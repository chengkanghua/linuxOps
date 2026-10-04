# 时间服务器与 VPN

> 这一章讲两件运维工作里非常实用的事：一是用 VPN 在公网上打通一条安全的"专用通道"，二是用 NTP 让全网机器的时间保持一致。前半部分弄懂 VPN 的原理，并用 OpenVPN 动手搭一套远程接入；后半部分掌握 NTP 时间服务器的搭建、状态查看与客户端时间管理。

## 本章目录

**第一篇 · VPN 虚拟专用网络**
- 一、VPN 的作用
- 二、VPN 介绍
- 三、VPN 分类
- 四、VPN 隧道协议
- 五、VPN 服务实践
- 六、VPN 客户端部署

**第二篇 · NTP 时间服务器**
- 七、时间服务器
- 八、NTP 时间协议
- 九、NTP 的应用
- 十、环境准备与服务端配置
- 十一、启动 NTP 与状态查看
- 十二、客户端配置与手动时间管理

---

# 第一篇 · VPN 虚拟专用网络

## 一、VPN 的作用

VPN 是 **Virtual Private Network（虚拟专用网络）** 的缩写。一面盾牌上写着这三个单词，正好点明它最核心的价值——安全：在公开的互联网上，为你的数据撑起一条加密的专用通道。

### 能够访问墙外的内容

很多国外网站和服务（如 Google、YouTube、Facebook、Twitter）在国内无法直接打开。借助 VPN，可以绕过这种网络访问限制，正常访问这些"墙外"的内容。

### 虚拟网络隧道

VPN 会在你的设备和目标网络之间建立一条虚拟隧道。即使数据要穿过防火墙、经过公共互联网，隧道里的数据也是被封装和加密过的——外面的人只能看到一条隧道，看不到里面具体传了什么。

### 隧道数据传输

进入隧道后，所有数据——聊天消息、邮件、购物订单、银行卡信息——都以加密形式传输。可以把它想象成一根内壁写满密文的管道：数据从这头进去、从那头出来，中途即使被截获也无法读懂。

### 保护服务器安全

VPN 还能把访问者"藏"在盾牌后面安全地连接服务器：企业可以把重要服务器放在内网，只允许通过 VPN 接入的授权用户访问，避免这些服务器直接暴露在公网上被人扫描和攻击。

## 二、VPN 介绍
VPN 直译就是虚拟专用通道，是提供给企业之间或者个人与公司之间**安全数据传输**的隧道。

虚拟私有网络（VPN）隧道，是通过 Internet 隧道技术将两个不同地理位置的网络安全地连接起来的技术。

当两个网络是使用私有 IP 地址的私有局域网络时，它们之间是不能相互访问的，这时使用隧道技术就可以使得两个子网内的主机进行通讯。VPN 隧道技术经常被用于大型机构中不同办公区域子网的连接。

有时，使用 VPN 隧道仅仅是因为它很安全。服务提供商与公司会使用这样一种方式架设网络，他们将重要的服务器（如，数据库，VoIP，银行服务器）放置到一个子网内，仅仅让有权限的用户通过 VPN 隧道进行访问。

VPN（虚拟专用网）发展至今已经不再是一个单纯的、经过加密的访问隧道了，它已经融合了**访问控制**、**传输管理**、**加密**、**路由选择**、**可用性管理**等多种功能，并在全球的信息安全体系中发挥着重要的作用。在网络上，有关各种 VPN 协议优缺点的比较仁者见仁、智者见智，很多技术人员出于实际使用目的考虑，要在访问控制、安全性、用户易用性、灵活扩展等各方面权衡利弊，难以取舍；尤其在 VOIP 语音环境中，网络安全显得尤为重要，因此现在越来越多的网络电话和语音网关支持 VPN 协议。

下图对比了"物理专线"和"VPN 虚拟专用线路"两种方式：上海办事处的 PC 主机要访问北京办事处的服务器，贵重的数据包既可以走顶部昂贵的专用线路，也可以走底部在互联网上建立的虚拟专用线路。

