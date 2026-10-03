# Linux通配符

## 通配符

就是键盘上的一些特殊字符，可以实现特殊的功能，例如模糊搜索一些文件。

| 文件名 | 通配符 | 模糊匹配 |
| --- | --- | --- |
| luffy | \* | luffyalex |
| | | luffychao |
| | | luffycunzhang |
| | | |
| oldboy | ? | oldboy1 |
| | | oldboy2 |
| | | oldboyz |
| | | oldboyx |

利用通配符可以更轻松的处理字符信息

### 常见通配符

| 符号 | 作用 |
| --- | --- |
| \* | 匹配任意，0或多个字符，字符串 |
| ? | 匹配任意1个字符，有且只有一个字符 |
| 符号集合 | 匹配一堆字符或文本 |
| \[abcd] | 匹配abcd中任意一个字符，abcd也可以是不连续任意字符 |
| \[a-z] | 匹配a到z之间任意一个字符，要求连续字符，也可以连续数字，匹配\[1-9] |
| \[!abcd] | 不匹配括号中任意一个字符，也可以书写\[!a-d]，同于写法 |
| `[^abcd]` | 同上，！可以换成 ^ |

### 特殊通配符

| 符号 | 作用 |
| --- | --- |
| \[\[:upper:]] | 所有大写字母 |
| \[\[:lower:]] | 所有小写字母 |
| \[\[:alpha:]] | 所有字母 |
| \[\[:digit:]] | 所有数字 |
| \[\[:alnum:]] | 所有的字母和数字 |
| \[\[:space:]] | 所有的空白字符 |
| \[\[:punct:]] | 所有标点符号 |

案例

```plain
1.找出根目录下最大文件夹深度是3，且所有以l开头的文件，且以小写字母结尾，中间出现任意一个字符的文本文件，
[root@chaogelinux luffy_data]# find / -maxdepth 3 -type f -name "l?[[:lower:]]"
/usr/bin/ldd
/usr/bin/lua
/usr/sbin/lvm
/usr/sbin/lid
2.找出/tmp下以任意一位数字开头，且以非数字结尾的文件
[root@chaogelinux luffy_data]# find /tmp  -type f -name '[0-9][^0-9]'
3.显示/tmp下以非字母开头，后面跟着一个字母以及其他任意长度的字符的文件
find /tmp -type f -name "[^a-zA-Z][a-z]*"
4.mv/tmp/下，所有以非字母开头的文件，复制到/tmp/allNum/目录下
mv /tmp/[^a-zA-Z]* /tmp/allNum/
5.复制/tmp目录下所有的.txt文件结尾的文件，且以y、t开头的文件，放入/data目录
[root@chaogelinux tmp]# cp -r /tmp/[y,t]*.txt /data/
```

### \*号

准备数据如下

```plain
[root@pylinux tmp]# ls
chaoge.sh  chaoge.txt  oldboy.txt  oldgirl.txt  oldluffy.txt  yu.sh
```

1.匹配所有的txt文本

```plain
[root@pylinux tmp]# ls
chaoge.sh  chaoge.txt  oldboy.txt  oldgirl.txt  oldluffy.txt  yu.sh
```

2.匹配所有的sh脚本

```plain
[root@pylinux tmp]# ls *.sh
chaoge.sh  yu.sh
```

3.查看所有的old开头的文件

```plain
[root@pylinux tmp]# ls old*
oldboy.txt  oldgirl.txt  oldluffy.txt
```

### ？号

1.匹配一个任意字符

```plain
[root@pylinux tmp]# ls *.s?
chaoge.sh  yu.sh
```

2.匹配两个，三个任意字符

```plain
[root@pylinux tmp]# ls old???.txt
oldboy.txt
[root@pylinux tmp]# ls old????.txt
oldgirl.txt
```

### \[abc]

1.匹配\[abc]中的一个字符

```plain
[root@pylinux tmp]# ls
a.txt  b.txt  chaoge.sh  chaoge.txt  l.txt  oldboy.txt  oldgirl.txt  oldluffy.txt  yu.sh
[root@pylinux tmp]# ls [abc].txt
a.txt  b.txt
```

2.匹配如下类型文件

olda\_.txt oldb\_.txt oldc\*.txt

```plain
[root@pylinux tmp]# ls old[abcd]*.txt
oldboy.txt
```

### \[a-z]作用

\[]中括号里面的a-z，表示从a到z之间的任意一个字符，a-z要连续，也可以用连续的数字，如\[1-9]

<!-- OCR_START -->
[root@pylinux tmp]# ls
a.txtb.txtchaoge.sh
chaoge.txt chao.txt l.txt oldboy.txt oldgirl.txt oldluffy.txtyu.shyu.txt
[root@pylinux tmp]#
[root@pylinuxtmp]#ls[a-z].txt匹配任意1个字符
a.txtb.txtl.txt
[root@pylinuxtmp]#ls[a-z]?.txt匹配任意2个字符
yu.txt
[root@pylinux tmp]# ls [a-z]??.txt
Ls：无法访问[a-z]?？.txt：没有那个文件或目录
匹配任意3个字符，没有这个文件
匹配任意4个字符
chao.txt
<!-- OCR_END -->

### \[!abcd]

```plain
[^abcd]  
 [^a-d]
效果同上
```

除了abcd四个字符以外的任意一个字符

<!-- OCR_START -->
- [root@pylinux tmp]# ls *.txt
- ab.txtb.txt
- chao.txt
- d.txt
- l.txt
- oldgirl.txt
- yu.txt
- a.txt
- chaoge.txt
- c.txt
- e.txt
- oldboy.txt
- oldluffy.txt
- [root@pylinux tmp]#
- 找出除了以abcd字符开头的txt文件
- [root@pylinux tmp]# ls [!abcd]*.txt
- e.txt l.txt oldboy.txt oldgirl.txt
- oldluffy.txt  yu.txt
<!-- OCR_END -->

<!-- OCR_START -->
- [root@pylinux tmp]# ls *.txt
- 1.txt 35.txt
- a.txt
- chaoge.txt
- c.txt
- e.txt
- oldboy.txt
- oldluffy.txt
- 2.txt ab.txt
- b.txt
- chao.txt
- d.txt
- l.txt
- oldgirl.txt
- yu.txt
- [root@pylinux tmp]#
- [root@pylinux tmp]# ls [!a-d].txt
- 找出除了 a.txt b.txtc.txt d.txt 以外的任意一个字符.txt
- 1.txt  2.txt  e.txt
- 找出除了1到9之间，单个字符的.txt
- a.txtb.txtc.txt d.txte.txt
<!-- OCR_END -->

### 结合find命令使用

```plain
[root@pylinux tmp]# find /tmp  -type f  -name "[a-z].txt"        #找出a到z之间单个字符的文件
/tmp/b.txt
/tmp/e.txt
/tmp/a.txt
/tmp/l.txt
/tmp/d.txt
/tmp/c.txt
[root@pylinux tmp]# find /tmp  -type f  -name "[!a-d].txt"        #找出除了a到d之间单个字符的文件
/tmp/e.txt
/tmp/2.txt
/tmp/1.txt
/tmp/l.txt
[root@pylinux tmp]# find /tmp  -type f  -name "?.txt"            #找出所有单个字符的文件
/tmp/b.txt
/tmp/e.txt
/tmp/2.txt
/tmp/a.txt
/tmp/1.txt
/tmp/l.txt
/tmp/d.txt
/tmp/c.txt
[root@pylinux tmp]# find /tmp  -type f  -name "*.txt"            #找出所有的txt文本
```

## Linux特殊符号

### 路径相关

| 符号 | 作用 |
| --- | --- |
| ~ | 当前登录用户的家目录 |
| - | 上一次工作路径 |
| . | 当前工作路径，或隐藏文件 .chaoge.txt |
| .. | 上一级目录 |

波浪线案例

```plain
[root@pylinux tmp]# cd ~
[root@pylinux ~]# pwd
/root
[yu@pylinux ~]$
[yu@pylinux ~]$ pwd
/home/yu
```

短横杠案例

```plain
[root@pylinux opt]# cd /tmp
[root@pylinux tmp]# cd -
/opt
[root@pylinux opt]# cd -
/tmp
[root@pylinux tmp]# echo $OLDPWD
/opt
```

点案例

```plain
[root@pylinux tmp]# find .  -name "*.sh"
./yu.sh
./chaoge.sh
```

点点案例

```plain
[root@pylinux tmp]# mkdir ../opt/超哥nb
[root@pylinux tmp]#
[root@pylinux tmp]# ls /opt/
超哥nb
[root@pylinux home]# ls -a
.  ..  py  testyu  yu
```

### 特殊引号

在linux系统中，单引号、双引号可以用于表示字符串

| 名称 | 解释 |
| --- | --- |
| 单引号 '' | 所见即所得，强引用，单引号中内容会原样输出 |
| 双引号 "" | 弱引用，能够识别各种特殊符号、变量、转义符等，解析后再输出结果 |
| 没有引号 | 一般连续字符串、数字、路径可以省略双引号，遇见特殊字符，空格、变量等，必须加上双引号 |
| 反引号 \`\` | 常用于引用命令结果，同于$(命令) |

### 反引号案例

用反引号进行命令解析

```plain
[root@pylinux tmp]# date +%F
2019-11-05
[root@pylinux tmp]# touch `date +%F`.txt    #创建文件，名字是当前时间格式
[root@pylinux tmp]# ls
2019-11-05.txt
[root@pylinux tmp]# echo date
date
[root@pylinux tmp]# echo `date`        #反引号中命令会被执行
2019年 11月 05日 星期二 16:29:28 CST
[root@pylinux tmp]# which cat
/usr/bin/cat
[root@pylinux tmp]#
[root@pylinux tmp]# ls -l `which cat`        #反引号中命令被执行
-rwxr-xr-x. 1 root root 54080 4月  11 2018 /usr/bin/cat
```

### 双引号案例

当输出双引号内所有内容时，内容中有命令需要用反引号标记

```plain
[root@pylinux tmp]# echo "date"
date
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# echo "`date`"
2019年 11月 05日 星期二 16:30:42 CST
[root@pylinux tmp]# echo "今天是星期 `date +%w`"
今天是星期 2
[root@pylinux tmp]# echo "今年是$(date +%Y)年"
今年是2019年
```

### 单引号案例

单引号中内容是强引用，保持原样输出

```plain
[root@pylinux tmp]# echo "今天日期是 `date +%F`"        #双引号可以
今天日期是 2019-11-05
[root@pylinux tmp]# echo '今天日期是 `date +%F`'        #单引号不可以
今天日期是 `date +%F`
```

### 无引用案例

没有引号，很难确定字符串的边界，且linux命令是以空格区分的

建议用双引号代替不加引号

```plain
[root@pylinux tmp]# echo "今天是 `date +%Y`年"
今天是 2019年
[root@pylinux tmp]# echo 今天是 `date +%Y`年
今天是 2019年
[root@pylinux tmp]# ls "/tmp"
2019-11-05.txt
[root@pylinux tmp]#
[root@pylinux tmp]# ls /tmp
2019-11-05.txt
```

## 输出重定向特殊符号

输入设备

* 键盘输入数据
* 文件数据导入

输出设备

* 显示器、屏幕终端
* 文件

### 数据流

![1610807499252-30f888b3-7133-4461-b5f0-a90eb7e22320.png](img/Linux通配符/image4.png)

程序的数据流：

* 输入流：<---标准输入 （stdin），键盘
* 输出流：-->标准输出（stdout），显示器，终端
* 错误输出流：-->错误输出（stderr）

### 文件描述符

在Linux系统中，一切设备都看作文件。

而每打开一个文件，就有一个代表该打开文件的文件描述符。

程序启动时默认打开三个I/O设备文件：

* 标准输入文件stdin，文件描述符0
* 标准输出文件stdout，文件描述符1
* 标准错误输出文件stderr，文件描述符2

| 符号 | 特殊符号 | 简介 |
| --- | --- | --- |
| 标准输入stdin | 代码为0，配合< 或<< | 数据流从右向左 👈 |
| 标准输出stdout | 代码1，配合>或>> | 数据从左向右👉 |
| 标准错误stderr | 代码2，配合>或>> | 数据从左向右👉 |
| | | |
| 重定向符号 | | 数据流是箭头方向 |
| 标准输入重定向 | 0< 或 < | 数据一般从文件流向处理命令 |
| 追加输入重定向 | 0<<或<< | 数据一般从文件流向处理命令 |
| 标准输出重定向 | 1>或> | 正常输出重定向给文件，默认覆盖 |
| 标准输出追加重定向 | 1>>或>> | 内容追加重定向到文件底部，追加 |
| 标准错误输出重定向 | 2> | 讲标准错误内容重定向到文件，默认覆盖 |
| 标准错误输出追加重定向 | 2>> | 标准错误内容追加到文件底部 |

错误输出

```plain
[root@chaogelinux tmp]# ls yyy
ls: 无法访问yyy: 没有那个文件或目录
[root@chaogelinux tmp]#
[root@chaogelinux tmp]# ls yyy > cuowu.txt
ls: 无法访问yyy: 没有那个文件或目录
[root@chaogelinux tmp]# ls yyy >> cuowu.txt
ls: 无法访问yyy: 没有那个文件或目录
[root@chaogelinux tmp]# ls yyy 2> cuowu.txt
[root@chaogelinux tmp]#
[root@chaogelinux tmp]#
[root@chaogelinux tmp]# cat cuowu.txt
ls: 无法访问yyy: 没有那个文件或目录
```

### 特殊重定向，合并重定向

* `2>&1`把标准错误，重定向到标准输出

把命令的执行结果写入文件，标准错误当做标准输出处理，也写入文件

* Command > /path/file 2>&1

```plain
echo "I am oldboy" 1>>oldboy.txt 2>>oldboy.txt
echo  "I am oldboy"  >> /dev/null 2>&1            #  命令已经将结果重定向到/dev/null，2>&1符号也会将标准错误输出到/dev/null，/dev/null是一个黑洞，只写文件
```

### 输入重定向

数据流输入

```plain
[root@chaogelinux tmp]# cat < yu2.txt
我是 yu2，你是谁，想偷看我？
#mysql数据导入
mysql -uroot -p < db.sql
[root@chaogelinux ~]# cat chaoge.txt
a b c d e f g
[root@chaogelinux ~]# tr -d 'a-c' < chaoge.txt
   d e f g
[root@chaogelinux ~]# wc -l < chaoge.txt
1
```

### 其他特殊符号

| 符号 | 解释 |
| --- | --- |
| ; | 分号，命令分隔符或是结束符 |
| # | 1.文件中注释的内容 2.root身份提示符 |
| | | 管道符，传递命令结果给下一个命令 |
| $ | 1.$变量，取出变量的值 2.普通用户身份提示符 |
| \ | 转义符，将特殊含义的字符还原成普通字符 |
| {} | 1.生成序列 2.引用变量作为变量与普通字符的分割 |

### ；号

* 表示命令的结束
* 命令间的分隔符
* 配置文件的注释符

```plain
[root@pylinux tmp]# pwd;ls            #执行两条命令
/tmp
2019-11-05.txt  oldboy.txt  txt
```

### #号

* 注释行

```plain
# nginx.conf
#user  nobody;
worker_processes  1;
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
#pid        logs/nginx.pid;
```

### |号

比如生活中的管道，能够传输物质

Linux管道符 | 用于传输数据，对linux命令的处理结果再次处理，直到得到最终结果

```plain
[root@pylinux ~]# ifconfig |grep inet
        inet 10.141.32.137  netmask 255.255.192.0  broadcast 10.141.63.255
        inet 127.0.0.1  netmask 255.0.0.0
