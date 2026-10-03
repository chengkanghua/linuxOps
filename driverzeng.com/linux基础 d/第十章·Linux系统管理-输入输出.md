# 第十章·Linux系统管理-输入输出

## 重定向概述

| 什么是重定向 |
| :--- |

将原本要输出到屏幕的数据信息，重新定向到指定的文件中。

比如：每天凌晨定时备份数据，希望将备份数据的结果保存到某个文件中。这样第二天通过查看结果文件，就知道昨天备份数据是成功，还是失败。

| 为何要使用重定向 |
| :--- |

1.当屏幕输出的信息很重要，而且希望保存重要的信息时。

2.后台执行中的程序，不希望他干扰屏幕正常的输出结果时。

3.系统的例行命令, 例如定时任务的执行结果，希望他可以存下来时。

4.一些执行命令，我们已经知道他可能出现错误信息, 想将他直接丢弃时。

5.执行一个命令，可能报错和正确的输出并存，类似错误日志与标准正确日志需要分别输出至不同的文件。

## 标准输入与输出

执行一个`shell`程序时通常会自动打开三个文件描述符

| 名称 | 文件描述符 | 作用 |
| :--- | :--- | :--- |
| 标准输入（stdin） | 0 | 通常是键盘，也可以是其他文件或者命令的输出的内容可以作为标准输入 |
| 标准输出（stdout） | 1 | 默认输出到屏幕 |
| 错误输出（stderr） | 2 | 默认输出到屏幕 |
| 文件名称（filename） | 3+ | |

进程将从标准输入中得到数据，将正常输出打印至屏幕终端，将错误的输出信息也打印至屏幕终端。

进程使用文件描述符`(file descriptors)`来管理打开的文件

<!-- OCR_START -->
- stdout
- stdin
- stderr
- process
- otherfiles
<!-- OCR_END -->

以`cat`命令为例, `cat`命令的功能是从命令行给出的文件中读取数据，并将这些数据直接送到标准输出。若使用如下命令：

```bash
#会把文件`/etc/passwd`的内容依次显示到屏幕上
[root@zls ~]# cat /etc/passwd
```

但如果`cat`命令行中没有参数, 它就会从标准输入中读取数据, 并将其送到标准输出。

```bash
[root@zls ~]# cat
hello
hello
^C
//用户输入的每一行都立刻被cat命令输出到屏幕上。
```

输入输出过程检测

```bash
#持续追踪查看文件内容
[root@zls ~]# tail -f /etc/passwd
ctrl+z 将进程转到后台
#查看运行的进程
[root@zls ~]# ps
PID TTY          TIME CMD
5848 pts/1    00:00:00 bash
6885 pts/1    00:00:00 tail
6888 pts/1    00:00:00 ps
#查看6885进程下的文件描述符
[root@zls ~]# ls -l /proc/6885/fd
total 0
lrwx------ 1 root root 64 Dec  3 06:57 0 -> /dev/pts/1
lrwx------ 1 root root 64 Dec  3 06:57 1 -> /dev/pts/1
lrwx------ 1 root root 64 Dec  3 06:56 2 -> /dev/pts/1
lr-x------ 1 root root 64 Dec  3 06:57 3 -> /etc/passwd
lr-x------ 1 root root 64 Dec  3 06:57 4 -> inotify
# Linux查看标准输入输出设备
[root@zls ~]# ls -l /dev/std*
lrwxrwxrwx 1 root root 15 Dec  2 22:30 /dev/stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root 15 Dec  2 22:30 /dev/stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root 15 Dec  2 22:30 /dev/stdout -> /proc/self/fd/1
```

## 输出重定向

***

重定向: 改变标准输入、标准输出的方向的就是重定向\*\*

***

| 类型 | 操作符 | 用途 |
| :--- | :--- | :--- |
| 标准覆盖输出重定向 | 1> | 将命令的执行结果输出到指定的文件中, 而不是直接显示在屏幕上 |
| 标准追加输出重定向 | >> | 将命令执行的结果追加输出到指定文件 |
| 错误覆盖输出重定向 | 2> | 将程序的错误结果输出到执行的文件中，会覆盖源文件内容 |
| 错误追加输出重定向 | 2>> | 将程序输出的错误结果以追加的方式输出到指定文件中，不会覆盖源文件 |
| 标准输入重定向 | << | 将命令中接收输入的途径由默认的键盘更改为指定的文件 |

