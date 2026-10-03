# 第1章 Python基础语法(new)

到现在为止，我们也是写过代码的人啦，但你有没有发现，每次写代码要新建文件、写完保存时还要选择存放地点，执行时还要切换到命令行调用python解释器，好麻烦呀，能否一气呵成，让我简单的写代码？此时开发工具IDE上场啦，一个好的IDE能帮你大大提升开发效率。

很多语言都有比较流行的开发工具，比如JAVA 的Eclipse, C#,C++的VisualStudio, Python的是啥呢？ Pycharm，最好的Python 开发IDE

**安装**

下载地址:<https://www.jetbrains.com/pycharm/download>选择Professional 专业版

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

你以后写的项目可能有成百上千个代码文件 ，全放在一起可不好，所以一般把同样功能的代码放在一个目录，我们现在以天为单位，为每天的学习创建一个目录day1,day2,day3…这样

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
- 点击Run‘hello'就可以运行啦
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

# 1.1 编程语言介绍和分类

## 什么是编程？为什么要编程？

编程 是个动词，编程==写代码，写代码为了什么? 为了让计算机干你想要干的事情，比如，马化腾想跟别人聊天，于是写了个聊天软件，这个软件就是一堆代码的集合，这些代码是什么？这些代码是计算机能理解的语言。

那计算能理解的语言是什么呢？ 之前，我们已经了解到，它只能理解2进制，0101010…，你总不能人肉输一堆二进制给计算机(虽然最原始的计算机就是这么干的)让它工作吧，这样开发速度太慢了。所以最好的办法就是人输入简单的指令，计算机能把指令转成二进制进行执行，举例如下:

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

## 有哪些编程语言？

编程语言总体分以为机器语言、汇编语言、高级语言，如下

**机器语言**

由于计算机内部只能接受二进制代码，因此，用二进制代码0和1描述的指令称为机器指令，全部机器指令的集合构成计算机的机器语言，用机器语言编程的程序称为目标程序。只有目标程序才能被计算机直接识别和执行。但是机器语言编写的程序无明显特征，难以记忆，不便阅读和书写，且依赖于具体机种，局限性很大，机器语言属于低级语言。

用机器语言编写程序，编程人员要首先熟记所用计算机的全部指令代码和代码的涵义。手编程序时，程序员得自己处理每条指令和每一数据的存储分配和输入输出，还得记住编程过程中每步所使用的工作单元处在何种状态。这是一件十分繁琐的工作。编写程序花费的时间往往是实际运行时间的几十倍或几百倍。而且，编出的程序全是些0和1的指令代码，直观性差，还容易出错。**除了计算机生产厂家的专业人员外，绝大多数的程序员已经不再去学习机器语言了。**

机器语言是微处理器理解和使用的，用于控制它的操作二进制代码。

尽管机器语言好像是很复杂的，然而它是有规律的。

存在着多至100000种机器语言的指令。这意味着不能把这些种类全部列出来。

以下是一些示例：

指令部份的示例

0000 代表 加载（LOAD）

0001 代表 存储（STORE）

…

暂存器部份的示例

0000 代表暂存器 A

0001 代表暂存器 B

…

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

汇编语言的实质和机器语言是相同的，都是直接对硬件操作，只不过指令采用了英文缩写的标识符，更容易识别和记忆。它同样需要编程者将每一步具体的操作用命令的形式写出来。汇编程序的每一句指令只能对应实际操作过程中的一个很细微的动作。例如移动、自增，因此汇编源程序一般比较冗长、复杂、容易出错，而且使用汇编语言编程需要有更多的计算机专业知识，但汇编语言的优点也是显而易见的，用汇编语言所能完成的操作不是一般高级语言所能够实现的，而且源程序经汇编生成的可执行文件不仅比较小，而且执行速度很快。

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

**编译类**：编译是指在应用源程序执行之前，就将程序源代码“翻译”成目标代码（机器语言），因此其目标程序可以脱离其语言环境独立执行(编译后生成的可执行文件，是cpu可以理解的2进制的机器码组成的)，使用比较方便、效率较高。但应用程序一旦需要修改，必须先修改源代码，再重新编译生成新的目标文件（\* .obj，也就是OBJ文件）才能执行，只有目标文件而没有源代码，修改很不方便。

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

**解释类**：执行方式类似于我们日常生活中的“同声翻译”，应用程序源代码一边由相应语言的解释器“翻译”成目标代码（机器语言），一边执行，因此效率比较低，而且不能生成可独立执行的可执行文件，应用程序不能脱离其解释器(想运行，必须先装上解释器，就像跟老外说话，必须有翻译在场)，但这种方式比较灵活，可以动态地调整、修改应用程序。如Python、Java、PHP、Ruby等语言。

### **总结**

**机器语言**

优点是最底层，速度最快，缺点是最复杂，开发效率最低

**汇编语言**

优点是比较底层，速度最快，缺点是复杂，开发效率最低

**高级语言**

编译型语言执行速度快，不依赖语言环境运行，跨平台差

解释型跨平台好，一份代码，到处使用，缺点是执行速度慢，依赖解释器运行

## 主流编程语言介绍(10分钟)

世界上的编程语言有600多种，但真正大家主流在使用的最多二三十种，不同的语言有自己的特点和擅长领域，随着计算机的不断发展，新语言在不断诞生，也同时有很多老旧的语言慢慢无人用了。有个权威的语言排名网站，可以看到主流的编程语言是哪些

