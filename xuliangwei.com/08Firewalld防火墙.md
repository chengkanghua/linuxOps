# 08 Firewalld防火墙

# 08 Firewalld防火墙

* [1.防火墙基本概述](http://kt.xuliangwei.com/15216870315478.html#toc_0)
* [2.防火墙区域概述](http://kt.xuliangwei.com/15216870315478.html#toc_1)
* [3.防火墙基本指令参数](http://kt.xuliangwei.com/15216870315478.html#toc_2)
* [4.防火墙区域配置策略](http://kt.xuliangwei.com/15216870315478.html#toc_3)
* [5.防火墙服务访问策略](http://kt.xuliangwei.com/15216870315478.html#toc_4)
* [6.防火墙端口访问策略](http://kt.xuliangwei.com/15216870315478.html#toc_5)
* [7.防火墙端口转发策略](http://kt.xuliangwei.com/15216870315478.html#toc_6)
* [8.防火墙富规则策略](http://kt.xuliangwei.com/15216870315478.html#toc_7)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 1.防火墙基本概述

`RHEL/CentOS 7`系统中集成了多款防火墙管理工具，其中`firewalld（Dynamic Firewall Manager of Linux systems`, `Linux`系统的动态防火墙管理器）服务是默认的防火墙配置管理工具，它拥有基于CLI（命令行界面）和基于GUI（图形用户界面）的两种管理方式。

<!-- OCR_START -->
- system-config-firewall
- firewall-config
- firewall-cmd
- iptables (service)
- firewalld (daemon and service)
- iptables (command)
- kernel (netfilter)
- RHEL_453350_0717
<!-- OCR_END -->

相较于传统的`Iptables`防火墙管理工具`firewalld`支持动态更新,并加入了区域`zone`的概念。

简单来说，区域就是`firewalld`预先准备了几套防火墙策略集合（策略模板）,用户可以根据生产场景的不同而选择合适的策略集合，从而实现防火墙策略之间的快速切换。

注意

> 一个zone区域仅能绑定一个网卡, 设定不同的匹配规则
>
> 一个zone区域又可以针对不同的源地址设定不同的规则

<!-- OCR_START -->
- [home]家庭网络允许访问所有外部资源
- [work]公司网络允许访问文件服务
- [kafei]咖啡馆网络允许上网
- Firewall能定义多组区域
- 1.根据不同的环境选择不同的区域
- 2.根据不同的区域配置不同的访问规则
<!-- OCR_END -->

`Firewalld`相关配置文件

> 默认定义的模板配置文件/usr/lib/firewalld
>
> 存储规则配置文件 /etc/firewalld/

## 2.防火墙区域概述

| 区域 | 默认规则策略 |
| :--- | :--- |
| trusted | 允许所有的数据包流入与流出 |
| home | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、mdns、ipp-client、amba-client与dhcpv6-client服务相关，则允许流量 |
| internal | 等同于home区域 |
| work | 拒绝流入的流量，除非与流出的流量数相关；而如果流量与ssh、ipp-client与dhcpv6-client服务相关，则允许流量 |
| public | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh、dhcpv6-client服务相关，则允许流量 |
| external | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh服务相关，则允许流量 |
| dmz | 拒绝流入的流量，除非与流出的流量相关；而如果流量与ssh服务相关，则允许流量 |
| block | 拒绝流入的流量，除非与流出的流量相关 |
| drop | 拒绝流入的流量，除非与流出的流量相关 |

<!-- OCR_START -->
- 没票观众
- eth1
- drop
- 演唱会
- 普通观众
- localhost
- public
- VIP观众
- BGX
- etho
- trusted
<!-- OCR_END -->

## 3.防火墙基本指令参数

为了能够使用firwalld服务和相关工具去管理防火墙，必须启动firwalld服务，并且需要禁用以前旧防火墙相关服务, `firewall-config`(图形界面), `firewall-cmd`

`firewalld`的规则分两种状态：

> runtime运行时: 修改规则马上生效,但是临时生效 \[不建议]
>
> permanent持久配置: 修改后需要reload重载才会生效 \[强烈推荐]

`firewall-cmd`命令分类

| 参数 | 作用 |
| :--- | :--- |
| **zone区域相关指令** | |
| --get-default-zone | 查询默认的区域名称 |
| --set-default-zone=<区域名称> | 设置默认的区域，使其永久生效 |
| --get-active-zones | 显示当前正在使用的区域与网卡名称 |
| --get-zones | 显示总共可用的区域 |
| --new-zone=<zone> | 新增区域 |
| **services服务相关指令** | |
| --get-services | 显示预先定义的服务 |
| --add-service=<服务名> | 设置默认区域允许该服务的流量 |
| --remove-service=<服务名> | 设置默认区域不再允许该服务的流量 |
| **Port端口相关指令** | |
| --add-port=<端口号/协议> | 设置默认区域允许该端口的流量 |
| --remove-port=<端口号/协议> | 设置默认区域不再允许该端口的流量 |
| **Interface网卡相关指令** | |
| --add-interface=<网卡名称> | 将源自该网卡的所有流量都导向某个指定区域 |
| --change-interface=<网卡名称> | 将某个网卡与区域进行关联 |
| **其他相关指令** | |
| --list-all | 显示当前区域的网卡配置参数、资源、端口以及服务等信息 |
| --reload | 让“永久生效”的配置规则立即生效，并覆盖当前的配置规则 |

## 4.防火墙区域配置策略

1.为了能正常使用`firwalld`服务和相关工具去管理防火墙，必须启动`firwalld`服务, 同时关闭以前旧防火墙相关服务

```plain
//禁用旧版防火墙服务
[root@xuliangwei ~]# systemctl mask iptables
[root@xuliangwei ~]# systemctl mask ip6tables
//启动firewalld防火墙, 并加入开机自启动服务
[root@xuliangwei ~]# systemctl start firewalld
[root@xuliangwei ~]# systemctl enable firewalld
//备份firewalld相关配置文件(重要)
[root@Firewalld ~]# cp -r /etc/firewalld/ /etc/firewalld_backup
```

2.`zone`区域相关指令

```plain
//查看当前默认区域
[root@xuliangwei ~]# firewall-cmd --get-default-zone 
public
//将当前默认区域修改为work
[root@xuliangwei ~]# firewall-cmd  --set-default-zone=work
//work区域允许所有人访问http服务 
[root@xuliangwei ~]# firewall-cmd --permanent --add-service=http --zone=work
//将网络接口切换至work区域
[root@xuliangwei ~]# firewall-cmd --change-interface=eth0 --zone=work
```

3.将某网段`IP`路由至`home`区域, 由该区域规则进行匹配决定是否放行

```plain
[root@Firewalld ~]# firewall-cmd --permanent --add-source=192.168.56.0/24 --zone=home
[root@Firewalld ~]# firewall-cmd --permanent --add-port=9000/tcp --zone=home
success
[root@Firewalld ~]# firewall-cmd --reload
success
//检查相关规则
[root@Firewalld ~]# firewall-cmd --get-active-zones
home
  sources: 192.168.56.0/24
public
  interfaces: eth0 br0 vnet0
```

4.查询`firewald`相关规则

```plain
//查看当前处于活动的区域
[root@Firewalld ~]#  firewall-cmd --get-active-zones
home  //数据包的源IP是192.168.69网段走home区域
  sources: 192.168.69.0/24
work  //默认区域, eth0接口流量都由work区域过滤
  interfaces: eth0 br0 vnet0
//查看指定区的明细
[root@xuliangwei ~]# firewall-cmd  --list-all --zone=work
work (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0
  sources:
  services: ssh dhcpv6-client 'http'
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

5.查询`public`区域是否允许请求`SSH HTTPS`协议的流量

```plain
[root@Firewalld ~]# firewall-cmd --zone=public --query-service=ssh
yes
[root@Firewalld ~]# firewall-cmd --zone=public --query-service=https
no
```

## 5.防火墙服务访问策略

1.配置防火墙, 允许请求`http https`协议的流量设置为永久允许，并立即生效

```plain
[root@Firewalld ~]# firewall-cmd --permanent --add-service=http --add-service=https
success
//重启加载生效
[root@Firewalld ~]# firewall-cmd --reload
success
//检查相关配置
[root@Firewalld ~]# firewall-cmd --list-services
ssh dhcpv6-client 'http https'
```

2.配置防火墙, 允许请求`php-fpm`服务的流量设置为永久允许，并立即生效

```plain
[root@Firewalld ~]# cd /usr/lib/firewalld/services/
//拷贝相应的xml文件
[root@Firewalld services]# cp http.xml php-fpm.xml
//修改端口为9000
[root@Firewalld services]# cat php-fpm.xml 
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>PHP-FPM</short>
  <description> php-fpm </description>
  <port protocol="tcp" port="9000"/>
</service>
//增加
[root@Firewalld ~]# firewall-cmd --permanent --add-service=php-fpm
//查看
[root@Firewalld ~]# firewall-cmd --list-services
ssh dhcpv6-client 'http https php-fpm'
//安装php-fpm, 并监听9000端口, 注意修改php-fpm端口监听在本网段
[root@Firewalld ~]# yum install php-fpm -y
[root@Firewalld ~]# systemctl start php-fpm
//外网telnet端口检测
~ telnet  192.168.56.11 9000
Trying 192.168.56.11...
Connected to 192.168.56.11.
Escape character is '^]'.
```

3.配置防火墙, 请求`https`协议的流量设置为永久拒绝，并立即生效

```plain
[root@Firewalld ~]# firewall-cmd --permanent --remove-service=https --remove-service=php-fpm --zone=public
success
[root@Firewalld ~]# firewall-cmd --reload
success
//检查当前活动服务
[root@Firewalld ~]# firewall-cmd --list-service
ssh dhcpv6-client http
```

## 6.防火墙端口访问策略

1.配置防火墙, 访问`8080/tcp 8080/udp`端口的流量策略设置为永久允许, 并立即生效

```plain
//添加firewalld规则
[root@Firewalld ~]# firewall-cmd --permanent --add-port=8080/udp --add-port=8080/tcp
//动态加载
[root@Firewalld ~]# firewall-cmd --reload
success
//检查端口规则
[root@Firewalld ~]# firewall-cmd --list-ports
8080/tcp 8080/udp
```

2.配置防火墙, 访问`8080/udp`的端口流量设置为永久拒绝，并立即生效

```plain
[root@Firewalld ~]# firewall-cmd --permanent --remove-port=8080/udp
success
[root@Firewalld ~]# firewall-cmd --reload && firewall-cmd --list-ports
success
8080/tcp
```

## 7.防火墙端口转发策略

端口转发是指传统的目标地址映射，实现外网访问内网资源

流量转发命令格式为

> firewall-cmd --permanent --zone=<区域> --add-forward-port=port=<源端口号>:proto=<协议>:toport=<目标端口号>:toaddr=<目标IP地址>

1.把访问本机`555/tcp`端口的流量转发到`22/tcp`端口，要求当前和长期有效

```plain
[root@Firewalld ~]# firewall-cmd --permanent --zone=public --add-forward-port=port=555:proto=tcp:toport=22:toaddr=192.168.56.11
success
[root@Firewalld ~]# firewall-cmd --reload
success
```

2.把访问本机`6666/tcp`端口的流量转发到`80/tcp`端口,要求当前和长期有效

```plain
[root@Firewalld ~]# firewall-cmd --permanent --add-port=80/tcp
[root@Firewalld ~]# firewall-cmd --permanent --zone=public --add-forward-port=port=6666:proto=tcp:toport=80:toaddr=192.168.56.11
success
[root@Firewalld ~]# firewall-cmd --reload
success
```

3.移除本地`555/tcp`端口转发策略, 要求当前和长期有效

```plain
[root@Firewalld ~]# firewall-cmd --remove-forward-port=port=555:proto=tcp:toport=22:toaddr=192.168.56.11
success
[root@Firewalld ~]# firewall-cmd --reload
success
```

## 8.防火墙富规则策略

firewalld中的富规则表示更细致、更详细的防火墙策略配置，它可以针对系统服务、端口号、源地址和目标地址等诸多信息进行更有针对性的策略配置, 优先级在所有的防火墙策略中也是最高的。

1.富规则帮助手册

```plain
man firewall-cmd
man firewalld.richlanguage
           rule
             [source]
             [destination]
             service|port|protocol|icmp-block|masquerade|forward-port
             [log]
             [audit]
             [accept|reject|drop]
rule [family="ipv4|ipv6"]
source address="address[/mask]" [invert="True"]
destination address="address[/mask]" invert="True"
service name="service name"
port port="port value" protocol="tcp|udp"
protocol value="protocol value"
forward-port port="port value" protocol="tcp|udp" to-port="port value" to-addr="address"
log [prefix="prefix text"] [level="log level"] [limit value="rate/duration"]
accept | reject [type="reject type"] | drop
//区里的富规则按先后顺序匹配，按先匹配到的规则生效。
--add-rich-rule='<RULE>'    //在指定的区添加一条富规则
--remove-rich-rule='<RULE>' //在指定的区删除一条富规则
--query-rich-rule='<RULE>'  //找到规则返回0 ，找不到返回1
--list-rich-rules       //列出指定区里的所有富规则
--list-all 和 --list-all-zones 也能列出存在的富规则
```

1.允许来自于`192.168.69.113/32`主机请求`8081-8083`端口, 当前和永久生效

```plain
[root@Firewalld ~]# firewall-cmd --zone=public --permanent \
--add-rich-rule='rule family=ipv4 source address=192.168.69.113/32 port port=8081-8083 protocol=tcp accept' 
success
[root@Firewalld ~]# firewall-cmd --reload
success
```

2.拒绝来自`192.168.69.113/32`主机所有的请求, 当前和永久生效

```plain
[root@Firewalld ~]# firewall-cmd --permanent --zone=public \
--add-rich-rule='rule family=ipv4 source address=192.168.69.113/32 reject'  
success
[root@Firewalld ~]# firewall-cmd --reload
success
```

3.拒绝来自于`192.168.69.0/24`网段请求`ssh`服务, 当前和永久生效

```plain
[root@Firewalld ~]# firewall-cmd --permanent --zone=public \
--add-rich-rule='rule family=ipv4 source address=192.168.69.0/24 service name=ssh reject'
success
[root@Firewalld ~]# firewall-cmd --reload
success
```

4.限制所有请求`ftp`服务流量, 每分钟1个并发, 当前和永久生效

```plain
[root@Firewalld ~]# firewall-cmd --permanent --zone=public \
--add-rich-rule='rule service name=ftp log prefix="ftp " level=notice limit value=1/m accept'
success 
[root@Firewalld ~]# firewall-cmd --reload
success
//开启多个ftp连接, 查看日志
[root@Firewalld ~]# tail -f /var/log/message
Apr 21 11:16:04 kvm-node1 kernel: ftp IN=br0 OUT= MAC=00:0c:29:72:6a96:00:50:56:c0:00:02:08:00 
SRC=192.168.56.1 DST=192.168.56.11 LEN=64 TOS=0x00 PREC=0x00 TTL=64 ID=21160 DF PROTO=TCP 
SPT=57050 DPT=21 WINDOW=65535 RES=0x00 SYN URGP=0
```

5.防止规则设定错误导致网络连接断开,用于调试,规则在300秒后失效

```plain
[root@Firewalld ~]# firewall-cmd \
--add-rich-rule='rule family=ipv4 source address=192.168.69.113/32 service name=ssh reject' --timeout=300
```

6.将`192.168.69.113/32`主机访问`443/tcp`的数据包转发到本机的`22/tcp`端口, 当前和永久生效

```plain
//端口转发规则
[root@Firewalld ~]# firewall-cmd --permanent --zone=public \
--add-rich-rule='rule family=ipv4 source address=192.168.56.1/32 forward-port port=443 protocol=tcp to-port=22'
success
[root@Firewalld ~]# firewall-cmd --reload
success
```

7.允许`192.168.69.113/32`访问`httpd`, 并且记录日志, 日志级别为`notice`,日志前缀为`NEW HTTP`, 限制每秒最多3个并发, 当前和永久生效

```plain
# yum install httpd
# systemctl start httpd
# systemctl enable httpd
[root@Firewalld soft]# firewall-cmd --permanent --zone=public \
--add-rich-rule='rule family=ipv4 source address=192.168.69.113/32 service name=http,https log level=notice prefix="New Http " limit value="3/s" accept' 
success
[root@Firewalld soft]# firewall-cmd --reload
success
```

> 更新: 2019-03-20 20:02:52  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/lovpql>