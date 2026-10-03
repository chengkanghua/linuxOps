# 第二章·Nginx常用基础模块

## Nginx目录索引

| 目录索引模块简述 |
| :--- |

`ngx_http_autoindex_module`模块处理以斜杠字符（'/'）结尾的请求，并生成目录列表。

当`ngx_http_index_module`模块找不到索引文件时，通常会将请求传递给`ngx_http_autoindex_module`模块。

***

| 配置 |
| :--- |

`Nginx`默认是不允许列出整个目录浏览下载。

```bash
Syntax:    autoindex on | off;
Default:    autoindex off;
Context:    http, server, location
 
# autoindex常用参数
autoindex_exact_size off;
默认为on， 显示出文件的确切大小，单位是bytes。
修改为off，显示出文件的大概大小，单位是kB或者MB或者GB。
 
autoindex_localtime on;
默认为off，显示的文件时间为GMT时间。
修改为on， 显示的文件时间为文件的服务器时间。
 
charset utf-8,gbk;
默认中文目录乱码，添加上解决乱码。
```

配置示例：

```bash
[root@web01 ~]# vim /etc/nginx/conf.d/module.conf
server {
    listen 80;
    server_name module.driverzeng.com;
    charset utf-8,gbk;
    localtion / {
        root /code;
        index index.html index.htm;
    }
    location /download {
        alias /module;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }
}
```

## Nginx状态监控

`ngx_http_stub_status_module`模块提供对基本状态信息的访问。

默认情况下不构建此模块，应使用`--with-http_stub_status_module`配置参数启用它

***

| 配置 |
| :--- |

```bash
Syntax: stub_status;
Default: —
Context: server, location
```

配置`Nginx status`示例

```bash
server {
    listen 80;
    server_name module.driverzeng.com;
    access_log off;
 
    location /nginx_status {
        stub_status;
    }
}
server {
        listen 80;
        server_name module.driverzeng.com;
        charset utf-8,gbk;
        localtion / {
                root /code;
                index index.html index.htm;
        }
        location /download {
                alias /module;
                autoindex on;
                autoindex_exact_size off;
                autoindex_localtime on;
        }
        location /nginx_status {
                stub_status;
        }
}
```

打开浏览器访问：<http://module.driverzeng.com/nginx_status>

<!-- OCR_START -->
- Chrome
- 文件
- 编辑
- 视图
- 历史记录
- 书签用户
- 窗口
- 帮助
- module.driverzeng.com/nginx_
- 不安全|module.driverzeng.com/nginx_status
- 应用
- 1
- TTS
- zabbix-api
- Active connections:2
- server accepts handled requests
- 2424203
- Reading:0 Writing:1 Waiting:1
<!-- OCR_END -->

```bash
Active connections  # 当前活动的连接数
accepts             # 当前的总连接数TCP
handled             # 成功的连接数TCP
requests            # 总的http请求数
Reading             # 请求
Writing             # 响应
Waiting             # 等待的请求数，开启了keepalive
# 注意, 一次TCP的连接，可以发起多次http的请求, 如下参数可配置进行验证
keepalive_timeout  0;   # 类似于关闭长连接
keepalive_timeout  65;  # 65s没有活动则断开连接
```

## Nginx访问控制

基于IP的访问控制 `http_access_module`

基于用户登陆认证 `http_auth_basic_module`

***

| nginx基于IP的访问控制 |
| :--- |

```bash
#允许配置语法
Syntax:    allow address | CIDR | unix: | all;
Default:    —
Context:    http, server, location, limit_except
 
#拒绝配置语法
Syntax:    deny address | CIDR | unix: | all;
Default:    —
Context:    http, server, location, limit_except
```

1\)访问控制配置示例,拒绝指定的IP,其他全部允许

```bash
server {
    listen 80;
    server_name module.driverzeng.com;
    access_log off;
 
    location /nginx_status {
        stub_status;
        deny 10.0.0.1;
        allow all;   
    }
}
```

2. 访问控制配置示例, 只允许谁能访问, 其它全部拒绝

```bash
server {
    listen 80;
    server_name module.driverzeng.com;
    access_log off;
 
    location /nginx_status {
        stub_status;
        allow   10.0.0.0/24;
        allow   127.0.0.1;
        deny    all;
    }
}
```

***

| Nginx基于用户登陆认证 |
| :--- |

1\)基于用户登陆认证配置语法

```bash
#访问提示字符串
Syntax: auth_basic string| off;
Default: auth_basic off;
Context: http, server, location, limit_except
 
#账户密码文件
Syntax: auth_basic_user_file file;
Default: -
Context: http, server, location, limit_except
```

2\)基于用户登陆认证配置实践

```bash
#1.需要安装httpd-tools，该包中携带了htpasswd命令
[root@web01 ~]# yum install httpd-tools
#2.创建新的密码文件, -c创建新文件 -b允许命令行输入密码
[root@web01 ~]# htpasswd -b -c /etc/nginx/auth_conf zls zls
 
#3.nginx配置调用
server {
    listen 80;
    server_name module.driverzeng.com;
    access_log off;
 
    location /nginx_status {
        stub_status;
        auth_basic "Auth access Blog Input your Passwd!";
        auth_basic_user_file auth_conf;
    }
}
```