```plaintext
                          ┌──────────┐
                          │ 专用线路  │
   ┌────────────┐         └──────────┘         ┌────────────┐
   │ 上海办事处   │ ─────────────────────────▶ │ 北京办事处   │
   │  PC 主机    │                            │   服务器    │
   └────────────┘                            └────────────┘
         │                                        ▲
         │───────▶ 〔 互 联 网 络 〕───────────────┤
         │                                        │
         │  [数据包-贵重]                          │
         └──────▶〔虚拟专用线路〕──────────────────┘
```

普通互联网传输就像普通快递：各家的包裹成堆放在一起传递；物理专线则像用私人飞机专运一颗价值连城的夜明珠，安全性极高，但费用也极其昂贵。而 VPN 这条"虚拟专用线路"，正是在廉价的公网上模拟出专线级别的安全。

> 📌 一句话理解：**VPN = 在便宜的公网上，跑出昂贵专线的安全性。**

### VPN 示意图

一个典型的企业 VPN 场景：总部内网通过 UTT 3640 网关接入互联网，各个分点（分点 1、分点 4……）的 U2000 网关以及出差人员，都通过在 Internet 上建立的 VPN 隧道安全地连回总部。

```plaintext
                    ┌──────────── 总部 ────────────┐
                    │  服务器组（服务器 + 办公 PC）   │
                    └──────────────┬───────────────┘
                                UTT 3640
                                   │
   ══════════ VPN ══════════│══════════ VPN ══════════ Internet
              │               │              │
          〔分点 1〕       〔出差人员〕      〔分点 4〕
           U2000            (便携电脑)       U2000
         (内网 PC ……)                     (内网 PC ……)
```

## 三、VPN 分类
企业环境中，一般根据 VPN 的应用领域不同，把 VPN 划分为 4 类应用。

### 1. 主机远程访问 VPN 服务

这个场景一般用于超哥出差、休假等特殊情况下远程办公：需要访问公司内部网络时，可以通过 VPN 拨号接入公司内网。此时远程的超哥和办公室里的同事，就相当于处在同一个局域网里。

人在家中，就可以访问公司内网的文件服务器、OA 办公系统、ERP、HTTP 服务等各种局域网应用。

```plaintext
   ┌───────────┐   ┌───────────────┐
   │ Home User │   │ Remote Worker │
   └─────┬─────┘   └───────┬───────┘
         └────────┬────────┘
             ╔════╧════╗
             ║Internet ║
             ╚════╤════╝
                  │
            [Firewall] ──▶ [Office] ──▶ File Server / Intranet
```

对于运维人员来说，则是用个人电脑拨号到企业的 IDC 机房，远程维护服务器。

这是运维人员最常采用的方式，用来维护企业里那些没有外网 IP 地址的服务器等设备。

### 2. 企业网络之间的 VPN 服务

在公司分支机构的局域网和公司总部的 LAN 之间建立 VPN 连接，通过公网 Internet 把各地分部的 LAN 连到总部的 LAN。

比如全国各地连锁超市的业务结算系统。

由于地域相隔，通过 VPN 把不同地域的机器连起来互相访问，用起来就像在同一个局域网内。

### 3. 企业多 IDC 机房之间的 VPN

用于不同机房之间的业务管理和业务访问的数据传输。

### 4. 企业外部 VPN 服务

在全球供应商、合作伙伴的 LAN 与本部公司的 LAN 之间建立 VPN。

## 四、VPN 隧道协议
### PPTP
**点对点隧道协议（PPTP）** 是由包括微软和 3Com 等公司组成的 PPTP 论坛开发的一种点对点隧道协议，基于拨号使用的 PPP 协议使用 PAP 或 CHAP 之类的加密算法，或者使用 Microsoft 的点对点加密算法 MPPE。其通过跨越基于 TCP/IP 的数据网络创建 VPN 实现了从远程客户端到专用企业服务器之间数据的安全传输。PPTP 支持通过公共网络(例如 Internet)建立按需的、多协议的、虚拟专用网络。PPTP 允许加密 IP 通讯，然后在要跨越公司 IP 网络或公共 IP 网络(如 Internet)发送的 IP 头中对其进行封装。

Linux 平台上典型的开源实现就是 PPTP。

PPTP 属于点对点方式的应用，适合用户远程拨号到企业内部办公。

