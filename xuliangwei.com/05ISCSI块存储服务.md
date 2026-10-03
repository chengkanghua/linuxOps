# 05 ISCSI块存储服务

# 05 ISCSI块存储服务

* [1.iSCSI技术介绍](http://kt.xuliangwei.com/15107335544892.html#toc_0)
* [2.配置iSCSI服务端](http://kt.xuliangwei.com/15107335544892.html#toc_1)
* [3.配置Linux客户端](http://kt.xuliangwei.com/15107335544892.html#toc_2)
* [4.配置Win客户端](http://kt.xuliangwei.com/15107335544892.html#toc_3)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208
>
> 重要指数2星

## 1.iSCSI技术介绍

为了进一步提升硬盘存储设备的读写速度和性能，人们一直在努力改进物理硬盘设备的接口协议。当前的硬盘接口类型主要有IDE、SCSI和SATA这3种。

> IDE是一种成熟稳定、价格便宜的并行传输接口。
>
> SATA是一种传输速度更快、数据校验更完整的串行传输接口。
>
> SCSI是一种用于计算机和硬盘、光驱等设备之间系统级接口的通用标准，具有系统资源占用率低、转速高、传输速度快等优点。

iSCSI技术在工作形式上分为服务端`target`与客户端`initiator`

iSCSI服务端即用于存放硬盘存储资源的服务器

iSCSI客户端则是用户使用的软件，用于访问远程服务端的存储资源。

## 2.配置iSCSI服务端

| 主机名称 | 操作系统 | IP地址 |
| :--- | :--- | :--- |
| iSCSI服务端 | Linux7 | 192.168.56.11 |
| iSCSI客户端 | Linux7 | 192.168.56.12 |

1.安装`iscsi`服务

```plain
[root@iscsi-server ~]# yum install targetd targetcli -y
//启动ISCSI服务端程序targetd, 并加入开机自启
[root@iscsi-server ~]# systemctl start targetd
[root@iscsi-server ~]# systemctl enable targetd
```

2.配置iSCSI服务共享资源

> targetcli是用于管理iSCSI服务端存储资源的配置命令，将iSCSI共享资源的配置内容抽象成“目录”的形式, 我们只需将各类配置信息填入到相应的“目录”中即可。

```plain
[root@linux-node1 ~]# targetcli
targetcli shell version 2.1.fb46
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.
/> cd backstores/block
/backstores/block>'create disk0 /dev/sdb'
Created block storage object disk0 using /dev/sdb.
/backstores/block> cd /
/> ls
o- / ..................................................................... [...]
  o- backstores .......................................................... [...]
  | o- block .............................................. [Storage Objects: 1]
  | | o- disk0 ..................... [/dev/sdb (20.0GiB) write-thru deactivated]
  | |   o- alua ............................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ................... [ALUA state: Active/optimized]
  | o- fileio ............................................. [Storage Objects: 0]
  | o- pscsi .............................................. [Storage Objects: 0]
  | o- ramdisk ............................................ [Storage Objects: 0]
  o- iscsi ........................................................ [Targets: 0]
  o- loopback ..................................................... [Targets: 0]
```

3.创建`iSCSI target`名称及配置共享资源

> iSCSI target名称是由系统自动生成，用于描述共享资源的唯一字符串。
>
> 客户端在扫描iSCSI服务端时即可看见该字符串，因此我们无需记忆该字符串。
>
> 系统在生成这个target名称后，还会在/iscsi参数目录中创建一个与其字符串同名的新“目录”用来存放共享资源。

```plain
//将之前ISCSI共享资源池中硬盘添加至/iscsi目录
/> cd iscsi
/iscsi> create
Created target iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.
//
/iscsi> cd iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73/tpg1/luns
//
/iscsi/iqn.20...a73/tpg1/luns> create /backstores/block/disk0
Created LUN 0.
```

4.设置访问控制列表（ACL）

> iSCSI协议是通过客户端名称进行验证, 用户在访问存储共享资源时不需要输入密码，只要iSCSI客户端的名称与服务端中设置的访问控制列表中某一名称条目一致即可
>
> acls参数目录用于存放能够访问iSCSI服务端共享存储资源的客户端名称。

```plain
/iscsi/iqn.20...a9756a73/tpg1> cd acls
/iscsi/iqn.20...a73/tpg1/acls> create iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73:client
```

5.设置iSCSI服务端的监听IP地址和端口号

```plain
/iscsi/iqn.20...d80/tpg1/acls> cd ..
/iscsi/iqn.20...c356ad80/tpg1> cd portals 
/iscsi/iqn.20.../tpg1/portals> create 192.168.56.11
Using default IP port 3260
```

6.配置后检查配置信息，重启`iSCSI`服务端程序并配置防火墙策略。

```plain
/iscsi/iqn.20.../tpg1/portals> cd /
/> ls
o- / ..................................................................... [...]
  o- backstores .......................................................... [...]
  | o- block .............................................. [Storage Objects: 1]
  | | o- disk0 ....................... [/dev/sdb (20.0GiB) write-thru activated]
  | |   o- alua ............................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ................... [ALUA state: Active/optimized]
  | o- fileio ............................................. [Storage Objects: 0]
  | o- pscsi .............................................. [Storage Objects: 0]
  | o- ramdisk ............................................ [Storage Objects: 0]
  o- iscsi ........................................................ [Targets: 1]
  | o- iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73 . [TPGs: 1]
  |   o- tpg1 ........................................... [no-gen-acls, no-auth]
  |     o- acls ...................................................... [ACLs: 1]
  |     | o- iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73:client  [Mapped LUNs: 1]
  |     |   o- mapped_lun0 ............................. [lun0 block/disk0 (rw)]
  |     o- luns ...................................................... [LUNs: 1]
  |     | o- lun0 .................. [block/disk0 (/dev/sdb) (default_tg_pt_gp)]
  |     o- portals ................................................ [Portals: 1]
  |       o- 0.0.0.0:3260 ................................................. [OK]
  o- loopback ..................................................... [Targets: 0]
//保存配置
/> saveconfig
//注意:不要使用ctrl+c结束该进程
/> exit
//重启targetd服务, 并配置firewalld防火墙
[root@xuliangwei ~]# systemctl restart targetd
[root@xuliangwei ~]# firewall-cmd --permanent --add-port=3260/tcp
firsuccess
[root@linux-node1 ~]# firewall-cmd --reload
success
```

## 3.配置Linux客户端

1.安装`iSCSI`客户端服务程序`initiator`

```plain
yum install iscsi-initiator-utils
```

2.编辑iSCSI客户端中的`initiator`名称文件，将服务端的访问控制列表名称填写进来

```plain
[root@xuliangwei ~]# cat /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73:client
```

3.重启客户端`iscsid`服务程序并将其加入开机自启动

```plain
[root@xuliangwei ~]# systemctl restart iscsid
[root@xuliangwei ~]# systemctl enable iscsid
```

4.`iSCSI`客户端访问并使用共享存储资源的步骤很简单, 发现, 登录, 挂载, 使用

```plain
//iscsiadm是用于管理、查询、插入、更新或删除iSCSI数据库配置文件的命令行工具
//扫描远程ISCSI服务端共享存储资源
//-m discovery 扫描并发现可用的存储资源
//-t st 执行扫描操作的类型
// -p 指定iSCSI服务端的IP地址
[root@xuliangwei ~]# iscsiadm -m discovery -t st -p 192.168.56.11
192.168.56.11:3260,1 iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73
```

5.`iscsiadm`命令发现远程服务器上可用的存储资源后，然后使用`iscsiadm`登陆`ISCSI`服务端

```plain
//-m node参数为将客户端所在主机作为一台节点服务器
//-T  参数为要使用的存储资源（直接复制前面命令中扫描发现的结果，以免录入错误）
//-p 192.168.10.10参数依然为对方iSCSI服务端的IP地址
//--login或-l参数进行登录验证
[root@xuliangwei ~]# iscsiadm -m node \
-T iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73 \
-p 192.168.56.11 --login
```

6.`iSCSI`客户端成功登录之后, 会在客户端主机上多出一块名为`/dev/sd[x]`的设备文件, 进行格式化挂载即可

```plain
//查看当前磁盘
[root@xuliangwei ~]# lsblk
//格式化并挂载
[root@xuliangwei ~]# mkfs.xfs /dev/sdb
[root@xuliangwei ~]# mkdir /iscsi
[root@xuliangwei ~]# mount /dev/sdc /iscsi/
//开机自动挂载
[root@xuliangwei ~]# blkid | grep /dev/sdb
/dev/sdc: UUID="0b5f71ea-90f9-45c5-a7cb-6a22f5460a67" TYPE="xfs"
[root@xuliangwei ~]# tail -n1 /etc/fstab
UUID=0b5f71ea-90f9-45c5-a7cb-6a22f5460a67   /iscsi  xfs defaults    0 0
```

7.卸载`iSCSI`共享设备资源`-u`参数进行卸载

```plain
[root@xuliangwei ~]# iscsiadm -m node \
-T iqn.2003-01.org.linux-iscsi.linux-node1.x8664:sn.9eaea9756a73 -u
```

## 4.配置Win客户端

使用`Windows`系统的客户端也可以正常访问`iSCSI`服务器上的共享存储资源，而且操作原理及步骤与Linux系统的客户端基本相同。

1.运行`iSCSI`发起程序。在Windows 7操作系统中已经默认安装了iSCSI客户端程序，我们只需在控制面板中找到“系统和安全”标签，然后单击“管理工具”,如图1-1所示

<!-- OCR_START -->
- 控制面板系统和安全
- 搜索控制面板
- 控制面板主页
- 操作中心
- 系统和安全
- 检查计算机的状态并解决问题
- 更改用户帐户控制设置
- 常见计算机问题疑难解答
- 网络和 Internet
- 将计算机还原到一个较早的时间点
- 硬件和声音
- Windows防火墙
- 程序
- 检查防火墙状态
- 允许程序通过Windows防火墙
- 用户帐户和家庭安全
- 系统
- 外观
- 查看RAM的大小和处理器速度
- 检查Windows体验指数
- 允许远程访问
- 查看该计算机的名称
- 设备管理器
- 时钟、语言和区域
- 轻松访问
- Windows Update
- 启用或禁用自动更新
- 检查更新
- 查看已安装的更新
- 电源选项
- 唤醒计算机时需要密码
- 更改电源按钮的功能
- 更改计算机睡眠时间
- 备份和还原
- 备份您的计算机
- 从备份还原文件
- Windows Anytime Upgrade
- 获取新版本的Windows7的更多功能
- 管理工具
- 释放磁盘空间
- 对硬盘进行碎片整理
- 创建并格式化硬盘分区
- 查看事件日志
- 计划任务
<!-- OCR_END -->

图1-1 在控制面板中单击“管理工具”

进入到“管理工具”双击“iSCSI发起程序”, 在第一次运行iSCSI发起程序时，系统会提示`Microsoft iSCSI`服务端未运行，单击“是”按钮即可自动启动并运行iSCSI发起程序，如图1-2所示

<!-- OCR_START -->
- 控制面板系统和安全管理工具
- 搜索管理工具
- 面打开
- ☆收藏夹
- 名称
- 修改日期
- 类型
- 大小
- 下载
- isCSI 发起程序
- 2009/7/14 12:54
- 快捷方式
- 2 KB
- 桌面
- Windows PowerShell Modules
- 2009/7/14 13:32
- 3 KB
- 最近访问的位置
- Windows 内存诊断
- 2009/7/14 12:53
- 服务
- 同库
- Microsoft iscSI
- 视频
- 图片
- MicrosoftiSCSI服务尚未运行。若要使isCSI正常工作，必须启动该服务。若要
- 文档
- 立即启动该服务并让该服务在每次计算机重新启动时自动启动，请单击“是”按
- 音乐
- 钮。
- 计算机
- 是(Y)
- 否(N)
- 网络
- iSCSI发起程序修改日期：2009/7/1412:54
- 创建日期：2009/7/1412:54
- 大小:1.24 KB
<!-- OCR_END -->

图1-2 双击“iSCSI发起程序”图标

2.必须先扫描发现`iSCSI`服务端上可用的存储资源。

在`ISCSI`发起程序的目标窗口栏写入`ISCSI`服务端的`IP`地址, 单击快速链接, 如图1-3

<!-- OCR_START -->
- iSCSI发起程序属性
- 目标
- 发现
- 收藏的目标卷和设备RADIUS配置
- 快速连接
- 若要发现具标并使用基本连接登录到目标，请键入该目标的IP地址或DNS名
- 然信單害“快递莲接”
- 称，
- 目标（T)：
- 192.168.69.112
- 快速连接（Q).
- 已发现的目标（G）
- 刷新（R）
- 名称
- 状态
- 若要使用高级选项进行连接，请选择目标，然后单击
- 连接（H）
- 连接”。
- 若要家全断开某个目标的连接，请选择该目标，然后单
- 断开连接（D）
- 对于目标属性，包括会话的配置，请选择该目标并单击
- 属性（P）.
- 属性”。
- 对于配置与目标关联的设备，请选择该目标，然后单击
- 设备（V）.
- 设备”。
- 有关基本iSCSI连接和目标的详细信息
- 确定
- 取消
- 应用（A）
<!-- OCR_END -->

图1-3 填写iSCSI服务端的IP地址

在弹出的“快速连接”提示框中可看到共享的硬盘存储资源，单击“完成”按钮即可，如图1-4所示。

<!-- OCR_START -->
- iSCSI 发起程序 属性
- 快速连接
- 在所提供_P地址惑卫_条称处的可用连接目标如下所列。如果有多个目
- 标可用，则需要分别连接到每个目标。
- 在此处进行的连接将添加到收藏目标列表中，每次重新启动该计算机时都将
- 尝试恢复这些连接。
- 已发现的目标(T)
- 名称
- 状态
- i qn.2003-01.org.1linux-iscsi.locslhost.x8.
- 不活动
- 进度报告
- 无法登录到目标。
- 连接（C)
- 完成(D）
- 有关基本iSCSI连接和目标的详细信息
- 确定
- 取消
- 应用（)
<!-- OCR_END -->

图1-4 在“快速连接”提示框中看到的共享的硬盘存储资源

回到“目标”选项卡页面，可以看到共享存储资源的名称已经出现，如图1-5所示。

<!-- OCR_START -->
- iSCSI 发起程序 属性
- 目标
- 发现
- 收藏的目标卷和设备RADIUS配置
- 快速连接
- 若要发现目标并使用基本连接登录到目标，请键入该目标的IP地址或DNS名
- 称，然后单击“快速连接”
- 目标(T)：
- 快速连接（Q）
- 已发现的目标（G)
- 刷新(R)
- 名称
- 状态
- iqn.2003-01. org.linux-iscsi.localhost.x8664:...7
- 不活动
- 若要使用高级选项进行连接：请选择目标，然后单击
- 连接(H)
- 连接
- 若要完全断开某个目标的连接，请选择该目标，然后单
- 击“断开连接”
- 断开连接（）
- 对于是标属性，包括会话的配置，请选择该目标并单击
- 属性(P).
- 属性
- 对于要置与目标关联的设备，请选择该目标，然后单击
- 设备(V)...
- 有关基本iSCSI连接和目标的详细信息
- 确定
- 取消
- 应用（)
<!-- OCR_END -->

