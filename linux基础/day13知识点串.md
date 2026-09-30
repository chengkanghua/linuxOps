# day13 知识点串

![1546505225915-6fbbd77e-8f0e-4a1e-9e2e-7c2ca14c417b.png](img/day13%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2-01.png)

# [](#v7mlos)单引号 双引号  反引号

```bash
1 单引号  所见即所得  单引号里面的内容会原封不动的输出
#echo 'oldboy $LANG $PS1 $(hostname) `pwd`'
oldboy $LANG $PS1 $(hostname) `pwd`

2 双引号  与单引号类似  里面的特殊符号会被解析（运行）
#echo "oldboy $LANG $PS1 $(hostname) `pwd`"
oldboy en_US_UTF8 [\u@\h \W]\$ oldboy /oldboy

3. 反引号  优先执行命令  类似  $( 命令 )


```

# 显示你到目标之间每个路由是否通畅

# windows tracert

# linux traceroute

```bash
检查机房网络是否有故障
[e:\~]$ tracert -d www.baidu.com
通过最多 30 个跃点跟踪
到 www.a.shifen.com [111.13.100.91] 的路由:
 1     2 ms     2 ms     2 ms  192.168.21.254
 2     3 ms     3 ms     3 ms  122.71.224.1
 3     4 ms     4 ms     5 ms  222.35.254.253
 4     4 ms     2 ms     5 ms  222.35.61.6
 5     6 ms     4 ms     4 ms  221.179.159.21
 6     5 ms     5 ms    10 ms  111.13.14.6
 7     3 ms     5 ms     5 ms  111.13.98.101
 8     5 ms    32 ms     5 ms  111.13.108.33
 9     *        *        *     请求超时。
10     5 ms     6 ms     4 ms  111.13.100.91
跟踪完成。

# traceroute -d www.taobao.com
traceroute to www.taobao.com (101.37.183.171), 30 hops max, 60 byte packets
 1  * * *
 2  11.216.38.73 (11.216.38.73)  5.497 ms  5.813 ms  6.055 ms
 3  11.216.39.62 (11.216.39.62)  3.884 ms 11.216.38.134 (11.216.38.134)  3.881 ms 11.216.39.126 (11.216.39.126)  6.843 ms
 4  11.185.75.41 (11.185.75.41)  0.847 ms 11.185.75.49 (11.185.75.49)  0.991 ms 11.185.75.41 (11.185.75.41)  0.903 ms
 5  116.251.94.118 (116.251.94.118)  1.275 ms 116.251.94.106 (116.251.94.106)  1.450 ms 116.251.104.177 (116.251.104.177)  1.935 ms
 6  140.205.27.154 (140.205.27.154)  29.054 ms 116.251.90.170 (116.251.90.170)  35.379 ms 103.49.76.134 (103.49.76.134)  25.414 ms
 7  106.11.75.246 (106.11.75.246)  31.799 ms 106.11.37.57 (106.11.37.57)  31.006 ms 157.119.194.85 (157.119.194.85)  34.941 ms
 8  * * *
 9  * * *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  * * *
25  * * *
26  * * *
27  * * *
28  * * *
29  * * *
30  * * *

```

# [](#tvgrnz)检查 sshd是否在运行

```bash
1 检查端口 22  （端口用来区分不同的服务）
			  22端口 === sshd服务
2 检查进程是否运行

# 查询软件包是否安装
#rpm -qa telnet nc nmap
nc-1.84-24.el6.x86_64
nmap-5.51-6.el6.x86_64
telnet-0.17-48.el6.x86_64
#安装软件包
yum install  nc nmap  telnet  lrzsz  -y 

kill 2001  //杀死这个进程
ps –ef | grep 2001 //查询这个进程是否在运行

# 查询22端口是否在运行
#telnet 10.0.0.200 22
Trying 10.0.0.200...
Connected to 10.0.0.200.
Escape character is '^]'.
SSH-2.0-OpenSSH_5.3
Protocol mismatch.
Connection closed by foreign host.

# 查询22端口是否存在
#nc 10.0.0.200 22
SSH-2.0-OpenSSH_5.3
```

linux nc  和 window  聊天

![1546504961656-40ec2705-0722-4e89-be65-379351f8e032-image3.png](img/day13%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2-02.png)

```bash
# nmap 查询主机多个端口是否开启
# nmap –p1-1024 主机名   查1-1024端口
# nmap -p22,80,443 www.baidu.com

Starting Nmap 5.51 ( http://nmap.org ) at 2018-07-25 10:46 CST
Nmap scan report for www.baidu.com (111.13.100.91)
Host is up (0.0019s latency).
Other addresses for www.baidu.com (not scanned): 111.13.100.92
PORT    STATE    SERVICE
22/tcp  filtered ssh
80/tcp  open     http
443/tcp open     https
Nmap done: 1 IP address (1 host up) scanned in 1.35 seconds
```

```bash
# 查询本机22端口是否开启
#ss -lntup |grep 22
#netstat -lntup | grep 22
# lsof -i:22

```

