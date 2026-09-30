# day29 shell编程 变量 if

如何杀死僵尸进程

```
ps lax | egrep 'zombie|TIME'


最简单粗暴的方法，重启服务器。当然此方法弊端明显，服务器焉能随便重启，如此之 low 的方法，几乎不在我们
的考虑范围之内。

解决方案 1 - 直接杀死父进程
kill -9 pid

解决方案 2 - 手动向父进程传递 SIGCHLD 信号
kill -s SIGCHLD pid # 这里的 pid 指定的是父进程的 pid
如果上述命令未能杀死僵尸进程，可以再退一步，比如重启父进程，如过仍然不行，则考虑采用方案 1

```

回顾

如何查询系统性能命令：

```bash
cpu : lscpu /proc/cpuinfo w uptime top htop lm_sen*  vmstat sar
磁盘：df du iotop  dd
内存：iotop free  ps aux top htop
网络 iftop netstat  ss nmap
raid magecli
硬件 ipmatop
```



# 为什么要使用shell编程？
节约时间  减少重复工作

```BASH
# vim /etc/init.d/functions  # 系统的shell脚本

# ll /etc/init.d/functions
-rw-r--r-- 1 root root 25427 Aug 15 18:26 /etc/init.d/functions


```



## 书写脚本
```bash
#！/bin/bash   #脚本默认的命令解释器 开头写
#! /usr/bin/python
# file cal.sh
cal.sh: Bourne-Again shell script text executable

```







```bash
# sh bak-etc.sh  #执行脚本  -x 查看执行过程
/bin/sh -x bak-etc.sh

# cat bak-etc.sh
# !/bin/bash
PATH=$PATH
#get ip address
ip=`hostname -I|awk '{print $1}'`

#mkdir && backup
mkdir -p /backup/$ip
tar zcf /backup/$ip/etc-`date  +%F`.tar.gz   /etc/



```



## 变量 特殊变量


```bash
什么是变量？
	x + y =10  x=20  y=? 未知数（变量）
变量相当于是藏金阁里面的武功秘籍： bao

变量          书名： bao
使用变量				看书： $bao
修改变量				bao=”欲练此功必先自宫不子宫也能成功”

变量命令规则： 不能以数字开头

变量分类：
	普通变量 （局部变量）
		ip  oldboy   IP
	环境变量 （全局变量）
		1  大写
		2  系统定义的
		2  在大部分可以使用
PATH  PS1  LANG


# #env 显示系统所有环境变量名
env | awk -F'[=]' '{print $1}'  
env|sed 's#=.*##g'
env|egrep '^[A-Z0-9_]+'
env|egrep '^[^=]+' -o

局部变量和全局变量区别
# vim show.sh
# OLDBOY=10
# echo $OLDBOY
10
# /bin/sh show.sh
# export OLDBOY=10  #声明全局变量  环境变量
# /bin/sh show.sh
10
# env |grep -i oldboy  # 检查环境变量
HOSTNAME=oldboy01
OLDBOY=10
# unset OLDBOY   #取消变量
# OLDBOY=10
# source show.sh   #相当于是在当前环境执行
10
# . show.sh 		 #  等于 source
10

特殊变量 *** (重点)
# week=6
# echo $week
6
# echo $weekday

# echo $week'day'
6day
# echo ${week}day
6day





做一个计算器
# awk 'BEGIN{print 1/3}'
0.333333
# awk -v num1=10 'BEGIN{print num1}'
10
# awk -vnum1=10 -vnum2=20 'BEGIN{print num1/num2}'
0.5
# awk -v{n1=10,n2=20} 'BEGIN{print n1/n2}'
0.5
书写脚本计算10与20的加减乘除  cal.sh
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


特殊符号： $1 $2 第一个参数 第二个参数
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

通过命令行传递参数方式进行计算
# sh cal.sh 10 20
```







# vim快捷操作 批量删除  批量添加
```bash
1 进入批量编辑模式（可视块） ctrl +v
2 选择 批量增加的范围
3 按 shift + i 进行修改
4 按esc 退出等等
vim快捷键 小r   替换当前光标字符   不进入编辑模式


```

