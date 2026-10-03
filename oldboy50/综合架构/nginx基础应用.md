# Nginx 基础应用

## 一、用户访问网站的完整流程

```
1. 输入域名 → 浏览器跳转 → DNS 解析（客户端→服务端：递归查询；服务端→服务端：迭代查询）
2. 建立 TCP 连接（三次握手）
    客户端 → 服务端：SYN=1 seq=x
    服务端 → 客户端：SYN=1 ACK=x+1 seq=y
    客户端 → 服务端：ACK=y+1 seq=x+1（连接建立）
3. 发起 HTTP 请求
    方法（GET）、Host（www.oldboyedu.com）、资源（/index.html）、端口（80/443）、参数（类型/压缩/认证等）
4. 服务端响应
    软件（nginx）、文件类型、是否压缩、是否长连接
5. 断开 TCP（四次挥手）
    客户端 → 服务端：FIN=1 seq=x
    服务端 → 客户端：FIN=1 ACK=x+1 seq=y
    服务端 → 客户端：FIN=1 ACK=x+1 seq=z
    客户端 → 服务端：ACK=z+1 seq=sj
```

---

## 二、Nginx 基本简述

> Nginx 是开源、高性能、可靠的 **HTTP Web 服务 + 代理服务**。
> - 开源：直接获取源码
> - 高性能：支持海量并发
> - 可靠：服务稳定

### 常见的 HTTP Web 服务
| 软件 | 来源 |
| --- | --- |
| Httpd | Apache 基金会 |
| IIS | 微软服务器版 |
| GWS | Google 开发 |
| OpenResty | Nginx + LuaJIT + 大量 Lua 库（阿里/腾讯/百度都在用） |
| Tengine | 淘宝基于 Nginx 开发 |

> 传统防火墙工作在网络四层（TCP/UDP，按端口如 22/80 放行）；基于 Nginx+Lua 可实现 **WAF 应用层防火墙（七层）**。

### Nginx 能防护哪些攻击（运维必背）
| 攻击类型 | 示例 |
| --- | --- |
| SQL 注入 | `?id=1' union select` |
| XSS 跨站 | `<script>alert(1)</script>` |
| 命令注入 | `?cmd=cat /etc/passwd` |
| CC 攻击 / 恶意爬虫 | 高频请求打垮服务 |
| IP 黑名单 / UA 黑名单 | 屏蔽恶意来源 |
| 目录遍历 | `../etc/passwd` |
| 非法请求方法 | TRACE、PUT |

> 不用自己开发！有成熟开源轻量 WAF：**ngx_lua_waf**（基于 OpenResty）。

### 用 OpenResty 集成 ngx_lua_waf
```bash
# 1. 安装 OpenResty（替代 Nginx，自带 Lua）
yum install -y yum-utils
yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
yum install -y openresty

# 2. 下载 WAF 规则
cd /usr/local/openresty/nginx/conf/
git clone https://github.com/loveshell/ngx_lua_waf.git waf

# 3. 配置集成
http {
  lua_package_path "/usr/local/openresty/nginx/conf/waf/?.lua";
  lua_shared_dict limit 10m;
  init_by_lua_file  /usr/local/openresty/nginx/conf/waf/init.lua;
  access_by_lua_file /usr/local/openresty/nginx/conf/waf/waf.lua;
  server {
    listen 80;
    location / { root html; }
  }
}

# 4. 重启生效
systemctl restart openresty
# ✅ WAF 生效，自动拦截恶意请求
```

---

## 三、为什么选择 Nginx

1. **非常轻量**：核心模块少（其余以插件形式安装），代码模块化、易读、便于二次开发。
2. **互联网公司都选它**：技术成熟、统一选型降低维护成本、涉足场景多、技术更新成本低。
3. **网络模型**：Nginx 用 **epoll**；Apache 用 **select**。
   - `select`：每次请求都遍历扫描所有 fd，性能低。
   - `epoll`：事件就绪直接处理，高效且无连接数限制。

> I/O 多路复用：可同时监控多个文件描述符，就绪时通知程序读写。`select` / `poll` / `epoll`。

