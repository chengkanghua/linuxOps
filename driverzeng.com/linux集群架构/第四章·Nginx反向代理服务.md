# 第四章·Nginx反向代理服务

## Nginx代理服务基本概述

| 什么是代理 |
| :--- |

*代理一词往往并不陌生, 该服务我们常常用到如(代理理财、代理租房、代理收货等等)，如下图所示*

<!-- OCR_START -->
- 联系
- 查找
- 租房
- 中介
- 房源
<!-- OCR_END -->

| 没有代理情景 |
| :--- |

*在没有代理模式的情况下，客户端和*`_Nginx_`*服务端，都是客户端直接请求服务端，服务端直接响应客户端。*

<!-- OCR_START -->
- 请求
- 客户端
- 服务端
- 响应
<!-- OCR_END -->

| 企业场景 |
| :--- |

*那么在互联网请求里面,客户端往往无法直接向服务端发起请求,那么就需要用到代理服务,来实现客户端和服务通信，如下图所示*

<!-- OCR_START -->
- oldboyedu
- 1.请求资源
- 2.请求资源
- 客户端
- 代理
- 服务端
- 4.返回资源
- 3.返回资源
<!-- OCR_END -->

## Nginx代理服务常见模式

*Nginx作为代理服务,按照应用场景模式进行总结，代理分为正向代理、反向代理*

| 正向代理 |
| :--- |

*正向代理，(内部上网)客户端<—>代理->服务端*

<!-- OCR_START -->
- 正向代理
- ③
- DNS
- 客户端
- www.google.com
- 代理
- Google
<!-- OCR_END -->

| 反向代理 |
| :--- |

*反向代理，用于公司集群架构中，客户端->代理<—>服务端*

<!-- OCR_START -->
- 反向代理
- DNS
- 客户端
- 代理
- 博客网站
<!-- OCR_END -->

| 正向代理与反向代理的区别 |
| :--- |

*1.区别在于形式上服务的”对象”不一样*

*2.正向代理代理的对象是客户端，为客户端服务*

*3.反向代理代理的对象是服务端，为服务端服务*

## Nginx代理服务支持协议

*Nginx作为代理服务，可支持的代理协议非常的多，具体如下图*

<!-- OCR_START -->
- Nginx代理可支持的代理协议
- HTTP
- 代理->超文本传输协议
- HttpServer
- HTTPS
- 代理->http/https协议
- TCP
- 代理->tcp/dup协议
- TCPServer
- websocket
- 用户
- Nginx
- 代理->http1.1长链接通讯协议
- SocketServer
- GRPC
- 代理->go语言远程过程调用
- GrpcServer
- POP/IMAP
- 代理->邮件收发协议
- MailServer
- RTMP
- 代理->流媒体、直播、点播
- MediaServer
<!-- OCR_END -->

***

| 反向代理使用协议 |
| :--- |

*如果将Nginx作为反向代理服务，常常会用到如下几种代理协议，如下图所示*

<!-- OCR_START -->
- Nginx作为反向代理常用代理协议
- http_proxy
- ngx_http_proxy_module,
- Http
- Server
- fastcgi
- 用户
- Nginx
- ngx_http
- _fastcgi_module
- phpServer
- HTTPS
- uwcgi
- ngx_http_uwcgi_module
- pythonServer
- websocket
- Socket
- grpc
- ngx_http_v2
- module
- GrpcServer
- https.//www.driverzeng.com
<!-- OCR_END -->

***

| 模块总结 |
| :--- |

*反向代理模式与Nginx代理模块总结如表格所示*

| **反向代理模式** | **Nginx\*\*\*\*配置模块** |
| :--- | :--- |
| http、websocket、https | ngx_http_proxy_module |
| fastcgi | ngx_http_fastcgi_module |
| uwsgi | ngx_http_uwsgi_module |
| grpc | ngx_http_v2_module |

## Nginx反向代理配置语法

| 代理配置语法 |
| :--- |

```bash
Syntax:    proxy_pass URL;
Default:    —
Context:    location, if in location, limit_except
 
http://localhost:8000/uri/
http://192.168.56.11:8000/uri/
http://unix:/tmp/backend.socket:/uri/
```

***

| url跳转修改返回location |
| :--- |

`url`跳转修改返回`Location`\[不常用]

参考下载站点：<http://test.driverzeng.com/Nginx_File/>

```bash
Syntax:    proxy_redirect default;
proxy_redirect off;proxy_redirect redirect replacement;
Default:    proxy_redirect default;
Context:    http, server, location
```

