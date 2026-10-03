# 时间服务器与vpn

## vpn作用

<!-- OCR_START -->
- Virtual
- P
- rivate
- Network
<!-- OCR_END -->

### 能够访问墙外的内容


<!-- OCR_START -->
> You
> Tube
<!-- OCR_END -->



### 虚拟网络隧道


<!-- OCR_START -->
> S
> f
> You
> Tube
<!-- OCR_END -->



### 隧道数据传输


<!-- OCR_START -->
> 典
> 典
> 曲
<!-- OCR_END -->



### 保护服务器安全
![1671596950472-dc447528-1453-4cdd-9020-4b9e9b0df29c.png](img/时间服务器与vpn/image5.png)

## VPN介绍
VPN 直译就是虚拟专用通道，是提供给企业之间或者个人与公司之间**安全数据传输**的隧道。

虚拟私有网络（VPN）隧道是通过 Internet 隧道技术将两个不同地理位置的网络安全的连接起来的技术。

当两个网络是使用私有 IP 地址的私有局域网络时，它们之间是不能相互访问的，这时使用隧道技术就可以使得两个子网内的主机进行通讯。VPN 隧道技术经常被用于大型机构中不同办公区域子网的连接。

有时，使用 VPN 隧道仅仅是因为它很安全。服务提供商与公司会使用这样一种方式架设网络，他们将重要的服务器（如，数据库，VoIP，银行服务器）放置到一个子网内，仅仅让有权限的用户通过 VPN 隧道进行访问。

VPN (虚拟专用网)发展至今已经不在是一个单纯的经过加密的访问隧道了，它已经融合了**访问控制**、**传输管理**、**加密**、**路由选择**、**可用性管理**等多种功能，并在全球的信息安全体系中发挥着重要的作用。也在网络上，有关各种 VPN 协议优缺点的比较是仁者见仁，智者见智，很多技术人员由于出于使用目的考虑，包括访问控制、 安全和用户简单易用，灵活扩展等各方面，权衡利弊，难以取舍；尤其在 VOIP 语音环境中，网络安全显得尤为重要，因此现在越来越多的网络电话和语音网关支持 VPN 协议。

<!-- OCR_START -->
- 专用线路
- 上海办事处
- 北京办事处
- 互联网络
- PC主机
- 服务器
- 数据包-贵重
- 虚拟专用线路
<!-- OCR_END -->

+ 虚拟网络通道，保证数据专有安全，而不同于公开在互联网中的数据传输
- 如送快递，普通快递，是成堆的放在一起，各家快递，各家的数据需要传递
- 专线快递，如寄送一个价值连城的夜明珠，私人飞机专运，保证了安全性。
+ 专线通道，太过于昂贵

### VPN示意图

<!-- OCR_START -->
- 服务器组
- 总部
- UTT3640
- VPN
- 出差人员
- Intemet
- U2000
- 分点1
- 分点4
<!-- OCR_END -->

## VPN分类
企业环境中一般根据VPN的应用领域不同，把VPN划分为4类应用。

### 主机远程访问VPN服务
该情况一般用于超哥出差，休假等特殊情况远程办公，需要连接访问公司内部网络的场景，可以通过VPN拨号到公司内部，此时远程的超哥和办公室的其他同事就相当于在一个局域网了。

在家就可以访问公司内网，如文件服务器，OA办公四通，ERP，HTTP服务等等局域网应用。

<!-- OCR_START -->
- VirtualPrivateNetwork(VPN)
- Internet
- FileServer
- Firewall
- Office
- Home User
- Intranet
- RemoteWorker
<!-- OCR_END -->

对于运维人员需要个人电脑，拨号到企业网站的IDC机房，远程维护服务器。

这是运维人员经常经常采用的方法，来维护企业里无外网IP地址的服务器等设备。

### 企业网络之间的VPN服务
在公司的分支机构的局域网和公司总部的LAN之间的VPn连接，通过公网Internet建立VPN将各地的公司分部LAN连接到公司总部的LAN。

例如全国各地的大超市业务结算。

由于地域原因，通过VPN把不同地域的机器连接互相访问，就像是在一个局域网内。

### 企业多IDC机房之间的VPN
不同机房之间的业务管理和业务访问的数据传输。

### 企业外部VPN服务
在全球供应商，合作伙伴的LAN和本部公司的LAN建立VPN

## VPN隧道协议
### PPTP
**点对点隧道协议 (PPTP)** 是由包括微软和 3Com 等公司组成的 PPTP 论坛开发的一种点对点隧道协，基于拨号使用的 PPP 协议使用 PAP 或 CHAP 之类的加密算法，或者使用 Microsoft 的点对点加密算法 MPPE。其通过跨越基于 TCP/IP 的数据网络创建 VPN 实现了从远程客户端到专用企业服务器之间数据的安全传输。PPTP 支持通过公共网络(例如 Internet)建立按需的、多协议的、虚拟专用网络。PPTP 允许加密 IP 通讯，然后在要跨越公司 IP 网络或公共 IP 网络(如 Internet)发送的 IP 头中对其进行封装。

典型的Linux平台开源软件就是PPTP。

PPTP属于点对点方式应用，适合用户远程拨号到企业内部进行办公。

<!-- OCR_START -->
- Internet
- PPTPTunnel
- R1Router
- WAN:192.168.30.2/30
- 172.22.22.1
- Local:10.10.10.0/24
- 172.22.22.2
- R2Router
- WAN:192.168.40.2/30
- LAN:10.10.11.0/24
- 10.10.10.4/24
- 10.10.10.2/24
- 10.10.11.2/24
- 10.10.10.3/24
- Site-to-Site PPTP
<!-- OCR_END -->

**点对点隧道协议(PPTP，Point-to-Point Tunneling Protocol)将点对点协议(PPP，Point-to-Point Protocol)的数据帧封装进 IP 数据包中，通过 TCP／IP 网络进行传输**。PPTP 可以对 IP、IPX 或 NetBEUI 数据进行加密传递。PPTP 通过 PPTP 控制连接来创建、维护和终止一条隧道，并使用通用路由封装(GRE，Generic Routing Encapsulation)对 PPP 数据帧进行封装。封装前，PPP 数据帧的有效载荷(有效传输数据)首先必须经过加密、压缩或是两者的混合处理。

