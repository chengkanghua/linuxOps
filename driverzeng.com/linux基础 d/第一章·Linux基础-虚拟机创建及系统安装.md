# 第一章·Linux基础-虚拟机创建及系统安装

## 第一阶段基础课程大纲

<!-- OCR_START -->
- 老男孩教育
- Linux系统优化初级
- 计算机硬件组成及原理
- Xshell远程网络连接Linux
- 操作系统基础
- Linux文件过滤及内容编辑处理核心命令
- Linux起源
- 老男孩教育Linux云计算
- 第一阶段基础课程大纲
- Linux文件类型及属性
- Linux系统安装实战
- Linux目录文件与系统启动
- Linux三剑客及正则表达式
- Linux工具类命令及进程管理类命令讲解
- Linux文件及目录权限精讲及多个企业网站权限案例模拟
<!-- OCR_END -->

## 常用工具推荐
| 个人博客 |
| :--- |

> 博客园
>
> 51cto
>
> wordpress（LNMP搭建）
>

---

| 个人笔记 |
| :--- |

> 有道云笔记
>
> 印象笔记
>
> 为知笔记
>
> 马克飞象
>
> 作业部落
>

---

| 画图工具 |
| :--- |

> Visio
>
> 亿图
>
> processon
>

---

| 思维导图 |
| :--- |

> Xmind
>
> 幕布
>
> 百度脑图
>
> 头脑风暴
>
> 思路整理
>

## 使用VMware创建虚拟机安装CentOS7系统
| 创建虚拟机 |
| :--- |

打开VMware

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F)
- 编辑（E）查看（V）
- 虚拟机（M）选项卡（T）帮助（H）
- 主页
- Q在此处键入内容进行
- 我的计算机
- 共享的虚拟机
- WORKSTATION12PRO
- 创建新的虚拟机
- 打开虚拟机
- 连接远程服务器
- 连接到VMware
- vCloudAir
- OK/s
- ymware
- OKIs
<!-- OCR_END -->

点击创建虚拟机，或者单击 "文件"--> "创建虚拟机"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F）编辑（E）查看（V）虚拟机（M）选项卡（T）帮助（H）
- 主页
- Q在此处键入内容进行
- 我的计算机
- 共享的虚拟机
- WORKSTATION12PRO
- 创建新的虚拟机
- 打开虚拟机
- 连接远程服务器
- 连接到VMware
- vCloudAir
- OKUs
- ymware
<!-- OCR_END -->

选择"高级" 单击 "下一步"

<!-- OCR_START -->
- VMware Workstation
- 文件（F
- 编辑（E）查看（V)
- 虚拟机（M）
- 选项卡（T）
- 帮助（H）
- 主页
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 共享的虚拟机
- PRO
- 欢迎使用新建虚拟机向导
- WORKST
- TION
- 您希望使用什么类型的配置？
- 典型（推荐）（T）
- 服务器
- 连接到VMware
- 通过几个简单的步骤创健Workstation12.0
- vCloudAir
- 虚拟机。
- 自定义（高级）（C）
- 创建带有SCSI控制器类型、虚拟磁盘类型
- 以及与i旧版VMware产品兼容性等高级选项
- 的虚拟机。
- 帮助
- <上—步（B)
- 下一步（N）>
- 取消
- OK/s
- ymware
<!-- OCR_END -->

虚拟机的兼容性选择 "Workstation12.0"

<!-- OCR_START -->
- VMware Workstation
- 文件（F）
- 编辑（E）查看（V）
- 虚拟机（M）
- 选项卡（T）
- 帮助（H）
- 主页
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 共享的虚拟机
- 选择虚拟机硬件兼容性
- 该虚拟机需要何种硬件功能？
- PRO
- 虚拟机硬件兼容性
- 硬件兼容性（H）：
- 兼容：
- Workstation12.0
- Workstation11.x
- Workstation10.x
- 服务器
- 连接到VMware
- 兼容产品：
- Workstation9.x
- Fusion8.x
- Workstation 8.x
- vCloud Air
- Workstation6.5-7.x
- Workstation 6.0
- Workstation5.x
- 帮助
- <上-步(B)][下—步(N)>]
- 取消
- 0.2K/s
- wmware
- 0.3Ks
<!-- OCR_END -->

