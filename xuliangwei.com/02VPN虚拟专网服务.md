# 02 VPN虚拟专网服务

# 02 VPN虚拟专网服务

* [1.VPN应用场景](http://kt.xuliangwei.com/15099321047799.html#toc_0)
* [2.VPN服务端配置](http://kt.xuliangwei.com/15099321047799.html#toc_1)
* [3.Win客户端配置](http://kt.xuliangwei.com/15099321047799.html#toc_2)
* [4.Linux客户端配置](http://kt.xuliangwei.com/15099321047799.html#toc_3)
* [5.VPN连接故障](http://kt.xuliangwei.com/15099321047799.html#toc_4)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 1.VPN应用场景

<!-- OCR_START -->
- VPN应用模式一：外网用户访问内部资源
- Internet
- VPN服务器
- 内部网络
- 外部用户
<!-- OCR_END -->

## 2.VPN服务端配置

**实验环境介绍**

<!-- OCR_START -->
- 连接VPN
- ftp服务器
- 内网互通
- eth1:172.16.56.12
- 分配172.16网段地址
- Win客户端
- VPN服务器
- 192.168.56.100
- eth0:192.168.56.11
- eth1: 172.16.56.11
- web服务器
- eth1:172.16.56.13
<!-- OCR_END -->

# 02 VPN虚拟专网服务

**实验环境规划**

| 角色 | 外网IP(NAT) | 内网IP(LAN) |
| :--- | :--- | :--- |
| VPN-Server | eth0:192.168.56.11(公网) | eth1:172.16.56.11 |
| 内网服务器(A) | | eth1:172.16.56.12 |
| 内网服务器(B) | | eth1:172.16.56.13 |

环境准备:

```plain
[root@vpn-server ~]# systemctl stop firewalld
[root@vpn-server ~]# systemctl disable firewalld
[root@vpn-server ~]# setenforce 0
[root@vpn-server ~]# getenforce
Disabled
```

1.配置`epel`源, 安装`pptp VPN`相关软件

```plain
[root@vpn-server ~]# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
[root@vpn-server ~]# yum install ppp pptp pptpd -y
```

2.开启内核转发功能

```plain
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
[root@vpn-server ~]# sysctl -p
```

3.配置客户端上网`DNS`, 如客户端不需要分配`DNS`可不配置

```plain
[root@vpn-server ~]# vim /etc/ppp/options.pptpd +68
ms-dns 223.5.5.5
```

4.设置`VPN`拨号的账号密码

```plain
[root@vpn-server ~]# vim /etc/ppp/chap-secrets
# Secrets for authentication using CHAP
# client    server  secret          IP addresses
bgx * 123456 *
```

5.分配`VPN`拨号地址段, 注意和内网相同地址

```plain
[root@vpn-server ~]# vim /etc/pptpd.conf
#添加本机公网IP（localip）
localip 192.168.56.11
#分配VPN用户的内网网段（remoteip）
remoteip 172.16.56.100-200
```

7.启动`pptpd`服务并加入开机自启动

```plain
[root@vpn-server ~]# systemctl start pptpd
[root@vpn-server ~]# systemctl enable pptpd
//检查tcp1723端口是否开启
[root@vpn-server ~]# ss -lntup | grep 1723
tcp    LISTEN     0   3    *:1723    *:*    users:(("pptpd",pid=3483,fd=6))
```

## 3.Win客户端配置

1.如果直接使用客户端连接内网地址是无法连接成功

<!-- OCR_START -->
- 计算机
- pass
- 管理员：C:1Windows\system32\cmd.exe
- C:\Usersxuliangwei>ping 172.16.56.11
- 网络
- 正在Ping172.16.56.11具有32字节的数据：
- 请求超时。
- 回收站
- 172.16.56.11的Ping统计信息：
- 数据包：已发送=4，已接收=0，丢失=4（100%丢失），
- Google
- Chrome
- C:\Usersxuliangwei>
- VMware
- Workstati...
- Xshell5
- ZoomIt64...
- 44
- 下午3:30
- 2017/11/29
<!-- OCR_END -->

2.打开网络共享中心，点击-->设置新的连接或网络

<!-- OCR_START -->
- 计算机
- 控制面板所有控制面板项网络和共享中心
- 搜索控制面板
- 文件（F)编辑（E）查看（V)工具（T）帮助（H)
- 控制面板主页
- 查看基本网络信息并设置连接
- 网络
- 更改适配器设置
- 查看完整映射
- 更改高级共享设置
- XULIANGWEID8EB
- Internet
- (此计算机)
- 回收站
- 查看活动网络
- 连接或断开连接
- Zoo
- 访问类型：
- 无法连接到Internet
- 工作网络
- 连接：
- 本地连接
- 更改网络设置
- Google
- Chrome
- 设置新的连接或网络
- 设置无线、宽带、拨号、临时或VPN连接；或设置路由器或访问点。
- 连接到网络
- 连接到或重新连接到无线、有线、拨号或VPN网络连接。
- VMware
- Workstati....
- 选择家庭组和共享选项
- 访问位于其他网络计算机上的文件和打印机，或更改共享设置。
- 另请参阅
- Internet选项
- 疑难解答
- Xshell 5
- Windows防火墙
- 诊断并修复网络问题，或获得故障排除信息。
- 家庭组
- 极域电子教清理垃圾
- 室软件v4.
- P46
- 下午3:27
- 2017/11/29
<!-- OCR_END -->

3.选择连接到工作区域

<!-- OCR_START -->
- 计算机
- 控制面板所有控制面板项网络和共享中心
- 搜索控制面板
- 文件（F)编辑（E）查看（V）工具（T）帮助（H）
- 控制面板主页
- 网络
- 设置连接或网络
- 更改适配器设置
- 更改高级共享设置
- 选择
- 个连接选项
- 回收站
- 连接到Internet
- 设置无线、宽带或拨号连接，连接到Internet。
- 设置新网络
- 配置新的路由器或访问点。
- Google
- 连接到工作区
- Chrome
- 设置到您的工作区的拨号或VPN连接。
- 设置拨号连接
- 使用拨号连接连接到Internet。
- VMware
- Workstati..
- 另请参阅
- Internet选项
- Xshell 5
- 下一步(N）
- Windows防火墙
- 取消
- 家庭组
- ZoomIt64..
- 下午3:31
- 40
- 2017/11/29
<!-- OCR_END -->

4.使用Internet连接到VPN服务

<!-- OCR_START -->
- 计算机
- 控制面板所有控制面板项网络和共享中心
- 搜索控制面板
- 文件（F)编辑（E）查看（V)工具（T)帮助（H）
- 控制面板主页
- 网络
- 连接到工作区
- 更改适配器设置
- 更改高级共享设置
- 您想如何连接？
- 回收站
- 使用我的Internet连接（VPN)(1)
- 通过Internet使用虚拟专用网络（VPN）来连接
- Google
- Chrome
- 直接拨号（D）
- 不通过Internet直接使用电话号码来连接。
- VMware
- Workstati..
- 什么是VPN连接？
- 另请参阅
- Internet选项
- Xshell 5
- Windows防火墙
- 取消
- 家庭组
- ZoomIt64..
- 下午3:33
- 40
- 2017/11/29
<!-- OCR_END -->

