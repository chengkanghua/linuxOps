# Linux 定时任务

> 你每天是怎么起床的？有人靠闹钟，有人靠梦想。服务器也一样——到点就要自动干活，全靠 Linux 的定时任务。本篇就来聊清楚：什么是定时任务、crond 服务怎么工作、如何用 `at` 和 `crontab` 配置任务，以及生产环境里的书写规范和排错思路。

## 本章目录

- 一、什么是计划任务
- 二、crond 定时任务服务应用
- 三、为什么需要 crond 定时任务
- 四、Linux 下的定时任务软件
- 五、定时任务与邮件服务
- 六、配置 QQ 邮箱为发件服务器
- 七、定时任务 cron 实践
- 八、crontab 命令
- 九、定时任务语法格式
- 十、定时任务书写规范流程
- 十一、生产环境用户配置定时任务流程
- 十二、定时任务综合实战案例
- 十三、取消定时任务发邮件功能
- 十四、补充 anacron

## 一、什么是计划任务

**计划任务**：在后台运行，到了预定时间就会自动执行的任务，前提是事先手动把计划设定好。常见用途有：

- 周期性任务执行
- 清空 /tmp 目录下的内容
- MySQL 数据库备份
- Redis 数据备份

这些工作都可以交给 crond 服务来完成。

### 检查 crond 服务相关的软件包

用 `rpm -qa |grep cron` 看看系统里和 cron 相关的软件包装了哪些：

```plain
[root@MiWiFi-R3-srv ~]# rpm -qa |grep cron
cronie-anacron-1.4.11-14.el7.x86_64        
crontabs-1.11-6.20121102git.el7.noarch     
cronie-1.4.11-14.el7.x86_64    #定时任务主程序包，提供crond守护进程等工具
rpm -ivh  安装rpm软件
rpm -qa 查看软件是否安装
rpm -ql 查看软件详细信息s
rpm -qf 查看命令属于的安装包
rpm -e  卸载软件
```

### 检查 crond 服务是否运行

不同 CentOS 版本查看服务状态的命令略有不同：

```plain
systemctl status crond.service  #centos7
service crond status    #centos6
```

## 二、crond 定时任务服务应用

在正式学习之前，先分清三个长得很像的名字：

| 名字 | 含义 |
| --- | --- |
| `cron` | 定时任务服务软件的名字 |
| `crond` | 定时任务的守护进程名 |
| `crontab` | 管理定时任务的命令 |

Cron 是 Linux 系统中以后台进程模式、周期性执行命令或指定程序的服务软件。

系统启动后 cron 软件随即启动，对应的进程名叫做 crond。它默认每分钟检查一次系统中是否有需要执行的任务计划，有就按计划执行，就像我们平时用的闹钟。

- crond 定时任务默认最快的频率是**每分钟**执行一次。
- 如果需要秒级的计划任务，crond 就不适用了，应编写 shell 脚本实现。

下面是一个秒级任务的 shell 脚本示例，循环里 `sleep 1`，每秒打印一句话：

```plain
#秒级shell脚本
[root@pylinux tmp]# cat test_cron.sh
#!/bin/bash
while true
do
echo "超哥还是强呀"
sleep 1
done
```

运行 `sh test_cron.sh` 后，屏幕上每隔一秒就会打印一行"超哥还是强呀"，按 `Ctrl+C` 可以停止脚本。

## 三、为什么需要 crond 定时任务

运维工作中有大量"必须做、但又不想熬夜守着做"的事情：

- 夜间数据库定时备份
- 夜间网站数据（用户上传、文件、图片、程序）备份
- 备份等待时间过长
- 任务重复性高

利用 Linux 的定时任务 cron 工具，就可以解决这些重复性、周期性的自动备份等运维工作。

## 四、Linux 下的定时任务软件

### at：只执行一次的任务

`at` 定时任务工具依赖于 `atd` 服务，适用于执行一次就结束的调度任务。

