# VPN虚拟专网服务

## 1.VPN应用场景

![1547292559131-3ae90d53-6138-46a8-b0bf-97a39e58ad59.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-01.png)

## 2.VPN服务端配置

**实验环境介绍**

![1547292587943-07f18dd5-6146-40f4-a289-76e718ae966a.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-02.png)

**实验环境规划**

| 角色 | 外网IP(NAT) | 内网IP(LAN) |
| --- | --- | --- |
| VPN-Server | eth0:192.168.56.11(公网) | eth1:172.16.1.250 |
| 内网服务器(A) | | eth1:172.16.1.61 |
| 内网服务器(B) | | eth1:172.16.56.13 |

```bash
#环境准备:
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
getenforce

#配置epel源, 安装pptp VPN相关软件
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install ppp pptp pptpd -y

#2.开启内核转发功能
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
# sysctl -p

#3.配置客户端上网DNS, 如客户端不需要分配DNS可不配置
# +68 表示打开直接跳到68行
[root@vpn-server ~]# vim /etc/ppp/options.pptpd +68
ms-dns 223.5.5.5

#4.设置VPN拨号的账号密码
echo 'ckh * 123456 *' >> /etc/ppp/chap-secrets

#5.分配VPN拨号地址段, 注意和内网相同地址
[root@vpn-server ~]# vim /etc/pptpd.conf
#添加本机公网IP（localip）
localip 10.0.0.250
#分配VPN用户的内网网段（remoteip）
remoteip 172.16.1.2-200
------------------------------------
echo 'localip 10.0.0.250' >>/etc/pptpd.conf
echo 'remoteip 172.16.1.2-200' >>/etc/pptpd.conf

#7.启动pptpd服务并加入开机自启动
systemctl start pptpd
systemctl enable pptpd

//检查tcp1723端口是否开启
[root@vpn-server ~]# ss -lntup | grep 1723
tcp    LISTEN     0   3    *:1723    *:*    users:(("pptpd",pid=3483,fd=6))


```

## 3.Win客户端配置

1.如果直接使用客户端连接内网地址是无法连接成功 

\_                                                            \_                                 ![1547292626075-56dd1c00-1d0e-4685-ac26-f3a33b216ba4.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-03.png)

2.打开网络共享中心，点击-->设置新的连接或网络 

![1547292646866-372f5b5d-8fd8-4f33-be64-004afa5d7047.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-04.png)

\_                                                            \_                                                                     

3.选择连接到工作区域 

![1547292681181-959ae79d-2fdc-48a2-9363-f36584dd8f94.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-05.png)

\_                                                            \_                                                                 

4.使用Internet连接到VPN服务 

![1547292704907-fc06a9eb-7771-4bcc-b621-0fc6d47a692f.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-06.png)

5.填写vpn地址以及名称,然后下一步 

\_                                                            \_                                 ![1547292896143-3fdc7001-a3c1-4df8-a0d8-021cc1e18f94.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-07.png)

6.填写在VPN-Server上配置好的用户名以及密码, 然后点击连接 

\_                                                            \_                                 ![1547292920348-e373eec2-ab9d-4c06-bf9a-d5570de2c162.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-08.png)

7.VPN连接成功 

![1547293179583-195e9645-4e68-4487-ad73-092c19ac0340.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-09.png)

8.测试是否能够连接100.100.1.50这台内网服务器,如图2-7 

![1547293220244-854f7dbe-b6ad-4426-8dcf-ef47fd17adda.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-10.png)

![1547293347321-1eb1f3d9-3dae-4ba5-9795-23f83bffb357.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-11.png)

默认连接VPN是会通过VPN的默认网关来进行上网,我们取消默认使用VPN连接上网功能即可

![1547293340792-3581b0b5-c249-4669-9045-06118708e3a8.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-12.png)

![1547293293834-1993f992-216e-4a73-93b3-9f9427c2dc3a.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-13.png)

![1547293321741-67174721-c4a0-41f6-91b8-e5d9ef6a9af9.png](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-14.png)

## 4.Linux客户端配置

1.以`CentOS7.4`为客户端,安装软件包

```bash
yum install -y ppp pptp pptp-setup
```

2.客户端连接VPN服务端

> 运行 pptpsetup --create test --server IP --username 用户名 --password 密码 --encrypt --start
>
> 连接 VPN 服务端。 您需要填写实际配置 VPN 服务端的 IP 地址、用户名和密码。

```bash
# pptpsetup --create test --server 192.168.56.11 --username bgx --password 123456 --encrypt --start


Using interface ppp0
Connect: ppp0 <--> /dev/pts/3
CHAP authentication succeeded
MPPE 128-bit stateless compression enabled
local  IP address 172.16.56.102
remote IP address 192.168.56.11
```

3.检查分配地址段

```bash
# ifconfig|grep -A 5 ppp
ppp0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1496
inet 172.16.56.102  netmask 255.255.255.255  destination 192.168.69.112
ppp  txqueuelen 3  (Point-to-Point Protocol)
RX packets 6  bytes 60 (60.0 B)
RX errors 0  dropped 0  overruns 0  frame 0
TX packets 6  bytes 66 (66.0 B)
TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

4.添加默认路由

```bash
ping www.baidu.com
ip route replace default dev ppp0

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

```bash
Nov 15 15:30:07 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: pppd 2.4.5 started by root, uid 0
Nov 15 15:30:07 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Using interface ppp0
Nov 15 15:30:07 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Connect: ppp0 <--> /dev/pts/2
Nov 15 15:30:38 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: LCP: timeout sending Config-Requests
Nov 15 15:30:38 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Connection terminated.
Nov 15 15:30:38 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Modem hangup
Nov 15 15:30:38 iZm5ea7wyzv7b8pzmd9vk5Z pppd[11407]: Exit.
```

扩展

<https://help.aliyun.com/knowledge_detail/41345.html?spm=5176.11065259.1996646101.searchclickresult.3ac66c34VPg8xs#CentOSVPNclient>


> 更新: 2024-08-29 19:37:41  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/yuqymc>