[老男孩教育-持续集成教程.pdf](https://www.yuque.com/attachments/yuque/0/2020/pdf/194754/1584114062769-7cf95762-e630-41e1-a408-55e8e2323abe.pdf)

[(方纪元)持续集成教程.pdf](https://www.yuque.com/attachments/yuque/0/2020/pdf/194754/1584114451602-e9ef0787-688f-4678-b91b-badfe5544380.pdf)

# 1devops介绍
## 1.Devops是什么


![1547368343210-bb6aa887-4f48-424b-b427-e16af7a5ce14-image1.jpeg](img/day74持续集成教程-01.jpeg)



<font style="color:#000000;">开发</font><font style="color:#C6244D;"> development</font>

运维 <font style="color:#C6244D;">operation</font>

## 2.Devops能干嘛
提高产品质量

1. 自动化测试
2. 持续集成
3. 代码质量管理工具
4. 程序员鼓励师



## 3.Devops如何实现


既然这么好？为什么有些公司没有

设计架构规划‐代码的存储‐构建‐测试、预生产、部署、监控



# 02 git 版本控制系统


## 1.版本控制系统简介
vcs	`version  control  system`

版本控制系统是一种记录一个或若干个文件内容变化，以便将来查阅特定版本内容情况的系统记录文件的所有历史变化

随时可恢复到任何一个历史状态多人协作开发



## 2.为什么需要版本控制系统


![1547368343288-d28a9750-eb40-4d7a-9049-ea713951d5b7-image2.jpeg](img/day74持续集成教程-02.jpeg)



![1547368343329-daae01c1-4e38-4ecc-8f50-c6986aa90ce7-image3.jpeg](img/day74持续集成教程-03.jpeg)



## 3.常见版本管理工具
SVN

集中式的版本控制系统，只有一个中央数据仓库，如果中央数据仓库挂了或者不可访问，所有的使用者无法使用SVN，无法进行提交或备份文件。

![1547368343359-12f1276e-0769-4373-97fb-5b3e5d26f058-image4.jpeg](img/day74持续集成教程-04.jpeg)

![1547368343382-7e67834d-c013-44fb-9b5d-22de88eb3aa5-image5.jpeg](img/day74持续集成教程-05.jpeg)![1547368343410-659bf444-1d9b-40b1-8dab-1b9b8f463c3e-image6.png](img/day74持续集成教程-06.png)





![1547368343429-fe9e424b-3bc3-455f-8413-8233d58961f1-image7.jpeg](img/day74持续集成教程-07.jpeg)



## 4.牛逼的人不需要解释这句话被LINUX展现的淋漓尽致
![1547368343458-2ac28b5e-f2a7-4a58-b5fd-7dc9a71417d6-image8.jpeg](img/day74持续集成教程-08.jpeg)



Gt的诞生

很多人都知道，Linus在1991年创建了开源的Linux，从此，Linux系统不断发展，已经成为最大的服务器系统软件了。

Linus虽然创建了Linux，但Linux的壮大是靠全世界热心的志愿者参与的，这么多人在世界各地为Linux编写代码，那Linux的代码是如何管理的呢？

事实是，在2002年以前，世界各地的志愿者把源代码文件通过diff的方式发给Linus，然后由Linus本人通过手工方式合并代码！

你也许会想，为什么Linus不把Linux代码放到版本控制系统里呢？不是有CVS、SVN这些免费的版本控制系统吗？因为Linus坚定地反对CVS和SVN，这些集中式的版本控制系统不但速度慢，而且必须联网才能使用。有一些商用的版本控制系统，虽然比CVS、SVN好用，但那是付费的，和Linux的开源精神不符。

不过，到了2002年，Linux系统已经发展了十年了，代码库之大让Linus很难继续通过手工方式管理了，社区的弟兄们也对这种方式表达了强烈不满，于是Linus选择了一个商业的版本控制系统BitKeeper，BitKeeper的东家BitMover公司出于人道主义精神，授权Linux社区免费使用这个版本控制系统。

安定团结的大好局面在2005年就被打破了，原因是Linux社区牛人聚集，不免沾染了一些梁山好汉的江湖习气。开发Samba的Andrew试图破解BitKeeper的协议（这么干的其实也不只他一个），被BitMover公司发现了（监控工作做得不错！），于是BitMover公司怒了，要收回Linux社区的免费使用权。

Linus可以向BitMover公司道个歉，保证以后严格管教弟兄们，嗯，这是不可能的。实际情况是这样的：

Linus花了两周时间自己用C写了一个分布式版本控制系统，这就是Git！一个月之内，Linux系统的源码已经由Git管理了！牛是怎么定义的呢？大家可以体会一下。

Git迅速成为最流行的分布式版本控制系统，尤其是2008年，GitHub网站上线了，它为开源项目免费提供Git存储，无数开源项目开始迁移至GitHub，包括jQuery，PHP，Ruby等等。

历史就是这么偶然，如果不是当年BitMover公司威胁Linux社区，可能现在我们就没有免费而超级好用的Git了。



# 03.Git安装
## 1系统环境准备
官方文档

[<font style="color:blue;">https://git-scm.com/book/zh/v2</font>](https://git-scm.com/book/zh/v2)

```bash
cat  /etc/redhat‐release  #查看系统版本 CentOS Linux release 7.1.1503 (Core)
uname  ‐r  	#查看内核版本 3.10.0‐229.el7.x86_64
getenforce  #确认Selinux关闭状态 Disabled
systemctl  stop  firewalld  #关闭防火墙
```

## 2.Git安装部署


```bash
yum  install  git  #  安装Git

[root@git  ~]#  git  config
‐‐global	使用全局配置文件
‐‐system	使用系统级配置文件
‐‐local	   使用版本库级配置文件

git  config  –‐global  user.name  "lizhenya"
# 配置git使用用户
git  config  –‐global  user.email  "lizhenya@mail.com"
# 配置git使用邮箱
git  config  –‐global  color.ui  true
# 语法高亮

#  git  config  –‐list
user.name=oldboy 
user.email=oldboy@mail.com
color.ui=true

#  cat  .gitconfig 
[user]
name = lizhenya
email  =  lizhenya@qq.com
 [color]
ui = true
```



## 3.git初始化


```bash
初始化工作目录、对已存在的目录或者对已存在的目录都可进行初始化
mkdir  git_data
cd git_data/
# 初始化
git init

# 查看工作区状态
# git status   //查看工作区状态
# On branch master    # on 在  branch 分支 master主节点
#
# Initial commit      #初始提交
#
nothing to commit (create/copy files and use "git add" to track)  #没有要提交的内容

隐藏文件介绍：
branches # 分支目录
config	# 定义项目特有的配置选项description	# 仅供git web程序使用HEAD # 指示当前的分支
hooks # 包含git钩子文件
info # 包含一个全局排除文件(exclude文件)
objects # 存放所有数据内容，有info和pack两个子文件夹
refs # 存放指向数据(分支)的提交对象的指针
index # 保存暂存区信息，在执行git init的时候，这个文件还没有

```



# 04.Git常规使用
## 1.创建数据-提交数据
![1547368343480-4d4236f2-e2d8-4dbd-b307-e919126fbdc9-image9.jpeg](img/day74持续集成教程-09.jpeg)

## 2.git四种状态


![1547368343505-d3c6aea1-db52-4a78-bff2-950d99c3a468-image10.jpeg](img/day74持续集成教程-10.jpeg)

> staged   分期的 分段的 成级
>
> modified   更改 修改
>
> unmodified  未更改的
>
> untracked   未跟踪的
>



## 3.git基础命令
```bash
[root@git  git_data]#  git  status
#  位于分支  master
# 初始提交
无文件要提交（创建/拷贝文件并使用 "git add" 建立跟踪）

[root@git  git_data]#  touch  a  b  c 
[root@git  git_data]#  git  status
#  位于分支  master #
# 初始提交
#
# 未跟踪的文件:
#	（使用 "git add <file>..." 以包含要提交的内容）
#
#	a
#	b
#	c
提交为空，但是存在尚未跟踪的文件（使用 "git add" 建立跟踪）
[root@git  git_data]#  git  add  a   #这一步是将a文件提交到暂存区
[root@git  git_data]#  git  status
#  位于分支  master #
# 初始提交
#
# 要提交的变更：
#	（使用  "git  rm  ‐‐cached  <file>..."  撤出暂存区）
#
#	新文件：	a #
# 未跟踪的文件:
#	（使用 "git add <file>..." 以包含要提交的内容）
#
#	b
#	c


# ll .git
total 12
drwxr-xr-x 2 root root   6 Sep  4 06:03 branches
-rw-r--r-- 1 root root  92 Sep  4 06:03 config
-rw-r--r-- 1 root root  73 Sep  4 06:03 description
-rw-r--r-- 1 root root  23 Sep  4 06:03 HEAD
drwxr-xr-x 2 root root 242 Sep  4 06:03 hooks
drwxr-xr-x 2 root root  21 Sep  4 06:03 info
drwxr-xr-x 4 root root  30 Sep  4 06:03 objects
drwxr-xr-x 4 root root  31 Sep  4 06:03 refs


[root@git  git_data]#  git  rm  ‐‐cached  c  #删除暂存区文件c 
[root@git  git_data]#  ll
总用量 0
‐rw‐r‐‐r‐‐  1  root  root  0  8月	23  07:05  a
‐rw‐r‐‐r‐‐  1  root  root  0  8月	23  07:05  b
‐rw‐r‐‐r‐‐  1  root  root  0  8月	23  07:05  c

[root@git  git_data]#  git  add  .	#  使用git  add  .  或者*  添加目录中所有改动过的文件
[root@git  git_data]#  git  status                                                                                           
#  位于分支  master
#
# 初始提交
#
# 要提交的变更：
#	（使用  "git  rm  ‐‐cached  <file>..."  撤出暂存区）
#
#	新文件：	a
#	新文件：	b
#	新文件：	c
[root@git  git_data]#  git  status
# On branch master  #  位于分支  master #
#
# Initial commit    # 初始提交
#
# Changes to be committed:  # 要提交的变更：
#   (use "git rm --cached <file>..." to unstage)   #	（使用  "git  rm  ‐‐cached  <file>..."  撤出暂存区）
#
#	new file:   a
#	new file:   b
#
# Untracked files:   # 未跟踪的文件:
#   (use "git add <file>..." to include in what will be committed) （使用 "git add <file>..." 以包含要提交的内容）
#
#	c
```



删除文件

```bash
1.先从暂存区撤回到工作区、然后直接删除文件
git  rm  ‐‐cached  c
rm  ‐f  c

2.直接从暂存区域同工作区域一同删除文件命令 
git  rm  ‐f  b
```



提交到本地仓库

```bash
[root@yht git_data]# git commit -m "commit a"   #  提交到本地仓库  -m 标记
[master (root-commit) 245986e] commit a   #主分支master  根提交
 2 files changed, 0 insertions(+), 0 deletions(-)  #2个文件
 create mode 100644 a
 create mode 100644 b

[root@git  git_data]#  git  status
#  位于分支  master
无文件要提交，干净的工作区
```





修改文件名称两种方法

```bash

[root@git  git_data]#  mv  a  a.txt
[root@git  git_data]#  git  status #  位于分支  master
# 尚未暂存以备提交的变更：
#	（使用  "git  add/rm  <file>..."  更新要提交的内容）
#	（使用 "git checkout ‐‐ <file>..." 丢弃工作区的改动）
#
#	删除：	a

#
# 未跟踪的文件:
#	（使用 "git add <file>..." 以包含要提交的内容）
#
#	a.txt

修改尚未加入提交（使用  "git  add"  和/或  "git  commit  ‐a"）
[root@git  git_data]#  git  rm  ‐‐cached  a	#  从暂存区删除a文件
rm  'a'
[root@git  git_data]#  git  status
#  位于分支  master
# 要提交的变更：
#	（使用 "git reset HEAD <file>..." 撤出暂存区）
#
#	删除：	a #
# 未跟踪的文件:
#	（使用 "git add <file>..." 以包含要提交的内容）
#
#	a.txt

[root@git  git_data]#  git  add  a.txt  #提交到暂存区
[root@git  git_data]#  git  status
#  位于分支  master
# 要提交的变更：
#	（使用 "git reset HEAD <file>..." 撤出暂存区）
#
#	重命名：	a ‐> a.txt	# 识别到a和a.txt相同为重命名
[root@git  git_data]#  git  commit  ‐m  "commit  a.txt"   #提交到本地仓库

2.直接用git命令重命名
[root@git  git_data]#  git  mv  a.txt  a	把工作区域和暂存区域的文件同时修改文件名称
[root@git  git_data]#  git  status
#  位于分支  master
# 要提交的变更：
#	（使用 "git reset HEAD <file>..." 撤出暂存区）
#
#	重命名：	a.txt ‐> a git  commit  ‐m  "rename  a.txt  a"

git status 只能查看区域状态的不同，不能查看文件内容的变化。
git diff 查看内容的不同
[root@git  git_data]#  echo  aaa  >  a
[root@git  git_data]#  git  diff  a	#  比对本地工作目录和暂存区文件的不同
diff ‐‐git a/a b/a
index e69de29..72943a1 100644#
‐‐‐ a/a
+++ b/a
@@ ‐0,0 +1 @@
+aaa
[root@git  git_data]#  git  add  a	            #  提交a文件到暂存区域、在用git  diff是相同的
[root@git  git_data]#  git  diff  ‐‐cached  a   # 比对的是暂存区和本地仓库文件的不同处 diff ‐‐git a/a b/a
index e69de29..72943a1 100644
‐‐‐ a/a
+++ b/a
@@ ‐0,0 +1 @@
+aaa

[root@git  git_data]#  git  commit  ‐m  "modified  a"	#  提交后在比对则暂存区和本地仓库内容相同
[master  4c57a60]  modified  a
1 file changed, 1 insertion(+)
[root@git  git_data]#  git  diff  ‐‐cached  a   #提交后对比后是相同 没有任何提示
[root@git  git_data]#

git  commit	#  相当于虚拟机的镜像、任何操作都被做了一次快照，可恢复到任意一个位置
[root@git  git_data]#  git  log	查看历史的git  commit快照操作

commit  4c57a605997f511149bfec53d9018b503e77f961	#  哈希唯一标识的字符串
Author:  lizhenya  <
lizhenya@qq.com
>	#  作者个人信息
Date:	Thu  Aug  23  07:54:23 2018 +0800	# 时 间
modified  a	#  ‐m  个人写的提交描述信息
commit  56925321114eb9adf09b42a733a6f9f3edd9ad65 Author:  lizhenya  <
lizhenya@qq.com
>
Date:	Thu Aug 23 07:39:41 2018 +0800

rename  a.txt  a


[root@git  git_data]#  git  log  ‐‐oneline	#  一行简单的显示commit信息
4c57a60  modified  a
5692532  rename  a.txt  a 7adfca0  commit  a.txt b4017a8  commit  a

[root@git  git_data]#  git  log  ‐‐oneline  ‐‐decorate	#  显示当前的指针指向哪里
4c57a60  (HEAD,  master)  modified  a
5692532  rename  a.txt  a 7adfca0  commit  a.txt b4017a8  commit  a
[root@git  git_data]#  git  log  ‐p	#  显示具体内容的变化
[root@git  git_data]#  git  log  ‐1	#  只显示1条内容

恢复历史数据
1.只更改了当前目录
[root@git  git_data]#  echo  "333"  >>  a
[root@git  git_data]#  git  status
#  位于分支  master
# 尚未暂存以备提交的变更：
#	（使用 "git add <file>..." 更新要提交的内容）
#	（使用 "git checkout ‐‐ <file>..." 丢弃工作区的改动）	# 看提示使用此命令覆盖工作区的改动
#
#	修改：	a #
修改尚未加入提交（使用  "git  add"  和/或  "git  commit  ‐a"）
[root@git  git_data]#  git  checkout  ‐‐  a	#  从暂存区覆盖本地工作目录
[root@git  git_data]#  git  status
#  位于分支  master
无文件要提交，干净的工作区
[root@git  git_data]#  cat  a
aaa

2.修改了本地目录且同时提交到了暂存区
[root@git  git_data]#  echo  ccc  >>  a	#  添加新内容
[root@git  git_data]#  git  add  .	#  提交到暂存区
[root@git  git_data]#  git  diff  ‐‐cached  #比对暂存区和本地仓库的内容
diff ‐‐git a/a b/a
index 72943a1..959479a 100644
‐‐‐ a/a
+++ b/a
@@ ‐1 +1,2 @@ aaa

+ccc

[root@git  git_data]#  git  status
#  位于分支  master
# 要提交的变更：
#	（使用 "git reset HEAD <file>..." 撤出暂存区）
#
#	修改：	a
[root@git  git_data]#  git  reset  HEAD  a	#  本地仓库a文件 覆盖暂存区域重置后撤出暂存区的变更：
M	a
[root@git  git_data]#  git  diff  a   #对比工作目录a 与暂存区 a的不同
diff ‐‐git a/a b/a
index 72943a1..959479a 100644
‐‐‐ a/a
+++ b/a
@@ ‐1 +1,2 @@ aaa
+ccc
[root@git  git_data]#  git  diff  ‐‐cached  a  #对比暂存区文件a 与本地仓库文件 a 的不同 , 没有区别就无任何输出

3.修改了工作目录后提交到了暂存区和本地仓库后进行数据恢复
echo bbb >>a	# 提交新的bbb文件到a
git  commit  ‐m  "add  bbb"  #将暂存区文件提交到本地仓库
echo ccc >> a  
git  commit  ‐am  "add  ccc"	#  这时候发现改错代码了，想还原某一次提交的文件快照
[root@git  git_data]#  git  log  ‐‐oneline
59ba2a9 add ccc
dbead4c add bbb
4c57a60  modified  a
5692532  rename  a.txt  a
7adfca0  commit  a.txt
b4017a8  commit  a

Git服务程序中有一个叫做HEAD的版本指针，当用户申请还原数据时，其实就是将HEAD指针指向到某个特定的提交版本，但是因为Git是分布式  版本控制系统，为了避免历史记录冲突，故使用了SHA‐1计算出十六进制的哈希字串来区分每个提交版本，另外默认的HEAD版本指针会指向到最近的一次提交版本记录`

[root@git  git_data]#  git  reset  ‐‐hard  4c57a60
HEAD  现在位于  4c57a60  modified  a
`刚刚的操作实际上就是改变了一下HEAD版本指针的位置，就是你将HEAD指针放在那里，那么你的当前工作版本就会定位在那里，要想把内容再还原到最新提交的版本，先看查看下提交版本号`
[root@git  git_data]#  cat  a	#  打开发现回退错了，应该回退到bbb版本
aaa
[root@git  git_data]#  git  log  ‐‐oneline	#  这时候查看log没有commit  bbb的历史了
4c57a60  modified  a
5692532  rename  a.txt  a
7adfca0  commit  a.txt
b4017a8  commit  a

怎么搞得？竟然没有了add bbb这个提交版本记录？
原因很简单，因为我们当前的工作版本是历史的一个提交点，这个历史提交点还没有发生过add bbb  更新记录，所以当然就看不到了，要是想”还原到未来”的历史更新点，可以用git reflog命令来查看所有的历史记录：

[root@git  git_data]#  git  reflog	#  使用git  reflog  可查看总历史内容
4c57a60  HEAD@{0}:  reset:  moving  to  4c57a60
59ba2a9  HEAD@{1}:  commit:  add  ccc
dbead4c  HEAD@{2}:  commit:  add  bbb
4c57a60  HEAD@{3}:  commit:  modified  a
5692532  HEAD@{4}:  commit:  rename  a.txt  a
7adfca0  HEAD@{5}:  commit:  commit  a.txt
b4017a8  HEAD@{6}:  commit  (initial):  commit  a
[root@git  git_data]#  git  reset  ‐‐hard  dbead4c	#  然后使用reset回到bbb的版本内容下
HEAD 现在位于 dbead4c add bbb
[root@git  git_data]#  cat  a
aaa bbb

```



##  4. git分支
分支即是平行空间，假设你在为某个手机系统研发拍照功能，代码已经完成了80%，但如果将这不完整的代码直接 提交到git仓库中，又有可能影响到其他人的工作，此时我们便可以在该软件的项目之上创建一个名叫”拍照功能”的分支，这种分支只会属于你自己，而其他人看不到，等代码编写完成后再与原来的项目主分支合并下即可，这 样即能保证代码不丢失，又不影响其他人的工作。



![1547388538968-b6be1210-cde1-46f9-87de-c774cc5cc275.png](img/day74持续集成教程-11.png)

一般在实际的项目开发中，我们要尽量保证master分支是非常稳定的，仅用于发布新版本，平时不要随便直接修改里面的数据文件，而工作的时候则可以新建不同的工作分支，等到工作完成后在合并到master分支上面，所以团队的合作分支看起来会像上面图那样。

```bash
[root@git  git_data]#  git  log  ‐‐oneline  ‐‐decorate
dbead4c  (HEAD,  master)  add  bbb
4c57a60  modified  a
5692532  rename  a.txt  a
7adfca0  commit  a.txt
b4017a8  commit  a

# 默认分支指向你最后一次的提交 HEAD头、指针
`HEAD 指针指向哪个分支、说明你当前在哪个分支下工作`
[root@git  git_data]#  git  branch  testing   # 新建testing分支
[root@git  git_data]#  git  branch
*  master                         # *号在哪里就说明当前在哪个分支上入下图所示
testing
```

![1547388645232-fb7dd85d-a180-46a4-9ade-ee7933b52824.png](img/day74持续集成教程-12.png)



```bash
[root@git  git_data]#  git  log  ‐‐oneline  ‐‐decorate	#  通过命令查看分支指向
dbead4c  (HEAD,  testing,  master)  add  bbb
4c57a60  modified  a
5692532  rename  a.txt  a
7adfca0  commit  a.txt
b4017a8  commit  a
[root@git  git_data]#  git  checkout  testing	#  切换到testing分支、对应的HEAD指针也指向了testing切换到分支  'testing'
[root@git  git_data]#  git  branch   #查看所有分支  *表示所在分支
master
* testing

```

![1547368343567-783a8e47-2868-40c0-8e4a-8c63e0c18b80-image13.png](img/day74持续集成教程-13.png)

```bash
[root@git  git_data]#  touch  test
[root@git  git_data]#  git  add  .
[root@git  git_data]#  git  commit  ‐m  "commit  test"

```



![1547368343586-6b102c9d-d532-4cca-8800-cc6782edd6d3-image14.png](img/day74持续集成教程-14.png)



```bash
[root@git  git_data]#  git  checkout  master	#  切换到master分支后指针指向到了master切换到分支  'master'
[root@git  git_data]#  git  branch
*  master
testing
[root@git  git_data]#  ll      #  正常情况下是没有test文件的、保证master分支是线上环境的
总用量 4
‐rw‐r‐‐r‐‐  1  root  root  8  8月	23  08:42  a

```

![1547368343607-2dab6491-5d53-4662-a655-80254a16e4fd-image15.png](img/day74持续集成教程-15.png)



```bash
[root@git  git_data]#  touch  master
[root@git  git_data]#  git  add  .
[root@git  git_data]#  git  commit  ‐m  "commit  master"

```



![1547368343629-37a363ac-dafb-4bef-ba83-f07e102c6118-image16.png](img/day74持续集成教程-16.png)

```bash
合并分支
[root@git  git_data]#  git  merge  testing     #  提示输入描述信息  相当于git的‐m参数
[root@git  git_data]#  git  log  ‐‐oneline  ‐‐decorate
3258705  (HEAD,  master)  Merge  branch  'testing'
f5ae1d8  commit  master
ad4f25a  (testing)  commit  test
dbead4c add bbb
4c57a60  modified  a
5692532  rename  a.txt  a
7adfca0  commit  a.txt
b4017a8  commit  a

```



![1547368343656-7eb0d1d2-6156-4f4c-88b8-76ecdcc5c55c-image17.png](img/day74持续集成教程-17.png)



```bash
冲突合并
[root@git  git_data]#  echo  "master"  >>  a
[root@git  git_data]#  git  commit  ‐am  "modified  a  master"  # 将工作区域的代码一次性提交到本地仓库
[root@git  git_data]#  git  checkout  testing     #切换分支testing
切换到分支  'testing'
[root@git  git_data]#  git  branch                     # 查看所有分支
master
* testing
[root@git  git_data]#  cat  a
aaa
bbb
[root@git  git_data]#  echo  "testing"  >>a
[root@git  git_data]#  git  commit  ‐am  "modified  a  on  testing  branch" #将工作目录文件一次提交到本地仓库
[root@git  git_data]#  git  checkout  master       #切换master主分支
[root@git  git_data]#  git  merge  testing          #合并分支 testing
Auto-merging a
      #自动合并 a
CONFLICT (content): Merge conflict in a
    #冲突（内容）：合并
Automatic merge failed; fix conflicts and then commit the result.   #自动合并失败，修正冲突然后提交修正的结果。
[root@git  git_data]#  cat  a	#  冲突的文件自动标识到文件里，手动更改冲突要保留的代码
[root@yht git_data]# cat -n a
  # 修改过后的内容
    1	aaa
    2	ccc
    3	bbb
    4	ccc
    5	master
    6	testing
[root@git  git_data]#  git  commit  ‐am  "merge  testing  to  master"	#  进行提交即可
[root@git  git_data]#  git  log  ‐‐oneline  ‐‐decorate
bba413d  (HEAD,  master)  merge  testing  to  master
34d7a55  (testing)  modified  a  on  testing  branch
ec1a424  modified  a  master
3258705  Merge  branch  'testing' f5ae1d8  commit  master
ad4f25a  commit  test
删除分支‐d参数
[root@git  git_data]#  git  branch  ‐d  testing
Deleted branch testing (was 8406e79).      #已删除分支 testing（曾为 34d7a55）。
[root@git  git_data]#  git  branch
*  master
```





## 5.git标签使用
```bash
标签也是指向了一次commit提交，是一个里程碑式的标签，回滚打标签直接加标签号，不需要加唯一字符串不好记
# git  tag  ‐a  v1.0  ‐m  "aaa  bbb  master  tesing  version  v1.0"  #‐a指定标签名字  ‐m  指定说明文字
#  git  tag        #列出所有标签
v1.0

#  git  tag  ‐a  v2.0  dbead4c  ‐m  "add  bbb  version  v2.0"	#  指定某一次的提交为标签
#  git  show  v1.0	#  查看v1.0的信息	git  show  加标签查看
#  git  reset  ‐‐hard  v2.0	#  直接还原数据到v2.0
HEAD 现在位于 dbead4c add bbb

#  ll
总用量 4
‐rw‐r‐‐r‐‐  1  root  root  8  8月	23  11:26  a
‐rw‐r‐‐r‐‐  1  root  root  0  8月	23  11:25  b

#  git  tag  ‐d  v2.0	#  删除标签  ‐d参数

```



# 05.github使用
Github顾名思义是一个Git版本库的托管服务，是目前全球最大的软件仓库，拥有上百万的开发者用户，也是软件开发和寻找资源的最佳途径，Github不仅可以托管各种Git版本仓库，还拥有了更美观的Web界面，您的代码文件可以被任何人克隆，使得开发者为开源项贡献代码变得更加容易，当然也可以付费购买私有库，这样高性价比的私有库真的是帮助到了很多团队和企业

1、注册用户	# 课前注册好用户

2、配置ssh‐key

3、创建项目

4、克隆项目到本地

5、推送新代码到github



![1547432381418-afbd93f9-f408-4a1f-8468-13434384af3c.png](img/day74持续集成教程-18.png)



![1547432928010-d0aa3feb-eefa-4c69-a441-ddf155c2d067.png](img/day74持续集成教程-19.png)



```bash
[root@git git_data]# git remote add origin https://github.com/chengkanghua178/repository.git
[root@git github]# git push -u origin master  #推送到origin 远程仓库
Username for 'https://github.com': chengkanghua178    #提示输入github账号密码
Password for 'https://chengkanghua178@github.com':
Counting objects: 3, done.         # 计数对象：3，完成。
Writing objects: 100% (3/3), 224 bytes | 0 bytes/s, done.  #写入对象：100%（3/3），224字节0字节/秒，完成。
Total 3 (delta 0), reused 0 (delta 0)   #总计3（增量0），重复使用0（增量0
To https://github.com/chengkanghua178/repository.git
 * [new branch]      master -> master    #*[新分支]master->master
Branch master set up to track remote branch master from origin. #分支主机设置为从源站跟踪远程分支主机。

```



```bash
[root@git  git_data]#  git  remote
origin
克隆http到本地进行测试
cd  /tmp/
git  clone  https://github.com/chengkanghua178/repository.git   #将远程仓库代码克隆到本地
低版本的系统存在版本问题提示
fatal:  unable  to  access  'https://github.com/oldboylzy/oldboy.git/':  Peer  reports
incompatible  or  unsupported  protocol  version yum  update ‐y nss curl libcurl	#升级版本即可
[root@git  git_test]#  touch  d
[root@git  git_test]#  git  add  .
[root@git  git_test]#  git  commit  ‐m  "add  d"
[root@git  git_test]#  git  push  ‐u  origin  master       #将代码提交远程仓库origin master主分支
[root@git  git_data]#  cd  /root/git_data/
[root@git git_data]# git init
Initialized empty Git repository in /root/git_data/.git/
[root@git git_data]# git pull https://github.com/chengkanghua178/repository.git  # 拉取远程仓库最新代码、然后进行上传

```



```bash
[root@git git_data]# ls  					#查看文件
d  README.md
[root@git git_data]# vim d 				#编辑文件 添加内容test d
[root@git git_data]# git add .   #提交到暂存区
[root@git git_data]# git commit -m "modify d"  #提交到本地仓库
[master e345d09] modify d
 1 file changed, 2 insertions(+)
[root@git git_data]# git push -u orgin master  #推送到远程仓库orgin master主分支
fatal: 'orgin' does not appear to be a git repository #致命错误:orgin不是git存储库
fatal: Could not read from remote repository.

Please make sure you have the correct access rights  请确保您拥有正确的访问权限
and the repository exists.  #并且 存储库存在。

#添加远程仓库  命名origin
[root@git git_data]# git remote add origin https://github.com/chengkanghua178/repository.git
[root@git git_data]# git push -u origin master   #推送本地仓库至远程仓库
Username for 'https://github.com': chengkanghua178
Password for 'https://chengkanghua178@github.com':
Counting objects: 5, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 272 bytes | 0 bytes/s, done.  #写入对象100% 完成
Total 3 (delta 0), reused 0 (delta 0)
To https://github.com/chengkanghua178/repository.git
   9f1ba3e..e345d09  master -> master
Branch master set up to track remote branch master from origin.
#这时候 github上可以看到修改的内容
```



# 06.gitlab安装
GitLab简介

GitLab  是一个用于仓库管理系统的开源项目。使用Git作为代码管理工具，并在此基础上搭建起来的web服务。可通过Web界面进行访问公开的或者私人项目。它拥有与Github类似的功能，能够浏览源代码，管理缺陷和注释。可以管理团队对仓库的访问，它非常易于浏览提交过的版本并提供一个文件历史库。团队成员可以利用内置的简单聊天程序(Wall)进行交流。它还提供一个代码片段收集功能可以轻松实现代码复用。

常用的网站：

官网：https://about.gitlab.com/

国内镜像：[https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/](https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/)

安装环境：

1、	CentOS 6或者7

2、	2G内存（实验）生产（至少4G）

3、	安装包：gitlab‐ce‐10.2.2‐ce

4、	禁用防火墙，关闭selinux

```bash
https://about.gitlab.com/installation/#centos‐7	 # gitlab官网
# 安装依赖
yum  install -y curl policycoreutils‐python openssh‐server	


#上传gitlab安装包  下载方式可通过国内清华源gitlab‐ce社区版本下载
#rz  ‐bye  gitlab‐ce‐10.2.2‐ce.0.el7.x86_64.rpm


mkdir -p ~/tools ;cd ~/tools
wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-10.2.2-ce.0.el7.x86_64.rpm
[root@git ~]# yum localinstall gitlab‐ce‐10.2.2‐ce.0.el7.x86_64.rpm   #yum localinstall 自动解决依赖

vim  /etc/gitlab/gitlab.rb		#gitlab  配置文件
更改url地址为本机IP地址  external_url  'http://10.0.0.203'
gitlab-ctl reconfigure 	# 更改配置文件后需重新配置
浏览器访问 http://10.0.0.203  提示设置初始密码 (gitlab123) , 然后用root账号登陆

/opt/gitlab/	# gitlab的程序安装目录
/var/opt/gitlab	# gitlab目录数据目录
/var/opt/gitlab/git‐dfata	# 存放仓库数据
gitlab‐ctl status	# 查看目前gitlab所有服务运维状态
gitlab‐ctl stop	# 停止gitlab服务
gitlab‐ctl stop nginx	# 单独停止某个服务
gitlab‐ctl tail	# 查看所有服务的日志

Gitlab的服务构成：
nginx：	静态web服务器
gitlab‐workhorse:  轻量级的反向代理服务器
logrotate：日志文件管理工具
postgresql：数据库
redis：缓存数据库
sidekiq：用于在后台执行队列任务（异步执行）。（Ruby）
unicorn：An  HTTP  server  for  Rack  applications，GitLab  Rails应用是托管在这个服务器上面的。（Ruby Web Server,主要使用Ruby编写）

gitlab汉化：
1、下载汉化补丁
git  clone  https://gitlab.com/xhang/gitlab.git
2、查看全部分支版本git branch ‐a
3、对比版本、生成补丁包
git diff remotes/origin/10-2-stable remotes/origin/10-2-stable-zh > ../10.2.2-zh.diff
4、停止服务器
gitlab-ctl stop
5、打补丁
yum install -y patch 
patch  ‐d  /opt/gitlab/embedded/service/gitlab‐rails  ‐p1  <  /tmp/10.2.2‐zh.diff
6、启动和重新配置
gitlab‐ctl start
gitlab‐ctl reconfigure
```



# 07.gitlab使用


```bash
1、配置外观
    管理区域(admin-area)‐-->外观(appearance)
2、关闭自动注册‐可根据实际需求操作
    管理区域‐设置‐关闭自动注册
    settings --> sign-up Restrictions --sign-up enabled 去√
3、创建组‐用户‐项目
    创建组
```



![1547368343714-0809a25f-dc30-4813-a692-132360f1ee2d-image19.jpeg](img/day74持续集成教程-20.jpeg)



设置组名称、描述等创建群组

#这里先创建组 , 然后创建用户加入到组里, 然后创建项目,项目属于哪个组开发的, 然后组成员就可以访问



![1547368343748-a43f16b5-6004-449a-810a-4361b9616783-image20.jpeg](img/day74持续集成教程-21.jpeg)



创建用户

![1547368343806-95a5e6a2-e826-43be-b5f3-f65b49359151-image22.png](img/day74持续集成教程-22.png)



![1547368343830-32f8997d-ea1d-4dda-803d-a271c4c78c77-image23.png](img/day74持续集成教程-23.png)



![1547368343852-0c0b733a-3fa0-4357-a24d-0c2310f18db9-image24.png](img/day74持续集成教程-24.png)





新用户创建页面不可填写密码, 创建后,点编辑 既可以填写密码





4、把用户添加到组里面

管理区域-选择创建的oldboy组进行添加用户、权限给开发人员-增加用户到群组![1547368343875-a055ff95-7d2a-434c-bf27-7d1058e34771-image25.jpeg](img/day74持续集成教程-25.jpeg)





5、创建仓库

管理区域-创建仓库



![1547368343899-507d5e33-3ef6-4c92-b710-0619927c2299-image26.jpeg](img/day74持续集成教程-26.jpeg)



项目设置哪个组管理,这样组成员登陆时候也能看项目代码



![1547522849707-bef048c8-fea0-49ee-a71f-2f120db4d086.png](img/day74持续集成教程-27.png)





6、登陆dev用户测试是否能看到空的git‐test仓库

![1547521611863-04b8dd4a-c556-42f0-9aff-0e53dad9c33a.png](img/day74持续集成教程-28.png)

7、添加ssh‐keys到gitlab 注：一个服务器的key只能添加到一个gitlab服务器上，一个用户可以添加多个key

```bash
ssh-keygen -t rsa    #生成秘钥   一路回车
# cat ~/.ssh/id_rsa.pub   #复制公钥
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr+Y1S4W/YAaxdS0CALUPIBcgZywaZJIWPukWp8DA8ClByKlTD+v144TjqRmSj4b5Fw4rUV1Di+BWjiagDfXUWLBJarn0rV+wynuFIIoFkbFdELR4UfWWOeHX3FyY5EfXH3alMWx7274W7loEgIYX/92IStIMdAzTWQwTk0Aup4chcZcZr9IcMHIp3o90xDcCS0F0T7rkYfyD24Dc+2BZ9mSyG+6oMX6l2WZDKMKfST6v80/scQQ5c2zk/keVkN8ZY6t5PMkaZT56AyEImRns1J2IgarMXSvwUGWmM2OD1ca5AN4Z0EVqy7yBgrnrPNL1TvFs8A3p+zuz3YKRA3rGX root@oldboy


```

添加 user settings  --> SSH keys



8、添加远程仓库、推送本地代码到远程仓库

```bash
git  remote  add  origin  git@10.0.0.203:oldboy/get_test.git	#  添加远程仓库
git  remote  rename  origin  old‐origin    		# 远程 origin 如果已经存在则重新命名或者新添加仓库名称不同
git push ‐u origin ‐‐all          	#推送代码到远程仓库


Existing folder
cd existing_folder
git init
git remote add origin git@10.0.0.20:root/git_test.git
git add .
git commit -m "Initial commit"
git push -u origin master

----------------------------------------------------------------------------------------
[root@server ~]# git clone http://10.0.0.2/oldboy/get_test.git
Cloning into 'get_test'...
Username for 'http://10.0.0.2': root
Password for 'http://root@10.0.0.2':
cd get_test/
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master

```



8、克隆代码到另外一台主机

```bash
如果不做认证会让输入gitlab的密码、
我们使用key进行认证
ssh-keygen -t rsa
把公钥复制到dev用户下进行测试然后在克隆代码
git  clone  git@10.0.0.203:oldboy/get_test.git
测试推送代码到dev下
git branch dev      #创建分支 dev
git checkout dev    #切换分支 dev
touch dev      
git add .                      #添加到暂存区
git commit  ‐m  "add  dev"    #添加到本地仓库
git push ‐u origin dev	   # 推送dev分支到远程仓库 (推送之后 gitlablab页面上会多一个dev分支)
```



![1547518405778-ac09b891-a85f-42c4-bfd2-597c9833a864.png](img/day74持续集成教程-29.png)



提交合并请求进行分支合并到master主分支

![1547524229864-dad7ff76-2bc3-4ead-a066-5ddc0b385897.png](img/day74持续集成教程-30.png)



![1547524314054-846b2b88-1aed-4654-86f6-4287422c5381.png](img/day74持续集成教程-31.png)



合并后在gitlab服务端master上没有dev、要先进行pull

cd /root/git_data

git pull



添加项目成员

![1547520756579-a3b8df08-33c9-48ac-96c5-e81ca22cfab9.png](img/day74持续集成教程-32.png)





9、设置保护主分支

root 用户登录

![1547368343939-c574c01b-f898-4303-91c3-fd34da7f0f24-image27.jpeg](img/day74持续集成教程-33.jpeg)

测试dev分支推送代码则显示为拒绝，如果还是可以推送请查看配置保护分支选项

[root@web01  get_test]#  git  merge  dev

[root@web01  get_test]#  git  push  ‐u  origin  master



```bash
[root@oldboy git_data]# git checkout master
[root@oldboy git_data]# touch dev3
[root@oldboy git_data]# git add .
[root@oldboy git_data]# git commit -m "add dev3"
[root@oldboy git_data]# git push -u origin master
Counting objects: 3, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 238 bytes | 0 bytes/s, done.
Total 2 (delta 0), reused 0 (delta 0)
#远程：gitlab:不允许将代码推送到此项目上受保护的分支。
remote: GitLab: You are not allowed to push code to protected branches on this project.
To git@10.0.0.20:oldboy/git_data.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'git@10.0.0.20:oldboy/git_data.git'
```



10、返回master端测试推送，由于其他分支进行推送，和master端内容不一致，所以无法进行推送，使用git pull把代码拉取到本地，或者git fetch 把代码拉取到本地仓库后进行合并（注意：git pull = git fetch+git  merge）



```bash
[root@oldboy git_data]# git branch -d dev  #删除dev分支
Deleted branch dev (was ef9fe17).
[root@oldboy git_data]# git branch dev   #创建dev分支
[root@oldboy git_data]# git checkout dev   #切换到dev分支
[root@oldboy git_data]# git commit -am "dev dev" #将本地代码一次提交到本地仓库
# On branch dev
nothing to commit, working directory clean
[root@oldboy git_data]# git remote
origin
[root@oldboy git_data]# git push -u origin dev   #提交成功 可以提交到dev分支
Counting objects: 3, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 238 bytes | 0 bytes/sgit , done.
Total 2 (delta 0), reused 0 (delta 0)
remote:
remote: To create a merge request for dev, visit:
remote:   http://10.0.0.20/oldboy/git_data/merge_requests/new?merge_request%5Bsource_branch%5D=dev
remote:
To git@10.0.0.20:oldboy/git_data.git
   ef9fe17..4ee4155  dev -> dev
Branch dev set up to track remote branch dev from origin.

```



然后去gitlab 页面,登陆dev用户   提交merge request 合并请求

![1547531601956-9454c6b6-245d-4763-bcc7-771eae8f344e.png](img/day74持续集成教程-34.png)

![1547531669176-b8d84046-6746-4950-90a2-23ac8d043575.png](img/day74持续集成教程-35.png)



登陆管理员账号root  , merge Requests 1



![1547531787364-21ec2755-9e11-4002-8307-a563d31d1604.png](img/day74持续集成教程-36.png)



![1547531948203-660d93d2-bbc4-4c8f-8318-bef4b3996559.png](img/day74持续集成教程-37.png)



模拟开发人员dev 用户推送代码到dev分支下

```bash
[root@oldboy git_data]# touch ./devdev/aaaa.log
[root@oldboy git_data]# touch aaa.log
[root@oldboy git_data]# git add .
[root@oldboy git_data]# git commit -m "aaa.log"
[root@oldboy git_data]# git push -u origin dev
[root@oldboy git_data]# ls
aaa.log  dev  devdev  README.md
[root@oldboy git_data]# git rm dev
rm 'dev'
[root@oldboy git_data]# git add .
[root@oldboy git_data]# git commit -m "rm dev"
[root@oldboy git_data]# git branch
* dev
  master
[root@oldboy git_data]# git push -u origin dev
```

# 08.gitlab备份
对gitlab进行备份将会创建一个包含所有库和附件的归档文件。对备份的恢复只能恢复到与备份时的gitlab相同的版本。

将gitlab迁移到另一台服务器上的最佳方法就是通过备份和还原。                            

gitlab提供了一个简单的命令行来备份整个gitlab，并且能灵活的满足需求。

备份文件将保存在配置文件(/etc/gitlab/gitlab.rb)中定义的backup_path中，文件名为TIMESTAMP_gitlab_backup.tar,TIMESTAMP为备份时的时间戳。TIMESTAMP的格式为：EPOCH_YYYY_MM_DD_Gitlab‐version。



如果自定义备份目录需要赋予git权限配置文件中加入

gitlab_rails['backup_path']  =  '/data/backup/gitlab'

gitlab_rails['backup_keep_time']  =  604800	#备份保留的时间（以秒为单位，这个是七天默认值），

mkdir  /data/backup/gitlab

chown ‐R git.git /data/backup/gitlab

完成后执行gitlab‐ctl reconfigure



官方文档

[https://docs.gitlab.com/omnibus/settings/backups.html](https://docs.gitlab.com/omnibus/settings/backups.html)

```bash
mkdir -p /data/gitlab/backups
tar zcf /data/gitlab/backups/$(date "+etc-gitlab-\%s.tgz") -C / etc/gitlab  #配置配置文件
cat >> /etc/gitlab/gitlab.rb<<EOF
gitlab_rails['backup_path']  =  '/data/gitlab/backups'
gitlab_rails['backup_keep_time']  =  604800	 #备份保留的时间（以秒为单位，这个是七天默认值），
EOF
chown -R git.git /data/gitlab/backups
# 完成后执行
gitlab-ctl reconfigure

```



# 09.jenkins


官 网 jenkins.io

Jenkins是一个开源软件项目，是基于Java开发的一种持续集成工具，用于监控持续重复的工作，旨在提供一个开    放易用的软件平台，使软件的持续集成变成可能。

安装包下载

[https://repo.huaweicloud.com/java/jdk](https://repo.huaweicloud.com/java/jdk)

[https://mirrors.huaweicloud.com/jenkins/redhat/](https://mirrors.huaweicloud.com/jenkins/redhat/)



## 1.安装
装备两台服务器 关闭selinux和防火墙内存2G 50G+硬盘

jenkins	10.0.0.201

nexus	10.0.0.202



```bash

mkdir -p ~/tools/ ;cd ~/tools/
wget https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.rpm
wget https://mirrors.huaweicloud.com/jenkins/redhat/jenkins-2.99-1.1.noarch.rpm
# 2.安装JDK运行环境和jenkins服务
rpm -ivh jdk-8u181-linux-x64.rpm
rpm -ivh jenkins-2.99-1.1.noarch.rpm

java -version
# 3.配置jenkins
# 启动用户修改为root JENKINS_USER="root"
sed -i '/^JENKINS_USER/s#jenkins#root#gp' /etc/sysconfig/jenkins
systemctl  start  jenkins 
systemctl  enable  jenkins
#访问页面进行配置 http://10.0.0.201:8080



4.jenkins主要的目录
/usr/lib/jenkins/：jenkins安装目录，WAR包会放在这里
/etc/sysconfig/jenkins：jenkins配置文件，“端口”，“JENKINS_HOME”等都可以在这里配置
/var/lib/jenkins/：默认的JENKINS_HOME
/var/log/jenkins/jenkins.log：Jenkins日志文件



4.插件安装（跳过安装插件，直接上传插件到目录）和修改登录密码
官方的插件下载地址：http://updates.jenkins-ci.org/
国内的源：https://mirrors.tuna.tsinghua.edu.cn/jenkins/plugins/
  1.自动安装可选插件
  2.手动下载插件上传安装
  3.插件放入插件目录
#插件目录
cd /var/lib/jenkins/plugins/
[root@m01 plugins]# tar zxvf plugins.tar.gz




上传插件包解压到plugins下执行重启	
systemctl  restart  jenkins
```





## 2.创建一个自由风格的项目freestyle‐job


![1547368343964-500e9403-b6cb-4640-bcb0-bca7a9481db4-image28.jpeg](img/day74持续集成教程-38.jpeg)



丢失旧的构建

![1547368343992-188453e6-d66c-42ac-9d82-52644eaee720-image29.png](img/day74持续集成教程-39.png)

执行一条shell命令、查看运行的当前路径,构建后的产物存储在/var/lib/jenkins/workspace/



![1547368344028-6f27f6c5-c489-433b-b128-068624909129-image30.jpeg](img/day74持续集成教程-40.jpeg)



### 2.1jenkins获取git源码，在 gitlab 导入一个监控项目代码
[https://gitee.com/kangjie1209/monitor.git](https://gitee.com/kangjie1209/monitor.git)

[https://gitee.com/chengkanghua/monitor](https://gitee.com/chengkanghua/monitor)



![1547368344053-940ad07e-ed98-47c3-a1bf-4329c290fc25-image31.jpeg](img/day74持续集成教程-41.jpeg)





### 2.2 jenkins端配置 项目->源码管理-->获取代码凭证方式，
<font style="color:rgb(0, 0, 0);">方式一、通过http方式链接</font>

源码管理 : repository url:  [http://10.0.0.2/oldboy/monitor](http://10.0.0.2/oldboy/monitor)

<font style="color:rgb(0, 0, 0);">凭证:  添加 账号密码  类型 </font>

<font style="color:rgb(0, 0, 0);"></font>

<font style="color:rgb(0, 0, 0);">方式二、SSH密钥类型(推荐)</font>

```bash
# jenkins 服务器安装 git   :   
yum install -y git
# 添加git仓库失败,可能是yum安装的git版本太低,可以手动安装最新版本git
# 我们可以从GitHub上下载最新的源码编译后安装最新的git
# git安装 https://blog.csdn.net/qq_575775600/article/details/120997367


ssh-keygen -t rsa
# jenkins服务器配置免密登录gitlab 
ssh-copy-id root@10.0.0.2

[root@jenkins ~]# cat .ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLae2TAKKfqfs29QT0zlwtXUMWNQEKu8HG1uMGjDS4J+9fRbeX+SzpV5+vdOFXMxrIcOWnLZoKG2oBjV0PVeYcVd+D1ce4fGQxCAQdxoZzHDBmcPBphjjHZh7dnpt2WzcYIEdf4SpqydlZQv/nYD4W85l17QDnDxfMZ9dI9NtaG+VfoMJe/HH0nVNuDUD1mJeQxX13qcnszNbvo5teeD6HtKikS+0pMjHq4EveePL87rPNL2wJ37OGj+PSDdMrqMlTUl5/5SYnaWPRbqp5GxOP7hLlLKC1PY7rS0/5bUypSteSPG8est3yK5qN7WwrpfEADGl5IPDs0ra32BGKP2E1 root@jenkins
# 公钥 添加到  gitlab中
# 以root账户登录——》点击头像——》Settings——》SSH Keys
# 复制刚才 id_rsa.pub文件的内容到这里，点击“Add Key”


[root@jenkins ~]# cat .ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAy2ntkwCin6n7NvUE9M5cLV1DFjUBCrvBxtbjBow0uCfvX0W3
l/ks6Vefr3ThVzMayHDlpy2aChtqAY1dD1XmHFXfg9XHuHxkMQgEHcaGcxwwZnDw
aYY4x2Ye3Z6bdls3GCBHX+EqasnZWUL/52A+FvOZde0A5w8XzGfXSPTbWhvlX6DC
Xvxx9J1Tbg1A9ZiXkMV9d6nJ7MzW76ObXng+h7SopEvtKTIx6uBL3njy/O6zzS9s
Cd+zho/j0g3TK6jJU1Jef+UmJ2lj0W6qeRsTj+4S5SygtT2O60tP+W1MqUrXkjxv
HrLd8iuaje1sK6XxAAxpeSDw7NK2t9gRij9hNQIDAQABAoIBAQDJh59K/1wfV+d+
YW6RpEoK39VxkP4BRlgLyiaO/CXXNimgeJAWz1ZBsQCScvg2znkAkWnWIgX1cYer
FgVXBkG/XQzfrtP64bLaKRj67w+RyCHjvI1T3xkt5O07oMJhlqmVC5XrVkgSGP1v
xEOJVv7s+lfWUAOO6JMpfs/6hi00rZ2NLjxibV0ToJNsOMhLVtqdrqYQI9HA2Wty
IpUZSggUcDv4X0POza0u8HZD8BPzKWYxygAkgHEB/YahVPP1FJdGZILf/MLAMWgI
Xplrg8TmtzscEz87XQ6hrzPzbdk9sH5QalhQYYH9tUhzR7d3IwquE5kwGaatQiJR
4qBPAmLBAoGBAPNZiYPx3pGg4Z246FpenXGxzOj/YWQeW0XKs9NBV6mpsr06n0WD
DxbORqf0IHGFmIBzzL/yhvCCsZyeIxDUIWIv4K89c6dffP2znqSg29Ol1zzpEbu3
+guLVDCozHK49ckJOTUnkcDJ5a1ZQDVYzLd7c+RqWGi0nVV9oTzUFelJAoGBANX8
7cSuQlUfN75EnE67YivKcrvizKkA17KcmwhDG1sg29rl+anDEhzmN0HRu+beIjDg
V/LGKgDRvRP91SXlKB03eVAMkFEAmmnQyxJVsweSOrkccxp9TE4xVOWphXp4zmG7
Cv+iUonIMTYCdCkFUjIP09QwZ0c5cX3yLVwZAsSNAoGBAItb3EemjLpDMtFbIh0W
j/2bP+iyz3hBdi2arq6tfeFYoFaDqtBpBIwf5xCp2qaIRlRRfJDz99jmT4aMfTJW
+SM8neRdQc04/uBfK9vFjv4+u+tS4efprRVNXhJbqHGOgJr3YD6TgYGxXYmPUhj6
2Im+9hh52lVkEbHytxKZtk6ZAoGAX4xLYqnopneE/WlHXgRfhmwkJO7VMZVVusQg
mWTVfzBB2xEbFIksuki1XadXvnNrUuWpf5aqRKliQt3xYbVb3wfZHDwv6Gtbh2oa
crpfcT8DB4rDfo16F+QBI3c5SYFNrefFtnV1Y15HUvVvhq2AkSfuDu35/5yPp4wO
YvQr/zUCf1MWJ5FUek096Btb7ptk9nW6bpBCNQ2n93LPTwEAi2fXiu3KXLtD6/JQ
+CY3ZtJswNA6GH+BF3NHsNg5W104lcAEu+bvH0JRdMsHVCzbq013/I5m5KYeVGbY
Z9uWpaBXVRAH9KpgwzomU1bOR3ih3QsQHezw0nCSPn88XFRepCc=
-----END RSA PRIVATE KEY-----

把生成的私钥放在Jenkins中
打开全局凭证——》添加凭证
http://10.0.0.3:8080/credentials/store/system/domain/_/newCredentials

```

![1725531667374-ccd9a75a-8fc7-434b-88b9-d5bcaebdfee8.png](img/day74持续集成教程-42.png)



jenkins 项目的源码管理 选择对应的凭证

![1725531736654-b201d22e-256f-4f8f-9e28-2a37daea6cf3.png](img/day74持续集成教程-43.png)



7.执行立即构建获取到代码



![1547368344120-6acfaed4-ddea-4a35-b65f-0c052fc645ad-image33.png](img/day74持续集成教程-44.png)



2.3 .写一个脚本把从git仓库里获取的代码上传到web服务器站点目录下



```bash
# ssh-keygen -t rsa
 # jenkins服务器提前做好免密登录web服务器
ssh-copy-id 10.0.0.4 
mkdir -p /server/scripts/

cat > /server/scripts/deploy.sh<<'EOF'
#!/bin/sh
DATE=$(date +%Y-%m-%d-%H-%M-%S)
CODE_DIR="/var/lib/jenkins/workspace/freestyle-job"
WEB_DIR="/usr/share/nginx/"
web_server=10.0.0.4
get_code_tar(){
  cd  $CODE_DIR  && tar zcf /opt/web-$DATE.tar.gz  ./*
}
scp_code_web(){
  scp  /opt/web-$DATE.tar.gz  $web_server:$WEB_DIR
}
code_tarxf(){
  ssh  $web_server  "cd  $WEB_DIR  && mkdir  web-$DATE  && tar xf web-$DATE.tar.gz -C web-$DATE"
}
ln_html(){
  ssh  $web_server  "cd  $WEB_DIR  &&  rm  -rf  html  &&  ln  -s  web-$DATE  html"
}
main(){
  get_code_tar;
  scp_code_web;
  code_tarxf;
  ln_html;
}
main
EOF

```



### 2.3.使用jenkins调用部署脚本（此处写脚本全路径脚本名称）测试


![1547368344150-2c249cd2-be81-42e8-8bb6-c783493b9659-image34.png](img/day74持续集成教程-45.png)





### 2.4.配置自动触发构建、需要设置安全令牌Secret token
![1547368344178-6080fe3f-25ac-4daa-bb2d-e387932e06bd-image35.jpeg](img/day74持续集成教程-46.jpeg)



[http://10.0.0.2/oldboy/monitor/settings/integrations](http://10.0.0.2/oldboy/monitor/settings/integrations)

gitlab 项目-->设置-->集成 页面



![1547368344206-dcf02680-5468-470f-994b-10fa2cb074fc-image36.jpeg](img/day74持续集成教程-47.jpeg)









### 2.5.克隆代码到master上更改代码后进行推送测试是否自动触发
```bash
git  clone  git@10.0.0.203:oldboy/monitor.git
cd monitor
touch test.log
git add .
git commit -m "test job"
git push -u origin master
```





### 2.6Jenkins配置jenkins返回构建状态到gitlab
系统管理‐系统设置选项下

![1547368344236-36efd6e1-2b74-40fb-b67c-c29042f9213d-image37.jpeg](img/day74持续集成教程-48.jpeg)

这里点击添加凭证: 



gitlab root 用户登录 进行认证配置进入gitlab点击用户设置找到访问令牌Access Tokens

![1547368344262-1d12dd2b-0784-44b5-9967-a1b085a4831f-image38.jpeg](img/day74持续集成教程-49.jpeg)



![1547368344285-7ebb93b3-b93e-4708-8eaa-9785bd727481-image39.png](img/day74持续集成教程-50.png)



jenkins 添加 全局凭证, api token, (这里是刚刚系统设置添加的界面)

![1547368344305-6c48bb99-633a-4d3f-a94e-2bb45ca30d80-image40.png](img/day74持续集成教程-51.png)



下一步设置项目中的执行后操作。然后进行构建测试返回结果

![1547368344337-b98a8d18-2988-4043-a006-4479467459a8-image41.png](img/day74持续集成教程-52.png)



查看测试结果 (重新 push 代码 自动构建后 在 gitlab 页面上可以看到返回的结果状态)



![1547368344357-49c47654-60c5-4ec0-a73f-3765742e5f55-image42.jpeg](img/day74持续集成教程-53.jpeg)







### 2.7  配置构建发送邮件
每次执行完构建任务后，我们都可以通过邮件来通知相关人员构建的执行情况，具体配置如下：

全局配置

在 jenkins 系统管理—>系统设置，

在系统设置中找到 Jenkins Locaction 填好 JenkinsURL 跟系统管理员的邮件地址，注意必填。

![1725542612856-3bfad978-bcf0-46a6-8498-9ccaf57461f9.png](img/day74持续集成教程-54.png)



找到“邮件通知”部分，(有一个中文的,一个英文部分,两个都要填写.) 

提前登录 163 邮箱开通 smtp 服务,获取一个授权密码 : CNAIVRVDPBOYQSUB  

passwd: 粘贴授权码

![1725542832834-571de10f-97e5-4491-8b25-d4c611ad68ab.png](img/day74持续集成教程-55.png)

第二个中文邮件通知部分, 填写一样

![1725542819022-af91da4b-b361-43ee-8f0a-e0e6a90861da.png](img/day74持续集成教程-56.png)

jenkins  进入 job 配置页面，下拉至构建后操作部分

![1725542923245-f34cf1d4-3a71-40a7-852e-1fbad56cfe30.png](img/day74持续集成教程-57.png)



E-mail Notification 选项配置比较简单

![1725542979513-0793e38c-e11f-4aa5-8e9e-61395c8ff3b4.png](img/day74持续集成教程-58.png)

editable Email Notification 配置接收邮件列表和 内容,

![1725543024320-4a16ba11-1472-463c-aae3-965458e69e78.png](img/day74持续集成教程-59.png)

默认是构建失败才发送邮件, 点击高级设置,添加 成功也发送邮件 triggers,: 

send To 添加 Recipient list

add Trigger : Success

![1725543115568-bedc4dd4-31c1-418a-8614-b7f477f57ec1.png](img/day74持续集成教程-60.png)



最后构建测试  会收到邮件提示



# 10.创建Maven项目
Maven是一个项目管理和综合工具。Maven提供给开发人员构建一个完整的生命周期框架。

开发团队可以自动完成该项目的基础设施建设，Maven使用标准的目录结构和默认构建生命周期。

Apache的开源项目主要服务于JAVA平台的构建、依赖管理、项目管理。

Project  Object  Model，项目对象模型。通过xml格式保存的pom.xml文件。该文件用于管理：源代码、配置文 件、开发者的信息和角色、问题追踪系统、组织信息、项目授权、项目的url、项目的依赖关系等等。该文件是由开发维护，我们运维人员可以不用去关心。

**下载Maven 3安装包**

官网：[http://maven.apache.org/download.cgi](http://maven.apache.org/download.cgi)

清华镜像：[https://mirrors.tuna.tsinghua.edu.cn/apache/maven/](https://mirrors.tuna.tsinghua.edu.cn/apache/maven/)

## 1.安装Maven
```bash
wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
tar zxvf apache-maven-3.9.9-bin.tar.gz
mv apache-maven-3.9.9 /usr/local/
ln  -s  /usr/local/apache-maven-3.9.9/  /usr/local/maven
/usr/local/maven/bin/mvn -v


3、编辑/etc/profile文件，在末尾添加
echo 'export  PATH=/usr/local/apache-maven-3.9.9/bin/:$PATH' >> /etc/profile
source /etc/profile
mvn ‐v	# 查看版本号


# 上传一个简单的java项目包hello‐world.tar.gz进行解压
git clone https://gitee.com/chengkanghua/helloworld.git


进入目录执行打包命令
validate（验证）:	验证项目正确，并且所有必要信息可用。
compile（编译）:  编译项目源码
test（测试）: 使用合适的单元测试框架测试编译后的源码。
package（打包）: 源码编译之后，使用合适的格式（例如JAR格式）对编译后的源码进行打包。
integration‐test（集成测试）: 如果有需要，把包处理并部署到可以运行集成测试的环境中去。
verify（验证）: 进行各种测试来验证包是否有效并且符合质量标准。
install（安装）: 把包安装到本地仓库，使该包可以作为其他本地项目的依赖。
deploy（部署）: 在集成或发布环境中完成，将最终软件包复制到远程存储库，以与其他开发人员和项目共享。
mvn clean (清除) : 清除上次编译的结果

cd  helloworld
mvn  package   #会去maven的中央仓库去下载需要的依赖包和插件到.m2目录下


# 认识maven安装目录
# ll /usr/local/maven/
total 36
drwxr-xr-x 2 root root    97 Sep  6 04:08 bin
drwxr-xr-x 2 root root    76 Sep  6 04:08 boot
drwxr-xr-x 3 root root    63 Aug 14 16:48 conf
drwxr-xr-x 4 root root  4096 Sep  6 04:08 lib
-rw-r--r-- 1 root root 18920 Aug 14 16:48 LICENSE
-rw-r--r-- 1 root root  5034 Aug 14 16:48 NOTICE
-rw-r--r-- 1 root root  1279 Aug 14 16:48 README.txt
bin:该目录包含了 mvn 运行的脚本，这些脚本用来配置 java 命令，准备好 classpath 和相关的 Java 系统属性，然后执行 Java 命令。其中 mvn 是基于 UNIX 平台的脚本，mvn.bat 是基于Windows 平台的脚本。
boot：该目录只包含一个文件，该文件是一个类加载器框架，Maven 使用该框架加载自己的类库。
conf：该目录包含了一个非常重要的文件 settings.xml。用于全局定义 Maven 的行为。也可以将该文件复制到~/.m2/目录下，在用户范围内定制 Maven 行为。
Lib：该目录包含了所有 Maven 运行时需要的 Java 类库。


本地仓库
maven 安装目录/usr/local/maven/conf/settings.xml 进行配置。
在 settings.xml 文件中，设置 localRepository 元素的值为想的仓库地址即可
<settings>
<localRepository>/opt/maven_repository</localRepository>
</settings>
通过我们建议修改.m2 目录下的 setting.xml 文件，修改只针对用户。




远程仓库
说到远程仓库先从最核心的中央仓库开始，中央仓库是默认的远程仓库，maven 在安装的时候，自带的就是中央仓库的配置，所有的 maven 项目都会继承超级 pom，具体的说，包含了下面配置的 pom 我们就称之为超级 pom
<repositories> 
 <repository> 
 <id>central</id> 
 <name>Central Repository</name> 
 <url>http://repo.maven.apache.org/maven2</url> 
 <layout>default</layout> 
 <snapshots> 
 <enabled>false</enabled> 
 </snapshots> 
 </repository> 
</repositories>

中央仓库包含了绝大多数流行的开源 Java 构件，以及源码、作者信息、SCM、信息、许可证信息等。一般来说，简单的 Java 项目依赖的构件都可以在这里下载得到。


```

      





## 2.创建Maven私服nexus
部署私服  nexus

下载

[https://help.sonatype.com/en/download-archives---repository-manager-3.html](https://help.sonatype.com/en/download-archives---repository-manager-3.html) 3.x 下载

[https://help.sonatype.com/en/download-nexus-2.html](https://help.sonatype.com/en/download-nexus-2.html)       2.x 下载



配置仓库两个选项

1、项目下的pom.xml配置、只生效当前的项目

2、在maven配置全局所有项目生效



上传JDK和nexus安装包

```bash
wget https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.rpm
rpm  ‐ivh  jdk‐8u121‐linux‐x64.rpm
java -version

# wget https://download.sonatype.com/nexus/3/nexus-3.50.0-01-unix.tar.gz 
# 国内下载 不动.
rz nexus-3.20.1-01-unix.tar.gz
tar zxvf nexus-3.20.1-01-unix.tar.gz

mv nexus-3.20.1-01 /usr/local/
ln -s /usr/local/nexus-3.20.1-01 /usr/local/nexus

/usr/local/nexus/bin/nexus start 10.0.0.3:8081	
# /usr/local/nexus/bin/nexus start 10.0.0.3:8081
WARNING: ************************************************************
WARNING: Detected execution as "root" user.  This is NOT recommended!
WARNING: ************************************************************
Starting nexus
--------------------------------------------------------------
# 上面启动成功后会警告不要使用 root 用户启动，这里可以新建一个用户，也可以指定root 用户启动，使他不出现警告，下面配置指定 root 用户启动,编辑 bin 目录下的nexus.rc 文件，修改内容为：run_as_user="root"
echo 'run_as_user="root"' > /usr/local/nexus/bin/nexus.rc
/usr/local/nexus/bin/nexus start 10.0.0.3:8081
/usr/local/nexus/bin/nexus status

# 添加到开机启动
echo '/usr/local/nexus/bin/nexus start 10.0.0.3:8081' >> /etc/rc.local
chmod +x /etc/rc.local


#浏览器打开  10.0.0.3:8081 #默认用户 admin  ,初始密码提示在这个文件中, 打开看
cat /usr/local/sonatype-work/nexus3/admin.password
ee7c1f4a-380e-456f-826c-0dae7a955d25
# 初次登录提示修改密码  admin123 


# 配置 Maven 项目使用 Nexus 仓库
# 在 maven 的 setting.xml 文件中配置私服配置，这种方式配置后所有本地使用该配置的 maven 项目的 pom 文件都无需配置私服下载相关配置
# 在<profiles></profiles>之间加入下面的配置
vi  /usr/local/maven/conf/settings.xml
<profile>
	 <id>my-nexus</id>
	<repositories>
		<!-- 私有库地址-->
		 <repository>
			 <id>nexus</id>
			 <name>nexus</name>
			 <url>http://10.0.0.3:8081/repository/maven-public/</url>
			 <snapshots>
				<enabled>true</enabled>
			 </snapshots>
			 <releases>
				<enabled>true</enabled>
			 </releases>
		 </repository>
	 </repositories>
	<pluginRepositories>
	<!--插件库地址-->
		 <pluginRepository>
		 <id>nexus</id>
		 <url>http://10.0.0.3:8081/repository/maven-public/</url>
		 <releases>
			<enabled>true</enabled>
		 </releases>
		 <snapshots>
			<enabled>true</enabled>
		 </snapshots>
		 </pluginRepository>
	 </pluginRepositories>
</profile>


# 在<settings></settings>之间加入下面的配置，激活使用上面的配置
<activeProfiles>
 <activeProfile>my-neuxs</activeProfile>
</activeProfiles>
# 注：profile 名字要对应

# 在<mirros></mirros>之间加入如下配置
<mirror>
 <id>nexus-myself</id>
 <!--*指的是访问任何仓库都使用我们的私服-->
 <mirrorOf>*</mirrorOf>
 <name>Nexus myself</name>
 <url>http://10.0.0.3:8081/repository/maven-public/</url>
</mirror>


# 配置完成后，当我们再次执行 mvn 命令时，下载构件的地址变为我们的私服地址
cd helloworld/
mvn clean



Maven 配置使用私服（发布依赖）
https://blog.csdn.net/qq_57581439/article/details/127769703
-----------------------------------
```





## 3.创建一个Maven项目
[**https://gitee.com/chengkanghua/helloworld.git**](https://gitee.com/chengkanghua/helloworld.git)

导入这个项目 

把java项目添加到gitlab仓库中



![1725554125914-6f39c6bd-e580-425d-8aa1-254472b23877.png](img/day74持续集成教程-61.png)







在 jenkins 配置 maven

打开系统管理—>全局工具配置页面，下拉新增一个 maven 配置。



![1547368344401-60a680f9-123e-4ac6-a5da-b75167069d9e-image44.png](img/day74持续集成教程-62.png)



回到 Jenkins 主页面，点击“新建 Item”进入创建 Job 页面，



![1547368344435-d00e5ad9-695b-46b0-8a0d-83d30461a65f-image45.jpeg](img/day74持续集成教程-63.jpeg)

通用部分配置“丢弃旧的构建”

![1725554501974-75e69cdf-bc93-4730-8737-ee4b40f6a4ed.png](img/day74持续集成教程-64.png)



源码管理配置  源码从gitlab上获取

![1725554647631-572227b3-c4c7-48b2-9b10-1a4726d1eb1c.png](img/day74持续集成教程-65.png)



配置要执行的 maven 命令，保存配置，返回 job 主页面，执行构建。



![1725554760642-7f8e9790-507d-436b-a531-0e3e2b180a9b.png](img/day74持续集成教程-66.png)







# 11 Jenkins Pipeline项目
CI/CD持续集成/持续部署

持续集成(Continuous  integration)是一种软件开发实践，即团队开发成员经常集成它们的工作，通过每个成员每天至少集成一次，也就意味着每天可能会发生多次集成。每次集成都通过自动化的构建（包括编译，发布，自动 化测试）来验证，从而尽早地发现集成错误。

比如（你家装修厨房，其中一项是铺地砖，边角地砖要切割大小。如果一次全切割完再铺上去，发现尺寸有误的话 浪费和返工时间就大了，不如切一块铺一块。这就是持续集成。）



持续部署（continuous  deployment）是通过自动化的构建、测试和部署循环来快速交付高质量的产品。某种程度上代表了一个开发团队工程化的程度，毕竟快速运转的互联网公司人力成本会高于机器，投资机器优化开发流程化   相对也提高了人的效率。

比如（装修厨房有很多部分，每个部分都有检测手段，如地砖铺完了要测试漏水与否，线路铺完了要通电测试电路 通顺，水管装好了也要测试冷水热水。如果全部装完了再测，出现问题可能会互相影响，比如电路不行可能要把地 砖给挖开……。那么每完成一部分就测试，这是持续部署。）



持续交付  Continuous  Delivery:频繁地将软件的新版本，交付给质量团队或者用户，以供评审尽早发现生产环境中存在的问题；如果评审通过，代码就进入生产阶段

比如（全部装修完了，你去验收，发现地砖颜色不合意，水池太小，灶台位置不对，返工吗？所以不如没完成一部 分，你就去用一下试用验收，这就是持续交付。）

敏捷思想中提出的这三个观点，还强调一件事：通过技术手段自动化这三个工作。加快交付速度。



## 1.什么是pipeline
Jenkins  2.0的精髓是Pipeline  as  Code，是帮助Jenkins实现CI到CD转变的重要角色。什么是Pipeline，简单来说，就是一套运行于Jenkins上的工作流框架，将原本独立运行于单个或者多个节点的任务连接起来，实现单个    任务难以完成的复杂发布流程。Pipeline的实现方式是一套Groovy DSL，任何发布流程都可以表述为一段Groovy 脚本，并且Jenkins支持从代码库直接读取脚本，从而实现了Pipeline as Code的理念。

## 2.Pipeline 概 念
Pipeline 是一个用户定义的 CD  流水线模式。Pipeline  代码定义了通常包含构建、测试和发布步骤的完整的构建过程。

Node

node 是一个机器，它是 Jenkins 环境的一部分，并且能够执行 Pipeline。同时，node 代码块也是脚本式

Pipeline 语法的关键特性。

Stage

Stage 块定义了在整个 Pipeline 中执行的概念上不同的任务子集（例如“构建”，“测试”和“部署”阶段），许多插件使用它来可视化或呈现 Jenkins 管道状态/进度。

Step

一项任务。从根本上讲，一个步骤告诉 Jenkins 在特定时间点（或过程中的“步骤”）要做什么。例如，使用

sh   step：sh  'make'  可以执行  make  这个  shell  命令。



## 3.jenkins file
声明式 脚本式

```bash
脚本式语法格式：
pipeline{
agent any 
stages{
	stage("get code"){ steps{
			echo  "get  code  from  scm"
		}
	}
	stage("package"){ 
  	steps{
			echo "packge code"
		}
	}
	stage("deploy"){ 
  		steps{
				echo "deploy packge to node1"
			}
	}
}
}

创建一个pipeline项目

```



![1547368344504-88052734-b73f-4487-8fcf-2205aacca0ed-image48.jpeg](img/day74持续集成教程-67.jpeg)

pipline 粘贴上面的脚本

![1547368344533-45ebdfa9-978b-4d08-9040-d1c0acb44be9-image49.jpeg](img/day74持续集成教程-68.jpeg)

保存立即构建

![1725594314568-a242ac73-6897-4c9e-af3a-aa49e32154a3.png](img/day74持续集成教程-69.png)







## 4 通过 scm 获取 Jenkinsfile
首先我们在 gitlab 上的 monitor 仓库的根目录下创建一个 Jenkins 文件，文件的内容为：

```bash
git clone git@10.0.0.2:oldboy/helloworld.git
cd helloworld/

cat > Jenkinsfile <<'EOF'
pipeline{
  agent any
  stages{
  	stage("get code"){ steps{
  			echo  "get  code  from  scm"
  		}
  	}
  	stage("package"){
    	steps{
  			echo "packge code"
  		}
  	}
  	stage("deploy"){
    		steps{
  				echo "deploy packge to node1"
  			}
  	}
  }
}
EOF

git add .
git commit -m "add jeninsfile"
git push


```

接着我们在 Jenkins 新建一个 pipeline job，命名为 pipeline-job01,前 2 步，同上一个示例一样，

在pipeline-job01 的配置页面，点击 Pipeline 选项卡，下拉到 pipeline 部分，选择从 scm 获取 pipeline script，



![1547368344611-1c05d14c-9ebc-41ed-bddb-e6a1bdbf05f9-image51.png](img/day74持续集成教程-70.png)

保存配置后，回到 Job 主页面，执行“立即构建”，在”console output”中，我们可以看到，首先从 gitlab 仓库获取了所有的代码文件，然后识别到 Jenkins 文件，执行文件中定义的构建任务。

![1725595337287-6b985a52-c794-464b-8d44-8a75b28ca398.png](img/day74持续集成教程-71.png)





## Pipeline 语法生成器
随着 Pipeline 一起发布的内建的文档，使得创建复杂的 Pipelines 更加容易。内建的文档可以根据安装在 Jenkins 实例中的插件，被自动生成和更新。

内建的文档可以通过链接被找到: localhost:8080/pipeline-syntax/。假设你已经有了一个正运行在本地 8080 端口上的实例。同样的文档可以连接到这里，通过任何项目的左边菜单”Pipeline Syntax”。



![1725596122300-3b3548c9-de64-45c1-a05c-bc4cc7699670.png](img/day74持续集成教程-72.png)

语法生成器是动态填充的，其中列出了可供 jenkins 使用的步骤，可用的步骤取决于安装的插件。



![1725596197943-1f696c1d-741b-4c3e-9d56-e9a25fefc228.png](img/day74持续集成教程-73.png)







## 使用 pipeline 实现 monitor 仓库代码的发布
1、在 Gitlab 在 monitor 仓库的根目录上添加 Jenkinsfile 文件，文件内容如下：



```bash
vim jenkinsfile

pipeline{
agent any 
stages{
	stage("get code"){ 
  	steps{
			echo "get code"
		}
	}
	stage("unit test"){ 
  	steps{
			echo "unit test"
		}
	}
	stage("package"){ 
  	steps{
			sh  'tar zcf /opt/web-${BUILD_ID}.tar.gz ./* --exclude=.git --exclude=Jenkinsfile'
		}
	}
	stage("deploy"){ 
  	steps{
			sh  'ssh 10.0.0.4  "mkdir -p  /usr/share/nginx/web-${BUILD_ID}"'
			sh  'scp /opt/web-${BUILD_ID}.tar.gz 10.0.0.4:/usr/share/nginx/web-${BUILD_ID}/'
			sh  'ssh 10.0.0.4  "cd /usr/share/nginx/web-${BUILD_ID}  && tar xf  web-${BUILD_ID}.tar.gz  &&  rm  -rf  web-${BUILD_ID}.tar.gz"'
			sh  'ssh 10.0.0.4  "rm -rf /usr/share/nginx/html && ln -s /usr/share/nginx/web-${BUILD_ID} /usr/share/nginx/html"'
				}
			}
	}
}

```

此 jenkinsfile 包括五个 stage，分为 replace file、test、package、deploy，对于非编译项目，我们一般包括这五个阶段。



2、在 jenkins 上创建一新的 Job，job 名称为 monitor-web，类型为 pipeline，

![1725596962765-d992c4b4-8b23-4068-b230-5434aa4dad2b.png](img/day74持续集成教程-74.png)



3、jenkins  配置 gitlab 自动触发构建（具体请参与前面部分相关内容）。

![1725597105656-4d41c7db-fa40-471e-99c7-0aa1c67ac94b.png](img/day74持续集成教程-75.png)



gitlab 仓库设置 集成 

![1725597207724-bae3736a-e955-47a7-8b9e-4eda5baa6b9d.png](img/day74持续集成教程-76.png)

测试一下

![1725597254831-a9d9937e-6f5b-43ed-af78-bfd5ec8f8eb7.png](img/day74持续集成教程-77.png)



4. 回到 jenkins 配置从 scm 获取 jenkinsfile

![1725597362156-ab204aa1-f04e-49cb-9345-6e927e3c26f9.png](img/day74持续集成教程-78.png)

5、保存配置，返回 job 主页面，执行构建。

![1725599006871-b75b4ad1-b11b-4ce0-b0a1-e0f9c08c914f.png](img/day74持续集成教程-79.png)



部署成功

![1725599051445-e63a735b-427e-47b0-90dd-3e7fcadd39c5.png](img/day74持续集成教程-80.png)

