# 第七章·Linux用户管理-用户的基本操作

## 用户基本概述

| 什么是用户 |
| :--- |

用户指的是能够正常登录Linux或windows系统

那Linux与windows系统的用户有什么区别？

本质都是登录系统的，只不过Linux支持多用户同时登录，windows默认不支持，但是修改`组策略`的情况下也是可以多用户登录的。

<!-- OCR_START -->
- Superuser
- Group
<!-- OCR_END -->

| Linux下用户有什么作用 |
| :--- |

1）系统上的每一个进程(运行的程序)都需要特定的用户运行

2）每一个文件都有特定的用户拥有，所以访问一个文件或目录受到用户的限制

3）进程能够以何种方式访问某一个文件或目录, 与进程所关联的用户有关

<!-- OCR_START -->
- root:读写执行
- file1
- alice:读
- alice:读写
- XX进程
- file2
- oldboy:只读
- oldboy用户
- alice:只读
- file3
- oldboy:读写执行
<!-- OCR_END -->

| 如何查看系统中所存在的用户 |
| :--- |

*查看当前系统用户信息*

```bash
[root@db04 ~]# id
uid=0(root) gid=0(root) 组=0(root)
[root@db04 ~]# id zls
uid=602(zls) gid=602(zls) 组=602(zls)
```

*每一个文件都有所有者*

```bash
[root@db04 tmp]# ll
总用量 12
drwxr-xr-x 2 zls     zls     4096 6月   2 20:44 zls
drwxr-xr-x 2 oldboy  oldboy  4096 6月   2 20:44 oldboy
drwxr-xr-x 2 student student 4096 6月   2 20:44 student
```

*每一个进程都有用户运行*

```bash
[root@db04 ~]# ps -ef|less
```

***

| 用户相关配置文件 |
| :--- |

用户的信息存放在`/etc/passwd`用户的密码都保存在`/etc/shadow`这两个文件是`linux`系统中最重要的文件之一。

如果没有这两个文件或者这两个文件出问题，会导致无法正常登录`linux`系统。

`/etc/passwd` 账户文件

<!-- OCR_START -->
- [root@zls~]#head-1/etc/passwd
- root:x:0:0:root:/root:/bin/bash
- 以：作为分隔符，总共七列
- root
- /bin/bash
- 用户名称
- 密码占位符
- 用户UID
- 用户GID
- 注释信息
- 用户家目录
- 登录shell
- 第一列
- 第二列
- 第三列
- 第四列
- 第五列
- 第六列
- 第七列
<!-- OCR_END -->

```bash
[root@zls ~]# head -1 /etc/passwd
root:x:0:0:root:/root:/bin/bash
// /etc/passwd由 ':' 为分割符, 分为7个字段，每个字段的具体含义如下:
字段名称               注释说明
1.用户名称             //用户的账号名称
2.密码占位符         //存放账户的口令,暂用x表示,密码保存在/etc/shadow
3.用户的UID        //用户标识号
4.用户基本组GID      //组标识号
5.用户注释          //用户详细信息
6.用户家目录         //root家目录是/root普通用户家目录存在/home/username(可自定义)
7.用户登录Shell     //用户登录Linux使用的shell  #cat /etc/shells
```

***

`/etc/shadow` 用户密码文件

<!-- OCR_START -->
- [root@zls~]#head/etc/shadow
- zls:11:18049:0:99999:7:2:6627567:
- 以：作为分隔符，总共九列
- 第一列：root
- 用户名称
- 第二列：！
- 密码为一长串字符串，！表示没有密码
- 第三列：18049
- 最近一次变更密码，从1970年到现在过了多少天
- 第四列：0
- 密码最少使用天数，0无限制
- 第五列：99999
- 密码最长使用天数，默认99999不过期
- 第六列：7
- 密码到期前，系统会在密码到期前7天提酵变更密码
- 第七列：2
- 密码到期后，密码过期后两天强制提示变更用户密码
- 第八列：6627567
- 账户失效时间，从1970年起，账户在这个日期前可使用，到期后失效
- 第九列：空
- 标志，保留
<!-- OCR_END -->

