# 第六章·Nginx四层负载均衡

## Nginx四层负载均衡概述
| 什么是四层负载均衡 |
| --- |

四层负载均衡是基于传输层协议包来封装的（如：TCP/IP），那我们前面使用到的七层是指的应用层，他的组装在四层的基础之上，无论四层还是七层都是指的OSI网络模型。

---

| 四层负载均衡应用场景 |
| --- |

1、四层+七层来做负载均衡，四层可以保证七层的负载均衡的高可用性；如：nginx就无法保证自己的服务高可用，需要依赖LVS或者keepalive。

2、如：tcp协议的负载均衡，有些请求是TCP协议的（mysql、ssh），或者说这些请求只需要使用四层进行端口的转发就可以了，所以使用四层负载均衡。

---

| 四层+七层构建大规模集群架构使用场景 |
| --- |

<!-- OCR_START -->
- 四层负载发送过来的数据
- DNS解析
- web集群
- 数据库集群
- 继续进行拆包
- 去DNS服务器解析域名
- Host：域名匹配
- URL规则控制、安全限制..等
- web服务器
- 存储或读取数据
- 分配业务
- Mysql
- （员工1）
- （主后援1）
- 七层负载均衡
- 到web端
- 解析后返回访问地址
- （主经理A）
- 四层负载均衡
- （主总监）
- （员工2）
- （备后援2）
- 通过浏览器去访问四层负载均衡
- （主经理B）
- 数据库主从、读写分离、MHA
- 主从
- keepalive
- （员工3）
- （主经理C）
- Redis集群
- （主副总监）
- （员工4）
- Redis
- src:10.0.0.1 port:80
- （主后援3）
- 只拿到访问的ip和端口就传递给后
- （主经理D）
- （员工5）
- 面七层负裁均衡不在进行拆包
- 静态页面可以直接访问CDN
- （备后援4）
- （员工6）
- Redis主从、明兵模式cluster
- CDN
- （员工7）
- 处理七层负载传递过来的数据
- 存储共享文件
- NFS
- （主后援5）
- 曾老湿
- 静态教据可以同步到CDN
- Driver
- Zeng
<!-- OCR_END -->

| 四层负载均衡总结 |
| --- |

1、四层负载均衡仅能转发TCP/IP协议、UDP协议、通常用来转发端口，如：tcp/22、udp/53；

2、四层负载均衡可以用来解决七层负载均衡端口限制问题；（七层负载均衡最大使用65535个端口号）

3、四层负载均衡可以解决七层负载均衡高可用问题；（多台后端七层负载均衡能同事的使用）

4、四层的转发效率比七层的高得多，但仅支持tcp/ip协议，不支持http和https协议；

5、通常大并发场景通常会选择使用在七层负载前面增加四层负载均衡。

---

| Nginx四层负载均衡场景实践 |
| --- |

**Nginx如何配置四层负载均衡**

1、通过访问负载均衡的5555端口，实际是后端的web01的22端口在提供服务；

2、通过访问负载均衡的6666端口，实际是后端的mysql的3306端口在提供服务。

**先配置两台lb负载均衡**

```bash
[root@lb02 ~]# cat /etc/yum.repos.d/nginx.repo 
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
#在lb02上安装nginx
[root@lb02 yum.repos.d]# yum install -y nginx
#在lb02上同步lb01的所有nginx相关配置
[root@lb02 ~]# scp -r root@172.16.1.5:/etc/nginx /etc/
#启动nginx
[root@lb02 conf.d]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@lb02 conf.d]# systemctl enable nginx
Created symlink from /etc/systemd/system/multi-user.target.wants/nginx.service to /usr/lib/systemd/system/nginx.service.
[root@lb02 conf.d]# nginx
```

1.创建存放四层负载均衡配置文件的目录

```bash
[root@lb02 ~]# vim /etc/nginx/nginx.conf
events {
        ....
}
include /etc/nginx/conf.c/*.conf;
http {
        .....
}
[root@lb02 ~]# mkdir /etc/nginx/conf.c
```

2.配置四层负载均衡

```bash
[root@web03 conf.c]# cat lb_domain.conf 
stream {
    upstream lb {
            server 172.16.1.5:80 weight=5 max_fails=3 fail_timeout=30s;
            server 172.16.1.6:80 weight=5 max_fails=3 fail_timeout=30s;
    }
    server {
            listen 80;
            proxy_connect_timeout 3s;
            proxy_timeout 3s;
            proxy_pass lb;
    }
}
[root@web03 conf.c]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@web03 conf.c]# nginx -s reload
#配置本机hosts解析后浏览器访问并查看nginx日志
```

3.四层负载均衡开启日志

```bash
#四层负载均衡是没有access的日志的，因为在nginx.conf的配置中，access的日志格式是配置在http下的，而四层复杂均衡配置实在http以外的；
#如果需要日志则需要配置在stream下面
[root@web03 conf.c]# cat lb_domain.conf 
stream {
    log_format  proxy '$remote_addr $remote_port - [$time_local] $status $protocol '
                  '"$upstream_addr" "$upstream_bytes_sent" "$upstream_connect_time"' ;
    access_log /var/log/nginx/proxy.log proxy;
    upstream lb {
            server 172.16.1.5:80 weight=5 max_fails=3 fail_timeout=30s;
            server 172.16.1.6:80 weight=5 max_fails=3 fail_timeout=30s;
    }
    server {
            listen 80;
            proxy_connect_timeout 3s;
            proxy_timeout 3s;
            proxy_pass lb;
    }
}
```

---

| Nginx四层负载均衡端口转发 |
| --- |

1.使用nginx四层负载均衡实现tcp的转发

```bash
请求负载均衡 5555    --->     172.16.1.7:22;
请求负载均衡 6666    --->     172.16.1.51:3306;
```

2.配置nginx四层负载均衡实现tcp的转发

```bash
[root@lb4-01 ~]# cat /etc/nginx/conf.c/lb_domain.conf 
stream {
    log_format  proxy '$remote_addr $remote_port - [$time_local] $status $protocol '
                      '"$upstream_addr" "$upstream_bytes_sent" "$upstream_connect_time"' ;
    access_log /var/log/nginx/proxy.log proxy;
#定义转发ssh的22端口
    upstream ssh_7 {
            server 10.0.0.7:22;
    }
#定义转发mysql的3306端口
    upstream mysql_51 {
            server 10.0.0.51:3306;
    }
    server {
            listen 5555;
            proxy_connect_timeout 3s;
            proxy_timeout 300s;
            proxy_pass ssh_7;
    }
    server {
            listen 6666;
            proxy_connect_timeout 3s;
            proxy_timeout 3s;
            proxy_pass mysql_51;
    }
}
```

> 更新: 2024-09-22 20:25:35  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ov13zx>