图1-5 在“目标”选项卡中看到了共享存储资源

3.由于在`iSCSI`服务端程序上设置了`ACL`使得只有客户端名称与`ACL`策略中的名称保持一致时才能使用远程存储资源，因此需要在“配置”选项卡中单击“更改”按钮，把`iSCSI`发起程序的名称修改为服务端, 如图1-6

<!-- OCR_START -->
- iSCSI发起程序属性
- 目标发现
- 收藏的目标卷和设备RADIUS配置
- 此处的配置设置是全局设置，会影响以后使用该发起程序进行的任何连接。
- 任何现有连接都可以继续工：但如果重新启动系统，或发起程序试图重新连
- 接到首标，则这些连接可能会失。
- 连接到目标时，高级连接功能允许对特定连接进行特别控制。
- 发起程序名称：
- i qn. 2003-01. org. linux-iscsi. localhost. x8664 : sn. 97835da337d7 : client
- 若要修改发起程序名称，请单击“更改”。
- 更改0)..
- 若要将发起程序CHAP机密设置为与相互CHAP一起使
- 用，请单害CHAP"。
- CHAP (P).
- 若要设置发起程序的IPsec隧道模式地址，请单击
- “IPsec"。
- IPsec (I).
- 若要生成系统中所有已连接的目标和设备的报告，请单
- 击“报告”””。
- 报告(R)
- 有关配置的详细信息
- 确定
- 取消
- 应用（)
<!-- OCR_END -->

