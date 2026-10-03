# 玩转Git

# 课程综述

## 版本管理的演变

vcs 出现之前

* 用目录拷贝区别不同版本
* 公共文件容易被覆盖
* 成员沟通成本很高，代码集成效率低下

集中式vcs

* 有集中的版本管理服务器
* 具备文件版本管理和分支管理能力
* 集成效率有明显地提高
* 客户端必须时刻和服务器相连

分布式 VCS

* 服务器和客户端都有完整的版本库
* 脱离服务端，客户端照样可以管理版本
* 查看历史和版本比较等多数操作，都不需要访问服务器，比集中式 VCS更能提高版本管理效率

## git的特点

* 最优的存储能力
* 非凡的性能
* 开源的
* 很容易做备份
* 支持离线操作
* 很容易定制工作流程

## 课程内容

* git
* github
* gitlab

# 第一章 Git基础

## 02 安装Git

检查安装结果

git --version

## 03 最小配置

配置user信息

git config --global user.name 'you_name'

git config --global user.email 'you_email@domain.com'

config 的三个作用域

* git config --local    # local只对仓库有
* git config --global  # global 对登录用户所有仓库有效
* git config --system # system 对系统的所有用户有效

显示 config 的配置， 加 --list

* git config --list --local
* git config --list --global
* git config --list --system

设置与清除

设置，缺省等同于 local

* git config  --local
* git config --global
* git config --system

清除， --unset

* git config --unset --local user.name
* git config --unset --global user.name
* git config --unset --system user.name

优先级

local  > global > system

课后实践

```bash
请动⼿⽐⼀⽐，local 和 global 的优先级。
1. 在 Git 命令⾏⽅式下，⽤ init 创建⼀个 Git 仓库。
 $ git init your_first_git_repo_name
2. cd 到 repo 中。
 $ cd your_first_git_repo_name
3. 配置 global 和 local 两个级别的 user.name 和 user.email。
 $ git config --local user.name 'your_local_name'
 $ git config --local user.email 'your_local_email@.'
 $ git config --global user.name 'your_global_name'
 $ git config --global user.name 'your_global_eamil@.'  
4. 创建空的 commit
 $ git commit --allow-empty -m ‘Initial’
5. ⽤ log 看 commit 信息，Author 的 name 和 email 是什么？
 $ git log
```

## 05通过几次commit来认识工作区和暂存区

建Git仓库

两种方式：

1. 用Git之前已经有项目代码

```bash
cd 项目代码文件夹
git init
```

2. 用Git之前还没有项目代码

```bash
cd 某个文件夹
git init you_project #会在当前路径下创建和项目名称同名的文件夹
cd your_project
```

往仓库添加文件

4次提交，一个有模有样的静态页面生成了

1. 加入index.html和 git-logo
2. 加入 style.css
3. 加入 scripts.js
4. 修改 index.html 和 style.css

【工作目录】-- git add files-------> 【暂存区】  --git commit -----> 【版本历史】

课后实践

* 1 模仿视频的步骤，建立一个简单的静态站点
* 2 熟悉 add  commit  mv log  gitk 命令

```plain
git status  # 显示暂存区文件和未被git 管理的文件情况
git add index.html images # 将多个文件提交到暂存区
git add -u #把所有文件提交到暂存区
git commit -m'Add index'  # 正式提交到历史库
git log   #查看历史
```

## 06给文件重命名的简便方法

```plain
# 按之前学习的操作
mv readme readme.md
git add readme.md
git rm readme

# 简便方法
git mv readme readme.md
git commit -m"Move readme to readme.md"
```

## 08 通过git log 查看版本演变历史

```plain
git log --oneline
git log --oneline --all
git log -n1 --oneline  #-n1 最近的1条记录
git log --all  #所有分支历史都有
git log --all --graph  #图形化显示
git log --oneline --all -n4 --graph

git branch -av         #查看所有分支列表
git checkout -b temp  #切换到新分支上了
git checkout master   #切换到master分支上
git commit -am'add'

git log --help
```

## 09 探密 git 目录

```plain
```

## 10 commit 、tree 和blob 三个对象之间的关系

Git 对象彼此关系

commit --》 tree ---》 blob

## 11 数一数tree的个数

新建的Git仓库， 有且仅有1个commit，仅仅包含/doc/readme ,请问内含多少个tree，多少个blob？

commit   	----》   tree 		 -----》 tree 	  -----》 blob

tree	tree doc  blob readme		Hello，world

parent

atuthor

