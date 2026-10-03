# 03 FTP文件传输服务

# 03 FTP文件传输服务

* [1.FTP服务原理概述](http://kt.xuliangwei.com/15099406436300.html#toc_0)
* [2.FTP服务传输模式](http://kt.xuliangwei.com/15099406436300.html#toc_1)
* [3.FTP服务安装配置](http://kt.xuliangwei.com/15099406436300.html#toc_2)
* [4.FTP匿名用户访问](http://kt.xuliangwei.com/15099406436300.html#toc_3)
* [5.FTP本地用户访问](http://kt.xuliangwei.com/15099406436300.html#toc_4)
* [6.FTPFTP企业案例](http://kt.xuliangwei.com/15099406436300.html#toc_5)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 1.FTP服务原理概述

FTP(File Transfer Protocol), 中文为 “文件传输协议” 是一种在互联网上进行文件传输的协议, 用于在Internet上控制文件的双向传输。

FTP是一个应用程序, 基于客户端/服务器模式，默认使用TCP 20/21端口:

> FTP控制链接：21端口，用于接受客户端发出的相关FTP命令与参数
>
> FTP数据链接：20端口，用于数据传输, 比如: 上传、下载数据

FTP服务端通常部署在企业内网, 具有容易搭建、方便管理、安全稳定等特征。 而且有些FTP客户端工具支持文件的多点下载以及断点续传技术，因此FTP服务得到了广大用户的青睐。

FTP协议的传输拓扑如下:

<!-- OCR_START -->
- FTP指令
- 数据资料
- FTP客户端
- FTP服务器
<!-- OCR_END -->

**FTP登陆用户:**

> 匿名用户 -->系统用户
>
> 系统用户 -->一般关闭
>
> 虚拟用户 -->系统用户

## 2.FTP服务传输模式

**FTP传输模式**

> 1. 主动模式：服务端通过20端口主动向客户端连接，传输数据。
> 2. 被动模式：服务端启动随机端口，等待客户端发起连接，进行数据传输。

<!-- OCR_START -->
- FTP主动模式
- 主动模式防火墙需要打开21和20端口
- 目标端口21
- Internet
- 源端口20
- FTP
- 防火墙
<!-- OCR_END -->

<!-- OCR_START -->
- FTP被动模式
- 防火墙只打开21和20端口
- 被动模式FTP不能下载数据
- 目标端口21
- Internet
- 源端口1234
- FTP
- 防火墙
<!-- OCR_END -->

**FTP传输模式总结:**

> FTP服务器端启用防火墙, 开启21/20端口，这时FTP只能工作在主动模式
>
> FTP客户端开启防火墙，这时FTP只能选择工作在被动模式
>
> FTP客户端和FTP服务端都有防火墙，那么将无法使用FTP主动和被动模式

## 3.FTP服务安装配置

1.基础环境准备

```plain
[root@ftp-server ~]# uname -r
3.10.0-693.el7.x86_64
[root@ftp-server ~]# cat /etc/redhat-release
Red Hat Enterprise Linux Server release 7.4 (Maipo)
```

2.关闭防火墙以及`selinux`

```plain
[root@ftp-server ~]# systemctl stop firewalld
[root@ftp-server ~]# systemctl disable firewalld
[root@ftp-server ~]# sed -ri '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config
[root@ftp-server ~]# setenforce 0
[root@ftp-server ~]# getenforce
Disabled
```

3.安装`vsftpd`服务

```plain
//需要有epel仓库
[root@ftp-server ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
[root@ftp-server ~]# yum install vsftpd libdb-utils -y
```

4.启动`ftp`服务并加入开机自启动

```plain
[root@ftp-server ~]# systemctl enable vsftpd
[root@ftp-server ~]# systemctl start vsftpd
```

> 注意: 默认使用匿名用户访问共享目录站点为`/var/ftp`仅拥有下载权限

5.`vsftpd`全局配置文件注释

```plain
[root@ftp-server ~]# cat /etc/vsftpd/vsftpd.conf
anonymous_enable=YES            //是否启用匿名用户
local_enable=YES                //是否启动本地用户
write_enable=YES                //开启全局上传文件
local_umask=022                 //控制本地用户上传文件默认权限, umask表示要减掉的权限
anon_umask=022                  //控制匿名用户上传文件的默认权限
anon_upload_enable=YES          //允许匿名用户上传
anon_mkdir_write_enable=YES     //允许创建目录
dirmessage_enable=YES           //配置用户目录显示信息
xferlog_enable=YES              //启动日志
xferlog_file=/var/log/vsftpd.log//指定日志位置，配置xferlog_enable使用
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES                      //是否作为一个独立守护进程运行
chroot_local_user=YES           //禁锢所有用户在用户目录下
chroot_list_enable=YES          //配合chroot_list_file使用
chroot_list_file=/etc/vsftpd/chroot_list    //禁锢用户列表
pam_service_name=vsftpd         ////PAM认证文件
userlist_enable=YES     //ftpusers文件下的用户都被拒绝登陆访问
tcp_wrappers=YES
guest_enable=YES                //开启虚拟用户
guest_username=www              //FTP虚拟用户对应的系统用户
user_config_dir=/etc/vsftpd/ftplogin    //授权FTP虚拟用户所在目录
//权限限制
local_root=/data/ftp    //指定本地用户访问目录站点
anon_root=/data/ftp     //指定匿名用户访问目录站点
//资源控制
anon_max_rate=500000    //匿名用户限速
local_max_rate=800000   //本地用户限速
max_clients=100         //同时能接收多少请求
max_per_ip=2            //一个ip同时能有多少连接
```

## 4.FTP匿名用户访问

1.配置匿名用户访问ftp服务，拥有创建文件夹、上传下载文件、不允许删除、移动、重命令

```plain
//编辑vsftpd主配置文件
[root@ftp-server ~]# vim /etc/vsftpd/vsftpd.conf
//启动匿名用户、允许上传和创建文件权限
anonymous_enable=YES
anon_upload_enable=YES
anon_mkdir_write_enable=YES
//修改默认ftp共享目录站点权限，最后重新加载vsftpd服务
[root@ftp-server ~]# chmod -R 777 /var/ftp/
[root@ftp-server ~]# systemctl restart vsftpd
//Linux下使用lftp客户端工具访问vsftpd服务验证，安装此工具
[root@ftp-server ~]# yum install lftp -y
//使用匿名用户登录vsftpd
[root@ftp-client ~]# lftp 192.168.56.11
lftp 192.168.56.11:~> ls
drwxrwxrwx    2 0        0            4096 Mar 22  2017 pub
lftp 192.168.56.11:/> cd pub
//创建目录
lftp 192.168.56.11:/pub> mkdir dir_ftp
mkdir ok, `dir_ftp' created
lftp 192.168.56.11:/pub> ls
drwx------    2 14       50           4096 Nov 14 21:10 dir_ftp
//切换系统其他目录
lftp 192.168.56.11:/pub> lcd /etc
lcd ok, local cwd=/etc
//下载系统内文件
lftp 192.168.56.11:/pub> put inittab
884 bytes transferred
lftp 192.168.56.11:/pub> ls
drwx------    2 14       50           4096 Nov 14 21:10 dir_ftp
-rw-------    1 14       50            884 Nov 14 21:11 inittab
//切回ftp目录
lftp 192.168.56.11:/pub> cd
cd ok, cwd=/
lftp 192.168.56.11:/> cd pub
lftp 192.168.56.11:/pub> ls
drwx------    2 14       50           4096 Nov 14 21:10 dir_ftp
-rw-------    1 14       50            884 Nov 14 21:11 inittab
//验证删除文件权限
lftp 192.168.56.11:/pub> rm inittab
rm: Access failed: 550 Permission denied. (inittab)
```

## 5.FTP本地用户访问

本地用户访问`ftp`默认拥有上传和下载权限

```plain
1.本地用户访问ftp服务
[root@ftp-server ~]# useradd ftp_test
[root@ftp-server ~]# echo "123"|passwd --stdin ftp_test
//客户端验证
[root@ftp-client ~]# lftp 192.168.56.11
lftp 192.168.56.11:~> login ftp_test 123
lftp ftp_test@192.168.56.11:/> mkdir ftp
[root@ftp-server ~]# ls /home/ftp_test
ftp
2.拒绝特定的本地用户访问ftp
[root@ftp-server ~]# echo "ftp_test" >> /etc/vsftpd/ftpusers
//客户端验证
[root@ftp-client ~]# lftp 192.168.56.11
lftp 192.168.56.11:~> login ftp_test 123
lftp ftp_test@192.168.56.11:~> ls
ls: Login failed: 530 Login incorrect.
3.锁定所有本地用户只能在自己的家目录操作,但允许bgx用户不被锁定家目录
chroot_local_user=YES   //锁定所用用户至家目录
chroot_list_enable=YES  //排除某个用户不被锁定
chroot_list_file=/etc/vsftpd/chroot_list    //对应的文件
allow_writeable_chroot=YES  //centos7必须增加
```

## 6.FTPFTP企业案例

公司为了宣传最新的产品信息，计划搭建FTP服务器，为客户提供相关文档的下载。对所有权互联网开放共享目录，允许下载产品信息。公司的合作单位能够使用FTP服务器进行上传和下载。

需求分析

> 根据企业的需求，对于不同用户进行不同的权限限制，FTP服务器需要实现用户的审核。需考虑到服务器的安全性，所以关闭实体用户登录，使用虚拟帐号验证机制，并对不同虚拟帐号设置不同的权限。为了保证服务器的性能，还需要根据用户的等级，限制客户端的连接数及下载速度。

解决方案

> 1.匿名用户允许下载我们公司的产品, 但需要对其限速50Kb
>
> 2.普通用户可以针对自己的目录进行上传和下载,对其限速500Kb(虚拟用户)
>
> 3.管理用户, 可以访问所有目录资源, 并可以操作客户的目录, 但不允许操作对外
>
> 4.优化: 根据不同的等级用户做不同的限速, 限制客户端连接次数(5)

```plain
[root@ftp-server ~]# /data/ftp   //manager用户能管理所有目录,但不能管理soft目录
    manager     
    bgx     //bgx普通用户仅能查看自己的文件和修改
    soft        //匿名用户仅能下载共享软件包
1.建立系统账户, 供与虚拟账户使用
[root@ftp-server ~]# useradd virftp -s /sbin/nologin
//2.创建对应目录,赋予权限
[root@ftp-server ~]#mkdir -p /data/ftp/{manager,bgx,soft}
[root@ftp-server ~]#chown -R virftp.virftp /data/ftp/{manager,bgx}
    
//3.创建虚拟用户账户及密码
[root@ftp-server ~]# cat > /etc/vsftpd/vsftpd_login <<EOF
manager
manager
bgx
bgx
EOF
[root@ftp-server ~]# chmod 600 /etc/vsftpd/vsftpd_login
//4.生成对应的库文件
[root@ftp-server ~]# db_load -T -t hash -f /etc/vsftpd/vsftpd_login /etc/vsftpd/vsftpd_login.db
//5.修改pam文件
[root@ftp-server ~]# vim /etc/pam.d/vsftpd
auth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login
account sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login
//6.建立虚拟目录
[root@ftp-server ~]# mkdir /etc/vsftpd/vsftpd_user_conf
//7.配置匿名用户权限,限速100k
//匿名用户登陆默认目录,必须要和/etc/passwd中的ftp用户的默认宿主目录要一样,否则也会出错误!
anonymous_enable=YES
anon_root=/data/ftp/soft
anon_max_rate=100000
//关闭之前修改过的匿名上传和创建权限
anon_upload_enable=NO
anon_mkdir_write_enable=NO
//8.配置管理用户, 限速2MB
cat > /etc/vsftpd/vsftpd_user_conf/manager <<EOF
local_root=/data/ftp/
allow_writeable_chroot=YES
write_enable=YES
local_umask=022
anonymous_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
idle_session_timeout=600
data_connection_timeout=120
max_clients=10
max_per_ip=5
local_max_rate=2000000
EOF
//9.配置普通用户, 限速1MB
cat > /etc/vsftpd/vsftpd_user_conf/bgx <<EOF
local_root=/data/ftp/bgx
allow_writeable_chroot=YES
write_enable=YES
local_umask=022
anonymous_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
idle_session_timeout=600
data_connection_timeout=120
max_clients=10
max_per_ip=5
local_max_rate=1000000
EOF
//10.配置文件尾部追加如下内容
chroot_local_user=YES
guest_enable=YES
guest_username=virftp
virtual_use_local_privs=YES
user_config_dir=/etc/vsftpd/vsftpd_user_conf
//11.使用ftp客户端验证权限即可
```

> 更新: 2019-03-20 19:59:11  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/oei95o>