安装系统 选择"稍后安装操作系统",单击"下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F）
- 编辑（E）查看（V）
- 虚拟机（M）
- 选项卡（T）
- 帮助（H）
- 主页
- Q在此处键入内容进行.
- 新建虚拟机向导
- 我的计算机
- 安装客户机操作系统
- 共享的虚拟机
- 虚拟机如同物理机，需要操作系统。您将如何安装客户机操作系统？
- PRO
- 安装来源：
- 安装程序光盘（D）：
- DVD驱动器（D:）GSP1RMCULXFRER_CN_DVD
- 服务器
- 连接到VMware
- vCloud Air
- 安装程序光盘映像文件（iso）（M）：
- C:\Users\xullangweiDesktop\rhcsa.iso
- 浏览（R）..
- 稍后安装操作系统（S）。
- 创建的虚拟机将包含一个空白硬盘
- 帮助
- <上一步（B)
- 下—步（N）>
- 取消
- wmware
- OK
<!-- OCR_END -->

客户机操作系统选择 "RedHat7 64位" 或者 根据内核选择 "其他Linux内核3.x" 单击 "下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F）编辑（E）查看（V）虚拟机（M）选项卡（T）帮助（H）
- 主页
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 共享的虚拟机
- 选择客户机操作系统
- 此虚拟机中将安装哪种操作系统？
- PRO
- 客户机操作系统
- MicrosoftWindowsW)
- Linux(L)
- Novell NetWare(E)
- 服务器
- 连接到VMware
- Solaris(S)
- VMware ESx(x)
- vCloud Air
- 其他（0）
- 版本（v）
- RedHatEnterpriseLinux764f
- 帮助
- <上一步（B)
- 下—步（N)>
- 取消
- 0.1K/s
- 7%
- ymware
- OK/s
<!-- OCR_END -->

<!-- OCR_START -->
- VMwareWorkstation
- Red HatEnterprise Linux5
- 文件（F）编辑（E）查看（V)
- 虚拟机（M）选项卡（T）
- 帮助（RedHatEnterpriseLinux4
- RedHatEnterpriseLinux464位
- 主页×
- RedHatEnterpriseLinux3
- Q在此处键入内容进行
- RedHatEnterpriseLinux2
- 新RedHatLinux
- 我的计算机
- SunJavaDesktopSystem
- SUSELinuxEnterprise1264位
- 共享的虚拟机
- SUSELinuxEnterprise 11
- PRO
- SUSELinuxEnterprise1164位
- SUSELinuxEnterprise10
- SUSELinuxEnterprise1064位
- SUSELinuxEnterprise7/8/9
- SUSELinux
- SUSELinux64位
- Turbolinux
- Turbolinux64位
- 服务器
- 连接到VMware
- Ubuntu
- Ubuntu64位
- vCloud Air
- VMwarePhoton64位
- 内核
- 其他Linux2.6.x内核
- 其他Linux2.6.x内核64位
- 其他Linux2.4.x内核
- 其他Linux2.2.x内核
- 帮助
- <上—步（B)
- 下一步（N)>
- 取消
- OK/s
- wmware
- 7
- OKIs
<!-- OCR_END -->

修改虚拟机名称"centos7"，选择存储位置，单击 "下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F)
- 编辑（E）查看（V)
- 虚拟机（M）
- 选项卡（T）
- 帮助（H)
- 主页×
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 命名虚拟机
- 共享的虚拟机
- 您要为此虚拟机使用什么名称？
- PRO
- 虚拟机名称（V）：
- Red HatEnterrriseLinux764位
- centos7
- 位置（L）：
- 服务器
- 连接到VMware
- C:\Users\xuliangweiDocuments\Virtual Machines\RedHatEnterpr
- 浏览（R）..
- vCloudAir
- 在”编辑”>“首选项”中可更改默认位置。
- 保存到自己想保存的位置
- <上一步（B)
- 下一步(N)>
- 取消
- OK's
- ymware
- OKGs
<!-- OCR_END -->

选择处理器 1核即可，单击 "下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F）编辑（E)查看（V)
- 虚拟机（M）
- 选项卡（T）
- 帮助（H)
- 主页
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 共享的虚拟机
- 处理器配置
- 为此虚拟机指定处理器数里。
- PRO
- 处理器
- 处理器数量（P）：
- 每个处理器的核心数量（C）：
- 1
- 总处理器核心数量：
- 服务器
- 连接到VMware
- vCloudAir
- 帮助
- <上一步（B)
- 下一步(N)>
- 取消
- OK/s
- ymware
<!-- OCR_END -->

