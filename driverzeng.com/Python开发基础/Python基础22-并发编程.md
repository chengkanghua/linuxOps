# Python基础22-并发编程

## Python基础22-并发编程

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(2) 评论(0)

* [进程介绍](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_0)
* [计算机的发展史](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_1)
* [并发、并行、串行](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_2)
* [进程的创建（了解）](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_3)
* [进程的状态](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_4)
* [同步异步 & 阻塞非阻塞](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_5)
* [进程实现并发（了解）](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_6)
* [开启进程的两种方式](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_7)
* [join方法](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_8)
* [pid方法](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_9)
* [守护进程](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_10)
* [互斥锁](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_11)
* [进程间通信IPC](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_12)
* [生产者消费者模型](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_13)
* [线程介绍](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_14)
* [守护线程](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_15)
* [线程互斥锁](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_16)
* [GIL全局解释器锁](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_17)
* [GIL与Lock](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_18)
* [GIL与多线程](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_19)
* [多线程性能测试](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_20)
* [死锁现象与递归锁](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_21)
* [信号量](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_22)
* [事件Event](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_23)
* [线程Queue](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_24)
* [进程池与线程池](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_25)
* [协程](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_26)
* [Greenlet](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_27)
* [Gevent介绍](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_28)
* [Gevent之同步与异步](https://blog.driverzeng.com/zenglaoshi/5446.html#toc_29)

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

## 进程介绍

***

| 什么是进程？ |
| :--- |

进程的概念起源于操作系统，是操作系统最核心的概念，也是操作系统提供的最古老也是最重要的抽象概念之一。操作系统的其他所有内容都是围绕进程的概念展开的。

即使可以利用的cpu只有一个（早期的计算机确实如此），也能保证支持（伪）并发的能力。将一个单独的cpu变成多个虚拟的cpu（多道技术：时间多路复用和空间多路复用+硬件上支持隔离），没有进程的抽象，现代计算机将不复存在。

**必备的理论基础**

<!-- OCR_START -->
- 暴风影
- 腾讯qq
- 浏览器
- 用户态
- 用户接口程序
- 软件
- 内核态
- 操作系统
- 曾老湿
- 计算机硬件
- 硬件
- Driver Zeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 暴风影
- 腾讯qq
- 浏览器
- 用户接口程序
- 美丽的接口-
- 操作系统
- 丑陋的接口
- 计算机硬件
<!-- OCR_END -->

￼

```plain
#一 操作系统的作用：
    1：隐藏丑陋复杂的硬件接口，提供良好的抽象接口
    2：管理、调度进程，并且将多个进程对硬件的竞争变得有序
#二 多道技术：
    1.产生背景：针对单核，实现并发
    ps：
    现在的主机一般是多核，那么每个核都会利用多道技术
    有4个cpu，运行于cpu1的某个程序遇到io阻塞，会等到io结束再重新调度，会被调度到4个
    cpu中的任意一个，具体由操作系统调度算法决定。
    
    2.空间上的复用：如内存中同时有多道程序
    3.时间上的复用：复用一个cpu的时间片
       强调：遇到io切，占用cpu时间过长也切，核心在于切之前将进程的状态保存下来，这样
            才能保证下次切换回来时，能基于上次切走的位置继续运行
```

说了那么多没有用的，接下来我们就了解一下什么是进程：

进程：指的是一个正在进行/运行的程序或者说一个任务，进程是用来描述程序执行过程的虚拟概念，而负责执行任务则是cpu

举例（单核+多道，实现多个进程的并发执行）：

曾老湿在一个时间段内有很多任务要做：Linux备课的任务，写书的任务，交女朋友的任务，王者荣耀上分的任务，　　

但曾老湿同一时刻只能做一个任务（cpu同一时间只能干一个活），如何才能玩出多个任务并发执行的效果？

曾老湿备一会课，再去跟别人的女朋友聊聊天，再去打一会王者荣耀....这就保证了每个任务都在进行中.

***

| 进程跟程序的对比 |
| :--- |

程序仅仅只是一堆代码而已，而进程指的是程序的运行过程。

**举例：**

想象一位有一手好厨艺的计算机科学家 曾老湿 正在为他的女儿alex做生日蛋糕。

他有做生日蛋糕的食谱。

厨房里有所需的原料:面粉、鸡蛋、韭菜、蒜泥、臭豆腐等食材。

在这个比喻中：

做蛋糕的食谱就是程序(即用适当形式描述的算法)

曾老湿就是处理器(cpu)

而做蛋糕的各种原料就是输入数据。

进程就是曾老湿阅读食谱、取来各种原料以及烘制蛋糕等一系列动作的总和。

现在假设计算机科学家曾老湿的儿子zls哭着跑了进来，说：[\*\*\*\*\*\*](https://fanyi.baidu.com/translate?aldtype=16047\&query=%E5%98%BF%EF%BC%8C%E7%88%B8%E7%88%B8%EF%BC%8C%E6%88%91%E7%9A%84%E5%A4%B4%E8%A2%AB%E8%9C%9C%E8%9C%82%E8%9B%B0%E4%BA%86\&keyfrom=baidu\&smartresult=dict\&lang=auto2zh#zh/en/%E5%98%BF%EF%BC%8C%E7%88%B8%E7%88%B8%EF%BC%8C%E6%88%91%E7%9A%84%E5%A4%B4%E8%A2%AB%E8%9C%9C%E8%9C%82%E8%9B%B0%E4%BA%86)。

科学家曾老湿想了想，处理儿子zls蛰伤的任务比给女儿alex做蛋糕的任务更重要，于是

计算机科学家就记录下他照着食谱做到哪儿了(保存进程的当前状态)，然后拿出一本急救手册，按照其中的指示处理蛰伤。这里，我们看到处理机从一个进程(做蛋糕)切换到另一个高优先级的进程(实施医疗救治)，每个进程拥有各自的程序(食谱和急救手册)。当蜜蜂蛰伤处理完之后，这位计算机科学家又回来做蛋糕，从他

离开时的那一步继续做下去。

需要强调的是：同一个程序执行两次，那也是两个进程，比如打开暴风影音，虽然都是同一个软件，但是一个可以播放苍井空，一个可以播放武藤兰。

## 计算机的发展史

***

| 第一代计算机（1940~1955）：真空管和穿孔卡片 |
| :--- |

**第一代计算机的产生背景：**

第一代之前人类是想用机械取代人力，第一代计算机的产生是计算机由机械时代进入电子时代的标志，从Babbage失败之后一直到第二次世界大战，数字计算机的建造几乎没有什么进展，第二次世界大战刺激了有关计算机研究的爆炸性进展。

lowa州立大学的john Atanasoff教授和他的学生Clifford Berry建造了据认为是第一台可工作的数字计算机。该机器使用300个真空管。大约在同时，Konrad Zuse在柏林用继电器构建了Z3计算机，英格兰布莱切利园的一个小组在1944年构建了Colossus，Howard Aiken在哈佛大学建造了Mark 1，宾夕法尼亚大学的William Mauchley和他的学生J.Presper Eckert建造了ENIAC。这些机器有的是二进制的，有的使用真空管，有的是可编程的，但都非常原始，设置需要花费数秒钟时间才能完成最简单的运算。

在这个时期，同一个小组里的工程师们，设计、建造、编程、操作及维护同一台机器，所有的程序设计是用纯粹的机器语言编写的，甚至更糟糕，需要通过成千上万根电缆接到插件板上连成电路来控制机器的基本功能。没有程序设计语言（汇编也没有），操作系统则是从来都没听说过。使用机器的过程更加原始，详见下‘工作过程’

**特点：**

没有操作系统的概念

所有的程序设计都是直接操控硬件

**工作过程：**

程序员在墙上的机时表预约一段时间，然后程序员拿着他的插件版到机房里，将自己的插件板街道计算机里，这几个小时内他独享整个计算机资源，后面的一批人都得等着(两万多个真空管经常会有被烧坏的情况出现)。

后来出现了穿孔卡片，可以将程序写在卡片上，然后读入机而不用插件板

**优点：**

程序员在申请的时间段内独享整个资源，可以即时地调试自己的程序（有bug可以立刻处理）

**缺点：**

浪费计算机资源，一个时间段内只有一个人用。

注意：同一时刻只有一个程序在内存中，被cpu调用执行，比方说10个程序的执行，是串行的

***

| 第二代计算机（1955~1965）：晶体管和批处理系统 |
| :--- |

**第二代计算机的产生背景：**

由于当时的计算机非常昂贵，自认很自然的想办法较少机时的浪费。通常采用的方法就是批处理系统。

**特点：**

设计人员、生产人员、操作人员、程序人员和维护人员直接有了明确的分工，计算机被锁在专用空调房间中，由专业操作人员运行，这便是‘大型机’。

有了操作系统的概念

有了程序设计语言：FORTRAN语言或汇编语言，写到纸上，然后穿孔打成卡片，再讲卡片盒带到输入室，交给操作员，然后喝着咖啡等待输出接口

工作过程：插图

<!-- OCR_START -->
- 输人
- 输出
- 磁带机
- 磁带
- 系统磁带
- 读卡机
- 打印机
- 1401
- 7094
- a)
- b)
- C)
- d)
- e)
- f)
- 一种早期的批处理系统：a）程序员将卡片拿到1401机处：b）1401机将批处理作业读到磁带上：
<!-- OCR_END -->

￼

<!-- OCR_START -->
c）操作员将输人带送至7094机，d）7094机进行计算：e）操作员将输出磁带送到1401机：f1401机打印输
在收集了大约一个小时的批量作业之后，这些卡片被读进磁带，然后磁带被送到机房里并装到磁带
机上。随后，操作员装入一个特殊的程序（现代操作系统的前身），它从磁带上读人第一个作业并运行，
其输出写到第二盘磁带上，而不打印。每个作业结束后，操作系统白动地从磁带上读人下一个作业并运
行。当一批作业完全结束后，操作员取下输入和输出磁带，将输入磁带换成下一批作业，并把输出磁带
拿到~一台1401机器上进行脱机（不与主计算机联机）打印。
<!-- OCR_END -->

￼

**第二代如何解决第一代的问题/缺点：**

1.把一堆人的输入攒成一大波输入，

2.然后顺序计算（这是有问题的，但是第二代计算也没有解决）

3.把一堆人的输出攒成一大波输出

