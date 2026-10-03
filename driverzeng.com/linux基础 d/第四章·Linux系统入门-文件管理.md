# 第四章·Linux系统入门-文件管理

## 文件管理概述

| Bash Shell对文件进行管理 |
| :--- |

谈到Linux文件管理，首先我们需要了解的就是，我们要对文件做些什么事情？

无非就是对文件进行以下操作：

>  
>
> 创建
>
> 复制
>
> 移动
>
> 查看
>
> 编辑
>
> 压缩
>
> 查找
>
> 删除
>
> 等等

例如：当我们想配置一下网卡信息，修改IP是否应该知道文件在哪，才能去修改。

| 内容摘要 |
| :--- |

1.系统目录结构

2.文件路径定位

3.文件管理命令

4.文件类型file

5.链接文件ln

6.文件编辑vim

## 系统目录结构

几乎所有的计算机操作系统都是使用目录结构组织文件。具体来说就是在一个目录中存放子目录和文件，而在子目录中又会进一步存放子目录和文件，以此类推形成一个树状的文件结构，由于其结构很像一棵树的分支，所以该结构又被称为`目录树`。

windows：一多根的方式组织文件C:\ D:\\

Linux：以单根的方式组织文件 /

<!-- OCR_START -->
- linux目录的顶点
- /dev/sdal
- etc
- usr
- /dev/sda2
- /dev/sdb1
- var
- https://www.driyerzeng.com
<!-- OCR_END -->

***

| 目录层次的标准FHS |
| :--- |

FHS全称（Filesystem Hierarchy Standard），中文意思是目录层次标准，是Linux的目录规范标准。

FHS定义了两次规范：

1.“/”目录下的各个目录应该放什么文件数据。

2.针对/usr 和 /var 这两个目录的子目录来定义。

<!-- OCR_START -->
- "ROOT"
- /BIN
- /ETC
- /USR
- /VAR
- /SBIN
- "ESSENTIALBINARIES”
- "HOSTSPECIFIC
- "SHAREABLEAND
- "VARIABLEDATAFILES"
- "SYSTEMBINARIES"
- CAT
- SYSTEM CONFIG"
- READ-ONLYDATA"
- FASTBOOT
- CHGRP
- CSH.LOGIN
- /LOCAL
- /CACHE
- FASTHALT
- CHMOD
- EXPORTS
- FDISK
- /TMP
- CHOWN
- /BOOT
- FSTAB
- "APPLICATION
- FSCK
- "TEMPERORYFILES
- CP
- "STATICFILESOF
- FTPUSERS
- SOFTWARE"
- CACHE DATA"
- GETTY
- DELETEDONBOOTUP
- DATA
- BOOTLOADER"
- GATEWAYS
- /LIB
- HALT
- DD
- GETTYDEFS
- /GAMES
- "VARIABLESTATE
- IFCONFIG
- /DEV
- DF
- KERNEL
- GROUP
- /INCLUDE
- INIT
- DMESG
- SYSTEM.MAP
- HOST.CONF
- INFORMATION
- MKFS
- "LOCATIONOFSPECIAL
- ECHO
- VMLINUZ
- HOSTS
- /MAN
- REMAINS AFTER
- MKSWAP
- ORDEVICEFILES
- FALSE
- INITRD
- HOSTS.ALLOW
- REBOOT"
- [CONTAINS MAKEDEV]"
- HOSTNAME
- GRUB
- HOSTS.DENY
- /SHARE
- /YP
- ROUTE
- KILL
- MODULEINFO
- HOSTS.EQUIV
- /SRC
- DATAFOR
- SWAPON
- LN
- HOSTS.LPD
- SWAPOFF
- /HOME
- NISSERVICES"
- LOGIN
- INETD.CONF
- /LOCK
- UPDATE
- "USERHOME
- LS
- INITTAB
- STATICDATA
- SHAREABLE
- DIRECTORIES"
- MKDIR
- ISSUE
- "LOCKFILESFOR
- MKNOD
- LS.SO.CONF
- AMONG ALL
- ARCHITECTURES"
- SHAREDRESOURCES"
- MORE
- MOTD
- /OPT
- MOUNT
- MTAB
- "VARIABLEDATAOF
- "LIBRARY AND
- MV
- MTOOLS
- "MANUALPAGES"
- PACKAGESINSTALLED"
- KERNELMODULES"
- PS
- NETWORKS
- PWD
- PASSWD
- /MAN1"user programs"”
- /RUN
- /MNT
- RM
- PRINTCAP
- /MAN2"system calls"
- "INFO OFSYSTEM
- "MOUNTFILES
- RMDIF
- PROFILE
- /MAN3"lib functions"
- SINCEITWASBOOTED"
- FORTEMPERORY
- SED
- PROTOCOLS
- /MAN4"specialfile"
- /MAN5"file formats"
- FILESYSTEMS"
- SH
- RESOLV.CONF
- STTY
- RPC
- /MAN6"games"
- SU
- SECURETTY
- /MAN7"misc."
- "AVAILABLEFORPROG."
- /MAN8"system admin."
- "ADD-ONAPPLICATION
- SYNCH
- SERVICES
- TRUE
- SHELLS
- /SPOOL
- UMOUNT
- SYSLOG.CONF
- "MOSTUSER COMMANDS"
- "DATAAWAITING
- UNAME
- PROCESSING"
- /LPD
- "HOMEDIR.FOR
- "CONFIG FILE
- /MQUEUE
- ROOTUSER"
- FOR ADDON
- "STANDARD INCLUDE
- FILESFOR'C'PROG."
- /NEWS
- /RWHO
- /UUCP
- "OBJ,BIN,LIB
- FILESFOR PROG.
- /LOG
- AND PACKAGES"
- "LOGFILES
- 51CTO.com
- ANDDIR"
- nttps://www.driverzeng.com
- gaanagza.ho
<!-- OCR_END -->

Linux系统中也沿用了这种文件结构, 所有目录和文件都在 "根目录"下, 目录名为"/"。FHS（文件系统层次标准）定义了在根目录下的主要目录以及每个目录应该存放什么文件。

<!-- OCR_START -->
- bin
- boot
- dev
- etc
- home
- root
- sbin
- tmp
- usr
- var
- alice
- bob
- eve
- local
<!-- OCR_END -->

| “/”根目录 |
| :--- |

