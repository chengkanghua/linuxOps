# Shell 基础

> Shell 是运维人员每天都要打交道的东西。本篇先讲清楚 Shell 和 Shell 脚本是什么、为什么运维离不开它，再一步步学习 bash 的特性、变量、字符串处理和扩展变量，为后面写运维脚本打好底子。

## 本章目录

**第一篇 · 认识 Shell**
- 一、什么是 Shell
- 二、什么是 Shell 脚本
- 三、Shell 和运维
- 四、脚本语言

**第二篇 · Bash 基础特性与环境变量**
- 五、Bash 基础特性
- 六、环境变量设置

**第三篇 · Shell 变量、子串与扩展**
- 七、Shell 变量
- 八、Shell 子串
- 九、特殊 Shell 扩展变量处理
- 十、扩展变量的应用场景

---

# 第一篇 · 认识 Shell

## 一、什么是 Shell

用翻译软件查一下就知道，shell 的英文原意是"贝壳"。这个名字很形象——Shell 就是包裹在 Linux 内核外面的一层"壳"。

Shell 的作用是：

* 解释执行用户输入的命令或程序等
* 用户输入一条命令，Shell 就解释一条
* 键盘输入命令、Linux 给出响应，这种方式称之为交互式

Shell 在整个系统中的位置，可以用下面这张层次图表示，从外到内一层包一层：

```plain
┌──────────────────────────────────────────┐
│               外围应用程序                 │
│   ┌──────────────────────────────────┐   │
│   │  shell 解释器（翻译官、命令解释器）  │   │
│   │   ┌────────────────────────┐     │   │
│   │   │      操作系统核心        │     │   │
│   │   │    ┌──────────────┐    │     │   │
│   │   │    │   机器硬件     │    │     │   │
│   │   │    └──────────────┘    │     │   │
│   │   └────────────────────────┘     │   │
│   └──────────────────────────────────┘   │
└──────────────────────────────────────────┘
```

Shell 是一块包裹着系统核心的壳，处于操作系统的最外层，与用户直接对话：把用户的输入解释给操作系统，再把处理结果输出到屏幕，让用户看到。

比如在终端执行一条 echo 命令，输入什么就回显什么：

```plain
[root@chaogelinux data]# echo "超哥带你学shell"
超哥带你学shell
```

从登录 Linux、输入账号密码，到进入交互式界面，所有操作都是交给 Shell 解释并执行的。整条链路如下：

```plain
                  超哥（用户）
          敲键盘输入命令，例如 ls
                     │
                     ▼
 ┌─────────────────────────────────────────────┐
 │ shell 壳                                    │
 │  · 通过 bash 解释器：解析和翻译用户输入        │
 │  · terminal 终端：接受输入，绘制输出           │
 └─────────────────────────────────────────────┘
       │ 系统调用                       ▲ stdout/stderr
       ▼                               │
            操作系统内核 kernel  ───────┘
                     │
                     ▼
                  计算机硬件
```

我们想获取计算机的数据，不可能每次都编写程序、编译后再运行。比如找一个文件，难道要先写一段 C 代码、调用系统函数、用 gcc 编译后才能运行？

于是有了 Shell 解释器：只要敲下 `ls -lh` 这样的字符串，Shell 就会把它解释成 `ls -l -h` 然后执行，并通过终端输出结果，图形界面和命令行界面都一样。

即使是图形界面下"点点点"的动作，区别也只是：

* 命令行操作，Shell 解释执行后，把结果输出到黑屏命令行界面
* 图形化操作，Shell 接受点击动作，输出图案数据

> 💡 可以把 Shell 想象成一个"翻译官"：你对翻译软件说"请将我这句话翻译成英文，否则老外看不懂"，它马上给出 "Please translate this sentence into English, otherwise the foreigner will not understand"。Shell 做的事同理——把人说的命令，翻译成内核听得懂的系统调用。

## 二、什么是 Shell 脚本

把命令或者程序语句写进文件，执行文件时依次读取其中的代码，这个程序文件就称之为 Shell 脚本。

在脚本里定义多条 Linux 命令和循环控制语句，一次性全部执行完，这种执行方式称之为非交互式方式。

