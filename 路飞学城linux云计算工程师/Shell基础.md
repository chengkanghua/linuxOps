# Shell基础

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


```bash
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

```


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

## shell和运维

shell脚本语言很适合处理纯文本类型数据，且Linux的哲学思想就是一切皆文件，如日志、配置文件、文本、网页文件，大多数都是纯文本类型的，因此shell可以方便的进行文本处理，好比强大的Linux三剑客（grep、sed、awk）

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

**变量是暂时存储数据的地方，是一种数据标记（房间号，标记了客人所在的位置），数据存储在内容空间，通过调用正确的变量名字，即可取出对应的值。**

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
  * 名称定义要做到见名知意，切按照规则来，切不得引用保留关键字(help检查保留字)
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

# Shell变量

## 本地变量

定义Shell变量，变量名不需要加美元符$

本地变量只在用户当前shell生存期中有效，如

<!-- OCR_START -->
- root@chaogelinux~]#story_one="大师兄，师傅被妖怪抓走了"
- root@chaogelinux
- <~』#
- <~]#
- [root@chaogelinux ~]# echo ${story_one}
- 大师兄，师傅被妖怪抓走了
- <~]#bash
- 开启子shell,
- 变量丢失
<!-- OCR_END -->

### 变量定义

变量名要求：字母、数字、下划线组成、可以是字母或是下划线开头，如

* chaoge
* chao_ge123
* \_chao_ge123

变量名严格区分大小写

* Chao_ge
* chao_ge

```plain
1.赋值不加引号
story_three=大师兄，快来救我

2.赋值单引号
story_two='大师兄，三师弟被妖怪抓走了'

3.赋值双引号
story_one="大师兄，师傅被妖怪抓走了"
```

### 取出变量值

* 单引号，所见即所得，强引用
* 双引号，输出引号里所有内容，识别特殊符号，弱引用
* 无引号，连续的符号可以不加引号，有空格则有歧义，最好使用双引号
* 反引号，引用命令执行结果，等于$()用法

### 特殊变量

shell的特殊变量，用在如脚本，函数传递参数使用，有如下特殊的，位置参数变量

```bash
$0        获取shell脚本文件名，以及脚本路径
$n        获取shell脚本的第n个参数,n在1~9之间，如$1 ,$2, $9 ，大于9则需要写，${10}，参数空格隔开
$#        获取执行的shell脚本后面的参数总个数
$*         获取shell脚本所有参数，不加引号等同于$@作用，加上引号"$*"作用是 接收所有参数为单个字符串，"$1 $2.."
$@        不加引号，效果同上，加引号，是接收所有参数为独立字符串，如"$1" "$2"  "$3" ...，空格保留
```

特殊变量实践

```bash
[root@chaogelinux tmp]# sh /tmp/p.sh yu chao cc
/tmp/p.sh yu chao

# 脚本内容
[root@chaogelinux tmp]# cat p.sh
###################################################################
# File Name: p.sh
# Author: pyyu
# mail: yc_uuu@163.com
# Created Time: 2020年05月25日 星期一 18时39分55秒
#=============================================================
[root@chaogelinux shell_program]# cat special_var.sh
#! /bin/bash
echo '---特殊变量 $0 $1 $2 ..的实践'
echo '结果：'  $0 $1 $2

echo '#####################'
echo '---特殊变量$# 获取参数总个数'
echo '结果：'  $#

echo '#####################'
echo '---特殊变量$* 实践'
echo '结果：'  $*

echo '#####################'

echo '---特殊变量$@ 实践'
echo '结果：' $@
```

  

## 面试题分享


$*和$@ 的区别

```bash
$* 和 $@ 都表示传递给函数或脚本的所有参数

当 $* 和 $@ 不被双引号" "包围时，它们之间没有任何区别，都是将接收到的每个参数看做一份数据，彼此之间以空格来分隔。

但是当它们被双引号" "包含时，就会有区别了：
"$*"会将所有的参数从整体上看做一份数据，而不是把每个参数都看做一份数据。
"$@"仍然将每个参数都看作一份数据，彼此之间是独立的。

比如传递了 5 个参数，那么对于"$*"来说，这 5 个参数会合并到一起形成一份数据，它们之间是无法分割的；而对于"$@"来说，这 5 个参数是相互独立的，它们是 5 份数据。

如果使用 echo 直接输出"$*"和"$@"做对比，是看不出区别的；但如果使用 for 循环来逐个输出数据，立即就能看出区别来。
```

