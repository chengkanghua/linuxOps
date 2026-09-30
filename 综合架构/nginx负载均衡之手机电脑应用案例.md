# Nginx 负载均衡之手机/电脑应用案例

> 场景：根据客户端 **User-Agent（浏览器/手机）** 或 **访问目录** 把请求转发到不同后端；并用 Keepalived 实现负载均衡器的双机热备。

环境：
```
proxy  10.0.0.5          # 负载均衡
web01  10.0.0.7          # 模拟 iPhone 页面
web02  10.0.0.8          # 模拟 Android 页面
```

---

## 一、按手机/浏览器类型分流（基于 `$http_user_agent`）

### 1. 准备 web01 / web02 站点
```bash
# web01
cat > /etc/nginx/conf.d/sj.conf <<EOF
server {
  listen 80;
  server_name sj.oldboy.com;
  location / {
    root /sj;
    index index.html;
  }
}
EOF
mkdir /sj && echo "Ipone....." > /sj/index.html
nginx -t && systemctl restart nginx

# web02（配置相同，内容不同）
mkdir /sj && echo "Android...." > /sj/index.html
nginx -t && systemctl restart nginx

# Windows hosts：10.0.0.5 sj.oldboy.com  → 浏览器访问测试
```

### 2. 按手机型号分流（iPhone / Android）
```nginx
# lb-5：/etc/nginx/conf.d/sj_proxy.conf
upstream iphone  { server 172.16.1.7:80; }
upstream android { server 172.16.1.8:80; }

server {
  listen 80;
  server_name sj.oldboy.com;
  location / {
    include proxy_params;
    if ($http_user_agent ~* "iphone")  { proxy_pass http://iphone; }
    if ($http_user_agent ~* "android") { proxy_pass http://android; }
  }
}
```
> 浏览器 F12 切换设备模拟（iOS / Android）即可看到不同页面。

### 3. 按浏览器分流（Firefox / Chrome / iPhone / Android / 默认）
```nginx
upstream firefox { server 172.16.1.7:80; }
upstream chrome  { server 172.16.1.8:80; }
upstream iphone  { server 172.16.1.7:80; }
upstream android { server 172.16.1.8:80; }
upstream default { server 172.16.1.7:80; }

server {
  listen 80;
  server_name sj.oldboy.com;
  location / {
    include proxy_params;
    if ($http_user_agent ~* "Firefox") { proxy_pass http://firefox; }
    if ($http_user_agent ~* "Chrome")  { proxy_pass http://chrome;  }
    if ($http_user_agent ~* "iphone")  { proxy_pass http://iphone;  }
    if ($http_user_agent ~* "android") { proxy_pass http://android; }
    proxy_pass http://default;     # 其他浏览器走默认
  }
}
```

---

## 二、按访问目录分流（基于 `location`）

```nginx
upstream static_pools { server 172.16.1.7:80; }   # 静态
upstream upload       { server 172.16.1.8:80; }   # 上传

server {
  listen 80;
  server_name sj.oldboy.com;
  location /       { include proxy_params; proxy_pass http://upload; }
  location /static/ { include proxy_params; proxy_pass http://static_pools; }
  location /upload/ { include proxy_params; proxy_pass http://upload; }
}
```
```bash
# 后端准备对应页面
echo "我是static页面"  > /sj/static/index.html     # web01
echo "我是upload页面"   > /sj/upload/index.html     # web02
# Windows hosts：10.0.0.5 sj.oldboy.com
# 访问 http://sj.oldboy.com/static/  和  /upload/  看不同结果
```

**方案 2（用 if 实现，注意：原文作者实测会报语法错误，不推荐）**
```nginx
if ($request_uri ~* "^/static/(.*)$") { proxy_pass http://static_pools/$1; }
if ($request_uri ~* "^/upload/(.*)$") { proxy_pass http://upload_pools/$1; }
location / { proxy_pass http://default_pools; include proxy.conf; }
```
> ⚠️ `if` 在 `location` 中与 `proxy_pass` 混用容易踩坑，生产优先用 `location` 前缀匹配。

---

## 三、Nginx 双机热备（Keepalived）

### 1. 高可用概述
高可用双机热备：两台机器跑相同业务，一台宕机时另一台**快速接管**，用户无感知，保证业务 7×24 不中断。

### 2. 环境准备
| 系统 | 角色 | 外网 IP | 内网 IP |
| --- | --- | --- | --- |
| CentOS 7.5 | keepalived-master | eth0:10.0.0.5 | eth1:172.16.1.5 |
| CentOS 7.5 | keepalived-slave | eth0:10.0.0.6 | eth1:172.16.1.6 |

### 3. 安装
```bash
yum install keepalived -y       # lb01、lb02 都装
rpm -qc keepalived             # 配置在 /etc/keepalived/keepalived.conf
```

### 4. 配置 lb01（MASTER）
```bash
cat > /etc/keepalived/keepalived.conf <<EOF
global_defs {
  router_id lb01
}
vrrp_instance VI_1 {
  state MASTER
  interface eth0
  virtual_router_id 50
  priority 150
  advert_int 1
  authentication {
    auth_type PASS
    auth_pass 1111
  }
  virtual_ipaddress {
    10.0.0.3
  }
}
EOF
systemctl restart keepalived
```

### 5. 配置 lb02（BACKUP）
```bash
cat > /etc/keepalived/keepalived.conf <<EOF
global_defs {
  router_id lb02
}
vrrp_instance VI_1 {
  state BACKUP
  interface eth0
  virtual_router_id 50
  priority 100
  advert_int 1
  authentication {
    auth_type PASS
    auth_pass 1111
  }
  virtual_ipaddress {
    10.0.0.3
  }
}
EOF
systemctl restart keepalived
```

