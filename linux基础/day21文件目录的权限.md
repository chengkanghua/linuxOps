# day21文件目录的权限

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- day21文件目录的权限
- 文件和目录 的rwx 的含义
- 说错下面错误的报错原因:
- 文件访问过程与权限
- 控制系统默认权限 umask
- 如何通过控制权限，来保护网站的安全？
- linux 特殊权限 （了解） suid setuid  sticky粘zhān滞位
- 隐藏属性（文件系统权限）

# day21文件目录的权限





![1546509565405-25606c6f-8b15-4ae1-a5f8-3857d5fd6125.png](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-01.png)





# 文件和目录 的rwx 的含义
```bash
对于文件rwx含义

useradd -m -s /bin/bash oldboy

# root用户下面修改权限   测试r权限  
# oldboy用户只有r权限

echo "hostname" > /tmp/test.sh
chown oldboy:oldboy test.sh
chmod u=r test.sh
# ll /tmp/test.sh
-r--r--r-- 1 oldboy oldboy 0 Aug 18 08:52 /tmp/test.sh


#oldboy用户下面测试
su - oldboy
cd /tmp/
$ ll test.sh
-r--r--r--. 1 oldboy oldboy 9 Aug  6 12:32 test.sh
$ cat /tmp/test.sh
hostname
$ echo 'pwd'>>test.sh
-bash: test.sh: Permission denied
$ /oldboy/test.sh
-bash: /oldboy/test.sh: Permission denied

#root用户下面修改权限   测试w权限  
#oldboy用户只有w 权限
# chmod u=w test.sh
# ll test.sh
--w-r--r--. 1 oldboy oldboy 9 Aug  6 12:32 test.sh

#oldboy用户下面测试
su - oldboy
$ ll test.sh
--w-r--r--. 1 oldboy oldboy 9 Aug  6 12:32 test.sh
$ cat test.sh
cat: test.sh: Permission denied
$ echo 'pwd' >>test.sh  #追加成功
$ echo 'pwd' >>test.sh
$ echo 'pwd' >>test.sh
$ echo 'pwd' >>test.sh
$ cat test.sh
cat: test.sh: Permission denied
$ /oldboy/test.sh
-bash: /oldboy/test.sh: Permission denied


# 对于目录rwx含义
创建环境
mkdir -p /oldboy/test
touch /oldboy/test/oldboy{01..5}.txt
chown oldboy.oldboy  /oldboy/test/
# 只给oldboy用户 目录r权限
chmod u=r /oldboy/test/

# ll -d /oldboy/test
drwxr-xr-x. 2 oldboy oldboy 4096 Aug  6 13:02 /oldboy/test


#oldboy用户下面测试
su - oldboy
$ cd /oldboy
$ ls test
ls: cannot access test/oldboy01.txt: Permission denied
ls: cannot access test/oldboy02.txt: Permission denied
ls: cannot access test/oldboy03.txt: Permission denied
ls: cannot access test/oldboy04.txt: Permission denied
ls: cannot access test/oldboy05.txt: Permission denied
oldboy01.txt  oldboy02.txt  oldboy03.txt  oldboy04.txt  oldboy05.txt
$ ls -l test
ls: cannot access test/oldboy05.txt: Permission denied
ls: cannot access test/oldboy04.txt: Permission denied
ls: cannot access test/oldboy01.txt: Permission denied
ls: cannot access test/del.sh: Permission denied
ls: cannot access test/oldboy02.txt: Permission denied
ls: cannot access test/oldboy03.txt: Permission denied
total 0
-????????? ? ? ? ?            ? oldboy01.txt
-????????? ? ? ? ?            ? oldboy02.txt
-????????? ? ? ? ?            ? oldboy03.txt
-????????? ? ? ? ?            ? oldboy04.txt
-????????? ? ? ? ?            ? oldboy05.txt


# 只给目录用户 w权限
# chmod u=w /oldboy/test
# ll /oldboy/test -d
d-w-r-xr-x 2 oldboy oldboy 106 Aug 18 09:03 /oldboy/test
#切换到oldboy用户
$ cd /oldboy/
$ ll test
ls: cannot open directory test: Permission denied
$ ls test
ls: cannot open directory test: Permission denied
$ touch test/aa.sh
touch: cannot touch ‘test/aa.sh’: Permission denied


对于文件rwx 含义
r-- = 读文件
-w- = 只可以追加内容, echo 'xx' >> file, 但是vim,cat等没有权限
rw- = 修改文件
r-x = 执行脚本

r 读取文件内容
w 修改文件内容， 需要r权限配合
只有w权限的时候 ，强制保存退出会导致源文件内容丢失
x 权限表示是否能执行脚本， 需要r权限配合


对于目录 rwx 含义
r-x =  查看目录内容和文件属性
-wx =  目录下可以创建修改删除文件

r 查看目录内容   ls   需要x权限配合（x是否能查看文件的属性）
w 在目录下创建 删除 修改文件名（w删除权限需要x 配合）
x  是否能进入到目录   cd  （你是否能查看目录中文件的属性 需要r配合）
删除一个文件  看文件所在目录的权限 是否有wx权限


```



 

# 说错下面错误的报错原因:
```bash
1. $ ls /root/ 
ls: cannot open directory /root/: Permission denied
目录没有rx权限 
2. $ touch /etc/passwd.txt 
touch: cannot touch `/etc/passwd.txt': Permission denied
目录没有wx权限 
3. $ \rm -f /etc/sysconfig/network
rm: cannot remove `/etc/sysconfig/network': Permission denied
目录没有 wx权限 
4. $ echo '#oldboy'  >>/etc/hosts  
-bash: /etc/hosts: Permission denied
文件没有w权限 
5. [oldboy@oldboyedu50-lnb /]$ cat /etc/shadow 
cat: /etc/shadow: Permission denied
文件没有r 权限



```



