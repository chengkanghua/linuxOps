# rsync 增量同步工具

## 一、基本概述

rsync 是开源备份工具，可在不同主机间同步，支持**全量备份**与**增量备份**，非常适合集中式备份、异地备份。

- 官方地址：<http://rsync.samba.org/>
- 监听端口：**873**
- 运行模式：**C/S（客户端/服务端）**

**两种备份方式**
- **完全备份**：把客户端 file1/file2/file3 全部备份到服务端（效率低、占空间）。
- **增量备份**：只把客户端新增的 file2/file3 备份到服务端（效率高、省空间，适合异地备份）。

---

## 二、应用场景（推 / 拉）

| 方式 | 说明 | 痛点 |
| --- | --- | --- |
| **推（push）** | 所有主机把本地数据推到 Rsync 备份服务器 | 客户端同时推，服务端接收慢（适合少量数据） |
| **拉（pull）** | 备份服务器拉取所有主机数据 | 备份服务器开销大 |
| **大量服务器** | 多客户端推送 + 服务端校验 | 建议用定时任务错峰 |
| **异地备份** | 跨机房/公网同步 | 配合 `--bwlimit` 限速、SSH 隧道 |

---

## 三、传输模式

```text
Local:      rsync [OPTION...] SRC... [DEST]
远程通道:
  Pull: rsync [OPTION...] [USER@]HOST:SRC... [DEST]
  Push: rsync [OPTION...] SRC... [USER@]HOST:DEST
守护进程:
  Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST]
        rsync [OPTION...] rsync://[USER@]HOST[:PORT]/SRC... [DEST]
  Push: rsync [OPTION...] SRC... [USER@]HOST::DEST
        rsync [OPTION...] SRC... rsync://[USER@]HOST[:PORT]/DEST
```

**常用选项**
| 选项 | 含义 |
| --- | --- |
| `-a` | 归档模式，等于 `-tropgDl` |
| `-v` | 详细输出（速率、文件数） |
| `-z` | 传输时压缩 |
| `-r` | 递归目录 |
| `-t/-o/-p/-g` | 保持时间/属主/权限/属组 |
| `-l` | 保留软链接 |
| `-P` | 显示进度 |
| `-D` | 保留设备文件 |
| `-L` | 保留软链接指向的文件 |
| `-e` | 指定信道（如 ssh） |
| `--exclude=PATTERN` | 排除文件模式 |
| `--bwlimit=100` | 限速 |
| `--partial` | 断点续传 |
| `--delete` | 目标与源保持一致（删目标多余文件） |

### 1. 本地方式（类似 cp）
```bash
rsync /etc/passwd /tmp/
ls /tmp/passwd
```

### 2. 远程方式（走 ssh，类似 scp）
```bash
# 下载
echo "This Nfs" > file
rsync -avz root@172.16.1.31:/root/file /opt/

# 上传
echo "This Rsync" > file2
rsync -avz /root/file2 root@172.16.1.31:/mnt
```
> 推送 `/root/`：推送目录**下面的内容**（不含自身）；推送 `/root`：推送目录**本身及内容**。

远程方式的缺陷：① 用系统用户（不安全）；② 普通用户有权限问题；③ 走 ssh 协议。

### 3. 守护进程方式（推荐，不用系统用户更安全）
```bash
# 拉取 backup 模块到本地 /mnt
rsync -avz rsync_backup@192.172.16.1.41::backup/ /mnt/ --password-file=/etc/rsync.password
# rsync 命令  [选项]  [虚拟用户@]主机::模块  本地目标

# 推送本地 /mnt 到 backup 模块
rsync -avz /mnt/ rsync_backup@192.172.16.1.41::backup/ --password-file=/etc/rsync.password
```

---

## 四、服务实践

| 角色 | 外网 IP | 内网 IP | 主机名 |
| --- | --- | --- | --- |
| Rsync 服务端 | 10.0.0.41 | 10.0.0.7 | backup |
| Rsync 客户端 | 10.0.0.31 | 10.0.0.4 | nfs |

**服务端配置**
```bash
# 1. 安装
yum -y install rsync

# 2. /etc/rsyncd.conf
cat > /etc/rsyncd.conf<<EOF
uid = rsync
gid = rsync
port = 873
fake super = yes
use chroot = no
max connections = 200
timeout = 600
ignore errors
read only = false
list = false
auth users = rsync_backup
secrets file = /etc/rsync.password
log file = /var/log/rsyncd.log
#####################################
[backup]
comment = welcome to oldboyedu backup!
path = /backup
EOF
```
| 配置项 | 含义 |
| --- | --- |
| `uid` / `gid` | 运行进程的用户/组 |
| `port` | 监听端口 |
| `fake super = yes` | 无需 root 也能保存文件完整属性 |
| `use chroot = no` | 关闭假根 |
| `max connections` | 最大连接数 |
| `timeout` | 超时 |
| `ignore errors` | 忽略错误 |
| `read only = false` | 可写 |
| `list = false` | 不暴露模块列表 |
| `auth users` | 虚拟认证用户 |
| `secrets file` | 密码文件路径 |
| `[backup]` / `path` | 模块名 / 接收目录 |

