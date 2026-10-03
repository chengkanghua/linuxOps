# 第一章·Nginx Web快速入门-基础

## Nginx基础概述

| nginx简述 |
| :--- |

***Nginx**__**是一个开源且高性能、可靠的**__**Http Web**\_\_**服务、代理服务。***

*开源:* *直接获取源代码*

*高性能:* *支持海量并发*

*可靠:* *服务稳定*

***

| 我们为什么选择Nginx服务 |
| :--- |

***Nginx**\_\_**非常轻量***

*功能模块少* *(**源代码仅保留__http__与核心模块代码**,**其余不够核心代码会作为插件来安装**)*

*代码模块化* *(**易读，便于二次开发，对于开发人员非常友好**)*

***互联网公司都选择**\_\_**Nginx***

*1.Nginx技术成熟，具备的功能是企业最常使用而且最需要的*

*2.**适合当前主流架构趋势**,* *微服务、云架构、中间层*

*3.**统一技术栈**,* *降低维护成本*\_,\_ *降低技术更新成本。*

_**Nginx******采用****__Epool__****网络模型，****__Apache__****采用****__Select__\_\_**模型**_

*Select:* \_当用户发起一次请求，\_*select__模型就会进行一次遍历扫描，从而导致性能低下。*

*Epool:* \_当用户发起请求，\_*epool__模型会直接进行处理，效率高效，并无连接限制。*

| Nginx典型应用场景 |
| :--- |

<!-- OCR_START -->
- Nginx应用场景
- 静态服务
- 代理服务
- 安全服务
- 流行架构
- 浏览器缓存
- 协议类型
- 访问控制
- Nginx+PHP(Fastcgi_pass)LNMP
- 防资源盗用
- 正向代理
- 访问限制
- Nginx+Java(Proxy_Pass) LNMT
- 资源分类
- 反向代理
- 流量限制
- Nginx+Python(uwsgi_pass)
- 资源压缩
- 负载均衡
- 拦截攻击
- 资源缓存
- 代理缓存
- 拦截异常请求
- 跨域访问
- 动静分离
- 拦截SQL注入
<!-- OCR_END -->

***

# 静态WEB软件

\*\*nginx\
\*\*\*\*apache\
\*\*\*\*IIS\
\*\*\*\*lighttpd\
\*\*\*\*tengine\
\*\***openresty-nginx**

# **动态WEB软件**

\*\*\
\*\*\*\*Tomcat\
\*\*\*\*Resin\
\*\*\*\*weblogic\
\*\*\*\*Jboss\
\*\*

## **Nginx快速安装**

| **Nginx的安装方式** |
| :--- |

**1.源码编译=>Nginx (1.版本随意 2.安装复杂 3.升级繁琐 4.规范 5.便于管理)**

**2.epel仓库=>Nginx (1.版本较低 2.安装简单 3.配置不易读)**

**3.官方仓库=>Nginx (1.版本较新 2.安装简单 3.配置易读)**

***

| **安装Nginx依赖** |
| :--- |

```bash
[root@web ~]# yum install -y gcc gcc-c++ autoconf pcre pcre-devel make automake wget httpd-tools vim tree
```

***

| **配置官方yum源** |
| :--- |

```bash
[root@web ~]# vim /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
```

***

| **安装Nginx服务** |
| :--- |

```bash
[root@web ~]# yum install nginx -y
```

***

| **启动并设置开机自启** |
| :--- |

```bash
[root@web ~]# systemctl enable nginx
[root@web ~]# systemctl start nginx
```

***

| **验证是否启动成功** |
| :--- |

**1.端口检测**

```bash
[root@zls ~]# netstat -lntup|grep 80
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      1221/nginx: master
```

**2.检测进程**

```bash
[root@zls ~]# ps -ef|grep nginx
root       1221      1  0 16:54 ?        00:00:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
nginx      1222   1221  0 16:54 ?        00:00:00 nginx: worker process
```

**3.打开浏览器检测**

