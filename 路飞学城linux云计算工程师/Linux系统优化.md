# Linux 系统优化

> 本篇解决两件上手前的"小事"：一是如何在中文 / 英文之间切换系统语言，方便对照英文报错查资料；二是 Linux 软件包管理——从程序的来源、格式，到 rpm、yum、systemctl 的用法，最后讲源代码编译安装。学完你就能熟练地装软件、查软件、管服务。

## 本章目录

- 一、修改系统语言（中英文）
- 二、Linux 软件包管理
  - 不同操作系统的安装包
  - 编程语言
  - 程序格式
  - 程序包管理器
  - 获取程序包的途径
  - rpm 命令
  - 软件包依赖关系
  - systemctl 命令
  - 源代码编译安装

---

## 一、修改系统语言（中英文）

Linux 的显示语言由 locale（区域设置）决定。给环境变量 `LC_ALL` 赋不同的值，就能在中英文之间切换：

```plain
export LC_ALL=en_US.UTF-8
export LC_ALL=zh_CN.UTF-8
```

- 第一行：把当前环境切换成英文；
- 第二行：切换回中文。

> 💡 这种写法只对当前登录会话生效，重新登录后失效。查看当前区域设置可执行只读命令 `locale`；需要永久生效时，CentOS 7 一般修改 `/etc/locale.conf`（例如设置 `LANG=en_US.UTF-8`）。

## 二、Linux 软件包管理

### 不同操作系统的安装包

同一个 QQ，在不同平台上的安装包格式完全不同：

| 平台 | 常见安装包格式 | QQ 安装包示例 |
| --- | --- | --- |
| Windows | `.exe`、`.msi` | `QQ9.0.7.24121.exe` |
| macOS | `.dmg`、`.pkg` | `QQ_V6.5.2.dmg` |
| Linux | `.rpm`、`.deb`（因发行版而异） | 见下方说明 |

原截图是浏览器下载 QQ 时的页面：Windows 包的下载地址以 `.exe` 结尾、Mac 包以 `.dmg` 结尾，下载失败时页面会给出"重试"按钮。

所谓软件包，就是把应用程序、配置文件和数据打到一起的产物：

```plain
软件包顾名思义就是将应用程序、配置文件和数据打包的产物，所有的linux发行版都采用了某种形式的软件包系统，这使得linux软件管理和在windows下一样方便，suse、red hat、fedora等发行版都是用rpm包，Debian和Ubuntu则使用.deb格式的软件包。
mysql-5-3-4.rpm
redis-3-4-3.rpm
nginx2-3-2.rpm
```

### 编程语言

编程语言的种类非常多——原截图是一张"编程语言词云"，里面挤了上百种语言的名字，字号越大代表越热门，其中最醒目的是 C、Java、JavaScript、PHP、Python、C++ 等。

在 Linux 生态里，这些语言按使用场景大致分成两个层次：

| 层次 | 语言 | 代表软件 |
| --- | --- | --- |
| 系统级开发 | C/C++ | httpd、nginx |
|  | golang | docker |
| 应用级开发 | java | hadoop，hbase |
|  | python | openstack |
|  | perl / ruby / php | — |

### 程序格式

**C/C++ 程序源代码**

C/C++ 的源代码是纯文本格式，需要借助"编译器、头文件、开发库"组成的编译开发环境，才能编译成机器能执行的二进制程序：

```plain
文本格式的程度代码
```

```plain
编译器、头文件、开发库
```

编译出来的二进制程序，一般由下面几部分组成：

```plain
程序(软件)组成部分：
    二进制程序  可执行命令
    库     .so文件
    配置文件    .conf
    帮助文件    readme    /usr/share/man
```

**java/python 程序**

这类程序不直接编译成机器码，而是先编译成运行在各自虚拟机上的格式：

```plain
编译成能够在python虚拟机pvm上运行的格式
```

**项目构建工具**

管理编译过程也需要专门的构建工具：

```plain
c/c++  ：make工具
```

原截图用"七巧板"打了个比方：源代码是一堆零散的**七巧板零件**，经过编译、打包变成机器码形式的**安装包**（拼好的七巧板图案），机器码是系统可以直接执行的：

```plain
源代码（七巧板零件）──编译 / 打包──▶ 机器码安装包（七巧板拼图）──▶ 系统可以直接执行
```