```bash
/           #第一层次结构的根、整个文件系统层次结构的根目录。
/bin/       #需要在单用户模式可用的必要命令（可执行文件）；面向所有用户，例如：cat、ls、cp，和/usr/bin类似。
/boot/      #引导程序文件，例如：kernel、initrd；时常是一个单独的分区[6]
/dev/       #必要设备, 例如：, /dev/null.
/etc/       #特定主机，系统范围内的配置文件。关于这个名称目前有争议。在贝尔实验室关于UNIX实现文档的早期版本中，/etc 被称为/etcetra 目录，[7]这是由于过去此目录中存放所有不属于别处的所有东西（然而，FHS限制/etc存放静态配置文件，不能包含二进制文件）。[8]自从早期文档出版以来，目录名称已被以各种方式重新称呼。最近的解释包括反向缩略语如："可编辑的文本配置"（英文 "Editable Text Configuration"）或"扩展工具箱"（英文 "Extended Tool Chest")。[9]
/etc/opt/       #/opt/的配置文件
/etc/X11/       #X_Window系统(版本11)的配置文件
/etc/sgml/      #SGML的配置文件
/etc/xml/       #XML的配置文件
/home/          #用户的家目录，包含保存的文件、个人设置等，一般为单独的分区。
/lib/           #/bin/ and /sbin/中二进制文件必要的库文件。
/media/         #可移除媒体(如CD-ROM)的挂载点 (在FHS-2.3中出现)。
/lost+found     #在ext3文件系统中，当系统意外崩溃或机器意外关机，会产生一些文件碎片在这里。当系统在开机启动的过程中fsck工具会检查这里，并修复已经损坏的文件系统。当系统发生问题。可能会有文件被移动到这个目录中，可能需要用手工的方式来修复，或移到文件到原来的位置上。
/mnt/       #临时挂载的文件系统。比如cdrom,u盘等，直接插入光驱无法使用，要先挂载后使用
/opt/       #可选应用软件包。
/proc/      #虚拟文件系统，将内核与进程状态归档为文本文件（系统信息都存放这目录下）。例如：uptime、 network。在Linux中，对应Procfs格式挂载。该目录下文件只能看不能改（包括root）
/root/      #超级用户的家目录
/sbin/      #必要的系统二进制文件，例如： init、 ip、 mount。sbin目录下的命令，普通用户都执行不了。
/srv/       #站点的具体数据，由系统提供。
/tmp/       #临时文件(参见 /var/tmp)，在系统重启时目录中文件不会被保留。
/usr/       #默认软件都会存于该目录下。用于存储只读用户数据的第二层次；包含绝大多数的(多)用户工具和应用程序。
/var/       #变量文件——在正常运行的系统中其内容不断变化的文件，如日志，脱机文件和临时电子邮件文件。有时是一个单独的分区。如果不单独分区，有可能会把整个分区充满。如果单独分区，给大给小都不合适。
```

**重点记住**

```bash
/etc        系统重要配置文件, 以及常用服务配置文件
/var        存放系统引导启动时产生的可变文件,文件通常动态更改的,例如: 缓存目录,日志文件
/run        系统启动后, 运行的程序产生的运行时数据, 包括进程的pid文件,锁文件等
/home       普通用户的主目录, 普通用户的家目录默认为/HOME/USERNAME
/root       超级管理员的主目录, 普通用户无权操作
/tmp        存放临时文件, 一般存放超过10天以上都会自动删除,可以更改删除临时文件的期限
/boot       存放系统引导时候需要的文件
/dev        存放设备文件
/usr        安装的软件, 共享库, 重要的子目录有
/usr/bin    用户命令目录
/usr/sbin   管理员命令目录
/usr/local  本地自定义安装的软件
//注意:在Linux7系统中, /bin, /sbin, /lib, /lib64都以软链接的形式链接到/usr/目录下,例如:
/bin  --> /usr/bin
/sbin --> /usr/sbin
lib -> usr/lib
lib64 -> usr/lib64
```

***

| /etc/目录 |
| :--- |

特定主机系统范围内的配置文件。

```bash
/etc/rc /etc/rc.d   ***** #/etc/rc*.d 启动、或改变运行级时运行的scripts或scripts的目录.
/etc/hosts          ***** #本地域名解析文件
/etc/sysconfig/network  ***** #IP、掩码、网关、主机名配置
/etc/resolv.conf    ***** #DNS服务器配置
/etc/fstab          ***** #开机自动挂载系统，所有分区开机都会自动挂载
/etc/inittab        ***** #设定系统启动时Init进程将把系统设置成什么样的runlevel及加载相关的启动文件配置
/etc/exports        ***** #设置NFS系统用的配置文件路径
/etc/init.d/        ***** #这个目录来存放系统启动脚本
/etc/profile        ***** #全局系统环境配置变量
/etc/csh.login,  /etc/csh.cshrc
/etc/issue          ***** #认证前的输出信息，默认输出版本内核信息
/etc/motd           #设置认证后的输出信息
/etc/mtab           #当前安装的文件系统列表.由scripts初始化，并由mount 命令自动更新.需要一个当前安装的文件系统的列表时使用，例如df 命令
/etc/group          ***** #类似/etc/passwd ，但说明的不是用户而是组.
/etc/passwd         ***** #用户数据库，其中的域给出了用户名、真实姓名、家目录、加密的口令和用户的其他信息.
/etc/shadow         ****** #在安装了影子口令软件的系统上的影子口令文件.影子口令文件将/etc/passwd 文件中的加密口令移动到/etc/shadow 中，而后者只对root可读.这使破译口令更困难.
/etc/sudoers        ***** #可以sudo命令的配置文件
/etc/syslog.conf    ***** #系统日志参数配置
/etc/login.defs     #设置用户帐号限制的文件
/etc/securetty      #确认安全终端，即哪个终端允许root登录.一般只列出虚拟控制台，这样就不可能(至少很困难)通过modem或网络闯入系统并得到超级用户特权.
/etc/printca        #类似/etc/termcap ，但针对打印机.语法不同.
/etc/shells         #列出可信任的shell.chsh 命令允许用户在本文件指定范围内改变登录shell.提供一台机器FTP服务的服务进程ftpd 检查用户shell是否列在 /etc/shells 文件中，如果不是将不允许该用户登录.
/etc/xinetd.d       #如果服务器是通过xinetd模式运行的，它的脚本要放在这个目录下。有些系统没有这个目录，比如Slackware，有些老的版本也没有。在Redhat Fedora中比较新的版本中存在。
/etc/opt/           #/opt/的配置文件
/etc/X11/           #X_Window系统(版本11)的配置文件
/etc/sgml/          #SGML的配置文件
/etc/xml/           #XML的配置文件
/etc/skel/          ***** #默认创建用户时，把该目录拷贝到家目录下
```

***

| /usr/目录 |
| :--- |

默认软件都会存于该目录下。用于存储只读用户数据的第二层次；包含绝大多数的用户工具和应用程序。

```bash
/usr/X11R6          #存放X-Windows的目录；
/usr/games          #存放着XteamLinux自带的小游戏；
/usr/doc            #Linux技术文档；
/usr/include        #用来存放Linux下开发和编译应用程序所需要的头文件；
/usr/lib            #存放一些常用的动态链接共享库和静态档案库；
/usr/man            #帮助文档所在的目录；
/usr/src            #Linux开放的源代码，就存在这个目录，爱好者们别放过哦；
/usr/bin/           #非必要可执行文件 (在单用户模式中不需要)；面向所有用户。
/usr/lib/           #/usr/bin/和/usr/sbin/中二进制文件的库。
/usr/sbin/          #非必要的系统二进制文件，例如：大量网络服务的守护进程。
/usr/share/         #体系结构无关（共享）数据。
/usr/src/           #源代码,例如:内核源代码及其头文件。
/usr/X11R6/         #X Window系统版本 11, Release 6.
/usr/local/         #本地数据的第三层次，具体到本台主机。通常而言有进一步的子目录，例如：bin/、lib/、share/.这是提供给一般用户的/usr目录，在这里安装一般的应用软件；
```

***

| /var/目录 |
| :--- |

/var 包括系统一般运行时要改变的数据.每个系统是特定的，即不通过网络与其他计算机共享.

