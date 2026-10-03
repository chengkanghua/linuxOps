# HTTPS 配置案例

> 两个实战案例：① 单台 Web 配置 HTTPS；② Nginx 负载均衡 + 后端 Web 全链路 HTTPS。

---

## 案例 1：单台 Web 配置 HTTPS

```bash
# 1. 生成自签证书（生产应替换为受信 CA 证书）
mkdir /etc/nginx/ssl_key -p
cd /etc/nginx/ssl_key
openssl genrsa -idea -out server.key 2048
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt

# 2. 配置 Nginx
cat > /etc/nginx/conf.d/https.conf <<EOF
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
  rewrite (.*) https://$server_name$1 redirect;
  # return 302 https://$server_name$request_uri;
}
EOF

echo "https....." > /code/index.html
nginx -t && systemctl restart nginx
# Windows hosts：10.0.0.9 s.oldboy.com  → 浏览器访问 https://s.oldboy.com
```

---

## 案例 2：Nginx 负载均衡 + Nginx Web 配置 HTTPS

> ⚠️ 证书用通配符，生产必须统一；自签证书可随意（黑户，仅供学习）。
> 若后端节点不直接对用户提供服务，可不监听 80（只留 443）。

```bash
# 环境
# lb01: 10.0.0.5/172.16.1.5  nginx-proxy
# web01: 10.0.0.7/172.16.1.7  nginx-web01
# web02: 10.0.0.8/172.16.1.8  nginx-web02

# 1. 后端统一生成证书（一次即可，其余拷贝）
mkdir /etc/nginx/ssl_key -p && cd /etc/nginx/ssl_key
openssl genrsa -idea -out server.key 2048
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt

# 2. 后端 web01（wordpress）
cat > /etc/nginx/conf.d/wordpress.conf <<EOF
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
EOF

# 3. 配置第二台 web02（直接拷贝）
scp -rp /etc/nginx/ssl_key/ root@172.16.1.8:/etc/nginx/
scp -rp /etc/nginx/conf.d/ root@172.16.1.8:/etc/nginx/
systemctl restart nginx   # web01、web02 都重启

# 4. 拷贝证书到 Proxy
scp -rp /etc/nginx/ssl_key/ root@172.16.1.5:/etc/nginx/

# 5. lb01 负载均衡
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

> ⚠️ WordPress 若最初用 HTTP 安装，开启 HTTPS 后会破图/加载不全。建议：① 安装前就配好 HTTPS；② 后台「设置→常规」把 WordPress 地址与站点地址改为 `https://`。

**架构示意图**
![架构1](img/HTTPS%E9%85%8D%E7%BD%AE%E6%A1%88%E4%BE%8B-01.png)
![架构2](img/HTTPS%E9%85%8D%E7%BD%AE%E6%A1%88%E4%BE%8B-02.png)
![架构3](img/HTTPS%E9%85%8D%E7%BD%AE%E6%A1%88%E4%BE%8B-03.png)

---

## 常见面试题

1. **负载均衡 + 多后端都配 HTTPS，证书怎么管理？**
   用同一张证书（通配符 `*.oldboy.com` 最省事）；所有后端和 LB 上放同一份证书，避免主机名不匹配告警。

2. **后端不直接对外服务，需要监听 80 吗？**
   不需要。只暴露 443 给 LB（或 LB 用内网转发），80 仅用于 LB 侧做 HTTP→HTTPS 跳转。

3. **WordPress 从 HTTP 切到 HTTPS 为什么破图？**
   页面里资源 URL 是 http，混合内容被浏览器拦截。解决：后台把站点地址改成 https，或开启 WordPress 全站 https。

4. **单台 HTTPS 配置要点？**
   签发/部署证书、`listen 443 ssl`、`ssl_certificate`/`ssl_certificate_key`，再用 80 server 做 `return 302 https://`。

5. **自签证书能用在生产吗？**
   不能（不受信，浏览器红锁）。生产用受信 CA（含免费 Let's Encrypt）证书。

---

> 更新：2026-05-06 15:45:22
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/nylmf8>
