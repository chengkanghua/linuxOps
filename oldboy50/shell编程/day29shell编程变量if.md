# day29 Shell 编程：变量与 if

## 一、课前回顾

### 1. 如何杀死僵尸进程
```bash
ps lax | egrep 'zombie|TIME'
```
- 最简单粗暴：重启服务器（弊端明显，不在考虑范围）。
- 方案 1：直接杀死父进程 `kill -9 <父进程pid>`
- 方案 2：手动向父进程传递 `SIGCHLD` 信号 `kill -s SIGCHLD <父进程pid>`；若无效再重启父进程；仍不行则退回方案 1。

### 2. 查询系统性能命令速查
```bash
cpu : lscpu  /proc/cpuinfo  w  uptime  top  htop  lm_sensors  vmstat  sar
磁盘：df  du  iotop  dd
内存：free  ps aux  top  htop
网络：iftop  netstat  ss  nmap
raid：megacli
硬件：ipmitool
```

## 二、为什么使用 Shell 编程？
**节约时间、减少重复工作。**

系统自带大量 shell 脚本，例如：
```bash
# vim /etc/init.d/functions   # 系统的 shell 脚本
# ll /etc/init.d/functions
-rw-r--r-- 1 root root 25427 Aug 15 18:26 /etc/init.d/functions
```

## 三、书写脚本基础

```bash
#！/bin/bash   # 脚本默认的命令解释器，写在开头
#! /usr/bin/python
# file cal.sh
cal.sh: Bourne-Again shell script text executable
```

**两种执行方式**
```bash
# sh bak-etc.sh        # 执行脚本，-x 可查看执行过程
/bin/sh -x bak-etc.sh

# cat bak-etc.sh
# !/bin/bash
PATH=$PATH
#get ip address
ip=`hostname -I|awk '{print $1}'`
#mkdir && backup
mkdir -p /backup/$ip
tar zcf /backup/$ip/etc-`date +%F`.tar.gz /etc/
```

## 四、变量

### 1. 什么是变量
```
x + y = 10   x = 20   y = ?
```
变量相当于"藏金阁里的秘籍"：变量名是书名，使用变量是"看书 `$bao`"，修改变量是重新赋值 `bao="欲练此功必先自宫..."`。

- **变量命令规则**：不能以数字开头。
- **变量分类**：
  - 普通变量（局部变量）：`ip`、`oldboy`、`IP`
  - 环境变量（全局变量）：① 大写 ② 系统定义 ③ 大部分地方可用，如 `PATH`、`PS1`、`LANG`

### 2. 局部变量 vs 全局变量
```bash
# env 显示系统所有环境变量名
env | awk -F'[=]' '{print $1}'
env | sed 's#=.*##g'
env | egrep '^[A-Z0-9_]+'
env | egrep '^[^=]+' -o

# vim show.sh
# OLDBOY=10
# echo $OLDBOY
10
# /bin/sh show.sh
# export OLDBOY=10   # 声明为全局变量（环境变量）
# /bin/sh show.sh
10
# env |grep -i oldboy   # 检查环境变量
HOSTNAME=oldboy01
OLDBOY=10
# unset OLDBOY          # 取消变量
# OLDBOY=10
# source show.sh        # 相当于在当前环境执行
10
# . show.sh             # 等于 source
10
```

### 3. 特殊变量（重点）
```bash
# week=6
# echo $week
6
# echo $weekday

# echo $week'day'
6day
# echo ${week}day
6day
```

### 4. 花括号的用法
当变量名紧跟字母/数字时，必须用 `${变量}` 界定边界，否则会被连读成新变量名（如 `$weekday` 实际是另一个未定义变量）。

## 五、做一个计算器（awk 入门）

```bash
# awk 'BEGIN{print 1/3}'
0.333333
# awk -v num1=10 'BEGIN{print num1}'
10
# awk -vnum1=10 -vnum2=20 'BEGIN{print num1/num2}'
0.5
# awk -v{n1=10,n2=20} 'BEGIN{print n1/n2}'
0.5
```

**脚本版：计算 10 与 20 的加减乘除 `cal.sh`**
```bash
# vim cal.sh
# cat cal.sh
# !/bin/bash
awk -v{n1=10,n2=20} 'BEGIN{print n1/n2}'
awk -v{n1=10,n2=20} 'BEGIN{print n1*n2}'
awk -v{n1=10,n2=20} 'BEGIN{print n1+n2}'
awk -v{n1=10,n2=20} 'BEGIN{print n1-n2}'
# /bin/sh cal.sh
0.5
200
30
-10
```