---

## 四、Nginx 应用场景
- 静态网站部署（html/css/图片）
- 反向代理（转发请求给后端）
- 负载均衡（分发流量到多台服务器）
- HTTPS 配置
- 缓存、限流、防盗链
- 集成 Lua 做 WAF 防火墙

---

## 五、Nginx 快速安装

版本分类：`Mainline version`（开发版）、`Stable version`（稳定版）、`Legacy version`（历史版本）。
三种安装方式：
1. **epel 仓库**：版本低、配置文件不一样（不推荐）
2. **源码编译**：复杂、企业基本不用
3. **官方仓库（推荐）**：版本新、安装简单、配置不复杂

```bash
# 官方仓库（推荐写法）
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx-stable]
name=nginx stable repo
baseurl=https://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

# 或精简写法
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx
baseurl=http://nginx.org/packages/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF

yum install yum-utils -y
yum clean all && yum makecache
yum install nginx -y        # 一定确认是官方仓库安装
nginx -v                   # 查看版本（如 nginx/1.14.0）
nginx -V                   # 查看编译参数

# 指定查看 nginx 源的软件列表
yum --disablerepo=\* --enablerepo=nginx-stable list | grep nginx
```

**编译参数越多越好还是越少越好？**
- 越少：功能少，后期可维护性差；
- 越多：功能全、覆盖广、可维护性强。

---

## 六、Nginx 配置文件

`/etc/nginx/nginx.conf` 是纯文本配置，以区块 `{}` 组织。三大核心模块：
- **CoreModule**（核心）：可包含 Event、HTTP
- **EventModule**（事件驱动）：`worker_connections`、`use epoll`
- **HttpCoreModule**（HTTP 内核）：可包含多个 `server`（多站点）；`server` 内可有多个 `location`（访问路径）

| 路径 | 作用 |
| --- | --- |
| `/etc/nginx/nginx.conf` | 主配置文件 |
| `/etc/nginx/conf.d/` | 子配置文件目录（最常用） |
| `/usr/share/nginx/html` | 默认网站根目录 |
| `/var/log/nginx/` | 日志目录（access.log / error.log） |
| `/usr/sbin/nginx` | 启动命令 |

```nginx
# /etc/nginx/nginx.conf
user  nginx;                                   # 运行用户
worker_processes  1;                           # worker 进程数
error_log  /var/log/nginx/error.log warn;      # 错误日志
pid        /var/run/nginx.pid;
events {
  worker_connections  1024;                    # 单 worker 最大连接数
  use epoll;                                   # 事件模型（默认 epoll）
}
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  keepalive_timeout  65;                       # 长连接超时
  #gzip  on;
  include /etc/nginx/conf.d/*.conf;
}
```

```nginx
# /etc/nginx/conf.d/default.conf
server {
  listen       80;
  server_name  localhost;
  location / {
    root   /usr/share/nginx/html;
    index  index.html index.htm;
  }
  error_page   500 502 503 504  /50x.html;
}
```

**常用命令**
```bash
systemctl start nginx       # 启动
systemctl stop nginx        # 停止
systemctl restart nginx     # 重启
systemctl reload nginx      # 重载配置（不中断业务，推荐）
systemctl enable nginx      # 开机自启
nginx -t                    # 检查配置语法（修改后必执行）
tail -f /var/log/nginx/access.log   # 实时访问日志
tail -f /var/log/nginx/error.log    # 实时错误日志
```

---

## 七、部署一个站点
```bash
cat > /etc/nginx/conf.d/oldboy_game.conf <<EOF
server {
  listen 80;
  server_name game.oldboy.com;
  location / {
    root /oldboy_code;
    index index.html;
  }
  access_log /var/log/nginx/access.log;
}
EOF

mkdir /oldboy_code
echo "hello world html" > /oldboy_code/index.html
nginx -t && systemctl start nginx && systemctl reload nginx

# 访问方式：
# 1. 直接 IP：http://10.0.0.7
# 2. 域名（改 hosts）：
#    Windows: C:\Windows\System32\drivers\etc\hosts  → 10.0.0.7 game.oldboy.com
#    Mac:     sudo vim /etc/hosts
# 用 ping 测试解析，再浏览器访问 game.oldboy.com
```

