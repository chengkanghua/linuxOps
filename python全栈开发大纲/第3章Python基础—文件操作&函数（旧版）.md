# 第3章  Python基础—文件操作&函数（旧版）

# 3.1 上节适遗

# 3.2 三元运算

## 本节重点：

* 让学生掌握3元运算的使用及应用场景

> **本节时长需控制在5分钟内**

## 三元运算

三元运算又称三目运算，是对简单的条件语句的简写，如：

简单条件语句：

```plain
if 条件成立:
    val = 1
else:
    val = 2
```

改成三元运算：

```plain
val = 1 if 条件成立 else 2
```

# 3.3 字符编码转换

## 本节重点：

* 使学生掌握彻底掌握字符编码之前的转换关系
* 掌握 python2 vs python3上编码的区别
* 掌握python2和3上 bytes,str的区别

> **本节时长需控制在60分钟内**
>
> 注，本节有些地方可能不太容易理解，建议对照”第2章-字符编码转换“部分视频好好看2遍

## 编码回顾

在备编码相关的课件时，在知乎上看到一段关于Python编码的回答

<!-- OCR_START -->
Python编码为什么那么蛋疼？
刘志军
公众号：Python之禅
1243人赞同了该回答
一旦走上了编程之路，如果你不把编码问题搞清楚，那么它将像幽灵一般纠缠你整个职业生涯，各
种灵异事件会接鐘而来，挥之不去。只有充分发挥程序员死磕到底的精神你才有可能彻底摆脱编码
问题带来的烦恼，我第一次遇到编码问题是写JavaWeb相关的项目，一串字符从浏览器游离到应
用程序代码中，翻江倒海沉浸到数据库中，随时随地都有可能踩到编码的地雷。第二次遇到编码问
题就是学Python的时候，在爬取网页数据时，编码问题又出现了，当时我的心情是奔溃的，用时
下最ing的一句话就是：“我当时就懵逼了”。为了搞清字符编码，我们得从计算机的起源开始，计算
机中的所有数据，不论是文字、图片、视频、还是音频文件，本质上最终都是按照类似01010101
的数字形式存储的。我们是幸运的，我们也是不幸的，幸运的是时代赋予了我们都有机会接触计算
机，不幸的是，计算机不是我们国人发明的，所以计算机的标准得按美帝国人的习惯来设计，那么
最开始计算机是通过什么样的方式来表现字符的呢？这要从计算机编码的发展史说起。
<!-- OCR_END -->

这哥们的这段话说的太对了，搞Python不把编码彻底搞明白，总有一天它会猝不及防坑你一把。

不过感觉这哥们的答案并没把编码问题写明白，所以只好亲自动笔了。

折腾编码问题，有很多次，我以为自已明白了，最终发现，那只不过是自圆其说而已，这一次，终于100%确定，动笔即不再改！

看这篇文章前，你应该已经知道了为什么有编码，以及编码的种类情况

* ASCII 占1个字节，只支持英文
* GB2312 占2个字节，支持6700+汉字
* GBK GB2312的升级版，支持21000+汉字
* Shift-JIS 日本字符
* ks_c_5601-1987 韩国编码
* TIS-620 泰国编码

由于每个国家都有自己的字符，所以其对应关系也涵盖了自己国家的字符，但是以上编码都存在局限性，即：仅涵盖本国字符，无其他国家字符的对应关系。应运而生出现了万国码，他涵盖了全球所有的文字和二进制的对应关系。

* Unicode 2-4字节 已经收录136690个字符，并还在一直不断扩张中...

Unicode 起到了2个作用：

1. 直接支持全球所有语言，每个国家都可以不用再使用自己之前的旧编码了，用unicode就可以了。(就跟英语是全球统一语言一样)
2. unicode包含了跟全球所有国家编码的映射关系，为什么呢？后面再讲

Unicode解决了字符和二进制的对应关系，但是使用unicode表示一个字符，太浪费空间。例如：利用unicode表示“Python”需要12个字节才能表示，比原来ASCII表示增加了1倍。

由于计算机的内存比较大，并且字符串在内容中表示时也不会特别大，所以内容可以使用unicode来处理，但是存储和网络传输时一般数据都会非常多，那么增加1倍将是无法容忍的！！！

为了解决存储和网络传输的问题，出现了Unicode Transformation Format，学术名UTF，即：对unicode中的进行转换，以便于在存储和网络传输时可以节省空间!

* UTF-8： 使用1、2、3、4个字节表示所有字符；优先使用1个字符、无法满足则使增加一个字节，最多4个字节。英文占1个字节、欧洲语系占2个、东亚占3个，其它及特殊字符占4个。
* UTF-16： 使用2、4个字节表示所有字符；优先使用2个字节，否则使用4个字节表示。
* UTF-32： 使用4个字节表示所有字符。

总结：**UTF 是为unicode编码 设计 的一种 在存储 和传输时节省空间的编码方案。**

## 字符在硬盘上的存储

无论以什么编码在内存里显示字符，存到硬盘上都是2进制。

```plain
ascii编码(美国)：
    l   0b1101100
    o   0b1101111
    v   0b1110110
    e   0b1100101
GBK编码(中国)：
    老   0b11000000 0b11001111
    男   0b11000100 0b11010000
    孩   0b10111010 0b10100010
Shift_JIS编码(日本)：
    私   0b10001110 0b10000100
    は   0b10000010 0b11001101
ks_c_5601-1987编码(韩国)：
    나   0b10110011 0b10101010
    는   0b10110100 0b11000010
TIS-620编码(泰国)：
    ฉัน  0b10101001 0b11010001 0b10111001
...
```

```plain
要注意的是，存到硬盘上时是以何种编码存的，再从硬盘上读出来时，就必须以何种编码读，要不然就乱了。。
```

### 编码的转换

虽然国际语言是英语 ，但大家在自己的国家依然说自已的语言，不过出了国， 你就得会英语 编码也一样，虽然有了unicode and utf-8 ，但是由于历史问题，各个国家依然在大量使用自己的编码，比如中国的windows,默认编码依然是gbk,而不是utf-8。

基于此，如果中国的软件出口到美国，在美国人的电脑上就会显示乱码，因为他们没有gbk编码。

若想让中国的软件可以正常的在 美国人的电脑上显示，只有以下2条路可走：

1. 让美国人的电脑上都装上gbk编码
2. 把你的软件编码以utf-8编码

第1种方法几乎不可能实现，第2种方法比较简单。 但是也只能是针对新开发的软件。 如果你之前开发的软件就是以gbk编码的，上百万行代码可能已经写出去了，重新编码成utf-8格式也会费很大力气。

so , 针对已经用gbk开发完毕的项目，以上2种方案都不能轻松的让项目在美国人电脑上正常显示，难道没有别的办法了么？

有， 还记得我们讲unicode其中一个功能是其包含了跟全球所有国家编码的映射关系，意思就是，你写的是gbk的“路飞学城”,但是unicode能自动知道它在unicode中的“路飞学城”的编码是什么，如果这样的话，那是不是意味着，无论你以什么编码存储的数据，只要你的软件在把数据从硬盘读到内存里，转成unicode来显示，就可以了。由于所有的系统、编程语言都默认支持unicode，那你的gbk软件放到美国电脑上，加载到内存里，变成了unicode,中文就可以正常展示啦。

<!-- OCR_START -->
- U4E00unicode汉字表.pdf（page411of526）
- Q路
- Page Order
- Found on 1 page<>]Done
- atches
- 8DE8
- CJK Unified Ideographs
- 8E0F
- HB1-
- 9 K...
- HEX
- 8DFC
- 足157.6
- 足157.7
- GE-3F30
- 8DE9
- 8DFD
- G3-6FF
- V0-4465
- G0-7555
- HB2-E45B
- J14-7940
- 跪楚
- 跪登
- 悠翻叶
- 8DEA
- 8DFE
- G03972
- V1-684F
- 52-E4
- 分别是"路"在香港、台
- 8DFF
- 台湾
- 日8本EB
- 韩国、越南编码里的位置
- 8DEC
- 8E00
- tr
- 足15%
- G0-754D
- HB2-E069
- T2-476F
- J14-793D
- K1-5B42
- V1-6850
- GE-3F32
- 8DED
- 8E01
- G3-6F75
- 8DEE
- 8E02
- G3-F6D
- V0-445C
- 1
- K2-6362
- 8DEF
- 8E03
- Unicode位置
- GO0-4237
- HB1-B8F4
- T1-667B
- V1-6851
- 联時跆跳
- 联時
- 楚骏晦
- 8DF0
- 8E04
- 骏晦
- 哲骏嗨肺
- HB2-E067
- T247D
- G5-6E74
- 時跆跳
- 8DF1
- 8E05
- 对应的GBK编码
- 8DF2
- 跆路
- 8E06
- 位置
- 8DF3
- 8E07
- HB1-B8F5
- T1-667C
- K0-542F
- GE-3F34
- HB2-E45E
- G0-4C78
- V1-6852
- 8DF4
- 8E08
- GE-3F2F
- HB2-E073
- T2-4779
- J1-5F72
- K2-635B
- GE-3F35
- T3-497A
- JO-6C73
- K1-6475
- 8DF5
- 8E09
- 只白
<!-- OCR_END -->

这个表你自己也可以下载下来

unicode与gbk的映射表 <http://www.unicode.org/charts/>

## Python3的执行过程

在看实际代码的例子前，我们来聊聊，python3 执行代码的过程

1. 解释器找到代码文件，把代码字符串按文件头定义的编码加载到内存，转成unicode
2. 把代码字符串按照语法规则进行解释
3. 所有的变量字符都会以unicode编码声明

## 编码转换过程

实际代码演示，在py3上 把你的代码以utf-8编写， 保存，然后在windows上执行。

```plain
s = '路飞学城'
print(s)
```

<!-- OCR_START -->
r2-效i盾类型\病编码\py3_encode.py-
- Notepad+ +
语言(L)设置(T)工具(O)宏(M)运行(R)插件(P)窗口(W)
Py2.py
16to2.txtx
py3_encode.py
C:\Windows\system32\cmd.exe
C:4
选项
字体
布局
颜色
光标大小
○小(S)
中(M)
大(L)
Z:WsersalexDocumentsworkPyProjects\luffy_课
命令记录
编辑选项
马>python3 encode_py2-py
缓冲区大小（B）：
路飞学城
50
快速编辑模式Q)
缓中区数量（)：
4
插入模式（)
Z:sersValexDocumentsWworkPyProjects\luffy_课
丢弃旧的副本()
码>
当前代码页
Z:sersale
DocumentsworkPyProjects√luffy_课
936
(AHSI/OEM－简体中文GBK)
Z:WlsersValexDocumentsworkPyProjects\luffy_课
Z:sersMalexDocumentsworkPyProjects^luffy_课
WsersMalexDocumentsorkPyProjectsAluffy_i课
码>python3 py3_encode -py
确定
取消
ersalexlocumept
WorkPyProjects<luffy_课
<!-- OCR_END -->

so ,一切都很美好，到这里，我们关于编码的学习按说就可以结束了。

但是，如生活一样，美好的表面下，总是隐藏着不尽如人意，上面的utf-8编码之所以能在windows gbk的终端下显示正常，是因为到了内存里python解释器把utf-8转成了unicode , 但是这只是python3, 并不是所有的编程语言在内存里默认编码都是unicode,比如 万恶的python2 就不是， 它的默认编码是ASCII，想写中文，就必须声明文件头的coding为gbk or utf-8, 声明之后，python2解释器仅以文件头声明的编码去解释你的代码，加载到内存后，并不会主动帮你转为unicode,也就是说，你的文件编码是utf-8,加载到内存里，你的变量字符串就也是utf-8, 这意味着什么你知道么？。。。意味着，你以utf-8编码的文件，在windows是乱码。

<!-- OCR_START -->
py3_gbk.py∞
encode_py2.pyx
16to2.
pv3 ercode.pvx
冏大
coding:utf-8
81.
C:100mm0ows1aystem321cm0.ene
码>
Z:NsersalexDocumentsworkPyProjects\luffy_i课件2i天入
Z:WsersValexDocumentsWworkPyProjects\luffy_i课件2i天
"路飞
Z:lsersalexDocumentsworkPyProjects\luffy_课件2i天入
码>python3 py3_encode-py
路飞学城
print(s)
Z:VsersMalexDocumentsworkPyProjects√luffy_课件2i天A
Z:sersValexDocumentsworkPyProjects\luffy_课件2i天
码>python3 encode_py2-py
Z:NsersalexDocumentsWwork
yProjects\luffy_课件2i天入
码>python encode_py2-py
E:sersalexDocumentswork
半：
<!-- OCR_END -->

乱是正常的，不乱才不正常，因为只有2种情况 ，你的windows上显示才不会乱。

1. 字符串以GBK格式显示
2. 字符串是unicode编码

既然Python2并不会自动的把文件编码转为unicode存在内存里， 那就只能使出最后一招了，你自己人肉转。Py3 自动把文件编码转为unicode必定是调用了什么方法，这个方法就是，decode(解码) 和encode(编码)

```plain
UTF-8 --> decode 解码 --> Unicode
Unicode --> encode 编码 --> GBK / UTF-8 ..
```

**decode示例**

