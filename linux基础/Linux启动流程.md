# Linux启动流程

[Linux启动流程.pdf](https://www.yuque.com/attachments/yuque/0/2019/pdf/194754/1554022046140-03f26a2d-b248-4806-9c38-e24c7d6a9c0f.pdf)



[Linux系统计划任务.pdf](https://www.yuque.com/attachments/yuque/0/2019/pdf/194754/1554022051031-042edb15-5062-4d27-8229-446fd258b937.pdf)







<font style="color:rgb(25,128,230);"></font>

# <font style="color:rgb(44,63,81);">Linux系统的组成： </font>
<font style="color:rgb(44,63,81);">内核 </font><font style="color:rgb(44,63,81);">+ </font><font style="color:rgb(44,63,81);">根文件系统 </font>

<font style="color:rgb(44,63,81);">内核可实现以下功能： </font>

<font style="color:rgb(44,63,81);">进程管理、内存管理、网络协议栈、文件系统、安全功能、驱动程序。 </font>

<font style="color:rgb(44,63,81);">内核是</font><font style="color:rgb(44,63,81);">linux</font><font style="color:rgb(44,63,81);">的整个核心，确切的说内核即是</font><font style="color:rgb(44,63,81);">Linux</font><font style="color:rgb(44,63,81);">，其他程序都是通过调度内核来实现其功 </font>

<font style="color:rgb(44,63,81);">能。 </font>

<font style="color:rgb(44,63,81);"></font>

<font style="color:rgb(44,63,81);">运行中的系统环境分层： </font>

<font style="color:rgb(44,63,81);">内核空间 </font><font style="color:rgb(44,63,81);">+ </font><font style="color:rgb(44,63,81);">用户空间 </font>

<font style="color:rgb(44,63,81);">内核空间： 由内核代码组成，拥有系统级别权限，可直接更改硬件； </font>

<font style="color:rgb(44,63,81);">用户空间： 由各种应用程序组成，通过调用内核来完成各种复杂的任务。 </font>

# <font style="color:rgb(44,63,81);">CentOS6的启动流程</font>
![1725376112836-a1ebf038-8cfd-4360-b95a-65c66e3491a1.png](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-01.png)



<font style="color:rgb(44,63,81);">1.</font><font style="color:rgb(44,63,81);">开机自检</font>

<font style="color:rgb(44,63,81);">这个过程是开机后，</font><font style="color:rgb(44,63,81);">BIOS</font><font style="color:rgb(44,63,81);">或</font><font style="color:rgb(44,63,81);">UEFI</font><font style="color:rgb(44,63,81);">进行硬件检查的阶段 </font>

<font style="color:rgb(44,63,81);">2.MBR</font><font style="color:rgb(44,63,81);">引导 </font>

<font style="color:rgb(44,63,81);">自检硬件没有问题时候，这里以</font><font style="color:rgb(44,63,81);">BIOS</font><font style="color:rgb(44,63,81);">为例，</font><font style="color:rgb(44,63,81);">BIOS</font><font style="color:rgb(44,63,81);">将会直接去找硬盘的第一个扇区，找 </font>

<font style="color:rgb(44,63,81);">到前</font><font style="color:rgb(44,63,81);">446</font><font style="color:rgb(44,63,81);">字节，将</font><font style="color:rgb(44,63,81);">MBR</font><font style="color:rgb(44,63,81);">加载到内存中，</font><font style="color:rgb(44,63,81);">MBR</font><font style="color:rgb(44,63,81);">将告诉程序下一阶段去哪里找系统</font><font style="color:rgb(44,63,81);">grub</font><font style="color:rgb(44,63,81);">引 </font>

<font style="color:rgb(44,63,81);">导。此阶段属于</font><font style="color:rgb(44,63,81);">grub</font><font style="color:rgb(44,63,81);">的第一阶段。</font><font style="color:rgb(44,63,81);">grub</font><font style="color:rgb(44,63,81);">还有</font><font style="color:rgb(44,63,81);">1.5</font><font style="color:rgb(44,63,81);">阶段和</font><font style="color:rgb(44,63,81);">2</font><font style="color:rgb(44,63,81);">阶段。 </font>

<font style="color:rgb(44,63,81);">3.GRUB</font><font style="color:rgb(44,63,81);">引导 </font>

<font style="color:rgb(44,63,81);">-grub第1.5和2阶段，信息默认存放在扇区中,如果使用grub­install生成的2阶段的文件 </font>

<font style="color:rgb(44,63,81);">是存放在</font><font style="color:rgb(44,63,81);">/boot</font><font style="color:rgb(44,63,81);">分区中的。 </font>

<font style="color:rgb(44,63,81);">- 为了加载内核系统，不得不加载/boot分区，而加载/boot分区，需要有/boot分区的驱 </font>

<font style="color:rgb(44,63,81);">动，</font><font style="color:rgb(44,63,81);">/boot</font><font style="color:rgb(44,63,81);">分区驱动是放在</font><font style="color:rgb(44,63,81);">/boot</font><font style="color:rgb(44,63,81);">分区中的</font><font style="color:rgb(44,63,81);">,</font><font style="color:rgb(44,63,81);">啊，我们好像进入了死循环了，</font><font style="color:rgb(44,63,81);">Linux</font><font style="color:rgb(44,63,81);">是怎么 </font>

<font style="color:rgb(44,63,81);">解决的呢？就是靠放在</font><font style="color:rgb(44,63,81);">1.5</font><font style="color:rgb(44,63,81);">阶段中的数据，是放在第一个扇区后的后续扇区中，具体占 </font>

<font style="color:rgb(44,63,81);">用多少字节，不太清楚，只知道</font><font style="color:rgb(44,63,81);">1.5</font><font style="color:rgb(44,63,81);">阶段和</font><font style="color:rgb(44,63,81);">2</font><font style="color:rgb(44,63,81);">阶段总共</font><font style="color:rgb(44,63,81);">27</font><font style="color:rgb(44,63,81);">个扇区。 </font>

<font style="color:rgb(44,63,81);">-stage1.5： </font>

<font style="color:rgb(44,63,81);">mbr</font><font style="color:rgb(44,63,81);">之后的扇区，识别</font><font style="color:rgb(44,63,81);">stage2</font><font style="color:rgb(44,63,81);">所在的分区上的文件系统 </font>

<font style="color:rgb(44,63,81);">-stage2： </font>

<font style="color:rgb(44,63,81);">开机启动的时候看到的</font><font style="color:rgb(44,63,81);">Grub</font><font style="color:rgb(44,63,81);">选项、信息，还有修改</font><font style="color:rgb(44,63,81);">GRUB</font><font style="color:rgb(44,63,81);">背景等功能都是</font><font style="color:rgb(44,63,81);">stage2</font><font style="color:rgb(44,63,81);">提供 </font>

<font style="color:rgb(44,63,81);">的，</font><font style="color:rgb(44,63,81);">stage2</font><font style="color:rgb(44,63,81);">会去读入</font><font style="color:rgb(44,63,81);">/boot/grub/grub.conf</font><font style="color:rgb(44,63,81);">或者</font><font style="color:rgb(44,63,81);">menu.lst</font><font style="color:rgb(44,63,81);">等配置文件 </font>

<font style="color:rgb(44,63,81);">4.</font><font style="color:rgb(44,63,81);">读取</font><font style="color:rgb(44,63,81);">grub.conf</font><font style="color:rgb(44,63,81);">文件 </font>

<font style="color:rgb(44,63,81);">读取</font><font style="color:rgb(44,63,81);">grub.conf</font><font style="color:rgb(44,63,81);">文件以确定内核启动的参数，准备启动内核 </font>

<font style="color:rgb(44,63,81);">5.</font><font style="color:rgb(44,63,81);">启动内核</font>

<font style="color:rgb(44,63,81);">-加载内核，核心开始解压缩，启动一些最核心的程序。 </font>

<font style="color:rgb(44,63,81);">-因为为了让内核足够轻小，硬件驱动并没有放在内核文件里面，我们可以看到内核很 </font>

<font style="color:rgb(44,63,81);">小</font><font style="color:rgb(44,63,81);">,</font><font style="color:rgb(44,63,81);">才</font><font style="color:rgb(44,63,81);">4M</font><font style="color:rgb(44,63,81);">左右，我们可以想象</font><font style="color:rgb(44,63,81);">Windows</font><font style="color:rgb(44,63,81);">中的驱动，安装系统时候还需要使用驱动软件下 </font>

<font style="color:rgb(44,63,81);">载好长时间呢 </font>

<font style="color:rgb(44,63,81);">-因此需要使用/initramfs­2.6.32­696.el6.x86_64.img来驱动硬件</font>

<font style="color:rgb(44,63,81);"></font>

```bash
[root@oldboy ~]# ll -h /boot/vmlinuz-2.6.32-696.el6.x86_64 
-r-xr-xr-x. 1 root root 4.1M Jul 8 21:06 /boot/vmlinuz-2.6.32-696.el6.x8 6_64
```

<font style="color:rgb(44,63,81);">6.加载伪文件系统（ramdisk）， </font>

<font style="color:rgb(44,63,81);">内核已将启动起来了，再调用</font><font style="color:rgb(44,63,81);">ramdisk</font><font style="color:rgb(44,63,81);">文件，尝试驱动所有的硬件设备，到这一步，内 </font>

<font style="color:rgb(44,63,81);">核起来了，所有驱动也装上了，因此后面的启动就可以交给程序了 </font>

<font style="color:rgb(44,63,81);">7.启动init进程 </font>

```bash
(1)读取/etc/inittab文件 
inittab文件里面定义了系统默认运行级别，这一步做了一些工作如下： 
a)初始运行级别(RUN LEVEL)
b)系统初始化脚本 
c)对应运行级别的脚本目录 
d)定义UPS电源终端/恢复脚本 
e)在虚拟控制台生成getty,以生成终端 
f)在运行级别5初始化X 

(2)执行/etc/rc.d/rc.sysinit程序 系统初始化一些脚本，主要完成以下工作 
a)设置主机名 
b)设置欢迎信息 
c)激活udev和selinux可以在grub.conf中,kernel行添加selinux=0以关闭selinux
d)挂载/etc/fstab文件中定义的文件系统 
e)检测根文件系统，并以读写方式重新挂载根文件系统 
f)设置系统时钟 
g)激活swap设备 
h)根据/etc/sysctl.conf文件设置内核参数 
i)激活lvm及software raid设备
j)加载额外设备的驱动程序 
k)清理操作 

(3)/etc/rc#.d/文件（各种服务） 
里面定义的是各种服务的启动脚本，可以ls查看，S开头代表开机启动的服务，K开头的是关机要执 行的任务。#代表数字，一个数字代表一个运行级别，共7个运行级别，这里就不多说了 

4)/etc/rc.d/rc.local文件 
这里面可以自定义开机启动的命令

```

<font style="color:rgb(44,63,81);">8.执行/bin/login </font>

<font style="color:rgb(44,63,81);">执行</font><font style="color:rgb(44,63,81);">/bin/login</font><font style="color:rgb(44,63,81);">程序，等待用户登录 </font>

<font style="color:rgb(44,63,81);"></font>

<font style="color:rgb(44,63,81);">了解CentOS系统启动流程对我们有什么帮助 </font>

<font style="color:rgb(44,63,81);">在实际工作中，</font><font style="color:rgb(44,63,81);">CentOS</font><font style="color:rgb(44,63,81);">主机难免会出现无法启动或启动异常，而在了解了</font><font style="color:rgb(44,63,81);">CentOS</font><font style="color:rgb(44,63,81);">系统启 </font>

<font style="color:rgb(44,63,81);">动流程后，可以针对问题对症下药，而且通过学习</font><font style="color:rgb(44,63,81);">CentOS</font><font style="color:rgb(44,63,81);">系统启动流程后，可掌握部分的 </font>

<font style="color:rgb(44,63,81);">Linux工作机制，为以后的解决Linux故障打下扎实的基础。 </font>

<font style="color:rgb(44,63,81);"></font>

#  Systemd初始化进程  
 CentOS7/RHEL7 系统的开机启动过程如下: 



1.首先BIOS开机自检 

2.然后进入启动菜单,加载系统内核 

3.然后内核进行初始化 

4.最后启动初始化进程  



 初始化进程作为Linux系统的第一个进程，它需要完成Linux系统中相关的初始化工作，为用户提供 合适的工作环境。 RHEL/CentOS 7 系统已经替换掉了熟悉的初始化进程服务System V init正式采用 全新的systemd初始化进程服务。如果您之前学习的是 RHEL/CentOS 6或7 系统，可能会不习惯。 systemd初始化进程服务采用了并发启动机制，开机速度得到了不小的提升。 



CentOS6系统, 管理员可以使用如下指令来管理服务器的启动与停止  

```bash
//关机相关命令
shutdown -h now 			//立即关机，常用
init 0 								//切换系统关机级别，容易理解
//重启相关命令
reboot 								//重启命令，常用
init 6 								//切换系统重启级别，容易理解
```

 CentOS7系统, 管理员可以使用systemctl命令来管理服务器启动与停止  

```bash
//关机相关命令
systemctl poweroff   //立即关机，常用
//重启相关命令
systemctl reboot     //重启命令，常用
```

#  Systemd目标名称  
 无论如何, RHEL/CentOS 7 已经没有了“运行级别”这个概念，Linux系统在启动时要进行大量的初始 化工作，比如挂载文件系统和交换分区、启动各类进程服务等，这些都可以看作是一个一个的单元 Unit, systemd用目标target代替了 System V init 中运行级别的概念，这两者的区别如下所示  

![1725789549116-8f7cc825-2ba4-4ef9-bd60-93bdceb134bb.png](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-02.png)

 RHEL/CentOS6 系统运行级别管理  

```bash
//查看运行级别
[root@student ~]# runlevel
N 3 //如果N是其他数字,代表上一次运行级别
//切换运行级别
[root@student ~]# init 3

//永久修改配置文件
[root@student ~]# /etc/inittab

```

 RHEL/CentOS7 系统目标管理  

```bash
//查看系统默认启动运行级别
[root@student ~]# systemctl get-default

//修改默认启动运行级别（永久生效）
[root@student ~]# systemctl set-default TARGET.target
# multi-user.target: analogous to runlevel 3
# graphical.target: analogous to runlevel 5
```

#  systemd服务管理  
 由于之前长期使用 RHEL/CentOS 6 系统, 已经习惯使用 service chkconfig 等命令来管理系统服 务，但在 RHEL/CentOS 7 系统中是使用systemctl命令来管理服务的。 



如下是 RHEL/CentOS 6 系统中 System V init 命令与 RHEL/CentOS 7 系统中systemctl命令的对 比，后续课程中会经常用到它们。 



systemctl管理服务的启动、重启、停止、重载、查看状态等常用命令  

![1725789655272-8c5dd15a-d741-40ec-8bb5-0ef4bcaa6101.png](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-03.png)

 systemctl设置服务开机启动、不启动、查看各级别下服务启动状态等常用命令  

![1725789677575-51d70e51-56cc-4434-bc6e-0913042045c1.png](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-04.png)

 systemctl服务状态说明  

![1725789701445-dbef9260-c675-4026-9029-504df77c4b20.png](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-05.png)











# 面试题
## linux 启动过程  centos6 *****
开机自检(BIOS) --> MBR引导 –>GRUB菜单—> 加载内核(Kernel)

-->INIT进程—> 读取/etc/inittab配置文件—》执行/etc/rc.d/rc.sysinit脚本

---> 执行/etc/rc.d/rc脚本  --> 启动mingetty进程



![1546492204918-33cbe446-7c0d-410d-b593-e3454f9ec584-image2.png](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-06.png)



## linux 启动过程  centos7  ****
```bash

一  BIOS阶段
1当计算机启动时，首先由 BIOS（基本输入/输出系统）进行硬件自检
（POST，Power-On Self Test），检查硬件是否正常工作，如内存、硬盘、CPU 等。
2 BIOS 会根据设置的启动顺序（例如，从硬盘、光驱、USB 等设备中选择），
找到可启动的设备。

二 MBR或 UEFI阶段
1 如果是传统的 MBR（主引导记录）方式：
硬盘的主引导记录（MBR）被加载到内存中，
MBR 中包含一个引导加载程序（通常是 GRUB Legacy）。

2 如果是 UEFI（统一可扩展固件接口）方式：
UEFI 固件会读取硬盘上的 UEFI 引导分区中的引导管理器（例如 GRUB2 for UEFI）。
引导管理器负责加载操作系统内核。

三、GRUB 阶段
1 GRUB（Grand Unified Bootloader）显示启动菜单，
用户可以选择要启动的操作系统（如果有多个操作系统安装在同一台计算机上）
或选择不同的内核版本和启动参数。
2 当用户选择了 CentOS 7 后，GRUB 会根据配置文件加载内核镜像（vmlinuz）
和初始内存磁盘（initramfs）到内存中。

四、内核初始化阶段
1 内核（kernel）开始执行，它首先进行自身的初始化，包括检测硬件、初始化设备驱动程序等。
2 内核挂载根文件系统，它会从 initramfs 中获取必要的驱动和模块，
以确保能够访问真正的根文件系统。

五、Systemd 阶段
1 一旦根文件系统被挂载，内核会执行 systemd 进程（PID 1），它是 CentOS 7 的系统和服务管理器。
2 systemd 会执行一系列的初始化任务，如设置主机名、加载内核模块、启动各种服务等。
3 systemd 会根据默认的运行级别（通常是 3 或 5，分别对应多用户文本模式和图形模式）
来启动相应的服务和应用程序。

六、用户登录阶段
1 当所有必要的服务都启动完成后，根据运行级别，会启动相应的显示管理器
（如在图形模式下是 GDM）或登录提示符（在文本模式下）。
2 用户输入用户名和密码进行登录，登录成功后，
用户可以开始在系统中进行操作和使用各种应用程序。




```



# 




> 更新: 2026-04-23 14:03:08  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/mg4qu5>