---

## 八、Nginx 目录索引（autoindex）
```nginx
autoindex on;                  # 开启目录索引
autoindex_exact_size off;     # off：显示大概大小（kB/MB/GB）；on：精确 bytes
autoindex_localtime on;        # on：显示服务器本地时间
charset utf-8,gbk;            # 解决中文目录乱码
```

```bash
cat > /etc/nginx/conf.d/oldboy_game.conf <<EOF
server {
  listen 80;
  server_name game.oldboy.com;
  charset utf-8,gbk;
  location / {
    root /oldboy_code;
    index index.html;
  }
  location /centos {
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
    root /oldboy_code;
  }
}
EOF
mkdir -p /oldboy_code/centos
touch /oldboy_code/centos/aaaa.txt
mkdir -p /oldboy_code/centos/centos{1..10}
nginx -t && systemctl reload nginx
# 访问 http://game.oldboy.com/centos/
```
> 开启目录索引后，上传文件显示其修改时间；本地创建则与服务器时间一致。

---

## 九、Nginx 状态监控（stub_status）
```bash
cat > /etc/nginx/conf.d/oldboy_game.conf <<EOF
server {
  listen 80;
  server_name game.oldboy.com;
  charset utf-8,gbk;
  location / {
    root /oldboy_code;
    index index.html;
  }
  location /centos {
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
    root /oldboy_code;
  }
  location /nginx_status {
    stub_status;
  }
}
EOF
nginx -t && systemctl reload nginx
# 访问 http://game.oldboy.com/nginx_status
```

**状态含义**
```
Active connections: 1          # 当前活动连接数
server accepts handled requests
 2 2 36                        # TCP总连接 / 成功连接 / 总HTTP请求
Reading: 0 Writing: 1 Waiting: 0
```
| 字段 | 含义 |
| --- | --- |
| Active connections | 当前活动连接数 |
| accepts | TCP 总连接数 |
| handled | TCP 成功连接数（失败 = 总 - 成功） |
| requests | 总 HTTP 请求数（一次 TCP 可含多次 HTTP = 长连接） |
| Reading | 正在读请求 |
| Writing | 正在写响应 |
| Waiting | 等待的请求数（已开启 keepalive） |

> `keepalive_timeout 0`：每次连接仅一次请求（短连接）；`65`：65s 内请求建立在同一个连接上（长连接）。

---

## 十、Nginx 访问控制

### 1. 基于 IP 地址
```nginx
# 语法
# allow address | CIDR | unix: | all;   Context: http/server/location
# deny  address | CIDR | unix: | all;

# 示例1：拒绝指定 IP，其他允许
location /nginx_status {
    stub_status;
    access_log off;
    deny 10.0.0.1/32;
    allow all;
}
# 10.0.0.1 访问 → 403 Forbidden

# 示例2：只允许本机，其他拒绝
location /nginx_status {
    stub_status;
    allow 127.0.0.1;
    deny all;
}
```

### 2. 基于用户密码
```bash
# 安装工具并生成密码文件
yum install httpd-tools -y
htpasswd -b -c /etc/nginx/auth_conf ckh 123456

cat > /etc/nginx/conf.d/oldboy_game.conf <<EOF
server {
  listen 80;
  server_name game.oldboy.com;
  charset utf-8,gbk;
  location / {
    root /oldboy_code;
    index index.html;
  }
  location /centos {
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
    root /oldboy_code;
    auth_basic "不要随便尝试, 滚蛋!";
    auth_basic_user_file /etc/nginx/auth_conf;
  }
  location /nginx_status {
    stub_status;
    allow 127.0.0.1;
    deny all;
  }
}
EOF
nginx -t && systemctl reload nginx
# 访问 http://game.oldboy.com/centos/ 提示输入账号密码

# 推荐组合写法（参考 fj.xuliangwei.com）
location / {
  root /code;
  autoindex on;
  autoindex_localtime on;
  autoindex_exact_size off;
  access_log off;
  auth_basic "Permission denied";
  auth_basic_user_file /etc/nginx/auth_conf;
}
```