选择内存 "1024M" 单击 "下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F)编辑（E）查看（V)
- 虚拟机（M）
- 选项卡（T）帮助（H）
- 主页×
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 共享的虚拟机
- 此虚拟机的内存
- 您要为此虚拟机使用多少内存？
- PRO
- 指定分配给此虚拟机的内存量。内存大小必须为4MB的倍数。
- 64GB
- 此虚拟机的内存（M）：
- 2048
- MB
- 32GB
- 16GB
- 服务器
- 连接到VMware
- 8GB
- vCloudAir
- 4GB
- 最大推荐内存：
- 2GB
- 28672MB
- 1GB
- 512MB
- 口推荐内存：
- 256MB
- 2048MB
- 128MB
- 64MB
- 口客户机操作系统最低推荐内存：
- 32MB
- 1024MB
- 16MB
- 8MB
- 4MB
- 帮助
- <上一步（B)
- 下—步(N）>
- 取消
- vmware
- OKG
<!-- OCR_END -->

网络模式，选择"桥接"，单击"下一步"

<!-- OCR_START -->
- VMwareWorkstatior
- 文件（F编辑（E）查看（V）虚拟机（M）选项卡（T）帮助（H）
- 主页
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 网络类型
- 共享的虚拟机
- 要添加哪类网络？
- PRO
- 网络连接
- 使用桥接网络（R）
- 为客户机操作系统提供直接访问外部以太网网络的权限。客户机在外部网络上必须
- 有自己的IP地址。
- 服务器
- 连接到VMware
- 使用网络地址转换（NAT)（E）
- vCloudAir
- 为客户机操作系统提供使用主机IP地址访问主机拨号连接或外部以太网网络连接的
- 使用仅主机模式网络（H）
- 将客户机操作系统连接到主机上的专用虚拟网络。
- 不使用网络连接（T）
- 帮助
- <上一步（B)
- 下—步（N）>
- 取消
- OK's
- mware
- 7
<!-- OCR_END -->

IO控制器选择默认，单击"下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F）
- 编辑（E）查看（V）
- 虚拟机（M）
- 选项卡（T）
- 帮助（H）
- 主页x
- Q在此处键入内容进行..
- 我的计算机
- 共享的虚拟机
- 新建虚拟机向导
- 选择1/0控制器类型
- 您要使用何种类型的SCSI控制器？
- 1/0控制器类型
- SCSI控制器：
- 连接到VMware
- BusLogic(U)
- （不适用于64位客户机）
- vCloud Air
- LSI Logic（L)（推荐）
- LSI LogicSAS(S)
- 帮助
- <上一步（B)
- 下—步（N）>
- 取消
- OK/s
- wmware
<!-- OCR_END -->

磁盘类型也默认即可，单击"下一步"

<!-- OCR_START -->
- VMware Workstation
- 文件（F)编辑（E）查看（V)
- 虚拟机（M）选项卡（T）帮助（H）
- 主页x
- Q在此处键入内容进行
- 我的计算机
- 共享的虚拟机
- 新建虚拟机向导
- 选择磁盘类型
- 您要创建何种磁盘？
- 虚拟磁盘类型
- IDE(I)
- 连接到VMware
- SCSI(S)（推荐）
- vCloudAir
- SATA(A)
- 帮助
- <上一步（B)
- [下一步（N)>
- 取消
- OK'S
- wmware
- OK/
<!-- OCR_END -->

选择"创建新虚拟磁盘"，单击"下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F)编辑（E）查看（V)
- 虚拟机（M）
- 选项卡（T）
- 帮助（H）
- 主页×
- Q在此处键入内容进行
- 我的计算机
- 共享的虚拟机
- 新建虚拟机向导
- 选择磁盘
- 您要使用哪个磁盘？
- 磁盘
- 创建新虚拟磁盘（V）
- 连接到VMware
- 虚拟磁盘由主机文件系统上的一个或多个文件组成，客户机操作系统会将其视为单
- 个硬盘。虚拟磁盘可在一台主机上或多台主机之间轻松复制或移动。
- vCloudAir
- 使用现有虚拟磁盘（E）
- 选择此选项将重新使用之前配置的磁盘。
- 使用物理磁盘（适用于高级用户）P）
- 选择此选项将为虚拟机提供直接访问本地硬盘的权限。
- 帮助
- <上—步（B）
- 下—步（N)>
- 取消
- OKUS
- wmware
- OK/s
<!-- OCR_END -->

