# HAProxy 安装配置

> HAProxy 是 C 语言编写的自由开源软件，提供**高可用、负载均衡**，以及基于 **TCP 和 HTTP** 的应用代理。适合大负载 Web 站点（常需会话保持或七层处理），单机即可支撑数万并发。采用**事件驱动 + 单进程模型**，资源利用高效，且能安全整合进现有架构、隐藏后端真实服务器。GitHub、Stack Overflow、Reddit、Twitter 等都在用。

---

## 一、负载均衡分层（回顾）

| 层级 | 依据 | 说明 | 代表产品 |
| --- | --- | --- | --- |
| 二层（MAC） | 虚拟 MAC | 外部请求虚拟 MAC，负载均衡按 MAC 分配后端 | — |
| 三层（IP） | 虚拟 IP | 外部请求虚拟 IP，按 IP 分配后端 | — |
| 四层（TCP） | IP + 端口 | 在三层基础上按端口转发 | F5、LVS、Nginx、HAProxy |
| 七层（HTTP） | URL/主机名 | 按虚拟 URL 或主机名转发到对应处理服务器 | HAProxy、Nginx、Apache、MySQL Proxy |

---

## 二、安装

### 1. Yum 安装（推荐）
```bash
yum -y install haproxy
```

### 2. 源码安装
官方文档：<https://cbonte.github.io/haproxy-dconv/>
源码包：<https://src.fedoraproject.org/repo/pkgs/haproxy/>

```bash
# 解压
tar xf haproxy-2.3.10.tar.gz && cd haproxy-2.3.10

# 创建运行用户
useradd -r -M -s /sbin/nologin haproxy

# 安装依赖
yum -y install make gcc pcre-devel bzip2-devel openssl-devel systemd-devel

# 查看 CPU 核数（用于并行编译）
grep 'processor' /proc/cpuinfo | wc -l
# 总核数 = 物理CPU个数 × 每CPU核数；总逻辑CPU = 物理CPU × 核数 × 超线程

# 编译（-j 指定并行数）
make -j $(grep 'processor' /proc/cpuinfo | wc -l) \
  TARGET=linux-glibc \
  USE_OPENSSL=1 USE_ZLIB=1 USE_PCRE=1 USE_SYSTEMD=1

make clean
make install PREFIX=/usr/local/haproxy
cp haproxy /usr/sbin/
file haproxy     # 确认：ELF 64-bit LSB executable
```

---

## 三、内核参数
```bash
echo 'net.ipv4.ip_nonlocal_bind = 1' >> /etc/sysctl.conf   # 允许绑定非本机 IP（VIP）
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
sysctl -p
```

---

## 四、配置文件结构

HAProxy 配置由 **global**（全局）和**代理设定**组成，共五段：

| 段 | 作用 |
| --- | --- |
| `global` | 全局参数，进程级，与 OS 相关（日志、用户、最大连接等） |
| `defaults` | 默认参数，可被 frontend/backend/listen 继承（重复则覆盖） |
| `frontend` | 接收请求的前端虚拟节点，可指定后端 backend |
| `backend` | 后端服务集群（真实服务器），一个 backend 对应多个实体服务器 |
| `listen` | frontend + backend 组合体，常用于状态监控（1.3 前唯一写法） |

### 完整示例
```bash
mkdir /etc/haproxy
cat > /etc/haproxy/haproxy.cfg <<EOF
#--------------全局配置----------------
global
    log 127.0.0.1 local0 info
    maxconn 20480
    pidfile /var/run/haproxy.pid
    user haproxy
    group haproxy
    daemon
#--------------默认配置----------------
defaults
    mode http
    log global
    option dontlognull
    option httpclose
    option httplog
    option redispatch
    balance roundrobin
    timeout connect 10s
    timeout client 10s
    timeout server 10s
    timeout check 10s
    maxconn 60000
    retries 3
#--------------统计页面----------------
listen admin_stats
    bind 0.0.0.0:8189
    stats enable
    mode http
    stats uri /haproxy_stats
    stats realm Haproxy\ Statistics
    stats auth admin:admin
    stats admin if TRUE
    stats refresh 30s
#--------------Web 集群----------------
listen webcluster
    bind 0.0.0.0:80
    mode http
    maxconn 3000
    balance roundrobin
    cookie SESSION_COOKIE insert indirect nocache
    server web01 192.168.110.10:80 check inter 2000 fall 5
EOF
```

---

## 五、时间格式
含时间的参数（如各类 timeout）默认单位**毫秒**，也可加后缀：

| 后缀 | 含义 |
| --- | --- |
| `us` | 微秒（1/1,000,000 秒） |
| `ms` | 毫秒（1/1,000 秒） |
| `s` | 秒 |
| `m` | 分钟 |
| `h` | 小时 |
| `d` | 天 |

---

## 六、global 配置详解
```bash
global
    log 127.0.0.1 local3         # 日志输出设置，local0 为设备，info 为级别
    log 127.0.0.1 local1 notice
    ulimit-n 82000               # 每进程最大文件描述符
    maxconn 20480                # 每进程最大并发连接
    chroot /usr/local/haproxy    # 锁定工作目录，提升安全（目录须为空且无写权限）
    uid 99                       # 运行用户 UID
    gid 99                       # 运行组 GID
    daemon                       # 后台守护进程运行
    nbproc 1                     # 进程数（默认 1，多进程仅特殊场景用）
    pidfile /usr/local/haproxy/run/haproxy.pid
```
- `maxconn` ≈ `ulimit -n`，限制每进程最大连接。
- `chroot` 提升安全，但目录必须空且不可写。
- `nbproc` 多进程模式调试困难，一般只用单进程。

