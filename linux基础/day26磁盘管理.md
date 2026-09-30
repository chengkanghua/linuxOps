# day26 磁盘管理

> 本文为 Linux 磁盘管理课程：磁盘组成与容量计算、RAID、内存查看、fdisk/parted 分区、文件系统，以及"Java 占用内存导致 swap 不足"的故障案例。

![磁盘管理](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-01.png)

## 一、磁盘知识的体系结构

![体系结构](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-02.png)
![体系结构](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-03.png)

### 1. 磁盘组成

```bash
# 磁盘（硬盘 disk / hard disk）主要指标
1 容量
2 转速 rpm（round per minute，每分钟多少转）：5400 / 7200 / 10000 转每分钟
   固态硬盘 SSD（Solid State Disk）：质保期五年 / 300 TBW（TB written）；数据要备份 3 份

# 3. 计算磁盘大小公式
磁盘大小 = 柱面的大小 × 柱面的数量
柱面的大小 = 磁道的大小 × 磁头数量
磁道的大小 = 每个磁道扇区数量 × 每个扇区大小
```

```bash
# 列出所有分区表
fdisk -l
Disk /dev/sda: 21.5 GB, 21474836480 bytes
255 heads, 63 sectors/track, 2610 cylinders
# heads 磁头=255   每个磁道扇区数量=63   柱面数量=2610
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes   # 每个扇区 512 字节

# 计算验证
echo 63*512 | bc                        # 磁道大小 = 扇区数 × 扇区大小
32256
echo 63*512*255 | bc                    # 柱面大小 = 磁道大小 × 磁头数
8225280
echo 63*512*255*2610 | bc               # 磁盘大小 = 柱面大小 × 柱面数
21467980800
echo 63*512*255*2610/1024^3 | bc        # 不计算小数
19
echo 63*512*255*2610/1024^3 | bc -l     # -l 计算小数
19.99361515045166015625
awk 'BEGIN{print 63*512*255*2610/1024^3}'   # awk 计算
19.9936
```

> **为什么 500G 硬盘实际到手不足 500G？**
> 厂家按 **1000** 为单位（1KB=1000 字节），计算机按 **1024** 为单位。
> Linux 下计算方法：`bc -l` 或 `awk BEGIN{}`。

```bash
# 什么是 MBR？位于哪里？占多少字节？如何复制出来？
# MBR 主引导记录：0 磁头 0 磁道 1 扇区 512 字节的前 446 字节
dd if=/dev/sdb of=/tmp/mbr bs=512 count=1

# 软链接和硬链接区别（见后续章节）

# 查看系统状态常用命令
CPU：top、mpstat、vmstat
内存：free -h、top
磁盘 IO：iostat、iotop
网络：ifconfig、netstat、ss、sar

# 一次 kill 一个程序的多个进程
ps ax | grep containerd-shi[m] | cut -c1-6 | xargs kill
# 或者用 killall
killall tail        # killall 进程名
```

### 2. RAID 磁盘阵列

**三大特点**：更高的容量、更高的冗余、更高的性能。

- **RAID 5**：最少 3 块盘，最多损坏一块，损失一块盘的容量，写入性能 OK；对速度安全要求不高，普遍用于数据库、存储。
- **RAID 5 + Spare（热备盘）**

| 类型 | RAID 级别 | 至少几块硬盘 | 容量 | 性能 | 安全冗余 | 使用场景 | 举例 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 条带 | RAID 0 | 1 块 | 所有容量和 | 读写最快 | 0 | 不要求安全，只要求速度 | 存储从库、数据从库 |
| 镜像 | RAID 1 | 2 块 | 所有硬盘容量一半 | 写入慢 / 读取 OK | 坏一块 | 要求安全，对速度没要求 | 系统盘、监控服务器 |
| 带奇偶校验的条带化 | RAID 5 | 3 块 | 两块盘的容量和 | 写入慢 / 读取 OK | 坏一块 | 对速度要求不高 | 普遍数据库、存储 |
| 镜像+条带化 | RAID 10 | 4 块 | 总容量的一半 | 读写都 OK | 坏一半 | 安全性能都要 | 高并发或高访问量主库、存储 |
| 带奇偶校验的条带化 | RAID 50 | 6 块 | 4 块硬盘容量总和 | 读写都 OK | 坏 2 块 | 安全性能都要 | 高并发或高访问量主库、存储 |

## 二、查看内存使用情况

```bash
# free -h
            total       used       free     shared    buffers     cached
Mem:          474M       389M        84M       232K        15M       286M
-/+ buffers/cache:        87M       387M
Swap:         767M       920K       767M

# 剩余内存 387M = free 84M + buffers 15M + cached 286M
```

> Linux 会把你使用过的命令或文件**缓存（buffer/cache）**起来，提高下次使用速度。
> **写 buffer，读 cache**。

## 三、磁盘分区 fdisk

