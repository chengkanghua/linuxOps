# Linux系统优化

修改中英文

```plain
export LC_ALL=en_US.UTF-8
export LC_ALL=zh_CN.UTF-8
```

# Linux软件包管理

windows程序

<!-- OCR_START -->
https://dldir1.qq.c0m/qqfile/qq/QQ9.0.7/24121/QQ9.0.7.24121.exe
重试
<!-- OCR_END -->

macos程序

<!-- OCR_START -->
http://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.2.dmg
重试
<!-- OCR_END -->

Linux程序

```plain
软件包顾名思义就是将应用程序、配置文件和数据打包的产物，所有的linux发行版都采用了某种形式的软件包系统，这使得linux软件管理和在windows下一样方便，suse、red hat、fedora等发行版都是用rpm包，Debian和Ubuntu则使用.deb格式的软件包。
mysql-5-3-4.rpm
redis-3-4-3.rpm
nginx2-3-2.rpm
```

## 编程语言

<!-- OCR_START -->
- LanguagePascal
- C/AL
- SYMP
- HAL/S
- ALGOL
- DATATREVE
- SMSCRPT
- MPLE
- PL
- Ajax
- Clojre
- Object
- Not
- Trac
- Mcrocode
- code
- Ly
- SALSA ATS
- ELAN
- Adenine
- Assembly
- LispVB
- TADPOL
- language
- shell
- Windowt/Des
- 十十
- SuperTak
- JavaScript
- IMP
- ABC
- Visual
- foet
- Delphi DASL
- GaeeMorhey
- Prolog
- Caynre
- Camlz
- Go
- ECMASapt
- bac
- JASS
- Corstrait
- PEARL
- Estisp ObjectScript
- lava
- Oxygene
- Programming
- LSS
- ScriptPHP
- Ruby
- EXEC
- Action
- CarVision
- REXX
- RPL
- NETosn
- Common
- Doonerag
- COBOL
- CraghTak
- Python
- Tung
- CRCAModA-2
- ISWM
- AcMoby
- Uface
- HaXa
- WATFOR
- Cara
<!-- OCR_END -->

* 系统级开发：
  * C/C++：httpd、nginx
  * golang：docker
* 应用及开发：
  * java：hadoop，hbase
  * python：openstack
  * perl
  * ruby
  * php

## 程序格式

**C/C++程序源代码**

```plain
文本格式的程度代码
```

编译开发环境

```plain
编译器、头文件、开发库
```

二进制格式组成

```plain
程序(软件)组成部分：
    二进制程序  可执行命令
    库     .so文件
    配置文件    .conf
    帮助文件    readme    /usr/share/man
```

**java/python程序**

源代码

```plain
编译成能够在python虚拟机pvm上运行的格式
```

**项目构建工具**

```plain
c/c++  ：make工具
```

<!-- OCR_START -->
- 机器码
- 安装包
- 七巧板零件
- 七巧板拼图
- 系统可以直接执行
<!-- OCR_END -->

## 程序包管理器

在 RPM（红帽软件包管理器）出现之前，Linux 装软件只能用源码包：服务程序大多只提供源代码，运维要自行编译、解决依赖，还要兼顾其他程序和库的关系，安装/升级/卸载/查询都非常困难，对知识和耐心要求极高。

RPM 正是为解决这些问题而设计：它类似 Windows 的控制面板，建立统一的数据库文件，详细记录软件信息，并能自动分析依赖关系。

<!-- OCR_START -->
- 程序和功能
- 个控制面板程序程序和功能
- 搜索“程序和功
- 控制面板主页
- 卸载或更改程序
- 查看已安装的更新
- 若要卸最图序，请从列表中将其选中，然后单击“卸城”、“更改“或”修复，
- 启用或关闭Windows功能
- 组织
- 名称
- 发布者
- 安装时间
- 大小
- 版本
- 360安全浏宽界7
- 360安全中心
- 2014/10/5
- 卸载(U)
- 7.1.1
- AMD Catalyst Control Center
- AMD
- 1.00,
- MicrosoftVisualC++2012Redistributable（x86)-11.0.
- Microsoft Corporation
- 17.3 MB
- 11.0
- 温英特尔（R）核芯显卡驱动屋序
- Intel Corporation
- 74.2 MB9.17.
- 360安全中心产品版本：7.1.1.200
<!-- OCR_END -->

