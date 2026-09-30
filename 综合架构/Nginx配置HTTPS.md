# Nginx配置HTTPS

```bash
keepalived
 7x24小时不DOWN场景
 2台服务器
 主 优先级150 virtu_router_id 50 lb01
 备 优先级100 virtu_router_id 50 lb02
 列脑（主和备上面都有虚拟IP --->俗称VIP）
 解决办法：执行脚本
 1.keepalived造成故障：主和备上都编写一个脚本：
   1.备判断自己是否能ping通主
   2.检查自己是否存在VIP
   3.建议使用kill命令杀死备机的keepalived
 2.Nginx故障，导致请求通过VIP找到Master服务器无法提供服务。
   1.检查Nginx的进程是否存在，如果存在则sleep 5秒，再次检查
   2.如果不存在，则尝试启动一次Nginx
   3.如果启动成功，进入下一步，sleep 5秒
   4.如果启动不成功，强制杀掉keepalived让地址漂移至备机
   5.建议写在Master上面即可。
 3.keepalived用在哪
   国企，传统互联网，全是物理服务器
 4.keepalived不能用在哪
   1.互联网--->使用公有云的 (LB)
   2.公有云不能使用keepalived工具，公有云本身负载均衡支持高可用
 5.面试被问到：你们高可用如何实现的？？
 我们使用公有云的LB负载均衡，本身厂商就支持高可用，所以这一块我们没做考虑。
 但：如果贵公司使用的是硬件服务器，那么也可以使用keepalived开源软件实现高可用。

虚拟机上面：
 一台服务器的https
 前端负载均衡，后端是web服务器，实现https
阿里云：
 ecs 运行一个nginx 启用https
 slb+ecs实现https

```

## 1.Rewrite基本概述

*1.什么是rewrite*

`Rewrite`即`URL`重写， 主要实现`url`地址重写, 以及重定向, 就是把传入`Web`的请求重定向到其他`URL`的过程。

*2.Rewrite使用场景*

1.`URL`地址跳转，例如用户访问`bgx.com`将其跳转到`xuliangwei.com` , 或者当用户通过`http`的方式访问`bgx.com`时， 将其跳转至`https`的方式访问`bgx.com`\
2.`URL`伪静态, 将`动态页面显示为静态页面`方式的一种技术, 便于搜索引擎的录入, 同时减少 动态URL地址对外暴露过多的参数, 提升更高的安全性。\
3.搜索引擎`SEO`优化依赖于`url`路径, 以便支持搜索引擎录入

## 2.Rewrite配置语法

Rewrite示例

```bash
Syntax: rewrite regex replacement [flag];
Default: --
Context: server, location, if
```

*在匹配过程中可以引用一些Nginx的全局变量*

> $document_root 针对当前请求的根路径设置值;(网站根目录)
>
> $host 请求信息中的"Host"，如果请求中没有Host行，则等于设置的服务器名;
>
> $request_filename 当前请求的文件路径名（带网站的主目录`/code/images/test.jpg`）
>
> $request_uri 当前请求的文件路径名（不带网站的主目录`/images/test.jpg`）
>
> $scheme用的协议，比如http或者https
>
> $request_filename; <http://ds.oldboy.com/nginx.png> --》 /soft/code/images/nginx.png $request_uri; <http://ds.oldboy.com/nginx.png> --》 /nginx.png

`Rewrite`匹配优先级

> 1.执行server块的rewrite指令
>
> 2.执行location匹配
>
> 3.执行选定的location中的rewrite

## 配置开启nginx rewrite 日志

