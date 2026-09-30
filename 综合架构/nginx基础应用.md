# nginx基础应用

用户访问网站流程：

```plain
1.用户输入域名->浏览器跳转->DNS解析( 递归查询 | 迭代查询 )
    客户端向服务端发起查询->递归查询
    服务端向服务端发起查询->迭代查询
2.由浏览器向服务端发起TCP连接（三次握手）
    客户端  -->请求包连接-syn=1 seq=x         服务端
    服务端  -->向应客户端syn=1 ack=x+1 seq=y  客户端
    客户端  -->建立连接  ack=y+1 seq=x+1 服务端
3.客户端发起http请求：
    1.请求的方法是什么： Get 获取
    2.请求的Host主机是： www.oldboyedu.com
    3.请求的资源是什么： /index.html
    4.请求的端口是什么： 默认http是80  https 443
    5.请求携带的参数是： 属性（请求的类型、压缩、认证、等等）
4.服务端响应的内容是：
    1.响应服务端使用的软件（nginx）
    2.响应请求文件的类型
    3.响应请求的文件是否进行压缩
    4.响应请求的主机是否进行长连接
5.客户端向服务端发起TCP断开（四次挥手）
    客户端  --> 断开请求 fin=1 seq=x           -->      服务端
    服务端  --> 响应断开 fin=1 ack=x+1 seq=y   -->      客户端
    服务端  --> 断开连接 fin=1 ack=x+1 seq=z   -->      客户端
    客户端  --> 确认断开 fin=1 ack=z+1 seq=sj  -->      服务端
    
```

## [](#)1.Nginx基本简述

> * Nginx是一个开源且高性能、可靠的HttpWeb服务、代理服务。
> * 开源: 直接获取源代码
> * 高性能: 支持海量并发
> * 可靠: 服务稳定

## 常见的 HTTP Web服务

Httpd 由Apache基金会

IIS 微软服务器版

GWS Google开发

Openrestry 基于nginx+lua   | nginx+lua 可实现waf防火墙(7层应用层防火墙)

```
			(传统防火墙工作在四层tcp/udp) 22/80 端口

			扩展[https://www.newdefend.com/index/intro](https://www.newdefend.com/index/intro)

			1 花钱解决问题 ()

			2 自己解决问题(浪费时间 没有上浮空间)
```

Tengline 淘宝基于Nginx开发 | <http://tengine.taobao.org/>

OpenResty = Nginx + LuaJIT + 大量 Lua 库（官方定制版，阿里 / 腾讯 / 百度都在用）

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">能防护哪些攻击？（运维必背）</font>**

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">SQL 注入</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">?id=1' union select</font></code>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">XSS 跨站</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"><script>alert(1)</script></font></code>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令注入</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">?cmd=cat /etc/passwd</font></code>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">CC 攻击 / 恶意爬虫</font>**

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">IP 黑名单 / UA 黑名单</font>**

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">目录遍历</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">../etc/passwd</font></code>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">非法请求方法</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：TRACE、PUT</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">不用自己开发！</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 有成熟开源轻量 WAF：  </font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 安装 OpenResty（替代 Nginx，自带 Lua）</font>

```plain
# CentOS 安装 OpenResty
yum install -y yum-utils
yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
yum install -y openresty
```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. 下载 ngx_lua_waf 规则</font>

```plain
cd /usr/local/openresty/nginx/conf/
git clone https://github.com/loveshell/ngx_lua_waf.git waf
```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3. Nginx 配置集成 WAF</font>

```nginx
http {
  # 加载WAF
  lua_package_path "/usr/local/openresty/nginx/conf/waf/?.lua";
  lua_shared_dict limit 10m;
  init_by_lua_file  /usr/local/openresty/nginx/conf/waf/init.lua;
  access_by_lua_file /usr/local/openresty/nginx/conf/waf/waf.lua;

  server {
    listen 80;
    location / {
      root html;
    }
  }
}
```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">4. 重启 OpenResty</font>

```plain
systemctl restart openresty
```

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">WAF 直接生效！自动拦截所有恶意请求</font>**

## [](#)为什么选择 Nginx

