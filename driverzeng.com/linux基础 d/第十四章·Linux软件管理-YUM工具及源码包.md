# 第十四章·Linux软件管理-YUM工具及源码包

## YUM基本概述

| 什么是yum |
| :--- |

`yum`是RedHat以及CentOS中的软件包管理器，能够通过互联网下载以rpm结尾的包，并且安装，并可以自动处理依赖性关系，无需繁琐的一次次下载安装。

1.联网获取软件

2.基于RPM管理

3.自动解决依赖

4.命令简单好记

5.生产最佳实践

| 什么是yum源 |
| :--- |

要成功的使用yum工具安装更新软件或系统，就需要有一个包含各种rpm软件包的repository（软件仓库），这个软件仓库我们习惯称之为`yum源`或者`yum 仓库`这个源可以是本地的也可以是网络的。

## YUM源的配置

| BASE源 |
| :--- |

```bash
#因为CentOS默认是国外的源，有时候安装速度会很慢，所以我们更换国内源
#CentOS 6
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
#或者
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
#CentOS 7
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#或者
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

各大镜像源：

阿里云：<https://opsx.alibaba.com/mirror>

清华源：<https://mirrors.tuna.tsinghua.edu.cn/>

163源：<http://mirrors.163.com/>

华为源：<https://mirrors.huaweicloud.com/>

科大源：<http://mirrors.ustc.edu.cn/>

| EPEL源 |
| :--- |

```bash
#下载epel源之前，查看base中的所有软件包
[root@db04 ~]# yum repolist
epel(RHEL 7)
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
epel(RHEL 6)
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
```

***

| 安装其他源 |
| :--- |

例如：nginx

打开浏览器访问：nginx的官网 [点击此处](http://nginx.org/)

找到最新版本，点击后，网站最下方`Pre-Built Packages`中找到repo仓库

```bash
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
```

例如：zabbix

打开浏览器访问：zabbix的官网 [点击此处](https://www.zabbix.com/)

查看官方文档`Documentation`在`Installation`中点击`Installation from packages`选择`Red Hat Enterprise Linux/CentOS`下载zabbix官方源

```bash
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
```

例如：saltstack

打开浏览器访问：saltstack的官网 [点击此处](https://www.saltstack.com/)

```bash
yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm
```

## YUM实践案例

***

| 使用yum查询软件包的方式 |
| :--- |

```bash
#列出软件仓库中可用的软件
[root@zls ~]# yum list
#进行模糊查找
[root@zls ~]# yum list|grep ftp
#列出软件包详情
[root@zls ~]# yum info ftp
```

***

| 使用yum安装软件包的方式 |
| :--- |

```bash
#安装软件只需要给出软件名称（前提是在仓库中必须有）
[root@zls ~]# yum install traceroute
#安装过程中分析依赖关系后, 直接安装, 无需交互
[root@zls ~]# yum install php -y
#安装本地的rpm包, 如果有依赖关系, 会自动从软件仓库中下载所需依赖（非来自.repo定义的软件仓库）
[root@zls ~]# yum localinstall /mnt/Packages/bind-9.9.4-50.el7.x86_64.rpm
#安装网络上rpm包
[root@zls ~]# yum install http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
```

***

| 使用yum重装软件包的方式 |
| :--- |

```bash
#检查软件是否存在
[root@zls ~]# rpm -q vsftpd
vsftpd-2.2.2-24.el6.x86_64
#检查vsftpd软件配置文件
[root@zls ~]# rpm -qc vsftpd
/etc/logrotate.d/vsftpd
/etc/pam.d/vsftpd
/etc/vsftpd/ftpusers
/etc/vsftpd/user_list
/etc/vsftpd/vsftpd.conf
#不小心删除vsftpd配置文件
[root@zls ~]# rm -f /etc/vsftpd/vsftpd.conf
#重新安装软件
[root@zls ~]# yum reinstall vsftpd
#再次检查
[root@zls ~]# rpm -qc vsftpd
/etc/logrotate.d/vsftpd
/etc/pam.d/vsftpd
/etc/vsftpd/ftpusers
/etc/vsftpd/user_list
/etc/vsftpd/vsftpd.conf
```

***

| 使用yum更新软件包的方式 |
| :--- |

```bash
#对比Linux已安装的软件和yum仓库中的软件, 有哪些需要升级
[root@zls ~]# yum check-update
#更新acl软件
[root@zls ~]#  yum update acl -y
#如果执行下面的命令，很危险
[root@zls ~]#  yum update -y
```

***

| 使用yum删除软件包的方式 |
| :--- |

```bash
#先安装一个samba软件
[root@zls ~]# yum install samba -y
#删除该软件包,会删除依赖, 但是我们尽可能不要使用删除软件操作
[root@zls ~]# yum erase samba -y
[root@zls ~]# yum remove samba -y
```

***

| yum仓库相关指令 |
| :--- |

```bash
#列出yum源可用的软件仓库
[root@zls ~]# yum repolist
#列出全部yum源可用和禁用的仓库
[root@zls ~]# yum repolist all
#启用软件包
[root@db04 ~]# yum-config-manager --enable
建议：直接修改配置文件
#查看这个文件或命令属于哪个包
yum provides /etc/my.cnf
yum provides cd
```

***

| yum缓存相关指令 |
| :--- |

```bash
#缓存yum源软件仓库, xml元数据文件
[root@zls ~]# yum makecache
#缓存软件包, 修改yum全局配置文件
[root@zls ~]# vim /etc/yum.conf
[main]
cachedir=/var/cache/yum/$basearch/$releasever
keepcache=1 //启动缓存
#查看缓存的xml文件
[root@zls ~]# ls /var/cache/yum/x86_64/7/base/
#查看缓存软件包路径
[root@zls ~]# /var/cache/yum/x86_64/7/
#另一种缓存rpm包方式
#1.安装插件支持只下载软件包不安装
[root@zls ~]# yum install -y yum-plugin-downloadonly
#2.将软件下载至指定目录
[root@zls ~]# yum install httpd -y --downloadonly --downloaddir=/tmp
#清除所有yum缓存
[root@zls ~]# yum clean all
#只清除缓存的软件包
[root@zls ~]# yum clean packages
```

***

| yum包组相关指令 |
| :--- |

```bash
#列出已经安装和所有可使用的软件组
[root@zls ~]# yum groups list
#安装一整个组的软件
[root@zls ~]# yum groups install Development tools \
Compatibility libraries \
Base Debugging Tools
#yum删除包组
[root@zls ~]# yum groups remove  -y Base
```

***

| yum历史命令 |
| :--- |

```bash
#查看历史执行yum命令
[root@zls ~]# yum history
#查询历史执行yum命令ID详细信息
[root@zls ~]# yum history info N
#撤销历史执行过的yum命令
[root@zls ~]# yum history undo N
```

## YUM全局配置文件\[扩展]

yum的配置一般有两种方式：

1.全局配置文件/etc/目录下的yum.conf

2.子配置文件/etc/yum.repos.d/目录下的所有.repo文件

```bash
vim /etc/yum.cnf
cachedir=/var/cache/yum/$basearch/$releasever   //缓存目录
keepcache=0     //缓存软件包, 1启动 0 关闭
debuglevel=2    //调试级别
logfile=/var/log/yum.log    //日志记录位置
exactarch=1     //检查平台是否兼容
obsoletes=1     //检查包是否废弃
gpgcheck=1      //检查来源是否合法,需要有制作者的公钥信息
plugins=1       //是否启用查询
installonly_limit=5
bugtracker_url
# metadata_expire=90m //每小时手动检查元数据
# in /etc/yum.repos.d   //包含repos.d目录
```

## YUM签名检查机制\[扩展]

`rpm`软件提供组织`redhat`在构建`rpm`包时, 使用其`私钥private key`对 `rpm`进行签名

客户端在使用`rpm`为了验证其合法性, 可以使用`redhat`提供的`公钥public key`进行签名检查

***

| 方式1: 指定公钥的位置 |
| :--- |

```bash
[root@zls ~]# vim /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-$releasever - Base mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra #baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