\*2019年2月数据(<https://www.tiobe.com/tiobe-index/>)

<!-- OCR_START -->
- Feb 2019
- Feb 2018
- Change
- Programming Language
- Ratings
- 1
- Java
- 15.876%
- +0.89%
- 2
- 12.424%
- +0.57%
- 3
- 4
- Python
- 7.574%
- +2.41%
- C++
- 7.444%
- +1.72%
- 5
- 6
- Visual Basic .NET
- 7.095%
- +3.02%
- 8
- JavaScript
- 2.848%
- -0.32%
- 7
- ５
- 2.846%
- -1.61%
- PHP
- 2.271%
- -1.15%
- 9
- 11
- SQL
- 1.900%
- -0.46%
- 10
- 20
- Objective-C
- 1.447%
- 15
- Assembly language
- 1.377%
- 12
- 19
- MATLAB
- 1.196%
- -0.03%
- 13
- 17
- Perl
- 1.102%
- -0.66%
- 14
- Delphi/Object Pascal
- 1.066%
- -1.52%
- 1.043%
- -1.04%
- 16
- Ruby
- 1.037%
- -1.50%
- Visual Basic
- 0.991%
- -1.19%
- 18
- Go
- 0.960%
- 49
- Groovy
- 0.936%
- +0.75%
- Swift
- 0.918%
- -0.88%
<!-- OCR_END -->

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

下面介绍下几个主流的编程语言：

**C语言:**

C语言是一种计算机程序设计语言，它既具有高级语言的特点，又具有汇编语言的特点。它由美国贝尔研究所的D.M.Ritchie于1972年推出，1978年后，C语言已先后被移植到大、中、小及微型机上，它可以作为工作系统设计语言，编写系统应用程序，也可以作为应用程序设计语言，编写不依赖计算机硬件的应用程序。它的应用范围广泛，具备很强的数据处理能力，不仅仅是在软件开发上，而且各类科研都需要用到C语言，适于编写系统软件，三维，二维图形和动画，具体应用比如单片机以及嵌入式系统开发。

**C++：**

C++是C语言的继承的扩展，它既可以进行C语言的过程化程序设计，又可以进行以抽象数据类型为特点的基于对象的程序设计，还可以进行以继承和多态为特点的面向对象的程序设计。C++擅长面向对象程序设计的同时，还可以进行基于过程的程序设计，因而C++就适应的问题规模而论，大小由之。

C++不仅拥有计算机高效运行的实用性特征，同时还致力于提高大规模程序的编程质量与程序设计语言的问题描述能力。

**JAVA:**

Java是一种可以撰写跨平台应用软件的面向对象的程序设计语言，是由Sun Microsystems公司于1995年5月推出的Java程序设计语言和Java平台（即JavaSE, JavaEE, JavaME）的总称。Java 技术具有卓越的通用性、高效性、平台移植性和安全性，广泛应用于个人PC、数据中心、游戏控制台、科学超级计算机、移动电话和互联网，同时拥有全球最大的开发者专业社群。在全球云计算和移动互联网的产业环境下，Java更具备了显著优势和广阔前景。

**PHP:**

PHP（外文名:PHP: Hypertext Preprocessor，中文名：“超文本预处理器”）是一种通用开源脚本语言。语法吸收了C语言、Java和Perl的特点，利于学习，使用广泛，主要适用于Web开发领域

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

Go是从2007年末由Robert Griesemer, Rob Pike, Ken Thompson主持开发，后来还加入了Ian Lance Taylor, Russ Cox等人，并最终于2009年11月开源，在2012年早些时候发布了Go 1稳定版本。现在Go的开发已经是完全开放的，并且拥有一个活跃的社区。

由其擅长并发编程

**Python:**

Python是一门优秀的综合语言， Python的宗旨是简明、优雅、强大，在人工智能、云计算、金融分析、大数据开发、WEB开发、自动化运维、测试等方向应用广泛，已是全球第4大最流行的语言。

# 1.2 Python介绍、发展趋势

## Python介绍

Python的创始人为吉多·范罗苏姆（Guido van Rossum）。1989年的圣诞节期间，Guido开始写Python语言的编译器。Python这个名字，来自Guido所挚爱的电视剧Monty Python’s Flying Circus。他希望这个新的叫做Python的语言，能符合他的理想：创造一种C和shell之间，功能全面，易学易用，可拓展的语言。

最新的TIOBE排行榜，Python赶超C++占据第3， 与Java、C一起成为全球最流行的3大编程语言。

Python崇尚优美、清晰、简单，上手简单，非常适合做为第一门编程语言来学习。

Python可以应用于众多领域，如：数据分析、组件集成、网络服务、图像处理、数值计算和科学计算等众多领域。目前业内几乎所有大中型互联网企业都在使用Python，如：Youtube、Dropbox、BT、Quora（中国知乎）、豆瓣、知乎、Google、Yahoo!、Facebook、NASA、百度、腾讯、汽车之家、美团等。

## **目前Python主要应用领域：**

1. WEB开发——最火的Python web框架Django, 支持异步高并发的Tornado框架，短小精悍的flask,bottle, Django官方的标语把Django定义为the framework for perfectionist with deadlines(大意是一个为完全主义者开发的高效率web框架)
2. 网络编程——支持高并发的Twisted网络框架， py3引入的asyncio使异步编程变的非常简单
3. 爬虫——爬虫领域，Python几乎是霸主地位，Scrapy\Request\BeautifuSoap\urllib等，想爬啥就爬啥
4. 云计算——目前最火最知名的云计算框架就是OpenStack,Python现在的火，很大一部分就是因为云计算
5. 人工智能、数据分析—— Python 是目前公认的人工智能和数据分析领域的必备语言
6. 自动化运维——问问中国的每个运维人员，运维人员必须会的语言是什么？10个人相信会给你一个相同的答案，它的名字叫Python
7. 金融分析——我个人之前在金融行业，10年的时候，我们公司写的好多分析程序、高频交易软件就是用的Python,到目前,Python是金融分析、量化交易领域里用的最多的语言
8. 科学运算—— 97年开始，NASA就在大量使用Python在进行各种复杂的科学运算，随着NumPy, SciPy, Matplotlib, Enthought librarys等众多程序库的开发，使的Python越来越适合于做科学计算、绘制高质量的2D和3D图像。和科学计算领域最流行的商业软件Matlab相比，Python是一门通用的程序设计语言，比Matlab所采用的脚本语言的应用范围更广泛
9. 游戏开发——在网络游戏开发中Python也有很多应用。相比Lua or C++,Python 比 Lua 有更高阶的抽象能力，可以用更少的代码描述游戏业务逻辑，与 Lua 相比，Python 更适合作为一种 Host 语言，即程序的入口点是在 Python 那一端会比较好，然后用 C/C++ 在非常必要的时候写一些扩展。Python 非常适合编写 1 万行以上的项目，而且能够很好地把网游项目的规模控制在 10 万行代码以内。另外据我所知，知名的游戏 < 文明 > 就是用Python写的

## **Python在一些公司的应用：**

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

## **Python的发展史**

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

## **Python的发展前景怎么样？**

知乎上有一篇文章，问Python未来10年的发展前景，请去看一下Alex的回答

> 未来十年Python的前景会怎样？<https://www.zhihu.com/question/22112542/answer/166053516>

## Python 2 or Python 3 ?

***In summary : Python 2.x is legacy, Python 3.x is the present and future of the language***

*Python 3.0 was released in 2008. The final 2.x version 2.7 release came out in mid-2010, with a statement of*

*extended support for this end-of-life release. The 2.x branch will see no new major releases after that. 3.x is*

*under active development and has already seen over five years of stable releases, including version 3.3 in 2012,*

*3.4 in 2014, and 3.5 in 2015. This means that all recent standard library improvements, for example, are only*

*available by default in Python 3.x.*

*Guido van Rossum (the original creator of the Python language) decided to clean up Python 2.x properly, with less regard for backwards compatibility than is the case for new releases in the 2.x range. The most drastic improvement is the better Unicode support (with all text strings being Unicode by default) as well as saner bytes/Unicode separation.*

*Besides, several aspects of the core language (such as print and exec being statements, integers using floor division) have been adjusted to be easier for newcomers to learn and to be more consistent with the rest of the language, and old cruft has been removed (for example, all classes are now new-style, “range()” returns a memory efficient iterable, not a list as in 2.x).*

目前虽然业内不少企业还在大量使用 2.7，因为旧项目几十万甚至上百万行的代码想快速升级到3.0不是件容易的事，但是大家在开发新项目时几乎都会使用3.x。

另外Python3 确实想比2.x做了很多的改进，直观点来讲，就像从XP升级到Win7的感觉一样，棒棒的。

Py2 和Py3的具体细节区别我们在以后课程中会慢慢深入。

## Python的优缺点

先看优点

1. Python的定位是“优雅”、“明确”、“简单”，所以Python程序看上去总是简单易懂，初学者学Python，不但入门容易，而且将来深入下去，可以编写那些非常非常复杂的程序。
2. 开发效率非常高，Python有非常强大的第三方库，基本上你想通过计算机实现任何功能，Python官方库里都有相应的模块进行支持，直接下载调用后，在基础库的基础上再进行开发，大大降低开发周期，避免重复造轮子。
3. 高级语言————当你用Python语言编写程序的时候，你无需考虑诸如如何管理你的程序使用的内存一类的底层细节
4. 可移植性————由于它的开源本质，Python已经被移植在许多平台上（经过改动使它能够工 作在不同平台上）。如果你小心地避免使用依赖于系统的特性，那么你的所有Python程序无需修改就几乎可以在市场上所有的系统平台上运行
5. 可扩展性————如果你需要你的一段关键代码运行得更快或者希望某些算法不公开，你可以把你的部分程序用C或C++编写，然后在你的Python程序中使用它们。
6. 可嵌入性————你可以把Python嵌入你的C/C++程序，从而向你的程序用户提供脚本功能。

再看缺点：

1. **速度慢** ，Python 的运行速度相比C语言确实慢很多，跟JAVA相比也要慢一些，因此这也是很多所谓的大牛不屑于使用Python的主要原因，但其实这里所指的运行速度慢在大多数情况下用户是无法直接感知到的，必须借助测试工具才能体现出来，比如你用C运一个程序花了0.01s,用Python是0.1s,这样C语言直接比Python快了10倍,算是非常夸张了，但是你是无法直接通过肉眼感知的，因为一个正常人所能感知的时间最小单位是0.15-0.4s左右，哈哈。其实在大多数情况下Python已经完全可以满足你对程序速度的要求，除非你要写对速度要求极高的搜索引擎等，这种情况下，当然还是建议你用C去实现的。
2. **代码不能加密** ，因为PYTHON是解释性语言，它的源码都是以名文形式存放的，不过我不认为这算是一个缺点，如果你的项目要求源代码必须是加密的，那你一开始就不应该用Python来去实现。
3. **线程不能利用多核问题** ，这是Python被人诟病最多的一个缺点，GIL即全局解释器锁（Global Interpreter Lock），是计算机程序设计语言解释器用于同步线程的工具，使得任何时刻仅有一个线程在执行，Python的线程是操作系统的原生线程。在Linux上为pthread，在Windows上为Win thread，完全由操作系统调度线程的执行。一个python解释器进程内有一条主线程，以及多条用户程序的执行线程。即使在多核CPU平台上，由于GIL的存在，所以禁止多线程的并行执行。关于这个问题的折衷解决方法，我们在以后线程和进程章节里再进行详细探讨。

当然，Python还有一些其它的小缺点，在这就不一一列举了，我想说的是，任何一门语言都不是完美的，都有擅长和不擅长做的事情，建议各位不要拿一个语言的劣势去跟另一个语言的优势来去比较，语言只是一个工具，是实现程序设计师思想的工具，就像我们之前中学学几何时，有的时候需要要圆规，有的时候需要用三角尺一样，拿相应的工具去做它最擅长的事才是正确的选择。之前很多人问我Shell和Python到底哪个好？我回答说Shell是个脚本语言，但Python不只是个脚本语言，能做的事情更多，然后又有钻牛角尖的人说完全没必要学Python, Python能做的事情Shell都可以做，只要你足够牛B,然后又举了用Shell可以写俄罗斯方块这样的游戏，对此我能说表达只能是，**不要跟SB理论，SB会把你拉到跟他一样的高度，然后用充分的经验把你打倒。**

# 1.3 Python环境安装

Python目前已支持所有主流操作系统，在Linux,Unix,Mac系统上自带Python环境，在Windows系统上需要安装一下，超简单

## Windows安装

打开官网<https://www.python.org/downloads/windows/>下载中心

<!-- OCR_START -->
python
Donate
About
Downloads
Documentation
Community
Success
Python >>> Downloads >>Windows
Python Releases for Windows
Latest Python 3 Release - Python 3.7.2
Latest Python 2 Release - Python 2.7.15
· Python 2.7.16rc1 - 2019-02-17
· Download Windows x86 MSl installer
一般选这个x86-64的就行
DownloadWindowsx86-64MSlinstaller
·Download Windows help file
· Download Windows debug information files for 64-bit binaries
· Download Windows debug information files
Python 3.8.0a1 - 2019-02-03
<!-- OCR_END -->

下载安装完成。

### 配置环境变量

我的Python刚才装到C:\Users\alex\AppData\Local\Programs\Python\Python37 目录下了， 以后每次执行python程序时，还要到这个目录下调用python.exe这个可执行文件才行。 太麻烦了， 为了方便调用，可以配置系统的环境变量，让你的Python可以很容易的被找到。

找到我的计算机，右单击——》属性——》环境变量

<!-- OCR_START -->
- 系统属性
- 计算机名硬件
- 高级
- 系统保护远程
- 要进行大多数更改：您必须作为管理员登录。
- 性能
- 视觉效果，处理器计划，内存使用，以及虚拟内存
- 设置（S)..
- 用户配置文件
- 与您登录有关的桌面设置
- 设置（E)...
- 启动和故障恢复
- 系统启动，系统失败和调试信息
- 设置（T)...
- 环境变量).：
- 确定
- 取消
- 应用（A)
<!-- OCR_END -->

