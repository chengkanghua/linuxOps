# 第二阶段 · CentOS7 和 CentOS6 区别

> 从安装到日常管理，逐一对比 6 与 7 的差异，并给出 CentOS7 初始化优化实战。

## 一、安装 CentOS 7.5 步骤图示

安装流程概览（配图顺序即操作步骤）：

1. 新建虚拟机向导 → 虚拟机位置单独存在大容量分区。
2. 网络选择 **NAT 模式**，其余按推荐。
3. 自定义硬件删到最精简 + 指定 ISO 镜像。
4. 启动进入安装界面，选 `Install CentOS 7`，按 **Tab** 设置内核参数。
5. 添加内核参数 `net.ifnames=0 biosdevname=0`（把网卡名改回 eth0 风格），回车。

![安装1](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-01.png)
![安装2](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-02.png)
![安装3](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-03.png)
![安装4](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-04.png)
![安装5](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-05.png)
![安装6](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-06.png)
![安装7](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-07.png)
![安装8](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-08.png)
![安装9](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-09.png)
![安装10](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-10.png)
![安装11](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-11.png)
![安装12](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-12.png)
![安装13](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-13.png)
![安装14](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-14.png)
![安装15](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-15.png)
![安装16](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-16.png)

安装选项要点：分区「全部」；关闭 **kdump**；关闭 **Security Policy**；`Minimal Install`；时区选上海；密码设置点两下 Done。

**内核参数永久改回 eth0 命名**（安装时加了 `net.ifnames=0 biosdevname=0` 后，想永久生效）：
```bash
# 网卡命名受 biosdevname 和 net.ifnames 两个参数影响
# 编辑 /etc/default/grub，增加 biosdevname=0 net.ifnames=0，然后更新 grub 并重启
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
```

---

## 二、系统基础服务变化对比

| 操作 | CentOS6 | CentOS7 | 对比 |
| --- | --- | --- | --- |
| 自动补全 | 只支持命令、文件名 | 支持命令、选项、文件名 | |
| 文件系统 | ext4 | xfs | 随机读写更快 |
| repo 仓库 | yum | yum-config-manager | 添加仓库便捷 |
| 修改主机名 | /etc/sysconfig/network | /etc/hostname | hostnamectl |
| 修改时区 | /etc/sysconfig/clock | timedatectl set-timezone | 更方便 |
| 防火墙 | iptables | firewalld | — |
| 服务管理 | System V init | systemd | — |
| 时间同步 | ntp | chrony | — |

**补充说明**
1. **文件系统**：XFS 是 CentOS7 默认，比 ext4 更适合大文件、高并发场景，随机读写性能提升显著。
2. **服务管理**：systemd 替代 SysVinit，支持并行启动，开机更快；统一用 `systemctl` 管理（启动/停止/自启）。
3. **时间同步**：chrony 比 ntp 更轻量，网络波动时同步精度更高，CentOS7 推荐 `chronyd`。

---

## 三、实用操作对比

### 1. 自动补全
```bash
yum install bash-completion -y
```

### 2. 搭建本地 yum 源
**CentOS6**
```bash
# 挂载光盘
mount /dev/cdrom /mnt/
cd /etc/yum.repos.d/ && gzip *        # 备份原 repo
cat > /etc/yum.repos.d/local.repo <<EOF
[local]
name=This is local yum repo
baseurl=file:///mnt
EOF
yum install vim -y
```

**CentOS7**
```bash
mount /dev/cdrom /mnt/
yum provides yum-config-manager        # 查工具所属包
yum install yum-utils -y
cd /etc/yum.repos.d/ && gzip *
yum-config-manager --add-repo=file:///mnt
yum install vim -y
```

### 3. 修改主机名
**CentOS6**
```bash
hostname oldboy_temp      # 临时
bash                       # 重新载入 bash 生效
sed -i '/^HOSTNAME=/c HOSTNAME=oldboyedu' /etc/sysconfig/network   # 永久
```

**CentOS7**
```bash
hostname oldboy-c7        # 临时
bash
hostnamectl set-hostname oldboyedu-c7   # 永久
cat /etc/hostname
```

### 4. 修改时区
```bash
timedatectl list-timezones                  # 查看所有时区
timedatectl set-timezone "Asia/Shanghai"   # 设为上海
```