#### 


特殊变量小结：



```bash
$1 $2      awk :第1列 第2列
		 shell脚本： 第1个参数
$0           awk： 整行
		 shell脚本：文件名称
$#	脚本参数的个数
$?  它表示上一个命令的退出状态码。（返回值）0正确 非0执行失败 判断上一个命令是否正确
$@ 以列表的形式返回参数列表
---------------------------------------------------------------------------
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
# echo $?  # 表示上一个命令的退出状态码。
127

# 通过read 交互式传递变量
read -p "input num1:" n1   # -p 显示
input num1:oldboy
# echo $n1
oldboy
#  -s 不显示输入的密码 –t 超时时间
read -s -t 5 -p "input passwd:" p

cal-read.sh 通过read命令实现 n1 n2赋值
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







# 判断 if
```bash
#1. 如果/oldboy 目录存在 显示 /oldboy dir exist
# ls /oldboy && echo /oldboy dir exist
#[ -d /oldboy ] && echo '/oldboy dir exist'
/oldboy dir exist

#2 如果/oldboy 不存在   则创建这个目录
ls /oldboy || mkdir -p /oldboy
[ -d /oldboy2 ] || mkdir -p /oldboy2

# 条件表达式
[ -d /oldboy ]
[ -f /oldboy ]
[ -d /oldboy50 ]
# echo $?    #目录存在返回0
0
# [ -d /oldboy5 ]
# $cho $?   # 目录不存在返回 非0

# 比大小
-eq         equal         ==
-ne     not equal         !=
-gt     great than        >
-ge     great equal       >=
-lt     less  than        <
-le     less  equal       <=

if 判断 ******
if [ 条件 ];then
	命令
fi



