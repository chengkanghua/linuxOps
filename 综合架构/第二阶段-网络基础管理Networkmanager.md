# 第二阶段-网络基础管理Networkmanager

# 基础介绍
<font style="color:#333333;">RHEL/CentOS7</font>系统默认使用<font style="color:#333333;">NetworkManager</font>来提供网络服务，这是一种动态管理网络配置的守护进程，能够让网络设备保持连接状态。 <font style="color:#333333;">NetworkManager</font>提供的命令行和图形配置工具对网络进行设定, 设定保存的配置文件在<font style="color:#333333;">/etc/sysconfig/network-scripts</font>目录下, 工具有<font style="color:#333333;"> nmcli nmtui, nm-connect-editor</font>

<font style="color:#333333;background-color:#ffff00;">nmcli</font><font style="color:#333333;">   </font><font style="color:#0070C0;">nm是NetworkManager 的缩写  cli命令窗口</font>

![1547283254995-1874d2b1-833a-4f1e-8e7e-8f3b448d6555-image2.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-%E7%BD%91%E7%BB%9C%E5%9F%BA%E7%A1%80%E7%AE%A1%E7%90%86Networkmanager-01.png) 

```bash
device 物理设备，例如 enp2s0,virbr0,team0
connection 连接设置 ，指的是一套具体配置方案
yum install –y  bash-completion  # 命令参数自动补全 软件
误区， Linux命令不用记，记到笔记里，需要时候复制就可以

# nmcli device  #查看物理设备状态
设备名   类型	  	 状态		  连接件
DEVICE  TYPE      STATE      CONNECTION
eth0    ethernet  connected  eth0
lo      loopback  unmanaged  --
connected   连接
ethernet    以太网
loopback	环回接口
unmanaged	非托管
# nmcli connection   #查看连接和设备的状态（逻辑上的配置文件）
NAME  UUID                                  TYPE      DEVICE
eth0  3921d633-020d-4eea-936f-e208dbac8a50  ethernet  eth0

nmcli connection  show eth0  #查看eth0配置详细信息
nmcli connection show –active  #仅查看活动配置文件
NAME  UUID                                  TYPE      DEVICE
eth0  3921d633-020d-4eea-936f-e208dbac8a50  ethernet  eth0
eth1  1baf152e-63e2-41ef-b2b1-3ce8e3a3ab4d  ethernet  eth1

# systemctl status NetworkManager   #查看NetworkManager 服务状态
# enabled 表示下次启动会自动开启 
# active(running) 表示当前正在运行


# systemctl disable NetworkManager   #设置开机不启动
# systemctl enable NetworkManager	#设置开机自启动

# systemctl is-enabled NetworkManager  查看指定服务是否开机自动
# systemctl is-active NetworkManager  #查看是否是运行状态

#启动服务
systemctl start NetworkManager
#停止服务
systemctl stop NetworkManager
#重启服务
systemctl restart NetworkManager 
```



# [](#1gk0hr)#使用nmcli 创建新的连接 
```bash
//定一个名为dhcp的连接, 配置DHCP地址
//实质是添加/etc/sysconfig/network-scripts/ifcfg-ens33-dhcp配置文件
con-name 连接名字 对应网卡接口 eth0 是否开机自启 yes  类型  以太网  ipv4模式 自动
# nmcli connection add \
con-name ens33-dhcp ifname eth0 autoconnect yes \
type ethernet ipv4.method auto

# nmcli connection  #查看所有连接
NAME        UUID                                  TYPE            DEVICE
eth0        000b9696-19d5-4ade-bca6-7ee0266ddcf0  802-3-ethernet  eth0
ens33-dhcp  33bcddf0-9cc4-47fe-9acf-ede449757d8a  802-3-ethernet  --    
//激活指定的连接名为ens33-dhcp的连接
# nmcli connection up ens33  # 应用这个连接，xhell会掉线
nmcli  connection   ##查看连接和设备的状态（逻辑上的配置文件）
#按tab补全时候没有提示的时候 用—help  会有提示
# nmcli connection add con-name ens33-dhcp ifname eth0 autoconnect yes \
type ethernet ipv4.method --help
错误：修改 ipv4.method 失败：'--help' 不在 [auto, link-local, manual, shared, disabled] 中。

# nmcli connection  #查看连接状态（逻辑上的配置文件）
NAME        UUID                                  TYPE      DEVICE
eth0        3921d633-020d-4eea-936f-e208dbac8a50  ethernet  eth0
ens33-dhcp  a174f280-5cc9-44ef-88bd-2619a6465e6b  ethernet  --

//删除不要的网卡配置连接文件
nmcli connection delete "wired connection 1"

```

