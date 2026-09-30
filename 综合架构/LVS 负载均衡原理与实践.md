# LVS 负载均衡原理与实践

> LVS（Linux Virtual Server）即 Linux 虚拟服务器，由章文嵩博士主导的开源负载均衡项目，已集成进 Linux 内核。它在内核中实现基于 IP 的负载均衡调度。
> 官网：<http://www.linuxvirtualserver.org/>

![LVS 体系结构](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-01.webp)

---

## 一、前置：netfilter 基本原理

LVS 基于 Linux 内核的 **netfilter** 框架实现。我们常说的「Linux 防火墙」就是 netfilter，但平时操作的是 **iptables**（只是用户空间传递规则的工具），真正工作的是 netfilter。

![netfilter 工作机制](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-02.webp)

netfilter 提供一整套 **hook 函数**管理机制，实现数据包过滤、NAT、连接跟踪。它在数据包流经路径上设置了 **5 个关卡（hook 点）**：

| hook 点 | 触发时机 |
| --- | --- |
| **PREROUTING** | 刚进入网络层、未做路由查找的包 |
| **INPUT** | 路由查找后，确定发往本机的包 |
| **FORWARD** | 路由查找后，要转发的包（POSTROUTING 之前） |
| **OUTPUT** | 本机进程刚发出的包 |
| **POSTROUTING** | 已做路由查找、确定转发、即将离开本设备的包 |

**数据包走向**：进入网卡 → 链路层 → 网络层 → PREROUTING → 路由查找：
- 目标 IP 是本机 → INPUT → 协议栈 → 应用 → OUTPUT → POSTROUTING → 出网卡；
- 目标 IP 不是本机且开启 forward → FORWARD → POSTROUTING → 出网卡。

---

## 二、LVS 的组成及作用

LVS 由两部分程序组成：**ipvs** + **ipvsadm**。

- **ipvs（IP Virtual Server）**：工作在内核态，基于 netfilter 框架实现 IPVS 功能。用户配置的 VIP 等信息通过 ipvsadm 传递到内核的 ipvs。
- **ipvsadm**：LVS 用户态配套工具，实现 VIP 和 RS 的增删改查，通过 Netlink / raw socket 与内核通信。类比：LVS 是 netfilter，ipvsadm 就相当于 iptables。

---

## 三、LVS 特性

- 工作在网络二/三/四层，仅作分发，CPU/内存消耗很低；**DR 模式下流量直接走后端网卡，性能可媲美硬件负载**。
- 内核直接集成，配置简单，无复杂配置项。
- 应用范围广（可对 HTTP、数据库等几乎所有应用做负载）；负载策略多样：**3 种工作模式 + 10 种调度算法**。
- **不支持**七层虚拟主机、Rewrite 正则、动静分离 —— 这是 Nginx、HAProxy 的优势。
- 适合中大型架构，不适合中小型应用。

### LVS 相关术语
| 术语 | 含义 |
| --- | --- |
| **DS**（Director Server） | 前端负载均衡器节点 |
| **RS**（Real Server） | 后端真实工作服务器 |
| **VIP**（Virtual IP） | 对外面向用户请求的 IP（用户访问目标） |
| **DIP**（Director IP） | 负载调度器用于和内部主机通信的 IP |
| **RIP**（Real Server IP） | 后端服务器 IP |
| **CIP**（Client IP） | 客户端 IP |

---

## 四、LVS 原理架构

![LVS 原理架构](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-03.webp)

1. IPVS 虚拟出对外提供访问的 **VIP** 地址。
2. 用户通过这个 VIP 访问服务器。
3. 请求经过 VIP 到达负载调度器的内核空间。
4. PREROUTING 链接收请求，确定是本机 IP，发往 INPUT 链。
5. 到达 INPUT 链后，IPVS 将请求与 ipvsadm 定义的规则比对；若匹配集群服务，IPVS 强行修改数据包并发往 POSTROUTING 链。
6. POSTROUTING 链发现目标 IP 正好是后端服务器，最终发给后端 RS。

---

## 五、LVS 三种工作模式（+ FullNAT）

### 1. NAT 模式（Network Address Translation）
![NAT 模式](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-04.webp)

- **原理**：LVS 调度器双网卡（eth0 内网、eth1 外网 VIP）。用户经 DNS 解析到 VIP，LVS 按算法选一台 RS，转发前**修改目标 IP 和端口**（支持端口映射）；RS 响应先回 LVS，LVS 再把源 IP/端口改回 VIP 发回客户端（靠连接 Hash 表保证同一连接落到同一 RS）。
- **优点**：支持 Windows；支持端口映射（RS PORT 与 VPORT 可不一致）。
- **缺点**：RS 需把网关指向 DIP；**请求和响应双向流量都过 LVS**，带宽成为瓶颈。
- **场景**：对 Windows 友好，用 LVS 必须选 NAT。

### 2. DR 模式（Direct Routing，直接路由）
![DR 模式](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-05.webp)

- **原理**：LVS 只承担入站请求并按算法选 RS，最终由 RS **直接回包**给客户端。要求 LVS 与 RS 在同一局域网，**VIP 在调度器和所有 RS 间共享**：调度器的 VIP 对外可见，RS 的 VIP 配置在 **lo 回环接口别名**上，并通过内核参数限制其不向外广播 ARP。
- **RS 关键配置**：修改 `arp_ignore` 和 `arp_announce`，把 VIP 配在 lo 上，限制 RS 不响应 VIP 的 ARP 解析请求。
- **优点**：响应数据不经过 LVS，性能高；对数据包修改小，信息完整性好；可透传客户端源 IP。
- **缺点**：LVS 与 RS 必须在同一物理网络；RS 需配 lo 和内核参数；不支持端口映射。
- **场景**：性能要求高首选 DR。