```bash
/var/log/message            ***** #系统日志信息，按周自动轮询
/var/spool/cron/root        ***** #定时器配置文件目录，默认按用户命名
/var/log/secure             ***** #记录登陆系统存取信息的文件，不管认证成功还是认证失败都会记录
/var/log/wtmp               #记录登陆者信息的文件，last,who,w命令信息来源于此
/var/spool/clientmqueue/    #当邮件服务未开启时，所有应发给系统管理员的邮件都将堆放在此
/var/spool/mail/            #邮件目录
/var/tmp                    #比/tmp 允许的大或需要存在较长时间的临时文件. (虽然系统管理员可能不允许/var/tmp 有很旧的文件.)
/var/lib                    #系统正常运行时要改变的文件.  
/var/local                  #/usr/local 中安装的程序的可变数据(即系统管理员安装的程序).注意，如果必要，即使本地安装的程序也会使用其他/var 目录，例如/var/lock .  
/var/lock                   #锁定文件.许多程序遵循在/var/lock 中产生一个锁定文件的约定，以支持他们正在使用某个特定的设备或文件.其他程序注意到这个锁定文件，将不试图使用这个设备或文件.
/var/log/                   ***** #各种程序的Log文件，特别是login   (/var/log/wtmp log所有到系统的登录和注销) 和syslog (/var/log/messages 里存储所有核心和系统程序信息. /var/log 里的文件经常不确定地增长，应该定期清除.  
/var/run                    #保存到下次引导前有效的关于系统的信息文件.例如， /var/run/utmp 包含当前登录的用户的信息.
/var/cache/                 #应用程序缓存数据。这些数据是在本地生成的一个耗时的I/O或计算结果。应用程序必须能够再生或恢复数据。缓存的文件可以被删除而不导致数据丢失。
```

***

| /proc/目录 |
| :--- |

虚拟文件系统，将内核与进程状态归档为文本文件（系统信息都存放这目录下）。

例如：uptime、 network。在Linux中，对应Procfs格式挂载。该目录下文件只能看不能改（包括root）

```bash
/proc/meminfo           ***** #查看内存信息
/proc/loadavg           ***** #还记得 top 以及 uptime 吧？没错！上头的三个平均数值就是记录在此！
/proc/uptime            ***** #就是用 uptime 的时候，会出现的资讯啦！
/proc/cpuinfo           ***** #关于处理器的信息，如类型、厂家、型号和性能等。
/proc/cmdline           #加载 kernel 时所下达的相关参数！查阅此文件，可了解系统是如何启动的！
/proc/filesystems       #目前系统已经加载的文件系统罗！
/proc/interrupts        #目前系统上面的 IRQ 分配状态。
/proc/ioports           #目前系统上面各个装置所配置的 I/O 位址。
/proc/kcore             #这个就是内存的大小啦！好大对吧！但是不要读他啦！
/proc/modules           #目前我们的 Linux 已经加载的模块列表，也可以想成是驱动程序啦！
/proc/mounts            #系统已经挂载的数据，就是用 mount 这个命令呼叫出来的数据啦！
/proc/swaps             #到底系统挂加载的内存在哪里？呵呵！使用掉的 partition 就记录在此啦！
/proc/partitions        #使用 fdisk -l 会出现目前所有的 partition 吧？在这个文件当中也有纪录喔！
/proc/pci               #在 PCI 汇流排上面，每个装置的详细情况！可用 lspci 来查阅！
/proc/version           #核心的版本，就是用 uname -a 显示的内容啦！
/proc/bus/*             #一些汇流排的装置，还有 U盘的装置也记录在此喔！
```

***

| /dev/目录 |
| :--- |

设备文件分为两种：块设备文件(b)和字符设备文件(c)

设备文件一般存放在/dev目录下，

对常见设备文件作如下说明：

```bash
/dev/hd[a-t]            #IDE设备
/dev/sd[a-z]            #SCSI设备
/dev/fd[0-7]            #标准软驱
/dev/md[0-31]           #软raid设备
/dev/loop[0-7]          #本地回环设备
/dev/ram[0-15]          #内存
/dev/null               #无限数据接收设备,相当于黑洞
/dev/zero               #无限零资源
/dev/tty[0-63]          #虚拟终端
/dev/ttyS[0-3]          #串口
/dev/lp[0-3]            #并口
/dev/console            #控制台
/dev/fb[0-31]           #framebuffer
/dev/cdrom              #=> /dev/hdc
/dev/modem              #=> /dev/ttyS[0-9]
/dev/pilot              #=> /dev/ttyS[0-9]
/dev/random             #随机数设备
/dev/urandom            #随机数设备
```

***

| 命令目录 |
| :--- |

***/bin***

```bash
[root@db04 ~]# ls /bin/
alsaunmute  chgrp  cut                   dbus-send      domainname  ex       gettext   ipcalc              ln        mail    mount       nisdomainname  raw       rpm        sh     tar         traceroute     unicode_stop  zcat
arch        chmod  dash                  dbus-uuidgen   dumpkeys    false    grep      iptables-xml        loadkeys  mailx   mountpoint  ping           readlink  rvi        sleep  taskset     traceroute6    unlink
awk         chown  date                  dd             echo        fgrep    gtar      iptables-xml-1.4.7  logger    mkdir   mv          ping6          red       rview      sort   tcsh        true           usleep
basename    cp     dbus-cleanup-sockets  df             ed          find     gunzip    kbd_mode            login     mknod   nano        plymouth       rm        sed        stty   touch       umount         vi
bash        cpio   dbus-daemon           dmesg          egrep       findmnt  gzip      kill                ls        mktemp  netstat     ps             rmdir     setfont    su     tracepath   uname          view
cat         csh    dbus-monitor          dnsdomainname  env         gawk     hostname  link                lsblk     more    nice        pwd            rnano     setserial  sync   tracepath6  unicode_start  ypdomainname
```

***/sbin***