参数个数必须是2个
cat > geshu.sh <<EOF
# !/bin/bash
if [ $# -ne 2 ];then
	echo "参数个数必须是2个"
fi
EOF

# 给计算器增加一个条件  判断脚本的参数个数， 如果不是2则 提示请输入两个数字
cat > cal.sh <<EOF
#!/bin/bash
if [ $# -ne 2 ];then
echo "USAGE:$0 num1 num2"
	exit  #提前退出
fi
n1=$1
n2=$2
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1+n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1-n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1*n2}'
awk -vn1=$n1 -vn2=$n2 'BEGIN{print n1/n2}'
EOF


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


# 测试表达式(条件表达式)
[ -z ]  # 字符串空返回真
[ -d ]
[ -f ]
-eq         equal         ==
-ne     not equal         !=
-gt     great than        >
-ge     great equal       >=
-lt     less  than        <
-le     less  equal       <=
man bash


多分支
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

# sh  comp-multi.sh 19 29
19 <29

```





# for 循环




```bash
for 变量  in  列表
do
命令
done

for tao  in  girl{01..9999}
do
echo $tao
done

```



# 批量分发公钥 不用输入手工输入密码方法
```bash
ssh-keygen -t  rsa
yum install -y sshpass

for i in {12..120}; do sshpass -p 123456 ssh-copy-id -o "StrictHostKeyChecking no" root@192.168.14.$i; done

for i in {133..240}; do ssh 192.168.14.$i "systemctl restart docker"; done


```





shell 与子 shell

```bash
# 以新的子 Shell 进程来执行脚本 
# 脚本的环境变量更改,不会影响但钱shell进程
sh xx.sh  


#在当前 Shell 进程中执行脚本。
# 这使得脚本中的环境变量更改、变量赋值等操作会直接影响到当前 Shell 进程。
source xx.sh 或 “./xx.sh
```





# 批量交互增加用户设置随机密码useradd.sh
```bash
#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
#循环判断用户输入的用户名是否合法
while true
	do
		#读取要创建用户名的前缀,然后判断用户名称不能一特殊字符开头
		read -p "Please enter a username prefix(not a special character)：" User
		echo $User | grep -v '^[a-Z0-9]'
		if [ $? -eq 0 ];then
			echo "The format is incorrect, please re-enter！！"
			else
				break 
		fi
	done
#先读取要创建的用户数量
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
# paste两个文件进行拼接新文件
paste -d ":" /tmp/user.txt /tmp/user_passwd.txt >>/tmp/zhong_user_passwd.txt && rm -f /tmp/user.txt /tmp/user_passwd.txt
#批量的设置密码
chpasswd </tmp/zhong_user_passwd.txt
echo "The password for the account is /tmp/zhong_user_passwd.txt"

```





# linux stat查看文件详细信息
```bash
# stat /tmp/1.cc  
 File: `/tmp/1.cc'
 Size: 4          Blocks: 8          IO Block: 4096   regular file
Device: 803h/2051d	Inode: 261989      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2018-08-11 11:14:09.307726283 +0800
Modify: 2018-08-06 16:27:52.630404197 +0800
Change: 2018-08-06 16:27:52.630404197 +0800

在Linux中，没有文件创建时间的概念。只有文件的访问时间、修改时间、状态改变时间。
也就是说不能知道文件的创建时间。
但如果文件创建后就没有修改过，修改时间=创建时间;
如果文件创建后，状态就没有改变过，那么状态改变时间=创建时间;
如果文件创建后，没有被读取过，那么访问时间=创建时间，这个基本不太可能。

##与文件相关的几个时间：
> * 1、Access 访问时间，读一次这个文件的内容，这个时间就会更新。比如对这个文件使用more、cat命令。ls、stat命令都不会修改文件的访问时间。
> * 2、Modify 修改时间，对文件内容修改一次，这个时间就会更新。比如：vi后保存文件。ls -l列出的时间就是这个时间。
> * 3、Change 状态改动时间。是该文件的i节点最后一次被修改的时间，通过chmod、chown命令修改一次文件属性，这个时间就会更新。
##另个除了可以通过stat来查看文件的mtime,ctime,atime等属性，也可以通过ls命令来查看，具体如下:
>ls -lc filename 列出文件的 ctime （最后更改时间）
>ls -lu filename 列出文件的 atime（最后存取时间）
>ls -l filename 列出文件的 mtime （最后修改时间）
 
 
在linux中stat函数中，用st_atime表示文件数据最近的存取时间(last accessed time)；
用st_mtime表示文件数据最近的修改时间(last modified time)；
使用st_ctime表示文件i节点数据最近的修改时间(last i-node's status changed time)。
 
在linux系统中，系统把文件内容数据与i节点数据是分别存放的，i节点数据存放了文件权限与文件属主之类的数据。


```





# 考题


5.在shell编程中，如果要访问变量值，可以在变量前面加一个______符号 $

6.说出shell的种类，以及常用的shell

```bash
[root@ckh scripts]# cat /etc/shells
/bin/sh
/bin/bash
/sbin/nologin
/bin/dash
/bin/tcsh
/bin/csh
/bin/zsh
 
bash 大多数linux系统默认使用的shell
csh  c shell 使用的是类c 语法 像c语言风格的一种shell
tcsh  是csh 的增强版，与c shell完全兼容
sh    快捷方式 已经被/bin/bash 取代
zsh   目前linux里最庞大的一种shell， 84个内部命令，使用起来比较复杂。


```



7.linux中shell变量$# $@ $0 $1 $2的含义解释?

```bash
	$@  以列表形式返回参数列表
	$#  返回参数个数
	$0	文件名称
	$1 $2  第1个参数 第2个参数
  
```



8.请编写一个脚本，

每天凌晨0点将/root/data目录下的所有文件及文件夹备份到/root/data_bak/yyyyMMdd文件夹下，启动yyyyMMdd为以日期命名的文件夹，即每天需要新生成一个文件夹用于备份数据



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



9.linux从后台启动进程应在最后加一个什么符号  答: &

10.在shell中变量的赋值有四种方法，其中。采用name=12 的方法

A 直接赋值      ****

B 使用read命令

C 使用命令行参数

D 使用命令的输出



11.Linux启动的第一个进程init启动的第一个脚本程序是  

```bash
CentOS 6: 启动的第一个进程是 init，init 启动的第一个脚本程序通常是 /etc/rc.d/rc.sysinit。

centos7: 第一个启动的是systemd
systemd 启动的第一个脚本程序通常是 /etc/systemd/system/default.target
```

12.写出命令，查看所有java进程



```bash
ps -ef|grep gava |grep -v grep
```





2.设计一个shell程序，添加一个新组为class1，然后添加属于这个组的30个用户，用户名的形式为stdxx 其中xx从01到30

```bash
#!/bin/bash
export PATH=$PATH
groupadd class1;echo std{01..3}|xargs -n1|sed 's#.*#useradd -g class1 &#g'|bash
  
```



3.在shell比较运算符中，数值测试“等于则为真”的是  答:  [  -eq   ]

5.把当前目录（包含子目录）下所有后缀为“.sh”的文件后缀改为“.shell”

```bash
find /tmp -type f -name "*.sh" |awk -F. '{print $1}'|sed -r 's#.*#mv &.sh &.shell#g'|bash
find /tmp -type f -name "*.shell"|sed -r 's#(.*)(.shell)#mv & \1.sh#g'|bash

```

6.用Shell 编程，判断一个文件是不是字符设备文件，如果是将其拷贝到/dev目录下面

```bash
[root@ckh scripts]# cat cp.sh  
 	#!/bin/bash
 	# cp.sh
 	#输出提示
 	echo -e  "please input filename  /n"
 	#判断是哪个文件？ 可以用read命令从键盘上获取文件名
 	read FILENAME
 	# 如何判断是否字符文件 ，使用系统内置命令 test
 	#其中有[ -c FILENAME ]这个命令就是判断FILENAME是否是字符设备,如果是为真;如果不是为假;
 	if [ -c $FILENAME ];then
   cp $FILENAME /dev
 	else
   echo "It's not Charactor device file"
 	fi
  
```



7.请编写一个脚本，每天凌晨0点将/root/data目录下的所有文件及文件夹备份到/root/data_bak/yyyyMMdd文件夹下，启动yyyyMMdd为以日期命名的文件夹，即每天需要新生成一个文件夹用于备份数据

8.请写出下列shell脚本：使用for循环在/opt目录下通过随机小写10个字母加固定字符串test批量创建10个html文件，创建完成后将test全部改为test_done(for循环实现)，并html大写



```bash
cd /opt
	for i in `ls`
 do
  touch  `mkpasswd -l 10 -s 0 -d 0 `test.html
  #-l 表示要求的长度
  #-s 表示不能有相同的
  #-d 表示不能有数字
   #echo $i  #测试i的值有没有取出来
   i=`echo $i|cut -c-14`#表示取出前14个字符
   #echo $i  #测试前14个字符取出的是否有误
   mv $i".html"  $i"_done.html" #名字全部替换
 done
```



9.写一个脚本实现判断192.168.1.0/24 网络里，当前在线的ip有哪些



```bash
#!/bin/bash
	for (( i==1;i<=254;i++))
  do  
	pint -c 2 -w 2  192.168.1.$i
	-c#表示执行的数次
	-w表示执行的期限，以秒为单位
	if [ $? -ne 0 ];then
	echo "192.168.1.$i 该ip不通"
	else
	echo "192.168.1.$i" >>/tmp/ip.txt
	fi
	echo -e "\n"
	done
```



1.使用shell写一个99乘法表



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



4.判断数字大于500则执行big.sh  小于等于500则退出脚本，并输出报错信息	

```bash
[root@ckh scripts]# cat big.sh
	#!/bin/bash
	echo "我是 big.sh"
	[root@ckh scripts]# cat pan.sh
	#!/bin/bash
	export path=$PATH
	read -t 5 -p "please input a number:" n1
	#n1=$1
	if [ $n1 -gt 500 ];then
 /bin/sh /server/scripts/big.sh
	else
 echo "num1<500"
	fi
```





> 更新: 2024-08-21 19:56:12  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/cuqxz7>