```plain
1.Nginx非常轻量
	1.功能模块少(源代码仅保留http与核心模块代码,其余不够核心代码会作为插件来安装)
	2.代码模块化（易读，便于二次开发，对于开发人员是非常友好）

2.互联网公司都选择Nginx
	1.技术成熟, 大公司都选择Nginx
	2.统一技术选型工具, 降低维护成本，减少故障几率。
	3.Nginx涉足场景较多，技术更新成本低。
	
3.Nginx采用Epool网络模型, Apache采用Select模型。	
	Select: 当用户发起一次请求，select模型就会进行一次遍历扫描，从而导致性能低下。
	Epool: 当用户发起请求，epool模型会直接进行处理，效率高效，并无连接限制。

扩展:
io多路复用模型:I/O 多路复用技术是一种可以同时监控多个文件描述符，当其中一个或多个文件描述符就绪时，就通知程序进行相应的读写操作的技术。
select
poll
epoll

```

## [](#)Nginx应用场景

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">静态网站部署（html、css、图片）</font>
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">反向代理</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（转发请求给后端服务）</font>
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">负载均衡</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（分发流量到多台服务器）</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTPS 配置</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">缓存、限流、防盗链</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">集成 Lua 做 WAF 防火墙</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>

## [](#)Nginx快速安装

> * Mainline version 开发版
> * Stable version 稳定版
> * Legacy version 历史版本

```plain
1 epel仓库 --> nginx (1.版本低 2配置文件不一样)
2 源码编译 --> nginx (1复杂 2 企业不使用)
3 官方仓库 --> nginx (勾  1版本新 2 安装简单  3配置不复杂) 
http://nginx.org/en/linux_packages.html#stable
```

1.配置Nginx官方的仓库

```nginx
#官方的配置 
cat > /etc/yum.repos.d/nginx.repo<<EOF
[nginx-stable]
name=nginx stable repo
baseurl=https://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

yum install yum-utils
yum clean all
yum makecache


#修改的版本
cat > /etc/yum.repos.d/nginx.repo<<EOF
[nginx]
name=nginx
baseurl=http://nginx.org/packages/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF

```

2.安装Nginx【一定确认是通过官方的仓库安装上】

```plain
[root@ckh ~]# yum install nginx
依赖关系解决
==============================================================================
 Package   架构           版本                 源           大小
==============================================================================
正在安装:
 nginx     x86_64    1:1.14.0-1.el7_4.ngx     nginx        750 k
事务概要
==============================================================================
安装  1 软件包
总下载量：750 k
安装大小：2.6 M
Is this ok [y/d/N]:y
```

3.检查版本【1.14.0】

```plain
[root@web01 ~]# nginx -v
nginx version: nginx/1.14.0
```

4.查看nginx编译的参数

```plain
nginx -V

# yum list|grep nginx    #查看Nginx其他插件 这里包括了其他epel源的

#指定之查看nginx源的 软件列表
yum --disablerepo=\* --enablerepo=nginx-stable list|grep nginx

```

5.编译参数越多越好，还是越少越好？

```plain
源码编译好了，做成的rpm包
越少：功能少，后期可维护性差
越多：功能全，覆盖广，可维护性强

```

## [](#)Nginx配置文件

Nginx主配置文件/etc/nginx/nginx.conf是一个纯文本类型的文件，整个配置文件是以区块的形式组织的。一般，每个区块以一对大括号{}来表示开始与结束。

> * 1.CoreModule 核心模块
> * 2.EventModule 事件驱动模块
> * 3.HttpCoreModule http内核模块

需了解扩展项

> * CoreModule层下可以有Event、HTTP
> * HTTP模块层允许有多个Server层, Server主要用于配置多个网站
> * Server层又允许有多个Location, Location主要用于定义网站访问路径

| 路径 | 作用 |
| --- | --- |
| `/etc/nginx/nginx.conf` | 主配置文件 |
| `/etc/nginx/conf.d/` | 子配置文件目录（最常用） |
| `/usr/share/nginx/html` | 默认网站根目录 |
| `/var/log/nginx/` | 日志目录（access.log/error.log） |
| `/usr/sbin/nginx` | 启动命令 |

