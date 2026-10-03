# 05 Git标签管理

# 05 Git标签管理

* [1.1创建本地标签](http://class.xuliangwei.com/15128038225593.html#toc_0)
* [1.2查看本地标签](http://class.xuliangwei.com/15128038225593.html#toc_1)
* [1.3删除本地标签](http://class.xuliangwei.com/15128038225593.html#toc_2)
* [1.4推送本地标签](http://class.xuliangwei.com/15128038225593.html#toc_3)
* [1.5获取远程标签](http://class.xuliangwei.com/15128038225593.html#toc_4)
* [1.6删除远程标签](http://class.xuliangwei.com/15128038225593.html#toc_5)
* [1.7Git标签小结](http://class.xuliangwei.com/15128038225593.html#toc_6)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

当版本仓库内的数据有个大的改善或者功能更新，我们经常会打一个类似于软件版本号的标签，这样通过标签就可以将版本库中的某个历史版本给记录下来，方便我们随时将特定历史时期的数据取出来用，另外打标签其实只是像某个历史版本做了一个指针，所以一般都是瞬间完成的。

## 1.1创建本地标签

创建带有说明的标签,-a指定标签名字，-m指定说明文字

```plain
[root@git-node1 demo]# git tag -a v1.0.0 -m "version 1.0.0 release"
```

## 1.2查看本地标签

1.查看当前本地所有标签

```plain
[root@git-node1 demo]# git tag -l v*
v1.0.0
v1.0.1
```

2.查看当前1.0版本的详细信息

```plain
[root@git-node1 demo]# git show v1.0.0
tag v1.0.0
Tagger: xuliangwei <xuliangwei@foxmail.com>
Date:   Sun Nov 6 03:12:44 2016 +0800
 
version 1.0.0 release
 
commit 95734131860ef7c9078b8a208ff6437d0952380b
Author: xuliangwei <xuliangwei@foxmail.com>
Date:   Sun Nov 6 02:15:35 2016 +0800
 
    chnged name index.html->index.php
 
diff --git a/index.html b/index.html
deleted file mode 100644
index e69de29..0000000
diff --git a/index.php b/index.php
new file mode 100644
index 0000000..e69de29
```

## 1.3删除本地标签

我们为同一个提交版本设置了两次标签,删除重复性的标签

```plain
[root@git-node1 demo]# git tag -d v1.0.1
已删除 tag 'v1.0.1'（曾为 3c13e43）
[root@git-node1 demo]# git tag -l v*
v1.0.0
```

## 1.4推送本地标签

如上操作都是基于打标签以及删除标签，下面我们来学习下打完标签后如何推送至远端服务器

也可以使用`git push origin –-tags`推送所有本地建立的tag包

```plain
[root@git-node1 demo]# git push origin v1.0.0
Counting objects: 1, done.
Writing objects: 100% (1/1), 167 bytes | 0 bytes/s, done.
Total 1 (delta 0), reused 0 (delta 0)
To git@git-node1:root/git_demo.git
 * [new tag]         v1.0.0 -> v1.0.0
```

## 1.5获取远程标签

使用`git pull`获取最新tag包，可以使用`git fetch`强制获取

```plain
[root@git-node1 git_demo]# git pull origin v1.0.0s
remote: Counting objects: 1, done.
remote: Total 1 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (1/1), done.
来自 git-node1:root/git_demo
 * [新tag]           v1.0.0     -> v1.0.0
Already up-to-date.
```

## 1.6删除远程标签

通过`push delete`参数来删除远程标签

```plain
[root@git-node1 git_demo]# git push origin --delete tag v1.0.0
To git@git-node1:root/git_demo.git
 - [deleted]         v1.0.0
```

也可以先删除本地tag标签,然后推送空标签至于远程进行删除

```plain
[root@git-node1 git_demo]# git tag v1.0.1
[root@git-node1 git_demo]# git push origin v1.0.1
Total 0 (delta 0), reused 0 (delta 0)
To git@git-node1:root/git_demo.git
 * [new tag]         v1.0.1 -> v1.0.1
 
//删除本地tag
[root@git-node1 git_demo]# git tag -d v1.0.1
已删除 tag 'v1.0.1'（曾为 9573413）
 
//推送空tag至远程进行删除
[root@git-node1 git_demo]# git push origin :refs/tags/v1.0.1
To git@git-node1:root/git_demo.git
 - [deleted]         v1.0.1
```

## 1.7Git标签小结

git版本号规则

内部版本 B1.1.0 

外部版本 V1.1.0

补丁版本 P1.1.0

```plain
命令git tag –a <tagname> -m "message"      //在当前commit状态新建一个tag
命令git tag -l <tagname>   //列出相对应版本号tag
命令git push origin <tagname>      //推送一个本地标签
命令git push origin --tags //推送全部未推送过的本地标签
命令git tag -d <tagname>   //删除一个本地标签
命令git push origin --delete tag <tagname>        //删除一个远程标签
命令git push origin :refs/tags/<tagname>   //删除一个远程标签
```

> 更新: 2019-03-21 09:22:47  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/yq2i4n>