# 新增一个静态地址的连接, 配置IP、掩码、网关等
```bash
静态地址添加流程
1.添加一个连接的配置
2.给连接指定一个名称
3.连接配置绑定物理网卡
4.网卡的类型,网卡开机启动
5.网卡通过什么途径获取地址(静态、dhcp)
6.配置对应的IP地址、掩码、网关、DNS
# nmcli connection add con-name eht1-static ifname eth1 \
type ethernet autoconnect yes \
ipv4.method manual \
ipv4.addresses 10.0.0.9/24 \
ipv4.gateway 10.0.0.254 \
ipv4.dns 223.5.5.5 \
+ipv4.dns 8.8.8.8

//激活指定的连接名为eht1-static的连接
# nmcli connection up eht1-static
# nmcli connection show
NAME         UUID                                  TYPE            DEVICE
eht1-static  6fdebe6e-5ef0-4a05-8235-57e317fdada0  802-3-ethernet  eth0
```



# [](#orgpir)#使用nmcli 修改已有的网络连接
```bash
//1.取消开机自动激活网络
# nmcli connection modify eht1-static \
autoconnect no

//2.修改连接的dns
# nmcli connection modify eht1-static \
ipv4.dns 8.8.8.8

//3.给连接再增加dns,有些设定值通过+/-可以增加或则移除设定
# nmcli connection modify eht1-static \
+ipv4.dns 8.8.8.8

//4.替换连接的静态IP和默认网关
# nmcli connection modify eht1-static \
ipv4.addresses 192.168.69.252/24 ipv4.gateway 192.168.69.22

//5.添加一个没有默认网关的IP
# nmcli connection modify eht1-static \
+ipv4.addresses 192.168.70.12/24 

//6.修改完毕，nmlci仅仅修改并保存了配置，要激活更改，需要重激活连接
# nmcli connection down eht1-static && \
nmcli connection up eht1-static

//删除自建的connection
# nmcli connection delete eht1-static


// 图形工具配置 nm-connection-editor
```

# [](#42g0wz)使用<font style="color:#333333;">nmcli</font>管理网络<font style="color:#333333;">/etc/sysconfig/network-scripts/</font>配置文件（手工修改）
```bash
1.新增物理网卡 
2.拷贝配置文件(可以和设备名称一致)—>配置文件名就是 connection的连接名称（可用和物理网卡名称一致） 
3.修改配置,删除UUID、修改name连接名称、修改device设备名称、修改IP地址等信息 
4.重新加载网络配置  使用 nmcli connection reload 加载配置 
5.启用连接,并检查  nmcli connection up 【connection-name】

//修改eht1-static配置文件
# vim /etc/sysconfig/network-scripts/ifcfg-eht1-static
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
IPADDR=192.168.69.232
PREFIX=24
GATEWAY=192.168.69.1
DNS1=211.161.122.200
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
NAME=ens32-staic
UUID=6fdebe6e-5ef0-4a05-8235-57e317fdada0
DEVICE=ens32
ONBOOT=yes

//手工编辑正在使用的配置文件,需要重载配置,然后重启
# nmcli connection reload
# nmcli connection down eht1-static && nmcli connection up eht1-static

```



