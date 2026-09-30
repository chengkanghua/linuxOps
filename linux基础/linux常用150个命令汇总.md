# linux常用150个命令汇总

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- linux 常用 150个命令汇总
  - ●线上查询及帮助命令（2 个）
- [运维老鸟分享linux运维发展路线规划](https://blog.51cto.com/oldboy/1361536)
  - 线上查询及帮助命令(2个)
  - 文件和目录操作命令(18个)
  - 查看文件及内容处理命令（21个）
  - 文件压缩及解压缩命令（4个）
  - 信息显示命令（11个）
  - 搜索文件命令（4个）
  - 用户管理命令（10个）
  - 基础网络操作命令（11个）
  - 深入网络操作命令（9个）
  - 有关磁盘与文件系统的命令
  - 系统权限及用户授权相关命令（4个）
  - 查看系统用户登陆信息的命令（7个）
  - 内置命令及其它（19个）
  - 系统管理与性能监视命令(9个)
  - 关机/重启/注销和查看系统信息的命令（6个）
  - 进程管理相关命令（15个）
  - 三剑客

# linux 常用 150个命令汇总

![1553346369541-ff44190a-add2-4f02-a408-120380296518.png](img/linux%E5%B8%B8%E7%94%A8150%E4%B8%AA%E5%91%BD%E4%BB%A4%E6%B1%87%E6%80%BB-01.png)



## ●线上查询及帮助命令（2 个） 

man help info



●文件和目录操作命令（19 个） 

ls cd cp find mkdir mv pwd rename rm rmdir touch tree 

basename dirname chattr lsattr file md5sum



●查看文件及内容处理命令（19 个） 

cat tac more less head tail cut split paste sort uniq wc iconv 

dos2unix file diff vimdiff rev grep egrep join tr vi/vim 

●文件压缩及解压缩命令（4 个） 

tar unzip gzip zip 

●信息显示命令（12 个） 

uname hostname **dmesg **uptime file stat du df top free date cal 

●搜索文件命令（4 个） 

which find whereis locate 

●用户管理命令（10 个） 

useradd usermod userdel groupadd passwd chage id su  

visudo sudo  

●基础网络操作命令（10 个） 

telnet ssh scp wget ping route ifconfig ifup ifdown netstat 

●深入网络操作命令（6 个） 

nmap lsof route mail mutt nslookup dig host traceroute 

tcpdump



●有关磁盘与文件系统的命令（10 几个） 

mount umount df du fsck dd dumpe2fs dump fdisk parted  

mkfs partprobe e2fsck mkswap swapon sync resize2fs 

●关机和查看系统信息的命令（3 个） 

shutdown halt init 

●系统管理相关命令（8 个） 

uptime top free vmstat mpstat iostat sar(sysstats) chkconfig 

●系统安全相关命令（10 个） 

chmod chown chgrp chage passwd su sudo umask chattr  

lsattr 

●查看系统用户登陆信息的命令（7 个） 

whoami who w last lastlog users finger 

●其它（19 个） 

echo printf rpm yum watch alias unalias date clear history  

eject time nohup nc xargs exec export unset type bc 

●系统性能监视高级命令(12 个) 

内存:top free vmstat mpstat iostat sar 

CPU:top vmstat mpstat iostat sar 

I/O:vmstat mpstat iostat sar 

进程:ipcs ipcrm lsof strace lstrace 

负载:uptime

●关机/重启/注销命令（7） 

关机重启: 

shutdown init halt poweroff reboot 

注销退出： 

logout exit ctl+d ——>快捷键(生产常用) 

●进程管理：（16 个） 

bg：后台运行 fg：挂起程序 jobs：显示后台程序 kill,killall,pkill：杀掉进程 

crontab：设置定时 ps：查看进程 pstree：显示进程状态树 

top：显示进程 nice：改变优先权 nohup：用户退出系统之后继续工作 

pgrep：查找匹配条件的进程 strace：跟踪一个进程的系统调用 

ltrace：跟踪进程调用库函数的情 vmstat：报告虚拟内存统计信息 

runlevel init service 

●非常危险的系统命令（5 个）： 

mv rm fdisk parted dd 

●linux 系统四位剑客（3 个） 

grep（egrep） sed awk





# [运维老鸟分享linux运维发展路线规划](https://blog.51cto.com/oldboy/1361536)










## 线上查询及帮助命令(2个)
	

| man | 帮助，命令的词典，更复杂的还有info，但不常用。 |
| --- | --- |
| help | 查看Linux内置命令的帮助，比如cd命令。 |


## 文件和目录操作命令(18个)
	**ls**

 全拼list，功能是列出目录的内容及其内容属性信息。

 -d  显示目录本身

 -t  时间排序

 -r 逆序

 -l 长格式显示详细信息

 -F 给不同类型的文件加上标记  

 -h  人类可读显示

 -i  显示inode 节点

 --full-time //以完整的时间格式显示

	**cd**

 全拼change directory，功能是从当前工作目录切换到指定的工作目录。

 cd .

 cd ..

 cd ~  

 cd -

	**cp**

 全拼copy，其功能为复制文件或目录。

 -p：保留源文件或目录的属性；

  -d 如果复制的源文件是符号链接，仅复制符号链接本身，保留符号链接所指向的目标文件或目录

  -a 等同于上面的p，d，r 这3个选项功能的总和

 -R/r：递归处理，将指定目录下的所有文件与子目录一并处理；

 -i 覆盖已有文件前提示用户确认

 -t 默认情况下命令格式是 “cp 源文件 目标文件” ，使用-t 可以颠倒顺序，格式为 “cp -t 目标文件 源文件”

	**find**

 查找的意思，用于查找目录及目录下的文件。

 find /oldoby/ 接路径

 -maxdepth  1  最大目录几层

 -type f  file 文件  d 目录

 -mtime +7  7天以前    -7 7天以内  7 第7天

 -name "*.sh"   查找的文件名

 -iname 查找的时候不区分大小写

 -exec ls -l {} \;  把查出的的结果 放入{}  

	**mkdir**

 全拼make directories，其功能是创建目录。

  -p  递归创建目录

  -m  设置新目录默认的对应的权限

	**mv**

 全拼move，其功能是移动或重命名文件。

 -f  若文件已存在，不会询问而直接覆盖

 -i  若目标文件已存在，就会询问是否覆盖

 -n 不覆盖已存在的文件

 -t 和cp命令-t 功能一样

	**pwd**

 全拼print working directory，其功能是显示当前工作目录的绝对路径。

	rename

 用于重命名文件。

	**rm**

 全拼remove，其功能是删除一个或多个文件或目录。

 -r或-R：递归删除目录及内容

 -f  删除不提示

 -i   在删除前需要确认

	**rmdir**

 全拼remove empty directories，功能是删除空目录。

	**touch**

 创建新的空文件，改变已有文件的时间戳属性。

 -t 201807281246.30 text1.txt  创建新文件时候，指定文件的时间的属性

 -d 20201001  text1.txt  修改已有文件的时间属性

 -r text.txt a.txt  修改a.txt 的时间属性，使其和text.txt 的时间属性一致

	**tree**

 功能是以树形结构显示目录下的内容。

 -d 只显示目录

 -L  1  显示第一层目录

 -F  与ls命令的-F 类似

	**basename**

 显示文件名或目录名。

	**dirname**

 显示文件或目录路径。

	**chattr**

 改变文件的扩展属性。

	**lsattr**

 查看文件扩展属性。

	**file**

 显示文件的类型。

	**md5sum**

 计算和校验文件的MD5值。  

## 查看文件及内容处理命令（21个）
	**cat**

 全拼concatenate，功能是用于连接多个文件并且打印到屏幕输出或重定向到指定文件中。

 -n  对所有输出的内容按行编号，不忽略空白行

 -b  对所有输出的内容按行编号， 忽略空白行

 -s  当遇到有连续两行以上的空白行时，就替换为一行空白行

	**tac**

 tac是cat的反向拼写，因此命令的功能为反向显示文件内容。

 -n  显示行号

	**more**

 分页显示文件内容。

 f 显示下一页

 b 上一页

 enter  一行一行显示

	**less**

 分页显示文件内容，more命令的相反用法。

	**head**

 显示文件内容的头部。

 -n 10  显示头10行 默认也是10行

	**tail**

 显示文件内容的尾部。

 -n

	**cut**

 将文件的每一行按指定分隔符分割并输出。

 -d ' '  指定分隔符

 -f3,6  指定多少列

 -b  以字节为单位进行分割

 -c  以字符为单位进行分割

 -d  自定义分隔符，默认以tab为分隔符

 -f  与选项-d 一起使用，指定显示哪个区域

 -n  取消分割多字节符，与选项-b 一起使用

 N  第N个字节、字符或字段

 N-  从第N个字节、字符或字段开始直至行尾  

 N-M  从第N到第M（含第M）个字节、字符或字段

 -M  从第1到第M （含第M）个字节、字符或字段

	**split**

 分割文件为不同的小片段。

	**paste**

 按行合并文件内容。

	**sort**

 对文件的文本内容排序。

 -h 人类可读显示

 -r  逆序

	**uniq**

 去除重复行。oldboy

	**wc**

 统计文件的行数、单词数或字节数。

 -l  多少行

	**iconv**

 转换文件的编码格式。

	**dos2unix**

 将DOS格式文件转换成UNIX格式。

	**diff**

 全拼difference，比较文件的差异，常用于文本文件。

	**vimdiff**

 命令行可视化文件比较工具，常用于文本文件。

	**rev**

 反向输出文件内容。

	**grep/egrep**

 过滤字符串，三剑客老三。

 -v       显示不匹配的行，或者说排除某些行

 -n       显示匹配行及行号

 -i        不区分大小写，只适用于单字符，默认是区分大小写的

 -c        只统计匹配的行数

 -E        使用扩展的egrep命令

 --color=auto     为grep过滤的匹配字符串添加颜色

 -w        只匹配过滤的单词

 -o         只输出匹配的内容

	**join**

 按两个文件的相同字段合并。

	**tr**

 替换或删除字符。

	**vi/vim**

 命令行文本编辑器。

 i 编辑模式

 o 光标一行新建一行

 :set nu 显示行号

## 文件压缩及解压缩命令（4个）
	**tar**

 打包压缩。oldboy

 zcf   打包名.tar.gz   目标

 tf    查看压缩包内容

 xf   解压文件名  -C  指定解压路径

 -exclude  排除解压  	tar zcf /tmp/etc-pai.tar.gz    /etc/  --exclude /etc/services  

	**unzip**

 解压文件。

	**gzip**

 gzip压缩工具。

	**zip**

 压缩工具。

## 信息显示命令（11个）
	**uname**

 显示操作系统相关信息的命令。

 -r  显示内核版本及64位

 -m 多少位的

	**hostname**

 显示或者设置当前系统的主机名。

 hostname oldboy  临时修改主机名

	**dmesg**

 显示开机信息，用于诊断系统故障。

	**uptime**

 显示系统运行时间及负载。

	**stat**

 显示文件或文件系统的状态。

	**du**

 计算磁盘空间使用情况。

	**df**

 报告文件系统磁盘空间的使用情况。

 -h 人类可读显示

	**top**

 实时显示系统资源使用情况。

	**free**

 查看系统内存。

 -h 人类可读显示

	**date**

 显示与设置系统时间。

 -s ”20180725 00:00:00“

	**cal**

 查看日历等时间信息。

## 搜索文件命令（4个）
	**which**

 查找二进制命令，按环境变量PATH路径查找。

	**find**

 从磁盘遍历查找文件或目录。

 -type  f 文件    d目录

 -name   “*.txt"  名字

 -iname  不区分大小写

 -size      文件大小  +100k   -10k

 -maxdepth    目录最大层级

 -mtime 按照文件的修改时间来查找文件

   	-n  表示文件更时间距离现在n天以内

   	+n  表示文件更改时间距现在n天以前

   	n   是距现在第n天

 -exec  对匹配的文件执行该参数所给出的shell命令  

   	！ 取反

   	-a  取交集（and）

   	-o 取并集（or）

	**whereis**

 查找二进制命令，按环境变量PATH路径查找。

	**locate**

 从数据库 (/var/lib/mlocate/mlocate.db) 查找命令，使用updatedb更新库。

## 用户管理命令（10个）
	**useradd**

 添加用户。

	**usermod**

 修改系统已经存在的用户属性。

	**userdel**

 删除用户。

	**groupadd**

 添加用户组。

	**passwd**

 修改用户密码。

	**chage**

 修改用户密码有效期限。

	**id**

 查看用户的uid,gid及归属的用户组。

	**su**

 切换用户身份。

	**visudo**

 编辑/etc/sudoers文件的专属命令。

	**sudo**

 以另外一个用户身份（默认root用户）执行事先在sudoers文件允许的命令。

## 基础网络操作命令（11个）
	**telnet** 使用TELNET协议远程登录。

	**ssh** 使用SSH加密协议远程登录。

	**scp** 全拼secure copy，用于不同主机之间复制文件。

	**wget** 命令行下载文件。

	**ping** 测试主机之间网络的连通性。

	**route** 显示和设置linux系统的路由表。

	**ifconfig** 查看、配置、启用或禁用网络接口的命令。

	**ifup** 启动网卡。

	**ifdown** 关闭网卡。

	**netstat** 查看网络状态。

	**ss** 查看网络状态。

## 深入网络操作命令（9个）
	**nmap** 网络扫描命令。

 nmap -p22,80,443 www.baidu.com

	**lsof** 全名list open files，显示所有被打开的文件

 -i:25  :25和-i选项组合可以让lsof列出占用TCP或UDP的25端口的进程。

 | grep delete   筛选被删除的文件

	**mail** 发送和接收邮件。

	**mutt** 邮件管理命令。

	**nslookup** 交互式查询互联网DNS服务器的命令。

	**dig** 查找DNS解析过程。

	**host** 查询DNS的命令。

	**traceroute** 追踪数据传输路由状况。

	**tcpdump** 命令行的抓包工具。

## 有关磁盘与文件系统的命令
	**mount** 挂载文件系统。

	**umount** 卸载文件系统。

	**fsck** 检查并修复Linux文件系统。

	**dd** 转换或复制文件。

	**dumpe2fs** 导出ext2/ext3/ext4文件系统信息。

	**dump** ext2/3/4文件系统备份工具。

	**fdisk** 磁盘分区命令，适用于2TB以下磁盘分区。

	**parted** 磁盘分区命令，没有磁盘大小限制，常用于2TB以下磁盘分区。

	**mkfs** 格式化创建Linux文件系统。

	**partprobe** 更新内核的硬盘分区表信息。

	**e2fsck** 检查ext2/ext3/ext4类型文件系统。

	**mkswap** 创建Linux交换分区。

	**swapon** 启用交换分区。

	**swapoff** 关闭交换分区。

	**sync **将内存缓冲区内的数据写入磁盘。

	**resize2fs** 调整ext2/ext3/ext4文件系统大小。

	**ln**  默认是创建硬链接

 -s  创建软链接

## 系统权限及用户授权相关命令（4个）
	**chmod** 改变文件或目录权限。

	**chown** 改变文件或目录的属主和属组。

	**chgrp** 更改文件用户组。

	**umask** 显示或设置权限掩码。

## 查看系统用户登陆信息的命令（7个）
	whoami 显示当前有效的用户名称，相当于执行id -un命令。

	who 显示目前登录系统的用户信息。

	w 显示已经登陆系统的用户列表，并显示用户正在执行的指令。

	last 显示登入系统的用户。

	lastlog 显示系统中所有用户最近一次登录信息。

	users 显示当前登录系统的所有用户的用户列表。

	finger 查找并显示用户信息。

## 内置命令及其它（19个）
	**echo** 打印变量，或直接输出指定的字符串

	**printf** 将结果格式化输出到标准输出。

	**rpm** 管理rpm包的命令。

 -qa  软件名    查询安装的软件信息

 -ql    软件名    显示软件文件列表

	**yum** 自动化简单化地管理rpm包的命令。

 -install   安装

 -y           自动yes

	**watch** 周期性的执行给定的命令，并将命令的输出以全屏方式显示。

	**alias** 设置系统别名。

	**unalias** 取消系统别名。

	**date** 查看或设置系统时间。

 -s “2018-07-25 00:00:00”

	**clear** 清除屏幕，简称清屏。

	**history** 查看命令执行的历史纪录。

 ctrl + r  搜索历史命令记录

	**eject** 弹出光驱。

	**time** 计算命令执行时间。

	**nc** 功能强大的网络工具。

 nc 10.0.0.200 22

	**xargs** 将标准输入转换成命令行参数。

 -n 几列显示

	**exec** 调用并执行指令的命令。

	**export** 设置或者显示环境变量。

	**unset** 删除变量或函数。

	**type** 用于判断另外一个命令是否是内置命令。

	**bc** 命令行科学计算器

## 系统管理与性能监视命令(9个)
	**chkconfig **管理Linux系统开机启动项。

  --level 2   设置2级别 chkconfig --level 2 iptables on

	**vmstat** 虚拟内存统计。

	**mpstat** 显示各个可用CPU的状态统计。

	**iostat** 统计系统IO。

	**sar** 全面地获取系统的CPU、运行队列、磁盘 I/O、分页（交换区）、内存、 CPU中断和网络等性能数据。

	**ipcs** 用于报告Linux中进程间通信设施的状态，显示的信息包括消息列表、共享内存和信号量的信息。

	**ipcrm**

 用来删除一个或更多的消息队列、信号量集或者共享内存标识。

	**strace**

 用于诊断、调试Linux用户空间跟踪器。我们用它来监控用户空间进程和内核的交互，比如系统调用、信号传递、进程状态变更等。

	**ltrace**

 命令会跟踪进程的库函数调用,它会显现出哪个库函数被调用。

## 关机/重启/注销和查看系统信息的命令（6个）
	**shutdown** 关机。

	**halt** 关机。

	**poweroff** 关闭电源。

	**logout** 退出当前登录的Shell。

exit 退出当前登录的Shell。

	Ctrl+d 退出当前登录的Shell的快捷键。

## 进程管理相关命令（15个）
	bg 将一个在后台暂停的命令，变成继续执行  （在后台执行）。

	fg 将后台中的命令调至前台继续运行。

	jobs 查看当前有多少在后台运行的命令。

	kill 终止进程。

	killall 通过进程名终止进程。

	pkill 通过进程名终止进程。

	crontab 定时任务命令。

	ps 显示进程的快照。

 -ef   显示程序 和对应环境变量   f树状显示

	pstree 树形显示进程。

	nice/renice 调整程序运行的优先级。

	nohup 忽略挂起信号运行指定的命令。

	pgrep 查找匹配条件的进程。

	runlevel 查看系统当前运行级别。

	init 切换运行级别。

	service 启动、停止、重新启动和关闭系统服务，还可以显示所有系统服务的当前状态。

 

## 三剑客
  sed   三剑客老二  取行  

    -n  取消默认输出    sed  -n '3p' 第3行     sed  -n '3,5p'  

    -i  修改文件内容  

    -i.bak  显示备份文件 修改文件内容

     's#oldboy#oldgirl#g'   替换  

     -r   支持扩展正则   sed -r 's#^.*t |/.*$##g

     sed '/^$/d' test.txt     // d删除 delete 按行单位

     

     s===sub

 awk   三剑客老大  取列

     NR 行号

     'NR==3,NR==5'  

     'NR==3{print $4}'  // $4 第4列  

   	-F '[: ]'    指定分隔符

   	awk '!/^$/' test.txt   // ！ 排除

 

 grep	它能使用正则表达式搜索文本，并把匹配的行打印出来。

    -v 反向选择

 

    



> 更新: 2020-05-19 15:00:00  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/bng95k>