现代操作系统的前身:(见图）

\*\*优点：\*\*批处理，节省了机时

**缺点：**

1.整个流程需要人参与控制，将磁带搬来搬去（中间俩小人）

2.计算的过程仍然是顺序计算-》串行

3.程序员原来独享一段时间的计算机，现在必须被统一规划到一批作业中，等待结果和重新调试的过程都需要等同批次的其他程序都运作完才可以（这极大的影响了程序的开发效率，无法及时调试程序）

***

| 第三代计算机（1965~1980）：集成电路芯片和多道程序设计 |
| :--- |

**第三代计算机的产生背景：**

20世纪60年代初期，大多数计算机厂商都有两条完全不兼容的生产线。

一条是面向字的：大型的科学计算机，如IBM 7094，见上图，主要用于科学计算和工程计算

另外一条是面向字符的：商用计算机，如IBM 1401，见上图，主要用于银行和保险公司从事磁带归档和打印服务

开发和维护完全不同的产品是昂贵的，同时不同的用户对计算机的用途不同。

IBM公司试图通过引入system/360系列来同时满足科学计算和商业计算，360系列低档机与1401相当，高档机比7094功能强很多，不同的性能卖不同的价格

360是第一个采用了（小规模）芯片（集成电路）的主流机型，与采用晶体管的第二代计算机相比，性价比有了很大的提高。这些计算机的后代仍在大型的计算机中心里使用，此乃现在服务器的前身，这些服务器每秒处理不小于千次的请求。

**如何解决第二代计算机的问题1：**

卡片被拿到机房后能够很快的将作业从卡片读入磁盘，于是任何时刻当一个作业结束时，操作系统就能将一个作业从磁带读出，装进空出来的内存区域运行，这种技术叫做

同时的外部设备联机操作：SPOOLING，该技术同时用于输出。当采用了这种技术后，就不在需要IBM1401机了，也不必将磁带搬来搬去了（中间俩小人不再需要）

**如何解决第二代计算机的问题2：**

第三代计算机的操作系统广泛应用了第二代计算机的操作系统没有的关键技术：多道技术

cpu在执行一个任务的过程中，若需要操作硬盘，则发送操作硬盘的指令，指令一旦发出，硬盘上的机械手臂滑动读取数据到内存中，这一段时间，cpu需要等待，时间可能很短，但对于cpu来说已经很长很长，长到可以让cpu做很多其他的任务，如果我们让cpu在这段时间内切换到去做其他的任务，这样cpu不就充分利用了吗。这正是多道技术产生的技术背景

**多道技术：**

多道技术中的多道指的是多个程序，多道技术的实现是为了解决多个程序竞争或者说共享同一个资源（比如cpu）的有序调度问题，解决方式即多路复用，多路复用分为时间上的复用和空间上的复用。

\*\*空间上的复用：\*\*将内存分为几部分，每个部分放入一个程序，这样，同一时间内存中就有了多道程序。

<!-- OCR_START -->
- 作业3
- 作业2
- 内存
- 作业1
- 分区
- 操作系统
<!-- OCR_END -->

￼

**时间上的复用：**当一个程序在等待I/O时，另一个程序可以使用cpu，如果内存中可以同时存放足够多的作业，则cpu的利用率可以接近100%，类似于我们小学数学所学的**统筹方法**。（操作系统采用了多道技术后，可以控制进程的切换，或者说进程之间去争抢cpu的执行权限。这种切换不仅会在一个进程遇到io时进行，一个进程占用cpu时间过长也会切换，或者说被操作系统夺走cpu的执行权限）

```plain
### 详解
现代计算机或者网络都是多用户的，多个用户不仅共享硬件，而且共享文件，数据库等信息，共享意味着冲突和无序。
操作系统主要使用来
1.记录哪个程序使用什么资源
2.对资源请求进行分配
3.为不同的程序和用户调解互相冲突的资源请求。
我们可将上述操作系统的功能总结为：处理来自多个程序发起的多个（多个即多路）共享（共享即复用）资源的请求，简称多路复用
多路复用有两种实现方式
1.时间上的复用
当一个资源在时间上复用时，不同的程序或用户轮流使用它，第一个程序获取该资源使用结束后，在轮到第二个。。。第三个。。。
例如：只有一个cpu，多个程序需要在该cpu上运行，操作系统先把cpu分给第一个程序，在这个程序运行的足够长的时间（时间长短由操作系统的算法说了算）或者遇到了I/O阻塞，操作系统则把cpu分配给下一个程序，以此类推，直到第一个程序重新被分配到了cpu然后再次运行，由于cpu的切换速度很快，给用户的感觉就是这些程序是同时运行的，或者说是并发的，或者说是伪并行的。至于资源如何实现时间复用，或者说谁应该是下一个要运行的程序，以及一个任务需要运行多长时间，这些都是操作系统的工作。
2.空间上的复用
每个客户都获取了一个大的资源中的一小部分资源，从而减少了排队等待资源的时间。
例如：多个运行的程序同时进入内存，硬件层面提供保护机制来确保各自的内存是分割开的，且由操作系统控制，这比一个程序独占内存一个一个排队进入内存效率要高的多。
有关空间复用的其他资源还有磁盘，在许多系统中，一个磁盘同时为许多用户保存文件。分配磁盘空间并且记录谁正在使用哪个磁盘块是操作系统资源管理的典型任务。
这两种方式合起来便是多道技术
```

空间上的复用最大的问题是：程序之间的内存必须分割，这种分割需要在硬件层面实现，由操作系统控制。如果内存彼此不分割，则一个程序可以访问另外一个程序的内存，

首先丧失的是安全性，比如你的qq程序可以访问操作系统的内存，这意味着你的qq可以拿到操作系统的所有权限。

其次丧失的是稳定性，某个程序崩溃时有可能把别的程序的内存也给回收了，比方说把操作系统的内存给回收了，则操作系统崩溃。

第三代计算机的操作系统仍然是批处理

许多程序员怀念第一代独享的计算机，可以即时调试自己的程序。为了满足程序员们很快可以得到响应，出现了分时操作系统

**如何解决第二代计算机的问题3：**

**分时操作系统：**

多个联机终端+多道技术

20个客户端同时加载到内存，有17在思考，3个在运行，cpu就采用多道的方式处理内存中的这3个程序，由于客户提交的一般都是简短的指令而且很少有耗时长的，索引计算机能够为许多用户提供快速的交互式服务，所有的用户都以为自己独享了计算机资源

CTTS：麻省理工（MIT）在一台改装过的7094机上开发成功的，CTSS兼容分时系统，第三代计算机广泛采用了必须的保护硬件（程序之间的内存彼此隔离）之后，分时系统才开始流行

MIT，贝尔实验室和通用电气在CTTS成功研制后决定开发能够同时支持上百终端的MULTICS（其设计者着眼于建造满足波士顿地区所有用户计算需求的一台机器），很明显真是要上天啊，最后摔死了。

后来一位参加过MULTICS研制的贝尔实验室计算机科学家Ken Thompson开发了一个简易的，单用户版本的MULTICS，这就是后来的UNIX系统。基于它衍生了很多其他的Unix版本，为了使程序能在任何版本的unix上运行，IEEE提出了一个unix标准，即posix（可移植的操作系统接口Portable Operating System Interface）

后来，在1987年，出现了一个UNIX的小型克隆，即minix，用于教学使用。芬兰学生Linus Torvalds基于它编写了Linux

***

| 第四代计算机（1980~至今）：个人计算机 |
| :--- |

略

## 并发、并行、串行

并发：多个任务与看起来是同时运行的

串行：一个任务完完整整的运行完毕，才能运行下一个任务

无论是并行还是并发，在用户看来都是'同时'运行的，不管是进程还是线程，都只是一个任务而已，真是干活的是cpu，cpu来做这些任务，而一个cpu同一时刻只能执行一个任务

***

| 并发 |
| :--- |

是伪并行，即看起来是同时运行。单个cpu+多道技术就可以实现并发，（并行也属于并发）

**单CPU多进程举例：**

```plain
## 例一
你是一个cpu，你同时谈了三个女朋友，每一个都可以是一个恋爱任务，你被这三个任务共享
要玩出并发恋爱的效果，
应该是你先跟女友1去看电影，看了一会说：不好，我要拉肚子，然后跑去跟第二个女友吃饭，吃了一会说：那啥，我
去趟洗手间，然后跑去跟女友3开了个房
## 例二
某天下午，zls、bgx、zls、alex、约好了一起去嫖娼，但娼只有一个(cpu只有一个)，但是却要‘同时’干
四个任务(嫖出并发的效果)，那就必须是干一会zls，再干一会zls，再干一会alex，再干一会bgx
zls：花了200块钱，因为人美活好
bgx：500块钱
alex：100块钱，可能是不太行
zls：没要钱，为啥？？？因为大家刚刚嫖的是他女朋友
```

***

| 并行 |
| :--- |

同时运行，只有具备多个cpu才能实现并行

单核下，可以利用多道技术，多个核，每个核也都可以利用多道技术（多道技术是针对单核而言的）

有四个核，六个任务，这样同一时间有四个任务被执行，假设分别被分配给了cpu1，cpu2，cpu3，cpu4，

一旦任务1遇到I/O就被迫中断执行，此时任务5就拿到cpu1的时间片去执行，这就是单核下的多道技术

而一旦任务1的I/O结束了，操作系统会重新调用它(需知进程的调度、分配给哪个cpu运行，由操作系统说了算)，可能被分配给四个cpu中的任意一个去执行

<!-- OCR_START -->
- 时间段T
- 串行
- 线程A
- 线程B
- 线程C
- 并行
- 并发
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

所有现代计算机经常会在同一时间做很多件事，一个用户的PC（无论是单cpu还是多cpu），都可以同时运行多个任务（一个任务可以理解为一个进程）。

1.启动一个进程来杀毒（360软件）

2.启动一个进程来看电影（暴风影音）

3.启动一个进程来聊天（腾讯QQ）

所有的这些进程都需被管理，于是一个支持多进程的多道程序系统是至关重要的

多道技术概念回顾：内存中同时存入多道（多个）程序，cpu从一个进程快速切换到另外一个，使每个进程各自运行几十或几百毫秒，这样，虽然在某一个瞬间，一个cpu只能执行一个任务，但在1秒内，cpu却可以运行多个进程，这就给人产生了并行的错觉，即伪并发，以此来区分多处理器操作系统的真正硬件并行（多个cpu共享同一个物理内存）

## 进程的创建（了解）

　　但凡是硬件，都需要有操作系统去管理，只要有操作系统，就有进程的概念，就需要有创建进程的方式，一些操作系统只为一个应用程序设计，比如微波炉中的控制器，一旦启动微波炉，所有的进程都已经存在。

　　而对于通用系统（跑很多应用程序），需要有系统运行过程中创建或撤销进程的能力，主要分为4中形式创建新的进程

　　1. 系统初始化（查看进程linux中用ps命令，windows中用任务管理器，前台进程负责与用户交互，后台运行的进程与用户无关，运行在后台并且只在需要时才唤醒的进程，称为守护进程，如电子邮件、web页面、新闻、打印）

　　2. 一个进程在运行过程中开启了子进程（如nginx开启多进程，os.fork,subprocess.Popen等）

　　3. 用户的交互式请求，而创建一个新进程（如用户双击暴风影音）

　　4. 一个批处理作业的初始化（只在大型机的批处理系统中应用）

　　无论哪一种，新进程的创建都是由一个已经存在的进程执行了一个用于创建进程的系统调用而创建的：

　　1. 在UNIX中该系统调用是：fork，fork会创建一个与父进程一模一样的副本，二者有相同的存储映像、同样的环境字符串和同样的打开文件（在shell解释器进程中，执行一个命令就会创建一个子进程）

　　2. 在windows中该系统调用是：CreateProcess，CreateProcess既处理进程的创建，也负责把正确的程序装入新进程。

　　关于创建的子进程，UNIX和windows

　　1.相同的是：进程创建后，父进程和子进程有各自不同的地址空间（多道技术要求物理层面实现进程之间内存的隔离），任何一个进程的在其地址空间中的修改都不会影响到另外一个进程。

　　2.不同的是：在UNIX中，子进程的初始地址空间是父进程的一个副本，提示：子进程和父进程是可以有只读的共享内存区的。但是对于windows系统来说，从一开始父进程与子进程的地址空间就是不同的。

## 进程的状态

```plain
tail -f access.log |grep '404'
```

执行程序tail，开启一个子进程，执行程序grep，开启另外一个子进程，两个进程之间基于管道'|'通讯，将tail的结果作为grep的输入。

进程grep在等待输入（即I/O）时的状态称为阻塞，此时grep命令都无法运行

其实在两种情况下会导致一个进程在逻辑上不能运行，

　　1. 进程挂起是自身原因，遇到I/O阻塞，便要让出CPU让其他进程去执行，这样保证CPU一直在工作

　　2. 与进程无关，是操作系统层面，可能会因为一个进程占用时间过多，或者优先级等原因，而调用其他的进程去使用CPU。

因而一个进程由三种状态

<!-- OCR_START -->
- 运行
- 1、
- 进程为等待输入而阻塞
- 2、
- 调度程序选择另一个进程
- 3、
- 调度程序选择这个进程
- 4、出现有效输入
- 阻塞
- 就绪
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## 同步\异步 & 阻塞\非阻塞

***

| 同步 |
| :--- |

```plain
#所谓同步，就是在发出一个功能调用时，在没有得到结果之前，该调用就不会返回。按照这个定义，其实绝大多数函数都是同步调用。但是一般而言，我们在说同步、异步的时候，特指那些需要其他部件协作或者需要一定时间完成的任务。
#举例：
#1. multiprocessing.Pool下的apply #发起同步调用后，就在原地等着任务结束，根本不考虑任务是在计算还是在io阻塞，总之就是一股脑地等任务结束
#2. concurrent.futures.ProcessPoolExecutor().submit(func,).result()
#3. concurrent.futures.ThreadPoolExecutor().submit(func,).result()
```

***

| 异步 |
| :--- |

```plain
#异步的概念和同步相对。当一个异步功能调用发出后，调用者不能立刻得到结果。当该异步功能完成后，通过状态、通知或回调来通知调用者。如果异步功能用状态来通知，那么调用者就需要每隔一定时间检查一次，效率就很低（有些初学多线程编程的人，总喜欢用一个循环去检查某个变量的值，这其实是一 种很严重的错误）。如果是使用通知的方式，效率则很高，因为异步功能几乎不需要做额外的操作。至于回调函数，其实和通知没太多区别。
#举例：
#1. multiprocessing.Pool().apply_async() #发起异步调用后，并不会等待任务结束才返回，相反，会立即获取一个临时结果（并不是最终的结果，可能是封装好的一个对象）。
#2. concurrent.futures.ProcessPoolExecutor(3).submit(func,)
#3. concurrent.futures.ThreadPoolExecutor(3).submit(func,)
```

***

| 阻塞 |
| :--- |

```plain
#阻塞调用是指调用结果返回之前，当前线程会被挂起（如遇到io操作）。函数只有在得到结果之后才会将阻塞的线程激活。有人也许会把阻塞调用和同步调用等同起来，实际上他是不同的。对于同步调用来说，很多时候当前线程还是激活的，只是从逻辑上当前函数没有返回而已。
#举例：
#1. 同步调用：apply一个累计1亿次的任务，该调用会一直等待，直到任务返回结果为止，但并未阻塞住（即便是被抢走cpu的执行权限，那也是处于就绪态）;
#2. 阻塞调用：当socket工作在阻塞模式的时候，如果没有数据的情况下调用recv函数，则当前线程就会被挂起，直到有数据为止。
```

***

| 非阻塞 |
| :--- |

```plain
#非阻塞和阻塞的概念相对应，指在不能立刻得到结果之前也会立刻返回，同时该函数不会阻塞当前线程。
```

***

| 小结 |
| :--- |

```plain
#1. 同步与异步针对的是函数/任务的调用方式：同步就是当一个进程发起一个函数（任务）调用的时候，一直等到函数（任务）完成，而进程继续处于激活状态。而异步情况下是当一个进程发起一个函数（任务）调用的时候，不会等函数返回，而是继续往下执行当，函数返回的时候通过状态、通知、事件等方式通知进程任务完成。
#2. 阻塞与非阻塞针对的是进程或线程：阻塞是当请求不能满足的时候就将进程挂起，而非阻塞则不会阻塞当前进程
```

## 进程实现并发（了解）

进程并发的实现在于，硬件中断一个正在运行的进程，把此时进程运行的所有状态保存下来，为此，操作系统维护一张表格，即进程表（process table），每个进程占用一个进程表项（这些表项也称为进程控制块）

<!-- OCR_START -->
- 进程管理
- 存储管理
- 文件管理
- 寄存器
- 正文段指针
- 根目录
- 程序计数器
- 数据段指针
- 工作目录
- 程序状态字
- 堆栈指针
- 文件描述符
- 用户ID
- 进程状态
- 组ID
- 优先级
- 调度参数
- 进程ID
- 父进程
- 进程组
- 信号
- 进程开始时间
- 使用的CPU时间
- 子进程的CPU时间
- 下次报警时间
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

该表存放了进程状态的重要信息：程序计数器、堆栈指针、内存分配状况、所有打开文件的状态、帐号和调度信息，以及其他在进程由运行态转为就绪态或阻塞态时，必须保存的信息，从而保证该进程在再次启动时，就像从未被中断过一样。

## 开启进程的两种方式

***

| multiprocessing模块介绍 |
| :--- |

原本应用程序没有办法开启进程，都是程序来调用操作系统来开启进程，那么不同的操作系统就需要不同的系统调用...

在Windows下开启进程需要使用模块：`createprocess`

在Linux系统下开启进程需要使用模块：`fork`

但是按照Python的尿性，就会封装成更简单的方式，多系统都可以调用：`multiprocessing`

python中的多线程无法利用多核优势，如果想要充分地使用多核CPU的资源（os.cpu_count()查看），在python中大部分情况需要使用多进程。Python提供了multiprocessing。

multiprocessing模块用来开启子进程，并在子进程中执行我们定制的任务（比如函数），该模块与多线程模块threading的编程接口类似。

multiprocessing模块的功能众多：支持子进程、通信和共享数据、执行不同形式的同步，提供了Process、Queue、Pipe、Lock等组件。

需要再次强调的一点是：与线程不同，进程没有任何共享状态，进程修改的数据，改动仅限于该进程内。

***

| Process类介绍 |
| :--- |

**创建进程的类：**

```plain
Process([group [, target [, name [, args [, kwargs]]]]])，由该类实例化得到的对象，表示一个子进程中的任务（尚未启动）
强调：
1. 需要使用关键字的方式来指定参数
2. args指定的为传给target函数的位置参数，是一个元组形式，必须有逗号
```

**参数介绍：**

```plain
group参数未使用，值始终为None
target表示调用对象，即子进程要执行的任务
args表示调用对象的位置参数元组，args=(1,2,'zls',)
kwargs表示调用对象的字典,kwargs={'name':'zls','age':18}
name为子进程的名称
```

**方法介绍：**

```plain
p.start()：启动进程，并调用该子进程中的p.run()
p.run():进程启动时运行的方法，正是它去调用target指定的函数，我们自定义类的类中一定要实现该方法
p.terminate():强制终止进程p，不会进行任何清理操作，如果p创建了子进程，该子进程就成了僵尸进程，使用该方法需要特别小心这种情况。如果p还保存了一个锁那么也将不会被释放，进而导致死锁
p.is_alive():如果p仍然运行，返回True
p.join([timeout]):主线程等待p终止（强调：是主线程处于等的状态，而p是处于运行的状态）。timeout是可选的超时时间，需要强调的是，p.join只能join住start开启的进程，而不能join住run开启的进程
```

**属性介绍：**

```plain
p.daemon：默认值为False，如果设为True，代表p为后台运行的守护进程，当p的父进程终止时，p也随之终止，并且设定为True后，p不能创建自己的新进程，必须在p.start()之前设置
p.name:进程的名称
p.pid：进程的pid
p.exitcode:进程在运行时为None、如果为–N，表示被信号N结束(了解即可)
p.authkey:进程的身份验证键,默认是由os.urandom()随机生成的32字符的字符串。这个键的用途是为涉及网络连接的底层进程间通信提供安全性，这类连接只有在具有相同的身份验证键时才能成功（了解即可）
```

***

| 举例 |
| :--- |

```plain
import time
def task(name):
    print('%s is runnging' %name)
    time.sleep(3)
    print('%s is down' %name)
task('zls')
print('主进程')
```

等zls进程运行完了，才会执行主进程，那肯定是不阔以的。

<!-- OCR_START -->
- PYTHON
- ·并发编程
- 01开启进程的两种方式.py
- from multiprocessing.import Process
- 2
- import time
- 3
- def task（name):
- 5
- print('%s is
- runnging'
- %name)
- 6
- time.sleep(3)
- 7
- print（'%s is down' %name)
- 8
- 9
- task('zls')
- 10
- print（主进程
- Run:
- 01开启进程的两种方式
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python
- zls is runnging
- zls is down
- 主进程
- rocess finished with exit code o
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**开启进程方式一：**

```plain
from multiprocessing import Process
import time
def task(name):
    print('%s is runnging' %name)
    time.sleep(3)
    print('%s is down' %name)
if __name__ == '__main__': ## windows上开启进程必须使用__main__的方式，在Linux就无所谓了
    ## 实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
    obj=Process(target=task,args=('zls',))
    # Process(target=task,kwargs={'name':'zls'})
    obj.start()
    print('主进程')
```

