# Python基础21-网络编程

## Python基础21-网络编程

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(34) 评论(0)

* [网络编程介绍](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_0)
* [互联网协议介绍](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_1)
* [Socket（套接字）发展史及分类](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_2)
* [套接字工作流程](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_3)
* [基于TCP协议通信的套接字程序（简单版）](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_4)
* [通讯循环](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_5)
* [链接循环](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_6)
* [套接字通信底层原理](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_7)
* [小练习模拟ssh远程执行命令](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_8)
* [粘包问题](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_9)
* [小练习FTP](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_10)
* [基于udp协议的套接字](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_11)
* [实现并发](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_12)
* [源码分析总结：](https://blog.driverzeng.com/zenglaoshi/5394.html#toc_13)

>  
>
> -曾老湿, 江湖人称曾老大。
>
> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023

***

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1\)整合了各个公有云API，自主创建云主机。
>
> 2\)ELK自动化收集日志功能。
>
> 3\)Saltstack自动化运维统一配置管理工具。
>
> 4\)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5\)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6\)SQL执行及审批流程。
>
> 7\)慢查询日志分析web界面。

***

## 网络编程介绍

***

| 学习网络编程目标 |
| :--- |

**目标:编写一个C/S架构的软件**

C/S: Client--------基于网络----------Server

B/S: Browser-------基于网络----------Server

1.硬件C/S架构(打印机)

2.软件C/S架构

互联网中处处是C/S架构

如黄色网站是服务端，你的浏览器是客户端（B/S架构也是C/S架构的一种）

腾讯作为服务端为你提供视频，你得下个腾讯视频客户端才能看它的视频）

**C/S架构与socket的关系：**

我们学习socket就是为了完成C/S架构的开发

**服务端需要遵循的原则:**

1.服务端与客户端都需要有唯一的地址,但是服务端的地址必须固定/绑定

2.对外一直提供服务,稳定运行

3.服务端应该支持并发

**网络建立的目的**

首先，不是为了网恋

网络建立的目的是为数据交互(通信)

如何实现通信:

1.建立好底层的物理连接介质

2.有一套统一的通信标准,称之为互联网协议

## 互联网协议介绍

互联网协议:就是计算机界的英语

**OSI七层协议**

ip+mac可以标识全世界范围内独一无二的一台计算机的位置

port可以标识一台计算机之上唯一的一个基于网络通信的应用软件

ip+mac+port:可以标识全世界范围内独一无二的一个应用软件(基于网络通信)

引子：

须知一个完整的计算机系统是由硬件、操作系统、应用软件三者组成,具备了这三个条件，一台计算机系统就可以自己跟自己玩了（打个单机游戏，玩个扫雷啥的）

如果你要跟别人一起玩，那你就需要上网了，什么是互联网？

互联网的核心就是由一堆协议组成，协议就是标准，比如全世界人通信的标准是英语

如果把计算机比作人，互联网协议就是计算机界的英语。所有的计算机都学会了互联网协议，那所有的计算机都就可以按照统一的标准去收发信息从而完成通信了。

人们按照分工不同把互联网协议从逻辑上划分了层级，

<!-- OCR_START -->
- 应用层
- 表示层
- 会话层
- 传输层
- 网络层
- 数据链路层
- 曾老湿
- DriverZeng
- 物理层
<!-- OCR_END -->

￼

为何学习socket一定要先学习互联网协议：

1.首先：本节课程的目标就是教会你如何基于socket编程，来开发一款自己的C/S架构软件

2.其次：C/S架构的软件（软件属于应用层）是基于网络进行通信的

3.然后：网络的核心即一堆协议，协议即标准，你想开发一款基于网络通信的软件，就必须遵循这些标准。

4.最后：就让我们从这些标准开始研究，开启我们的socket编程之旅

**每层运行常见物理设备**

<!-- OCR_START -->
- 传输层
- 四层交换机、
- 四层的路由器
- 网络层
- 路由器、三层交换机
- 数据链路层
- 网桥、以太网交换机、网卡
- 物理层
- 中继器、集线器、双绞线
<!-- OCR_END -->

￼

**以太网封装过程**



<!-- OCR_START -->
> 以太网封装过程
> PC1
> PC2
<!-- OCR_END -->

￼

***

| 数据链路层 |
| :--- |

数据链路层由来：单纯的电信号0和1没有任何意义，必须规定电信号多少位一组，每组什么意思

数据链路层的功能：定义了电信号的分组方式

**以太网协议：**

早期的时候各个公司都有自己的分组方式，后来形成了统一的标准，即以太网协议ethernet

ethernet规定：

1.要有一块网卡，网卡上要有一个独一无二的地址（mac地址）

2.一组电信号构成一个数据包，叫做‘帧’

3.每一数据帧分成：报头head和数据data两部分

| head | data |
| :--- | :--- |

**head包含：(固定18个字节)**

发送者／源地址，6个字节

接收者／目标地址，6个字节

数据类型，6个字节

data包含：(最短46字节，最长1500字节)

数据包的具体内容

head长度＋data长度＝最短64字节，最长1518字节，超过最大限制就分片发送

**mac地址：**

head中包含的源和目标地址由来：ethernet规定接入internet的设备都必须具备网卡，发送端和接收端的地址便是指网卡的地址，即mac地址

mac地址：每块网卡出厂时都被烧制上一个世界唯一的mac地址，长度为48位2进制，通常由12位16进制数表示（前六位是厂商编号，后六位是流水线号）

<!-- OCR_START -->
MacBook-pro:~driverzeng$ifconfigeno
en0:LagS=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST>mtu1500
ether
f0:18:98:2a:78:eb
inet6fe80::be:4545:a512:27de%en0prefixlen64securedscopeid0xa
inet192.168.101.105netmask0xffffff00broadcast192.168.101.255
nd6optionS=201<PERFORMNUD,DAD>
media:autoselect
status:active
driverzeng$
曾老湿
<!-- OCR_END -->

￼

计算机通讯基本靠吼。

**广播：**

有了mac地址，同一网络内的两台主机就可以通信了（一台主机通过arp协议获取另外一台主机的mac地址）

ethernet采用最原始的方式，广播的方式进行通信，即计算机通信基本靠吼

<!-- OCR_START -->
- IEEE802.1Q
- 2Bytes+2Bytes+
- 目标
- 发送源
- TPID
- TCI
- 数据部分
- CRC
- MAC地址
- 6Bytes+
- 2Bytes+
- 46~1500Bytes
- 4Bytes+
- 0x8100+
- 内含12bit的
- CRC经过重
- VLAN标识
- 新计算
- pc1按照上图格式以广播的方式发送以太网包给pc4，然而pc2，pc3，pc5都会收到，大家都收到
- pc1发来的包，拆开后发现目标mac如果不是自己就丢弃，如果是自已就响应
- pc1
- pc2
- pc3
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

故障：广播风暴...

***

| 网络层 |
| :--- |

网络层由来：有了ethernet、mac地址、广播的发送方式，世界上的计算机就可以彼此通信了，问题是世界范围的互联网是由

一个个彼此隔离的小的局域网组成的，那么如果所有的通信都采用以太网的广播方式，那么一台机器发送的包全世界都会收到，

这就不仅仅是效率低的问题了，这会是一种灾难

<!-- OCR_START -->
- 世界大网络由一个个小的彼此隔离的局域网组成
- 以太网包只能在一个局域网内发送，一个局域网是一个广播域
- 以太网的广播包只能在一个广播域内发送
- 跨广播域通信只能通过路由转发
- internet
- 隔离的局域网1
- 隔离的局域网3
- 隔离的局域网2
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

上图结论：必须找出一种方法来区分哪些计算机属于同一广播域，哪些不是，如果是就采用广播的方式发送，如果不是，

就采用路由的方式（向不同广播域／子网分发数据包），mac地址是无法区分的，它只跟厂商有关

网络层功能：引入一套新的地址用来区分不同的广播域／子网，这套地址即网络地址

```plain
# IP协议：
规定网络地址的协议叫ip协议，它定义的地址称之为ip地址，广泛采用的v4版本即ipv4，它规定网络地址由32位2进制表示
范围0.0.0.0-255.255.255.255
一个ip地址通常写成四段十进制数，例：172.16.10.1
# ip地址分成两部分（点分十进制）
网络部分：标识子网
主机部分：标识主机
注意：单纯的ip地址段只是标识了ip地址的种类，从网络部分或主机部分都无法辨识一个ip所处的子网
例：172.16.10.1与172.16.10.2并不能确定二者处于同一子网
# 子网掩码
所谓”子网掩码”，就是表示子网络特征的一个参数。它在形式上等同于IP地址，也是一个32位二进制数字，它的网络部分全部为1，主机部分全部为0。比如，IP地址172.16.10.1，如果已知网络部分是前24位，主机部分是后8位，那么子网络掩码就是11111111.11111111.11111111.00000000，写成十进制就是255.255.255.0。
 
知道”子网掩码”，我们就能判断，任意两个IP地址是否处在同一个子网络。方法是将两个IP地址与子网掩码分别进行AND运算（两个数位都为1，运算结果为1，否则为0），然后比较结果是否相同，如果是的话，就表明它们在同一个子网络中，否则就不是。
 
比如，已知IP地址172.16.10.1和172.16.10.2的子网掩码都是255.255.255.0，请问它们是否在同一个子网络？两者与子网掩码分别进行AND运算，
172.16.10.1：10101100.00010000.00001010.000000001
255255.255.255.0:11111111.11111111.11111111.00000000
AND运算得网络地址结果：10101100.00010000.00001010.000000001->172.16.10.0
AND运算又叫做"按位与"运算，符号："&"，在编程术语中表示一种运算方法，不可逆
172.16.10.2：10101100.00010000.00001010.000000010
255255.255.255.0:11111111.11111111.11111111.00000000
AND运算得网络地址结果：10101100.00010000.00001010.000000001->172.16.10.0
结果都是172.16.10.0，因此它们在同一个子网络。
总结一下，IP协议的作用主要有两个，一个是为每一台计算机分配IP地址，另一个是确定哪些地址在同一个子网络
# ip数据包
ip数据包也分为head和data部分，无须为ip包定义单独的栏位，直接放入以太网包的data部分
head：长度为20到60字节
data：最长为65,515字节。
而以太网数据包的”数据”部分，最长只有1500字节。因此，如果IP数据包超过了1500字节，它就需要分割成几个以太网数据包，分开发送了。
```

