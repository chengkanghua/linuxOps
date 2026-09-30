# 第二阶段-Centos7和centos6区别

# 安装centos 7.5

首先虚拟机新建虚拟机向导

![1547283546851-f1028d13-5ba1-49ce-a32c-10de1f02b7e2-image1.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-01.png)

虚拟机位置单独存在一个大容量分区

![1547283546901-99f37749-4356-4af3-b83f-2fae51c8d27d-image2.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-02.png)

网络地址 NAT模式， 其他按推荐

![1547283546925-4bf82234-3723-4d40-901c-187b8b6dd6af-image3.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-03.png)

自定义硬件删到最精简+指定iso镜像位置

![1547283546947-c90dafff-94f5-4abe-900a-4df415f22acd-image4.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-04.png)

启动虚拟机安装进入系统安装选择界面 选择<font style="background-color:#ffff00;">install Centos7</font> 按下<font style="background-color:#ffff00;">Tab</font> 设定Kernel内核参数

![1547283546976-d6dc1076-e5dc-494d-9f26-b170ff90b401-image5.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-05.png)

添加内核参数 <font style="background-color:#ffff00;">net.ifnames=0 biosdevname=0</font>   之后回车

```bash
网络接口命名修改
- 网卡命名规则受 biosdevname 和 net.ifnames 两个参数影响
- 编辑/etc/default/grub文件 增加 biosdevname=0 net.ifnames=0
- 更新grub
	- #grub2-mkconfig -o /boot/grub2/grub.cfg
- 重启
  - reboot
```

![1547283546993-fa4c697f-062b-46af-96f4-c825a645eee2-image6.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-06.png)

![1547283547019-3b0b6f76-f570-490a-8f03-824972c77963-image7.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-07.png)

![1547283547041-a8c77497-f0e6-43bc-a06b-616271152516-image8.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-08.png)

![1547283547066-c2823f6b-f402-4b59-860c-2ed4649b3220-image9.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-09.png)

![1547283547097-148e92db-f9ba-4d1d-aa82-838de1387497-image10.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-10.png)

![1547283547123-721e9aa3-a3ff-4e29-893d-2720fbf407a3-image11.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-11.png)

![1547283547151-83db4a6f-4427-44c6-946a-c7ca055807d3-image12.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-12.png)

![1547283547171-de61deec-bae6-4039-b9ce-d178abfa13c4-image13.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-13.png)

![1547283547195-4c6e42bf-2abf-4ff4-824c-2d749b02e2a1-image14.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-14.png)

![1547283547222-621b11a6-9e44-4f82-8980-7332737df584-image15.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-15.png)

![1547283547246-3f4352d4-a324-422f-abb7-6a29247efde8-image16.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-16.png)

分区全部  

kdump 关闭  s

ecurity policy 关闭  

minimal install  

时区选上海

密码设置1 要点两下 Done

# [](#x41myz)<font style="color:#222222;">CentOS7系统特性</font>

## <font style="color:#222222;">系统基础服务变化</font>

| 操作 | Centos6 | Centos7 | 对比 |
| --- | --- | --- | --- |
| 自动补全 | 只支持命令、文件名 | 支持命令、选项、文件名 |  |
| 文件系统 | ext4 | xfs | 随机读写更快 |
| repo 仓库 | yum | yum-config-manager | 添加仓库便捷 |
| 修改主机名 | /etc/sysconfig/network | /etc/hostname | hostnamectl |
| 修改时区 | /etc/sysconfig/clock | timedatectl set-timezone | 更方便 |
| 防火墙 | iptables | firewalld | - |
| 服务管理 | System V init | systemd | - |
| 时间同步服务 | ntp | chrony | - |

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">补充说明（实用知识点）</font>

1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">文件系统</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：XFS 作为 CentOS7 默认文件系统，相比 ext4 更适合大文件、高并发场景，随机读写性能提升显著；</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">服务管理</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：systemd 替代 System V init 后，支持并行启动服务，开机速度更快，且通过 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">systemctl</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 命令统一管理服务（启动 / 停止 / 开机自启）；</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">时间同步</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：chrony 相比 ntp 更轻量，网络波动时同步精度更高，CentOS7 推荐优先使用 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">chronyd</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 服务。</font>

