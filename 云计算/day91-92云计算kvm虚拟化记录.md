# day91-92 云计算kvm虚拟化记录

 

# 检查虚拟机是否支持虚拟化
egrep --color -i "svm|vmx" /proc/cpuinfo

 

![1566204893498-3b9ae4ab-1f68-4836-9214-6d78100a04fb.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-01.jpeg)

 

前提 amdcpu不支持   bios里要开启支持虚拟化    vmware 设置 cpu要开启 虚拟化intel vt-x/EPT 打钩

 

![1566204893588-c98b85dc-42ea-470d-94b2-c076d36b4f80.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-02.jpeg)

 

 

# 使用光盘搭建本地yum源
第一步：挂载光盘：mount /dev/cdrom /mnt

第二步：使网络yum源失效：cd /etc/yum.repos.d/   进入yum源目录，

 

修改yum源文件后缀名，使其失效：mv CentOS-Base.repo CentOS-Base.repo.bak

 

第三步： 使光盘yum源失效：

 

新建CentOS-Media.repo并添加内容:   vi CentOS-Media.repo

 

# CentOS-Media.repo

#

[c7-media]

name=CentOS-$releasever - Media

baseurl=file:///mnt

gpgcheck=1

enabled=1

gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

第四步：保存退出后，安装一个命令试一试 例如：yum makecache

 

 

 

 

 

 

 

宿主机：内存4G+  纯净的系统CentOS-7

 

# 1：什么是虚拟化？
虚拟化，是指通过虚拟化技术将一台计算机虚拟为多台逻辑计算机。在一台计算机上同时运行多个逻辑计算机，每个逻辑计算机可运行不同的操作系统，并且应用程序都可以在相互独立的空间内运行而互不影响，从而显著提高计算机的工作效率

 

虚拟化使用软件的方法重新定义划分IT资源，可以实现IT资源的动态分配、灵活调度、跨域共享，提高IT资源利用率，使IT资源能够真正成为社会基础设施，服务于各行各业中灵活多变的应用需求。

 

# 2：为什么要用虚拟化？
512G 内存，4路 8核16线程 cpu，12* PCI-E 1T的SSD；ntp服务，资源浪费，10 tomcat多实例，6个数据库，2个Hadoop

 

既不想资源浪费，服务的安全隔离性，虚拟化

 

场景1：同一台物理机运行多个php版本

场景2：机房的迁移，解决了硬件和系统的依赖

场景3：openstack环境，软件发布体检

场景4：开发环境和测试环境，使用虚拟化

场景5：业务的快速部署

 

3台物理服务器, 2 个项目组,60多个开发.

 

虚拟化：提高了资源的利用率，服务的安全性隔离，解决了系统和硬件之间的依赖

 

# 3：kvm虚拟化软件的安装
[root@backup ~]# mount /dev/cdrom /mnt

 

yum install libvirt* virt-* qemu-kvm* -y

 

KVM：Kernel-based Virtual Machine 

 

libvirt  作用：虚拟机的管理软件

virt   virt-install virt-clone   作用：虚拟机的安装和克隆

qemu-kvm  qemu-img 作用：复制管理虚拟机的磁盘

 

虚拟化软件：

qemu      软件纯模拟全虚拟化软件，特别慢！

xen(半)   性能特别好，需要使用专门修改之后的内核

KVM       全虚拟机，它有硬件支持cpu，基于内核，而且不需要使用专门的内核

vmware workstation(图形界面)

virtualbox(图形界面)

 

4：安装一台kvm虚拟机

分发软件TightVNC或者VNC Viewer 4.exe

 

systemctl start libvirtd.service

systemctl status libvirtd.service

 

使用xftp把centos7.4系统iso文件传上虚拟机

![1566204893692-cdd7168a-b76b-44f2-aa7d-5e09b7ca0a82.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-03.jpeg)

建议虚拟机内存不要低于1024M，否则安装系统特别慢！

virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name centos7 --memory 1024 --vcpus 1 --disk /opt/centos2.raw,format=raw,size=10 --cdrom /opt/CentOS-7.4-x86_64-DVD-1708.iso --network network=default --graphics vnc,listen=0.0.0.0 –noautoconsole

 

参数说明

                     --virt-type  虚拟化类型

                     --os-type   系统类型

                     --os-variant  发行版本

                     --name      虚拟机的名字

                    --memory    虚拟机的内存

                     --vcpus      虚拟cpu核数

                     --disk       指定硬盘路径    format镜像格式   size 大小 单位是G

                --cdrom     指定光盘

                     --network network   指定网络   这里是默认的内核网络 NAT

                     --graphics    控制台指定 vnc上显示画面

                                                     监听端口 0.0.0.0

                     –noautoconsole   不自动控制台 (不加这个参数命名行一直䟘住那里)

 

 

 

  