***

| 方式2: 提前导入公钥 |
| :--- |

```bash
[root@zls ~]# rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
[root@tianyun ~]# vim /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-$releasever - Base mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra #baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
gpgcheck=1
```

***

| 方式3: 不进行签名验证 |
| :--- |

```bash
#不检查软件包的签名，或者修改配置文件
[root@zls ~]# yum install httpd --nogpgcheck
```

## 制作本地YUM仓库

如果想要制作一个本地的YUM仓库，那么必须要先了解YUM的配置文件中的一些参数含义。

```bash
[]          //仓库名称
name        //仓库描述信息
baseurl     //YUM源url地址 ,可以是file:// ftp:// http://
enabled     //是否激活该YUM源(0代表禁用,1代表激活,默认为激活)
gpgcheck    //安装软件时是否检查签名(0代表禁用,1代表激活)
```

有时候你的linux系统不能联网，当然就不能很便捷的使用联网的yum源了，这时候就需要你自己会利用linux系统光盘制作一个yum源。具体步骤如下：

***

| 1.挂载镜像 |
| :--- |

```bash
[root@zls ~]# mount /dev/cdrom /mnt
```

***

| 2.备份原有仓库 |
| :--- |

```bash
[root@zls ~]# gzip /etc/yum.repos.d/*
```

