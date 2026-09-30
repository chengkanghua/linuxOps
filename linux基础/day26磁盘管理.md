# day26磁盘管理

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- day26 磁盘管理
- 磁盘知识的体系结构
  - 1磁盘组成
  - raid 磁盘阵列
- 查看内存使用情况
- 磁盘分区fdisk
- parted 分区
- 命令小结
- 文件系统:
- 故障案例： java 程序占用大量内存，开始使用swap， swap不足增加swap

# day26 磁盘管理

![1546511412160-8a7b87cb-326e-4889-80f9-2fc46ccdebe6.png](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-01.png)





# 磁盘知识的体系结构


![1546511305757-ba8f4606-ff90-4b92-82bb-bcccd732ade0-image1.png](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-02.png)

![1546516088591-caac8ddd-d134-4188-9387-3b0367cf22fa.png](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-03.png)

## 1磁盘组成
	

```bash
磁盘 硬盘 disk（hard disk）
磁盘主要指标
	1 容量
	2 转速rpm    # round per minute  每分钟多少转  5400/7200/ 10000转/分钟                                    
		          固态硬盘 ssd  # Solid State Disk
				                 质保期 五年/300 TBW TB write
				                 数据： 备份3份
  3 计算磁盘大小公式
              柱面的大小 * 柱面的数量
              柱面的大小 = 磁道的大小* 磁头数量
              磁道的大小 = 每个磁道扇区数量*每个扇区大小


#列出所有分区表
# fdisk -l
Disk /dev/sda: 21.5 GB, 21474836480 bytes
255 heads, 63 sectors/track, 2610 cylinders
heads磁头	 每个磁道扇区数量63    柱面数量2610
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
									每个扇区大小	512
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00016896
Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          26      204800   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2              26         124      786432   82  Linux swap / Solaris
Partition 2 does not end on cylinder boundary.
/dev/sda3             124        2611    19979264   83  Linux
***************************************************************************************
# #255 heads, 63 sectors/track, 2610 cylinders
# # 磁头        每个磁道扇区数量     柱面数量
# echo  63*512|bc            #磁道大小=每个磁道扇区数量*每个扇区大小
32256
# echo 63*512*255|bc         #柱面的大小=磁道的大小*磁头数量
8225280
# echo 63*512*255*2610|bc    #磁盘大小=柱面的大小*柱面的数量
21467980800
# echo 63*512*255*2610/1024^3|bc   #不计算小数
19
# echo 63*512*255*2610/1024^3|bc -l  # -l 计算小数
19.99361515045166015625
# awk 'BEGIN{print 3/4,1/2,1/3}'  # awk中算数
0.75 0.5 0.333333
# awk 'BEGIN{print 63*512*255*2610/1024^3}' # awk计算
19.9936
字节 bytes
1KB=1024bytes
1MB=1024kb
1GB=1024MB

500G 实际到手容量不足500G？
厂家： 1000为单位 1kb=1000字节  1MB=1000kb
计算机中: 1024单位

linux 下面进行计算方法：
1 bc –l
2 awk BEGIN



# awk '{ip[$1]++}END{for (j in ip)print j,ip[j]}' access.log|sort -nr -k 2|head -5

# awk '{print $1}' access.log|sort|uniq -c|sort -nr|head -5

读cache  写buffer
00 00 * * *  /bin/bash clear.sh

什么是MBR,如何恢复MBR，MBR位于那里，占多少字节，如何复制出MBR  /tmp
MBR 主引导记录
0磁头0磁道1扇区512字节前446字节
dd if=/dev/sdb of=/tmp/mbr bs=512 count=1


软链接和硬链接区别：
查看系统的状态  cpu 内存 io利用率  网络状态
CPU：top、mpstat、vmstat
内存：free -h、top
磁盘 IO：iostat、iotop
网络：ifconfig、netstat、ss、sar


# 一次kill 一个程序的多个进程
ps ax |grep containerd-shi[m]|cut -c1-6|xargs kill
#或者用kiallall
killall tail  # killall 进程名


```



## raid 磁盘阵列
特点: 更高的容量

	          更高的冗余

	          更高的性能



raid5  最少3块盘  最多损坏一块  损失一块盘的容量  写入性能速度ok  对于速度安全要求不高 ; 普遍数据库、存储

RAID5+Spare（热备盘）

