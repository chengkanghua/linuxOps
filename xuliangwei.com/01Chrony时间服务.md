# 01 Chrony时间服务

# 01 Chrony时间服务

* [1.系统时区配置](http://kt.xuliangwei.com/15096029771222.html#toc_0)
* [2.chrony配置](http://kt.xuliangwei.com/15096029771222.html#toc_1)
* [3.ntpdate同步](http://kt.xuliangwei.com/15096029771222.html#toc_2)
* [4.chrony同步](http://kt.xuliangwei.com/15096029771222.html#toc_3)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

NTP（Network Time Protocol，网络时间协议）是用来使网络中的各个计算机时间同步的一种协议。它的用途是把计算机的时钟同步到世界协调时UTC，其精度在局域网内可达0.1ms，在互联网上绝大多数的地方其精度可以达到1-50ms。

NTP服务器就是利用NTP协议提供时间同步服务的。

## 1.系统时区配置

1.统一调整时区为亚洲上海, 如不统一则会导致时间同步产生差异

```plain
[root@xuliangwei ~]# timedatectl
      Local time: Sun 2018-03-18 08:46:29 CST
  Universal time: Sun 2018-03-18 00:46:29 UTC
        RTC time: Sun 2018-03-18 00:46:29
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
//列出可用时区
[root@xuliangwei ~]# timedatectl list-timezones
//必须调整时间为上海
[root@xuliangwei ~]# timedatectl set-timezone Asia/Shanghai
//使用网络时间同步(考试必考题)
[root@xuliangwei ~]# timedatectl set-ntp true
```

## 2.chrony配置

基础环境准备

```plain
[root@ntp-server ~]# systemctl stop  firewalld
[root@ntp-server ~]# systemctl disable firewalld
[root@ntp-server ~]# setenforce 0
[root@ntp-server ~]# getenforce 
Disabled
```

1.安装`chrony`时间同步服务

```plain
[root@ntp-server ~]# yum install chrony -y
```

2.使用chrony服务同步时间

```plain
//使用网络时间同步(考试必考题)
[root@ntp-server ~]# timedatectl set-ntp true
//配置时间同步服务器
[root@ntp-server ~]# vim /etc/chrony.conf
server ntp1.aliyun.com iburst
# Allow NTP client access from local network.
allow 192.168.69.0/24
```

3.启动chrony服务

```plain
[root@ntp-server ~]# systemctl enable chronyd
[root@ntp-server ~]# systemctl start chronyd
```

4.验证服务端是否能同步时间

```plain
[root@ntp-server ~]# chronyc sources
210 Number of sources = 1
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^~ localhost                     2   6   377    41   -10.8s[ -10.8s] +/-   11ms
```

## 3.ntpdate同步

客户端要等几分钟再与新启动的ntp服务器进行时间同步，否则会提示`no server suitable for synchronization found`错误。

```plain
//客户端安装ntpdate命令进行同步(第一种方式)
[root@ntp-client ~]# yum install ntpdate -y
[root@ntp-client ~]# ntpdate 192.168.69.112
18 Mar 11:01:47 ntpdate[18913]: step time server 192.168.69.112 offset -9.805077 sec
//将同步命令写入计划任务。
[root@node1 ~]# crontab -e
*/2 * * * * /usr/sbin/ntpdate 172.16.56.11 &>/dev/null
```

## 4.chrony同步

<!-- OCR_START -->
- Chrony时间同步服务
- eth1:192.168.69.13
- 同步公网
- 内网主机只能同步内部时间服务器
- 内网主机没有网络无法同步公网
- 公网时间服务器
- eth0: 192.168.56.11
- ntp1.aliyun.com
- eth1:192.168.69.11
- eth1:192.168.69.12
<!-- OCR_END -->

客户端安装`chrony`服务同步内网时间服务器(第二种方式)

```plain
//环境准备
[root@ntp-client ~]# systemctl stop firewalld
[root@ntp-client ~]# setenforce 0
//安装时间同步
[root@ntp-client ~]# yum install chrony -y
[root@ntp-client ~]# timedatectl set-ntp true
//配置时间同步服务器
[root@ntp-client ~]# vim /etc/chrony.conf
#指定内部时间服务器地址
server 192.168.69.112 iburst
//启动chrony服务
[root@ntp-client ~]# systemctl enable chronyd
[root@ntp-client ~]# systemctl start chronyd
//客户端同步验证
[root@ntp-client ~]# chronyc sources
210 Number of sources = 1
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^? 192.168.69.112                3   6   376   206   -14.1s[ -14.1s] +/-  12.6s
```

> 更新: 2019-03-20 19:57:47  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/ywg3l0>