磁盘大小20G即可，选择"将虚拟磁盘存储为单个文件"，因为是NTFS磁盘所以不需要拆分，单击"下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F)编辑（E）查看（V)
- 虚拟机（M）
- 选项卡（T）帮助（H）
- 主页x
- Q在此处键入内容进行.
- 新建虚拟机向导
- 我的计算机
- 指定磁盘容里
- 共享的虚拟机
- 磁盘大小为多少？
- 最大磁盘大小（GB)（S）：
- I20.0
- 针对RedHatEnterpriseLinux764位的建议大小：20GB
- 口立即分配所有磁盘空间（A）。
- 分配所有容里可以提高性能，但要求所有物理磁盘空间立即可用。如果不立即分配
- 连接到VMware
- 所有空间，虚拟磁盘的空间最初很小，会随着您向其中添加数据而不断变大。
- vCloudAir
- 将虚拟磁盘存储为单个文件（0）
- 将虚拟磁盘拆分成多个文件（M）
- 拆分磁盘后，可以更轻松地在计算机之间移动虚拟机，但可能会降低大容里磁盘的
- 性能。
- 帮助
- <上——步（B)下—步（N)>
- 取消
- wmware
<!-- OCR_END -->

磁盘名称默认即可，单击"下一步"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F
- 编辑（E）查看（V）
- 虚拟机（M）
- 选项卡（T）帮助（H）
- 主页×
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 指定磁盘文件
- 共享的虚拟机
- 您要在何处存储磁盘文件？
- 磁盘文件
- 将使用此处所提供的文件名称创健一个50GB的磁盘文件。
- rhel7_node1.vmdk
- 浏览（R）.
- 连接到VMware
- vCloud Air
- 帮助
- <上一步(B)[下—步(N)>
- 取消
- wmware
- OK's
<!-- OCR_END -->

选择"自定义硬件"，删除不需要的硬件，添加光盘镜像（安装centos7系统）单击"完成"

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F）
- 编辑（E）查看（V）
- 虚拟机（M）选项卡（T）
- 帮助（H）
- 主页x
- Q在此处键入内容进行
- 新建虚拟机向导
- 我的计算机
- 已准备好创建虚拟机
- 共享的虚拟机
- 单击完成“创健虚拟机。然后可以安装RedHatEnterpriseLinux764位。
- 将使用下列设置创建虚拟机：
- 名称：
- rhel7_node1
- 位置：
- C:lvmware\rhel7_node1
- 版本：
- Workstation12.0
- 操作系统：
- RedHatEnterpriseLinux764位
- 连接到VMware
- vCloudAir
- 硬盘：
- 50GB
- 内存：
- 2048MB
- 网络适配器：
- NAT
- 其他设备：
- CD/DVD，USB控制器，打印机，声卡
- 自定义硬件（C
- <上一步（B)
- 完成
- 取消
- OKis
- wmware
<!-- OCR_END -->

<!-- OCR_START -->
- VMware Workstation
- 文件（F)编辑（E）查看（V)
- 虚拟机（M）
- 硬件
- 仓主页
- 设备
- 摘要
- 3D图形
- Q在此处键入内容进行.
- 加速3D图形(3)
- 内存
- 2GB
- 我的计算机
- 口处理器
- 1
- 新CD/DVD（SAT..自动检测
- 监视器
- 共享的虚拟机
- 网络适配器
- NAT
- 将主机设置用于监视器（U）
- 婴显示器
- 自动检测
- 指定监视器设置（S）：
- 监视器数量（N）：
- 任意监视器的最大分辨率（M）：
- 2560x1600
- ware
- Air
- 图形内存
- 图形内存可用的最大客户机内存量（x）：
- 768MB（推荐）
- 添加A)
- 移除（R）
- 关闭
- 帮助
- ymware
<!-- OCR_END -->

<!-- OCR_START -->
- VMwareWorkstation
- 文件（F）
- 编辑（E）查看（V）
- 虚拟机（M）
- 硬件
- 仓主页
- 设备
- 设备状态
- Q在此处键入内容进行
- 摘要
- 内存
- 2GB
- 已连接（C）
- 启动连接（0)
- 我的计算机
- 口处理器
- 共享的虚拟机
- 新CD/DVD（SAT.自动检测
- 网络适配器
- NAT
- 连接
- 显示器
- 自动检测
- 使用物理驱动器（P）：
- 使用ISO映像文件（M）：
- C:\Users\xuliangwei\Desktop
- 浏览（B)..
- ware
- 高级（v)...
- Air
- 添加（A)..
- 移除（R)
- 关闭
- 帮助
- ymware
<!-- OCR_END -->

---

