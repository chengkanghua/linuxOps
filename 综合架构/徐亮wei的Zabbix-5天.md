# Zabbix监控-体系介绍-Day01
zabbix监控大纲-day01

	0.单机监控

	1.安装zabbix

	2.zabbix基础架构

	3.监控一台主机

	4.自定义监控项（自己编写脚本->zabbix）

	5.自定义阈值（到达预设的瓶颈）

	6.自定义动作（发邮件|执行命令）

	7.自定义报警



## [](#c3gvfr)监控体系概述
1.为什么要使用监控

	1.对系统不间断实时监控	

	2.实时反馈系统当前状态

	3.保证服务可靠性安全性

	4.保证业务持续稳定运行



2.监控怎么用，比如我们需要监控磁盘的使用率

	1.如何查看磁盘使用率 df -h

	2.监控磁盘的那些指标 block、inode

	3.如何获取具体的信息 df -h|awk '/\/$/{print $(NF-1)}'

	4.获取的数值到达多少报警 80%



4.有哪些监控工具

	cacti、Nagios、Zabbix、

	Lepus(天兔)数据库监控系统

	Open-Falcon 小米

	Prometheus(普罗米修斯，Docker、K8s)



5.如果去到一家新公司，如何入手？

	1.硬件监控	路由器、交换机、防火墙

	2.系统监控	CPU、内存、磁盘、网络、进程、TCP

	3.服务监控	nginx、php、tomcat、redis、memcache、mysql....

	4.WEB监控	响应时间、加载时间、渲染时间、

	5.日志监控	ELk（收集、存储、分析、展示）  日志易

	6.安全监控	Firewalld、WAF(Nginx+lua)、安全宝、牛盾云、安全狗

	7.网络监控	smokeping 多机房

	8.业务监控

	

## [](#tckwiu)单机如何监控
```bash
http://man.linuxde.net/par/3

yum install glances -y
glances 啥都能看

CPU： w、top、htop、
	%Cpu(s):  0.3 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
	us 用户态: 跟用户的操作有关 35%
	sy 系统态: 跟内核的处理有关 60%
	id CPU空闲: 5%

内存: free
[root@m01 ~]# free -m
total        used        free      shared  buff/cache   available
Mem:            974          55         840           0          79         797
Swap:          3967          48        3919

磁盘：df、iotop
Device:            tps    kB_read/s    kB_wrtn/s    	kB_read    	kB_wrtn
sda               0.80        25.32        33.36     	221034     	291193
设备名        每秒传输次数   每秒读大小   每秒写大小   读的总大小   写的总大小


网络：ifconfig、route、glances、iftop、nethogs、netstat
单位换算
Mbps  100Mbps/8
MB	  12MB

iftop  中间的<= =>这两个左右箭头，表示的是流量的方向。
TX：发送流量、RX：接收流量、TOTAL：总流量
netstat
netstat -an|grep ESTABLISHED   	#查看状态
netstat -rn    				   # 查看路由信息
netstat -lntup
netstat -an

3：使用shell脚本来监控服务器（磁盘空间不够）
内存:每隔1分钟监控一次内存,当你的可用内存低于100m,发邮件报警,要求显示剩余内存
	1.怎么获取内存可用的值（free -m|awk '/^Mem/{print $NF}'）
	2.获取到内存可用的值如何和设定的阈值进行比较
	3.比较如果大于100m则不处理，如果小于100则报警
	4.如何每隔1分钟执行一次

[root@m01 ~]# cat free.sh 
#!/usr/bin/bash
HostName=$(hostname)_$(hostname -i)
Date=$(date +%F)

while true;do
	Free=$(free -m|awk '/^Mem/{print $NF}')

	if [ $Free -le 100 ];then
		echo "$Date: $HostName Mem Is < ${Free}MB"
	fi
	sleep 5
done


4.随着时间的推移，用户不断的增多，服务随时可能扛不住会被oom(out of memory)
当系统内容不足的时候，会触发oom, 当内存不够会使用swap，当swap被大量占用。系统会特别卡

[root@m01 ~]# dd if=/dev/zero of=/dev/null bs=800M status=progress
[root@m01 ~]# tail -f /var/log/messages
Out of memory: Kill process 2227 (dd) score 778 or sacrifice child
Killed process 2227 (dd) total-vm:906724kB, anon-rss:798820kB, file-rss:0kB
```





## [](#1ohkpt)安装Zabbix-Server
5.Zabbix-Server，是一个C/S和B/S结构



```bash
1.安装Zabbix-server
rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
yum remove zabbix22 -y
yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server

2.创建Zabbix数据库以及用户
	#启动数据库，加入开机自启
systemctl enable mariadb
systemctl start mariadb
	#创建数据库并授权
# mysql -uroot -p
MariaDB [(none)]> create database zabbix character set utf8 collate utf8_bin;
MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
3.导入基础架构和数据
[root@m01 ~]# cd /usr/share/doc/zabbix-server-mysql-3.4.12/
[root@m01 ~]# zcat create.sql.gz |mysql -uroot zabbix

4.启动Zabbix Server进程，在zabbix_server.conf中编辑数据库配置
[root@m01 ~]# vi /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix

# 启动Zabbix Server进程
[root@m01 ~]# systemctl enable zabbix-server
[root@m01 ~]# systemctl start zabbix-server

5.编辑Zabbix前端的PHP配置，Zabbix前端的Apache配置文件位于 /etc/httpd/conf.d/zabbix.conf 。一些PHP设置已经完成了配置。

[root@m01 ~]# /etc/httpd/conf.d/zabbix.conf 
php_value max_execution_time 300
php_value memory_limit 128M
php_value post_max_size 16M
php_value upload_max_filesize 2M
php_value max_input_time 300
php_value always_populate_raw_post_data -1
# php_value date.timezone Asia/Shanghai

依据所在时区，你可以取消 “date.timezone” 设置的注释，并正确配置它(Asia/Shanghai)。在配置文件更改后，需要重启Apache Web服务器。

6.启动httpd服务
systemctl enable httpd
systemctl start httpd

```

## [](#96sqmo)快速监控一台主机
```bash
1.安装
rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.12-1.el7.x86_64.rpm

2.配置
[root@web03 ~]# vim /etc/zabbix/zabbix_agentd.conf
Server=10.0.0.61	#指向Zabbix-Server

3.启动
systemctl start zabbix-agent
systemctl enable zabbix-agent

[root@web03 ~]# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:10050           0.0.0.0:*               LISTEN      1103/zabbix_agentd
```



## [](#7ubozp)Zabbix基础架构
zabbix-agent ---->zabbix-server ----> 数据库 <--- zabbix web

数据采集            数据分析|报警     数据存储      数据展示



## [](#o3erxd)Zabbix拆分数据库
```bash
LAMP 单台
LAP+MySQL架构（修改如下两个文件中连接数据库的配置信息）
[root@m01 ~]# ll /etc/zabbix/zabbix_server.conf
[root@m01 ~]# ll /etc/zabbix/web/zabbix.conf.php

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
	

如出现如下错误：请检查数据库是否允许远程连接，对应的账户和密码是否配置错误
[root@m01 ~]# tail -f /var/log/zabbix/zabbix_server.log
 2189:20180820:173636.941 [Z3001] connection to database 'zabbix' failed: [2003] Can't connect to MySQL server on '172.16.1.51' (111)

 
```