Linux程序包管理器，几个发行版

* debian(Ubuntu)：dpt、dpkg、
  * .deb
* redhat：`redhat package manager，简称rpm`
* suse：`rpm`

**源代码格式**

```plain
格式：name-version.tar.gz
nginx-1.12.0.tar.gz
node-v10.15.3-linux-x64.tar
```

**rpm包格式**

```plain
格式：name-version-release.arch.rpm
wget-1.14-18.el7.x86_64.rpm
名字，版本号，架构型号
```

<!-- OCR_START -->
DownloadPackages:
Red HatEnterprise Linux7/ Oracle Linux7(x86,64-bit),RPM Bundle
8.0.12
589.9M
Download
(mysql-8.0.12-1.el7.x86_64.rpm-bundle.tar)
MD5:124407c79aa6ab6717951d2f056d989c|Signature
453.0M
(mysql-8.0.12-1.el7.aarch64.rpm-bundle.tar)
MD5:4aa4234db895532ca9ebde30235fd8ea|Signature
RedHatEnterpriseLinux7/OracleLinux7(x86,64-bit),RPMPackage
348.9M
MySQL Server
(mysql-community-server-8.0.12-1.el7.x86_64.rpm)
MD5:ebc02ca3bb0df6eaef832d7ab25edc62
347.7M
(mysql-community-server-8.0.12-1.el7.aarch64.rpm)
MD5:c4285f503b21c9f70053d56da0d4cd43
25.5M
Client Utilities
(mysql-community-client-8.0.12-1.el7.x86_64.rpm)
MD5:8a665fabed7b66f3c90f6747419e27b8
<!-- OCR_END -->

## 获取程序包的途径

互联网上提供的软件，可能存在后门，存在安全隐患，插件

*最为正确的途径*

* 操作系统发行版本光盘
* 文件服务器
* 镜像站点

开源镜像站

```plain
http://mirrors.aliyun.com
http://mirrors.sohu.com
http://mirrors.sohu.com/centos/7.5.1804/os/x86_64/Packages/
http://mirrors.163.com
```

* epel，提供centos众多额外的第三方包，可信任的第三方软件包组织

```plain
http://mirrors.sohu.com/fedora-epel/7/x86_64/Packages/
https://mirrors.aliyun.com/epel/7/x86_64/Packages/m/
```

* 搜索引擎

```plain
http://www.rpmfind.net/linux/mageia/distrib/7/x86_64/media/core/release/lrzsz-0.12.21-22.mga7.x86_64.rpm
```

## rpm命令

```plain
rpm命令：rpm  [OPTIONS]  [PACKAGE_FILE]
# i表示安装 v显示详细过程 h以进度条显示，每个#表示2%进度
安装软件的命令格式                rpm -ivh filename.rpm    
升级软件的命令格式                rpm -Uvh filename.rpm
卸载软件的命令格式                rpm -e filename.rpm
查询软件描述信息的命令格式         rpm -qpi filename.rpm
列出软件文件信息的命令格式         rpm -qpl filename.rpm
查询文件属于哪个 RPM 的命令格式 　 rpm -qf filename
```

案例

```plain
wget http://www.rpmfind.net/linux/mageia/distrib/7/x86_64/media/core/release/lrzsz-0.12.21-22.mga7.x86_64.rpm
#测试rpm包
[root@chaogelinux pyrpm]# rpm -ivh --test lrzsz-0.12.21-22.mga7.x86_64.rpm
警告：lrzsz-0.12.21-22.mga7.x86_64.rpm: 头V4 RSA/SHA256 Signature, 密钥 ID 80420f66: NOKEY
准备中...                          ################################# [100%]
[root@chaogelinux pyrpm]# rpm -ivh lrzsz-0.12.21-22.mga7.x86_64.rpm
警告：lrzsz-0.12.21-22.mga7.x86_64.rpm: 头V4 RSA/SHA256 Signature, 密钥 ID 80420f66: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:lrzsz-0.12.21-22.mga7            ################################# [100%]
#升级rpm包
[root@chaogelinux pyrpm]# rpm -Uvh lrzsz-0.12.21-22.mga7.x86_64.rpm
警告：lrzsz-0.12.21-22.mga7.x86_64.rpm: 头V4 RSA/SHA256 Signature, 密钥 ID 80420f66: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:lrzsz-0.12.21-22.mga7            ################################# [100%]
#卸载lrzsz工具
rpm -e lrzsz
```

