# Nginx 负载均衡

反向代理【跳转不行？】\
携带头信息\[Host 客户端真实IP]\
连接、响应、返回、buff\
前端监听80端口 -> 后端的8080 ![1547291085902-4f522fae-82bc-414b-a99d-d622a0244bc5.png](img/Nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1-01.png)

1.是否必须统一前端的代理端口和后端的web服务器端口【不需要】\
2.前端使用80端口，后端使用8080，8081,8082，就不在需要域名【可以|不是很建议】\
3.最常见，最建议的方式\
前端配置好blog.oldboy.com 域名，配置好监听的80端口，配置好proxy_pass\
后端配置好blog.oldboy.com 域名，配置好监听的80端口

## Nginx负载均衡

*Web服务器，直接面向用户，往往要承载大量并发请求，单台服务器难以负荷，我使用多台WEB服务器组成集群，前端使用Nginx负载均衡，将请求分散的打到我们的后端服务器集群中，实现负载的分发。那么会大大提升系统的吞吐率、请求性能、高容灾*

![1547291247990-f201f0d1-b8a6-4d1f-b8cc-6b611129b989.png](img/Nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1-02.png)

*Nginx是一个典型的SLB(Server Load Balance)网络负载均衡器*

![1547291258567-d35c05a4-d902-42a1-b670-9c7b426a30f1.png](img/Nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1-03.png)

负载均衡具有反向代理的功能 反向代理 -> 仅能代理一台服务器 负载均衡 -> 可以代理(多台,集群) proxy_pass http协议 fastcgi_pass fastcgi协议

负载均衡的名词

 *调度\
\_\_ 前端\
\_\_ SLB Server Load Balance\
\_\_ LB Load Balance\
\_\_ SLB 阿里云\
\_\_ CLB 腾讯云\
\_\_ ULB Ucloud*

### 2.1Nginx负载均衡按层划分 \[OSI]

*负载均衡按层划分应用场景: \_\_**四层负载均衡***\*\* tcp/udp协议 只能转发 端口\*\*

![1547291269543-1b2f4a6b-5796-4505-be93-a9828bd6bf07.png](img/Nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1-04.png)

\_负载均衡按层划分应用场景: \_***七层负载均衡,http协议 Nginx最常用***

![1547291285510-bcb2329e-62cf-4573-b443-b65430fd6420.png](img/Nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1-05.png)

### 2.1Nginx负载均衡配置场景

`Nginx`实现负载均衡需要用到`proxy_pass`代理模块配置.\
`Nginx`负载均衡是将客户端请求代理转发至一组`upstream`虚拟服务池

![1547291307948-c8139437-a05e-43ba-9986-b74022789062.png](img/Nginx%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1-06.png)

环境配置

| 角色 | 外网ip(NAT) | 内网(LAN) | 主机名 |
| --- | --- | --- | --- |
| LB01 | eth0:10.0.0.5 | eth0:10.0.0.5 | lb01 |
| web01 | eth0:10.0.0.7 | eth0:10.0.0.7 | web01 |
| web02 | eth0:10.0.0.8 | eth0:10.0.0.8 | web02 |

`Nginx upstream`虚拟配置语法

```nginx
Syntax: upstream name { ... }
Default: -
Context: http
//upstream例子
upstream backend {
  server backend1.example.com       weight=5;
  server backend2.example.com:8080;
  server unix:/tmp/backend3;
  server backup1.example.com:8080   backup;
}
server {
  location / {
    proxy_pass http://backend;
  }
}
```

web01 配置

```nginx
# cat /etc/nginx/conf.d/node.conf
server {
  listen 80;
  server_name node.oldboy.com;
  location / {
    root /node;
    index index.html;
  }
}
mkdir /node
echo 'web01.....' > /node/index.html
nginx -t
systemctl restart nginx
```

web02 配置

```nginx
# cat /etc/nginx/conf.d/node.conf
server {
  listen 80;
  server_name node.oldboy.com;
  location / {
    root /node;
    index index.html;
  }
}
mkdir /node
echo 'web02.....' > /node/index.html
nginx -t
systemctl reload nginx
```

lb01 配置

```nginx
# cat /etc/nginx/conf.d/node_proxy.conf
upstream  node {
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

windows 访问测试

```plain
C:\Windows\System32\drivers\etc\hosts
10.0.0.5          node.oldboy.com

浏览器访问 http://node.oldboy.com/