[root@pylinux tmp]# ls | grep .txt
2019-11-05.txt
oldboy.txt
[root@pylinux tmp]# netstat -tunlp|grep 22
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1401/sshd
[root@pylinux tmp]# netstat -tunlp|grep 3306
[root@pylinux tmp]# netstat -tunlp|grep 80
[root@pylinux tmp]# ps aux|grep python
[root@pylinux tmp]# ps aux|grep mariadb
```

能一次出结果的命令，尽量不要二次过滤，效率并不高

### $符

Linux系统命令行中，字符串前加$符，代表字符串变量的值

```plain
[root@pylinux tmp]# echo OLDPWD
OLDPWD
[root@pylinux tmp]# echo $OLDPWD
/root
[root@pylinux tmp]# echo PATH
PATH
[root@pylinux tmp]# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/python37/bin:/root/bin
[root@pylinux tmp]# name="超哥带你学linux"
[root@pylinux tmp]# echo name
name
[root@pylinux tmp]# echo $name
超哥带你学linux
```

### {}符

1.生成序列，一连串的文本

```plain
[root@pylinux tmp]# echo {1..100}
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100
[root@pylinux tmp]# echo {a..i}
a b c d e f g h i
[root@pylinux tmp]# echo {i..a}
i h g f e d c b a
[root@pylinux tmp]# echo {1..9}
1 2 3 4 5 6 7 8 9
[root@pylinux tmp]# echo {o,l,d}
o l d
```

2.利用{}快速备份文件

```plain
[root@pylinux tmp]# cp /etc/sysconfig/network-scripts/ifcfg-eth0{,.ori}
```

3.将变量括起来作为变量的分隔符

```plain
[root@pylinux tmp]# echo $week
3
[root@pylinux tmp]# echo "$week_oldboy"      #输出为空，系统人为week_oldboy是整个变量
[root@pylinux tmp]# echo "${week}_oldboy"        #花括号中才会识别是变量，作了分割
3_oldboy
```

### 逻辑操作符

逻辑符既可以在linux系统中直接用，也可以在Bash脚本中用

| 命令 | 解释 |
| --- | --- |
| && | 前一个命令成功，再执行下一个命令 |
| || | 前一个命令失败了，再执行下一个命令 |
| ! | 1.在bash中取反 2.在vim中强制性 3.历史命令中 !ls找出最近一次以ls开头的命令 |

1.&&案例

```plain
[root@pylinux tmp]# ls && cd /opt && pwd        #执行成功会继续下一个命令
2019-11-05.txt  oldboy.txt  txt
/opt
[root@pylinux opt]# ls /tmpp && cd /tmp        #执行失败就结束
ls: 无法访问/tmpp: 没有那个文件或目录
```

1. ||案例

```plain
[root@pylinux opt]# ls /tmpp || cd /tmp            #执行失败才会继续下一个命令
ls: 无法访问/tmpp: 没有那个文件或目录
[root@pylinux tmp]#
[root@pylinux tmp]# cd /opt || cd /root            #执行成功则不会继续下一个命令
[root@pylinux opt]#
```

1. 感叹号
2. 取反

```plain
[root@pylinux tmp]# ls [a-f]*
a  b  c  d  e  f
[root@pylinux tmp]# ls [!a-f]*        #取反的意思
2019-11-05.txt  g  h  i  j  k  l  m  n  o  oldboy.txt  p  q  r  s  t  txt  u  v  w  x  y  z
```

* 感叹号的vim强制退出
* 找出历史命令

# linux正则表达式与grep

## bash是什么

<!-- OCR_START -->
- portage portage
- 5643Apr
- 5
- 14:37bash-4.0_p10-r1.ebui1d
- portage
- 6230p
- 1
- 14:37bast-4.0_p10.ebuf1d
- 48
- Hpr
- 0017-n
- arsm
- 3
- 25
- Apr
- portay
- basnry.
- Jul251
- 130
- 8
- 1e
- 3portage
- Mau
- portag
- root
- 2
- Mar23
- bash-3.2
- -xr-x
- roo
- J82Jul
- 23
- 21
- 33portage
- oot
- Jul
- bash-3.
- wtage
- 7Mar23
- not
- 4645Mar
- 1root
- 7bash-3,
- ot
- porta
- irtage
- 5977Mar
- 514
- Feb
- nP
- 7bash-4
- -r
- rtagepor
- 38Mar
- 6151Ar
- 232
- ata
- 43Apr
- 37bash-
- portage po
- 5988
- 2bash-
- 38Apr
- 5643
- por
- ameta
- portar
- 6238
- 05
- 148
- 48Apr14
- 810:21bash
- ge
- 564
- 810
- Dortageporta,
- 532Apr
- 03:35bash-
- w-r--r
- 30
- .age
- yr
- 03
- rtage portag
- 5660ay
- 9:43bash
- 55
- geportage
- tage
- 89
- 3:35file
- 5660riay
- eportage
- 5668 Jui
- rw-r--r-
- rtage
- 2848May
- 4:35met
- 5660 Jui
- 3003
- 84
- 468Fet
- catmet
- 1portage
- -oFeb
- -shells/
- -rw-r-
- /bash
- -X
- 1portageportar
- "UTF-8"?>
- entoo.org
- 2portag
- -r4-r-
- 1port
- ortage/apr
- /usr/portage
- dirwxr-xr-x
- rumnd.gent
- sain
- "http:/
- "1,0encn
<!-- OCR_END -->

* bash是一个命令处理器，运行在文本窗口中，并能执行用户直接输入的命令
* bash还能从文件中读取linxu命令，称之为脚本
* bash支持通配符、管道、命令替换、条件判断等逻辑控制语句

### bash的特性

* 命令行展开

```plain
[root@chaogelinux ~]# echo {tom,bob,chaoge,jerry}
tom bob chaoge jerry
[root@chaogelinux ~]# echo chaoge{666,888}
chaoge666 chaoge888
[root@chaogelinux ~]# echo chaoge{1..5}
chaoge1 chaoge2 chaoge3 chaoge4 chaoge5
[root@chaogelinux ~]# echo chaoge{1..10..2}
chaoge1 chaoge3 chaoge5 chaoge7 chaoge9
[root@chaogelinux ~]# echo chaoge{01..10..2}
chaoge01 chaoge03 chaoge05 chaoge07 chaoge09
```

* 命令别名

```plain
alias,unalias
```

* 命令历史

```plain
history
!行号
!! 上一次的命令
```

* 快捷键

```plain
ctrl + a  移动到行首
ctrl + e  移动到行尾
ctrl + u  删除光标之前的字符
ctrl + k  删除光标之后的字符
ctrl + l  清空屏幕终端内容，同于clear
```

* 命令补全

```plain
tab键
补全
    $PATH中存在的命令
```

* 文件路径补全

```plain
/opt/chaoge/linux_study
```

# Linux正则表达式



<!-- OCR_START -->
> RegExp
> 正则表达式工具
<!-- OCR_END -->



正则表达式：Regual Expression, REGEXP

由一类特殊字符及文本字符所编写的模式，其中有些字符不表示其字面意义，而是用于表示控制或通配的功能；

分两类：

```plain
基本正则表达式：BRE
扩展正则表达式：ERE
```

## 正则表达式的意义

* 处理大量的字符串
* 处理文本

通过特殊符号的辅助，可以让linux管理员快速过滤、替换、处理所需要的字符串、文本，让工作高效。

通常Linux运维工作，都是面临大量带有字符串的内容，如

* 配置文件
* 程序代码
* 命令输出结果
* 日志文件

且此类字符串内容，我们常会有特定的需要，查找出符合工作需要的特定的字符串，因此正则表达式就出现了

* 正则表达式是一套规则和方法
* 正则工作时以单位进行，一次处理一行
* 正则表达式化繁为简，提高工作效率
* linux仅受三剑客（sed、awk、grep）支持，其他命令无法使用

正则表达式应用非常广泛，应用在如Python、Java、Perl等，Linux下普通命令无法使用正则表达式的，只能使用三剑客。

**通配符是大部分普通命令都支持的，用于查找文件或目录，而正则表达式是通过三剑客命令在文件（数据流）中过滤内容的**

## Linux三剑客

文本处理工具，均支持正则表达式引擎

* grep：文本过滤工具，（模式：pattern）工具
* sed：stream editor，流编辑器；文本编辑工具
* awk：Linux的文本报告生成器（格式化文本），Linux上是gawk

### 正则表达式的分类

Linux三剑客主要分两类

* 基本正则表达式（BRE、basic regular expression）

```plain
BRE对应元字符有 ^$.[]*
```

* 扩展正则表达式（ERE、extended regular expression）

```plain
ERE在在BRE基础上，增加上 (){}?+| 等字符
```

### 基本正则表达式BRE集合

* 匹配字符
* 匹配次数
* 位置锚定

| 符号 | 作用 |
| --- | --- |
| ^ | 尖角号，用于模式的最左侧，如 "^oldboy"，匹配以oldboy单词开头的行 |
| $ | 美元符，用于模式的最右侧，如"oldboy$"，表示以oldboy单词结尾的行 |
| ^$ | 组合符，表示空行 |
| . | 匹配任意一个且只有一个字符，不能匹配空行 |
| \ | 转义字符，让特殊含义的字符，现出原形，还原本意，例如`\.`代表小数点 |
| \* | 匹配前一个字符（连续出现）0次或1次以上 ，重复0次代表空，即匹配所有内容 |
| .\* | 组合符，匹配任意长度的任意字符 |
| ^.\* | 组合符，匹配任意多个字符开头的内容 |
| .\*$ | 组合符，匹配以任意多个字符结尾的内容 |
| \[abc] | 匹配\[]集合内的任意一个字符，a或b或c，可以写\[a-c] |
| `[^abc]` | 匹配除了^后面的任意字符，a或b或c，^表示对\[abc]的取反 |
| `<pattern>` | 匹配完整的内容 |
| <或> | 定位单词的左侧，和右侧，如`<chao>`可以找出"The chao ge"，缺找不出"yuchao" |

### 扩展正则表达式ERE集合

扩展正则必须用 grep -E 才能生效

| 字符 | 作用 |
| --- | --- |
| + | 匹配前一个字符1次或多次，前面字符至少出现1次 |
| \[:/]+ | 匹配括号内的":"或者"/"字符1次或多次 |
| ? | 匹配前一个字符0次或1次，前面字符可有可无 |
| 竖线 | 表示或者，同时过滤多个字符串 |
| () | 分组过滤，被括起来的内容表示一个整体 |
| | |
| a{n,m} | 匹配前一个字符最少n次，最多m次 |
| a{n,} | 匹配前一个字符最少n次 |
| a{n} | 匹配前一个字符正好n次 |
| a{,m} | 匹配前一个字符最多m次 |

Tip:

```plain
grep命令需要使用参数 -E即可支持正则表达式
egrep不推荐使用，使用grep -E替代
grep不加参数，得在特殊字符前面加"\"反斜杠，识别为正则
```

### grep

全拼：Global search REgular expression and Print out the line.

**作用：文本搜索工具，根据用户指定的“模式（过滤条件）”对目标文本逐行进行匹配检查，打印匹配到的行**

**模式：由正则表达式的**`**元字符**`**及**`**文本字符**`**所编写出的**`**过滤条件**`**；**

```plain
语法：
grep [options] [pattern]  file 
命令  参数   匹配模式   文件数据
                -i：ignorecase，忽略字符的大小写；
                -o：仅显示匹配到的字符串本身；
                -v, --invert-match：显示不能被模式匹配到的行；
                -E：支持使用扩展的正则表达式元字符；
                -q, --quiet, --silent：静默模式，即不输出任何信息；
