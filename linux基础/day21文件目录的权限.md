# day21 文件与目录的权限

![权限示意图](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-01.png)

## 一、文件与目录 rwx 的含义

### 实验准备
```bash
useradd -m -s /bin/bash oldboy

# root 下只给 oldboy 对 test.sh 的 r 权限
echo "hostname" > /tmp/test.sh
chown oldboy:oldboy test.sh
chmod u=r test.sh
# ll /tmp/test.sh
-r--r--r-- 1 oldboy oldboy 0 Aug 18 08:52 /tmp/test.sh

# oldboy 用户测试
su - oldboy
cd /tmp/
$ cat /tmp/test.sh        # 可读
hostname
$ echo 'pwd' >> test.sh   # 不可写
-bash: test.sh: Permission denied
$ /tmp/test.sh            # 不可执行
-bash: /tmp/test.sh: Permission denied

# root 下只给 oldboy 对 test.sh 的 w 权限
chmod u=w test.sh
# --w-r--r--. 1 oldboy oldboy 9 Aug  6 12:32 test.sh
# oldboy 测试
$ cat test.sh             # 不可读
cat: test.sh: Permission denied
$ echo 'pwd' >> test.sh   # 可追加
$ /tmp/test.sh            # 不可执行
-bash: /tmp/test.sh: Permission denied
```

### 目录 rwx 实验
```bash
# 创建环境
mkdir -p /oldboy/test
touch /oldboy/test/oldboy{01..5}.txt
chown oldboy.oldboy /oldboy/test/

# 只给目录 r 权限
chmod u=r /oldboy/test/
# oldboy 测试：能看到文件名，但查看属性报错
$ ls test
ls: cannot access test/oldboy01.txt: Permission denied
...
oldboy01.txt  oldboy02.txt  oldboy03.txt  oldboy04.txt  oldboy05.txt
$ ls -l test
total 0
-????????? ? ? ? ?            ? oldboy01.txt   # 属性不可见

# 只给目录 w 权限
chmod u=w /oldboy/test
$ cd /oldboy/ && ll test
ls: cannot open directory test: Permission denied
$ touch test/aa.sh
touch: cannot touch 'test/aa.sh': Permission denied
```

### rwx 总结
**对文件**
- `r` 读取文件内容（如 `cat`）
- `w` 修改文件内容（需 `r` 配合）；**只有 w 时强制保存会清空源文件**
- `x` 执行脚本（需 `r` 配合）

**对目录**
- `r` 查看目录内容（`ls`），需 `x` 配合
- `w` 在目录下创建/删除/改名文件（需 `x` 配合）
- `x` 进入目录（`cd`），查看文件属性也需 `x` 配合
- **删除一个文件，看的是该文件所在目录是否有 `wx` 权限**

## 二、错误报错原因辨析
```bash
1. $ ls /root/
ls: cannot open directory /root/: Permission denied
→ 目录没有 rx 权限

2. $ touch /etc/passwd.txt
touch: cannot touch `/etc/passwd.txt': Permission denied
→ 目录没有 wx 权限

3. $ rm -f /etc/sysconfig/network
rm: cannot remove `/etc/sysconfig/network': Permission denied
→ 目录没有 wx 权限

4. $ echo '#oldboy' >> /etc/hosts
-bash: /etc/hosts: Permission denied
→ 文件没有 w 权限

5. $ cat /etc/shadow
cat: /etc/shadow: Permission denied
→ 文件没有 r 权限
```

## 三、文件访问过程与权限
```bash
cat oldboy.txt
        inode          block
文件    文件属性        数据（文件内容）
目录    目录属性        文件名

cat /oldboy/test.sh
权限可能与文件所在目录及上级目录有关

文件访问过程：
  1. 用户发起访问请求（vim/cat 打开文件）
  2. 操作系统内核介入（定位文件）
  3. 文件权限检查（文件权限位）
  4. 实际文件访问（读：从存储读入内存；写：从内存写入存储）

文件权限：读（r）、写（w）、执行（x），对应数字 4、2、1。
```