| | raid级别 | 至少需要几块硬盘 | 容量 | 性能 | 安全冗余   | 使用场景 | 举例 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 条带 | raid 0   | 1块   | 所有容量和 | 读写最快 | 0 | 不要求安全<br/>只要求速度 | 存储从库<br/>数据从库 |
| 镜像 | raid 1  | 2块 | 所有硬盘容量一半 | 写入速度慢<br/>读取ok | 坏一块 | 要求安全<br/>对于速度没 | 系统盘<br/>监控服务器 |
| 带奇偶校验的条带化 | raid 5 | 3 | 两块盘的容量和 | 写入速度慢<br/>读取ok | 坏一块 | 对于速度要求不高 | 普遍数据库,存储 |
| 1+0，镜像加条带化 | RAID 10 | 4 | 总容量的一半 | 读写都ok | 坏一半 | 对于安全性能都要 | 高并发或高访问量的主库 存储 |
| 5+0 带奇偶校验的条带化 | RAID 50 | 6块 | 4块硬盘的容量总和 | 读写都ok |  坏2块 | 对于安全性能都要 | 高并发或高访问量的主库 存储 |






# 查看内存使用情况
```bash
# free -h
            total       used       free     shared    buffers     cached
Mem:          474M       389M        84M       232K        15M       286M
-/+ buffers/cache:        87M       387M
Swap:         767M       920K       767M

剩余内存 387M = free 84M + 15M buffers +286M cached

linux把你使用过的命令或文件 替你缓存（buffer cache）起来，提高下次使用速度
写buffer
读cache
```





# 磁盘分区fdisk
```bash
linux启动流程： centos6
      1. 开机自检BIOS
      2. MBR引导
      3. GRUB菜单
      4. Kernel加载内核
      5. 运行init 进程    第一个进程
      6. /etc/inittab    读取运行级别
      7. /etc/rc.sysinit  系统初始化
      8. /etc/rc.d/rc3.d   根据运行级别 启动对应服务（开机自启动）
      9. mingetty 		登录界面

磁盘的引导扇区   0磁头 0磁道 1扇区
MBR引导        0头0道1扇区前446字节
MBR（Mster Boot Record）      主引导记录  引导系统启动
DPT（Disk Partition Table）   磁盘分区表 记录着磁盘分区从哪里开始到哪里结束

主分区(primary)    每个分区占用16个字节的分区表
扩展分区(extended) 无法直接使用。 再创建逻辑分区
逻辑分区(logical)   存放数据

磁盘分区的命名规则
第1块sas硬盘的第一个主分区    /dev/sda1
第2块sata硬盘的第2个主分区   /dev/sdb2
第3块sata硬盘的第1个逻辑分区 /dev/sdc3

------------------------------------------------
#虚拟机添加了两个硬盘
# fdisk -l|grep sd[a-c]
Disk /dev/sda: 21.5 GB, 21474836480 bytes
/dev/sda1   *           1          26      204800   83  Linux
/dev/sda2              26         124      786432   82  Linux swap / Solaris
/dev/sda3             124        2611    19979264   83  Linux
Disk /dev/sdb: 213 MB, 213909504 bytes
Disk /dev/sdc: 213 MB, 213909504 bytes

fdisk  -c -u
       -u     When listing partition tables, give sizes in sectors  instead  of
             cylinders.
      				磁盘分区的时候 以扇区为单位 默认是按照 柱面
       -c     Switch off DOS-compatible mode. (Recommended)
      				关闭dos兼容模式

# fdisk -cu /dev/sdb
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x914f7c27.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.
Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)
Command (m for help):
#fdisk 内部命令
m 显示帮助
n new 创建分区
p 显示所有分区信息
d 删除分区
w 保存并退出
q 不保存退出
Command (m for help): n      
Command action
  e   extended					# 扩展分区
  p   primary partition (1-4)  #主分区
Invalid partition number for type `l'    # 类型分区号无效
p
Partition number (1-4):   #分区号码
Partition number (1-4): 1
First sector (2048-417791, default 2048):  # 从哪里开始 （回车使用默认）
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-417791, default 417791): +10M   #结束位置
Command (m for help): p
Disk /dev/sdb: 213 MB, 213909504 bytes
64 heads, 32 sectors/track, 204 cylinders, total 417792 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x914f7c27
  Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048       22527       10240   83  Linux
。。。。。。。。
Command (m for help): p
Disk /dev/sdb: 213 MB, 213909504 bytes
64 heads, 32 sectors/track, 204 cylinders, total 417792 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x914f7c27
  Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048       22527       10240   83  Linux
/dev/sdb4           22528      417791      197632    5  Extended
/dev/sdb5           24576      126975       51200   83  Linux
/dev/sdb6          129024      231423       51200   83  Linux

对每个房间装修（磁盘分区）
# mkfs.ext4 /dev/sdb1
This filesystem will be automatically checked every 21 mounts or
这个磁盘分区会被自动检查   每挂载21次或180天 会进程一次磁盘检查
180 days, whichever comes first.  Use tune2fs -c or -i to override.
自己创建的磁盘分区关闭磁盘检查。
# tune2fs -c 0 -i 0 /dev/sdb1  # 关闭磁盘自动检查
-c 每挂载多少次 进行一次磁盘检查     0 是关闭
-i 每过多少天 进行一次磁盘检查       0 是关闭