```

grep命令是Linux系统中最重要的命令之一，功能是从`文本文件`或`管道数据流`中筛选匹配的`行`和`数据`，如果再配合`正则表达式`，功能十分强大，是Linux运维人员必备的命令

grep命令里的`匹配模式`就是你想要找的东西，可以是`普通的文字符号`，也可以是正则表达式

| 参数选项 | 解释说明 |
| --- | --- |
| -v | 排除匹配结果 |
| -n | 显示匹配行与行号 |
| -i | 不区分大小写 |
| -c | 只统计匹配的行数 |
| -E | 使用egrep命令 |
| --color=auto | 为grep过滤结果添加颜色 |
| -w | 只匹配过滤的单词 |
| -o | 只输出匹配的内容 |

*案例*

```plain
cat /etc/passwd > /tmp/test_grep.txt
grep  "login" /tmp/test_grep.txt  -n                                #找出login有关行
grep  "login" /tmp/test_grep.txt  -n -v                                 #找出没有login的行
grep   "ROOT" /tmp/test_grep.txt  -i                                      #忽略大小写，找出root有关行
grep -E  "root|sync"  /tmp/test_grep.txt --color=auto       #同时过滤出root和sync有关行
grep "login" /tmp/test_grep.txt  -c                 #统计匹配结果的行数
grep "login" /tmp/test_grep.txt   -n -o                   #只输出匹配出的内容
grep "oldboy" /tmp/test_grep.txt -w                         #完整匹配，字符串精确匹配，整个单词
grep -Ev "^#|^$"  /tmp/test_grep.txt                       #过滤掉空白和注释行
```

## 正则表达式grep实践

准备测试文件

<!-- OCR_START -->
| 排名 | cat-nluffy.txt | cat-nluffy.txt | 排名(上年) |
| --- | --- | --- | --- |
| 1 | Iamoldboyteacher | 2 | I： |
| teach linux. | 3 | like python. | 4 |
| 5 | My | /qqis877348180. | 6 |
| 7 | My | name is chaoge. | 8 |
| 9 | Our school website is http://oldboyedu.com | 10 | 11 |
<!-- OCR_END -->

### ^符号

1.输出所有以m开头的行

```plain
[root@pylinux data]# grep -i  -n "^m" luffy.txt        # -i忽略大小写  -n 显示仪行号
5:My qq is 877348180.
7:My name is chaoge.
```

<!-- OCR_START -->
- [root@pylinux data]#
- grep -n -i "^m" luffy.txt
- 5:My
- qq is 877348180
- 7:My
- name
- eischaoge.
<!-- OCR_END -->

2.输出所有以i开头的行

```plain
[root@pylinux data]# grep -i -n "^i" luffy.txt
1:I am oldboy teacher
2:I teach linux.
3:I like python.
```

<!-- OCR_START -->
- [root@pylinuxc
- datal#
- grep -i -n "^i" luffy.txt
- 1:I
- amoldboyteacher
- 2:I
- teach linux.
- 3:I
- Like python.
<!-- OCR_END -->

### $符

1.输出所有以r结尾的行

```plain
[root@pylinux data]# grep -i -n "r$" luffy.txt
1:I am oldboy teacher
```

<!-- OCR_START -->
- [root@pylinux
- data]#
- grep -i -n "r$" 1
- luffy.txt
- 1:I
- am
- oldboy
- teacher
<!-- OCR_END -->

2.输出所以以m结尾的行

```plain
[root@pylinux data]# grep -i -n "m$" luffy.txt
9:Our school website is http://oldboyedu.com
```

<!-- OCR_START -->
- [root@pylinux data]# grep -i -n "m$" luffy.txt
- oun
- school
- wehslte
- ://oldhovedu
<!-- OCR_END -->

TIP

```plain
注意在Linux平台下，所有文件的结尾都有一个$符
可以用cat -A 查看文件
```

3.输出所有以"."结尾的行，注意用转义符

```plain
1.注意不加转义符的结果，正则里"."是匹配任意1个字符，grep把.当做正则处理了，因此把有数据的行找出来了，
[root@pylinux data]# grep -i -n ".$" luffy.txt
1:I am oldboy teacher
2:I teach linux.
3:I like python.
5:My qq is 877348180.
7:My name is chaoge.
9:Our school website is http://oldboyedu.com
2.加上转义符，当做普通的小数点过滤
[root@pylinux data]# grep -i -n "\.$" luffy.txt
2:I teach linux.
3:I like python.
5:My qq is 877348180.
7:My name is chaoge.
```

### ^$组合符

```plain
1.找出文件的空行，以及行号
[root@pylinux data]# grep "^$" luffy.txt  -n
4:
6:
8:
10:
11:
12:
```

<!-- OCR_START -->
- [root@pylinuxdata]#
- grep
- "^$" luffy.txt
- 4：
- 6:
- 8:
- 10:
- 11:
- 12:
<!-- OCR_END -->

### .点符号

"."点表示任意一个字符，有且只有一个，不包含空行

```plain
[root@pylinux data]# grep -i -n "." luffy.txt
1:I am oldboy teacher
2:I teach linux.
3:I like python.
5:My qq is 877348180.
7:My name is chaoge.
9:Our school website is http://oldboyedu.com
```

<!-- OCR_START -->
- [root@pylinux data]# grep -i -n "." luffy.txt
- 1:Iamoldboyteacher
- 2:I teach linux.
- 3:I like python.
- 5:Myqqis877348180
- 7 :My name
- eischaoge.
- 9:Our school
- website
- is
- http://oldboyedu.com
<!-- OCR_END -->

匹配出 ".ac"，找出任意一个三位字符，包含ac

```plain
[root@pylinux data]# grep -i -n ".ac" luffy.txt
1:I am oldboy teacher
2:I teach linux.
```

<!-- OCR_START -->
- [root@pylinux
- data]#
- grep -i -n ".ac" luffy.txt
- 1:I am oldboy
- teacher
- 2:It
- teach linux.
<!-- OCR_END -->

### \转义符

1.找出文中所有的点"."

```plain
[root@pylinux data]# grep "\." luffy.txt
I teach linux.
I like python.
My qq is 877348180.
My name is chaoge.
Our school website is http://oldboyedu.com
```

<!-- OCR_START -->
- [root@pylinux
- data]#
- grep
- "\."luffy.txt
- I：
- teach linux.
- I like python.
- My
- qq is 877348180.
- name is
- chaoge.
- Ourschool website
- s http://oldboyedu.com
<!-- OCR_END -->

### \*符

1.找出前一个字符0次或多次，找出文中出现"i"的0次或多次

```plain
[root@pylinux data]# grep -n "i*" luffy.txt
1:I am oldboy teacher
2:I teach linux.
3:I like python.
4:
5:My qq is 877348180.
6:
7:My name is chaoge.
8:
9:Our school website is http://oldboyedu.com
10:
11:
12:
```

<!-- OCR_START -->
- [root@pylinux
- data#
- grep -n "i*"
- luffy.txt
- 1:I
- amoldboyteacher
- 2:I
- teach linux.
- 3:I like python.
- 4:
- 5:My qq is 8
- 877348180.
- 6:
- 7:My name
- is
- chaoge.
- 8:
- 9:Our school
- website is http://oldboyedu.com
- 10:
- 11:
- 12:
<!-- OCR_END -->

### .\*组合符

.表示任意一个字符，\*表示匹配前一个字符0次或多次，因此放一起，代表匹配所有内容，以及空格

```plain
[root@pylinux data]# grep '.*' luffy.txt
I am oldboy teacher
I teach linux.
I like python.
My qq is 877348180.
My name is chaoge.
Our school website is http://oldboyedu.com
```

<!-- OCR_START -->
- [root@pylinuxdata]#
- grep
- ·.*+
- luffy.txt
- amoldboyteacher
- teach linux.
- like python.
- Myqqis877348180.
- My
- name
- eischaoge
- Ourschoolwebsiteishttp://oldboyedu.com
- [root@pylinux
- data]#
<!-- OCR_END -->

### ^.\*o符

^以某字符为开头

.任意0或多个字符

.\*代表匹配所有内容

o普通字符，一直到字母o结束

这种匹配相同字符到最后一个字符的特点，称之为贪婪匹配

```plain
[root@chaogelinux data]# grep "I.*o" luffy.txt
I am oldboy teacher
I like python.
```

### `[abc]中括号`

中括号表达式，\[abc]表示匹配中括号中任意一个字符，a或b或c，常见形式如下

* \[a-z]匹配所有小写单个字母
* \[A-Z]匹配所有单个大写字母
* \[a-zA-Z]匹配所有的单个大小写字母
* \[0-9]匹配所有单个数字
* \[a-zA-Z0-9]匹配所有数字和字母

```plain
[root@pylinux data]# grep '[a-z]' luffy.txt
I am oldboy teacher
I teach linux.
I like python.
My qq is 877348180.
My name is chaoge.
Our school website is http://oldboyedu.com
```

<!-- OCR_START -->
- [root@pylinuxc
- datal#
- grep
- [a-z]'luffy.txt
- amoldboyteacher
- teach linux.
- like python.
- My
- qq is
- 877348180
- nameischaoge
- Our school
- L website is http://oldboyedu.com
<!-- OCR_END -->

```plain
[root@pylinux data]# grep '[abcd]' luffy.txt
I am oldboy teacher
I teach linux.
My name is chaoge.
Our school website is http://oldboyedu.com
```

<!-- OCR_START -->
- [root@pylinux data]#
- grep
- '[abcd]' luffy.txt
- amoldboyteacher
- teach linux.
- My
- name is
- chaoge.
- Our school website
- e is http://oldboyedu.com
<!-- OCR_END -->

### grep参数-o

使用"-o"选项，可以只显示被匹配到的关键字，而不是讲整行的内容都输出。

*显示文件中有多少个字符a*

```plain
[root@pylinux data]# grep -o  'a' luffy.txt |wc -l
5
```

### `[^abc]中括号中取反`

`[^abc]`或`[^a-c]`这样的命令，"^"符号在中括号中第一位表示排除，就是排除字母a或b或c

**出现在中括号里的尖角号表示取反**

1.找出除了小写字母以外的字符

```plain
[root@pylinux data]# grep '[^a-z]' luffy.txt
I am oldboy teacher
I teach linux.
I like python.
My qq is 877348180.
My name is chaoge.
Our school website is http://oldboyedu.com
```

<!-- OCR_START -->
- [root@pylinuxdata]#
- grep
- '[^a-z]'luffy.txt
- amoldboyteacher
- teach linux.
- like
- epython.
- My
- qqis877348180.
- name is
- chaoge.
- Our school website is http://oldboyedu.com
<!-- OCR_END -->

## 扩展正则表达式实践

此处使用grep -E进行实践扩展正则，egrep官网已经弃用

### +号

+号表示匹配前一个字符1次或多次，必须使用grep -E 扩展正则

```plain
[root@pylinux data]# grep -E  'l+'  luffy.txt
I am oldboy teacher
I teach linux.
I like python.
Our school website is http://oldboyedu.com
```

<!-- OCR_START -->
- [root@pylinux
- data]#
- grep
- luffy.txt
- [root@pylinuxdata]#
- grep -E
- 'l+'
- amoldboyteacher
- teach
- I linux.
- I like python.
- Our school
- website is http://oldboyedu.com
<!-- OCR_END -->

### ?符

匹配前一个字符0次或1次

1.找出文件中包含gd或god的行

```plain
[root@pylinux data]# grep -E 'go?d' luffycity.txt
god            #字母o出现了一次
gd          #字母o出现了0次
```

### |符

竖线|在正则中是或者的意思

1.找出系统中的txt文件，且名字里包含a或b的字符

```plain
[root@pylinux data]# find / -maxdepth 3  -name "*.txt" |grep -i -E "a|b"
/data/luffycity.txt
/data/luffy.txt
/test_find/chaoge.txt
/test_find/alex.txt
/opt/all.txt
/opt/_book/123.txt
/opt/Python-3.7.3/pybuilddir.txt
/opt/alltxt.txt
/opt/s15oldboy/qiong.txt
/opt/IIS/keystorePass.txt
```

### ()小括号

将一个或多个字符捆绑在一起，当作一个整体进行处理；

* 小括号功能之一是`分组过滤被括起来的内容`，`括号内的内容表示一个整体`
* 括号()内的内容可以`被后面的"\n"正则引用`，`n为数字`，表示`引用第几个括号`的内容
  * `\1`：表示从左侧起，第一个括号中的模式所匹配到的字符
  * `\2`：从左侧期，第二个括号中的模式所匹配到的字符

1.找出包含good和glad的行

```plain
[root@pylinux data]# grep -E 'goo|lad' luffycity.txt        #结果不是我们想要的
good
goooood
goooooood
glad
[root@pylinux data]# grep -E 'good|glad' luffycity.txt    #我们希望能够实现这这样的匹配
good
glad
[root@pylinux data]# grep -E 'g(oo|la)d' luffycity.txt
good
glad
```

<!-- OCR_START -->
[root@pylinux data]# grep -E 'goodlglad' luffycity.txt
good
glad
[root@pylinux data]# grep -E 'goollad' luffycity.txt
goooood
goooooood
[root@pylinux data]# grep -E 'gCoolla)d' luffycity.txt
<!-- OCR_END -->

**分组之后向引用**

```plain
[root@chaogelinux data]# cat lovers.txt
I like my lover.
I love my lover.
He likes his lovers.
He love his lovers.
[root@chaogelinux data]# grep -E  '(l..e).*\1' lovers.txt
I love my lover.
He love his lovers.
[root@chaogelinux data]# grep -E '(r..t).*\1' /etc/passwd    #案例2
root:x:0:0:root:/root:/bin/bash
```

# 最清晰的分组解释

<!-- OCR_START -->
- root@web02
- 1#
- I>是单词结尾锚定
- 分组案例：
- 匹配一个单词
- 找出，用户名，
- shell名相同的行
- 如 sync
- shutdown
- ~]#
- halt
- ~]#
- ～]#
- [root@web02 ~]# grep -E
- C[△:]+\>
- /etc/passwd
- sync:x:5:0:sync:/sbin:/binsync
- 分组概念：
- shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
- 第一个括号内的正则的值，用后面的\1变量引用
- halt:x:7:0:halt:/sbin:/sbin/halt
- 如有第二个括号，用后续\2变量引用
- bash:x:8889:8889::/home/bash:/bin/bash
- 正则解释
- grep -E '^([^:]+\>).*\1$'
- ~]#
- [^:]+找出除了冒号以外的多个字符
- ～]#
- ［^:]+找出除了冒号以外的多个字符开头的行
- ~]#
- ［:]+>找出除了冒号以外的多个字符开头的行，且锚定单词
- 也就锁定了/etc/passwd的第一个字段，也就是用户名
- （L：+>）*表示匹配用户名后续所有的内容
- 重点：
- ^([^:]+\>).*1$表示匹配用户名后所有内容，且结尾是前面括号内的单词
- 分组用法（[：]+>)这是第一个括号分组，找出了用户名，\1是取出括号的值，也是用户名
<!-- OCR_END -->

### {n,m}匹配次数

重复前一个字符各种次数，可以通过-o参数显示明确的匹配过程

<!-- OCR_START -->
- [root@pylinux data]# grep
- -E
- "a{1,3}" luffycity.txt
- aadaaaaaaaalllxxx
- 匹配字母a
- chaogeeee
- 最少1次
- [root@pylinux data]#
- 最多3次
- -0
- aaa
- 每次匹配，最多3个
- 第一行多次匹配
- 剩下2个
- aa
- 下一行只有一个a
- -E-O
- "a{2,3}" luffycity.txt
- 匹配最少2个，最多3个
- 因此第二行只有一个a，没显示
<!-- OCR_END -->

<!-- OCR_START -->
- [root@pylinux data]# grep
- 'a{4,}" luffycity.txt
- aaaaaaaaaaa
- 最少匹配4个a，
- 因此一次输出
- -E
- -0
- a{,4了"
- luffycity.txt
- aaaa
- 一次最多匹配4个a
- aaa
<!-- OCR_END -->

# Linux三剑客sed

# **注意sed和awk使用单引号，双引号有特殊解释**

sed是Stream Editor（字符流编辑器）的缩写，简称流编辑器。

sed是操作、过滤和转换文本内容的强大工具。

常用功能包括结合正则表达式对文件实现快速增删改查，其中查询的功能中最常用的两大功能是过滤（过滤指定字符串）、取行（取出指定行）。

<!-- OCR_START -->
- 文件test.txt
- sed模式空间
- pattern space
- I have a pen
- 一次读取一行
- I have an apple
- 读取每一行数据放入自己的工作车间
- （文本数据读入内存）
- Apple pen
- 模式匹配
- 匹配成功
- 匹配失败
- 默认输出到屏幕（可以取消）
- 编辑 （输出到屏幕）
- sed工作流程图
<!-- OCR_END -->

***

<!-- OCR_START -->
| 名称 | 名称 | 排名 | 名称 | 名称 |
| --- | --- | --- | --- | --- |
| 小人进去理发店 | 十个小人等待理发 | 理发店，处理头发 | (十行文本数据) | (sed模式空间，处理内存数据） |
| sed读取文本内容 | 不符规则 (不用理发) | 5 | 理发规则 | （头发超过5厘米的必须减） |
| 模式规则 | （处理哪一行数据） | 6 | 没理发的人回到队伍 | 符合规则， |
<!-- OCR_END -->

语法：

```plain
sed [选项] [sed内置命令字符] [输入文件]
```

选项：

| 参数选项 | 解释 |
| --- | --- |
| -n | 取消默认sed的输出，常与sed内置命令p一起用 |
| -i | 直接将修改结果写入文件，不用-i，sed修改的是内存数据 |
| -e | 多次编辑,不需要管道符了 |
| -r | 支持正则扩展 |

sed的`内置命令字符`用于对文件进行不同的操作功能，如对文件增删改查

sed常用`内置命令字符`：

| sed的内置命令字符 | 解释 |
| --- | --- |
| a | append，对文本追加，在指定行后面添加一行/多行文本 |
| d | Delete，删除匹配行 |
| i | insert，表示插入文本，在指定行前添加一行/多行文本 |
| p | Print ，打印匹配行的内容，通常p与-n一起用 |
| s/正则/替换内容/g | 匹配正则内容，然后替换内容（支持正则），结尾g代表全局匹配 |

sed匹配范围

| 范围 | 解释 |
| --- | --- |
| 空地址 | 全文处理 |
| 单地址 | 指定文件某一行 |
| `/pattern/` | 被模式匹配到的每一行 |
| 范围区间 | `10,20 十到二十行`，`10,+5第10行向下5行`，`/pattern1/,/pattern2/` |
| 步长 | `1~2，表示1、3、5、7、9行`，`2~2两个步长，表示2、4、6、8、10、偶数行` |

## sed案例

准备测试数据

```plain
[root@pylinux data]# cat -n luffycity.txt
     1    My name is chaoge.
     2    I teach linux.
     3    I like play computer game.
     4    My qq is 877348180.
     5    My website is http://pythonav.cn.