## [](#ixx0mx)自定义监控-初试
```bash
1.监控系统中的对象 
iostat | awk '/^sda/{print $2}'

2.如何增加监控项 
UserParameter=<key>,<shell command>
[root@web03 ~]# cat /etc/zabbix/zabbix_agentd.d/iotop.conf
UserParameter=iotps,iostat | awk '/^sda/{print $2}'
[root@web03 ~]# systemctl restart zabbix-agent
  
3.agent如何验证自己定义的监控项是否生效，是否能取值
[root@web03 ~]# zabbix_agentd -p |grep iotps
iotps                               [t|1.72]
  
4.Zabbix-Server如何验证Zabbix-Agent是否有对应的监控项
[root@m01 ~]# yum install zabbix-get -y
[root@m01 ~]# zabbix_get -s 10.0.0.9 -p10050 -k iotps
1.69

5.ZabbixWeb界面进行关联
	1.选择配置->主机->对应主机->监控项->创建监控项->名称->键值(监控项目名称)->信息类型->单位
	2.选择监测中->最新数据->等待30s

7.自定义阈值（到达预设的瓶颈）
	1.选择配置->主机->对应主机->触发器->创建触发器->名称->
	表达式一定要选择对应的监控项进行设定（{web03-10.0.0.9:system.users.num.last()}>2）->确认
	2.开启多个会话窗口，测试前端报警
	3.前端报警开启方式->右上角->小人头->正在发送消息->开启即可
  
```

# [](#fn3eog)Zabbix监控-自定义监控-Day02
## [](#qi8otg)自定义报警(邮件|微信)
_当监控项超过触发器设定的阈值->触发动作->（发送消息|执行命令）_

1. _怎么报警-> 2.报警怎么发，发什么内容 -> 报警发给谁_

_<font style="color:#FF0000;">注意：要使SMTP验证选项可用，Zabbix服务器应使用cURL 7.20.0或更高版本</font>_



_1.启用动作_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-01.png)

_2.__<font style="color:#333333;">单击管理→报警媒介类型，</font>__设定发送消息的介质-email_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-02.png)

__

_3.配置发件人的账号和授权码（注意：不是收件人邮箱）_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-03.png)

__

_4.配置收件人接收的邮箱地址-点击小人头->选择报警媒介->点击小按钮添加_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-04.png)

__

_5.添加收件人的邮箱，以及接受报警的等级_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-05.png)



6.一定要点击更新按钮



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-06.png)

__

_7.如果邮箱无法发送，请检查email设定的客户端授权码_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-07.png)

__

_8.如果邮箱配置没有任何错误，效果如下_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-08.png)



**<font style="color:#FF0000;">2.实现企业微信报警</font>**

```bash
1.创建媒体介质类型->脚本->写什么内容->脚本放在哪
yum install python-pip -y 
pip install requests 
cd /usr/lib/zabbix/alertscripts
chmod +x weixin.py 
./weixin.py  WeiXinID   111   2222
chown zabbix.zabbix /tmp/weixin.log

2.创建报警媒介
{ALERT.SENDTO}  #发给谁
{ALERT.SUBJECT}  #发送的主题
{ALERT.MESSAGE}  #发送的内容

```





![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-09.png)



3.微信报警脚本媒介



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-10.png)

__

_3.接收的微信号（企业微信中自己的名子的全拼，首字母大写 XuLiangWei）_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-11.png)

## 
## 自定义监控-深入
```bash
详细介绍监控项的每个对应的参数
自定义监控tcp11种状态（演示传参）
cd /etc/zabbix/zabbix_agentd.d/
[root@zabbix-01 zabbix_agentd.d]# cat -n tcp_state.conf  
UserParameter=tcp_state[*],netstat -ant|grep -c $1

systemctl restart zabbix-agent

# zabbix-server测试
[root@zabbix ~]# zabbix_get -s 10.0.0.7 -k tcp_state[LISTEN]
8
```





![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-12.png)

添加11种TCP的状态，先添加一个，然后进行克隆，如需修改更新间隔请全选监控项，批量修改。



对于不支持的key，请调整如下选项

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-13.png)



_<font style="color:#FF0000;">演示监控tcp的22端口是否处于监听状态，使用类型是字符类型->使用Service State值映射</font>_

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-14.png)





![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-15.png)

_<font style="color:#FF0000;"></font>_

_<font style="color:#FF0000;">演示差异速度</font>_

创建文件写入100  监控上—>获取数据后->重定向文件200 然后查看获

取的值—>点击图形—>获取最近500的值

## [](#zmr3lb)自定义阈值-深入
_<font style="color:#FF0000;">1.演示取出内存的百分比</font>_

```bash
取出内存的可用的MB大小 / 总的内存大小 = 实际可用的百分比
1.定义剩余内存百分比
[root@web03 zabbix_agentd.d]# vim /etc/zabbix/zabbix_agentd.d/oldboy.conf
UserParameter=Mem_pre,free -m|awk '/^Mem/{print $NF*100/$2}'

[root@web03 zabbix_agentd.d]# systemctl restart zabbix-agent

2.在ZabbixServer验证监控项是否可用
[root@m01 ~]# zabbix_get -s 10.0.0.9 -k 'Mem_pre'
72.1766

```

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-16.png)



_<font style="color:#FF0000;">2.自定义单条件触发器，设置内存低于 30% 进行报警</font>_

__

_1.创建触发器_

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-17.png)

__

_2.填写表达式_

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-18.png)

__

_3.压低内存，检查报警邮件（以内存1G为例，使用下面方式进行消耗内存）_

_[root@web03 ~]# dd if=/dev/zero of=/dev/null bs=500M count=1024_

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-19.png)

_<font style="color:#FF0000;">3.内存低于百分之10加上，swap使用超过百分之5，再次进行监控报警（更精准）</font>_

```bash
1.增加swap的监控 
[root@web03 ~]# vim /etc/zabbix/zabbix_agentd.d/oldboy.conf
UserParameter=Swap_pre,free -m|awk '/^Swap/{print $3*100/$2}'

[root@web03 ~]# systemctl restart zabbix-agent

2.在ZabbixServer使用zabbix_get命令测试
[root@m01 ~]# zabbix_get -s 10.0.0.9 -k 'Swap_pre'
1.05873
```

3.在ZabbixWeb创建监控项

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-20.png)

4.基于之前建立的触发器进行修改，修改为多条规则同时满足才触发

`{web03-10.0.0.9:Mem_pre.last()}<30 and {web03-10.0.0.9:Swap_pre.last()}>1 `



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-21.png)



5.使用dd命令进行压测(只满足内存低于30%规则，所以无法报警)

[root@web03 ~]# dd if=/dev/zero of=/dev/null bs=500M count=1024  



6.使用dd命令进行压测(满足内存低于30%规则，并且同时满足swap使用率超过百分之1

触发报警)

[root@web03 ~]# dd if=/dev/zero of=/dev/null bs=800M count=1024  



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-22.png) 7.常用的触发器表达式，常用的函数

_<font style="color:#FF0000;">and 并且  or 或者</font>_

_last()     比对最新的值_

_avg()    解决波动报警，流量在多少分钟平均达到多少报警avg(5m)_

_diff()    比对上一次文件的内容_

_nodata() 收不到数据进行报警nodata(5m)_



_<font style="color:#FF0000;">4.图形中文乱码处理</font>_

```bash
[root@m01 ~]# cd /usr/share/fonts/dejavu/
[root@m01 dejavu]# mv DejaVuSans.ttf DejaVuSans.ttf.bak

在windows电脑的C盘找到windows目录, 进入fonts，随便复制一个字体至桌面，然后上传至服务器C:\Windows\Fonts
[root@m01 dejavu]# rz   #上传了simhei.ttf
[root@m01 dejavu]# mv simhei.ttf DejaVuSans.ttf

```

## [](#ipm4be)自定义报警修改
定制报警的内容

