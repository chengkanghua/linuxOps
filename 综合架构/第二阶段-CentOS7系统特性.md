# 第二阶段- CentOS7系统特性

`Centos7`新的主流操作系统, `Centos7`带来了很多的功能改变。

本地虚拟机环境`VmWare、KVM、Virtaulbox`

| 操作系统 | Centos6.9 | Centos7.5 |
| :--- | :--- | :--- |

## 系统基础服务变化

| 操作 | Centos6 | Centos7 | 对比 |
| :--- | :--- | :--- | :--- |
| 自动补全 | 只支持命令、文件名 | 支持命令、选项、文件名 | |
| 文件系统 | ext4 | xfs | 随机读写更快 |
| repo仓库 | yum | yum-config-manager | 添加仓库便捷 |
| 修改主机名 | /etc/sysconfig/network | /etc/hostname | hostnamectl |
| 修改时区 | /etc/sysconfig/clock | timedatectl set-timezone | 更方便 |
| 防火墙 | iptables | firewalld | |
| 服务管理 | System V init | systemd | |
| 时间同步服务 | ntp | chrony | |

***1.系统主机名***

| 操作 | centos6 | cetos7 |
| :--- | :--- | :--- |
| 临时修改 | hostname | hostname |
| 永久修改 | /etc/sysconfig/network | /etc/hostname |
|  | | hostnamectl set-hostname #centos7永久修改 |

***2.系统文件目录结构***

| centos6 | cetos7 |
| :--- | :--- |
| bin | bin -> usr/bin |
| sbin | sbin -> usr/sbin |
| lib | lib -> usr/lib |

***3.网络接口变化***

![1547284062590-cd3235b2-e4c1-4eb1-9142-45eee8c876a2.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-CentOS7%E7%B3%BB%E7%BB%9F%E7%89%B9%E6%80%A7-01.png)

> net.ifnames 基于固件、拓扑、进行自动分配网卡名称，缺点比eth0、更难读，如ens32\
> biosdevname 根据戴尔服务器系统的BIOS提供的信息对网络接口进行重命名，如em1
>
> 默认命名规则 eth0 eth1 eth2\
> biosdevname em1 em2 em3\
> net.ifnames ens33 ens34 ens35

*centos6与centos7使用网络接口规则*

| Centos6 | Centos7 |
| :--- | :--- |
| net.ifnames=0   biosdevname=1   默认命名规则 | net.ifnames=1   biosdevname=1   默认命名规则 |

*centos7使用ip命令查看ip地址方法*

> 1.查看ip地址信息 ip addr\
> 2.添加多个IP地址 ip addr add 192.168.56.200/24 dev eth0:1\
> 3.控制网络接口    ip link set dev eth0 down

## Systemd服务概述

**Systemd初始**\
Systemd是Centos7新采用的一套管理体系，可以实现启动及进程服务管理等，对比Centos6系统之前所采用sysVini体系，带来了很多变化。

> Centos7支持并行启动，显著提高开机启动效率(测试6与7区别)\
> Centos7关机只关闭正在运行的服务，Centos6关机会从头关到尾\
> Centos7服务的启动与停止不在需要init.d下的脚本

| | Centos6 | Centos7 |
| --- | :--- | :--- |
| 启动项管理 | chkconfig | systemctl |
| 服务管理 | service | systemctl |
| 系统启动级别 | init | systemctl |
| 日志管理 | syslog | Systemd-journal |

## systemd启动级别

在Centos7中没有级别的概念，而是使用`target`目标来涵盖启动级别的概念

设置系统启动运行级别

| | SysVinit | Systemd |
| --- | :--- | :--- |
| 关闭系统 | 0 | runlevel0.target,poweroff.target |
| 单用户模式 | 1,s,single | runlevel1.target,rescue.target |
| 多用户模式 | 2 | runlevel2.target,multi-user.target |
| 多用户带网络模式 | 3 | runlevel3.target,multi-user.target |
| 多用户图形化模式 | 5 | runlevel5.target,graphical-user.target |
| 重启操作系统 | 6 | runlevel6.target,reboot.target |

设置系统启动运行级别

| | Centos6 | Centos7 |
| --- | :--- | :--- |
| 设置启动级别 | init3 | systemctl set-default multi-user.target |
| 获取当前启动级别 | runlevel | systemctl get-default |

## systemd服务管理

命令 选项(非必须) 执行命令 单元名称(非必须)\
`systemctl [OPTIONS...]COMMAND[NAME...]`