```bash
1.设置 /etc/nginx/nginx.conf  中错误日志级别为 notice (nginx 中最低级别的错误)
error_log  /var/log/nginx/error.log notice;

2. 在http模块层, 增加一行 rewrite 日志
rewrite_log     on;

3 配置rewrite 测试日志是否生效
cat >/etc/nginx/conf.d/rewrite.conf<<EOF
server {
  listen 80;
  server_name r.oldboy.com;
  location  / {
    rewrite ^/ https://www.xuliangwei.com;
  }
}
EOF
4. 重启nginx
nginx -t
systemctl restart nginx


hosts 修改
ip r.oldboy.com
浏览器 安装http status 插件 访问  r.oldboy.com

# tail -f /var/log/nginx/error.log
2018/09/29 15:49:58 [notice] 2907#2907: *1 "^/" matches "/", client: 10.0.0.1, server: r.oldboy.com, request: "GET / HTTP/1.1", host: "r.oldboy.com"
2018/09/29 15:49:58 [notice] 2907#2907: *1 rewritten redirect: "https://www.xuliangwei.com", client: 10.0.0.1, server: r.oldboy.com, request: "GET / HTTP/1.1", host: "r.oldboy.com"


# tail /var/log/nginx/access.log
10.0.0.1 - - [29/Aug/2024:16:03:51 +0800] "GET / HTTP/1.1" 302 145 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36 Core/1.116.438.400 QQBrowser/13.0.6071.400" "-"



```

![1547290349378-a99c40e6-b5de-42a8-a785-b0c827512372.png](img/Nginx%E9%85%8D%E7%BD%AEHTTPS-01.png)

### 例1:用户访问/abc/1.html实际上真实访问是/cc/bb/2.html

```bash
# 配置好真实的路径
[root@web03 conf.d]# cat rewrite.conf
server {
  listen 80;
  server_name r.oldboy.com;
  location  / {
    root /code;
    index index.html;
  }
}
# 准备对应的站点目录
mkdir /code/cc/bb -p
echo "cc_bb2" >/code/cc/bb/2.html
nginx -t
systemctl restart nginx

# 配置rewrite 跳转规则
[root@web03 conf.d]# cat rewrite.conf
server {
  listen 80;
  server_name r.oldboy.com;
  location  / {
    root /code;
    index index.html;
    }
  # 不区分大小写匹配
  location ~* /abc/1.html {
    # 请求abc/1.html 跳转/code/cc/bb/2.html
    rewrite /abc/1.html /cc/bb/2.html;
    }
}

#windows hosts 解析  10.0.0.9 r.oldboy.com
# 浏览器访问 http://r.oldboy.com//abc/1.html

3 配置rewrite 跳转 修正一次
[root@web03 conf.d]# cat rewrite.conf
server {
  listen 80;
  server_name r.oldboy.com;
  location  / {
    root /code;
    index index.html;
    }
  location ~* /abc/1.html {
    # redirect 跳转标记 302 插件http status 能看到
    rewrite (.*) /cc/bb/2.html redirect;
    # 效果和 rewrite 一样 ,但是没有日志
    # return 302 /cc/bb/2.html;
    }
}
```

![1547290349788-f18d1a70-468c-42d6-b1a7-7fe5c50c9a7c.png](img/Nginx%E9%85%8D%E7%BD%AEHTTPS-02.png)

```bash
4.配置rewrite跳转规则【修订2次】
[root@web03 conf.d]# cat rewrite.conf 
server {
  listen 80;
  server_name r.oldboy.com;
  location / {
    root /code;
    index index.html;
    }
  #不区分大小写匹配
  location ~* /abc/1.html {
    return 302 /cc/bb/2.html;
    }
}
```

### 例2: 用户访问 /2018/ccc/bbb/2.html 实际上真是访问的事2014/ccc/bbb/2.html

```bash
1.先配置好真实的路径
server {
  listen 80;
  server_name r.oldboy.com;
  location / {
    root /code;
    index index.html;
  }
}
2.准备对应的站点目录
mkdir /code/2014/ccc/bbb -p
echo "2014" > /code/2014/ccc/bbb/2.html

3. 配置 rewrite跳转规则
[root@web03 conf.d]# cat rewrite.conf
server {
  listen 80;
  server_name r.oldboy.com;
  location  / {
    root /code;
    index index.html;
  }
  location ~* /2018/ccc/bbb/2.html {
    rewrite (.*) /2014/ccc/bbb/2.html redirect;
  }
}

nginx -t
systemctl restart nginx

浏览器访问 http://r.oldboy.com/2018/ccc/bbb/2.html

```

