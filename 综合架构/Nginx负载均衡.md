# Nginx 负载均衡

> 单台 Web 服务器难扛高并发，用多台 Web 组成集群，前端 Nginx 做负载均衡把请求分散到后端，可大幅提升吞吐、性能和高可用。Nginx 是典型的 **SLB（Server Load Balance）**。

## 一、几个基础认知

- **负载均衡具备反向代理功能**，但范围不同：
  - 反向代理 `proxy_pass` → 只能代理一台服务器；
  - 负载均衡 `upstream` + `proxy_pass` → 代理多台（集群）。
- 协议区分：`proxy_pass` 走 HTTP 协议；`fastcgi_pass` 走 FastCGI 协议（连 php-fpm）。

**常见名词**
| 名词 | 含义 |
| --- | --- |
| 调度 / 前端 | 负载均衡器（如 Nginx/LVS） |
| LB | Load Balance，负载均衡 |
| SLB | Server Load Balance（阿里云叫 SLB） |
| CLB | 腾讯云负载均衡 |
| ULB | UCloud 负载均衡 |

### 按 OSI 层级划分
- **四层负载均衡**：基于 TCP/UDP，只能按 IP + 端口转发（LVS、Nginx stream、HAProxy）。
- **七层负载均衡**：基于 HTTP 等应用协议，可按域名/URL 转发（Nginx 最常用）。

### 端口与域名怎么配？
1. 前端代理端口和后端的 Web 端口**不必须统一**。
2. 前端 80、后端 8080/8081/8082，可不用域名（可以，但不建议）。
3. **最推荐**：前后端都用 `blog.oldboy.com`、都监听 80，前端配 `proxy_pass` 指向后端池。

---

## 二、配置场景

Nginx 负载均衡用 `proxy_pass` 模块，把客户端请求代理转发到一组 `upstream` 虚拟服务池。

![负载均衡架构](img/Nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1-06.png)

**环境**

| 角色 | 外网(NAT) | 内网(LAN) | 主机名 |
| --- | --- | --- | --- |
| LB01 | 10.0.0.5 | 10.0.0.5 | lb01 |
| web01 | 10.0.0.7 | 10.0.0.7 | web01 |
| web02 | 10.0.0.8 | 10.0.0.8 | web02 |

**upstream 语法**
```nginx
Syntax: upstream name { ... }
Default: -
Context: http

upstream backend {
  server backend1.example.com       weight=5;
  server backend2.example.com:8080;
  server unix:/tmp/backend3;
  server backup1.example.com:8080   backup;    # 备份节点
}
server {
  location / {
    proxy_pass http://backend;
  }
}
```

**web01**
```nginx
# /etc/nginx/conf.d/node.conf
server {
  listen 80;
  server_name node.oldboy.com;
  location / {
    root /node;
    index index.html;
  }
}
```
```bash
mkdir /node && echo 'web01.....' > /node/index.html
nginx -t && systemctl restart nginx
```

**web02**
```nginx
# /etc/nginx/conf.d/node.conf （同 web01）
server {
  listen 80;
  server_name node.oldboy.com;
  location / { root /node; index index.html; }
}
```
```bash
mkdir /node && echo 'web02.....' > /node/index.html
nginx -t && systemctl reload nginx
```

**lb01（负载均衡器）**
```nginx
# /etc/nginx/conf.d/node_proxy.conf
upstream node {
  server 172.16.1.7:80;
  server 172.16.1.8:80;
}
server {
  listen 80;
  server_name node.oldboy.com;
  location / {
    proxy_pass http://node;
    include proxy_params;
  }
}
```

**Windows 测试**
```
C:\Windows\System32\drivers\etc\hosts
10.0.0.5    node.oldboy.com
# 浏览器访问 http://node.oldboy.com/  （交替返回 web01/web02）
```

---

## 三、后端节点状态

| 状态 | 说明 |
| --- | --- |
| `down` | 当前 server 暂时不参与调度（维护时用，效果类似注释） |
| `backup` | 预留备份服务器，只有其他节点都不可用时才启用 |
| `max_fails` | 允许请求失败的次数 |
| `fail_timeout` | 达到 `max_fails` 失败后，暂停服务的时间 |
| `max_conns` | 限制该节点最大接收连接数 |