### L2TP
**第 2 层隧道协议 (L2TP)** 是 IETF 基于 L2F (Cisco的第二层转发协议)开发的 PPTP 的后续版本。是一种工业标准 Internet 隧道协议，其可以为跨越面向数据包的媒体发送点到点协议 (PPP) 框架提供封装。PPTP 和 L2TP 都使用 PPP 协议对数据进行封装，然后添加附加包头用于数据在互联网络上的传输。**PPTP 只能在两端点间建立单一隧道。 L2TP 支持在两端点间使用多隧道，用户可以针对不同的服务质量创建不同的隧道**。**L2TP 可以提供隧道验证，而 PPTP 则不支持隧道验证**。**但是当 L2TP 或 PPTP 与 IPSEC 共同使用时，可以由 IPSEC 提供隧道验证，不需要在第2层协议上验证隧道使用 L2TP**。 **PPTP 要求互联网络为 IP 网络**。L2TP 只要求隧道媒介提供面向数据包的点对点的连接，L2TP 可以在 IP(使用UDP)，帧中继永久虚拟电路 (PVCs), X.25 虚拟电路(VCs)或 ATM VCs 网络上使用。

<!-- OCR_START -->
- Intemal
- hosts
- Security Gateway
- Not
- encrypted
- VPN Tunnel
- (IPsec)
- Internet
- Remote IPsec Client
- 436 × 300
<!-- OCR_END -->

L2TP和PPTP都是一个隧道协议，区别在于**L2TP 可以提供隧道验证，而 PPTP 则不支持隧道验证**。

### IPSec
**IPSec** 的隧道是由**封装**、**路由**与**解封装**组成整个过程。隧道将原始数据包隐藏(或封装)在新的数据包内部。该新的数据包可能会有新的寻址与路由信息，从而使其能够通过网络传输。

隧道与数据保密性结合使用时，在网络上窃听通讯的人将无法获取原始数据包数据(以及原始的源和目标)。封装的数据包到达目的地后，会删除封装，原始数据包头用于将数据包路由到最终目的地。

<!-- OCR_START -->
- IPSec
- Modes
- Transpor+ Mode
- Gateway
- Tunnel Mode
<!-- OCR_END -->

### SSLVPN
SSL 协议提供了数据**私密性**、**端点验证**、**信息完整性**等特性。SSL 协议由许多子协议组成，其中两个主要的子协议是**握手协议**和**记录协议**。握手协议允许服务器和客户端在应用协议传输第一个数据字节以前，彼此确认，协商一种加密算法和密码钥匙。

在数据传输期间，记录协议利用握手协议生成的密钥加密和解密后来交换的数据。

SSL 独立于应用，因此任何一个应用程序都可以享受它的安全性而不必理会执行细节。SSL 置身于网络结构体系的**传输层**和**应用层**之间。此外，SSL 本身就被几乎所有的 Web 浏览器支持。这意味着客户端不需要为了支持 SSL 连接安装额外的软件。这两个特征就是 SSL 能应用于 VPN 的关键点。

<!-- OCR_START -->
- Port 1
- 192.168.1.99/24
- WAN1
- FortiClient
- 172.20.120.123
- Remote user
- SSL VPN
- FortiGate
- InternalNetwork
- Web Portal
<!-- OCR_END -->

### IPSec和SSL VPN区别

<!-- OCR_START -->
- IPSeC VS.SSLVPNs
- Internet
- Corporate
- IPSecTunnel
- Network
- ①IPSeC
- Remote User
- ②Permitted Subnet(s)
- With IPSec Client
- VPN/Firewall
- User's
- Maitbox
- ④Exchange
- Server
- SSL/TLS Tunnel
- SSL VPN
- Firewall
- Gatevray
- With Any Browser
- Intranet
- Permitted
- URLs/Objects
<!-- OCR_END -->

## VPN服务实践
利用虚拟专用网络，实现让外网主机获得架构中内网地址信息，实现利用内网地址进行数据传递

### 机器准备
```bash
windows主机    外网主机        10.0.1.1 （模拟公网地址）
vpnserver主机                 10.0.1.63（模拟公网地址）          172.20.1.63（模拟私网地址）
web01                                                  172.20.1.7 （模拟私网地址）
```

PS：确保每台主机时间做好正确同步

整个部署架构，肯定是分为客户端和服务端

### VPN服务端部署
准备好一台linux虚拟机

```bash
1.配置好基础环境
yum install wget -y

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

yum install -y bash-completion vim lrzsz wget expect net-tools nc nmap tree dos2unix htop iftop iotop unzip telnet sl psmisc nethogs glances bc ntpdate  openldap-devel 

2.确保时间正确
ntpdate -u ntp.aliyun.com
修改时区
[root@vpn_server ~]# ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
[root@vpn_server ~]#
[root@vpn_server ~]#
[root@vpn_server ~]# date
Wed Aug  5 15:53:28 CST 2020

3.明确关闭防火墙，大坑
```

服务器准备2块网卡，一个模拟公网，一个模拟局域网，在vmware上添加即可

这里mac和windows的网卡NAT添加是有区别的

windows的vmware workstation添加方式较为简单

mac的方式如下：

