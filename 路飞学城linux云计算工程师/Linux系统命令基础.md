# Linux 系统命令基础

> 前面咱们已经成功安装了 Linux 系统——CentOS 7。从这一章开始，跟着超哥一起奔向 Linux 命令行的世界。
>
> 本篇前半部分讲命令行长什么样、Linux 的目录树和挂载概念；后半部分逐个练习文件和目录管理的高频命令，最后聊帮助命令、开关机、快捷键、环境变量、路径概念，以及 Linux 的开机启动流程。

## 本章目录

**第一篇 · 命令基础与目录结构**
- 一、Linux 命令格式
- 二、Linux 命令行提示符
- 三、操作系统目录分隔符
- 四、Linux 与 Windows 的目录结构比较
- 五、图解 Linux 与 Windows 目录
- 六、Linux 目录挂载
- 七、为什么要学 Linux 命令

**第二篇 · 文件及目录管理命令**
- 八、文件目录命令总览
- 九、cd 命令：切换目录
- 十、tree 命令：树形展示
- 十一、ls 命令：查看目录内容
- 十二、mkdir 命令：创建目录
- 十三、touch 命令：创建文件 / 修改时间戳
- 十四、cp 命令：复制
- 十五、mv 命令：移动与重命名
- 十六、rm 命令：删除

**第三篇 · 帮助、开关机与 Shell 基础**
- 十七、Linux 帮助命令
- 十八、Linux 开关机命令
- 十九、Linux 命令行常用快捷键
- 二十、Linux 的环境变量
- 二十一、绝对路径与相对路径

**第四篇 · 系统文件与启动流程**
- 二十二、系统重要文件路径
- 二十三、Linux 开机启动流程

---

# 第一篇 · 命令基础与目录结构

## 一、Linux 命令格式

一条 Linux 命令的通用写法是：**命令 + 条件/参数 + 对象（文件或目录）**，各部分之间用空格隔开。超哥用一张搞笑的"结婚"表格帮你记住这个结构：

| 命令 | 空格 | 条件/参数 | 空格 | 对象/文件/目录 |
| --- | --- | --- | --- | --- |
| 结婚 | 空格 | -有车有房有存款 | 空格 | 白富美 |
| 结婚 | 空格 | -没有车有房有存款 | 空格 | 是个女的就行 |
| rm | 空格 | -f | 空格 | /tmp/oldboy.txt |

对应到真实命令，最后一行就是 `rm -f /tmp/oldboy.txt`：`rm` 是命令，`-f` 是参数，`/tmp/oldboy.txt` 是要处理的对象。

1. 一般情况下，【参数】是可选的，一些情况下【文件或路径】也是可选的

2. 参数 > 同一个命令，跟上不同的参数执行不同的功能

执行linux命令，添加参数的目的是让命令更加贴切实际工作的需要！

linux命令，参数之间，普遍应该用一个或多个空格分割！

> 💡 参数通常以一个短横杠 `-` 开头（短格式，如 `-f`），两个短横杠 `--` 开头的是长格式（如 `--force`）。很多命令两者等价，先记住常用的短格式即可。

## 二、Linux 命令行提示符

登录系统后，终端里最先看到的就是一行**命令提示符**。以 `[root@oldboy_python ~]#` 为例，每一部分都有含义：

| 组成部分 | 图中内容 | 含义 |
| --- | --- | --- |
| 用户名 | root | 我是谁？（当前登录的用户） |
| @ | @ | 分隔符（戏称"三八线"） |
| 主机名 / 机器名 | oldboy_python | 这台机器叫什么 |
| 路径 | ~ | 你当前在哪？（`~` 代表家目录） |
| 提示符 | # | `#` 表示超级用户，`$` 表示普通用户 |

再看一遍普通用户和超级用户提示符的区别：

```plain
命令提示符
[py@pylinux ~]$            普通用户py，登陆后
[root@pylinux ~]#        超级用户root，登录后
root代表当前登录的用户
@ 分隔符
pylinux 主机名
~  当前的登录的位置，此时是家目录
# 超级用户身份提示符
$ 普通用户身份提示符
```

> 📌 记住一个安全常识：看到 `#` 要格外小心，你现在是 root，敲下的每一条命令都可能直接影响整台机器。

## 三、操作系统目录分隔符

*Windows 平台命令行目录分隔符：*

```plain
C:\Users\yuchao\oldboy>
```

Windows 以**反斜杠** `\` 分割目录。

*Linux 平台命令行目录分隔符：*

```plain
[root@pylinux /opt/python37]#
```

Linux 系统以**正斜杠** `/` 分割目录。

> ⚠️ 初学最容易犯的错就是斜杠写反。记住：Linux 世界里路径一律用正斜杠 `/`，而且第一个 `/` 是根目录。

## 四、Linux 与 Windows 的目录结构比较

Linux首先是建立一个根"/"文件系统，所有的目录也都是由根目录衍生出来。

登录系统后，在当前命令窗口输入命令:

```plain
ls /
```

这个命令用来查看根目录下都有什么，输出如下：

```plain
[root@pylinux ~]# ls /
bin dev home lib64 mnt proc run srv tmp var
boot etc lib media opt root sbin sys usr
```

在Linux底下，所有的文件与目录都是由根目录开始，是目录与文件的源头，然后一个个的分支下来，如同树枝状，因此称为这种目录配置为：**目录树**。

目录树的特点是什么呢？

* 目录树的起始点是根目录(/,root);
* 每一个目录不止能使用本地的文件系统，也可以使用网络上的文件系统，可以利用NFS服务器挂载特定目录。
* 每一个文件在此目录树中的文件名，包含完整路径都是独一无二的。

## 五、图解 Linux 与 Windows 目录

*Linux与windows区别*

* windows特点:E:\学习视频\高清视频\\
* Linux目录特点:/etc/hosts /root/data/oldboy.txt

下图是两边目录结构的对比，先用 ASCII 图还原一下。

**Windows：每个盘符都是一棵独立的树，C 盘、D 盘、E 盘平级。**

```plain
C盘 ── windows 文件夹
   └─ 软件 文件夹
D盘 ── 视频 文件夹
E盘 ── 学习视频 ── 高清视频
```

**Linux：只有一棵倒挂的树，一切从根 `/` 开始。**

```plain
/（根目录）
├── oldboy/ ── peng/ ── zhi/ ── li/
├── data/   ── sysconfig ── network-scripts ── ifcfg-eth0
├── etc/    ── hosts
└── root/   ── data/ ── oldboy.txt
```

**Linux** 系统目录结构基本特点：

1.Linux下一切从`根`开始

2.Linux下面的目录是一个有层次的目录结构

3.在linux中每个目录可以挂载到不同的设备(磁盘)上

4.Linux 下设备不挂载不能使用，不挂载的设备相当于没门没窗户的监狱(进不去出不来)，挂载相当于给设备创造了一个入口(挂载点，一般为目录)

## 六、Linux 目录挂载

**挂载**通常是将一个`存储设备`挂接到一个已经存在的`目录`上，访问这个`目录`就是访问该存储设备的内容。

对 Linux 来说**一切皆文件**：所有文件都放在以根目录为起点的树形目录结构中，硬件设备也以文件形式存在。

挂载之前，Linux 自己的文件系统和 U 盘的文件系统是两套互相独立的结构：

```plain
a) Linux 系统文件目录（一部分）           b) U 盘文件系统目录
          /                                     /sdb1
     ┌────┼────┬─────┐                     ┌───┼───┐
   /bin /home /lib  /usr ...              /a  /b  /c ...
