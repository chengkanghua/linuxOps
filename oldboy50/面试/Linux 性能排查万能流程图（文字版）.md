

```plain
服务器卡顿/响应慢
                             ↓
               uptime / top 看负载 & idle CPU
             ┌────────┬─────────┬──────────────┐
load高+idle低   load高+idle高   load正常但仍慢
     ↓              ↓               ↓
   CPU排查       磁盘I/O排查     内存 / 网络排查

【CPU排查】
top 看 %CPU 最高进程
vmstat 1
├─ us 高 → 业务代码/计算密集/死循环
├─ sy 高 → 系统调用/锁竞争/上下文切换高
└─ wa 高 → 直接跳磁盘I/O
pidstat -w 1 → 看 cswch/s 切换次数

【内存排查】
free -h 看 available & swap
vmstat 1 看 si/so 是否持续读写
├─ si/so 频繁 → 内存不够+交换导致卡顿
├─ available 低 → 内存不足
└─ top 按 M → 定位吃内存进程

【磁盘I/O排查】
iostat -x 1
├─ %util ≈100% → I/O 满载
├─ await 远大于 svctm → I/O 排队
└─ iotop → 定位疯狂读写进程

【网络排查】
sar -n DEV 1 → 带宽是否跑满
ip -s link → 丢包/错包
ss -tan 统计连接状态
├─ TIME_WAIT 多 → TCP 参数优化
└─ CLOSE_WAIT 多 → 应用未正常关闭连接
```

---

# <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. 口袋速查卡（复制到备忘录）</font>
```plain
【1分钟定位口诀】
1. load 高、idle 低 → CPU 瓶颈
2. wa 高、util 100% → 磁盘 I/O
3. si/so 不停、内存低 → Swap 内存瓶颈
4. 流量满、丢包、连接异常 → 网络

【常用命令】
uptime
top
vmstat 1
free -h
iostat -x 1
iotop
sar -n DEV 1
ss -tan
ip -s link


```

---

# <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3. 完整版一键排查脚本（直接复制运行）</font>
```bash
cat > check.sh <<'EOF'
#!/bin/bash
clear
echo "================================================="
echo "           Linux 性能一键排查脚本"
echo "================================================="

echo -e "\n[1] 系统负载"
uptime

echo -e "\n[2] CPU 总览（top）"
top -bn1 | head -15

echo -e "\n[3] CPU/内存/IO/交换 总览（vmstat）"
vmstat 1 3

echo -e "\n[4] 内存使用"
free -h

echo -e "\n[5] 磁盘 IO 详情（iostat -x）"
iostat -x 1 2

echo -e "\n[6] 网络流量"
sar -n DEV 1 2

echo -e "\n[7] TCP 连接状态"
ss -tan | awk '{print $1}' | sort | uniq -c

echo -e "\n[8] 网卡丢包/错包"
ip -s link

echo -e "\n================================================="
echo "判断速查："
echo "wa 高          → 磁盘IO瓶颈"
echo "us 高          → 应用CPU高"
echo "si/so 持续     → 内存Swap瓶颈"
echo "丢包/流量满    → 网络瓶颈"
echo "================================================="
EOF
chmod +x check.sh
./check.sh
```