# [](#3ubbwr)使用原生Network管理网络 （不推荐）
```bash
CentOS/RHEL的网络配置文件默认目录为/etc/sysconfig/network-scripts 
默认第一块物理网卡配置文件为ifcfg-eth0, 
如果有第二块物理网卡, 配置文件则为ifcfg-eth1以此类推。 
 注意: 如果新增物理网卡没有配置文件，可选择复制系统默认的进行修改。

1.删除NetworkManger建立连接, 同时停止NetworkManger服务
# systemctl disable NetworkManager
# systemctl stop NetworkManager
2.添加一块物理网卡, 然后新增网络连接配置文件
//复制配置eth0配置文件为eth1
# cp /etc/sysconfig/network-scripts/{ifcfg-eth0,ifcfg-eth1}

//编辑网卡配置文件
# vim /etc/sysconfig/network-scripts/ifcfg-eth1
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
NAME=eth1
DEVICE=eth1
ONBOOT=yes
IPADDR=192.168.56.12
NETMASK=255.255.255.0
GATEWAY=192.168.56.2
DNS1=192.168.56.2

//重启network网络服务加载网络
# systemctl restart network.service

//选项                  描述
BOOTPROTO=none          //获取地址方式[none|dhcp|static]
IPADDR=192.168.56.12    //固定IP地址
PREFIX=24               //掩码
GATEWAY=192.168.56.2    //网关
DNS1=192.168.56.2       //域名解析
DEVICE=eth1             //设备名称  
NAME="eth1"             //连接名称
ONBOOT=yes              //开机自启动
DEFROUTE=yes            //将接口设定为默认路由[yes|no]
USERCTL=yes             //允许非root用户管理接口[yes|no]

```







# [](#q6p6xu)Linux7修改网卡为eth0
```bash
1.已安装Linux7系列操作系统, 修改网卡命名规则为eth0 eth1
//修改网卡配置文件
# cd /etc/sysconfig/network-scripts/
# mv ifcfg-eno16777728 ifcfg-eth0
# vim ifcfg-eth0
NAME=eth0
DEVICE=eth0

//GRUB添加kernel参数
# vim /etc/sysconfig/grub
GRUB_CMDLINE_LINUX="...net.ifnames=0 biosdevname=0 quiet"
# grub2-mkconfig -o /boot/grub2/grub.cfg

//重启系统生效
# reboot

//默认centos7不支持ifconfig命令安装net-tools包
# yum install net-tools
# ifconfig eth0  #查看网卡信息

```



<font style="color:#333333;">2.在安装系统选择Install Centos7按下Tab设定kernel内核参数   (推荐)</font>

![1547283255023-8ec9baed-8628-4d06-a2c4-b8f8131a42fd-image3.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-%E7%BD%91%E7%BB%9C%E5%9F%BA%E7%A1%80%E7%AE%A1%E7%90%86Networkmanager-02.png)



<font style="color:#333333;">增加内核参数: net.ifnames=0 biosdevname=0</font>

![1547283255061-bdc97ace-1770-4bc9-a290-3a1a49a54efa-image4.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-%E7%BD%91%E7%BB%9C%E5%9F%BA%E7%A1%80%E7%AE%A1%E7%90%86Networkmanager-03.png)



<font style="color:#333333;">检查是否修改成功</font>![1547283255097-325e4859-fdeb-43e0-ac62-091ee2146a58-image5.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-%E7%BD%91%E7%BB%9C%E5%9F%BA%E7%A1%80%E7%AE%A1%E7%90%86Networkmanager-04.png)



# [](#a7hxou)主机名设定与名称解析服务
```bash
生产环境中必须配置主机名,同时主机名也需要遵循一定的规范, 比如:
公有云: 地区-项目-业务-服务-节点-地址
wh-shop-register-nginx-node1-192.168.56.13
wh-med-pay-mysql-master01-192.168.56.11
wh-med-pay-mysql-slave01-192.168.56.12
1.主机名查看与配置
hostname命令可以查看主机名, 
# 也可以用于临时修改主机名
# hostname "test"

rhel7系统建议使用hostnamectl修改和查看主机名
//设定永久名称
# hostnamectl set-hostname nginx.node1.xuliangwei.com
//永久修改主机名会修改/etc/hostname文件
# cat /etc/hostname
nginx.node1.xuliangwei.com

//检查状态信息
# hostnamectl


DNS客户端配置
/etc/hosts文件, 加快域名解析, 方便小型局域网用户使用内部设备

假设公司有A B两台主机, B主机添加的IP为192.168.69.12,为了方便访问B主机, 
可以在A主机的/etc/hosts文件中添加一条记录
192.168.69.12 hostB

完成后在A主机上使用ping命令测试到B主机的连通性, 
如果没有添加记录, 将会显示unknown host 

hostB的错误
使用hosts文件仅能为有限的主机记录, 无法将所有已知的主机名记录到hosts文件中, 
因此当今几乎所有的主机都在使用DNS来解析地址, DNS是全互联网上主机名及其IP地址对应关系的数据库,
配置文件/etc/resolv.conf
# cat /etc/resolv.conf
# Generated by NetworkManager
search node1.xuliangwei.com
nameserver 211.161.122.200

```



