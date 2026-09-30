# nginx负载均衡之手机电脑应用案例

## nginx负载均衡之 手机电脑应用案例

proxy 10.0.0.5\
web01 10.0.0.7 # 模拟iphone页面\
web02 10.0.0.8 # 模拟 anroid 页面

### 根据不同的浏览器, 以及不同的手机, 访问的效果都将不一样。

```bash
# web01的配置网站
cat > /etc/nginx/conf.d/sj.conf<<EOF
server {
  listen 80;
  server_name sj.oldboy.com;
  location / {
    root /sj;
    index index.html;
    }
}
EOF
mkdir /sj
echo "Ipone....." >/sj/index.html
nginx -t
systemctl restart nginx

#windows hosts解析
ip sj.oldboy.com
#浏览器访问http://sj.oldboy.com/
---------------------------------------------
# web02 配置conf 一样
mkdir /sj
echo "Android...." >/sj/index.html
nginx -t
systemctl restart nginx

#windows hosts解析
ip sj.oldboy.com
#浏览器访问http://sj.oldboy.com/
---------------------------------------------
# proxy lb-5 负载均衡配置
# cat /etc/nginx/conf.d/sj_proxy.conf
upstream iphone {
  server 172.16.1.7:80;
}
upstream android {
  server 172.16.1.8:80;
}
//server根据判断来访问不同的页面
server {
  listen 80;
  server_name sj.oldboy.com;
  location / {
    include proxy_params;
    //iphone 手机访问效果
    if ($http_user_agent ~* "iphone"){
      proxy_pass http://iphone;
      }
    //android 手机访问效果
    if ($http_user_agent ~* "android"){
      proxy_pass http://android;
      }
    }
}

nginx -t
systemctl restart nginx
#windows hosts解析
ip sj.oldboy.com;
#浏览器访问http://sj.oldboy.com/   F12选安卓和ios设备访问看看


```

### 根据不同的浏览器跳转到不同的页面

```bash
//通过浏览器来分别连接不同的浏览器访问不同的效果。
# cat /etc/nginx/conf.d/sj_proxy.conf
upstream firefox {
  server 172.16.1.7:80;
}
upstream chrome {
  server 172.16.1.8:80;
}
upstream iphone {
  server 172.16.1.7:80;
}
upstream android {
  server 172.16.1.8:80;
}
upstream default {
  server 172.16.1.7:80;
}
#server根据判断来访问不同的页面
server {
  listen 80;
  server_name  sj.oldboy.com;
  location / {
    include proxy_params;
    #firefox浏览器访问效果
    if ($http_user_agent ~* "Firefox"){
      proxy_pass http://firefox;
      }
    #chrome浏览器访问效果
    if ($http_user_agent ~* "Chrome"){
      proxy_pass http://chrome;
      }
    #iphone手机访问效果
    if ($http_user_agent ~* "iphone"){
      proxy_pass http://iphone;
      }
    #android手机访问效果
    if ($http_user_agent ~* "android"){
      proxy_pass http://android;
      }
    # 其他浏览器访问默认规则
    proxy_pass http://default;
  }
}
```

### 根据访问不同目录, 代理不同的服务器

```bash
//默认动态，静态直接找设置的static，上传找upload
# lb主机
# cat /etc/nginx/conf.d/sj_proxy.conf
upstream static_pools {
  server 172.16.1.7:80;
}
upstream upload {
  server 172.16.1.8:80;
}
server {
  listen 80;
  server_name sj.oldboy.com;
  location / {
    include proxy_params;
    proxy_pass http://upload;
    }
  location /static/ {
    include proxy_params;
    proxy_pass http://static_pools;
    }
  location /upload/ {
    include proxy_params;
    proxy_pass http://upload;
    }
}
#创建对应的目录文件
#web01主机
echo "我是static页面" >/sj/static/index.html
#web02 主机
echo "我是upload页面" >/sj/upload/index.html

# windows hosts 添加域名解析
10.0.0.5 sj.oldboy.com
#浏览器访问
http://sj.oldboy.com/upload/
http://sj.oldboy.com/static/

# 方案2：以if语句实现。 // 报错语法错误
if ($request_uri ~* "^/static/(.*)$") {
  proxy_pass http://static_pools/$1;
  }
if ($request_uri ~* "^/upload/(.*)$") {
  proxy_pass http://upload_pools/$1;
  }
location / {
  proxy_pass http://default_pools;
  include proxy.conf;
  }
  
```

