# NFS 共享存储

# NFS基本概述

NFS（Network File System，网络文件系统）是\*\*<font style="background-color:rgba(0, 0, 0, 0);">Linux/Unix 系统最常用的轻量级网络共享协议</font>\*\*

基于 RPC（远程过程调用）实现，允许不同主机通过 TCP/IP 网络共享文件和目录。客户端可以像访问本地磁盘一样挂载和使用远程 NFS 共享目录，是中小规模集群环境中成本最低、部署最快的共享存储方案。如果是大型网站, 会用到更复杂的分布式文件系统 ceph,FastDFS,glusterfs,HDFS

## 与其他共享存储对比

| 方案 | 优点 | 缺点 | 适用场景 |
| --- | --- | --- | --- |
| NFS | 部署简单、成本低、兼容性好、使用方便 | 单点故障、性能依赖网络、安全性一般 | 中小规模集群、非核心业务 |
| Samba | 支持 Windows/Linux 跨平台共享 | 性能差、配置复杂 | 跨平台文件共享 |
| GlusterFS | 分布式、高可用、横向扩展 | 部署复杂、运维成本高 | 大规模集群、高并发读取 |
| Ceph | 统一存储（块 / 文件 / 对象）、高可用 | 极其复杂、资源消耗大 | 大规模云环境、核心业务 |

为什么要使用NFS服务进行数据存储

1.实现多台服务器之间数据共享

2.实现多台服务器之间数据的一致

# NFS应用场景

![1547285149676-07979dba-7088-4df3-893d-0b8a1ad5a678-image1.png](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-01.png)

![1547285149740-e6ced790-ce46-4005-98bb-b0e2f4ed9173-image2.png](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-02.png)

## 典型生产场景

* <font style="background-color:rgba(0, 0, 0, 0);">Web 集群</font>**<font style="background-color:rgba(0, 0, 0, 0);">静态资源共享</font>**<font style="background-color:rgba(0, 0, 0, 0);">（图片、CSS、JS、用户上传文件）</font>
* <font style="background-color:rgba(0, 0, 0, 0);">应用集群</font>**<font style="background-color:rgba(0, 0, 0, 0);">配置文件统一管理</font>**
* <font style="background-color:rgba(0, 0, 0, 0);">日志</font>**<font style="background-color:rgba(0, 0, 0, 0);">集中存储与分析</font>**<font style="background-color:rgba(0, 0, 0, 0);">（ELK 直接采集 NFS 日志）</font>
* <font style="background-color:rgba(0, 0, 0, 0);">数据</font>**<font style="background-color:rgba(0, 0, 0, 0);">备份中转服务器</font>**
* <font style="background-color:rgba(0, 0, 0, 0);">CI/CD 流水线</font>**<font style="background-color:rgba(0, 0, 0, 0);">构建产物共享</font>**

## <font style="background-color:rgba(0, 0, 0, 0);">不适用场景</font>

* <font style="background-color:rgba(0, 0, 0, 0);">高并发随机写入场景（如数据库存储）</font>
* <font style="background-color:rgba(0, 0, 0, 0);">要求强一致性和高可用的核心业务</font>
* <font style="background-color:rgba(0, 0, 0, 0);">跨公网的文件共享（延迟高、安全性差）</font>

# NFS实现原理

![1547285149775-be4f6b4e-1330-4b0d-8358-b734478d4d00-image3.png](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-03.png)

本地文件操作方式

1.当用户执行mkdir命令, 该命令会通过shell解释器翻译给内核,由内核解析完成后驱动硬件，完成相应的操作。

NFS实现原理(需要先了解\[程序|进程|线程])

1.用户进程访问NFS客户端，使用不同的函数对数据进行处理

2.NFS客户端通过TCP/IP的方式传递给NFS服务端。

3.NFS服务端接收到请求后，会先调用portmap进程进行端口映射。

4.nfsd进程用于判断NFS客户端是否拥有权限连接NFS服务端。

5.Rpc.mount进程判断客户端是否有对应的权限进行验证。

6.protmap进程实现用户映射和压缩