也可以看超哥的博客：[https://www.cnblogs.com/pyyu/p/9689138.html](https://www.cnblogs.com/pyyu/p/9689138.html)

### mac自定义vmware网络-外网
```bash
内网  172.20.1.63 仅主机模式
外网     10.0.1.63   NAT模式
```

1.vmware fusion偏好设置，添加nat自定义网络

偏好设置

<!-- OCR_START -->
- 网络
- 常规
- 键盘与鼠标
- 显示
- 默认应用程
- 反馈
- Internet共享
- 使用此配置的虚拟机将使用自定网络连接。
- 与我的Mac共享
- 桥接模式网络连接
- 允许该网络上的虚拟机连接到外部网络 (使用 NAT)
- 自动检测
- 启用IPv6
- Wi-Fi
- IPv6 前缀:
- fd15:4ba5:5a2b:1002::/64
- AX88772A
- 端口转发
- USB 10/100/1000 LAN
- AX88179...it Ethernet
- 主机端口
- 类型
- 虚拟机IP地址
- 描述
- iPad USB
- 蓝牙PAN
- Thunderbolt Ethernet
- iPhone USB 2
- USB 10/10...00 LAN 2
- iPhone USB 3
- USB 10/10...00 LAN 3
- 将Mac主机连接到该网络
- 自定
- 通过DHCP在该网络上提供地址
- 仅供我的Mac
- vmnet2
- 子网 IP:
- 10.0.1.0
- 子网掩码：
- 255.255.255.0
- √需要通过鉴定才能进入混杂模式
- 点按锁按钮以进行更改。
- 还原
- 应用
<!-- OCR_END -->

2.网络适配器1，选择vmnet2网络链接

<!-- OCR_START -->
- 一小
- G<
- vpn_server-10.0.0.63
- 断开连接网络适配器
- NAT 模式
- 桥接模式 (自动检测)
- √自定 (vmnet2)
- 仅主机模式
- 网络适配器 设置...
<!-- OCR_END -->

虚拟机连接

<!-- OCR_START -->
- vpn_server-10.0.0.63
- 显示全部
- ...er-10.0.0.63：网络适配器
- 添加设备...
- ?连接网络适配器
- 此网络适配器已配置为使用：
- USB10/100/1000LAN
- AX88179USB3....GigabitEthernet
- 虚拟机使用自定网络连接。
- iPad USB
- 蓝牙PAN
- 名称：vmnet2
- ThunderboltEthernet
- 类型：自定
- iPhone USB 2
- 子网 IP:10.0.1.0
- 子网掩码：255.255.255.0
- iPhone USB 3
- 自定
- 仅供我的Mac专用
- vmnet2
- 高级选项
<!-- OCR_END -->

3.centos的网卡配置文件ifcfg-ens33

```bash
[root@vpn_server ~]# cat /etc/sysconfig/network-scripts/ifcfg-ens33
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
#BOOTPROTO=dhcp
BOOTPROTO=static                              # <<<<<<<<<<
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=0bf55130-2380-4275-a785-09ba4871d951
HWADDR=00:50:56:22:5C:3F               # <<<<<<<<<<   
DEVICE=ens33 
ONBOOT=yes                                             # <<<<<<<<<<
IPADDR=10.0.1.63                                # <<<<<<<<<<
GATEWAY=10.0.1.2                                # <<<<<<<<<<
NETMASK=255.255.255.0                        # <<<<<<<<<<
DNS1=1.2.4.8                                        # <<<<<<<<<<
```

正确设置后，确保client-server能够通信

```bash
[yuchao@yumac vmnet2]$ping 10.0.1.63
PING 10.0.1.63 (10.0.1.63): 56 data bytes
64 bytes from 10.0.1.63: icmp_seq=0 ttl=64 time=0.365 ms
64 bytes from 10.0.1.63: icmp_seq=1 ttl=64 time=0.539 ms
```

### mac设置仅主机-内网
在加一个网络设备-添加网卡

<!-- OCR_START -->
- 显示全部
- ..r-10.0.1.63
- 网络适配器2
- 添加设备...
- 连接网络适配器
- 此网络适配器已配置为使用：
- USB 10/100/1000 LAN
- 虚拟机使用专用虚拟网络连接到Mac。一般情况下，无
- AX88179 USB 3...Gigabit Ethernet
- 法在Mac上通过物理网络访问专用网络。
- iPad USB
- 多个虚拟机可同时连接到一个专用网络。
- 蓝牙PAN
- Thunderbolt Ethernet
- iPhone USB 2
- iPhone USB 3
- 仅供我的 Mac 专用
- vmnet2
- 高级选项
- MAC 地址:
- 00:50:56:24:B9:F7
- 生成
- 网络模拟设置
- 入站转换
- 出站转换
- 带宽：
- 不受限
- Kbps:
- 数据包丢失 (%):
- 0.0
- 延迟 (毫秒):
- 移除网络适配器
<!-- OCR_END -->

mac的vmware fusion仅主机模式设备是：

vmnet1--仅主机，改成超哥这样的配置

vmnet2--nat  

```bash
yumac:VMware Fusion root# cat /Library/Preferences/VMware\ Fusion/networking
VERSION=1,0
answer VNET_1_DHCP no
answer VNET_1_HOSTONLY_NETMASK 255.255.255.0
answer VNET_1_HOSTONLY_SUBNET 172.20.1.0
answer VNET_1_VIRTUAL_ADAPTER yes

answer VNET_2_DHCP no
answer VNET_2_HOSTONLY_NETMASK 255.255.255.0
answer VNET_2_HOSTONLY_SUBNET 10.0.1.0
answer VNET_2_NAT yes
answer VNET_2_NAT_PARAM_UDP_TIMEOUT 30
answer VNET_2_VIRTUAL_ADAPTER yes
```

拷贝ifcfg-ens33 改为Ifcfg-ens37

centos内针对仅主机的网络适配器，添加网卡配置文件

```bash
生成新的网卡UUID

[root@vpn_server network-scripts]# uuidgen ens37
83bc9a96-818c-4104-8c06-8c39ba74f021
```

```bash
[root@vpn_server network-scripts]# cat ifcfg-ens37
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens37
HWADDR=00:50:56:24:B9:F7   # 和fusion保持一致
DEVICE=ens37
ONBOOT=yes
IPADDR=172.20.1.63
NETMASK=255.255.255.0
```

## VPN服务端软件部署

```bash
1.下载软件
# openvpn  vpn软件
# easy-rsa 生成证书和密钥，类似于ssh-keygen
yum install openvpn easy-rsa -y

2.创建服务端所需的证书和密钥信息
# 拷贝easy-rsa整个文件夹配置，放入openvpn目录下
[root@vpn_server ~]# cp -r /usr/share/easy-rsa/ /etc/openvpn/
[root@vpn_server openvpn]# cp  /usr/share/doc/easy-rsa-3.0.7/vars.example /etc/openvpn/easy-rsa/3.0.7/vars

#修改在openvpn目录下的vars配置文件，修改如下参数
set_var EASYRSA_REQ_COUNTRY     "CN"  # 国家 
set_var EASYRSA_REQ_PROVINCE    "BeiJing"  # 地区
set_var EASYRSA_REQ_CITY        "BeiJing"  # 城市
set_var EASYRSA_REQ_ORG "LuffyCity"   #组织
set_var EASYRSA_REQ_EMAIL       "yc_uuu@163.com"  #邮箱
set_var EASYRSA_REQ_OU          "Linux IT"   #拥有者

3.进入openvpn目录，生成easyrsa有关的证书和PKI信息目录
[root@vpn_server 3.0.7]# pwd
/etc/openvpn/easy-rsa/3.0.7
[root@vpn_server 3.0.7]# ll
total 96
-rwxr-xr-x 1 root root 74889 Aug  6 09:40 easyrsa
-rw-r--r-- 1 root root  4616 Aug  6 09:40 openssl-easyrsa.cnf
-rw-r--r-- 1 root root  8884 Aug  6 10:00 vars
drwxr-xr-x 2 root root   122 Aug  6 09:40 x509-types

[root@vpn_server 3.0.7]# ./easyrsa init-pki

Note: using Easy-RSA configuration from: /etc/openvpn/easy-rsa/3.0.7/vars

init-pki complete; you may now create a CA or requests.
Your newly created PKI dir is: /etc/openvpn/easy-rsa/3.0.7/pki

# 初始化，会在当前目录创建PKI目录，用于存储一些中间变量及最终生成的证书
[root@vpn_server 3.0.7]# ll
total 96
-rwxr-xr-x 1 root root 74889 Aug  6 09:40 easyrsa
-rw-r--r-- 1 root root  4616 Aug  6 09:40 openssl-easyrsa.cnf
drwx------ 4 root root    87 Aug  6 10:05 pki
-rw-r--r-- 1 root root  8884 Aug  6 10:00 vars
drwxr-xr-x 2 root root   122 Aug  6 09:40 x509-types

4.创建服务端ca证书，先不用密码，注意超哥执行命令的路径
# 创建根证书，首先会提示设置密码，用于ca对之后生成的server和client证书签名时使用
[root@vpn_server 3.0.7]# ./easyrsa build-ca nopass

Note: using Easy-RSA configuration from: /etc/openvpn/easy-rsa/3.0.7/vars
Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017
Generating RSA private key, 2048 bit long modulus
.....................................................+++
........................................................................................................+++
e is 65537 (0x10001)
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:openvpn

CA creation complete and you may now import and sign cert requests.
Your new CA certificate file for publishing is at:
/etc/openvpn/easy-rsa/3.0.7/pki/ca.crt

5.再创建私钥文件和证书请求文件

[root@vpn_server 3.0.7]# ./easyrsa gen-req openvpn nopass

Note: using Easy-RSA configuration from: /etc/openvpn/easy-rsa/3.0.7/vars
Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017
Generating a 2048 bit RSA private key
.....................+++
.............................................................................................................................................................................................+++
writing new private key to '/etc/openvpn/easy-rsa/3.0.7/pki/easy-rsa-1847.DQsKq2/tmp.GWykXa'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Common Name (eg: your user, host, or server name) [openvpn]:

Keypair and certificate request completed. Your files are:
req: /etc/openvpn/easy-rsa/3.0.7/pki/reqs/openvpn.req
key: /etc/openvpn/easy-rsa/3.0.7/pki/private/openvpn.key

私钥文件如上。

6.对整数签名，对信息进行确认，生成最终证书文件
[root@vpn_server 3.0.7]# ./easyrsa sign server openvpn

Note: using Easy-RSA configuration from: /etc/openvpn/easy-rsa/3.0.7/vars
Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017

You are about to sign the following certificate.
Please check over the details shown below for accuracy. Note that this request
has not been cryptographically verified. Please be sure it came from a trusted
source or that you have verified the request checksum with the sender.

Request subject, to be signed as a server certificate for 825 days:

subject=
    commonName                = openvpn

Type the word 'yes' to continue, or any other input to abort.
  Confirm request details: yes
Using configuration from /etc/openvpn/easy-rsa/3.0.7/pki/easy-rsa-1885.hjzdrW/tmp.S4zotf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'openvpn'
Certificate is to be certified until Nov  9 02:21:50 2022 GMT (825 days)

Write out database with 1 new entries
Data Base Updated

Certificate created at: /etc/openvpn/easy-rsa/3.0.7/pki/issued/openvpn.crt

7.生成pem文件，包含了证书、公私钥，根证书等。
迪菲-赫尔曼密钥交换（英语：Diffie–Hellman key exchange，缩写为D-H） 是一种安全协议。它可以让双方在完全没有对方任何预先信息的条件下通过不安全信道创建起一个密钥。这个密钥可以在后续的通讯中作为对称密钥来加密通讯内容。

[root@vpn_server 3.0.7]# ./easyrsa gen-dh

Note: using Easy-RSA configuration from: /etc/openvpn/easy-rsa/3.0.7/vars
Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017
Generating DH parameters, 2048 bit long safe prime, generator 2
This is going to take a long time
..............................................................................................................................................................................................................+................................................................................................................+.......

最终结果
..........++*++*

DH parameters of size 2048 created at /etc/openvpn/easy-rsa/3.0.7/pki/dh.pem

8.openvpn服务端总结
1.  /etc/openvpn/easy-rsa/3.0.7/pki/ca.crt
2.
req: /etc/openvpn/easy-rsa/3.0.7/pki/reqs/openvpn.req
key: /etc/openvpn/easy-rsa/3.0.7/pki/private/openvpn.key

3./etc/openvpn/easy-rsa/3.0.7/pki/issued/openvpn.crt
4./etc/openvpn/easy-rsa/3.0.7/pki/dh.pem

9.对证书与公私钥文件进行统一管理
cp /etc/openvpn/easy-rsa/3.0.7/pki/ca.crt /etc/openvpn/server/
cp /etc/openvpn/easy-rsa/3.0.7/pki/private/openvpn.key /etc/openvpn/server/
cp /etc/openvpn/easy-rsa/3.0.7/pki/issued/openvpn.crt /etc/openvpn/server/
cp /etc/openvpn/easy-rsa/3.0.7/pki/dh.pem /etc/openvpn/server/

[root@vpn_server openvpn]# tree /etc/openvpn/server/
/etc/openvpn/server/
├── ca.crt
├── dh.pem
├── openvpn.crt
└── openvpn.key

10.拷贝编写服务端配置文件
有关配置文件具体讲解，可以看
https://zzjlogin.github.io/Server/linux-server/openvpn/0040openvpn_config.html
这个地址

[root@vpn_server openvpn]# cp /usr/share/doc/openvpn-2.4.9/sample/sample-config-files/server.conf /etc/openvpn/

[root@vpn_server openvpn]# ll
total 12
drwxr-x--- 2 root openvpn     6 Apr 25 05:23 client
drwxr-xr-x 3 root root       39 Aug  6 09:40 easy-rsa
drwxr-x--- 2 root openvpn    72 Aug  6 10:40 server
-rw-r--r-- 1 root root    10784 Aug  6 10:44 server.conf

11.修改openvpn 服务端配置文件，修改如下参数

# 监听地址，端口，选择tcp更为安全，udp保证效率，开启tun隧道传输
local 10.0.1.63
port 1194  
proto tcp
dev tun   
ca /etc/openvpn/server/ca.crt
cert /etc/openvpn/server/openvpn.crt
key /etc/openvpn/server/openvpn.key  # This file should be kept secret
dh /etc/openvpn/server/dh.pem
topology subnet  #开启子网的掩码为/24 默认是/30
server 10.8.0.0 255.255.255.0 #配置服务器VPN子网，用于VPN客户端提取ip，服务器子集用10.8.0.1，说白了就是连接上VPN使用的ip地址
push "route 172.20.1.0 255.255.255.0" #用于VPN局域网的内网环境通信，推送内网路由
keepalive 10 120  #多久未使用VPN超时时间
;tls-auth ta.key 0 # This file is secret  # 注释掉这个，不使用该tls加密方式
status /var/log/openvpn-status.log  # 修改日志存放路径
log-append  /var/log/openvpn.log  # 运行日志
mute 20  # 重复日志限额
;explicit-exit-notify 1  #关闭自动重新连接功能

12.超哥的配置文件长这样
[root@vpn_server openvpn]# grep -n ^[a-Z] /etc/openvpn/server.conf
25:local 10.0.1.63
32:port 1194
35:proto tcp
53:dev tun
78:ca /etc/openvpn/server/ca.crt
79:cert /etc/openvpn/server/openvpn.crt
80:key /etc/openvpn/server/openvpn.key  # This file should be kept secret
85:dh /etc/openvpn/server/dh.pem
92:topology subnet
101:server 10.8.0.0 255.255.255.0
108:ifconfig-pool-persist ipp.txt
141:push "route 172.20.1.0 255.255.255.0"
231:keepalive 10 120
252:cipher AES-256-CBC
281:persist-key
282:persist-tun
287:status /var/log/openvpn-status.log
297:log-append  /var/log/openvpn.log
306:verb 3
311:mute 20
```

历经千辛万苦终于给服务端整好了，跟着超哥继续向下学

### 启动服务端
### 修改内核转发
```bash
1.添加内核转发参数
vim /etc/sysctl.conf

net.ipv4.ip_forward = 1

2.生效
sysctl -p
```

  

```bash
# 编写openvpn启动单元文件
[root@vpn_server openvpn]# cat /usr/lib/systemd/system/openvpn.service
# 依赖于network-online.target才可以运行
[Unit]
Description=openvpn service 
After=network-online.target
Wants=network-online.target

# 服务运行参数
[Service]
Type=forking
User=root
Group=root
ExecStart=/usr/sbin/openvpn --daemon --config /etc/openvpn/server.conf
ExecStop=/bin/kill -9 $MAINPID
Restart=on=failure
PrivateTmp=true

[Install]
WantedBy=multi-user.target

# 重新加载单元服务
systemctl daemon-reload

# 启动openvpn

[root@vpn_server openvpn]# systemctl start openvpn

[root@vpn_server openvpn]# systemctl enable openvpn
Created symlink from /etc/systemd/system/multi-user.target.wants/openvpn.service to /usr/lib/systemd/system/openvpn.service.

[root@vpn_server openvpn]# netstat -tunlp|grep 1194
tcp        0      0 10.0.1.63:1194          0.0.0.0:*               LISTEN      2481/openvpn
```

如果有错，检查配置文件，和超哥的文档对比。

  
 

## VPN客户端部署
下载客户端，各个操作系统都有

[https://openvpn.net/download-open-vpn/](https://openvpn.net/download-open-vpn/)

### 修改客户端配置文件
指定openvpn服务端信息即可

```bash
windows，下载openvpn客户端软件后，进行客户端配置

```

### 需要在服务端执行
```bash
1.在linux openvpn上生成提供给client使用的配置文件
[root@vpn_server 3.0.7]# ./easyrsa gen-req client01 nopass

Note: using Easy-RSA configuration from: /etc/openvpn/easy-rsa/3.0.7/vars
Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017
Generating a 2048 bit RSA private key
..................................+++
....................................+++
writing new private key to '/etc/openvpn/easy-rsa/3.0.7/pki/easy-rsa-2554.WYG9iM/tmp.3zL6Zq'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Common Name (eg: your user, host, or server name) [client01]:

Keypair and certificate request completed. Your files are:
req: /etc/openvpn/easy-rsa/3.0.7/pki/reqs/client01.req
key: /etc/openvpn/easy-rsa/3.0.7/pki/private/client01.key

2.签发客户端证书
[root@vpn_server 3.0.7]# ./easyrsa sign client client01

Note: using Easy-RSA configuration from: /etc/openvpn/easy-rsa/3.0.7/vars
Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017

You are about to sign the following certificate.
Please check over the details shown below for accuracy. Note that this request
has not been cryptographically verified. Please be sure it came from a trusted
source or that you have verified the request checksum with the sender.

Request subject, to be signed as a client certificate for 825 days:

subject=
    commonName                = client01

Type the word 'yes' to continue, or any other input to abort.
  Confirm request details: yes
Using configuration from /etc/openvpn/easy-rsa/3.0.7/pki/easy-rsa-2581.OUkWb9/tmp.g6glBr
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'client01'
Certificate is to be certified until Nov  9 06:42:23 2022 GMT (825 days)

Write out database with 1 new entries
Data Base Updated

Certificate created at: /etc/openvpn/easy-rsa/3.0.7/pki/issued/client01.crt

3.客户端配置文件汇总
# 放入/etc/openvpn/client/
[root@vpn_server 3.0.7]# mkdir -p /etc/openvpn/client/client01

[root@vpn_server 3.0.7]# cp /etc/openvpn/easy-rsa/3.0.7/pki/private/client01.key /etc/openvpn/client/client01
[root@vpn_server 3.0.7]# cp /etc/openvpn/easy-rsa/3.0.7/pki/issued/client01.crt /etc/openvpn/client/client01/
[root@vpn_server 3.0.7]# cp /etc/openvpn/easy-rsa/3.0.7/pki/ca.crt /etc/openvpn/client/client01/

4.检查
total 16
-rw------- 1 root root 1155 Aug  6 14:51 ca.crt
-rw------- 1 root root 4418 Aug  6 14:51 client01.crt
-rw------- 1 root root 1704 Aug  6 14:49 client01.key

5.导出配置文件，发送给windows客户端
利用python程序，快速运行http服务
[root@vpn_server 3.0.7]# cd /etc/openvpn/client/client01/
[root@vpn_server client01]# python -m SimpleHTTPServer 80
Serving HTTP on 0.0.0.0 port 80 ...
```

此时可以在windows中下载该配置文件

<!-- OCR_START -->
- 计算机本地磁盘（C:）openvpn
- 组织+
- 包含到库中▼
- 共享+
- 新建文件夹
- 收藏夹
- 名称
- 下载
- ca
- 桌面
- client01
- 最近访问的位置
- client01.key
- 视频
<!-- OCR_END -->

并且要再找到一个ovpn文件，也可以直接手动生成

client01.ovpn文件

```bash
client
dev tun
proto tcp
remote 10.0.1.63 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert client01.crt
key client01.key
cipher AES-256-CBC
verb 3
```

<!-- OCR_START -->
- →计算机本地磁盘(C:)openvpn
- 组织+
- 包含到库中+
- 共享
- 新建文件夹
- ☆收藏夹
- 名称
- 修改日期
- 类型
- 大小
- 下载
- 同ca
- 2020/8/6 15:00
- 安全证书
- 2 KB
- 桌面
- client01
- 5 KB
- 最近访问的位置
- client01.key
- KEY 文件
- 2020/8/6 15:34
- OVPN Profile
- 1 KB
- 视频
- 口图片
<!-- OCR_END -->

### 启动openvpn客户端
**openvpn需要手动设置ip地址，因为关闭了DHCP功能**

通过openvpn连接后，进行连接，连接成功后，已然进入VPN的内网环境了

```bash
可以检查网络情况
1.服务端的隧道网段
6: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none
    inet 10.8.0.1/24 brd 10.8.0.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::e6f3:8f47:c9a4:37f5/64 scope link flags 800
       valid_lft forever preferred_lft forever
[root@vpn_server client01]#
```

客户端尝试和VPN网络隧道通信

```bash
1.和10.8.0.1地址通信
ping 10.8.0.1

2.windows客户端此时应该是可以连接内网服务器ip的
ssh 172.20.1.63
```

### 成功后示意图
```bash
1.服务端的日志展示

==> /var/log/openvpn.log <==
Thu Aug  6 16:39:47 2020 TCP connection established with [AF_INET]10.0.1.69:49994
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 TLS: Initial packet from [AF_INET]10.0.1.69:49994, sid=4cd40cef c2012f51
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 VERIFY OK: depth=1, CN=openvpn
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 VERIFY OK: depth=0, CN=client01
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 peer info: IV_VER=3.git::3e56f9a6
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 peer info: IV_PLAT=win
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 peer info: IV_NCP=2
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 peer info: IV_TCPNL=1
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 peer info: IV_PROTO=2
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 peer info: IV_AUTO_SESS=1
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 peer info: IV_GUI_VER=OCWindows_3.2.0-1064
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 peer info: IV_SSO=openurl
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 Control Channel: TLSv1.2, cipher TLSv1/SSLv3 ECDHE-RSA-AES256-GCM-SHA384, 2048 bit RSA
Thu Aug  6 16:39:47 2020 10.0.1.69:49994 [client01] Peer Connection Initiated with [AF_INET]10.0.1.69:49994
Thu Aug  6 16:39:47 2020 client01/10.0.1.69:49994 MULTI_sva: pool returned IPv4=10.8.0.2, IPv6=(Not enabled)
Thu Aug  6 16:39:47 2020 client01/10.0.1.69:49994 MULTI: Learn: 10.8.0.2 -> client01/10.0.1.69:49994
Thu Aug  6 16:39:47 2020 client01/10.0.1.69:49994 MULTI: primary virtual IP for client01/10.0.1.69:49994: 10.8.0.2
Thu Aug  6 16:39:47 2020 client01/10.0.1.69:49994 PUSH: Received control message: 'PUSH_REQUEST'
Thu Aug  6 16:39:47 2020 client01/10.0.1.69:49994 SENT CONTROL [client01]: 'PUSH_REPLY,route 172.20.1.0 255.255.255.0,route-gateway 10.8.0.1,topology subnet,ping 10,ping-restart 120,ifconfig 10.8.0.2 255.255.255.0,peer-id 0,cipher AES-256-GCM' (status=1)
Thu Aug  6 16:39:47 2020 client01/10.0.1.69:49994 Data Channel: using negotiated cipher 'AES-256-GCM'
Thu Aug  6 16:39:47 2020 client01/10.0.1.69:49994 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Thu Aug  6 16:39:47 2020 client01/10.0.1.69:49994 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key

==> /var/log/openvpn-status.log <==
ss,Last Ref
10.8.0.2,client01,10.0.1.69:49994,Thu Aug  6 16:39:52 2020
GLOBAL STATS
Max bcast/mcast queue length,0
END
```

<!-- OCR_START -->
口13%
13GB
1.0 kB
OpenVPNConnect
inet6 ::1/128 scope host
ssyste
Profiles
valid_lft forever preferred_lft forever
WindowsIP配置
ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state
windows客户端VPN
link/ether 00:50:56:22:5c:3f brd ff:ff:ff:ff:ff:ff
Linux服务端
未知适配器本地连接：
inet 10.0.1.63/24 brd 10.0.1.255 scope global ens33
CONNECTED
VPN服务端
windows客户端通过openvpn连接
连接特定的DNS后缀
inet6 fe80::250:56ff:fe22:5c3f/64 scope link
模拟公网IP
地链接
IPv6地址
fe80::b921:3b2e:40c8:62b2
OpenVPN Profile
Mi
IPv4地址
10.8.0.2
:ens37: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state
10.0.1.63 [cliento1]
255.255.255.0
link/ether 00:50:56:24:b9:f7 brd ff:ff:ff:ff:ff:ff
此处获取了VPN隧道ip
inet 172.20.1.63/24 brd 172.20.1.255 scope global ens37
以太网适配器Ethernet0：
inet6fe80::250:56ff:fe24:b9f7/64scopeLtnk模拟内网IP
windows客户端ip
CONNECTION STATS
连特定的DNS
后缀
：tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
fe80::a0e2:a1f2:6285:705a
link/none
10. 0. 1. 69
86B/s
inet 10.8.0.1/24 brd 10.8.0.255 scope global tun0
valid_lftfreverpreferred_lft forever
默认网关.
:10. 0. 1. 2
inet6 fe80::a4cd:99f4:97b1:6caf/64 scope link flags 800
以太网适配器蓝牙网络连接：
连接的VPN网段
root@vpn_server client01]#
媒体状态
媒体已断开连接
root@vpn_serverclient01]#tail-f/var/log/openvpn*
/var/log/openvpn.log<==
hu Aug 6 16:36:52 2020 TCPv4_SERVER link local (bound): [AF_INET]10.0.1.63:
C:\Users\yu>ping 172. 20. 1.63
因为连接了VPN，已然可以和内网通信！
hu Aug 6 16:36:52 2020 TCPv4_SERVER link remote:[AF_UNSPEC]
oB/s
hu Aug 6 16:36:52 2020 MULTI: multi_init called,r=256 v=256
正在Ping172.20.1.63具有32字节的数据：
hu Aug
6 16:36:52 2020 IFCONFIG P00L: base=10.8.0.2 size=252, ipv6=0
来自
BYTES IN
BYTES OUT
6 16:36:52 2020 ifconfig_pool_readC)，in='client01,10.8.0.2'，T0D0:
0KB/S
172.20.1.63
hu Aug 6 16:36:52 2020 succeeded -> ifconfig_pool_set()
172.20.1.63的回复：
字节=32时间=1ms
TTL=64
hu Aug 6 16:36:52 2020 IFCONFIG P00L LIST
172.20.1.63的回复：字节=32时间<1msTTL=64
DURATION
PACKET RECEIVED
6 16:36:52 2020 client01,10.8.0.2
6 16:36:52 2020 MULTI: TCP INIT maxclients=1024 maxevents=1028
172.20.1.63的Ping统计信息：
00:02:07
5secago
hu Aug6 16:36:52 2020 Initialization Sequence Completed
数据包：
已发送
接收=4，丢失=0（0%丢失），
=>/var/log/openvpn-status.log<==
最短=0ms，最长=1ms，平均=0ms
YOU
此处的日志，已经看到消息
penVPN CLIENT LIST
pdated,Thu Aug 6 16:36:52 2020
C:\Users\yu>
ommon Name,Real Address,Bytes Received,Bytes Sent,Connected Since
YOUR PRIVATE IP
0802
<!-- OCR_END -->