### 程序包管理器

在 RPM（红帽软件包管理器）出现之前，Linux 装软件只能用源码包：服务程序大多只提供源代码，运维要自行编译、解决依赖，还要兼顾其他程序和库的关系，安装/升级/卸载/查询都非常困难，对知识和耐心要求极高。

RPM 正是为解决这些问题而设计：它类似 Windows 的控制面板，建立统一的数据库文件，详细记录软件信息，并能自动分析依赖关系。

原截图是 Windows 控制面板的"程序和功能"界面：可以按名称、发布者、安装时间、大小、版本查看已安装软件，选中后点"卸载 / 更改 / 修复"。RPM 在 Linux 里扮演的就是类似角色。

不同发行版使用的包管理器和软件包格式如下：

| 发行版 | 包管理器 | 软件包格式 |
| --- | --- | --- |
| Debian / Ubuntu | dpkg（常用 apt/apt-get 作为前端） | `.deb` |
| RedHat / CentOS / Fedora | rpm（常用 yum/dnf 作为前端） | `.rpm` |
| SUSE | rpm（常用 zypper 作为前端） | `.rpm` |

**源代码格式**

```plain
格式：name-version.tar.gz
nginx-1.12.0.tar.gz
node-v10.15.3-linux-x64.tar
```

**rpm 包格式**

```plain
格式：name-version-release.arch.rpm
wget-1.14-18.el7.x86_64.rpm
名字，版本号，架构型号
```

原截图是 MySQL 官网 8.0.12 版本的下载列表，可以直观看到"同一个软件、不同平台 / 用途对应不同的包"，文件名里就带着架构信息：

| 适用平台 | 包形式 | 文件名 | 大小 |
| --- | --- | --- | --- |
| RHEL 7 / Oracle Linux 7（x86，64-bit） | RPM Bundle 合集 | mysql-8.0.12-1.el7.x86_64.rpm-bundle.tar | 589.9M |
| RHEL 7 / Oracle Linux 7（ARM，64-bit） | RPM Bundle 合集 | mysql-8.0.12-1.el7.aarch64.rpm-bundle.tar | 453.0M |
| x86，64-bit · MySQL Server | 单个 RPM | mysql-community-server-8.0.12-1.el7.x86_64.rpm | 348.9M |
| ARM，64-bit · MySQL Server | 单个 RPM | mysql-community-server-8.0.12-1.el7.aarch64.rpm | 347.7M |
| x86，64-bit · Client Utilities | 单个 RPM | mysql-community-client-8.0.12-1.el7.x86_64.rpm | 25.5M |

> 💡 `x86_64` 和 `aarch64` 是两种 CPU 架构：前者对应 Intel/AMD，后者对应 ARM（例如鲲鹏、车载 Thor 这类平台）。装包必须选对架构，否则装不上也跑不了。

### 获取程序包的途径

> ⚠️ 互联网上随手搜到的软件，可能被植入后门或捆绑插件，存在安全隐患。下载软件包应尽量走正规、可信的渠道。

最为正确的途径有：发行版自带光盘、单位内部文件服务器、官方镜像站点。具体可分为：

| 途径 | 说明 |
| --- | --- |
| 操作系统发行版光盘 | 随系统发行，和系统版本严格匹配，最可信 |
| 开源镜像站 | 官方仓库的完整镜像，下载速度快 |
| EPEL | 可信任的第三方组织，为 CentOS/RHEL 提供大量额外软件包 |
| 搜索引擎（如 rpmfind） | 按名字找散落的 rpm 包，需仔细甄别来源 |

常用的开源镜像站：

```plain
http://mirrors.aliyun.com
http://mirrors.sohu.com
http://mirrors.sohu.com/centos/7.5.1804/os/x86_64/Packages/
http://mirrors.163.com
```

EPEL 镜像地址：

```plain
http://mirrors.sohu.com/fedora-epel/7/x86_64/Packages/
https://mirrors.aliyun.com/epel/7/x86_64/Packages/m/
```

通过搜索引擎找包（示例为 rpmfind 上的 lrzsz 包）：

```plain
http://www.rpmfind.net/linux/mageia/distrib/7/x86_64/media/core/release/lrzsz-0.12.21-22.mga7.x86_64.rpm
```