实践

```bash
[root@chaogelinux shell_program]# cat t1.sh
#!/bin/bash
echo "print each param from \"\$*\""
for var in "$*"
do
    echo "$var"
done
echo "print each param from \"\$@\""
for var in "$@"
do
    echo "$var"
done
```

  

### 特殊状态变量

```bash
$? 上一次命令执行状态返回值，0正确，非0失败
$$  当前shell脚本的进程号
$! 上一次后台进程的PID
$_ 再次之前执行的命令，最后一个参数

查找方式 man bash   
    搜索Special Parameters
```

脚本控制返回值

```bash
[root@chaogelinux learnshell]# cat t4.sh
###################################################################
# File Name: t4.sh
# Author: pyyu
# mail: yc_uuu@163.com
# Created Time: 2020年05月26日 星期二 17时06分08秒
#=============================================================
#!/bin/bash
[ $# -ne 2 ] && {
    echo "must be two args"
    exit 119 #终止程序运行，且返回119状态码，提供给当前shell的$?变量，若是在函数里 可以return 119用法
}
echo ok
```

上一次后台进程的PID

```bash
[root@chaogelinux shell_program]# nohup ping baidu.com & 1> /dev/null
[1] 21629
[root@chaogelinux shell_program]# nohup: 忽略输入并把输出追加到"nohup.out"

[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# echo $!
21629
[root@chaogelinux shell_program]# ps -ef|grep ping
root     21629 20999  0 15:46 pts/0    00:00:00 ping baidu.com
```

$$ 当前shell脚本的进程号

```bash
[root@chaogelinux shell_program]# cat special_var.sh
#! /bin/bash
echo '---特殊变量 $0 $1 $2 ..的实践'
echo '结果：'  $0 $1 $2

echo '#####################'
echo '---特殊变量$# 获取参数总个数'
echo '结果：'  $#

echo '#####################'
echo '---特殊变量$* 实践'
echo '结果：'  $*

echo '#####################'

echo '---特殊变量$@ 实践'
echo '结果：' $@

echo "当前脚本执行的进程号：$$"
```

$\_ 再次之前执行的命令，最后一个参数

```bash
[root@chaogelinux shell_program]# ls $_
special_var.sh

[root@chaogelinux shell_program]# cat $_
```

## bash shell内置变量命令

bash本身提供的一些内置命令

```bash
echo
eval
exec
export
read
shift
```

### echo命令

```bash
-n 不换行输出内容
-e 解析转义字符

\n    换行
\r    回车
\t    tab
\b  退格
\v    纵向制表符
```

案例

```bash
[root@chaogelinux learnshell]# echo chaoge;echo cc
chaoge
cc
[root@chaogelinux learnshell]# echo chaoge;echo cc -n
chaoge
cc -n
[root@chaogelinux learnshell]# echo -n  chaoge;echo cc
chaogecc
[root@chaogelinux learnshell]#
[root@chaogelinux learnshell]#
[root@chaogelinux learnshell]# echo "cc\tyy\tdd"
cc\tyy\tdd
[root@chaogelinux learnshell]# echo -e  "cc\tyy\tdd"
cc    yy    dd
[root@chaogelinux learnshell]# printf "cc\tyy\tdd\n"
cc    yy    dd
```

### eval

eval 执行多个命令。

```bash
[root@chaogelinux shell_program]# eval ls ;cd /tmp

```

### exec

```bash
不创建子进程，执行该命令，exec执行后自动exit

[root@chaogelinux learnshell]# exec date
2020年 05月 26日 星期二 17:28:03 CST
Connection to pyyuc closed.
```

## shell子串

子串就是一个完整字符串的一部分，通过shell特有语法截取。

```bash
${变量}                                      返回变量值
${#变量}                                  返回变量长度，字符长度
${变量:start}                     返回变量Offset数值之后的字符
${变量:start:length}   提取offset之后的length限制的字符 
${变量#word}                          从变量开头删除最短匹配的word子串
${变量##word}                      从变量开头，删除最长匹配的word
${变量%word}                         从变量结尾删除最短的word
${变量%%word}                     从变量结尾开始删除最长匹配的word
${变量/pattern/string}  用string代替第一个匹配的pattern
${变量//pattern/string} 用string代替所有的pattern
```