### 我们可以通过http服务，验证VPN成功了

```bash
1.在linux上启动80服务

[root@vpn_server client01]#  python -m SimpleHTTPServer 80

Serving HTTP on 0.0.0.0 port 80 ...
```

2.windows上访问该VPN的地址（分别尝试，连接、断开VPN）

<!-- OCR_START -->
- OpenVPNConnect
- 无法访问此页面
- Profiles
- 10.8.0.1/
- DISCONNECTED
- OpenVPNProfile
- 10.0.1.63 [client01]
- 嗯...无法访问此页面
- 尝试此操作
- ·请确保你已获取正确的网址：
- http://10.8.0.1
- 未连接VPN
- ·在必应上搜索"http://10.8.0.
- 无法访问VPN服务器的内容
- ·刷新页面
- 详细信息
- 报告这一问题
- 隐私声明
<!-- OCR_END -->

连接上VPN

<!-- OCR_START -->
- Directory listing for/
- Profiles
- 10.8.0.1/
- 连接VPN
- CONNECTED
- 可以访问VPN服务端的内容了
- OpenVPN Profile
- 10.0.1.63 [client01]
- ca.crt
- client01.crt
- client01.key
- CONNECTIONSTATS
- 2.3KB/s
<!-- OCR_END -->

  
 

