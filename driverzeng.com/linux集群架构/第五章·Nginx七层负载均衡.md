# 第五章·Nginx七层负载均衡

## Nginx负载均衡基本概述

| 为什么要使用负载均衡 |
| --- |

当我们的**Web**服务器直接面向用户，往往要承载大量并发请求，单台服务器难以负荷，我使用多台**Web**服务器组成集群，前端使用`Nginx`负载均衡，将请求分散的打到我们的后端服务器集群中，实现负载的分发。那么会大大提升系统的吞吐率、请求性能、高容灾

<!-- OCR_START -->
- WebServer集群
- oldboyedu
- Web服务1
- Nginx
- 客户端
- Web服务2
- 浏览器
- 负载均衡
- Web服务3
- 曾老湿
- Driver
- Zeng
<!-- OCR_END -->

往往我们接触的最多的是`SLB(Server Load Balance)`负载均衡，实现最多的也是`SLB`、那么`SLB`它的调度节点和服务节点通常是在一个地域里面。那么它在这个小的逻辑地域里面决定了他对部分服务的实时性、响应性是非常好的。

所以说当海量用户请求过来以后，它同样是请求调度节点，调度节点将用户的请求转发给后端对应的服务节点，服务节点处理完请求后在转发给调度节点，调度节点最后响应给用户节点。这样也能实现一个均衡的作用，那么**Nginx**则是一个典型的`SLB`

**负载均衡的叫法有很多：**

> 负载均衡
>
> 负载
>
> Load Balance
>
> LB

**公有云中叫法**

> SLB 阿里云负载均衡
>
> QLB 青云负载均衡
>
> CLB 腾讯云负载均衡
>
> ULB ucloud负载均衡

**常见的负载均衡的软件**

> Nginx
>
> Haproxy
>
> LVS

<!-- OCR_START -->
- 用户节点
- VIP
- 调度节点
- 服务节点
- 曾老湿
- Driver
- Zeng
<!-- OCR_END -->

***

| 负载均衡能实现的应用场景一: 四层负载均衡 |
| --- |

所谓四层负载均衡指的是`OSI`七层模型中的传输层，那么传输层**Nginx**已经能支持**TCP/IP**的控制，所以只需要对客户端的请求进行**TCP/IP**协议的包转发就可以实现负载均衡，那么它的好处是性能非常快、只需要底层进行应用处理，而不需要进行一些复杂的逻辑。

<!-- OCR_START -->
- 包转发
- 客户端
- Layer 4
- 服务端
- 曾老湿
- DriverZeng
<!-- OCR_END -->

| 负载均衡能实现的应用场景二:七层负载均衡 |
| --- |

七层负载均衡它是在应用层，那么它可以完成很多应用方面的协议请求，比如我们说的**http**应用的负载均衡，它可以实现**http**信息的改写、头信息的改写、安全应用规则控制、**URL**匹配规则控制、以及转发、**rewrite**等等的规则，所以在应用层的服务里面，我们可以做的内容就更多，那么**Nginx**则是一个典型的七层负载均衡`SLB`

<!-- OCR_START -->
- 处理应用层：http信息
- 代理
- 客户端
- 服务端
- Layer7TCP/IP
- 曾老湿
- Driver
- Zeng
<!-- OCR_END -->

***

| 四层负载均衡与七层负载均衡区别 |
| --- |

四层负载均衡数据包在底层就进行了分发，而七层负载均衡数据包则是在最顶层进行分发、由此可以看出，七层负载均衡效率没有四负载均衡高。

但七层负载均衡更贴近于服务，如:**http**协议就是七层协议，我们可以用**Nginx**可以作会话保持，**URL**路径规则匹配、**head**头改写等等，这些是四层负载均衡无法实现的。

**注意：四层负载均衡不识别域名，七层负载均衡识别域名**

## Nginx负载均衡配置场景

Nginx要实现负载均衡需要用到`proxy_pass`代理模块配置.

Nginx负载均衡与**Nginx**代理不同地方在于，**Nginx**的一个`location`仅能代理一台服务器，而**Nginx**负载均衡则是将客户端请求代理转发至一组**upstream**虚拟服务池.

