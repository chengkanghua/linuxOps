# Nginx 配置 HTTPS

> 本文含三大块：① Keepalived 高可用概述；② Nginx Rewrite（URL 重写/跳转）；③ HTTPS 原理、自签证书、单台/负载均衡全链路配置。

---

## 一、Keepalived 高可用概述

**7×24 不宕机场景**：2 台服务器，主（priority 150，virtual_router_id 50，lb01）+ 备（priority 100，virtual_router_id 50，lb02）。

**脑裂（主备都有 VIP）解决办法：写脚本**
1. **keepalived 故障**：主备各写脚本——备机判断是否 ping 通主、自己是否存在 VIP，若异常 `kill` 掉本机 keepalived。
2. **Nginx 故障**（VIP 找到 Master 但无法服务）：检查 Nginx 进程，存在则 sleep 5 再查；不存在尝试启动一次，成功则继续；启动失败则强杀 keepalived 让地址漂移到备。建议写在 Master 上。

**keepalived 用在哪 / 不能用在哪**
- 用：国企、传统互联网、纯物理服务器。
- 不用：公有云（厂商 LB 自带高可用，**公有云不能用 keepalived**，VIP 漂移由云厂商处理）。

**面试回答高可用怎么实现**
> 我们用公有云 LB，厂商本身支持高可用，这块没额外做；如果是自建物理机，则用 keepalived 开源方案实现。

**场景区分**
- 虚拟机上一台服务器的 HTTPS；
- 前端负载均衡 + 后端 Web 实现 HTTPS；
- 阿里云：ECS 跑 Nginx 启用 HTTPS；SLB + ECS 实现 HTTPS。

---

## 二、Rewrite 基本概述

**Rewrite = URL 重写/重定向**：把传入 Web 的请求重定向到其他 URL。

**使用场景**
1. 地址跳转：访问 `bgx.com` 跳 `xuliangwei.com`；HTTP 访问跳到 HTTPS。
2. URL 伪静态：把动态页面显示成静态（便于搜索引擎收录，隐藏参数更安全）。
3. SEO 优化依赖 URL 路径。

### 配置语法
```nginx
Syntax: rewrite regex replacement [flag];
Default: --
Context: server, location, if
```

**可引用的全局变量**
| 变量 | 含义 |
| --- | --- |
| `$document_root` | 当前请求的根路径（站点根目录） |
| `$host` | 请求 Host；无 Host 行则等于 server_name |
| `$request_filename` | 带主目录的完整文件路径（`/code/images/test.jpg`） |
| `$request_uri` | 不带主目录的请求路径（`/images/test.jpg`） |
| `$scheme` | 协议（http / https） |

**Rewrite 匹配优先级**
1. 执行 server 块的 rewrite 指令；
2. 执行 location 匹配；
3. 执行选定 location 中的 rewrite。

### 开启 rewrite 调试日志
```bash
# /etc/nginx/nginx.conf：错误日志级别设为 notice（nginx 中最低的错误级别）
error_log  /var/log/nginx/error.log notice;
# http 模块增加一行
rewrite_log     on;

# 测试配置
cat >/etc/nginx/conf.d/rewrite.conf<<EOF
server {
  listen 80;
  server_name r.oldboy.com;
  location  / {
    rewrite ^/ https://www.xuliangwei.com;
  }
}
EOF
nginx -t && systemctl restart nginx
# Windows hosts：10.0.0.9 r.oldboy.com，浏览器访问 r.oldboy.com
# tail -f /var/log/nginx/error.log
# 2018/09/29 15:49:58 [notice] *1 "^/" matches "/"
# 2018/09/29 15:49:58 [notice] *1 rewritten redirect: "https://www.xuliangwei.com"
```

### 例1：访问 /abc/1.html 实际访问 /cc/bb/2.html
```bash
# 准备真实路径
mkdir /code/cc/bb -p
echo "cc_bb2" >/code/cc/bb/2.html

cat > /etc/nginx/conf.d/rewrite.conf <<EOF
server {
  listen 80;
  server_name r.oldboy.com;
  location / {
    root /code;
    index index.html;
  }
  location ~* /abc/1.html {
    rewrite (.*) /cc/bb/2.html redirect;
    # return 302 /cc/bb/2.html;   # 等价但无日志
  }
}
EOF
nginx -t && systemctl restart nginx
# 浏览器访问 http://r.oldboy.com//abc/1.html
```