### 6. Master / Backup 配置区别
| 配置项 | Master | Backup |
| --- | --- | --- |
| router_id（唯一标识） | lb01 | lb02 |
| state（角色） | MASTER | BACKUP |
| priority（竞选优先级，大者优先） | 150 | 100 |

### 7. 启动并验证 VIP 漂移
```bash
# lb01、lb02 都启动
systemctl enable keepalived && systemctl start keepalived

# lb01 上应有 VIP
ip addr | grep 10.0.0.3

# 停掉 lb01 的 keepalived，VIP 漂移到 lb02
systemctl stop keepalived
ip addr | grep 10.0.0.3     # lb01 上已无

# lb02 上查看：VIP 已接管
ip addr | grep 10.0.0.3

# lb01 重启 keepalived，优先级高会重新接管
systemctl start keepalived
ip addr | grep 10.0.0.3     # 回到 lb01
```

---

## 四、Keepalived 脑裂（Split-Brain）

**脑裂**：因网络故障（网线松动、防火墙拦截、硬件崩溃等）导致两台 Keepalived 在指定时间内收不到对方心跳，各自抢占资源并持有 VIP，两台都「以为自己是主」。

### 1. 备节点脑裂检测脚本
```bash
mkdir /server/scripts
cat > /server/scripts/check_split_brain.sh <<'EOF'
#!/bin/sh
lb01_vip=10.0.0.3
lb01_ip=10.0.0.5
while true; do
  ping -c 2 -W 3 $lb01_ip &>/dev/null
  if [ $? -eq 0 -a $(ip add | grep "$lb01_vip" | wc -l) -eq 1 ]; then
    echo "ha is split brain.warning."
  else
    echo "ha is ok"
  fi
  sleep 5
done
EOF
chmod +x /server/scripts/check_split_brain.sh

# 用 screen 后台运行
yum install screen -y
screen
sh /server/scripts/check_split_brain.sh
# Ctrl+a 再按 d 脱离（Detached）
ps aux | grep check_split_brain
screen -list            # 查看会话（如 2542.pts-0.lb02）
screen -r 2542         # 重新进入会话
```

### 2. Nginx 宕机自动切换脚本（主备都要）
Nginx 挂了用户请求会失败，但 Keepalived 不会自动切换，需脚本检测：Nginx 不死就拉起，拉不起来就停 Keepalived 让 VIP 漂移。
```bash
mkdir -p /server/scripts
cat > /server/scripts/check_web.sh <<'EOF'
#!/bin/sh
while true; do
  nginxpid=$(ps -C nginx --no-header | wc -l)
  if [ $nginxpid -eq 0 ]; then
    systemctl start nginx
    sleep 5
    nginxpid=$(ps -C nginx --no-header | wc -l)
    if [ $nginxpid -eq 0 ]; then
      systemctl stop keepalived
      exit 1
    fi
  fi
  sleep 5
done
EOF
chmod +x /server/scripts/check_web.sh

# 在 keepalived.conf 中调用（lb01/lb02 都要加）
cat > /etc/keepalived/keepalived.conf <<EOF
global_defs {
  router_id Lb01
}
vrrp_script check_web {
  script "/server/scripts/check_web.sh"
  interval 2
  weight 50
}
vrrp_instance VI_1 {
  state MASTER
  interface ens33
  virtual_router_id 50
  priority 150
  advert_int 1
  authentication {
    auth_type PASS
    auth_pass 1111
  }
  virtual_ipaddress {
    10.0.0.3
  }
  track_script {
    check_web
  }
}
EOF
systemctl restart keepalived.service
# lb02 配置类似（router_id lb02、state BACKUP、priority 100、interface eth0）
```

---

## 五、快速克隆一台 lb02
```bash
scp -rp root@172.16.1.5:/etc/yum.repos.d /etc/
yum install nginx -y
scp -rp root@172.16.1.5:/etc/nginx /etc/
systemctl start nginx && systemctl enable nginx
```

---

## 六、常见面试题

1. **如何用 Nginx 根据手机/浏览器返回不同页面？**
   用 `if ($http_user_agent ~* "iphone") { proxy_pass ... }` 按 UA 分流；生产更推荐用 `map` 指令替代 `if`。

2. **Keepalived 高可用怎么实现？**
   两台 LB 配 VRRP 实例，MASTER 持有 VIP（priority 高），心跳丢失后 BACKUP 接管 VIP，实现地址漂移。

3. **Master 和 Backup 配置主要区别？**
   `router_id` 唯一、`state` 角色（MASTER/BACKUP）、`priority` 优先级（大者为主）。

4. **什么是脑裂？常见原因？**
   两台 Keepalived 收不到对方心跳却都持有 VIP。原因：网线松动、防火墙拦截 VRRP、硬件故障、Nginx 死掉等。

5. **Nginx 挂了为什么 Keepalived 不切换？怎么解决？**
   Keepalived 只管 VIP，不管应用。需 `vrrp_script` + `track_script` 检测 Nginx 存活，不健康就停 Keepalived 触发漂移。

6. **`if` 在 Nginx location 里和 proxy_pass 混用有什么坑？**
   容易触发「if is evil」语义陷阱导致配置异常，优先用 `location` 前缀匹配或 `map`。

---

> 词汇：Detached 独立的 / Attached 附属的 / Sockets 套接字
> 更新：2026-05-05 20:44:34
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/hp7gvv>
