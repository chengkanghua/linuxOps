# 第二阶段 · 网络基础管理（NetworkManager）

## 一、基础介绍

RHEL/CentOS7 默认用 **NetworkManager** 动态管理网络配置，保证网络设备持续连接。配置保存在 `/etc/sysconfig/network-scripts/` 目录下，常用工具：

- `nmcli`：命令行（NetworkManager + cli）
- `nmtui`：文本图形界面
- `nm-connection-editor`：图形界面

> 误区提醒：Linux 命令不用死记，记到笔记里，需要时复制即可。

![NetworkManager 概览](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-%E7%BD%91%E7%BB%9C%E5%9F%BA%E7%A1%80%E7%AE%A1%E7%90%86Networkmanager-01.png)

**两个核心概念**
- **device（设备）**：物理网卡，如 `enp2s0`、`virbr0`、`team0`。
- **connection（连接）**：一套具体配置方案（逻辑配置），可绑定到设备。

```bash
yum install -y bash-completion     # 命令参数自动补全

nmcli device                       # 查看物理设备状态
# DEVICE  TYPE      STATE      CONNECTION
# eth0    ethernet  connected  eth0
# lo      loopback  unmanaged  --
# connected=已连接  ethernet=以太网  loopback=环回  unmanaged=非托管

nmcli connection                   # 查看连接（逻辑配置文件）
nmcli connection show eth0        # 查看 eth0 详细配置
nmcli connection show --active    # 仅看活动连接

systemctl status NetworkManager    # 查看服务状态
# enabled=下次开机自启   active(running)=当前运行
systemctl enable/disable NetworkManager      # 开机自启/不自启
systemctl is-enabled NetworkManager          # 是否开机自启
systemctl is-active NetworkManager           # 是否运行中
systemctl start/stop/restart NetworkManager  # 启动/停止/重启
```

---

## 二、用 nmcli 创建新连接

### 1. 创建 DHCP 连接
```bash
# 实质是生成 /etc/sysconfig/network-scripts/ifcfg-eth0-dhcp
nmcli connection add con-name eth0-dhcp ifname eth0 \
  autoconnect yes type ethernet ipv4.method auto

nmcli connection                 # 查看所有连接
nmcli connection up eth0-dhcp    # 激活连接（注意：会切网卡，Xshell 可能掉线）

# 删除多余连接
nmcli connection delete "wired connection 1"
```
> Tab 无补全提示时，用 `nmcli connection add ... ipv4.method --help` 查看可选值：`[auto, link-local, manual, shared, disabled]`。

### 2. 创建静态 IP 连接
```bash
# 静态地址添加流程：① 加连接 ② 命名 ③ 绑网卡 ④ 设类型/开机启 ⑤ 地址获取方式 ⑥ 配 IP/掩码/网关/DNS
nmcli connection add con-name eth1-static ifname eth1 \
  type ethernet autoconnect yes \
  ipv4.method manual \
  ipv4.addresses 10.0.0.9/24 \
  ipv4.gateway 10.0.0.254 \
  ipv4.dns 223.5.5.5 \
  +ipv4.dns 8.8.8.8

nmcli connection up eth1-static
```

---

## 三、用 nmcli 修改已有连接

```bash
# 1. 取消开机自启
nmcli connection modify eth1-static autoconnect no

# 2. 修改 DNS
nmcli connection modify eth1-static ipv4.dns 8.8.8.8

# 3. 追加 DNS（+/- 表示增加/移除）
nmcli connection modify eth1-static +ipv4.dns 8.8.8.8

# 4. 替换静态 IP 和默认网关
nmcli connection modify eth1-static \
  ipv4.addresses 192.168.69.252/24 ipv4.gateway 192.168.69.22

# 5. 增加一个无默认网关的 IP
nmcli connection modify eth1-static +ipv4.addresses 192.168.70.12/24

# 6. 修改后仅保存配置，需重激活才生效
nmcli connection down eth1-static && nmcli connection up eth1-static

# 删除自建连接
nmcli connection delete eth1-static
```
> 图形工具：`nm-connection-editor`

