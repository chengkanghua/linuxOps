# 第二阶段 · Web 基础之 HTTP

> 本文是运维理解「Web 请求全链路」的基础。抓包、排错、性能优化、HTTPS 配置，全都建立在对 HTTP 的理解上。

---

## 一、HTTP 核心基础

### 1. 本质与工作模式
- **HTTP** = Hyper Text Transfer Protocol（超文本传输协议），基于 TCP/IP 的应用层协议，采用「**客户端—服务器**」请求 / 响应模式。
- **无状态**：协议本身不记录请求上下文。登录态、会话保持靠 Cookie / Session 解决（排查登录失效、会话保持问题的基础）。

| 版本 | 运维核心关注点 |
| --- | --- |
| HTTP/1.0 | 短连接（每次请求新建 TCP，性能低） |
| HTTP/1.1 | 长连接（Keep-Alive 默认可用，减少握手开销；支持管道化请求） |
| HTTP/2 | 多路复用（单 TCP 连接处理多请求，性能大幅提升，Nginx 可启用） |
| HTTP/3 | 基于 QUIC（UDP），解决 TCP 队头阻塞，运维接触少，了解即可 |

### 2. 请求 / 响应结构（排错的「语言」）

用 `curl -v` 或抓包工具都能看到下面这些内容。

**请求结构**
```http
# 1. 概况
Request URL: http://10.0.0.7/index.html       # 请求的 URL
Request Method: GET                           # 请求方法
Status Code: 304 Not Modified                 # 返回状态
Remote Address: 10.0.0.7:80                   # 请求地址

# 2. 请求头
Accept: text/html,                            # 可接收类型
Accept-Encoding: gzip, deflate                # 是否接受压缩
Accept-Language: zh-CN,zh;q=0.9               # 语言偏好
Cache-Control: max-age=0                      # 缓存控制
Connection: keep-alive                        # TCP 长连接
Host: www.oldboyedu.com                      # 请求域名（虚拟主机核心）
If-Modified-Since: Fri, 04 May 2018 08:13:44 GMT
If-None-Match: "a49-56b5ce607fe00"           # 校验标记（配合 304）
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0                       # 浏览器标识
# 空行
（请求体：POST/PUT 才有，如表单数据）
```
> 运维重点：`Host`（Nginx 据此匹配站点）、`Connection: Keep-Alive`、`Content-Length`（请求体大小）。

**响应结构**
```http
HTTP/1.1 304 Not Modified                     # 协议 + 状态码
Date: Fri, 14 Sep 2018 09:14:28 GMT           # 服务器时间
Server: Apache/2.4.6 (CentOS) PHP/5.4.16      # 服务端软件
Connection: Keep-Alive
Keep-Alive: timeout=5, max=100                # 长连接超时/最大请求数
ETag: "a49-56b5ce607fe00"                     # 校验标记
# ============ 空行 ============
# ============ 返回内容 ============
```
> 运维重点：`Server`（识别 Web 版本）、`Cache-Control`（缓存策略）、`Content-Encoding: gzip`（压缩状态）。

### 3. 相关术语：PV / UV / IP
- **PV（Page View）**：页面浏览量。
- **UV（Unique Visitor）**：独立访客数。
- **IP**：独立 IP 数。

> 例子：一栋楼 100 人，每人一台电脑 + 一个手机，都通过 NAT 出口上网，每人点击网站 2 次。
> - PV = 400（100人×2端×2次）
> - UV = 200（100 人 × 2 端）
> - IP = 1（NAT 出口只有 1 个公网 IP）

### 4. 什么是 URL
URL（Uniform Resource Locator，统一资源定位符）唯一标识互联网上的某个文档，由 **协议 + 主机 + 端口（默认 80）+ 文件名** 构成。

![URL 结构](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-01.png)