```nginx
# cat /etc/nginx/nginx.conf
user  nginx;                                   # 运行nginx程序的用户
worker_processes  1;                           # 运行的进程数量
error_log  /var/log/nginx/error.log warn;      # 错误日志
pid        /var/run/nginx.pid;                 # 存放nginx进程运行的pid
events {                                       # 事件模块开始
  worker_connections  1024;                  # worker进程的最大连接数
  use epool;                                 # 事件使用的模型（默认epool）
}                                              # 事件模块结束
http {                                         # http开始
  include       /etc/nginx/mime.types;       # 包含
  default_type  application/octet-stream;    #m默认文件类型
  # 定义日志的格式
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  # 访问日志存放的路径【main是日志的格式】
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  #tcp_nopush     on;
  keepalive_timeout  65;                        # 长连接
  #gzip  on;                                    # 压缩
  include /etc/nginx/conf.d/*.conf;             # 所有的conf结尾的文件都被包含起来
}

```

```nginx
# egrep -v '^$|^.*#' /etc/nginx/conf.d/default.conf
server {                                	# 我要定义一个网站【博客】
  listen       80;                        # 监听80端口
  server_name  localhost;                 # 对应的域名
  location / {                            # 用户请求域名时，默认匹配的规则
    root   /usr/share/nginx/html;       	# 网站根目录
    index  index.html index.htm;        	# 返回的默认页面
  }
  error_page   500 502 503 504  /50x.html; # 定义错误页面的
}

```

常用命令

```nginx
# 启动
systemctl start nginx
# 停止
systemctl stop nginx
# 重启
systemctl restart nginx
# 重载配置（不中断业务，推荐！）
systemctl reload nginx
# 开机自启
systemctl enable nginx
# 检查配置是否正确（修改后必执行）
nginx -t

# 实时查看访问日志
tail -f /var/log/nginx/access.log

# 实时查看错误日志
tail -f /var/log/nginx/error.log
```

## [](#)部署一个站点：

1.对应的nginx配置文件

```nginx
cat > /etc/nginx/conf.d/oldboy_game.conf<<EOF
server {
  listen 80;                   #端口
  server_name game.oldboy.com; #域名
  location / {
    root /oldboy_code;        # 网站根目录
    index index.html;
  }
  # 日志  每个域名单独配置日志文件，可不配置
  access_log /var/log/nginx/access.log;
}
EOF



# 2.对应的源代码文件【手动-太low】
mkdir /oldboy_code
cd /oldboy_code/
rz  html5.zip  #上传代码
unzip html5.zip

#没有文件 随意写一个
echo "hello world html" > /oldboy_code/index.html


# 检查nginx的语法
nginx -t


#需要先启动nginx
systemctl start nginx

#重载nginx
nginx -s reload
systemctl reload nginx

# 如何访问:
1.通过服务器的IP直接访问：10.0.0.7
2.通过域名方式访问
    Windows:   C:\Windows\System32\drivers\etc\hosts 文件
    Mac:       sudo vim /etc/hosts
    10.0.0.7   game.oldboy.com
    
3.使用ping命令测试域名解析是否正常
  浏览器访问 game.oldboy.com
```

# Nginx目录索引

```nginx
#autoindex常用参数
autoindex on;
开启目录索引
autoindex_exact_size off;
默认为on， 显示出文件的确切大小，单位是bytes。
修改为off，显示出文件的大概大小，单位是kB或者MB或者GB。
autoindex_localtime on;
默认为off，显示的文件时间为GMT时间。
修改为on， 显示的文件时间为文件的服务器时间。
charset utf-8,gbk;
默认中文目录乱码，添加上解决乱码。


cat > /etc/nginx/conf.d/oldboy_game.conf<<EOF
server {
  listen 80;
  server_name game.oldboy.com;
  location / {
    autoindex on;
    root /oldboy_code;
    index index.html;
  }
}
EOF


#改名 html
mv /oldboy_code/index.html /oldboy_code/oldboy.html

cat > /etc/nginx/conf.d/oldboy_game.conf<<EOF
server {
	listen 80;
	server_name game.oldboy.com;
  location / {
  	root /oldboy_code;
  	index index.html;
  }
  location /centos {
  	autoindex on;
  	root /oldboy_code;
  }
}
EOF

mv /oldboy_code/oldboy.html /oldboy_code/index.html

mkdir -p /oldboy_code/centos
nginx -t

touch /oldboy_code/centos/aaaa.txt
mkdir -p /oldboy_code/centos/centos{1..10}
systemctl reload nginx
# http://game.oldboy.com/centos/

cat > /etc/nginx/conf.d/oldboy_game.conf<<EOF
server {
  listen 80;
  server_name game.oldboy.com;
  charset utf-8,gbk;
  location / {
    root /oldboy_code;
    index index.html;
    }
  location /centos {
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
    root /oldboy_code;
    }
}
EOF
systemctl reload nginx
systemctl restart nginx


如果开启了目录的索引
上传的文件,只看该文件的修改时间.
如果本地创建,则和服务器时间进行保持.


```

