# 第七章·Nginx实现动静分离

## Nginx动静分离基本概述
动静分离，通过中间件将动静分离和静态请求进行分离；

通过中间件将动态请求和静态请求分离，可以建上不必要的请求消耗，同事能减少请求的延时。

通过中间件将动态请求和静态请求分离，逻辑图如下:

<!-- OCR_START -->
- 动态请求
- 负载均衡
- 程序框架
- 程序逻辑
- 数据资源
- 静态请求
- 曾老湿
- DriverZeng
<!-- OCR_END -->

动静分离只有好处：动静分离后，即使动态服务不可用，但静态资源不会受到影响。

## Nginx动静分离场景实践
| 单台服务器实现动静分离 |
| --- |

```bash
location / {
    root /code/wordpress;
    index.php;
}
location ~* \.(png|jpg|mp4|)${
    root /code/wordpress/images;
    gzip on;
    .....
}
location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    .....
}
```

---

| 多台服务器实现动静分离 |
| --- |

<!-- OCR_START -->
- 动态资源
- jsp、
- php、java
- 负载均衡
- 10.0.0.8
- 请求
- 静态资源
- jpg、png、mp4
- 10.0.0.7
- 曾老湿
- DriverZeng
<!-- OCR_END -->

---

| 环境准备 |
| --- |

| 系统 | 作用 | 服务 | 地址 |
| --- | --- | --- | --- |
| Centos7.5 | 负载均衡 | nginx proxy | 10.0.0.5 |
| Centos7.5 | 静态资源 | nginx static | 10.0.0.7 |
| Centos7.5 | 动态资源 | tomcat server | 10.0.0.8 |

---

| web01配置静态资源 |
| --- |

```bash
[root@web01 ~]# cd /etc/nginx/conf.d/
[root@web01 conf.d]# cat ds_oldboy.conf 
server {
        listen 80;
        server_name pic.drz.com;
        root /code;
        index index.html;
        location ~* .*\.(jpg|png|gif)$ {
                root /code/images;
        }
}
#配置一个主页
[root@web01 conf.d]# echo "zls_test_web01" > /code/index.html
#创建图片目录
[root@web01 conf.d]# mkdir /code/images/
#上传一个静态文件
[root@web01 conf.d]# cd /code/images/
[root@web01 images]# rz cjk.gif
[root@web01 conf.d]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@web01 conf.d]# nginx -s reload
```

---

| 验证 |
| --- |

打开浏览器访问：[http://pic.drz.com/](http://pic.drz.com/)

<!-- OCR_START -->
- pic.drz.com
- cjk.gif（515x289)
- 不安全pic.drz.com
- 应用
- zabbix-api
- zls_test_web01
<!-- OCR_END -->

打开浏览器访问：[http://pic.drz.com/cjk.gif](http://pic.drz.com/cjk.gif)

<!-- OCR_START -->
- pic.drz.com
- cjk.gif（515x289)
- ←→C① 不安全| pic.drz.com/cjik.gif
- ll应用 zabbix-api
- 曾老湿
<!-- OCR_END -->

---

| web02配置动态资源 |
| --- |

```bash
[root@web02 ~]# yum install -y tomcat
[root@web02 ~]# mkdir /usr/share/tomcat/webapps/ROOT
[root@web02 ~]# cat /usr/share/tomcat/webapps/ROOT/java_test.jsp
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<HTML>
    <HEAD>
        <TITLE>曾老湿JSP Page</TITLE>
    </HEAD>
    <BODY>
        <%
            Random rand = new Random();
            out.println("<h1>曾老湿随机数:<h1>");
            out.println(rand.nextInt(99)+100);
        %>
    </BODY>
</HTML>
[root@web02 webapps]# systemctl start tomcat
```