<!-- OCR_START -->
- encode_py2. pyX
- 16to2.txtx
- py3_encode. py
- coding:utf-8
- C:(\/Windows\system32\cmd.exe
- sersalexDocuments
- alexDocumen
- python3 encode_py2.
- "路飞学城
- alexDocuments
- workPyProjectsluff
- P9
- print(s)
- HserS
- PyProiects
- luff
- "rolects
- Lufi
- s2
- s.decode（'utf-8
- 1
- ype
- print
- type(s2)
<!-- OCR_END -->

**encode 示例**

<!-- OCR_START -->
- C:(Windows\system32\cmd.exe
- 口回
- coding:utf-8
- Z:WsersalexDocumentsworkPyProjects\luffy_课件21天
- 门chapter2-数据类型编码>
- 21大
- chapter2-3
- ："路飞学城"
- p9
- 飞学城
- print(s)
- Ktype
- 'unicode'>
- "str">
- s2 = s.decode（'utf-8'
- alexDocuments\workPyProjects\luffy_课件21天入门chapter2-数据类型编码>
- print
- :S2
- : type(s2)
- S3
- s2.encode("GBK")·
- 把unicode编码成gbk
- type(s3).
- encode之后编码变成了str
- 可以正常显示
<!-- OCR_END -->

记住下图规则

<!-- OCR_START -->
- Unicode
- decode
- encode
- encode编码
- decode 解码
- 编码
- 解码
- GBK中文编码
- Shift-JIS日本编码
<!-- OCR_END -->

## 如何验证编码转对了呢？

1. 查看数据类型，python 2 里有专门的unicode 类型
2. 查看unicode编码映射表

unicode字符是有专门的unicode类型来判断的，但是utf-8,gbk编码的字符都是str,你如果分辨出来的当前的字符串数据是何种编码的呢？ 有人说可以通过字节长度判断，因为utf-8一个中文占3字节，gbk一个占2字节。

<!-- OCR_START -->
encode_py2.pyx
16to2.txt
py3_encode.pyx
coding:utf-8
2
3
K"
4
5
S2
S.decode('utf-8')
#unicode
6
S3
s2.encode("GBK")
print(s3,s)
10
C:\Window
s\system32\cmd.
Z:VlsersVa
lexDocuments
rk^PyProjects^luffy.
chapter2
编码>
21
Z:Vlsers
lexDocumentswo
kPyProjects√luffy_课
chapter2-委文据
Z:Vsers
PyProjects√luffy_课件2i天入
- py
（xc2xb7xb7xc9
xe8xb7xafxe9xa3x9e)
课件21天入门vchapter2-数据类型√编码>
alexDocumentswork^PyProj
ects^luffy_i
GBK 4字节
UTF-86字节
python encode_py2
<!-- OCR_END -->

靠上面字节个数，虽然也能大体判断是什么类型，但总觉得不是很专业。

怎么才能精确的验证一个字符的编码呢，就是拿这些16进制的数跟编码表里去匹配。

“路飞学城”的unicode编码的映射位置是 u'\u8def\u98de\u5b66\u57ce' ，‘\u8def’ 就是‘路’，到表里搜一下。

“路飞学城”对应的GBK编码是'\xc2\xb7\xb7\xc9\xd1\xa7\xb3\xc7' ，2个字节一个中文，"路" 的二进制 "\xc2\xb7"是4个16进制，正好2字节，拿它到unicode映射表里对一下， 发现是G0-4237，并不是\xc2\xb7呀。。。擦。演砸了吧。。

<!-- OCR_START -->
- G3-6F6D
- HB2-E06B
- T2-4771
- K2-6358
- 8DEF
- 足157.6
- G0-4237
- HB1-B8F4
- T1-667B
- J0-4F29
- K0-5658
<!-- OCR_END -->

再查下“飞” \u98de ，对应的是G0-3749， 跟\xb7\xc9也对不上。

<!-- OCR_START -->
- GL-434B
- 13-6220
- 98DE
- 飞183'.0
- G0-3749
- H-8BF1
<!-- OCR_END -->

虽然对不上， 但好\xc2\xb7 和G0-4237中的第2位的2和第4位的7对上了，“飞”字也是一样，莫非巧合？

把他们都转成2进制显示试试

```plain
路
C               2
8   4   2   1   8   4   2   1
<strong>1   1   0   0   0   0   1   0</strong>
B               7
8   4   2   1   8   4   2   1
<strong>1   0   1   1   0   1   1   1</strong>
飞
B               7
8   4   2   1   8   4   2   1
1   0   1   1   0   1   1   1
C               9
8   4   2   1   8   4   2   1
1   1   0   0   1   0   0   1
```

这个“路”还是跟G0-4237对不上呀，没错， 但如果你把路\xc2\xb7的每个二进制字节的左边第一个bit变成0试试呢， 我擦，加起来就真的是4237了呀。。难道又是巧合？？？

必然不是，是因为，GBK的编码表示形式决定的。。因为GBK编码在设计初期就考虑到了要兼容ASCII,即如果是英文，就用一个字节表示，2个字节就是中文，但如何区别连在一起的2个字节是代表2个英文字母，还是一个中文汉字呢？ 中国人如此聪明，决定，2个字节连在一起，如果每个字节的第1位(也就是相当于128的那个2进制位)如果是1，就代表这是个中文，这个首位是128的字节被称为高字节。 也就是2个高字节连在一起，必然就是一个中文。 你怎么如此笃定？因为0-127已经表示了英文的绝大部分字符，128-255是ASCII的扩展表，表示的都是极特殊的字符，一般没什么用。所以中国人就直接拿来用了。

问：那为什么上面 "\xc2\xb7"的2进制要把128所在的位去掉才能与unicode编码表里的G0-4237匹配上呢？

这只能说是unicode在映射表的表达上直接忽略了高字节，但真正映射的时候 ，肯定还是需要用高字节的哈。

### Python bytes类型

在python 2 上写字符串

```plain
>>> s = "路飞"
>>> print s
路飞
>>> s
'\xe8\xb7\xaf\xe9\xa3\x9e'
```

虽说打印的是路飞，但直接调用变量s，看到的却是一个个的16进制表示的二进制字节，我们怎么称呼这样的数据呢？直接叫二进制么？也可以， 但相比于010101，这个数据串在表示形式上又把2进制转成了16进制来表示，这是为什么呢？ 哈，为的就是让人们看起来更可读。我们称之为bytes类型，即字节类型， 它把8个二进制一组称为一个byte,用16进制来表示。 　

说这个有什么意思呢？

想告诉你一个事实， 就是，python2的字符串其实更应该称为字节串。 通过存储方式就能看出来， 但python2里还有一个类型是bytes呀，难道又叫bytes又叫字符串？ 嗯 ，是的，在python2里，bytes == str ， 其实就是一回事。

除此之外呢， python2里还有个单独的类型是unicode , 把字符串解码后，就会变成unicode

```plain
>>> s
'\xe8\xb7\xaf\xe9\xa3\x9e' #utf-8
>>> s.decode('utf-8')
u'\u8def\u98de' #unicode 在unicode编码表里对应的位置
>>> print(s.decode('utf-8'))
路飞 #unicode 格式的字符
```

由于Python创始人在开发初期认知的局限性，其并未预料到python能发展成一个全球流行的语言，导致其开发初期并没有把支持全球各国语言当做重要的事情来做，所以就轻佻的把ASCII当做了默认编码。 当后来大家对支持汉字、日文、法语等语言的呼声越来越高时，Python于是准备引入unicode,但若直接把默认编码改成unicode的话是不现实的， 因为很多软件就是基于之前的默认编码ASCII开发的，编码一换，那些软件的编码就都乱了。所以Python 2 就直接 搞了一个新的字符类型，就叫unicode类型，比如你想让你的中文在全球所有电脑上正常显示，在内存里就得把字符串存成unicode类型。

```plain
>>> s = "路飞"
>>> s
'\xe8\xb7\xaf\xe9\xa3\x9e'
>>> s2 = s.decode("utf-8")
>>> s2
u'\u8def\u98de'
>>> type(s2)
<type 'unicode'>
```

时间来到2008年，python发展已近20年，创始人龟叔越来越觉得python里的好多东西已发展的不像他的初衷那样，开始变得臃肿、不简洁、且有些设计让人摸不到头脑，比如unicode 与str类型，str 与bytes类型的关系，这给很多python程序员造成了困扰。

龟叔再也忍不了，像之前一样的修修补补已不能让Python变的更好，于是来了个大变革，Python3横空出世，不兼容python2,python3比python2做了非常多的改进，其中一个就是终于把字符串变成了unicode,文件默认编码变成了utf-8,这意味着，只要用python3,无论你的程序是以哪种编码开发的，都可以在全球各国电脑上正常显示，真是太棒啦！

PY3 除了把字符串的编码改成了unicode, 还把str 和bytes 做了明确区分， str 就是unicode格式的字符， bytes就是单纯二进制啦。

<!-- OCR_START -->
it[Alexs-MacBook-Pro:chapter3-文件操作 与 函 数 alex$ python3
Python 3.6.1 (v3.6.1:69c0db5050, Mar 21 2017, 01:21:04)
[GCC 4.2.1 (Apple Inc. build 5666) (dot 3)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
vvv
[>>> S = "路 飞"
[>>> type(s)
py3 str = py2 unicode
<class 'str';
[>>> s.encode("gbk")
b'\xc2\xb7\xb7\xc9'
py3的bytes就是bytes,不在与str傻傻分不清啦
<!-- OCR_END -->

最后一个问题，为什么在py3里，把unicode编码后，字符串就变成了bytes格式？ 你直接给我直接打印成gbk的字符展示不好么？我想其实py3的设计真是煞费苦心，就是想通过这样的方式明确的告诉你，想在py3里看字符，必须得是unicode编码，其它编码一律按bytes格式展示。

好吧，就说这么多吧。

最后再提示一下，Python只要出现各种编码问题，无非是哪里的编码设置出错了

常见编码错误的原因有：

* Python解释器的默认编码
* Python源文件文件编码
* Terminal使用的编码
* 操作系统的语言设置 掌握了编码之前的关系后，挨个排错就好啦　

# 3.4 文件处理

## 本节重点：

* 使学生掌握文件的读、写、修改方法
* 掌握文件处理模式的区别

> **本节时长需控制在50分钟内**

## 引子

1.问题：给你一个文件 "兼职白领学生空姐模特护士联系方式.txt" ，如何查看内容？

答：

1. 安装文本编辑器软件
2. 选中右键，利用文本编辑器软件打开
3. 查看 or 写入
4. 保存，关闭

> PS: 看到居然还有xxx的女朋友 或 美好的事物应该分享，默默的把xxx的女朋友电话也写进去

2.问题：文件在硬盘上是如何存储？

答：以某种编码格式的 “010101010101001” 保存在硬盘上。

3.问题：假定世上无文本编辑器软件，如何使用Python对文件进行操作？

答：请看下面

## Python处理文件

文件操作分为读、写、修改，我们先从读开始学习

#### 读文件

**示例1：**

```plain
f = open(file='D:/工作日常/兼职白领学生空姐模特护士联系方式.txt',mode='r',encoding='utf-8')
data = f.read()
f.close()
```

上述操作语法解释：

```plain
file='D:/工作日常/兼职白领学生空姐模特护士联系方式.txt'  表示文件路径
mode='r'                                          表示只读（可以修改为其他）
encoding='utf-8'                                  表示将硬盘上的 0101010 按照utf-8的规则去“断句”，再将“断句”后的每一段0101010转换成unicode的 01010101，unicode对照表中有01010101和字符的对应关系。
f.read()                                          表示读取所有内容，内容是已经转换完毕的字符串。
f.close()                                         表示关闭文件
```

> PS: 此处的encoding必须和文件在保存时设置的编码一致，不然“断句”会不准确从而造成乱码。

**示例2：**

```plain
f = open(file='D:/工作日常/兼职白领学生空姐模特护士联系方式.txt',mode='rb')
data = f.read()
f.close()
```

上述操作语法解释：

```plain
file='D:/工作日常/兼职白领学生空姐模特护士联系方式.txt'      表示文件路径
mode='rb'                                            表示只读（可以修改为其他）
f.read()                                             表示读取所有内容，内容是硬盘上原来以某种编码保存的 010101010，即：某种编码格式的字节类型
f.close()                                            表示关闭文件
```

问：示例2和示例1的区别在哪？

答：在于示例2打开文件时并未指定encoding,这是为何？是因为直接以rb模式打开了文件 ，rb是指二进制模式，数据读到内存里直接是bytes格式，如果想内容，还需要手动decode,因此在文件打开阶段，不需要指定编码

问：假如你不知道你要处理的文件是什么编码可怎么办呢？

```plain
import chardet
f = open('log',mode='rb')
data = f.read()
f.close()
result = chardet.detect(open('log',mode='rb').read())
print(result)
```

输出：

```plain
{'encoding': 'GB2312', 'confidence': 0.99, 'language': 'Chinese'}
```

> **注意：**
>
> * 文件操作时，以 “r”或“rb” 模式打开，则只能读，无法写入；
> * 硬盘上保存的文件都是某种编码的0101010，打开时需要注意：
>   * rb，直接读取文件保存时原生的0101010，在Python中用字节类型表示
>   * r和encoding，读取硬盘的0101010，并按照encoding指定的编码格式进行断句，再将“断句”后的每一段0101010转换成unicode的 010101010101，在Python中用字符串类型表示

#### 循环文件

```plain
f = open("兼职白领学生空姐模特护士联系方式.txt",'r',encoding="utf-8")
for line in f:
    print(line)
f.close()
```

#### 写文件

```plain
f = open(file='D:/工作日常/兼职白领学生空姐模特护士联系方式.txt',mode='w',encoding='utf-8')
f.write('北大本科美国留学一次50，微信号：xxxxx')
f.close()
```

上术操作语法解释：

```plain
file='D:/工作日常/兼职白领学生空姐模特护士联系方式.txt'     表示文件路径
mode='w'                                             表示只写
encoding='utf-8'                                     将要写入的unicode字符串编码成utf-8格式
f.write(...)                                         表示写入内容，写入的内容是unicode字符串类型，内部会根据encoding转换为制定编码的 01101010101，即：字节类型
f.close()
```

二进制写

```plain
f = open(file='D:/工作日常/兼职白领学生空姐模特护士联系方式.txt',mode='wb')
f.write('北大本科美国留学一次50，微信号：xxxxx'.encode('utf-8'))
f.close()
```

上述操作语法解释：

```plain
file='D:/工作日常/兼职白领学生空姐模特护士联系方式.txt'      表示文件路径
mode='wb'                                             表示只以2进制模式写
f.write(...)                                          表示写入内容，写入的内容必须字节类型，即：是某种编码格式的0101010
f.close()
```

> **注意：**
>
> 文件操作时，以 “w”或“wb” 模式打开，则只能写，并且在打开的同时会先将内容清空。
>
> 写入到硬盘上时，必须是某种编码的0101010，打开时需要注意：
>
> * wb，写入时需要直接传入以某种编码的0100101，即：字节类型
> * w 和 encoding，写入时需要传入unicode字符串，内部会根据encoding制定的编码将unicode字符串转换为该编码的 010101010

#### 追加

把内容追加到文件尾部

```plain
f = open("兼职白领学生空姐模特护士联系方式.txt",'a',encoding="gbk")
f.write("\n杜姗姗 北京  167 49 13324523342")
f.close()
```

运行结果

```plain
姓名        地区    身高    体重    电话
况咏蜜     北京    171    48    13651054608
......
岳妮妮     深圳    177    54    18835324553
贺婉萱     深圳    174    52    18933434452
叶梓萱    上海    171    49    18042432324
杜姗姗 北京  167 49 13324523342   #这行是添加的
```

> **注意：**
>
> 文件操作时，以 “a”或“ab” 模式打开，则只能追加，即：在原来内容的尾部追加内容
>
> 写入到硬盘上时，必须是某种编码的0101010，打开时需要注意：
>
> * ab，写入时需要直接传入以某种编码的0100101，即：字节类型
> * a 和 encoding，写入时需要传入unicode字符串，内部会根据encoding制定的编码将unicode字符串转换为该编码的 010101010

#### 读写模式

打开模式只有只读、只写、只追加，难道没有可以读写的操作吗？当然有

**读写模式**

```plain
f = open("兼职白领学生空姐模特护士联系方式.txt",'r+',encoding="gbk")
data = f.read() #可以读内容 
print(data)
f.write("\nblack girl  河北  167 50  13542342233") #可以写
f.close()
```

但上面的内容写到哪个位置了呢？答案是追加到了最后面。

那如果是我想添加到任意位置呢？答案是可以，又是不可以。。。。，为啥，一会就学

写读模式

```plain
f = open("兼职白领学生空姐模特护士联系方式.txt",'w+',encoding="gbk")
data = f.read() 
print(data)
f.write("\nnewline 1哈哈")
f.write("\nnewline 2哈哈")
f.write("\nnewline 3哈哈")
f.write("\nnewline 4哈哈")
print("content",f.read())
f.close()
```

输出

```plain
#注意这是个空行， 是上面print(data)的结果，代表 根本 没读到内容
content  #从这开始，读到的是刚写入的内容
newline 1哈哈
newline 2哈哈
newline 3哈哈
newline 4哈哈
```

此时查看文件 内容 发现，里面只有4条newline..内容，之前的旧内容全没了，事实代表，w+会先把文件清空，再写新内容，相比w模式，只是支持了一个读功能，且还只能读已经写入的新内容。着实没什么卵用。。。

#### 文件操作的其它功能

```plain
def fileno(self, *args, **kwargs): # real signature unknown
        返回文件句柄在内核中的索引值，以后做IO多路复用时可以用到
    def flush(self, *args, **kwargs): # real signature unknown
        把文件从内存buffer里强制刷新到硬盘
    def readable(self, *args, **kwargs): # real signature unknown
        判断是否可读
    def readline(self, *args, **kwargs): # real signature unknown
        只读一行，遇到\r or \n为止
    def seek(self, *args, **kwargs): # real signature unknown
        把操作文件的光标移到指定位置
        *注意seek的长度是按字节算的， 字符编码存每个字符所占的字节长度不一样。
        如“路飞学城” 用gbk存是2个字节一个字，用utf-8就是3个字节，因此以gbk打开时，seek(4) 就把光标切换到了“飞”和“学”两个字中间。
        但如果是utf8,seek(4)会导致，拿到了飞这个字的一部分字节，打印的话会报错，因为处理剩下的文本时发现用utf8处理不了了，因为编码对不上了。少了一个字节
    def seekable(self, *args, **kwargs): # real signature unknown
        判断文件是否可进行seek操作
    def tell(self, *args, **kwargs): # real signature unknown
        返回当前文件操作光标位置 
    def truncate(self, *args, **kwargs): # real signature unknown
        按指定长度截断文件
        *指定长度的话，就从文件开头开始截断指定长度，不指定长度的话，就从当前位置到文件尾部的内容全去掉。
    def writable(self, *args, **kwargs): # real signature unknown
        判断文件是否可写
```

每个都举例试一下。

现在提出一个萦绕心头的问题，文件内容是否可修改？当然可以，但需要套路

#### 修改文件

尝试直接以r+模式打开文件，默认会把新增的内容追加到文件最后面。但我想要的是修改中间的内容 ，怎么办？ 为什么会把内容添加到尾部呢？(最新测试r+会从头覆盖，测试代码如下)

```plain
f1 = open("luffy.txt",'w',encoding="utf-8")
f1.write("[路飞学城]")
f1.close()
f = open("luffy.txt",'r+',encoding="utf-8")
f.write("alex")
f.close()
```

我们已经学了seek,现在告诉你，之所以内容会追加到最后面，是因为，文件一打开，要写的时候，光标会默认移到文件尾部，再开始写。 现在我想修改中间部分，是不是seek(中间位置)再写就可以了呢？

```plain
f = open("兼职白领学生空姐模特护士联系方式utf8.txt",'r+',encoding="utf-8")
f.seek(6)
f.write("[路飞学城]")
f.close()
```

执行没报错，开心，看输出

```plain
王心[路飞学城]9    46    13813234424
马纤羽     深圳    173    50    13744234523
乔亦菲     广州    172    52    15823423525
罗梦竹     北京    175    49    18623423421
刘诺涵     北京    170    48    18623423765
岳妮妮     深圳    177    54    18835324553
贺婉萱     深圳    174    52    18933434452
叶梓萱    上海    171    49    18042432324
杜姗姗 北京  167 49 13324523342
black girl  河北  167 50  13542342233
```

确实从第3个字开始改的，但是我擦，好像我的\[路飞学城] 把后面的内容覆盖啦。。。。，这不是我想要的呀。。。

**问：为什么这样子？**

这是硬盘的存储原理导致的，当你把文件存到硬盘上，就在硬盘上划了一块空间，存数据，等你下次打开这个文件 ，seek到一个位置，每改一个字，就是把原来的覆盖掉，如果要插入，是不可能的，因为后面的数据在硬盘上不会整体向后移。所以就出现 当前这个情况 ，你想插入，却变成了会把旧内容覆盖掉。

**问：但是人家word, vim 都可以修改文件 呀，你这不能修改算个什么玩意？**

我并没说就不能修改了，你想修改当然可以，就是不要在硬盘上修改，把内容全部读到内存里，数据在内存里可以随便增删改查，修改之后，把内容再全部写回硬盘，把原来的数据全部覆盖掉。vim word等各种文本编辑器都是这么干的。

**问：说的好像有道理，但你又没看过word软件的源码，你凭什么这么笃定？**

哈哈，我不需要看源码，硬盘 的存储原理决定了word必须这么干 ，不信的话，还有个简单的办法来确认我说的，就是用word or vim读一个编辑一个大文件 ，至少几百MB的，你 会发现，加载过程会花个数十秒，这段时间干嘛了？ cpu 去玩了？去上厕所啦？ 当然不是，是在努力把数据 从硬盘上读到内存里。

**问：但是文件如果特别大，比如5个GB,读到内存，就一下子吃掉了5GB内存，好费资源呀，有没有更好的办法呢？**

如果不想占内存，只能用另外一种办法啦，就是边读边改， 什么意思？ 不是不能改么？是不能改原文件 ，但你可以打开旧文件 的同时，生成一个新文件呀，边从旧的里面一行行的读，边往新的一行行写，遇到需要修改就改了再写到新文件 ，这样，在内存里一直只存一行内容。就不占内存了。 但这样也有一个缺点，就是虽然不占内存 ，但是占硬盘，每次修改，都要生成一份新文件，虽然改完后，可以把旧的覆盖掉，但在改的过程中，还是有2份数据 的。

**问：还有更好的方式 么？**

有完没完？ 没了。

**占硬盘方式的文件修改代码示例**

```plain
f_name = "兼职白领学生空姐模特护士联系方式utf8.txt"
f_new_name = "%s.new" % f_name
old_str = "乔亦菲"
new_str = "[乔亦菲 Yifei Qiao]"
f = open(f_name,'r',encoding="utf-8")
f_new = open(f_new_name,'w',encoding="utf-8")
for line in f:
    if old_str in line:
        new_line = line.replace(old_str,new_str)
    else:
        new_line = line
    f_new.write(new_line)
f.close()
f_new.close()
```

上面的代码，会生成一个修改后的新文件 ，原文件不动，若想覆盖原文件

```plain
import os
f_name = "兼职白领学生空姐模特护士联系方式utf8.txt"
f_new_name = "%s.new" % f_name
old_str = "乔亦菲"
new_str = "[乔亦菲 Yifei Qiao]"
f = open(f_name,'r',encoding="utf-8")
f_new = open(f_new_name,'w',encoding="utf-8")
for line in f:
    if old_str in line:
        new_line = line.replace(old_str,new_str)
    else:
        new_line = line
    f_new.write(new_line)
f.close()
f_new.close()
os.remove(f_name) # windows下要先删除原文件，否则下一步改名会报错文件已存在
os.rename(f_new_name,f_name) #把新文件名字改成原文件 的名字，就把之前的覆盖掉了,windows使用os.replace # 帮助文档说明replace会覆盖原文件
```

## 练习题

**练习题1 —— 全局替换程序：**

* 写一个脚本，允许用户按以下方式执行时，即可以对指定文件内容进行全局替换

```plain
`python your_script.py old_str new_str filename`
```

* 替换完毕后打印替换了多少处内容

```python
# 练习题1 —— 全局替换程序：  https://www.cnblogs.com/chengege/p/10211862.html
# 写一个脚本，允许用户按以下方式执行时，即可以对指定文件内容进行全局替换
#   `python your_script.py old_str new_str filename`
# 替换完毕后打印替换了多少处内容

import sys
# print('参数个数：', len(sys.argv))
# print('他们是：', str(sys.argv))

par = sys.argv  #从命令行 获取 用户输入的参数的列表
print(par)
path_list = sys.path #获取路径列表
print(path_list)
# 使用占 内存方式修改文件
def replace_file(old_str,new_str,path_filename):
    with open(path_filename,'r+',encoding='utf_8') as read_f:
        info = ''
        count = 0
        for line in read_f:
            # print(line,end='')
            if old_str in line:
                new_info = line.replace(old_str, new_str)
                info += new_info
                count += 1
            else:
                info += line
        print('替换次数为%d' % count)
        read_f.seek(0)  #使光标移动到文件开头
        read_f.write(info)  #写入内容
        read_f.truncate(read_f.tell()) # 删除掉光标当前位置 之后的内容！ 防止解码错误
old_str = par[1]
new_str = par[2]
filename = '%s\%s' % (path_list[0],par[3])
replace_file(old_str, new_str, filename)
```

**练习题2 —— 模拟登陆：**

* 用户输入帐号密码进行登陆
* 用户信息保存在文件内
* 用户密码输入错误三次后锁定用户，下次再登录，检测到是这个用户也登录不了

```python
# 模拟登陆 https://www.cnblogs.com/guotianbao/p/6782536.html
#1. 用户输入帐号密码进行登陆
#2. 用户信息保存在文件内
#3. 用户密码输入错误三次后锁定用户"
import sys
count = 0
flag_break =False
while count<3:
    user_name = input('用户名：').strip()
    with open('lock_file',encoding='utf-8') as f_lock:
        for line in f_lock:
            if line.strip() == user_name:
                sys.exit('%s 已经被锁定' % user_name)
    password =input('密码：').strip()
    with open('user_file',encoding='utf-8') as f_user:
        for line in f_user:
            username,passwd = line.strip().split()
            if user_name == username and password == passwd:
                print('登录成功')
                flag_break = True
                break
        if flag_break == False:
            if count == 2:
                count += 1
            else:
                print('用户名或者密码错误，请重试，还有 %s次机会' % (2 - count))
                count += 1
        else:
            break
else:
    print('多次登录错误，此账户已经被锁定')
    with open('lock_file', 'a+') as f_lock:
        f_lock.write('\n' +user_name)

```

# 3.5 函数

## 本节重点：

* 使学生掌握函数的作用、语法
* 掌握作用域、全局变量与局部变量知识

> **本节时长需控制在 分钟内**

## 引子

现在老板让你写一个监控程序，24小时全年无休的监控你们公司网站服务器的系统状况，当cpu＼memory＼disk等指标的使用量超过阀值时即发邮件报警，你掏空了所有的知识量，写出了以下代码

```plain
while True：
    if cpu利用率 > 90%:
        #发送邮件提醒
        连接邮箱服务器
        发送邮件
        关闭连接
    if 硬盘使用空间 > 90%:
        #发送邮件提醒
        连接邮箱服务器
        发送邮件
        关闭连接
    if 内存占用 > 80%:
        #发送邮件提醒
        连接邮箱服务器
        发送邮件
        关闭连接
```

上面的代码实现了功能，但即使是邻居老王也看出了端倪，老王亲切的摸了下你家儿子的脸蛋，说，你这个重复代码太多了，每次报警都要重写一段发邮件的代码，太low了，这样干存在2个问题：

1. 代码重复过多，一个劲的copy and paste不符合高端程序员的气质
2. 如果日后需要修改发邮件的这段代码，比如加入群发功能，那你就需要在所有用到这段代码的地方都修改一遍

你觉得老王说的对，你也不想写重复代码，但又不知道怎么搞，老王好像看出了你的心思，此时他抱起你儿子，笑着说，其实很简单，**只需要把重复的代码提取出来，放在一个公共的地方，起个名字，以后谁想用这段代码，就通过这个名字调用就行了**，如下

```plain
def 发送邮件(内容)
    #发送邮件提醒
    连接邮箱服务器
    发送邮件
    关闭连接
while True：
    if cpu利用率 > 90%:
        发送邮件('CPU报警')
    if 硬盘使用空间 > 90%:
        发送邮件('硬盘报警')
    if 内存占用 > 80%:
        发送邮件('内存报警')
```

你看着老王写的代码，气势恢宏、磅礴大气，代码里透露着一股内敛的傲气，心想，老王这个人真是不一般，突然对他的背景更感兴趣了，问老王，这些花式玩法你都是怎么知道的？ 老王亲了一口你儿子，捋了捋不存在的胡子，淡淡的讲，“老夫，年少时，师从京西沙河淫魔银角大王 ”， 你一听“银角大王”这几个字，不由的娇躯一震，心想，真nb,怪不得代码写的这么6, 这“银角大王”当年在江湖上可是数得着的响当当的名字，只可惜后期纵欲过度，卒于公元2017年， 真是可惜了，只留下其哥哥孤守当年兄弟俩一起打下来的江山。 此时你看着的老王离开的身影，感觉你儿子跟他越来越像了。。。

## 基本定义

#### 函数是什么?

函数一词来源于数学，但编程中的「函数」概念，与数学中的函数是有很大不同的，具体区别，我们后面会讲，编程中的函数在英文中也有很多不同的叫法。在BASIC中叫做subroutine(子过程或子程序)，在Pascal中叫做procedure(过程)和function，在C中只有function，在Java里面叫做method。

**定义: 函数是指将一组语句的集合通过一个名字(函数名)封装起来，要想执行这个函数，只需调用其函数名即可**

**特性:**

1. 减少重复代码
2. 使程序变的可扩展
3. 使程序变得易维护

#### 语法定义

```plain
def sayhi():#函数名
    print("Hello, I'm nobody!")
sayhi() #调用函数
```

可以带参数

```plain
#下面这段代码
a,b = 5,8
c = a**b
print(c)
#改成用函数写
def calc(x,y):
    res = x**y
    return res #返回函数执行结果
c = calc(a,b) ＃结果赋值给c变量
print(c)
```

参数可以让你的函数更灵活，不只能做死的动作，还可以根据调用时传参的不同来决定函数内部的执行流程

## 函数参数

**形参变量**

只有在被调用时才分配内存单元，在调用结束时，即刻释放所分配的内存单元。因此，形参只在函数内部有效。函数调用结束返回主调用函数后则不能再使用该形参变量

**实参**

可以是常量、变量、表达式、函数等，无论实参是何种类型的量，在进行函数调用时，它们都必须有确定的值，以便把这些值传送给形参。因此应预先用赋值，输入等办法使参数获得确定值

<!-- OCR_START -->
- 形参
- 实参

```text
#改成用函数写
def calc(x,y)
res=x**y
return res
c = calc(a,b)
print(c)
```
<!-- OCR_END -->

#### **默认参数**

看如下代码

```plain
def stu_register(name,age,country,course):
    print("----注册学生信息------")
    print("姓名:",name)
    print("age:",age)
    print("国籍:",country)
    print("课程:",course)
stu_register("王山炮",22,"CN","python_devops")
stu_register("张叫春",21,"CN","linux")
stu_register("刘老根",25,"CN","linux")
```

发现 country 这个参数 基本都 是"CN", 就像我们在网站上注册用户，像国籍这种信息，你不填写，默认就会是 中国， 这就是通过默认参数实现的，把country变成默认参数非常简单

```plain
def stu_register(name,age,course,country="CN"):
```

这样，这个参数在调用时不指定，那默认就是CN，指定了的话，就用你指定的值。

> \*\*另外，你可能注意到了，在把country变成默认参数后，我同时把它的位置移到了最后面，为什么呢？　　\*\*

#### 关键参数

正常情况下，给函数传参数要按顺序，不想按顺序就可以用关键参数，只需指定参数名即可(指定了参数名的参数就叫关键参数)，***但记住一个要求就是，关键参数必须放在位置参数(以位置顺序确定对应关系的参数)之后***

```plain
def stu_register(name, age, course='PY' ,country='CN'):
    print("----注册学生信息------")
    print("姓名:", name)
    print("age:", age)
    print("国籍:", country)
    print("课程:", course)
```

调用可以这样

```plain
stu_register("王山炮",course='PY', age=22,country='JP' )
```

但绝不可以这样

```plain
stu_register("王山炮",course='PY',22,country='JP' )
```

当然这样也不行

```plain
stu_register("王山炮",22,age=25,country='JP' )
```

这样相当于给age赋值2次，会报错！

#### **非固定参数**

若你的函数在定义时不确定用户想传入多少个参数，就可以使用非固定参数

```plain
def stu_register(name,age,*args): # *args 会把多传入的参数变成一个元组形式
    print(name,age,args)
stu_register("Alex",22)
#输出
#Alex 22 () #后面这个()就是args,只是因为没传值,所以为空
stu_register("Jack",32,"CN","Python")
#输出
# Jack 32 ('CN', 'Python')
```

还可以有一个\*\*kwargs

```plain
def stu_register(name,age,*args,**kwargs): # *kwargs 会把多传入的参数变成一个dict形式
    print(name,age,args,kwargs)
stu_register("Alex",22)
#输出
#Alex 22 () {}#后面这个{}就是kwargs,只是因为没传值,所以为空
stu_register("Jack",32,"CN","Python",sex="Male",province="ShanDong")
#输出
# Jack 32 ('CN', 'Python') {'province': 'ShanDong', 'sex': 'Male'}
```

## 返回值

函数外部的代码要想获取函数的执行结果，就可以在函数里用return语句把结果返回

```plain
def stu_register(name, age, course='PY' ,country='CN'):
    print("----注册学生信息------")
    print("姓名:", name)
    print("age:", age)
    print("国籍:", country)
    print("课程:", course)
    if age > 22:
        return False
    else:
        return True
registriation_status = stu_register("王山炮",22,course="PY全栈开发",country='JP')
if registriation_status:
    print("注册成功")
else:
    print("too old to be a student.")
```

**注意**

* 函数在执行过程中只要遇到return语句，就会停止执行并返回结果，so 也可以理解为 return 语句代表着函数的结束
* 如果未在函数中指定return,那这个函数的返回值为None

## 全局与局部变量

```plain
name = "Alex Li"
def change_name(name):
    print("before change:",name)
    name = "金角大王,一个有Tesla的男人"
    print("after change", name)
change_name(name)
print("在外面看看name改了么?",name)
```

输出

```plain
before change: Alex Li
after change 金角大王,一个有Tesla的男人
在外面看看name改了么? Alex Li
```

不用传name 值到函数里，也可以在函数里调用外面的变量

```plain
name = "Alex Li"
def change_name():
    name = "金角大王,一个有Tesla的男人"
    print("after change", name)
change_name()
print("在外面看看name改了么?", name)
```

**但就是不能改！**

* 在函数中定义的变量称为局部变量，在程序的一开始定义的变量称为全局变量。
* 全局变量作用域是整个程序，局部变量作用域是定义该变量的函数。
* 当全局变量与局部变量同名时，在定义局部变量的函数内，局部变量起作用；在其它地方全局变量起作用。

#### 作用域

作用域（scope），程序设计概念，通常来说，一段程序代码中所用到的名字并不总是有效/可用的，而限定这个名字的可用性的代码范围就是这个名字的作用域。

> 这里不适合深入，以后再讲LEGB rule

#### 如何在函数里修改全局变量？

```plain
name = "Alex Li"
def change_name():
    global name
    name = "Alex 又名 金角大王,路飞学城讲师"
    print("after change", name)
change_name()
print("在外面看看name改了么?", name)
```

`global name`**的作用就是要在函数里声明全局变量name ，意味着最上面的**`name = "Alex Li"`**即使不写，程序最后面的print也可以打印name**

## 嵌套函数

```plain
name = "Alex"
def change_name():
    name = "Alex2"
    def change_name2():
        name = "Alex3"
        print("第3层打印", name)
    change_name2()  # 调用内层函数
    print("第2层打印", name)
change_name()
print("最外层打印", name)
```

输出

```plain
第3层打印 Alex3
第2层打印 Alex2
最外层打印 Alex
```

此时，在最外层调用change_name2()会出现什么效果？

没错， 出错了， 为什么呢？

> 嵌套函数的用法会了，但它有什么用呢？下节课揭晓。。。

## 匿名函数

匿名函数就是不需要显式的指定函数名

```plain
#这段代码
def calc(x,y):
    return x**y
print(calc(2,5))
#换成匿名函数
calc = lambda x,y:x**y
print(calc(2,5))
```

你也许会说，用上这个东西没感觉有毛方便呀， 。。。。呵呵，如果是这么用，确实没毛线改进，不过匿名函数主要是和其它函数搭配使用的呢，如下

```plain
res = map(lambda x:x**2,[1,5,7,4,8])
for i in res:
    print(i)
```

输出

```plain
1
25
49
16
64
```

## 高阶函数

变量可以指向函数，函数的参数能接收变量，那么一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数。

```plain
def add(x,y,f):
    return f(x) + f(y)
res = add(3,-6,abs)
print(res)
```

只需满足以下任意一个条件，即是高阶函数

* 接受一个或多个函数作为输入
* return 返回另外一个函数

## 递归

在函数内部，可以调用其他函数。如果一个函数在内部调用自身本身，这个函数就是递归函数。

```plain
def calc(n):
    print(n)
    if int(n/2) ==0:
        return n
    return calc(int(n/2))
calc(10)
```

输出

```plain
10
5
2
1
```

来看实现过程，我改了下代码

```plain
def calc(n):
    v = int(n/2)
    print(v)
    if v > 0:
        calc(v)
    print(n)
calc(10)
```

输出

```plain
5
2
1
0
1
2
5
10
```

为什么输出结果是这样？

<!-- OCR_START -->
- 3
- =/o
- 2
- 7=l0
<!-- OCR_END -->

**递归特性:**

1. 必须有一个明确的结束条件
2. 每次进入更深一层递归时，问题规模相比上次递归都应有所减少
3. 递归效率不高，递归层次过多会导致栈溢出（在计算机中，函数调用是通过栈（stack）这种数据结构实现的，每当进入一个函数调用，栈就会加一层栈帧，每当函数返回，栈就会减一层栈帧。由于栈的大小不是无限的，所以，递归调用的次数过多，会导致栈溢出）

> *堆栈扫盲*<http://www.cnblogs.com/lln7777/archive/2012/03/14/2396164.html>

**递归有什么用呢？有很多用途，今天我们就讲一个**

递归函数实际应用案例，二分查找

```plain
data = [1, 3, 6, 7, 9, 12, 14, 16, 17, 18, 20, 21, 22, 23, 30, 32, 33, 35]
def binary_search(dataset,find_num):
    print(dataset)
    if len(dataset) >1:
        mid = int(len(dataset)/2)
        if dataset[mid] == find_num:  #find it
            print("找到数字",dataset[mid])
        elif dataset[mid] > find_num :# 找的数在mid左面
            print("\033[31;1m找的数在mid[%s]左面\033[0m" % dataset[mid])
            return binary_search(dataset[0:mid], find_num)
        else:# 找的数在mid右面
            print("\033[32;1m找的数在mid[%s]右面\033[0m" % dataset[mid])
            return binary_search(dataset[mid+1:],find_num)
    else:
        if dataset[0] == find_num:  #find it
            print("找到数字啦",dataset[0])
        else:
            print("没的分了,要找的数字[%s]不在列表里" % find_num)
binary_search(data,66)
```

## 内置函数

Python的len为什么你可以直接用？肯定是解释器启动时就定义好了

<!-- OCR_START -->
- Built-in Functions
- abs()
- dict()
- help()
- min()
- setattr()
- all()
- dir()
- hex()
- next()
- slice()
- any()
- divmod()
- id()
- object()
- sorted()
- ascii()
- enumerate()
- input()
- oct()
- staticmethod()
- bin()
- eval()
- int()
- open()
- str()
- bool()
- exec()
- isinstance()
- ord()
- sum()
- bytearray()
- filter()
- issubclass()
- pow()
- super()
- bytes ()
- float()
- iter()
- print()
- tuple()
- callable()
- format()
- len()
- property()
- type()
- chr()
- frozenset()
- list()
- range()
- vars()
- classmethod()
- getattr()
- locals()
- repr()
- zip()
- compile()
- globals()
- map()
- reversed()
- import
- _()
- complex()
- hasattr()
- max()
- round()
- delattr()
- hash()
- memoryview()
- set()
<!-- OCR_END -->

> 内置参数详解 <https://docs.python.org/3/library/functions.html?highlight=built#ascii>

几个刁钻古怪的内置方法用法提醒

```plain
#compile
f = open("函数递归.py")
data =compile(f.read(),'','exec')
exec(data)
#print
msg = "又回到最初的起点"
f = open("tofile","w")
print(msg,"记忆中你青涩的脸",sep="|",end="",file=f)
# #slice
# a = range(20)
# pattern = slice(3,8,2)
# for i in a[pattern]: #等于a[3:8:2]
#     print(i)
#
#
#memoryview
#usage:
#>>> memoryview(b'abcd')
#<memory at 0x104069648>
#在进行切片并赋值数据时，不需要重新copy原列表数据，可以直接映射原数据内存，
import time
for n in (100000, 200000, 300000, 400000):
    data = b'x'*n
    start = time.time()
    b = data
    while b:
        b = b[1:]
    print('bytes', n, time.time()-start)
for n in (100000, 200000, 300000, 400000):
    data = b'x'*n
    start = time.time()
    b = memoryview(data)
    while b:
        b = b[1:]
    print('memoryview', n, time.time()-start)
几个内置方法用法提醒
```

## 练习题

修改个人信息程序

在一个文件里存多个人的个人信息，如以下

```plain
username password  age position department 
alex     abc123    24   Engineer   IT
rain     df2@432    25   Teacher   Teching
....
```

1.输入用户名密码，正确后登录系统 ，打印

```plain
1. 修改个人信息
2. 打印个人信息
3. 修改密码
```

2.每个选项写一个方法

3.登录时输错3次退出程序

练习题答案

```plain
def print_personal_info(account_dic,username):
    """
    print user info 
    :param account_dic: all account's data 
    :param username: username 
    :return: None
    """
    person_data = account_dic[username]
    info = '''
    ------------------
    Name:   %s
    Age :   %s
    Job :   %s
    Dept:   %s
    Phone:  %s
    ------------------
    ''' %(person_data[1],
          person_data[2],
          person_data[3],
          person_data[4],
          person_data[5],
          )
    print(info)
def save_back_to_file(account_dic):
    """
    把account dic 转成字符串格式 ，写回文件 
    :param account_dic: 
    :return: 
    """
    f.seek(0) #回到文件头
    f.truncate() #清空原文件
    for k in account_dic:
        row = ",".join(account_dic[k])
        f.write("%s\n"%row)
    f.flush()
def change_personal_info(account_dic,username):
    """
    change user info ,思路如下
    1. 把这个人的每个信息打印出来， 让其选择改哪个字段，用户选择了的数字，正好是字段的索引，这样直接 把字段找出来改掉就可以了
    2. 改完后，还要把这个新数据重新写回到account.txt，由于改完后的新数据 是dict类型，还需把dict转成字符串后，再写回硬盘 
    :param account_dic: all account's data 
    :param username: username 
    :return: None
    """
    person_data = account_dic[username]
    print("person data:",person_data)
    column_names = ['Username','Password','Name','Age','Job','Dept','Phone']
    for index,k in enumerate(person_data):
        if index >1: #0 is username and 1 is password
            print("%s.  %s: %s" %( index, column_names[index],k)  )
    choice = input("[select column id to change]:").strip()
    if choice.isdigit():
        choice = int(choice)
        if choice > 0 and choice < len(person_data): #index不能超出列表长度边界
            column_data = person_data[choice] #拿到要修改的数据
            print("current value>:",column_data)
            new_val = input("new value>:").strip()
            if new_val:#不为空
                person_data[choice] = new_val
                print(person_data)
                save_back_to_file(account_dic) #改完写回文件
            else:
                print("不能为空。。。")
account_file = "account.txt"
f = open(account_file,"r+")
raw_data = f.readlines()
accounts = {}
#把账户数据从文件里读书来，变成dict,这样后面就好查询了
for line in raw_data:
    line = line.strip()
    if not  line.startswith("#"):
        items = line.split(",")
        accounts[items[0]] = items
menu = '''
1. 打印个人信息
2. 修改个人信息
3. 修改密码
'''
count = 0
while count <3:
    username = input("Username:").strip()
    password = input("Password:").strip()
    if username in accounts:
        if password == accounts[username][1]: #
            print("welcome %s ".center(50,'-') % username )
            while True: #使用户可以一直停留在这一层
                print(menu)
                user_choice = input(">>>").strip()
                if user_choice.isdigit():
                    user_choice = int(user_choice)
                    if user_choice == 1:
                        print_personal_info(accounts,username)
                    elif user_choice == 2:
                        change_personal_info(accounts,username)
                elif user_choice == 'q':
                    exit("bye.")
        else:
            print("Wrong username or password!")
    else:
        print("Username does not exist.")
    count += 1
else:
    print("Too many attempts.")
```

# 3.6 函数进阶

## 本节重点：

* 使学生掌握函数名称空间、闭包、装饰器知识

> **本节时长需控制在 分钟内**

## 名称空间

又名name space, 顾名思义就是存放名字的地方，存什么名字呢？举例说明，若变量x=1，1存放于内存中，那名字x存放在哪里呢？**名称空间正是存放名字x与1绑定关系的地方**

名称空间共3种，分别如下

* locals: 是函数内的名称空间，包括局部变量和形参
* globals: 全局变量，函数定义所在模块的名字空间
* builtins: 内置模块的名字空间

**不同变量的作用域不同就是由这个变量所在的命名空间决定的。**

作用域即范围

* 全局范围：全局存活，全局有效
* 局部范围：临时存活，局部有效

查看作用域方法 globals(),locals()

#### 作用域查找顺序

```plain
level = 'L0'
n = 22
def func():
    level = 'L1'
    n = 33
    print(locals())
    def outer():
        n = 44
        level = 'L2'
        print(locals(),n)
        def inner():
            level = 'L3'
            print(locals(),n) #此外打印的n是多少？
        inner()
    outer()
func()
```

**问题：在inner()里的打印的n的值是多少？**

LEGB 代表名字查找顺序: locals -> enclosing function -> globals -> **builtins**

* locals 是函数内的名字空间，包括局部变量和形参
* enclosing 外部嵌套函数的名字空间
* globals 全局变量，函数定义所在模块的名字空间
* builtins 内置模块的名字空间

## 闭包

关于闭包，即函数定义和函数表达式位于另一个函数的函数体内(嵌套函数)。而且，这些内部函数可以访问它们所在的外部函数中声明的所有局部变量、参数。当其中一个这样的内部函数在包含它们的外部函数之外被调用时，就会形成闭包。也就是说，内部函数会在外部函数返回后被执行。而当这个内部函数执行时，它仍然必需访问其外部函数的局部变量、参数以及其他内部函数。这些局部变量、参数和函数声明（最初时）的值是外部函数返回时的值，但也会受到内部函数的影响。

```plain
def outer():
    name = 'alex'
    def inner():
        print("在inner里打印外层函数的变量",name)
    return inner
f = outer() 
f()
```

闭包的意义：**返回的函数对象，不仅仅是一个函数对象，在该函数外还包裹了一层作用域，这使得，该函数无论在何处调用，优先使用自己外层包裹的作用域**

## 装饰器

你是一家视频网站的后端开发工程师，你们网站有以下几个版块。

```plain
def home():
    print("---首页----")
def america():
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
def henan():
    print("----河南专区----")
```

视频刚上线初期，为了吸引用户，你们采取了免费政策，所有视频免费观看，迅速吸引了一大批用户，免费一段时间后，每天巨大的带宽费用公司承受不了了，所以准备对比较受欢迎的几个版块收费，其中包括“欧美” 和 “河南”专区，你拿到这个需求后，想了想，想收费得先让其进行用户认证，认证通过后，再判定这个用户是否是VIP付费会员就可以了，是VIP就让看，不是VIP就不让看就行了呗。 你觉得这个需求很是简单，因为要对多个版块进行认证，那应该把认证功能提取出来单独写个模块，然后每个版块里调用 就可以了，与是你轻轻的就实现了下面的功能 。

```plain
#_*_coding:utf-8_*_
user_status = False #用户登录了就把这个改成True
def login():
    _username = "alex" #假装这是DB里存的用户信息
    _password = "abc!23" #假装这是DB里存的用户信息
    global user_status
    if user_status == False:
        username = input("user:")
        password = input("pasword:")
        if username == _username and password == _password:
            print("welcome login....")
            user_status = True
        else:
            print("wrong username or password!")
    else:
        print("用户已登录，验证通过...")
def home():
    print("---首页----")
def america():
    login() #执行前加上验证
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
def henan():
    login() #执行前加上验证
    print("----河南专区----")
home()
america()
henan()
```

此时你信心满满的把这个代码提交给你的TEAM LEADER审核，没成想，没过5分钟，代码就被打回来了， TEAM LEADER给你反馈是，我现在有很多模块需要加认证模块，你的代码虽然实现了功能，但是需要更改需要加认证的各个模块的代码，这直接违反了软件开发中的一个原则“开放-封闭”原则，简单来说，它规定已经实现的功能代码不允许被修改，但可以被扩展，即：

* 封闭：已实现的功能代码块不应该被修改
* 开放：对现有功能的扩展开放

这个原则你还是第一次听说，我擦，再次感受了自己这个野生程序员与正规军的差距，BUT ANYWAY,老大要求的这个怎么实现呢？如何在不改原有功能代码的情况下加上认证功能呢？你一时想不出思路，只好带着这个问题回家继续憋，媳妇不在家，去隔壁老王家串门了，你正好落的清静，一不小心就想到了解决方案，不改源代码可以呀。 你师从沙河金角大王时，记得他教过你，高阶函数，就是把一个函数当做一个参数传给另外一个函数，当时大王说，有一天，你会用到它的，没想到这时这个知识点突然从脑子 里蹦出来了，我只需要写个认证方法，每次调用 需要验证的功能 时，直接 把这个功能 的函数名当做一个参数 传给 我的验证模块不就行了么，哈哈，机智如我，如是你啪啪啪改写了之前的代码。

```plain
#_*_coding:utf-8_*_
user_status = False #用户登录了就把这个改成True
def login(func): #把要执行的模块从这里传进来
    _username = "alex" #假装这是DB里存的用户信息
    _password = "abc!23" #假装这是DB里存的用户信息
    global user_status
    if user_status == False:
        username = input("user:")
        password = input("pasword:")
        if username == _username and password == _password:
            print("welcome login....")
            user_status = True
        else:
            print("wrong username or password!")
    if user_status == True:
        func() # 看这里看这里，只要验证通过了，就调用相应功能
def home():
    print("---首页----")
def america():
    #login() #执行前加上验证
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
def henan():
    #login() #执行前加上验证
    print("----河南专区----")
home()
login(america) #需要验证就调用 login，把需要验证的功能 当做一个参数传给login
# home()
# america()
login(henan)
```

你很开心，终于实现了老板的要求，不改变原功能代码的前提下，给功能加上了验证，此时，媳妇回来了，后面还跟着老王，你两家关系 非常 好，老王经常来串门，老王也是码农，你跟他分享了你写的代码，兴奋的等他看完 夸奖你NB,没成想，老王看后，并没有夸你，抱起你的儿子，笑笑说，你这个代码还是改改吧， 要不然会被开除的，WHAT? 会开除，明明实现了功能 呀， 老王讲，没错，你功能 是实现了，但是你又犯了一个大忌，什么大忌？ 你改变了调用方式呀， 想一想，现在没每个需要认证的模块，都必须调用你的login()方法，并把自己的函数名传给你，人家之前可不是这么调用 的， 试想，如果 有100个模块需要认证，那这100个模块都得更改调用方式，这么多模块肯定不止是一个人写的，让每个人再去修改调用方式 才能加上认证，你会被骂死的。。。。 你觉得老王说的对，但问题是，如何即不改变原功能代码，又不改变原有调用方式，还能加上认证呢？ 你苦思了一会，还是想不出，老王在逗你的儿子玩，你说，老王呀，快给我点思路 ，实在想不出来，老王背对着你问， 老王：学过匿名函数没有？ 你：学过学过，就是lambda嘛 老王：那lambda与正常函数的区别是什么？ 你：最直接的区别是，正常函数定义时需要写名字，但lambda不需要 老王：没错，那lambda定好后，为了多次调用 ，可否也给它命个名？ 你：可以呀，可以写成plus = lambda x:x+1类似这样，以后再调用plus就可以了，但这样不就失去了lambda的意义了，明明人家叫匿名函数呀，你起了名字有什么用呢？ 老王：我不是要跟你讨论它的意义 ，我想通过这个让你明白一个事实 说着，老王拿起你儿子的画板，在上面写了以下代码：

```plain
def plus(n):
    return n+1
plus2 = lambda x:x+1
```

老王： 上面这两种写法是不是代表 同样的意思？ 你：是的 老王：我给lambda x:x+1 起了个名字叫plus2，是不是相当于def plus2(x) ? 你：我擦，你别说，还真是，但老王呀，你想说明什么呢？ 老王： 没啥，只想告诉你，给函数赋值变量名就像def func_name　是一样的效果，如下面的plus(n)函数，你调用时可以用plus名，还可以再起个其它名字，如

```plain
calc = plus
calc(n)
```

你明白我想传达什么意思了么？ 你：。。。。。。。。。。。这。。。。。。嗯 。。。。。不太。。。。明白 。。 老王：。。。。这。。。。。呵呵。。。。。。好吧。。。。，那我在给你点一下，你之前写的下面这段调用 认证的代码

```plain
home()
login(america) #需要验证就调用 login，把需要验证的功能 当做一个参数传给login
# home()
# america()
login(henan)
```

你之所改变了调用方式，是因为用户每次调用时需要执行login(henan)，类似的。其实稍一改就可以了呀

```plain
home()
america = login(america)
henan = login(henan)
```

这样你，其它人调用henan时，其实相当于调用了login(henan), 通过login里的验证后，就会自动调用henan功能。 你：我擦，还真是唉。。。，老王，还是你nb。。。不过，等等， 我这样写了好，那用户调用时，应该是下面这个样子

```plain
home()
america = login(america) #你在这里相当于把america这个函数替换了
henan = login(henan)
#那用户调用时依然写
america()
```

但问题在于，还不等用户调用 ，你的america = login(america)就会先自己把america执行了呀。。。。，你应该等我用户调用 的时候 再执行才对呀，不信我试给你看。。。 老王：哈哈，你说的没错，这样搞会出现这个问题？ 但你想想有没有解决办法 呢？ 你：我擦，你指的思路呀，大哥。。。我哪知道 下一步怎么走。。。 老王：算了，估计你也想不出来。。。 学过嵌套函数没有？ 你：yes,然后呢？ 老王：想实现一开始你写的america = login(america)不触发你函数的执行，只需要在这个login里面再定义一层函数，第一次调用america = login(america)只调用到外层login，这个login虽然会执行，但不会触发认证了，因为认证的所有代码被封装在login里层的新定义 的函数里了，login只返回 里层函数的函数名，这样下次再执行america()时， 就会调用里层函数啦。。。 你：。。。。。。什么？ 什么个意思，我蒙逼了。。。 老王：还是给你看代码吧。。

```plain
def login(func): #把要执行的模块从这里传进来
    def inner():#再定义一层函数
        _username = "alex" #假装这是DB里存的用户信息
        _password = "abc!23" #假装这是DB里存的用户信息
        global user_status
        if user_status == False:
            username = input("user:")
            password = input("pasword:")
            if username == _username and password == _password:
                print("welcome login....")
                user_status = True
            else:
                print("wrong username or password!")
        if user_status == True:
            func() # 看这里看这里，只要验证通过了，就调用相应功能
    return inner #用户调用login时，只会返回inner的内存地址，下次再调用时加上()才会执行inner函数
```

此时你仔细着了老王写的代码　，感觉老王真不是一般人呀，连这种奇淫巧技都能想出来。。。，心中默默感谢上天赐你一个大牛邻居。 你: 老王呀，你这个姿势很nb呀，你独创的？ 此时你媳妇噗嗤的笑出声来，你也不知道 她笑个球。。。 老王：呵呵， 这不是我独创的呀当然 ，这是开发中一个常用的玩法，叫语法糖，官方名称“装饰器”，其实上面的写法，还可以更简单 可以把下面代码去掉

```plain
america = login(america) #你在这里相当于把america这个函数替换了
```

只在你要装饰的函数上面加上下面代码

```plain
@login
def america():
    #login() #执行前加上验证
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
@login
def henan():
    #login() #执行前加上验证
    print("----河南专区----")
```

效果是一样的。 你开心的玩着老王教你的新姿势 ，玩着玩着就手贱给你的“河南专区”版块 加了个参数，然后，结果 出错了。。。

你：老王，老王，怎么传个参数就不行了呢？ 老王：那必然呀，你调用henan时，其实是相当于调用的login，你的henan第一次调用时henan = login(henan)， login就返回了inner的内存地址，第2次用户自己调用henan("3p"),实际上相当于调用的时inner,但你的inner定义时并没有设置参数，但你给他传了个参数，所以自然就报错了呀 你：但是我的 版块需要传参数呀，你不让我传不行呀。。。 老王：没说不让你传，稍做改动便可。。

老王：你再试试就好了 。 你： 果然好使，大神就是大神呀。 。。 不过，如果有多个参数呢？ 老王：。。。。老弟，你不要什么都让我教你吧，非固定参数你没学过么？ \*args,\*\*kwargs... 你：噢 。。。还能这么搞?,nb,我再试试。 你身陷这种新玩法中无法自拔，竟没注意到老王已经离开，你媳妇告诉你说为了不打扰你加班，今晚带孩子去跟她姐妹住 ，你觉得媳妇真体贴，最终，你终于搞定了所有需求，完全遵循开放-封闭原则，最终代码如下。

```plain
#_*_coding:utf-8_*_
user_status = False #用户登录了就把这个改成True
def login(func): #把要执行的模块从这里传进来
    def inner(*args,**kwargs):#再定义一层函数
        _username = "alex" #假装这是DB里存的用户信息
        _password = "abc!23" #假装这是DB里存的用户信息
        global user_status
        if user_status == False:
            username = input("user:")
            password = input("pasword:")
            if username == _username and password == _password:
                print("welcome login....")
                user_status = True
            else:
                print("wrong username or password!")
        if user_status == True:
            func(*args,**kwargs) # 看这里看这里，只要验证通过了，就调用相应功能
    return inner #用户调用login时，只会返回inner的内存地址，下次再调用时加上()才会执行inner函数
def home():
    print("---首页----")
@login
def america():
    #login() #执行前加上验证
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
# @login
def henan(style):
    '''
    :param style: 喜欢看什么类型的，就传进来
    :return:
    '''
    #login() #执行前加上验证
    print("----河南专区----")
home()
# america = login(america) #你在这里相当于把america这个函数替换了
henan = login(henan)
# #那用户调用时依然写
america()
henan("3p")
```

此时，你已累的不行了，洗洗就抓紧睡了，半夜，上厕所，隐隐听到隔壁老王家有微弱的女人的声音传来，你会心一笑，老王这家伙，不声不响找了女朋友也不带给我看看，改天一定要见下真人。。。。 第二2天早上，产品经理又提了新的需求，要允许用户选择用qq\weibo\weixin认证，此时的你，已深谙装饰器各种装逼技巧，轻松的就实现了新的需求。

#### 带参数装饰器

```plain
#_*_coding:utf-8_*_
user_status = False #用户登录了就把这个改成True
def login(auth_type): #把要执行的模块从这里传进来
    def auth(func):
        def inner(*args,**kwargs):#再定义一层函数
            if auth_type == "qq":
                _username = "alex" #假装这是DB里存的用户信息
                _password = "abc!23" #假装这是DB里存的用户信息
                global user_status
                if user_status == False:
                    username = input("user:")
                    password = input("pasword:")
                    if username == _username and password == _password:
                        print("welcome login....")
                        user_status = True
                    else:
                        print("wrong username or password!")
                if user_status == True:
                    return func(*args,**kwargs) # 看这里看这里，只要验证通过了，就调用相应功能
            else:
                print("only support qq ")
        return inner #用户调用login时，只会返回inner的内存地址，下次再调用时加上()才会执行inner函数
    return auth
def home():
    print("---首页----")
@login('qq')
def america():
    #login() #执行前加上验证
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
@login('weibo')
def henan(style):
    '''
    :param style: 喜欢看什么类型的，就传进来
    :return:
    '''
    #login() #执行前加上验证
    print("----河南专区----")
home()
# america = login(america) #你在这里相当于把america这个函数替换了
#henan = login(henan)
# #那用户调用时依然写
america()
# henan("3p")
```

#### 练习题

一：编写3个函数，每个函数执行的时间是不一样的，

> 提示：可以使用time.sleep(2)，让程序sleep 2s或更多，

二：编写装饰器，为每个函数加上统计运行时间的功能

> 提示：在函数开始执行时加上start=time.time()就可纪录当前执行的时间戳，函数执行结束后在time.time() - start就可以拿到执行所用时间

三：编写装饰器，为函数加上认证的功能，即要求认证成功后才能执行函数

四：编写装饰器，为多个函数加上认证的功能（用户的账号密码来源于文件），要求登录成功一次，后续的函数都无需再输入用户名和密码

> 提示：从文件中读出字符串形式的字典，可以用eval('{"name":"egon","password":"123"}')转成字典格式

# 3.7 生成器& 迭代器

## 本节重点：

* 使学生掌握列表生成式、生成器、迭代器

> **本节时长需控制在 分钟内**

## 列表生成式

现在有个需求，看列表`[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]`,要求你把列表里的每个值加1，你怎么实现？你可能会想到2种方式

**二逼青年版**

```plain
>>> a
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> b = []
>>> for i in a:b.append(i+1)
... 
>>> b
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
>>> a = b
>>> a
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

**普通青年版**

```plain
a = [1,3,4,6,7,7,8,9,11]
for index,i in enumerate(a):
    a[index] +=1
print(a)
```

**文艺青年版**

```plain
>>> a
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
>>> a = map(lambda x:x+1, a)
>>> a
<map object at 0x101d2c630>
>>> for i in a:print(i)
... 
3
5
7
9
11
```

其实还有一种写法，如下

**装逼青年版**

```plain
>>> a = [i+1 for i in range(10)]
>>> a
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

这样的写法就叫做**列表生成式**

## 生成器

通过列表生成式，我们可以直接创建一个列表。但是，受到内存限制，列表容量肯定是有限的。而且，创建一个包含100万个元素的列表，不仅占用很大的存储空间，如果我们仅仅需要访问前面几个元素，那后面绝大多数元素占用的空间都白白浪费了。

所以，如果列表元素可以按照某种算法推算出来，那我们是否可以在循环的过程中不断推算出后续的元素呢？这样就不必创建完整的list，从而节省大量的空间。在Python中，这种一边循环一边计算的机制，称为生成器：generator。

要创建一个generator，有很多种方法。第一种方法很简单，只要把一个列表生成式的`[]`改成`()，`就创建了一个generator：

```plain
>>> L = [x * x for x in range(10)]
>>> L
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
>>> g = (x * x for x in range(10))
>>> g
<generator object <genexpr> at 0x1022ef630>
```

创建`L`和`g`的区别仅在于最外层的`[]`和`()`，`L`是一个list，而`g`是一个generator。

我们可以直接打印出list的每一个元素，但我们怎么打印出generator的每一个元素呢？

如果要一个一个打印出来，可以通过`next()`函数获得generator的下一个返回值：

```plain
>>> next(g)
0
>>> next(g)
1
>>> next(g)
4
>>> next(g)
9
>>> next(g)
16
>>> next(g)
25
>>> next(g)
36
>>> next(g)
49
>>> next(g)
64
>>> next(g)
81
>>> next(g)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
```

我们讲过，generator保存的是算法，每次调用`next(g)`就计算出`g`的下一个元素的值，直到计算到最后一个元素，没有更多的元素时，抛出`StopIteration`的错误。

当然，上面这种不断调用`next(g)`实在是太变态了，正确的方法是使用`for`循环，因为generator也是可迭代对象：

```plain
>>> g = (x * x for x in range(10))
>>> for n in g:
...     print(n)
...
0
1
4
9
16
25
36
49
64
81
```

所以，我们创建了一个generator后，基本上永远不会调用next()，而是通过for循环来迭代它，并且不需要关心StopIteration的错误。

generator非常强大。如果推算的算法比较复杂，用类似列表生成式的for循环无法实现的时候，还可以用函数来实现。

比如，著名的斐波拉契数列（Fibonacci），除第一个和第二个数外，任意一个数都可由前两个数相加得到：

1, 1, 2, 3, 5, 8, 13, 21, 34, ...

斐波拉契数列用列表生成式写不出来，但是，用函数把它打印出来却很容易：

```plain
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        print(b)
        a, b = b, a + b
        n = n + 1
    return 'done'
```

注意，赋值语句：

```plain
a, b = b, a + b
```

相当于：

```plain
t = a + b 
a = b 
b = t
```

但不必显式写出临时变量t就可以赋值。

上面的函数可以输出斐波那契数列的前N个数：

```plain
>>> fib(10)
1
1
2
3
5
8
13
21
34
55
done
```

仔细观察，可以看出，`fib`函数实际上是定义了斐波拉契数列的推算规则，可以从第一个元素开始，推算出后续任意的元素，这种逻辑其实非常类似generator。

也就是说，上面的函数和generator仅一步之遥。要把`fib`函数变成generator，只需要把`print(b)`改为`yield b`就可以了：

```plain
def fib(max):
    n,a,b = 0,0,1
    while n < max:
        #print(b)
        yield  b
        a,b = b,a+b
        n += 1
    return 'done'
```

这就是定义generator的另一种方法。如果一个函数定义中包含`yield`关键字，那么这个函数就不再是一个普通函数，而是一个generator：

```plain
>>> f = fib(6)
>>> f
<generator object fib at 0x104feaaa0>
```

这里，最难理解的就是generator和函数的执行流程不一样。函数是顺序执行，遇到return语句或者最后一行函数语句就返回。而变成generator的函数，在每次调用next()的时候执行，遇到yield语句返回，再次被next()调用时从上次返回的yield语句处继续执行。

```plain
data = fib(10)
print(data)
print(data.__next__())
print(data.__next__())
print("干点别的事")
print(data.__next__())
print(data.__next__())
print(data.__next__())
print(data.__next__())
print(data.__next__())
#输出
<generator object fib at 0x000002E33EEFFCA8>
1
1
干点别的事
2
3
5
8
13
```

`在上面fib`的例子，我们在循环过程中不断调用`yield`，就会不断中断。当然要给循环设置一个条件来退出循环，不然就会产生一个无限数列出来。同样的，把函数改成generator后，我们基本上从来不会用`next()`来获取下一个返回值，而是直接使用`for`循环来迭代：

```plain
>>> for n in fib(6):
...     print(n)
...
1
1
2
3
5
8
```

但是用for循环调用generator时，发现拿不到generator的return语句的返回值。如果想要拿到返回值，必须捕获StopIteration错误，返回值包含在StopIteration的value中：

```plain
>>> g = fib(6)
>>> while True:
...     try:
...         x = next(g)
...         print('g:', x)
...     except StopIteration as e:
...         print('Generator return value:', e.value)
...         break
...
g: 1
g: 1
g: 2
g: 3
g: 5
g: 8
Generator return value: done
```

关于如何捕获错误，后面的错误处理还会详细讲解。

\*\*还可通过yield实现在单线程的情况下实现并发运算的效果　　\*\*

```plain
#_*_coding:utf-8_*_
__author__ = 'Alex Li'
import time
def consumer(name):
    print("%s 准备吃包子啦!" %name)
    while True:
       baozi = yield
       print("包子[%s]来了,被[%s]吃了!" %(baozi,name))
def producer(name):
    c = consumer('A')
    c2 = consumer('B')
    c.__next__()
    c2.__next__()
    print("老子开始准备做包子啦!")
    for i in range(10):
        time.sleep(1)
        print("做了2个包子!")
        c.send(i)
        c2.send(i)
producer("alex")
通过生成器实现协程并行运算
```

## 迭代器

我们已经知道，可以直接作用于`for`循环的数据类型有以下几种：

一类是集合数据类型，如`list`、`tuple`、`dict`、`set`、`str`等；

一类是`generator`，包括生成器和带`yield`的generator function。

这些可以直接作用于`for`循环的对象统称为可迭代对象：`Iterable`。

可以使用`isinstance()`判断一个对象是否是`Iterable`对象：

```plain
>>> from collections import Iterable
>>> isinstance([], Iterable)
True
>>> isinstance({}, Iterable)
True
>>> isinstance('abc', Iterable)
True
>>> isinstance((x for x in range(10)), Iterable)
True
>>> isinstance(100, Iterable)
False
```

而生成器不但可以作用于for循环，还可以被next()函数不断调用并返回下一个值，直到最后抛出StopIteration错误表示无法继续返回下一个值了。

*\***可以被next()函数调用并不断返回下一个值的对象称为迭代器：Iterator。***

可以使用isinstance()判断一个对象是否是Iterator对象：

```plain
>>> from collections import Iterator
>>> isinstance((x for x in range(10)), Iterator)
True
>>> isinstance([], Iterator)
False
>>> isinstance({}, Iterator)
False
>>> isinstance('abc', Iterator)
False
```

生成器都是`Iterator`对象，但`list`、`dict`、`str`虽然是`Iterable`，却不是`Iterator`。

把`list`、`dict`、`str`等`Iterable`变成`Iterator`可以使用`iter()`函数：

```plain
>>> isinstance(iter([]), Iterator)
True
>>> isinstance(iter('abc'), Iterator)
True
```

你可能会问，为什么`list`、`dict`、`str`等数据类型不是`Iterator`？

这是因为Python的`Iterator`对象表示的是一个数据流，Iterator对象可以被`next()`函数调用并不断返回下一个数据，直到没有数据时抛出`StopIteration`错误。可以把这个数据流看做是一个有序序列，但我们却不能提前知道序列的长度，只能不断通过`next()`函数实现按需计算下一个数据，所以`Iterator`的计算是惰性的，只有在需要返回下一个数据时它才会计算。

`Iterator`甚至可以表示一个无限大的数据流，例如全体自然数。而使用list是永远不可能存储全体自然数的。

**小结**

凡是可作用于`for`循环的对象都是`Iterable`类型；

凡是可作用于`next()`函数的对象都是`Iterator`类型，它们表示一个惰性计算的序列；

集合数据类型如`list`、`dict`、`str`等是`Iterable`但不是`Iterator`，不过可以通过`iter()`函数获得一个`Iterator`对象。

Python3的`for`循环本质上就是通过不断调用`next()`函数实现的，例如：

```plain
for x in [1, 2, 3, 4, 5]:
    pass
```

实际上完全等价于：

```plain
# 首先获得Iterator对象:
it = iter([1, 2, 3, 4, 5])
# 循环:
while True:
    try:
        # 获得下一个值:
        x = next(it)
    except StopIteration:
        # 遇到StopIteration就退出循环
        break
```

# 3.8 本章小结

## 本章总节

### 练习题

#### 文件处理相关

1. 编码问题
   1. 请说明python2 与python3中的默认编码是什么？
   2. 为什么会出现中文乱码？你能列举出现乱码的情况有哪几种？
   3. 如何进行编码转换？
   4. `#-*-coding:utf-8-*-` 的作用是什么？
   5. 解释py2 bytes vs py3 bytes的区别
2. 文件处理
   1. r和rb的区别是什么？
   2. 解释一下以下三个参数的分别作用

```plain
open(f_name,'r',encoding="utf-8")
```

#### 函数基础：

1. 写函数，计算传入数字参数的和。（动态传参）
2. 写函数，用户传入修改的文件名，与要修改的内容，执行函数，完成整个文件的批量修改操作
3. 写函数，检查用户传入的对象（字符串、列表、元组）的每一个元素是否含有空内容。
4. 写函数，检查传入字典的每一个value的长度,如果大于2，那么仅保留前两个长度的内容，并将新内容返回给调用者。

```plain
dic = {"k1": "v1v1", "k2": [11,22,33,44]}
PS:字典中的value只能是字符串或列表
```

1. 解释闭包的概念

#### 函数进阶：

1. 写函数，返回一个扑克牌列表，里面有52项，每一项是一个元组
   1. 例如：\[(‘红心’，2),(‘草花’，2), …(‘黑桃A’)]
2. 写函数，传入n个数，返回字典{‘max’:最大值,’min’:最小值}

```plain
例如:min_max(2,5,7,8,4)
返回:{‘max’:8,’min’:2}
```

1. 写函数，专门计算图形的面积
   * 其中嵌套函数，计算圆的面积，正方形的面积和长方形的面积
   * 调用函数area(‘圆形’,圆半径) 返回圆的面积
   * 调用函数area(‘正方形’,边长) 返回正方形的面积
   * 调用函数area(‘长方形’,长，宽) 返回长方形的面积

```plain
def area():
    def 计算长方形面积():
        pass
    def 计算正方形面积():
        pass
    def 计算圆形面积():
        pass
```

1. 写函数，传入一个参数n，返回n的阶乘

```plain
例如:cal(7)
计算7*6*5*4*3*2*1
```

1. 编写装饰器，为多个函数加上认证的功能（用户的账号密码来源于文件），要求登录成功一次，后续的函数都无需再输入用户名和密码

#### 生成器和迭代器

1. 生成器和迭代器的区别？
2. 生成器有几种方式获取value？
3. 通过生成器写一个日志调用方法， 支持以下功能
   * 根据指令向屏幕输出日志
   * 根据指令向文件输出日志
   * 根据指令同时向文件&屏幕输出日志
   * 以上日志格式如下

```plain
2017-10-19 22:07:38 [1] test log db backup 3
2017-10-19 22:07:40 [2]    user alex login success 
#注意：其中[1],[2]是指自日志方法第几次调用，每调用一次输出一条日志
```

```
- 代码结构如下
```

```plain
def logger(filename,channel='file'):
    """
    日志方法
    :param filename: log filename
    :param channel: 输出的目的地，屏幕(terminal)，文件(file)，屏幕+文件(both)
    :return:
    """
    ...your code...
 #调用
 log_obj = logger(filename="web.log",channel='both')
 log_obj.__next__()
 log_obj.send('user alex login success')
```

#### 内置函数

1. 用map来处理字符串列表,把列表中所有人都变成sb,比方alex_sb

```plain
name=['alex','wupeiqi','yuanhao','nezha']
```

1. 用filter函数处理数字列表，将列表中所有的偶数筛选出来

```plain
num = [1,3,5,6,7,8]
```

1. 如下，每个小字典的name对应股票名字，shares对应多少股，price对应股票的价格

```plain
portfolio = [
    {'name': 'IBM', 'shares': 100, 'price': 91.1},
    {'name': 'AAPL', 'shares': 50, 'price': 543.22},
    {'name': 'FB', 'shares': 200, 'price': 21.09},
    {'name': 'HPQ', 'shares': 35, 'price': 31.75},
    {'name': 'YHOO', 'shares': 45, 'price': 16.35},
    {'name': 'ACME', 'shares': 75, 'price': 115.65}
]
```

1. 计算购买每支股票的总价\
   用filter过滤出，单价大于100的股票有哪些

1、请分别介绍文件操作中不同的打开方式之间的区别：

| 模式 | 含义 |
| --- | --- |
| r | |
| rb | |
| r+ | |
| rb+ | |
| w | |
| wb | |
| w+ | |
| wb+ | |
| a | |
| ab | |
| a+ | |
| ab+ | |

2、有列表 li = \['alex', 'egon', 'smith', 'pizza', 'alen'], 请将以字母“a”开头的元素的首字母改为大写字母；

3、有如下程序, 请给出两次调用`show_num`函数的执行结果，并说明为什么：

```plain
num = 20
   def show_num(x=num):
       print(x)
   show_num()
   num = 30
   show_num()
```

4、有列表 li = \['alex', 'egon', 'smith', 'pizza', 'alen'], 请以列表中每个元素的第二个字母倒序排序；

5、有名为`poetry.txt`的文件，其内容如下，请删除第三行；

```plain
昔人已乘黄鹤去，此地空余黄鹤楼。
   黄鹤一去不复返，白云千载空悠悠。
   晴川历历汉阳树，芳草萋萋鹦鹉洲。
   日暮乡关何处是？烟波江上使人愁。
```

6、有名为`username.txt`的文件，其内容格式如下，写一个程序，判断该文件中是否存在"alex", 如果没有，则将字符串"alex"添加到该文件末尾，否则提示用户该用户已存在；

```plain
pizza
   alex
   egon
```

7、有名为user_info.txt的文件，其内容格式如下，写一个程序，删除id为100003的行；

```plain
pizza,100001
   alex, 100002
   egon, 100003
```

8、有名为user_info.txt的文件，其内容格式如下，写一个程序，将id为100002的用户名修改为`alex li`；

```plain
pizza,100001
   alex, 100002
   egon, 100003
```

9、写一个计算每个程序执行时间的装饰器；

10、lambda是什么？请说说你曾在什么场景下使用lambda？

11、题目：写一个摇骰子游戏，要求用户压大小，赔率一赔一。

要求：三个骰子，摇大小，每次打印摇骰子数。

### 作业

现要求你写一个简单的员工信息增删改查程序，需求如下：

<!-- OCR_START -->
| 员工信息表 | 员工信息表 | 员工信息表 | 排名 | 员工信息表 | 排名(上年) |
| --- | --- | --- | --- | --- | --- |
| phone | dept | enroll_date | 1 | Alex Li | 22 |
| 13651054608 | IT | 2013-04-01 | 2 | Jack Wang | 30 |
| 13304320533 | HR | 2015-05-03 | 3 | Raln Liu | 25 |
| 1383235322 | Sales | 2016-04-22 | 4 | Mack Cao | 40 |
<!-- OCR_END -->

当然此表你在文件存储时可以这样表示

```plain
1,Alex Li,22,13651054608,IT,2013-04-01
2,Jack Wang,28,13451024608,HR,2015-01-07
3,Rain Wang,21,13451054608,IT,2017-04-01
4,Mack Qiao,44,15653354208,Sales,2016-02-01
5,Rachel Chen,23,13351024606,IT,2013-03-16
6,Eric Liu,19,18531054602,Marketing,2012-12-01
7,Chao Zhang,21,13235324334,Administration,2011-08-08
8,Kevin Chen,22,13151054603,Sales,2013-04-01
9,Shit Wen,20,13351024602,IT,2017-07-03
10,Shanshan Du,26,13698424612,Operation,2017-07-02
```

1.可进行模糊查询，语法至少支持下面3种查询语法:

```plain
find name,age from staff_table where age > 22
find * from staff_table where dept = "IT"
find * from staff_table where enroll_date like "2013"
```

2.可创建新员工纪录，以phone做唯一键(即不允许表里有手机号重复的情况)，staff_id需自增

```plain
语法: add staff_table Alex Li,25,134435344,IT,2015-10-29
```

3.可删除指定员工信息纪录，输入员工id，即可删除

```plain
语法: del from staff_table where  id=3
```

4.可修改员工信息，语法如下:

```plain
UPDATE staff_table SET dept="Market" WHERE  dept = "IT" 把所有dept=IT的纪录的dept改成Market
UPDATE staff_table SET age=25 WHERE  name = "Alex Li"  把name=Alex Li的纪录的年龄改成25
```

5.以上每条语名执行完毕后，要显示这条语句影响了多少条纪录。 比如查询语句 就显示 查询出了多少条、修改语句就显示修改了多少条等。

**注意：以上需求，要充分使用函数，请尽你的最大限度来减少重复代码！**

### 练习答案

#### 文件处理相关

1. 编码问题
   * 请说明python2 与python3中的默认编码是什么？

```plain
# 答案
 py2默认ASCII码，py3默认的utf8
```

```
- 为什么会出现中文乱码？你能列举出现乱码的情况有哪几种？
```

```plain
# 答案
#coding:utf-8 #.py文件是什么编码就需要告诉python用什么编码去读取这个.py文件。
sys.stdout.encoding，默认就是locale的编码，print会用sys.stdout.encoding去encode()成字节流，交给terminal显示。所以locale需要与terminal一致，才能正确print打印出中文。
sys.setdefaultencoding(‘utf8’)，用于指定str.encode() str.decode()的默认编码，默认是ascii。
以下几种(local 为软件运行时的语言环境):
 终端为UTF-8，locale为zh_CN.GBK
 终端为UTF-8，locale为zh_CN.UTF-8
 终端为GBK，locale为zh_CN.GBK
 终端为GBK，locale为zh_CN.UTF-8
```

1. 如何进行编码转换？

```plain
# 答案
  字符串在python内部中是采用unicode的编码方式，所以其他语言先decode转换成unicode编码，再encode转换成utf8编码。
```

1. `#-*-coding:utf-8-*-` 的作用是什么？

```plain
# 答案
  编码声明
```

1. 解释py2 bytes vs py3 bytes的区别

```plain
# 答案
   Python 2 将 strings 处理为原生的 bytes 类型，而不是 unicode(python2 str == bytes)，
   Python 3 所有的 strings 均是 unicode 类型(python3 中需要通过 unicode )
   string -> encode  -> bytes
   bytes -> decode  -> string
```

1. 文件处理
   1. r和rb的区别是什么？

```plain
# 答案
r 读模式
rb 二进制读
```

```
1. 解释一下以下三个参数的分别作用
```

```plain
# 答案
open(f_name,'r',encoding="utf-8")
```

```plain
f_name   文件名
 r      模式
encoding  编码方式
```

#### 函数基础：

1. 写函数，计算传入数字参数的和。（动态传参）

```plain
# 答案
def func_sum(x, y):
   return x + y
   或
   lambda x , y : x +y
```

1. 写函数，用户传入修改的文件名，与要修改的内容，执行函数，完成整个文件的批量修改操作

```plain
# 答案
# 修改列表中字符串首字母大写
def file_daxie(file):
   a=[]
   for i in file:
       b=i.capitalize()
       a.append(b)
print(a)
```

1. 写函数，检查用户传入的对象（字符串、列表、元组）的每一个元素是否含有空内容。

```plain
# 答案
def file_k(file):
   n=0
   for i in file:
       if i==‘ ‘:
           n+=1
   print(‘有%s个空‘%n)
```

1. 写函数，检查传入字典的每一个value的长度,如果大于2，那么仅保留前两个长度的内容，并将新内容返回给调用者。

```plain
dic = {"k1": "v1v1", "k2": [11,22,33,44]}
PS:字典中的value只能是字符串或列表
```

```plain
#答案
     def func(i):  # i为所传字典
         for k, v in i.items():
             if len(v) > 2:
                 dic[k]= v[:2]
             else:
                 continue
         return i
     print(func(dic))
     {'k1': 'v1', 'k2': [11, 22]}
```

1. 解释闭包的概念

```plain
# 答案
  闭包(closure)是函数式编程的重要的语法结构。函数式编程是一种编程范式 (而面向过程编程和面向对象编程也都是编程范式)。
  在面向过程编程中，我们见到过函数(function)；在面向对象编程中，我们见过对象(object)。函数和对象的根本目的是以某种逻辑方式组织代码，并提高代码的可重复使用性(reusability)。
  闭包也是一种组织代码的结构，它同样提高了代码的可重复使用性。
```

#### 函数进阶：

1. 写函数，返回一个扑克牌列表，里面有52项，每一项是一个元组
   1. 例如：\[(‘红心’，2),(‘草花’，2), …(‘黑桃A’)]

```plain
# 答案
 def cards():
     num = []
     for i in range(2,11):
         num.append(i)
     num.extend(['J','Q','K','A'])
     type = ['红心','草花','方块','黑桃']
     result = []
     for i in num:
         for j in type:
             result.append((j,i))
     return result
 print(cards())
```

```
1. 写函数，传入n个数，返回字典{‘max’:最大值,’min’:最小值}
```

```plain
例如:min_max(2,5,7,8,4)
返回:{‘max’:8,’min’:2}
```

```plain
# 答案
 def max_min(*args):
     the_max = args[0]
     the_min = args[0]
     for i in args:
         if i > the_max:
             the_max = i
         if i < the_min:
             the_min = i
     return {'max': the_max, 'min': the_min}
 print(max_min(2, 4, 6, 48, -16, 999, 486, ))
```

1. 写函数，专门计算图形的面积
2. 其中嵌套函数，计算圆的面积，正方形的面积和长方形的面积
3. 调用函数area(‘圆形’,圆半径) 返回圆的面积
4. 调用函数area(‘正方形’,边长) 返回正方形的面积
5. 调用函数area(‘长方形’,长，宽) 返回长方形的面积

```plain
def area():
def 计算长方形面积():
    pass
def 计算正方形面积():
    pass
def 计算圆形面积():
    pass
```

```plain
# 答案
  import math
  print('''
  请按照如下格式输出：
      调用函数area(‘圆形’,圆半径) 返回圆的面积
      调用函数area(‘正方形’,边长) 返回正方形的面积
      调用函数area(‘长方形’,长，宽) 返回长方形的面积''')
  def area(name,*args):
      def areas_rectangle(x,y):
          return ("长方形的面积为：",x*y)
      def area_square(x):
          return ("正方形的面积为：",x**2)
      def area_round(r):
          return ("圆形的面积为：",math.pi*r*r)
      if name =='圆形':
          return area_round(*args)
      elif name =='正方形':
          return area_square(*args)
      elif name =='长方形':
          return areas_rectangle(*args)
  print(area('长方形', 3, 4))
  print(area('圆形', 3))
  print(area('正方形', 3))
```

1. 写函数，传入一个参数n，返回n的阶乘

```plain
例如:cal(7)
计算7*6*5*4*3*2*1
```

```plain
# 答案
def cal(n):
   res= 1
   for i in range(n,0,-1):
       # print(i)
       res = res*i
       print(res)
   return res
print(cal(7))
```

1. 编写装饰器，为多个函数加上认证的功能（用户的账号密码来源于文件），要求登录成功一次，后续的函数都无需再输入用户名和密码

```plain
# 答案
def login(func):
    def wrapper(*args,**kwargs):
        username = input("account:").strip()
        password = input("password:").strip()
        with open('userinfo.txt','r',encoding='utf-8') as f:
            userinfo = f.read().strip(',')
            userinfo = eval(userinfo)
            print(userinfo)
            if username in userinfo['name'] and password in userinfo['password']:
                print("success")
            else:
                print("pass")
    return wrapper
@login
def name():
    print("hello")
name()
```

#### 生成器和迭代器

1. 生成器和迭代器的区别？

```plain
# 答案
对于list、string、tuple、dict等这些容器对象,使用for循环遍历是很方便的。
在后台for语句对容器对象调用iter()函数。iter()是python内置函数。
iter()函数会返回一个定义了 next()方法的迭代器对象，它在容器中逐个访问容器内的
元素。next()也是python内置函数。在没有后续元素时，next()会抛出
一个StopIteration异常，通知for语句循环结束。
迭代器是用来帮助我们记录每次迭代访问到的位置，当我们对迭代器使用next()函数的
时候，迭代器会向我们返回它所记录位置的下一个位置的数据。实际上，在使用next()函数
的时候，调用的就是迭代器对象的_next_方法（Python3中是对象的_next_方法，
Python2中是对象的next()方法）。所以，我们要想构造一个迭代器，
就要实现它的_next_方法。但这还不够，python要求迭代器本身也是可迭代的，
所以我们还要为迭代器实现_iter_方法，而_iter_方法要返回一个迭代器，
迭代器自身正是一个迭代器，所以迭代器的_iter_方法返回自身self即可。
```

1. 生成器有几种方式获取value？

```plain
# 答案
两种方式获取：
   for  循环
   next 获取
```

1. 通过生成器写一个日志调用方法， 支持以下功能
2. 根据指令向屏幕输出日志
3. 根据指令向文件输出日志
4. 根据指令同时向文件&屏幕输出日志
5. 以上日志格式如下

```plain
2017-10-19 22:07:38 [1] test log db backup 3
2017-10-19 22:07:40 [2] user alex login success
#注意：其中[1],[2]是指自日志方法第几次调用，每调用一次输出一条日志
```

* 代码结构如下

```plain
def logger(filename,channel='file'):
"""
日志方法
:param filename: log filename
:param channel: 输出的目的地，屏幕(terminal)，文件(file)，屏幕+文件(both)
:return:
"""
...your code...
#调用
log_obj = logger(filename="web.log",channel='both')
log_obj.__next__()
log_obj.send('user alex login success')
```

#### 内置函数

1. 用map来处理字符串列表,把列表中所有人都变成sb,比方alex_sb

```plain
name=['alex','wupeiqi','yuanhao','nezha']
```

```plain
map()函数
map()是 Python 内置的高阶函数，它接收一个函数 f 和一个 list，并通过把
函数 f 依次作用在 list 的每个元素上，得到一个新的 list 并返回。
　　注意：map()函数在不改变原有的lisy，而是返回一个新的list
代码:
name=['alex','wupeiqi','yuanhao','nezha']
def sb(x):
   return x+'_sb'
res = map(sb,name)
print(list(res))
```

1. 用filter函数处理数字列表，将列表中所有的偶数筛选出来

```plain
num = [1,3,5,6,7,8]
```

```plain
num = [1,3,5,6,7,8]
def func(x):
   if x%2 == 0:
       return True
ret = filter(func,num)
print(list(ret))
```

1. 如下，每个小字典的name对应股票名字，shares对应多少股，price对应股票的价格

```plain
portfolio = [
{'name': 'IBM', 'shares': 100, 'price': 91.1},
{'name': 'AAPL', 'shares': 50, 'price': 543.22},
{'name': 'FB', 'shares': 200, 'price': 21.09},
{'name': 'HPQ', 'shares': 35, 'price': 31.75},
{'name': 'YHOO', 'shares': 45, 'price': 16.35},
{'name': 'ACME', 'shares': 75, 'price': 115.65}
]
```

计算购买每支股票的总价

用filter过滤出，单价大于100的股票有哪些

```plain
f = filter(lambda d:d['price']>=100,portfolio)
  print(list(f))
```

1、请分别介绍文件操作中不同的打开方式之间的区别：

| 模式 | 含义 |
| --- | --- |
| r | 文本只读模式 |
| rb | 二进制模式 这种方法是用来传输或存储，不给人看的 |
| r+ | 读写模式，只要有r，那么文件必须存在 |
| rb+ | 二进制读写模式 |
| w | 只写模式，不能读，用w模式打开一个已经存在的文件，如果有内容会清空，重新写 |
| wb | 以二进制方式打开，只能写文件，如果不存在，则创建 |
| w+ | 读写模式，先读后写，只要有w，会清空原来的文件内容 |
| wb+ | 二进制写读模式 |
| a | 追加模式，也能写，在文件的末尾添加内容 |
| ab | 二进制追加模式 |
| a+ | 追加模式，如果文件不存在，则创建文件，如果存在，则在末尾追加 |
| ab+ | 追读写二进制模式，从文件顶部读取文件，从文件底部添加内容，不存在则创建 |

2、有列表 li = \['alex', 'egon', 'smith', 'pizza', 'alen'], 请将以字母“a”开头的元素的首字母改为大写字母；

```plain
# 答案
li = ['alex', 'egon', 'smith', 'pizza', 'alen']
li_new = []
for i in li:
    if i.startswith('a'):
        li_new.append(i.capitalize())
    else:
        li_new.append(i)
print(li_new)
for i in range(len(li)):
    if li[i][0] == 'a':
        li[i] = li[i].capitalize()
    else:
        continue
print(li)
```

3、有如下程序, 请给出两次调用`show_num`函数的执行结果，并说明为什么：

```plain
num = 20
  def show_num(x=num):
    print(x)
  show_num()
  num = 30
  show_num()
```

```plain
# 答案
  如果函数收到的是一个不可变对象（比如数字、字符或者元组）的引用，就不能直接修改原始对象，相当于通过“传值’来传递对象，此时如果想改变这些变量的值，可以将这些变量申明为全局变量。
```

4、有列表 li = \['alex', 'egon', 'smith', 'pizza', 'alen'], 请以列表中每个元素的第二个字母倒序排序；

```plain
# 答案
  print(sorted(li, key=lambda x: x[1], reverse=True))
```

5、有名为`poetry.txt`的文件，其内容如下，请删除第三行；

```plain
昔人已乘黄鹤去，此地空余黄鹤楼。
  黄鹤一去不复返，白云千载空悠悠。
  晴川历历汉阳树，芳草萋萋鹦鹉洲。
  日暮乡关何处是？烟波江上使人愁。
```

```plain
# 答案
  方法一：
  import os
  p = 'poetry.txt'
  file = open(p,'r',encoding='utf-8')
  print(file)
  pnew = '%s.new'%p
  filenew = open(pnew,'w',encoding='utf-8')
  str1 = '晴川历历汉阳树，芳草萋萋鹦鹉洲。'
  for i in file:
      if str1 in i:
          i = ''
          filenew.write(i)
      else:
          filenew.write(i)
  file.close()
  filenew.close()
  os.replace(pnew,p)
  方法二：逐行读取文件
  import os
  f1=open('poetry.txt', 'r',encoding='utf-8')
  str='晴川历历汉阳树，芳草萋萋鹦鹉洲。'
  with open('poetry1.txt', 'w', encoding='utf-8') as f2:
      ff1='poetry.txt'
      ff2='poetry1.txt'
      for line in f1:
          if str in line:
              line=''
              f2.write(line)
          else:
              f2.write(line)
  f1.close()
  f2.close()
  os.replace(ff2,ff1)
```

6、有名为`username.txt`的文件，其内容格式如下，写一个程序，判断该文件中是否存在"alex", 如果没有，则将字符串"alex"添加到该文件末尾，否则提示用户该用户已存在；

```plain
pizza
  alex
  egon
```

```plain
# 答案
  with open('username.txt','r+',encoding='utf-8') as f:
    str1 = 'alexx'
    i = f.read()
    print(i)
    if str1 in i:
        print("the user already exist in")
    else:
        f.write('\nalexx')
```

7、有名为user_info.txt的文件，其内容格式如下，写一个程序，删除id为100003的行；

```plain
pizza,100001
  alex, 100002
  egon, 100003
```

```plain
# 答案
  import os
  a = 'user_info.txt'
  b = 'user_info1.txt'
  with open(a,'r',encoding='utf-8') as f:
      with open(b, 'w', encoding='utf-8') as f2:
          for i in f:
              if '100003' in i:
                  pass
              else:
                  f2.write(i)
  os.replace(b,a)
```

8、有名为user_info.txt的文件，其内容格式如下，写一个程序，将id为100002的用户名修改为`alex li`；

```plain
pizza,100001
  alex, 100002
  egon, 100003
```

```plain
# 答案
  file = 'user_info.txt'
  old_str = '100002'
  new_str = 'alex, 100002'
  file_data=''
  with open(file,'r',encoding='utf-8') as f1:
      for line in f1:
          if old_str in line:
              line =new_str
          file_data +=line
          with open(file,'w',encoding='utf-8') as f1:
              f1.write(file_data)
```

9、写一个计算每个程序执行时间的装饰器；

```plain
# 答案
  import time
  def timer(func):
      def wrapper(*args,**kwargs):
          start_time = time.time()
          func(*args)
          stop_time = time.time()
          print(stop_time-start_time)
      return wrapper
  @timer
  def sayhi():
      print("hello word")
  sayhi()
```

10、lambda是什么？请说说你曾在什么场景下使用lambda？

```plain
# 答案
lambda函数就是可以接受任意多个参数(包括可选参数)并且返回单个表达式值得函数
    好处：
        1.lambda函数比较轻便，即用即扔，适合完成只在一处使用的简单功能
        2.匿名函数，一般用来给filter，map这样的函数式编程服务
        3.作为回调函数，传递给某些应用，比如消息处理
```

11、题目：写一个摇骰子游戏，要求用户压大小，赔率一赔一。

要求：三个骰子，摇大小，每次打印摇骰子数。

```plain
import random
def roll_dice(numbers=3, points=None):
    """
     定义骰子，循环三次
    :param numbers:
    :param points:
    :return:
    """
    print('----- 摇骰子 -----')
    if points is None:
        points = []
    while numbers > 0:
        point = random.randrange(1, 7)
        points.append(point)
        numbers -= 1
    return points
def roll_result(total):
    """
    定义大小，三个大或者一个小两个大。三个小或者两个小一个大
    :param total:
    :return:
    """
    is_big = 11 <= total <= 18
    is_small = 3 <= total <= 10
    if is_big:
        return "big"
    elif is_small:
        return "small"
def start_game():
    your_money = 1000
    while your_money > 0:
        print('----- 游戏开始 -----')
        choices = ["大", "小"]
        your_choice = input("请下注， 大 or 小")
        your_bet = input("下注金额：")
        if your_choice in choices:
            points = roll_dice()
            total = sum(points)
            you_win = your_choice == roll_result(total)
            if you_win:
                your_money = your_money + int(your_bet)
                print("骰子点数", points)
                print("恭喜， 你赢了%s元， 你现在的本金%s 元" % (your_bet, your_money + int(your_bet)))
            else:
                your_money = your_money - int(your_bet)
                print("骰子点数", points)
                print("很遗憾， 你输了%s元， 你现在的本金%s 元" % (your_bet, your_money - int(your_bet)))
        else:
            print('格式有误，请重新输入')
    else:
        print("game over")
start_game()
```

> 更新: 2021-05-08 18:23:16  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/osdkv4>