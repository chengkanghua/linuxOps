# 第八章·Linux权限管理-基本权限

## 权限的基本概述

| 什么是权限？ |
| :--- |

我们可以把他理解为操作系统对用户能够执行的功能所设立的限制，主要用于约束用户能对系统所做的操作，以及内容访问的范围，或者说，权限是指某个特定的用户具有特定的系统资源使用权利。

***

| 为什么要有权限？ |
| :--- |

因为在公司中，服务器可能就那么几台，但是运维可能有多个，我们多个运维要登录同一台服务器，那么不可能只有一个root用户，我们需要根据运维的等级，来分配用户权限。

***

| 权限与用户的关系？ |
| :--- |

Linux中的文件或目录的权限和用户及用户组关联很大，Linux中每个文件或目录都有一组共9个基础权限位，每三个字符被分为一组，他们分别是属主权限位(占三个字符)、属组权限位(占三个字符)、其他用户权限位(占三个字符)

比如`rwxr-xr-x` linux中正是这9个权限位来控制文件属主(User)、属组(Group)、其他用户(Other)基础权限。

每种身份，又对应了3种权限：r（readable）、w（writeable）、x（excutable）

> rwx, rwx, r-x
>
> User Group Other

**权限与属主属组**

<!-- OCR_START -->
- 属组权限位
- rwxr-xr-x
- rootroot
- zls.txt
- 其他用户权限位
- 属主权限位
<!-- OCR_END -->

> //用户对资源来说, 有三种角色
>
> User(u): 属主用户(文件所有者)
>
> Group(g): 属组用户(包含组成员)
>
> Other(o): 其他用户
>
> //一个用户访问文件流程如下
>
> 判断用户是否为文件的所有者,如果是,按所有者的权限进行访问
>
> 判断是否为文件的所有组成员,如果是,就按组的权限去访问
>
> 最终用户就是文件的其他的人,按其他人的权限去访问

***

| 权限中的rwx分别代表什么含义？ |
| :--- |

当我们使用`ls -l`查看一个文件的详细属性时，能看到每个文件都有一个9位基本权限位

比如：`rwxr-xr-x`其中每三位字符为一组，分别表示属主权限位，属组权限位，其他用户权限位。

| 字母 | 含义 | 对应权限 |
| :--- | :--- | :--- |
| r(read) | 读取权限 | 4 |
| w(write) | 写入权限 | 2 |
| x(execute) | 执行权限 | 1 |
| -(没有权限) | 没有权限 | 0 |

如果权限位不可读、不可写、不可执行，则用-来表示。

***

| 权限设置示例 |
| :--- |

文件权限示例：

```bash
[root@db04 ~]# ls -l /opt/
-rw-r-xr-- 1 zls oldboy 1048576 6月   1 12:48 zls_file1.txt
```

1\)zls对文件的权限是什么？

2\)oldboy对文件的权限是什么？

3\)qiudao对文件的权限是什么？（qiudao属于oldboy组）

4\)zls对文件的权限是什么？

## 权限修改命令chmod

+:增加权限

-:删除权限

\=:设置权限

```bash
#ugo方式
chmod   //修改文件目录权限rwx  -R级联修改
[root@db04 ~]# touch file
[root@db04 ~]# chmod a=rwx file
[root@db04 ~]# chmod a+rwx file
[root@db04 ~]# ll file
-rwxrwxrwx 1 root root 0 6月  20 23:23 file
[root@db04 ~]# chmod a-rwx file
[root@db04 ~]# chmod a=-rwx file
[root@db04 ~]# ll
总用量 0
---------- 1 root root 0 6月  20 23:23 file
[root@db04 ~]# chmod u+rw,g+r,o+rx file
[root@db04 ~]# ll
总用量 0
-rwxrwxrwx 1 root root 0 6月  20 23:23 file
[root@db04 ~]# chmod u=rwx,g=rw,o=rx file
[root@db04 ~]# ll
总用量 0
-rwxrw-r-x 1 root root 0 6月  20 23:23 file
```

```bash
#number方式
mkdir dir       //建立目录
touch dir/file  //建立文件
示例1：
chmod 777 dir/   //修改dir目录权限为777
chmod u+rwx,g+rwx,o+rwx 
示例2：
chmod 666 dir/file     //修改file文件权限为666
chmod u+rw,g+rw,o+rw 
示例3：
chmod -R 766 dir/  //修改目录及子目录权限
```

## 基础权限设置案例

| 权限 | 对文件的影响 | 对目录的影响 |
| :--- | :--- | :--- |
| 读取权限（r） | 具有读取\阅读文件内容权限 | 具有浏览目录及子目录 |
| 写入权限（w） | 具有新增、修改文件内容的权限 | 具有增加和删除目录内文件 |
| 执行权限（x） | 具有执行文件的权限 | 具有访问目录的内容(取决于目录中文件权限) |

**文件权限实验案例:**

