# shell编程基础6天

# 一、简单介绍Shell

##    1. 为什么学习Shell

       1）减少重复性工作

       2）减少出错

       3）批量管理服务器

       4）提高工作效率

       5）懒

       6）安装系统

       7）初始化操作（优化SSHD、禁止开机服务启动、安装基础软件，iptables，selinux等等）

       8）安装服务、LNMP LAMP （nginx、PHP、MySQL、Tomcat、Keepalived、NFS、Rsync、Zabbix、redis等等）

       9）服务的配置和启动，Python服务启停方式 python3.5 test.py IP 域名  

       10）代码上线

       11）监控（框架、端口、进程、流量 cacti）

       12）日志切割、日志分析（三剑客 grep sed awk）、安全(ELK)

## 2. 学习Shell需要的基础知识

       1) 熟练掌握基础命令

       2）编程思维

       3）熟练掌握VIM

       4）三剑客sed grep awk \*\*\*\*\*

     

## 3. 如何学好Shell（包含了哪些东西）

       1）环境变量

       2）条件表达式

       3）if判断语句

       4）for循环语句

       5）while循环语句

       6）case语句

       7）循环控制命令 continue break exit

       8）读懂编程-框架-思考-自己练习-总结-编程思路（积累）

       注意事项：不能拿别人的来用

   

# 二、初步认识Shell

   1. 什么是Shell

       1）Shell是命令解释器、解释我们输入的命令和程序

       2）Shell交互式模式  Shell等待我们的输入、会执行我们的命令反馈结果

       3）Shell非交互模式  Shell不与我们交互、直接读取我们文件内或程序内的命令

   2. 什么是Shell脚本

       1）就是把Shell可执行命令放入文件里，条件表达式、判断循环等等

   3. 创建Shell脚本（规范）

       1）路径统一（自动化）（log存放的位置、程序安装位置）

          /server/scripts/

       2）开头写解释器注释

           顶头写注释#!/bin/bash，不能写在后面，下面的注释是不执行，是给我们看的，注释还可以写在命令行的后面与命令同行

       3）脚本名以.sh结尾

       4）脚本内写作者版本

           #Version V1.0

           #Author Lizhenya

           #Create Time 2018-11-05

           #QQ:5555555

           #count

       5）每个段的注释

       6）注释尽量不用中文

       7）成对的符号要一次性书写

       8）循环语句一次性书写完毕

# 三、环境变量

## 1.什么是环境变量

       1）x=1 y=x+10 y=？ x 变量 等号是赋值 等号右边的变量的值

       2）等号后面一堆的内容，用一个名字来代替叫做变量

       3）环境变量以生存周期来分类

```
	临时性环境变量 export，关闭shell、变量失效

	export lizhenya=test

	echo $lizhenya

	exit

	echo $lizhenya
```

<font style="background-color:transparent;"></font>

<font style="background-color:transparent;">永久环境变量 需要更改配置文件/etc/profile、永久生效</font>

   4）环境变量生效的顺序

```
  1) /etc/profile  ~/.bash_profile  ~/.bashrc  /etc/bashrc
```

## 2.定义环境变量

   1) 变量名字的写法  字母 数字 下划线的组合，尽量以字母开头、不能以数字开头，等号两边不能有空格，名字的写法

```bash
1. lizhenya=test
2. LizhenYa=test 大驼峰语法
3. lizhenYa=test 小驼峰语法
```

## 3.环境变量三种定义方式

   

```bash
1）数字变量如何定义  lizhenya=123   #  数字必须是连续的
2）字符串变量如何定义

lizhenya="I am lizhenya teacher"  # 默认就加双引号
lizhenya='I am lizhenya teacher'  # 所见即所得、定义什么值输出什么值

[root@m01  ~]# lizhenya=I am lizhenya
-bash: am: 未找到命令
[root@m01  ~]# lizhenya="I am lizhenya"
[root@m01  ~]# echo $lizhenya
I am lizhenya

3）命令变量如何定义  lizhenya=`date` # 反引号 解析命令
```

## 4.Shell特殊位置环境变量

```bash
$0   # 脚本名称、如果你的脚本全路径执行，带全路径脚本名
$n   # 代表了传参的参数 $0 脚本名称，大于9的数字用{10}括起来
$#   # 代表了脚本所有传参的个数
$*    # 脚本中所有传参的参数，不加双引号和$@一样，加了双引号把所有的参数作为一个整体输出
$@  # 脚本中所有传参的参数，不加双引号和$*一样，加了双引号把传参的参数作为单个字符串输出

#将命令行参数设置为 "I am"、lizhenya 和 teacher
#使用特殊变量（如 $1、$2、$3
set -- "I am" lizhenya teacher
# for i in "$*";do echo $i;done
I am lizhenya teacher
# for i in "$@";do echo $i;done
I am
lizhenya
teacher

$* 为 “1 2 3”（一起被引号包住）
$@ 为 “1” “2” “3” （分别被包住）
$?  # 代表了上一次命令执行的结果，0为成功，非零为失败
$$  # 获取当前脚本的PID
$!  # 获取上一个脚本的PID

```

# 5.变量子串

```bash
1. 获取字符串的长度
# 显示定义变量 
export oldboy=mirror
echo ${#oldboy}  #6

2. :  # 字符串切片
substr=${oldboy:0:3}
echo $substr #mir 


3. 扩展题：如何取字符串的长度？
echo ${#oldboy}
echo $oldboy|wc -L
expr length "${oldboy}"
echo $oldboy|awk '{print length($0)}'
  
4. 取小于3的字符串
str="abc"
if [ ${#str} -lt 3 ]; then
    echo "$str"
fi


```

   

# 补充：环境变量

```bash
read从键盘读入变量值
read 变量名  
read -p "提示信息: " 变量名  
read -t 5 -p "提示信息: " 变量名

#示例
cat > first.sh<<\EOF  
back_dir1=/var/backup  
read -p "请输入你的备份目录: " back_dir2  
echo $back_dir1  
echo $back_dir2  
EOF

cat > ping2.sh<<\EOF
#!/bin/bash
read -p "Input IP or : " ip
ping -c2 $ip &>/dev/null
if [ $? -eq 0 ];then
  echo "host $ip is ok"
else
  echo "host $ip is fail"
fi
EOF

注意事项: 定义或引用变量时注意事项： " "弱引用 ' '强引用
# lizhenya=test  
# echo "${lizhenya} is good"  
test is good  

# echo '${school} is good'  
${lizhenya} is good


变量删除替换
1.	从前面往后删除变量内容

url=www.sina.com.cn
#从前往后，最短匹配 ##sina.com.cn
echo ${url#*.}   
#从前往后，最长匹配(贪婪匹配) #cn
echo ${url##*.}

2.	从后往前删除环境变量
url=www.sina.com.cn
echo ${url}
#从后往前，最短匹配 # www.sina.com
# 匹配到.cn， 返回剩余的
echo ${url%.*}
#从后往前，最长匹配 贪婪匹配 # www
# 匹配到.sina.com.cn ，返回剩余的
echo ${url%%.*}

url=www.sina.com.cn
#${parameter#word}这种形式是参数扩展的一种用法，
#它会从 $parameter 代表的字符串开头开始匹配 word，并删除最短匹配的部分然后返回剩余部分。
#它从开头查找 a.，但由于这个字符串中开头并没有 a.，所以返回原字符串
echo ${url#a.}     #www.sina.com.cn
# 它匹配到 www.sina. 返回剩余的
echo ${url#*sina.} #com.cn

3.	内容变量替换
url=www.sina.com.cn  
echo ${url/sina/baidu} #www.baidu.com.cn

url=www.sina.com.cn  
echo ${url/n/N}  #www.siNa.com.cn
#贪婪匹配
echo ${url//n/N} #www.siNa.com.cN

4.	变量自增
a=1
b=1
let x=a++   #a先把值1赋值给x 再自身加一
let y=++b   #b先自增1再复制给y
# echo $a
2
# echo $b
2
# echo $x
1
# echo $y
2

实际案例
cat > i++.sh<<\EOF
#!/bin/sh
IP=8.8.8.8
i=1
while [ $i -le 3 ]
do
       ping -c 1 $IP &>/dev/null
       if [ $? -eq 0 ];then
               echo "$IP is up..."
       fi
       let i++
done
EOF



```

# 五．变量数值运算