图1-6 修改iSCSI发起程序的名称

在确认客户端发起程序的名称修改正确后即可返回到“目标”选项卡页面中，然后单击“连接”按钮进行连接请求，成功连接到远程共享存储资源的页面如图1-7所示。

<!-- OCR_START -->
- iSCSI 发起程序 属性
- 目标
- 发现
- 收藏的目标卷和设备RADIUS配置
- 快速连接
- 若要发现目标并使用基本连接登录到目标，请键入该目标的IP地址或DNS名
- 称，然信单害“快递莲接”。
- 目标(T)：
- 快速连接（Q).
- 已发现的目标（G)
- 刷新(R)
- 名称
- 状态
- iqn.2003-01.org.linux-iscsi.localhost.x8664:...
- 已连接
- 若要使用高级选项进行连接，请选择目标，然后单击
- 连接)
- 若要完全断开某个目标的连接，请选择该目标，然后单
- 断开连接（）
- 击“断开连接”
- 对于目标属性，包括会话的配置，请选择该目标并单击
- 属性”
- 属性(P)
- 对于要置与目标关联的设备，请选择该目标，然后单击
- 设备(V)...
- 设备
- 有关基本iSCSI连接和目标的详细信息
- 确定
- 取消
- 应用（)
<!-- OCR_END -->