[https://www.zabbix.com/documentation/3.4/zh/manual/appendix/macros/supported_by_location](https://www.zabbix.com/documentation/3.4/zh/manual/appendix/macros/supported_by_location)

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-23.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-24.png)

<font style="color:#333333;">告警消息内容：</font>

<font style="color:#333333;">报警主机：{HOST.NAME1}</font>

<font style="color:#333333;">报警服务: {ITEM.NAME1}</font>

<font style="color:#333333;">报警Key1: {ITEM.KEY1}：{ITEM.VALUE1}</font>

<font style="color:#333333;">报警Key2: {ITEM.KEY2}：{ITEM.VALUE2}</font>

<font style="color:#333333;">严重级别: {TRIGGER.SEVERITY}</font>

<font style="color:#333333;"></font>

<font style="color:#333333;">恢复消息内容：</font>

<font style="color:#333333;">恢复主机：{HOST.NAME1}</font>

<font style="color:#333333;">恢复服务： {ITEM.NAME1}</font>

<font style="color:#333333;">恢复Key1：{ITEM.KEY1}：{ITEM.VALUE1}</font>

<font style="color:#333333;">恢复Key2: {ITEM.KEY2}：{ITEM.VALUE2}</font>



最终邮件报警效果

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-25.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-26.png)

## 
## 自定义定制图形
1.介绍监控的顺序->应用级->监控项->基于监控项创建触发器->基于监控项创建图形

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-27.png)

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-28.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-29.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-30.png)



2.聚合图形->将多张图整合起来，合并为一张图

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-31.png)	



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-32.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-33.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-34.png)



 3.幻灯片可以轮询播放聚合图形

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-35.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-36.png)



## [](#3d5fpn)自定义图形树 
```bash
1.安装graphtree
cd /usr/share/zabbix
wget https://raw.githubusercontent.com/OneOaaS/graphtrees/master/graphtree3.0.4.patch

2.导入补丁包
yum install -y patch
patch  -Np0 <graphtree3.0.4.patch
chown -R apache.apache oneoaas

3.修改Apache配置文件
#vim /etc/httpd/conf.d/zabbix.conf		
Alias /oneoaas /usr/share/zabbix/oneoaas		
Alias /zabbix /user/share/zabbix	

4.重启httpd服务
systemctl restart httpd
```



5.效果图

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-37.png)

 

展示每个组的图形，也可以展示组下面对应的主机



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-38.png)



## 自定义模板
_<font style="color:#FF0000;">1.模板是支持导入与导出（模板里面的监控项是有脚本支撑，所以脚本需一起打包）</font>_

_<font style="color:#FF0000;">2.   .conf，定义监控项，调用脚本或命令。</font>_

_<font style="color:#FF0000;">3.如果希望将之前定义的监控项做成模板，找到监控项->全选->复制</font>_

_<font style="color:#FF0000;">4. 自定义使用模板（让监控项可以重复使用）</font>_

_<font style="color:#FF0000;"></font>_

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-39.png)

        

1.客户端agent必须要定义监控项，监控项取值需要使用到脚本文件或系统命令

2.服务端导入模板

3.创建监控主机，链接新导入模板，如果是已存在的监控主机，增加我们刚导入的模板



# [](#bg8zfn)Zabbix监控-应用监控-Day03
1.对应的服务本身都具备打开状态页面，针对状态页面进行取值，定义监控项，传递给zabbix-agent

2.在Zabbixweb添加对应的key和主机，ZabbixServer抓取ZabbixAgent上的数据。



应用监控 Nginx、PHP、Redis、MySQL

## <font style="color:rgb(50, 50, 93);">Zabbix监控TCP</font>
<font style="color:rgb(82, 95, 127);">Tcp的连接状态对于我们web服务器来说是至关重要的，尤其是并发量ESTAB；或者是syn_recv值，假如这个值比较大的话我们可以认为是不是受到了攻击，或是是time_wait值比较高的话，我们要考虑看我们内核是否需要调优，太高的time_wait值的话会占用太多端口，要是端口少的话后果不堪设想：所以今天我们来学学如何使用Zabbix监控tcp状态</font>



```bash
1.编写Shell脚本
[root@linux-node1 ~]# cd /etc/zabbix/scripts
[root@linux-node1 scripts]# vim tcp_status.sh
#!/bin/bash
############################################################
# $Name:         tcp_status.sh
# $Version:      v1.0
# $Function:     TCP Status
# $Author:       xuliangwei
# $organization: www.xuliangwei.com
# $Create Date:  2016-06-23
# $Description:  Monitor TCP Service Status
############################################################
[ $# -ne 1 ] && echo "Usage:CLOSE-WAIT|CLOSED|CLOSING|ESTAB|FIN-WAIT-1|FIN-WAIT-2|LAST-ACK|LISTEN|SYN-RECV SYN-SENT|TIME-WAIT" && exit 1
tcp_status_fun(){
    TCP_STAT=$1
    ss -ant | awk 'NR>1 {++s[$1]} END {for(k in s) print k,s[k]}' > /tmp/ss.txt
    TCP_STAT_VALUE=$(grep "$TCP_STAT" /tmp/ss.txt | cut -d ' ' -f2)
    if [ -z "$TCP_STAT_VALUE" ];then
        TCP_STAT_VALUE=0
    fi
    echo $TCP_STAT_VALUE
}
tcp_status_fun $1;
添加执行权限

[root@linux-node1 scripts]# chmod +x tcp_status.sh 


2.监控项linux_tcp.conf的配置文件如下：
[root@linux-node1 ~]# cat /etc/zabbix/zabbix_agentd.d/tcp.conf
UserParameter=tcp_status[*],/bin/bash /etc/zabbix/scripts/tcp_status.sh "$1"

3.重启zabbix-agent修改配置文件必须重启
[root@linux-node1 ~]# systemctl restart  zabbix-agent

4.Server测试Agent是否能获取到值，通过Zabbix_get(不要直接执行脚本)
[root@linux-node1 scripts]# zabbix_get -s 192.168.90.11 -k tcp_status[ESTAB]
8

5.添加所有监控项(记得将模板关联主机)
6.查看图形(图形是自定义创建)

```



## Nginx监控


**<font style="color:rgb(82, 95, 127);">实验环境</font>**

| <font style="color:rgb(82, 95, 127);">服务器系统</font> | <font style="color:rgb(82, 95, 127);">角色</font> | <font style="color:rgb(82, 95, 127);">IP</font> |
| :--- | :--- | :--- |
| <font style="color:rgb(82, 95, 127);">CentOS 7.4 x86_64</font> | <font style="color:rgb(82, 95, 127);">Zabbix-Server</font> | <font style="color:rgb(82, 95, 127);">192.168.90.10</font> |
| <font style="color:rgb(82, 95, 127);">CentOS 7.4 x86_64</font> | <font style="color:rgb(82, 95, 127);">Zabbix-Agent</font> | <font style="color:rgb(82, 95, 127);">192.168.90.11</font> |


