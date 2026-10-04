# Linux Shell 基础

> 本章讲清楚四件事：Shell 是什么、Shell 脚本怎么写、bash 有哪些好用的基础特性，以及父子 Shell、内建命令和环境变量的来龙去脉。命令行运维的半壁江山都在这里，建议边读边在机器上敲。

## 本章目录

- 一、走进 Shell
  - 什么是 Shell
  - Shell 和运维
  - 什么是 Shell 脚本（Shebang / 注释规范 / 执行方式）
  - 脚本语言
  - bash 基础特性（命令历史 / 变量）
  - 环境变量设置
- 二、Shell 实践
  - 父子 Shell / 子 Shell
  - 进程列表
  - 后台执行与子 Shell
  - 协程与子 Shell
- 三、内建命令
  - 外部命令 / 内置命令
- 四、Linux 环境变量
  - 全局变量与局部变量
  - PATH 变量
  - 登录 Shell / 交互式 Shell / 非交互式 Shell
  - 永久性环境变量

---

## 一、走进 Shell

Linux 早期没有图形界面，管理员只能坐在控制台前输入 Shell 命令、查看文本输出。

多数发行版（如 CentOS）可以用 `ctrl+F1~F7` 组合键在多个虚拟控制台之间切换；如今更常见的做法，是用 Xshell 这类终端工具远程连接到机器进行管理。

以 CentOS 为例，默认的 Shell 是 `GNU bash shell`，支持 man 手册、Tab 补全、Shell 指令等特性。

`GNU bash shell` 在用户登录时作为一个普通程序启动，用哪个 Shell 是由 `/etc/passwd` 中的条目指定的：

```plain
[root@chaogelinux ~]# tail -1 /etc/passwd
susu:x:2009:2010::/home/susu:/bin/bash
```

bash 在用户登录时自动启动。如果是从虚拟控制台登录，会直接出现命令行界面（CLI，Command-Line Interface）提示符，此时就可以输入 Shell 命令；如果是从图形化桌面登录，则需要启动 GNOME 终端这样的终端仿真器来访问 Shell CLI。

### 什么是 Shell

shell 这个单词本意为"贝壳"，在 IT 语境里特指命令解释器。

Shell 的作用是：

* 解释执行用户输入的命令或程序；
* 用户输入一条，Shell 就解释一条；
* 这种键盘输入命令、Linux 给出响应的方式，称为**交互式**。

从外到内，Shell 处于"外围应用程序"和"操作系统核心"之间，像一名翻译官：

```plain
┌───────────────────────────────────────────┐
│ 外围应用程序                               │
│  ┌─────────────────────────────────────┐  │
│  │ shell 解释器（翻译官、命令解释器）    │  │
│  │  ┌───────────────────────────────┐  │  │
│  │  │ 操作系统核心                   │  │  │
│  │  │  ┌─────────────────────────┐  │  │  │
│  │  │  │       机器硬件           │  │  │  │
│  │  │  └─────────────────────────┘  │  │  │
│  │  └───────────────────────────────┘  │  │
│  └─────────────────────────────────────┘  │
└───────────────────────────────────────────┘
```

Shell 是包裹在系统内核外的一层"壳"，处于操作系统最外层，直接与用户对话：把用户的输入解释给操作系统，再把处理结果输出到屏幕。例如：

```plain
[root@chaogelinux data]# echo "超哥带你学shell"
超哥带你学shell
```

从登录 Linux、输入账号密码，到进入交互式界面，期间所有操作都要交给 Shell 解释并执行。一条命令从敲下到看到结果，完整的流转过程如下：

```plain
                         超哥（用户）
                   敲键盘 ls       查看输出
                         ↘          ↗
      ┌────────────────────────────────────────────┐
      │ shell 壳                                   │
      │  ┌──────────────────┐  ┌────────────────┐  │
      │  │ bash 解释器       │  │ terminal 终端  │  │
      │  │ 解析、翻译用户    │  │ 接受输入、     │  │
      │  │ 输入              │  │ 绘制输出       │  │
      │  └────────┬──────────┘  └───────▲────────┘  │
      └───────────┼─────────────────────┼───────────┘
             系统调用             stdout/stderr
                  ▼                    │
      ┌───────────────────────┐        │
      │ 操作系统内核 kernel    │────────┘
      └───────────┬───────────┘
                  ▼
      ┌───────────────────────┐
      │      计算机硬件        │
      └───────────────────────┘
```