例如突发任务：某天夜里 3 点需要临时性备份一次数据，就可以使用 at 软件。

at 支持的时间写法如下：

```plain
语法
HH:MM
YYYY-mm-dd
noon    正午中午12点
midnight    午夜晚12点
teatime    下午茶时间，下午四点
tomorrow    明天
now+1min  #一分钟之后
now+1minutes/hours/days/weeks
```

下面演示一分钟之后执行 `ls /data`，以及如何查看、读取文件、删除任务：

```plain
一分钟之后运行ls /opt
at now+1min
[root@chaogelinux ~]# at  now+1min        #ctrl+d提交任务
at> ls /data
at> <EOT>
job 2 at Thu Nov 21 10:38:00 2019
运行之后，通过邮件检查
[root@chaogelinux ~]#
您在 /var/spool/mail/root 中有新邮件
[root@chaogelinux ~]# mail  #通过mail，检查at的任务结果
#检查定时任务
at -l  #列出等待中的作业
#通过文件交互式读取任务，不用交互式输入
[root@chaogelinux data]# cat mytasks.at
echo "chaoge 666"
[root@chaogelinux data]# at -f ./mytasks.at now+3min
job 5 at Thu Nov 21 10:51:00 2019
#删除任务
at -d 6
atrm 6  #效果一样
```

### cron：周期性任务

`cron` 定时任务依赖于 `crond` 服务，启动 `crond服务后`，通过 Linux 命令 `crontab` 就可以配置周期性定时任务，是 Linux 运维最常用的工具。

## 五、定时任务与邮件服务

任务计划触发执行后，会把执行结果通过邮件发送给用户。注意这不是互联网上的邮件，而是**系统内部的邮件服务**。

下面是检查并启动系统邮件服务的步骤（CentOS 5 是 sendmail，CentOS 6、7 是 postfix）：

```plain
1.检查服务器端口，25号邮件端口是否打开,centos5是sendmail，centos6、7是postfix服务
ss -tnl |grep 25
netstat -tnl |grep 25
2.发现未启动25端口的话，则需要启动postfix服务，用于发送邮件
首先更改postfix配置文件
    vim /etc/postfix/main.cf
修改如下参数
  inet_interfaces = all
  inet_protocols = all
3.启动postfix服务
systemctl start postfix
```

### 本地电子邮件服务

