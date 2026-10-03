# 第6章 网络编程-SOCKET开发

# 6.1 C/S架构介绍
## 本节重点：
+ 了解C/S架构
+ 计算机基础知识
+ 了解什么是网络

> **本节时长需控制在35-45分钟内**
>

### 什么是C/S架构
C指的是client（客户端软件），S指的是Server（服务端软件），本章的重点就是教大家写一个C/S架构的软件，实现服务端软件与客户端软件基于网络通信。

### 计算机基础知识
作为应用开发程序员，我们开发的软件都是应用软件，而应用软件必须运行于操作系统之上，操作系统则运行于硬件之上，应用软件是无法直接操作硬件的，应用软件对硬件的操作必须调用操作系统的接口，由操作系统操控硬件。

比如客户端软件想要基于网络发送一条消息给服务端软件，流程是：

1、客户端软件产生数据，存放于客户端软件的内存中，然后调用接口将自己内存中的数据发送／拷贝给操作系统内存

2、客户端操作系统收到数据后，按照客户端软件指定的规则（即协议）、调用网卡发送数据

3、网络传输数据

4、服务端软件调用系统接口，想要将数据从操作系统内存拷贝到自己的内存中

5、服务端操作系统收到4的指令后，使用与客户端相同的规则（即协议）从网卡接收到数据，然后拷贝给服务端软件

<!-- OCR_START -->
- 客户端软件
- 服务端软件
- 操作系统
- 计算机硬件
- internet
<!-- OCR_END -->

### 什么是网络
硬件之上安装好操作系统，然后装上软件你就可以正常使用了，但此时你也只能自己使用，像下图这样，每个人都拥有一台自己的机器，然而彼此孤立

<!-- OCR_START -->
- 软件
- 操作系统
- 硬件
<!-- OCR_END -->

如何能大家一起玩耍，那就是联网了，即internet

然而internet为何物？举一个简单的例子： 如果把一个人与这个人的有线电话比喻为一台计算机，那么其实两台计算机之间通信与两个人打电话之间通信的原理是一样的。 两个人之间想要打电话首先一点必须是接电话线，这就好比是计算机之间的通信首先要有物理链接介质，比如网线，交换机，路由器等网络设备。 通信的线路建好之后，只是物理层面有了可以承载数据的介质，要想通信，还需要我们按照某种规则组织我们的数据，这样对方在接收到数据后就可以按照相同的规则去解析出数据，这里说的规则指的就是：中国有很多地区，不同的地区有不同的方言，为了全中国人都可以听懂，大家统一讲普通话

<!-- OCR_START -->
- 北京：林海峰
- 广西：周陌
- 通信标准：普通话
<!-- OCR_END -->

普通话属于中国国内人与人之间通信的标准，那如果是两个国家的人交流呢？

<!-- OCR_START -->
- 美国：奥巴马
- 通信标准：英语
- 北京：林海峰
- 广西：周陌
- 通信标准：普通话
<!-- OCR_END -->

问题是，你不可能要求一个人／计算机掌握全世界的语言／标准，于是有了世界统一的通信标准：英语

<!-- OCR_START -->
- 美国：奥巴马
- 世界统一的通信标准：英语
- 北京：林海峰
- 广西：周陌
- 日本：苍井空
<!-- OCR_END -->

英语成为世界上所有人通信的统一标准，计算机之间的通信也应该有一个像英语一样的通信标准，这个标准称之为互联网协议， 可以很明确地说：互联网协议就是计算机界的英语，网络就是物理链接介质+互联网协议。 我们需要做的是，让全世界的计算机都学会互联网协议，这样任意一台计算机在发消息时都严格按照协议规定的格式去组织数据，接收方就可以按照相同的协议解析出结果了，这就实现了全世界的计算机都能无障碍通信。 按照功能不同，人们将互联网协议分为osi七层或tcp/ip五层或tcp/ip四层（我们只需要掌握tcp/ip五层协议即可），这种分层就好比是学习英语的几个阶段，每个阶段应该掌握专门的技能或者说完成特定的任务，比如：1、学音标 2、学单词 3、学语法 4、写作文。。。

<!-- OCR_START -->
- 应用层
- 表示层
- 会话层
- 传输层
- 网络层
- 数据链路层
- 网络接口层
- 物理层
<!-- OCR_END -->

每层运行常见物理设备（了解）

<!-- OCR_START -->
- 传输层
- 四层交换机、
- 四层的路由器
- 网络层
- 路由器、
- 三层交换机
- 数据链路层
- 网桥、以太网交换机、网卡
- 物理层
- 中继器、集线器、双绞线
<!-- OCR_END -->

### 什么是TCP/IP?
Transmission Control Protocol/Internet Protocol的简写，中译名为传输控制协议/因特网互联协议，又名网络通讯协议，是Internet最基本的协议、Internet国际互联网络的基础

### TCP/IP的起源
20世纪50年代末，正处于冷战时期。当时美国军方为了自己的计算机网络在受到袭击时，即使部分网络被摧毁，其余部分仍能保持通信联系，便由美国国防部的高级研究计划局（ARPA）建设了一个军用网，叫做“阿帕网”（ARPAnet）。阿帕网于1969年正式启用，当时仅连接了4台计算机，供科学家们进行计算机联网实验用，这就是因特网的前身。

到70年代，ARPAnet已经有了好几十个计算机网络，但是每个网络只能在网络内部的计算机之间互联通信，不同计算机网络之间仍然不能互通。为此， ARPA又设立了新的研究项目，支持学术界和工业界进行有关的研究，研究的主要内容就是想用一种新的方法将不同的计算机局域网互联，形成“互联网”。研究人员称之为“internetwork”，简称“Internet”，这个名词就一直沿用到现在。

终于到1974年，TCP/IP诞生啦，TCP/IP有一个非常重要的特点，就是开放性，即TCP/IP的规范和Internet的技术都是公开的。目的就是使任何厂家生产的计算机都能相互通信，使Internet成为一个开放的系统，这正是后来Internet得到飞速发展的重要原因。

### OSI七层模型
美国国防部在开发tcp/ip的同时，还有一些其它大厂商也开发出了自己的网络体系，实际上世界上第一个网络体系结构由IBM公司提出（也是74年，比TCP/IP略早，SNA），以后其他公司也相继提出自己的网络体系结构如：Digital公司的DNA，美国国防部的TCP/IP等，多种网络体系结构并存，其结果是若采用IBM的结构，只能选用IBM的产品，只能与同种结构的网络互联。

这就像中国人说中文，美国人说英语，日本人说日本话一样，同一国家的人沟通没问题，但不同国家之间的人没法通信。为了解决网络通信中这样不互通的问题，国际标准化组织ISO于1977年成立了一个委员会，在现有网络的基础上，提出了不基于具体机型、操作系统或公司的网络体系结构，称为开放系统互联模型。

**OSI/RM模型(Open System Interconnection / Reference Model)的设计目的是成为一个所有计算机厂商都能实现的开放网络模型，来克服使用众多私有网络模型所带来的困难和低效性。**

****

# 6.2 TCP/IP 各层详解
# 本节重点：
+ 让学生知道tcp/ip 5层模型中，每一层都是做什么的
+ 让学生掌握每一层中必备的知识点

> **本节时长需控制在60分钟内**
>

### TCP/IP五层模型讲解（2分）
我们将应用层，表示层，会话层并作应用层，从tcp／ip五层协议的角度来阐述每层的由来与功能，搞清楚了每层的主要协议

就理解了整个互联网通信的原理。

首先，用户感知到的只是最上面一层应用层，自上而下每层都依赖于下一层，所以我们从最下一层开始切入，比较好理解

每层都运行特定的协议，越往上越靠近用户，越往下越靠近硬件

### 物理层（2分）
物理层由来：上面提到，孤立的计算机之间要想一起玩，就必须接入internet，言外之意就是计算机之间必须完成组网

物理层功能：主要是基于电器特性发送高低电压(电信号)，高电压对应数字1，低电压对应数字0

### 数据链路层（5分）
数据链路层由来：单纯的电信号0和1没有任何意义，必须规定电信号多少位一组，每组什么意思

数据链路层的功能：定义了电信号的分组方式

**以太网协议：**

早期的时候各个公司都有自己的分组方式，后来形成了统一的标准，即以太网协议ethernet