## Nginx访问限制

在企业中经常会遇到这种情况，服务器流量异常，负载过大等等。对于大流量恶意的攻击访问， 会带来带宽的浪费，服务器压力，影响业务，往往考虑对同一个ip的连接数，请求数、进行限制。

`ngx_http_limit_conn_module`模块可以根据定义的`key`来限制每个键值的连接数，如同一个IP来源的连接数。

`limit_conn_module` 连接频率限制

`limit_req_module` 请求频率限制

***

| Nginx连接限制配置实战 |
| :--- |

1\)`Nginx`连接限制配置语法

```bash
#模块名ngx_http_limit_conn_module
Syntax:     limit_conn_zone key zone=name:size;
Default: —
Context: http
 
Syntax:    limit_conn zone number;
Default: —
Context: http, server, location
```

2\)`Nginx`连接限制配置实践

**在一个公网Nginx中配置**

```bash
http{   #http层，设置
    # Limit settings
    limit_conn_zone $remote_addr zone=conn_zone:10m;
server{ #server层调用
    #连接限制，限制同时最高1个连接
    limit_conn conn_zone 1;
    }
}
```

3\)使用`ab`工具进行压力测试

```bash
[root@web01 ~]# yum install -y httpd-tools
[root@web01 ~]# ab -n 20 -c 2  http://127.0.0.1/index.html
```

4\)nginx日志结果

```bash
2018/10/24 18:04:49 [error] 28656#28656: *1148 limiting connections by zone "conn_zone", client: 123.66.146.123, server: www.driverzeng.com, request: "GET / HTTP/1.0", host: "www.driverzeng.com"
2018/10/24 18:04:49 [error] 28656#28656: *1155 limiting connections by zone "conn_zone", client: 123.66.146.123, server: www.driverzeng.com, request: "GET / HTTP/1.0", host: "www.driverzeng.com"
2018/10/24 18:04:49 [error] 28656#28656: *1156 limiting connections by zone "conn_zone", client: 123.66.146.123, server: www.driverzeng.com, request: "GET / HTTP/1.0", host: "www.driverzeng.com"
```

***

| Nginx请求限制配置实战 |
| :--- |

朋友公司Nginx配置文件:[TP](http://download.driverzeng.com/nginx.txt)

企业真实案例：

<!-- OCR_START -->
location
/crawler
#请求限速，如果请求数超过1，则后续全拒绝，则会出现412状态，
41
limit_req zone=crawips burst=l nodelay:
limit_req_status 412;
error_page412/m/newerrorcode.json;
对对对。是这个。
棒啊。
你们公司的nginx配置文件写的挺规范
嗯都比较规范
我现在教他们nginx，
就准备用这个举例子
F.Phh.
嗯好
太感谢了
<!-- OCR_END -->

1\)`Nginx`请求限制配置语法

```bash
#模块名ngx_http_limit_req_module
Syntax:     limit_req_zone key zone=name:size rate=rate;
Default: —
Context: http
 
Syntax:    limit_req zone number [burst=number] [nodelay];
Default: —
Context: http, server, location
```

2\)`Nginx`请求限制配置实战

```bash
# http标签段定义请求限制, rate限制速率，限制一秒钟最多一个IP请求
http {
    limit_req_zone $binary_remote_addr zone=req_zone:10m rate=1r/s;
}
server {
    listen 80;
    server_name module.oldboy.com;
    # 1r/s只接收一个请求,其余请求拒绝处理并返回错误码给客户端
    #limit_req zone=req_zone;
 
    # 请求超过1r/s,剩下的将被延迟处理,请求数超过burst定义的数量, 多余的请求返回503
    limit_req zone=req_zone burst=3 nodelay;
    location / {
        root /code;
        index index.html;
    }
}
```

3\)使用`ab`工具进行压力测试

```bash
[root@oldboyedu ~]# yum install -y httpd-tools
[root@oldboyedu ~]# ab -n 20 -c 2  http://127.0.0.1/index.html
```

4\)nginx日志结果

```bash
2018/10/24 07:38:53 [error] 81020#0: *8 limiting requests, excess: 3.998 by zone "req_zone", client: 10.0.0.10, server: module.driverzeng.com, request: "GET /index.html HTTP/1.0", host: "10.0.0.10"
2018/10/24 07:38:53 [error] 81020#0: *9 limiting requests, excess: 3.998 by zone "req_zone", client: 10.0.0.10, server: module.driverzeng.com, request: "GET /index.html HTTP/1.0", host: "10.0.0.10"
2018/10/24 07:38:53 [error] 81020#0: *10 limiting requests, excess: 3.998 by zone "req_zone", client: 10.0.0.10, server: module.driverzeng.com, request: "GET /index.html HTTP/1.0", host: "10.0.0.10"
```

5）nginx请求限制重定向（扩展）

在nginx请求限制的过程中，我们可以自定义一个返回值，也就是错误页面的状态码。

默认情况下是`503`