***

| 3.创建新仓库文件 |
| :--- |

```bash
#使用yum-config-manager命令添加本地仓库
[root@zls ~]# yum-config-manager --add-repo="file:///mnt"
#手动添加repo配置文件(方式二)
[root@zls ~]# vim /etc/yum.repos.d/cdrom.repo  
[cdrom]      
name=This is local cdrom
baseurl=file:///mnt
enabled=1
gpgcheck=0
```

***

| 5.刷新repos生成缓存 |
| :--- |

```bash
[root@zls ~]# yum makecache
```

## 构建企业级YUM仓库

<!-- OCR_START -->
- 软件仓库
- YUM
- 在线更新
- 客户机
<!-- OCR_END -->

本地光盘提供基础软件包`Base`

yum缓存提供`update`软件包

yum缓存提供常用软件包: `nginx`, `zabbix`, `docker`, `saltstack`

**环境准备**

| 系统 | IP | 角色 | 主机名 |
| :--- | :--- | :--- | :--- |
| centos7.4_x86_64 | 10.0.0.90 | yum仓库服务端 | yum_server |
| centos7.4_x86_64 | 10.0.0.91 | yum仓库客户端 | yum_client |

**服务端配置**

1.基础环境准备

```bash
#关闭防火墙
[root@yum_server ~]# systemctl stop firewalld
#临时关闭selinux
[root@yum_server ~]# setenforce 0
#安装ftp服务,启动并加入开机启动
[root@yum_server ~]# yum -y install vsftpd 
[root@yum_server ~]# systemctl start vsftpd 
[root@yum_server ~]# systemctl enable vsftpd
#开启yum缓存功能
[root@yum_server ~]# vim /etc/yum.conf
[main] cachedir=/var/cache/yum/$basearch/$releasever 
keepcache=1
[root@yum_server ~]# yum clean all
```

2.提供基础`base`源

```bash
[root@yum_server ~]# mkdir /var/ftp/centos7
[root@yum_server ~]# mount /dev/cdrom /mnt
[root@yum_server ~]# cp -rp  /mnt/Packages/*.rpm /var/ftp/centos7
```

3.提供第三方源,同步中科大的源

```bash
#进入ftp目录
[root@yum_server centos]# cd /var/ftp/
#同步中科大的源
[root@yum_server ftp]# rsync -avzP rsync://rsync.mirrors.ustc.edu.cn/repo/nginx ./
```

4.安装`createrepo`并创建 `reopdata`仓库

```bash
//安装createrepo
[root@yum_server ~]# yum -y install createrepo
//生成仓库信息
[root@yum_server ~]# createrepo /var/ftp/
//注意: 如果此仓库每次新增软件则需要重新生成一次
```

**客户端使用yum源**

1.配置并使用`base`基础源