### Linux 启动流程回顾（CentOS 6）
```bash
1. 开机自检 BIOS
2. MBR 引导
3. GRUB 菜单
4. Kernel 加载内核
5. 运行 init 进程（第一个进程）
6. /etc/inittab 读取运行级别
7. /etc/rc.sysinit 系统初始化
8. /etc/rc.d/rc3.d 根据运行级别启动对应服务（开机自启动）
9. mingetty 登录界面
```

### 引导扇区与分区表
```bash
磁盘的引导扇区   0磁头 0磁道 1扇区
MBR 引导        0头0道1扇区前446字节
MBR（Master Boot Record）    主引导记录  引导系统启动
DPT（Disk Partition Table）  磁盘分区表  记录磁盘分区从哪里开始到哪里结束

主分区(primary)     每个分区占用 16 个字节的分区表
扩展分区(extended)  无法直接使用，需再创建逻辑分区
逻辑分区(logical)   存放数据

# 磁盘分区命名规则
第1块 sas 硬盘的第一个主分区     /dev/sda1
第2块 sata 硬盘的第2个主分区     /dev/sdb2
第3块 sata 硬盘的第1个逻辑分区   /dev/sdc3
```

### fdisk 实操
```bash
# 虚拟机添加了两个硬盘
fdisk -l | grep sd[a-c]
Disk /dev/sda: 21.5 GB, 21474836480 bytes
Disk /dev/sdb: 213 MB, 213909504 bytes
Disk /dev/sdc: 213 MB, 213909504 bytes

# 常用选项
fdisk -c -u
  -u  列出分区表时以扇区为单位（默认按柱面）
  -c  关闭 DOS 兼容模式（推荐）

fdisk -cu /dev/sdb
```

**fdisk 内部命令**：
```bash
m  显示帮助
n  new 创建分区
p  显示所有分区信息
d  删除分区
w  保存并退出
q  不保存退出
```

```bash
Command (m for help): n
Command action
  e   extended               # 扩展分区
  p   primary partition (1-4) # 主分区
p
Partition number (1-4): 1
First sector (2048-417791, default 2048):     # 回车用默认
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-417791, default 417791): +10M

Command (m for help): p
  Device Boot  Start    End    Blocks   Id  System
/dev/sdb1       2048   22527    10240   83  Linux
/dev/sdb4      22528  417791   197632    5  Extended
/dev/sdb5      24576  126975    51200   83  Linux
/dev/sdb6     129024  231423    51200   83  Linux
```

### 格式化（装修）、关闭磁盘检查、挂载
```bash
# 对每个"房间"装修 = 创建文件系统
mkfs.ext4 /dev/sdb1
# This filesystem will be automatically checked every 21 mounts or 180 days...

# 关闭磁盘自动检查（自己创建的分区建议关闭）
tune2fs -c 0 -i 0 /dev/sdb1
# -c 每挂载多少次检查一次（0=关闭）   -i 每过多少天检查一次（0=关闭）

# 挂载
mount /dev/sdb1 /data1
# 报错：mount: you must specify the filesystem type
#       → 挂载必须指定文件系统类型（先 mkfs 格式化）

# 检查
df -h
# /dev/sdb1  194M  1.8M  182M  1% /data1
```

### 永久挂载
```bash
# 方法一：/etc/fstab（开机自动挂载）
# 设备名称(分区)   挂载点(目录)  文件系统类型  挂载参数  是否备份  是否开机磁盘检查
/dev/sdb1         /data1       ext4         defaults    0        0

# /etc/fstab 示例（含 UUID 写法）
UUID=0c9291ad-1bc9-48a1-85b3-bce1314499ac  /      ext4   defaults  1  1
UUID=251cad76-385f-489d-b315-de8b588fdc57  /boot  ext4   defaults  1  2
UUID=c4bdfe6a-678b-4ea6-8bbc-53e7ae882417  swap   swap   defaults  0  0

# 查看 uuid 对应设备
blkid
# /dev/sdb1: UUID="12d89b97-accd-459b-88fe-bed0a40d6a81" TYPE="ext4"

# 方法二：/etc/rc.local 增加
/bin/mount /dev/sdb1 /data1
```

### 新增硬盘的完整步骤
```bash
# 增加 200MB 硬盘，创建一个分区挂载到 /data
1. 创建分区（fdisk /dev/sdb）
2. 通知系统磁盘分区表变化： partprobe /dev/sdb
3. 创建文件系统（格式化）： mkfs    # make filesystem
```

## 四、parted 分区（>2TB 硬盘）

```bash
fdisk   支持 2TB 以内硬盘，只支持 MBR 磁盘分区表
parted  支持 2TB 以上硬盘；MBR（主分区最多 4 个）或 GPT（接近 100 个）
```