**为什么要有 `www.`？**
`www.` 本质是 `qq.com` 主域名下的子域名，加它的原因有三类：
1. **历史约定**：早期一台服务器跑多种服务，用子域名区分：`www.`→网页、`mail.`→邮件、`ftp.`→文件传输。
2. **技术区分**：不同服务对应不同虚拟主机 / 端口。
3. **业务适配**：超大型站点（如腾讯）把 `www` 作为 Web 服务的统一入口，形成用户「肌肉记忆」。

### 5. CDN 核心解析
CDN（Content Delivery Network，内容分发网络）本质是**分布在全球 / 全国的缓存服务器集群**，核心目标是「让用户就近访问资源」——把源站静态资源（图片、JS、CSS、视频、下载包）缓存到离用户最近的节点，解决「跨地域访问慢、源站压力大、带宽成本高」三大问题。

- **核心是「就近缓存」**：静态资源分发到各地节点，用户不用远访源站，速度快、源站压力小。
- **工作流程**：DNS 智能解析到就近节点 → 节点命中直接返回，未命中回源缓存后返回。
- **运维操作**：配置缓存规则、刷新 / 预热缓存、排查节点解析 / 缓存故障。

---

## 二、运维高频 HTTP 知识点（必背）

### 1. 状态码（排查 Web 故障的「信号灯」）

不用记全，但必须掌握以下高频码的**含义 + 排查方向**：

| 分类 | 核心码 | 含义 | 运维排查方向 |
| --- | --- | --- | --- |
| 2xx 成功 | 200 | 请求成功 | 正常，无需排查 |
| | 206 | 部分请求（断点续传） | 检查 Nginx 是否支持 `range` |
| 3xx 重定向 | 301 | 永久重定向 | 检查 Nginx `rewrite`（SEO 场景常用） |
| | 302 | 临时重定向 | 排查业务跳转逻辑 |
| | 304 | 未修改（缓存命中） | 检查静态资源缓存配置（`expires` / `Cache-Control`） |
| 4xx 客户端错误 | 400 | 请求参数错误 | 客户端请求格式问题，抓包看请求体 |
| | 403 | 禁止访问 | 文件权限 / SELinux / Nginx `allow|deny` / 目录无索引页 |
| | 404 | 资源不存在 | 检查 Nginx 根目录 / 路径、文件是否存在 |
| | 408 | 请求超时 | 客户端发送慢，查网络或客户端 |
| | 499 | Nginx 特有：客户端主动断开 | 后端响应慢，客户端提前关闭，调大 `proxy_read_timeout` |
| 5xx 服务端错误 | 500 | 服务器内部错误 | 后端程序报错（PHP/Java）、Nginx 配置语法错 |
| | 502 | 坏网关 | 后端服务挂了（Tomcat/PHP-FPM）、代理地址错误 |
| | 503 | 服务不可用 | 后端过载 / 维护中，查进程 / 负载均衡 |
| | 504 | 网关超时 | 后端响应慢，调大 `proxy_read_timeout`、查慢请求 |

### 2. HTTP 请求方法

#### (1) 核心方法（RFC 标准，最常用）
| 方法 | 大白话 | 典型场景 | 幂等 |
| --- | --- | --- | --- |
| **GET** | 「查」：获取资源 | 访问网页、查询、下载 | ✅ |
| **POST** | 「增/提交」：提交数据创建资源 | 登录、下单、上传 | ❌ |
| **PUT** | 「改（全量）」：替换资源 | 更新用户全部字段 | ✅ |
| **DELETE** | 「删」：删除资源 | 删除订单 / 用户 | ✅ |
| **HEAD** | 只取响应头 | 检查文件是否存在、大小 | ✅ |
| **OPTIONS** | 「查权限」 | 跨域预检（CORS）、接口探测 | ✅ |
| **PATCH** | 「改（增量）」：部分更新 | 只改手机号 | ❌ |
| **TRACE** | 回显请求，调试 | 排查转发问题（极少用） | ✅ |
| **CONNECT** | 建立隧道 | 代理转发 HTTPS | ❌ |