### 例3:用户访问/test目录下任何内容, 实际上真实访问是http://www.xuliangwei.com

```bash
# 配置文件  之前配置的location 全删除掉
[root@web03 conf.d]# cat rewrite.conf 
server {
  listen 80;
  server_name r.oldboy.com;
  location /test {
    rewrite (.*) https://www.xuliangwei.com;
  }
}
```

### 例4:用户访问course-11-22-33.html 实际上真实访问是 /course/11/22/33/course_33.html

```bash
1.先配置好真实的路径
server {
  listen 80;
  server_name r.oldboy.com;
  location / {
    root /code;
    index index.html;
  }
}
2.准备对应的站点目录
mkdir /code/course/11/22/33/ -p
echo "bgx123.com" > /code/course/11/22/33/course_33.html
systemctl restart nginx

3.配置rewrite跳转规则
[root@web03 conf.d]# cat rewrite.conf 
server {
  listen 80;
  server_name r.oldboy.com;
  location / {
    root /code;
    index index.html;
    #仅针对一条规则
    #rewrite ^/course-11-22-33.html /course/11/22/33/course_33.html;
    # 如果课程路径都一样, 那这条规则灵活度更高
    rewrite ^/(.*)-(.*)-(.*)-(.*).html /$1/$2/$3/$4/$1_$4.html;
  }
}

nginx -t
systemctl reload nginx
# 浏览器访问http://r.oldboy.com/course-11-22-33.html

```

### 例5:将http请求，跳转至https

```bash
[root@web03 conf.d]# cat https.conf
server {
  listen 80;
  server_name s.oldboy.com;
  rewrite (.*) https://$server_name$request_uri redirect;
  #return 302 https://$server_name$request_uri;
}

server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    root /code;
    index index.html;
  }
}
```

## 3.Rewrite标记Flag

`rewrite`指令根据表达式来重定向`URI`, 或者修改字符串。 可以应用于`server,location, if`环境下, 每行`rewrite`指令最后跟一个`flag`标记，支持的`flag`标记有如下表格所示：

| flag | |
| --- | --- |
| last | 停止对当前请求的处理，并将重写后的 URL 作为新的请求进行再次处理。通常用于将请求重定向到不同的 location 块进行进一步处理。 |
| break | <font style="color:rgba(0, 0, 0, 0.85);">停止处理当前的 rewrite 规则集，不再继续尝试其他规则。但不会像</font>`last`<font style="color:rgba(0, 0, 0, 0.85);">那样重新开始请求处理，而是继续在当前的 location 块中处理请求，只是不再应用后续的 rewrite 规则</font> |
| redirect | 返回 302 临时重定向状态码，告知客户端重定向到新的 URL。重定向的 URL 是重写后的 URL。 |
| permanent | 返回 301 永久重定向状态码，告知客户端资源已永久移动到新的 URL。与`redirect`类似，但表示重定向是永久性的，客户端可以缓存这个重定向信息。 |

1.临时跳转302

```bash
location /test {
  rewrite (.*) https://www.xuliangwei.com redirect;
}
每一次浏览器都会询问服务端（浏览器不会记录r.oldboy.com/test---》）

```

2.永久跳转301

```bash
location /test {
  rewrite (.*) https://www.xuliangwei.com permanent;
}
只要浏览器访问一次，会记录这个跳转，下次再也不会询问，直接跳转

```

对比flag中break与last 公司目前产品有一个url地址是r.oldboy.com/2017_old随着时间的推移, 公司希望客户通过新的url访问www.oldboy.com/2019_new需要保证浏览器的url地址不发生变化