## 使用tightvnc 连接虚拟机
### tightvnc 软件windows 安装时候选择 自定义 安装客户端就可以
连接填写 ip 10.0.0.41

![1566204893769-116c4017-9949-48fc-a1d7-258aa3b3f42e.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-04.jpeg)![1566204893851-bd399315-d9ed-4dda-a7a4-9725eaaac963.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-05.jpeg)

 

![1566204893942-484a56ee-085a-4021-9c0d-99bf21d4e4eb.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-06.jpeg)

开启网络 连上网络就可以  主机名:oldboy

![1566204893994-c3565ef4-ab23-4fea-ab2e-c9e5193ecb08.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-07.jpeg)

选上海时区  同步时间

![1566204894048-c7c48f09-42f3-4675-bc10-b1202929669d.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-08.jpeg)

硬盘分区选项 一定不要选lvm 选 standard partition  只要一个跟分区就可以  忽略警告

![1566204894139-171de206-fa74-4421-a862-185923c026e8.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-09.jpeg)

![1566204894215-be38a59c-e205-4bfc-90c3-0a44c60e3de1.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-10.jpeg)

 

![1566204894288-91c8df7a-709f-469c-88fb-ff6cfff8f33d.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-11.jpeg)

 

kdump 备份策略关闭

 

![1566204894377-05f2ad4e-b41a-4aa3-b07d-c6aacb7b958e.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-12.jpeg)

 

安装 设置个密码就可以 等待安装完

 

 

raw：10G  不支持做快照，性能好

qcow2：   支持快照

 

# 5：kvm虚拟机的virsh日常管理和配置
列表list

![1566204894447-2d3b7686-8e8c-4989-a361-41217d519e81.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-13.jpeg)

开机start

![1566204894524-975c9324-7328-4cc0-a79b-9ff11d667d58.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-14.jpeg)

 

vnc连接填写ip 方式 10.0.0.41:端口 第一台5900  第二台5901

                                          或者是 10.0.0.41:1

关机shutdown

![1566204894595-93569566-7051-40e8-a4e1-5369d07f44c7.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-15.jpeg)

拔电源关机destroy

![1566204894688-527bca19-6125-4d28-b0a6-11ffbd5d72d8.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-16.jpeg)

导出配置dumpxml  例子：virsh dumpxml centos7 >centos7-off.xml

![1566204894748-c4ae08e7-f803-4b18-945f-3833f3ac5eeb.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-17.jpeg)

 

![1566204894817-282a0977-0e2d-4f41-8999-e1ac90df3467.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-18.jpeg)

 

[root@backup opt]# ls /etc/libvirt/qemu/    #配置文件默认存放位置

centos7.xml  networks

删除undefine  推荐：先destroy，在undefine

[root@backup opt]# virsh undefine centos7    #这个只是删除了配置文件 实体文件 raw文件没被删除的

域 centos7 已经被取消定义

 

[root@backup opt]# ls /etc/libvirt/qemu/

networks

导入配置define  

[root@backup opt]# virsh define centos7.xml

定义域 centos7（从 centos7.xml）

修改配置edit(自带语法检查)

[root@backup opt]# mv centos2.raw  centos7.raw  #修改实体文件名

[root@backup opt]# virsh start centos7

错误：开始域 centos7 失败

错误：Cannot access storage file '/opt/centos2.raw': 没有那个文件或目录

 

[root@backup opt]# virsh edit centos7

![1566204894889-b8ca7610-2abd-48b0-a82c-b5a94c9f830f.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-19.jpeg)

重命名domrename （低版本不支持）

[root@backup opt]# virsh domrename centos7 web01

错误：所需操作无效：cannot rename active domain

 

[root@backup opt]# virsh shutdown centos7

域 centos7 被关闭

 

[root@backup opt]# virsh domrename centos7 web01

Domain successfully renamed

 

[root@backup opt]# virsh list --all

 Id    名称                         状态

----------------------------------------------------

 -     web01                          关闭

挂起suspend

恢复resume

![1566204894979-b00a51d4-d874-4164-9d8e-cb5969bbe9b2.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-20.jpeg)

查询vnc端口号vncdisplay

![1566204895063-b359b0d0-8d68-428b-82fe-392d1360ca1a.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-21.jpeg)

 

reboot重启虚拟机

[root@kvm ~]# virsh reboot web01

Domain web01 is being rebooted

# 6：kvm虚拟机开机启动和console登录
 

开机启动autostart，前提：systemctl enable libvirtd；

[root@backup opt]# virsh autostart web01

域 web01标记为自动开始

取消开机启动autostart --disable

[root@backup opt]# virsh autostart --disable web01

域 web01取消标记为自动开始

 

centos7的kvm虚拟机：