图1-7 成功连接到远程共享存储资源

4.访问`iSCSI`远程共享存储资源。右键单击桌面上的“计算机”图标，打开计算机管理程序，如图1-8所示。

<!-- OCR_START -->
- 计算机管理
- 文件(F)  操作(A)查看(V)  帮助(H)
- →园园
- 计算机管理(本地)
- 布局类型文件系统状态
- 容量
- 可用空
- 操作
- 系统工具
- （C:）简单基本NTFS
- 状态良好（系统，启动，页面文件，活动，故障转储，主分区）60.00GB
- 48.54
- 磁盘管理
- 任务计划程序
- 更多操作
- 事件查看器
- 共享文件夹
- 性能
- 设备管理器
- 昌存储
- 服务和应用程序
- III
- 磁盘0
- 基本
- (C:)
- 60.00 GB
- 60.00 GB NTFS
- 联机
- 状态良好（系统，启动，页面文件，活动，故障转储，主分区)
- ④磁盘1
- 未知
- 39.97 GB
- 没有初始化
- 未分配
- cD-ROM0
- DVD (D:)
- 主分区
<!-- OCR_END -->

图1-8 计算机管理程序的界面

5.对磁盘进行初始化操作，如图1-9至1-16所示。

<!-- OCR_START -->
- 计算机管理
- 文件(F)
- 操作(A)
- 查看(V)
- 帮助(H)
- 日4
- 计算机管理(本地)
- 布局类型文件系统状态
- 容量
- 可用空
- 操作
- 系统工具
- （C:）简单基本NTFS
- 状态良好（系统，启动,页面文件，活动,故障转储，主分区）60.00GB
- 48.54
- 磁盘管理
- 任务计划程序
- 更多操作
- 事件查看器
- 共享文件夹
- 性能
- 设备管理器
- 初始化磁盘
- 存储
- 磁盘必须经过初始化，逻辑磁盘管理器才能访问。
- 服务和应用程序
- 选择磁盘（S)：
- 磁盘1
- 为所选磁盘使用以下磁盘分区形式：
- MBR（主启动记录）（M）
- 磁盘0
- GPT（GUID分区表）（G）
- 基本
- 注意：所有早期版本的Windows.不识别GPT分区形式。建议在大
- 60.00 GB
- 2TB的磁盘或基于Itaniun的计算机所用的磁盘上使用这种分区形
- 式。
- 联机
- 确定
- 取消
- 未知
- 39.97 GB
- 没有初始化
- 未分配
- cD-ROM 0
- DVD (D:)
- 主分区
<!-- OCR_END -->

