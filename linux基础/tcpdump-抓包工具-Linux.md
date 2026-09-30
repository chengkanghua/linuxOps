# tcpdump 抓包工具（Linux）

> tcpdump 是 Linux 自带的抓包工具，可以详细看到计算机通信中的报文内容。如果你熟悉 wireshark，tcpdump 相当于**wireshark 的命令行版本**（dump 在计算机英语中是"转存"的意思）。

原文：<https://www.cnblogs.com/asheng2016/p/9562707.html>

环境：VMware-Workstation-12-Pro，Windows-10，CentOS-6.9-x86_64，Xshell5

## 一、基本介绍

- tcpdump 官网：<http://www.tcpdump.org/>
- 官方文档（全网最详细、最权威）：<http://www.tcpdump.org/manpages/tcpdump.1.html>

查看本机 tcpdump 版本：
```plain
[root@as4k html]# tcpdump --version
tcpdump version 4.1-PRE-CVS_2017_03_21
```
> 最新版本（截至原文）：Version 4.9.2，Release Date: September 3, 2017

## 二、man page 一览（参数很多，先别慌）

```plain
TCPDUMP(8)                                                          TCPDUMP(8)
NAME
       tcpdump - dump traffic on a network
SYNOPSIS
       tcpdump [ -AdDefIJKlLnNOpqRStuUvxX ] [ -B buffer_size ] [ -c count ]
               [ -C file_size ] [ -G rotate_seconds ] [ -F file ]
               [ -i interface ] [ -j tstamp_type ] [ -m module ] [ -M secret ]
               [ -Q|-P in|out|inout ]
               [ -r file ] [ -s snaplen ] [ -T type ] [ -w file ]
               [ -W filecount ]
               [ -E spi@ipaddr algo:secret,...  ]
               [ -y datalinktype ] [ -z postrotate-command ] [ -Z user ]
               [ expression ]
```

上面参数虽多，但不必逐一掌握。下面先通过简单案例看效果，再给出常用参数。

## 三、基础案例

### 案例 1：观察 DNS 解析情况

Linux 要正常访问互联网需要正确的 DNS 解析。假设已配置阿里云 DNS `223.6.6.6`，可用 tcpdump 抓 DNS 包验证。准备**两个 xshell 窗口**：

**步骤 1**（窗口 1）：
```bash
tcpdump -n -i any port 53
```
![DNS抓包步骤1](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-01.png)

- 尽量在 root 下使用 tcpdump
- `-n`：不要把 IP 地址解析成域名
- `-i`：指定抓取哪块网卡，`any` 表示任意一块
- `port`：指定抓取的端口，DNS 工作在 53 端口

**步骤 2**（窗口 2）：
```bash
ping -c3 baidu.com
```
`-c3` 表示 ping 3 次停下。此时本机与百度产生通信，窗口 1 的 tcpdump 就会监听到：

![DNS抓包结果](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-02.png)

可以看到本地 `192.168.56.11` 的 42711 端口向阿里云 DNS `223.6.6.6` 请求 `baidu.com` 的 IP，并成功得到答复，说明 DNS 工作正常。

**异常判读**：如果抓到的 DNS 包像下面这样——

![DNS异常](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-03.png)

一共发起了**三次** DNS 查询请求服务器才返回 IP，这显然不太正常，可据此判断网络卡慢的原因出在 DNS 解析上。

> 以上就是用 tcpdump 抓包来简单判断网络通信状况。

### 案例 2：抓取一个 TCP 包

TCP 三次握手分别是：**ACK，SYN-ACK，ACK**。我们在 Linux 上简单搭建 nginx，然后用 tcpdump 抓 TCP 包。

```plain
yum install nginx -y
/etc/init.d/nginx start
```

在 Windows 浏览器输入本机 IP，可看到 nginx 欢迎页：
![nginx页面](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-04.png)

在 xshell 中执行（eth0 为当前网卡名），然后在浏览器刷新：
```bash
tcpdump -n -i eth0 port 80
```
![TCP三次握手](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-05.png)

可以看到熟悉的 `ACK`、`SYN-ACK`、`ACK` 三次握手信息，说明 TCP 连接成功建立。

> 不要太过纠结于抓包细节，事实上 TCP 协议包含相当多的内容，无法在此展开。

## 四、tcpdump 最常见的几个参数

### `-i` 指定网卡
```plain
tcpdump -i eth0        # 抓取 eth0 网卡的数据包
```

### `-c` 指定抓包个数
```plain
tcpdump -i eth0 -c 10  # 只抓取 10 个包
```

### `-w` 保存到文件（供以后分析）
```plain
tcpdump -i eth0 -c 10 -w my-packets.pcap
file my-packets.pcap
# my-packets.pcap: tcpdump capture file ....
```
保存的 `.pcap` 是特殊格式，**直接用 vim 无法查看**。可以拿到 Windows 下用 wireshark 打开：
![wireshark分析](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-06.png)

### `-n` 不解析 IP（默认会把 IP 解析成域名）+ 过滤端口/主机
```plain
tcpdump -n -i eth0 port 80
tcpdump -n -i eth0 host baidu.com
tcpdump -n -i eth0 host baidu.com and port 80
```

## 五、参考资料

- 官方权威教程：<http://www.tcpdump.org/manpages/tcpdump.1.html>
- 漫画形式介绍 tcpdump（非常有趣）：<https://jvns.ca/zines/#tcpdump>

> 更新: 2020-03-10 13:35:44
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/wgcv5a>