# 检查进程是否运行

```bash
#程序  进程  守护进程
ps –ef  //显示所有运行的进程
#ps -ef |grep sshd
#ps -ef |grep crond
#ps -ef |egrep "sshd|crond"

# 判断数字
#ps -ef |grep /sshd |wc -l
2

# ps -ef |grep /ssh
root        918      1  0 May19 ?        00:00:00 /usr/sbin/sshd -D
root       2218   1099  0 01:51 pts/0    00:00:00 grep --color=auto /ssh
# ps -ef |grep /ss[h]
root        918      1  0 May19 ?        00:00:00 /usr/sbin/sshd -D

```

# [](#g72esb)找出/app/logs 下面 以.log结尾的文件（不区分大小写）  打包备份/tmp/log.tar.gz  (2种方法)

```bash
find /app/logs/ -type f -iname "*.log" |xargs tar zcvf /tmp/log.tar.gz

tar zcvf /tmp/log3.tar.gz $(find /app/logs/ -type f -iname "*.log")
# 上面的会不断覆盖 # centos7 可以,没有被覆盖

find -type f -iname "*.log" -exec tar zcf /tmp/log2.tar.gz {} +;


```

# 找出/app/logs下面以.log结尾的文件（不区分大小写）复制到 /tmp/下面（3种方法）

```bash
mkdir -p  /tmp/{a..d}
#方法1 
#  -t, --target-directory=DIRECTORY  copy all SOURCE arguments into DIRECTORY
#  –t  把前面的选项 变成 目标路径了
# find /app/logs/  -type f  -iname "*.log" |xargs cp -t /tmp/a 

#方法2
# cp  `find /app/logs/  -type f  -iname "*.log"`  /tmp/b 

#方法3
# find -type f -iname "*.log" -exec cp {} /tmp/c/  \;

```

# 程序 进程 守护进程  

* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">程序</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：硬盘上的</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">静态文件</font>**
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">进程</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：程序运行后，内存中的</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">动态实例</font>**
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">守护进程</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">后台长期运行、脱离终端、提供服务</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">的特殊进程（系统服务）</font>

| 名称 | 状态 | 位置 | 生命周期 | 特点 | 例子 |
| --- | --- | --- | --- | --- | --- |
| **程序** | 静态 | 硬盘 | 永久存在（直到删除） | 只是文件，不运行 | nginx 执行文件、ls 命令 |
| **进程** | 动态 | 内存 | 运行→结束→销毁 | 有 PID，占用资源 | 执行 ping、ls 产生的进程 |
| **守护进程** | 动态 | 内存 | 长期运行（开机→关机） | 后台、无终端、系统服务 | sshd、mysql、nginx 服务 |

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 程序 (Program) —— 静态的代码</font>

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">就是磁盘上的二进制文件 / 脚本，没有运行，一动不动</font>**

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">本质：代码、指令的集合</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">状态：</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">静态</font>**
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">位置：存放在硬盘 / U 盘</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">例子：</font>
  * <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/usr/bin/ls</font></code>
  * <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/usr/sbin/sshd</font></code>
  * <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/root/test.sh</font></code>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">nginx 的执行文件</font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. 进程 (Process) —— 动态的实例</font>

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">程序被加载到内存，开始运行，就变成了进程</font>**

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">本质：程序的</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">执行过程</font>**
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">状态：</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">动态</font>**
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">有唯一标识：</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">PID（进程号）</font>**
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">占用系统资源（内存、CPU）</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">生命周期：运行开始 → 执行结束 → 销毁</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"># 查看当前运行的进程ps-ef</font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3. 守护进程 (Daemon) —— 后台 “不死” 进程</font>

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">特殊的进程 → 后台运行、脱离终端、长期存活、开机自启</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">也叫 </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">服务进程</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，是为系统 / 用户提供持续服务的进程</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">后台运行，不占终端</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">关机才停，否则一直运行</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">没有交互界面</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">都是系统服务</font>

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">例子</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：sshd、nginx、mysql、crond、firewalld</font>

```plain
# 查看守护进程（系统服务）
ps -ef | grep sshd
ps -ef | grep nginx
```

# vim故障

```
vim故障原因：1编辑文件的时候断开连接

				2 多个窗口同事编辑一个文件
```

vim快捷键 创建环境

cat /etc/services  /etc/sysconfig/network-scripts/ifcfg-eth0 >>/tmp/vim.log

![1546505405044-206dd0c8-bfff-4d1b-9d0f-0ea416004353-image2.png](img/day13%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2-03.png)

```bash
解决：1 未保存数据不要了
  			q退出编辑
  			命令行删除临时文件         
        ls –la # 显示隐藏文件
				rm –rf .oldboy.txt.swp
        
      2  未保存数据必须要
  		  	 q 退出编辑 ，命令行恢复数据 vim –r  oldboy.txt
  			   恢复文件内容后要保存退出  :wq
        
				
```

![1546506087837-ca4de2d9-4377-41a9-b25b-91535b989713.png](img/day13%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2-04.png)

