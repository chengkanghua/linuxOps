# day30 shell编程下部 三剑客grep sed



# 1 企业案例题： 书写脚本检查 crond 是否在运行


```bash
1如果在运行 显示crond  is running
2如果没有运行 crond is not running
cat > checkcrond.sh <<EOF
#!/bin/bash
PATH=$PATH
count=`ps -ef|grep crond|wc -l`
echo $count
if [ $count -eq 2 ];then
	echo "crond is running"
else
	echo "crond is not running"
fi
EOF

mv checkcrond.sh checkcd.sh  # 改名成功
# 坑 检查的进程crond 是否存在  脚本名字不能有crond
#检查
[root@ckh scripts]# sh checkcd.sh
2
crond is running

[root@ckh scripts]# /etc/init.d/crond stop
Stopping crond:                                            [  OK  ]

[root@ckh scripts]# sh checkcd.sh
1
crond is not running


# 加颜色版本
cat > checkcd.sh <<EOF
#!/bin/bash
PATH=$PATH
. /etc/init.d/functions
count=`ps -ef|grep crond|wc -l`
echo $count
if [ $count -eq 2 ];then
	action "crond is running"
else
	action "crond is not running" /bin/false
fi
EOF


[root@ckh scripts]# /etc/init.d/crond start
Starting crond:                                            [  OK  ]

# 是否存在  本身grep也会算进去 |grep –v grep
[root@ckh scripts]# ps -ef|grep crond|grep -v grep   # -v  过滤不显示
root       3387      1  0 10:06 ?        00:00:00 crond
[root@ckh scripts]# ps -ef|grep '[c]rond'                  
root       3387      1  0 10:06 ?        00:00:00 crond			
进程名称  grep '[c]rond'  crond—color
				crond


```



## 






# 2循环 for
```bash
for p in 1 2 3 4 5
do
	echo $p
done

# 使用for循环输出下列效果
# sh loop.sh
tao,01week 01group take you to 大宝剑, find 01woman
tao,02week 02group take you to 大宝剑, find 02woman
tao,03week 03group take you to 大宝剑, find 03woman
tao,04week 04group take you to 大宝剑, find 04woman
tao,05week 05group take you to 大宝剑, find 05woman
tao,06week 06group take you to 大宝剑, find 06woman
cat > loop.sh <<EOF
#!/bin/bash
for sum in {01..6}
do
	echo "tao,${sum}week ${sum}group take you to 大宝剑, find ${sum}woman"
done	
EOF

# 写在一行
for p in {01..6};do echo "tao,${p}week ${p}group take you to 大宝剑, find ${p}woman"; done


```









# 3优化系统开机启动项，只保留 crond, ssd,network,rsyslog,sysstat  其余都关闭


```bash

# centos 6
chkconfig |awk '!/crond|sshd|network|rsyslog|sysstat/{print $1}'
chkconfig |grep -v “crond|sshd|network|rsyslog|sysstat” |awk '{print $1}'
chkconfig|egrep -v 'crond|sshd|network|rsyslog|sysstat'|awk '{print $1}'|tr "\n" " "

cat > fuwu.sh <<EOF
#!/bin/bash
for name in `chkconfig|egrep -v 'crond|sshd|network|rsyslog|sysstat'|awk '{print $1}'|tr "\n" " " `
do 
	chkconfig $name off
done
EOF


# centos7 
systemctl list-unit-files --type=service | grep enabled  # 所有开机启动服务
systemctl list-unit-files --type=service | grep enabled | awk '!/crond|sshd|network|rsyslog|sysstat|autovt@|getty@/{print $1}'


cat > fuwu.sh <<EOF
#!/bin/bash
for name in \$(systemctl list-unit-files --type=service | grep enabled | awk '!/crond|sshd|network|rsyslog|sysstat|autovt@|getty@/{print $1}')
do 
	systemctl disable $name
done
EOF


```



# 4批量stu01..stu03 添加用户并设置8位随机密码for




```bash
# date +%N |md5sum|cut -c1-8   # date+%N十亿分之一秒 纳秒，随机密码
1619c6aa
# echo $RANDOM #随机数字
26984
# echo $RANDOM+10000000|bc # bc用来计算
10026887
# echo $(($RANDOM+10000000)) #$(()) 计算数字
10029414
cat > addstu.sh <<EOF
#!/bin/bash
for name in stu{01..3}
do 
	useradd $name
	pass=`date +%N|md5sum|cut -c1-8`
	echo $pass|passwd --stdin $name
	echo $name $pass>>/tmp/user.log
done
EOF

```





# 5三剑客 sed grep awk


```bash

find  
	-maxdepth 1 目录层级
  -type 类型
  -name  按名字查找
  -iname	按名字查找不区分大小写
  -mtime  按时间
  !			
  -perm  按权限 permission
  -user 	按所属用户
  -exec   {} \ ;

grep
	-v  排除
	-n	显示行号
	-E	支持扩展正则 egrep
	-o	显示匹配过程
	-i  不区分大小写
	-l   过滤的时候只显示文件名字   #找出系统中包含oldoby的文件
	--color  显示颜色
	-A   after 之后    显示你要找的内容及接下来的 xxx行  -A2
	-B    上
	-C   上下

sed      stream editor  流编辑器
	-r  支持扩展
	-n  取消默认输出
	-i   修改文件
	-i.bak
	
sed –r ‘s#[0-9]##g’ oldboy.txt
  	选项 命令   小尾吧
  	option 替换    全局
sed –n ‘1p’

sed 命令执行过程
	1 读取文件内容 第1行
	2 是否满足条件
  3 满足条件  执行对应的命令  p s d
  4 不满足  继续第1步
	3 截止到文件的最后一行

  

# 环境准备
cat>person.txt<<EOF    
101,oldboy,CEO
102,zhangyao,CTO
103,Alex,COO
104,yy,CFO
105,feixue,CIO
110,lidao,COCO
EOF

sed -n 5p  person.txt      		  		# 显示第5行
sed -n '2,5p' person.txt   		  		# 显示第2行到第5行
sed -n '3,$p' person.txt   		  		# 显示第3行到最后一行$p
sed -n '1p;4p;5p' person.txt  			# 显示文件的 1 4 5 行
sed -n "/oldboy/p" person.txt   		# 显示文件中包含olboy 的行
sed -n "/101/,/105/p" person.txt  	# 包含101的行到 包含105的行
sed -n '/oldboy/,/yy/p' person.txt  # 显示文件中从包含oldboy到yy的行

特殊写法：
#显示文件的第1和4行和5行
sed -n '1p ;4p; 5p' person.txt

# 1到2行不显示
seq 10 |sed -n '1~2p'
 
sed -n '/Alex/p'  person.txt

#显示带Alex的行 和后两行
sed -n '/Alex/,+2p'  person.txt
grep -A2 "Alex" person.txt



单引号- 所见即所得
双引号- 解析特殊符号
不加引号– 支持通配符{}
```















![1546518655123-9c3bc5fc-283d-482e-adb2-3030d33fb06c.png](img/day30shell%E7%BC%96%E7%A8%8B%E4%B8%8B%E9%83%A8%E4%B8%89%E5%89%91%E5%AE%A2grepsed-01.png)



![1546518664516-836f3366-3a20-478b-93fa-9d20cf26c7d3.png](img/day30shell%E7%BC%96%E7%A8%8B%E4%B8%8B%E9%83%A8%E4%B8%89%E5%89%91%E5%AE%A2grepsed-02.png)



> 更新: 2024-08-22 09:46:31  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/mrc1n9>