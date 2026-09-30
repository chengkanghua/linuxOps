# day 62 zabbix04

day 62 zabbix04

1.怎么看他所有的状态信息，了解状态信息指标都是什么意思 2.怎么获取对应的状态信息，

硬件监控（IPMI监控） 系统监控（CPU、内存、磁盘、网络） Linux、Windows 应用监控（Nginx PHP-FPM MySQL Redis Tomcat） WEB监控 （）

应用监控（Nginx PHP-FPM MySQL Redis Tomcat）

## Nginx
```plain
1.Nginx的状态信息在哪里能看到
[root@web02 conf.d]# cat status.conf
server {
listen 80;
server_name _;
location /nginx_status {
stub_status;
access_log off;
allow 127.0.0.1;
deny all;
}
}
2.Nginx的状态信息值如何取
[root@web02 conf.d]# curl 127.0.0.1/nginx_status
Active connections: 1
server accepts handled requests
1 1 1
Reading: 0 Writing: 1 Waiting: 0
3.取出accepts、handled、requests
accepts            curl -s 127.0.0.1/nginx_status|awk 'NR==3{print $1}'
handled            curl -s 127.0.0.1/nginx_status|awk 'NR==3{print $2}'
requests           curl -s 127.0.0.1/nginx_status|awk 'NR==3{print $NF}'
#############
nginx_status.sh
#############
4.脚本存放的位置
[root@web02 ~]# mkdir -p /etc/zabbix/zabbix_agentd.d/scripts
[root@web02 ~]# cd /etc/zabbix/zabbix_agentd.d/scripts
[root@web02 scripts]# rz #上传nginx配置文件
[root@web02 scripts]# chmod +x nginx_status.sh
5.如何自定义监控项
[root@web02 conf.d]# cd /etc/zabbix/zabbix_agentd.d/
[root@web02 zabbix_agentd.d]# cat nginx.conf
UserParameter=nginx_status[*],/usr/bin/bash /etc/zabbix/zabbix_agentd.d/scripts/nginx_status.sh "$1"
6.通过zabbix_get获取zabbix-agent上的监控项
[root@zabbix-server ~]# zabbix_get -s 172.16.1.8 -k nginx_status[accepts]
10
7.导入nginx对应的模板，然后关联主机
1.配置->模板->导入
2.关联主机->等待获取对应的值
3.模板已经准备好了图形，所以可通过图形查看对应的报表
[root@web02 scripts]# ab -n10000 -c200 http://127.0.0.1/nginx_status
```

## Nginx日志中的状态码 200 301 302 404 403 500 502 504
```plain
日志中存在对应的状态码
1.编写取值脚本
[root@web02 zabbix_agentd.d]# cat scripts/nginx_log.sh
#!/usr/bin/bash
awk -vS=$1 '{if($9==S) sum++}END{print sum}' /var/log/nginx/access.log
2.自定义监控项
[root@web02 zabbix_agentd.d]# cat nginx.conf
UserParameter=nginx_status[*],/usr/bin/bash /etc/zabbix/zabbix_agentd.d/scripts/nginx_status.sh "$1"
UserParameter=nginx_log[*],/usr/bin/bash /etc/zabbix/zabbix_agentd.d/scripts/nginx_log.sh "$1"
[root@web02 zabbix_agentd.d]# systemctl restart zabbix-agent
3.在zabbix-server上取值测试
[root@zabbix-server ~]# zabbix_get -s 172.16.1.8 -k nginx_log[404]
20283
4.在web界面创建模板，然后挨个添加监控项，添加图形，最后对应主机引用该模板
```

#####  如果有很多台相同的主机，都需要监控nginx的状态  
 1.所有的主机都需要开启Nginx的状态模块  
 2.每台服务器的脚本都一样（取状态值）  
 3.每台服务器的自定义监控项名称都一样  
 4.每台服务器可以使用相同的模板

