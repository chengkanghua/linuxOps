# 06 GitLab运维

# 06 GitLab运维

* [1.Gitlab安装](http://class.xuliangwei.com/14976016283789.html#toc_0)
* [2.Gitlab邮件](http://class.xuliangwei.com/14976016283789.html#toc_1)
* [3.Gitlab备份](http://class.xuliangwei.com/14976016283789.html#toc_2)
* [4.Gitlab恢复](http://class.xuliangwei.com/14976016283789.html#toc_3)
* [5.Gitlab迁移](http://class.xuliangwei.com/14976016283789.html#toc_4)
* [6.Gitlab升级](http://class.xuliangwei.com/14976016283789.html#toc_5)
* [7.Gitlab更改默认Nginx](http://class.xuliangwei.com/14976016283789.html#toc_6)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

`Gitlab`是一个利用`Ruby on Rails`开发的开源应用程序，实现一个自托管的`Git`项目仓库，可通过`Web`界面进行访问公开的或者私人的项目`Gitlab`能够浏览源代码，管理缺陷和注释。

## 1.Gitlab安装

1.安装和配置必要的依赖关系

在CentOS7，下面的命令将在系统防火墙打开`HTTP`和`SSH`访问。

```plain
yum install -y curl openssh-server postfix
systemctl start sshd postfix
systemctl enable sshd postfix
//如果必须使用firewalld, 则开启http访问即可
firewall-cmd --permanent --add-service=http
systemctl reload firewalld
```

2.安装`Gitlab`

```plain
[root@gitlab-ce ~]# yum install https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-10.8.3-ce.0.el7.x86_64.rpm
```

3.`gitlab`汉化

```plain
[root@gitlab-ce ~]# yum install -y git
[root@gitlab-ce ~]# git clone https://gitlab.com/xhang/gitlab.git
[root@gitlab-ce ~]# /usr/bin/cp -r ./gitlab/* /opt/gitlab/embedded/service/gitlab-rails/
```

4.配置并启动, 启动后通过`http`方式访问服务器, 设定`root`密码即可

```plain
gitlab-ctl reconfigure
gitlab-ctl status
gitlab-ctl stop
gitlab-ctl start
```

## 2.Gitlab邮件

```plain
[root@gitlab-ce ~]# grep '^[a-Z]' /etc/gitlab/gitlab.rb
#gitlab访问url
external_url 'http://git.bgx.com'
## Email Settings
gitlab_rails['gitlab_email_enabled'] = true
# 启动smtp
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.qq.com"
gitlab_rails['smtp_port'] = 25
# 发件人邮箱
gitlab_rails['gitlab_email_from'] = "572891887@qq.com"
# 发件人显示名称
gitlab_rails['gitlab_email_display_name'] = 'GitLab-System'
# qq邮箱账户
gitlab_rails['smtp_user_name'] = "572891887@qq.com"
# qq邮箱密码(安全密码)
gitlab_rails['smtp_password'] = "rqoewdfrxnexbcjg"
gitlab_rails['smtp_domain'] = "smtp.qq.com"
gitlab_rails['smtp_authentication'] = :plain
gitlab_rails['smtp_enable_starttls_auto'] = true
```

## 3.Gitlab备份

使用`Gitlab`一键安装包安装`Gitlab`非常简单, 同样的备份恢复与迁移也非常简单. 使用一条命令即可创建完整的`Gitlab`备份:

```plain
[root@gitlab-ce ~]# gitlab-rake gitlab:backup:create
```

使用以上命令会在`/var/opt/gitlab/backups`目录下创建一个名称类似为`1481598919_gitlab_backup.tar`的压缩包, 这个压缩包就是`Gitlab`整个的完整部分, 其中开头的`1481598919`是备份创建的日期

`/etc/gitlab/gitlab.rb` 配置文件须备份

`/var/opt/gitlab/nginx/conf` nginx配置文件

`/etc/postfix/main.cfpostfix` 邮件配置备份

**Gitlab备份目录**

1.修改默认存放备份站点目录，然后进行重新加载配置文件

```plain
[root@gitlab-ce ~]# vim /etc/gitlab/gitlab.rb
...
gitlab_rails['backup_path'] = "/data/gitlab/backups"
...
[root@gitlab-ce ~]# gitlab-ctl reconfigure
```

3.手动备份

```plain
[root@gitlab-ce ~]# gitlab-rake gitlab:backup:create
```

4.自动备份

```plain
//实现每天凌晨2点进行一次自动备份:通过crontab使用备份命令实现
00 02 * * * /usr/bin/gitlab-rake gitlab:backup:create
```

## 4.Gitlab恢复

Gitlab的从备份恢复也非常简单:

```plain
# 停止相关数据连接服务
[root@gitlab-ce ~]# gitlab-ctl stop unicorn
[root@gitlab-ce ~]# gitlab-ctl stop sidekiq
# 从1528102291_2018_06_04_10.8.3编号备份中恢复
[root@gitlab-ce ~]# gitlab-rake gitlab:backup:restore BACKUP=1528102291_2018_06_04_10.8.3
# 启动Gitlab
[root@gitlab-ce ~]# gitlab-ctl start
```

## 5.Gitlab迁移

迁移如同备份与恢复的步骤一样, 只需要将老服务器`/var/opt/gitlab/backups`目录下的备份文件拷贝到新服务器上的`/var/opt/gitlab/backups`即可(如果你没修改过默认备份目录的话). 

但是需要注意的是新服务器上的`Gitlab`的版本必须与创建备份时的`Gitlab`版本号相同. 比如新服务器安装的是最新的`10.8.3`版本的`Gitlab`那么迁移之前, 最好将老服务器的`Gitlab`升级为`10.8.3`，基于最新版本的状态在进行备份.

`/etc/gitlab/gitlab.rb` gitlab配置文件须迁移,迁移后需要调整数据存放目录

`/var/opt/gitlab/nginx/conf` nginx配置文件目录须迁移

```plain
//将旧机器上的备份文件同步过来后的操作步骤
[root@linux-node1 ~]# gitlab-ctl stop unicorn
ok: down: unicorn: 0s, normally up
[root@linux-node1 ~]# gitlab-ctl stop sidekiq
ok: down: sidekiq: 0s, normally up
[root@linux-node1 ~]# chmod 777 /var/opt/gitlab/backups/1528102291_2018_06_04_10.8.3_gitlab_backup.tar
[root@linux-node1 ~]# gitlab-rake gitlab:backup:restore BACKUP=1528102291_2018_06_04_10.8.3
```

## 6.Gitlab升级

1.关闭`gitlab`服务

```plain
[root@gitlab-ce ~]# gitlab-ctl stop unicorn
[root@gitlab-ce ~]# gitlab-ctl stop sidekiq
[root@gitlab-ce ~]# gitlab-ctl stop nginx
```

2.备份`gitlab`

```plain
[root@gitlab-ce ~]# gitlab-rake gitlab:backup:create
```

3.下载`gitlab`的`RPM`包并进行升级

```plain
//直接安装高版本
[root@gitlab-ce ~]# yum install gitlab-ce-8.12.13-ce.0.el7.x86_64
//报错.
Error executing action `run` on resource 'ruby_block[directory resource: /var/opt/gitlab/git-data/repositories]'
//解决方法:
[root@gitlab-ce ~]# chmod 2770 /var/opt/gitlab/git-data/repositories
```

4.启动并查看`gitlab`版本信息

```plain
[root@gitlab-ce ~]# gitlab-ctl reconfigure
[root@gitlab-ce ~]# gitlab-ctl restart
[root@gitlab-ce ~]# head -1 /opt/gitlab/version-manifest.txt
gitlab-ce 10.8.3
```

## 7.Gitlab更改默认Nginx

更换`gitlab`自带`Nginx`, 使用自行安装的`Nginx`来管理`gitlab`服务。

1.编辑`gitlab`配置文件禁用自带`Nignx`服务器

```plain
vi /etc/gitlab/gitlab.rb
...
#设置nginx为false,关闭自带Nginx
nginx['enable'] = false
...
```

检查默认nginx配置文件，并迁移至新Nginx服务

```plain
/var/opt/gitlab/nginx/conf/nginx.conf          #nginx配置文件,包含gitlab-http.conf文件
/var/opt/gitlab/nginx/conf/gitlab-http.conf    #gitlab核心nginx配置文件
```

重启`nginx、gitlab`服务

```plain
[root@gitlab-ce ~]# gitlab-ctl reconfigure
[root@gitlab-ce ~]# systemctl start nginx
```

访问报502。原因是`nginx`用户无法访问`gitlab`用户的`socket`文件。 

重启gitlab需要重新授权

```plain
chmod -R o+x /var/opt/gitlab/gitlab-rails
```

> 更新: 2019-03-21 09:23:55  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/dvw9z2>