### 例2：/2018/ccc/bbb/2.html → /2014/ccc/bbb/2.html
```bash
mkdir /code/2014/ccc/bbb -p
echo "2014" > /code/2014/ccc/bbb/2.html

cat > /etc/nginx/conf.d/rewrite.conf <<EOF
server {
  listen 80;
  server_name r.oldboy.com;
  location / { root /code; index index.html; }
  location ~* /2018/ccc/bbb/2.html {
    rewrite (.*) /2014/ccc/bbb/2.html redirect;
  }
}
EOF
nginx -t && systemctl restart nginx
```

### 例3：/test 下任意内容 → 跳到外部站
```nginx
server {
  listen 80;
  server_name r.oldboy.com;
  location /test {
    rewrite (.*) https://www.xuliangwei.com;
  }
}
```

### 例4：course-11-22-33.html → /course/11/22/33/course_33.html
```bash
mkdir -p /code/course/11/22/33/
echo "bgx123.com" > /code/course/11/22/33/course_33.html

cat > /etc/nginx/conf.d/rewrite.conf <<EOF
server {
  listen 80;
  server_name r.oldboy.com;
  location / {
    root /code;
    index index.html;
    # 灵活写法：把 a-b-c-d.html 映射成 /a/b/c/d/a_d.html
    rewrite ^/(.*)-(.*)-(.*)-(.*).html /$1/$2/$3/$4/$1_$4.html;
  }
}
EOF
nginx -t && systemctl reload nginx
# 访问 http://r.oldboy.com/course-11-22-33.html
```

### 例5：HTTP 请求跳转 HTTPS
```nginx
server {
  listen 80;
  server_name s.oldboy.com;
  rewrite (.*) https://$server_name$request_uri redirect;
  # return 302 https://$server_name$request_uri;
}
server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / { root /code; index index.html; }
}
```

---

## 三、Rewrite 标记 Flag

| flag | 含义 |
| --- | --- |
| `last` | 停止当前请求处理，用重写后的 URL **重新发起新请求**（通常跳到别的 location 继续处理） |
| `break` | 停止当前 rewrite 规则集，不再尝试后续规则；**不重新发起请求**，在当前 location 继续处理 |
| `redirect` | 返回 **302** 临时重定向，每次浏览器都询问服务端（不缓存） |
| `permanent` | 返回 **301** 永久重定向，浏览器缓存，**只询问一次** |

**301 vs 302**
- `redirect`（302）：每次都问服务端（浏览器不记录）。
- `permanent`（301）：访问一次后记录跳转，下次直接跳、不再询问。

**last 与 break 对比**（需求：旧 `r.oldboy.com/2019_new` 跳转新地址，但浏览器 URL 不变）
```nginx
server {
  listen 80;
  server_name r.oldboy.com;
  root /code;
  location ~ ^/2019_new { rewrite ^/2019_new /2017_old/ break; }   # 404 风险
  location ~ ^/2020_new { rewrite ^/2020_new /2017_old/ last; }    # 重新发起请求
  location ~ ^/2017_old { root /code; index index.html; }
}
mkdir /code/2017_old -p && echo "2017_code" > /code/2017_old/index.html
systemctl restart nginx
```
- `last`：`/2020_new` → 重新请求 → 命中 `/2017_old` → 正常返回。
- `break`：`/2019_new` 重写后**不重新请求**，直接在当前 location 找 `/code/2017_old/` 默认页，不存在则 404。

---

## 四、Nginx HTTPS

### 1. 为什么用 HTTPS
HTTP 不安全：① 传输数据被中间人盗用、信息泄露；② 数据被劫持、篡改。

**证书购买选择**：单域名（`www`）、多域名（`www images cdn test m`）、通配符（`*.oldboy.com`）。
**HTTPS 注意事项**
- 不支持三级域名解析；证书到期需重新申请替换（不支持续费）；
- 绿锁：全站 URL 都是 https；黄锁：页面含 http 不安全链接；红锁：证书假或过期。
- 自己颁发的证书都是「黑户」（不被 CA 承认），仅学习/内网可用。

### 2. 自签证书
```bash
# 前置：openssl 1.0.2+，nginx 带 --with-http_ssl_module
openssl version
nginx -V | grep http_ssl_module

mkdir /etc/nginx/ssl_key -p && cd /etc/nginx/ssl_key

# 1. 生成带密码私钥（密码记牢，这里 1234）
openssl genrsa -idea -out server.key 2048

# 2. 生成自签证书（同时去掉私钥密码）
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 \
  -keyout server.key -out server.crt
# 交互：CN / WH / WH / edu / SA / bgx / bgx@foxmail.com
# req=创建证书  new=新证书  x509=标准格式  key=私钥  out=证书  days=有效期
```