```

如图所示，是U盘存储设备和Linux系统自己的文件系统结构，此时Linux想要使用U盘的硬件设备，必须将Linux`本身的目录`和硬件设备的文件目录合二为一，此过程就称之为`挂载`。

```plain
挂载操作会隐藏原本Linux目录中的文件，因此选择Linux本身的目录，最好是新建空目录用于挂载
挂载之后，这个目录被称为挂载点
```

挂载之后，两套结构合成了一套，U 盘文件系统成为 Linux 目录树的一根新"树枝"：

```plain
          /
     ┌────┼────┬────┬─────────────────┐
   /bin /home /lib  /usr   /sdb-u(sdb1)
                              ├── /a
                              ├── /b
                              └── /c ...
```

此时 U 盘文件系统已成为 Linux 文件系统的一部分，访问 `/sdb-u` 文件夹即是访问 U 盘中的文件夹。

根目录下这些常见目录分别是干什么的，先看一张总览图，后面还有逐个的详细说明：

| 目录 | 存放内容 |
| --- | --- |
| /dev | 存放抽象硬件 |
| /boot | 存放内核与启动文件 |
| /lib | 存放系统库文件 |
| /bin | 存放二进制文件（可执行命令） |
| /sbin | 存放特权级二进制文件 |
| /usr | 存放安装程序（软件默认目录） |
| /var | 存放经常变化的文件 |
| /mnt | 文件挂载目录（U 盘、光驱） |
| /home | 普通用户目录 |
| /root | 特权用户目录 |
| /etc | 存放配置文件目录 |
| /opt | 大型软件存放目录（非强制） |

* **/bin**：bin是Binary的缩写, 这个目录存放着最经常使用的命令。
* **/boot：**这里存放的是启动Linux时使用的一些核心文件，包括一些连接文件以及镜像文件。
* **/dev ：**dev是Device(设备)的缩写, 该目录下存放的是Linux的外部设备，在Linux中访问设备的方式和访问文件的方式是相同的。
* **/etc：**这个目录用来存放所有的系统管理所需要的配置文件和子目录。
* **/home**：用户的主目录，在Linux中，每个用户都有一个自己的目录，一般该目录名是以用户的账号命名的。
* **/lib**：这个目录里存放着系统最基本的动态连接共享库，其作用类似于Windows里的DLL文件。几乎所有的应用程序都需要用到这些共享库。
* **/lost+found**：这个目录一般情况下是空的，当系统非法关机后，这里就存放了一些文件。
* **/media**：linux系统会自动识别一些设备，例如U盘、光驱等等，当识别后，linux会把识别的设备挂载到这个目录下。
* **/mnt**：系统提供该目录是为了让用户临时挂载别的文件系统的，我们可以将光驱挂载在/mnt/上，然后进入该目录就可以查看光驱里的内容了。
* **/opt**： 这是给主机额外安装软件所摆放的目录。比如你安装一个ORACLE数据库则就可以放到这个目录下。默认是空的。
* **/proc**：这个目录是一个虚拟的目录，它是系统内存的映射，我们可以通过直接访问这个目录来获取系统信息。 这个目录的内容不在硬盘上而是在内存里，我们也可以直接修改里面的某些文件，比如可以通过下面的命令来屏蔽主机的ping命令，使别人无法ping你的机器：

```plain
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
```

* **/root**：该目录为系统管理员，也称作超级权限者的用户主目录。
* **/sbin**：s就是Super User的意思，这里存放的是系统管理员使用的系统管理程序。
* **/selinux**： 这个目录是Redhat/CentOS所特有的目录，Selinux是一个安全机制，类似于windows的防火墙，但是这套机制比较复杂，这个目录就是存放selinux相关的文件的。
* **/srv**： 该目录存放一些服务启动之后需要提取的数据。
* **/sys**：这是linux2.6内核的一个很大的变化。该目录下安装了2.6内核中新出现的一个文件系统 sysfs 。\
  sysfs文件系统集成了下面3种文件系统的信息：针对进程信息的proc文件系统、针对设备的devfs文件系统以及针对伪终端的devpts文件系统。该文件系统是内核设备树的一个直观反映。当一个内核对象被创建的时候，对应的文件和目录也在内核对象子系统中被创建。
* **/tmp**：这个目录是用来存放一些临时文件的。
* **/usr**：这是一个非常重要的目录，用户的很多应用程序和文件都放在这个目录下，类似于windows下的program files目录。
* **/usr/bin：**系统用户使用的应用程序。
* **/usr/sbin：**超级用户使用的比较高级的管理程序和系统守护程序。
* **/usr/src：**内核源代码默认的放置目录。
* **/var**：这个目录中存放着在不断扩充着的东西，我们习惯将那些经常被修改的目录放在这个目录下。包括各种日志文件。

在linux系统中，有几个目录是比较重要的，平时需要注意不要误删除或者随意更改内部文件。

**/etc： 上边也提到了，这个是系统中的配置文件，如果你更改了该目录下的某个文件可能会导致系统不能启动。**

**/bin, /sbin, /usr/bin, /usr/sbin: 这是系统预设的执行文件的放置目录，比如 ls 就是在/bin/ls 目录下的。**

**值得提出的是，/bin, /usr/bin 是给系统用户使用的指令（除root外的通用户），而/sbin, /usr/sbin 则是给root使用的指令。**

**/var： 这是一个非常重要的目录，系统上跑了很多程序，那么每个程序都会有相应的日志产生，而这些日志就被记录到这个目录下，具体在/var/log 目录下，另外mail的预设放置也是在这里。**

## 七、为什么要学 Linux 命令

* Linux从诞生就是黑屏界面，所有操作倚靠命令完成，如磁盘读写、文件操作、网络管理等
* 企业中，服务器的维护工作都是`ssh客户端`完成，没有图形界面
* 程序员想要管理linux服务器，必须学习常用命令

*Linux命令学习方法*

* 熟能生巧，多敲打，多练习即可
* 不可能一下子掌握所有命令用法，学会使用搜索引擎查阅命令资料

**当年超哥在一家美资企业，一位台湾老程序员送我的一本书。。。**

**可能是看我骨骼惊奇吧！！**

那本书叫《100 个 UNIX 最常用的指令》：封面从上到下铺满密密麻麻的命令名，底部画着键盘和鼠标，出版方是和硕科技文化有限公司。想表达的意思很直接——日常高频使用的命令也就百来个，不用被命令数量吓到。

---

# 第二篇 · 文件及目录管理命令

## 八、文件目录命令总览

文件和目录管理最基础的六条命令：

| 命令 | 对应英文 | 作用 |
| --- | --- | --- |
| ls | list | 查看文件夹内容 |
| pwd | print work directory | 查看当前所在目录 |
| cd 目录名 | Change directory | 切换文件夹 |
| touch 文件名 | touch | 如果文件不存在，则创建 |
| mkdir 目录名 | Make directory | 创建目录 |
| rm 文件名 | Remove | 删除指定文件 |

我们知道切换目录的指令是cd，那么首先得知道如何切换目录，这个得用心记呀！

```plain
.    当前目录
..    上一层目录
-    前一个工作目录
~    当前【用户】所在的家目录
/            顶级根目录
```

> 📌 这五个特殊路径是后面所有目录操作的基础，尤其是 `.`、`..`、`~`，务必记牢。

## 九、cd 命令：切换目录

cd是change directory的缩写，这是用来变换工作目录的命令，注意命令和目录之间有一个空格。

下面是超哥在终端里演示的几种常见用法，对照右侧说明看：

| 执行的操作 | 作用 |
| --- | --- |
| `cd ~` | 进入用户家目录 |
| `pwd`（输出 `/root`） | 打印当前目录 |
| `cd` | 不加任何路径，也代表进入家目录 |
| `cd ..` | 去往上一级目录 |
| `cd -`（输出 `/root`） | 返回刚才的目录 |
| `cd /home/` | 进入 /home 目录 |
| `cd ../`（在 /home 下执行） | 进入指定的上一层目录 |

需要注意的是，在所有目录底下都存在两个目录，分别是【.】和【..】，分别代表当前目录，上层目录！那么如何证明它的存在呢？

```plain
命令： ls -la /
查看命令解释：man ls  (Linux下的帮助指令)
结论：ls - list directory contens (列出目录内容)
ls -la /  以竖状格式化显示列出/目录所有内容
```

执行后的完整输出如下，注意最上面的 `.` 和 `..` 两行——任何目录下都有它们：

```plain
[root@localhost ~]# ls -la /
total 16
dr-xr-xr-x.  17 root root  224 Jul 16 00:17 .
dr-xr-xr-x.  17 root root  224 Jul 16 00:17 ..
lrwxrwxrwx.   1 root root    7 Jul 16 00:13 bin -> usr/bin
dr-xr-xr-x.   5 root root 4096 Jul 16 00:18 boot
drwxr-xr-x.  21 root root 3280 Jul 16 00:19 dev
drwxr-xr-x.  75 root root 8192 Jul 16 00:19 etc
drwxr-xr-x.   2 root root    6 Apr 11 12:59 home
lrwxrwxrwx.   1 root root    7 Jul 16 00:13 lib -> usr/lib
lrwxrwxrwx.   1 root root    9 Jul 16 00:13 lib64 -> usr/lib64
drwxr-xr-x.   2 root root    6 Apr 11 12:59 media
drwxr-xr-x.   2 root root    6 Apr 11 12:59 mnt
drwxr-xr-x.   2 root root    6 Apr 11 12:59 opt
dr-xr-xr-x. 109 root root    0 Jul 16 00:19 proc
dr-xr-x---.   2 root root  114 Jul 16 00:18 root
drwxr-xr-x.  23 root root  680 Jul 16 12:51 run
lrwxrwxrwx.   1 root root    8 Jul 16 00:13 sbin -> usr/sbin
drwxr-xr-x.   2 root root    6 Apr 11 12:59 srv
dr-xr-xr-x.  13 root root    0 Jul 16 00:19 sys
drwxrwxrwt.   8 root root  151 Jul 16 12:51 tmp
drwxr-xr-x.  13 root root  155 Jul 16 00:13 usr
drwxr-xr-x.  19 root root  267 Jul 16 00:19 var
```

> 💡 这是 CentOS 7 的输出：`bin`、`sbin`、`lib`、`lib64` 都变成了软链接，指向 `usr/` 下的同名目录，所以你会看到 `bin -> usr/bin` 这样的箭头。

## 十、tree 命令：树形展示

以树形结构显示目录下内容。它展示的层级关系大致是这个样子：

```plain
.
├── 一级目录1
├── 一级目录2
│   ├── 二级目录2.1
│   └── 二级目录2.2
└── 一级目录3
    ├── 二级目录3.1
    ├── 二级目录3.2
    └── 二级目录3.3
        ├── 三级目录3.3.1
        └── 三级目录3.3.2