| 以太网头 | IP头 | IP数据 |
| :--- | :--- | :--- |

```plain
# ARP协议（Address Resolution Protocol）
arp协议由来：计算机通信基本靠吼，即广播的方式，所有上层的包到最后都要封装上以太网头，然后通过以太网协议发送，在谈及以太网协议时候，我门了解到
通信是基于mac的广播方式实现，计算机在发包时，获取自身的mac是容易的，如何获取目标主机的mac，就需要通过arp协议
arp协议功能：广播的方式发送数据包，获取目标主机的mac地址
 
协议工作方式：每台主机ip都是已知的
例如：主机172.16.10.10/24访问172.16.10.11/24
```

1.首先通过ip地址和子网掩码区分出自己所处的子网

| 场景 | 数据包地址 |
| :--- | :--- |
| 同一子网 | 目标主机mac，目标主机ip |
| 不同子网 | 网关mac，目标主机ip |

2.分析172.16.10.10/24与172.16.10.11/24处于同一网络(如果不是同一网络，那么下表中目标ip为172.16.10.1,通过arp获取的是网关的mac)

| | 源mac | 目标mac | 源ip | 目标ip | 数据部分 |
| --- | :--- | :--- | :--- | :--- | :--- |
| 发送端主机 | 发送端mac | FF:FF:FF:FF:FF:FF | 172.16.10.10/24 | 172.16.10.10/24 | 数据 |

3.这个包会以广播的方式在发送端所处的自网内传输，所有主机接收后拆开包，发现目标ip为自己的，就响应，返回自己的mac

***

| 传输层 |
| :--- |

传输层的由来：网络层的ip帮我们区分子网，以太网层的mac帮我们找到主机，然后大家使用的都是应用程序，你的电脑上可能同时开启qq，暴风影音，等多个应用程序，

那么我们通过ip和mac找到了一台特定的主机，如何标识这台主机上的应用程序，答案就是端口，端口即应用程序与网卡关联的编号。

传输层功能：建立端口到端口的通信

补充：端口范围0-65535，0-1023为系统占用端口

**tcp协议：**

可靠传输，TCP数据包没有长度限制，理论上可以无限长，但是为了保证网络的效率，通常TCP数据包的长度不会超过IP数据包的长度，以确保单个TCP数据包不必再分割。

| 以太网头 | ip 头 | tcp头 | 数据 |
| :--- | :--- | :--- | :--- |

**udp协议：**

不可靠传输，”报头”部分一共只有8个字节，总长度不超过65,535字节，正好放进一个IP数据包。

| 以太网头 | ip头 | udp头 | 数据 |
| :--- | :--- | :--- | :--- |

**tcp报文**

<!-- OCR_START -->
- 32 bit
- 源端口
- 目的端口
- 序号
- TCP
- 确认号
- 20字节
- 首部
- 数据
- 保留
- 偏移
- 窗口
- 检验和
- 紧急指针
- 选项和填充
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 三次握手的过程：
- Client
- Server
- SYN_SENT
- SYNseq=x
- LISTEN
- (connect(）)
- SYN_RCVD
- SYNseq=y,ACK=x+1
- ESTABLISHED
- ACK=y+1
- (write())
- seq=x+1ACK=y+1
- (read())
- ACKx+2
- FINseq=x+2ACK=y+1
- FIN_WAIT_1
- (close())
- CLOSE_WAIT
- ACKx+3
- FIN_WAIT_2
- LAST_ACK
- FIN seq=y+1
- TIME_WAIT
- ACK=y+2
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**TCP 三次握手**



<!-- OCR_START -->
> Client
> Server
<!-- OCR_END -->

￼

好比在一个夜高风黑的夜晚，你一个人在小区里散步，不远处看见小区里的一位漂亮妹子迎面而来，但是因为路灯有点暗等原因不能100%确认，所以要通过招手的方式来确定对方是否认识自己。

你首先向妹子招手(syn)，妹子看到你向自己招手后，向你点了点头挤出了一个微笑(ack)。你看到妹子微笑后确认了妹子成功辨认出了自己(进入estalished状态)。

但是妹子有点不好意思，向四周看了一看，有没有可能你是在看别人呢，她也需要确认一下。妹子也向你招了招手(syn)，你看到妹子向自己招手后知道对方是在寻求自己的确认，于是也点了点头挤出了微笑(ack)，妹子看到对方的微笑后确认了你就是在向自己打招呼(进入established状态)。

于是两人加快步伐，走到了一起，彼此之间相互拥抱。

我们来回顾一下，这个过程中总共有四个动作：

1.你招手

2.妹子点头微笑

3.妹子招手

4.你点头微笑

**握手完成后，开始TCP数据传输**

TCP数据传输就是两个人"交流"，然后两个人就回到了家中，开始"交流"，但是啊，在交流的过程中不是一下子就交流完的，得反复"交流"，并且需要对方反复确认，证明她真的得到了点"什么东西"。

<!-- OCR_START -->
- Client
- Server
- established
<!-- OCR_END -->

￼

**TCP 四次挥手**

<!-- OCR_START -->
- Client
- Server
- established
<!-- OCR_END -->

￼

第二天早上啊，妹子意犹未尽，卧槽？？？意犹未尽什么鬼（可能是没有听够你讲的故事还是啥的...），你反正是有点扛不住了（可能是聊了一晚上天？有点口干了？）。

于是乎你就跟妹子提出了分手，提完分手之后，你还没有起(tí)身(shàng)就(kù)走(zi)，你在等妹子给你回复。妹子接收到你的消息之后，脸色大变，然后妹子就说，你先等会，我跟你算算账。算完账之后，跟你说，昨晚1000块，不给我就跟你老婆说，那你能怎么办？认栽呗，给她1000，然后走人。

于是乎经历过四次挥手之后，就断开连接了，但是要记住，不是立马就断开连接，因为你是个渣男，所以你要付出代价，这个后果就是持续4分钟的time_wait状态，不能释放套接字资源（端口），这段时间内套接字资源（端口）不得回收利用。

回顾一下，还是四个动作：

1.你提出分手

2.妹子跟你算账

3.算完账告诉你

4.你给钱

完成四次挥手之后，你还得进入time_wait的状态，付出这个惨痛的代价。

**TCP协议的11种状态**

三次握手中：

1.SYN_SENT

2.LISTEN

3.SYN_REVD（syn洪水攻击）\*\*\*\*半连接池

4.ESTABLISHED

四次挥手中：

1.FIN_WAIT_1

2.CLOSE_WAIT

3.FIN_WAIT_2

4.LAST_ACK

5.TIME_WAIT（TIME_WAIT多，证明服务器上有大并发）

关闭状态：

1.CLOSED（被动关闭端在接收到ack包后，进入CLOSED状态关闭TCP连接）

2.CLOSING（客户端和服务端同时发起断开连接）

***

| 会话层 |
| :--- |

**会话层主要三大功能**：

1.建立会话：A、B两台网络设备之间要通信，要建立一条会话供他们使用，在建立会话的过程中也会有身份验证，权限鉴定等环节；

2.保持会话：通信会话建立后，通信双方开始传递数据，当数据传递完成后，OSI会话层不一定会立刻将两者这条通信会话断开，它会根据应用程序和应用层的设置对该会话进行维护，在会话维持期间两者可以随时使用这条会话传输局；

3.断开会话：当应用程序或应用层规定的超时时间到期后，OSI会话层才会释放这条会话。或者A、B重启、关机、手动执行断开连接的操作时，OSI会话层也会将A、B之间的会话断开。

***

| 表示层 |
| :--- |

**表示层主要三大功能：**

1.内码转换

2.压缩与解压缩

3.加密与解密。

***

| 应用层 |
| :--- |

应用层由来：用户使用的都是应用程序，均工作于应用层，互联网是开发的，大家都可以开发自己的应用程序，数据多种多样，必须规定好数据的组织形式

应用层功能：规定应用程序的数据格式。

例：TCP协议可以为各种各样的程序传递数据，比如Email、WWW、FTP等等。那么，必须有不同协议规定电子邮件、网页、FTP数据的格式，这些应用程序协议就构成了”应用层”。

***

| socket |
| :--- |

Socket是应用层与TCP/IP协议族通信的中间软件抽象层，它是一组接口。在设计模式中，Socket其实就是一个门面模式，它把复杂的TCP/IP协议族隐藏在Socket接口后面，对用户来说，一组简单的接口就是全部，让Socket去组织数据，以符合指定的协议。

所以，我们无需深入理解tcp/udp协议，socket已经为我们封装好了，我们只需要遵循socket的规定去编程，写出的程序自然就是遵循tcp/udp标准的。

我们知道两个进程如果需要进行通讯最基本的一个前提能能够唯一的标示一个进程，在本地进程通讯中我们可以使用PID来唯一标示一个进程，但PID只在本地唯一，网络中的两个进程PID冲突几率很大，这时候我们需要另辟它径了，我们知道IP层的ip地址可以唯一标示主机，而TCP层协议和端口号可以唯一标示主机的一个进程，这样我们可以利用ip地址＋协议＋端口号唯一标示网络中的一个进程。

能够唯一标示网络中的进程后，它们就可以利用socket进行通信了，什么是socket呢？我们经常把socket翻译为套接字，socket是在应用层和传输层之间的一个抽象层，它把TCP/IP层复杂的操作抽象为几个简单的接口供应用层调用已实现进程在网络中通信。

<!-- OCR_START -->
- 用户
- 进程
- 应用层
- Socket抽象层
- 运输层
- TCP
- UDP
- ICMP
- IP
- IGMP
- 网络层
- ARP
- 硬件
- RARP
- 链路层
- 接口
- 曾老湿
- DriverZeng
- 媒体
<!-- OCR_END -->

￼

socket起源于UNIX，在Unix一切皆文件哲学的思想下，socket是一种"打开—读/写—关闭"模式的实现，服务器和客户端各自维护一个"文件"，在建立连接打开后，可以向自己文件写入内容供对方读取或者读取对方内容，通讯结束时关闭文件。

***

| 总结 |
| :--- |

<!-- OCR_START -->
- Socket客户端：浏览器
- Socket服务端：web服务
- ...
- 应用层
- HTTP通信
- 传输层
- TCP链接
- 网络层
- 数据链路层
- 物理层
- 曾老湿
- internet
- DriverZeng
<!-- OCR_END -->

￼

**数据传输动图如下：**

<!-- OCR_START -->
- PLAY
- 数据在各层之间的传递过程
- 计算机1
- 计算机2
<!-- OCR_END -->

￼

\*\*最终可以理解为：\*\*快递 发快递 拆快递

## Socket（套接字）发展史及分类

套接字起源于 20 世纪 70 年代加利福尼亚大学伯克利分校版本的 Unix,即人们所说的 BSD Unix。 因此,有时人们也把套接字称为“伯克利套接字”或“BSD 套接字”。一开始,套接字被设计用在同 一台主机上多个应用程序之间的通讯。这也被称进程间通讯,或 IPC。套接字有两种（或者称为有两个种族）,分别是基于文件型的和基于网络型的。

***

| 基于文件类型的套接字家族 |
| :--- |

套接字家族的名字：AF_UNIX

unix一切皆文件，基于文件的套接字调用的就是底层的文件系统来取数据，两个套接字进程运行在同一机器，可以通过访问同一个文件系统间接完成通信

***

| 基于网络类型的套接字家族 |
| :--- |

套接字家族的名字：AF_INET

(还有AF_INET6被用于ipv6，还有一些其他的地址家族，不过，他们要么是只用于某个平台，要么就是已经被废弃，或者是很少被使用，或者是根本没有实现，所有地址家族中，AF_INET是使用最广泛的一个，python支持很多种地址家族，但是由于我们只关心网络编程，所以大部分时候我么只使用AF_INET)

## 套接字工作流程

一个生活中的场景。你要打电话给一个朋友，先拨号，朋友听到电话铃声后提起电话，这时你和你的朋友就建立起了连接，就可以讲话了。等交流结束，挂断电话结束此次交谈。 生活中的场景就解释了这工作原理。

<!-- OCR_START -->
- TCP服务器端
- socket
- TCP客户端
- bindO
- listenO
- accept)
- connect)
- 建立连接
- 阻塞直到有客户端连接
- 请求数据
- write
- read)
- 处理请求
- 回应数据
- reado
- 结束连接
- 曾老湿
- Driver Zeng
- close)
<!-- OCR_END -->