## 软件包依赖关系

早期装软件很费劲：管理员得下载源码、编译，还要为系统做各种调整。源码编译虽提高了定制自由度，但在小软件上耗费精力并不划算，于是软件包应运而生。

软件包管理把管理员从无休止的兼容问题中解放出来——yum 能自动搜索依赖并完成安装。而 rpm 包的依赖关系，是由包的作者在制作时定义的。

```plain
必须解决依赖关系，软件才能正常工作
```

<!-- OCR_START -->
- q:Quit
- dD,E:DeL
- U,U,I:Undel
- r,R:Regb,B:ReqBy
- i:Info
- c,c:commit
- F2:Help
- 19.6M cmake
- 2.8.12.1-1.fc19.i686
- 18.3M kdenlive
- 0.9.6-2.fc19.i686
- 17.8M selinux-policy-targeted
- 3.12.1-54.fc19.n0arch
- 17.5M python-sqlalchemy
- 0.8.3-1.fc19.i686
- 16.4M wqy-zenhei-fonts
- 0.9.46-10.fc19.n0arch
- 15.5M gCC-C++
- 4.8.3-1.fc19.i686
- 15.2M shutter
- 0.90-2.fc19.noarch
- 368K
- ImageMagick-perl
- 6.7.8.9-5.fc19.i686
- 7.4M
- 2
- ImageMagick
- 14.3M
- glibc
- 2.17-14.fc19.i686
- OK
- basesystem
- 10.0-8.fc19.noarch
- 113.7M
- -glibc-common
- 3.4M
- +bash
- 4.2.45-1.fc19.i686
- 145K
- +libselinux
- 2.1.13-15.fc19.i686
- 1.9M
- tzdata
- 2013c-1.fc19.n0arch
- 199K
- libgcc
- 330K
- +nss-softokn-freebl
- 3.14.3-1.fc19.i686
- 22.4M
- perl
- 5.16.3-265.fc19.i686
- 28K
- perl-carp
- 1.26-243.fc19.n0arch
- Pkgs:1650
- （3.7GB）
- Del:O（OKB）
- Break:o1
- (flags）---（18)
<!-- OCR_END -->

### 自动解决依赖关系软件包管理器

* Yum，红帽系列rpm包管理工具
* apt-get，deb包管理工具
* zypper，suse的rpm包管理工具

*windows软件管理工具*

<!-- OCR_START -->
- 360
- 欧件大全
- 软件升级
- 软件即
- 软件体检
- 游戏中心
- 手机必管
- 软件管家
- 热门精选
- ）【公告】360用户男：整建有你，一路圆行！
- 手机助手
- 我的软件
- 热门按索榜
- 最受好评榜
- 新秀软件榜
- 软件风云榜
- 页游排行榜
- 单机游戏排行榜
- 今日热门
- 软件排行
- 腾讯QQ
- 2401049
- 一键升级
- 酷我音乐
- 957269
- 一健安装
- 装机必册
- 360安全测览器
- 1700111
- 已安装
- 软件宝库
- 快用苹果助手
- 997269
- 键安装
- 全部软件（22279）
- 酷豹音乐
- 1436481
- 美阳秀秀
- 888511
- 视须软件（789）
- 天工具（185）
- 暴风影音
- 1312251
- 一键安装
- 鲁大师
- 781954
- 览（84）
- 手心输入法
- 1096100
- 360杀奇
- 682681
- 下载
- 游戏乐（7859）
- 网络游戏（483）
- 乐软件（548）
- 360极速测览器
- 643453
- Adobe Reader
- 536926
- 安全杀毒（91）
- 系统工具（2200）
- 阿里旺旺
- 603123
- 迅雷看看
- 503516
- 下载工具（129）
- 极速版迅
- 599194
- 谷歌拼音输入法
- 476863
- 办公软件（723）
- 手机数码（259）
- 语音
- 571321
- 风行网络电影
- 455573
- 入法（93）
- 款件管家目版本：5.1.0.1120
- 软件小动手设置下积营理
<!-- OCR_END -->

*Linux软件管理*