```bash
parted /dev/sdc
  print    显示分区信息
  mktable(mklabel)  创建磁盘分区表：gpt 或 msdos(mbr)
  mkpart   创建分区
  rm       删除分区
  q        退出不保存

(parted) mktable gpt          # 创建 gpt 分区表
Warning: The existing disk label on /dev/sdc will be destroyed... Do you want to continue?
Yes/No? y
(parted) mkpart primary 0 10  # 创建分区，默认 M 为单位
Warning: The resulting partition is not properly aligned for best performance.
Ignore/Cancel? i
(parted) p
Model: VMware, VMware Virtual S (scsi)
Disk /dev/sdc: 214MB
Partition Table: gpt
Number  Start   End     Size    File system  Name     Flags
1       17.4kB  10.0MB  9983kB               primary
(parted) q

# 格式化并挂载
mkfs.ext4 /dev/sdc1
mount /dev/sdc1 /sdc1
echo '/dev/sdc1 /sdc1 ext4 defaults 0 0' >> /etc/fstab
```

**非交互式创建分区**：
```bash
parted /dev/sdc mkpart primary 0 10 ignore
parted /dev/sdc mkpart primary 10 20 ignore
parted /dev/sdc p
# 1  17.4kB  10.0MB  9983kB  primary
# 3  10.0MB  10.5MB   485kB  primary
# 2  10.5MB  19.9MB  9437kB  primary
```

## 五、命令小结

```bash
fdisk      磁盘分区；-l 显示磁盘分区信息
parted     磁盘分区命令（支持 >2TB / GPT）
partprobe  通知系统硬盘的分区表变化： partprobe /dev/sdb
mkfs       创建文件系统（格式化）： mkfs.ext4 === mkfs -t ext4
tune2fs    修改分区信息（如关闭磁盘检查）
dd         创建指定大小文件（复制）
           dd if=/dev/zero of=/tmp/1g bs=1M count=1000
mkswap     创建 swap（让 xxx 成为 swap）
swapon -s  激活 swap / 显示 swap 组成
swapoff    关闭 swap

# 把磁盘的 MBR 复制出来（0磁头0磁道1扇区，前 512 字节）
dd if=/dev/sda of=/tmp/mbr.bin bs=512 count=1
file /tmp/mbr.bin        # boot sector 启动扇区
od /tmp/mbr.bin          # 二进制方式查看
od -xa /tmp/mbr.bin      # 查看二进制文件内容
```

## 六、文件系统

```bash
# 文件系统 = 组织管理文件的方法
#   装修风格 ===== 屋子如何住人
#   文件系统 ===== 文件在磁盘上面如何存放

inode  文件属性
block  文件内容 / 目录内的文件名
superblock（超级块）  记录 inode 信息、block 存放位置等
dumpe2fs -h   只显示超级块

# 常见文件系统及应用场景（尽量使用系统默认的文件系统）
suse / openSUSE 默认：reiserfs
IBM AIX(unix)：jfs 日志文件系统
CentOS 7：XFS
CentOS 6：ext4
CentOS 5：ext3

reiserfs  大量小文件业务首选（100K 以内），需单独安装
xfs       有的门户数据库 MySQL 业务会选择 xfs
ext4      视频下载、流媒体、数据库、小文件业务都 OK，可用默认
ext2      没有日志，用于蓝汛/网宿的 cache 业务、CDN 网站加速（缓存）
swap      交换分区
```

> 注：Ext4/Reiserfs 可作为 SSD 文件系统，但未对 SSD 做优化，不能充分发挥 SSD 性能，并影响 SSD 使用时间。

## 七、故障案例：Java 占用大量内存导致 swap 不足，如何增加 swap

> 背景：定时任务重启 tomcat 失败（脚本中需加入环境变量）；Java 程序占用大量内存，开始使用 swap，swap 不足。

```bash
# 创建一个文件成为 swap
free -h
# Mem:   474M 140M 334M ...
# Swap:  767M   0B 767M

# 1. 创建一个 100M 的文件
dd if=/dev/zero of=/tmp/100m bs=1M count=100
# if = input file（从哪里获取）  of = output file（输出到哪里）
# bs = block size（每次复制多少）  count = 复制多少次
# /dev/zero 不断输出零；/dev/null 黑洞
file /tmp/100m
# /tmp/100m: data

# 2. 创建 swap（让这个文件成为 swap，相当于格式化）
mkswap /tmp/100m
file /tmp/100m
# /tmp/100m: Linux/i386 swap file (new style) 1 (4K pages) size 25599 pages

# 3. 激活 swap 分区
swapon /tmp/100m
free -h
# Swap:  867M   0B 867M
swapon -s        # 显示 swap 组成情况（磁盘分区和文件）
# Filename      Type      Size   Used  Priority
# /dev/sda2     partition 786428 0     -1
# /tmp/100m     file      102396 0     -2

# 4. 永久增加
# /etc/rc.local 增加： /sbin/swapon /tmp/100m
# /etc/fstab 中类型和挂载点都写 swap
```

![磁盘](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-04.png)
![磁盘](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-05.png)
![磁盘](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-06.png)
![磁盘](img/day26%E7%A3%81%E7%9B%98%E7%AE%A1%E7%90%86-07.png)

**友情链接**：
<http://www.xuliangwei.com/>
<https://www.abcdocker.com/>（<https://i4t.com/>）

> 更新: 2026-04-24 12:35:02
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/nzorh0>
