# 第1章 python基础（旧版）

# 1.1 python编程语言介绍

## 本节重点：

* 让学生理解为编程语言是什么？为什么要编程？
* 让学生大体明白，编程语言是如何与计算机底层通信的
* 编程语言有哪些分类？
* 分别列举主流编程语言的特点

> **本节时长需控制在25-30分钟内**

## 什么是编程？为什么要编程？(5分钟)

编程 是个动词，编程==写代码，写代码为了什么呢? 为了让计算机干你想要干的事情，比如，马化腾想跟别人聊天，于是写了个聊天软件，这个软件就是一堆代码的集合，这些代码是什么？这些代码是计算机能理解的语言。

例子：你是公司老板，你有一个员工是中国人，你让他干活，就得说中文，还有一个员工是美国人，让他干活，就得说英文，你还有一条狗，让他听话，你就得汪汪汪。。。，那现在你有台电脑，让它干活，就得用它能理解的语言。

那计算能理解的语言是什么呢？ 之前，我们已经了解到，它只能理解2进制，0101010...，你总不能人肉输一堆二进制给计算机(虽然最原始的计算机就是这么干的)让它工作吧，这样开发速度太慢了。所以最好的办法就是人输入简单的指令，计算机能把指令转成二进制进行执行，举例如下:

假如 程序员想让计算机 播放一首 歌曲 ， 只需要输入指令 ，

```plain
open "老男孩.mp3"
play
```

计算机的CPU接收到这样的指令后，会把它转成一堆 只有cpu可以理解的指令，然后再将指令变成各种对应的如下类似二进制

```plain
[  op  |  rs |  rt | address/immediate]
   35     3     8           68           decimal
 100011 00011 01000 00000 00001 000100   binary
```

最终cpu 去调用你的硬盘上这首歌，通过音箱播放。

上面cpu那段指令太难理解了，如果让你天天写这样的代码，大家非得自杀不可。还好，伟大的计算机先驱们，开发了各种编程语言，让我们只需要通过写一些简单的规则，就能操作计算机工作啦。

## 有哪些编程语言？(10分钟)

编程语言总体分以为机器语言、汇编语言、高级语言，如下

**机器语言**

计算机内部只能识别二进制代码。用 0 和 1 描述的指令称为**机器指令**，全部机器指令的集合构成**机器语言**，用它编写的程序叫**目标程序**——只有目标程序能被计算机直接识别和执行。

但机器语言编写的程序无明显特征、难记忆、不便读写，且依赖具体机种，局限性很大，属于**低级语言**。

用机器语言编程极其繁琐：程序员要熟记全部指令代码，自己处理每条指令和数据的存储分配、输入输出，还要记住每步所用工作单元的状态。编写时间往往是实际运行时间的几十甚至几百倍，而且全是 0/1 代码，直观性差、容易出错。

**如今除计算机厂家的专业人员外，绝大多数程序员已不再学习机器语言。**

机器语言是微处理器理解和使用的，用于控制它的操作二进制代码。

尽管机器语言好像是很复杂的，然而它是有规律的。

存在着多至100000种机器语言的指令。这意味着不能把这些种类全部列出来。

以下是一些示例：

指令部份的示例

0000 代表 加载（LOAD）

0001 代表 存储（STORE）

...

暂存器部份的示例

0000 代表暂存器 A

0001 代表暂存器 B

...

存储器部份的示例

000000000000 代表地址为 0 的存储器

000000000001 代表地址为 1 的存储器

000000010000 代表地址为 16 的存储器

100000000000 代表地址为 2^11 的存储器

集成示例

0000,0000,000000010000 代表 LOAD A, 16

0000,0001,000000000001 代表 LOAD B, 1

0001,0001,000000010000 代表 STORE B, 16

0001,0001,000000000001 代表 STORE B, 1\[1]

**汇编语言**

**汇编语言**与机器语言本质相同，都是直接操作硬件，只是指令改用英文缩写标识符，更易识别和记忆。它同样要求编程者把每一步具体操作都写成命令。

* **缺点**：一条指令只对应一个很细微的动作（如移动、自增），因此源程序冗长、复杂、易错，且需要更多计算机专业知识
* **优点**：能完成一般高级语言做不到的事情；源程序汇编后生成的可执行文件**更小、执行更快**

汇编的hello world，打印一句hello world, 需要写十多行，也是醉了。

```plain
; hello.asm 
section .data            ; 数据段声明
        msg db "Hello, world!", 0xA     ; 要输出的字符串
        len equ $ - msg                 ; 字串长度
section .text            ; 代码段声明
global _start            ; 指定入口函数
_start:                  ; 在屏幕上显示一个字符串
        mov edx, len     ; 参数三：字符串长度
        mov ecx, msg     ; 参数二：要显示的字符串
        mov ebx, 1       ; 参数一：文件描述符(stdout) 
        mov eax, 4       ; 系统调用号(sys_write) 
        int 0x80         ; 调用内核功能
                         ; 退出程序
        mov ebx, 0       ; 参数一：退出代码
        mov eax, 1       ; 系统调用号(sys_exit) 
        int 0x80         ; 调用内核功能
```

**高级语言**

高级语言是大多数编程者的选择。和汇编语言相比，它不但将许多相关的机器指令合成为单条指令，并且去掉了与具体操作有关但与完成工作无关的细节，例如使用堆栈、寄存器等，这样就大大简化了程序中的指令。同时，由于省略了很多细节，编程者也就不需要有太多的专业知识。

高级语言主要是相对于汇编语言而言，它并不是特指某一种具体的语言，而是包括了很多编程语言，像最简单的编程语言PASCAL语言也属于高级语言。

**高级语言所编制的程序不能直接被计算机识别，必须经过转换才能被执行**，按转换方式可将它们分为两类：

**编译类**：在程序**执行之前**就把源代码"翻译"成目标代码（机器语言），因此目标程序可脱离语言环境独立执行——编译后生成的可执行文件由 CPU 能直接理解的二进制机器码组成，使用方便、效率较高。

* **缺点**：一旦需要修改，必须先改源代码，再重新编译生成新的目标文件（`*.obj`）才能执行。只有目标文件而没有源码时，修改很不方便。

> 用翻译官举例子

<!-- OCR_START -->
- 人能读懂的代码
- print("hello world!")
- 编译型
- 解释型
- 字节码
- 执行前一次性
- 编译=翻译
- 翻译
- 虚拟机
- 机器能读懂的代码
- 010101010101110011111000111..
- 边执行边翻译
- cpu运行
<!-- OCR_END -->

**编译后程序运行时不需要重新翻译，直接使用编译的结果就行了。程序执行效率高，依赖编译器，跨平台性差些**。如C、C++、Delphi等

**解释类**：执行方式类似日常生活中的"同声翻译"——源代码一边由解释器"翻译"成目标代码，一边执行。

* **缺点**：效率较低；不能生成可独立执行的可执行文件，程序不能脱离解释器运行（就像跟外国人说话必须有翻译在场）
* **优点**：方式灵活，可以动态调整、修改应用程序

典型语言：Python、Java、PHP、Ruby 等。

#### 总结

**机器语言**

优点是最底层，速度最快，缺点是最复杂，开发效率最低

**汇编语言**

优点是比较底层，速度最快，缺点是复杂，开发效率最低

**高级语言**

编译型语言执行速度快，不依赖语言环境运行，跨平台差

解释型跨平台好，一份代码，到处使用，缺点是执行速度慢，依赖解释器运行

## 主流编程语言介绍(10分钟)

世界上的编程语言有600多种，但真正大家主流在使用的最多二三十种，不同的语言有自己的特点和擅长领域，随着计算机的不断发展，新语言在不断诞生，也同时有很多老旧的语言慢慢无人用了。有个权威的语言排名网站，可以看到主流的编程语言是哪些

