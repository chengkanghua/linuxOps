# day13基础命令练习

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- day13基础命令练习
- 通过三剑客进行过滤
- 取网卡ipaddr 地址
- date
- 打包压缩 /etc 目录   压缩到/tmp ,每天创建的压缩包名字要不同
- 查找当前目录下所有文件 ，并把文件中的 oldboy 字符串换成 oldgirl
- 请问在一个命令上加什么参数可以实现下面命令的内容在同一行输出。
- 当从root 用户切换到普通用户oldboy时， 执行ifconfig，会提示。 command not found
- 请描述下列路径的内容做什么的？
- 如何快速查到ifconfig的全路径，请给出命令。
- 请给出查看系统在线的用户
- 请给出正确的关机和重起服务器的命令。
- 请写出下面linux命令行的的快捷键的功能

# day13基础命令练习



# 通过三剑客进行过滤
```bash
sed  替换  后向引用
awk  取列  

grep/egrep

sed
sed  -n '10p'          oldboy.txt
sed  -n '/oldboy/p'    oldboy.txt

awk
awk      'NR==10'      oldboy.txt
awk      '/oldboy/'    oldboy.txt
```

# 取网卡ipaddr 地址
```bash
# awk '/IPADDR/' /etc/sysconfig/network-scripts/ifcfg-eth0
IPADDR=10.0.0.200
#awk -F= '/IPADDR/{print $2}' /etc/sysconfig/network-scripts/ifcfg-eth0
10.0.0.200

#'条件{动作}'
#NR==2
#NR>=10
#取出网卡的DNS
#awk -F= '/DNS(1|2)/{print $2}' /etc/sysconfig/network-scripts/ifcfg-eth0
223.6.6.6
223.5.5.5



```

# date
```bash
# 显示一年前的日期
#date -d '-1year'

#显示 年-月-日_周几
date +%F_%w

date -s '20180521 12:21:12' 设置时间
ntpdate  ntp1.aliyun.com  同步阿里云服务器时间
ntp1.aliyun.com       # 时间服务器  校对时间
 
```







# 打包压缩 /etc 目录   压缩到/tmp ,每天创建的压缩包名字要不同
```bash
# tar zcf /tmp/etc-`date +%F_%H`.tar.gz /etc

```



# 查找当前目录下所有文件 ，并把文件中的 oldboy 字符串换成 oldgirl
```bash
find ./ -type f |xargs sed -i 's#oldboy#oldgirl#g'

sed -i 's#oldboy#oldgirl#g' $(find ./ -type f )

find ./ -type f -exec sed -i 's#oldboy#oldgirl#g' {} \;


```



# 请问在一个命令上加什么参数可以实现下面命令的内容在同一行输出。
```bash
两条命令 在一条输出
echo "oldboy";echo "oldboy"

#echo -n  不显示每行结尾的回车
echo -n 'oldboy';echo -n 'oldboy'

# -e  让echo支持转移字符  \n \t
echo -e 'oldboy\nnold\n\nlidao'

```



# 当从root 用户切换到普通用户oldboy时， 执行ifconfig，会提示。 command not found


```bash
输入命令时候提示 command not found
模拟环境export PATH=
PATH环境变量问题
PATH路径  坏境变量 存放的是命令路径

如何修改
1临时 ；export PATH=
[root@oldboyedu50-lnb ~]#echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
2永久 增加到  /etc/profile
	 source /etc/profile
3检查
	echo $PATH

  
```



# 请描述下列路径的内容做什么的？
```bash
/var/log/messages	系统默认日志
/var/log/secure		用户登录信息
/etc/fstab			  开机自动挂载
/etc/hosts			  解析主机名（域名）

# 修改主机
	1 临时 hostname
	2 永久 vim /etc/sysconfig/network   source  # centos7 文件时 /etc/hostname
	3  解析 /etc/hosts
  
/etc/rc.local     开机自启动
/etc/profile        环境变量  别名
/var/spool/cron/root   定时任务的配置文件

```



# 如何快速查到ifconfig的全路径，请给出命令。
```bash
yum install -y net-tools
yum install -y mlocate

which ifconfig  # 显示命令的绝对路径
whereis ifconfig # 显示命令相关信息

updatedb  # 更新locate所用的数据（清单）  占用磁盘IO读写
locate ifconfig  # 根据名字查找文件（目录）位置   
		

```



# 请给出查看系统在线的用户
```bash
[root@oldboy ~]# w
10:40:07 up 1 day, 16:38,  2 users,  load average: 0.00, 0.01, 0.00
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
root     tty1     -                Thu12   20:24   0.38s  0.38s -bash
root     pts/0    192.168.21.15    Sun20    0.00s  0.23s  0.00s w

报错
[root@oldboy ~]# w
63 column window is too narrow
窗口太窄了 放大屏幕


# w | awk -F' ' 'NR==1{print $6}'
2
# w | awk -F' ' 'NR==1{print $(NF-6)}'  #倒数第7列 
2

```



# 请给出正确的关机和重起服务器的命令。
```bash
重启
shutdown -r 10    # 10分钟后重启
shutdown -r 0/now #立刻重启
shutdown -c       #取消当前的重启或关机
reboot 			      #重启
init 6            

关机
halt
shutdown -h 10
shutdown -h 0/now  立刻关机
poweroff
init 0

```



# 请写出下面linux命令行的的快捷键的功能
```bash
Ctrl + a  把光标移动到行首
Ctrl + e  把光标移动到行尾
Ctrl + c  取消 cancel
Ctrl + d  退出当前用户
Ctrl + l  清屏
Ctrl + u  把光标所在位置到行首的内容删除（剪切）
Ctrl + k  把光标所在位置到行尾的内容删除（剪切）
ctrl + y  粘贴
ctrl+s     锁屏
ctrl+q/c   解锁
ctrl + r  搜索历史包含的命令  回车及执行  

# histroy 显示历史记录 |grep  筛选
history |grep awk


#命令行输入oldboyedu
#然后让光标移动到行首 加上注释符号和I am studying
#然后让光标移动到行尾，加上 linux.site:www.dddos.com;
#剪切，这一行内容。
#粘贴3次。





```















[access.txt](https://www.yuque.com/attachments/yuque/0/2019/txt/194754/1553423006142-9c45f67e-9cb8-4dcc-8cce-7dc9b67f60c1.txt)



扩展



```bash
# cut -d ':' -f7 /etc/passwd|sort|uniq -c|sort -nr|head -3
     15 /sbin/nologin
      1 /sbin/shutdown
      1 /sbin/halt

# cut -d ':' -f7 /etc/passwd|sort|uniq -c|sort -nr|column -t
15  /sbin/nologin
1   /sbin/shutdown
1   /sbin/halt
1   /bin/sync
1   /bin/bash

# nginx日志统计ip访问量排名前5
# cut -d ' ' -f1 access.log |sort|uniq -c|sort -nr|head -5|column -t
7326  122.71.226.14
3708  123.66.148.193
1638  122.71.243.118
936   122.71.70.94
738   223.72.40.36

```



























> 更新: 2026-04-26 17:50:41  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/qf6ogy>