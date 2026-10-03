# 第四章·Sersync 实时同步实战

## 实时同步概述

| 什么是实时同步 |
| :--- |

实时同步是一种只要当前目录发生变化则会触发一个事件，事件触发后会将变化的目录同步至远程服务器。

| 为什么要实时同步 |
| :--- |

保证数据的连续性, 减少人力维护成本,解决nfs单点故障

| 实时同步工具选择 |
| :--- |

`sersync+RSYNC(√)、`

`inotify+rsync`

`_Inotify_`*是一个通知接口，用来监控文件系统的各种变化，如果文件存取，删除，移动。可以非常方便地实现文件异动告警，增量备份，并针对目录或文件的变化及时作出响应。*`_rsync+inotify_`*可以实触发式实时同步增量备份*

`_sersync_`*是国人基于*`_rsync+inotify-tools_`*开发的工具，不仅保留了优点同时还强化了实时监控，文件过滤，简化配置等功能，帮助用户提高运行效率，节省时间和网络资源。*[*sersync项目地址*](https://github.com/wsgzao/sersync)

## 实时同步实践

*案例: 实现*`_web_`*上传视频文件，实则是写入*`_NFS_`*至存储，当NFS存在新的数据则会实时的复制到备份服务器\
**1.web上传视频至NFS存储\
**2.web和NFS的数据都备份再备份服务器的/backup\
\_\_3.如何将NFS数据实时同步到备份服务器的/data目录*

| 角色 | 外网IP(NAT) | 内网IP(LAN) | 安装工具 |
| :--- | :--- | :--- | :--- |
| web01 | eth0:10.0.0.7 | eth1:172.16.1.7 | |
| nfs-server | eth0:10.0.0.31 | eth1:172.16.1.31 | rsync+inotify+sersync |
| backup | eth0:10.0.0.41 | eth1:172.16.1.41 | rsync-server |

*Backup服务器操作步骤如下*

*1.安装*`_rsync_`

```bash
[root@backup ~]# yum install rsync -y
```

*2.配置*`_rsync_`

```bash
[root@backup ~]# cat /etc/rsyncd.conf 
uid = www
gid = www
port = 873
fake super = yes
use chroot = no
max connections = 200
timeout = 600
ignore errors
read only = false
list = false
auth users = rsync_backup
secrets file = /etc/rsync.password
log file = /var/log/rsyncd.log
#####################################
[backup]
path = /backup
[data]
path = /data
```

*3.建立对应密码文件*

```bash
[root@backup ~]# echo "rsync_backup:123456" > /etc/rsync.password
```

*4.创建对应目录并授权*

```bash
[root@backup ~]# groupadd -g 666 www
[root@backup ~]# useradd -u 666 -g www www
[root@backup ~]# mkdir -p /{backup,data}
[root@backup ~]# chown -R www.www /{backup,data}
```

*5.启动*`_rsync_`

```bash
[root@backup-41 ~]# systemctl enable rsyncd
[root@backup-41 ~]# systemctl start rsyncd
```

*Nfs-Server操作步骤如下*

*1.安装*`_sersync_`

```bash
# sersync需要依赖inotify和rsync，所以需要安装对应软件
[root@nfs01 ~]# yum install rsync inotify -y
# 安装sersync
[root@nfs01 ~]# mkdir /server/tools -p
[root@nfs01 ~]# cd /server/tools/
[root@nfs01 tools]# wget https://raw.githubusercontent.com/wsgzao/sersync/master/sersync2.5.4_64bit_binary_stable_final.tar.gz
[root@nfs01 tools]# tar xf sersync2.5.4_64bit_binary_stable_final.tar.gz
[root@nfs01 tools]# mv GNU-Linux-x86/ /usr/local/sersync
```

*2.配置*`_sersync_`*详解*

<!-- OCR_START -->
老男孩期中架构-实时同步服务sersync-服务配置文件比对说明
rsync
-az
/data
rsync_backup
172.16.1.41
nfsbackup
--password-file=/etc/rsync.password
<localpath
watch="/opt/tongbu">
cremota
ip="172.16.1.41'
name="nfsbackup"/>
<!--<remoteip="192.168.8.39"name="tongbu"/>-->
<!--<remote ip="192.168.8.40"name="tongbu"/>-->
<commonParams
params="-az"/>
<auth start="true
users="rsync_backup
<userDefinedPortstart="false"port="874"/><!--port=874--
<timeoutstart="false"time="100"/><!--timeout=100-->
oldboy
老男孩IT教育
<ssh start="false"/>
小白化身变大神
绘图出品
<!-- OCR_END -->

```bash
[root@nfs01 tools]# cd /usr/local/sersync/
[root@nfs01 sersync]# cp confxml.xml confxml.bak
[root@nfs01 sersync]# vim confxml.xml
  5     <fileSystem xfs="true"/>  <!-- 文件系统 -->
  6     <filter start="false">  <!-- 排除不想同步的文件-->
  7         <exclude expression="(.*)\.svn"></exclude>
  8         <exclude expression="(.*)\.gz"></exclude>
  9         <exclude expression="^info/*"></exclude>
 10         <exclude expression="^static/*"></exclude>
 11     </filter>
 
 12     <inotify> <!-- 监控的事件类型 -->
 13         <delete start="true"/>
 14         <createFolder start="true"/>
 15         <createFile start="true"/>
 16         <closeWrite start="true"/>
 17         <moveFrom start="true"/>
 18         <moveTo start="true"/>
 19         <attrib start="false"/>
 20         <modify start="false"/>
 21     </inotify>
 
 23     <sersync>
 24         <localpath watch="/data/www"> <!-- 监控的目录 -->
 25             <remote ip="172.16.1.41" name="data"/>  <!-- backup的IP以及模块 -->
 26             <!--<remote ip="192.168.8.39" name="tongbu"/>-->
 27             <!--<remote ip="192.168.8.40" name="tongbu"/>-->
 28         </localpath>
 
 29         <rsync> <!-- rsync的选项 -->
 30             <commonParams params="-az"/>
 31             <auth start="true" users="rsync_backup" passwordfile="/etc/rsync.password"/>
 32             <userDefinedPort start="false" port="874"/><!-- port=874 -->
 33             <timeout start="true" time="100"/><!-- timeout=100 -->
 34             <ssh start="false"/>
 35         </rsync>
            <!-- 每60分钟执行一次同步-->
  36         <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--def
    ault every 60mins execute once-->
```

*3.启动*`_sersync_`*服务守护进程*

```bash
# 查看启动参数
[root@nfs01 sersync]# ./sersync2 -h
set the system param
execute：echo 50000000 > /proc/sys/fs/inotify/max_user_watches
execute：echo 327679 > /proc/sys/fs/inotify/max_queued_events
parse the command param
_______________________________________________________
参数-d:启用守护进程模式
参数-r:在监控前，将监控目录与远程主机用rsync命令推送一遍
参数-n: 指定开启守护线程的数量，默认为10个
参数-o:指定配置文件，默认使用confxml.xml文件
参数-m:单独启用其他模块，使用 -m refreshCDN 开启刷新CDN模块
参数-m:单独启用其他模块，使用 -m socket 开启socket模块
参数-m:单独启用其他模块，使用 -m http 开启http模块
不加-m参数，则默认执行同步程序
# 启动Sersync, 如果需要同步多个目录, 那么需要配置多套环境
[root@nfs01 ~]# /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
```

*如果nfs出现故障,希望将web客户端挂载至backup服务器上, 怎么实现？*

```bash
#1.nfs和backup两台服务器应该保持一样（nfs配置。nfs共享的目录。nfs的权限）
[root@backup ~]# yum install nfs-utils -y
[root@backup ~]# rsync -avz root@172.16.1.31:/etc/exports /etc/
[root@backup ~]# groupadd -g 666 www
[root@backup ~]# useradd -u666 -g666 www
    
#2.启动nfs服务
[root@backup ~]# systemctl start rpcbind
[root@backup ~]# systemctl start nfs-server
#3.修改rsync的权限
[root@backup ~]# vim /etc/rsyncd.conf
uid = www
gid = www
    
#4.修改授权
[root@backup ~]# chown -R www.www /data/ /backup/
    
#5.重启rsync
[root@backup ~]# systemctl restart rsyncd
    
#6.进行一次数据推送, 然后模拟nfs故障（挂起虚拟机）
    
#7.web强制卸载172.16.1.31:/data       
[root@web01 ~]# umount -lf /data
#8.web尝试挂载172.16.1.41:/data 
[root@web01 ~]# mount -t nfs 172.16.1.41:/data /data/
```

基于sersync海量文件实时同步:[TP](https://blog.51cto.com/jin544642965/2339314)

***

| 实时同步总结 |
| :--- |

```bash
1.为什么要使用实时同步？
        1.解决nfs单点
        2.大量的静态资源迁移（本地迁移云端）
2.实时同步能解决什么问题？
        1.平滑的迁移
        2.备份：减少人为的干预
3.实时同步工具选择？
        rsync+inotify   少量文件同步，麻烦。同步大文件太慢，遍历扫描，非常影响效率。
        sersync         配置简单，多线程同步，同步块。适合大量的小文件或者图片。
        lsryncd 
4.demo：用户上传文件-->web-->写入-->nfs存储-->inotify-->action-->rsync--->backup
        用户上传文件-->web-->写入-->nfs存储（本地）--->实时的同步到-->存储（云端）
                     web-->卸载存储（本地）--->重新挂载存储(云端)
```

***

| 练习 |
| :--- |

1.将上面的实验重新做

2.写文档

3.画图

> 更新: 2024-09-22 17:54:59  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/rbkudx>