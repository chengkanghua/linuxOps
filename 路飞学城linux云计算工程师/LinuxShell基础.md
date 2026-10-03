# Linux Shell基础

\[TOC]

# 走进shell

Linux早期没有图形界面，管理员只能在控制台输入 shell 命令、查看文本输出。

多数发行版（如 CentOS）可用 `ctrl+F1~F7` 组合键访问控制台；如今更常用 Xshell 这类终端工具远程连接管理。

以 CentOS 为例，默认 shell 是 `GNU bash shell`，支持以下特性：

* man手册
* tab补全
* shell指令

`GNU bash shell`是在系统普通用户登陆时，作为普通程序运行，这个规则是`/etc/passwd`中指定的条目

```plain
[root@chaogelinux ~]# tail -1 /etc/passwd
susu:x:2009:2010::/home/susu:/bin/bash
```

bash 会在用户登录时自动启动。若通过虚拟控制台终端登录，会出现命令行界面（CLI）提示符，此时即可输入 shell 命令；若通过图形化桌面登录，则需启动 GNOME 这类终端仿真器来访问 shell CLI。

## 什么是shell

<!-- OCR_START -->
- Google翻译
- xA 文字
- 文档
- 检测到英语
- 英语
- 中文
- 德语
- 中文(简体)
- shell
- 贝壳
<!-- OCR_END -->

shell的作用是

* 解释执行用户输入的命令或程序等
* 用户输入一条命令，shell就解释一条
* 键盘输入命令，Linux给与响应的方式，称之为交互式

<!-- OCR_START -->
- 外围应用程序
- shell解释器（翻译官、命令解释器）
- 操作系统核心
- 机器硬件
<!-- OCR_END -->

shell 是包裹在系统内核外的一层"壳"，处于操作系统最外层，直接与用户对话：把用户输入解释给操作系统，再把处理结果输出到屏幕。

<!-- OCR_START -->
- [root@chaogelinux
- data]#
- echo
- "超哥带你学shel1
<!-- OCR_END -->

从我们登录Linux，输入账号密码到进入Linux交互式界面，所有的操作，都是交给shell解释并执行

<!-- OCR_START -->
- 超哥
- 敲键盘
- Is
- terminal终端
- 通过bash解释器
- shell壳
- 接受输入，绘制输出
- 解析和翻译用户输入
- 系统调用
- stdout/stderr
- 操作系统内核kernel
- 计算机硬件
<!-- OCR_END -->

获取计算机数据不可能每次都写程序、编译、再运行——比如找一个文件，你得写 C 代码、调系统函数、gcc 编译后才能执行。

于是有了 shell 解释器：只要输入 `ls -lh` 这样的字符串，shell 就会把它翻译解释为 `ls -l -h` 并执行，再通过终端输出结果。无论图形化还是命令行界面都是如此。

即使我们用的图形化，点点点的动作，区别也只是

* 命令行操作，shell解释执行后，输出结果到黑屏命令行界面
* 图形化操作，shell接受点击动作，输出图案数据

<!-- OCR_START -->
- Google翻译
- A 文字
- 文档
- 点击图标下载App
- Android
- ios
- 检测语言
- 英语
- 中文
- 德语
- 中文(简体)
- 日语
- 请将我这句话翻译成英文，否则老外看不懂
- Please translate this sentence into English,
- otherwise the foreigner will not understand
- Qing jiang wo zhe ju hua fanyi cheng yingwén, fouze läowai kan bu dong
- 19/5000
- 发送反
<!-- OCR_END -->

## shell和运维

shell 很适合处理纯文本数据。Linux 的哲学是"一切皆文件"——日志、配置、网页文件大多是纯文本，因此 shell 配合 Linux 三剑客（grep、sed、awk）能高效完成文本处理。

<!-- OCR_START -->
- 基础命令
- Nginx/
- 存储服务
- web
- python
- 定时任务
- 服务
- shell
- Zabbix
- Django
- 监控
- 虚拟化服
- Linux系
- 统服务
- 云计算服
<!-- OCR_END -->

## 什么是shell脚本

当命令或者程序语句写在文件中，我们执行文件，读取其中的代码，这个程序文件就称之为shell脚本。

在shell脚本里定义多条Linux命令以及循环控制语句，然后将这些Linux命令一次性执行完毕，执行脚本文件的方式称之为，非交互式方式。

* windows中存在`*.bat`批处理脚本
* Linux中常用`*.sh`脚本文件

<!-- OCR_START -->
- [root@chaogelinuxdata]#cat testl.sh
- echo
- ）“脚本执行完毕～"
- [root@chaogelinux data]# sh test1.sh
- books.txt
- luffycity.com
- pyyu.txt
- test_umask.txt
- chaoge2.txt
- luffy.txt
- test
- tttttt.txt
- chaoge.txt
- mytasks.at
- test1.sh
- yu.txt
- lovers.txt
- pwd.txt
- test.txt
- yuyuyuyu.txt
<!-- OCR_END -->

*shell脚本规则*

在Linux系统中，shell脚本或者称之为（bash shell程序）通常都是vim编辑，由Linux命令、bash shell指令、逻辑控制语句和注释信息组成。

### Shebang

计算机程序中，`shebang`指的是出现在文本文件的第一行前两个字符`#!`