获取计算机数据，不可能每次都编写程序、编译后再运行。比如找一个文件，难道要先写一段 C 代码、调用系统函数、用 gcc 编译后才能执行？

于是就有了 Shell 解释器：只要敲下 `ls -lh` 这样一串字符，Shell 就会把它翻译解释成 `ls -l -h` 并执行，再通过终端输出结果，图形界面和命令行界面都是这个道理。

即使在图形界面下"点点点"，区别也仅仅在于结果呈现的形式：

* 命令行操作：Shell 解释执行后，把结果输出到黑色命令行界面；
* 图形化操作：Shell 接受点击动作，输出图案数据。

> 💡 可以把 Shell 理解成 Google 翻译：你输入中文"请将我这句话翻译成英文"，它输出英文给老外看；Shell 做的也是"翻译"——把人能看懂的命令字符串，翻译成内核能执行的系统调用。

### Shell 和运维

Shell 非常适合处理纯文本数据。Linux 的哲学是"一切皆文件"——日志、配置、网页文件大多是纯文本，因此 Shell 配合 Linux 三剑客（grep、sed、awk）就能高效完成文本处理。

Shell 也处在运维技术体系的中心，周边的各类服务和工具都离不开它：

| 方向 | 代表技术 |
| --- | --- |
| 基础操作 | 基础命令、定时任务、存储服务 |
| Web 方向 | Nginx/web、Django 服务 |
| 开发语言 | python 服务 |
| 监控运维 | Zabbix 监控 |
| 系统与云 | Linux 系统服务、虚拟化服务、云计算服务 |

### 什么是 Shell 脚本

把命令或程序语句写进文件，执行文件、读取其中的代码，这个程序文件就称为 **Shell 脚本**。

在脚本里定义多条 Linux 命令以及循环控制语句，让这些命令一次性执行完毕——这种执行脚本文件的方式，称为**非交互式**。

* Windows 中有 `*.bat` 批处理脚本；
* Linux 中常用 `*.sh` 脚本文件。

下面看一个真实的脚本及其执行效果：

```plain
[root@chaogelinux data]# cat test1.sh
ls .
echo "脚本执行完毕～"
[root@chaogelinux data]# sh test1.sh
books.txt       luffycity.com   pyyu.txt        test_umask.txt
chaoge2.txt     luffy.txt       test            tttttt.txt
chaoge.txt      mytasks.at      test1.sh        yu.txt
lovers.txt      pwd.txt         test.txt        yuyuyuyu.txt
脚本执行完毕～
```

**Shell 脚本的构成规则：**

在 Linux 系统中，Shell 脚本（bash shell 程序）通常用 vim 编辑，由 Linux 命令、bash shell 指令、逻辑控制语句和注释信息组成。

#### Shebang

计算机程序中，`shebang` 指的是出现在文本文件第一行的前两个字符 `#!`。

在 Unix 系统中，程序会分析 `shebang` 后面的内容，把它作为解释器指令。例如：

* 以 `#!/bin/sh` 开头的文件，执行时会调用 `/bin/sh`，也就是 bash 解释器；
* 以 `#!/usr/bin/python` 开头的文件，表示指定 python 解释器去执行；
* 以 `#!/usr/bin/env 解释器名称` 开头，是一种在不同平台上都能正确找到解释器的办法。

注意事项：

* 如果脚本未指定 `shebang`，执行时默认用当前 Shell 去解释脚本，即 `$SHELL`；
* 如果 `shebang` 指定了可执行的解释器，如 `/bin/bash`、`/usr/bin/python`，脚本执行时文件名会作为参数传递给解释器；
* **如果 #! 指定的解释程序没有可执行权限，则会报错"bad interpreter: Permission denied"。**
* **如果 #! 指定的解释程序不是一个可执行文件，那么指定的解释程序会被忽略，转而交给当前的 SHELL 去执行这个脚本。**
* **如果 #! 指定的解释程序不存在，那么会报错"bad interpreter: No such file or directory"。**
* **#! 之后的解释程序需要写绝对路径（如：`#!/bin/bash`），它不会自动到 $PATH 中寻找解释器。**
* **如果你用 `bash test.sh` 这样的命令执行脚本，那么 #! 这一行会被忽略，解释器用的当然是命令行中显式指定的 bash。**

脚本案例：

