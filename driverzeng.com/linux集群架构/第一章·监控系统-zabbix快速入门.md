# 第一章·监控系统-zabbix快速入门

* [监控系统概述](https://www.driverzeng.com/zenglaoshi/2394.html#toc_0)
* [面试常问](https://www.driverzeng.com/zenglaoshi/2394.html#toc_1)
* [单机监控命令了解](https://www.driverzeng.com/zenglaoshi/2394.html#toc_2)
* [使用脚本监控nginx](https://www.driverzeng.com/zenglaoshi/2394.html#toc_3)
* [zabbix监控快速安装](https://www.driverzeng.com/zenglaoshi/2394.html#toc_4)
* [zabbix使用-快速监控一台主机](https://www.driverzeng.com/zenglaoshi/2394.html#toc_5)
* [zabbix监控基础架构](https://www.driverzeng.com/zenglaoshi/2394.html#toc_6)
* [添加自定义监控项入门](https://www.driverzeng.com/zenglaoshi/2394.html#toc_7)

-曾老湿, 江湖人称曾老大。

> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023

***

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1\)整合了各个公有云API，自主创建云主机。
>
> 2\)ELK自动化收集日志功能。
>
> 3\)Saltstack自动化运维统一配置管理工具。
>
> 4\)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5\)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6\)SQL执行及审批流程。
>
> 7\)慢查询日志分析web界面。

***

## 监控系统概述

| 什么是监控？ |
| --- |

监控系统是整个运维环节，乃至整个产品生命周期中最重要的一环，事前及时预警发现故障，事后提供翔实的数据用于追查定位问题。

***

| 为什么要做监控？ |
| --- |

生活中：

1.超市监控：防内外偷

![1574471352430-a58404a1-e83c-4f85-81d5-5a1e4ccb0ff8.gif](img/第一章·监控系统-zabbix快速入门/image1.gif)

2.交通监控：测速，违章

![1574471352352-432e7c03-387c-4e9d-9d35-da9900ea6f91.gif](img/第一章·监控系统-zabbix快速入门/image2.gif)

***

企业中：

1.系统的监控:实际上是对系统不间断的实时监控

2.实时反馈系统当前状态:我们监控某个硬件、或者某个系统，都是需要能实时看到当前系统的状态，是正常、异常、或者故障。

3.保证服务可靠性安全性:我们监控的目的就是要保证系统、服务、业务正常运行

4.保证业务持续稳定运行:如果我们的监控做得很完善，即使出现故障，能第一时间接收到故障报警，在第一时间处理解决，从而保证业务持续性的稳定运行。（往往，第一时间知道业务宕机的都是用户）

***

| 监控怎么来实现？ |
| --- |

***



<!-- OCR_START -->
> CACTI
<!-- OCR_END -->

￼

[1.CACTI(网络监控)](https://www.cacti.net/)

<!-- OCR_START -->
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***



<!-- OCR_START -->
> Nagios
<!-- OCR_END -->

￼

[2.NAGIOS(系统监控)](https://www.nagios.com/)

<!-- OCR_START -->
- http://192.168.1.141/nagios/
- Google
- 访问最多
- RedHat
- Red HatMagazine
- RedHatNetwork
- RedHatSupport
- NNagios
- TestPagefortheApacheHT...
- Nagios
- Last Check
- Host
- Service
- Status
- Duration
- Attempt
- Status Information
- localhost
- Current Load
- OK
- 12-13-201213:28:18
- 0d6h28m14s
- 1/4
- 0K-1oadaverage000,0.02,0.00
- General
- Current Users
- 12-13-201213:28:56
- 0d6h2736s
- USERS OK-2users currently 1ogged
- Home
- in
- HTTP
- WARNING
- 12-13201213:29:33
- 0d6h26m59s
- 4/4
- HTTP WARNING:HTTP/L1 403
- Documentation
- Forbidden
- Current Status
- PING
- 12132012 13:30:11
- 0d 6h26m21s
- PING OK-Packet 1oss=0%,RTA=
- DK
- 0.04
- Tactical 0verview
- Root Partition
- 12-13-2012 13:30:18
- 0d6h25m44s
- DISK 0K-freespace/15H4 MB
- Nap
- （81%inode=97%）:
- Hosts
- SSH
- 12-13-201213:31:26
- 0d6h25m6s
- SSH 0K-0penSSH_4.3(protocol 20)
- OServices
- Host Groups
- Suap lsage
- JK
- 12-13-2012 13:32:03
- 0d6h24m29s
- SWAP0K-100%free（767 MBoutof
- 767MB)
- Summary
- PROCS 0K:36processes with STATE=
- Grid
- Total Processes
- 12-13-201213:28:33
- 0d6h2351s
- RSZDT
- Service Groups
- apache
- 12-13-2012 13:31:21
- 0d4h36m32s
- 1/5
- HTTP 0K HTTP/1.12000K-265bytes
- in 0o03 seconds
- check=cpu
- 12-132012 13:31:01
- 0d0h33m43s
- 1/2
- checkmem
- Services
- (Unhandled)
- 12-13-201213:31:53
- 0d3h20m51s
- 200
- Hosts （Unhandled）
- 曾老湿
- DriverZeng
- 11 Matching Service Entries Displayed
<!-- OCR_END -->

￼

***



<!-- OCR_START -->
> ZABBIX
<!-- OCR_END -->

￼

[3.ZABBIX(分布式监控)](https://www.zabbix.com/)

<!-- OCR_START -->
- ZABBIX
- Monitoring
- Inventory
- Reports
- Configuration
- Administration
- ZShare
- 2
- Dashboard
- Overview
- Web
- Latest data
- Triggers
- Graphs
- Screens
- Maps
- Discovery
- ITservices
- abcdocker监控
- Groupall
- Hostall
- GraphNetworktrafficonetho
- Filter
- Zoom:5m15m30m1h2h3h6h12h1d3d7d14d1mAll
- 2017-04-0221:03:33-2017-04-0222:03:33(n0W!)
- 《《1m7d1d12h1h5m|5m1h12h1d7d1m）》
- 1h fixed
- Zabbixserver:NetworktrafficonethO（1h)
- 100bps
- 80bps
- 60bps
- 40bps
- 20bps
- obps
- Nd
- Wc
- 90
- 80
- 91
- 2N
- 92
- 8Z
- VE
- 5
- 85
- :60
- 61
- OT
- 20/0
- last
- min
- avg
- max
- Incomingnetworktrafficonetho
- 16bps
- 8.27bps
- Outgoingnetworktrafficonetho
- 17.73bps
- 96bps
- OTriaaer:Incomingnetworktrafficonetho
- [>10485760]
- 曾老湿
- tgoingnetworktrafficonetho
- DriverZeng
<!-- OCR_END -->

￼

***



<!-- OCR_START -->
> falcon
<!-- OCR_END -->

￼

[4.open-falcon(小米监控产品)](http://open-falcon.org/)

<!-- OCR_START -->
- Falcon-Screen
- +导航
- Falcon-Dashboard
- Screen
- screen首页
- OPS-
- /falcon transfer
- 克境
- 显示
- 时间股
- +导
- 1h
- 搜索。
- c3-
- 指标
- 监控V2硬件资
- 12h
- falol
- insfer
- 1d
- JNT
- gra]
- 76
- roxy
- stre
- 1m
- n-Reade
- 11 :20
- nx
- DIA
- >20
- 天气
- 曾老湿
- DriverZeng
- 2015-02-0811:34:00
- 0.899
<!-- OCR_END -->

￼

***



<!-- OCR_START -->
> Prometheus
<!-- OCR_END -->

￼

[5.普罗米修斯(监控docker,K8S)](https://prometheus.io/)

<!-- OCR_START -->
- localhost:9090/graph?go.range_input=1m&g0.expr=node_cpu&g0.tab=0
- QSearch
- ☆自
- Prometheus
- Alerts
- Graph
- Status
- Help
- node_cou
- Loadtime:34ms
- Resolution:1s
- Totaltimeseries:9
- Execute
- -insertmetricatcursor
- 1m
- Until
- Res.(s)
- Ostacked
- 500
- 400
- 300
- 200
- 100
- 30s
- 45s
- 15s
- node_cpu{cpu="cpu0"instance="10.0.2.15:9100"job=node",mode=“user}
- node_cpu{cpu="cpu0"instance="10.0.2.15:9100"job=node",mode="system")
- r曾老湿
<!-- OCR_END -->

￼

***

![1574471353302-efc62120-ad82-4fe7-9015-1cfdbcd58b0d.jpeg](img/第一章·监控系统-zabbix快速入门/image13.jpeg)￼

[6.lepus天兔(数据库监控)](http://www.lepus.cc/tag/index/Lepus)

<!-- OCR_START -->
- 天兔
- 仪表盘
- MySQL
- Oracle
- MongoDB
- Redis
- OS
- 大屏
- 告警
- 配置
- 语言
- admin
- 8MySQL
- 2
- 2MongoDB
- 5Redis
- 配置中心
- 主页/仪表盘
- 天免版本：v3.5天免状态正在运行
- 最新监测时间：2014-11-0516:32:39
- MySQL监控
- 健康监控
- 应用
- 主机
- 排序
- APH
- 搜索
- C重盟
- 刷新
- 资源监控
- 服务器
- 数据库
- 操作系统
- 键缓存监控
- 类型
- 角色标签
- 版本
- 连接
- 会话
- 进程
- 等待同步
- 延时
- 表空间
- SNMP
- 负载
- Cpu
- 内存
- 网络
- 磁盘
- 图表
- InnoDB监控
- 112.64.45.30:3316
- m7
- 5.5.35-MariaDB-log
- 进程监控
- 112.64.45.30:3326
- m8
- 5.6.15-rel63.0-log
- 复制监控
- 219.234.6.180:3306
- m1
- 5.5.36
- 219.234.6.180:3307
- m2
- 5.6.12-log
- item:replication
- 表空间分析
- 219.234.6.180:3308
- m3
- value:IOThreadNoSQLThreadN
- level:critical
- 慢查询分析
- 219.234.6.180:3309
- m4
- time:2014-11-19 23:29:16
- AWR报告
- 219.234.6.180:3326
- m5
- 5.1.72-log
- Oracle监控
- 219.234.6.180:3339
- ***
- m6
- **.
- MongoDB监控
- 219.234.6.180:1521
- oracle11g
- 11.2.0.1.0
- 曾老湿
- Mongo
- 219.234.6.180:27017
- mongo1
- 2.6.0
- DriverZeng
- 219.234.6.180:27018
- mongo2
<!-- OCR_END -->

￼

## 面试常问

面试官：你们公司监控是如何做的？

你：用zabbix

面试官：...

<!-- OCR_START -->
- 2
- ?.
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

如果面试，真的被问到以上问题，那么请按照逻辑层次，详细的回答出...

打开面试技巧链接:[TP](https://www.driverzeng.com/zenglaoshi/760.html)

监控软件我们使用的是zabbix，我们监控在不同的维度

***

| 硬件层面 |
| --- |

如果说到硬件，肯定要先说物理服务器用的什么型号？

物理服务器，选型，Dell R710 720 730 ...

`IDRAC`自带一个远程管理卡，安装上一个软件包之后，就可以监控

<!-- OCR_START -->
- 系统
- PowerEdgeR610
- 尾性
- 111,Admin
- 风扇
- 远程访问
- 电池
- 侵入
- 风扇余
- 电源设备
- 属性
- 温度
- 电压
- 元余状况
- 完全
- 电源监控
- LCD
- 探测器列表
- 旅障涡值
- 状况
- 探测器名称
- 读数
- 最小
- 最大
- System BoardFAN MOD 1ARPM
- 4680RPM
- NIA
- NA
- 1920RPM
- NCA
- System Board FAN MOD 2A RPM
- System Board FAN MOD3ARPM
- 4560RPM
- NFA
- System Board FAN MOD 4A RPM
- 1920RFM
- 曾老湿
- 3600RPM
- DriverZeng
- 3480RPM
- NUA
<!-- OCR_END -->

￼

如果不使用dell的idrac那就使用zabbix的`IPMI`接口监控硬件

1）CPU温度，

2）风扇转速，

3）磁盘是否损坏，

4）CMOS电池电量

5）内存是否损坏

6. ...

***

| 系统层面 |
| --- |

1）CPU：使用率、负载

2）内存：使用率

3）磁盘：使用率，IO

4）进程

5）TCP状态

6）系统负载

7. ...

***

| 网络层面 |
| --- |

1）网络设备：路由器，交换机

2）网卡入口流量

3）网卡出口流量

4）带宽的峰值

5）...

使用zabbix的snmp方式监控

***

| 应用层面 |
| --- |

当然了最基本的就是各个服务的进程，端口号

一些特殊程序我们还需要额外监控：

1）MySQL：主从复制是否有延迟（zabbix监控模板）

2）redis：主从复制是否有延迟

监控思路:zabbix没有固定模板，可以在主库中set一个key为时间戳，然后从库会同步这个时间戳（动态），写脚本时时获取这两个时间戳，做对比。

3）NFS：磁盘挂载状况

4）tomcat：JVM监控，老年代、新生代、永久带、full-gc、垃圾回收

5）rsync的同步情况，MD5校验文件是否被篡改

6）...

***

| 业务层面 |
| --- |

1）URL的监控

2）API的监控

3）nginx的状态码

4）tomcat的exception

5）请求时间

6）响应时间

7）加载时间

8）渲染时间

9）...

## 单机监控命令了解

[监控命令参考文档](https://man.linuxde.net/par/3)

***

| CPU监控命令 |
| --- |

1）w

```plain
[root@web02 ~]# w
 12:30:41 up 1 day,  8:10,  1 user,  load average: 0.00, 0.01, 0.05
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/1    10.0.0.1         五09    1.00s  0.00s  0.00s w
```

2）top

```plain
[root@web02 ~]# top
top - 12:31:10 up 1 day,  8:11,  1 user,  load average: 0.00, 0.01, 0.05
Tasks: 100 total,   1 running,  99 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.3 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  2030148 total,  1457796 free,   190464 used,   381888 buff/cache
KiB Swap:  1048572 total,  1048572 free,        0 used.  1652944 avail Mem
```

3）htop

```plain
[root@web02 ~]# htop
 CPU[|                                                                0.7%]   Tasks: 27, 38 thr; 1 running
```

4）glances

```plain
[root@web02 ~]# glances
web02 (CentOS Linux 7.5.1804 64bit / Linux 3.10.0-862.el7.x86_64)                                                                                                                                                       Uptime: 1 day, 8:12:51
CPU  [||                                                                         2.9%]   CPU       2.9%  nice:     0.0%                    MEM     13.1%  active:     310M                    SWAP      0.0%                    LOAD    1-core
MEM  [||||||||||                                                                13.1%]   user:     1.9%  irq:      0.0%                    total:  1.94G  inactive:   145M                    total:   1024M                    1 min:    0.14
SWAP [                                                                           0.0%]   system:   1.0%  iowait:   0.0%                    used:    260M  buffers:   2.03M                    used:        0                    5 min:    0.09
                                                                                         idle:    97.1%  steal:    0.0%                    free:   1.68G  cached:     319M                    free:    1024M                    15 min:   0.07
```

5）uptime

```plain
[root@web02 ~]# uptime
 12:33:18 up 1 day,  8:13,  1 user,  load average: 0.10, 0.08, 0.07
```

不管用什么命令监控，查看CPU，我们都必须了解，系统的用户态和内和态。

```plain
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
us: 用户态     跟用户的操作有关35%
sy: 内和态     跟内核的处理有关65%
id: CPU空闲
```

当我们执行一个命令的时候，很快能出来结果，但是有多少人知道，这个很快，他都占用了哪些时间呢？

```plain
[root@web02 ~]# time ls
backup.sh  group_vars_web_group
real    0m0.002s       真实执行时间
user    0m0.001s       用户执行时间
sys 0m0.001s       系统执行时间
```

***

| 内存监控命令 |
| --- |

1）free

```plain
[root@web02 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:           1982         186        1413           9         383        1612
Swap:          1023           0        1023
[root@web02 ~]# free -h
              total        used        free      shared  buff/cache   available
Mem:           1.9G        186M        1.4G        9.4M        383M        1.6G
Swap:          1.0G          0B        1.0G
```

2）top

3）glances

4）htop

后面这几个命令在看CPU的时候已经演示了。

如何查看单个进程占用内存？

```plain
#进程占用内存公式
pmem = VmRSS / MemTotal * 100
process mem = 虚拟内存 / 总内存 * 100
```

python脚本

```plain
[root@web02 ~]# cat mem.py
#!/usr/bin/env python
# _*_ coding:UTF-8 _*_
# 收集程序所占用的物理内存大小，占所有物理内存的比例
# Python: 2.7.6
import sys
import os
from subprocess import Popen,PIPE
def get_pid(program):
    '获取目标程序的PID列表'
    p = Popen(['pidof',program],stdout=PIPE,stderr=PIPE)
    pids,stderrput = p.communicate()
#     pids = p.stdout.read()  #这种方法也是可以的
#     这里也可以对stderrput来进行判断
    if pids:
        return pids.split()
    else:
        raise ValueError
def mem_calc(pids):
    '计算PIDs占用的内存大小'
    mem_total = 0
    for pid in pids:
        os.chdir('/proc/%s' % pid)
        with open('status') as fd:
            for line in fd:
                if line.startswith('VmRSS'):
                    mem = line.strip().split()[1]
                    mem_total += int(mem)
                    break
    return mem_total
def mem_percent(mem):
    '计算程序内存占用物理内存的百分比'
    with open('/proc/meminfo') as fd:
        for line in fd:
            if line.startswith('MemTotal'):
                total = line.strip().split()[1]
        percent = (float(mem)/int(total)) * 100
    return percent
def main():
    try:
        program = sys.argv[1]
        pids = get_pid(program)
    except IndexError as e:
        sys.exit('%s need a Program name ' % __file__)
    except ValueError as e:
        sys.exit('%s not a Process Name or not Start' % program )
    mem_total = mem_calc(pids)
    percent = mem_percent(mem_total)
    return program,mem_total,percent
if __name__ == '__main__':
    program,mem_total,mem_percent=main()
    print('进程名称:%s\n物理内存为:%s\n百分比为:%.2f%%'% (program,mem_total,mem_percent))
```

***

| 磁盘监控命令 |
| --- |

1）df

```plain
[root@web02 ~]# df -h
文件系统        容量  已用  可用 已用% 挂载点
/dev/sda3        18G  1.4G   17G    8% /
devtmpfs        981M     0  981M    0% /dev
tmpfs           992M     0  992M    0% /dev/shm
tmpfs           992M  9.5M  982M    1% /run
tmpfs           992M     0  992M    0% /sys/fs/cgroup
/dev/sda1      1014M  124M  891M   13% /boot
tmpfs           199M     0  199M    0% /run/user/0
[root@web02 ~]# df -i
文件系统         Inode 已用(I) 可用(I) 已用(I)% 挂载点
/dev/sda3      9436672   36259 9400413       1% /
devtmpfs        251012     393  250619       1% /dev
tmpfs           253768       1  253767       1% /dev/shm
tmpfs           253768     700  253068       1% /run
tmpfs           253768      16  253752       1% /sys/fs/cgroup
/dev/sda1       524288     326  523962       1% /boot
tmpfs           253768       1  253767       1% /run/user/0
```

2）iotop

```plain
[root@web02 ~]# iotop
Total DISK READ :   0.00 B/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:   0.00 B/s | Actual DISK WRITE:       0.00 B/s
```

3）iostat

```plain
#以兆为单位，每秒执行一次，执行10次
[root@web02 ~]# iostat -dm 1 10
```

4）dstat

```plain
[root@web02 ~]# dstat -cdngy
----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
  0   0 100   0   0   0|1729B 3483B|   0     0 |   0     0 |  47    65
  0   0 100   0   0   0|   0     0 |  66B  830B|   0     0 |  92   114
  0   0 100   0   0   0|   0     0 |  66B  350B|   0     0 |  92   106
  0   0 100   0   0   0|   0    16k|  66B  350B|   0     0 | 102   114
```

5）glances

```plain
[root@web02 ~]# glances
DISK I/O     R/s    W/s      0.3   0.3  292M 5.96M   537 root         0 S   1:53.61     0     0 /usr/bin/vmtoolsd
sda1           0      0      0.0   0.0     0     0   271 root       -20 S   0:00.00     0     0 bioset
sda2           0      0      0.0   0.1  191M 1.21M   545 root         0 S   0:00.00     0     0 /usr/sbin/gssproxy -D
sda3           0      0      0.0   0.0     0     0   227 root       -20 S   0:00.00     0     0 ata_sff
sr0            0      0      0.0   0.2  124M 4.41M  2356 nginx        0 S   0:00.30     0     0 nginx: worker process
sr1            0      0      0.0   0.1 87.5M 2.11M  1108 root         0 S   0:00.44     0     0 /usr/libexec/postfix/master -w
```

***

| 网络监控命令 |
| --- |

1）glances

```plain
[root@web02 ~]# glances
NETWORK     Rx/s   Tx/s   TASKS 100 (138 thr), 2 run, 98 slp, 0 oth sorted automatically by cpu_percent, flat view
eth0        168b    1Kb
lo            0b     0b
```

2）iftop

```plain
[root@web02 ~]# iftop
                                               12.5Kb                                          25.0Kb                                         37.5Kb                                          50.0Kb                                    62.5Kb
└──────────────────────────────────────────────┴───────────────────────────────────────────────┴──────────────────────────────────────────────┴───────────────────────────────────────────────┴───────────────────────────────────────────────
web02                                                                                                     => 10.0.0.1                                                                                                  1.31Kb  2.82Kb  2.82Kb
                                                                                                          <=                                                                                                            208b    347b    347b
web02                                                                                                     => gateway                                                                                                      0b    268b    268b
                                                                                                          <=                                                                                                              0b    268b    268b
                                                                                                          
                                                                                                          #按P键可以看到与什么服务在交互
#Mb 与 MB的区别
#百兆带宽：100Mb
#实际：100Mbps / 8 = 12MB
```

3）nethogs

该命令可以查看某个进程所使用的流量

```plain
[root@web02 ~]# nethogs
NetHogs version 0.8.5
    PID USER     PROGRAM                                                                                                                                                                                  DEV        SENT      RECEIVED
   2477 root     sshd: root@pts/1                                                                                                                                                                         eth0        0.131   0.064 KB/sec
      ? root     unknown TCP                                                                                                                                                                                          0.000   0.000 KB/sec
  TOTAL                                                                                                                                                                                                               0.131       0.064 KB/sec
```

4）ifconfig

```plain
[root@web02 ~]# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.8  netmask 255.255.255.0  broadcast 10.0.0.255
        inet6 fe80::20c:29ff:fea0:7ef0  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:a0:7e:f0  txqueuelen 1000  (Ethernet)
        RX packets 55217  bytes 64623101 (61.6 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 30950  bytes 4603140 (4.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 27  bytes 2072 (2.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 27  bytes 2072 (2.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

5）route

```plain
[root@web02 ~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.0.0.2        0.0.0.0         UG    100    0        0 eth0
10.0.0.0        0.0.0.0         255.255.255.0   U     100    0        0 eth0
```

***

| TCP11种状态监控命令 |
| --- |

1）netstat

```plain
[root@driver-zeng ~]# netstat -an
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:873             0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:52022           0.0.0.0:*               LISTEN
tcp        0      0 172.24.156.150:59936    100.100.30.25:80        ESTABLISHED
tcp        0      0 172.24.156.150:52022    139.226.172.217:54116   ESTABLISHED
tcp6       0      0 :::873                  :::*                    LISTEN
udp        0      0 172.17.0.1:123          0.0.0.0:*
udp        0      0 172.18.0.1:123          0.0.0.0:*
udp        0      0 172.24.156.150:123      0.0.0.0:*
udp        0      0 127.0.0.1:123           0.0.0.0:*
udp        0      0 0.0.0.0:123             0.0.0.0:*
udp6       0      0 :::123                  :::*
[root@driver-zeng ~]# netstat -an|awk '/^tcp/ {print $NF}'|sort|uniq -c
      4 ESTABLISHED
      6 LISTEN
[root@driver-zeng ~]# netstat -an|awk '/^tcp/ {++state[$NF]} END {for(key in state) print key," \t" ,state[key]}'
LISTEN       6
ESTABLISHED      4
```

2）ss

```plain
[root@driver-zeng ~]# ss -n|awk '{print $2}'|sort|uniq -c
     42 ESTAB
      1 State
```

***

| 生产场景需求 |
| --- |

如何每1分钟监控当前系统的内存使用状态，如果可用低于100MB则发送邮件。同时打印当前还剩余多少内存

1.如何获取内存的状态信息 free -m

2.如何获取内存的可用状态 free -m|awk '/<sup>Mem/{print</sup> $NF}'

3.如何进行数字的比对，高于100MB不处理，低于100MB，发送邮件。

4.如何每分钟执行。

```plain
[root@web02 ~]# vim free.sh
#!/bin/bash
while true;do
  free_av=$(free -m|awk '/^Mem/{print $NF}')
  Hostname=$(hostname)_$(hostname -I|awk '{print $2}')
  Date=$(date +%F)
  if [ $free_av -lt 100 ];then
    echo "$Date: ${Hostname},内存低于100MB，还有${free_av}MB内存可用"
  fi
      sleep 2
done
[root@web02 ~]# sh free.sh
2018-10-12: web02_,内存低于100MB，还有20MB内存可用
2018-10-12: web02_,内存低于100MB，还有6MB内存可用
2018-10-12: web02_,内存低于100MB，还有5MB内存可用
[root@web02 ~]# dd < /dev/zero > /dev/null bs=2000M
```

***

| 系统的oom |
| --- |

随着时间的推移，用户不断增多，服务消耗的内存越来越多，当系统内存不足的时候，可能会导致系统产生oom（out of memory）

1.当系统内存不足时就会大量使用swap（虚拟内存）

2.当系统大量使用swap的时候，系统会特别卡

注意：有时可能内存还有剩余300M或者500M，但是swap依然被使用

```plain
[root@web02 ~]# dd < /dev/zero > /dev/null bs=2000M
[root@web02 ~]# tail -f /var/log/messages
Out of memory: Kill process 29957 (dd) score 366 or sacrifice child
Killed process 29957 (dd) total-vm:2532680kB, anon-rss:1416508kB, filers:0kB
```

## 使用脚本监控nginx

前面的课程中，我们学习了使用脚本+定时任务的方法自动备份并将检查结果，发到指定邮箱,那么这里，我也可以使用脚本+定时任务的方法，进行监控，并使用邮件报警

```plain
#!/bin/bash
nginx_process=`ps -ef|grep -c [n]ginx`
if [ $nginx_process -lt 2 ];then
    echo "目前nginx进程数是：$nginx_process"|mail -s "完犊子nginx挂了" 133411023@qq.com
fi
```

***

### **low de yi pi**

***

## zabbix监控快速安装

***方法一：官方安装方式***

***

| 配置zabbix官方仓库 |
| --- |

```plain
RHEL 7:
# rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
RHEL 6:
# rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
RHEL 5:
# rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/5/x86_64/zabbix-release-3.4-1.noarch.rpm
```

***

| 安装zabbix-server |
| --- |

```plain
# yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent
```

***方法二：第三方源安装***

***

| 配置zabbix第三方仓库 |
| --- |

```plain
[root@web02 ~]# rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
获取https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
警告：/var/tmp/rpm-tmp.NlJfKB: 头V4 RSA/SHA512 Signature, 密钥 ID a14fe591: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:zabbix-release-3.4-2.el7     ################################# [100%]
```

***

| 安装zabbix-server |
| --- |

```plain
[root@web02 ~]# yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server
```

***配置zabbix-server***

***

| 初始化数据库 |
| --- |

```plain
#启动数据库
[root@web02 ~]# systemctl start mariadb
#连接数据库
[root@web02 ~]# mysql
#创建zabbix库
MariaDB [(none)]> create database zabbix character set utf8 collate utf8_bin;
#退出数据库
MariaDB [(none)]> exit
#进入SQL文件目录
[root@web02 ~]# cd /usr/share/doc/zabbix-server-mysql-3.4.15/
#导入SQL文件
[root@web02 zabbix-server-mysql-3.4.15]# zcat create.sql.gz |mysql zabbix
#检查导入结果
MariaDB [(none)]> show databases;
MariaDB [(none)]> use zabbix
MariaDB [zabbix]> show tables;
#创建用户
MariaDB [zabbix]> grant all on zabbix.* to zabbix@'localhost' identified by '123';
Query OK, 0 rows affected (0.01 sec)
```

***

| 编辑zabbix-server配置 |
| --- |

```plain
[root@web02 ~]# vim /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=123
```

***

| 启动zabbix-server并加入开机自启 |
| --- |

```plain
[root@web02 ~]# systemctl start zabbix-server
[root@web02 ~]# systemctl enable zabbix-server
[root@web02 ~]# netstat -lntup
tcp        0      0 0.0.0.0:10051           0.0.0.0:*               LISTEN      5129/zabbix_server
```

***

| 修改时区，启动httpd |
| --- |

```plain
[root@web02 ~]# vim /etc/httpd/conf.d/zabbix.conf
php_value date.timezone Asia/Shanghai
[root@web02 ~]# systemctl start httpd
[root@web02 ~]# systemctl enable httpd
```

打开浏览器访问：<http://10.0.0.8/zabbix>

<!-- OCR_START -->
- ①不安全|10.0.0.8/zabbix/setup.php
- 应用
- zabbix
- Welcome
- Checkofpre-requisites
- Configure DB connection
- Welcome to
- Zabbixserver details
- Pre-installation summary
- Zabbix 3.4
- Install
- Nextstep
- LicensedunderGPLV2
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- Installation
- ①不安全 | 10.0.0.8/zabbix/setup.php
- 应用
- zabbix-api
- ZABBIX
- Check of pre-requisites
- Current value
- Required
- Welcome
- PHP version
- 5.4.16
- 5.4.0
- OK
- PHP option *memory_limit"
- 128M
- Configure DB connection
- PHP option"post
- 16M
- Zabbixserverdetails
- Pre-installation summary
- PHP option“upload_max_filesize”
- 2M
- Install
- PHPoption"max_execution_time"
- 300
- PHP option*max input_time"
- PHP option"date.timezone"
- Asia/Shanghai
- PHP databases support
- MySQL
- PHP bcmath
- on
- PHP mbstring
- PHP option“mstring.func_overlo"
- off
- Back
- Next step
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来
- Installation
- 1Red Hat Ent
- A 不安全 | 10.0.0.8/zabbix/setup.php
- 应用 zabbix-api
- ZABBIX
- Configure DB connection
- Pleasecreatedatabasemanuallyandsettheonf
- Press“Next step" button when done.
- Welcome
- Check of pre-requisites
- Database type
- MySQL
- Database host
- localhost
- Zabbixserverdetails
- Pre-installtion summary
- Database port
- 0-use default port
- Install
- Database name
- User
- Password
- Back
- Nextstep
- Licensed under GPLv2
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- Installation
- A不安全|10.0.0.8/zabbix/setup.php
- I应用 zabbix-api
- ZABBIX
- Zabbixserverdetails
- Pleaseenterthehostnameorhost IadressandportumberoftheZabbixerveraswellasthe
- Welcome
- nameoftheinstallation(optional).
- Checkof pre-requisites
- Host
- localhost
- Configure DB connection
- Port
- 10051
- Name
- 曾老湿
- Pre-installation summary
- Install
- Back
- Nextstep
- Licensed under GPLv2
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z Installation
- ① 不安全| 10.0.0.8/zabbix/setup.php
- 应用 zabbix-api
- 翻译此页？
- 选项
- 翻译
- ZABBIX
- Pre-installation summary
- Pleasecheckconfigurationparar
- change configuration
- Welcome
- Database type
- MySQL
- Check of pre-requisites
- Configure DB conne
- Database server
- localhost
- Zabbix server details
- port
- default
- Install
- Database user
- Database password
- Zabbix server
- Zabbix serverport
- 10051
- Zabbixserver name
- 曾老湿
- BackNext step
- Licensedunder GPLv2
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来
- Installa
- 不安全|10.0.0.8/zabbix/setup.php
- l应用 zabbix-api
- ZABBIX
- Install
- Welcome
- Check of pre-requisites
- Configure DB connection
- Zabbix server details
- Pre-installation summary
- Congratulations! You have successfully installed Zabbix
- frontend.
- Finish
- edunderGPLv2
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 曾老湿：Zabbix
- A不安全| 10.0.0.8/zabbix/index.php
- 应用 zabbix-api
- 曾老湿
- ZABBIX
- Usemame
- Admin
- Password
- Remember me for 30 days
- Signin
- orsigninasguest
- Help·Support
- DriverZeng
<!-- OCR_END -->

￼

用户名：Admin

密码：zabbix

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来
- Z曾老湿：Dashboard
- 3 Installaion from sources Zzal
- 不安全 | 10.0.0.8/zabbix/zabbix.php?action=dashboard.view
- 应用 zabbix-api
- ZABBIX
- Monitoring  Inventory Reports  Configuration  Administration
- ZShare
- Dashboard  Problems
- OverviewWebLatest data Trigers Graphs ScreensMaps Disovery Services
- 曾老湿
- Dashboard
- Edit dashboard
- 目日
- Favourite screens
- Host status
- Favourite graphs
- Nographsadded
- No screens added
- Nomap
- Host group
- Without problems
- Withproblems
- No data found.
- Updated: 12:21:44
- Updated:12:21:43
- Time
- Recovery time
- Status
- Info
- Host
- Problem·Severity
- Duration
- Ack
- Actions
- System status
- Disaster
- High
- Average
- Warming
- Information
- Not classified
- Status of Zabbix
- Parameter
- Value
- Details
- Web monitoring
- Yes
- localhost:10051
- Discovery status
- 0/1/75
- Discoveryrule
- Numberof hosts(enabled/disabled/templates)
- 76
- Ok
- Failed
- Unknown
- Up
- Down
- Numberof items(enabled/disabled/not supported)
- 68
- 0/68/0
- Numberoftriggers(enabled/disabled [problem/k])
- 46
- 0 / 46 [0 / 0]
- Number of users (online)
- 2
- 1
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 曾老湿：User profile
- →C  ① 不安全 | 10.0.0.8/zabbix/profile.php
- I应用 zabbix-api
- ZABBIX
- Monitoring Inventory  Reports Configuration
- Administration
- ZShare
- 曾老湿
- User profile: Zabbix Administrator
- User Media Messaging
- Password
- Change password
- Language
- Chinese(zh_CN)
- ThemeSystem default
- Auto-login
- Auto-logout15m
- Refresh30s
- Rows per page
- 50
- URL (after login)
- Update
- DriverZeng
- Zabbix3.4.15.2001-2018,ZabbixSIA
<!-- OCR_END -->

￼

修改语言为中文

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- Z曾老湿：仪表板
- 不安全|10.0.0.8/zabbix/zabbix.php
- 应用    zabbix-api
- ZABBIX
- 监测中  资产记录报表 配置管理
- QZShare
- 仪表板 问题概览 Wweb监测 最新数据触发器图形 聚合图形 拓扑图 自动发现服务
- 曾老湿
- Dashboard
- 编辑仪表盘目
- 添加仪表盘/Dashboard
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 未添加数据图.
- 未添加聚合图形.
- 未添加拓扑图.
- 主机群组
- 正常设备
- 异常设备
- 合计
- 未发现数据
- 已更新：12:22:40
- 问题
- 时间
- 恢复时间
- 状态
- 信息
- 主机
- 问题·严重性
- 持续时间
- 确认
- 动作
- 已更新：12:23:41
- 系统状态
- 灾难
- 严重
- 一般严重
- 警告
- 未分类
- Zabbix状态
- 0ofO问题显示
- 已更新：12:23:40
- 参数
- 细节
- Zabbix服务器端运行中
- localhost:10051
- Web监测
- 自动发现状态
- 主机数量（已启用/已禁用/模板）
- 76
- 0/1/75
- 正常
- 已失败
- 未知的
- 自动发现规则
- 监控项数量（已启用/已禁用/不支持）
- 68
- 0/68/0
- 触发器数量（已启用/已禁用[问题/正常]）
- 46
- 0/ 46[0 /0]
- 用户数(线上）
- 2
- 1
<!-- OCR_END -->

￼

## zabbix使用-快速监控一台主机

***

| 在需要被监控的主机上安装zabbix客户端 |
| --- |

```plain
[root@web01 ~]# rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.15-1.el7.x86_64.rpm
获取https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.15-1.el7.x86_64.rpm
警告：/var/tmp/rpm-tmp.7ESzKH: 头V4 RSA/SHA512 Signature, 密钥 ID a14fe591: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:zabbix-agent-3.4.15-1.el7    ################################# [100%]
```

***

| 配置客户端并启动 |
| --- |

```plain
#修改配置文件
[root@web01 ~]# vim /etc/zabbix/zabbix_agentd.conf
Server=127.0.0.1,10.0.0.8
ServerActive=127.0.0.1,10.0.0.8
#启动客户端
[root@web01 ~]# systemctl start zabbix-agent
#添加开机自启
[root@web01 ~]# systemctl enable zabbix-agent
Created symlink from /etc/systemd/system/multi-user.target.wants/zabbix-agent.service to /usr/lib/systemd/system/zabbix-agent.service.
#检查10050端口
[root@web01 ~]# netstat -lntup
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:10050           0.0.0.0:*               LISTEN      9204/zabbix_agentd
```

***

| 在web页面添加监控 |
| --- |

```plain
#添加监控之前我们必须保证10050端口可以通信
[root@web02 ~]# telnet 10.0.0.7 10050
Trying 10.0.0.7...
Connected to 10.0.0.7.
Escape character is '^]'
```

<!-- OCR_START -->
- 曾老湿：配置主机
- ①不安全| 10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- αZShare？
- 主机群组
- 模板
- 主机
- 维护动作关联项事件
- 自动发现服务
- 曾老湿
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 状态
- 可用性
- agent加密
- 信息
- Zabbixserver
- 应用集11
- 监控项68
- 触发器46
- 图形11
- 自动发现2
- 127.0.0.1: 10050
- bixAgent)
- 停用的
- ZBXSNMPJMXIPMI
- 显示已自动发现的1中的1
- 0选择
- 导出
- 批量更新
- 删除
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置主机
- A不安全|10.0.0.8/zabbix/hosts.php?groupid=0&forn
- m=创建主机
- 8
- 应用 zabbix-api
- 主机群组模板
- 主机维护
- 动作关联项事件
- 自动发现
- 服务
- 主机
- 主机模板
- IPMI宏主机资产记录
- 加密
- 主机名称
- web01
- 可见的名称
- 群组
- 在..群组之中
- 其它群组
- Templates
- Templates/Databases
- Templates/Modules
- evices
- Templates/Virtualization
- Zabbix servers
- Virtualmachines
- 新的群组
- web_group
- agent代理程序的接口
- DNS名称
- 连接到
- 默认
- 10.0.0.7
- IP地址
- DNS
- 移除
- 添加
- SNMP接口
- JMX接口
- IPMI接口
- 描述
- 由agent代理程序监测(无agent代理程序)
- 已启用
- 曾老湿
- 取消
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置主机
- A 不安全| 10.0.0.8/zabbix/hosts.php?groupid=0&form=创建主机
- 应用 zabbx-api
- ZABBIX
- 监测中
- 资产记录
- 报表
- 配置
- 管理
- ZShare
- 主机群组模板 主机 维护 动作 关联项事件
- 自动发现服务
- 曾老湿
- 主机
- 模板
- IPMI
- 宏主机资产记录
- 加密
- 链接的模板
- 名称
- 链接指示器
- Template OS Linux
- 在此输入搜索
- ③
- 添加
- 4）
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置主机
- 不安全| 10.0.0.8/zabbix/hos
- ts.php?dd
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表 配置 管理
- Share
- 主机群组
- 模板
- 主机
- 维护
- 动作关联项事件
- 自动发现
- 服务
- 曾老湿
- 群组所有
- 创建主机导入
- 过滤器
- DNS
- IP地址
- 端口
- 应用重设
- 名称
- 应用集
- 监控项
- 触发器
- 图形
- Web监测
- 接口
- 状态
- 可用性
- agent 加密
- 信息
- web01
- 应用集10
- 监控项32
- 触发器15
- 图形5
- 自动发现2
- 10.0.0.7:10050
- Template OS Linux(Template AppZabbix Agent)
- 已启用
- ZBXSNMP|JMX|IPMI
- Zabbixserver
- 应用集11
- 监控项68
- 触发器46
- 图形11
- 127.0.0.1: 10050
- 停用的
- 显示已自动发现的2中的2
- 导出
- 批量更新
- 删除
- DriverZeng
<!-- OCR_END -->

￼

**绿了，就证明成功了**

<!-- OCR_START -->
- 自定义图表[每
- ①不安全|10.0.0.8/zabbix/charts.php?fullscreen=0&groupid=15&hostid=10254&graphid=793
- I 应用 zabbix-api
- ZABBIX
- 监测中 资产记录 报表配置 管理
- αShare？
- 仪表板问题概览
- Web监测 最新数据 触发器 图形聚合图形 拓扑图 自动发现服务
- 曾老湿
- 图形
- 群组web_group
- 主机webo1图形CPUload
- 过滤器
- 缩放：5m15m30m1h所有
- 2019-10-2309:34:14-2019-10-2310:34:14(现在）
- 《《1h5m15m1h》>
- 1h固定的
- web01: CPU load (1h)
- 0.06
- 0.05
- 0.04
- 0.03
- 0.02
- 0.01
- 0.0027
- .3
- Processorload(5minaveragepercore)
- 8.83
- 0.0110
- [0]
- Om:Processor load is too high onwebo1
- [>5]
<!-- OCR_END -->

￼

在上图中，会发现有图了，但是下面的字体是`口口`，这是因为中文字体没有显示出来，我们需要自己更换字体。

首先在windows系统中，找到字体存放目录`C:\Windows\Fonts`，找一个自己喜欢的字体，我选择的是楷体（simkai.ttf）。



<!-- OCR_START -->
> simkai.ttf
<!-- OCR_END -->

￼

将该字体上传至zabbix的字体目录下。

```plain
#进入zabbix字体目录
[root@web02 fonts]# cd /usr/share/zabbix/fonts
#查看目录内容
[root@web02 fonts]# ll
总用量 0
lrwxrwxrwx 1 root root 33 10月 12 15:00 graphfont.ttf -> /etc/alternatives/zabbix-web-font
#上传字体
[root@web02 fonts]# rz simkai.ttf
#删除原来的字体，或者mv备份
[root@web02 fonts]# rm -f graphfont.ttf
#将上传的字体改名
[root@web02 fonts]# mv simkai.ttf graphfont.ttf
#刷新web页面查看
```

<!-- OCR_START -->
- Z曾老湿：自定义图表[每30秒刷新
- ①不安全|10.0.0.8/zabbix/charts.php?fullscreen=0&groupid=15&hostid=10254&graphid=793
- zabbix-api
- 应用
- ZABBIX
- 监测中资产记录报表配置管理
- αShare？
- 仪表板
- 问题
- 概览
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 图形
- 群组web_group主机web01图形CPU load
- 过滤器
- 缩放：5m15m30m1h所有
- 2019-10-2309:59:01-2019-10-2310:59:01(现在I)
- 《《1h5m1 5m1h》》
- 1h 固定的
- web01: CPU 1oad (1h)
- 0.06
- 0.0
- 0.04
- 0. 03
- 最新最小
- 平均
- 最大
- .03
- 0. 0123
- 0.05
- 触发器：Processor load is too high on web01[> 5]
- DriverZeng
<!-- OCR_END -->

￼

## zabbix监控基础架构

zabbix-agent(数据采集) --> zabbix-server(数据分析\报警) --> 数据库(数据存储) --> zabbix-web(数据展示)

<!-- OCR_START -->
- 数据采集
- zabbix-agent
- 当在web上修改配置，其实是在
- 数据库中修改，然后定期的往
- 里面读配置，如果读到配置，
- 再根据配置来管理agent的值
- 分析，报警
- 数据展示给用户
- zabbix-server
- zabbix-web
- 数据存储
- 从数据库中读
- 取数据，过程
- 是互动的
- 将数据从server
- 写入到数据库
- MySQL
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| zabbix数据库拆分 |
| --- |

目前我们zabbix的架构，单台zabbix服务：LAMP+zabbix

我们需要实现zabbix架构，将数据库拆分成单独的一台，LAP+zabbix+MySQL

***1.环境准备***

| 主机名 | wanIP | lanIP | 角色 |
| --- | --- | --- | --- |
| zabbix | 10.0.0.71 | 172.16.1.71 | zabbix-server |
| db01 | 10.0.0.51 | 172.16.1.51 | MySQL |

***2.导出原MySQL中的zabbix数据***

```plain
#导出zabbix数据
[root@zabbix ~]# mysqldump -uroot -p -B zabbix > /tmp/zabbix.sql
#拷贝数据到db01
[root@zabbix ~]# scp /tmp/zabbix.sql 10.0.0.51:/tmp
```

***3.准备新的数据库环境***

```plain
#安装数据库
[root@db01 ~]# yum install -y mariadb-server
#启动数据库
[root@web01 ~]# systemctl start mariadb
#导入数据
[root@web01 ~]# mysql -uroot -p < /tmp/zabbix.sql
```

***4.关闭原来的数据库并测试***

```plain
#关闭数据库
[root@web02 ~]# systemctl stop mariadb
#打开浏览器查看
```

<!-- OCR_START -->
- 应用
- zabbix-ap
- Database error
- /var/lib/mysql/mysql.sock(2)
- Retry
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

凉凉，为啥呢？应为我们需要修改php代码连接数据库，就和之前我们修改wordpres连库代码一样

***5.修改连接数据库代码***

```plain
#修改代码
[root@web02 ~]# vim /etc/zabbix/web/zabbix.conf.php
<?php
// Zabbix GUI configuration file.
global $DB;
$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '10.0.0.51';
$DB['PORT']     = '0';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = '123';
// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';
$ZBX_SERVER      = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = '曾老湿';
$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
#修改配置文件
[root@web02 ~]# vim /etc/zabbix/zabbix_server.conf
DBHost=10.0.0.51
#重启zabbix-server
[root@web02 ~]# systemctl restart zabbix-server
#打开浏览器测试
```

<!-- OCR_START -->
- ZWarning[refreshed every30sx
- 不安全| 10.0.0.8/zabbix/
- l应用zabbix-api
- Database error
- Error connecting to database: Host 10.0.0.8'isnot allowed to connect t this MariaD
- server
- Retry
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

新一轮的报错又出现了，刚才是连接不上`localhost`的，现在连接不上`10.0.0.8` 证明什么，证明我们新装的数据库不允许远程连接，我们可以使用命令行测试一下。

```plain
#是拒绝的，所以我们创建个用户即可
[root@web02 ~]# mysql -uzabbix -p123 -h 10.0.0.7
ERROR 1130 (HY000): Host '10.0.0.8' is not allowed to connect to this MariaDB server
#创建用户
MariaDB [(none)]> grant all on zabbix.* to zabbix@'10.0.0.%' identified by '123';
Query OK, 0 rows affected (0.00 sec)
```

<!-- OCR_START -->
- 曾老湿：Zabbix
- 不安全
- |10.0.0.8/zab
- 应用
- 曾老湿
- ZABBIX
- Remember me for 30 days
- Sign in
- or sign in as guest
- Help·Support
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：自定义图表[每30秒刷新×
- 应用
- zabbix-api
- ZABBIX
- 监测中 资产记录报表  配置管理
- αShare？
- 仪表板
- 问题
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 概览
- 曾老湿
- 图形
- 群组web
- 主机web01图形CPUload
- 过滤器
- 缩放：5m15m30m1h2h 3h所有
- 2019-10-2311:3:41-2019-10-2312:33:41(现在）)
- 《《1h5m15m1h》》
- 1h固定的
- web01: CPU 1oad (1h)
- 0.25
- 0. 20
- 0. 15
- 0. 10
- 0.0
- 最新
- 最小
- 26
- [平均]
- [评码]
- rocessorload
- 0.0326
- 0.06
- load is too high on web01
- [>5]
- DriverZeng
<!-- OCR_END -->

￼

## 添加自定义监控项入门

**需求：监控登录服务器的用户会话数量**

***

| 自定义监控格式 |
| --- |

```plain
### Option: UserParameter
#       User-defined parameter to monitor. There can be several user-defined parameters.
#       Format: UserParameter=<key>,<shell command>
#       See 'zabbix_agentd' directory for examples.
#官方示例
UserParameter=mysql.ping,HOME=/var/lib/zabbix mysqladmin ping | grep -c alive
UserParameter=mysql.version,mysql -V
```

***

| 自定义监第一步 |
| --- |

使用命令查看服务器当前登录用户会话数量

```plain
[root@web01 zabbix]# uptime |awk '{print $6}'
```

***

| 自定义监第二步 |
| --- |

把命令加入配置文件并起名

```plain
UserParameter=user.count,uptime |awk '{print $6}'
```

***

| 自定义监第三步 |
| --- |

客户端，查看监控项

```plain
[root@web01 zabbix]# zabbix_agentd -p
user.count                                    [t|1]
```

***

| 自定义监第四步 |
| --- |

在zabbix-server端获取agent端数据，使用zabbix_get命令

```plain
#安装zabbix_get命令
[root@web02 ~]# rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-get-3.4.15-1.el7.x86_64.rpm
获取https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-get-3.4.15-1.el7.x86_64.rpm
准备中...                          ################################# [100%]
正在升级/安装...
   1:zabbix-get-3.4.15-1.el7      ################################# [100%]
#语法
[root@web02 ~]# zabbix_get
usage:
  zabbix_get -s host-name-or-IP [-p port-number] [-I IP-address] -k item-key
  zabbix_get -s host-name-or-IP [-p port-number] [-I IP-address]
                --tls-connect cert --tls-ca-file CA-file
                [--tls-crl-file CRL-file] [--tls-agent-cert-issuer cert-issuer]
                [--tls-agent-cert-subject cert-subject]
                --tls-cert-file cert-file --tls-key-file key-file -k item-key
  zabbix_get -s host-name-or-IP [-p port-number] [-I IP-address]
                --tls-connect psk --tls-psk-identity PSK-identity
                --tls-psk-file PSK-file -k item-key
  zabbix_get -h
  zabbix_get -V
#获取数据
[root@web02 ~]# zabbix_get -s 10.0.0.7 -k user.count
1
```

***

| 自定义监第五步 |
| --- |

在web页面添加监控项

<!-- OCR_START -->
- Z曾老湿：配置主机
- 不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录
- 报表
- 配置
- 管理
- ZShare
- 主机群组模板主机
- 维护动作关联项事件
- 自动发现
- 服务
- 曾老湿
- 主机
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 应用
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent加密
- 信息
- web01
- 应用集10
- 监控项44
- 触发器19
- 图形8
- 自动发现2
- 10.0.0.7:10050
- 已启用
- ZBXSNMPJMXIPMI
- Zabbix server
- 应用集11
- 监控项68
- 触发器46
- 图形11
- 127.0.0.1:10050
- 停用的
- 显示已自动发现的2中的2
- 0选择
- 启用
- 禁用
- 导出
- 批量更新
- 删除
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置监控项
- →C不安全|10.0.0.8/zabbix/items.php?filter_set=1&hostid=10254
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 主机群组模板主机维护动作关联项事件自动发现服务
- 曾老湿
- 监控项
- 创建监控项
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集10监控项44触发器19图形8自动发现规则2Web场景
- 过滤器
- 主机群组
- 在此输入搜索
- 选择
- 类型所有
- 信息类型所有
- 状态所有
- 主机
- web01x
- 更新间隔
- 历史记录
- 应用集
- 趋势
- 触发器所有
- 名称
- 模板所有
- 键值
- 应用
- 重设
- 过滤器只影响过滤后的数据
- CPU13Filesystems10General5Memory5NetworkitrfacesOs8Perfomance13Processes2Security2Zzabbxagent3
- 信息类型
- 字符4数字（无正负）24浮点数16
- 模板
- 模板的监控项32非模板监控项12
- 有触发器
- 无触发器25有触发器19
- 间隔
- 1m3110m21h11
- Wizard
- 触发器
- 类型
- 状态
- 信息
- *00
- Template AppZabbixAgent:Agent ping
- 触发器1
- agent.ping
- 1m
- 1w
- 365d
- Zabbix客户端
- Zabbixagent
- 已启用
- ...
- TemplateOsLinux:Availablememory
- vm.memory.size[available]
- Memory
- TemplateOSLinux:Checksumof /etc/passwd
- vfs.fle.cksum[/etc/passwd]
- Securty
- 曾老湿ng
- system.cpu.switches
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 监控项
- 所有主机/web01
- 已启用ZBX
- SNMP JMXIPMI
- 应用集10监控项44触发器19图形8自动发现规则2Web场景
- 进程
- Monitor Login UserCount
- 类型
- Zabbix客户端
- 建1
- user.count
- 选择
- 主机接口10.0.0.7：10050
- 信息类型数字（无正负）
- 单位
- 更新间隔
- 3s
- 自定义时间间隔
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长
- 90d
- 趋势存储时间
- 365d
- 查看值
- 不变
- 展示值映射
- 新的应用
- SystemDIY
- 应用集
- -无
- Filesystems
- CPU
- General
- Memory
- Networkinterfaces
- OS
- Performance
- Processes
- Security
- 填入主机资产纪录栏位-无
- Dri增e老湿ng
- 描述监控主机的登录用户会话数量
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置主机
- →C
- 不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中
- 资产记录报表
- 配置
- 管理
- Share
- 主机群组模板主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 主机
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 应用
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent 加密
- 信息
- web01
- 应用集11
- 监控项45
- 触发器19
- 图形8
- 自动发现2
- 10.0.0.7:10050
- TemplateOSLinux（TemplateAppZabbixAgent)
- 已启用
- ZBXSNMPJMXIPMI
- Zabbixserver
- 监控项68
- 触发器46
- 图形11
- 127.0.0.1:10050
- TemplateAppZabbixServerTemplateOSLinuxTemp
- 停用的
- 显示已自动发现的2中的2
- 选择
- 启用
- 禁用
- 导出
- 批量更新
- 删除
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：应用集的配置
- →C不安全|10.0.0.8/zabbix/applications.php?groupid=0&hostid=10254
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- ？_心
- 主机群组模板
- 主机维护动作关联项事件自动发现服务
- 曾老湿
- 应用集
- 群组所有
- 主机web01
- 创建应用集
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集11监控项45触发器19图形8自动发现规则2Web场景
- 监控项
- 信息
- Template OS Linux:CPU
- 监控项13
- TemplateOSLinux:Filesystems
- 监控项10
- TemplateOSLinux:General
- 监控项5
- TemplateOSLinux:Memory
- TemplateOSLinux:Network interfaces
- 监控项2
- TemplateOS Linux:OS
- 监控项8
- Template OS Linux:Processes
- Template OS Linux:Security
- SystemDIY
- 监控项1
- Template AppZ
- 监控项3
- 显示已自动发现的11中的11
- 0选择
- 启用
- 禁用
- Dri曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置监控项
- 不安全10.0.0.8/zabbix/items.php?hostid=10254&filter_set=1&filter_application=System+DIY
- 9
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 主机群组
- 模板
- 主机维护动作关联项事件
- 自动发现
- 服务
- 曾老湿
- 监控项
- 创建监控项
- 所有主机/web01已启用ZBX SNMP JMXIPMI应用集11监控项45触发器19图形8自动发现规则2Web场景
- 过滤器
- 在此输入搜索
- 选择
- 类型
- 所有
- 信息类型
- 状态所有
- 主机
- web01x
- 更新间隔
- 历史记录
- 应用集
- SystemDIY
- 趋势
- 触发器所有
- 名称
- 模板所有
- 键值
- 重设
- 过滤器只影响过滤后的数据
- Wizard
- 触发器
- 间隔
- 状态
- 信息
- MonitorLoginUserCount
- user.count
- 3s
- 90d
- 365d
- Zabbix客户端
- 已启用
- 显示已自动发现的1中的1
- 清除历史
- 复制
- 批量更新
- 删除
<!-- OCR_END -->

￼

***

| 自定义监第六步 |
| --- |

添加触发器：当用户登录超过2人的时候，就要报警。

<!-- OCR_START -->
- 曾老湿：配置主机
- 不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中
- 资产记录
- 报表
- 配置
- 管理
- ZShare
- 7
- 主机群组模板主机
- 维护动作关联项事件
- 自动发现服务
- 曾老湿
- 主机
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 应用
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent 加密
- 信息
- web01
- 应用集11
- 监控项45
- 触发器19
- 图形8
- 自动发现2
- 10.0.0.7:10050
- Template OS Linux(Template App Zabbix Agent)
- 已启用
- ZBXSNMPJMXIPMI
- Zabbixserver
- 监控项68
- 触发器46
- 图形11
- 127.0.0.1:10050
- 停用的
- 显示已自动发现的2中的2
- 0选择
- 启用
- 禁用
- 导出
- 批量更新
- 刷除
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
Z曾老湿：配置触发器
C不安全|10.0.0.8/zabbix/triggers.php?groupid=0&hostid=10254
应用
zabbix-api
ZABBIX
监测中资产记录
报表配置管理
ZShare
主机群组模板
主机维护动作关联项事件
自动发现服务
曾老湿
触发器
群组所有
主机web01
创建触发器
所有主机/web01
已启用ZBXSNMPJMXIPMI应用集11监控项45触发器19图形8自动发现规则2Web场景
过滤器
严重性
所有
未分类信息警告
一般严重严重灾难
状态
正常未知的
已启用停用的
重设
名称
表达式
信息
警告
TemplateOSLinux:/etc/passwdhasbeen changedon{HOST.NAME}
{web01:vfs.file.cksum[/etc/passwd]).diff(o)>0
已启用
TemplateOS Linux:Configuredmaxnumberof openedfles is too low onHOST.NAME}
{web01:kernel.maxiles.last(0)<1024
TemplateOSLinux:Configuredmaxnumberof processesistoolowonHOST.NAME)
{web01:kernel.maxproc.last（0)<256
Template OS Linux:Disk I/O is overloaded on{HOST.NAME)
{web01:system.cpu.util.iwaitl.avg(5m）)>20
Mountedfilesystemdiscovery:Freediskspaceislessthan20%onvolume/
{web01:vfs.fs.size[/.pfree].last(0)<20
Mountedflesystemdisovery:Freediskspaceislessthan0%nvolumebot
{web01:vfs.fs.size[/boot,pfre].last(0)}<20
Mountedfilesystemdiscovery:Freeinodesislessthan20%onvolume/
{web01:vfs.fs.inode[/.,pfree].last(0)><20
Mountedflesystemdiscovery:Free inodesislessthan20%onvolume/boot
{web01:vfs.fs.inode[/boot,pfree].last（0）)><20
TemplateOS Linux:Host informationwaschanged on{HOST.NAME}
{web01:system.uname.diff(0)>0
TemplateAppZabbixAgent:Hostname of zabbix_agentd was changedon{HOST.NAME)
{web01:agent.hostname.diff(o)>0
TemplateOS Linux:Hostname was changed on(HOST.NAME)
{web01:system.hostname.dif(o)>0
一般严重
TemplateOSLinux:Lackofavailablememory onserverHOST.NAME)
{web01:vm.memory.size[available].last(0))<20M
Template OS Linux:Lack of free swap space on(HOST.NAME)
{web01:system.swap.size[pfree].last(0)><50
TemplateOS Linux:Processor load istoo highon(HOST.NAME)
{web01:system.cpu.load[percpu,avg1].avg(5m)}>5
Dr增e老湿n
obix
DESC
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置触发器
- A不安全|10.0.0.8/zabbix/triggers.php?groupid=0&hostid=10254&form=创建触发器
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Zsh
- 主机群组模板
- 主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 触发器
- 所有主机/web01
- 已启用
- ZBX
- SNMPJMXIPMI应用集11监控项45触发器19图形8自动发现规则2
- Web场景
- 触发器依赖关系
- 名称
- Monitor LoginUser Count
- 严重性未分类信息警告
- 一般严重
- 表达式
- 泰加
- 表达式构造器
- 事件成功选代
- 表达式恢复表达式无
- 问题事件生成模式
- 单个多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 添加
- 允许手动关闭
- URL
- 描述
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置触发器
- →CA不安全|10.0.0.8/zabbix/triggers.php?groupid=0&hostid=10254&form=创建触发器
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ee
- 曾老湿：条件
- QShare
- A不安全|10.0.0.8/zabbix/popup_.trexpr.php
- 主机群组模板
- 主机维护动作关联项事件自动发现
- 曾老湿
- 触发器
- 监控项
- webo1:Monitor Login UserCount
- 选择
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI
- 应用集11
- 功能
- last()-Last(mostrecent)Tvalue
- 触发器依赖关系
- 最后一个（T）
- 计数
- 间隔(秒)
- 时间
- 名称Monitor Login UserCou
- 结果2
- 严重性未分类信息
- 插入
- 取消
- 表达式
- 表达式构造器
- 事件成功选代
- 恢复表达式
- 问题事件生成模式
- 单个
- 多重
- 事件成功关闭
- 所有问题
- 标记
- 添加
- 允许手动关闭
- URL
- 描述
- Dri增e老ng
- 已启用
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置触发器
- A不安全|10.0.0.8/zabbix/triggers.php?groupid=0&hostid=10254&form=创建触发器
- 应用zabbix-api
- 主机群组模板
- 主机维护动作
- 关联项事件
- 自动发现
- 服务
- 曾老湿
- 触发器
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI
- 应用集11监控项45触发器19图形8自动发现规则2Web场景
- 触发器依赖关系
- 名称Monitor LoginUserCount
- 严重性未分类信息警告
- 一般严重
- 表达式{web01:user.count.last()}>2
- 添加
- 表达式构造器
- 事件成功迭代
- 表达式恢复表达式无
- 问题事件生成模式
- 单个多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 移除
- 允许手动关闭
- URL
- 描述
- 系统用户超过2个则告警
- 已启用
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：仪表板
- ①不安全|10.0.0.8/zabbix/zabbix.php?action=dashboard.view&ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 仪表板
- 问题
- 概览
- Web监测
- 最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- Dashboard
- 编辑仪表盘
- 目区
- 添加仪表盘/Dashboard
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 未添加数据图
- 未添加聚合图形
- 未添加拓扑图
- 主机群组
- 正常设备
- 异常设备
- 合计
- web_group
- 已更新：16:32:00
- 时间
- 恢复时间
- 状态
- 信息
- 主机
- 问题·严重性
- 持续时间
- 确认
- 动作
- 16:31:10
- web01
- Monitor Login User Count
- 50s
- 系统状态
- 灾难
- 严重
- 一般严重
- 警告
- 未分类
- 1
- Zabbix状态
- 1of1问题显示已更新：16:32:00
- 参数
- 细节
- Zabbix服务器端运行中
- 自动发现状态
- localhost:10051
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置触发器
- A不安全|10.0.0.8/zabbix/triggers.php?form=update&hostid=10254&triggerid=15661
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 主机群组模板
- 主机维护动作关联项事件自动发现服务
- 曾老海
- 触发器
- 所有主机/web01
- 已启用
- ZBX
- SNMPJMXIPMI
- 应用集11监控项45触发器20图形8自动发现规则2Web场景
- 触发器依赖关系
- 名称Monitor Login User Cou
- urt(HOST.NAME)
- 严重性
- 未分类信息警告
- 一般严重
- 严重灾难
- 表达式
- {web01:user.count.last()>2
- 添加
- 表达式构造器
- 事件成功选代
- 恢复表达式无
- 问题事件生成模式
- 单个多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 移除
- 允许手动关闭
- URL
- 描述
- 系统用户超过2个则告警
- Dri增老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置触发器
- →C不安全|10.0.0.8/zabbix/triggers.php?form=update&hostid=10254&triggerid=15661
- 应用zabbix-api
- 所有主机/web01
- 已启用ZBX SNMP|JMXIPMI应用集11监控项45触发器20图形8自动发现规则2Web场景
- 触发器依赖关系
- 名称
- Monitor LoginUserCount(HOST.NAME)(HOST.IP)
- 严重性未分类信息警告一般严重严重灾难
- 表达式{web01:user.count.last()}>2
- 添加
- 表达式构造器
- 事件成功迭代
- 表达式恢复表达式无
- 问题事件生成模式
- 单个多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 移除
- 允许手动关闭
- URL
- 描述
- 系统用户超过2个则告警
- 已启用
- 更新
- 克隆
- 删除
- 取消
- Dri曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：仪表板
- 不安全|10.0.0.8/zabbix/zabbix.php?action=dashboard.view
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 仪表板问题概览
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- Dashboard
- 编辑仪表盘
- 目图
- 添加仪表盘/Dashboard
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 未添加数据图
- 未添加聚合图形
- 未添加拓扑图
- 主机群组
- 正常设备
- 异常设备
- 合计
- web_group
- 1
- 已更新：16:36:18
- 问题
- 时间
- 恢复时间
- 状态
- 信息
- 主机
- 问题·严重性
- 持续时间
- 确认
- 动作
- 已更新：16:36:19
- 16:31:10
- Monitor Login User Count web0110.0.0.7
- 5m8s
- 系统状态
- 灾难
- 严重
- 一般严重
- 警告
- 未分类
- Zabbix状态
- 1of1问题显示已更新：16:36:18
- 参数
- 细节
- 增老湿ng则
- 自动发现状态
- Zabbix服务器端运行中
- localhost:10051
<!-- OCR_END -->

￼

***

| 优化触发器名称 |
| --- |

使用zabbix内置变量，来优化触发器的名称，此处使用的是

主机名变量：{HOST.NAME}

IP地址变量：{HOST.IP}

```plain
Monitor Login User Count Problem 主机名:{HOST.NAME} IP地址:{HOST.IP}
```

<!-- OCR_START -->
- 曾老湿：配置触发器
- CA不安全|10.0.0.8/zabbix/triggers.php?form=update&hostid=10254&triggerid=15661
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QShare
- 主机群组模板主机维护动作关联项事件自动发现服务
- 曾老湿
- 触发器
- 所有主机/web01
- 已启用
- ZBXSNMPJMXIPMI
- 应用集11监控项45触发器20图形8自动发现规则2Web场景
- 触发器依赖关系
- 名称Monitor LoginUserCountProblem主机名：(HOST.NAME）IP地址：(HOST.IP)
- 严重性未分类信息警告
- 一般严重
- 严重灾难
- 表达式(web01:user.count.last()}>2
- 添加
- 表达式构造器
- 事件成功迭代
- 表达式
- 恢复表达式无
- 问题事件生成模式
- 单个
- 多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 移除
- 允许手动关闭
- URL
- 描述
- 系统用户超过2个则告警
- 曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：仪表板
- →C
- 不安全|10.0.0.8/zabbix/zabbix.php?action=dashboard.view&ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 7
- 仪表板问题概览Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- Dashboard
- 编辑仪表盘
- 添加仪表盘/Dashboard
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 未添加数据图
- 未添加聚合图形
- 未添加拓扑图
- 主机群组
- 正常设备
- 异常设备
- 合计
- web_group
- 1
- 已更新：16：39:09
- 问题
- 时间
- 恢复时间状态
- 信息
- 主机
- 问题·严重性
- 持续时间确认动作
- 16:31:10
- webo
- Monitor Login Use
- 59s
- 系统状态
- ±0
- 灾难
- 严重
- 一般严重
- 警告
- 未分类
- Zabbix状态
- 1of1问题显示已更新：16:39:09
- 参数
- 细节
- Zabbix服务器端运行中
- Dr增e老湿ng
- 自动发现状态
- localhost:10051
<!-- OCR_END -->

￼

***

| 前端web页面告警 |
| --- |

<!-- OCR_START -->
- Z曾老湿：用户基本资料
- →C不安全|10.0.0.8/zabbix/profile.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- ？_心
- 曾老湿
- 用户基本资料：ZabbixAdministrator
- 用户报警媒介正在发送消息
- 前端信息中
- 消息超时60
- 播放声音一次
- 触发器示警度恢复
- alarm_ok
- 播放停止
- 未分类
- no_sound
- 信息
- alarm_information
- 警告
- alarm_warning
- 一般严重alarm_average
- 播放
- 停止
- 严重
- alarm_high
- 灾难
- alarm_disaster
- 更新
- 取消
- Dri增e老湿ng
<!-- OCR_END -->

￼

***

| 自定义监第七步 |
| --- |

添加图形化界面。

<!-- OCR_START -->
- Z曾老湿：配置主机
- 不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录
- 报表配置
- 管理
- Share
- 主机群组
- 模板
- 主机维护动作
- 关联项事件
- 自动发现
- 服务
- 曾老湿
- 主机
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- Web监测
- 接口
- 状态
- 可用性
- agent加密
- 信息
- webo1
- 应用集11
- 监控项45
- 触发器20
- 图形8
- 自动发现2
- 10.0.0.7:10050
- 已启用
- ZBX
- SNMPJMXIPMI
- Zabbix server
- 监控项68
- 触发器46
- 图形11
- 127.0.0.1:10050
- teAppZabbixAgent)
- 停用的
- ZBXSNMPJMXIPMI
- 显示已自动发现的2中的2
- 0选择
- 启用
- 禁用
- 导出
- 批量更新
- 删除
- Drie老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置图标
- →C不安全|10.0.0.8/zabbix/graphs.php?groupid=0&hostid=10254
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 主机群组模板
- 主机维护动作关联项事件自动发现服务
- 曾老湿
- 图形
- 群组所有
- 主机web01
- 创建图形
- 所有主机/web01
- 已启用
- ZBXSNMPJMXIPMI
- 应用集11监控项45触发器20图形8自动发现规则2Web场景
- 名称
- 图形类别
- Template OS Linux:CPU jumps
- 900
- 200
- 正常
- Template OS Linux:CPUload
- Template OS Linux:CPU utilization
- 层积的
- 600
- 340
- Pie
- covery:Diskspaceusage/boot
- TemplateOSLinux:Memory usage
- Template OSLinux:Swapusage
- 显示已自动发现的8中的8
- 0选择
- 复制
- 制除
- Dr增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置图标
- A不安全|10.0.0.8/zabbix/graphs.php?groupid=0&hostid=10254&form=创建图形
- 9
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置
- 管理
- ZShare
- 主机群组模板主机维护动作关联项事件
- 自动发现
- 服务
- 曾老湿
- 图形
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集11监控项45触发器20图形8自动发现规则2Web场景
- 图形预览
- Monitor LoginUserCount
- 900
- 200
- 图形类别正常
- 查看图例
- 查看工作时间
- 查看触发器
- 百分比线（左）
- 百分比线（右）口
- 纵轴Y最小值MIN可计算的
- 纵轴最大值可计算的
- 监控项
- 名称
- 功能
- 绘图风格
- 纵轴Y侧
- 颜色
- 动作
- 1:
- web01:MonitorL
- 平均
- 左侧
- FF66FF
- 移除
- Dr曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
Z曾老湿：自定义图表[每30秒刷新×
→C不安全|10.0.0.8/zabbix/charts.php?fullscreen=0&groupid=15&hostid=10254&graphid=800
应用zabbix-api
ZABBIX监测中资产记录报表配置管理
QShare？
仪表板问题概览Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
曾老湿
图形
群组web_group
主机web01图形Monitor LoginUserCount
过滤器
缩放：5m15m30m1h2h3h6h12h1d3d7d14d1m3m6m1y所有
2019-10-2315:48:20-2019-10-2316:48:20(现在）)
《《1y6m1m7d1d12h1h5m15m1h12h1d7d1m6m1y
1h固定的
web01:MonitorLogin User Count （1h)
3.5
3. 0
2.
1.0
7-01
最新最小平均最大
Monitor Login User Count
[平均]
2.46
触发器：Monitor Login UserCountProblem主机名：web01IP地址：10.0.0.7[>2]
Dri增e老湿ng
<!-- OCR_END -->

￼

***

| 自定义监第八步 |
| --- |

给触发器，添加动作，邮件告警

<!-- OCR_START -->
- Z曾老漫：动作的配置
- ①不安全|10.0.0.8/zabbix/actionconf.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录
- 报表
- 配置
- 管理
- ZShare
- 主机群组模板主机维护
- 动作
- 关联项事件自动发现
- 曾老湿
- 事件源触发器
- 创建动作
- 过滤器
- 名称
- 状态
- 任何
- 已启用停用的
- 应用
- 重设
- 条件
- 操作
- Report problemstoZabbixadministrators
- 发送消息给用户群组：Zabbixadministrators通过所有介质
- 停用的
- 显示已自动发现的1中的1
- 0选择
- 启用
- 禁用
- 副除
- Dri增e老湿ng
<!-- OCR_END -->

￼

如果事件源是触发器，那么就会触发动作，触发什么动作呢？就需要自己来创建了。

自定义触发器--->动作--->通知

如果事件源是触发器-->则创建一个触发的动作-->通知

1.我怎么通知。通过介质（配置一个邮箱的发件人）

2.通知给谁。（接收的邮箱）

3.通知的内容（内容可以自定义）

<!-- OCR_START -->
- 曾老湿：配置媒体类型
- 不安全|10.0.0.8/zabbix/zabbix.php?action=mediatype.list&ddreset=1
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表
- 配置
- 管理
- ZShare
- ？_心
- 一般agent代理程序认证用户群组用户
- 报警媒介类型
- 脚本队列
- 曾老湿
- 创建媒体类型
- 过滤器
- 名称
- 状态
- 任何
- 已启用停用的
- 重设
- 类型
- 用于动作中
- 细节
- Email
- 电子邮件
- 已启用
- SMTP服务器：“mail.company.com"SMTPHELO:“company.com"，SMTP电邮：zabbix@company.com”
- Jabber
- Jabber标识符：jiabber@company.com
- SMS
- 短信
- GSM调制解调器："/dev/ttySO"
- 显示已自动发现的3中的3
- 选择
- Dri曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置媒体类型
- QQ邮箱-帐户
- →CA不安全|10.0.0.8/zabbix/zabbix.php?action=mediatype.edit&mediatypeid=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QShare
- 一般
- agent代理程序
- 认证用户群组用户报警媒介类型
- 脚本队列
- 曾老湿
- 报警媒介类型
- 选项
- 名称
- QQ邮箱
- 类型
- 电子邮件
- SMTP服务器
- smtp.qq.com
- SMTP服务器端口
- 465
- SMTPHEL
- qq.com
- SMTP电邮
- 253097001@qq.com
- 安全链接
- 无STARTTLS（纯文本通信协议扩展）
- SSL/TLS
- SSL验证对端
- SSL验证主机
- 认证无
- Usemame and passw
- 用户名
- 已启用
- 更新
- 克隆
- 取消
- Zabbix3.4.15.2001-2018ZabbixSIA
- Dri曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户
- QQ邮箱-帐户
- 不安全|10.0.0.8/zabbix/users.php?ddreset=1
- 应用
- zabbix-api
- ZABBIX
- 监测中
- 资产记录
- 报表
- 配置
- 管理
- ZShare
- 一般
- agent代理程序认证用户群组
- 用户
- 报警媒介类型
- 脚本队列
- 曾老湿
- 用户群组所有
- 创建用户
- 过滤器
- 别名
- 名称
- 姓氏
- 用户类型任何用户管理员超级管理员
- 重设
- 用户名第一部分
- 用户类型
- 群组
- 是否在线？
- 登录
- 前端访问
- 调试模式
- 状态
- Admin
- Administrator
- 超级管理员
- 是（2019-10-2317:02:32)
- 正常
- 系统默认
- 停用的
- 已启用
- guest
- Guests
- 不（2019-10-2312:33:13)
- 显示已自动发现的2中的2
- 0选择
- 解锁
- 副除
- Dri曾老湿n
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户
- QQ邮箱-帐户
- 不安全|10.0.0.8/zabbix/users.php?form=update&userid=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 一般agent代理程序
- 认证用户群组用户报警媒介类型
- 曾老湿
- 用户
- 报警媒介
- 权限
- 类型
- 收件人
- 当启用时
- 如果存在严重性则使用
- 添加
- 更新
- 取消
- Dr曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户
- QQ邮箱-帐户
- 不安全|10.0.0.8
- 曾老湿：报警媒介
- A不安全|10.0.0.8/zabbix/popup_media.php?dstfrm=userForm
- 应用
- zabbix-api
- 报警媒介
- ZABBIX
- 监测中资产记录
- ZShare
- agent代理程序
- 认证用户群组
- 类型QQ邮箱
- 曾老
- 用户
- 收件人
- 133411023@qq.com
- 当启用时
- 1-7,00:00-24:00
- 权限
- 如果存在严重性则使用未分类
- 信息
- 警告
- 一般严重
- 严重
- 灾难
- 已启用
- 添加
- 取消
- 曾老湿
- Zabbix3.4.15.2001-2018ZabbixSIA
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置用户
- QQ邮箱-帐户
- →C不安全|10.0.0.8/zabbix/users.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 一般
- agent代理程序
- 认证用户群组用户报警媒介类型
- 脚本
- 队列
- 曾老湿
- 用户
- 报警媒介
- 权限
- 类型
- 收件人
- 当启用时
- 如果存在严重性则使用
- Status动作
- QQ邮箱133411023@qq.com
- 1-7,00:00-24:00未信警一严灾
- 已启用编辑移除
- 添加
- 更新
- Dr曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：仪表板
- QQ邮箱-帐户
- mail.qq.com/cgi-bin/frame_html?sid=7yDL9kZR7xysS0wR&r=283baebbb9bf35f60e473428e6aaa3a8
- 应用
- zabbix-api
- <133411023@qq.com>
- 口|反馈建议|帮助中心|退出
- Moil
- QQ邮箱
- mail.qq.com
- 邮箱首页|设置-换肤?
- Q邮件全文搜索.
- 写信
- 《返回
- 回复回复全部转发删除
- 彻底删除
- 举报拒收标记为
- 移动到.
- 上一封下一封
- 收信
- Problem:Monitor LoginUserCountProblem主机名：web01IP地址：10.0.0.7
- 通讯录
- 发件人：253097001<253097001@qq.com>
- 时间：2019年10月23日（星期三）下午5:05
- 收件箱（58）
- 收件人：<133411023@qq.com>
- 星标邮件★
- 这不是腾讯公司的官方邮件?。请勿轻信密保、汇款、中奖信息，勿轻易援打陌生电话。举报垃圾邮件
- 网站安全云检测
- 群邮件
- 草稿箱
- Problemstartedat17:05:16on2019.10.23
- 已发送
- Problemname:Monitor LoginUserCountProblem主机名：web01IP地址：10.0.0.7
- 已删除
- Host:web01
- 垃圾箱（3）
- [清空]
- Severity:Average
- QQ邮件订阅
- 其他邮箱
- Original problem ID:21
- 日历|记事本
- 在线文档NEW
- 快捷回复给：253097001
- 附件收藏
- 文件中转站
- 下一封未读：阿里云阿里云云盾证书服务到期提醒
- 贺卡|明信片
- 《返回回复回复全部转发删除彻底删除举报拒收标记为移动到
- 阅读空间
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：动作的配置
- QQ邮箱-帐户
- 故障PROBLEM，服务器：web01发X
- mailq.com/cgi-bin/frame_html?sid=7yDL9kZR7xysS0wR&r=283baebbb9bf35f60e473428e6aaa3a8
- 应用
- zabbix-api
- <133411023@qq.com>
- |反馈建议|帮助中心|退出
- MOiQQ邮箱
- mail.qq.com
- 邮箱首页|设置-换肤
- Q邮件全文搜索
- 写信
- 《返回回复回复全部转发删除彻底删除举报拒收标记为移动到
- 上一封下一封
- 收信
- 故障PROBLEM，服务器：web01发生：MonitorLoginUserCountProblem主机名：web01IP地址：10.0.0.7故障！
- 通讯录
- 发件人：253097001<253097001@qq.com>
- 时间：2019年10月23日（星期三）下午5:31
- 收件箱（58）
- 收件人：<133411023@qq.com>
- 星标邮件★
- 这不是腾讯公司的官方邮件。请勿轻信密保、汇款、中奖信息，勿轻易拨打陌生电话。举报垃圾邮件
- 网站安全云检测
- 群邮件
- 草稿箱
- 告警地址：10.0.0.7
- 已发送
- 已删除
- 告警主机：web01
- 垃圾箱（3）
- [清空]
- QQ邮件订阅
- 告警时间：2019.10.2317:31:16
- 其他邮箱
- 告警等级：Average
- 日历|记事本
- 在线文档NEW
- 告警信息：MonitorLoginUserCountProblem主机名：web01IP地址：10.0.0.7
- 附件收藏
- 文件中转站
- 告警项目：user.count
- 贺卡|明信片
- 阅读空间
- 问题详情：MonitorLoginUserCount：3
- 当前状态：PROBLEM:3
- 事件ID:23
- Dri增e老湿ng
<!-- OCR_END -->

￼

> 更新: 2019-11-23 09:13:28  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/wo3228>