5.填写vpn地址以及名称,然后下一步

<!-- OCR_START -->
- 计算机
- pass
- 控制面板
- 所有控制面板项网络和共享中心
- 搜索控制面板
- 文件（F)编辑（E)
- 查看（V)
- 网络
- 连接到工作区
- 控制面板主页
- 更改适配器设置
- 键入要连接的Internet地址
- 更改高级共享设置
- 网络管理员可提供此地址。
- 回收站
- Internet地址1）：
- 192.168.56.11
- VPN-Servert地址
- 目标名称（E）：
- 随意名称
- Google
- Chrome
- 使用智能卡（S）
- 允许其他人使用此连接（A）
- 这个选项允许可以访问这台计算机的人使用此连接。
- VMware
- 现在不连接：仅进行设置以便稍后连接（D）
- Workstati..
- 另请参阅
- Xshell5
- 下一步(N)
- Internet选项
- 取消
- Windows防火墙
- 家庭组
- ZoomIt64..
- 39
- 下午3:36
- 2017/11/29
<!-- OCR_END -->

6.填写在VPN-Server上配置好的用户名以及密码, 然后点击连接

<!-- OCR_START -->
- 计算机
- pass
- 控制面板
- 搜索控制面板
- 网络
- 文件（F)编辑（E）
- 查看（V)
- 连接到工作区
- 控制面板主页
- 键入您的用户名和密码
- 更改适配器设置
- 回收站
- 更改高级共享设置
- 用户名（U）：
- xuliangwei
- 密码（P）：
- 123456
- 显示字符(S)
- 回记住此密码（R)
- Google
- Chrome
- 域（可选）D）：
- VMware
- Workstati..
- Xshell5
- 连接（C)
- 另请参阅
- 取消
- Internet选项
- 疑难解答
- Windows防火墙
- 诊断并修复网络问题，或获得故障排除信息。
- 家庭组
- ZoomIt64..
- 42
- 下午3:39
- 2017/11/29
<!-- OCR_END -->