**用户认证局限性 & 解决**
- 局限：用户信息依赖文件、管理文件过多无法联动、操作机械效率低。
- 解决：① Nginx 结合 Lua 高效验证；② 结合 LDAP（`nginx-auth-ldap` 模块）。

---

## 十一、Nginx 访问限制（防 CC / 爬虫 / 限流）

两个核心模块：**`ngx_http_limit_conn_module`**（限制连接数）、**`ngx_http_limit_req_module`**（限制请求数）。

- `limit_conn`：控制**同一 IP 同时能建多少个 TCP 连接**。
- `limit_req`：控制**同一 IP 每秒能发多少个 HTTP 请求**（防 CC 神器）。

### 1. http 块内定义规则
```nginx
# 请求频率限制（防 CC、防刷新）
# $binary_remote_addr：以 IP 为限流 key；zone=req_zone:10m：共享内存 10M；rate=10r/s：每秒 10 请求
limit_req_zone $binary_remote_addr zone=req_zone:10m rate=10r/s;
# limit_req zone=req_zone burst=20 nodelay;  # burst=20 排队，nodelay 超队直接拒

# 连接数限制（防大量并发）
limit_conn_zone $binary_remote_addr zone=conn_zone:10m;
# limit_conn conn_zone 10;  # 同 IP 最多 10 并发
```

### 2. server / location 中使用
```nginx
server {
  listen 80;
  server_name www.xxx.com;
  root /usr/share/nginx/html;
  index index.html;

  limit_req zone=req_zone burst=20 nodelay;   # 请求频率限制
  limit_conn conn_zone 10;                     # 连接数限制
  limit_req_status 429;                        # 超限返回 429
  limit_conn_status 429;

  location / { try_files $uri $uri/ /index.html; }

  location /api/ {
    limit_req zone=req_zone burst=10 nodelay;
    proxy_pass http://backend;
  }
}
```

### 生产最佳组合
```nginx
http {
    # 请求频率限制（防 CC）
    limit_req_zone $binary_remote_addr zone=req_zone:10m rate=15r/s;
    # 并发连接限制（防恶意并发）
    limit_conn_zone $binary_remote_addr zone=conn_zone:10m;

    server {
        listen 80;
        server_name www.xxx.com;
        root /usr/share/nginx/html;

        limit_req zone=req_zone burst=30 nodelay;   # 排队 30 突发，超队直接拒
        limit_conn conn_zone 15;                    # 单 IP 最多 15 并发
        limit_req_status 429;
        limit_conn_status 429;

        location / { try_files $uri $uri/ /index.html; }
    }
}
```
> `limit_req`：限制每秒请求数（防 CC、防刷）；`limit_conn`：限制同时连接数（防并发）。两者一起 = Nginx 层最强大免费防火墙。

**压测验证**
```bash
echo '10.0.0.4 game.oldboy.com' >> /etc/hosts
yum install -y httpd-tools
# A 主机压测
ab -n 500000 -c 20 http://game.oldboy.com/index.html
# B 主机同时压测会被限流、卡住/拒绝
ab -n 50 -c 20 http://game.oldboy.com/index.html
# 结果：Complete requests: 50  Successful，Failed requests: 46
```

---

## 十二、Nginx 日志配置

```bash
tail -f /var/log/nginx/access.log
# 10.0.0.1 - - [19/Sep/2018:08:43:45 +0800] "GET /favicon.ico HTTP/1.1" 503 615 "http://game.oldboy.com/" "Mozilla/5.0 ..." "-"
# 字段：IP - 用户 - 时间 方法 路径 协议 状态码 大小 referer UA 真实IP
```