vnc连接查看ip --> XSHELL ssh连接到虚拟机上

![1566204895140-da86d2e8-5edd-45d8-b53b-105bd4a6a918.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-22.jpeg)

 

#修改内核参数命令  实际修改的是/etc/grub2.cfg -> ../boot/grub2/grub.cfg

grubby --update-kernel=ALL --args="console=ttyS0,115200n8"

reboot

 

virsh console连接到虚拟机      ctrl+] 退出虚拟机

![1566204895229-3d08dfff-416d-4214-b93a-bba43d072037.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-23.jpeg)

 

### 作业1：实现centos6的虚拟机，console命令行登录？
安装一台centos6 的kvm虚拟机

console命令行登陆

 

centos6 安装

virt-install --virt-type kvm --os-type=linux --os-variant rhel6 --name centos6 --memory 1024 --vcpus 1 --disk /opt/centos6.raw,format=raw,size=10 --cdrom /opt/CentOS-6.9-x86_64-bin-DVD1.iso --network network=default --graphics vnc,listen=0.0.0.0 --noautoconsole

 

 

配置虚拟机模板支持vish console功能

+ **1. ****添加****ttyS0****的安全许可**

_# __添加__ttyS0__的许可，允许__root__登陆_

[root@centos6 ~]# echo "ttyS0" >> /etc/securetty

 

+ **2. ****编辑****/etc/inittab****，添加如下**

[root@centos6 ~]# cat /etc/inittab

... ...

S0:12345:respawn:/sbin/agetty ttyS0 115200, 1152000 xterm

 

3. 配置grub.conf

在kernel行添加如下配置console=tty0 console=ttyS0,115200n8

[root@centos6 ~]# cat /etc/grub.conf

... ... #省略

default=0

timeout=5

splashimage=(hd0,0)/grub/splash.xpm.gz

hiddenmenu

title CentOS (2.6.32-642.4.2.el6.x86_64)

        root (hd0,0)

        kernel /vmlinuz-2.6.32-642.4.2.el6.x86_64 ro root=/dev/mapper/vg_linux-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_LVM_LV=vg_linux/lv_swap rd_NO_MD rd_LVM_LV=vg_linux/lv_root SYSFONT=latarcyrheb-sun16 crashkernel=auto  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet console=tty0 console=ttyS0,115200n8

        initrd /initramfs-2.6.32-642.4.2.el6.x86_64.img

·       **4. ****重启虚拟机**

[root@centos6 ~]_# reboot_

 

5. 确认配置生效

在KVM宿主机执行命令

[root@kvm01 ~]# virsh console instance001

virsh console instance001

Connected to domain instance001

Escape character is ^] #此处[Enter]

 

CentOS release 6.8 (Final)

Kernel 2.6.32-642.4.2.el6.x86_64 on an x86_64

 

centos6 login: root

Password:  #此处输入root密码

Last login: Fri Sep  2 03:53:22 on ttyS0

 

参考文档

https://blog.csdn.net/oyym_mv/article/details/52412797

 

# 7：kvm虚拟机虚拟磁盘格式转换和快照管理
#安装系统初始时候指定磁盘类型

virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name centos7 --memory 1024 --vcpus 1 --disk /data/oldboy.qcow2,format=<font style="color:red;">qcow2</font>,size=10 --cdrom /data/CentOS-7.2-x86_64-DVD-1511.iso --network network=default --graphics vnc,listen=0.0.0.0 --noautoconsole

 

raw：裸格式，占用空间比较大，不支持快照功能，性能较好，

qcow2：cow  （copy on write）占用空间小，支持快照，性能比raw差一点

              qemu

              cow  == copy on write  写时复制

 

qemu-img info  test.qcow2

![1566204895288-09904d20-1310-49ae-8eb7-c5cc90a2ba13.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-24.jpeg)

 

![1566204895347-9a55532d-f266-4a45-936b-64bfce099796.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-25.jpeg)

创建一块qcow2格式的虚拟硬盘：qemu-img create -f qcow2 test.qcow2 2G

![1566204895409-4e0b1499-0b2b-47fd-9ed6-5f64b99ada1b.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-26.jpeg)

 

# -f 指定格式类型

![1566204895482-c44be7b4-063a-4218-967c-f30621249b30.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-27.jpeg)

 

# 调整大小

![1566204895566-9041a810-805f-4a2d-8c8f-6c6469cf74f3.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-28.jpeg)

raw转qcow2：qemu-img convert -f raw     -O qcow2           oldboy.raw   oldboy.qcow2

                     convert [-f fmt]   [-O output_fmt]    filename     output_filename

![1566204895637-f86d21b3-f3e9-48fc-81dd-6f779c2cf388.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-29.jpeg)

 

![1566204895747-e3b908b6-4983-4141-8a6c-2314ec0d4bbc.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-30.jpeg)

 