<!-- OCR_START -->
- 4Web
- 文件
- 还让
- 视图
- 发布
- 窗口
- 帮助
- 503ServiceTemporarilyUnavax
- ①不安全|module.driverzeng.com
- 应用TTTSzabbix-api
- 503ServiceTemporarilyUnavailable
- nginx/1.16.0
<!-- OCR_END -->

1）修改默认返回状态码

```bash
server {
        listen 80;
        server_name module.driverzeng.com;
        charset utf-8,gbk;
        location / {
                root /code;
                index index.html index.htm;
                limit_req zone=req_zone burst=3 nodelay;
                #修改返回状态码为：478
                limit_req_status 478
        }
}
```

<!-- OCR_START -->
- Chrome
- 文件
- 编辑
- 视图
- 历史记录
- 书签
- 用户
- 窗口
- 帮助
- module.driverzeng.com
- 应用TTTS
- zabbix-api
- 该网页无法正常运作
- 如果问题仍然存在，请与网站所有者联系。
- HTTP ERROR 478
- 重新加载
<!-- OCR_END -->

2）页面太丑，重定向页面

```bash
server {
        listen 80;
        server_name module.driverzeng.com;
        charset utf-8,gbk;
        location / {
                root /code;
                index index.html index.htm;
                limit_req zone=req_zone burst=3 nodelay;
                limit_req_status 478
                #重定错误页面
                error_page 478 /err.html;
        }
}
vim /code/err.html
<img style='width:100%;height:100%;' src=https://www.driverzeng.com/zenglaoshi/478_page.png>
```

<!-- OCR_START -->
- 文件
- 历史记录
- 窗口
- 帮助
- module.driverzeng.com
- C不安全| module.driverzeng.com
- 应用↑TTSzabbix-api
- HTTPERRORCODE:478
- 请求被限制了哟..
- 操作太快了.慢点
<!-- OCR_END -->

***

***

| Nginx连接限制没有请求限制有效？ |
| :--- |

我们先来回顾一下**http**协议的连接与请求，首先**HTTP**是建立在**TCP**基础之上,在完成**HTTP**请求需要先建立**TCP**三次握手（称为**TCP**连接）,在连接的基础上在完成**HTTP**的请求。

所以多个HTTP请求可以建立在一次**TCP**连接之上, 那么我们对请求的精度限制，当然比对一个连接的限制会更加的有效，因为同一时刻只允许一个**TCP**连接进入, 但是同一时刻多个**HTTP**请求可以通过一个**TCP**连接进入。所以针对**HTTP**的请求限制才是比较优的解决方案。

## Nginx Location

使用`Nginx Location`可以控制访问网站的路径,但一个`server`可以有多个`location`配置, 多个`location`的优先级该如何区分

***

| Location语法示例 |
| :--- |

```bash
location [=|^~|~|~*|!~|!~*|/] /uri/ { ...
}
```

***

| Location语法优先级排列 |
| :--- |

| **匹配符** | **匹配规则** | **优先级** |
| :--- | :--- | :--- |
| = | 精确匹配 | 1 |
| ^~ | 以某个字符串开头 | 2 |
| ~ | 区分大小写的正则匹配 | 3 |
| ~\* | 不区分大小写的正则匹配 | 4 |
| !~ | 区分大小写不匹配的正则 | 5 |
| !~\* | 不区分大小写不匹配的正则 | 6 |
| / | 通用匹配，任何请求都会匹配到 | 7 |

***

| 配置网站验证Location优先级 |
| :--- |

```bash
[root@Nginx conf.d]# cat testserver.conf 
server {
    listen 80;
    server_name www.driverzeng.com;
    location / {
        default_type text/html;
        return 200 "location /";
    }
 
    location =/ {
        default_type text/html;
        return 200 "location =/";
    }
 
    location ~ / {
        default_type text/html;
        return 200 "location ~/";
    }
 
    # location ^~ / {
    #   default_type text/html;
    #   return 200 "location ^~";
    # }
}
```

***

| 测试Location效果 |
| :--- |

```bash
# 优先级最高符号=
[root@Nginx conf.d]# curl www.driverzeng.com
location =/
 
# 注释掉精确匹配=, 重启Nginx
[root@Nginx ~]# curl www.driverzeng.com
location ~/
 
# 注释掉~, 重启Nginx
[root@Nginx ~]# curl www.driverzeng.com
location /
```

***

| Locaiton应用场景 |
| :--- |

```bash
# 通用匹配，任何请求都会匹配到
location / {
    ...
}
 
# 严格区分大小写，匹配以.php结尾的都走这个location    
location ~ \.php$ {
    ...
}
 
# 严格区分大小写，匹配以.jsp结尾的都走这个location 
location ~ \.jsp$ {
    ...
}
 
# 不区分大小写匹配，只要用户访问.jpg,gif,png,js,css 都走这条location
location ~* .*\.(jpg|gif|png|js|css)$ {
    ...
}
 
# 不区分大小写匹配
location ~* "\.(sql|bak|tgz|tar.gz|.git)$" {
    ...
}
```

> 更新: 2024-09-22 20:10:55  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ngsb0g>