ethernet规定

+ 一组电信号构成一个数据包，叫做‘帧’
+ 每一数据帧分成：报头head和数据data两部分

| head | data |
| :--- | :--- |
| | |

head包含：(固定18个字节)

+ 发送者／源地址，6个字节
+ 接收者／目标地址，6个字节
+ 数据类型，6个字节

data包含：(最短46字节，最长1500字节)

+ 数据包的具体内容

head长度＋data长度＝最短64字节，最长1518字节，超过最大限制就分片发送

**mac地址：**

head中包含的源和目标地址由来：ethernet规定接入internet的设备都必须具备网卡，发送端和接收端的地址便是指网卡的地址，即mac地址

mac地址：每块网卡出厂时都被烧制上一个世界唯一的mac地址，长度为48位2进制，通常由12位16进制数表示（前六位是厂商编号，后六位是流水线号）

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
- pc1发来的包，拆开后发现目标mac如果不是自已就丢弃，如果是自已就响应
- pc1
- pc2
- pc3
<!-- OCR_END -->

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
- pc1发来的包，拆开后发现目标mac如果不是自已就丢弃，如果是自已就响应
- pc1
- pc2
- pc3
<!-- OCR_END -->

### 网络层（40分）
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
- 隔离的扇域网2
<!-- OCR_END -->

上图结论：必须找出一种方法来区分哪些计算机属于同一广播域，哪些不是，如果是就采用广播的方式发送，如果不是，

就采用路由的方式（向不同广播域／子网分发数据包），mac地址是无法区分的，它只跟厂商有关

网络层功能：**引入一套新的地址用来区分不同的广播域／子网，这套地址即网络地址**

##### **IP协议：**
+ 规定网络地址的协议叫ip协议，它定义的地址称之为ip地址，广泛采用的v4版本即ipv4，它规定网络地址由32位2进制表示
+ 范围0.0.0.0-255.255.255.255
+ 一个ip地址通常写成四段十进制数，例：172.16.10.1

**子网掩码**

所谓”子网掩码”，就是表示子网络特征的一个参数。它在形式上等同于IP地址，也是一个32位二进制数字，它的网络部分全部为1，主机部分全部为0。比如，IP地址172.16.10.1，如果已知网络部分是前24位，主机部分是后8位，那么子网络掩码就是11111111.11111111.11111111.00000000，写成十进制就是255.255.255.0。

子网掩码是用来标识一个IP地址的哪些位是代表网络位，以及哪些位是代表主机位。子网掩码不能单独存在，它必须结合IP地址一起使用。_**子网掩码只有一个作用，就是将某个IP地址划分成网络地址和主机地址两部分。**_

> 蒙蔽的你肯定想问，我要区分网络位和主机位干鬼用？
>
> 这就像寄信，你给你的南方姑娘寄信，她肉身在厦门，详细地址是厦门鼓浪屿三街27号，那网络位就相当于城市，详细地址就是主机位，网络位帮你定位到城市，主机位帮你找到你的南方姑娘。 路由器通过子网掩码来确定哪些是网络位，哪些是主机位
>

区分网络位和主机位是为了划分子网，就是把一个大网络分成多个小网络，为什么要分子网呢?

+ **广播风暴**：6万台主机在一个网段里，通信基本靠吼，任何一个人要吼一嗓子，6万多个人必须被动听着，一会你的网络就瘫痪啦。
+ **地址浪费**：运营商在公网上有很多级联的路由器，有时候2个路由器之间只会用掉几个IP,如果不进行子网划分，那同网段的其它主机也就都不能用了。举例两个级联路由器的接口ip分别为222.34.24.12/24,222.34.24.13/24, 此可承载255个主机的网段只用了2个IP,那其它的就全浪费了，因为不能再分配给别人。

> 划分子网本质上就是借主机位到给网络位，每借一位主机位，这个网段的可分配主机就会越少，比如192.168.1.0/24可用主机255个，借一位变成192.168.1.0/25，那可用主机就从255-128=127个了（从最大的值开始借），再借一位192.168.1.0/26,那可用主机数就变成了255-(128+64)=63个啦
>

**IP地址分类：**

IP地址根据网络ID的不同分为5种类型，A类地址、B类地址、C类地址、D类地址和E类地址。

1. A类IP地址：一个A类IP地址由1字节的网络地址和3字节主机地址组成，网络地址的最高位必须是“0”， 地址范围从1.0.0.0 到126.0.0.0。可用的A类网络有126个，每个网络能容纳1亿多个主机。
2. B类IP地址 ：一个B类IP地址由2个字节的网络地址和2个字节的主机地址组成，网络地址的最高位必须是“10”，地址范围从128.0.0.0到191.255.255.255。可用的B类网络有16382个，每个网络能容纳6万多个主机 。
3. C类IP地址：一个C类IP地址由3字节的网络地址和1字节的主机地址组成，网络地址的最高位必须是“110”。范围从192.0.0.0到223.255.255.255。C类网络可达209万余个，每个网络能容纳254个主机。
4. D类地址用于多点广播（Multicast）： D类IP地址第一个字节以“lll0”开始，它是一个专门保留的地址。它并不指向特定的网络，目前这一类地址被用在多点广播（Multicast）中。多点广播地址用来一次寻址一组计算机，它标识共享同一协议的一组计算机。
5. E类IP地址 以“llll0”开始，为将来使用保留。

> **全零（“0．0．0．0”）地址对应于当前主机。全“1”的IP地址（“255．255．255．255”）是当前子网的广播地址。**
>
> **回环地址(127.0.0.1) 又称为本机地址，那它跟0.0.0.0是什么区别呢？那得先了解回环接口**
>

环回接口（loopback）。平时我们用127.0.0.1来尝试自己的机器服务器好使不好使。走的就是这个loopback接口。对于环回接口，有如下三点值得注意:

+ 传给环回地址（一般是127.0.0.1）的任何数据均作为IP输入。
+ 传给广播地址或多播地址的数据报复制一份传给环回接口，然后送到以太网上。这是 因为广播传送和多播传送的定义包含主机本身。
+ 任何传给该主机IP地址的数据均送到环回接口。

##### IP报文
IP协议是TCP/IP协议的核心，所有的TCP，UDP，IMCP，IGCP的数据都以IP数据格式传输，要注意的是，IP不是可靠的协议，这是说，IP协议没有提供一种数据未传达以后的处理机制－－这被认为是上层协议－－TCP或UDP要做的事情。所以这也就出现了TCP是一个可靠的协议，而UDP就没有那么可靠的区别。这是后话，暂且不提。

IP协议头

<!-- OCR_START -->
- 1516
- 31
- 4位
- 4位首部
- 8位服务类型
- 16位总长度（字节数）
- 版本
- 长度
- (TOS)
- 3位
- 16位标识
- 13位片偏移
- 标志
- 8位生存时间
- 8位协议
- 16位首部检验和
- (TTL)
- 20字节
- 32位源IP地址
- 32位目的IP地址
- 选项（如果有)
<!-- OCR_END -->

挨个解释它是教科书的活计，我感兴趣的只是那八位的TTL字段，还记得这个字段是做什么的么？这个字段规定该数据包在穿过多少个路由之后才会被抛弃(这里就体现出来IP协议包的不可靠性，它不保证数据被送达)，某个ip数据包每穿过一个路由器，该数据包的TTL数值就会减少1，当该数据包的TTL成为零，它就会被自动抛弃。这个字段的最大值也就是255，也就是说一个协议包也就在路由器里面穿行255次就会被抛弃了，根据系统的不同，这个数字也不一样，一般是32或者是64

##### **ARP协议**
arp协议由来：计算机通信基本靠吼，即广播的方式，所有上层的包到最后都要封装上以太网头，然后通过以太网协议发送，在谈及以太网协议时候，我门了解到

通信是基于mac的广播方式实现，计算机在发包时，获取自身的mac是容易的，如何获取目标主机的mac，就需要通过arp协议

arp协议功能：广播的方式发送数据包，获取目标主机的mac地址

协议工作方式：每台主机ip都是已知的

例如：主机172.16.10.10/24访问172.16.10.11/24

一：首先通过ip地址和子网掩码区分出自己所处的子网

| 场景 | 数据包地址 |
| :--- | :--- |
| 同一子网 | 目标主机mac，目标主机ip |
| 不同子网 | 网关mac，目标主机ip |