```bash
[root@yum_client ~]# gzip /etc/yum.repos.d/*
[root@yum_client ~]# vim /etc/yum.repos.d/centos7.repo 
[centos74]
name=centos74_base
baseurl=ftp://10.0.0.90/centos7
gpgcheck=0
```

2.客户端指向本地`ftp`源

```bash
[root@yum_client ~]# vim /etc/yum.repos.d/nginx.repo 
[ftp]
name=local ftpserver
baseurl=ftp://10.0.0.90/nginx
gpgcheck=0
```

## 源码包概述

| 什么是源码包 |
| :--- |

源码包指的是开发编写好的程序源代码，但并没有将其编译为一个能正常使用的工具。

| 为什么要学习源码包 |
| :--- |

1.部分软件，官方只提供源码包，需要自行编译安装

2.运维需要规范时，我们想把所有的软件全都安装到同一个目录下

PS：咱们使用windows时，强迫症，我装的QQ，微信，游戏等...全都要放到D盘的某一个目录下

3.有些软件，官方刚发布，还没来得及制作成RPM包，那么我们可以自行编译安装

| 源码包的优缺点 |
| :--- |

优点：

1.有了源码包，那我就可以自行修改代码，提供我们使用，传说中的二次开发

2.可以定制需要的相关功能

3.新版本优先更新源码

4.自动化规范，方便落地

缺点：

1.相对于yum安装，复杂

2.耗时比较长

| 源码包如何获取 |
| :--- |

常见的软件，源码包均可以去官方网站获取源码包。

例如：

mysql

nginx

apache

...

| 源码包安装步骤 |
| :--- |

安装源码包，必须要经历4个步骤

1.解压 tar

2.生成 ./configure cmake

3.编译 make

4.安装 make install

<!-- OCR_START -->
- 编译安装过程
- 下载源代码安装包文件
- 步骤1：tar解包
- 用途：解压并释放源代码包到指定的目录
- 步骤2：./configure配置
- 用途：设置安装目录、安装模块等选项、生成makefile
- 步骤3：make编译
- 用途：将makefile生成可执行的二进制文件
- 步骤4：makeinstall安装
- 用途：复制二进制文件到系统，配置应用环境
- 测试及应用、维护软件
<!-- OCR_END -->

| 源码包安装实战 |
| :--- |

下面通过编译Nginx来深入理解源码包安装

```bash
#1.基础环境准备
[root@node1 ~]# yum install -y gcc make wget 
#2.下载源码包(源码包一定要上官方站点下载，其他站点不安全)
[root@node1 ~]# mkdir -p /soft/src
[root@node1 src]# cd /soft/src
[root@node1 src]# wget http://nginx.org/download/nginx-1.12.2.tar.gz
#3.解压源码包,并进入相应目录
[root@node1 src]# tar xf nginx-1.12.2.tar.gz
[root@node1 src]# cd nginx-1.12.2
#4.配置相关的选项，并生成Makefile
[root@node1 nginx-1.12.2]# ./configure --help|head
  --help                             print this message
  --prefix=PATH                      set installation prefix
  --sbin-path=PATH                   set nginx binary pathname
  --modules-path=PATH                set modules path
  --conf-path=PATH                   set nginx.conf pathname
  --error-log-path=PATH              set error log pathname
  --pid-path=PATH                    set nginx.pid pathname
  --lock-path=PATH                   set nginx.lock pathname
#后面的内容省略了，使用 ./configure --help 命令查看可以使用的选项。
#一般常用的有 --prefix=PREFIX 这个选项的意思是定义软件包安装到哪里。
#建议，源码包都是安装在/soft/目录下。
#5.指定编译参数 
[root@node1 nginx-1.12.2]# ./configure --prefix=/soft/nginx-1.12.2 --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module
#6.验证这一步命令是否成功, 非0d都不算成功
[root@node1 nginx-1.12.2]# echo $?
0
#7.编译并安装
[root@node1 nginx-1.12.2]# make
[root@node1 nginx-1.12.2]# make install
[root@node1 nginx-1.12.2]# echo $?
```

源码编译报错信息处理