#前面加time 显示转换时间

[root@kvm opt]# time qemu-img convert -f raw -O qcow2 /opt/centos7.raw /opt/centos7.qcow2

![1566204895805-67fd4132-65e5-47c1-ae72-81a4ae09b4c6.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-31.jpeg)

 

virsh edit web01                                

<disk type='file' device='disk'>

      <driver name='qemu' type='<font style="color:red;">qcow2</font>'/>

      <source file='/data/<font style="color:red;">centos7.qcow2'</font>/>

      <target dev='vda' bus='virtio'/>

      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='

0x0'/>

</disk>

                                    

![1566204895870-c5863ee5-424a-4331-9c38-f9aa340e9b81.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-32.jpeg)

                                    

创建快照virsh snapshot-create centos7

![1566204895927-64a90e33-06a7-439d-a2ce-12b61f190c52.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-33.jpeg)

查看快照virsh snapshot-list centos7

![1566204895990-49bf82b2-963e-4ebc-9274-f7336dee401e.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-34.jpeg)

还原快照virsh snapshot-revert centos7 --snapshotname 1516574134

![1566204896075-e2d8b32a-8d85-4b69-b262-b1c035f3b396.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-35.jpeg)

删除快照virsh snapshot-delete centos7 --snapshotname 1516636570

![1566204896152-55861719-f8b2-4ba4-9a28-3928f5a8ee1c.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-36.jpeg)

 

8:kvm虚拟机克隆

virt-clone --auto-clone -o centos7(完整克隆)   |不会克隆快照

![1566204896210-8714701b-06ae-453c-93cc-ce055373a8ba.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-37.jpeg)

kvm链接克隆   | 后置备

#磁盘文件

![1566204896262-b7ccaa0c-6dc5-4295-92e6-e4c3db162151.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-38.jpeg)

 

#配置文件准备

[root@kvm opt]# cp web01.xml web03.xml

[root@kvm opt]# vim web03.xml

改名字

删除uuid

删除 mac地址

改磁盘路径

#导入配置文件

[root@kvm opt]# virsh define web03.xml

Domain web03 defined from web03.xml

 

#或者是启动安装命令 自动生成配置文件  |推荐

![1566204896339-2530d942-f2b6-4a70-82d6-b4b547f408b8.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-39.jpeg)

 

virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name web04 --memory 1024 --vcpus 1 --disk /opt/web04.qcow2 --boot hd --network network=default --graphics vnc,listen=0.0.0.0 --noautoconsole

 

# 9：kvm虚拟机的桥接网络
1:virsh iface-bridge eth0 br0

### 默认的的虚拟机网络是NAT模式  网段192.168.122.0/24
#查看iptables 规则

iptables -t nat -L –n

 

![1566204896418-ea3a7116-3d59-414d-88f0-23d2e0cba12a.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-40.jpeg)

 

内核转发参数

![1566204896513-ca867260-9cb0-469d-866d-086c3917e49b.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-41.jpeg)

 

 

配置永久生效内核转发参数

root@kvm opt]# echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf

 

#检查

![1566204896586-1241c1ef-0fdb-4615-b238-e0d0ce1f1d94.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-42.jpeg)

 

 

#创建桥接网络    |不依赖宿主机内核转发

![1566204896639-3f664a74-8c56-4723-84b2-40ed831fbc1d.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-43.jpeg)

 

![1566204896696-920a9366-00b2-460b-bfd9-b4fd87acb526.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-44.jpeg)

 

#安装指定桥接网络 从新定义生成配置文件  |前提先删除配置文件 undefine

virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name web04 --memory 1024 --vcpus 1 --disk /opt/web04.qcow2 --boot hd --network bridge=br0 --graphics vnc,listen=0.0.0.0 --noautoconsole

 

 

 

 

#查看路由信息

![1566204896750-6cb0af6c-753c-4e7f-93f8-3a2246d7a5a8.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-45.jpeg)

 

 

### 2:virsh edit web01
 

virsh edit web01

#修改红色部分   

<interface type='<font style="color:red;">bridge</font>'>

      <mac address='52:54:00:55:aa:fa'/>

      <source <font style="color:red;">bridge='br0'</font>/>

在宿主机上，重启虚拟机生效

这里vmware dhcp服务要打开 kvm虚拟机才能自动获取到网络

![1566204896815-6d2ca816-4935-402b-be0a-d90ae2feb725.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-46.jpeg)

 

#重启web01

[root@kvm opt]# virsh start web01

Domain web01 started

 

#验证 ssh连接

![1566204896884-a9869f75-5212-44b7-b535-1806f4434661.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-47.jpeg)

 

 

 

### 3:修改kvm虚拟机的ip  |手动设置ip    这种方式vmware可以不用开dhcp
echo 'TYPE=Ethernet