￼

先从服务器端说起。服务器端先初始化Socket，然后与端口绑定(bind)，对端口进行监听(listen)，调用accept阻塞，等待客户端连接。在这时如果有个客户端初始化一个Socket，然后连接服务器(connect)，如果连接成功，这时客户端与服务器端的连接就建立了。客户端发送数据请求，服务器端接收请求并处理请求，然后把回应数据发送给客户端，客户端读取数据，最后关闭连接，一次交互结束

## 基于TCP协议通信的套接字程序（简单版）

***

| socket模块函数 |
| :--- |

```plain
服务端套接字函数
s.bind()    绑定(主机,端口号)到套接字
s.listen()  开始TCP监听
s.accept()  被动接受TCP客户的连接,(阻塞式)等待连接的到来
客户端套接字函数
s.connect()     主动初始化TCP服务器连接
s.connect_ex()  connect()函数的扩展版本,出错时返回出错码,而不是抛出异常
公共用途的套接字函数
s.recv()            接收TCP数据
s.send()            发送TCP数据(send在待发送数据量大于己端缓存区剩余空间时,数据丢失,不会发完)
s.sendall()         发送完整的TCP数据(本质就是循环调用send,sendall在待发送数据量大于己端缓存区剩余空间时,数据不丢失,循环调用send直到发完)
s.recvfrom()        接收UDP数据
s.sendto()          发送UDP数据
s.getpeername()     连接到当前套接字的远端的地址
s.getsockname()     当前套接字的地址
s.getsockopt()      返回指定套接字的参数
s.setsockopt()      设置指定套接字的参数
s.close()           关闭套接字
面向锁的套接字方法
s.setblocking()     设置套接字的阻塞与非阻塞模式
s.settimeout()      设置阻塞套接字操作的超时时间
s.gettimeout()      得到阻塞套接字操作的超时时间
面向文件的套接字的函数
s.fileno()          套接字的文件描述符
s.makefile()        创建一个与该套接字相关的文件
```

***

| 服务端使用socket模块 |
| :--- |

我们来写一个程序，不会写的话，就想一想打电话的过程

```plain
## 服务端
import socket
# 1.买手机
phone=socket.socket(socket.AF_INET,socket.SOCK_STREAM)  #SOCK_STREAM 就是 TCP 协议，TCP协议又叫流式协议。。SOCK_DGRAM是udp协议
print(phone)
```

<!-- OCR_START -->
服务端.pyx
import socket
#1.买手机
phone=socket.socket(socket.AF_INET,socket.SoCK_STREAM)
#SOCK STREAM 就是TCP 协议，
TCP协议文叫流式协议
SOCKDGRAM是udp协议
print(phone)
Run:
服务端×
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/服务端.py
<socket.socket fd=3,family=AddressFamily.AF_INET,type=SocketKind.SocK_STREAM,proto=0,laddr=('0.0.0.0',0)>
曾老湿
rocess finished with exit code 0
Driver Zeng
<!-- OCR_END -->

￼

**插入手机卡**

```plain
import socket
# 1.买手机
phone=socket.socket(socket.AF_INET,socket.SOCK_STREAM)  #SOCK_STREAM 就是 TCP 协议，TCP协议又叫流式协议。。SOCK_DGRAM是udp协议
print(phone)
# 2.插手机卡
phone.bind(('127.0.0.1',3306))
```

**开机**

```plain
import socket
# 1.买手机
phone=socket.socket(socket.AF_INET,socket.SOCK_STREAM)  #SOCK_STREAM 就是 TCP 协议，TCP协议又叫流式协议。。SOCK_DGRAM是udp协议
print(phone)
# 2.插手机卡
phone.bind(('127.0.0.1',3306))
# 3.开机(半连接池，最大请求数为5)
phone.listen(5)
```

**等待电话请求**

```plain
import socket
# 1.买手机
phone=socket.socket(socket.AF_INET,socket.SOCK_STREAM)  #SOCK_STREAM 就是 TCP 协议，TCP协议又叫流式协议。。SOCK_DGRAM是udp协议
# 2.插手机卡
phone.bind(('127.0.0.1',3306))
# 3.开机(半连接池，最大请求数为5)
phone.listen(5)
# 4.等待电话请求
conn,client_addr=phone.accept()#套接字对象(返回元组的双向链接套接字对象，存放客户端ip和端口的小元组)
print(conn)
print(client_addr)
```

**启动服务端**

***

| 客户端使用socket模块 |
| :--- |

同样，客户端需要有个手机，emmm...不过客户端的手机不用插手机卡，那就座机吧

```plain
import socket
# 1.买手机
phone=socket.socket(socket.AF_INET,socket.SOCK_STREAM)  #SOCK_STREAM 就是 TCP 协议，TCP协议又叫流式协议。。SOCK_DGRAM是udp协议
# 2.打电话
phone.connect(('127.0.0.1',3306))
```

**运行客户端，服务端显示结果如下：**

<!-- OCR_START -->
| 排名 | 名称 | 名称 | 名称 | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| PYTHON[~/DeSktop/PYTHON]- | /服务端.py[PYTHON] | PYTHON | 服务端.py | 服务端.py | 客户端.pyx |
| import socket | #1.买手机 | phone=socket.socket(socket.AF_INETsocket.SOCK_STREAM) | #SOCK_STREAM就是TCP协议TCP协议又叫流式协议。SOCKDGRAM是udp协议 | #2.插手机卡 | phone.bind（（'127.0.0.1'3306)) |
| 8 | 9 | #3.开机（半连接池，最大请求数为5） | 10 | phone.listen(5) | 11 |
| 12 | #4.等待电话请求 | 13 | conn,client_addr=phone.accept() | 14 | print（conn) |
| 15 | print(client_addr) | Run: | 服务端× | 客户端 | /Users/driverzeng/PvcharmProiects/untitled1/venv/bin/pvthon/Users/driverzeng/Desktop/PYTHoN/服务端.py |
<!-- OCR_END -->

￼

***

| 服务端收发消息 |
| :--- |

```plain
import socket
# 1.买手机
phone=socket.socket(socket.AF_INET,socket.SOCK_STREAM)  #SOCK_STREAM 就是 TCP 协议，TCP协议又叫流式协议。。SOCK_DGRAM是udp协议
# 2.插手机卡
phone.bind(('127.0.0.1',3306))
# 3.开机(半连接池，最大请求数为5)
phone.listen(5)
# 4.等待电话请求
conn,client_addr=phone.accept()
print(conn)
print(client_addr)
# 5.收\发消息
data=conn.recv(1024) #1024接收的最大字节数
print('收到客户的数据：',data)
conn.send(data.upper()) #收到数据之后，回消息给客户端
# 6.挂电话，断开链接
conn.close()
# 7.再次回收资源：关机
phone.close()
```

**注意：1024在这里面是一个坑，如果客户端发送超过1024的字节数那就凉了。**

***

| 客户端发\收消息 |
| :--- |

```plain
import socket
# 1.买手机
phone=socket.socket(socket.AF_INET,socket.SOCK_STREAM)  #SOCK_STREAM 就是 TCP 协议，TCP协议又叫流式协议。。SOCK_DGRAM是udp协议
# 2.打电话
phone.connect(('127.0.0.1',3306))
# 3.发\收消息
phone.send('hello'.encode('utf-8')) # 只能发送bytes类型
data=phone.recv(1024)
print('收到服务端的消息：',data)
# 4.挂电话(断开链接)
phone.close()
```

**服务端：**

<!-- OCR_START -->
| PYTHON[~/DeSktop/PYTHON]-../服务端.py[PYTHON] | 排名 | PYTHON[~/DeSktop/PYTHON]-../服务端.py[PYTHON] | 排名(上年) | PYTHON[~/DeSktop/PYTHON]-../服务端.py[PYTHON] |
| --- | --- | --- | --- | --- |
| #1.买手机 | 3 | phone=Socket.Socket（socket.AF_INETsocket.SOCK_STREAM）#SOCKSTREAM 就是TCP协议，TCP协议又叫流式协议。SOCK DGRAM是udp协议 | 6 | #2.插手机卡 |
| phone.bind(('127.0.0.13306)) | 8 | #3.开机（半连接池，最大请求数为5） | 9 | 10 |
| phone.listen（5) | 11 | 12 | #4.等待电话请求 | 13 |
| connclient_addr=phone.accept() | 14 | print（conn) | 15 | print(client_addr) |
| 16 | 17 | #5.收\发消息 | 18 | data=conn.recv（1024）#1024接收的最大字节数 |
| 19 | print（收到客户的数据： | data) | 20 | conn.send（data.upper（））#收到数据之后回消息给客户端 |
| 21 | Run: | 服务端× | 客户端X | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/服务端.py |
| <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.S0CK_STREAM, proto=0,laddr=('127.0.0.1',3306),raddr=('127.0.0.1',62336)> | (127001.62336) | 收到客户的数据：b'hello | Processfinishedwithexitcodeo | 曾老湿 |
<!-- OCR_END -->