## 12分离指针情况下的注意事项

```bash
[root@aliyun git-test]# git log
commit 84c8b6c7532db83e31b044fb51c7811bb24b5694
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Fri Jan 10 18:20:36 2020 +0800

    add index.

commit 749b6c7de83ee665d49ce51053df5c5e9bb64153
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Thu Jan 9 19:20:05 2020 +0800

    Initial'
[root@aliyun git-test]# git checkout 84c8b6c753
Note: checking out '84c8b6c753'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD 目前位于 84c8b6c... add index.
[root@aliyun git-test]# vi index.html
[root@aliyun git-test]# git status
# 头指针分离于 84c8b6c
# 尚未暂存以备提交的变更：
#   （使用 "git add <file>..." 更新要提交的内容）
#   （使用 "git checkout -- <file>..." 丢弃工作区的改动）
#
#	修改：      index.html
#
修改尚未加入提交（使用 "git add" 和/或 "git commit -a"）
[root@aliyun git-test]# git commit -am'index-test'  #文件修改后一次提交到仓库
[分离头指针 131d743] index-test
 1 file changed, 1 insertion(+)
[root@aliyun git-test]# git branch -av
* （分离自 84c8b6c） 131d743 index-test
  master             84c8b6c add index.
  temp               0399168 add
[root@aliyun git-test]# git checkout master
警告：您正丢下 1 个提交，未和任何分支关联：
  131d743 index-test
如果您想要通过创建新分支保存他们，这可能是一个好时候。
如下操作：
 git branch new_branch_name 131d743
切换到分支 'master'
[root@aliyun git-test]# git branch index-test 131d743
```

## 13 进一步理解HEAD 和branch

```bash
[root@aliyun git-test]# git checkout -b index2-test index-test #基于index-test创建新分支index2-test
切换到一个新分支 'index2-test'
[root@aliyun git-test]# git log -n1  #head指向了新分支

[root@aliyun git-test]# git diff 131d7438a4 84c8b6c753
[root@aliyun git-test]# git diff HEAD HEAD^   # HEAD^  head的父亲 等于HEAD~1
```

# 第二章 独自使用Git 时的常见场景

## 14 怎么删除不需要的分支

```bash
[root@aliyun git-test]# git branch -av
  index-test  131d743 index-test
* index2-test 131d743 index-test
  master      84c8b6c add index.
  temp        0399168 add
[root@aliyun git-test]# git branch -d index2-test
error: 无法删除您当前所在的分支 'index2-test'。
[root@aliyun git-test]#
[root@aliyun git-test]# git checkout index-test
切换到分支 'index-test'
[root@aliyun git-test]# git branch -d index2-test
已删除分支 index2-test（曾为 131d743）。
[root@aliyun git-test]# git branch -D index2-test
```

## 15怎么修改最新commit 的 message？

```plain
[root@aliyun git-test]# git branch -av
  index-test 131d743 index-test
* master     84c8b6c add index.
  temp       0399168 add
[root@aliyun git-test]# git commit --amend   #修改commit的message
[root@aliyun git-test]# git log --oneline
```

## 16 怎么修改老旧的commit的message

```plain
[root@aliyun git-test]# git log
commit f3e167d142a7af0b6b7a29afad7183ffdc568c01
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Fri Jan 10 18:20:36 2020 +0800

    add index,oem.png

commit 749b6c7de83ee665d49ce51053df5c5e9bb64153
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Thu Jan 9 19:20:05 2020 +0800

    Initial'
[root@aliyun git-test]# git rebase -i 749b6c7de8  #选择父commit id
r f3e167d add index,oem.png,end   #r是修改commit的messages

# Rebase 749b6c7..f3e167d onto 749b6c7
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell


[分离头指针 5276a25] add index,oem.png,end
 2 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 images/oem.png
 create mode 100644 index.html
Successfully rebased and updated refs/heads/master.
```

## 17怎么样把连续的多个commit 整理成1个？