# NTP时间服务器

<!-- OCR_START -->
- Computers
- GPS Satelite
- Network Appliances
- Network Time System
- Server
- Internet Time Server
- Other NTP Devices
<!-- OCR_END -->

## 时间服务器
时间对于人类的作息非常重要，按时起床，按时上班，赶火车、火箭发射等等，都需要时间上的把控。

还有如卫星运转、监控、交换机、计算机时间等等，都离不开对时间的精准同步。

为什么每次计算机重启之后，时间都能够保持正确同步呢？是因为你的电脑主板上有一个用于记录BIOS配置的电池，如果电池没电了，或者某些因素，导致BIOS数据被清空，电脑开机后，时间就不准确了。

又或者可能操作系统程序的问题，软件上导致了时间不准确，那么我们都得调整下时间，得让计算机保持正确的状态。

生活里我们可以通过电视台，广播站，电话等等来调整我们的手表等事件。那么当计算机时间不准，我们如何让主机时间正确呢。

时间对于现代人来说是很重要的，因为『 Time is money 』。既然时间如此重要，对于因特网来说应该也是很重要吧？

## NTP时间协议

<!-- OCR_START -->
- 公网时间服务器
- 内网时间服务器
<!-- OCR_END -->

NTP（Network Time Protocol，网络时间协议）是用来使网络中的各个计算机时间同步的一种协议。它的用途是把计算机的时钟同步到世界协调时UTC，其精度在局域网内可达0.1ms，在互联网上绝大多数的地方其精度可以达到1-50ms。

