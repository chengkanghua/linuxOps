# day58 Nginx 常见问题与总结

> 汇总 Nginx 实战中的高频坑点：server_name 优先级、root/alias 区别、error_page、try_files、SSL 终结、内核优化。

---

## 1. Nginx 多 Server 的 server_name 优先级

处理 HTTP 请求时，Nginx 读取请求头 Host，与每个 `server` 的 `server_name` 匹配；若命中多个，按优先级选实际处理的 `server`：

1. **完全字符串匹配**（如 `www.oldboy.com`）
2. **通配符在前的**（如 `*.oldboy.com`）
3. **通配符在后的**（如 `www.oldboy.*`）
4. **正则匹配的** `server_name`
5. 都没匹配 → 选 `listen` 带 `default_server` 的 `server`
6. 还没写 → 选 `listen` 端口下**第一个** `server`

### 演示：三个 server 都配 localhost
```bash
[root@web02 conf.d]# cat code1.conf
server {
  listen 80;
  server_name localhost;
  location / { root /code1; index index.html; }
}
[root@web02 conf.d]# cat code2.conf
server {
  listen 80;
  server_name localhost;
  location / { root /code2; index index.html; }
}
[root@web02 conf.d]# cat code3.conf
server {
  listen 80;
  server_name localhost;
  location / { root /code3; index index.html; }
}

# 准备站点目录
mkdir -p /code{1..3}
for i in {1..3}; do echo "Code$i" > /code$i/index.html; done

# 检查语法（会告警 server_name 冲突，但不影响启动）
nginx -t
# nginx: [warn] conflicting server name "localhost" on 0.0.0.0:80, ignored
# nginx: configuration file ... test is successful

systemctl restart nginx
# 浏览器 IP 访问 10.0.0.7  → 默认显示最先匹配的 Code1
```

### 修改默认虚拟主机（default_server）
```nginx
server {
  listen 80 default_server;
  server_name localhost;
  location / { root /code3; index index.html; }
}
# IP 访问 10.0.0.7 → 显示 code3
```

### 禁止 IP 直接访问（只允许域名）
```nginx
# 方式一：返回 500
server {
  listen 80 default_server;
  server_name localhost;
  return 500;
}
# 方式二：重定向到指定域名
server {
  listen 80 default_server;
  server_name localhost;
  rewrite ^(.*) http://www.baidu.com;
}
```
> 参考：<https://blog.csdn.net/weixin_40064477/article/details/78970862>

---

## 2. Nginx Include 包含文件

一台服务器配多个 `server` 会让 `nginx.conf` 臃肿、可读性差。**用 `include` 拆分**到 `conf.d/*.conf`，简化主配置、便于维护。

```nginx
# /etc/nginx/nginx.conf
http {
  include /etc/nginx/conf.d/*.conf;
}
```

---

## 3. root 与 alias 的区别（重点）

- `alias`：目录**别名**（location 路径整体替换成 alias 指定的绝对路径）。
- `root`：最上层目录定义（location 路径**拼接**到 root 后面）。

```nginx
# root：访问 /image/1.jpg → 实际找 /code3/image/1.jpg
location /image/ {
  root /code3/;
}
```

```nginx
# alias：访问 /image/1.jpg → 实际找 /code3/1.jpg（注意 alias 路径结尾 /）
location /image/ {
  alias /code3/;
}
# 若写成 alias /code3; 访问 /image/1.jpg → 找 /code31.jpg（错误）
```
> ⚠️ 用 `alias` 时路径结尾建议带 `/`，否则容易路径拼接错误导致 404。

---

## 4. error_page 错误页面

```nginx
server {
  listen 80;
  server_name t1.com;
  location / {
    root /code;
    index index.html;
  }
  error_page 404 /404.jpg;                 # 404 跳转到 /404.jpg
}
# 如下状态码跳转 /500.jpg
error_page 500 502 503 504 /500.jpg;
location = /500.jpg {                      # = 精准匹配 500.jpg
  root /code/error;
}
```

代理场景：后端连不上会报 502
```nginx
server {
  listen 80;
  server_name t1.com;
  location / {
    root /code;
    index index.html;
    proxy_pass http://192.168.1.0:80;      # 地址不可达 → 502
  }
  error_page 404 /404.jpg;
}
```

---

## 5. try_files 按顺序检查文件

`try_files` 按顺序检查文件/目录是否存在，都不存在就 fallback 到最后一项（内部重定向或命名 location）。

逻辑：`$uri` → `$uri/`（加斜杠重定向）→ 最后的 fallback。

