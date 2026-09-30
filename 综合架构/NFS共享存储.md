# NFS 共享存储

## 一、基本概述

NFS（Network File System，网络文件系统）是 **Linux/Unix 系统最常用的轻量级网络共享协议**，基于 **RPC（远程过程调用）** 实现，允许不同主机通过 TCP/IP 网络共享文件和目录。客户端可像访问本地磁盘一样挂载远程 NFS 共享目录，是中小规模集群中**成本最低、部署最快**的共享存储方案。大型网站会用更复杂的分布式文件系统（Ceph、FastDFS、GlusterFS、HDFS）。

### 与其他共享存储对比
| 方案 | 优点 | 缺点 | 适用场景 |
| --- | --- | --- | --- |
| **NFS** | 部署简单、成本低、兼容性好 | 单点故障、性能依赖网络、安全性一般 | 中小规模集群、非核心业务 |
| Samba | 跨 Windows/Linux 共享 | 性能差、配置复杂 | 跨平台文件共享 |
| GlusterFS | 分布式、高可用、横向扩展 | 部署复杂、运维成本高 | 大规模集群、高并发读取 |
| Ceph | 统一存储（块/文件/对象）、高可用 | 极复杂、资源消耗大 | 大规模云环境、核心业务 |

### 为什么用 NFS
1. 实现多台服务器之间**数据共享**；
2. 实现多台服务器之间**数据一致**。

### 典型生产场景
- Web 集群**静态资源共享**（图片、CSS、JS、用户上传文件）；
- 应用集群**配置文件统一管理**；
- 日志**集中存储与分析**（ELK 直接采集 NFS 日志）；
- 数据**备份中转服务器**；
- CI/CD 流水线构建产物共享。

### 不适用场景
- 高并发随机写入（如数据库存储）；
- 强一致性和高可用的核心业务；
- 跨公网文件共享（延迟高、安全性差）。

![应用场景1](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-01.png)
![应用场景2](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-02.png)

---

## 二、实现原理（含常见错误纠正）

![原理图](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-03.png)

**本地文件操作**：用户执行 `mkdir` → shell 解释给内核 → 内核驱动硬件。

**NFS 实现原理**（先理解程序/进程/线程）：
1. 用户进程访问 NFS 客户端，用不同函数处理数据；
2. NFS 客户端通过 TCP/IP 把请求传给 NFS 服务端；
3. NFS 服务端接收请求后，先调用 portmap 做端口映射；
4. nfsd 进程判断客户端是否有权限连接；
5. rpc.mount 判断客户端是否有对应权限验证；
6. portmap 实现用户映射和压缩；
7. NFS 服务端把请求函数转成本地命令交内核驱动硬件。

> ⚠️ 上面这套说法**整体方向正确，但有多处核心错误和不严谨**，逐一纠正：

| 序号 | 原说法 | 错误 / 不严谨之处 |
| --- | --- | --- |
| 1 | "服务端接收请求后先调用 portmap 做端口映射" | **错**。Portmap 是**客户端先调用**的；服务端是**启动时主动向 Portmap 注册自己的端口**，接收请求后不会再调用 Portmap |
| 2 | "portmap 实现用户映射和压缩" | **错**。Portmap 唯一功能是**端口映射**；用户映射（root_squash）、权限压缩是 **nfsd** 的功能 |
| 3 | "nfsd 判断能否登录；rpc.mount 判断文件权限" | **顺序颠倒**。客户端先经 rpc.mount 验证**挂载权限**，通过后才能和 nfsd 通信；nfsd 负责**文件操作权限**和读写 |
| 4 | "nfsd/mountd/portmap 是 NFS 服务器调用的外部进程" | **架构错**。三者都是**运行在服务端的独立 RPC 服务进程**，共同组成 NFS，不是被某"总控"调用的子模块 |
| 5 | "NFS 服务端将请求转换命令传递给内核" | **不严谨**。Linux 下 nfsd 是**内核线程**（非用户态进程），直接和内核 VFS 交互 |
| 6 | 原理图把三个进程画在 NFS 服务器框外 | **架构错**。三进程都运行在服务端内核/用户态，属 NFS 一部分 |

![正确原理图](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-04.png)

### 前置说明
NFS 基于 RPC 的客户端-服务器架构，所有交互遵循 **"客户端先查 Portmap 找端口，再直接和对应服务通信"** 的 RPC 标准流程。

### 1. 服务端启动流程（先于任何客户端请求）
1. 启动 `rpcbind`（Portmap），监听**固定 111 端口**，等待 RPC 服务注册；
2. 启动 `rpc.mountd`，随机绑端口，向本地 rpcbind 注册：`(程序号100005, 版本3, TCP, 端口xxx)`；
3. 启动 `nfsd`（Linux 下为内核线程），绑定**固定 2049 端口**，向 rpcbind 注册：`(程序号100003, 版本3, TCP, 2049)`；
4. nfsd 读取 `/etc/exports`，加载共享目录和权限规则。