NTP服务器就是利用NTP协议提供时间同步服务的。 ntp软件（支持ntp协议） CentOS6自带 CentOS7需要安装的 chrony软件（支持ntp协议） CentOS7自带

NTP基于UDP报文进行传输，使用的UDP端口号为123。

使用NTP的目的是对网络内所有具有时钟的设备进行时钟同步，使网络内所有设备的时钟保持一致，从而使设备能够提供基于统一时间的多种应用。

对于运行NTP的本地系统，既可以接受来自其他时钟源的同步，又可以作为时钟源同步其他的时钟，并且可以和其他设备互相同步。

## NTP的应用
对于网络中的各台设备来说，如果依靠管理员手工输入命令来修改系统时钟是不可能的，不但工作量巨大，而且也不能保证时钟的精确性。通过NTP，可以很快将网络中设备的时钟同步，同时也能保证很高的精度。 NTP主要应用于需要网络中所有设备时钟保持一致的场合，比如：

+ 在网络管理中，对于从不同设备采集来的日志信息、调试信息进行分析的时候，需要以时间作为参照依据。如nginx的访客日志
+ 计费系统要求所有设备的时钟保持一致。
+ 完成某些功能，如定时重启网络中的所有设备，此时要求所有设备的时钟保持一致。
+ 多个系统协同处理同一个比较复杂的事件时，为保证正确的执行顺序，多个系统必须参考同一时钟。
+ 在备份服务器和客户端之间进行增量备份时，要求备份服务器和所有客户端之间的时钟同步。

