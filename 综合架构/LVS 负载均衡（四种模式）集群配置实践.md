# LVS 负载均衡（四种模式）集群配置实践

> 本文是 LVS 四种工作模式的**实操手册**：NAT（含 HTTPS）、DR、TUN、FULLNAT。理论见《LVS 负载均衡原理与实践》。

---

## 一、LVS-NAT 模式（HTTP）

### 1. 环境说明
![NAT 环境](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%EF%BC%88%E5%9B%9B%E7%A7%8D%E6%A8%A1%E5%BC%8F%EF%BC%89%E9%9B%86%E7%BE%A4%E9%85%8D%E7%BD%AE%E5%AE%9E%E8%B7%B5-01.webp)

角色：DR（调度器，双网卡）、RS1、RS2、Client。DR 上给仅主机网卡（ens38）配内网 IP。

### 2. DR 添加仅主机网卡
```bash
# 查看仅主机网卡名（示例为 ens38）
ifconfig
# 仅主机网段假设为 192.168.23.0
nmcli connection add con-name ens38 ifname ens38 type ethernet
nmcli connection modify ens38 ipv4.addresses 192.168.23.10/24 ipv4.method manual autoconnect yes
systemctl restart NetworkManager
nmcli connection up ens38
```

### 3. 关闭防火墙与 SELinux（DR/RS1/RS2 都做）
```bash
systemctl stop firewalld && systemctl disable firewalld
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
setenforce 0
```

### 4. 配置 IP
```bash
# DR
# ifcfg-ens33: IPADDR=192.168.79.129  PREFIX=24  GATEWAY=192.168.79.2  DNS1=8.8.8.8
# RS1
# ifcfg-ens33: IPADDR=192.168.79.134  PREFIX=24  GATEWAY=192.168.79.129  DNS1=8.8.8.8
# RS2
# ifcfg-ens33: IPADDR=192.168.79.139  PREFIX=24  GATEWAY=192.168.79.129  DNS1=8.8.8.8
# 注意：RS 网关必须指向 DR 的 DIP（NAT 模式要求）
```

### 5. 安装 Web 服务（RS1/RS2）
```bash
yum -y install httpd
echo RS1 > /var/www/html/index.html     # RS1
echo RS2 > /var/www/html/index.html     # RS2
systemctl restart httpd && systemctl enable httpd
```

### 6. 配置 LVS（DR 上）
```bash
# 开启 IP 转发
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
sysctl -p

yum -y install ipvsadm
ipvsadm -A -t 192.168.23.10:80 -s rr
ipvsadm -a -t 192.168.23.10:80 -r 192.168.79.134:80 -m
ipvsadm -a -t 192.168.23.10:80 -r 192.168.79.139:80 -m
ipvsadm -Ln
# TCP  192.168.23.10:80 rr
#   -> 192.168.79.134:80   Masq   (Masq = NAT 模式)
#   -> 192.168.79.139:80   Masq

# 保存并开机自启
ipvsadm -Sn > /etc/sysconfig/ipvsadm
systemctl restart ipvsadm.service && systemctl enable ipvsadm.service
```

### 7. 测试
```bash
[root@Client ~]# curl http://192.168.23.10
RS2
[root@Client ~]# curl http://192.168.23.10
RS1
# 交替返回即负载均衡生效
```

---

## 二、LVS-NAT 模式（HTTPS）

在 NAT 基础上，为 RS 签发证书，使 LVS 对 443 端口做负载。

### 1. DR 上自建 CA 并生成根密钥
```bash
mkdir -p /etc/pki/CA/private && cd /etc/pki/CA/
(umask 077; openssl genrsa -out private/cakey.pem 2048)
openssl req -new -x509 -key private/cakey.pem -out cacert.pem -days 1024
# 交互填写：CN / hubei / wuhan / runtime / linux / Gin / Gin@163.com
touch index.txt && echo 01 > serial
```

### 2. RS1 生成证书请求并发送给 CA
```bash
yum -y install mod_ssl
mkdir /etc/httpd/ssl && cd /etc/httpd/ssl/
(umask 077; openssl genrsa -out httpd.key 2048)
openssl req -new -key httpd.key -days 1024 -out httpd.csr
# 交互填写与上面一致
scp httpd.csr root@192.168.79.129:/root/
```