# Nginx状态监控

```nginx
cat > /etc/nginx/conf.d/oldboy_game.conf <<EOF
server {
  listen 80;
  server_name game.oldboy.com;
  charset utf-8,gbk;
  location / {
    root /oldboy_code;
    index index.html;
  	}
  location /centos {
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
    root /oldboy_code;
    }
  location  /nginx_status {
    stub_status;
	}
}
EOF

nginx -t
systemctl reload nginx

# http://game.oldboy.com/nginx_status
#使用浏览器访问http://IP/nginx_status访问后得到的结果
Active connections: 1             
server accepts handled requests     
 2 2 36 	
Reading: 0 Writing: 1 Waiting: 0 	
 
2           # 总的tcp连接数connection
2           # 成功tcp连接数connection(失败连接=(总连接数-成功连接数))
36          # 总共处理的http请求数requests 
Active connections    # 当前活动的连接数
accepts   2           # 当前的总连接数TCP
handled   2           # 成功的连接数TCP
requests 36           # 总的http请求数
一次TCP的连接，可以发起多次http的请求（长连接状态）
#keepalive_timeout 0;  每次连接都会产生一次请求(短连接)
#keepalive_timeout 65; 在65s以内的请求建立在一个连接基础之上(长连接)
Reading             #请求
Writing             #响应
Waiting             #等待的请求数，开启了keepalive

```

# Nginx访问控制

## 基于ip地址

```nginx
//允许配置语法
Syntax: allow address | CIDR | unix: | all;
Default: —
Context: http, server, location, limit_except
//拒绝配置语法
Syntax: deny address | CIDR | unix: | all;
Default: —
Context: http, server, location, limit_except

1访问控制配置示例,拒绝指定ip,其他全部允许
location /nginx_status {
    stub_status;
    access_log off;
    deny 10.0.0.1/32;
    allow all;
}

10.0.0.1访问 提示403 forbidden	

# 10.0.0.7 本机访问
# curl -H Host:game.oldboy.com 10.0.0.7/nginx_status
Active connections: 1
server accepts handled requests
40 40 132 Reading: 0 Writing: 1 Waiting: 0

# curl 10.0.0.7/nginx_status  
Active connections: 1  
server accepts handled requests  
 41 41 133  
Reading: 0 Writing: 1 Waiting: 0

2访问控制配置示例, 只允许谁能访问, 其它全部拒绝
location  /nginx_status {
	stub_status;
	allow 127.0.0.1;
	deny all;
}

```

## 基于用户密码

```nginx
//配置语法
Syntax: auth_basic string| off;
Default: auth_basic off;
Context: http, server, location, limit_except
//用户密码记录配置文件
Syntax: auth_basic_user_file file;
Default: -
Context: http, server, location, limit_except

1 需要安装依赖组件 生成账号密码文件
yum install httpd-tools
htpasswd -b -c /etc/nginx/auth_conf ckh 123456
cat /etc/nginx/auth_conf


2配置文件 加入需要认证的location 模块

cat > /etc/nginx/conf.d/oldboy_game.conf<<EOF
server {
  listen 80;
  server_name game.oldboy.com;
  charset utf-8,gbk;
  location / {
    root /oldboy_code;
    index index.html;
    }
  location /centos {
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
    root /oldboy_code;
    auth_basic "不要随便尝试, 滚蛋!";
    auth_basic_user_file /etc/nginx/auth_conf;
    }
  location /nginx_status {
    stub_status;
    allow 127.0.0.1;
    deny all;
    }
  }
EOF

nginx -t
systemctl reload nginx

# http://game.oldboy.com/centos/  #访问提示输入账号密码登录


参考 fj.xuliangwei.com
location / {
  root /code; 							# 指定网站代码存放的位置
  autoindex on;							# 开启目录索引
  autoindex_localtime on;		# 开启本地服务器的时间
  autoindex_exact_size off;	# 以人性化方式显示文件大小
  access_log off;						# 关闭访问日志
  auth_basic "Permission denied";	# 基础认证的描述信息
  auth_basic_user_file /etc/nginx/auth_conf;	# 基础认证密码文件位置(验证)
}

用户认证局限性
  1.用户信息依赖文件方式
  2.用户管理文件过多, 无法联动
  3.操作管理机械，效率低下
  
解决办法
1.Nginx结合LUA实现高效验证
2.Nginx结合LDAP利用nginx-auth-ldap模块
```