## [](#m2nlgg)自动补全

```bash
yum install bash-completion -y
```

## [](#au33sz)搭建本地yum源

```bash
centos 6 实现方式
	1 挂载光盘—》 设置---》cdrom –》iso –》选择对应的镜像文件
	2 在cenos6  挂载  mount /dev/cdrom /mnt/
	3  将原有的 yum源 备份   gzip *
		 cd /etc/yum.repos.d/ && gzip *
  4.编写对应的repo文件
cat > /etc/yum.repos.d/local.repo <<EOF
[local]
name=This is local yum repo
baseurl=file:///mnt
EOF

centos 7 实现
1 挂载光盘—》 设置---》cdrom –》iso –》选择对应的镜像文件
2 在cenos7  挂载  mount /dev/cdrom /mnt/
3 #查yum-config-manager工具属于哪个软件包提供（查询方式联网）
yum provides yum-config-manager   
4 yum install yum-utils –y  # 安装对应软件包
5. 备份repo 文件
    # cd /etc/yum.repos.d/ && gzip *
6  使用yum-config-manager 命令创建一个本地仓库
   yum-config-manager --add-repo=file:///mnt

7.  测试yum是否能正常使用
  # yum install vim -y
  
```

## [](#bli0pa)修改主机名

```bash
centos 6 实现方式
1.临时修改主机名
[root@c6 ~]# hostname oldboy_temp
[root@c6 ~]# bash
[root@oldboy_temp ~]#    #bash之后 主机名更新了
2.永久修改主机名
[root@oldboy_temp ~]# sed -i '/^HOSTNAME=/c HOSTNAME=oldboyedu' /etc/sysconfig/network
[root@oldboy_temp ~]# cat /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=oldboyedu

centos 7实现
#1.临时修改主机名
hostname oldboy-c7
bash  #从新载入bash  相当于退出从新登入

#2.永久修改主机名
hostnamectl set-hostname oldboyedu-cc7
cat /etc/hostname 

```

## [](#r8apfc)修改时区

```bash
1.查看所有时区
# timedatectl list-timezones
2.修改时区
timedatectl set-timezone "America/Punta_Arenas"  
timedatectl set-timezone "Asia/Shanghai"

```

   

## [](#bl9zcp)系统文件目录结构

```bash
centos6	    	cetos7
bin           bin/-->  usr/bin
sbin         	sbin-->  usr/sbin
lib	     		 	lib ->  usr/lib

# tree -dL 1 /
/
├── bin -> usr/bin
├── boot
├── dev
├── etc
├── home
├── lib -> usr/lib
├── lib64 -> usr/lib64
├── media
├── mnt
├── opt
├── proc
├── root
├── run
├── sbin -> usr/sbin
├── srv
├── sys
├── tmp
├── usr
└── var
```

![1547283547293-3de45a4b-ddad-4016-b5e6-49ea23404cb6-image18.jpeg](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-17.jpeg)

## 网络命名的规则

```bash
biosdevname         em1 em2 em3
net.ifnames         ens33 ens34 ens35  
net.ifnames 基于固件、拓扑、进行自动分配网卡名称，缺点比eth0、更难读，如ens32
biosdevname 根据戴尔服务器系统的BIOS提供的信息对网络接口进行重命名，如em1

centos7使用ip命令查看ip地址方法
1.查看ip地址信息 ip addr 
2.添加多个IP地址 ip addr add 192.168.56.200/24 dev eth0:1 
3.控制网络接口 ip link set dev eth0 down

安装net-tools工具，可使用ifconfig命令
# yum install net-tools –y

# yum provides *ifconfig  #查询ifconfig命令是哪个安装包的命令
net-tools-2.0-0.22.20131004git.el7.x86_64 : Basic networking tools
Repo        : base
Matched from:
Filename    : /sbin/ifconfig

```

## [](#r7pthh)启动级别