### 3. DR（CA）签署并回发证书
```bash
mkdir /etc/pki/CA/newcerts
touch /etc/pki/CA/index.txt && echo "01" > /etc/pki/CA/serial
openssl ca -in httpd.csr -out httpd.crt -days 1024
# 提示 Sign the certificate? [y/n]: y  →  commit? [y/n]: y
scp httpd.crt root@192.168.79.134:/etc/httpd/ssl
scp /etc/pki/CA/cacert.pem root@192.168.79.134:/etc/httpd/ssl
```

### 4. RS2 复用证书
```bash
yum -y install mod_ssl && mkdir /etc/httpd/ssl
# 在 RS1 上把证书和密钥发给 RS2
scp cacert.pem httpd.crt httpd.key root@192.168.79.139:/etc/httpd/ssl
```

### 5. RS1/RS2 修改 HTTPS 配置
```bash
vim /etc/httpd/conf.d/ssl.conf
# SSLCertificateFile /etc/httpd/ssl/httpd.crt
# SSLCertificateKeyFile /etc/httpd/ssl/httpd.key
# SSLCACertificateFile /etc/httpd/ssl/cacert.pem
systemctl restart httpd.service
ss -anlt | grep 443     # 应监听 443
```

### 6. DR 添加 443 规则并测试
```bash
ipvsadm -A -t 192.168.23.10:443 -s rr
ipvsadm -a -t 192.168.23.10:443 -r 192.168.79.134 -m
ipvsadm -a -t 192.168.23.10:443 -r 192.168.79.139 -m
ipvsadm -Ln
# 测试（忽略证书校验）
curl -k https://192.168.23.10:443    # 交替返回 RS1 / RS2
```

---

## 三、LVS-DR 模式

![DR 环境](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%EF%BC%88%E5%9B%9B%E7%A7%8D%E6%A8%A1%E5%BC%8F%EF%BC%89%E9%9B%86%E7%BE%A4%E9%85%8D%E7%BD%AE%E5%AE%9E%E8%B7%B5-02.webp)

### 1. RS1/RS2 安装 httpd（同前，关闭防火墙/SELinux，`echo RS1/RS2` 到 index.html）

### 2. DR 配置 VIP（在 lo 上，32 位掩码）
```bash
# 临时
ifconfig lo 192.168.79.100 broadcast 192.168.79.100 netmask 255.255.255.255 up
# 永久（写入 rc.local）
echo 'ifconfig lo 192.168.79.100 broadcast 192.168.79.100 netmask 255.255.255.255 up' >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
```

### 3. RS 配置 ARP 内核参数（**必须先做，再配 VIP**）
```bash
vim /etc/sysctl.conf
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
sysctl -p
```
> 原因：多机共用 VIP，先限制 ARP，防止 RS 抢答 VIP 的 ARP 请求。

### 4. RS 配置 VIP 并加路由
```bash
ifconfig lo 192.168.79.100 broadcast 192.168.79.100 netmask 255.255.255.255 up
route add -host 192.168.79.100/32 dev lo    # RS1、RS2 都加
```

### 5. 配置 LVS（DR 上，模式 `-g` = DR）
```bash
ipvsadm -A -t 192.168.79.100:80 -s rr
ipvsadm -a -t 192.168.79.100:80 -r 192.168.79.134:80 -g
ipvsadm -a -t 192.168.79.100:80 -r 192.168.79.139:80 -g
ipvsadm -Ln
# -> 192.168.79.134:80   Route   (Route = DR 模式)
ipvsadm -Sn > /etc/sysconfig/ipvsadm
systemctl restart ipvsadm.service && systemctl enable ipvsadm.service
```

### 6. 测试
```bash
curl http://192.168.79.100    # 交替返回 RS1 / RS2
```

---

## 四、LVS-TUN 模式

### 1. DR 开启转发、加载并配置 tunl0
```bash
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf && sysctl -p
yum -y install ipvsadm
ifconfig tunl0 192.168.79.55 broadcast 192.168.79.55 netmask 255.255.255.255 up
```

### 2. RS1/RS2 启用 ipip 模块并配置 tunl0
```bash
modprobe ipip
ifconfig tunl0 192.168.79.55 broadcast 192.168.79.55 netmask 255.255.255.255 up
```

### 3. RS 内核参数（针对 tunl0）
```bash
vim /etc/sysctl.conf
net.ipv4.conf.tunl0.arp_ignore = 1
net.ipv4.conf.tunl0.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.tunl0.rp_filter = 0
net.ipv4.conf.all.rp_filter = 0
sysctl -p
```