## php怎么监控，php-fpm
```plain
1.PHP-FPM工作模式通常与Nginx结合使用,修改php-fpm.conf
[root@Agent ~]# vim /etc/php-fpm.d/www.conf
pm.status_path = /phpfpm_status
[root@Agent ~]# systemctl restart php-fpm
2.修改nginx.conf的配置文件,增加如下location访问PHP-FPM状态信息。
location ~ /phpfpm_status {
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
process manager         #进程管理方式dynamic或者static
start time              #启动日志,如果reload了fpm，时间会更新
start since             #运行时间
accepted conn           #当前池接受的连接数
listen queue            #请求等待队列,如果这个值不为0,那么需要增加FPM的进程数量     （长时间大于0）
max listen queue        #请求等待队列最高的数量
listen queue len        #socket等待队列长度
idle processes          #空闲进程数量0        （空闲持续多长时间0则报警）
active processes        #活跃进程数量200
total processes         #总进程数量200
max active processes    #最大的活跃进程数量（FPM启动开始计算）
max children reached    #最大数量限制的次数，如果这个数量不为0，那说明你的最大进程数量过小,可以适当调整。
slow requests           # 超过5s在执行，这就算慢
1.取值
curl -s http://127.0.0.1/phpfpm_status|grep "$1"|awk '{print $NF}'
2.定义监控项
[root@web02 zabbix_agentd.d]# cat php.conf
UserParameter=fpm[*],curl -s http://127.0.0.1/phpfpm_status|grep ^"$1":|awk '{print $NF}'
3.zabbix-server获取对应的监控项
[root@zabbix-server ~]# zabbix_get -s 172.16.1.8 -k fpm["accepted conn"]
50077
[root@zabbix-server ~]# zabbix_get -s 172.16.1.8 -k fpm["listen queue"]
[root@zabbix-server ~]# zabbix_get -s 172.16.1.8 -k fpm["idle processes"]
4.web界面添加模板，模板添加监控项，基于监控项创建触发器，触发则发送邮件报警。画一个图形出来。
触发器
1.当空闲的进程数为0 或 队列大于0，持续1分钟，则报警 ，练习多条件表达式
{Fpm Status:fpm["idle processes"].avg(1m)}=0 or {Fpm Status:fpm["listen queue"].avg(1m)}>30
5.模拟故障 ab -n10000 -c200 http://127.0.0.1/phpfpm_status
```

## #####Redis 监控（内存数据库）
```plain
1.软件支持打印自身的状态信息(info)
2.取值
3.添加监控项
4.web界面添加模板，模板添加监控项，基于监控项创建触发器，触发则发送邮件报警。画一个图形出来。
[root@web02 zabbix_agentd.d]# yum install redis -y
[root@web02 zabbix_agentd.d]# systemctl start redis
redis-cli客户端工具，info是一个命令(打印redis当前的状态信息)
端口监听上6379
[root@web02 zabbix_agentd.d]# redis-cli  info
connected_clients:1
used_memory_human:794.38K
used_memory_rss_human:5.65M
http://www.yanglixun.com/?p=176
MySQL 监控
1.使用percona工具来监控MySQL
2.需要安装percona
1.脚本{2个，1个php脚本，是用来连接mysql数据库的，2个脚本调用php取数据库的状态信息}
2.conf配置文件
3.web页面模板
1.前置条件System Requirements
Zabbix agent, php, php-mysql packages on monitored node.
1.在Zabbix-Agent端安装percona Monitoring Plugins
[root@Agent ~]#  yum install -y  https://www.percona.com/downloads/percona-monitoring-plugins/percona-monitoring-plugins-1.1.8/binary/redhat/7/x86_64/percona-zabbix-templates-1.1.8-1.noarch.rpm
2.检查软件安装的路径
[root@db01 ~]# rpm -ql percona-zabbix-templates
/var/lib/zabbix/percona
/var/lib/zabbix/percona/scripts    #脚本存放的位置
/var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh
/var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php
/var/lib/zabbix/percona/templates
/var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf  #监控项配置文件
/var/lib/zabbix/percona/templates/zabbix_agent_template_percona_mysql_server_ht_2.0.9-sver1.1.8.xml
3.修改配置，填写数据库的用户名和密码【mysql -uroot -pBgx123.com】
[root@db01 ~]# vim /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php
$mysql_user = 'root';
$mysql_pass = 'Bgx123.com';
4.执行脚本测试是否能取值
[root@db01 ~]# sh /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh gg
6
5.自定义监控项
[root@db01 ~]# cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /etc/zabbix/zabbix_agentd.d/
[root@db01 ~]# systemctl restart zabbix-agent
6.使用zabbix-server取值
[root@zabbix-server ~]# zabbix_get -s 172.16.1.51 -k MySQL.Key-read-requests
rm: 无法删除"/tmp/localhost-mysql_cacti_stats.txt": 不允许的操作
6
7.导入模板，并且关联mysql对应的主机
```

应用监控（Rsync、NFS）  
 监控的方法  
 1.判断软件是否支持自带的info信息（查找你需要监控的指标，取值）  
 2.编写监控项（监控项名称是自定义，具体的命令，可以是脚本，也可以是命令）  
 3.通过zabbix_get获取对应的值，测试  
 4.在ZabbixWEb页面添加监控项->应用级->模板  
 5.调用对应的主机->添加对应的监控模板

作业：视频  
 0.Rsync、NFS、Nginx、PHP、MySQL

```plain
1. 2台web(Nginx+PHP)、1台MySQL、1台NFS、1台Rsync（所有的.conf监控项一样，模板不一样）
1.自定义监控项、自定义触发器、自定义动作
2.如何制作模板，模板的导出与导入
#####
使用Ansible统一
安装Zabbix-Agent
配置Zabbix-Agent
推送所有的脚本
推送所有的.conf文件
```



> 更新: 2019-01-12 21:38:56  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/mcvuev>