# day59 Zabbix监控快速入门

* 1.为什么要使用监控
  * 1.对系统不间断实时监控
  * 2.实时反馈系统当前状态
  * 3.保证服务可靠性安全性
  * 4.保证业务持续稳定运行
* 2.如何进行监控，比如我们需要监控磁盘的使用率
  * 1.如何查看磁盘使用率`df -h`
  * 2.监控磁盘的那些指标`block、inode`
  * 3.如何获取具体的信息`df -h|awk '/\/$/{print $(NF-1)}'`
  * 4.获取的数值到达多少报警 80%
* 3.流行的监控工具
  * 1.cacti、Nagios、Zabbix、
  * 2.Lepus(天兔)数据库监控系统
  * 3.Open-Falcon 小米
  * 4.Prometheus(普罗米修斯，Docker、K8s)
* 4.如果去到一家新公司，如何入手监控
  * 1.硬件监控 路由器、交换机、防火墙
  * 2.系统监控 CPU、内存、磁盘、网络、进程、TCP
  * 3.服务监控 nginx、php、tomcat、redis、memcache、mysql
  * 4.WEB监控 请求时间、响应时间、加载时间、
  * 5.日志监控 ELk（收集、存储、分析、展示） 日志易
  * 6.安全监控 Firewalld、WAF(Nginx+lua)、安全宝、牛盾云、安全狗
  * 7.网络监控 smokeping 多机房
  * 8.业务监控

运维面试中，常常会被问题监控相关的问题，那么这个问题到底该如何来回答，我针对本文给大家提供了一个简单的回答思路。\
1.硬件监控。\
通过SNMP来进行路由器交换机的监控(这些可以跟一些厂商沟通来了解如何做)、服务器的温度以及其他，可以通过IPMI来实现。当然如果没有硬件全都是云，直接跳过这一步骤。\
2.系统监控。\
如CPU的负载，上下文切换、内存使用率、磁盘读写、磁盘使用率、磁盘inode使用率。当然这些都是需要配置触发器，因为默认太低会频繁报警。\
3.服务监控。\
比如公司用的LNMP架构，nginx自带Status模块、PHP也有相关的Status、MySQL的话可以通过percona官方工具来进行监控。Redis这些通过自身的info获取信息进行过滤等。方法都类似。要么服务自带。要么通过脚本来实现想监控的内容，以及报警和图形功能。\
4.网络监控。\
如果是云主机又不是跨机房，那么可以选择不监控网络。当然你说我们是跨机房以及如何如何。推荐使用smokeping来做网络相关的监控。或者直接交给你们的网络工程师来做，因为术业有专攻。\
5.安全监控。\
如果是云主机可以考虑使用自带的安全防护。当然也可以使用iptables。如果是硬件，那么推荐使用硬件防火墙。使用云可以购买防DDOS，避免出现故障导致down机一天。如果是系统，那么权限、密码、备份、恢复等基础方案要做好。web同时也可以使用Nginx+Lua来实现一个web层面的防火墙。当然也可以使用集成好的openresty。\
6.Web监控。\
web监控的话题其实还是很多。比如可以使用自带的web监控来监控页面相关的延迟、js响应时间、下载时间、等等。这里我推荐使用专业的商业软件,监控宝或听云来实现。毕竟人家全国各地都有机房。（如果本身是多机房那就另说了）\
7.日志监控。\
如果是web的话可以使用监控Nginx的50x、40x的错误日志，PHP的ERROR日志。其实这些需 求无非是，收集、存储、查询、展示，我们其实可以使用开源的ELKstack来实现。 Logstash（收集）、elasticsearch（存储+搜索）、kibana（展示）\
8.业务监控。\
我们上面做了那么多，其实最终还是保证业务的运行。这样我们做的监控才有意义。所以业务层面这块的监控需要和开发以及总监开会讨论，监控比较重要的业务指标，（需要开会确认）然后通过简单的脚本就可以实现，最后设置触发器即可\
9.流量分析。\
平时我们分析日志都是拿awk sed xxx一堆工具来实现。这样对我们统计ip、pv、uv不是很方便。那么可以使用百度统计、google统计、商业，让开发嵌入代码即可。为了避免隐私也可以使用piwik来做相关的流量分析。\
10.可视化。\
通过screen以及引入一些第三方的库来美化界面，同时我们也需要知道，订单量突然增加、突然减少。或者说突然来了一大波流量，这流量从哪儿来，是不是推广了，还是被攻击了。可以结合监控平来梳理各个系统之间的业务关系。\
11.自动化监控。\
如上我们做了那么多的工作，当然不能是一台一台的来加key实现。可以通过Zabbix的主动模式以及被动模式来实现。当然最好还是通过API来实现。