# 挂载
# mount /dev/sdb1 /data1
# 检查
[root@oldboy01 data]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        19G  7.1G   11G  40% /
tmpfs           238M     0  238M   0% /dev/shm
/dev/sda1       190M   40M  141M  22% /boot
/dev/sdb1       194M  1.8M  182M   1% /data1

报错：
[root@oldboy01 data]# mount /dev/sdb1 /data1
mount: you must specify the filesystem type #挂载必须指定文件系统类型


永久挂载
方法一 /etc/fstab   开机自动挂载
UUID=0c9291ad-1bc9-48a1-85b3-bce1314499ac  /           ext4          defaults        1           1
UUID=251cad76-385f-489d-b315-de8b588fdc57  /boot       ext4          defaults        1           2
UUID=c4bdfe6a-678b-4ea6-8bbc-53e7ae882417  swap        swap          defaults        0           0
tmpfs                                      /dev/shm    tmpfs         defaults        0           0
devpts                                     /dev/pts    devpts        gid=5,mode=620  0           0
sysfs                                      /sys        sysfs         defaults        0           0
proc                                       /proc       proc          defaults        0           0
设备名称（分区）			 挂载点(目录) 文件系统类型   挂载参数   是否进行备份 是否开机磁盘检查
/dev/cdrom
/dev/sdb1
dev/sdb1   			/data1		 ext4 		defaults		  0 	0

# 查看uuid 对应设备
[root@oldboy01 data]# blkid
/dev/sda3: UUID="0c9291ad-1bc9-48a1-85b3-bce1314499ac" TYPE="ext4"
/dev/sda1: UUID="251cad76-385f-489d-b315-de8b588fdc57" TYPE="ext4"
/dev/sda2: UUID="c4bdfe6a-678b-4ea6-8bbc-53e7ae882417" TYPE="swap"
/dev/sdb1: UUID="12d89b97-accd-459b-88fe-bed0a40d6a81" TYPE="ext4"


方法二 /etc/rc.local 增加  bin/mount /dev/sdb1 /data1


-----
增加硬盘200MB  硬盘创建一个分区挂载到/data 目录
1. 创建分区   （上面已经创建好）
2 通知系统sdb 磁盘分区表变化  partprobe /dev/sdb
3 创建文件系统 （格式化）    mkfs   #make filesystem
```

# parted 分区
```bash
fdisk  支持2TB以内的硬盘     只支持MBR磁盘分区表
parted 支持2TB以上的硬盘	MBR（主分区最多4个）,GPT（无限 接近100）


# parted /dev/sdc
print    显示分区信息
报错
(parted) p                                                                
Error: /dev/sdc: unrecognised disk label   没有分区表
mktable  mklabel创建磁盘分区表  gpt msdos（mbr）
mkpart   创建分区
rm   	 删除分区
q  		 退出不保存

(parted) mktable gpt   # 创建gpt分区表
# 提示已经存在  磁盘分区表  在/dev/sdc  是不是继续                                                
Warning: The existing disk label on /dev/sdc will be destroyed and all data on this disk
will be lost. Do you want to continue?
Yes/No? y  
(parted) mkpart primary 0 10     #创建分区 默认是M 为单位                                        
Warning: The resulting partition is not properly aligned for best performance.
Ignore/Cancel? i    
(parted) p    #查看                                                     
Model: VMware, VMware Virtual S (scsi)
Disk /dev/sdc: 214MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
1      17.4kB  10.0MB  9983kB               primary
(parted) q   #退出      
# 格式化已经分好的区  mkfs.ext4 /dev/sdc1
# 挂载 mount /dev/sdc1 /sdc1
# 开机自动挂载 echo ‘/dev/sdc1 /sdc1 ext4 defaults 0 0’ >> /etc/fstab
                                                    
非交互式创建分区
# parted /dev/sdc  mkpart primary 0 10 ignore
       
# parted /dev/sdc mkpart primary 10 20 ignore
Warning: You requested a partition from 10000kB to 20.0MB.                
The closest location we can manage is 10.0MB to 10.5MB.
Is this still acceptable to you?
parted: invalid token: ignore
Yes/No? y                                                                 
Warning: The resulting partition is not properly aligned for best performance.
Ignore/Cancel? i                                                         
Information: You may need to update /etc/fstab.                          
# parted /dev/sdc p   # 显示分区信息
Model: VMware, VMware Virtual S (scsi)
Disk /dev/sdc: 214MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Number  Start   End     Size    File system  Name     Flags
1      17.4kB  10.0MB  9983kB               primary
3      10.0MB  10.5MB  485kB                primary
2      10.5MB  19.9MB  9437kB               primary