### log_format
```bash
Syntax: log_format name [escape=default|json] string ...;
Default: log_format combined "...";
Context: http

log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
  '$status $body_bytes_sent "$http_referer" '
  '"$http_user_agent" "$http_x_forwarded_for"';
```
| 变量 | 含义 |
| --- | --- |
| `$remote_addr` | 客户端 IP |
| `$remote_user` | 客户端用户名 |
| `$time_local` | 本地时间 |
| `$time_iso8601` | ISO8601 标准时间 |
| `$request` | 请求方法 + HTTP 协议 |
| `$status` | 状态码（定位错误） |
| `$body_bytes_sent` | 发给客户端的资源字节数（不含响应头） |
| `$bytes_sent` | 发给客户端总字节数 |
| `$msec` | 日志写入时间（秒，毫秒精度） |
| `$http_referer` | 来源页面 |
| `$http_user_agent` | 客户端浏览器 |
| `$http_x_forwarded_for` | 客户端真实 IP（经代理时） |
| `$request_length` | 请求长度（行+头+正文） |
| `$request_time` | 请求耗时（秒，毫秒精度） |

> 若 Nginx 在反向代理/LB 之后，`$remote_addr` 取到的是代理 IP；代理会在 `X-Forwarded-For` 中追加真实客户端 IP。

#### access_log
```bash
Syntax: access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];
access_log off;
Default: access_log logs/access.log combined;
Context: http, server, location, if in location, limit_except
```

#### 日志切割（logrotate）
```bash
cat /etc/logrotate.d/nginx
/var/log/nginx/*.log {
        daily
        missingok
        rotate 52
        compress
        delaycompress
        notifempty
        create 640 nginx adm
        sharedscripts
        postrotate
                if [ -f /var/run/nginx.pid ]; then
                        kill -USR1 `cat /var/run/nginx.pid`
                fi
        endscript
}
```

#### 指定站点/路径日志
```nginx
# /etc/nginx/conf.d/oldboy_game.conf
server {
  listen 80;
  server_name game.oldboy.com;
  charset utf-8,gbk;
  access_log /var/log/nginx/game.log main;
  location / {
    root /oldboy_code;
    index index.html;
  }
  location /centos {
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
    root /oldboy_code;
    auth_basic "plase passwd user";
    auth_basic_user_file /etc/nginx/auth_conf;
    access_log /var/log/nginx/game.centos.log main;
  }
}
```

---

## 十三、Nginx 虚拟站点（一台服务器多网站）

> 虚拟主机：一台服务器上配置多个网站（如公司主页、博客、论坛）。

### 基于域名
```bash
cat > /etc/nginx/conf.d/oldboy_avi.conf <<EOF
server {
  listen 80;
  server_name avi.oldboy.com;
  location / {
    root /oldboy_code2;
    index index.html;
  }
}
EOF
mkdir -p /oldboy_code2 && echo "avi" > /oldboy_code2/index.html
# Windows hosts 加：10.0.0.7 avi.oldboy.com
```

### 基于端口
```bash
cat > /etc/nginx/conf.d/oldboy_edu.conf <<EOF
server { listen 8081; server_name edu.oldboy.com; location / { root /oldboy_code3; index index.html; } }
EOF
cat > /etc/nginx/conf.d/oldboy_avi.conf <<EOF
server { listen 8080; server_name avi.oldboy.com; location / { root /oldboy_code2; index index.html; } }
EOF
# 访问：http://10.0.0.7:8081/  http://10.0.0.7:8080/
# 基于端口的多网站一般仅公司内部使用（域名与否影响不大）
```

---

## 十四、Nginx Location（匹配规则与优先级）

> 一个 server 可有多个 location，但匹配有优先级。

```nginx
location [修饰符] /uri/ { ... }
# 修饰符：= | ^~ | ~ | ~* | !~ | !~* | /
```

| 修饰符 | 类型 | 含义 | 优先级 | 生产示例 |
| --- | --- | --- | --- | --- |
| `=` | 精准匹配 | 完全等于路径，立即终止 | 1（最高） | `location = /api/login` |
| `^~` | 前缀匹配 | 以路径开头，匹配后**不查正则** | 2 | `location ^~ /static/` |
| `~` | 正则（区分大小写） | 正则匹配 | 3 | `location ~ \.php$` |
| `~*` | 正则（不区分大小写） | 正则匹配 | 3 | `location ~* \.PNG$` |
| `!~` | 正则取反（区分） | 不匹配正则才生效 | 4 | `location !~ \.sh$` |
| `!~*` | 正则取反（不区分） | 不匹配正则才生效 | 4 | `location !~* \.exe$` |
| 无（前缀） | 普通前缀 | 以路径开头，继续查正则 | 5 | `location /api/` |
| `/` | 通用匹配 | 兜底，匹配所有 | 6（最低） | `location /` |