```bash
2.在nginx.conf的Server标签下添加如下内
location /nginx_status {
    stub_status on;
    access_log  off;
    allow 127.0.0.1;
    deny all;
    }
    
3.本地访问Nginx Status
[root@linux-node1 ~]# curl http://127.0.0.1/nginx_status
Active connections: 1
server accepts handled requests
 1 1 1
Reading: 0 Writing: 1 Waiting: 0
 
Nginx状态解释：
Active connections  Nginx正处理的活动链接数1个
server              Nginx启动到现在共处理了1个连接。
accepts             Nginx启动到现在共成功创建1次握手。 
handled requests    Nginx总共处理了1次请求。
Reading             Nginx读取到客户端的 Header 信息数。
Writing             Nginx返回给客户端的 Header 信息数。
Waiting             Nginx已经处理完正在等候下一次请求指令的驻留链接，开启。
 
Keep-alive的情况下，这个值等于active-（reading + writing）。
请求丢失数=(握手数-连接数)可以看出,本次状态显示没有丢失请求。

4.编写Nginx的Shell脚本(如果端口不一致,只需要修改脚本端口即可)
[root@Agent ~]# mkdir -p /etc/zabbix/scripts
[root@linux-node1 scripts]# vim /etc/zabbix/scripts/nginx_status.sh
#!/bin/bash
############################################################
# $Name:         nginx_status.sh
# $Version:      v1.0
# $Function:     Nginx Status
# $Author:       ckh
# $organization: www.chengkanghua.top,www,bjstack.com
# $Create Date:  2016-06-23
# $Description:  Monitor Nginx Service Status
############################################################

NGINX_PORT=80  #如果端口不同仅需要修改脚本即可，否则修改xml很麻烦
NGINX_COMMAND=$1
 
nginx_active(){
    /usr/bin/curl -s "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" |awk '/Active/ {print $NF}'
}
 
nginx_reading(){
    /usr/bin/curl -s "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" |awk '/Reading/ {print $2}'
}
 
nginx_writing(){
    /usr/bin/curl -s "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" |awk '/Writing/ {print $4}'
       }
 
nginx_waiting(){
    /usr/bin/curl -s "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" |awk '/Waiting/ {print $6}'
       }
 
nginx_accepts(){
    /usr/bin/curl -s "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" |awk 'NR==3 {print $1}'
       }
 
nginx_handled(){
    /usr/bin/curl -s "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" |awk 'NR==3 {print $2}'
       }
 
nginx_requests(){
    /usr/bin/curl -s "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" |awk 'NR==3 {print $3}'
       }
 
 
  case $NGINX_COMMAND in
    active)
        nginx_active;
        ;;
    reading)
        nginx_reading;
        ;;
    writing)
        nginx_writing;
        ;;
    waiting)
        nginx_waiting;
        ;;
    accepts)
        nginx_accepts;
        ;;
    handled)
        nginx_handled;
        ;;
    requests)
        nginx_requests;
        ;;
          *)
        echo $"USAGE:$0 {active|reading|writing|waiting|accepts|handled|requests}"
    esac

 
5.给脚本添加执行权限
[root@Agent]# chmod +x /etc/zabbix/scripts/nginx_status.sh

6.监控项nginx_status.conf的配置文件如下：
[root@Agent ~]# cat /etc/zabbix/zabbix_agentd.d/nginx_status.conf
UserParameter=nginx_status[*],/bin/bash /etc/zabbix/zabbix_agentd.d/scripts/nginx/nginx_status.sh "$1"

6.重启zabbix-agent
[root@Agent ~]# systemctl restart  zabbix-agent

7.使用Zabbix_get来获取值
[root@linux-node1 ~]# zabbix_get -s 192.168.90.11 -k nginx_status[writing]
1

8.添加所有监控项, 如图4-3, 记得关联到指定的主机

```



## [](#qh7due)PHP-fpm监控
**<font style="color:rgb(82, 95, 127);">实践环境</font>**

| <font style="color:rgb(82, 95, 127);">服务器系统</font> | <font style="color:rgb(82, 95, 127);">角色</font> | <font style="color:rgb(82, 95, 127);">IP</font> |
| :--- | :--- | :--- |
| <font style="color:rgb(82, 95, 127);">CentOS 7.4 x86_64</font> | <font style="color:rgb(82, 95, 127);">Zabbix-Server</font> | <font style="color:rgb(82, 95, 127);">192.168.90.10</font> |
| <font style="color:rgb(82, 95, 127);">CentOS 7.4 x86_64</font> | <font style="color:rgb(82, 95, 127);">Zabbix-Agent</font> | <font style="color:rgb(82, 95, 127);">192.168.90.11</font> |


```bash
1.PHP-FPM工作模式通常与Nginx结合使用,修改php-fpm.conf
[root@Agent ~]# vim /etc/php-fpm.d/www.conf
pm.status_path = /phpfpm_status

2.修改nginx.conf的配置文件,增加如下location访问PHP-FPM状态信息。
   location ~ ^/(phpfpm_status)$ {
        include fastcgi_params;
        fastcgi_pass    127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}


3.访问测试phpfpm_status
[root@Agent ~]# curl http://127.0.0.1/phpfpm_status
pool:                 www
process manager:      dynamic
start time:           05/Jul/2016:15:30:56 +0800
start since:          409
accepted conn:        22
listen queue:         0
max listen queue:     0
listen queue len:     128
idle processes:       4
active processes:     1
total processes:      5
max active processes: 2
max children reached: 0
 
#PHP-FPM状态解释：
pool #fpm池名称,大多数为www
process manager #进程管理方式dynamic或者static
start time #启动日志,如果reload了fpm，时间会更新
start since #运行时间
accepted conn #当前池接受的请求数
listen queue #请求等待队列,如果这个值不为0,那么需要增加FPM的进程数量
max listen queue #请求等待队列最高的数量
listen queue len #socket等待队列长度
idle processes #空闲进程数量
active processes #活跃进程数量
total processes #总进程数量
max active processes #最大的活跃进程数量（FPM启动开始计算）
max children reached #程最大数量限制的次数，如果这个数量不为0，那说明你的最大进程数量过小,可以适当调整。

4.编写php-fpm的Shell脚本(如果端口不一致,只需要修改脚本端口即可)
[root@Agent ~]# cd /etc/zabbix/scripts
[root@Agent scripts]# vim phpfpm_status.sh
#!/bin/bash
############################################################
# $Name:         phpfpm_status.sh
# $Version:      v1.0
# $Function:     Nginx Status
# $Author:       xuliangwei
# $organization: www.xuliangwei.com
# $Create Date:  2016-06-23
# $Description:  Monitor Nginx Service Status
############################################################
 
PHPFPM_COMMAND=$1
PHPFPM_PORT=80  #根据监听不同端口进行调整
 
start_since(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^start since:/ {print $NF}'
}
 
accepted_conn(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^accepted conn:/ {print $NF}'
}
 
listen_queue(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^listen queue:/ {print $NF}'
}
 
max_listen_queue(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^max listen queue:/ {print $NF}'
}
 
listen_queue_len(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^listen queue len:/ {print $NF}'
}
 
idle_processes(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^idle processes:/ {print $NF}'
}
 
active_processes(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^active processes:/ {print $NF}'
}
 
total_processes(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^total processes:/ {print $NF}'
}
 
max_active_processes(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^max active processes:/ {print $NF}'
}
 
max_children_reached(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^max children reached:/ {print $NF}'
}
 
slow_requests(){
    /usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm_status" |awk '/^slow requests:/ {print $NF}'
}
 
case $PHPFPM_COMMAND in
    start_since)
        start_since;
        ;;
    accepted_conn)
        accepted_conn;
        ;;
    listen_queue)
        listen_queue;
        ;;
    max_listen_queue)
        max_listen_queue;
        ;;
    listen_queue_len)
        listen_queue_len;
        ;;
    idle_processes)
        idle_processes;
        ;;
    active_processes)
        active_processes;
        ;;
        total_processes)
                total_processes;
                ;;
        max_active_processes)
                max_active_processes;
                ;;
        max_children_reached)
                max_children_reached;
                ;;
        slow_requests)
                slow_requests;
                ;;
          *)
        echo $"USAGE:$0 {start_since|accepted_conn|listen_queue|max_listen_queue|listen_queue_len|idle_processes|active_processes|total_processes|max_active_processes|max_children_reached}"
    esac

 
5.给脚本添加执行权限
[root@Agent scripts]# chmod +x phpfpm_status.sh

6.监控项的phpfpm_status.conf配置文件如下：
[root@Agent ~]# cat /etc/zabbix/zabbix_agentd.d/phpfpm_status.conf
UserParameter=phpfpm_status[*],/bin/bash /etc/zabbix/scripts/phpfpm_status.sh "$1"

6.重启zabbix-agent
[root@Agent ~]# systemctl restart  zabbix-agent

7.Server使用zabbix_get命令来获取Agent端的值
[root@linux-node1 zabbix_agentd.d]# zabbix_get -s 192.168.90.11 -k phpfpm_status[accepted_conn]
45

8.添加所有监控项, 如下图4-5, 最后记得关联至对应主机
9.查看图形，如图4-4(图形自定义)

```

  
 



