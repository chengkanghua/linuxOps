# VPN 虚拟专网服务

## 1. 应用场景

通过 VPN 让外部客户端安全接入企业内网，访问内网服务器资源（如 100.100.1.50）。

![VPN 应用场景](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-01.png)

## 2. 服务端配置（PPTP）

**实验环境**

| 角色 | 外网 IP (NAT) | 内网 IP (LAN) |
| --- | --- | --- |
| VPN-Server | eth0:192.168.56.11 | eth1:172.16.1.250 |
| 内网服务器 A | — | eth1:172.16.1.61 |
| 内网服务器 B | — | eth1:172.16.56.13 |

![实验环境规划](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-02.png)

```bash
# 1. 环境准备
systemctl stop firewalld && systemctl disable firewalld
setenforce 0 && getenforce
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install ppp pptp pptpd -y

# 2. 开启内核转发
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# 3. 客户端上网 DNS
vim /etc/ppp/options.pptpd +68
ms-dns 223.5.5.5

# 4. VPN 拨号账号密码（格式：用户名 服务名 密码 IP）
echo 'ckh * 123456 *' >> /etc/ppp/chap-secrets

# 5. 分配地址段（localip 本机，remoteip 分配给客户端）
echo 'localip 10.0.0.250'        >> /etc/pptpd.conf
echo 'remoteip 172.16.1.2-200'   >> /etc/pptpd.conf

# 6. 启动服务
systemctl start pptpd && systemctl enable pptpd

# 检查 1723 端口
ss -lntup | grep 1723
# tcp LISTEN 0 3 *:1723 *:* users:(("pptpd",pid=3483,fd=6))
```

## 3. Windows 客户端配置

1. 直接用内网地址无法连通，需先建立 VPN 连接
2. 网络共享中心 → 设置新的连接或网络
3. 选择"连接到工作区域"
4. 使用 Internet 连接到 VPN
5. 填写 VPN 服务器地址与连接名称
6. 填写服务端配置的用户名/密码并连接

![Win 客户端连接](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-03.png)
![VPN 连接成功](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-09.png)

> 默认连接 VPN 会走 VPN 默认网关上网，取消"在远程网络上使用默认网关"即可仅访问内网。

![取消默认网关](img/VPN%E8%99%9A%E6%8B%9F%E4%B8%93%E7%BD%91%E6%9C%8D%E5%8A%A1-12.png)

连通后可访问内网服务器（如 100.100.1.50）。

## 4. Linux 客户端配置

```bash
# 1. 安装
yum install -y ppp pptp pptp-setup

# 2. 创建并连接（替换为实际 IP/用户/密码）
pptpsetup --create test --server 192.168.56.11 \
  --username bgx --password 123456 --encrypt --start
# Using interface ppp0
# Connect: ppp0 <--> /dev/pts/3
# CHAP authentication succeeded
# MPPE 128-bit stateless compression enabled
# local  IP address 172.16.56.102
# remote IP address 192.168.56.11

# 3. 检查分配地址
ifconfig | grep -A 5 ppp

# 4. 添加默认路由走 VPN
ping www.baidu.com
ip route replace default dev ppp0
```

## 5. 连接故障排查

- 错误类似 691：检查 iptables / SELinux / 客户端防火墙
- 云主机：检查安全组出入站是否放行 1723 端口
- 物理机：向 IDC 确认端口/路由是否支持 PPTP（GRE 协议）
- 日志现象 `LCP: timeout sending Config-Requests`：通常是 GRE(47) 协议被拦截或网络不通

```log
pppd[11407]: Connect: ppp0 <--> /dev/pts/2
pppd[11407]: LCP: timeout sending Config-Requests
pppd[11407]: Connection terminated.
pppd[11407]: Modem hangup
```

参考：<https://help.aliyun.com/knowledge_detail/41345.html>

---

## 面试题

1. **VPN 的作用？**
   在公网上建立加密隧道，让外部客户端安全接入企业内网访问内部资源。

2. **PPTP 依赖哪些协议/端口？**
   控制通道 TCP 1723 + 数据通道 GRE(47) 协议，二者都需放行，否则出现 LCP 超时。

3. **为什么客户端能访问内网？**
   服务端开启 `net.ipv4.ip_forward` 内核转发，并把客户端流量经内网网卡路由出去。

4. **`net.ipv4.ip_forward=1` 的作用？**
   开启 Linux 内核 IP 转发，使服务器能作为路由器转发数据包，VPN/网关类服务必备。

5. **连接 691/LCP 超时常见原因？**
   账号密码错误、GRE 协议被防火墙/安全组拦截、SELinux 限制、服务端 1723 未监听。

---

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/yuqymc>