```bash
1.整数运算expr + - \* / %
expr 1 + 2  
expr $num1 + $num2

2.整数运算 $(()) + - * / %
echo $(($num1+$num2))  
echo $((num1+num2))  
echo $((5-3*2))  
echo $(((5-3)*2))  
echo $((2**3))  
sum=$((1+2)); echo $sum

3. 整数运算 $[] + - * / %
echo $[5+2]
echo $[5**2]

4. 整数运算 let + - * / %
let sum=2+3;  
echo $sum  
i=1
let i++
echo $i

5. 小数运算 bc + - * / %
echo "2*4" |bc  
echo "2^4" |bc  
echo "scale=2;6/4" |bc  
awk 'BEGIN{print 1/2}'  
echo "print 5.0/2" |python
```

# 六．Shell条件测试

## 1.文件测试

```bash
[ -e dir|file ] 	存在则为真
[ -d dir ] 				目录是否存在
[ -f file ] 			文件是否存在  
[ -r file ] 			文件是否有读权限
[ -x file ] 			文件是否有执行权限
[ -w file ] 			文件是否有写权限

常用测试
# test -d /opt/test
# echo $?
1
# [ ! -d /opt/test ] && mkdir /opt/test
# [ -d /opt/lizhenya ] || mkdir /opt/lizhenya


[ -b FILE ] 如果 FILE 存在且是一个块特殊文件则为真。
[ -c FILE ] 如果 FILE 存在且是一个字特殊文件则为真。
[ -d DIR ]  如果 FILE 存在且是一个目录则为真。
[ -e FILE ] 如果 FILE 存在则为真。
[ -f FILE ] 如果 FILE 存在且是一个普通文件则为真。
[ -g FILE ] 如果 FILE 存在且已经设置了SGID则为真。
[ -k FILE ] 如果 FILE 存在且已经设置了粘制位则为真。
[ -p FILE ] 如果 FILE 存在且是一个名字管道(F如果O)则为真。
[ -r FILE ] 如果 FILE 存在且是可读的则为真。
[ -s FILE ] 如果 FILE 存在且大小不为0则为真。
[ -t FD ]    如果文件描述符 FD 打开且指向一个终端则为真。
[ -u FILE ] 如果 FILE 存在且设置了SUID (set user ID)则为真。
[ -w FILE ] 如果 FILE存在且是可写的则为真。
[ -x FILE ]  如果 FILE 存在且是可执行的则为真。
[ -O FILE ] 如果 FILE 存在且属有效用户ID则为真。
[ -G FILE ] 如果 FILE 存在且属有效用户组则为真。
[ -L FILE ] 如果 FILE 存在且是一个符号连接则为真。
[ -N FILE ] 如果 FILE 存在 and has been mod如果ied since it was last read则为真。
[ -S FILE ] 如果 FILE 存在且是一个套接字则为真。
[ FILE1 -nt FILE2 ] 如果 FILE1 has been changed more recently than FILE2, or 如果 FILE1 exists and FILE2 does not则为真。
[ FILE1 -ot FILE2 ] 如果 FILE1 比 FILE2 要老, 或者 FILE2 存在且 FILE1 不存在则为真。
[ FILE1 -ef FILE2 ] 如果 FILE1 和 FILE2 指向相同的设备和节点号则为真。
```

## 2.数值比较

```bash
数值比较 [ 整数 1 操作符 整数 2 ]  
[ 1 -gt 10 ]   大于        #greater than
[ 1 -lt 10 ]   小于        #less than
[ 1 -eq 10 ]   等于        #be equal to
[ 1 -ne 10 ]   不等于      #Not equal to
[ 1 -ge 10 ]   大于等于    #Greater than or equal to
[ 1 -le 10 ]   小于等于    #Less than or equal to

```

**案例：**

```bash
# 查看磁盘/当前使用状态，如果使用率超过80%则报警发邮件
# 怎么看磁盘使用率，怎么获取对应的值
# cat disk_use.sh  
#!/bin/sh
DATE=$(date +%F)
Disk_Use=$(df -h|grep '/$'|awk '{print $5}'|awk -F% '{print $1}')
if [ $Disk_Use -ge 10 ]
then
   echo "Disk Is use ${Disk_Use}%" >/tmp/${DATE}-diskuse.txt
fi


#案例2 内存超过百分80报警输出
# cat memory_use.sh  
#!/bin/sh
Mem_Use=$(free -m|grep ^M|awk '{print $3/$2*100}')
if [ ${Mem_Use%.*} -ge 30 ]
then
   echo "Memory IS ERROR ${Mem_Use%.*}%"
else
   echo "Memory IS OK ${Mem_Use%.*}%"
fi

案例3 自己写一个监控内存状态的脚本
ab -n 200000 -c 2000 http://127.0.0.1/index.html 
案例4 自己用脚本打印出 系统版本 内核版本平台 虚拟平台 静态主机名 eth0网卡IP地址 lo网卡IP地址 当前外网IP地址
curl icanhazip.com

```

## 3.字符串比较

```bash
[ -z STRING ] 如果STRING的长度为零则为真 ，即判断是否为空，空即是真；
[ -n STRING ] 如果STRING的长度非零则为真 ，即判断是否为非空，非空即是真；
[ STRING1 = STRING2 ]  如果两个字符串相同则为真 ；
[ STRING1 != STRING2 ] 如果字符串不相同则为真 ；
[ STRING1 ]  如果字符串不为空则为真,与-n类似

1. 字符串比对、必须加双引号
[ "$USER" = "root" ];echo $?  #0

AAA=""
echo ${#AAA}

#字符长度为 0 返回真 0
[ -z "$AAA" ]
echo $?

#字符长度不为 0 返回真0
[ -n "$AAA" ]
echo $?

[ "$USER" = "root" ];echo $?  #0
[ "$USER" = "lizhenya" ];echo $?    
[ "$USER" != "lizhenya" ];echo $?

```

## 4. 多整数比较

```bash
-a 与
-o 或
! 非

[ 1 -lt 2 -a 5 -gt 10 ];echo $?
[ 1 -lt 2 -o 5 -gt 10 ];echo $?

正则会用到[[]]
[[ 1 -lt 2 && 5 -gt 10 ]];echo $?
[[ 1 -lt 2 || 5 -gt 10 ]];echo $?

```

## 5.正则比对

```bash
#变量$USER的值是否以 “r” 开头。如果匹配成功，条件为真；

[[ "$USER" =~ ^r ]];echo $?

num=123
[[ "$num" =~ ^[0-9]+$ ]];echo $?

num=123a
[[ "$num" =~ ^[0-9]+$ ]];echo $?

#案例：
# cat test01.sh  
#!/bin/sh
read -p "please input number " num
if [[ ! "$num" =~ ^[0-9]+$ ]]
then
   echo "please input 数字"
   exit 1
fi
echo "Number Is $num"
```

## 1.自己用脚本打印出 系统版本 内核版本平台 虚拟平台 静态主机名 eth0网卡IP地址 lo网卡IP地址 当前外网IP地址

```bash
cat > printEnv.sh<<\EOF
#!/bin/bash
System=$(hostnamectl|grep System|awk '{print $3,$4,$5}')
Kernel=$(hostnamectl|grep Kernel|awk -F: '{print $2}')
Vt=$(hostnamectl|grep Virtualization | awk '{print $2}')
Statichostname=$(hostnamectl|grep "Static hostname"|awk '{print $3}')
Etho=$(ifconfig eth0 | awk 'NR==2{print $2}')
Lo=$(ifconfig lo |awk 'NR==2{print $2}')
Network_T=$(curl -s icanhazip.com)

echo "当前系统版本是:$System"
echo "当前系统内核是:$Kernel"
echo "当前虚拟平台是:$Vt"
echo "当前静态主机名是:$Statichostname"
echo "当前Eth0IP地址是:$Eth0"
echo "当前Lo地址是:$Lo"
echo "当前外网地址是:$Network_T"
EOF
```

   

## 2.批量创建添加用户脚本

```bash
cat > useradd.sh <<\EOF
#!/bin/bash
#########################################
# File Name : user.sh
# version: v.1.0
# Author Centos
# Created Time : 2018-11-06
#########################################
read -p "please input number: " num
if [[ ! $num =~ ^[0-9]+$ ]];then
echo echo "please input number: "
     exit 1
fi
read -p "please input prefix: " name
if [[ -z ${#name} ]];then
 echo "请输入 前缀: "
 exit 2
fi
for i in `seq $num`
do
 userfull=$name$i
 useradd $userfull
 if [ $? -eq 0 ];then
  echo "123" |passwd --stdin $userfull &>/dev/null
  echo "$userfull create success"
 fi
done
EOF
```

