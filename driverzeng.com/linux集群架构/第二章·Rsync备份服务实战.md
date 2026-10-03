# 第二章·Rsync 备份服务实战

## Rsync基本概述

rsync是一款开源、快速、多功能、可实现**全量及增量**的本地或**远程数据同步**备份的优秀工具。rsync软件适用于Unix/linux/Windows等多种操作系统平台。

| Rsync简介 |
| :--- |

rsync英文称为remote synchronizetion，从软件的名称就可以看出来，rsync具有可使本地和远程两台主机之间的数据快速复制同步镜像、远程备份的功能，这个功能**类似&#x4E8E;****ssh****&#x5E26;的sc&#x70;****命令，但是又优于scp****&#x547D;令的功能，sc&#x70;****每次都是全量拷贝，而rsync****&#x53EF;以增量拷贝**。当然，rsync还可以在本地主机的不同分区或目录之间全量及曾量的复制数据，这又类似cp命令。但是同样也优于cp命令，cp每次都是全量拷贝，而rsync可以增量拷贝。

在同步数据的时候，默认情况下，rsync通过其独特的“quick check”算法，它仅同步大小或者最后修改时间发生变化的文件或目录，当然也可根据权限、属主等属性的变化同步，但是需要制定相应的参数，甚至可以实现只同步一个文件里有变化的内容部分，所以，可是实现快速的同步备份数据。