### 通过命令行参数计算
```bash
# sh cal.sh 10 20
30
-10
200
0.5
# cat cal.sh
# !/bin/bash
n1=$1
n2=$2
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1+n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1-n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1*n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1/n2}'
# sh cal.sh 10 20
```

## 六、特殊变量小结

```bash
$1 $2      awk：第1列 第2列
           shell脚本：第1个参数 第2个参数
$0         awk：整行
           shell脚本：文件名称
$#         脚本参数的个数
$?         上一个命令的退出状态码（返回值），0 正确，非 0 失败
$@         以列表的形式返回参数列表
```

```bash
# sh cal.sh 10 20 30
10 20 cal.sh

cat > cal.sh <<EOF
# !/bin/bash
n1=$1
n2=$2
echo $1 $2 $0
EOF
# sh cal.sh 10 20 30
10 20 cal.sh 3

cat > cal.sh <<EOF
# !/bin/bash
n1=$1
n2=$2
echo $1 $2 $0 $#
EOF
# echo $?
0
# lslafl
-bash: lslafl: command not found
# echo $?   # 表示上一个命令的退出状态码
127
```

### 通过 read 交互式赋值
```bash
read -p "input num1:" n1   # -p 显示提示
input num1:oldboy
# echo $n1
oldboy
# -s 不显示输入（密码）  -t 超时时间
read -s -t 5 -p "input passwd:" p
```

**脚本版 `cal-read.sh`**
```bash
# sh cal-read.sh
input num1,num2:10 20
30
-10
200
0.5

cat > cal-read.sh <<EOF
# !/bin/bash
read -p "input num1,num2:" n1 n2
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1+n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1-n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1*n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1/n2}'
EOF
```

### vim 快捷操作（批量删除 / 批量添加）
```bash
1 进入批量编辑模式（可视块） ctrl + v
2 选择批量增加的范围
3 按 shift + i 进行修改
4 按 esc 退出
```
> vim 快捷键 `r`：替换当前光标字符，不进入编辑模式。

## 七、if 判断

```bash
# 1. 如果 /oldboy 目录存在，显示 /oldboy dir exist
# ls /oldboy && echo /oldboy dir exist
# [ -d /oldboy ] && echo '/oldboy dir exist'
/oldboy dir exist

# 2. 如果 /oldboy 不存在，则创建该目录
ls /oldboy || mkdir -p /oldboy
[ -d /oldboy2 ] || mkdir -p /oldboy2
```

### 条件表达式
```bash
[ -d /oldboy ]   # 目录存在为真
[ -f /oldboy ]   # 文件存在为真
[ -d /oldboy50 ]
# echo $?        # 目录存在返回 0
0
# [ -d /oldboy5 ]
# $?             # 目录不存在返回非 0
```

### 数值比较运算符
```
-eq   equal         ==
-ne   not equal     !=
-gt   great than    >
-ge   great equal   >=
-lt   less than     <
-le   less equal    <=
```
> 更多参见 `man bash`。

### if 基本语法
```bash
if [ 条件 ];then
    命令
fi
```

**示例：限定参数个数必须是 2 个**
```bash
cat > geshu.sh <<EOF
# !/bin/bash
if [ $# -ne 2 ];then
    echo "参数个数必须是2个"
fi
EOF
```

**给计算器增加参数校验**
```bash
cat > cal.sh <<EOF
#!/bin/bash
if [ $# -ne 2 ];then
echo "USAGE:$0 num1 num2"
    exit   # 提前退出
fi
n1=$1
n2=$2
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1+n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1-n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1*n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1/n2}'
EOF
```

**比较两数的大小**
```bash
cat > bgormall.sh <<EOF
#!/bin/bash
n1=$1
n2=$2
if [ $n1 -gt $n2 ];then
echo "$n1>$n2"
else
echo "$n1<=$n2"
fi
EOF
```

### 测试表达式（条件表达式）
```bash
[ -z ]   # 字符串为空返回真
[ -d ]   # 目录存在
[ -f ]   # 文件存在
```

### 多分支 if
```bash
cat > comp-multi.sh <<EOF
#!/bin/bash
n1=$1
n2=$2
if [ $n1 -gt $n2 ];then
echo "$n1 > $n2"
elif [ $n1 -lt $n2 ];then
echo "$n1 <$n2"
else
echo "$n1 == $n2"
fi
EOF
# sh comp-multi.sh 19 29
19 <29
```

## 八、for 循环

```bash
for 变量 in 列表
do
    命令
done

for tao in girl{01..9999}
do
echo $tao
done
```

### 批量分发公钥（免交互）
```bash
ssh-keygen -t rsa
yum install -y sshpass
for i in {12..120}; do sshpass -p 123456 ssh-copy-id -o "StrictHostKeyChecking no" root@192.168.14.$i; done
for i in {133..240}; do ssh 192.168.14.$i "systemctl restart docker"; done
```