下面是一个站点到站点（Site-to-Site）的 PPTP 示例：两台路由器 R1、R2 各自接入互联网，并在彼此之间建立一条 PPTP 隧道，让两个内网可以互通。

```plaintext
                        ╔══════════╗
                        ║ Internet ║
                        ╚════╤═════╝
              172.22.22.1 ╱  ╲ 172.22.22.2
              ┌─────────┐╱  PPTP  ╲┌─────────┐
              │R1 Router│  Tunnel  │R2 Router│
              └────┬────┘          └────┬────┘
       10.10.10.0/24              10.10.11.0/24
        .2  .3  .4 ...                  .2 ...
```

| 设备 | 隧道地址 | WAN 地址 | 内网网段 |
| --- | --- | --- | --- |
| **R1 Router** | 172.22.22.1 | 192.168.30.2/30 | Local：10.10.10.0/24（主机 .2 / .3 / .4） |
| **R2 Router** | 172.22.22.2 | 192.168.40.2/30 | LAN：10.10.11.0/24（主机 10.10.11.2） |

**点对点隧道协议(PPTP，Point-to-Point Tunneling Protocol)将点对点协议(PPP，Point-to-Point Protocol)的数据帧封装进 IP 数据包中，通过 TCP／IP 网络进行传输**。PPTP 可以对 IP、IPX 或 NetBEUI 数据进行加密传递。PPTP 通过 PPTP 控制连接来创建、维护和终止一条隧道，并使用通用路由封装(GRE，Generic Routing Encapsulation)对 PPP 数据帧进行封装。封装前，PPP 数据帧的有效载荷(有效传输数据)首先必须经过加密、压缩或是两者的混合处理。

### L2TP
**第 2 层隧道协议（L2TP）** 是 IETF 基于 L2F（Cisco 的第二层转发协议）开发的、PPTP 的后续版本。是一种工业标准 Internet 隧道协议，其可以为跨越面向数据包的媒体发送点到点协议 (PPP) 框架提供封装。PPTP 和 L2TP 都使用 PPP 协议对数据进行封装，然后添加附加包头用于数据在互联网络上的传输。**PPTP 只能在两端点间建立单一隧道。 L2TP 支持在两端点间使用多隧道，用户可以针对不同的服务质量创建不同的隧道**。**L2TP 可以提供隧道验证，而 PPTP 则不支持隧道验证**。**但是当 L2TP 或 PPTP 与 IPSEC 共同使用时，可以由 IPSEC 提供隧道验证，不需要在第2层协议上验证隧道使用 L2TP**。 **PPTP 要求互联网络为 IP 网络**。L2TP 只要求隧道媒介提供面向数据包的点对点的连接，L2TP 可以在 IP(使用UDP)，帧中继永久虚拟电路 (PVCs), X.25 虚拟电路(VCs)或 ATM VCs 网络上使用。

实际部署时 L2TP 通常和 IPsec 配合使用：内网主机到安全网关这一段是未加密的，网关之间跨越 Internet 的 VPN 隧道则由 IPsec 加密。

```plaintext
 Internal
 hosts ────(Not encrypted)────▶[Security Gateway]
                                 │
                  VPN Tunnel (IPsec) ── Encrypted
                                 │
                            ╔════╧════╗
                            ║ Internet ║
                            ╚════╤════╝
                       Remote IPsec Client
```

L2TP 和 PPTP 都是隧道协议，核心区别在于：**L2TP 可以提供隧道验证，而 PPTP 不支持隧道验证**。

### IPSec
**IPSec** 隧道的整个过程由**封装**、**路由**与**解封装**组成。隧道将原始数据包隐藏(或封装)在新的数据包内部。该新的数据包可能会有新的寻址与路由信息，从而使其能够通过网络传输。

隧道与数据保密性结合使用时，在网络上窃听通讯的人将无法获取原始数据包数据(以及原始的源和目标)。封装的数据包到达目的地后，会删除封装，原始数据包头用于将数据包路由到最终目的地。

IPSec 有两种工作模式，区别在于"谁来加密、加密到哪一层"：