## 3.猜数字游戏

```bash
随机输出一个1-100的数字 
要求用户输入数字（数字处加判断）  
如果比随机数小则提示比随机数小了 大则提示比随机数大了
正确则退出 错误则继续死循环
最后统计猜了多少次（猜对的情况）

awk 'BEGIN{srand();\
a=int(rand()*100);\
while(1<2)\
{printf"%s",\
"input num:";getline num < "-";\
if(num==a)\
{print "你猜对了";exit}\
else if(num>a){print "你猜大了"}\
else{print "小了"}}}'


awk 算数函数
最常用的算数函数有rand函数、srand函数、int函数。
可以使用rand函数生成随机数，但是使用rand函数时，需要配合srand函数，否则rand函数返回的值将一直不变 
https://www.cnblogs.com/ghostwu/p/9098349.html  #undefined
```

```bash
# cat caishuzi.sh
#!/usr/bin/bash
Rand=$[${RANDOM}%100+1]
i=0
while true
do
 read -p "please input number: " Num
 let i++
 if [[ ! $Num =~ ^[0-9]+$ ]];then
  echo "please check you number!"
  continue
 fi
 if [ $Num -eq $Rand ];then
  echo "恭喜你,答对咯!"
  echo "你一共猜了 $i 次"
  exit 0
 fi
 if [ $Num -gt $Rand ];then
  echo "你输入的数太大了, 试试小一点"
  else echo "你输入的数字太小了,试试大一点"
 fi
done

---------------------------------------------------------------
# cat caishuzi.sh 
#!/bin/sh
num=$(echo $((RANDOM%100+1)))
echo $num
i=1
while true
do
read -p "Please Input number: 1-100: " num1
if [[ ! $num1 =~ ^[0-9]+$ ]];
then
    echo "Please Input number: 1-100"
    continue
fi
if [ $num1 -lt $num ];then
        echo "你输入的数字小了"
elif [ $num1 -gt $num ];then
        echo "你输入的数字大了"
elif [ $num1 -eq $num ];then
        echo "猜中了"
        break
fi
let i++
done
echo "一共猜了 $i 次"



```

# 七、流程控制语句

```bash
单分支结构
if [ 如果你有房 ];then  
   我就嫁给你
fi

双分支结构
if [ 如果你有房 ];then  
       我就嫁给你
   else
       再见
fi

多分支结构
if [ 如果你有房 ];then  
       我就嫁给你
elif [ 你有车 ];then
       我就嫁给你
elif [ 你有钱 ];then
       我就嫁给你
   else
       再见
fi
```

## 案例：根据不同的操作系统安装不同的源

用来获取系统版本 支持 6 7

 uname -r |awk -F '.' '{print $(NF-1)}'

```bash
#!/bin/sh
#Version v1.0
#Author lzy
os_version=$(cat /etc/redhat-release|awk '{print $4}')
if [ "$os_version" = "(Final)" ]
       then
       os_version=$(cat /etc/redhat-release|awk '{print $3}')
fi
if [ ${os_version%%.*} -eq 7 ]
       then
       mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
       wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
       yum makecache
elif [ ${os_version%%.*} -eq 6 ]
       then
       mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
       wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
       yum makecache
elif [ ${os_version%%.*} -eq 5 ]
       then
       mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
       curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
else
       echo "Please check version"
fi
```

## 案例：安装不同的PHP版本

\#通过yum 安装不同的php源

<https://www.cnblogs.com/shifu204/p/7243576.html>

```bash
[root@lizhenya ~]# cat php.sh
#!/usr/bin/bash
#install php
install_php56() {
       yum install epel-release
       rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
       yum install --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof
}
install_php70() {
   echo "install php7.0......"
}
install_php71() {
   echo "install php7.1......"
}
while :
do
   echo "################################"
   echo -e "\t1 php-5.6"
   echo -e "\t2 php-7.0"
   echo -e "\t3 php-7.1"
   echo -e "\tq exit"
   echo "################################"
   read -p "version[1-3]: " version
   if [ "$version" = "1" ];then
       install_php56    
   elif [ "$version" = "2" ];then
       install_php70
   elif [ "$version" = "3" ];then
       install_php71
   elif [ "$version" = "q" ];then
       exit
   else
       echo "error"    
   fi
done

```

## 2.流程控制语句case

case语句

```bash
case 变量 in  
模式 1)  
   命令序列 1;;  
模式 2)  
   命令序列 2;;  
模式 3)  
   命令序列 3 ;;  
*)  
   无匹配后命令序列  
esac
```

### 案例：

```bash
# cat del.sh
#!/usr/bin/bash
read -p "请输入需要删除的用户前缀，以及用户的位数: " delname delnum
echo "你将要删除如下账户
       用户前缀是: $delname
       用户的个数: $delnum
"
read -p "你确定要删除吗[y|Y|Yes|n|N|NO]?" reday
for i in $(seq $delnum);do
        userfull=$delname$i
        case $reday in y|Y|YES)
                id $userfull &>/dev/null
                if [ $? -eq 0 ];then
                        userdel $userfull &>/dev/null
                        echo "userdel is ok $userfull...."
                else
                        echo "$userfull" no such user
                fi;;
                n|N|no|NO|No)
                        exit 1;;
               *)
               read -p "你确定要删除吗[y|Y|Yes|n|N|NO]?" reday
       esac
done

```

案例：

```bash
# cat caidan.sh  
#!/usr/bin/bash
caidan(){
cat <<EOF
===================
h 显示命令帮助    
f 显示登陆信息  
d 显示磁盘挂载  
m 查看内存使用  
u 查看系统负载  
q 退出程序
=====================
EOF
}

caidan
while true
do
	read -p "请输入你想查看系统状态对应码[d/m/u/q]: " sys
	case "$sys" in  
		h)
			clear
			caidan
			;;
		f)
			clear
			w
			;;
		d)
			clear
			df -h
			;;
		m)
			clear
			free -m
			;;
		u)
		   clear
		   uptime
		   ;;
		q)
		   break
		   ;;
		*)
		   echo "error"
		   exit 1;
	esac
done
```

### 案例 jumpserver简单实现

```bash
trap
信号说明
HUP(1)    挂起，通常因终端掉线或用户退出而引发
INT(2)    中断，通常因按下Ctrl+C组合键而引发
QUIT(3)   退出，通常因按下Ctrl+组合键而引发
ABRT(6)   中止，通常因某些严重的执行错误而引发
ALRM(14)  报警，通常用来处理超时
TERM(15)  终止，通常在系统关机时发送
SIGTSTP   停止进程    终端来的停止信号

# cat ~/jumpserver.sh  
#!/usr/bin/bash
#jumpServer  
Mysql_master=10.0.0.10
Mysql_slave1=10.0.0.11
Mysql_slave2=10.0.0.12
Nginx_Up=10.0.0.6
Nginx_WEB1=10.0.0.7
Nginx_WEB2=10.0.0.8
meminfo(){
cat <<EOF
-------------------------------
|       1) mysql-master         |
|       2) mysql-slave1         |
|       3) mysql-slave2         |
|       4) Nginx-Upstream       |
|       5) Nginx-WebNode1       |
|       6) Nginx-WebNode2       |
|       h) help                 |
---------------------------------
EOF
}
#调用函数打印菜单
meminfo
#控制不让输入ctrl+c,z
trap "" HUP INT TSTP

while true
do
  read -p "请输入要连接的主机编号: " num
  case $num in  
    1|mysql-master)
      ssh root@$Mysql_master
      ;;
    2|Mysql_slave1)
      ssh root@$Mysql_slave1
      ;;
    3|Mysql_slave2)
      ssh root@$Mysql_slave2
      ;;
    h|help)
      clear
      meminfo
      ;;
    #退出脚本后门, 不要让其他人知道
    exec)
      break
      ;;
  esac
done
```

### 案例：