## 四、控制默认权限 umask
```bash
umask
022      # 777-022

# 目录一般最大权限 777，文件一般最大权限 666
目录默认权限 = 777 - 022 = 755
文件默认权限 = 666 - 022 = 644

umask 032
文件 = 666 - 032 = 634 + 010（奇数位加 1）= 644

umask 是 035，系统文件/目录默认权限？
文件 = 666 - 035 = 631 + 011（奇数加 1）= 642
目录 = 777 - 035 = 742

# 要求创建的文件默认权限 000、目录 111，umask 应为？
666    # 777-666=111(目录)  666-666=000(文件)
```

## 五、通过权限保护网站安全
```bash
# 网站 blog.oldboyedu.com 根目录 /app/blog
# 1. 网站以虚拟用户 www 运行
#    file 644   dir 755

# 模拟
mkdir -p /app/blog /app/blog/upload
touch /app/blog/tao.avi /app/blog/dao.mp4 /app/blog/ndd.torrent

useradd www
su - www
$ touch upload/499G.torrent
touch: cannot touch `upload/499G.torrent': Permission denied

# 原因及解决：上传目录需给 www 写+执行权限
chown www.www /app/blog/upload/
chmod u+w /app/blog/upload
chmod u+x /app/blog/upload
# ll -d /app/blog/upload
drwxr-xr-x 2 www www 26 Aug 18 10:16 /app/blog/upload
```

## 六、Linux 特殊权限（了解）：SUID / SGID / Sticky

> 注：粘滞位（sticky）与 SGID 容易混淆，下面分别说明。

### 1. SUID（4，u+s / 4755）
运行命令时**临时拥有该命令所有者的权限**（如 root）。
```bash
chmod u+s /bin/rm      # 或 chmod 4755 /bin/rm
chmod u+s /bin/ls
# ll /bin/ls
-rwsr-xr-x. 1 root root 117048 Mar 23 2017 /bin/ls
# stat /bin/ls
Access: (4755/-rwsr-xr-x)  Uid: ( 0/ root)
```

### 2. SGID（2，g+s / 2755）
运行命令时**临时加入该命令所属用户组的权限**。

### 3. Sticky 粘滞位（1，o+t / 1777）
目录下任何人都能创建文件，但**只能管理自己的文件**，无法删除/修改别人的。
```bash
chmod 1777 /tmp
# stat /tmp
Access: (1777/drwxrwxrwt)  Uid: ( 0/ root)
```

## 七、隐藏属性（文件系统权限 chattr / lsattr）
```bash
chattr  改变文件或目录的扩展属性：chattr [选项] [模式] 文件
常用选项：-R 递归；-V 详细输出
属性模式：+ 添加  - 移除  = 设置
常用属性：
  a  仅追加：只能追加内容，不能删除或重命名
  i  不可变：不能删除、重命名、写入或追加
  d  不可压缩（dump 备份时忽略）
  s  安全删除（删除时清空内容）
  u  不可删除（删除后内容可恢复）

sudo chattr +i /etc/passwd      # 设置不可变
sudo chattr -i /etc/passwd      # 移除不可变
lsattr /etc/passwd              # 查看属性
lsattr -R /etc                 # 递归查看目录
lsattr -a /home                # 显示所有文件/目录

# a：只能追加，不能删除/修改
# chattr +a test.sh
# lsattr test.sh
-----a-------e- test.sh
# rm -f test.sh
rm: cannot remove `test.sh': Operation not permitted

# i：不可修改、不可删除
# which chattr lsattr
/usr/bin/chattr
/usr/bin/lsattr
```

![特殊权限](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-02.png)
![隐藏属性](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-03.png)
![权限练习](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-04.png)
![umask](img/day21%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%9A%84%E6%9D%83%E9%99%90-05.png)

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/qbcduc>