#

Nginx访问限制
**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ngx_http_limit_conn_module</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ngx_http_limit_req_module</font>**

这两个是 Nginx **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">防 CC 攻击、防爬虫、限流</font>** 最核心的两个模块！

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1.</font>\*\*\*\*<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> limit_conn → 限制连接数</font>**

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">控制</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">同一个 IP 同时能建立多少个连接</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（针对 TCP 连接）</font>

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. limit_req → 限制请求数</font>**

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">控制</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">同一个 IP 每秒能发多少个请求</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（针对 HTTP 请求，防 CC 攻击神器）</font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. nginx.conf 最顶层配置（http 块内）</font>

```nginx
# ====================== 1. 请求频率限制（防CC、防刷新）======================
# 定义限流桶：name=req_zone，1个IP占10M内存，每秒只允许 10 个请求
limit_req_zone $binary_remote_addr zone=req_zone:10m rate=10r/s;

#说明
limit_req_zone $binary_remote_addr zone=req_zone:10m rate=10r/s;
$binary_remote_addr：用 IP 做限制 key
zone=req_zone:10m：定义一块内存区域，名字 req_zone，大小 10M
rate=10r/s：每秒只允许 10 个请求

limit_req zone=req_zone burst=20 nodelay;
burst=20：排队最多 20 个请求
nodelay：超过排队直接返回 429，不等待


# ====================== 2. 连接数限制（防大量并发）======================
# 定义连接限制：name=conn_zone，1个IP占10M内存
limit_conn_zone $binary_remote_addr zone=conn_zone:10m;

#说明
表示：同一个 IP 最多同时 10 个连接
limit_conn conn_zone 10;






```

***

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2、在 server /location 中使用（生产真实示例）</font>

```nginx
server {
  listen 80;
  server_name www.xxx.com;
  root /usr/share/nginx/html;
  index index.html;

  # 日志
  access_log /var/log/nginx/www.xxx.com.log;

  # ====================== 全局启用限流 ======================
  # 请求频率限制
  # burst=20 → 排队缓冲20个请求
  # nodelay → 超过直接拒绝，不等待
  limit_req zone=req_zone burst=20 nodelay;

  # 连接数限制：同一个IP最多 10 个并发连接
  limit_conn conn_zone 10;

  # 超过限制返回 503
  limit_req_status 429;
  limit_conn_status 429;

  location / {
    try_files $uri $uri/ /index.html;
  }

  # 针对接口 stricter 限流
  location /api/ {
    limit_req zone=req_zone burst=10 nodelay;
    proxy_pass http://backend;
  }
}
```

## 最终生产最佳组合