7.最后NFS服务端会将对应请求的函数转换为本地能识别的命令，传递至内核，由内核驱动硬件。

rpc是一个远程过程调用，那么使用nfs必须有rpc服务

# 上面说法 整体方向正确，但存在多个核心原理错误和不严谨的地方

| 序号 | 原说法 | 错误 / 不严谨之处 |
| --- | --- | --- |
| 1 | "NFS 服务端接收到请求后，会先调用 portmap 进程进行端口映射" | **完全错误**。Portmap 是**客户端先调用**的，服务端是**启动时主动向 Portmap 注册自己的端口**，服务端接收到请求后根本不会调用 Portmap |
| 2 | "protmap 进程实现用户映射和压缩" | **完全错误**。Portmap 唯一的功能就是**端口映射**，用户映射（root_squash）、权限压缩是**nfsd 进程**的核心功能 |
| 3 | "nfsd 进程用于判断客户端是否能够登录服务器；rpc.mount 判断文件权限" | **顺序颠倒**。客户端先通过 rpc.mount 验证**挂载权限**，通过后才能和 nfsd 通信；nfsd 负责**文件操作权限**和实际的文件读写 |
| 4 | "nfsd、mountd、portmap 是 NFS 服务器调用的外部进程" | **架构错误**。这三个都是**运行在服务端的独立 RPC 服务进程**，共同组成 NFS 服务，不是被某个 "总控 NFS 服务器" 调用的子模块 |
| 5 | "NFS 服务端将请求转换为本地能识别的命令，传递至内核" | **不严谨**。Linux 下的 nfsd 是**内核线程**（不是用户态进程），它直接和内核 VFS 层交互，不需要 "转换命令传递给内核" |
| 6 | 原理图中三个进程画在 NFS 服务器框外 | **架构错误**。三个进程都运行在服务端内核 / 用户态，属于 NFS 服务的一部分 |

![1777517973781-97ea424d-dfca-4f51-86c3-be726e80a18b.png](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-04.png)

### <font style="background-color:rgba(0, 0, 0, 0);">前置说明</font>

<font style="background-color:rgba(0, 0, 0, 0);">NFS 是基于 RPC 的客户端 - 服务器架构，所有交互都遵循 "</font>**<font style="background-color:rgba(0, 0, 0, 0);">客户端先查 Portmap 找端口，再直接和对应服务通信</font>**<font style="background-color:rgba(0, 0, 0, 0);">" 的 RPC 标准流程。</font>

### <font style="background-color:rgba(0, 0, 0, 0);">1. 服务端启动流程（先于任何客户端请求）</font>

1. <font style="background-color:rgba(0, 0, 0, 0);">系统启动</font><code><font style="background-color:rgba(0, 0, 0, 0);">rpcbind</font></code><font style="background-color:rgba(0, 0, 0, 0);">（Portmap）服务，监听</font>**<font style="background-color:rgba(0, 0, 0, 0);">固定 111 端口</font>**<font style="background-color:rgba(0, 0, 0, 0);">，等待 RPC 服务注册</font>
2. <font style="background-color:rgba(0, 0, 0, 0);">启动</font><code><font style="background-color:rgba(0, 0, 0, 0);">rpc.mountd</font></code><font style="background-color:rgba(0, 0, 0, 0);">服务，随机绑定一个端口，向本地 rpcbind 注册自己的信息：</font><code><font style="background-color:rgba(0, 0, 0, 0);">(程序号100005, 版本3, TCP, 端口xxx)</font></code>
3. <font style="background-color:rgba(0, 0, 0, 0);">启动</font><code><font style="background-color:rgba(0, 0, 0, 0);">nfsd</font></code><font style="background-color:rgba(0, 0, 0, 0);">服务（Linux 下是内核线程），绑定</font>**<font style="background-color:rgba(0, 0, 0, 0);">固定 2049 端口</font>**<font style="background-color:rgba(0, 0, 0, 0);">，向本地 rpcbind 注册自己的信息：</font><code><font style="background-color:rgba(0, 0, 0, 0);">(程序号100003, 版本3, TCP, 2049)</font></code>
4. <font style="background-color:rgba(0, 0, 0, 0);">nfsd 读取</font><code><font style="background-color:rgba(0, 0, 0, 0);">/etc/exports</font></code><font style="background-color:rgba(0, 0, 0, 0);">配置文件，加载共享目录和权限规则</font>