￼

**客户端：**

<!-- OCR_START -->
| PYTHON[~/DeSktop/PYTHON]-./客户端 | 排名 | PYTHON[~/DeSktop/PYTHON]-./客户端 | PYTHON[~/DeSktop/PYTHON]-./客户端 | PYTHON[~/DeSktop/PYTHON]-./客户端 | 排名(上年) |
| --- | --- | --- | --- | --- | --- |
| #SOCK STREAM 就是TCP协议TCP协议又叫流式协议。 | SOCK DGRAM是udp协议 | 5 | 6 | #2.打电话 | 7 |
| phone.connect(('127.0.0.1'3306)) | 9 | #3.发\收消息 | 10 | phone.send（heLlo′.encode（utf-8'）)#只能发送bytes类型 | 11 |
| data=phone.recv(1024) | 12 | print（'收到服务端的消息： | data) | 13 | 14 |
| #4.挂电话（断开链接） | 15 | phone.close() | Run: | 服务端× | 客户端X |
<!-- OCR_END -->

￼

## 通讯循环

***

| 简化模块使用 |
| :--- |

**服务端**

```plain
## 服务端必须满足至少三点条件：
# 1.绑定一个固定的ip和port
# 2.一直对外提供服务，稳定运行
# 3.能够支持并发
from socket import *
server=socket(AF_INET,SOCK_STREAM)
server.bind(('127.0.0.1',8888))
server.listen(5)
conn,client_addr=server.accept()
data=conn.recv(1024)
print('接收到客户端数据：',data)
conn.send(data.upper())
conn.close()
server.close()
```

**客户端**

```plain
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8888))
client.send('hello'.encode('utf-8'))
data=client.recv(1024)
print(data)
client.close()
```

我们上回写的这些内容，会发现一个问题，客户端发送一个数据，服务端接收到之后，返回数据，然后两边直接关闭了。就好比打电话，你说一句你好，对方回一句你好，然后就结束了？正常来说，我们还可以再接着说，所以我们得做一件事情，那就是`通信循环`

***

| 客户端添加通讯循环 |
| :--- |

```plain
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8888))
while True:
    client.send('hello'.encode('utf-8'))
    data=client.recv(1024)
    print(data)
client.close()
```

***

| 服务端添加通信循环 |
| :--- |

```plain
## 服务端必须满足至少三点条件：
# 1.绑定一个固定的ip和port
# 2.一直对外提供服务，稳定运行
# 3.能够支持并发
from socket import *
server=socket(AF_INET,SOCK_STREAM)
server.bind(('127.0.0.1',8888))
server.listen(5)
conn,client_addr=server.accept()
while True:
    data=conn.recv(1024)
    conn.send(data.upper())
conn.close()
server.close()
```

**运行之后发现，一直在发消息**

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-../Soc
- PYTHON
- socket客户端·py
- 服务端.py
- 客户端.py
- from socket import *
- 2
- 3
- client=socket(AF_INET,SOCK_STREAM)
- 4
- client.connect(('127.0.0.1,8888))
- 5
- 6
- while True:
- client.send('hello'.encode('utf-8'))
- 8
- data=client.recv(1024)
- 9
- print(data)
- 10
- 11
- client.close()
- Run:
- 客户端（1）×
- 服务端（1）
- b'HELLO'
- 'HELLO'
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 使用input发消息 |
| :--- |

```plain
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8888))
# 通信循环
while True:
    msg=input('>>>: ').strip()
    client.send(msg.encode('utf-8'))
    data=client.recv(1024)
    print(data)
client.close()
```

<!-- OCR_START -->
PYTHON[~/Desktop/PYTHON]-../socket/客户端.py[PYTHON]
PYTHONsocket客户端.py
服务端.pyx
客户端.py
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect（('127.0.0.1'8888))
#通信循环
while True:
msg=input('>>>:).strip()
9
client.send(msg.encode('utf-8'))
10
data=client.recv（1024)
11
print(data)
12
13
client.close()
Run:
客户端（1）
服务端（1）
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/socket/客户端.py
：你好
b'\xe4\xbd\xa0\xe5\xa5\xbd'
:hello
b'HELLO'
曾老湿
Driver Zeng
<!-- OCR_END -->

￼

***

| 修改通讯循环bug |
| :--- |

当我们终止 客户端的时候，服务端会被带挂

原因：服务端的 data=conn.recv(1024)，双向连接

我们肯定不能让这种事情发生，你想，如果你访问京东，然后你把自己电脑砸了，京东网站就崩溃了？

妈耶，那也太刺激了吧。

**服务端修改**

```plain
## 服务端必须满足至少三点条件：
# 1.绑定一个固定的ip和port
# 2.一直对外提供服务，稳定运行
# 3.能够支持并发
from socket import *
server = socket(AF_INET, SOCK_STREAM)
server.bind(('127.0.0.1', 8888))
server.listen(5)
conn, client_addr = server.accept()
while True:
    try:  # 处理windows的客户端连接bug
        data = conn.recv(1024)
        if len(data) == 0: break  # 解决 linux 系统bug
        conn.send(data.upper())
    except ConnectionResetError:
        break
conn.close()
server.close()
```

但是这样又出现一个新的问题，虽然服务端不会因为客户端关闭挂了，但是服务端会因为客户端的关闭，自己也正常关闭了。我们要满足服务端的第二点条件，提供服务，稳定运行。

## 链接循环

刚才我们发现bug，如果客户端关闭了，服务端也就关闭了。要死啊，现在来解决这个问题

***

| 修改服务端 |
| :--- |

```plain
## 服务端必须满足至少三点条件：
# 1.绑定一个固定的ip和port
# 2.一直对外提供服务，稳定运行
# 3.能够支持并发
from socket import *
server = socket(AF_INET, SOCK_STREAM)
server.bind(('127.0.0.1', 8888))
server.listen(5)
while True: #链接+通信循环
    conn, client_addr = server.accept()
    while True:  #通信循环
        try:  # 处理windows的客户端连接bug
            data = conn.recv(1024)
            if len(data) == 0: break  # 解决 linux 系统bug
            conn.send(data.upper())
        except ConnectionResetError:
            break
    conn.close()
server.close()
```

但是这样，没有办法做到并发，我们多创建几个客户端

<!-- OCR_START -->
- 客户
- 曾老湿

```text
PYTHON socket客户端7.py
CCE
服务端pyx
客户端1.py×
客户端2.py
客户端3.py
客户端4.py
客户端5.py
客户端6.py
客户端7.p
Project
from socket import* PYTHON
~/Desktop/PYTHON
client=socket(AF_INETSOCK_STREAM)
ATM
client.connect（（127.0.0.18888))
客户端1.py
#通信循环
while True:
msg=input('>>:）.strip() client.send（msg.encode('utf-8') data=client.recv（1024) print(data)
客户端7.py
ent.close()
服务端.py
```
<!-- OCR_END -->

￼

<!-- OCR_START -->
Run:
服务端（1）X
客户端（1）X
客户端2×
客户端3×
客户端4X
客户端5×
客户端6X
客户端7×
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/socket/客户端7.py
Traceback (most recent call last):
File"Users/driverzeng/Desktop/PYTHON/socket/客户端7.py"，line 4，in <module>
client.connect（('127.0.0.1',8888))
TimeoutError:[Errno 6o] Operation timed out
Process finished with exit code 1
曾老湿
Driver Zeng
<!-- OCR_END -->

￼

我们要解决这个问题，想想生活中的例子，比如你开了一家"丽春院"，然后你只有一个人，那外面来了一堆客人，你只能一个一个服务...emmm ，那么怎么解决呢？就是多招几个人，然后你站在门口拉客。

就好比程序，我们开一个进程，这个进程专门，接收请求，然后把请求交给你开的子进程去做，或者交给线程去做。

等回头我们解决这个问题，使用并发编程

## 套接字通信底层原理

***

| bug |
| :--- |

首先我们再来看一个bug，就是客户端如果在发送数据的时候，什么都没有发送，发了个空，客户端就会被阻塞 。

<!-- OCR_START -->
- 直在这闪烁
- 曾老湿

```text
PYTHON[~/Desktop/PYTHON]-../socket/客户端1.py[PYTHON]
PYTHONSOCket
客户端1.py
服务端.py
客户端1.py
客户端2.py
客户端3.py
客户端4.py
客户端5.py×
客户端6.pyx
客户端7.py
from socket import * 2
3
client=socket(AF_INET,SOCK_STREAM)
client.connect（('127.0.0.1'8888))
6
#通信循环
while True:
8
msg=input('>>>:).strip() 9 client.send(msg.encode('utf-8')) 10
data=client.recv(1024)
11
print(data)
12
13
client.close()
Run:
服务端（1）×
客户端1×
客户端2×
客户端3×
客户端4×
客户端5×
客户端6×
客户端7
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/socket/客户端1.py
Driver Zeng
```
<!-- OCR_END -->

￼

这个问题，是阻塞在client.recv这个地方，服务端没有返回数据。

```plain
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8888))
# 通信循环
while True:
    msg=input('>>>: ').strip()
    if len(msg) == 0:continue
    client.send(msg.encode('utf-8'))
    data=client.recv(1024)
    print(data)
client.close()
```

<!-- OCR_START -->
- 曾老湿

```text
PYTHON[~/Desktop/PYTHON]-./Socket/客户端1.py[PYTHON]
PYTHON
socket
客户端1.py
服务端.py
客户端1.py
客户端2.py
客户端3.py
客户端4.py
客户端5.py
客户端6.py
客户端7.py
from socket import * 3
client=socket(AF_INET,SOCK_STREAM)
client.connect（（'127.0.0.1′8888))
4
6
#通信循环
while True:
8
msg=input('>>>:').strip()
9
if len（msg）=0:continue
10
client.send(msg.encode('utf-8'))
11
data=client.recv(1024)
12
print(data)
13
14
client.close()
Run:
服务端（1）
客户端1×
客户端2×
客户端3
客户端4
客户端5×
客户端6
客户端7
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/socket/客户端1.py
>>>:
>>>:
>>>:
DriverZeng
```
<!-- OCR_END -->