```bash
[root@aliyun git-test]# git log
commit 4ef4fb4c872a42297b064a65be61a458ffbd1804
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Tue Jan 14 18:19:02 2020 +0800
    add 3.log
commit 7154dfa59ebf590dfadc041fd52558fffa6d9442
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Tue Jan 14 18:18:38 2020 +0800
    add 2.log
commit da90fe04ce478e491376b8ff68246ab04470783d
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Tue Jan 14 18:18:16 2020 +0800
    add .log
commit 5276a25f5ef79527f355991db0a6534c9e0a08be
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Fri Jan 10 18:20:36 2020 +0800
    add index,oem.png,end
commit 749b6c7de83ee665d49ce51053df5c5e9bb64153
Author: chengkanghua <chengkanghua@foxmail.com>
Date:   Thu Jan 9 19:20:05 2020 +0800
    Initial'
[root@aliyun git-test]# git rebase -i 749b6c7de83e
pick 5276a25 add index,oem.png,end
pick da90fe0 add .log
s 7154dfa add 2.log
s 4ef4fb4 add 3.log
:wq 保存之后
# This is a combination of 3 commits.
Create a complete *.log   #增加的messages
# The first commit's message is:
add .log
# This is the 2nd commit message:
add 2.log
# This is the 3rd commit message:
add 3.log
:wq 保存
[分离头指针 47f28e3] Create a complete *.log add .log add 2.log add 3.log
 3 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 index.log
 create mode 100644 index2.log
 create mode 100644 index3.log
Successfully rebased and updated refs/heads/master.
[root@aliyun git-test]# git log --oneline
47f28e3 Create a complete *.log add .log add 2.log add 3.log
5276a25 add index,oem.png,end
749b6c7 Initial'
```

## 18怎么样把间隔的几个commit整理成1个？

```bash

[root@aliyun git-test]# git log --graph
* commit d95040cb4c302ca8fce8e6bac9eea2f1bbd45d37    
| Author: chengkanghua <chengkanghua@foxmail.com>
| Date:   Tue Jan 14 18:35:03 2020 +0800
|
|     add **
|
* commit 9e9edc7dab1e75024e28b19055d6a7a32901c661
| Author: chengkanghua <chengkanghua@foxmail.com>
| Date:   Tue Jan 14 18:34:32 2020 +0800
|
|     add"
|
* commit 92ed2eb5a5be0853bc128bf35f6343a6e1d30c95
| Author: chengkanghua <chengkanghua@foxmail.com>
| Date:   Tue Jan 14 18:34:00 2020 +0800
|
|     rm .log
|
* commit 47f28e3e2be782fb3ea00f100437b9dcd22831ae
| Author: chengkanghua <chengkanghua@foxmail.com>
| Date:   Tue Jan 14 18:18:16 2020 +0800
|
|     Create a complete *.log   **
|     add .log
|     add 2.log
|     add 3.log
|
* commit 5276a25f5ef79527f355991db0a6534c9e0a08be
| Author: chengkanghua <chengkanghua@foxmail.com>
| Date:   Fri Jan 10 18:20:36 2020 +0800
|
|     add index,oem.png,end
|
* commit 749b6c7de83ee665d49ce51053df5c5e9bb64153
  Author: chengkanghua <chengkanghua@foxmail.com>
  Date:   Thu Jan 9 19:20:05 2020 +0800

      Initial'
[root@aliyun git-test]# git rebase -i 749b6c7d
------------------------------------------------------------------------
pick 749b6c7   # 手动添加最早的commit id
s 5276a25 add index,oem.png,end  #合并间隔的
pick 47f28e3 Create a complete *.log add .log add 2.log add 3.log
pick 92ed2eb rm .log
pick 9e9edc7 add"    //删除要合并的行
pick d95040c add     //删除要合并的行

# Rebase 749b6c7..d95040c onto 749b6c7
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
-------------------------------------------------------------------------
:wq 保存之后
".git/rebase-merge/git-rebase-todo" 24L, 775C written
之前的拣选操作现在是一个空提交，可能是由冲突解决导致的。如果您无论如何
也要提交，使用命令：

    git commit --allow-empty

否则，请使用命令 'git reset'
# 头指针分离于 749b6c7
# 您正在将分支 'master' 变基到 '749b6c7'。
#   （所有冲突已解决：运行 "git rebase --continue"）
#
无文件要提交，干净的工作区
Could not apply 749b6c7...
[root@aliyun git-test]# git rebase --continue
-----------------------------------------------------------------
# This is a combination of 2 commits.
add readme.md   //新添加的
# The first commit's message is:

Initial'

# This is the 2nd commit message:

add index,oem.png,end
#
# 似乎您正在做一个拣选提交。如果不对，请删除文件
#       .git/CHERRY_PICK_HEAD
# 然后重试。


# 请为您的变更输入提交说明。以 '#' 开始的行将被忽略，而一个空的提交
# 说明将会终止提交。
# 头指针分离于 749b6c7
# 您正在将分支 'master' 变基到 '749b6c7'。
#   （所有冲突已解决：运行 "git rebase --continue"）
#
# 要提交的变更：
#
#       新文件：    images/oem.png
#       新文件：    index.html
---------------------------------------------------------------------------
:wq
[分离头指针 013f92b] add readme.md
 2 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 images/oem.png
 create mode 100644 index.html
Successfully rebased and updated refs/heads/master.
[root@aliyun git-test]# git log --graph
* commit da959b3a70120f7f9489142f65da66da4e3f07d5
| Author: chengkanghua <chengkanghua@foxmail.com>
| Date:   Tue Jan 14 18:34:00 2020 +0800
|
|     rm .log
|
* commit 4cf89ad03c37fc01970ba7a9ed49fdcbc7589ca0
| Author: chengkanghua <chengkanghua@foxmail.com>
| Date:   Tue Jan 14 18:18:16 2020 +0800
|
|     Create a complete *.log
|     add .log
|     add 2.log
|     add 3.log
|
* commit 013f92b10887778393f97fe77dbe965186c037f4
| Author: chengkanghua <chengkanghua@foxmail.com>
| Date:   Thu Jan 9 19:20:05 2020 +0800
|
|     add readme.md
|
|     Initial'
|
|     add index,oem.png,end
|
* commit 749b6c7de83ee665d49ce51053df5c5e9bb64153
  Author: chengkanghua <chengkanghua@foxmail.com>
  Date:   Thu Jan 9 19:20:05 2020 +0800

      Initial'
```