***

| 案例1: 标准输出重定向(覆盖) |
| :--- |

<!-- OCR_START -->
- stdin
- stdout
- process
- stderr
<!-- OCR_END -->

```bash
#标准输出重定向, 先清空,后写入, 如果文件不存在则创建
[root@zls ~]# ifconfig eth0 > abc
```

***

| 案例2: 标准输出重定向(追加) |
| :--- |

<!-- OCR_START -->
- stdin
- stdout
- process
- stderr
<!-- OCR_END -->

```bash
//标准追加输出重定向, 向配置文件末尾追加内容
[root@zls ~]# echo "This is network conf" >> if
```

***

| 案例3: 错误输出重定向 |
| :--- |

<!-- OCR_START -->
- stdin
- stdout
- process
- stderr
<!-- OCR_END -->

```bash
#正确输出以及错误输出重定向至一个文件
[root@zls ~]# useradd zls
[root@zls ~]# su - zls
//将标准输出和标准错误输出重定向到不同文件
[zls@zls ~]# find /etc -name "*.conf" 1>a 2>b
```

***

| 案例4: 正确和错误都输入到相同位置 |
| :--- |

<!-- OCR_START -->
- stdout
- stdin
- process
- stderr
<!-- OCR_END -->

```bash
#将标准输出和标准错误输出重定向到同一个文件, 混合输出
[zls@zls ~]$ find /etc -name "*.conf" &>ab
[zls@zls ~]$ find /etc -name "*.conf" >ab 2&>1
#合并两个文件内容至一个文件
[zls@zls ~]$ cat a b > c
```

<!-- OCR_START -->
- stdin
- stdout
- process
<!-- OCR_END -->

```bash
#重定向到相同的位置
[root@zls ~]# ls /root /error >ab  2>&1
```

***

| 案5: 重定向到空设备/dev/null |
| :--- |

<!-- OCR_START -->
- stdin
- stdout
- process
- stderr
<!-- OCR_END -->

```bash
#空设备，即将产生的输出丢掉
[root@zls ~]# ls /root /error >ab 2>/dev/null
[root@zls ~]# ls /root /error >ab &>/dev/null
```

***

| 案例6: 脚本中使用重定向 |
| :--- |

```bash
[root@zls ~]# vim ping.sh 
#!/bin/bash
. /etc/init.d/functions
read -p "请输入要检测的IP：" IP
ping -c1 -W1 $IP
if [ $? -eq 0 ];then
        action "$IP" /bin/true
else
        action "$IP" /bin/false
fi
[root@zls ~]# sh ping.sh
#改进后版
[root@zls ~]# vim ping.sh
#!/bin/bash
. /etc/init.d/functions
read -p "请输入要检测的IP：" IP
ping -c1 -W1 $IP >/dev/null
if [ $? -eq 0 ];then
        action "$IP" /bin/true
else
        action "$IP" /bin/false
fi
```

***

| 案例7: 脚本中使用重定向 |
| :--- |

```bash
[root@zls ~]# vim ping2.sh 
#!/bin/bash
. /etc/init.d/functions
read -p "请输入要检测的IP：" IP
ping -c1 -W1 $IP >/dev/null
if [ $? -eq 0 ];then
        action "$IP" /bin/true >> /tmp/IP_OK.txt
else
        action "$IP" /bin/false >> /tmp/IP_FAILD.txt
fi
[root@zls ~]# sh ping.sh
```

## 输入重定向

输入重定向，即原本从键盘等设备上获得的输入信息，重定向由命令的输出作为输入。

标准输入: `< 等价 0<`

***

| 案例1 |
| :--- |

```bash
#没有改变输入的方向，默认键盘
[root@zls ~]# mail zls
Subject: hello
1111 
2222
3333
.   #结束
EOT
#检查是否收到邮件
[root@zls ~]# su - zls
[root@zls ~]# mail
//输入重定向，来自于文件
[root@zls ~]# mail -s "test01" zls < /etc/hosts
```

***

| 案例2 |
| :--- |

```bash
#没有改变输入的方向，默认键盘，此时等待输入
[root@zls ~]# grep 'root' 
xxx
xxx
[root@zls ~]# grep 'root' < /etc/passwd
root:x:0:0:root:/root:/bin/bash
```

