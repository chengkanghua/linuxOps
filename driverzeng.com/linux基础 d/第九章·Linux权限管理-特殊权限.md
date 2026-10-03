# 第九章·Linux权限管理-特殊权限

## Linux系统特殊权限概述

之前我们已经讲过r（读）、w（写）、x（执行）这三种普通全年，但是我们在查询系统文件权限时会发现出现了一些其他的权限字母

例：

```bash
[root@db04 ~]# ll /usr/bin/passwd
-rwsr-xr-x. 1 root root 30768 2月  22 2012 /usr/bin/passwd
[root@db04 ~]# ll /usr/bin/write
-rwxr-sr-x. 1 root tty 12016 11月 22 2013 /usr/bin/write
[root@db04 ~]# ll /tmp/ -d
drwxrwxrwt. 3 root root 4096 6月  21 03:19 /tmp/
```

### 特殊权限suid介绍

在属主本来应该是x（执行）权限的位置上出现了一个小写s，这是什么权限？

我们把这种权限称作：SetUID权限，也叫做SUID的特殊权限，这种权限有什么作用呢？

或者说，这种权限能干点啥？为啥会有这种权限？

| SetUID权限 |
| :--- |

在Linux系统中，每个普通用户都可以更改自己的密码，这是合理的设置，问题是，普通哦用户的信息保存在 /etc/passwd文件中，与用户的密码在 /etc/shadow 文件中，也就是说，普通用户在更改自己密码时，修改了 /etc/shadow 文件中的加密密码，但是文件权限显示。普通用户对这两个文件都没有写权限。

```bash
[root@db04 ~]# ll /etc/passwd /etc/shadow
-rw-r--r--. 1 root root 5962 6月  20 19:32 /etc/passwd
----------. 1 root root 4089 6月  20 19:32 /etc/shadow
```

那么请问，为什么普通用户可以修改自己的密码，并将修改后的密码，写入 /etc/shadow 文件中呢？

其实，普通用户可以修改自己的密码，在于`passwd`命令，该命令拥有特殊权限，SetUID，也就是咱们看到的，在属主的权限位的执行权限上是 s 。

可以这样理解：当一个具有执行权限的文件设置了SetUID权限后，用户在执行这个文件时，将以文件所有者身份来执行，你懂我意吧？

还是不懂？那就再说详细一点，当...普通用户使用`passwd`命令来更改自己的密码时，实际上是在用`passwd`命令的所有者，所有者是谁？就是root的身份在执行`passwd`命令。那root，当然可以将密码写入 /etc/shadow 文件中了啊，所以普通与用户也可以修改 /etc/shadow文件，命令执行完成后该身份也就消失了。

有一个用户 lamp 她可以修改自己的权限，因为passwd命令有SetUID权限，但是她不能查看/etc/shadow文件内容，因为查看文件的命令例如，cat，没有SetUID权限：

```bash
#创建lamp用户
[root@db04 ~]# useradd lamp
#给密码1
[root@db04 ~]# echo 1 |passwd --stdin lamp
更改用户 lamp 的密码 。
passwd： 所有的身份验证令牌已经成功更新。
#切换lamp用户
[root@db04 ~]# su - lamp
#修改密码为123@qqdianCOM
[lamp@db04 ~]$ passwd
Changing password for user lamp.
Changing password for lamp.
(current) UNIX password:1
New password:123@qqdianCOM
Retype new password:123@qqdianCOM
passwd: all authentication tokens updated successfully.
#查看/etc/shadow
[lamp@db04 ~]$ cat /etc/shadow
cat: /etc/shadow: Permission denied
#给cat命令授权 SetUID 权限
[root@db04 ~]# chmod 4755 /bin/cat
#查看cat权限
[root@db04 ~]# ll /bin/cat
-rwsr-xr-x. 1 root root 48568 11月 22 2013 /bin/cat
#切换用户
[root@db04 ~]# su - lamp
#再次查看/etc/shadow
[lamp@db04 ~]$ cat /etc/shadow
root:$6$TBgaEEzA$TZLUb9QLtM26nvQwjfALLeubnlg1Y1TJLiwcfYxzsZthSmTZmCkg3osOJn1rAAmTVuWsI0H.OTLVanAej2Jdl0:18067:0:99999:7:::
```

<!-- OCR_START -->
- /usr/bin/passwd
- 权限：-rwsr-xr-x
- 由user变成root
- 执行
- 特殊：SUID
- 程序所有者：root
- /etc/shadow
- /bin/cat
- user
- 还是user
- 特殊：无
<!-- OCR_END -->

| 授权SetUID |
| :--- |

```bash
#在有执行权限的情况下是 s，没有执行权限的情况下是 S
[root@db04 ~]# chmod u+s /bin/cat
[root@db04 ~]# chmod 4755 /bin/cat
```

| SUID的作用 |
| :--- |

1.让普通用户对可执行的二进制文件，临时拥有二进制文件的所属权限

2.如果设置的二进制文件没有执行权限，那么suid的权限显示就是S