在Unix系统中，程序会分析`shebang`后面的内容，作为解释器的指令，例如

* 以`#!/bin/sh`开头的文件，程序在执行的时候会调用`/bin/sh`，也就是bash解释器
* 以`#!/usr/bin/python`开头的文件，代表指定python解释器去执行
* 以`#!/usr/bin/env 解释器名称`，是一种在不同平台上都能正确找到解释器的办法

注意事项：

* 如果脚本未指定`shebang`，脚本执行的时候，默认用当前shell去解释脚本，即`$SHELL`
* 如果`shebang`指定了可执行的解释器，如`/bin/bash /usr/bin/python`，脚本在执行时，文件名会作为参数传递给解释器
* **如果#!指定的解释程序没有可执行权限，则会报错“bad interpreter: Permission denied”。**
* **如果#!指定的解释程序不是一个可执行文件，那么指定的解释程序会被忽略，转而交给当前的SHELL去执行这个脚本。**
* **如果#!指定的解释程序不存在，那么会报错“bad interpreter: No such file or directory”。**
* **#!之后的解释程序，需要写其绝对路径（如：#!/bin/bash），它是不会自动到$PATH中寻找解释器的。**
* **如果你使用"bash test.sh"这样的命令来执行脚本，那么#!这一行将会被忽略掉，解释器当然是用命令行中显式指定的bash。**

脚本案例

```plain
[root@chaogelinux data]# cat test.sh
#!/bin/bash
echo "超哥强呀，奥力给"
#!/bin/bash 这里就是注释的作用了
```

系统自带的bash脚本，开机启动脚本

```plain
[root@chaogelinux data]# head -1 /etc/rc.d/init.d/network
#! /bin/bash
```

### 脚本注释，脚本开发规范

* 在shell脚本中，#后面的内容代表注释掉的内容，提供给开发者或使用者观看，系统会忽略此行
* 注释可以单独写一行，也可以跟在命令后面
* 尽量保持爱写注释的习惯，便于以后回顾代码的含义，尽量使用英文、而非中文

```plain
#! /bin/bash
# Date : 2019-11-28 14:59:18
# Author：created by chaoge
# Blog：www.cnblogs.com/pyyu
```

<!-- OCR_START -->
#！ /bin/bash shebang指定解释器network Bring up/down networking脚本作用注释、注解chkconfig:2345 10 90 description:Activates/Deactivates all network interfaces configured to start at boot time.

### BEGIN INIT INFO

# Provides: $network

# Should-Start: iptables ip6tables NetworkManager-wait-online NetworkManager $network-pre

# Short-Description: Bring up/down networking

# Description: Bring up/down networking

###END INIT INFO

# Source function library.

为代码的作用添加解释/etc/init.d/functions if [！ -f /etc/sysconfig/network ]; then exit 6 fi /etc/sysconfig/network if [ -f /etc/sysconfig/pcmcia ]; then /etc/sysconfig/pcmcia

# Check that networking is up.

[ "${NETWORKING}" = "no" ] && eXit 6

# if the ip configuration utility isn't around we can't function.

[ -x /sbin/ip ] Il exit 1
<!-- OCR_END -->

### 执行shell脚本的方式

* `bash script.sh`或`sh scripte.sh`，文件本身没权限执行，没x权限，则使用的方法，或脚本未指定`shebang`，重点推荐的方式
* 使用`绝对/相对`路径执行脚本，需要文件含有x权限
* `source script.sh`或者`. script.sh`，代表`执行的含义，source等于点.`
* 少见的用法，`sh < script.sh`

```plain
[root@chaogelinux data]# cat test.sh
#!/bin/bash
echo "超哥强呀，奥力给"
#!/bin/bash 这里就是注释的作用了
[root@chaogelinux data]#
[root@chaogelinux data]#
[root@chaogelinux data]# sh < test.sh
超哥强呀，奥力给
[root@chaogelinux data]# sh test.sh
超哥强呀，奥力给
[root@chaogelinux data]# bash test.sh
超哥强呀，奥力给
[root@chaogelinux data]# source test.sh
超哥强呀，奥力给
[root@chaogelinux data]# . /data/test.sh
超哥强呀，奥力给
权限不足
[root@chaogelinux data]# ./test.sh
-bash: ./test.sh: 权限不够
[root@chaogelinux data]# chmod +x test.sh
[root@chaogelinux data]# ./test.sh
超哥强呀，奥力给
```

## 脚本语言

shell脚本语言属于一种弱类型语言`无需声明变量类型，直接定义使用`

`强类型语言，必须先定义变量类型，确定是数字、字符串等，之后再赋予同类型的值`

centos7系统中支持的shell情况，有如下种类

```plain
[root@chaogelinux ~]# cat /etc/shells  
/bin/sh
/bin/bash
/sbin/nologin
/usr/bin/sh
/usr/bin/bash
/usr/sbin/nologin
/bin/tcsh
/bin/csh
```

默认的sh解释器

```plain
[root@chaogelinux ~]# ll /usr/bin/sh
lrwxrwxrwx 1 root root 4 11月 16 10:48 /usr/bin/sh -> bash
```

### 其他脚本语言