```nginx
location / { }                                   # 通用匹配
location ~ \.php$ { fastcgi_pass 127.0.0.1:9000; }  # 区分大小写，.php 走 PHP
location ~ \.zip$ { deny all; }                 # 区分大小写，.zip 拒绝
location ~* .*\.(jpg|gif|png|js|css)$ {         # 不区分大小写，静态资源
  root /code/xuliangwei;
  expires 7d;
}
location ~* "\.(sql|bak|tgz|tar.gz|.git)$" {    # 不区分大小写，敏感文件
  return 403 "启用访问控制成功";
}
```

---

## 十五、多 server_name 配置相同 IP 的冲突

```bash
# 给想让 IP 访问的 server 加 default_server → IP 访问强制走这里
server {
    listen 80 default_server;
    server_name 192.168.1.100;
    root /data/web;
}
server {
    listen 80;
    server_name 192.168.1.100;
    root /usr/share/nginx/html;
}
```
> 多个 server 配相同 IP + 同端口 = 冲突。优先级：`default_server` > 配置中第一个出现的 server > 其他。解决：给目标 server 加 `listen 80 default_server;`。

---

## 十六、常见面试题

1. **Nginx 为什么性能高？**
   采用 **epoll** 事件模型（事件就绪直接处理，无连接上限），而 Apache 用 select（每次遍历，性能低）；且轻量、模块化。

2. **`location` 的优先级顺序？**
   `=` 精准(1) > `^~` 前缀(2) > `~`/`~*` 正则(3) > 无修饰前缀(5) > `/` 通用(6)。注意正则 `~` 和 `~*` 同级，按配置先后。

3. **怎么实现 Nginx 防 CC 攻击 / 限流？**
   用 `limit_req_zone` + `limit_req`（限制每秒请求数）和 `limit_conn_zone` + `limit_conn`（限制并发连接数），超限返回 429。

4. **`limit_req` 的 burst 和 nodelay 是什么？**
   `burst` 是突发请求排队缓冲数；`nodelay` 表示超过「速率+队列」的请求立即拒绝，不延迟等待。

5. **Nginx 访问控制有哪几种？**
   基于 IP（`allow`/`deny`）和基于用户密码（`auth_basic` + `auth_basic_user_file`）。

6. **如何获取经过代理后的真实客户端 IP？**
   代理侧配置 `X-Forwarded-For`，后端从 `$http_x_forwarded_for` 读取；`$remote_addr` 只能看到代理 IP。

7. **多个 server 都配了相同 IP，冲突怎么办？**
   给想作为 IP 访问入口的 server 加 `listen 80 default_server;`，优先级最高。

8. **Nginx 怎么集成 WAF？**
   用 OpenResty（Nginx+Lua）配合 ngx_lua_waf，通过 `access_by_lua_file` 在请求阶段拦截 SQL 注入、XSS 等攻击。

---

> 词汇：select 选择 / epoll 网络模型(nginx采用) / Mainline 主流主线 / Stable 稳定 / Legacy 历史 / enable 开启 / code 代码 / built 建造 / core 核心 / worker 工人 / connections 连接 / processes 进程 / include 包含 / sendfile 发送文件 / keepalive 保持连接 / autoindex 自动索引 / exact 精确 / deny 拒绝 / allow 允许 / auth 认证 / basic 基本 / zone 地带 / binary 二进制 / remote 远程 / addr 地址 / limit 限制 / burst 突发 / nodelay 无延迟 / active 活跃 / reading 阅读 / writing 写作 / waiting 等待 / accepts 接受 / handled 已处理 / requests 请求
> 更新：2026-05-05 16:53:02
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/eq9pkg>