3.特殊权限suid仅对二进制课执行程序有效，其他文件或目录则无效

注意：suid极其危险，不信可以尝试对vim或者rm命令进行设定suid

### 特殊权限sgid介绍

| SetGID权限 |
| :--- |

将目录设置为SGID后，如果在该目录下创建文件，都将与该目录的所属组保持一致

<!-- OCR_START -->
再举个栗子
nttps://www.driverzeng.com
<!-- OCR_END -->

对不起...举错了，但是不重要

```bash
#创建一个目录
[root@db04 ~]# mkdir /tmp/test
#赋予sgid权限
[root@db04 ~]# chmod g+s /tmp/test/
#查看目录权限
[root@db04 ~]# ll /tmp/test/ -d
drwxr-sr-x 2 root root 4096 6月  21 16:26 /tmp/test/
#使用root用户创建文件
[root@db04 ~]# touch /tmp/test/root_file
#查看文件
[root@db04 ~]# ll /tmp/test/
总用量 0
-rw-r--r-- 1 root root 0 6月  21 16:30 root_file
#切换用户
[root@db04 ~]# su - lamp
#创建文件
[lamp@db04 ~]$ touch /tmp/test/lamp_file
touch: cannot touch `/tmp/test/lamp_file': Permission denied
#赋予目录777权限
[root@db04 ~]# chmod 777 /tmp/test/
#查看目录权限
[root@db04 ~]# ll -d /tmp/test/
drwxrwsrwx 2 root root 4096 6月  21 16:26 /tmp/test/
#切换至普通用户
[root@db04 ~]# su - lamp
#创建文件
[lamp@db04 ~]$ touch /tmp/test/lamp_file
#查看权限
[lamp@db04 ~]$ ll /tmp/test/lamp_file
-rw-rw-r-- 1 lamp root 0 Jun 21 16:34 /tmp/test/lamp_file
#讲test目录属主和属组改为oldboy
[root@db04 ~]# chown oldboy.oldboy /tmp/test/
#查看权限
[root@db04 ~]# ll -d /tmp/test/
drwxrwsrwx 2 oldboy oldboy 4096 6月  21 16:34 /tmp/test/
#切换用户
[root@db04 ~]# su - lamp
#创建文件
[lamp@db04 ~]$ touch /tmp/test/lamp_file2
#查看文件权限
[lamp@db04 ~]$ ll /tmp/test/lamp_file2
-rw-rw-r-- 1 lamp oldboy 0 Jun 21 16:35 /tmp/test/lamp_file2
```

| SetGID权限设置 |
| :--- |

```bash
[root@db04 ~]# chmod 2755 /tmp/test/
[root@db04 ~]# chmod g+s /tmp/test/
```

| SetGID的作用 |
| :--- |

1.针对用户组权限位修改，用户创建的目录或文件所属组和该目录的所属组一致。

2.当某个目录设置了sgid后，在该目录中新建的文件不在是创建该文件的默认所属组

3.使用sgid可以使得多个用户之间共享一个目录的所有文件变得简单。

练习sgid：

创建三个用户，分别是`zls`,`oldboy`,`yourname`这些用户都属于`oldboyedu`组的成员。这些用户的密码都是`123`

1.要求以上用户和组可以在`/home/oldboyedu`目录里访问，创建，删除文件

2.其他用户一律不允许访问该目录

3.在该目录下新建的文件会自动属于`oldboyedu`组拥有

### 特殊权限sbit介绍

`sticky`（SI TI KI）粘滞，目前只对目录有效，作用如下：

普通用户对该目录拥有w和x权限，即普通用户可以在此目录中拥有写入权限，如果没有粘滞位，那么普通用户拥有w权限，就可以删除此目录下的所有文件，包括其他用户简历的文件。但是一旦被赋予了粘滞位，除了root可以删除所有文件，普通用户就算有w权限也只能删除自己建立的文件，而不能删除其他用户简历的文件。

系统中存在的`/tmp`目录是经典的粘滞位目录，谁都有写权限，因此安全成问题，常常是木马第一手跳板。

| sticky授权方法 |
| :--- |

```bash
[root@db04 ~]# chmod 1755 /opt
[root@db04 ~]# chmod o+t /opt
```

| sticky的作用 |
| :--- |

1.让多个用户都具有写权限的目录，并让每个用户只能删自己的文件。

2.特殊sticky目录表现在others的x位，用小t表示，如果没有执行权限是T

3.一个目录即使它的权限为"777"如果是设置了粘滞位，除了目录的属主和"root"用户有权限删除，除此之外其他用户都不允许删除该目录。

## Linux权限属性chattr概述

`chattr`只有root用户可以使用，用来修改文件系统的权限属性，建立凌驾于rwx基础权限之上的授权

`chattr`命令格式：\[root@db04 ~]# #chattr \[+-=]\[选项] 文件名或目录名

设置文件属性(权限)，针对所有用户，包括 root

```bash
#选项：+增加权限 -减少权限 =等于某个权限
#a：让文件或目录仅可追加内容
#i：不得任意更动文件或目录
#创建文件并设置属性
[root@zls ~]# touch file_a file_i
[root@zls ~]# lsattr file_a file_i
---------------- file_a
---------------- file_i
#设置属性
[root@zls ~]# chattr +a file_a
[root@zls ~]# chattr +i file_i
[root@zls ~]# lsattr file_a file_i
-----a---------- file_a
----i----------- file_i
#a权限, 无法覆盖写入和删除文件
[root@zls ~]# echo "aa" > file_a
bash: file_a: Operation not permitted
[root@zls ~]# rm -f file_a
rm: cannot remove ‘file_a’: Operation not permitted
#a权限, 只能追加, 适用于日志文件
[root@zls ~]# echo "aa" >> file_a
#i权限, 无法写入, 无法删除
[root@zls ~]# echo "i" > file_i
bash: file_i: Permission denied
[root@zls ~]# echo "i" >> file_i
bash: file_i: Permission denied
[root@zls ~]# rm -f  file_i
rm: cannot remove ‘file_i’: Operation not permitted
#解除限制
[root@zls ~]# chattr -a file100 
[root@zls ~]# chattr -i file200
```

## Linux进程掩码umask

| 什么是umask |
| :--- |

当我们登录系统之后，创建一个文件总是有一个默认权限，比如：

目录默认权限：755

文件默认权限：644

那么这个权限是怎么来的呢？

不瞒你说，这就是umask做的，umask设置了用户创建文件的默认权限。

| umask是如何改变新文件的权限 |
| :--- |

系统默认umask为022，那么当我们创建一个目录时，正常情况下目录的权限应该是777，但是umask表示要减去的值，所以新目录文件的权限应该是777-022=755。至于文件的权限也依次类推：666-022=644

| umask涉及到的配置文件 |
| :--- |

`umask`涉及到的相关文件`/etc/bashrc /etc/profile ~/.bashrc ~/.bash_profile`

> 注意umask影响的范围
>
> shell (vim,touch) --umask--> 新文件或目录权限
>
> vsftpd --umask--> 新文件或目录权限
>
> samba --umask--> 新文件或目录权限
>
> useradd --umask--> 用户 HOME

```bash
1.假设umask值为：022（所有位为偶数）
//文件的起始权限值
6 6 6  -  0 2 2  = 6 4 4 
2.假设umask值为：045（其他用户组位为奇数）
//计算出来的权限。由于umask的最后一位数字是5，所以，在其他用户组位再加1。
6 6 6  -   0 4 5 = 6 2 1
3.默认目录权限计算方法
7 7 7  -  0 2 2 = 7 5 5