```plain
[root@chaogelinux data]# cat test.sh
#!/bin/bash
echo "超哥强呀，奥力给"
#!/bin/bash 这里就是注释的作用了
```

系统自带的 bash 开机启动脚本，第一行同样是 shebang：

```plain
[root@chaogelinux data]# head -1 /etc/rc.d/init.d/network
#! /bin/bash
```

#### 脚本注释，脚本开发规范

* 在 Shell 脚本中，`#` 后面的内容是注释，写给开发者或使用者看，系统会忽略这一行；
* 注释可以单独占一行，也可以跟在命令后面；
* 养成写注释的习惯，方便以后回顾代码的含义；注释尽量使用英文而非中文。

```plain
#! /bin/bash
# Date : 2019-11-28 14:59:18
# Author：created by chaoge
# Blog：www.cnblogs.com/pyyu
```

再看系统网络脚本 `/etc/init.d/network` 的片段，它就是一个"用注释解释代码作用"的好例子：

```plain
#! /bin/bash
#
# network       Bring up/down networking
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

文件开头的注释分别说明了：shebang 指定解释器、脚本的用途（启停网络）、chkconfig 启动级别，以及每段代码的作用。

#### 执行 Shell 脚本的方式

* `bash script.sh` 或 `sh scripte.sh`：文件本身没有 x 权限，或者脚本没有指定 `shebang` 时使用，是重点推荐的方式；
* 使用`绝对路径/相对路径`执行脚本：需要文件含有 x 权限；
* `source script.sh` 或者 `. script.sh`：在当前 Shell 中执行，source 等于点 `.`；
* 少见的用法：`sh < script.sh`。

下面依次演示这几种方式，注意直接 `./test.sh` 时因为没有 x 权限而报错，加上执行权限后就正常了：

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

### 脚本语言

Shell 脚本语言属于一种**弱类型语言**：无需声明变量类型，直接定义使用。

与之相对，**强类型语言必须先定义变量类型（确定是数字、字符串等），之后再赋予同类型的值**。

CentOS 7 系统中支持的 Shell 种类如下：

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

#### 其他脚本语言

编程语言的种类非常多，C、C++、Java、Python、PHP、JavaScript、shell……各有各的舞台。运维工作中常打交道的主要是下面几种：

* **PHP**：网页程序语言，专注于 Web 页面开发，WordPress、Discuz 等开源产品都是用 PHP 开发的；
* **Perl**：擅长强大的正则表达式，以及运维工具的开发；
* **Python**：明星语言，既适合脚本程序开发，也擅长 Web 页面开发（如系统后台、资产管理平台）、爬虫开发；大量 Linux 运维工具也是 Python 写的，甚至游戏开发也会用到它。

#### Shell 的优势

虽然有这么多脚本语言，但对于 Linux 操作系统内部的应用而言，Shell 才是最好用的工具：Linux 底层命令都支持 Shell 语句，还能结合三剑客（grep、sed、awk）玩出各种高级用法。

Shell 尤其擅长系统管理类脚本的开发，比如软件启停脚本、监控报警脚本、日志分析脚本。

每种语言都有自己擅长的地方，扬长避短、达到高效运维的目的，才是最合适的选择。

```plain
#Linux默认shell
[root@chaogelinux ~]# echo $SHELL
/bin/bash
```

### bash 基础特性

bash 是一个命令处理器，关于它，先记住三句话：

* bash 运行在文本窗口中，能执行用户直接输入的命令；
* bash 还能从文件中读取 Linux 命令，这就是脚本；
* bash 支持通配符、管道、命令替换、条件判断等逻辑控制语句。

bash 提供了诸多方便的功能，可以显著提升运维效率。

#### 命令历史

**Shell 会保留本次会话中用户提交执行过的命令。**

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

history 命令的常用参数：

```plain
history #命令 以及参数
-c: 清空内存中命令历史；
-r：从文件中恢复历史命令
数字  ：显示最近n条命令  history  10
```

快速调用历史命令：

```plain
!n  #执行历史记录中的某n条命令
!!  #执行上一次的命令，或者向上箭头
!string   #执行名字以string开头的最近一次的命令
```

调用上一次命令的最后一个参数：

```plain
ESC .   #快捷键
!$
```

> 💡 `ESC .` 和 `!$` 是日常使用频率极高的小技巧。比如刚 `cat /etc/sysconfig/network-scripts/ifcfg-eth0`，下一条想编辑它，直接 `vim` 后按 `ESC .` 即可粘出长路径。

控制历史命令记录方式的环境变量：

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

#### bash 特性汇总

* 文件路径 Tab 键补全
* 命令补全
* 快捷键 Ctrl + a、e、u、k、l
* 通配符
* 命令历史
* 命令别名
* 命令行展开

#### 变量含义

学生时代的数学方程式，如 x=1、y=2，那时把 x、y 叫作未知数。

站在计算机的角度，x=1、y=2 就是定义了两个变量，名字分别叫 x 和 y，并给它们赋了值 1 和 2。

**变量是暂存数据的地方，相当于一种数据标记（就像房间号标记了客人所在的位置）：数据存在内存空间里，通过正确的变量名就能取出对应的值。**

用"房间"来理解变量，对应关系如下：

| 房间（比喻） | 变量（概念） |
| --- | --- |
| 房间名字 | 变量名 |
| 房间类型 | 变量类型 |
| 客人 | 变量值 |

就像数学题里给 x、y 求值一样，在 Linux 中直接写出赋值语句就完成了变量定义：`name="超哥"`、`age=18`。

#### Shell 变量

变量定义与赋值时要注意，变量名与值之间**不得有空格**：

```plain
name="超哥"
变量名
变量类型，bash默认把所有变量都认为是字符串
bash变量是弱类型，无需事先声明类型，是将声明和赋值同时进行
```

变量的替换/引用：

```plain
[root@chaogelinux ~]# name="超哥带你学bash"
[root@chaogelinux ~]# echo ${name}
超哥带你学bash
[root@chaogelinux ~]# echo $name    #可以省略花括号
超哥带你学bash
```

变量名规则：

  * 命名要做到见名知意，并遵守规则，不得引用保留关键字（可用 `help` 检查保留字）；
  * 只能包含数字、字母、下划线；
  * 不能以数字开头；
  * 不能用标点符号；
  * 变量名严格区分大小写。

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

变量按作用范围可以分为以下几类：

| 变量类别 | 作用范围 / 说明 |
| --- | --- |
| 本地变量 | 只对当前 shell 进程有效 |
| 环境变量（全局变量） | 对当前 shell 及其任意子进程有效；分自定义、内置两种 |
| 局部变量 | 在 shell 函数或 shell 脚本中定义 |
| 位置参数变量 | 用于向 shell 脚本传递参数 |
| 特殊变量 | shell 内置的具有特殊功效的变量，如 `$?`：0 表示成功，1-255 表示错误码 |
| 自定义变量 | 手动赋值 `varName=value`，用 `${varName}` 或 `$varName` 引用 |

本地变量只在当前 shell 进程中有效，可以用 `pstree` 查看 shell 进程的嵌套关系：

```plain
pstree检查进程树
```

在一个开了多个终端窗口的桌面会话里执行 `pstree`，能清楚看到 `sshd—bash—csh—bash—csh—bash` 这样一串 Shell 嵌套链条，每开一个 SSH 终端，就多出一条 `sshd` 分支。

一旦切换到另一种 Shell（比如 csh），原来定义的本地变量就找不到了：

```plain
[root@chaogelinux ~]# name=123
[root@chaogelinux ~]# echo $name
123
[root@chaogelinux ~]# csh
[root@chaogelinux ~]# echo $name
name: Undefined variable.
```

引用变量时，单引号和双引号的行为不同。下面的例子中，双引号里的变量名会被替换成变量值，单引号里的内容则原样保留：

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

* 单引号：识别为普通字符串。

> 📌 记忆要点：**双引号会解析变量，单引号里是什么就输出什么。**

#### 不同的执行方式，不同的 Shell 环境

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

1. 每次调用 bash 都会开启一个子 Shell，因此不会保留当前 Shell 的变量，可以通过 `pstree` 检查进程树；
2. 调用 source 是在当前 Shell 环境加载脚本，因此变量会保留下来。

##### Shell 变量面试题

问：如下操作，最终输出什么内容？

```plain
[root@chaogelinux data]# cat test.sh
user1=`whoami`
[root@chaogelinux data]# sh test.sh
[root@chaogelinux data]# echo $user1
A.当前用户
B.超哥
C.空
```

### 环境变量设置

环境变量一般指的是用 export 内置命令导出的变量，用于定义 Shell 的运行环境、保证 Shell 命令正确执行。

Shell 通过环境变量确定登录用户名、PATH 路径、文件系统等各种信息。

环境变量可以在命令行中临时创建，但用户退出 Shell 终端后变量即丢失；如果要永久生效，就需要修改**环境变量配置文件**：

* 用户个人配置文件：`~/.bash_profile`、`~/.bashrc`（远程登录用户特有的文件）；
* 全局配置文件：`/etc/profile`、`/etc/bashrc`。系统建议最好把自定义配置放在 `/etc/profile.d/` 下，而不是直接修改主文件；修改全局配置文件会影响所有登录系统的用户。

#### 检查环境变量的命令

* `set`：输出所有变量，包括全局变量、局部变量；
* `env`：只显示全局变量；
* `declare`：输出所有变量，如同 set；
* `export`：显示和设置环境变量值。

#### 撤销环境变量

* `unset 变量名`：删除变量或函数。

#### 设置只读变量

* `readonly`：只有 Shell 结束时，只读变量才失效。

```plain
直接readonly 显示当前系统只读变量
[root@chaogelinux ~]# readonly name="超哥"
[root@chaogelinux ~]# name="chaochao"
-bash: name: 只读变量
```

#### 系统保留环境变量关键字

bash 内嵌了诸多环境变量，用于定义 bash 的工作环境：

```plain
[root@chaogelinux ~]# export |awk -F '[ :=]' '{print $3}'
```

#### bash 多命令执行

```plain
[root@chaogelinux home]# ls /data/;cd /tmp/;cd /home;cd /data
```

#### 环境变量初始化与加载顺序

SSH 登录 Linux 后，系统会启动一个 bash shell，它会依次读取若干个环境文件，检查其中的环境变量设置，顺序如下：

1. **`/etc/profile`**：全局环境变量文件。为系统的每个用户设置环境信息，用户第一次登录时该文件被执行，并从 `/etc/profile.d` 目录的配置文件中搜集 Shell 设置；
2. **读取 `/etc/profile.d` 目录下的脚本**：里面有系统自带的诸多脚本，也可以放入自定义的、需要登录时加载的脚本，便于用户登录后立即运行；
3. **运行 `$HOME/.bash_profile`**：用户环境变量文件；
4. **运行 `$HOME/.bashrc`**；
5. **运行 `/etc/bashrc`**。

---

## 二、Shell 实践

同样一个脚本，用不同方式执行，背后可能是当前 Shell，也可能是新开启的子 Shell：

```plain
① source script
   Shell:  [source script] → [command 1] → [command 2] →