```

### 1.输出文件第2，3行的内容

```plain
[root@pylinux data]# sed -n '2,3p' luffycity.txt    
I teach linux.
I like play computer game.
```

<!-- OCR_START -->
- [root@pylinuxdata]#sed
- "2,3p" luffycity.txt
- My name is chaoge.
- teach linux.
- sed默认输出所有结果
- like play computer game.
- Ilikeplaycomputergame.
- My
- / qqis 877348180
- My website is http://pythonav.cn.
- [root@pylinuxdata]#
- [root@pylinux data]# sed -n "2,3p" luffycity.txt
- 添加-n参数不显示默认输出
<!-- OCR_END -->

***

### 2.过滤出含有linux的字符串行

```plain
#sed可以实现grep的过滤效果，必须吧要过滤的内容放在双斜杠中
[root@pylinux data]# sed -n '/linux/p' luffycity.txt        
I teach linux.
```

***

### 3.删除含有game的行

**注意sed想要修改文件内容，还得用-i参数**

```plain
[root@pylinux data]# sed '/game/d' luffycity.txt
My name is chaoge.
I teach linux.
My qq is 877348180.
My website is http://pythonav.cn.
```

<!-- OCR_START -->
[root@pylinux data]# cat -n luffycity.txt
1 My name is chaoge.
2
I teach linux.
3
I like play computer game.
4
：My qq is 877348180
5 My website is http://pythonav.cn.
[root@pylinux data]#
[root@pylinux data]# sed '/game/d' luffycity.txt
My name is chaoge.
有关game的行删了
Mywebsiteishttp://pythonav.cn.
<!-- OCR_END -->

想要将修改结果写入到文件，还得这么敲

```plain
[root@pylinux data]# sed  -i '/game/d' luffycity.txt  #不会输出结果，直接写入文件
```

删掉2，3两行

```plain
[root@pylinux data]# sed '2,3d' luffycity.txt
```

删除第5行到结尾

```plain
[root@pylinux data]# sed '5,$d'  luffycity.txt
My name is chaoge.
----------
I teach linux.
----------
```

***

### 4.将文件中的My全部替换为His

* s内置符配合g，代表全局替换，中间的"/"可以替换为"#@/"等

```plain
[root@pylinux data]# sed 's/My/His/g' luffycity.txt
His name is chaoge.
I teach linux.
I like play computer game.
His qq is 877348180.
His website is http://pythonav.cn.
```

***

### 5.替换所有My为His，同时换掉QQ号为8888888

```plain
[root@pylinux data]# sed -e 's/My/His/g' -e 's/877348180/88888/g' luffycity.txt
His name is chaoge.
I teach linux.
I like play computer game.
His qq is 88888.
His website is http://pythonav.cn.
```

***

### 6.在文件第二行追加内容 a字符功能，写入到文件，还得添加 -i

```plain
[root@pylinux data]# sed -i '2a I am useing  sed command' luffycity.txt
My name is chaoge.
I teach linux.
I am useing  sed command
I like play computer game.
My qq is 877348180.
My website is http://pythonav.cn.
```

<!-- OCR_START -->
[root@pylinux data]# sed -i '2a I am useing sed command' luffycity.txt
在第二行下面，添加了内容
[root@pylinux data]#
[root@pylinux data]# catluffycity.txt
-n
1 My name is chaoge.
2I teach linux.
2
3
I am useing sed command
I like play computer game.
4
5My qq is 877348180.
6
5 My website is http://pythonav.cn.
<!-- OCR_END -->

添加多行信息，用换行符"\n"

```plain
[root@pylinux data]# sed -i "3a i like linux very much.\nand you?" luffycity.txt
[root@pylinux data]#
[root@pylinux data]# cat -n luffycity.txt
     1    My name is chaoge.
     2    I teach linux.
     3    I am useing  sed command
     4    i like linux very much.
     5    and you?
     6    I like play computer game.
     7    My qq is 877348180.
     8    My website is http://pythonav.cn.
```

<!-- OCR_START -->
- [root@pylinux data]# sed -i "3a i like linux very much.\nand you?" luffycity.txt
- [root@pylinux data]#
- [root@pylinux data]# cat -n luffycity.txt
- 1 My name is chaoge.
- 2
- I teach linux.
- 3
- I am useing sed command
- 4
- i like linux very much.
- 5
- and you?
- 6
- I like play computer game.
- My qq is 877348180.
- Mywebsiteishttp://pythonav.cn.
<!-- OCR_END -->

在每一行下面插入新内容

```plain
[root@pylinux data]# sed "a ----------" luffycity.txt
My name is chaoge.
----------
I teach linux.
----------
I am useing  sed command
----------
i like linux very much.
----------
and you?
----------
I like play computer game.
----------
My qq is 877348180.
----------
My website is http://pythonav.cn.
----------
```

***

### 7.在第二行上面插入内容

```plain
[root@pylinux data]# sed '2i i am 27' luffycity.txt
My name is chaoge.
i am 27
----------
I teach linux.
----------
I am useing  sed command
----------
i like linux very much.
----------
and you?
----------
I like play computer game.
----------
My qq is 877348180.
----------
My website is http://pythonav.cn.
----------
```

## sed配合正则表达式企业案例

上一节是用grep -E 扩展正则表达式，这一节是用sed配合正则表达式使用

### 取出linux的IP地址

1.删除网卡信息

<!-- OCR_START -->
- [root@pylinux ~]# ifconfig
- eth0: flagS=4163<IP , BROADCAST,RUNNING,MULTICAST>
- mtu 1500
- inet
- 10.141.32.137
- netmask 255.255.192.0
- broadcast
- .63.255
- ether 52:54:0
- txqueuelen 1000 (Ethernet)
- RXpackets 3958953bytes 447491542(426.7MiB)
- RX errors 0 dropped 0 overruns 0
- frame 0
- TX packets 5001880
- ）bytes605578926（577.5 MiB)
- TX6
- errors 0
- ）dropped 0overruns0
- carrier 0
- collisions 0
- lo: flagS=73<UP,LOOPBACK,RUNNING>
- mtu 65536
- inet 127.0.0.11
- netmask 255.0.0.0
- loop
- txqueuelen 1000
- ）(Local Loopback)
- RX packets 0 bytes 0 (0.0 B)
- RX
- dropped0
- )overruns
- 50
- TX errors 0
- 0droppedooverruns@
<!-- OCR_END -->

### **去头去尾法**

交给管道符，一次去头，一次去尾

```plain
思路：
1.首先取出第二行
[root@pylinux ~]# ifconfig | sed -n '2p'
        inet 10.141.32.137  netmask 255.255.192.0  broadcast 10.141.63.255
2.找到第二行后，去掉ip之前的内容 
[root@pylinux ~]# ifconfig eth0|sed -n '2s#^.*inet##gp'
 10.141.32.137  netmask 255.255.192.0  broadcast 10.141.63.255
 解释： 
 -n是取消默认输出  
 2s是处理第二行内容
 #^.*inet##  是匹配inet前所有的内容
 gp代表全局替换且打印替换结果
3.再次处理，去掉ip后面的内容
[root@pylinux tmp]# sed -n '2s/^.*inet//gp' ip.txt | sed -n 's/net.*$//gp'
 10.141.32.137
 解释：
 net.*$  匹配net到结尾的内容
 s/net.*$//gp   #把匹配到的内容替换为空
```

### **-e参数多次编辑**

```plain
[root@pylinux tmp]# ifconfig eth0  | sed -ne '2s/^.*inet//g'  -e '2s/net.*$//gp'
 10.141.32.137
```

<!-- OCR_START -->
[root@pylinux tmp]# ifconfig eth0
I sed -ne'2s/^.*inet//g'
-e '2s/net.*$//gp
10.141.32.137
[root@pylinux tmp]#
第一次处理
去掉第二行ip 之前的信息
对文件第二次编辑
不打印
去掉第二行p之后的信息
且打印最终结果
[root@pylinux tmp]# ifconfig
etho
eth0:flagS=4163<UP,BROADCAST,RUNNING,MULTICAST>mtu 1500
inet 10.141.32.137 netmask 255.255.192.0 broadcast 10.141.
ether 52:54:00:4f:
txqueuelen 1000 (Ethernet)
RX packets 3966141
vyces 448278800 (427.5 MiB)
RXerrors0dropped0overruns0frame0
TX packets 5008162bytes 606448585(578.3 MiB)
TX errors 0dropped 0 overruns 0
）carrier0
collisions 0
<!-- OCR_END -->

# Linux三剑客awk

awk是一个强大的linux命令，有强大的文本格式化的能力，好比将一些文本数据格式化成专业的excel表的样式

awk早期在Unix上实现，我们用的awk是gawk，是GUN awk的意思

<!-- OCR_START -->
[root@pylinux tmp]# ll /usr/bin/awk
Lrwxrwxrwx. 1 root root 4 8月
82018/usr/bin/awk
->
gawk
<!-- OCR_END -->

awk更是是一门编程语言，支持条件判断、数组、循环等功能

## 再谈三剑客

* grep，擅长单纯的查找或匹配文本内容
* sed，更适合编辑、处理匹配到的文本内容
* awk，更适合格式化文本内容，对文本进行复杂处理

三个命令称之为Linux的三剑客

## awk基础

awk语法

```plain
awk [option] 'pattern[action]'  file ...
awk 参数   '条件动作'  文件
```

<!-- OCR_START -->
- awk可选参数
- 模式
- 动作
- 文件/数据
- awk
- options
- {action}
- file
- pattern
<!-- OCR_END -->

* Action指的是动作，awk擅长文本格式化，且输出格式化后的结果，因此最常用的动作就是`print`和`printf`

### awk场景

动作场景

<!-- OCR_START -->
[root@pylinux
tmp]#
2
alex1 alex2 alex3 alex4 alex5
alex6 alex7 alex8 alex9 alex10
alex11 alex12 alex13 alex14 alex15
alex16 alex17 alex18 alex19 alex20
alex21 alex22 alex23 alex24 alex25
alex26 alex27 alex28 alex29 alex30
alex31 alex32 alex33 alex34 alex35
alex36 alex37 alex38 alex39 alex40
alex41 alex42 alex43 alex44 alex45
alex46 alex47 alex48 alex49 alex50
[root@pylinux tmp]#
# cat alex.txt lawk '{print $2}
alex2
取出了第二列
alex7
alex12
alex17
alex22
alex27
alex32
alex37
alex42
alex47
<!-- OCR_END -->

```plain
[root@pylinux tmp]# cat alex.txt
alex1 alex2 alex3 alex4 alex5
alex6 alex7 alex8 alex9 alex10
alex11 alex12 alex13 alex14 alex15
alex16 alex17 alex18 alex19 alex20
alex21 alex22 alex23 alex24 alex25
alex26 alex27 alex28 alex29 alex30
alex31 alex32 alex33 alex34 alex35
alex36 alex37 alex38 alex39 alex40
alex41 alex42 alex43 alex44 alex45
alex46 alex47 alex48 alex49 alex50
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# cat alex.txt |awk '{print $2}'
alex2
alex7
alex12
alex17
alex22
alex27
alex32
alex37
alex42
alex47
```

我们执行的命令是`awk '{print $2}'`，没有使用参数和模式，`$2`表示输出文本的`第二列`信息

awk默认以空格为分隔符，且多个空格也识别为一个空格，作为分隔符

awk是按行处理文件，一行处理完毕，处理下一行，根据用户指定的分割符去工作，没有指定则默认空格

```plain
指定了分隔符后，awk把每一行切割后的数据对应到内置变量
```

<!-- OCR_START -->
- 文本
- $0完整输入
- $1
- $2
- $3
<!-- OCR_END -->

* $0表示整行
* $NF表示当前分割后的最后一列
* 倒数第二列可以写成$(NF-1)

### awk内置变量

| 内置变量 | 解释 |
| --- | --- |
| $n | 指定分隔符后，当前记录的第n个字段 |
| $0 | 完整的输入记录 |
| FS | 字段分隔符，默认是空格 |
| NF(Number of fields) | 分割后，当前行一共有多少个字段 |
| NR(Number of records) | 当前记录数，行数 |
| 更多内置变量可以man手册查看 | man awk |

### *一次性输出多列*

```plain
[root@pylinux tmp]# awk '{print $1,$2}' alex.txt
alex1 alex2
alex6 alex7
alex11 alex12
alex16 alex17
alex21 alex22
alex26 alex27
alex31 alex32
alex36 alex37
alex41 alex42
alex46 alex47
```

<!-- OCR_START -->
[root@pylinux tmp]#
cat -n(
alex.txt
awk会自动分割成5列
4
5）
1
③
alex1 alex2 alex3 alex4 alex5
2
alex6 alex7 alex8 alex9 alex10
3
alex11 alex12 alex13 alex14 alex15
alex16 alex17 alex18 alex19 alex20
alex21 alex22 alex23 alex24 alex25
6
alex26 alex27 alex28 alex29 alex30
7
alex31 alex32 alex33 alex34 alex35
8
alex36 alex37 alex38 alex39 alex40
9
alex41 alex42 alex43 alex44 alex45
10
alex46 alex47 alex48 alex49 alex50
[root@pylinux tmp]# awk '{print $4,$1}' alex.txt
alex4 alex1
格式化文本内容
alex9 alex6
输出第四列，第一列
alex14 alex11
alex19 alex16
alex24 alex21
alex29 alex26
alex34 alex31
alex39 alex36
alex44 alex41
alex49 alex46
<!-- OCR_END -->

### *自动定义输出内容*

awk，必须`外层单引号`，`内层双引号`

内置变量`$1、$2`都不得添加双引号，否则会识别为文本，尽量别加引号

<!-- OCR_START -->
root@pylinux tmpl# cat -n alex.txt
1
alex1 alex2 alex3 alex4 alex5
2
alex6 alex7 alex8 alex9 alex10
3
alex11 alex12 alex13 alex14 alex15
4
alex16 alex17 alex18 alex19 alex20
5
alex21 alex22 alex23 alex24 alex25
6
alex26 alex27 alex28 alex29 alex30
7
alex31 alex32 alex33 alex34 alex35
8
alex36alex37 alex38 alex39alex40
9
alex41 alex42 alex43 alex44 alex45
10
alex46 alex47 alex48 alex49 alex50
[root@pylinux tmp]# awk ‘{print "第一列",$1,'
"第二列"，$2，"第三列",$3}’alex.txt
第一列alex1第二列alex2第三列alex3
第一列alex6 第二列alex7第三列alex8
awk强大的格式化，自定义字段
第一列alex11 第二列alex12 第三列alex13
文本格式化输出
一列alex16 第二列alex17 第三列alex18
一列
alex21第二列
」alex22第三列alex23
alex26
第二列
alex27第三列（
alex28
alex31第二列
」alex32第三列alex33
第一列alex36 第二列alex37 第三列alex38
第一列alex41第二列alex42第三列alex43
第一列alex46第二列alex47第三列alex48
<!-- OCR_END -->

```plain
[root@pylinux tmp]# awk '{print "第一列",$1,"第二列",$2,"第三列",$3}' alex.txt
第一列 alex1 第二列 alex2 第三列 alex3
第一列 alex6 第二列 alex7 第三列 alex8
第一列 alex11 第二列 alex12 第三列 alex13
第一列 alex16 第二列 alex17 第三列 alex18
第一列 alex21 第二列 alex22 第三列 alex23
第一列 alex26 第二列 alex27 第三列 alex28
第一列 alex31 第二列 alex32 第三列 alex33
第一列 alex36 第二列 alex37 第三列 alex38
第一列 alex41 第二列 alex42 第三列 alex43
第一列 alex46 第二列 alex47 第三列 alex48
```

### 输出整行信息

```plain
[root@pylinux tmp]# awk '{print}' alex.txt        #两种写法都可以
[root@pylinux tmp]# awk '{print $0}' alex.txt
```

### awk参数

| 参数 | 解释 |
| --- | --- |
| -F | 指定分割字段符 |
| -v | 定义或修改一个awk内部的变量 |
| -f | 从脚本文件中读取awk命令 |

## awk案例

测试文件内容

```plain
[root@pylinux tmp]# cat pwd.txt  -n
     1    sync:x:5:0:sync:/sbin:/bin/sync
     2    shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     3    halt:x:7:0:halt:/sbin:/sbin/halt
     4    mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
     5    operator:x:11:0:operator:/root:/sbin/nologin
     6    games:x:12:100:games:/usr/games:/sbin/nologin
     7    ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
     8    nobody:x:99:99:Nobody:/:/sbin/nologin
     9    systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
    10    dbus:x:81:81:System message bus:/:/sbin/nologin
    11    polkitd:x:999:998:User for polkitd:/:/sbin/nologin
    12    libstoragemgmt:x:998:997:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin
    13    rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
    14    ntp:x:38:38::/etc/ntp:/sbin/nologin
