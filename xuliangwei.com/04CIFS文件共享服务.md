# 04 CIFS文件共享服务

# 04 CIFS文件共享服务

* [1.Samba基本概述](http://kt.xuliangwei.com/15104732647841.html#toc_0)
* [2.Samba服务配置](http://kt.xuliangwei.com/15104732647841.html#toc_1)
* [3.Win挂载Samba](http://kt.xuliangwei.com/15104732647841.html#toc_2)
* [4.Linux挂载Samba](http://kt.xuliangwei.com/15104732647841.html#toc_3)
* [5.SMB多用户挂载](http://kt.xuliangwei.com/15104732647841.html#toc_4)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208
>
> 重要指数2星

## 1.Samba基本概述

`Server Message Block (SMB)`是`Windows`服务器和客户端之间实现文件共享的服务协议。

`Samba`服务通常用来做跨系统文件共享服务，实现不同操作系统之间的资源共享。

`Samba`相关功能

> 用户验证
>
> 文件共享
>
> 打印共享
>
> 域名解析

`Samba`软件包

> samba: samba服务端共享程序
>
> common: samba服务配置文件语法检验testparm
>
> cifs-utils: samba客户端软件, 提供所需工具指令集

`Samba`主要程序

| 程序名 | 功能 | 端口 |
| :--- | :--- | :--- |
| nmbd | 提供基于NetBios主机名称解析 | udp/137,138 |
| smbd | 提供对文件、打印资源的共享 | udp/139,445 |

## 2.Samba服务配置

实践环境准备

| 操作系统 | 主机名称 | IP地址 |
| :--- | :--- | :--- |
| Linux7 | Samba服务端-Samba-Server | 192.168.69.112 |
| Linux7 | Linux客户端-Samba-Client | 192.168.69.113 |
| Windows7 | Windows客户端 | 192.168.69.100 |

1.安装`Samba`服务程序

```plain
[root@xuliangwei ~]# systemctl stop firewalld
[root@xuliangwei ~]# setenforce 0
[root@xuliangwei ~]# yum -y install samba
```

2.`samba`主配置文件,默认存放于`/etc/samba/smb.conf`

```plain
//筛选Samba注释配置文件
[root@xuliangwei ~]# egrep -v '^#|^$' /etc/samba/smb.conf
[global]    //全局参数
    workgroup = SAMB       //工作组名称
    hosts allow = 192.168.56.  //表示允许IP或网段, 允许使用通配符或主机名
    interfaces = eth0      //SambaServer监听网卡, 也可以写IP地址
    max connections = 0    //最大连接数目, 超出拒绝, 0表示不限制
    max log size = 50      //定义日志文件的最大容量为50KB
    security = user        //安全验证方式，总共有4种
                           //share:无需验证身份, 简单方便, 安全性差
                           //user:需要验证用户密码才可访问, 安全性高
                           //server:需要通过三方服务验证账号密码, （集中管理账户）
                           //domain: 使用域控制器进行身份验证
    passdb backend = tdbsam//定义用户密码的类型，共有3种
                           //smbpasswd:为系统用户设置Samba服务程序的密码
                           //tdbsam:创建数据库文件并使用pdbedit命令建立Samba服务程序的用户
                           //ldapsam: 基于LDAP服务进行账户验证
    printing = cups        //设置Samba共享打印机的类型(bsd, sysv, plp, lprng, aix, hpux, qnx)
    printcap name = cups   //设置共享打印机的配置文件
    load printers = yes    //设置在Samba服务启动时是否共享打印机设备
    cups options = raw     //打印机的选项
//为了更方便查阅共享重要参数的功能, 共享参数如下：
[共享名/访问名]
comment = 任意字符串
path = 共享目录路径
browseable = 指定该共享是否可以浏览
writable = 指定该共享路径是否可写
valid users = 允许访问该共享的用户
invalid users = 禁止访问该共享的用户
write list = 允许写入该共享的用户
guest ok = 指定该共享是否允许guest账户访问
```

3.建立访问共享资源, 在`Linux7`系统中, Samba服务程序默认使用的是用户口令认证模式,确保仅让有密码且受信任的用户访问共享资源, 不过需要使用`pdbedit`建立账户信息数据库来管理SMB服务程序

```plain
//pdbedit [选项] 账户
//-a 用户名    建立Samba用户
//-x 用户名    删除Samba用户
//-L    列出用户列表
//-Lv   列出用户详细信息的列表
[root@xuliangwei ~]# useradd bgx
[root@xuliangwei ~]# pdbedit -a -u bgx
new password:   //输入密码
retype new password:    //确认密码
```

4.创建用于共享资源的文件目录, 要考虑到文件读写权限的问题

```plain
[root@xuliangwei ~]# mkdir /share/smb -p
[root@xuliangwei ~]# chown -R bgx.bgx /share/smb/
```

5.修改`Samba`服务程序的主配置文件, 可以删除`[homes][printers]`

```plain
[global]
    workgroup = SAMBA
    security = user
    passdb backend = tdbsam
    printing = cups
    printcap name = cups
    load printers = yes
    cups options = raw
//建立共享目录
[share]
 comment = This is share SMB Service
 path = /share/smb
 public = no
 writable = yes
```

6.重启`smb`服务并加入开机自启动

```plain
[root@xuliangwei ~]# systemctl restart smb
[root@xuliangwei ~]# systemctl enable smb
//如果必须开启防火墙, 注意执行如下指令
[root@xuliangwei ~]# firewall-cmd --permanent --add-service=samba
[root@xuliangwei ~]# firewall-cmd --reload
```

## 3.Win挂载Samba

要在`Windows`系统中访问共享资源，只需在我的电脑上方输入

`\\192.168.69.112`然后再加服务器的IP地址即可, 如下图1-1所示:

<!-- OCR_START -->
- 网络192.168.69.112
- 搜索192.168.69.112
- 文件(F)
- 编辑(E)
- 查看(V)
- 工具(T)
- 帮助(H)
- 组织
- 网络和共享中心
- 查看远程打印机
- 下载
- Windows 安全
- 桌面
- 最近访问的位置
- 输入网络密码
- 输入您的密码来连接到：192.168.69.112
- Subversion
- bgx
- 视频
- 图片
- 中工电工业
- 域：XULIANGWEI-PC
- 文档
- 口记住我的凭据
- 音乐
- 登录失败：未知的用户名或错误密码
- 计算机
- 确定
- 取消
- 网络
- 0个对象
<!-- OCR_END -->

图1-1 在Windows系统中访问共享资源

正确输入`bgx`账户名以及使用`pdbedit`命令设置的密码后，就可以登录到共享界面中了，如图1-2所示。此时，我们可以尝试执行查看、写入、更名、删除文件等操作。

<!-- OCR_START -->
- 网络192.168.69.112samba-share
- 搜索samba-share
- 文件(F)
- 编辑（E)
- 查看(V)
- 工具(T)
- 帮助（H)
- 组织?
- 打开
- 打印
- 新建文件夹
- 下载
- 名称
- 修改日期
- 类型
- 大小
- 桌面
- xuliangwei.txt
- 2018/3/31 18:11
- 文本文档
- 0 KB
- 最近访问的位置
- xuliangwei.txt-记事本
- 编辑(E）格式(O)查看(V)
- Subversion
- bgx
- 视频
- 图片
- 文档
- 音乐
- 计算机
- 网络
<!-- OCR_END -->

图1-2 成功访问Samba共享资源

## 4.Linux挂载Samba

`Samba`服务可以实现`Linux`系统之间的文件共享, 在客户端安装支持文件共享服务的软件包`cifs-utils`

1.安装可以访问`samba`资源的客户端

```plain
[root@xuliangwei ~]# yum -y install cifs-utils
```

2.临时查看`SMB`服务端共享资源

```plain
//以匿名身份查看授权资源,直接回车即可
[root@samba-client ~]# smbclient -L 192.168.56.11
Enter SAMBA\root's password:
Anonymous login successful
OS=[Windows 6.1] Server=[Samba 4.6.2]
    Sharename       Type      Comment
    ---------       ----      -------
    samba-share     Disk      This is Share /data/samba/share
    IPC$            IPC       IPC Service (Samba 4.6.2)
//以bgx身份查看授权资源,直接回车即可
[root@samba-client ~]# smbclient -L 192.168.56.11 -U bgx%123
Domain=[SAMBA-SERVER] OS=[Windows 6.1] Server=[Samba 4.6.2]
    Sharename       Type      Comment
    ---------       ----      -------
    samba-share     Disk      This is Share /data/samba/share
    IPC$            IPC       IPC Service (Samba 4.6.2)
    
//直接访问共享
[root@samba-client ~]# smbclient //192.168.56.11 -U bgx%123
```

3.手动挂载`SMB`访问共享

```plain
//建立挂载点
[root@samba-client ~]# mkdir /cifs
//以匿名的身份挂载资源
[root@samba-client ~]# mount -t cifs -o guest //192.168.56.11/samba-share  /cifs
//以账户密码身份挂载
[root@samba-client ~]# mount -t cifs -o rw,user=bgx,pass=123 //192.168.56.11/samba-share  /cifs
```

4.也可以将登陆账户密码保存至配置文件,可以免输入密码去访问挂载

```plain
//创建相应文件, 并赋予安全权限
[root@samba-client ~]# vim /etc/samba/bgx
username=bgx
password=1
domain=MYGROUP
[root@samba-client ~]# chmod 600 /etc/samba/bgx
//挂载时执行用户密码文件credentials=/etc/samba/bgx
[root@samba-client ~]# mount -t cifs -o rw,credentials=/etc/samba/bgx //192.168.56.11/samba-share /cifs
```

5.自动挂载`SMB`共享

```plain
[root@samba-client ~]# vim /etc/fstab
//第一种方式,以用户名密码的方式
//192.168.69.112/samba-share    /cifs   cifs  domain=WORKGROUP,user=bgx,pass=123 0 0
//第二种方式,通过上述的配置文件定义账户与密码以及域
//192.168.69.112/samba-share   /cifs   cifs  credentials=/etc/samba/bgx 0 0
#第二种方式的定义的配置文件
[root@samba-client ~]# vim /etc/samba/bgx
username=bgx
password=1
domain=MYGROUP
```

## 5.SMB多用户挂载

在`Samba Server`服务器上, 共享`/data/samba/public`,实现对访问挂载后的共享的每个用户单独的验证，实现权限隔离。

> 允许bgx1 能够读写
>
> 允许bgx2 能够读
>
> 允许bgx3 不能访问

```plain
//1.创建系统用户
[root@samba-server ~]# useradd bgx1 -s /sbin/nologin
[root@samba-server ~]# useradd bgx2 -s /sbin/nologin
[root@samba-server ~]# useradd bgx3 -s /sbin/nologin
//2.添加系统用户至samba服务
[root@samba-server ~]# pdbedit -a bgx1
[root@samba-server ~]# pdbedit -a bgx2
[root@samba-server ~]# pdbedit -a bgx3
[root@samba-server ~]# pdbedit -L
bgx2:1008:
bgx1:1007:
bgx3:1009:
//3.修改samba配置文件共享目录
[root@samba-server ~]# cat >> /etc/samba/smb.conf <<-EOF
[samba-public]
comment = This is a Share samba-public
path = /data/samba/public
public = no
valid users = bgx1,bgx2
invalid users = bgx3
writable = yes
EOF
//4.创建共享目录, 并设置权限
[root@samba-server ~]# mkdir -p /data/samba/public  -p
[root@samba-server ~]# chown bgx1 /data/samba/public/
//5.使用testparm测试
[root@samba-server ~]# testparm
Processing section "[samba-share]"
Processing section "[samba-public]"
Loaded services file OK.
#testparm命令报错：
rlimit_max: increasing rlimit_max (1024) to minimum Windows limit (16384)
//临时生效
[root@samba-server ~]# ulimit -n 16384
//重启后生效
[root@samba-server ~]# echo "root - nofile 16384" >> /etc/security/limits.conf
//5.重启smb服务
[root@samba-server ~]# systemctl restart smb nmb
[root@samba-server ~]# systemctl enable smb nmb
//6.客户端挂载, 并测试权限
[root@samba-client ~]# mkdir /bgx{1..3}
[root@samba-client ~]# mount -t cifs -o username=bgx1,pass=123 //192.168.69.112/samba-public /bgx1/
[root@samba-client ~]# mount -t cifs -o username=bgx2,pass=123 //192.168.69.112/samba-public /bgx2
[root@samba-client ~]# mount -t cifs -o username=bgx3,pass=123 //192.168.69.112/samba-public /bgx3
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
//7.自动挂载
//挂载属性_netdev是关键选项，网络连通后挂载, 否则容易引起服务器无法启动
[root@samba-client ~]# echo "//192.168.69.112/samba-public /bgx1 cifs defautlts,username=bgx1,password=123,_netdev 0 0" >> /etc/fstab
[root@samba-client ~]# echo "//192.168.69.112/samba-public /bgx2 cifs defautlts,username=bgx2,password=123,_netdev 0 0" >> /etc/fstab
[root@samba-client ~]# echo "//192.168.69.112/samba-public /bgx3 cifs defautlts,username=bgx3,password=123,_netdev 0 0" >> /etc/fstab
```

> 更新: 2019-03-20 19:59:42  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/kg2knn>