### <font style="background-color:rgba(0, 0, 0, 0);">2. 客户端挂载 NFS 共享流程（第一步）</font>

<font style="background-color:rgba(0, 0, 0, 0);">当客户端执行</font><code><font style="background-color:rgba(0, 0, 0, 0);">mount -t nfs server:/share /mnt</font></code><font style="background-color:rgba(0, 0, 0, 0);">时：</font>

1. <font style="background-color:rgba(0, 0, 0, 0);">客户端内核的 NFS 模块向</font>**<font style="background-color:rgba(0, 0, 0, 0);">服务端的 111 端口</font>**<font style="background-color:rgba(0, 0, 0, 0);">发送 RPC 请求："查询程序号 100005（mountd）的 TCP 端口"</font>
2. <font style="background-color:rgba(0, 0, 0, 0);">服务端 rpcbind 返回 mountd 的端口号（如 20048）</font>
3. <font style="background-color:rgba(0, 0, 0, 0);">客户端连接服务端的 mountd 端口，发送</font><code><font style="background-color:rgba(0, 0, 0, 0);">MNT</font></code><font style="background-color:rgba(0, 0, 0, 0);"> RPC 请求，携带要挂载的共享目录路径</font>
4. **<font style="background-color:rgba(0, 0, 0, 0);">rpc.mountd 读取 /etc/exports</font>**<font style="background-color:rgba(0, 0, 0, 0);">，验证客户端 IP 是否有权限挂载该共享目录</font>
5. <font style="background-color:rgba(0, 0, 0, 0);">验证通过后，rpc.mountd 生成该共享目录</font>**<font style="background-color:rgba(0, 0, 0, 0);">根目录的文件句柄（FH）</font>**<font style="background-color:rgba(0, 0, 0, 0);">，返回给客户端</font>
6. <font style="background-color:rgba(0, 0, 0, 0);">客户端在本地挂载点</font><code><font style="background-color:rgba(0, 0, 0, 0);">/mnt</font></code><font style="background-color:rgba(0, 0, 0, 0);">建立 NFS 文件系统，将根文件句柄保存到内核中</font>

### <font style="background-color:rgba(0, 0, 0, 0);">3. 客户端文件操作流程（挂载完成后）</font>

<font style="background-color:rgba(0, 0, 0, 0);">当客户端执行</font><code><font style="background-color:rgba(0, 0, 0, 0);">cat /mnt/test.txt</font></code><font style="background-color:rgba(0, 0, 0, 0);">时：</font>

