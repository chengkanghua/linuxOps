# day22 定时任务

> 本文为 Linux 定时任务（crond/crontab）课程，涵盖概念、书写流程、各种备份脚本、结果重定向、inode 耗尽案例、Java 环境变量坑等。

![定时任务](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-01.png)

## 一、什么是定时任务

定时任务 = **规则 + 脚本（命令大礼包）**，用来把重复性的工作（备份、同步时间等）交给系统自动执行。

```bash
# 定时任务软件 crond（软件包 cronie）
yum install cronie -y
rpm -qa | grep cronie            # 查询是否安装
rpm -qf `which crontab`          # 查询命令属于哪个包

# 系统级定时任务目录（按周期执行脚本）
ll -d /etc/cron.*
# /etc/cron.daily    每天
# /etc/cron.hourly   每小时
# /etc/cron.monthly  每月
# /etc/cron.weekly   每周
# /etc/cron.deny     定时任务黑名单

# 系统日志切割示例
cat /etc/cron.daily/logrotate
cat /etc/logrotate.d/syslog     # 配置要切割的日志：cron/messages/secure 等
```

### 检查定时任务运行
```bash
# 1. 是否运行
ps -ef | grep crond
# 2. 是否开机自启动
chkconfig | grep crond          # CentOS6
systemctl is-enabled crond      # CentOS7
systemctl status crond
```

## 二、定时任务书写格式与流程

```bash
# 格式：分 时 日 月 周  命令
# *  *  *  *  * user-name  command to be executed
# 分(0-59) 时(0-23) 日(1-31) 月(1-12) 周(0-6, 0=周日)

# 例子
30  08 * * *  go to school      # 每天8:30
00  00 * * *  go to bed         # 每天0:00

# 查看/编辑
crontab -l       # 查看
crontab -e       # 编辑（保存时语法错会提示 retry）
cat /var/spool/cron/root        # root 的定时任务文件
```

**书写流程**：① 命令先手动测通 → ② 写成脚本 → ③ 写入 crontab → ④ 检查（内容 + `/var/log/cron` 日志）。

```bash
# 每分钟显示自己名字追加到 /tmp/name.log
crontab -l
* * * * * echo oldboy>>/tmp/name.log

# 每2分钟同步时间
*/2 * * * * /usr/sbin/ntpdate ntp1.aliyun.com

# 时间写法
*/1 * * * *             每隔1分钟
02 * * * *              每小时第2分钟
00 07-11/2 * * * cmd    7点到11点每2小时（= 07,09,11）
```

## 三、打包备份 /etc 到 /tmp

```bash
# 1. 命令
tar zcf /tmp/etc-`date +%F`.tar.gz /etc/

# 2. 脚本
cat /server/scripts/bak-etc.sh
tar zcf /tmp/etc-`date +%F`.tar.gz /etc/
sh /server/scripts/bak-etc.sh && ll /tmp/

# 3. 定时任务（先每分钟测试，再改成每天0点）
* * * * *  /bin/sh /server/scripts/bak-etc.sh
00 00 * * *  /bin/sh /server/scripts/bak-etc.sh
```

## 四、结果定向到黑洞或文件

定时任务中命令/脚本的正确及错误输出，必须**重定向到黑洞 `(>/dev/null 2>&1)` 或追加到文件**，否则会触发邮件堆积（见案例五）。

```bash
>>/tmp/oldboy.txt 2>&1       记录执行过程
>/dev/null 2>&1   （== &>/dev/null）  丢弃执行过程
# /dev/null 是 linux 黑洞

# 示例
*/2 * * * * /usr/sbin/ntpdate ntp1.aliyun.com >/dev/null 2>&1
00 00 * * * /bin/sh /server/scripts/bak-etc.sh >/dev/null 2>&1
* * * * * date +\%F_\%T >>/tmp/time.log 2>&1     # 注意 % 需转义
```

## 五、企业案例：邮件服务关闭导致 inode 用光