### 2. 客户端挂载流程（第一步）
客户端执行 `mount -t nfs server:/share /mnt`：
1. 客户端内核 NFS 模块向**服务端 111 端口**发 RPC："查程序号 100005（mountd）的 TCP 端口"；
2. 服务端 rpcbind 返回 mountd 端口（如 20048）；
3. 客户端连接 mountd，发 `MNT` RPC，携带要挂载的共享目录路径；
4. **rpc.mountd 读 `/etc/exports`**，验证客户端 IP 是否有权限挂载；
5. 验证通过，rpc.mountd 生成共享目录**根文件句柄（FH）**返回客户端；
6. 客户端本地挂载点 `/mnt` 建立 NFS 文件系统，保存根 FH 到内核。

### 3. 客户端文件操作流程（挂载完成后）
客户端执行 `cat /mnt/test.txt`：
1. 用户进程调用 `read()` 进入内核 VFS；
2. VFS 判断是 NFS 文件系统，调用内核 NFS 客户端模块函数；
3. NFS 客户端向**服务端 111 端口**发 RPC："查程序号 100003（nfsd）的 TCP 端口"；
4. rpcbind 返回 nfsd 端口 2049；
5. 客户端连 2049 发 `LOOKUP` RPC，携带**根 FH + 文件名 test.txt**；
6. **nfsd** 据 FH 找到本地文件，生成 test.txt 的 FH 返回；
7. 客户端发 `READ` RPC，携带 FH、偏移、长度；
8. **nfsd** 执行：① 验证操作权限 ② **用户映射**（root_squash：客户端 root 映射为服务端 nfsnobody）③ 调内核 VFS 读盘；
9. nfsd 序列化数据返回客户端；
10. 客户端 NFS 模块复制到用户空间，`read()` 返回。

### 关键补充澄清
1. **nfsd 身份**：Linux 下是**内核线程**（非用户态进程），是 NFS 性能高的重要原因，直接运行在内核态与 VFS/磁盘驱动交互。
2. **rpcbind 唯一作用**：就是"RPC 服务电话本"，只记"哪个 RPC 服务在哪个端口"，不参与权限验证和传输。
3. **权限两层结构**：第一层**挂载权限**（rpc.mountd 挂载时验证，决定能不能挂）；第二层**文件操作权限**（nfsd 每次操作时验证，决定能不能读写具体文件）。
4. **用户映射**：root_squash、all_squash 等都是 nfsd 功能，执行文件操作前按 `/etc/exports` 规则把客户端 UID/GID 替换为服务端 UID/GID。

---

## 三、实战操作

### 1. 环境准备
| 服务器系统 | 角色 | 外网IP | 内网IP |
| --- | --- | --- | --- |
| CentOS 7.5 | NFS 服务端 | eth0:10.0.0.31 | eth1:172.16.1.31 |
| CentOS 7.5 | NFS 客户端 | eth0:10.0.0.41 | eth1:172.16.1.41 |

> 注意：关闭防火墙，避免默认策略禁止 NFS 共享。

```bash
# 关闭 Firewalld
systemctl disable firewalld && systemctl stop firewalld
# 关闭 SELinux
sed -ri '#^SELINUX=#cSELINUX=Disabled' /etc/selinux/config
setenforce 0
```

### 2. 服务端配置
```bash
# 1. 安装
yum -y install nfs-utils

# 2. /etc/exports 格式：共享目录  客户端地址(参数1,参数2,...)
# 例：把 /data 共享给 172.16.1.0/24，要求：读写 / 写入硬盘后返回 / 全部映射为匿名用户
cat > /etc/exports <<EOF
/data 172.16.1.0/24(rw,sync,all_squash)
EOF

# 3. 创建目录
mkdir /data

# 4. 启动并开机自启
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server

# 5. 检查端口
netstat -lntp

# 6. 检查共享内容
cat /var/lib/nfs/etab
exportfs -arv

# 7. 授权共享目录为 nfsnobody
grep "65534" /etc/passwd
chown -R nfsnobody.nfsnobody /data
```

### 3. 客户端配置
```bash
# 8. 安装（只需安装工具，无需启动服务）
yum install nfs-utils -y
systemctl enable rpcbind && systemctl start rpcbind

# 查看服务端共享
showmount -e 172.16.1.31
# Export list for 172.16.1.31:
# /data 172.16.1.0/24

# 9. 创建挂载点并挂载
mkdir /data
mount -t nfs 172.16.1.31:/data /data/
df -h
# 172.16.1.31:/data   50G  2.6G  48G   6% /data

# 10. 测试写入
echo "123" > /data/test

# 11. 卸载
umount /data/

# 12. 服务端查看数据
ll /data/
```