1. <font style="background-color:rgba(0, 0, 0, 0);">用户进程调用</font><code><font style="background-color:rgba(0, 0, 0, 0);">read()</font></code><font style="background-color:rgba(0, 0, 0, 0);">系统调用，进入内核 VFS 层</font>
2. <font style="background-color:rgba(0, 0, 0, 0);">VFS 判断这是 NFS 文件系统，调用内核 NFS 客户端模块的对应函数</font>
3. <font style="background-color:rgba(0, 0, 0, 0);">NFS 客户端向</font>**<font style="background-color:rgba(0, 0, 0, 0);">服务端的 111 端口</font>**<font style="background-color:rgba(0, 0, 0, 0);">发送 RPC 请求："查询程序号 100003（nfsd）的 TCP 端口"</font>
4. <font style="background-color:rgba(0, 0, 0, 0);">服务端 rpcbind 返回 nfsd 的端口号 2049</font>
5. <font style="background-color:rgba(0, 0, 0, 0);">客户端连接服务端的 2049 端口，发送</font><code><font style="background-color:rgba(0, 0, 0, 0);">LOOKUP</font></code><font style="background-color:rgba(0, 0, 0, 0);"> RPC 请求，携带</font>**<font style="background-color:rgba(0, 0, 0, 0);">根文件句柄 + 文件名 test.txt</font>**
6. **<font style="background-color:rgba(0, 0, 0, 0);">nfsd 进程</font>**<font style="background-color:rgba(0, 0, 0, 0);">根据文件句柄找到本地文件，生成 test.txt 的文件句柄返回给客户端</font>
7. <font style="background-color:rgba(0, 0, 0, 0);">客户端发送</font><code><font style="background-color:rgba(0, 0, 0, 0);">READ</font></code><font style="background-color:rgba(0, 0, 0, 0);"> RPC 请求，携带 test.txt 的文件句柄、偏移量、读取长度</font>
8. **<font style="background-color:rgba(0, 0, 0, 0);">nfsd 进程</font>**<font style="background-color:rgba(0, 0, 0, 0);">执行以下操作：</font>
   * <font style="background-color:rgba(0, 0, 0, 0);">验证客户端对该文件的操作权限</font>
   * <font style="background-color:rgba(0, 0, 0, 0);">执行</font>**<font style="background-color:rgba(0, 0, 0, 0);">用户映射</font>**<font style="background-color:rgba(0, 0, 0, 0);">（如 root_squash：将客户端 root 用户映射为服务端 nfsnobody）</font>
   * <font style="background-color:rgba(0, 0, 0, 0);">调用内核 VFS 层读取本地磁盘文件</font>
9. <font style="background-color:rgba(0, 0, 0, 0);">nfsd 将读取到的数据序列化后返回给客户端</font>
10. <font style="background-color:rgba(0, 0, 0, 0);">客户端 NFS 模块将数据复制到用户空间，</font><code><font style="background-color:rgba(0, 0, 0, 0);">read()</font></code><font style="background-color:rgba(0, 0, 0, 0);">系统调用返回</font>

## <font style="background-color:rgba(0, 0, 0, 0);">关键补充澄清</font>

1. **<font style="background-color:rgba(0, 0, 0, 0);">关于 nfsd 的身份</font>**<font style="background-color:rgba(0, 0, 0, 0);">：Linux 下 nfsd 是</font>**<font style="background-color:rgba(0, 0, 0, 0);">内核线程</font>**<font style="background-color:rgba(0, 0, 0, 0);">（不是用户态进程），这是 NFS 性能高的重要原因，它直接运行在内核态，和 VFS、磁盘驱动无缝交互。</font>
2. **<font style="background-color:rgba(0, 0, 0, 0);">关于 rpcbind 的唯一作用</font>**<font style="background-color:rgba(0, 0, 0, 0);">：它就是一个 "RPC 服务电话本"，只负责记录 "哪个 RPC 服务在哪个端口"，除此之外不做任何其他事情，不参与任何权限验证和数据传输。</font>
3. **<font style="background-color:rgba(0, 0, 0, 0);">关于权限验证的两层结构</font>**<font style="background-color:rgba(0, 0, 0, 0);">：</font>
   * <font style="background-color:rgba(0, 0, 0, 0);">第一层：</font>**<font style="background-color:rgba(0, 0, 0, 0);">挂载权限</font>**<font style="background-color:rgba(0, 0, 0, 0);">，由 rpc.mountd 在挂载时验证，决定客户端能不能挂载这个共享目录</font>
   * <font style="background-color:rgba(0, 0, 0, 0);">第二层：</font>**<font style="background-color:rgba(0, 0, 0, 0);">文件操作权限</font>**<font style="background-color:rgba(0, 0, 0, 0);">，由 nfsd 在每次文件操作时验证，决定客户端能不能读 / 写这个具体的文件</font>
4. **<font style="background-color:rgba(0, 0, 0, 0);">关于用户映射</font>**<font style="background-color:rgba(0, 0, 0, 0);">：root_squash、all_squash 等都是 nfsd 的功能，它会在执行文件操作前，将 RPC 请求中携带的客户端 UID/GID，按照 /etc/exports 的规则替换成服务端的 UID/GID</font>

<font style="background-color:rgba(0, 0, 0, 0);"></font>

<font style="background-color:rgba(0, 0, 0, 0);"></font>

