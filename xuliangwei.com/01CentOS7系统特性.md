# 01 CentOS7系统特性

# 01 CentOS7系统特性

* [系统基础服务变化](http://kt.xuliangwei.com/15369045298910.html#toc_0)
* [Systemd服务概述](http://kt.xuliangwei.com/15369045298910.html#toc_1)
* [systemd启动级别](http://kt.xuliangwei.com/15369045298910.html#toc_2)
* [systemd服务管理](http://kt.xuliangwei.com/15369045298910.html#toc_3)
* [Centos7系统优化](http://kt.xuliangwei.com/15369045298910.html#toc_4)
* [核心架构地址规划](http://kt.xuliangwei.com/15369045298910.html#toc_5)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 老男孩Linux云计算运维QQ交流群: 384467551 226199307
>
> [老男孩教育官网](http://www.oldboyedu.com/) [http://www.oldboyedu.com](http://www.oldboyedu.com/)

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
| 修改字符集 | /etc/sysconfig/il8n | /etc/locale.conf | localectl |
| 防火墙 | iptables | firewalld | |
| 服务管理 | System V init | systemd | |
| 时间同步服务 | ntp | chrony | |

***1.系统主机名***

| 操作 | centos6 | cetos7 |
| :--- | :--- | :--- |
| 临时修改 | hostname | hostname |
| 永久修改 | /etc/sysconfig/network | /etc/hostname |
| hostnamectl set-hostname #centos7永久修改 | | |

***2.系统文件目录结构***

| centos6 | cetos7 |
| :--- | :--- |
| bin | bin -> usr/bin |
| sbin | sbin -> usr/sbin |
| lib | lib -> usr/lib |

***3.网络接口变化***

<!-- OCR_START -->
- Centos7操作系统网络接口命名
- 接口名称
- 网卡
- 网线
- etho
- 网卡1
- eth1
- 网卡2
- eth2
- 网卡3
<!-- OCR_END -->

> net.ifnames 基于固件、拓扑、进行自动分配网卡名称，缺点比eth0、更难读，如ens32
>
> biosdevname 根据戴尔服务器系统的BIOS提供的信息对网络接口进行重命名，如em1
>
> 默认命名规则 eth0 eth1 eth2
>
> biosdevname em1 em2 em3
>
> net.ifnames ens33 ens34 ens35

*centos6与centos7使用网络接口规则*

| Centos6 | Centos7 |
| :--- | :--- |
| net.ifnames=0   biosdevname=1   默认命名规则 | net.ifnames=1   biosdevname=1   默认命名规则 |

*centos7使用ip命令查看ip地址方法*

> 1.查看ip地址信息 ip addr
>
> 2.添加多个IP地址 ip addr add 192.168.56.200/24 dev eth0:1
>
> 3.控制网络接口 ip link set dev eth0 down

## Systemd服务概述

**Systemd初始**

Systemd是Centos7新采用的一套管理体系，可以实现启动及进程服务管理等，对比Centos6系统之前所采用sysVini体系，带来了很多变化。

> Centos7支持并行启动，显著提高开机启动效率(测试6与7区别)
>
> Centos7关机只关闭正在运行的服务，Centos6关机会从头关到尾
>
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

命令 选项(非必须) 执行命令 单元名称(非必须)

`systemctl [OPTIONS...]COMMAND[NAME...]`

| 操作 | Centos6 | Centos7 |
| :--- | :--- | :--- |
| 启动服务 | /etc/init.d/crond start | systemctl start crond |
| 停止服务 | /etc/init.d/crond stop | systemctl stop crond |
| 重启服务 | /etc/init.d/crond restart | systemctl restart crond |
| 查看状态 | /etc/init.d/crond status | systemctl status crond |
| 开机启动 | chkconfig --level 35 crond on | systemctl enable crond |
| 开机禁用 | chkconfig crond off | systemctl disable crond |
| 禁止运行 | | systemctl umask crond |

## Centos7系统优化

```plain
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
echo '* - nofile 65535' >> /etc/security/limits.conf
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

***

> 更新: 2019-03-20 20:03:22  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/hu956k>