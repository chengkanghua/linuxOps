# linux发行版本 安装





# [](#imzcwf)Linux发展史
1诞生 于1969年在贝尔实验室开发UNIX操作系统，，于1969年在贝尔实验室开发

2 人： 谭宁邦 --1984年因为UNIX规定‘不能对学生提供源码’谭宁邦老师自己编写兼容与UNIX的Minix用于教学

3 人：斯托曼 <font style="color:#333333;">1984 年，Stallman 开始 GNU（GNU's Not Unix）项目，创办 FSF（基金会；</font>

<font style="color:#333333;">（产品：GCC、Emacs、Bash Shell、GLIBC； 倡导“自由软件”； </font>

4 人: 托瓦兹 --1991年，芬兰赫尔辛基大学的研究生托瓦斯基于gcc、bash开发针对368机器的Linux内核

# [](#il5lwt)Linux系统的组成
## [](#llwuyp)操作系统就是人硬件之前的中介、桥梁


![1546417158326-e056ca3f-470a-43d0-856e-ce25514a7893-image2.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-01.png)

#### Linux=Linux内核+命令解释器shell+程序软件
# [](#a85yzw)Linux不同发行版本的区别：
Ubuntu  乌班图 开发人员      

RedHat  红帽   国企 金融

     Red Hat Linux  9.0

     Red Hat Enterprise Linux 红帽企业版  RHEL  7.5  

CentOS  国内最火爆

Fedora  redhat的测试版 新功能 新想法放入到Fedora 稳定

       Fedora ------>RedHat------>CentOS

       

Debian/FreeBSD  安全性要求比较高

SUSE/OpenSUSE   德国 高级数据库 邮件服务

红旗Linux  中标麒麟

# [](#7x44dr)CentOS与RedHat区别
1.Redhat 免费下载 项目收费 无法更新

2.CentOS 做到与红帽一模一样

 1）红帽收费项目去掉

 2）红帽logo去掉

# [](#dl2gzp)32位系统和64位系统的区别
**运算速度**

32位系统相当于4车道马路

64位系统相当于8车道马路

**设计定位  **

64位主要是给服务器使用 大量计算



从存储容量角度上来看：一个字的字长是32/64位，假设是32位，假设主存/高速缓存中有a个字块，一个字块有b个字，那么32位操作系统中的主存总容量就是32ab字节，64位操作系统就是64ab字节



从寻址角度上来看：指的是操作系统拥有的最大寻址能力。

如32位操作系统有32根地址总线，那么它的最大寻址能立就是2へ32=4G，所以它能读取的最大物理内存就是4G

当下随着计算机性能的迭代进化，64位操作系统已成为主流，我们编程使用的电脑大多都是64位的操作系统，32位操作系统越来越少了。







# [](#pt80xe)Linux发行的不同版本（常见Linux系统）
  Ubuntu  （乌班图）一般都是开发人员使用 有操作界面 有点像Windows

  Redhat   （红帽） 一般国企、金融使用 收费

  Centos     国内使用最多 免费

  Fedora      红帽的测试版

  Debian/freebsd  类似Unix安全性要求高的 使用

  SUSE/OPENSUSE   德国使用最多 因为是德国开发的

  麒麟Linux（中标麒麟）/红旗Linux     国企使用