② /bin/bash script
   Shell:     [/bin/bash script] ──────────────────────────┐
   Subshell:                       [command 1] → [command 2] ┘

③ ./script
   Shell:     [./script] ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
   Subshell:                [command 1] → [command 2] ────┘
```

* `source` 在**当前 Shell** 内依次执行命令；
* `/bin/bash script` 由当前 Shell 启动一个**子 Shell**，命令在子 Shell 中执行；
* `./script` 同样是在子 Shell 中执行（需要文件具备 x 权限）。

### 父子 Shell

**父 Shell**：登录某个虚拟控制器终端（连接某一台 Linux 虚拟机）时，默认启动的那个交互式 Shell，它启动后就等待用户输入命令。

ps 命令的参数带不带横杠，作用是不一样的：

```plain
-f 　显示UID,PPID,C与STIME栏位。
f 　用ASCII字符显示树状结构，表达进程间的相互关系。
-e 　此参数的效果和指定"A"参数相同。
e 　列出进程时，显示每个进程所使用的环境变量。
```

案例：登录后用一条命令查看进程的父子关系。

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

### 子 Shell

在 CLI 提示符下输入 `/bin/bash`（或其他 bash 指令），会创建一个新的 Shell 程序，这就是**子 Shell（child shell）**。

子 Shell 同样有 CLI 提示符，可以继续输入命令。下面通过两次 `ps -f` 观察父子 Shell 的诞生过程：

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

输入 bash 指令后，一个子 Shell 就产生了：

* 第一个 `ps -f` 是在父 Shell 里执行的；
* 第二个 `ps -f` 是在子 Shell 里执行的。

整个过程可以表示为：

```plain
  父 shell                     子 shell
