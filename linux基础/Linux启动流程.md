# Linux 启动流程

> 本文讲解 Linux 系统组成、CentOS 6 与 CentOS 7 的完整启动流程、systemd 初始化进程/目标/服务管理，并附面试常问的启动过程描述。

配套资料：
[Linux启动流程.pdf](https://www.yuque.com/attachments/yuque/0/2019/pdf/194754/1554022046140-03f26a2d-b248-4806-9c38-e24c7d6a9c0f.pdf)
[Linux系统计划任务.pdf](https://www.yuque.com/attachments/yuque/0/2019/pdf/194754/1554022051031-042edb15-5062-4d27-8229-446fd258b937.pdf)

## 一、Linux 系统的组成

**系统 = 内核 + 根文件系统**

**内核可实现的功能**：进程管理、内存管理、网络协议栈、文件系统、安全功能、驱动程序。

> 内核是 Linux 的整个核心，确切地说**内核即是 Linux**，其他程序都是通过调度内核来实现其功能。

**运行中的系统环境分层**：

| 空间 | 组成 | 权限 |
| --- | --- | --- |
| **内核空间** | 由内核代码组成 | 拥有系统级别权限，可直接更改硬件 |
| **用户空间** | 由各种应用程序组成 | 通过调用内核来完成各种复杂任务 |

## 二、CentOS 6 的启动流程

![CentOS6启动流程](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-01.png)

### 1. 开机自检
开机后 BIOS 或 UEFI 进行硬件检查的阶段。

### 2. MBR 引导
自检硬件无问题后（以 BIOS 为例），BIOS 直接去找硬盘的第一个扇区，找到**前 446 字节**，将 MBR 加载到内存中。MBR 告诉程序下一阶段去哪里找系统 grub 引导。此阶段属于 **grub 第一阶段**（grub 还有 1.5 阶段和 2 阶段）。

### 3. GRUB 引导
- grub 第 1.5 和 2 阶段信息默认存放在扇区中；若使用 `grub-install` 生成的 2 阶段文件则存放在 `/boot` 分区。
- **"先有鸡还是先有蛋"的问题**：为了加载内核，不得不加载 `/boot` 分区；而加载 `/boot` 分区需要 `/boot` 分区的驱动，驱动又放在 `/boot` 分区里……Linux 靠 **1.5 阶段**的数据解决——它放在第一个扇区之后的后续扇区中（1.5 和 2 阶段总共 27 个扇区）。
- **stage1.5**：位于 MBR 之后的扇区，用于识别 stage2 所在分区上的文件系统。
- **stage2**：开机看到的 Grub 选项、信息，以及修改 GRUB 背景等功能都由 stage2 提供；stage2 会读入 `/boot/grub/grub.conf` 或 `menu.lst` 等配置文件。

### 4. 读取 grub.conf 文件
读取 `grub.conf` 以确定内核启动参数，准备启动内核。

### 5. 启动内核
- 加载内核，核心开始解压缩，启动一些最核心的程序。
- 为了让内核足够轻小，硬件驱动**并没有放在内核文件里面**（内核才 4M 左右）：
```bash
[root@oldboy ~]# ll -h /boot/vmlinuz-2.6.32-696.el6.x86_64
-r-xr-xr-x. 1 root root 4.1M Jul 8 21:06 /boot/vmlinuz-2.6.32-696.el6.x86_64
```
- 因此需要使用 `/initramfs-2.6.32-696.el6.x86_64.img` 来驱动硬件。

### 6. 加载伪文件系统（ramdisk）
内核已启动，再调用 ramdisk 文件，尝试驱动所有硬件设备。至此内核起来了、驱动也装上了，后面的启动就可以交给程序了。

### 7. 启动 init 进程
```bash
# (1) 读取 /etc/inittab 文件
# inittab 定义了系统默认运行级别，做了以下工作：
a) 初始运行级别(RUN LEVEL)
b) 系统初始化脚本
c) 对应运行级别的脚本目录
d) 定义 UPS 电源中断/恢复脚本
e) 在虚拟控制台生成 getty，以生成终端
f) 在运行级别 5 初始化 X

# (2) 执行 /etc/rc.d/rc.sysinit 程序（系统初始化脚本），主要完成：
a) 设置主机名
b) 设置欢迎信息
c) 激活 udev 和 selinux（可在 grub.conf 的 kernel 行添加 selinux=0 关闭）
d) 挂载 /etc/fstab 中定义的文件系统
e) 检测根文件系统，并以读写方式重新挂载
f) 设置系统时钟
g) 激活 swap 设备
h) 根据 /etc/sysctl.conf 设置内核参数
i) 激活 lvm 及 software raid 设备
j) 加载额外设备的驱动程序
k) 清理操作

# (3) /etc/rc#.d/ 目录（各种服务）
# 里面是各种服务的启动脚本：S 开头=开机启动的服务，K 开头=关机要执行的任务。
# # 代表数字，一个数字对应一个运行级别，共 7 个运行级别。

# (4) /etc/rc.d/rc.local 文件
# 这里可以自定义开机启动的命令
```

### 8. 执行 /bin/login
执行 `/bin/login` 程序，等待用户登录。

> **了解启动流程有什么用？**
> 实际工作中 CentOS 主机难免出现无法启动或启动异常。了解启动流程后可以**对症下药**，同时能掌握部分 Linux 工作机制，为解决 Linux 故障打下扎实基础。

## 三、CentOS 7 / RHEL 7 启动流程（systemd）

1. 首先 **BIOS 开机自检**
2. 然后进入**启动菜单**，加载系统内核
3. 然后**内核进行初始化**
4. 最后**启动初始化进程**

> 初始化进程作为 Linux 系统的**第一个进程**，需要完成系统中相关的初始化工作，为用户提供合适的工作环境。RHEL/CentOS 7 已替换掉熟悉的 System V init，正式采用全新的 **systemd** 初始化进程服务。systemd 采用**并发启动机制**，开机速度得到不小提升。

### 关机 / 重启命令对比
```bash
# CentOS 6
shutdown -h now     # 立即关机，常用
init 0              # 切换系统关机级别，容易理解
reboot              # 重启命令，常用
init 6              # 切换系统重启级别

# CentOS 7
systemctl poweroff  # 立即关机，常用
systemctl reboot    # 重启命令，常用
```

## 四、Systemd 目标名称（target 取代运行级别）

RHEL/CentOS 7 **没有了"运行级别"这个概念**。Linux 启动时要进行大量初始化工作（挂载文件系统和交换分区、启动各类进程服务等），这些都可以看作一个一个的**单元 Unit**。systemd 用**目标 target** 代替了 System V init 中的运行级别：

![target与运行级别对照](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-02.png)

```bash
# RHEL/CentOS 6 运行级别管理
runlevel        # 查看运行级别（N 3，N 若是其他数字代表上一次运行级别）
init 3          # 切换运行级别
/etc/inittab    # 永久修改配置文件

# RHEL/CentOS 7 目标管理
systemctl get-default                 # 查看系统默认启动目标
systemctl set-default TARGET.target   # 修改默认启动目标（永久生效）
# multi-user.target: analogous to runlevel 3
# graphical.target: analogous to runlevel 5
```

## 五、systemd 服务管理

习惯了 CentOS 6 的 `service` / `chkconfig`，在 CentOS 7 中要使用 **`systemctl`** 来管理服务。

**systemctl 管理服务的启动、重启、停止、重载、查看状态等常用命令**：
![systemctl服务管理](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-03.png)

**systemctl 设置服务开机启动、不启动、查看各级别下服务启动状态等常用命令**：
![systemctl开机启动](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-04.png)

**systemctl 服务状态说明**：
![服务状态](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-05.png)

## 六、面试题

### 1. Linux 启动过程（CentOS 6）★★★★★

```plain
开机自检(BIOS) → MBR引导 → GRUB菜单 → 加载内核(Kernel)
→ INIT进程 → 读取 /etc/inittab 配置文件 → 执行 /etc/rc.d/rc.sysinit 脚本
→ 执行 /etc/rc.d/rc 脚本 → 启动 mingetty 进程
```

![CentOS6启动过程](img/Linux%E5%90%AF%E5%8A%A8%E6%B5%81%E7%A8%8B-06.png)

### 2. Linux 启动过程（CentOS 7）★★★★

**一、BIOS 阶段**
1. 计算机启动时，首先由 BIOS 进行硬件自检（POST，Power-On Self Test），检查内存、硬盘、CPU 等是否正常。
2. BIOS 根据设置的启动顺序（硬盘、光驱、USB 等），找到可启动的设备。

**二、MBR 或 UEFI 阶段**
1. 传统 **MBR** 方式：硬盘的主引导记录被加载到内存，MBR 中包含引导加载程序（通常是 GRUB Legacy）。
2. **UEFI** 方式：UEFI 固件读取硬盘上 UEFI 引导分区中的引导管理器（例如 GRUB2 for UEFI），由其负责加载操作系统内核。

**三、GRUB 阶段**
1. GRUB 显示启动菜单，用户可选择要启动的操作系统或不同的内核版本与启动参数。
2. 选择 CentOS 7 后，GRUB 根据配置文件加载内核镜像（vmlinuz）和初始内存磁盘（initramfs）到内存中。

**四、内核初始化阶段**
1. 内核开始执行，首先进行自身初始化，包括检测硬件、初始化设备驱动程序等。
2. 内核挂载根文件系统，从 initramfs 中获取必要的驱动和模块，以确保能够访问真正的根文件系统。

**五、Systemd 阶段**
1. 根文件系统挂载后，内核执行 systemd 进程（PID 1），它是 CentOS 7 的系统和服务管理器。
2. systemd 执行一系列初始化任务：设置主机名、加载内核模块、启动各种服务等。
3. systemd 根据默认的运行级别（通常是 3 或 5，分别对应多用户文本模式和图形模式）启动相应服务和应用程序。

**六、用户登录阶段**
1. 所有必要服务启动完成后，根据运行级别启动相应的显示管理器（图形模式是 GDM）或登录提示符（文本模式）。
2. 用户输入用户名和密码登录，成功后即可开始操作系统和使用各种应用程序。

> 更新: 2026-04-23 14:03:08
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/mg4qu5>