***

| 案例3 |
| :--- |

```bash
[root@zls ~]# dd if=/dev/zero of=/file1.txt bs=1M count=20
[root@zls ~]# dd </dev/zero >/file2.txt bs=1M count=20
```

***

| 案例4 |
| :--- |

```bash
#mysql 导入数据
[root@zls ~]# mysql -uroot -p123 < bbs.sql
```

***

| 案例5: 利用重定向建立多行的文件 |
| :--- |

```bash
#手动执行 shell 命令
[root@zls ~]# echo "111" > file1.txt 
[root@zls ~]# cat file1.txt
111
[root@zls ~]# cat >file2.txt
111
222
333
^D
[root@zls ~]# cat >>file3.txt
aaa
bbb
ccc
^D
```

***

| 案例6: 利用重定向建立多行的文件 |
| :--- |

```bash
#脚本 script 创建多行文件
[root@zls ~]# vim create_file.sh 
cat >file200.txt <<EOF
111
222
333
yyy
ccc
EOF
[root@zls ~]# vim vm.sh
cat <<EOF
+--------------------------+
| vmware manager           |
+--------------------------+
| by zls                   |
+--------------------------+
| 1. Install KVM           |
| 2. Install or Reset C6.5 |
| 3. Install or Reset C7.4 |
| 5. Instqll or Reset W7   |
| 6. Remove all            |
| q. quit                  |
+--------------------------+
EOF

# 以下方式变量不解析
cat >file200.txt <<\EOF
111
222
$LANG
yyy
ccc
EOF

cat >file200.txt <<-'EOF'
111
222
$LANG
EOF
```

```bash
[root@db04 ~]# vim fruit.sh
#!/bin/sh
menu(){
      cat <<EOF
    +------------+
    | 1 | apple  |
    +---+--------+
    | 2 | pear   |
    +---+--------+
    | 3 | banana |
    +---+--------+
    | 4 | cherry |
    +---+--------+
EOF
read -p "please input a num: " fruit
}
usage(){
     echo "USAGE:请输入水果编号"
     exit 1
}
color(){
case "$fruit" in
  1)
    echo -e "\E[1;31mapple \E[0m"
    ;;
  2)
    echo -e "\E[1;20mpear \E[0m"
    ;;
  3)
    echo -e "\E[1;33mbanana \E[0m"
    ;;
  4)
    echo -e "\E[1;35mcherry \E[0m"
    ;;
  *)
    usage
esac
}
menu
color
```

***

| 案例7: 两条命令同时重定向\[了解] |
| :--- |

```bash
[root@zls ~]# ls; date &>/dev/null
[root@zls ~]# ls &>/dev/null; date &>/dev/null
[root@zls ~]# (ls; date) &>/dev/null
#后台执行
[root@zls ~]# (while :; do date; sleep 2; done) &
[1] 6378
[root@zls ~]# (while :; do date; sleep 2; done) &>date.txt &
[root@zls ~]# jobs
[1]+ 运行中 ( while :; do date; sleep 2;
done ) &>/date.txt &
```

扩展点: `subshell`

```bash
[root@zls ~]# cd /boot; ls
#subshell 中执行
[root@zls ~]# (cd /boot; ls)
#如果不希望某些命令的执行对当前 shell 环境产生影响，请在subshell中执行
```

## 管道技术

| 什么是管道 |
| :--- |

管道操作符号 "|" 连接左右两个命令, 将左侧的命令的标准输出, 交给右侧命令的标准输入。

***

注意：无法船体标准错误输出至后者命令

***

<!-- OCR_START -->
- stdout
- stdin
- process
<!-- OCR_END -->

格式: `cmd1 | cmd2 [...|cmdn]`

***

| 案例1: 将/etc/passwd 中的UID取出并按大小排序 |
| :--- |

```bash
#正常按第三列排序
[root@zls ~]# sort -t":" -k3 -n /etc/passwd 
[root@zls ~]# sort -t":" -k3 -n /etc/passwd -r 
[root@zls ~]# sort -t":" -k3 -n /etc/passwd |head
```

***

| 案例2: 统计当前/etc/passwd 中用户使用的 shell 类型 |
| :--- |