### 3. TUN 模式（IP Tunneling，IP 隧道）
![TUN 模式](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-06.webp)

- **原理**：请求与响应分离，调度器只处理请求，RS 直接回包。IP 隧道将发往 VIP 的原始包封装、加新包头（新源/目标 IP 端口），通过隧道转发给 RS；RS 收到后直接响应客户端。
- **优点**：单臂模式，LVS 压力小；数据包修改小；可跨机房。
- **缺点**：不支持端口映射；RS 需装模块配 VIP；隧道头部固定可能导致 RS 网卡流量不均；封装可能分片影响性能。
- **场景**：转发性要求高、有跨机房需求。

### 4. FullNAT 模式（阿里研发）
同时修改请求报文的**源 IP 和目标 IP**（及端口）进行转发。
- 与 NAT 本质相同（请求/响应都过 Director），区别：NAT 仅改目的 IP/端口，FullNAT 源目 IP 和端口都改。
- NAT：RIP 网关要指向 DIP；FullNAT：RIP 与 DIP 不必同网段，但需能通信。

### 小结对比
| 模式 | 请求 | 响应 | 特点 |
| --- | --- | --- | --- |
| **NAT** | 经 Director | 经 Director | RIP 网关指向 DIP；支持端口映射；瓶颈在带宽 |
| **FullNAT** | 经 Director | 经 Director | 源目 IP 都转换；RIP/DIP 不必同网段 |
| **DR** | 经 Director | RS 直接回 Client | 改 MAC；LVS/RS 同二层；不支持端口映射 |
| **TUN** | 经 Director | RS 直接回 Client | IP 隧道封装；支持跨机房 |

> 参考：<https://blog.csdn.net/weixin_51867896/article/details/123646168>、<https://blog.csdn.net/u010489158/article/details/86776691>

---

## 六、LVS 调度算法（10 种）

无论哪种工作模式，调度算法都是核心。内核主要实现 10 种：

| 算法 | 简称 | 说明 |
| --- | --- | --- |
| 轮询调度 | **RR** | 依次循环分配，假设所有 RS 能力相同，简单平均 |
| 加权轮询 | **WRR** | 给 RS 加权重，权重越高处理的请求越多（A:1、B:2 → B 请求数是 A 两倍） |
| 最小连接 | **LC** | 新连接分给当前连接数最小的 RS（动态，记录各 RS 连接数） |
| 加权最小连接 | **WLC** | LC 超集，按权重比例分配；可动态问询 RS 负载调整权重（默认权重 1） |
| 基于局部的最少连接 | **LBLC** | 针对目标 IP 的负载均衡，主要用于 Cache 集群 |
| 带复制的基于局部最少连接 | **LBLCR** | LBLC 增强，维护「目标 IP → 一组服务器」映射，超载时从全集群选并加入组 |
| 目标地址散列 | **DH** | 按目标 IP 作 Hash Key 找服务器，可用且未超载则发送 |
| 源地址散列 | **SH** | 按源 IP 作 Hash Key（同一客户端总到同一 RS，会话保持场景） |
| 最短期望延迟 | **SED** | 基于 WLC，运算 `(1+连接数)/权重`，取结果最小者 |
| 最少队列 | **NQ** | 无需队列，若有 RS 连接数=0 直接分配，否则做 SED 运算 |

**SED 示例**：A/B/C 权重 1/2/3，新请求运算：
```
A: (1+1)/1 = 2
B: (1+2)/2 = 3/2
C: (1+3)/3 = 4/3   → 选 C（结果最小）
```

---

## 七、常见面试题

1. **LVS 工作在内核哪部分？用户态工具是什么？**
   LVS 核心是内核的 ipvs（基于 netfilter），用户态用 ipvsadm 配置 VIP/RS。

2. **LVS 有哪几种工作模式？最常用哪个？**
   NAT、DR、TUN、FullNAT。生产最常用 **DR**（响应不经 LVS，性能最高），跨机房用 TUN。

3. **NAT 和 DR 的区别？**
   NAT 请求和响应都过 Director，RS 网关指向 DIP，支持端口映射但带宽瓶颈；DR 只改目标 MAC，响应由 RS 直接回客户端，性能高，但 LVS/RS 需同二层、不支持端口映射。

4. **DR 模式为什么 RS 要把 VIP 配在 lo 上，还要改 arp_ignore/arp_announce？**
   多台机器共用一个 VIP，若不限制，RS 会响应 VIP 的 ARP 导致客户端直连 RS。配在 lo 且不广播/应答 VIP 的 ARP，保证只有 Director 的 VIP 对外可见，RS 只收目标地址为 VIP 的数据包。

5. **LVS 不支持七层功能，那谁补位？**
   Nginx、HAProxy 支持七层（虚拟主机、动静分离、Rewrite），常作为 LVS 之后的应用层负载。

6. **LVS 常见调度算法有哪些？rr 和 wrr 区别？**
   RR/WRR/LC/WLC/LBLC/LBLCR/DH/SH/SED/NQ。rr 平均轮询；wrr 加权轮询，权重高的 RS 分到更多请求。

7. **想要同一客户端总是落到同一台 RS（会话保持），用什么算法？**
   源地址散列 **SH**（按源 IP Hash）。

---

> 参考链接：<https://blog.csdn.net/weixin_38738049/article/details/125749863>、<https://blog.csdn.net/weixin_40470303/article/details/80541639>