<font style="background-color:rgba(0, 0, 0, 0);"></font>

# 实战操作：

## 1.环境准备

| **服务器系统** | **角色** | **外网IP** | **内网IP** |
| --- | --- | --- | --- |
| CentOS 7.5 | NFS服务端 | eth0:10.0.0.31 | eth1:172.16.1.31 |
| CentOS 7.5 | NFS客户端 | eth0:10.0.0.41 | eth1:172.16.1.41 |

注意: 不要忘记关闭防火墙, 以免默认的防火墙策略禁止正常的NFS共享服务

```bash
#关闭Firewalld防火墙
systemctl disable firewalld
systemctl stop firewalld

#关闭selinux防火墙
sed -ri '#^SELINUX=#cSELINUX=Disabled' /etc/selinux/config
setenforce 0
```

```bash
1.安装nfs
yum -y install nfs-utils
2.配置nfs
我们可以按照共享目录的路径 允许访问的NFS客户端（共享权限参数）格式，定义要共享的目录与相应的权限。
exports配置文件格式
/data 172.16.1.0/24(rw,sync,all_squash)
NFS共享目录 NFS客户端地址1(参数1,参数2,...) 客户端地址2(参数1,参数2,...) 
NFS共享目录 NFS客户端地址(参数1,参数2,...)
如果想要把/data目录共享给172.16.1.0/24网段内的所有主机 
  1.主机都拥有读写权限 
  2.在将数据写入到NFS服务器的硬盘中后才会结束操作，最大限度保证数据不丢失 
  3.将所有用户映射为本地的匿名用户(nfsnobody)

cat > /etc/exports <<EOF
/data 172.16.1.0/24(rw,sync,all_squash)
EOF

# 3.创建对应的目录
mkdir /data
# 4.启动服务，并将服务加入开机自启动
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server
# 5.检查端口
netstat -lntp

# 6检查共享的内容
cat /var/lib/nfs/etab

#这个也可以检查配置文件
exportfs -arv

# 7.检查匿名用户对应的真实账户,并授权共享目录为nfsnobody
grep "65534" /etc/passwd
chown -R nfsnobody.nfsnobody /data

# 8.配置客户端
yum install nfs-utils -y
systemctl enable rpcbind
systemctl start rpcbind

# showmount -e 172.16.1.31
Export list for 172.16.1.31:
/data 172.16.1.0/24

# 9.配置客户端-创建挂载点目录，执行挂载命令
mkdir /data
mount -t nfs 172.16.1.31:/data /data/
# df -h
文件系统                 容量  已用  可用 已用% 挂载点
172.16.1.31:/data         50G  2.6G   48G    6% /data

# 10.测试客户端是否拥有写的权限
echo "123" > /data/test


11.卸载本地客户端的挂载信息
umount /data/
# ll /data/


12.检查nfs客户端是否存在数据 #服务端查看
# ll /data/



作业：
   1.将所有的机器还原
   2.准备2台web挂载至nfs服务
   3.模拟a写，b删

nfs结束，实时同步


```

## 核心配置参数详解

执行man exports命令，然后切换到文件结尾，可以快速查看如下样例格式：

<code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/etc/exports</font></code> 常用权限选项

| **nfs共享参数** | **参数作用** |
| --- | --- |
| rw\* | 读写权限 |
| ro | 只读权限 |
| root_squash | 当NFS客户端以root管理员访问时，映射为NFS服务器的匿名用户(不常用) |
| no_root_squash | 当NFS客户端以root管理员访问时，映射为NFS服务器的root管理员(不常用) |
| all_squash | 无论NFS客户端使用什么账户访问，均映射为NFS服务器的匿名用户(常用) |
| no_all_squash | 无论NFS客户端使用什么账户访问，都不进行压缩 |
| sync\* | 同时将数据写入到内存与硬盘中，保证不丢失数据 |
| async | 优先将数据保存到内存，然后再写入硬盘；这样效率更高，但可能会丢失数据 |
| anonuid\* | 配置all_squash使用,指定NFS的用户UID,必须存在系统 |
| <font style="background-color:#FFFFFF;">secure </font> | <font style="background-color:#FFFFFF;"> </font><font style="background-color:#FFFFFF;">NFS通过1024以下的安全TCP/IP端口发送 </font> |
| insecure  | NFS通过1024以上的端口发送  |
|  wdelay  | 如果多个用户要写入NFS目录，则归组写入（默认） |
|  no_wdelay | 如果多个用户要写入NFS目录，则立即写入，当使用async时，无需此设置 |
|  Hide | 在NFS共享目录中不共享其子目录  |
|  no_hide   | 共享NFS目录的子目录  |
| <font style="background-color:#FFFFFF;">subtree_check  </font><font style="background-color:#FFFFFF;"> </font> | 如果共享/usr/bin之类的子目录时，强制NFS检查父目录的权限（默认）  |
| no_subtree_check | <font style="background-color:#FFFFFF;">和上面相对，不检查父目录权限 </font> |

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">面试必备知识点</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 核心概念必问</font>