```bash

[root@m01 ~]# ./check.sh
=================================================
           Linux 性能一键排查脚本
=================================================

[1] 系统负载
 22:26:17 up  4:11,  2 users,  load average: 0.00, 0.01, 0.05
  当前时间  运行多少时间 2个用户 系统平均负载 最近  1分钟  5分钟 15分钟平均负载
[2] CPU 总览（top）
top - 22:26:17 up  4:11,  2 users,  load average: 0.00, 0.01, 0.05
Tasks: 111 total,   1 running, 110 sleeping,   0 stopped,   0 zombie （僵尸进程）
系统总共有 109 个进程 / 线程
%Cpu(s):  1.8 us, 23.2 sy,  0.0 ni, 75.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
us 用户进程占用 sy：内核系统占用  ni：优先级调整过的进程占用 
id：空闲 CPU 比例（最重要） wa：等待磁盘 I/O 的 CPU 比例
hi：硬件中断  si：软件中断   st：被虚拟机偷走的时间（云服务器才有）
KiB Mem :   995668 total,   233512 free,   168168 used,   593988 buff/cache
KiB Swap:  2097148 total,  2097148 free,        0 used.   647604 avail Mem
单位 KB     buff/cache：缓存占用 ≈ 600MB（Linux 会把空闲内存拿来当缓存，正常，不是占用）
avail Mem：实际可用于应用的内存 ≈ 641MB

   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 18140 root      20   0  161972   2096   1536 R  27.3  0.2   0:00.18 top
     1 root      20   0   43696   4028   2604 S   0.0  0.4   0:07.88 systemd
     2 root      20   0       0      0      0 S   0.0  0.0   0:00.04 kthreadd
     4 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:0H
     5 root      20   0       0      0      0 S   0.0  0.0   0:01.66 kworker/u256:0
     6 root      20   0       0      0      0 S   0.0  0.0   0:00.69 ksoftirqd/0
     7 root      rt   0       0      0      0 S   0.0  0.0   0:00.34 migration/0
     8 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh

PR：优先级 
NI（Nice）进程的 谦让值（Nice Value） 范围：-20 ～ +19 ，NI 越小（越负）→ 优先级越高
VIRT：虚拟内存（不用太关注）
RES：实际物理内存（关键）
SHR：共享内存
S：状态（S = 睡眠，R = 运行）

[3] CPU/内存/IO/交换 总览（vmstat）
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 233768   2108 591880    0    0    16     6   40   44  0  1 99  0  0
 1  0      0 233784   2108 591880    0    0     0     4   52   64  0  1 99  0  0
 0  0      0 233784   2108 591880    0    0     0     0   62   67  0  1 100  0  0
1. procs 进程队列
r：等待 CPU 运行的进程数
b：阻塞（等待 IO / 资源）的进程数
2. memory 内存（单位：KB）
swpd：使用的交换分区大小
free：空闲物理内存
buff：缓冲区内存（块设备缓存）
cache：页缓存（文件缓存）
3. swap 交换分区
si：从 swap 读入内存（swap in）
so：写入 swap（swap out）
si/so 不为 0 说明内存不够用，开始用交换分区
4. io 磁盘读写
bi：从块设备读入数据（块 /s）
bo：写入块设备（块 /s）
5. system 系统中断
in：每秒中断数
cs：每秒上下文切换次数
6. cpu 使用率（总和 100%）
us：用户态 CPU
sy：内核态 CPU
id：空闲 CPU
wa：等待 IO 的 CPU
st：被虚拟机偷走的 CPU（虚拟化环境才有）

[4] 内存使用
              total        used        free      shared  buff/cache   available
Mem:           972M        163M        228M        7.6M        580M        632M
Swap:          2.0G          0B        2.0G

[5] 磁盘 IO 详情（iostat -x）  Linux 下磁盘 IO 详细性能统计
Linux 3.10.0-1160.71.1.el7.x86_64 (m01)         04/21/2026      _x86_64_        (2 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.34    0.00    0.55    0.01    0.00   99.10
%user：用户进程 CPU 占比 → 0.30%
%nice：低优先级进程 CPU → 0%
%system：内核系统调用 CPU → 0.83%
%iowait：CPU 等待磁盘 IO 的时间 → 0.01%（几乎没有 IO 等待）
%steal：虚拟机被宿主机偷走的 CPU → 0%
%idle：空闲 CPU → 98.87%

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.10    0.81    0.53    32.83    11.03    65.70     0.00    1.08    0.90    1.36   0.57   0.08
dm-0              0.00     0.00    0.73    0.62    32.03    10.89    63.37     0.00    1.27    0.95    1.63   0.54   0.07
dm-1              0.00     0.00    0.01    0.00     0.15     0.00    50.09     0.00    0.56    0.56    0.00   0.39   0.00


rrqm/s   Read Request Merged per second 每秒被系统合并的读请求数
wrqm/s    每秒被系统合并的写请求数
r/s：每秒读次数
w/s：每秒写次数
rkB/s：每秒读数据量（KB）
wkB/s：每秒写数据量（KB）
avgrq-sz   Average Request Size   平均每个 IO 请求的大小（扇区为单位）
avgqu-sz  Average Queue Size   IO 队列平均长度（等待处理的 IO 个数）
await：IO 请求平均等待时间（毫秒）
r_await   每个读请求从发起到完成的平均耗时（毫秒）
w_await   每个写请求平均耗时（毫秒）
svctm：平均服务时间（毫秒）
%util：设备繁忙百分比（最重要）


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.50    0.00    0.50    0.00    0.00   99.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00







[6] 网络流量  sar -n DEV 1 2
sar：系统活动报告工具（可以看 CPU、内存、网卡、磁盘…）
-n DEV：查看网络设备（网卡）流量
1：每隔 1 秒采样一次
2：总共采样 2 次

Linux 3.10.0-1160.71.1.el7.x86_64 (m01)         04/21/2026      _x86_64_        (2 CPU)

10:26:20 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
10:26:21 PM      eth0      1.00      0.00      0.06      0.00      0.00      0.00      0.00
10:26:21 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00

10:26:21 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
10:26:22 PM      eth0      1.00      1.00      0.06      0.36      0.00      0.00      0.00
10:26:22 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00

Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
Average:         eth0      1.00      0.50      0.06      0.18      0.00      0.00      0.00
Average:           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00

IFACE  网卡名称  lo：本地回环网卡（127.0.0.1）
rxpck/s  （receive packets per second） 每秒接收数据包个数
txpck/s   transmit packets per second   每秒发送数据包个数
rxkB/s     每秒接收的数据量  单位kb
txkB/s    每秒发送的数据量
rxcmp/s   每秒接收的压缩包数量
txcmp/s   每秒发送的压缩包数量
rxmcst/s   每秒接收的组播包数量



[7] TCP 连接状态  ss -tan | awk '{print $1}' | sort | uniq -c
      2 ESTAB
      5 LISTEN
      1 State

ss 查看所有网络连接状态  -t  tcp a 所有 n 不解析域名 用ip端口显示
awk '{print $1}'  #awk 只取第一列
sort 把相同的排序在一起
uniq -c  去重并统计次数
连接状态：
LISTEN   端口正在监听，等待别人来连接
ESTABLISHED  ESTAB  连接已建立，正在正常通信
TIME_WAIT   主动关闭方，等待确保对方收到包
CLOSE_WAIT   被动关闭方，等待程序关闭连接
FIN_WAIT1   正在发送 FIN，等待对方 ACK  一般很快消失，看不到几个
FIN_WAIT2    已发 FIN，等对方发 FIN   偶尔可见，正常
SYN_RECV     收到 SYN，回复 SYN+ACK，等待对方 ACK
LAST_ACK    被动关闭方发 FIN，等最后一个 ACK   很快消失，正常
最简单记忆版（只记关键）
LISTEN：等着被连
ESTAB：正在通信
TIME_WAIT：正常收尾，等一会儿
CLOSE_WAIT：程序漏关连接 → 要警惕
SYN_RECV：半连接 → 太多可能被攻击

[8] 网卡丢包/错包 ip -s link  
ip：Linux 现代网络管理工具
-s：显示统计数据（statistics）
link：查看 ** 网络接口（网卡）** 信息
查看网卡状态、MAC 地址、MTU、收包统计、发包统计、错误包、丢包、溢出等。

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
1编号 lo网卡名称  
LOOPBACK：本地环回  UP：网卡已启用   LOWER_UP：逻辑已连接
mtu 65536   最大传输单元（本地默认超大） 一次数据包的大小 字节 Byte  64kb
qdisc noqueue 排队规则（本地无队列）
state UNKNOWN 状态未知（lo 固定这样）
mode DEFAULT  mode：网卡的工作模式  默认模式（标准以太网模式）
      default：正常以太网
      dhcp：DHCP 模式（极少显示）
      bond / balance：网卡绑定模式
      loopback：环回（lo 网卡）
      pointopoint：点对点链路（PPP、隧道等）
group default   表示该网卡属于哪个 接口组（interface group） 属于系统默认组（组号 0）
qlen 1000   queue length，网卡发送队列长度 数据包个数

    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    link/loopback   环回地址，无真实 MAC     brd 广播地址
  
    RX: bytes  packets  errors  dropped overrun mcast
    1423352    10789    0       0       0       0
bytes：开机至今总共接收字节数：1,457,252 字节
packets：接收包总数：11,467 个
errors：接收错误包数 → 0 正常
dropped：内核丢弃包数 → 0 正常
overrun：网卡溢出（CPU 处理不过来）→ 0
mcast：组播包数量 → 0

TX（发送）统计
    TX: bytes  packets  errors  dropped carrier collsns
    1423352    10789    0       0       0       0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
BROADCAST：支持广播
MULTICAST：支持组播
UP：网卡已启动
LOWER_UP：物理链路已连接（网线正常）    
qdisc pfifo_fast：queueing discipline，排队规则 / 队列调度算法 pfifo_fast：Linux 以太网默认调度策略
        noop：无队列（lo 网卡用）
        fq_codel：现代通用队列，延迟更低
        htb：限流、带宽控制常用

        
    link/ether 00:0c:29:e4:88:7d brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    18064673   17894    0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    4943231    10849    0       0       0       0



=================================================
判断速查：
wa 高          → 磁盘IO瓶颈
us 高          → 应用CPU高
si/so 持续     → 内存Swap瓶颈
丢包/流量满    → 网络瓶颈
=================================================
```

