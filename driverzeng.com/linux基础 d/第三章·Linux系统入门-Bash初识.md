# 第三章·Linux系统入门-Bash初识

## Bash Shell介绍

| 什么是Bash Shell |
| :--- |

Bash Shell是一个命令解释器，它在操作系统的最外层，负责用户程序与内核进行交互操作的一种接口，讲用户输入的命令翻译给操作系统，并将处理后的结果输出至屏幕。

当我们使用远程连接工具连接linux服务，系统则会打开一个默认的shell，我们可以在这个界面执行命令，比如：获取系统当前时间，创建一个用户等等...

<!-- OCR_START -->
- 程序或服务
- 系统调用接口
- 内核
- 硬件
- 用户
<!-- OCR_END -->

| Bash Shell的作用 |
| :--- |

使用`Shell`实现对`Linux`系统的大部分管理，例如：

1）文件管理

2）权限管理

3）用户管理

4）磁盘管理

5）网络管理

6）软件管理

7）应用管理

...等等管理

| 平时我们该如何使用Bash Shell |
| :--- |

```bash
#获取当前时间
[root@db04 ~]# date
2019年 05月 29日 星期三 07:53:49 CST
#创建用户
[root@db04 ~]# useradd zls
#如果要创建100个用户，使用shell script
for n in `seq 100`;do
        useradd oldboy$n && \
        echo "用户 oldboy$n 已创建成功"
done
[root@db04 ~]# bash user.sh
```

| 总结shell执行方式 |
| :--- |

输入命令方式 ===> 效率低 ===>适合少量工作

shell script ===> 效率高 ===>适合复杂的工作

我们使用的shell版本

```bash
[root@db04 ~]# bash -version
GNU bash, version 4.1.2(1)-release (x86_64-redhat-linux-gnu)
Copyright (C) 2009 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

```

| shell提示符 |
| :--- |

```bash
'$' = 普通用户
'#' = root用户（超级管理员）
#查看当前用户
[root@db04 ~]# whoami
root
#查看当前命令提示符
[root@db04 ~]# echo $PS1
[\u@\h \W]\$
root:当前系统的用户
db04:当前系统的主机名
~:当前所在的位置
#:超级管理员身份（root用户）
$:普通用户
```

PS1的常用参数以及含义

```bash
\d ：代表日期，格式为weekday month date，例如："Mon Aug 1"
\H ：完整的主机名称
\h ：仅取主机名中的第一个名字
\t ：显示时间为24小时格式，如：HH：MM：SS
\T ：显示时间为12小时格式
\A ：显示时间为24小时格式：HH：MM
\u ：当前用户的账号名称
\v ：BASH的版本信息
\w ：完整的工作目录名称
\W ：利用basename取得工作目录名称，只显示最后一个目录名
\# ：下达的第几个命令
\$ ：提示字符，如果是root用户，提示符为 # ，普通用户则为 $
　　
　　
#颜色
30  40 黑色
31  41 红色
32  42 绿色
33  43 黄色
34  44 蓝色
35  45 紫红色
36  46 青蓝色
37  47 白色
```

```bash
PS1='\[\e[32;40m\] \[[\u@\h \w \t]\$ \[\e[0m\]'
PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[36;40m\]\w\[\e[0m\]]\\$ "
PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\[\e[35;40m\]\h\[\e[0m\] \[\e[36;40m\]\w\[\e[0m\]]\\$ "
```

***

| shell基础语法 |
| :--- |

命令行bash shell，为用户提供输入，执行命令的界面

```bash
#命令     选项        参数
command  [-options] [arguments]
[root@db04 ~]# ls               //命令
[root@db04 ~]# ls -l            //命令+选项
[root@db04 ~]# ls -l /home/     //命令+选项+参数
#命令：整条shell命令的主体
#选项：用于调节命令的具体功能
    #以'-'引导段个事选项（单个字符），例如”-a“
    #以'--'引导长格式选项（多个字符），例如”--all“
    #多个短格式选项可以卸载一起，只用一个”-“引导，例如”-la“
#参数：命令操作与偶的对象，如文件、目录名等
#命令必须开头，选项和参数位置可以发生变化

```