| 操作 | Centos6 | Centos7 |
| :--- | :--- | :--- |
| 启动服务 | /etc/init.d/crond start | systemctl start crond |
| 停止服务 | /etc/init.d/crond stop | systemctl stop crond |
| 重启服务 | /etc/init.d/crond restart | systemctl restart crond |
| 查看状态 | /etc/init.d/crond status | systemctl status crond |
| 开机启动 | chkconfig --level 35 crond on | systemctl enable crond<br/>#--now 表示立刻启动，<br/>systemctl enable --now glusterd |
| 开机禁用 | chkconfig crond off | systemctl disable crond |
| 禁止运行 | | systemctl umask crond |

## Centos7系统优化

```bash
#0.调整yum源
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
#centos7 安装官网epel源 , 里面包含国内多个源地址 , 安装软件时候会自动选择最优的源
# yum install epel-release.noarch
#清理缓存，并重新生成缓存文件
yum clean all
yum makecache

//1.安装基础软件包
yum install net-tools vim tree htop iftop \
iotop lrzsz sl wget unzip telnet nmap nc psmisc \
dos2unix bash-completion iotop iftop sysstat -y
//2.关闭firewalld防火墙
systemctl disable firewalld
systemctl stop firewalld
systemctl status firewalld
//3.关闭selinux
# 方式一
sed -ri 's#(^SELINUX=).*#\1disabled#g' /etc/selinux/config
# 方式二
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config
# 方式三
vim /etc/selinux/config
# 临时生效
setenforce 0  
//4.优化ulimit 
#设置 nofile 65535 能大幅提升文件句柄上限，满足高并发服务的运行需求。
echo '* - nofile 65535' >> /etc/security/limits.conf
//临时生效
ulimit -n 65536
//5.重启并快照

```

## 核心架构地址规划

```plain
网站核心架构所需虚拟机IP及主机名规划：
 wanip         lanip       hostname
10.0.0.5     172.16.1.5     lb01
10.0.0.6     172.16.1.6     lb02
10.0.0.7     172.16.1.7     web01
10.0.0.8     172.16.1.8     web02
10.0.0.9     172.16.1.9     web03
10.0.0.31    172.16.1.31    nfs01
10.0.0.41    172.16.1.41    backup
10.0.0.51    172.16.1.51    db01
10.0.0.61    172.16.1.61    m01
10.0.0.71    172.16.1.71    zabbix
网站核心架构vmware和xshell软件里虚拟机名字规划：
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

# <font style="color:rgba(0, 0, 0, 0.85);background-color:rgba(0, 0, 0, 0.04);">Linux 高并发服务调优</font>

Linux 高并发服务调优是一个\*\*<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">系统性工程</font>\*\*，核心围绕「系统内核、资源限制、网络、服务自身」四大维度展开，

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">一、基础资源限制调优（解决「资源不够用」）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">高并发下最容易先触发「文件句柄、进程数」限制，这是调优第一步。</font>

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 提升最大打开文件数（nofile）</font>

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">作用</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：Linux 中「一切皆文件」（端口、套接字、日志都算），默认 1024 远不够高并发。</font>

```bash
# 临时生效（当前会话）
ulimit -n 65535
# 永久生效（所有用户）
echo '* - nofile 65535' >> /etc/security/limits.conf
# 补充：针对 systemd 服务（如 Nginx/Java），需在服务配置中加
# 编辑 /usr/lib/systemd/system/nginx.service，[Service] 段添加
LimitNOFILE=65535
```

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. 提升最大进程数（nproc）</font>

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">作用</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：限制单个用户能创建的进程 / 线程数，避免高并发下进程创建失败。</font>

```bash
# 永久生效
echo '* - nproc 65535' >> /etc/security/limits.conf
# 补充：CentOS7 需修改专属配置文件
echo '* - nproc 65535' >> /etc/security/limits.d/20-nproc.conf
```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">二、内核参数调优（解决「网络 / 内存瓶颈」）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">修改 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/etc/sysctl.conf</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（内核参数配置文件），是高并发调优的核心，重点优化 TCP 网络和内存。</font>

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 先备份原配置（安全第一）</font>

```bash
cp /etc/sysctl.conf /etc/sysctl.conf.bak
```

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. 添加核心调优参数（直接复制粘贴）</font>

```bash
cat >> /etc/sysctl.conf << EOF
# ===== TCP 网络调优（核心）=====
# 开启TIME_WAIT端口复用（解决大量TIME_WAIT占用端口）
net.ipv4.tcp_tw_reuse = 1
# 快速回收TIME_WAIT连接
net.ipv4.tcp_tw_recycle = 1
# TIME_WAIT最大数量（默认180000，高并发可加大）
net.ipv4.tcp_max_tw_buckets = 6000
# 最大TCP连接队列（解决SYN丢包、连接超时）
net.core.somaxconn = 65535
# 单个端口最大监听队列（和somaxconn配合）
net.core.netdev_max_backlog = 65535
# TCP接收/发送缓冲区默认值
net.core.rmem_default = 8388608
net.core.wmem_default = 8388608
# TCP接收/发送缓冲区最大值
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
# TCP连接超时重试次数（减少无效等待）
net.ipv4.tcp_retries2 = 5
# 开启SYN Cookie（防御SYN洪水攻击）
net.ipv4.tcp_syncookies = 1
# 最大待处理SYN请求数
net.ipv4.tcp_max_syn_backlog = 65535
# 保持连接超时时间（秒，减少空闲连接占用）
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 3