```

### 显示文件第五行

```plain
#NR在awk中表示行号，NR==5表示行号是5的那一行
#注意一个等于号，是修改变量值的意思，两个等于号是关系运算符，是"等于"的意思
[root@pylinux tmp]# awk 'NR==5' pwd.txt
operator:x:11:0:operator:/root:/sbin/nologin
```

### 显示文件2-5行

设置模式（条件）

```plain
#告诉awk，我要看行号2到5的内容
[root@pylinux tmp]# awk 'NR==2,NR==5' pwd.txt
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
```

### 给每一行的内容添加行号

添加变量，NR等于行号，$0表示一整行的内容

{print }是awk的动作

```plain
[root@pylinux tmp]# awk  '{print NR,$0}'  alex.txt
1 alex1 alex2 alex3 alex4 alex5
2 alex6 alex7 alex8 alex9 alex10
3 alex11 alex12 alex13 alex14 alex15
4 alex16 alex17 alex18 alex19 alex20
5 alex21 alex22 alex23 alex24 alex25
6 alex26 alex27 alex28 alex29 alex30
7 alex31 alex32 alex33 alex34 alex35
8 alex36 alex37 alex38 alex39 alex40
9 alex41 alex42 alex43 alex44 alex45
10 alex46 alex47 alex48 alex49 alex50  alex51
```

### 显示文件3-5行且输出行号

```plain
[root@pylinux tmp]# awk 'NR==3,NR==5  {print NR,$0}' alex.txt
3 alex11 alex12 alex13 alex14 alex15
4 alex16 alex17 alex18 alex19 alex20
5 alex21 alex22 alex23 alex24 alex25
```

### 显示pwd.txt文件的第一列，倒数第二和最后一列

```plain
[root@pylinux tmp]# cat pwd.txt -n
     1    sync:x:5:0:sync:/sbin:/bin/sync
     2    shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     3    halt:x:7:0:halt:/sbin:/sbin/halt
     4    mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
     5    operator:x:11:0:operator:/root:/sbin/nologin
     6    games:x:12:100:games:/usr/games:/sbin/nologin
     7    ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
     8    nobody:x:99:99:Nobody:/:/sbin/nologin
     9    systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
    10    dbus:x:81:81:System message bus:/:/sbin/nologin
    11    polkitd:x:999:998:User for polkitd:/:/sbin/nologin
    12    libstoragemgmt:x:998:997:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin
    13    rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
    14    ntp:x:38:38::/etc/ntp:/sbin/nologin
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# awk -F ':' '{print $1,$(NF-1),$NF}' pwd.txt
sync /sbin /bin/sync
shutdown /sbin /sbin/shutdown
halt /sbin /sbin/halt
mail /var/spool/mail /sbin/nologin
operator /root /sbin/nologin
games /usr/games /sbin/nologin
ftp /var/ftp /sbin/nologin
nobody / /sbin/nologin
systemd-network / /sbin/nologin
dbus / /sbin/nologin
polkitd / /sbin/nologin
libstoragemgmt /var/run/lsm /sbin/nologin
rpc /var/lib/rpcbind /sbin/nologin
ntp /etc/ntp /sbin/nologin
```

<!-- OCR_START -->
1
sync:x:5:0:sync:/sbin:/bin/sync
2
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
3
halt:x:7:0:halt:/sbin:/sbin/halt
4
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
5
operator:x:11:0:operator:/root:/sbin/nologin
6
games:x:12:100:games:/usr/games:/sbin/nologin
7
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
8
nobody:x:99:99:Nobody:/:/sbin/nologin
9
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
10
dbus:x:81:81:System message bus:/:/sbin/nologin
11
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
12
libstoragemgmt:x:998:997:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin
13
rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
14 ntp:x:38:38::/etc/ntp:/sbin/nologin
[root@pylinux tmp]#
awk指定分隔符的参数-F指定以：冒号为分隔符
[root@pylinux tmp]# awk -F ':''{print $1,$(NF-1),$NF}' pwd.txt
sync /sbin /bin/sync
shutdown /sbin /sbin/shutdown
$1第一列
halt /sbin /sbin/halt
mail /var/spool/mail /sbin/nologin
NF表示每一行总字段数
operator /root /sbin/nologin
games /usr/games /sbin/nologin
$(NF-1）倒数第二
ftp/var/ftp/sbin/nologin
nobody/ /sbin/nologin
$(NF）最后一列
systemd-network / /sbin/nologin
dbus / /sbin/nologin
polkitd / /sbin/nologin
libstoragemgmt /var/run/lsm /sbin/nologin
rpc /var/lib/rpcbind /sbin/nologin
ntp/etc/ntp/sbin/nologin
<!-- OCR_END -->

## awk分隔符

<!-- OCR_START -->
[root@pylinux tmp]# cat pwd.txt
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
冒号分割符
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
libstoragemgmt:x:998:997:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin
rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
[root@pylinux tmp]#
root@pylinux tmpl# cat alex.txt
alex1 alex2 alex3 alex4 alex5
alex6 alex7 alex8 alex9 alex10
alex11 alex12 alex13 alex14 alex15
空格分隔符
alex16 alex17 alex18 alex19 alex20
alex21 alex22 alex23 alex24 alex25
alex26 alex27 alex28 alex29 alex30
alex31 alex32 alex33 alex34 alex35
alex36 alex37 alex38 alex39 alex40
alex41 alex42 alex43 alex44 alex45
alex46 alex47 alex48 alex49 alex50
alex51
<!-- OCR_END -->

awk的分隔符有两种

* 输入分隔符，awk默认是空格，空白字符，英文是field separator，变量名是FS
* 输出分隔符，output field separator，简称OFS

## FS输入分隔符

awk逐行处理文本的时候，以输入分割符为准，把文本切成多个片段，默认符号是空格

当我们处理特殊文件，没有空格的时候，可以自由指定分隔符特点

```plain
[root@pylinux tmp]# awk -F '#' '{print $1}' chaoge.txt
超哥c
超哥f
超哥i
超哥l
超哥o
超哥r
超哥u
超哥x
```

<!-- OCR_START -->
- [root@pylinux tmp]# cat chaoge.txt
- 超哥c#超哥d#超哥e
- 超哥f#超哥g#超哥h
- 超哥i#超哥#超哥k
- 超哥1#超哥m#超哥n
- 超哥o#超哥p#超哥q
- 超哥r#超哥s#超哥t
- 超哥u#超哥v#超哥w
- 超哥x#超哥y#超哥z
- [root@pylinux tmp]# awk -F '#’'{print $1}' chaoge.txt
- 超哥c
- 超哥f
- 指定以#号为分隔符
- 超哥
- 超哥1
- 超哥o
- 超哥r
- 超哥u
- 超哥x
<!-- OCR_END -->

* 除了使用-F选项，还可以使用变量的形式，指定分隔符，使用-v选项搭配，修改FS变量

```plain
[root@pylinux tmp]# awk -v FS='#' '{print $1}' chaoge.txt
超哥c
超哥f
超哥i
超哥l
超哥o
超哥r
超哥u
超哥x
```

### OFS输出分割符

awk执行完命令，默认用空格隔开每一列，这个空格就是awk的默认输出符，例如

```plain
[root@pylinux tmp]# cat chaoge.txt
超哥c#超哥d#超哥e
超哥f#超哥g#超哥h
超哥i#超哥j#超哥k
超哥l#超哥m#超哥n
超哥o#超哥p#超哥q
超哥r#超哥s#超哥t
超哥u#超哥v#超哥w
超哥x#超哥y#超哥z
[root@pylinux tmp]# awk -v FS='#' '{print $1,$3}' chaoge.txt
超哥c 超哥e
超哥f 超哥h
超哥i 超哥k
超哥l 超哥n
超哥o 超哥q
超哥r 超哥t
超哥u 超哥w
超哥x 超哥z
```

<!-- OCR_START -->
- [root@pylinux tmp]#catchaoge.txt
- 超哥c#超哥d#超哥e
- 超哥f#超哥g#超哥h
- 超哥i#超哥j#超哥k
- 超哥1#超哥m#超哥n
- 超哥o#超哥p#超哥q
- 超哥r#超哥s#超哥t
- 超哥u#超哥v#超哥w
- 超哥x#超哥y#超哥z
- [root@pylinuxtmp]#awk-vFS='#`'{print$1,$3}'chaoge.txt
- 超哥c超哥e
- 超哥f超哥h
- 打印输出
- 超哥i超哥k
- 第一列
- 超哥l超哥n
- 第三列
- 超哥o超哥q
- 中间是空格
- 超哥r超哥t
- 超哥u超哥w
- 超哥x超哥z
<!-- OCR_END -->

通过OFS设置输出分割符，记住修改变量必须搭配选项 -v

```plain
[root@pylinux tmp]# cat chaoge.txt
超哥c#超哥d#超哥e
超哥f#超哥g#超哥h
超哥i#超哥j#超哥k
超哥l#超哥m#超哥n
超哥o#超哥p#超哥q
超哥r#超哥s#超哥t
超哥u#超哥v#超哥w
超哥x#超哥y#超哥z
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# awk -v FS='#' -v OFS='---' '{print $1,$3 }' chaoge.txt
超哥c---超哥e
超哥f---超哥h
超哥i---超哥k
超哥l---超哥n
超哥o---超哥q
超哥r---超哥t
超哥u---超哥w
超哥x---超哥z
[root@pylinux tmp]#
```

<!-- OCR_START -->
- [root@pylinux tmp]# cat chaoge.txt
- 超哥c#超哥d#超哥e
- 超哥f#超哥g#超哥h
- 超哥i#超哥j#超哥k
- 此时这个文本特点是，没有空格
- 超哥1#超哥m#超哥n
- 中间以#分割
- 超哥o#超哥p#超哥q
- 超哥r#超哥s#超哥t
- 超哥u#超哥v#超哥w
- 超哥x#超哥y#超哥z
- [root@pylinux tmp]#
- 指定输入分割符
- [root@pylinux tmp]# awk -v FS='#’-v OFS='---'
- '{print $1,$3 }'chaoge.txt
- 超哥c---超哥e
- 超哥f---超哥h
- 指定输出分割符
- 超哥i---超哥k
- 超哥l---超哥n
- 因此针对#分割后，打印第一列、第三列结果
- 超哥o---超哥q
- 超哥r---超哥t
- 中间的输出分隔符，
- 被我改成了，
- 超哥u---超哥w
- 超哥x---超哥z
<!-- OCR_END -->

### 输出分隔符与逗号

awk是否存在输出分隔符，特点在于`'{print $1,$3 } 逗号`的区别

* 添加逗号，默认是空格分隔符

```plain
[root@pylinux tmp]# awk -v FS='#'  '{print $1,$3 }' chaoge.txt
超哥c 超哥e
超哥f 超哥h
超哥i 超哥k
超哥l 超哥n
超哥o 超哥q
超哥r 超哥t
超哥u 超哥w
超哥x 超哥z
```

* 不加逗号

```plain
[root@pylinux tmp]# awk -v FS='#'  '{print $1$3 }' chaoge.txt
超哥c超哥e
超哥f超哥h
超哥i超哥k
超哥l超哥n
超哥o超哥q
超哥r超哥t
超哥u超哥w
超哥x超哥z
```

* 修改分割符，改为\t(制表符，四个空格)或者任意字符

```plain
[root@pylinux tmp]# awk -v FS='#' -v OFS='\t\t' '{print $1,$3 }' chaoge.txt
超哥c        超哥e
超哥f        超哥h
超哥i        超哥k
超哥l        超哥n
超哥o        超哥q
超哥r        超哥t
超哥u        超哥w
超哥x        超哥z
```

## awk变量

### awk参数

| 参数 | 解释 |
| --- | --- |
| -F | 指定分割字段符 |
| -v | 定义或修改一个awk内部的变量 |
| -f | 从脚本文件中读取awk命令 |

对于awk而言，变量分为

* 内置变量
* 自定义变量

| 内置变量 | 解释 |
| --- | --- |
| FS | 输入字段分隔符， 默认为空白字符 |
| OFS | 输出字段分隔符， 默认为空白字符 |
| RS | 输入记录分隔符(输入换行符)， 指定输入时的换行符 |
| ORS | 输出记录分隔符（输出换行符），输出时用指定符号代替换行符 |
| NF | NF：number of Field，当前行的字段的个数(即当前行被分割成了几列)，字段数量 |
| NR | NR：行号，当前处理的文本行的行号。 |
| FNR | FNR：各文件分别计数的行号 |
| FILENAME | FILENAME：当前文件名 |
| ARGC | ARGC：命令行参数的个数 |
| ARGV | ARGV：数组，保存的是命令行所给定的各参数 |

## 内置变量

### NR，NF、FNR

* awk的内置变量NR、NF是不用添加$符号的
* 而`$0 $1 $2 $3 ... 是需要添加$符号的`

*输出每行行号，以及字段总个数*

```plain
[root@pylinux tmp]# cat -n alex.txt
     1    alex1 alex2 alex3 alex4 alex5
     2    alex6 alex7 alex8 alex9 alex10
     3    alex11 alex12 alex13 alex14 alex15
     4    alex16 alex17 alex18 alex19 alex20
     5    alex21 alex22 alex23 alex24 alex25
     6    alex26 alex27 alex28 alex29 alex30
     7    alex31 alex32 alex33 alex34 alex35
     8    alex36 alex37 alex38 alex39 alex40
     9    alex41 alex42 alex43 alex44 alex45
    10    alex46 alex47 alex48 alex49 alex50  alex51
[root@pylinux tmp]#
[root@pylinux tmp]# awk '{print NR,NF}' alex.txt
1 5
2 5
3 5
4 5
5 5
6 5
7 5
8 5
9 5
10 6
```

*输出每行行号，以及指定的列*

```plain
[root@pylinux tmp]# awk '{print NR,$1,$5}' alex.txt
1 alex1 alex5
2 alex6 alex10
3 alex11 alex15
4 alex16 alex20
5 alex21 alex25
6 alex26 alex30
7 alex31 alex35
8 alex36 alex40
9 alex41 alex45
10 alex46 alex50
```

### 处理多个文件显示行号

```plain
#  普通的NR变量，会将多个文件按照顺序排序
[root@pylinux tmp]# awk '{print NR,$0}' alex.txt  pwd.txt
```

```plain
#使用FNR变量，可以分别对文件行数计数
[root@pylinux tmp]# awk '{print FNR,$0}' alex.txt  pwd.txt
```

### 内置变量RS

RS变量作用是`输入分隔符`，默认是`回车符`，也就是`回车(Enter键)换行符`

我们也可以自定义`空格`作为`行分隔符`，每遇见一个空格，就换行处理

<!-- OCR_START -->
- [root@pylinux tmp]#cat -n chaoge.txt
- 超哥1超哥2超哥3
- 我们默认理解的是，按下回车，进入下一行
- 2
- 超哥4超哥5超哥6
- 3
- 超哥7超哥8超哥9
- 4
- 超哥10超哥11超哥12
- 5
- 超哥13超哥14超哥15
- 6
- 超哥16超哥17超哥18
- 7
- 超哥19超哥20
- [root@pylinux tmp]#
- [root@pylinux tmp]# awk -v RS=' ' '{print NR,$o}' chaoge.txt
- 1超哥1
- RS代表awk的输入分隔符
- 2超哥2
- 3超哥3
- 修改了RS的值是'代表有一个空格
- 超哥4
- 4超哥5
- awk以后遇见?空格就换行处理
- 超哥6
- 超哥7
- 因此行号显示以空格作为换行了
- 6超哥8
- 超哥9
- 超哥10
- 我们发现有几个这样的特殊的
- 超哥12
- 超哥13
- 是因为awk认为空格是分隔符
- 10
- 超哥
- 11超哥15
- 超哥12后面没有空格了，因此和超哥13算成了同一行
- 超哥16
- 12超哥17
- 13超哥18
- 超哥19
- 14超哥20
<!-- OCR_END -->