打开浏览器，访问：[http://10.0.0.8:8080/java_test.jsp](http://10.0.0.8:8080/java_test.jsp)

<!-- OCR_START -->
- 曾老湿JSPPage
- 10.0.0.8:8080/java_test.jsp
- 应用
- zabbix-api
- 曾老湿随机数：
- 198
- 曾老湿
- DriverZeng
<!-- OCR_END -->

---

| 负载均衡上调度 |
| --- |

```bash
[root@lb01 conf.d]# cat proxy_ds.conf 
upstream static {
        server 172.16.1.7:80;
}
upstream java {
        server 172.16.1.8:8080;
}
server {
        listen 80;
        server_name pic.drz.com;
        location ~* \.(jpg|png|gif)$ {
                proxy_pass http://static;
                proxy_set_header Host $http_host;
        }
        location ~ \.jsp {
                proxy_pass http://java;
                proxy_set_header Host $http_host;
        }
}
[root@lb01 conf.d]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@lb01 conf.d]# nginx -s reload
```

2.5 配置本地hosts，通过负载访问动态与静态资源

动态资源 ↓

<!-- OCR_START -->
- pic.drz.com
- cjk.gif（515x289)
- 5
- 曾老湿JSPPage
- ①不安全
- pic.drz.com/java_test.jsp
- 应用
- zabbix-api
- 曾老湿随机数：
- 180
<!-- OCR_END -->

静态资源 ↓

<!-- OCR_START -->
- C不安全|pic.drz.com/cjk.gi
- 应用zabbix-api
- 曾老湿
- Driver
- Zeng
<!-- OCR_END -->

网站主页 ↓

<!-- OCR_START -->
- pic.drz.com
- cjk.gif（515x289)
- 曾老湿JSPPage
- ①不安全|pic.drz.com
- 应用
- zabbix-api
- zls_test_web01
- 曾老湿
- DriverZeng
<!-- OCR_END -->

---

| 负载均衡上整合动态和静态的html文件 |
| --- |

```bash
#编辑配置文件
[root@lb01 ~]# cat /etc/nginx/conf.d/proxy_ds.conf
upstream static {
        server 172.16.1.7:80;
}
upstream java {
        server 172.16.1.8:8080;
}
server {
        listen 80;
        server_name pic.drz.com;
        
        location / {
            root /code;
            index index.html;
        }
        
        location ~* \.(jpg|png|gif)$ {
                proxy_pass http://static;
                proxy_set_header Host $http_host;
        }
        location ~ \.jsp {
                proxy_pass http://java;
                proxy_set_header Host $http_host;
        }
}
[root@lb01 ~]# mkdir -p /code
#编辑整合后的index.html
[root@lb01 ~]# cat /code/index.html
<html lang="en">
<head>
        <meta charset="UTF-8" />
        <title>曾老湿测试ajax和跨域访问</title>
        <script src="http://libs.baidu.com/jquery/2.1.4/jquery.min.js"></script>
</head>
<script type="text/javascript">
$(document).ready(function(){
        $.ajax({
        type: "GET",
        url: "http://pic.drz.com/java_test.jsp",
        success: function(data){
                $("#get_data").html(data)
        },
        error: function() {
                alert("哎呦喂,失败了,回去检查你服务去~");
        }
        });
});
</script>
        <body>
                <h1>曾老湿带你测试动静分离</h1>
                <img src="http://pic.drz.com/cjk.gif">
                <div id="get_data"></div>
        </body>
</html>
```

---

| 浏览访问测试动静分离是否能成功 |
| --- |

<!-- OCR_START -->
- 曾老湿测试ajax和跨域访问
- →C
- ①不安全|pic.drz.com
- 应用
- zabbix-api
- 曾老湿带你测试动静分离
- 曾老湿随机数：
- 197
- Elements
- Sources
- Network
- Performance
- Memory
- Application
- Security
- Audits
- Q|PreservelogDisablecache
- Online
- Filter
- Hide data URLs AI
- XHRJS
- CSSImg
- Media Font Doc WS Manifest Other
- 20ms
- 40 ms
- 60ms
- 80ms
- 100ms
- 120 ms
- 140 ms
- 160ms
- 180ms
- 200ms
- 220ms
- 240 ms
- 260ms
- 280ms
- 300ms
- 320 ms
- 340 ms
- 360ms
- Name
- xHeaders
- PreviewResponse
- Cookies
- Timing
- jquery.min.js
- General
- cjk.gif
- Request URL:http://pic.drz.com/cjk.gif
- 曾老湿
- Request Method: GET
- Driver
- Zeng
- transferred|48.4 MBresources|Finish:498ms
- DOMC
- StatusCode:2000K
<!-- OCR_END -->