```bash
[root@db04 ~]# ls /sbin/
accton         cbq              dosfsck      fsck.ext4dev    ifdown                   iptables                ldconfig     lvmsar         mkfs.ext2            partprobe   quotaon              service       tc             vgmerge
addpart        cfdisk           dosfslabel   fsck.msdos      ifenslave                iptables-1.4.7          load_policy  lvreduce       mkfs.ext3            partx       rdisc                setfiles      telinit        vgmknodes
agetty         chcpu            dracut       fsck.vfat       ifrename                 iptables-multi          logsave      lvremove       mkfs.ext4            pccardctl   readahead            setpci        tune2fs        vgreduce
alsactl        chkconfig        dumpe2fs     fsfreeze        ifup                     iptables-multi-1.4.7    losetup      lvrename       mkfs.ext4dev         pidof       readahead-collector  setregdomain  udevadm        vgremove
arp            clock            e2fsck       fstab-decode    init                     iptables-restore        lsinitrd     lvresize       mkfs.msdos           pivot_root  reboot               setsysfont    udevd          vgrename
arping         consoletype      e2image      fstrim          initctl                  iptables-restore-1.4.7  lsmod        lvs            mkfs.vfat            plipconfig  regdbdump            sfdisk        umount.hal     vgs
audispd        crda             e2label      fuser           insmod                   iptables-save           lspci        lvscan         mkhomedir_helper     plymouthd   reload               sgpio         unix_chkpwd    vgscan
auditctl       cryptsetup       e2undo       genhostid       insmod.static            iptables-save-1.4.7     lspcmcia     MAKEDEV        mkinitrd             poweroff    resize2fs            shutdown      unix_update    vgsplit
auditd         ctrlaltdel       ether-wake   getkey          install-info             iptunnel                lvchange     matchpathcon   mkswap               ppp-watch   restart              slattach      vconfig        vmcore-dmesg
aureport       debugfs          ethtool      grub            installkernel            iw                      lvconvert    mdadm          modinfo              pvchange    restorecon           sln           vgcfgbackup    weak-modules
ausearch       delpart          faillock     grubby          ip                       iwconfig                lvcreate     mdmon          modprobe             pvck        rfkill               start         vgcfgrestore   wipefs
autrace        depmod           fdisk        grub-crypt      ip6tables                iwevent                 lvdisplay    microcode_ctl  mount.tmpfs          pvcreate    rmmod                start_udev    vgchange
badblocks      dhclient         findfs       grub-install    ip6tables-1.4.7          iwgetid                 lvextend     mii-diag       nameif               pvdisplay   rngd                 status        vgck
biosdevname    dhclient-script  fixfiles     grub-md5-crypt  ip6tables-multi          iwlist                  lvm          mii-tool       netreport            pvmove      route                stop          vgconvert
blkdeactivate  dm_dso_reg_tool  fsadm        grub-terminfo   ip6tables-multi-1.4.7    iwpriv                  lvmchange    mingetty       new-kernel-pkg       pvremove    rsyslogd             sulogin       vgcreate
blkdiscard     dmeventd         fsck         halt            ip6tables-restore        iwspy                   lvmconf      mkdosfs        nologin              pvresize    rtmon                sushell       vgdisplay
blkid          dmevent_tool     fsck.cramfs  hdparm          ip6tables-restore-1.4.7  kdump                   lvmdiskscan  mkdumprd       pam_console_apply    pvs         runlevel             swapoff       vgexport
blockdev       dmraid           fsck.ext2    hwclock         ip6tables-save           kexec                   lvmdump      mke2fs         pam_tally2           pvscan      runuser              swapon        vgextend
bridge         dmraid.static    fsck.ext3    ifcfg           ip6tables-save-1.4.7     killall5                lvmetad      mkfs           pam_timestamp_check  quotacheck  scsi_id              switch_root   vgimport
busybox        dmsetup          fsck.ext4    ifconfig        ipmaddr                  kpartx                  lvmsadc      mkfs.cramfs    parted               quotaoff    securetty            sysctl        vgimportclone
```

***

| 家目录 |
| :--- |

***/home***

```bash
[root@db04 ~]# pwd
/root
[root@db04 ~]# useradd zls
[root@db04 ~]# ls /home/
zls
```

***/root***

```bash
[root@db04 ~]# pwd
/root
```

***

| 系统文件目录 |
| :--- |

>  
>
> /usr 目录 相当于windows下的 C:\Windows目录
>
> /usr/local 软件安装目录 相当于C:\Program
>
> /usr/bin 普通用户使用的应用程序（重要）
>
> /usr/sbin 管理员用户使用的应用程序（重要）
>
> /usr/lib 库文件Glibc 32bit
>
> /usr/lib64 库文件Glibc 64bit

```bash
#查看cp命令依赖的库文件
[root@db04 ~]# ldd /bin/cp
    linux-vdso.so.1 =>  (0x00007fff53397000)
    libselinux.so.1 => /lib64/libselinux.so.1 (0x00000036b4a00000)
    librt.so.1 => /lib64/librt.so.1 (0x0000003cb8a00000)
    libacl.so.1 => /lib64/libacl.so.1 (0x0000003cbca00000)
    libattr.so.1 => /lib64/libattr.so.1 (0x0000003cba600000)
    libc.so.6 => /lib64/libc.so.6 (0x0000003cb7e00000)
    libdl.so.2 => /lib64/libdl.so.2 (0x00000036b4200000)
    /lib64/ld-linux-x86-64.so.2 (0x0000003cb7600000)
    libpthread.so.0 => /lib64/libpthread.so.0 (0x0000003cb8200000)
```

***

| 启动目录 |
| :--- |

>  
>
> /boot 存放的系统启动相关的文件，例如：kernel，grub（引导装载程序）

```bash
[root@db04 ~]# ls -1 /boot/
config-2.6.32-431.el6.x86_64
efi
grub
initramfs-2.6.32-431.el6.x86_64.img
initrd-2.6.32-431.el6.x86_64kdump.img
lost+found
symvers-2.6.32-431.el6.x86_64.gz
System.map-2.6.32-431.el6.x86_64
vmlinuz-2.6.32-431.el6.x86_64
```

***

| 配置文件目录 |
| :--- |

>  
>
> /etc 极其重要，后续所有服务的配置都在这个目录中
>
> /etc/sysconfig/network-script/ifcfg- 网卡配置文件
>
> /etc/hostname 系统主机名配置文件
>
> /etc/resolv.conf dns客户端配置文件
>
> /etc/hosts 本地域名解析配置文件

***

| 可变的目录与临时目录 |
| :--- |

>  
>
> /var 存放一些变化文件，比如/var/log/下的系统日志文件
>
> /var/tmp 进程产生的临时文件
>
> /tmp 系统临时目录（类似于公共厕所）

***

| 设备目录文件 |
| :--- |

>  
>
> /dev 存放设备文件，比如硬盘，硬盘分区，光驱等
>
> /dev/null 黑洞设备，只进不出，类似于辣鸡回收站
>
> /dev/random 生成随机数的设备
>
> /dev/zero 能远远不断的产生数据，类似于取款机，随时随地取钱
>
> /dev/pts/0 虚拟的Bash Shell终端，提供给远程用户使用，0：一个终端 1：2个终端...

```bash
[root@db04 ~]# ls /dev/sda*
/dev/sda  /dev/sda1  /dev/sda2
[root@db04 ~]# ls /dev/zero /dev/random /dev/null
/dev/null  /dev/random  /dev/zero
[root@db04 ~]# ls /dev/cdrom /dev/sr0
[root@db04 ~]# dd if=/dev/zero of=/opt/test.txt bs=1M count=1024
[root@db04 ~]# ls -lh /opt/test.txt
-rw-r--r-- 1 root root 1.0G 5月  31 06:05 /opt/test.txt
[root@db04 ~]# tty
/dev/pts/3
[root@db04 ~]# ps -ef|grep tty
root       6889      1  0 May21 tty1     00:00:00 /sbin/mingetty /dev/tty1
root       6891      1  0 May21 tty2     00:00:00 /sbin/mingetty /dev/tty2
root       6893      1  0 May21 tty3     00:00:00 /sbin/mingetty /dev/tty3
root       6895      1  0 May21 tty4     00:00:00 /sbin/mingetty /dev/tty4
root       6897      1  0 May21 tty5     00:00:00 /sbin/mingetty /dev/tty5
root       6899      1  0 May21 tty6     00:00:00 /sbin/mingetty /dev/tty6
root      21723  21092  0 06:37 pts/3    00:00:00 grep tty
[root@db04 ~]# ps -ef|grep sshd
root       6757      1  0 May21 ?        00:00:00 /usr/sbin/sshd
root      19882   6757  0 May30 ?        00:00:00 sshd: root@pts/2
root      21090   6757  0 05:01 ?        00:00:00 sshd: root@pts/3
root      21725  21092  0 06:38 pts/3    00:00:00 grep sshd
```

