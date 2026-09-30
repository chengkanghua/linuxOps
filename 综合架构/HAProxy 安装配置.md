# <font style="color:rgb(34, 34, 34);">2/0 haproxy 简介</font>
**<font style="color:rgb(34, 34, 34);">HAProxy</font>**<font style="color:rgb(34, 34, 34);">是一个使用C语言编写的自由及开放源代码软件，其提供</font>[<font style="color:rgb(34, 34, 34);">高可用性</font>](https://baike.baidu.com/item/%E9%AB%98%E5%8F%AF%E7%94%A8%E6%80%A7/909038)<font style="color:rgb(34, 34, 34);">、</font>[<font style="color:rgb(34, 34, 34);">负载均衡</font>](https://baike.baidu.com/item/%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1/932451)<font style="color:rgb(34, 34, 34);">，以及基于</font>[<font style="color:rgb(34, 34, 34);">TCP</font>](https://baike.baidu.com/item/TCP)<font style="color:rgb(34, 34, 34);">和</font>[<font style="color:rgb(34, 34, 34);">HTTP</font>](https://baike.baidu.com/item/HTTP)<font style="color:rgb(34, 34, 34);">的应用程序</font>[<font style="color:rgb(34, 34, 34);">代理</font>](https://baike.baidu.com/item/%E4%BB%A3%E7%90%86/3242667)<font style="color:rgb(34, 34, 34);">。</font>

<font style="color:rgb(34, 34, 34);">HAProxy特别适用于那些负载特大的web站点，这些站点通常又需要会话保持或七层处理。HAProxy运行在当前的硬件上，完全可以支持数以万计的</font>[<font style="color:rgb(34, 34, 34);">并发连接</font>](https://baike.baidu.com/item/%E5%B9%B6%E5%8F%91%E8%BF%9E%E6%8E%A5/3763280)<font style="color:rgb(34, 34, 34);">。并且它的运行模式使得它可以很简单安全的整合进您当前的架构中， 同时可以保护你的web服务器不被暴露到网络上。</font>

<font style="color:rgb(34, 34, 34);">HAProxy实现了一种</font>[<font style="color:rgb(34, 34, 34);">事件驱动</font>](https://baike.baidu.com/item/%E4%BA%8B%E4%BB%B6%E9%A9%B1%E5%8A%A8/9597519)<font style="color:rgb(34, 34, 34);">**, **单一进程模型，此模型支持非常大的</font>[<font style="color:rgb(34, 34, 34);">并发连接数</font>](https://baike.baidu.com/item/%E5%B9%B6%E5%8F%91%E8%BF%9E%E6%8E%A5%E6%95%B0/401716)<font style="color:rgb(34, 34, 34);">。</font>[<font style="color:rgb(34, 34, 34);">多进程</font>](https://baike.baidu.com/item/%E5%A4%9A%E8%BF%9B%E7%A8%8B/9796976)<font style="color:rgb(34, 34, 34);">或多线程模型受内存限制 、系统调度器限制以及无处不在的锁限制，很少能处理数千并发连接。</font>[<font style="color:rgb(34, 34, 34);">事件驱动模型</font>](https://baike.baidu.com/item/%E4%BA%8B%E4%BB%B6%E9%A9%B1%E5%8A%A8%E6%A8%A1%E5%9E%8B/1419787)<font style="color:rgb(34, 34, 34);">因为在有更好的资源和时间管理的用户空间(User-Space) 实现所有这些任务，所以没有这些问题。此模型的弊端是，在多核系统上，这些程序通常扩展性较差。这就是为什么他们必须进行优化以 使每个CPU时间片(Cycle)做更多的工作。</font>

<font style="color:rgb(34, 34, 34);">包括</font><font style="color:rgb(34, 34, 34);"> </font>[<font style="color:rgb(34, 34, 34);">GitHub</font>](https://baike.baidu.com/item/GitHub)<font style="color:rgb(34, 34, 34);">、</font>[<font style="color:rgb(34, 34, 34);">Bitbucket</font>](https://baike.baidu.com/item/Bitbucket)<font style="color:rgb(34, 34, 34);">、</font>[<font style="color:rgb(34, 34, 34);">Stack Overflow</font>](https://baike.baidu.com/item/StackOverFlow/23731987?fr=aladdin)<font style="color:rgb(34, 34, 34);">、</font>[<font style="color:rgb(34, 34, 34);">Reddit</font>](https://baike.baidu.com/item/Reddit)<font style="color:rgb(34, 34, 34);">、</font>[<font style="color:rgb(34, 34, 34);">Tumblr</font>](https://baike.baidu.com/item/Tumblr)<font style="color:rgb(34, 34, 34);">、</font>[<font style="color:rgb(34, 34, 34);">Twitter</font>](https://baike.baidu.com/item/Twitter)<font style="color:rgb(34, 34, 34);">和</font><font style="color:rgb(34, 34, 34);"> </font>[<font style="color:rgb(34, 34, 34);">Tuenti</font>](https://baike.baidu.com/item/Tuenti)<font style="color:rgb(34, 34, 34);">在内的知名网站，及亚马逊网络服务系统都使用了HAProxy。</font>

# _**<font style="color:rgb(51, 51, 51);">3</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">0</font>**_**<font style="color:rgb(34, 34, 34) !important;">负载均衡</font>**
## _**<font style="color:rgb(51, 51, 51);">3</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">1</font>**_**<font style="color:rgb(34, 34, 34) !important;">二层负载均衡（mac）</font>**
<font style="color:rgb(34, 34, 34);">用于虚拟mac地址方式，外部对虚拟mac地址请求，负载均衡接收后分配给后端实际的mac地址响应。</font>

## _**<font style="color:rgb(51, 51, 51);">3</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">2</font>**_**<font style="color:rgb(34, 34, 34) !important;">三层负载均衡（ip）</font>**
<font style="color:rgb(34, 34, 34);">一般用于虚拟ip地址的方式，外部对虚拟ip地址请求，负载均衡接收后分配给后端实际的ip地址响应。</font>

## _**<font style="color:rgb(51, 51, 51);">3</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">3</font>**_**<font style="color:rgb(34, 34, 34) !important;">四层负载均衡（tcp）</font>**
<font style="color:rgb(34, 34, 34);">在三层负载均衡的基础上，用ip+port接收请求，在转发到对应的机器上。</font>

<font style="color:rgb(34, 34, 34);">产品大概有：F5，lvs，nginx，haproxy......</font>

## _**<font style="color:rgb(51, 51, 51);">3</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">4</font>**_**<font style="color:rgb(34, 34, 34) !important;">七层负载均衡（http）</font>**
<font style="color:rgb(34, 34, 34);">根据虚拟的url或者ip，主机名接收请求，在转发到相应的处理服务器上。</font>

<font style="color:rgb(34, 34, 34);">产品大概有：haproxy，nginx，apache，mysql proxy......</font>

# _**<font style="color:rgb(51, 51, 51);">4</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">0</font>**_**<font style="color:rgb(34, 34, 34) !important;">haproxy安装</font>**
## _**<font style="color:rgb(51, 51, 51);">4</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">1</font>**_**<font style="color:rgb(34, 34, 34) !important;">Yum安装</font>**
```plain
[root@LB ~]# yum -y install haproxy
```

## _**<font style="color:rgb(51, 51, 51);">4</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">2</font>**_**<font style="color:rgb(34, 34, 34) !important;">源码安装</font>**
<font style="color:rgb(34, 34, 34);">haproxy官方帮助文档：</font>[<font style="color:rgb(34, 34, 34);">https://cbonte.github.io/haproxy-dconv/</font>](https://cbonte.github.io/haproxy-dconv/)

**<font style="color:rgb(34, 34, 34);">下载安装包</font>**

<font style="color:rgb(34, 34, 34);">haproxy源码包下载网站地址：</font>[<font style="color:rgb(34, 34, 34);">https://src.fedoraproject.org/repo/pkgs/haproxy/</font>](https://src.fedoraproject.org/repo/pkgs/haproxy/)

<font style="color:rgb(34, 34, 34);">使用xftp传到本机</font>

![](img/HAProxy%20%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE-01.png)

**<font style="color:rgb(34, 34, 34);">解压并安装</font>**

```plain
//解压源码包
[root@LB ~]# ls
anaconda-ks.cfg  haproxy-2.3.10.tar.gz
#解压
[root@LB ~]# tar xf haproxy-2.3.10.tar.gz 
[root@LB ~]# ls
anaconda-ks.cfg  haproxy-2.3.10  haproxy-2.3.10.tar.gz
#进到目录中查看以下
[root@LB ~]# cd haproxy-2.3.10
[root@LB haproxy-2.3.10]# ls
BRANCHES   CONTRIBUTING  include  MAINTAINERS  reg-tests  src      VERDATE
CHANGELOG  doc           INSTALL  Makefile     ROADMAP    SUBVERS  VERSION
contrib    examples      LICENSE  README       scripts    tests

//创建haproxy用户
[root@LB ~]# useradd -r -M -s /sbin/nologin haproxy

//安装工具包
[root@LB ~]# yum -y install make gcc pcre-devel bzip2-devel openssl-devel systemd-devel

//查看Linux核心数
[root@LB ~]# cat /proc/cpuinfo

# 总核数 = 物理CPU个数 X 每颗物理CPU的核数 
# 总逻辑CPU数 = 物理CPU个数 X 每颗物理CPU的核数 X 超线程数

# 查看物理CPU个数
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l

# 查看每个物理CPU中core的个数(即核数)
cat /proc/cpuinfo| grep "cpu cores"| uniq

# 查看逻辑CPU的个数
cat /proc/cpuinfo| grep "processor"| wc -l

查看CPU信息（型号）
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

查看内 存信息
# cat /proc/meminfo

//调用处理器
[root@LB haproxy-2.3.10]# make -j $(grep 'processor' /proc/cpuinfo |wc -l)  \
> TARGET=linux-glibc  \
> USE_OPENSSL=1  \
> USE_ZLIB=1  \
> USE_PCRE=1  \
> USE_SYSTEMD=1
  CC      src/ev_poll.o
  CC      src/ev_epoll.o
  ...
  ...
  LD      haproxy

//开始编译安装
#清除上次的make命令所产生的object文件（后缀为“.o”的文件）及可执行文件
[root@LB haproxy-2.3.10]# make clean

#安装到/usr/local目录下，名字叫haproxy
[root@LB haproxy-2.3.10]# make install PREFIX=/usr/local/haproxy

#把haproxy程序复制到/usr/sbin/目录下
[root@LB haproxy-2.3.10]# cp haproxy /usr/sbin/

#查看haproxy文件类型
[root@LB haproxy-2.3.10]# file haproxy 
haproxy: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=df4decbe5c7a826ef193e22887e81b64d3651a30, with debug_info, not stripped
```

# _**<font style="color:rgb(51, 51, 51);">5</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">0</font>**_**<font style="color:rgb(34, 34, 34) !important;">配置各个负载的内核</font>**
```plain
[root@LB ~]# echo 'net.ipv4.ip_nonlocal_bind = 1' >>  /etc/sysctl.conf
[root@LB ~]# echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
[root@LB ~]# sysctl  -p
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.ip_forward = 1
```

# _**<font style="color:rgb(51, 51, 51);">6</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">0</font>**_**<font style="color:rgb(34, 34, 34) !important;">提供配置文件</font>**
```plain
mkdir /etc/haproxy

cat > /etc/haproxy/haproxy.cfg <<EOF
#--------------全局配置----------------
global
    log 127.0.0.1 local0  info
    #log loghost local0 info
    maxconn 20480
#chroot /usr/local/haproxy
    pidfile /var/run/haproxy.pid
    #maxconn 4000
    user haproxy
    group haproxy
    daemon
#---------------------------------------------------------------------
#common defaults that all the 'listen' and 'backend' sections will
#use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode http
    log global
    option dontlognull
    option httpclose
    option httplog
    #option forwardfor
    option redispatch
    balance roundrobin
    timeout connect 10s
    timeout client 10s
    timeout server 10s
    timeout check 10s
    maxconn 60000
    retries 3
#--------------统计页面配置------------------
listen admin_stats
    bind 0.0.0.0:8189
    stats enable
    mode http
    log global
    stats uri /haproxy_stats
    stats realm Haproxy\ Statistics
    stats auth admin:admin
    #stats hide-version
    stats admin if TRUE
    stats refresh 30s
#---------------web设置-----------------------
listen webcluster
    bind 0.0.0.0:80
    mode http
    #option httpchk GET /index.html
    log global
    maxconn 3000
    balance roundrobin
    cookie SESSION_COOKIE insert indirect nocache
    server web01 192.168.110.10:80 check inter 2000 fall 5
    #server web01 192.168.110.10:80 cookie web01 check inter 2000 fall 5
EOF
```

## _**<font style="color:rgb(51, 51, 51);">6</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">1</font>**_**<font style="color:rgb(34, 34, 34) !important;">总体介绍</font>**
<font style="color:rgb(34, 34, 34);">haproxy 的配置文件由两部分组成：全局设定和对代理的设定，共分为五段：</font>`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">global</font>**`<font style="color:rgb(34, 34, 34);">，</font>`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">defaults</font>**`<font style="color:rgb(34, 34, 34);">，</font>`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">frontend</font>**`<font style="color:rgb(34, 34, 34);">，</font>`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">backend</font>**`<font style="color:rgb(34, 34, 34);">，</font>`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">listen</font>**`

1. <font style="color:rgb(34, 34, 34);">global: 全局配置，主要用于定义全局参数，属于进程级的配置，通常和操作系统配置有关。</font>
2. <font style="color:rgb(34, 34, 34);">default: 配置默认参数，这些参数可以被用到frontend，backend，Listen组件。</font>
3. <font style="color:rgb(34, 34, 34);">frontend：接收请求的前端虚拟节点，frontend可以指定具体使用后端的backend。</font>
4. <font style="color:rgb(34, 34, 34);">backend : 后端服务集群的配置，真实服务器，一个backend对应一个或者多个实体服务器。</font>
5. <font style="color:rgb(34, 34, 34);">listen: fronted和backend的组合体，比如haproxy实例状态监控部分配置。Haproxy1.3之前的唯一配置方式。</font>

## _**<font style="color:rgb(51, 51, 51);">6</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">2</font>**_**<font style="color:rgb(34, 34, 34) !important;">时间格式</font>**
<font style="color:rgb(34, 34, 34);">一些包含了值的参数表示时间，如超时时长。这些值一般以毫秒为单位，但也可以使用其它的时间单位后缀</font>

+ `**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">us</font>**`<font style="color:rgb(34, 34, 34);">: 微秒(microseconds)，即1/1000000秒；</font>
+ `**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">ms</font>**`<font style="color:rgb(34, 34, 34);">: 毫秒(milliseconds)，即1/1000秒；</font>
+ `**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">s</font>**`<font style="color:rgb(34, 34, 34);">: 秒(seconds)；</font>
+ `**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">m</font>**`<font style="color:rgb(34, 34, 34);">: 分钟(minutes)；</font>
+ `**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">h</font>**`<font style="color:rgb(34, 34, 34);">：小时(hours)；</font>
+ `**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">d</font>**`<font style="color:rgb(34, 34, 34);">: 天(days)；</font>

## _**<font style="color:rgb(51, 51, 51);">6</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">3</font>**_**<font style="color:rgb(34, 34, 34) !important;">global配置</font>**
<font style="color:rgb(34, 34, 34);">通常主要定义全局配置主要用于设定义全局参数，属于进程级的配置，通常和操作系统配置有关。</font>

```plain
global
         log 127.0.0.1 local3        #定义haproxy日志输出设置
         log 127.0.0.1   local1 notice        
         #log loghost    local0 info #定义haproxy 日志级别
         ulimit-n 82000              #设置每个进程的可用的最大文件描述符
         maxconn 20480               #默认最大连接数
         chroot /usr/local/haproxy   #chroot运行路径
         uid 99                      #运行haproxy 用户 UID
         gid 99                      #运行haproxy 用户组gid
         daemon                      #以后台形式运行harpoxy
         nbproc 1                    #设置进程数量
         pidfile /usr/local/haproxy/run/haproxy.pid  #haproxy 进程PID文件
         #debug                      #haproxy调试级别，建议只在开启单进程的时候调试
         #quiet
```

+ <font style="color:rgb(34, 34, 34);">log：全局的日志配置，local0是日志输出设置，info表示日志级别（err，waning，info，debug）；</font>
+ <font style="color:rgb(34, 34, 34);">maxconn：设定每个HAProxy进程可接受的最大并发连接数，此选项等同于linux命令选项”ulimit -n”；</font>
+ <font style="color:rgb(34, 34, 34);">chroot：修改haproxy的工作目录至指定的目录并在放弃权限之前执行chroot()操作,可以提升haproxy的安全级别，不过需要注意的是要确保指定的目录为空目录且任何用户均不能有写权限；</font>
+ <font style="color:rgb(34, 34, 34);">daemon：让haproxy以守护进程的方式工作于后台，其等同于“-D”选项的功能，当然，也可以在命令行中以“-db”选项将其禁用；</font>
+ <font style="color:rgb(34, 34, 34);">nbproc：指定启动的haproxy进程个数，只能用于守护进程模式的haproxy；默认只启动一个进程，鉴于调试困难等多方面的原因，一般只在单进程仅能打开少数文件描述符的场景中才使用多进程模式；</font>
+ <font style="color:rgb(34, 34, 34);">pidfile：将haproxy的进程写入pid文件；</font>
+ <font style="color:rgb(34, 34, 34);">ulimit-n：设定每进程所能够打开的最大文件描述符数目，默认情况下其会自动进行计算，因此不推荐修改此选项；</font>

## _**<font style="color:rgb(51, 51, 51);">6</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">4</font>**_**<font style="color:rgb(34, 34, 34) !important;">defaults配置</font>**
<font style="color:rgb(34, 34, 34);">用于设置配置默认参数，这些参数可以被用到frontend，backend，listen组件。</font>

<font style="color:rgb(34, 34, 34);">在此部分中设置的参数值，默认会自动引用到下面的frontend、backend、listen部分中。如果某些参数属于公用的配置，只需要在defaults部分添加一次即可。而如果frontend、backend、listen部分也配置了与defaults部分一样的参数，defaults部分参数对应的值自动被覆盖。</font>

```plain
defaults
         log    global         #引入global定义的日志格式
         mode    http          #所处理的类别(7层代理http，4层代理tcp)
         maxconn 50000         #最大连接数
         option  httplog       #日志类别为http日志格式
         option  httpclose     #每次请求完毕后主动关闭http通道
         option  dontlognull   #不记录健康检查日志信息
         option  forwardfor    #如果后端服务器需要获得客户端的真实ip，需要配置的参数，可以从http header 中获取客户端的IP
         retries 3             #3次连接失败就认为服务器不可用，也可以通过后面设置        
         stats refresh 30       #设置统计页面刷新时间间隔
         option abortonclose    #当服务器负载很高的时候，自动结束掉当前队列处理比较久的连接
         balance roundrobin     #设置默认负载均衡方式，轮询方式
         #balance source        #设置默认负载均衡方式，类似于nginx的ip_hash      
         #contimeout 5000        #设置连接超时时间
         #clitimeout 50000       #设置客户端超时时间
         #srvtimeout 50000       #设置服务器超时时间
         timeout http-request    10s  #默认http请求超时时间
         timeout queue           1m   #默认队列超时时间
         timeout connect         10s  #默认连接超时时间
         timeout client          1m   #默认客户端超时时间
         timeout server          1m   #默认服务器超时时间
         timeout http-keep-alive 10s  #默认持久连接超时时间
         timeout check           10s  #设置超时检查超时时间
```

+ <font style="color:rgb(34, 34, 34);">mode http：设置haproxy的运行模式，有三种｛http|tcp|health｝。注意：如果haproxy中还要使用4层的应用（mode tcp）的话，不建议在此定义haproxy的运行模式。</font>
    - <font style="color:rgb(34, 34, 34);">tcp模式：在此模式下，客户端和服务器端之前将建立一个全双工的连接，不会对七层报文做任何检查，默认为tcp模式，经常用于SSL、SSH、SMTP等应用。</font>
    - <font style="color:rgb(34, 34, 34);">http模式：在此模式下，客户端请求在转发至后端服务器之前将会被深度分板，所有不与RFC格式兼容的请求都会被拒绝。</font>
    - <font style="color:rgb(34, 34, 34);">health：已基本不用了。</font>
+ <font style="color:rgb(34, 34, 34);">log global：设置日志继承全局配置段的设置。</font>
+ <font style="color:rgb(34, 34, 34);">option httplog：表示开始打开记录http请求的日志功能。</font>
+ <font style="color:rgb(34, 34, 34);">option dontlognull：如果产生了一个空连接，那这个空连接的日志将不会记录。</font>
+ <font style="color:rgb(34, 34, 34);">option http-server-close：打开http协议中服务器端关闭功能，使得支持长连接，使得会话可以被重用，使得每一个日志记录都会被记录。</font>
+ <font style="color:rgb(34, 34, 34);">retries 3：向上游服务器尝试连接的最大次数，超过此值就认为后端服务器不可用。</font>
+ <font style="color:rgb(34, 34, 34);">option abortonclose：当haproxy负载很高时，自动结束掉当前队列处理比较久的链接。</font>
+ <font style="color:rgb(34, 34, 34);">timout http-request 10s：客户端发送http请求的超时时间。</font>
+ <font style="color:rgb(34, 34, 34);">timeout queue 1m：当上游服务器在高负载响应haproxy时，会把haproxy发送来的请求放进一个队列中。timeout queue定义放入这个队列的超时时间。</font>
+ <font style="color:rgb(34, 34, 34);">timeout connect 5s：haproxy与后端服务器连接超时时间，如果在同一个局域网可设置较小的时间。</font>
+ <font style="color:rgb(34, 34, 34);">timeout client 1m：定义客户端与haproxy连接后，数据传输完毕，不再有数据传输，即非活动连接的超时时间。</font>
+ <font style="color:rgb(34, 34, 34);">timeout server 1m：定义haproxy与上游服务器非活动连接的超时时间。</font>
+ <font style="color:rgb(34, 34, 34);">timeout http-keep-alive 10s：设置新的http请求连接建立的最大超时时间，时间较短时可以尽快释放出资源，节约资源。</font>
+ <font style="color:rgb(34, 34, 34);">timeout check 10s：健康检测的时间的最大超时时间。</font>
+ <font style="color:rgb(34, 34, 34);">maxconn 3000：最大并发连接数。</font>
+ <font style="color:rgb(34, 34, 34);">contimeout 5000：设置成功连接到一台服务器的最长等待时间，默认单位是毫秒，新版本的haproxy使用timeout connect替代，该参数向后兼容。</font>
+ <font style="color:rgb(34, 34, 34);">clitimeout 3000：设置连接客户端发送数据时的成功连接最长等待时间，默认单位是毫秒，新版本haproxy使用timeout client替代。该参数向后兼容。</font>
+ <font style="color:rgb(34, 34, 34);">srvtimeout 3000：设置服务器端回应客户度数据发送的最长等待时间，默认单位是毫秒，新版本haproxy使用timeout server替代。该参数向后兼容。</font>

## _**<font style="color:rgb(51, 51, 51);">6</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">5</font>**_**<font style="color:rgb(34, 34, 34) !important;">frontend配置</font>**
`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">frontend</font>**`<font style="color:rgb(34, 34, 34);">是在haproxy 1.3版本以后才引入的一个组件，同时引入的还有</font>`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">backend</font>**`<font style="color:rgb(34, 34, 34);">组件。通过引入这些组件，在很大程度上简化了haproxy配置文件的复杂性。</font>`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">forntend</font>**`<font style="color:rgb(34, 34, 34);">可以根据ACL规则直接指定要使用的后端</font>`**<font style="color:rgb(216, 59, 100);background-color:rgb(249, 242, 244) !important;">backend</font>**`<font style="color:rgb(34, 34, 34);">。</font>

```plain
frontend http_80_in
     bind 0.0.0.0:80    #设置监听端口，即haproxy提供的web服务端口，和lvs的vip 类似
     mode http          #http 的7层模式
     log global         #应用全局的日志设置
     option httplog     #启用http的log
     option httpclose   #每次请求完毕后主动关闭http通道，HAproxy不支持keep-alive模式     
     option forwardfor  #如果后端服务器需要获得客户端的真实IP需要配置此参数，将可以从HttpHeader中获得客户端IP
     default_backend wwwpool   #设置请求默认转发的后端服务池
```

+ <font style="color:rgb(34, 34, 34);">frontend http_80_in：定义一个名为http_80_in的frontend。</font>
+ <font style="color:rgb(34, 34, 34);">bind 0.0.0.0:80：定义haproxy前端部分监听的端口。</font>
+ <font style="color:rgb(34, 34, 34);">mode http：定义为http模式。</font>
+ <font style="color:rgb(34, 34, 34);">log global：继承global中log的定义。</font>
+ <font style="color:rgb(34, 34, 34);">option forwardfor：使后端server获取到客户端的真实IP。</font>

## _**<font style="color:rgb(51, 51, 51);">6</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">6</font>**_**<font style="color:rgb(34, 34, 34) !important;">backend配置</font>**
<font style="color:rgb(34, 34, 34);">用来定义后端服务集群的配置，真实服务器，一个Backend对应一个或者多个实体服务器。</font>

```plain
backend wwwpool      #定义wwwpool服务器组。
  mode http           #http的7层模式
  option  redispatch
  option  abortonclose
  balance source      #负载均衡的方式，源哈希算法
  cookie  SERVERID    #允许插入serverid到cookie中，serverid后面可以定义
  option  httpchk GET /test.html   #心跳检测
  server web1 10.1.1.2:80 cookie 2 weight 3 check inter 2000 rise 2 fall 3 maxconn 8
```

## _**<font style="color:rgb(51, 51, 51);">6</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">7</font>**_**<font style="color:rgb(34, 34, 34) !important;">listen配置</font>**
<font style="color:rgb(34, 34, 34);">常常用于状态页面监控，以及后端server检查，是Fronted和backend的组合体。</font>

```plain
listen  admin_status           #Frontend和Backend的组合体,监控组的名称，按需自定义名称 
         bind 0.0.0.0:8888              #监听端口 
         mode http                      #http的7层模式 
         log 127.0.0.1 local3 err       #错误日志记录 
         stats refresh 5s               #每隔5秒自动刷新监控页面 
         stats uri /admin?stats         #监控页面的url访问路径 
         stats realm itnihao\ welcome   #监控页面的提示信息 
         stats auth admin:admin         #监控页面的用户和密码admin,可以设置多个用户名 
         stats auth admin1:admin1       #监控页面的用户和密码admin1 
         stats hide-version             #隐藏统计页面上的HAproxy版本信息  
         stats admin if TRUE            #手工启用/禁用,后端服务器(haproxy-1.4.9以后版本)
```

# _**<font style="color:rgb(51, 51, 51);">7</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">0</font>**_**<font style="color:rgb(34, 34, 34) !important;">启动haproxy</font>**
```plain
//yum方式
systemctl start haproxy

//源码方式
#通过配置文件启动
haproxy -f /etc/haproxy/haproxy.cfg
```

# _**<font style="color:rgb(51, 51, 51);">8</font>**_<font style="color:rgb(93, 105, 165);">|</font>_**<font style="color:rgb(51, 51, 51);">0</font>**_**<font style="color:rgb(34, 34, 34) !important;">启动日志</font>**
1. <font style="color:rgb(34, 34, 34);">HAproxy在默认情况不会记录日志</font>
2. <font style="color:rgb(34, 34, 34);">不仅要在haproxy.conf中配置日志输出</font>
3. <font style="color:rgb(34, 34, 34);">还需要修改系统日志的配置文件</font>

**<font style="color:rgb(34, 34, 34);">修改haproxy.conf</font>**

<font style="color:rgb(34, 34, 34);">在haproxy.conf文件中增加如下日志配置，  
</font><font style="color:rgb(34, 34, 34);">defaults下面增加日志相关的配置：</font>

```plain
defaults                      
    log global
    option httplog
    log 127.0.0.1 local7
```

<font style="color:rgb(34, 34, 34);">日志的级别为local0～local7，  
</font><font style="color:rgb(34, 34, 34);">另外16～23保留为本地使用：</font>

| <font style="color:rgb(34, 34, 34);">级别</font> | <font style="color:rgb(34, 34, 34);">代码</font> | <font style="color:rgb(34, 34, 34);">描述</font> |
| :--- | :--- | :--- |
| <font style="color:rgb(34, 34, 34);">energ</font> | <font style="color:rgb(34, 34, 34);">0</font> | <font style="color:rgb(34, 34, 34);">系统不可用</font> |
| <font style="color:rgb(34, 34, 34);">alert</font> | <font style="color:rgb(34, 34, 34);">1</font> | <font style="color:rgb(34, 34, 34);">必须马上采取行动的事件</font> |
| <font style="color:rgb(34, 34, 34);">crit</font> | <font style="color:rgb(34, 34, 34);">2</font> | <font style="color:rgb(34, 34, 34);">关键的事件</font> |
| <font style="color:rgb(34, 34, 34);">err</font> | <font style="color:rgb(34, 34, 34);">3</font> | <font style="color:rgb(34, 34, 34);">错误事件</font> |
| <font style="color:rgb(34, 34, 34);">warning</font> | <font style="color:rgb(34, 34, 34);">4</font> | <font style="color:rgb(34, 34, 34);">警告事件</font> |
| <font style="color:rgb(34, 34, 34);">notice</font> | <font style="color:rgb(34, 34, 34);">5</font> | <font style="color:rgb(34, 34, 34);">普通但重要的事件</font> |
| <font style="color:rgb(34, 34, 34);">info</font> | <font style="color:rgb(34, 34, 34);">6</font> | <font style="color:rgb(34, 34, 34);">有用的信息</font> |
| <font style="color:rgb(34, 34, 34);">debug</font> | <font style="color:rgb(34, 34, 34);">7</font> | <font style="color:rgb(34, 34, 34);">调试信息</font> |


**<font style="color:rgb(34, 34, 34);">修改系统日志配置</font>**

<font style="color:rgb(34, 34, 34);">vim /etc/rsyslog.conf  
</font><font style="color:rgb(34, 34, 34);">指定日志文件haproxy.log保存的位置，  
</font><font style="color:rgb(34, 34, 34);">haproxy.log会自动生成：</font>

```plain
$ModLoad imudp
$UDPServerRun 514
local7.* /root/haproxy/log/haproxy.log
```

<font style="color:rgb(34, 34, 34);">由于haproxy的日志是用udp传输的,所以要启用rsyslog的udp监听。</font>

**<font style="color:rgb(34, 34, 34);">配置rsyslog的主配置文件，开启远程日志</font>**

```plain
vim /etc/sysconfig/rsyslog

SYSLOGD_OPTIONS="-r -m 0 -c 2"
```

<font style="color:rgb(34, 34, 34);">参数说明：</font>

```plain
#-r 开启远程日志
#-m 0 标记时间戳。单位是分钟，为0时，表示禁用该功能
#-c 2 使用兼容模式，默认是 -c 5
```

**<font style="color:rgb(34, 34, 34);">重启rsyslog服务</font>**

```plain
systemctl restart rsyslog
```

**<font style="color:rgb(34, 34, 34);">重启haproxy服务</font>**

```plain
ps -ef | grep haproxy
kill -9 PID
haproxy -f /usr/local/haproxy/conf/haproxy.cfg
```

  


**<font style="color:rgb(65, 72, 87);background-color:rgb(248, 249, 251);">链接</font>**<font style="color:rgb(65, 72, 87);background-color:rgb(248, 249, 251);">：</font>[https://www.cnblogs.com/leixixi/p/14749322.html](https://www.cnblogs.com/leixixi/p/14749322.html)

