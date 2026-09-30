# rsync增量同步工具

# 1.Rsync基本概述
rsync<font style="color:#333333;">是一款开源的备份工具，可以在不同主机之间进行同步，可实现全量备份与增量备份，因此非常适合用于架构集中式备份或异地备份等应用。 </font>

rsync<font style="color:#333333;">官方地址：</font>[传送门](http://rsync.samba.org/)<font style="color:#333333;"> </font>

rsync<font style="color:#333333;">监听端口：873 </font>rsync   

<font style="color:#333333;">运行模式：   C/S  客户端/服务端        </font>

<font style="color:#333333;">B/S 浏览器/服务端</font>

<font style="color:#333333;">rsync常见的两种备份方式</font>

<font style="color:#6F6F6F;">完全备份 增量备份</font>

<font style="color:#333333;">假设客户端上有</font>file1 file2 file3<font style="color:#333333;">文件，服务端上有</font>file1<font style="color:#333333;">文件，现要将客户端上的数据备份至服务端</font>

![1547284700643-6a1123ef-a48f-4d77-8e60-99345af7b3d5-image1.jpeg](img/rsync%E5%A2%9E%E9%87%8F%E5%90%8C%E6%AD%A5%E5%B7%A5%E5%85%B7-01.jpeg)

<font style="color:#FF0000;">完全备份，将客户端所有的数据内容</font>file1 file2 file3<font style="color:#FF0000;">全部备份至服务端 (效率低下, 占用空间)</font>

![1547284700693-efa713c2-ccf7-46ac-a00a-4d796a5f6197-image2.jpeg](img/rsync%E5%A2%9E%E9%87%8F%E5%90%8C%E6%AD%A5%E5%B7%A5%E5%85%B7-02.jpeg)

<font style="color:#FF0000;">增量备份，将客户端的</font>file2 file3<font style="color:#FF0000;">增量备份至服务端 (提高备份效率,节省空间, 适合异地备份 )</font>

# 2.Rsync应用场景
<font style="color:#333333;">关于数据同步的两种方式</font>

<font style="color:#333333;"></font>

<font style="color:#FF0000;">1.推: 所有主机推送本地数据至Rsync备份服务器，会导致数据同步缓慢(适合少量数据备份)</font>

![1547284700729-113453fe-c9eb-4f9a-8cf0-a781d07b1610-image3.jpeg](img/rsync%E5%A2%9E%E9%87%8F%E5%90%8C%E6%AD%A5%E5%B7%A5%E5%85%B7-03.jpeg)



<font style="color:#FF0000;">2.拉: rsync备份服务端拉取所有主机上的数据，会导致备份服务器开销大</font>

![1547284700755-9028b1c1-e40f-4d26-a372-5f165d6f2afa-image4.jpeg](img/rsync%E5%A2%9E%E9%87%8F%E5%90%8C%E6%AD%A5%E5%B7%A5%E5%85%B7-04.jpeg)



<font style="color:#FF0000;">3.大量服务器备份场景</font>

![1547284700779-cb685187-3c68-42f2-94b5-e31124b03cda-image5.jpeg](img/rsync%E5%A2%9E%E9%87%8F%E5%90%8C%E6%AD%A5%E5%B7%A5%E5%85%B7-05.jpeg)



<font style="color:#FF0000;">4.异地备份实现思路</font>

![1547284700809-e78120f3-a9c6-4fa0-ad3b-bd64c56c902e-image6.jpeg](img/rsync%E5%A2%9E%E9%87%8F%E5%90%8C%E6%AD%A5%E5%B7%A5%E5%85%B7-06.jpeg)



# 3.Rsync传输模式
```bash
Rsync大致使用三种主要的数据传输方式
本地方式      远程方式       守护进程

# Local:  本地传输
rsync [OPTION...] SRC... [DEST]  

#远程通道传输
Access via remote shell:    
    Pull: rsync [OPTION...] [USER@]HOST:SRC... [DEST]
    Push: rsync [OPTION...] SRC... [USER@]HOST:DEST

# 守护进程方式传输
Access via rsync daemon:    
    Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST]
          rsync [OPTION...] rsync://[USER@]HOST[:PORT]/SRC... [DEST]
    Push: rsync [OPTION...] SRC... [USER@]HOST::DEST
          rsync [OPTION...] SRC... rsync://[USER@]HOST[:PORT]/DEST

Rsync命令对应选项
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

```



## 本地方式 单个主机本地之间的数据传输 类似于cp命令
```bash
  					选项		pc		U盘
Local:  rsync [OPTION...] SRC... [DEST]
# rsync /etc/passwd /tmp/
# ls /tmp/passwd

```

## 远程方式<font style="color:#333333;"> 通过</font>ssh<font style="color:#333333;">通道传输数据,类似</font>scp<font style="color:#333333;">命令</font>
```bash
Access via remote shell: 远程传输
Pull: rsync [OPTION...] [USER@]HOST:SRC... [DEST]  下载（拉）
Push: rsync [OPTION...] SRC... [USER@]HOST:DEST    上传（推）

#下载pull
echo "This Nfs" > file
rsync -avz root@172.16.1.31:/root/file /opt/


#上传push（将backup的file2文件上传至NFS服务器的/mnt目录）
echo "This Rsync" > file2
rsync -avz /root/file2 root@172.16.1.31:/mnt


英文翻译
# rsync -avz /root/file2 root@172.16.1.31:/mnt
root@172.16.1.31''s password:
sending incremental file list   #发送增量文件列表
file2

sent 99 bytes  received 35 bytes  20.62 bytes/sec   #发送99字节接收35字节20.62字节/秒
total size is 11  speedup is 0.08  				#总大小为11，加速率为0.08

注意事项
#推送目录（推送/root/目录下面的所有文件和目录，不会推送/root/目录本身）
[root@backup ~]# rsync -avz /root/ root@172.16.1.31:/tmp
   
#推送目录，推送目录本身以及目录下面的所有文件
[root@backup ~]# rsync -avz /root root@172.16.1.31:/tmp

远程方式存在的缺陷：
   1.需要使用系统用户（不安全）
   2.使用普通用户（权限存在问题）
   3.需要走ssh协议

           
```



## 守护进程(服务，持续后台运行)
```bash
rsync自身非常重要的功能(不使用系统用户，更加安全)
   Access via rsync daemon:    守护进程方式传输
   Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST] #下载
   Push: rsync [OPTION...] SRC... [USER@]HOST::DEST #上传

---1.拉取rsync备份服务的backup模块数据至本地/mnt目录
# Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST]
rsync -avz rsync_backup@192.172.16.1.41::backup/ /mnt/ \
--password-file=/etc/rsync.password
 
rsync           ---命令
[OPTION...]     ---选项
[USER@]         ---远程主机用户(虚拟用户)
HOST::          ---远程主机地址  
SRC...          ---远程主机模块(不是目录)
[DEST]          ---将远程主机数据备份至本地什么位置     

---2.将本地/mnt目录里文件推送至rsync备份服务器的backup模块
# Push: rsync [OPTION...] SRC... [USER@]HOST::DEST
rsync -avz /mnt/ rsync_backup@192.172.16.1.41::backup/ \
--password-file=/etc/rsync.password

rsync           ---命令
[OPTION...]     ---选项
SRC...          ---远程主机模块(不是目录)
[USER@]         ---远程主机用户(虚拟用户)
HOST::          ---远程主机地址
[DEST]          ---将远程主机模块备份至本地什么位置

```



# 4.Rsync服务实践
| **<font style="color:#222222;">角色</font>** | **<font style="color:#222222;">外网IP(NAT)</font>** | **<font style="color:#222222;">内网IP(LAN)</font>** | **<font style="color:#222222;">主机名</font>** |
| --- | --- | --- | --- |
| <font style="color:#222222;">Rsync服务端</font> | <font style="color:#222222;">eth0:10.0.0.41</font> | <font style="color:#222222;">eth1:10.0.0.7</font> | <font style="color:#222222;">backup</font> |
| <font style="color:#222222;">Rsync客户端</font> | <font style="color:#222222;">eth0:10.0.0.31</font> | <font style="color:#222222;">eth1:10.0.0.4</font> | <font style="color:#222222;">nfs</font> |




```bash
# 1.第一个里程碑，安装rsync软件
yum -y install rsync

# 2.第二个里程碑，配置/etc/rsyncd.conf
#查询配置文件存放的路径
rpm -qc rsync

vi /etc/rsyncd.conf   # vi 不会粘贴格式，
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
secrets file = /etc/rsync.password
log file = /var/log/rsyncd.log
#####################################
[backup]
comment = welcome to oldboyedu backup!
path = /backup


# vim /etc/rsyncd.conf   #配置说明
# 全局模块
uid = rsync                     --- 运行进程的用户
gid = rsync                     --- 运行进程的用户组
port = 873                      --- 监听端口
fake super = yes                --- 无需让rsync以root身份运行，允许存储文件的完整属性
use chroot = no                 --- 关闭假根功能
max connections = 200           --- 最大连接数
timeout = 600                   --- 超时时间
ignore errors                   --- 忽略错误信息
read only = false               --- 对备份数据可读写
list = false                    --- 不允许查看模块信息
auth users = rsync_backup       --- 定义虚拟用户，作为连接认证用户
secrets file = /etc/rsync.passwd---定义rsync服务用户连接认证密码文件路径
##局部模块
[backup]                --- 定义模块信息
comment = commit        --- 模块注释信息
path = /backup          --- 定义接收备份数据目录



#3.第三个里程碑，创建用户(运行rsync服务的用户身份)
#1.创建rsync账户，不允许登录不创建家目录
useradd -M -s /sbin/nologin rsync

#2.创建备份目录(尽可能磁盘空间足够大),授权rsync用户为属主
mkdir /backup
chown -R rsync.rsync /backup/

# 4.第四个里程碑，创建虚拟用户密码文件(用于客户端连接时使用的用户)
#3.创建虚拟用户和密码文件,并赋予600权限  服务端
echo "rsync_backup:1" >/etc/rsync.password
chmod 600 /etc/rsync.password

# 5.第五个里程碑，启动rsync服务，并加入开机自启
systemctl start rsyncd
systemctl enable rsyncd
启动后检查对应端口
#  ss -lntp |grep 873

--------------------------------------------------------------
# 1.将客户端的/etc/passwd 推送至 rsync服务端[backup]
rsync -avz /etc/passwd rsync_backup@10.0.0.7::backup  #提示输入密码
# 2.将rsync服务端模块[/backup]下载至本地
# Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST]
rsync -avz rsync_backup@10.0.0.7::backup /opt
#服务器端没有rsync_backup用户，这个用户是 rsync配置文件配置的/etc/rsyncd.conf


# 6.第六个里程碑，Rsync客户端配置, 配置密码并设置权限（配置不输入密码方式）
#方式一：适合终端执行指定用户密码文件
yum install rsync –y   # 终端也安装rsync 但是不用启动服务  客户端
echo "1" > /etc/rsync.password
chmod 600 /etc/rsync.password 
rsync -avz rsync_backup@10.0.0.7::backup /opt --password-file=/etc/rsync.password

方式二：适合写脚本，强烈推荐方式
export RSYNC_PASSWORD=1
rsync -avz rsync_backup@10.0.0.7::backup /opt

强制一致性 pc  ->  U盘保持一致（--delete）
  rsync -avz /root rsync_backup@10.0.0.7::backup --delete

限速
dd if=/dev/zero of=/opt/test.dosk bs=1M count=1024
rsync -avzP --bwlimit=1 /opt/test.dosk rsync_backup@10.0.0.7::backup

实战一: 客户端推送数据至Rsync服务端
mkdir /backup
rsync -avz /backup/ rsync_backup@10.0.0.7::backup/ --password-file=/etc/rsync.password

实战二: 客户端拉取Rsync服务端数据至本地
rsync -avz rsync_backup@10.0.0.7::backup /backup/ --password-file=/etc/rsync.password

实战三: Rsync实现数据无差异同步
//拉取远端数据：远端与本地保持一致,远端没有本地有会被删除, 造成客户端数据丢失
rsync -avz --delete rsync_backup@10.0.0.7::backup/ /data/ --password-file=/etc/rsync.password

//推送数据至远端：本地与远端保持一致, 本地没有远端会被删除, 造成服务器端数据丢失
rsync -avz --delete /data/ rsync_backup@10.0.0.7::backup/ --password-file=/etc/rsync.password


```



# 5.Rsync备份案例
```bash
统一所有的目录站点是/backup
   1.备份什么
       1.系统重要的配置文件
       /etc/fstab /var/spool/cron/root
       2.服务的配置文件
       /etc/rsyncd.conf
       3.日志
       /var/log/secure /var/log/message
       4.脚本
       /server/scripts

  2.怎么备份
  /backup/nfs_172.16.1.31_2018_09_05
  /backup/nfs_172.16.1.31_2018_09_06
  /backup/nfs_172.16.1.31_2018_09_07

3.编写脚本
# echo $(hostname)_$(ifconfig eth1|awk 'NR==2{print $2}')_$(date +%F)
nfs_172.16.1.31_2018-09-05
# mkdir /server/scripts -p
      
1.我要备份什么        (xxxxx）
2.我要怎么备份       （tar）
3.我要将数据推送给谁 （备份服务器）
6.Rsync备份思考


#rsync实现简单本地打包和推送  #EOF 加'' 是为了创建这个文件时候内部的$不会执行
```
cat > /server/scripts/client_rsync_backup.sh<<'EOF'
#!/usr/bin/bash
#1.定义变量
Host=$(hostname)
Addr=$(ifconfig eth0|awk 'NR==2{print $2}')
Date=$(date +%F)
Dest=${Host}_${Addr}_${Date}
Path=/backup
#2.创建备份目录
mkdir -p $Path/$Dest
#3.备份对应的文件
tar czf $Path/$Dest/system.tar.gz /etc/fstab /etc/rsyncd.conf && \
tar czf $Path/$Dest/log.tar.gz  /var/log/messages /var/log/secure
#4.推送本地数据至备份服务器
export RSYNC_PASSWORD=1
rsync -avz $Path/ rsync_backup@10.0.0.4::backup
EOF


翻译英文
已加载插件：fastestmirror
Loading mirror speeds from cached hostfile #从缓存的主机文件加载镜像速度
There are no enabled repos.					#没有启用repos。
Run "yum repolist all" to see the repos you have.  #运行“yum repolist all”来查看你的repos。
To enable Red Hat Subscription Management repositories: #启用Red Hat订阅管理存储库:
    subscription-manager repos --enable <repo>   #订阅管理器repos——启用
To enable custom repositories:					#启用自定义存储库:
    yum-config-manager --enable <repo>			#yum-config-manager——使<回购>

    
```









	





报错：

[root@backup scripts]# vim a

vim: error while loading shared libraries: libperl.so: cannot open shared object file: No such fileor directory   # vim依赖的动态文件删了

yum remove vim  #卸载

yum -y install vim*  #重新安装



[root@linuxbaodian scripts]# find / -name "libperl.so" /usr/lib64/perl5/CORE/libperl.so /usr/lib64/perl5/5.10.0/x86_64-linux-thread-multi/CORE/libperl.so

以上操作没有用



从好的的电脑上拷贝

[root@ckh perl5]# pwd

/lib64/perl5

[root@ckh perl5]# tar zcf /croe.tar.gz ./CORE



打包文件拷贝过去/lib64/perl5

解压  就好了







英文翻译

![1547284700838-ee179d15-e64e-4c91-92b1-1547dca2ad1a-image7.png](img/rsync%E5%A2%9E%E9%87%8F%E5%90%8C%E6%AD%A5%E5%B7%A5%E5%85%B7-07.png)



# rsync报错整理
## 1、@ERRPR：chdir failed
```plain
错误原因：
服务器端没有提供访问的目录 /backup
处理方法：
需要在服务器端创建，并赋予权限rsync管理权限
mkdir /backup
chown -R rsync.rsync /backup/
```

## 2、@ERROR: auth failed on module backup
```plain
查看 服务端/etc/rsync.password 配置文件是否有问题
比如:
多余的空格 空行
rsync error: error startingclient-serverprotocol (code 5) at main.c(1503) [sender=3.0.6]
错误原因
1>    客户端密码文件的权限不是600
2>    服务端密码文件不是600
3>    服务端密码文件不存在(名字写错了/没有创建/配置文件参数写错了)
4>    服务端密码文件里保存的用户名和密码不正确
```

## 3、@ERROR:invalid uid rsync
```plain
不可用的uid
useradd rsync -s /sbin/nologin -M
```

## 4、@ERROR: chroot failed
```plain
@ERROR:chroot failed
rsyncerror: error starting client-server protocol (code 5) at main.c(1522)[receiver=3.0.3]
 
服务器端的目录不存在或无权限，创建目录并修正权限可解决问题。
```

## 5、@ERROR: auth failed on module tee
```plain
rsync error: error starting client-serverprotocol (code 5) at main.c(1522) [receiver=3.0.3]
 
服务器端该模块（tee）需要验证用户名密码，但客户端没有提供正确的用户名密码，认证失败。
 提供正确的用户名密码解决此问题。
```

## 6、@ERROR: Unknown module ‘tee_nonexists'
```plain
rsync error: error starting client-serverprotocol (code 5) at main.c(1522) [receiver=3.0.3]
 
服务器不存在指定模块。提供正确的模块名或在服务器端修改成你要的模块以解决问题。
1>    推送/拉取命令写错了
2>    服务端模块名字写错了
```

## 7、rsync: --passwork-file=/etc/rsync.password: unknown option
```plain
rsync: --passwork-file=/etc/rsync.password:unknown option
rsync error: syntax or usage error (code 1)at main.c(1422) [client=3.0.6]
错误原因：
/etc/rsync.password文件名称写错
解决方法：
更正/etc/rsync.password文件名称
```

## 8、rsync: ERROR:cannot stat destination
```plain
sending incremental file list
rsync: ERROR: cannot stat destination"." (in backup): Permission denied (13)
rsync error: errors selecting input/outputfiles, dirs (code 3) at main.c(554) [receiver=3.0.6]
rsync: connection unexpectedly closed (5bytes received so far) [sender]
rsync error: error in rsync protocol datastream (code 12) at io.c(600) [sender=3.0.6]
错误原因：
服务端rsync对目录操作权限不足
解决方法：
修改对应目录权限755
[root@oldboy~]# chmod 755 /backup/
[root@oldboy~]# ll -ld /backup/
drwxr-xr-x.12 rsync rsync 4096 Sep 23 19:17 /backup/
```

## 9、rsync: write failed on "/home/backup2010/ ": No space lefton device (28)
```plain
rsync:write failed on "/home/backup2010/wensong": No space left on device(28)
rsyncerror: error in file IO (code 11) at receiver.c(302) [receiver=3.0.7]
rsync:connection unexpectedly closed (2721 bytes received so far) [generator]
rsyncerror: error in rsync protocol data stream (code 12) at io.c(601) [generator=3.0.7]
问题原因：
磁盘空间不够，所以无法操作。
解决方法：
可以通过df /home/backup2010 来查看可用空间和已用空间
```

## 10、rsync: opendir "/kexue" (in dtsChannel) failed: Permissiondenied (13)
```plain
注意查看同步的目录权限是否为755
```

## 11、rsync: failed to connect to 203.100.192.66: Connection timed out(110)
```plain
rsync:failed to connect to 203.100.192.66: Connection timed out (110)
rsyncerror: error in socket IO (code 10) at clientserver.c(124) [receiver=3.0.5]
检查服务器的端口netstat ?tunlp，远程telnet测试。
可能因为客户端或者服务端的防火墙开启 导致无法通信，可以设置规则放行 rsync（873端口） 或者直接关闭防火墙。
关服务端selinux 和iptabs 防火墙
 
还有一种在同步过程中可能会提示没有权限 （将同步目录加上SvcwRsync全部权限即可，更简单的方法就是将SvcwRsync设为管理员即可）
需要给/etc/rsync.password 600权限
[root@backup backup]# ll -ld/etc/rsync.password
-rw-------. 1 root root 20 Sep 22 21:16/etc/rsync.password
```

## 12、rsync: failed to connect to 10.10.10.170: Connection refused (111)
```plain
rsync:failed to connect to 10.10.10.170: Connection refused (111)
rsyncerror: error in socket IO (code 10) at clientserver.c(124) [receiver=3.0.5]
 
启动服务：rsync --daemon--config=/etc/rsyncd.conf
```

## 13 、rsync:recv_generator: mkdir "/teacherclubBackup/rsync……" failed: No spaceleft on device (28)
```plain
*** Skipping any contents from this faileddirectory ***
 
磁盘空间满
 
14、rsync error: received SIGINT, SIGTERM, orSIGHUP (code 20) at rsync.c(544) [receiver=3.0.5]
rsyncerror: received SIGINT, SIGTERM, or SIGHUP (code 20) at rsync.c(544)[generator=3.0.5]
 
 
Ctrl+C或者大量文件
```

## 15、rsync: read error: Connection reset by peer (104)
```plain
rsync:read error: Connection reset by peer (104)
 rsync error: error in rsync protocol datastream (code 12) at io.c(759) [receiver=3.0.5]
 
xnetid启动
查看rsync日志
rsync: unable to open configuration file"/etc/rsyncd.conf": No such file or directory
xnetid查找的配置文件位置默认是/etc下，根据具体情况创建软链接。例如：
ln -s /etc/rsyncd/rsyncd.conf /etc/rsyncd.conf
或者更改指定默认的配置文件路径，在/etc/xinetd.d/rsync配置文件中。
```

## 16、rsync:recv_generator: mkdir"nfs01_172.16.1.31" (in backup) failed:Permission denied (13)
```plain
sendingincremental file list
./
rsync:failed to set times on"." (in backup): Operation not permitted (1)
nfs01_172.16.1.31/
rsync:recv_generator: mkdir"nfs01_172.16.1.31" (in backup) failed:Permission denied (13)
***Skipping any contents fromthis failed directory ***
sent 106bytes  received 15 bytes  80.67 bytes/sec
totalsize is 655  speedup is 5.41
rsyncerror: some files/attrs were not transferred (see previous errors) (code 23) atmain.c(1039) [sender=3.0.6]
错误原因:
1、服务端配置文件中指定的用户和模块指定的目录的属主属组不同
2、服务端模块指定的目录属组属组没有权限
解决方法:
将模块指定目录的属主属组修改为 配置文件中指定的 uid gid
[root@nfs01 ~]# chown rsync.rsync/backup           配置文件中指定的用户和组
```

## 17、skippingnon-regular file “vendor/bin/doctrine”
```plain
receivingincremental file list
skippingnon-regular file “vendor/bin/doctrine”
skippingnon-regular file “vendor/bin/doctrine.php”
sent1990 bytes received 489209 bytes 327466.00 bytes/sec total size is 182515746speedup is 371.57
原因：
source源文件有软链接。
解决方法：
修改为 rsync -va，其中 -a== -rlptgoD (no -H,-A,-X) 或者 rsync -rvltOD 也可以。
解决后：
receiving incremental file list
vendor/bin/doctrine ->../doctrine/orm/bin/doctrine
vendor/bin/doctrine.php ->../doctrine/orm/bin/doctrine.php
sent 1998 bytes received 489279 bytes327518.00 bytes/sec total size is 182515746 speedup is 371.51
```

## 18、@ERROR: module is read only
```plain
sendingincremental file list
ERROR:module is read only
rsyncerror: syntax or usage error (code 1) at main.c(866) [receiver=3.0.6]
rsync:read error: Connection reset by peer (104)
rsyncerror: error in rsync protocol data stream (code 12) at io.c(759)[sender=3.0.6]
原因：
source源服务器端权限设置read为only只读权限。
解决方法：
read only = false
```

## 19、password file must not be other-accessible
```plain
passwordfile must not be other-accessible
passwordfile must not be other-accessible
continuingwithout password file
Password:
原因：
这是因为rsyncd.pwd rsyncd.secrets的权限不对，应该设置为600。
解决方法：
chmod 600 rsyncd.pwd
```

## 20、rsync error: error starting client-server protocol
```plain
rsyncerror: error starting client-server protocol
rsyncerror: error starting client-server protocol (code 5) at main.c(1524)[Receiver=3.0.6]
原因：
/etc/rsyncd.conf配置文件内容有错误。请正确核对配置文件。
```

## 21、 rsync: chown “” failed: Invalid argument (22)
```plain
rsync:chown “” failed: Invalid argument (22)
原因：
权限无法复制。去掉同步权限的参数即可。(这种情况多见于Linux向Windows的时候)
```

## 22、@ERROR: daemon security issue — contactadmin
```plain
@ERROR:daemon security issue — contact admin rsync error: error starting client-serverprotocol (code 5) at main.c(1530) [sender=3.0.6]
原因：
同步的目录里面有权限不足的软连接文件，需要服务器端的/etc/rsyncd.conf打开use chroot = yes。
```

## 23、rsync: read error: Connection reset by peer (104)
```plain
rsync: read error: Connection reset by peer(104) rsync error: error in rsync protocol data stream (code 12) at io.c(794) [receiver=3.0.6]
解决：
很大可能是服务器端没有开启 rsync 服务，开启服务。
```

## 24、@ERROR: failed to openlock file
```plain
@ERROR:failed to open lock file rsync error: error starting client-server protocol(code 5) at main.c(1495) [receiver=3.0.6]
解决：
配置文件 rsync.conf 中添加lock file = rsyncd.lock 即可解决
```

## rsync服务端开启的iptables防火墙
【客户端的错误现象】

   No route to host

【错误演示过程】

[root@nfs01 tmp]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup

rsync: failed to connect to 172.16.1.41: No route to host (113)

rsync error: error in socket IO (code 10) at clientserver.c(124) [sender=3.0.6]

【异常问题解决】

关闭rsync服务端的防火墙服务（iptables）

[root@backup mnt]# /etc/init.d/iptables stop

iptables: Setting chains to policy ACCEPT: filter          [  OK  ]

iptables: Flushing firewall rules:                          [  OK  ]

iptables: Unloading modules:                                 [  OK  ]

[root@backup mnt]# /etc/init.d/iptables status

iptables: Firewall is not running.

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#58lmtv)rsync客户端执行rsync命令错误
【客户端的错误现象】

[root@nfs01 tmp]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::/backup

ERROR: The remote path must start with a module name not a /

rsync error: error starting client-server protocol (code 5) at main.c(1503) [sender=3.0.6]

【异常问题解决】

   rsync命令语法理解错误，::/backup是错误的语法，应该为::backup(rsync模块)

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#g7w3ad)@ERROR: auth failed on module oldboy
【客户端的错误现象】

[root@nfs01 tmp]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup

Password: 

@ERROR: auth failed on module backup

rsync error: error starting client-server protocol (code 5) at main.c(1503) [sender=3.0.6]

【异常问题解决】

1. 密码真的输入错误，用户名真的错误

2. secrets file = /etc/rsync.password指定的密码文件和实际密码文件名称不一致

3. /etc/rsync.password文件权限不是600

4. rsync_backup:oldboy123密码配置文件后面注意不要有空格

   echo "rsync_backup:oldboy123" >>/etc/rsync.password

5. rsync客户端密码文件中只输入密码信息即可，不要输入虚拟认证用户名称

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#ngnmnw)Unknown module 'backup' 
【客户端的错误现象】

[root@nfs01 tmp]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup

@ERROR: Unknown module 'backup'

rsync error: error starting client-server protocol (code 5) at main.c(1503) [sender=3.0.6]

【异常问题解决】

/etc/rsyncd.conf配置文件模块名称书写错误

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#epngix)Permission denied
【客户端的错误现象】

[root@nfs01 tmp]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup

Password: 

sending incremental file list

hosts

rsync: mkstemp ".hosts.5z3AOA" (in backup) failed: Permission denied (13)

sent 196 bytes  received 27 bytes  63.71 bytes/sec

total size is 349  speedup is 1.57

rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1039) [sender=3.0.6]

【异常问题解决】

1. 共享目录的属主和属组不正确，不是rsync

2. 共享目录的权限不正确，不是755

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#9pnerz)chdir failed
【客户端的错误现象】

[root@nfs01 tmp]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup

Password: 

@ERROR: chdir failed

rsync error: error starting client-server protocol (code 5) at main.c(1503) [sender=3.0.6]

【异常问题解决】

1. 备份存储目录没有建立

2. 建立的备份存储目录和配置文件定义不一致

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#h817lg)invalid uid rsync
【客户端的错误现象】

[root@nfs01 tmp]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup

Password: 

@ERROR: invalid uid rsync

rsync error: error starting client-server protocol (code 5) at main.c(1503) [sender=3.0.6]

【异常问题解决】

rsync服务对应rsync虚拟用户不存在了，重新创建即可。

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#ryqsbu)客户端已经配置了密码文件，但免秘钥登录方式，依旧需要输入密码
【客户端的错误现象】

password file must not be other-accessible

[root@nfs01 tmp]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup --password-file=/etc/rsync.password

password file must not be other-accessible

continuing without password file

Password: 

sending incremental file list

sent 26 bytes  received 8 bytes  5.23 bytes/sec

total size is 349  speedup is 10.26

【异常问题解决】

rsync客户端的秘钥文件也必须是600权限

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#8o22kb)rsync客户端连接慢问题
【客户端的错误日志】

2017/03/08 20:14:43 [3422] params.c:Parameter() - Ignoring badly formed line in configuration file: ignore errors

2017/03/08 20:14:43 [3422] name lookup failed for 172.16.1.31: Name or service not known

2017/03/08 20:14:43 [3422] connect from UNKNOWN (172.16.1.31)

2017/03/08 20:14:43 [3422] rsync to backup/ from rsync_backup@unknown (172.16.1.31)

2017/03/08 20:14:43 [3422] receiving file list

2017/03/08 20:14:43 [3422] sent 76 bytes  received 83 bytes  total size 349

【客户端的正确日志】

2017/03/08 20:16:45 [3443] params.c:Parameter() - Ignoring badly formed line in configuration file: ignore errors

2017/03/08 20:16:45 [3443] connect from nfs01 (172.16.1.31)

2017/03/08 20:16:45 [3443] rsync to backup/ from rsync_backup@nfs02 (172.16.1.31)

2017/03/08 20:16:45 [3443] receiving file list

2017/03/08 20:16:45 [3443] sent 76 bytes  received 83 bytes  total size 349

【异常问题解决】

查看日志进行分析

## [](https://www.yuque.com/chengkanghua/oldboy50/sl2ie1#fsxlgu)rsync服务没有正确启动
【客户端的错误现象】

Connection refused (111)

[root@oldboy-muban ~]#  rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup

rsync: failed to connect to 172.16.1.41: Connection refused (111)

rsync error: error in socket IO (code 10) at clientserver.c(124) [sender=3.0.6]

【异常问题解决】

 [root@oldboy-muban ~]# rsync --daemon

[root@oldboy-muban ~]# ss -lntup |grep rsync

tcp    LISTEN     0      5			:::873            :::*      users:(("rsync",1434,5))

tcp    LISTEN     0      5			*:873              *:*      users:(("rsync",1434,4))

[root@oldboy-muban ~]# rsync -avz /etc/hosts rsync_backup@172.16.1.41::backup

Password: 

sending incremental file list

hosts

sent 196 bytes  received 27 bytes  49.56 bytes/sec

total size is 349  speedup is 1.57



> 更新: 2026-04-29 17:04:37  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/gqkttb>