***

| 虚拟的文件系统 |
| :--- |

>  
>
> /proc 反应系统当前进程的实时状态

```bash
[root@db04 ~]# cat /proc/meminfo
MemTotal:        1906556 kB
MemFree:           86636 kB
Buffers:          160992 kB
Cached:          1487556 kB
SwapCached:            0 kB
Active:           473468 kB
Inactive:        1197472 kB
Active(anon):      22616 kB
Inactive(anon):       12 kB
Active(file):     450852 kB
Inactive(file):  1197460 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2031608 kB
SwapFree:        2031608 kB
Dirty:                 4 kB
Writeback:             0 kB
AnonPages:         22408 kB
Mapped:             9200 kB
Shmem:               240 kB
Slab:             115316 kB
SReclaimable:      90108 kB
SUnreclaim:        25208 kB
KernelStack:         704 kB
PageTables:         2832 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2984884 kB
Committed_AS:      90636 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      157472 kB
VmallocChunk:   34359574080 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        6144 kB
DirectMap2M:     1042432 kB
DirectMap1G:     1048576 kB
[root@db04 ~]# cat /proc/cpuinfo
processor   : 0
vendor_id   : GenuineIntel
cpu family  : 6
model       : 158
model name  : Intel(R) Core(TM) i7-8850H CPU @ 2.60GHz
stepping    : 10
cpu MHz     : 2591.345
cache size  : 9216 KB
fpu     : yes
fpu_exception   : yes
cpuid level : 22
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm constant_tsc up arch_perfmon xtopology tsc_reliable nonstop_tsc unfair_spinlock pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch arat xsaveopt fsgsbase bmi1 hle avx2 smep bmi2 invpcid rtm
bogomips    : 5182.69
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management:
[root@db04 ~]# ls /proc/
1     12   15   17     2      21704  26   293  314  397  6     6690  6740  6865  6893  718  9          cgroups  diskstats    filesystems  ipmi      key-users   locks    mounts  pagetypeinfo  self      sys            tty          zoneinfo
10    13   155  18     20     22     27   3    32   4    645   6699  6757  687   6895  719  acpi       cmdline  dma          fs           irq       kmsg        mdstat   mpt     partitions    slabinfo  sysrq-trigger  uptime
1027  14   156  19     21     23     28   30   33   41   649   6700  6833  6876  6897  73   asound     cpuinfo  driver       interrupts   kallsyms  kpagecount  meminfo  mtd     sched_debug   softirqs  sysvipc        version
1043  146  157  19882  21090  24     29   31   38   42   657   6729  6840  6889  6899  784  buddyinfo  crypto   execdomains  iomem        kcore     kpageflags  misc     mtrr    schedstat     stat      timer_list     vmallocinfo
11    147  16   19884  21092  25     291  313  39   5    6661  6732  6857  6891  7     8    bus        devices  fb           ioports      keys      loadavg     modules  net     scsi          swaps     timer_stats    vmstat
[root@db04 ~]# ps -ef|grep sshd
root       6757      1  0 May21 ?        00:00:00 /usr/sbin/sshd
root      19882   6757  0 May30 ?        00:00:00 sshd: root@pts/2
root      21090   6757  0 05:01 ?        00:00:00 sshd: root@pts/3
root      21706  21092  0 06:25 pts/3    00:00:00 grep sshd
[root@db04 ~]# ls /proc/6757/
```

***

| 以下目录都是被软链接了 |
| :--- |

/bin --> /usr/bin

/sbin --> /usr/sbin

/lib --> /usr/lib

/lib64 --> /usr/lib64

## 文件路径定位

在我们开始操作文件前，首先需要对文件进行定位，比如：

你要在哪，创建什么文件？

你要将文件复制到什么地方？

你要删除什么地方的文件？

那什么是定位？

比如：/etc/hostname整个文件中包含文件名称以及文件所在的位置，我们将这个叫做路径，那么路径就是怼文件进行定位的一种方式。

例如：下图所示的message所在的路径是？

<!-- OCR_START -->
- home
- alice
- var
- bob
- eve
- log
- messages
<!-- OCR_END -->

再举个例子，我想在座的各位男生，应该深有体会，以前网站是不支持在线观看视频，电影之类的，必须要通过迅雷，或者...一些软件，下载下来，然后本地播放器观看，QVOD...等等，那这个小电影，一般来说，都会隐藏的很深很深很深很深。而且目录名字起的，越奇葩越好。

***

| 特殊目录“.”和“..” |
| :--- |

在每个目录下, 都会固定存在两个特殊目录, 分别是`.`和`..`的目录。

一个点代表当的是当前目录, 两个点代表的是当前目录的上层目录。

注意: 在Linux下所有以点开始的文件都是"隐藏文件", 对于这类文件, 只使用命令`ls -l`是看不到的, 必须要使用`ls -la`才可以看到,如下所示:

```bash
[root@db04 ~]# ls -la /
总用量 106
dr-xr-xr-x. 23 root root  4096 5月  21 11:11 .
dr-xr-xr-x. 23 root root  4096 5月  21 11:11 ..
-rw-r--r--   1 root root     0 5月  21 11:11 .autofsck
-rw-r--r--   1 root root     0 10月 19 2018 .autorelabel
dr-xr-xr-x.  2 root root  4096 5月  27 03:16 bin
dr-xr-xr-x.  5 root root  1024 5月  21 11:11 boot
drwxr-xr-x   3 root root  4096 4月   8 21:40 data
drwxr-xr-x  19 root root  3740 5月  21 11:11 dev
drwxr-xr-x. 86 root root  4096 5月  30 22:53 etc
drwxr-xr-x.  3 root root  4096 5月  30 22:53 home
dr-xr-xr-x. 13 root root  4096 5月  26 08:53 lib
dr-xr-xr-x.  9 root root 12288 5月  27 03:16 lib64
drwx------.  2 root root 16384 10月 19 2018 lost+found
drwxr-xr-x.  2 root root  4096 9月  23 2011 media
drwxr-xr-x.  2 root root  4096 9月  23 2011 mnt
drwxr-xr-x.  3 root root  4096 5月  31 06:05 opt
dr-xr-xr-x  96 root root     0 5月  21 19:11 proc
dr-xr-x---.  3 root root  4096 5月  30 09:05 root
dr-xr-xr-x.  2 root root 12288 5月  27 03:16 sbin
drwxr-xr-x.  2 root root  4096 10月 19 2018 selinux
drwxr-xr-x.  2 root root  4096 9月  23 2011 srv
drwxr-xr-x  13 root root     0 5月  21 19:11 sys
drwxrwxrwt.  3 root root  4096 5月  31 03:44 tmp
drwxr-xr-x. 13 root root  4096 10月 19 2018 usr
drwxr-xr-x. 20 root root  4096 10月 19 2018 var
[root@db04 ~]# ls -la /opt/
总用量 1048592
drwxr-xr-x.  3 root root       4096 5月  31 06:05 .
dr-xr-xr-x. 23 root root       4096 5月  21 11:11 ..
drwxr-xr-x.  2 root root       4096 11月 22 2013 rh
-rw-r--r--   1 root root 1073741824 5月  31 06:05 test.txt
```

