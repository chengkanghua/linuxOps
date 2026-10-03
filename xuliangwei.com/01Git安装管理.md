# 01 Git安装管理

# 01 Git安装管理

* [1.1在Linux上安装](http://class.xuliangwei.com/15127996488866.html#toc_0)
* [1.2在Mac上安装](http://class.xuliangwei.com/15127996488866.html#toc_1)
* [1.3在Windows上安装](http://class.xuliangwei.com/15127996488866.html#toc_2)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

Git是分布式的版本控制系统，我们只要有了一个原始Git版本仓库，就可以让其他主机克隆走这个原始版本仓库，从而使得一个Git版本仓库可以被同时分布到不同的主机之上，并且每台主机的版本库都是一样的，没有主次之分，极大的保证了数据安全性，并使得用户能够自主选择向那个Git服务器推送文件了，其实部署一个git服务器是非常简单的。

## 1.1在Linux上安装

1.安装Git

```plain
[root@git-node1 ~]# yum install git -y
```

2.配置`git`全局用户以及邮箱

```plain
[root@git-node1 ~]# git config --global user.name "xuliangwei"  
[root@git-node1 ~]# git config --global user.email "xuliangwei@foxmail.com"  
[root@git-node1 ~]# git config --global color.ui true
```

3.检查`git`相关配置

```plain
[root@git-node1 ~]# git config --list
user.name=xuliangwei
user.email=xuliangwei@foxmail.com
color.ui=true
```

## 1.2在Mac上安装

在 Mac 上安装 Git，使用图形化 Git 安装工具，界面如图 1-3-1，

[Mac安装Git下载地址](http://sourceforge.net/projects/git-osx-installer/)

<!-- OCR_START -->
- 安装“git-2.7.1-intel-universal-mavericks"
- 安装成功。
- 介绍
- ?目的宗卷
- ·安装类型
- 安装
- 摘要
- 软件已安装。
- 返回
- 关闭
<!-- OCR_END -->

Mac下git客户端图形管理工具(也可用于windows)，界面如图 1-3-2，

[Mac图形化工具下载地址](https://www.sourcetreeapp.com/)

<!-- OCR_START -->
- sourcetree-website (Git)
- Commit
- Pull
- Push
- Branch Merge
- Shelve
- Show in Finder
- Terminal Settings
- WORKSPACE
- All Branches
- Show Remote BranchesAncestor Order
- Jump to:
- 2
- File status
- Graph
- Author
- Description
- Date
- History
- b7358c7
- Rahul Chha...
- DmasterDoriginmasterDoriginHEAD Removing ol.
- Mar3,2016,11:.
- bdb8bef
- Merged in update-google-verification (pull request #14)
- Feb 18, 2016, 1:3.
- Search
- dfe975d
- Tyler Tadej.
- originpate-gogeverifcatonUpdate google verificatFeb1,2016, 2:2.
- BRANCHES
- 3be3290
- Replace outdatedAtlassian logo infooter with base64 en
- Feb 11, 2016, 2:1.
- dba4719
- Add gitignore
- Feb 15, 2016, 10:.
- Feb 11, 2016, 1:3.
- f67b45
- Mike Minns
- Updated Mac min-spec to 10.10
- 72d32a8
- Michael Min._.
- Merged in hero_images (pull request #13)
- TAGS
- 246c4ff
- Joel Unger.
- Doriginhero_images heroimages Used Tinrypngto C
- Feb 11, 2016, 3:3...
- 9d9438c
- Replacing hero images with new version of SourceTree
- Feb 9, 2016, 2:59.
- REMOTES
- ce75b63
- Merged in bug/date-https (pull request #12)
- 85367bb
- Patrick Tho..
- originbug/ate-hpfoxeddateandhttps errors
- Jan 7, 2016, 12:2
- SHELVED
- 4f9b557
- New Favicon
- Feb 8, 2016, 3:55.
- 384e6d5
- Rahul Chhab.D originsearch-console-access search console google ver
- Feb 3, 2016, 2:09
- SUBREPOSITORIES
- 6fa47a9
- updated to move supported version to OSX 10.9+
- Dec 15, 2015, 2:0.
- 8dd87bb
- Milke Mins....
- remove extra , when a line is skipped due to empty server
- Nov 23, 2015, 2:2.
- faa195e
- Mike Mins...
- Skip records with empty server/user id as gas rejects them
- Nov 23, 2015, 2:1
- Ocdfe96
- corrected paths after merge
- Nov 23,2015, 2:0.
- 051ab1b
- corrected column counting
- Nov 23, 2015, 1:5.
- a723bc2
- Merge branch “au2gex*
- 65fd580
- deal with invalid instanceids
- 500a892
- Merged in au2gex (pull request #11)
- Nov 23, 2015, 1:0.
<!-- OCR_END -->

## 1.3在Windows上安装

在 Windows 上安装 Git，使用图形化 Git 安装工具，界面如图 1-3-3

[Git工具下载地址](https://git-for-windows.github.io/)

<!-- OCR_START -->
MINGW32:~/git
一回
welcome toGit （vers1on1.8.3-preview20130601)
Run'githelpgit'to displaythehelpindex.
Run'git help<command>'todisplay help for specific commands.
BaCon@BACON
gitclonehttps://github.com/msysgit/git.git
Cloninginto'git
remote:
Counting.objects:177468,
done.
remote:Compressing_objects:100%(52057/52057),done.
remote:Total 177468(delta 133396),reused 166093 (delta 123576)
Receiving objects:100%(177468/177468),42.16 MiB I1.84 MiB/s，done.
Resolving deltas:100%（133396/133396),done.
Checking out fi1es:100%(2576/2576),done.
scdgit
con@BAcoN~/git(master)
git status
Onbranch master
nothing to commit，
working directoryclean
Bacon@BACoN ~/git(master)
<!-- OCR_END -->

> 更新: 2019-03-21 09:18:55  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/atq75w>