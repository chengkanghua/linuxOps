# 第十三章·Linux软件管理-RPM工具

## RPM基础概述

| 什么是rpm |
| :--- |

RPM全称`RPM Package Manager`缩写，由红帽开发用于软件包的安装，升级卸载与查询

| 为什么要学rpm |
| :--- |

就像在windows系统中一样，如果你想要安装一个`QQ`，安装一个`微信`，安装一款`游戏`，首先要去该软件的官网上去下载相关的软件包，通常都是`.exe`的安装包。还有那种绿色软件包，一下载下来，解压开就能使用无需安装。

那么Linux中也有很多种类的安装包，我们在Linux上也需要安装软件，软件包的种类也有很多，但是最方便，最简单，最简易，速度最快的，也就是`rpm`包了。

RPM包长啥样呢？

下面请看大屏幕...

| rpm包的命名规则 |
| :--- |

当我们拿到一个软件包的时候，我们需要对rpm包有基本的认识。`bash-4.2.46-28.el7.x86_64.rpm`

<!-- OCR_START -->
- 发布次数
- 硬件平台
- bash-4.2.46-28.el7.x86_64.rpm
- 软件名称
- 版本号
- 扩展名，表示适
- 用于64位系统
<!-- OCR_END -->

> name: 软件包名称
>
> version: 版本号, 主版本, 重大更新. 次版本, 子功能更新. 修订号, 修复bug
>
> release: 发布版本 el6, el7 (hostnamectl)
>
> arch: 系统平台, i386、x86_64(hostnamectl)

rpm包的组成:

> 安装释放的文件
>
> 软件包的元数据(版本,发布号,架构,描述,要求,更改日志等)
>
> 脚本:安装前执行的脚本和安装后的脚本

| Linux中的软件包类型 |
| :--- |

| 分类 | 安装 | 版本 |
| :--- | :--- | :--- |
| rpm包 | 预先编译打包,安装简单 | 软件版本偏低 |
| 源码包 | 手动编译打包,安装繁琐 | 软件版本随意 |
| 二进制包 | 解压即可使用, 安装简单 | 不能修改源码 |

> 注意: 不管是源码包，还是二进制包,安装时都可能会有依赖关系!

| 系统平台 | 包类型 | 工具 | 自动解决依赖 |
| :--- | :--- | :--- | :--- |
| RedHat/Centos | RPM | rpm | yum |
| Ubuntu/Debian | DPKG | dpkg | apt |

| RPM软件包的获取途径 |
| :--- |