***

| 绝对路径 |
| :--- |

Linux系统采用了目录树的文件组织结构, 在Linux下每个目录或文件都可以从根目录处开始寻找, 比如: `/usr/bin`目录。这种从根目录开始的全路径被称为"绝对路径", 绝对路径一定是以 “/” 开头的。

如何确认当前所在的目录, 可以使用`pwd`命令查看:

```bash
[root@db04 ~]# cd /usr/local/
[root@db04 local]# pwd
/usr/local
```

就好比，咱们在中国写快递地址的时候 ，如果你往外省邮寄，北京-上海

**绝对路径**

得写具体地址：上海市/浦东新区/创智良仓/3207

**相对路径**

那你在叫外卖的时候呢:浦东新区/创智良仓/3207

***

| 相对路径 |
| :--- |

相对路径, 关键点在于当前在什么路径下。假设当前目录在`/usr/local`下, 那么它的上层目录(/usr目录)可以用`../`表示, 而\`\`/usr/local`的下层目录(src)则可以用`./src\`表示。所谓的(.)和(..)目录实际上也是属于相对路径

```bash
#进入/opt目录
[root@db04 ~]# cd /opt/
[root@db04 opt]# ls -la
总用量 1048592
drwxr-xr-x.  3 root root       4096 5月  31 06:05 .          //当前目录
dr-xr-xr-x. 23 root root       4096 5月  21 11:11 ..         //上层目录
drwxr-xr-x.  2 root root       4096 11月 22 2013 rh
-rw-r--r--   1 root root 1073741824 5月  31 06:05 test.txt
#进入当前目录
[root@db04 opt]# cd .
[root@db04 opt]# pwd
/opt
#进入当前目录的上层目录
[root@db04 opt]# cd ..
[root@db04 /]# pwd
/
```

示例：

```bash
[root@db04 /]# useradd oldboy
[root@db04 /]# ls /home/oldboy/
[root@db04 /]# ls ~/
[root@db04 /]# ls ~/file1
[root@db04 /]# ls ~/zls/file1
```

```bash
[root@db04 /]# ls abc
[root@db04 /]# ls ../abc
[root@db04 /]# ls abc/file1
```

***

| cd命令常见用法 |
| :--- |

`cd` : 切换目录 change directory

```bash
.  表示用户所处的当前目录
.. 表示上级目录;
~  表示当前用户自己的家目录
cd -    #切换上次所在目录
cd ~    #切换至当前用户家目录
cd      #切换至当前用户家目录
cd .    #.代表当前目录,一般在拷贝、移动等情况下使用
cd ..   #切换至当前目录的上级目录
```

## 系统文件管理

| 创建目录mkdir |
| :--- |

`mkdir` :创建目录 make directory

```bash
DESCRIPTION
       Create the DIRECTORY(ies), if they do not already exist.
       创建目录，如果他们不存在
       Mandatory arguments to long options are mandatory for short options too.
       -m, --mode=MODE
              set file mode (as in chmod), not a=rwx - umask
       -p, --parents
              no error if existing, make parent directories as needed
       -v, --verbose
              print a message for each created directory
       -Z, --context=CTX
              set the SELinux security context of each created directory to CTX
       --help display this help and exit
       --version
              output version information and exit
```

命令示例：

```bash
#创建目录
[root@db04 ~]# mkdir dir1
#创建目录并给权限
[root@db04 ~]# mkdir -m 777 dir2
#递归创建目录
[root@db04 ~]# mkdir -p dir3/dir4/dir5
#创建目录并显示信息
[root@db04 ~]# mkdir -pv dir4/dir5/dir6
mkdir: 已创建目录 "dir4"
mkdir: 已创建目录 "dir4/dir5"
mkdir: 已创建目录 "dir4/dir5/dir6"
#创建多目录
[root@db04 ~]# mkdir /home/zls/dir1 /home/zls/dir2 /home/zls/dir3
[root@db04 ~]# mkdir /home/zls/{dir4,dir5,dir6}
[root@db04 ~]# mkdir -p /home/zls/{dir7,dir8,dir9}/zenglaoshi
[root@db04 ~]# mkdir -pv /home/zls/{dir10,dir11,dir12}/zenglaoshi
mkdir: 已创建目录 "/home/zls/dir10"
mkdir: 已创建目录 "/home/zls/dir10/zenglaoshi"
mkdir: 已创建目录 "/home/zls/dir11"
mkdir: 已创建目录 "/home/zls/dir11/zenglaoshi"
mkdir: 已创建目录 "/home/zls/dir12"
mkdir: 已创建目录 "/home/zls/dir12/zenglaoshi"
[root@db04 ~]# mkdir /home/{zls/{1,2},oldboyedu}
```

小练习：

使用一条命令创建出下面的目录

/home/zls

/home/zls/test1

/home/zls/test2

/home/oldboy

/home/oldboy/test1

/tmp/oldboy

/tmp/oldgirl

/root/test/test1

/root/test/test2

/root/abc

/backup

***

| 创建文件touch |
| :--- |

`touch`: 创建文件

命令示例：

```bash
[root@db04 ~]# touch file
[root@db04 ~]# touch file1 file2
[root@db04 ~]# touch /home/zls/file3 file4
[root@db04 ~]# touch file{5,6,7}
[root@db04 ~]# touch file{10..100}
```

***

**注意:**

1.创建文件，必须要创建在一个存在的目录中

2.和创建目录不同的是，创建相同的文件不会报错

3.创建相同的文件，源文件内容不会被覆盖

4.在Linux当中一切皆文件

***

```bash
[root@db04 ~]# echo 123 > file1
[root@db04 ~]# cat file1
123
[root@db04 ~]# touch file1
[root@db04 ~]# cat file1
123
```

***

| 树状显示目录文件结构 |
| :--- |

`tree`: 以树状的形式，显示目录和文件

```bash
[root@db04 ~]# tree
[root@db04 ~]# tree /
[root@db04 ~]# tree /home
[root@db04 ~]# tree -L 1 /
[root@db04 ~]# tree -L 1 -d
```

***

| 复制命令cp |
| :--- |

`cp`: 复制 copy

语法：

```bash
SYNOPSIS
       cp [OPTION]... [-T] SOURCE DEST
       cp [OPTION]... SOURCE... DIRECTORY
       cp [OPTION]... -t DIRECTORY SOURCE...