*rsync官方地址：*[*TP*](http://rsync.samba.org/)\_\
\_\_rsync监听端口：873\
\_*rsync运行模式：C/S*

***

**小提示：利用rsync还可以实现删除文件和目录的功能，这又相当于rm命令，一个rsync相当于scp、cp、rm，但是还优于他们的每一个命令。**

***

| Rsync的特性 |
| :--- |

支持拷贝特殊文件，如连接文件、设备等。

可以有排除指定文件或目录同步的功能，相当于打包命令tar的排除功能。

可以做到保持原文件或目录的权限、时间、软硬链接、属主、组等所有属性均不改变 –p。

可以实现增量同步，既只同步发生变化的数据，因此数据传输效率很高（tar-N）。

可以使用rcp、rsh、ssh等方式来配合传输文件（rsync本身不对数据加密）。

可以通过socket（进程方式）传输文件和数据（服务端和客户端）\*\*\*\*\*。

支持匿名的活认证（无需系统用户）的进程模式传输，可以实现方便安全的进行数据备份和镜像。

***

| 生产场景架构集群备份方案 |
| :--- |

1.借助cron+rsync把所有客户服务器数据同步到备份服务器。

2.针对公司重要数据备份混乱状况和领导提出备份全网数据的解决方案。

3.通过本地打包备份，然后rsync结合inotify应用把全网数统一备份到一个固定存储服务器，然后在存储服务器上通过脚本检查并报警管理员备份结果。

4.定期将IDC机房的数据 备份公司的内部服务器，防止机房地震及火灾问题导致数据丢失。

5.实时同步，解决存储服务器等的单点问题。

***

| 备份类型介绍 |
| :--- |

>  
>
> 完全备份
>
> 增量备份

*假设客户端上有*`_file1 file2 file3_`*文件，服务端上有*`_file1_`*文件，现要将客户端上的数据备份至服务端*

<!-- OCR_START -->
- file1
- file2
- file3
<!-- OCR_END -->

*全量备份，将客户端所有的数据内容*`_file1 file2 file3_`*全部备份至服务端 (效率低下, 占用空间)*

<!-- OCR_START -->
- file2
- file1
- file3
- 增量备份
- 服务端
- ferzeng.com
<!-- OCR_END -->

*增量备份，将客户端的*`_file2 file3_`*增量备份至服务端 (提高备份效率,节省空间, 适合异地备份 )*

## Rsync的应用场景

| Rync的数据同步模式 |
| :--- |

*1.推: 所有主机推送本地数据至Rsync备份服务器，会导致数据同步缓慢(适合少量数据备份)*

<!-- OCR_START -->
- Rsync应用场景-推（上传）
- WebServer
- 接收
- Rsync备份服务
<!-- OCR_END -->

*2.拉: rsync备份服务端拉取所有主机上的数据，会导致备份服务器开销大*

<!-- OCR_START -->
- Rsync应用场景-拉（下载）
- WebServer
- 接收
- Rsync备份服务
- WebShttps://www.driverzeng.com
<!-- OCR_END -->

*3.大量服务器备份场景*

<!-- OCR_START -->
- Rsync应用场景-多Server备份
- ①：客户端推送至备份源1（上传）
- ②：客户端推送至备份源2（上传）
- WebServer
- 备份源2
- 备份源1
- ③：备份源3定时拉取备份源1-2（下载）
- https://www备i源zeng.com
<!-- OCR_END -->

*4.异地备份实现思路*

<!-- OCR_START -->
- Rsync应用场景-异地备份场景
- ①:推(上传）
- ③：拉（下载）
- WebServer
- 同步
- 本地备份
- 云端备份
<!-- OCR_END -->

## Rsync传输模式

| Rsync使用三种主要的数据传输方式 |
| :--- |

\_本地方式\
\_\_远程方式\
\_*守护进程*

***

| 本地传输方式 |
| :--- |

单个主机本地之间的数据传输(此时类似于`cp`命令)

```bash
#本地拷贝数据命令
Local:  rsync [OPTION...] SRC... [DEST]
#本地拷贝数据示例
[root@backup ~]# rsync  -avz  /etc/passwd  /tmp/
rsync       #备份命令(cp)
[options]   #选项
SRC...      #本地源文件
[DEST]      #本地目标文件
```

***

| 远程传输方式 |
| :--- |

通过`ssh`通道传输数据,类似`scp`命令

```bash
#pull拉取数据命令
Pull: rsync [OPTION...] [USER@]HOST:SRC... [DEST]
#pull拉取数据示例
[root@backup ~]# rsync -avz root@172.16.1.41:/etc/hostname ./   #拉取远程文件
[root@backup ~]# rsync -avz root@172.16.1.41:/root/ /backup/   #拉取远程目录下的所有文件
[root@backup ~]# rsync -avz root@172.16.1.41:/root /backup/    #拉取远程目录以及目录下的所有文件
Pull        #拉取, 下载
rsync       #备份命令
[options]   #选项
[USER@]     #目标主机的系统用户
HOST        #目主机IP地址或域名
SRC...      #目标主机源文件
[DEST]      #下载至本地哪个位置
     
#push推送数据命令
Push: rsync [OPTION...] SRC... [USER@]HOST:DEST
#push推送数据示例
rsync -avz /backup/2018-10-01 root@172.16.1.41:/tmp/
Push        #推送, 上传
rsync       #备份命令
[options]   #选项
SRC...      #本地源文件
[USER@]     #目标主机的系统用户
HOST        #目主机IP地址或域名
[DEST]      #目标对应位置
```

`Rsync`借助`SSH`协议同步数据存在的缺陷

>  
>
> 1.使用系统用户（不安全）
>
> 2.使用普通用户（会导致权限不足情况）

***

| 守护进程传输方式 |
| :--- |

`rsync`自身非常重要的功能(不使用系统用户，更加安全)

```bash
#pull拉取数据命令
Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST]
#1.拉取rsync备份服务的"backup模块"数据至本地/mnt目录
[root@nfs01 ~]# rsync -avz rsync_backup@192.172.16.1.41::backup/ /mnt/ --password-file=/etc/rsync.password
rsync           #命令
[OPTION...]     #选项
[USER@]         #远程主机用户(虚拟用户)
HOST::          #远程主机地址  
SRC...          #远程主机模块(不是目录)
[DEST]          #将远程主机数据备份至本地什么位置     
#push推送数据命令
Push: rsync [OPTION...] SRC... [USER@]HOST::DEST
#2.将本地/mnt目录推送至rsync备份服务器的backup模块
[root@nfs01 ~]# rsync -avz /mnt/ rsync_backup@192.172.16.1.41::backup/ --password-file=/etc/rsync.password
rsync           #命令
[OPTION...]     #选项
SRC...          #远程主机模块(不是目录)
[USER@]         #远程主机用户(虚拟用户)
HOST::          #远程主机地址
[DEST]          #将远程主机模块备份至本地什么位置
```

***

| Rsync命令对应选项 |
| :--- |

```bash
-a           #归档模式传输, 等于-tropgDl
-v           #详细模式输出, 打印速率, 文件数量等
-z           #传输时进行压缩以提高效率
-r           #递归传输目录及子目录，即目录下得所有目录都同样传输。
-t           #保持文件时间信息
-o           #保持文件属主信息
-p           #保持文件权限
-g           #保持文件属组信息
-l           #保留软连接
-P           #显示同步的过程及传输时的进度等信息
-D           #保持设备文件信息
-L           #保留软连接指向的目标文件
-e           #使用的信道协议,指定替代rsh的shell程序
--exclude=PATTERN   #指定排除不需要传输的文件模式
--exclude-from=file #文件名所在的目录文件
--bwlimit=100       #限速传输
--partial           #断点续传
--delete            #让目标目录和源目录数据保持一致
--password-file=xxx #使用密码文件
```

## Rsync服务实践

| 主机角色 | 外网IP(WAN) | 内网IP(LAN) | 主机名称 |
| :--- | :--- | :--- | :--- |
| Rsync服务端 | 10.0.0.41 | 172.16.1.41 | backup |
| Rsync客户端 | 10.0.0.31 | 172.16.1.31 | nfs |

***

| 安装Rsync |
| :--- |

```bash
[root@backup ~]# yum -y install rsync
```

***

| 配置Rsync |
| :--- |

```bash
[root@backup ~]# cat /etc/rsyncd.conf
uid = rsync
gid = rsync
port = 873
fake super = yes
use chroot = no
max connections = 200
timeout = 600
ignore errors
read only = false
list = false
auth users = rsync_backup
secrets file = /etc/rsync.passwd
log file = /var/log/rsyncd.log
#####################################
[backup]
comment = welcome to oldboyedu backup!
path = /backup
--- 配置详解
[root@backup ~]# vim /etc/rsyncd.conf
uid = rsync                      # 运行进程的用户
gid = rsync                      # 运行进程的用户组
port = 873                       # 监听端口
fake super = yes                 # 无需让rsync以root身份运行，允许接收文件的完整属性
use chroot = no                  # 禁锢推送的数据至某个目录, 不允许跳出该目录
max connections = 200            # 最大连接数
timeout = 600                    # 超时时间
ignore errors                    # 忽略错误信息
read only = false                # 对备份数据可读写
list = false                     # 不允许查看模块信息
auth users = rsync_backup        # 定义虚拟用户，作为连接认证用户
secrets file = /etc/rsync.passwd # 定义rsync服务用户连接认证密码文件路径
[backup]                # 定义模块信息
comment = commit        # 模块注释信息
path = /backup          # 定义接收备份数据目录
```

***

| 创建用户 |
| :--- |

创建一个用来运行rsync服务的用户身份

```bash
#1) 创建rsync账户，不允许登录不创建家目录
[root@backup ~]# useradd -M -s /sbin/nologin rsync
#2) 创建备份目录(尽可能磁盘空间足够大),授权rsync用户为属主
[root@backup ~]# mkdir /backup
[root@backup ~]# chown -R rsync.rsync /backup/
```

***

| 虚拟用户配置 |
| :--- |

创建虚拟用户密码文件, 授权600安全权限(用于客户端连接时使用的用户)

```bash
[root@backup ~]# echo "rsync_backup:zls" >/etc/rsync.passwd
[root@backup ~]# chmod 600 /etc/rsync.passwd
```

***

| 进程管理 |
| :--- |

启动rsync服务，并将rsync加入开机自启动

```bash
[root@backup ~]# systemctl start rsyncd
[root@backup ~]# systemctl enable rsyncd
```

***

| 检查端口 |
| :--- |

```bash
[root@backup ~]# netstat -lntup
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:873             0.0.0.0:*               LISTEN      4758/rsync
```

***

| 客户端配置 |
| :--- |

`Rsync`客户端仅需配置虚拟用户的密码,并授权为600安全权限

```bash
# 方式一：适合终端执行指定用户密码文件
[root@nfs01 ~]# yum install rsync -y
[root@nfs01 ~]# echo "zls" > /etc/rsync.pass
[root@nfs01 ~]# chmod 600 /etc/rsync.pass
# 方式二：脚本中使用，强烈推荐方式
[root@nfs01 ~]# export RSYNC_PASSWORD=zls
```

***

| 实战一 |
| :--- |

客户端推送backup目录下所有内容至`Rsync`服务端

```bash
[root@nfs01 ~]# export RSYNC_PASSWORD=zls
[root@nfs01 ~]# rsync -avz /backup/ rsync_backup@172.16.1.41::backup/
```

***

| 实战二 |
| :--- |

客户端拉取`Rsync`服务端 backup模块数据至本地客户端的 /backup目录

```bash
[root@nfs01 ~]# export RSYNC_PASSWORD=zls
[root@nfs01 ~]#rsync -avz rsync_backup@172.16.1.41::backup /backup/
```

***

| 实战三 |
| :--- |

`Rsync`实现数据无差异同步

```bash
#拉取远端数据：远端与本地保持一致,远端没有本地有会被删除, 造成客户端数据丢失
[root@nfs01 ~]# export RSYNC_PASSWORD=zls
[root@nfs01 ~]# rsync -avz --delete rsync_backup@172.16.1.41::backup/ /data/
#推送数据至远端：本地与远端保持一致, 本地没有远端会被删除, 造成服务器端数据丢失
[root@nfs01 ~]# export RSYNC_PASSWORD=zls
[root@nfs01 ~]# rsync -avz --delete /data/ rsync_backup@172.16.1.41::backup/
```

***

| 实战四 |
| :--- |

`Rsync`的Limit限速

```bash
#企业案例: 某DBA使用rsync拉取备份数据时，由于文件过大导致内部交换机带宽被沾满，导致用户的请求无法响应
[root@nfs01 ~]# export RSYNC_PASSWORD=zls
[root@nfs01 ~]# rsync -avz --bwlimit=1 rsync_backup@172.16.1.41::backup/ /data/
```

## Rsync备份案例

使用3台服务器主机名分别为`web01、backup 、nfs`主机信息见下表:

| 角色 | 外网IP(WAN) | 内网IP(LAN) | 主机名 |
| :--- | :--- | :--- | :--- |
| WEB | eth0:10.0.0.7 | eth1:172.16.1.7 | web01 |
| NFS | eth0:10.0.0.31 | eth1:172.16.1.31 | nfs01 |
| Rsync | eth0:10.0.0.41 | eth1:172.16.1.41 | backup |

***

| 客户端需求 |
| :--- |

1.客户端提前准备存放的备份的目录，目录规则如下:`/backup/nfs_172.16.1.31_2018-09-02` 

2.客户端在本地打包备份(系统配置文件、应用配置等)拷贝至`/backup/nfs_172.16.1.31_2018-09-02`

3.客户端最后将备份的数据进行推送至备份服务器

4.客户端每天凌晨1点定时执行该脚本

5.客户端服务器本地保留最近7天的数据, 避免浪费磁盘空间

***

| 服务端需求 |
| :--- |

1.服务端部署rsync，用于接收客户端推送过来的备份数据

2.服务端需要每天校验客户端推送过来的数据是否完整

3.服务端需要每天校验的结果通知给管理员

4.服务端仅保留6个月的备份数据,其余的全部删除

>  
>
> 注意：所有服务器的备份目录必须都为/backup

**建议备份的数据内容如下：**

```bash
#1.开机自启动配置文件  设备挂载配置文件  本地内网配置文件    (系统配置文件)
/etc/rc.local       /etc/fstab      /etc/hosts              
#2.cron定时任务        firewalld防火墙       脚本目录      (重要目录)
/var/spool/cron/    /etc/firewalld     /server/scripts
#3.系统日志文件
/var/log/   //系统安全日志、sudo日志、内核日志、rsyslog日志
#4.应用程序服务配置文件 nginx、PHP、mysql、redis.....
```

*1.客户端备份实现思路,脚本每天凌晨01点定时执行一次（打包->标记->推送->保留最近7天的文件）*

```bash
[root@nfs scripts]# cat /server/scripts/client_rsync_backup.sh 
#!/usr/bin/bash
#1.定义变量
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
Host=$(hostname)
Addr=$(ifconfig eth1|awk 'NR==2{print $2}')
Date=$(date +%F)
Dest=${Host}_${Addr}_${Date}
Path=/backup
#2.创建备份目录
[ -d $Path/$Dest ] || mkdir -p $Path/$Dest
#3.备份对应的文件
cd / && \
[ -f $Path/$Dest/system.tar.gz ] || tar czf $Path/$Dest/system.tar.gz etc/fstab etc/rsyncd.conf && \
[ -f $Path/$Dest/log.tar.gz ] || tar czf $Path/$Dest/log.tar.gz  var/log/messages var/log/secure && \
#4.携带md5验证信息
[ -f $Path/$Dest/flag ] || md5sum $Path/$Dest/*.tar.gz >$Path/$Dest/flag_$Date
#5.推送本地数据至备份服务器
export RSYNC_PASSWORD=zls
rsync -avz $Path/ rsync_backup@172.16.1.41::backup
#6.本地保留最近7天的数据
find $Path/ -type d -mtime +7|xargs rm -rf
```

*2.客户端编写定时任务,让备份每天凌晨1点执行*

```bash
[root@nfs01 ~]# crontab -l
00 01 * * * /bin/bash /server/scripts/backup_rsync.sh &>/dev/null
```

*3.服务端校验客户端推送数据的完整性, (校验->存储校验结果->将保存的结果通过邮件发送给管理员->保留最近180天的数据)*

```bash
#1.服务端配置邮件功能
[root@backup /]# yum install mailx -y
[root@backup /]# vim /etc/mail.rc
set from=253097001@qq.com
set smtp=smtps://smtp.qq.com:465
set smtp-auth-user=253097001@qq.com
set smtp-auth-password=#客户端授权码
set smtp-auth=login
set ssl-verify=ignore
set nss-config-dir=/etc/pki/nssdb/
#2.服务端校验、以及邮件通知脚本
[root@backup ~]# mkdir /server/scripts -p
[root@backup ~]# vim /server/scripts/check_backup.sh
#!/usr/bin/bash
#1.定义全局的变量
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
#2.定义局部变量
Path=/backup
Date=$(date +%F)
#3.查看flag文件,并对该文件进行校验, 然后将校验的结果保存至result_时间
find $Path/ -type f -name "flag_$Date"|xargs md5sum -c >$Path/result_${Date}
#4.将校验的结果发送邮件给管理员
mail -s "Rsync Backup $Date" 123@qq.com <$Path/result_${Date}
#5.删除超过7天的校验结果文件, 删除超过180天的备份数据文件
find $Path/ -type f -name "result*" -mtime +7|xargs rm -f
find $Path/ -type d -mtime +180|xargs rm -rf
```

*4.服务端编写定时任务脚本*

```bash
[root@backup backup]# crontab -l
00 05 * * * /bin/bash /server/scripts/check_backup.sh &>/dev/null
```

*5.如何扩展多台服务器的备份？*

```bash
[root@nfs ~]# rsync -avz /server 172.16.1.7:/
```

<!-- OCR_START -->
- 实现步骤
- 1.安装配置启动rsync。准备接受客户端的数据
- 1.先准备存储备份文件的目录
- /bakcup/nfs_ip_dat
- 2.每天的客户端数据推送过来后，进行校验
- 2.将重要的文件打包并放置/backup/nfs_ip_data/xx
- tar.gz
- 3.使用md5-c命令校验当天所有的flag标记
- 3.使用md5命令给每个tar包增加标记->flag
- 4.将校验的结果存储在本地/backup/result-date文件中
- 4.通过rsync命令推送本地的备份数据至服务端
- 5.定时将校验的结果通过邮件方式发送管理员
- 备份
- 5.定时清理本地的备份数据，保留最近7天即可
- 6.仅客户端（可以多台）180天的备份数据
- 文件
- 服务端
- Pol
- 退出
- 首先是运行了rsync服务
- 2
- 打包
- 5.通过rsync命令推送数据至Rsync服务端
- 6.backup模块
- 3
- 实际模块
- /backup/nfs_IP_da
- te/xx.tar.gz
- 代表/bakcup目录
- 配置
- 4.加标记flag
- 7.验证客户端的数据是否完整
- 将验证结果按天存储至/backap目录
- 老男孩教育50期
- 每天将验证结果文件内容通过邮件通知给管理员
- By：曾老湿
- 二田
<!-- OCR_END -->

## Rsync结合inotify\[扩展]

1.安装inotify

```bash
yum -y install inotify-tools
```

2.inotify参数说明

```bash
-m 持续监控
-r 递归
-q 静默，仅打印时间信息
--timefmt 指定输出时间格式
--format 指定事件输出格式
%Xe 事件
%w 目录
%f 文件
-e 指定监控的事件
access 访问
modify 内容修改
attrib 属性修改
close_write 修改真实文件内容
open 打开
create 创建
delete 删除
umount 卸载
```

3.命令测试

```bash
/usr/bin/inotifywait  -mrq  --format '%Xe  %w  %f' -e create,modify,delete,attrib,close_write  /backup
```

4.脚本编写

```bash
[root@backup ~]# vim rsyn-inotify.sh
#!/bin/bash
dir=/backup
/usr/bin/inotifywait  -mrq  --format '%w %f' -e create,delete,attrib,close_write  $dir | while read line;do
        cd  $dir  && rsync -az -R  --delete  .  rsync_backup@172.16.1.31::backup --password-file=/etc/rsync.passwd >/dev/null 2>&1
done  &

```

> 更新: 2024-09-22 14:45:47  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/zmexyd>