| 安装CentOS7系统 |
| :--- |

完成后，就会出现虚拟机创建完的页面，单击"开启此虚拟机"，如下图所示

<!-- OCR_START -->
- rhel7_node1-VMwareWorkstation
- 文件（F）编辑（E）查看（V
- 虚拟机（M）
- 选项卡（T）
- 帮助（H）
- 主页
- rhel7_node1
- Q在此处键入内容进行
- 我的计算机
- RHCE254
- 开启此虚拟机
- RHCE124
- 编辑虚拟机设置
- 共享的虚拟机
- 设备
- 内存
- 2GB
- 口处理器
- 1
- 硬盘（SCSI
- 50GB
- CD/DVD（SATA）正在使用文件C.
- 网络适配器
- NAT
- 显示器
- 自动检测
- 描述
- 在此处键入对该虚拟机的描述。
- 虚拟机详细信息
- 状态：已关机
- 配置文件：C:\vmware\rhel7_node1\rhel7_node1.vmx
- 8%
- OK/s
- 硬件兼容性：
<!-- OCR_END -->

进入系统的安装界面

<!-- OCR_START -->
- CentOS7
- InstallCent0S7
- Testthismedia&installCentOS7
- Troubleshooting
- Press Tab for full configuration options on menu
- Iitems.
<!-- OCR_END -->

修改网卡名称

<!-- OCR_START -->
Cent0S7
InstallCent0S7
Testthismedia&installCentOS7
Troubleshooting
umlinuz initrd=initrd.imginst.stage2=hd:LABEL=Cent0S>x207x20x86_64 rd.1iue
checkquietnet.ifnames=0 biosdeuname=0
<!-- OCR_END -->

选择英文，continue

<!-- OCR_START -->
- CENTOS7INSTALLATION
- Help!
- CentOS
- WELCOMETOCENTOS7.
- What language would you like to use during the installation process?
- English
- English(United States)
- Afrikaans
- English (United Kingdom)
- English (India)
- Amharic
- English (Australia)
- dyell
- Arabic
- English (Canada)
- Assamese
- English (Denmark)
- Asturianu
- English (lreland)
- Eenapyckag
- Belarusian
- English (New Zealand)
- EbnrapcKИ
- Bulgarian
- English (Nigeria)
- Bengali
- English (Hong Kong SAR China)
- Quit
<!-- OCR_END -->

选择时区

<!-- OCR_START -->
- INSTALLATIONSUMMARY
- CENTOSZINSTALLATION
- Help!
- CentoS
- LOCALIZATION
- DATE&TIME
- KEYBOARD
- Americas/NewYork timezone
- English (US)
- LANGUAGESUPPORT
- English (United States)
- SOFTWARE
- INSTALLATION SOURCE
- SOFTWARESELECTION
- Local media
- Minimal Install
- SYSTEM
- INSTALLATIONDESTINATION
- KDUMP
- Quit
- Begin Installation
- We won't touch your disks until you click 'Be gin Installation'
- Please complete itemhttps://wwWidriverZeng.comg to the next step.
<!-- OCR_END -->

选择上海时区，可以在下拉菜单选择，也可以，点图片选择

<!-- OCR_START -->
- DATE&TIME
- CENTOS7INSTALLATION
- Done
- Help!
- Region:
- Asia
- City:
- Shanghai
- Network Time
- OFF
- 24-hour
- PM
- 03
- 08
- 2019
- OAM/PM
- Youneed to setupnetworkingfirst ifyohttps://wwWedriverzeng.com
<!-- OCR_END -->

选择系统初始安装软件包，可以使用最小化安装，也可以自己选择，一些组件安装

<!-- OCR_START -->
- centos7模板机
- <.>
- 要释放鼠标，请按：Control-8
- INSTALLATIONSUMMARY
- CENTOS7INSTALLATION
- Help!
- Centos
- DATE&TIME
- KEYBOARD
- Asia/Shanghai timezone
- English (US)
- LANGUAGE SUPPORT
- English(United States)
- SOFTWARE
- INSTALLATIONSOURCE
- SOFTWARESELECTION
- Local media
- Minimal Install
- SYSTEM
- INSTALLATIONDESTINATION
- KDUMP
- Automaticpartitioningselected
- Kdump is enabled
- NFTWORKRHOSTNAME
- SFCURITYPOIICY
- Quit
- Begin Installation
- We won't touch your disks until you click 'Be gin Installation'
- Please complete itenhttps://wwWidriverZeng.comg to the next step.
<!-- OCR_END -->