```



# 命令小结
```bash
fdisk 磁盘分区
			-l 显示磁盘分区信息
parted 磁盘分区命令

partprobe  通知系统硬盘的分区表变化
		partprobe /dev/sdb
mkfs  # make filesystem  创建文件系统（格式化）
			-t 指定系统类型
		  mkfs.ext4 === mkfs –t ext4
tune2fs 修改分区信息

dd  创建指定大小文件（复制）
		if =/dev/zero of=/tmp/1g bs=1M count=1000
	
mkswap  创建swap（让xxx成为swap）
	swapon -s  #（激活swap）
	swapoff	   #（关闭swap）

# 把磁盘的mbr复制出来  0磁头0磁道1扇区前446字节
# 复制前512字节
dd if=/dev/sda of=/tmp/mbr.bin bs=512 count=1
# boot sector 启动扇区
file /tmp/mbr.bin  
# 二进制方式查看文件
od /tmp/mbr.bin   
#查看二进制文件的内容
od -xa /tmp/mbr.bin  

```

# 文件系统:
```bash
组织管理文件的方法
		装修风格===== 屋子如何住人
		文件系统===== 文件在磁盘上面如何存放

不同的系统会有不同的文件系统

inode   block？
inode   文件属性
block   文件内容/ 目录内的文件名

定时任务没有定向到空或追加到文件

inode信息    block存放位置   superblock的地方  超级块
dumpe2fs –h  只显示超级块

常见文件系统 及 应用场景
尽量使用系统默认的文件系统
suse  openSUSE linux的默认文件系统    reiserfs文件系统
ibm 的 AIX（unix） 使用的jfs 日志文件系统
centos7  XFS文件系统
centos6  ext4文件系统
centos5  ext3文件系统

reiserfs大量小文件业务首选reiserfs（100K以内）, 单独安装。
xfs  有的门户的数据库MySQL业务会选择xfs。
ext4 视频下载，流媒体，数据库，小文件业务也OK，可以用默认的。
ext2 没有日志，蓝汛、网宿的cache业务，CDN网站加速服务的。  缓存
Ext4/Reiserfs可以作为SSD文件系统，但未对SSD做优化，不能充分发挥SSD性能，并影响SSD使用时间。
swap 交换分区


raid 文件系统    大话存储
浪潮之颠

```



友情链接

http://www.xuliangwei.com/

https://www.abcdocker.com/  [https://i4t.com/](https://i4t.com/)





# 故障案例： java 程序占用大量内存，开始使用swap， swap不足增加swap
```plain
#定时任务重启tomcat  发现重启失败 报错， 定时任务脚本中加入了环境变量
故障案例： java 程序占用大量内存，开始使用swap， swap不足
增加swap

创建一个文件成为swap
# free -h
            total       used       free     shared    buffers     cached
Mem:          474M       140M       334M       236K        23M        41M
-/+ buffers/cache:        74M       399M
Swap:         767M         0B       767M

1 创建一个100M 的文件
# dd if=/dev/zero of=/tmp/100m bs=1M count=100
if== input file 从哪里获取    of  output  file 输出到哪里  block size每次复制多少  count 复制多少次
/dev/zero  不断输出 零
/dev/null  黑洞
# file /tmp/100m  # data类型
/tmp/100m: data

2 创建swap 让这个文件成为swap（格式化）
# mkswap /tmp/100m  #创建swap类型
# file /tmp/100m  # 显示文件类型  是swap类型
/tmp/100m: Linux/i386 swap file (new style) 1 (4K pages) size 25599 pages

3 激活swap 分区
# swapon /tmp/100m
# free -h
            total       used       free     shared    buffers     cached
Mem:          474M       297M       177M       236K        24M       193M
-/+ buffers/cache:        79M       395M
Swap:         867M         0B       867M

# swapon –s    # 显示swap 组成情况（磁盘分区 和 文件）
Filename				Type		Size	Used	Priority
/dev/sda2                               partition	786428	0	-1
/tmp/100m                               file		102396	0	-2

4 永久增加
/etc/rc.local   增加 sbin/swapon /tmp/100m
/etc/fstab      类型和挂载点都是 swap



```



















![1546511416997-3367586d-e44d-4ca2-b0f3-798bb76e4844.png](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-04.png)



![1570862458782-cc42e53f-f029-4fd6-910c-e45ff5b7712a.png](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-05.png)



------------------------------------------------------------------------

![1546511305855-f9d60131-92ef-43b0-be12-16351bc7ad1a-image3.png](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-06.png)





![1546511381502-993acde4-0f49-403d-a183-963825bd4c20.png](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-07.png)







  




---------------------------------





> 更新: 2026-04-24 12:35:02  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/nzorh0>