<!-- OCR_START -->
- 间 程序和功能
- Python37
- 系统
- 百度一下
- 淘淘宝
- 京东
- 传奇
- C:\Users\alex\AppData\Local\Programs\Python\Python37
- 组织
- 包含到库中▼
- 共享▼
- 刻录
- 新建文件夹
- 名称
- ☆收藏夹
- 修改日期
- Python 3.7 (64-bit)
- Python 3.7.2 (tags/u3.7.2:9a3ffc0492, Dec 23 2018, 23:09
- 下载
- DLLs
- 2019/2/
- (AMD64>]on win32
- 桌面
- Doc
- Type "help","copyright",
- "credits"or"license"for
- 最近访问的位置
- include
- 系统属性
- M Lib
- libs
- 计算机名硬件
- 高级
- 系统保护远程
- 同库
- Scripts
- 视频
- 环境变量
- 编辑系统变量
- ■ tcl
- 腾讯视频
- Tools
- alex的用户变量(u)
- 变量名0)：
- 口图片
- Path
- LICENSE
- 2018/12
- 变量
- 文档
- 变量值(V)：
- DataLocalProgramsPythonPython37
- 自 NEWS
- TEMP
- 音乐
- %USERPROFILE%\A
- python
- TMP
- 确定
- 取消
- python3.dll
- 计算机
- python37.dll
- 本地磁盘 (C:)
- pythonw
- 新建(N)...
- 编辑（E)...
- 删除()
- MobileBackups or
- vcruntime140.dll
- 系统变量（S）
- InstallESD on'psf'
- Home on 'psf (Y:)
- C: Progr am Files (x86)\Parallel.
- Mac Disk (Z:)
- PATHEXT
- .COM:.EXE:. BAT:.CMD:. VBS:. VBE:...
- PROCESSOR_AR.
- AMD64
- PRNCESSIR TI
- 70S+enn
- 网络
- 新建（W）.
- 编辑（工）
- 删除（L）
<!-- OCR_END -->

