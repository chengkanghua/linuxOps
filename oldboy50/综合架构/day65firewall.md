# day65 Firewalld 防火墙

> `firewalld` 是 RHEL/CentOS 7 默认的**动态防火墙管理器**，支持 CLI（`firewall-cmd`）和 GUI（`firewall-config`）两种方式。相比传统 iptables，它支持动态更新，并引入 **zone（区域）** 概念——预先准备多套策略模板，按场景切换即可。

**默认策略**
- 从**外访问服务器内部**：默认阻止（需加规则放行）。
- 从**服务器内部访问外部**：默认允许。

> 注意：一个 zone 只能绑定一个网卡，但一个 zone 可以针对**不同源地址**设置不同规则。
> 配置目录：`/usr/lib/firewalld`（默认模板）、`/etc/firewalld/`（用户配置，优先）。

### 常用术语（中英对照）
| 英文 | 含义 |
| --- | --- |
| target | 目标（默认策略） |
| trusted | 可信，允许所有流量 |
| drop | 丢弃（不回应） |
| reject | 拒绝（返回拒绝） |
| rich rules | 富规则 |
| masquerade | IP 伪装（SNAT） |
| forward-port | 端口转发 |
| permanent / runtime | 永久 / 运行时 |

---

## 一、区域（zone）管理

| 区域 | 默认规则 |
| --- | --- |
| trusted | 允许所有数据包流入流出 |
| home | 拒绝流入，除非与流出相关；ssh/mdns/ipp-client/samba-client/dhcpv6-client 允许 |
| internal | 同 home |
| work | 拒绝流入，除非与流出相关；ssh/ipp-client/dhcpv6-client 允许 |
| public | 拒绝流入，除非与流出相关；ssh/dhcpv6-client 允许 |
| external | 拒绝流入，除非与流出相关；ssh 允许 |
| dmz | 拒绝流入，除非与流出相关；ssh 允许 |
| block | 拒绝流入，除非与流出相关 |
| drop | 拒绝流入，除非与流出相关 |

### 规则状态
- **runtime（运行时）**：立即生效，临时（重启失效），不建议日常使用。
- **permanent（持久）**：修改后需 `--reload` 才生效，强烈推荐。

### `firewall-cmd` 常用参数
| 参数 | 作用 |
| --- | --- |
| `--get-default-zone` | 查默认区域 |
| `--set-default-zone=<区域>` | 设置默认区域（永久） |
| `--get-active-zones` | 显示当前活跃区域与网卡 |
| `--get-zones` | 显示所有可用区域 |
| `--new-zone=<名>` | 新增区域 |
| `--get-services` | 显示预定义服务 |
| `--add-service=<服务>` | 默认区域放行该服务 |
| `--remove-service=<服务>` | 取消放行该服务 |
| `--add-port=<端口/协议>` | 默认区域放行该端口 |
| `--remove-port=<端口/协议>` | 取消放行该端口 |
| `--add-interface=<网卡>` | 将该网卡流量导向某区域 |
| `--change-interface=<网卡>` | 关联网卡与区域 |
| `--list-all` | 显示当前区域配置 |
| `--reload` | 让永久配置立即生效 |

---

## 二、区域配置实战

### 1. 启用 firewalld（禁用旧防火墙）
```bash
systemctl mask iptables ip6tables
systemctl start firewalld
systemctl enable firewalld
```

### 2. 查看区域
```bash
firewall-cmd --get-default-zone          # public
firewall-cmd --get-active-zone
# public
#   interfaces: eth0 eth1
```

### 3. drop 默认拒绝 + 白名单（10.0.0.0/24 走 trusted）
```bash
firewall-cmd --set-default-zone=drop
firewall-cmd --permanent --change-interface=eth0 --zone=drop
firewall-cmd --permanent --add-source=10.0.0.0/24 --zone=trusted
firewall-cmd --reload
firewall-cmd --get-active-zones
# drop     interfaces: eth0          # 默认区域
# trusted  sources: 10.0.0.0/24     # 白名单网段
```

### 4. 按源 IP 给不同权限
```bash
# 10.0.0.1 仅允许 ssh
firewall-cmd --add-source=10.0.0.0/24 --permanent --zone=public
# 192.168.20.0/24 加入白名单
firewall-cmd --add-source=192.168.20.0/24 --permanent --zone=trusted
firewall-cmd --reload
firewall-cmd --get-active-zone
# drop      interfaces: eth0 eth1
# public    sources: 10.0.0.1/32
# trusted   sources: 192.168.20.0/24
```

### 5. 查看指定区域明细
```bash
firewall-cmd --list-all --zone=drop
# drop (active)  target: DROP  services:  ports:  ...
firewall-cmd --list-all --zone=trusted
# trusted (active)  target: ACCEPT  sources: 10.0.0.0/24
```

### 6. 查询 public 是否放行 ssh/https
```bash
firewall-cmd --zone=public --query-service=ssh    # yes
firewall-cmd --zone=public --query-service=https   # no
```

### 7. 恢复默认
```bash
firewall-cmd --set-default-zone=public
firewall-cmd --remove-source=10.0.0.0/24 --zone=public --permanent
firewall-cmd --remove-source=192.168.20.0/24 --zone=trusted --permanent
firewall-cmd --reload
```

---

## 三、端口访问策略
```bash
# 1. 永久放行 8080/tcp 8080/udp 并生效
firewall-cmd --permanent --add-port=8080/udp --add-port=8080/tcp
firewall-cmd --reload
firewall-cmd --list-ports         # 8080/tcp 8080/udp
# 2. 永久拒绝 8080/udp
firewall-cmd --permanent --remove-port=8080/udp
firewall-cmd --reload && firewall-cmd --list-ports   # 8080/tcp
```

