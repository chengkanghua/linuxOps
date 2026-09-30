# day58 Nginx常见问题与总结

## 1.Nginx多Server，导致Server_name优先级

在开始处理一个HTTP请求时，Nginx会读取header（请求头）中的host，与每个server中的server_name进行匹配，，来决定用哪一个server标签来完成处理这个请求。有可能一个Host与多个server中的server_name都匹配，这个时候就会更具匹配优先级来选择实际处理的server块。优先级匹配结果如下：\
1，首先选择所有的字符串完全匹配的server_name。（完全匹配）\
2，选择通配符在前面的server_name，如\_.sentinel.org.cn\
\_\_ 3，选择通配符在后面的server_name，如sentinel.\_\
4，最后选择使用正则表达式匹配的server_name\
5，如果全部都没有匹配到，那么将选择在listen配置项后加入\[default|default_server]的server块。\
6，如果没写，那么就找到匹配listen端口的第一个server块

```bash
1.准备nginx对应的配置文件
[root@web02 conf.d]# cat code1.conf
server {
  listen 80;
  server_name localhost;
  location / {
    root /code1;
    index index.html;
  }
}
[root@web02 conf.d]# cat code2.conf
server {
  listen 80;
  server_name localhost;
  location / {
    root /code2;
    index index.html;
  }
}
[root@web02 conf.d]# cat code3.conf
server {
  listen 80;
  server_name localhost;
  location / {
    root /code3;
    index index.html;
  }
}
2.准备站点目录
mkdir /code{1..3} -p
for i in {1..3};do echo "Code$i" > /code$i/index.html;done
[root@web02 conf.d]# cat /code1/index.html 
Code1
[root@web02 conf.d]# cat /code2/index.html 
Code2
[root@web02 conf.d]# cat /code3/index.html 
Code3

3.检查语法
[root@web02 conf.d]# nginx -t
nginx: [warn] conflicting server name "localhost" on 0.0.0.0:80, ignored
nginx: [warn] conflicting server name "localhost" on 0.0.0.0:80, ignored
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

4.正常重启
systemctl restart nginx
# 浏览器ip访问 10.0.0.7  默认显示最先匹配的 Code1
```

```bash
# 修改默认的虚拟主机   default_server
server {
  listen 80 default_server;
  # rewrite ^(.*) http://www.baidu.com;
  server_name localhost;
  location / {
    root /code3;
    index index.html;
  }
}
#通过ip地址 10.0.0.7 默认显示 code3
```

```bash
# 禁止ip访问
[root@web01 conf.d]# cat code3.conf
server {
  listen 80 default_server;
  server_name localhost;
  return 500;
}
# 或者 重定向到网址
server {
  listen 80 default_server;
  server_name localhost;
  rewrite ^(.*) http://www.baidu.com;
}
```

参考 Nginx 禁止IP访问 只允许域名访问 <https://blog.csdn.net/weixin_40064477/article/details/78970862>

## 2.Nginx Include 包含文件

一台服务器配置多个`server`网站，会导致`nginx.conf`主配置文件变得非常庞大而且可读性非常的差。\
目的：为了简化主配置文件，便于人类可读

## 3.nginx配置下有两个指定目录的，root和alias，那nginx的root和alias指令的区别

alias是一个目录别名的定义，

root则是最上层目录的定义。

```bash
# root配置实例:
[root@web01 code3]# cat /etc/nginx/conf.d/code3.conf
server {
  listen 80 default_server;
  index index.html;
  location /image/ {
    root /code3/;
  }
}
[root@web01 code3]# tree ./
./
├── image
│   └── 1.jpg
└── index.html
1 directory, 2 files

# 浏览器访问 http://10.0.0.7/image/1.jpg  可以访问到图片
# 用户访问/image/db.jpg，实际上Nginx会上/code3/image/目录下找去找1.jpg文件。

```

```bash
# alias配置实例:
[root@web01 code3]# vim /etc/nginx/conf.d/code3.conf
server {
  listen 80 default_server;
  index index.html;
  location /image/ {
    alias /code3/;
  }
}
# 浏览器访问 http://10.0.0.7/image/1.jpg  显示404找不到资源
# 用户访问/image/1.jpg，实际上Nginx会上/code3/目录下找去找1.jpg文件

```

## 4. error_page错误日志

```bash
server {
  listen 80;
  server_name t1.com
  location / {
    root /code;
    index index.html
  }
  # 404错误去找 根下的404.jpg
  error_page 404 /404.jpg;
}

# redirect server error pages to the static page /50x.html
#如下错误状态码进行跳转/500.jpg
error_page 500 502 503 504  /500.jpg;
#当有人访问500.jpg 则进行精准匹配
location = /500.jpg {
  root   /code/error;
}

# 查看压缩包内容
zcat default.conf.gz
// 403错误  主页找不到
// 404错误  文件找不到
// 500 服务器无法解析

server {
  listen 80;
  server_name t1.com
  location / {
    root /code;
    index index.html
    #这个地址主机连接不到会报502错误
    proxy_pass http://192.168.1.0:80;
  }
  error_page 404 /404.jpg;
}
```