```bash
# 3. 运行用户
useradd -M -s /sbin/nologin rsync
mkdir /backup && chown -R rsync.rsync /backup/

# 4. 虚拟用户密码文件
echo "rsync_backup:1" >/etc/rsync.password
chmod 600 /etc/rsync.password

# 5. 启动
systemctl start rsyncd && systemctl enable rsyncd
ss -lntp |grep 873

# 测试（客户端也装 rsync 但不启动服务）
rsync -avz /etc/passwd rsync_backup@10.0.0.7::backup                 # 推送
rsync -avz rsync_backup@10.0.0.7::backup /opt                      # 拉取
```

**客户端免密**
```bash
echo "1" > /etc/rsync.password
chmod 600 /etc/rsync.password
rsync -avz rsync_backup@10.0.0.7::backup /opt --password-file=/etc/rsync.password
# 方式二（脚本推荐）：
export RSYNC_PASSWORD=1
rsync -avz rsync_backup@10.0.0.7::backup /opt
```

**常用操作**
```bash
# 强制一致性（--delete）
rsync -avz --delete rsync_backup@10.0.0.7::backup/ /data/ --password-file=/etc/rsync.password
rsync -avz --delete /data/ rsync_backup@10.0.0.7::backup/ --password-file=/etc/rsync.password

# 限速
dd if=/dev/zero of=/opt/test.dosk bs=1M count=1024
rsync -avzP --bwlimit=1 /opt/test.dosk rsync_backup@10.0.0.7::backup

# 实战：推 / 拉 / 无差异同步
rsync -avz /backup/ rsync_backup@10.0.0.7::backup/ --password-file=/etc/rsync.password
rsync -avz rsync_backup@10.0.0.7::backup /backup/ --password-file=/etc/rsync.password
rsync -avz --delete rsync_backup@10.0.0.7::backup/ /data/ --password-file=/etc/rsync.password   # 远端为准
rsync -avz --delete /data/ rsync_backup@10.0.0.7::backup/ --password-file=/etc/rsync.password   # 本地为准
```

---

## 五、备份案例脚本

统一备份目录为 `/backup`；备份系统配置、服务配置、日志、脚本，目录命名 `主机名_IP_日期`。

```bash
cat > /server/scripts/client_rsync_backup.sh<<'EOF'
#!/usr/bin/bash
#1.定义变量
Host=$(hostname)
Addr=$(ifconfig eth0|awk 'NR==2{print $2}')
Date=$(date +%F)
Dest=${Host}_${Addr}_${Date}
Path=/backup
#2.创建备份目录
mkdir -p $Path/$Dest
#3.备份文件
tar czf $Path/$Dest/system.tar.gz /etc/fstab /etc/rsyncd.conf && \
tar czf $Path/$Dest/log.tar.gz  /var/log/messages /var/log/secure
#4.推送
export RSYNC_PASSWORD=1
rsync -avz $Path/ rsync_backup@10.0.0.4::backup
EOF
```

---

## 六、常见报错速查

### 服务端配置类
**1. `@ERROR: chdir failed`**
原因：服务端没有 `/backup` 目录。处理：`mkdir /backup && chown -R rsync.rsync /backup`

**2. `@ERROR: auth failed on module backup`**
原因：服务端密码文件有问题。检查：① 客户端密码文件权限非 600；② 服务端密码文件非 600；③ 文件不存在/名字写错；④ 用户名密码不正确。

**3. `@ERROR: invalid uid rsync`**
原因：不可用 uid。处理：`useradd rsync -s /sbin/nologin -M`

**4. `@ERROR: chroot failed`**
原因：服务端目录不存在或无权限。处理：创建目录并修正权限。

**5. `@ERROR: auth failed on module tee`**
原因：模块 tee 需要验证但客户端未提供正确密码。处理：提供正确密码。

**6. `@ERROR: Unknown module 'tee_nonexists'`**
原因：模块不存在；① 推送/拉取命令写错；② 服务端模块名写错。

**7. `rsync: --passwork-file=...: unknown option`**
原因：密码文件名字写错（如把 password 打成 passwork）。更正文件名。

**8. `rsync: ERROR: cannot stat destination "." (in backup): Permission denied (13)`**
原因：服务端目录权限不足。处理：`chmod 755 /backup/`

**9. `rsync: write failed ... No space left on device (28)`**
原因：磁盘满。处理：`df` 查看，清理空间。

**10. `rsync: opendir "/kexue" (in dtsChannel) failed: Permission denied (13)`**
注意查看同步目录权限是否为 755。

**11. `rsync: failed to connect to ...: Connection timed out (110)`**
原因：防火墙/网络不通。处理：检查端口 `ss -tunlp`、telnet 测试，放行 873 或关防火墙。