<!-- OCR_START -->
- LanguagePascal
- C/AL
- SYMP
- HAL/S
- ALGOL
- DATATREVE
- SIMSCRPT
- SMPLE
- PL
- Ajax
- CloAe
- Object
- Autoe
- Not
- Jerocede
- code
- SALSAATS
- ELAN
- Adenine
- Assembly
- SAMMTG
- TADPOL
- language
- LispVB
- Fl
- shell
- Windows/Dos
- SuperTak
- JavaScript
- IMP
- ABC
- FLavaFx
- Visual
- Foth
- GameMorhey
- Prolog
- Cayeve
- Delphi DASL
- Go
- Camlz
- ECMASorpt
- PEARL
- JASS
- Eiatisp ObjectScript
- Corstrait
- Java
- Oxygene
- Programming
- ILASS
- ScriptPHP
- Ruby
- EXEC
- CarViaion
- Cyclone
- Action
- REXX
- FPL
- NETosnk
- Common
- Bomevg coeOL GraghTak
- CRCAModli-2
- Python
- AicMoby
- Utace
- HaXa
- Caral
- WATFOR
<!-- OCR_END -->

* PHP是网页程序语言，专注于Web页面开发，诸多开源产品，wordpress、discuz开源产品都是PHP开发
* Perl语言，擅长支持强大的正则表达式，以及运维工具的开发
* Python语言，明星语言，不仅适用于脚本程序开发，也擅长Web页面开发，如（系统后台，资产管理平台），爬虫程序开发，大量Linux运维工具也由python开发，甚至于游戏开发也使用

### shell的优势

虽然有诸多脚本编程语言，但是对于Linux操作系统内部应用而言，shell是最好的工具，Linux底层命令都支持shell语句，以及结合三剑客(grep、sed、awk)进行高级用法。

* 擅长系统管理脚本开发，如软件启停脚本、监控报警脚本、日志分析脚本

每个语言都有自己擅长的地方，扬长避短，达到高效运维的目的是最合适的。

```plain
#Linux默认shell
[root@chaogelinux ~]# echo $SHELL
/bin/bash
```

## bash基础特性

<!-- OCR_START -->
- bash是什么
- portage-portage
- 5643
- 6230日p
- 514137bash-4.0_p10.ebu11d
- portage
- 48
- Hpr
- 1405
- 口1
- iars
- portag
- 25
- HPF
- portarg
- Jul25
- bash-,
- 130
- 1e
- 3portage
- portad
- May
- root
- bash-3.5
- POL
- 2Jul25
- 21
- Mar23
- -xr-x
- roo
- 382
- 23
- Jul
- 33portage
- oot
- wtage
- 7Mar23
- not
- 1645Mar
- 2321
- 1root
- 5
- Mau
- 7bash-3,
- ot
- irtage
- 1Apr
- 5977Mar
- 514
- Feb
- porta
- 7bash-4
- rtagepor
- 38Mar23
- 6151Ar
- 37bash-
- portagepo
- 43Apr
- 5988
- 38Apr
- 05:52bash-
- por
- 48Apr14
- 1
- portar
- 6238
- 810:21bash
- ige
- yY
- oortage
- 532Apr
- 03:35bash-
- 564
- 810
- age
- yr
- rtageportag
- 5660ay30
- 9:43bash
- 55
- 3003
- ge portage
- tage
- 3:35file
- 5660ray
- eportage
- 5668 Jui
- rtage
- 2848May
- 14:35met
- 5660 Jui2509
- rW-r
- 20481ay3003
- 468Fet
- cat met
- 984
- -oFeb
- 2
- -shells/
- portageportar
- entoo.org
- 2portag
- "UTF-8"?>
- ortage/apr
- rummd.gent
- ainlusr/portage
- "nttp://
- drwxr-xr-x
- ·bash是一个命令处理器，运行在文本窗口中，并能执行用户直接输入的命令
- ·bash还能从文件中读取linxu命令，称之为脚本
- ·bash支持通配符、管道、命令替换、条件判断等逻辑控制语句
<!-- OCR_END -->

bash有诸多方便的功能，有助于运维人员提升工作效率

**命令历史**

**Shell会保留其会话中用户提交执行的命令**

```plain
history    #命令，查看历史命令记录，注意【包含文件中和内存中的历史记录】
[root@chaogelinux ~]# echo $HISTSIZE    #shell进程可保留的命令历史的条数
3000
[root@chaogelinux ~]# echo $HISTFILE        #存放历史命令的文件，用户退出登录后，持久化命令个数
/root/.bash_history
#存放历史命令的文件
[root@chaogelinux ~]# ls -a ~/.bash_history
/root/.bash_history
```

history命令

```plain
history #命令 以及参数
-c: 清空内存中命令历史；
-r：从文件中恢复历史命令
数字  ：显示最近n条命令  history  10
```

调用历史命令

```plain
!n  #执行历史记录中的某n条命令
!!  #执行上一次的命令，或者向上箭头
!string   #执行名字以string开头的最近一次的命令
```

调用上一次命令的最后一个参数

```plain
ESC .   #快捷键
!$
```

控制历史命令的环境变量

```plain
变量名：HISTCONTROL
ignoredups：忽略重复的命令；
ignorespace：忽略以空白字符开头的命令；
ignoreboth：以上两者同时生效；
[root@chaogelinux ~]# HISTCONTROL=ignoreboth
[root@chaogelinux ~]# echo $HISTCONTROL
ignoreboth
[root@chaogelinux ~]# history
```

### bash特性汇总