1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">文件句柄（FH）</font>**
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">答案：NFS 中文件的唯一标识，包含</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">fsid(文件系统ID)+inode号+生成号</font></code>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">意义：是 NFS 无状态设计的核心，每个请求自带 FH，服务端无需保存客户端状态</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无状态设计</font>**
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">答案：服务端不保存任何客户端的会话状态，每个请求独立完整</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">优点：故障恢复快，服务端重启后客户端只需重试请求</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">缺点：不支持原生文件锁，一致性弱</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Stub/Skeleton</font>**
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">答案：RPC 的代理层</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Stub（客户端存根）：伪装成本地函数，封装网络请求</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Skeleton（服务端骨架）：接收网络请求，分发到真实业务函数</font>
4. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">rpcbind（Portmap）的唯一作用</font>**
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">答案：RPC 服务的 "电话本"，记录 "程序号→端口号" 的映射关系</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">客户端先查 111 端口获取目标服务端口，再直接通信</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 版本对比必问（生产选型核心）</font>

| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">对比项</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">NFSv3</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">NFSv4（生产推荐）</font> |
| --- | --- | --- |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">端口</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">111+2049 + 随机端口</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">仅固定 2049/tcp</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">依赖服务</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">rpcbind+mountd+nlm</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无任何依赖</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">协议状态</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无状态</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">有状态</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">锁机制</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">独立 NLM 协议</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">原生集成</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">挂载方式</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">挂载实际目录 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/data</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">挂载伪根 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/</font></code> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">性能</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">一般（多次 RPC 往返）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">更高（复合 RPC 批量操作）</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">安全</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">仅 IP 认证</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">支持 Kerberos 强认证</font> |

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 权限机制必问</font>

1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">root_squash（默认开启）</font>**
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">答案：将客户端 root 用户（UID=0）映射为服务端的 nfsnobody 用户</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">意义：安全必备，防止客户端 root 拥有服务端 root 权限</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">all_squash</font>**
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">答案：将所有客户端用户都映射为 nfsnobody</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">适用场景：公共共享目录，统一权限</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">sync vs async</font>**
   * <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">sync</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（生产必须）：数据写入磁盘后才返回成功，无数据丢失风险</font>
   * <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">async</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：先写入内存再刷盘，性能高但断电丢数据</font>

# 新装系统 <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">禁用 NFSv3，只保留 NFSv4(推荐)</font>

```bash
# 现卸载了在安装
yum remove nfs-utils
# 安装nfs-utils
yum install -y nfs-utils


vim /etc/exports
/data/  10.0.0.0/24(rw,sync,no_subtree_check,no_root_squash,fsid=0)

#检查
exportfs -r

vi /etc/nfs.conf
 # 找到 [nfsd] 区域，修改成下面这样
[nfsd]
vers2=n
vers3=n
vers4=y
vers4.0=y
vers4.1=y
vers4.2=y
tcp=y
udp=n

# echo 'RPCNFSDARGS="-N 2 -N 3 -U" ' /etc/sysconfig/nfs
# echo "MOUNTD_NFS_V3=no" >> /etc/sysconfig/nfs
# 3.创建对应的目录

mkdir /data
# 4.启动服务，并将服务加入开机自启动
systemctl enable  nfs-server
systemctl start  nfs-server
# 5.检查端口
netstat -lntp


# 检查确认是不是只有v4版本
cat /proc/fs/nfsd/versions
rpcinfo -p | grep nfs

#客户端挂载， 
#yum install nfs-utils -y  只需要安装就可以，不用启动任何服务
mount -t nfs -o vers=4.2 服务器IP:/共享目录 /本地挂载点
mount -t nfs -o vers=4.2,tcp 10.0.0.5:/ /data/

```