## 5. Nginx Try_file 按顺序检查文件是否存在

Nginx try_files路径匹配

\#1.检查用户请求的uri内容是否存在本地,存在则解析

\#2.将请求加/, 类似于重定向处理

\#3.最后交给index.php处理

```bash
1.演示环境准备
echo "nginx Try-Page" > /code/index.html
echo "Tomcat-Page" > /soft/app/apache-tomcat-9.0.7/webapps/ROOT/index.html

2.配置Nginx的tryfiles
[root@web03 code]# cat /etc/nginx/conf.d/try.conf
server {
  listen 80;
  server_name 192.168.69.113;
  location / {
    root /code;
    # 默认index.php页面不存在， 转到java_page 本地的8080端口
    index index.html;
    try_files $uri /index.html @java_page;
  }
  location @java_page {
    proxy_pass http://127.0.0.1:8080;
  }
}
//重启Nginx
nginx -s reload

[root@Nginx ~]# curl http://192.168.69.113/index.html
Try-Page

//将/soft/code/index.html文件移走
[root@Nginx ~]# mv /soft/code/{index.html,index.html_bak}

3.测试`tryfiles`
//发现由Tomcat吐回了请求
[root@Nginx ~]# curl http://192.168.69.113/index.html    
Tomcat-Page
```

## wordpress 配置 try_files $uri /index.php?$query_string;

请求根不存在的页面 ，跳转主页

```bash
[root@web01 conf.d]# vim wordpress.conf
server {
  listen 443;
  server_name wordpress.etiantian.org;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    root /code/wordpress;
    index index.php index.html;
    try_files $uri /index.php?$query_string;
  }
  location ~ \.php$ {
    root /code/wordpress;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
  }
}
# 实现浏览器上https://wordpress.etiantian.org/接不存在的路径，会自动跳到首页
```

扩展：

proxy_cache <https://blog.csdn.net/dengjiexian123/article/details/53386586>

## nginx ssl Termination

![1547294375761-f63fa8ce-6079-4a5e-9c6e-06ae8bc5a663.png](img/day58Nginx%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E4%B8%8E%E6%80%BB%E7%BB%93-01.png)

```bash
#负载上配置 443端口
[root@lb01 conf.d]# vim s.oldboy_https.conf
upstream node_php {
  server 172.16.1.7:80;
  #server 172.16.1.8:80;
}
server {
  listen 80;
  server_name s.oldboy.com;
  return 302 https://$server_name$request_uri;
}
server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate  ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    proxy_pass http://node_php;
    #包含主机头信息 连接响应时间.
    include proxy_params;
  }
}
#web01 上的 只配置80端口
[root@web01 conf.d]# vim s.oldboy.conf
server {
  listen 80;
  server_name s.oldboy.com;
  location / {
    root /code;
    index index.html;
  }
}

echo "web01...." > /code/index.html
nginx -t 
systemctl restart nginx
# web01 配置一样
```

### 后端web是 tomcat 本机配置一个反向代理

```bash
# 负载均衡配置一样
[root@lb01 conf.d]# vim s.oldboy_https.conf
upstream node_php {
  #调用的是反向代理
  server 172.16.1.9:80;
}
server {
  listen 80;
  server_name tomcat.oldboy.com;
  return 302 https://$server_name$request_uri;
}
server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate  ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    proxy_pass http://node_php;
    #包含主机头信息 连接响应时间.
    include proxy_params;
  }
}
# web03 配置 nginx 反向代理
[root@web03 conf.d]# vim tomcat.oldboy.com
server {
  listen 80;
  server_name tomcat.oldboy.com;
  location / {
    # 调用本地的tomcat 8080  程序
    proxy_pass http://127.0.0.1:8080;
    include proxy_params;
  }
}

```

![1547294463218-a54a6ff9-d0e7-4c35-87b6-a2189934a213.png](img/day58Nginx%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E4%B8%8E%E6%80%BB%E7%BB%93-02.png)

# nginx 服务器内部优化

```bash
#nginx服务器内核优化
cat >> /etc/sysctl.conf <<EOF
net.core.rmem_default = 256960
net.core.rmem_max = 513920
net.core.wmem_default = 256960
net.core.wmem_max = 513920
net.core.netdev_max_backlog = 2000
net.core.somaxconn = 2048
net.core.optmem_max = 81920
net.ipv4.tcp_mem = 131072  262144  524288
net.ipv4.tcp_rmem = 8760  256960  4088000
net.ipv4.tcp_wmem = 8760  256960  4088000
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.ip_local_port_range = 1024  65000
net.ipv4.tcp_max_syn_backlog = 2048
kernel.pid_max = 200000
fs.file-max = 6576596
EOF
```


> 更新: 2024-08-29 21:54:45  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/xqiv5k>