```bash
checking for C compiler ... not found ./configure: error: C compiler cc is not found 
#解决方案
# yum -y install gcc gcc-c++ make
./configure: error: the HTTP rewrite module requires the PCRE library.
You can either disable the module by using --without-http_rewrite_module
option, or install the PCRE library into the system, or build the PCRE library
statically from the source with nginx by using --with-pcre=<path> option.
#解决方案
# yum install -y pcre-devel
./configure: error: the HTTP gzip module requires the zlib library.
You can either disable the module by using --without-
http_gzip_module option, or install the zlib library into the
system, or build the zlib library statically from the source with
nginx by using --with-zlib=<path> option. 
#解决方案:
# yum -y install zlib-devel
./configure: error: SSL modules require the OpenSSL library.
You can either do not enable the modules, or install the OpenSSL 
library into the system, or build the OpenSSL library statically
from the source with nginx by using --with-openssl=<path> option.
#解决方案
# yum -y install openssl-devel
```

## 自定义RPM包，并制作YUM仓库\[扩展]

| 自定义RPM包 |
| :--- |

```bash
yum -y install ruby rubygems ruby-devel
gem sources -a http://mirrors.aliyun.com/rubygems/
gem sources --remove http://rubygems.org/
gem install fpm -v 1.3.3
如果安装不上，则可以使用下面的命令下载fpm包
wget http://download.driverzeng.com/fpm-1.3.3.x86_64.tar.gz
准备环境：
mkdir /usr/local/tools -p
cd /usr/local/tools/
wget http://nginx.org/download/nginx-1.6.3.tar.gz
sed -i 's#keepcache=0#keepcache=1#g' /etc/yum.conf  开启yum缓存
find /var/cache/ -type f -name '*rpm'|xargs rm -f 清除yum缓存
安装nginx：
yum install pcre-devel openssl-devel -y
find /var/cache/ -type f -name '*rpm'
find /var/cache/ -type f -name '*rpm'|xargs cp -t /tmp/
cd /tmp/ && tar zcf nginx_yum.tar.gz *.rpm
sz nginx_yum.tar.gz
cd /usr/local/tools
useradd nginx -M -s /sbin/nologin
tar xf nginx-1.6.3.tar.gz
cd nginx-1.6.3
./configure --prefix=/usr/local/nginx-1.6.3 --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module
make && make install
ln -s /usr/local/nginx-1.6.3/ /usr/local/nginx
写脚本：
mkdir -p /server/scripts/
cd /server/scripts/
cat >>nginx_rpm.sh<<EOF
#!/bin/bash
useradd nginx -M -s /sbin/nologin
ln -s /usr/local/nginx-1.6.3/ /usr/local/nginx
EOF
打包：
fpm -s dir -t rpm -n nginx -v 1.6.3 -d 'pcre-devel,openssl-devel' --post-install /server/scripts/nginx_rpm.sh -f /application/nginx-1.6.3/
```

| 定制YUM仓库 |
| :--- |

```bash
#安装yum仓库制作命令
yum -y install createrepo
mkdir -p /application/yum/centos7/x86_64/ 
cd /application/yum/centos7/x86_64/
cp /home/oldboy/tools/*.rpm .
初始化：
createrepo /application/yum/centos6/x86_64/
检查是否开启80端口：
netstat -ntlup |grep 80
cd /application/yum/centos7/x86_64/
python -m SimpleHTTPServer 80 &>/dev/null & 
打开浏览器输入你的外网IP
测试：开启另外一台机器
cd /etc/yum.repos.d
mkdir yum_bak && mv *repo yum_bak
vim zls.repo
[zls]
name=Server
baseurl=http://10.0.0.61
enable=1
gpgcheck=0
清本地yum缓存：
yum clean all
显示yum仓库内容：
yum list
yum makecache
http://blog.zls.com/autodeploy-yum/
配置nginx：
    server {
        listen       80;
        server_name  localhost;
        location / {
#            root   html;
            root   /data/yum_data/;
#            index  index.html index.htm;
            autoindex on;
            access_log off;
        }
    }
```

> 更新: 2024-09-20 22:18:16  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/gcragz>