<!-- OCR_START -->
- 通过配置文件指定仓库地址
- Yum软件仓库
- /etc/yum.repos.d/*.repo
- 服务器
- 客户端
- cache
- 缓存数据
<!-- OCR_END -->

**yum命令**是在Fedora和RedHat以及SUSE中基于rpm的软件包管理器，它可以使系统管理人员交互和自动化地更细与管理RPM软件包，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软体包，无须繁琐地一次次下载、安装。

尽管 RPM 能够帮助用户查询软件相关的依赖关系，但问题还是要运维人员自己来解决， 而有些大型软件可能与数十个程序都有依赖关系，在这种情况下安装软件会是非常痛苦的。

Yum 软件仓库便是为了进一步降低软件安装难度和复杂度而设计的技术。Yum 软件仓库可以 根据用户的要求分析出所需软件包及其相关的依赖关系，然后自动从服务器下载软件包并安装到系统。

Yum 软件仓库中的 RPM 软件包可以是由红帽官方发布的，也可以是第三方发布的，当然也可以是自己编写的。

### yum工具

* Yum（全称为 Yellow dog Updater, Modified）是一个在Fedora和RedHat以及CentOS中的Shell前端软件包管理器。基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软件包，无须繁琐地一次次下载、安装。
* 说到yum源就必须说到linux系统中特有的依赖关系问题，yum就是为了解决依赖关系而存在的。yum源就相当是一个目录项，当我们使用yum机制安装软件时，若需要安装依赖软件，则yum机制就会根据在yum源中定义好的路径查找依赖软件，并将依赖软件安装好。
* YUM是“Yellow dog Updater, Modified”的缩写，是一个软件包管理器，YUM从指定的地方（相关网站的rpm包地址或本地的rpm路径）自动下载RPM包并且安装，能够很好的解决依赖关系问题。
* YUM的基本工作机制如下： 服务器端：在服务器上面存放了所有的RPM软件包，然后以相关的功能去分析每个RPM文件的依赖性关系，将这些数据记录成文件存放在服务器的某特定目录内。 客户端：如果需要安装某个软件时，先下载服务器上面记录的依赖性关系文件(可通过WWW或FTP方式)，通过对服务器端下载的纪录数据进行分析，然后取得所有相关的软件，一次全部下载下来进行安装。
* Yum repository：yum仓库，存储了众多的软件包，以及相关的元数据文件
  * 文件服务器
    * ftp://
    * http://
    * nfs://
    * file://
  * yum仓库可以存在多个，自动选择软件最新的，以及优先选择离我们近的仓库下载

```plain
#yum其实也是一个rpm软件
[root@chaogelinux pyrpm]# rpm -qa yum
yum-3.4.3-163.el7.centos.noarch
```

### yum客户端

```plain
/etc/yum.conf  #为所有仓库提供公共配置
[root@chaogelinux yum.repos.d]# cat /etc/yum.conf
[main]
cachedir=/var/cache/yum/$basearch/$releasever
keepcache=0                                    #本地缓存是否保留，0否，1是
debuglevel=2                                #调试日志级别
logfile=/var/log/yum.log        #日志路径
exactarch=1                                    #精确系统平台版本匹配
obsoletes=1            
gpgcheck=1                                    #检查软件包的合法性
plugins=1                
installonly_limit=5                    #同时安装几个工具包
bugtracker_url=http://bugs.centos.org/set_project.php?project_id=23&ref=http://bugs.centos.org/bug_report_page.php?category=yum
distroverpkg=centos-release        
#  This is the default, if you make this bigger yum won't see if the metadata
# is newer on the remote and so you'll "gain" the bandwidth of not having to
# download the new metadata and "pay" for it by yum not having correct
# information.
#  It is esp. important, to have correct metadata, for distributions like
# Fedora which don't keep old packages around. If you don't like this checking
# interupting your command line usage, it's much better to have something
# manually check the metadata once an hour (yum-updatesd will do this).
# metadata_expire=90m
#请放置你的仓库在这里，并且命名为*.repo类型
# PUT YOUR REPOS HERE OR IN separate files named file.repo
# in /etc/yum.repos.d
```

### repo仓库文件

<!-- OCR_START -->
mirrors.aliyun.com/centos/7/
2.root@chaogelinux:/etc/yum.
X root@chaogelinux:/.. 81
Indexof/centos/7/
#CentOS-Base.repo
The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
atomic/
28-
# geographically close to the client. You should use this for Centos updates
centosplus/
14-
cloud/
# unless you are manually picking other mirrors.
configmanagement/
cr/
dotnet/
29-
# If the mirrorlist= does not work for you, as a fall back you can try the
extras/
11-
# remarked out baseurl= line instead.
fasttrac
isos/
06-
nfv/
opstools/
os/
13-
paas/
[base]
rt/
10-
sclo/
name=Centos-$releasever - Base - mirrors.aliyun.com
storage/
failovermethod=priority
updates/
baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
virt/
http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
#released updates
name=Centos-$releasever - Updates - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
http://mirrors.aliyuncs.com/centos/$releasever/updates/$basearch/
http://mirrors.cloud.aliyuncs.com/centos/$releasever/updates/$basearch/
#additionalpackagesthat maybeuseful
name=Centos-$releasever - Extras - mirrors.aliyun.com
<!-- OCR_END -->

```plain
/etc/yum.repos.d/*.repo #提供仓库的地址文件
CentOS-Base.repo
[base]
name=CentOS-$releasever - Base - mirrors.aliyun.com        #仓库文件的说明
failovermethod=priority    #存在多个url的时候，按顺序来连接，如果是roundrobin，意为随机挑选
baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/    #指定仓库的网站地址
        http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
gpgcheck=1    #是否检测秘钥
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7      #公钥文件存放路径
#released updates  指定rpm包需要升级的地址，此处可以去网页上寻找对应的包
[updates]
name=CentOS-$releasever - Updates - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/updates/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
epel.conf
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
baseurl=http://mirrors.aliyun.com/epel/7/$basearch
failovermethod=priority
enabled=1        #是否启用此仓库
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
```

自定义一个简单的repo文件

```plain
touch chaoge.repo #写入
[base]
name=Chaoge repo 
baseurl=http://chaoge.com/centos/7/os/x86_64/
gpgcheck=0
[epel]
name=Chaoge epel repo
baseurl=http://chaoge.com/epel/7/os/x86_64/
gpgcheck=0
```

### 配置yum源

* `[http://mirrors.163.com/](http://mirrors.163.com/)`
* `[https://opsx.alibaba.com/mirrors](https://opsx.alibaba.com/mirrors)`

```plain
1.备份现有repo仓库
2.下载新的repo文件
CentOS 6
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
CentOS 7
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
3.清空旧yum缓存，生成新的缓存
yum clean all
yum makecache
4.针对阿里云镜像，可能出现无法解析地址的异常
sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
5.配置epel源
epel(RHEL 7)
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
epel(RHEL 6)
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
epel(RHEL 5)
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo
```

* `[http://mirrors.sohu.com/](http://mirrors.sohu.com/)`

### yum命令

```plain
yum命令的用法：
    yum [options] [command] [package ...]
   command is one of:
    * install package1 [package2] [...]
    * update [package1] [package2] [...]
    * update-to [package1] [package2] [...]
    * check-update
    * upgrade [package1] [package2] [...]
    * upgrade-to [package1] [package2] [...]
    * distribution-synchronization [package1] [package2] [...]
    * remove | erase package1 [package2] [...]
    * list [...]
    * info [...]
    * provides | whatprovides feature1 [feature2] [...]
    * clean [ packages | metadata | expire-cache | rpmdb | plugins | all ]
    * makecache
    * groupinstall group1 [group2] [...]
    * groupupdate group1 [group2] [...]
    * grouplist [hidden] [groupwildcard] [...]
    * groupremove group1 [group2] [...]
    * groupinfo group1 [...]
    * search string1 [string2] [...]
    * shell [filename]
    * resolvedep dep1 [dep2] [...]
    * localinstall rpmfile1 [rpmfile2] [...]
       (maintained for legacy reasons only - use install)
    * localupdate rpmfile1 [rpmfile2] [...]
       (maintained for legacy reasons only - use update)
    * reinstall package1 [package2] [...]
    * downgrade package1 [package2] [...]
    * deplist package1 [package2] [...]
    * repolist [all|enabled|disabled]
    * version [ all | installed | available | group-* | nogroups* | grouplist | groupinfo ]
    * history [info|list|packages-list|packages-info|summary|addon-info|redo|undo|rollback|new|sync|stats]
    * check
    * help [command]
显示仓库列表：
    repolist [all|enabled|disabled]
显示程序包：
    list
        # yum list [all | glob_exp1] [glob_exp2] [...]
        # yum list {available|installed|updates} [glob_exp1] [...]
安装程序包：
    install package1 [package2] [...]
    reinstall package1 [package2] [...]  (重新安装)
升级程序包：
    update [package1] [package2] [...]
    downgrade package1 [package2] [...] (降级)
检查可用升级：
    check-update
卸载程序包：
    remove | erase package1 [package2] [...]
查看程序包information：
    info [...]
查看指定的特性(可以是某文件)是由哪个程序包所提供：
    provides | whatprovides feature1 [feature2] [...]
清理本地缓存：
clean [headers|packages|metadata|dbcache|plugins|expire-cache|all]
构建缓存：
    makecache
搜索：
    search string1 [string2] [...]
    以指定的关键字搜索程序包名及summary信息；
查看指定包所依赖的capabilities：
    deplist package1 [package2] [...]
查看yum事务历史：
    history [info|list|packages-list|packages-info|summary|addon-info|redo|undo|rollback|new|sync|stats]
安装及升级本地程序包：
    * localinstall rpmfile1 [rpmfile2] [...]
       (maintained for legacy reasons only - use install)
    * localupdate rpmfile1 [rpmfile2] [...]
       (maintained for legacy reasons only - use update)
包组管理的相关命令：
    * groupinstall group1 [group2] [...]
    * groupupdate group1 [group2] [...]
    * grouplist [hidden] [groupwildcard] [...]
    * groupremove group1 [group2] [...]
    * groupinfo group1 [...]
如何使用光盘当作本地yum仓库：
    (1) 挂载光盘至某目录，例如/media/cdrom
        # mount -r -t iso9660 /dev/cdrom /media/cdrom
    (2) 创建配置文件
    [CentOS7]
    name=
    baseurl=
    gpgcheck=
    enabled=
yum的命令行选项：
    --nogpgcheck：禁止进行gpg check；
    -y: 自动回答为“yes”；
    -q：静默模式；
    --disablerepo=repoidglob：临时禁用此处指定的repo；
    --enablerepo=repoidglob：临时启用此处指定的repo；
    --noplugins：禁用所有插件；
yum的repo配置文件中可用的变量：
    $releasever: 当前OS的发行版的主版本号；
    $arch: 平台；
    $basearch：基础平台；
    $YUM0-$YUM9
[base]
name=Chaoge repo 
baseurl=http://chaoge.com/centos/7/os/x86_64/  #使用变量替换，就很方便了
baseurl=http://chaoge.com/centos/6/os/x86_64/
baseurl=http://chaoge.com/centos/5/os/x86_64/
gpgcheck=0
```

## systemctl命令

<!-- OCR_START -->
- systemctl
- 相关命令：service，chkconfig
- systemd 是Linux下的一款系统和服务管理器，兼容 SysV 和LSB的启动脚本。systemd的特性有：支持并行化任务；同时采用socket式与D-Bus总线式激活服务；按需
- 启动守护进程（daemon）；利用Linux的cgroups监视进程；支持快照和系统恢复；维护挂载点和自动挂载点；各服务间基于依赖关系进行精密控制。
- 任务
- 旧指令
- 新指令
- 使某服务自动启动
- chkconfig--level3httpd on
- systemctlenablehttpd.service
- 使某服务不自动启动
- systemctldisablehttpd.service
- 检查服务状态
- servicehttpdstatus
- Systemctlstatushttpd.service（服务详细信息）systemctlis-enabledhttpd.service（仅显示是否Active)
- 显示所有已启动的服务
- chkconfig--ist
- systemctlist-units--type=service
- 启动某服务
- servicehttpdstart
- systemctlstarthttpd.service
- 停止某服务
- servicehttpdstop
- systemctlstophttpd.service
- 重启某服务
- servicehttpdrestart
- systemctlrestarthttpd.service
- 某服务重新加载配置文件
- servicehttpdreload
- systemctlreloadhttpd.service
<!-- OCR_END -->

## 源代码编译安装

无论是rpm命令或是yum命令，都是安装二进制格式的程序包，别人编译好的

```plain
mysql-xx.rpm
redis-xx.rpm
nginx-xx.rpm
```

可能存在的问题，别人给的rpm包，可能版本较低，不合适我们现有的需求

### yum和编译安装的区别

*yum的优缺点*

* yum是自动去yum源中寻找rpm包下载且安装，自动解决依赖，自动指定安装路径，无须人为干预
* 适合初学者，不用考虑依赖关系即可安装使用大部分软件
* 功能由rpm包控制，这个rpm包也是别人编译好的，版本可能较低，功能受限，存在漏洞
* yum自动安装的软件不能定义软件的路径，与功能，机器数量较多，与后期维护成本较大

*编译安装优缺点*

* 可以手动下载最新源代码，按照指定需求，设置参数，指定安装路径，扩展第三方功能，更加灵活
* 无法自动解决依赖关系，对新手不友好

**建议方式**

```plain
yum和编译安装结合使用，能够最大程度解决问题
```

### 编译三部曲

前提条件：准备好开发工具以及开发环境

```plain
开发工具：gcc make等
开发组件：
yum groupinstall "Development Tools"
yum groupinstall "Server Platform Development"
```

<!-- OCR_START -->
- 源文件
- 预处理
- 纯C
- 编译器
- cpp
- cC
- 汇编程序
- 可执行文件
- 链接器
- 目标文件
- 汇编器
- ld
- as
- 库文件
<!-- OCR_END -->

第一曲，执行脚本`configure`文件

```plain
./configure --prefix=软件安装路径
针对C、C++代码，进行编译安装，需要指定配置文件`Makefile`，需要通过`configure`脚本生成
通过选项传递参数，指定启用特性、安装路径等<执行时会生成makefile
检查依赖到的外部环境
```

第二曲，执行make命令

```plain
make是Linux开发套件里面自动化编译的一个控制程序，他通过借助 Makefile 里面编写的编译规范进行自动化的调用 gcc 、ld 以及运行某些需要的程序进行编译的程序。一般情况下，他所使用的 Makefile 控制代码，由 configure 这个设置脚本根据给定的参数和系统环境生成。
make这一步就是编译，大多数的源代码包都经过这一步进行编译（当然有些perl或python编写的软件需要调用perl或python来进行编译）
make 的作用是开始进行源代码编译，以及一些功能的提供，这些功能由他的 Makefile 设置文件提供相关的功能，比如 make install 一般表示进行安装，make uninstall 是卸载，不加参数就是默认的进行源代码编译。
```

第三曲：开始安装 make install

```plain
开始安装软件到./configure指定的安装路径
```

### 源码编译安装nginx

```plain
1.准备编译环境
yum install gcc patch libffi-devel python-devel  zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel openssl openssl-devel -y
2.获取nginx源代码
wget -c https://nginx.org/download/nginx-1.12.0.tar.gz
3.解压缩nginx源代码
tar -zxvf nginx-1.12.0.tar.gz
4.进入源码目录
cd nginx-1.12.0
5.开始编译三部曲
./configure --prefix=/opt/nginx112/  --with-http_ssl_module --with-http_stub_status_module 
6.执行make指令，调用gcc等编译工具
make
7.开始安装
make install
8.安装后启动nginx软件，找到二进制程序，以绝对路径执行
/opt/ngx112/sbin/nginx
9.检查环境变量，需要手动配置nginx的PATH路径，否则必须绝对路径才能找到
编辑文件/etc/profile.d/nginx.sh
写入export PATH=/opt/ngx112/sbin:$PATH
10.退出回话，重新登录机器
logout
11.检查环境变量
[root@chaogelinux ngx112]# cat /etc/profile.d/nginx.sh
export PATH=/opt/ngx112/sbin:$PATH
12.启动nginx，可以访问页面
```

### 环境变量配置文件

```plain
/etc/profile
用于设置系统级的环境变量和启动程序，在这个文件下配置会对所有用户生效。当用户登录(login)时，文件会被执行，并从/etc/profile.d目录的配置文件中查找shell设置。如果对/etc/profile修改的话必须重启才会生效
~/.profile
每个用户都可使用该文件输入专用于自己使用的shell信息,当用户登录时,该文件仅仅执行一次!默认情况下,他设置一些环境变量,执行用户的.bashrc文件.
~/.bashrc
该文件包含专用于你的bash shell的bash信息,当登录时以及每次打开新的shell时,该该文件被读取.
~/.bash_logout
当每次退出系统(退出bash shell)时,执行该文件，通常存放清理工作的命令。
执行顺序
登陆shell
登陆shell时，首先执行/etc/profile，之后执行用户目录下的~/.profile,~/.profile中会执行~/.bashrc。
```

> 更新: 2021-01-17 12:14:03  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/fg42uf>