**可以尝试关掉静态或者动态的服务，测试是否互不影响**

## Nginx资源分离场景实践
Nginx通过负载均衡实现手机与PC调度至不通的后端节点应用案例

---

| 根据Iphone、安卓、pc跳转不通的页面环境规划 |
| --- |

| 系统版本 | 主机角色 | 外网IP | 内网IP | 提供端口 |
| --- | --- | --- | --- | --- |
| CentOS7.5 | 负载均衡 | 10.0.0.5 | 172.16.1.5 | 80 |
| CentOS7.5 | 提供Android页面 | | 172.16.1.7 | 9090 |
| CentOS7.5 | 提供Iphone页面 | | 172.16.1.7 | 9091 |
| CentOS7.5 | 提供pc页面 | | 172.16.1.7 | 9092 |

1.配置后端WEB节点的Nginx配置

```bash
[root@web01 conf.d]# vim sj.conf
server {
        listen 9090;
        location / {
                root /code/android;
                index index.html;
        }
}
server {
        listen 9091;
        location / {
                root /code/iphone;
                index index.html;
        }
}
server {
        listen 9092;
        location / {
                root /code/pc;
                index index.html;
        }
}
```

2.为后端WEB节点配置对应的网站目录及代码

```bash
[root@web01 conf.d]# mkdir /code/{android,iphone,pc}
[root@web01 conf.d]# echo "我是安卓" > /code/android/index.html
[root@web01 conf.d]# echo "我是iphone" > /code/iphone/index.html
[root@web01 conf.d]# echo "我是computer" > /code/pc/index.html
```

3.配置负载均衡服务，根据不同的浏览器调度到不同的资源地

```bash
[root@lb01 conf.d]# vim /etc/nginx/conf.d/proxy_sj.conf
upstream android {
        server 172.16.1.7:9090;
}
upstream iphone {
        server 172.16.1.7:9091;
}
upstream pc {
        server 172.16.1.7:9092;
}
server {
        listen 80;
        server_name sj.drz.com;
        charset 'utf-8';
        location / {
                #如果客户端来源是Android则跳转到Android的资源；
                if ($http_user_agent ~* "Android") {
                        proxy_pass http://android;
                }
                #如果客户端来源是Iphone则跳转到Iphone的资源；
                if ($http_user_agent ~* "Iphone") {
                        proxy_pass http://iphone;
                }
                #如果客户端是IE浏览器则返回403错误；
                if ($http_user_agent ~* "MSIE") {
                        return 403;
                }
                #默认跳转pc资源；
                proxy_pass http://pc;
        }
}
```

4.使用浏览器访问，查看结果

| PC端访问 |
| --- |

<!-- OCR_START -->
- 应用
- 建议网站
- 百度一下，你就知道
- 时间戳（Unixtimes...
- 云堡垒-任子行
- On
- ProcessOn
- 在线编码转换
- 在线
- 我是computer
<!-- OCR_END -->

---

| 浏览器模拟IPhone |
| --- |

<!-- OCR_START -->
- 应用
- 建议网站
- 百度一下，你就知道
- 时间戳（Unixtimes...
- 云堡垒-任子行
- On
- ProcessOn
- 在线编码转换
- 在线加密
- iPhoneX
- 812
- 100%Online
- 我是iphone
- 曾老湿
- DriverZeng
<!-- OCR_END -->

---

| 浏览器模拟Android |
| --- |

<!-- OCR_START -->
- 应用
- 建议网站
- 百度一下，你就知道
- 时间戳（Unixtimes...
- 云堡垒-任子行
- On
- ProcessOn
- 在线编码转换
- 在线加密/解密
- GalaxyS5
- 640
- 360
- 150%Online
- 我是安卓
- 曾老湿
- DriverZeng
<!-- OCR_END -->

---

| 实际线上的配置 |
| --- |

```bash
server {
        listen 80;
        server_name   www.drz.com;
        if ($http_user_agent ~* "Android|Iphone") {
                rewrite ^/$ https://sj.drz.com redirect;
        }       
}
```

> 更新: 2024-09-23 22:59:14  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/gpdqme>