```bash
http {
    ###########################################################
    # 一、定义限流规则（必须放在 http 块内，全局生效）
    # 两个模块：请求频率限制(limit_req) + 并发连接限制(limit_conn)
    # 核心作用：防CC攻击、恶意爬虫、高频刷接口、超大并发攻击
    ###########################################################

    # ====================== 1. 请求频率限制配置（最常用，防CC攻击）======================
    # $binary_remote_addr：以客户端IP作为限流维度（二进制格式，节省内存）
    # zone=req_zone:10m：定义共享内存区域
    #   req_zone = 规则名称（自定义）
    #   10m      = 分配10M内存，可存储约8万+个IP的限流状态（生产标准大小）
    # rate=15r/s：限速规则 → 每秒允许单个IP发起 15 个正常请求
    limit_req_zone $binary_remote_addr zone=req_zone:10m rate=15r/s;

    # ====================== 2. 并发连接限制配置（防恶意并发连接）======================
    # $binary_remote_addr：以客户端IP作为限制维度
    # zone=conn_zone:10m：定义共享内存区域
    #   conn_zone = 规则名称（自定义）
    #   10m       = 分配10M内存存储IP连接状态
    limit_conn_zone $binary_remote_addr zone=conn_zone:10m;


    ###########################################################
    # 二、站点配置：应用限流规则到具体网站
    ###########################################################
    server {
        listen 80;
        server_name www.xxx.com;
        root /usr/share/nginx/html;

        # ====================== 启用请求频率限制 ======================
        # zone=req_zone：调用上方定义的请求限流规则
        # burst=30：缓冲队列 → 允许最多排队 30 个突发请求（保护服务器不被瞬间打崩）
        # nodelay：核心参数 → 超过速率+队列的请求，直接拒绝（不等待、不延迟，立即拦截）
        limit_req zone=req_zone burst=30 nodelay;

        # ====================== 启用并发连接限制 ======================
        # conn_zone：调用上方定义的连接限制规则
        # 15：单个IP 最多允许同时建立 15 个TCP并发连接
        limit_conn conn_zone 15;

        # ====================== 限流返回状态码配置 ======================
        # 超过请求频率限制 → 直接返回 429（标准：请求过多）
        # 替代默认503，更符合HTTP规范，对SEO/前端更友好
        limit_req_status 429;
        # 超过并发连接限制 → 直接返回 429
        limit_conn_status 429;

        # 默认站点根目录配置
        location / {
            try_files $uri $uri/ /index.html;
        }
    }
}
```

* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">limit_req</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：限制</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">每秒请求数</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，防 CC、防刷接口</font>
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">limit_conn</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：限制</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">同时连接数</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，防大量并发</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">两个一起开 = </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Nginx 层最强大免费防火墙</font>**

```plain
echo '10.0.0.4 game.oldboy.com' >> /etc/hosts
# a主机访问
yum install -y httpd-tools

# n总请求数 c并发数
ab -n 500000 -c 20  http://game.oldboy.com/index.html  

# 再a主机访问没结束的时候, B主机访问 会卡住 被拒绝
yum install -y httpd-tools
ab -n 500000 -c 20  http://game.oldboy.com/index.html 



#压力测试 #另一台centos测试
yum install -y httpd-tools
echo '10.0.0.4 game.oldboy.com' >> /etc/hosts
ab -n 50 -c 20  http://game.oldboy.com/index.html
Complete requests:      50  # 成功
Failed requests:        46  # 失败的
```

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

# **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">nginx 日志配置</font>**

```bash
# tail -f /var/log/nginx/access.log  
10.0.0.1 - - [19/Sep/2018:08:43:45 +0800] "GET /favicon.ico HTTP/1.1" 503 615 "http://game.oldboy.com/""Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.90 Safari/537.36 2345Explorer/9.4.2.17629" "-"
ip地址 - 用户名- 时间 请求方法get  路径 协议  状态码 响应文件大小 上一个页面  客户端浏览器  记录客户端真实ip

```

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">log_format指令</font>**

```bash
配置语法: 包括: error.log access.log
Syntax: log_format name [escape=default|json] string ...;
Default: log_format combined "...";
Context: http

#默认Nginx定义日志语法
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
'$status $body_bytes_sent "$http_referer" '
'"$http_user_agent" "$http_x_forwarded_for"';

Nginx日志格式允许包含的变量：
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

● 注:如果Nginx位于负载均衡器，nginx反向代理之后， web服务器无法直接获取到客户端真实的IP地址。
● $remote_addr获取的是反向代理的IP地址。 反向代理服务器在转发请求的http头信息中，
● 增加X-Forwarded-For信息，用来记录客户端IP地址和客户端请求的服务器地址。




```

## **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">access_log指令</font>**

```plain
Syntax: access_log path [format [buffer=size] [gzip[=level]][flush=time] [if=condition]];
access_log off;
Default: access_log logs/access.log combined;
Context: http, server, location, if in location, limit_except

Example: server {  ...  access_log /var/log/nginx/www.bgx.com.log;  ...



```

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

#### **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">日志切割定义文件</font>**

```bash
[root@nfs oldboy_code]# cat /etc/logrotate.d/nginx
/var/log/nginx/*.log {
        daily
        missingok
        rotate 52
        compress
        delaycompress
        notifempty
        create 640 nginx adm
        sharedscripts
        postrotate
                if [ -f /var/run/nginx.pid ]; then
                        kill -USR1 `cat /var/run/nginx.pid`
                fi
        endscript
}
```

