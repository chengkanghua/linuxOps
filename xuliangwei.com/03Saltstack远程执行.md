# 03 Saltstack远程执行

# 03 Saltstack远程执行

* [2.1目标(Target)](http://class.xuliangwei.com/15128073698252.html#toc_0)
* [2.2模块(Modules)](http://class.xuliangwei.com/15128073698252.html#toc_1)
* [2.3返回(Return)](http://class.xuliangwei.com/15128073698252.html#toc_2)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

当我们使用Salt执行一条远程命令

```plain
salt '*' cmd.run "df -h"
```

<!-- OCR_START -->
- Salt
- I*1
- cmd.run
- "df-h"
- command
- 命令
- 目标
- 模块
- 返回
<!-- OCR_END -->

## 2.1目标(Target)

<!-- OCR_START -->
- 自标匹配方式
- 与MinionlD相关
- 与MinionID无关
- 通配符
- 列表
- 正则
- IP
- 复合
- 分组
- Grains
- Pillar
<!-- OCR_END -->

1.通配符匹配方式

```plain
//*代表匹配所有主机
[root@salt0-master ~]# salt '*' test.ping
[root@salt0-master ~]# salt 'salt1-minion.example.com' test.ping 
[root@salt0-master ~]# salt 'salt1*' test.ping 
[root@salt0-master ~]# salt 'salt[1|2]*' test.ping 
[root@salt0-master ~]# salt 'salt?-minion.example.com' test.ping 
[root@salt0-master ~]# salt 'salt[!1|2]-minion.example.com' test.ping
```

2.列表匹配方式

```plain
[root@salt0-master ~]# salt -L 'salt1-minion.example.com,salt2-minion.example.com' test.ping
```

3.正则表达式

```plain
[root@salt0-master ~]# salt -E 'salt(1|2|3|4)*' test.ping 
[root@salt0-master ~]# salt -E 'salt(1|2|3|4)-minion.example.com' test.ping
```

4.IP匹配方式

```plain
[root@salt0-master ~]# salt -S '192.168.70.0/24' test.ping
[root@salt0-master ~]# salt -S '192.168.70.171' test.ping
```

5.分组匹配方式

```plain
[root@salt0-master ~]# vi /etc/salt/master
nodegroups:
  webserver: 'salt1-minion.example.com,salt2-minion.example.com'
  dbserver: 'L@salt1-minion.example.com,salt2-minion.example.com or salt3*'
  ftpserver: 'G@os:centos and salt1-minion.example.com'
[root@salt0-master ~]# systemctl restart salt-master
[root@salt0-master ~]# salt -N 'webserver' test.ping
```

6.Grains匹配方式

```plain
[root@salt0-master ~]# salt -G 'os:centos' test.ping 
[root@salt0-master ~]# salt -G 'fqdn_ip4:192.168.70.174' test.ping
```

> 注意：
>
> 所有在远程执行中可以匹配到目标的方式, 在TopFile定义时指定主机也可以使用该方法指定目标主机

主机名设计方案

```plain
1.IP地址
2.根据业务来进行设置www.xuliangwei.com
nginx-php-node1-lnmp01-hz-aliyun-www.xuliangwei.com
nginx-php-node1 代表第一个php架构节点
lnmp01 当前的集群环境
hz-aliyun 在杭州阿里云机房
www 业务线
xuliangwei.com 对应的域名
```

## 2.2模块(Modules)

> 模块：自带模块
>
> 1.安装 pkg
>
> 2.配置 file
>
> 3.启动 service

<!-- OCR_START -->
- 远程执行的模块
- pkg
- file
- service
- user
<!-- OCR_END -->

**软件包模块**

```plain
模块名：pkg
功能： 软件包状态，会根据操作系统不同，选择对应的安装方式（如CentOS系统默认会使用yum，Debian系统默认使用apt-get）
//安装
[root@salt0-master ~]# salt '*' pkg.install "httpd"
//卸载 
[root@salt0-master ~]# salt '*' pkg.remove "httpd"
//安装最新版本
[root@salt0-master ~]# salt '*' pkg.latest_version httpd
//查看模块帮助 salt '*' pkg
```

**文件模块**

```plain
//文件状态信息
[root@salt0-master ~]# salt '*' file.stats /etc/passwd
//文件创建
[root@salt0-master ~]# salt '*' file.touch "/tmp/bak"
//文件软链接
[root@salt0-master ~]# salt '*' file.symlink /tmp/123 /root/456
[root@salt0-master ~]# salt '*' file.rename /path/to/src /path/to/dst
[root@salt0-master ~]# salt '*' file.chown /etc/passwd root root
//查看模块帮助 salt '*' file
```

**服务模块**

```plain
salt '*' service.disabled <service name>
salt '*' service.enable <service name>
salt '*' service.enabled <service name>
salt '*' service.missing sshd
salt '*' service.reload <service name>
salt '*' service.restart <service name>
salt '*' service.start <service name>
salt '*' service.status <service name> [service signature]
salt '*' service.stop <service name>
//查看模块帮助 salt '*' pkg
```

## 2.3返回(Return)

`Return`组件可以理解为`SaltStack`系统对执行`Minion`返回后的数据存储或者返回给其他程序，支持多种存储方式，例如 `MySQL、MongoDB 、Redis、Memcache`等。

通过`Return`可以对`SaltStack`每次的操作进行记录，对以后的日志审计提供了数据源。

<!-- OCR_START -->
- Master
- return
- SQL
- ODBC
- mongo
- commands
- syslog
- states
- Minion
- salt
- disk.usage
- redis_return
<!-- OCR_END -->

1.配置一台数据库

```plain
[root@salt0-master ~]# yum install MySQL-python mariadb-server mariadb
[root@salt0-master ~]# systemctl start mariadb
#建立远程登录账户
MariaDB [(none)]> grant all on salt.* to salt@'%' identified by 'salt@Pass'; 
#创建对应的库和表
CREATE DATABASE  `salt`
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;
USE `salt`;
DROP TABLE IF EXISTS `jids`;
CREATE TABLE `jids` (
  `jid` varchar(255) NOT NULL,
  `load` mediumtext NOT NULL,
  UNIQUE KEY `jid` (`jid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX jid ON jids(jid) USING BTREE;
DROP TABLE IF EXISTS `salt_returns`;
CREATE TABLE `salt_returns` (
  `fun` varchar(50) NOT NULL,
  `jid` varchar(255) NOT NULL,
  `return` mediumtext NOT NULL,
  `id` varchar(255) NOT NULL,
  `success` varchar(10) NOT NULL,
  `full_ret` mediumtext NOT NULL,
  `alter_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `jid` (`jid`),
  KEY `fun` (`fun`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `salt_events`;
CREATE TABLE `salt_events` (
`id` BIGINT NOT NULL AUTO_INCREMENT,
`tag` varchar(255) NOT NULL,
`data` mediumtext NOT NULL,
`alter_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`master_id` varchar(255) NOT NULL,
PRIMARY KEY (`id`),
KEY `tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

2.`Minion`端操作

```plain
[root@salt1-minion ~]# yum install MySQL-python -y
[root@salt1-minion ~]# vim /etc/salt/minion 
#return: mysql
mysql.host: '192.168.70.170'
mysql.user: 'salt'
mysql.pass: 'salt@Pass'
mysql.db: 'salt'
mysql.port: 3306
[root@salt1-minion ~]# systemctl restart salt-minion
```

3.`Master`端操作

```plain
[root@salt0-master ~]# salt 'salt1*' test.ping --return mysql
```

4.检查数据库是否有值

```plain
*************************** 2. row ***************************
       fun: test.ping
       jid: 20180601115142525730
    return: true
        id: salt1-minion.example.com
   success: 1
  full_ret: {"fun_args": [], "jid": "20180601115142525730", "return": true, "retcode": 0, "success": true, "fun": "test.ping", "id": "salt1-minion.example.com"}
alter_time: 2018-06-01 11:51:42
```

> 更新: 2019-03-21 09:16:34  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/dz76tg>