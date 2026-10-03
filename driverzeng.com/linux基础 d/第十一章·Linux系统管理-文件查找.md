# 第十一章·Linux系统管理-文件查找

## 文件查找概述

| 为什么要使用文件查找 |
| :--- |

有些时候，我们可能会忘了某个文件所在的位置，此时就需要通过find来查找。

还有些时候，我想要找到，某个目录下，所有小于1k的文件。

还还有些时候，我们想要找到，某个目录下，7天之前创建的文件。

还还还有些时候，我们想找到，某个目录下，所有以.sh结尾的脚本。

`Linux`系统中的`find`命令在查找文件时非常有用而且方便。

它可以根据不同的条件来进行查找文件:例如权限、拥有者、修改日期/时间、文件大小等等。 同时`find`命令是`Linux`下必须掌握的。

find 命令的基本语法如下

| 命令 | 路径 | 选项 | 表达式 | 动作 |
| :--- | :--- | :--- | :--- | :--- |
| find | \[path...] | \[options] | \[expression] | \[action] |
| 查找 | 地区 | 小姐姐 | 18 | 约... |
| 视频 | 路径 | 日韩 | 无码 | 看 |

## find查找示例

| 根据文件名称查找 |
| :--- |

```plain
//创建文件
touch /etc/sysconfig/network-scripts/{ifcfg-eth1,IFCFG-ETH1}
//查找/etc目录下包含ifcfg-eth0名称的文件
[root@zls ~]# find /etc -name "ifcfg-eth1"
//-i 忽略大小写
[root@zls ~]# find /etc -iname "ifcfg-eth1"
//查找/etc目录下包含ifcfg-eth名称所有文件
[root@zls ~]# find /etc/ -name "ifcfg-eth*"
[root@zls ~]# find /etc -iname "ifcfg-eth*"
```

***

| 根据文件大小查找 |
| :--- |

```plain
//查找大于5M
[root@zls ~]# find /etc -size +5M
//超找等于5M
[root@zls ~]# find /etc -size 5M
//查找小于5M
[root@zls ~]# find /etc -size -5M
需求：我想查找到这些文后，查看他们的大小zls
[root@db04 ~]# find /etc -size +5M -ls
```

***

| 根据文件类型查找 |
| :--- |

```plain
//f 文件
[root@zls ~]# find /dev -type f
//d 目录
[root@zls ~]# find /dev -type d
//l 链接
[root@zls ~]# find /dev -type l
//b 块设备
[root@zls ~]# find /dev -type b
//c 字符设备
[root@zls ~]# find /dev -type c
//s 套接字
[root@zls ~]# find /dev -type s
//p 管道文件
[root@zls ~]# find /dev -type p
```

| 根据文时间查找 |
| :--- |

```plain
//创建测试文件
[root@zls ~]# for i in `seq -w 30`;do date -s  201802$i && touch file-$i;done
//查找7天以前的文件(不会打印当天的文件)
[root@zls ~]# find ./ -iname "file-*" -mtime +7
//查找最近7天的文件，不建议使用(会打印当天的文件)
[root@zls ~]# find ./ -iname "file-*" -mtime -7
//查找第7天文件(不会打印当天的文件)
[root@zls ~]# find ./ -iname "file-*" -mtime 7
//本地文件保留最近7天的备份文件, 备份服务器保留3个月的备份文件
find /backup/ -iname "*.bak" -mtime +7 -delete
find /backup/ -iname "*.bak" -mtime +90 -delete
```

| 根据文件用户查找 |
| :--- |

```plain
//查找属主是zls
[root@zls ~]# find /home -user zls
//查找属组是admin
[root@zls ~]# find /home -group admin
//查找属主是zls, 属组是admin
[root@zls ~]# find /home -user zls -group admin
//查找属主是zls, 并且属组是admin
[root@zls ~]# find /home -user zls -a -group admin
//查找属主是zls, 或者属组是admin
[root@zls ~]# find /home -user zls -o -group admin
//查找没有属主
[root@zls ~]# find /home -nouser
//查找没有属组
[root@zls ~]# find /home -nogroup
//查找没有属主或属组
[root@zls ~]# find /home -nouser -o -nogroup
//打印目录的时候，只打印1级目录（按深度查找）
[root@db04 ~]# find /home/ -maxdepth 1 -type d  -user zls
```