* 文件路径tab键补全
* 命令补全
* 快捷键ctrl + a,e,u,k,l
* 通配符
* 命令历史
* 命令别名
* 命令行展开

### 变量含义

学生时代所学的数学方程式，如x=1,y=2，那会称之为x，y是未知数

对于计算机角度，x=1,y=2等于定义了两个变量，名字分别是x，y，且赋值了1和2

**变量是暂存数据的地方，相当于一种数据标记（像房间号标记了客人位置）：数据存在内存空间中，通过正确的变量名即可取出对应的值。**

<!-- OCR_START -->
- 房间
- 变量
- 房间名字
- 变量名
- 房间类型
- 变量类型
- 客人
- 变量值
<!-- OCR_END -->

<!-- OCR_START -->
- #
- 定义Linux变量
- name="超哥”
- age=18
<!-- OCR_END -->

### shell变量

* 变量定义与赋值，注意变量与值之间不得有空格

```plain
name="超哥"
变量名
变量类型，bash默认把所有变量都认为是字符串
bash变量是弱类型，无需事先声明类型，是将声明和赋值同时进行
```

* 变量替换/引用

```plain
[root@chaogelinux ~]# name="超哥带你学bash"
[root@chaogelinux ~]# echo ${name}
超哥带你学bash
[root@chaogelinux ~]# echo $name    #可以省略花括号
超哥带你学bash
```

* 变量名规则
  * 名称定义要做到见名知意，且按照规则来，不得引用保留关键字（用 help 检查保留字）
  * 只能包含数字、字母、下划线
  * 不能以数字开头
  * 不能用标点符号
  * 变量名严格区分大小写

```plain
有效的变量名：
NAME_CHAOGE
_chaoge
chaoge1
chaogE1
Chao2_ge
无效的变量名：
?chaoge
chao*ge
chao+ge
```

* 变量的作用域
  * 本地变量，只针对当前的shell进程

```plain
pstree检查进程树
```

