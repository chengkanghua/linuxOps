# 第五章·Linux文件管理-文件软硬链接

## 系统链接文件

文件有文件名和数据，在Linux上被分成两个部分：用户数据(user data)与元数据(metadata)

用户数据：文件数据块（data block），数据块是记录文件真实内容的地方，我们将其称为`Block`

元数据：文件的附加属性，例如：文件大小，创建时间，属组，属主...等，我们称其为`Inode`

在Linux中，`inode`是文件元数据的一部分，但其并不包含文件名，`inode`号即索引节点号

文件名仅是为了方便人们的记忆和使用，系统或者程序通过`inode`号寻找正确的文件数据块。

下图为文件读取的流程：

<!-- OCR_START -->
- filename
- inode
- data blocks
- metadata
- user data
<!-- OCR_END -->

￼

Linux系统引入了两种链接：

1.硬链接（hard link）

2.软链接（又叫：符号链接即`soft link`或`symbolic link`）

***

| 软链接 |
| :--- |

1.什么是软链接？

软链接相当于windows的快捷方式，软链接文件会将`inode`指向源文件的`block`

> 当我们访问这个软链接文件时，其实就是在访问源文件的本身。
>
> 1.那么当我们对一个文件创建多个软链接时，其实就是多个`inode`指向同一个`block`。
>
> 2.那么当我们删除软链接文件时，其实只是删除了一个`inode`的指向，并不会对源文件造成影响。
>
> 3.如果我们删除的是源文件，那么该文件的所有软链接文件都会失效。

```bash
[root@db04 ~]# touch soft_link
[root@db04 ~]# ln -s soft_link /tmp/soft_link
[root@db04 ~]# ls -li soft_link /tmp/soft_link
662184 -rw-r--r-- 1 root root 0 6月   1 10:42 soft_link
915769 lrwxrwxrwx 1 root root 9 6月   1 10:42 /tmp/soft_link -> soft_link
```

<!-- OCR_START -->
- 软链接inode
- 915769
- /tmp/soft_link
- 元数据inode
- 磁盘
- 662184
- 元数据block
- /root/soft_link
<!-- OCR_END -->

￼

2.软链接的应用场景

1）软件升级

2）代码发布

3）不方便移动的目录

4）数据回滚

5）程序读取

***

| 硬链接 |
| :--- |

1.什么是硬链接

若一个`inode`号对应多个文件名，则称这些文件为硬链接。换句话说，硬链接就是同一个文件使用了多个别名，如下图所示`hard link`就是file的一个别名，他们有共同的`inode`

```bash
[root@db04 ~]# ls -li /tmp/hard_link
662189 -rw-r--r-- 2 root root 0 6月   1 12:21 /tmp/hard_link
[root@db04 ~]# ls -li hard_link
662189 -rw-r--r-- 2 root root 0 6月   1 12:21 hard_link
```

<!-- OCR_START -->
- 硬链接文件
- /tmp/hard_link
- inode
- 662189
- datablock
- 元数据文件
- /root/hard_link
- 磁盘
<!-- OCR_END -->

￼

总结：硬链接与软链接的区别

```bash
1）创建命令不同
    软链接：ln -s
    硬链接：ln
2）目录不能创建硬链接，并且硬链接不可以跨越系统的分区，软链接可以
3）硬链接文件与源文件inode相同，软链接文件与源文件inode不同
4）删除软链接文件，对源文件无影响，但是删除软链接源文件对软链接文件有影响
5）删除硬链接文件，对源文件也无影响，并且删除源文件，对硬链接文件也无影响
```

面试题：当前磁盘空间还剩余500G，但是就无法往里面写入数据，报错，磁盘空间满了。

1T磁盘，用户数据把inode沾满了

```bash
[root@db04 ~]# df -i
Filesystem                   Inodes IUsed   IFree IUse% Mounted on
/dev/mapper/vg_db01-lv_root 1152816 76391 1076425    7% /
tmpfs                        238319     1  238318    1% /dev/shm
/dev/sda1                    128016    39  127977    1% /boot
#模拟
[root@db04 ~]# dd if=/dev/zero of=/opt/disk bs=1K count=1024
[root@db04 ~]# mkfs.ext4 -i 1024 /opt/disk
[root@db04 ~]# mkdir /data1
[root@db04 ~]# mount -t ext4 -o loop /opt/disk /data1
[root@db04 data1]# touch file{1..2000}
touch: 无法创建"file1014": 设备上没有空间
touch: 无法创建"file1015": 设备上没有空间
touch: 无法创建"file1016": 设备上没有空间
touch: 无法创建"file1017": 设备上没有空间
touch: 无法创建"file1018": 设备上没有空间
[root@db04 data1]# df -h
Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/vg_db01-lv_root   18G  2.0G   15G  12% /
tmpfs                        931M     0  931M   0% /dev/shm
/dev/sda1                    485M   39M  421M   9% /boot
/opt/disk                    891K   39K  801K   5% /data1
[root@db04 data1]# df -i
Filesystem                   Inodes IUsed   IFree IUse% Mounted on
/dev/mapper/vg_db01-lv_root 1152816 76393 1076423    7% /
tmpfs                        238319     1  238318    1% /dev/shm
/dev/sda1                    128016    39  127977    1% /boot
/opt/disk                      1024  1024       0  100% /data1
```

硬连接数计算

```bash
[root@db04 ~]# mkdir hard
[root@db04 ~]# ll hard -d
drwxr-xr-x 2 root root 4096 6月   1 12:50 hard
[root@db04 ~]# cd hard
[root@db04 hard]# mkdir test1
[root@db04 ~]# ll -d hard
drwxr-xr-x 3 root root 4096 6月   1 12:50 hard
[root@db04 ~]# cd hard
[root@db04 hard]# touch test
[root@db04 ~]# ll -d hard
drwxr-xr-x 3 root root 4096 6月   1 12:50 hard
```

> 更新: 2024-09-20 22:03:15  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ox61ca>