\*2017年5月数据(<https://www.tiobe.com/tiobe-index/> )

<!-- OCR_START -->
| 排名(May 2017) | 排名(May 2016) | 名称 | 占比 | 变化 |
| --- | --- | --- | --- | --- |
| 1 | 1 | Java | 14.639% | -6.32% |
| 2 | 2 | C | 7.002% | -6.22% |
| 3 | 3 | C++ | 4.751% | -1.95% |
| 4 | 5 | Python | 3.548% | -0.24% |
| 5 | 4 | C# | 3.457% | -1.02% |
| 6 | 10 | Visual Basic .NET | 3.391% | +1.07% |
| 7 | 7 | JavaScript | 3.071% | +0.73% |
| 8 | 12 | Assembly language | 2.859% | +0.98% |
| 9 | 6 | PHP | 2.693% | -0.30% |
| 10 | 9 | Perl | 2.602% | +0.28% |
| 11 | 8 | Ruby | 2.429% | +0.09% |
| 12 | 13 | Visual Basic | 2.347% | +0.52% |
| 13 | 15 | Swift | 2.274% | +0.68% |
| 14 | 16 | R | 2.192% | +0.86% |
| 15 | 14 | Objective-C | 2.101% | +0.50% |
| 16 | 42 | Go | 2.080% | +1.83% |
| 17 | 18 | MATLAB | 2.063% | +0.78% |
| 18 | 11 | Delphi/Object Pascal | 2.038% | +0.03% |
| 19 | 19 | PL/SQL | 1.676% | +0.47% |
| 20 | 22 | Scratch | 1.668% | +0.74% |
<!-- OCR_END -->

长期语言排名

<!-- OCR_START -->
- VeryLongTermHistory
- To see the bigger picture, please find below the positions of the top 10 programming languages of many years back. Please note that these are
- average positions for a period of 12months.
- Programming Language
- 2017
- 2012
- 2007
- 2002
- 1997
- 1992
- 1987
- Java
- 1
- 14
- 2
- C++
- 3
- 4
- 发展越来越好的
- 7
- Python
- 5
- 9
- 27
- PHP
- 6
- JavaScript
- 8
- 20
- Visual Basic .NET
- 21
- 没落的语言
- Perl
- 11
- Assembly language
- 10
- COBOL
- 25
- 31
- 17
- 13
- Lisp
- 12
- Prolog
- 33
- 37
- 26
- 18
- Pascal
- 102
- 19
- 29
<!-- OCR_END -->

下面介绍下几个主流的编程语言：(5分钟快速介绍)

**C语言:**

**C 语言**：兼具高级语言与汇编语言的特点，由美国贝尔研究所的 D.M.Ritchie 于 1972 年推出。1978 年后陆续移植到大、中、小及微型机上。

* 既可写系统应用程序，也可写不依赖硬件的应用程序
* 数据处理能力强，广泛用于科研、系统软件、二维/三维图形与动画
* 典型场景：单片机、嵌入式系统开发

**C++：**

C++是C语言的继承的扩展，它既可以进行C语言的过程化程序设计，又可以进行以抽象数据类型为特点的基于对象的程序设计，还可以进行以继承和多态为特点的面向对象的程序设计。C++擅长面向对象程序设计的同时，还可以进行基于过程的程序设计，因而C++就适应的问题规模而论，大小由之。

C++不仅拥有计算机高效运行的实用性特征，同时还致力于提高大规模程序的编程质量与程序设计语言的问题描述能力。

**JAVA:**

**Java**：可撰写跨平台应用软件的面向对象语言，由 Sun Microsystems 于 1995 年 5 月推出，是 Java 程序设计语言与 Java 平台（JavaSE / JavaEE / JavaME）的总称。

* 特点：通用性、高效性、**平台移植性**和安全性俱佳
* 应用：个人 PC、数据中心、游戏主机、超级计算机、移动电话、互联网
* 拥有全球最大的开发者社群，在云计算与移动互联网时代优势显著

**PHP:**

PHP（外文名:PHP: Hypertext Preprocessor，中文名："超文本预处理器"）是一种通用开源脚本语言。语法吸收了C语言、Java和Perl的特点，利于学习，使用广泛，主要适用于Web开发领域

**Ruby:**

Ruby 是开源的，在Web 上免费提供，但需要一个许可证。\[4]

Ruby 是一种通用的、解释的编程语言。

Ruby 是一种真正的面向对象编程语言。

Ruby 是一种类似于 Python 和 Perl 的服务器端脚本语言。

Ruby 可以用来编写通用网关接口（CGI）脚本。

Ruby 可以被嵌入到超文本标记语言（HTML）。

Ruby 语法简单，这使得新的开发人员能够快速轻松地学习 Ruby

**GO:**

Go 是一个开源的编程语言，它能让构造简单、可靠且高效的软件变得容易。

**Go**：2007 年末由 Robert Griesemer、Rob Pike、Ken Thompson 主持开发，后有 Ian Lance Taylor、Russ Cox 等人加入；2009 年 11 月开源，2012 年初发布 Go 1 稳定版。如今 Go 完全开放开发，拥有活跃社区。

由其擅长并发编程

**Python:**

Python是一门优秀的综合语言， Python的宗旨是简明、优雅、强大，在人工智能、云计算、金融分析、大数据开发、WEB开发、自动化运维、测试等方向应用广泛，已是全球第4大最流行的语言。

# 1.2 python 介绍

## 本节重点：

* 让学生了解Python的特点、发展史
* 通过介绍Python广泛的应用领域和前景，激发学生们的学习兴趣

> **本节时长需控制在35分钟之内**

## Python介绍(3-5分钟)

Python 的创始人是**吉多·范罗苏姆（Guido van Rossum）**。1989 年圣诞节期间，Guido 开始编写 Python 语言的编译器。

名字来自 Guido 挚爱的电视剧 *Monty Python's Flying Circus*。他的理想是：创造一种介于 C 和 shell 之间、**功能全面、易学易用、可扩展**的语言。

最新的TIOBE排行榜，Python赶超PHP占据第4， Python崇尚优美、清晰、简单，是一个优秀并广泛使用的语言。

Python 可应用于众多领域：数据分析、组件集成、网络服务、图像处理、数值计算与科学计算等。

目前业内几乎所有大中型互联网企业都在使用 Python，如 YouTube、Dropbox、Google、Yahoo!、Facebook、NASA、百度、腾讯、豆瓣、知乎、汽车之家、美团等。

## **目前Python主要应用领域：**(5-10分钟)

1. **WEB 开发**：最火的 Python Web 框架 Django（官方标语 *the framework for perfectionist with deadlines*，即"为追求完美的高效开发者打造的框架"）；此外还有支持异步高并发的 Tornado，以及短小精悍的 Flask、Bottle
2. 网络编程——支持高并发的Twisted网络框架， py3引入的asyncio使异步编程变的非常简单
3. 爬虫——爬虫领域，Python几乎是霸主地位，Scrapy\Request\BeautifuSoap\urllib等，想爬啥就爬啥
4. 云计算——目前最火最知名的云计算框架就是OpenStack,Python现在的火，很大一部分就是因为云计算
5. **人工智能**：Python 已是 AI 与大数据时代的第一开发语言。随着 Facebook 开源 PyTorch，Python 的头牌位置基本确立——曾经的竞争者（Matlab、Scala、R、Java）已难撼动其地位。
6. 自动化运维——问问中国的每个运维人员，运维人员必须会的语言是什么？10个人相信会给你一个相同的答案，它的名字叫Python
7. 金融分析——我个人之前在金融行业，10年的时候，我们公司写的好多分析程序、高频交易软件就是用的Python,到目前,Python是金融分析、量化交易领域里用的最多的语言
8. **科学运算**：从 1997 年起 NASA 就大量使用 Python 做复杂科学运算。随着 NumPy、SciPy、Matplotlib、Enthought libraries 等库的发展，Python 越来越适合科学计算与绘制高质量 2D/3D 图像。

与科学计算领域最流行的商业软件 Matlab 相比，Python 是**通用程序设计语言**，应用范围比 Matlab 的脚本语言更广泛。
9. 游戏开发——在网络游戏开发中Python也有很多应用。相比Lua or C++,Python 比 Lua 有更高阶的抽象能力，可以用更少的代码描述游戏业务逻辑，与 Lua 相比，Python 更适合作为一种 Host 语言，即程序的入口点是在 Python 那一端会比较好，然后用 C/C++ 在非常必要的时候写一些扩展。Python 非常适合编写 1 万行以上的项目，而且能够很好地把网游项目的规模控制在 10 万行代码以内。另外据我所知，知名的游戏<文明> 就是用Python写的

## **Python在一些公司的应用：**(3-5分钟)

* 谷歌：Google App Engine 、code.google.com 、Google earth 、谷歌爬虫、Google广告等项目都在大量使用Python开发
* CIA: 美国中情局网站就是用Python开发的
* NASA: 美国航天局(NASA)大量使用Python进行数据分析和运算
* YouTube:世界上最大的视频网站YouTube就是用Python开发的
* Dropbox:美国最大的在线云存储网站，全部用Python实现，每天网站处理10亿个文件的上传和下载
* Instagram:美国最大的图片分享社交网站，每天超过3千万张照片被分享，全部用python开发
* Facebook:大量的基础库均通过Python实现的
* Redhat: 世界上最流行的Linux发行版本中的yum包管理工具就是用python开发的
* 豆瓣: 公司几乎所有的业务均是通过Python开发的
* 知乎: 国内最大的问答社区，通过Python开发(国外Quora)
* 春雨医生：国内知名的在线医疗网站是用Python开发的
* 除上面之外，还有搜狐、金山、腾讯、盛大、网易、百度、阿里、淘宝 、土豆、新浪、果壳等公司都在使用Python完成各种各样的任务。

## **Python的发展史**(3-5分钟)

1989年，Guido开始写Python语言的编译器。

1991年，第一个Python编译器诞生。它是用C语言实现的，并能够调用C语言的库文件。从一出生，Python已经具有了：类，函数，异常处理，包含表和词典在内的核心数据类型，以及模块为基础的拓展系统。

Granddaddy of Python web frameworks, Zope 1 was released in 1999

Python 1.0 - January 1994 增加了 lambda, map, filter and reduce.

Python 2.0 - October 16, 2000，加入了内存回收机制，构成了现在Python语言框架的基础

Python 2.4 - November 30, 2004, 同年目前最流行的WEB框架Django 诞生

Python 2.5 - September 19, 2006

Python 2.6 - October 1, 2008

Python 2.7 - July 3, 2010

In November 2014, it was announced that Python 2.7 would be supported until 2020, and reaffirmed that there would be no 2.8 release as users were expected to move to Python 3.4+ as soon as possible

Python 3.0 - December 3, 2008 (这里要解释清楚 为什么08年就出3.0，2010年反而又推出了2.7？是因为3.0不向下兼容2.0，导致大家都拒绝升级3.0，无奈官方只能推出2.7过渡版本)

Python 3.1 - June 27, 2009

Python 3.2 - February 20, 2011

Python 3.3 - September 29, 2012

Python 3.4 - March 16, 2014

Python 3.5 - September 13, 2015

Python 3.6 - 2016-12-23 发布python3.6.0版

## **Pyhton的发展前景怎么样？**(1-3分钟)

知乎上有一篇文章，问Python未来10年的发展前景，请去看一下Alex的回答

> 未来十年Python的前景会怎样？ <https://www.zhihu.com/question/22112542/answer/166053516>

## Python 有哪些种类？(3-5分钟)

我们现在知道了Python是一门解释型语言，代码想运行，必须通过解释器执行，Python的解释器本身也可以看作是个程序（翻译官司是哪国人不重要），这个程序是什么语言开发的呢？ 答案是好几种语言？ what? 因为Python有好几种解释器，分别基于不同语言开发，每个解释器特点不同，但都能正常运行我们的Python代码，下面分别来看下：

**CPython**

当我们从Python官方网站下载并安装好Python 2.7后，我们就直接获得了一个官方版本的解释器：CPython。这个解释器是用C语言开发的，所以叫CPython。在命令行下运行python就是启动CPython解释器。

> CPython是使用最广且被的Python解释器。教程的所有代码也都在CPython下执行。

**IPython**

IPython是基于CPython之上的一个交互式解释器，也就是说，IPython只是在交互方式上有所增强，但是执行Python代码的功能和CPython是完全一样的。好比很多国产浏览器虽然外观不同，但内核其实都是调用了IE。

CPython用>>>作为提示符，而IPython用In \[序号]:作为提示符。

**PyPy**

PyPy是另一个Python解释器，它的目标是执行速度。PyPy采用JIT技术，对Python代码进行动态编译（注意不是解释），所以可以显著提高Python代码的执行速度。

绝大部分Python代码都可以在PyPy下运行，但是PyPy和CPython有一些是不同的，这就导致相同的Python代码在两种解释器下执行可能会有不同的结果。如果你的代码要放到PyPy下执行，就需要了解PyPy和CPython的不同点。

**Jython**

Jython是运行在Java平台上的Python解释器，可以直接把Python代码编译成Java字节码执行。

**IronPython**

IronPython和Jython类似，只不过IronPython是运行在微软.Net平台上的Python解释器，可以直接把Python代码编译成.Net的字节码。

## Python 2 or Python 3 ? (3-5分钟)

**In summary : Python 2.x is legacy, Python 3.x is the present and future of the language**

Python 3.0 was released in 2008. The final 2.x version 2.7 release came out in mid-2010, with a statement of

extended support for this end-of-life release. The 2.x branch will see no new major releases after that. 3.x is

under active development and has already seen over five years of stable releases, including version 3.3 in 2012,

3.4 in 2014, and 3.5 in 2015. This means that all recent standard library improvements, for example, are only

available by default in Python 3.x.

Guido van Rossum (the original creator of the Python language) decided to clean up Python 2.x properly, with less regard for backwards compatibility than is the case for new releases in the 2.x range. The most drastic improvement is the better Unicode support (with all text strings being Unicode by default) as well as saner bytes/Unicode separation.

Besides, several aspects of the core language (such as print and exec being statements, integers using floor division) have been adjusted to be easier for newcomers to learn and to be more consistent with the rest of the language, and old cruft has been removed (for example, all classes are now new-style, "range()" returns a memory efficient iterable, not a list as in 2.x).

目前虽然业内很多企业还在大量使用Python2.6 or 2.7，因为旧项目几十万甚至上百万行的代码想快速升级到3.0不是件容易的事，但是大家在开发新项目时几乎都会使用3.x。

另外Python3 确实想比2.x做了很多的改进，直观点来讲，就像从XP升级到Win7的感觉一样，棒棒的。

Py2 和Py3的具体细节区别我们在以后课程中会慢慢深入。

# 1.3 python 安装

## 本节重点：

* 让学生了安装上Python，配置好环境变量

> **本节时长需控制在5分钟之内**

Python目前已支持所有主流操作系统，在Linux,Unix,Mac系统上自带Python环境，在Windows系统上需要安装一下，超简单

## Windows安装

打开官网 <https://www.python.org/downloads/windows/> 下载中心

测试安装是否成功

windows --> 运行 --> 输入cmd ，然后回车，弹出cmd程序，输入python,如果能进入交互环境 ，代表安装成功。

# 1.4 第一个python 程序

## 本节重点：

* 让学生掌握Python代码的2种执行方式

> **本节时长需控制在10分钟之内**

## 文件执行

1. 用notepad++创建一个文件，输入以下代码

```plain
print("Hello World!")
print("Python好简单呀，我要学好挣大钱！")
```

1. 保存为HelloWorld.py , 注意要强调.py后缀名的作用
2. 进入cmd命令行，执行python HelloWorld.py, 看结果 （注意要解释文件名前面加python 的原因是要把代码交给python解释器去解释执行）

## 交互器执行

演示在python交互器下 ，输出hello world ！

> 要强调python交互器是主要用来对代码进行调试用的

## 精通各种语言的Hello World

C++

```plain
#include <iostream>
 int main(void)
 {
  std::cout<<"Hello world";
 }
```

C

```plain
#include <stdio.h>
int main(void)
{
printf("\nhello world!");
return 0;
}
```

JAVA

```plain
public class HelloWorld{
  // 程序的入口
  public static void main(String args[]){
    // 向控制台输出信息
    System.out.println("Hello World!");
  }
}
```

PHP

```plain
<?php  
             echo "hello world!";  
?>
```

Ruby

> 日本人开发的，敏感时期容易挨K

```plain
puts "Hello world."
```

GO

```plain
package main
import "fmt"
func main(){
    fmt.Printf("Hello World!\n God Bless You!");
}
```

# 1.5 变量

## 本节重点：

* 让学生掌握变量的作用
* 让学生掌握标识符的命名规范
* 掌握常量与变量的区别

> **本节时长需控制在25分钟之内**

## 变量是什么？

#### 引子 （10分钟）

计算机的主要作用之一是进行运算，用python进行数值运算非常容易，跟我们平常用计算器一样简单:

```plain
>>> 4*3/2 - 1
5.0
```

那现在有一个需求，咱们同学A花钱如流水，为了帮助他理财，我们决定为他出个月底消费报表，报表中有2个重要数据,当月总花费和分类汇总费用，即总共花了多少钱吃饭、买衣服等。

<!-- OCR_START -->
- 1
- 吃饭
- 买衣服
- 交通
- 精神消费
- 2
- 1月1日
- 10
- 20
- 6
- 300
- 3
- 1月2日
- 15
- 4
- 1月3日
- 7
- 12
- 1月11日
- 13
- 1月12日
- 14
- 1月13日
- 1月14日
- 26
- 1月25日
- 27
- 1月26日
- 28
- 1月27日
- 400
- 29
- 1月28日
- 30
- 1月29日
- 5
- 31
- 1月30日
- 32
- 1月31日
- 200
- 33
- Total
- 265
- 186
- 1200
- 34
<!-- OCR_END -->

现在要求你用程序 把 每个消费分类统计 和总消费依次计算并打印出来，你怎么做呢？如果不用计算机，让你用笔算，你会不会跟下面一样算呢？

<!-- OCR_START -->
- DATE
- Dh05=10+15+7+7+4+7
- 265
- 买服二20二20
- 交通
- 二6+6+6.--+6=186
- 总消发二265+20+186+1200=167
<!-- OCR_END -->

你发现没有？你在最后在算总消费的时候直接用的是之前已经算好的中间结果，为什么这么做？都知道这样是为了避免重新再算一遍所有的数据。 那在程序中呢？

```plain
>>> print('eat',10+15+7+4+7+3)
eat 46
>>> print('cloth',20)
cloth 20
>>> print('traffic',6+6+6+6+6)
traffic 30
>>> print('精神',300+300+400+200)
精神 1200
>>> 
>>> 
>>> print('总消费', 46+20+30+1200)
总消费 1296
```

我的亲， 你这么写是有问题的，啥问题？你最后算总消费的时候 是人肉 把之前算出来的分类结果 填进去的， 但是我们把程序写在脚本里运行时， 你肯定不会预先知道吃饭、交通、买衣服3个分类的结果的，这个结果是动态算出来的，那你如何把这3个动态结果做为总消费运算的数据源呢？答案简单， 直接把每个分类结果先起个名字存下来，然后计算总消费的时候，只需要把之前存下来的几个名字调用 一下就可以啦！

```plain
>>> eat = 10+15+7+4+7+3
>>> cloth = 20
>>> traffic = 6+6+6+6+6
>>> 精神=300+300+200+400
>>> 
>>> total = eat + cloth + traffic + 精神
>>> print('总消息',total)
总消息 1296
```

eat,cloth,traffic,精神,total这几个名字的作用，就是**把程序运算的中间结果临时存到内存里，以备后面的代码继续调用，这几个名字的学名就叫做"变量"**

#### 变量的作用 （3分钟）

**Variables **are used to** store information to be referenced and manipulated in a computer program**. They also provide a way of \*\*labeling data with a descriptive name, \*\*so our programs can be understood more clearly by the reader and ourselves. **It is helpful to think of variables as containers that hold information**. Their sole purpose is to label and store data in memory. This data can then be used throughout your program.

## 变量定义规范 (8-10分钟)

#### **声明变量**

```plain
name = "Alex Li"
```

#### 

<!-- OCR_START -->
- name="AlexLi"
- 变量名
- 变量值
- （标识符）
<!-- OCR_END -->

#### **变量定义规则**

1. 变量名只能是 字母、数字或下划线的任意组合
2. 变量名的第一个字符不能是数字
3. 以下关键字不能声明为变量名\['and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'exec', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'not', 'or', 'pass', 'print', 'raise', 'return', 'try', 'while', 'with', 'yield']

#### **定义方式**

驼峰体

```plain
AgeOfOldboy = 56 
NumberOfStudents = 80
```

下划线

```plain
age_of_oldboy = 56 
number_of_students = 80
```

> 你觉得哪种更清晰，哪种就是官方推荐的，我想你肯定会先第2种,第一种AgeOfOldboy咋一看以为是AngelaBaby

#### 变量的修改

。。。。

#### **定义变量不好的方式举例**

* 变量名为中文、拼音
* 变量名过长
* 变量名词不达意

## 常量(2-4分钟)

常量即指不变的量，如pai 3.141592653..., 或在程序运行过程中不会改变的量

举例，假如老男孩老师的年龄会变，那这就是个变量，但在一些情况下，他的年龄不会变了，那就是常量。在Python中没有一个专门的语法代表常量，程序员约定俗成用变量名全部大写代表常量

```plain
AGE_OF_OLDBOY = 56
```

> 在c语言中有专门的常量定义语法，`const int count = 60;`一旦定义为常量，更改即会报错

# 1.6 程序交互

## 本节重点：

* 使学生掌握如何让程序读取用户输入

> **本节时长需控制在15分钟之内**

## 读取用户输入(5-8分钟)

```plain
name = input("What is your name?")
print("Hello " + name )
```

执行脚本就会发现，程序会等待你输入姓名后再往下继续走。

可以让用户输入多个信息，如下

```plain
name = input("What is your name?")
age = input("How old are you?")
hometown = input("Where is your hometown?")
print("Hello ",name , "your are ", age , "years old, you came from",hometown)
```

执行输出

```plain
What is your name?Alex Li
How old are you?22
Where is your hometown?ShanDong
Hello  Alex Li your are  22 years old, you came from ShanDong
```

> 为避免学生蒙逼，py2.7 的raw_input 以后再补充

## 注释(5-8分钟)

随着学习的深入，用不了多久，你就可以写复杂的上千甚至上万行的代码啦，有些代码你花了很久写出来，过了些天再回去看，发现竟然看不懂了，哈哈，这太正常了。 另外，你以后在工作中会发现，一个项目多是由几个甚至几十个开发人员一起做，你要调用别人写的代码，别人也要用你的，如果代码不加注释，你自己都看不懂，更别说别人了，这样写会挨打的。所以为了避免这种尴尬的事情发生，一定要增加你代码的可读性。

代码注释分单行和多行注释， 单行注释用`#`，多行注释可以用三对双引号`""" """`

下面给大家看一段标准代码的注释，忽略代码意思

```plain
def subclass_exception(name, parents, module, attached_to=None):
    """
    Create exception subclass. Used by ModelBase below.
    If 'attached_to' is supplied, the exception will be created in a way that
    allows it to be pickled, assuming the returned exception class will be added
    as an attribute to the 'attached_to' class.
    """
    class_dict = {'__module__': module}
    if attached_to is not None:
        def __reduce__(self):
            # Exceptions are special - they've got state that isn't
            # in self.__dict__. We assume it is all in self.args.
            return (unpickle_inner_exception, (attached_to, name), self.args)
        def __setstate__(self, args):
            self.args = args
        class_dict['__reduce__'] = __reduce__
        class_dict['__setstate__'] = __setstate__
    return type(name, parents, class_dict)
```

**代码注释原则:**

1. 不用全部加注释，只需要在自己觉得重要或不好理解的部分加注释即可
2. 注释可以用中文或英文，但绝对不要拼音噢

# 1.7 基本数据类型

## 本节重点：

* 使学生掌握字符串、数字、布尔这三种基本数据类型，这样讲后面的流程控制和逻辑判断时会容易接受

> **本节时长需控制在15-20分钟之内**
>
> 此处暂不讲list , dict等数据类型，不要一开始给学生太多太碎的知识点

## 什么是数据类型？

我们人类可以很容易的分清数字与字符的区别，但是计算机并不能呀，计算机虽然很强大，但从某种角度上看又很傻，除非你明确的告诉它，1是数字，"汉"是文字，否则它是分不清1和'汉'的区别的，因此，在每个编程语言里都会有一个叫数据类型的东东，其实就是对常用的各种数据类型进行了明确的划分，你想让计算机进行数值运算，你就传数字给它，你想让他处理文字，就传字符串类型给他。Python中常用的数据类型有多种，今天我们暂只讲3种， 数字、字符串、布尔类型

## 数字(3-5分钟)

**int（整型）**

在32位机器上，整数的位数为32位，取值范围为-2**31～2**31-1，即-2147483648～2147483647

在64位系统上，整数的位数为64位，取值范围为-2**63～2**63-1，即-9223372036854775808～9223372036854775807

**long（长整型）**

跟C语言不同，Python的长整数没有指定位宽，即：Python没有限制长整数数值的大小，但实际上由于机器内存有限，我们使用的长整数数值不可能无限大。

注意，自从Python2.2起，如果整数发生溢出，Python会自动将整数数据转换为长整数，所以如今在长整数数据后面不加字母L也不会导致严重后果了。

> 注意：在Python3里不再有long类型了，全都是int

```plain
>>> a= 2**64
>>> type(a)  #type()是查看数据类型的方法
<type 'long'>
>>> b = 2**60
>>> type(b)
<type 'int'>
```

> 除了int和long之外， 其实还有float浮点型, 复数型，但今天先不讲啦

## 字符串(5-8分钟)

**在Python中,加了引号的字符都被认为是字符串！**

```plain
>>> name = "Alex Li" #双引号
>>> age = "22"       #只要加引号就是字符串
>>> age2 = 22          #int
>>> 
>>> msg = '''My name is Alex, I am 22 years old!'''  #我擦，3个引号也可以
>>> 
>>> hometown = 'ShanDong'   #单引号也可以
```

那单引号、双引号、多引号有什么区别呢？ 让我大声告诉你，单双引号木有任何区别，只有下面这种情况 你需要考虑单双的配合

```plain
msg = "My name is Alex , I'm 22 years old!"
```

多引号什么作用呢？作用就是多行字符串必须用多引号

```plain
msg = '''
今天我想写首小诗，
歌颂我的同桌，
你看他那乌黑的短发，
好像一只炸毛鸡。
'''
print(msg)
```

**字符串拼接**

数字可以进行加减乘除等运算，字符串呢？让我大声告诉你，也能？what ?是的，但只能进行"相加"和"相乘"运算。

```plain
>>> name
'Alex Li'
>>> age
'22'
>>> 
>>> name + age  #相加其实就是简单拼接
'Alex Li22'
>>> 
>>> name * 10 #相乘其实就是复制自己多少次，再拼接在一起
'Alex LiAlex LiAlex LiAlex LiAlex LiAlex LiAlex LiAlex LiAlex LiAlex Li'
```

注意，字符串的拼接只能是双方都是字符串，不能跟数字或其它类型拼接

```plain
>>> type(name),type(age2)
(<type 'str'>, <type 'int'>)
>>> 
>>> name
'Alex Li'
>>> age2
22
>>> name + age2
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: cannot concatenate 'str' and 'int' objects #错误提示数字 和 字符 不能拼接
```

## 布尔型(bool) (5分钟)

布尔类型很简单，就两个值 ，一个True(真)，一个False(假), 主要用记逻辑判断

但其实你们并不明白对么？ let me explain, 我现在有2个值 ， a=3, b=5 , 我说a>b你说成立么? 我们当然知道不成立，但问题是计算机怎么去描述这成不成立呢？或者说a< b是成立，计算机怎么描述这是成立呢？

没错，答案就是，用布尔类型

```plain
>>> a=3
>>> b=5
>>> 
>>> a > b #不成立就是False,即假
False
>>> 
>>> a < b #成立就是True, 即真
True
```

计算机为什么要描述这种条件呢？因为接下来就可以根据条件结果来干不同的事情啦呀！比如

```plain
if a > b 
   print(a is bigger than b )
else 
   print(a is smaller than b )
```

上面是伪代码，但是不是意味着， 计算机就可以根据判断结果不同，来执行不同的动作啦？

### 列表类型(10分)

只讲基本定义、列表嵌套、取值

### 字典类型(10分)

只讲基本定义、取值

> 除了上面讲过的3种数据类型之外， 后面我们还会讲到如列表 、字典、集合等，越往后面学就越发现计算机好nb呀!

# 1.8 格式化输出

## 本节重点：

* 使学生掌握字符串格式的方法

> **本节时长需控制在10分钟之内**

## 格式化输出(10分钟)

现有一练习需求，问用户的姓名、年龄、工作、爱好 ，然后打印成以下格式

```plain
------------ info of Alex Li -----------
Name  : Alex Li
Age   : 22
job   : Teacher
Hobbie: girl
------------- end -----------------
```

你怎么实现呢？你会发现，用字符拼接的方式还难实现这种格式的输出，所以一起来学一下新姿势

只需要把要打印的格式先准备好， 由于里面的 一些信息是需要用户输入的，你没办法预设知道，因此可以先放置个占位符，再把字符串里的占位符与外部的变量做个映射关系就好啦

```plain
name = input("Name:")
age = input("Age:")
job = input("Job:")
hobbie = input("Hobbie:")
info = '''
------------ info of %s ----------- #这里的每个%s就是一个占位符，本行的代表 后面拓号里的 name 
Name  : %s  #代表 name 
Age   : %s  #代表 age  
job   : %s  #代表 job 
Hobbie: %s  #代表 hobbie 
------------- end -----------------
''' %(name,name,age,job,hobbie)  # 这行的 % 号就是 把前面的字符串 与拓号 后面的 变量 关联起来 
print(info)
```

%s就是代表字符串占位符，除此之外，还有%d,是数字占位符， 如果把上面的age后面的换成%d，就代表你必须只能输入数字啦

```plain
age     : %d
```

我们运行一下，但是发现出错了。。。

<!-- OCR_START -->
```text
inputtest
/usr/local/bin/python3.5"/Users/alex/Documents/work/PyProjects/python基础/outline大纲/chapter1/inputtest.py
Name:Alex
Age:22
Job:IT
Hobbie:girl
Traceback（mostrecentcalllast):
File"/Users/alex/Documents/work/PyProjects/python基础/outline大纲/chapter1/inputtest.py"，line34，in<module>
TypeError:%dformat:anumberisrequired,notstr
Process finishedwithexitcode1
2
```
<!-- OCR_END -->

说%d需要一个数字，而不是str, what? 我们明明输入的是数字呀，22，22呀。

不用担心 ，不要相信你的眼睛我，们调试一下，看看输入的到底是不是数字呢？怎么看呢？查看数据类型的方法是什么来着？type()

```plain
name = input("Name:")
age = input("Age:")
print(type(age))
```

执行输出是

```plain
Name:Alex
Age:22
<class 'str'> #怎么会是str
Job:IT
....
```

让我大声告诉你，**input接收的所有输入默认都是字符串格式！**

要想程序不出错，那怎么办呢？简单，你可以把str转成int

```plain
age = int(  input("Age:")  )
print(type(age))
```

肯定没问题了。相反，能不能把数字转成字符串呢？必然可以，`str( yourStr )`

# 1.9 基本运算符

## 本节重点：

* 使学生掌握基本的几种运算符，便于其更容易理解后面的流程控制部分的知识

> **本节时长需控制在15分钟之内**

## 运算符

计算机可以进行的运算有很多种，可不只加减乘除这么简单，运算按种类可分为算数运算、比较运算、逻辑运算、赋值运算、成员运算、身份运算、位运算，今天我们暂只学习算数运算、比较运算、逻辑运算、赋值运算

#### 算数运算

以下假设变量：**a=10，b=20**

#### 比较运算

以下假设变量：**a=10，b=20**

#### 赋值运算

以下假设变量：**a=10，b=20**

<!-- OCR_START -->
- 运算符
- 描述
- 实例
- 简单的赋值运算符
- c = a +b 将 a+b 的运算结果赋值为 c
- +=
- 加法赋值运算符
- c += ａ 等效于 c= c+ a
- 减法赋值运算符
- c-=a等效于c=c-a
- -=
- *=
- 乘法赋值运算符
- /=
- 除法赋值运算符
- %=
- 取模赋值运算符
- **二
- 幂赋值运算符
- //=
- 取整除赋值运算符
<!-- OCR_END -->

#### 逻辑运算

<!-- OCR_START -->
运算符
描述
实例
and
布尔"与"－如果x为False，×andy返回False，否则它返回y的计算值。
(aandb)返回true。
or
布尔"或"-如果x是True，它返回True，否则它返回y的计算值。
(aorb)返回true。
not
布尔"非"－如果x为True，返回False。如果x为False，它返回True。
not(aandb)返回false。
<!-- OCR_END -->

# 1.10 流程控制之 if --else

## 本节重点：

* 使学生理解和掌握基本流程控制if ... else
* 掌握缩进的重要性
* 使学生掌握多条件语句if ..elif ...

> **本节时长需控制在30分钟之内**

## 流程控制

假如把写程序比做走路，那我们到现在为止，一直走的都是直路，还没遇到过分叉口，想象现实中，你遇到了分叉口，然后你决定往哪拐必然是有所动机的。你要判断那条岔路是你真正要走的路，如果我们想让程序也能处理这样的判断怎么办？ 很简单，只需要在程序里预设一些条件判断语句，满足哪个条件，就走哪条岔路。这个过程就叫流程控制。

#### if...else 语句

**单分支 (3-5分钟)**

```plain
if 条件:
    满足条件后要执行的代码
```

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 名称 | 排名 | 名称 |
| --- | --- | --- | --- | --- | --- |
| ifelse.pyx | ifAge0foldboy | 1 | #*coding:utf-8* | 2 | 3 |
| 顿号：是语法格式 | 4 | Age0f0ldboy= 56 | 5 | 6 | if Age0foldboy >5 |
| 50： | print("Tooold,time toretire.. | 4个空格 | if条件成立后要执行的代码 | ifelse | /usr/local/bin/python3.5/Users/alex/Documents/work/PyProjects/python基础/outline大纲/chapter1/if |
<!-- OCR_END -->

**双分支(3分钟)**

```plain
if 条件:
    满足条件执行代码
else:
    if条件不满足就走这段
```

```plain
AgeOfOldboy = 48
if AgeOfOldboy > 50 :
    print("Too old, time to retire..")
else:
    print("还能折腾几年!")
```

**缩进(5分钟)**

> 这里必须要插入这个缩进的知识点

你会发现，上面的if代码里，每个条件的下一行都缩进了4个空格，这是为什么呢？这就是Python的一大特色，强制缩进，目的是为了让程序知道，每段代码依赖哪个条件，如果不通过缩进来区分，程序怎么会知道，当你的条件成立后，去执行哪些代码呢？

在其它的语言里，大多通过`{}`来确定代码块，比如C,C++,Java,Javascript都是这样，看一个JavaScript代码的例子

```plain
var age = 56
if ( age < 50){
  console.log("还能折腾")
    console.log('可以执行多行代码')
}else{
   console.log('太老了')
}
```

在有`{}`来区分代码块的情况下，缩进的作用就只剩下让代码变的整洁了。

Python是门超级简洁的语言，发明者定是觉得用`{}`太丑了，所以索性直接不用它，那怎么能区分代码块呢？答案就是强制缩进。

Python的缩进有以下几个原则:

* 顶级代码必须顶行写，即如果一行代码本身不依赖于任何条件，那它必须不能进行任何缩进
* 同一级别的代码，缩进必须一致
* 官方建议缩进用4个空格，当然你也可以用2个，如果你想被人笑话的话。

**多分支(15-20分钟)**

回到流程控制上来，if...else ...可以有多个分支条件

```plain
if 条件:
    满足条件执行代码
elif 条件:
    上面的条件不满足就走这个
elif 条件:
    上面的条件不满足就走这个
elif 条件:
    上面的条件不满足就走这个    
else:
    上面所有的条件不满足就走这段
```

写个猜年龄的游戏吧

```plain
age_of_oldboy = 48
guess = int(input(">>:"))
if guess > age_of_oldboy :
    print("猜的太大了，往小里试试...")
elif guess < age_of_oldboy :
    print("猜的太小了，往大里试试...")
else:
    print("恭喜你，猜对了...")
```

上面的例子，根据你输入的值不同，会最多得到3种不同的结果

> 此时让学生自己也默写一遍这段代码

再来个匹配成绩的小程序吧，成绩有ABCDE5个等级，与分数的对应关系如下

```plain
A    90-100
B    80-89
C    60-79
D    40-59
E    0-39
```

要求用户输入0-100的数字后，你能正确打印他的对应成绩

```plain
score = int(input("输入分数:"))
if score > 100:
    print("我擦，最高分才100...")
elif score >= 90:
    print("A")
elif score >= 80:
    print("B")
elif score >= 60:
    print("C")
elif score >= 40:
    print("D")
else:
    print("太笨了...E")
```

这里有个问题，就是当我输入95的时候 ，它打印的结果是A,但是95 明明也大于第二个条件`elif score >=80:`呀, 为什么不打印B呢？这是因为代码是从上到下依次判断，只要满足一个，就不会再往下走啦，这一点一定要清楚呀！

> 你有没有发现一个问题，我上在的程序都只能执行一次，猜年龄只能一次好无聊呀，能不能多让我试几次呢，说不定就猜中了呢，毕竟老男孩老师的年龄很快就成为常量啦。。。哈哈哈， 必然可以，继续往下学吧！加油！

# 1.11 流程控制之 循环

## 本节重点：

* 使学生理解和掌握while循环的使用
* 掌握break continue 控制语句
* 能独自己写出后面的2个小练习

> **本节时长需控制在45分钟之内**

## While 循环(3分钟)

上节课我们已经学会用if .. else 来猜年龄的游戏啦，但是只能猜一次就中的机率太小了，如果我想给玩家3次机会呢？就是程序启动后，玩家最多可以试3次，这个怎么弄呢？你总不会想着把代码复制3次吧。。。。

```plain
age_of_oldboy = 48
guess = int(input(">>:"))
if guess > age_of_oldboy :
    print("猜的太大了，往小里试试...")
elif guess < age_of_oldboy :
    print("猜的太小了，往大里试试...")
else:
    print("恭喜你，猜对了...")
#第2次
guess = int(input(">>:"))
if guess > age_of_oldboy :
    print("猜的太大了，往小里试试...")
elif guess < age_of_oldboy :
    print("猜的太小了，往大里试试...")
else:
    print("恭喜你，猜对了...")
#第3次
guess = int(input(">>:"))
if guess > age_of_oldboy :
    print("猜的太大了，往小里试试...")
elif guess < age_of_oldboy :
    print("猜的太小了，往大里试试...")
else:
    print("恭喜你，猜对了...")
```

即使是小白的你，也觉得的太low了是不是，以后要修改功能还得修改3次，因此记住，写重复的代码是程序员最不耻的行为。

那么如何做到不用写重复代码又能让程序重复一段代码多次呢？ 循环语句就派上用场啦

#### 语法(10-15分钟)

```plain
while  条件:
    执行代码...
```

简单吧, `while` 就是当的意思，当山峰没有棱角的时候，当河水。。。，sorry , `while` 指 当其后面的条件 成立 ，就执行`while`下面的代码

写个让程序从0打印到100的程序 ，每循环一次，+1

```plain
count = 0 
while count <= 100 : #只要count<=100就不断执行下面的代码
   print("loop ", count )
   count +=1  #每执行一次，就把count+1，要不然就变成死循环啦，因为count一直是0
```

输出

```plain
loop  0
loop  1
loop  2
loop  3
....
loop  98
loop  99
loop  100
```

如果我想实现打印1到100的偶数怎么办呢？

那就得先搞清，怎么判断一个数字是偶数，能被2整除的就是偶数对不对, 怎么判断能否被2整除？简单，除完2没有余数就是啦。记得我们学的取模算运算符么？

```plain
>>> 10%2
0
>>> 8%2  #无余数，是偶数
0
>>> 7%2  #有余数，是奇数
1
```

放到我们的循环程序里

```plain
count = 0
while count <= 100 : #只要count<=100就不断执行下面的代码
    if count % 2 == 0: #是偶数
        print("loop ", count)
    count +=1 #每执行一次，就把count+1，要不然就变成死循环啦，因为count一直是0
```

输出

```plain
loop  0
loop  2
loop  4
loop  6
....
loop  96
loop  98
loop  100
```

> 此处一定要停下来，让学生自己默写一遍

#### 死循环 (3分钟)

**有一种循环叫死循环，一经触发，就运行个天荒地老、海枯石烂。**

while 是只要后边条件成立(也就是条件结果为真)就一直执行，怎么让条件一直成立呢？

```plain
count = 0
while True: #True本身就是真呀
    print("你是风儿我是沙,缠缠绵绵到天涯...",count)
    count +=1
```

## 循环中止语句 （8-10分钟）

如果在循环的过程中，因为某些原因，你不想继续循环了，怎么把它中止掉呢？这就用到break 或 continue 语句

* break用于完全结束一个循环，跳出循环体执行循环后面的语句
* continue和break有点类似，区别在于continue只是终止本次循环，接着还执行后面的循环，break则完全终止循环

**例子:break**

```plain
count = 0
while count <= 100 : #只要count<=100就不断执行下面的代码
    print("loop ", count)
    if count == 5:
        break
    count +=1 #每执行一次，就把count+1，要不然就变成死循环啦，因为count一直是0
print("-----out of while loop ------")
```

输出

```plain
loop  0
loop  1
loop  2
loop  3
loop  4
loop  5
-----out of while loop ------
```

**例子：continue**

```plain
count = 0
while count <= 100 : 
    count += 1
    if count > 5 and count < 95: #只要count在6-94之间，就不走下面的print语句，直接进入下一次loop
        continue 
    print("loop ", count)
print("-----out of while loop ------")
```

输出

```plain
loop  1
loop  2
loop  3
loop  4
loop  5
loop  95
loop  96
loop  97
loop  98
loop  99
loop  100
loop  101
-----out of while loop ------
```

## while ... else .. （3-5分钟）

与其它语言else 一般只与if 搭配不同，在Python 中还有个while ...else 语句

while 后面的else 作用是指，**当while 循环正常执行完，中间没有被break 中止的话，就会执行else后面的语句**

```plain
count = 0
while count <= 5 :
    count += 1
    print("Loop",count)
else:
    print("循环正常执行完啦")
print("-----out of while loop ------")
```

输出

```plain
Loop 1
Loop 2
Loop 3
Loop 4
Loop 5
Loop 6
循环正常执行完啦
-----out of while loop ------
```

如果执行过程中被break啦，就不会执行else的语句啦

```plain
count = 0
while count <= 5 :
    count += 1
    if count == 3:break
    print("Loop",count)
else:
    print("循环正常执行完啦")
print("-----out of while loop ------")
```

输出

```plain
Loop 1
Loop 2
-----out of while loop ------
```

## 小节练习

**练习1：猜年龄游戏 (10分钟)**

要求：

1. 允许用户最多尝试3次，3次都没猜对的话，就直接退出，如果猜对了，打印恭喜信息并退出

**练习2：猜年龄游戏升级版 (10分钟)**

要求：

1. 允许用户最多尝试3次
2. 每尝试3次后，如果还没猜对，就问用户是否还想继续玩，如果回答Y或y, 就继续让其猜3次，以此往复，如果回答N或n，就退出程序
3. 如何猜对了，就直接退出

# 1.12 开发工具IDE

## 本节重点：

* 使学生掌握Pycharm开发工具的使用
* 掌握代码调试功能

> **本节时长需控制在10分钟之内**

## 为什么要用IDE？

到现在为止，我们也是写过代码的人啦，但你有没有发现，每次写代码要新建文件、写完保存时还要选择存放地点，执行时还要切换到命令行调用python解释器，好麻烦呀，能否一气呵成，让我简单的写代码？此时开发工具IDE上场啦，一个好的IDE能帮你大大提升开发效率。

很多语言都有比较流行的开发工具，比如JAVA 的Eclipse, C#,C++的VisualStudio, Python的是啥呢？ Pycharm，最好的Python 开发IDE

**安装**

下载地址:<https://www.jetbrains.com/pycharm/download> 选择Professional 专业版

> Comunnity社区版是免费的，但支持的功能不多，比如以后我们会学的Django就不支持，所以还是用专业版，但专业版是收费的，一年一千多，不便宜。唉，万能的淘宝。。。不宜再多说啦。

注册完成后启动，会让你先创建一个项目，其实就是一个文件夹，我们以后的代码都存在这里面

<!-- OCR_START -->
- New Project
- PurePython
- Location:
- /Users/alex/PycharmProjects/py_learn
- dDjango
- Flask
- Interpreter:
- 3.5.2at/usr/local/bin/python3.5
- GoogleAppEngine
- ：Pyramid
- Web2Py
- AngularCLI
- 代表是PYTHON项目
- AAngularJS
- 项目名
- Foundation
- 5
- HTML5Boilerplate
- ReactApp
- 解释器
- ReactNative
- TwitterBootstrap
- >WebStarterKit
- Create
<!-- OCR_END -->

你以后写的项目可能有成百上千个代码文件 ，全放在一起可不好，所以一般把同样功能的代码放在一个目录，我们现在以天为单位，为每天的学习创建一个目录day1,day2,day3...这样
<!-- OCR_START -->
- py_learn
- Project
- IlliExternal Lib
- New
- File
- NewScratchFile
- %Cut
- 创建一个目录
- Directory
- Copy
- PythonPackage
- CopyPath
- 8C
<!-- OCR_END -->

创建代码文件 

<!-- OCR_START -->
- py_learn
- day1
- Project
- py_learn~/PycharmProjects/py_learn
- New
- File
- IlliExternalLibrarie
- NewScratch File
- %Cut
- Directory
- Copy
- 右单击day1目录
- 8C
- Python Package
- CopyPath
- CopyasPlainText
- PythonFile
- CopyRelativePath
- iPJupyterNotebook
- Paste
- 8V
- HTMLFile
<!-- OCR_END -->

执行代码

<!-- OCR_START -->
- hello
- py_learn dayhello.py
- Project
- hello.py
- 文件名
- py_learn~/PycharmProjects/py_learn
- day1
- Ill ExternalLibraries
- #_*_coding:utf-8_*
- 2
- 3
- count=0
- 4
- whilecount<=100：#只要count<=l00就不断执行下面的代码
- 5
- print("loop
- 6
- if count==
- 7
- break
- 8
- count +=1
- Copy Reference
- Paste
- 要不然就变成死循环啦，因为count一直是0
- 8V
- 9
- Paste from History...
- 10
- print("
- ou1
- Paste Simple
- Column Selection Mode
- 写完代码后，直接在编辑页右单击
- Refactor
- 点击Run'hello'就可以运行啦
- Folding
- GoTo
- Generate...
- Run'hello
- ^OR
- Debug'hello'
- /usr/local/bin/python3.5/Users/alex/f
- ycharmProjects/py_learn/day1/hello.p
- Run'hellowith Coverage
- loop
- Profile'hello
- 1
- ConcurrencyDiagramforhello'
- 运行结果
- Save'hello
- outofwhileloop
- Local History
- Process finished with exit code0
- Execute Linein Console
- TOE
- Comparewith Clipboard
- File Encoding
- Diagrams
- QEvent Log
<!-- OCR_END -->

#### 代码调试

想不想看代码一步步的执行过程？比如想看每次循环某个变量有没有变化，总是print太low了，试试pycharm 牛逼的debug功能吧

<!-- OCR_START -->
- hello.py-py_learn-[~/PycharmProjects/py_learn]
- hello
- pylearnday1
- hello.py
- Project
- hello.pyx
- py_learn~/PycharmProjects/py_learn
- while
- count
- Data
- Dday1
- Ill External Libraries
- 1
- #*_coding:utf-8*
- 此时count变量在内存中的值会动态在这显示
- 3
- =0
- 想对哪些行进行调试，就双击红点位置
- 4
- whilecount<=100：#只要count<=100就不断执行下面的代码
- 会出现红点
- 5
- print("loop
- 6
- ifcount==5:
- 7
- break
- 8
- count+=1 #每执行一次，就把count+l，要不然就变成死循环啦，因为count一直是0
- 9
- 10
- print("
- -outofwhileloop
- 蓝色背景行是代表当前走到哪步了
- 每次点击一下，程序就会走一步
- Deb
- →Variables
- count={int}2
- 当前程序中所有变量的动态值
- QEvent Log
- 3:1LF
- UTF-8
<!-- OCR_END -->

# 1.13 本章小结

## 本章总节

#### 练习题:

1. 简述编译型与解释型语言的区别，且分别列出你知道的哪些语言属于编译型，哪些属于解释型
2. 执行 Python 脚本的两种方式是什么
3. Pyhton 单行注释和多行注释分别用什么?
4. 布尔值分别有什么?
5. 声明变量注意事项有那些?
6. 如何查看变量在内存中的地址?
7. 写代码
   1. 实现用户输入用户名和密码,当用户名为 seven 且 密码为 123 时,显示登陆成功,否则登陆失败!
   2. 实现用户输入用户名和密码,当用户名为 seven 且 密码为 123 时,显示登陆成功,否则登陆失败,失败时允许重复输入三次
   3. 实现用户输入用户名和密码,当用户名为 seven 或 alex 且 密码为 123 时,显示登陆成功,否则登陆失败,失败时允许重复输入三次
8. 写代码\
   a. 使用while循环实现输出2-3+4-5+6...+100 的和\
   b. 使用 while 循环实现输出 1,2,3,4,5, 7,8,9, 11,12\
   c. 使用while 循环输出100-50，从大到小，如100，99，98...，到50时再从0循环输出到50，然后结束\
   d. 使用 while 循环实现输出 1-100 内的所有奇数\
   e. 使用 while 循环实现输出 1-100 内的所有偶数
9. 现有如下两个变量,请简述 n1 和 n2 是什么关系?

```plain
n1 = 123456
n2 = n1
```

1. 制作趣味模板程序（编程题）\
   需求：等待用户输入名字、地点、爱好，根据用户的名字和爱好进行任意显示\
   如：敬爱可爱的xxx，最喜欢在xxx地方干xxx
2. 输入一年份，判断该年份是否是闰年并输出结果。（编程题）\
   注：凡符合下面两个条件之一的年份是闰年。 （1） 能被4整除但不能被100整除。 （2） 能被400整除。
3. 假设一年期定期利率为3.25%，计算一下需要过多少年，一万元的一年定期存款连本带息能翻番？（编程题）
4. 使用while,完成以下图形的输出

```plain
*
* *
* * *
* * * *
* * * * *
* * * *
* * *
* *
*
```

1. 路飞决定根据销售额给员工发提成，提成为阶梯制，假设一个销售人员基本工资为3000元， 每月业绩低于5万元，无提成，5万至10万，提成3%，10万至15万提成5%，15万-25万提成8%，25万至35万提成10%，35万以上，提成15%。 从键盘获取用户当月业绩，计算其工资+提成的总额。
2. 北京地铁交通价格调整为：6公里(含)内3元;6公里至12公里(含)4元;12公里至22公里(含)5元;22公里至32公里(含)6元;32公里以上部分， 每增加1元可乘坐20公里。使用市政交通一卡通刷卡乘坐轨道交通，每自然月内每张卡支出累计满100元以后的乘次价格给予8折优惠;满150元以后的乘次给予5折优惠，假设每个月，小明都需要上20天班，每次上班需要来回1次，即每天需要乘坐2次同样路线的地铁,编写程序，从键盘获取距离，帮小明计算每月的总花费。
3. 一球从100米高度自由落下，每次落地后反跳回原高度的一半；再落下，求它在第10次落地时，共经过多少米？第10次反弹多高？

#### 作业

**编写登陆接口**

基础需求：

* 让用户输入用户名密码
* 认证成功后显示欢迎信息
* 输错三次后退出程序

升级需求：

* 可以支持多个用户登录 (提示，通过列表存多个账户信息)
* 用户3次认证失败后，退出程序，再次启动程序尝试登录时，还是锁定状态（提示:需把用户锁定的状态存到文件里）

## 练习答案

1. 简述编译型与解释型语言的区别，且分别列出你知道的哪些语言属于编译型，哪些属于解释型.

```plain
答:
   编译型语言：
     使用专门的编译器，针对特定的平台，将高级语言源代码一次性的编译成可被该平台硬件执行的机器码，并包装成该平台所能识别的可执行性程序的格式。
   特点：
     在编译型语言写的程序执行之前，需要一个专门的编译过程，把源代码编译成机器语言的文件.
   执行方式:
     源代码 ———> 编译(一次编译) ———>目标代码———>执行(多次执行)———>输出
  解释型语言：
     使用专门的解释器对源程序逐行解释成特定平台的机器码并立即执行。
  特点：
     解释型语言不需要事先编译，其直接将源代码解释成机器码并立即执行，所以只要某一平台提供了相应的解释器即可运行该程序。
  执行方式:
    源代码 ———> 解释器(每次执行都需要解释)———>输出    
  编译型: C c++, c#
  解释型: python PHP ruby, java
```

1. 执行 Python 脚本的两种方式是什么

```plain
答:
  1、./run.py.shell直接调用python脚本  
 2、python run.py 调用python 解释器来调用python脚本
```

1. Pyhton 单行注释和多行注释分别用什么?

```plain
答:
  1, 单行注释使用 # 号
  2, 多行注释使用 """"""  ''''''
```

1. 布尔值分别有什么?

```plain
答:
 布尔值分别有：True 和False
  布尔值为False的有：[] () {} 0 False ""  等
```

1. 声明变量注意事项有那些?

```plain
答案：
     模块名，包名 ：小写字母， 单词之间用户_分割。
     类名：首字母大写。
     全局变量： 大写字母， 单词之间用户_分割。
     普通变量： 小写字母， 单词之间用户_分割。
     函数： 小写字母， 单词之间用户_分割。
     实例变量： 以_开头，其他和普通变量一样 。
     私有实例变量（外部访问会报错）： 以__开头（2个下划线），其他和普通变量一样 。
     专有变量： __开头，__结尾，一般为python的自有变量（不要以这种变量命名）。
```

1. 如何查看变量在内存中的地址?

```plain
id
```

1. 写代码
   1. 实现用户输入用户名和密码,当用户名为 seven 且 密码为 123 时,显示登陆成功,否则登陆失败!
   2. 实现用户输入用户名和密码,当用户名为 seven 且 密码为 123 时,显示登陆成功,否则登陆失败,失败时允许重复输入三次
   3. 实现用户输入用户名和密码,当用户名为 seven 或 alex 且 密码为 123 时,显示登陆成功,否则登陆失败,失败时允许重复输入三次

```plain
username = ['seven','Alex']
password = '123'
count = 0
while count < 3:
 username = input('用户名：')
 password = input('密码：')
 if username in username and password == password:
     print('登陆成功!')
     break
 else:
     print('登陆失败！')
 count += 1
```

1. 写代码

a. 使用while循环实现输出2-3+4-5+6...+100 的和

```plain
```

答:
i = 2
count = 0
while i <= 100:
if i % 2 == 0:
count += i
else:
count -= i
i += 1
print(count)

```
```

b. 使用 while 循环实现输出 1,2,3,4,5, 7,8,9, 11,12

```plain
```

答:
n1 = True
n2 = 1
while n1:
if n2 == 12:
print(n2)
break
if n2 == 6 or n2 == 10:
n2 += 1
continue
print(n2)
n2 += 1

```
```

c. 使用while 循环输出100-50，从大到小，如100，99，98...，到50时再从0循环输出到50，然后结束

```plain
```

count =100
while count > 50:
print(count)
count -=1
if count==50:
count=1
while count<=50:
print(count)
count+=1
break

```
```

d. 使用 while 循环实现输出 1-100 内的所有奇数

```plain
```

count =0
while count <=100:
if count %2!=0:
print(count)
count +=1

```
```

e. 使用 while 循环实现输出 1-100 内的所有偶数

```plain
```

count =0
while count <=100:
if count %2==0:
print(count)
count +=1

```
```

1. 现有如下两个变量,请简述 n1 和 n2 是什么关系?

```plain
n1 = 123456
 n2 = n1
```

1. 制作趣味模板程序（编程题）\
   需求：等待用户输入名字、地点、爱好，根据用户的名字和爱好进行任意显示 如：敬爱可爱的xxx，最喜欢在xxx地方干xxx

```plain
答案：
     name = input("请输入姓名：")
     address = input("请输入地点：")
     hobby = input("请输入爱好：")
     print("敬爱可爱的 %s, 最喜欢在%s地方干%s" % (name, address, hobby))
```

1. 输入一年份，判断该年份是否是闰年并输出结果。（编程题）\
   注：凡符合下面两个条件之一的年份是闰年。 （1） 能被4整除但不能被100整除。 （2） 能被400整除。

```plain
答案：
 def get_year():
     year = int(input("请输入年份："))
     if year % 4 == 0 and year % 100 != 0 or year % 400 == 0:
         print("%s 年是闰年" % year)
     else:
         print("%s 年不是闰年" % year)
 get_year()
```

1. 假设一年期定期利率为3.25%，计算一下需要过多少年，一万元的一年定期存款连本带息能翻番？（编程题）

```plain
money = 10000
     rate = 0.0325
     years = 0
     while money <= 20000:
         years += 1
         money  = money*(1+rate)
     print(str(years))
```

1. 一球从100米高度自由落下，每次落地后反跳回原高度的一半；再落下，求它在第10次落地时，共经过多少米？第10次反弹多高？

```plain
count = 0
    height = 100
    meter = 0
    while count < 10:
        meter +=  height #下落
        height /= 2
        meter += height  #反弹
        count +=1
        print(meter,height)
```

# 1.14 python 开发规范指南

转载至 [Google 开源项目风格指南 (中文版)](http://zh-google-styleguide.readthedocs.io/en/latest/)

## 1.14.1 python 风格规范

#### 分号

```plain
不要在行尾加分号, 也不要用分号将两条命令放在同一行.
```

#### 行长度

```plain
每行不超过80个字符
```

例外:

1. 长的导入模块语句
2. 注释里的URL

不要使用反斜杠连接行.

Python会将 圆括号, 中括号和花括号中的行隐式的连接起来 , 你可以利用这个特点. 如果需要, 你可以在表达式外围增加一对额外的圆括号.

```plain
Yes: foo_bar(self, width, height, color='black', design=None, x='foo',
             emphasis=None, highlight=0)
     if (width == 0 and height == 0 and
         color == 'red' and emphasis == 'strong'):
```

如果一个文本字符串在一行放不下, 可以使用圆括号来实现隐式行连接:

```plain
x = ('This will build a very long long '
     'long long long long long long string')
```

在注释中，如果必要，将长的URL放在一行上。

```plain
Yes:  # See details at
      # http://www.example.com/us/developer/documentation/api/content/v2.0/csv_file_name_extension_full_specification.html
```

```plain
No:  # See details at
     # http://www.example.com/us/developer/documentation/api/content/\
     # v2.0/csv_file_name_extension_full_specification.html
```

注意上面例子中的元素缩进; 你可以在本文的 缩进 部分找到解释.

#### 括号

```plain
宁缺毋滥的使用括号
```

除非是用于实现行连接, 否则不要在返回语句或条件语句中使用括号. 不过在元组两边使用括号是可以的.

```plain
Yes: if foo:
         bar()
     while x:
         x = bar()
     if x and y:
         bar()
     if not x:
         bar()
     return foo
     for (x, y) in dict.items(): ...
```

```plain
No:  if (x):
         bar()
     if not(x):
         bar()
     return (foo)
```

#### 缩进

```plain
用4个空格来缩进代码
```

绝对不要用tab, 也不要tab和空格混用. 对于行连接的情况, 你应该要么垂直对齐换行的元素(见 行长度 部分的示例), 或者使用4空格的悬挂式缩进(这时第一行不应该有参数):

```plain
Yes:   # Aligned with opening delimiter
       foo = long_function_name(var_one, var_two,
                                var_three, var_four)
       # Aligned with opening delimiter in a dictionary
       foo = {
           long_dictionary_key: value1 +
                                value2,
           ...
       }
       # 4-space hanging indent; nothing on first line
       foo = long_function_name(
           var_one, var_two, var_three,
           var_four)
       # 4-space hanging indent in a dictionary
       foo = {
           long_dictionary_key:
               long_dictionary_value,
           ...
       }
```

```plain
No:    # Stuff on first line forbidden
      foo = long_function_name(var_one, var_two,
          var_three, var_four)
      # 2-space hanging indent forbidden
      foo = long_function_name(
        var_one, var_two, var_three,
        var_four)
      # No hanging indent in a dictionary
      foo = {
          long_dictionary_key:
              long_dictionary_value,
              ...
      }
```

#### 空行

```plain
顶级定义之间空两行, 方法定义之间空一行
```

顶级定义之间空两行, 比如函数或者类定义. 方法定义, 类定义与第一个方法之间, 都应该空一行. 函数或方法中, 某些地方要是你觉得合适, 就空一行.

#### 空格

```plain
按照标准的排版规范来使用标点两边的空格
```

括号内不要有空格.

```plain
Yes: spam(ham[1], {eggs: 2}, [])
```

```plain
No:  spam( ham[ 1 ], { eggs: 2 }, [ ] )
```

不要在逗号, 分号, 冒号前面加空格, 但应该在它们后面加(除了在行尾).

```plain
Yes: if x == 4:
         print x, y
     x, y = y, x
```

```plain
No:  if x == 4 :
         print x , y
     x , y = y , x
```

参数列表, 索引或切片的左括号前不应加空格.

```plain
Yes: spam(1)
```

```plain
no: spam (1)
```

```plain
Yes: dict['key'] = list[index]
```

```plain
No:  dict ['key'] = list [index]
```

在二元操作符两边都加上一个空格, 比如赋值(=), 比较(==, <, >, !=, <>, <=, >=, in, not in, is, is not), 布尔(and, or, not). 至于算术操作符两边的空格该如何使用, 需要你自己好好判断. 不过两侧务必要保持一致.

```plain
Yes: x == 1
```

```plain
No:  x<1
```

当'='用于指示关键字参数或默认参数值时, 不要在其两侧使用空格.

```plain
Yes: def complex(real, imag=0.0): return magic(r=real, i=imag)
```

```plain
No:  def complex(real, imag = 0.0): return magic(r = real, i = imag)
```

不要用空格来垂直对齐多行间的标记, 因为这会成为维护的负担(适用于:, #, =等):

```plain
Yes:
     foo = 1000  # comment
     long_name = 2  # comment that should not be aligned
     dictionary = {
         "foo": 1,
         "long_name": 2,
         }
```

```plain
No:
     foo       = 1000  # comment
     long_name = 2     # comment that should not be aligned
     dictionary = {
         "foo"      : 1,
         "long_name": 2,
         }
```

#### Shebang

```plain
大部分.py文件不必以#!作为文件的开始. 根据 PEP-394 , 程序的main文件应该以 #!/usr/bin/python2或者 #!/usr/bin/python3开始.
```

(译者注: 在计算机科学中, Shebang (也称为Hashbang)是一个由井号和叹号构成的字符串行(#!), 其出现在文本文件的第一行的前两个字符. 在文件中存在Shebang的情况下, 类Unix操作系统的程序载入器会分析Shebang后的内容, 将这些内容作为解释器指令, 并调用该指令, 并将载有Shebang的文件路径作为该解释器的参数. 例如, 以指令#!/bin/sh开头的文件在执行时会实际调用/bin/sh程序.)

\#!先用于帮助内核找到Python解释器, 但是在导入模块时, 将会被忽略. 因此只有被直接执行的文件中才有必要加入#!.

#### 注释

```plain
确保对模块, 函数, 方法和行内注释使用正确的风格
```

##### 文档字符串

Python有一种独一无二的的注释方式: 使用文档字符串. 文档字符串是包, 模块, 类或函数里的第一个语句. 这些字符串可以通过对象的**doc**成员被自动提取, 并且被pydoc所用. (你可以在你的模块上运行pydoc试一把, 看看它长什么样). 我们对文档字符串的惯例是使用三重双引号"""( PEP-257 ). 一个文档字符串应该这样组织: 首先是一行以句号, 问号或惊叹号结尾的概述(或者该文档字符串单纯只有一行). 接着是一个空行. 接着是文档字符串剩下的部分, 它应该与文档字符串的第一行的第一个引号对齐. 下面有更多文档字符串的格式化规范.

##### 模块

每个文件应该包含一个许可样板. 根据项目使用的许可(例如, Apache 2.0, BSD, LGPL, GPL), 选择合适的样板.

##### 函数和方法

下文所指的函数,包括函数, 方法, 以及生成器.

一个函数必须要有文档字符串, 除非它满足以下条件:

1. 外部不可见
2. 非常短小
3. 简单明了

文档字符串应该包含函数做什么, 以及输入和输出的详细描述. 通常, 不应该描述"怎么做", 除非是一些复杂的算法. 文档字符串应该提供足够的信息, 当别人编写代码调用该函数时, 他不需要看一行代码, 只要看文档字符串就可以了. 对于复杂的代码, 在代码旁边加注释会比使用文档字符串更有意义.

关于函数的几个方面应该在特定的小节中进行描述记录， 这几个方面如下文所述. 每节应该以一个标题行开始. 标题行以冒号结尾. 除标题行外, 节的其他内容应被缩进2个空格.

##### Args:

列出每个参数的名字, 并在名字后使用一个冒号和一个空格, 分隔对该参数的描述.如果描述太长超过了单行80字符,使用2或者4个空格的悬挂缩进(与文件其他部分保持一致). 描述应该包括所需的类型和含义. 如果一个函数接受_foo(可变长度参数列表)或者\_*bar (任意关键字参数), 应该详细列出*foo和\*\*bar.

##### Returns: (或者 Yields: 用于生成器)

描述返回值的类型和语义. 如果函数返回None, 这一部分可以省略.

##### Raises:

列出与接口有关的所有异常.

```plain
def fetch_bigtable_rows(big_table, keys, other_silly_variable=None):
    """Fetches rows from a Bigtable.
    Retrieves rows pertaining to the given keys from the Table instance
    represented by big_table.  Silly things may happen if
    other_silly_variable is not None.
    Args:
        big_table: An open Bigtable Table instance.
        keys: A sequence of strings representing the key of each table row
            to fetch.
        other_silly_variable: Another optional variable, that has a much
            longer name than the other args, and which does nothing.
    Returns:
        A dict mapping keys to the corresponding table row data
        fetched. Each row is represented as a tuple of strings. For
        example:
        {'Serak': ('Rigel VII', 'Preparer'),
         'Zim': ('Irk', 'Invader'),
         'Lrrr': ('Omicron Persei 8', 'Emperor')}
        If a key from the keys argument is missing from the dictionary,
        then that row was not found in the table.
    Raises:
        IOError: An error occurred accessing the bigtable.Table object.
    """
    pass
```

##### 类

类应该在其定义下有一个用于描述该类的文档字符串. 如果你的类有公共属性(Attributes), 那么文档中应该有一个属性(Attributes)段. 并且应该遵守和函数参数相同的格式.

```plain
class SampleClass(object):
    """Summary of class here.
    Longer class information....
    Longer class information....
    Attributes:
        likes_spam: A boolean indicating if we like SPAM or not.
        eggs: An integer count of the eggs we have laid.
    """
    def __init__(self, likes_spam=False):
        """Inits SampleClass with blah."""
        self.likes_spam = likes_spam
        self.eggs = 0
    def public_method(self):
        """Performs operation blah."""
```

##### 块注释和行注释

最需要写注释的是代码中那些技巧性的部分. 如果你在下次 代码审查 的时候必须解释一下, 那么你应该现在就给它写注释. 对于复杂的操作, 应该在其操作开始前写上若干行注释. 对于不是一目了然的代码, 应在其行尾添加注释.

```plain
# We use a weighted dictionary search to find out where i is in
# the array.  We extrapolate position based on the largest num
# in the array and the array size and then do binary search to
# get the exact number.
if i & (i-1) == 0:        # true iff i is a power of 2
```

为了提高可读性, 注释应该至少离开代码2个空格.

另一方面, 绝不要描述代码. 假设阅读代码的人比你更懂Python, 他只是不知道你的代码要做什么.

```plain
# BAD COMMENT: Now go through the b array and make sure whenever i occurs
# the next element is i+1
```

#### 类

```plain
如果一个类不继承自其它类, 就显式的从object继承. 嵌套类也一样.
```

```plain
Yes: class SampleClass(object):
         pass
     class OuterClass(object):
         class InnerClass(object):
             pass
     class ChildClass(ParentClass):
         """Explicitly inherits from another class already."""
```

```plain
No: class SampleClass:
        pass
    class OuterClass:
        class InnerClass:
            pass
```

继承自 `object` 是为了使属性(properties)正常工作, 并且这样可以保护你的代码, 使其不受 PEP-3000 的一个特殊的潜在不兼容性影响. 这样做也定义了一些特殊的方法, 这些方法实现了对象的默认语义, 包括 `__new__`, `__init__`, `__delattr__`, `__getattribute__`, `__setattr__`, `__hash__`, `__repr__`, and `__str__`.

#### 字符串

```plain
即使参数都是字符串, 使用%操作符或者格式化方法格式化字符串. 不过也不能一概而论, 你需要在+和%之间好好判定.
```

```plain
Yes: x = a + b
     x = '%s, %s!' % (imperative, expletive)
     x = '{}, {}!'.format(imperative, expletive)
     x = 'name: %s; score: %d' % (name, n)
     x = 'name: {}; score: {}'.format(name, n)
```

```plain
No: x = '%s%s' % (a, b)  # use + in this case
    x = '{}{}'.format(a, b)  # use + in this case
    x = imperative + ', ' + expletive + '!'
    x = 'name: ' + name + '; score: ' + str(n)
```

避免在循环中用+和+=操作符来累加字符串. 由于字符串是不可变的, 这样做会创建不必要的临时对象, 并且导致二次方而不是线性的运行时间. 作为替代方案, 你可以将每个子串加入列表, 然后在循环结束后用 `.join` 连接列表. (也可以将每个子串写入一个 `cStringIO.StringIO` 缓存中.)

```plain
Yes: items = ['<table>']
     for last_name, first_name in employee_list:
         items.append('<tr><td>%s, %s</td></tr>' % (last_name, first_name))
     items.append('</table>')
     employee_table = ''.join(items)
```

```plain
No: employee_table = '<table>'
    for last_name, first_name in employee_list:
        employee_table += '<tr><td>%s, %s</td></tr>' % (last_name, first_name)
    employee_table += '</table>'
```

在同一个文件中, 保持使用字符串引号的一致性. 使用单引号'或者双引号"之一用以引用字符串, 并在同一文件中沿用. 在字符串内可以使用另外一种引号, 以避免在字符串中使用. GPyLint已经加入了这一检查.

(译者注:GPyLint疑为笔误, 应为PyLint.)

```plain
Yes:
     Python('Why are you hiding your eyes?')
     Gollum("I'm scared of lint errors.")
     Narrator('"Good!" thought a happy Python reviewer.')
```

```plain
No:
     Python("Why are you hiding your eyes?")
     Gollum('The lint. It burns. It burns us.')
     Gollum("Always the great lint. Watching. Watching.")
```

为多行字符串使用三重双引号"""而非三重单引号'''. 当且仅当项目中使用单引号'来引用字符串时, 才可能会使用三重'''为非文档字符串的多行字符串来标识引用. 文档字符串必须使用三重双引号""". 不过要注意, 通常用隐式行连接更清晰, 因为多行字符串与程序其他部分的缩进方式不一致.

```plain
Yes:
    print ("This is much nicer.\n"
           "Do it this way.\n")
```

```plain
No:
      print """This is pretty ugly.
  Don't do this.
  """
```

#### 文件和sockets

```plain
在文件和sockets结束时, 显式的关闭它.
```

除文件外, sockets或其他类似文件的对象在没有必要的情况下打开, 会有许多副作用, 例如:

1. 它们可能会消耗有限的系统资源, 如文件描述符. 如果这些资源在使用后没有及时归还系统, 那么用于处理这些对象的代码会将资源消耗殆尽.
2. 持有文件将会阻止对于文件的其他诸如移动、删除之类的操作.
3. 仅仅是从逻辑上关闭文件和sockets, 那么它们仍然可能会被其共享的程序在无意中进行读或者写操作. 只有当它们真正被关闭后, 对于它们尝试进行读或者写操作将会抛出异常, 并使得问题快速显现出来.

而且, 幻想当文件对象析构时, 文件和sockets会自动关闭, 试图将文件对象的生命周期和文件的状态绑定在一起的想法, 都是不现实的. 因为有如下原因:

1. 没有任何方法可以确保运行环境会真正的执行文件的析构. 不同的Python实现采用不同的内存管理技术, 比如延时垃圾处理机制. 延时垃圾处理机制可能会导致对象生命周期被任意无限制的延长.
2. 对于文件意外的引用,会导致对于文件的持有时间超出预期(比如对于异常的跟踪, 包含有全局变量等).

推荐使用 "with"语句 以管理文件:

```plain
with open("hello.txt") as hello_file:
    for line in hello_file:
        print line
```

对于不支持使用"with"语句的类似文件的对象,使用 contextlib.closing():

```plain
import contextlib
with contextlib.closing(urllib.urlopen("http://www.python.org/")) as front_page:
    for line in front_page:
        print line
```

Legacy AppEngine 中Python 2.5的代码如使用"with"语句, 需要添加 "from **future** import with_statement".

#### TODO注释

```plain
为临时代码使用TODO注释, 它是一种短期解决方案. 不算完美, 但够好了.
```

TODO注释应该在所有开头处包含"TODO"字符串, 紧跟着是用括号括起来的你的名字, email地址或其它标识符. 然后是一个可选的冒号. 接着必须有一行注释, 解释要做什么. 主要目的是为了有一个统一的TODO格式, 这样添加注释的人就可以搜索到(并可以按需提供更多细节). 写了TODO注释并不保证写的人会亲自解决问题. 当你写了一个TODO, 请注上你的名字.

```plain
# TODO(kl@gmail.com): Use a "*" here for string repetition.
# TODO(Zeke) Change this to use relations.
```

如果你的TODO是"将来做某事"的形式, 那么请确保你包含了一个指定的日期("2009年11月解决")或者一个特定的事件("等到所有的客户都可以处理XML请求就移除这些代码").

#### 导入格式

```plain
每个导入应该独占一行
```

```plain
Yes: import os
     import sys
```

```plain
No:  import os, sys
```

导入总应该放在文件顶部, 位于模块注释和文档字符串之后, 模块全局变量和常量之前. 导入应该按照从最通用到最不通用的顺序分组:

1. 标准库导入
2. 第三方库导入
3. 应用程序指定导入

每种分组中, 应该根据每个模块的完整包路径按字典序排序, 忽略大小写.

```plain
import foo
from foo import bar
from foo.bar import baz
from foo.bar import Quux
from Foob import ar
```

#### 语句

```plain
通常每个语句应该独占一行
```

不过, 如果测试结果与测试语句在一行放得下, 你也可以将它们放在同一行. 如果是if语句, 只有在没有else时才能这样做. 特别地, 绝不要对 `try/except` 这样做, 因为try和except不能放在同一行.

```plain
Yes:
  if foo: bar(foo)
```

```plain
No:
  if foo: bar(foo)
  else:   baz(foo)
  try:               bar(foo)
  except ValueError: baz(foo)
  try:
      bar(foo)
  except ValueError: baz(foo)
```

#### 访问控制

```plain
在Python中, 对于琐碎又不太重要的访问函数, 你应该直接使用公有变量来取代它们, 这样可以避免额外的函数调用开销. 当添加更多功能时, 你可以用属性(property)来保持语法的一致性.
(译者注: 重视封装的面向对象程序员看到这个可能会很反感, 因为他们一直被教育: 所有成员变量都必须是私有的! 其实, 那真的是有点麻烦啊. 试着去接受Pythonic哲学吧)
```

另一方面, 如果访问更复杂, 或者变量的访问开销很显著, 那么你应该使用像 `get_foo()` 和 `set_foo()` 这样的函数调用. 如果之前的代码行为允许通过属性(property)访问 , 那么就不要将新的访问函数与属性绑定. 这样, 任何试图通过老方法访问变量的代码就没法运行, 使用者也就会意识到复杂性发生了变化.

#### 命名

```plain
module_name, package_name, ClassName, method_name, ExceptionName, function_name, GLOBAL_VAR_NAME, instance_var_name, function_parameter_name, local_var_name.
```

##### 应该避免的名称

1. 单字符名称, 除了计数器和迭代器.
2. 包/模块名中的连字符(-)
3. 双下划线开头并结尾的名称(Python保留, 例如__init\_\_)

##### 命名约定

1. 所谓"内部(Internal)"表示仅模块内可用, 或者, 在类内是保护或私有的.
2. 用单下划线(\_)开头表示模块变量或函数是protected的(使用import \* from时不会包含).
3. 用双下划线(\_\_)开头的实例变量或方法表示类内私有.
4. 将相关的类和顶级函数放在同一个模块里. 不像Java, 没必要限制一个类一个模块.
5. 对类名使用大写字母开头的单词(如CapWords, 即Pascal风格), 但是模块名应该用小写加下划线的方式(如lower_with_under.py). 尽管已经有很多现存的模块使用类似于CapWords.py这样的命名, 但现在已经不鼓励这样做, 因为如果模块名碰巧和类名一致, 这会让人困扰.

##### Python之父Guido推荐的规范

| Type | Public | Internal |
| :--- | :--- | :--- |
| Modules | lower_with_under | \_lower_with_under |
| Packages | lower_with_under | |
| Classes | CapWords | \_CapWords |
| Exceptions | CapWords | |
| Functions | lower_with_under() | \_lower_with_under() |
| Global/Class Constants | CAPS_WITH_UNDER | \_CAPS_WITH_UNDER |
| Global/Class Variables | lower_with_under | \_lower_with_under |
| Instance Variables | lower_with_under | \_lower_with_under (protected) or \_\_lower_with_under (private) |
| Method Names | lower_with_under() | \_lower_with_under() (protected) or \_\_lower_with_under() (private) |
| Function/Method Parameters | lower_with_under | |
| Local Variables | lower_with_under | |

##### Main

```plain
即使是一个打算被用作脚本的文件, 也应该是可导入的. 并且简单的导入不应该导致这个脚本的主功能(main functionality)被执行, 这是一种副作用. 主功能应该放在一个main()函数中.
```

在Python中, pydoc以及单元测试要求模块必须是可导入的. 你的代码应该在执行主程序前总是检查 `if __name__ == '__main__'` , 这样当模块被导入时主程序就不会被执行.

```plain
def main():
      ...
if __name__ == '__main__':
    main()
```

所有的顶级代码在模块导入时都会被执行. 要小心不要去调用函数, 创建对象, 或者执行那些不应该在使用pydoc时执行的操作.

[](http://book.luffycity.com/python-book/di-1-zhang-python-ji-chu/114-pythonkai-fa-gui-fan-zhi-nan.html)[\
](http://book.luffycity.com/python-book/di-1-zhang-python-ji-chu/114-pythonkai-fa-gui-fan-zhi-nan/pythonyu-yan-gui-fan.html)

## 1.14.2 python 语言规范

#### Lint

```plain
对你的代码运行pylint
```

##### 定义:

pylint是一个在Python源代码中查找bug的工具. 对于C和C++这样的不那么动态的(译者注: 原文是less dynamic)语言, 这些bug通常由编译器来捕获. 由于Python的动态特性, 有些警告可能不对. 不过伪告警应该很少.

##### 优点:

可以捕获容易忽视的错误, 例如输入错误, 使用未赋值的变量等.

##### 缺点:

pylint不完美. 要利用其优势, 我们有时侯需要: a) 围绕着它来写代码 b) 抑制其告警 c) 改进它, 或者d) 忽略它.

##### 结论:

确保对你的代码运行pylint.抑制不准确的警告,以便能够将其他警告暴露出来。

你可以通过设置一个行注释来抑制告警. 例如:

```plain
dict = 'something awful'  # Bad Idea... pylint: disable=redefined-builtin
```

pylint警告是以一个数字编号(如 `C0112` )和一个符号名(如 `empty-docstring` )来标识的. 在编写新代码或更新已有代码时对告警进行抑制, 推荐使用符号名来标识.

如果警告的符号名不够见名知意，那么请对其增加一个详细解释。

采用这种抑制方式的好处是我们可以轻松查找抑制并回顾它们.

你可以使用命令 `pylint --list-msgs` 来获取pylint告警列表. 你可以使用命令 `pylint --help-msg=C6409` , 以获取关于特定消息的更多信息.

相比较于之前使用的

!FILENAME disable`.`pylint: disable-msg`, 本文推荐使用`pylint

要抑制"参数未使用"告警, 你可以用"\_"作为参数标识符, 或者在参数名前加`"unused_"`. 遇到不能改变参数名的情况, 你可以通过在函数开头"提到"它们来消除告警. 例如:

```plain
def foo(a, unused_b, unused_c, d=None, e=None):
    _ = d, e
    return a
```

#### 导入

```plain
仅对包和模块使用导入
```

##### 定义:

模块间共享代码的重用机制.

##### 优点:

命名空间管理约定十分简单. 每个标识符的源都用一种一致的方式指示. x.Obj表示Obj对象定义在模块x中.

##### 缺点:

模块名仍可能冲突. 有些模块名太长, 不太方便.

##### 结论:

使用 `import x` 来导入包和模块.

使用 `from x import y` , 其中x是包前缀, y是不带前缀的模块名.

使用 `from x import y as z`, 如果两个要导入的模块都叫做y或者y太长了.

例如, 模块 `sound.effects.echo` 可以用如下方式导入:

```plain
from sound.effects import echo
...
echo.EchoFilter(input, output, delay=0.7, atten=4)
```

导入时不要使用相对名称. 即使模块在同一个包中, 也要使用完整包名. 这能帮助你避免无意间导入一个包两次.

#### 包

```plain
使用模块的全路径名来导入每个模块
```

##### 优点:

避免模块名冲突. 查找包更容易.

##### 缺点:

部署代码变难, 因为你必须复制包层次.

##### 结论:

所有的新代码都应该用完整包名来导入每个模块.

应该像下面这样导入:

```plain
# Reference in code with complete name.
import sound.effects.echo
# Reference in code with just module name (preferred).
from sound.effects import echo
```

#### 异常

```plain
允许使用异常, 但必须小心
```

##### 定义:

异常是一种跳出代码块的正常控制流来处理错误或者其它异常条件的方式.

##### 优点:

正常操作代码的控制流不会和错误处理代码混在一起. 当某种条件发生时, 它也允许控制流跳过多个框架. 例如, 一步跳出N个嵌套的函数, 而不必继续执行错误的代码.

##### 缺点:

可能会导致让人困惑的控制流. 调用库时容易错过错误情况.

##### 结论:

异常必须遵守特定条件:

1. 像这样触发异常: `raise MyException("Error message")` 或者 `raise MyException` . 不要使用两个参数的形式( `raise MyException, "Error message"` )或者过时的字符串异常( `raise "Error message"` ).
2. 模块或包应该定义自己的特定域的异常基类, 这个基类应该从内建的Exception类继承. 模块的异常基类应该叫做"Error".

```plain
class Error(Exception):
     pass
```

1. 永远不要使用

!FILENAME 很容易隐藏真正的bug. `except`: 语句来捕获所有异常, 也不要捕获 `Exception` 或者 `StandardError` , 除非你打算重新触发该异常, 或者你已经在当前线程的最外层(记得还是要打印一条错误消息). 在异常这方面, Python非常宽容, `except`: 真的会捕获包括Python语法错误在内的任何错误. 使用 `except`

1. 尽量减少`try/except`块中的代码量. try块的体积越大, 期望之外的异常就越容易被触发. 这种情况下, `try/except`块将隐藏真正的错误.
2. 使用finally子句来执行那些无论try块中有没有异常都应该被执行的代码. 这对于清理资源常常很有用, 例如关闭文件.
3. 当捕获异常时, 使用 `as` 而不要用逗号. 例如

```plain
try:
    raise Error
except Error as error:
    pass
```

#### 全局变量

```plain
避免全局变量
```

##### 定义:

定义在模块级的变量.

##### 优点:

偶尔有用.

##### 缺点:

导入时可能改变模块行为, 因为导入模块时会对模块级变量赋值.

##### 结论:

避免使用全局变量, 用类变量来代替. 但也有一些例外:

1. 脚本的默认选项.
2. 模块级常量. 例如:　PI = 3.14159. 常量应该全大写, 用下划线连接.
3. 有时候用全局变量来缓存值或者作为函数返回值很有用.
4. 如果需要, 全局变量应该仅在模块内部可用, 并通过模块级的公共函数来访问.

#### 嵌套/局部/内部类或函数

```plain
鼓励使用嵌套/本地/内部类或函数
```

##### 定义:

类可以定义在方法, 函数或者类中. 函数可以定义在方法或函数中. 封闭区间中定义的变量对嵌套函数是只读的.

##### 优点:

允许定义仅用于有效范围的工具类和函数.

##### 缺点:

嵌套类或局部类的实例不能序列化(pickled).

##### 结论:

推荐使用.

#### 列表推导(List Comprehensions)

```plain
可以在简单情况下使用
```

##### 定义:

列表推导(list comprehensions)与生成器表达式(generator expression)提供了一种简洁高效的方式来创建列表和迭代器, 而不必借助map(), filter(), 或者lambda.

##### 优点:

简单的列表推导可以比其它的列表创建方法更加清晰简单. 生成器表达式可以十分高效, 因为它们避免了创建整个列表.

##### 缺点:

复杂的列表推导或者生成器表达式可能难以阅读.

##### 结论:

适用于简单情况. 每个部分应该单独置于一行: 映射表达式, for语句, 过滤器表达式. 禁止多重for语句或过滤器表达式. 复杂情况下还是使用循环.

```plain
Yes:
  result = []
  for x in range(10):
      for y in range(5):
          if x * y > 10:
              result.append((x, y))
  for x in xrange(5):
      for y in xrange(5):
          if x != y:
              for z in xrange(5):
                  if y != z:
                      yield (x, y, z)
  return ((x, complicated_transform(x))
          for x in long_generator_function(parameter)
          if x is not None)
  squares = [x * x for x in range(10)]
  eat(jelly_bean for jelly_bean in jelly_beans
      if jelly_bean.color == 'black')
```

```plain
No:
  result = [(x, y) for x in range(10) for y in range(5) if x * y > 10]
  return ((x, y, z)
          for x in xrange(5)
          for y in xrange(5)
          if x != y
          for z in xrange(5)
          if y != z)
```

#### 默认迭代器和操作符

```plain
如果类型支持, 就使用默认迭代器和操作符. 比如列表, 字典及文件等.
```

##### 定义:

容器类型, 像字典和列表, 定义了默认的迭代器和关系测试操作符(in和not in)

##### 优点:

默认操作符和迭代器简单高效, 它们直接表达了操作, 没有额外的方法调用. 使用默认操作符的函数是通用的. 它可以用于支持该操作的任何类型.

##### 缺点:

你没法通过阅读方法名来区分对象的类型(例如, has_key()意味着字典). 不过这也是优点.

##### 结论:

如果类型支持, 就使用默认迭代器和操作符, 例如列表, 字典和文件. 内建类型也定义了迭代器方法. 优先考虑这些方法, 而不是那些返回列表的方法. 当然，这样遍历容器时，你将不能修改容器.

```plain
Yes:  for key in adict: ...
      if key not in adict: ...
      if obj in alist: ...
      for line in afile: ...
      for k, v in dict.iteritems(): ...
```

```plain
No:   for key in adict.keys(): ...
      if not adict.has_key(key): ...
      for line in afile.readlines(): ...
```

#### 生成器

```plain
按需使用生成器.
```

##### 定义:

所谓生成器函数, 就是每当它执行一次生成(yield)语句, 它就返回一个迭代器, 这个迭代器生成一个值. 生成值后, 生成器函数的运行状态将被挂起, 直到下一次生成.

##### 优点:

简化代码, 因为每次调用时, 局部变量和控制流的状态都会被保存. 比起一次创建一系列值的函数, 生成器使用的内存更少.

##### 缺点:

没有.

##### 结论:

鼓励使用. 注意在生成器函数的文档字符串中使用"Yields:"而不是"Returns:".

#### Lambda函数

```plain
适用于单行函数
```

##### 定义:

与语句相反, lambda在一个表达式中定义匿名函数. 常用于为 map() 和 filter() 之类的高阶函数定义回调函数或者操作符.

##### 优点:

方便.

##### 缺点:

比本地函数更难阅读和调试. 没有函数名意味着堆栈跟踪更难理解. 由于lambda函数通常只包含一个表达式, 因此其表达能力有限.

##### 结论:

适用于单行函数. 如果代码超过60-80个字符, 最好还是定义成常规(嵌套)函数.

对于常见的操作符，例如乘法操作符，使用 operator 模块中的函数以代替lambda函数. 例如, 推荐使用 operator.mul , 而不是 lambda x, y: x \* y .

#### 条件表达式

```plain
适用于单行函数
```

##### 定义:

条件表达式是对于if语句的一种更为简短的句法规则. 例如: x = 1 if cond else 2 .

##### 优点:

比if语句更加简短和方便.

##### 缺点:

比if语句难于阅读. 如果表达式很长， 难于定位条件.

##### 结论:

适用于单行函数. 在其他情况下，推荐使用完整的if语句.

#### 默认参数值

```plain
适用于大部分情况.
```

##### 定义:

你可以在函数参数列表的最后指定变量的值, 例如, def foo(a, b = 0): . 如果调用foo时只带一个参数, 则b被设为0. 如果带两个参数, 则b的值等于第二个参数.

##### 优点:

你经常会碰到一些使用大量默认值的函数, 但偶尔(比较少见)你想要覆盖这些默认值. 默认参数值提供了一种简单的方法来完成这件事, 你不需要为这些罕见的例外定义大量函数. 同时, Python也不支持重载方法和函数, 默认参数是一种"仿造"重载行为的简单方式.

##### 缺点:

默认参数只在模块加载时求值一次. 如果参数是列表或字典之类的可变类型, 这可能会导致问题. 如果函数修改了对象(例如向列表追加项), 默认值就被修改了.

##### 结论:

鼓励使用, 不过有如下注意事项:

不要在函数或方法定义中使用可变对象作为默认值.

```plain
Yes: def foo(a, b=None):
         if b is None:
             b = []
```

```plain
No:  def foo(a, b=[]):
         ...
No:  def foo(a, b=time.time()):  # The time the module was loaded???
         ...
No:  def foo(a, b=FLAGS.my_thing):  # sys.argv has not yet been parsed...
         ...
```

#### 属性(properties)

```plain
访问和设置数据成员时, 你通常会使用简单, 轻量级的访问和设置函数. 建议用属性（properties）来代替它们.
```

##### 定义:

一种用于包装方法调用的方式. 当运算量不大, 它是获取和设置属性(attribute)的标准方式.

##### 优点:

通过消除简单的属性(attribute)访问时显式的get和set方法调用, 可读性提高了. 允许懒惰的计算. 用Pythonic的方式来维护类的接口. 就性能而言, 当直接访问变量是合理的, 添加访问方法就显得琐碎而无意义. 使用属性(properties)可以绕过这个问题. 将来也可以在不破坏接口的情况下将访问方法加上.

##### 缺点:

属性(properties)是在get和set方法声明后指定, 这需要使用者在接下来的代码中注意: set和get是用于属性(properties)的(除了用 `@property` 装饰器创建的只读属性). 必须继承自object类. 可能隐藏比如操作符重载之类的副作用. 继承时可能会让人困惑.

##### 结论:

你通常习惯于使用访问或设置方法来访问或设置数据, 它们简单而轻量. 不过我们建议你在新的代码中使用属性. 只读属性应该用 `@property` 装饰器 来创建.

如果子类没有覆盖属性, 那么属性的继承可能看上去不明显. 因此使用者必须确保访问方法间接被调用, 以保证子类中的重载方法被属性调用(使用模板方法设计模式).

```plain
Yes: import math
     class Square(object):
         """A square with two properties: a writable area and a read-only perimeter.
         To use:
         >>> sq = Square(3)
         >>> sq.area
         9
         >>> sq.perimeter
         12
         >>> sq.area = 16
         >>> sq.side
         4
         >>> sq.perimeter
         16
         """
         def __init__(self, side):
             self.side = side
         def __get_area(self):
             """Calculates the 'area' property."""
             return self.side ** 2
         def ___get_area(self):
             """Indirect accessor for 'area' property."""
             return self.__get_area()
         def __set_area(self, area):
             """Sets the 'area' property."""
             self.side = math.sqrt(area)
         def ___set_area(self, area):
             """Indirect setter for 'area' property."""
             self._SetArea(area)
         area = property(___get_area, ___set_area,
                         doc="""Gets or sets the area of the square.""")
         @property
         def perimeter(self):
             return self.side * 4
```

(译者注: 老实说, 我觉得这段示例代码很不恰当, 有必要这么蛋疼吗?)

#### True/False的求值

```plain
尽可能使用隐式false
```

##### 定义:

Python在布尔上下文中会将某些值求值为false. 按简单的直觉来讲, 就是所有的"空"值都被认为是false. 因此0， None, \[], {}, "" 都被认为是false.

##### 优点:

使用Python布尔值的条件语句更易读也更不易犯错. 大部分情况下, 也更快.

##### 缺点:

对C/C++开发人员来说, 可能看起来有点怪.

##### 结论:

尽可能使用隐式的false, 例如: 使用

!FILENAME . 不过还是有一些注意事项需要你铭记在心: `if foo`: 而不是 `if foo != []`

1. 永远不要用==或者!=来比较单件, 比如None. 使用is或者is not.
2. 注意: 当你写下 `if x`: 时, 你其实表示的是

!FILENAME 当你要测试一个默认值是None的变量或参数是否被设为其它值. 这个值在布尔语义下可能是false! `if x is not None` . 例如

1. 永远不要用==将一个布尔量与false相比较. 使用 if not x: 代替. 如果你需要区分false和None, 你应该用像 `if not x and x is not None`: 这样的语句.
2. 对于序列(字符串, 列表, 元组), 要注意空序列是false. 因此

!FILENAME 要更好. `if not seq`: 或者 `if seq`: 比 `if len(seq)`: 或 `if not len(seq)`

1. 处理整数时, 使用隐式false可能会得不偿失(即不小心将None当做0来处理). 你可以将一个已知是整型(且不是len()的返回结果)的值与0比较.

````plain
```python
Yes: if not users:
         print 'no users'
     if foo == 0:
         self.handle_zero()
     if i % 10 == 0:
         self.handle_multiple_of_ten()
````

````

1. 注意'0'(字符串)会被当做true.

#### 过时的语言特性
```plain
尽可能使用字符串方法取代字符串模块. 使用函数调用语法取代apply(). 使用列表推导, for循环取代filter(), map()以及reduce().
````

##### 定义:

当前版本的Python提供了大家通常更喜欢的替代品.

##### 结论:

我们不使用不支持这些特性的Python版本, 所以没理由不用新的方式.

```plain
Yes: words = foo.split(':')
     [x[1] for x in my_list if x[2] == 5]
     map(math.sqrt, data)    # Ok. No inlined lambda expression.
     fn(*args, **kwargs)
```

```plain
No:  words = string.split(foo, ':')
     map(lambda x: x[1], filter(lambda x: x[2] == 5, my_list))
     apply(fn, args, kwargs)
```

#### 词法作用域(Lexical Scoping)

##### 定义:

嵌套的Python函数可以引用外层函数中定义的变量, 但是不能够对它们赋值. 变量绑定的解析是使用词法作用域, 也就是基于静态的程序文本. 对一个块中的某个名称的任何赋值都会导致Python将对该名称的全部引用当做局部变量, 甚至是赋值前的处理. 如果碰到global声明, 该名称就会被视作全局变量.

一个使用这个特性的例子:

```plain
def get_adder(summand1):
    """Returns a function that adds numbers to a given number."""
    def adder(summand2):
        return summand1 + summand2
    return adder
```

(译者注: 这个例子有点诡异, 你应该这样使用这个函数: `sum = get_adder(summand1)(summand2)`)

##### 优点:

通常可以带来更加清晰, 优雅的代码. 尤其会让有经验的Lisp和Scheme(还有Haskell, ML等)程序员感到欣慰.

##### 缺点:

可能导致让人迷惑的bug. 例如下面这个依据 PEP-0227 的例子:

```plain
i = 4
def foo(x):
    def bar():
        print i,
    # ...
    # A bunch of code here
    # ...
    for i in x:  # Ah, i *is* local to Foo, so this is what Bar sees
        print i,
    bar()
```

因此 `foo([1, 2, 3])` 会打印 `1 2 3 3` , 不是 `1 2 3 4` .

译者注: x是一个列表, for循环其实是将x中的值依次赋给i.这样对i的赋值就隐式的发生了, 整个foo函数体中的i都会被当做局部变量, 包括bar()中的那个. 这一点与C++之类的静态语言还是有很大差别的.)

##### 结论:

鼓励使用.

#### 函数与方法装饰器

```plain
如果好处很显然, 就明智而谨慎的使用装饰器
```

#### 定义:

用于函数及方法的装饰器 (也就是@标记). 最常见的装饰器是`@classmethod` 和`@staticmethod`, 用于将常规函数转换成类方法或静态方法. 不过, 装饰器语法也允许用户自定义装饰器. 特别地, 对于某个函数 `my_decorator` , 下面的两段代码是等效的:

```plain
class C(object):
   @my_decorator
   def method(self):
       # method body ...
```

```plain
class C(object):
    def method(self):
        # method body ...
    method = my_decorator(method)
```

##### 优点:

优雅的在函数上指定一些转换. 该转换可能减少一些重复代码, 保持已有函数不变(enforce invariants), 等.

##### 缺点:

装饰器可以在函数的参数或返回值上执行任何操作, 这可能导致让人惊异的隐藏行为. 而且, 装饰器在导入时执行. 从装饰器代码的失败中恢复更加不可能.

##### 结论:

如果好处很显然, 就明智而谨慎的使用装饰器. 装饰器应该遵守和函数一样的导入和命名规则. 装饰器的python文档应该清晰的说明该函数是一个装饰器. 请为装饰器编写单元测试.

避免装饰器自身对外界的依赖(即不要依赖于文件, socket, 数据库连接等), 因为装饰器运行时这些资源可能不可用(由 `pydoc` 或其它工具导入). 应该保证一个用有效参数调用的装饰器在所有情况下都是成功的.

装饰器是一种特殊形式的"顶级代码". 参考后面关于 Main 的话题.

#### 线程

```plain
不要依赖内建类型的原子性.
```

虽然Python的内建类型例如字典看上去拥有原子操作, 但是在某些情形下它们仍然不是原子的(即: 如果**hash**或**eq**被实现为Python方法)且它们的原子性是靠不住的. 你也不能指望原子变量赋值(因为这个反过来依赖字典).

优先使用Queue模块的 `Queue` 数据类型作为线程间的数据通信方式. 另外, 使用threading模块及其锁原语(locking primitives). 了解条件变量的合适使用方式, 这样你就可以使用 `threading.Condition` 来取代低级别的锁了.

#### 威力过大的特性

```plain
避免使用这些特性
```

##### 定义:

Python是一种异常灵活的语言, 它为你提供了很多花哨的特性, 诸如元类(metaclasses), 字节码访问, 任意编译(on-the-fly compilation), 动态继承, 对象父类重定义(object reparenting), 导入黑客(import hacks), 反射, 系统内修改(modification of system internals), 等等.

##### 优点:

强大的语言特性, 能让你的代码更紧凑.

##### 缺点:

使用这些很"酷"的特性十分诱人, 但不是绝对必要. 使用奇技淫巧的代码将更加难以阅读和调试. 开始可能还好(对原作者而言), 但当你回顾代码, 它们可能会比那些稍长一点但是很直接的代码更加难以理解.

##### 结论:

在你的代码中避免这些特性.

> 更新: 2021-01-15 08:32:23  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/bec7a9>