### 4. 配置 LVS（模式 `-i` = TUN）
```bash
ipvsadm -A -t 192.168.79.55:80 -s rr
ipvsadm -a -t 192.168.79.55:80 -r 192.168.79.134 -i
ipvsadm -a -t 192.168.79.55:80 -r 192.168.79.139 -i
ipvsadm -Ln
# -> 192.168.79.134:80   Tunnel
ipvsadm -Sn > /etc/sysconfig/ipvsadm
systemctl restart ipvsadm.service
```

### 5. 测试
```bash
curl http://192.168.79.55    # 交替返回 RS1 / RS2
```

---

## 五、LVS FULLNAT 模式

### 原理
NAT 只提供 DNAT；FULLNAT 在出 LVS 时再做 **SNAT**，实现 RS 与 Director 跨网段通信。数据流：`Client → VS → RS → VS → Client`。

1. 客户端请求 `cip -> vip`；
2. VS 做 DNAT（目的改为 rip）+ SNAT（源改为 dip）：`dip -> rip`；
3. RS 响应给 dip；
4. VS 再做 SNAT+DNAT：`vip -> cip` 发回客户端。

**架构特点**：VIP 公网、RIP/DIP 私网且可不同网段（RIP 网关不必指向 DIP）；请求和响应都经 Director；支持端口映射；比 NAT 更利于 RS 跨 VLAN 通信。

### 实践
```bash
# 网络规划
# VM1(Director): eth0 10.1.1.10/24
# VM2(Client):   eth0 10.1.1.1/24
# VM3(RS):       eth0 192.168.10.2/24
# Director 另一网卡: 192.168.10.1/24

# FULLNAT 规则（-q 表示 FULLNAT）
ipvsadm -A -t 10.1.1.1:80 -s rr
ipvsadm -a -t 10.1.1.1:80 -r 192.168.10.2:22 -q -w 1   # DNAT
ipvsadm -P -t 10.1.1.1:80 -z 192.168.10.1:90           # SNAT

# 测试：访问 Director 的 80 端口实际 SSH 到 RS
ssh -p 80 root@10.1.1.1     # 正常登录到 VM3
```

---

## 六、ipvsadm 主要参数速查

**虚拟服务器（VIP）**
| 参数 | 作用 |
| --- | --- |
| `-A` | 添加虚拟服务器 |
| `-t` / `-u` / `-f` | TCP / UDP / 防火墙标记 |
| `-s` | 指定调度算法 |
| `-D` | 删除虚拟服务器 |
| `-E` | 修改虚拟服务器 |
| `-C` | 清空所有规则 |
| `-L` / `-l` | 查看规则（`-Ln` 不解析主机名） |

**后端 RealServer（RS）**
| 参数 | 作用 |
| --- | --- |
| `-a` | 添加 RS |
| `-r` | 指定 RS 的 IP |
| `-g` | DR 模式 |
| `-i` | TUN 模式 |
| `-m` | NAT 模式 |
| `-q` | FULLNAT 模式 |
| `-w` | 指定权重 |
| `-d` | 删除 RS |
| `-e` | 修改 RS |

常用：`ipvsadm -Ln` 查看规则；`ipvsadm -Sn` 导出（保存到 `/etc/sysconfig/ipvsadm`）。

---

## 七、常见面试题

1. **NAT 模式 RS 的网关为什么要指向 DIP？**
   因为响应报文必须经过 Director 做 SNAT 回给客户端；若 RS 直连外网，响应就不走 LVS，客户端收不到。

2. **DR 模式 RS 为什么要改 arp_ignore/arp_announce 且把 VIP 配在 lo？**
   多机共用 VIP，限制 RS 不通告/不应答 VIP 的 ARP，避免客户端直连 RS 或 ARP 冲突；VIP 配在 lo 且 32 位掩码，保证只有 Director 的 VIP 对外可见。

3. **DR 和 TUN 的响应都不经过 LVS，区别？**
   DR 改 MAC 在同一二层转发；TUN 用 IP 隧道封装，可跨机房/跨网段。

4. **FULLNAT 与 NAT 区别？**
   NAT 只改目的 IP；FULLNAT 同时改源和目的 IP，使 RS 与 Director 可跨网段，支持端口映射。

5. **`-g`/`-i`/`-m`/`-q` 各代表哪种模式？**
   `-g`=DR，`-i`=TUN，`-m`=NAT，`-q`=FULLNAT。

6. **ipvsadm 规则怎么持久化？**
   `ipvsadm -Sn > /etc/sysconfig/ipvsadm`，并 `systemctl enable ipvsadm`。

---

> 参考：<https://blog.csdn.net/qq_15437629/article/details/127343787>、<https://blog.csdn.net/m0_72898391/article/details/127096428>