```bash
[root@zls ~]# tail -1 /etc/shadow
zls1:!!:16312:0:99999:7:::
//  /etc/shadow由 ':' 为分割符, 分为9个字段，每个字段的具体含义如下:
字段名称                       注释说明
1.用户登陆名             //用户的账号名称
2.加密后的密码            //用户密码,这是加密过的口令(未设密码时为!!)
3.最近一次密码更改时间     //从1970年到最近一次更改密码时间之间过了多少天
4.密码最少使用几天        //密码最少使用几天才可以更改密码(0表示无限制)
5.密码最长使用几天      //密码使用多少天需要修改密码(默认99999永不过期)
6.密码到期前警告期限     //密码过期前多少天提醒用户更改密码(默认过期提前7天警告)
7.密码到期后保持活动的天数 //在此期限内, 用户依然可以登陆系统并更改密码, 指定天数过后, 账户被锁定
8.账户到期时间        //从1970年起,账户在这个日期前可使用，到期后失效。
9.标志                        //保留
```

***

| 用户分类（约定，规范） |
| :--- |

| 用户UID | 系统中约定的含义 |
| :--- | :--- |
| 0 | 超级管理员(拥有最高权限) |
| 1-200 | 系统用户，由系统分配给系统进程使用 |
| 201-999 | 系统用户，用来运行服务账户，不需要登陆系统(动态分配) |
| 1000+ | 常规普通用户 |

> 注意: 在CentOS7系统之前, UID1-499用于系统用户, 而UID 500+则用于普通用户

| 使用chage更改用户密码密码使用情况（了解内容） |
| :--- |

```bash
-d //设置最近一次更改密码时间, 0下次登陆系统强制修改密码
-m //设置用户两次改变密码之间使用"最小天数"
-M //设置用户两次改变密码之间使用"最大天数"
-W //设置密码更改警告时间 将过期警告天数设为“警告天数”
-I //设置密码过期天数后, 密码为失效状态
-E //设置用户过期时间, 账户失效后无法登陆
-l //显示用户信息
//修改时间为2014年08月31日,和图中时间匹配,方便后续验证
[root@zls ~]# date -s '20140831'
Sun Aug 31 00:00:00 CST 2014
[root@zls ~]# date
Sun Aug 31 00:00:01 CST 2014
[root@zls ~]# useradd zls1
[root@zls ~]# echo "123" |passwd --stdin zls1
[root@zls ~]# tail -1 /etc/shadow
zls1:!!:16312:0:99999:7:::
//设置最近一次修改密码时间
[root@zls ~]# chage -d "2014-09-01" zls1
[root@zls ~]# tail -n1 /etc/shadow
zls1:!!:16314:0:99999:7:::
//设置最短使用密码时间
[root@zls ~]# chage -m 2 zls1
[root@zls ~]# tail -n1 /etc/shadow
zls1:!!:16314:2:99999:7:::
//设置密码最长使用时间
[root@zls ~]# chage -M 15 zls1
[root@zls ~]# tail -n1 /etc/shadow
zls1:!!:16314:2:15:7:::
//设置密码警告时间
[root@zls ~]# chage -W 6 zls1
[root@zls ~]# tail -n1 /etc/shadow
zls1:!!:16314:2:15:6:::
[root@zls ~]# chage -W 7 zls1
[root@zls ~]# tail -n1 /etc/shadow
zls1:!!:16314:2:15:7:::
//设置密码过期时间
[root@zls ~]# chage -I 5 zls1
[root@zls ~]# tail -n1 /etc/shadow
zls1:!!:16314:2:15:6:5::
//设置用户过期时间
[root@zls ~]# chage -E "20115-08-31" zls1
[root@zls ~]# tail -n1 /etc/shadow
zls1:!!:16314:2:15:6:5:6627567:
[root@zls ~]# chage -l zls1
Last password change            : Sep 01, 2014       //最近一次更改密码时间
Password expires                : Sep 16, 2014      //密码过期时间
Password inactive               : Sep 21, 2014     //密码失效时间
Account expires                 : Aug 31, 2015     //用户失效时间
Minimum number of days between password change      : 2  //密码最短使用时间
Maximum number of days between password change      : 15 //密码最长使用时间
Number of days of warning before password expires   : 7 //密码过期前警告天数
//如何验证,只调整时间为如下进行验证:
1.验证普通用户是否能修改密码, 不需要调整时间。
2.普通用户登陆系统后, 会提示警告密码还剩多少天过期
[root@zls ~]# date -s "2014-09-12"
3.普通用户登陆系统后, 强制要求修改密码
[root@zls ~]# date -s "2014-09-18"
4.普通用户登陆系统后, 提示账户已过期
[root@zls ~]# date -s "2014-09-23"
```

## 用户相关的命令

下面我们就围绕着用户的创建，修改，删除等来讲讲涉及到的命令：

useradd、usermod、userdel

***

| useradd |
| :--- |

使用`useradd`和`adduser`这两个命令，来创建用户

添加用户前需要确定