```plain
[root@pylinux tmp]# awk -v RS=' ' '{print NR,$0}' chaoge.txt
```

### 内置变量ORS

ORS是输出分隔符的意思，awk默认认为，每一行结束了，就得添加`回车换行符`

ORS变量可以更改输出符

```plain
awk -v ORS='@@@' '{print NR,$0}' chaoge.txt
```

<!-- OCR_START -->
- [root@pylinux tmp]# cat -n chaoge.txt
- 超哥1超哥2超哥3
- 2
- 超哥4超哥5超哥6
- 3
- 超哥7超哥8超哥9
- 4
- 超哥10超哥11超哥12
- chaoge.txt文本默认的内容
- 5
- 超哥13超哥14超哥15
- cat-n显示了行号
- 6
- 超哥16超哥17超哥18
- 7
- 超哥19超哥20
- [root@pylinux tmp]#
- [root@pylinux tmp]#awk'{print NR,$o}'chaoge.txt
- 2超哥4超哥5超哥6
- awk默认也是每一行以换行符结束
- 3超哥7超哥8超哥9
- 4超哥10超哥11超哥12
- 显示和cat-n一样
- 5超哥13超哥14超哥15
- 6超哥16超哥17超哥18
- 7超哥19超哥20
- 我们修改了每一行的结束符号，改为了@@@，因此没有换行输出
- 而是在每一行结尾添加了@@@
- awk -v ORS='@@@''{print NR,$o}'chaoge.txt
- 1
- 超哥1超哥2超哥3@@@2超哥4超哥5超哥6@@@3超哥7超哥8超哥9@@@4超哥10超哥11超哥12
- @@@5超哥13超哥14超哥15@@@6超哥16超哥17超哥18@@@7超哥19超哥20@@@[root@pylinuxtmp
<!-- OCR_END -->

### 内置变量FILENAME

显示awk正在处理文件的名字

```plain
[root@pylinux tmp]# awk '{print FILENAME,FNR,$0}' chaoge.txt   alex.txt
chaoge.txt 1 超哥a 超哥b
chaoge.txt 2 超哥c 超哥d 超哥e
chaoge.txt 3 超哥f 超哥g 超哥h
chaoge.txt 4 超哥i 超哥j 超哥k
chaoge.txt 5 超哥l 超哥m 超哥n
chaoge.txt 6 超哥o 超哥p 超哥q
chaoge.txt 7 超哥r 超哥s 超哥t
chaoge.txt 8 超哥u 超哥v 超哥w
chaoge.txt 9 超哥x 超哥y 超哥z
alex.txt 1 alex1 alex2 alex3 alex4 alex5
alex.txt 2 alex6 alex7 alex8 alex9 alex10
alex.txt 3 alex11 alex12 alex13 alex14 alex15
alex.txt 4 alex16 alex17 alex18 alex19 alex20
```

### 变量ARGC、ARGV

ARGV表示的是一个数组，数组中保存的是命令行所给的`参数`

数组是一种数据类型，如同一个盒子

盒子有它的名字，且内部有N个小格子，标号从0开始

给一个盒子起名字叫做months，月份是1~12，那就如图所示

<!-- OCR_START -->
- months
- "January"”
- 1
- "February”
- 2
- “March"
- 3
- "April"
- 4
- "May"
- 5
- "June"
- 6
- “July"
- 7
- "August”
- 8
- "September"
- 9
- "October"
- 10
- "November"
- 11
- "December"
- 12
<!-- OCR_END -->

<!-- OCR_START -->
- [root@pylinux tmp]# awk
- 'BEGIN{print"超哥教你学内置awk变量呢"}
- chaoge.txt
- 超哥教你学内置awk变量呢
- 其实这个命令
- ARGV数组
- [root@pylinux tmp]#
- 给awk设置一个模式 （条件）
- 我们给awk传入了几个参数
- 处理文件前，先打印“超哥教你学内置awk变量呢
- 参数存入了数组变量中ARGV
- 索引0
- awk
- ：‘BEGIN{print"超哥教你学内置awk变量呢"，ARGV[O]}‘
- 打印了索引0的值
- [root@pylinux
- （tmp]#
- 索引1
- ‘BEGIN{print"超哥教你学内置awk变量呢"，ARGV[O]，ARGV[1]}'
- awk chaoge.txt
- 打印了索引0和索引1的值
- 索引2
- alex.txt
- [root@pyLinuxtmp]#awk‘BEGIN{print"超哥教你学内置awk变量呢",ARGV[O],ARGV[1],ARGV[2]}‘
- 超哥教你学内置awk变量呢awkchaoge.txtalex.txt
- 打印了索引0、1、2的值
<!-- OCR_END -->

```plain
[root@pylinux tmp]# awk 'BEGIN{print "超哥教你学内置awk变量呢"}'  chaoge.txt
超哥教你学内置awk变量呢
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# awk 'BEGIN{print "超哥教你学内置awk变量呢",ARGV[0]}'  chaoge.txt
超哥教你学内置awk变量呢 awk
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# awk 'BEGIN{print "超哥教你学内置awk变量呢",ARGV[0],ARGV[1]}'  chaoge.txt
超哥教你学内置awk变量呢 awk chaoge.txt
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# awk 'BEGIN{print "超哥教你学内置awk变量呢",ARGV[0],ARGV[1],ARGV[2]}'  chaoge.txt   alex.txt
超哥教你学内置awk变量呢 awk chaoge.txt alex.txt
```

### 自定义变量

顾名思义，是我们自己定义变量

* 方法一，`-v varName=value`
* 方法二，在程序中直接定义

方法一：

```plain
[root@pylinux tmp]# awk -v luffyVarName="超哥nb，awk讲的好啊"  'BEGIN{print luffyVarName}' chaoge.txt
超哥nb，awk讲的好啊
```

<!-- OCR_START -->
- [root@pylinux tmp]# awk-vluffyVarName="超哥nb，awk讲的好啊"
- 'BEGIN{printluffyVarName}'
- chaoge.txt
- 超哥nb，awk讲的好啊
- 自定义变量与赋值
- [root@pylinux tmp]#
- 定义模式 (条件)
- 打印变量
- 'BEGIN{print luffyVarName}{print $0}'chaoge.txt
- 超哥a超哥b
- 打印变量值
- 且处理文件内容
- 超哥c超哥d超哥e
- 超哥f超哥g超哥h
- 超哥i超哥j
- 超哥k
- 超哥l超哥m超哥n
- 超哥o超哥p超哥q
- 超哥r超哥s超哥t
- 超哥u超哥v超哥w
- 超哥x超哥y超哥z
<!-- OCR_END -->

方法二：

```plain
[root@pylinux tmp]# awk 'BEGIN{chaogeVar="超哥带你学linux，还怕学不会咋的";chaogeVar2="学的会，必须学得会" ;print chaogeVar,chaogeVar2}'
超哥带你学linux，还怕学不会咋的 学的会，必须学得会
```

<!-- OCR_START -->
- [root@pylinux tmp]# awk
- 'BEGIN{chaogeVar="超哥带你学linux，还怕学不会咋的"；chaogeVar2="学的会，必须学得会’
- ;printchaogeVar,chaogeVar2}
- 超哥带你学linux，还怕学不会咋的学的会，必须学得会
- 定义变量1
- 定义变量2
- [root@pylinux tmp]#
- 打印变量值
<!-- OCR_END -->

方法三：间接引用shell变量

```plain
[root@pylinux tmp]# studyLinux="超哥讲的linux是真滴好，嘿嘿"
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# awk -v myVar=$studyLinux 'BEGIN{print myVar}'    # -v是给awk定义变量
超哥讲的linux是真滴好，嘿嘿
```

# awk格式化

前面我们接触到的awk的输出功能，是{print}的功能，只能对文本简单的输出，并不能`美化`或者`修改格式`

# printf格式化输出

如果你学过C语言或是go语言，一定见识过printf()函数，能够对文本格式化输出

## printf和print的区别

```plain
format的使用
要点：
1、其与print命令的最大不同是，printf需要指定format；
2、format用于指定后面的每个item的输出格式；
3、printf语句不会自动打印换行符；\\n
format格式的指示符都以%开头，后跟一个字符；如下：
%c: 显示字符的ASCII码；
%d, %i：十进制整数；
%e, %E：科学计数法显示数值；
%f: 显示浮点数；
%g, %G: 以科学计数法的格式或浮点数的格式显示数值；
%s: 显示字符串；
%u: 无符号整数；
%%: 显示%自身；
printf修饰符：
-: 左对齐；默认右对齐,
+：显示数值符号；  printf "%+d"
```

* printf动作默认不会添加换行符
* print默认添加空格换行符

```plain
[root@pylinux tmp]# awk '{print $1}' 超哥nb.txt
超哥nb1
超哥nb4
超哥nb7
超哥nb10
[root@pylinux tmp]# awk '{print $1}' 超哥nb.txt
超哥nb1
超哥nb4
超哥nb7
超哥nb10
[root@pylinux tmp]#
[root@pylinux tmp]# awk '{printf $1}' 超哥nb.txt
超哥nb1超哥nb4超哥nb7超哥nb10[root@pylinux tmp]#
```

### 给printf添加格式

* 格式化字符串 %s 代表字符串的意思

```plain
[root@pylinux tmp]# awk '{printf "%s\n",$1}' 超哥nb.txt
超哥nb1
超哥nb4
超哥nb7
超哥nb10
```

<!-- OCR_START -->
- 超哥nb7--
- 超哥nb10--
- [root@pylinuxtmp]#awk'{printf"%s\n"，$1}’超哥nb.txt
- 超哥nb1
- 超哥nb4
- printf用"%s\n"对$1进行格式化
- %s显示字符串
- In换行符
<!-- OCR_END -->

### 对多个变量进行格式化

当我们使用linux命令printf时，是这样的，一个`%s格式替换符`，可以对多个参数进行重复格式化

```plain
[root@pylinux tmp]# printf  "%s\n"  a b c d
a
b
c
d
```

然而awk的`格式替换符`想要修改多个变量，必须传入多个

```plain
[root@pylinux tmp]# awk 'BEGIN{printf "%d\n%d\n%d\n%d\n%d\n",1,2,3,4,5}'
1
2
3
4
5
```

<!-- OCR_START -->
| 名称 | 排名 |
| --- | --- |
| 'BEGIN{printf | "%d\n%d\n%d\n%d\n%d\n",1,2,3,4,5} |
| 一 | 2 |
| 注意aWk不跟上文件数据，必须添加BEGIN | 3 |
<!-- OCR_END -->

* printf对输出的文本不会换行，必须添加对应的`格式替换符`和`\n`
* 使用printf动作，`'{printf "%s\n",$1}'`，替换的格式和变量之间得有逗号`,`
* 使用printf动作，`%s %d 等格式化替换符` 必须 和`被格式化的数据`一一对应

### printf案例

```plain
[root@pylinux tmp]# cat  超哥nb.txt
超哥nb1 超哥nb2 超哥nb3
超哥nb4 超哥nb5 超哥nb6
超哥nb7 超哥nb8 超哥nb9
超哥nb10
[root@pylinux tmp]# awk '{printf "第一列：%s  第二列：%s  第三列：%s\n",$1,$2,$3}' 超哥nb.txt
第一列：超哥nb1  第二列：超哥nb2  第三列：超哥nb3
第一列：超哥nb4  第二列：超哥nb5  第三列：超哥nb6
第一列：超哥nb7  第二列：超哥nb8  第三列：超哥nb9
第一列：超哥nb10  第二列：  第三列：
```

<!-- OCR_START -->
- [root@pylinuxtmp]#cat
- 超哥nb.txt
- 超哥nb1超哥nb2超哥nb3
- 超哥nb4超哥nb5超哥nb6
- 超哥nb7超哥nb8超哥nb9
- 超哥nb10
- [root@pylinux tmp]#
- 添加自定义的格式，然后通过格式替换符格式化输出
- [root@pylinuxtmp]#awk‘{printf"第一列：%s第二列：%s第三列：%s\n"，$1,$2,$3}’超哥nb.txt
- 第一列：超哥nb1第二列：超哥nb2第三列：超哥nb3
- 第一列：超哥nb4第二列：超哥nb5
- 第三列：超哥nb6
- 第一列：超哥nb7第二列：超哥nb8第三列：超哥nb9
- 像不像Excel数据
- 第一列：超哥nb10第二列：
- 第三列：
<!-- OCR_END -->

* awk通过空格切割文档
* printf动作对数据格式化

### 对pwd.txt文件格式化

<!-- OCR_START -->
[roote@pylinux tmp]# cat pwd.txt
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
%s是格式替换符，代表字符串
dbus:x:81:81:Systemmessagebus:/:/sbin/nologin
polkitd:x:999:998:Userfor polkitd:/:/sbin/nologin
%s\t在格式化后，结尾添加制表符\t，四个空格，为了美观
gemgmt:/var/run/lsm:/sbin/nologin
%-25s设置格式化后的字符长度是25
[root@pylinux tmp]#
[rootepylinux tmp]#
BEGIN模式（条件），在处理文本前，格式化打印数据
打印这么一行数据
awk在此处理文本数据，格式化打印每一列的数据
ot@pylinux
tmp#
awk
k-F":"
‘BEGIN{printf“%-25s\t%-25s\t%-25s\t%-25s\t%-25s\t%-25s\t%-25s\n","用户名","密码","UID","GID","用户注释","用户家目录","用户使用的解释器"}{printf“%-25s\t%-25s\t%-25s\t%-25s\t%-25s\t%-25s\t %s\n"
$1,$2,$3,$4,$5,$6,$7}
pwd.txt
用户名
密码
UID
GID
用户注释
用户家目录
用户使用的解释器
shutcdown
567
shutcdon
/sbin
halt
/sbin/halt
mail
8
12
/var/spool/mail
/sbin/nologin
operator
/root
games
/usr/games
FTP User
/var/ftp
Nobody
systemd Network Management
Systemmessage bus
polkitd
User for polkitd
libstoragemgmt
daemon account forlibstoragemgmt
/var/run/lsm
nep
Rpcbind Daemon
/var/lib/rpcbind
/etc/ntp
<!-- OCR_END -->

```plain
awk -F ":" 'BEGIN{printf "%-25s\t %-25s\t %-25s\t %-25s\t %-25s\t %-25s\t %-25s\n","用户名","密码","UID","GID","用户注释","用户家目录","用户使用的解释器"} {printf "%-25s\t %-25s\t %-25s\t %-25s\t %-25s\t %-25s\t %s\n",$1,$2,$3,$4,$5,$6,$7}' pwd.txt
参数解释
'BEGIN{printf "格式替换符 格式替换符2","变量1","变量2"}'  执行BEGIN模式
%s是格式替换符 ，替换字符串
%s\t 格式化字符串后，添加制表符，四个空格
%-25s  已然是格式化字符串， - 代表左对齐  ，25个字符长度
```

# awk模式pattern

再来回顾下awk的语法

```plain
awk [option] 'pattern[action]'  file ...
```

awk是按行处理文本，刚才讲解了`print`动作，现在讲解特殊的`pattern`：`BEGIN`和`END`

* BEGIN模式是处理文本之前需要执行的操作
* END模式是处理完所有行之后执行的操作

```plain
[root@pylinux tmp]# awk 'BEGIN{print "超哥教你学awk"}'
超哥教你学awk
#上述操作没有指定任何文件作为数据源，而是awk首选会执行BEGIN模式指定的print操作，打印出如上结果，然后发现没有任何文件需要操作，就结束了
```

```plain
[root@pylinux tmp]# awk 'BEGIN{print "超哥带你学awk"}{print $1}' alex.txt
超哥带你学awk
alex1
alex6
alex11
alex16
alex21
alex26
alex31
alex36
alex41
alex46
```