# [](#pvh9op)Route设置路由以及网关
```bash
Linux主机之间是使用IP进行通信, 假设A主机和B主机同在一个网段内且网卡都处于激活状态, 
则A具备和B直接通信的能力, 但如果A主机和B主机处于两个不同的网段, 
则A必须通过路由器才能和B通信, 路由器属于IT设备的基础设施, 每一个网段都应该至少有一个网关

//增加网段路由
route add -net 192.168.90.0/24 gw 192.168.56.254
route add -net 0.0.0.0/0 gw 192.168.56.254

//删除网段路由
route del -net 192.168.90.0/24
route del -net 0.0.0.0/0 gw 192.168.56.254

//增加主机路由
route add -host 192.168.70.1 gw 192.168.56.254
//删除主机路由
route del -host 192.168.70.1/32

//查看当前路由表
route -n
如果重启, 配置信息就不存在, 必须将这种配置信息写到相关的配置文件中才能永久保存,
比如网卡配置文件的GATEWAY

```



# [](#plgkxn)网络检测工具与故障排查
```bash
ping命令的目的在于测试另一台主机是否可达, 如果ping不到某台主机,就说明对方主机已经出现了问题, 
但是不排除由于链路中的防火墙、ping被丢弃等原因造成ping不通的情况
-c 指定ping的次数
-i 指定ping包的发送间隔
-w 如果ping没有回应, 则在指定超时时间后退出


hostn/slookup命令是用来查询DNS记录的，
# 命令返回该域名的IP
# host xuliangwei.com

traceroute命令是用来路由跟踪, 检测网络故障出现在ISP运营商或是对端服务无法响应
# traceroute xuliangwei.com

ss/netstat命令查看网络连接状态
-t tcp协议的连接
-a 所有状态的连接
-n 数字化输出
-u upd协议的连接
-l 处于listen状态的连接
-p 输出相应进程的名字

1. Show TCP sockets (LISTEN)
# ss -tnl
# ss -tnl |grep :80 
# ss -tnl |grep :21 
# ss -atn
# ss -atn |grep :22
yum provides lsof  #查询lsof命令是哪个安装软件包
lsof  -i:22  # 查询本机22端口有哪些服务在运行

//常见端口
http    80/tcp 
https   443/tcp 
ssh     22/tcp 
ftp     20,21/tcp
mysql   3306/tcp
rsync   873/rsync
redis   6379/tcp
dns     53/udp
dhcp	67,68/udp


网络故障排查
网络故障分为硬件\软件故障
    网卡损坏
    链路故障
    网卡驱动不兼容

网络排查思路
1.ping本地回环口, 确定本机TCP/IP协议栈是否正常
2.ping本机IP地址, 确定本地设备以及驱动是否正常
3.ping同网段主机, 确定二层网络是否正常工作
  ping 三层网关  确定三层网络是否正常工作
4.ping网关地址, 确定本地与网络是否正常
5.ping公网地址, 确定本地路由是否正常
6.ping公网域名, 确定DNS客户端是否正常

服务故障排查思路
1.使用telnet检测端口是否开放
2.检查服务端防火墙以及SElinux
3.检查相应的权限是否配置正常
4.检查日志是否有异常
5.检查完毕后持续测试
建议: 所有的排查思路都从OSI七层模型由下往上逐一进行排查(学会看日志)

```







> 更新: 2024-08-24 16:40:32  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/lppg8g>