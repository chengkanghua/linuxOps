# tcpdump-抓包工具-Linux

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- tcpdump-抓包工具-Linux
- 基本介绍
- 这是什么鬼
- 基础案例
  - 观察DNS解析情况
  - 抓取一个TCP包
- tcpdump中最常见的几个参数
- 参考资料

[https://www.cnblogs.com/asheng2016/p/9562707.html 原文\
](https://www.cnblogs.com/asheng2016/p/9562707.html)

环境：VMware-Workstation-12-Pro，Windows-10，CentOS-6.9-x86_64，Xshell5

# 基本介绍

tcpdump是Linux自带的抓包工具，可以详细看到计算机通信中详细报文内容，如果读者熟悉另一款\
强大的抓包工具wireshark，tcpdump相当于是wireshark的命令行版本。dump这个单词有垃圾堆，\
倒垃圾的意思，在计算机英语中的含义是转存。

tcpdump官网：http://www.tcpdump.org/\
This is the official web site of tcpdump, a powerful command-line packet analyzer;

查看本机tcpdump的版本

```plain
[root@as4k html]# tcpdump --version  
tcpdump version 4.1-PRE-CVS_2017_03_21
```

tcpdump的最新版本\
Version: 4.9.2\
Release Date: September 3, 2017

官方文档：http://www.tcpdump.org/manpages/tcpdump.1.html，此文档无疑是全网最详细，最权威\
的教程，很多大牛的博客都有借鉴此文的内容。

# 这是什么鬼

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

上面是tcpdump，man page里面的内容，oh my god！这么多参数，本文当然不可能逐一介绍上面的内容，\
我们先直接通过一些简单的案例看看效果，然后给出一些常见参数的用法。

# 基础案例

## 观察DNS解析情况

我们知道，Linux系统要想正常访问互联网，需要正确配置DNS解析，现在我们已经配置了阿里云的DNS\
223.6.6.6，我们想看一下DNS解析是否正常，就可以使用tcpdump来抓取DNS包，准备好两个xshell\
窗口，按照如下方式操作

步骤1 tcpdump -n -i any port 53

![1547276407031-db384cb5-6412-46e1-bd48-67fa1314a19b.png](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-01.png)

尽量在root用户下使用tcpdump命令，`-n`表示不要把IP地址解析成域名，`-i`表示抓取哪块网卡的通信\
数据包，`any`表示任意一块，`port`是指定要抓取数据包的端口，DNS服务工作在53端口上，执行完毕之\
后，我们切换到第2个窗口，进行步骤2

步骤2 ping -c3 baidu.com\
`-c3`表示和ping次停下，这时候我们的计算机和百度产生的通信，窗口1的tcpdump就会监听到我们的通信\
数据，也就是所谓的抓包，切换到窗口1，看到的数据大致如下

![1547276407099-aa1fcd33-051f-4d3b-8ed6-57a221ec333b.png](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-02.png)

在上图中我们可看到本地192.168.56.11，端口42711进程向阿里云DNS服务器223.6.6.6，请求告知\
baidu.com的IP地址是什么？阿里云的DNS服务器成功给了我们答复，由此可以说明，我们的DNS工作\
正常。

如果抓取的DNS数据包，看起来向下面这样：

![1547276407031-4ffbb9a7-8324-401c-a018-a9b913e2e81d.png](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-03.png)

从上图可以看出，我们一共发起了三次DNS查询请求，服务器才最终给我们返回了IP地址，这显然是不太正常的，\
由此我们可以判断，这次网络卡慢的原因，应该出在DNS解析上。

以上就是使用tcpdump抓包来简单判断网络通信状况。

## 抓取一个TCP包

首先我们知道TCP三次握手分别是：ACK，SYN-ACK，ACK。下面我们就在Linux中简单搭建nginx服务器，\
然后使用tcpdump抓取tcp包看下。

安装nginx服务并启动

```plain
yum install nginx -y  
/etc/init.d/nginx start
```

然后在windows浏览器中输入自己的IP地址，将会看到如下界面

![1547276407878-7b608235-a6b7-4441-aa54-cc386f3bb047.png](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-04.png)

在xshell中执行`tcpdump -n -i eth0 port 80`，eth0是我当前网卡的名称，然后在浏览器中刷新一下，\
可以看到抓取到了如下内容

![1547276407076-1c8078f1-dfd9-454d-b8b2-92b1b78833fd.png](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-05.png)

可以看到，我们熟悉的ACK，SYN-ACK，ACK三次握手的信息都出现了，说明我们TCP连接成功建立了。

> 不要太过纠结于抓包细节，事实上tcp协议包含相当多的内容，无法在此展开

# tcpdump中最常见的几个参数

-i 指定要抓取数据包的网卡名称

```plain
tcpdump -i eth0 # 抓取eth0网卡的数据包
```

-c 指定抓取包的个数

```plain
tcpdump -i eth0 -c 10 # 只抓取10个包
```

-w 把抓取到的数据存放到文件中供以后分析

```plain
# tcpdump -i eth0 -c 10 -w my-packets.pcap  
# file my-packets.pcap   
my-packets.pcap: tcpdump capture file ....
```

可以看到，我们保存的`my-packets.pcap`是一种特殊文件，直接使用vim是无法查看的，可以把\
该文件拿到windows下，使用wireshark查看，效果如下

![1547276407123-4cfc57de-c3a4-4514-877e-255664062e7e.png](img/tcpdump-%E6%8A%93%E5%8C%85%E5%B7%A5%E5%85%B7-Linux-06.png)

-n 不解析ip，默认会将ip解析成域名\
指定过滤端口(port)和主机名(host)

```plain
tcpdump -n -i eth0 port 80  
tcpdump -n -i eth0 host baidu.com  
tcpdump -n -i eth0 host baidu.com and port 80
```

# 参考资料

官方权威教程\
http://www.tcpdump.org/manpages/tcpdump.1.html

漫画形式介绍tcpdump，非常有趣\
https://jvns.ca/zines/#tcpdump


> 更新: 2020-03-10 13:35:44  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/wgcv5a>