***

| 添加发往后端服务器的请求头信息 |
| :--- |

```bash
Syntax:    proxy_set_header field value;
Default:    proxy_set_header Host $proxy_host;
            proxy_set_header Connection close;
Context:    http, server, location
 
# 用户请求的时候HOST的值是www.oldboy.com, 那么代理服务会像后端传递请求的还是www.oldboy.com
proxy_set_header Host $http_host;
# 将$remote_addr的值放进变量X-Real-IP中，$remote_addr的值为客户端的ip
proxy_set_header X-Real-IP $remote_addr;
# 客户端通过代理服务访问后端服务, 后端服务通过该变量会记录真实客户端地址
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```

***

| 代理到后端的TCP连接、响应、返回等超时时间 |
| :--- |

```bash
//nginx代理与后端服务器连接超时时间(代理连接超时)
Syntax: proxy_connect_timeout time;
Default: proxy_connect_timeout 60s;
Context: http, server, location
 
//nginx代理等待后端服务器的响应时间
Syntax:    proxy_read_timeout time;
Default:    proxy_read_timeout 60s;
Context:    http, server, location
 
//后端服务器数据回传给nginx代理超时时间
Syntax: proxy_send_timeout time;
Default: proxy_send_timeout 60s;
Context: http, server, location
```

***

| proxy_buffer代理缓冲区 |
| :--- |

```bash
//nignx会把后端返回的内容先放到缓冲区当中，然后再返回给客户端,边收边传, 不是全部接收完再传给客户端
Syntax: proxy_buffering on | off;
Default: proxy_buffering on;
Context: http, server, location
 
//设置nginx代理保存用户头信息的缓冲区大小
Syntax: proxy_buffer_size size;
Default: proxy_buffer_size 4k|8k;
Context: http, server, location
 
//proxy_buffers 缓冲区
Syntax: proxy_buffers number size;
Default: proxy_buffers 8 4k|8k;
Context: http, server, location
```

***

| 常用优化配置 |
| :--- |

*Proxy代理网站常用优化配置如下，将配置写入新文件，调用时使用include引用即可*

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

***

| 重复使用配置 |
| :--- |

*代理配置location时调用方便后续多个Location重复使用*

```bash
location / {
    proxy_pass http://127.0.0.1:8080;
    include proxy_params;
}
```

## Nginx反向代理场景实践

| Nginx反向代理配置实例 |
| :--- |

<!-- OCR_START -->
- oldboyedu
- 反向
- 请求反向代理80端口
- 代理向后端转发请求
- 客户端
- 服务端
- 代理
- 转发至后端的8080
- 10.0.0.1
- 10.0.0.5:80
- 172.16.1.5：随机端口
- 172.16.1.7:8080
<!-- OCR_END -->

***

| 环境准备 |
| :--- |

| **角色** | **外网\*\*\*\*IP(NAT)** | **内网\*\*\*\*IP(LAN)** | **主机名** |
| :--- | :--- | :--- | :--- |
| Proxy | eth0:10.0.0.5 | eth1:172.16.1.5 | lb01 |
| web01 | eth0:10.0.0.7 | eth1:172.16.1.7 | web01 |

***

| 配置需求 |
| :--- |

*web01服务器,配置一个网站，监听在8080此时网站仅172网段的用户能访问*

```bash
[root@web01 ~]# cd /etc/nginx/conf.d/
[root@web01 conf.d]# vim web.conf
server {
    listen 8080;
    server_name localhost;
 
    location / {
        root /code_8080;
        index index.html;
        deny 10.0.0.0/24;
        allow all;
    }
}
[root@web01 conf.d]# mkdir /code_8080
[root@web01 conf.d]# echo "web01-7...." >/code_8080/index.html
[root@web01 conf.d]# systemctl restart nginx
```

***

| 配置需求 |
| :--- |

*proxy代理服务,配置监听eth0的80端口，使10.0.0.0网段的用户，能够通过代理服务器访问到后端的172.16.1.7的8080端口站点内容*

```bash
[root@lb01 ~]# cd /etc/nginx/conf.d/
[root@lb01 conf.d]# cat proxy_web_node1.conf 
server {
    listen 80;
    server_name nginx.oldboy.com;
 
    location / {
        proxy_pass http://172.16.1.7:8080;
        include proxy_params;
    }
}
 
[root@lb01 conf.d]# systemctl enable nginx
[root@lb01 conf.d]# systemctl start nginx
```

> 更新: 2024-09-23 16:19:46  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/cgxspp>