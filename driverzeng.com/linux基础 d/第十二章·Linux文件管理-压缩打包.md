# 第十二章·Linux文件管理-压缩打包

## 压缩打包介绍

`windows`下我们接触最多的压缩文件就是`.rar`格式, 但`Linux`有自己所特有的压缩工具。

如果希望windows和Linux互相能使用的压缩工具, 建议`.zip`格式

压缩的好处主要有：

> 节省磁盘空间占用率
>
> 节省网络传输带宽消耗
>
> 网络传输更加快捷

Linux系统常见的压缩包有哪些类型

| 格式 | 压缩工具 |
| :--- | :--- |
| .zip | zip压缩工具 |
| .gz | gzip压缩工具，只能压缩文件，会删除源文件（通常配合tar使用） |
| .bz2 | bzip2压缩工具，只能压缩文件，会删除源文件（通常配合tar使用） |
| .tar.gz | 先使用tar命令归档打包，然后使用gzip压缩 |
| .tar.bz2 | 先使用tar命令归档打包，然后使用bzip压缩 |

> 注意:
>
> 1.Linux下常用压缩文件以.tar.gz结尾.
>
> 2.Linux下压缩文件必须带后缀.

## gzip压缩工具

```bash
#安装gzip压缩工具
[root@db04 ~]# yum install -y gzip
#创建文件
[root@db04 ~]# echo 123  >> file1
#压缩file1
[root@db04 ~]# gzip file1
#查看文件
[root@db04 ~]# ll
总用量 4
-rw-r--r-- 1 root root 30 6月  23 17:31 file1.gz
#查看文件类型
[root@db04 ~]# file file1.gz
file1.gz: gzip compressed data, was "file1", from Unix, last modified: Sun Jun 23 17:31:54 2019
#查看gzip压缩后的文件内容
[root@db04 ~]# zcat file1.gz
123
#解压文件
[root@db04 ~]# gzip -d file1.gz
#查看文件
[root@db04 ~]# ll
总用量 4
-rw-r--r-- 1 root root 4 6月  23 17:31 file1
#压缩所有文件该如何操作？
```

## zip压缩工具

`zip`是压缩工具，`unzip`是解压缩工具

```bash
#安装zip压缩工具和解压工具
[root@db04 ~]# yum install -y zip unzip
#压缩文件为zip包
[root@zls ~]# zip  filename.zip  filename 
#              搬家     行李箱        衣物
#压缩目录为zip包  
[root@zls ~]# zip -r  dir.zip dir/
#解压zip文件包, 默认解压至当前目录          
[root@zls ~]# unzip  filename.zip
```

请问：Linux中的zip和windows中的zip是否可以互相解压？

## tar压缩工具

`tar`是`linux`下最常用的压缩与解压缩, 支持文件和目录的压缩归档

```bash
#语法：tar [-zjxcvfP] filename 
c   //创建新的归档文件
x   //对归档文件解包
t   //列出归档文件里的文件列表
v   //输出命令的归档或解包的过程
f   //指定包文件名，多参数f写最后
C   //指定解压目录位置
z   //使用gzip压缩归档后的文件(.tar.gz)
j   //使用bzip2压缩归档后的文件(.tar.bz2)
J   //使用xz压缩归档后的文件(tar.xz)
X   //排除多个文件(写入需要排除的文件名称)
h   //打包软链接
P   //连带绝对路径打包
--hard-dereference  //打包硬链接
--exclude   //在打包的时候写入需要排除文件或目录
//常用打包与压缩组合
czf     //打包tar.gz格式
cjf     //打包tar.bz格式
cJf     //打包tar.xz格式
zxf     //解压tar.gz格式
jxf     //解压tar.bz格式
xf      //自动选择解压模式
tf      //查看压缩包内容
```

***

| 将文件或目录进行打包压缩 |
| :--- |