<!-- OCR_START -->
- upstreamServer
- Web服务1
- 10.0.0.7
- Nginx
- 客户端
- 请求
- 负载均衡
- Web服务2
- Proxypass
- 浏览器
- 10.0.0.8
- 10.0.0.5
- Web服务3
- 10.0.0.9
- 曾老湿
<!-- OCR_END -->

***

| Nginx upstream虚拟配置语法 |
| --- |

```bash
Syntax: upstream name { ... }
Default: -
Context: http
 
#upstream例
upstream backend {
    server backend1.example.com       weight=5;
    server backend2.example.com:8080;
    server unix:/tmp/backend3;
    server backup1.example.com:8080   backup;
}
server {
    location / {
        proxy_pass http://backend;
    }
}
```

***

| 1.环境准备 |
| --- |

| **角色** | **外网\*\*\*\*IP(NAT)** | **内网\*\*\*\*IP(LAN)** | **主机名** |
| --- | --- | --- | --- |
| LB01 | eth0:10.0.0.5 | eth1:172.16.1.5 | lb01 |
| web01 | eth0:10.0.0.7 | eth1:172.16.1.7 | web01 |
| web02 | eth0:10.0.0.8 | eth1:172.16.1.8 | web02 |

***

| 2.Web01服务器上配置nginx |
| --- |

```bash
[root@web01 ~]# cd /etc/nginx/conf.d/
[root@web01 conf.d]# cat node.conf 
server {
    listen 80;
    server_name node.drz.com;
    location / {
        root /node;
        index index.html;
    }
}
[root@web01 conf.d]# mkdir /node
[root@web01 conf.d]# echo "Web01..." > /node/index.html
[root@web01 conf.d]# systemctl restart nginx
```

***

| 3.Web02服务器上配置nginx |
| --- |

```bash
[root@web02 ~]# cd /etc/nginx/conf.d/
[root@web02 conf.d]# cat node.conf 
server {
    listen 80;
    server_name node.drz.com;
    location / {
        root /node;
        index index.html;
    }
}
[root@web02 conf.d]# mkdir /node
[root@web02 conf.d]# echo "Web02..." > /node/index.html
[root@web02 conf.d]# systemctl restart nginx
```

***

| 4.配置Nginx负载均衡 |
| --- |

```bash
[root@lb01 ~]# cd /etc/nginx/conf.d/
[root@lb01 conf.d]# cat node_proxy.conf 
upstream node {
    server 172.16.1.7:80;
    server 172.16.1.8:80;
}
server {
    listen 80;
    server_name node.drz.com;
 
    location / {
        proxy_pass http://node;
        include proxy_params;
    }
}
[root@lb01 conf.d]# systemctl restart nginx
```

***

| 5.准备Nginx负载均衡调度使用的proxy_params |
| --- |

```bash
[root@Nginx ~]# vim /etc/nginx/proxy_params
proxy_set_header Host $http_host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
 
proxy_connect_timeout 30;
proxy_send_timeout 60;
proxy_read_timeout 60;
 
proxy_buffering on;
proxy_buffer_size 32k;
proxy_buffers 4 128k;
```

打开浏览器访问：<http://node.drz.com>

<!-- OCR_START -->
- oldboyedu
- node.oldboy.com
- 不安全
- ···
- 应用
- 运维
- 开发
- 学习
- 写作
- 阅读
- 教育
- Web01...
- 曾老湿
- Driver
- Lend
<!-- OCR_END -->

<!-- OCR_START -->
- node.oldboy.com
- 不安全
- 应用
- 运维
- 开发
- 学习
- 写作
- Web02...
- 曾老湿
- DriverZeng
<!-- OCR_END -->

***

| 负载均衡常见典型故障 |
| --- |

如果后台服务连接超时，Nginx是本身是有机制的，如果出现一个节点down掉的时候，Nginx会更据你具体负载均衡的设置，将请求转移到其他的节点上，但是，如果后台服务连接没有down掉，但是返回错误异常码了如:504、502、500,这个时候你需要加一个负载均衡的设置，如下：proxy_next_upstream  http_500 | http_502 | http_503 | http_504  |http_404;意思是，当其中一台返回错误码404,500...等错误时，可以分配到下一台服务器程序继续处理，提高平台访问成功率。