二：分析172.16.10.10/24与172.16.10.11/24处于同一网络(如果不是同一网络，那么下表中目标ip为172.16.10.1,通过arp获取的是网关的mac)

| | 源mac | 目标mac | 源ip | 目标ip | 数据部分 |
| --- | :--- | :--- | :--- | :--- | :--- |
| 发送端主机 | 发送端mac | FF:FF:FF:FF:FF:FF | 172.16.10.10/24 | 172.16.10.11/24 | 数据 |

三：这个包会以广播的方式在发送端所处的子网内传输，所有主机接收后拆开包，发现目标ip为自己的，就响应，返回自己的mac

查看本机arp表的命令

```plain
Alexs-MacBook-Pro:~ alex$ arp -a
? (192.168.0.3) at 0:21:cc:65:52:f0 on en4 ifscope [ethernet]
? (192.168.0.64) at 68:f7:28:d0:4b:21 on en4 ifscope [ethernet]
? (192.168.0.233) at 84:d9:31:3:ae:8b on en4 ifscope [ethernet]
? (192.168.0.254) at 60:da:83:be:c2:5a on en4 ifscope [ethernet]
? (192.168.0.255) at (incomplete) on en4 ifscope [ethernet]
? (224.0.0.251) at 1:0:5e:0:0:fb on en4 ifscope permanent [ethernet]
```

**ICMP**

前面讲到了，IP协议并不是一个可靠的协议，它不保证数据被送达，那么，自然的，保证数据送达的工作应该由其他的模块来完成。其中一个重要的模块就是ICMP(网络控制报文)协议。

当传送IP数据包发生错误－－比如主机不可达，路由不可达等等，ICMP协议将会把错误信息封包，然后传送回给主机。给主机一个处理错误的机会.

我们一般主要用ICMP协议检测网络是否通畅，基于ICMP协议的工具主要有ping 和traceroute

_**ping**_

```plain
Alexs-MacBook-Pro:~ alex$ ping www.baidu.com
PING www.a.shifen.com (111.13.100.91): 56 data bytes
64 bytes from 111.13.100.91: icmp_seq=0 ttl=54 time=6.563 ms
64 bytes from 111.13.100.91: icmp_seq=1 ttl=54 time=6.320 ms
64 bytes from 111.13.100.91: icmp_seq=2 ttl=54 time=6.698 ms
64 bytes from 111.13.100.91: icmp_seq=3 ttl=54 time=6.445 ms
^C
--- www.a.shifen.com ping statistics ---
4 packets transmitted, 4 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 6.320/6.506/6.698/0.140 ms
```

ping这个单词源自声纳定位，而这个程序的作用也确实如此，它利用ICMP协议包来侦测另一个主机是否可达。原理是用类型码为0的ICMP发请 求，受到请求的主机则用类型码为8的ICMP回应。ping程序来计算间隔时间，并计算有多少个包被送达。用户就可以判断网络大致的情况。我们可以看到， ping给出来了传送的时间和TTL的数据。

_**traceroute**_

用来查看从当前主机到某地址一共经过多少跳路由

```plain
$ traceroute www.baidu.com
traceroute: Warning: www.baidu.com has multiple addresses; using 111.13.100.91
traceroute to www.a.shifen.com (111.13.100.91), 64 hops max, 52 byte packets
 1  192.168.0.254 (192.168.0.254)  0.458 ms  0.274 ms  0.246 ms
 2  122.71.64.1 (122.71.64.1)  2.006 ms  1.788 ms  1.626 ms
 3  * 222.35.254.253 (222.35.254.253)  2.024 ms  2.243 ms
 4  222.35.254.241 (222.35.254.241)  9.333 ms
    61.233.9.50 (61.233.9.50)  4.960 ms
    61.233.9.93 (61.233.9.93)  3.010 ms
 5  61.237.2.202 (61.237.2.202)  3.442 ms  3.497 ms
 ......
```

### 传输层（15分）
传输层的由来：网络层的ip帮我们区分子网，以太网层的mac帮我们找到主机，然后大家使用的都是应用程序，你的电脑上可能同时开启qq，暴风影音，迅雷等多个应用程序，

那么我们通过ip和mac找到了一台特定的主机，如何标识这台主机上的应用程序呢？答案就是端口，端口即应用程序与网卡关联的编号。

传输层功能：建立端口到端口的通信

补充：端口范围0-65535，0-1023为系统占用端口

传输层有两种协议，TCP和UDP,见下图

<!-- OCR_START -->
- 用户
- 进程
- 应用层
- TCP
- UDP
- 运输层
- ICMP
- IP
- IGMP
- 网络层
- ARP
- 硬件
- RARP
- 链路层
- 接口
- 媒体
<!-- OCR_END -->

#### tcp协议
可靠传输，TCP数据包没有长度限制，理论上可以无限长，但是为了保证网络的效率，通常TCP数据包的长度不会超过IP数据包的长度，以确保单个TCP数据包不必再分割。

| 以太网头 | ip 头 | tcp头 | 数据 |
| :--- | :--- | :--- | :--- |
| | | | |

> 为什么tcp是可靠的数据传输呢？
>
> **最可靠的方式就是只要不得到确认，就重新发送数据报，直到得到对方的确认为止。**
>

tcp报文

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

tcp的3次握手和4四挥手

![image_1c1phb5ao10jb183v1l3i1psgo6037.png-281.7kB][17]

#### udp协议
不可靠传输，”报头”部分一共只有8个字节，总长度不超过65,535字节，正好放进一个IP数据包。

| 以太网头 | ip头 | udp头 | 数据 |
| :--- | :--- | :--- | :--- |
| | | | |

总结

TCP协议虽然安全性很高，但是网络开销大，而UDP协议虽然没有提供安全机制，但是网络开销小，在现在这个网络安全已经相对较高的情况下，为了保证传输的速率，我们一般还是会优先考虑UDP协议！

[17]: [http://static.zybuluo.com/agocan/gbg90sa2fn94tkk3asobet6u/image_1c1phb5ao10jb183v1l3i1psgo6037.png](http://static.zybuluo.com/agocan/gbg90sa2fn94tkk3asobet6u/image_1c1phb5ao10jb183v1l3i1psgo6037.png)

# 6.3 Socket介绍
## 本节重点：
+ 让学生了解什么是socket
+ 让学生掌握socket常用接口方法

> **本节时长需控制在35-40分钟内**
>

### 引子(2分钟)
我们已经知道，假设我现在要写一个程序，给另一台计算机发数据，必须通过tcp/ip协议 ，但具体的实现过程是什么呢？我应该怎么操作才能把数据封装成tcp/ip的包，又执行什么指令才能把数据发到对端机器上呢? 不能只有世界观，没有方法论呀。。。此时，socket隆重登场，简而言之，socket这个东东干的事情，就是帮你把tcp/ip协议层的各种数据封装啦、数据发送、接收等通过代码已经给你封装好了，你只需要调用几行代码，就可以给别的机器发消息了。

### Socket介绍
#### 什么是socket?(5分钟)
Socket是应用层与TCP/IP协议族通信的中间软件抽象层，**它是一组接口**。在设计模式中，Socket其实就是一个门面模式，它把复杂的TCP/IP协议族隐藏在Socket接口后面，对用户来说，一组简单的接口就是全部。

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
- 媒体
<!-- OCR_END -->

socket起源于Unix，而Unix/[Linux](http://lib.csdn.net/base/linux) 基本哲学之一就是“一切皆文件”，都可以用“打开open –> 读写write/read –> 关闭close”模式 来操作。Socket就是该模式的一个实现，socket即是一种特殊的文件，一些socket函数就是对其进行的操作（读/写IO、打开、关闭）

你想给另一台计算机发消息，你知道他的IP地址，他的机器上同时运行着qq、迅雷、word、浏览器等程序，你想给他的qq发消息，那想一下，你现在只能通过ip找到他的机器，但如果让这台机器知道把消息发给qq程序呢？答案就是通过port,一个机器上可以有0-65535个端口，你的程序想从网络上收发数据，就必须绑定一个端口，这样，远程发到这个端口上的数据，就全会转给这个程序啦

<!-- OCR_START -->
| 排名 | 名称 | 名称 |
| --- | --- | --- |
| 80 | Ngnix | remote client |
| 22 | 10.23.22.35 + 37002 | SSH |
| hi约么? | 37002 | QQ |
<!-- OCR_END -->

#### Socket通信套路(10分钟)
当通过socket建立起2台机器的连接后，本质上socket只干2件事，一是收数据，一是发数据，没数据时就等着。

socket 建立连接的过程跟我们现实中打电话比较像，打电话必须是打电话方和接电话方共同完成的事情，我们分别看看他们是怎么建立起通话的

**接电话方：**

```plain
1.首先你得有个电话
2.你的电话要有号码
3.你的电话必须连上电话线
4.开始在家等电话
5.电话铃响了，接起电话，听到对方的声音
```

**打电话方：**

```plain
1.首先你得有个电话
2.输入你想拨打的电话
3.等待对方接听
4.say “hi 约么，我有七天酒店的打折卡噢~”
5.等待回应——》响应回应——》等待回应。。。。
```

**把它翻译成socket通信**

**接电话方(socket服务器端)：**

```plain
1.首先你得有个电话\(生成socket对象\)
2.你的电话要有号码\(绑定本机ip+port\)
3.你的电话必须连上电话线\(连网\)
4.开始在家等电话\(开始监听电话listen\)
5.电话铃响了，接起电话，听到对方的声音\(接受新连接\)
```

**打电话方(socket客户端)：**

```plain
1.首先你得有个电话\(生成socket对象\)
2.输入你想拨打的电话\(connect 远程主机ip+port\)
3.等待对方接听
4.say “hi 约么，我有七天酒店的打折卡噢~”\(send\(\) 发消息。。。\)
5.等待回应——》响应回应——》等待回应。。。。
```

<!-- OCR_START -->
- TCP服务器端
- socketO
- TCP客户端
- bind
- socket
- listen()
- acceptO
- connectO
- 建立连接
- 阻塞直到有客户端连接
- 请求数据
- write
- read)
- 处理请求
- 回应数据
- readO
- 结束连接
- close)
- closeO
<!-- OCR_END -->