```bash
root@web03 conf.d]# vim rewrite.conf
server {
  listen 80;
  server_name r.oldboy.com;
  root /code;
  location ~ ^/2019_new {
    rewrite ^/2019_new /2017_old/ break;
  }
  location ~ ^/2020_new {
    rewrite ^/2020_new /2017_old/ last;
  }
  location ~ ^/2017_old {
    root /code;
    index index.html;
  }
}

mkdir /code/2017_old -p
echo "2017_code" > /code/2017_old/index.html
systemctl restart nginx
```

last与break对比总结:

```bash
last   r.oldboy.com/2020_new    ---->    r.oldboy.com/2017_old
1.last进行Rewrite匹配成功, 停止当前这个请求, 并根据rewrite匹配的规则重新向Server发起一个请求。
2.新请求的内容是域名+URL, 对应的地址为www.oldboy.com/2017_old

break   r.oldboy.com/2019_new    ---->  /2017_old     不存在404
1.break进行Rewrite匹配成功后, 不会像last重新发起请求, 首先查找站点目录下/code/2017_old/默认返回页是否存在, 如不存在则404, 如存在继续往下匹配
2.根据Rewrite匹配的规则, 跳转至r.oldboy.com/2017_old/的URL地址, 匹配成功后则不继续匹配

```

## 09.Nginx HTTPS

### 1.HTTPS基本概述

为什么需要使用HTTPS, 因为HTTP不安全

> 1.传输数据被中间人盗用, 信息泄露
>
> 2.数据内容劫持, 篡改

配置HTTPS前预备知识

* HTTPS证书购买选择
  * 保护1个域名 `www`
  * 保护5个域名 `www images cdn test m`
  * 通配符域名 `*.oldboy.com`
* HTTPS注意事项
  * https不支持三级域名解析
  * Https不支持续费,证书到期需重新申请进行替换
  * Https显示绿色, 说明整个网站的URL都是https的。
  * Https显示黄色, 因为网站代码中包含http的不安全连接。
  * Https显示红色，要么证书是假的，要么证书过期。
* 自己颁发的证书统统都是假的（我们只管使用）

### 自己生成证书

```bash
# 1.检查当前环境
//openssl必须是1.0.2
[root@Nginx ~]# openssl version
OpenSSL 1.0.2k-fips  26 Jan 2017
//nginx必须有ssl模块
[root@Nginx ~]# nginx -V
--with-http_ssl_module

mkdir /etc/nginx/ssl_key -p
cd /etc/nginx/ssl_key

#2.使用openssl充当CA权威机构创建私钥(生产不可能使用此方式生成证书，不被互联网CA权威承认的黑户证书)
[root@Nginx ssh_key]# openssl genrsa -idea -out server.key 2048
Generating RSA private key, 2048 bit long modulus
.....+++
//记住配置密码, 我这里是1234
Enter pass phrase for server.key:
Verifying - Enter pass phrase for server.key:

#3.生成自签证书，同时去掉私钥的密码
[root@Nginx ssl_key]# openssl req -days 36500 -x509 \
-sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:WH
Locality Name (eg, city) [Default City]:WH
Organization Name (eg, company) [Default Company Ltd]:edu
Organizational Unit Name (eg, section) []:SA
Common Name (eg, your name or your server's hostname) []:bgx
Email Address []:bgx@foxmail.com
# req  -->用于创建新的证书
# new  -->表示创建的是新证书
# x509 -->表示定义证书的格式为标准格式
# key  -->表示调用的私钥文件信息
# out  -->表示输出证书文件信息
# days -->表示证书的有效期

#4.配置Nginx支持Https实例
[root@web03 conf.d]# cat https.conf
server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    root /code;
    index index.html;
  }
}
```

### nginx 服务配置