```bash
# cat start_nginx.sh
#!/usr/bin/bash
# manager Nginx start stop restart reload
source  /etc/init.d/functions
act=$1

te(){
if [ $? -eq 0 ];then
	action "Nginx Is $act" /bin/true
else
	action "Nginx Is $act" /bin/false
fi
}

start(){
	/usr/sbin/nginx &>/dev/null
	te
}
stop(){
	/usr/sbin/nginx -s stop &>/dev/null
	te
}
reload(){
	/usr/sbin/nginx -s reload
	te
}
status(){
	Ngx_status=$(ps aux|grep "[n]ginx"|grep master|awk '{print $2}')
	Nginx_Status_Port=$(netstat -lntp|grep nginx|awk '{print $4}')
	echo "Nginx_status_Pid: $Ngx_status"
	echo "Nginx_status_Port: $Nginx_Status_Port"
}
case $1 in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		sleep 1
		start
		;;
	reload)
		reload
		;;
	status)
		status
		;;
	*)
	echo "Usage: $0 {start|stop|status|restart|reload|}"
esac
```

## 3.交互脚本expect

### 1.简单实现面交互登陆

```bash
# yum install expect
#!/usr/bin/expect
spawn ssh root@10.0.0.11
expect {
  "yes/no" { send "yes\r"; exp_continue };
  "password:" { send "1\r" };
}
interact

# 运行方式
# expect 脚本名称.sh #或者去掉expect也行
```

### 2.expect定义变量实现交互方式

```bash
#!/usr/bin/expect
set ip 10.0.0.11
set user root
set password 1
set timeout 5
spawn ssh $user@$ip
expect {
  "yes/no" { send "yes\r"; exp_continue }
  "password:" { send "$password\r" };
}  
#交互方式
interact
```

# 八、For循环

## 1.for循环语法

```bash
for 变量名  in [ 取值列表 ]  
do  
   循环体
done
```

### 案例1：

```bash
[root@lizhenya ~]# cat ping.sh  
#!/bin/
#循环主机
for i in {1..254}
do       #并发执行
  {    
    IP=39.107.76.$i
    ping -c1 $IP &>/dev/null
    if [ $? -eq 0 ];then
      echo "$IP" >>ip.txt
    fi
  }&
done
  wait  #等待上面的并发执行完再执行下面的语句
  echo "获取在线IP完成"
```

### 案例2

```bash
#!/bin/sh
for i in `cat user.txt`
do
  id $i &>/dev/null
  if [ $? -ne 0 ];then
    useradd $i
    echo "123"|passwd --stdin $i &>/dev/null
    echo "Create $i OK"
  else
    echo "useradd: $i already exists"
  fi
done
```

## 2.while循环

```bash
while循环基础语法
# 当条件测试成立（条件测试为真），执行循环体
while 条件测试  
do  
   循环体  
done

```

### 案例1：用while创建用户

```bash
# cat scripts/while.sh  
#!/bin/sh
while read line
do
  id $line &>/dev/null
  if [ $? -eq 0 ];then
    echo "useradd: user $line already exists"
  else
    useradd $line
    if [ $? -eq 0 ];then
      echo "create $line success"
    fi
  fi
done<user.txt

#文件中存在用户和密码
# cat while1.sh  
#!/bin/sh
while read user
do
  u=$(echo $user|awk '{print $1}')
  p=$(echo $user|awk '{print $2}')
  id $u &>/dev/null
  if [ $? -ne 0 ];then
    useradd $u
    echo $p|passwd --stdin $u &>/dev/null
    echo "Create $u is ok"
  else
    echo "useradd: $u already exists"
  fi
done<user.txt
```

# 九．Shell内置命令

exit 退出整个程序  

break 结束当前循环，或跳出本层循环

continue 忽略本次循环剩余的代码，直接进行下一次循环

## exit示例

```bash
# cat exit.sh  
while true
do
  echo "123"
  exit
  echo "456"
done
echo "done..."

# 执行后的结果
[root@lizhenya ~]# sh exit.sh  
123

# break示例
[root@lizhenya ~]# cat break.sh  
while true
do
  echo "123"
  break
  echo "456"
done
echo "done..."

#执行后的结果
# sh break.sh  
123
done...

# continue 示例  
# 假如创建前创建一个test1 break会直接跳出循环、continue会跳出继续循环
# cat continue.sh  
#!/bin/sh
for i in `seq 10`
do
  useradd test$i
  if [ $? -eq 0 ];then
  echo "Create $i Success"
  else
    continue
  fi
done
```

# 九、函数

## 1.Shell中函数的作用

1.命令合集，完成特定功能的代码块

2.在shell中定义函数可以使用代码模块化, 便于复用代码,加强可读性

3.函数和变量类似, 先定义才可调用，如果定义不调用则不会被执行

传参 $1,$2

变量 local

返回值 return $?

## 2. 如何定义和调用函数

```bash
# 方式一
函数名() {
   command
}
# 方式二
function 函数名() {  
   command
}

调用函数非常简单, 只需要在脚本中写入函数的名称即可
// 在脚本中直接写入函数名即可完成函数调用
function_name
```

## 3.函数传参

fun $1  传入脚本后第一个参数

fun $\*  接收所有参数的传递

### 案例：

```bash
# cat fun3.sh  
# 函数判断
t_file(){                  
  if [ -f $1 ];then
    echo "$1 exists"
  else
    return 1
  fi
}
# 调用函数
t_file  $1
```

1.

```bash
# cat fun.sh  
#!/bin/sh
# 定义一个函数
count01(){
num=10
for i in `seq 10`
do
  total=$[$i + $num]
done
  echo "计算结果是: $total"
}
count01    #  调用函数

# sh fun.sh  
计算结果是: 20
```

2.

```bash
# cat fun.sh  
#!/bin/sh
count01(){
for i in `seq 10`
do
  total=$[$i + $num]
done
  echo "计算结果是: $total"
}

num=10
count01

[root@lizhenya ~]# sh fun.sh  
计算结果是: 20
```

3.

```bash
# cat fun.sh  
#!/bin/sh
count01(){
num=$1
for i in `seq $num`
do
  total=$[$i + $num]
done
  echo "计算结果是: $total"
}
count01 $1
count01 $2
count01 $3

# sh fun.sh 10 20 30
计算结果是: 20
计算结果是: 40
计算结果是: 60

```

### 传参使用场景：

```bash
# cat nginx.sh  
source /etc/init.d/functions
Test() {
  if [ $? -eq 0 ];then
    action "Nginx $1 is ok" /bin/true
  else
    action "Nginx $1 is error" /bin/false
  fi
}
case $1 in
  start)
    nginx
    Test $1
    ;;
  stop)
    nginx -s stop
    Test $1
    ;;
  reload)
    nginx -s reload
    Test $1
    ;;
  *)
  echo "USAGE: $0 { start|stop|reload }"
esac

```

### 函数的返回值

echo 返回函数返回值

return 返回指定函数退出状态码

1.

```bash
# cat fun2.sh  
fun2() {
  echo 100
  return 1
}
result=`fun2`
echo "函数的状态码是: $?"
echo "函数的返回值是: $result"

# sh fun2.sh  
函数的状态码是: 1
函数的返回值是: 100
```

2.

```bash
# cat fun3.sh  
file=/etc/ttt               # 定义文件
t_file(){                   # 函数判断
  if [ -f $file ];then
    return 0
  else
    return 1
  fi
}
# 调用函数
t_file
#根据函数返回状态码进行输出
if [ $? -eq 0 ];then
  echo "该文件存在 $file"
else
  echo "该文件不存在 $file"
fi

```

3. 统计文件行

```bash
# cat read.sh  
#!/bin/sh
File=/etc/passwd
function count(){
  local i=0
  while read line
  do
    let ++i	
  done<$File
  echo $i
}

```

# 十、Shell数组的应用

## 1.数组的分类

普通数组：只能使用整数 作为数组索引  

关联数组：可以使用字符串 作为数组索引

## 2数组赋值方式一, 针对每个索引进行赋值

```bash
#数组名[索引]=变量值
arraytest[0]=zhangsan
arraytest[1]=lisi
arraytest[2]=laowang

```

## 3数组赋值方式二, 一次赋多个值

```bash
#数组名=(多个变量值)
array=(1 2 3)
array=(1 2 3 "test" [10]=oldboy)

```

## 4.查看数组赋值结果

```bash
declare -a     #查看普通数组
declare -A     #查看关联数组

5.如何访问数组中的元数
echo ${array[0]}  	#第一个元素
echo ${array[@]} 		#访问数组所有的元素
echo ${#array[@]}   #统计元素的个数

```

## 6.	如何访问数组中的索引

```bash
# 获取数组元素的索引 !
echo ${!array[@]}


```

## 7.	关联数组