# nfs-v3 v4  架构图对比

![1777622196136-4fc5a721-0e2a-4e39-b630-3fd07c426fa8.png](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-05.png)

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">一、NFSv3 工作过程</font>

1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">端口查询</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：客户端先连服务端 111 端口，向 rpcbind 查询</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">mountd、statd、lockd 的随机端口</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">⚠️</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> nfsd 端口固定为 2049，不是随机的）</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">挂载验证</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：客户端连接 mountd，</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">检查 /etc/exports 中的 IP 白名单权限</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，验证通过后返回根文件句柄</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">文件 IO</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：客户端连接 nfsd (2049)，发送独立 RPC 请求处理读写；</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">文件锁需单独调用 nlm 服务，状态恢复需单独调用 statd 服务</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">特点</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：无状态协议，每个请求独立；多服务多端口，防火墙难配置；</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">性能较低（多次 RPC 往返）</font>**

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">二、NFSv4 工作过程</font>

1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">直接连接</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：客户端直接连服务端固定 2049 端口，</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无需 rpcbind 端口映射</font>**
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">伪根挂载</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：通过</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">复合 RPC</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（一个请求包含多个操作）获取服务端伪根 (fsid=0) 文件句柄</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">⚠️</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 这就是 v4 挂载路径必须写</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">而不是</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/data</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">的根本原因</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">全功能处理</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：所有操作（挂载、读写、锁、权限验证、状态管理）都通过 2049 端口的复合 RPC 完成，</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无需单独调用任何外部服务</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">特点</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：有状态协议，服务端跟踪会话；单端口单服务，防火墙仅需开放 2049/tcp；</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">性能更高（复合 RPC 减少 70% 以上网络往返）</font>**

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">NFSv4 不是 "完全有状态"，而是一种</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">精心设计的混合架构</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">它在</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">锁、打开文件、委托、会话</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">这些必须有状态的地方引入了状态</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">它在</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">基础 IO 操作</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">这些不需要状态的地方保持了无状态的简单性和可靠性</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">这种设计既保留了 NFSv3 无状态协议的优点，又解决了它的核心缺点，是 NFSv4 成为现代企业级文件共享标准的根本原因</font>

# 其他:

## 如果希望NFS文件共享服务能一直有效，则需要将其写入到fstab文件中

```bash
# vim /etc/fstab
172.16.1.31:/data /nfsdir nfs defaults 0 0
```

## 在企业工作场景，通常情况NFS服务器共享的只是普通静态数据（图片、附件、视频），不需要执行suid、exec等权限，挂载的这个文件系统只能作为数据存取之用，无法执行程序，对于客户端来讲增加了安全性。例如: 很多木马篡改站点文件都是由上传入口上传的程序到存储目录。然后执行的。

```bash
通过mount -o指定挂载参数，禁止使用suid，exec，增加安全性能
[root@nfs-client ~]# mount -t nfs -o nosuid,noexec,nodev 172.16.1.31:/data /mnt
```

## 有时也需要考虑性能相关参数\[可选]

```bash
通过mount -o指定挂载参数，禁止更新目录及文件时间戳挂载
[root@nfs-client ~]# mount -t nfs -o noatime,nodiratime 172.16.1.31:/data /mnt
```

##

## docker volume 挂载nfs时候不成功 修改nfs服务配置文件