```

tree命令可能要单独安装：

**yum install tree -y**

```plain
tree命令语法：
tree常用参数
-C 在文件和目录清单加上色彩，便于区分各种类型。
-d 显示目录名称而非内容。
-D 列出文件或目录的更改时间。
-f 在每个文件或目录之前，显示完整的相对路径名称。
-F 在条目后加上文件类型的指示符号(* ， /， = ， @ ， | ，其中的一个) 目录/
```

## 十一、ls 命令：查看目录内容

显示目录下内容及属性信息的命令

```plain
-a 显示指定目录下所有子目录与文件，包括以.开头的隐藏文件
-l 以列表方式显示文件的详细信息   ls -l 等于ll 用法
-h, --human-readable          与-l 一起，以易于阅读的格式输出文件大小
                                (例如 1K 234M 2G)
-t 根据最后修改时间排序，默认是以文件名排序，通常与-l 连用
-F 在条目后加上文件类型的指示符号(* ， /， = ， @ ， | ，其中的一个)
    注:可以标识文件类型
    加上 * 代表可执行的普通文件
    加上 = 表示套接字
    加上 | 表示FIFOS(队列系统)
  加上 @表示符号链接
  加上 / 表示文件夹
-d 显示目录本身的信息 而不是显示目录的内容
-r, --reverse                 逆序排列
-S                            根据文件大小排序,从大到小排序
-i 显示索引节点信息(索引节点相当于身份证号)
--full-time 以完整的时间格式输出(也就是按照中国的时间日期显示)
```

案例

```plain
ls -lt 按照时间进行排序
ls -lrt 找出最新的文件
ls -d */    列出当前所有目录
ll -hS    ./*    显示出当前目录下所有内容详细，且以kb,mb,gb单位从大到小排序
```

加上 `-F` 参数后，终端会用颜色和结尾符号直接告诉你文件类型。下图是某 bin 目录下执行 `ls -F` 的效果，归纳如下：

| 颜色与结尾 | 文件类型 | 图中例子 |
| --- | --- | --- |
| 深蓝色、以 `/` 结尾 | 文件夹 | __pycache__/ |
| 浅蓝色、以 `@` 结尾 | 链接文件（软链接） | 2to3@、python3-config@、pyvenv@、pydoc3@、python3@、idle3@、python3.7-config@ |
| 绿色、以 `*` 结尾 | 可执行文件 | f2py3.7*、flask*、pip3*、fandango*、django-admin*、glances*、virtualenv*、taurusgui* 等 |
| 白色、无特殊符号 | 普通文件 | heiheihei、django-admin.py |

> ⚠️ 注意 `django-admin.py` 虽然名字带 `.py`，但在图中是普通文件；文件类型看权限位和颜色，不靠后缀名判断，这点和 Windows 不一样。

## 十二、mkdir 命令：创建目录

创建文件夹

```plain
用法：mkdir [选项]... 目录...
若指定目录不存在则创建目录。
-m, --mode=模式       设置权限模式(类似chmod)，而不是rwxrwxrwx 减umask
-p, --parents         需要时创建目标目录的上层目录，但即使这些目录已存在也不当作错误处理
mkdir {1..3}加花括号创建连续的目录，用..隔开 花括号内可以是连续的数字、连续的字母mkdir {a..e}
```

案例

```plain
mkdir {alex,pyyu,mjj}  创建三个文件夹，逗号隔开
mkdir alex{1..5}    创建连续的目录
mkdir cunzhang longting  创建少量连续目录
```

在终端里逐条执行，再配合 `ls` 和 `tree` 看结果，过程如下：

```plain
[root@pylinux tmp]# mkdir alex{1..5}
[root@pylinux tmp]# ls
alex1  alex2  alex3  alex4  alex5
[root@pylinux tmp]# mkdir {alex,pyyu,mjj}
[root@pylinux tmp]# ls
alex  alex1  alex2  alex3  alex4  alex5  mjj  pyyu
[root@pylinux tmp]# mkdir cunzhang longting
[root@pylinux tmp]# ls
alex  alex1  alex2  alex3  alex4  alex5  cunzhang  longting  mjj  pyyu
[root@pylinux tmp]# mkdir -p ./boy/{mjj,cunzhang} ./girl/{longting}
[root@pylinux tmp]# ls
alex  alex1  alex2  alex3  alex4  alex5  boy  cunzhang  girl  longting  mjj  pyyu
[root@pylinux tmp]# tree
.
├── alex
├── alex1
├── alex2
├── alex3
├── alex4
├── alex5
├── boy
│   ├── cunzhang
│   └── mjj
├── cunzhang
├── girl
│   └── {longting}
├── longting
├── mjj
└── pyyu

15 directories, 0 files
```

> 💡 注意最后那个目录名真的是 `{longting}`：花括号里只有一个元素时不会做"展开"，bash 会把大括号原样当成目录名。想得到 `longting`，直接写 `./girl/longting` 即可，别手多加花括号。

## 十三、touch 命令：创建文件 / 修改时间戳

创建文件或修改文件时间戳

```plain
用法：touch [选项]... 文件...
将每个文件的访问时间和修改时间改为当前时间。
不存在的文件将会被创建为空文件，除非使用-c 或-h 选项。
touch {连续数字或字母} 创建多个文件序列
touch {1..10}
touch {a..z}
  -c, --no-create       不创建任何文件
  -t STAMP              使用[[CC]YY]MMDDhhmm[.ss] 格式的时间替代当前时间
  -r, --reference=文件  使用指定文件的时间属性替代当前文件时间
```

案例

用花括号一次性批量创建文件，`ls` 查看结果：

```plain
[root@pylinux tmp]# touch {1..5}
[root@pylinux tmp]# touch alex{1..5}
[root@pylinux tmp]# touch {001..5}
[root@pylinux tmp]# ls
001  002  003  004  005  1  2  3  4  5  alex1  alex2  alex3  alex4  alex5
```

```plain
修改文件时间
touch -t 06010808 alex1    #修改alex1文件的时间是 6月1号8点8分
touch -r alex1 alex2        #把alex2的时间改成alex1一样
```

> 💡 `{001..5}` 这种写法会自动补零，生成 `001`、`002` 这样等宽的文件名，批量排序时特别好用。

## 十四、cp 命令：复制

复制命令

windows复制

```plain
可以说是相当简单了
ctrl + c 复制
ctrl + v 黏贴
```

Windows 下还可以用鼠标右键点"复制"、再右键点"粘贴"，图形化操作非常直观。Linux 里没有这两个快捷键，复制要靠 `cp` 命令。

linux复制

```plain
用法：cp [选项]... [-T] 源文件 目标文件
　或：cp [选项]... 源文件... 目录
　或：cp [选项]... -t 目录 源文件...
将源文件复制至目标文件，或将多个源文件复制至目标目录。
-r 递归式复制目录，即复制目录下的所有层级的子目录及文件 -p 复制的时候 保持属性不变
-d 复制的时候保持软连接(快捷方式)
-a 等于-pdr
-p                等于--preserve=模式,所有权,时间戳，复制文件时保持源文件的权限、时间属性
-i, --interactive        覆盖前询问提示
```

案例

```plain
复制 > copy > cp
#移动xxx.py到/tmp目录下
cp xxx.py /tmp/
#移动xxx.py顺便改名为chaoge.py
cp xxx.py /tmp/chaoge.py
Linux下面很多命令，一般没有办法直接处理文件夹,因此需要加上（参数） 
cp -r 递归,复制目录以及目录的子孙后代
cp -p 复制文件，同时保持文件属性不变    可以用stat
cp -a 相当于-pdr
#递归复制test文件夹，为test2
cp -r test test2
cp是个好命令，操作文件前，先备份
cp main.py main.py.bak
移动多个文件，放入文件夹c中
cp -r  文件1  文件2  文件夹a   文件夹c
```

案例2

```plain
[root@pylinux opt]# cp luffy_boy.zip  luffy_boy.zip.bak2
cp：是否覆盖"luffy_boy.zip.bak2"？ y
[root@pylinux opt]# cp luffy_boy.zip  luffy_boy.zip.bak2 -i
cp：是否覆盖"luffy_boy.zip.bak2"？ y
cp确认是否覆盖是-i参数作用，默认alias因为添加了别名
[root@pylinux opt]# alias
alias cp='cp -i'
[root@pylinux opt]# cp luffyCity/ luffyCity2    #必须添加-r参数才可以复制递归目录
cp: omitting directory 'luffyCity/'
[root@pylinux opt]#
[root@pylinux opt]#
[root@pylinux opt]#
[root@pylinux opt]# cp -r luffyCity/ luffyCity2
[root@pylinux opt]#
[root@pylinux opt]#
[root@pylinux opt]# ls
luffyCity  luffyCity2
```

取消cp别名的方式

* 使用命令绝对路径
* 命令开头用反斜线 \
* 取消cp命令别名
* 写入环境变量配置文件

```plain
1.
[root@pylinux opt]# which cp
alias cp='cp -i'
    /usr/bin/cp
[root@pylinux opt]# /usr/bin/cp luffy_boy.zip luffy_boy.zip.bak
2.
[root@pylinux opt]# \cp luffy_boy.zip luffy_boy.zip.bak
3.
[root@pylinux opt]# unalias cp
[root@pylinux opt]#
[root@pylinux opt]# cp luffy_boy.zip luffy_boy.zip.bak
4.
[root@pylinux opt]# vim ~/.bashrc  #可以注释掉如下配置
# .bashrc
# User specific aliases and functions
alias rm='rm -i'
#alias cp='cp -i'
alias mv='mv -i'
```

快速备份配置文件

修改配置前先备份是个救命的好习惯。网卡配置文件路径很长、源和目标路径又重复，可以这样写：

```plain
[root@pylinux opt]# cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0.bak
[root@pylinux opt]# cp /etc/sysconfig/network-scripts/ifcfg-eth0{,.origin}
```

第二条用的是 Bash 的大括号展开语法：`ifcfg-eth0{,.origin}` 会被拆成 `ifcfg-eth0` 和 `ifcfg-eth0.origin` 两个路径，一条命令完成备份。备份后该目录下能看到三个文件：

```plain
ifcfg-eth0   ifcfg-eth0.bak   ifcfg-eth0.origin
```

## 十五、mv 命令：移动与重命名

下面这个命令能让文件"瞬间移动"——它就是 `mv`，负责移动文件，也负责给文件改名。

```plain
mv命令就是move的缩写，作用是移动或是重命名文件
用法：mv [选项]... [-T] 源文件 目标文件
　或：mv [选项]... 源文件... 目录
　或：mv [选项]... -t 目录 源文件...
将源文件重命名为目标文件，或将源文件移动至指定目录。
-f, --force                  覆盖前不询问
-i, --interactive            覆盖前询问
-n, --no-clobber             不覆盖已存在文件如果您指定了-i、-f、-n 中的多个，仅最后一个生效。
-t, --target-directory=DIRECTORY      将所有参数指定的源文件或目录移动至 指定目录
-u, --update                  只在源文件文件比目标文件新，或目标文件不存在时才进行移动
```

**mv移动|重命名**

判断 mv 到底是"移动"还是"重命名"，关键看**目标文件夹存不存在**。先准备环境并演示"目标存在 → 移动"：

```plain
[root@pylinux tmp]# mkdir -p alex/dsb
[root@pylinux tmp]# tree
.
└── alex
    └── dsb

2 directories, 0 files
[root@pylinux tmp]# mkdir lufficity
[root@pylinux tmp]# mv alex/ lufficity/
[root@pylinux tmp]# ls
lufficity
[root@pylinux tmp]# ls lufficity/
alex
```

目标文件夹存在，alex 被搬进了 lufficity 里面。再演示"目标不存在 → 重命名"：

```plain
[root@pylinux tmp]# mkdir -p alex/dsb
[root@pylinux tmp]# ls
alex  lufficity
[root@pylinux tmp]# mv alex/ oldboy_alex/
[root@pylinux tmp]# ls
lufficity  oldboy_alex
[root@pylinux tmp]# ls oldboy_alex/
dsb
```

目标文件夹不存在，alex 直接改名叫 oldboy_alex，里面的 dsb 原样保留。

mv案例

```plain
移动（搬家）命令  > move > mv
1.给文件重命名
mv abc  abc.py  
2.如果目标文件存在，-i参数则提示是否覆盖
mv test1.txt  test2.txt 
3.使用反斜杠命令屏蔽别名
\mv kunkun wuyifan
4.取消别名
5.移动单个文件
mv file1.txt  dir/
6.移动多个文件
mv file1.txt file2.txt dir/
7.通配符移动多个文件
mv dir/file*   ../
```

文件的改名和覆盖提示，终端里的实际效果如下：

```plain
[root@pylinux tmp]# touch caixukun
[root@pylinux tmp]# mv caixukun kunkun
[root@pylinux tmp]# ls
kunkun
[root@pylinux tmp]# touch wuyifan
[root@pylinux tmp]# touch kuanmian
[root@pylinux tmp]# mv wuyifan kuanmian
mv: 是否覆盖"kuanmian"?  n
```

目标文件 kunkun 不存在，mv 起改名作用；目标文件 kuanmian 已存在，默认的 `-i` 参数会提示是否覆盖。

## 十六、rm 命令：删除

Linux在使用rm（删除）、cp（覆盖）、mv（搬家）等命令的时候，必须非常小心，因为这些命令都是“炸弹”，想必大家都听过“删库到跑路”，一言不合“rm -rf /”，假如你真的这么做了，那么。。。上帝保佑你

网上有张漫画特别贴切：老板怒气冲冲举着手机对员工吼——"从现在开始，你不用再请假了！"没错，你被炒鱿鱼了。乱敲删除命令，真的可能是这个下场。

```plain
用法：rm [选项]... 文件...
删除 (unlink) 文件。
rm命令就是remove的含义，删除一个或者多个文件，这是Linux系统重要命令
-f, --force           强制删除。忽略不存在的文件，不提示确认
-i                    在删除前需要确认
-I                    在删除超过三个文件或者递归删除前要求确认。
-d, --dir    删除空目录
-r, -R, --recursive   递归删除目录及其内容
-v, --verbose         详细显示进行的步骤
      --help            显示此帮助信息并退出
      --version         显示版本信息并退出
```

案例

```plain
1.删除普通文件,需要确认提示,默认添加了-i参数
rm file1.txt
2.强制删除文件，不提示
rm -f file2.txt
3.递归删除文件夹
[root@pylinux tmp]# rm -r heh/
rm：是否进入目录"heh/"? y
rm：是否删除普通空文件 "heh/kuanmian2"？y
rm：是否删除普通空文件 "heh/kuanmian"？y
rm：是否删除目录 "heh/"？y
```

**炸弹命令**

务必看清楚敲打的命令，是否正确、不得有空格

务必看清楚敲打的命令，是否正确、不得有空格

务必看清楚敲打的命令，是否正确、不得有空格

```plain
1.强制删除且不让用户确认
rm -rf 文件夹
2.强制删除且显示过程
[root@pylinux tmp]# rm -rfv ./*
已删除"./456.txt"
已删除目录："./q/w/e/r/t/yt"
已删除目录："./q/w/e/r/t"
已删除目录："./q/w/e/r"
已删除目录："./q/w/e"
已删除目录："./q/w"
已删除目录："./q"
```

> ⚠️ `rm -rf` 默认不进回收站、删除即释放。敲回车前至少检查两件事：路径写没写对（尤其有没有多余空格）、当前在哪个目录。生产环境里涉及删除，先 `pwd` 和 `ls` 确认目标再动手。

**注意文件恢复**

rm命令删除文件后可以通过如ext3grep工具恢复数据，若是想要粉碎文件，还有其他方式

> 💡 所谓"恢复"有很强的前提：删除后该分区没有再写入新数据、文件系统类型受支持，而且很多时候要先把磁盘 umount 下来做只读分析。所以别指望删除后都能救回来，事前备份永远比事后恢复靠谱。

---

# 第三篇 · 帮助、开关机与 Shell 基础

## 十七、Linux 帮助命令

*man帮助命令*

当你不知道linux命令如何使用的时候，使用man命令帮助你

```plain
语法
man 命令  
如：
man  ls  
进入man帮助文档后，按下q退出
```

打开 `man cp` 后，手册内容按固定栏目分区，对照下图看：

| man 手册栏目 | 内容 |
| --- | --- |
| NAME | 命令一句话简介，如 `cp - copy files and directories` |
| SYNOPSIS（命令格式） | 列出 `cp [OPTION]... [-T] SOURCE DEST` 等写法，**中括号里的内容可以省略** |
| DESCRIPTION（描述） | 命令的详细说明，如 `Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.` |
| 参数列表 | 逐个解释选项，如 `-a, --archive`、`-b`、`--copy-contents` 等 |

*使用--help参数*

```plain
语法：
命令 --help
帮助命令的精简版
如 ls --help
```

*help命令获取帮助*

```plain
语法：
help  命令  
只针对bash内置命令
```

*info命令获取帮助*

```plain
语法：
info 命令
```

*从互联网中获取*

```plain
互联网有很多在线linux中文文档网站
```

> 💡 四种获取帮助的优先级建议：先试 `命令 --help`（最快）；看不懂再 `man 命令`（最全）；`help` 只对 cd、echo 这类 bash 内置命令有效；`info` 内容更庞大，入门阶段用得少。判断是不是内置命令，可以用 `type 命令名`。

## 十八、Linux 开关机命令

*shutdown重启或者关机*

```plain
[root@pylinux ~]#shutdown --help
shutdown [OPTIONS...] [TIME] [WALL...]
Shut down the system.
```

*重启*

```plain
语法：
shutdown -r参数    -r --reboot    Reboot the machine
shutdown -r 10    #十分钟后重启
shutdown -r 0        #立刻重启
shutdown -r now #立刻重启
```

*关机*

```plain
语法：
shutdown -h    --halt  停止的含义
shutdown -h 10 #十分钟后关机
shutdown -h 0  
shutdown -h now #立即关机
```

*halt，poweroff，reboot命令关机与重启*

```plain
reboot 重启
```

```plain
poweroff
halt 关机
```

*关机、重启、注销命令列表*

| 命令 | 说明 |
| --- | --- |
| shutdown -h now | 立刻关机，企业用法 |
| shutdown -h 1 | 1分钟后关机，也可以写时间如 11:30 |
| halt | 立刻关闭系统，需手工切断电源 |
| init 0 | 切换运行级别为0，0表示关机 |
| poweroff | 立刻关闭系统，且关闭电源 |
| 重启 | |
| reboot | 立刻重启机器，企业用法 |
| Shutdown -r now | 立刻重启，企业用法 |
| shutdown -r 1 | 一分钟后重启 |
| Init 6 | 切换运行级别为6，此级别是重启 |
| 注销命令 | |
| logout | 注销退出当前用户 |
| exit | 注销退出当前用户，快捷键ctrl + d |

> ⚠️ 这些命令自己练习时可以敲；远程登录到真实服务器上，绝不能随手执行关机/重启，必须先评估业务影响并走确认流程。`shutdown -h 1` 这种"延时执行"的如果后悔了，可以用 `shutdown -c` 取消。

## 十九、Linux 命令行常用快捷键

```plain
ctrl + c     cancel取消当前操作
ctrl + l    清空屏幕内容
ctrl + d    退出当前用户
ctrl + a     光标移到行首
ctrl + e    光标移到行尾
ctrl + u  删除光标到行首的内容
```

> 💡 补充两个同样高频的：`ctrl + w` 删除光标前的一个单词；`ctrl + r` 搜索历史命令，输关键字就能翻出以前敲过的长命令。

## 二十、Linux 的环境变量

同学们应该都会配置windows下的环境变量（PATH），都知道系统会按照PATH的设定，去每个PATH定义的目录下搜索可执行文件。

那么如何查看Linux下的PATH环境变量呢？

```plain
执行命令：
echo $PATH
echo命令是有打印的意思
$符号后面跟上PATH,表示输出PATH的变量
```

PATH(一定是大写的)这个变量是由一堆目录组成，分隔符是":"号，而不同于windows的";"号。

```plain
[root@luffycity ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

> 💡 为什么敲 `ls` 不用写全 `/usr/bin/ls`？因为系统会按 PATH 中目录的先后顺序去找可执行文件，找到了就执行。如果自己写的脚本"命令找不到"，十有八九是脚本所在目录不在 PATH 里——可以用全路径执行，或把目录加进 PATH。

## 二十一、绝对路径与相对路径

Linux中非常重要的概念--路径，路径用来定位如何找到某个文件。

这里超哥先讲个例子，到底什么是相对路径，绝对路径

比如一个老外，要来老男孩教育学习python，但是他找不到地点，因此向你问路，你可以告诉他：

1.先坐飞机来中国北京，从北京机场坐地铁到沙河地铁站，然后走路800米到沙河汇德商厦，上四楼，找到超哥，结束寻路。

　　2. 超哥就在汇德商厦403办公室，武佩奇后面坐着呢！！！

第一种说法从"中国北京"这个唯一起点一步步描述，相当于**绝对路径**；第二种说法拿"你现在的位置"当参照，相当于**相对路径**。

Linux下特别注意文件名/路径的写法，可以将所谓的路径(path)定义为绝对路径(absolute)和相对路径(relative)。这两种文件名/路径的写法依据是这样的：

* 绝对路径：由根目录(/)为开始写起的文件名或者目录名称，如/home/oldboy/test.py;
* 相对路径：相对于目前路径的文件名写法。例如./home/oldboy/exam.py或../../home/oldboy/exam.py，简单来说只要开头不是/，就是属于相对路径

因此你必须了解，相对路径是：**以你当前所在路径的相对路径来表示的。**

例如你现在在/home 这个目录下，如要进入/var/log这个路径，如何写呢？

1. cd /var/log (绝对路径)
2. cd ../var/log(相对路径)

因为你在/home底下，因此你要回到上一层(../)之后，才能继续前往/var，特别注意：

* . :代表当前的目录，也可以用./ 来表示
* .. :代表上一层的目录，也可以用../来表示

先看相对路径的执行过程：

```plain
[root@python_linux home]# pwd
/home
[root@python_linux home]# cd ../var/log
[root@python_linux log]# pwd
/var/log
```

再看绝对路径的写法——不管当前在哪，从 `/` 出发永远不会错：

```plain
[root@python_linux home]# pwd
/home
[root@python_linux home]# cd /var/log
[root@python_linux log]# pwd
/var/log
```

> 📌 一句话区分：**以 `/` 开头的是绝对路径，以 `.`、`..` 或文件名直接开头的是相对路径。** 写脚本时优先用绝对路径，换个目录执行也不会找不到文件。

---

# 第四篇 · 系统文件与启动流程

## 二十二、系统重要文件路径

### /etc初始化系统重要文件

`/etc` 下集中了系统和服务的配置文件，下面这些是运维排查时最常打交道的：

| 文件路径 | 作用 |
| --- | --- |
| /etc/sysconfig/network-scripts/ifcfg-eth0 | 网卡配置文件 |
| /etc/resolv.conf | Linux系统DNS客户端配置文件 |
| /etc/hostname (CentOS7) /etc/sysconfig/network:(CentOS 6) | 主机名配置文件 |
| /etc/hosts | 系统本地的DNS解析文件 |
| /etc/fstab | 配置开机设备自动挂载的文件 |
| /etc/rc.local | 存放开机自启动程序命令的文件 |
| /etc/inittab | 系统启动设定运行级别等配置的文件 |
| /etc/profile及/etc/bashrc | 配置系统的环境变量/别名等的文件 |
| /etc/profile.d | 用户登录后执行的脚本所在的目录 |
| /etc/issue和/etc/issue.net | 配置在用户登录终端前显示信息的文件 |
| /etc/init.d | 软件启动程序所在的目录(centos 6) |
| /usr/lib/systemd/system/ | 软件启动程序所在的目录(centos 7) |
| /etc/motd | 配置用户登录系统之后显示提示内容的文件 |
| /etc/redhat-release | 声明RedHat版本号和名称信息的文件 |
| /etc/sysctl.conf | Linux内核参数设置文件 |

### /proc重要路径

`/proc` 是内核和内存信息的"窗口"，排查 CPU、内存、负载问题时常读：

| 文件路径 | 内容 |
| --- | --- |
| /proc/meminfo | 系统内存信息 |
| /proc/cpuinfo | 关于处理器的信息，如类型，厂家，型号，性能等 |
| /proc/loadavg | 系统负载信息，uptime 的结果 |
| /proc/mounts | 已加载的文件系统的列表 |

### /var目录下文件

`/var` 下存放经常变化的东西，排查问题最先翻日志：

| 文件路径 | 内容 |
| --- | --- |
| /var/log | 记录系统及软件运行信息文件所在的目录 |
| /var/log/messages | 系统级别日志文件 |
| /var/log/secure | 用户登录信息日志文件 |
| /var/log/dmesg | 记录硬件信息加载情况的日志文件 |

> 💡 实车排障时这几个文件是"老朋友"：系统服务报错看 `/var/log/messages`，怀疑有人登录或被爆破看 `/var/log/secure`，硬件没识别出来看 `dmesg` 和 `/var/log/dmesg`。

## 二十三、Linux 开机启动流程

作为一个运维人，必须得保障服务器正确工作，机器宕机了，也得明确是什么问题，从何查起，那么了解启动流程就能够对症下药，排查问题。

### CentOS 6 启动流程

CentOS 6 从按下电源到出现登录界面，整体流程如下：

```plain
按下电源
  │
  ▼
开机自检（BIOS）
  │
  ▼
MBR 引导
  │
  ▼
GRUB 菜单（可以选择不同内核 / C6 单用户模式）
  │
  ▼
加载内核（加载到内存）
  │
  ▼
运行 INIT 进程（C6 第一个启动的进程）
  │
  ▼
读取 /etc/inittab（确定 C6 运行级别）
  │
  ▼
读取 /etc/rc.sysinit 初始化系统（设置主机名、IP 地址）
  │
  ▼
根据运行级别运行 /etc/rc数字.d 下面的脚本（C6 开机自启动）
  │
  ▼
启动 mingetty 显示登录界面，运行 login（明哥 tty）
```

* *BIOS自检*

检查硬件是否健康。如 cpu 风扇是否正常，内存是否正常，时钟是否正常，这个过程是读取 ROM 上的指令执行的。

* *微控制器*

系统想要启动必须先加载 BIOS，按下电源键时，给微控制器下达一条复位指令，各寄存器复位，最 后下达一条跳转指令，跳转到 BIOS 的 ROM，使得硬件去读取主板上的 BIOS 程序，在这之前都是 由硬件来完成，之后硬件就会把控制权交给 BIOS。

* *BIOS->POST*

随后 BIOS 程序加载 CMOS(可读写的 RAM 芯片，保存 BIOS 设置硬件参数的数据)的信息，借 CMOS 取得主机的各项硬件配置。取得硬件配置的信息之后，BIOS 进行加电自检(Power-on self Test，POST)过程,检测计算机各种硬件信息，如果发现硬件错误则会报错(发出声音警告)。之后 BIOS 对硬件进行初始化。BIOS 将自己复制到物理内存中继续执行，开始按顺序搜寻可引导存储设 备，决定存储设备的顺序(即定义第一个可引导的磁盘，当然是在有两个磁盘的前提)，接下来就 会读取磁盘的内容，但是要读取磁盘文件必须要有文件系统，这对 BIOS 挂载文件系统来说是不可 能，因此需要一个不依赖文件系统的方法使得 BIOS 读取磁盘内容，这种方法就是引入 MBR。最后 BIOS 通过 INT13 硬件中断功能读取第一个可引导的存储设备的 MBR(0 磁道 0 扇区)中的 boot loader。将 MBR 加载到物理内存中执行。MBR 载入内存后，BIOS 将控制权转交给 MBR(准确的 说应该是 MBR 中的 boot loader)，然后 MBR 接管任务开始执行。

* *MBR引导*

载入了第一个可引导的存储设备的 MBR 后，MBR 中的 boot loader 就要读取所在磁盘的操作系统核 心文件(即后面所说的内核)了。 但是不同操作系统的文件系统格式不同，还有一个磁盘可以安装多个操作系统，如何让 boot loader 做到引导的就是用户想要的操作系统，这么多不同的功能单靠一个 446 字节的 boot loader 是远远不 够的。必须有一个相对应的程序来处理各自对应的操作系统核心文件，这个程序就是操作系统的 loader(注意不是 MBR 中的 boot loader)，这样一来 boot loader 只需要将控制权交给对应操作系统 的 loader，让它负责去启动操作系统就行了。 一个硬盘的每个分区的第一个扇区叫做 boot sector，这个扇区存放的就是操作系统的 loader，所以常 说一个分区只能安装一个操作系统。MBR 的 boot loader 有三个功能:提供选单，读取内核文件，转 交给其它 loader。 提供选单就是给用户提供一张选项单，让用户选择进入哪个操作系统;读取内核文件的意思是，系 统会有一个默认启动的操作系统，这个操作系统的 loader 在所在分区的 boot sector 有一份，除此之 外，也会将这个默认启动的操作系统的 loader 复制一份到 MBR 的 boot loader 中，这样一来 MBR 就 会直接读取 boot loader 中的 loader 了，然后就是启动默认的操作系统;转交给其它的 loader，当用 户选择其它操作系统启动的时候，boot loader 会将控制权转交给对应的 loader，让它负责操作系统的 启动。

* *GRUB引导*

grub 是 boot loader 中的一种，就 grub 来说，为了打破在 MBR 中只有 446Bytes 用于存放 boot loader这一限制，所以这一步的实现是这样的:grub 是通过分成三个阶段来实现加载内核这一功能的，这三个阶段分别是:stage1, stage1.5 以及 stage2。 stage1:存放于 MBR 的前 446Bytes，用于加载 stage1.5 阶段，目的是为了识别并驱动 stage2(或者 /boot)所在分区的文件系统。 stage1.5:存放于 MBR 之后的扇区，加载 stage2 所在分区的文件系统驱动，让 stage1 中的 boot loader 能识别 stage2 所在分区的文件系统。 stage2:存放于磁盘分区之上，具体存放于/boot/grub 目录之下，主要用于加载内核文件(vmlinuz- VERSION-RELEASE)以及 ramdisk 这个临时根文件系统(initrd-VERSION-RELEASE.img 或 initramfs- VERSION-RELEASE.img)。 概述:假如要启动的是硬盘设备，首先硬件平台主板 BIOS 必须能够识别硬盘，然后 BIOS 才能加载 硬盘中的 boot loader，而 boot loader 自身加载后就能够直接识别当前主机上的硬盘设备了;不过， 能够识别硬盘设备不代表能够识别硬盘设备中的文件系统，因为文件系统是额外附加的一层软件组 织的文件结构，所以要对接一种文件系统，就必须要有对应的能够识别和理解这种文件系统的驱 动，这种驱动就称为文件系统驱动。而 stage1.5 就是向 grub 提供文件系统驱动的，这样 stage1 就能 访问 stage2 及内核所在的分区(/boot)了。

* *加载内核*

内核(Kerenl)在得到系统控制权之后，首先要进行自身初始化，而初始化的主要作用是: 探测可识别到的所有硬件设备; 加载硬件驱动程序，即加载真正的根文件系统所在设备的驱动程序(有可能会借助于 ramdisk 加载 驱动); 以只读方式挂载根文件系统(如果有借助于 ramdisk 这个临时文件系统(虚根)，则在这一步之后 会执行根切换;否则不执行根切换); 运行用户空间的第一个应用程序:/sbin/init。 到这里内核空间的启动流程就结束了，而接下来是用户空间完成后续的系统启动流程。 注意:ramdisk 和内核是由 boot loader 一同加载到内存当中的，ramdisk 是用于实现系统初始化的、 基于内存的磁盘设备，即加载至内存(的某一段空间)后把内存当磁盘使用，并在内存中作为临时 根文件系统提供给内核使用，帮助内核挂载真正的根文件系统。而之所以能够帮助内核挂载根文件系统是因为在 ramdisk 这个临时文件系统的/lib/modules 目录下有真正的根文件系统所在设备的驱动 程序;除此之外，这个临时文件系统也遵循 FHS，例如有这些固定目录结构:/bin, /sbin, /lib, /lib64, /etc, /mnt, /media, ... 因为 Linux 内核有一个特性就是通过使用缓冲/缓存来达到加速对磁盘上文件的访问的目的，而 ramdisk 是加载到内存并模拟成磁盘来使用的，所以 Linux 就会为内存中的“磁盘”再使用一层缓冲 /缓存，但是 ramdisk 本来就是内存，它只不过被当成硬盘来使用罢了，这就造成双缓冲/缓存了，而 且不会起到提速效果，甚至影响了访问性能;CentOS 5 系列以及之前版本的 ramdisk 文件为 initrd- VERSION-RELEASE.img，就会出现上述所说到的问题;而为了解决一问题，CentOS 6/7 系列版本就将其改为 initramfs-VERSION-RELEASE.img，使用文件系统的方式就可以避免双缓冲/缓存了，可 以说这是一种提速机制。

* *启动init进程*

grub 中默认指定 init=/sbin/init 程序，可以在 grub.conf 中 kernel 行自定义执行程序 init=/bin/bash,此时 可以绕过下面步骤直接进入 bash 界面。 内核源代码文件中显示 996 行左右，规定了 init 启动的顺序，/sbin/init->/etc/init->/bin/init->/bin/sh。

* *读取/etc/inittab 文件*

inittab 文件里面定义了系统默认运行级别，这一步做了一些工作如下: 初始运行级别(RUN LEVEL); 系统初始化脚本; 对应运行级别的脚本目录; 定义 UPS 电源终端/恢复脚本; 在虚拟控制台生成 getty,以生成终端; 在运行级别 5 初始化 X。

* *执行/etc/rc.d/rc.sysinit 程序*

系统初始化一些脚本，主要完成以下工作。 设置主机名; 设置欢迎信息;

激活 udev 和 selinux 可以在 grub.conf 中,kernel 行添加 selinux=0 以关闭 selinux; 挂载/etc/fstab 文件中定义的文件系统; 检测根文件系统，并以读写方式重新挂载根文件系统; 设置系统时钟;

激活 swap 设备; 根据/etc/sysctl.conf 文件设置内核参数; 激活 lvm 及 software raid 设备; 加载额外设备的驱动程序; 清理操作。 /etc/rc*.d/文件(各种服务) 里面定义的是各种服务的启动脚本，可以 ls 查看，S 开头代表开机启动的服务，K 开头的是关机要 执行的任务。#代表数字，一个数字代表一个运行级别，共 7 个运行级别。 /etc/rc.d/rc.local 文件 这里面可以自定义开机启动的命令。

* *执行/bin/login*

执行/bin/login 程序，等待用户登录。

### CentOS 7 启动流程

CentOS 7 的前半段和 CentOS 6 基本一样，区别从第一个用户进程开始：`init` 换成了 `systemd`，后面的服务改为并行启动。整体流程：

```plain
按下电源
  │
  ▼
开机自检（BIOS）
  │
  ▼
MBR 引导
  │
  ▼
GRUB 菜单
  │
  ▼
加载内核
  │
  ▼
systemd（C7 第一个启动的进程）
  │
  ▼
读取运行级别 target(7)：/etc/systemd/system/default.target
  │
  ▼
进入 multi-user.target
  │
  ▼
并行启动 /usr/lib/systemd/system、/etc/systemd/system/ 下的各种服务
  │
  ▼
启动 login 显示登录界面
```

CentOS7 和 CentOS6 启动流程差不多，只不过到 init 程序时候，改为了 systemd，因此详细解释一下 systemd 后的启动流程。

* uefi或BIOS初始化，开始post开机自检;
* 加载mbr到内存
* 加载内核和inintamfs模块
* 内核开始初始化，使用systemd代替centos6的init程序

1.执行initrd.target，包括挂载/etc/fstab文件中的系统，此时挂载后，就可以切换到根目录了

2.从initramfs根文件系统切换到磁盘根目录

3.systemd执行默认target配置

CentOS7 系表面是有“运行级别”这个概念，实际上是为了兼容以前的系统，每个所谓的“运行级 别”都有对应的软连接指向，默认的启动级别是/etc/systemd/system/default.target，根据它的指向可 以找到系统要进入哪个模式。

centos7的7个启动模式是：

* 0 ==> runlevel0.target, poweroff.target
* 1 ==> runlevel1.target, rescue.target
* 2 ==> runlevel2.target, multi-user.target
* 3 ==> runlevel3.target, multi-user.target
* 4 ==> runlevel4.target, multi-user.target
* 5 ==> runlevel5.target, graphical.target
* 6 ==> runlevel6.target, reboot.target
* systemd执行sysinit.target;
* systemd启动multi-user.target下的本机与服务器服务;
* systemd执行multi-user.target下的/etc/rc.d/rc.local。
* Systemd 执行 multi-user.target 下的 getty.target 及登录服务;
* systemd 执行 graphical 需要的服务。

> 💡 传统 `init` 是一件一件串行启动服务，速度慢；`systemd` 按依赖关系并行启动，这是 CentOS 7 开机明显变快的主要原因。运维排查服务时，对应的命令也从 `service 服务名 status` 变成了 `systemctl status 服务名`。

---

> 更新: 2022-12-20 20:54:07  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/sdeetr>
