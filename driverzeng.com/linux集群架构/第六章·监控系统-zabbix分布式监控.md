# 第六章·监控系统-zabbix分布式监控

+ [分布式监控](https://www.driverzeng.com/#toc_0)
+ [zabbix porxy代理概述](https://www.driverzeng.com/#toc_1)
+ [zabbix porxy代理功能](https://www.driverzeng.com/#toc_2)
+ [zabbix proxy代理企业场景](https://www.driverzeng.com/#toc_3)

> -曾老湿, 江湖人称曾老大。
>
> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023
>

---

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1)整合了各个公有云API，自主创建云主机。
>
> 2)ELK自动化收集日志功能。
>
> 3)Saltstack自动化运维统一配置管理工具。
>
> 4)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6)SQL执行及审批流程。
>
> 7)慢查询日志分析web界面。
>

---

## 分布式监控
| 概述 |
| --- |

Zabbix通过Zabbix proxies为IT基础设施提供有效和可用的分布式监控

代理(proxies)可用于代替Zabbix server本地收集数据，然后将数据报告给服务器。

---

| proxy特征 |
| --- |

当选择使用/不使用proxy时，必须考虑几个注意事项。

项。

| | Proxy |
| --- | :--- |
| _轻量级（Lightweight）_ | **Yes** |
| _图形界面（GUI）_ | No |
| _独立工作（Works independently）_ | **Yes** |
| _易于维护（Easy maintenance）_ | **Yes** |
| _自动生成数据库（Automatic DB creation）_1 | **Yes** |
| _本地管理（Local administration）_ | No |
| _准备嵌入式硬件 （Ready for embedded hardware）_ | **Yes** |
| _单向TCP连接（One way TCP connections）_ | **Yes** |
| _集中配置（Centralised configuration）_ | **Yes** |
| _生成通知（Generates notifications）_ | No |

---

