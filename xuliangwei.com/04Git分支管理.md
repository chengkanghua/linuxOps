# 04 Git分支管理

# 04 Git分支管理
+ [1.1创建本地分支](http://class.xuliangwei.com/15128004273760.html#toc_0)
+ [1.2切换本地分支](http://class.xuliangwei.com/15128004273760.html#toc_1)
+ [1.3合并本地分支](http://class.xuliangwei.com/15128004273760.html#toc_2)
+ [1.4删除本地分支](http://class.xuliangwei.com/15128004273760.html#toc_3)
+ [1.5查看远程分支](http://class.xuliangwei.com/15128004273760.html#toc_4)
+ [1.6解决分支冲突](http://class.xuliangwei.com/15128004273760.html#toc_5)
+ [1.7删除远程分支](http://class.xuliangwei.com/15128004273760.html#toc_6)
+ [1.8Git分支小结](http://class.xuliangwei.com/15128004273760.html#toc_7)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208
>

分支即是平行空间，假设你在为某个手机系统研发拍照功能，代码已经完成了80%，但如果将这不完整的代码直接提交到git仓库中，又有可能影响到其他人的工作，此时我们便可以在该软件的项目之上创建一个名叫“拍照功能”的分支，这种分支只会属于你自己，而其他人看不到，等代码编写完成后再与原来的项目主分支合并下即可，这样即能保证代码不丢失，又不影响其他人的工作。

![1553131337795-b3d19324-5184-454a-9980-f71a8db734dc.jpeg](img/04Git分支管理/image1.jpeg)

说明: Git团队合作流程图

一般在实际的项目开发中，我们要尽量保证master分支是非常稳定的，仅用于发布新版本，平时不要随便直接修改里面的数据文件，而工作的时候则可以新建不同的工作分支，等到工作完成后在合并到master分支上面，所以团队的合作分支看起来会像上面图那样。

<!-- OCR_START -->
- 项目建立
- 上网功
- 电话动
- 信动
- 特航功能
<!-- OCR_END -->

说明: Git分支示意图

生产代码提交方式

### 1.1创建本地分支
首先创建本地dev分支

```plain
[root@git-node1 demo]# git branch dev
[root@git-node1 demo]# git branch  //查看本地分支
  dev
* master
```

### 1.2切换本地分支
切换分支至刚建立dev分支

```plain
[root@git-node1 demo]# git checkout dev
切换到分支 'dev'
[root@git-node1 demo]# git branch
* dev
  master
```

切换分支发生冲突会导致无法切换对应分支，可使用-f强制切换

```plain
[root@git-node1 demo]# git checkout -f master
切换到分支 'master'
[root@git-node1 demo]# git branch
  dev
* master
```

### 1.3合并本地分支
现在，我们想把linux的工作成果合并到master分支上了，则可以使用”git merge”命令来将指定的的分支与当前分支合并

git合并分之示意图

1.切换到dev分支

```plain
[root@git-node1 demo]# git checkout dev
切换到分支 'dev'
```

2.添加内容至index.html，并提交

```plain
[root@git-node1 demo]# echo "Create new branch dev" >> index.html
[root@git-node1 demo]# git add index.html
[root@git-node1 demo]# git commit -m "new branch dev"
[dev 1bf25ef] new branch dev
 1 file changed, 1 insertion(+)
 create mode 100644 index.html
```

3.切回master分支，合并dev分支

```plain
[root@git-node1 demo]# git checkout master
切换到分支 'master'
[root@git-node1 demo]# git merge dev  //master合并dev分支内容
更新 9573413..ead1936
Fast-forward
 index.html | 1 +
1 files changed, 1 insertion(+)
 create mode 100644 index.html
```

### 1.4删除本地分支
合并完成dev分支后，可以放心的删除。

```plain
[root@git-node1 demo]# git branch -d dev
已删除分支 dev（曾为 ead1936）。
[root@git-node1 demo]# git branch
* master
```

### 1.5查看远程分支
查看远程分支

```plain
[root@git-node1 demo]# git branch -a
* master
  remotes/origin/master
```

### 1.6解决分支冲突
但是Git并不能每次都为我们自动的合并分支，当遇到了内容冲突比较复杂的情况，则必须手工将差异内容处理点，比如这样的情况：

git分支冲突示意图

1.创建linux分支并切换到linux分支

```plain
[root@git-node1 demo]# git checkout -b linux
切换到一个新分支 'linux'
```

2．添加1行内容，并推送到远程仓库

```plain
[root@git-node1 demo]# echo "1.branch linux" > readme.txt
[root@git-node1 demo]# git add readme.txt
[root@git-node1 demo]# git commit -m "touch readme.txt"
[linux 4580c3b] touch readme.txt
 1 file changed, 1 insertion(+)
 create mode 100644 readme.txt
[root@git-node1 demo]# git push origin linux //推送到远程仓库,创建并关联远程dev分支
Counting objects: 4, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 294 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
remote:
remote: Create merge request for linux:
remote:   http://git-node1/root/git_demo/merge_requests/new?merge_request%5Bsource_branch%5D=linux
remote:
To git@git-node1:root/git_demo.git
 * [new branch]      linux -> linux
```

3.切换至master分支，添加readme.txt文件，并和linux分支相同位置，然后尝试合并

```plain
[root@git-node1 demo]# echo "1.branch master" > readme.txt
[root@git-node1 demo]# git merge linux
自动合并 readme.txt
冲突（添加/添加）：合并冲突于 readme.txt
自动合并失败，修正冲突然后提交修正的结果。
[root@git-node1 demo]# vim readme.txt  //我们需要手动删除<<<，=======，>>>>
<<<<<<< HEAD
1.branch master
=======
1.branch linux
>>>>>>> linux
```

4.从新提交并添加至远程分支仓库

```plain
[root@git-node1 demo]# git commit -m "merge branch linux readme.txt"
[master 5f3f588] merge branch linux readme.txt
[root@git-node1 demo]# git push origin master
Counting objects: 7, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 339 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@git-node1:root/git_demo.git
   4c7a145..5f3f588  master -> master
```

### 1.7删除远程分支
删除如上已经被合并过的linux分支。

```plain
[root@git-node1 demo]# git push origin --delete linux
To git@git-node1:root/git_demo.git
 - [deleted]         linux
```

或者push推送一个空的分支到远程test分支进行删除

```plain
[root@git-node1 demo]# git push origin :test
To git@git-node1:root/git_demo.git
 - [deleted]         dev
```

### 1.8Git分支小结
Git鼓励大量使用分支，常见分支结构

dev分支

bug分支

新功能分支

```plain
命令 git branch //列出所有本地分支
命令git branch –r  //列出所有远程分支
命令git branch –a  //列出所有本地分支和远程分支
命令git branch [branch-name]  //创建新分支
命令git checkout –b [branch-name] //创建新分支，并且切换到该分支
命令 git branch  --track [branch] [remote-branch]   //创建新分支，与指定的远程分支建立追踪关系
命令 git checkout [branch-name]      //切换至指定分支
命令 git branch –set-upstream [branch] [remote-branch] //本地分支与远程分支建立追踪关系
命令 git merge [branch] //合并指定分支到当前分支
命令 git cherry-pick [commit] //选择一个commit，合并至当前分支
命令git branch –d [branch-name]  //删除本地分支
命令git push origin --delete [branch-name]  //删除远程分支
命令git branch –dr [remote/branch]   //删除远程分支
```

> 更新: 2019-03-21 09:22:25  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/gmawr5>