可以选择一些开发工具，调试工具

选择系统安装位置，（磁盘分区）

<!-- OCR_START -->
- INSTALLATIONSUMMARY
- CENTOS7INSTALLATION
- Help!
- CentoS
- DATE&TIME
- KEYBOARD
- Asia/Shanghai timezone
- English (US)
- LANGUAGESUPPORT
- English (United States)
- SOFTWARE
- INSTALLATIONSOURCE
- SOFTWARESELECTION
- Local media
- Minimal Install
- SYSTEM
- INSTALLATIONDESTINATION
- KDUMP
- Automatic partitioning selected
- Kdumpis enabled
- NETWORK&HOSTNAME
- SECURITYPOLICY
- Not connected
- No profile selected
- Quit
- Begin Installation
- https://www.driverzeng.comouch your disks until you click'Begin Installation'
<!-- OCR_END -->

**1.磁盘分区介绍**

**1)最基本分区方式：**

**CentOS6中:**

> /boot：500M
>
> swap：内存的1~2倍（峰值16G）
>
> /：剩余空间都给/
>

**CentOS7中:**

> /boot：1024M
>
> swap：内存1~2倍（峰值16G）
>
> /：剩余空间都给/
>

**2)公有云，虚拟化分区方式：**

> /boot：500~1024
>
> /：剩余的都给/
>
> 没有swap分区：因为swap分区是虚拟内存，性能不如内容，本来就是虚拟化产品，再使用swap，性能会更差。
>

**3)根据服务器用途分区方式:**

**数据服务器:**

> /boot：500M
>
> swap：内存的1~2倍（峰值16G）
>
> /data：根据公司数据量来定（1T）
>
> /：剩余空间都给/
>

**备份服务器:**

> /boot：500M
>
> swap：内存的1~2倍（峰值16G）
>
> /backup：根据公司数据量来定（2T）
>
> /：剩余空间都给/
>

**2.文件系统介绍**

CentOS5：ext2（没有系统日志）、ext3

CentOS6：ext4

CentOS7：xfs

Windows：FAT32、NTFS

选择手动分区，根据上面推荐方式进行分区

<!-- OCR_START -->
centos7模板机
要释放鼠标，请按：Control-8
INSTALLATIONDESTINATION
CENTOS7INSTALLATION
Done
Help!
Device Selection
Select the device(s) you'd like to install to. They will be left untouched until you click on the main menu's
"Begin Installation" button.
Local Standard Disks
20 GiB
VMware, VMware Virtual S
sda/
992.5KiB free
Disks left unselected here will not be touched
Specialized & Network Disks
Add a disk...
Other Storage Options
Partitioning
自己手动分区
Automatically configure partitioning.
O I will configure partitioning.
]I would like to make additional space available.
Full disk summary and boot loader...
Refresh.
<!-- OCR_END -->

<!-- OCR_START -->
2
<>
centos7模板机
要释放鼠标，请按：Control-
MANUAL PARTITIONING
CENTOS7INSTALLATION
Done
Help!
New Centos7Installation
You havent created any mount points for your CentOS
7 installation yet. You can:
可以选择自动创建分区
Click here to create them automatically.
● Create new mount points by clicking the '+' button.
New mount points will use the following partitioning
scheme:
LVM
不使用LVM逻辑卷分区
When you create mount points for your CentOS 7 installation,
you'll be able to view their details here.
可以手动添加分区
AVAILABLE SPACE
TOTAL SPACE
20GiB
1 storaqe device selected
Reset All
<!-- OCR_END -->

首先创建boot分区，1024G

<!-- OCR_START -->
<>
centos7模板机
要释放鼠标，请按：Control-
MANUAL PARTITIONING
CENTOS7INSTALLATION
Done
Help!
New Centos 7 Installation
You havent created any mount points for your CentOS
7 installation yet. You can:
Click here to create them automatically.
● Create new mount points by c
ADDANEWMOUNTPOINT
New mount points will use the fc
scheme:
More customization options are available
after creating the mount point below.
Standard Partition
Mount Point:
/boot
1024
Desired Capacity
nts for your CentOS 7 installation,
etails here.
Cancel
Add mount point
AVAILABLE SPACE
TOTAL SPACE
20GiB
1 storaqe device selected
Reset All
<!-- OCR_END -->

然后创建swap分区，1024G