BOOTPROTO=static

NAME=eth0

DEVICE=eth0

ONBOOT=yes

IPADDR=10.0.0.111

NETMASK=255.255.255.0

GATEWAY=10.0.0.254

DNS1=223.5.5.5' >/etc/sysconfig/network-scripts/ifcfg-eth0

4.验证

![1566204896953-ff38296f-dc66-4892-9192-d94443a66100.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-48.jpeg)

 

取消桥接网卡

iface-unbridge br0

 

 

扩展 修改默认的nat 网段

![1566204897072-afd2948b-789c-4f10-a5b0-500682e3ddd0.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-49.jpeg)

# 10：kvm虚拟机在线热添加硬盘
# kvm宿主机 创建一个磁盘

qemu-img create -f qcow2 oldboy2.qcow2 5G

#为web01热添加硬盘

virsh attach-disk web01 /opt/oldboy2.qcow2 vdb --live --cache=none --subdriver=qcow2

 

 

#kvm虚拟机查看到新添加的硬盘/dev/vdb

![1566204897157-9a4a6e11-6ba6-4898-b3cf-19d3dabbd7e6.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-50.jpeg)

 

###虚拟机###

mkfs.xfs /dev/vdb

 

![1566204897223-30a5fe07-e731-4455-99c2-99fe83e8904b.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-51.jpeg)

 

mount /dev/vdb /data

 

![1566204897297-cc509b10-e3cd-43d7-ba31-590fd866b6c6.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-52.jpeg)

 

 

 

虚拟机磁盘扩容：

umount /data

 

在kvm虚拟机，卸载

virsh detach-disk web01  vdb

#增加5G

qemu-img resize /data/centos7-add01.qcow2 +5G

#重新热添加

virsh attach-disk web01 /data/centos7-add01.qcow2 vdb --live --cache=none --subdriver=qcow2

 

在虚拟机中：

mount /dev/vdb /data

#更新分区大小

xfs_growfs /dev/vdb

 

 

## 根分区扩容：
1）在宿主机上关闭虚拟机并调整虚拟机磁盘大小

#关机web01

virsh shutdown web01

 

#加 10G

qemu-img resize oldboy.qcow2 +10G

 

 

![1566204897357-57717a86-bef4-4033-af4f-bc3cf1779231.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-53.jpeg)

2）虚拟机中fdisk重新分区

fdisk /dev/vda

 

#操作记录

 

[root@oldboy ~]# <font style="color:red;">fdisk /dev/vda</font>

Welcome to fdisk (util-linux 2.23.2).

 

Changes will remain in memory only, until you decide to write them.

Be careful before using the write command.

 

Command (m for help): <font style="color:red;">p</font>

 

Disk /dev/vda: 10.7 GB, 10737418240 bytes, 20971520 sectors

Units = sectors of 1 * 512 = 512 bytes

Sector size (logical/physical): 512 bytes / 512 bytes

I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk label type: dos

Disk identifier: 0x000bb03b

 

   Device Boot      Start         End      Blocks   Id  System

/dev/vda1   *        2048    20971519    10484736   83  Linux

 

Command (m for help): <font style="color:red;">d</font>

Selected partition 1

Partition 1 is deleted

 

Command (m for help): <font style="color:red;">n</font>

Partition type:

   p   primary (0 primary, 0 extended, 4 free)

   e   extended

Select (default p): p

Partition number (1-4, default 1):

First sector (2048-20971519, default 2048):

Using default value 2048

Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519):

Using default value 20971519

Partition 1 of type Linux and of size 10 GiB is set

 

Command (m for help): <font style="color:red;">p</font>

 

Disk /dev/vda: 10.7 GB, 10737418240 bytes, 20971520 sectors

Units = sectors of 1 * 512 = 512 bytes

Sector size (logical/physical): 512 bytes / 512 bytes

I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk label type: dos

Disk identifier: 0x000bb03b

 

   Device Boot      Start         End      Blocks   Id  System

/dev/vda1            2048    20971519    10484736   83  Linux

 

Command (m for help): <font style="color:red;">w</font>

The partition table has been altered!

 

Calling ioctl() to re-read partition table.

 

WARNING: Re-reading the partition table failed with error 16: Device or resource busy.

The kernel still uses the old table. The new table will be used at

the next reboot or after you run partprobe(8) or kpartx(8)

Syncing disks.

[root@oldboy ~]# <font style="color:red;">partprobe /dev/vda1   //</font><font style="color:red;">通知分区表并没有用</font><font style="color:red;">, </font><font style="color:red;">要重启</font>

 

[root@oldboy ~]# <font style="color:red;">reboot</font>

 

3)重启之后，执行

<font style="color:red;">xfs_growfs /dev/vda1</font><font style="color:red;">，</font>

