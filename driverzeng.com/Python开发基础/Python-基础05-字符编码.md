# Python-基础05-字符编码

## Python-基础05-字符编码
2019-04-26 分类：[Linux](https://www.driverzeng.com/zenglaoshi/category/linux), [Python](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80/python), [脚本语言](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80) 阅读(43) 评论(0)

+ [计算知识储备](https://www.driverzeng.com/zenglaoshi/1333.html#toc_0)
+ [字符编码介绍](https://www.driverzeng.com/zenglaoshi/1333.html#toc_1)
+ [字符编码之应用文件编辑器](https://www.driverzeng.com/zenglaoshi/1333.html#toc_2)
+ [字符编码应用程序之Python](https://www.driverzeng.com/zenglaoshi/1333.html#toc_3)

> -曾老湿, 江湖人称曾老大。
>
> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023
>

---

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1)整合了各个公有云API，自主创建云主机。
>
> 2)ELK自动化收集日志功能。
>
> 3)Saltstack自动化运维统一配置管理工具。
>
> 4)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6)SQL执行及审批流程。
>
> 7)慢查询日志分析web界面。
>

---

## 计算知识储备
| 计算机基础知识 |
| :--- |

<!-- OCR_START -->
- 应用程序任何操作硬件的请求，都需要向操作系统发送系
- 统调用的请求，然后由操作系统去操作硬件
- TheNiceBoyLikeMe
- CPU
- DriverZeng
- 存放notepad++数据
- 内存
- 存放操作系统数据
- 硬盘
<!-- OCR_END -->

￼

**文本编辑器存取文件原理（notepad++，pycharm，word）**

```plain
#1、打开编辑器就打开了启动了一个进程，是在内存中的，所以，用编辑器编写的内容也都是存放与内存中的，断电后数据丢失
#2、要想永久保存，需要点击保存按钮：编辑器把内存的数据刷到了硬盘上。
#3、在我们编写一个py文件（没有执行），跟编写其他文件没有任何区别，都只是在编写一堆字符而已。
```

**python解释器执行py文件的原理 ，例如python test.py**

```plain
#第一阶段：python解释器启动，此时就相当于启动了一个文本编辑器
#第二阶段：python解释器相当于文本编辑器，去打开test.py文件，从硬盘上将test.py的文件内容读入到内存中(小复习：pyhon的解释性，决定了解释器只关心文件内容，不关心文件后缀名)
#第三阶段：python解释器解释执行刚刚加载到内存中test.py的代码( ps：在该阶段，即真正执行代码时，才会识别python的语法，执行文件内代码，当执行到name="zls"时,会开辟内存空间存放字符串"zls")
```

**差异**

```plain
#1、相同点：python解释器是解释执行文件内容的，因而python解释器具备读py文件的功能，这一点与文本编辑器一样
#2、不同点：文本编辑器将文件内容读入内存后，是为了显示或者编辑，根本不去理会python的语法，而python解释器将文件内容读入内存后，可不是为了给你瞅一眼python代码写的啥，而是为了执行python代码、会识别python语法。
```

## 字符编码介绍
| 什么是字符编码 |
| :--- |

计算机要想工作必须通电,即用‘电’驱使计算机干活,也就是说‘电’的特性决定了计算机的特性。电的特性即高低电平(人类从逻辑上将二进制数1对应高电平,二进制数0对应低电平)，关于磁盘的磁特性也是同样的道理。结论：计算机只认识数字

很明显，我们平时在使用计算机时，用的都是人类能读懂的字符（用高级语言编程的结果也无非是在文件内写了一堆字符），如何能让计算机读懂人类的字符？

必须经过一个过程：

字符--------（翻译过程）------->数字

```plain
#如果只用1位定义 只能表示两个值
a   0
b   1
#两位还是不够
00
01
10
11
#所以一开始定义了8位
0000 0000
1111 1111 +1 -1
10000 0000
2**8 -1
255 + 0
256
#最早科学家用8位bit二进制数，表示一个字符
#但是中国人想要用计算机，ACSII表256位根本不够用
ASCII：1字节=1字符（英文）
GBK：2bytes=1中文字符，1B=1英文字符
2 ** 16 -1=65535
```