```bash
#1 创建目录 启动服务
echo "https....." > /code/index.html
nginx -t
systemctl restart nginx

#2 配置Host解析
10.0.0.9 s.oldboy.com

#强制跳转访问http的请求至https
[root@web03 conf.d]# cat https.conf 
server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    root /code;
    index index.html;
  }
}
server {
  listen 80;
  server_name s.oldboy.com;
  rewrite (.*) https://$server_name$request_uri redirect;
}

如果添加了flag标记，则会有跳转到https的信息  301。
如果没有添加flag标记，则没有跳转https的信息  200。



```

1.作业  1.将单台wordpress博客配置https访问

```bash
# 1 申请证书,上面有
# 1.准备文件
mkdir /etc/nginx/ssl_key -p
cd /etc/nginx/ssl_key
openssl genrsa -idea -out server.key 2048
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt

# 2 修改网站配置文件
[root@web01 conf.d]# cat wordpress.conf
server {
  listen 80;
  server_name wordpress.oldboy.com;
  rewrite (.*) https://$server_name$request_uri redirect;
}
server {
  listen 443;
  server_name wordpress.oldboy.com;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    root /code/wordpress;
    index index.php index.html;
  }
  location ~ \.php$ {
    root /code/wordpress;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    }
}
```

2.负载均衡+后端的web，http正常请求没问题，https实现

```bash
### 注意：ssl证书使用通配符，生产必须统一，如果是自己签发证书可以随意使用（黑户）
# 1.环境准备
角色      外网IP(NAT)       内网IP(LAN)       服务
lb01    eth0:10.0.0.5   eth1:172.16.1.5     nginx-proxy
web01   eth0:10.0.0.7   eth1:172.16.1.7     nginx-web01
web02   eth0:10.0.0.8   eth1:172.16.1.8     nginx-web02

# 2.先配置后端的所有web节点, 如下操作,统一配置
//生成证书（仅生成一次即可, 其他机器拷贝）
mkdir /etc/nginx/ssl_key -p
cd /etc/nginx/ssl_key
openssl genrsa -idea -out server.key 2048
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt

//配置 后端web01 节点通过https方式访问,
[root@web02 conf.d]# vim blog.oldboy.com.conf
server {
  listen 443;
  server_name blog.oldboy.com;
  root /code/wordpress;
  index index.php index.html;
  ssl on;
  ssl_certificate  ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location ~ \.php$ {
    root /code/wordpress;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
  }
}
// 配置第二台web02 节点
[root@web01 ~]# scp -rp /etc/nginx/* root@172.16.1.8:/etc/nginx/
// 重启两台后端web节点Nginx
[root@web01 ~]# systemctl restart nginx
[root@web02 ~]# systemctl restart nginx

拷贝web01上的ssl证书至Proxy
[root@web01 ~]# scp -rp /etc/nginx/ssl_key/ root@172.16.1.5:/etc/nginx/
// 配置nginx 负载均衡调度
[root@lb01 ~]# cat /etc/nginx/conf.d/proxy.conf 
# 必须修改后端监听资源池为443端口
upstream site {
  server 172.16.1.7:443 max_fails=1 fail_timeout=60s;
  server 172.16.1.8:443 max_fails=1 fail_timeout=60s;
}
# 接收用户https请求, 将请求内容抛至后端web节点
server {
  listen 443;
  server_name blog.oldboy.com;
  ssl on;
  ssl_certificate  ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    proxy_pass https://site;
    include proxy_params;
  }
}
# 用户通过http请求跳转至https
server {
  listen 80;
  server_name blog.oldboy.com;
  return 302 https://$server_name$request_uri;
}

#重启Proxy Nginx
[root@lb01 ~]# systemctl restart nginx

wordpress早期安装如果是使用http方式, 那开启https后会导致wordpress出现破图或加载不全的情况。
建议:
1.在安装wordpress之前就配置好https
2.在wordpress后台管理页面, 设置->常规->修改（WordPress地址以及站点地址）为 https://



```


> 更新: 2026-05-06 15:16:34  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/zlz9fp>