```bash
server {
    listen 80;
    server_name www.driverzeng.com;
    location / {
        proxy_pass http://node;
        proxy_next_upstream error timeout http_500 http_502 http_503 http_504;
    }
}
```

## Nginx负载均衡调度算法

| **调度算法** | **概述** |
| --- | --- |
| 轮询 | 按时间顺序逐一分配到不同的后端服务器(默认) |
| weight | 加权轮询,weight值越大,分配到的访问几率越高 |
| ip_hash | 每个请求按访问IP的hash结果分配,这样来自同一IP的固定访问一个后端服务器 |
| url_hash | 按照访问URL的hash结果来分配请求,是每个URL定向到同一个后端服务器 |
| least_conn | 最少链接数,那个机器链接数少就分发 |

***

| Nginx负载均衡\[rr]轮询具体配置 |
| --- |

```bash
upstream load_pass {
    server 10.0.0.7:80;
    server 10.0.0.8:80;
}
```

***

| Nginx负载均衡\[wrr]权重轮询具体配置 |
| --- |

```bash
upstream load_pass {
    server 10.0.0.7:80 weight=5;
    server 10.0.0.8:80;
}
```

***

| Nginx负载均衡ip_hash |
| --- |

具体配置不能和weight一起使用。

```bash
#如果客户端都走相同代理, 会导致某一台服务器连接过多
upstream load_pass {
    ip_hash;
    server 10.0.0.7:80 weight=5;
    server 10.0.0.8:80;
}
```

## Nginx负载均衡后端状态

后端Web服务器在前端Nginx负载均衡调度中的状态

| **状态** | **概述** |
| --- | --- |
| down | 当前的server暂时不参与负载均衡 |
| backup | 预留的备份服务器；其他服务器都不可用时候才开始处理请求 |
| max_fails | 允许请求失败的次数 |
| fail_timeout | 经过max_fails失败后, 服务暂停时间 |
| max_conns | 限制最大的接收连接数 |

***

| 测试down状态测试该Server不参与负载均衡的调度 |
| --- |

```bash
upstream load_pass {
    #不参与任何调度, 一般用于停机维护
    server 10.0.0.7:80 down;
}
```

***

| 测试backup以及down状态 |
| --- |

```bash
upstream load_pass {
    server 10.0.0.7:80 down;
    server 10.0.0.8:80 backup;
    server 10.0.0.9:80 max_fails=1 fail_timeout=10s;
}
 
location  / {
    proxy_pass http://load_pass;
    include proxy_params;
}
```

***

| 测试max_fails失败次数和fail_timeout多少时间内失败多少次则标记down |
| --- |

```bash
upstream load_pass {
    server 10.0.0.7:80;
    server 10.0.0.8:80 max_fails=2 fail_timeout=10s;
}
```

***

| 测试max_conns最大TCP连接数 |
| --- |

```bash
upstream load_pass {
    server 10.0.0.7:80;
    server 10.0.0.8:80 max_conns=1;
}
```

## Nginx负载均衡健康检查

在Nginx官方模块提供的模块中，没有对负载均衡后端节点的健康检查模块，但可以使用第三方模块。

`nginx_upstream_check_module`来检测后端服务的健康状态。