* Windows 中存在 `*.bat` 批处理脚本
* Linux 中常用 `*.sh` 脚本文件

看一个例子：脚本里只有两条语句，`ls .` 列出当前目录内容，`echo` 打印结束语。用 `sh test1.sh` 执行，命令依次跑完，最后打印"脚本执行完毕~"：

```plain
[root@chaogelinux data]# cat test1.sh
ls .
echo "脚本执行完毕~"
[root@chaogelinux data]# sh test1.sh
books.txt    luffycity.com    pyyu.txt    test_umask.txt
chaoge2.txt  luffy.txt        test        tttttt.txt
chaoge.txt   mytasks.at       test1.sh    yu.txt
lovers.txt   pwd.txt          test.txt    yuyuyuyu.txt
脚本执行完毕~
```

**Shell 脚本规则**

在 Linux 系统中，Shell 脚本（也叫 bash shell 程序）通常用 vim 编辑，由 Linux 命令、bash shell 指令、逻辑控制语句和注释信息组成。

### Shebang

计算机程序中，`shebang` 指的是出现在文本文件第一行的前两个字符 `#!`。

在 Unix 系统中，程序会分析 `shebang` 后面的内容，把它作为解释器的指令，例如：

* 以 `#!/bin/sh` 开头的文件，执行时会调用 `/bin/sh`，也就是 bash 解释器
* 以 `#!/usr/bin/python` 开头的文件，代表指定 python 解释器去执行
* 以 `#!/usr/bin/env 解释器名称` 开头，是一种在不同平台上都能正确找到解释器的办法

注意事项：

* 如果脚本未指定 `shebang`，执行时默认用当前 shell 去解释脚本，即 `$SHELL`
* 如果 `shebang` 指定了可执行的解释器，如 `/bin/bash`、`/usr/bin/python`，脚本在执行时，文件名会作为参数传递给解释器
* **如果#!指定的解释程序没有可执行权限，则会报错“bad interpreter: Permission denied”。**
* **如果#!指定的解释程序不是一个可执行文件，那么指定的解释程序会被忽略，转而交给当前的SHELL去执行这个脚本。**
* **如果#!指定的解释程序不存在，那么会报错“bad interpreter: No such file or directory”。**
* **#!之后的解释程序，需要写其绝对路径（如：#!/bin/bash），它是不会自动到$PATH中寻找解释器的。**
* **如果你使用"bash test.sh"这样的命令来执行脚本，那么#!这一行将会被忽略掉，解释器当然是用命令行中显式指定的bash。**

先看一个最简单的脚本案例：

```plain
[root@chaogelinux data]# cat test.sh
#!/bin/bash
echo "超哥强呀，奥力给"
#!/bin/bash 这里就是注释的作用了
```

系统自带的 bash 脚本、开机启动脚本，第一行同样是 shebang：

```plain
[root@chaogelinux data]# head -1 /etc/rc.d/init.d/network
#! /bin/bash
```

### 脚本注释与开发规范

* 在 Shell 脚本中，`#` 后面的内容代表注释，写给开发者或使用者看，系统会忽略这一行
* 注释可以单独写一行，也可以跟在命令后面
* 养成写注释的习惯，便于以后回顾代码的含义；注释尽量使用英文，而非中文

```plain
#! /bin/bash
# Date : 2019-11-28 14:59:18
# Author：created by chaoge
# Blog：www.cnblogs.com/pyyu
```

系统自带的网络服务脚本 `/etc/init.d/network` 就是一份规范的注释范例。截取其中一段可以看到，注释把每一部分的作用都交代得很清楚：

```bash
#! /bin/bash
#
# network      Bring up/down networking
#
# chkconfig: 2345 10 90
# description: Activates/Deactivates all network interfaces configured to \
#              start at boot time.
#
### BEGIN INIT INFO
# Provides: $network
# Should-Start: iptables ip6tables NetworkManager-wait-online NetworkManager $network-pre
# Short-Description: Bring up/down networking
# Description: Bring up/down networking
### END INIT INFO

# Source function library.
. /etc/init.d/functions

if [ ! -f /etc/sysconfig/network ]; then
    exit 6
fi

. /etc/sysconfig/network

if [ -f /etc/sysconfig/pcmcia ]; then
    . /etc/sysconfig/pcmcia
fi

# Check that networking is up.
[ "${NETWORKING}" = "no" ] && exit 6

# if the ip configuration utility isn't around we can't function.
[ -x /sbin/ip ] || exit 1
```