```plaintext
  主机 A ◇═════════ Transport Mode ═════════◇ 主机 B
          (端到端，直接加密主机之间的报文)

  主机 A ──▶[Gateway] ◀═══ Tunnel Mode ═══▶[Gateway] ◀── 主机 B
                    (网关之间加密整个报文)
```

| 模式 | 加密范围 | 典型场景 |
| --- | --- | --- |
| **传输模式 Transport Mode** | 只加密 IP 报文的载荷，保留原始 IP 头 | 两台主机之间端到端通信 |
| **隧道模式 Tunnel Mode** | 整个原始 IP 报文被封装并加密，外层再套一个新 IP 头 | 两个安全网关之间建立站点 VPN |

### SSL VPN
SSL 协议提供了数据**私密性**、**端点验证**、**信息完整性**等特性。SSL 协议由许多子协议组成，其中两个主要的子协议是**握手协议**和**记录协议**。握手协议允许服务器和客户端在应用协议传输第一个数据字节以前，彼此确认，协商一种加密算法和密码钥匙。

在数据传输期间，记录协议利用握手协议生成的密钥加密和解密后来交换的数据。

SSL 独立于应用，因此任何一个应用程序都可以享受它的安全性而不必理会执行细节。SSL 置身于网络结构体系的**传输层**和**应用层**之间。此外，SSL 本身就被几乎所有的 Web 浏览器支持。这意味着客户端不需要为了支持 SSL 连接安装额外的软件。这两个特征就是 SSL 能应用于 VPN 的关键点。

下图是一个 SSL VPN 的接入示例：远程用户既可以用专用客户端（FortiClient），也可以直接用浏览器访问 Web Portal，两种方式都通过 SSL VPN 连入 FortiGate 网关，再进入内部网络。

```plaintext
 Remote user ──[FortiClient]──┐
                              ├──▶ SSL VPN ──▶┌──────────┐
 Remote user ──[ Web Portal ]─┘     WAN1       │FortiGate │──▶ Internal Network
                          (浏览器) 172.20.120.123 └──────────┘
                                              Port1 192.168.1.99/24
```

| 角色 | 地址 / 说明 |
| --- | --- |
| Remote user（远程用户） | 通过 FortiClient 客户端或 Web Portal 浏览器接入 |
| FortiGate WAN1 | 172.20.120.123（外网侧） |
| FortiGate Port 1 | 192.168.1.99/24（内网侧） |
| Internal Network | 接入后可访问的内部网络 |

### IPSec 和 SSL VPN 的区别

下图把两种 VPN 放在一起对比：IPSec 需要安装专用客户端，接入后直接开放授权的整个子网；SSL VPN 用任意浏览器即可，由网关做更细粒度的资源控制。

```plaintext
 Remote User                 ① IPsec VPN/Firewall      ② Corporate Network
 With IPsec Client ══IPSec Tunnel══▶ [设备] ═══════▶ Permitted Subnet(s)

 Remote User     Firewall ③ SSL VPN Gateway
 With Any Browser ═SSL/TLS Tunnel══▶[砖墙][网关] ┬─④─▶ Exchange Server / User's Mailbox
                                               └─⑤─▶ Intranet Server
                                                     Permitted URLs/Objects
```

- **① IPsec VPN/Firewall**：用户端到企业边界的 IPsec 设备；
- **② Permitted Subnet(s)**：接入后可访问的企业授权子网；
- **③ SSL VPN Gateway**：部署在防火墙后的 SSL VPN 网关；
- **④ Exchange Server**：可被授权访问的邮件服务器及用户邮箱；
- **⑤ Intranet Server / Permitted URLs/Objects**：按策略开放的内网服务器、URL 和具体资源。

## 五、VPN 服务实践
利用虚拟专用网络，实现让外网主机获得架构中内网地址信息，实现利用内网地址进行数据传递

### 机器准备
```bash
windows主机    外网主机        10.0.1.1 （模拟公网地址）
vpnserver主机                 10.0.1.63（模拟公网地址）          172.20.1.63（模拟私网地址）
web01                                                  172.20.1.7 （模拟私网地址）
```

PS：确保每台主机时间做好正确同步

整个部署架构分为两部分：客户端和服务端。

### VPN 服务端部署