```bash
You have new mail in /var/spool/mail/root

# 原因：定时任务没重定向，不断发邮件；而邮件服务(postfix)又关闭，
# 邮件堆积在 /var/spool/postfix/maildrop/ 下产生海量小文件 → inode 耗尽
# centos7 默认 postfix 是关闭的：systemctl is-enabled postfix

# 删除大量小文件（避免 rm * 参数过长）
echo {1..450000}.txt | xargs touch
ls *.txt | xargs rm
ls 1*.txt | xargs rm        # 缩小范围分批删
# 或直接删目录（先记录好权限与所有者）
```

> 结论：定时任务规则结尾务必加 `>/dev/null 2>&1` 或 `>>/tmp/oldboy 2>&1`。

## 六、Java 服务定时任务无法执行（环境变量坑）

```bash
# resin_restart.sh 定时执行报错：找不到 JDK tools.jar
# 原因：crontab 执行 shell 时只能识别少数系统环境变量，普通环境变量不识别
# 解决：在脚本里用 export 重新声明所需变量

#!/bin/sh
JAVA_HOME="/opt/jdk1.6.0_18"
CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
PATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:/opt/nginx-0.7.61/sbin:/opt/jdk1.6.0_18/bin:/opt/resin-3.0.25/bin:$PATH
export JAVA_HOME PATH USER LOGNAME MAIL HOSTNAME HISTSIZE INPUTRC CLASSPATH
/usr/local/bin/xxresin_stop.sh
/usr/local/bin/xxresin_start.sh
```

```bash
# 调试脚本执行过程
sh -x /server/scripts/bak-etc.sh
# 以 + 开头的行表示执行过程，其余为输出
```

## 七、每两小时备份配置文件（软链接坑）

```bash
# /etc/rc.local 是软链接，直接 tar 会打包失效的链接
# 加 -h 把软链接指向的源文件打包进去
tar zchf /backup/conf-`date +%F`.tar.gz /etc/rc.local /etc/hosts /etc/fstab /etc/sysconfig/
00 */2 * * * /bin/sh /server/scripts/bak-conf.sh >/dev/null 2>&1
```

## 八、按主机 IP 备份到 /backup/ip/

```bash
# 巨坑：hostname -I 结果带空格，需 awk 取第一列
ip=`hostname -I|awk '{print $1}'`
mkdir -p /backup/$ip
tar zcf /backup/$ip/etc-`date +%F`.tar.gz /etc/

cat /server/scripts/bak-etc-adv.sh
#get ip address
ip=`hostname -I|awk '{print $1}'`
mkdir -p /backup/$ip
tar zcf /backup/$ip/etc-`date +%F`.tar.gz /etc/

crontab -l
00 00 * * * /bin/sh /server/scripts/bak-etc-adv.sh 2>&1
```
> 补充：若 `hostname -i` 反应慢或带 IPv6，配置好 `/etc/hosts` 与 `/etc/resolv.conf`（DNS 改 223.5.5.5），必要时 `sysctl -w net.ipv6.conf.all.disable_ipv6=1` 临时关闭 IPv6。

## 九、综合作业：备份 + 清理 7 天前 + 保留周一

```bash
cat > /server/scripts/bak-etc.sh <<EOF
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
mkdir -p /backup
DATE=\`date +%F-%H_%w\`
tar zcf /backup/etc-"\$DATE".tar.gz /etc
find /backup/etc*.tar.gz -type f -mtime +7 ! -name "*_1.tar.gz" |xargs rm -f
EOF

crontab -e
00 00 * * * /bin/sh /server/scripts/bak-etc.sh
```
> `%w` 为周几（周一=1），命名含 `_1` 即周一备份，find 用 `! -name "*_1.tar.gz"` 排除，实现"保留每周一备份"。

## 十、脚本初体验

```bash
mkdir -p /server/scripts
cd /server/scripts
#cat show.sh
date +%F_%T

#ll show.sh
-rw-r--r-- 1 root root 13 Aug  8 12:25 show.sh
#sh show.sh
2018-08-08_12:27:46
```

![定时任务练习](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-02.png)
![练习](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-03.png)
![练习](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-04.png)
![练习](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-05.png)
![练习](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-06.jpeg)
![练习](img/day22%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1-07.png)

> 更新: 2026-04-23 21:52:04
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/xk021r>