## MySQL监控
`<font style="color:rgb(94, 102, 135);">percona Monitoring Plugins</font>`<font style="color:rgb(82, 95, 127);">是一个高质量的组件，为</font>`<font style="color:rgb(94, 102, 135);">MySQL</font>`<font style="color:rgb(82, 95, 127);">数据库添加企业级的监控和图表功能。但其脚本使用</font>`<font style="color:rgb(94, 102, 135);">PHP</font>`<font style="color:rgb(82, 95, 127);">实现，故而</font>`<font style="color:rgb(94, 102, 135);">Zabbix-Agent</font>`<font style="color:rgb(82, 95, 127);">需要安装</font>`<font style="color:rgb(94, 102, 135);">PHP</font>`<font style="color:rgb(82, 95, 127);">环境。</font>

[percona工具集](https://www.percona.com/software/documentation)

```bash
#获取mysql的状态信息，写入文件，针对文件进行取值
yum install php php-fpm php-mysql mariadb-server
systemctl start mariadb

#创建远程可以登录的数据库账户和密码
# mysql -uroot 
MariaDB [(none)]> grant all on *.* to mysql@'%' identified by '123456';
#建议不要使用新库

rpm -ivh https://www.percona.com/downloads/percona-monitoring-plugins/percona-monitoring-plugins-1.1.8/binary/redhat/7/x86_64/percona-zabbix-templates-1.1.8-1.noarch.rpm

tree /var/lib/zabbix/percona
cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /etc/zabbix/zabbix_agentd.d/
systemctl restart zabbix-agent

配置php连接数据库 
# vim /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php
<?php
$mysql_user = 'root';
$mysql_pass = '';
$mysql_port = 3306;

测试shell脚本，shell脚本包含了php命令，php通过命令去连接mysql获取的状态
# sh /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh gg
405647

# 在Zabbix-Server端上使用Zabbix_get获取值(否则会失败)
[root@vpn-server ~]# zabbix_get -s 10.0.0.11 -k MySQL.pool-read-requests
2572

//如果获取不到值常见问题
1.看是否是MySQL密码错误
2.不要直接执行脚本来获取
3.删除/tmp/localhost-mysql_cacti_stats.txt文件
4.权限问题导致

测试完脚本，一定删除产生的文件
rm -f /tmp/localhost-mysql_cacti_stats.txt


在Zabbix页面模板选项中导入Percona模板, 模板存放在/var/lib/zabbix/percona/templates， 最后关联主机即可。

```

## Redis监控
`<font style="color:rgb(94, 102, 135);">Redis</font>`<font style="color:rgb(82, 95, 127);">使用自带的</font>`<font style="color:rgb(94, 102, 135);">INFO</font>`<font style="color:rgb(82, 95, 127);">命令，进行状态监控。以一种易于解释且易于阅读的格式，返回关于</font>`<font style="color:rgb(94, 102, 135);">Redis</font>`<font style="color:rgb(82, 95, 127);">服务器的各种信息和统计数值。</font>

<font style="color:rgb(82, 95, 127);">1.编写Shell脚本</font>

+ <font style="color:rgb(82, 95, 127);"> </font><font style="color:rgb(82, 95, 127);">脚本端口、连接redis服务地址根据具体情况进行修改</font>
+ <font style="color:rgb(82, 95, 127);"> AUTH认证没有开启，将PASSWD修改为空即可。</font>

```bash
[root@Agent ~]# mkdir -p  /etc/zabbix/scripts
[root@Agent ~]# vim /etc/zabbix/scripts/redis_status.sh
#!/bin/bash
############################################################
# $Name:         redis_status.sh
# $Version:      v1.0
# $Function:     Redis Status
# $Author:       ckh
# $organization: www.chengkanghua.top
# $Create Date:  2016-06-23
# $Description:  Monitor Redis Service Status
############################################################
 
R_COMMAND="$1"
R_PORT="6379"  #根据实际情况调整端口
R_SERVER="127.0.0.1"  #根据具体情况调整IP地址
PASSWD=""    #如果没有设置Redis密码,为空即可
 
 
redis_status(){
   (echo -en "AUTH $PASSWD\r\nINFO\r\n";sleep 1;) | /usr/bin/nc "$R_SERVER" "$R_PORT" > /tmp/redis_"$R_PORT".tmp
      REDIS_STAT_VALUE=$(grep "$R_COMMAND:" /tmp/redis_"$R_PORT".tmp | cut -d ':' -f2)
       echo "$REDIS_STAT_VALUE"
}
 
case $R_COMMAND in
    used_cpu_user_children)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_cpu_sys)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    total_commands_processed)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    role)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    lru_clock)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    latest_fork_usec)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    keyspace_misses)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    keyspace_hits)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    keys)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    expires)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    expired_keys)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    evicted_keys)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    connected_clients)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    changes_since_last_save)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    blocked_clients)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    bgsave_in_progress)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    bgrewriteaof_in_progress)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_memory_peak)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_memory)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_cpu_user)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    used_cpu_sys_children)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    total_connections_received)
    redis_status "$R_PORT" "$R_COMMAND"
    ;;
    *)
    echo $"USAGE:$0 {used_cpu_user_children|used_cpu_sys|total_commands_processed|role|lru_clock|latest_fork_usec|keyspace_misses|keyspace_hits|keys|expires|expired_keys|connected_clients|changes_since_last_save|blocked_clients|bgrewriteaof_in_progress|used_memory_peak|used_memory|used_cpu_user|used_cpu_sys_children|total_connections_received}"
    esac

--------------------------------------------------------------------------------------------
3.添加脚本执行权限
[root@Agent ~]# chmod +x /etc/zabbix/scripts/redis_status.sh

4.Zabbix权限不足处理办法
[root@Agent ~]# rm -f /tmp/redis_6379.tmp

5.key的redis_status.conf的配置文件如下：
[root@Agent ~]# cat /etc/zabbix/zabbix_agentd.d/redis_status.conf
UserParameter=redis_status[*],/bin/bash /etc/zabbix/scripts/redis_status.sh "$1" 

6.重启zabbix-agent
[root@Agent ~]# systemctl restart  zabbix-agent

7.在Zabbix-Server使用Zabbix_get获取值
[root@Server ~]# zabbix_get -s 192.168.90.11 -k redis_status[used_cpu_sys]
16.81

8.展示所有Key(记得将模板关联主机)如图4-14

9.查看图形，如图4-15、图4-16(图形自定义)
    
```

<font style="color:rgb(82, 95, 127);">Redis状态参数解释：</font>

```bash
server : Redis 服务器信息，包含以下域：
redis_version : Redis 服务器版本
redis_git_sha1 : Git SHA1
redis_git_dirty : Git dirty flag
os : Redis 服务器的宿主操作系统
arch_bits : 架构（32 或 64 位）
multiplexing_api : Redis 所使用的事件处理机制
gcc_version : 编译 Redis 时所使用的 GCC 版本
process_id : 服务器进程的 PID
run_id : Redis 服务器的随机标识符（用于 Sentinel 和集群）
tcp_port : TCP/IP 监听端口
uptime_in_seconds : 自 Redis 服务器启动以来，经过的秒数
uptime_in_days : 自 Redis 服务器启动以来，经过的天数
lru_clock : 以分钟为单位进行自增的时钟，用于 LRU 管理
clients : 已连接客户端信息，包含以下域：
connected_clients : 已连接客户端的数量（不包括通过从属服务器连接的客户端）
client_longest_output_list : 当前连接的客户端当中，最长的输出列表
client_longest_input_buf : 当前连接的客户端当中，最大输入缓存
blocked_clients : 正在等待阻塞命令（BLPOP、BRPOP、BRPOPLPUSH）的客户端的数量
memory : 内存信息，包含以下域：
used_memory : 由 Redis 分配器分配的内存总量，以字节（byte）为单位
used_memory_human : 以人类可读的格式返回 Redis 分配的内存总量
used_memory_rss : 从操作系统的角度，返回 Redis 已分配的内存总量（俗称常驻集大小）。这个值和 top 、 ps 等命令的输出一致。
used_memory_peak : Redis 的内存消耗峰值（以字节为单位）
used_memory_peak_human : 以人类可读的格式返回 Redis 的内存消耗峰值
used_memory_lua : Lua 引擎所使用的内存大小（以字节为单位）
mem_fragmentation_ratio : used_memory_rss 和 used_memory 之间的比率
persistence : RDB 和 AOF 的相关信息
stats : 一般统计信息
replication : 主/从复制信息
cpu : CPU 计算量统计信息
commandstats : Redis 命令统计信息
cluster : Redis 集群信息
keyspace : 数据库相关的统计信息
参数还可以是下面这两个：
all : 返回所有信息
default : 返回默认选择的信息
当不带参数直接调用 INFO 命令时，使用 default 作为默认参数。
```

<font style="color:rgb(82, 95, 127);"></font>

<font style="color:rgb(82, 95, 127);"></font>

**Discuz x 项目的 redis 监控**

```bash
1.准备基础目录和web站点
[root@web03 ~]# yum install mariadb-server nginx php php-fpm php-mysql php-pecl-redis -y
[root@web03 ~]# mkdir -p /code
[root@web03 ~]# cd /code/
[root@web03 code]# rz –E    #本地上传---
[root@web03 code]# unzip Discuz_X3.2_SC_UTF8.zip
[root@web03 code]# mv upload/* ./
[root@web03 code]# chmod -R 777 *
2.配置Nginx与PHP
[root@web03 conf.d]# cat /etc/nginx/conf.d/discuz.conf 
server {
        listen 80;
        root /code;
        index index.php index.html;

        location ~ \.php$ {
            root /code;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }
}
3.重启Nginx与PHP
[root@web03 conf.d]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@web03 conf.d]# systemctl reload nginx
[root@web03 conf.d]# systemctl restart php-fpm
4.创建数据库
[root@web03 conf.d]# systemctl start mariadb
[root@web03 conf.d]# mysql   #登录数据库
MariaDB [(none)]> create database bbs;   #创建数据库名称
Query OK, 1 row affected (0.00 sec)
```



5.没有开启缓存前

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-40.png)