```bash
1.定义关联数组，申明是关联数据
declare -A array_1
declare -A array_2

2.关联数组的赋值方式一，针对每个索引进行赋值
#数组名[索引]=变量值
declare -A array_1
declare -A array_2
array_1[index1]=zhangsan
array_1[index2]=lisi
array_1[index3]=laowang

3.关联数组的赋值方式二，一次赋多个值
declare array_2=([index1]=oldboy [index2]=li [index3]=zhang)
declare -A

3.访问数据元素
echo ${array_2[index2]}
echo ${array_2[@]}      
echo ${!array_2[@]}  

```

## 8.	遍历数组

已知文件里有名字对应的性别 请统计性别出现的总次数

```bash
let array_pa[m]++
let array_pa[f]++
let array_pa[x]++
let array_pa[m]++

cat > sex.txt<<EOF  
zs m
ls m
lw f
ll m
lz f
lq m
EOF

cat > count_sex.sh<<\EOF  
#!/bin/sh
declare -A sex
while read line
do
  type=$(echo $line|awk '{print $2}')
  let sex[$type]++
done<sex.txt
#遍历数组
for i in ${!sex[*]}
do
  echo $i共有${sex[$i]}个
done
EOF

```

案例2

```bash
# 统计nginx日志IP访问次数
# cat nginx_count.sh  
#!/bin/sh
declare -A array_nginx
while read line
do
  type=$(echo $line|awk '{print $1}')
  let array_nginx[$type]++
done</var/log/nginx/access.log

for i in ${!array_nginx[*]}
do
  echo "IP是 $i 共出现了${array_nginx[$i]}次"
done
```

案例3

统计tcp状态信息

```bash
# cat nginx_status.sh  
#!/bin/sh
declare -A array_nginx
type=`ss -an|grep 80|awk '{print $2}'`
for i in $type
do
  let array_nginx[$i]++
done

for n in ${!array_nginx[*]}
do
  echo $n ${array_nginx[$n]}
done

```

## 条件表达式

条件表达式的值只有真（非0 | 非空 | 条件成立 | $?为0（此条shell特有））、

假（0 | 空 | 条件不成立 | $?不为0（此条shell特有））此规则适用于所有的计算机高级语言

算术运算

逻辑运算

Linux命令

## 选择（分支）

### if

```bash
if 条件表达式;then
  命令
fi
```

```bash
#/bin/bash
http="ss -lntup|grep nginx &> /dev/null"
# eval 将参数作为命令来执行
if eval $http
then
  echo 1
else
  echo 0
fi
```

```bash
st=>start: Start
op=>operation: 命令1
cond=>condition: 条件表达式为真？
e=>end

st->cond
cond(yes)->op->e
cond(no)->e
```

### if else

```bash
if 条件表达式;then
  命令1
else
  命令2
fi
```

```bash
st=>start: Start
op=>operation: 命令1
op2=>operation: 命令2
cond=>condition: 条件表达式为真？
e=>end

st->cond
cond(yes)->op->e
cond(no)->op2->e
```

### if elif else

```bash
if 条件表达式;then
  命令1
elif 条件表达式2;then
  命令2
else
  命令3
fise
```

### case

```bash
case 变量 in 
模式 1) 
    命令序列 1;; 
模式 2) 
    命令序列 2;; 
模式 3) 
    命令序列 3 ;; 
*) 
    无匹配后命令序列 
esac
```

### case

```bash
# cat php-install-case.sh
#!/bin/bash
#version v1.0
cat << EOF
1) install php5.5
2) install php5.6
3) install php7.1
EOF
read -p "please input menu-number: " Number
case $Number in
  1)
	echo "安装 php5.5";;
  2)
	echo "安装 php5.6";;
  3)
	echo "安装 php7.1";;
*)
	echo "你输入的数字不是1-3"
esac
```

### 批量删除用户

```bash
# cat deluser.sh
#!/bin/sh
#Version v1.0
read -p "Please input 前缀和一个数字: " name num
for i in `seq $num`
do
  echo "你确定要删除 $name$i "
done

read -p "Please input [y|Y|yes|n|N|no]" num1
for n in `seq $num`
do
  userfull=$name$n
  case $num1 in	y|Y|yes)
    id $userfull
    if [ $? -eq 0 ];then
        userdel $userfull -r
    else
        echo "no $userfull"
    fi ;;
    n|N|no)
    exit 1 ;;
    *)
      read -p "Please input [y|Y|yes|n|N|no]" num1
  esac
done

```

选择菜单输出对应信息

```bash
# cat menu.sh
#!/usr/bin/bash
#version v1.0
cat << EOF
h 显示命令帮助
f 显示登陆信息
d 显示磁盘挂载
m 查看内存使用
u 查看系统负载
q 退出程序
EOF

read -p "请输入对应的菜单项: " num
case $num in
	h)
  	man bash ;;
	f)
  	who;;
	d)
  	df -h ;;
	m)
  	free -h ;;
	u)
  	uptime ;;
	q)
  	exit 1 ;;
	*)
	echo "你输入的不是对应的菜单项."
esac
```

### 最新有一文本文件lessons.txt内容如下，请使用awk处理该文本，并输出内容如result.txt

print $2 array\[$2]

```bash
cat > lessons.txt<<EOF
634751 预排
568688 预排
386760 删除
619373 预排
428491 预排
487563 完成
603342 完成
436339 完成
EOF

# result.txt
删除 386760
完成 487563,603342,436339
预排 634751,568688,619373,428491


#
awk '{key=$2;$2="";value=$0;sum[key]=sum[key]""value} END{for(i in sum) print i,sum[i]}' lessons.txt


 
从上到下按行读取

把第二列作为数组来存值

每读取一行都会重新给数组加值
第一次是这样 sum[预排]=null" "634751
预排  634751
第二次是这样 sum[预排]=sum[预排]" "568688
预排  634751  568688
……
直到awk读完最后一行,然后在END模式下进行输出数组结果
i是下标  sum[i]就是数组下标的值
```

```bash
#五行哥
awk '{array[$2]=array[$2]","$1}END{for (i in array) print i,array[i]}' lessons.txt


awk '{if(array[$2]==""){array[$2]=array[$2]$1}else{array[$2]=array[$2]","$1}}END{for (i in array) print i,array[i]}' lessons.txt



cat > lesson.awk<<\EOF
#!/usr/bin/awk
{
    if(array[$2]=="")
        {
        array[$2]=array[$2]$1
        }
    else
        {
        array[$2]=array[$2]","$1
        }
}
END{
    for (i in array)
        print i,array[i]
}
EOF

#----------------------分隔符
\EOF
# --------------------分隔符
awk -f lesson.awk lessons.txt


---------------------------------

数组是相同类型相关联变量的集合
[root@web01 ~]# if((3<5));then echo 1;else echo 2;fi
1
[root@web01 ~]# if [ 3 -lt 5 ];then echo 1;else echo 2;fi
1
[root@web01 ~]# if id root &> /dev/null;then echo 1;else echo 2;fi
1
[root@web01 ~]# if id roo &> /dev/null;then echo 1;else echo 2;fi
2

[root@web01 ~]# a=1
[root@web01 ~]# if ((a));then echo 1;else echo 0;fi
1
[root@web01 ~]# a=0
[root@web01 ~]# if ((a));then echo 1;else echo 0;fi
0
# 非0 都是真
[root@web01 ~]# a=3
[root@web01 ~]# if ((a));then echo 1;else echo 0;fi
1
# 空 未赋值也是假
[root@web01 ~]# echo $b

[root@web01 ~]# if ((b));then echo 1;else echo 0;fi
0

-------------------------------------------------------------------
精简代码
# vim lesson.awk
#!/usr/bin/awk
{
  if(array[$2])
      {
      array[$2]=array[$2]","$1
      }
  else
      {
      array[$2]=array[$2]$1
      }
}
END{
  for (i in array)
    print i,array[i]
}

# awk -f lesson.awk lessons.txt

-----------------------------------------------------------------
三目运算(if-else)
条件?num1;num2
array[$2]?array[$2]=array[$2]","$1:array[$2]=array[$2]$1

awk '{array[$2]?array[$2]=array[$2]","$1:array[$2]=array[$2]$1}END{for (i in array) print i,array[i]}' lessons.txt

# 再精简
awk '{array[$2]=array[$2]?array[$2]","$1:array[$2]$1}END{for (i in array) print i,array[i]}' lessons.txt

```

      

# day05 

##  trap