```

命令示例

```bash
[root@db04 ~]# cp file /home/zls
[root@db04 ~]# cp file1 /tmp/test1
[root@db04 ~]# cp -p file1 /tmp/
[root@db04 ~]# cp -r /etc/ /tmp/
[root@db04 ~]# cp -r /etc/* /tmp/
[root@db04 ~]# cp -v /etc/hosts /etc/sysconfig/network /opt/
"/etc/hosts" -> "/opt/hosts"
"/etc/sysconfig/network" -> "/opt/network"
[root@db04 ~]# cp /etc/{hosts,hosts.bak}
[root@db04 ~]# cp /etc/hosts{,.org}
[root@db04 ~]# cp -r file file1 file2 file3 /etc/ /opt/ /usr/local
[root@db04 ~]# cp -t  /opt/ /etc/hosts
```

***

| 移动命令mv |
| :--- |

`mv`:移动 move

语法：

```bash
mv [OPTION]... [-T] SOURCE DEST
mv [OPTION]... SOURCE... DIRECTORY
mv [OPTION]... -t DIRECTORY SOURCE...
```

命令示例：

```bash
[root@db04 ~]# mv file /tmp/
[root@db04 ~]# mv file1 test1
[root@db04 ~]# mv dir1 /tmp/
[root@db04 ~]# mv dir2 file4 file5 file6 /opt/ /usr/local/
[root@db04 ~]# mv /tmp/dir1 ./
[root@db04 ~]# mv /tmp/dir1 .
[root@db04 ~]# mv /tmp/dir2 ../
[root@db04 ~]# mv -t /tmp/ file1 file2 ./file3
```

***

| 删除命令rm |
| :--- |

`rm`:删除 remove

语法：

```bash
用法：rm [选项]... 文件...
删除 (unlink) 文件。
  -f, --force       强制删除。忽略不存在的文件，不提示确认
  -i            在删除前需要确认
  -I            在删除超过三个文件或者递归删除前要求确认。此选项比-i 提
            示内容更少，但同样可以阻止大多数错误发生
      --interactive[=WHEN]  根据指定的WHEN 进行确认提示：never，once (-I)，
                或者always (-i)。如果此参数不加WHEN 则总是提示
      --one-file-system     递归删除一个层级时，跳过所有不符合命令行参
                数的文件系统上的文件
      --no-preserve-roo 不特殊对待"/"
      --preserve-root   不允许删除"/"(默认)
  -r, -R, --recursive   递归删除目录及其内容
  -v, --verbose     详细显示进行的步骤
      --help        显示此帮助信息并退出
      --version     显示版本信息并退出
```

命令示例：

```bash
[root@db04 ~]# rm file2
rm：是否删除普通空文件 "file2"？y
[root@db04 ~]# rm -f file3
[root@db04 ~]# rm -r /tmp/dir1/
rm：是否删除目录 "/tmp/dir1"？y
[root@db04 ~]# rm -fr dir3
[root@db04 ~]# rm -fr dir4
[root@db04 ~]# mkdir /home/dir
[root@db04 ~]# touch /home/dir/{file2,file3,.file4}
[root@db04 ~]# rm -rf /home/dir/*
[root@db04 ~]# ls /home/dir/ -a
.  ..  .file4
[root@db04 ~]# touch file{1..10}
[root@db04 ~]# touch {1..10}.pdf
[root@db04 ~]# rm -rf file*
[root@db04 ~]# rm -rf *.pdf
```

## 系统文件查看命令

| 查看命令cat |
| :--- |

`cat`:查看文件内容

语法：

```bash
用法：cat [选项]... [文件]...
将[文件]或标准输入组合输出到标准输出。
  -A, --show-all           等于-vET
  -b, --number-nonblank    对非空输出行编号
  -e                       等于-vE
  -E, --show-ends          在每行结束处显示"$"
  -n, --number             对输出的所有行编号
  -t                       与-vT 等价
  -T, --show-tabs          将跳格字符显示为^I
  -u                       (被忽略)
  -v, --show-nonprinting   使用^ 和M- 引用，除了LFD和 TAB 之外
      --help                  显示此帮助信息并退出
      --version            显示版本信息并退出
```

```bash
示例：cat /etc/passwd
示例：cat -n /etc/passwd   //-n参数行号 
示例：cat >> zls.txt <<EOF  //追加数据
     test
     EOF
[root@db04 ~]# cat >> zls.txt << EOF
> 卧槽
> 作者：曾老湿
> 江山风景美如画，
> 本想吟诗赠天下。
> 奈何自己没文化，
> 一句卧槽风好大。
> 就这么地吧。
> 谢谢大家。
> EOF
[root@db04 ~]# cat zls.txt
卧槽
作者：曾老湿
江山风景美如画，
本想吟诗赠天下。
奈何自己没文化，
一句卧槽风好大。
就这么地吧。
谢谢大家。
示例：tac
```

***

| 查看命令more |
| :--- |

```bash
[root@db04 ~]# more /etc/services
```

***

| 查看命令less |
| :--- |

```bash
[root@db04 ~]# less /etc/services
```

***

| 查看命令head |
| :--- |

`head`:查看文件头部

```bash
[root@db04 ~]# head /etc/services
[root@db04 ~]# head -n 5 /etc/services
[root@db04 ~]# head -3 /etc/services
```

***

| 查看命令tail |
| :--- |

`tail`:查看文件尾部

```bash
[root@db04 ~]# tail /etc/services
[root@db04 ~]# tail -n 5 /etc/services
[root@db04 ~]# tail -5 /etc/services
[root@db04 ~]# tail -f /var/log/messages
[root@db04 ~]# tailf /var/log/messages
```

***

| 过滤文件内容grep |
| :--- |

`grep`:过滤

命令示例：

```bash
[root@db04 ~]# grep '风' zls
江山风景美如画，
一句卧槽风好大。
[root@db04 ~]# grep '^江山' zls
江山风景美如画，
[root@db04 ~]# grep '。$' zls
本想吟诗赠天下。
一句卧槽风好大。
就这么地吧。
谢谢大家。
[root@db04 ~]# grep '，$' zls
江山风景美如画，
奈何自己没文化，
[root@db04 ~]# grep '*' zls
[root@db04 ~]# grep '.*' zls
卧槽
作者：曾老湿
江山风景美如画，
本想吟诗赠天下。
奈何自己没文化，
一句卧槽风好大。
江风啦啦啦
就这么地吧。
谢谢大家。
[root@db04 ~]# grep -n '风' zls
3:江山风景美如画，
6:一句卧槽风好大。
[root@db04 ~]# grep -A 1 '风' zls
江山风景美如画，
本想吟诗赠天下。
--
一句卧槽风好大。
就这么地吧。
[root@db04 ~]# grep -nA 1 '风' zls
3:江山风景美如画，
4-本想吟诗赠天下。
--
6:一句卧槽风好大。
7-就这么地吧。
[root@db04 ~]# grep -nB 1 '风' zls
2-作者：曾老湿
3:江山风景美如画，
--
5-奈何自己没文化，
6:一句卧槽风好大。
[root@db04 ~]# grep -nC 1 '风' zls
2-作者：曾老湿
3:江山风景美如画，
4-本想吟诗赠天下。
5-奈何自己没文化，
6:一句卧槽风好大。
7-就这么地吧。
[root@db04 ~]# grep -v '风' zls
卧槽
作者：曾老湿
本想吟诗赠天下。
奈何自己没文化，
就这么地吧。
谢谢大家。
[root@db04 ~]# grep '风景|卧槽' zls
[root@db04 ~]# grep -E '风景|卧槽' zls
卧槽
江山风景美如画，
一句卧槽风好大。
[root@db04 ~]# vim alex.txt
alex is a dsb
ALEX is a DSB
[root@db04 ~]# grep 'alex' alex.txt
alex is a dsb
[root@db04 ~]# grep -i 'alex' alex.txt
alex is a dsb
ALEX is a DSB
```

## 文件上传下载命令

```bash
wget        //文件下载
-O          //指定下载地址,更改名称  
-T          //超时时间
-q          //安静下载(关闭wget输出)
--spider    //网络爬虫   
示例：wget http://www.baidu.com
curl    //文件下载
示例：curl -o http://www.baidu.com
yum install lrzsz
rz  //文件上传
sz  //文件下载
示例：sz filename
```

## 文件查找命令

```bash
locate //查找文件或者目录
示例：locate /etc/sh       //搜索含有/etc/sh的目录或文件
[root@db04 ~]# locate /etc/sh
/etc/shadow
/etc/shadow-
/etc/shells
/usr/local/etc/shadow
/usr/local/etc/shadow-
/usr/local/etc/shells
示例：locate -i /etc/sh    //忽略大小写
which   //查找系统PATH变量目录下的命令(绝对路径)
[root@db04 ~]# which ls
alias ls='ls --color=auto'
    /bin/ls