# [](https://www.yuque.com/chengkanghua/oldboy50/balhn5#qpv6zz)vim 快捷键

```bash
zz 保存并退出

vim 中的模式
第一种   命令模式  G  gg  i  a
第二种   编辑模式  i o C A
第三种   底行模式  :

命令模式: 
移动光标    hjkl  左 下  上  右
		k
	h		l
		j
gg        光标移动到文件的第一行
G         光标移动到文件的最后一行
100gg      到100行
$      光标移动到这一行的行尾
0      光标移动到这一行的行首
复制 删除 粘贴
yy   复制当前光标所在行
p  粘贴
3p  多次粘贴
dd 删除当前行  剪切行
dG 删除当前行到结尾的内容


编辑模式:
o 在当前行下面插入一个空行进入编辑模式
O  在当前行上面 插入一个空行进入编辑模式
C  删除光标到行尾的内容进入编辑模式
A  到光标行尾 进入编辑模式
D  删除当前光标到行尾不进入编辑模式



底行模式:
	:set nu  显示行号
	:set nonu   取消显示行号
	/搜索的内容  enter   n 继续向下查找   N继续向上查找
	:noh 临时取消语法的高亮
	:%  s#ssh#lili#g     # s替换  G全局 =替换所有


vim 中 帮助
	：help G
	：help ：noh
	：q 退出帮助



批量操作
	批量删除操作：
	1 ctrl + v  可视块模式
	2 通过上下左右  选择
	3 按d 删除所选内容
  
	批量编辑：
	1 ctrl + v  可视块模式
	2 通过上下左右  选择
	3 大写I
	4 编辑完成 按 esc 等等

文件中的ssh 替换为oldboy
sed  ‘s#ssh#oldboy#g’vim.log
		‘s@@@g’
		‘s///g’


iptables  centos 5.x 6.x
fireawalld   centos 7.x
```

# [](https://www.yuque.com/chengkanghua/oldboy50/balhn5#4he3ba)挂载光盘 rpm 安装软件

```bash
第1步 挂载光盘  
mount /dev/cdrom  /mnt/

第2步 检查
df -h

第3步 通过rpm命令安装软件
rpm -ivh  /mnt/Packages/lrzsz-0.12.20-27.1.el6.x86_64.rpm
# rpm -ivh  /mnt/Packages/lrzsz-0.12.20-27.1.el6.x86_64.rpm
  
#检查软件是否安装
# rpm -qa tree
tree-1.5.3-3.el6.x86_64

#list 显示软件包内容
# rpm -ql tree


```

# [如何解压RPM包](https://www.cnblogs.com/joeblackzqq/archive/2011/03/19/1989137.html)

```plain
有时我们需要RPM包中的某个文件，如何解压RPM包呢？
RPM包括是使用cpio格式打包的，因此可以先转成cpio然后解压，如下所示：
rpm2cpio xxx.rpm | cpio -div

例如：
rpm2cpio csphere-controller-2.0.15.1-stable7facf03.x86_64.rpm |cpio -div

```

# 网卡配置文件

```bash
#####/etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
ONBOOT=yes
BOOTPROTO=static
#HWADDR=00:0C:29:59:D4:13
IPADDR=10.0.0.200
PREFIX=24    #NETMASK=255.255.255.0
GATEWAY=10.0.0.254
DNS1=223.5.5.5
DNS2=223.6.6.6
```

# 如何修改主机名

```bash
#hostname oldboy
#echo "oldboy" > /etc/hostname

# hostnamectl set-hostname new_hostname   # 等于上面两条命令

#cat /etc/sysconfig/network   # centos6上, centos7上就没有了
NETWORKING=yes
HOSTNAME=oldboy
```

# host 主机 域名

```bash
# cat  /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.0.0.200  oldboyedu50-lnb

# ping oldboyedu50-lnb

# ping    `hostname`
```

# [](https://www.yuque.com/chengkanghua/oldboy50/balhn5#uiunix)yum grouplist

```bash
# yum grouplist
Installed Groups:   #已经安装的软件包组
  Base
  Compatibility libraries
  Debugging Tools
  Development tools
  E-mail server
  Graphical Administration Tools
  Hardware monitoring utilities
  Legacy UNIX compatibility
  Networking Tools
  Performance Tools
  Perl Support
  Security Tools
  System administration tools
 
Available Groups:  #你还可以安装的软件包组
  Additional Development
  Backup Client
  Backup Server
  CIFS file server
  Client management tools
  Console internet tools
  Desktop
# 安装组包
yum groupinstall  'Debugging Tools'
```

# [](https://www.yuque.com/chengkanghua/oldboy50/balhn5#na0lgv)zip 打包文件

```bash
#zip /a/hosts.zip /etc/hosts
 adding: etc/hosts (deflated 59%)
 
#unzip /a/host.zip


#  -r  打包目录
zip -r /tmp/a/etc.zip /etc/
```


> 更新: 2026-04-26 10:28:32  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/encyeg>