￼

***

| 底层原理分析 |
| :--- |

<!-- OCR_START -->
- 第六步：服务器接收
- 到数据之后，返回
- HELLO给客户端，也
- 是通过操作系统
- 服务端程序
- 客户端程序
- b'hello'
- 曾老湿
- 第七步，将HELLO给操作系统
- 第五步：服务器将数据传递给程序
- 第一步：client.sendd发送数据并不是直接给服务端，而是调用操作系统
- 第九步：系统将HELLO传递给程序
- 服务器（操作系统）
- 二步：将bhello发送给服务端的操作系统
- 客户端（操作系统）
- 第三步：接收到客户端的数据，返回ACK
- http://blog.driverzeng.com
- 第八步：将HELLO交给客户端操作系统
<!-- OCR_END -->

￼

## 小练习模拟ssh远程执行命令

**客户端**

```plain
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8080))
# 通信循环
while True:
    cmd=input('请输入要执行的linux命令: ').strip()
    if len(cmd) == 0:continue
    client.send(cmd.encode('utf-8'))
    cmd_res=client.recv(1024)
    print(cmd_res.decode('utf-8'))
client.close()
```

**服务端**

```plain
## 服务端必须满足至少三点条件：
# 1.绑定一个固定的ip和port
# 2.一直对外提供服务，稳定运行
# 3.能够支持并发
from socket import *
import subprocess
server = socket(AF_INET, SOCK_STREAM)
server.bind(('127.0.0.1', 8080))
server.listen(5)
while True: #链接+通信循环
    conn, client_addr = server.accept()
    while True:  #通信循环
        try:  # 处理windows的客户端连接bug
            cmd = conn.recv(1024)
            if len(cmd) == 0: break # 解决 linux 系统bug
            res = subprocess.Popen(cmd.decode('utf-8'), stdout=subprocess.PIPE, shell=True, stderr=subprocess.PIPE)
            stdout=res.stdout.read()
            stderr=res.stderr.read()
            conn.send(stdout+stderr)
        except ConnectionResetError:
            break
    conn.close()
server.close()
```

<!-- OCR_START -->
- 服务端
- 曾老湿

```text
PYTHON[~/Desktop/PYTHON]-../socket/客户端1.py[PYTHON]
PYTHON socket
客户端1.py
服务端.py
客户端1.pyx
客户端2.py
客户端3.py
客户端4.py
客户端5.py
客户端6.py
客户端7.py
from socket import * 3
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1'8080))
6
#通信循环
while True:
cmd=input（请输入要执行的linux命令：）.strip（）
iflen（cmd）=0:continue
9
10
client.send(cmd.encode('utf-8'))
11
cmd_res=client.recv(1024)
12
print(cmd_res.decode('utf-8'))
13
14
client.close()
15
16
Run:
2客户端1×
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/socket/客户端1.py
请输入要执行的linux命令：ls
客户端1.py
客户端2.py
客户端3.py
客户端4.py
客户端5.py
客户端6.py
客户端7.py
服务端·py
请输入要执行的linux命令：ifconfig
VHC128:flags=0mtu0
Lo0:fLagS=8049<UP,L00PBACK,RUNNING,MULTICAST> mtU 16384
opti0nS=1203<RXCSUM,TXCSUM,TXSTATUS,SW_TIMESTAMP>
inet 127.0.0.1netmask 0xff000000
inet6 ::1prefixlen 128
inet6 fe80::1%lo0 prefixlen 64 scopeid 0x2
nd6 options=201<PERFORMNUD,DAD>
gif0:flagS=8010<POINTOPOINT,MULTICAST>mtU 1280
stfo: flags=0 mtu 1280
XHC20:flags=0mtu0
XHCO:flags=0mtu0
XHC1:flags=0mtu0
en5:fLagS=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
ether ac:de:48:00:11:22
三6:TODO
DriverZeng
```
<!-- OCR_END -->

￼

## 粘包问题

<!-- OCR_START -->
PYTHON
客户端1.py
socket
服务端.pyx
客户端1.pyx
客户端2.pyx
客户端3.py
客户端4.py
客户端5.pyx
客户端6.pyx
客户端7.py
from socket import *
2
3
client=socket(AF_INET,SOCK_STREAM)
4
client.connect（('127.0.0.18080))
5
6
#通信循环
7
while True：
8
cmd=input（请输入要执行的linux命令：）.strip（）
9
if len（cmd)=0:continue
10
client.send(cmd.encode('utf-8'))
11
cmd_res=client.recv(1024)
12
print(cmd_res.decode('utf-8'))
13
14
client.close()
15
16
Run:
服务端×
客户端1×
media: autoselect （100baseTx <full-duplex>)
status: active
ap1:fLagS=8802<BROADCAST,SIMPLEX,MULTICAST> mtu 1500
ether f2:18:98:2a:78:eb
media: autoselect
status: inactive
en0:fLagS=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtU 1500
ether f0:18:98:2a:78:eb
inet6 fe80:be:4545:a512:27de%en0 prefixlen 64 secured scopeid 0xa
inet 192.168.101.105 netmask 0xffffff00 broadcast 192.168.101.255
nabop
请输入要执行的linux命令：ls
tionS=201<PERFORMNUD,DAD>
p2p0:fLagS=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST>mtu 2304
aWdL0:fLagS=8943<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST> mtu 1484
ether 5a:42:55:37:d7:1b
inet6 fe80::5842:55ff:fe37:d71b%awdl0 prefixlen 64 scopeid 0xc
nd6 optionS=201<PERFORMNUD,DAD>
曾老湿
DriverZeng
-00621ID DD0ADCA
<!-- OCR_END -->

￼

当客户端，接收服务端返回的结果超过1024的时候，就会出现粘包问题，后面我再执行别的命令。如上图 ，我执行了一个ls，然后把之前的网卡信息没有发完的部分，接着发了。后面的问题，直到所有结果都出来，才能看到。

***

| 什么是粘包问题 |
| :--- |

让我们基于tcp先制作一个远程执行命令的程序（1：执行错误命令 2：执行ls 3：执行ifconfig）

**注意注意注意**：

res=subprocess.Popen(cmd.decode('utf-8'),

shell=True,

stderr=subprocess.PIPE,

stdout=subprocess.PIPE)

的结果的编码是以当前所在的系统为准的，如果是windows，那么res.stdout.read()读出的就是GBK编码的，在接收端需要用GBK解码

且只能从管道里读一次结果

注意：命令ls -l ; lllllll ; pwd 的结果是既有正确stdout结果，又有错误stderr结果

须知：只有TCP有粘包现象，UDP永远不会粘包，为何，且听我娓娓道来

首先需要掌握一个socket收发消息的原理

<!-- OCR_START -->
- 服务端
- 客户端
- socket服务端程序
- 用户态
- socket客户端程序
- 缓存
- 内核态
- NEE
- 网卡
- 曾老湿
- DriverZeng
- internet字节流
<!-- OCR_END -->

￼

发送端可以是一K一K地发送数据，而接收端的应用程序可以两K两K地提走数据，当然也有可能一次提走3K或6K数据，或者一次只提走几个字节的数据，也就是说，应用程序所看到的数据是一个整体，或说是一个流（stream），一条消息有多少字节对应用程序是不可见的，因此TCP协议是面向流的协议，这也是容易出现粘包问题的原因。而UDP是面向消息的协议，每个UDP段都是一条消息，应用程序必须以消息为单位提取数据，不能一次提取任意字节的数据，这一点和TCP是很不同的。怎样定义消息呢？可以认为对方一次性write/send的数据为一个消息，需要明白的是当对方send一条信息的时候，无论底层怎样分段分片，TCP协议层会把构成整条消息的数据段排序完成后才呈现在内核缓冲区。

例如基于tcp的套接字客户端往服务端上传文件，发送时文件内容是按照一段一段的字节流发送的，在接收方看了，根本不知道该文件的字节流从何处开始，在何处结束

所谓粘包问题主要还是因为接收方不知道消息之间的界限，不知道一次性提取多少字节的数据所造成的。

此外，发送方引起的粘包是由TCP协议本身造成的，TCP为提高传输效率，发送方往往要收集到足够多的数据后才发送一个TCP段。若连续几次需要send的数据都很少，通常TCP会根据优化算法把这些数据合成一个TCP段后一次发送出去，这样接收方就收到了粘包数据。

1.TCP（transport control protocol，传输控制协议）是面向连接的，面向流的，提供高可靠性服务。收发两端（客户端和服务器端）都要有一一成对的socket，因此，发送端为了将多个发往接收端的包，更有效的发到对方，使用了优化方法（Nagle算法），将多次间隔较小且数据量小的数据，合并成一个大的数据块，然后进行封包。这样，接收端，就难于分辨出来了，必须提供科学的拆包机制。 即面向流的通信是无消息保护边界的。