windows —> 运行 —> 输入cmd ，然后回车，弹出cmd程序，输入python,如果能进入交互环境 ，代表环境变量成功。

## Mac 安装

通过Lunchpad找到Terminal命令行终端

<!-- OCR_START -->
- tel
- TextEdit
- Sublime Text
- TeamViewer
<!-- OCR_END -->

输入Python3

# 1.4 开发你的第一个Python程序

在windows上创建第一个Python程序

<!-- OCR_START -->
- 帮助

```text
hello.py -记事本
文件(F)
编辑(E)
格式(0)
查看(V)
hello.py
print("Hello World.")
```
<!-- OCR_END -->

保存，然后通过python解释器执行

<!-- OCR_START -->
cC:\Windows\system32\cmd.exe
Microsoft Windows[版本 6.1.76@1]
版权所有（c）209MicrosoftCorporation。保留所有权利。
C:sersalex>python
Python 3.7.2 (tags/v3.7.2:9a3ffc0492.Dec 23 2018.23:09:28)
lype
"credits" or "license" for more info
exit()
hello.py
直接把文件拖过来就行
C:Vsersalex>
psfHome ^Desktophe llo -py- txt
Hello World.
<!-- OCR_END -->

好了，你的第一次，就这样没了，也就那么回事对吧，呵呵。

# 1.5 选择最好用的PyCharm

### 选择最好用的PyCharm IDE

到现在为止，我们也是写过代码的人啦，但你有没有发现，每次写代码要新建文件、写完保存时还要选择存放地点，执行时还要切换到命令行调用python解释器，好麻烦呀，能否一气呵成，让我简单的写代码？此时开发工具IDE上场啦，一个好的IDE能帮你大大提升开发效率。

很多语言都有比较流行的开发工具，比如JAVA 的Eclipse, C#,C++的VisualStudio, Python的是啥呢？ Pycharm，最好的Python 开发IDE。

\*\*安装：\*\*下载地址:<https://www.jetbrains.com/pycharm/download>选择Professional 专业版

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
- :Pyramid
- WWeb2Py
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

你以后写的项目可能有成百上千个代码文件 ，全放在一起可不好，所以一般把同样功能的代码放在一个目录，我们现在以天为单位，为每天的学习创建一个目录day1,day2,day3…这样
<!-- OCR_START -->
- py_learn
- Project
- llliExternal Lib
- New
- File
- NewScratch File
- % Cut
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
- PythonPackage
- CopyPath
- CopyasPlainText
- PythonFile
- CopyRelativePath
- iPJupyterNotebook
- Paste
- 8V
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
- Ill External Libraries
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
- 点击Run‘hello'就可以运行啦
- Folding
- GoTo
- Generate...
- Run'hello'
- ^OR
- Debug'hello
- ^D
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

代码调试

想不想看代码一步步的执行过程？比如想看每次循环某个变量有没有变化，总是print太low了，试试pycharm 牛逼的debug功能吧