```

### 2.2Nginx负载均衡后端状态

*后端Web服务器在前端Nginx负载均衡调度中的状态*

| 状态 | 概述 |
| --- | --- |
| down | 当前的server暂时不参与负载均衡 (维护时用 和注释效果差不多) |
| backup | 预留的备份服务器 (机器配置不均衡使用) |
| max_fails | 允许请求失败的次数 |
| fail_timeout | 经过max_fails失败后, 服务暂停时间 |
| max_conns | 限制最大的接收连接数 |

*1.测试down状态, 测试该Server不参与负载均衡的调度*

```nginx
upstream load_pass {
  //不参与任何调度, 相当于注释
    server 10.0.0.7:80 down;
}
```

*2.测试backup以及down状态*

```nginx
upstream load_pass {
  server 10.0.0.7:80;
  server 10.0.0.8:80 backup;
  server 10.0.0.9:80 max_fails=1 fail_timeout=10s;
}
location  / {
  proxy_pass http://load_pass;
  include proxy_params;
}
```

### 2.3Nginx负载均衡调度算法

| 调度算法 | 概述 |
| --- | --- |
| 轮询 | 按时间顺序逐一分配到不同的后端服务器(默认 常用) |
| weight | 加权轮询,weight值越大,分配到的访问几率越高 (配置不均衡使用) |
| ip_hash | 每个请求按访问IP的hash结果分配,这样来自同一IP的固定访问一个后端服务器 |
| url_hash | 按照访问URL的hash结果来分配请求,是每个URL定向到同一个后端服务器 |
| least_conn | 最少链接数,那个机器链接数少就分发 |

*1.Nginx负载均衡\[wrr]轮询具体配置*

```nginx
upstream load_pass {
  server 10.0.0.7:80;
  server 10.0.0.8:80;
}
```

*2.Nginx负载均衡\[weight]权重轮询具体配置*

```nginx
upstream load_pass {
  server 10.0.0.7:80 weight=5;
  server 10.0.0.8:80;
}
```

*3.Nginx负载均衡ip_hash具体配置, 不能和weight一起使用。*

```nginx
//如果客户端都走相同代理, 会导致某一台服务器连接过多
upstream load_pass {
  ip_hash;
  server 10.0.0.7:80 weight=5;
  server 10.0.0.8:80;
}
```

4.Nginx负载均衡url_hash具体配置

```nginx
upstream load_pass {
  hash $request_uri;
  server 192.168.56.11:8001;
  server 192.168.56.11:8002;
  server 192.168.56.11:8003;
}

//针对三台服务器添加相同文件
/soft/code1/url1.html url2.html url3.html
/soft/code2/url1.html url2.html url3.html
/soft/code3/url1.html url2.html url3.html

192.168.56.100/url1.html
ur1.html   》 192.168.56.11:8080 -> url1.html
ur1.html   》 192.168.56.11:8081 -> url1.html
ur1.html   》 192.168.56.11:8082 -> url1.html

```

示例：

```nginx
upstream blog {
  server 172.16.1.7:80 max_fails=2 fail_timeout=10s;
  server 172.16.1.8:80 max_fails=2 fail_timeout=10s;
  server 172.16.1.9:80 backup;
}
```

1.将能正常请求的blog\edu\zh的两台服务器，前端增加一个负载均衡

```bash
# cat /etc/nginx/conf.d/proxy.conf 
upstream php{
  server 172.16.1.7:80;
  server 172.16.1.8:80;
  server 172.16.1.9:80;
}
server {
  listen 80;
  server_name blog.oldboy.com;
  location / {
    proxy_pass http://php;
    include proxy_params;
    }
}
server {
  listen 80;
  server_name edu.oldboy.com;
  location / {
    proxy_pass http://php;
    include proxy_params;
    }
}
server {
  listen 80;
  server_name zh.oldboy.com;
  location / {
    proxy_pass http://php;
    include proxy_params;
    }
}
```

总结

负载均衡具有反向代理的功能\
反向代理 -> 仅能代理一台服务器\
负载均衡 -> 可以代理(多台,集群)\
proxy_pass http协议\
fastcgi_pass fastcgi协议

负载均衡的名词\
调度\
前端\
SLB Server Load Balance\
LB Load Balance\
SLB 阿里云\
CLB 腾讯云\
ULB Ucloud

负载均衡按层划分【OSI】\
负载均衡按层划分应用场景: 四层负载均衡 tcp/udp协议 只能转发 端口\
负载均衡按层划分应用场景: 七层负载均衡, http协议 Nginx最常用

负载均衡后端节点状态\
down 维护使用{#和注释效果差不多}\
backup 当所有服务器都无法使用时，才会启动\
max_fails fail_timeout 多长时间，允许失败多少次

负载均衡调度策略\
1.默认轮询 【常用】\
2.加权轮询 【机器配置不均衡时使用】\
3.ip_hash 【容易导致某一个节点繁忙】\
4.url_hash 【下去测试】\
5.least_conn【哪台服务器连接数少就分发给哪台】


> 更新: 2026-05-05 19:32:54  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/wsqdes>