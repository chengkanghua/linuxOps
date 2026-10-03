# 06 Saltstack项目实践

# 06 Saltstack项目实践
+ [项目分解与环境规划](http://class.xuliangwei.com/15128075859751.html#toc_0)
+ [系统初始化配置](http://class.xuliangwei.com/15128075859751.html#toc_1)
+ [基础模块配置管理](http://class.xuliangwei.com/15128075859751.html#toc_2)
+ [业务模块配置管理](http://class.xuliangwei.com/15128075859751.html#toc_3)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208
>

[Saltstack架构代码下载地址](http://fj.xuliangwei.com/saltstack/salt.tar.gz)

## 项目分解与环境规划
1.环境配置

```plain
# 开发、测试、预生产、生产
[root@salt0-master ~]# vim /etc/salt/master 
file_roots:
  base:
    - /srv/salt/base  #base基础环境
  prod:
    - /srv/salt/prod  #prod生产环境
pillar_roots:
  base:
    - /srv/pillar/base
  prod:
    - /srv/pillar/prod
[root@salt0-master ~]# systemctl restart salt-master
```

## 系统初始化配置
> DNS配置
>
> history记录时间
>
> 内核参数优化
>
> limits配置
>
> yum仓库配置
>
> sshd服务调整
>
> 防火墙设定
>
> 基础软件包
>
> ntp客户端
>
> 应用用户
>

```plain
[root@salt0-master srv]# tree /srv/salt/base/
/srv/salt/base/
├── init
│   ├── dns.sls
│   ├── env_init.sls
│   ├── files
│   │   ├── authorized_keys.template
│   │   ├── limits.conf.template
│   │   ├── resolv.conf.template
│   │   ├── selinux_config.template
│   │   ├── sshd_config.template
│   │   ├── yum.repos.d.template
│   │   │   ├── base.repo
│   │   │   ├── epel.repo
│   │   │   ├── nginx.repo
│   │   │   ├── salt-latest.repo
│   │   │   └── zabbix.repo
│   │   └── zabbix_agentd.conf.template
│   ├── firewalld.sls
│   ├── history.sls
│   ├── limit.sls
│   ├── ntp.sls
│   ├── pkg.sls
│   ├── repo.sls
│   ├── sshd.sls
│   ├── ssh-key.sls
│   ├── sysctl.sls
│   ├── user.sls
│   └── zabbix_agent.sls
└── top.sls
```

## 基础模块配置管理
```plain
[root@salt0-master srv]# tree /srv/salt/prod/modules/
/srv/salt/prod/modules/
├── keepalived
│   ├── files
│   └── install.sls
├── mysql
│   ├── files
│   │   └── my.cnf.template
│   ├── install.sls
│   └── service.sls
├── nginx
│   ├── files
│   │   └── nginx.conf.template
│   ├── install.sls
│   └── service.sls
└── php
    ├── files
    │   ├── php-fpm.conf.template
    │   ├── php-fpm.d.template
    │   │   └── www.conf
    │   └── php.ini.template
    ├── install.sls
    └── service.sls
```

## 业务模块配置管理
根据业务类型划分，使用cluster业务引入，包含基础模块的配置

```plain
[root@salt0-master srv]# tree /srv/salt/prod/cluster/
/srv/salt/prod/cluster/
├── proxy
│   ├── files
│   │   ├── keepalived.conf.template
│   │   └── proxy.conf.template
│   ├── keepalived-outside.sls
│   └── server.sls
└── webnode
    ├── code.sls
    ├── files
    │   ├── config.d.template
    │   │   └── bbs.conf
    │   └── index.php
    └── vhost.sls
```

haproxy

```plain
haproxy
[root@saltstack01 ~]# cat /srv/salt/prod/haproxy/files/haproxy.cfg 
global
    log 127.0.0.1 local2 
    chroot /var/lib/haproxy 
    pidfile /var/run/haproxy.pid 
    maxconn 4000 
    user haproxy 
    group haproxy 
    daemon 
    stats socket /var/lib/haproxy/stats
defaults
    mode http 
    log global 
    option httplog 
    option dontlognull 
    option http-server-close 
    option forwardfor except 127.0.0.0/8 
    option redispatch retries 3 
    timeout http-request 10s 
    timeout queue 1m 
    timeout connect 10s 
    timeout client 1m
    timeout server 1m 
    timeout http-keep-alive 10s 
    timeout check 10s 
    maxconn 3000
listen stats
    bind *:8925
    stats enable
    stats hide-version
    stats uri /stats
    stats realm HaproxyStats
    stats auth bgx:123
    stats admin if TRUE
frontend web
mode http
bind *:80
default_backend httpservers
backend httpservers 
    balance roundrobin 
    server http1 192.168.56.11:80 maxconn 2000 weight 1 check inter 1s rise 2 fall 2
    server http2 192.168.56.12:80 maxconn 2000 weight 1 check inter 1s rise 2 fall 2
```

keepalived

```plain
[root@saltstack01 ~]# cat /srv/salt/prod/keepalived/files/keepalived.conf 
! Configuration File for keepalived
global_defs { 
    router_id {{ ROUTER_ID }} 
}
vrrp_instance VI_1 { 
    state {{ STATE }}
    interface eth0
    virtual_router_id 51 
    priority {{ PRIORITY }} 
    advert_int 1 authentication {
        auth_type PASS
        auth_pass 1111 
    } 
    virtual_ipaddress {
        192.168.56.11
    }
}
keepalived-install:
  pkg.installed:
    - name: keepalived 
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://keepalived/files/keepalived.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: keepalived-service
    - template: jinja 
    {% if grains['fqdn'] == 'saltstack01.com' %}
    - ROUTER_ID: saltstack01
    - STATE: MASTER
    - PRIORITY: 100 
    {% elif grains['fqdn'] == 'saltstack02.com' %}
    - ROUTER_ID: saltstack02
    - STATE: BACKUP
    - PRIORITY: 50 
    {% endif %} 
keepalived-service:
  service.running:
    - name: keepalived
    - enable: True
    - reload: True
    - require:
      - pkg: keepalived-service
      - file: keepalived-service
    - watch:
    - file: keepalived-service
```

> 更新: 2019-03-21 09:18:17  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/zczrcy>