| 根据文件权限查找 |
| :--- |

```plain
//精切匹配644权限
[root@zls ~]# find . -perm 644 -ls
//拥有者至少有011(-wx),组010(-w-),其他人100(r--)
[root@zls ~]# find /home -perm -324 
//查找全局可写(没位权限必须高于2 -w-)
[root@zls ~]# find . -perm -222 -ls
//拥有者至少有r权限, 或者拥有组至少有r权限, 或者匿名至少有w权限
[root@zls ~]# find /home -perm /442 
//包含set uid
[root@zls ~]# find  /usr/sbin -perm -4000 -ls
//包含set gid
[root@zls ~]# find  /usr/sbin -perm -2000 -ls
//包含sticky
[root@zls ~]# find  /usr/sbin -perm -1000 -ls
```

| find处理动作 |
| :--- |

当查找到一个文件后, 需要对文件进行如何处理, 默认动作 `-print`

| 动作 | 含义 |
| :--- | :--- |
| -print | 打印查找到的内容（默认） |
| -ls | 以长格式显示的方式打印查找到的内容 |
| -delete | 删除查找到的文件（仅能删除空目录） |
| -ok | 后面跟自定义shell命令（会提示是否操作） |
| -exec | 后面跟自定义shell命令（标准写法-exec ;） |

```plain
//打印查询到的文件
[root@zls ~]# find /etc -name "ifcfg*"
[root@zls ~]# find /etc -name "ifcfg*" -print
[root@zls ~]# find /etc -name "ifcfg*" -ls
//拷贝文件
[root@zls ~]# find /etc -name "ifcfg*" -exec cp -rvf {} /tmp \;
//-ok会不断提示
[root@zls ~]# find /etc -name "ifcfg*" -ok cp -rvf {} /tmp \;
//删除文件
[root@zls ~]# find /etc -name "ifcfg*" -exec rm -f {} \;
[root@zls ~]# find /etc -name "ifcfg*" -delete
```

***

| find结合xargs |
| :--- |

```plain
#xargs将查找到结果一个一个的处理
[root@zls ~]# touch file.txt
[root@zls ~]# find . -name "file.txt" |xargs rm -f
[root@zls ~]# find . -name "file.txt" |xargs -I {} cp -rvf {} /var/tmp
```

***

| find练习题 |
| :--- |

1.查找/tmp目录下，属主不是root，切文件名不是以f开头的文件

2.查找/var目录下属主为root，切属组为mail的所有文件

3.查找/var目录下不属于root、oldboy、zls组的所有文件

4.查找/var目录下最近一周内其内容修改过，同时属主不为root，也不是postfix的文件

5.查找/etc/下所有大于1M且类型为普通文件的所有文件

6.将/etc中的所有目录（仅目录）复制到/tmp下，目录结构不变

7.将/etc目录复制到 /var/tmp，/var/tmp/etc的所有目录权限为777，/var/tmp/etc/目录中所有文件权限为666

9.创建touch file{1..10}10个文件，保留file9，其他一次全部删除

10.解释如下每条命令的含义

mkdir /root/dir1

touch /root/dir1/file{1..10}

find /root/dir1 -type f -name 'file5'

find /root/dir1 ! -name 'file5'

find /root/dir1 -name 'file5' -o -name 'file9'

find /root/dir1 -name 'file5' -o -name 'file9' -ls

find /root/dir1 (-name 'file5' -o -name 'file9' ) -ls

find /root/dir1 (-name 'file5' -o -name 'file9' ) -exec rm -rvf {} ;

find /root/dir1 ! (-name 'file5' -o -name 'file9' ) -exec rm -vf {} ;

> 更新: 2024-09-20 22:14:06  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/cu8z09>