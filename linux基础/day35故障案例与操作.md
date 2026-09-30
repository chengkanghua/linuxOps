# day35故障案例与操作



![1547281121531-38fbae98-f233-48e9-9139-2e68b4cdd2ba.png](img/day35%E6%95%85%E9%9A%9C%E6%A1%88%E4%BE%8B%E4%B8%8E%E6%93%8D%E4%BD%9C-01.png)



![1547281191918-18150968-4f60-42c5-828a-1a71705bb785.png](img/day35%E6%95%85%E9%9A%9C%E6%A1%88%E4%BE%8B%E4%B8%8E%E6%93%8D%E4%BD%9C-02.png)









![1547281292574-ff0a3a06-0177-4cdb-bc8e-4e95826895af.png](img/day35%E6%95%85%E9%9A%9C%E6%A1%88%E4%BE%8B%E4%B8%8E%E6%93%8D%E4%BD%9C-03.png)



[day35故障案例与操作.xmind](https://www.yuque.com/attachments/yuque/0/2019/xmind/194754/1554020751356-d35abd77-1f78-4456-8ea1-976ad8a169cd.xmind)

[CentOS-如何进入救援模式.pdf](https://www.yuque.com/attachments/yuque/0/2019/pdf/194754/1554020762520-81bc69fc-f99f-4756-a965-6af310822369.pdf)





# 写一段shell脚本，输出同时存在于file1和file2中用户名的密码
如果用户名同时存在 输出用户名的密码

```plain
cat > file1<<EOF
user passwd
oldboy   1234
alex    4567
lidao   9999
EOF
cat > file2<<EOF
id user
001 lidao
002 alex
003 oldboy
004 oldgirl
EOF

# FNR 每个文件的行号 每个文件都会从1开始   NR 行号
# awk '{print FNR,NR,$1,$2}' file1 file2
1 1 user passwd
2 2 oldboy 1234
3 3 alex 4567
4 4 lidao 9999
1 5 id user
2 6 002 alex
3 7 003 oldboy
4 8 004 oldgirl
# awk 'FNR==NR{print "frist file"}FNR!=NR{print "2 file"}' file1 file2
frist file
frist file
frist file
frist file
2 file
2 file
2 file
2 file
awk 'FNR==NR{h[$1]=$2;}' file1 file2
# awk 'FNR==NR{h[$1]=$2;}FNR!=NR{print h[$2]}' file1 file2
passwd
4567
1234
# awk 'FNR==NR{h[$1]=$2;next}{print $2,h[$2]}' file1 file2
user passwd
lidao 9999
alex 4567
oldboy 1234
oldgirl
# awk 'FNR==NR{a[$1]=$2;next} $2 in a{print $2,a[$2]}' file1 file2
user passwd
lidao 9999
alex 4567
oldboy 1234
```





# linux启动流程 (centos6)


```bash
1	开机自检（BIOS）
2	MBR引导 |0磁头0磁道1扇区前446字节 | GPT (支持更大硬盘)
3	GRUB菜单  |选择内核（修改启动的时候内核参数）
        centos6.  进入单用户
        centos7.  救援模式
4	KERNEL 内核
5	init  进程
6	/etc/inittab 运行级别 
7	/etc/rc.d/rc.sysinit  初始化系统
8	/etc/rc.d/rc*.d   根据运行级别 启动不同的开机自启动服务      /etc/rc.local			
9	mingetty  进程 登入界面
```



# linux运行级别


```bash
运行级别含义
   0关机
   1 单用户
   2  多用户模式不能NFS
   3 完全多用户模式（默认工作环境）
   4待开发
   5 图形化桌面模式
   6 重启
   
# 如何查看与修改  
runlevel #查看当前运行级别   
init 3 #切换运行级别
```



# 软硬链接的区别
```bash
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
  
```



# 2 故障案例？
1. 遇到过什么故障

	2）套路（尽量不要停）

				自我介绍

				工作经历

				HR谈人生



## 磁盘空间不足系列(no space left on device)
[三种原因解释Linux磁盘空间不足.pdf](https://www.yuque.com/attachments/yuque/0/2026/pdf/194754/1777276213377-f500d8fd-75b7-4a1b-b6aa-0fccc331182b.pdf)



```bash
a）block满了 df –h  ； du –sh /data |sort –h  #具体到文件和目录  确认之后删除

创建文件提示no space left on device , df –h 没有满  还有空间  问什么原因导致？ 

b）df –i   #inode满了  定时任务
查找大于1M 目录 确认之后删除

c）block满了 提示no space left on device  ； df –h 满了， /data满了，  du –sh /data 没有满
文件没有彻底删除
lsof | grep delete      重启对应的服务/进程


```

## linux显示中文乱码
```bash
原因： 系统与远程连接工具字符集不同
排查： 1查看系统的字符集 echo $LANG  
      2检查xshell使用的字符集
解决 ； a)修改xhell字符集
    		b）修改系统字符集
				export LANG=en_US.UTF-8
				vim /etc/sysconfig/i18n 里面的字符集
							LANG=”en_US.UTF8”
				source /etc/sysconfig/i18n
				echo $LANG
```

## 定时任务书写不当导致inode满了
```bash
crontab –e
		>/dev/null 2>&1
		>>/tmp/oldboy.log 2>&1
删除 大量小文件
	a)ls/find +|xargs
	b)缩小范围ls/find +|xargs
  c)删除文件所在目录(记录好权限和所有者)
```



## 权限拒绝 permission denled
```bash
文件    显示文件内容
  			修改文件内容
  			执行脚本
目录
		创建 删除 重命名
		查看目录	
    
对于文件rwx 含义
	r 读取文件内容
	w 修改文件内容， 需要r权限配合  （只有w权限，强制保存退出会导致源文件内容丢失）
	x 权限表示是否能执行脚本， 需要r权限配合
对于目录 rwx 含义
r 查看目录 ls   需要x权限配合（x是否能看到文件的属性）
w 在目录下创建  删除 修改文件名（w 删除权限需要x配合）
x 是否能进入到这个目录 cd （是否能看到目录中文件的属性 需要r权限配合）
	删除一个文件  看文件所在目录的权限 是否有wx权限
```

### /app/blog/upload   网站上传文件报错？
		

```bash
www
  touch /app/blog/upload/lidao.avi
  解决：
  方法1  修改upload的权限 o+w  （不推荐）  upload  757
  方法2  upload 所有者修改为www    chown www.www upload
```



## 命令行 ~bash-4.1$如何解决？
```bash
cp /etc/skel/.bash*  ~/
```

## JAVA环境变量故障，导致tomcat无法启动？


```bash
每天重启tomcat
脚本.sh  -->  stop  start
写入定时任务 定时任务运行 启动后无法使用    #背景
定时任务运行脚本PATH 只有/usr/bin 和/bin    #原因
把tomcat相关的环境变量写入脚本开头			#解决
```



## java程序大量占用内存，内存不足，占用swap？


```bash
dd if=/dev/zero of=/tmp/1G  bs=1M  count=1024  #创建文件
mkswap /tmp/1G   # 创建swap类型
swapon /tmp/1G      # 激活
swapon –s   #显示交换分区组成情况
永久挂载 /etc/fstab
   /tmp/100g swap swap defaults 0 0   
```



## 拿到磁盘到最终使用过程
```bash
[root@ckh tmp]# dd if=/dev/zero of=/tmp/200m bs=1M count=200
[root@ckh tmp]# mkfs.ext3 /tmp/200m
[root@ckh tmp]# file /tmp/200m
/tmp/200m: Linux rev 1.0 ext3 filesystem data
[root@ckh tmp]# mount -o loop /tmp/200m  /media
[root@ckh tmp]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        19G   13G  5.4G  70% /
tmpfs           238M     0  238M   0% /dev/shm
/dev/sda1       190M   40M  141M  22% /boot
/dev/sdb1        45M  810K   42M   2% /data1
/dev/sdc1       8.3M   90K  7.7M   2% /sdc1
/dev/sdc2        33M  467K   31M   2% /sdc2
/tmp/200m       194M  5.6M  179M   4% /media
****************************************************华丽的分割线***************************
1. fdisk  pared  分区工具  partprobe /dev/sdb1 通知系统分区表变化
2. mkfs.ext4  && tune2fs –c 0 –i 0 /dev/sdb1  #格式化并关闭磁盘自动检查
3. 挂载 mount /dev/sdb1 /data
4. 永久挂载 /etc/fstab   或者 /etc/rc.local
```



## yum源  阿里云  清华
[https://mirrors.tuna.tsinghua.edu.cn/](https://mirrors.tuna.tsinghua.edu.cn/)     centos？ epel

[https://opsx.alibaba.com/mirror](https://opsx.alibaba.com/mirror)           centos 帮助 epel帮助





## 单用户模式
1重启后   按任意键进入单用户模式

2 进入GRUB菜单

3 按a 编辑内核参数 写入 空格 1 或single

4 成功进入单用户模式

修改密码后  ctrl+d 退出单用户模式

[linuix单用户修改密码.docx](https://www.yuque.com/attachments/yuque/0/2026/docx/194754/1777276154646-a3071c01-37cd-43e7-82fc-7ee7406bd116.docx)



## 救援模式
连接上光盘

开机按一下 esc   或者F2   重启按ctrl alt insert    esc

选第三个<font style="background-color:#ffff00;">resccue installed system</font> 救援模式进入

<font style="background-color:#ffff00;">提示都默认  就一个 setup network   选no 不启用网络</font>

![1547281053670-7cd2352a-3713-4a50-a657-4e97d498e040-image2.png](img/day35%E6%95%85%E9%9A%9C%E6%A1%88%E4%BE%8B%E4%B8%8E%E6%93%8D%E4%BD%9C-04.png)  <font style="color:#0070C0;">#提示原来的系统放入 /mnt/sysimage </font>

![1547281053706-07230236-47a7-46b4-8d21-1fcff72bc882-image3.png](img/day35%E6%95%85%E9%9A%9C%E6%A1%88%E4%BE%8B%E4%B8%8E%E6%93%8D%E4%BD%9C-05.png)

<font style="background-color:#ffff00;">chroot /mnt/sysimage</font> <font style="color:#0070C0;">#把当前使用的/目录切换为这个下面</font>

退出ctrl +d  两次 选 reboot就可以了



# vim快捷键


```bash
1测试文件 cat /etc/services /etc/sysconfig/network-scripts/ifcfg-eth0 >>/tmp/vim.log

2移动光标
↑k
←h    		→l
↓j
gg        光标移动到文件的第一行
G         光标移动到文件的最后一行
100gg      到100行
:100		到100行
$      光标移动到这一行的行尾
0      光标移动到这一行的行首

3编辑
o 在当前行下面插入一个空行进入编辑模式
O  在当前行上面 插入一个空行进入编辑模式
C  删除光标到行尾的内容进入编辑模式
A  快速到达行尾 进入编辑模式
D  删除当前光标到行尾
cc 清空当前行并进入编辑模式

4复制 删除 粘贴
yy   复制当前光标所在行
p   粘贴
3p  多次粘贴
dd  删除当前行  剪切行
dG  删除当前行到结尾的内容
:3,5move10   3.5行剪切到10行后面
:3.5copy10   3行到5行拷贝到10行后面

5其他
	:set nu  显示行号
	:set nonu   取消显示行号
	/搜索的内容  enter   n 继续向下查找   N继续向上查找
	:noh 临时取消语法的高亮
	u  撤销刚才的操作
	vim 中 帮助
		：help G
		：help ：noh
		：q 退出帮助
	替换
		:%s#yes#no#g   替换所有
		:102,$s#yes#no#g  替换某个范围的
		:s#yes#no#g   替换当前行
    
6批量操作
	批量删除操作：
	1 ctrl + v  可视块模式
	2 通过上下左右  选择
	3 按d 删除所选内容
	批量编辑：
	1 ctrl + v  可视块模式
	2 通过上下左右  选择
	3 大写I  shift+i
	4 编辑完成 按 esc 等等
  
7 常见故障
模拟：	编辑文件的时候断开链接 ，再次编辑
故障：   found a swap file by the name ‘.vim.log.swp’
			swap file ‘.vim.log.swp’ already exists
解决：  删除临时文件
		vim –r vim.log 恢复丢失的内容 ， :wq 保存退出 再删除临时文件
    
```







# 复习题
## 1.三剑客过滤  指哪打哪
```bash
grep –v 'oldboy' oldboy.txt

sed –n '3p' oldboy.txt
sed –n '20,30p' oldboy.txt
sed '/oldboy/d' oldboy.txt

awk '！/oldboy/' oldboy.txt
awk '/oldboy/' oldboy.txt
awk 'NR==20,NR==30' oldboy.txt
```



##  2.显示日期 打包压缩并添加上日期
```bash
[root@ckh ~]# date +%N  #纳秒
907719701
[root@ckh ~]# date +%F   #年月日   date +%T时分秒 date +%H%M%S
2018-08-28
[root@ckh ~]# date +%Y%m%d   #年月日
20180828
tar zcf /tmp/etc-`date +%Y%m%d`.tar.gz  /etc
```

## 3.find+sed  遇到故障排查流程
```bash
find /oldboy –type f –name "*.sh" |xargs sed –i 's#oldboy#oldgirl#g'
```

## 4.快捷键  关机重启
```bash
shutdown –h now 
init 0
poweroff

shutdown –r 0
init 6
reboot
```



## 5.如何修改PATH 
```bash

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin 
```

## 6.linux如何知道我对某个文件或目录有什么权限？ 
```bash
ls -l
```

## 7.修改权限与所有者  
```bash
chmod 644 oldboy.txt  #修改权限
chown www.www  oldboy.txt  #修改所有者
```



## 1.文件 目录 rwx 含义 
```bash
对于文件的rwx含义
	r 可以读取文件
	w 可以修改文件 （需要r权限配合，） 没有r权限强制保存会导致源文件丢失
	x  执行权限 （需要r权限配合）
  
对于目录的rwx 含义
	r 查看目录列表 ls  （需要x权限配合看文件属性）
	w  可以在目录下 删除 创建 重命名文件 （删除文件需要x权限配合）
	x 可以进入目录 cd （是否能看到文件属性需要r权限配合）
		删除一个文件  看文件所在目录的权限 是否有wx权限
        
```

## 2.权限相关错误:  permission denied  原因及解决
```bash
$ ls /root/ 
ls: cannot open directory /root/: Permission denied
目录没有rx权限 

$ touch /etc/passwd.txt 
touch: cannot touch `/etc/passwd.txt': Permission denied
目录没有wx权限 

$ \rm -f /etc/sysconfig/network 
rm: cannot remove `/etc/sysconfig/network': Permission denied
目录没有 wx权限 

$ echo '#oldboy'  >>/etc/hosts  
-bash: /etc/hosts: Permission denied
文件没有w权限

$ cat /etc/shadow 
cat: /etc/shadow: Permission denied 
文件没有r 权限

```



## 3.系统默认的权限 umask 计算 
```bash
文件的默认最高权限666   
目录最高权限777
用最高权限减去 umask值  就是系统的默认权限
文件权限减去后如果有奇数要加1

```

## 4.如何通过控制权限的方法 让网站安全
```bash
file 644
dir 755
chown www.www /app/blog/upload/


```

## 5.网站集群架构 数据库 存储
![1547281452915-a77baeb1-c39c-4262-8c34-a43869c377af-image2.png](img/day35%E6%95%85%E9%9A%9C%E6%A1%88%E4%BE%8B%E4%B8%8E%E6%93%8D%E4%BD%9C-06.png)

## 6.隐藏属性（文件系统权限）
```bash
chattr  +a  目标   
#   +a文件只能被追加不能被删除   +i 不可摧毁  不能删除不能修改不能追加

lsattr   查看隐藏属性

用法: 
  一般命令加i权限  
  系统配置文件加a权限
```











	



> 更新: 2026-04-27 15:50:35  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/zneigx>