**12. `rsync: failed to connect to ...: Connection refused (111)`**
服务未启动。处理：`rsync --daemon --config=/etc/rsyncd.conf`

**13. `rsync: recv_generator: mkdir "..." failed: No space left on device (28)`**
磁盘空间满。

**14. `rsync error: received SIGINT, SIGTERM, or SIGHUP (code 20)`**
Ctrl+C 中断或文件过多。

**15. `rsync: read error: Connection reset by peer (104)`**
原因：xnetid 启动、配置文件路径不对。处理：建软链 `ln -s /etc/rsyncd/rsyncd.conf /etc/rsyncd.conf`。

**16. `rsync: recv_generator: mkdir "nfs01_172.16.1.31" failed: Permission denied (13)`**
原因：① 服务端配置的用户与模块目录属主属组不一致；② 目录无权限。处理：`chown rsync.rsync /backup`。

**17. `skipping non-regular file "vendor/bin/doctrine"`**
原因：源有软链接。处理：用 `rsync -va`（`-a` 含 `-l`）或 `rsync -rvltOD`。

**18. `@ERROR: module is read only`**
原因：服务端 `read only = true`。处理：`read only = false`。

**19. `password file must not be other-accessible`**
原因：密码文件权限不是 600。处理：`chmod 600 rsyncd.pwd`。

**20. `rsync error: error starting client-server protocol`**
原因：`/etc/rsyncd.conf` 内容有错误。核对配置。

**21. `rsync: chown "" failed: Invalid argument (22)`**
原因：权限无法复制（多见于 Linux→Windows）。去掉同步权限参数。

**22. `@ERROR: daemon security issue — contact admin`**
原因：同步目录里有软链接且权限不足。处理：`use chroot = yes`。

**23. `rsync: read error: Connection reset by peer (104)`**
原因：服务端未开启 rsync 服务。开启服务。

**24. `@ERROR: failed to open lock file`**
原因：缺锁文件配置。处理：加 `lock file = rsyncd.lock`。

### 防火墙类
**No route to host**
客户端现象：`rsync: failed to connect to ...: No route to host (113)`。原因：服务端 iptables 拦截。处理：关闭/放行防火墙。

### 客户端命令类
**`ERROR: The remote path must start with a module name not a /`**
原因：`::/backup` 语法错误，应为 `::backup`（模块名，不是路径）。

**`@ERROR: auth failed on module backup`**
原因：① 密码/用户名错；② `secrets file` 指向的文件名与实际不一致；③ 文件权限非 600；④ 密码后有多余空格；⑤ 客户端密码文件只写密码、不要写虚拟用户名。

**`Unknown module 'backup'`**
原因：`/etc/rsyncd.conf` 模块名写错。

**`Permission denied` + `mkstemp ".hosts.5z3AOA" failed`**
原因：① 共享目录属主属组不是 rsync；② 目录权限不是 755。

**`@ERROR: chdir failed`**
原因：① 备份目录没建；② 建的目录与配置不一致。

**`@ERROR: invalid uid rsync`**
原因：rsync 虚拟用户不存在，重新创建。

**`password file must not be other-accessible`（仍提示输密码）**
原因：客户端密码文件也必须是 600 权限。

**客户端连接慢**
日志：`name lookup failed for 172.16.1.31`，`connect from UNKNOWN`。处理：检查 DNS/主机名解析；正确日志应是 `connect from nfs01 (172.16.1.31)`。

**服务没正确启动**
现象：`Connection refused (111)`。处理：`rsync --daemon` 然后 `ss -lntup |grep rsync`，再试。

---

## 七、常见面试题

1. **rsync 三种传输模式？**
   本地（类似 cp）、远程（走 ssh，类似 scp）、守护进程（C/S，用虚拟用户，最安全）。

2. **rsync 为什么比 scp 适合备份？**
   支持增量传输（只传变化部分）、断点续传、限速、排除文件、压缩，且守护进程模式不用系统用户。

3. **`--delete` 是做什么的？有什么风险？**
   让目标与源完全一致，删除目标多余文件。风险：方向写反会误删一方数据，生产慎用。

4. **密码文件为什么必须 600 权限？**
   rsync 不允许密码文件对其他用户可读，否则报 `password file must not be other-accessible` 并退回到交互输密码。

5. **`rsync -avz /root/ ...` 和 `rsync -avz /root ...` 区别？**
   前者推送目录**内容**（不含 /root 本身）；后者推送**目录本身及其内容**。

6. **常见 `@ERROR: auth failed` 怎么排查？**
   查密码文件权限（服务端+客户端都 600）、用户名密码、配置文件 `secrets file` 路径、密码后多余空格。

7. **`No route to host` 一般是什么问题？**
   网络不通或被防火墙拦截，放行 873 或关闭防火墙后重试。

---

> 更新：2026-04-29 17:04:37
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/gqkttb>