```bash
6.安装redis-Server并配置redis
[root@web03 config]# yum install redis -y
[root@web03 config]# vim /etc/redis.conf
requirepass 123456    #在配置文件中480行，去掉注释，修改密码
[root@web03 config]# systemctl start redis
如果redis在不同的主机上，请修改监听的地址
[root@web03 config]# grep "bind" /etc/redis.conf 
# bind 192.168.1.100 10.0.0.1
bind 127.0.0.1   #默认，可以根据需求进行修改
```



7.修改discuz配置，添加redis缓存

[root@web03 ~]# vim /code/config/config_global.php

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-41.png)

8.重启php-fpm

[root@web03 ~]# systemctl restart php-fpm

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-42.png)



## [](#bvrybu)Tomcat监控
Zabbix-server->zabbix java gateway -> jvm

<font style="color:rgb(82, 95, 127);">在Zabbix中，JMX监控数据的获取由专门的代理程序来实现,</font>

<font style="color:rgb(82, 95, 127);">即Zabbix-Java-Gateway来负责数据的采集，</font>

<font style="color:rgb(82, 95, 127);">Zabbix-Java-Gateway和JMX的Java程序之间通信获取数据</font>

<font style="color:rgb(82, 95, 127);"></font>

**<font style="color:rgb(82, 95, 127);">JMX在Zabbix中的运行流程:</font>**

```bash
1.Zabbix-Server找Zabbix-Java-Gateway获取Java数据
2.Zabbix-Java-Gateway找Java程序(zabbix-agent)获取数据
3.Java程序返回数据给Zabbix-Java-Gateway
4.Zabbix-Java-Gateway返回数据给Zabbix-Server
5.Zabbix-Server进行数据展示

```

**<font style="color:rgb(82, 95, 127);">配置JMX监控的步骤:</font>**

```bash
1.安装Zabbix-Java-Gateway。
2.配置zabbix_java_gateway.conf参数。
3.配置zabbix-server.conf参数。
4.Tomcat应用开启JMX协议。
5.ZabbixWeb配置JMX监控的Java应用。

```



**<font style="color:rgb(82, 95, 127);">实践环境</font>**

| <font style="color:rgb(82, 95, 127);">服务器系统</font> | <font style="color:rgb(82, 95, 127);">角色</font> | <font style="color:rgb(82, 95, 127);">IP</font> |
| :--- | :--- | :--- |
| <font style="color:rgb(82, 95, 127);">CentOS 7.4 x86_64</font> | <font style="color:rgb(82, 95, 127);">Zabbix-Server</font> | <font style="color:rgb(82, 95, 127);">192.168.56.11</font> |
| <font style="color:rgb(82, 95, 127);">CentOS 7.4 x86_64</font> | <font style="color:rgb(82, 95, 127);">Zabbix-java-gateway</font> | <font style="color:rgb(82, 95, 127);">192.168.56.12</font> |
| <font style="color:rgb(82, 95, 127);">CentOS 7.4 x86_64</font> | <font style="color:rgb(82, 95, 127);">Zabbix-Agent</font> | <font style="color:rgb(82, 95, 127);">192.168.56.13</font> |