## 19 怎么比较暂存区和HEAD所含文件的差异？

```bash

[root@aliyun git-test]# git add index.html
[root@aliyun git-test]# git diff --cached  # 暂存区和当前head的区别
diff --git a/index.html b/index.html
index e69de29..409dd11 100644
--- a/index.html
+++ b/index.html
@@ -0,0 +1,4 @@
+<html>
+<h1> hahaha </h1>
+<h2> bbbb  </h2>
+</html>
# 对比文件后确认没问题了再提交到历史仓库
[root@aliyun git-test]# git commit -m'add'
```

## 20 怎么比较工作区和暂存区所含文件差异？

```plain
[root@aliyun git-test]# git diff  #查看工作区与暂存区的差异
diff --git a/index.html b/index.html
index 409dd11..f97a08d 100644
--- a/index.html
+++ b/index.html
@@ -1,4 +1,5 @@
 <html>
 <h1> hahaha </h1>
 <h2> bbbb  </h2>
+<li>bare registry</li>
 </html>
diff --git a/main.php b/main.php
index 3b18e51..1d9ac26 100644
--- a/main.php
+++ b/main.php
@@ -1 +1,2 @@
 hello world
+aaa
```

## 22 如何让工作区的文件恢复为和暂存区一样?

```bash
#将暂存区的index.html内容恢复到工作区
[root@aliyun git-test]# git checkout -- index.html
# 所有文件都恢复成暂存区
[root@aliyun git-test]# git checkout -- .
```

## 23 怎样取消暂存区部分文件的更改?

```bash
[root@aliyun git-test]# git status
# 位于分支 master
# 要提交的变更：
#   （使用 "git reset HEAD <file>..." 撤出暂存区）
#
#	新文件：    images/logo.png
#	修改：      index.html
#	新文件：    main.php
#
[root@aliyun git-test]# git reset HEAD -- index.html #将head的index.html恢复到暂存区
重置后撤出暂存区的变更：
M	index.html
[root@aliyun git-test]# git status
# 位于分支 master
# 要提交的变更：
#   （使用 "git reset HEAD <file>..." 撤出暂存区）
#
#	新文件：    images/logo.png
#	新文件：    main.php
#
# 尚未暂存以备提交的变更：
#   （使用 "git add <file>..." 更新要提交的内容）
#   （使用 "git checkout -- <file>..." 丢弃工作区的改动）
#
#	修改：      index.html
```

## 24消除最近的几次提交

```plain
[root@aliyun git-test]# git log --oneline
6103e3f add1
44d2741 add
da959b3 rm .log
4cf89ad Create a complete *.log add .log add 2.log add 3.log
013f92b add readme.md
749b6c7 Initial'
[root@aliyun git-test]# git reset --hard da959b3   #将工作区和暂存区恢复到da959b3版本
HEAD 现在位于 da959b3 rm .log
```

## 25 看看不同提交的指定文件的差异

