# linux基础命令

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- linux 基础命令
- 如果记住？ 什么是真的会了？
- 提问的艺术
- 命令结构
- Linux与Windows目录结构对比图
- ls -l /dev/cdrom
- mount  /dev/cdrom  /mnt/
- ls -l /mnt/
- ls  /mnt/Packages/
- linux目录挂载
    - Linux系统的文件目录用途
- 绝对路径、相对路径
- [操作系统目录分隔符](https://docs.chengkanghua.top/linux/linux%E5%9F%BA%E7%A1%80%E5%91%BD%E4%BB%A4?id=%e6%93%8d%e4%bd%9c%e7%b3%bb%e7%bb%9f%e7%9b%ae%e5%bd%95%e5%88%86%e9%9a%94%e7%ac%a6)
- linux bash快捷键
- 重定向符号
- Linux文件及目录管理命令
- cat
- stat
- [tr命令](https://docs.chengkanghua.top/linux/linux%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%AE%A1%E7%90%86%E5%91%BD%E4%BB%A4?id=tr%e5%91%bd%e4%bb%a4)
- 如何优雅的查看日志内容
- [cd命令，变换目录](https://www.yuque.com/chengkanghua/awf7cm/sdeetr#H8jB9)
- [tree命令](https://www.yuque.com/chengkanghua/awf7cm/sdeetr#HPSNA)
- [ls命令](https://www.yuque.com/chengkanghua/awf7cm/sdeetr#Ib1mg)
- ln 软链接 硬链接
- 文件删除原理
- inode 与 block
- linux下通过mkdir命令创建一个新目录/oldboy/ett，ett的硬链接数是多少，为什么？
- file
- [mkdir命令](https://www.yuque.com/chengkanghua/awf7cm/sdeetr#QeMon)
- [touch命令](https://www.yuque.com/chengkanghua/awf7cm/sdeetr#hwYqs)
- [cp复制](https://www.yuque.com/chengkanghua/awf7cm/sdeetr#Tcfz6)
- [mv命令](https://www.yuque.com/chengkanghua/awf7cm/sdeetr#RXUcJ)
- [rm命令](https://www.yuque.com/chengkanghua/awf7cm/sdeetr#o4TYx)
- 别名 alias
- 用户管理
- uname
- pwd
- clear
- type
- History
- hostnamectl
- lrzsz
- linux帮助命令
- linux开关机命令
    - reboot
    - shutdown
- 显示与设置系统时间  date
- linux 环境变量
- 字符集
- 练习

# 如果记住？ 什么是真的会了？
1 经常使用

2 回忆

3 通过题目回忆之前的内容

4 操作



什么是真的会了？

1. 熟练的操作
2. 解决故障



1. 说出来
2. 写出来



怎么做？



![画板](img/linux%E5%9F%BA%E7%A1%80%E5%91%BD%E4%BB%A4-01.jpeg)

 

1. 讨论
2. 操作与练习
3. 总结作业
4. 面试题 笔试题
5. 每天晚上微信分享

输入---> 输出 ---> 纠正--->





# 提问的艺术
1.背景 

我在做什么的时候 遇到了什么故障 

我做的事情是：

我遇到的故障:

我尝试了什么方法

command not found 

2.直接发出问题

3.着急的问题多问几个人

我有个问题，很着急 ，谁来帮帮我？

4.请客

5.如何让自己成为值得培养的人？

态度 

把每次的问题 无论对方是否回答 整理排版好 发给对方 

把每次面试的题目 整理好 发给面试官 

# 命令结构
举例[ Root   @     oldboy        ~  ]

Root表示当前用户名（你是谁）、

@表示断开分隔没有实际意义、

oldboy表示主机名（你在用的机器）、

~表示当前在哪里（你在哪）。

连起来的意思是 谁在操作哪台服务器在Linux的什么位置上

```bash
PS1 环境变量
环境变量特点
1.都是大写的
2.可以在系统中大部分地方 使用 含义基本没变化
3.系统创建

# PS1 控制命令行样子
echo $PS1
PS1 控制命令行样子
PS1的常用参数以及含义:
　　\d ：代表日期，格式为weekday month date，例如："Mon Aug 1"
　　\H ：完整的主机名称
　　\h ：仅取主机名中的第一个名字
　　\t ：显示时间为24小时格式，如：HH：MM：SS
　　\T ：显示时间为12小时格式
　　\A ：显示时间为24小时格式：HH：MM
　　\u ：当前用户的账号名称
　　\v ：BASH的版本信息
　　\w ：完整的工作目录名称
　　\W ：利用basename取得工作目录名称，只显示最后一个目录名
　　\# ：下达的第几个命令
　　\$ ：提示字符，如果是root用户，提示符为 # ，普通用户则为 $
  
  
#临时
export PS1='[\u@\h \w]\$ '

#永久
vim /etc/profile #编辑文件
[root@oldboyedu50 /data]# tail -2 /etc/profile
alias net='cat /etc/sysconfig/network-scripts/ifcfg-eth0'
export PS1='[\u@\h \w]\$ '

#生效
source  /etc/profile
修改过文件一定要进行 source 进行生效
```

# Linux与Windows目录结构对比图
![1546418059244-54527e10-a217-4a9c-a143-369e72e25eea-image4.png](img/linux%E5%9F%BA%E7%A1%80%E5%91%BD%E4%BB%A4-02.png)



一切皆文件

1 倒挂树状结构   一切从根开始

2 linux每个目录可以挂载在不同的设备（磁盘）上。windows不容易做到

3 linux 所有设备不挂载不能使用  	mount  /dev/cdrom  /mnt/	

linux下面所有的设备默认是无法直接使用的，给设备创造入口，入口===挂载点====目录（已经存在）

      mount  /dev/cdrom  /mnt/



实验：

1.光盘插入系统中

2.进入linux 光盘文件

# ls -l /dev/cdrom  

lrwxrwxrwx. 1 root root 3 Jul 16 14:32 /dev/cdrom -> sr0

3.给光盘创造一个入口（已经存在）

# mount  /dev/cdrom  /mnt/

mount: block device /dev/sr0 is write-protected, mounting read-only

# ls -l /mnt/

# ls  /mnt/Packages/



FHS 目录层次标准 （/和/usr每个目录作用）

[https://www.processon.com/view/link/5a6a9944e4b0a92b467f03b0](https://www.processon.com/view/link/5a6a9944e4b0a92b467f03b0)

```bash
/bin      binary 二进制文件 命令
/sbin	    super binary 超级命令  只有root可以使用
/boot	    引导文件存放 系统内核
/dev		   device 设备文件 光盘 硬盘分区
/etc	        系统配置文件
/home	     /home/oldboy  普通用户的家目录
/root	     /root root用户的家目录
/lib        libary 库文件
/lib64	     libary 库文件
/lost+found	 系统宕机  临时保存数据位置
/mnt	       默认的额挂载点， 临时挂在点
/opt          第三方软件安装位置
/proc        process虚拟目录 存放的事内存中的信息 进程 服务信息
/sys	      虚拟目录 存放的是内存中的信息  进程 服务信息
/tmp       temp temporary	临时存放文件的位置 垃圾堆
/usr	     user/ unix sofware resource 用户软件
/var	     variable 经常变化的数据 存放的位置 日志


IT information  technology 信息技术
[root@m01 ~]# cat /proc/cpuinfo
processor	: 0   第几个核心
physical id	: 0   第几颗CPU(物理)

# grep processor /proc/cpuinfo
processor	: 0
processor	: 1
processor	: 2
processor	: 3

# grep physical /proc/cpuinfo
physical id	: 0
physical id	: 0
physical id	: 1
physical id	: 1

# lscpu
CPU(s):                4    一共 4个核心
On-line CPU(s) list:   0-3
Socket(s):             2    2路
Model name:            Intel(R) Core(TM) i5-4440S CPU @ 2.80GHz
4.2 /proc/meminfo  memory info 内存信息

# cat /proc/meminfo
MemTotal:        1906256 kB
MemFree:         1722092 kB
Buffers:           25796 kB
Cached:            52816 kB

# free -h
             total       used       free     shared    buffers     cached
Mem:          1.8G       180M       1.6G       224K        25M        51M
-/+ buffers/cache:       103M       1.7G
Swap:         767M         0B       767M

[root@oldboyedu50 ~]# column -t /proc/mounts 
rootfs         /                         rootfs       rw                                                  0  0
proc           /proc                     proc         rw,relatime                                         0  0
sysfs          /sys                      sysfs        rw,relatime                                         0  0
devtmpfs       /dev                      devtmpfs     rw,relatime,size=938496k,nr_inodes=234624,mode=755  0  0
devpts         /dev/pts                  devpts       rw,relatime,gid=5,mode=620,ptmxmode=000             0  0
tmpfs          /dev/shm                  tmpfs        rw,relatime                                         0  0
/dev/sda3      /                         ext4         rw,relatime,barrier=1,data=ordered                  0  0
/proc/bus/usb  /proc/bus/usb             usbfs        rw,relatime                                         0  0
/dev/sda1      /boot                     ext4         rw,relatime,barrier=1,data=ordered                  0  0
none           /proc/sys/fs/binfmt_misc  binfmt_misc  rw,relatime      

[root@ckh oldboy]# cat /proc/loadavg
0.08 0.08 0.12 1/176 12938
[root@ckh oldboy]# uptime
 17:33:11 up  2:50,  2 users,  load average: 0.06, 0.08, 0.12

[root@oldboyedu50 ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes        #开机自启动 或 重启所有网卡的时候 是否自启动
BOOTPROTO=none    #动态ip  静态
#BOOTPROTO=static  #静态
#BOOTPROTO=dhcp    #动态
IPADDR=10.0.0.200     #ip地址
PREFIX=24          #NETMASK=255.255.255.0  子网掩码 控制局域网中最多多少台机器

GATEWAY=10.0.0.254 #默认网关

DNS1=223.5.5.5   #随意使用的DNS(公共DNS)
DNS2=223.6.6.6

[root@oldboyedu50 ~]# /etc/init.d/network restart 
[root@oldboyedu50 ~]# service network restart

/etc/resolv.conf  DNS配置文件
/etc/sysconfig/network-scripts/ifcfg-eth0 (推荐)
网卡配置文件中的DNS 优先于 /etc/resolv.conf

/etc/hostname #修改主机名文件

/etc/hosts  # IP - 域名映射表

/etc/fstab (file system table)  #开机自动挂载分区 / 硬盘 / 设备的核心配置文件
[root@oldboyedu50-lnb ~]# blkid 
/dev/sda3: UUID="cf634253-6c41-4771-87b7-e86afb9284a7" TYPE="ext4" 
/dev/sda1: UUID="8519938a-dccb-4eb5-bbbc-4fd22f9f99fe" TYPE="ext4" 
/dev/sda2: UUID="f70549a5-ec74-4cd1-99ba-49eb175e712d" TYPE="swap" 

/etc/rc.local  #linux 开机 最后一步 自动执行命令 / 脚本的地方

/etc/inittab  # 老 Linux 系统（CentOS 6 及更早）用来设置「开机默认运行级别」的文件，现作废
0  关机 （不要把运行级别设置为0）
1  单用户模式 single user mode
2  多用户模式无法使用 NFS
3  完全多用户模式 命令行模式 文本模式 （工作默认的环境）
4  待开发
5  X11   桌面（desktop)模式 图形化界面模式
6  重启 （不要把运行级别设置为6）

/etc/init.d/ 服务管理命令存放处
/etc/profile 坏境变量 别名  *****
/etc/bashrc    别名
#全局的
/etc/profile   /etc/bashrc
#局部
~/.bashrc


/etc/issue
→ 本地控制台登录 时显示（显示器直接连机器）
/etc/issue.net
→ 远程 SSH 登录 时显示（Xshell、SecureCRT 连接）
/etc/motd  文件内容用户登录系统之后显示    

/etc/sysconfig/i18n 字符集（语言）
#echo $LANG
en_US.UTF8
#export LANG=zh_CN.UTF-8  #临时修改
永久修改
# cat /etc/sysconfig/i18n
LANG="en_US.UTF8"
SYSFONT="latarcyrheb-sun16"

生效
source /etc/sysconfig/i18n

/usr/local   linux编译安装软件默认的位置
/usr/share   文档和帮助
/usr/src     源代码

/var/log  日志
[root@oldboyedu50-lnb ~]# ll /var/log/messages  /var/log/secure
-rw-------. 1 root root 212235 Jul 19 21:30 /var/log/messages #系统默认的日志
-rw-------. 1 root root   8002 Jul 19 19:32 /var/log/secure #安全日志 记录用户登录信息日志


etc/passwd  文件解析
用户名：密码：uid：gid：用户说明信息：用户家目录：用户的命令解释器shell
```

# linux目录挂载
### Linux系统的文件目录用途
/bin：系统命令目录

/sbin：超级命令目录，只能超级管理员可以执行的命令

/boot：系统目录，类似于Windows中的C盘

/dev ：设备文件目录，硬盘、光驱、U盘都属于设备文件，/dev/sr0代表光驱设备。注意，次目录下的文件没有办法直接使用，必须先挂载

/etc ：非常重要，代表系统的配置文件目录。大部分软件安装完成后，其配置文件都存放在此目录

/home：普通用户的家目录，用户登录后会自动切换到此目录

/root：超级管理员的家目录，超级管理员登录后会自动切换到此目录

/media：挂载目录，早期Linux挂载目录，用于挂载光盘以及软盘

/mnt：挂载目录，用来挂载额外的设备，如 U 盘、移动硬盘和其他操作系统的分区

/opt ：第三方软件目录，这个目录是放置和安装其他软件的位置，手工安装的源码包软件都可以安装到这个目录中。不过笔者还是习惯把软件放到 /usr/local/ 目录中，也就是说，/usr/local/ 目录也可以用来安装软件

/usr ：系统程序目录，类似Windows中的Program Files

/proc：虚拟文件系统。该目录中的数据并不保存在硬盘上，而是保存到内存中。主要保存系统的内核、进程、外部设备状态和网络状态等。

/tmp ：临时文件目录，在该目录下，所有用户都可以访问和写入。建议此目录中不能保存重要数据，最好每次开机都把该目录清理

/var ：经常变化的文件目录，网页文件、数据文件、日志文件

!

+ **/bin**：bin是Binary的缩写, 这个目录存放着最经常使用的命令。
+ **/boot：**这里存放的是启动Linux时使用的一些核心文件，包括一些连接文件以及镜像文件。
+ **/dev ：**dev是Device(设备)的缩写, 该目录下存放的是Linux的外部设备，在Linux中访问设备的方式和访问文件的方式是相同的。
+ **/etc：**这个目录用来存放所有的系统管理所需要的配置文件和子目录。
+ **/home**：用户的主目录，在Linux中，每个用户都有一个自己的目录，一般该目录名是以用户的账号命名的。
+ **/lib**：这个目录里存放着系统最基本的动态连接共享库，其作用类似于Windows里的DLL文件。几乎所有的应用程序都需要用到这些共享库。
+ **/lost+found**：这个目录一般情况下是空的，当系统非法关机后，这里就存放了一些文件。
+ **/media**：linux系统会自动识别一些设备，例如U盘、光驱等等，当识别后，linux会把识别的设备挂载到这个目录下。
+ **/mnt**：系统提供该目录是为了让用户临时挂载别的文件系统的，我们可以将光驱挂载在/mnt/上，然后进入该目录就可以查看光驱里的内容了。
+ **/opt**： 这是给主机额外安装软件所摆放的目录。比如你安装一个ORACLE数据库则就可以放到这个目录下。默认是空的。
+ **/proc**：这个目录是一个虚拟的目录，它是系统内存的映射，我们可以通过直接访问这个目录来获取系统信息。 这个目录的内容不在硬盘上而是在内存里，我们也可以直接修改里面的某些文件，比如可以通过下面的命令来屏蔽主机的ping命令，使别人无法ping你的机器：

```plain
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
```

+ **/root**：该目录为系统管理员，也称作超级权限者的用户主目录。
+ **/sbin**：s就是Super User的意思，这里存放的是系统管理员使用的系统管理程序。
+ **/selinux**： 这个目录是Redhat/CentOS所特有的目录，Selinux是一个安全机制，类似于windows的防火墙，但是这套机制比较复杂，这个目录就是存放selinux相关的文件的。
+ **/srv**： 该目录存放一些服务启动之后需要提取的数据。
+ **/sys**：这是linux2.6内核的一个很大的变化。该目录下安装了2.6内核中新出现的一个文件系统 sysfs 。 sysfs文件系统集成了下面3种文件系统的信息：针对进程信息的proc文件系统、针对设备的devfs文件系统以及针对伪终端的devpts文件系统。该文件系统是内核设备树的一个直观反映。当一个内核对象被创建的时候，对应的文件和目录也在内核对象子系统中被创建。
+ **/tmp**：这个目录是用来存放一些临时文件的。
+ **/usr**：这是一个非常重要的目录，用户的很多应用程序和文件都放在这个目录下，类似于windows下的program files目录。
+ **/usr/bin：**系统用户使用的应用程序。
+ **/usr/sbin：**超级用户使用的比较高级的管理程序和系统守护程序。
+ **/usr/src：**内核源代码默认的放置目录。
+ **/var**：这个目录中存放着在不断扩充着的东西，我们习惯将那些经常被修改的目录放在这个目录下。包括各种日志文件。

在linux系统中，有几个目录是比较重要的，平时需要注意不要误删除或者随意更改内部文件。

**/etc： 上边也提到了，这个是系统中的配置文件，如果你更改了该目录下的某个文件可能会导致系统不能启动。**

**/bin, /sbin, /usr/bin, /usr/sbin: 这是系统预设的执行文件的放置目录，比如 ls 就是在/bin/ls 目录下的。**

**值得提出的是，/bin, /usr/bin 是给系统用户使用的指令（除root外的通用户），而/sbin, /usr/sbin 则是给root使用的指令。**

**/var： 这是一个非常重要的目录，系统上跑了很多程序，那么每个程序都会有相应的日志产生，而这些日志就被记录到这个目录下，具体在/var/log 目录下，另外mail的预设放置也是在这里。**

# 绝对路径、相对路径
绝对路径：从根开始的路径    /data/xxxx/xxx

相对路径：从当前所在目录出发    data/ddd/ss



# 操作系统目录分隔符

> 参考：https://docs.chengkanghua.top/linux/linux%E5%9F%BA%E7%A1%80%E5%91%BD%E4%BB%A4?id=%e6%93%8d%e4%bd%9c%e7%b3%bb%e7%bb%9f%e7%9b%ae%e5%bd%95%e5%88%86%e9%9a%94%e7%ac%a6
```plain
window平台命令行分隔符  反斜杠
\ 
linux平台命令分隔符    正斜杠
/
```

# linux bash快捷键
```bash
Tab          自动补全
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
Ctrl + r   搜索最近使用的命令 不对继续按ctrl+r

Esc + .(点) 显示上一个命令的最后一个参数
```

# 重定向符号
```bash
一、先记住 Linux 里的 3 个默认 “通道”
所有命令运行时，系统会自动打开 3 个文件描述符：
0 = stdin 标准输入（键盘输入）
1 = stdout 标准输出（正常信息）
2 = stderr 标准错误（报错信息）
这就是 1 和 2 的由来！
正常消息 = 1
错误消息 = 2

>   # 全称：1>（标准输出覆盖重定向）
    > 是 1> 的简写
    意思：把正常输出 覆盖 写入文件
    文件不存在 → 创建
    文件已存在 → 清空再写入

>>（标准输出追加重定向）
    >> 是 1>> 的简写
    意思：把正常输出 追加 到文件末尾
    不清空，不覆盖

2>  标准错误 覆盖 重定向
    只收集错误信息
    覆盖写（清空文件再写）
2>> 标准错误 追加 重定向
    只收集错误信息
    追加到末尾，不覆盖

2>&1 （最重要！最难懂！）
      把 标准错误 (2) 重定向到 标准输出 (1) 所在的位置
      2> = 错误重定向
      &1 = 代表 “标准输出的位置”  
2>&1
    = 错误信息跟着正常信息走
    = 错误和正常输出 混在一起

为什么要写 &1，不能写 1？
    因为写 1 会被当成文件名  写 &1 才代表文件描述符 1


总结（秒记）
> = 覆盖输出（1>）
>> = 追加输出（1>>）
2> = 覆盖错误
2>> = 追加错误
2>&1 = 错误跟着输出走（合并输出）   
```

# Linux文件及目录管理命令
| 命令 | 对应英文 | 作用 |
| --- | --- | --- |
| ls | list | 查看文件夹内容 |
| pwd | print work directory | 查看当前所在目录 |
| cd 目录名 | Change directory | 切换文件夹 |
| touch 文件名 | touch | 如果文件不存在，则创建 |
| mkdir 目录名 | Make directory | 创建目录 |
| rm 文件名 | Remove | 删除指定文件 |


# cat
```bash

cat 经常用来显示文件的内容 concatenate files and print on the standard output
cat /etc/redhat-release
uname -a #打印系统的一些信息
uname -r #内核版本 
uname -m #x86 架构

```

# stat
```bash
[root@ckh oldboy]# stat alex.txt
  File: ‘alex.txt’
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d    Inode: 34732868    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2026-04-23 15:50:03.623023578 +0800  #访问时间cat
Modify: 2026-04-23 15:50:03.623023578 +0800  #修改时间
Change: 2026-04-23 15:50:03.623023578 +0800  #文件修行改变时间
 Birth: -

ls
参数--full-time
  配合-l参数，显示详细时间
  --time=WORD
  配合-1参数，其中WORD可以是，
        ctime(属性变化时间），
        atime(文件访问时间）,
        mtime(修改时间) 没有此参数则默认显示文件内容修改时间。
 
ls -l --full-time --time=atime /tmp/file1.txt
ls -l --full-time --time=ctime /tmp/file1.txt
ls -l --full-time  /tmp/file1.txt


win+r   osk 弹出屏幕键盘
```

# tr命令

> 参考：https://docs.chengkanghua.top/linux/linux%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%AE%A1%E7%90%86%E5%91%BD%E4%BB%A4?id=tr%e5%91%bd%e4%bb%a4
tr命令从标准输入中替换、缩减或删除字符，将结果写入到标准输出

```plain
用法：tr [选项]... SET1 [SET2]
从标准输入中替换、缩减和/或删除字符，并将结果写到标准输出。
字符集1：指定要转换或删除的原字符集。
当执行转换操作时，必须使用参数“字符集2”指定转换的目标字符集。
但执行删除操作时，不需要参数“字符集2”；
字符集2：指定要转换成的目标字符集。
-c或——complerment：取代所有不属于第一字符集的字符；
-d或——delete：删除所有属于第一字符集的字符；
-s或--squeeze-repeats：把连续重复的字符以单独一个字符表示；
-t或--truncate-set1：先删除第一字符集较第二字符集多出的字符。

案例；
#将输入字符由小写换为大写：
[root@luffycity ~]# echo "My name is alex" | tr 'a-z' 'A-Z'
MY NAME IS ALEX
#tr删除字符或数字，只要匹配上属于第一个字符串的字符，都被删掉
[root@luffycity ~]# echo "My name is alex and i am 30 years old." | tr -d "0-9"
My name is alex and i am  years old.
[root@luffycity ~]# echo "My name is alex and i am 33456 years old." | tr -d "1234"
My name is alex and i am 56 years old.
#删除字符，所有的数字，以及小写字符
[root@luffycity ~]# echo "My name is alex and i am 33456 years old." | tr -d "0-9","a-z"


[root@luffycity tmp]# tr "[a-z]" "[A-Z]" < alex.txt            #全部换成大写
I AM LUFFYCITY CTO.
I AM 30 YEARS OLD.
I LIKE EAT DA XI GUA .
#删除文中出现的换行符、制表符（tab键）
tr -d "\n\t" < alex.txt
#去重连续的字符，tr是挨个匹配" ia" 每一个字符，包括空格去重
[root@luffycity tmp]# echo "iiiii      am  aaaaalex,iiii like  hot girl" | tr -s " ia"
i am alex,i like hot girl
#-c取反结果，将所有除了'a'以外的全部替换为'A'
[root@luffycity tmp]# echo 'i am alex' | tr -c 'a' 'A'
AAaAAaAAAA


# tr 与<
tr ',' ' ' <oldbot.txt   //把oldoby.txt 中的，替换空格

seq 10 > a.txt
# 1 2 3 4 5 6 7 8 9 10
xargs -n2 < a.txt  #两列显示
```



# 如何优雅的查看日志内容
```bash
1.head
2.tail
3.grep
4.less 一页一页查看文件内容
   空格 或 f   下一页
           b   上一页
           q   退出
           
5.more
```

# cd命令，变换目录

> 参考：https://www.yuque.com/chengkanghua/awf7cm/sdeetr#H8jB9
cd切换目录

cd    进入用户家目录；

cd ~  进入用户家目录；

cd -  返回进入此目录之前所在的目录；

cd ..  返回上级目录（若当前目录为“/“，则执行完后还在“/"；".."为上级目录的意思）；

cd ../..  返回上两级目录；

# tree命令

> 参考：https://www.yuque.com/chengkanghua/awf7cm/sdeetr#HPSNA
以树形结构显示目录下内容

```bash
tree命令语法：
tree常用参数
-C 在文件和目录清单加上色彩，便于区分各种类型。
-d 显示目录名称而非内容。
-D 列出文件或目录的更改时间。
-f 在每个文件或目录之前，显示完整的相对路径名称。
-F 在条目后加上文件类型的指示符号(* ， /， = ， @ ， | ，其中的一个) 目录/
```

# ls命令

> 参考：https://www.yuque.com/chengkanghua/awf7cm/sdeetr#Ib1mg
```bash
ls命令用来显示目标列表
  -a 显示隐藏文件
  -d  仅显示目录名
  -l 长格式显示
  -t   sort by modification time, newest first， 修改时间最新 排最前面
  -r, --reverse   reverse order while sorting   排序的时候反序
   --full-time            like -l --time-style=full-iso


[root@ckh oldboy]# ll
total 28
-rw-r--r-- 1 root root   0 Apr 23 15:50 alex.txt
-rw-r--r-- 1 root root  21 Apr 23 19:06 a.txt
-rw-r--r-- 1 root root  21 Apr 23 19:12 a.txt.bak
-rw-r--r-- 1 root root 283 Apr 23 19:17 id.txt

文件权限  rwx
对于一个文件来说 ，系统中的用户分为： 主人   		家人   	陌生人
												         所有者    用户组   其他人
r  --- read    可读 4
w  --write     可写 2
x  ----execute	可执行1
-    0

权限的计算:
主人      家人    陌生人
-rw-			r--      r--
420			 400		   400
6			   4         4
```

# ln 软链接 硬链接
链接： 软链接（softlink  或 符号链接 symlink）   硬链接 (hard  link)

硬链接 ： 文件的inode 号码相同， 互为硬链接（在同一个磁盘分区） 

文件的入口

```bash
# 硬链接创建
#ln a.txt  a.txt.hard
#ls -lhi
total 11M
261983 -rw-r--r-- 2 root root   21 Jan  1  2020 a.txt
261983 -rw-r--r-- 2 root root   21 Jan  1  2020 a.txt.hard
  
  1特点， 同一个分区inode 相同的文件，互为硬链接
	2 防止误删除
	3 彻底删除一个文件条件
		文件的硬链接为0（rm）

软链接：最常用  相当于windows快捷方式  存放的源文件的位置    
# ln -s oldboy.txt  oldboy.txt-soft
#ls -l
lrwxrwxrwx 1 root root      10 Jul 29 22:53 oldboy.txt-soft -> oldboy.txt

# 加绝对路径 ****
#ln -s /tmp/oldboy.txt oldboy.txt2-soft
#ll
total 10660
-rw-r--r-- 1 root root      27 Jul 29 18:39 oldboy.txt
lrwxrwxrwx 1 root root      15 Jul 29 23:00 oldboy.txt2-soft -> /tmp/oldboy.txt




文件删除原理
```

# 文件删除原理
```bash
1 硬链接数为0    rm
2 进程调用数为0   是否有人使用
  
窗口1
[root@m01 oldboy]# echo "aa" > /tmp/logs.txt
[root@m01 oldboy]# tail -f /tmp/logs.txt
aa

窗口2
#显示所有被占用的文件
#list  open files
# lsof |grep logs.txt
tail   5608    root   3r    REG      253,0    3   34279813 /tmp/logs.txt

输出字段解释
tail：这是正在运行的进程的名称
5608：进程 ID（PID）
root：运行该进程的用户。
3r：文件描述符和访问模式。这里的“3”是文件描述符，“r”表示以只读模式（read）打开文件。
REG：文件类型，这里表示常规文件。
253,0：文件所在的设备号。设备号用于标识文件所在的存储设备。
3：文件的节点号（inode number），用于在文件系统中唯一标识文件。
34279813：文件的大小（以字节为单位) 34279813 字节。
/tmp/logs.txt：打开的文件的路径和名称。

# 模拟  文件没有被彻底删除 （i_link）为0 进程调用数（i_count）不为0
[root@oldboy ~]#du -sh /var/log/* |sort -h
4.6G	/var/log/messages
[root@oldboy ~]#\rm -f /var/log/messages
[root@oldboy ~]#df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        19G   11G  7.1G  61% /
....

#原因： 文件没由被彻底删除
# 进程调用数为0 =====重启服务/软件
[root@oldboy ~]#lsof | grep deleted
rsyslogd   1246  root  1w   REG  8,3 4888890193 785370 /var/log/messages (deleted)
#deleted lsof 标记  表示文件硬链接数为0 进程调用数不为0

# 重启服务、/进程
[root@oldboy ~]#/etc/init.d/rsyslog  restart
Shutting down system logger:                               [  OK  ]
Starting system logger:                                    [  OK  ]

[root@oldboy ~]#df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        19G  6.2G   12G  35% /
.....

[root@oldboy ~]#lsof |grep messages
rsyslogd 46711  root  1w REG   8,3   212  785173 /var/log/messages


小结：
1 磁盘空间不足 – 文件没有彻底删除，导致（硬链接为0 进程调用数不为0）
	df –h  ； du –sh 没有满；  lsof |grep delete



软 硬链接  区别    （面试题）
		解答： 在linux系统中，链接分两种： 1硬链接    2软链接（符号链接）
		1）如何创建：
					ln 源文件  硬链接名
					ln –s  源文件  软链接名
		2） 含义：
			 a) 在同一个分区 硬链接和源文件的inode节点号相同，而软链接文件相当于windows下面的快捷方式（inode 节点号与源文件不同）
		3)  特点：
			a) 硬链接不能对目录创建，  软链接可以
			b）软链接可以跨文件系统， 硬链接不行（同一分区）
		4）怎么没的（源文件， 软链接， 硬链接与删除）
			a） 删除软链接文件， 对源文件及硬链接文件无任何影响
			b） 删除（文件的）硬链文件 ，对源文件及软链接文件无任何影响
			c） 删除（文件的）源文件，对硬链接文件无影响，软链接失效
			d） 同时删除源文件及其硬链接文件 ， 整个文件才会被真正 的删除

	3 文件删除原理
        1 硬链接为0
  			2 进程调用数为0


企业故障案例：Web服务器磁盘满深入解析及解决 
https://blog.51cto.com/oldboy/612351
```

# inode 与 block 
```bash
[root@m01 tmp]# ls -lhi
total 0
14 -rw-r--r-- 1 root root 0 May 20 05:22 file1
15 -rw-r--r-- 1 root root 0 May 20 05:22 file12
16 -rw-r--r-- 1 root root 0 May 20 05:22 file13
详细介绍: 
14:inode号 
-rw-r--r-- :  -文件类型  权限9个字符以3个为一组，分别表示文件所有者、所属组和其他用户的权限
# 权限分为读（r）、写（w）、执行（x），如果没有相应权限则用-表示。
1 : 硬链接数量
root: 所有者
root: 所属组
0 : 大小
May 20 05:22  : 修改时间
file1 : 文件名


inode 创建一个非空文件要占用一个inode和自少一个block。
block  1存放数据的地方
		   2磁盘读取数据是按block单位读取的
		   3每读取一个block就会消耗一次磁盘I/O（input/output）磁盘读写
       
企业案例： 如果向磁盘写入数据提示如下错误：No space left on device（磁盘空间不足），
					通过df -h查看磁盘空间，发现没满，请问可能原因是什么？    
          企业场景什么情况下会导致这个问题发生？
          
inode用光了  大量的小文件（定时任务）

## 准备模拟 block 环境
mkdir -p /app/logs
dd if=/dev/zero of=/dev/sdc bs=8K  count=10
ls – l /dev/sdc
mkfs.ext4 /dev/sdc

# - o用于指定挂载选项
# loop（loopback）选项允许将一个普通文件模拟成一个块设备来进行挂载。例如iso镜像文件
mount -o loop /dev/sdc /app/logs   

#block 满了
#cp /bin/ls  /app/logs/
cp: writing `/app/logs/ls': No space left on device

#df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        19G  6.1G   12G  35% /
tmpfs           491M     0  491M   0% /dev/shm
/dev/sda1       190M   40M  141M  22% /boot
/dev/sdc         73K   70K     0 100% /app/logs
#\rm /app/logs/ls
#df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        19G  6.1G   12G  35% /
tmpfs           491M     0  491M   0% /dev/shm
/dev/sda1       190M   40M  141M  22% /boot
/dev/sdc         73K   14K   55K  21% /app/logs

# 模拟inode 用光
#创建多个小文件
#cd /app/logs/
#echo {1..500}|xargs touch

#touch  /app/logs/{1..7}.txt
touch: cannot touch `/app/logs/6.txt': No space left on device
touch: cannot touch `/app/logs/7.txt': No space left on device

#排查
#df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        19G  6.1G   12G  35% /
tmpfs           491M     0  491M   0% /dev/shm
/dev/sda1       190M   40M  141M  22% /boot
/dev/sdc         73K   14K   55K  21% /app/logs
# df -i
Filesystem      Inodes IUsed   IFree IUse% Mounted on
/dev/sda3      1250928 57431 1193497    5% /
tmpfs           238282     1  238281    1% /dev/shm
/dev/sda1        51200    39   51161    1% /boot
/dev/sdc            16    16       0  100% /app/logs

# cd /app/logs/ && echo {1..500} |xargs \rm -rf	

# 删除大量小文件
# mkdir  -p /tmp/test
# cd /tmp/test
# touch {1..500000}
-bash: /bin/touch: Argument list too long

# echo {1..500000}|xargs touch
# ls |wc -l
500000


##故障：无法删除大量文件
[.../tmp/test]# \rm -f *
-bash: /bin/rm: Argument list too long
##解决：删除大量文件
[... /tmp/test]# ls |xargs rm

删除大量小文件
1. ls/find +|xargs rm

2.缩小范围删除
ls 1*  |xargs rm
ls 2*  |xargs rm

3.删除文件所在目录 （记录好权限和属性）


```



# linux下通过mkdir命令创建一个新目录/oldboy/ett，ett的硬链接数是多少，为什么？
```bash
mkdir -p /oldboy/ett
ll -d /oldboy/ett

[root@ckh oldboy]# ll -d /oldboy/ett
drwxr-xr-x 2 root root 6 Apr 23 21:17 /oldboy/ett
           硬链接2     大小6kb 
# 目录与目录下的. 是指向同一个inode号.

mkdir -p /oldboy/ett/oldboy     # ett目录的硬连接数是？
ll -d /oldboy/ett

[root@ckh oldboy]# ll -d /oldboy/ett
drwxr-xr-x 3 root root 20 Apr 23 21:23 /oldboy/ett
# 子目录oldboy目录里 .. 目录是上级目录ett 
```





# file
```bash
# 查看文件详细类型 
#file /bin/ls
/bin/ls: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
#file /etc/hosts
/etc/hosts: ASCII text
#file /tmp/etc-pai.tar
/tmp/etc-pai.tar: gzip compressed data, from Unix, last modified: Sun Jul 29 19:11:58 2018


1.二进制文件（命令）
2.文本文件（text）
3.数据文件（data）需要单独命令查看
※※※※※d    dir         目录
※※※※※l    softlink    软连接
b    block       块设备
c    character   字符设备
p    pipe        管道
s    socket      套接字
```

# mkdir命令

> 参考：https://www.yuque.com/chengkanghua/awf7cm/sdeetr#QeMon
```bash
# mkdir
  -v  显示创建过程
  -p  递归创建目录
#创建目录
mkdir a 
#递归创建目录
mkdir -p a/b/c/d   
# 以树形结构列出目录内容。
tree a
```

# touch命令

> 参考：https://www.yuque.com/chengkanghua/awf7cm/sdeetr#hwYqs
```bash

pwd  显示当前目录位置  print name of current/working directory

touch 创建文件
touch ex2
用法：touch [选项]... 文件...
将每个文件的访问时间和修改时间改为当前时间。
不存在的文件将会被创建为空文件，除非使用-c 或-h 选项。
touch {连续数字或字母} 创建多个文件序列
touch {1..10}
touch {a..z}
  -c, --no-create       不创建任何文件
  -t STAMP              使用[[CC]YY]MMDDhhmm[.ss] 格式的时间替代当前时间
  -r, --reference=文件  使用指定文件的时间属性替代当前文件时间
```

# cp复制

> 参考：https://www.yuque.com/chengkanghua/awf7cm/sdeetr#Tcfz6
```bash
用法：cp [选项]... [-T] 源文件 目标文件
　或：cp [选项]... 源文件... 目录
　或：cp [选项]... -t 目录 源文件...
将源文件复制至目标文件，或将多个源文件复制至目标目录。
-r 递归式复制目录，即复制目录下的所有层级的子目录及文件 -p 复制的时候 保持属性不变
-d 复制的时候保持软连接(快捷方式)
-a 等于-pdr
-p                等于--preserve=模式,所有权,时间戳，复制文件时保持源文件的权限、时间属性
-i, --interactive        覆盖前询问提示


cp 用来将一个或多个源文件或者目录复制到指定的目的文件或目录
  -a：此参数的效果和同时指定"-dpR"参数相同；
  -d：当复制符号连接时，把目标文件或目录也建立为符号连接，并指向与源文件或目录连接的原始文件或目录；
  -p：保留源文件或目录的属性；
  -R/r：递归处理，将指定目录下的所有文件与子目录一并处理；


  如何备份
cp oldboy.txt  oldboy.txt.bak

```

# mv命令

> 参考：https://www.yuque.com/chengkanghua/awf7cm/sdeetr#RXUcJ
```bash
# mv- move (rename) files
#把 /data 移动到 /root目录下面
mv  /data/ /root/

```

# rm命令

> 参考：https://www.yuque.com/chengkanghua/awf7cm/sdeetr#o4TYx
```bash
rm -  rm - remove files or directories
#强制删除目录
rm -rf  /tmp/data/
rm -rf  /tmp/data/
rm -fr /tmp/data/
        -f 强制删除 不提示
	      -r 删除目录

用法：rm [选项]... 文件...
删除 (unlink) 文件。
rm命令就是remove的含义，删除一个或者多个文件，这是Linux系统重要命令
-f, --force           强制删除。忽略不存在的文件，不提示确认
-i                    在删除前需要确认
-I                    在删除超过三个文件或者递归删除前要求确认。
-d, --dir    删除空目录
-r, -R, --recursive   递归删除目录及其内容
-v, --verbose         详细显示进行的步骤
      --help            显示此帮助信息并退出
      --version         显示版本信息并退出
 
案例：
1.删除普通文件,需要确认提示,默认添加了-i参数
rm file1.txt
2.强制删除文件，不提示
rm -f file2.txt
3.递归删除文件夹
[root@pylinux tmp]# rm -r heh/
rm：是否进入目录"heh/"? y
rm：是否删除普通空文件 "heh/kuanmian2"？y
rm：是否删除普通空文件 "heh/kuanmian"？y
rm：是否删除目录 "heh/"？y

炸弹命令
1.强制删除且不让用户确认
rm -rf 文件夹
2.强制删除且显示过程
[root@pylinux tmp]# rm -rfv ./*
已删除"./456.txt"
已删除目录："./q/w/e/r/t/yt"
已删除目录："./q/w/e/r/t"
已删除目录："./q/w/e/r"
已删除目录："./q/w/e"
已删除目录："./q/w"
已删除目录："./q"
```



# 别名 alias
```bash
\cp = 强制使用 原始、原生的 cp 命令 跳过所有别名（alias），不询问，不绕弯
\rm    不询问删除
\mv    不询问移动/覆盖
\ls    不使用 ls 别名

\rm     \命令相当于直接输入命令路径使用  /bin/rm
#使用命令的绝对路径（全路径）
# which cp  #命令的绝对路径（全路径）
alias cp='cp -i'
	/bin/cp

#alias 显示系统中的别名
#设置别名
alias wang='rm -i'
alias 别名='命令'

# 配置rm别名-永久生效 =修改文件 /etc/profile
vim /etc/profile
export rm=’echo rm bny’
[root@oldboyedu50 ~]# source /etc/profile
[root@oldboyedu50 ~]# alias rm
alias rm='echo rm bny'
# 每个用户家目录/.bashrc 配置的下别名优先于 /etc/profile
# 所以要把这里的  # alias rm=‘rm -i’
[root@oldboyedu50 ~]# vim   /root/.bashrc
# alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -重新登录 并检查
[root@oldboyedu50 ~]# alias rm
alias rm='echo rm bny'

```

# 用户管理
```bash
第一类：root（超级管理员），UID为0，这个用户有极大的权限，
第二类：系统用户，UID为1～499。一般是不会被登入的。
第三类就是普通用户，UID范围一般是500～6553


常用命令解释器
/bin/sh 默认 
/bin/bash 默认
/sbin/nologin 虚拟用户
/dash ubuntu 
csh unix
tsh unix
CopyErrorOK!
用户信息配置文件
/etc/passwd 用户信息
/etc/shadow  用户密码信息
/etc/group 用户组信息
/etc/gshadow 用户组密码信息
/etc/skel


用户管理的命令
命令	作用
useradd	创建用户
usermod	修改用户信息
userdel	删除用户及配置文件
passwd	更改用户密码
chpasswd	批量更新用户密码
chage	修改用户密码属性
id	查看用户UID、GID、组信息
su	切换用户
sudo	用root身份执行命令
visudo	编辑sudoers配置文件


# su - root
Password:123456
[root@localhost ~]# 切换成功
```



# uname
```plain
#主要功能：获取计算机操作系统相关信息
root@VM-4-16-ubuntu:~# uname -a
Linux VM-4-16-ubuntu 4.15.0-193-generic #204-Ubuntu SMP Fri Aug 26 19:20:21 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
```



计算机中的单位

```plain
# 1TB = 1024GB
# 1GB = 1024MB
# 1MB = 1024KB
# 1KB（千字节） = 1024B（字节）
```

# pwd
```plain
#主要功能：pwd=print working directory，打印当前工作目录（告诉我们，我们当前位置）
```

# clear
```plain
主要功能：清屏
```

# type
```plain
# 主要功能：主要用来结合help命令，用于判断命令的类型（属于内部命令还是外部命令）
# type 命令
内部命令：命令 is a shell builtin
外部命令：没有显示以上信息的就是外部命令
```

# History
```plain
# 主要功能：显示系统以前输入的前1000条命令
```

# hostnamectl
```plain
# 主要功能：用于设置计算机的主机名称（给计算机起个名字），此命令式CentOS7新增的命令。
hostnamectl ： hostname + control

# 获取计算机名称
# hostname	CentOS6
# hostnamectl  CentOS7

### 机的主机名称

Centos7中主机名分3类，静态的（static）、瞬态的（transient）、和灵活的（pretty）。

① 静态static主机名称：电脑关机或重启后，设置的名称亦然有效

② 瞬态transient主机名称：临时主机名称，电脑关机或重启后，设置的名称就失效了

③ 灵活pretty主机名称：可以包含一些特殊字符

CentOS 7中和主机名有关的文件为/etc/hostname，它是在系统初始化的时候被读取的，并且内核根据它的内容设置瞬态主机名。

> 更改主机名称，让其永久生效？① 使用静态的 ② 改/etc/hostname文件


① 瞬态主机名称（临时设置）
# hostnamectl --transient set-hostname 主机名称
主机名称 建议遵循 FQDN协议（功能+公司域名）
web01.itcast.cn
web02.itcast.cn

案例：临时设置主机名称为yunwei.itcast.cn
# hostnamectl --transient set-hostname yunwei.itcast.cn
# su 立即生效

② 静态主机名称（永久生效）
# hostnamectl --static set-hostname 主机名称
温馨提示：--static也可以省略不写

案例：把计算机的主机名称永久设置为yunwei.itcast.cn
# hostnamectl --static set-hostname yunwei.itcast.cn
# su 立即生效

③ 灵活主机名称（主机名称可以添加特殊字符）
# hostnamectl --pretty set-hostname 主机名称（包含特殊字符）

案例：把计算机的主机名称通过灵活设置，设置为yunwei's server01
# hostnamectl --pretty set-hostname "yunwei's server01"
查看灵活的主机名称
# hostnamectl --pretty
```

# lrzsz
```bash
yum install lrzsz –y
rz  文件从windows上传到linux
sz   从linux中下载到windows
```

# linux帮助命令
```plain
语法
man 命令  
如：
man  ls  
进入man帮助文档后，按下q退出

语法：
命令 --help
帮助命令的精简版
如 ls --help

语法：
help  命令  
只针对bash内置命令

语法：
info 命令


互联网有很多在线linux中文文档网站
```

# linux开关机命令
### reboot
主要功能：立即重启计算机

poweroff

halt

### shutdown
```plain
# 主要功能：立即关机或延迟关机
# shutdown -h 0或now
# shutdown -h 0
# shutdown -h now
选项说明：
-h ：halt缩写，代表关机

# 在Linux系统中，立即关机除了使用shutdown -h 0以外还可以使用halt -p命令

# 10分钟后关机
# shutdown -h 10
光标一直不停的闪，取消关机
# 按Ctrl + C（CentOS6，中断关机。CentOS7中还需要使用shutdown -c命令）
# shutdown -c


重启
语法：
shutdown -r参数    -r --reboot    Reboot the machine
shutdown -r 10    #十分钟后重启
shutdown -r 0        #立刻重启
shutdown -r now #立刻重启
```

_关机、重启、注销命令列表_

| 命令 | 说明 |
| --- | --- |
| shutdown -h now | 立刻关机，企业用法 |
| shutdown -h 1 | 1分钟后关机，也可以写时间如 11:30 |
| halt | 立刻关闭系统，需手工切断电源 |
| init 0 | 切换运行级别为0，0表示关机 |
| poweroff | 立刻关闭系统，且关闭电源 |
| 重启 | |
| reboot | 立刻重启机器，企业用法 |
| Shutdown -r now | 立刻重启，企业用法 |
| shutdown -r 1 | 一分钟后重启 |
| Init 6 | 切换运行级别为6，此级别是重启 |
| 注销命令 | |
| logout | 注销退出当前用户 |
| exit | 注销退出当前用户，快捷键ctrl + d |




# 显示与设置系统时间  date
```bash
# date +%F && date +%Y-%m-%d
2024-08-17
2024-08-17
# date +%T && date +%H:%M:%S
20:24:05
20:24:05

# %w day of week (0..6); 0 is Sunday #周几  0是周日
# date +%w   
6

# 显示当前日期格式: 年月日_小时  ?
[root@m01 ~]# date +%Y"年"%m"月"%d"日"_%H"小时"
2024年08月17日_20小时
[root@m01 ~]# date -d "1 day ago"
Fri Aug 16 20:26:47 CST 2024
[root@m01 ~]# date -d "1day"
Sun Aug 18 20:27:00 CST 2024
[root@m01 ~]# date -d "-1day"
Fri Aug 16 20:27:11 CST 2024
[root@m01 ~]# date -d "-1day" +%F
2024-08-16

-d  根据你的描述显示指定日期
-d  '-7day'  7天之前
-d  '7day'   7天之后
-d '+7day'   7天之后


# date -s 设置系统时间
date -s "20241001 10:10:10"
# 再同步到硬件时间
hwclock --systohc

# 查看硬件时间
hwclock --show 
hwclock -r




 
```

# linux 环境变量
```plain
执行命令：
echo $PATH
echo命令是有打印的意思
$符号后面跟上PATH,表示输出PATH的变量


PATH 存放是linux 下命令的路径（位置）
[root@oldboy ~]#echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
/bin/
/sbin
/usr/bin
/usr/sbin
/usr/local/bin
/usr/local/sbin

linux  执行命令的过程
是否是别名

在 PATH中找命令是否存在
1提示  command not found
2 执行
```

# 字符集
```bash
GBK 国家标准
UTF-8 万国码   
#1.查看字符集           
# echo $LANG
en_US.UTF-8
# #en_US 英文语言 
# #UTF-8 字符集

# #语言.字符集
#2.修改字符集-临时
# export  LANG=zh_CN.UTF-8       
# echo $LANG
zh_CN.UTF-8
          
#3.永久修改字符集
# cat /etc/sysconfig/i18n 
LANG="en_US.UTF-8"
SYSFONT="latarcyrheb-sun16"

# source /etc/sysconfig/i18n
# echo $LANG
en_US.UTF-8



# centos7 字符集（locale）的配置文件 /etc/locale.conf
[root@m01 ~]# cat /etc/locale.conf
LANG="en_US.UTF-8"

sudo localectl set-locale LANG=en_US.UTF-8  #立即生效不用重启系统

[root@m01 ~]# localectl status   #查看当前区域设置
   System Locale: LANG=en_US.UTF-8
       VC Keymap: us
      X11 Layout: us

```





# 练习
```bash
[root@oldboyedu-49 ~]# lidao  2>> /data/oldboy.txt  # 2>> 标准错误追加重定向
[root@oldboyedu-49 ~]# cat /data/oldboy.txt
oldboyav.com
-bash: lidao: command not found


echo lidao >> /data/oldboy.txt  2>&1   # 2>&1把错误和正确信息都存放到文件中


# 在 /data 下面创建文件 oldboy.txt
touch /data/oldboy.txt

# 为oldboy.txt增加内容"I am studying linux."

# 方法1 vim 
	vim /data/oldboy.txt
	i 插入 I am studying linux
	esc  :wq 保存退出
	cat /tmp/oldboy.tx

# 追加重定向    >>     # >   重定向 : 会清空文件内容 
echo ""I am studying linux."" >> /data/oldboy.txt

# cat 追加内容
cat >> /data/oldboy.txt <<EOF
dddos.com
xxs.com
nmap.com
EOF

# 把文件/data/oldboy.txt内容修改为
dddos.com
xxs.com
nmap.com

cat >/data/oldboy.txt<<AV
dddos.com
xxs.com
nmap.com
AV


# 同时把错误和正确信息都记录下来
lidao  >>/data/oldboy.txt  2>> /data/oldboy.txt
echo lidao  >>/data/oldboy.txt  2>> /data/oldboy.txt
cat /data/oldboy.txt


echo lidao  >>/data/oldboy.txt  2>&1



# <   输入重定向
[root@m01 ~]# echo '1 2 3 4  5 6 7' > /tmp/test.txt
[root@m01 ~]# xargs -n2 < /tmp/test.txt
1 2
3 4
5 6
7

# <<  追加输入重定向   向文件中追加多行
cat >/data/text.txt<<EOF
cnblog.com/
wechat:11234
qq:1234
EOF


# 把oldboy.txt拷贝(复制)到/tmp下
cp /data/oldboy.txt  /tmp/

# -r 递归复制  复制目录及目录内容  # -a –pdr
cp -r /data/ /tmp/

man cp 
cp -a  === -pdr
-p  复制保持属性不变
-d  软链接相关
-r  递归

# 把 /data 移动到 /root目录下面
mv /data /root/


# rm
rm  oldboy.txt  #删文件
rm -r data/     #删目录   加-f 不提示
防止误删除:
1.危险参数放最后
2.尽量不要加上-r
3.精确删除


#find  /data/   -type f            -name  "lidao.txt"
#find  在哪里找 -类型 f(file文件)  -名字 "名字"

# * 所有任何
find  /data/  -type f  -name  "*.txt"


# find命令找出的文件 交给 ls -l
find /tmp/ -type f -name "*.txt" |xargs ls -l
```





















> 更新: 2026-04-23 17:10:10  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/xoag7l>