```bash
信号说明
HUP(1)    挂起，通常因终端掉线或用户退出而引发
INT(2)    中断，通常因按下Ctrl+C组合键而引发
QUIT(3)   退出，通常因按下Ctrl+组合键而引发
ABRT(6)   中止，通常因某些严重的执行错误而引发
ALRM(14)  报警，通常用来处理超时
TERM(15)  终止，通常在系统关机时发送
SIGTSTP   停止进程     终端来的停止信号

```

## 写一个shell跳板机 ( 这里可以写成一个项目 面试用)

```bash
[root@web01 ~]# cat jumpserver.sh
#!/bin/sh
#version v1.0
m01=192.168.137.61
mysql=192.168.137.5
NFS=192.168.137.31
m01=192.168.137.61
caidan(){
cat <<EOF
===============================================================
1) LB02
2) MYSQL
3) NFS
4) M01
6) h
===============================================================
EOF
}
caidan
trap "" HUP INT TSTP

while true
do
  read -p "请输入你要登陆的服务器编号" num
  case $num in
    1|LB02)
      ssh root@$LB02
      ;;
    2|MYSQL)
      ssh root@$MYSQL
      ;;
    3|NFS)
      ssh root@$NFS
      ;;
    4|m01)
      ssh root@$m01
      ;;
    h)
      caidan
      ;;
    q)
      exit 1
      ;;
  esac
done

#提前生成秘钥 分发公钥
# ssh-keygen   
# ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.137.61

测试Jumpserver.sh (写成开机自启动脚本)
# sh jumpserver.sh
===============================================================
1) LB02
2) MYSQL
3) NFS
4) M01
6) h
===============================================================
请输入你要登陆的服务器编号4
Last login: Fri Nov  9 08:50:12 2018 from 192.168.137.1

[root@m01 ~]#

```

## Nginx 启动|停止|状态|  脚本

```bash
# cat nginx-start.sh
#!/usr/bin/bash
#nginx_start
source /etc/init.d/functions
TE=$1
ST(){
  if [ $? -eq 0 ];then
    action "nginx $TE" /bin/true
  else
    action "nginx $TE" /bin/false
  fi
}

start(){
  /usr/sbin/nginx
  ST
}
stop(){
  /usr/sbin/nginx -s stop
  ST
}
restart(){
  /usr/sbin/nginx -s stop
  sleep 5
  /usr/sbin/nginx
  ST
}

reload(){
  /usr/sbin/nginx -s reload
  ST
}
status(){
  #pro=$(ps axu|grep nginx|grep master|awk '{print $2}')
  pro=`pgrep nginx|sed -n '2p'`
  echo "Nginx PID is $pro"
  port=`netstat -lntup|grep -v tcp6|grep nginx|awk '{print $4}'`
  echo "$port"
  ST
}

case $1 in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  reload)
    start
    ;;
  status)
    status
    ;;
  *)
  echo "USAGE $0: start|stop|restart|reload|status"
  exit 1
esac

```

## Expect自动化交互

```bash
# yum install expect

# 简单实现免交互登陆
# vim expect.ex
#!/usr/bin/expect
spawn ssh root@192.168.137.61
expect {
        "yes/no" { sed "yes\r"; exp_continue }
        "password:" { send "1\r" };
}
interact

-------------------------------------------------------------
# Expect 变量方式
#!/usr/bin/expect
#设置变量的expect语法
set ip 10.0.0.5
set user root
set password centos
set timeout 5

spawn ssh $user@$ip
expect {
    #\r回车 exp_continue 如果不需要输入密码就跳过
    "yes/no" { send "yes\r"; exp_continue }
    "password:" { send "$password\r" };
} 
#交互方式
interact

执行
# expect expect.ex
spawn ssh root@192.168.137.61
root@192.168.137.61's password:
Last login: Fri Nov  9 10:58:25 2018 from 192.168.137.7
[root@m01 ~]#

```

bash脚本引用 expect

```bash
#!/usr/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
ssh-keygen -b 1024 -f /root/.ssh/id_rsa -t rsa -p ""
for i in `echo 50 51 52 53`
do
  IP=172.16.1.$i
/usr/bin/expect <<EOF
spawn ssh-copy-id -i /root/ ssh/id_rsa. pub root$IP

expect {
  "(yes/no)? " {send "yes\r";exp_continue}
  "password: " {send "1\r";}
}

expect eof

EOF
done
```

## 扩展作业：写自动分发公钥脚本用Expect

```bash
# yum install expect

# cat ssh164.exp
#!/usr/bin/expect
#set的作用是设置变量
set host_ip [lindex $argv 0]

#spawn设置执行命令时，可以引用变量；变量的第一个参数为0
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $host_ip
expect {
  -timeout 60
  "(yes/no)?" { send "yes\n";exp_continue}
  "password:" { send "1\n"}
  # 当达到60秒后就超时,打印指定输出后退出
  timeout {puts "Connect timeout!";return}
}
expect eof

exit -onexit {
        #send_user 也是打印输出
        send_user "Job has finished!"
}


# cat ssh164.sh
#!/bin/bash
iplist=(
  192.168.137.7
  192.168.137.51
)
for ip in ${iplist[*]};do 
        expect /root/ssh164.exp $ip
done

# sh ssh164.sh  #自动分发公钥
```

## 测试网段10.0.0.0-254  哪个能ping通 输出到txt文件里  \*\*面试题

```bash
#!/bin/bash
for ((i=1;i<255;i++))
do
  ping -c 1 -w 1s 10.0.0.$i
  n=`echo $?`
  if [ $n -eq 0 ];then
    echo 10.0.0.$i >>/tmp/online_ip.log 
  fi
done

------------------------------------------------------------------
# {}& 花括号里面的是高并发执行 速度快
# cat ping.sh
#!/bin/bash
for i in {1..254};do
{
  IP=192.168.137.$i
  if ping -c1 -t2 $IP &>/dev/null;then
    echo "$IP" >> /tmp/ip.log
  fi
}&
done
wait  # wait  扫描结束后就提示
echo "获取在线IP 完成"


# nmap扫描方式
# cat ping2.sh
#!/bin/bash
nmap -n -sP 192.168.137.1-254|grep "192.168.137"|awk -F" " '{print $5}'>/tmp/chake.txt

for n in `cat /tmp/chake.txt`
do
  echo "find $n"
done
wait
echo "获取在线IP 完成"

# sh ping2.sh
find 192.168.137.1
find 192.168.137.61
find 192.168.137.7


# for循环添加用户
#!/bin/sh
for i in `cat user.txt`
do
  id $i &>/dev/null
  if [ $? -ne 0 ];then
     useradd $i
     echo "123"|passwd --stdin $i &>/dev/null
     echo "Create $i OK"
  else
     echo "useradd: $i already exists"
  fi
done

----------------------------------------------------------
# cat useradd.sh
#!/bin/bash
read -p "please input number: " num
if [[ ! $num =~ ^[0-9]+$ ]];then
  echo "please input number: "
  exit 1
fi

read -p "please input prefix: " name
if [[ -z ${#name} ]];then
  echo "请输入 前缀: "
  exit 2
fi

for i in `seq $num`
do
  userfull=$name$i
  useradd $userfull
  if [ $? -eq 0 ];then
    echo "123" |passwd --stdin $userfull &>/dev/null
    echo "$userfull create success"
  fi
done

```

## while 循环

```bash
# while :; do sleep 5; echo date;done  #5秒输出 ；一直输出date


#while read line
# cat useradd-while.sh
#!/bin/sh
while read line
do
  id $line &>/dev/null
  if [ $? -eq 0 ];then
    echo "useradd: user $line already exists"
  else
    useradd $line
    if [ $? -eq 0 ];then
    echo "create $line success"
    fi
  fi
done<userList.txt

cat > userList.txt<<EOF
ckh1
ckh2
EOF

Shell内置命令
exit 退出整个程序 
break 结束当前循环，或跳出本层循环
continue 忽略本次循环剩余的代码，直接进行下一次循环

#!/bin/sh
for i in `seq 10`
do
  useradd test$i
  if [ $? -eq 0 ];then
    echo "Create $i Success"
  else
    #break
    continue
  fi
done

```

## 函数调用

