# 01 Linux系统日志管理

# 01 Linux系统日志管理

* [系统日志架构概述](http://kt.xuliangwei.com/15172886347374.html#toc_0)
* [syslog日志审查](http://kt.xuliangwei.com/15172886347374.html#toc_1)
* [Journal日志审查](http://kt.xuliangwei.com/15172886347374.html#toc_2)
* [Journal日志持久化](http://kt.xuliangwei.com/15172886347374.html#toc_3)
* [日志轮询logrotate](http://kt.xuliangwei.com/15172886347374.html#toc_4)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 系统日志架构概述

在rhel7系统中有两个日志服务，分别是传统的`rsyslog`和新添加的`systemd-journal`

`systemd-journald`是一个改进型的日志管理服务，可以收集来自内核、系统早期的启动阶段的日志、系统守护进程在启动和运行中的标准输出和错误信息，还有`syslog`的日志。 

该日志服务仅仅把日志集中保存在单一结构化的日志文件`/run/log`默认情况下并不会持久化保存日志, 每次重启后, 之前的日志都会丢失。另外，一些`rsyslog`无法收集的日志也会被`jounral`记录到。

rsyslog作为传统的系统日志服务，把所有收集到的日志都记录到/var/log/目录下的各个日志文件中。常见的日志文件如下:

> /var/log/messages 绝大多数的系统日志都记录到才文件
>
> /var/log/secure 所有跟安全和认证授权等日志都会记录到此文件
>
> /var/log/maillog 邮件服务的日志
>
> /var/log/cron crond计划任务的日志
>
> /var/log/boot.log 系统启动的相关日志

## syslog日志审查

```plain
rsyslog.conf
syslog日志类型
syslog日志的属性：
emerg       //内核崩溃
alert       //
crit        //
err         //错误
warnning    //警告
nice        //
info        //
debug       //
看懂简单的日志设定规则
分析日志字段
手工发送日志logger
[root@xuliangwei ~]# logger -p authpriv.info -t "test" "Err"
[root@xuliangwei ~]# tail -n1 /var/log/secure
Mar 18 21:37:04 xuliangwei test: Err
```

## Journal日志审查

这是`systemd`自带的日志服务工具所有日志记录到`/run/log`文件中, 必须使用如下命令才可打开

```plain
# journalctl  查看所有的日志
# journalctl -n 5 查看最后5条日志
# journalctl -p err 查看err类型的日志
# journalctl -f 不断输出最后10条日志
# journalctl --since today 查看今天的日志
# journalctl --since "2014-02-10 20:30:00"  --until "2014-02-13 12:00:00"
# journalctl -o verbose  查看日志的详细信息
# journalctl _SYSTEMD_UNIT=sshd.service _PID=1182
```

## Journal日志持久化

持久化保存`journal`的日志,默认只会保存一个月的日志

```plain
# mkdir /var/log/journal
# chown root:systemd-journal /var/log/journal
# chmod 2755 /var/log/journal
# killall -USR1 systemd-journald
```

## 日志轮询logrotate

> 更新: 2019-03-20 19:57:10  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/wt93cv>