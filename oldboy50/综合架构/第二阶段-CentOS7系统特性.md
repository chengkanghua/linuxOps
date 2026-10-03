# 第二阶段 · CentOS7 系统特性

> CentOS7 是新一代主流系统，相比 CentOS6 在初始化、服务管理、网络命名、文件系统等方面都有变化。本地虚拟化环境可用 VMware、KVM、VirtualBox。

## 一、系统基础服务变化（CentOS6 vs 7）

| 操作 | CentOS6 | CentOS7 | 说明 |
| --- | --- | --- | --- |
| 自动补全 | 只支持命令、文件名 | 支持命令、选项、文件名 | 7 更智能 |
| 文件系统 | ext4 | xfs | 随机读写更快 |
| 仓库管理 | yum | yum-config-manager | 添加仓库更便捷 |
| 修改主机名 | /etc/sysconfig/network | /etc/hostname | 7 可用 hostnamectl |
| 修改时区 | /etc/sysconfig/clock | timedatectl set-timezone | 更方便 |
| 防火墙 | iptables | firewalld | |
| 服务管理 | System V init | systemd | |
| 时间同步 | ntp | chrony | |

### 1. 主机名
| 操作 | CentOS6 | CentOS7 |
| --- | --- | --- |
| 临时修改 | `hostname` | `hostname` |
| 永久修改 | /etc/sysconfig/network | /etc/hostname 或 `hostnamectl set-hostname` |

### 2. 文件目录结构（7 的合并）
| CentOS6 | CentOS7 |
| --- | --- |
| /bin | /bin → /usr/bin |
| /sbin | /sbin → /usr/sbin |
| /lib | /lib → /usr/lib |

### 3. 网络接口命名变化
![网卡命名](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-CentOS7%E7%B3%BB%E7%BB%9F%E7%89%B9%E6%80%A7-01.png)

- **net.ifnames**：基于固件/拓扑自动分配，如 `ens32`（比 eth0 难读）。
- **biosdevname**：根据 BIOS 信息命名，如 `em1`（戴尔服务器常见）。

| 命名方案 | 规则 | 示例 |
| --- | --- | --- |
| 默认（6） | eth0/eth1/eth2 | eth0 |
| biosdevname | em1/em2/em3 | em1 |
| net.ifnames（7） | ens33/ens34/ens35 | ens33 |

| CentOS6 | CentOS7 |
| --- | --- |
| net.ifnames=0 biosdevname=1 | net.ifnames=1 biosdevname=1 |

**CentOS7 用 `ip` 命令查看/管理网络**
- 查看 IP：`ip addr`
- 添加多 IP：`ip addr add 192.168.56.200/24 dev eth0:1`
- 启停网卡：`ip link set dev eth0 down`

---

## 二、Systemd 服务管理

> Systemd 是 CentOS7 的新管理体系，替代 SysVinit，带来并行启动、按需管理等变化。

- CentOS7 支持**并行启动**，开机更快。
- CentOS7 关机只关正在运行的服务；6 会从头关到尾。
- CentOS7 不再依赖 `/etc/init.d/` 下的脚本。

| 功能 | CentOS6 | CentOS7 |
| --- | --- | --- |
| 启动项管理 | chkconfig | systemctl |
| 服务管理 | service | systemctl |
| 系统启动级别 | init | systemctl |
| 日志管理 | syslog | systemd-journal |

### 1. 启动级别（target 取代 runlevel）
CentOS7 用 `target` 目标涵盖启动级别概念。

| 运行场景 | SysVinit | Systemd |
| --- | --- | --- |
| 关机 | 0 | runlevel0.target, poweroff.target |
| 单用户 | 1,s,single | runlevel1.target, rescue.target |
| 多用户 | 2 | runlevel2.target, multi-user.target |
| 多用户+网络 | 3 | runlevel3.target, multi-user.target |
| 多用户+图形 | 5 | runlevel5.target, graphical-user.target |
| 重启 | 6 | runlevel6.target, reboot.target |

| 操作 | CentOS6 | CentOS7 |
| --- | --- | --- |
| 设置启动级别 | `init 3` | `systemctl set-default multi-user.target` |
| 查看当前级别 | `runlevel` | `systemctl get-default` |

### 2. 服务管理命令
格式：`systemctl [OPTIONS...] COMMAND [NAME...]`