# 文件访问过程与权限
```bash
cat oldboy.txt
    		inode     block
文件    文件属性	  数据（文件内容）
目录    目录属性   文件名

cat /oldboy/test.sh
权限可能与文件所在目录及上级目录 及 目录有关


文件访问过程
  1用户发起访问请求  (应用程序 vim cat 打开文件)
  2操作系统内核介入  (定位文件)
  3文件权限检查    (文件权限位) 
  4实际文件访问    (读操作会从存储设备读取文件内容到内存，写操作会将内存中的数据写入存储设备等)

文件权限 ：读（r）、写（w）、执行（x），分别对应数字 4、2、1。	

  
```



# 控制系统默认权限 umask
```bash
umask
022    777-022
文件一般可以给最大权限 666
目录一般可以给最大权限 777

目录默认权限 777-022 =755
文件默认权限 666-022 =644

umask 032
文件 666 -032 =634 + 010 =644

umask  是035 系统文件的默认权限是？ 目录权限是？
文件 666-035=631 + 011 =642   奇数加1
目录 777-035=742

要求创建的文件默认权限是000，目录的权限是111  umask？
666
```



# 如何通过控制权限，来保护网站的安全？
```bash
网站 blog.oldboyedu.com
/app/blog

1 网站通过 www用户运行（虚拟用户）
	file  644
	dir  755
  
模拟环境  
mkdir -p /app/blog  /app/blog/upload    
touch    /app/blog/tao.avi /app/blog/dao.mp4  /app/blog/ndd.torrent 

# 网站用户通过www用户运行
useradd  www
su - www
$ touch upload/499G.torrent
touch: cannot touch `upload/499G.torrent': Permission denied

#什么原因及怎么解决
# chown www.www /app/blog/upload/
# chmod u+w /app/blog/upload
# chmod u+x /app/blog/upload
# ll -d /app/blog/upload
drwxr-xr-x 2 www www 26 Aug 18 10:16 /app/blog/upload
```

# linux 特殊权限 （了解） suid setuid  sticky粘zhān滞位


```bash
zhān  [zhì]
粘      滞

1 suid 
运行某一个命令的时候相当于这个命令的所有者（root）
设置方法 
chmod u+s /bin/rm  # 或者chmod 4755 /bin/rm


2 sticky 粘滞位 
任何人都可以在这个目录创建文件，每个人只能管理自己的文件，其他人处理不了
作用： 运行某一个命令的时候相当于属于这个命令的所在家庭（用户组）（root）
设置方法 chmod 1777 /tmp


#chmod u+s /bin/ls /bin/touch
#ll /bin/ls /bin/touch
-rwsr-xr-x. 1 root root 117048 Mar 23  2017 /bin/ls
-rwsr-xr-x. 1 root root  52560 Mar 23  2017 /bin/touch
#chmod u+s /bin/ls
#stat /bin/ls
File: `/bin/ls'
Size: 117048    	Blocks: 232        IO Block: 4096   regular file
Device: 803h/2051d	Inode: 130878      Links: 1
Access: (4755/-rwsr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2018-08-07 22:21:49.855105248 +0800
Modify: 2017-03-23 02:52:45.000000000 +0800
Change: 2018-08-07 22:24:05.983104952 +0800

#stat /tmp
File: `/tmp'
Size: 4096      	Blocks: 8          IO Block: 4096   directory
Device: 803h/2051d	Inode: 261972      Links: 7
Access: (1777/drwxrwxrwt)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2018-08-07 21:40:11.343109682 +0800
Modify: 2018-08-07 21:39:54.827108611 +0800
Change: 2018-08-07 21:39:54.827108611 +0800



```





# 隐藏属性（文件系统权限）
```bash
chattr  改变文件或目录的扩展属性
chattr [options] [mode] files
常用选项
-R：递归地对目录及其内容应用更改。
-V：显示命令的详细输出。
属性模式
+：添加属性。
-：移除属性。
=：设置属性
常用属性
a：仅追加模式。文件只能被追加内容，不能被删除或重命名。
i：不可变模式。文件或目录不能被删除、重命名、链接、写入或追加内容。
d：不可压缩模式。在使用 dump 命令备份文件系统时，该文件或目录将被忽略。
s：安全删除模式。当文件被删除时，其内容将被完全清除。
u：不可删除模式。如果文件被删除，其内容将被保存，以便之后可以恢复。

sudo chattr +i /etc/passwd #设置不可变属性
sudo chattr -i /etc/passwd  #移除不可变属性
lsattr /etc/passwd   #查看文件属性
lsattr -R /etc      #递归显示目录属性
lsattr -a /home  #显示所有文件和目录的属性


a（append 只能追加） 如果设置了这个权限 只能追加  不能删除 不能修改
i  （immutable 无敌）无法修改 无法删除
# chattr +a test.sh
# lsattr  test.sh
-----a-------e- test.sh
# \rm -f test.sh
rm: cannot remove `test.sh': Operation not permitted

# 查看命令路径   网站安全以后可以改这两个文件名字
#which chattr lsattr
/usr/bin/chattr
/usr/bin/lsattr
```











![1546509639576-c2301272-af79-405f-a9c1-2d637a8bacf8.png](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-02.png)



![1546509651068-64b1afd8-e998-44c7-80e2-16887e5f3346.png](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-03.png)

![1546509668142-79425fa7-658d-4b28-9811-8c0be3addfeb.png](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-04.png)





![1546509690763-b91066f1-7860-48ff-98d2-e8e6dba8df58.png](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-05.png)







> 更新: 2026-04-23 21:46:35  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/qbcduc>