> 💡 这段脚本里有三类信息值得照抄：第一行 `#! /bin/bash` 是 shebang，指定解释器；开头大段注释说明脚本作用、chkconfig 级别和功能描述；正文中的注释则为具体代码的作用添加解释。以后写脚本，按这个标准来就够规范了。


### 执行 Shell 脚本的方式

* `bash script.sh` 或 `sh scripte.sh`：文件本身没有 x 权限、或者脚本没指定 `shebang` 时使用，是重点推荐的方式
* 使用 `绝对/相对` 路径执行脚本：需要文件含有 x 权限
* `source script.sh` 或者 `. script.sh`：在当前 shell 中执行，source 等同于点 `.`
* 少见的用法：`sh < script.sh`

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

## 三、Shell 和运维

Shell 脚本语言很适合处理纯文本类型的数据。而 Linux 的哲学思想是"一切皆文件"——日志、配置文件、文本、网页文件，绝大多数都是纯文本，所以 Shell 可以很方便地进行文本处理，比如强大的 Linux 三剑客 grep、sed、awk。

Shell 在运维技能体系中处于中心位置，周围各类服务和技术都要靠它串联起来：

| 方向 | 具体内容 |
| --- | --- |
| 基础操作 | 基础命令、定时任务 |
| Web 与开发 | Nginx/web、Django 服务、python 服务 |
| 系统与监控 | Linux 系统服务、Zabbix 监控 |
| 存储与基础设施 | 存储服务、虚拟化服务、云计算服务 |

## 四、脚本语言

Shell 脚本语言属于一种弱类型语言，`无需声明变量类型，直接定义使用`。

与之相对，`强类型语言必须先定义变量类型，确定是数字、字符串等，之后再赋予同类型的值`。

CentOS 7 系统中支持的 Shell 有如下种类：

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

默认的 sh 解释器其实是 bash 的软链接：

```plain
[root@chaogelinux ~]# ll /usr/bin/sh
lrwxrwxrwx 1 root root 4 11月 16 10:48 /usr/bin/sh -> bash
```

### 其他脚本语言

编程语言的种类非常多（可以想象成一张写满语言名字的词云：C、C++、Java、JavaScript、PHP、Python、Lisp、VB、Pascal、Assembly、Ruby、shell……），跟运维关系比较密切的主要是下面几种：

* PHP 是网页程序语言，专注于 Web 页面开发，wordpress、discuz 等诸多开源产品都是用 PHP 开发的
* Perl 语言擅长支持强大的正则表达式，以及运维工具的开发
* Python 是明星语言，既适合脚本程序开发，也擅长 Web 页面开发（如系统后台、资产管理平台）、爬虫程序开发；大量 Linux 运维工具由 Python 开发，甚至游戏开发也会用到

### Shell 的优势

虽然有诸多脚本编程语言，但对于 Linux 操作系统内部的应用而言，Shell 才是最好的工具：Linux 底层命令都支持 Shell 语句，还能结合三剑客 grep、sed、awk 玩出高级用法。

* 擅长系统管理脚本开发，如软件启停脚本、监控报警脚本、日志分析脚本

每种语言都有自己擅长的地方，扬长避短、达到高效运维的目的，才是最合适的。

```plain
#Linux默认shell
[root@chaogelinux ~]# echo $SHELL
/bin/bash
```

---

# 第二篇 · Bash 基础特性与环境变量

## 五、Bash 基础特性

bash 是什么？一张用终端代码拼出的"BASH"大字图很直观地表达了：bash 就是 Linux 上最主流的那个 Shell。

* bash 是一个命令处理器，运行在文本窗口中，并能执行用户直接输入的命令
* bash 还能从文件中读取 Linux 命令，称之为脚本
* bash 支持通配符、管道、命令替换、条件判断等逻辑控制语句

bash 有诸多方便的功能，有助于运维人员提升工作效率。

### 命令历史

**Shell 会保留其会话中用户提交执行的命令。**

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

