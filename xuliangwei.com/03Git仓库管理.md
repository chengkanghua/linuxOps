# 03 Git仓库管理

# 03 Git仓库管理
+ [1.1部署开源仓库](http://class.xuliangwei.com/15128001294437.html#toc_0)
+ [1.2添加远程仓库](http://class.xuliangwei.com/15128001294437.html#toc_1)
+ [1.3修改远程仓库](http://class.xuliangwei.com/15128001294437.html#toc_2)
+ [1.4查看远程仓库](http://class.xuliangwei.com/15128001294437.html#toc_3)
+ [1.5推送远程仓库](http://class.xuliangwei.com/15128001294437.html#toc_4)
+ [1.6克隆远程仓库](http://class.xuliangwei.com/15128001294437.html#toc_5)
+ [1.7拉取远程仓库](http://class.xuliangwei.com/15128001294437.html#toc_6)
+ [1.8更改远程仓库](http://class.xuliangwei.com/15128001294437.html#toc_7)
+ [1.9移除远程仓库](http://class.xuliangwei.com/15128001294437.html#toc_8)
+ [1.10Git远程仓库小结](http://class.xuliangwei.com/15128001294437.html#toc_9)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208
>

现在本地已经创建了git仓库，又在gitlab上创建了一个git仓库，并且让这两个仓库进行远程同步，这样gitlab仓库既可以备份也可以与他人协作管理远程仓库以及根据需要推送或拉取数据。

管理远程仓库包括了如何添加远程仓库、移除无用远程仓库、查看远程仓库、修改远程仓库等等。

## 1.1部署开源仓库
GitLab 是一个用于仓库管理系统的开源项目。

1.安装配置gitlab依赖项

如想使用Postfix来发送邮件,在安装期间请选择'Internet Site'. 您也可以用sendmai或者 配置SMTP服务并使用SMTP发送邮件.在 Centos7系统上, 下面的命令将在系统防火墙里面开放HTTP和SSH端口.

```plain
[root@git-node1 ~]# yum install curl openssh-server postfix
[root@git-node1 ~]# systemctl enable sshd postfix
[root@git-node1 ~]# systemctl start sshd postfix
[root@git-node1 ~]# firewall-cmd --permanent --add-service=http
[root@git-node1 ~]# systemctl reload firewalld
```

2.添加GitLab仓库,并安装到服务器

```plain
[root@git-node1 ~]# curl -sS http://packages.gitlab.cc/install/gitlab-ce/script.rpm.sh | sudo bash
[root@git-node1 ~]# yum install gitlab-ce
```

3.启动GitLab

```plain
gitlab-ctl reconfigure
```

1. 浏览到主机名和登录Browse to the hostname and login 首次访问GitLab,系统会让你重新设置管理员的密码,设置成功后会返回登录界面. 默认的管理员账号是root,如果你想更改默认管理员账号,请输入上面设置的新密码登录系统后修改帐号名.

5.创建key

```plain
[root@git-node1 ~]# ssh-keygen //一路回车即可
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
8e:5f:ce:ea:32:d4:14:3e:7c:e0:10:8c:1a:6b:cf:7c root@git-node1
The key's randomart image is:
+--[ RSA 2048]----+
|     o..|
|  . . o o|
|   +   = o       |
|  +     * .      |
| . +   oSo       |
|    + Eo.|
|     o. . .|
|      o. +|
|       ++.o|
+-----------------+
```

6.复制id_rsa.pub公钥

```plain
[root@git-node1 ~]# cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCq0Y39J2ZNjk2DG55o2ok9f2NgvM75MapmOcN0PLwb6vjPVZczHKYE968D9E1hLaH7y4IaW6pp6KSebBL/fg3bEHGvaaWfdgfQ2ccI8V045cn5WnkS81VxeHd8F9Tnz9xvAAZhXUc6HaArllXtn/pX5EGn1I/UUdTnQdQPNyWjBnPq04x8vtQvQn1C2KKyaxdwWzY+dmmfbveBqwY4+A/5rZV+qdUblN0SVxYgdgXzzg51bNKJr8mRaKgSUIdZylVFLlg9vnGL1VRxvINxxd51FNV+O51bUEbjVEr0LNlhcHqGUli4bIJ09ZuWs8p3PJtmQc9YIKyPIjSZD7ih9DX9 root@git-node1
```

7.添加公钥至gitlab，如图1-6-1

<!-- OCR_START -->
- C192.16656.11/ro/
- Pofle Seinps
- SSHKeyn
- hadtiep
- SSHKeys
- Addin say
- tehrrpos
- aadtaS5h1iry
- Siprout
- GaLab.
- Kry
- EHwgodwst2a//t
- rtigtoodkt
- Yor H k ()
<!-- OCR_END -->

图1-6-1添加服务器公钥

## 1.2添加远程仓库
1.gitlab创建仓库，进行远程同步，如图1-6-2

<!-- OCR_START -->
- 192.16856.11/
- 1
- Projects
- F+
- New project
- vepeet path
- Druteor
- hep2/772.168.3671
<!-- OCR_END -->

图1-6-2gitlab创建远程仓库

2.使用git remote 添加远程仓库地址,选择SSH方式克隆。

```plain
[root@git-node1 ~]# cd demo/  //必须是git init 初始化仓库目录
[root@git-node1 demo]# git remote add origin git@git-node1:root/git_demo.gitxxx
```

## 1.3修改远程仓库
由于刚开始添加的远程仓库写错了url,现在通过如下命令进行url修改

```plain
[root@git-node1 demo]# git remote set-url origin git@git-node1:root/git_demo.git
```

## 1.4查看远程仓库
如果已经配置了远程仓库服务器，可以运行 git remote命令。它会列出你指定每一个远程服务器的简写。

```plain
[root@git-node1 demo]# git remote
origin
```

也可以指定-v选项，会显示需要读写远程仓库git保存简写名称以及对应的URL地址。

```plain
[root@git-node1 demo]# git remote -v
origin      git@git-node1:root/git_demo.git (fetch)
origin      git@git-node1:root/git_demo.git (push)
```

## 1.5推送远程仓库
将本地库更新内容推送至远程，用git push命令，实际上是将当前分支推送至远程仓库。

由于远程库是新建立空的，我们在第一次推送时候，git默认是不会把本地master关联至远端的master，所以我们需要加上-u参数，这样git不但会把本地的master分支内容推送至远程仓库的master分支，并且还会将本地的master分支和远程master分支关联起来。在以后推送或者拉取时就可以简化命令。

```plain
[root@git-node1 demo]# git push -u origin master
Counting objects: 5, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (5/5), 432 bytes | 0 bytes/s, done.
Total 5 (delta 0), reused 0 (delta 0)
To git@git-node1:root/git_demo.git
 * [new branch]      master -> master
分支 master 设置为跟踪来自 origin 的远程分支 master。
```

如果推送冲突可以选择--force强行推送

```plain
[root@git-node1 xuliangwei]# git push origin --force
如果一次都没有推送数据,可以选择—all一次全部推送至远程服务器
[root@git-node1 xuliangwei]# git push origin --all
```

## 1.6克隆远程仓库
如果现在仓库已经有开发好的项目，需要加入进来开发，可以先clone整个项目。

```plain
[root@git-node1 tmp]# git clone git@git-node1:root/git_demo.git
正克隆到 'git_demo'...
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 5 (delta 0), reused 0 (delta 0)
接收对象中: 100% (5/5), done.
```

## 1.7拉取远程仓库
简单的说,这个命令会访问远程仓库，从中取出你还没有的数据，或者git pull之后还是没有的数据。

此前在添加的远程仓库的时候指定了仓库名origin，命令会自动将其添加为远程仓库并默认以origin为简写。

所以，git fetch origin相当于从远程获取最新版本到本地，然后比较本地master分支和远程master分支差别最后进行合并。

```plain
[root@git-node1 demo]# git fetch origin //拉取主分支最新版本(可以拉取其他分支)
[root@git-node1 demo]# git fetch origin dev //获取dev分支最新数据
```

拉取数据，在生产环境中见到比较多的还是git pull相当于是从远程获取最新版本并merge到本地

```plain
[root@git-node1 xuliangwei]# git pull origin master #拉取主分支最新版本(可以拉取其他分支)
[root@git-node1 xuliangwei]# git pull origin dev  //获取dev分支最新数据
```

上述命令其实相当于git fetch 和 git merge在实际使用中，git fetch更安全一些，因为在merge前，我们可以查看更新情况，然后再决定是否合并

## 1.8更改远程仓库
如果想重新命名一个远程仓库名称。将test重命名为rainbow,可以通过git remote rename进行修改。

注意：这同时会修改你的远程分支名字。之前引用test/master的现在会引用rainbow/master

1.添加新远程分支，并赋予test为远程仓库名称

```plain
[root@git-node1 git_demo]# git remote add test git@git-node1:root/git_demo.git
[root@git-node1 git_demo]# git remote -v
origin      git@git-node1:root/git_demo.git (fetch)
origin      git@git-node1:root/git_demo.git (push)
test        git@git-node1:root/git_demo.git (fetch)
test        git@git-node1:root/git_demo.git (push)
```

2.修改test名称为rainbow名称

```plain
[root@git-node1 git_demo]# git remote rename test rainbow
[root@git-node1 git_demo]# git remote -v
origin      git@git-node1:root/git_demo.git (fetch)
origin      git@git-node1:root/git_demo.git (push)
rainbow     git@git-node1:root/git_demo.git (fetch)
rainbow     git@git-node1:root/git_demo.git (push)
```

## 1.9移除远程仓库
因为一些变动不再使用一些特定的镜像，可以通过git remote remove 远程仓库名称，移除远程仓库

1.查看远程仓库

```plain
[root@git-node1 git_demo]# git remote -v
origin      git@git-node1:root/git_demo.git (fetch)
origin      git@git-node1:root/git_demo.git (push)
rainbow     git@git-node1:root/git_demo.git (fetch)
rainbow     git@git-node1:root/git_demo.git (push)
```

2.移除不再使用的rainbow远程仓库

```plain
[root@git-node1 git_demo]# git remote remove rainbow
[root@git-node1 git_demo]# git remote -v
origin      git@git-node1:root/git_demo.git (fetch)
origin      git@git-node1:root/git_demo.git (push)
```

## 1.10Git远程仓库小结
要添加一个仓库，首先必须知道仓库的地址，然后使用git remote add 命令添加远程仓库，也可使用git clone命令克隆。（Git支持多种协议，包括http、https，但通过ssh支持的原生git协议速度最佳。）

要关联一个远程库，使用命令git remote add origin git@server-name:path/repo-name.git，关联后，使用命令git push -u origin master第一次推送master分支的所有内容，此后，每次本地提交后，只要有必要，就可以使用命令git push origin master推送最新修改

```plain
# git remote add [remote] [url]#添加(关联)远程库
# git remote  set-url  [remote] [url] #修改远程仓库
# git clone [url] #克隆远程仓库项目
# git remote #查看指定远程仓库命名简写
# git remote –v #查看远程仓库详细信息以及名称对应URL
# git push -u remote master #第一次推送master分支的所有内容
# git fetch remote [branch/tag] #下载远程仓库的所有变动
# git pull remote [branch/tag] #拉取主分支最新版本(可以拉取其他分支)
# git push remote [branch/tag] --force #强行推送当前分支至远程分支,及时冲突
# git push remote [branch/tag] --all #推送所有分支到远程仓库
# git remote rename [oldname] [newname] #修改远程仓库名称
# git remote remove [name] #删除远程仓库名称以及URL地址
```

> 更新: 2019-03-21 09:22:00  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/dqg73g>