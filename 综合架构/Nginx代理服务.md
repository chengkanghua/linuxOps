# Nginx代理服务

## 1.Nginx代理服务概述
代理我们往往并不陌生, 该服务我们常常用到如(代理租房、代理收货等等)  
那么在互联网请求里面, 客户端无法直接向服务端发起请求, 那么就需要用到代理服务, 来实 现客户端和服务通信

Nginx作为代理服务可以实现很多的协议代理, 我们主要以http代理为主

正向代理(内部上网) 客户端<-->代理--->服务端  
反向代理               客户端-->代理<-->服务端



_正向与反向代理的区别_

> 区别在于代理的对象不一样  
正向代理代理的对象是客户端  
反向代理代理的对象是服务端
>





## 2 Nginx代理配置语法
```nginx
#推荐写法
server{
  listen 80;
  server_name blog.oldboy.com;
  location / {
    proxy_pass http://172.16.1.7;
    include proxy_params;
  }
}
server{
  listen 80;
  server_name edu.oldboy.com;
  location / {
    proxy_pass http://172.16.1.7;
    include proxy_params;
  }
}
----------------------------------------------------------
# cat /etc/nginx/proxy_params 
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

## 1.3Nginx反向代理示例
| 角色 | 外网ip | 内网ip | 主机名 |
| --- | --- | --- | --- |
| proxy | 10.0.0.5 | 172.16.1.5 | lb01 |
| web01 | 10.0.0.7 | 172.16.1.7 | web01 |


### 1 web01 服务器
```plain

# cat /etc/nginx/conf.d/web.conf
server{
  listen 8080;
  server_name localhost;
  location / {
    root /code_8080;
    index index.html;
    }
}

mkdir /code_8080
echo "echo we01-7...">/code_8080/index.html
systemctl restart nginx

# netstat -lntp

# 修改 监听在8080 端口 仅运行在172网段能访问
# cat /etc/nginx/conf.d/web.conf
server{
  listen 8080;
  server_name 172.16.1.7;
  location / {
    root /code_8080;
    index index.html;
    deny 10.0.0.0/24;
    allow all;
    }
}
```

### 2 proxy 代理服务器
```plain
#配置yum源
cat > /etc/yum.repos.d/nginx.repo<<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF

# 安装nginx
yum install nginx -y
# 关闭默认站点配置
cd /etc/nginx/conf.d/; mv default.conf default.conf.off
# 配置一个代理服务 让10.0.0.1客户端,能够通过代理访问到后端
cat > /etc/nginx/conf.d/proxy.conf<<EOF
server {
  listen 80;
  server_name nginx.oldboy.com;
  location / {
    proxy_pass http://172.16.1.7:8080;
    }
}
EOF
systemctl start nginx
systemctl enable nginx

windows  C:\Windows\System32\drivers\etc\ hosts 添加
10.0.0.5         nginx.oldboy.com

#添加发往后端服务器的请求头信息 1host 2客户端ip 3真实客户端ip
[root@lb02 ~]# cat /etc/nginx/conf.d/proxy.conf
server {
  listen 80;
  server_name nginx.oldboy.com;
  location / {
    proxy_pass http://172.16.1.7:8080;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
# 重启nginx
nginx -t
systemctl restart nginx

浏览器访问http://nginx.oldboy.com/

[root@web01 conf.d]# tail -f /var/log/nginx/access.log
172.16.1.5 - - [25/Sep/2018:11:46:01 +0800] "GET / HTTP/1.0" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.90 Safari/537.36 2345Explorer/9.4.2.17629" "10.0.0.1"
日志最后面接受的事代理服务器传过来的真实ip地址

10.0.0.7 - - [28/Aug/2024:21:07:34 +0800] "GET / HTTP/1.0" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36 Core/1.116.438.400 QQBrowser/13.0.6071.400" "-"
10.0.0.7 - - [28/Aug/2024:21:09:06 +0800] "GET / HTTP/1.0" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36 Core/1.116.438.400 QQBrowser/13.0.6071.400" "10.0.0.1"

```

### 3优化 proxy 的配置
```bash
cat > /etc/nginx/proxy_params<<EOF 
# 发往后端web服务器的请求头信息 host 客户端ip  真实客户端ip
proxy_set_header Host \$http_host;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
# 代理到后端的Tcp 连接 响应 ,返回等超时时间
proxy_connect_timeout 30;
proxy_send_timeout 60;
proxy_read_timeout 60;
# proxy_buffer 代理缓冲区
proxy_buffering on;
proxy_buffer_size 32k;
proxy_buffers 4 128k;
EOF
-------------------------------------------------------
# vim /etc//nginx/conf.d/proxy.conf
server {
  listen 80;
  server_name nginx.oldboy.com;
  location / {
    # 代理服务器接收到请求交给后端web
    proxy_pass http://172.16.1.7:8080;
    # 包含proxy_params
    include proxy_params;
    }
}

systemctl restart nginx
```

---





反向代理



![1547290959469-25f18ced-d8df-46a0-adc2-6562dd842ca7.png](img/Nginx%E4%BB%A3%E7%90%86%E6%9C%8D%E5%8A%A1-01.png)![1547290960682-0abd5ae8-ebb7-4af4-8b4a-a68edfaa6bb8.png](img/Nginx%E4%BB%A3%E7%90%86%E6%9C%8D%E5%8A%A1-02.png)















































> 更新: 2026-05-05 19:33:12  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/tdcl6m>