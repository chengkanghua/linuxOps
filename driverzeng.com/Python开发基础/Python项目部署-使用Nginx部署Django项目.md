# Python项目部署-使用Nginx部署Django项目

* [nginx介绍及部署](https://blog.driverzeng.com/zenglaoshi/1226.html#toc_0)
* [nginx部署路飞学城代码](https://blog.driverzeng.com/zenglaoshi/1226.html#toc_1)

>  
>
> -曾老湿, 江湖人称曾老大。
>
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

## nginx介绍及部署

想必我们大多数人都是通过访问网站而开始接触互联网的吧。我们平时访问的网站服务 就是 Web 网络服务，一般是指允许用户通过浏览器访问到互联网中各种资源的服务。

Web 网络服务是一种被动访问的服务程序，即只有接收到互联网中其他主机发出的 请求后才会响应，最终用于提供服务程序的 Web 服务器会通过 HTTP(超文本传输协议)或 HTTPS(安全超文本传输协议)把请求的内容传送给用户。

目前能够提供 Web 网络服务的程序有 IIS、Nginx 和 Apache 等。其中，IIS(Internet Information Services，互联网信息服务)是 Windows 系统中默认的 Web 服务程序

2004 年 10 月 4 日，为俄罗斯知名门户站点而开发的 Web 服务程序 Nginx 横空出世。 Nginx 程序作为一款轻量级的网站服务软件，因其稳定性和丰富的功能而快速占领服务器市 场，但 Nginx 最被认可的还当是系统资源消耗低且并发能力强，因此得到了国内诸如新浪、 网易、腾讯等门户站的青睐。

<!-- OCR_START -->
- 向服务器发出Web请求
- 查询页面
- 互联网
- 浏览器
- 将文档传送给客户浏览器
- 网站服务器
<!-- OCR_END -->

￼

web服务器（nginx）：接收HTTP请求（例如www.pythonav.cn/xiaocang.jpg）并返回数据

web框架（django，flask）：开发web应用程序，处理接收到的数据。

***

| nginx介绍 |
| :--- |

1）nginx是一个开源的，支持高性能，高并发的www服务和代理服务软件。它是一个俄罗斯人lgor sysoev开发的，作者将源代码开源出来供全球使用。

2）nginx比它大哥apache性能改进许多，nginx占用的系统资源更少，支持更高的并发连接，有更高的访问效率。

3）nginx不但是一个优秀的web服务软件，还可以作为反向代理，负载均衡，以及缓存服务使用。

4）安装更为简单，方便，灵活。

5）支持高并发，能支持几万并发连接

6）资源消耗少，在3万并发连接下开启10个nginx线程消耗的内存不到200M

7）可以做http反向代理和负载均衡

8）支持异步网络i/o事件模型epoll

***

| 第三方产品Tengine |
| :--- |

Tengine是由淘宝网发起的Web服务器项目。它在Nginx的基础上，针对大访问量网站的需求，添加了很多高级功能和特性。Tengine的性能和稳定性已经在大型的网站如淘宝网，天猫商城等得到了很好的检验。它的最终目标是打造一个高效、稳定、安全、易用的Web平台。

***

| nginx配置安装 |
| :--- |

同样，nginx也有很多的安装方式：

1）源码安装（运维偏向：规范，便于配置管理）

2）yum，rpm安装（为了效率可以选用）

nginx官网：<http://nginx.org/>

```plain
#安装依赖包
[root@elkstack01 ~]# yum install gcc gcc-c++ pcre-devel patch libffi-devel python-devel  zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel openssl-devel -y
#依赖简单介绍
一. gcc 安装
安装 nginx 需要先将官网下载的源码进行编译，编译依赖 gcc 环境，如果没有 gcc 环境，则需要安装：
yum install gcc-c++
二. PCRE pcre-devel 安装
PCRE(Perl Compatible Regular Expressions) 是一个Perl库，包括 perl 兼容的正则表达式库。nginx 的 http 模块使用 pcre 来解析正则表达式，所以需要在 linux 上安装 pcre 库，pcre-devel 是使用 pcre 开发的一个二次开发库。nginx也需要此库。命令：
yum install -y pcre-devel
三. zlib 安装
zlib 库提供了很多种压缩和解压缩的方式， nginx 使用 zlib 对 http 包的内容进行 gzip ，所以需要在 Centos 上安装 zlib 库。
yum install -y zlib-devel
四. OpenSSL 安装
OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及 SSL 协议，并提供丰富的应用程序供测试或其它目的使用。
nginx 不仅支持 http 协议，还支持 https（即在ssl协议上传输http），所以需要在 Centos 安装 OpenSSL 库。
yum install -y openssl-devel
#下载nginx源码包
[root@elkstack01 ~]# wget -c https://nginx.org/download/nginx-1.10.3.tar.gz
#创建nginx用户
[root@elkstack01 ~]# useradd nginx -s /sbin/nologin -M
#解压
[root@elkstack01 ~]# tar xf nginx-1.10.3.tar.gz
#进入nginx安装目录
[root@elkstack01 ~]# cd nginx-1.10.3/
#生成编译文件，开启状态监测模块，开启ssl，开启4层代理模块
[root@elkstack01 nginx-1.10.3]# ./configure  --user=nginx --group=nginx --prefix=/usr/local/nginx-1.10.3/ --with-http_stub_status_module  --with-http_ssl_module --with-stream
#编译
[root@elkstack01 nginx-1.10.3]# make
#安装
[root@elkstack01 nginx-1.10.3]# make install
#执行成功后我们可以看一下，/usr/local目录下是否有nginx
[root@elkstack01 nginx-1.10.3]# ll /usr/local/
总用量 60
drwxr-xr-x. 2 root root 4096 3月   5 12:21 bin
drwxr-xr-x  8 root root 4096 4月   8 12:51 elasticsearch-head
drwxr-xr-x. 2 root root 4096 9月  23 2011 etc
drwxr-xr-x. 2 root root 4096 9月  23 2011 games
drwxr-xr-x. 3 root root 4096 3月   5 12:21 include
lrwxrwxrwx  1 root root   21 3月   5 12:02 jdk1.8 -> /usr/local/jdk1.8_121
drwxr-xr-x  8 uucp  143 4096 12月 13 2016 jdk1.8_121
drwxr-xr-x. 3 root root 4096 3月   5 12:21 lib
drwxr-xr-x. 2 root root 4096 9月  23 2011 lib64
drwxr-xr-x. 2 root root 4096 9月  23 2011 libexec
drwxr-xr-x  3 root root 4096 3月   5 12:21 n
drwxr-xr-x  6 root root 4096 4月  12 23:06 nginx-1.10.3
drwxr-xr-x  6 root root 4096 4月   8 17:13 python3.6.4
drwxr-xr-x. 2 root root 4096 9月  23 2011 sbin
drwxr-xr-x. 7 root root 4096 3月   5 12:21 share
drwxr-xr-x. 2 root root 4096 9月  23 2011 src
#做软链接
[root@elkstack01 nginx-1.10.3]# ln -s /usr/local/nginx-1.10.3 /usr/local/nginx
#进入nginx程序目录
[root@elkstack01 nginx-1.10.3]# cd /usr/local/nginx-1.10.3/
#查看nginx的目录结构
[root@elkstack01 nginx-1.10.3]# ll
总用量 16
#存放nginx所有配置文件的目录,主要nginx.conf
drwxr-xr-x 2 root root 4096 4月  12 23:06 conf
#存放nginx默认站点的目录，如index.html、error.html等
drwxr-xr-x 2 root root 4096 4月  12 23:06 html
#存放nginx默认日志的目录，如error.log access.log
drwxr-xr-x 2 root root 4096 4月  12 23:06 logs
#存放nginx程序命令的目录
drwxr-xr-x 2 root root 4096 4月  12 23:06 sbin
```

***

| nginx配置文件介绍 |
| :--- |

Nginx主配置文件`/etc/nginx/nginx.conf`是一个纯文本类型的文件，整个配置文件是以区块的形式组织的。一般，每个区块以一对大括号`{}`来表示开始与结束，每一行使用`;`表示结束。

```plain
#CoreModule核心模块
user nginx;                       #Nginx进程所使用的用户
worker_processes 1;             #Nginx运行的work进程数量(建议与CPU数量一致或auto)
error_log /log/nginx/error.log  #Nginx错误日志存放路径
pid /var/run/nginx.pid          #Nginx服务运行后产生的pid进程号
#events事件模块
events {            
    worker_connections  #每个worker进程支持的最大连接数
    use epool;          #事件驱动模型, epoll默认
}
#http内核模块
#公共的配置定义在http{}
http {  //http层开始
...  
#使用Server配置网站, 每个Server{}代表一个网站(简称虚拟主机)
    'server' {
        listen       80;        //监听端口, 默认80
        server_name  localhost; //提供服务的域名或主机名
        access_log host.access.log  //访问日志
        //控制网站访问路径
        'location' / {
            root   /usr/share/nginx/html;   //存放网站代码路径
            index  index.html index.htm;    //服务器返回的默认页面文件
        }
        //指定错误代码, 统一定义错误页面, 错误代码重定向到新的Locaiton
        error_page   500 502 503 504  /50x.html;
    }
    ...
    //第二个虚拟主机配置
    'server' {
    ...
    }
    include /etc/nginx/conf.d/*.conf;  //包含/etc/nginx/conf.d/目录下所有以.conf结尾的文件
}   //http层结束
```

***

| 部署一个简单的nginx站点 |
| :--- |

```plain
#简化nginx配置文件
[root@elkstack01 conf]# grep -Ev "#|^$" /usr/local/nginx/conf/nginx.conf.default > /usr/local/nginx/conf/nginx.conf
#编辑nginx页面
[root@elkstack01 conf]# echo 'zls_nginx_page' > /usr/local/nginx/html/index.html
#检测nginx语法
[root@elkstack01 conf]# /usr/local/nginx/sbin/nginx -t
nginx: the configuration file /usr/local/nginx-1.10.3//conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.10.3//conf/nginx.conf test is successful
#启动nginx
[root@elkstack01 conf]# /usr/local/nginx/sbin/nginx
#检测端口
[root@elkstack01 conf]# netstat -lntup|grep 80
tcp        0      0 0.0.0.0:80                  0.0.0.0:*                   LISTEN      39105/nginx
#检测进程
[root@elkstack01 conf]# ps -ef|grep nginx
root      39105      1  0 23:19 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nginx     39106  39105  0 23:19 ?        00:00:00 nginx: worker process
```

打开浏览器，访问：<http://10.0.0.51/>

<!-- OCR_START -->
- C不安全|10.0.0.51
- 应用TTTS
- zls_nginx_page
<!-- OCR_END -->

￼

***

| nginx多个虚拟主机 |
| :--- |

如果每台linux服务器只运行了一个小网站，那么人气低，流量小的草根站长需要承担高额的服务器租赁费，也造成了硬件资源浪费。

虚拟主机就是将一台服务器分割成多个“虚拟服务器”，每个站点使用各自的硬盘空间，由于省资源，省钱，众多网站都使用虚拟主机来部署网站。

1）虚拟主机的概念就是在web服务里的一个独立的网站站点，这个站点对应独立的域名（IP），具有独立的程序和资源目录，可以独立的对外提供服务。

2）这个独立的站点配置是在nginx.conf中使用server{}代码块标签来表示一个虚拟主机。

3）Nginx支持多个server{}标签，即支持多个虚拟主机站点。

**虚拟主机类型**

基于域名的虚拟主机

通过不同的域名区分不同的虚拟主机，是企业应用最广的虚拟主机。

基于端口的虚拟主机

通过不同的端口来区分不同的虚拟主机，一般用作企业内部网站，不对外直接提供服务的后台，例如blog.driverzeng.com:8888

基于IP的虚拟主机

通过不同的IP区分不同的虚拟主机，此类比较少见，一般业务需要多IP的常见都会在负载均衡中绑定VIP

nginx可以自动识别用户请求的域名，根据不同的域名请求服务器传输不同的内容，只需要保证服务器上有一个可用的ip地址，配置好dns解析服务。

/etc/hosts是linux系统中本地dns解析的配置文件，同样可以达到域名访问效果

**配置虚拟主机**

```plain
#编辑nginx配置文件
[root@elkstack01 conf]# vim /usr/local/nginx/conf/nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
    server {
        listen       80;
        server_name  blog.driverzeng.com;
        location / {
            root   /code/drz;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
#创建站点目录
[root@elkstack01 conf]# mkdir -p /code/drz
#编辑blog页面
[root@elkstack01 conf]# echo '<font color="red">zls blog page</font>' > /code/drz/index.html
#检测nginx语法
[root@elkstack01 conf]# /usr/local/nginx/sbin/nginx -t
nginx: the configuration file /usr/local/nginx-1.10.3//conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.10.3//conf/nginx.conf test is successful
#重新加载nginx（不间断业务）
[root@elkstack01 conf]# /usr/local/nginx/sbin/nginx -s reload
#绑定hosts(MAC)
MacBook-Pro:~ driverzeng$ sudo vim /etc/hosts
10.0.0.51 blog.driverzeng.com
#绑定hosts(Windows)
windows+r 打开运行 输入：drivers，进入etc目录里面有一个hosts文件，在文件最后一行添加
10.0.0.51 blog.driverzeng.com
```

打开浏览器，访问：<https://blog.driverzeng.com/>

<!-- OCR_START -->
C不安全|blog.driverzeng.com
应用TTTS
zlsblogpage
<!-- OCR_END -->

￼

***

| 找不到页面优化 |
| :--- |

在网站运行过程中，可能因为页面不存在等原因，导致网站无法正常响应请求，此时web服务会返回系统的错误码，但是默认的错误页面很不友好，不仅很丑，还暴露了nginx的版本信息。

<!-- OCR_START -->
- C不安全|blog.driverzeng.com/aaa
- 应用TTTS
- 404NotFound
- nginx/1.10.3
<!-- OCR_END -->

￼

```plain
#将页面移走
[root@elkstack01 conf]# mv /code/drz/index.html /tmp/
```

<!-- OCR_START -->
- →C不安全|blog.driverzeng.com
- 应用TTTS
- 403Forbidden
- nginx/1.10.3
<!-- OCR_END -->

￼

```plain
#在虚拟主机中 加一行配置
[root@elkstack01 conf]# vim /usr/local/nginx/conf/nginx.conf
    server {
        listen       80;
        server_name  blog.driverzeng.com;
        location / {
            root   /code/drz;
            index  index.html index.htm;
        }
        error_page 400 403 404 405 /40x.html;
        }
    }
#检测语法
[root@elkstack01 conf]# /usr/local/nginx/sbin/nginx -t
nginx: the configuration file /usr/local/nginx-1.10.3//conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.10.3//conf/nginx.conf test is successful
#重新加载
[root@elkstack01 conf]# /usr/local/nginx/sbin/nginx -s reload
#编辑nginx错误页面
[root@elkstack01 conf]# vim /code/drz/40x.html
<img style='width:100%;height:100%;' src=https://blog.driverzeng.com/zenglaoshi/404_page.png>
```

再次打开浏览器，访问一个不存在的页面：<https://blog.driverzeng.com/aaa>

<!-- OCR_START -->
应用
Oops!Thepageyourequestedwasnotfound!
HomeHelp
Whatwouldyouliketodonow?
<!-- OCR_END -->

￼

## nginx部署路飞学城代码

既然要部署项目，那我们必须有代码，光是一个nginx肯定是没有用的。

***

| 代码下载 |
| :--- |

路飞学城django代码：<https://files.cnblogs.com/files/pyyu/luffy_boy.zip>

vue代码：<https://files.cnblogs.com/files/pyyu/07-luffy_project_01.zip>

```plain
#将代码下载到服务器上
[root@elkstack01 ~]# wget https://files.cnblogs.com/files/pyyu/luffy_boy.zip
[root@elkstack01 ~]# wget https://files.cnblogs.com/files/pyyu/07-luffy_project_01.zip
```

***

| 部署前端VUE |
| :--- |

要在服务器上，编译打包vue项目，必须得有node环境

```plain
#下载node二进制包，此包已经包含node，不需要再编译
[root@elkstack01 ~]# wget https://nodejs.org/download/release/v8.6.0/node-v8.6.0-linux-x64.tar.gz
#解压
[root@elkstack01 ~]# tar -xf node-v8.6.0-linux-x64.tar.gz
#因为是二进制，所以解压开可以直接使用，移动到安装目录
[root@elkstack01 ~]# mv node-v8.6.0-linux-x64 /usr/local/node-8.6.0
#做软链接
[root@elkstack01 ~]# ln -s /usr/local/node-8.6.0 /usr/local/node
#进入node文件夹
[root@elkstack01 ~]# cd /usr/local/node
#查看目录内容
[root@elkstack01 node]# ll
总用量 152
drwxrwxr-x 2 nginx nginx  4096 9月  27 2017 bin
-rw-rw-r-- 1 nginx nginx 53120 9月  27 2017 CHANGELOG.md
drwxrwxr-x 3 nginx nginx  4096 9月  27 2017 include
drwxrwxr-x 3 nginx nginx  4096 9月  27 2017 lib
-rw-rw-r-- 1 nginx nginx 56524 9月  27 2017 LICENSE
-rw-rw-r-- 1 nginx nginx 25984 9月  27 2017 README.md
drwxrwxr-x 5 nginx nginx  4096 9月  27 2017 share
#查看bin目录下内容
[root@elkstack01 node]# ll bin/
总用量 36264
-rwxrwxr-x 1 nginx nginx 37133148 9月  27 2017 node
lrwxrwxrwx 1 nginx nginx       38 4月  12 23:54 npm -> ../lib/node_modules/npm/bin/npm-cli.js
lrwxrwxrwx 1 nginx nginx       38 4月  12 23:54 npx -> ../lib/node_modules/npm/bin/npx-cli.js
#我们需要将bin目录下的命令添加环境变量
[root@elkstack01 node]# vim /etc/profile.d/node.sh
export PATH="/usr/local/node/bin:$PATH"
#重新加载环境变量
[root@elkstack01 node]# source /etc/profile
#测试是否加载成功
[root@elkstack01 node]# node -v
v8.6.0
[root@elkstack01 node]# npm -v
5.3.0
```

node环境有了，安装node模块，以及打包node项目

```plain
#解压VUE代码
[root@elkstack01 ~]# unzip 07-luffy_project_01.zip
#进入vue源码目录
[root@elkstack01 ~]# cd 07-luffy_project_01/
#安装vue模块，默认去装package.json的模块内容，如果出现模块安装失败，手动再装
[root@elkstack01 07-luffy_project_01]# npm install
#此时注意，你本地写的vue代码，接口很可能连接的服务器地址有问题，注意Axios.POST提交的地址，一定得发送给django应用（如果用了nginx，就发送给nginx的入口端口
#准备编译打包vue项目，替换配置文件所有地址，改为服务器地址
[root@elkstack01 07-luffy_project_01]# sed -i 's#127.0.0.1#10.0.0.51#g' /root/07-luffy_project_01/src/restful/api.js
#此时打包vue项目，生成一个dist静态文件夹
[root@elkstack01 07-luffy_project_01]# npm run build
#检查dist文件夹
[root@elkstack01 07-luffy_project_01]# ll dist/
总用量 8
-rw-r--r-- 1 root root  556 4月  13 00:09 index.html
drwxr-xr-x 8 root root 4096 4月  13 00:09 static
```

如果出现如下报错，那么我们需要更新npm版本

<!-- OCR_START -->
- ARH
- andthen
- npmaudit
- ERR! COde EINTEGRITY
- wbV+piQaP
- Updateavailable5.3.0→6.9.0
- Run npmi-g npm to update
<!-- OCR_END -->

￼

```plain
[root@elkstack01 07-luffy_project_01]# npm i -g npm
```

至此vue代码就结束了，只需要让nginx配置，找到vue的index.html首页文件即可.

让nginx找到vue的index.html方法有很多

1）再配置一个server主机

```plain
#先更改一个路径，将站点目录名字修改的简单一点
[root@elkstack01 ~]# mv 07-luffy_project_01 /usr/local/luffy
#编辑nginx配置文件
[root@elkstack01 ~]# vim /usr/local/nginx/conf/nginx.conf
    server {
        listen       80;
        server_name  luffy.driverzeng.com;
        location / {
            root   /usr/local/luffy/dist;
            index  index.html index.htm;
        }
        error_page 400 403 404 405 /40x.html;
        }
#检测nginx语法
[root@elkstack01 ~]# /usr/local/nginx/sbin/nginx -t
nginx: the configuration file /usr/local/nginx-1.10.3//conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.10.3//conf/nginx.conf test is successful
#重新加载nginx
[root@elkstack01 ~]# /usr/local/nginx/sbin/nginx -s reload
#配置hosts
10.0.0.51 luffy.driverzeng.com
```

打开浏览器，访问:[http://luffy.driverzeng.com](http://luffy.driverzeng.com/)

<!-- OCR_START -->
- >C不安全|luffy.driverzeng.com/home
- 应用TTTS
- 路飞学城
- 首页
- 免费课程
- 轻课
- 学位课程
- 登录|注册
- 骑士计划
- 挖出一条进入互联网名企的新通道
- 仅在深圳校区下期开班：12月24日
<!-- OCR_END -->

￼

2）直接把刚才的dist目录下的代码，拷贝到drz下

```plain
[root@elkstack01 ~]# cp -a /usr/local/luffy/dist/* /code/drz/
```

打开浏览器，访问:[https://blog.driverzeng.com](https://blog.driverzeng.com/)

<!-- OCR_START -->
- 不安全blog.driverzeng.com/home
- 应用TTTS
- 路飞学城
- 首页
- 免费课程
- 轻课
- 学位课程
- 登录|注册
- 一Python全栈开发+人工智能
- 面授同步班
- 适合人群：零基础入行编程新手
- 限免试听
- 花1/4的价格在线同步享价值2万+的老男孩最新面授班线下课程
<!-- OCR_END -->

￼

***

| 部署后端代码 |
| :--- |

这个路飞代码数据库用的是sqllite，不需要配置数据库了

购物车用的都是redis，因此要启动服务器的redis-server服务端

```plain
#启动redis
[root@elkstack01 ~]# redis-server /data/6379/redis.conf
```

| 源码安装Python环境 |
| :--- |

Python官网：<https://www.python.org/>

```plain
#下载Python3.6.4安装包
[root@db03 ~]# wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz
#解压
[root@centos7 opt]# tar xf Python-3.6.4.tgz
#生成Python环境安装文件
[root@db03 ~]# ./configure --prefix=/usr/local/python3.6.4 --with-ssl
#编译
[root@db03 ~]# make
#安装
[root@db03 ~]# make install
#软链接python3命令
[root@db03 ~]# ln -s /usr/local/python3.6.4/bin/python3 /usr/bin/
#软链接pip3命令
[root@db03 ~]# ln -s /usr/local/python3.6.4/bin/pip3  /usr/bin/
#安装redis驱动器
[root@elkstack01 ~]# pip3 install redis
#安装uwsgi
[root@elkstack01 ~]# pip3 install uwsgi
#安装Django
[root@elkstack01 ~]# pip3 install django
#安装uwsgi
[root@elkstack01 ~]# yum install -y uwsgi
#编写安装模块文件
[root@elkstack01 ~]# vim requirements.txt
certifi==2018.11.29
chardet==3.0.4
crypto==1.4.1
Django==2.1.4
django-redis==4.10.0
django-rest-framework==0.1.0
djangorestframework==3.9.0
idna==2.8
Naked==0.1.31
pycrypto==2.6.1
pytz==2018.7
PyYAML==3.13
redis==3.0.1
requests==2.21.0
shellescape==3.4.1
urllib3==1.24.1
uWSGI==2.0.17.1
#一次性安装
[root@elkstack01 ~]# pip3 install -r /root/requirements.txt
#解压代码
[root@elkstack01 ~]# unzip luffy_boy.zip
#移动代码
[root@elkstack01 ~]# mv luffy_boy /code/drz/
#配置uwsgi
[root@elkstack01 ~]# vim /code/drz/uwsgi.ini
[uwsgi]
# Django-related settings
# the base directory (full path)
chdir           = /code/drz/luffy_boy
# Django's wsgi file
module          = luffy_boy.wsgi
# the virtualenv (full path)
home            = /usr/local/python3
# process-related settings
# master
master          = true
# maximum number of worker processes
processes       = 1
# the socket (use the full path to be safe
socket          = 0.0.0.0:8888
# clear environment on exit
vacuum          = true
#启动uwsgi
[root@elkstack01 ~]# uwsgi --ini /code/drz/uwsgi.ini &
#配置nginx
[root@elkstack01 ~]# vim /usr/local/nginx/conf/nginx.conf
    server {
    listen       8000;
            server_name  blog.driverzeng.com;
            location / {
            uwsgi_pass 0.0.0.0:8888;
            include /usr/local/nginx/conf/uwsgi_params;
            }
            location /static {
            alias /code/drz/static;
           }
      }
```

***

| nginx负载均衡 |
| :--- |

```plain
[root@lb01 conf]# cat nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    upstream backend {
    server 172.16.1.7:80  weight=1;
    server 172.16.1.8:80  weight=1;
}
    server {
        listen       80;
        server_name  blog.driverzeng.com;
        location / {
            index  index.html index.htm;
            proxy_pass http://backend;
            proxy_set_header Host  $host;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_connect_timeout 60; 
            proxy_send_timeout 60; 
            proxy_read_timeout 60; 
            proxy_buffer_size 4k; 
            proxy_buffers 4 32k;
            proxy_busy_buffers_size 64k; 
            proxy_temp_file_write_size 64k;
        }
    }
}
```

> 更新: 2020-06-25 10:42:50  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/nws1rg>