第三方模块项目地址：[TP](https://github.com/yaoweibin/nginx_upstream_check_module)

1.安装依赖包

```bash
[root@lb02 ~]# yum install -y gcc glibc gcc-c++ pcre-devel openssl-devel patch
```

2.下载nginx源码包以及nginx_upstream_check模块第三方模块

```bash
[root@lb02 ~]# wget http://nginx.org/download/nginx-1.14.2.tar.gz
[root@lb02 ~]# wget https://github.com/yaoweibin/nginx_upstream_check_module/archive/master.zip
```

3.解压nginx源码包以及第三方模块

```bash
[root@lb02 ~]# tar xf nginx-1.14.2.tar.gz
[root@lb02 ~]# unzip master.zip
```

4.进入nginx目录，打补丁(nginx的版本是1.14补丁就选择1.14的,p1代表在nginx目录，p0是不在nginx目录)

```bash
[root@lb02 ~]# cd nginx-1.14.2/
[root@lb02 nginx-1.14.2]# patch -p1 <../nginx_upstream_check_module-master/check_1.14.0+.patch
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --add-module=/root/nginx_upstream_check_module-master --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
[root@lb02 nginx-1.14.2]# make && make install
```

5.在已有的负载均衡上增加健康检查的功能

```bash
[root@lb01 conf.d]# cat proxy_web.conf
upstream web {
    server 172.16.1.7:80 max_fails=2 fail_timeout=10s;
    server 172.16.1.8:80 max_fails=2 fail_timeout=10s;
    check interval=3000 rise=2 fall=3 timeout=1000 type=tcp;
    #interval  检测间隔时间，单位为毫秒
    #rise      表示请求2次正常，标记此后端的状态为up
    #fall      表示请求3次失败，标记此后端的状态为down
    #type      类型为tcp
    #timeout   超时时间，单位为毫秒
}

server {
    listen 80;
    server_name web.drz.com;
    location / {
        proxy_pass http://web;
        include proxy_params;
    }
    location /upstream_check {
        check_status;
    }
}
```

## Nginx负载均衡会话保持

在使用负载均衡的时候会遇到会话保持的问题，可通过如下方式进行解决。

1.使用nginx的`ip_hash`，根据客户端的IP，将请求分配到对应的IP上

2.基于服务端的`session`会话共享（NFS，MySQL，memcache，redis，file）

在解决负载均衡绘画问题，我们需要了解`session`和`cookie`的区别。

浏览器端存的是`cookie`每次浏览器发请求到服务端时，报文头是会自动添加`cookie`信息的。

服务端会查询用户的`cookie`作为key去存储里找对应的value(session)

同一域名下的网站的`cookie`都是一样的，所以无论几台服务器，无论请求分配到哪一台服务器上同一用户的`cookie`是不变的。也就是说`cookie`对应的`session`也是唯一的。所以，这里只要保证多台业务服务器访问同一个共享存储服务器（NFS，MySQL，memcache，redis，file）就行了。

1.配置Nginx

```bash
[root@web01 conf.d]# cat php.conf
server {
    listen 80;
    server_name php.drz.com;
    root /code/phpMyAdmin-4.8.4-all-languages;
    location / {
        index index.php index.html;
    }
    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
[root@web01 conf.d]# systemctl restart nginx
```

2.安装phpmyadmin （web01和web02上都装）

```bash
[root@web01 conf.d]# cd /code
[root@web01 code]# wget https://files.phpmyadmin.net/phpMyAdmin/4.8.4/phpMyAdmin-4.8.4-all-languages.zip
[root@web01 code]# unzip phpMyAdmin-4.8.4-all-languages.zip
```

3.配置phpmyadmin连接远程的数据库

```bash
[root@web01 code]# cd phpMyAdmin-4.8.4-all-languages/
[root@web01 phpMyAdmin-4.8.4-all-languages]# cp config.sample.inc.php config.inc.php
[root@web01 phpMyAdmin-4.8.4-all-languages]# vim config.inc.php
/* Server parameters */
$cfg['Servers'][$i]['host'] = '172.16.1.51';
```

4.配置授权

```bash
[root@web01 conf.d]# chown -R www.www /var/lib/php/
```

***

| 使用浏览器访问页面，获取cookie信息 |
| --- |

<!-- OCR_START -->
- phpMyAdmin
- ①不安全| php.drz.com
- n/index.php
- 无痕模式
- TTTSzabbix-api
- 欢迎使用phpMyAdmin
- 语言-Language
- 中文-Chine
- 登录
- 用户名：
- 密码：
- 执行
- 曾老湿
- DriverZeng
<!-- OCR_END -->

<!-- OCR_START -->
/10.0.0.51lphpl
① 不安全| php.drz.com/index.php
无痕模式
zabbix-api
phpMyAdmin
服务器：10.0.0.51
数据库SQL状态账户国导出园导入设置复制变量字符集引擎插件
近期访问 表收藏夹
常规设置
数据库服务器
新建
±- information_schema
修改密码
·服务器： 10.0.0.51 via TCP/IP
±- mysql
·服务器类型：MariaDB
服务器连接排序规则：utf8mb4_unicode_ci
·服务器连接:SSL未被使用
- perfon
- test
·服务器版本：5.5.60-MariaDB -MariaDB Server
·协议版本：10
外观设置
用户：root@10.0.0.7
·服务器字符集：UTF-8 Unicode (utf8)
语言-Language
中文-Chinese simplified
控制台
pmahomme
网站服务器
冠曰
Elem
Sources
Network
Performance
Mer
Application
urity
Audits
CFiter
Manifest
Name
Domain
Path
Expires/Max-Age
HttpOonly
Service Workers
e96b27a6a628be47745a10a36e2fcd5a
php.drz.com
Session
42
Clear storage
pmaAuth-1
%7B%22iv%22%3A%22REAbvnq%5C%2F7fNV3CFNs%5C%2Fz73g%3D%3D%22%2C%22m..
202
pmaUser-1
%7B%22iv%22%3A%22vLaf5vHAjllaIE%5C%2FUe9mgyQ%3D%3D%22%2C%22mac%22%3.
2019-09-20T10...
184
Storage
pma_lang
zh_CN
php.dr.com
Local Storage
Session Storage
IndexedDB
WebSQL
Cookies
http://php.drz.
Cache
Cache Storage
Application Cache
BackgroundServices
What'sNewx
Highlights from the Chrome76 update
Autocomplete with csskeyword values
Typingakeywordvalue likebold" intheStyle
A new UI for network settings
The“Uselargerequ
"，"Shoy
曾老湿
tingspane
new
Driver Zeng
gesinHARexports
<!-- OCR_END -->

```bash
[root@web01 phpMyAdmin-4.8.4-all-languages]# ll /var/lib/php/session/
总用量 4
-rw-------. 1 www www 2424 8月  21 18:41 sess_e96b27a6a628be47745a10a36e2fcd5a
```

<!-- OCR_START -->
1.root@web01:/
X..4-all-languages(ssh)981
root@db01:~（ssh)82
2X.ent/themes/QQ（vim)83
X..nginx/conf.d（ssh)84
[root@web01phpMyAdmin-4.8.4-all-languages]#1l/var/lib/php/session/
总用量4
-rw-
1wwwwww24248月2118:41sess_e96b27a6a628be47745a10a36e2fcd5a
[root@web01phpMyAdmin-4.8.4-all-languages]#
曾老湿
DriverZeng
<!-- OCR_END -->