更多邮件协议的概念可以参考网易邮箱的说明：[网易邮箱邮件协议解释](http://help.163.com/09/1223/14/5R7P6CJ600753VB8.html)

常见的三个邮件协议：

```plain
smtp：simple mail transmission protocol
    pop3：Post Office Procotol
    imap4：Internet Mail Access Procotol
```

学习邮件服务前，先了解两个概念：

| 缩写 | 全称 | 含义 |
| --- | --- | --- |
| MTA | Mail Transport Agent | 邮件传送代理，也就是 `postfix` 服务 |
| MUA | Mail User Agent | 收发邮件的客户端，可以是 `foxmail`，也可以是其他客户端 |

CentOS 7 通过 `mailx` 命令发送邮件，通过 `mail` 命令接收邮件。

### mailx 命令

下面给系统用户 chaoge 发送一封邮件，`-s` 指定主题，正文结束后单独输入一个点并回车提交：

```plain
[root@chaogelinux ~]# mailx -s "hello chaoge" chaoge    # 给chaoge系统用户发送邮件，-s 添加主题
hi chaoge,how are you?    #文章内容
.        #输入点，退出邮件
EOT    #结束符号，end out
```

### mail 命令查看邮件

切换到 chaoge 用户，执行 `mail` 命令就能看到刚才那封新邮件，在 `&` 提示符后输入邮件编号即可查看对应邮件：

```plain
[root@chaogelinux ~]# su - chaoge
[chaoge@chaogelinux ~]$ mail
Heirloom Mail version 12.5 7/5/10. Type ? for help.
"/var/spool/mail/chaoge": 1 message 1 new
>N  1 root                  Thu Nov 21 09:42  18/645   "hello chaoge"
& 1
Message  1:
From root@chaogelinux.localdomain  Thu Nov 21 09:42:19 2019
Return-Path: <root@chaogelinux.localdomain>
X-Original-To: chaoge
Delivered-To: chaoge@chaogelinux.localdomain
Date: Thu, 21 Nov 2019 09:42:19 +0800
To: chaoge@chaogelinux.localdomain
Subject: hello chaoge
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
From: root@chaogelinux.localdomain (root)
Status: R

hi chaoge,how are you?
&
```

邮件内容里各个字段的含义对照如下：

| 字段 | 含义 |
| --- | --- |
| `From` / `Return-Path` | 发信人是谁 |
| `X-Original-To` / `Delivered-To` / `To` | 收信的目标人（也可以抄送给其他人）及收信人地址 |
| `Date` | 邮件发送时间 |
| `Subject` | 邮件标题 |
| `User-Agent` | 发信人使用的工具（这里是 mailx） |
| `Content-Type` | 邮件编码格式 |
| 末尾正文 | 邮件正文内容 |

看完邮件后，按 `q` 退出：

```plain
& q
Held 1 message in /var/spool/mail/chaoge
You have mail in /var/spool/mail/chaoge
```

### 非交互式发邮件

除了交互式写邮件，也可以让命令从文本文件中读取正文。下面用 chaoge 用户给 root 回一封邮件：

```plain
[chaoge@chaogelinux ~]$ echo "I fine,thank you root,and you?" > fine.txt
[chaoge@chaogelinux ~]$
[chaoge@chaogelinux ~]$ mail -s "hello root" root < fine.txt
[chaoge@chaogelinux ~]$ logout
您在 /var/spool/mail/root 中有邮件
[root@chaogelinux ~]# mail
```

## 六、配置 QQ 邮箱为发件服务器

除了系统内部邮件，还可以配置外部邮箱（QQ、163 等）作为发件服务器，让定时任务把结果发到互联网邮箱。完整配置和证书处理过程如下：

```plain
配置qq 为发件服务器
[root@ckh ~]# cat /etc/mail.rc
# 这里填入smtp地址，这里的xxx为qq或者163
set smtp=smtps://smtp.qq.com:465
# 认证方式
set smtp-auth=login
# 这里输入邮箱账号
set smtp-auth-user=chengkanghua@foxmail.com
# 这里填入密码，这里是授权码而不是邮箱密码
set smtp-auth-password=frsrbsyivlsmbgef
# 忽略证书警告
set ssl-verify=ignore
# 证书所在目录
set nss-config-dir=/etc/pki/nssdb
# 设置发信人邮箱和昵称
set from=chengkanghua@foxmail.com

# 发邮件
echo 'test '|mail -s 'hello qq' 343264992@163.com

邮件发送成功了但是提示报错
Error in certificate: Peer's certificate issuer has been marked as not trusted by the
#1忽略证书警告 改成 严格按照证书要求
sed -i 's/ignore/strict/g' /etc/mail.rc
#2获取邮件服务器证书
echo   -n " " |  openssl s_client -connect smtp.qq.com:465 | sed -ne  '/-BEGIN CERTIFICATE-/,/-END CERTIFIICATE-/p'  >  /etc/pki/nssdb/qq.crt
#3把证书添加到受信任表
certutil    -A    -n   'qq'    -t    "P,P,P"    -d    /etc/pki/nssdb    -i    /etc/pki/nssdb/qq.crt

具体参数解释 :
##-A :表示添加
##-n :nickname  昵称，比如qq,163
##--t:表示受信任的标签，可取值/t/c/p都可以
##-d:证书在的目录
##-i:证书文件的具体位置

#再次测试发送邮件
echo 'end  '|mail -s 'test not error' 343264992@163.com

```

> ⚠️ `smtp-auth-password` 填的是邮箱的**授权码**，不是邮箱登录密码；授权码需要在邮箱设置里单独开启 SMTP 服务后获取。

## 七、定时任务 cron 实践

向 crond 进程提交任务的方式与 at 不同：crond 需要读取配置文件，且有固定的文件格式，配置文件通过 crontab 命令来管理。

cron 任务分为**系统定时任务**和**用户定时任务**两类。

### 系统定时任务

crond 服务工作时，除了会查看 `/var/spool/cron` 目录下的定时任务文件以外，还会查看 `/etc/cron.d` 目录以及 `/etc/anacrontab` 里的文件内容，里面存放着每天、每周、每月需要执行的系统任务。

```plain
[root@pylinux ~]# ls -l /etc/|grep cron*
-rw-------.  1 root  root      541 4月  11 2018 anacrontab
drwxr-xr-x.  2 root  root     4096 8月  30 11:08 cron.d        #系统定时任务
drwxr-xr-x.  2 root  root     4096 8月   8 2018 cron.daily    #每天的任务
-rw-------.  1 root  root        0 4月  11 2018 cron.deny
drwxr-xr-x.  2 root  root     4096 8月   8 2018 cron.hourly    #每小时执行的任务
drwxr-xr-x.  2 root  root     4096 6月  10 2014 cron.monthly    #每月的定时任务
-rw-r--r--   1 root  root      507 5月  10 2019 crontab
drwxr-xr-x.  2 root  root     4096 6月  10 2014 cron.weekly    #每周的定时任务
```

系统定时任务的配置文件是 `/etc/crontab`，内容如下：

```plain
[root@chaogelinux data]# cat /etc/crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin        #路径信息很少，因此定时任务用绝对路径
MAILTO=root            #执行结果发送邮件给用户
# For details see man 4 crontabs
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
#每一行，就是一条周期性任务
user-name 是以某一个用户身份运行任务
command to be executed  任务是什么
```

> 💡 注意配置文件里的 `PATH` 只有寥寥几个目录，比我们登录后的 PATH 短得多。所以定时任务里的命令**推荐写绝对路径**，否则可能出现"手动能执行、定时任务里却报 command not found"的问题。

### 用户定时任务计划

当系统管理员（root）或普通用户（chaoge）创建了需要定期执行的任务，可以使用 `crontab` 命令配置。

crond 服务启动后，会每分钟查看 `/var/spool/cron` 路径下以**系统用户名**命名的定时任务文件，以确定是否有需要执行的任务。

```plain
#root用户有一个定时任务文件
[root@pylinux ~]# ls -l /var/spool/cron/
总用量 4
-rw------- 1 root root 141 10月  9 14:42 root
#查看此root定时任务文件的内容
[root@pylinux ~]# cat /var/spool/cron/root
*/1 * * * * /usr/local/qcloud/stargate/admin/start.sh > /dev/null 2>&1 &
0 0 * * * /usr/local/qcloud/YunJing/YDCrontab.sh > /dev/null 2>&1 &
#等同于如下命令
[root@pylinux ~]# crontab -l
*/1 * * * * /usr/local/qcloud/stargate/admin/start.sh > /dev/null 2>&1 &
0 0 * * * /usr/local/qcloud/YunJing/YDCrontab.sh > /dev/null 2>&1 &
```

## 八、crontab 命令

crontab 命令用来提交和管理用户需要周期性执行的任务，和 Windows 下的计划任务类似。

| 参数 | 解释 | 使用示例 |
| --- | --- | --- |
| -l | list查看定时任务 | crontab -l |
| -e | edit编辑定时任务，建议手动编辑 | crontab -e |
| -i | 删除定时任务，提示用户确认删除，避免出错 | crontab -i |
| -r | 删除定时任务，移除/var/spool/cron/username文件，全没了 | crontab -r |
| -u user | 指定用户执行任务，root可以管理普通用户计划任务 | crontab -u chaoge -l |

crontab 命令本质上就是在修改 `/var/spool/cron` 中的定时任务文件。

> ⚠️ `crontab -r` 会把当前用户的整个定时任务文件删掉、一条不留，手滑代价很大。日常查看用 `-l`、编辑用 `-e` 即可。

### 查看与编辑定时任务

```plain
crontab -l #列出用户设置的定时任务，等于cat var/spool/cron/root
crontab -e  #编辑用户的定时任务，等于如上命令编辑的是 vi /var/spool/cron/root文件
```

### 检查 crond 服务是否运行

```plain
[root@pylinux ~]# systemctl is-active crond
active
[root@pylinux ~]# ps -ef|grep crond
root       711     1  0 10月20 ?      00:00:01 /usr/sbin/crond -n
```

### 定时任务相关的文件

```plain
/var/spool/cron  定时任务的配置文件所在目录
/var/log/cron  定时任务日志文件
/etc/cron.deny  定时任务黑名单
```

crond 的一举一动都会记录在 `/var/log/cron` 里。下面是一段定时任务日志，每行依次记录了**时间**、**哪个用户的定时任务**、**执行了什么命令/脚本**：

```plain
[root@oldboyedu-39-nb tmp]# tail /var/log/cron
Aug  8 11:32:32 oldboyedu-39-nb crontab[49887]: (root) BEGIN EDIT (root)
Aug  8 11:36:13 oldboyedu-39-nb crontab[49887]: (root) REPLACE (root)
Aug  8 11:36:13 oldboyedu-39-nb crontab[49887]: (root) END EDIT (root)
Aug  8 11:36:16 oldboyedu-39-nb crontab[49891]: (root) LIST (root)
Aug  8 11:37:01 oldboyedu-39-nb crond[1628]: (root) RELOAD (/var/spool/cron/root)
Aug  8 11:37:01 oldboyedu-39-nb CROND[49893]: (root) CMD (/usr/sbin/ntpdate ntp1.aliyun.com )
Aug  8 11:38:01 oldboyedu-39-nb CROND[49903]: (root) CMD (/usr/sbin/ntpdate ntp1.aliyun.com )
```

其中 `BEGIN EDIT / REPLACE / END EDIT / LIST` 对应手动编辑和查看动作，`CMD` 则表示任务被真正执行了。

## 九、定时任务语法格式

定时任务的口诀是：**什么时候做什么事**。

可以先查看系统定时任务配置文件，对照它的格式来写：

```plain
[root@luffycity ~]# cat /etc/crontab
```

配置文件中前五个时间字段依次是：分钟、小时、日期、月份、周几，最后是要执行的命令。周日可以用 0 或 7 表示。前半段决定"什么时间执行"，后半段决定"执行什么命令/脚本"。

| 列 | 含义 | 取值范围 |
| --- | --- | --- |
| 第 1 列 | 分钟 minute | 0 - 59 |
| 第 2 列 | 小时 hour | 0 - 23 |
| 第 3 列 | 日期 day of month | 1 - 31 |
| 第 4 列 | 月份 month | 1 - 12，也可写 jan、feb、mar、apr … |
| 第 5 列 | 周几 day of week | 0 - 6（Sunday=0 或 7），也可写 sun、mon、tue … |

先用两个生活化的例子感受一下：

```plain
每天上午8点30，去上学
30 08 * * *  go to school
每天晚上12点回家回家睡觉
00 00  *  * *  go home
```

定时任务各列的详细说明如下：

```plain
crontab任务配置基本格式：
*  *　 *　 *　 *　　command
分钟(0-59)　小时(0-23)　日期(1-31)　月份(1-12)　星期(0-6,0代表星期天)　 命令
第1列表示分钟1～59 每分钟用*或者 */1表示
第2列表示小时1～23（0表示0点）
第3列表示日期1～31
第4列表示月份1～12
第5列标识号星期0～6（0表示星期天）
第6列要运行的命令
（注意：day of month和day of week一般不同时使用）
（注意：day of month和day of week一般不同时使用）
（注意：day of month和day of week一般不同时使用）
```

> 📌 日期（day of month）和星期（day of week）一般不同时设置，否则规则会变得难以预测。

时间的表示方法有两种：

- **特定值**：时间点有效取值范围内的某个具体值。
- **通配符**：某时间点有效范围内的所有值，表示"每"的意思。

| 特殊符号 | 含义 |
| --- | --- |
| `*` | 星号，表示"每"的意思，如 `00 23 * * * cmd` 表示每月每周每日的 23:00 整点执行命令 |
| `-` | 减号，表示时间范围分隔符，如 `17-19`，代表每天的 17、18、19 点 |
| `,` | 逗号，表示分隔时段，如 `30 17,18,19 * * * cmd` 表示每天 17、18、19 点的半点执行命令 |
| `/n` | n 表示可以整除的数字，每隔 n 个单位时间执行一次，如每隔 10 分钟表示 `*/10 * * * * cmd` |

再多看几个示例，对照注释体会每个符号的作用：

```plain
0 * * * *   每小时执行，每小时的整点执行
1 2 * * 4   每周执行，每周四的凌晨2点1分执行
1 2 3 * *   每月执行，每月的3号的凌晨2点1分执行
1 2 3 4 *    每年执行，每年的4月份3号的凌晨2点1分执行
1 2 * * 3,5   每周3和周五的2点1分执行
* 13,14 * * 6,0  每周六、周日的下午1点和2点的每一分钟都执行
0 9-18 * * 1-5   周一到周五的每天早上9点一直到下午6点的每一个整点(工作日的每个小时整点)
*/10 * * * *  每隔10分钟执行一次任务
*7 * * * *    如果没法整除，定时任务则没意义,可以自定制脚本控制频率
定时任务最小单位是分钟，想完成秒级任务，只能通过其他方式（编程语言）
```

## 十、定时任务书写规范流程

生产环境里写定时任务，推荐遵循"命令行测试 → 编写脚本 → 测试脚本 → 编辑 crontab → 调试"的流程，调试通过才算完成，不通过就回去排错：

```text
开始
  │
  ▼
命令行测试 ──► 编写脚本 ──► 测试脚本 ──► 编辑 crontab ──► 调试
                                                    ├─ YES ──► 完成
                                                    └─ NO ───► 排错 ──► 回到调试
```

每个阶段的具体规范如下。

### 1. 命令行测试

| 注意事项 |
| --- |
| 使用命令的全路径 |

### 2. 编写脚本

| 脚本书写规范 |
| --- |
| 定时任务推荐用脚本执行 |
| 命令全路径复制到脚本中 |
| 创建指定的脚本目录 /server/scripts |
| 不要随意输出信息，输出到文件或空设备（tar zcf；echo >a.log） |
| 打包时切换到上级目录打包 |

### 3. 测试脚本

| 测试规范 |
| --- |
| 查看脚本 cat 一下 |
| 执行脚本用 /bin/sh |
| 执行的脚本要使用绝对路径 |

### 4. 编辑 crontab

| crontab 书写规范 |
| --- |
| 加上注释 what who why when（4W） |
| 不要求输出就定向到 >/dev/null 2>&1 |
| 在指定用户下执行相关定时任务，不要什么都给 root，可以使用 -u |
| 推荐使用 crontab -e，有语法检查功能 |
| crontab -l 检查定时任务 |
| 最新的放在最上面 |

避免出错的小技巧：复制之前正确的 /bin/sh 脚本全路径；每一个步骤都要尽量复制；定时任务、脚本、命令都用绝对路径。

### 5. 调试与排错

| 类型 | 方法 |
| --- | --- |
| 调试（不能用于生产环境） | 增加执行任务的频率来调试任务；调整系统时间调试任务 |
| 调试（日志方式） | 脚本里面把输出定向到文件；通过 cron 日志 /var/log/cron 调试 |
| 排错 | 注意环境变量导致的定时任务故障；命令里的百分号需要转义 `\%` |

> ⚠️ cron 中 `%` 有特殊含义（表示换行），命令里要用到百分号时必须写成 `\%`，这是非常常见的定时任务故障点。

### 案例 1

```plain
*/1 * * * * /bin/sh  /scripts/data.sh      #每分钟执行命令
30 3,12 * * *  /bin/sh  /scripts/data.sh  #每天的凌晨3点半，和12点半执行脚本
30 */6 * * *    /bin/sh  /scripts/data.sh     #每隔6小时，相当于6、12、18、24点的半点时刻，执行脚本
30 8-18/2  * * * /bin/sh  /scripts/data.sh  #  30代表半点，8-18/2表示早上8点到下午18点之间每隔两小时也就是8、10、12、14、16、18的半点时刻执行脚本
30 21 * * *  /opt/nginx/sbin/nginx -s reload  #每天晚上9点30重启nginx
45 4 1,10 * *  /bin/sh  /scripts/data.sh   #每月的1、10号凌晨4点45执行脚本
10 1  * 6,0  /bin/sh  /scripts/data.sh   #每周六、周日的凌晨1点10分执行命令
0,30 18-23 * * *  #每天的18点到23点之间，每隔30分钟执行一次
00 */1 * * *  /bin/sh  /scripts/data.sh   #每隔一小时执行一次
00 11 * 4 1-3 /bin/sh  /scripts/data.sh        #4月份的周一到周三的上午11点执行脚本
```

### 案例 2

```plain
# 每天早上7点到上午11点，每2小时运行cmd命令
00 07-11/2 * * * CMD
0 6 * * * /var/www/test.sh        #每天6点执行脚本
0 4 * * 6 /var/www/test.sh    #每周六凌晨4:00执行
5 4 * * 6 /var/www/test.sh    #每周六凌晨4:05执行
40 8 * * * /var/www/test.sh    #每天8:40执行
31 10-23/2 * * *    /var/www/test.sh    #在每天的10:31开始，每隔2小时重复一次
0 2 * * 1-5 /var/www/test.sh    #每周一到周五2:00
0 8,9 * * 1-5  /var/www/test.sh   #每周一到周五8:00，每周一到周五9:00
0 10,16 * * *  /var/www/test.sh   #每天10:00、16:00执行
```

## 十一、生产环境用户配置定时任务流程

需求：每分钟向 `/testcron/hellochaoge.txt` 文件中写入一句话"超哥带你学linux"。

### 第一步：先在命令行测试，确保任务能正确执行

新手尤其要注意，切莫编写完定时任务就不管不问了。先手动执行命令验证，比如目标目录不存在时，追加写入会直接报错：

```plain
[root@pylinux ~]# echo "超哥带你学linux" >> /testcron/hellochaoge.txt
-bash: /testcron/hellochaoge.txt: 没有那个文件或目录
[root@pylinux ~]# mkdir /testcron
[root@pylinux ~]# echo "超哥带你学linux" >> /testcron/hellochaoge.txt
[root@pylinux ~]# cat /testcron/hellochaoge.txt
超哥带你学linux
```

稍不小心就会出错——目标文件夹必须先存在。

### 第二步：编辑定时任务文件，写入需要定时执行的任务

```plain
crontab -e 
写入
* * * * * /usr/bin/echo "超哥带你学linux" >> /testcron/hellochaoge.txt
保存后
[root@pylinux ~]# crontab -e
crontab: installing new crontab
```

### 第三步：检查定时任务

```plain
[root@pylinux ~]# crontab -l
* * * * * /usr/bin/echo "超哥带你学linux" >> /testcron/hellochaoge.txt
```

### 第四步：实时检测文件内容

用 `tail -f` 盯着文件，正常情况下每分钟会多出一行：

```plain
tail -f /testcron/hellochaoge.txt
```

## 十二、定时任务综合实战案例

### 案例一：每 5 分钟让服务器进行时间同步

```plain
crontab -e 
*/5 * * * * /usr/sbin/ntpdate  ntp1.aliyun.com &> /dev/null
```

### 案例二：每晚 0 点整，把站点目录 /var/www/html 打包备份到 /data

提醒：tar 命令不建议使用绝对路径打包，特殊情况可以使用 -P 参数。

先检查目录、创建测试文件，再手动执行打包命令：

```plain
1.检查文件夹是否存在，不存在则创建
[root@pylinux ~]# ls -d /var/www/html /data
ls: 无法访问/var/www/html: 没有那个文件或目录
ls: 无法访问/data: 没有那个文件或目录
2.创建文件夹
[root@pylinux ~]# mkdir -p /var/www/html  /data
[root@pylinux ~]# ls -d /var/www/html /data
/data  /var/www/html
3.创建测试文件
[root@pylinux ~]# touch /var/www/html/chaoge{1..10}.txt
[root@pylinux ~]# ls /var/www/html/
chaoge10.txt  chaoge1.txt  chaoge2.txt  chaoge3.txt  chaoge4.txt  chaoge5.txt  chaoge6.txt  chaoge7.txt  chaoge8.txt  chaoge9.txt
4.打包压缩命令
[root@pylinux www]# tar -zcvf /data/bak_$(date +%F).tar.gz  ./html/
```

打包时先 `cd` 到站点的上级目录 `/var/www`，对 html 文件夹打包压缩，结果放在 /data 目录下并以当天日期命名。执行过程会逐个列出被打包的文件，完成后在 /data 下能看到带日期的压缩包：

```plain
[root@pylinux ~]# cd /var/www/
[root@pylinux www]# ls
html
[root@pylinux www]# pwd
/var/www
[root@pylinux www]# tar -zcvf /data/bak_$(date +%F).tar.gz ./html/
./html/
./html/chaoge5.txt
./html/chaoge4.txt
./html/chaoge8.txt
./html/chaoge1.txt
./html/chaoge6.txt
./html/chaoge2.txt
./html/chaoge9.txt
./html/chaoge10.txt
./html/chaoge3.txt
./html/chaoge7.txt
[root@pylinux www]# ls -l /data
总用量 4
-rw-r--r-- 1 root root 229 11月 11 14:55 bak_2019-11-11.tar.gz
```

### 编写 shell 脚本，交给定时任务定期执行

把打包动作写成脚本，避免在 crontab 里写一长串命令：

```plain
[root@pylinux scripts]# cat bak.sh
#!/bin/bash
cd /var/www && \
/bin/tar -zcf /data/bak_$(date +%F).tar.gz ./html
```

### 创建定时任务

```plain
crontab -e
写入
00 00 * * * /bin/sh  /server/scripts/bak.sh > /dev/null 2>&1
#解释 >/dev/null 2>&1 代表把所有输出信息重定向到黑洞文件
> 是重定向符号
/dev/null是黑洞文件
2>&1 代表让标准错误和标准输出一样
此命令表示将脚本执行的正常或者错误日志都重定向到/dev/null，也就是什么都不输出
>/dev/null 2>&1 等价于  1>/dev/null 2>/dev/null  等价于 &> /dev/null
```

## 十三、取消定时任务发邮件功能

如果不想让任务每次执行都发邮件，可以把输出重定向到黑洞设备，两种写法的区别如下：

```plain
1.定时任务的命令 >  /dev/null   #命令的执行正确结果输出到黑洞，标准错误还是报错
2.定时任务的命令 &>  /dev/null  #组合符  &> 正确和错误的输出，都写入黑洞，危险命令，有风险，慎用
```

## 十四、补充 anacron

如果由于机器故障关机，定时任务没能按时执行，下次开机后 cron 也**不会补执行**这些任务。

使用 anacron，下次开机会扫描定时任务，把关机期间未执行的任务全部补执行一遍。服务器一般很少关机重启，所以日常运维中了解即可。

---

> 更新: 2023-01-11 11:26:32  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/oa6eke>