```bash
[root@aliyun git-test]# git branch -av
  index-test 131d743 index-test
* master     da959b3 rm .log
  temp       0399168 add
  temp1      6103e3f add1
[root@aliyun git-test]# git diff temp master  #不同分支的文件比对
diff --git a/test.log b/test.log
deleted file mode 100644
index e69de29..0000000
diff --git a/ttt b/ttt
deleted file mode 100644
index e69de29..0000000
[root@aliyun git-test]# git diff temp master -- index.html  #指定文件的
[root@aliyun git-test]# git diff 0399168 da959b3 -- index.html
```

## 26 正确删除文件的方法

```plain
# 以后commit 不需要的文件就使用 git rm 删除掉
[root@aliyun git-test]# git rm main.php
rm 'main.php'
[root@aliyun git-test]# git status
# 位于分支 master
# 要提交的变更：
#   （使用 "git reset HEAD <file>..." 撤出暂存区）
#
#	删除：      main.php
#
```

## 27 开发中临时加塞了紧急任务怎么处理?

```bash
[root@aliyun git-test]# git diff  #工作区做过修改

[root@aliyun git-test]# git stash  #临时把修改的文件存放一边,不提交到历史仓库
Saved working directory and index state WIP on master: 5e0c753 add
HEAD 现在位于 5e0c753 add
[root@aliyun git-test]# git stash list
stash@{0}: WIP on master: 5e0c753 add
[root@aliyun git-test]# git status
# 位于分支 master
无文件要提交，干净的工作区
# 这个时候就可以去做临时任务了
[root@aliyun git-test]# git stash apply  #恢复之前存放的文件内容放在工作区.
[root@aliyun git-test]# git stash list  #列表信息还存在,可以反复使用.
stash@{0}: WIP on master: 5e0c753 add
[root@aliyun git-test]# git stash pop
error: Your local changes to the following files would be overwritten by merge:
	index.html
Please, commit your changes or stash them before you can merge.
Aborting
[root@aliyun git-test]# git reset --hard HEAD
HEAD 现在位于 5e0c753 add
[root@aliyun git-test]# git status
# 位于分支 master
无文件要提交，干净的工作区
[root@aliyun git-test]# git stash pop  #pop会丢掉 stash list 列表信息
```

## 28 如何指定不需要Gti管理的文件?

```bash
github在创建仓库时候 有一个gitignore 选项,
C.gitignore
# Precrequisites
*.d
*.exyd/
-------------------------------------------------
java.gitignore
*.class
*.log
*.tar
.war


[root@aliyun git-test]# git status
# 位于分支 master
# 未跟踪的文件:
#   （使用 "git add <file>..." 以包含要提交的内容）
#
#	.gitignore
提交为空，但是存在尚未跟踪的文件（使用 "git add" 建立跟踪）
[root@aliyun git-test]# cat .gitignore   #文件名必须是这个
doc   //表示git不管doc文件和doc文件夹
doc/  //表示git不管doc文件夹
[root@aliyun git-test]# echo 'hi'>doc
[root@aliyun git-test]# git status
# 位于分支 master
# 未跟踪的文件:
#   （使用 "git add <file>..." 以包含要提交的内容）
#
#	.gitignore
提交为空，但是存在尚未跟踪的文件（使用 "git add" 建立跟踪）
```

## 29如何将Git仓库备份到本地?

Git 的备份

| 常用协议 | 语法格式 | 说明 |
| --- | --- | --- |
| 本地协议1 | /path/to/repo.git | 哑协议 |
| 本地协议2 | file:///path/to/repo.git | 智能协议 |
| http/https 协议 | http://git-server.com:port/path/to/repo.git或者https开头 | 平时接触到的都是智能协议 |
| ssh协议 | <user@git-server.com><br/>:path/to/repo.git | 工作最常用的智能协议 |

哑协议与智能协议

* 直观区别: 哑协议传输进度不可见;智能协议传输可见
* 传输速度:智能协议比哑协议传输速度快.

备份特点

```bash
project-A.git s1  <-–--—push-–--— project-A/.git
project-A.git s1  -–--—fetch-–--—> project-A/.git

project-A.git s2  <-–-–—push-–-–— project-A/.git
project-A.git s2  -–-–—fetch-–-–—> project-A/.git

project-A.git s3  <-–-–—push-–-–— project-A/.git
project-A.git s3  -–-–—fetch-–-–—> project-A/.git
```