### rpm 命令

rpm 的基本用法和常用操作格式如下：

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

下面通过一个完整案例，演示安装前测试、安装、升级和卸载：

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
   1:lrzsz-0.12.21-22.mga            ################################# [100%]
#卸载lrzsz工具
rpm -e lrzsz
```

> 💡 输出里的 `NOKEY` 警告表示该包没有用系统已信任的 GPG 密钥签名，不影响安装；在确定包来源可信的前提下可以忽略。

### 软件包依赖关系

早期装软件很费劲：管理员得下载源码、编译，还要为系统做各种调整。源码编译虽提高了定制自由度，但在小软件上耗费精力并不划算，于是软件包应运而生。

软件包管理把管理员从无休止的兼容问题中解放出来——yum 能自动搜索依赖并完成安装。而 rpm 包的依赖关系，是由包的作者在制作时定义的：

```plain
必须解决依赖关系，软件才能正常工作
```

原截图是一个文本界面的包管理工具，展示了 `shutter` 包的依赖树：它直接或间接依赖了 ImageMagick-perl、ImageMagick、glibc、perl、bash 等众多软件包，层级关系如下：

```plain
shutter
 ├─ ImageMagick-perl
 │   ├─ ImageMagick
 │   │   └─ glibc
 │   │       ├─ basesystem
 │   │       ├─ glibc-common ──▶ bash
 │   │       ├─ libselinux
 │   │       └─ tzdata
 │   ├─ libgcc ──▶ nss-softokn-freebl
 │   └─ perl ──▶ perl-Carp
 └─ bash