```bash
1.安装java以及zabbix-java-gateway (如果源码安装加上–enable-java参数)

//安装java-gateway
[root@linux-node1 ~]# yum install  zabbix-java-gateway java-1.8.0-openjdk -y

2.配置zabbix-java-gateway
vim /etc/zabbix/zabbix_java_gateway.conf

3.启动zabbix-java-gateway
[root@linux-node1 ~]# systemctl start zabbix-java-gateway
[root@linux-node1 ~]# netstat -lntup|grep 10052
tcp6       0      0 :::10052                :::*                    LISTEN      13042/java

4.修改zabbix-server 配置文件
[root@linux-node1 ~]# vim /etc/zabbix/zabbix_server.conf
#java gateway地址
JavaGateway=192.168.90.11  
#java gateway默认端口10052
JavaGatewayPort=10052
#启动进程轮询java gateway
StartJavaPollers=5

5.重启zabbix-server
[root@linux-node1 ~]# systemctl restart zabbix-server

6.安装tomcat服务
mkdir /soft/package/src -p
wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.2/bin/apache-tomcat-9.0.2.tar.gz
tar xf apache-tomcat-9.0.2.tar.gz -C /soft/
ln -s /soft/apache-tomcat-9.0.2/ /soft/tomcat

7.开启tomcat的远程jvm配置文件
[root@linux-node1 ~]# vim /usr/local/tomcat/bin/catalina.sh
CATALINA_OPTS="$CATALINA_OPTS
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=12345
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.90.11"
 
 
#jvm配置文件解释
CATALINA_OPTS="$CATALINA_OPTS
//启用远程监控JMX
-Dcom.sun.management.jmxremote
//jmx启用远程端口,Zabbix添加时必须一致
-Dcom.sun.management.jmxremote.port=12345
//不开启用户密码认证
-Dcom.sun.management.jmxremote.authenticate=false
//不启用ssl加密传输
-Dcom.sun.management.jmxremote.ssl=false
//运行tomcat主机的IP地址
-Djava.rmi.server.hostname=192.168.90.11"

7.重启tomcat服务
[root@linux-node1 ~]# /usr/local/tomcat/bin/shutdown.sh
[root@linux-node1 ~]# /usr/local/tomcat/bin/startup.sh

8.zabbix添加tomcat主机,并添加Zabbix自带java监控模板，如图4-10、图4-11、图4-12
9.查看图形，如图4-13
10.自带的监控可能无法满足企业需求,大家可以根据公司的业务定制不同的JVM监控模板。
```















# [](#g311xu)Zabbix监控-场景监控-Day04
## [](#2za1zb)Zabbix架构回顾
zabbix监控基础架构回顾

Zabbix监控方式（agent、snmp、ipmi、ssh、telnet）

Zabbix资源回顾（基于监控项基础的所有资源）

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-43.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-44.png)



## [](#d39rom)Web场景检测
_<font style="color:#FF0000;">Web网站可用性监控</font>_

    1.使用命令行实现网站的登陆（curl登陆discuz，需要关闭discuz的验证码）

    2.使用curl模拟登陆zabbix web

_<font style="color:#FF0000;">扩展知识</font>_

    静态网站： 纯静态网站就是服务器的源代码和客户端的源代码一致。

    动态网站：<?php phpinfo()?>

      每次用户访问的时候，html都是在内存中动态生成的，支持登陆，支持用户交互

      所以动态网站登陆需要有东西存下来，那么动态网站下发的是session，客户端保存的是cookie，那什么是session，什么是cookie。

     服务端下发：session	客户端保存：cookie  <font style="color:#FF0000;">演示例子：禁用IE浏览器的cookie验证。</font>



_<font style="color:#FF0000;">用户访问网站时，session和cookie是如何进行工作的。</font>_

       当用户第一次访问网站，肯定不会携带cookie信息，服务端返回网页的时候，给该用户分配一个sessionID

       当用户第二次访问网站的时候，会携带cookies访问，服务端就会通过session验证用户的cookid进行验证

       模拟登陆 curl -L -c cook -b cook -d '原始数据' 请求URL

       登陆成功后，使用curl -c cook -b cook Url 访问想访问的内容，然后追加至一个html文件中 验证是否成功



<font style="color:#FF0000;">使用命令行模拟登陆zabbix</font>

curl -L -c tt -b tt -d 'name=Admin&password=zabbix&autologin=1&enter=Sign+in' 'http://10.0.0.61/zabbix/index.php'



<font style="color:#FF0000;">使用命令行模拟登陆discuz论坛</font>

_-c -b 指定保存的cook信息_

_-d 指定登陆需要发送的用户名与密码_

curl -L -c cook -b cook -d 'fastloginfield=username&username=admin&password=1&quickforward=yes&handlekey=ls' 'http://10.0.0.9/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1'



_<font style="color:#FF0000;">模拟退出Discuz论坛</font>_

curl -L -c cook -b cook 'http://10.0.0.9/member.php?mod=logging&action=logout'



Web场景监控步骤与监控流程：

1.登陆

    2.验证

    3.退出



1.基于主机创建web监控

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-45.png)

2.监控web站点步骤

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-46.png)

3.查看详细步骤->登录

<font style="color:#FF0000;">URL</font>

http://10.0.0.9/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1

<font style="color:#FF0000;">原始发布</font>

fastloginfield=username&username=admin&password=1&quickforward=yes&handlekey=ls

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-47.png)

4. 查看详细步骤->验证是否登录成功

<font style="color:#FF0000;">URL</font>

http://10.0.0.9/home.php?mod=space&do=friend 



<font style="color:#FF0000;">原始发布</font>

fastloginfield=username&username=admin&password=1&quickforward=yes&handlekey=ls



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-48.png)

4. 查看详细步骤->退出登录

<font style="color:#FF0000;">URL</font>

[http://10.0.0.9/member.php?mod=logging&action=logout](http://10.0.0.9/member.php?mod=logging&action=logout) ![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-49.png)

5.最终访问效果



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-50.png)

## [](#gxmnre)自动发现(被动)
<font style="color:#333333;">网络发现由两个阶段组成:发现（discovery）和动作（actions）</font>

<font style="color:#333333;"></font>

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-51.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-52.png)

<font style="color:#1F2C33;"></font>

<font style="color:#1F2C33;">默认标题</font>: 自动发现主机IP:{DISCOVERY.DEVICE.IPADDRESS}

<font style="color:#1F2C33;">消息内容</font>

客户端名称: {DISCOVERY.SERVICE.NAME}

客户端端口: {DISCOVERY.SERVICE.PORT}

客户端状态: {DISCOVERY.SERVICE.STATUS}



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-53.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-54.png)



新增一台全新的主机

```bash
[root@web02 ~]# rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.12-1.el7.x86_64.rpm
[root@web02 ~]# grep "^Server" /etc/zabbix/zabbix_agentd.conf 
Server=10.0.0.61
[root@web02 ~]# systemctl restart zabbix-agent
```





16：zabbix自动发现和主动注册(重要)

    1.自动发现，自动添加监控主机，

        配置-自动发现->选择扫描的主机段

        配置->动作->事件源->自动发现->定制消息

    自动发现问题: Server每60s扫描一次小弟，资源开销厉害

## [](#xlb7xo)自动注册(主动)
1.关闭自动发现

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-55.png)

2.配置自动注册，修改Zabbix-agentd.conf的配置文件

```bash
[root@web03 ~]# vim /etc/zabbix/zabbix_agentd.conf
ServerActive=10.0.0.61
Hostname=
[root@web03 ~]# systemctl restart zabbix-agent
```

2.WEB界面配置->动作->事件源->自动注册->创建动作

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-56.png)

3.动作->名称->触发条件

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-57.png)

4.操作->操作细节->关联模板->发送消息

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-58.png)

5.注册成功

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-59.png)

## [](#bgnckt)主动模式与被动模式
<font style="color:#FF0000;">主动模式与被动模式针对的是zabbix-Agent</font>

1.被动模式 (Zabbix-server轮询检测zabbix-agent)

2.主动模式 (Zabbix-agent主动上报给Zabbix-server)



_<font style="color:#FF0000;">Zabbix主动模式与被被动模式选择</font>_

1.当Queue里有大量延迟的监控项

2.当监控主机超过300+, 建议使用主动模式。



Zabbix默认是被动模式:

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-60.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-61.png)



被动模式,100个监控,需要100个回合（注意zabbix图中的时间）

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-62.png)

主动模式,100个监控,需要1个回合





1.Zabbix-agent修改配置文件

```bash
[root@web03 ~]# vim /etc/zabbix/zabbix_agentd.conf
ServerActive=10.0.0.61
Hostname=
[root@web03 ~]# systemctl restart zabbix-agent
```

2.添加主机（自动注册）