### 5. 系统文件目录结构
```
CentOS6            CentOS7
bin        →       bin → usr/bin
sbin       →       sbin → usr/sbin
lib        →       lib → usr/lib
```
```bash
tree -dL 1 /
# /bin -> usr/bin  /sbin -> usr/sbin  /lib -> usr/lib  /lib64 -> usr/lib64 ...
```
![目录结构](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-17.jpeg)

### 6. 网络命名规则
```
biosdevname   →  em1 em2 em3
net.ifnames   →  ens33 ens34 ens35
```
- `net.ifnames`：基于固件/拓扑自动命名（如 ens32，比 eth0 难读）。
- `biosdevname`：根据 BIOS 信息命名（如 em1，戴尔常见）。

```bash
ip addr                                      # 查看 IP
ip addr add 192.168.56.200/24 dev eth0:1     # 添加多 IP
ip link set dev eth0 down                    # 控制网卡

yum install net-tools -y                     # 装后可用的 ifconfig
yum provides *ifconfig                       # 查 ifconfig 所属包
```

### 7. 启动级别（runlevel → target）
```
SysVinit                              Systemd
关闭系统       0       runlevel0.target, poweroff.target
单用户模式     1       runlevel1.target, rescue.target
多用户模式     2       runlevel2.target, multi-user.target
多用户+网络    3       runlevel3.target, multi-user.target
多用户+图形    5       runlevel5.target, graphical-user.target
重启           6       runlevel6.target, reboot.target
```
```bash
# CentOS6：vim /etc/inittab
# CentOS7：
systemctl get-default                              # 查看默认 target
systemctl set-default multi-user.target            # 建议用这个（等价 runlevel3）
systemctl set-default graphical.target             # 图形（等价 runlevel5）

# 关机/重启
poweroff            # 个人测试机可用
reboot              # 重启
shutdown -h now     # 生产首选：安全、有提示
systemctl poweroff  # 自动化/脚本首选，效果同 shutdown -h now
```

### 8. systemd 服务管理
```
systemctl [OPTIONS...] COMMAND [NAME...]
操作           CentOS6                      CentOS7
启动服务       /etc/init.d/crond start       systemctl start crond
停止服务       /etc/init.d/crond stop        systemctl stop crond
重启服务       /etc/init.d/crond restart     systemctl restart crond
查看状态       /etc/init.d/crond status       systemctl status crond
开机启动       chkconfig --level 35 crond on  systemctl enable crond
开机禁用       chkconfig crond off            systemctl disable crond
禁止运行       —                             systemctl mask crond
```
```bash
service crond restart          # 7 上为兼容 6 习惯保留
systemctl restart crond        # 7 推荐
systemctl list-unit-files      # 查看所有服务开机状态
systemctl is-enabled crond     # 检查是否开机自启
```

---

## 四、CentOS7 系统优化（初始化）

```bash
# SSH 优化：关闭 DNS 反向解析和 GSSAPI 认证，提速登录
sed -rie "/UseDNS/s/yes/no/g;/UseDNS/s/#//g;/^GSSAPI/s/yes/no/g" /etc/ssh/sshd_config
systemctl restart sshd

# 1. 调整 yum 源
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# 也可：yum install epel-release.noarch
yum clean all && yum makecache

# 2. 安装基础软件包
yum install net-tools vim tree htop iotop iftop \
  lrzsz sl wget unzip telnet nmap nc psmisc \
  dos2unix bash-completion sysstat rsync nfs-utils -y

# 3. 关闭防火墙
systemctl disable firewalld
systemctl stop firewalld

# 4. 关闭 SELinux
setenforce 0
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config

# 5. 优化 ulimit
echo '* - nofile 65535' >> /etc/security/limits.conf

# 6. 关闭图形化网卡管理 / 邮件服务（服务器不需要）
systemctl stop NetworkManager && systemctl disable NetworkManager
systemctl stop postfix && systemctl disable postfix.service

# 7. 网卡配置（自动获取 IP 版）
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
TYPE=Ethernet
BOOTPROTO=dhcp
NAME=eth0
DEVICE=eth0
ONBOOT=yes
DNS1=223.5.5.5
EOF
systemctl restart network

# 手动设 IP 版
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
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

# 8. 关机打快照
shutdown -h now
```