```bash
# 克隆远端仓库本地 名称改成one
[root@aliyun 666-backup]# git clone https://github.com/atom/github.git one

[root@aliyun 666-backup]# git init
重新初始化现存的 Git 版本库于 /home/ckh/666-backup/.git/
[root@aliyun 666-backup]# git remote -v
[root@aliyun 666-backup]# git remote add mybook https://github.com/chengkanghua/mybook.git
[root@aliyun 666-backup]# git remote -v
mybook	https://github.com/chengkanghua/mybook.git (fetch)
mybook	https://github.com/chengkanghua/mybook.git (push)
[root@aliyun 666-backup]# echo log >index.html
[root@aliyun 666-backup]# git push mybook
```

# 第三章 Git与Github的简单同步

## 30 注册一个GitHub账号

## 31 配置公私钥

<https://help.github.com/cn/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account>

## 32 在Github上创建个人仓库

## 33  把本地仓库同步到GitHub

```bash
$ # git remote remove github #删除远程仓库推送地址
$ git pull github master
$ git branch -av
* master                c3f20e4 Initial commit
  remotes/github/master c3f20e4 Initial commit

$ git branch -av
* master                a7cffcb add
  remotes/github/master c3f20e4 Initial commit

--------------------------------------------------------------
$ git init  #本地已有的仓库 有文件

# 添加远程仓库地址
$ git remote add github git@github.com:chengkanghua/test.git
$ git remote -v
github  git@github.com:chengkanghua/test.git (fetch)   拉取
github  git@github.com:chengkanghua/test.git (push)	   推送
$ git push github --all  # --all 本地所有分支都想远端push
To github.com:chengkanghua/test.git
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'git@github.com:chengkanghua/test.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
$ git fetch github master   #只是把远端文件拉下来，不做合并
warning: no common commits
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
From github.com:chengkanghua/test
 * branch            master     -> FETCH_HEAD
 * [new branch]      master     -> github/master
$ git branch -va   #不是基于远端的基础做的变更是不让push的
* master                2a02f80 add
  remotes/github/master cb7de8c Initial commit
$ git merge github/master
fatal: refusing to merge unrelated histories    #拒绝合并不相关的历史记录分支
$ git merge --allow-unrelated-histories github/master  #合并不相关的历史记录分支
$ git push github master
```

# 第四章 Git多人单分支集成协作时的常见场景

## 34 不同人修改了不同文件如何处理？

```bash
# 在github上新建分支feature/add_git_commands  模拟两个人操作
[root@vulcan ~]# git clone git@github.com:chengkanghua/test.git test02
[root@vulcan test]# git config --add --local user.name 'ckh2020'
[root@vulcan test]# git config --add --local user.email 'ckh2020@qq.com'
[root@vulcan test]# git config --local -l
[root@vulcan test]# git branch -av
# 基于远端分支创建一个分支并且切换到这个分支上
[root@vulcan test]# git checkout -b feature/add_git_commands origin/feature/add_git_commands
[root@vulcan test]# git branch -v
* feature/add_git_commands d37975f Merge remote-tracking branch 'github/master'
  master                   d37975f Merge remote-tracking branch 'github/master'
[root@vulcan test]# echo 'w are going to record some git command' >> index.html
[root@vulcan test]# git add index.html
[root@vulcan test]# git status
[root@vulcan test]# git commit -m'modified-index.html'
[root@vulcan test]# git push

# 另一个开发操作，新增的远端分支没有同步下来。
$ git branch -av
* master                d37975f Merge remote-tracking branch 'github/master'
  remotes/github/master d37975f Merge remote-tracking branch 'github/master'
$ git fetch github
$ git branch -av
$ git checkout -b feature/add_git_commands github/feature/add_git_commands
$ git branch -v
* feature/add_git_commands 721dcbf modified-index.html
  master                   d37975f Merge remote-tracking branch 'github/master'
$ echo 'git bash' >> index.html
$ git add -u
$ git commit -m'gitbash> index.html'

# 另一个开发也在修改
[root@vulcan test]# echo 'add remote' > readme.md
[root@vulcan test]# git commit -am'add readme'
[root@vulcan test]# git add .
[root@vulcan test]# git commit -m "add readme.md"
[root@vulcan test]# git push

#在回到test02 用户操作
$ git push
To github.com:chengkanghua/test.git
 ! [rejected]        feature/add_git_commands -> feature/add_git_commands (fetch first)
error: failed to push some refs to 'git@github.com:chengkanghua/test.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
# 报错 本地和远端不是fast-forwards
$ git fetch github
$ git branch -av
* feature/add_git_commands                29c8dd3 [ahead 1, behind 1] gitbash> index.html
  master                                  d37975f Merge remote-tracking branch 'github/master'
  remotes/github/feature/add_git_commands 543be3d add readme.md
  remotes/github/master                   d37975f Merge remote-tracking branch 'github/master'
$ git merge github/feature/add_git_commands
$ git push
```