# [](#5lv8fs)Centos下载地址
国内镜像站 [https://developer.aliyun.com/mirror/](https://developer.aliyun.com/mirror/)

centos7  iso 最新版

[https://mirrors.aliyun.com/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2207-02.iso](https://mirrors.aliyun.com/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2207-02.iso)

Centos官网 [https://vault.centos.org/](https://vault.centos.org/)   



vmware workstation 官网

众所周知，现在VMware被博通（broadcom）收购且宣布了17.5版本的VMware Workstation Pro对个人用户免费许可使用

<font style="color:rgb(85, 86, 102);">需要有一个博通的账号。博主使用QQ邮箱注册成功，没什么问题。</font>

<font style="color:rgb(85, 86, 102);">下载的时候需要输入地址等其他信息必填项什么的，可随便填即可，这个没有影响。</font>

[https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro](https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware%20Workstation%20Pro)



# [](#bqy1wx)学习环境
虚拟机软件： VMware Workstation 12.0/8.0

计算机要求配置 I5 处理器 8G内存 500G硬盘

# [](#qzdylr)Linux系统安装
## [](#9i45fz)创建虚拟机着重注意的几个地方
### [](#ky49ar)（1）注意安装过程中选择稍后安装
![1546417158347-ae072dae-b682-449d-8168-3dc311a3e429-image3.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-02.png)

![1546417158367-97dac204-b065-4444-bc71-354baf736bdd-image4.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-03.png)



![1546417158388-bad6ac02-b5ba-4e3f-90d6-f866c82c359d-image5.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-04.png)

### [](#xgg5yq)（2）注意最后一步创建虚拟机保存的位置，一般不放在C盘
## [](#ygdalc)	安装CentOS系统过程注意的几个地方
### [](#g4visb)第一个注意系统镜像挂载的位置和启动时连接对勾要勾上
![1546417158406-c1b785a7-6a2f-40ff-ad6e-0d70eaa0a964-image6.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-05.png)

### [](#x25fvl)安装过程注意时间问题
   UTO 选项的对勾记得要去掉  不然会和计算机有时差

### [](#r7lmys)安装分区注意事项
/boot  引导分区  200M

swap   交换分区 内存不足的时候 临时把swap当做内存使用  # 生产环境中内存(现在内存也便宜)都很大 swap不设置

      内存<8G   swap是内存的1.5倍

      内存>=8G swap 就是8G

/      根分区    所有程序软件 存放的位置

      剩余多少给多少

### [](#fe5dce)安装好后配置网络
主要用到 setup 命令后 一个图形界面的配置eth0网卡 注意dhcp要关掉 On boot 要记得启动





![1546417158431-b45919ad-caa8-40ed-8bed-9340102e59c6-image7.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-06.png)





![1546417158457-13f8ec33-3c9e-4ed0-826f-88ac21ec4469-image8.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-07.png)



![1546417158492-708d2cfb-289e-4d52-b4e5-fc3b1b95be01-image9.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-08.png)

![1546417158522-26fb59bb-35e0-4c48-9e00-27b1c1e24fd6-image10.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-09.png)



![1546417158559-bc26a2a9-7815-468c-bfb4-dfe2d799ea80-image11.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-10.png)



看不到next  使用快捷键F12	



![1546417158585-9dd23609-e9a0-49d8-8f56-aa7c3934ed06-image12.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-11.png)

![1546417158609-a7af3267-989c-469e-92c3-051730aeacb4-image13.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-12.png)

	![1546417158635-84a83a83-b33f-4d45-8980-71140374e0ee-image14.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-13.png)

![1546417158655-ff29ae25-bc04-439a-8baf-354cafb13eba-image15.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-14.png)



![1546417158680-e33e04d4-3760-4f79-a67e-5702171a3cfc-image16.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-15.png) ![1546417158705-1e1c0e0c-1d3c-4867-8018-fffe2de08087-image17.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-16.png)

![1546417158733-941a13e4-d93d-4e3c-8fbb-38ce81f3a694-image18.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-17.png)



	![1546417158761-e9c4ac47-5ff7-4d0c-9085-705e63fc20c0-image19.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-18.png)

	![1546417158792-78e7ec46-bf3f-485b-b2ea-2823fb9bcc03-image20.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-19.png)





	![1546417158816-0c250ccc-7836-4ff3-8447-2e89176b1002-image21.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-20.png)

	![1546417158844-1895f0af-2575-4187-ae8b-a86e0878d327-image22.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-21.png)



![1546417158871-56576c07-5a21-43b7-a825-66d92162b57b-image23.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-22.png)



	![1546417158894-eb76ca03-c5ee-47c1-8ecf-264b705b3ab6-image24.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-23.png)



	![1546417158924-d7b7efaf-1048-4b73-983e-bf341582b3c1-image25.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-24.png)



# Linux下面磁盘区分区
**适用于数据不重要**

/boot 引导分区 200M (centos 7 1G)

swap  交换分区 <8G  1.5G

              >=8G  8G

/     根分区   剩余所有





**适于数据重要**

/boot 引导分区 200M (centos 7 1G)

swap  交换分区 <8G  1.5G

              >=8G  8G

/     根分区   20-200G

/data 数据分区 剩余所有（当系统出问题的时候date区的文件不会丢失）



**适于不知道里面文件重不重要**

/boot 引导分区 200M (centos 7 1G)

swap  交换分区 <8G  1.5G

              >=8G  8G

/     根分区   20-200G

剩余的不分配  留着 谁使用谁分配



# 网络配置
![1546417158953-3db1ee87-b657-46ce-b69e-5265c831d5a7-image26.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-25.png)

![1546417158997-cfb9c72f-afe2-4760-b593-81a5ed6410ea-image27.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-26.png)



vmnet8 地址应该是上面的 10.0.0.254

![1546417159052-34142e18-32f6-462c-9006-65bf3e4085ec-image29.png](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-27.png)



# linux服务器无法上网排查过程
1.ip是否正确

2.网卡配置文件 是否正确

网关配置错误

DNS

3.编辑--->虚拟网络编辑器---> NAT模式 ---->子网ip 10.0.0.0

NAT设置:--->网关IP:10.0.0.254



4.vmware服务

win+r 输入 services.msc



VMware Authorization Service    正在运行/已启动         自动

VMware NAT Service              正在运行/已启动      自动

VMware DHCP Service             正在运行/已启动      自动



1 重启NAT service  

2 端口虚拟机网卡  再连接上

3 linux系统里重启网络   systemctl restart network















# VMare网络模式
### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">一、桥接模式（Bridged，VMnet0）</font>
**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心原理</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：虚拟机虚拟网卡直接 “桥接” 到主机物理网卡（有线 / 无线），</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">相当于局域网里一台独立的真实电脑</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，和主机平级、同网段。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">二、NAT 模式（Network Address Translation，VMnet8）—— 最常用默认</font>
**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心原理</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：VMware 内置虚拟 NAT 路由器 + DHCP，虚拟机在</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">私有虚拟子网</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">共享主机的物理 IP 上网</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，外部看不到虚拟机真实 IP。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 三  仅主机模式（Host-Only，VMnet1）—— 封闭隔离</font>
**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心原理</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：仅创建</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">纯内部虚拟网络</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，无 NAT、无外网出口，虚拟机只能和主机、同 Host-Only 的虚拟机通信，完全隔离物理网络与外网。</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>

# <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">centos 6.9修改系统默认字符集</font>


```bash
centos 6.9修改系统默认字符集

# locale –a   #列出系统所支持的所有字符集

yum -y groupinstall chinese-support    安装中文支持包

修改方法： 
		1 export LANG=zh_CN.UTF8   #临时修改
		2 vim /etc/sysconfig/i18n   
			LANG=”zh_CN.UTF8”     					#永久修改文件
		source /etc/sysconfig/i18n     # 生效配置文件


# centos7 修改方法
cp /etc/locale.conf  /etc/local.conf.bak
echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf
source /etc/locale.conf

    

```





> 更新: 2026-04-24 14:13:31  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/dossrq>