5.将web01上配置好的phpmyadmin以及nginx的配置文件推送到web02主机上

```bash
[root@web01 code]# scp -rp  phpMyAdmin-4.8.4-all-languages root@172.16.1.8:/code/
[root@web01 code]# scp /etc/nginx/conf.d/php.conf  root@172.16.1.8:/etc/nginx/conf.d/
```

6.在web02上重载Nginx服务

```bash
[root@web02 code]# systemctl restart nginx
```

7.授权

```bash
[root@web02 code]# chown -R www.www /var/lib/php/
```

8.接入负载均衡

```bash
[root@lb01 conf.d]# vim proxy_php.com.conf 
upstream php {
        server 172.16.1.7:80;
        server 172.16.1.8:80;
}
server {
        listen 80;
        server_name php.drz.com;
        location / {
                proxy_pass http://php;
                include proxy_params;
        }
}
[root@lb01 conf.d]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@lb01 conf.d]# systemctl restart nginx
```

\*\*使用负载均衡的轮询功能之后，会发现，如果将session保存在本地文件的话，永远都登录不上去。\*\*drz.com

***

| 使用redis解决会话登录问题 |
| --- |

1.安装redis内存数据库

```bash
[root@db01 ~]# yum install redis -y
```

2.配置redis监听在172.16.1.0网段上

```bash
[root@db01 ~]# sed  -i '/^bind/c bind 127.0.0.1 172.16.1.51' /etc/redis.conf
```

3.启动redis

```bash
[root@db01 ~]# systemctl start redis
[root@db01 ~]# systemctl enable redis
```

4.php配置session连接redis