## Nginx双机热备

### 1.Keepalived高可用概述

*1.什么是高可用*

什么是高可用双击热备, 一般指2台机器启动着相同的业务系统,当有一台机器down机了, 另外一台 服务器能快速的接管, 对于访问的用户是无感知的。

*2.高可用使用场景*

那么高可用使用在什么场景，业务系统需要保证7x24小时不DOWN机, 作为业务来说随时都可用, 让你的业务系统更顽强。

### Keepalived高可用安装

*1.环境准备*

| 服务器系统 | 角色 | 外网IP | 内网IP |
| --- | --- | --- | --- |
| CentOS 7.5 | keepalived-master | eth0:10.0.0.5 | eth1:172.16.1.5 |
| CentOS 7.5 | keepalived-slave | eth0:10.0.0.6 | eth1:172.16.1.6 |

*2.在lb01与lb02上分别安装keepalived*

```bash
yum install keepalived -y
yum install keepalived -y
```

*3.配置lb01 , keepalived-master*

```bash
# rpm -qc keepalived
/etc/keepalived/keepalived.conf
/etc/sysconfig/keepalived

# lb01
cat > /etc/keepalived/keepalived.conf<<EOF
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
systemctl restart keepalived.service

#lb02  配置
cat > /etc/keepalived/keepalived.conf<<EOF
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

# 检查 是不是有 10.0.0.3 ip地址
# ip a

# 停止lb01停止keeplived ;lb02机器就有10.0.0.3ip地址 实现了地址漂移

```

*5.对比keepalived的master与backup配置的区别*

| Keepalived配置区别 | Master配置 | Backup节配置 |
| --- | --- | --- |
| route_id(唯一标识) | route_id lb01 | route_id lb02 |
| state(角色状态) | state Master | state Backup |
| priority(竞选优先级) | priority 150(数大的优先) | priority 100 |

*6.启动lb01与lb02的keepalived*

```bash
#lb01
systemctl enable keepalived
systemctl start keepalived
#lb02
systemctl enable keepalived
systemctl start keepalived
```

*7.检查keepalived的虚拟IP地址是否漂移*

在`lb01`上进行如下操作

```bash
# lb01存在vip地址
ip addr |grep 10.0.0.3

# 停止lb01上的keepalived, 检测vip已不存在
systemctl stop keepalived
ip addr |grep 10.0.0.3
```

*在lb02上进行如下操作*

```bash
ip addr|grep 10.0.0.3
```

*lb01重新启动keepalived,发现地址被重新接管*

```bash
systemctl start keepalived
ip addr |grep 10.0.0.3

```

### Keepalived高可用配置

### 快速配置一台 lb02

```bash
scp -rp root@172.16.1.5:/etc/yum.repos.d /etc/
yum install nginx -y
scp -rp root@172.16.1.5:/etc/nginx /etc/
ystemctl start nginx
systemctl enable nginx
```

### keepalived高可用<font style="color:rgb(20, 21, 26);">脑裂</font>

由于某些原因，导致两台`keepalived`高可用服务器在指定时间内，无法检测到对方的心跳消息，各自取得资源及服务的所有权，而此时的两台高可用服务器又都还活着。

> 服务器网线松动等网络故障 服务器硬件故障发生损坏现象而崩溃 主备都开启`firewalld`防火墙 Nginx服务死掉等

*1.在备上编写检测脚本, 测试如果能ping通主并且备节点还有VIP(虚拟ip地址)的话则认为产生了列脑*