**作业**
1. 将机器还原；
2. 准备 2 台 web 挂载至 NFS；
3. 模拟 A 写、B 删。

> NFS 结束后接「实时同步」。

---

## 四、核心配置参数详解

`man exports` 可查样例。常用权限选项：

| 参数 | 作用 |
| --- | --- |
| `rw`（常用） | 读写权限 |
| `ro` | 只读权限 |
| `root_squash`（默认） | 客户端用 root 访问时映射为服务端匿名用户（nfsnobody） |
| `no_root_squash` | 客户端 root 访问时映射为服务端 root（**不安全**） |
| `all_squash`（常用） | 无论客户端用什么账户，都映射为服务端匿名用户 |
| `no_all_squash` | 不压缩账户 |
| `sync`（生产必须） | 同时写入内存与硬盘，保证不丢数据 |
| `async` | 先写内存再刷盘，效率高但可能丢数据 |
| `anonuid`/`anongid` | 配合 all_squash 指定匿名用户的 UID/GID（必须系统存在） |
| `secure` | 通过 1024 以下安全端口发送 |
| `insecure` | 通过 1024 以上端口发送（Docker volume 常需） |
| `wdelay` | 多个用户写目录时归组写入（默认） |
| `no_wdelay` | 立即写入（配 async 时无需） |
| `hide`/`no_hide` | 是否不共享/共享子目录 |
| `subtree_check`/`no_subtree_check` | 是否检查父目录权限 |

---

## 五、面试必备知识点

### 核心概念
1. **文件句柄（FH）**：NFS 中文件唯一标识，含 `fsid(文件系统ID)+inode号+生成号`。是 NFS 无状态设计核心，每个请求自带 FH，服务端无需保存客户端状态。
2. **无状态设计**：服务端不保存客户端会话状态，每个请求独立完整。优点：故障恢复快；缺点：不支持原生文件锁、一致性弱。
3. **Stub/Skeleton（RPC 代理层）**：Stub（客户端存根）伪装成本地函数封装网络请求；Skeleton（服务端骨架）接收请求分发到真实业务函数。
4. **rpcbind（Portmap）唯一作用**：RPC 服务"电话本"，记录"程序号→端口号"映射；客户端先查 111 端口拿目标端口再直接通信。

### 版本对比（生产选型核心）
| 对比项 | NFSv3 | NFSv4（生产推荐） |
| --- | --- | --- |
| 端口 | 111+2049+随机端口 | 仅固定 2049/tcp |
| 依赖 | rpcbind+mountd+nlm | 无依赖 |
| 协议状态 | 无状态 | 有状态（混合设计） |
| 锁机制 | 独立 NLM 协议 | 原生集成 |
| 挂载方式 | 挂载实际目录 `/data` | 挂载伪根 `/`（fsid=0） |
| 性能 | 一般（多次 RPC 往返） | 更高（复合 RPC 批量） |
| 安全 | 仅 IP 认证 | 支持 Kerberos 强认证 |

### 权限机制
1. **root_squash（默认开启）**：客户端 root（UID=0）映射为服务端 nfsnobody；安全必备，防客户端 root 拿到服务端 root 权限。
2. **all_squash**：所有客户端用户都映射为 nfsnobody；适合公共共享目录统一权限。
3. **sync vs async**：`sync`（生产必须）写盘后才返回，无丢失风险；`async` 先写内存再刷盘，性能好但断电丢数据。

---

## 六、NFSv3 与 NFSv4 工作过程对比

![架构对比图](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-05.png)

### 一、NFSv3 工作过程
1. **端口查询**：客户端连服务端 111，向 rpcbind 查 **mountd/statd/lockd 随机端口**（⚠️ nfsd 固定 2049，不是随机的）。
2. **挂载验证**：客户端连 mountd，查 `/etc/exports` 的 IP 白名单，通过返回根 FH。
3. **文件 IO**：客户端连 nfsd(2049) 发独立 RPC 处理读写；**文件锁需单独调 nlm，状态恢复需单独调 statd**。

> 特点：无状态，每请求独立；多服务多端口，防火墙难配；性能较低（多次往返）。

### 二、NFSv4 工作过程
1. **直接连接**：客户端直连服务端固定 2049，**无需 rpcbind 端口映射**。
2. **伪根挂载**：通过**复合 RPC**（一个请求含多个操作）获取服务端伪根（fsid=0）FH。⚠️ 这就是 v4 挂载路径必须写 `/` 而不是 `/data` 的原因。
3. **全功能处理**：挂载、读写、锁、权限验证、状态管理都经 2049 复合 RPC 完成，**无需单独调用任何外部服务**。