<!-- OCR_START -->
- [root@pylinux tmp]#awk'BEGIN{print"超哥带你学awk"}{print $1}’alex.txt
- 超哥带你学awk
- alexl
- 黄色是awk优先执行的BEGIN动作
- alex6
- alex11
- alex16
- alex21
- BEGIN模式动作完成后，再对文件alex.txt处理，打印出第一列
- alex26
- alex31
- alex36
- alex41
- alex46
<!-- OCR_END -->

* 再次总结，BEGIN就是处理文本前，先执行BEGIN模式指定的动作
* 再来看END的作用（awk处理完所有指定的文本后，需要执行的动作）

<!-- OCR_START -->
- root@pylinuxtmp]#awk‘{print$1,$3}END{print"超哥这个awk讲的好啊"}’alex.txt
- alex1alex3
- alex6 alex8
- awk先对文件处理完毕，打印出第一列、第三列
- alex11 alex13
- alex16alex18
- END模式就是处理完所有指定的文本之后，执行的动作
- alex21 alex23
- alex26 alex28
- alex31 alex33
- alex36alex38
- alex41alex43
- alex46alex48
- 超哥这个awk讲的好啊
<!-- OCR_END -->

### awk结合BEGIN和END模式

```plain
[root@pylinux tmp]# awk 'BEGIN{print "来路飞学城听超哥讲linux"}{print $1,$2}END{print "超哥nb"}' alex.txt
```