<!-- OCR_START -->
- PYTHON[~/Des
- PYTHON并发编程
- 01开启进程的两种方式.py
- from multiprocessing import Process
- import time
- 3
- def task(name):
- print('%s is runnging' %name)
- 5
- 6
- time.sleep(3)
- print('%s is down'%name)
- 8
- 9
- 10
- 1f
- name
- main_'：##windows上开启进程必须使用main的方式，在Linux就无所谓了
- 11
- #实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典
- 12
- obj=Process(target=task,args=('zls',))
- 13
- #Process(target=task,kwargs={'name':'zls'})
- 14
- obj.start()
- 15
- print（主进程）
- task()
- Run:
- 01开启进程的两种方式×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop
- 主进程
- zls is runnging
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- PYTHON并发编程
- 01开启进程的两种方式.py
- from multiprocessing import Process
- 2
- import time
- 3
- def task(name):
- 5
- print('%s is runnging
- %name)
- 6
- time.sleep(3)
- 7
- print('%s is down'%name)
- 8
- 9
- 10
- main'：##windows上开启进程必须使用main的方式，在Linux就无所谓了
- 11
- #实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
- 12
- obj=Process(target=task,args=('zls',))
- 13
- # Process(target=task,kwargs={'name':'zls'})
- 14
- obj.start()
- 15
- print（主进程'）
- task()
- Run:
- 01开启进程的两种方式×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/users/driverzeng/Desktop/PYTh
- 主进程
- zls is runnging
- zls is down
- Process finished with exit code 0
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

**开启进程方式二：**

```plain
from multiprocessing import Process
import time
class  MyProcess(Process):
    def __init__(self,name):
        super().__init__()
        self.name=name
    def run(self):
        print('%s is runnging' %self.name)
        time.sleep(3)
        print('%s is down' %self.name)
if __name__ == '__main__': ## windows上开启进程必须使用__main__的方式，在Linux就无所谓了
    ## 实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
    # obj=Process(target=MyProcess,args=('zls',))
    # Process(target=task,kwargs={'name':'zls'})
    obj=MyProcess('zls')
    obj.start()
    print('主进程')
```

<!-- OCR_START -->
- PYTHONL~
- PYTHON并发编程
- 01开启进程的两种方式.py
- 白from multiprocessingi
- import Process
- 2
- import time
- 3
- class
- MyProcess(Process):
- 5
- def
- init(self,name):
- 6
- super()._init
- 7
- self.name=name
- 8
- 9
- def run(self):
- 10
- print('%s is runnging' %self.name)
- 11
- time.sleep(3)
- 12
- print('%s is down' %self.name)
- 13
- 14
- 15
- 16
- name
- main
- ：##windows上开启进程必须使用main的方式，在Linux就无所谓了
- 17
- ##实例化
- 18
- # obj=Process(target=MyProcess,args=('zls',))
- 19
- # Process(target=task,kwargs={'name':'zls'})
- 20
- obj=MyProcess('zls')
- 21
- obj.start()
- 22
- print（'主进程
- Run:
- 01开启进程的两种方式
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desk
- 主进程
- zls is runnging
- zls is down
- Process finished with exit code 0
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## join方法

***

| join方法的作用 |
| :--- |

```plain
from multiprocessing import Process
import time
def task(name):
    print('%s is runnging' %name)
    time.sleep(3)
    print('%s is down' %name)
if __name__ == '__main__': ## windows上开启进程必须使用__main__的方式，在Linux就无所谓了
    ## 实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
    obj1=Process(target=task,args=('子进程1',))
    obj2=Process(target=task,args=('子进程2',))
    # Process(target=task,kwargs={'name':'zls'})
    obj1.start()
    obj2.start()
    print('主进程')
```

<!-- OCR_START -->
| PYTHOND并发编程 | PYTHOND并发编程 | 排名 | PYTHOND并发编程 |
| --- | --- | --- | --- |
| 02join方法.py | from multiprocessing import Process | import time | 3 |
| 4 | def task(name): | 5 | print('%s is runnging'9 |
| %name) | 6 | time.sleep(3) | print('%s is down'%name) |
| 8 | 9 | 10 | 白if |
| main | ：##windows上开启进程必须使用main的方式，在Linux就无所谓了 | 11 | #实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。 |
| 12 | obj1=Process（target=task,args=('子进程1',)） | 13 | obj2=Process（target=task,args=（'子进程2',）) |
| 14 | # Process(target=task,kwargs={'name':'zls'}) | 15 | obj1.start() |
| 16 | obj2.start() | 17 | print（主进程 |
| Run: | 02join方法x | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desk | 主进程 |
| 子进程1 is runnging | 子进程2 is runnging | 子进程1isdown | 子进程2isdown |
<!-- OCR_END -->

￼

\*\*需求：\*\*正常来说，主进程不应该立马运行，而是等待子进程工作完了，拿到结果之后，交给主进程，主进程再运行，让主进程等...但是得让子进程并发起来。

```plain
from multiprocessing import Process
import time
def task(name):
    print('%s is runnging' %name)
    time.sleep(3)
    print('%s is down' %name)
if __name__ == '__main__': ## windows上开启进程必须使用__main__的方式，在Linux就无所谓了
    ## 实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
    obj1=Process(target=task,args=('子进程1',))
    obj2=Process(target=task,args=('子进程2',))
    # Process(target=task,kwargs={'name':'zls'})
    obj1.start()
    obj2.start()
    time.sleep(4)
    print('主进程')
```

我们让它睡4秒？好像可以哎~~~

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 排名 | 名称 | 排名(上年) |
| --- | --- | --- | --- | --- | --- |
| PYTHON并发编程 | 02join方法.py | 02join方法.py | from multiprocessing import Process | 2 | import time |
| 3 | def task(name): | 4 | 5 | print(%s is runnging′%name) | 6 |
| time.sleep(3) | 7 | print('%s is down'%name) | 8 | 9 | 10 |
| name | main | ：##windows上开启进程必须使用main的方式，在Linux就无所谓了 | 11 | ##实例化， | 12 |
| obj1=Process（target=task,args=（'子进程1',）) | 13 | obj2=Process（target=task2args=（'子进程2'，)) | 14 | # Process(target=task,kwargs={'name':'zls'}) | 15 |
| obj1.start() | 16 | obj2.start() | 17 | time.sleep(4) | 18 |
| print（主进程） | Run: | 02join方法x | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHO | 子进程1 is runnging | 子进程2 isrunnging |
| 子进程1isdown | 子进程2isdown | 主进程 | 曾老湿 | rocess finished with exit code o | Driver Zeng |
<!-- OCR_END -->

￼

但是你怎么知道子进程会运行多长时间？

```plain
from multiprocessing import Process
import time
def task(name):
    print('%s is runnging' %name)
    time.sleep(3)
    print('%s is down' %name)
if __name__ == '__main__': ## windows上开启进程必须使用__main__的方式，在Linux就无所谓了
    ## 实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
    obj1=Process(target=task,args=('子进程1',))
    obj2=Process(target=task,args=('子进程2',))
    # Process(target=task,kwargs={'name':'zls'})
    obj1.start()
    obj2.start()
    obj1.join()
    obj2.join()
    print('主进程')
```

<!-- OCR_START -->
PYTHON
PYTHON并发编程
02join方法.py
from multiprocessing import Process
2
import time
3
def task(name):
5
print('%s is runnging' %name)
6
time.sleep(3)
7
print（'%s is down' %name)
8
9
10
name
main：##windows上开启进程必须使用main的方式，在Linux就无所谓了
11
#实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
12
obj1=Process（target=task,args=（子进程1',）)
13
obj2=Process（target=task,args=（'子进程2',）)
14
# Process(target=task,kwargs={'name':'zls'})
15
obj1.start()
16
obj2.start()
17
18
obj1.join()
19
obj2.join()
20
print（‘主进程）
if_name_=='_main_
Run:
02join方法×
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop
子进程1 isrunnging
子进程2 isrunnging
子进程1isdown
子进程2isdown
主进程
曾老湿
DriverZeng
Process finished with exit code 0
<!-- OCR_END -->

￼

自定义一下执行时间

```plain
from multiprocessing import Process
import time
def task(name,n):
    print('%s is runnging' %name)
    time.sleep(n)
    print('%s is down' %name)
if __name__ == '__main__': ## windows上开启进程必须使用__main__的方式，在Linux就无所谓了
    ## 实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
    obj1=Process(target=task,args=('子进程1',1))
    obj2=Process(target=task,args=('子进程2',2))
    obj3=Process(target=task,args=('子进程3',3))
    # Process(target=task,kwargs={'name':'zls'})
    obj1.start()
    obj2.start()
    obj3.start()
    obj1.join()
    obj2.join()
    obj3.join()
    print('主进程')
```

<!-- OCR_START -->
- PYTHON并发编程
- 02join方法.py
- 白from multiprocessing import Process
- 2
- import time
- 3
- 4
- def task（name,n):
- 5
- print('%s is runnging'
- %name)
- 6
- time.sleep(n)
- 7
- print('%s is down'%name)
- 8
- 9
- 10
- if
- main
- ：##windows上开启进程必须使用main的方式，在Linux就无所谓了
- 11
- #实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
- 12
- obj1=Process（target=task,args=（'子进程1′,1）)
- 13
- obj2=Process（target=task,args=('子进程2'2))
- 14
- obj3=Process（target=task,args=（'子进程3'3))
- 15
- #Process(target=task,kwargs={'name':'zls'})
- 16
- obj1.start()
- 17
- obj2.start()
- 18
- obj3.start()
- 19
- 20
- obj1.join()
- 21
- obj2.join()
- 22
- obj3.join()
- 23
- print（‘主进程'）
- if_name_=='_main_'
- Run:
- 02join方法x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desk
- 子进程1 is runnging
- 子进程2 is runnging
- 子进程3 is runnging
- 子进程1 isdown
- 子进程2isdown
- 子进程3isdown
- 主进程
- 曾老湿
- rocess finished with exit code 0
- DriverZeng
<!-- OCR_END -->

￼

for循环

```plain
from multiprocessing import Process
import time
def task(name,n):
    print('%s is runnging' %name)
    time.sleep(n)
    print('%s is down' %name)
if __name__ == '__main__': ## windows上开启进程必须使用__main__的方式，在Linux就无所谓了
    ## 实例化，需要传参，有两种传参方式。1.使用args传一个元组。2.使用kwargs传一个字典。
    start=time.time()
    p_l=[]
    for i in range(1,4):
        obj=Process(target=task,args=('子进程%s' %i,i))
        p_l.append(obj)
        obj.start()
    for p in p_l:
        p.join()
    print('主进程')
```

<!-- OCR_START -->
- PC
- PYTHO
- PYTHON 并发编程
- 02join方法.py
- from multiprocessing import Process
- import time
- 2
- 3
- 4
- def task(name,n):
- 5
- print('%s is runnging'
- %name)
- 6
- time.sleep(n)
- 7
- print('%s is down'%name)
- 8
- 9
- 10
- if
- main_：##windows上开启进程必须使用main的方式，在Linux就无所谓了
- 11
- #实例化，需要传参，有两种传参方式。1.使用args传一
- 12
- 13
- start=time.time()
- 14
- p_l=[]
- 15
- for i in range（1,4):
- 16
- obj=Process（target=task,args=（'子进程%s′%i,i)）
- 17
- p_l.append（obj)
- 18
- obj.start()
- 19
- 20
- for p in p_l:
- 21
- p.join(）
- 22
- print（主进程）
- if_name_
- =='_main_'>foriin range(1,4)
- Run:
- 02join方法×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Deskt
- 子进程1 is runnging
- 子进程2is runnging
- 子进程3 is runnging
- 子进程1isdown
- 子进程2isdown
- 子进程3isdown
- 曾老湿
- 主进程
- Driver Zeng
<!-- OCR_END -->

￼

***

| 进程之间内存空间隔离 |
| :--- |

```plain
from multiprocessing import Process
n=100 #在windows系统中应该把全局变量定义在if __name__ == '__main__'之上就可以了
def work():
    global n
    n=0
    print('子进程内: ',n)
if __name__ == '__main__':
    p=Process(target=work)
    p.start()
    p.join
    print('主进程内: ',n)
```

## pid方法

```plain
from multiprocessing import Process,current_process
import time
def task():
    print('%s is running' %current_process().pid)
    time.sleep(3)
    print('%s is down' % current_process().pid)
if __name__ == '__main__':
    p=Process(target=task)
    p.run()
    print('主进程',current_process().pid)
```

<!-- OCR_START -->
| PYTHON[~/Desktop/PYTHON]-./并发编程/O3pi | PYTHON[~/Desktop/PYTHON]-./并发编程/O3pi | 排名 | PYTHON[~/Desktop/PYTHON]-./并发编程/O3pi | PYTHON[~/Desktop/PYTHON]-./并发编程/O3pi |
| --- | --- | --- | --- | --- |
| 2 | 3 | import time | def task（): | print('%s is running' %current_process().pid) |
| time.sleep(3) | print('%s is down' % current_process().pid) | 8 | 10 | if |
| name | main_': | 12 | p=Process(target=task) | 13 |
| p.run() | print（主进程,current_process（）.pid） | 14 | Run: | 03pid方法× |
| /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/并发编程/03 pid方法·py" | 28451 is running | 28451 is down | 主进程28451 | 曾老湿 |
<!-- OCR_END -->

￼

```plain
from multiprocessing import Process,current_process
import time,os
def task():
    print('%s is running' %os.getpid())
    time.sleep(3)
    print('%s is down' %os.getpid())
if __name__ == '__main__':
    p=Process(target=task)
    p.run()
    print('主进程',os.getpid())
```

## 守护进程

***

| 守护进程介绍 |
| :--- |

主进程创建守护进程

其一：守护进程会在主进程代码执行结束后就终止

其二：守护进程内无法再开启子进程,否则抛出异常：AssertionError: daemonic processes are not allowed to have children

注意：进程之间是互相独立的，主进程代码运行结束，守护进程随即终止

```plain
#守护进程: 本质就是一个"子进程",该"子进程"的生命周期<=被守护进程的生命周期
from multiprocessing import Process
import time
def task(name):
    print('老太监%s活着....' %name)
    time.sleep(3)
    print('老太监%s正常死亡....' %name)
if __name__ == '__main__':
    p=Process(target=task,args=('爱根',))
    p.daemon=True
    p.start()#一定要在p.start()前设置,设置p为守护进程,禁止p创建子进程,并且父进程代码执行结束,p即终止运行
    time.sleep(1)
    print('皇上:ZLS正在死...')
```

## 互斥锁

进程之间数据不共享,但是共享同一套文件系统,所以访问同一个文件,或同一个打印终端,是没有问题的,

而共享带来的是竞争，竞争带来的结果就是错乱，如何控制，就是加锁处理

***

| 模拟抢票 |
| :--- |

我们来通过抢票的方式，体验一下数据共享的情况。

db.json

```plain
{"count": 0}
```

```plain
import json
import time,random
from multiprocessing import Process
def search(name):
    with open('db.json','rt',encoding='utf-8') as f:
        dic=json.load(f)
    time.sleep(1)
    print('%s 查看到余票为%s' %(name,dic['count']))
def get(name):
    with open('db.json','rt',encoding='utf-8') as f:
        dic=json.load(f)
        if dic['count'] > 0:
            dic['count'] -= 1
            time.sleep(random.randint(1,3))
            with open('db.json','wt',encoding='utf-8') as f:
                json.dump(dic,f)
                print('%s 购票成功' % name)
        else:
            print('%s 查看到没有票了' %name)
def task(name):
    search(name)
    get(name)
if __name__ == '__main__':
    for i in range(10):
        p=Process(target=task,args=('路人 %s' %i,))
        p.start()
```