**打开浏览器访问：**[**http://10.0.0.101**](http://10.0.0.101/)

\*\*\*\*

**4.检查nginx的软件版本**

```bash
[root@zls ~]# nginx -v
nginx version: nginx/1.16.0
```

**5.检查nginx的编译参数**

```bash
[root@zls ~]# nginx -V
nginx version: nginx/1.16.0
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC)
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
```

***

| **Nginx启停** |
| :--- |

**1.Nginx启动**

```bash
[root@zls ~]# /usr/sbin/nginx
[root@zls ~]# systemctl start nginx
```

**2.Nginx停止**

```bash
[root@zls ~]# /usr/sbin/nginx -s stop
[root@zls ~]# systemctl stop nginx
```

**3.Nginx重启**

```bash
[root@zls ~]# systemctl restart nginx
```

**4.Nginx重载**

```bash
[root@zls ~]# /usr/sbin/nginx -s reload
[root@zls ~]# systemctl reload nginx
```

***

| **Nginx相关文件介绍** |
| :--- |

**为了让大家更清晰的了解**`**Nginx**`**软件的全貌，可使用**`**rpm -ql nginx**`**查看整体的目录结构及对应的功能，如下表格整理了**`**Nginx**`**比较重要的配置文件**

***1.Nginx主配置文件***

| **路径** | **类型** | **作用** |
| :--- | :--- | :--- |
| **/etc/nginx/nginx.conf** | **配置文件** | **nginx主配置文件** |
| **/etc/nginx/conf.d/default.conf** | **配置文件** | **默认网站配置文件** |

***2.Nginx代理相关参数文件***

| **路径** | **类型** | **作用** |
| :--- | :--- | :--- |
| **/etc/nginx/fastcgi_params** | **配置文件** | **Fastcgi代理配置文件** |
| **/etc/nginx/scgi_params** | **配置文件** | **scgi代理配置文件** |
| **/etc/nginx/uwsgi_params** | **配置文件** | **uwsgi代理配置文件** |

***3.Nginx编码相关配置文件***

| **路径** | **类型** | **作用** |
| :--- | :--- | :--- |
| **/etc/nginx/win-utf** | **配置文件** | **Nginx编码转换映射文件** |
| **/etc/nginx/koi-utf** | **配置文件** | **Nginx编码转换映射文件** |
| **/etc/nginx/koi-win** | **配置文件** | **Nginx编码转换映射文件** |
| **/etc/nginx/mime.types** | **配置文件** | **Content-Type与扩展名** |

***4.Nginx管理相关命令***

| **路径** | **类型** | **作用** |
| :--- | :--- | :--- |
| **/usr/sbin/nginx** | **命令** | **Nginx命令行管理终端工具** |
| **/usr/sbin/nginx-debug** | **命令** | **Nginx命令行与终端调试工具** |

***4.Nginx日志相关目录与文件***

| **路径** | **类型** | **作用** |
| :--- | :--- | :--- |
| **/var/log/nginx** | **目录** | **Nginx默认存放日志目录** |
| **/etc/logrotate.d/nginx** | **配置文件** | **Nginx默认的日志切割** |

***

| **Nginx默认配置文件** |
| :--- |

**Nginx主配置文件**`**/etc/nginx/nginx.conf**`**是一个纯文本类型的文件，整个配置文件是以区块的形式组织的。一般，每个区块以一对大括号**`**{}**`**来表示开始与结束。**

**Nginx主配置文件整体分为三块进行学习，分别是**

`**CoreModule(核心模块)**`**，**

`**EventModule(事件驱动模块)**`**，**

`**HttpCoreModule(http内核模块)**`

`**CoreModule**`***核心模块***

```bash
user www;                       #Nginx进程所使用的用户
worker_processes 1;             #Nginx运行的work进程数量(建议与CPU数量一致或auto)
error_log /log/nginx/error.log  #Nginx错误日志存放路径
pid /var/run/nginx.pid          #Nginx服务运行后产生的pid进程号
```

`**EventModule(事件驱动模块)**`

```bash
events {            
    worker_connections 25535;   #每个worker进程支持的最大连接数
    use epoll;                  #事件驱动模型, epoll默认
}
```

`**HttpCoreModule(http内核模块)**`

```bash
#http层开始
http {
#包含资源类型文件
    include       /etc/nginx/mime.types;
#默认以下载方式传输给浏览器(前提是该资源在mime.types中无法找到)
    default_type  application/octet-stream;
#日志格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
#访问日志
    access_log  /var/log/nginx/access.log  main;
#高效文件传输
    sendfile        on;
#搭配sendfile使用
    #tcp_nopush     on;
#长连接超时时间
    keepalive_timeout  65;
#是否开启压缩
    #gzip  on;
    #使用Server配置网站, 每个Server{}代表一个网站(简称虚拟主机)
    'server' {
        listen       80;            #监听端口, 默认80
        server_name  driverzeng.com;    #提供的域名
        access_log  access.log;     #该网站的访问日志
        #控制网站访问路径
        'location' / {
            root   /usr/share/nginx/html;   #存放网站源代码的位置
            index  index.html index.htm;    #默认返回网站的文件
        }
    }
    ...
    #第二个虚拟主机配置
    'server' {
    ...
    }
    include /etc/nginx/conf.d/*.conf;  #包含/etc/nginx/conf.d/目录下所有以.conf结尾的文件
} #http结束层
```

`**http server location**`**扩展了解项**

> \*\* \*\*
>
> ***http{}**__**层下允许有多个**__**Server{}**__**层，一个**__**Server{}**__**层下又允许有多个**__**Location***
>
> ***http{}***\*\* \*\****标签主要用来解决用户的请求与响应。***
>
> ***server{}***\*\* \*\****标签主要用来响应具体的某一个网站。***
>
> ***location{}***\*\* \*\****标签主要用于匹配网站具体**__**URL**__**路径。***

## **Nginx网站配置**

**1.新增**`**nginx**`**配置文件**

```bash
[root@web01 conf.d]# cat /etc/nginx/conf.d/game.conf 
server {
    listen 80;
    server_name game.driverzeng.com;
 
    location / {
        root /code;
        index index.html;
    }
}
```

**2.放置游戏源代码文件至nginx配置文件root指定的目录**

```bash
[root@web01 conf.d]# mkdir /code && cd /code
[root@web01 code]# rz  html5.zip
[root@web01 code]# unzip html5.zip
[root@web01 code]# ls
ceshi  game  html5.zip  img  index.html  readme.txt
```

**3.检查**`**nginx**`**的语法是否存在错误**

```bash
[root@web01 code]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

**4.重载**`**Nginx [reload|restart]**`

```bash
[root@web01 code]# systemctl reload nginx
```

**5.设置hosts**

```bash
MacBook-Pro:~ driverzeng$ sudo vim /etc/hosts
10.0.0.101 game.driverzeng.com
```

**6.检测是否设置成功**

```bash
MacBook-Pro:~ driverzeng$ ping game.driverzeng.com
PING game.driverzeng.com (10.0.0.101): 56 data bytes
64 bytes from 10.0.0.101: icmp_seq=0 ttl=64 time=0.267 ms
64 bytes from 10.0.0.101: icmp_seq=1 ttl=64 time=0.450 ms
64 bytes from 10.0.0.101: icmp_seq=2 ttl=64 time=0.508 ms
64 bytes from 10.0.0.101: icmp_seq=3 ttl=64 time=0.464 ms

```

**7.浏览器检测**

**打开浏览器访问：**[**http://game.driverzeng.com**](http://game.driverzeng.com/)

<!-- OCR_START -->
- 微信html5游戏平台
- →C不安全|game.driverzeng.com
- 无痕模式
- TTTSzabbix-api
- 千万人在玩的微信小游戏
- 9miao.com
- 国内最大开源微信开发者社区
- 游戏免安装，开始即玩！关注微信公众平台有惊喜！
- 超级读心术，超准！
- 高智商手机魔术，敢挑战吗？
- 开始玩
- 热度：496942人在玩过。
- 激光防线！
- 激光防线保卫家园。
- 热度：496907人在玩过。
- 超级足球！
- 微信足球游戏。
- 热度：495947人在玩过。
- 疯狂浇痒痒！
- 看看你是哪种味道。
- 热度：488107人在玩过。
- 哪种味道！
- 热度：496107人在玩过。
- 红还是绿！
- 一款让人发狂的颜色游戏。
- 贱人配对！
- 贱人贱人配一对。
<!-- OCR_END -->

\*\*\*\*

## **Nginx虚拟主机**

***通常在企业中可能会有很多业务系统，那么多套业务服务如何使用***`_**Nginx**_`***配置?***

<!-- OCR_START -->
- 多套业务服务如何配置？
- Nginx1
- A业务服务
- Nginx2
- B业务服务
- Nginx3
- C业务服务
<!-- OCR_END -->

\*\*\*\*

_**如果使用如上方式部署，则需要多台服务器配置******Nginx****__，但如果使用虚拟主机方式，则在同一个__****Nginx****__上运行多套单独服务，这些服务是相互独立的。简单来说，看似多套业务系统，实则可以运行在一台__****Nginx****__服务上___

*\*\*\*\**

<!-- OCR_START -->
- Nginx虚拟主机配置方式
- 虚拟主机A
- A业务服务
- 虚拟主机B
- B业务服务
- 虚拟主机C
- C业务服务
- Nginx
- nttps:7/www.ariverzeng.com
<!-- OCR_END -->

\*\*\*\*

***Nginx配置虚拟主机有如下三种方式：***

***方式一、基于主机多**__**IP**__**方式***

***方式二、基于端口的配置方式***

***方式三、基于多个**__**hosts**__**名称方式(多域名方式)***

***

| **基于多IP方式** |
| :--- |

<!-- OCR_START -->
- 基于多IP的虚拟主机方式
- http://10.0.0.10
- IP1:10.0.0.10
- 虚拟主机A
- http://10.0.0.11
- IP2:10.0.0.11
- 虚拟主机B
- http://10.0.0.12
- IP3:10.0.0.12
- 虚拟主机C
- Nginx
<!-- OCR_END -->

\*\*\*\*

**那么基于&#x591A;****IP****&#x7684;方式，有如下两种方式：**

<!-- OCR_START -->
- 方式一、多网卡多IP的方式
- 方式二、
- 单网卡多IP的方式
- 网卡1
- IP1  (10.0.0.10)
- IP2 (10.0.0.11)
- 网卡2
<!-- OCR_END -->

\*\*\*\*

***1).**__**配置多网卡**__**多IP的方式***

```bash
server {
    ...
    listen 10.0.0.10:80;
    ...
}
 
server {
    ...
    listen 10.0.0.11:80;
    ...
}
```

***2).**__**配置单网卡**__**多IP的方式***

```bash
#添加一个IP
[root@web01 ~]# ip addr add 10.0.0.11/24 dev eth0
 
# 虚拟机配置方案
[root@web01 ~]# cat /etc/nginx/conf.d/addr1.conf
server {
    ...
    listen 10.0.0.10:80;
    ...
}
 
[root@web01 ~]# cat /etc/nginx/conf.d/addr2.conf
server {
    ...
    listen 10.0.0.11:80;
    ...
}
```

***

| **基于多端口方式** |
| :--- |

<!-- OCR_START -->
- 基于多端口的方式
- http://10.0.0.10:80
- Listen:80
- 虚拟主机A
- http://10.0.0.10:81
- Listen:81
- 虚拟主机B
- http://10.0.0.10:82
- Listen:82
- 虚拟主机C
- Nainx
- https://www.driverze
<!-- OCR_END -->

\*\*\*\*

***Nginx多端口虚拟主机方式，具体配置如下***

```bash
#仅修改listen监听端口即可, 但不能和系统端口出现冲突
 
[root@web01 ~]# cat /etc/nginx/conf.d/port1.conf
server {
    ...
    listen 80;
    ...
}
 
[root@web01 ~]# cat /etc/nginx/conf.d/port2.conf
server {
    ...
    listen 81;
    ...
}
 
[root@web01 ~]# cat /etc/nginx/conf.d/port3.conf
server {
    ...
    listen 82;
    ...
}
```

***

| **基于多域名方式** |
| :--- |

<!-- OCR_START -->
- 基于host名称的虚拟主机方式
- http://1.oldboyedu.com
- 1.oldboyedu.com
- 虚拟主机A
- http://2.oldboyedu.com
- 2.oldboyedu.com
- 虚拟主机B
- http://3.oldboyedu.com
- 3.oldboyedu.com
- 虚拟主机C
- Nginx
- https://www.driverzen
<!-- OCR_END -->

\*\*\*\*

***1.创建对应的**\_\_**web站点目录以及程序代码***

```bash
[root@web01 ~]# mkdir /soft/code/{server1,server2}
[root@web01 ~]# echo "server1" > /code/server1/index.html
[root@web01 ~]# echo "server2" > /code/server2/index.html
```

***2.配置不同域名的虚拟主机***

```bash
[root@web02 ~]# cat /etc/nginx/conf.d/server1.conf
server {
    listen       80;
    server_name  1.oldboyedu.com;
    root /code/server1;
    index index.html;
    ...
}
[root@web01 ~]# cat /etc/nginx/conf.d/server2.conf
server {
    ...
    listen       80;
    server_name  2.oldboyedu.com;
    root /code/server2;
    index index.html;
}
```

## **Nginx日志管理**

***Nginx有非常灵活的日志记录模式，每个级别的配置可以有各自独立的访问日志。日志格式通过log_format命令定义格式。***

***

| **log_format详解** |
| :--- |

**在nginx默认的配置文件中，log_format已经将日志格式定死，但是我们可不可以修改呢？**

**1.**`**log_format**`**的作用是定义日志格式语法**

```bash
# 配置语法: 包括: error.log access.log
Syntax: log_format name [escape=default|json] string ...;
Default: log_format combined "...";
Context: http
```

**2.nginx默认日志格式语法如下：**

```bash
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
                      
```

**3.**`**Nginx**`**日志格式允许包含的内置变量**

```bash
$remote_addr        # 记录客户端IP地址
$remote_user        # 记录客户端用户名
$time_local         # 记录通用的本地时间
$time_iso8601       # 记录ISO8601标准格式下的本地时间
$request            # 记录请求的方法以及请求的http协议
$status             # 记录请求状态码(用于定位错误信息)
$body_bytes_sent    # 发送给客户端的资源字节数，不包括响应头的大小
$bytes_sent         # 发送给客户端的总字节数
$msec               # 日志写入时间。单位为秒，精度是毫秒。
$http_referer       # 记录从哪个页面链接访问过来的
$http_user_agent    # 记录客户端浏览器相关信息
$http_x_forwarded_for #记录客户端IP地址
$request_length     # 请求的长度（包括请求行， 请求头和请求正文）。
$request_time       # 请求花费的时间，单位为秒，精度毫秒
# 注:如果Nginx位于负载均衡器，nginx反向代理之后， web服务器无法直接获取到客 户端真实的IP地址。
# $remote_addr获取的是反向代理的IP地址。 反向代理服务器在转发请求的http头信息中，
# 增加X-Forwarded-For信息，用来记录客户端IP地址和客户端请求的服务器地址。
```

**4.**`**access_log**`**日志配置语法**

```bash
Syntax: access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];
access_log off;
Default: access_log logs/access.log combined;
Context: http, server, location, if in location, limit_except
```

**5.**`**Nginx Access**`**日志配置实践**

```bash
server {
    listen 80;
    server_name code.oldboy.com;
    #将当前的server网站的访问日志记录至对应的目录，使用main格式
    access_log /var/log/nginx/code.oldboy.com.log main;
    location / {
        root /code;
    }
    #当有人请求改favicon.ico时，不记录日志
    location /favicon.ico {
        access_log off;
        return 200;
    }
}
```

***

| **nginx日志切割** |
| :--- |

**使用**`**logrotate**`**切割日志**

```bash
[root@nginx conf.d]# cat /etc/logrotate.d/nginx
/var/log/nginx/*.log {
        daily                   # 每天切割日志
        missingok               # 日志丢失忽略
        rotate 52               # 日志保留52天
        compress                # 日志文件压缩
        delaycompress           # 延迟压缩日志
        notifempty              # 不切割空文件
        create 640 nginx adm    # 日志文件权限
        sharedscripts
        postrotate      # 切割日志执行的命令
                if [ -f /var/run/nginx.pid ]; then
                        kill -USR1 `cat /var/run/nginx.pid`
                fi
        endscript
}
```

**日志切割后的效果**

```bash
[root@oldboy ~]# ll /var/log/nginx/
total 4044
-rw-r----- 1 www adm  54438 Oct 12 03:28 access.log-20181012.gz
-rw-r----- 1 www adm  28657 Oct 13 03:48 access.log-20181013.gz
-rw-r----- 1 www adm  10135 Oct 12 03:28 error.log-20181130.gz
-rw-r----- 1 www adm   7452 Oct 13 03:48 error.log-20181201.gz

```

> 更新: 2024-09-22 20:52:17  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/nbn3x5>