┌──────────┐   创建子 shell   ┌──────────┐
│ 发出命令： │ ───────────────▶ │ 发出命令： │
│   bash   │                  │   ps -f  │
└──────────┘                  └──────────┘
```

子 Shell 生成时，父进程的部分环境变量会被复制到子 Shell 里，这一点后面还会详细说明。

#### 多个子 Shell

连续执行多次 bash，就会一层套一层地开启多个子 Shell：

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

层级关系一目了然：父 shell 发出 `bash` 创建子 shell，子 shell 再发出 `bash` 创建孙 shell，依次向下就是曾孙 shell；最深处执行的 `ps --forest` 把整条链条都画了出来。

退出子 Shell：

```plain
exit 可以退出子shell，也可以退出当前的虚拟控制台终端。
只需要在父shell里输入exit就可以退出了。
```

### 进程列表

如果想一次性执行一系列命令，可以用分号把命令串起来：

```plain
[root@chaogelinux ~]# pwd;ls;cd /opt;pwd;ls
这样的写法，命令的确会依次执行，但是这并不是【进程列表】
```

必须加上小括号，才是真正的进程列表：

```plain
[root@chaogelinux opt]# (cd ~;pwd;ls ;cd /tmp;pwd;ls)
命令列表，必须写入括号里，进程列表是生成子shell去执行对应的命令。
```

进程列表的语法就是：

```plain
(command1;command2)
```

#### 检测子 Shell

通过一个环境变量可以检查当前是否处于子 Shell 中：

```plain
[root@chaogelinux opt]# echo $BASH_SUBSHELL
0
结尾为0则没有子shell，非0就是有子shell
```

非子 Shell 执行命令：

```plain
[root@chaogelinux opt]# cd ~;pwd;ls ;cd /tmp;pwd;ls;echo $BASH_SUBSHELL
能够看到结果为0，表示是父shell直接执行
```

子 Shell 的执行形式：

```plain
[root@chaogelinux tmp]# (cd ~;pwd;ls ;cd /tmp;pwd;ls;echo $BASH_SUBSHELL)
看到结果不为0了，表示是在子shell里运行了
```

#### 子 Shell 嵌套

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

Shell 脚本开发中，经常利用子 Shell 进行多进程处理。

### 后台执行与子 Shell

日常执行 Shell 命令时，很多地方都会用到子 Shell，比如进程列表、协程、管道等。

一个高效的用法是把子 Shell 和后台执行结合起来。

先认识 `sleep` 命令：

```plain
sleep 3
sleep将你会话暂停3秒，然后返回shell
```

不希望 sleep 卡住当前会话，可以把它放到后台：

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

#### jobs 命令

```plain
[root@chaogelinux tmp]# jobs
[1]+  运行中               sleep 300 &
[root@chaogelinux tmp]#
```

jobs 命令可以显示后台作业信息，加上 `-l` 还能看到 PID：

```plain
[root@chaogelinux tmp]# jobs -l
[1]+ 27520 运行中               sleep 300 &
显示pid信息
一旦后台jobs完成，就会显示出结束状态。
[1]+  完成                  sleep 300
```

#### 进程列表放入后台

先看一个前台执行的例子：

```plain
[root@chaogelinux tmp]# (sleep 2;echo $BASH_SUBSHELL;sleep 2)
1
这个案例，会有2秒的暂停，显示数字，表示只有一个子shell，然后又暂停了2秒，最终返回提示符
```

再看进程列表结合后台模式的效果：

```plain
[root@chaogelinux tmp]# (sleep 2;echo $BASH_SUBSHELL;sleep 2)&
[1] 29308
[root@chaogelinux tmp]# 1
[1]+  完成                  ( sleep 2; echo $BASH_SUBSHELL; sleep 2 )
```

这种用法的目的是：开辟子 Shell 处理繁琐工作，同时不让它阻塞终端的使用。

后面还会学到结合 tar 命令进行后台压缩的实用案例：

```plain
# 这里注意，tar压缩的时候，会有报警信息，原因是绝对路径的问题，可以忽略，是系统为了保护文件的操作
[root@chaogelinux tmp]# (tar -cf Tmp.tar /tmp;tar -Pcf Home.tar /home)&
[1] 29931
```

此时可以检查父子 Shell 的执行方式：

```plain
[root@chaogelinux tmp]# ps -ef --forest
root      1830     1  0 9月25 ?       00:00:00 /usr/sbin/sshd -D
root     24731  1830  0 09:36 ?        00:00:00  \_ sshd: root@pts/2
root     24734 24731  0 09:36 pts/2    00:00:00      \_ -bash
root     30337 24734  0 10:28 pts/2    00:00:00          \_ -bash
root     30341 30337 16 10:28 pts/2    00:00:02          |   \_ tar -cf Tmp.tar /tmp
root     30452 24734  1 10:28 pts/2    00:00:00          \_ ps -ef --forest
```

### 协程与子 Shell

协程（coproc）同样是在后台创建子 Shell，然后在子 Shell 中执行命令：

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

协程把命令放在后台执行，也可以通过 jobs 命令看到：

```plain
[root@chaogelinux tmp]# coproc sleep 10
[1] 31610
[root@chaogelinux tmp]# jobs
[1]+  运行中               coproc COPROC sleep 10 &
```

协程默认给任务起名叫 `COPROC`，也可以自己指定名字：

```plain
[root@chaogelinux tmp]# coproc Chao_ge_job { sleep 10; }
[1] 31840
[root@chaogelinux tmp]# jobs
[1]+  运行中               coproc Chao_ge_job { sleep 10; } &
```

通过这种写法就指定了协程的名字，注意扩展语法 `{ 任务 }` 中花括号里面的空格。

---

## 三、内建命令

2015 年在上海面试运维岗位时，面试官问过这样一个问题：你知道 Linux 的内置命令和外置命令吗？

回答要点是：

> 内置命令：系统启动时就加载进内存、常驻内存，执行效率更高，但占用资源；
>
> 外置命令：需要时从硬盘读取程序文件，再加载进内存执行。

### 外部命令

外部命令也称作文件系统命令，是存在于 bash shell 之外的程序，一般位于这些目录：

```plain
/bin
/usr/bin
/sbin/
/usr/sbin
```

例如 ps 就是一个外部命令：

```plain
[root@chaogelinux tmp]# which ps
/usr/bin/ps
[root@chaogelinux tmp]# type -a ps
ps 是 /usr/bin/ps
[root@chaogelinux tmp]# ls -l /usr/bin/ps
-rwxr-xr-x 1 root root 100112 10月 19 2019 /usr/bin/ps
```

外部命令执行时会创建一个子进程，仍然可以通过 ps 查看进程号：

```plain
[root@chaogelinux tmp]# ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
root       750 24734  0 10:45 pts/2    00:00:00 ps -f
root     24734 24731  0 09:36 pts/2    00:00:00 -bash
ps命令是父bash，创建新的进程750执行的。
```

过程上就是父进程发出外部命令，衍生出一个子进程去执行：

```plain
  父进程                      子进程
