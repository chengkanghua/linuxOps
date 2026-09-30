# Nginx 代理服务

> Nginx 作为代理服务可代理多种协议，以 **HTTP 代理** 最常用。代理解决「客户端无法直接访问服务端」的问题。

## 一、正向代理 vs 反向代理

| 类型 | 数据流 | 代理对象 |
| --- | --- | --- |
| **正向代理**（内部上网） | 客户端 ⇄ 代理 → 服务端 | **客户端**（帮内部用户访问外网） |
| **反向代理** | 客户端 → 代理 ⇄ 服务端 | **服务端**（帮后端挡在前面对外） |

> 核心区别：代理对象不同。正向代理代理客户端；反向代理代理服务端。

![反向代理](img/Nginx%E4%BB%A3%E7%90%86%E6%9C%8D%E5%8A%A1-01.png)
![反向代理](img/Nginx%E4%BB%A3%E7%90%86%E6%9C%8D%E5%8A%A1-02.png)

---

## 二、代理配置语法

```nginx
# 推荐写法：把通用代理参数抽到 proxy_params 统一 include
server {
  listen 80;
  server_name blog.oldboy.com;
  location / {
    proxy_pass http://172.16.1.7;
    include proxy_params;
  }
}
```

```nginx
# /etc/nginx/proxy_params —— 发往后端的请求头 + 超时 + 缓冲区
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

---

## 三、反向代理实战示例

**环境**

| 角色 | 外网 IP | 内网 IP | 主机名 |
| --- | --- | --- | --- |
| proxy | 10.0.0.5 | 172.16.1.5 | lb01 |
| web01 | 10.0.0.7 | 172.16.1.7 | web01 |

### 1. web01 后端（监听 8080）
```nginx
# /etc/nginx/conf.d/web.conf
server {
  listen 8080;
  server_name 172.16.1.7;
  location / {
    root /code_8080;
    index index.html;
    deny 10.0.0.0/24;     # 拒绝外网网段直接访问
    allow all;
  }
}
```
```bash
mkdir /code_8080
echo "web01-7..." > /code_8080/index.html
systemctl restart nginx
```

### 2. proxy 代理服务器
```bash
# 配置官方源并安装
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF
yum install nginx -y

# 关闭默认站点
cd /etc/nginx/conf.d/ && mv default.conf default.conf.off

cat > /etc/nginx/conf.d/proxy.conf <<EOF
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
EOF

nginx -t && systemctl start nginx && systemctl enable nginx
```
> Windows `C:\Windows\System32\drivers\etc\hosts` 添加：`10.0.0.5 nginx.oldboy.com`
> 浏览器访问 `http://nginx.oldboy.com/`

### 3. 验证真实客户端 IP 已透传
```bash
# web01 访问日志
tail -f /var/log/nginx/access.log
# 172.16.1.5 - - [25/Sep/2018:11:46:01 +0800] "GET / HTTP/1.0" 304 0 "-" "..." "10.0.0.1"
#                                                              ↑ X-Forwarded-For 里的真实客户端 IP
```
日志末尾的 `10.0.0.1` 就是代理服务器透传的**真实客户端 IP**（靠 `X-Forwarded-For`）。

---

## 四、优化 proxy 配置（抽公共参数）

```bash
cat > /etc/nginx/proxy_params <<EOF
# 发往后端的请求头：host / 客户端 IP / 真实客户端 IP
proxy_set_header Host \$http_host;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
# 代理到后端的连接/发送/读取超时
proxy_connect_timeout 30;
proxy_send_timeout 60;
proxy_read_timeout 60;
# 代理缓冲区
proxy_buffering on;
proxy_buffer_size 32k;
proxy_buffers 4 128k;
EOF

vim /etc/nginx/conf.d/proxy.conf
server {
  listen 80;
  server_name nginx.oldboy.com;
  location / {
    proxy_pass http://172.16.1.7:8080;
    include proxy_params;     # 复用公共参数，避免重复书写
  }
}
systemctl restart nginx
```

---

## 五、常见面试题

1. **正向代理和反向代理的区别？**
   正向代理代理**客户端**（帮内网用户访问外网，如科学上网/缓冲）；反向代理代理**服务端**（对外暴露统一入口，隐藏后端，做负载均衡）。

2. **Nginx 反向代理怎么让后端拿到真实客户端 IP？**
   代理配置加 `proxy_set_header X-Real-IP $remote_addr;` 和 `X-Forwarded-For $proxy_add_x_forwarded_for;`，后端从 `X-Forwarded-For` 取值。

3. **`proxy_params` 文件有什么用？**
   把 host、X-Forwarded-For、超时、缓冲区等公共代理参数抽到独立文件，各 `location` 用 `include proxy_params;` 复用，减少重复、便于维护。

4. **`proxy_pass` 后面加不加 `/` 有什么影响？**
   加 `/`（如 `proxy_pass http://up/;`）会把 `location` 匹配到的路径部分**剔除**再转发；不加 `/` 则**原样转发**完整 URI。这是最容易踩坑的点，需按后端期望的路径配置。

5. **`X-Forwarded-For` 和 `X-Real-IP` 区别？**
   `X-Real-IP` 只记录直接客户端 IP；`X-Forwarded-For` 是**逗号分隔的链**，记录经过的每一跳代理，多层代理下更完整。

---

> 更新：2026-05-05 19:33:12
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/tdcl6m>