### Socket套接字方法
#### **socket 实例类**(8-10分钟)
```plain
socket.socket(family=AF_INET, type=SOCK_STREAM, proto=0, fileno=None)
```

_**family(socket家族)**_

+ socket.AF_UNIX：用于本机进程间通讯，为了保证程序安全，两个独立的程序(进程)间是不能互相访问彼此的内存的，但为了实现进程间的通讯，可以通过创建一个本地的socket来完成
+ socket.AF_INET:(还有AF_INET6被用于ipv6，还有一些其他的地址家族，不过，他们要么是只用于某个平台，要么就是已经被废弃，或者是很少被使用，或者是根本没有实现，所有地址家族中，AF_INET是使用最广泛的一个，python支持很多种地址家族，但是由于我们只关心网络编程，所以大部分时候我么只使用AF_INET)

_**socket type类型**_

+ socket.SOCK_STREAM #for tcp
+ socket.SOCK_DGRAM #for udp
+ socket.SOCK_RAW #原始套接字，普通的套接字无法处理ICMP、IGMP等网络报文，而SOCK_RAW可以；其次，SOCK_RAW也可以处理特殊的IPv4报文；此外，利用原始套接字，可以通过IP_HDRINCL套接字选项由用户构造IP头。
+ socket.SOCK_RDM #是一种可靠的UDP形式，即保证交付数据报但不保证顺序。SOCK_RAM用来提供对原始协议的低级访问，在需要执行某些特殊操作时使用，如发送ICMP报文。SOCK_RAM通常仅限于高级用户或管理员运行的程序使用。
+ socket.SOCK_SEQPACKET #废弃了

> (Only SOCK_STREAM and SOCK_DGRAM appear to be generally useful.)
>

**proto=0** 请忽略，特殊用途

**fileno=None** 请忽略，特殊用途

#### 服务端套接字函数(2分钟)
+ s.bind() 绑定(主机,端口号)到套接字
+ s.listen() 开始TCP监听
+ s.accept() 被动接受TCP客户的连接,(阻塞式)等待连接的到来

#### 客户端套接字函数(2分钟)
+ s.connect() 主动初始化TCP服务器连接
+ s.connect_ex() connect()函数的扩展版本,出错时返回出错码,而不是抛出异常

#### 公共用途的套接字函数(3-5分钟)
+ s.recv() 接收数据
+ s.send() 发送数据(send在待发送数据量大于己端缓存区剩余空间时,数据丢失,不会发完，可后面通过实例解释)
+ s.sendall() 发送完整的TCP数据(本质就是循环调用send,sendall在待发送数据量大于己端缓存区剩余空间时,数据不丢失,循环调用send直到发完)
+ s.recvfrom() Receive data from the socket. The return value is a pair (bytes, address)
+ s.getpeername() 连接到当前套接字的远端的地址
+ s.close() 关闭套接字
+ socket.setblocking(flag) #True or False,设置socket为非阻塞模式，以后讲io异步时会用
+ socket.getaddrinfo(host, port, family=0, type=0, proto=0, flags=0) 返回远程主机的地址信息，例子 socket.getaddrinfo('luffycity.com',80)
+ socket.getfqdn() 拿到本机的主机名
+ socket.gethostbyname() 通过域名解析ip地址

# 6.4 Socket 代码实例
## 本节重点：
+ 使学生掌握基本的socket tcp / udp 通信实例
+ 让学生可通过socket写一个简单的聊天的例子

> **本节时长需控制在70-80分钟内**
>

### 基本Socket例子(10-15分钟)
做了这么久的铺垫，是时候该与远方的她say hi啦

Server

```plain
# Echo server program
import socket
HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 50007              # Arbitrary non-privileged port
sock_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock_server.bind((HOST, PORT))
sock_server.listen(1) #开始监听，1代表在允许有一个连接排队，更多的新连接连进来时就会被拒绝
conn, addr = sock_server.accept() #阻塞直到有连接为止，有了一个新连接进来后，就会为这个请求生成一个连接对象
with conn:
    print('Connected by', addr)
    while True:
        data = conn.recv(1024) #接收1024个字节
        if not data: break #收不到数据，就break
        conn.sendall(data) #把收到的数据再全部返回给客户端
```

Client

```plain
# Echo client program
import socket
HOST = 'localhost'    # The remote host
PORT = 50007              # The same port as used by the server
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((HOST, PORT))
client.sendall(b'Hello, world')
data = client.recv(1024)
print('Received',data)
```

先启动server端，再启动client端，看结果