#### history 命令

```plain
history #命令 以及参数
-c: 清空内存中命令历史；
-r：从文件中恢复历史命令
数字  ：显示最近n条命令  history  10
```

#### 调用历史命令

```plain
!n  #执行历史记录中的某n条命令
!!  #执行上一次的命令，或者向上箭头
!string   #执行名字以string开头的最近一次的命令
```

#### 调用上一条命令的最后一个参数

```plain
ESC .   #快捷键
!$
```

#### 控制历史命令的环境变量

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

### Bash 特性汇总

* 文件路径 Tab 键补全
* 命令补全
* 快捷键 Ctrl + a、e、u、k、l
* 通配符
* 命令历史
* 命令别名
* 命令行展开

### 变量的含义

学生时代学的数学方程式，比如 x=1、y=2，那时我们称 x、y 为未知数。

从计算机的角度看，x=1、y=2 就是定义了两个变量，名字分别是 x、y，并分别赋值 1 和 2。

**变量是暂时存储数据的地方，也是一种数据标记（好比房间号，标记了客人所在的位置）；数据存储在内存空间中，通过调用正确的变量名，就能取出对应的值。**

用"房间"打比方，变量的三个要素一一对应：

| 房间 | 变量 |
| --- | --- |
| 房间名字 | 变量名 |
| 房间类型 | 变量类型 |
| 客人 | 变量值 |

数学题里我们要解方程组才能知道 x、y 的值；在 Linux 里不用解，直接定义就行，比如：

```plain
name="超哥"
age=18
```

### Shell 变量

* 变量定义与赋值，注意变量名和值之间不得有空格

```plain
name="超哥"
变量名
变量类型，bash默认把所有变量都认为是字符串
bash变量是弱类型，无需事先声明类型，是将声明和赋值同时进行
```

* 变量替换/引用，即用变量名取出变量值

```plain
[root@chaogelinux ~]# name="超哥带你学bash"
[root@chaogelinux ~]# echo ${name}
超哥带你学bash
[root@chaogelinux ~]# echo $name    #可以省略花括号
超哥带你学bash
```

* 变量名规则
  * 命名要做到见名知意、按照规则来，且不得引用保留关键字（可用 help 检查保留字）
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

用 `pstree` 看一下进程树就明白了。下面红框标出的部分说明：每开一个终端、每执行一次 bash 或 csh，都会产生一个新的 shell 进程，它们层层嵌套：

```plain
sshd─sshd─bash─csh─bash─csh─bash
    ├─sshd─bash─pstree
    └─sshd─bash
```

本地变量只在定义它的那个 shell 里有效，切换到另一个 shell 后变量就找不到了：

```plain
[root@chaogelinux ~]# name=123
[root@chaogelinux ~]# echo $name
123
[root@chaogelinux ~]# csh
[root@chaogelinux ~]# echo $name
name: Undefined variable.
```

  * 环境变量，也称为全局变量，针对当前shell以及其任意子进程，环境变量也分`自定义`、`内置`两种环境变量
  * 局部变量，针对在`shell函数`或是`shell脚本`中定义
* 位置参数变量：用于 `shell脚本` 中传递参数
* 特殊变量：Shell 内置的有特殊功效的变量
  * `$?`
    * 0：成功
    * 1-255：错误码
* 自定义变量
  * 变量赋值：`varName=value`
  * 变量引用：`${varName}`、`$varName`
    * 双引号中，变量名会替换为变量值

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

    * 单引号，识别为普通字符串

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

1. 每次调用 bash 都会开启一个子 shell，因此不会保留当前 shell 的变量，可以通过 `pstree` 命令检查进程树
2. 调用 source 是在当前 shell 环境加载脚本，因此变量会保留下来

#### Shell 变量面试题

问，如下命令执行后，`echo $user1` 会输出什么内容？

```plain
[root@chaogelinux data]# cat test.sh
user1=`whoami`
[root@chaogelinux data]# sh test.sh
[root@chaogelinux data]# echo $user1
A.当前用户
B.超哥
C.空
```

> 📌 答案是 C：空。`sh test.sh` 在子 shell 中执行，里面给 user1 赋的值不会带回当前 shell。