### 本地回退到 Tomcat
```nginx
server {
  listen 80;
  server_name 192.168.69.113;
  location / {
    root /code;
    index index.html;
    try_files $uri /index.html @java_page;
  }
  location @java_page {
    proxy_pass http://127.0.0.1:8080;
  }
}
```
```bash
echo "nginx Try-Page" > /code/index.html
echo "Tomcat-Page"    > /soft/app/apache-tomcat-9.0.7/webapps/ROOT/index.html
nginx -s reload
curl http://192.168.69.113/index.html     # nginx Try-Page
mv /soft/code/{index.html,index.html_bak} # 移走本地文件
curl http://192.168.69.113/index.html     # Tomcat-Page（回退到 java 页）
```

### WordPress 的 try_files（伪静态核心）
```nginx
server {
  listen 443;
  server_name wordpress.etiantian.org;
  ssl on;
  ssl_certificate     ssl_key/server.crt;
  ssl_certificate_key ssl_key/server.key;
  location / {
    root /code/wordpress;
    index index.php index.html;
    try_files $uri /index.php?$query_string;   # 不存在的路径回退到 index.php，实现伪静态
  }
  location ~ \.php$ {
    root /code/wordpress;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include        fastcgi_params;
  }
}
# 访问不存在的路径 → 自动跳回首页（由 index.php 处理）
```
> 扩展阅读：proxy_cache <https://blog.csdn.net/dengjiexian123/article/details/53386586>

---

## 6. Nginx SSL Termination（SSL 卸载）

HTTPS 的加解密集中在负载均衡器（LB）完成，后端 Web 仍用 80（明文），减轻后端压力。

![SSL 终结](img/day58Nginx%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E4%B8%8E%E6%80%BB%E7%BB%93-01.png)

### 后端是 PHP（负载均衡 443 → 后端 80）
```nginx
# lb01
upstream node_php {
  server 172.16.1.7:80;
}
server {
  listen 80;
  server_name s.oldboy.com;
  return 302 https://$server_name$request_uri;       # HTTP 强制跳 HTTPS
}
server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate     ssl_key/server.crt;
  ssl_certificate_key ssl_key/server.key;
  location / {
    proxy_pass http://node_php;
    include proxy_params;
  }
}

# web01（只配 80）
server {
  listen 80;
  server_name s.oldboy.com;
  location / {
    root /code;
    index index.html;
  }
}
echo "web01...." > /code/index.html
nginx -t && systemctl restart nginx
```

### 后端是 Tomcat（LB 443 → 本机 Nginx 反向代理 → 本机 8080）
```nginx
# lb01（同上前半段，upstream 指向 web03）
upstream node_php {
  server 172.16.1.9:80;
}
# （server 80/443 同上）

# web03（本机 Nginx 反向代理到 Tomcat 8080）
server {
  listen 80;
  server_name tomcat.oldboy.com;
  location / {
    proxy_pass http://127.0.0.1:8080;
    include proxy_params;
  }
}
```
![反向代理到 Tomcat](img/day58Nginx%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E4%B8%8E%E6%80%BB%E7%BB%93-02.png)

---

## 7. Nginx 服务器（内核）优化

```bash
cat >> /etc/sysctl.conf <<EOF
net.core.rmem_default = 256960
net.core.rmem_max = 513920
net.core.wmem_default = 256960
net.core.wmem_max = 513920
net.core.netdev_max_backlog = 2000
net.core.somaxconn = 2048
net.core.optmem_max = 81920
net.ipv4.tcp_mem = 131072 262144 524288
net.ipv4.tcp_rmem = 8760 256960 4088000
net.ipv4.tcp_wmem = 8760 256960 4088000
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
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 2048
kernel.pid_max = 200000
fs.file-max = 6576596
EOF
sysctl -p
```

---

## 八、常见面试题

1. **多个 server 配了相同 server_name，Nginx 怎么选？**
   按优先级：完全匹配 > 通配符前 > 通配符后 > 正则 > default_server > 第一个。冲突时 `nginx -t` 会告警，实际取第一个匹配。

2. **root 和 alias 的区别？**
   `root` 把 location 路径拼到 root 后面（`/image/1.jpg` → `/code3/image/1.jpg`）；`alias` 用 alias 路径整体替换 location（`/image/1.jpg` → `/code3/1.jpg`）。

3. **怎么禁止 IP 直接访问，只允许域名？**
   配一个 `listen 80 default_server` 的 server，`return 500` 或 `rewrite` 重定向到域名。

4. **try_files 的作用？**
   按顺序检查 `$uri`、加 `/`、到最后 fallback；常用于单页应用 / WordPress 伪静态（回退到 index.php）。

5. **什么是 SSL Termination（SSL 卸载）？有什么好处？**
   在负载均衡器统一做 HTTPS 加解密，后端用明文 HTTP，减轻后端 CPU 压力、简化证书管理。

6. **Nginx 内核优化调哪些参数？**
   提升连接队列（somaxconn）、端口范围（ip_local_port_range）、TIME_WAIT 复用（tcp_tw_reuse）、SYN Cookie（防洪水）、文件句柄（fs.file-max）等。

---

> 更新：2024-08-29 21:54:45
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/xqiv5k>