<!-- OCR_START -->
[Alexs-MacBook-Pro:socket学习
alex$
Alexs-MacBook-Pro:socket学习alex$
Alexs-MacBook-Pro:socket学习alex$python3basic_sample_server1.py
Connected by('127.0.0.1'，49388)
Received b'Hello, world'
化网络编程day12orm
<!-- OCR_END -->

> 此时一定要停下来，让学生自己写一遍！
>

### 循环收发数据(15-20分钟)
第一次接触就这么交待了，只说了一句话，感觉不够过瘾，如何实现更多的交互呢？简单，只需要让客户端不断的发，服务端不断的收就可以了，写个循环搞定

server

```plain
# Echo server program
import socket
HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 50007              # Arbitrary non-privileged port
sock_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock_server.bind((HOST, PORT))
sock_server.listen(1) #开始监听，1代表在允许有一个连接排队，更多的新连接连进来时就会被拒绝
conn, addr = sock_server.accept() #阻塞直到有连接为止，有了一个新连接进来后，就会为这个请求生成一个连接对象
with conn:
    print('Connected by', addr)
    while True:
        data = conn.recv(1024) #接收1024个字节
        print("server recv:",conn.getpeername(), data.decode())
        if not data: break #收不到数据，就break
        conn.sendall(data) #把收到的数据再全部返回给客户端
```

client

```plain
# Echo client program
import socket
HOST = 'localhost'    # The remote host
PORT = 50007              # The same port as used by the server
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((HOST, PORT))
while True: 
    msg = input(">>>:").strip()
    if len(msg) == 0:continue
    client.sendall(msg.encode()) #发送用户输入的数据,必须是bytes模式
    data = client.recv(1024)
    print('Received',data.decode()) #收到服务器的响应后，decode一下
```

结果

<!-- OCR_START -->
- [Alexs-MacBook-Pro:socket学 习 alex$ python3 basic_sample_server2.py
- [Alexs-MacBook-Pro:socket学习 alex$ python3 basic_sample_client2.p)
- Connected by ('127.0.0.1',
- 49576)
- :Hi
- server recv:
- ('127.0.0.1',
- 49576) Hi
- Received Hi
- 49576）杠娘么?
- :杠娘么?
- 海峰在家么？
- Received 杠娘么?
- 那我去找你！
- 洗干净
- Received 海峰在家么?
- server recv: ('127.0.0.1',
- Alexs-MacBook-Pro:socket学 习 alex$
- Received 那我去找你！
- :渊
- Illi External Libraries
- ：先洗干净
- Received 洗王 净
- :^cTraceback (most recent call last):
- File "basic_sample_client2.py"
- line 12,
- in <module>
- msg = input(">>>:").strip()
- KeyboardInterrupt
- CTRL-C 退出
<!-- OCR_END -->

> 此时一定要停下来，让学生自己写一遍！
>

### 简单聊天软件(5分钟)
为什么上面的那个例子里，我跟杠娘说什么，她就回复什么，这哪叫聊天呀，这种事需要双方尽全力配合才行呀，那就让服务端也能说话

Server

```plain
import socket
HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 50007              # Arbitrary non-privileged port
sock_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock_server.bind((HOST, PORT))
sock_server.listen(1) #开始监听，1代表在允许有一个连接排队，更多的新连接连进来时就会被拒绝
conn, addr = sock_server.accept() #阻塞直到有连接为止，有了一个新连接进来后，就会为这个请求生成一个连接对象
with conn:
    print('Connected by', addr)
    while True:
        data = conn.recv(1024) #接收1024个字节
        print("recv from Alex:",conn.getpeername(), data.decode())
        if not data: break #收不到数据，就break
        response = input(">>>").strip()
        conn.send(response.encode())
        print("send to alex:",response)
```

client不需要做更改，直接 看结果

<!-- OCR_START -->
- [Alexs-MacBook-Pro:socket学习alex$ python3 basic_sample_server3.py
- Connected by ('127.0.0.1'，49761)
- : Hi
- recv from Alex: （'127.0.0.1'， 49761) Hi
- hey
- :杠娘
- send to alex: hey
- Received Alex
- :海峰在么
- Alex 哥
- Received 不在家，
- 去讲课了
- send to alex:
- :哈，我知道，
- 我安排的
- recvfromAlex:（'127.0.0.1'，49761）海峰在么
- Received哈哈
- 他 不在家，
- :我去找你吧
- 不在家，
- Received好呀呀
- recv from Alex: ('127.0.0.1',4
- 49761）哈，我知道，我安排的
- :10分钟到
- v>v品
- 这么快，那我去洗澡澡等你
- send to alex:哈哈
- :mua.
- recvfromAlex：（'127.0.0.1'，49761）我去找你吧
- 好呀呀
- sendtoalex:好呀呀
- recv from Alex:（'127.0.0.1'，49761）10分钟到
- 哈，这么快，那我去洗澡澡等你
- vvv
- ll External Libraries
<!-- OCR_END -->

冷静的海峰玩了一会这个程序说，Alex你这个有bug,双方只能一来一往的说话，如果你想连续发2句话是不行的，就卡住了。

对，海峰你说的没错，之所以连续发第2次时会卡住 ，是因为你发了一条消息后，就去调用recv方法接收服务器的响应了，在服务器端返回消息之前，这个recv(1024)方法是阻塞的，如果想允许此时还能再发消息给服务器端，就需要再单独启动一个线程，只负责发消息。当然这就得等我们掌握了线程知识再学啦，此处不多赘述。

> 此处补充下listen(1)的演示，就是启动多个客户端连接同一个服务端，发现服务端只能同时处理一个请求
>

### 聊天软件升级版(20-25分钟)
刚才在聊天的时候，你会发现，服务端(杠娘)在服务客户端(Alex)的时候，其它人如果也想跟杠娘连接是处于排队状态，然后等Alex完事并断开后，下一个人就跟上，但实际情况是客户端一断开，服务端也跟着断了。

为什么会断呢？因为服务端以下代码的意思是， 如果收不到数据，就跳出循环，就断开了呀

```plain
conn, addr = sock_server.accept() #阻塞直到有连接为止，有了一个新连接进来后，就会为这个请求生成一个连接对象
with conn:
    print('Connected by', addr)
    while True:
        data = conn.recv(1024) #接收1024个字节
        print("recv from Alex:",conn.getpeername(), data.decode())
        if not data: break #收不到数据，就break ， 就是它干的
        response = input(">>>").strip()
        conn.send(response.encode())
        print("send to alex:",response)
```

想实现一个客户端断开后，可以立刻接入另外一个客户端的话，怎么办呢？只需再在外层加个循环

```plain
while True: #最外层loop 
    conn, addr = sock_server.accept() #阻塞直到有连接为止，有了一个新连接进来后，就会为这个请求生成一个连接对象
    #为何把上面这句话也包含在循环里？
    print("来了个新客人",conn.getpeername() )
    with conn:
        print('Connected by', addr)
        while True:
            data = conn.recv(1024) #接收1024个字节
            print("recv from :",conn.getpeername(), data.decode())
            if not data: break #收不到数据，就break
            conn.send(data.upper())
            print("send to alex:",data)
```

break跳出后就回到大while那层

<!-- OCR_START -->
```text
sock_server.listen（1）_#开始监听，1代表在允许有一个连接排队，更多的新连接连进来时就会被拒绝
while True:
conn，addr=sock_server.accept（）#阻塞直到有连接为止，有了一个新连接进来后，就会为这个请求
#为何把上面这句话也包含在循环里？
print（"来了个新客人",conn·getpeername(）)
with conn:
print('Connected by', addr)
while True:
data=conn.recv（1024）#接收1024个字节
print("recv from :",conn.getpeername(), data.decode())
ifnotdata：break #收不到数据，就break
conn.send(data.upper())
print("send to alex:",data)
```
<!-- OCR_END -->

> 此时一定要停下来，让学生自己写一遍！
>

**问题：**

有的同学在重启服务端时可能会遇到

<!-- OCR_START -->
```text
Traceback(most recentcall last):
File"/Users/iieli/testl/test/服务端.py"，line7，in<module>
phone.bind(('127.0.0.1'.8080))
0SError:[Errno48]
Addressalready
inuse
```
<!-- OCR_END -->

这个是由于你的服务端仍然存在四次挥手的time_wait状态在占用地址（如果不懂，请深入研究1.tcp三次握手，四次挥手 2.syn洪水攻击 3.服务器高并发情况下会有大量的time_wait状态的优化方法）

解决方法1：

```plain
sock_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock_server.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1) #一行代码搞定，写在bind之前
sock_server.bind((HOST, PORT))
```

解决方法2：

```plain
发现系统存在大量TIME_WAIT状态的连接，通过调整linux内核参数解决，
vi /etc/sysctl.conf
编辑文件，加入以下内容：
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
然后执行 /sbin/sysctl -p 让参数生效。
net.ipv4.tcp_syncookies = 1 表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse = 1 表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_tw_recycle = 1 表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。
net.ipv4.tcp_fin_timeout 修改系統默认的 TIMEOUT 时间
```

> 此方法全栈班的学生可直接忽略
>

### UDP实例(15-20分钟)
udp 不需要经过3次握手和4次挥手，不需要提前建立连接，直接发数据就行。

server端

```plain
import socket
ip_port=('127.0.0.1',9000)
BUFSIZE=1024
udp_server_client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM) #udp类型
udp_server_client.bind(ip_port)
while True:
    msg,addr=udp_server_client.recvfrom(BUFSIZE)
    print("recv ",msg,addr)
    udp_server_client.sendto(msg.upper(),addr)
```

client端

```plain
import socket
ip_port = ('127.0.0.1',9000)
BUFSIZE = 1024
udp_server_client = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
while True:
    msg=input('>>: ').strip()
    if not msg:continue
    udp_server_client.sendto(msg.encode('utf-8'),ip_port)
    back_msg,addr = udp_server_client.recvfrom(BUFSIZE)
    print(back_msg.decode('utf-8'),addr)
```

演示
<!-- OCR_START -->
[Alexs-MacBook-Pro:socket学习 alex$ python3 udp_client_1.py
: hey
HEY ('127.0.0.1'，9000)
：杠娘么
recv
b'hey'('127.0.0.1'，49400)
杠娘么（'127.0.0.1′，9000)
recvb'\xe5\xa4\xba'('127.0.0.1'，49400)
：我又想你了啦
^CTraceback (most recent call last):
我又想你了啦（'127.0.0.1＇，9000)
File "udp_server_1.py", line 12, in <module>
：我是Alex呀
msg,addr=udp_server_client.recvfrom(BUFSIZE)
('127.0.0.1'，9000)
KeyboardInterrupt
：我一会去找你呀
[Alexs-MacBook-Pro:socket学习 alex$ python3 udp_server_1.py
会去找你呀（'127.0.0.1′，
9000)
recv 1('127.0.0.1'， 57816)
：哈哈哈，
海峰在上课！:)
哈哈哈海峰在上课！：）（'127.0.0.1'，9000)
[Alexs-MacBook-Pro:socket学习 alex$
socket学习 —Python udp_client_1.py — 80x24
~/Documents/work/PyProjects/python基础/socket学习 — Python udp_client_1.py
[Alexs-MacBook-Pro:socket学习alex$ python3ud
server_l.py
[Alexs-MacBook-Pro:socket学习
alex$
recvney (127.0.0.1', 51332)
('127.0.0.1'，51332)
我又想你了啦（'127.0.0.1'，51332）
('127.0.0.1'，
51332)
49275
媳妇（*127.0.0.1'，52095)
我海峰（'127.0.0.1'，
52095)
晚上想吃什么
('127.0.0.1'，52095)
媳妇
sbAlex老安排我讲课（'127.0.0.1'，52095）
媳妇（'127.0.0.1'，9000)
他自己一到处去浪
：我是海峰
妈蛋的。
我海峰（127.0.0.1′，9000)
会丢找你呀
哈哈哈海峰在上课！：）（'127.0.0.1'，
晚上想吃什么（'127.0.0.1′，
你怎么不回消息（'127.0.0.1'，52095）
：sb Alex老安排我讲课
SB ALEX老安排我讲课（'127.0.0.1′，9000)
：↑
他自己一天去到处去浪
自动化网络编程day9
他自己一到处去浪（127.0.0.1′，9000)
自动化网络编程day10异步io
自动化网络编程day12orm
：你怎么不回消息
自动化网络编程redis&数据库
你怎么不回消息（'127.0.0.1＇，9000)
°9: Version Control
16:1L
LF
<!-- OCR_END -->

> 此时一定要停下来，让学生自己写一遍！
>

### **TCP VS UDP(5分钟)**
**tcp基于链接通信**

+ 基于链接，则需要listen（backlog），指定连接池的大小
+ 基于链接，必须先运行的服务端，然后客户端发起链接请求
+ 对于mac系统：如果一端断开了链接，那另外一端的链接也跟着完蛋recv将不会阻塞，收到的是空(解决方法是：服务端在收消息后加上if判断，空消息就break掉通信循环)
+ 对于windows/linux系统：如果一端断开了链接，那另外一端的链接也跟着完蛋recv将不会阻塞，收到的是空(解决方法是：服务端通信循环内加异常处理，捕捉到异常后就break掉通讯循环)

**udp无链接**

+ 无链接，因而无需listen（backlog），更加没有什么连接池之说了
+ 无链接，udp的sendinto不用管是否有一个正在运行的服务端，可以己端一个劲的发消息，只不过数据丢失
+ recvfrom收的数据小于sendinto发送的数据时，在mac和linux系统上数据直接丢失，在windows系统上发送的比接收的大直接报错
+ 只有sendinto发送数据没有recvfrom收数据，数据丢失

# 6.5 粘包现象与解决方案
## 本节重点：
+ 使学生了解粘包原理
+ 让学生掌握粘包解决方案

> **本节时长需控制在70-80分钟内**
>

### 简单远程执行命令程序开发(30分钟)
是时候用户socket干点正事呀，我们来写一个远程执行命令的程序，写一个socket client端在windows端发送指令，一个socket server在Linux端执行命令并返回结果给客户端

执行命令的话，肯定是用我们学过的subprocess模块啦，但**注意注意注意：**

```plain
res = subprocess.Popen(cmd.decode('utf-8'),shell=True,stderr=subprocess.PIPE,stdout=subprocess.PIPE)
```

命令结果的编码是以当前所在的系统为准的，如果是windows，那么**res.stdout.read()读出的就是GBK编码的**，在接收端需**要用GBK解码，且只能从管道里读一次结果**

_**ssh server**_

```plain
import socket
import subprocess
ip_port = ('127.0.0.1', 8080)
tcp_socket_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcp_socket_server.bind(ip_port)
tcp_socket_server.listen(5)
while True:
    conn, addr = tcp_socket_server.accept()
    print('客户端', addr)
    while True:
        cmd = conn.recv(1024)
        if len(cmd) == 0: break
        print("recv cmd",cmd)
        res = subprocess.Popen(cmd.decode('utf-8'), shell=True,
                               stdout=subprocess.PIPE,
                               stdin=subprocess.PIPE,
                               stderr=subprocess.PIPE)
        stderr = res.stderr.read()
        stdout = res.stdout.read()
        print("res length",len(stdout))
        conn.send(stderr)
        conn.send(stdout)
```

_**ssh client**_

```plain
import socket
ip_port = ('127.0.0.1', 8080)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
res = s.connect_ex(ip_port)
while True:
    msg = input('>>: ').strip()
    if len(msg) == 0: continue
    if msg == 'quit': break
    s.send(msg.encode('utf-8'))
    act_res = s.recv(1024)
    print(act_res.decode('utf-8'), end='')
```

尝试执行ls、pwd命令,你惊喜的发现，拿到了正确的结果！

but 莫开心太早，此时执行一个结果比较长的命令，比如top -bn 1， 你发现依然可以拿到结果，但如果再执行一条df -h的话，就发现，你拿到并不是df命令的结果，而是上一条top命令的部分结果。为啥捏？为啥捏？为啥捏？

是因为，top命令的结果比较长，但客户端只recv(1024), 可结果比1024长呀，那怎么办，只好在服务器端的IO缓冲区里把客户端还没收走的暂时存下来，等客户端下次再来收，所以当客户端第2次调用recv(1024)就会首先把上次没收完的数据先收下来，再收df命令的结果。

那怎么解决呢？ 有些同学说，直接把recv(1024)改大不就好了，改成5000\10000或whatever. 可我的亲，这么干的话，并不能解决实际问题，因为你不可能提前知道对方返回的结果数据大下，无论你改成多大，对方的结果都有可能比你设置的大，另外这个recv并不是真的可以随便改特别大的，有关部门建议的不要超过8192，再大反而会出现影响收发速度和不稳定的情况

同志们，这个现象叫做粘包，就是指两次结果粘到一起了。它的发生主要是因为socket缓冲区导致的，来看一下

<!-- OCR_START -->
- 服务端
- 客户端
- socket服务端程序
- 用户态
- socket客户端程序
- 缓存
- 内核态
- 网卡
- internet字节流
<!-- OCR_END -->

你的程序实际上无权直接操作网卡的，你操作网卡都是通过操作系统给用户程序暴露出来的接口，那每次你的程序要给远程发数据时，其实是先把数据从用户态copy到内核态，这样的操作是耗资源和时间的，频繁的在内核态和用户态之前交换数据势必会导致发送效率降低， 因此socket 为提高传输效率，发送方往往要收集到足够多的数据后才发送一次数据给对方。若连续几次需要send的数据都很少，通常TCP socket 会根据优化算法把这些数据合成一个TCP段后一次发送出去，这样接收方就收到了粘包数据。

**粘包问题只存在于TCP中，Not UDP**

还是看上图，发送端可以是一K一K地发送数据，而接收端的应用程序可以两K两K地提走数据，当然也有可能一次提走3K或6K数据，或者一次只提走几个字节的数据，也就是说，应用程序所看到的数据是一个整体，或说是一个流（stream），一条消息有多少字节对应用程序是不可见的，因此TCP协议是面向流的协议，这也是容易出现粘包问题的原因。而UDP是面向消息的协议，每个UDP段都是一条消息，应用程序必须以消息为单位提取数据，不能一次提取任意字节的数据，这一点和TCP是很不同的。怎样定义消息呢？可以认为对方一次性write/send的数据为一个消息，需要明白的是当对方send一条信息的时候，无论底层怎样分段分片，TCP协议层会把构成整条消息的数据段排序完成后才呈现在内核缓冲区。

例如基于tcp的套接字客户端往服务端上传文件，发送时文件内容是按照一段一段的字节流发送的，在接收方看了，根本不知道该文件的字节流从何处开始，在何处结束

所谓粘包问题主要还是因为接收方不知道消息之间的界限，不知道一次性提取多少字节的数据所造成的。

**总结**

1. TCP（transport control protocol，传输控制协议）是面向连接的，面向流的，提供高可靠性服务。收发两端（客户端和服务器端）都要有一一成对的socket，因此，发送端为了将多个发往接收端的包，更有效的发到对方，使用了优化方法（Nagle算法），将多次间隔较小且数据量小的数据，合并成一个大的数据块，然后进行封包。这样，接收端，就难于分辨出来了，必须提供科学的拆包机制。 即面向流的通信是无消息保护边界的。
2. UDP（user datagram protocol，用户数据报协议）是无连接的，面向消息的，提供高效率服务。不会使用块的合并优化算法，, 由于UDP支持的是一对多的模式，所以接收端的skbuff(套接字缓冲区）采用了链式结构来记录每一个到达的UDP包，在每个UDP包中就有了消息头（消息来源地址，端口等信息），这样，对于接收端来说，就容易进行区分处理了。 **即面向消息的通信是有消息保护边界的。**
3. **tcp是基于数据流的，于是收发的消息不能为空，这就需要在客户端和服务端都添加空消息的处理机制，防止程序卡住，而udp是基于数据报的，即便是你输入的是空内容（直接回车），那也不是空消息，udp协议会帮你封装上消息头，实验略**

#### 基于UDP的命令执行程序(10分钟)
上面说了，udp不存在粘包问题，我们看一下实例

udp server

```plain
import socket
import subprocess
ip_port = ('127.0.0.1', 9003)
bufsize = 1024
udp_server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udp_server.bind(ip_port)
while True:
    # 收消息
    cmd, addr = udp_server.recvfrom(bufsize)
    print('用户命令----->', cmd,addr)
    # 逻辑处理
    res = subprocess.Popen(cmd.decode('utf-8'), shell=True, stderr=subprocess.PIPE, stdin=subprocess.PIPE,
                           stdout=subprocess.PIPE)
    stderr = res.stderr.read()
    stdout = res.stdout.read()
    # 发消息
    udp_server.sendto(stdout + stderr, addr)
udp_server.close()
```

udp client

```plain
from socket import *
import time
ip_port = ('127.0.0.1', 9003)
bufsize = 1024
udp_client = socket(AF_INET, SOCK_DGRAM)
while True:
    msg = input('>>: ').strip()
    if len(msg) == 0:
        continue
    udp_client.sendto(msg.encode('utf-8'), ip_port)
    data, addr = udp_client.recvfrom(bufsize)
    print(data.decode('utf-8'), end='')
```

### 粘包的解决办法(35分钟)
问题的根源在于，接收端不知道发送端将要传送的字节流的长度，所以解决粘包的方法就是围绕，如何让发送端在发送数据前，把自己将要发送的字节流总大小让接收端知晓，然后接收端来一个死循环接收完所有数据

#### 普通青年版
服务器端

```plain
import socket,subprocess
ip_port=('127.0.0.1',8080)
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(ip_port)
s.listen(5)
while True:
    conn,addr=s.accept()
    print('客户端',addr)
    while True:
        msg=conn.recv(1024)
        if not msg:break
        res=subprocess.Popen(msg.decode('utf-8'),shell=True,\
                            stdin=subprocess.PIPE,\
                         stderr=subprocess.PIPE,\
                         stdout=subprocess.PIPE)
        err=res.stderr.read()
        if err:
            ret=err
        else:
            ret=res.stdout.read()
        data_length=len(ret)
        conn.send(str(data_length).encode('utf-8'))
        data=conn.recv(1024).decode('utf-8')
        if data == 'recv_ready':
            conn.sendall(ret)
    conn.close()
```

客户端

```plain
import socket,time
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
res=s.connect_ex(('127.0.0.1',8080))
while True:
    msg=input('>>: ').strip()
    if len(msg) == 0:continue
    if msg == 'quit':break
    s.send(msg.encode('utf-8'))
    length=int(s.recv(1024).decode('utf-8'))
    s.send('recv_ready'.encode('utf-8'))
    send_size=0
    recv_size=0
    data=b''
    while recv_size < length:
        data+=s.recv(1024)
        recv_size+=len(data) #为什么不直接写1024？
    print(data.decode('utf-8'))
```

> 为何low？
>
> 程序的运行速度远快于网络传输速度，所以在发送一段字节前，先用send去发送该字节流长度，这种方式会放大网络延迟带来的性能损耗
>

刚才上面 在发送消息之前需先发送消息长度给对端，还必须要等对端返回一个ready收消息的确认，不等到对端确认就直接发消息的话，还是会产生粘包问题(承载消息长度的那条消息和消息本身粘在一起)。 有没有优化的好办法么？

#### 文艺青年版一
思考一个问题，为什么不能在发送了消息长度(称为消息头head吧)给对端后，立刻发消息内容(称为body吧)，是因为怕head 和body 粘在一起，所以通过等对端返回确认来把两条消息中断开。

可不可以直接发head + body,但又能让对端区分出哪个是head，哪个是body呢？我靠、我靠，感觉智商要涨了。

想到了，把head设置成定长的呀，这样对端只要收消息时，先固定收定长的数据，head里写好，后面还有多少是属于这条消息的数据，然后直接写个循环收下来不就完了嘛！唉呀妈呀，我真机智。

可是、可是如何制作定长的消息头呢？假设你有2条消息要发送，第一条消息长度是 3000个字节，第2条消息是200字节。如果消息头只包含消息长度的话，那两个消息的消息头分别是

```plain
len(msg1) = 4000 = 4字节
len(msg2) = 200 = 3字节
```

你的服务端如何完整的收到这个消息头呢？是recv(3)还是recv(4)服务器端怎么知道？用尽我所有知识，我只能想到拼接字符串的办法了，打比方就是设置消息头固定100字节长，不够的拿空字符串去拼接。

server

```plain
import socket,json
import subprocess
ip_port = ('127.0.0.1', 8080)
tcp_socket_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcp_socket_server.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1) #一行代码搞定，写在bind之前
tcp_socket_server.bind(ip_port)
tcp_socket_server.listen(5)
def pack_msg_header(header,size):
    bytes_header = bytes(json.dumps(header),encoding="utf-8")
    fill_up_size = size -  len(bytes_header)
    print("need to fill up ",fill_up_size)
    header['fill'] = header['fill'].zfill(fill_up_size)
    print("new header",header)
    bytes_new_header = bytes(bytes(json.dumps(header),encoding="utf-8"))
    return bytes_new_header
while True:
    conn, addr = tcp_socket_server.accept()
    print('客户端', addr)
    while True:
        cmd = conn.recv(1024)
        if len(cmd) == 0: break
        print("recv cmd",cmd)
        res = subprocess.Popen(cmd.decode('utf-8'), shell=True,
                               stdout=subprocess.PIPE,
                               stdin=subprocess.PIPE,
                               stderr=subprocess.PIPE)
        stderr = res.stderr.read()
        stdout = res.stdout.read()
        print("res length",len(stdout))
        msg_header = {
            'length':len(stdout + stderr),
            'fill':''
        }
        packed_header = pack_msg_header(msg_header,100)
        print("packed header size",packed_header,len(packed_header))
        conn.send(packed_header)
        conn.send(stdout + stderr)
```

client

```plain
import socket
import json
ip_port = ('127.0.0.1', 8080)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
res = s.connect_ex(ip_port)
while True:
    msg = input('>>: ').strip()
    if len(msg) == 0: continue
    if msg == 'quit': break
    s.send(msg.encode('utf-8'))
    response_msg_header = s.recv(100).decode("utf-8")
    response_msg_header_data = json.loads(response_msg_header)
    msg_size = response_msg_header_data['length']
    res = s.recv(msg_size)
    print("received res size ",len(res))
    print(res.decode('utf-8'), end='')
```

#### 文艺青年版二
为字节流加上自定义固定长度报头也可以借助于第三方模块struct，用法为

```plain
import json,struct
#假设通过客户端上传1T:1073741824000的文件a.txt
#为避免粘包,必须自定制报头
header={'file_size':1073741824000,'file_name':'/a/b/c/d/e/a.txt','md5':'8f6fbf8347faa4924a76856701edb0f3'} #1T数据,文件路径和md5值
#为了该报头能传送,需要序列化并且转为bytes
head_bytes=bytes(json.dumps(header),encoding='utf-8') #序列化并转成bytes,用于传输
#为了让客户端知道报头的长度,用struck将报头长度这个数字转成固定长度:4个字节
head_len_bytes=struct.pack('i',len(head_bytes)) #这4个字节里只包含了一个数字,该数字是报头的长度
#客户端开始发送
conn.send(head_len_bytes) #先发报头的长度,4个bytes
conn.send(head_bytes) #再发报头的字节格式
conn.sendall(文件内容) #然后发真实内容的字节格式
#服务端开始接收
head_len_bytes=s.recv(4) #先收报头4个bytes,得到报头长度的字节格式
x=struct.unpack('i',head_len_bytes)[0] #提取报头的长度
head_bytes=s.recv(x) #按照报头长度x,收取报头的bytes格式
header=json.loads(json.dumps(header)) #提取报头
#最后根据报头的内容提取真实的数据,比如
real_data_len=s.recv(header['file_size'])
s.recv(real_data_len)
```

使用struct模块实现方式如下

server

```plain
import socket,struct,json
import subprocess
phone=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
phone.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1) #就是它，在bind前加
phone.bind(('127.0.0.1',8080))
phone.listen(5)
while True:
    conn,addr=phone.accept()
    while True:
        cmd=conn.recv(1024)
        if not cmd:break
        print('cmd: %s' %cmd)
        res=subprocess.Popen(cmd.decode('utf-8'),
                             shell=True,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
        err=res.stderr.read()
        print(err)
        if err:
            back_msg=err
        else:
            back_msg=res.stdout.read()
        headers={'data_size':len(back_msg)}
        head_json=json.dumps(headers)
        head_json_bytes=bytes(head_json,encoding='utf-8')
        conn.send(struct.pack('i',len(head_json_bytes))) #先发报头的长度
        conn.send(head_json_bytes) #再发报头
        conn.sendall(back_msg) #在发真实的内容
    conn.close()
```

client

```plain
from socket import *
import struct,json
ip_port=('127.0.0.1',8080)
client=socket(AF_INET,SOCK_STREAM)
client.connect(ip_port)
while True:
    cmd=input('>>: ')
    if not cmd:continue
    client.send(bytes(cmd,encoding='utf-8'))
    head=client.recv(4) #先收4个bytes，这里4个bytes里包含了报头的长度
    head_json_len=struct.unpack('i',head)[0] #解出报头的长度
    head_json=json.loads(client.recv(head_json_len).decode('utf-8')) #拿到报头
    data_len=head_json['data_size'] #取出报头内包含的信息
    #开始收数据
    recv_size=0
    recv_data=b''
    while recv_size < data_len:
        recv_data+=client.recv(1024)
        recv_size=len(recv_data)
    print(recv_data.decode('utf-8'))
    #print(recv_data.decode('gbk')) #windows默认gbk编码
```

# 6.6 通过socket发送文件
## 本节重点：
+ 让学生掌握利用socket收发文件的方法

> **本节时长需控制在45分钟内**
>

### 通过socket收发文件软件开发(45分钟)
收发收发文件与远程执行命令的程序原理是一摸一样的，比如下载文件的过程：

```plain
1、客户端提交命令
2、服务端接收命令，解析，执行下载文件的方法，即以读的方式打开文件，for循环读出文件的一行行内容，然后send给客户端
3、客户端以写的方式打开文件，将接收的内容写入文件中
```

参照上一小节文艺青年实现版二，示范代码如下

服务端实现

```plain
import socket
import struct
import json
import subprocess
import os
class MYTCPServer:
    address_family = socket.AF_INET
    socket_type = socket.SOCK_STREAM
    allow_reuse_address = False
    max_packet_size = 8192
    coding='utf-8'
    request_queue_size = 5
    server_dir='file_upload'
    def __init__(self, server_address, bind_and_activate=True):
        """Constructor.  May be extended, do not override."""
        self.server_address=server_address
        self.socket = socket.socket(self.address_family,
                                    self.socket_type)
        if bind_and_activate:
            try:
                self.server_bind()
                self.server_activate()
            except:
                self.server_close()
                raise
    def server_bind(self):
        """Called by constructor to bind the socket.
        """
        if self.allow_reuse_address:
            self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.socket.bind(self.server_address)
        self.server_address = self.socket.getsockname()
    def server_activate(self):
        """Called by constructor to activate the server.
        """
        self.socket.listen(self.request_queue_size)
    def server_close(self):
        """Called to clean-up the server.
        """
        self.socket.close()
    def get_request(self):
        """Get the request and client address from the socket.
        """
        return self.socket.accept()
    def close_request(self, request):
        """Called to clean up an individual request."""
        request.close()
    def run(self):
        while True:
            self.conn,self.client_addr=self.get_request()
            print('from client ',self.client_addr)
            while True:
                try:
                    head_struct = self.conn.recv(4)
                    if not head_struct:break
                    head_len = struct.unpack('i', head_struct)[0]
                    head_json = self.conn.recv(head_len).decode(self.coding)
                    head_dic = json.loads(head_json)
                    print(head_dic)
                    #head_dic={'cmd':'put','filename':'a.txt','filesize':123123}
                    cmd=head_dic['cmd']
                    if hasattr(self,cmd):
                        func=getattr(self,cmd)
                        func(head_dic)
                except Exception:
                    break
    def put(self,args):
        file_path=os.path.normpath(os.path.join(
            self.server_dir,
            args['filename']
        ))
        filesize=args['filesize']
        recv_size=0
        print('----->',file_path)
        with open(file_path,'wb') as f:
            while recv_size < filesize:
                recv_data=self.conn.recv(self.max_packet_size)
                f.write(recv_data)
                recv_size+=len(recv_data)
                print('recvsize:%s filesize:%s' %(recv_size,filesize))
tcpserver1=MYTCPServer(('127.0.0.1',8080))
tcpserver1.run()
```

客户端实现

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

## 6.7本章总结
### 练习题
1. 什么是C/S架构？
2. 互联网协议是什么？分别介绍五层协议中每一层的功能？
3. 基于tcp协议通信，为何建立链接需要三次握手，而断开链接却需要四次挥手
4. 为何基于tcp协议的通信比基于udp协议的通信更可靠？
5. ‍流式协议指的是什么协议，数据报协议指的是什么协议？
6. 什么是socket？简述基于tcp协议的套接字通信流程
7. 什么是粘包？ socket 中造成粘包的原因是什么？ 哪些情况会发生粘包现象？
8. 基于socket开发一个聊天程序，实现两端互相发送和接收消息
9. 基于tcp socket，开发简单的远程命令执行程序，允许用户执行命令，并返回结果
10. 基于tcp协议编写简单FTP程序，实现上传、下载文件功能，并解决粘包问题
11. 基于udp协议编写程序，实现功能
    1. 执行指定的命令，让客户端可以查看服务端的时间
    2. 执行指定的命令，让客户端可以与服务的的时间同步

### 作业
题目：开发一个支持多用户同时在线的FTP程序

要求：

1. 用户加密认证
2. 允许同时多用户登录（用到并发编程的知识，选做）
3. 每个用户有自己的家目录，且只能访问自己的家目录
4. 对用户进行磁盘配额，每个用户的可用空间不同（选做）
5. 允许用户在ftp server上随意切换目录
6. 允许用户查看当前目录下的文件
7. 允许上传和下载文件，并保证文件的一致性
8. 文件传输过程中显示进度条
9. 附加：支持文件的断点续传（选做）
10. 开发的程序需符合PEP8开发规范，及专业的生产软件设计规范，包括目录、代码命名、功能接口等

> 更新: 2021-01-15 10:08:50  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/wc94o9>