如果虚拟机磁盘文件系统是ext4：resize2fs /dev/vda1

 

 

#报错  解决:删除完快照

![1566204897406-2b6524fc-6d69-426f-81ae-74dd99984b9f.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-54.jpeg)

 

热添加配置文件没有,重启之后 又要重新添加硬盘和挂载

添加到配置文件命令

临时生效

virsh  attach-disk web04 /opt/oldboy.qcow2 vdb --subdriver qcow2

永久生效

virsh  attach-disk web04 /opt/oldboy.qcow2 vdb --subdriver qcow2 --config

 

 

## kvm 虚拟机在线热添加网卡
virsh # attach-interface web01 --type bridge --source br0 --model virtio --config

Interface attached successfully

 

attach-interface 网卡接口

web01 主机名

-type  网络类型  

--source  源  指定它桥接到哪块网卡上

--model  模式 virtio(网卡名是eth1 开始)  不加这个模式 默认是ens9这种

--config   写入配置文件(这个要重启才生效)

 

![1566204897472-d11d6ad3-1d70-4db8-b828-59b1b720b05b.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-55.jpeg)

 

 

#删除 网卡

virsh # edit web01

# 找到对应的 mac addr 标签删除

    <interface type='bridge'>

      <mac address='52:54:00:42:9a:2c'/>

      <source bridge='br0'/>

      <model type='virtio'/>

      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>

</interface>

:wq  保存 

重启 reboot web01

 

 

 

扩展  查看本机所有网卡信息

![1566204897535-30cad051-8581-4f04-91ea-3f92a9d1ccad.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-56.jpeg)

## kvm 虚拟机在线热添加内存
[root@kvm opt]# virsh list --all

 Id    Name                           State

----------------------------------------------------

 7     web01                          running

 -     centos6                        shut off

 -     web02                          shut off

 -     web03                          shut off

 

#删除web03 配置文件

[root@kvm opt]# virsh undefine web03

Domain web03 has been undefined

# 重新生成配置文件  <font style="color:red;">maxmemory=2048</font>

[root@kvm opt]# virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name web03   --memory 512,maxmemory=2048 --vcpus 1,maxvcpus=8 --disk /opt/web03.qcow2 --boot hd --network bridge=br0 --graphics vnc,listen=0.0.0.0 --noautoconsole

 

Starting install...

 

Domain creation completed.

#启动web03虚拟机

[root@kvm opt]# virsh start web03

Domain web03 started

#显示 进程id 用于vnc连接

[root@kvm opt]# virsh vncdisplay web03

:1

 

vnc连接上 10.0.0.11:1 #查看内存

![1566204897602-d96dc966-f766-4771-92cd-5dbdc25419be.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-57.jpeg)

 

#kvm宿主机 修改web03 内存1024

[root@kvm opt]# virsh setmem web03 1024M –live

 

# 虚拟机检查

![1566204897654-3eef46ac-ec85-436e-aff9-23f872b3c127.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-58.jpeg)

 

 

![1566204897733-a35a018f-8876-4881-93ae-c06708ba68b5.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-59.jpeg)

 

## kvm 虚拟机 热添加 cpu
 

![1566204897794-f0b7d7b6-c5e7-4731-aee8-e731417c340e.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-60.jpeg)

 

#删除web03 配置文件

[root@kvm opt]# virsh undefine web03

Domain web03 has been undefined

 

#重新生成配置文件  maxvcpus=8

virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name web03   --memory 512,maxmemory=2048 --vcpus 1,maxvcpus=8 --disk /opt/web03.qcow2 --boot hd --network bridge=br0 --graphics vnc,listen=0.0.0.0 --noautoconsole

 

# vnc 连接 查看cpu核数

![1566204897855-e6b6e6d5-f593-490e-ba5e-461ba77477f5.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-61.jpeg)

 

#cpu添加到4核

virsh # setvcpus web02 4 –live

 

#虚拟机检查

![1566204897915-fb8071f5-040c-49df-8bc7-7264333ce215.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-62.jpeg)

 

 

 

 

![1566204897971-3ec465e8-d5c5-4993-8b05-2b3a16778214.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-63.jpeg)

 

 

 

 

 

ksm 内存压缩技术     云厂商,超卖

                     相同的内存 合并在一块

           64G 物理内存

           1G 内存虚拟机 2倍, 128台  5倍 320台

32G 阿里云自己的淘宝  32G  96台

 

 

#一条命令开启所有kvm虚拟机    

![1566204898042-8c0406ac-b4cd-4685-bb18-74f3371812c8.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-64.jpeg)

 

 

 

# 什么时候需要用到热迁移?
业务要求停机时间特别短,

 

服务安全等级

999

9999

 

集群架构进行扩容:

一台物理服务器  10台 kvm虚拟机