<!-- OCR_START -->
- PYTHOND并发编程
- 05互斤锁.py
- 05互厅锁pyx
- db.json x
- import json
- 2
- import time,random
- 3
- from multiprocessing import Process
- 4
- 5
- def search(name):
- 6
- with open（'db.json','rt'encoding='utf-8') as f:
- dic=json.load（f)
- 7
- 8
- time.sleep(1)
- 9
- print（%s 查看到余票为%s′%（namedic[count]）)
- 10
- 11
- def get（name):
- 12
- 13
- 14
- if dic['count']>0:
- 15
- dic['count'] -=1
- 16
- time.sleep(random.randint(1.3))
- 17
- 18
- json.dump（dic,f)
- 19
- print（%s购票成功%name）
- 20
- else:
- 21
- print（%s查看到没有票了’%name）
- 22
- 23
- def task(name):
- 24
- search(name)
- 25
- get(name)
- 26
- 27
- if
- name
- main
- 28
- for i in range（10):
- 29
- p=Process（target=taskargs=（'路人 %s′%i,))
- 30
- D.start()
- get() >with open('db.json','rt',encodi..> if dic['count] > 0
- Run:
- 05互斤锁×
- 路人3查看到余票为1
- 路人4查看到余票为1
- 路人5 查看到余票为1
- 路人6查看到余票为1
- 路人7查看到余票为1
- 路人8查看到余票为1
- 路人9 查看到余票为1
- 路人2购票成功
- 路人5购票成功
- 路人4购票成功
- 路人7购票成功
- 路人0购票成功
- 路人1购票成功
- 路人3购票成功
- 路人6购票成功
- 路人8购票成功
- 各人9购票成功
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

所有人都购票成功，这样就疯了，上车估计得把火车厢都拆了。

解决方法一：都变成串行

```plain
import json
import time,random
from multiprocessing import Process
def search(name):
    with open('db.json','rt',encoding='utf-8') as f:
        dic=json.load(f)
    time.sleep(1)
    print('%s 查看到余票为%s' %(name,dic['count']))
def get(name):
    with open('db.json','rt',encoding='utf-8') as f:
        dic=json.load(f)
        if dic['count'] > 0:
            dic['count'] -= 1
            time.sleep(random.randint(1,3))
            with open('db.json','wt',encoding='utf-8') as f:
                json.dump(dic,f)
                print('%s 购票成功' % name)
        else:
            print('%s 查看到没有票了' %name)
def task(name):
    search(name)
    get(name)
if __name__ == '__main__':
    for i in range(10):
        p=Process(target=task,args=('路人 %s' %i,))
        p.start()
        p.join()  #join只能将进程的任务整体变成串行
```

但是这样不合理，永远都是路人1抢到票，而且连查票，都得变成串行的，大家一个一个来查。

**使用互斥锁**

```plain
import json
import time,random
from multiprocessing import Process,Lock
def search(name):
    with open('db.json','rt',encoding='utf-8') as f:
        dic=json.load(f)
    time.sleep(1)
    print('%s 查看到余票为%s' %(name,dic['count']))
def get(name):
    with open('db.json','rt',encoding='utf-8') as f:
        dic=json.load(f)
        if dic['count'] > 0:
            dic['count'] -= 1
            time.sleep(random.randint(1,3))
            with open('db.json','wt',encoding='utf-8') as f:
                json.dump(dic,f)
                print('%s 购票成功' % name)
        else:
            print('%s 查看到没有票了' %name)
def task(name,mutex):
    search(name)        #并发
    mutex.acquire()     #互斥锁
    get(name)           #购票
    mutex.release()     #释放锁     #写法一，get之后释放互斥锁。
    # with mutex:   #写法二
    #     get(name)
if __name__ == '__main__':
    mutex=Lock()
    for i in range(10):
        p=Process(target=task,args=('路人 %s' %i,mutex))
        p.start()
```

<!-- OCR_START -->
- PYTHON并发编程
- 05互斤锁.py
- 05互斤锁.pyX
- Odb.json X
- 白import json
- 2
- import time,random
- 3
- from multiprocessing import Process,Lock
- 4
- def
- search(name):
- 6
- with open('db.json
- 'rt',encoding='utf-8')as f:
- 7
- dic=json.load(f)
- 8
- time.sleep(1)
- 9
- print(%s 查看到余票为%s%（namedic[count]））
- 10
- 11
- def get（name):
- 12
- 13
- 14
- if dic['count']>0:
- 15
- dic['count'] -=1
- 16
- time.sleep(random.randint(1,3))
- 17
- with open('db.json','wt'encoding='utf-8')as f:
- 18
- json.dump（dic,f)
- 19
- print（%s 购票成功%name）
- 20
- else:
- 21
- print（%s 查看到没有票了%name）
- 22
- 23
- def task(name,mutex):
- -L/
- Run:
- 05互斤锁×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driver
- 路人0查看到余票为1
- 路人1查看到余票为1
- 路人2查看到余票为1
- 路人3查看到余票为1
- 路人4查看到余票为1
- 路人5查看到余票为1
- 路人6查看到余票为1
- 路人7查看到余票为1
- 路人8查看到余票为1
- 路人 9查看到余票为1
- 路人0购票成功
- 路人1 查看到没有票了
- 路人2查看到没有票了
- 路人3查看到没有票了
- 路人4查看到没有票了
- 路人5查看到没有票了
- 路人6查看到没有票了
- 路人7查看到没有票了
- 路人8查看到没有票了
- 路人9查看到没有票了
- Process finished with exit code 0
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

查票都是1，但是买的时候，只有一个人能买的到，其余人再看就没票了。

## 进程间通信IPC

进程彼此之间互相隔离，要实现进程间通信（IPC），multiprocessing模块支持两种形式：队列和管道，这两种方式都是使用消息传递的。

队列=管道+锁

***

| 推荐用队列 |
| :--- |

```plain
from multiprocessing import Queue
q=Queue(3)
q.put(['first',])
q.put({'x':1})
q.put(3)
print(q.get())
print(q.get())
print(q.get())
```

<!-- OCR_START -->
- PYTHON
- 并发编程
- 06IPC.py
- from multiprocessing import Queue
- 3
- q=Queue（3)
- 4
- q.put(['first'])
- 5
- q.put（{'x':1})
- 6
- q.put(3)
- 7
- 8
- print(q.get())
- 9
- 10
- Run:
- 06IPCX
- /Users/driverzeng/PycharmProjects/untitled1/venv
- ['first']
- ['x':1}
- Process finished with exit code 0
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

了解用法

```plain
from multiprocessing import Queue
q=Queue(3)
q.put(['first',],block=True,timeout=3)  # block阻塞   timeout超时
q.put({'x':1},block=True,timeout=3)
q.put(3,block=True,timeout=3)
print(q.get())
print(q.get())
print(q.get())
q.put_nowait()  #不等了 q.put(1,block=False)
q.get(block=True,timeout=3)
q.get_nowait() # q.get(block=False)
```

## 生产者消费者模型

***

| 生产者消费者模型 |
| :--- |

在并发编程中使用生产者和消费者模式能够解决绝大多数并发问题。该模式通过平衡生产线程和消费线程的工作能力来提高程序的整体处理数据的速度。

***

| 为什么要使用生产者和消费者模式 |
| :--- |

在线程世界里，生产者就是生产数据的线程，消费者就是消费数据的线程。在多线程开发当中，如果生产者处理速度很快，而消费者处理速度很慢，那么生产者就必须等待消费者处理完，才能继续生产数据。同样的道理，如果消费者的处理能力大于生产者，那么消费者就必须等待生产者。为了解决这个问题于是引入了生产者和消费者模式。

***

| 什么是生产者消费者模式 |
| :--- |

```plain
生产者:代指生产数据的任务
消费者:代指处理数据的任务
该模型的工作方式:
    生产生产数据传递消费者处理
生产者消费者模式是通过一个容器来解决生产者和消费者的强耦合问题。生产者和消费者彼此之间不直接通讯，而通过阻塞队列来进行通讯，所以生产者生产完数据之后不用等待消费者处理，直接扔给阻塞队列，消费者不找生产者要数据，而是直接从阻塞队列里取，阻塞队列就相当于一个缓冲区，平衡了生产者和消费者的处理能力。
基于队列实现生产者消费者模型
```

***

| 举例 |
| :--- |

```plain
import time,random
from multiprocessing import Process,Queue
def producter(name,food,q):
    for i in range(10):
        #造数据...
        res='%s%s' %(food,i)
        time.sleep(random.randint(1,3))     #模拟生产数据的时间
        q.put(res)
        print('厨师[%s]生产了<%s>' %(name,res))
def consumer(name,q):
    while True:
        res=q.get(q)
        time.sleep(random.randint(1,3))     #模拟处理数据的时间
        print('吃货[%s]吃了<%s>' %(name,res))
if __name__ == '__main__':
    q=Queue()
    #生产者们
    p1=Process(target=producter,args=('zls','泔水',q))
    #消费者们
    c1=Process(target=consumer,args=('zls',q))
    p1.start()
    c1.start()
    print('主进程')
```