12.分布式监控

## 2.单机时代如何监控

[1.监控命令参考文档](http://man.linuxde.net/par/3) <http://man.linuxde.net/par/3>

```bash
CPU监控命令: w、top、htop、glances
%Cpu(s):  0.3 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
us 用户态: 跟用户的操作有关 35%
sy 系统态: 跟内核的处理有关 60%
id CPU空闲:
```

内存监控命令: `free`

```bash
[root@m01 ~]# free -m
total        used        free      shared  buff/cache   available
Mem:            974         440         194           4         340         328
Swap:          2047          11        2036
```

磁盘监控命令: `df、iotop`

```bash
Device:            tps    kB_read/s    kB_wrtn/s        kB_read     kB_wrtn
sda               0.80        25.32        33.36        221034      291193
设备名        每秒传输次数   每秒读大小   每秒写大小   读的总大小   写的总大小
```

网络监控命令: `ifconfig、route、glances、iftop、nethogs、netstat`

```bash
单位换算
Mbps  100Mbps/8
MB    12MB
iftop  中间的<= =>这两个左右箭头，表示的是流量的方向。
TX：发送流量、RX：接收流量、TOTAL：总流量
#查看TCP11中状态
netstat -an|grep ESTABLISHED
netstat -rn                    # 查看路由信息
netstat -lntup
```

2.随着时间的推移，用户不断的增多，服务随时可能扛不住会被`oom(out of memory)`，当系统内存不足的时候，会触发`oom`

> 1.当系统内存不足的时候就会大量使用swap 2.当系统大量使用swap的时候，系统会特别卡 注意: 有时可能内存还有剩余300Mb-500Mb，但会发现swap依然被使用

```bash
[root@m01 ~]# dd if=/dev/zero of=/dev/null bs=800M
[root@m01 ~]# tail -f /var/log/messages
Out of memory: Kill process 2227 (dd) score 778 or sacrifice child
Killed process 2227 (dd) total-vm:906724kB, anon-rss:798820kB, file-rss:0kB
```

3.那单机时代，如何使用`shell`脚本来实现服务器的监控

> 需求: 每隔1分钟监控一次内存,当你的可用内存低于100m,发邮件报警,要求显示剩余内存
>
> 1.怎么获取内存可用的值`free -m|awk '/^Mem/{print $NF}'` 
>
> 2.获取到内存可用的值如何和设定的阈值进行比较
>
> 3.比较如果大于100m则不处理，如果小于100则报警
>
> 4.如何每隔1分钟执行一次

```bash
早期监控脚本
[root@nfs ~]# cat free.sh 
#!/usr/bin/bash
#Auth
while true
do
  #1.定义主机名，时间，IP地址
  Date=$(hostname)_$(hostname -I|awk '{print $2}')_$(date +%F)
  #2.获取可用的内存
  Free_Use=$(free -m|awk '/^Mem/{print $NF}')
  #3.进行比较
  if [ $Free_Use -le 100 ];then
    echo "$Date 内存已经低于100M, 当前还剩余可用内存: $Free_Use"
  fi
  sleep 3
  echo "循环又开始"
done
```

## zabbix监控快速安装

```bash
1.配置Zabbix仓库
rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
# rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/5.5/rhel/7/x86_64/zabbix-release-5.5-1.el7.noarch.rpm
#rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/6.5/rhel/7/x86_64/zabbix-release-6.5-1.el7.noarch.rpm
2.安装Zabbix程序包，以及MySQL、Zabbix-agent
yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server
3.创建Zabbix数据库以及用户
systemctl start mariadb
# mysql -uroot
MariaDB [(none)]> create database zabbix character set utf8 collate utf8_bin;
MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';

4.导入Zabbix数据至数据库中
cd /usr/share/doc/zabbix-server-mysql-3.4.15/
zcat create.sql.gz |mysql -uroot zabbix

5.编辑/etc/zabbix/zabbix_server.conf文件，修改数据库配置
[root@zabbix-server ~]# grep  ^[a-Z]  /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix                *******

6.启动Zabbix服务进程，并加入开机自启
systemctl start zabbix-server
systemctl enable zabbix-server

7.配置Apache的配置文件/etc/httpd/conf.d/zabbix.conf，修改时区。
[root@zabbix-server ~]# vim /etc/httpd/conf.d/zabbix.conf
php_value max_execution_time 300
php_value memory_limit 128M
php_value post_max_size 16M
php_value upload_max_filesize 2M
php_value max_input_time 300
php_value always_populate_raw_post_data -1
#取消注释，设置正确的时区
php_value date.timezone Asia/Shanghai       ****

8.启动Apache服务
systemctl enable httpd
systemctl start httpd

9.通过浏览器访问http://IP/zabbix 进入向导页面，进行zabbix安装。
10.完成zabbix安装后，默认的登录页面账户和密码是  Admin  zabbix
# mariadb也要加入开机自启
systemctl enable mariadb.service

# 如果出现网络延时找不到情况试试  清华源   下面的参考 
手动安装
yum localinstall https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-server-mysql-3.4.12-1.el7.x86_64.rpm
yum localinstall https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-web-3.4.12-1.el7.noarch.rpm
yum install mariadb -y
yum install mariadb mariadb-server -y
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
zcat /usr/share/doc/zabbix-server-mysql-3.4.15/create.sql.gz | mysql -uroot zabbix

```

![1547294913204-5d1b3285-593f-4ab4-acec-4dad55f30337.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-01.png)

检查依赖项是否不存在任何异常

 ![1547294930673-2781a4d5-0147-4467-aecf-6e1dfade7e57.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-02.png)

配置`zabbixWeb`连接数据库

 ![1547294962035-88f8bd82-d07d-406f-b7c2-f5020e590764.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-03.png) 

配置`ZabbixServer`服务器的主机名或主机IP地址和端口号, 以及安装的名称（可选）

![1547295006120-0204d3d2-03db-4d14-9305-7c7a33e817f9.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-04.png)

安装前摘要，检查配置参数。如果一切都正确，请按"下一步"按钮或"后退"按钮来更改配置参数。

![1547295028018-e65e6878-5bf0-4c32-b4e6-d147139f7b08.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-05.png)

 提示已成功地安装了`Zabbix`前端。配置文件`/etc/zabbix/web/zabbix.conf.php`被创建。 

![1547295042268-9fd3d77e-e075-4ad0-87db-db3bdd427414.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-06.png)

默认登陆ZabbixWeb的用户名`Admin`，密码`zabbix`

![1547295062845-f47593d1-897f-420c-a2f9-18a95c98cb76.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-07.png)

调整`ZabbixWeb`前端为中文字符集 ![1547295086735-9fa5c90a-952c-457f-8531-f66dd165506b.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-08.png)

至此Zabbix已经安装完毕

![1547295118088-5efb1b9b-79b8-4c38-8ee7-b4f7b8402a9a.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-09.png)

## 快速监控一台主机

```bash
#安装zabbix agent 客户端 版本可以比服务端低
rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.12-1.el7.x86_64.rpm

[root@web01 ~]# rpm -ql zabbix-agent
/etc/logrotate.d/zabbix-agent
/etc/zabbix/zabbix_agentd.conf
/etc/zabbix/zabbix_agentd.d
/etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
/usr/lib/systemd/system/zabbix-agent.service
/usr/lib/tmpfiles.d/zabbix-agent.conf
/usr/sbin/zabbix_agentd
# 修改配置
[root@web01 ~]# vim /etc/zabbix/zabbix_agentd.conf
Server=172.16.1.71
[root@web01 ~]# sed '/^Server/c Server=172.16.1.71' /etc/zabbix/zabbix_agentd.conf
#启动
[root@web01 ~]# systemctl start zabbix-agent.service
# 检查端口 10050
[root@web01 ~]# netstat -lntp
tcp   0   0 0.0.0.0:10050   0.0.0.0:*  LISTEN   2410/zabbix_agentd
```

4 配置ZabbixWeb页面，点击配置->选择主机->创建主机

![1547295133268-9c0b3051-9c8d-44c7-bfd1-37c89616a869.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-10.png)

![1547295154624-92c71273-ab29-47fd-bced-e076f3f31041.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-11.png)

5.点击模板->选择连接指示器->选择->搜索Linux->点击小按钮添加->最后添加

![1547295177046-6b204168-248b-4309-8a31-54ee5db662b5.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-12.png)

![1547295194691-6074b313-d632-4bc7-ba83-d0d640a19c1c.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-13.png)

![1547295206006-663b0d8a-7a10-4055-bd2a-9888a494b6d9.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-14.png)

## Zabbix基础架构

zabbix-agent ---->zabbix-server ----> 数据库 <--- zabbix web

数据采集 数据分析|报警 数据存储 数据展示

![1547295228879-5f643862-c482-4cd6-837e-4b083f479e72.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-15.png)

## Zabbix拆分数据库

`Zabbix`数据拆分: `LAP+MySQL`（修改如下两个文件中连接数据库的配置信息）

(300台服务器以内不用拆封数据库)

```bash
ll /etc/zabbix/zabbix_server.conf
ll /etc/zabbix/web/zabbix.conf.php
```

```bash
1.在新的数据库上创建zabbix库
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@'%' identified by 'Bgx123.com';

2.在旧的zabbix服务器上备份数据库文件，然后倒至新的数据库
[root@m01 ~]# mysqldump -uroot \
--databases zabbix \
--single-transaction > `date +%F%H`-zabbix.sql
[root@m01 ~]# cat 2018-08-2017-zabbix.sql |mysql -h 10.0.0.51 -uzabbix -pBgx123.com zabbix

3.修改zabbixServer的数据库连接信息
[root@m01 ~]# vim /etc/zabbix/zabbix_server.conf 
DBHost=172.16.1.51
DBName=zabbix
DBUser=zabbix
DBPassword=Bgx123.com

[root@m01 ~]# systemctl restart zabbix-server    

4.修改zabbixWeb连接数据库信息
[root@m01 ~]# vim /etc/zabbix/web/zabbix.conf.php 
$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '172.16.1.51';
$DB['PORT']     = '0';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'Bgx123.com';

[root@m01 ~]# systemctl restart httpd

```

```bash
如出现如下错误：请检查数据库是否允许远程连接，对应的账户和密码是否配置错误
[root@m01 ~]# tail -f /var/log/zabbix/zabbix_server.log
2189:20180820:173636.941 [Z3001] connection to database 'zabbix' failed: [2003] Can't connect to MySQL server on '172.16.1.51' (111)
```

## 自定义监控-初试

```bash
1.监控系统中的对象 
iostat | awk '/^sda/{print $2}'

2.如何增加监控项 
UserParameter=<key>,<shell command>

[root@web01 ~]# cat /etc/zabbix/zabbix_agentd.d/iotop.conf
UserParameter=iotps,iostat | awk '/^sda/{print $2}'

[root@web01 ~]# systemctl restart zabbix-agent

3.agent如何验证自己定义的监控项是否生效，是否能取值
[root@web01 ~]# zabbix_agentd -p |grep iotps
iotps                           [t|1.72]

4.Zabbix-Server如何验证Zabbix-Agent是否有对应的监控项
[root@zabbix ~]# yum install zabbix-get -y
[root@zabbix ~]# zabbix_get -s 172.16.1.7 -p10050 -k iotps
3.76

5.ZabbixWeb界面进行关联
1.选择配置->主机->对应主机->监控项->创建监控项->名称->键值(监控项目名称)->信息类型->单位
2.选择监测中->最新数据->等待30s
7.自定义阈值（到达预设的瓶颈）
1.选择配置->主机->对应主机->触发器->创建触发器->名称->
表达式一定要选择对应的监控项进行设定（{web03-10.0.0.9:system.users.num.last()}>2）->确认
2.开启多个会话窗口，测试前端报警
3.前端报警开启方式->右上角->小人头->正在发送消息->开启即可

```

5.ZabbixWeb界面进行关联  1.选择配置->主机->对应主机->监控项->创建监控项->名称->键值(监控项目名称)->信息类型->单位

![1547295246313-b09da46e-7a8b-4eef-bfa7-7334700aadc7.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-16.png)

![1547295262697-af45ff54-328f-4633-ba93-727fc75e979a.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-17.png)

2.选择监测中->最新数据->等待30s

![1547295283776-de0e1ab8-ea64-4df7-a636-5480699a5cda.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-18.png)

7.自定义阈值（到达预设的瓶颈）  1.选择配置->主机->对应主机->触发器->创建触发器->名称->  表达式一定要选择对应的监控项进行设定（{web03-10.0.0.9:system.users.num.last()}>2）->确认

![1547295316862-115b6921-51f6-40e8-b153-46e2af1fece1.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-19.png)

![1547295338413-32b5a8c8-39d1-456c-b11b-897c2b7686ba.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-20.png)

2.开启多个会话窗口，测试前端报警  3.前端报警开启方式->右上角->小人头->正在发送消息->开启即可

![1547295406295-40b226a0-8352-4287-ae00-483893fb5eb9.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-21.png)

web01 多登陆两个个窗口

![1547297073616-c0602dbe-5726-4423-a33e-59525d7de58d.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-22.png)

## Zabbix监控-自定义监控-Day02

## 自定义报警(邮件|微信)

*当监控项超过触发器设定的阈值->****触发动作->****（发送消息|\*\*执行命令）*

*1.* *怎么报警-> 2.\*\*报警怎么发，发什么内容 ->* *报警发给谁*

*注意：要使SMTP*\_**验证选项可用，Zabbix**\_*服务器应使用cURL 7.20.0\*\*或更高版本*

1.单击配置->动作->启用动作 

![1547297104161-bb743000-b795-4418-ba8e-6fad694d4cf4.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-23.png)

2.单击管理→报警媒介类型，设定发送消息的介质-email 

![1547297128535-b61c38ad-c5f2-4c19-b89b-d098ea3c8121.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-24.png)

3.配置服务器邮件的发件人，使用邮箱账户和授权密码（注意：不是收件人邮箱） 

![1547297204456-b9363ced-73af-4942-b816-4e7ac50ab8c6.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-25.png)

4.配置收件人接收的邮箱，单击右上角用户->报警媒介->添加 

![1547297228574-8b039149-9bcc-4f17-a6b2-cc13a0873af6.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-26.png)

5.填写收件人类型, 收件人邮箱，接收报警的级别，最后点击添加，

              \_                                                            \_                                 ![1547297301816-abe46785-327b-4042-9c68-aa3c25465eac.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-27.png)

6.确认没有任何问题，点击更新即可。 

![1547297264421-bce86530-92d8-4be7-9a5c-c980aed586f0.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-28.png)

7.如果邮箱配置没有任何错误，可以尝试触发报警, 查看邮件是否能收到报警消息 

![1547297458253-edf05036-39f2-4a5b-b667-87e351f44b74.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-29.png)

 8.如果邮箱配置存在错误，单击报表->动作日志->检查邮箱发送情况 

![1547297474471-b26d3d57-b4da-4147-8ac5-93d72e9af1d7.png](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-30.png)


> 更新: 2024-08-30 18:33:50  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/gyq69l>