3.Zabbix需要更新模板为Active

_1.全克隆被动模式的模板->改名->主动模式的模板_

_2.修改克隆好的模板，进行监控项的修改，修改为主动模式_

_3.主机引用，先取消被动使用的模板（取消链接并清理），然后链接新模板_

__

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-63.png)

# [](#glwbdp)Zabbix监控-Day05
## [](#ra8omx)ZabbixProxy分布式
![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-64.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-65.png)

# 16.分布式监控
**概述**

Zabbix通过Zabbix proxies为IT基础设施提供有效和可用的分布式监控代理(proxies)可用于代替Zabbix server本地收集数据，然后将数据报告给服务器**Proxy 特征**

当选择使用/不使用proxy时，必须考虑几个注意事项。

| Proxy轻量级（Lightweight） | Yes |
| --- | --- |
| 图形界面（GUI） | No |
| 独立工作（Works independently） | Yes |
| 易于维护（Easy maintenance） | Yes |
| 自动生成数据库（Automatic DB creation)1 | Yes |
| 本地管理（Local administration） | No |
| 准备嵌入式硬件（Ready for embedded hardware） | Yes |
| 单向TCP连接（One way TCP connections） | Yes |
| 集中配置（Centralised configuration） | Yes |
| 生成通知（Generates notifications） | No |




 1.监控主机多，性能跟不上，延迟大。

 2.解决跨机房

 3.解决网络不稳定



Proxy不支持图形

Proxy不支持报警

Proxy需要数据库

Proxy不能和Server装一起



**环境**

ZabbixServer-->ZabbixProxy-->ZabbixAgent

| 功能 | 外网IP | 内网IP |
| --- | --- | --- |
| zabbix-server | 10.0.0.61 | |
| zabbix-proxy	 | 10.0.0.8 | 172.16.1.8 |
| zabbix-agent	 | 10.0.0.9 | 172.16.1.9 |


```bash
1.安装zabbix-proxy
[root@web02 ~]# yum localinstall https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-proxy-mysql-3.4.12-1.el7.x86_64.rpm

2.安装Mariadb数据库
[root@web02 ~]# yum install mariadb-server –y
[root@web02 ~]# systemctl start mariadb

3.创建数据库
MariaDB [(none)]> create database zabbix_proxy default charset utf8;

							   #									库             #用户名
MariaDB [(none)]> grant all on zabbix_proxy.* to zabbix_proxy@'localhost' identified by 'zabbix_proxy';

4.导入zabbix数据
[root@web02 ~]# cd /usr/share/doc/zabbix-proxy-mysql-3.4.12/
[root@web02 zabbix-proxy-mysql-3.4.12]# zcat schema.sql.gz |mysql -uzabbix_proxy -pzabbix_proxy zabbix_proxy

5.配置zabbix-proxy
[root@web02 ~]# grep '^[a-Z]' /etc/zabbix/zabbix_proxy.conf
Server=10.0.0.61
Hostname=Zabbix proxy
DBName=zabbix_proxy
DBUser=zabbix_proxy
DBPassword=zabbix_proxy

6.启动zabbix-proxy并加入开机自启
[root@web02 ~]# systemctl enable zabbix-proxy
[root@web02 ~]# systemctl start zabbix-proxy
[root@web02 ~]# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       
tcp        0      0 0.0.0.0:10051           0.0.0.0:*               LISTEN      5561/zabbix_proxy


1.配置Zabbix-Agent
[root@web03 ~]# grep '^[a-Z]' /etc/zabbix/zabbix_agentd.conf 
Server=172.16.1.8
ServerActive=172.16.1.8
Hostname=web03

2.重启zabbix-agent
[root@web03 ~]# systemctl restart zabbix-agent

```





1.配置Zabbix-Server Web页面

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-66.png)

2.agent代理程序名称（必须与proxy配置文件中定义的Hostname一致）

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-67.png)

2.创建主机（内网网段主机）

![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-68.png)



![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-69.png)





![](img/%E5%BE%90%E4%BA%AEwei%E7%9A%84Zabbix-5%E5%A4%A9-70.png)



```bash
Proxy可优化选项
# vim /etc/zabbix/zabbix_proxy.conf
#超时时间
468:Timeout=30 
#代理将每N秒将收集的数据发送到服务器。对于处于被动模式的代理，此参数将被忽略。
254:DataSenderFrequency=20

```

## [](#nplnac)ZabbixApi[了解]
```bash
1.在使用zabbix-api之前，先获取一个token
curl -s -X POST -H 'Content-Type:application/json' -d '
{
"jsonrpc": "2.0",
"method": "user.login",
"params": {
"user": "Admin",
"password": "zabbix"
},
"id": 1
}' http://10.0.0.61/zabbix/api_jsonrpc.php

#f返回的token
4f51830c86bdffebfbc4b5a92734260c


2.禁用某一台主机
curl -s -X POST -H 'Content-Type:application/json' -d '
{
    "jsonrpc": "2.0",
    "method": "host.update",
    "params": {
        "hostid": "10289",
        "status": 1
    },
    "auth": "4f51830c86bdffebfbc4b5a92734260c",
    "id": 1
}' http://10.0.0.61/zabbix/api_jsonrpc.php

3.删除一台主机
curl -s -X POST -H 'Content-Type:application/json' -d '
{
    "jsonrpc": "2.0",
    "method": "host.delete",
    "params": [
        "10289"
    ],
    "auth": "4f51830c86bdffebfbc4b5a92734260c",
    "id": 1
}' http://10.0.0.61/zabbix/api_jsonrpc.php

4.创建主机
curl -s -X POST -H 'Content-Type:application/json' -d '
{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": "192.168.3.3",
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "192.168.3.1",
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "5"
            }
        ],
        "templates": [
            {
                "templateid": "10095"
            }
        ]
    },
    "auth": "e42a8c26b5a66826f7c3b988d53d4a9f",
    "id": 1
}' http://10.0.0.61/zabbix/api_jsonrpc.php

5.批量创建主机
[root@web02 ~]# cat  zabbix_create.sh 
#login
GetToken=$(curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0",
"method": "user.login",
"params": {
"user": "Admin",
"password": "zabbix"
},
"id": 1
}' http://10.0.0.61/zabbix/api_jsonrpc.php)

# result token
Token=$(echo $GetToken|awk -F ',' '{print $2}'|awk -F '"' '{print $4}')

while read line;do
curl -s -X POST -H 'Content-Type:application/json' -d '{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": '\"$line\"',
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": '\"$line\"',
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "2"
            }
        ],
        "templates": [
            {
                "templateid": "10001"
            }
        ]
    },
    "auth": '\"$Token\"',
    "id": 1
}' http://10.0.0.61/zabbix/api_jsonrpc.php|python -m json.tool
done < /tmp/ip.txt
```

## [](#qmk7sg)Zabbix性能优化
1)针对mysql调整，zabbix-server和mysql拆分,写多读少。

2)将被动模式修改为主动模式

3)使用zabbix-proxy分布式

4)去掉无用监控项, 增加监控项的取值间隔, 减少历史数据保存周期(housekeeper)

zabbix    40901  0.0  0.3 260356  3632 ?        S    11:20   0:00 /usr/sbin/zabbix_server: housekeeper 

[deleted 0 hist/trends, 6548 items/triggers, 134 events, 0 sessions, 0 alarms, 0 audit items in 0.262922 sec, idle for 1 hour(s)]

5)针对于zabbix-server进程调优,谁忙,就加大它的进程数量（取决实际情况，不是越大越好）

6)针对于zabbix-server缓存调优,谁的剩余内存少,就加大它的缓存值（zabbix cache usage）