## 环境准备
准备一台linux虚拟机，且安装ntp服务

```plain
yum install ntp -y
[root@master-70 ~]# rpm -ql ntp |grep conf
/etc/ntp.conf
/etc/sysconfig/ntpd
/usr/share/man/man5/ntp.conf.5.gz
```

### 修改ntp配置文件
【权限控制】

```plain
在 ntp.conf 档案内可以利用『 restrict 』来控管权限，这个参数的设定方式为：
restrict [你的IP] mask [netmask_IP] [parameter]
其中 parameter 的参数主要有底下这些：
ignore： 拒绝所有类型的 NTP 联机；
nomodify： 客户端不能使用 ntpc 与 ntpq 这两支程序来修改服务器的时间参数， 但客户端仍可透过这部主机来进行网络校时的；
noquery： 客户端不能够使用 ntpq, ntpc 等指令来查询时间服务器，等于不提供 NTP 的网络校时啰；
notrap： 不提供 trap 这个远程事件登录 (remote event logging) 的功能。
notrust： 拒绝没有认证的客户端。
那如果你没有在 parameter 的地方加上任何参数的话，这表示『该 IP 或网段不受任何限制』的意思喔！一般来说，我们可以先关闭 NTP 的权限，然后再一个一个的启用允许登入的网段。
```