* 
<!-- OCR_START -->
- 2. root@chaogelinux:~ (ssh)
- X root@chaogelinux...81
- ×root@chaogelinux:~
- root@chaogelinux:~(ssh)
- -crond
- -dbus-daemon
- -dockerd-current-
- -docker-containe———9*[{docker-conta+
- -17*[{dockerd-current}]
- -lsmd
- -Lvmetad
- master
- Tpickup
- -qmgr
- nginx-
- ～』#
- -polkitd-
- —6*[{polkitd}]
- -rsvsload2*[{rsvsload?]
- sshd-
- -bash-
- csh-
- -sshd——bash-
- -pstree
- -systemd-journal
- -systemd-logind
- -systemd-udevd
- tuned—4*[{tuned}]
- ~1#
- ~」#
<!-- OCR_END -->

\
  

<!-- OCR_START -->
- [root@chaogelinux ~]# name=123
- [root@chaogelinux ~]# echo $name
- 123
- 切换shell
- [root@chaogelinux ~]#
- csh
- 变量丢失
- name: Undefined variable.
- root@chaoaelinu
<!-- OCR_END -->

  * 环境变量，也称为全局变量，针对当前shell以及其任意子进程，环境变量也分`自定义`、`内置`两种环境变量
  * 局部变量，针对在`shell函数`或是`shell脚本`中定义
* 位置参数变量：用于`shell脚本`中传递的参数
* 特殊变量：shell内置的特殊功效变量
  * $?
    * 0：成功
    * 1-255：错误码
* 自定义变量
  * 变量赋值：`varName=value`
  * 变量引用：`${varName}`、`$varName`
    * 双引号，变量名会替换为变量值

```plain
[root@chaogelinux ~]# n1=1
[root@chaogelinux ~]# n2=2
[root@chaogelinux ~]#
[root@chaogelinux ~]# n3="$n1"
[root@chaogelinux ~]# echo $n3
1
[root@chaogelinux ~]# n4='$n2'
[root@chaogelinux ~]# echo $n4
$n2
```

```
    * 单引号，识别为普通字符串
```

### 不同的执行方式，不同的shell环境

```plain
[root@chaogelinux data]# echo user1='超哥' > testsource.sh
[root@chaogelinux data]# echo $user1
[root@chaogelinux data]# sh testsource.sh
[root@chaogelinux data]# echo $user1
[root@chaogelinux data]# source testsource.sh
[root@chaogelinux data]# echo $user1
超哥
```

解答：

1.每次调用bash都会开启一个子shell，因此不保留当前的shell变量，通过`pstree`命令检查进程树

2.调用source是在当前shell环境加载脚本，因此保留变量

#### shell变量面试题

问，如下输入什么内容

```plain
[root@chaogelinux data]# cat test.sh
user1=`whoami`
[root@chaogelinux data]# sh test.sh
[root@chaogelinux data]# echo $user1
A.当前用户
B.超哥
C.空
```

## 环境变量设置

环境变量一般指的是用export内置命令导出的变量，用于定义shell的运行环境、保证shell命令的正确执行。

shell通过环境变量确定登录的用户名、PATH路径、文件系统等各种应用。

环境变量可以在命令行中临时创建，但是用户退出shell终端，变量即丢失，如要永久生效，需要修改`环境变量配置文件`

* 用户个人配置文件`~/.bash_profile`、`~/.bashrc 远程登录用户特有文件`
* 全局配置文件`/etc/profile`、`/etc/bashrc`，且系统建议最好创建在`/etc/profile.d/`，而非直接修改主文件，修改全局配置文件，影响所有登录系统的用户

**检查系统环境变量的命令**

* set，输出所有变量，包括全局变量、局部变量
* env，只显示全局变量
* declare，输出所有的变量，如同set
* export，显示和设置环境变量值

**撤销环境变量**

* unset 变量名，删除变量或函数。

**设置只读变量**

* readonly ，只有shell结束，只读变量失效

```plain
直接readonly 显示当前系统只读变量
[root@chaogelinux ~]# readonly name="超哥"
[root@chaogelinux ~]# name="chaochao"
-bash: name: 只读变量
```

**系统保留环境变量关键字**

bash内嵌了诸多环境变量，用于定义bash的工作环境

```plain
[root@chaogelinux ~]# export |awk -F '[ :=]' '{print $3}'
```

### bash多命令执行

```plain
[root@chaogelinux home]# ls /data/;cd /tmp/;cd /home;cd /data
```

### 环境变量初始化与加载顺序

<!-- OCR_START -->
环境变量文件加载顺序
ssh登录Linux后，系统启动一个bashshell
bash会读取若干个系统环境文件，检查环境变量设置
/etc/profile：全局环境变量文件
为系统的每个用户设置环境信息，当用户第一次登录时，该文件被执行，
并从/etc/profile.d目录的配置文件中搜集shell的设置。
然后读取/etc/profile.d目录下的脚本
有系统诸多脚本，也放入自定义需要登录加载的脚本
便于用于登录后立即运行脚本
运行$HOME/.bash_profle（用户环境变量文件）
运行$HOME/.bashrc
运行/etc/bashrc
<!-- OCR_END -->

# shell实践

<!-- OCR_START -->
- Shell:
- source script
- command1
- command2
- ②
- /bin/bash script
- Subshell:
- /script
<!-- OCR_END -->

## 父子shell

父shell：我们在登录某个虚拟机控制器终端的时候(连接某一个linux虚拟机)时，默认启动的交互式shell，然后等待命令输入

ps命令参数，是否有横杠的参数作用是不一样的

```plain
-f 　显示UID,PPID,C与STIME栏位。
f 　用ASCII字符显示树状结构，表达进程间的相互关系。
-e 　此参数的效果和指定"A"参数相同。
e 　列出进程时，显示每个进程所使用的环境变量。
```

案例

```plain
1.于超老师登录自己的虚拟机
[yuchao@yumac Luffy_linux]$sshpyyu
Last login: Sat Sep 26 21:06:16 2020 from 221.218.215.96
[root@chaogelinux ~]#
2.一条命令，查看进程的父子关系
[root@chaogelinux ~]# ps --forest -ef
# 观察如下信息，可以清晰看出父子关系
root      1830     1  0 9月25 ?       00:00:00 /usr/sbin/sshd -D
root     15105  1830  0 21:07 ?        00:00:00  \_ sshd: root@pts/0
root     15107 15105  0 21:07 pts/0    00:00:00      \_ -bash
root     16074 15107  0 21:11 pts/0    00:00:00          \_ ps --forest -ef
```

## 子shell

当在CLI的提示符下，输入/bin/bash指令，或者其他bash指令，会创建一个新的shell程序，这就被称之为`子shell（child shell）`

子shell同样的拥有CLI提示符，可以输入命令。

使用如下命令，超哥教你如何查看父子的诞生

```plain
[root@chaogelinux ~]# ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
root     15107 15105  0 21:07 pts/0    00:00:00 -bash
root     16893 15107  0 21:17 pts/0    00:00:00 ps -f
当前父shell   15107
[root@chaogelinux ~]# ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
root     15107 15105  0 21:07 pts/0    00:00:00 -bash
root     16966 15107  1 21:18 pts/0    00:00:00 bash
root     17144 16966  0 21:18 pts/0    00:00:00 ps -f
第一次父bash的pid，15107
第二次执行bash，子shell的pid， 16966，ppid是15107，由此看出是子shell
```

输入bash指令之后，一个子shell就产生了。

* 第一个ps -ef命令是在父shell里执行的
* 第二个ps -ef是在子shell里执行的。

<!-- OCR_START -->
- 父shell
- 子shell
- 创建子shell
- 发出命令：
- bash
- ps-f
<!-- OCR_END -->

子shell生成时，父进程的部分环境变量被复制到子shell里，这个后面于超老师在给大家说。

### 多个子shell

```plain
1.当前shell关系
root      1830     1  0 9月25 ?       00:00:00 /usr/sbin/sshd -D
root     22206  1830  0 09:23 ?        00:00:00  \_ sshd: root@pts/2
root     22208 22206  0 09:23 pts/2    00:00:00      \_ -bash
root     22757 22208  0 09:24 pts/2    00:00:00          \_ ps -ef --forest
2.执行多个bash，开启多个子shell
连续输入四次bash之后
root      1830     1  0 9月25 ?       00:00:00 /usr/sbin/sshd -D
root     22206  1830  0 09:23 ?        00:00:00  \_ sshd: root@pts/2
root     22208 22206  0 09:23 pts/2    00:00:00      \_ -bash
root     22844 22208  0 09:25 pts/2    00:00:00          \_ bash
root     23017 22844  0 09:25 pts/2    00:00:00              \_ bash
root     23190 23017  1 09:25 pts/2    00:00:00                  \_ bash
root     23363 23190  1 09:25 pts/2    00:00:00                      \_ bash
root     23537 23363  0 09:25 pts/2    00:00:00                          \_ ps -ef --forest
```

<!-- OCR_START -->
- 父shell
- bash的子shell
- 创建
- 发出命令：
- 子shell
- bash
- 创建子shell
- bash的曾孙shell
- ps
- --forest
<!-- OCR_END -->

退出子shell

```plain
exit 可以退出子shell，也可以退出当前的虚拟控制台终端。
只需要在父shell里输入exit就可以退出了。
```

## 进程列表

若是超哥想要执行一系列的命令，可以通过命令列表来实现，如下

```plain
[root@chaogelinux ~]# pwd;ls;cd /opt;pwd;ls
这样的写法，命令的确会依次执行，但是这并不是【进程列表】
```

必须如下写法才是

```plain
[root@chaogelinux opt]# (cd ~;pwd;ls ;cd /tmp;pwd;ls)
命令列表，必须写入括号里，进程列表是生成子shell去执行对应的命令。
```

进程列表的语法就是如上

```plain
(command1;command2)
```

### 检测子shell

通过一个环境变量，检查子shell是否存在

```plain
[root@chaogelinux opt]# echo $BASH_SUBSHELL
0
结尾为0则没有子shell，非0就是有子shell
```

非子shell的执行命令

```plain
[root@chaogelinux opt]# cd ~;pwd;ls ;cd /tmp;pwd;ls;echo $BASH_SUBSHELL
能够看到结果为0，表示是父shell直接执行
```

子shell的执行形式

```plain
[root@chaogelinux tmp]# (cd ~;pwd;ls ;cd /tmp;pwd;ls;echo $BASH_SUBSHELL)
看到结果不为0了，表示是在子shell里运行了
```

### 子shell嵌套

```plain
刚才我们是用了一个括号，开启子shell，现在可以开启多个子shell
[root@chaogelinux tmp]# (pwd;echo $BASH_SUBSHELL)
/tmp
1
细心的同学观察下，超哥这里是怎么改动的
[root@chaogelinux tmp]# (pwd;(echo $BASH_SUBSHELL))
/tmp
2
观察到环境变量的数字已经发生了变化，其实是通过两个括号，创建了2个子shell。
```

shell脚本开发里，经常会使用子shell进行多进程处理。

## 后台执行与子shell

在我们日常shell命令执行里，很多地方都有用到子shell，如进程列表、协程、管道等。

一个高效的子shell用法是和后台结合使用。

使用`sleep`命令

```plain
sleep 3
sleep将你会话暂停3秒，然后返回shell
```

不希望sleep卡住会话，将它放在后台

```plain
[root@chaogelinux tmp]# sleep 300&
[1] 27520
显示的是后台作业的id号（background job  1），以及后台进程的PID(27520)
[root@chaogelinux tmp]# ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
root     24734 24731  0 09:36 pts/2    00:00:00 -bash
root     27520 24734  0 09:57 pts/2    00:00:00 sleep 300
root     27557 24734  0 09:57 pts/2    00:00:00 ps -f
我们发现是基于bash父shell的24734生成的27520
```

### jobs命令

```plain
[root@chaogelinux tmp]# jobs
[1]+  运行中               sleep 300 &
[root@chaogelinux tmp]#
```

jobs命令可以显示后台作业信息

```plain
[root@chaogelinux tmp]# jobs -l
[1]+ 27520 运行中               sleep 300 &
显示pid信息
一旦后台jobs完成，就会显示出结束状态。
[1]+  完成                  sleep 300
```

### 进程列表放入后台

先看一个事例

```plain
[root@chaogelinux tmp]# (sleep 2;echo $BASH_SUBSHELL;sleep 2)
1
这个案例，会有2秒的暂停，显示数字，表示只有一个子shell，然后又暂停了2秒，最终返回提示符
```

在看下进程列表，结合后台模式的效果

```plain
[root@chaogelinux tmp]# (sleep 2;echo $BASH_SUBSHELL;sleep 2)&
[1] 29308
[root@chaogelinux tmp]# 1
[1]+  完成                  ( sleep 2; echo $BASH_SUBSHELL; sleep 2 )
```

这样的子shell用法，目的是在于，开辟子shell处理繁琐的工作，同时保证不会让子shell限制终端的使用。

我们会在后面学习结合tar命令进行后台压缩的实用案例。

```plain
# 这里注意，tar压缩的时候，会有报警信息，原因是绝对路径的问题，可以忽略，是系统为了保护文件的操作
[root@chaogelinux tmp]# (tar -cf Tmp.tar /tmp;tar -Pcf Home.tar /home)&
[1] 29931
```

此时可以通过命令检查，父子shell的执行方式

```plain
[root@chaogelinux tmp]# ps -ef --forest
root      1830     1  0 9月25 ?       00:00:00 /usr/sbin/sshd -D
root     24731  1830  0 09:36 ?        00:00:00  \_ sshd: root@pts/2
root     24734 24731  0 09:36 pts/2    00:00:00      \_ -bash
root     30337 24734  0 10:28 pts/2    00:00:00          \_ -bash
root     30341 30337 16 10:28 pts/2    00:00:02          |   \_ tar -cf Tmp.tar /tmp
root     30452 24734  1 10:28 pts/2    00:00:00          \_ ps -ef --forest
```

## 协程与子shell

协程也是在后台创建子shell，然后在子shell中执行命令

```plain
# 使用coproc命令
[root@chaogelinux tmp]# coproc sleep 10
[1] 31253
[root@chaogelinux tmp]#
[root@chaogelinux tmp]#
[root@chaogelinux tmp]#
[1]+  完成                  coproc COPROC sleep 10
[root@chaogelinux tmp]# ps -ef --forest
root      1830     1  0 9月25 ?       00:00:00 /usr/sbin/sshd -D
root     24731  1830  0 09:36 ?        00:00:00  \_ sshd: root@pts/2
root     24734 24731  0 09:36 pts/2    00:00:00      \_ -bash
root     31404 24734  0 10:34 pts/2    00:00:00          \_ sleep 10
root     31440 24734  0 10:34 pts/2    00:00:00          \_ ps -ef --forest
```

协程是将命令放在后台执行，也可以通过jobs命令看到

```plain
[root@chaogelinux tmp]# coproc sleep 10
[1] 31610
[root@chaogelinux tmp]# jobs
[1]+  运行中               coproc COPROC sleep 10 &
```

协程给任务起了个名字，`COPROC`，也可以自己指定名字

```plain
[root@chaogelinux tmp]# coproc Chao_ge_job { sleep 10; }
[1] 31840
[root@chaogelinux tmp]# jobs
[1]+  运行中               coproc Chao_ge_job { sleep 10; } &
```

通过这种写法，协程的名字指定了，注意扩展语法`{ 任务 }`花括号里面的空格。

# 内建命令

这里超哥曾经在15年在上海面试运维的时候，面试官问过这个问题：你知道linux内置命令，外置命令吗？

答：

> >

> 内置命令：在系统启动时就加载入内存，常驻内存，执行效率更高，但是占用资源
>
> 外置命令：用户需要从硬盘中读取程序文件，再读入内存加载

## 外部命令

外部命令也称作文件系统命令，存在于bash shell之外的程序，一般存在的路径是

```plain
/bin
/usr/bin
/sbin/
/usr/sbin
```

例如ps就是外部命令

```plain
[root@chaogelinux tmp]# which ps
/usr/bin/ps
[root@chaogelinux tmp]# type -a ps
ps 是 /usr/bin/ps
[root@chaogelinux tmp]# ls -l /usr/bin/ps
-rwxr-xr-x 1 root root 100112 10月 19 2019 /usr/bin/ps
```

外部命令在执行时，会创建一个子进程，我们还是可以通过ps命令查看，进程id号

```plain
[root@chaogelinux tmp]# ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
root       750 24734  0 10:45 pts/2    00:00:00 ps -f
root     24734 24731  0 09:36 pts/2    00:00:00 -bash
ps命令是父bash，创建新的进程750执行的。
```

<!-- OCR_START -->
- 父进程
- 子进程
- 衍生
- 发出外部命令：
- 执行外部命令：
- ps -f
<!-- OCR_END -->

无论是子进程，还是子shell，我们都可以通过发送`signaling信号`和其沟通。

## 内置命令

内置命令和外置命令的区别，就在于`是否会创建子进程去执行`。

内置命令和shell编译为一体，是shell的一部分，不需要外部程序文件执行。

还是可以通过`type`了解命令是否是内建的。

```plain
[root@chaogelinux tmp]# type cd
cd 是 shell 内嵌
[root@chaogelinux tmp]# type exit
exit 是 shell 内嵌
```

因为内置命令不需要衍生子进程执行，也不用打开程序文件，执行速度更快，效率也更高。

### 查看内置命令

```plain
# 该命令列出所有的bash shell可以用的内置命令
[root@web01 ~ 11:33:33]$compgen -b
```

### 查看外置命令

除了以上的内置命令，日常使用的大部分命令都是外部命令啦。

可以用type验证下即可。

# Linux环境变量

变量的概念，超哥前面已经给大家介绍了。

Linux环境变量可以提升shell使用体验，很多程序和脚本通过环境变量来获取系统信息，存储的临时数据和配置信息。

## 什么是环境变量

`environment variable`的作用是存储有关shell会话和工作环境的信息，因此也称之为环境变量。

它允许你在内存里存储临时数据，便于程序或者shell能够轻松的访问。

bash shell里，环境变量分为两类：

* 全局变量
* 局部变量

## 全局环境变量

全局环境变量对于shell会话和所有的子shell都是可以访问到的。

局部环境变量是只针对创建他们的shell可见。

Linux在bash会话启动时就设定里全局环境变量：

* 系统环境变量，区别在于纯大写字母
* 用户配置的环境变量

```plain
1.查看全局环境变量
env
printenv
```

要想显示某个环境变量的值

```plain
[root@web01 ~ 12:02:44]$printenv HOME
/root
# 也可以用echo命令
[root@web01 ~ 12:03:13]$echo $HOME
/root
# 也可以利用变量的值，作为参数使用
[root@web01 ~ 12:04:02]$ls $HOME
# 既然是全局变量，进入子shell，也是可以看到，和父shell是一样的结果
[root@web01 ~ 12:04:53]$bash
[root@web01 ~]# echo $HOME
/root
```

## 局部环境变量

局部变量只能在定义他们的进程里可见，局部变量无法单独查看，可以用set命令查到所有的环境变量，包含局部变量，全局变量，以及用户自定义变量。

> >

> env、printenv、set之间的差异微小
>
> set显示全局变量，局部变量，用户自定义变量，以及按照字母顺序排序
>
> env、printenv命令和set的区别在于不会排序，也不会输出局部变量和自定义变量。

### 局部用户定义变量

注意，加上引号

自定义的变量，尽量用小写字母，进行和系统变量区分开，防止修改系统变量导致灾难。

```plain
[root@web01 ~]# echo $my_name
[root@web01 ~]# my_name="超哥"
[root@web01 ~]#
[root@web01 ~]# echo $my_name
超哥
[root@web01 ~]# set |grep my_name
my_name=超哥
```

局部变量，在父子shell是不可见的

```plain
[root@web01 ~]# echo $my_name
超哥
[root@web01 ~]#
[root@web01 ~]# bash
[root@web01 ~]# echo $my_name
# 退回父shell
[root@web01 ~]# my_age=18
[root@web01 ~]# echo $my_age
18
[root@web01 ~]# exit
exit
[root@web01 ~]# echo $my_age
```

想要解决这个问题，就可以设置全局变量来改变这个情况。

## 设置全局变量

```plain
[root@web01 ~]# export name='超哥带你学shell'
[root@web01 ~]#
[root@web01 ~]# printenv name
超哥带你学shell
[root@web01 ~]#
[root@web01 ~]# bash
[root@web01 ~]#
[root@web01 ~]# printenv name
超哥带你学shell
```

通过`export`命令设置全局变量，在子shell里也都是可见的。

### 作用域优先级

父shell的环境变量优先级，是高于子shell的，也就是：

* 子shell里修改了全局变量，也不回影响到父shell

通过如下过程，**看出子shell不会影响到父shell的变量**

```plain
1.当前的父shell
[root@web01 ~]# name='我是超哥，这里是全局变量'
[root@web01 ~]#
[root@web01 ~]# export name='我是超哥，这里是全局变量'
[root@web01 ~]#
[root@web01 ~]#
[root@web01 ~]# bash
[root@web01 ~]#
[root@web01 ~]# name='我是子shell，我也是超哥'
[root@web01 ~]#
[root@web01 ~]#
[root@web01 ~]# printenv name
我是子shell，我也是超哥
[root@web01 ~]#
[root@web01 ~]# exit
exit
[root@web01 ~]#
[root@web01 ~]# printenv name
我是超哥，这里是全局变量
2.子shell即使用export也无法修改父shell的变量值
```

## 删除变量

```plain
[root@web01 ~]# unset name
[root@web01 ~]# echo $name
```

要注意的还是，在子shell里删除变量，也不回影响父shell

## 查找变量

小技巧，过滤出部分系统的环境变量

```plain
[root@web01 ~]# set |grep  '^[A-Z]' |wc -l
```

查找出部分自定义变量

```plain
[root@web01 ~]# set |grep  '^[a-z]'
colors=/root/.dircolors
name=age
dequote ()
quote ()
quote_readline ()
```

## PATH变量

PATH变量的作用，超哥已经在其他章节给大家讲解过了。

## 登录Shell

登录Linux时，bash shell是默认的shell启动，shell会从5个文件中读取，是否定义了环境变量

* /etc/profile
* $HOME/.bash_profile
* $HOME/.bashrc
* $HOME/.bash_login
* $HOME/.profile

`/etc/profile`文件是系统上默认的bash主启动文件，每个用户启动都会执行该文件。

该文件利用了`for`语句，进行配置文件循环读取，遍历执行`/etc/profile.d`目录下所有的文件

```plain
[root@web01 ~]# ls  /etc/profile.d/
```

## 交互式shell

刚才说的登录shell，是系统启动，首次登录时启动的shell。

交互式shell，指的是`当你手动输入bash指令，进入的子shell`，这个称之为交互式shell，提供命令行提示符，用户进行输入命令交互。

> 如果bash是交互式shell启动的，不会访问/etc/profile，只会检查HOME目录下的.bashrc文件
>
> \[root@web01 ~]# cat ~/.bashrc
>
> 这个文件有两个作用：
>
> 1.执行/etc/bashrc文件
>
> 2.为用户提供自定义的命令别名，自定义变量，以及shell函数执行。

## 非交互式shell

说了上面的两种shell，就是因为还存在非交互式shell。

这种形式是用来执行shell脚本，它没有命令行提示符。

```plain
[root@web01 ~]# cat hello.sh
#!/bin/bash
echo 'hello 超哥，你讲的课真有意思'
[root@web01 ~]# bash hello.sh
hello 超哥，你讲的课真有意思
```

## 永久性环境变量

对于想要设置永久的环境变量，也就是每次开机都能够生效，大多数运维的习惯是写入`/etc/profile`

但是要注意，如果系统某天升级了，这个文件也会更新，所定制的环境变量也就消失了。

因此正确的操作是

> 在/etc/profile.d/目录创建.sh文件，在该脚本文件中定义环境变量。

> 更新: 2022-12-20 21:16:31  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/abeqrr>