#### **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">时间日志定义格式 位置</font>**

```plain
[root@web01 nginx]# cat /etc/nginx/nginx.conf
http {
```

```
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';

access_log  /var/log/nginx/access.log  main;
```

```
}
```

#### **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">时间日志指定位置 access_log</font>**

```plain
# cat /etc/nginx/conf.d/oldboy_game.conf
server {
  listen 80;
  server_name game.oldboy.com;
  charset utf-8,gbk;
  access_log /var/log/nginx/game.log  main;
  location / {
    root /oldboy_code;
    index index.html;
    }
  location /centos {
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
    root /oldboy_code;
    auth_basic "plase passwd user";
    auth_basic_user_file /etc/nginx/auth_conf;
    access_log /var/log/nginx/game.centos.log main;
    }
}
```

# **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Nginx虚拟站点</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">所谓虚拟主机，及在一台服务器上配置多个网站</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">如: 公司主页、博客、论坛看似三个网站, 实则可以运行在一台服务器上。</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

## **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">基于域名的 配置</font>**

```bash
# cat /etc/nginx/conf.d/oldboy_avi.conf
server{
  listen 80;
  server_name avi.oldboy.com;
  location / {
    root /oldboy_code2;
    index index.html;
    }
}

# 创建目录 创建index.html
mkdir -p /oldboy_code2
echo "avi" > /oldboy_code2/index.html

# window 主机 域名 对应关系(域名解析) 配置 C:\Windows\System32\drivers\etc


```

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

## **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">基于端口虚拟主机配置实战</font>**

```plain
//仅修改listen监听端口即可, 但不能和系统端口出现冲突 server {  ...  listen 8001;  ... }
server {  ...  listen 8002;  ... }
修改端口 配置文件

# cat /etc/nginx/conf.d/oldboy_edu.conf
server{
  listen 8081;
  server_name edu.oldboy.com;
  location / {
    root /oldboy_code3;
    index index.html;
    }
}
# cat /etc/nginx/conf.d/oldboy_avi.conf
server{
  listen 8080;
  server_name avi.oldboy.com;
  location / {
    root /oldboy_code2;
    index index.html;
    }
}


浏览器览器访问
http://10.0.0.7:8081/ 
http://10.0.0.7:8080/
基于端口的多网站 (一般)  
1 如果网站都是使用不同端口访问,那使用域名和不使用域名没有什么影响.  注意: 只有公司内部才会使用

```

# **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Nginx Location</font>**

> **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">使用Nginx Location控制访问网站规则</font>**
>
> **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">一个server可以有多个location配置，但多个location配置的优先级又该如何划分</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Location语法规则:</font>**

```plain
location [修饰符] 匹配路径 {
    # 匹配成功后执行的配置
}

location [=|^~|~|~|!~|!~|/] /uri/ { ... }
```

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Location优先级如\[]号显示</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">匹配符 匹配规则 优先级 = 精确匹配</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 1 ^~ 以某个字符串开头</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 2 ~ 区分大小写的正则匹配 </font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3 ~</font>**\_ 不区分大小写的正则匹配 \_

\_4 !~ 区分大小写不匹配的正则 \_