## 六、环境变量设置

环境变量一般指用 export 内置命令导出的变量，用于定义 Shell 的运行环境、保证 Shell 命令正确执行。

Shell 通过环境变量确定登录的用户名、PATH 路径、文件系统等各种信息。

环境变量可以在命令行中临时创建，但用户退出 Shell 终端后变量就会丢失。如果要永久生效，需要修改 `环境变量配置文件`：

* 用户个人配置文件：`~/.bash_profile`、`~/.bashrc`（远程登录用户特有的文件）
* 全局配置文件：`/etc/profile`、`/etc/bashrc`；系统建议把自定义配置放在 `/etc/profile.d/` 下，而不是直接修改主文件——修改全局配置文件会影响所有登录系统的用户

**检查系统环境变量的命令**

* set：输出所有变量，包括全局变量、局部变量
* env：只显示全局变量
* declare：输出所有变量，如同 set
* export：显示和设置环境变量值

**撤销环境变量**

* unset 变量名：删除变量或函数

**设置只读变量**

* readonly：只有 Shell 结束，只读变量才会失效

```plain
直接readonly 显示当前系统只读变量
[root@chaogelinux ~]# readonly name="超哥"
[root@chaogelinux ~]# name="chaochao"
-bash: name: 只读变量
```

**系统保留环境变量关键字**

bash 内嵌了诸多环境变量，用于定义 bash 的工作环境。

```plain
[root@chaogelinux ~]# export |awk -F '[ :=]' '{print $3}'
```

### Bash 多命令执行

```plain
[root@chaogelinux home]# ls /data/;cd /tmp/;cd /home;cd /data
```

### 环境变量初始化与加载顺序

SSH 登录 Linux 后，系统会启动一个 bash shell，bash 会依次读取若干个环境文件，检查环境变量设置。整体加载顺序如下：

```plain
ssh 登录，启动 bash
        │
        ▼
  /etc/profile                 全局环境变量文件
        │                      用户第一次登录时执行
        ├─► /etc/profile.d/*.sh
        │
        ▼
  $HOME/.bash_profile          用户环境变量文件
        │
        ▼
  $HOME/.bashrc
        │
        ▼
  /etc/bashrc
```

各文件的作用：

1. `/etc/profile`：全局环境变量文件，为系统的每个用户设置环境信息。用户第一次登录时该文件被执行，并从 `/etc/profile.d` 目录的配置文件中搜集 shell 的设置。
2. `/etc/profile.d`：该目录下有系统诸多脚本，也可以放入自定义的、需要登录时加载的脚本，便于用户登录后立即运行。
3. `$HOME/.bash_profile`：用户个人环境变量文件。
4. `$HOME/.bashrc`：用户个人的交互式 shell 配置文件。
5. `/etc/bashrc`：全局的交互式 shell 配置文件。

---

# 第三篇 · Shell 变量、子串与扩展

## 七、Shell 变量

### 本地变量

定义 Shell 变量时，变量名不需要加美元符 `$`。

本地变量只在用户当前 shell 的生存期内有效。比如：

```plain
[root@chaogelinux ~]# story_one="大师兄，师傅被妖怪抓走了"
[root@chaogelinux ~]# echo ${story_one}
大师兄，师傅被妖怪抓走了
[root@chaogelinux ~]# bash
[root@chaogelinux ~]# echo ${story_one}
```

在当前 shell 中变量可以正常取出；执行 `bash` 开启子 shell 后，最后那条 echo 没有任何输出——变量丢失了。

#### 变量定义

变量名由字母、数字、下划线组成，可以用字母或下划线开头，如：

* chaoge
* chao_ge123
* \_chao_ge123

变量名严格区分大小写：

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

#### 取出变量值

* 单引号：所见即所得，强引用
* 双引号：输出引号里的所有内容，能识别特殊符号，弱引用
* 无引号：连续的符号可以不加引号，但有空格就会产生歧义，最好使用双引号
* 反引号：引用命令执行结果，等同于 `$()` 用法

#### 特殊变量

Shell 的特殊变量主要用在脚本、函数传递参数的场景，常见的位置参数变量如下。