> 确定用户的默认组是否有特殊要求
>
> 确定用户是否允许登陆
>
> 确定用户的密码策略
>
> 确定用户的有效期
>
> 确定用户的uid是否有特殊要求

1.使用`useradd`命令新增用户, 注意: `adduser`命令软链接指向`useradd`命令

```bash
'-u' 指定用户的UID,不能和现有ID冲突
'-g' 指定用户用户默认基本组
'-G' 指定用户附加组,用逗号隔开添加多个附加组
'-d' 指定用户家目录
'-c' 指定用户注释信息
'-M' 不建立家目录
'-s' 指定用户默认shell
'-r' 创建系统账户, 没有家目录
'-a' 附加组，都留下，配合-G，追加
//创建zls用户,指定UID5001,基本组students 附加组sa,dba 注释信息：one newB user, 登陆的shell:/bin/bash
[root@zls ~]# groupadd sa
[root@zls ~]# groupadd dba
[root@zls ~]# groupadd students
[root@zls ~]# useradd -u 5001 -g students -G sa,dba -c "one newB user" -d /home/zls -s /bin/bash zls
[root@zls ~]# tail -1 /etc/passwd
zls:x:5001:505:one newB user:/home/zls:/bin/bash
//创建系统用户，不建立用户家目录 指定nologin使其用户无法登陆系统
[root@zls ~]# useradd mysql -M -s /sbin/nologin
[root@zls ~]# useradd -r dba -s /sbin/nologin
```

2.使用`usermod`命令修改用户组

```bash
'-u'    修改用户的UID
'-g'    修改用户所属的基本组GID
'-G'    修改用户附加组, 使用逗号隔开多个附加组, 覆盖原有的附加组
'-a'    追加更多的附加组, 必须和-G使用: -aG 追加附加组
'-m'    家目录迁移, 必须和-d一起使用, 移动用户的家目录到新的位置
'-d'    指定用户的家目录新位置  
'-c'    修改用户的注释信息 
'-s'    更改用户使用的shell
'-l'    更改用户登录名
'-L'    锁定用户
'-U'    解锁用户
[root@zls ~]# grep "zls" /etc/passwd
zls:x:5001:505:2018 new student:/home/zls:/bin/bash
//修改用户uid,gid, 附加组, 注释信息, 用户家目录, 登录shell, 登录名
//建立组,指定组gid
[root@zls ~]# groupadd -g 5008 network_sa
[root@zls ~]# groupadd -g 5009 devops
//修改用户属性
[root@zls ~]# usermod -u 6001 -g5008 -a -G 5009 -c "2019 new student" -md /zls -s /bin/sh -l zls_zls zls
//检查是否修改成功
[root@zls ~]# grep "zls" /etc/passwd
zls_zls:x:6001:5008:2019 new student:/zls:/bin/sh
[root@zls ~]# id zls_zls
uid=6001(zls_zls) gid=5008(network_sa) groups=5008(network_sa),503(sa),504(dba),5009(devops)
//验证家目录
[root@zls ~]# ll -d /zls
drwx------. 2 zls_zls network_sa 4096 2014-09-23 00:13 /zls
锁定用户
[root@zls ~]# echo "123" |passwd --stdin zls_zls
[root@zls ~]# usermod -L zls_zls
//无法正常登录系统
➜  ~ ssh zls_zls@192.168.56.11
zls_zls@192.168.56.11's password:
Permission denied, please try again.
解锁用户
[root@zls ~]# usermod -U zls_zls
//正常登录系统
➜  ~ ssh zls_zls@192.168.56.11
zls_zls@192.168.56.11's password:
Welcome to Aliyun Esc Linux
-sh-4.1$
```

当然还有很多命令可以查看用户的信息，以下简单列举一些，都是我们压根不用的，了解即可

1）使用`finger`命令查询永辉信息以及登录信息

```bash
#如果没有则需要安装
[root@db04 ~]# yum install -y finger
#使用方法
[root@db04 ~]# finger zls
Login: zls                      Name:
Directory: /home/zls                    Shell: /bin/bash
Never logged in.
No mail.
No Plan.
```

2）使用`chfn`命令修改用户信息

```bash
#修改用户信息
[root@db04 ~]# chfn zls
Changing finger information for zls.
Name []: 曾老湿
Office []: 老男孩教育
Office Phone []: 13012345678
Home Phone []:
Finger information changed.
#再次查看
[root@db04 ~]# finger zls
Login: zls                      Name: 曾老湿
Directory: /home/zls                    Shell: /bin/bash
Office: 老男孩教育, +1-301-234-5678
Never logged in.
No mail.
No Plan.
```