<!-- OCR_START -->
- PYTHON并发编程O7生产消费.py
- 06 IPC.py X
- 07生产消费.pyx
- importt
- 2
- from multiprocessing import Process,Queue
- 3
- 4
- def producter（name,food,g):
- for i in range（10):
- 5
- #造数据
- 6
- res='%s%s'
- %（food,i)
- 7
- 8
- time.sleep(random.randint(1.3))
- #模拟生产数据的时间
- 9
- q.put(res)
- print（厨师[%s]生产了<%s>′%（name,res））
- 10
- 11
- 12
- def consumer（name,g):
- 13
- while True:
- 14
- res=q.get(q)
- 15
- #模拟处理数据的时间
- 16
- print（吃货[%s]吃了<%s>'%（name,res））
- 17
- main..
- 18
- if
- name
- 19
- q=Queue()
- 20
- 21
- #生产者们
- 22
- p1=Process(target=producter,args=（'zls','水'q))
- 23
- #消费者们
- 24
- c1=Process(target=consumer,args=('egon',q))
- 25
- 26
- p1.start()
- 27
- c1.start()
- 28
- 29
- print（‘主进程'）
- if _name_ =='_main_
- Run:
- .07生产消费×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/d
- 主进程
- 厨师[zls]生产了<水0>
- 厨师[zls]生产了<水1>
- 厨师[zls]生产了<水2>
- 吃货[egon］吃了<水0>
- 吃货[egon]吃了<水1>
- 厨师[zls]生产了<水3>
- 吃货[egon]吃了<水2>
- 厨师[zls］生产了<水4>
- 吃货[egon］吃了<水3>
- 厨师[zls]生产了<水5>
- 吃货[egon]吃了<泪水4>
- 厨师[zls］生产了<水6>
- 吃货[egon]吃了<泪水5>
- 吃货[egon］吃了<水6>
- 厨师[zls］生产了<水7>
- 厨师[zls]生产了<水8>
- 曾老湿
- 1吃77
- Driver Zeng
- 三6:TODO
- 2Python Console
<!-- OCR_END -->

￼

***

| 问题一 |
| :--- |

刚才厨师生产完了，吃货也吃完了，但是程序没有结束。

因为队列已经空了，但是消费者一直在get，所以程序一直在阻塞，正常来说程序应该结束掉。

解决办法,生产者发出一个结束信号None:

```plain
import time,random
from multiprocessing import Process,Queue
def producter(name,food,q):
    for i in range(3):
        #造数据...
        res='%s%s' %(food,i)
        time.sleep(random.randint(1,3))     #模拟生产数据的时间
        q.put(res)
        print('厨师[%s]生产了<%s>' %(name,res))
    q.put(None)
def consumer(name,q):
    while True:
        res=q.get(q)
        if res is None:break
        time.sleep(random.randint(1,3))     #模拟处理数据的时间
        print('吃货[%s]吃了<%s>' %(name,res))
if __name__ == '__main__':
    q=Queue()
    #生产者们
    p1=Process(target=producter,args=('zls','泔水',q))
    #消费者们
    c1=Process(target=consumer,args=('zls',q))
    p1.start()
    c1.start()
    print('主进程')
```

<!-- OCR_START -->
- PYTHON并发编程
- 07生产消费.pyx
- 06 IPC.pyx
- 34
- 35
- def producter（name,food,g):
- 36
- for i in range(3):
- 37
- #造数据
- 38
- res='%s%s'
- %（food,i)
- 39
- time.sleep(random.randint(13))
- #模拟生产数据的时间
- 40
- q.put(res)
- 41
- print(厨师[%s]生产了<%s>'%（name，res））
- 42
- q.put（None)
- 43
- 44
- def consumer（name,g):
- 45
- while True:
- 46
- res=q·get（q)
- 47
- if res is None:break
- 48
- #模拟处理数据的时间
- 49
- print（'吃货[%s]吃了<%s>'%（nameres））
- 50
- 51
- if
- name
- main
- 52
- q=Queue（）
- 53
- 54
- #生产者们
- 55
- p1=Process(target=producter,args=('zls','水',q))
- 56
- #消费者们
- 57
- c1=Process(target=consumer,args=('egon'q))
- 58
- 59
- p1.start()
- 60
- c1.start()
- 61
- 62
- print（主进程
- Run:
- 07生产消费×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desk
- 主进程
- 厨师[zls]生产了<水0>
- 厨师[zls]生产了<水1>
- 吃货[egon]吃了<水0>
- 吃货[egon]吃了<泪水1>
- 厨师[zls］生产了<水2>
- 吃货[egon］吃了<水2>
- 曾老湿
- DriverZeng
- rocess finished with exit code 0
<!-- OCR_END -->

￼

***

| 问题二 |
| :--- |

多个生产者，少数消费者，结果会怎么样？

```plain
import time,random
from multiprocessing import Process,Queue
def producter(name,food,q):
    for i in range(3):
        #造数据...
        res='%s%s' %(food,i)
        time.sleep(random.randint(1,3))     #模拟生产数据的时间
        q.put(res)
        print('厨师[%s]生产了<%s>' %(name,res))
    q.put(None)
def consumer(name,q):
    while True:
        res=q.get(q)
        if res is None:break
        time.sleep(random.randint(1,3))     #模拟处理数据的时间
        print('吃货[%s]吃了<%s>' %(name,res))
if __name__ == '__main__':
    q=Queue()
    #生产者们
    p1=Process(target=producter,args=('小zls','泔水',q))
    p2=Process(target=producter,args=('中zls','屎包子',q))
    p3=Process(target=producter,args=('大zls','腰子汤',q))
    #消费者们
    c1=Process(target=consumer,args=('zls',q))
    c2=Process(target=consumer,args=('zls',q))
    p1.start()
    p2.start()
    p3.start()
    c1.start()
    c2.start()
    print('主进程')
```

如下图可见，生产了屎包子2，却没人吃？？？怎么回事？吃饱了？实际上不是，因为我们的结束信号并没有放到最后。

<!-- OCR_START -->
- PYTHON·并发编程
- 07生产消费.pyX
- 06IPC.py
- 48
- time.sleep(random.randint(1,3))
- 49
- print（吃货[%s]吃了<%s>'%（name,res））
- 50
- 51
- if
- name
- main
- 52
- q=Queue（)
- 53
- 54
- #生产者们
- 55
- p1=Process（target=producter，args=('小zls'水q))
- 56
- p2=Process（target=producterargs=（中zls屎包子q）)
- 57
- p3=Process（target=producter,args=('大zls'腰子汤'q）)
- 58
- #消费者门
- 59
- c1=Process(target=consumer,args=('egon'q))
- 60
- c2=Process(target=consumerargs=('EGoN'q))
- 61
- 62
- p1.start()
- 63
- p2.start()
- 64
- p3.start()
- 65
- c1.start()
- 66
- c2.start()
- 67
- 68
- print（主进程'）
- Run:
- 07生产消费×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Deskto
- 主进程
- 厨师[小zls]生产了<水0>
- 厨师[中zls］生产了<屎包子0>
- 厨师[小zls］生产了<水1>
- 吃货[egon]吃了<甜水0>
- 厨师[大zls］生产了<腰子汤0>
- 厨师[中zls］生产了<屎包子1>
- 厨师[小zls］生产了<水2>
- 厨师[大zls］生产了<腰子汤1>
- 吃货[egon]吃了<甜水1>
- 吃货[EGON]吃了<屎包子0>
- 厨师[大zls]生产了<腰子汤2>
- 厨师[中zls］生产了<屎包子2>
- 吃货[egon］吃了<腰子汤0>
- 吃货[EGON]吃了<屎包子1>
- 吃货[egon]吃了<水2>
- 吃货[egon］吃了<腰子汤1>
- 吃货[egon］吃了<腰子汤2>
- Process finished with exit code 0
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

所以我们要在所有子进程都结束了，然后再把None放进去。

```plain
import time,random
from multiprocessing import Process,Queue
def producter(name,food,q):
    for i in range(3):
        #造数据...
        res='%s%s' %(food,i)
        time.sleep(random.randint(1,3))     #模拟生产数据的时间
        q.put(res)
        print('厨师[%s]生产了<%s>' %(name,res))
    q.put(None)
def consumer(name,q):
    while True:
        res=q.get(q)
        if res is None:break
        time.sleep(random.randint(1,3))     #模拟处理数据的时间
        print('吃货[%s]吃了<%s>' %(name,res))
if __name__ == '__main__':
    q=Queue()
    #生产者们
    p1=Process(target=producter,args=('小zls','泔水',q))
    p2=Process(target=producter,args=('中zls','屎包子',q))
    p3=Process(target=producter,args=('大zls','腰子汤',q))
    #消费者们
    c1=Process(target=consumer,args=('zls',q))
    c2=Process(target=consumer,args=('zls',q))
    p1.start()
    p2.start()
    p3.start()
    c1.start()
    c2.start()
    p1.join()
    p2.join()
    p3.join()
    q.put(None)
    q.put(None)
    print('主进程')
```

<!-- OCR_START -->
- PYTHON 并发编程
- 07生产消费.pyX
- 06 IPC.py X
- priit（ 吃贝[osj吃j<%S>
- 50
- 51
- if
- name
- main
- 52
- q=Queue()
- 53
- 54
- #生产者们
- 55
- p1=Process（target=producter,args=（'小zls','水'q))
- 56
- p2=Process（target=producter,args=（中zls屎包子q）)
- 57
- p3=Process（target=producterargs=（'大zls'腰子汤'q）)
- 58
- #消费者们
- 59
- c1=Process(target=consumer,args=('egon',q))
- 60
- c2=Process(target=consumerargs=('EGoN'q))
- 61
- 62
- p1.start()
- 63
- p2.start()
- 64
- p3.start()
- 65
- c1.start()
- 66
- c2.start()
- 67
- 68
- p1.join()
- 69
- p2.join（)
- 70
- p3.join()
- 71
- q.put(None)
- 72
- 73
- print（主进程
- Run:
- 07生产消费×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/dr
- 厨师[大zls］生产了<腰子汤0>
- 厨师[小zls]生产了<水0>
- 厨师[中zls】生产了<屎包子0>
- 厨师[大zls］生产了<腰子汤1>
- 吃货[egon］吃了<腰子汤0>
- 厨师[中zls】生产了<屎包子1>
- 厨师[大zls]生产了<腰子汤2>
- 吃货[EGON]吃了<水O>
- 吃货[egon］吃了<屎包子0>
- 厨师[小zls]生产了<水1>
- 厨师[中zls］生产了<屎包子2>
- 吃货[EGON]吃了<腰子汤1>
- 厨师[小zls】生产了<水2>
- 主进程
- 吃货[EGON]吃了<腰子汤2>
- 吃货［egon]吃了<屎包子1>
- 吃货[egon]吃了<屎包子2>
- Process finished with exit code 0
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

不过这么写，太low了，我们需要更好的解决方案

```plain
import time,random
from multiprocessing import Process,JoinableQueue
def producter(name,food,q):
    for i in range(3):
        #造数据...
        res='%s%s' %(food,i)
        time.sleep(random.randint(1,3))     #模拟生产数据的时间
        q.put(res)
        print('厨师[%s]生产了<%s>' %(name,res))
    # q.put(None)
def consumer(name,q):
    while True:
        res=q.get(q)
        if res is None:break
        time.sleep(random.randint(1,3))     #模拟处理数据的时间
        print('吃货[%s]吃了<%s>' %(name,res))
        q.task_done()
if __name__ == '__main__':
    q=JoinableQueue()
    #生产者们
    p1=Process(target=producter,args=('小zls','泔水',q))
    p2=Process(target=producter,args=('中zls','屎包子',q))
    p3=Process(target=producter,args=('大zls','腰子汤',q))
    #消费者们
    c1=Process(target=consumer,args=('zls',q))
    c2=Process(target=consumer,args=('zls',q))
    p1.start()
    p2.start()
    p3.start()
    c1.start()
    c2.start()
    p1.join()
    p2.join()
    p3.join()
    q.join() #主进程等q结束，即q内的数据被取干净
    print('主进程')
```

这样运行但是程序没有结束

<!-- OCR_START -->
- PPYT
- PYTHON并发编程O7生产消费·py
- 06 IPC.py X
- 07生产消费.py X
- 93
- q.task_done()
- 94
- 95
- if
- name
- main
- 96
- q=JoinableQueue(）
- 97
- 98
- #生产者们
- 99
- p1=Process（target=producter,args=（'小zls','水'q）)
- 100
- p2=Process（target=producter,args=（'中zls','屎包子'q）)
- 101
- p3=Process（target=producter,args=（大zls，腰子汤q))
- 102
- #消费者们
- 103
- c1=Process(target=consumer,args=('egon'q))
- 104
- c2=Process(target=consumerargs=('EGoN'q))
- 105
- 106
- p1.start()
- 107
- p2.start()
- 108
- p3.start()
- 109
- c1.start()
- 110
- c2.start()
- 111
- 112
- p1.join()
- 113
- p2.join()
- 114
- p3.join()
- 115
- q.join（）#主进程等a结束，即g内的数据被取干净
- 116
- print（主进程'）
- consumer() while True
- Run:
- 07生产消费×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/De
- 厨师[大zls]生产了<腰子汤0>
- 厨师[小zls]生产了<水0>
- 厨师[中zls］生产了<屎包子0>
- 厨师[小zls]生产了<水1>
- 吃货[EGON]吃了<水O>
- 厨师[中zls］生产了<屎包子1>
- 吃货[EGON]吃了<屎包子0>
- 厨师[大zls］生产了<腰子汤1>
- 吃货[egon］吃了<腰子汤0>
- 厨师[中zls］生产了<屎包子2>
- 吃货[EGON】吃了<泪水1>
- 厨师[小zls]生产了<水2>
- 厨师[大zls］生产了<腰子汤2>
- 吃货[EGON]吃了<腰子汤1>
- 吃货[egon]吃了<屎包子1>
- 吃货[egon]吃了<屎包子2>
- 吃货[EGON]吃了<泪水2>
- 吃货[egon]吃了<腰子汤2>
- 曾老湿
- 主进程
- DriverZeng
<!-- OCR_END -->

￼

还是消费者在那q.get....现在要想办法让消费者死掉，既然主进程运行完了，想让消费者死掉，有一个很好的办法，就是让消费者的进程变成守护进程，一旦主进程结束，消费者进程跟着一起结束

```plain
import time,random
from multiprocessing import Process,JoinableQueue
def producter(name,food,q):
    for i in range(3):
        #造数据...
        res='%s%s' %(food,i)
        time.sleep(random.randint(1,3))     #模拟生产数据的时间
        q.put(res)
        print('厨师[%s]生产了<%s>' %(name,res))
    # q.put(None)
def consumer(name,q):
    while True:
        res=q.get(q)
        if res is None:break
        time.sleep(random.randint(1,3))     #模拟处理数据的时间
        print('吃货[%s]吃了<%s>' %(name,res))
        q.task_done()
if __name__ == '__main__':
    q=JoinableQueue()
    #生产者们
    p1=Process(target=producter,args=('小zls','泔水',q))
    p2=Process(target=producter,args=('中zls','屎包子',q))
    p3=Process(target=producter,args=('大zls','腰子汤',q))
    #消费者们
    c1=Process(target=consumer,args=('zls',q))
    c2=Process(target=consumer,args=('zls',q))
    c1.daemon=True
    c2.daemon=True
    p1.start()
    p2.start()
    p3.start()
    c1.start()
    c2.start()
    p1.join()
    p2.join()
    p3.join()
    q.join() #主进程等q结束，即q内的数据被取干净
    print('主进程')
```

<!-- OCR_START -->
- 06IPC.pyX
- 07生产消费.py
- 白if
- name
- main
- 6
- q=JoinableQueue（)
- 8
- #生产者们
- p1=Process（target=producter,args=（'小zls',水'q）)
- p2=Process（target=producter,args=（'中zls',屎包子'q）)
- p3=Process(target=producterargs=（'大zls',腰子汤'q))
- #消费者们
- c1=Process(target=consumer,args=('egon',q))
- c2=Process(target=consumer,args=('EGoN',q))
- c1.daemon=True
- c2.daemon=True
- p1.start()
- p2.start()
- p3.start()
- c1.start()
- c2.start()
- p1.join()
- p2.join()
- p3.join()
- q.join（）#主进程等a结束，即g内的数据被取干净
- print（主进程）
- n:
- 07生产消费
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng
- 厨师[小zls]生产了<水0>
- 厨师[中zls］生产了<屎包子0>
- 厨师[大zls]生产了<腰子汤0>
- 吃货[EGON】吃了<屎包子0>
- 厨师[小zls】生产了<水1>
- 厨师[中zls］生产了<屎包子1>
- 吃货[egon]吃了<泪水0>
- 厨师[大zls]生产了<腰子汤1>
- 厨师[小zls]生产了<水2>
- 厨师[中zls］生产了<屎包子2>
- 吃货[egon]吃了<腰子汤1>
- 吃货[egon]吃了<泪水1>
- 厨师[大zls]生产了<腰子汤2>
- 吃货[EGON】吃了<屎包子1>
- 吃货[EGON]吃了<屎包子2>
- 吃货[egon]吃了<泪水2>
- 吃货[EGON]吃了<腰子汤2>
- 主进程
- 曾老湿
- finished with exit code 0
- Driver Zeng
<!-- OCR_END -->

￼

## 线程介绍

***

| 什么是线程 |
| :--- |

在传统操作系统中，每个进程有一个地址空间，而且默认就有一个控制线程

线程顾名思义，就是一条流水线工作的过程，一条流水线必须属于一个车间，一个车间的工作过程是一个进程

车间负责把资源整合到一起，是一个资源单位，而一个车间内至少有一个流水线

流水线的工作需要电源，电源就相当于cpu

所以，进程只是用来把资源集中到一起（进程只是一个资源单位，或者说资源集合），而线程才是cpu上的执行单位。

多线程（即多个控制线程）的概念是，在一个进程中存在多个控制线程，多个控制线程共享该进程的地址空间，相当于一个车间内有多条流水线，都共用一个车间的资源。

例如，北京地铁与上海地铁是不同的进程，而北京地铁里的13号线是一个线程，北京地铁所有的线路共享北京地铁所有的资源，比如所有的乘客可以被所有线路拉。

***

| 线程的创建开销小 |
| :--- |

**创建进程的开销要远大于线程？**

如果我们的软件是一个工厂，该工厂有多条流水线，流水线工作需要电源，电源只有一个即cpu（单核cpu）

一个车间就是一个进程，一个车间至少一条流水线（一个进程至少一个线程）

创建一个进程，就是创建一个车间（申请空间，在该空间内建至少一条流水线）

而建线程，就只是在一个车间内造一条流水线，无需申请空间，所以创建开销小

**进程之间是竞争关系，线程之间是协作关系？**

车间直接是竞争/抢电源的关系，竞争（不同的进程直接是竞争关系，是不同的程序员写的程序运行的，迅雷抢占其他进程的网速，360把其他进程当做病毒干死）

一个车间的不同流水线式协同工作的关系（同一个进程的线程之间是合作关系，是同一个程序写的程序内开启动，迅雷内的线程是合作关系，不会自己干自己）

***

| 线程VS进程 |
| :--- |

1.同一进程下的多个线程共享该进程内的资源

2.创建线程的开销要远远小于进程

3.线程共享创建它的进程的地址空间；进程有自己的地址空间。

4.线程可以直接访问其进程的数据段；进程有自己的父进程的数据段副本。

5.线程可以直接与其进程的其他线程通信；进程必须使用进程间通信与同级进程通信。

6.新线程很容易创建；新进程需要复制父进程。

7.线程可以对同一进程的线程进行相当大的控制；进程只能对子进程进行控制。

8.对主线程的更改（取消、优先级更改等）可能会影响进程其他线程的行为；对父进程的更改不会影响子进程。

***

| 为啥要用多线程 |
| :--- |

多线程指的是，在一个进程中开启多个线程，简单的讲：如果多个任务共用一块地址空间，那么必须在一个进程内开启多个线程。详细的讲分为4点：

1.多线程共享一个进程的地址空间

2.线程比进程更轻量级，线程比进程更容易创建可撤销，在许多操作系统中，创建一个线程比创建一个进程要快10-100倍，在有大量线程需要动态和快速修改时，这一特性很有用

3.若多个线程都是cpu密集型的，那么并不能获得性能上的增强，但是如果存在大量的计算和大量的I/O处理，拥有多个线程允许这些活动彼此重叠运行，从而会加快程序执行的速度。

4.在多cpu系统中，为了最大限度的利用多核，可以开启多个线程，比开进程开销要小的多。（这一条并不适用于python）

<!-- OCR_START -->
- 内核
- 键盘
- 磁盘
<!-- OCR_END -->

￼

开启一个字处理软件进程，该进程肯定需要办不止一件事情，比如监听键盘输入，处理文字，定时自动将文字保存到硬盘，这三个任务操作的都是同一块数据，因而不能用多进程。只能在一个进程里并发地开启三个线程,如果是单线程，那就只能是，键盘输入时，不能处理文字和自动保存，自动保存时又不能输入和处理文字。

***

| 开启线程的两种方式 |
| :--- |

我们之前学过`mutilprocess`模块，用来开启进程，只要会了那个模块，线程的模块，接口一毛一样

启动线程的模块：`threading`

**方式一：**

```plain
from  threading import Thread
import time
def task(name):
    print('%s is running' %name)
    time.sleep(2)
    print('%s is down' %name)
if __name__ == '__main__':
    obj=Thread(target=task,args=('线程1',))
    obj.start()
    print('主线程')
```

<!-- OCR_START -->
- PYTHON
- ?并发编程
- 08多线程.py
- from
- threading
- import Thread
- import time
- 4
- def task(name):
- 5
- print('%s is running'%name)
- 6
- time.sleep(2)
- 7
- print（'%s is down' %name)
- 9
- name
- main:
- 10
- obj=Thread（target=task,args=(`线程1',))
- 11
- obj.start()
- 12
- print（'主线程'）
- 13
- Run:
- 08多线程×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/U
- 线程1isrunning
- 主线程
- 线程1isdown
- Process finished with exit code 0
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

**方式二：**

```plain
from  threading import Thread
import time
class MyThread(Thread):
    def run(self):
        print('%s is running' %self.name)
        time.sleep(2)
        print('%s is down' %self.name)
if __name__ == '__main__':
    obj=MyThread()
    obj.start()
    print('主线程')
```

<!-- OCR_START -->
- 14
- fromthreading import Thread
- 15
- 16
- import time
- 17
- 18
- class MyThread(Thread):
- 19
- def run(self):
- 20
- print('%s is running'%self.name)
- 21
- time.sleep(2)
- 22
- print('%s is down' %self.name)
- 23
- 24
- 白if
- name
- main
- 25
- obj=MyThread(）
- 26
- obj.start()
- 27
- print（'主线程'）
- 28
- if_name
- Run:
- 08多线程×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python
- Thread-1 is running
- 主线程
- Thread-1 is down
- ocess finished with exit code 0
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 14
- from  threading import Thread
- 15
- 16
- import time
- 17
- 18
- class MyThread(Thread):
- 19
- of
- def run(self):
- 20
- print('%s is running'
- %self.name)
- 21
- time.sleep(2)
- 22
- print('%s is down' %self.name)
- 23
- 24
- if
- name
- main
- 25
- obj=MyThread（name=‘线程1'）
- 26
- obj.start()
- 27
- print（主线程'）
- 28
- if_name_=='_main_
- Run:
- 08多线程
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python
- 线程1isrunning
- 主线程
- 线程1isdown
- 曾老湿
- ocess finished with exit code O
- DriverZeng
<!-- OCR_END -->

￼

***

| 线程对象其他相关属性 |
| :--- |

```plain
Thread实例对象的方法
  # isAlive(): 返回线程是否活动的。
  # getName(): 返回线程名。
  # setName(): 设置线程名。
threading模块提供的一些方法：
  # threading.currentThread(): 返回当前的线程变量。
  # threading.enumerate(): 返回一个包含正在运行的线程的list。正在运行指线程启动后、结束前，不包括启动前和终止后的线程。
  # threading.activeCount(): 返回正在运行的线程数量，与len(threading.enumerate())有相同的结果。
```

```plain
from threading import Thread
import threading
from multiprocessing import Process
import os
def work():
    import time
    time.sleep(3)
    print(threading.current_thread().getName())
if __name__ == '__main__':
    #在主进程下开启线程
    t=Thread(target=work)
    t.start()
    print(threading.current_thread().getName())
    print(threading.current_thread()) #主线程
    print(threading.enumerate()) #连同主线程在内有两个运行的线程
    print(threading.active_count())
    print('主线程/主进程')
    '''
    打印结果:
    MainThread
    <_MainThread(MainThread, started 140735268892672)>
    [<_MainThread(MainThread, started 140735268892672)>, <Thread(Thread-1, started 123145307557888)>]
    主线程/主进程
    Thread-1
    '''
```

主线程等待子线程结束

```plain
from threading import Thread
import time
def sayhi(name):
    time.sleep(2)
    print('%s say hello' %name)
if __name__ == '__main__':
    t=Thread(target=sayhi,args=('zls',))
    t.start()
    t.join()
    print('主线程')
    print(t.is_alive())
    '''
    zls say hello
    主线程
    False
    '''
```

**active_count和current_thread**

```plain
from threading import Thread,active_count,current_thread
import time,os
def task():
    print('%s is running' %current_thread().name)
    time.sleep(2)
if __name__ == '__main__':
    t=Thread(target=task,)
    t.start()
    # t.join()
    # print('主',active_count())
    print('主',current_thread().name)
```

## 守护线程

无论是进程还是线程，都遵循：守护xxx会等待主xxx运行完毕后被销毁

需要强调的是：运行完毕并非终止运行

```plain
#1.对主进程来说，运行完毕指的是主进程代码运行完毕
#2.对主线程来说，运行完毕指的是主线程所在的进程内所有非守护线程统统运行完毕，主线程才算运行完毕
```

详细解释：

```plain
#1 主进程在其代码结束后就已经算运行完毕了（守护进程在此时就被回收）,然后主进程会一直等非守护的子进程都运行完毕后回收子进程的资源(否则会产生僵尸进程)，才会结束，
#2 主线程在其他非守护线程运行完毕后才算运行完毕（守护线程在此时就被回收）。因为主线程的结束意味着进程的结束，进程整体的资源都将被回收，而进程必须保证非守护线程都运行完毕后才能结束。
```

```plain
from threading import Thread
from multiprocessing import Process
import time
def foo():
    print(123)
    time.sleep(1)
    print("end123")
def bar():
    print(456)
    time.sleep(3)
    print("end456")
if __name__ == '__main__':
    # t1=Thread(target=foo)
    # t2=Thread(target=bar)
    t1=Process(target=foo)
    t2=Process(target=bar)
    t1.daemon=True
    t1.start()
    t2.start()
    print("main-------")
    '''
    123
    main-------
    456
    end456
    '''
    '''
    main-------
    123
    456
    end456
    '''
    '''
    main-------
    456
    end456
    '''
```

## 线程互斥锁

```plain
from threading import Thread,Lock
import time
mutex=Lock()
n=100
def task():
    global n
    mutex.acquire()
    temp=n
    time.sleep(0.1)
    n=temp-1
    mutex.release()
if __name__ == '__main__':
    t_l=[]
    for i in range(100):
        t=Thread(target=task)
        t_l.append(t)
        t.start()
    for t in t_l:
        t.join()
    print(n)
```

## GIL全局解释器锁

***

| 什么是GIL |
| :--- |

```plain
'''
定义：
In CPython, the global interpreter lock, or GIL, is a mutex that prevents multiple 
native threads from executing Python bytecodes at once. This lock is necessary mainly 
because CPython’s memory management is not thread-safe. (However, since the GIL 
exists, other features have grown to depend on the guarantees that it enforces.)
'''
结论：在Cpython解释器中，同一个进程下开启的多线程，同一时刻只能有一个线程执行，无法利用多核优势
```

>  
>
> 首先需要明确的一点是GIL并不是Python的特性，它是在实现Python解析器(CPython)时所引入的一个概念。就好比C++是一套语言（语法）标准，但是可以用不同的编译器来编译成可执行代码。有名的编译器例如GCC，INTEL C++，Visual C++等。Python也一样，同样一段代码可以通过CPython，PyPy，Psyco等不同的Python执行环境来执行。像其中的JPython就没有GIL。然而因为CPython是大部分环境下默认的Python执行环境。所以在很多人的概念里CPython就是Python，也就想当然的把GIL归结为Python语言的缺陷。所以这里要先明确一点：GIL并不是Python的特性，Python完全可以不依赖于GIL

***

GIL本质就是一把互斥锁，既然是互斥锁，所有互斥锁的本质都一样，都是将并发运行变成串行，以此来控制同一时间内共享数据只能被一个任务所修改，进而保证数据安全。

可以肯定的一点是：保护不同的数据的安全，就应该加不同的锁。

要想了解GIL，首先确定一点：每次执行python程序，都会产生一个独立的进程。例如python test.py，python aaa.py，python bbb.py会产生3个不同的python进程

```plain
'''
#验证python test.py只会产生一个进程
#test.py内容
import os,time
print(os.getpid())
time.sleep(1000)
'''
python3 test.py 
#在windows下
tasklist |findstr python
#在linux下
ps aux |grep python
验证python test.py只会产生一个进程
```

在一个python的进程内，不仅有test.py的主线程或者由该主线程开启的其他线程，还有解释器开启的垃圾回收等解释器级别的线程，总之，所有线程都运行在这一个进程内，毫无疑问

```plain
#1 所有数据都是共享的，这其中，代码作为一种数据也是被所有线程共享的（test.py的所有代码以及Cpython解释器的所有代码）
例如：test.py定义一个函数work（代码内容如下图），在进程内所有线程都能访问到work的代码，于是我们可以开启三个线程然后target都指向该代码，能访问到意味着就是可以执行。
#2 所有线程的任务，都需要将任务的代码当做参数传给解释器的代码去执行，即所有的线程要想运行自己的任务，首先需要解决的是能够访问到解释器的代码。
```

综上：

如果多个线程的target=work，那么执行流程是

多个线程先访问到解释器的代码，即拿到执行权限，然后将target的代码交给解释器的代码去执行

解释器的代码是所有线程共享的，所以垃圾回收线程也可能访问到解释器的代码而去执行，这就导致了一个问题:对于同一个数据100，可能线程1执行x=100的同时，而垃圾回收执行的是回收100的操作，解决这种问题没有什么高明的方法，就是加锁处理，如下图的GIL，保证python解释器同一时间只能执行一个任务的代码

<!-- OCR_START -->
- GIL
- GIL.acquire()
- globaln
- mutex.acquire(
- tem=n
- 解释器的代码（参数）
- time.sleep(0.5)
- n=temp-1
- mutex.release()
- GIL.release()
- mutex
- 同一进程内的多个线程
- 垃圾回收线程
- 线程1
- 线程2
- 线程3
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## GIL与Lock

GIL保护的是解释器级的数据，保护用户自己的数据则需要自己加锁处理，如下图

<!-- OCR_START -->
- Python GIL vs thread Lock
- 线程共享数据池
- 赋值给count=1，并释放gillock
- count=0
- 拿到公共数据count
- 也要修改count
- Py thread
- 1
- 2
- 再次申请到gillock
- 申请到gillock
- 执行完count++操作，
- 并赋值给count=1
- 12
- python解释器
- 重复之前第一次执行的所有过程
- 调用系统原生线程
- 调用原生线程
- OS
- 完成count++
- 执行到时间了，被要求释放gil
- 在cpu上执行
- 10
- cpu1
- cpu2
- cpu3
- cpu4
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
from threading import Thread,Lock
import time
mutex=Lock()
n=100
def task():
    global n
    with mutex:
        temp=n
        time.sleep(0.1)
        n=temp-1
if __name__ == '__main__':
    l=[]
    for i in range(100):
        t=Thread(target=task)
        l.append(t)
        t.start()
    for t in l:
        t.join()
    print(n)
```

## GIL与多线程

有了GIL的存在，同一时刻同一进程中只有一个线程被执行

听到这里，有的同学立马质问：进程可以利用多核，但是开销大，而python的多线程开销小，但却无法利用多核优势，也就是说python没用了，php才是最牛逼的语言？

别着急啊，老娘还没讲完呢。

要解决这个问题，我们需要在几个点上达成一致：

```plain
#1. cpu到底是用来做计算的，还是用来做I/O的？
#2. 多cpu，意味着可以有多个核并行完成计算，所以多核提升的是计算性能
#3. 每个cpu一旦遇到I/O阻塞，仍然需要等待，所以多核对I/O操作没什么用处
```

一个工人相当于cpu，此时计算相当于工人在干活，I/O阻塞相当于为工人干活提供所需原材料的过程，工人干活的过程中如果没有原材料了，则工人干活的过程需要停止，直到等待原材料的到来。

如果你的工厂干的大多数任务都要有准备原材料的过程（I/O密集型），那么你有再多的工人，意义也不大，还不如一个人，在等材料的过程中让工人去干别的活，

反过来讲，如果你的工厂原材料都齐全，那当然是工人越多，效率越高

**结论：**

对计算来说，cpu越多越好，但是对于I/O来说，再多的cpu也没用

当然对运行一个程序来说，随着cpu的增多执行效率肯定会有所提高（不管提高幅度多大，总会有所提高），这是因为一个程序基本上不会是纯计算或者纯I/O，所以我们只能相对的去看一个程序到底是计算密集型还是I/O密集型，从而进一步分析python的多线程到底有无用武之地

```plain
#分析：
我们有四个任务需要处理，处理方式肯定是要玩出并发的效果，解决方案可以是：
方案一：开启四个进程
方案二：一个进程下，开启四个线程
#单核情况下，分析结果: 
　　如果四个任务是计算密集型，没有多核来并行计算，方案一徒增了创建进程的开销，方案二胜
　　如果四个任务是I/O密集型，方案一创建进程的开销大，且进程的切换速度远不如线程，方案二胜
#多核情况下，分析结果：
　　如果四个任务是计算密集型，多核意味着并行计算，在python中一个进程中同一时刻只有一个线程执行用不上多核，方案一胜
　　如果四个任务是I/O密集型，再多的核也解决不了I/O问题，方案二胜
 
#结论：现在的计算机基本上都是多核，python对于计算密集型的任务开多线程的效率并不能带来多大性能上的提升，甚至不如串行(没有大量切换)，但是，对于IO密集型的任务效率还是有显著提升的。
```

## 多线程性能测试

***

| I/O密集型：多线程效率高 |
| :--- |

```plain
from multiprocessing import Process
from threading import Thread
import threading
import os,time
def work():
    time.sleep(2)
    print('===>')
if __name__ == '__main__':
    l=[]
    print(os.cpu_count()) #本机为4核
    start=time.time()
    for i in range(400):
        # p=Process(target=work) #耗时12s多,大部分时间耗费在创建进程上
        p=Thread(target=work) #耗时2s多
        l.append(p)
        p.start()
    for p in l:
        p.join()
    stop=time.time()
    print('run time is %s' %(stop-start))
```

***

| 计算密集型：多进程效率高 |
| :--- |

```plain
from multiprocessing import Process
from threading import Thread
import os,time
def work():
    res=0
    for i in range(100000000):
        res*=i
if __name__ == '__main__':
    l=[]
    print(os.cpu_count()) #本机为4核
    start=time.time()
    for i in range(4):
        p=Process(target=work) #耗时5s多
        p=Thread(target=work) #耗时18s多
        l.append(p)
        p.start()
    for p in l:
        p.join()
    stop=time.time()
    print('run time is %s' %(stop-start)
```

## 死锁现象与递归锁

进程也有死锁与递归锁，在进程那里忘记说了，放到这里一切说了额

所谓死锁： 是指两个或两个以上的进程或线程在执行过程中，因争夺资源而造成的一种互相等待的现象，若无外力作用，它们都将无法推进下去。此时称系统处于死锁状态或系统产生了死锁，这些永远在互相等待的进程称为死锁进程，如下就是死锁

```plain
from threading import Thread,Lock
import time
mutexA=Lock()
mutexB=Lock()
class MyThread(Thread):
    def run(self):
        self.func1()
        self.func2()
    def func1(self):
        mutexA.acquire()
        print('\033[41m%s 拿到A锁\033[0m' %self.name)
        mutexB.acquire()
        print('\033[42m%s 拿到B锁\033[0m' %self.name)
        mutexB.release()
        mutexA.release()
    def func2(self):
        mutexB.acquire()
        print('\033[43m%s 拿到B锁\033[0m' %self.name)
        time.sleep(2)
        mutexA.acquire()
        print('\033[44m%s 拿到A锁\033[0m' %self.name)
        mutexA.release()
        mutexB.release()
if __name__ == '__main__':
    for i in range(10):
        t=MyThread()
        t.start()
'''
Thread-1 拿到A锁
Thread-1 拿到B锁
Thread-1 拿到B锁
Thread-2 拿到A锁
然后就卡住，死锁了
'''
```

解决方法，递归锁，在Python中为了支持在同一线程中多次请求同一资源，python提供了可重入锁RLock。

这个`RLock`内部维护着一个`Lock`和一个`counter`变量，`counter`记录了`acquire`的次数，从而使得资源可以被多次`require`。直到一个线程所有的`acquire`都被`release`，其他的线程才能获得资源。上面的例子如果使用`RLock`代替`Lock`，则不会发生死锁：

```plain
mutexA=mutexB=threading.RLock() #一个线程拿到锁，counter加1,该线程内又碰到加锁的情况，则counter继续加1，这期间所有其他线程都只能等待，等待该线程释放所有锁，即counter递减到0为止
```

<!-- OCR_START -->
- 08多线程.py
- 02GILvs自定义互斥锁.py
- 38
- pr1nt（033L42m%s掌到B锁\033L0m'%seLt.name）
- 39
- mutexB.release()
- 40
- 41
- 42
- 43
- def func2(self):
- 44
- mutexB.acquire()
- 45
- print（'\033[43m%s 拿到B锁\033[0m′%self.name）
- 46
- time.sleep(2)
- 47
- 48
- 49
- 50
- 51
- 52
- 53
- 54
- name
- main
- 55
- for i in rang
- （10）:
- 56
- t=MyThread()
- 57
- t.start()
- Run:
- 02GILVS自定义互斥锁
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/d
- Thread-1 拿到A锁
- hread-2 拿到A锁
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## 信号量

信号量Semahpore（同线程一样）

```plain
## 互斥锁 同时只允许一个线程更改数据，而Semaphore是同时允许一定数量的线程更改数据 ，比如厕所有3个坑，那最多只允许3个人上厕所，后面的人只能等里面有人出来了才能再进去，如果指定信号量为3，那么来一个人获得一把锁，计数加1，当计数等于3时，后面的人均需要等待。一旦释放，就有人可以获得一把锁
## 信号量与进程池的概念很像，但是要区分开，信号量涉及到加锁的概念
from multiprocessing import Process,Semaphore
import time,random
def go_wc(sem,user):
    sem.acquire()
    print('%s 占到一个茅坑' %user)
    time.sleep(random.randint(0,3)) #模拟每个人拉屎速度不一样，0代表有的人蹲下就起来了
    sem.release()
if __name__ == '__main__':
    sem=Semaphore(5)
    p_l=[]
    for i in range(13):
        p=Process(target=go_wc,args=(sem,'user%s' %i,))
        p.start()
        p_l.append(p)
    for i in p_l:
        i.join()
    print('============》')
```

## 事件Event

Event（同线程一样）

```plain
## python线程的事件用于主线程控制其他线程的执行，事件主要提供了三个方法 set、wait、clear。
## 事件处理的机制：全局定义了一个“Flag”，如果“Flag”值为 False，那么当程序执行 event.wait 方法时就会阻塞，如果“Flag”值为True，那么event.wait 方法时便不再阻塞。
# clear：将“Flag”设置为False
# set：将“Flag”设置为True
 
from multiprocessing import Process,Event
import time,random
def car(e,n):
    while True:
        if not e.is_set(): #Flase
            print('\033[31m红灯亮\033[0m，car%s等着' %n)
            e.wait()
            print('\033[32m车%s 看见绿灯亮了\033[0m' %n)
            time.sleep(random.randint(3,6))
            if not e.is_set():
                continue
            print('走你,car', n)
            break
def police_car(e,n):
    while True:
        if not e.is_set():
            print('\033[31m红灯亮\033[0m，car%s等着' % n)
            e.wait(1)
            print('灯的是%s，警车走了,car %s' %(e.is_set(),n))
            break
def traffic_lights(e,inverval):
    while True:
        time.sleep(inverval)
        if e.is_set():
            e.clear() #e.is_set() ---->False
        else:
            e.set()
if __name__ == '__main__':
    e=Event()
    # for i in range(10):
    #     p=Process(target=car,args=(e,i,))
    #     p.start()
    for i in range(5):
        p = Process(target=police_car, args=(e, i,))
        p.start()
    t=Process(target=traffic_lights,args=(e,10))
    t.start()
    print('============》')
```

## 线程Queue

```plain
import queue
queue.Queue() #先进先出
q=queue.Queue(3)
q.put(1)
q.put(2)
q.put(3)
print(q.get())
print(q.get())
print(q.get())
queue.LifoQueue() #后进先出->堆栈
q=queue.LifoQueue(3)
q.put(1)
q.put(2)
q.put(3)
print(q.get())
print(q.get())
print(q.get())
queue.PriorityQueue() #优先级
q=queue.PriorityQueue(3) #优先级,优先级用数字表示,数字越小优先级越高
q.put((10,'a'))
q.put((-1,'b'))
q.put((100,'c'))
print(q.get())
print(q.get())
print(q.get())
```

## 进程池与线程池

在程序是IO密集的情况下用多线程，在程序是计算密集的情况下，用多进程。

在利用Python进行系统管理的时候，特别是同时操作多个文件目录，或者远程控制多台主机，并行操作可以节约大量的时间。多进程是实现并发的手段之一，需要注意的问题是：

1.很明显需要并发执行的任务通常要远大于核数

2.一个操作系统不可能无限开启进程，通常有几个核就开几个进程

3.进程开启过多，效率反而会下降（开启进程是需要占用系统资源的，而且开启多余核数目的进程也无法做到并行）

例如当被操作对象数目不大时，可以直接利用multiprocessing中的Process动态成生多个进程，十几个还好，但如果是上百个，上千个。。。手动的去限制进程数量却又太过繁琐，此时可以发挥进程池的功效。

我们就可以通过维护一个进程池来控制进程数目，比如httpd的进程模式，规定最小进程数和最大进程数...

ps：对于远程过程调用的高级应用程序而言，应该使用进程池，Pool可以提供指定数量的进程，供用户调用，当有新的请求提交到pool中时，如果池还没有满，那么就会创建一个新的进程用来执行该请求；但如果池中的进程数已经达到规定最大值，那么该请求就会等待，直到池中有进程结束，就重用进程池中的进程。

\*\*创建进程池的类：\*\*如果指定numprocess为3，则进程池会从无到有创建三个进程，然后自始至终使用这三个进程去执行所有任务，不会开启其他进程

```plain
Pool([numprocess  [,initializer [, initargs]]]):创建进程池
```

**参数介绍**

```plain
numprocess:要创建的进程数，如果省略，将默认使用cpu_count()的值
initializer：是每个工作进程启动时要执行的可调用对象，默认为None
initargs：是要传给initializer的参数组
```

**方法介绍：**

主要方法：

```plain
p.apply(func [, args [, kwargs]]):在一个池工作进程中执行func(*args,**kwargs),然后返回结果。需要强调的是：此操作并不会在所有池工作进程中并执行func函数。如果要通过不同参数并发地执行func函数，必须从不同线程调用p.apply()函数或者使用p.apply_async()
p.apply_async(func [, args [, kwargs]]):在一个池工作进程中执行func(*args,**kwargs),然后返回结果。此方法的结果是AsyncResult类的实例，callback是可调用对象，接收输入参数。当func的结果变为可用时，将理解传递给callback。callback禁止执行任何阻塞操作，否则将接收其他异步操作中的结果。
p.close():关闭进程池，防止进一步操作。如果所有操作持续挂起，它们将在工作进程终止前完成
P.jion():等待所有工作进程退出。此方法只能在close（）或teminate()之后调用
```

**其他方法：**

```plain
方法apply_async()和map_async（）的返回值是AsyncResul的实例obj。实例具有以下方法
obj.get():返回结果，如果有必要则等待结果到达。timeout是可选的。如果在指定时间内还没有到达，将引发一场。如果远程操作中引发了异常，它将在调用此方法时再次被引发。
obj.ready():如果调用完成，返回True
obj.successful():如果调用完成且没有引发异常，返回True，如果在结果就绪之前调用此方法，引发异常
obj.wait([timeout]):等待结果变为可用。
obj.terminate()：立即终止所有工作进程，同时不执行任何清理或结束任何挂起工作。如果p被垃圾回收，将自动调用此函数
```

**应用：**

```plain
## 同步调用apply
from multiprocessing import Pool
import os,time
def work(n):
    print('%s run' %os.getpid())
    time.sleep(3)
    return n**2
if __name__ == '__main__':
    p=Pool(3) #进程池中从无到有创建三个进程,以后一直是这三个进程在执行任务
    res_l=[]
    for i in range(10):
        res=p.apply(work,args=(i,)) #同步调用，直到本次任务执行完毕拿到res，等待任务work执行的过程中可能有阻塞也可能没有阻塞，但不管该任务是否存在阻塞，同步调用都会在原地等着，只是等的过程中若是任务发生了阻塞就会被夺走cpu的执行权限
        res_l.append(res)
    print(res_l)
```

```plain
## 异步调用apply_async
from multiprocessing import Pool
import os,time
def work(n):
    print('%s run' %os.getpid())
    time.sleep(3)
    return n**2
if __name__ == '__main__':
    p=Pool(3) #进程池中从无到有创建三个进程,以后一直是这三个进程在执行任务
    res_l=[]
    for i in range(10):
        res=p.apply_async(work,args=(i,)) #同步运行,阻塞、直到本次任务执行完毕拿到res
        res_l.append(res)
    #异步apply_async用法：如果使用异步提交的任务，主进程需要使用jion，等待进程池内任务都处理完，然后可以用get收集结果，否则，主进程结束，进程池可能还没来得及执行，也就跟着一起结束了
    p.close()
    p.join()
    for res in res_l:
        print(res.get()) #使用get来获取apply_aync的结果,如果是apply,则没有get方法,因为apply是同步执行,立刻获取结果,也根本无需get
```

**详解：apply_async与apply**

```plain
#一：使用进程池（异步调用,apply_async）
#coding: utf-8
from multiprocessing import Process,Pool
import time
def func(msg):
    print( "msg:", msg)
    time.sleep(1)
    return msg
if __name__ == "__main__":
    pool = Pool(processes = 3)
    res_l=[]
    for i in range(10):
        msg = "hello %d" %(i)
        res=pool.apply_async(func, (msg, ))   #维持执行的进程总数为processes，当一个进程执行完毕后会添加新的进程进去
        res_l.append(res)
    print("==============================>") #没有后面的join，或get，则程序整体结束，进程池中的任务还没来得及全部执行完也都跟着主进程一起结束了
    pool.close() #关闭进程池，防止进一步操作。如果所有操作持续挂起，它们将在工作进程终止前完成
    pool.join()   #调用join之前，先调用close函数，否则会出错。执行完close后不会有新的进程加入到pool,join函数等待所有子进程结束
    print(res_l) #看到的是<multiprocessing.pool.ApplyResult object at 0x10357c4e0>对象组成的列表,而非最终的结果,但这一步是在join后执行的,证明结果已经计算完毕,剩下的事情就是调用每个对象下的get方法去获取结果
    for i in res_l:
        print(i.get()) #使用get来获取apply_aync的结果,如果是apply,则没有get方法,因为apply是同步执行,立刻获取结果,也根本无需get
#二：使用进程池（同步调用,apply）
#coding: utf-8
from multiprocessing import Process,Pool
import time
def func(msg):
    print( "msg:", msg)
    time.sleep(0.1)
    return msg
if __name__ == "__main__":
    pool = Pool(processes = 3)
    res_l=[]
    for i in range(10):
        msg = "hello %d" %(i)
        res=pool.apply(func, (msg, ))   #维持执行的进程总数为processes，当一个进程执行完毕后会添加新的进程进去
        res_l.append(res) #同步执行，即执行完一个拿到结果，再去执行另外一个
    print("==============================>")
    pool.close()
    pool.join()   #调用join之前，先调用close函数，否则会出错。执行完close后不会有新的进程加入到pool,join函数等待所有子进程结束
    print(res_l) #看到的就是最终的结果组成的列表
    for i in res_l: #apply是同步的，所以直接得到结果，没有get()方法
        print(i)
```

***

| 基于多线程实现套接字服务支持并发 |
| :--- |

**服务端：**

```plain
from socket import *
server=socket(AF_INET,SOCK_STREAM)
server.bind(('127.0.0.1',8082))
server.listen(5)
while True: #链接循环
    conn,client_addr=server.accept()
    print(client_addr)
    while True: #通信循环
        try:
            data=conn.recv(1024)
            if len(data) == 0:break
            conn.send(data.upper())
        except ConnectionResetError:
            break
    conn.close()
```

**客户端：**

```plain
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8082))
while True:
    msg=input('>>>: ').strip()
    if len(msg) == 0:continue
    client.send(msg.encode('utf-8'))
    data=client.recv(1024)
    print(data.decode('utf-8'))
```

**并发**

```plain
### 服务端
from socket import *
from threading import Thread
def communicate(conn):
    while True:  # 通信循环
        try:
            data = conn.recv(1024)
            if len(data) == 0: break
            conn.send(data.upper())
        except ConnectionResetError:
            break
    conn.close()
def server(ip,port,backlog=5):
    server = socket(AF_INET, SOCK_STREAM)
    server.bind((ip, port))
    server.listen(backlog)
    while True:  # 链接循环
        conn, client_addr = server.accept()
        print(client_addr)
        #通信
        t=Thread(target=communicate,args=(conn,))
        t.start()
if __name__ == '__main__':
    s=Thread(target=server,args=('127.0.0.1',8083))
    s.start()
### 客户端
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8083))
while True:
    msg=input('>>>: ').strip()
    if len(msg) == 0:continue
    client.send(msg.encode('utf-8'))
    data=client.recv(1024)
    print(data.decode('utf-8'))
```

***

| 存在问题 |
| :--- |

如果客户端开多了，服务端还是会不断的创建线程，虽然线程开销小，但是还是需要创建内存空间。那也无法无限开启线程。

所以我们要限制并发的个数，不能无限开启线程。

解决方案，就是使用进程池 和 线程池，来限制并发的个数。

***

| 进程池的使用 |
| :--- |

相关知识点：同步，异步

```plain
### 异步提交
## ProcessPoolExecutor  进程池
## ThreadPoolExecutor  线程池
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
import time, random, os
def task(name):
    print('%s%s is running' %(name, os.getpid()))
    time.sleep(random.randint(1,3))
if __name__ == '__main__':
    # print(os.cpu_count())
    p = ProcessPoolExecutor(4)  # 传一个参数，max_workers 最大的进程数，如果不传递任何参数，或者None，则会根据系统的cpu核心数来创建
    ## 提交任务的两种方式：
    # 同步调用：提交完一个任务之后，就在原地等待，等待任务完完整整的拿到结果后，再执行下一行代码，会导致任务是串行执行的
    # 异步调用：提交完一个任务之后，不在原地等待，而是直接执行下一行代码，会导致任务是并发执行的。
    for i in range(20):
        p.submit(task,'进程pid：')
    print('主')
```

异步提交的结果去哪啦？

```plain
### 同步提交
## ProcessPoolExecutor  进程池
## ThreadPoolExecutor  线程池
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
import time, random, os
def task(name):
    print('%s%s is running' %(name, os.getpid()))
    time.sleep(random.randint(1,3))
    return 123
if __name__ == '__main__':
    # print(os.cpu_count())
    p = ProcessPoolExecutor(4)  # 传一个参数，max_workers 最大的进程数，如果不传递任何参数，或者None，则会根据系统的cpu核心数来创建
    ## 提交任务的两种方式：
    # 同步调用：提交完一个任务之后，就在原地等待，等待任务完完整整的拿到结果后，再执行下一行代码，会导致任务是串行执行的
    # 异步调用：提交完一个任务之后，不在原地等待，而是直接执行下一行代码，会导致任务是并发执行的。
    for i in range(20):
        # futrue=p.submit(task,'进程pid：')
        # print(futrue)
        # res=futrue.result()
        res=p.submit(task,'进程pid:').result()
        print(res)
    print('主')
```

修改函数返回结果

```plain
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
import time, random, os
def task(name,n):
    print('%s%s is running' %(name, os.getpid()))
    time.sleep(random.randint(1,3))
    return n**2
if __name__ == '__main__':
    # print(os.cpu_count())
    p = ProcessPoolExecutor(4)  # 传一个参数，max_workers 最大的进程数，如果不传递任何参数，或者None，则会根据系统的cpu核心数来创建
    ## 提交任务的两种方式：
    # 同步调用：提交完一个任务之后，就在原地等待，等待任务完完整整的拿到结果后，再执行下一行代码，会导致任务是串行执行的
    # 异步调用：提交完一个任务之后，不在原地等待，而是直接执行下一行代码，会导致任务是并发执行的。
    for i in range(20):
        # futrue=p.submit(task,'进程pid：')
        # print(futrue)
        # res=futrue.result()
        res=p.submit(task,'进程pid：',i).result()
        print(res)
    print('主')
```

***

| 异步提交等待运行完毕再拿结果 |
| :--- |

```plain
## ProcessPoolExecutor  进程池
## ThreadPoolExecutor  线程池
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
import time, random, os
def task(name,n):
    print('%s%s is running' %(name, os.getpid()))
    time.sleep(random.randint(1,3))
    return n**2
if __name__ == '__main__':
    # print(os.cpu_count())
    p = ProcessPoolExecutor(4)  # 传一个参数，max_workers 最大的进程数，如果不传递任何参数，或者None，则会根据系统的cpu核心数来创建
    ## 提交任务的两种方式：
    # 同步调用：提交完一个任务之后，就在原地等待，等待任务完完整整的拿到结果后，再执行下一行代码，会导致任务是串行执行的
    # 异步调用：提交完一个任务之后，不在原地等待，而是直接执行下一行代码，会导致任务是并发执行的。
    l=[]
    for i in range(10):
        # futrue=p.submit(task,'进程pid：')
        # print(futrue)
        # res=futrue.result()
        res=p.submit(task,'进程pid：',i)
        l.append(res)
    p.shutdown(wait=True)  #关闭进程池的入口，并在原地等待进程池内所有任务运行完毕
    for res in l:
        print(res.result())
    print('主')
```

<!-- OCR_START -->
- PYTHON并发编程进程池
- 进程池的使用.py
- process.py
- 01进程池与线程池.py
- ## ProcessPoolExecutor
- 2
- 3
- ##ThreadPoolExecutor
- 线程池
- 4
- 5
- from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
- 6
- 7
- import time,random,os
- 8
- 9
- 10
- def task(name,n):
- 11
- print(%s%s is running′%（name, os.getpid()))
- 12
- time.sleep(random.randint（1,3))
- 13
- return n**2
- 14
- 15
- 16
- 1f
- name_
- main
- 17
- # print（os.cpu_count()）
- 18
- p = ProcessPoolExecutor（4)
- #传一个参数，max_workers 最大的进程数，如果不传
- 19
- #提交任务的两种方式：
- 20
- #同步调用：提交完一个任务之后，
- 就在原地等待，等待任务完完整整的拿到结果后，再执行
- if_name_=='_main_
- Run:
- 进程池的使用×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverz
- 进程pid:31872 is running
- 进程pid:31873 is running
- 进程pid:31874is running
- 进程pid:31875isrunning
- 1
- 25
- 36
- 49
- 64
- 81
- 曾老湿
- Process
- finished with exit code 0
- DriverZeng
<!-- OCR_END -->

￼

***

| 既然拿到了结果应该处理结果 |
| :--- |

模拟简单爬虫

```plain
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
import time, random, os
import requests
def get(url):
    print('%s  GET %s' % (os.getpid(), url))
    time.sleep(random.randint(1,3))
    response=requests.get(url)
    if response.status_code == 200:
        return response.text
    else:
        return '下载失败了'
def  parse(res):
    print('%s 解析结果为： %s' %(os.getpid(),len(res)))
if __name__ == '__main__':
    urls=[
        'https://www.baidu.com',
        'https://www.sina.com',
        'https://www.jd.com',
        'https://www.driverzeng.com',
        'https://www.tmall.com',
        'https://www.aliyun.com'
    ]
    p=ProcessPoolExecutor(3)
    l=[]
    for url in urls:
        future=p.submit(get,url)
        l.append(future)
    p.shutdown(wait=True)
    for future in l:
        res=future.result()
        parse(res)
    print('主')
```

<!-- OCR_START -->
- PYTHOND并发编程D进程池
- 进程池的使用.py
- 01进程池与线程池.py
- process.pyx
- 40
- print('%s
- GET %s'%（os.getpid(),url))
- 41
- time.sleep(random.randint(1,3))
- 42
- response=requests.get(url)
- 43
- if response.status_code =
- 200:
- 44
- return response.text
- 45
- else:
- 46
- return‘下载失败了
- 47
- 48
- def
- parse(res):
- 49
- print(%s 解析结果为：%s'%（os.getpid(）len（res）)）
- 50
- 51
- if
- name
- main
- 52
- urls=
- 53
- 'https://ww.baidu.com'
- 54
- 'https://ww.sina.com'
- 55
- https://ww.jd.com'，
- 56
- 'https://ww.driverzeng.com'
- 57
- https://ww.tmall.com'
- 58
- https://ww.aliyun.com
- 59
- Run:
- 进程池的使用
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverz
- 32169
- GET https://ww.baidu.com
- 32170
- GET
- https://www.sina.com
- 32171
- 1
- 32168
- 解析结果为：
- 2443
- 526602
- 110256
- 2687
- 32168角
- 214991
- 32168解析结果为：
- 94686
- Process finished with exit code o
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

## 协程

本节的主题是基于单线程来实现并发，即只用一个主线程（很明显可利用的cpu只有一个）情况下实现并发，为此我们需要先回顾下并发的本质：切换+保存状态

cpu正在运行一个任务，会在两种情况下切走去执行其他的任务（切换由操作系统强制控制），一种情况是该任务发生了阻塞，另外一种情况是该任务计算的时间过长或有一个优先级更高的程序替代了它

<!-- OCR_START -->
- 运行
- 1、
- 进程为等待输入而阻塞
- 2、
- 调度程序选择另一个进程
- 3、
- 调度程序选择这个进程
- 4、出现有效输入
- 阻塞
- 就绪
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

ps：在介绍进程理论时，提及进程的三种执行状态，而线程才是执行单位，所以也可以将上图理解为线程的三种状态

一：其中第二种情况并不能提升效率，只是为了让cpu能够雨露均沾，实现看起来所有任务都被“同时”执行的效果，如果多个任务都是纯计算的，这种切换反而会降低效率。为此我们可以基于yield来验证。yield本身就是一种在单线程下可以保存任务运行状态的方法，我们来简单复习一下：

**单纯地切换反而会降低运行效率**

```plain
'''
1、协程：
    单线程实现并发
    在应用程序里控制多个任务的切换+保存状态
    优点：
        应用程序级别速度要远远高于操作系统的切换
    缺点：
        多个任务一旦有一个阻塞没有切，整个线程都阻塞在原地
        该线程内的其他的任务都不能执行了
        一旦引入协程，就需要检测单线程下所有的IO行为,
        实现遇到IO就切换,少一个都不行，以为一旦一个任务阻塞了，整个线程就阻塞了，
        其他的任务即便是可以计算，但是也无法运行了
2、协程序的目的：
    想要在单线程下实现并发
    并发指的是多个任务看起来是同时运行的
    并发=切换+保存状态
'''
#串行执行
import time
def func1():
    for i in range(10000000):
        i+1
def func2():
    for i in range(10000000):
        i+1
start = time.time()
func1()
func2()
stop = time.time()
print(stop - start)
#基于yield并发执行
import time
def func1():
    while True:
        yield
def func2():
    g=func1()
    for i in range(10000000):
        i+1
        next(g)
start=time.time()
func2()
stop=time.time()
print(stop-start)
```

二：第一种情况的切换。在任务一遇到io情况下，切到任务二去执行，这样就可以利用任务一阻塞的时间完成任务二的计算，效率的提升就在于此

**yield不能检测IO，实现遇到IO自动切换**

```plain
import time
def func1():
    while True:
        print('func1')
        yield
def func2():
    g=func1()
    for i in range(10000000):
        i+1
        next(g)
        time.sleep(3)
        print('func2')
start=time.time()
func2()
stop=time.time()
print(stop-start)
```

对于单线程下，我们不可避免程序中出现io操作，但如果我们能在自己的程序中（即用户程序级别，而非操作系统级别）控制单线程下的多个任务能在一个任务遇到io阻塞时就切换到另外一个任务去计算，这样就保证了该线程能够最大限度地处于就绪态，即随时都可以被cpu执行的状态，相当于我们在用户程序级别将自己的io操作最大限度地隐藏起来，从而可以迷惑操作系统，让其看到：该线程好像是一直在计算，io比较少，从而更多的将cpu的执行权限分配给我们的线程。

协程的本质就是在单线程下，由用户自己控制一个任务遇到io阻塞了就切换另外一个任务去执行，以此来提升效率。为了实现它，我们需要找寻一种可以同时满足以下条件的解决方案：

```plain
#1. 可以控制多个任务之间的切换，切换之前将任务的状态保存下来，以便重新运行时，可以基于暂停的位置继续执行。
#2. 作为1的补充：可以检测io操作，在遇到io操作的情况下才发生切换
```

***

| 协程介绍 |
| :--- |

协程：是单线程下的并发，又称微线程，纤程。英文名Coroutine。一句话说明什么是线程：协程是一种用户态的轻量级线程，即协程是由用户程序自己控制调度的。

**需要强调的是：**

```plain
#1. python的线程属于内核级别的，即由操作系统控制调度（如单线程遇到io或执行时间过长就会被迫交出cpu执行权限，切换其他线程运行）
#2. 单线程内开启协程，一旦遇到io，就会从应用程序级别（而非操作系统）控制切换，以此来提升效率（！！！非io操作的切换与效率无关）
```

对比操作系统控制线程的切换，用户在单线程内控制协程的切换

**优点如下：**

```plain
#1. 协程的切换开销更小，属于程序级别的切换，操作系统完全感知不到，因而更加轻量级
#2. 单线程内就可以实现并发的效果，最大限度地利用cpu
```

**缺点如下：**

```plain
#1. 协程的本质是单线程下，无法利用多核，可以是一个程序开启多个进程，每个进程内开启多个线程，每个线程内开启协程
#2. 协程指的是单个线程，因而一旦协程出现阻塞，将会阻塞整个线程
```

**总结协程特点：**

1.必须在只有一个单线程里实现并发

2.修改共享数据不需加锁

3.用户程序里自己保存多个控制流的上下文栈

4.附加：一个协程遇到IO操作自动切换到其它协程（如何实现检测IO，yield、greenlet都无法实现，就用到了gevent模块（select机制）

## Greenlet

如果我们在单个线程内有20个任务，要想实现在多个任务之间切换，使用yield生成器的方式过于麻烦（需要先得到初始化一次的生成器，然后再调用send。。。非常麻烦），而使用greenlet模块可以非常简单地实现这20个任务直接的切换

```plain
#安装
pip3 install greenlet
```

```plain
from greenlet import greenlet
def eat(name):
    print('%s eat 1' %name)
    g2.switch('zls')
    print('%s eat 2' %name)
    g2.switch()
def play(name):
    print('%s play 1' %name)
    g1.switch()
    print('%s play 2' %name)
g1=greenlet(eat)
g2=greenlet(play)
g1.switch('zls')#可以在第一次switch时传入参数，以后都不需要
```

单纯的切换（在没有io的情况下或者没有重复开辟内存空间的操作），反而会降低程序的执行速度

```plain
#顺序执行
import time
def f1():
    res=1
    for i in range(100000000):
        res+=i
def f2():
    res=1
    for i in range(100000000):
        res*=i
start=time.time()
f1()
f2()
stop=time.time()
print('run time is %s' %(stop-start)) #10.985628366470337
#切换
from greenlet import greenlet
import time
def f1():
    res=1
    for i in range(100000000):
        res+=i
        g2.switch()
def f2():
    res=1
    for i in range(100000000):
        res*=i
        g1.switch()
start=time.time()
g1=greenlet(f1)
g2=greenlet(f2)
g1.switch()
stop=time.time()
print('run time is %s' %(stop-start)) # 52.763017892837524
```

greenlet只是提供了一种比generator更加便捷的切换方式，当切到一个任务执行时如果遇到io，那就原地阻塞，仍然是没有解决遇到IO自动切换来提升效率的问题。

单线程里的这20个任务的代码通常会既有计算操作又有阻塞操作，我们完全可以在执行任务1时遇到阻塞，就利用阻塞的时间去执行任务2。。。。如此，才能提高效率，这就用到了Gevent模块。

## Gevent介绍

```plain
#安装
pip3 install gevent
```

Gevent 是一个第三方库，可以轻松通过gevent实现并发同步或异步编程，在gevent中用到的主要模式是Greenlet, 它是以C扩展模块形式接入Python的轻量级协程。 Greenlet全部运行在主程序操作系统进程的内部，但它们被协作式地调度。

```plain
#用法
g1=gevent.spawn(func,1,,2,3,x=4,y=5)创建一个协程对象g1，spawn括号内第一个参数是函数名，如eat，后面可以有多个参数，可以是位置实参或关键字实参，都是传给函数eat的
g2=gevent.spawn(func2)
g1.join() #等待g1结束
g2.join() #等待g2结束
#或者上述两步合作一步：gevent.joinall([g1,g2])
g1.value#拿到func1的返回值
```

遇到IO阻塞时会自动切换任务

```plain
import gevent
def eat(name):
    print('%s eat 1' %name)
    gevent.sleep(2)
    print('%s eat 2' %name)
def play(name):
    print('%s play 1' %name)
    gevent.sleep(1)
    print('%s play 2' %name)
g1=gevent.spawn(eat,'zls')
g2=gevent.spawn(play,name='zls')
g1.join()
g2.join()
#或者gevent.joinall([g1,g2])
print('主')
```

上例gevent.sleep(2)模拟的是gevent可以识别的io阻塞,

而time.sleep(2)或其他的阻塞,gevent是不能直接识别的需要用下面一行代码,打补丁,就可以识别了

from gevent import monkey;monkey.patch_all()必须放到被打补丁者的前面，如time，socket模块之前

或者我们干脆记忆成：要用gevent，需要将from gevent import monkey;monkey.patch_all()放到文件的开头

```plain
from gevent import monkey;monkey.patch_all()
import gevent
import time
def eat():
    print('eat food 1')
    time.sleep(2)
    print('eat food 2')
def play():
    print('play 1')
    time.sleep(1)
    print('play 2')
g1=gevent.spawn(eat)
g2=gevent.spawn(play_phone)
gevent.joinall([g1,g2])
print('主')
```

我们可以用threading.current_thread().getName()来查看每个g1和g2，查看的结果为DummyThread-n，即假线程

## Gevent之同步与异步

```plain
from gevent import spawn,joinall,monkey;monkey.patch_all()
import time
def task(pid):
    """
    Some non-deterministic task
    """
    time.sleep(0.5)
    print('Task %s done' % pid)
def synchronous():
    for i in range(10):
        task(i)
def asynchronous():
    g_l=[spawn(task,i) for i in range(10)]
    joinall(g_l)
if __name__ == '__main__':
    print('Synchronous:')
    synchronous()
    print('Asynchronous:')
    asynchronous()
#上面程序的重要部分是将task函数封装到Greenlet内部线程的gevent.spawn。 初始化的greenlet列表存放在数组threads中，此数组被传给gevent.joinall 函数，后者阻塞当前流程，并执行所有给定的greenlet。执行流程只会在 所有greenlet执行完后才会继续向下走。
```

***

| Gevent之应用举例一 |
| :--- |

**协程应用：爬虫**

```plain
from gevent import monkey;monkey.patch_all()
import gevent
import requests
import time
def get_page(url):
    print('GET: %s' %url)
    response=requests.get(url)
    if response.status_code == 200:
        print('%d bytes received from %s' %(len(response.text),url))
start_time=time.time()
gevent.joinall([
    gevent.spawn(get_page,'https://www.python.org/'),
    gevent.spawn(get_page,'https://www.yahoo.com/'),
    gevent.spawn(get_page,'https://github.com/'),
])
stop_time=time.time()
print('run time is %s' %(stop_time-start_time))
```

***

| Gevent之应用举例二 |
| :--- |

通过gevent实现单线程下的socket并发（from gevent import monkey;monkey.patch_all()一定要放到导入socket模块之前，否则gevent无法识别socket的阻塞）

**服务端**

```plain
from gevent import monkey;monkey.patch_all()
from socket import *
import gevent
#如果不想用money.patch_all()打补丁,可以用gevent自带的socket
# from gevent import socket
# s=socket.socket()
def server(server_ip,port):
    s=socket(AF_INET,SOCK_STREAM)
    s.setsockopt(SOL_SOCKET,SO_REUSEADDR,1)
    s.bind((server_ip,port))
    s.listen(5)
    while True:
        conn,addr=s.accept()
        gevent.spawn(talk,conn,addr)
def talk(conn,addr):
    try:
        while True:
            res=conn.recv(1024)
            print('client %s:%s msg: %s' %(addr[0],addr[1],res))
            conn.send(res.upper())
    except Exception as e:
        print(e)
    finally:
        conn.close()
if __name__ == '__main__':
    server('127.0.0.1',8080)
```

**客户端**

```plain
from socket import *
client=socket(AF_INET,SOCK_STREAM)
client.connect(('127.0.0.1',8080))
while True:
    msg=input('>>: ').strip()
    if not msg:continue
    client.send(msg.encode('utf-8'))
    msg=client.recv(1024)
    print(msg.decode('utf-8'))
```

**多线程并发多个客户端**

```plain
from threading import Thread
from socket import *
import threading
def client(server_ip,port):
    c=socket(AF_INET,SOCK_STREAM) #套接字对象一定要加到函数内，即局部名称空间内，放在函数外则被所有线程共享，则大家公用一个套接字对象，那么客户端端口永远一样了
    c.connect((server_ip,port))
    count=0
    while True:
        c.send(('%s say hello %s' %(threading.current_thread().getName(),count)).encode('utf-8'))
        msg=c.recv(1024)
        print(msg.decode('utf-8'))
        count+=1
if __name__ == '__main__':
    for i in range(500):
        t=Thread(target=client,args=('127.0.0.1',8080))
        t.start()
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:27:48  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ybwnty>