## 35 不同人修改了同文件的不同区域如何处理？

```bash
git pull  #把远端文件下载下来并且本地分支做更新

# 报错 本地和远端不是fast-forwards   操作方法和上一节一样
$ git fetch github
$ git merge github/feature/add_git_commands
$ git push
```

\##　36 不同人修改了同文件的同一个区域如何处理？

```bash
$ echo 'mv log' >> index.html
$ git add .
$ git commit -m'modifies index.html'
$ git push
[root@vulcan test]# echo 'mv if else fi'>> index.html
[root@vulcan test]# git add .
[root@vulcan test]# git commit -m'modify index.html'
[feature/add_git_commands cbe02ae] modify index.html
 1 file changed, 1 insertion(+)
[root@vulcan test]# git push
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
[root@vulcan test]# git pull
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 1), reused 3 (delta 1), pack-reused 0
Unpacking objects: 100% (3/3), done.
From github.com:chengkanghua/test
   267d00d..481b94e  feature/add_git_commands -> origin/feature/add_git_commands
Auto-merging index.html
CONFLICT (content): Merge conflict in index.html  #内容冲突。
Automatic merge failed; fix conflicts and then commit the result.

[root@vulcan test]# cat index.html
<head>test </head>
w are going to record some git command
git bash
<<<<<<< HEAD

mv if else fi
=======
mv log
>>>>>>> 481b94e538816ab4cb5e43081ff7aedb66f88203
[root@vulcan test]# vi index.html   #修改成需要的样子。
[root@vulcan test]# cat index.html
<head>test </head>
w are going to record some git command
git bash
mv if else fi
mv log
[root@vulcan test]# git commit -am 'resolved conflict by hand with 4 git commands'
[root@vulcan test]# git status
[root@vulcan test]# git push
```

## 37 同时变更了文件名和文件内容如何处理？

```bash

# 更改了文件名之后，另一个用户
push 时候报错  note about fast-forwards
git pull 会自动蹦出合并提示 :wq 就可以了
```

## 38  把同一文件改成了不同的文件名如何处理？

```bash
# a开发和b开发都分别修改 index.html 为index1.html 和 index2.html
# a开发修改并且push成功
# b修改在push 提示 note about fast-forwards
# git pull   #这个时候git会报冲突，需要和另一个开发协商
# git status
# git rm index2.html index.html
# git add index1.html
# git commit -m'modify index.html->index1.html'
# git push
```

# 第五章： Git集成使用禁忌

\##　39　禁止向集成分支执行push-f　操作

```bash
git push -f  #--force 强制push 即使不是 fast-forwards
```

## 40 禁止向集成分支执行变更历史的操作

```bash
只有在现有的情况再往上增加commit的方式来让着个代码看起来更好。
```

# 第六章 初始GitHub

## 41 GitHub为什么这么火？

**Git 诞生之前**

程序员之间进行变成协作的方式很少

即使有SVN，与开源团队合作通常也需要获得项目管理员的许可才能 fork 项目的一个分支，否则便无法编辑代码

* 许多情况下，批准过程比编写代码花费的时间更长
* 许多开源项目都受到权限问题以及其他一些低效率事情的困扰

**Git诞生之后**

当Git 于2005年发布时,开源领域正在经历一场文艺复兴

那时的开发者对Linux充满浓烈的兴趣

第一个Web 2.0 应用程序已经开始出现

许多公司正在将他们的项目迁移到开源服务器

尽管Git 通过引入 fork 概念使得开源项目的合作变得容易,但Git依然有局限

* 它无法帮助开发人员寻找开源项目
* 许多程序员开发了大量优秀开源项目,但却很难让他人知道这些项目.

**GitHub诞生了**

* 创建一个可以托管整个代码的地方
* 程序员可以协同工作
* 了解如何充分利用Git

`我使用 GitHub免费托管我公司的代码,我对此感到有些不好意思。我可以发一张支票 给你们吗?”- PeepCode的创始人 Geoffrey Rosenbach`

**GitHub的十年**

2007-2011  代码协作与软件社交

* 有100万用户超过200万个存储库

2012-2015 从快速增长到无处不在

* 有280万用户 有460万个存储库