2.UDP（user datagram protocol，用户数据报协议）是无连接的，面向消息的，提供高效率服务。不会使用块的合并优化算法，, 由于UDP支持的是一对多的模式，所以接收端的skbuff(套接字缓冲区）采用了链式结构来记录每一个到达的UDP包，在每个UDP包中就有了消息头（消息来源地址，端口等信息），这样，对于接收端来说，就容易进行区分处理了。 即面向消息的通信是有消息保护边界的。

3.tcp是基于数据流的，于是收发的消息不能为空，这就需要在客户端和服务端都添加空消息的处理机制，防止程序卡住，而udp是基于数据报的，即便是你输入的是空内容（直接回车），那也不是空消息，udp协议会帮你封装上消息头，实验略

udp的recvfrom是阻塞的，一个recvfrom(x)必须对唯一一个sendinto(y),收完了x个字节的数据就算完成,若是y>x数据就丢失，这意味着udp根本不会粘包，但是会丢数据，不可靠

tcp的协议数据不会丢，没有收完包，下次接收，会继续上次继续接收，己端总是在收到ack时才会清除缓冲区内容。数据是可靠的，但是会粘包。

两种情况下会发生粘包。

发送端需要等缓冲区满才发送出去，造成粘包（发送数据时间间隔很短，数据了很小，会合到一起，产生粘包）

```plain
from socket import *
import subprocess
server = socket(AF_INET, SOCK_STREAM)
server.bind(('127.0.0.1', 8081))
server.listen(5)
conn,_=server.accept()
data1=conn.recv(5)
print('第一次收: ',data1)
data2=conn.recv(5)
print('第二次收: ',data2)
data3=conn.recv(3)
print('第三次收: ',data3)
```

```plain
from socket import *
client = socket(AF_INET, SOCK_STREAM)
client.connect(('127.0.0.1', 8081))
# tcp协议会将数据量较小且发送时间间隔较短的数据合并成一个数据报发送
client.send(b'hello')
client.send(b'world')
client.send(zls')
```

***

| 解决粘包问题简单版 |
| :--- |

粘包问题是tcp协议流式传输数据的方式导致的

如何解决粘包问题:接收端能够精确地收干净每个数据包没有任何残留

**加报头，解决粘包问题，使用struct模块**

```plain
import struct
obj1=struct.pack('i',133211)
print(obj1,len(obj1))
res1 = struct.unpack('i',obj1)
print(res1[0])
```

<!-- OCR_START -->
| 排名 | Format | Format | Format |
| --- | --- | --- | --- |
| Notes | padbyte | novalue | char |
| string of length1 | 1 | signed char | integer |
| 1 | (3) | unsigned char | integer |
| 1 | (3) | Bool | bool |
| 1 | (1) | short | integer |
| 2 | (3) | unsigned short | integer |
| 2 | (3) | int | integer |
| 4 | (3) | unsigned int | integer |
| 4 | (3) | 1 | long |
| integer | 4 | (3) | unsigned long |
| integer | 4 | (3) | long long |
| integer | 8 | (2),(3) | unsigned long long |
| integer | 8 | (2）,(3) | float |
| 4 | (4) | double | float |
| 8 | (4) | 曾老湿 | string |
<!-- OCR_END -->

￼

```plain
## 关于struct的详细用法
import struct
import binascii
import ctypes
values1 = (1, 'abc'.encode('utf-8'), 2.7)
values2 = ('defg'.encode('utf-8'),101)
s1 = struct.Struct('I3sf')
s2 = struct.Struct('4sI')
print(s1.size,s2.size)
prebuffer=ctypes.create_string_buffer(s1.size+s2.size)
print('Before : ',binascii.hexlify(prebuffer))
# t=binascii.hexlify('asdfaf'.encode('utf-8'))
# print(t)
s1.pack_into(prebuffer,0,*values1)
s2.pack_into(prebuffer,s1.size,*values2)
print('After pack',binascii.hexlify(prebuffer))
print(s1.unpack_from(prebuffer,0))
print(s2.unpack_from(prebuffer,s1.size))
s3=struct.Struct('ii')
s3.pack_into(prebuffer,0,123,123)
print('After pack',binascii.hexlify(prebuffer))
print(s3.unpack_from(prebuffer,0))
```

**服务端**

```plain
# 服务端必须满足至少三点:
# 1. 绑定一个固定的ip和port
# 2. 一直对外提供服务,稳定运行
# 3. 能够支持并发
from socket import *
import subprocess
import struct
server = socket(AF_INET, SOCK_STREAM)
server.bind(('127.0.0.1', 8081))
server.listen(5)
# 链接循环
while True:
    conn, client_addr = server.accept()
    print(client_addr)
    # 通信循环
    while True:
        try:
            cmd = conn.recv(1024) #cmd=b'dir'
            if len(cmd) == 0: break  # 针对linux系统
            obj=subprocess.Popen(cmd.decode('utf-8'),
                             shell=True,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE
                             )
            stdout=obj.stdout.read()
            stderr=obj.stderr.read()
            # 1. 先制作固定长度的报头
            header=struct.pack('i',len(stdout) + len(stderr))
            # 2. 再发送报头
            conn.send(header)
            # 3. 最后发送真实的数据
            conn.send(stdout)
            conn.send(stderr)
        except ConnectionResetError:
            break
    conn.close()
server.close()
```

**客户端**

```plain
from socket import *
import struct
client = socket(AF_INET, SOCK_STREAM)
client.connect(('127.0.0.1', 8081))
# 通信循环
while True:
    cmd=input('>>: ').strip()
    if len(cmd) == 0:continue
    client.send(cmd.encode('utf-8'))
    #1. 先收报头,从报头里解出数据的长度
    header=client.recv(4)
    total_size=struct.unpack('i',header)[0]
    #2. 接收真正的数据
    cmd_res=b''
    recv_size=0
    while recv_size < total_size:
        data=client.recv(1024)
        recv_size+=len(data)
        cmd_res+=data
    print(cmd_res.decode('gbk'))
client.close()
```

***

| 解决粘包问题终极版 |
| :--- |

struct的长度是有范围的。如果超过长度会报错。

而且，刚才的报头很low，只有数据的长度，正常来说，报头应该有，对数据的描述等详细信息。

struct新方式

```plain
import struct
import json
header_dic={
                'filename':'a.txt',
                'md5':'asdfasdf123123x1',
                'total_size':123123111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111123
            }
header_json=json.dumps(header_dic)
# print(header_json)
header_bytes=header_json.encode('utf-8')
print(len(header_bytes))
```

**客户端：**

```plain
from socket import *
import struct
import json
client = socket(AF_INET, SOCK_STREAM)
client.connect(('127.0.0.1', 8081))
# 通信循环
while True:
    cmd=input('>>: ').strip()
    if len(cmd) == 0:continue
    client.send(cmd.encode('utf-8'))
    #1. 先收4bytes,解出报头的长度
    header_size=struct.unpack('i',client.recv(4))[0]
    #2. 再接收报头,拿到header_dic
    header_bytes=client.recv(header_size)
    header_json=header_bytes.decode('utf-8')
    header_dic=json.loads(header_json)
    print(header_dic)
    total_size=header_dic['total_size']
    #3. 接收真正的数据
    cmd_res=b''
    recv_size=0
    while recv_size < total_size:
        data=client.recv(1024)
        recv_size+=len(data)
        cmd_res+=data
    print(cmd_res.decode('gbk'))
client.close()
```

**服务端：**

```plain
# 服务端必须满足至少三点:
# 1. 绑定一个固定的ip和port
# 2. 一直对外提供服务,稳定运行
# 3. 能够支持并发
from socket import *
import subprocess
import struct
import json
server = socket(AF_INET, SOCK_STREAM)
server.bind(('127.0.0.1', 8081))
server.listen(5)
# 链接循环
while True:
    conn, client_addr = server.accept()
    print(client_addr)
    # 通信循环
    while True:
        try:
            cmd = conn.recv(1024)  # cmd=b'dir'
            if len(cmd) == 0: break  # 针对linux系统
            obj = subprocess.Popen(cmd.decode('utf-8'),
                                   shell=True,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE
                                   )
            stdout = obj.stdout.read()
            stderr = obj.stderr.read()
            # 1. 先制作报头
            header_dic = {
                'filename': 'a.txt',
                'md5': 'asdfasdf123123x1',
                'total_size': len(stdout) + len(stderr)
            }
            header_json = json.dumps(header_dic)
            header_bytes = header_json.encode('utf-8')
            # 2. 先发送4个bytes(包含报头的长度)
            conn.send(struct.pack('i', len(header_bytes)))
            # 3  再发送报头
            conn.send(header_bytes)
            # 4. 最后发送真实的数据
            conn.send(stdout)
            conn.send(stderr)
        except ConnectionResetError:
            break
    conn.close()
server.close()
```

## 小练习FTP

服务端：

```plain
import socketserver
import struct
import json
import os
class FtpServer(socketserver.BaseRequestHandler):
    coding='utf-8'
    server_dir='file_upload'
    max_packet_size=1024
    BASE_DIR=os.path.dirname(os.path.abspath(__file__))
    def handle(self):
        print(self.request)
        while True:
            data=self.request.recv(4)
            data_len=struct.unpack('i',data)[0]
            head_json=self.request.recv(data_len).decode(self.coding)
            head_dic=json.loads(head_json)
            # print(head_dic)
            cmd=head_dic['cmd']
            if hasattr(self,cmd):
                func=getattr(self,cmd)
                func(head_dic)
    def put(self,args):
        file_path = os.path.normpath(os.path.join(
            self.BASE_DIR,
            self.server_dir,
            args['filename']
        ))
        filesize = args['filesize']
        recv_size = 0
        print('----->', file_path)
        with open(file_path, 'wb') as f:
            while recv_size < filesize:
                recv_data = self.request.recv(self.max_packet_size)
                f.write(recv_data)
                recv_size += len(recv_data)
                print('recvsize:%s filesize:%s' % (recv_size, filesize))
ftpserver=socketserver.ThreadingTCPServer(('127.0.0.1',8080),FtpServer)
ftpserver.serve_forever()
```

客户端：

```plain
import socket
import struct
import json
import os
class MYTCPClient:
    address_family = socket.AF_INET
    socket_type = socket.SOCK_STREAM
    allow_reuse_address = False
    max_packet_size = 8192
    coding='utf-8'
    request_queue_size = 5
    def __init__(self, server_address, connect=True):
        self.server_address=server_address
        self.socket = socket.socket(self.address_family,
                                    self.socket_type)
        if connect:
            try:
                self.client_connect()
            except:
                self.client_close()
                raise
    def client_connect(self):
        self.socket.connect(self.server_address)
    def client_close(self):
        self.socket.close()
    def run(self):
        while True:
            inp=input(">>: ").strip()
            if not inp:continue
            l=inp.split()
            cmd=l[0]
            if hasattr(self,cmd):
                func=getattr(self,cmd)
                func(l)
    def put(self,args):
        cmd=args[0]
        filename=args[1]
        if not os.path.isfile(filename):
            print('file:%s is not exists' %filename)
            return
        else:
            filesize=os.path.getsize(filename)
        head_dic={'cmd':cmd,'filename':os.path.basename(filename),'filesize':filesize}
        print(head_dic)
        head_json=json.dumps(head_dic)
        head_json_bytes=bytes(head_json,encoding=self.coding)
        head_struct=struct.pack('i',len(head_json_bytes))
        self.socket.send(head_struct)
        self.socket.send(head_json_bytes)
        send_size=0
        with open(filename,'rb') as f:
            for line in f:
                self.socket.send(line)
                send_size+=len(line)
                print(send_size)
            else:
                print('upload successful')
client=MYTCPClient(('127.0.0.1',8080))
client.run()
```

## 基于udp协议的套接字

udp协议：又叫做数据报协议，udp是无链接的，先启动哪一端都不会报错

***

| 服务端 |
| :--- |

```plain
import socket
server=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
server.bind(('127.0.0.1',8080))
## TCP协议应该写：server.listen(5)，但是udp协议不需要链接
## TCP协议应该写：erver.accept()，建立双向链接，但是udp协议没有，所以也不写
while True:
    data=server.recvfrom(1024)
    print(data)
```

***

| 客户端 |
| :--- |

```plain
import socket
client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
## TCP协议应该写：client.connect(('127.0.0.1',8080)) 但是udp协议没有链接
while True:
    msg=input('>>:').strip()
    client.sendto(msg.encode('utf-8'),('127.0.0.1',8080))
```

运行服务端和客户端

<!-- OCR_START -->
PYTHON[~/Desktop/PYTHON]-../udp/客户
PYTHON udp
客户端.py
服务端·pyx
import socket
client=socket.socket(socket.AF_INET,socket.SoCK_DGRAM)
#TcP协议应该写：client.connect（（
（127.0.0.18080））但是udp协议没有链接
while True:
msg=input（'>>:').strip(）
client.sendto(msg.encode('utf-8'),('127.0.0.1'8080))
8
Run:
服务端（1）
客户端X
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/udp/客户端.py
:z1s
曾老湿
Driver Zeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
| 排名 | PYTHON | 排名(上年) | PYTHON | 排名(上年) | PYTHON |
| --- | --- | --- | --- | --- | --- |
| 客户端.py | import socket | server=socket.socket(socket.AF_INET,socket.SoCK_DGRAM) | server.bind（('127.0.0.1',8080)) | 5 | 白## TcP协议应该写：server.Listen（5）、但是udp协议不需要链接 |
| 6 | #Tcp协议应该写：erver.accept（），建立双向链接，但是udp协议没有，所以也不写 | 8 | while True: | 9 | data=server.recvfrom(1024) |
| 10 | print(data) | 11 | 12 | Run: | 服务端（1）× |
<!-- OCR_END -->

￼

***

| 服务端返回消息 |
| :--- |

```plain
import socket
server=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
server.bind(('127.0.0.1',8080))
## TCP协议应该写：server.listen(5)，但是udp协议不需要链接
## TCP协议应该写：erver.accept()，建立双向链接，但是udp协议没有，所以也不写
while True:
    data,client_addr=server.recvfrom(1024)
    print(data)
    server.sendto(data.upper(),client_addr)
```

***

| 客户端接收服务端返回的消息 |
| :--- |

```plain
import socket
client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
## TCP协议应该写：client.connect(('127.0.0.1',8080)) 但是udp协议没有链接
while True:
    msg=input('>>:').strip()
    client.sendto(msg.encode('utf-8'),('127.0.0.1',8080))
    data,server_addr=client.recvfrom(1024)
    print(data)
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-../uC
- PYTHONudp客户端.py
- 服务端.pyx
- 客户端.py
- importsocket
- 2
- 3
- client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
- 4
- ##TcP协议应该写：client.connect（（127.0.0.1，8080））但是udp协议没有链接
- 5
- 6
- while True：
- msg=input(':').strip()
- 8
- client.sendto(msg.encode('utf-8'),('127.0.0.1',8080))
- 9
- data,server_addr=client.recvfrom(1024)
- 10
- print(data)
- Run:
- 服务端（1）
- 2客户端X
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/udp/客户端.py
- >>:zls
- b'ZLS'
- >>:abc
- b'ABC'
- 曾老湿
- >：
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
| PYTHONDudp | PYTHONDudp | PYTHONDudp | PYTHONDudp | 排名 |
| --- | --- | --- | --- | --- |
| 服务端.py | 服务端.pyx | 客户端.py | import socket | 3 |
| server=socket.socket(socket.AF_INET,socket.SoCK_DGRAM) | server.bind(('127.0.0.1'8080)) | ## TcP协议应该写：server.Listen（5），但是udp协议不需要链接 | 5 | 6 |
| #TcP协议应该写：erver.accept（）建立双向链接，但是udp协议没有，所以也不写 | 8 | while True： | 9 | data,client_addr=server.recvfrom(1024) |
| 10 | print(data) | 11 | server.sendto(data.upper(),client_addr) | 12 |
| 13 | Run: | 服务端（1）× | 客户端 | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/udp/服务端.py |
<!-- OCR_END -->

￼

**注意：**

1.如果把客户端关了，服务端不会断开连接

2.如果把服务端关了，客户端还能发送数据

3.客户端只输入一个回车(空数据)不会阻塞

对于udp协议来说，必须一发对应一收，所以udp协议不存在粘包问题

```plain
## 服务端
import socket
server=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
server.bind(('127.0.0.1',8080))
## TCP协议应该写：server.listen(5)，但是udp协议不需要链接
## TCP协议应该写：server.accept()，建立双向链接，但是udp协议没有，所以也不写
print(server.recvfrom(1024))
print(server.recvfrom(1024))
print(server.recvfrom(1024))
## 客户端
import socket
client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
## TCP协议应该写：client.connect(('127.0.0.1',8080)) 但是udp协议没有链接
client.sendto(b'hello',('127.0.0.1',8080))
client.sendto(b'world',('127.0.0.1',8080))
client.sendto(b'zls',('127.0.0.1',8080))
```

<!-- OCR_START -->
PYTHON[~/Desktop/PY
PYTHONudp客户端.py
服务端.pyX
客户端.py
import socket
client=socket.socket(socket.AF_INET,socket.SoCK_DGRAM)
#Tcp协议应该写：client.connect（（127.0.0.18080））但是udp协议没有链接
6
client.sendto(b'hello'('127.0.0.1',8080))
cent.sendto(b'world'('127.0.0.1',8080))
client.sendto(b'zls'('127.0.0.1',8080))
Run:
服务端（1）×
客户端X
/users/driverzeng/PycharmProjects/untitled1/venv/bin/python/users/driverzeng/Desktop/PYTHoN/udp/服务端.
(b'hello',('127.0.0.1',53270))
(b'world'，('127.0.0.1',53270))
(b'zls',('127.0.0.1'，53270))
Process finished with exit code 0
曾老湿
Driver Zeng
<!-- OCR_END -->

￼

在工作中，很少使用udp协议，有一些服务会走udp协议：

1.ntp时间服务器

2.QQ聊天

3.DNS

***

| 模拟QQ聊天 |
| :--- |

```plain
## 服务端
import socket
ip_port=('127.0.0.1',8081)
udp_server_sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM) #买手机
udp_server_sock.bind(ip_port)
while True:
    qq_msg,addr=udp_server_sock.recvfrom(1024)
    print('来自[%s:%s]的一条消息:\033[1;44m%s\033[0m' %(addr[0],addr[1],qq_msg.decode('utf-8')))
    back_msg=input('回复消息: ').strip()
    udp_server_sock.sendto(back_msg.encode('utf-8'),addr)