| 操作 | CentOS6 | CentOS7 |
| --- | --- | --- |
| 启动 | /etc/init.d/crond start | systemctl start crond |
| 停止 | /etc/init.d/crond stop | systemctl stop crond |
| 重启 | /etc/init.d/crond restart | systemctl restart crond |
| 状态 | /etc/init.d/crond status | systemctl status crond |
| 开机自启 | chkconfig --level 35 crond on | systemctl enable crond（`--now` 表示立即启动，如 `systemctl enable --now glusterd`） |
| 开机禁用 | chkconfig crond off | systemctl disable crond |
| 禁止运行 | — | systemctl mask crond |

---

## 三、CentOS7 系统优化（初始化脚本）

```bash
# 0. 调整 yum 源
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# 也可直接：yum install epel-release.noarch（会自动选最优源）
yum clean all && yum makecache

# 1. 安装基础软件包
yum install net-tools vim tree htop iftop \
  iotop lrzsz sl wget unzip telnet nmap nc psmisc \
  dos2unix bash-completion iotop iftop sysstat -y

# 2. 关闭 firewalld
systemctl disable firewalld
systemctl stop firewalld
systemctl status firewalld

# 3. 关闭 SELinux（三种方式任选）
sed -ri 's#(^SELINUX=).*#\1disabled#g' /etc/selinux/config   # 方式一
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config   # 方式二
vim /etc/selinux/config                                       # 方式三
setenforce 0   # 临时生效

# 4. 优化 ulimit（文件句柄上限，满足高并发）
echo '* - nofile 65535' >> /etc/security/limits.conf
ulimit -n 65536   # 临时生效

# 5. 重启并打快照
```

---

## 四、核心架构地址规划

```
网站核心架构所需虚拟机 IP 及主机名规划：
 wanip         lanip       hostname
10.0.0.5     172.16.1.5     lb01
10.0.0.6     172.16.1.6     lb02
10.0.0.7     172.16.1.7     web01
10.0.0.8     172.16.1.8     web02
10.0.0.9     172.16.1.9     web03
10.0.0.31    172.16.1.31    nfs01
10.0.0.41    172.16.1.41    backup(rsync)
10.0.0.51    172.16.1.51    db01
10.0.0.61    172.16.1.61    m01
10.0.0.71    172.16.1.71    zabbix

VMware / Xshell 虚拟机命名规划：
01-10.0.0.5-keepalived-lb01
02-10.0.0.6-keepalived-lb02
03-10.0.0.7-nginx-web01
04-10.0.0.8-nginx-web02
05-10.0.0.9-nginx-web03
06-10.0.0.31-nfsfilesystem-nfs01
07-10.0.0.41-rsync-backup
08-10.0.0.51-mysql-db01
09-10.0.0.61-manage-m01
10-10.0.0.71-zabbix
```

---

## 五、Linux 高并发服务调优

> 高并发调优是系统性工程，围绕「系统内核、资源限制、网络、服务自身」四大维度展开。

### 1. 基础资源限制（解决「资源不够用」）
**（1）最大打开文件数 nofile**
作用：Linux 一切皆文件（端口、套接字、日志都算），默认 1024 远不够高并发。
```bash
ulimit -n 65535                                       # 临时生效（当前会话）
echo '* - nofile 65535' >> /etc/security/limits.conf  # 永久（所有用户）
# 针对 systemd 服务（如 Nginx/Java），还需在该服务配置 [Service] 段加：
# LimitNOFILE=65535
```

**（2）最大进程数 nproc**
作用：限制单用户可创建的进程/线程数，避免高并发下创建失败。
```bash
echo '* - nproc 65535' >> /etc/security/limits.conf
echo '* - nproc 65535' >> /etc/security/limits.d/20-nproc.conf   # CentOS7 专属
```

### 2. 内核参数调优（解决「网络/内存瓶颈」）
修改 `/etc/sysctl.conf`，重点优化 TCP 和内存。
```bash
cp /etc/sysctl.conf /etc/sysctl.conf.bak   # 先备份

cat >> /etc/sysctl.conf << EOF
# ===== TCP 网络调优（核心）=====
net.ipv4.tcp_tw_reuse = 1            # 复用 TIME_WAIT 端口
net.ipv4.tcp_tw_recycle = 1          # 快速回收 TIME_WAIT（注意：NAT 环境慎用）
net.ipv4.tcp_max_tw_buckets = 6000   # TIME_WAIT 最大数量
net.core.somaxconn = 65535           # 最大 TCP 连接队列（防 SYN 丢包）
net.core.netdev_max_backlog = 65535  # 单端口最大监听队列
net.core.rmem_default = 8388608      # TCP 接收缓冲区默认
net.core.wmem_default = 8388608      # TCP 发送缓冲区默认
net.core.rmem_max = 16777216        # TCP 接收缓冲区最大
net.core.wmem_max = 16777216        # TCP 发送缓冲区最大
net.ipv4.tcp_retries2 = 5           # 连接超时重试次数
net.ipv4.tcp_syncookies = 1         # 开启 SYN Cookie（防 SYN 洪水）
net.ipv4.tcp_max_syn_backlog = 65535 # 最大待处理 SYN 请求
net.ipv4.tcp_keepalive_time = 60    # 保活超时（秒）
net.ipv4.tcp_keepalive_intvl = 10   # 保活探测间隔
net.ipv4.tcp_keepalive_probes = 3   # 保活探测次数

# ===== 内存/文件系统调优 =====
vm.swappiness = 0                   # 禁用 swap，避免内存交换导致性能暴跌
vm.dirty_ratio = 10                 # 内存页缓存刷新策略
vm.dirty_background_ratio = 5
EOF

sysctl -p   # 立即生效，无需重启
```