这个过程实际就是一个字符如何对应一个特定数字的标准，这个标准称之为字符编码

---

| 什么是字符编码 |
| :--- |

1、一个python文件中的内容是由一堆字符组成的，存取均涉及到字符编码问题（python文件并未执行，前两个阶段均属于该范畴）

2、python中的数据类型字符串是由一串字符组成的（python文件执行时，即第三个阶段）

---

| 字符编码的发展史与分类(了解) |
| :--- |

计算机由美国人发明，最早的字符编码为ASCII，只规定了英文字母数字和一些特殊字符与数字的对应关系。最多只能用 8 位来表示（一个字节），即：2**8 = 256，所以，ASCII码最多只能表示 256 个符号

<!-- OCR_START -->
- ASCII表
- American
- Standard Code
- for
- Information
- Interchange
- 美国标准信息交换代码
- 高四位
- ASCII控制字符
- ASCII打印字符
- 0001
- 0010
- 0011
- 0100
- 0101
- 0110
- 0111
- 3
- 十进
- 转义
- 字符解释
- 低四位
- 字符
- Ctrl
- NUL
- 空字符
- 16
- ^P
- DLE
- 数据链路转义
- 32
- 48
- 64
- 80
- 96
- 112
- 1
- ~A
- SOH
- 标题开始
- 17
- `Q
- DC1
- 设备控制1
- 33
- 49
- 65
- 81
- 97
- 113
- 2
- ^B
- STX
- 正文开始
- 18
- ^R
- DC2
- 设备控制
- 34
- 50
- 66
- 82
- 98
- 114
- ^C
- ETX
- 正文结束
- 19
- AS
- DC3
- 35
- 51
- 67
- 83
- 99
- 115
- 4
- ^D
- EOT
- 传输结束
- 20
- AT
- DC4
- 36
- 52
- 68
- 84
- 100
- 116
- 5
- ^E
- ENQ
- 查询
- 21
- ^U
- NAK
- 否定应答
- 37
- 53
- 69
- 85
- 101
- 117
- 6
- ^F
- ACK
- 肯定应答
- 22
- ^V
- SYN
- 同步空闲
- 38
- 54
- 70
- 86
- 102
- 118
- ^G
- BEL
- la
- 响铃
- 23
- ^W
- ETB
- 传输块结束
- 39
- 55
- 71
- 87
- 103
- b0
- 119
- 1000
- 8
- ^H
- BS
- 退格
- 24
- CAN
- 取消
- 40
- 56
- 72
- 88
- 104
- 120
- 1001
- HT
- 横向制表
- 25
- AY
- EM
- 介质结束
- 41
- 57
- 9
- 73
- 89
- 105
- 121
- 1010
- 10
- LF
- In
- 换行
- 26
- SUB
- 替代
- 42
- 58
- 74
- 90
- 106
- 122
- 1011
- 11
- ^K
- lv
- 纵向制表
- 27
- ESC
- le
- 43
- 59
- 75
- 91
- 107
- 123
- 1100
- 12
- FF
- 换页
- 28
- FS
- 文件分隔符
- 44
- 60
- 76
- 92
- 108
- 124
- 1101
- 13
- ^M
- CR
- 回车
- 29
- GS
- 组分隔符
- 45
- 61
- 77
- 93
- 109
- 125
- 1110
- SO
- 移出
- 30
- AA
- RS
- 记录分隔符
- 46
- 62
- 78
- 94
- 14
- 110
- 126
- 1111
- 移入
- 31
- US
- 单元分隔符
- 63
- 79
- 95
- 111
- 127
- Backspace
- SI
- 47
- 代码：DEL
- 注：
- 表中的ASCII字符可以用
- “Ait+小键ttos//wWw.driverzeng.com
- 2013/08/08
<!-- OCR_END -->

￼

当然我们编程语言都用英文没问题，ASCII够用，但是在处理数据时，不同的国家有不同的语言，日本人会在自己的程序中加入日文，中国人会加入中文。

而要表示中文，单拿一个字节表表示一个汉子，是不可能表达完的(连小学生都认识两千多个汉字)，解决方法只有一个，就是一个字节用>8位2进制代表，位数越多，代表的变化就多，这样，就可以尽可能多的表达出不通的汉字

所以中国人规定了自己的标准gb2312编码，规定了包含中文在内的字符－>数字的对应关系。

日本人规定了自己的Shift_JIS编码

韩国人规定了自己的Euc-kr编码（另外，韩国人说，计算机是他们发明的，要求世界统一用韩国编码，但世界人民没有搭理他们）

这时候问题出现了，精通18国语言的小周同学谦虚的用8国语言写了一篇文档，那么这篇文档，按照哪国的标准，都会出现乱码（因为此刻的各种标准都只是规定了自己国家的文字在内的字符跟数字的对应关系，如果单纯采用一种国家的编码格式，那么其余国家语言的文字在解析时就会出现乱码）

所以迫切需要一个世界的标准（能包含全世界的语言）于是unicode应运而生（韩国人表示不服，然后没有什么卵用）

ascii用1个字节（8位二进制）代表一个字符

unicode常用2个字节（16位二进制）代表一个字符，生僻字需要用4个字节

例：

字母x，用ascii表示是十进制的120，二进制0111 1000

汉字中已经超出了ASCII编码的范围，用Unicode编码是十进制的20013，二进制的01001110 00101101。

字母x，用unicode表示二进制0000 0000 0111 1000，所以unicode兼容ascii，也兼容万国，是世界的标准

这时候乱码问题消失了，所有的文档我们都使用但是新问题出现了，如果我们的文档通篇都是英文，你用unicode会比ascii耗费多一倍的空间，在存储和传输上十分的低效

本着节约的精神，又出现了把Unicode编码转化为“可变长编码”的UTF-8编码。UTF-8编码把一个Unicode字符根据不同的数字大小编码成1-6个字节，常用的英文字母被编码成1个字节，汉字通常是3个字节，只有很生僻的字符才会被编码成4-6个字节。如果你要传输的文本包含大量英文字符，用UTF-8编码就能节省空间：

| 字符 | ASCII | Unicode | UTF-8 |
| :--- | :--- | :--- | :--- |
| A | 01000001 | 00000000 01000001 | 01000001 |
| 中 | x | 01001110 00101101 | 11100100 10111000 10101101 |

从上面的表格还可以发现，UTF-8编码有一个额外的好处，就是ASCII编码实际上可以被看成是UTF-8编码的一部分，所以，大量只支持ASCII编码的历史遗留软件可以在UTF-8编码下继续工作。

---

| 总结字符编码的发展可分为三个阶段(重要) |
| :--- |

**阶段一：现代计算机起源于美国，最早诞生也是基于英文考虑的ASCII**

ASCII:一个Bytes代表一个字符（英文字符/键盘上的所有其他字符），1Bytes=8bit，8bit可以表示0-2**8-1种变化，即可以表示256个字符

ASCII最初只用了后七位，127个数字，已经完全能够代表键盘上所有的字符了（英文字符/键盘的所有其他字符），后来为了将拉丁文也编码进了ASCII表，将最高位也占用了

**阶段二:为了满足中文和英文，中国人定制了GBK**

GBK:2Bytes代表一个中文字符，1Bytes表示一个英文字符

为了满足其他国家，各个国家纷纷定制了自己的编码

日本把日文编到Shift_JIS里，韩国把韩文编到Euc-kr里

**阶段三：各国有各国的标准，就会不可避免地出现冲突，结果就是，在多语言混合的文本中，显示出来会有乱码。如何解决这个问题呢？？？**

**！！！！！！！！！！！！非常重要！！！！！！！！！！！！**

说白了乱码问题的本质就是不统一，如果我们能统一全世界，规定全世界只能使用一种文字符号，然后统一使用一种编码，那么乱码问题将不复存在，

ps：就像当年秦始皇统一中国一样，书同文车同轨，所有的麻烦事全部解决

很明显，上述的假设是不可能成立的。很多地方或老的系统、应用软件仍会采用各种各样的编码，这是历史遗留问题。于是我们必须找出一种解决方案或者说编码方案，需要同时满足：

**1、能够兼容万国字符**

**2、与全世界所有的字符编码都有映射关系，这样就可以转换成任意国家的字符编码**

这就是unicode（定长），　统一用2Bytes代表一个字符，　虽然2**16-1=65535，但unicode却可以存放100w+个字符，因为unicode存放了与其他编码的映射关系，准确地说unicode并不是一种严格意义上的字符编码表，下载pdf来查看unicode的详情：

链接:[https://pan.baidu.com/s/1ooEhiNK7q87G18vQShG53w](https://pan.baidu.com/s/1ooEhiNK7q87G18vQShG53w) 密码:4yra

很明显对于通篇都是英文的文本来说，unicode的式无疑是多了一倍的存储空间（二进制最终都是以电或者磁的方式存储到存储介质中的）

于是产生了UTF-8（可变长，全称Unicode Transformation Format），对英文字符只用1Bytes表示，对中文字符用3Bytes，对其他生僻字用更多的Bytes去存

**总结：内存中统一采用unicode，浪费空间来换取可以转换成任意编码（不乱码），硬盘可以采用各种编码，如utf-8，保证存放于硬盘或者基于网络传输的数据量很小，提高传输效率与稳定性。**

<!-- OCR_START -->
- 内存
- 文本编辑器输入英文字符口
- ASCII码二进制
- 很多地方或老的系统、应用软件仍会采用各种各样的编码，这是历史遗留问题。需要强调：
- 软件是存放于硬盘的，而运行软件是要将软件加载到内存的，面对硬盘中存放的各种编码的
- 硬盘
- 软件，想让我们的计算机能够将它们全都正常运行而不出现乱码，内存中必须有一种兼容万
- 国的编码，并且该编码需要与其他编码有相对应的映射/转换关系，这就是unicode
- cpu
- GBK码二进制
- unicode
- Shift_JIS码二进制
- Shift_JIS码的软件
- GBK码的软件
- Euc-kr码的软件
<!-- OCR_END -->

￼

基于目前的现状，内存中的编码固定就是unicode，我们唯一可变的就是硬盘的上对应的字符编码。

此时你可能会觉得，那如果我们以后开发软时统一都用unicode编码，那么不就都统一了吗，关于统一这一点你的思路是没错的，但我们不可会使用unicode编码来编写程序的文件，因为在通篇都是英文的情况下，耗费的空间几乎会多出一倍，这样在软件读入内存或写入磁盘时，都会徒增IO次数，从而降低程序的执行效率。因而我们以后在编写程序的文件时应该统一使用一个更为精准的字符编码utf-8（用1Bytes存英文，3Bytes存中文），再次强调，内存中的编码固定使用unicode。

1、在存入磁盘时，需要将unicode转成一种更为精准的格式，utf-8:全称Unicode Transformation Format，将数据量控制到最精简

2、在读入内存时，需要将utf-8转成unicode

所以我们需要明确：内存中用unicode是为了兼容万国软件，即便是硬盘中有各国编码编写的软件，unicode也有相对应的映射关系，但在现在的开发中，程序员普遍使用utf-8编码了，估计在将来的某一天等所有老的软件都淘汰掉了情况下，就可以变成：内存utf-8<->硬盘utf-8的形式了。

## 字符编码之应用文件编辑器
| notepad++ |
| :--- |

<!-- OCR_START -->
- new29-Notepad++[Administrator]
- 文件（F）编辑（E）搜索（S）视图（V）
- 编码（N）
- 语言（L）设置（T）工具（O）宏（M）运行（R）插件（P）窗口（W）？
- new22x
- 博客待整理.txt
- new24x
- new26×new27x
- day1.txt×new28×
- new29×
- 编码字符集
- 日文
- https://ww.driverzeng.com
- Normaltextfile
- ows(CRLF)
- Shift-JIS
- INS
<!-- OCR_END -->

￼

<!-- OCR_START -->
- *new29-Notepad++[Administrator]
- 文件(F）编辑（E）搜索（S）视图（V)编码（N）语言（L）设置（T）工具（O）宏（M）运行（R）插件（P）窗口（W)
- 4X
- 25
- 26X
- dayl.txtx
- new28x
- new29×
- 你瞅啥
- 何見
- 既有中文也有日文，但是文件编码用的是日文shif-JIS
- 保存文件
- Normal textfile
- dows(CR LF)
- Shift-JIS
- INS
<!-- OCR_END -->

￼

<!-- OCR_START -->
- C:\Users\Administrator\Desktop\字符编码测试.txt-Notepad++[Administrator]
- 文件（F)编辑（E）搜索（S）视图（V)编码（N）语言（L）设置（T）工具（O）宏（M）运行（R）插件（P)窗口（W)
- 口W
- new22×博客待整理.txt×
- new24×new25×new26x
- new27x
- dayl.txtx
- new28x
- 字符编码测试.txt
- ？??
- 重新打开，nodpad++默认选择了ANSI编码，文件就出现乱码
- 选择utf-8也乱码
- 那我们就选择日文编码看看效果如何
- Normal text file
- en
- /indows(CRLF)
- ANSI
- INS
<!-- OCR_END -->

￼

<!-- OCR_START -->
- C:\Users\Administrator\Desktop\字符编码测试.txt-Notepad++[Administrator]
- 文件（F）编辑（E）搜索（S）视图（V)编码（N）语言（L）设置（T）工具（O）宏（M）运行（R）插件（P）窗口（W）
- ew24x
- 28X
- 字符编码测试.txt
- ？??
- 何見
- 发现日文能正常显示，但是中文就出现乱码了
- Normal text file
- eng
- Windows(CRLF)
- Shift-JIS
- INS
<!-- OCR_END -->

￼

**乱码分析**

```plain
首先明确概念
#1、文件从内存刷到硬盘的操作简称存文件
#2、文件从硬盘读到内存的操作简称读文件
乱码的两种情况：
#乱码一：存文件时就已经乱码
存文件时，由于文件内有各个国家的文字，我们单以shiftjis去存，
本质上其他国家的文字由于在shiftjis中没有找到对应关系而导致存储失败
但当我们硬要存的时候，编辑并不会报错（难道你的编码错误，编辑器这个软件就跟着崩溃了吗？？？），但毫无疑问，不能存而硬存，肯定是乱存了，即存文件阶段就已经发生乱码
而当我们用shiftjis打开文件时，日文可以正常显示，而中文则乱码了
#用open模拟编辑器的过程
可以用open函数的write可以测试，f=open('a.txt','w',encodig='shift_jis'
f.write('你瞅啥\n何を見て\n') #'你瞅啥'因为在shiftjis中没有找到对应关系而无法保存成功，只存'何を見て\n'可以成功
#以任何编码打开文件a.txt都会出现其余两个无法正常显示的问题
f=open('a.txt','wb')
f.write('何を見て\n'.encode('shift_jis'))
f.write('你愁啥\n'.encode('gbk'))
f.write('你愁啥\n'.encode('utf-8'))
f.close()
#乱码二：存文件时不乱码而读文件时乱码
存文件时用utf-8编码，保证兼容万国，不会乱码，而读文件时选择了错误的解码方式，比如gbk，则在读阶段发生乱码，读阶段发生乱码是可以解决的，选对正确的解码方式就ok了，
```

---

| pycharm |
| :--- |

￼

￼

----

| python解释器 |
| :--- |

```plain
文件test.py以gbk格式保存，内容为：
　　x='林'
无论是
　　python2 test.py
还是
　　python3 test.py
都会报错（因为python2默认ascii，python3默认utf-8）
除非在文件开头指定#coding:gbk
```

---

| 总结 |
| :--- |

```plain
#1、保证不乱码的核心法则就是，字符按照什么标准而编码的，就要按照什么标准解码，此处的标准指的就是字符编码
#2、在内存中写的所有字符，一视同仁，都是unicode编码，比如我们打开编辑器，输入一个“你”，我们并不能说“你”就是一个汉字，此时它仅仅只是一个符号，该符号可能很多国家都在使用，根据我们使用的输入法不同这个字的样式可能也不太一样。只有在我们往硬盘保存或者基于网络传输时，才能确定”你“到底是一个汉字，还是一个日本字，这就是unicode转换成其他编码格式的过程了
```

unicode----->encode-------->utf-8

utf-8-------->decode---------->unicode

<!-- OCR_START -->
- 内存：unicode格式
- 读文件：decode
- 保存文件：encode
- 硬盘：utf-8格式
<!-- OCR_END -->

￼

**补充：**

浏览网页的时候，服务器会把动态生成的Unicode内容转换为UTF-8再传输到浏览器

如果服务端encode的编码格式是utf-8， 客户端内存中收到的也是utf-8编码的结果。

## 字符编码应用程序之Python
| 执行Python程序的三个阶段 |
| :--- |

python test.py （再强调一遍，执行test.py的第一步，一定是先将文件内容读入到内存中）

test.py文件内容以gbk格式保存的，内容为：

<!-- OCR_START -->
- test.py
- at
- 你好啊
- Data
- et
- PythonConsole
- >Terminal
- EventLog
- Platform andPlugin...(today22:15)
- n/a
- GBK
<!-- OCR_END -->

￼

阶段一：启动python解释器

阶段二：python解释器此时就是一个文本编辑器，负责打开文件test.py,即从硬盘中读取test.py的内容到内存中

```plain
此时，python解释器会读取test.py的第一行内容，#coding:utf-8，来决定以什么编码格式来读入内存，这一行就是来设定python解释器这个软件的编码使用的编码格式这个编码，
可以用sys.getdefaultencoding()查看，如果不在python文件指定头信息＃-*-coding:utf-8-*-,那就使用默认的
python2中默认使用ascii，python3中默认使用utf-8
```

<!-- OCR_START -->
- 首先报的是字符编码的错误

```text
C:WsersAdninistrator>
C:sersAdministrator>
C:UsersAdministratorpython2 E:CMSaaa\test.py
File "E:CMS\aaa\test.py", line 1
SyntaxError:
Non-ASCII character
xc4’in file E:\CMS\aaa\test-py on line 1, ehcoding declared;
http://python.org/dev/peps/pep-0263/fordetails
C:WsersAdministrator>
C:WsersAdministrator>
C:sersAdministrator>python3 E:<CMSaaa\test-py
File"E:\CMSVaaa\test.py", line 1
yntaxError:
Non-UTF-8 code
starting with'Vxc4’ in file E:\CMS\aaa\test-py on line
l,but noencoding declared;
see
http://python.org/deu/peps/pep-0263/fordetails
```
<!-- OCR_END -->

￼

改正：在test.py指定文件头，字符编码一定要为gbk，

<!-- OCR_START -->
C:sersAdministrator>python2 E:CMSaaatest-py
File"E:\CMSaaa\test-py",line 2
你好啊
SyntaxError:
invalid syntax
文件读取阶段的乱码问题已经解决，只剩下
python的语法问题，也仅仅只在执行阶段才会
C:VsersVAdministrator>
检测语法
C:WsersAdministrator>
C:sersAdministrator>python3 E:CMSaaatest-py
Traceback （most recent call last):
File"E:\CMSaaa\test-py".line 2,in<module>
NameError
name
'你子啊’isnotdefined
<!-- OCR_END -->

￼

阶段三：读取已经加载到内存的代码（unicode编码格式），然后执行，执行过程中可能会开辟新的内存空间，比如x="zls"

```plain
内存的编码使用unicode，不代表内存中全都是unicode，
在程序执行之前，内存中确实都是unicode,比如从文件中读取了一行x="zls",其中的x，等号，引号，地位都一样，都是普通字符而已，都是以unicode的格式存放于内存中的
但是程序在执行过程中，会申请内存（与程序代码所存在的内存是俩个空间）用来存放python的数据类型的值，而python的字符串类型又涉及到了字符的概念
比如x="zls",会被python解释器识别为字符串，会申请内存空间来存放字符串类型的值，至于该字符串类型的值被识别成何种编码存放，这就与python解释器的有关了，而python2与python3的字符串类型又有所不同。
```

---

| python2与python3字符串类型的区别 |
| :--- |

在python2中有两种字符串类型str和unicode

**str类型**

当python解释器执行到产生字符串的代码时（例如x='上'），会申请新的内存地址，然后将'上'编码成文件开头指定的编码格式

要想看x在内存中的真实格式，可以将其放入列表中再打印，而不要直接打印，因为直接print()会自动转换编码，这一点我们稍后再说。

```plain
#coding:gbk
x='上'
y='下'
print([x,y]) #['\xc9\xcf', '\xcf\xc2']
#\x代表16进制，此处是c9cf总共4位16进制数，一个16进制四4个比特位，4个16进制数则是16个比特位，即2个Bytes，这就证明了按照gbk编码中文用2Bytes
```

```plain
print(type(x),type(y)) #(<type 'str'>, <type 'str'>)
```

理解字符编码的关键！！！

内存中的数据通常用16进制表示，2位16进制数据代表一个字节，如\xc9，代表两位16进制，一个字节

gbk存中文需要2个bytes，而存英文则需要1个bytes，它是如何做到的？？？！！！

gbk会在每个bytes，即8位bit的第一个位作为标志位，标志位为1则表示是中文字符，如果标志位为0则表示为英文字符

```plain
x=‘你a好’
转成gbk格式二进制位
8bit+8bit+8bit+8bit+8bit=(1+7bit)+(1+7bit)+(0+7bit)+(1+7bit)+(1+7bit)
```

这样计算机按照从左往右的顺序读：

```plain
#连续读到前两个括号内的首位标志位均为1，则构成一个中午字符：你
#读到第三个括号的首位标志为0，则该8bit代表一个英文字符：a
#连续读到后两个括号内的首位标志位均为1，则构成一个中午字符：好
```

也就是说，每个Bytes留给我们用来存真正值的有效位数只有7位，而在unicode表中存放的只是这有效的7位，至于首位的标志位与具体的编码有关，即在unicode中表示gbk的方式为：

```plain
(7bit)+(7bit)+(7bit)+(7bit)+(7bit)
```

<!-- OCR_START -->
- GBK:'上'
- ====>`\xc9\xcf
- 第1个字节
- 第2个字节
- 十六进制
- 9
- 二进制
- 1100
- 1001
- 1 1 1 1
- 真实数据
- 100
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 4E09
- 1.2
- G0-487D
- HB1-A454
- T1-4435
- J0-3B30
- K0-5F32
- V1-4A26
- 4E0A
- G0-494F
- HB1-A457
- T1-4438
- JO-3E65
- K0-5F3E
- V1-4A27
- 4E0B
- G0-4F42
- HB1-A455
- T1-4436
- J0-323C
- K0-793B
- V1-4A28
- 4E0C
- G0-5822
- HB2-C946
- T2-2127
- J1-3024
- K2-2122
- 4E0D
- 1.3
- G0-323B
- HB1-A4A3
- T1-4462
- J0-4954
- K0-5C74
- V1-4A29
- s//www.driverzeng.c
- G0-536B
- HB2-C94F
- T2-212F
- JD-4D3F
- K2-2123
<!-- OCR_END -->

￼

可以看到“”上“”对应的gbk（G0代表的是gbk）编码就为494F，即我们得出的结果，而上对应的unicode编码为4E0A，我们可以将gbk-->decode-->unicode

```plain
#coding:gbk
x='上'.decode('gbk')
y='下'.decode('gbk')
print([x,y]) #[u'\u4e0a', u'\u4e0b']
```

**unicode类型**

当python解释器执行到产生字符串的代码时（例如s=u'林'），会申请新的内存地址，然后将'林'以unicode的格式存放到新的内存空间中，所以s只能encode，不能decode

```plain
#coding:gbk
x=u'上' #等同于 x='上'.decode('gbk')
y=u'下' #等同于 y='下'.decode('gbk')
print([x,y]) #[u'\u4e0a', u'\u4e0b']
```

```plain
print(type(x),type(y)) #(<type 'unicode'>, <type 'unicode'>)
```

**打印到终端**

对于print需要特别说明的是：

当程序执行时，比如

x='上' #gbk下，字符串存放为\xc9\xcf

print(x) #这一步是将x指向的那块新的内存空间（非代码所在的内存空间）中的内存，打印到终端，按理说应该是存的什么就打印什么,但打印\xc9\xcf，对一些不熟知python编码的程序员，立马就懵逼了，所以龟叔自作主张，在print(x)时，使用终端的编码格式，将内存中的\xc9\xcf转成字符显示，此时就需要终端编码必须为gbk，否则无法正常显示原内容：上

<!-- OCR_START -->
- #coding:gbk
- x='上’#[xc9\xcf’
- print
- （x）
- pycharm终端编码为utf-8，于是乱码
- aa
- https.//www.driverzeng.com
<!-- OCR_END -->

￼

<!-- OCR_START -->
- C:WsersAdministrator>
- C:sersVAdministrator>
- C:sersVAdministrator>python2 E:CMSaaaaa-py
- windows终端编码为gbk，于是可以正常显示
<!-- OCR_END -->

￼

对于unicode格式的数据来说，无论怎么打印，都不会乱码

<!-- OCR_START -->
- aa.py
- #coding:gbk
- x=u上’
- #[xc9xcf]
- print(x)
- unicode可以转换成任意编码，pycharm的终端是
- utf-8编码的也可以正常转换
- aa
<!-- OCR_END -->

￼

<!-- OCR_START -->
C:UsersAdministrator>
C:UsersVAdministrator>python2 E:CMSaaaVaa-py
C:sersAdministrator>
GBK终端也可以正常显示
<!-- OCR_END -->

￼

unicode这么好，不会乱码，那python2为何还那么别扭，搞一个str出来呢？python诞生之时，unicode并未像今天这样普及，很明显，好的东西你能看得见，龟叔早就看见了，龟叔在python3中将str直接存成unicode，我们定义一个str，无需加u前缀，就是一个unicode，屌不屌？

---

| 在python3 中也有两种字符串类型str和bytes |
| :--- |

str是unicode

```plain
#coding:gbk
x='上' #当程序执行时，无需加u，'上'也会被以unicode形式保存新的内存空间中,
print(type(x)) #<class 'str'>
#x可以直接encode成任意编码格式
print(x.encode('gbk')) #b'\xc9\xcf'
print(type(x.encode('gbk'))) #<class 'bytes'>
```

很重要的一点是：看到python3中x.encode('gbk') 的结果\xc9\xcf正是python2中的str类型的值,而在python3是bytes类型，在python2中则是str类型

于是我有一个大胆的推测：python2中的str类型就是python3的bytes类型，于是我查看python2的str()源码，发现

<!-- OCR_START -->
- 字符编码测试-py
- _builtin_.py x
- atxtx
- pass
- 查看bytes类型的源码
- bytes = str
- class classmethod(object):
<!-- OCR_END -->

￼

未经允许不得转载，欢迎技术交流，QQ：133411023：[DBA老司机带你删库到跑路.](https://www.driverzeng.com/) » [Python-基础05-字符编码](https://www.driverzeng.com/zenglaoshi/1333.html)

> 更新: 2019-05-28 15:18:20  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/yzv39m>