3）使用`chsh`命令修改用户登录bash shell

```bash
[root@db04 ~]# chsh zls
Changing shell for zls.
New shell [/bin/bash]: /sbin/nologin
Shell changed.
```

4）使用`who`，`whoami`，`w`检查用户登录情况

```bash
[root@db04 ~]# who
root     pts/0        2019-06-20 03:07 (10.0.0.1)
[root@db04 ~]# whoami
root
[root@db04 ~]# w
 14:36:59 up 1 day, 1 min,  1 user,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    10.0.0.1         03:07    0.00s  0.18s  0.00s w
```

3.使用`userdel`删除账户

```bash
语法 : userdel [-r] username //-r 同时删除家目录
[root@zls ~]# userdel user1
[root@zls ~]# ll /home/user1/ -d
drwx------. 3 501 501 4096 2017-11-15 12:40 /home/user1/
//连同家目录一起删除
[root@zls ~]# userdel -r user1
```

### 用户的扩展知识

| 用户的创建流程 |
| :--- |

1）useradd创建用户时，系统会以/etc/login.defs、/etc/defaults/useradd两个配置文件作为参照物，如果在创建用户时指定了参数则会覆盖/etc/login.defs、/etc/defaults/useradd文件的默认配置，如果未指定则使用默认

```bash
#查看配置文件
[root@db04 ~]# less /etc/login.defs
#过滤空行，注释（如何实现）
#参数讲解
#用户的邮件目录
MAIL_DIR    /var/spool/mail
#密码最大天数
PASS_MAX_DAYS   99999
#密码最小天数
PASS_MIN_DAYS   0
#密码最小长度
PASS_MIN_LEN    5
#密码警告天数
PASS_WARN_AGE   7
#普通用户最小uid
UID_MIN                  1000
#普通用户最大uid
UID_MAX                 60000
#系统用户最小uid
SYS_UID_MIN               201
#系统用户最大uid
SYS_UID_MAX               999
#普通用户组最小gid
GID_MIN                  1000
#普通用户组最大gid
GID_MAX                 60000
#系统组最小gid
SYS_GID_MIN               201
#系统组最大gid
SYS_GID_MAX               999
#是否创建家目录
CREATE_HOME                 yes
#权限
UMASK           077
#删除用户时，是否要移除用户组
USERGROUPS_ENAB yes
#密码加密算法
ENCRYPT_METHOD SHA512
#查看useradd配置文件
[root@zls ~]# cat /etc/default/useradd
GROUP=100                 //依赖于/etc/login.defs的USE RGRUUPS_ENAB参数，如果为no，则在此处控制
HOME=/home                      //把用户的家目录建在/home中。
INACTIVE=-1                     //是否启用账号过期停权,-1表示不启用。
EXPIRE=                         //账号终止日期,不设置表示不启用。
SHELL=/bin/bash            //新用户默认所有的shell类型。
SKEL=/etc/skel                  //配置新用户家目录的默认文件存放路径。
CREATE_MAIL_SPOOL=yes       //创建mail文件。
```

2）当使用`useradd`创建用户时，创建的用户家目录下会存在.bash\_\*环境变量相关的文件，这些环境变量默认文件在/etc/skel目录中拷贝。这个默认拷贝环境变量位置是由/etc/defaults/useradd配置文件中定义

企业故障案例

```bash
#在当前用户的家目录下，想要删除所有文件，执行了如下命令
[root@db04 ~]# rm -fr .*
#结果再次登录时
-bash-4.1#
#解决办法
-bash-4.1# cp /etc/skel/.bash* .
#再次登录 即可恢复
[root@db04 ~]#
```

## 用户密码管理

创建完账户后，默认是没有设置密码的，所以该账户是没有办法登陆操作系统。只有使用`passwd`设置好密码后方可登录系统。

使用`passwd`为用户创建密码时，为了安全起见，请尽量设置复杂一些。可以按照如下规则设置密码：

> 1.密码的长度最好大于10位字符
>
> 2.密码中包含大小写字母数字以及特殊字符 `! @ # $`
>
> 3.不规则性（不要出现自己名字、公司名字、自己电话、等等简单的密码)

需要注意:

> 1.普通用户只能更改自己的密码(密码必须满足8位字符)
>
> 2.管理员用户能更改任何人的密码(密码长度无限制)

1.使用`passwd`命令修改用户密码