![1574471853278-9f094778-631f-4c1e-8ecd-c613e8323f16.jpeg](img/第六章·监控系统-zabbix分布式监控/image1.jpeg)￼[1] 自动数据库创建功能仅适用于SQLite。其他数据库需要[手动设置](https://www.zabbix.com/documentation/3.4/manual/installation/install#requirements)

---

## zabbix porxy代理概述
| 概述 |
| --- |

zabbix proxy 可以代替 zabbix server 收集性能和可用性数据,然后把数据汇报给 zabbix server,并且在一定程度上分担了zabbix server 的压力.

此外，当所有agents和proxies报告给一个Zabbix server并且所有数据都集中收集时，使用proxy是实现集中式和分布式监控的最简单方法。

> zabbix proxy 使用场景:
>
> 1.监控远程区域设备
>
> 2.监控本地网络不稳定区域
>
> 3.当 zabbix 监控上千设备时,使用它来减轻 server 的压力
>
> 4.简化分布式监控的维护
>

<!-- OCR_START -->
- ZABBIX
- Firewall
- PROXY
- 曾老湿
- DriverZeng
- RemotelocationismonitoredbysingleZABBIXProxy
<!-- OCR_END -->

￼

zabbix proxy 仅仅需要一条 tcp 连接到 zabbix server,所以防火墙上仅仅需要加上一条规则即可。

proxy 收集到数据之后，首先将数据缓存在本地,然后在一定得时间之后传递给 zabbix  server，这样就不会因为服务器的任何临时通信问题而丢失数据。这个时间由 proxy配置文件中参数 ProxyLocalBuffer 和  ProxyOfflineBuffer 决定。

**注意：  
****1.zabbix proxy 数据库必须和 server 分开,否则数据会被破坏。  
****2.从Zabbix server数据库直接更新最新配置的proxy可能会比Zabbix server新，而Zabbix server的配置由于  CacheUpdateFrequency 的原因而无法快速更新。因此，proxy收集发送Zabbix server数据可能会被忽略。**

## zabbix porxy代理功能
zabbix proxy 是一个数据收集器,它不计算触发器、不处理事件、不发送报警。有关proxy功能的概述，如下表：

| 功能 | proxy支持(yes/no) | |
| :--- | :--- | --- |
| 项目（Items） | | |
| | _Zabbix agent checks_ | **Yes** |
| _Zabbix agent checks (active)_ | **Yes** 1 | |
| _Simple checks_ | **Yes** | |
| _Trapper items_ | **Yes** | |
| _SNMP checks_ | **Yes** | |
| _SNMP traps_ | **Yes** | |
| _IPMI checks_ | **Yes** | |
| _JMX checks_ | **Yes** | |
| _日志文件监控（Log file monitoring）_ | **Yes** | |
| _内部检查（Internal checks）_ | **Yes** | |
| _SSH checks_ | **Yes** | |
| _Telnet checks_ | **Yes** | |
| _外部检查（External checks）_ | **Yes** | |
| 内置web监控（Built-in web monitoring） | **Yes** | |
| 网络发现(Network discovery) | **Yes** | |
| 自动发现（Low-level discovery） | **Yes** | |
| 触发器计算（Calculating triggers） | _No_ | |
| 处理事件（Processing events） | _No_ | |
| 发送报警（Sending alerts） | _No_ | |
| 远程命令（Remote commands） | _No_ | |

使用 agent active 模式,一定要记住在 agent 的配置文件参数 **ServerActive** 加上 proxy 的 IP 地址。

## zabbix proxy代理企业场景

<!-- OCR_START -->
- 黑龙江机房
- DriverZeng
- zabbix-agent
- Eth1:172.16.1.9
- zabbix-
- Proxyl
- Eth0:10.0.0.7
- Eth1:172.16.1.7
- Eth1:172.16.1.10
- 防火墙
- Zabbix-Server
- 阿里云机房
- Eth1:172.16.1.11
- Zabbix-Proxy2
- Eth0:10.0.0.8
- Eth1:172.16.1.8
- 曾老湿
- Eth1:172.16.1.12
<!-- OCR_END -->

￼

---

| zabbix proxy分布式场景实践环境规划 |
| --- |

| **服务器功能** | **服务器外网** | **服务器内网** |
| --- | --- | --- |
| zabbix-server | 10.0.0.71 | ~~172.16.1.71~~ |
| zabbix-proxy | 10.0.0.8 | 172.16.1.8 |
| zabbix-agent | ~~10.0.0.7~~ | 172.16.1.7 |

---

| 安装部署zabbix proxy |
| --- |

```plain
[root@web01 ~]# yum install -y https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-proxy-mysql-3.4.15-1.el7.x86_64.rpm
```

---

| 配置zabbix proxy数据库 |
| --- |

```plain
[root@web01 ~]# yum install -y mariadb-server
[root@web01 ~]# systemctl start mariadb
[root@web01 ~]# systemctl enable mariadb
[root@web01 ~]# mysql
#创建数据库
MariaDB [(none)]> create database zabbix_proxy charset utf8;
#创建用户
MariaDB [(none)]> grant all on zabbix_proxy.* to zabbix_proxy@'localhost' identified by '123';
```

---

| 导入数据 |
| --- |

```plain
#查看数据文件
[root@web01 ~]# rpm -ql zabbix-proxy-mysql
/usr/share/doc/zabbix-proxy-mysql-3.4.15/schema.sql.gz
#导入数据
[root@web01 ~]# zcat /usr/share/doc/zabbix-proxy-mysql-3.4.15/schema.sql.gz |mysql zabbix_proxy
#查看导入后的数据
[root@web01 ~]# mysql
MariaDB [(none)]> show databases;
MariaDB [zabbix_proxy]> show tables;
```

---

| 修改zabbix proxy配置文件 |
| --- |

```plain
[root@web01 ~]# vim /etc/zabbix/zabbix_proxy.conf
Server=10.0.0.71
Hostname=hlj_proxy
DBName=zabbix_proxy
DBHost=localhost
DBUser=zabbix_proxy
DBPassword=123
```

---

| 启动zabbix proxy并加入开机自启 |
| --- |

```plain
[root@web01 ~]# systemctl start zabbix-proxy
[root@web01 ~]# systemctl enable zabbix-proxy
[root@web01 ~]# netstat -lntup
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:10051           0.0.0.0:*               LISTEN      82597/zabbix_proxy
```

---

| 配置zabbix agent |
| --- |

```plain
[root@web02 ~]# vim /etc/zabbix/zabbix_agentd.conf
Server=172.16.1.7
ServerActive=172.16.1.7
Hostname=web02
```

---

| 页面配置zabbix proxy |
| --- |

<!-- OCR_START -->
- Z曾老湿：配置代理
- C① 不安全| 10.0.0.8/zabbix/zabbix.php?action=proxy.list&ddreset=1
- ☆日
- 应用 zabbix-api
- ZABBIX
- 监测中资产记录报表
- 配置管理
- QZShare
- ？_(
- 一般agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- agent代理程序
- 创建代理
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置代理
- →CA不安全|10.0.0.8/zabbix/zabbix.php?action=proxy.edit
- 应用 zabbix-api
- ZABBIX
- 监测中资产记录报表 配置 管理
- ZShare
- 一般 agent代理程序 认证用户群组 用户 报警媒介类型脚本队列
- 曾老湿
- agent代理程序
- 加密
- agent代理程序名称hlj_proxy
- 系统代理程序模式
- 主动式被动式
- 主机agent代理程序的主机
- 其它主机
- 描述
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置主机
- ① 不安全 | 10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用 zabbix-api
- ZABBIX
- 监测中资产记录 报表配置 管理
- Share
- 主机群组模板
- 主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 主机
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- IP地址
- 端口
- 应用
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent 加密
- 信息
- web01
- 应用集11
- 监控项50
- 触发器22
- 图形9
- 自动发现2
- Web监测1
- 10.0.0.7:10050
- TCP状态监控模板,Template OS Linux(Template AppZabbix Agent)
- 已启用
- ZBXSNMP|JMXIPMI
- Zabix server
- 监控项69
- 触发器46
- 图形11
- 127.0.0.1: 10050
- TemplateAppabbixSereTemplatSLinxemlatAppZabbixAgent
- 停用的
- 显示已自动发现的 2中的2
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置主机
- A不安全|10.0.0.8/zabbix/hosts.php?groupid=0&form=创建主机
- 应用
- zabbix-api
- 工件
- 工VV
- 主机
- 模板
- IPMI
- 主机资产记录
- 加密
- 主机名称
- web01
- 可见的名称
- 群组在..群组之中
- 其它群组
- Linux servers
- Discoveredhosts
- Hypervisors
- Template/Base
- Templates
- Templates/Applications
- Templates/Databases
- Templates/Modules
- Templates/NetworkDevices
- Templates/OperatingSystems
- Templates/ServersHardware
- 新的群组
- agent代理程序的接口
- IP地址
- DNS名称
- 连接到
- 端口
- 默认
- 172.16.1.7
- DNS
- 10050
- 移除
- 添加
- SNMP接口
- JMX接口
- IPMI接口
- 描述
- 由agent代理程序监测
- hlj_proxy
- 已启用
- 取消
- 曾老湿
- DriverZeng
- Zabbix3.4.15.@2001-2018,ZabbixSIA
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置主机
- C ① 不安全 | 10.0.0.8/zabbix/hosts.php
- 应用zabbix-api
- ZABBIX
- 监测中 资产记录 报表  配置管理
- QZShare
- 主机群组模板
- 主机维护动作关联项事件
- 自动发现
- 服务
- 曾老湿
- 已添加主机
- 主机
- 群组所有
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 应用
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent 加密
- 信息
- 001
- 172.16.1.7: 10050
- 已启用
- ZBXSNMPJMXIPMI
<!-- OCR_END -->

￼

**	**

 			

> 更新: 2019-11-23 09:17:55  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/um693l>