> 1.`RedHat`光盘或[官方网站](ftp://ftp.redhat.com/) （通过挂载的方式访问）
>
> 2.`RPM`查询[官网网站](http://rpmfind.net/)
>
> 3.`Nginx`软件[官方网站](https://www.nginx.org/)
>
> 4.`MySQL`软件[官方网站](https://www.mysql.com/)

在我们刚开始学习rpm包时，建议先使用本地CentOS7的镜像，但实际生产环境中，都是通过联网的方式获取rpm包。

我们先通过虚拟机加载镜像，然后再linux中执行`mount /dev/cdrom /mnt`此时会在`/mnt/packages`目录下看到很多rpm的包文件，那么久可以开始rpm包管理之旅了。

```bash
[root@localhost ~]# mount /dev/cdrom /mnt/
mount: block device /dev/sr0 is write-protected, mounting read-only
[root@localhost ~]# ls /mnt/
CentOS_BuildTag  Packages                    RPM-GPG-KEY-CentOS-Security-6
EULA             RELEASE-NOTES-en-US.html    RPM-GPG-KEY-CentOS-Testing-6
GPL              repodata                    TRANS.TBL
images           RPM-GPG-KEY-CentOS-6
isolinux         RPM-GPG-KEY-CentOS-Debug-6
[root@localhost ~]# ls /mnt/Packages/|head
```

## RPM包安装管理

| RPM包安装命令 |
| :--- |

使用`rpm`命令安装软件包, 需要了解如下参数:

```bash
-i:         #安装
-v:         #详细信息
-h:         #安装进度 
--test:     #测试是否能够安装成功
--force:    #强制重新安装
--nodeps:   #忽略依赖关系
#安装软件包, 需要指定软件包绝对路径
[root@zls ~]# rpm -ivh /mnt/Packages/tree-1.6.0-10.el7.x86_64.rpm
[root@zls ~]# rpm -ivh /mnt/Packages/vsftpd-3.0.2-22.el7.x86_64.rpm
#在软件包所在目录下可以不指定绝对路径
[root@zls ~]# cd /mnt/Packages/
[root@zls Packages]# rpm -ivh zsh-5.0.2-28.el7.x86_64.rpm
#测试一个软件包是否能在该系统上安装
[root@zls ~]# rpm -ivh --test /mnt/Packages/vsftpd-3.0.2-22.el7.x86_64.rpm
#如果软件包存在, 强制再次安装
[root@zls ~]# rpm -ivh --force /mnt/Packages/tree-1.5.3-3.el6.x86_64.rpm
#安装samba服务需要依赖其他组件, 使用--nodeps可重新强制安装
[root@zls ~]# rpm -ivh --nodeps  /mnt/Packages/tree-1.6.0-10.el7.x86_64.rpm
```

| RPM包查询命令 |
| :--- |

使用`rpm`命令查询已安装好的rpm包, 需要了解如下参数:

```bash
rpm -q      #查看指定软件包是否安装
rpm -qa     #查看系统中已安装的所有RPM软件包列表
rpm -qi     #查看指定软件的详细信息
rpm -ql     #查询指定软件包所安装的目录、文件列表
rpm -qc     #查询指定软件包的配置文件
rpm -qd     #查询指定软件包的帮助文档
rpm -qf     #查询文件或目录属于哪个RPM软件
rpm -q --scripts    #查询rpm包安装前和安装后执行的脚本
#查询未安装的软件包信息
rpm -qip    //查询未安装的rpm包详细信息
rpm -qlp    //查询未安装的软件包会产生哪些文件
#查询vsftpd这个rpm包是否安装
[root@zls ~]# rpm -q vsftpd
#模糊查找系统已安装的rpm包
[root@zls ~]# rpm -qa |grep ftp
#查询vsftpd软件包的相关信息
[root@zls ~]# rpm -qi vsftpd
#查询rpm包所安装的文件
[root@zls ~]# rpm -ql vsftpd
#查询rpm包相关的配置文件
[root@zls ~]# rpm -qc vsftpd
#查询配置文件或命令来自于哪个rpm包
[root@zls ~]# rpm -qf /etc/vsftpd/vsftpd.conf
[root@zls ~]# rpm -qf /usr/sbin/vsftpd
//查询未安装的软件包会产生哪些文件
[root@zls ~]# rpm -qlp /mnt/Packages/samba-3.6.23-41.el6.x86_64.rpm
//查询未安装的软件包会产生哪些文件
[root@zls ~]# rpm -qip /mnt/Packages/samba-3.6.23-41.el6.x86_64.rpm
#以上查询只能查询已存在 已安装的包，如果没有安装，需要联网查询
[root@db04 ~]# yum provides zip
[root@db04 ~]# yum provides */ifconfig
Loaded plugins: fastestmirror, security
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
base/filelists_db                                                                                                                                                                                                      | 6.4 MB     00:00
epel/filelists_db                                                                                                                                                                                                      | 7.9 MB     00:00
extras/filelists_db                                                                                                                                                                                                    |  24 kB     00:00
updates/filelists_db                                                                                                                                                                                                   | 3.6 MB     00:00
net-tools-1.60-114.el6.x86_64 : Basic networking tools
Repo        : base
Matched from:
Filename    : /sbin/ifconfig
```

***

| RPM包升级命令 |
| :--- |

-U 如果老版本不存在，就全新安装，如果存在有新版即升级

-f 老版本必须存在

如果有新版则升级, 软件升级不要跨操作系统主版本号

```bash
[root@zls ~]# rpm -Uvh /mnt/Packages/tree-1.6.0-10.el7.x86_64.rpm
```

| RPM包卸载命令 |
| :--- |

卸载包时需要先把依赖的包卸载掉，如果依赖的包是系统所必须的，那就不能卸载这个包，否则会造成系统崩溃。

```bash
//先查询, 然后卸载 
[root@zls ~]# rpm -qa |grep sh
[root@zls ~]# rpm -e zsh
```

> 更新: 2024-09-20 22:15:59  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/zgzhka>