> 特点：有状态（会话跟踪）；单端口单服务，防火墙只需开 2049/tcp；性能更高（复合 RPC 减少 70%+ 网络往返）。

> NFSv4 不是"完全有状态"，而是**精心设计混合架构**：在锁/打开文件/委托/会话这些必须有状态处引入状态；在基础 IO 这些不需要状态处保持无状态的简单可靠。这正是它成为企业级标准的原因。

---

## 七、其他实用配置

### 开机自动挂载（fstab）
```bash
# vim /etc/fstab
172.16.1.31:/data /nfsdir nfs defaults 0 0
```

### 安全挂载（禁止 suid/exec）
企业场景 NFS 通常只共享静态数据（图片/附件/视频），不应执行程序，增加安全性（防木马上传后执行）：
```bash
mount -t nfs -o nosuid,noexec,nodev 172.16.1.31:/data /mnt
```

### 性能挂载（禁止更新时间戳）
```bash
mount -t nfs -o noatime,nodiratime 172.16.1.31:/data /mnt
```

### Docker volume 挂载 NFS 失败
修改 NFS 配置（Docker 常经 1024 以上端口）：
```plain
/data/nfs 192.168.0.0/16(rw,insecure,sync,no_subtree_check,no_root_squash)
```

### 验证权限
```bash
# 1. 验证 ro（只读）
# 服务端 /etc/exports
/data 172.16.1.0/24(ro,sync,all_squash)
systemctl restart nfs-server
# 客户端
mount -t nfs 172.16.1.31:/data /mnt
touch /mnt/file
# touch: cannot touch 'file': Read-only file system

# 2. 验证 all_squash + anonuid/anongid
# 服务端
/data 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
groupadd -g 666 www && useradd -u 666 -g 666 www
systemctl restart nfs-server
chown -R www.www /data/
# 客户端重新挂载后，写入文件属主显示 666；
# 建议客户端也建 uid/gid=666 的 www，避免权限不一致
groupadd -g 666 www && useradd -g 666 -u 666 www
```

---

## 八、NFS 存储小结

**优点**
1. 简单易用、部署方便、数据可靠、服务稳定，满足中小企业需求；
2. 数据都在文件系统之上，看得见、好管理。

**局限**
1. 存在单点故障，构建高可用维护麻烦；
2. 数据明文，不做任何校验；
3. 客户端挂载无需账号密码，安全性一般（内网使用）。

**生产建议**
1. 静态数据尽可能往前端推，减少后端存储压力；
2. 存储里的静态资源通过 CDN 缓存（jpg/png/mp4/avi/css/js）；
3. 没有缓存或架构历史问题太大，加再多存储也无用。

### 报错：Stale file handle（过期文件句柄）
```bash
mount -t nfs 172.16.1.31:/data /data/
# mount.nfs: Stale file handle
```
> 原因：客户端未卸载的情况下，服务端把该目录移除了。解决：客户端 `umount` 后再重新挂载。

![小结图1](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-06.png)
![小结图2](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-07.png)

---

## 九、常见面试题

1. **NFS 基于什么协议？为什么需要 rpcbind？**
   基于 RPC。NFS 各服务端口不固定（v3 下 mountd 随机端口），rpcbind 在 111 端口做"程序号→端口"的映射；客户端先查 rpcbind 拿到端口再直连。NFSv4 只用固定 2049，不再依赖 rpcbind。

2. **NFS 的权限为什么常配 all_squash / root_squash？**
   防止客户端 root 在共享目录里拿到服务端 root 权限；把所有访问统一映射为匿名用户（nfsnobody），统一权限、更安全。

3. **rpc.mountd 和 nfsd 分别负责什么？**
   rpc.mountd 在挂载时验证客户端 IP 是否允许挂（第一层挂载权限）；nfsd 负责实际文件读写操作和每次的文件操作权限验证（第二层）。

4. **NFSv3 和 NFSv4 主要区别？生产选哪个？**
   v3 多端口需 rpcbind、无状态、性能一般；v4 仅 2049、有状态（混合）、复合 RPC 性能更高、支持 Kerberos。生产推荐 **NFSv4**。

5. **NFSv4 挂载路径为什么写 `/` 而不是 `/data`？**
   因为 v4 使用"伪根"挂载（fsid=0），客户端先拿到伪根 FH，再通过复合 RPC 访问实际目录。

6. **Stale file handle 怎么处理？**
   客户端 `umount` 后重新 `mount` 即可，通常是服务端在客户端未卸载时移除了共享目录。

7. **生产挂载 NFS 为什么要加 nosuid,noexec？**
   共享目录只存静态数据，禁止在挂载点执行程序，防止木马上传后被运行。

---

> 更新：2026-05-01 16:07:27
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/tk8gl5>