图1-9 对磁盘设备进行初始化操作

<!-- OCR_START -->
- 新建简单卷向导
- 欢迎使用新建简单卷向导
- 此向导帮助您在磁盘上创健一个简单卷。
- 简单卷只能在单一磁盘上。
- 单击“下一步”继续。
- <上一步(B)下—步(N)>
- 取消
<!-- OCR_END -->

图1-10 开始使用“新建简单卷向导”

<!-- OCR_START -->
- 新建简单卷向导
- 指定卷大小
- 选择介于最大和最小值的卷大小。
- 最大磁盘空间量（MB)：
- 40924
- 8
- 简单卷大小(MB)（S):
- <上—步@下—步)>
- 取消
<!-- OCR_END -->

图1-11 对磁盘设备进行分区操作

<!-- OCR_START -->
- 新建简单卷向导
- 分配驱动器号和路径
- 为了便于访问，可以给磁盘分区分配驱动器号或驱动器路径。
- 分配以下驱动器号（）：
- 1
- 装入以下空白NTFS文件夹中(M）：
- 浏览)...
- 不分配驱动器号或驱动器路径①）
- <上一步(E下一步>
- 取消
<!-- OCR_END -->

图1-12 设置系统中显示的盘符

<!-- OCR_START -->
- 新建简单卷向导
- 格式化分区
- 要在这个磁盘分区上储存数据：您必须先将其格式化。
- 选择是否要格式化这个卷；如果要格式化，要使用什么设置。
- 不要格式化这个卷①）
- ?按下列设置格式化这个卷（0）：
- 文件系统(E)：
- NTFS
- 分配单元大小（）：
- 默认值
- 卷标(V)：
- 远程存储资源
- 执行快速格式化(）
- 启用文件和文件夹压缩）
- <上一步(B下一步>
- 取消
<!-- OCR_END -->

图1-13 设置磁盘设备的格式以及卷标

<!-- OCR_START -->
- 新建简单卷向导
- 正在完成新建简单卷向导
- 您已经成功完成新建简单卷向导。
- 已选择下列设置：
- 卷类型：简单养
- 选择的磁盘：磁盘1
- 40924 MB
- 文件系统：HTFS
- 分配单元大小：默认值
- 卷标：远程存储资源
- 若要关闭此向导，请单击“完成”。
- <上一步)
- 完成
- 取消
<!-- OCR_END -->

图1-14 检查磁盘初始化信息是否正确

<!-- OCR_START -->
- 计算机管理
- 文件(F)
- 操作(A)
- 查看(V)
- 帮助(H)
- 计算机管理(本地)
- 布局类型文件系统状态
- 容量
- 可用空
- 操作
- 系统工具
- 简单基本RAW
- 正在格式化
- 39.96 GB
- 39.96
- 磁盘管理
- 任务计划程序
- （C:）简单
- 基本NTFS
- 状态良好（系统，启动，页面文件，活动，故障转储，主分区）
- 60.00 GB48.54
- 更多操作
- 事件查看器
- 共享文件夹
- 性能
- 设备管理器
- 昌存储
- 服务和应用程序
- II
- 磁盘0
- 基本
- (C:)
- 60.00 GB
- 60.00 GB NTFS
- 联机
- 磁盘1
- 39.97 GB
- cD-ROM0
- DVD (D:)
- ■未分配■
- 主分区
<!-- OCR_END -->

图1-15 等待磁盘设备初始化过程结束

<!-- OCR_START -->
- 一回
- 计算机
- 搜索计算机
- 组织▼
- 系统属性
- 卸载或更改程序
- 映射网络驱动器
- 打开控制面板
- ☆收藏夹
- 硬盘(2)
- 下载
- 本地磁盘 (C:)
- 远程存储资源(E:)
- 桌面
- 最近访问的位置
- 48.5GB可用，共59.9GB
- 39.8GB可用，共39.9GB
- ·有可移动存储的设备 (1)
- 同库
- DVD驱动器（D:)
- 自动播放
- 视频
- 图片
- 文档
- 音乐
- 常规选项
- 打开文件夹以查看文件
- 使用Windows资源管理器
- 使用此驱动器进行备份
- 网络
- 使用Windows备份
- “控制面板”中查看更多“自动播放”选项
- WIN-APSS1EANKLR I作组: WORKGROUP
- 内存：2.00 GB
- 处理器: Intel(R) Core(TM) i7-4..
<!-- OCR_END -->

图1-16 磁盘初始化完毕后弹出设备图标

> 更新: 2019-03-20 20:00:30  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/vqvfgv>