准备好一台 Linux 虚拟机。

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

服务器需要准备 2 块网卡：一块模拟公网，一块模拟局域网，在 VMware 里添加即可。

这里 macOS 和 Windows 的网卡 NAT 添加方式有区别。

Windows 的 VMware Workstation 添加方式比较简单。

macOS 的方式如下。

也可以看超哥的博客：[https://www.cnblogs.com/pyyu/p/9689138.html](https://www.cnblogs.com/pyyu/p/9689138.html)

### macOS 自定义 VMware 网络——外网
```bash
内网  172.20.1.63 仅主机模式
外网     10.0.1.63   NAT模式
```

1. VMware Fusion 偏好设置，添加 NAT 自定义网络。

打开"偏好设置"，新建一个自定义网络 vmnet2，勾选"允许该网络上的虚拟机连接到外部网络（使用 NAT）"，子网 IP 填 10.0.1.0、子网掩码 255.255.255.0，并关闭该网络的 DHCP（后面由我们手动配置静态 IP）。

| 配置项 | 值 |
| --- | --- |
| 网络名称 | vmnet2 |
| 子网 IP | 10.0.1.0 |
| 子网掩码 | 255.255.255.0 |
| NAT | 勾选（允许连接外部网络） |
| DHCP | 关闭 |

2. 网络适配器 1，选择 vmnet2 网络连接。

在虚拟机的网络适配器设置中，选择"自定（vmnet2）"，而不是默认的 NAT / 桥接 / 仅主机模式。

3. 虚拟机连接。

在弹出的网络适配器配置窗口中确认：名称 vmnet2、类型自定、子网 IP 10.0.1.0、子网掩码 255.255.255.0，即表示该适配器已使用自定义网络。

4. CentOS 的网卡配置文件 ifcfg-ens33。

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

正确设置后，确保 client-server 能够通信。

```bash
[yuchao@yumac vmnet2]$ping 10.0.1.63
PING 10.0.1.63 (10.0.1.63): 56 data bytes
64 bytes from 10.0.1.63: icmp_seq=0 ttl=64 time=0.365 ms
64 bytes from 10.0.1.63: icmp_seq=1 ttl=64 time=0.539 ms
```

### macOS 设置仅主机网络——内网

再添加一个网络设备，即添加第二块网卡。

在"添加设备"中选择网络适配器，网络适配器 2 选择"仅供我的 Mac 专用"（仅主机模式），其 MAC 地址会在下方显示，需要和后面 CentOS 配置保持一致。
macOS 的 VMware Fusion 仅主机模式对应设备如下：

- vmnet1：仅主机，改成下面这样的配置；
- vmnet2：NAT。

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

拷贝 ifcfg-ens33，改名为 ifcfg-ens37。

在 CentOS 内针对仅主机的网络适配器，添加第二块网卡的配置文件。

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

### VPN 服务端软件部署

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

历经千辛万苦，服务端终于整好了，跟着超哥继续向下学。

### 启动服务端

#### 修改内核转发
```bash
1.添加内核转发参数
vim /etc/sysctl.conf

net.ipv4.ip_forward = 1

2.生效
sysctl -p
```

#### 编写 systemd 单元并启动服务

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

如果报错，检查配置文件，和超哥的文档逐项对比。


## 六、VPN 客户端部署

下载客户端，各个操作系统都有对应的版本：

[https://openvpn.net/download-open-vpn/](https://openvpn.net/download-open-vpn/)

### 修改客户端配置文件

只需要指定 OpenVPN 服务端的信息即可。

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

此时就可以在 Windows 中下载这些配置文件了。

下载完成后，在本地 openvpn 目录里能看到三个文件：

| 文件 | 作用 |
| --- | --- |
| ca.crt | CA 根证书 |
| client01.crt | 客户端证书 |
| client01.key | 客户端私钥 |

另外还需要一个 ovpn 文件，也可以直接手动生成。

即 client01.ovpn 文件。

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

把 client01.ovpn 也放进同一个目录后，文件夹里就凑齐了四个文件：ca.crt（安全证书）、client01.crt（约 5KB）、client01.key（KEY 文件）和 client01.ovpn（OVPN Profile，约 1KB）。

### 启动 OpenVPN 客户端

**OpenVPN 需要手动设置 IP 地址，因为前面关闭了 DHCP 功能。**

通过 OpenVPN 发起连接，连接成功后，就已经进入 VPN 的内网环境了。

```bash
可以检查网络情况。

1.服务端的隧道网段
6: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none
    inet 10.8.0.1/24 brd 10.8.0.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::e6f3:8f47:c9a4:37f5/64 scope link flags 800
       valid_lft forever preferred_lft forever
[root@vpn_server client01]#
```

客户端尝试与 VPN 网络隧道通信。

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

这张全景截图同时展示了服务端、客户端和连接状态三部分信息。

Linux 服务端的三块网卡：

| 网卡 | IP 地址 | 含义 |
| --- | --- | --- |
| ens33 | 10.0.1.63/24 | 模拟公网 IP |
| ens37 | 172.20.1.63/24 | 模拟内网 IP |
| tun0 | 10.8.0.1/24 | VPN 隧道网段（服务端地址） |

Windows 客户端的 IP 配置：

| 适配器 | IPv4 地址 | 含义 |
| --- | --- | --- |
| 未知适配器 本地连接 | 10.8.0.2 / 255.255.255.0 | 获取到的 VPN 隧道 IP |
| Ethernet0 | 10.0.1.69，网关 10.0.1.2 | Windows 客户端物理网卡 IP |

OpenVPN Connect 客户端显示状态为 CONNECTED，连接的配置为 10.0.1.63 [client01]，分配到的私有 IP 为 10.8.0.2。

此时在 Windows 上 ping 内网地址 172.20.1.63，4 个包全部收到、0% 丢失；在服务端 `tail -f /var/log/openvpn*` 也能看到 "Initialization Sequence Completed" 和客户端列表记录——说明因为连上了 VPN，客户端已经可以和内网正常通信。

### 通过 HTTP 服务验证 VPN 是否成功

```bash
1.在linux上启动80服务

[root@vpn_server client01]#  python -m SimpleHTTPServer 80

Serving HTTP on 0.0.0.0 port 80 ...
```

2.windows上访问该VPN的地址（分别尝试，连接、断开VPN）

未连接 VPN 时（OpenVPN Connect 显示 DISCONNECTED），在浏览器访问 `http://10.8.0.1` 会提示"无法访问此页面"，无法获取 VPN 服务器上的内容。

连接上 VPN。

连接成功后（状态显示 CONNECTED），再次访问 `http://10.8.0.1`，浏览器会显示该目录的文件列表（Directory listing for /），可以看到 ca.crt、client01.crt、client01.key 三个文件，证明已经能访问 VPN 服务端的内容了。


---

# 第二篇 · NTP 时间服务器

## 七、时间服务器

时间对人类的作息非常重要：按时起床、按时上班、赶火车、火箭发射，都需要对时间的精准把控。

再比如卫星运转、监控、交换机、计算机系统时间等，也都离不开精准的时间同步。

为什么每次计算机重启之后，时间还能保持正确呢？因为电脑主板上有一块专门给 BIOS 供电的电池。一旦电池没电，或者因某些原因导致 BIOS 数据被清空，电脑开机后的时间就不准了。

又或者是操作系统本身的问题，软件层面导致时间不准，这时也需要手动调整时间，让计算机保持正确状态。

生活中我们可以通过电视台、广播站、电话等来校准手表等计时器。那么当计算机时间不准时，又该如何让主机时间恢复正确呢？

时间对现代人来说很重要，正所谓 "Time is money"。既然时间如此重要，对互联网而言想必同样重要吧？

## 八、NTP 时间协议

时间服务器可以直接让所有客户端去公网同步，也可以先由内网时间服务器向公网同步，再分发给内网客户端——后者是企业集群更常用的两级结构：

```plaintext
方案一：直连公网
                    公网时间服务器
                 ┌───┬───┴───┬───┐
               主机 主机     主机 主机

方案二：内网服务器中转（推荐）
                    公网时间服务器
                         │
                    内网时间服务器
                 ┌───┬───┴───┬───┐
               主机 主机     主机 主机
```

NTP（Network Time Protocol，网络时间协议）是用来让网络中各台计算机时间同步的协议。它的作用是把计算机时钟同步到世界协调时 UTC，精度在局域网内可达 0.1ms，在互联网上绝大多数地方也能达到 1-50ms。

NTP 服务器就是利用 NTP 协议提供时间同步服务的主机。常见的服务端软件有两种：ntp 软件（支持 NTP 协议，CentOS 6 自带，CentOS 7 需要安装）和 chrony 软件（支持 NTP 协议，CentOS 7 自带）。

NTP 基于 UDP 报文传输，使用的 UDP 端口号为 123。

使用 NTP 的目的，是对网络内所有带时钟的设备做时钟同步，让全网设备的时钟保持一致，从而支撑那些依赖统一时间的各类应用。

对于运行 NTP 的本地系统，它既可以接受其他时钟源的同步，也可以作为时钟源去同步别的时钟，还可以和其他设备互相同步。

## 九、NTP 的应用

对网络中的各台设备来说，如果靠管理员手工敲命令修改系统时钟，既不现实——工作量巨大——也无法保证时钟精确。通过 NTP，可以很快把全网设备的时钟同步好，同时保证很高的精度。NTP 主要应用于需要所有设备时钟一致的场合：

+ 在网络管理中，分析从不同设备采集来的日志、调试信息时，需要以时间作为参照依据，比如 nginx 的访客日志；
+ 计费系统要求所有设备的时钟保持一致；
+ 某些功能，比如定时重启网络中的所有设备，要求所有设备时钟一致；
+ 多个系统协同处理同一个复杂事件时，为保证正确的执行顺序，各系统必须参考同一时钟；
+ 在备份服务器和客户端之间做增量备份时，要求备份服务器和所有客户端时钟同步。

## 十、环境准备

准备一台 Linux 虚拟机，并安装 ntp 服务。

```plain
yum install ntp -y
[root@master-70 ~]# rpm -ql ntp |grep conf
/etc/ntp.conf
/etc/sysconfig/ntpd
/usr/share/man/man5/ntp.conf.5.gz
```

### 修改 NTP 配置文件

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

## 十一、启动 NTP
```plain
[root@master-70 ~]# systemctl start ntpd
[root@master-70 ~]# systemctl is-active ntpd
active
```

### 观察 ntpd 服务端

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

可以使用 ntpstat 命令检测 NTP 服务到底有没有和上游机器通信。

```plain
[root@master-70 ~]# ntpstat
synchronised to NTP server (120.25.115.20) at stratum 3
   time correct to within 964 ms
   polling server every 64 s
这里表示和上游服务器的校准时间是964毫秒，1秒=1000毫秒
且会隔64秒进行主动更新时间
```

### ntpq

该命令可以列出本机 NTP 服务器和上游 NTP 的状态。

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

要注意服务器的 123 端口已正确开放，且本机 NTP 服务器已经正确连接了上层 NTP 服务器。

```plain
[root@master-70 ~]# ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
*120.25.115.20   10.137.53.7      2 u  103  128  377   44.820    0.206  75.029
+203.107.6.88    10.137.38.86     2 u  112  128   37   15.475    0.601  39.386
[root@master-70 ~]#
[root@master-70 ~]#
```

## 十二、客户端配置

上面介绍了 NTP 服务器的安装与设置。如果客户端机器数量很少，其实没必要单独配置 NTP 服务器；但如果要搭建计算机集群系统，使用时间服务器就非常合适。

### Linux 手动时间更新

我们之前学过 Linux 的时间管理命令。Linux 系统里有两个时间：

+ 软件时间：Linux 自己维护的时间，从 1970/01/01 开始计时；
+ 硬件时间：计算机系统在 BIOS 里记录的时间。

### 软件时间 date
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

把时间回退一小时。

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

查看、修改 BIOS 的时间。

修改软件时钟是通过 date 命令；如果要修改 BIOS 时间，则要用 hwclock 指令。

```plain
两个参数
-r  read 读取BIOS时间
-w  写入，当前linux时间将写入BIOS中
```

> 更新: 2022-12-21 12:36:06  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/en0sqt>