## 客户端1
import socket
BUFSIZE=1024
udp_client_socket=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
qq_name_dic={
    '虞姬':('127.0.0.1',8081),
    '韩信':('127.0.0.1',8081),
    '甄姬':('127.0.0.1',8081),
    '武大郎':('127.0.0.1',8081),
}
while True:
    qq_name=input('请选择聊天对象: ').strip()
    while True:
        msg=input('请输入消息,回车发送: ').strip()
        if msg == 'quit':break
        if not msg or not qq_name or qq_name not in qq_name_dic:continue
        udp_client_socket.sendto(msg.encode('utf-8'),qq_name_dic[qq_name])
        back_msg,addr=udp_client_socket.recvfrom(BUFSIZE)
        print('来自[%s:%s]的一条消息:\033[1;44m%s\033[0m' %(addr[0],addr[1],back_msg.decode('utf-8')))
udp_client_socket.close()
## 客户端2
import socket
BUFSIZE=1024
udp_client_socket=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
qq_name_dic={
    '虞姬':('127.0.0.1',8081),
    '韩信':('127.0.0.1',8081),
    '甄姬':('127.0.0.1',8081),
    '武大郎':('127.0.0.1',8081),
}
while True:
    qq_name=input('请选择聊天对象: ').strip()
    while True:
        msg=input('请输入消息,回车发送: ').strip()
        if msg == 'quit':break
        if not msg or not qq_name or qq_name not in qq_name_dic:continue
        udp_client_socket.sendto(msg.encode('utf-8'),qq_name_dic[qq_name])
        back_msg,addr=udp_client_socket.recvfrom(BUFSIZE)
        print('来自[%s:%s]的一条消息:\033[1;44m%s\033[0m' %(addr[0],addr[1],back_msg.decode('utf-8')))