```nginx
# down：不参与任何调度，相当于注释
upstream load_pass {
  server 10.0.0.7:80 down;
}

# backup + max_fails/fail_timeout
upstream load_pass {
  server 10.0.0.7:80;
  server 10.0.0.8:80 backup;                 # 备份
  server 10.0.0.9:80 max_fails=1 fail_timeout=10s;  # 失败 1 次后暂停 10s
}
```

---

## 四、调度算法

| 算法 | 说明 |
| --- | --- |
| **轮询（默认）** | 按时间顺序逐一分配到不同后端（最常用） |
| **weight 加权轮询** | `weight` 越大分配几率越高（机器配置不均衡时使用） |
| **ip_hash** | 按访问 IP 的 hash 分配，同一 IP 固定访问同一后端（会话保持） |
| **url_hash** | 按访问 URL 的 hash 分配，同一 URL 定向到同一后端（缓存命中友好） |
| **least_conn** | 最少连接数，哪台连接少就分发给哪台 |

```nginx
# 1. 轮询（默认）
upstream load_pass {
  server 10.0.0.7:80;
  server 10.0.0.8:80;
}

# 2. 加权轮询
upstream load_pass {
  server 10.0.0.7:80 weight=5;
  server 10.0.0.8:80;
}

# 3. ip_hash（注意：不能和 weight 一起用；若客户端都走同一代理，会导致某台连接过多）
upstream load_pass {
  ip_hash;
  server 10.0.0.7:80;
  server 10.0.0.8:80;
}

# 4. url_hash（同一 URL 固定到同一后端）
upstream load_pass {
  hash $request_uri;
  server 192.168.56.11:8001;
  server 192.168.56.11:8002;
  server 192.168.56.11:8003;
}
# 三台后端放相同文件 url1/2/3.html，访问 /url1.html 始终落到同一台

# 5. 综合示例：失败检测 + 备份
upstream blog {
  server 172.16.1.7:80 max_fails=2 fail_timeout=10s;
  server 172.16.1.8:80 max_fails=2 fail_timeout=10s;
  server 172.16.1.9:80 backup;
}
```

**实战：给 blog/edu/zh 三套站点加统一负载均衡**
```nginx
# /etc/nginx/conf.d/proxy.conf
upstream php {
  server 172.16.1.7:80;
  server 172.16.1.8:80;
  server 172.16.1.9:80;
}
server {
  listen 80;
  server_name blog.oldboy.com;
  location / { proxy_pass http://php; include proxy_params; }
}
server {
  listen 80;
  server_name edu.oldboy.com;
  location / { proxy_pass http://php; include proxy_params; }
}
server {
  listen 80;
  server_name zh.oldboy.com;
  location / { proxy_pass http://php; include proxy_params; }
}
```

---

## 五、核心知识点速记

- 负载均衡 = 反向代理（一台）+ `upstream`（多台集群）。
- 协议：`proxy_pass` → HTTP；`fastcgi_pass` → FastCGI。
- 名词：调度/前端、LB、SLB（阿里）、CLB（腾讯）、ULB（UCloud）。
- 分层：四层（TCP/UDP，按端口）、七层（HTTP，Nginx 最常用）。
- 后端状态：`down` 维护、`backup` 备份、`max_fails`+`fail_timeout` 失败检测。
- 调度算法：默认轮询（常用）、加权（配置不均）、ip_hash（会话保持，易偏载）、url_hash（缓存友好）、least_conn（谁闲给谁）。

---

## 六、常见面试题

1. **反向代理和负载均衡的区别？**
   反向代理 `proxy_pass` 只能代理一台；负载均衡用 `upstream` 代理多台集群。负载均衡包含反向代理能力。

2. **Nginx 负载均衡有哪些调度算法？默认哪个？**
   轮询（默认）、加权轮询、ip_hash、url_hash、least_conn。

3. **ip_hash 的作用和缺点？**
   同一客户端 IP 固定到同一后端，实现会话保持；缺点是若客户端都经同一代理出口，会导致某台负载过高。

4. **backup 和 down 的区别？**
   `down` 当前节点完全不参与调度（维护）；`backup` 平时不参与，只有其他节点都不可用时才启用。

5. **max_fails 和 fail_timeout 配合有什么用？**
   在 `fail_timeout` 时间内失败达到 `max_fails` 次，就把该节点标记为不可用并暂停 `fail_timeout` 时长，实现故障自动剔除。

6. **Nginx 是四层还是七层负载均衡？**
   默认七层（基于 HTTP）；1.9+ 通过 `stream` 模块支持四层。

---

> 更新：2026-05-05 19:32:54
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/wsqdes>