## 九、Shell 与子 Shell

```bash
# 以新的子 Shell 进程来执行脚本，脚本里的环境变量更改不会影响当前 shell
sh xx.sh

# 在当前 Shell 进程中执行脚本，变量赋值等操作会直接影响当前 shell
source xx.sh   或   ./xx.sh
```

## 十、实战脚本

### 1. 批量交互增加用户并设置随机密码 `useradd.sh`
```bash
#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
# 循环判断用户输入的用户名是否合法
while true
    do
        # 读取要创建用户名的前缀，判断不能以特殊字符开头
        read -p "Please enter a username prefix(not a special character)：" User
        echo $User | grep -v '^[a-Z0-9]'
        if [ $? -eq 0 ];then
            echo "The format is incorrect, please re-enter！！"
            else
                break
        fi
    done
# 读取要创建的用户数量
read -p "please input crate user num: " Num
for i in `seq $Num`
    do
        id  $User"_"$i >/dev/null 2>&1
        if [ $? -ne 0 ];then
            useradd $User"_"$i >/dev/null 2>&1 && echo $User"_"$i >>/tmp/user.txt && echo "$User'_'$i 用户创建成功" >>/tmp/user.log
            echo "`date +%T`'_'$User"| md5sum | awk '{print $1}' >>/tmp/user_passwd.txt
        fi
    done
rm -r /tmp/zhong_user_passwd.txt >>/dev/null 2>&1
# 拼接两个文件生成最终账号密码文件
paste -d ":" /tmp/user.txt /tmp/user_passwd.txt >>/tmp/zhong_user_passwd.txt && rm -f /tmp/user.txt /tmp/user_passwd.txt
# 批量设置密码
chpasswd </tmp/zhong_user_passwd.txt
echo "The password for the account is /tmp/zhong_user_passwd.txt"
```

## 十一、linux stat 查看文件详细信息

```bash
# stat /tmp/1.cc
 File: `/tmp/1.cc'
 Size: 4          Blocks: 8          IO Block: 4096   regular file