## Bash Shell的基本特性

| 命令补全 |
| :--- |

当使用windows查找一个目录层级特别多的文件时，打开的效率会非常的慢，但如果使用linux查找一个目录层级特别多的文件时，可以通过`tab`键快速补全。

命令补全

选项补全

参数补全

PS：`tab`键可以实命令补全，路径补全，在实际生产中`tab`补全往往是我们使用的最多的，因为可以减少执行命令以及路径出错率，还能提高输入效率。

```bash
#查看本机IP，忘记了具体命令
[root@db04 ~]# ifc
ifcfg     ifconfig
#按下tab键会自动补全
[root@db04 ~]# ifconfig
#按一下tab没有反应，那么需要按两下tab键，列出所有if开头的命令
[root@db04 ~]# if
if         ifcfg      ifconfig   ifdown     ifenslave  ifnames    ifrename   iftop      ifup
#Linux目录比较深，经常会使用tab键进行补全，如果路径出错是没有办法补全的
[root@db04 ~]# ls /etc/sysconfig/network-scripts/ifcfg-eth0
/etc/sysconfig/network-scripts/ifcfg-eth0
```

如果无法补全选项，那么需要安装一个扩展包

```bash
[root@db04 ~]# yum install -y bash-completion
```

***

| 命令快捷键 |
| :--- |

命令的快捷键可以帮助我们大大提升工作效率

```bash
Ctrl + a    #光标跳转至正在输入的命令行的首部
Ctrl + e    #光标跳转至正在输入的命令行的尾部
Ctrl + w    #按照空格来删除bash内容
Ctrl + c    #终止前台运行的程序
Ctrl + d    #在shell中，ctrl-d表示退出当前shell。（logout、exit）
Ctrl + z    #将任务暂停，挂至后台
Ctrl + l    #清屏，和clear命令等效。
Ctrl + k    #删除从光标到行末的所有字符
Ctrl + u    #删除从光标到行首的所有字符
Ctrl + r    #搜索历史命令, 利用关键字
Ctrl + s    #锁屏
Ctrl + q    #解锁
Ctrl + 左右  #按照单词快速跳转光标（Xshell提供的）
ESC  + .    #获取最后的指令
#在命令行前加面加 "#" 则该命令不会被执行
```

***

| 历史命令 |
| :--- |

历史命令的作用：追溯之前的发生情况，在企业中，十分重要，涉及到运维的责任，记录历史命令对于运维人员来说，也有一个专业名词：`审计`

-w:保存命令历史到文件 write

-c:清空命令历史记录，不会清空文件 clear

-d:删除命令历史的第N行 delete

```bash
#查看历史记录
[root@db04 ~]# history
#清空历史记录
[root@db04 ~]# history -c
#指定一条历史记录删除
[root@db04 ~]# history -d 110
#保存历史命令
[root@db04 ~]# history -w
#执行上一条命令
[root@db04 ~]# !!
#执行上一条ls相关命令
[root@db04 ~]# !ls
ls /etc/sysconfig/network-scripts/ifcfg-eth0
/etc/sysconfig/network-scripts/ifcfg-eth0
#执行历史命令中的第74条命令
[root@db04 ~]# !74
```

***

| 命令的别名 |
| :--- |

命令别名讲用户经常使用的复杂命令简单化，创建出属于自己的命令别名。

```bash
创建语法：alias 别名=”命令“
取消语法：unalias 别名
```