<!-- OCR_START -->
- hello.py-py_learn-[~/PycharmProjects/py_learn]
- Phello
- py_learnday1
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
- break
- 8
- count+=1 #每执行一次，就把count+l，要不然就变成死循环啦，因为count一直是0
- 9
- 10
- print("
- -out of whileloop
- 蓝色背景行是代表当前走到哪步了
- 每次点击一下，程序就会走一步
- Deb
- hello
- →Variables
- <module>, hellc
- count ={int} 2
- 当前程序中所有变量的动态值
- QEvent Log
- 3:1LF
- UTF-8
<!-- OCR_END -->

# 1.6 变量

## 什么是变量？

变量，是用于在内存中存放程序数据的容器，怎么理解呢？

计算机的最核心功能就是“计算”， 计算需要数据源，数据源要存在内存里，比如我要把小明的姓名、身高、年龄信息存下来，后面程序会调用，怎么存呢，直接设置一个“变量名=值”， 就可以

```plain
name = "小明"
age = 22
height = 160
```

后面程序想调用的时候，直接调 变量名 就可以

```plain
name = "小明"
age = 22
height = 160 
print(name)
print(age)
```

## 变量的使用规则

程序是从上到下执行的，所以变量必须先定义，后调用， 否则会报错

<!-- OCR_START -->
- 5
- 6
- name = "小明"
- 7
- age = 22
- 8
- height = 160
- 9
- 10
- print(name)
- 11
- print(address)
- 12
- 13
- address="北京昌平沙河"
- 14
- variable
- /Users/alex/venv/bin/python /Users/alex/Documents/work/PyProjects/apeland_py_learn/day1/variable.py
- 小明
- Traceback (most recent call last):
- File "/Users/alex/Documents/work/PyProjects/apeland py learn/day1/variable.py"
- line 11,
- in <module>
- NameError: name'address' is not defined
- Process finished with exit code 1
<!-- OCR_END -->

**变量名定义规则**

1. 变量名只能是 字母、数字或下划线的任意组合
2. 变量名的第一个字符不能是数字
3. 以下关键字不能声明为变量名\[‘and’, ‘as’, ‘assert’, ‘break’, ‘class’, ‘continue’, ‘def’, ‘del’, ‘elif’, ‘else’, ‘except’, ‘exec’, ‘finally’, ‘for’, ‘from’, ‘global’, ‘if’, ‘import’, ‘in’, ‘is’, ‘lambda’, ‘not’, ‘or’, ‘pass’, ‘print’, ‘raise’, ‘return’, ‘try’, ‘while’, ‘with’, ‘yield’]

## **常用定义方式**

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

你觉得哪种更清晰，哪种就是官方推荐的，我想你肯定会先第2种

#### **定义变量不好的方式举例**

* 变量名为中文、拼音
* 变量名过长
* 变量名词不达意

## 变量的修改

自行看图不解释

<!-- OCR_START -->
- name =
- ：小明”
- age =
- 22
- height = 160
- = 25
- print(name,age)
- variable
- /Users/alex/venv/bin/python /Users/ale
- 小明25
- Process finished with exit code 0
<!-- OCR_END -->

## 常量

常量即指不变的量，如pai 3.141592653…, 或在程序运行过程中不会改变的量

举例，假如老男孩老师的年龄会变，那这就是个变量，但在一些情况下，他的年龄不会变了，那就是常量。在Python中没有一个专门的语法代表常量，程序员约定俗成用变量名全部大写代表常量

```plain
AGE_OF_OLDBOY = 56
```

> 在c语言中有专门的常量定义语法， `const int count = 60;` 一旦定义为常量，更改即会报错

# 1.7 注释

随着学习的深入，用不了多久，你就可以写复杂的上千甚至上万行的代码啦，有些代码你花了很久写出来，过了些天再回去看，发现竟然看不懂了，哈哈，这太正常了。 另外，你以后在工作中会发现，一个项目多是由几个甚至几十个开发人员一起做，你要调用别人写的代码，别人也要用你的，如果代码不加注释，你自己都看不懂，更别说别人了，这样写会挨打的。所以为了避免这种尴尬的事情发生，一定要增加你代码的可读性。

代码注释分单行和多行注释， 单行注释用`#`，多行注释可以用三对双引号`“”” “””`

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

1. 不用给全部代码加注释，只需要在自己觉得重要或不好理解的部分加注释即可
2. 注释可以用中文或英文，但绝对不要拼音噢
3. 注释不光要给自己看，还要给别人看，所以请认真写

# 1.8 基本数据类型

## 什么是数据类型？

我们人类可以很容易的分清数字与字符的区别，但是计算机并不能呀，计算机虽然很强大，但从某种角度上看又很傻，除非你明确的告诉它，1是数字，“汉”是文字，否则它是分不清1和‘汉’的区别的，因此，在每个编程语言里都会有一个叫数据类型的东东，其实就是对常用的各种数据类型进行了明确的划分，你想让计算机进行数值运算，你就传数字给它，你想让他处理文字，就传字符串类型给他。Python中常用的数据类型包括多种，今天我们暂只讲4种， 数字、字符串、布尔类型、列表。

## 数字

**int（整型）**

在64位系统上，整数的位数为64位，取值范围为-2**63～2**63-1，即-9223372036854775808～9223372036854775807

**long（长整型）**

跟C语言不同，Python的长整数没有指定位宽，即：Python没有限制长整数数值的大小，但实际上由于机器内存有限，我们使用的长整数数值不可能无限大。

注意，自从Python2.2起，如果整数发生溢出，Python会自动将整数数据转换为长整数，所以如今在长整数数据后面不加字母L也不会导致严重后果了。

> 注意：在Python3里不再有long类型了，全都是int

```plain
>>> a= 2**64
>>> type(a)  #type()是查看数据类型的方法
>>> b = 2**60
>>> type(b)
```

**float (浮点型)**

即小数

```plain
>>> type(2.32)
```

## 字符串

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

数字可以进行加减乘除等运算，字符串呢？让我大声告诉你，也能？what ?是的，但只能进行”相加”和”相乘”运算。

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
  File "", line 1, in 
TypeError: cannot concatenate 'str' and 'int' objects #错误提示数字 和 字符 不能拼接
```

## 布尔型(bool)

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

## 列表(List)

如果要把全班的人名在内存里存下来，用上面的字符串类型可以做到，但取的时候不方便。

```plain
names = "Alex,Jack,Rain,Rachel,Mack..."
```

你print(names)它打印的是所有人的信息，如果想取出Rain，没办法(可以用字符串切割方式，但是很麻烦)。此时，用列表就比较合适。

```plain
>>> names = ["Alex","Jack","Rain","Rachel","Mack"]
>>> names[2] #为何names[2]就能取出Rain?
'Rain'
```

因为列表的是通过下标来标记元素位置的。 下标从0开始，每添加一个元素，就自动+1

| 元素名 | Alex | Jack | Rain | Rachel | Mack |
| --- | --- | --- | --- | --- | --- |
| 下标(索引) | 0 | 1 | 2 | 3 | 4 |

### **元素添加**

元素的添加有2种方式，插入、追加，插入指可以插入到列表的任意位置

**插入**

```plain
>>> names
['Alex', 'Jack', 'Rain', 'Rachel', 'Mack']
>>> names.insert(3,"小明")  #3代表你想插入的位置
>>> names
['Alex', 'Jack', 'Rain', '小明', 'Rachel', 'Mack']
>>>
```

**追加**

添加到列表的尾部

```plain
>>> names
['Alex', 'Jack', 'Rain', '小明', 'Rachel', 'Mack']
>>> names.append("小强")
>>> names
['Alex', 'Jack', 'Rain', '小明', 'Rachel', 'Mack', '小强']
```

### **修改**

直接根据下标找到元素重新赋值即可

```plain
>>> names[0] = "金角大王Alex"
>>> names
['金角大王Alex', 'Jack', 'Rain', '小明', 'Rachel', 'Mack', '小强']
```

### **删除元素**

这个不是通过下标了，是根据元素名子。

```plain
>>> names
['金角大王Alex', 'Jack', 'Rain', '小明', 'Rachel', 'Mack', '小强']
>>> names.remove("小明")
>>> names
['金角大王Alex', 'Jack', 'Rain', 'Rachel', 'Mack', '小强']
```

上面的命令会删除从左开始找到的第一个小明， 如果有多个小明，则只删除找到的第一个。

### **判断元素是否在列表里**

```plain
>>> names
['金角大王Alex', 'Jack', 'Rain', 'Rachel', 'Mack', '小强']
>>> 
>>> "Mack" in names
True
```

# 1.9 读取用户指令

若你的程序要接收用户指令，可以用input语法：

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

结果输出

```plain
What is your name?Alex Li
How old are you?22
Where is your hometown?ShanDong
Hello  Alex Li your are  22 years old, you came from ShanDong
```

> 注意，input()方法接收的只是字符串，即使你输入的是数字，它也会按字符串处理

# 1.10 格式化打印

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

***%s就是代表字符串占位符，除此之外，还有%d,是数字占位符，%f是浮点数占位符， 如果把上面的age后面的换成%d，就代表你必须只能输入数字啦***

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
 #怎么会是str
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

# 1.11 运算符

计算机可以进行的运算有很多种，可不只加减乘除这么简单，运算按种类可分为算数运算、比较运算、逻辑运算、赋值运算、成员运算、身份运算、位运算，今天我们暂只学习算数运算、比较运算、逻辑运算、赋值运算

## 算数运算

以下假设变量：**a=10，b=20**

<!-- OCR_START -->
- 运算符
- 描述
- 实例
- 加－两个对象相加
- a+b输出结果 30
- 减－得到负数或是一个数减去另一个数
- a-b 输出结果-10
- 乘－两个数相乘或是返回一个被重复若干次的字符串
- a*b输出结果200
- 除-x除以y
- b/a输出结果 2
- 取模－返回除法的余数
- b % a 输出结果 0
- **
- 幂－返回x的y次幂
- a**b为10的20次方，输出结果100000000000000000000
- //
- 取整除－返回商的整数部分
- 9//2输出结果4，9.0//2.0输出结果4.0
<!-- OCR_END -->

## 比较运算

以下假设变量：**a=10，b=20**

<!-- OCR_START -->
- 运算符
- 描述
- 实例
- 等于－比较对象是否相等
- (a ==b)返回 False。
- !=
- 不等于－比较两个对象是否不相等
- (a != b) 返回 true.
- <V
- (a<>b)返回 true。这个运
- 算符类似！=。
- 大于－返回x是否大于y
- 小于－返回x是否小于y。所有比较运算符返回1表示真，返回0表示假。这分别与特殊的变量
- True和False等价。注意，这些变量名的大写。
- 大于等于－返回x是否大于等于y。
- ^=
- 小于等于－返回x是否小于等于y。
<!-- OCR_END -->

## 赋值运算

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

## 逻辑运算

以下假设变量：**a=10，b=20**

<!-- OCR_START -->
- 运算符
- 描述
- 实例
- and
- 判断多个条件均为真时，返回真
- a>10 and b > 10 结果为False
- or
- 判断多个条件任意条件为真时，返回真
- a>10or b>10结果为True
- not
- 取反
- not a > b 结果为True
<!-- OCR_END -->

# 1.12 流程控制之 if。。else

## 流程控制

假如把写程序比做走路，那我们到现在为止，一直走的都是直路，还没遇到过分叉口，想象现实中，你遇到了分叉口，然后你决定往哪拐必然是有所动机的。你要判断那条岔路是你真正要走的路，如果我们想让程序也能处理这样的判断怎么办？ 很简单，只需要在程序里预设一些条件判断语句，满足哪个条件，就走哪条岔路。这个过程就叫流程控制。

基本上在各个语言中，都是用语法if…else…来实现，可分为单分支、双分支、多分支

**单分支**

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

**双分支**

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

**缩进**

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

**多分支**

回到流程控制上来，if…else …可以有多个分支条件

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

这里有个问题，就是当我输入95的时候 ，它打印的结果是A,但是95 明明也大于第二个条件`elif score >=80:`呀, 为什么不打印B呢？**这是因为代码是从上到下依次判断，只要满足一个，就不会再往下走啦，这一点一定要清楚呀！**

# 1.13 流程控制之 while 循环

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

#### **语法**

```plain
while  条件:
    执行代码...
```

简单吧,`while`就是当的意思，当山峰没有棱角的时候，当河水。。。，sorry ,`while`指 当其后面的条件 成立 ，就执行`while`下面的代码

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

#### **死循环**

**有一种循环叫死循环，一经触发，就运行个天荒地老、海枯石烂。**

while 是只要后边条件成立(也就是条件结果为真)就一直执行，怎么让条件一直成立呢？

```plain
count = 0
while True: #True本身就是真呀
    print("你是风儿我是沙,缠缠绵绵到天涯...",count)
    count +=1
```

## 循环中止语句

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

## while … else ..

与其它语言else 一般只与if 搭配不同，在Python 中还有个while …else 语句

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

**练习2：猜年龄游戏升级版 (20分钟)**

要求：

1. 允许用户最多尝试3次
2. 每尝试3次后，如果还没猜对，就问用户是否还想继续玩，如果回答Y或y, 就继续让其猜3次，以此往复，如果回答N或n，就退出程序
3. 如果猜对了，就直接退出

# 1.14 本章练习题&作业

## 练习题:【练习题答案再页尾】

1. 简述编译型与解释型语言的区别，且分别列出你知道的哪些语言属于编译型，哪些属于解释型
2. Pyhton 单行注释和多行注释分别用什么?
3. 布尔值分别有什么，及作用是什么?
4. 声明变量注意事项有那些?
5. 如何查看变量在内存中的地址?
6. 请写出 and 、or、not 的作用，并用代码来演示
7. 查看2、2.22、“小猿圈”分别是什么数据类型的语法是什么？
8. 写代码
   1. \[ ] 实现用户输入用户名和密码,当用户名为 seven 且 密码为 123 时,显示登陆成功,否则登陆失败!
   2. \[ ] 实现用户输入用户名和密码,当用户名为 seven 且 密码为 123 时,显示登陆成功,否则登陆失败,失败时允许重复输入三次
   3. \[ ] 实现用户输入用户名和密码,当用户名为 seven 或 alex 且 密码为 123 时,显示登陆成功,否则登陆失败,失败时允许重复输入三次
9. 写代码
   1. 使用 while 循环实现输出 1,2,3,4,5, 7,8,9, 11,12
   2. 使用while 循环输出100-50，从大到小，如100，99，98…，到50时再从0循环输出到50，然后结束
   3. 使用 while 循环实现输出 1-100 内的所有奇数
   4. 使用 while 循环实现输出 1-100 内的所有偶数
   5. 使用while循环实现输出2-3+4-5+6…+100 的和
10. 现有如下两个变量,请根据执行结果解释原因

```plain
n1 = 123456
n2 = n1
n1 = 333
print(n1,n2)
```

1. 制作趣味模板程序（编程题）
   1. 需求：等待用户输入名字、地点、爱好，根据用户的名字和爱好进行任意显示
   2. 如：敬爱可爱的xxx，最喜欢在xxx地方干xxx
2. 输入一年份，判断该年份是否是闰年并输出结果。（编程题）
   1. 注：凡符合下面两个条件之一的年份是闰年。 （1） 能被4整除但不能被100整除。 （2） 能被400整除。
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

1. 一球从100米高度自由落下，每次落地后反跳回原高度的一半；再落下，求它在第10次落地时，共经过多少米？第10次反弹多高？

## 作业

**双色球彩票 选购程序**

1. 先让用户依次选择6个红球，再选择2个蓝球，最后统一打印用户选择的球号。
2. 确保用户不能选择重复的，选择的数不能超出范围。

作业：双色球选购

1 双色球（假设一共八个球，6个红球，球号1-32、2个蓝球，球号1-16）

2 确保用户不能重复选择，不能超出范围

3 用户输入有误时有相应的错误提示

4 最后展示用户选择的双色球的号码

要达到的结果参考

<!-- OCR_START -->
variable
/Users/alex/venv/bin/python/Users/alex/Documents/work/PyProjects/apelar
Welcome to小猿圈lottery station
[1]select red ball:5
[2]select red ball:34
only can select n between 1-32
[2]select red ball:23
[3]select red ball:4
[4]select red ball:23
number 23 is already exist in red ball list
[4]select red ball:7
2
[5]select red ball:4
number 4 is already exist in red ball list
[5]select red ball:2
[6]select red ball:9
[1]select blue ball:3
[2]select blue ball:77
only can select n between 1-16
number 3 is already exist in blue ball list
Red ball: [5, 23, 4, 7, 2, 9]
Blue ball: [3, 2]
Good Luck.
Process finished with exit code 0
<!-- OCR_END -->

```python
# 作业需求:
#
# 作业：双色球选购
# 1 双色球（假设一共八个球，6个红球，球号1-32、2个蓝球，球号1-16）
# 2 确保用户不能重复选择，不能超出范围
# 3 用户输入有误时有相应的错误提示
# 4 最后展示用户选择的双色球的号码
# 效果图：双色球作业展示
# 升级需求：
# 1 一个while循环

# red_ball = []
# blue_ball = []
# count = 1
# print('welcome to guess ball game > ')
# while count <= 8:
#     if count <= 6:  # 前6个数字进red_ball
#         inp_number = input(f'\033[1;31m[{count}]select red ball:')
#         if inp_number.isdigit():  # 判断是否可转为int类型
#             inp_number = int(inp_number)
#             if inp_number in red_ball:  # 判断是否已经存在
#                 print(f'\033[1;30mnumber{inp_number} is already exist in red ball list')
#             elif inp_number <= 32 and inp_number >= 1:  # 是否符合数字范围
#                 red_ball.append(inp_number)
#                 count += 1
#             else:
#                 print('\033[1;30monly can select between 1 - 32')
#         else:
#             print('\033[1;30monly can select between 1 - 32')
#     else:  # 进blue_ball
#         inp_number = input(f'\033[1;34m[{count - 6}]select blue ball:')
#         if inp_number.isdigit():
#             inp_number = int(inp_number)
#             if inp_number in blue_ball:
#                 print(f'number{inp_number} is already exist in blue ball list')
#             elif inp_number <= 16 and inp_number >= 1:
#                 blue_ball.append(inp_number)
#                 count += 1
#             else:
#                 print('\033[1;30monly can select between 1 - 16')
#         else:
#             print('\033[1;30monly can select between 1 - 32')
#
# print(f'\033[1;30mRed ball: {red_ball}')
# print(f'\033[1;30mblue ball: {blue_ball}')
# print('\033[1;30mgood luck.')

# 输出文字颜色 参考https://blog.csdn.net/qq_38962621/article/details/108038966

# 两个while 实现
red_ball = []
blue_ball = []
print('welcome to guess ball game > ')

while True:  # red while
    if len(red_ball) >= 6:
        break
    inp_number = input(f'\033[1;31m[{len(red_ball) + 1}]select red ball: ')
    if inp_number.isdigit():
        inp_number = int(inp_number)
        if inp_number in red_ball:
            print(f'number{inp_number} is already exist in red_ball list ')
        elif 1 <= inp_number and inp_number <= 32:
            red_ball.append(inp_number)
        else:
            print('only can select number betweet 1-32')
    else:
        print('only can select number betweet 1-32')

while True:  # blue while
    if len(blue_ball) >= 2:
        break
    inp_number = input(f'\033[1;34m[{len(blue_ball) + 1}] select blue ball: ')
    if inp_number.isdigit():
        inp_number = int(inp_number)
        if inp_number in blue_ball:
            print(f'number{inp_number} is already exist in blue_ball list ')
        elif 1 <= inp_number and inp_number <= 16:
            blue_ball.append(inp_number)
        else:
            print('only can select number betweet 1-16')
    else:
        print('only can select number betweet 1-32')

print(f'\033[1;30mRed ball: {red_ball}')
print(f'\033[1;30mblue ball: {blue_ball}')
print('\033[1;30mgood luck.')

```

练习题答案如下：

1 简述编译型与解释型语言的区别，且分别列出你知道的哪些语言属于编译型，哪些属于解释型。

```plain
编译型语言:
    x（源码） --> 编译 --> y（编译后的机器码）
    特点：执行速度快，将整个代码全部编译后再执行，但是跨平台比较差。
解释型语言:
    x（源码） --> 解释器（虚拟机） --> 解释执行
    特点：执行速度比较慢，因为逐行解释再执行，但是跨平台性好。
```

2 Pyhton 单行注释和多行注释分别用什么?

```plain
单行使用 
    # 我被注释了 
多行使用 
    """
    要注释的内容
    要被注释了吗
    """
```

3 布尔值分别有什么，及作用是什么?

```plain
布尔型只有两个值True和False，基本都是用于逻辑判断。
※布尔值实际上也属于整型，True相当于1，False相当于0
```

4 声明变量注意事项有那些?

```plain
1、变量名只能是 字母、数字和下划线的任意组合
2、变量名的第一个字符不能使数字
3、[and,print,as,not,or]等关键字不能作为变量名
4、变量名不能为中文、拼音；变量名单词不能过长：变量单词不达意
```

5 如何查看变量在内存中的地址?

```plain
id(变量名)
```

6 请写出 and 、or、not 的作用，并用代码来演示

```plain
and 、or、not 都是逻辑运算符
and：逻辑的与
>>> 1 and 1
1
>>> 1 and 0
0
or：逻辑的或
>>> 1 or 0
1
>>> 0 or 1
1
not：逻辑的非
>>> a = True
>>> not a
False
```

7 查看2、2.22、“路飞学城”分别是什么数据类型的语法是什么？

```plain
>>> type(2)
<class 'int'>
>>> type(2.22)
<class 'float'>
>>> type("路飞学城")
<class 'str'>
```

8 写代码

> 实现用户输入用户名和密码,当用户名为 seven 且 密码为 123 时,显示登陆成功,否则登陆失败!

```plain
username = "seven"
password = "123"
name = input(">>>:").strip()
passwd = input(">>>:").strip()
if name == username and passwd == password:
    print("登陆成功")
else:
    print("登陆失败")
```

```plain
实现用户输入用户名和密码,当用户名为 seven 且 密码为 123 时,显示登陆成功,否则登陆失败,失败时允许重复输入三次
```

```plain
username = "seven"
password = "123"
count = 0
while count < 3:
    name = input(">>>:").strip()
    passwd = input(">>>:").strip()
    if name == username and passwd == password:
        print("登陆成功")
        break
    else:
        print("登陆失败")
        count += 1
```

> 实现用户输入用户名和密码,当用户名为 seven 或 alex 且 密码为 123 时,显示登陆成功,否则登陆失败,失败时允许重复输入三次

```plain
username1 = "seven"
username2 = "alex"
password = "123"
count = 0
while count < 3:
    name = input(">>>:").strip()
    passwd = input(">>>:").strip()
    if name == username1 or name == username2 and passwd == password:
        print("登陆成功")
        break
    else:
        print("登陆失败")
        count += 1
```

9 写代码

> 使用 while 循环实现输出 1,2,3,4,5, 7,8,9, 11,12

```plain
count = 0
while count < 12:
    count += 1
    if count == 6 or count == 10:
        continue
    print(count)
```

> 使用while 循环输出100-50，从大到小，如100，99，98…，到50时再从0循环输出到50，然后结束

```plain
count = 100
while count > -2:
    if count >= 50:
        print(count)
    else:
        print(49-count)
    count -= 1
```

> 用 while 循环实现输出 1-100 内的所有奇数

```plain
count = 0
while count < 100:
    count+=1
    if count % 2 != 0:
        print(count)
```

> 用 while 循环实现输出 1-100 内的所有偶数

```plain
count = 0
while count < 100:
    count+=1
    if count % 2 == 0:
        print(count)
```

> 使用while循环实现输出2-3+4-5+6…+100 的和

```plain
count = 2
total = 0
while count <= 100:
    if count % 2 == 0:
        total += count
    else:
        total -= count
    count += 1
print(total)
```

10 现有如下两个变量,请根据执行结果解释原因

```plain
n1 = 123456
n2 = n1
n1 = 333
print(n1,n2)
n1等于123456，
将n1的值赋值给n2，此时，n1等于n2都等于123456，
n1=333，
n1等于333，n2还是123456
```

11 制作趣味模板程序（编程题）

> 需求：等待用户输入名字、地点、爱好，根据用户的名字和爱好进行任意显示

```plain
username = input("username>>>:").strip()
place = input("place>>>:").strip()
hobby = input(">>>:").strip()
print("敬爱可爱的%s，最喜欢在%s地方干%s" % (username, place, hobby))
```

12 输入一年份，判断该年份是否是闰年并输出结果。（编程题）

```plain
凡符合下面两个条件之一的年份是闰年。 
（1） 能被4整除但不能被100整除。 （2） 能被400整除。
while True:
    year = input("year>>>:").strip()
    if year.isdigit():
        year = int(year)
    else:
        print("请输入整数")
        continue
    if year % 4 ==0 and year % 100 != 0:
        print("是闰年")
    elif year % 400 == 0:
        print("是世纪闰年")
    else:
        print("不是闰年")
```

13 假设一年期定期利率为3.25%，计算一下需要过多少年，一万元的一年定期存款连本带息能翻番？（编程题）

```plain
year = 0
salary = 10000
rate = 0.0325
while salary < 20000:
    year += 1
    interest = salary*rate
    salary += interest
    print(year, interest, salary)
```

14 使用while,完成以下图形的输出

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

```plain
count = 0
while count < 10:
    count += 1
    if count <= 5:
        print(count * " * ")
    else:
        print((10 - count) * " * ")
```

15 一球从100米高度自由落下，每次落地后反跳回原高度的一半；再落下，求它在第10次落地时，共经过多少米？第10次反弹多高？

```plain
height = 100
times = 0
total = 0
while times < 10:
    times += 1
    new_height = height/2
    total += 2*new_height
    height = new_height
print(times, new_height, total+100)
```

> 更新: 2021-08-08 11:14:30  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/hxwxfu>