---

## 四、手工修改配置文件（ifcfg）

```bash
# 步骤：① 新增物理网卡 ② 拷一份配置(文件名即连接名) ③ 改 UUID/NAME/DEVICE/IP
#        ④ nmcli connection reload 重新加载 ⑤ 启用连接
cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth1
vim /etc/sysconfig/network-scripts/ifcfg-eth1
# TYPE=Ethernet
# BOOTPROTO=none
# IPADDR=192.168.56.12
# PREFIX=24
# GATEWAY=192.168.56.2
# DNS1=192.168.56.2
# NAME=eth1
# DEVICE=eth1
# ONBOOT=yes

nmcli connection reload
nmcli connection down eth1 && nmcli connection up eth1
```

---

## 五、使用原生 network 服务（不推荐）

> 适合不用 NetworkManager 的场景：停掉 NM，直接用 `network.service`。

```bash
systemctl disable NetworkManager
systemctl stop NetworkManager

cp /etc/sysconfig/network-scripts/{ifcfg-eth0,ifcfg-eth1}
vim /etc/sysconfig/network-scripts/ifcfg-eth1
# TYPE=Ethernet
# BOOTPROTO=none
# DEFROUTE=yes
# NAME=eth1
# DEVICE=eth1
# ONBOOT=yes
# IPADDR=192.168.56.12
# NETMASK=255.255.255.0
# GATEWAY=192.168.56.2
# DNS1=192.168.56.2

systemctl restart network.service
```

**ifcfg 关键字段**
| 字段 | 说明 |
| --- | --- |
| BOOTPROTO=none | 获取地址方式 [none\|dhcp\|static] |
| IPADDR | 固定 IP |
| PREFIX=24 | 掩码 |
| GATEWAY | 网关 |
| DNS1 | DNS |
| DEVICE | 设备名 |
| NAME | 连接名 |
| ONBOOT=yes | 开机自启 |
| DEFROUTE=yes | 是否为默认路由 |
| USERCTL=yes | 允许非 root 管理接口 |

---

## 六、CentOS7 修改网卡为 eth0

**方式一：已装系统后改（GRUB 参数）**
```bash
cd /etc/sysconfig/network-scripts/
mv ifcfg-eno16777728 ifcfg-eth0
vim ifcfg-eth0
# NAME=eth0
# DEVICE=eth0

vim /etc/default/grub
# GRUB_CMDLINE_LINUX="... net.ifnames=0 biosdevname=0 quiet"
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

yum install net-tools -y
ifconfig eth0
```

**方式二（推荐）：安装时按 Tab 加内核参数**
![安装加参数1](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-%E7%BD%91%E7%BB%9C%E5%9F%BA%E7%A1%80%E7%AE%A1%E7%90%86Networkmanager-02.png)
增加内核参数 `net.ifnames=0 biosdevname=0`
![安装加参数2](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-%E7%BD%91%E7%BB%9C%E5%9F%BA%E7%A1%80%E7%AE%A1%E7%90%86Networkmanager-03.png)
检查是否成功：
![检查](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-%E7%BD%91%E7%BB%9C%E5%9F%BA%E7%A1%80%E7%AE%A1%E7%90%86Networkmanager-04.png)

---

## 七、主机名设定与名称解析

**主机名规范**（生产建议）：`地区-项目-业务-服务-节点-地址`
```
wh-shop-register-nginx-node1-192.168.56.13
wh-med-pay-mysql-master01-192.168.56.11
wh-med-pay-mysql-slave01-192.168.56.12
```

```bash
hostname "test"                  # 临时修改/查看
hostnamectl set-hostname nginx.node1.xuliangwei.com   # 永久（写 /etc/hostname）
cat /etc/hostname
hostnamectl                     # 查看状态
```

**/etc/hosts（本地解析，加速内网访问）**
```
# A 主机访问 B(192.168.69.12) 方便，在 A 上加：
192.168.69.12 hostB
# 没加的话 ping hostB 会报 unknown host
```