```bash
$0        获取shell脚本文件名，以及脚本路径
$n        获取shell脚本的第n个参数,n在1~9之间，如$1 ,$2, $9 ，大于9则需要写，${10}，参数空格隔开
$#        获取执行的shell脚本后面的参数总个数
$*         获取shell脚本所有参数，不加引号等同于$@作用，加上引号"$*"作用是 接收所有参数为单个字符串，"$1 $2.."
$@        不加引号，效果同上，加引号，是接收所有参数为独立字符串，如"$1" "$2"  "$3" ...，空格保留
```

特殊变量实践，运行脚本并观察各变量的结果：

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

  

### 面试题分享：`$*` 和 `$@` 的区别

```bash
$* 和 $@ 都表示传递给函数或脚本的所有参数

当 $* 和 $@ 不被双引号" "包围时，它们之间没有任何区别，都是将接收到的每个参数看做一份数据，彼此之间以空格来分隔。

但是当它们被双引号" "包含时，就会有区别了：
"$*"会将所有的参数从整体上看做一份数据，而不是把每个参数都看做一份数据。
"$@"仍然将每个参数都看作一份数据，彼此之间是独立的。

比如传递了 5 个参数，那么对于"$*"来说，这 5 个参数会合并到一起形成一份数据，它们之间是无法分割的；而对于"$@"来说，这 5 个参数是相互独立的，它们是 5 份数据。

如果使用 echo 直接输出"$*"和"$@"做对比，是看不出区别的；但如果使用 for 循环来逐个输出数据，立即就能看出区别来。
```

用 for 循环实践一下，区别立刻就能看出来：

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

#### 脚本控制返回值

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

#### 上一次后台进程的 PID

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

#### 当前 Shell 脚本的进程号

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

#### 上一次执行命令的最后一个参数

`$_` 记录在此之前执行的命令的最后一个参数：

```bash
[root@chaogelinux shell_program]# ls $_
special_var.sh

[root@chaogelinux shell_program]# cat $_
```

### Bash Shell 内置变量命令

bash 本身提供了一些内置命令，常用的有：

```bash
echo
eval
exec
export
read
shift
```

#### echo 命令

```bash
-n 不换行输出内容
-e 解析转义字符

\n    换行
\r    回车
\t    tab
\b  退格
\v    纵向制表符
```

案例，对比 `-n`、`-e` 和 printf 的效果：

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

#### eval

eval 执行多个命令。

```bash
[root@chaogelinux shell_program]# eval ls ;cd /tmp

```

#### exec

```bash
不创建子进程，执行该命令，exec执行后自动exit

[root@chaogelinux learnshell]# exec date
2020年 05月 26日 星期二 17:28:03 CST
Connection to pyyuc closed.
```

## 八、Shell 子串

子串就是一个完整字符串的一部分，可以通过 Shell 特有的语法进行截取。Shell 子串的常用语法如下：

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

下面通过案例逐一掌握。

### 子串基本用法

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

### 字符串长度的计算

计算字符串长度有好几种写法：

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


字符串长度的计算方法有很多种，谁最快？用 `time` 跑一万次循环对比一下：

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

> 📌 Shell 编程尽量使用内置操作和内置函数，少开管道、少调外部命令，性能差距可能有数倍。

### 截取字符串

基本语法：

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

#### 删除匹配的内容

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

#### 替换字符串

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

### 删除文件名练习

先批量创建 10 个图片文件，模拟需要处理的文件名：

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

目标：去掉所有文件名中的 `_finished` 字符串。

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

  

## 九、特殊 Shell 扩展变量处理

语法中的 parameter 指变量名，word 是给定的字符串。四种写法的区别如下：

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

### 扩展变量实践

#### 演示 1：`${parameter:-word}`

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

#### 演示 2：`${parameter:=word}`

这种写法用于保证变量始终有值：

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

#### 演示 3：`${parameter:?word}`

当变量不存在时，输出指定的提示信息：

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

#### 演示 4：`${parameter:+word}`

如果变量为空，什么都不做；变量有值时则返回 word：

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

## 十、扩展变量的应用场景

在脚本开发中，例如数据备份、数据删除的脚本，经常需要保证关键变量有默认值。

下面的脚本用于删除 7 天前的过期数据：

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