案例

## 子串基本用法

> Shell 截取字符串通常有两种方式：从指定位置开始截取和从指定字符（子字符串）开始截取。
>
> 从指定位置开始截取
>
> 这种方式需要两个参数：除了指定起始位置，还需要截取长度，才能最终确定要截取的字符串。
>
> 既然需要指定起始位置，那么就涉及到计数方向的问题，到底是从字符串左边开始计数，还是从字符串右边开始计数。答案是 Shell 同时支持两种计数方式。
>
> 1) 从字符串左边开始计数
>
> 如果想从字符串的左边开始计数，那么截取字符串的具体格式如下：
>
> ${string: start :length}
>
> 其中，string 是要截取的字符串，start 是起始位置（从左边开始，从 0 开始计数），length 是要截取的长度（省略的话表示直到字符串的末尾）。

```bash
[root@chaogelinux ~]# name="chao"
[root@chaogelinux ~]# echo ${name}
chao

[root@chaogelinux ~]# echo ${#name}
4

# 从start位置开始截取
[root@chaogelinux ~]# echo ${name:3}
o
[root@chaogelinux ~]# echo ${name:2}
ao
[root@chaogelinux ~]# echo ${name:1}
hao

# 指定start，以及元素长度
[root@chaogelinux ~]# echo ${name:1:2}
ha
```

计算变量值，长度的玩法

```bash

# 计算变量值，长度的玩法

[root@chaogelinux ~]# echo $name|wc -L #计算字符串长度
11
# 解释
# 打印行数
[root@chaogelinux shell_program]# cat test.txt |wc -l
2
# 打印最长行数的元素个数
[root@chaogelinux shell_program]# cat test.txt |wc -L
5

[root@chaogelinux ~]# expr length "$name"  #expr的length函数计算长度
11

[root@chaogelinux ~]# echo "$name" | awk '{print length($0)}'    #用awk的length函数
11

#最快的方式
[root@chaogelinux ~]# echo ${#name}
11
```


字符串长度计算，多种方法，谁最快？

速度比较

```bash
# 最快方式
# seq -s 指定分隔符
# seq -s ":" 100
# 执行3次打印的命令，打印出一个指定了分隔符的1～100的序列
for n in {1..3};do char=`seq -s ":" 100`;echo ${char} ;done

# 实践
[root@chaogelinux ~]# time for n in {1..10000};do char=`seq -s "chaoge" 100`;echo ${#char} &>/dev/null;done

real    0m11.041s
user    0m4.585s
sys    0m6.232s

#计算速度很慢，管道符和wc -L
[root@chaogelinux ~]# time for n in {1..10000};do char=`seq -s "chaoge" 100`;echo ${char}|wc -L &>/dev/null;done

real    0m38.577s
user    0m15.394s
sys    0m22.491s

# 性能还不错
[root@chaogelinux ~]# time for n in {1..10000};do char=`seq -s "chaoge" 100`;expr length "${char}" &>/dev/null;done

real    0m21.053s
user    0m8.673s
sys    0m11.944s

# awk再次加工，最慢
[root@chaogelinux ~]# time for n in {1..10000};do char=`seq -s "chaoge" 100`;echo ${char}|awk '{print length($0)}' &>/dev/null ;done

real    0m33.728s
user    0m13.839s
sys    0m19.121s
```

shell编程，尽量用内置系统操作，与内置函数

### 截取字符串

基本语法

```bash
# 从开头删除匹配最短
## 从开头删除匹配最长
% 从结尾删除匹配最短
%% 从结尾删除匹配最长

# 指定字符内容截取
a*c  匹配开头为a，中间任意个字符，结尾为c的字符串
a*C  匹配开头为a，中间任意个字符，结尾为C的字符串

#语法
name="yuchao"  # 该变量的值，有索引，分别是从 0，1，2，3，4开始

${变量}                                       返回变量值
${#name}                            返回变量长度，字符长度--------
${变量:start}                      返回变量start数值之后的字符，且包含start的数字
${变量:start:length}      提取start之后的length限制的字符 ，例如${name:4:1}
${变量#word}                           从变量开头删除最短匹配的word子串 ${name:yu}
${变量##word}                       从变量开头，删除最长匹配的word
${变量%word}                          从变量结尾删除最短的word
${变量%%word}                      从变量结尾开始删除最长匹配的word

替换
${变量/pattern/string}   用string代替第一个匹配的pattern
${变量//pattern/string}  用string代替所有的pattern
```