### CentOS6 关闭防火墙与 SELinux
```bash
# 防火墙（iptables）
/etc/init.d/iptables stop
chkconfig iptables off
chkconfig | grep iptables     # 检查：0~6 全 off

# SELinux（永久，需重启）
# /etc/selinux/config 中 SELINUX=enforcing|permissive|disabled
sed -i s#SELINUX=enforcing#SELINUX=disabled# /etc/selinux/config
# 临时（重启失效）
getenforce        # 查看当前
setenforce 0      # Enforcing → Permissive
```

---

## 五、CentOS7 添加内网卡
![添加内网卡1](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-18.png)
![添加内网卡2](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-Centos7%E5%92%8Ccentos6%E5%8C%BA%E5%88%AB-19.png)

```bash
nmcli connection add con-name eth1 ifname eth1 type ethernet \
  ipv4.addresses 172.16.1.222/24 autoconnect yes ipv4.method manual

yum install epel-release.noarch
```

---

## 六、英文词汇对照（学习用）

| 单词/词组 | 含义 |
| --- | --- |
| nothing to do | 无事可做 |
| Package | 软件包 |
| already | 已经 |
| and | 和 |
| latest | 最新的 |
| version | 版本 |
| loaded plugins | 加载插件 |
| Complete | 完成 |
| hostnamectl | host(主机)+name(名字)+ctl(control 控制) |
| zone | 区域 |
| time | 时间 |
| multi | 多 |
| analogous | 类似的 |
| target | 目标 |
| poweroff / shutdown / reboot | 关机 / 关机 / 重启 |
| systemd / systemctl | 系统服务管理 / 服务管理命令 |
| status | 状态 |
| clean | 清洁（清理） |
| makecache | 同步服务器缓存 |
| firewall | 防火墙 |
| done | 完成 |
| software selection | 软件选择 |
| installation source / destination | 安装源 / 安装位置 |
| keyboard / localization | 键盘 / 本地化 |
| established | 已建立连接的 |
| enabled | 启用 |

---

## 七、扩展：时间同步与内核升级

### 1. 系统时间与网络时间同步
```bash
# CentOS7（ntp 方式）
yum -y install ntp
systemctl enable ntpd && systemctl start ntpd
ntpdate ntp1.aliyun.com          # 手动同步
timedatectl                     # 查看时间（Time zone: Asia/Shanghai）

# CentOS6.9
ntpdate ntp2.aliyun.com
```
> 实际生产更推荐用 chrony（CentOS7 默认）。

### 2. 内核升级（EL7）
```bash
# https://dl.lamp.sh/kernel/el7/
wget https://dl.lamp.sh/kernel/el7/kernel-ml-devel-6.9.10-1.el7.x86_64.rpm
wget https://dl.lamp.sh/kernel/el7/kernel-ml-6.9.10-1.el7.x86_64.rpm
yum localinstall -y kernel-ml-6.9.10-1.el7.x86_64.rpm kernel-ml-devel-6.9.10-1.el7.x86_64.rpm

awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg   # 查看可用内核
grub2-set-default 'CentOS Linux (6.9.10-1.el7.x86_64) 7 (Core)'   # 设默认启动内核
grub2-editenv list
reboot
uname -r
```

---

## 八、常见面试题

1. **CentOS7 安装时加 `net.ifnames=0 biosdevname=0` 有什么用？**
   让网卡名沿用传统的 eth0/eth1，而不是 ens33 等可预测命名；需更新 grub 并重启才永久生效。

2. **CentOS6 与 7 的防火墙、时间同步、服务管理分别是什么？**
   6：iptables + ntp + SysVinit(service/chkconfig)；7：firewalld + chrony + systemd(systemctl)。

3. **如何永久修改 CentOS7 主机名？**
   `hostnamectl set-hostname 名字`（写入 /etc/hostname），无需重启。

4. **systemctl enable 和 mask 的区别？**
   enable 设开机自启；mask 比 disable 更彻底——创建指向 /dev/null 的软链，连手动 start 都被禁止，防止被依赖拉起。

5. **生产环境关机推荐用哪个命令？**
   手动维护首选 `shutdown -h now`（有提示、优雅）；脚本/自动化首选 `systemctl poweroff`，效果等价。

6. **为什么优化时要关闭 SELinux 和 NetworkManager？**
   SELinux 策略严格易导致服务异常（学习/测试环境常关）；NetworkManager 与手动网卡配置可能冲突，服务器通常用 network 而非 NM 管理。

---

> 更新：2026-05-14 13:19:37
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/vq2qss>