---

## 四、服务访问策略
```bash
# 1. 放行 http https
firewall-cmd --permanent --add-service=http --add-service=https
firewall-cmd --reload
firewall-cmd --list-services      # ssh dhcpv6-client http https

# 2. 自定义 php-fpm 服务（监听 9000）
cd /usr/lib/firewalld/services/
cp http.xml php-fpm.xml
cat php-fpm.xml
# <?xml version="1.0" encoding="utf-8"?>
# <service>
#   <short>PHP-FPM</short>
#   <description> php-fpm </description>
#   <port protocol="tcp" port="9000"/>
# </service>
firewall-cmd --permanent --add-service=php-fpm
firewall-cmd --list-services      # ... http https php-fpm
yum install php-fpm -y && systemctl start php-fpm
telnet 10.0.0.61 9000            # Connected

# 3. 拒绝 https、php-fpm
firewall-cmd --permanent --remove-service=https --remove-service=php-fpm --zone=public
firewall-cmd --reload
firewall-cmd --list-service       # ssh dhcpv6-client http
```

---

## 五、端口转发策略

> 格式：`firewall-cmd --permanent --zone=<区域> --add-forward-port=port=<源端口>:proto=<协议>:toport=<目标端口>:toaddr=<目标IP>`

```bash
# 1. 本机 555/tcp → 22/tcp（当前+永久）
firewall-cmd --permanent --zone=public --add-forward-port=port=555:proto=tcp:toport=22:toaddr=10.0.0.61
firewall-cmd --reload

# 2. 移除
firewall-cmd --remove-forward-port=port=555:proto=tcp:toport=22:toaddr=10.0.0.61
firewall-cmd --reload

# 3. 本地 6666 → 后端 10.0.0.9:22（需开启 IP 伪装）
firewall-cmd --add-masquerade --permanent
firewall-cmd --permanent --zone=public --add-forward-port=port=6666:proto=tcp:toport=22:toaddr=10.0.0.9
firewall-cmd --reload
```

---

## 六、富规则（rich rules）

> 富规则是最细致、优先级最高的策略，可针对服务、端口、源/目的地址等做精细控制。区域内按先后顺序匹配，先匹配先生效。

```bash
man firewall-cmd
man firewalld.richlanguage
# 语法骨架：
rule [family="ipv4|ipv6"]
  [source address="address[/mask]" [invert="True"]]
  [destination address="address[/mask]" invert="True"]
  service name="service name" | port port="port" protocol="tcp|udp" |
  protocol value="..." | forward-port port=... to-port=... to-addr=... |
  [log] [audit]
  accept | reject | drop

# 操作
--add-rich-rule='<RULE>'      # 指定区添加
--remove-rich-rule='<RULE>'   # 删除
--query-rich-rule='<RULE>'    # 查询（0 找到/1 未找到）
--list-rich-rules             # 列出所有富规则
```

### 示例
```bash
# 1. 仅允许 10.0.0.1 访问 http（其他同网段不行）
firewall-cmd --permanent --zone=public --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 port port=80 protocol=tcp accept'
firewall-cmd --reload

# 2. 拒绝 10.0.0.9 的 ssh 请求
firewall-cmd --permanent --zone=public --add-rich-rule='rule family=ipv4 source address=10.0.0.9/32 service name=ssh drop'
firewall-cmd --reload

# 3. 把 10.0.0.1 的 5551 端口转发到本机 22
firewall-cmd --permanent --zone=public --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 forward-port port=5551 protocol=tcp to-port=22'
firewall-cmd --reload

# 4. 把 10.0.0.1 的 6661 端口转发到后端 10.0.0.9:22
firewall-cmd --add-masquerade --permanent
firewall-cmd --permanent --zone=public --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 forward-port port=6661 protocol=tcp to-port=22 to-addr=10.0.0.9'
firewall-cmd --reload
```

---

## 七、开启内部上网（SNAT 伪装）

> 在带公网 IP 的实例上开启 NAT 网关的源地址转换（IP 伪装）。

```bash
# 1. 开启 masquerade（永久）
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload

# 2. 客户端把网关指向该防火墙主机
cat /etc/sysconfig/network-scripts/ifcfg-eth1
# GATEWAY=172.16.1.61
cat /etc/resolv.conf
# nameserver 223.5.5.5
nmcli connection reload
nmcli connection down eth1 && nmcli connection up eth1
ping baidu.com      # 通
```

---

## 常见面试题

1. **firewalld 相比 iptables 的优势？**
   支持动态更新、引入 zone 区域模板，可按场景快速切换整套策略，无需重启规则。

2. **firewalld 默认策略？**
   外→内默认拒绝，内→外默认允许。

3. **runtime 和 permanent 区别？**
   runtime 立即临时生效（重启丢失）；permanent 需 `--reload` 才生效、永久保存。建议用 permanent。

4. **富规则有什么特点？**
   最细致、优先级最高的规则，可对源/目的 IP、服务、端口、转发做精细匹配，区域内按先后顺序匹配。

5. **端口转发和 SNAT 伪装的区别？**
   端口转发是把某端口流量转到另一端口/IP；SNAT 伪装（masquerade）是让内网主机通过公网主机上网，做源地址转换。

6. **drop 和 reject 区别？**
   drop 静默丢弃（不回应），reject 明确返回拒绝；drop 更安全（不暴露主机存在）。

---

> 更新：2024-08-31 20:54:29
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/siod6r>