```bash
# lb02 在备上运行
mkdir /server/scripts
# vim /server/scripts/check_split_brain.sh
#!/bin/sh
lb01_vip=10.0.0.3
lb01_ip=10.0.0.5
while true;do
  # -w 3 间隔时间3秒  -c 次数
  ping -c 2 -W 3 $lb01_ip &>/dev/null
  #ping通主并且备节点还有VIP的话
  if [ $? -eq 0 -a `ip add|grep "$lb01_vip"|wc -l` -eq 1 ];then
    echo "ha is split brain.warning."
  else
    echo "ha is ok"
  fi
  sleep 5
done

yum install screen -y # 安装
screen   #进入另一个shell终端
sh /server/scripts/check_split_brain.sh
ctrl+ a  +d 退出当前shell
#后台查询 是在后台运行的
ps aux|grep check_split_brain

# 其实是在另外一个shell 里面
[root@lb02 ~]# screen -list
There is a screen on:
2542.pts-0.lb02    (Detached)
1 Socket in /var/run/screen/S-root.
# 进入/var/run/screen/S-root 里面可以删除对应的会话
screen -r  pid(2542)   # 进入之前的shell终端
```

*2.如果Nginx宕机, 会导致用户请求失败, 但Keepalived并不会进行切换, 所以需要编写一个脚本检测Nginx的存活状态, 如果不存活则kill nginx和keepalived*

```bash
# lb01 lb02主备上都运行 使用screen 在后台运行
mkdir -p /server/scripts

# vim /server/scripts/check_web.sh
#!/bin/sh
#使用while死循环
while true;do
  # no-header 不显示头部 第一行
  nginxpid=$(ps -C nginx --no-header|wc -l)
  #1.判断Nginx是否存活,如果不存活则尝试启动Nginx
  if [ $nginxpid -eq 0 ];then
    systemctl start nginx
    sleep 5
    #2.5秒后再次获取一次Nginx状态
    nginxpid=$(ps -C nginx --no-header|wc -l)
    #3.再次进行判断, 如Nginx还不存活则停止Keepalived,让地址进行漂移,并退出脚本  
    if [ $nginxpid -eq 0 ];then
      systemctl stop keepalived
    exit 1
    fi
  fi
  sleep 5
done

chmod +x /server/scripts/check_web.sh

在keepalived配置文件中调用此脚本，lb01与lb02都需操作
# cat /etc/keepalived/keepalived.conf
global_defs {
  router_id Lb01
}
vrrp_script check_web {
  script "/server/scripts/check_web.sh"
  # 每格2秒执行一次脚本
  interval 2
  # 权重
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
    # 10.0.0.3/24 dev ens33
    10.0.0.3
  }
  #调用上面定义的 check_web
  track_script {
    check_web
  }
}

systemctl restart keepalived.service

------------------------------------------------------------------
# cat /etc/keepalived/keepalived.conf
global_defs {
  router_id lb02
}
vrrp_script check_web {
  script "/server/scripts/check_web.sh"
  # 每格2秒执行一次脚本
  interval 2
  # 权重
  weight 50
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
    10.0.0.100
    }
  #调用上面定义的 check_web
  track_script {
    check_web
  }
}


systemctl restart keepalived.service

```

\_\_

翻译

Detached 独立的

Attached 附属的

Sockets 插座

![1547290160521-6b9f9a44-751e-4470-af05-703df0d0cb02.png](img/nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E4%B9%8B%E6%89%8B%E6%9C%BA%E7%94%B5%E8%84%91%E5%BA%94%E7%94%A8%E6%A1%88%E4%BE%8B-01.png)

![1547290218647-b1ecf54a-0af9-46e7-b02c-b640a44f05ea.png](img/nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E4%B9%8B%E6%89%8B%E6%9C%BA%E7%94%B5%E8%84%91%E5%BA%94%E7%94%A8%E6%A1%88%E4%BE%8B-02.png)


> 更新: 2026-05-05 20:44:34  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/hp7gvv>