```bash
//默认文件匿名用户仅有读权限
[root@zls ~]# echo "date" >> filename
[root@zls ~]# ll filename
-rw-r--r-- 1 root root 5 Jan 24 08:24 filename
//测试读权限(无法执行或删除)
[root@zls ~]# su - zls
[zls@zls ~]$ cat  /root/filename
date
//增加x执行权限
[root@zls ~]# chmod o+x /root/filename
[root@zls ~]# ll /root/filename
-rw-r--r-x 1 root root 5 Jan 24 08:24 /root/filename
//测试执行权限
[zls@zls ~]$ /root/filename
Wed Jan 24 08:28:34 EST 2018
//增加w执行权限
[root@zls ~]# chmod o+w /root/filename
[root@zls ~]# ll /root/filename
-rw-r--rwx 1 root root 5 Jan 24 08:24 /root/filename
//测试执行权限
[zls@zls ~]$ vim /root/filename
```

`rwx`对文件的影响(只对文件内容有影响)

> r：只读
>
> w：只写，会覆盖之前的内容
>
> x：什么也没有，没办法操作

***

> 文件权限需要组合：
>
> rw： 文件可读可写，不能执行
>
> rx： 文件可读，不可写，可以执行
>
> rwx：文件可读，可写，也可以执行

**目录权限实验案例:**

```bash
实战案例1: 对目录没有w，对文件有rwx 
[root@zls ~]# mkdir /dirname
[root@zls ~]# echo "test" >> /dirname/filename
[root@zls ~]# chmod 777 /dirname/filename
[root@zls ~]# ll -d /dirname/
drwxr-xr-x 2 root root 22 Jan 24 08:40 /dirname/
[root@zls ~]# ll -d /dirname/filename
-rwxrwxrwx 1 root root 5 Jan 24 08:41 /dirname/filename
//普通用户验证权限
[zls@zls ~]$ cat /dirname/filename
test
[zls@zls ~]$ rm -f /dirname/filename
rm: cannot remove ‘/dirname/filename’: Permission denied
实战案例2: 对目录有w，对文件没有任何权限
[root@zls ~]# chmod 777 /dirname/
[root@zls ~]# chmod 000 /dirname/filename
[root@zls ~]# ll -d /dirname/
drwxrwxrwx 2 root root 22 Jan 24 08:40 /dirname/
[root@zls ~]# ll -d /dirname/filename
---------- 1 root root 5 Jan 24 08:41 /dirname/filename
file_zls//普通用户验证权限
[zls@zls ~]$ cat /dirname/filename
cat: /dirname/filename: Permission denied
[zls@zls ~]$ rm -f /dirname/filename
[zls@zls ~]$ touch /dirname/filename_2
```

`rwx`对目录的影响

> 目录只有r权限: 具有浏览目录及子目录权限
>
> 不能进入目录
>
> 1.能使用ls命令浏览目录及子目录, 同时会提示权限拒绝
>
> 2.能使用ls -l命令浏览目录及子目录, 会带问号,同时只能看到文件名
>
> 总结: 目录只有r权限,仅仅只能浏览内的文件名，无其他操作权限
>
> 写入权限（w）
>
> 单纯的w权限没有任何意义。
>
> 如果目录只有w权限: 具有增加、删除或修改目录内文件名权限(需要x配合)
>
> //注意: 如果目录有w权限, 可以在目录内创建文件, 删除文件(跟文件本身权限无关)
>
> 不能进入目录、不能复制目录、不能删除目录、不能移动目录
>
> 执行权限（x）
>
> 目录只有x权限
>
> 1.只能进入目录
>
> 2.其他什么都做不了

注意：权限必须组合使用

***

**权限小结:**

> 文件rw权限, 可以查看和编辑文件内容
>
> 文件rx权限, 只能查看和执行文件、不能编辑、复制、移动、删除
>
> 目录rx权限, 允许浏览目录内文件以及子目录、并允许在目录内新建文件, 不允许创建、删除文件和目录

**注意事项:**

> 文件, x权限小心给予,建议赋予r或rw即可
>
> 目录, w权限小心给予,建议无特殊需求赋予rx即可

**权限与属主属组作用示例图**

<!-- OCR_START -->
- chown
- chmod7
<!-- OCR_END -->

`chown:` Linux中用来改变某个文件属主的命令, 如漫画中所示, 将某个"资源"(门)的访问权限给予别人。(卖房)

`chmod:` Linux中用来改变某个文件的访问模式的命令, 如漫画中所示, `chmod 777`会将大门敞开, 谁都可以进出。(租房)

实验

1.创建`andy,tom`用户为`oldboy`组, 用户统一使用`password`为密码

2.要求`oldboy`组的成员可以访问`/home/oldboy`目录, 并且可以在目录下创建,删除文件, 在目录下`andy`创建的文件可以让`tom`修改.

## 属主属组修改命令chown

```bash
chown   //更改属主以及属组 -R：递归修改
mkdir dir               //创建目录
touch dir/file_test     //创建文件
mkdir dir/dir_test      //创建目录
示例1：
chown bin dir/  //修改所属主为bin
ll -d dir/      //检查属主
drwxr-xr-x 2 bin root 4096 7月  22 00:50 dir/
示例2：
chown .adm dir/     //修改所属组为adm
ll -d dir/          //检查属组
drwxr-xr-x 2 bin adm 4096 7月  22 00:50 dir/
示例3：
chown -R root.root dir/ //递归修改目录及目录下的所有文件属主和属组
```

> 更新: 2024-09-21 13:56:34  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/xhphgk>