**/etc/resolv.conf（DNS 客户端）**
```
# Generated by NetworkManager
search node1.xuliangwei.com
nameserver 211.161.122.200
```

---

## 八、Route 路由与网关

```bash
# 增加网段路由
route add -net 192.168.90.0/24 gw 192.168.56.254
route add -net 0.0.0.0/0 gw 192.168.56.254      # 默认网关

# 删除网段路由
route del -net 192.168.90.0/24
route del -net 0.0.0.0/0 gw 192.168.56.254

# 主机路由
route add -host 192.168.70.1 gw 192.168.56.254
route del -host 192.168.70.1

route -n     # 查看路由表
```
> 路由重启会丢失，需写进网卡配置文件（如 `GATEWAY=`）才能永久保存。

---

## 九、网络检测工具与故障排查

```bash
# ping：测试可达性（不通不代表一定故障，可能被防火墙丢弃）
#   -c 次数  -i 间隔  -w 超时退出
host xuliangwei.com          # 查 DNS 解析到的 IP
nslookup xuliangwei.com
traceroute xuliangwei.com    # 路由跟踪，定位故障环节

# ss / netstat：查看连接
#   -t tcp  -u udp  -a 所有  -n 数字  -l listen  -p 进程
ss -tnl                       # 监听中的 TCP 端口
ss -tnl | grep :80
ss -atn | grep :22

yum provides lsof
lsof -i:22                    # 查 22 端口被谁占用
```

**常见端口速查**
| 服务 | 端口 |
| --- | --- |
| http | 80/tcp |
| https | 443/tcp |
| ssh | 22/tcp |
| ftp | 20,21/tcp |
| mysql | 3306/tcp |
| rsync | 873 |
| redis | 6379/tcp |
| dns | 53/udp |
| dhcp | 67,68/udp |

**网络故障排查思路（由下往上，对应 OSI 七层）**
1. `ping 127.0.0.1` 回环 → 本机 TCP/IP 协议栈正常？
2. `ping 本机IP` → 本地网卡/驱动正常？
3. `ping 同网段主机` → 二层网络正常？`ping 网关` → 三层网络正常？
4. `ping 公网IP` → 本地路由正常？
5. `ping 公网域名` → DNS 客户端正常？

**服务故障排查思路**
1. `telnet ip port` 检测端口是否开放；
2. 检查防火墙、SELinux；
3. 检查权限配置；
4. 查看日志是否异常；
5. 持续测试验证。
> 建议：所有排查都从 OSI 七层由下往上逐一进行，并学会看日志。

---

## 十、常见面试题

1. **NetworkManager 里 device 和 connection 的区别？**
   device 是物理网卡；connection 是一套配置方案，可绑定到 device。一个 device 同一时间只能有一个 active connection。

2. **`nmcli connection up` 为什么可能让 Xshell 掉线？**
   因为它会切换/重激活网卡连接，过程中网络短暂中断，远程会话会断开。

3. **修改 nmcli 连接后不生效？**
   `modify` 只改配置并保存，必须 `nmcli connection down xx && up xx` 重激活才生效。

4. **CentOS7 怎么把网卡名改回 eth0？**
   内核参数加 `net.ifnames=0 biosdevname=0`（安装时 Tab 加，或改 /etc/default/grub 后 `grub2-mkconfig`），再把 ifcfg 文件名和 NAME/DEVICE 改好，重启。

5. **网络不通时排查顺序？**
   按 OSI 由下往上：回环→本机IP→同网段/网关→公网IP→域名(DNS)，配合 telnet 测端口、看防火墙/SELinux/日志。

6. **`route` 加的路由重启丢失怎么办？**
   写进网卡配置文件（如 `GATEWAY=` 或 `/etc/sysconfig/network-scripts/route-eth0`），否则临时路由重启即失效。

---

> 更新：2024-08-24 16:40:32
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/lppg8g>