---

## 七、defaults 配置详解
```bash
defaults
    log    global
    mode    http                  # 运行模式：http | tcp | health
    maxconn 50000
    option  httplog              # http 日志格式
    option  httpclose            # 每次请求后主动关闭 http 通道（不支持 keep-alive 时）
    option  dontlognull          # 不记录空连接（健康检查）日志
    option  forwardfor           # 让后端拿到客户端真实 IP（从 header 取）
    retries 3                    # 连接失败重试次数，超过认为后端不可用
    option abortonclose          # 高负载时结束掉队列中等待过久的连接
    balance roundrobin           # 默认调度：轮询（source 类似 nginx ip_hash）
    timeout http-request  10s
    timeout queue          1m
    timeout connect        10s    # 与后端连接超时（同局域网可设小）
    timeout client         1m     # 与客户端非活动连接超时
    timeout server         1m     # 与上游非活动连接超时
    timeout http-keep-alive 10s
    timeout check          10s    # 健康检查超时
```
- **mode**：`http`（七层，深度分析、校验 RFC）、`tcp`（四层，SSL/SSH/SMTP 常用）、`health`（已基本不用）。
- `option httpclose` 与 `option http-server-close`：前者每次关通道，后者支持长连接复用。
- `timeout queue`：后端高负载时请求进队列，定义排队超时。
- 旧版 `contimeout/clitimeout/srvtimeout` 已被 `timeout connect/client/server` 取代（向后兼容）。

---

## 八、frontend / backend / listen 配置

**frontend**（1.3 后引入，按 ACL 指定后端）
```bash
frontend http_80_in
    bind 0.0.0.0:80        # 监听端口（类似 LVS 的 VIP）
    mode http
    log global
    option httplog
    option httpclose
    option forwardfor       # 让后端获取真实客户端 IP
    default_backend wwwpool # 默认转发到的后端池
```

**backend**
```bash
backend wwwpool
    mode http
    option redispatch       # 后端挂掉时把会话重派到其他服务器
    option abortonclose
    balance source          # 源 IP 哈希（类似 ip_hash，会话保持）
    cookie SERVERID         # 插入 serverid 到 cookie
    option httpchk GET /test.html   # 心跳检测
    server web1 10.1.1.2:80 cookie 2 weight 3 check inter 2000 rise 2 fall 3 maxconn 8
```

**listen（状态监控常用）**
```bash
listen admin_status
    bind 0.0.0.0:8888
    mode http
    log 127.0.0.1 local3 err
    stats refresh 5s
    stats uri /admin?stats
    stats realm itnihao\ welcome
    stats auth admin:admin
    stats auth admin1:admin1
    stats hide-version
    stats admin if TRUE      # 手工启停后端（1.4.9+）
```

---

## 九、启动
```bash
# yum 安装
systemctl start haproxy

# 源码安装（指定配置启动）
haproxy -f /etc/haproxy/haproxy.cfg
```

---

## 十、日志配置
HAProxy 默认不记录日志，需**两处**配合：

**1. haproxy.cfg 增加日志**
```bash
defaults
    log global
    option httplog
    log 127.0.0.1 local7
```
日志级别 `local0~local7`（另有 16~23 保留本地）。级别表：

| 级别 | 代码 | 描述 |
| --- | --- | --- |
| emerg | 0 | 系统不可用 |
| alert | 1 | 必须立即处理 |
| crit | 2 | 关键事件 |
| err | 3 | 错误事件 |
| warning | 4 | 警告 |
| notice | 5 | 普通但重要 |
| info | 6 | 有用信息 |
| debug | 7 | 调试信息 |

**2. 系统日志开启 UDP 接收（HAProxy 日志走 UDP）**
```bash
# /etc/rsyslog.conf
$ModLoad imudp
$UDPServerRun 514
local7.* /root/haproxy/log/haproxy.log

# /etc/sysconfig/rsyslog 开启远程
SYSLOGD_OPTIONS="-r -m 0 -c 2"
# -r 开启远程日志；-m 0 禁用时间戳标记；-c 2 兼容模式
```
```bash
systemctl restart rsyslog

# 重启 haproxy（源码方式）
ps -ef | grep haproxy
kill -9 <PID>
haproxy -f /usr/local/haproxy/conf/haproxy.cfg
```

> 参考：<https://www.cnblogs.com/leixixi/p/14749322.html>

---

## 十一、常见面试题

1. **HAProxy 支持哪几层负载均衡？**
   四层（TCP，mode tcp）和七层（HTTP，mode http）；不支持二层/三层（那是 LVS 的强项）。

2. **HAProxy 配置文件有哪五段？**
   global / defaults / frontend / backend / listen。

3. **mode http 和 mode tcp 的区别？**
   http 模式对请求做七层深度分析、校验 RFC，可做 URL/Host 路由；tcp 模式只做四层转发，用于 SSL/SSH/SMTP 等。

4. **怎么让后端拿到客户端真实 IP？**
   frontend/backend 加 `option forwardfor`，后端从 `X-Forwarded-For` 头取。

5. **HAProxy 如何实现会话保持？**
   `balance source`（源 IP 哈希）；或用 `cookie` 插入 SERVERID 绑定后端。

6. **HAProxy 日志配不出来常见原因？**
   只在 cfg 里配了 log 还不够，还要在 rsyslog 开启 UDP 监听（`imudp`/`UDPServerRun 514`）并重启 rsyslog。

---

> 原文：<https://www.cnblogs.com/leixixi/p/14749322.html>