7.VPN连接成功

<!-- OCR_START -->
- 计算机
- pass
- 控制面板
- 搜索控制面板
- 网络
- 文件（F编辑（E）
- 查看（V)
- 连接到工作区
- 控制面板主页
- 您已经连接
- 更改适配器设置
- 回收站
- 更改高级共享设置
- Google
- Chrome
- VMware
- Workstati..
- Xshell5
- 关闭（C)
- 另请参阅
- Internet选项
- 疑难解答
- Windows防火墙
- 诊断并修复网络问题，或获得故障排除信息。
- 家庭组
- ZoomIt64..
- 42
- 下午3:40
- 2017/11/29
<!-- OCR_END -->

# 02 VPN虚拟专网服务

8.测试是否能够连接100.100.1.50这台内网服务器,如图2-7

<!-- OCR_START -->
- 一口
- 控制面板网络和Internet网络连接
- 搜索网络连接
- 计算机
- pass
- 文件（F）编辑（E）查看（V)工具（T）高级（N）帮助（H）
- 管理员：C:\Windows\system32\cmd.exe-ping172.16.56.12
- 一回X
- ·口
- 随意名称
- C:Usersxuliangwei>ping172.16.56.12客户端已经能ping通内部的服务器
- WAN Miniport (PPTP)
- 正在Ping172.16.56.12具有32字节的数据：
- 来自172.16.56.12的回复：字节=32时间=2ms
- TTL=63
- 随意名称状态
- 来自
- 172.16.56.12的回复：字节=32时间=2msTTL=63
- 来自172.16.56.12的回复：字节=32时间=2msTTL=63
- 常规
- 详细信息
- 网络连接详细信息
- 属性
- 连接特定的DNS后缀
- 描述
- 物理地址
- VPN分配给客户端IP
- 已启用DHCP
- IPv4地址
- 172.16.56.100
- IPv4子网掩码
- 255.255.255.255
- IPv4默认网关
- IPv4DNS服务器
- IPv4WINS服务器
- 已启用NetBIOSove..
- 关闭(C)
- Zoomlt64.
- 4
- 下午3:41
- 2017/11/29
<!-- OCR_END -->

<!-- OCR_START -->
- vpn-56.12-root@node1:~-Xshell5
- 计算机
- pas
- 文件（F编辑（E）查看（V）工具（T）选项卡（B）窗口（W)帮助（H）
- 1vpn-56.12
- 网络
- [root@nodel ~]#
- [root@nodel ~]# ifconfig
- etho
- Link encaD:Ethernet
- HWaddr00:1C:42:74:19:6B
- 回收站
- inet addr:172.16.56.12
- Bcast:172.16.56.255 Mask:255.2
- 55.255.0
- inet6 addr: fe80::21c:42ff:fe74:196b/64 Sc0pe:Link
- Google
- UPBROADCASTRUNNINGMULTICASTMTU:1500
- ）Metric:1
- Chrome
- RX packets:1458 errors:0 dropped:0 overruns:0 frame:0
- TX packets:333 errors:0 dropped:0 overruns:0 carrier:0
- collisions:0 txqueuelen:1000
- VMware
- Workstat...
- RX bytes:158279 (154.5 KiB)
- TX bytes:41699 (40.7 KiB)
- lo
- Link encap:Local Loopback
- Xshell5
- 仅将文本发送到当前选项卡
- ssh://172.16.56.12:22
- SSH2
- xterm
- 65x14
- 14,17
- 1会话
- CAPNUM
- ZoomIt64.
- 下午3:42
- 2017/11/29
<!-- OCR_END -->

默认连接VPN是会通过VPN的默认网关来进行上网,我们取消默认使用VPN连接上网功能即可