```bash
//以gzip归档方式打包并压缩
tar czf  test.tar.gz  test/ test2/
//以bz2方式压缩 
tar cjf  test.tar.bz2 dir.txt dir/
//打包链接文件,打包链接文件的真实文件
[root@zls ~]# cd /
[root@zls /]# tar czfh local.tar.gz  etc/rc.local
#打包/tmp下所有文件
[root@zls ~]# cd /
[root@zls /]# find tmp/ -type f | xargs tar czf tmp.tar.gz      
#打包/tmp下所有文件
[root@zls /]# tar czf tmp.tar.gz | xargs find tmp/ -type f
#打包/tmp下所有文件
[root@zls /]# tar czf tmp.tar.gz $(find tmp/ -type f)
```

***

| 排除文件, 并打包压缩 |
| :--- |

```bash
#排除单个文件
[root@zls /]#  tar czf etc.tar.gz --exclude=etc/services etc/
#排除多个文件
[root@zls /]# tar czf etc.tar.gz --exclude=etc/services --exclude=etc/rc.local etc/
[root@zls /]# tar czf etc.tar.gz --exclude=etc/{services,passwd,shadow,gshadow,group}
#将需要排除的文件写入文件中
[root@zls /]# cat paichu.list
etc/services
etc/rc.local
etc/rc.d/rc.local
#指定需要排除的文件列表, 最后进行打包压缩
[root@zls /]# tar czfX etc.tar.gz paichu.list etc/
```

***

| 查看压缩文件 |
| :--- |

```bash
//查看压缩包内容和解压
[root@zls /]# tar tf  test.tar.gz
```

***

| 解压压缩文件 |
| :--- |

```bash
//解包或者解压缩
[root@zls /]# tar xf  test.tar.gz      
//将tar.gz解压至其他目录
[root@student ~]# tar xf /etc/local.tar.gz  -C /tmp
```

> 注意: 不管是打包还是解包，原文件是不会被删除的，但会覆盖当前已经存在的文件或者目录。

## TAR生产案例实践

基础环境准备

```bash
[root@localhost ~]# yum install mariadb-server
[root@localhost ~]# systemctl start mariadb
[root@localhost ~]# mkdir /backup
```

案例1 `mysql`物理备份及恢复

```bash
[root@localhost ~]# tar cJf /backup/mysql.tar.xz /var/lib/mysql
[root@localhost ~]# tar xf /backup/mysql.tar.xz -C /
```

案例2 `mysql`物理备份及恢复

```bash
[root@localhost ~]# cd /var/lib/mysql
[root@localhost mysql]# tar cJf /backup/mysql.tar.xz *
[root@localhost mysql]# tar tf /backup/mysql.tar.xz
[root@localhost mysql]# tar xf /backup/mysql.tar.xz -C /var/lib/mysql
```

案例3 `host A /etc` (海量小文件) --> `host A /tmp`

```bash
[root@localhost ~]# tar czf - /etc | tar xzf - -C /tmp
```

案例4 `host A /etc` (海量小文件) --> `host B /tmp`

```bash
#常规方法
[root@localhost ~]# scp -r /etc root@192.168.69.113:/tmp
#建议方法:
#接收B主机, 需要监听端口
[root@hostB ~]# systemctl stop firewalld.service 
[root@hostB ~]# nc -l 8888 |tar xzf - -C /tmp
#发送方A主机
[root@hostA ~]# tar -czf - /etc | nc 10.0.0.100 8888
tar: Removing leading `/' from member names
```

***

| 压缩命令练习 |
| :--- |

1.如何使用gzip命令对文件进行压缩、解压

2.如何用zip命令对文件以及目录进行压缩、解压

3.创建一个自己名字的文件至/opt目录

4.打包opt整个目录，并命名test_opt.tar.gz

5.查看打包好的test_opt.tar.gz里的文件

6.将打包好的test_opt.tar.gz内容指定解压至/tmp目录

7.打包etc目录下的所有文件，不要目录只要文件

8.打包etc目录下的所有文件，排除passwd，shadow

9.打包etc目录下的所有以p开头的文件

10.打包etc目录下所有大于1M的文件

> 更新: 2024-09-20 22:14:37  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/kggkmr>