```bash
语法: passwd [username]
//'passwd'后面不加[username]则是修改当前登陆终端用户的密码。
//如果你登陆的是root管理员用户，后面可以指定要修改的用户。
//只有root管理员才可以修该其他用户的密码，普通账户只能修改自己的密码，并且普通用户没有修改其他用户密码的权限
//root管理员用户登陆，修改root用户密码
[root@localhost ~]# passwd  
更改用户 root 的密码。
新的 密码：
重新输入新的 密码：
passwd：所有的身份验证令牌已经成功更新。
//root用户登陆，修改其他用户的密码
[root@localhost ~]# passwd zls
更改用户 zls 的密码
新的 密码：
重新输入新的 密码：
passwd： 所有的身份验证令牌已经成功更新。
//普通用户修改root管理员密码
[zls@zls ~]$ passwd root
passwd: Only root can specify a user name.
//无需用户交互修改密码, 将前者的输出结果, 成为后者的输入
[root@zls ~]# echo "123" | passwd --stdin zls
Changing password for user zls.
passwd: all authentication tokens updated successfully.
```

2.随机复杂密码生成的方式

```bash
//1.系统内置变量生成随机密码
[root@zls ~]# echo $RANDOM|md5sum|cut -c 1-10
693c116738
[root@zls ~]# echo $(echo $RANDOM|md5sum |cut -c 5-14) |tee pass.txt| passwd --stdin zls
//2.mkpasswd密码生成工具, -l设定密码长度,-d数子,-c小写字母,-C大写字母,-s特殊字符
[root@zls ~]# yum install -y expect   //需要安装扩展包
[root@zls ~]# mkpasswd -l 10 -d 2 -c 2 -C 2 -s 4
|K&13bR)i/
```

3.推荐密码保存工具客户端，支持`windows、MacOS、Iphone`以及浏览器插件