# ===== 内存/文件系统调优 =====
# 禁用swap（避免内存交换导致性能暴跌）
vm.swappiness = 0
# 内存页缓存刷新策略（提升IO性能）
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
EOF
```

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3. 使参数生效</font>

```plain
sysctl -p  # 无需重启，立即生效
```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">三、网络服务专属调优（以 Nginx 为例）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">系统调优后，服务自身配置也要匹配，否则无法利用系统资源。</font>

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. Nginx 核心调优（修改 nginx.conf）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">nginx</font>

```plain
worker_processes auto;  # 工作进程数=CPU核心数（auto自动匹配）
worker_cpu_affinity auto;  # 进程绑定CPU，避免切换开销
worker_connections 65535;  # 单个进程最大连接数（和nofile匹配）
multi_accept on;  # 一次性接收所有新连接

# 事件模型（epoll是Linux高并发最优选择）
events {
    use epoll;
}

# HTTP段调优
http {
    keepalive_timeout 60;  # 长连接超时时间
    keepalive_requests 10000;  # 单个长连接处理的最大请求数
    tcp_nodelay on;  # 禁用Nagle算法，降低延迟
    tcp_nopush on;   # 批量发送数据，提升吞吐量
    open_file_cache max=65535 inactive=20s;  # 文件缓存
}
```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">四、其他关键调优项</font>

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 禁用不必要的服务</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">关闭防火墙（生产环境用云防火墙 / 硬件防火墙）、SELinux 等无关服务，减少资源占用：</font>

```bash
# 关闭SELinux（永久生效，需重启）
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
# 临时关闭防火墙
systemctl stop firewalld && systemctl disable firewalld
```

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. CPU / 内存调优</font>

* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">CPU</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：避免运行多核不友好的程序，高并发服务（如 Nginx/Redis）默认支持多核，只需绑定 CPU 即可；</font>
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">内存</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：优先使用物理内存，禁用 swap（已在内核参数中设置 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">vm.swappiness=0</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">），避免内存交换导致性能断崖式下降。</font>

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3. 磁盘 IO 调优</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">高并发服务（如日志输出多）需优化磁盘：</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">使用 SSD 硬盘（随机读写性能远超机械盘）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">采用 XFS 文件系统（CentOS7 默认，比 ext4 更适合高并发）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">日志写入用「异步 + 缓存」（如 Nginx 开启 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">access_log buffer=32k</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">五、调优验证（关键！）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">调优后需确认配置生效，避免白配：</font>

```bash
# 验证文件句柄限制
ulimit -n  # 输出65535则生效
# 验证内核参数
sysctl net.core.somaxconn  # 输出65535则生效
# 验证Nginx配置
nginx -t && nginx -s reload
```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">总结（核心关键点）</font>

1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">基础层</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：提升文件句柄 / 进程数限制（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">limits.conf</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">），解决「资源不够用」；</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">内核层</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：优化 TCP 网络参数（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">sysctl.conf</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">），解决「连接超时 / 端口耗尽」；</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">服务层</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：匹配服务自身配置（如 Nginx 工作进程 / 连接数），利用好系统资源；</font>
4. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">兜底层</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：禁用 swap、关闭无关服务，避免性能损耗。</font>

先解锁系统限制，再优化网络 / 内存，最后匹配服务配置


> 更新: 2026-04-28 16:51:43  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/ldg044>