```bash
#定义临时别名，查看网络是否可以通，ping 百度,只对当前shell生效
[root@db04 ~]# alias tong="ping baidu.com"
[root@db04 ~]# tong
PING baidu.com (123.125.114.144) 56(84) bytes of data.
64 bytes from 123.125.114.144: icmp_seq=1 ttl=128 time=44.2 ms
64 bytes from 123.125.114.144: icmp_seq=2 ttl=128 time=47.5 ms
64 bytes from 123.125.114.144: icmp_seq=3 ttl=128 time=46.3 ms
#查看所有定义的别名
[root@db04 ~]# alias
alias cp='cp -i'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias tong='ping baidu.com'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
#取消别名
[root@db04 ~]# unalias oldboy
[root@db04 ~]# oldboy
-bash: tong: command not found
#永久生效
[root@db04 ~]# vim /etc/bashrc
alias oldboy="ping baidu.com"
```

***

| 获取命令帮助 |
| :--- |

```bash
#获取ls命令的帮助
[root@db04 ~]# ls --help
用法：ls [选项]... [文件]...
#ls常见选项
-a  //查看目录下的所有文件，包括隐藏文件
-l  //以长格式的方式显示文件的详细内容
-h  //以人性化的方式显示内容，配合-l使用
-d  //只列出目录名，不列出目录以下的内容
-t  //按修改时间进行排序
-i  //显示文件的inode（该文件在该分区的一个编号）
-r  //倒叙 
[root@db04 ~]# man ls
```

查看Linux命令的站点：

<http://linux.51yip.com/>

<http://man.linuxde.net/>

***

| 命令执行的流程 |
| :--- |

当我们执行一个命令, 整个命令执行流程如下:

1.判断命令是否通过绝对路径执行

2.判断命令是否存在别名

3.判断用户输入的是内部命令还是外部命令

4.内部命令直接执行, 外部命令检测是否存在缓存

5.检测`PATH`路径, 有执行, 无报错

>  
>
> 内部命令: shell程序自带的命令。
>
> 外部命令: 在系统PATH变量的某个路径下的可执行程序。

使用`type`命令检测用户输入的命令属于内部命令还是外部命令。

```bash
#cd命令属于shell内部命令
[root@db04 ~]# type -a cd
cd is a shell builtin
cd is /usr/bin/cd
#ping属于外部命令, 同时会打印当前命令路径
[root@db04 ~]# type -a  ping
ping is /bin/ping
```

`PATH`变量定义的路径, 作用是告诉`Bash`执行的外部命令存放的位置，`Bash`会在这些路径中进行逐个扫描。

事实上执行过的外部命令都会保存在内存缓存中, 当再次执行相同的命令, 会通过缓存调取执行, 也就意味着不会搜索`PATH`路径。

```bash
//表缓存命令所在位置
[root@db04 ~]# hash
hits    command
   1    /usr/bin/tty
   3    /sbin/ifconfig
//已缓存命令,如果移动位置会导致无法找到该命令
[root@db04 ~]# mv /sbin/ifconfig /bin/
[root@db04 ~]# ifconfig
-bash: /sbin/ifconfig: No such file or directory
//删除缓存过的ifconfig命令, 即可执行
[root@db04 ~]# hash -d ifconfig
[root@db04 ~]# ifconfig
//当然可以清空缓存表
[root@db04 ~]# hash -r
//命令缓存hash需要注意如下情况:
1.如果执行外部命令1次就会对该命令进行缓存
2.如果将命令移动了位置
    a.使用绝对路径执行
    b.删除hash表的缓存指令
```

总结, 当我们执行了一个`ping`命令之后, 整个命令执行的流程步骤如下:

>  
>
> 1.检查执行的是否是绝对路径执行
>
> 2.检查该ping命令是否存在别名
>
> 3.检查该ping命令是内部命令还是外部命令
>
> 4.如果是内部指令直接执行, 如果是外部命令
>
> 5.检测该命令是否有缓存,如果没有,查找PATH变量
>
> 6.检查PATH路径直到查找到该命令然后执行
>
> 7.如果没有找到该命令则返回错误。command not found

> 更新: 2024-09-20 21:58:38  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/xgu9kc>