```bash
SysVinit	                      		Systemd
关闭系统	               0	        	runlevel0.target,poweroff.target
单用户模式	             1	        	runlevel1.target,rescue.target
多用户模式	             2	        	runlevel2.target,multi-user.target
多用户带网络模式				 3	        	runlevel3.target,multi-user.target
多用户图形化模式				 5	        	runlevel5.target,graphical-user.target
重启操作系统	       		 6	        	runlevel6.target,reboot.target   

Centos6 开机启动级别 运行级别
	vim /etc/inittab

Centos7 开机默认启动目标 target 
    multi-user.target: analogous to runlevel 3
    graphical.target: analogous to runlevel 5

1 查看系统当前默认级别（目标）
# systemctl get-default

2.修改系统启动默认级别（目标）
# systemctl set-default runlevel5.target
 建议修改回去
# systemctl set-default multi-user.target

3.centos7关机指令
 poweroff、init0 (不建议使用)
 reboot （重启）

生产环境手动关机 → 首选 shutdown -h now（安全、有提示）；
脚本 / 自动化关机 → 首选 systemctl poweroff（符合 CentOS7 架构）；效果：和 shutdown -h now 完全一致，都是优雅关机。
个人测试机快捷关机 → 可用 poweroff；
```

## systemd服务管理

```bash
命令 选项(非必须) 执行命令 单元名称(非必须)
systemctl [OPTIONS...]COMMAND[NAME...]
操作	    Centos6	                       Centos7
启动服务	/etc/init.d/crond start	       	 systemctl start     crond
停止服务	/etc/init.d/crond stop	         systemctl stop      crond
重启服务	/etc/init.d/crond restart	   	 	 systemctl restart   crond
查看状态	/etc/init.d/crond status	    	 systemctl status    crond
开机启动	chkconfig --level 35 crond on    systemctl enable    crond
开机禁用	chkconfig crond off	             systemctl disable   crond
禁止运行	                                 systemctl umask     crond  

# centos7上的service命令还是为了兼容centos6的习惯 
service crond restart
# centos7启动与停止建议使用systemctl
systemctl restart crond
# centos7查看所有的服务开机启动和开机不启动的单元
systemctl list-unit-files
# centos7开机不自启
systemctl disable crond
# centos7开机自启
systemctl enable crond
# centos7检查是否开机自启
systemctl is-enabled crond

```

# [](#4xh7xq)Centos7系统优化

```bash
# UseDNS no → 关闭 DNS 反向解析
# GSSAPI no → 关闭 GSSAPI 认证
sed -ie "/UseDNS/s/yes/no/g;/UseDNS/s/#//g;/^GSSAPI/s/yes/no/g" /etc/ssh/sshd_config 
systemctl restart sshd

#1.调整yum源
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

#centos7 安装官网epel源 , 里面包含国内多个源地址 , 安装软件时候会自动选择最优的源
# yum install epel-release.noarch
#2.清理缓存，并重新生成缓存文件
yum clean all
yum makecache
#3.安装基础软件包
yum install net-tools vim tree htop iotop iftop \
iotop lrzsz sl wget unzip telnet nmap nc psmisc \
dos2unix bash-completion sysstat rsync nfs-utils -y
#4.关闭防火墙
systemctl disable firewalld
systemctl stop firewalld
#5.关闭selinux
setenforce 0   #临时修改
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config
#6.优化ulimit
echo '* - nofile 65535' >> /etc/security/limits.conf
#关闭网卡图形化设置模式
systemctl stop NetworkManager
systemctl disable NetworkManager
#关闭邮件服务
systemctl stop postfix
systemctl disable postfix.service 
# 自动获取ip版本
cat > /etc/sysconfig/network-scripts/ifcfg-eth0<<EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=eth0
DEVICE=eth0
ONBOOT=yes
BOOTPROTO="dhcp"
DNS1=223.5.5.5
EOF
systemctl restart network

#7.执行shutdown -h now 关闭Centos7系统
#8.选中对应的虚拟机->快照->拍摄快照


# 手动设置ip版本
cat > /etc/sysconfig/network-scripts/ifcfg-eth0<<EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=10.0.0.2
PREFIX=24
GATEWAY=10.0.0.254
DNS1=223.5.5.5
EOF

```