删除匹配的内容

```bash

[root@chaogelinux ~]# echo ${name} 
I am chaoge

[root@chaogelinux ~]# echo ${name:2:2} #第二个开始，取2个
am

[root@chaogelinux ~]# name2=abcABC123ABCabc
[root@chaogelinux ~]#
[root@chaogelinux ~]
[root@chaogelinux ~]#

# 从开头删除
[root@chaogelinux ~]# echo ${name2#a*C}  #从开头删除最短的a*C
123ABCabc

[root@chaogelinux ~]# echo ${name2##a*C}  #从开头删除最长的匹配
abc

# 从结尾删除
# 从结尾没有匹配到结果，原样返回
[root@chaogelinux ~]# echo ${name2%a*C}
abcABC123ABCabc

# 匹配到了就删除
[root@chaogelinux ~]# echo ${name2%a*c}
abcABC123ABC

# 匹配长的删除

# 删干净了，因为变量值name2=abcABC123ABCabc，匹配a*c，取最长的也就从前删到结尾
[root@chaogelinux ~]# echo ${name2%%a*c}

# 原样返回，因为从结尾开始匹配，压根就找不到a*C，因此不做处理

[root@chaogelinux ~]# echo ${name2%%a*C}
abcABC123ABCabc
```

替换字符串

```bash
[root@chaogelinux ~]# str1="Hello,man,i am your brother."
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]# echo $str1
Hello,man,i am your brother.
[root@chaogelinux ~]#
[root@chaogelinux ~]#
# 一个/ 替换匹配第一个合适的字符串
[root@chaogelinux ~]# echo ${str1/brother/sister}
Hello,man,i am your sister.

# 两个//，匹配所有的合适的字符串
# 替换所有的o为大写O
[root@chaogelinux ~]# echo ${str1//o/O}
HellO,man,i am yOur brOther.
```

删除文件名练习

```bash
删除所有图片文件名中的子串
[root@chaogelinux ~]# touch stu_102999_{1..5}_finished.jpg
[root@chaogelinux ~]# touch stu_102999_{1..5}_finished.png
[root@chaogelinux ~]# ll *.jpg *.png
-rw-r--r-- 1 root root 0 5月  26 18:05 stu_102999_1_finished.jpg
-rw-r--r-- 1 root root 0 5月  26 18:07 stu_102999_1_finished.png
-rw-r--r-- 1 root root 0 5月  26 18:05 stu_102999_2_finished.jpg
-rw-r--r-- 1 root root 0 5月  26 18:07 stu_102999_2_finished.png
-rw-r--r-- 1 root root 0 5月  26 18:05 stu_102999_3_finished.jpg
-rw-r--r-- 1 root root 0 5月  26 18:07 stu_102999_3_finished.png
-rw-r--r-- 1 root root 0 5月  26 18:05 stu_102999_4_finished.jpg
-rw-r--r-- 1 root root 0 5月  26 18:07 stu_102999_4_finished.png
-rw-r--r-- 1 root root 0 5月  26 18:05 stu_102999_5_finished.jpg
-rw-r--r-- 1 root root 0 5月  26 18:07 stu_102999_5_finished.png
```

1.去掉所有\_finished字符串