2台物理服务器   3+3  kvm虚拟机

 

热迁移的限制?

           需要共享存储.

 

## 热迁移实操
热迁移描述：

相比KVM虚拟机冷迁移中需要拷贝虚拟机虚拟磁盘文件，kvm虚拟机热迁移无需拷贝虚拟磁盘文件，但是需要迁移到的宿主机之间需要有相同的目录结构虚拟机磁盘文件，也就是共享存储，本文这部分内容通过nfs来实现，当然也可以采用Glusterfs集群文件系统来实现.

热迁移流程：

在kvm01上挂起虚拟机vm01，发送vm的虚拟机配置文件和运行时内存中的数据到kvm02, 接受完毕，kvm02恢复vm01,热迁移完成。

 

架构图如下:

![1566204898104-14bb0198-b387-404d-8c29-44d6b3ab1c96.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-65.jpeg)

 

<font style="color:#606777;">环境要求：</font>

| 主机名 | ip | 内存 | 网络 | 软件需求 | 虚拟化 |
| --- | --- | --- | --- | --- | --- |
| kvm01 | 10.0.0.11 | 2G | 创建br0桥接网卡 | kvm和nfs | 开启虚拟化 |
| kvm02 | 10.0.0.12 | 2G | 创建br0桥接网卡 | kvm和nfs | 开启虚拟化 |
| nfs01 | 10.0.0.31 | 1G | 无 | nfs | 无 |


 

 

<font style="color:red;">注意：需要互相做好</font><font style="color:red;">host</font><font style="color:red;">解析</font><font style="color:red;">  </font><font style="color:red;">三台机器</font><font style="color:red;">hosts</font><font style="color:red;">都一样</font>

[root@kvm01 ~]# cat /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4

::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.11 kvm01

10.0.0.12 kvm02

10.0.0.31 nfs01

 

 

一：在kvm01和kvm02上安装kvm和nfs,配置桥接网卡

yum install libvirt* virt-* qemu-kvm* nfs-utils openssh-askpass -y

systemctl start libvirtd.service

 

#创建网桥网卡

virsh iface-bridge eth0 br0

 

# 启动libvirtd 报错

![1566204898175-afa7a65b-77c1-4e0a-9c4e-332af143b730.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-66.jpeg)

 

#查询libvirtd 是哪个包装的

[root@kvm02 yum.repos.d]# rpm -qf /usr/sbin/libvirtd

libvirt-daemon-4.5.0-10.el7_6.3.x86_64

 

[root@kvm02 yum.repos.d]# rpm -ql libvirt-daemon-4.5.0-10.el7_6.3.x86_64

 

 

 

二：在nfs01上安装配置nfs

yum install nfs-utils -y

mkdir /data

#这里是配置 no_root  no_all  是不用验证用户

vim /etc/exports

/data 10.0.0.0/24(rw,async,no_root_squash,no_all_squash)

 

systemctl restart rpcbind

systemctl restart nfs

 

三：kvm01和kvm02挂载共享目录/opt

mount -t nfs 10.0.0.31:/data /opt

 

 

四：安装一台基于桥接模式的虚拟机

 

virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name web01   --memory 1024,maxmemory=2048 --vcpus 1,maxvcpus=8 --disk /opt/centos7.qcow2 --boot hd --network bridge=br0 --graphics vnc,listen=0.0.0.0 --noautoconsole

将虚拟机ip配置为10.0.0.111

 

 

## 不装图形界面迁移
virsh migrate --live web01 qemu+ssh://10.0.0.12/system –unsafe

 

![1566204898236-1ec38908-fd09-4364-84b7-5c3c94e736df.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-67.jpeg)

 

#kvm02 上查看 已经到kvm02 上了

![1566204898319-63a23a87-d1ea-4fdf-8457-23a9cb927483.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-68.jpeg)

 

在迁移命令之前用宿主机ping 虚拟机

![1566204898389-0ec25193-3eb3-4052-98df-b8e91d980c9d.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-69.jpeg)

 

 

五：在kvm01上安装图形界面、vnc服务端和virt-manager

yum groups install "GNOME Desktop" -y

yum install tigervnc-server.x86_64 -y

yum install virt-manager -y

六：启动vnc服务端

vncserver :1 启动5901端口的vnc服务端

vncserver -kill :1 关闭5901端口的vnc服务端

 

![1566204898449-26302873-98cb-4b78-8f96-29edca272547.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-70.jpeg)

 

七：使用vnc连接宿主机，使用virt-manager进行迁移

 

![1566204898516-17b04cb6-eefe-46eb-9be1-1d8265a3a8f2.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-71.jpeg)

 

这时候会提醒输入密码，就是之前第6步的时候设置的vnc连接密码