centos6 关闭防火墙  和关闭 selinux

```bash
CentOS 5.x 6.x 防火墙  iptables
CentOS 7.x      firewalld

临时关闭防火墙
/etc/init.d/iptables stop
# /etc/init.d/iptables status   //查看iptables 状态

永久关闭防火墙（永久关闭防火墙 就要关闭开机自启动 软件在开机的时候自动运行）
chkconfig iptables off

检查开机自启动防火墙设置：
# chkconfig |grep iptables
iptables       	0:off	1:off	2:off	3:off	4:off	5:off	6:off


永久关闭SElinux - 服务器重启之后生效
/etc/selinux/config
# SELINUX= can take one of these three values:
#     enforcing  默认 selinux 开启运行中
#     permissive      selinux 关闭 警告信息
#     disabled        selinux彻底关闭
SELINUX=enforcing

# 命令修改
sed -i s#SELINUX=enforcing#SELINUX=disabled# /etc/selinux/config

临时关闭selinux – 服务器重启之后失效
[root@oldboyedu50 ~]# getenforce
Enforcing
root@oldboyedu50 ~]# setenforce
usage:  setenforce [ Enforcing | Permissive | 1 | 0 ]
[root@oldboyedu50 ~]# setenforce  0
[root@oldboyedu50 ~]# getenforce
Permissive
```

# CentOS 7 64位添加内网卡

![1547283547401-7af7c986-4ec6-4cdb-a4c1-ec2c8196efc1-image23.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-18.png)

![1547283547424-6db15c4a-ee64-4ed0-bf0b-89773fc316c4-image24.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-19.png)

```bash
nmcli connection add con-name eth1 ifname eth1 type ethernet \
ipv4.addresses 172.16.1.222/24 autoconnect yes ipv4.method manual

#centos7 安装官网epel源 , 里面包含国内多个源地址 , 安装软件时候会自动选择最优的源
yum install epel-release.noarch

```

英文翻译

nothing to do  无事可做

Package  软件包

already   已经

and		  和

latest    最新的

version    版本

loaded plugins   加载插件

Complete  完成

hostnamectl

host 主机  name 名字 ctl  controller 控制

zone  区域

time  时间

multi 多

analogous  类似的

target       目标

poweroff     关机

shutdown	关机

reboot		重新启动

systemd		系统服务管理

systemctl   服务管理命令

status		状态

clean      清洁

makecache   同步服务器缓存

firewall     防火墙

done     	完成

software selection   软件选择

installation source			安装源

installation destination   安装位置

keyboard 					键盘

localization				本地化

<font style="color:#333333;">established					已建立连接的</font>

<font style="color:#333333;">enabled					 启用</font>

扩展

centos7 系统时间和网络时间同步

```bash
yum -y install  ntp
systemctl enable ntpd
systemctl start ntpd
ntpdate ntp1.aliyun.com  #同步网络时间

# timedatectl   #查看时间
      Local time: 一 2018-09-03 20:45:30 CST
  Universal time: 一 2018-09-03 12:45:30 UTC
        RTC time: 一 2018-09-03 12:45:31
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: yes
NTP synchronized: no
 RTC in local TZ: no
      DST active: n/a

centos 6.9 同步时间
# ntpdate ntp2.aliyun.com

```

# 内核升级

```bash
# https://dl.lamp.sh/kernel/el7/
wget https://dl.lamp.sh/kernel/el7/kernel-ml-devel-6.9.10-1.el7.x86_64.rpm
wget https://dl.lamp.sh/kernel/el7/kernel-ml-6.9.10-1.el7.x86_64.rpm

yum localinstall -y  kernel-ml-6.9.10-1.el7.x86_64.rpm kernel-ml-devel-6.9.10-1.el7.x86_64.rpm

#安装完毕后查看系统可用启动内核
awk -F\' '$1=="menuentry " {print  $2}' /etc/grub2.cfg

# 修改默认的启动内核
grub2-set-default 'CentOS Linux (6.9.10-1.el7.x86_64) 7 (Core)'
grub2-editenv list


reboot
uname -r
```


> 更新: 2026-05-14 13:19:37  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/vq2qss>