<!-- OCR_START -->
- <>
- centos7模板机
- 要释放鼠标，请按：Control-8
- MANUAL PARTITIONING
- CENTOS7INSTALLATION
- Done
- Help!
- New CentOs7 Installation
- sdal
- SYSTEM
- Mount Point:
- Device(s):
- /boot
- 1024MiB
- sda1
- VMware, VMware Virtual S
- (sda)
- ADD ANEWMOUNTPOINT
- Modify..
- More customization options are available
- after creating the mount point below.
- swap
- Desired Capacit
- 1024
- Cancel
- Add mount point
- Label:
- Name:
- AVAILABLE SPACE
- TOTAL SPACE
- 19GiB
- 20 GiB
- 1 storaqe device selected
- Reset All
<!-- OCR_END -->

最后将剩余空间全部分配给/分区

<!-- OCR_START -->
- <>
- >>
- centos7模板机
- 要释放鼠标，请按：Control-8
- MANUAL PARTITIONING
- CENTOS7INSTALLATION
- Done
- Help!
- New Centos 7 Installation
- sda2
- SYSTEM
- Mount Point:
- Device(s):
- /boot
- 1024 MiB
- sdal
- VMware, VMware Virtual S
- (sda)
- swap
- ADDANEWMOUNTPOINT
- Modify..
- More customization options are available
- after creating the mount point below.
- Desired Capacity
- Cancel
- Add mount point
- Label:
- Name:
- AVAILABLE SPACE
- TOTAL SPACE
- 18GiB
- 20 GiB
- 1 storaqe device selected
- Reset All
<!-- OCR_END -->

完成分区

<!-- OCR_START -->
- <>
- centos7模板机
- 要释放鼠标，请按：Control-8
- MANUAL PARTITIONING
- CENTOS7INSTALLATION
- Done
- Help!
- 理LS
- TNew CentOs7 Installatinn
- sda3
- SUMMARY OF CHANGES
- Your customizations will result in the following changes taking effect after you return to the main menu and begin installation:
- Order
- Action
- Type
- Device Name
- Mount point
- 1
- Destroy Format Unknown
- sda
- 2
- Create Format
- partition table (MSDOS) sda
- 3
- Create Device
- partition
- sda1
- 4
- sda2
- 6
- xfs
- swap
- 8
- sdal
- /boot
- Cancel &Return to Custom Partitioning
- Accept Changes
- AVAILABLESPACE
- TOTAL SPACE
- 992.5KiB
- 20 GiB
- 1 storage device selected
- Reset All
<!-- OCR_END -->

关闭Kdump

<!-- OCR_START -->
- 21
- <>
- centos7模板机
- 要释放鼠标，请按：Control-8
- INSTALLATIONSUMMARY
- CENTOS7INSTALLATION
- Help!
- CentOS
- DATE &TIME
- KEYBOARD
- Asia/Shanghai timezone
- English (US)
- LANGUAGESUPPORT
- English (United States)
- SOFTWARE
- INSTALLATIONSOURCE
- SOFTWARESELECTION
- Local media
- Minimal Install
- SYSTEM
- INSTALLATIONDESTINATION
- KDUMP
- Custom partitioning selected
- Kdump is enabled
- NETWORK&HOSTNAME
- SECURITYPOLICY
- Not connected
- No profile selected
- Quit
- Begin Installation
- https://www.driverzeng.Combuch your disks until you click'Begin Installation.
<!-- OCR_END -->

<!-- OCR_START -->
- <>
- centos7模板机
- 要释放鼠标，请按：Control-8
- KDUMP
- CENTOS7INSTALLATION
- Done
- Help!
- Kdump is a kernel crash dumping mechanism. In the event of a system crash, kdump will capture information from your system that
- can be invaluable in determining the cause of the crash. Note that kdump does require reserving a portion of system memory that
- will be
- Tavailable for other uses.
- 将此处原本的勾，取消
- Enable kdump
- Kdump Memory Reservation:
- Automatic
- Manual
- MemoryToBeReserved(MB)
- 128
- Total System Memory (MB):
- 1982
- UsableSystem Memory (MB):1854
<!-- OCR_END -->

设置网络和主机名

<!-- OCR_START -->
- <>
- centos7模板机
- 要释放鼠标，请按：Control-
- INSTALLATIONSUMMARY
- CENTOS7INSTALLATION
- Help!
- DATE&TIME
- CEntOS
- KEYBOARD
- Asia/Shanghai timezone
- English (US)
- LANGUAGESUPPORT
- English (United States)
- SOFTWARE
- INSTALLATIONSOURCE
- SOFTWARESELECTION
- Local media
- Minimal Install
- SYSTEM
- INSTALLATIONDESTINATION
- KDUMP
- Custom partitioning selected
- Kdump is disabled
- NETWORK&HOSTNAME
- SECURITYPOLICY
- Not connected
- No profile selected
- Quit
- Begin Installation
- https://www.driverzeng.compuch your disks until you click'Begin Installation'.
<!-- OCR_END -->