```bash
# cat fun3.sh 
#!/usr/bin/bash
t_file(){                   # 函数判断
    if [ -f $1 ];then
        echo "$1 exists"
    else
        return 1
    fi
}
# 调用函数
t_file  $1

# sh fun3.sh /etc/passwd
/etc/passwd exists
---------------------------------------------------------
# cat fun3.sh 
file=/etc/ttt               # 定义文件
t_file(){                   # 函数判断
    if [ -f $file ];then
        return 0
    else
        return 1
    fi
}
# 调用函数
t_file


# cat fun1.sh
#!/bin/sh
num=5
count01(){
for i in `seq 10`
do
  total=$[$i + $num]
done
echo "计算结果是: $total"
}
count01

#结果就是 最后一次循环 10+5
# sh fun1.sh
计算结果是: 15

函数的返回值

```

## nginx 启动|停止|状态|重载  脚本  函数版本

```bash
# cat nginx-start2.sh
#!/usr/bin/bash
source /etc/init.d/functions
Test() {
    if [ $? -eq 0 ];then
        action "Nginx $1 is ok" /bin/true
    else
        action "Nginx $1 is error" /bin/false
    fi
}
case $1 in
    start)
        nginx
        Test $1
        ;;
    stop)
        nginx -s stop
        Test $1
        ;;
    reload)
        nginx -s reload
        Test $1
        ;;
    *)
    echo "USAGE: $0 { start|stop|reload }"
esac
```

## while循环 统计/etc/passwd 有多少行

```bash
# vim total-passwd.sh
#!/bin/sh
countFileLines () {
        i=0
        while read line; do
                ((i++))
        done < "$1"
        echo "$1 has $i lines"
}
countFileLines $1

# sh total-file-lines.sh /etc/passwd
/etc/passwd has 40 lines

# wc -l /etc/passwd
40 /etc/passwd

#看书看目录, 工作中需要用到再去找到那个章节用
# 统计文件行
# cat read.sh 
#!/bin/sh
File=/etc/passwd
function count(){
#local 定义变量 函数里有效,不会和别的函数有冲突
local i=0
while read line
do
  # let是bash中用于计算的工具
  let ++i
done<$File
echo $i

}

```

# shell 练习题目

题目

#### 1.按照时间生成文件`2018-05-22.log`将每天的磁盘使用状态写入到对应的文件

```bash
分析
1.时间打印  date +%F
2.磁盘状态  df -h

# cat disk.sh
#!/bin/bash
log=/var/log/`date +%F`.log
[ -f $log ] || touch $log && df -h >$log
if [ ! -f $log ]
then
	touch $log && df -h >$log
fi

```

```bash
cronteb -e -u root
59 23 * * * /usr/bin/df -Th

```

#### 2.统计Nginx日志中每个IP的访问量有多少,日志如下:

`192.168.56.1 - - [21/May/2018:20:44:06 -0400] "GET /index.html HTTP/1.0" 404 169 "-" "ApacheBench/2.3" "-"/code/index.html`

> 分析
>
> 1.筛选所有的IP地址
>
> 2.排序、去重、统计

```bash
# awk  '{print $1}' nginx.log |uniq -c|sort -r
      8 192.168.56.1
      5 192.168.56.2
      
uniq -cd |d去掉1
sort -nk1 #是第一列
```

```bash
# awk '{sum[$1]++}END{for(i in sum)print i,sum[i]}' nginx.log
192.168.56.1 8
192.168.56.2 5

```

#### 3.写一个脚本计算一下Linux系统所有进程占用内存大小的和。

> 分析
>
> 1.如何获取内存的大小 top、ps
>
> 2.如何统计大小之和

```bash
# 物理内存占用 RSS
# ps aux |tail -n +2|awk '{sum+=$6} END{print sum}'
# 算MB大小
# ps aux |tail -n +2|awk '{sum+=$6} END{print sum/1024"MB"}'
# 虚拟内存占用vsz 
# ps aux |tail -n +2|awk '{sum+=$5} END{print sum/1024"MB"}'

-----------------------------------------------------------------------
ps aux|awk 'NR>=2{vsz+=$5;rss+=$6}END{printf "vsz虚拟内存: %s\nRSS(实际内存):%s\n",vsz,rss }'

```

#### 4.找到/backup目录下所有后缀名为.txt的文件

```
1.批量修改txt为txt.bak

2.把所有的.bak文件打包压缩为123.tar.gz

3.批量还原文件的名字，及把增加的.bak再删除
```

> 分析
>
> 1.使用find命令进行查找
>
> 2.使用mv命令进行移动改名
>
> 3.使用tar命令进行打包

```bash
[root@localhost backup]# find ./ -type f -name "*.txt" -exec mv {} {}.bak \;
[root@localhost backup]# tar zcf 123.tar.gz *.bak	
[root@localhost backup]# rm -f *.bak && tar xf 123.tar.gz	

[root@localhost backup]# ls
123.tar.gz  1.log  1.txt.bak  2.txt.bak  3.txt.bak  nginxCheck.sh  nohup.out
[root@localhost backup]# rename txt.bak txt *.bak   #批量改名
[root@localhost backup]# ls
123.tar.gz  1.log  1.txt  2.txt  3.txt  nginxCheck.sh  nohup.out
```

```bash
[root@localhost backup]# cat remove_backup.sh
#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
cd /backup
rename txt txt.bak *.txt
tar zcf 123.tar.gz *.bak
rename txt.bak txt *.bak
tar xf 123.tar.gz && rm -f *.bak
```

#### 5.写一个脚本，判断本机80端口(假如服务为httpd)是否开启,如果开启什么都不干, 如果发现端口不存在，那么重启一下http服务,并发邮件通知自己,脚本写好后可以每分钟执行一次，也可以写一个死循环

> 分析
>
> 1.检测80端口是否正常  netstat -lntp|grep ":80"
>
> 2.如果不正常则重启Nginx
>
> 3.如果进程是启动的则重启，否则直接启动

```bash
[root@localhost backup]# cat httpd_check.sh
#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
rpm -qa lsof &> /dev/null || yum install -y lsof
attr=`lsof -i:80|wc -l`
#echo $attr
if [ $attr -gt 1 ];then
		echo "nginx is ok"
	else
		systemctl start nginx
		echo "nginx start" |mail -s "nginx restart faild" 343264992@qq.com
fi
```

#### 6.现在有一个lnmp环境, 经常出现502错误, 只要一重启php-fpm即可解决，如果不重启则会持续非常长的一段时间，所有有必要写一个监控脚本，监控访问日志的状态码，一旦发生502，则自动重启一下php-fpm

> 分析
>
> 1.通过日志尾部最后300行，统计502出现的次数
>
> 2.精准判断是否是502错误，不是则不处理，是则重启php-fpm

```bash
[root@localhost backup]# cat lnmp_start_php.sh
#!/bin/bash
while true
do
log=`tail -300 /var/log/nginx/access.log |awk '{print $9}'|sort -n|uniq`
for i in $log
do
  if [ $i -eq 200 ];then
     systemctl restart php-fpm
     echo "restart ok"
     sleep 60
  fi
done
done
```

#### 7.用`shell`打印下面这句话中字母数小于6个的单词`Bash also interprets a number of multi-user optios`

> 分析
>
> 1.使用循环遍历
>
> 2.怎么统计单词数值 wc -c

```bash
for a in Bash also interprets a number of multi-user optios
do
	b=`echo $a|wc -L`
	if [ $b -lt 6 ]
		then
		echo $a
	fi
done
```

#### 8.添加`user_00->user_09`10个用户, 并且给他们设置一个随机密码, 密码要求10位包含大小写字母以及数字, 注意需要把每个用户的密码记录到一个日志文件中

> 分析
>
> 1.怎么实现00-09思路`echo user_{00..10} seq -w 0 10`
>
> 2.随机密码`mkpasswd( yum install expect)`

```bash
[root@localhost ~]# cat useradd.sh
#!/bin/bash
#########################################
# File Name : user.sh
# version: v.1.0
# Author Centos
# Created Time : 2018-11-06
#########################################
for j in user_{00..09}
do
	useradd $j
	pass=`mkpasswd -l 10 -s 0`
	echo $pass |passwd --stdin $j
	echo $pass $j >>/tmp/pass.log
done
```

#### 9.写个`shell`看看你的`linux`系统中是否有自定义用户(普通用户),若有一共有多少个？

> 分析
>
> 1.查看/etc/passwd文件
>
> 2.只有UID大于1000的都是普通
>
> cat /etc/passwd|awk -F ":" '{print "$3}'