┌────────────┐  衍生子进程   ┌────────────┐
│ 发出外部命令：│ ───────────▶ │ 执行外部命令：│
│   ps -f    │               │   ps -f    │
└────────────┘               └────────────┘
```

无论是子进程还是子 Shell，都可以通过发送 signaling 信号与它通信。

### 内置命令

内置命令和外置命令的区别，就在于**是否会创建子进程去执行**。

内置命令与 Shell 编译为一体，是 Shell 的一部分，不需要外部程序文件。

可以通过 `type` 了解一条命令是否为内建：

```plain
[root@chaogelinux tmp]# type cd
cd 是 shell 内嵌
[root@chaogelinux tmp]# type exit
exit 是 shell 内嵌
```

因为内置命令不需要衍生子进程，也不用打开程序文件，所以执行速度更快、效率更高。

#### 查看内置命令

```plain
# 该命令列出所有的bash shell可以用的内置命令
[root@web01 ~ 11:33:33]$compgen -b
```

#### 查看外置命令

除了以上内置命令，日常使用的大部分命令都是外部命令，用 `type` 验证一下即可。

---

## 四、Linux 环境变量

变量的概念前面已经介绍过。Linux 环境变量可以提升 Shell 的使用体验，很多程序和脚本通过环境变量获取系统信息、存储临时数据和配置信息。

### 什么是环境变量

`environment variable`（环境变量）的作用是存储有关 Shell 会话和工作环境的信息。

它允许在内存中存放临时数据，便于程序或 Shell 轻松访问。

bash shell 里，环境变量分为两类：

* 全局变量；
* 局部变量。

### 全局环境变量

全局环境变量对 Shell 会话和所有子 Shell 都可见；局部环境变量则只对创建它们的 Shell 可见。

Linux 在 bash 会话启动时就已经设置好了全局环境变量：

* 系统环境变量：特点是全部使用大写字母；
* 用户配置的环境变量。

```plain
1.查看全局环境变量
env
printenv
```

显示某个环境变量的值：

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

### 局部环境变量

局部变量只能在定义它们的进程里可见。局部变量无法单独查看，可以用 set 命令查到所有环境变量，包括局部变量、全局变量以及用户自定义变量。

> env、printenv、set 之间的差异很小：
>
> set 显示全局变量、局部变量、用户自定义变量，并按字母顺序排序；
>
> env、printenv 与 set 的区别在于不会排序，也不会输出局部变量和自定义变量。

#### 局部用户定义变量

自定义变量尽量用小写字母，以便和系统变量区分开，防止误改系统变量导致故障，赋值时注意加上引号。

```plain
[root@web01 ~]# echo $my_name
[root@web01 ~]# my_name="超哥"
[root@web01 ~]#
[root@web01 ~]# echo $my_name
超哥
[root@web01 ~]# set |grep my_name
my_name=超哥
```

局部变量在父子 Shell 之间是不可见的：

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

想要解决这个问题，就可以通过设置全局变量来改变。

### 设置全局变量

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

通过 `export` 设置的全局变量，在子 Shell 里也可见。

#### 作用域优先级

父 Shell 的环境变量优先级高于子 Shell，也就是说：子 Shell 里修改了全局变量，不会影响到父 Shell。

通过下面的过程，可以清楚看出子 Shell 不会影响父 Shell 的变量：

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

### 删除变量

```plain
[root@web01 ~]# unset name
[root@web01 ~]# echo $name
```

同样要注意，在子 Shell 里删除变量，也不会影响父 Shell。

### 查找变量

小技巧：过滤出部分系统环境变量。

```plain
[root@web01 ~]# set |grep  '^[A-Z]' |wc -l
```

查找出部分自定义变量：

```plain
[root@web01 ~]# set |grep  '^[a-z]'
colors=/root/.dircolors
name=age
dequote ()
quote ()
quote_readline ()
```

### PATH 变量

PATH 变量的作用在其他章节已经讲解过：它定义了 Shell 查找可执行命令的目录列表，命令能否直接敲名字运行，靠的就是它。

### 登录 Shell

登录 Linux 时，bash shell 默认启动，Shell 会从以下 5 个文件中读取环境变量定义：

* /etc/profile
* $HOME/.bash_profile
* $HOME/.bashrc
* $HOME/.bash_login
* $HOME/.profile

`/etc/profile` 是系统默认的 bash 主启动文件，每个用户登录时都会执行它。

该文件利用 `for` 语句循环读取配置，遍历执行 `/etc/profile.d` 目录下的所有文件：

```plain
[root@web01 ~]# ls  /etc/profile.d/
```

### 交互式 shell

刚才说的登录 Shell，是系统启动、首次登录时的 Shell。

交互式 Shell 指的是**手动输入 bash 指令进入的子 Shell**，它提供命令行提示符，让用户输入命令进行交互。

> 如果 bash 是以交互式 Shell 启动的，不会访问 /etc/profile，只检查 HOME 目录下的 .bashrc 文件：
>
> [root@web01 ~]# cat ~/.bashrc
>
> 这个文件有两个作用：
>
> 1. 执行 /etc/bashrc 文件；
>
> 2. 为用户提供自定义的命令别名、自定义变量以及 shell 函数执行。

### 非交互式 shell

除了上面两种 Shell，还存在非交互式 Shell。

这种形式用来执行 Shell 脚本，它没有命令行提示符：

```plain
[root@web01 ~]# cat hello.sh
#!/bin/bash
echo 'hello 超哥，你讲的课真有意思'
[root@web01 ~]# bash hello.sh
hello 超哥，你讲的课真有意思
```

### 永久性环境变量

想要设置永久生效的环境变量（每次开机都有效），大多数运维习惯把它写入 `/etc/profile`。

但要注意：系统某天升级时这个文件也可能被更新，定制的环境变量就会随之消失。

因此更推荐的做法是：

> 在 /etc/profile.d/ 目录下创建 .sh 文件，在该脚本文件中定义环境变量。

> 原文：<https://www.yuque.com/chengkanghua/awf7cm/abeqrr>