<!-- OCR_START -->
- [root@pylinuxtmp]#awk
- BEGIN{print"来路飞学城听超哥讲linux"了{print$1，$2}END{print"超哥nb"}
- alex.txt
- 来路飞学城听超哥讲linux1
- BEGIN开始优先指定的动作
- awk处理文件字段
- 最后执行的动作
- alex1alex2
- alex6alex7
- alex11 alex12
- alex16alex17
- alex21 alex22
- alex26alex27
- alex31 alex32
- alex36 alex37
- alex41alex42
- alex46 alex47
- 超哥nb
- 3
<!-- OCR_END -->

## awk模式pattern讲解

再来看一下awk的语法，`模式`也可以理解为是`条件`

```plain
awk [option] 'pattern[action]'  file ...
```

刚才我们学了两个模式(条件)

* BEGIN
* END

**awk默认是按行处理文本，如果不指定任何模式（条件），awk默认一行行处理**

**如果指定了模式，只有符合模式的才会被处理**

### 模式（条件）案例

```plain
[root@pylinux tmp]# cat -n alex.txt
     1    alex1 alex2 alex3 alex4 alex5
     2    alex6 alex7 alex8 alex9 alex10
     3    alex11 alex12 alex13 alex14 alex15
     4    alex16 alex17 alex18 alex19 alex20
     5    alex21 alex22 alex23 alex24 alex25
     6    alex26 alex27 alex28 alex29 alex30
     7    alex31 alex32 alex33 alex34 alex35
     8    alex36 alex37 alex38 alex39 alex40
     9    alex41 alex42 alex43 alex44 alex45
    10    alex46 alex47 alex48 alex49 alex50  alex51
[root@pylinux tmp]#
[root@pylinux tmp]#
[root@pylinux tmp]# awk 'NF==5 {print $1}'  alex.txt
alex1
alex6
alex11
alex16
alex21
alex26
alex31
alex36
alex41
[root@pylinux tmp]# awk 'NF==6 {print $1}'  alex.txt
alex46
```

<!-- OCR_START -->
[root@pylinux tmp]# cat -n alex.txt
alex1 alex2 alex3 alex4 alex5
2
alex6 alex7 alex8 alex9 alex10
3
alex11 alex12 alex13 alex14 alex15
4
alex16 alex17 alex18 alex19 alex20
源文本数据
5
alex21 alex22 alex23 alex24 alex25
6
alex26 alex27 alex28 alex29 alex30
7
alex31 alex32 alex33 alex34 alex35
awk对文件切割，默认是空格
8
alex36 alex37 alex38 alex39 alex40
9
alex41 alex42 alex43 alex44 alex45
因此1~9行是5个字段
10
alex46 alex47 alex48 alex49 alex50
alex51
第10行是6个字段
[root@pylinux tmp]#
[root@pylinux tmp]# awk 'NF==5 {print $1}'
alex.txt
alex1
NF==5表示当某一行符合字段数是5的时候，
就打印第一列的数据
alex6
alex11
alex16
alex21
alex26
alex31
因此输出了1~9行
alex36
alex41
[root@pylinux tmp]# awk 'NF==6 {print $1}'
NF==6只有第10行符合，有6个字段
alex46
<!-- OCR_END -->

### awk的模式

| 关系运算符 | 解释 | 示例 |
| --- | --- | --- |
| < | 小于 | x\<y |
| <= | 小于等于 | x<=y |
| == | 等于 | x==y |
| != | 不等于 | x!=y |
| >= | 大于等于 | x>=y |
| > | 大于 | x>y |
| ~ | 匹配正则 | x~/正则/ |
| !~ | 不匹配正则 | x!~/正则/ |

案例

```plain
[root@pylinux tmp]# awk 'NR>3{print $0}' alex.txt
alex16 alex17 alex18 alex19 alex20
alex21 alex22 alex23 alex24 alex25
alex26 alex27 alex28 alex29 alex30
alex31 alex32 alex33 alex34 alex35
alex36 alex37 alex38 alex39 alex40
alex41 alex42 alex43 alex44 alex45
alex46 alex47 alex48 alex49 alex50  alex51
[root@pylinux tmp]#
[root@pylinux tmp]# awk '$1=="alex36"{print $0}' alex.txt
alex36 alex37 alex38 alex39 alex40
```

<!-- OCR_START -->
[root@pylinux tmp]# cat -n alex.txt
1
alex1 alex2 alex3 alex4 alex5
2
alex6 alex7 alex8 alex9 alex10
3
alex11 alex12 alex13 alex14 alex15
4
alex16 alex17 alex18 alex19 alex20
5
alex21 alex22 alex23 alex24 alex25
6
alex26 alex27 alex28 alex29 alex30
7
alex31 alex32 alex33 alex34 alex35
8
alex36 alex37 alex38 alex39 alex40
9
alex41 alex42 alex43 alex44 alex45
10
alex46 alex47 alex48 alex49 alex50
alex51
[root@pylinux tmp]#
[root@pylinux tmp]# awk 'NR>3{print $0}' alex.txt
输出行号大于3的整行内容
NR表示行号
输出第一个字段是alex36的整行信息
[root@pylinux tmp]# awk '$1=="alex36"{print $0}' alex.txt
<!-- OCR_END -->

### awk基础总结

* 空模式，没有指定任何的模式（条件），因此每一行都执行了对应的动作，空模式会匹配文档的每一行，每一行都满足了（空模式）

```plain
[root@pylinux tmp]# awk '{print $1}' alex.txt
alex1
alex6
alex11
alex16
alex21
alex26
alex31
alex36
alex41
alex46
```

* 关系运算符模式，awk默认执行打印输出动作

```plain
[root@pylinux tmp]# awk 'NR==2,NR==5' alex.txt
alex6 alex7 alex8 alex9 alex10
alex11 alex12 alex13 alex14 alex15
alex16 alex17 alex18 alex19 alex20
alex21 alex22 alex23 alex24 alex25
```

* BEGIN/END模式（条件设置）

<!-- OCR_START -->
- [root@pylinuxtmp]#awk
- ‘BEGIN{print"超哥这个awk讲的我明白了"}{print$2}END{print"awk基础讲完了"}’alex.txt
- 超哥这个awk讲的我明白了
- alex2
- alex7
- alex12
- alex17
- alex22
- alex27
- alex32
- alex37
- alex42
- alex47
- awk基础讲完
<!-- OCR_END -->

## awk与正则表达式

正则表达式主要与awk的`pattern模式（条件）`结合使用

* 不指定模式，awk每一行都会执行对应的动作
* 指定了模式，只有被模式匹配到的、符合条件的行才会执行动作

### 找出pwd.txt中有以games开头的行

1.用grep过滤

```plain
[root@pylinux tmp]# cat -n pwd.txt
     1    sync:x:5:0:sync:/sbin:/bin/sync
     2    shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     3    halt:x:7:0:halt:/sbin:/sbin/halt
     4    mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
     5    operator:x:11:0:operator:/root:/sbin/nologin
     6    games:x:12:100:games:/usr/games:/sbin/nologin
     7    ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
     8    nobody:x:99:99:Nobody:/:/sbin/nologin
     9    systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
    10    dbus:x:81:81:System message bus:/:/sbin/nologin
    11    polkitd:x:999:998:User for polkitd:/:/sbin/nologin
    12    libstoragemgmt:x:998:997:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin
    13    rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
    14    ntp:x:38:38::/etc/ntp:/sbin/nologin
[root@pylinux tmp]# grep '^games' pwd.txt
games:x:12:100:games:/usr/games:/sbin/nologin
```

2.awk怎么办？

```plain
[root@pylinux tmp]# awk '/^games/{print $0}'  pwd.txt
games:x:12:100:games:/usr/games:/sbin/nologin
#省略写法
[root@pylinux tmp]# awk '/^games/'  pwd.txt
games:x:12:100:games:/usr/games:/sbin/nologin
```

### awk使用正则语法

<!-- OCR_START -->
grep‘正则表达式'pwd.txt
awk‘/正则表达式/动作’/etc/passwd
<!-- OCR_END -->

awk命令使用正则表达式，必须把正则放入 "//" 双斜杠中，匹配到结果后执行动作{print $0}，打印整行信息

grep可以过滤，那我还用你awk干啥？

**awk强大的格式化文本**

<!-- OCR_START -->
[root@pylinux tmp]# catpwd.txt
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemdNetworkManagement:/:/sbin/nologin
dbus:x:81:81:Systemmessagebus:/:/sbin/nologin
polkitd:x:999:998:Userforpolkitd:/:/sbin/nologin
libstoragemgmt:x:998:997:daemonaccountfor1ibstoragemgmt:/var/run/lsm:/sbin/nologin
rpc:x:32:32:RpcbindDaemon:/var/lib/rpcbind:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
nawerwertp:x:38:38::/etc/ntp:/sbin/nologin
nqwerqstp:x:38:38::/etc/ntp:/sbin/nologin
nqwetp:x:38:38::/etc/ntp:/sbin/nologin
[root@pylinux tmp]#
在awk处理文本之前先格式化打印
正则匹配以n开头的行
[root@pylinux tmp]# awk -F ":"
'BEGIN{printf"%-10s\t%-10s\n","用户名","用户id"}/^n/{printf"%-10s\t%-10s\n",$1,$3}’pwd.txt
用户名
用户id
nobody
99
%-10s格式化字符串，左对齐，10个字符
格式化输出第一列
ntp
38
第三列
nawerwertp
It制表符四个空格
nqwerqstp
nqweqsdtp
nqwetp
<!-- OCR_END -->

```plain
[root@pylinux tmp]# awk -F ":"  'BEGIN{printf "%-10s\t%-10s\n","用户名","用户id"} /^n/ {printf "%-10s\t%-10s\n",$1,$3}' pwd.txt
用户名           用户id
nobody        99
ntp           38
nawerwertp    38
nqwerqstp     38
nqweqsdtp     38
nqwetp        38
```

### awk命令执行流程

解读需求：从pwd.txt文件中，寻找我们想要的信息，按照以下顺序执行

```plain
awk 'BEGIN{ commands } pattern{ commands } END{ commands }'
```

1. 优先执行`BEGIN{}`模式中的语句
2. 从pwd.txt文件中读取第一行，然后执行`pattern{commands}`进行正则匹配`/^n/` 寻找n开头的行，找到了执行`{print}` 进行打印
3. 当awk读取到文件数据流的结尾时，会执行`END{commands}`

### 找出pwd.txt文件中禁止登录的用户（`/sbin/nologin`）

正则表达式中如果出现了 `"/"`则需要进行转义

找出pwd.txt文件中禁止登录的用户（`/sbin/nologin`）

1.用grep找出

```plain
grep '/sbin/nologin$' pwd.txt
```

<!-- OCR_START -->
[root@pylinux tmp]# cat pwd.txt
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
源文件
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
libstoragemgmt:x:998:997:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin
rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
nawerwertp:x:38:38::/etc/ntp:/sbin/nologin
nqwerqstp:x:38:38: :/etc/ntp:/sbin/nologin
nqwetp:x:38:38::/etc/ntp:/sbin/nologin
[root@pylinux tmp]#
[root@pylinux tmp]# grep '/sbin/nologin$' pwd.txt
过滤出的信息
<!-- OCR_END -->

2.awk用正则得用双斜杠`/正则表达式/`

```plain
[root@pylinux tmp]# awk '/\/sbin\/nologin$/{print $0}' pwd.txt
```

<!-- OCR_START -->
[root@pylinux tmp]#
正则表达式
我们想要/sbin/nolgin
awk处理正则需要/正则/
[root@pylinux tmp]# awk'//sbinVnologin$/{print $0}' pwd.txt
mail:x:8:12:mail:/var/spooL/ma1L:/sbin/nologin
/sbin/nologin$这是我们想要的正则
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
但是这里出现了斜杠，因此得进行转义
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
VsbinVnologin$
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
通过\反斜杠，转义符，还原斜杠/
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
Libstoragemgmt:x:998:997:daemon account for 1ibstoragemgmt:/var/run/lsm:/sbin/nologin
rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
nawerwertp:x:38:38::/etc/ntp:/sbin/nologin
nqwerqstp:x:38:38::/etc/ntp:/sbin/nologin
x:38:38::/etc/ntp:/sbin/nologin
<!-- OCR_END -->

### 找出文件的区间内容

1.找出mail用户到nobody用户之间的内容

<!-- OCR_START -->
正则模式
awk
/正则表达式/{动作Yfile.txt
行范围模式
awk'/正则1/./正则2/{动作}'file.txt
<!-- OCR_END -->

```plain
[root@pylinux tmp]# awk '/^mail/,/^nobody/ {print $0}' pwd.txt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
```

2.关系表达式模式

```plain
[root@pylinux tmp]# awk 'NR>=4 && NR<=8 {print $0}' pwd.txt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
```

### awk企业实战nginx日志

Access.log

```plain
39.96.187.239 - - [11/Nov/2019:10:08:01 +0800] "GET / HTTP/1.1" 302 0 "-" "Zabbix"
211.162.238.91 - - [11/Nov/2019:10:08:02 +0800] "GET /api/v1/course_sub/category/list/?belong=1 HTTP/1.1" 200 363 "https://www.luffycity.com/free" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"
211.162.238.91 - - [11/Nov/2019:10:08:02 +0800] "GET /api/v1/degree_course/ HTTP/1.1" 200 370 "https://www.luffycity.com/free" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"
```

### 统计日志的访客ip数量

```plain
#sort -n 数字从大到小排序
#wc -l 统计行数，也就是ip的条目数
[root@pylinux tmp]# awk '{print $1}' 500access.log |sort -n|uniq|wc -l
75
```

### 查看访问最频繁的前10个ip

```plain
#uniq -c 去重显示次数
#sort -n 从大到小排序
1.先找出所有ip排序，排序，然后去重统计出现次数
awk '{print $1}' 500access.log |sort -n |uniq -c
2.再次从大到小排序，且显示前100个ip
[root@pylinux tmp]# awk '{print $1}' 500access.log |sort -n |uniq -c |sort -nr |head -10
     32 113.225.0.211
     22 119.123.30.32
     21 116.30.195.155
     20 122.71.65.73
     18 163.142.211.160
     16 39.96.187.239
     16 124.200.147.165
     16 101.249.53.64
     14 120.228.193.218
     14 113.68.155.221
```

<!-- OCR_START -->
- [root@pylinux tmp]# awk'{print $1}' 500access.log lsort -nIuniq -cIsort -nr Ihead-10
- 32 113.225.0.211
- 22 119.123.30.32
- 21 116.30.195.155
- sort从大到小先排序
- 20 122.71.65.73
- 18 163.142.211.160
- 然后unig去重-c统计出现次数
- 16 39.96.187.239
- 16 124.200.147.165
- 再次从大到小排序，以出现次数排序sort-rn
- 16 101.249.53.64
- 14 120.228.193.218
- 用head显示前十行信息
- 14 113.68.155.221
<!-- OCR_END -->

# awk动作

# awk数组

# awk内置函数

# 三剑客练习题

# grep练习题

*a.找出有关root的行*

```plain
[root@chaogelinux init.d]# grep 'root' /etc/passwd
```

*b.找出root开头的行*

```plain
[root@chaogelinux init.d]# grep '^root' /etc/passwd
root:x:0:0:root:/root:/bin/bash
```

*c.匹配以root开头或者以yu开头的行，注意定位锚点*

```plain
[root@chaogelinux init.d]# grep -E "^(root|yu)\>" /etc/passwd
```

*d.过滤出bin开头的行，切显示行号*

```plain
[root@chaogelinux init.d]# grep '^bin' /etc/passwd -n
2:bin:x:1:1:bin:/bin:/sbin/nologin
```

*e.过滤出除了root开头的行*

```plain
[root@chaogelinux init.d]# grep -v '^root' /etc/passwd -n
```

*f.统计yu用户出现的次数*

```plain
[root@chaogelinux init.d]# grep -c  '^yu' /etc/passwd
3
```

*g.匹配yu用户，最多2次*

```plain
[root@chaogelinux init.d]# grep -m 2 '^yu' /etc/passwd
```

*h.匹配多文件，列出存在信息的文件名字*

```plain
[root@chaogelinux data]# grep -l "root" pwd.txt  pwd2.txt  test1.sh
pwd.txt
pwd2.txt
```

***

1.显示/etc/passwd文件中不以/bin/bash结尾的行\*

```plain
grep -v "/bin/bash$" /etc/passwd
```

*2.找出/etc/passwd文件中的两位数或三位数*

```plain
grep  "[0-9]\{2,3\}"  /etc/passwd  #注意这个，是找出包含了2或3个数字的行，不严谨，有误
```

<!-- OCR_START -->
```text
pyyuc:x: 2000: 2000: :/home/pyyuc: /bin/bash
alex:x:2001:1500::/home/alex:/bin/bash
chaoge:x: 2002:2002:: /home/chaoge:/bin/bash
[root@chaogelinux data]# grep
[0-9]{2,31}'
/etc/passwd
```
<!-- OCR_END -->

正确思路，匹配完整的单词，只找到2-3个数字

```plain
[root@chaogelinux data]# grep  "\<[0-9]\{2,3\}\>"  /etc/passwd
```

<!-- OCR_START -->
[root@chaogelinux data]# grep "\<[0-9]\{2,3\}\>"
/etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
仅仅找出2或3个长度的数字
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System messagebus:/:/sbin/nologin
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
libstoragemgmt:x:998:997:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin
rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
abrt:x:173:173::/etc/abrt:/sbin/nologin
sshd:x:74:74:Privilege-separatedSSH:/var/empty/sshd:/sbin/nologin
postfix:x:89:89: :/var/spool/postfix:/sbin/nologin
chrony:x:997:995::/var/lib/chrony:/sbin/nologin
<!-- OCR_END -->

*3.找出文件中，以至少一个空白字符开头，后面是非空字符的行*

```plain
[root@chaogelinux data]# cat lovers.txt
 I like my lover.
I love my lover.
He likes his lovers.
 He loves his lovers.
#she loves her cat
[root@chaogelinux data]# grep  -E  "^[[:space:]]+[^[:space:]]"  lovers.txt
 I like my lover.
 He loves his lovers.
```

*4.找出lovers.txt文件中，所有大小写i开头的行*

```plain
[root@chaogelinux data]# cat lovers.txt
 I like my lover.
I love my lover.
He likes his lovers.
 He loves his lovers.
#she loves her cat
i want ride my bike
[root@chaogelinux data]# grep -i "^i" lovers.txt
I love my lover.
i want ride my bike
[root@chaogelinux data]# grep "^[iI]" lovers.txt
I love my lover.
i want ride my bike
[root@chaogelinux data]# grep -E "^(i|I)" lovers.txt
I love my lover.
i want ride my bike
```

*5.找出系统上root、yu、nobody用户的信息*

注意，机器上可能存在多个近似用户，精确搜索得加上`<>`

```plain
[root@chaogelinux data]# grep -E "^\<(root|yu|nobody)\>" /etc/passwd
root:x:0:0:root:/root:/bin/bash
nobody:x:99:99:Nobody:/:/sbin/nologin
yu:x:1000:1000::/home/yu:/bin/bash
```

*6.找出/etc/init.d/functions文件中的所有函数名*

```plain
提示：找出这样的结果
checkpid()
checkpids()
kill()
run()
pidof()
daemon()
killproc()
[root@chaogelinux init.d]# grep -E "[a-zA-Z]+\(\)" /etc/init.d/functions   -o
[root@chaogelinux init.d]# grep -E "[[:alnum:]]+\(\)" /etc/init.d/functions  -o
```

*7.找出用户名和shell相同的用户*

```plain
[root@chaogelinux init.d]# grep -E "^([^:]+\>).*\1$" /etc/passwd
```

<!-- OCR_START -->
root@chaogelinux init.d]# grep -E "^C[^:]+\>).*\1$" /etc/passwd
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
nalt:x:7:0:halt:/sbin:/sbin/halt以非冒号开头的单词，中间是任意，结尾取出分组的值
[root@chaogelinux init.d]#
<!-- OCR_END -->

# sed练习题

**提示，sed命令加上-i参数将结果写入到文件**

准备文件pwd2.txt

```plain
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/bin/false
ba:x:1002:1002::/home/zhangy:/bin/bash
daemon:x:2:2:daemon:/sbin:/bin/false
mail:x:8:12:mail:/var/spool/mail:/bin/false
ftp:x:14:11:ftp:/home/ftp:/bin/false
&nobody:$:99:99:nobody:/:/bin/false
http:x:33:33::/srv/http:/bin/false
dbus:x:81:81:System message bus:/:/bin/false
hal:x:82:82:HAL daemon:/:/bin/false
mysql:x:89:89::/var/lib/mysql:/bin/false
aaa:x:1001:1001::/home/aaa:/bin/bash
test:x:1003:1003::/home/test:/bin/bash
```

*a.替换文件的root为chaoge，只替换一次，与替换所有*

```plain
sed 's/root/chaoge/' pwd2.txt |grep chaoge
sed 's/root/chaoge/g' pwd2.txt |grep chaoge
```

*b.替换文件所有的root为chaoge，且仅仅打印替换的结果*

```plain
[root@chaogelinux data]# sed 's/root/chaoge/gp' pwd2.txt -n
chaoge:x:0:0:chaoge:/chaoge:/bin/bash
```

*c.替换前10行bin开头的用户，改为C，且仅仅显示替换的结果*

```plain
[root@chaogelinux data]# sed -n "1,10s/^bin/C/gp" pwd2.txt
```

*d.替换前10行b开头的用户，改为C，且将m开头的行，改为M，且仅仅显示替换的结果*

```plain
[root@chaogelinux data]# sed -n -e "1,10s/^b/C/pg" -e "1,10s/^m/M/gp" pwd2.txt
```

*e.删除4行后面所有*

```plain
[root@chaogelinux data]# sed '4,$d' pwd2.txt
```

*f.删除从root开始，到ftp之间的行*

```plain
[root@chaogelinux data]# sed '/^root/,/^ftp/d' pwd2.txt
```

***

准备文件2

```plain
[root@chaogelinux data]# cat lovers.txt
 I like my lover.
I love my lover.
He likes his lovers.
 He loves his lovers.
#she loves her cat
```

*1.将文件中空白字符开头的行，添加注释符*

```plain
[root@chaogelinux data]# sed -e 's/^[[:space:]]/#/g' -e 's/^$/#/g' lovers.txt
#I like my lover.
I love my lover.
He likes his lovers.
#He loves his lovers.
#she loves her cat
#
#
#
```

*2.删除文件的空白和注释行*

```plain
[root@chaogelinux data]# sed '/^$/d;/^#/d' lovers.txt
 I like my lover.
I love my lover.
He likes his lovers.
 He loves his lovers.
```

*3.给文件前三行，添加#符号*

```plain
[root@chaogelinux data]# sed '1,3s/\(^.\)/#\1/g'  lovers.txt
# I like my lover.
#I love my lover.
#He likes his lovers.
 He loves his lovers.
#she loves her cat
```

<!-- OCR_START -->
- [root@chaogelinux data]# sed '1,3s/(^.\)/#>1/g
- lovers.txt
- # I like my lover.
- 1,3s
- 替换1到3行内容
- #I love my lover.
- #He likes his lovers.
- 1(^.V
- He loves his lovers.
- \转义符（分组^.匹配第一个字符
- #sheloves hercat
- 放入第一个组中，后面用\1引用分组的结果
- 结论：找出前3行的内容，替换第一个字符为"#字符
- 即，在前3行开头，添加注释符
<!-- OCR_END -->

*4.sed取出ip地址*

```plain
#多次管道符编辑
[root@chaogelinux data]# ifconfig eth0 |sed -n '2p' | sed 's/^.*inet//' | sed 's/netmask.*//'
 10.141.32.137
 #利用分组功能，引用ip地址
 [root@chaogelinux data]# ifconfig eth0 | sed -n '2p' | sed -r 's/^.*inet(.*)netmask.*/\1/'
 10.141.32.137
 #sed支持扩展正则 -r参数
 [root@chaogelinux data]# ifconfig eth0 | sed -r -n '2s/.*inet (.*)netmask.*/\1/p'
10.141.32.137
```

*5.找出系统版本*

```plain
[root@chaogelinux data]# cat /etc/centos-release
CentOS Linux release 7.7.1908 (Core)
[root@chaogelinux data]# sed -r -n 's/.*release[[:space:]]*([^.]+).*/\1/p' /etc/centos-release
7
```

<!-- OCR_START -->
[root@chaogelinuxdata]#cat/etc/centos-release
2
3
Cent0sLinux release 7.7.1908(Core)
[root@chaogelinux data]# sed -r -n 's/.*release[[:space:]]*C[^.]+].*^1/p' /etc/centos-release
7
[root@chaogelinux data]#
.*release[[:space:]]*匹配到CentoS Linux release
(^.]+）分组匹配，找到除了小数点以外的内容，一次或者多次，匹配到7
.*代表结尾的任意内容
<!-- OCR_END -->

# awk练习题

1.在当前系统中打印出所有普通用户的用户和家目录（/etc/passwd）

<!-- OCR_START -->
- 以passwd文件中root一行为例介绍各个字段作用
- 1
- 2
- 3
- 4
- 5
- 6
- 7
- root
- :X
- :0
- :/bin/bash
- 用户名称
- ：用户密码
- ：用户UID
- 用户组GIUD
- 用户说明
- ：用户家目录
- ：shell解释
<!-- OCR_END -->

```plain
[root@chaogelinux ~]# cat /etc/passwd | awk -F ":" '$3>=1000{print $1,"\t\t",$NF}'
```

2.给/tmp/chaoge.txt文件的前五行，添加#号

```plain
[root@chaogelinux tmp]# cat chaoge.txt
爱的魔力转圈圈1 爱的魔力转圈圈2 爱的魔力转圈圈3
爱的魔力转圈圈4 爱的魔力转圈圈5 爱的魔力转圈圈6
爱的魔力转圈圈7 爱的魔力转圈圈8 爱的魔力转圈圈9
爱的魔力转圈圈10 爱的魔力转圈圈11 爱的魔力转圈圈12
爱的魔力转圈圈13 爱的魔力转圈圈14 爱的魔力转圈圈15
爱的魔力转圈圈16 爱的魔力转圈圈17 爱的魔力转圈圈18
爱的魔力转圈圈19 爱的魔力转圈圈20
[root@chaogelinux tmp]# awk 'NR<6{print "#"$0}' chaoge.txt
```

3.统计文本信息

*姓名 区号 电话 三个月捐款数量*

```plain
Mike Harrington:[510] 548-1278:250:100:175
Christian Dobbins:[408] 538-2358:155:90:201
Susan Dalsass:[206] 654-6279:250:60:50
Archie McNichol:[206] 548-1348:250:100:175
Jody Savage:[206] 548-1278:15:188:150
Guy Quigley:[916] 343-6410:250:100:175
Dan Savage:[406] 298-7744:450:300:275
Nancy McNeil:[206] 548-1278:250:80:75
John Goldenrod:[916] 348-4278:250:100:175
Chet Main:[510] 548-5258:50:95:135
Tom Savage:[408] 926-3456:250:168:200
Elizabeth Stachelin:[916] 440-1763:175:75:300
```

*显示所有电话号码*

```plain
提示：
awk -F "[:]" '{print $1,$2}' tel.txt  #见到冒号就切一刀
awk -F "[ ]" '{print $1,$2}' tel.txt    #见到空格就切一刀
awk -F "[ :]" '{print $1,$2,$3,$4}' tel.txt  #见到空格或冒号，都切一刀
答案：
awk -F "[ :]" '!/^$/{print $4}' tel.txt  #排除空行，取出电话
```

*显示Tom的电话*

```plain
[root@chaogelinux tmp]# awk -F "[ :]+" '/^Tom/{print $4}' tel.txt
926-3456
```

*显示Nancy的姓名、区号、电话*

```plain
[root@chaogelinux tmp]# awk -F "[ :]" '/^Nancy/{print $1,$2,$4}' tel.txt
Nancy McNeil 548-1278
```

*显示所有D开头的姓*

<!-- OCR_START -->
- [root@chaogelinux tmp]# awk -F "[ :]" '/^D/{print $2}' tel.txt
- Savage
- 匹配D开头的行，不对
- [root@chaogelinux
- < tmp]# awk -F "[:]"
- $2~/^D/{print $2}' tel.txt
- Dobbins
- 针对第二列进行正则匹配
- Dalsass
<!-- OCR_END -->

```plain
[root@chaogelinux tmp]# awk -F "[ :]" '/^D/{print $2}' tel.txt
Savage
[root@chaogelinux tmp]# awk -F "[ :]" '$2~/^D/{print $2}' tel.txt
Dobbins
Dalsass
```

*显示所有区号是916的人名*

```plain
#针对第三列匹配正则，打印第一列
[root@chaogelinux tmp]# awk -F "[ :]" '$3~/\[916\]/{print $1}' tel.txt
Guy
John
Elizabeth
```

*显示Mike的捐款信息，在每一款前加上美元符*

```plain
[root@chaogelinux tmp]# awk -F "[ :]" '/^Mike/{print "$"$(NF-2),"$"$(NF-1),"$"$(NF)}' tel.txt
$250 $100 $175
```

\_显示所有人的`姓+逗号+名_`

```plain
[root@chaogelinux tmp]# awk -v FS="[ :]"  -v OFS=","  '!/^$/{print $2,$1}' tel.txt
Harrington,Mike
Dobbins,Christian
Dalsass,Susan
McNichol,Archie
Savage,Jody
Quigley,Guy
Savage,Dan
McNeil,Nancy
Goldenrod,John
Main,Chet
Savage,Tom
Stachelin,Elizabeth
```

*删除文件的空白行（awk不修改源文件），替换后的内容重定向写入新文件*

```plain
[root@chaogelinux tmp]# awk '!/^$/{print $0}' tel.txt > tel2.txt
[root@chaogelinux tmp]# awk '!/^$/' tel.txt > tel2.txt
```

> 更新: 2023-01-10 21:11:28  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/ed9xqk>