```bash
#思路:取出第七列(shell) | 排序(把相同归类)| 去重
[root@zls ~]# awk -F: '{print $7}' /etc/passwd
[root@zls ~]# awk -F: '{print $7}' /etc/passwd |sort
[root@zls ~]# awk -F: '{print $7}' /etc/passwd |sort |uniq
[root@zls ~]# awk -F: '{print $7}' /etc/passwd |sort |uniq -c
```

***

| 案例3: 统计出最占CPU的5个进程 |
| :--- |

```bash
[root@zls ~]# ps aux --sort=-%cpu |head -6
```

***

| 案例4: 统计网站的访问情况 top 20 |
| :--- |

```bash
#思路: 打印所有访问的连接 | 过滤访问网站的连接 | 打印用户的 IP | 排序 | 去重
[root@zls ~]# yum -y install httpd
[root@zls ~]# systemctl start httpd
[root@zls ~]# systemctl stop firewalld
[root@zls ~]# ss -an |grep :80 |awk -F":" '{print $8}' |sort |uniq -c
[root@zls ~]# ss -an |grep :80 |awk -F":" '{print $8}' |sort |uniq -c |sort -k1 -rn |head -n 20
```

***

| 案例5: 打印当前所有 IP |
| :--- |

```bash
[root@zls ~]# ip addr |grep 'inet ' |awk '{print $2}' |awk -F"/" '{print $1}'
127.0.0.1
192.168.69.112
```

***

| 案例6: 打印根分区已用空间的百分比(仅打印数字) |
| :--- |

```bash
[root@zls ~]# df |grep '/$' |awk '{print $5}' |awk -F"%" '{print $1}'

```

\*\*注意：\*\*管道符能让大家进一步掌握命令之间的搭配使用，提高命令输出值的处理效率，但是尽可能的减少管道的数量，一根管道能完成的事情，尽量不要用两根。

## tee管道技术

<!-- OCR_START -->
- stdout
- stdin
- process
- tee
- or
<!-- OCR_END -->

```bash
[root@zls ~]# ip addr |grep 'inet ' |tee ip.txt |awk -F"/" '{print $1}' |awk '{print $2}'
127.0.0.1
192.168.69.112
192.168.122.1
[root@zls ~]# cat ip.txt
inet 127.0.0.1/8 scope host lo
inet 192.168.69.112/24 brd 192.168.69.255 scope global ens32
inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
```

重定向与`tee`区别

```bash
[root@zls ~]# date > date.txt 
[root@zls ~]# date |tee date.txt
```

## 参数传递xargs

> 将参数列表转换成小块分段传递给其他命令
>
> 读入`stdin`的数据转换为参数添加至命令后面
>
> 让一些不支持管道的命令可以使用管道。

```bash
[root@zls ~]# grep "/sbin/nologin" /etc/passwd | wc -l
33
[root@zls ~]# head -5 /etc/passwd|tail -1
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
#使用grep过滤输出信息
[root@zls ~]# ls -l /etc |grep pass
-rw-r--r--   1 root root   4653 Dec  2 15:54 passwd
-rw-r--r--.  1 root root   4606 Dec  2 15:54 passwd-
-rw-r--r--.  1 root root   1454 Sep 23  2014 passwd.OLD
//管道和标准输出以及标准错误输出, 使用普通用户执行如下命令
find /etc/ -name "p*"|grep passwd
find /etc/ -name "p*"|grep passwd > a
find /etc/ -name "p*"|grep passwd > b
find /etc/ -name "p*"|grep passwd &> ab
```

注意事项:

> 1.在管道后面的命令，都不应该在写文件名
>
> 2.在管道中只有标准输出才可以传递下一个命令, 标准错误输出会直接输出终端显示, 建议在使用管道前将标准错误输出重定向。
>
> 例如: find /etc -name "\*.conf" 2>/dev/null | grep rc
>
> 3.有些命令不支持管道技术, 但是可以通过`xargs`来实现管道传递。
>
> 例如: which cat|xargs ls-l
>
> 例如: ls |xargs rm -rvf
>
> 例如: ls |xargs cp -rvft /tmp/ -> ls | xargs -I {} cp -rvf {} /tmp
>
> 例如: ls |xargs mv -t /tmp/ -> ls | xargs -I {} mv {} /tmp

> 更新: 2024-09-21 21:40:18  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/sf1sx9>