<!-- OCR_START -->
- 2
- <>
- centos7模板机
- 要释放鼠标，请按：Control-8
- NETWORK&HOSTNAME
- CENTOS7INSTALLATION
- Done
- Help!
- Ethernet (etho)
- OFF
- Intel Corporation 82545EM Gigabit Ethernet Controller
- Disconnected
- Hardware Address 00:0C:29:F5:E3:CF
- Speed 1000 Mb/s
- Configure..
- Host name:
- localhost.localdomain
- Apply
- Current host name:
<!-- OCR_END -->

<!-- OCR_START -->
- Editing etho
- Connection name:
- etho
- General
- Ethernet
- 802.1XSecurity
- DCB
- Proxy
- IPv4Settings
- IPv6 Settings
- Automatically connect to this network when it is available
- Connection priority for auto-activation:
- All users may connect to this network
- Automatically connect to VPN when using this connection
- Cancel
- Save
<!-- OCR_END -->

<!-- OCR_START -->
- Editing etho
- Connection name:
- etho
- General
- Ethernet
- 802.1XSecurity
- DCB
- Proxy
- IPv4 Settings
- IPv6Settings
- Method:
- Manual
- Addresses
- Address
- Netmask
- Gateway
- Add
- 10.0.0.100
- 255.255.255.0
- 10.0.0.2
- Delete
- DNS servers:
- Search domains:
- DHCP client ID:
- Require IPv4 addressing for this connection to complete
- Routes...
- Cancel
- Save
<!-- OCR_END -->

<!-- OCR_START -->
- 2
- <>
- centos7模板机
- 要释放鼠标，请按：Control-
- NETWORK&HOSTNAME
- CENTOS7INSTALLATION
- Done
- Help!
- Ethernet(etho)
- ON
- Intel Corporation 82545EM Gigabit Ethernet Controller
- Connected
- Hardware Address 00:0C:29:F5:E3:CF
- Speed 1000 Mb/s
- IP Address 10.0.0.100
- Subnet Mask 255.255.255.0
- Default Route 10.0.0.2
- DNS 10.0.0.2
- Configure...
- Host name:
- centos7
- Apply
- Current host name:
<!-- OCR_END -->

开始安装系统

<!-- OCR_START -->
- <.>
- centos7模板机
- 要释放鼠标，请按：Control-8
- INSTALLATIONSUMMARY
- CENTOS7INSTALLATION
- Help!
- DATE&TIME
- Centos
- KEYBOARD
- Asia/Shanghai timezone
- English (US)
- LANGUAGE SUPPORT
- English (United States)
- SOFTWARE
- INSTALLATIONSOURCE
- SOFTWARESELECTION
- Local media
- Minimal Install
- SYSTEM
- INSTALLATIONDESTINATION
- KDUMP
- Custom partitioning selected
- Kdump is disabled
- NETWORK&HOSTNAME
- SECURITYPOLICY
- Wired(etho)connected
- No profile selected
- Quit
- Begin Installation
- https://www.driverZeng.comouch your disks until you click'Begin Installation.
<!-- OCR_END -->

给系统用户设置密码

<!-- OCR_START -->
<>
centos7模板机
要释放鼠标，请按：Control-
CONFIGURATION
CENTOS7INSTALLATION
Help!
Centos
USERSETTINGS
ROOTPASSWORD
USER CREATION
Rootpassword isnot set
Nouserwillbecreated
Starting package installation process
CentOSCoreSIG
oduces the Centos LinuxDistribution.
Ki.centos.org/SpeciallnterestGroup
Please complete itemhttps://www.driverzeng.comg tothenext step.
<!-- OCR_END -->

<!-- OCR_START -->
- <>
- centos7模板机
- >>
- 要释放鼠标，请按：Control-8
- ROOTPASSWORD
- CENTOS7INSTALLATION
- Done
- Help!
- The root account is used for administering the system. Enter a password for the root user.
- 密码1
- Tooshort
- Confirm:
- Thepassword is too short.You will have thttps://www.driverZeng.com
<!-- OCR_END -->

> 更新: 2024-09-20 21:54:17  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/vhwpxk>