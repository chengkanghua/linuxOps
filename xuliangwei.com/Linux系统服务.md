# Linux系统服务

* [1.Linux启动流程](https://www.xuliangwei.com/bgx/1449.html#toc_0)
* [2.Linux运行级别](https://www.xuliangwei.com/bgx/1449.html#toc_1)
* [3.Linux systemd](https://www.xuliangwei.com/bgx/1449.html#toc_2)
* [4.Linux单用户模式](https://www.xuliangwei.com/bgx/1449.html#toc_3)
* [5.Linux下救援模式](https://www.xuliangwei.com/bgx/1449.html#toc_4)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com)"累计受益数万人。
>
> 笔者Q:552408925
>
> 架构师群:471443208

[***Centos7全新录制基础课程,点击传送-->***](https://edu.51cto.com/sd/a2e3a)*\*\*   文档配视频，效果更佳哦！\*\**

## 1.Linux启动流程

[***CentOS6启动级别***](https://www.runoob.com/linux/linux-system-boot.html)

[***CentOS6 VS Centos7开机启动流程图解***](https://www.processon.com/view/link/5bffde0ae4b0f012f2382181)

## 2.Linux运行级别

*1.什么是运行级别，运行级别就是操作系统当前正在运行的功能级别*

| System V init运行级别 | systemd目标名称 | 作用 |
| --- | --- | --- |
| 0 | runlevel0.target, poweroff.target | 关机 |
| 1 | runlevel1.target, rescue.target | 单用户模式 |
| 2 | runlevel2.target, multi-user.target | |
| 3 | runlevel3.target, multi-user.target | 多用户的文本界面 |
| 4 | runlevel4.target, multi-user.target | |
| 5 | runlevel5.target, graphical.target | 多用户的图形界面 |
| 6 | runlevel6.target, reboot.target | 重启 |

\_2.如何调整系统启动的运行级别？systemd使用'targets'而不是runlevels。默认情况下，有两个主要目标:\
\_\_multi-user.target：类似于运行级别3\
\_*graphical.target： 类似于运行级别5*

```plain
#1.查看系统默认运行级别
[root@student ~]# systemctl get-default
#2.要设置默认目标，请运行
[root@student ~]# systemctl set-default TARGET.target
```

## 3.Linux systemd

***1.systemd的由来***

\_Linux一直以来都是采用init进程作为祖宗进程，但是init有两个缺点：\
\_\_1、启动时间长。Init进程是串行启动，只有前一个进程启动完，才会启动下一个进程。\
\_\_2、启动脚本复杂，初始化完成后系统会加载很多脚本，脚本都会处理各自的情况，这会让脚本多而复杂。\
\_\_Centos5 是启动速度最慢的，串行启动过程，无论进程相互之间有无依赖关系。\
\_\_Centos6 相对启动速度有所改进。有依赖的进程之间依次启动而其他与之没有依赖关系的则并行同步启动。\
\_*Centos7 所有进程无论有无依赖关系则都是并行启动（当然很多时候进程没有真正启动而是只有一个信号或者说是标记而已，在真正利用的时候才会真正启动。）*

<!-- OCR_START -->
- Sysv init
- Upstart
- systemd
- 所有程序并行运行，如果程序之间
- 程序并行运行，但
- 有依赖，被依赖的程序，发一个已
- 是如果有依赖关系
- 经成功运行的信号给所依赖的程
- 时候，还是一步
- 序，其实自己正在启动过程中
- 步执行
- 程序一步一步运行，即便
- 他们之间并没有依赖关系
- www.xuliangwei.com
<!-- OCR_END -->

***2.什么是systemd***

*systemd即为system daemon守护进程，systemd主要解决上文的问题而诞生，systemd的目标是，为系统的启动和管理提供一套完整的解决方案。*

***3.systemd的优势***

\_1、最新系统都采用systemd管理（RedHat7,CentOS7,Ubuntu15等）\
\_\_2、Centos7支持开机并行启动服务，显著提高开机启动效率。\
\_\_3、Centos7关机只关闭正在运行的服务，而Centos6全部都关闭一次。\
\_\_4、Centos7服务的启动与停止不在使用脚本进行管理，也就是/etc/init.d下不在有脚本。\
\_*5、Centos7使用systemd解决原有模式缺陷，比如原有service不会关闭程序产生的子进程。*

***3.systemd相关配置文件***

\_/usr/lib/systemd/system/  #类似Centos6系统的启动脚本，/etc/init.d/\
\_\_/etc/systemd/system/      #类似Centos6系统的/etc/rc.d/rcN.d/\
\_*/etc/systemd/system/multi-user.target.wants/*

***4.systemd管理服务相关命令***

*systemctl管理服务的启动、重启、停止、重载、查看状态等常用命令*

| systemctl命令 | 作用 |
| --- | --- |
| systemctl start crond.service | 启动服务 |
| systemctl stop crond.service | 停止服务 |
| systemctl restart crond.service | 重启服务 |
| systemctl reload crond.service | 重新加载配置 |
| systemctl status crond.servre | 查看服务运行状态 |
| systemctl is-active sshd.service | 查看服务是否在运行中 |
| systemctl mask crond.servre | 禁止服务运行 |
| systemctl unmask crond.servre | 取消禁止服务运行 |

*当我们使用systemctl启动一个守护进程后，可以通过sysytemctl status查看此守护进程的状态*

| 状态 | 描述 |
| --- | --- |
| loaded | 服务单元的配置文件已经被处理 |
| active(running) | 服务持续运行 |
| active(exited) | 服务成功完成一次的配置 |
| active(waiting) | 服务已经运行但在等待某个事件 |
| inactive | 服务没有在运行 |
| enabled | 服务设定为开机运行 |
| disabled | 服务设定为开机不运行 |
| static | 服务开机不启动，但可以被其他服务调用启动 |

*systemctl 设置服务开机启动、不启动、查看各级别下服务启动状态等常用命令*

| systemctl命令（7系统） | 作用 |
| --- | --- |
| systemctl enable crond.service | 开机自动启动 |
| systemctl disable crond.service | 开机不自动启动 |
| systemctl list-unit-files | 查看各个级别下服务的启动与禁用 |
| systemctl is-enabled crond.service | 查看特定服务是否为开机自启动 |
| systemctl daemon-reload | 创建新服务文件需要重载变更 |

*CentOS7系统, 管理员可以使用 systemctl 命令来管理服务器启动与停止*

```plain
#关机相关命令
systemctl poweroff      #立即关机，常用
#重启相关命令
systemctl reboot        #重启命令，常用
```

*systemctl的journalctl日志*

```plain
journalctl -n 20    #查看最后20行
journalctl -f       #动态查看日志
journalctl -p err   #查看日志的级别
journalctl -u crond #查看某个服务的单元的日志
```

## 4.Linux单用户模式

***如何使用单用户模式进行变更系统密码？以Centos7系统为例：(Centos6破解方式请自行百度)***

*第1步：重启Linux系统主机并出现引导界面时，按下键盘上的e键进入内核编辑界面*

*第2步：在linux16这行的后面添加*`_enforcing=0 init=/bin/bash_`*，然后按下Ctrl + X组合键来运行修改过的内核程序*

<!-- OCR_START -->
insMod xfs setroot='hd0,Msdos1* if [ x$feature_platforM_search_hint = xy l: then search --no-floppy --fs-uuid --set=root --hint-bios=hd0,Msdos1 --hin^

-efi=hd0,Msdos1 --hint-bareMetal=ahci0,Msdos1 --hint='hd0,Msdos1'

78786441-a 161-433b-933c-5f385e7c4293 else search --n0-f1oppy --fs-uuid --set=root 7070b441-a061-433b-933c-5f38V e7c4293 fi 1inux16 /vmlinuz-3.10.0-957.1.3.e17.x86_64 r0ot=/dev/Mapper/centos_01d ooyedu-root r0 rd.lum.lu=centos_oldboyedu/root rd.lum.lv=centos_oldboyedu/swap net.ifnaMes=θ rhgb quiet LANG=en_US.UTF-8 enforcing=θ init=/bin/bash_ initrd16 /initraMfs-3.10.0-957.1.3.e17.x86_64.iMg Press Ctrl-x to start, Ctrl-c for a coMMand prompt or Escape to discard edits and return to the Menu. Pressing Tab lists possible CoMpletions. www.xuliangwei.com
<!-- OCR_END -->

*第3步：大约5秒过后，进入到系统的单用户模式，依次输入以下命令，等待系统重启操作完毕，然后就可以使用新密码来登录Linux系统了。命令行执行效果如图所示。*

<!-- OCR_START -->
1.336923] sd θ:θ:θ:θ: [sda] Assuming drive cache: write through
bash-4.2#
bash-4.2#mount-0rw,remount/1./默认是只读，重新挂载为读写
bash-4.2# echo "123456"I passwd
--stdinroot2.使用飞交互方式修改root密码
passwd: all authentication tokens updated successfully.
bash-4.2# exec /sbin/init
3.执行execinit重新引l导系统
www.xuliangwei.com
<!-- OCR_END -->

[***Centos7单用户破解密码更为详细版***](https://mp.weixin.qq.com/s/1f-zCq8j4gL3xiB3AV9K3A)

## 5.Linux下救援模式

***场景一：当系统坏了，无法登陆系统，但需要把里面的数据复制出来，怎么办？***

*步骤一、先挂载光盘，然后选择光盘引导为第一位*

<!-- OCR_START -->
- centos7-manager-61
- 挂起快照
- 设备
- 进入Unity模式
- PhoenixBIOS Setup Utility
- Main
- Aduanced
- Security
- Boot
- Exit
- Item Specific Help
- CD-ROM Drive
- Remouable Deuices
- +Hard Driue
- Keys used to view or
- Network boot from Intel E10oo
- configure deuices:
- <Enter> expands or
- collapses devices with
- a + or -
- <Ctrl+Enter> expands
- all
- <+> and <-> moues the
- deuice up or down.
- <n> May move remouable
- deuice between Hard
- Disk or Remouable Disk
- <d> Remoue a deuice
- that is not installed.
- F1
- Help
- Select Item
- -/+
- Change Values
- F9
- Setup Defaults
- Select Menu
- wwwixusaangwaExom
- Esc
- Enter
- Select  Sub-Menu
<!-- OCR_END -->

*步骤二、进入故障排除模式-->然后选择救援模式*

<!-- OCR_START -->
- centos7-manager-61
- 挂起快照
- 设备
- 进入Unity模式
- Cent0S 7
- Install Cent0S 7
- Test this media &
- Troubleshooting
- Press
- Tab for full c
- configuration options on menu
- items.
- www.xuliangwei.com
<!-- OCR_END -->

<!-- OCR_START -->
centos7-manager-61
挂起快照
设备
进入Unity模式
Troubleshooting
Install CentoS 7 in basic graphics mode
Rescue a CentoS system
Run a memory test
Boot from local drive
Return to main menu
Press
Tab for full
configuration options on menu
items.
If the system will not boot, this lets you access files
and edit config files to try to get it booting again.
www.xuliangwei.com
<!-- OCR_END -->

*步骤三、挂载真实系统后，发现数据都还存在*

<!-- OCR_START -->
centos7-manager-61
要释放鼠标，请按：Control-
挂起快照
设备
进入Unity模式
The rescue environment will now attempt to find your Linux installation and
mount it under the directory : /mmt/sysimage.
You can then make any changes
required to your system.
Choose '1' to proceed with this step.
You can choose to mount your file systems read-only instead of read-write by
choosing
'2
shell.
1) Continue
2) Read-only mount
3) Skip to shell
4) Quit （Reboot)
lease make a selection from the above:
Rescue Mount
Your system has been mounted under /mmt/sysimage
If you would like to make your system the root environment, run the command:
chroot /mt/sysimage
Please press <return> to get a shell.
When finished. nlease exit from
the shell and your system will reboot.
sh-4.2# chroot /mt/sysimage/
bash-4.2#
bash-4.2# 1s
a.txt
backup
boot
data
etc
lib
media
opt
root
sbin
SUS
usr
word
back
bin
code
dey
home
1ib64
mmt
proc
server
sry
tmp
var
Tanaconda] 1:main# 2:shell
3:1og
4:storage-log
5:program-log
Switch'
www.xue.rangweeTpcom
<!-- OCR_END -->

***场景二、修复MBR，主要出现在安装双系统时，后安装的系统把原来系统的MBR删除了，需要修复。***

*步骤一、破坏硬盘的前446字节，模拟MBR引号损坏，会发现重启无法启动系统*

```plain
[root@m01 ~]# dd if=/dev/zero of=/dev/sda bs=1 count=446
```

<!-- OCR_START -->
centos7-manager-61
挂起快照
设备
进入Unity模式
Booting
from local disk.
Network boot from Intel Eiθoo
Copyright （C) 2003-2014
UMware,
Inc.
Copyright （C) 1997-2000
Intel Corporation
PXE-EC8: PXE structure Has not found in UNDI driver code segMent.
PXE-MOF: Exiting Intel PXE ROM.
Network boot from Intel E10o0 #2
www.xuliangwei.com
<!-- OCR_END -->

*步骤二、重启系统，然后按照之前的操作进入救援模式，然后分配一个shell终端，挂载真实的操作系统进行修复*

<!-- OCR_START -->
centos7-manager-61
要释放鼠标，请按：Control-
挂起快照
设备
进入Unity模式
The rescue environment will now attempt to find your Linux installation and
mount it under the directory : /mmt/sysimage.
You can then make any changes
required to your system.
Choose '1' to proceed with this step.
You can choose to mount your file systems read-only instead of read-write by
choosing
'2
shell.
1) Continue
2) Read-only mount
3) Skip to shell
4) Quit （Reboot)
lease make a selection from the above:
Rescue Mount
Your system has been mounted under /mmt/sysimage
If you would like to make your system the root environment, run the command:
chroot /mt/sysimage
Please press <return> to get a shell.
When finished. nlease exit from
the shell and your system will reboot.
sh-4.2# chroot /mt/sysimage/
bash-4.2#
bash-4.2# 1s
a.txt
backup
boot
data
etc
lib
media
opt
root
sbin
SUS
usr
word
back
bin
code
dey
home
1ib64
mmt
proc
server
sry
tmp
var
[anaconda] 1:main# 2:shell
3:1og
4:storage-log
5:program-log
Switch"
www.xuE.rangweeTpcom
<!-- OCR_END -->

*步骤二、修复MBR引导，然后重启连接服务器*

```plain
#1.使用grub修复
# grub2-install /dev/sda
#2.然后退出
# exit
#3.最后重启进入系统
# reboot
```

***场景三、Centos7误删除grub文件如何进行修复。***

*步骤一、模拟误删故障*

```plain
#1.删除grub2 
[root@m01 ~]# rm -rf  /boot/grub2 
#2.重启计算机 
[root@m01 ~]# reboot
```

<!-- OCR_START -->
- centos7-manager-61
- 挂起快照
- 设备
- 进入Unity模式
- Booting
- fromlocaldisk
- error: file '/grub2/i386-pc/norMal.Mod' not found.
- Enteringrescue Mode...
- grub rescue>
- www.xuliangwei.com
<!-- OCR_END -->

*步骤二、重启系统，然后按照之前的操作进入救援模式，然后分配一个shell终端，挂载真实的操作系统进行修复*

<!-- OCR_START -->
centos7-manager-61
要释放鼠标，请按：Control-
挂起快照
设备
进入Unity模式
The rescue environment will now attempt to find your Linux installation and
mount it under the directory : /mmt/sysimage.
You can then make any changes
required to your system.
Choose '1' to proceed with this step.
You can choose to mount your file systems read-only instead of read-write by
choosing
'2
shell.
1) Continue
2) Read-only mount
3) Skip to shell
4) Quit （Reboot)
lease make a selection from the above:
Rescue Mount
Your system has been mounted under /mmt/sysimage
If you would like to make your system the root environment, run the command:
chroot /mmt/sysimage
Please press <return> to get a shell.
When finished. nlease exit from
the shell and your system will reboot.
sh-4.2# chroot /mt/sysimage/
bash-4.2#
bash-4.2# 1s
a.txt
backup
boot
data
etc
lib
media
opt
root
sbin
SUS
usr
word
back
bin
code
dev
home
1ib64
mnt
proc
seruer
sry
tmp
var
[anaconda] 1:main# 2:shell
3:1og
4:storage-log
5:program-log
Switch
www.xut.rangweeTpcom
<!-- OCR_END -->

*步骤三、使用grub2-install、grub2-mkconfig恢复配置文件*

<!-- OCR_START -->
centos7-manager-61
挂起快照
设备
进入Unity模式
bash-4.2# grub2-install /dev/sda
Installing for i386-pc platform.
Installation finished. Mo error reported.
bash-4.2# 1s /boot/grub2/
fonts grubeny i386-pc
locale
bash-4.2#
bash-4.2# grub2-mkconfig -0 /boot/grub2/grub.cfg
Generatinyyrubconfiyurationfiie
Found 1inux image: /b0ot/vmlinuz-3.10.0-957.1.3.e17.x86_64
Found initrd image: /boot/initramfs-3.10.0-957.1.3.e17.x86_64.img
Found 1inux image: /boot/vmlinuz-3.10.0-862.e17.x86_64
Found initrd image: /boot/initramfs-3.10.0-862.e17.x86_64.img
Found 1inux image: /boot/umlinuz-0-rescue-f70deafc4145405796ec77988f3e2bc0
Found initrd image: /boot/initramfs-0-rescue-f70deafc4145405796ec77988f3e2bc0.img
done
fonts
grub.cfg
grubeny
1386-pc locale
bash-4.Z#
4:storage-log
5:program-log
Switch www. Xle+rangweelpcom
lanaconda] 1:main# 2:she11
3:10g
<!-- OCR_END -->

***PS: 最后别忘记修改 BIOS 引导，让硬盘回归到第一引导***

> 更新: 2019-11-23 09:03:17  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/rbmf7a>