<!-- OCR_START -->
- 计算机
- pass
- 控制面板网络和Internet网络连接
- 搜索网络连接
- 文件（F）
- 编辑（E）查看（V）
- 工具（T高级（N）帮助（H）
- 网络
- 组织
- 断开此连接
- 重命名此连接
- 查看此连接的状态
- 删除此连接
- 更改此连接的设置
- 品·
- VMwareNetworkAdapter
- 本地连接
- 随意名称
- VMnet1
- VMnet8
- 已禁用
- Intel(R)PRO/1000MTNetwor...
- 随意名称属性
- Internet协议版本4（TCP/IPv4）属性
- 高级TCP/IP设置
- 常规
- 选项安全
- 共享
- IP设置DNS
- WINS
- 此连接使用下列项目（0）：
- Internet协议版本6（TCP/IPv6）
- 如果网缝支持此功能：则可以获取自动指派的I设置。否
- 则，您需要从网络系统管理员处获得适当
- 中，不能发送到局域网上的数据将被转发到拨号网络上。
- Microsott网络的又件和打印机共享
- ③去掉勾选即可
- Ch
- Microsoft网络客户端
- 自动获得IP地址（0）
- 使用下面的IP地址（S）：
- 在远程网络上使用默认网关（u）
- ①点击属性
- IP地址（I）：
- 禁用基于类的路由添加
- 自动获得DNS服务器地址（B）
- 自动跃点（A)
- VN
- 安装)..
- 卸载（）
- 属性(R）
- 使用下面的DNS服务器地址(E）：
- 接口跃点数(）：
- Wo
- 描述
- 首选DNS服务器（P）：
- TCP/IP。该协议是默认的广域网络协议，它提供在不同
- 的相互连接的网络上的通讯。
- 备用DNS服务器（A）
- 高级(V)
- Xs
- ②点击高级
- 确定
- 取消
- Zoomitb4....
- 45
- 下午3:44
- 2017/11/29
<!-- OCR_END -->

## 4.Linux客户端配置

1.以`CentOS7.4`为客户端,安装软件包

```plain
yum install -y ppp pptp pptp-setup
```

2.客户端连接VPN服务端

> 运行 pptpsetup --create test --server IP --username 用户名 --password 密码 --encrypt --start 连接 VPN 服务端。
>
> 您需要填写实际配置 VPN 服务端的 IP 地址、用户名和密码。

```plain
[root@vpn-client-rhel ~]# pptpsetup --create test --server 192.168.56.11 --username bgx --password 123456 --encrypt --start
Using interface ppp0
Connect: ppp0 <--> /dev/pts/3
CHAP authentication succeeded
MPPE 128-bit stateless compression enabled
local  IP address 172.16.56.102
remote IP address 192.168.56.11
```

3.检查分配地址段

```plain
[root@vpn-client-rhel ~]# ifconfig|grep -A 5 ppp
ppp0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1496
        inet 172.16.56.102  netmask 255.255.255.255  destination 192.168.69.112
        ppp  txqueuelen 3  (Point-to-Point Protocol)
        RX packets 6  bytes 60 (60.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 6  bytes 66 (66.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

4.添加默认路由

```plain
[root@vpn-client-rhel ~]# ping www.baidu.com
[root@vpn-client-rhel ~]# ip route replace default dev ppp0
[root@vpn-client-rhel ~]# ping www.baidu.com
PING baidu.com (220.181.57.216) 56(84) bytes of data.
64 bytes from 220.181.57.216: icmp_seq=1 ttl=52 time=23.0 ms
64 bytes from 220.181.57.216: icmp_seq=2 ttl=52 time=22.9 ms
```

## 5.VPN连接故障

如下这类错误和VPN客户端拨号提示连接691错误类似

1.检查IPtables和Selinux，以及客户端防火墙。

2.如果是云主机请检查安全组入口和出口是否运行1723端口访问。

3.如果是物理主机需要向IDC了解是否关闭此端口, 或路由不支持此协议。

```plain
Nov 15 15:30:07 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: pppd 2.4.5 started by root, uid 0
Nov 15 15:30:07 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Using interface ppp0
Nov 15 15:30:07 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Connect: ppp0 <--> /dev/pts/2
Nov 15 15:30:38 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: LCP: timeout sending Config-Requests
Nov 15 15:30:38 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Connection terminated.
Nov 15 15:30:38 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Modem hangup
Nov 15 15:30:38 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Exit.
```

> 更新: 2019-03-20 19:58:46  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/in3qkt>