udp_client_socket.close()
```

<!-- OCR_START -->
- PYTHON[~/DeSKtop/PYTHON]-
- PYTHONudp客户端2.py
- 服务端.pyX
- 客户端1.py
- 客户端2.py
- import socket
- BUFSIZE=1024
- udp_client_socket=socket.socket(socket.AF_INET,socket.SocK_DGRAM)
- 5
- qq_name_dic={
- 6
- 虞姬（127.0.0.18081），
- 韩信（127.0.0.18081），
- 8
- 9
- 武大郎:（127.0.0.18081）
- 10
- 11
- 12
- 13
- while True:
- 14
- qq_name=input（请选择聊天对象：）.strip（）
- 15
- 16
- msg=input（请输入消息，回车发送：）.strip（）
- 17
- if msg=
- 'quit':break
- 18
- if not msg or not qq_name or qq_name not in qq_name_dic:continue
- 19
- udp_client_socket.sendto(msg.encode('utf-8'),qq_name_dic[qq_name])
- 20
- 21
- back_msg,addr=udp_client_socket.recvfrom(BuFsIzE)
- 22
- print（'来自[%s:%s]的-条消息:\033[1;44m%s\033[0m′%（addr[0],addr[1]back_msg.decode（utf-8'）)）
- Run:
- 服务端（1）×
- 客户端X
- 客户端2
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/udp/服务端.py
- 来自[127.0.0.1：52073]的-条消息：123
- 回复消息：咋啦？
- 来自[127.0.0.1：59290]的-条消息：abc
- 回复消息：干哈？
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON
- PYTHONudp客户端1.py
- 服务端.pyx
- 客户端1.py
- 客户端2.py
- import socket
- BUFSIZE=1024
- udp_client_socket=socket.socket(socket.AF_INET,socket.SocK_DGRAM)
- 5
- name_dic={
- 6
- 虞姬:（127.0.0.18081），
- 韩信：（127.0.0.18081），
- 8
- 9
- 武大郎（127.0.0.18081），
- 10
- 11
- 12
- 13
- while True:
- 14
- qq_name=input（‘请选择聊天对象：）.strip（）
- 15
- 16
- msg=input（请输入消息，回车发送：）.strip（）
- 17
- if msg ='quit':break
- 18
- if not msg or not qq_name or qq_name not in qq_name_dic:continue
- 19
- udp_client_socket.sendto(msg.encode('utf-8'),qq_name_dic[qa_name])
- 20
- 21
- back_msg,addr=udp_client_socket.recvfrom(BuFsIzE)
- 22
- print（‘来自[%s:%s]的-条消息:\033[1;44m%s\033[0m′%（addr[0],addr[1],back msg.decode（'utf-8')))
- 虞姬
- Run:
- 服务端（1）×
- 客户端X
- 客户端2
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/udp/客户端1.py
- 请选择聊天对象：虞姬
- 请输入消息，回车发送：123
- 来自[127.0.0.1:8081]的-条消息：咋啦？
- 曾老湿
- 青输入消息，回车发送：
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- PYTHONudp客户端2.py
- 服务端.pyx
- 客户端1.py
- 客户端2.py
- import socket
- 2
- BUFSIZE=1024
- udp_client_socket=socket.socket(socket.AF_INETsocket.SoCK_DGRAM)
- 5
- qq_name_dic={
- 6
- 虞姬:（127.0.0.18081），
- 韩信（127.0.0.18081），
- 9
- 武大郎：（127.0.0.18081），
- 10
- 11
- 12
- 13
- while True:
- 14
- qq_name=input（请选择聊天对象：）.strip（）
- 15
- 16
- msg=input（请输入消息，回车发送：）.strip（）
- 17
- if msg='quit':break
- 18
- if not msg or not qq_name or qq_name not in qq_name_dic:continue
- 19
- udp_client_socket.sendto(msg.encode('utf-8'),qq_name_dic[qq_name])
- 20
- 21
- back_msg.addr=udp_client_socket.recvfrom(BuFsIzE)
- 22
- print（‘来自[%s:%s]的-条消息：\033[1;44m%s\033[0m%（addr[0],addr[1]back_msg.decode（utf-8'）））
- Run:
- 服务端（1）×
- 客户端X
- 客户端2×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/udp/客户端1.py
- 请选择聊天对象：虞姬
- 请输入消息，回车发送：123
- 来自[127.0.0.1:8081]的-条消息：咋啦？
- 请输入消息，回车发送：
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## 实现并发

使用socketserver模块

基于tcp的套接字，关键就是两个循环，一个链接循环，一个通信循环

socketserver模块中分两大类：server类（解决链接问题）和request类（解决通信问题）

**server类：**

<!-- OCR_START -->
- 与链接有关
- BaseServer
- TCPServer
- UnixStreamServer
- UDPServer
- UnixDatagramServer
- 基于多线程实现并发
- ThreadingMixIn
- ThreadingTCPServer
- ForkingMixIn
- 曾老湿
- ForkingUDPServer
- Driver Zeng
<!-- OCR_END -->

￼

**request类：**

<!-- OCR_START -->
- 与通信有关
- BaseRequestHandler
- StreamRequestHandler
- uestHandler
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**继承关系:**

<!-- OCR_START -->
- BaseServer
- ThreadingMixIn
- TCPServer
- UnixStreamServer
- 左继承
- 右继承
- UDPServer
- UnixDatagramServer
- ThreadingTCPServer
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- BaseServer
- ForkingMixIn
- TCPServer
- UnixStreamServer
- 左继承
- 右继承
- UDPServer
- UnixDatagramServer
- ForkingTCPServer
- 曾老湿
- DriverZeng
- ForkingUDPServer
<!-- OCR_END -->

￼

<!-- OCR_START -->
BaseRequestHandler
StreamRequestHandler
DatagramRequestHandler
<!-- OCR_END -->

￼

```python

以下述代码为例，分析socketserver源码：

ftpserver=socketserver.ThreadingTCPServer(('127.0.0.1',8080),FtpServer)

ftpserver.serve_forever()

查找属性的顺序：ThreadingTCPServer->ThreadingMixIn->TCPServer->BaseServer

1.实例化得到ftpserver，先找类ThreadingTCPServer的__init__,在TCPServer中找到，进而执行server_bind,server_active

2.找ftpserver下的serve_forever,在BaseServer中找到，进而执行self._handle_request_noblock()，该方法同样是在BaseServer中

3.执行self._handle_request_noblock()进而执行request, client_address = self.get_request()（就是TCPServer中的self.socket.accept()），然后执行self.process_request(request, client_address)

4.在ThreadingMixIn中找到process_request，开启多线程应对并发，进而执行process_request_thread，执行self.finish_request(request, client_address)

5.上述四部分完成了链接循环，本部分开始进入处理通讯部分，在BaseServer中找到finish_request,触发我们自己定义的类的实例化，去找__init__方法，而我们自己定义的类没有该方法，则去它的父类也就是BaseRequestHandler中找....

## 源码分析总结：
基于tcp的socketserver我们自己定义的类中的

　　1.self.server即套接字对象

　　2.self.request即一个链接

　　3.self.client_address即客户端地址

基于udp的socketserver我们自己定义的类中的

　　1.self.request是一个元组（第一个元素是客户端发来的数据，第二部分是服务端的udp套接字对象），如(b'adsf', )

　　2.self.client_address即客户端地址

```

***

| 基于TCP协议 |
| :--- |

```plain
import socketserver
## 自定义的类，只能来处理通信循环
class MyTCPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        print(self.client_address)
        pass
if __name__ == '__main__':
    server=socketserver.ThreadingTCPServer(('127.0.0.1',8081),MyTCPHandler)## 创建线程
    server.serve_forever()   ## 链接循环
```

运行一个服务端，三个客户端，会发现有三个客户端信息已经连接过来了

***

| 添加通信循环 |
| :--- |

```plain
### 服务端
###  思路，一个人站门口不停的建链接，然后造完链接就起一个线程，去做该做的事情
import socketserver
## 自定义的类，只能来处理通信循环
class MyTCPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        while True:  # 通信循环
            try:  # 处理windows的客户端连接bug
                data = self.request.recv(1024)
                if len(data) == 0: break  # 解决 linux 系统bug
                print('--->接收到客户端消息',data)
                self.request.send(data.upper())
            except ConnectionResetError:
                break
        self.request.close()
if __name__ == '__main__':
    server=socketserver.ThreadingTCPServer(('127.0.0.1',8081),MyTCPHandler)## 创建线程
    server.serve_forever()   ## 链接循环
```

```plain
### 客户端
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8081))
# 通信循环
while True:
    msg=input('>>>: ').strip()
    client.send(msg.encode('utf-8'))
    data=client.recv(1024)
    print(data)
client.close()
```

实现并发，每个客户端都能收到消息。

<!-- OCR_START -->
| 服务端.py | 服务端.py | 服务端.py | 服务端.py | 服务端.py | 排名 |
| --- | --- | --- | --- | --- | --- |
| 客户端1.pyx | 客户端2.pyx | 客户端3.py× | 客户端4.pyX | 客户端5.py | 客户端6.pyx |
| 客户端7.py | 18 | 19 | ## | 思路，一个人站门口不停的建链接，然后造完链接就起一个线程，去做该做的事情 | 20 |
| 21 | import socketserver | 22 | 23 | #自定义的类，只能来处理通信循环 | 24 |
| class MyTCPHandLer(socketserver.BaseRequestHandLer): | 25 | def handle(self): | 26 | while True:#通信循环 | 27 |
| try： #处理windows的客户端连接bug | 28 | data = self.request.recv(1024) | if len（data）=O:break #解决linux 系统bug | 29 | 30 |
| print（'- | 接收到客户端消息，data） | 31 | self.request.send(data.upper()) | 32 | except ConnectionResetError: |
| 33 | break | 34 | self.request.close() | 35 | 36 |
| if | name | main | 37 | server=socketserver.ThreadingTCPServer（（127.0.0.18081），MyTCPHandler）## 创建线程 | 38 |
| server.serve_forever() | #链接循环 | 39 | MyTCPHandler handle() | while True | except ConnectionResetError |
| Run: | 服务端 | 客户端1× | 2.客户端2（1）× | 客户端3× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/socket/Tcp并发编程/客户端2.py |
<!-- OCR_END -->

￼

***

| 基于udp协议 |
| :--- |

```plain
### 服务端
import socketserver
class MyUDPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        print(self.request)
if __name__ == '__main__':
    server=socketserver.ForkingUDPServer(('127.0.0.1',8080),MyUDPHandler)
    server.serve_forever()
### 客户端
import socket
client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
## TCP协议应该写：client.connect(('127.0.0.1',8080)) 但是udp协议没有链接
while True:
    client.sendto(b'hello',('127.0.0.1',8080))
    data,server_addr=client.recvfrom(1024)
    print(data)
```

运行一下服务端和客户端

<!-- OCR_START -->
| PYTHONSOcketUDP并发编程 | PYTHONSOcketUDP并发编程 | PYTHONSOcketUDP并发编程 | PYTHONSOcketUDP并发编程 | PYTHONSOcketUDP并发编程 | 排名 |
| --- | --- | --- | --- | --- | --- |
| 服务端.py | 客户端1.pyx | 客户端2.pyx | importsocketserver | 3 | class MyUDPHandLer(socketserver.BaseRequestHandler): |
| def handle(self): | 5 | print(self.request) | if | name.wmain | 8 |
| server=socketserver.ForkingUDPServer(('127.0.0.1',8080)MyUDPHandler) | server.serve_forever() | 9 | 10 | 11 | 12 |
| Run: | 服务端（1）× | 客户端1（1）× | 客户端2× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/socket/UDP并发编程/服务端·py | 7 |
<!-- OCR_END -->

￼

```plain
### 服务端，添加一个通信循环
import socketserver
import socketserver
class MyUDPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        print(self.request)
        data,sock=self.request
        self.request[1].sendto(data.upper(),self.client_address)
if __name__ == '__main__':
    server=socketserver.ForkingUDPServer(('127.0.0.1',8080),MyUDPHandler)
    server.serve_forever()
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:24:59  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/nxyx1q>