[Lastpass官方网站](https://www.lastpass.com/zh)

## 组的基本管理

组账户信息保存在`/etc/group`和`/etc/gshadow`两个文件中。

`/etc/group` 组账户信息

```bash
[root@zls ~]# head -2 /etc/group
root:x:0:
bin:x:1:bin,daemon
// /etc/group由':' 分割, 分割为4个字段，每个字段的具体含义如下:
字段名称
1.组的名称
2.组的密码(存在/etc/gshadow)
3.组GID信息
4.仅显示附加成员,基本成员不显示
```

`/etc/gshadow` 组密码信息

```bash
[root@zls ~]# head -2 /etc/gshadow
root:::
bin:::bin,daemon
// /etc/gshadow由 ':' 分割, 分割为4个字段，每个字段的具体含义如下:
字段名称
1.组名称
2.组密码
3.组管理员
4.仅显示附加成员,基本成员不显示
```

1.使用`groupadd`命令新增组`groupadd [-g GID] groupname`

```bash
//创建基本组, 不指定gid
[root@zls ~]# groupadd no_gid
[root@zls ~]# tail -n1 /etc/group
no_gid:x:1000:
//创建基本组, 指定gid为5555
[root@zls ~]# groupadd -g 5555 yes_gid
[root@zls ~]# tail -n1 /etc/group
yes_gid:x:5555:
//创建系统组，gid从201-999
[root@zls ~]# groupadd -r sys_group
[root@zls ~]# tail -n1 /etc/group
sys_group:x:990:
```

2.使用`groupmod`命令新增组

```bash
//-g 修改组gid
[root@zls ~]# groupmod -g 1111 no_gid
[root@zls ~]# tail -1 /etc/group
no_gid:x:1111:
//-n 修改组名称
[root@zls ~]# groupmod -n active_group yes_gid
[root@zls ~]# tail -1 /etc/group
active_group:x:5555:
```

3.使用`groupdel`删除组

> 该命令没有特殊选项，如果一个用户有基本组和附加组,只能删除附加组,不能删除基本组

```bash
#删除组
[root@zls ~]# groupdel active_group
#删除用户附加组
[root@docker ~]# id zls
uid=1069(zls) gid=5005(zls) groups=5005(zls),5004(devops)
[root@docker ~]# groupdel devops
[root@docker ~]# id zls
uid=1069(zls) gid=5005(zls) groups=5005(zls)
#无法删除用户基本组
[root@zls ~]# tail -n1 /etc/group
network_sa:x:5008:
[root@zls ~]# groupdel network_sa
groupdel: cannot remove the primary group of user 'zls_zls'
#只有删除用户或者用户变更基本后,方可删除该组
```

4.使用`gpasswd`设置组密码\[了解即可]

```bash
[root@zls ~]# groupadd devops
[root@zls ~]# gpasswd devops
Changing the password for group devops
New Password:
Re-enter new password:
```

5.使用`newgrp`命令切换基本组身份\[了解即可]

```bash
//检查账户信息
[root@docker ~]# useradd zls
[root@docker ~]# id zls
uid=1069(zls) gid=5005(zls) groups=5005(zls)
//切换普通用户
[root@docker ~]# su - zls
//创建新文件,并验证权限
[zls@docker ~]$ touch file_roots
[zls@docker ~]$ ll
-rw-rw-r-- 1 zls zls 0 Jun 13 10:06 file_roots
//切换组信息
[zls@docker ~]$ newgrp devops
Password:
//建立文件,检查权限
[zls@docker ~]$ touch file_test
[zls@docker ~]$ ll
total 0
-rw-rw-r-- 1 zls zls 0 Jun 13 10:06 file_roots
-rw-r--r-- 1 zls devops     0 Jun 13 10:08 file_test
```

## 4.用户身份切换

`Linux`系统中，有时候普通用户有些事情是没办法操作，除非是`root`管理员用户才能做到。这时就需要临时切换到`root`管理员身份来做事了。那么在学习如何切换用户之前,我们先来了解下用户工作环境。

如何在普通用户的情况下，完成日常工作？

1）`su` 切换用户，使用普通用户登录，然后使用su命令切换到root。

优点：简单，方便

缺点：需要知道root密码,不安全，切换到root没有日志审计功能

2）`sudo` 提权，当需要使用root权限时，进行提权，而无需切换至root用户。

优点：安全，方便

缺点：复杂

1.`Shell`分类

```bash
交互式shell    //等待用户输入执行的命令(终端操作,需要不断提示)
非交互式shell   //执行shell脚本, 脚本执行结束后shell自动退出
登陆shell     //需要输入用户名和密码才能进入shell su - zls
非登陆shell    //不需要输入用户和密码就能进入,比如执行sh, bash, su username
//查看登陆shell
[root@zls ~]# pstree
//临时设置,永久设置需要写配置文件
[root@zls ~]# export PS1='[\h@\u \t]#'
[zls@root 02:06:28]#
```

2.`bash shell`配置文件

```bash
Bash的配置文件保存用户的工作环境
个人配置文件： ~/.bash_profile ~/.bashrc
全局配置文件：/etc/profile /etc/profile.d/*.sh /etc/bashrc
profile类文件, 设定环境变量, 登陆前运行的脚本和命令
bashrc 类文件, 设定本地变量, 定义命令别名
全局配置和个人配置设置冲突, 优先使用个人配置准
```

3.`shell`配置文件应用顺序

```bash
//登录式shell配置文件执行顺序
/etc/profile->/etc/profile.d/*.sh->~/.bash_profile->~/.bashrc->/etc/bashrc
//非登陆式shell配置文件执行顺序
~/.bashrc->/etc/bashrc->/etc/profile.d/*.sh
#验证登陆shell和非登陆shell配置文件执行顺序, 在每个配置文件加入一段 “echo”即可。
#最后通过登陆shell和非登录shell方式登陆linux, 即可验证执行顺序。
```

扩展登录提示信息

```bash
_ooOoo_
                  o8888888o
                  88" . "88
                  (| -_- |)
                  O\  =  /O
               ____/`---'\____
             .'  \\|     |//  `.
            /  \\|||  :  |||//  \
           /  _||||| -:- |||||-  \
           |   | \\\  -  /// |   |
           | \_|  ''\---/''  |   |
           \  .-\__  `-`  ___/-. /
         ___`. .'  /--.--\  `. . __
      ."" '<  `.___\_<|>_/___.'  >'"".
     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
     \  \ `-.   \_ __\ /__ _/   .-` /  /
======`-.____`-.___\_____/___.-`____.-'======
                   `=---='
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            佛祖保佑       永不宕机
      https://www.driverzeng.com
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                       .   ' \\| |// `.
//                        / \\||| : |||// \
//                       / _||||| -:- |||||- \
//                         | | \\\ - /// | |
//                        | \_| ''\---/'' | |
//                        \ .-\__ `-` ___/-. /
//                      ___`. .' /--.--\ `. . __
//                   ."" '< `.___\_<|>_/___.' >'"".
//                  | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                  \ \ `-. \_ __\ /__ _/ .-` / /
//          ======`-.____`-.___\_____/___.-`____.-'======
//                              `=---='
//
//          .............................................
//          佛祖镇楼                  BUG辟易
//          佛曰:
//          写字楼里写字间，写字间里程序员；
//          程序人员写程序，又拿程序换酒钱。
//          酒醒只在网上坐，酒醉还来网下眠；
//          酒醉酒醒日复日，网上网下年复年。
//          但愿老死电脑间，不愿鞠躬老板前；
//          奔驰宝马贵者趣，公交自行程序员。
//          别人笑我忒疯癫，我笑自己命太贱；
//          不见满街漂亮妹，哪个归得程序员？
/**
 *　　　　　　　 ┏┓　 ┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　┃ 　
 *　　　　　　　┃　　　━　　 ┃ ++ + + +
 *　　　　　　 ████━████  ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　 ┃　　　┃　　　　　　　　　　　
 *　　　　　　　　 ┃　　　┃ + + + +
 *　　　　　　　　 ┃　　　┃　　　　Code is far away from bug with the animal protecting　　　　　　　
 *　　　　　　　　 ┃　　　┃ + 　　　　神兽保佑,代码无bug　　
 *　　　　　　　　 ┃　　　┃
 *　　　　　　　　 ┃　　　┃　　+　　　　　　　　　
 *　　　　　　　　 ┃　 　 ┗━━━┓ + +
 *　　　　　　　　 ┃ 　　　　   ┣┓
 *　　　　　　　　 ┃ 　　　　　 ┏┛
 *　　　　　　　　 ┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　  ┃┫┫ ┃┫┫
 *　　　　　　　　  ┗┻┛ ┗┻┛+ + + +
 */
```

4.如果全局配置和个人配置出现冲突, 那么如何验证呢？

```bash
编辑全局配置 /etc/profile     新增一行： PS1='[\h@\u \t]#'
[zls@root 02:16:57]#     //当前终端shell环境
编辑个人配置 ~/.bash_profile     新增一行： PS1='[\u@\H]#'
[zls@root 02:18:27]#su  zls_zls
[zls_zls@zls root]$
[zls@root 02:18:34]# su - zls_zls
[zls_zls@zls.com]#
```

5.创建用户，并登录系统

```bash
[root@zls ~]# useradd zls
[root@zls ~]# echo "123"|passwd --stdin zls
//使用zls用户登录当前Linux系统
➜  ~ ssh zls@192.168.56.111
zls@192.168.56.111's password:
[zls@zls ~]$
//可以使用whoami查看当前登录用户
[zls@zls ~]$ whoami
zls
```

6.切换用户，使用命令`su [-] username`

su命令后面跟`-`代表进入登陆式`shell` 如果su命令后不加`-`代表进入非登陆式`shell`，他们之间的区别在于加载的环境变量不一样。

> 普通用户`su -`代表直接切换至`root`用户身份, 但需要输入`root`用户密码。
>
> 超级管理员`root`用户使用`su - username`切换普通用户不需要输入任何密码。

```bash
[zls@zls ~]$ pwd
/home/zls
//不加 '-' 切换到root账户下时，当前目录没有变化
[zls@zls ~]$ su
密码：
[root@zls zls]# pwd
/home/zls
[root@zls zls]# exit
exit
//加 '-'切换到root账户，当前目录为root账户的家目录。
[zls@zls ~]$ su -
密码：
[root@zls ~]# pwd
/root
```

3.以某个用户的身份执行某个服务，使用命令`su -c username`

```bash
[root@zls ~]# su - zls -c 'ifconfig'
[root@zls ~]# su - zls -c 'ls ~'
```

## 5.用户身份提权

`su`命令在切换用户身份时，如果每个普通用户都能拿到`root`用户的密码，当其中某个用户不小心泄漏了`root`的密码，那系统会变得非常不安全。

为了改进这个问题，从而产生了`sudo`这个命令。

`sudo`执行一个仅有`root`身份才能执行的命令是可以办到的，但是需要输入密码，这个密码并不是`root`的密码而是用户自己的密码。

默认只有`root`用户能使用`sudo`命令，普通用户想要使用`sudo`需要`root`预先设定，即使用 `visudo`命令去编辑相关的配置文件`/etc/sudoers`

`Centos7`提权

```bash
[root@zls ~]# usermod zls -G wheel
//日志审计
[root@zls ~]$ sudo tail -f /var/log/secure
```

`CentOS6`提权

```bash
#1.系统安装后就有sudo命令，如果没有sudo命令，可通过如下方式安装
[root@zls ~]# yum install -y sudo
#2.使用`visudo`命令编辑sudo配置文件, 相当于 vim /etc/sudoers`配置文件
[root@zls ~]# visudo  #会对配置进行验证
zls ALL=(ALL) /bin/rm, /bin/cp  #新增
#3.配置选项详解
1.用户名      2.主机名   3.角色名       4.命令名
root            ALL=    (ALL)           ALL
zls      ALL     使用最高角色执行    /bin/rm, /bin/cp #允许使用sudo执行命令
zls   ALL=(ALL)  NOPASSWD:/bin/cp, /bin/rm   //不需要密码使用rm、cp命令
#4.使用visudo -c检查配置文件
[root@zls ~]# visudo  -c
/etc/sudoers: parsed OK
```

4.普通用户验证`sudo`权限

```bash
#1.切换普通用户
[root@zls ~]# su - zls
#2.检查普通用户sudo权限明细
[zls@zls ~]$ sudo -l
...
User zls may run the following commands on this host:
    (ALL) /bin/rm, (ALL) /bin/cp
#3.普通用户删除opt目录,删除失败
[zls@zls ~]$ rm -rf /opt/
rm: cannot remove `/opt': Permission denied
#4.使用sudo提权，验证用户权限是否可用，需要输入普通用户的密码
[zls@zls ~]$ sudo rm -rf /opt
```

5.sudo免密码配置选项

```bash
#1.普通用户执行sudo不需要输入密码配置
[root@zls ~]# visudo
zls ALL=(ALL) /bin/rm, /bin/cp  #默认
zls   ALL=(ALL)  NOPASSWD:/bin/rm, /bin/cp  #修改后
#2.默认普通用户无权删除
[zls@zls ~]$ rm -f /root/002
rm: cannot remove `/root/002': Permission denied
#3.验证sudo免密码执行权限
[zls@zls ~]$ sudo rm -f /root/002
```

6.`sudo`配置组

```bash
//如果每增加一个用户需配置一行sudo，这样设置非常麻烦。所以可以进行如下设置
%zls  ALL=(ALL)     NOPASSWD:/bin/rm, /bin/cp  #新增组
//group1这个组的所有用户都拥有sudo的权力。接下来只需要将用户加入该组即可。
//创建用户加入该组
[root@zls ~]# groupadd zls
[root@zls ~]# useradd zls1 -g zls
[root@zls ~]# useradd zls2 -g zls
//root用户建立目录
[root@zls ~]# mkdir /root/zls_sudo
//切换用户并删除测试
[root@zls ~]# su - zls1
[zls1@zls ~]$ rm -rf /root/zls_sudo
rm: cannot remove `/root/zls_sudo': Permission denied
//使用sudo
[zls1@zls ~]$ sudo rm -rf /root/zls_sudo
```

当然配置文件`/etc/sudoers`包含了诸多配置项，可以使用命令`man sudoers`来获得帮助信息。

下面介绍一个很实用的案例，我们的需求是将`Linux`服务器设置成如下:

1.仅允许使用普通账户登陆`Linux`服务器，禁止root直接登录

2.可以让普通用户不输入密码就能`sudo su -`切换到`root`账户

```bash
//禁止root用户登陆
[root@zls ~]# sed -i  's@#PermitRootLogin yes@PermitRootLogin no@g' /etc/ssh/sshd_config
[root@zls ~]# systemctl restart sshd
//配置sudo权限
[root@zls ~]# visudo
User_Alias USER_SU = zls1,zls2,zls
Cmnd_Alias SU = /bin/su
USER_SU ALL=(ALL) NOPASSWD:SU
//使用root登陆服务器失败
➜  ~ ssh root@192.168.56.11
root@192.168.56.11's password:
Permission denied, please try again.
//使用普通用户登陆服务器
➜  ~ ssh zls@192.168.56.11
zls@192.168.56.11's password:
Last login: Mon Oct 30 09:28:21 2017 from 192.168.56.2
//使用sudo提权至root用户
[zls@zls ~]$ sudo su -
[root@zls ~]#
```

7.`sudo`执行流程:

> 1.普通用户执行sudo命令, 会检查/var/db/sudo是否存在时间戳缓存
>
> 2.如果存在则不需要输入密码, 否则需要输入用户与密码
>
> 3.输入密码会检测是否该用户是否拥有该权限
>
> 4.如果有则执行，否则报错退出

<!-- OCR_START -->
- 普通用户运行sudo
- 检查/var/db/sudo
- 下是否有时间文
- 过期
- 件，并检查是否过
- 输入用户自
- 未过期
- 己的口令
- 检查/etc/sudoers
- 配置文件是否有运
- 行sudo和执行相应
- 命令的权限
- 有权限
- 无权限
- 执行命令并返回结果
- 退出sudo
- sudo执行流程
<!-- OCR_END -->

> 更新: 2024-09-20 22:07:48  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/yvmuc9>