```bash
# 取出普通用户 排除id65534 的nobody用户 
[root@yht ~]# awk -F: '($3)>=1000 && $3!=65534 {print $0}' /etc/passwd|wc -l
ckh:x:1000:0::/home/ckh:/bin/bash

[root@yht ~]# awk -F ':' '{if($3>=1000 && $3!=65534)sum++}END{print sum}' /etc/passwd
1
```

#### 10.写一个`shell`脚本，检测所有磁盘分区使用率和`inode`使用率，并记录到以当天时间命名的日志文件中，当发现某个分区容量或`inode`使用量大于85%时，发邮件通知自己

> 分析
>
> 1.打印当前磁盘inode和使用率至文件中
>
> 2.取值判断是否使用率超过85%
>
> 3.发邮件通知自己(/tmp/error.txt)

```bash
[root@yht ~]# cat disk_check.sh
#!/bin/bash
export PATH=$PATH
[ -d /var/log/disk ] || mkdir -p /var/log/disk
Date=`date +%F`
path=/var/log/disk
df -h > $path/disk_h_${Date}.log
df -i > $path/disk_i_${Date}.log
awk 'NR>=2{if($5+0 >= 85)print $1,$5}' $path/disk_i_${Date}.log >> $path/warning_${Date}.log
[ -s $path/warning_${Date}.log ] && cat $path/warning_${Date}.log | mail -s "disk warning" 343264992@qq.com
find $path -type f -mtime +7 |xargs -i rm -f {}
```

#### 11.写一个`shell`脚本来看看你使用最多的命令是那些，列出常用的命令top10

> 分析
>
> 1.拿到想要的值，排序、去重、统计

```bash
[root@localhost ~]# history |awk '{print $2}'|uniq -c|sort -r|head -10
      5 history
      4 cat
      2 yum
      2 systemctl
      2 systemctl
      2 curl
      1 yum
      1 vim
      1 vi
      1 sed
[root@localhost ~]# ll ~/.bash_history
-rw-------. 1 root root 6700 11月  6 14:30 /root/.bash_history	

[root@localhost ~]# history |cut -b 8-|awk '{print $1}'|sort|uniq -c|sort -n|tail -10

[root@localhost ~]# history |awk -F "[ |]+" '{a[$3]++}END{for(i in a)print a[i],i}'|sort|sort -n
```

#### 12.写一个脚本判断你的`Linux`服务器里是否开启`web`服务, 如果开启了请判断跑的是什么服务，是`httpd`还是`nginx`又或是其他?

> 分析
>
> 1.使用`netstat`查看是否存在80
>
> 2.筛选80端口对应的是`nginx`还是`httpd`

```bash
[root@yht ~]# netstat -lntp|grep ":80"|awk '{print $(NF-1)}'|awk -F[/:] '{print $(NF-1)}'
nginx
------------------------------------------------------
[root@yht ~]# cat web-check-is-runing.sh
#!/bin/bash
num=`netstat -lntp |egrep 'httpd|nginx' |wc -l`
   if [ $num -ge 1 ];then
	pro=`netstat -lntp|egrep 'httpd|nginx'|awk -F "/|:" '{print $4}'` &>/dev/null
	#echo $pro
	if [ $pro = "nginx" ];then
		echo "nginx is running"
		exit 1
	else
		echo "httpd is runnint"
		exit 2
	fi
   fi
```

#### 13.当前`mysql`服务的`root`密码为`123456`写脚本检测`mysql`服务是否正常(比如，可以正常进入`mysql`执行`show processlist`)，并检查一下当前的MySQL服务是主还是从，如果是从，请判断他的主从服务是否异常，如果是主，则不需要做什么

> 分析
>
> 1.使用非交互的方式登录mysql进行取值 mysql -h -u -p -e
>
> 2.检查主从, 如果是主则返回空，如果是从则返回数值(show slave status\G)
>
> 3.检查从的IO线程和SQL线程是否正常。

#### 14.写一个脚本, 计算100以内能被3整除的正整数之和

> 分析
>
> 1.先找出1-100能除以3等于0的数值
>
> 2.让数值进行相加

```bash
[root@yht ~]# cat number.sh
#!/bin/bash
Sum=0
for i in `seq 100`
do
	if [ `expr $i % 3` -eq 0 ]
		then
		Sum=$(expr $i \+ $Sum)
	fi
done
echo "合计: $Sum"
```

#### 15.提示用户输入网卡名字,然后我们用脚本输出网卡的IP

> 分析
>
> 1.需要读入用户输入的网卡名称
>
> 2.判断输入的网卡名称是否正确
>
> 3.判断网卡是否有IP地址，有则输出，没有则提示

```bash
[root@yht ~]# cat ifconfig.sh
#!/usr/bin/bash
read -p "Please input Device Name: " Name
ifconfig $Name &> /dev/null
if [ $? -eq 0 ]
then
	ifconfig $Name|awk -F'[ ]+' 'NR==2{print $3}'
else
	echo "Device name Error"
fi
```

#### 16.写一个猜数字脚本，当用户输入的数字和预设数字(随机生成一个0-100的数字)一样时，直接退出，否则让用户一直输入，并且提示用户的数字比预设数字大或者小

猜苹果是多少钱一斤

> 分析
>
> 1.随机数字如何生成
>
> 2.死循环，直到猜对才退出
>
> 3.判断大小

```bash
[root@yht ~]# cat caishuzi.sh
#!/bin/bash
num=`echo $(($RANDOM%100+1))`
while true
do
	read -p "Please input a number: " number
	if [ $number -gt $num ];then
		echo "数字过大了"
	elif [ $number -lt $num ];then
		echo "数字小了"
	else
		echo "你猜对 了!"
		exit 1
	fi
done
```

#### 17.写一个脚本判断输入的用户是否登入，如果未登陆提示没有登陆，如果登陆，显示登陆的终端以及通过那个IP登陆过来的

> 分析
>
> 1.使用w获取当前所有登陆系统的用户
>
> 2.判断

```bash
[root@yht ~]# cat user.sh
#!/bin/bash
read -p "请输入用户名称" A
Are=$(awk -F: '$3<1||$3>999{print $1}' /etc/passwd|grep "${A}$"|wc -l)
User=$(who|grep "$A"|wc -l)
case $Are in
	0)
	echo "$A 这个用户不存在!"
	;;
	1)
	[ $User -eq 0 ] && echo "$A 未登录" || who|awk '/'$A'/{print $1"\t"$2"\t"$NF}'
esac
```

#### 18.写一个`shell`先判断是否安装`http`和`mysql`没有安装进行安装，安装了检查是否启动服务，若没有启动则需要启动服务。

> 分析
>
> 1.使用rpm命令判断是否安装对应的软件
>
> 2.检查是否启动(ssytemctl|ps)

```bash
[root@web01 ~]# cat check-httpd-mysql.sh
#!/usr/bin/bash
n1=`rpm -qa httpd |wc -l`
n2=`netstat -lntp|grep http |wc -l`
if [ $n1 -eq 0 ];then
        yum install httpd -y
elif [ $n2 -eq 0 ];then
        systemctl start httpd
        else echo "httpd 正常"
fi
```

#### 19.写一个`shell`脚本，通过`curl -l`返回的状态码来判断所访问的网站是否正常，比如:当状态码为`200|301|302`时，才算正常

> 分析
>
> 1.获取状态码的关键值
>
> 2.根据状态进行判断即可

```bash
[root@localhost ~]# vim http.sh
#!/bin/bash
tt1=`curl -I -s https://www.baidu.com|head -1|cut -d " " -f2`
#echo $tt1

if [ $tt1 = "200" -o $tt1 = "301" -o $tt1 = "302" ]
        then
        echo "web is good"
else
        echo "web error"
fi
```

#### 20.已知`Nginx`访问的日志文件在`/var/log/nginx/access.log`请统计下早上10点到早上12点来访IP最多的是哪个？

```bash
grep -E '30/Oct/2018:1[0-2]:[0-5][0-9]:/var/log/nginx/access.log |awk '{print $1}' |sort -n |uniq -c |head -n1

[root@yht nginx]# grep -E '06/Nov/2018:1[0-2]' /var/log/nginx/access.log-20181107|awk '{print $1}'|sort -n|uniq -c|head -n1
      3 5.188.210.12
```

   

   

   

   [101shell脚本.txt](https://www.yuque.com/attachments/yuque/0/2020/txt/194754/1583916502366-c6c88d1b-335e-4bd7-8a80-139beb8cae60.txt)

   

   

   

   

   

   


> 更新: 2024-09-02 16:42:14  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/sggcw4>