#### (2) 幂等性（面试高频）
- **幂等**：多次执行同一请求，结果和一次完全一样（无副作用）。如 `GET /user/1` 查 1 次和 100 次结果一样；`DELETE /order/1` 删 1 次和 100 次都是删除态。
- **非幂等**：多次执行可能不同结果。如 `POST /order` 多次会创建多个订单；`PATCH` 多次可能重复更新。

#### (3) GET vs POST 核心区别
| 维度 | GET | POST |
| --- | --- | --- |
| 数据位置 | URL 拼接（`?name=test`） | 请求体（Body） |
| 数据大小 | 受 URL 长度限制（一般 < 2KB） | 无限制（可传大文件） |
| 安全性 | 暴露在 URL，明文可见 | 在请求体，相对安全（仍需 HTTPS） |
| 缓存 | 可被浏览器缓存 | 默认不缓存 |
| 用途 | 查数据 | 提交 / 创建 |

#### (4) 实际高频用法
1. GET：所有查询（列表、详情、下载）。
2. POST：所有提交 / 创建（登录、注册、下单、上传）。
3. PUT：全量更新（替换整个用户信息）。
4. PATCH：增量更新（只改昵称）。
5. DELETE：删除（删评论、删订单）。
6. OPTIONS：前端跨域时浏览器先发预检，确认允许后发真实请求。

**总结**：核心方法 = `GET(查) POST(增) PUT/PATCH(改) DELETE(删)`，对应 CRUD。幂等：GET/PUT/DELETE/HEAD/OPTIONS 是，POST/PATCH/CONNECT/TRACE 否。实际 80% 场景用 GET/POST，PUT/PATCH/DELETE 用于 RESTful API。

### 3. 核心特性（优化 Web 性能的关键）
- **长连接 Keep-Alive**：减少 TCP 握手/挥手开销，提升并发。Nginx 配置 `keepalive_timeout 60;`、`keepalive_requests 10000;`。
- **缓存机制**：核心响应头 `Cache-Control`（`max-age=86400`）、`Expires`、`ETag`。Nginx `expires 7d;` 让静态资源缓存 7 天，减少后端请求。
- **压缩 gzip**：压缩响应体（HTML/CSS/JS），减少传输量。Nginx `gzip on;` + `gzip_types text/html text/css application/json;`。
- **跨域 CORS**：前端调后端报跨域，Nginx 加响应头：
  ```nginx
  add_header Access-Control-Allow-Origin *;
  add_header Access-Control-Allow-Methods GET,POST,OPTIONS;
  ```

### 4. HTTPS 基础（运维必配）
HTTPS = HTTP + SSL/TLS（加密传输，解决明文泄露、篡改、伪造）。
- **核心配置**：`ssl_certificate` / `ssl_certificate_key`；禁用低版本 `ssl_protocols TLSv1.2 TLSv1.3;`。
- **常见问题**：证书过期（需监控告警）、HTTPS 慢（开 `ssl_session_cache` 缓存会话）、混合内容（页面同时加载 HTTP/HTTPS 资源）。

### 5. 运维必备工具
```bash
# curl：测试 HTTP 请求（排错第一工具）
curl -v http://www.baidu.com        # 看完整请求/响应
curl -I http://www.baidu.com        # 只看响应头
curl -X POST -d "name=test" http://www.baidu.com   # 测试 POST

# ab（Apache Bench）：压测
ab -n 1000 -c 100 http://www.baidu.com/    # 100 并发，共 1000 请求

# tcpdump：抓包分析
tcpdump -i eth0 port 80 -w http.pcap        # 抓 80 端口存文件，用 Wireshark 分析
```

### 6. Nginx 完整配置示例（反向代理 + 缓存 + 压缩 + HTTPS）
**前提**：Nginx 编译含 `ngx_http_proxy_module`（代理）、`ngx_http_gzip_module`（压缩）、`ngx_http_ssl_module`（HTTPS）。