2015年-2018年9月 GitHub全球扩张

* 有3千万用户 有9千万个存储库

**GitHub 成功的因素**

找到了一个需要解决的大问题

* 让git更容易使用时GitHub的目标,但这并不是最终目标.
* GitHub 真正的愿景是使协作和编写软件更容易

不断解决用户痛点

* 公司不仅致力于解决疑难问题,而且还致力于解决所有软件开发人员遇到的痛苦问题.
* 开发者需要一个更好,更直观的版本控制系统,它具有解决人类问题的巨大潜力,即轻松,安全和远程协作软件项目.

## 42GitHub都有哪些核心功能？

<https://github.com/features>

## 43怎么快速淘到感兴趣的开源项目

```latex
搜索
git 最好 学习 资料 in:readme    //搜索readme.md的内容

git 最好 学习 资料 in:readme stars:>1000

'after_script:'+'stage:deploy' filename:.gitlab-ci.yml   //搜索代码里面的
blog easily start in:readme stars:>5000
```

## 44 怎样在GitHub上搭建个人博客

```plain
https://github.com/barryclark/jekyll-now
```

## 45 开源项目怎么保证代码质量？

```plain
pull requests
```

## 46 为何需要组织类型的仓库？

```plain
```

# 第七章：使用GitHub进行团队协作

## 47 创建团队的项目

```plain
```

## 48 怎样选择适合自己团队的工作流?

需要考虑的因素

* 团队人员的组成
* 研发设计能力
* 输出产品的特征
* 项目难易程度

**主干开发**

\----> c1 ------> c2 ------> c3 -------> c4   <----- master  <------HEAD

* 适用于:  开发团队系统设计和开发能力强. 有一套有效的特切换的实施机制, 保证上线后无需修改代码就能够修改系统行为.需要快速迭代, 想获得CI/CD 所有好处.
* 适用于: 组件开发的团队,成员能力强, 人员少,沟通顺畅. 用户升级组件成本低的环境.

**Git Flow**

* 适用于: 不具备主干开发能力. 有预定的发布周期. 需要执行严格的发布流程.

**GitHub Flow**

* 适用于: 不具备主干开发. 随时集成随时发布: 分支集成时经过代码评审和自动化测试, 就可以立即发布的应用.

**GitLab Flow (带生产分支)**

* 适用于: 不具备主干开发能力. 无法控制准确的发布时间, 但又要求不停地集成

**GitLab Flow (带环境分支)**

* 适用于: 不具备主干开发能力. 需要逐个通过各个测试环境的验证才能发布.

**GitLab Flow (带发布分支)**

* 适用于: 不具备主干开发能力. 需要对外发布和维护不同版本.

## 49 如何挑选合适的分支集成策略?

```plain
```

## 50 启用issue跟踪需求和任务

```plain
```

## 53 团队协作时如何做分支的集成?

```plain
```

## 54 怎样保证集成的质量?

```plain
```

## 55只有把产品发布到GitHub上?

```plain
```

## 56 怎么给项目增加详细的指导文档?

```plain
```

# 第八章 GitLab 实践

## 57 国内互联网企业为什么喜欢GitLab?

## 58 GitLab 哪些核心的功能?

<https://about.gitlab.com/devops-tools/>

## 59 GitLab上怎么做项目管理?

<https://gitlab.com/gitlab-org/gitlab/issues>

## 60 GitLab上怎么做code review?

## 61 GitLab上怎么保证集成的质量?

## 62怎么把应用部署到AWS 上?

# git过滤文件

使用git提交，有时需要忽略不必要的文件或文件夹，可以采用以下方式：

```plain
1.首先在仓库中创建隐藏文件“.gitignore”
方法：选中本地仓库，右击“Git Bash Here”,然后执行如下命令：
touch .gitignore
2.用文本编辑器如editplus或notepad++输入需要忽略的文件或文件名，如下所示：
##ignore this file##
/target/ ：过滤文件设置，表示过滤这个文件夹
*.mdb  ，*.ldb  ，*.sln 表示过滤某种类型的文件
/mtk/do.c ，/mtk/if.h  表示指定过滤某个文件下具体文件
 !*.c , !/dir/subdir/     !开头表示不过滤
 *.[oa]    支持通配符：过滤repo中所有以.o或者.a为扩展名的文件
 
.*.jpg
.*.png
.*.svg
.*.psd
.*.ai
.*.bmp
```


> 更新: 2020-06-15 11:09:42  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/fpbx9s>