### 3. 单台 Nginx 启用 HTTPS
```nginx
server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / { root /code; index index.html; }
}
server {
  listen 80;
  server_name s.oldboy.com;
  rewrite (.*) https://$server_name$request_uri redirect;   # 强制跳 HTTPS
}
```
> 加 flag → 跳转带 301/302；不加 → 直接 200 访问原地址。

### 4. 作业：单台 WordPress 配 HTTPS
```nginx
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
  location / { root /code/wordpress; index index.php index.html; }
  location ~ \.php$ {
    root /code/wordpress;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
  }
}
```

### 5. 负载均衡 + 后端 Web 实现 HTTPS
```bash
# 环境
# lb01: 10.0.0.5/172.16.1.5  nginx-proxy
# web01: 10.0.0.7/172.16.1.7  nginx-web01
# web02: 10.0.0.8/172.16.1.8  nginx-web02

# 后端统一生成证书（生成一次，其余拷贝）
mkdir /etc/nginx/ssl_key -p && cd /etc/nginx/ssl_key
openssl genrsa -idea -out server.key 2048
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt

# 后端 web01（web02 直接 scp 配置）
cat > /etc/nginx/conf.d/blog.oldboy.com.conf <<EOF
server {
  listen 443;
  server_name blog.oldboy.com;
  root /code/wordpress;
  index index.php index.html;
  ssl on;
  ssl_certificate  ssl_key/server.crt;
  ssl_certificate_key ssl_key/server.key;
  location ~ \.php$ {
    root /code/wordpress;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
  }
}
EOF
scp -rp /etc/nginx/* root@172.16.1.8:/etc/nginx/
systemctl restart nginx   # web01 / web02 都重启

# 证书拷到 Proxy
scp -rp /etc/nginx/ssl_key/ root@172.16.1.5:/etc/nginx/

# lb01 负载均衡
cat > /etc/nginx/conf.d/proxy.conf <<EOF
upstream site {
  server 172.16.1.7:443 max_fails=1 fail_timeout=60s;
  server 172.16.1.8:443 max_fails=1 fail_timeout=60s;
}
server {
  listen 443;
  server_name blog.oldboy.com;
  ssl on;
  ssl_certificate  ssl_key/server.crt;
  ssl_certificate_key ssl_key/server.key;
  location / {
    proxy_pass https://site;
    include proxy_params;
  }
}
server {
  listen 80;
  server_name blog.oldboy.com;
  return 302 https://$server_name$request_uri;
}
EOF
systemctl restart nginx
```
> ⚠️ WordPress 若最初用 HTTP 安装，开 HTTPS 后会破图/加载不全。解决：① 安装前就配好 HTTPS；② 后台「设置→常规」把 WordPress 地址与站点地址改为 `https://`。

---

## 五、常见面试题

1. **rewrite 的 last 和 break 区别？**
   `last` 重写后**重新发起新请求**（会再走 location 匹配）；`break` 重写后**不重新请求**，在当前 location 继续处理后续、不再匹配其他 rewrite。

2. **redirect 和 permanent 区别（302 vs 301）？**
   `redirect` 返回 302 临时重定向，浏览器每次都询问服务端；`permanent` 返回 301 永久重定向，浏览器缓存只询问一次。

3. **HTTPS 相比 HTTP 解决什么问题？**
   防数据被中间人窃听、篡改、伪造。HTTP 明文传输不安全。

4. **自己签发的证书能用于生产吗？**
   不能（不被 CA 承认，浏览器报红锁/不信任）。生产应向受信 CA 购买或申请免费证书（如 Let's Encrypt）。

5. **负载均衡 + 后端都配 HTTPS 时要注意什么？**
   证书统一（通配符或同一证书）；WordPress 等若先 HTTP 安装需改后台地址为 HTTPS，否则破图。

6. **keepalived 在公有云能用吗？**
   不能。公有云 LB 自带高可用，VIP 漂移由厂商处理，无法用 keepalived 抢占。

7. **脑裂怎么解决？**
   主备写脚本：备机检测是否还能 ping 通主且自己是否异常持有 VIP，异常则杀本机 keepalived；同时配合 Nginx 存活检测脚本，Nginx 起不来就杀 keepalived 触发漂移。

---

> 更新：2026-05-06 15:16:34
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/zlz9fp>