```bash
#1.修改/etc/php.ini文件
[root@web ~]# vim /etc/php.ini
session.save_handler = redis
session.save_path = "tcp://172.16.1.51:6379"
;session.save_path = "tcp://172.16.1.51:6379?auth=123" #如果redis存在密码，则使用该方式
session.auto_start = 1
#2.注释php-fpm.d/www.conf里面的两条内容，否则session内容会一直写入/var/lib/php/session目录中
;php_value[session.save_handler] = files
;php_value[session.save_path]    = /var/lib/php/session
```

5.重启php-fpm

```bash
[root@web01 code]# systemctl restart php-fpm
```

6.将web01上配置好的文件推送到web02

```bash
[root@web01 code]# scp /etc/php.ini root@172.16.1.8:/etc/php.ini  
[root@web01 code]# scp /etc/php-fpm.d/www.conf root@172.16.1.8:/etc/php-fpm.d/www.conf
```

5.上web02上重启php-fpm

```bash
[root@web02 code]# systemctl restart php-fpm
```

6.redis查看数据

```bash
[root@db01 redis]# redis-cli
127.0.0.1:6379> keys *
1) "PHPREDIS_SESSION:1365eaf0490be9315496cb7382965954"
```

<!-- OCR_START -->
- ①不安全|php.haoda.com/index.php
- 应用建议网站百度一下，你就知道时间截（Unixtimes
- 云堡垒-任子行onProcessOnC在线编码转换在线加密/解密，对
- 易搞笑GIF图：大哥好Markdown图片|.
- 摄图网-正版高清图D腾讯企业邮箱
- phpMyAdmin
- 服务器：172.16.1.51
- 曰一
- Elements
- Sources
- Network
- Performance
- Memory
- Application
- Security
- Audits
- 48
- 数据库SQL
- 状态
- 账户导出导入设置复制变量
- Filter
- 近期访问表收藏夹
- Manifest
- Name
- Value
- Do
- Path
- Expi..
- Size
- Http
- 常规设置
- 数据库服务器
- Service Workers
- PHPSESSID
- f12f807d4cc8e1139d3cf3e2b1890762
- php...
- Sess..
- 41
- Clear storage
- 1365eaf0490be9315496cb7382965954
- 42
- 新建
- 修改密码
- ·服务器：172.16.1.51viaTCP/IP
- pmaAuth-1
- %7B%22iv%22%3A%22M%5C%2FG9VPV9OP
- Ses..
- 197
- edusoho
- ·服务器类型：MariaDB
- Storage
- pmaUser-1
- %78%22iv%22%3A%22akKs%5C%2FXF5giaJGx
- 201..
- 184
- information_sch
- 服务器连接排序规则：utf8mb4_unicode_ci
- ·服务器连接：SSL未被使用
- pma_lang
- zh_CN
- 13
- Local Storage
- -mysql
- ·服务器版本：5.5.60-MariaDB
- Session Storage
- performance_schema
- MariaDBServer
- IndexedDB
- -test
- 外观设置
- ·协议版本：10
- WebSQL
- wordpress
- ·用户： root@172.16.1.7
- Cookies
- -0zh
- ·服务器字符集：cp1252West European
- http://php.haoda.con
- 语言-Language中文-Chinese simplified
- (latin1)
- Cache
- 主题：
- pmahomme
- 网站服务器
- Application Cache
- ·字号：82%
- · nginx/1.16.0
- BackgroundServices
- 更多设置
- ·数据库客户端版本：libmysql-mysqlnd
- ↑BackgroundFetch
- 5.0.12-dev-20150407-SId:
- Background Sync
- 38fea24f2847fa7519001be390c98ae0a
- ·PHP扩展:mysqli curl mbstring
- □top
- ·PHP版本：7.1.30
- ·版本信息：4.9.0.1(已更新)
- ·文档
- ·官方主页
- ·贡献
- ·获取支持
- ·更新列表
- Console What's Newx
- ·授权
- Highlights from the Chrome 76update
- Autocomplete with Csskeyword values
- phpMyAdmin高级功能尚未完全设置，部分功能未激活。查找原因。
- 或者也可以去某个数据库的“操作”选项卡那里进行设置。
- AnewUIfor network settings
- 曾老湿
- new
- DriverZeng
<!-- OCR_END -->

> 更新: 2024-09-23 18:31:08  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/nzotb6>