```

#### 自动解决依赖关系的软件包管理器

主流发行版都有能自动解决依赖的"上层"包管理器：

| 工具 | 适用包 / 发行版 |
| --- | --- |
| yum | 红帽系列的 rpm 包 |
| apt-get | Debian / Ubuntu 的 deb 包 |
| zypper | SUSE 的 rpm 包 |

Windows 上也有类似思路的图形化工具：原截图是"360 软件管家"，提供软件大全、软件升级、软件卸载、软件体检等功能，在排行榜上点"一键安装 / 一键升级"即可，底层同样是自动处理依赖。

Linux 上对应的是 yum 机制。原截图展示了它的整体结构：一台 **Yum 软件仓库服务器**通过网络同时给多个**客户端**提供软件包，客户端本地用 cache 缓存数据，仓库地址则通过配置文件 `/etc/yum.repos.d/*.repo` 指定：

```plain
                ┌──────────────────────────┐
                │   Yum 软件仓库服务器       │
                │   RPM 包 + 依赖元数据      │
                └─────────────┬────────────┘
                              │  HTTP / FTP
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
      ┌─────────┐         ┌─────────┐         ┌─────────┐
      │ 客户端   │         │ 客户端   │         │ 客户端   │
      │ cache   │         │ cache   │         │ cache   │
      └─────────┘         └─────────┘         └─────────┘

客户端通过配置文件 /etc/yum.repos.d/*.repo 指定仓库地址
```

**yum** 是 Fedora、RedHat 以及 SUSE/CentOS 中基于 rpm 的软件包管理器，能让管理员交互式或自动化地维护、管理 RPM 软件包：它从指定的服务器自动下载 RPM 包并安装，自动处理依赖关系，一次装齐所有依赖，不必再繁琐地一个个下载、安装。

RPM 虽然能查询依赖关系，但依赖仍要运维自己动手解决，大型软件可能依赖数十个程序，手工安装非常痛苦。Yum 软件仓库正是为进一步降低安装难度而设计的：它根据需求分析出所需软件包及依赖，自动从服务器下载并安装。仓库里的 RPM 包可以是红帽官方发布的、第三方发布的，也可以是自己制作的。

> 📌 一句话记忆：**rpm 负责单个包的安装与查询，yum 在 rpm 之上自动解决依赖；yum 的软件来源就是 yum 仓库（repository）。**

#### yum 工具

- yum 全称为 **Yellow dog Updater, Modified**，是 Fedora、RedHat、CentOS 中基于 RPM 的 Shell 前端软件包管理器，能从指定服务器自动下载 RPM 包并安装、自动处理依赖，无须一次次手工下载。
- yum 就是为了解决依赖关系而存在的：yum 源相当于一个目录项，安装软件时，yum 按照源中定义好的路径查找并安装依赖包。
- 基本工作机制分两端：**服务器端**存放所有 RPM 包，并分析每个 RPM 的依赖关系、把结果记录成元数据文件放在特定目录；**客户端**安装软件时，先通过 WWW 或 FTP 下载依赖关系元数据，分析后把所有相关软件一次全部下载安装。
- yum 仓库（Yum repository）存储了众多软件包及相关元数据，可以通过多种协议提供：

| 协议 | 前缀示例 |
| --- | --- |
| FTP | `ftp://` |
| HTTP | `http://` |
| NFS | `nfs://` |
| 本地文件 | `file://` |

yum 可以同时配置多个仓库，自动选择软件最新、离客户端最近的仓库下载。

yum 本身其实也是一个 rpm 软件，可以用 rpm 查询：

```plain
#yum其实也是一个rpm软件
[root@chaogelinux pyrpm]# rpm -qa yum
yum-3.4.3-163.el7.centos.noarch
```

#### yum 客户端

`/etc/yum.conf` 为所有仓库提供公共配置，下面这份文件里带注释列出了缓存目录、日志路径、签名校验等默认设置：

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

#### repo 仓库文件

原截图左边是浏览器打开 `mirrors.aliyun.com/centos/7/` 看到的目录列表（`atomic/`、`centosplus/`、`cloud/`、`extras/`、`os/`、`updates/`、`virt/` 等），右边是 `/etc/yum.repos.d/CentOS-Base.repo` 的内容，红线把两者对应起来：repo 文件里的 `[base]`、`[updates]`、`[extras]` 段，分别指向镜像站上的 `os/`、`updates/`、`extras/` 目录：

| repo 文件中的段 | 对应镜像站目录 | 提供内容 |
| --- | --- | --- |
| `[base]` | `os/$basearch/` | 系统基础软件包 |
| `[updates]` | `updates/$basearch/` | 已发布的升级更新包 |
| `[extras]` | `extras/$basearch/` | 额外附加软件包 |

完整的仓库配置文件写法如下，每个字段的含义都在注释里：

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

也可以自定义一个简单的 repo 文件：

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

#### 配置 yum 源

常用的镜像源站点：

- [http://mirrors.163.com/](http://mirrors.163.com/)
- [https://opsx.alibaba.com/mirrors](https://opsx.alibaba.com/mirrors)

更换为阿里云源的完整步骤（备份、下载 repo 文件、重建缓存、配置 EPEL 等）：

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

搜狐镜像站也可以作为选择：[http://mirrors.sohu.com/](http://mirrors.sohu.com/)

#### yum 命令

yum 的完整子命令、常用操作、命令行选项和 repo 文件变量如下：

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

### systemctl 命令

systemd 是 Linux 下的一款系统和服务管理器，兼容 SysV 和 LSB 的启动脚本。它的主要特性有：支持并行化任务；同时采用 socket 式与 D-Bus 总线式激活服务；按需启动守护进程（daemon）；利用 Linux 的 cgroups 监视进程；支持快照和系统恢复；维护挂载点和自动挂载点；各服务间基于依赖关系进行精密控制。

相关的旧命令是 `service`、`chkconfig`，新旧指令对比如下：

| 任务 | 旧指令 | 新指令 |
| --- | --- | --- |
| 使某服务自动启动 | chkconfig --level 3 httpd on | systemctl enable httpd.service |
| 使某服务不自动启动 | chkconfig --level 3 httpd off | systemctl disable httpd.service |
| 检查服务状态 | service httpd status | systemctl status httpd.service（服务详细信息） systemctl is-enabled httpd.service（仅显示是否 Active） |
| 显示所有已启动的服务 | chkconfig --list | systemctl list-units --type=service |
| 启动某服务 | service httpd start | systemctl start httpd.service |
| 停止某服务 | service httpd stop | systemctl stop httpd.service |
| 重启某服务 | service httpd restart | systemctl restart httpd.service |
| 某服务重新加载配置文件 | service httpd reload | systemctl reload httpd.service |

### 源代码编译安装

无论是 rpm 命令还是 yum 命令，安装的都是别人编译好的二进制格式程序包：

```plain
mysql-xx.rpm
redis-xx.rpm
nginx-xx.rpm
```

这种方式可能存在的问题是：别人提供的 rpm 包版本往往较低，不一定满足我们现有的需求。

#### yum 和编译安装的区别

yum 安装的优缺点：

| 方面 | 说明 |
| --- | --- |
| 优点 | 自动去 yum 源寻找 rpm 包下载安装，自动解决依赖、自动指定安装路径，无须人为干预 |
| 优点 | 适合初学者，不用考虑依赖即可安装使用大部分软件 |
| 缺点 | 功能由 rpm 包控制，包也是别人编译好的，版本可能较低、功能受限，甚至存在漏洞 |
| 缺点 | 不能自定义安装路径与功能；机器数量较多时，后期维护成本较大 |

编译安装的优缺点：

| 方面 | 说明 |
| --- | --- |
| 优点 | 可手动下载最新源代码，按需设置参数、指定安装路径、扩展第三方功能，更加灵活 |
| 缺点 | 无法自动解决依赖关系，对新手不友好 |

建议的方式：

```plain
yum和编译安装结合使用，能够最大程度解决问题
```

#### 编译三部曲

开始编译前，要先准备好开发工具和开发环境：

```plain
开发工具：gcc make等
开发组件：
yum groupinstall "Development Tools"
yum groupinstall "Server Platform Development"
```

原截图是 C 程序从源代码到可执行文件的完整处理流程，涉及预处理器、编译器、汇编器、链接器四类工具：

```plain
源文件      预处理       纯 C      编译器     汇编程序    汇编器    目标文件    链接器
 .c ──cpp──▶ .c ──cc──▶ .s ──as──▶ .o ──ld──▶ 可执行文件
                                            ▲
                                      库文件 .a
```

第一曲，执行脚本 `configure` 文件：

```plain
./configure --prefix=软件安装路径
针对C、C++代码，进行编译安装，需要指定配置文件`Makefile`，需要通过`configure`脚本生成
通过选项传递参数，指定启用特性、安装路径等<执行时会生成makefile
检查依赖到的外部环境
```

第二曲，执行 make 命令：

```plain
make是Linux开发套件里面自动化编译的一个控制程序，他通过借助 Makefile 里面编写的编译规范进行自动化的调用 gcc 、ld 以及运行某些需要的程序进行编译的程序。一般情况下，他所使用的 Makefile 控制代码，由 configure 这个设置脚本根据给定的参数和系统环境生成。
make这一步就是编译，大多数的源代码包都经过这一步进行编译（当然有些perl或python编写的软件需要调用perl或python来进行编译）
make 的作用是开始进行源代码编译，以及一些功能的提供，这些功能由他的 Makefile 设置文件提供相关的功能，比如 make install 一般表示进行安装，make uninstall 是卸载，不加参数就是默认的进行源代码编译。
```

第三曲，开始安装 make install：

```plain
开始安装软件到./configure指定的安装路径
```

> 📌 一句话记忆：**编译三部曲 = `./configure`（传参数、查依赖、生成 Makefile）→ `make`（按 Makefile 编译）→ `make install`（拷贝文件到安装目录）。**

#### 源码编译安装 nginx

下面以编译安装 nginx 1.12.0 为例，走一遍完整流程，包括编译环境准备、编译三部曲和安装后的环境变量配置：

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

> ⚠️ 注意上面示例里安装前缀出现了 `nginx112` 和 `ngx112` 两种写法。实际操作时，启动路径和 PATH 必须与第 5 步 `--prefix` 指定的目录保持一致，否则会找不到程序。

#### 环境变量配置文件

Shell 相关的几个环境变量配置文件，作用范围和执行时机各不相同：

| 文件 | 作用范围 | 读取时机 |
| --- | --- | --- |
| `/etc/profile` | 系统全局，所有用户 | 登录（login）时执行，并从 `/etc/profile.d` 加载配置 |
| `~/.profile` | 当前用户 | 登录时执行一次，默认会调用 `~/.bashrc` |
| `~/.bashrc` | 当前用户 | 登录时以及每次打开新 shell 时读取 |
| `~/.bash_logout` | 当前用户 | 每次退出 bash shell 时执行，常放清理命令 |

各文件的详细说明及登录 shell 的执行顺序：

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

---

> 更新: 2021-01-17 12:14:03  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/fg42uf>