Device: 803h/2051d    Inode: 261989      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2018-08-11 11:14:09.307726283 +0800
Modify: 2018-08-06 16:27:52.630404197 +0800
Change: 2018-08-06 16:27:52.630404197 +0800
```
> Linux 中没有"文件创建时间"概念，只有访问时间、修改时间、状态改变时间。若文件创建后从未修改过，则修改时间=创建时间；若状态从未改变，则状态改变时间=创建时间；访问时间=创建时间基本不可能。

**与文件相关的几个时间：**
- **Access 访问时间**：读一次文件内容就更新（如 `more`、`cat`）；`ls`、`stat` 不会修改访问时间。
- **Modify 修改时间**：文件内容修改一次就更新（如 `vi` 保存）；`ls -l` 列出的就是此时间。
- **Change 状态改动时间**：文件 i 节点最后一次被修改的时间，通过 `chmod`、`chown` 修改属性时更新。

**查看方式：**
```bash
ls -lc filename   # 列出文件的 ctime（最后更改时间）
ls -lu filename   # 列出文件的 atime（最后存取时间）
ls -l  filename   # 列出文件的 mtime（最后修改时间）
```
> 系统中文件内容数据与 i 节点数据是分别存放的，i 节点数据存放文件权限与属主等信息。

## 十二、考题（面试题）

1. 在 shell 编程中，访问变量值需在变量前加的符号是 **`$`**。
2. 说出 shell 的种类及常用 shell：
```bash
[root@ckh scripts]# cat /etc/shells
/bin/sh
/bin/bash
/sbin/nologin
/bin/dash
/bin/tcsh
/bin/csh
/bin/zsh
```
- **bash**：大多数 Linux 系统默认使用的 shell
- **csh**：类 C 语法风格的 shell
- **tcsh**：csh 的增强版，完全兼容
- **sh**：快捷方式，已被 `/bin/bash` 取代
- **zsh**：目前最庞大的 shell，84 个内部命令，使用较复杂
3. shell 变量 `$# $@ $0 $1 $2` 含义？
```bash
$@   以列表形式返回参数列表
$#   返回参数个数
$0   文件名称
$1 $2  第1个参数、第2个参数
```
4. 编写脚本：每天凌晨 0 点将 `/root/data` 备份到 `/root/data_bak/yyyyMMdd`（按日期新建文件夹）。
```bash
cat > /server/scripts/bak-data.sh <<EOF
#!/bin/bash
DATE=`date +%Y%m%d`
mkdir -p /root/data_bak/$DATE
cp -r /data /root/data_bak/$DATE
EOF
crontab -e
00 00 * * * /bin/sh /server/scripts/bak-data.sh >/dev/null 2>&1
```
5. Linux 从后台启动进程应在最后加符号 **`&`**。
6. shell 中变量赋值四种方法，其中 `name=12` 属于 **A 直接赋值**（其余：B `read` 命令、C 命令行参数、D 命令输出）。
7. Linux 启动的第一个进程 init 启动的第一个脚本程序：
```bash
CentOS 6: 第一个进程是 init，init 启动的第一个脚本通常是 /etc/rc.d/rc.sysinit。
CentOS 7: 第一个启动的是 systemd，其启动的第一个脚本通常是 /etc/systemd/system/default.target
```
8. 查看所有 java 进程：
```bash
ps -ef | grep java | grep -v grep
```
9. 设计一个 shell 程序：添加新组 `class1`，再添加属于该组的 30 个用户，用户名为 `stdxx`（xx 从 01 到 30）。
```bash
#!/bin/bash
export PATH=$PATH
groupadd class1; echo std{01..30} | xargs -n1 | sed 's#.*#useradd -g class1 &#g' | bash
```
10. shell 比较运算符中，数值测试"等于则为真"的是 **`-eq`**。
11. 把当前目录（含子目录）下所有 `.sh` 后缀改为 `.shell`：
```bash
find /tmp -type f -name "*.sh" | awk -F. '{print $1}' | sed -r 's#.*#mv &.sh &.shell#g' | bash
find /tmp -type f -name "*.shell" | sed -r 's#(.*)(.shell)#mv & \1.sh#g' | bash
```
12. 判断一个文件是不是字符设备文件，如果是则拷贝到 `/dev` 目录：
```bash
[root@ckh scripts]# cat cp.sh
    #!/bin/bash
    # cp.sh
    echo -e  "please input filename  /n"
    read FILENAME
    # [ -c FILENAME ] 判断是否为字符设备文件，是则为真
    if [ -c $FILENAME ];then
     cp $FILENAME /dev
    else
     echo "It's not Charactor device file"
    fi
```
13. 编写脚本，每天凌晨 0 点将 `/root/data` 备份到 `/root/data_bak/yyyyMMdd`。（同第 4 题）
14. 使用 for 循环在 `/opt` 下通过随机 10 个小写字母 + 固定字符串 `test` 批量创建 10 个 html 文件，完成后将 `test` 改为 `test_done`，并 html 大写：
```bash
cd /opt
for i in `ls`
 do
  touch  `mkpasswd -l 10 -s 0 -d 0 `test.html
  #-l 要求的长度  -s 不允许重复  -d 不允许数字
  i=`echo $i|cut -c-14`   # 取出前14个字符
  mv $i".html"  $i"_done.html"   # 名字全部替换
 done
```
15. 写一个脚本判断 `192.168.1.0/24` 网络中当前在线的 IP：
```bash
#!/bin/bash
for (( i==1;i<=254;i++))
 do
    ping -c 2 -w 2 192.168.1.$i
    if [ $? -ne 0 ];then
        echo "192.168.1.$i 该ip不通"
    else
        echo "192.168.1.$i" >>/tmp/ip.txt
    fi
    echo -e "\n"
 done
```
16. 用 shell 写 99 乘法表：
```bash
[root@oldboy01 scripts]# cat 991.sh
    #!/bin/bash
    for ((i=1;i<=9;i++))
    do
        for ((j=1;j<=i;j++))
        do
            if [ $j -eq $i ];then
                echo $j"*"$i"="`echo $(($j * $i))`
            else
                echo -en $j"*"$i"="`echo $(($j * $i))`"\t"
            fi
        done
    done
[root@oldboy01 scripts]# cat 992.sh
    #!/bin/bash
    for ((i=1;i<=9;i++))
    do
        for ((j=1;j<=i;j++))
        do
            echo -en $j"*"$i"="`echo $(($j * $i))`"\t"
        done
        echo ""
    done
```
17. 判断数字大于 500 则执行 `big.sh`，小于等于 500 则退出脚本并输出报错信息：
```bash
[root@ckh scripts]# cat big.sh
    #!/bin/bash
    echo "我是 big.sh"
[root@ckh scripts]# cat pan.sh
    #!/bin/bash
    export path=$PATH
    read -t 5 -p "please input a number:" n1
    if [ $n1 -gt 500 ];then
        /bin/sh /server/scripts/big.sh
    else
        echo "num1<500"
    fi
```

> 更新：2024-08-21 19:56:12
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/cuqxz7>