![1566204898575-ea16e8c7-216c-4ca1-ad9f-2be9b48fecad.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-72.jpeg)

![1566204898635-6ee70c09-8b50-45f3-873b-3b535e0fe16e.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-73.jpeg)

![1566204898693-e271f239-2afe-4eb0-b3cb-10a83eaff99d.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-74.jpeg)

![1566204898754-bcd10a85-720f-40cb-9666-2668fe5167b1.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-75.jpeg)

![1566204898862-75fdba4e-e4ff-4a98-9464-4574a7ce183f.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-76.jpeg)

![1566204898934-0ad89392-dafa-4cbf-8c50-f4ef2ad58196.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-77.jpeg)

![1566204899021-24863115-08e1-46d3-b9f5-57d9de7798a6.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-78.jpeg)

![1566204899098-e0b07014-953a-44df-84e4-a0ff273c5c52.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-79.jpeg)

![1566204899166-d31d4ae0-9001-4648-832f-8fe0ac13aefa.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-80.jpeg)

![1566204899234-3bcae56c-d693-4f57-99de-2fbcb1fc3b3f.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-81.jpeg)

![1566204899304-35c6b83d-5095-45cb-90f1-100cbf9b2326.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-82.jpeg)

![1566204899361-8141540d-548f-42ba-b6e9-16504e29612e.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-83.jpeg)

在迁移的过程中，使用ping虚拟机的ip，发现只丢了一个包

![1566204899426-e4a475a9-2046-481a-9673-d5ea4eb51609.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-84.jpeg)

 

至此热迁移完成！

 

 

 

 

 

 

作业3：扩展研究EXSI虚拟化和EXSI iso到kvm的虚拟机迁移  |这个可以写成一个项目

http://blog.51cto.com/liqingbiao/1742724

<font style="color:green;"> </font>

<font style="color:green;">#</font><font style="color:green;">先将</font><font style="color:green;">exsi</font><font style="color:green;">虚拟机导出</font><font style="color:green;">ova</font><font style="color:green;">文件 , 然后倒入</font><font style="color:green;">kvm</font><font style="color:green;">虚拟机</font>

<font style="color:green;">[root@kvm01 opt]# yum install virt-v2v –y      //</font><font style="color:green;">阿里云基础源有个软件包下载</font>

#运行下面命令转换成 kvm虚拟机文件

virt-v2v -i ova openstack.ova -o local -os /opt/test  -of qcow2

![1566204899499-9940ed10-eee3-47ff-abee-a5a7fa64680b.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-85.jpeg)

 

报错 less /var/log/message   启动libvirtd 报错

![1566204899594-86687303-9994-4c7f-ae83-3175dc949acb.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-86.jpeg)

 

重存从一台好的libvirtd 里scp这个文件过来就好了

![1566204899668-42707836-53b5-48aa-af8f-bffbc8e0edc1.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-87.jpeg)

[root@kvm02 ~]# scp -rp /usr/lib64/libvirt/storage-backend/libvirt_storage_backend_rbd.so  root@10.0.0.11:/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_rbd.so

root@10.0.0.11's password:

libvirt_storage_backend_rbd.so                                                 100%   31KB  20.0MB/s   00:00

 

 

转换完成  查看文件类型 , 文件名修改成不要带中文的

 

![1566204899738-f1aaa679-8ba2-431e-81ce-a4e6199507d9.jpeg](img/day91-92%E4%BA%91%E8%AE%A1%E7%AE%97kvm%E8%99%9A%E6%8B%9F%E5%8C%96%E8%AE%B0%E5%BD%95-88.jpeg)

 

 

#从新生成配置文件启动

virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name openstack --memory 1024,maxmemory=2048  --vcpus 1,maxvcpus=8 --disk /opt/test/openstack.qcow2 --boot hd --network bridge=br0 --graphics vnc,listen=0.0.0.0 --noautoconsole

 

启动之后 vnc 连接上不了网, 查看网卡配置文件是 10.0.0.11 地址 ,这个地址被占用了, 手动改成10.0.0.130

重启网络 systemctl restart network   就可以了

参考

https://www.cnblogs.com/clsn/p/8510670.html

 

 

 

 

 

 

 

作业4：p2v迁移（物理机到kvm虚拟机的迁移）

[http://blog.csdn.net/tantexian/article/details/42869179](http://blog.csdn.net/tantexian/article/details/42869179)

 

 

老古董: 发热量大,配置低 2G ddr 400MHZ 750w

老古董: 发热量大,配置低 2G ddr 400MHZ 750w

.......

一台新集群  64G ddr4  2400MHZ   550w

 

iso镜像 , U盘启动盘  PE

打包所有根目录文件, 上传到kvm服务器, 输出一个qcow2 格式, 替换驱动,



> 更新: 2022-01-19 15:32:34  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/fl39lk>