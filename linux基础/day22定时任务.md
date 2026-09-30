# day22定时任务

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- day22 定时任务
- # 什么是定时任务
- 定时任务书写流程
- 每天晚上12点打包备份/etc目录到/tmp下面 脚本
- [](https://www.yuque.com/chengkanghua/oldboy50/lcguis#v0s7qf)定时任务中-命令或脚本结果(正确及错误)定向到黑洞(>/dev/null 2>&1)或追加到文件中
- 【企业案例】由于定时任务书写不规范（邮件服务关闭）引发的inode 用光了
- linux定时任务生产java服务无法执行问题群友案例
- [](https://www.yuque.com/chengkanghua/oldboy50/lcguis#z706ri)每两个小时打包备份 /etc/rc.local /etc/hosts /etc/fstab /etc/sysconfig 备份到/backup目录 脚本
- 每天晚上12点打包备份/etc/目录 备份到 /backup下面  备份到/backup/当前主机 ip 地址
- 定时任务作业：
- 脚本初体验

![1546509885122-be023efa-26a8-46b5-85ef-899b162e2781.png](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-01.png)

# # 什么是定时任务


```bash
1备份
2其他重复性工作： 同步时间
规则+脚本（命令大礼包）
crond(crontab) 定时任务软件（软件包cronie）

yum install cronie –y
#查询软件是否安装
rpm -qa | grep cronie

# 显示软件包相关信息
#rpm -ql cronie

# 查询命令属于那个软件包
#rpm -qf `which crontab`

# 卸载
rpm –e 包名

系统的定时任务(日志切割)
#ll /var/log/messages* /var/log/secure*


[root@oldboy01 ~]#ll -d /etc/cron.*
drwxr-xr-x. 2 root root 4096 Jul 17 19:09 /etc/cron.d
drwxr-xr-x. 2 root root 4096 Jul 17 19:10 /etc/cron.daily     每天
-rw-------. 1 root root    0 Aug 24  2016 /etc/cron.deny	    定时任务黑名单
drwxr-xr-x. 2 root root 4096 Jul 17 19:09 /etc/cron.hourly    每小时
drwxr-xr-x. 2 root root 4096 Jul 17 19:09 /etc/cron.monthly   每月
drwxr-xr-x. 2 root root 4096 Sep 27  2011 /etc/cron.weekly		每周
[root@lnb ~]# cat /etc/cron.daily/logrotate 
#!/bin/sh
/usr/sbin/logrotate /etc/logrotate.conf
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
fi
exit 0
[root@oldboyedu50-lnb ~]# cat /etc/logrotate.d/syslog 
/var/log/cron
/var/log/maillog
/var/log/messages
/var/log/secure
/var/log/spooler
{
    sharedscripts
    postrotate
/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
    endscript
}

# 查看定时任务list
#crontab -l
no crontab for root

# 编辑定时任务
#crontab -e

#cat /var/spool/cron/root  #root用户的定时任务


检查定时任务是否运行？
1 是否正在运行   
ps -ef |grep crond
ps aux | grep crond
2 是否开机自启动   
chkconfig |grep crond 
/etc/init.d/crond status
service crond status

# centos7 如下命令
systemctl is-enabled crond
systemctl status crond




定时任务配置文件格式：
什么时候  做什么
分 时 日 月 周
# cat /etc/crontab

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed


每天的上午8点30分 ，去学校上车
30  08 *  *  *  go to school
每天晚上12点准时 ，回家自己开车
00  00  *  *   *  go to bed




```







# 定时任务书写流程
```bash
1. 命令
2. 书写定时任务
3. 检查
  a. 检查文件内容
  b. 检查定时任务日志less /var/log/cron

#crontab –e   //编辑定时任务
crontab: installing new crontab
"/tmp/crontab.o8hh9F":2: bad day-of-week  // 语法错误
errors in crontab file, can't install.
Do you want to retry the same edit? cat
Enter Y or N

每分钟显示自己名字追加到 /tmp/name.log 中
[root@oldboy01 ~]#crontab –l     // 查看任务列表
* * * * * echo oldboy>>/tmp/name.log
[root@oldboy01 ~]#cat /tmp/name.log
oldboy


每2分钟同步下系统时间
*/2 * * * * ntpdate ntp1.aliyun.com
#crontab -l
* * * * * echo oldboy>>/tmp/name.log
*/2 * * * * /usr/sbin/ntpdate ntp1.aliyun.com

#tail -5 /var/log/cron
Aug  8 00:58:01 oldboy01 CROND[27075]: (root) CMD (echo oldboy>>/tmp/name.log)
Aug  8 00:58:01 oldboy01 CROND[27076]: (root) CMD (/usr/sbin/ntpdate ntp1.aliyun.com)
Aug  8 11:28:35 oldboy01 CROND[27082]: (root) CMD (echo oldboy>>/tmp/name.log)
Aug  8 11:28:35 oldboy01 CROND[27083]: (root) CMD (/usr/sbin/ntpdate ntp1.aliyun.com)
Aug  8 11:28:35 oldboy01 crontab[27089]: (root) LIST (root)


*/1 * * * *  每隔一分钟
02 * * * *   每小时的第2分钟

每天的上午7点到上午11点 每2小时运行CMD命令
00 07-11/2 * * * cmd
00 07,09,11 * * * cmd

备份：
流量低谷期（人少的时候）
1 凌晨半夜
2 游戏 直播 （早上5 - 6）

#23点到7点每个小时每分钟 执行一个
*  23,00-07/1 * * * /application/nginx/sbin/nginx -s reload
#23点到7点整点都执行一个
00 23,00-07/1 * * * /application/nginx/sbin/nginx -s reload
```



# 每天晚上12点打包备份/etc目录到/tmp下面 脚本
```bash
##1.命令
# tar zcf  /tmp/etc-`date +%F`.tar.gz  /etc/
# ll /tmp/etc-2018-08-0*  #检查文件

##2.书写脚本
# cat /server/scripts/bak-etc.sh
tar zcf  /tmp/etc-`date +%F`.tar.gz  /etc/
# sh /server/scripts/bak-etc.sh   #测试脚本
# ll /tmp/  #检查文件
-rw-r--r-- 1 root root 9734062 Aug  9 09:41 etc-2018-08-09.tar.gz

##3.书写定时任务-每分钟执行
# crontab -l
# 每分钟执行 backup etc  oldboy at 2018xxxxxx
* * * * *  /bin/sh /server/scripts/bak-etc.sh

##4.检查并根据要求把定时任务时间修改过来
# ll /tmp/
-rw-r--r-- 1 root root 9734062 Aug  9 09:44 etc-2018-08-09.tar.gz
# crontab -l
# 明天0点0分执行 backup etc  oldboy at 2018xxxxxx
00 00 * * *  /bin/sh /server/scripts/bak-etc.sh

```



# [](https://www.yuque.com/chengkanghua/oldboy50/lcguis#v0s7qf)定时任务中-命令或脚本结果(正确及错误)定向到黑洞(>/dev/null 2>&1)或追加到文件中


```bash
# 方法
>>/tmp/oldboy.txt 2>&1
>/dev/null 2>&1        ==&>/dev/null         ====  1>/dev/null   2>/dev/null    
/dev/null   linux黑洞  执行过程不想看

>>/tmp/oldboy.txt 2>&1 ==&>>/tmp/oldboy.txt  ====  1>>/tmp/oldboy.txt  2>>/tmp/oldboy.txt 记录着执行过程

# crontab -l
##print name  oldboy at 2018xxxxx
#* * * * *  echo oldboy  >>/tmp/name.log 2>&1 
#sync time   oldboy  at 2018xxxxx
*/2 * * * * /usr/sbin/ntpdate  ntp1.aliyun.com >/dev/null 2>&1
#backup etc  oldboy at 2018xxxxxx
00 00 * * *  /bin/sh /server/scripts/bak-etc.sh >/dev/null 2>&1
#show time
* * * * *  date +\%F_\%T  >>/tmp/time.log 2>&1


```

         



# 【企业案例】由于定时任务书写不规范（邮件服务关闭）引发的inode 用光了
```bash
提示有一封新邮件？
You have new mail in /var/spool/mail/root
原因： 定时任务中没有追加到文件或定向到空
1.定时任务不断给你发送邮件
You have new mail in /var/spool/mail/root

2.邮件软件关闭 ， 定时任务不断给你发送邮件 存放在邮件的临时目录 等待发送
#关闭邮件服务contos6   # centos7 里默认就是关闭的: systemctl is-enabled postfix 
# /etc/init.d/postfix  stop  
# chkconfig postfix off 
#定时任务书写不规范 邮件服务又关闭
#定时任务会存放存放临时文件里
ll /var/spool/postfix/maildrop/ | head
定时任务存放邮件的历史目录会不断的创建小文件
inode用光了 定时任务书写不规范导致的

定时任务中-命令或脚本结果(正确及错误)定向到黑洞(>/dev/null 2>&1)或
追加到文件中 >>/tmp/oldboy.txt 2>&1
	


【企业案例】如果定时任务规则结尾不加>/dev/null 2>&1或者追加到文件中>>/tmp/oldboy 2>&1，
很容易导致硬盘inode空间被占满，从而系统服务不正常。
如何删除大量小文件
		echo {1..450000}.txt|xargs touch
		ls *.txt |xargs rm
		ls *.txt |xargs -n数字 rm
		- 缩小范围一点点删除
			ls 1*.txt |xargs rm
		- 删除目录
			记录好目录权限和所有者


#每分钟显示当前系统的ip地址和系统的时间 追加到/tmp/ip.log中
1.定时任务
2.脚本内容

#命令    
#cat /server/scripts/ip.sh
ifconfig eth0|awk -F'[ :]+' 'NR==2{print $4}'
date
#crontab -l
* * * * * /bin/sh /server/scripts/ip.sh>>/tmp/ip.log  2>&1




  
```



# linux定时任务生产java服务无法执行问题群友案例


```bash
# http://oldboy.blog.51cto.com/2561410/1541515

1）我写了一个重启resin的脚本，由于业务原因，需要定时在某一个时间重启下resin服务器，
于是就在crontab里配置了如下内容：
50 17 * * 1-5 root /usr/local/bin/resin_restart.sh
其中，resin_restart.sh内容如下：
#!/bin/sh
/usr/local/bin/xxresin_stop.sh
/usr/local/bin/xxresin_start.sh

2）有问题的时刻到来了，服务器虽然定时起来了，但是却报了如下错误：
Resin can't load com.sun.tools.javac.Main.  Usually this means that the JDK tools.jar is missing from the classpath,
possibly because of using a JRE instead of the JDK. 
You can either add tools.jar to the classpath or change the compiler to an external one with <java compiler='javac'/> or jikes.
但是，明明已经在profile里配置了环境变量，为啥还找不到呢。折腾了需求没有搞定。

3) 咨询大牛得到答案:
由于export变量问题导致：具体为，crontab执行shell时只能识别为数不多的系统环境变量，
普通环境变量一般是无法识别的，如果在编写的脚本中需要使用变量，最好使用export重新声明下该变量，
以确保脚本正确执行。以后作为一个开发基本规范写上。

4）然后我在resin重启脚本里重新定义了下环境变量，脚本如下：
#!/bin/sh
#下面就是环境变量定义
JAVA_HOME="/opt/jdk1.6.0_18"
CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
PATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:/opt/nginx-0.7.61/sbin:/opt/jdk1.6.0_18/bin:/opt/resin-3.0.25/bin:$PATH
export JAVA_HOME PATH USER LOGNAME MAIL HOSTNAME HISTSIZE INPUTRC CLASSPATH
/usr/local/bin/xxresin_stop.sh
/usr/local/bin/xxresin_start.sh

5）经过测试，定时任务此时顺利重启
-----------------------------------


# cat  /server/scripts/bak-etc.sh 
#!/bin/bash
cd / && tar zcf  /tmp/etc-`date +%F`.tar.gz  etc/

# #调试：显示脚本的执行过程
# sh -x  /server/scripts/bak-etc.sh 
+ cd /
++ date +%F
+ tar zcf /tmp/etc-2018-08-09.tar.gz etc/
# #以+开头的行 表示执行过程 
# #不是以+开头的行 显示/输出



```



# [](https://www.yuque.com/chengkanghua/oldboy50/lcguis#z706ri)每两个小时打包备份 /etc/rc.local /etc/hosts /etc/fstab /etc/sysconfig 备份到/backup目录 脚本


```bash
#巨坑   /etc/rc.local 是软链接文件  
#软链接打包后 链接失效
# tar 选项 zchf  +h  打包的就是源文件了
tar zchf  /backup/conf-`date +%F`.tar.gz   /etc/rc.local  /etc/hosts /etc/fstab  /etc/sysconfig/

#backup conf
00 */2 * * *  /bin/sh  /server/scripts/bak-conf.sh >/dev/null 2>&1



```



# 每天晚上12点打包备份/etc/目录 备份到 /backup下面  备份到/backup/当前主机 ip 地址
```bash

# 把hostname -I 结果放入到ip变量中 创建一个叫ip地址.log的文件
# echo `hostname -I`.log
10.0.0.3 .log #有个空格

# 巨坑hostname –I  结果有个空格  解决|awk ‘{print $1}’

# ip=`hostname -I|awk '{print $1}'`
# echo $ip.log
10.0.0.200.log

# -i 对应的主机名 对应的ip  ipv6地址也会输出  需要配置好/etc/hosts
echo `hostname -i`.log
10.0.0.3.log



hostname -i #如果有ipv6地址也会输出 
# 临时关闭ipv6地址
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
# 永久关闭ipv6地址
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
# hostname -i 反应慢,原因配置了一个繁忙的dns地址
# 修改 vi /etc/resolv.conf 成   223.5.5.5  dns地址


2.命令结果存放在变量中
ip=`hostname -I|awk '{print $1}'`
mkdir -p /backup/$ip
tar zcf /backup/$ip/etc.tar.gz   /etc/
tar zcf /backup/$ip/etc-`date  +%F`.tar.gz   /etc/

#书写脚本
# cat /server/scripts/bak-etc-adv.sh
#get ip address
ip=`hostname -I|awk '{print $1}'`
#mkdir && backup
mkdir -p /backup/$ip
tar zcf /backup/$ip/etc-`date  +%F`.tar.gz   /etc/

#crontab -l
00 00 * * * /bin/sh /server/scripts/bak-etc-adv.sh 2>&1


```







# 定时任务作业：


```bash
每天晚上12点打包备份/etc/目录
1.打包备份到/backup目录
2.删除7天之前的备份
3.保留每周1的备份


cat > /server/scripts/bak-etc.sh <<EOF
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
mkdir -p /backup
DATE=`date +%F-%H_%w`
tar zcf /backup/etc-"$DATE".tar.gz /etc
find /backup/etc*.tar.gz -type f -mtime +7 !-name "*_1.tar.gz" |xargs rm -f
EOF

crontab -e
00 00 * * * /bin/sh /server/scripts/bak-etc.sh


```



















![1546510445362-77549c4e-73f8-4272-a8cd-3f85211c49d7.png](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-02.png)







# 脚本初体验
```bash
mkdir -p /server/scripts
cd /server/scripts
#cat show.sh
date +%F_%T

#ll show.sh
-rw-r--r-- 1 root root 13 Aug  8 12:25 show.sh
#sh show.sh
2018-08-08_12:27:46
#/bin/sh show.sh
2018-08-08_12:28:36

```









![1546509901676-e04bc521-a613-4007-a569-1a8d3d658c72.png](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-03.png)



![1546509921506-934be3cc-1fe5-4fbf-88a0-e7abf2ec37c5.png](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-04.png)



![1546509937852-56a8df11-4bd4-46cc-ab62-7dbddc9949cb.png](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-05.png)







![1553423236704-b29c9b06-09fd-40d5-bdcb-6b8d448afa95.jpeg](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-06.jpeg)



![1553423236910-32daaf2d-e37f-47dd-9cac-a835102dad99.png](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-07.png)



> 更新: 2026-04-23 21:52:04  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/xk021r>