### 3. 网络服务专属调优（以 Nginx 为例）
系统调优后，服务自身配置也要匹配，否则用不上资源。
```nginx
worker_processes auto;        # 工作进程数 = CPU 核心数
worker_cpu_affinity auto;     # 进程绑定 CPU，减少切换开销
worker_connections 65535;     # 单进程最大连接数（与 nofile 匹配）
multi_accept on;              # 一次性接收所有新连接

events {
    use epoll;                # Linux 高并发最优事件模型
}

http {
    keepalive_timeout 60;           # 长连接超时
    keepalive_requests 10000;       # 单长连接最大请求数
    tcp_nodelay on;                 # 禁用 Nagle 算法，降延迟
    tcp_nopush on;                  # 批量发送，提吞吐
    open_file_cache max=65535 inactive=20s;  # 文件缓存
}
```

### 4. 其他关键调优项
- **禁用不必要服务**：关闭防火墙（生产用云/硬件防火墙）、SELinux，减少资源占用：
  ```bash
  sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
  systemctl stop firewalld && systemctl disable firewalld
  ```
- **CPU/内存**：高并发服务（Nginx/Redis）默认多核友好，绑定 CPU 即可；内存优先用物理内存，禁用 swap（`vm.swappiness=0`）。
- **磁盘 IO**：用 SSD；用 XFS（CentOS7 默认，比 ext4 更适合高并发）；日志异步+缓存（如 Nginx `access_log buffer=32k`）。

### 5. 调优验证（关键！）
```bash
ulimit -n                    # 输出 65535 生效
sysctl net.core.somaxconn    # 输出 65535 生效
nginx -t && nginx -s reload
```

### 总结（核心关键点）
1. **基础层**：提升文件句柄/进程数限制（`limits.conf`），解决「资源不够用」。
2. **内核层**：优化 TCP 网络参数（`sysctl.conf`），解决「连接超时/端口耗尽」。
3. **服务层**：匹配服务自身配置（Nginx 工作进程/连接数），用好系统资源。
4. **兜底层**：禁用 swap、关闭无关服务，避免性能损耗。
> 顺序：先解锁系统限制 → 再优化网络/内存 → 最后匹配服务配置。

---

## 六、常见面试题

1. **CentOS6 和 CentOS7 在服务管理上最大区别？**
   6 用 SysVinit + service/chkconfig；7 用 systemd + systemctl，支持并行启动、用 target 取代 runlevel。

2. **CentOS7 网卡名为什么变成 ens33 而不是 eth0？**
   7 默认启用 `net.ifnames` 按固件/拓扑自动命名（如 ens33）；6 默认 eth0。可在内核参数加 `net.ifnames=0 biosdevname=0` 改回。

3. **systemctl enable --now 和 enable 的区别？**
   `enable` 仅设置开机自启；`--now` 同时立即启动服务。

4. **高并发下为什么要调大 nofile？**
   连接、端口、日志都算文件描述符，默认 1024 在高并发下会「too many open files」，需调大到 65535 并配合服务配置。

5. **tcp_tw_reuse / tcp_tw_recycle 有什么用？注意什么？**
   缓解大量 TIME_WAIT 占用端口；`tcp_tw_recycle` 在 NAT/负载均衡环境下可能导致连接异常，生产慎用。

6. **为什么生产常禁用 swap（swappiness=0）？**
   内存交换到磁盘会极大拖慢性能，数据库/高并发服务尤其敏感，宁可使用 OOM 也不愿 swap 抖动。

---

> 更新：2026-04-28 16:51:43
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/ldg044>