[root@db04 ~]# type -a ls
ls is aliased to `ls --color=auto'
ls is /bin/ls
[root@db04 ~]# which useradd
/usr/sbin/useradd
whereis //查找文件索引数据库下的命令、源文件、man文件。非PATH变量查找，所以查找的面比which要广 -b,-m
[root@db04 man1]# whereis ls
ls: /bin/ls /usr/share/man/man1/ls.1 /usr/share/man/man1p/ls.1p.gz
[root@db04 man1]# whereis -b ls
ls: /bin/ls
```

## 字符处理命令

| 排序命令sort |
| :--- |

在有些情况下，需要对一个无序的文本文件进行数据的排序, 这时就需要用到`sort`进行排序了。

语法：

```bash
用法：sort [选项]... [文件]...
　或：sort [选项]... --files0-from=F
```

命令示例：

```bash
[root@db04 ~]# cat >> sort.txt <<EOF
b:3
c:2
a:4
e:5
d:1
f:11
EOF
[root@db04 ~]# sort sort.txt
a:4
b:3
c:2
d:1
e:5
f:11
#可观察到, sort文件具有一个特点, 第一个字符是字母, 第三个字符是数字, 中间是用冒号隔开。
#这样我们可以使用-t指定分隔符, 使用-k指定用于排序的列了。
[root@db04 ~]# sort -t ':' -k 2 sort.txt
d:1
f:11            //为什么11在第二个？？？
c:2
b:3
a:4
e:5
#-n 按照数字顺序排序
[root@db04 ~]# sort -t ':' -k 2 -n sort.txt
d:1
c:2
b:3
a:4
e:5
f:11
#倒叙
[root@db04 ~]# sort -t ':' -k 2 -n -r sort.txt
f:11
e:5
a:4
b:3
c:2
d:1
#小练习
192.168.3.1 00:0F:AF:81:19:1F
192.168.3.2 00:0F:AF:85:6C:25
192.168.3.3 00:0F:AF:85:70:42
192.168.2.20 00:0F:AF:85:55:DE
192.168.2.21 00:0F:AF:85:6C:09
192.168.2.22 00:0F:AF:85:5C:41
192.168.0.151 00:0F:AF:85:6C:F6
192.168.0.152 00:0F:AF:83:1F:65
192.168.0.153 00:0F:AF:85:70:03
192.168.1.10 00:30:15:A2:3B:B6
192.168.1.11 00:30:15:A3:23:B7
192.168.1.12 00:30:15:A2:3A:A1
192.168.1.1 00:0F:AF:81:19:1F
192.168.2.2 00:0F:AF:85:6C:25
192.168.3.3 00:0F:AF:85:70:42
192.168.2.20 00:0F:AF:85:55:DE
192.168.1.21 00:0F:AF:85:6C:09
192.168.2.22 00:0F:AF:85:5C:41
192.168.0.151 00:0F:AF:85:6C:F6
192.168.1.152 00:0F:AF:83:1F:65
192.168.0.153 00:0F:AF:85:70:03
192.168.3.10 00:30:15:A2:3B:B6
192.168.1.11 00:30:15:A3:23:B7
192.168.3.12 00:30:15:A2:3A:A1
```

***

| 去重操作uniq |
| :--- |

如果文件中有多行完全相同的内容, 当前是希望能删除重复的行，同时还可以统计出完全相同的行出现的总次数, 那么就可以使用`uniq`命令解决这个问题(但是必须配合`sort`使用)。

语法：

```bash
uniq [OPTION]... [INPUT [OUTPUT]]
```

命令示例：

```bash
[root@db04 ~]# cat >> uniq.txt <<EOF
abc
123
abc
123
EOF
[root@db04 ~]# uniq uniq.txt
abc
123
abc
123
[root@db04 ~]# sort uniq.txt
123
123
abc
abc
[root@db04 ~]# sort uniq.txt |uniq
123
abc
[root@db04 ~]# sort uniq.txt |uniq -c
      2 123
      2 abc
#小练习，统计nginx日志访问量，最高的IP前十个
```

***

| 截取命令cut |
| :--- |

语法：

```bash
cut OPTION... [FILE]...
```

命令示例：

```bash
[root@db04 ~]# cat >> info.txt <<EOF
I'm zls,18 years old QQ 133411023
EOF
[root@db04 ~]# cut -d ' ' -f 2,6 info.txt
zls,18 133411023
[root@db04 ~]# cut -d ' ' -f 2,6 info.txt |cut -d ',' -f 1,2
zls,18 133411023
[root@db04 ~]# cut -d ' ' -f 2,6 info.txt |cut -c 1-3,8-16
zls133411023
```

***

注意：其实还有两个牛逼的命令可以处理 `awk`(取列)和`sed`(取行，替换)

***

| 统计命令wc |
| :--- |

语法：

```bash
wc [OPTION]... [FILE]...
```

命令示例：

```bash
[root@db04 ~]# wc /etc/services
 10774  58108 641020 /etc/services
#字节
[root@db04 ~]# wc -c /etc/services
641020 /etc/services
#单词
[root@db04 ~]# wc -w /etc/services
58108 /etc/services
#行数
[root@db04 ~]# wc -l /etc/services
10774 /etc/services
```

## 习题：

1.过滤出/etc/passwd以nologin结尾的内容，并统计行数

2.使用ifconfig命令获取当前的IP地址

3.将/etc/sysconfig/selinux文件中的SELINUX=enforcing替换为SELINUX=disabled

4.分析如下日志内容，每个域名被访问次数

```bash
[root@student tmp]# cat web.log 
http://www.driverzeng.com/index.html
http://www.driverzeng.com/1.html
http://post.driverzeng.com/index.html
http://mp3.driverzeng.com/index.html
http://www.driverzeng.com/3.html
http://post.driverzeng.com/2.html
```

5.用普通用户身份登陆虚拟机上完成练习

6.在用户家目录下创建6个文件 song1.mp3 ~ song6.mp3

7.把上题创建的songX.mp3文件移动到Music目录下（不存在则创建）

8.在用户家目录下创建三个目录,分别为 friends,family,work

9.切换到friends目录下,把Music目录下的song1.mp3 ~ song3.mp3 拷贝到当前目录

10.切换到family目录下,把Music目录下的song4.mp3 ~ song6.mp3 移动到当前目录

11.切换到用户主目录

12.删除family目录

13.切换到friends目录,把目录下的所有文件删除

14.切换到主目录,把friends目录删除.

> 更新: 2024-09-21 12:13:43  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/yfcd8n>