*5 !~***<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 不区分大小写不匹配的正则</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 6 / 通用匹配，任何请求都会匹配到 </font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">7常用的 / ~ ~* =</font>*\*

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">修饰符</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">匹配类型</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心含义</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">优先级</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">生产示例</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">关键备注</font>** |
| --- | --- | --- | --- | --- | --- |
| <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">=</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">精准匹配</font>** | **完全等于**\*\*<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">路径，匹配立即终止</font>\*\* | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1（最高）</font>** | <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">location = /api/login</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">速度最快，专用首页 / 固定接口</font>** |
| <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">^~</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">前缀匹配</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">以指定路径</font>****开头****<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，匹配后</font>****不检查正则** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2</font>** | <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">location ^~ /static/</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">静态资源专用，屏蔽正则干扰</font>** |
| <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">~</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">正则匹配</font>** | **区分大小写****<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，正则表达式匹配</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3</font>** | <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">location ~ \.php$</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">匹配.php、.jsp 等后缀</font>** |
| <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">~*</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">正则匹配</font>** | **不区分大小写**\*\*<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，正则表达式匹配</font>\*\* | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3</font>** | <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">location ~* \.PNG$</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">匹配图片 / 静态资源（无视大小写）</font>** |
| <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">!~</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">正则取反</font>** | **区分大小写**\*\*<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，</font>****不匹配****<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">正则才生效</font>\*\* | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">4</font>** | <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">location !~ \.sh$</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">拒绝 / 拦截指定后缀请求</font>** |
| <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">!~*</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">正则取反</font>** | **不区分大小写**\*\*<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，</font>****不匹配****<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">正则才生效</font>\*\* | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">4</font>** | <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">location !~* \.exe$</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">拦截恶意文件请求</font>** |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">普通前缀</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">以指定路径开头，继续匹配正则</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">5</font>** | <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">location /api/</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">通用路径匹配</font>** |
| <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">通用匹配</font>** | **匹配所有请求**\*\*<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，兜底规则</font>\*\* | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">6（最低）</font>** | <code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">location /</font>**</code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">所有未匹配请求走这里</font>** |

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

```plain
通用匹配，任何请求都会匹配到
location / {
}
严格区分大小写，匹配以.php结尾的都走这个location
location ~ \.php$ {
fastcgi_pass http://127.0.0.1:9000;
}
严格区分大小写，当用户访问/.zip结尾，统统全部拒绝
location ~ \.zip$ {
deny  all;
}
不区分大小写匹配，只要用户访问.jpg,gif,png,js,css 都走这条location
location ~* .*\.(jpg|gif|png|js|css)$ {
root /code/xuliangwei;
expires 7d;
#rewrite (.*) http://cdn.xuliangwei.com$request_uri;
}
不区分大小写匹配，
location ~* "\.(sql|bak|tgz|tar.gz|.git)$" {
return 403 "启用访问控制成功";
}

日志模块 虚拟主机（一台服务器运行多个网站） location的匹配符 location的优先级
```

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">8.Nginx常见问题  多Server_name都配置IP会产生冲突，冲突后优先级是怎么回事？ </font>**

```bash
# 加了 default_server → IP 访问强制走这里
server {
    listen 80 default_server;  # 👈 核心
    server_name 192.168.1.100;
    root /data/web;
}

server {
    listen 80;
    server_name 192.168.1.100;
    root /usr/share/nginx/html;
}



多个 server_name 配置相同 IP + 监听同端口 = 一定会冲突
冲突优先级：
default_server > 配置文件中第一个出现的 server > 其他
解决冲突最简单方法：
给你想让 IP 访问的那个 server，加上 listen 80 default_server;
```

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>**

翻译:

```plain
select 选择
epool 网络模型 nginx采用的网络模型
Mainline  主流 主线
Mainline version  开发版
stable   稳定
legacy   遗产   
Legacy version  历史版本
version  版本
enable   开启
code     代码
built	 建造
support  支持
configure  安装配置
arguments   参数
prefix  	前缀
modules		模块
threads		线程
addition	加法
request		请求
auth		认证
random		随机的
index       索引
secure		安全的
slice		切片
status		状态
protector	保护者
switches	开关
core		核心
coremodule	核心模块
event		事件
eventmodule  事件模块
HttpCoreModule  http内核模块
location      位置 定位
worker		 工人 劳动者
connetctions  企业人脉 ,连接
processes		进程
include			包含
application     应用 申请
send          发送
sendfile		发送文件
keepalive		保持连接
access  		使用 访问
successful		成功的
syntax			语法
reload			重载
drivers			驱动程序
autoindex 		自动索引
localtime		本地时间
exact			精确的
size			大小
status			状态
syntax			语法
active 			活跃的
connections		连接
reading			阅读
writing			写作
waiting			等待
accepts			接受 同意
handled			已处理
requests		请求
keepalive		保持连接
deny			拒绝
allow			允许
auth			认证
basic			基本
auth_basic "one shu gan";
auth_basic_user_file /etc/nginx/auth_conf;
zone			地带 地区
binary          二进制
remote			远程
addr			地址
limit			限制 界限
burst			突发
nodelay			无延迟
```


> 更新: 2026-05-05 16:53:02  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/eq9pkg>