```nginx
http {
  # ===== 1. 压缩（对应 HTTP gzip 特性）=====
  gzip on;
  gzip_vary on;
  gzip_min_length 1k;
  gzip_comp_level 6;
  gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
  gzip_proxied any;

  # ===== 2. 反向代理缓存（可选，对应 HTTP 缓存）=====
  proxy_cache_path /var/nginx/cache levels=1:2 keys_zone=OLD_BOY_CACHE:10m max_size=10g inactive=60m use_temp_path=off;

  # ===== 3. 长连接（对应 HTTP/1.1 Keep-Alive）=====
  keepalive_timeout 60s;
  keepalive_requests 10000;
  proxy_http_version 1.1;
  proxy_set_header Connection "";

  # HTTP 站点：强制跳转 HTTPS
  server {
    listen 80;
    server_name www.oldboy.com;
    rewrite ^(.*)$ https://$host$1 permanent;   # 301 永久重定向
  }

  # HTTPS 站点
  server {
    listen 443 ssl http2;
    server_name www.oldboy.com;

    ssl_certificate     /etc/nginx/ssl/oldboy.crt;
    ssl_certificate_key /etc/nginx/ssl/oldboy.key;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;

    location / {
      proxy_pass http://192.168.1.100:8080;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_connect_timeout 30s;
      proxy_read_timeout 60s;
      proxy_send_timeout 60s;

      proxy_cache OLD_BOY_CACHE;
      proxy_cache_valid 200 304 10m;
      proxy_cache_valid any 1m;
      proxy_cache_key $host$request_uri;
      add_header X-Proxy-Cache $upstream_cache_status;
    }

    # 静态资源缓存（对应 Cache-Control/Expires）
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
      root /data/www;
      expires 7d;
      add_header Cache-Control "public, max-age=604800";
      access_log off;
    }
  }
}
```

**配置项 ↔ HTTP 知识点对照**

| 配置项 | 对应 HTTP 知识点 | 运维价值 |
| --- | --- | --- |
| `gzip on` | 压缩特性 | 减少传输量，提速 |
| `expires 7d` | 缓存（Cache-Control/Expires） | 静态资源缓存，减后端压力 |
| `proxy_pass` | 反向代理 | 隔离后端，统一入口 |
| `proxy_read_timeout` | 请求超时 | 解决 504 |
| `ssl_protocols TLSv1.2+` | HTTPS 安全层 | 避免低版本 TLS 被攻击 |
| `keepalive_timeout` | HTTP/1.1 长连接 | 减握手开销，提并发 |

**验证**
```bash
nginx -t && systemctl restart nginx
# 验证压缩/缓存：
curl -I -H "Accept-Encoding: gzip" https://www.xxx.com/css/index.css
# 响应头含 Content-Encoding: gzip、Cache-Control: max-age=604800 即生效
```

### 7. 常见排查思路
1. **访问慢**：`curl -w "%{time_total}\n" -o /dev/null http://xxx` 测总耗时；抓包判断是握手慢 / 处理慢 / 传输慢；检查长连接、gzip、缓存是否生效。
2. **502/504**：502 先查后端（`ps -ef | grep php-fpm`）、代理地址是否正确；504 调大 `proxy_read_timeout`，查后端慢查询 / 卡死。
3. **403**：看 `error.log`；查文件权限（Nginx 进程用户是否有权）、SELinux（`getenforce`）。

---

## 三、HTTP 工作原理（完整 7 步流程）

以「访问 `http://www.baidu.com/index.html`」为例：

**步骤 1：DNS 解析**
浏览器把域名解析成 IP（可 `nslookup www.oldboy.com` 验证）。过程：本地缓存 → 本地 DNS → 根 → 顶级域 → 目标域，最终拿到 IP（如 192.168.1.100）。