umask  是035 系统文件的默认权限是？ 目录权限是？
文件 666-035=631 + 011 =642   奇数加1
目录 777-035=742
 
umask 044    //umask所有位全为偶数时
示例：mkdir d044   //目录733
示例：touch f044   //文件622
umask 023    //umask值的部分或全部位为奇数时
示例：mkdir d023   //目录754
示例：touch f023   //文件644
umask 035    //umask值的所有位为奇数时
示例：mkdir d035   //目录742
示例：touch f035   //文件642
```

示例1: 在`shell`进程中创建文件

```bash
//查看当前用户的umask权限
[root@zls ~]# umask
0022
[root@zls ~]# touch file0022
[root@zls ~]# mkdir dir0022
[root@zls ~]# ll -d file0022  dir0022/
drwxr-xr-x 2 root root 6 Jan 24 09:02 dir0022/
-rw-r--r-- 1 root root 0 Jan 24 09:02 file0022
```

示例2: 修改`shell umask`值(临时生效)

```bash
[root@zls ~]# umask 000
[root@zls ~]# mkdir dir000
[root@zls ~]# touch file000
[root@zls ~]# ll -d dir000 file000
drwxrwxrwx 2 root root 6 Jan 24 09:04 dir000
-rw-rw-rw- 1 root root 0 Jan 24 09:04 file000
```

示例3: 修改`shell umask`值(永久生效, 强烈不建议修改)

```bash
[root@zls ~]# vim /etc/profile
if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then 
umask 002
else
umask 022
fi
//立即在当前 shell 中生效
[root@zls ~]# source /etc/profile
```

示例4: 通过`umask`决定新建用户`HOME`目录的权限

```bash
[root@zls ~]# vim /etc/login.defs
UMASK 077
[root@zls ~]# useradd dba
[root@zls ~]# ll -d /home/dba/
drwx------. 4 dba dba 4096 3 月 11 19:50 /home/dba/
[root@zls ~]# vim /etc/login.defs
UMASK 000
[root@zls ~]# useradd sa
[root@zls ~]# ll -d /home/sa/
drwxrwxrwx. 4 sa sa 4096 3 月 11 19:53 /home/sa/
```

示例 5:例如`vsftpd`进程`/etc/vsftpd/vsftpd.conf`

```bash
[root@zls ~]# yum -y install vsftpd
[root@zls ~]# man vsftpd.conf
anon_umask
local_umask
```

> 更新: 2024-09-21 14:31:45  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/yqfdgd>