```plain
/data/nfs 192.168.0.0/16(rw,insecure,sync,no_subtree_check,no_root_squash)
rw        读写权限
insecure  通过1024以上端口发送
sync*     同时将数据写入到内存与硬盘中，保证不丢失数据
no_subtree_check   不检查父目录权限
no_root_squash     当NFS客户端以root管理员访问时，映射为NFS服务器的root管理员(不常用)


1.验证ro权限
1.服务端修改rw为ro参数
# cat /etc/exports
/data 172.16.1.0/24(ro,sync,all_squash)
# systemctl restart nfs-server

2.客户端验证
# mount -t nfs 172.16.1.31:/data /mnt
# df -h
Filesystem         Size  Used Avail Use% Mounted on
172.16.1.31:/data   98G  1.7G   97G   2% /mnt
# 无法写入文件
# touch /mnt/file
touch: cannot touch ‘file’: Read-only file system

2.验证all_squash、anonuid、anongid权限
//1.服务端配置
# cat /etc/exports
/data 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
//2.服务端需要创建对应的用户
# groupadd -g 666 www
# useradd -u 666 -g 666 www
# id www
uid=666(www) gid=666(www) groups=666(www)
//3.重载nfs-server
# systemctl restart nfs-server
# cat /var/lib/nfs/etab 
/data   172.16.1.0/24(rw,sync,wdelay,hide,nocrossmnt,secure,root_squash,all_squash,no_subtree_check,secure_locks,acl,no_pnfs,anonuid=666,anongid=666,sec=sys,secure,root_squash,all_squash)

//4.授权共享目录为www;目录的所有者和所属组 www
# chown -R www.www /data/


//5.客户端验证
# umount /mnt/
# mount -t nfs 172.16.1.31:/data /mnt
//6.客户端查看到的文件，身份是666
# ll /mnt/
drwxr-xr-x 2 666 666 6 Sep  3 02:08 rsync_dir
-rw-r--r-- 1 666 666 0 Sep  3 02:08 rsync_file
//7.客户端依旧能往/mnt目录下写文件
[root@backup mnt]# touch fff
[root@backup mnt]# mkdir 111
[root@backup mnt]# ll
drwxr-xr-x 2 666 666 6 Sep  3 03:05 111
-rw-r--r-- 1 666 666 0 Sep  3 03:05 fff
//8.建议：将客户端也创建一个uid为666，gid为666，统一身份，避免后续出现权限不足的情况
# groupadd -g 666 www
# useradd -g 666 -u 666 www
# id www

//9.最后检查文件的身份
# ll /mnt/
total 4
drwxr-xr-x 2 www www 6 Sep  3 03:05 111
-rw-r--r-- 1 www www 0 Sep  3 03:05 fff

```

## NFS存储小结

NFS存储优点

1.NFS文件系统简单易用、方便部署、数据可靠、服务稳定、满足中小企业需求。

2.NFS文件系统内存放的数据都在文件系统之上，所有数据都是能看得见。

NFS存储局限

1.存在单点故障, 如果构建高可用维护麻烦。

2.NFS数据明文, 并不对数据做任何校验。

3.客户端挂载无需账户密码, 安全性一般(内网使用)

生产应用建议

1.生产场景应将静态数据尽可能往前端推, 减少后端存储压力

2.必须将存储里的静态资源通过CDN缓存(jpg\png\mp4\avi\css\js)

3.如果没有缓存或架构本身历史遗留问题太大, 在多存储也无用

报错

```bash
# mount  -t nfs 172.16.1.31:/data /data/
mount.nfs: Stale file handle
Stale file handle   #过期文件句柄

错误原因是客户端之前挂载的mnt目录在没有卸载的情况下，服务器侧把这个目录移除了，才会出现这样的错误提示。解决的办法就是在客户端umount一下，在重新挂载就好了。
# umount /data
# mount  -t nfs 172.16.1.31:/data /data/
```

![1547285324565-cd2ac1d2-f00c-4932-bccd-0dd9dde301ab.png](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-06.png)

![1547285335453-1e3ad619-e6d9-447f-87c8-bdca57f9e6d4.png](img/NFS%E5%85%B1%E4%BA%AB%E5%AD%98%E5%82%A8-07.png)


> 更新: 2026-05-01 16:07:27  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/tk8gl5>