```plain
# 修改配置文件
vim  /etc/ntp.conf 
  6 # Permit time synchronization with our time source, but do not
  7 # permit the source to query or modify the service on this system.
  8 # restrict default nomodify notrap nopeer noquery
  9 restrict default nomodify
```

【server设定上游服务器】

```plain
上层 NTP 服务器的设定方式为：
server [IP or hostname] [prefer]
在 server 后端可以接 IP 或主机名，个人比较喜欢使用 IP 来设定说！至于那个 perfer 表示『优先使用』的服务器。
iburst 当一个运程NTP服务器不可用时，向它发送一系列的并发包进行检测。
 20 # Use public servers from the pool.ntp.org project.
 21 # Please consider joining the pool (http://www.pool.ntp.org/join.html).
 22 #server 0.centos.pool.ntp.org iburst
 23 #server 1.centos.pool.ntp.org iburst
 24 #server 2.centos.pool.ntp.org iburst
 25 #server 3.centos.pool.ntp.org iburst
 26 server ntp1.aliyun.com iburst
 27 server ntp2.aliyun.com iburst
 28 server ntp3.aliyun.com iburst
```

## 启动ntp
```plain
[root@master-70 ~]# systemctl start ntpd
[root@master-70 ~]# systemctl is-active ntpd
active
```

【观察ntpd服务端】

```plain
[root@master-70 ~]# netstat -tunlp|grep ntp
udp        0      0 172.17.0.1:123          0.0.0.0:*                           4408/ntpd
udp        0      0 172.20.0.70:123         0.0.0.0:*                           4408/ntpd
udp        0      0 127.0.0.1:123           0.0.0.0:*                           4408/ntpd
udp        0      0 0.0.0.0:123             0.0.0.0:*                           4408/ntpd
udp6       0      0 fe80::3c1d:54eb:697:123 :::*                                4408/ntpd
udp6       0      0 ::1:123                 :::*                                4408/ntpd
udp6       0      0 :::123                  :::*                                4408/ntpd
主要是udp封包，且是在123端口，这就表示ntp服务启动了
```

### ntpstat
可以使用ntpstat命令检测NTP服务到期是否和上游机器通信。

```plain
[root@master-70 ~]# ntpstat
synchronised to NTP server (120.25.115.20) at stratum 3
   time correct to within 964 ms
   polling server every 64 s
这里表示和上游服务器的校准时间是964毫秒，1秒=1000毫秒
且会隔64秒进行主动更新时间
```

### ntpq
该命令可以列出我们NTP服务器和上游NTP的状态。

```plain
[root@master-70 ~]# ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
*120.25.115.20   10.137.53.7      2 u    4   64    1   41.932   -0.187   0.388
 203.107.6.88    100.107.25.114   2 u    3   64    1   14.751   -0.931   0.857
 这个 ntpq -p 可以列出目前我们的 NTP 与相关的上层 NTP 的状态，上头的几个字段的意义为：
remote：亦即是 NTP 主机的 IP 或主机名啰～注意最左边的符号
如果有『 * 』代表目前正在作用当中的上层 NTP
如果是『 + 』代表也有连上线，而且可作为下一个提供时间更新的候选者。
refid：参考的上一层 NTP 主机的地址
st：就是 stratum 阶层啰！
when：几秒钟前曾经做过时间同步化更新的动作；
poll：下一次更新在几秒钟之后；
reach：已经向上层 NTP 服务器要求更新的次数
delay：网络传输过程当中延迟的时间，单位为 10^(-6) 秒
offset：时间补偿的结果，单位与 10^(-3) ，单位，毫秒
jitter：Linux 系统时间与 BIOS 硬件时间的差异时间， 单位为 10^(-6) 秒。
这里的时间已经非常精确了
```

要注意服务器的123端口正确开放，你自己的NTP服务器正确的连接了上层NTP服务器。

```plain
[root@master-70 ~]# ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
*120.25.115.20   10.137.53.7      2 u  103  128  377   44.820    0.206  75.029
+203.107.6.88    10.137.38.86     2 u  112  128   37   15.475    0.601  39.386
[root@master-70 ~]#
[root@master-70 ~]#
```

## 客户端配置
上面介绍了NTP服务器的安装与设定，如果客户端机器数量较少时，是没必要配置NTP服务器的，但是若是搭建计算机集群系统，那么使用时间服务器是很合适的。

### Linux手动时间更新
我们在之前学过Linux时间管理命令，且Linux系统有两个时间：

+ 软件时间：Linux自己的时间，从1970/01/01开始
+ 硬件时间：计算机系统在BIOS记录的时间

### 软件时间date
```plain
查看当前系统时间
[root@master-70 ~]# date
2020年 07月 15日 星期三 02:00:04 EDT
# 这里注意，超哥linux机器当前时间是EDT时区，是美国时间，差了北京时间12个小时
# 修改时区操作
[root@master-70 ~]# mv /etc/localtime /etc/localtime.bak
[root@master-70 ~]# ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
[root@master-70 ~]# date
2020年 07月 15日 星期三 17:01:36 CST
```

回退时间到前一小时

```plain
[root@master-70 ~]# date
2020年 07月 15日 星期三 17:01:36 CST
# 上述修改时间的格式是 
date  月份日期小时分钟年份
date MMDDhhmmYYYY
MM 月份
DD 日期
hh 小时
mm 分钟
YYYY 年份
# 时间回到上一小时
[root@master-70 ~]# date 071516002020  
2020年 07月 15日 星期三 16:00:00 CST
```

### hwclock
查看，修改BIOS的时间

在修改软件始终方面，我们是通过date命令修改，如果要修改BIOS时间，得用hwclock指令

```plain
两个参数
-r  read 读取BIOS时间
-w  写入，当前linux时间将写入BIOS中
```

> 更新: 2022-12-21 12:36:06  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/en0sqt>