```bash
思路：
1.单个文件去掉后缀，很简单
[root@chaogelinux str1]# mv stu_102999_1_finished.jpg stu_102999_1.jpg

2.通过子串的替换方式
[root@chaogelinux str1]# f=stu_102999_1_finished.jpg
[root@chaogelinux str1]#
[root@chaogelinux str1]#
# 变量的子串功能，去掉后缀
[root@chaogelinux str1]# echo ${f//_finished/}
stu_102999_1.jpg

# 利用变量的反引用替换文件名
[root@chaogelinux str1]# mv $f `echo ${f//_finished/}`

# 剩下的文件，利用循环操作
# 找出剩下所有需要替换的jpg文件
[root@chaogelinux str1]# ls *fin*.jpg
stu_102999_2_finished.jpg  stu_102999_3_finished.jpg  stu_102999_4_finished.jpg  stu_102999_5_finished.jpg
[root@chaogelinux str1]#

# 写shell循环代码，循环操作
# 去掉所有jpg文件的_finished后缀
[root@chaogelinux str1]# for file in `ls *fin*.jpg`;do mv $file `echo ${file//_finished/}`;done
[root@chaogelinux str1]# ls *.jpg
stu_102999_1.jpg  stu_102999_2.jpg  stu_102999_3.jpg  stu_102999_4.jpg  stu_102999_5.jpg
[root@chaogelinux str1]#
```

  

# 特殊shell扩展变量处理

语法

parameter，参数，范围

```bash
如果parameter变量值为空，返回word字符串
${parameter:-word} 

如果para变量为空，则word替代变量值，且返回其值
${parameter:=word}

如果para变量为空，word当作stderr输出，否则输出变量值
用于设置变量为空导致错误时，返回的错误信息
${parameter:?word}

如果para变量为空，什么都不做，否则word返回
${parameter:+word}
```

扩展变量实践

演示1\

```bash
[root@chaogelinux str1]# echo $chaoge

[root@chaogelinux str1]#
[root@chaogelinux str1]#
# 当chaoge没有值，heihei被返回，赋值给result
[root@chaogelinux str1]# result=${chaoge:-heihei}
[root@chaogelinux str1]#
[root@chaogelinux str1]# echo $result
heihei
# 要注意的是，此时chaoge还是空
[root@chaogelinux str1]# echo $chaoge

[root@chaogelinux str1]#

# 情况2，当chaoge变量有值时，该特殊扩展变量的符号，也就不起作用了
[root@chaogelinux str1]# echo $chaoge
pangzi

[root@chaogelinux str1]#
[root@chaogelinux str1]# result=${chaoge:-heihei}
[root@chaogelinux str1]# echo $result
pangzi
[root@chaogelinux str1]# echo $chaoge
pangzi
```

演示2

:=

该特殊情况用于保证变量始终有值

```bash
# 撤销变量
[root@chaogelinux str1]# echo $chaoge
[root@chaogelinux str1]# unset result
# 发现，hehe不但给了result，还给了chaoge变量
[root@chaogelinux str1]# result=${chaoge:=hehe}
[root@chaogelinux str1]# echo $result
hehe
[root@chaogelinux str1]# echo $chaoge
hehe

# 如果变量有值，什么事也不做
[root@chaogelinux str1]# result=${chaoge:apple}
[root@chaogelinux str1]# echo $result
hehe
[root@chaogelinux str1]# echo $chaoge
hehe
```

演示3

:?，当变量不存在时候，输出指定信息

```bash
[root@chaogelinux str1]# echo ${cc}

# 默认错误

[root@chaogelinux str1]# echo ${cc:?}
-bash: cc: 参数为空或未设置

[root@chaogelinux str1]# echo ${cc:?cc不存在}
-bash: cc: cc不存在

# 变量有值，则不做处理
[root@chaogelinux str1]# cc="happy"
[root@chaogelinux str1]# echo ${cc:?cc不存在}
happy
```

演示4

:+ 如果变量为空，什么都不做，否则替换

```bash
[root@chaogelinux str1]# unset cc result chaoge

# 为空
[root@chaogelinux ~]# result=${name:+chaoge}
[root@chaogelinux ~]# echo $result

[root@chaogelinux ~]# echo $name

[root@chaogelinux ~]#

# 不为空
[root@chaogelinux ~]# name="xiaoyu"
[root@chaogelinux ~]#
# 后面的值，返回给result
[root@chaogelinux ~]# result=${name:+chaoge}
[root@chaogelinux ~]# echo $result
chaoge
[root@chaogelinux ~]# echo $name
xiaoyu
```

# 扩展变量的应用场景

在脚本开发中，例如数据备份、删除的脚本

删除7天前的过期数据

```bash
[root@chaogelinux shell_program]# cat del_data.sh
find ${path:=/tmp} -name '*.tar.gz' -type f -mtime +7|xargs rm -f

# 上述就对path变量做了处理，否则如果path变量为定义，命令就会报错
# 有误的脚本，未指定path的路径，就会在当前目录删除，程序就有了歧义，bug
[root@chaogelinux shell_program]# cat del_data.sh
find ${path} -name '*.tar.gz' -type f -mtime +7|xargs rm -f
[root@chaogelinux shell_program]#
```

> 更新: 2022-12-20 21:59:14  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/pxroqb>