**步骤 2：TCP 三次握手**
HTTP 基于 TCP（可靠传输），与服务器 80（HTTP）/ 443（HTTPS）建连。
- 握手失败 → 端口未监听（`ss -lntup | grep 80`）、防火墙拦截。
- HTTP/1.1 默认**长连接**，一次 TCP 可处理多次请求（HTTP/1.0 是短连接）。

**步骤 3：客户端发送请求**
```http
GET /index.html HTTP/1.1
Host: www.oldboy.com
User-Agent: Chrome/120.0.0.0
Connection: Keep-Alive
# 空行
（请求体：GET 无，POST/PUT 才有）
```
- `Host` 错 → 404/400；方法被禁用（如 DELETE）→ 405。

**步骤 4：服务器接收并处理**
Web 服务器（Nginx/Apache）监听 80/443，做三件事：① 解析请求头（`Host` 匹配站点）；② 处理（静态直接读文件，动态转发 PHP-FPM/Tomcat）；③ 生成响应。
- 静态找不到 → 404（查 `root`/权限）；动态失败 → 500（查后端日志）。

**步骤 5：服务器返回响应**
```http
HTTP/1.1 200 OK
Server: nginx/1.20.1
Content-Type: text/html
Content-Length: 1024
Cache-Control: max-age=86400
# 空行
<html>...</html>
```
- 状态码是排错关键：502=后端挂、304=缓存命中、403=权限不足。

**步骤 6：关闭 / 复用 TCP 连接**
- 短连接（1.0）：响应完四次挥手关闭。
- 长连接（1.1）：连接保持，可继续发请求。需注意：`keepalive_timeout` 过小 → 握手频繁性能降；过大 → 连接堆积占端口。

**步骤 7：客户端渲染**
浏览器解析 HTML/CSS/JS，加载静态资源（又会触发新 HTTP 请求）。静态资源慢 → 查缓存/压缩、CDN 是否生效。

**请求全链路（含架构）**
```
1. 客户端输入域名、请求页面
2. 本地可能做一次 redirect 跳转
3. 解析域名对应 DNS
4. 拿到 DNS 解析出的 IP
5. 与服务端 TCP 三次握手（长连接）
6. 发起 HTTP 请求，先到前端防火墙
7. 防火墙识别身份，正常请求经内部交换机→负载均衡→下发请求
8. 负载均衡按内容下发到后端 Web
9. Web 解析请求：
   静态：Web→NFS 取图片→返回（负载→防火墙→用户）
   动态：Web→动态程序→解析
10. 动态程序遇查库，先连缓存→查缓存
11. 缓存无数据→再连数据库→查询
12. 数据库→动态程序→缓存→Web→负载→防火墙→用户
```

**HTTP 核心特性（运维必懂）**
- **无状态（Stateless）**：协议不记前后关联。解决：Cookie/Session 维持登录态；负载均衡需 `ip_hash` 会话保持，避免登录失效。
- **无连接（1.0）→ 长连接（1.1）**：`Connection: Keep-Alive` 复用 TCP，Nginx `keepalive_requests 10000` 提升并发。
- **明文（HTTP）→ 加密（HTTPS）**：HTTP 明文易被窃听/篡改，生产必须禁用 HTTP、强制 HTTPS。
- **媒体无关性**：可传输任意类型，靠 `Content-Type` 标识。配错 → 浏览器下载本该显示的图片、页面乱码。

---

## 四、访问网站抓包分析

1. **浏览器解析 URL** 中的超链接。
2. **DNS 请求**：PC 向 DNS 服务器发 QUERY，请求 `www.qq.com` 的 A 记录。
   ![DNS 请求](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-03.png)
3. **DNS 回复**：解析出 `www.qq.com` 对应三条 A 记录（如 59.37.96.63、14.17.42.40、14.17.32.211）。A 记录 = 主机名解析成 IP。
   ![DNS 回复](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-04.png)
4. **TCP 三次握手**：PC 向解析出的服务器地址发起握手。
   ![三次握手](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-05.png)
5. **发送 GET 请求**：PC 向服务器请求主页。
   ![GET 请求](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-06.png)
6. **服务器响应**：`HTTP/1.1 200 OK`，返回主页数据。
   ![响应](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-07.png)
7. **四次挥手断开连接**。

**POST 请求方法**：向指定资源提交要被处理的数据。
![POST](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-08.png)

---

## 五、HTTP 头部字段详解

| 头 (header) | 类型 | 说明 |
| --- | --- | --- |
| User-Agent | 请求 | 浏览器及平台信息，如 Mozilla/5.0 |
| Accept | 请求 | 客户端能处理的页面类型，如 text/html |
| Accept-Charset | 请求 | 可接受的字符集，如 UTF-8 |
| Accept-Encoding | 请求 | 可处理的编码，如 gzip |
| Accept-Language | 请求 | 自然语言，如 zh-cn |
| Host | 请求 | 服务器 DNS 名（从 URL 提取，必需） |
| Referer | 请求 | 用户从哪个页面跳转而来 |
| Cookie | 请求 | 把已设 Cookie 回传服务器，作为会话信息 |
| Date | 双向 | 消息发送时间 |
| Server | 响应 | 服务器软件信息，如 Microsoft-IIS/6.0 |
| Content-Encoding | 响应 | 内容编码方式，如 gzip |
| Content-Language | 响应 | 页面自然语言 |
| Content-Length | 响应 | 页面字节长度 |
| Content-Type | 响应 | 页面 MIME 类型 |
| Last-Modified | 响应 | 页面最后修改时间（缓存机制关键） |
| Location | 响应 | 重定向到另一个 URL |
| Set-Cookie | 响应 | 服务器希望客户端保存的 Cookie |

- **UA 字段**：`User-Agent` 标识浏览器（操作系统；加密等级；语言）渲染引擎 版本。
  ![UA](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-09.png)
- **Server 字段**：响应头包含处理请求的原始服务器软件信息。
  ![Server](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-10.png)
- **Referer 字段**：浏览器向 Web 服务器表明自己从哪个网页 / URL 跳转而来。
  ![Referer](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-11.png)
  ![Referer2](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-12.png)
- **HTTP 重定向**：`Location` 告诉浏览器对象已移动到别处，去该位置取。
  ![重定向](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-13.png)

---

## 六、常见面试题

1. **HTTP 和 HTTPS 的区别？**
   HTTP 明文传输，易被窃听/篡改；HTTPS = HTTP + SSL/TLS 加密，需配置证书、禁用低版本 TLS。生产应强制 HTTPS。

2. **HTTP/1.0、1.1、2.0 的核心区别？**
   1.0 短连接；1.1 长连接 + 管道化；2.0 多路复用（单连接多请求）。

3. **常见状态码 301/302/304/403/404/500/502/503/504 含义？**
   301 永久重定向、302 临时、304 缓存命中、403 禁止（权限）、404 不存在、500 服务端错、502 后端挂、503 不可用、504 网关超时。

4. **GET 和 POST 的区别？**
   数据位置（URL vs Body）、大小限制、安全性、缓存、用途（查 vs 提交）。

5. **什么是幂等？哪些方法幂等？**
   多次执行结果一致即幂等。GET/PUT/DELETE/HEAD/OPTIONS/TRACE 幂等；POST/PATCH/CONNECT 非幂等。

6. **HTTP 无状态怎么解决登录态？**
   用 Cookie/Session；多后端时需 `ip_hash` 会话保持或 Session 共享（Redis）。

7. **502 和 504 怎么排查？**
   502 查后端服务是否挂、代理地址是否正确；504 调大 `proxy_read_timeout`，查后端慢请求。

8. **Nginx 怎么优化 Web 性能（对应 HTTP 特性）？**
   gzip 压缩、静态资源 `expires` 缓存、Keep-Alive 长连接、反向代理缓存。

---

> 更新：2026-05-04 17:10:01
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/gpo7u6>
