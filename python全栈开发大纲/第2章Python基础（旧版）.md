# 第2章 Python基础  （旧版）

# 2.1 上节拾遗

## 本节重点：

* 让学员了解变量在内存中的存储情况
* 对身份运算知识点的补充

## 声明

本章所有知识点讲述的均为在**程序运行中**变量的状态。

本章中的内容都结合str数据类型，同样适用于数字类型，老师可在课程之中说明。

## 变量的创建与id

### 例1:name = 'oldboy'

首先，当我们定义了一个变量name = ‘oldboy’的时候，在内存中其实是做了这样一件事：

程序开辟了一块内存空间，将‘oldboy’存储进去，再让变量名name指向‘oldboy’所在的内存地址。如下图所示：

<!-- OCR_START -->
- 'oldboy
- name
<!-- OCR_END -->

### 例2:两个变量名一个值

> **提问：当我执行下面这段代码的时候，程序是怎么处理的呢？**

```plain
name1 = 'oldboy'
name2 = 'oldboy'
```

我们猜想会有两种可能:

第一种情况:程序分别在内存中开辟了两块儿空间来存储‘oldboy’这个值，并且让name1和name2指向这两个值。如下左图

第二种情况:由于两个值内容一致，所以程序只开辟一块儿空间存储‘oldboy’，并让name1和name2只想着个值。如下右图

> 提问：大家来猜测一下会是哪种情况？

<!-- OCR_START -->
- 'oldboy
- name1
- name2
<!-- OCR_END -->

其实上面的两种猜想都是对的。正常情况下字符串在内存里就是如我们猜想的第一种情况一样，每一次创建一个变量都会在内存中申请一块儿空间。

但是，python认为一些“看起来像python标识符的字符”和小整数字在开发中是常用的，因此出于节省内存的角度思考，对于这部分字符串和数字做出了优化\[-5,257)，python解释器会由于要定义的新变量内容与之前定义过的变量内容相同而不让这部分内容占用新的内存空间。

我们如何证明我们的想法呢？

python为我们提供了一个**id()方法**，可以查看一个变量的内存地址。

```plain
>>> name1 = 'oldboy'
>>> name2 = 'oldboy'
>>> name1_id = id(name1)
>>> name2_id = id(name2)
>>> print(name1_id,name2_id)
(4459387232, 4459387232)
```

执行完这段代码就基本验证了我们的思想，由于‘oldboy’是一个简单的字符串，因此python解释器做了优化，内存里只有一个‘oldboy’，name1和name2都指向同一块儿内存地址。

如果是长字符串呢？就米有优化机制啦！

```plain
>>> a = 'this is a very long sentence'
>>> b = 'this is a very long sentence'
>>> id(a)
4394464720
>>> id(b)
4394464640
```

对于\[-5,257)范围内的数字也有优化机制：

```plain
>>> a = 256
>>> b = 256
>>> id(a)
4297546112
>>> id(b)
4297546112
>>> a = -5
>>> b = -5
>>> id(a)
4297537760
>>> id(b)
4297537760
```

但是超过这个范围可就不太行了：

```plain
>> a=257
>>> b=257
>>> id(a)
4402490032
>>> id(b)
4403650768
>> a = -6
>>> b=-6
>>> id(a)
4402490032
>>> id(b)
4403650768
```

### 例3:一个变量名2个值

> **提问：如果像下面这样写自己的代码，最终打印name会得到什么结果？**

```plain
name = 'oldboy'
name = 'alex'
print(name)
```

我想大家的答案是一致的，name此时应该是‘alex’，当我们在程序中对变量进行重复赋值时，就是对一个变量进行修改.

代码解读：

程序先申请了一块内存空间来存储‘oldboy’，让name变量名指向这块内存空间

读到name=‘alex’之后又申请了另一块内存空间来存储‘alex’，并让原本指向‘oldboy’内存的链接断开，让name再指向‘alex’。

如下图所示：

<!-- OCR_START -->
- 'oldboy
- name
- 'alex'
<!-- OCR_END -->

### 例4:变量的赋值与修改

> **提问：如果像下面这样写自己的代码，最终打印name1和name2会分别得到什么结果？**

```plain
name1 = 'oldboy'
name2 = name1
name1 = 'alex'
print(name1,name2)
```

这里大家就会产生一些争论了，先执行一下给大家看。

<!-- OCR_START -->
- 1
- name1 =
- 'oldboy
- 2
- name2=name1
- 3
- name1='alex
- 4
- print(name1)
- 5
- print(name2)
- 6
- Runtest
- /Library/Framew
- alex
<!-- OCR_END -->

要想知道上面问题的结果是为什么，首先要了解在内存中两个变量的存储情况

<!-- OCR_START -->
- 'alex'
- name1
- "oldboy'
- name2
<!-- OCR_END -->

从上面的示意图中我们可以知道，当执行name2=name1这句话的时候，事实上是让name2指向了‘oldboy’所在的内存地址。

修改name1的值，相当于断开了name1到‘oldboy’的链接，重新建立name1和‘alex’之间的链接。在这个过程中，始终没有影响到name2和‘oldboy‘之间的关系，因此name2还是‘oldboy’，而name1变成了‘alex’。

## 身份运算

<!-- OCR_START -->
- 运算符
- 描述
- 实例
- is
- is是判断两个标识符是不是引用
- xisy，类似id(x)==id(y)，如果引|用的是同一个对象则返回True
- 自一个对象
- 否则返回False
- is not
- isnot是判断两个标识符是不是
- xisnoty，类似id(a)！=id(b)。如果引|用的不是同一个对象则返回
- 引引用自不同对象
- 结果True，否则返回False。
<!-- OCR_END -->

# 2.2 二进制

## 本节重点：

* 让学生了解二进制表示方法的意义
* 让学生掌握二进制与十进制之间的转换

## 引子（各位讲师请自行发挥）

首先，计算机一共就能做两件事：计算和通信

那在讲计算机之前，我们先来讲一个故事，大家知道古时候的中国是如何通信的么？

假如，战国时期两个国家要打仗了，我们垒了城墙，每隔一段就有兵镇守，现在有人来攻打我们了，然后我们是不是得通知其他人有人来打我们来了？怎么通知？

1.派个人跑着去？等人回来，仗打完了

2.点狼烟信号

好了，现在有5000精兵来打你了，你点了根狼烟搬救兵，从东边来了10个人，西边来了10个人，20个人来了，和你们一起战死了。

这怎么办？

我们不能这么保守了，只要我一点狼烟说有人来打我们了，先来他10000人，结果来了200个敌人，我们呼啦啦来一大堆人，是不是浪费资源啊？

我们是不是除了告诉人家要打仗了，还得告诉别人来了多少人啊？那我们怎么告诉？

来一个人点一根？来了5000人，点5000根，不用打了，自己给自己烧死了

那好我们就约定，来10个人点1根，来100个人点2根，来1000个人点3根，来5000个点4根，来10000个点5根。。。以此类推

好了现在我们有一个变态的需求，要精确的传送到底有多少个敌人？

> 每次报告信号之前得把人数清楚了再报告，我们怎么办？
>
> 这里让学生自由发挥5分钟

好了，现在来看看我的方法。。。



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



> 假如我们有20个狼烟孔，狼烟孔点燃了代表有人，没点燃代表没人。
>
> 这时候，1个敌人来了，点1根狼烟



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



> 现在2个敌人来了，怎么办？再点一根狼烟，把20根狼烟都点上能表示20个人。。。这肯定不行。我们这样，把
>
> 第一个狼烟孔灭掉，点燃第二个，这样只点燃第二个孔就代表两个人



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



> 现在3个敌人来了，怎么办？把第一个狼烟孔点着了就表示3个人



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



> 那如果来了4个人敌人，现在有两根狼烟都点着了只能表示3个人，表示4个人，做得到么？臣妾做不到啊～～～
>
> 但是现在使用2根狼烟原来只能表示2个人，现在我们是不是表达了4种状态(0,1,2,3)（**该着重表达原来的一根狼烟只能表达一个人，现在却能表达四种状态了**）。
>
> 再说眼下这4个敌人，咱们用这两根狼烟已经表现不了了，所以我们只好再点一根，同时我们还要灭掉前面的两根，因为第三根这一根狼烟就可以表示4个敌人



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



讲啊讲，突然之间发现每一位恰好就是2的n次方！

。。。剩下的你们自己发挥吧。。。

## 二进制定义

二进制是计算技术中广泛采用的一种[数制](http://baike.baidu.com/item/%E6%95%B0%E5%88%B6)。[二进制数](http://baike.baidu.com/item/%E4%BA%8C%E8%BF%9B%E5%88%B6%E6%95%B0)据是用0和1两个[数码](http://baike.baidu.com/item/%E6%95%B0%E7%A0%81)来表示的数。它的基数为2，进位规则是“逢二进一”，借位规则是“借一当二”，由18世纪德国数理哲学大师[莱布尼兹](http://baike.baidu.com/item/%E8%8E%B1%E5%B8%83%E5%B0%BC%E5%85%B9)发现。当前的[计算机系统](http://baike.baidu.com/item/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%B3%BB%E7%BB%9F)使用的基本上是[二进制系统](http://baike.baidu.com/item/%E4%BA%8C%E8%BF%9B%E5%88%B6%E7%B3%BB%E7%BB%9F)，数据在[计算机](http://baike.baidu.com/item/%E8%AE%A1%E7%AE%97%E6%9C%BA)中主要是以补码的形式存储的。计算机中的二进制则是一个非常微小的开关，用“开”来表示1，“关”来表示0。

我们发现刚刚我们讲述的狼烟的故事和现在这个新理论出奇相似。假设狼烟点燃用1表示，狼烟灭掉用0表示，那么刚刚我们用狼烟表示百万雄师的理论就可以用在计算机上，这种表示数字的方式就叫做二进制。

你可能会觉得发明计算机的人思路轻奇，为什么要多此一举的用这种方式来表达数字，但事实上计算机不像我们这样智能，CPU是一个包含上百万个精巧的[晶体管](https://www.baidu.com/s?wd=%E6%99%B6%E4%BD%93%E7%AE%A1\&tn=44039180_cpr\&fenlei=mv6quAkxTZn0IZRqIHckPjm4nH00T1YkrHfzmHbLuWf1nH9WrjIW0ZwV5Hcvrjm3rH6sPfKWUMw85HfYnjn4nH6sgvPsT6KdThsqpZwYTjCEQLGCpyw9Uz4Bmy-bIi4WUvYETgN-TLwGUv3EnWckPjmkrj03)的芯片集合，[晶体管](https://www.baidu.com/s?wd=%E6%99%B6%E4%BD%93%E7%AE%A1\&tn=44039180_cpr\&fenlei=mv6quAkxTZn0IZRqIHckPjm4nH00T1YzrHF9PjNBujwhmhN9mWDL0ZwV5Hcvrjm3rH6sPfKWUMw85HfYnjn4nH6sgvPsT6KdThsqpZwYTjCEQLGCpyw9Uz4Bmy-bIi4WUvYETgN-TLwGUv3EPjb3PHmvPH61Pjm3n1cdnW0Y)表达感情的方式很简单，就是通过高低电压(有电没电)，低电压的时候表示0，高电压的时候表示1，因此最终能让计算机理解的就只有0和1而已。

## 二进制与十进制转换

其实刚刚在无形中我们已经将10进制转换成2进制了，现在我们要再总结一遍。

刚才我们已经发现，二进制的第n位代表的十进制值都刚好遵循着2的n次方这个规律

**填位大法：**

先把他们代表的值依次写出来，然后再根据10进制的值把数填到相应位置，就好了～～～

十进制转二进制方法相同，只要对照二进制为1的那一位对应的十进制值相加就可以了。

<!-- OCR_START -->
| 排名 | 名称 | 排名(上年) |
| --- | --- | --- |
| 128 | 64 | 32 |
| 16 | 中 | 4 |
| 2 | 一 | 20 |
| 1 | Q | Q |
| Q | 200 | 1 |
<!-- OCR_END -->

# 2.3 字符编码

本节重点：

* 让学生了解为什么会有编码
* 让学生了解字符编码的种类及其发展顺序
* py2和py3编码区别

## 引子

通过上一节讲的二进制的知识，大家已经知道计算机只认识二进制，生活中的数字要想让计算机理解就必须转换成二进制。十进制到二进制的转换只能解决计算机理解数字的问题，那么文字要怎么让计算机理解呢？

于是我们就选择了一种曲线救国的方式，既然数字可以转换成十进制，我们只要想办法把文字转换成数字，这样文字不就可以表示成二进制了么？



<!-- OCR_START -->
> 文字
> 十进制
> 二进制
<!-- OCR_END -->



> 可是文字应该怎么转换成数字呢？就是强制转换

我们自己强行约定了一个表，把文字和数字对应上，这张表就相当于翻译，我们可以拿着一个数字来对比对应表找到相应的文字，反之亦然。

## ASCII码

> 可以先让学生看图片，然后再介绍ascii码

假如我们就已经有这么一张表了
<!-- OCR_START -->
- 十进
- 字符
- 十进制
- 字符十进制
- 16
- 32
- 48
- 64
- 80
- 96
- 112
- 128
- 144
- 160
- 176
- 192
- 208
- 224
- a.
- 240
- 17
- 33
- 49
- 65
- 81
- 97
- 113
- 129
- 9
- 145
- 161
- 177
- 193
- 209
- 225
- 241
- 2
- 18
- 1
- 34
- 50
- 66
- 82
- 98
- 114
- 130
- 146
- 162
- 6
- 178
- 194
- 210
- 226
- 242
- AI
- 3
- 19
- 35
- 51
- 67
- 83
- 99
- 115
- 131
- 147
- 163
- 179
- 195
- 211
- 227
- 243
- 20
- 36
- 52
- 68
- 84
- 100
- 116
- 132
- 148
- 164
- 180
- 196
- 212
- 228
- 244
- 5
- 69
- 21
- 37
- 85
- 101
- 117
- 133
- 149
- 165
- 181
- 197
- 213
- 229
- 245
- 22
- 38
- 54
- 70
- 86
- 102
- 118
- 134
- 150
- 166
- 182
- 198
- 214
- 230
- 246
- 23
- 39
- 55
- 7
- 71
- 87
- 103
- 119
- 135
- 151
- 167
- 183
- 199
- 215
- 231
- 247
- 24
- 40
- 56
- 8
- 72
- 88
- 104
- 120
- 136
- 152
- 168
- 184
- 200
- 216
- 232
- 248
- 25
- 41
- 57
- 73
- 89
- 105
- 121
- 137
- 153
- 169
- 185
- 201
- 217
- 233
- 249
- 10
- 26
- 42
- 58
- 74
- 90
- 106
- 122
- 138
- 154
- 170
- 186
- 202
- 218
- 234
- 250
- 11
- 27
- 43
- 59
- 75
- 107
- 123
- 139
- 155
- 91
- 171
- 12
- 187
- 203
- 219
- 235
- 251
- 1/4
- 28
- 44
- 60
- 76
- 92
- 108
- 124
- 140
- 156
- 172
- 188
- 204
- 220
- 236
- 252
- 13
- 29
- 45
- 61
- 77
- 93
- 109
- 125
- 141
- 157
- 173
- 189
- 205
- 221
- 237
- 253
- 30
- 46
- 62
- 78
- 94
- 110
- 126
- 142
- 158
- Pts
- 174
- 190
- 206
- 222
- 238
- 254
- 15
- 31
- 47
- 63
- 79
- 95
- 111
- 127
- 143
- 159
- 175
- 191
- 207
- 223
- 239
- 255
<!-- OCR_END -->

ASCII（American Standard Code for Information Interchange，美国信息交换标准代码）是基于[拉丁字母](http://baike.baidu.com/item/%E6%8B%89%E4%B8%81%E5%AD%97%E6%AF%8D)的一套电脑编码系统，主要用于显示现代[英语](http://baike.baidu.com/item/%E8%8B%B1%E8%AF%AD/109997)和其他[西欧](http://baike.baidu.com/item/%E8%A5%BF%E6%AC%A7)语言。它是现今最通用的单字节编码系统，并等同于[国际](http://baike.baidu.com/item/%E5%9B%BD%E9%99%85)标准ISO/IEC 646。

由于计算机是美国人发明的，因此，最早只有127个字母被编码到计算机里，也就是大小写英文字母、数字和一些符号，这个编码表被称为`ASCII`编码，比如大写字母 `A`的编码是`65`，小写字母 `z`的编码是`122`。后128个称为[扩展ASCII](http://baike.baidu.com/item/%E6%89%A9%E5%B1%95ASCII)码。

那现在我们就知道了上面的字母符号和数字对应的表是早就存在的。那么根据现在有的一些十进制，我们就可以转换成二进制的编码串。

比如

```plain
一个空格对应的数字是0          翻译成二进制就是0（注意字符'0'和整数0是不同的）
一个对勾√对应的数字是251       翻译成二进制就是11111011
```

> **提问：假如我们要打印两个空格一个对勾 写作二进制就应该是 0011111011， 但是问题来了，我们怎么知道从哪儿到哪儿是一个字符呢？**
>
> 论断句的重要性与必要性：
>
> 上次在网上看到个新闻，讲是个小偷在上海被捕时高喊道：“我一定要当上海贼王！”

正是由于这些字符串长的长，短的短，写在一起让我们难以分清每一个字符的起止位置，所以聪明的人类就想出了一个解决办法，既然一共就这255个字符，那最长的也不过是11111111八位，不如我们就把所有的二进制都转换成8位的，不足的用0来替换。

这样一来，刚刚的两个空格一个对勾就写作000000000000000011111011，读取的时候只要每次读8个字符就能知道每个字符的二进制值啦。

在这里，每一位0或者1所占的空间单位为bit(比特)，这是计算机中最小的表示单位

每8个bit组成一个字节，这是计算机中最小的存储单位(毕竟你是没有办法存储半个字符的)orz～

> 要不要举例子说单位？就像我们形容长度会有厘米、分米、米之分，在计算机里也有自己的计量数据大小的单位
>
> 人民币的例子：给了你好多钱，假如没有万-十万

```plain
bit           位，计算机中最小的表示单位
8bit = 1bytes 字节，最小的存储单位，1bytes缩写为1B
1KB=1024B
1MB=1024KB
1GB=1024MB
1TB=1024GB
1PB=1024TB
1EB=1024PB
1ZB=1024EB
1YB=1024ZB
1BB=1024YB
```

> 提问：学完ascii码，作为一个英文程序员来说，基本圆满了。但是作为一个中国程序员，你是不是觉得少了点儿什么？（再给学生看一下ascii码表）

## GBK和**GB2312**

显然，对于我们来说能在计算机中显示中文字符是至关重要的，然而刚学习的**ASCII**表里连一个偏旁部首也没有。所以我们还需要一张关于中文和数字对应的关系表。之前我们已经看到了，一个字节只能最多表示256个字符，要处理中文显然一个字节是不够的，所以我们需要采用两个字节来表示，而且还不能和**ASCII**编码冲突，所以，中国制定了**GB2312**编码，用来把中文编进去。

> 你可以想得到的是，全世界有上百种语言，日本把日文编到**Shift_JIS**里，韩国把韩文编到**Euc-kr**里，
>
> 各国有各国的标准，就会不可避免地出现冲突，结果就是，在多语言混合的文本中，显示出来会有乱码。

## **Unicode**

因此，**Unicode**应运而生。**Unicode**把所有语言都统一到一套编码里，这样就不会再有乱码问题了。

**Unicode**标准也在不断发展，但最常用的是用两个字节表示一个字符（如果要用到非常偏僻的字符，就需要**4**个字节）。现代[操作系统](http://lib.csdn.net/base/operatingsystem)和大多数编程语言都直接支持**Unicode**。

现在，捋一捋**ASCII**编码和**Unicode**编码的区别：

**ASCII**编码是**1**个字节，而**Unicode**编码通常是**2**个字节。

字母**A**用**ASCII**编码是十进制的**65**，二进制的**01000001**；

字符**0**用**ASCII**编码是十进制的**48**，二进制的**00110000**；

汉字“中”已经超出了**ASCII**编码的范围，用**Unicode**编码是十进制的**20013**，二进制的**01001110 00101101**。

你可以猜测，如果把**ASCII**编码的**A**用**Unicode**编码，只需要在前面补**0**就可以，因此，**A**的**Unicode**编码是**00000000 01000001**。

> 新的问题又出现了：如果统一成**Unicode**编码，乱码问题从此消失了。但是，如果你写的文本基本上全部是英文的话，用**Unicode**编码比**ASCII**编码需要多一倍的存储空间，在存储和传输上就十分不划算。

## **UTF-8**

所以，本着节约的精神，又出现了把**Unicode**编码转化为“可变长编码”的**UTF-8**编码。**UTF-8**编码把一个**Unicode**字符根据不同的数字大小编码成**1-6**个字节，常用的英文字母被编码成**1**个字节，汉字通常是**3**个字节，只有很生僻的字符才会被编码成**4-6**个字节。如果你要传输的文本包含大量英文字符，用**UTF-8**编码就能节省空间：

| 字符 | ASCII | Unicode | UTF-8 |
| --- | --- | --- | --- |
| A | 01000001 | 00000000 01000001 | 01000001 |
| 中 | x | 01001110 00101101 | 11100100 10111000 10101101 |

从上面的表格还可以发现，**UTF-8**编码有一个额外的好处，就是**ASCII**编码实际上可以被看成是**UTF-8**编码的一部分，所以，大量只支持**ASCII**编码的历史遗留软件可以在**UTF-8**编码下继续工作。

搞清楚了**ASCII**、**Unicode**和**UTF-8**的关系，我们就可以总结一下现在计算机系统通用的字符编码工作方式：

在计算机内存中，统一使用**Unicode**编码，当需要保存到硬盘或者需要传输的时候，就转换为**UTF-8**编码。

用记事本编辑的时候，从文件读取的**UTF-8**字符被转换为**Unicode**字符到内存里，编辑完成后，保存的时候再把**Unicode**转换为**UTF-8**保存到文件。

**文件存取编码转换图**

<!-- OCR_START -->
- 内存中unicode编码
- 读取
- 保存
- 转换为unicode
- 转换为utf8
- 文件UTF-8编码
<!-- OCR_END -->

## 常用编码介绍一览表

| 编码 | 制定时间 | 作用 | 所占字节数 |
| --- | --- | --- | --- |
| ASCII | 1967年 | 表示英语及西欧语言 | 8bit/1bytes |
| GB2312 | 1980年 | 国家简体中文字符集，兼容ASCII | 2bytes |
| Unicode | 1991年 | 国际标准组织统一标准字符集 | 2bytes |
| GBK | 1995年 | GB2312的扩展字符集，支持繁体字，兼容GB2312 | 2bytes |
| UTF-8 | 1992年 | 不定长编码 | 1-3bytes |

# 2.4 基本数据类型 数字

## 本节重点

1.学员了解整形、布尔型、浮点型以及复数型之间的定义与联系

2.学员掌握数字类型的基本运算方法

3.学员能熟练掌握数字常用操作

## 布尔型

bool型只有两个值：True和False

之所以将bool值归类为数字，是因为我们也习惯用1表示True，0表示False。

## 整型

Python中的整数属于int类型，默认用十进制表示，此外也支持二进制，八进制,十六进制表示方式。

**进制转换**

尽管计算机只认识二进制，但是为了迎合我们的习惯，python中的数字默认还是十进制。还提供了一些方法来帮助我们做转换。比如是进制转换为二进制使用bin方法，在转换结果前面还会加上‘0b’表示是一个二进制书。

既然十进制可以转换为二进制，那么其实使用同样的原理也可以转换为其他进制，python也为我们提供了十进制转换成八进制和十六进制的方法，分别是oct和hex。八进制前面以‘0o’标示，十六进制以‘0x’标示

```plain
>>> bin(10)
'0b1010'
>>> oct(10)
'0o12'
>>> hex(10)
'0xa'
```

**取余运算(%)**

```plain
>>> 5%2
1
>>> 16%4
0
>>> 16%7
2
```

\*\*算术运算(+ - \* / // divmod **)**

```plain
>>> 2+3
5
>>> 2-3
-1
>>> 2*3
6
>>> 3/2
1.5
>>> 3//2
1
>>> divmod(16,3)
(5, 1)
>>> 2**3
8
```

## 浮点型

<!-- OCR_START -->
- 整数
- float
- 有理数
- 有限小数
- 浮点型
- 分数
- 实数
- 无限循环小数
- 复数
- 无理数一无限不循环小数
- 虚数
<!-- OCR_END -->

> 浮点数是属于[有理数](http://baike.baidu.com/view/1197.htm)中某特定[子集](http://baike.baidu.com/view/276935.htm)的数的数字表示，在计算机中用以近似表示任意某个[实数](http://baike.baidu.com/view/14749.htm)。具体的说，这个实数由一个[整数](http://baike.baidu.com/view/71484.htm)或[定点数](http://baike.baidu.com/view/686808.htm)（即[尾数](http://baike.baidu.com/view/344255.htm)）乘以某个基数（计算机中通常是2）的整数次幂得到，这种表示方法类似于基数为10的[科学计数法](http://baike.baidu.com/view/41154.htm)。

好了，我们来解释上面那句装。。。的话：

Python的浮点数就是数学中的小数(alex一定要强调float是有限小数或无限循环小数，就好像谁真的关心似的)。

在运算中，整数与浮点数运算的结果也是一个浮点数。

**为什么要叫做float浮点型？**

```plain
浮点数也就是小数，之所以称为浮点数，是因为按照科学记数法表示时，
一个浮点数的小数点位置是可变的，比如，
1.23*109和12.3*108是相等的。
浮点数可以用数学写法，如1.23，3.14，-9.01，等等。但是对于很大或很小的浮点数，就必须用科学计数法表示，把10用e替代：
1.23*109就是1.23e9，或者12.3e8，0.000012可以写成1.2e-5，等等。
整数和浮点数在计算机内部存储的方式是不同的，整数运算永远是精确的而浮点数运算则可能会有四舍五入的误差。
```

**关于小数不精准问题**

Python默认的是17位精度,也就是小数点后16位，尽管有16位，但是这个精确度却是越往后越不准的。

首先，这个问题不是只存在在python中，其他语言也有同样的问题

其次，小数不精准是因为在转换成二进制的过程中会出现无限循环的情况，在约省的时候就会出现偏差。

> 比如：11.2的小数部分0.2转换为2进制则是[无限循环](https://www.baidu.com/s?wd=%E6%97%A0%E9%99%90%E5%BE%AA%E7%8E%AF\&tn=44039180_cpr\&fenlei=mv6quAkxTZn0IZRqIHckPjm4nH00T1Ykuhf3P1bLuWckmhRYujfL0ZwV5Hcvrjm3rH6sPfKWUMw85HfYnjn4nH6sgvPsT6KdThsqpZwYTjCEQLGCpyw9Uz4Bmy-bIi4WUvYETgN-TLwGUv3EnHRLn1bkn1Rdnjc3PWbvnHD3n0)的00110011001100110011...
>
> 单精度在存储的时候用23bit来存放这个尾数部分（前面9比特存储指数和符号）；同样0.6也是[无限循环](https://www.baidu.com/s?wd=%E6%97%A0%E9%99%90%E5%BE%AA%E7%8E%AF\&tn=44039180_cpr\&fenlei=mv6quAkxTZn0IZRqIHckPjm4nH00T1Ykuhf3P1bLuWckmhRYujfL0ZwV5Hcvrjm3rH6sPfKWUMw85HfYnjn4nH6sgvPsT6KdThsqpZwYTjCEQLGCpyw9Uz4Bmy-bIi4WUvYETgN-TLwGUv3EnHRLn1bkn1Rdnjc3PWbvnHD3n0)的；

这里有一个问题，就是当我们的计算需要使用更高的精度（超过16位小数）的时候该怎么做呢？

```plain
#借助decimal模块的“getcontext“和“Decimal“ 方法
>>> a = 3.141592653513651054608317828332
>>> a
3.141592653513651
>>> from decimal import *
>>> getcontext()
Context(prec=50, rounding=ROUND_HALF_EVEN, Emin=-999999, Emax=999999, capitals=1, clamp=0, flags=[FloatOperation], traps=[InvalidOperation, DivisionByZero, Overflow])
>>> getcontext().prec = 50
>>> a = Decimal(1)／Decimal(3)#注，在分数计算中结果正确，如果直接定义超长精度小数会不准确
>>> a
Decimal('0.33333333333333333333333333333333333333333333333333')
>>> a = '3.141592653513651054608317828332'
>>> Decimal(a)
Decimal('3.141592653513651054608317828332')
```

```plain
#不推荐：字符串格式化方式，可以显示，但是计算和直接定义都不准确，后面的数字没有意义。
>>> a = ("%.30f" % (1.0/3))  
>>> a  
'0.333333333333333314829616256247'
```

## 复数

从上面的图中我们就可以看出，复数complex是由实数和虚数组成的

要了解复数，其实关于复数还需要先了解虚数。虚数(就是虚假不实的数):平方为复数的数叫做虚数。

复数是指能写成如下形式的数a+bi，这里a和b是实数，i是虚数单位(即-1开根)。在复数a+bi中，a称为复数的实部，b称为复数的虚部(虚数是指平方为负数的数)，i称为虚数单位。

当虚部等于零时，这个复数就是实数；当虚部不等于零时，这个复数称为虚数。

*注，虚数部分的字母j大小写都可以。*

# 2.5 基本数据类型 字符串

## 本节重点

1.让学员理解字符串数据类型出现的意义

2.让学员掌握字符串的定义和特性

3.学员能熟练掌握字符串常用操作，并了解其他工厂方法

4.教会学生看源码技能

## 字符串的定义与创建

字符串是一个有序的字符的集合，用于存储和表示基本的文本信息，' '或'' ''或''' '''中间包含的内容称之为字符串

**创建：**

```plain
s = 'Hello,Eva！How are you?'
```

## 字符串的特性与常用操作

特性：

1.按照从左到右的顺序定义字符集合，下标从0开始顺序访问，有序

<!-- OCR_START -->
| str | 排名 |
| --- | --- |
| h | e |
| 索引 | 1 |
| 2 | 3 |
<!-- OCR_END -->

补充：

1.字符串的单引号和双引号都无法取消特殊字符的含义，如果想让引号内所有字符均取消特殊意义，在引号前面加r，如name＝r'l\thf'

2.unicode字符串与r连用必需在r前面，如name＝ur'l\thf'

**常用操作：**

```plain
#索引
s = 'hello'
>>> s[1]
'e'
>>> s[-1]
'o'
>>> s.index('e')
1
#查找
>>> s.find('e')
1
>>> s.find('i')
-1
#移除空白
s = '  hello,world!  '
s.strip()
s.lstrip()
s.rstrip()
s2 = '***hello,world!***'
s2.strip('*')
#长度
>>> s = 'hello,world'
>>> len(s)
11
#替换
>>> s = 'hello world'
>>> s.replace('h','H')
'Hello world'
>>> s2 = 'hi，how are you？'
>>> s2.replace('h','H')
'Hi，How are you？'
#切片
>>> s = 'abcdefghigklmn'
>>> s[0:7]
'abcdefg'
>>> s[7:14]
'higklmn'
>>> s[:7]
'abcdefg'
>>> s[7:]
'higklmn'
>>> s[:]
'abcdefghigklmn'
>>> s[0:7:2]
'aceg'
>>> s[7:14:3]
'hkn'
>>> s[::2]
'acegikm'
>>> s[::-1]
'nmlkgihgfedcba'
```

## 字符串的工厂函数

> 教会学员看源码

```plain
class str(object):
    """
    str(object='') -> str
    str(bytes_or_buffer[, encoding[, errors]]) -> str
    Create a new string object from the given object. If encoding or
    errors is specified, then the object must expose a data buffer
    that will be decoded using the given encoding and error handler.
    Otherwise, returns the result of object.__str__() (if defined)
    or repr(object).
    encoding defaults to sys.getdefaultencoding().
    errors defaults to 'strict'.
    """
    def capitalize(self): # real signature unknown; restored from __doc__
        """
        首字母变大写
        S.capitalize() -> str
        Return a capitalized version of S, i.e. make the first character
        have upper case and the rest lower case.
        """
        return ""
    def casefold(self): # real signature unknown; restored from __doc__
        """
        S.casefold() -> str
        Return a version of S suitable for caseless comparisons.
        """
        return ""
    def center(self, width, fillchar=None): # real signature unknown; restored from __doc__
        """
        原来字符居中，不够用空格补全
        S.center(width[, fillchar]) -> str
        Return S centered in a string of length width. Padding is
        done using the specified fill character (default is a space)
        """
        return ""
    def count(self, sub, start=None, end=None): # real signature unknown; restored from __doc__
        """
         从一个范围内的统计某str出现次数
        S.count(sub[, start[, end]]) -> int
        Return the number of non-overlapping occurrences of substring sub in
        string S[start:end].  Optional arguments start and end are
        interpreted as in slice notation.
        """
        return 0
    def encode(self, encoding='utf-8', errors='strict'): # real signature unknown; restored from __doc__
        """
        encode(encoding='utf-8',errors='strict')
        以encoding指定编码格式编码，如果出错默认报一个ValueError，除非errors指定的是
        ignore或replace
        S.encode(encoding='utf-8', errors='strict') -> bytes
        Encode S using the codec registered for encoding. Default encoding
        is 'utf-8'. errors may be given to set a different error
        handling scheme. Default is 'strict' meaning that encoding errors raise
        a UnicodeEncodeError. Other possible values are 'ignore', 'replace' and
        'xmlcharrefreplace' as well as any other name registered with
        codecs.register_error that can handle UnicodeEncodeErrors.
        """
        return b""
    def endswith(self, suffix, start=None, end=None): # real signature unknown; restored from __doc__
        """
        S.endswith(suffix[, start[, end]]) -> bool
        Return True if S ends with the specified suffix, False otherwise.
        With optional start, test S beginning at that position.
        With optional end, stop comparing S at that position.
        suffix can also be a tuple of strings to try.
        """
        return False
    def expandtabs(self, tabsize=8): # real signature unknown; restored from __doc__
        """
        将字符串中包含的\t转换成tabsize个空格
        S.expandtabs(tabsize=8) -> str
        Return a copy of S where all tab characters are expanded using spaces.
        If tabsize is not given, a tab size of 8 characters is assumed.
        """
        return ""
    def find(self, sub, start=None, end=None): # real signature unknown; restored from __doc__
        """
        S.find(sub[, start[, end]]) -> int
        Return the lowest index in S where substring sub is found,
        such that sub is contained within S[start:end].  Optional
        arguments start and end are interpreted as in slice notation.
        Return -1 on failure.
        """
        return 0
    def format(self, *args, **kwargs): # known special case of str.format
        """
        格式化输出
        三种形式：
        形式一.
        >>> print('{0}{1}{0}'.format('a','b'))
        aba
        形式二：（必须一一对应）
        >>> print('{}{}{}'.format('a','b'))
        Traceback (most recent call last):
          File "<input>", line 1, in <module>
        IndexError: tuple index out of range
        >>> print('{}{}'.format('a','b'))
        ab
        形式三：
        >>> print('{name} {age}'.format(age=12,name='lhf'))
        lhf 12
        S.format(*args, **kwargs) -> str
        Return a formatted version of S, using substitutions from args and kwargs.
        The substitutions are identified by braces ('{' and '}').
        """
        pass
    def format_map(self, mapping): # real signature unknown; restored from __doc__
        """
        与format区别
        '{name}'.format(**dict(name='alex'))
        '{name}'.format_map(dict(name='alex'))
        S.format_map(mapping) -> str
        Return a formatted version of S, using substitutions from mapping.
        The substitutions are identified by braces ('{' and '}').
        """
        return ""
    def index(self, sub, start=None, end=None): # real signature unknown; restored from __doc__
        """
        S.index(sub[, start[, end]]) -> int
        Like S.find() but raise ValueError when the substring is not found.
        """
        return 0
    def isalnum(self): # real signature unknown; restored from __doc__
        """
        至少一个字符，且都是字母或数字才返回True
        S.isalnum() -> bool
        Return True if all characters in S are alphanumeric
        and there is at least one character in S, False otherwise.
        """
        return False
    def isalpha(self): # real signature unknown; restored from __doc__
        """
        至少一个字符，且都是字母才返回True
        S.isalpha() -> bool
        Return True if all characters in S are alphabetic
        and there is at least one character in S, False otherwise.
        """
        return False
    def isdecimal(self): # real signature unknown; restored from __doc__
        """
        S.isdecimal() -> bool
        Return True if there are only decimal characters in S,
        False otherwise.
        """
        return False
    def isdigit(self): # real signature unknown; restored from __doc__
        """
        S.isdigit() -> bool
        Return True if all characters in S are digits
        and there is at least one character in S, False otherwise.
        """
        return False
    def isidentifier(self): # real signature unknown; restored from __doc__
        """
        字符串为关键字返回True
        S.isidentifier() -> bool
        Return True if S is a valid identifier according
        to the language definition.
        Use keyword.iskeyword() to test for reserved identifiers
        such as "def" and "class".
        """
        return False
    def islower(self): # real signature unknown; restored from __doc__
        """
        至少一个字符，且都是小写字母才返回True
        S.islower() -> bool
        Return True if all cased characters in S are lowercase and there is
        at least one cased character in S, False otherwise.
        """
        return False
    def isnumeric(self): # real signature unknown; restored from __doc__
        """
        S.isnumeric() -> bool
        Return True if there are only numeric characters in S,
        False otherwise.
        """
        return False
    def isprintable(self): # real signature unknown; restored from __doc__
        """
        S.isprintable() -> bool
        Return True if all characters in S are considered
        printable in repr() or S is empty, False otherwise.
        """
        return False
    def isspace(self): # real signature unknown; restored from __doc__
        """
        至少一个字符，且都是空格才返回True
        S.isspace() -> bool
        Return True if all characters in S are whitespace
        and there is at least one character in S, False otherwise.
        """
        return False
    def istitle(self): # real signature unknown; restored from __doc__
        """
        >>> a='Hello'
        >>> a.istitle()
        True
        >>> a='HellP'
        >>> a.istitle()
        False
        S.istitle() -> bool
        Return True if S is a titlecased string and there is at least one
        character in S, i.e. upper- and titlecase characters may only
        follow uncased characters and lowercase characters only cased ones.
        Return False otherwise.
        """
        return False
    def isupper(self): # real signature unknown; restored from __doc__
        """
        S.isupper() -> bool
        Return True if all cased characters in S are uppercase and there is
        at least one cased character in S, False otherwise.
        """
        return False
    def join(self, iterable): # real signature unknown; restored from __doc__
        """
        #对序列进行操作（分别使用' '与':'作为分隔符）
        >>> seq1 = ['hello','good','boy','doiido']
        >>> print ' '.join(seq1)
        hello good boy doiido
        >>> print ':'.join(seq1)
        hello:good:boy:doiido
        #对字符串进行操作
        >>> seq2 = "hello good boy doiido"
        >>> print ':'.join(seq2)
        h:e:l:l:o: :g:o:o:d: :b:o:y: :d:o:i:i:d:o
        #对元组进行操作
        >>> seq3 = ('hello','good','boy','doiido')
        >>> print ':'.join(seq3)
        hello:good:boy:doiido
        #对字典进行操作
        >>> seq4 = {'hello':1,'good':2,'boy':3,'doiido':4}
        >>> print ':'.join(seq4)
        boy:good:doiido:hello
        #合并目录
        >>> import os
        >>> os.path.join('/hello/','good/boy/','doiido')
        '/hello/good/boy/doiido'
        S.join(iterable) -> str
        Return a string which is the concatenation of the strings in the
        iterable.  The separator between elements is S.
        """
        return ""
    def ljust(self, width, fillchar=None): # real signature unknown; restored from __doc__
        """
        S.ljust(width[, fillchar]) -> str
        Return S left-justified in a Unicode string of length width. Padding is
        done using the specified fill character (default is a space).
        """
        return ""
    def lower(self): # real signature unknown; restored from __doc__
        """
        S.lower() -> str
        Return a copy of the string S converted to lowercase.
        """
        return ""
    def lstrip(self, chars=None): # real signature unknown; restored from __doc__
        """
        S.lstrip([chars]) -> str
        Return a copy of the string S with leading whitespace removed.
        If chars is given and not None, remove characters in chars instead.
        """
        return ""
    def maketrans(self, *args, **kwargs): # real signature unknown
        """
        Return a translation table usable for str.translate().
        If there is only one argument, it must be a dictionary mapping Unicode
        ordinals (integers) or characters to Unicode ordinals, strings or None.
        Character keys will be then converted to ordinals.
        If there are two arguments, they must be strings of equal length, and
        in the resulting dictionary, each character in x will be mapped to the
        character at the same position in y. If there is a third argument, it
        must be a string, whose characters will be mapped to None in the result.
        """
        pass
    def partition(self, sep): # real signature unknown; restored from __doc__
        """
        以sep为分割，将S分成head,sep,tail三部分
        S.partition(sep) -> (head, sep, tail)
        Search for the separator sep in S, and return the part before it,
        the separator itself, and the part after it.  If the separator is not
        found, return S and two empty strings.
        """
        pass
    def replace(self, old, new, count=None): # real signature unknown; restored from __doc__
        """
        S.replace(old, new[, count]) -> str
        Return a copy of S with all occurrences of substring
        old replaced by new.  If the optional argument count is
        given, only the first count occurrences are replaced.
        """
        return ""
    def rfind(self, sub, start=None, end=None): # real signature unknown; restored from __doc__
        """
        S.rfind(sub[, start[, end]]) -> int
        Return the highest index in S where substring sub is found,
        such that sub is contained within S[start:end].  Optional
        arguments start and end are interpreted as in slice notation.
        Return -1 on failure.
        """
        return 0
    def rindex(self, sub, start=None, end=None): # real signature unknown; restored from __doc__
        """
        S.rindex(sub[, start[, end]]) -> int
        Like S.rfind() but raise ValueError when the substring is not found.
        """
        return 0
    def rjust(self, width, fillchar=None): # real signature unknown; restored from __doc__
        """
        S.rjust(width[, fillchar]) -> str
        Return S right-justified in a string of length width. Padding is
        done using the specified fill character (default is a space).
        """
        return ""
    def rpartition(self, sep): # real signature unknown; restored from __doc__
        """
        S.rpartition(sep) -> (head, sep, tail)
        Search for the separator sep in S, starting at the end of S, and return
        the part before it, the separator itself, and the part after it.  If the
        separator is not found, return two empty strings and S.
        """
        pass
    def rsplit(self, sep=None, maxsplit=-1): # real signature unknown; restored from __doc__
        """
        S.rsplit(sep=None, maxsplit=-1) -> list of strings
        Return a list of the words in S, using sep as the
        delimiter string, starting at the end of the string and
        working to the front.  If maxsplit is given, at most maxsplit
        splits are done. If sep is not specified, any whitespace string
        is a separator.
        """
        return []
    def rstrip(self, chars=None): # real signature unknown; restored from __doc__
        """
        S.rstrip([chars]) -> str
        Return a copy of the string S with trailing whitespace removed.
        If chars is given and not None, remove characters in chars instead.
        """
        return ""
    def split(self, sep=None, maxsplit=-1): # real signature unknown; restored from __doc__
        """
        以sep为分割，将S切分成列表，与partition的区别在于切分结果不包含sep，
        如果一个字符串中包含多个sep那么maxsplit为最多切分成几部分
        >>> a='a,b c\nd\te'
        >>> a.split()
        ['a,b', 'c', 'd', 'e']
        S.split(sep=None, maxsplit=-1) -> list of strings
        Return a list of the words in S, using sep as the
        delimiter string.  If maxsplit is given, at most maxsplit
        splits are done. If sep is not specified or is None, any
        whitespace string is a separator and empty strings are
        removed from the result.
        """
        return []
    def splitlines(self, keepends=None): # real signature unknown; restored from __doc__
        """
        Python splitlines() 按照行('\r', '\r\n', \n')分隔，
        返回一个包含各行作为元素的列表，如果参数 keepends 为 False，不包含换行符，如        果为 True，则保留换行符。
        >>> x
        'adsfasdf\nsadf\nasdf\nadf'
        >>> x.splitlines()
        ['adsfasdf', 'sadf', 'asdf', 'adf']
        >>> x.splitlines(True)
        ['adsfasdf\n', 'sadf\n', 'asdf\n', 'adf']
        S.splitlines([keepends]) -> list of strings
        Return a list of the lines in S, breaking at line boundaries.
        Line breaks are not included in the resulting list unless keepends
        is given and true.
        """
        return []
    def startswith(self, prefix, start=None, end=None): # real signature unknown; restored from __doc__
        """
        S.startswith(prefix[, start[, end]]) -> bool
        Return True if S starts with the specified prefix, False otherwise.
        With optional start, test S beginning at that position.
        With optional end, stop comparing S at that position.
        prefix can also be a tuple of strings to try.
        """
        return False
    def strip(self, chars=None): # real signature unknown; restored from __doc__
        """
        S.strip([chars]) -> str
        Return a copy of the string S with leading and trailing
        whitespace removed.
        If chars is given and not None, remove characters in chars instead.
        """
        return ""
    def swapcase(self): # real signature unknown; restored from __doc__
        """
        大小写反转
        S.swapcase() -> str
        Return a copy of S with uppercase characters converted to lowercase
        and vice versa.
        """
        return ""
    def title(self): # real signature unknown; restored from __doc__
        """
        S.title() -> str
        Return a titlecased version of S, i.e. words start with title case
        characters, all remaining cased characters have lower case.
        """
        return ""
    def translate(self, table): # real signature unknown; restored from __doc__
        """
        table=str.maketrans('alex','big SB')
        a='hello abc'
        print(a.translate(table))
        S.translate(table) -> str
        Return a copy of the string S in which each character has been mapped
        through the given translation table. The table must implement
        lookup/indexing via __getitem__, for instance a dictionary or list,
        mapping Unicode ordinals to Unicode ordinals, strings, or None. If
        this operation raises LookupError, the character is left untouched.
        Characters mapped to None are deleted.
        """
        return ""
    def upper(self): # real signature unknown; restored from __doc__
        """
        S.upper() -> str
        Return a copy of S converted to uppercase.
        """
        return ""
    def zfill(self, width): # real signature unknown; restored from __doc__
        """
        原来字符右对齐，不够用0补齐
        S.zfill(width) -> str
        Pad a numeric string S with zeros on the left, to fill a field
        of the specified width. The string S is never truncated.
        """
        return ""
     ...略...
```

# 2.6 基本数据类型 列表

## 本节重点

1.让学员理解列表数据类型出现的意义

2.让学员掌握列表的定义和特性

3.学员能熟练掌握列表常用操作，并了解其他工厂方法

4.让同学们认识range方法，并能将range方法产生的数据转换成列表

## 引子

之前我们已经掌握了python中的两种数据类型，现在我们已经知道如果想表示咱们班有多少同学，应该使用int整形，如果想表示班里同学的名字，应该使用str字符串型。但是，现在我想表示全班同学的名字，应该用什么呢？

用我们现在学习的知识能解决问题么？

也许有的同学说，可以使用一个长字符串，把所有同学的名字都写进去，可是问题来了。

比如当某一个同学学的太差被学校开除了，我要在一长串字符中找到一个名字并且把他删除，是不是就变得格外麻烦？

这种情况下，我们就想，要是python给我们提供一种新的数据结构，可以存储很多个字符串，能让我们方便的添加修改和删除，就完美了。

## 列表的定义和创建

定义：\[]内以逗号分隔，按照索引，存放各种数据类型，每个位置代表一个元素

**列表的创建**

```plain
list_test=[‘张三‘,‘李四’,'alex']
#或
list_test=list('alex')
#或
list_test=list([‘张三‘,‘李四’,'alex'])
```

## 列表的特点和常用操作

特性：

1.可存放多个值

2.按照从左到右的顺序定义列表元素，下标从0开始顺序访问，有序

<!-- OCR_START -->
- list
- 张三
- 李四
- alex
- 索引
- 1
- 2
<!-- OCR_END -->

3.可修改指定索引位置对应的值，可变

### 常用操作：

```plain
#索引
>>> l = ['egon','alex','seven','yuan']
>>> l[0]
'egon'
>>> l[2]
'seven'
#切片
>>> l[0:2]
['egon', 'alex']
>>> l[2:5]
['seven', 'yuan']
>>> l[:2]
['egon', 'alex']
>>> l[2:]
['seven', 'yuan']
>>> l[:]
['egon', 'alex', 'seven', 'yuan']
>>> l[::2]
['egon', 'seven']
>>> l[::-1]
['yuan', 'seven', 'alex', 'egon']
#追加
>>> l.append("eva")
>>> l
['egon', 'alex', 'seven', 'yuan', 'eva']
#删除
>>> l.remove('eva')
>>> l
['egon', 'alex', 'seven', 'yuan']
>>> l.pop()
'yuan'
>>> l
['egon', 'alex', 'seven']
#长度
>>> len(l)
3
#包含
>>> 'seven' in l
True
>>> 'yuan' in l
False
#循环:为什么是“i”？
>>> for i in l:
    print(i)
egon
alex
seven
```

### 列表与字符串——split和join

```plain
#分割
>>> s = 'hello world'
>>> s.split(' ')
['hello', 'world']
>>> s2= 'hello,world'
>>> s2.split(',')
#连接
>>> l = ['hi','eva']
>>> '!'.join(l)
'hi!eva'
```

## range

### 引子：

现在已经学了列表了，那现在同学们来一起创建一个从1-100的列表。

等1分钟，你们都打算怎么创建啊？

是直接从1写到100还是用循环？如果从1写到100未免太傻气了，用循环好像还好一点儿。但是用循环写还不够简单，在python里有一个现成的方法，可以直接生成一个1-100的数。

```plain
>>> range(1,100)
range(1, 100)
>>> list(range(1,100))
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 
 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56,
 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 
 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]
>>> list(range(10))
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> list(range(0,100,2))
[0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 
56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98]
```

> 只介绍range的调用和参数传递，先不强调range是一个生成器，先让大家用list将range转换成一个列表使用即可

# 2.7 基本数据类型 元组

## 本节重点

1.让学员理解元组数据类型出现的意义

2.让学员掌握元组的定义和特性

3.学员能熟练掌握元组常用操作，并了解其他工厂方法

## 引子

介绍完列表，我们再介绍一种和列表非常相似的数据类型。叫做元组。

## 元组的定义和特性

*定义：与列表类似，只不过［］改成（）*

*特性：*

\_　　1.可存放多个值_按照从左到右的顺序定义元组元素，下标从0开始顺序访问，有序

> 解释为什么要有不可变数据类型元组出现？

## 元组的创建与常用操作

创建

```plain
ages = (11, 22, 33, 44, 55)
#或
ages = tuple((11, 22, 33, 44, 55))
```

常用操作

```plain
#索引
>>> ages = (11, 22, 33, 44, 55)
>>> ages[0]
11
>>> ages[3]
44
>>> ages[-1]
55
#切片:同list　　
#循环
>>> for age in ages:
    print(age)
11
22
33
44
55
#长度
>>> len(ages)
5
#包含
>>> 11 in ages
True
>>> 66 in ages
False
>>> 11 not in ages
False
```

## 元组的特性详解

**1.可存放多个值**

如果元组中只有一个值

```plain
t = (1,)
t = (1)   #<==>t = 1
```

元组中不仅可以存放数字、字符串，还可以存放更加复杂的数据类型

**2.不可变**

元组本身不可变，如果元组中还包含其他可变元素，这些可变元素可以改变

# 2.8 可变、不可变数据类型和hash

## 本节重点

1.让学生了解可变和不可变数据类型

2.了解hash函数

## 可变与不可变类型

截止到目前为止我们已经学过很多数据类型：数字类型、字符串类型、列表类型、元祖类型。

在python中，我们对数据类型还有另外一种分类方式，我们给数据类型分为可变数据类型和不可变数据类型。在了解原理之前，我们先来看看分类情况：

| 可变类型 | 不可变类型 |
| --- | --- |
| 列表 | 数字 |
| | 字符串 |
| | 元组 |

看着上面这句话，我们来看看什么叫可变什么叫不可变

**列表**

```plain
>>> l = [1,2,3,4]
>>> id(l)
4392665160
>>> l[1] = 1.5
>>> l
[1, 1.5, 3, 4]
>>> id(l)
4392665160
```

**数字**

```plain
>>> a = 1
>>> id(a)
4297537952 
>>> a+=1
>>> id(a)
4297537984
```

从内存角度看列表与数字的变与不变

<!-- OCR_START -->
- itemo
- 1.5
- item1
- 2
- item2
- item4
<!-- OCR_END -->

**字符串**

```plain
#例1
>>> s = 'hello'
>>> s[1] = 'a'
Traceback (most recent call last):
  File "<pyshell#5>", line 1, in <module>
    s[1] = 'a'
TypeError: 'str' object does not support item assignment
#例2
>>> s = 'hello'
>>> id(s)
4392917064
>>> s += ' world'
>>> s
'hello world'
>>> id(s)
4393419504
```

字符串也可以像列表一样使用索引操作，但是通过上例可以看出，我们不能像修改列表一样修改一个字符串的值，当我们对字符串进行拼接的时候，原理和整数一样，id值已经发生了变化，相当于变成了另外一个字符串。

**元组**——不允许修改

```plain
>>> t = (1,2,3,4)
>>> t[1] = 1.5
Traceback (most recent call last):
  File "<pyshell#10>", line 1, in <module>
    t[1] = 1.5
TypeError: 'tuple' object does not support item assignment
```

## hash

假设现在要你存储一些数据如下，你会怎么存？

```plain
张三 13980593357
李四 15828662334
王老五 13409821234
[[‘张三’，13980593357][‘李四’，15828662334][‘王老五’，13409821234]]
```

像上面这样存行不行？

可以～现在咱们有一个需求，就是获取“王五”的电话号码，你怎么做？

遍历整个列表，找到“王五”的信息所在的列表，然后拿到王五的电话。看起来一切顺利。

但是当我们需要存储的人越来越多，这个寻找的过程就会变得非常漫长，如果我们存了5000万个人的信息，那么找人这个过程就变得像大海捞针一样了。。。有没有什么好办法能够让我们一下子就找到对应的人呢？

我们都知道数据是存储在内存里的，内存中的每一个位置都有自己的地址标示。假如我们能够将这些人名转换成数字直接存储在数字代表的内存地址中，等要找这个人的时候，直接去这个地址找人是不是就方便了？

```plain
假如对上述的联系人信息进行存储时，采用的Hash函数为：姓名的每个字的拼音开头大写字母的ASCII码之和。因此
address(张三)=ASCII(Z)+ASCII(S)=90+83=173;
address(李四)=ASCII(L)+ASCII(S)=76+83=159;
address(王老五)=ASCII(W)+ASCII(L)+ASCII(W)=87+76+87=250;
```

<!-- OCR_START -->
| 名称 | 排名 |
| --- | --- |
| ...... | 159 |
| 张三 | 173 |
| 李四 | 250 |
<!-- OCR_END -->

当然了，这只是一个示意图，具体的情况比这个还要复杂，还有很多复杂的因素都没有考虑进入，比如如果计算出来的hash值发生了冲突怎么办？还有现在这张图就可以看出空间上的浪费，这就需要我们在设计hash算法的时候不能像我刚刚假设的那样随意。但这已经足以向你说明hash算法的与众不同，它能为你在数据查找的过程中节省多少时间。

现在，告诉你一个好消息，你不需要关心hash值是如何计算的，因为python已经为我们设计了一套算法你只要拿来用就可以：

```plain
>>> hash("张三")
6480394008723176318
>>> hash("李四")
-114706925611844552
>>> hash("王老五")
3250319002057530081
```

### 可以被hash的内容

刚刚我们已经说过，hash值的计算过程是依据这个值的一些特征计算的，这就要求被hash的值必须固定。

可以想见如果“王老五”变成“王老六”了，计算的结果就会发生改变。

因此我们要说，坏消息是**可变的数据类型是不可以被hash的**，好消息是如果**一个值可以hash那么说明这是一个不可变得数据类型**。

不会用hash没有关系，这里你先知道什么是hash，接下来，我们要学习一种很厉害的数据类型，它就是用这种方式，让我们能够从大量数据中直接快速找到我们想要的数据。

# 2.9 基本数据类型 字典

## 本节重点

1.让学员理解字典数据类型出现的意义

2.让学员掌握字典的定义和特性

3.学员能熟练掌握字典常用操作，并了解其他工厂方法

## 引子

之前我们已经学过了字典和元组，我们可以把全班同学的名字保存在列表中，并能够对这些名字进行增删改查了。现在我们又有了一个新的需求，我们不仅要保存每个同学的姓名，还想要保存他的年龄、身高等等。应该如何保存呢？

这里可以引导学生像组合列表这里思考：\[\[name,age,high],\[],……,\[]]

但是这样就有一个问题，如果我们想修改某一个同学的信息，需要遍历整个列表，这种方式非常麻烦。

当然我们也可以用index寻找这个学员的信息，但是前提是我们必须知道这个学员的姓名年龄和身高，这样我们使用这个列表的成本就太高了。。。

这个时候就需要有新的数据类型来支撑我们的需求。

## 字典的定义与特性

字典是Python语言中唯一的映射类型。

**定义：**｛key1:value1,key2:value2｝

```plain
1、键与值用冒号“：”分开；
2、项与项用逗号“，”分开；
```

**特性：**

```plain
1.key-value结构
2.key必须可hash、且必须为不可变数据类型、必须唯一
3.可存放任意多个值、可修改、可以不唯一
4.无序
```

## 字典的创建与常见操作

**字典的创建**

```plain
person = {"name": "alex", 'age': 20}
#或
person = dict(name='seven', age=20)
#或
person = dict({"name": "egon", 'age': 20})
#或
person = dict((['name','苑昊'],['文周',18]))
{}.fromkeys(seq,100) #不指定100默认为None
#注意
>>> dic={}.fromkeys(['k1','k2'],[])
>>> dic
{'k1': [], 'k2': []}
>>> dic['k1'].append(1)
>>> dic
{'k1': [1], 'k2': [1]}
```

**字典的常见操作**

```plain
键、值、键值对
　　　　1、dic.keys() 返回一个包含字典所有KEY的列表；
　　　　2、dic.values() 返回一个包含字典所有value的列表；
　　　　3、dic.items() 返回一个包含所有（键，值）元祖的列表；
　　　　4、dic.iteritems()、dic.iterkeys()、dic.itervalues() 与它们对应的非迭代方法一样，不同的是它们返回一个迭代子，而不是一个列表；
新增
　　　　1、dic['new_key'] = 'new_value'；
　　　　2、dic.setdefault(key, None) ,如果字典中不存在Key键，由 dic[key] = default 为它赋值；_
删除
　　　　1、dic.pop(key[,default]) 和get方法相似。如果字典中存在key，删除并返回key对应的vuale；如果key不存在，且没有给出default的值，则引发keyerror异常；
　　　　2、dic.clear() 删除字典中的所有项或元素；    
修改
　　　　1、dic['key'] = 'new_value',如果key在字典中存在，'new_value'将会替代原来的value值；
　　　　2、dic.update(dic2) 将字典dic2的键值对添加到字典dic中
查看
　　　　1、dic['key']，返回字典中key对应的值，若key不存在字典中，则报错；
　　　　2、dict.get(key, default = None) 返回字典中key对应的值，若key不存在字典中，则返回default的值（default默认为None）
循环
　　　　1、for k in dic.keys()
　　　　2、for k,v in dic.items()
　　　　3、for k in dic
长度
　　　　1、len(dic)
```

## 字典的工厂函数

```plain
class dict(object):
    """
    dict() -> new empty dictionary
    dict(mapping) -> new dictionary initialized from a mapping object's
        (key, value) pairs
    dict(iterable) -> new dictionary initialized as if via:
        d = {}
        for k, v in iterable:
            d[k] = v
    dict(**kwargs) -> new dictionary initialized with the name=value pairs
        in the keyword argument list.  For example:  dict(one=1, two=2)
    """
    def clear(self): # real signature unknown; restored from __doc__
        """ D.clear() -> None.  Remove all items from D. """
        pass
    def copy(self): # real signature unknown; restored from __doc__
        """ D.copy() -> a shallow copy of D """
        pass
    @staticmethod # known case
    def fromkeys(*args, **kwargs): # real signature unknown
        """ Returns a new dict with keys from iterable and values equal to value. """
        pass
    def get(self, k, d=None): # real signature unknown; restored from __doc__
        """ D.get(k[,d]) -> D[k] if k in D, else d.  d defaults to None. """
        pass
    def items(self): # real signature unknown; restored from __doc__
        """ D.items() -> a set-like object providing a view on D's items """
        pass
    def keys(self): # real signature unknown; restored from __doc__
        """ D.keys() -> a set-like object providing a view on D's keys """
        pass
    def pop(self, k, d=None): # real signature unknown; restored from __doc__
        """
        D.pop(k[,d]) -> v, remove specified key and return the corresponding value.
        If key is not found, d is returned if given, otherwise KeyError is raised
        """
        pass
    def popitem(self): # real signature unknown; restored from __doc__
        """
        D.popitem() -> (k, v), remove and return some (key, value) pair as a
        2-tuple; but raise KeyError if D is empty.
        """
        pass
    def setdefault(self, k, d=None): # real signature unknown; restored from __doc__
        """ D.setdefault(k[,d]) -> D.get(k,d), also set D[k]=d if k not in D """
        pass
    def update(self, E=None, **F): # known special case of dict.update
        """
        D.update([E, ]**F) -> None.  Update D from dict/iterable E and F.
        If E is present and has a .keys() method, then does:  for k in E: D[k] = E[k]
        If E is present and lacks a .keys() method, then does:  for k, v in E: D[k] = v
        In either case, this is followed by: for k in F:  D[k] = F[k]
        """
        pass
    def values(self): # real signature unknown; restored from __doc__
        """ D.values() -> an object providing a view on D's values """
        pass
....略....
```

# 2.10 基本数据类型 集合

## 本节重点

1.让学员了解什么是集合以及集合的作用

2.让学员掌握集合的定义和基本特征

3.让学员掌握集合的关系运算和常用操作

## 引子

现在有一个linux班一个python班，我们创建两个列表，把班里的学生表示出来：

l = \['张三','李四','老男孩']

p = \['张三','李四','alex']

现在要找出既在linux班上课也在python班上课的学生，应该怎么找？

```plain
l= ['张三','李四','老男孩']
p = ['张三','李四','alex']
l_p = []
for i in l:
    if i in p:
        l_p.append(i)
print(l_p)
```

上面这种方法可以实现我们的需求，但是比较麻烦，而且当列表变得非常长，执行代码的效率也是问题。

接下来，我们要学习一种新的数据类型，能够非常轻松的帮我们完成这个任务。

## 认识集合

集合是一个数学概念：由一个或多个确定的元素所构成的整体叫做集合。

**集合中的元素有三个特征：**

1.确定性（元素必须可hash）

2.互异性（去重）

3.无序性（集合中的元素没有先后之分），如集合{3,4,5}和{3,5,4}算作同一个集合。

> 注意：集合存在的意义就在于**去重和关系运算**

## 用集合解决问题

```plain
l= {'张三','李四','老男孩'}  #集合定义
p = {'张三','李四','alex'}
l_p = l&p    #集合求交集
print(l_p)
```

<!-- OCR_START -->
- 李四
- 老男孩
- Alex
- 张三
<!-- OCR_END -->

## 集合的定义

```plain
l= {1,2,3,1}  #此处应说明集合“去重”的效果
#定义可变集合
>>> set_test=set('hello') #此处应说明集合的“无序性”
>>> set_test
{'l', 'o', 'e', 'h'}
#改为不可变集合frozenset
>>> f_set_test=frozenset(set_test)
>>> f_set_test
frozenset({'l', 'e', 'h', 'o'})
```

## 集合的**关系运算**

除了刚刚我们学过的交集之外，集合还可以做其他的关系运算。

继续以引子为例，现在已知两个集合分别是学习linux班的同学和学习python班的同学

&.&=:交集——既学习linux课程也学习python课程的同学

<!-- OCR_START -->
- 交集
- 李四
- 老男孩
- Alex
- 张三
<!-- OCR_END -->

```plain
l= {'张三','李四','老男孩'}
p = {'张三','李四','alex'}
print(l.intersection(p))
print(l&p)
```

|,|=:合集，也叫并集——linux班和python班的所有同学

> 这里同学们不可以单纯的认为python班的人数+linux班的人数就是结果，如果两班人数相加应该是6人。但学习Linux班的张三和李四还同时在python班学习，因此我们实际上总共只有四个学员。**求并集除了合并效果之外还有去重功能**

<!-- OCR_START -->
- 张三
- Alex
- 去重
- 并集
- 老男孩
- 李四
<!-- OCR_END -->

```plain
l= {'张三','李四','老男孩'}
p = {'张三','李四','alex'}
print(l.union(p))
print(l|p)
```

－,－=:差集——只在linux而不python班的同学



<!-- OCR_START -->
> 差集
> 李四
> 老男孩
> Alex
> 张三
<!-- OCR_END -->



```plain
l= {'张三','李四','老男孩'}
p = {'张三','李四','alex'}
print(l.difference(p))
print(l-p)
```

^,^=:对称差集——只在linux班或只在python班的同学

<!-- OCR_START -->
- 对称差集
- 李四
- 老男孩
- Alex
- 张三
<!-- OCR_END -->

```plain
a = {1,2,3}
b = {2,3,4,5}
print(a.symmetric_difference(b))
print(a^b)
```

包含关系

in,not in：判断某元素是否在集合内

＝＝,！＝:判断两个集合是否相等

两个集合之间一般有三种关系，相交、包含、不相交。在Python中分别用下面的方法判断：

* set.isdisjoint(s)：判断两个集合是不是不相交
* set.issuperset(s)：判断集合是不是包含其他集合，等同于a>=b
* set.issubset(s)：判断集合是不是被其他集合包含，等同于a<=b

## **集合的常用操作**

**元素的增加**

单个元素的增加 : add()，add的作用类似列表中的append

对序列的增加 : update()，而update类似extend方法，update方法可以支持同时传入多个参数：

```plain
>>> a={1,2}
>>> a.update([3,4],[1,2,7])
>>> a
{1, 2, 3, 4, 7}
>>> a.update("hello")
>>> a
{1, 2, 3, 4, 7, 'h', 'e', 'l', 'o'}
>>> a.add("hello")
>>> a
{1, 2, 3, 4, 'hello', 7, 'h', 'e', 'l', 'o'}
```

**元素的删除**

集合删除单个元素有两种方法：

元素不在原集合中时：

set.discard(x)不会抛出异常

set.remove(x)会抛出KeyError错误

```plain
>>> a={1,2,3,4}
>>> a.discard(1)
>>> a
{2, 3, 4}
>>> a.discard(1)
>>> a
{2, 3, 4}
>>> a.remove(1)
Traceback (most recent call last):
  File "<input>", line 1, in <module>
KeyError: 1
```

pop()：由于集合是无序的，pop返回的结果不能确定，且当集合为空时调用pop会抛出KeyError错误，

clear():清空集合

```plain
>>> a={3,"a",2.1,1}
>>> a.pop()
>>> a.pop()
>>> a.clear()
>>> a
set()
>>> a.pop()
Traceback (most recent call last):
  File "<input>", line 1, in <module>
KeyError: 'pop from an empty set'
```

## 集合的工厂函数

```plain
class set(object):
    """
    set() -> new empty set object
    set(iterable) -> new set object
    Build an unordered collection of unique elements.
    """
    def add(self, *args, **kwargs): # real signature unknown
        """
        Add an element to a set.
        This has no effect if the element is already present.
        """
        pass
    def clear(self, *args, **kwargs): # real signature unknown
        """ Remove all elements from this set. """
        pass
    def copy(self, *args, **kwargs): # real signature unknown
        """ Return a shallow copy of a set. """
        pass
    def difference(self, *args, **kwargs): # real signature unknown
        """
        相当于s1-s2
        Return the difference of two or more sets as a new set.
        (i.e. all elements that are in this set but not the others.)
        """
        pass
    def difference_update(self, *args, **kwargs): # real signature unknown
        """ Remove all elements of another set from this set. """
        pass
    def discard(self, *args, **kwargs): # real signature unknown
        """
        与remove功能相同，删除元素不存在时不会抛出异常
        Remove an element from a set if it is a member.
        If the element is not a member, do nothing.
        """
        pass
    def intersection(self, *args, **kwargs): # real signature unknown
        """
        相当于s1&s2
        Return the intersection of two sets as a new set.
        (i.e. all elements that are in both sets.)
        """
        pass
    def intersection_update(self, *args, **kwargs): # real signature unknown
        """ Update a set with the intersection of itself and another. """
        pass
    def isdisjoint(self, *args, **kwargs): # real signature unknown
        """ Return True if two sets have a null intersection. """
        pass
    def issubset(self, *args, **kwargs): # real signature unknown
        """ 
        相当于s1<=s2
        Report whether another set contains this set. """
        pass
    def issuperset(self, *args, **kwargs): # real signature unknown
        """
        相当于s1>=s2
         Report whether this set contains another set. """
        pass
    def pop(self, *args, **kwargs): # real signature unknown
        """
        Remove and return an arbitrary set element.
        Raises KeyError if the set is empty.
        """
        pass
    def remove(self, *args, **kwargs): # real signature unknown
        """
        Remove an element from a set; it must be a member.
        If the element is not a member, raise a KeyError.
        """
        pass
    def symmetric_difference(self, *args, **kwargs): # real signature unknown
        """
        相当于s1^s2
        Return the symmetric difference of two sets as a new set.
        (i.e. all elements that are in exactly one of the sets.)
        """
        pass
    def symmetric_difference_update(self, *args, **kwargs): # real signature unknown
        """ Update a set with the symmetric difference of itself and another. """
        pass
    def union(self, *args, **kwargs): # real signature unknown
        """
        相当于s1|s2
        Return the union of sets as a new set.
        (i.e. all elements that are in either set.)
        """
        pass
    def update(self, *args, **kwargs): # real signature unknown
        """ Update a set with the union of itself and others. """
        pass
...略...
```

# 2.11 collections 模块

## 本节重点

1.了解Queue的基本概念和常用操作

2.学员了解collections模块

2.学员能掌握Counter、deque、defaultdict、namedtuple和OrderedDict数据类型的基本操作

## collections模块

collections模块在内置数据类型（dict、list、set、tuple）的基础上，还提供了几个额外的数据类型：ChainMap、Counter、deque、defaultdict、namedtuple和OrderedDict等。

1.namedtuple: 生成可以使用名字来访问元素内容的tuple子类

2.deque: 双端队列，可以快速的从另外一侧追加和推出对象

3.Counter: 计数器，主要用来计数

4.OrderedDict: 有序字典

5.defaultdict: 带有默认值的字典

## namedtuple

我们知道`tuple`可以表示不变集合，例如，一个点的二维坐标就可以表示成：

```plain
>>> p = (1, 2)
```

但是，看到`(1, 2)`，很难看出这个`tuple`是用来表示一个坐标的。

定义一个class又小题大做了，这时，`namedtuple`就派上了用场：

```plain
>>> from collections import namedtuple
>>> Point = namedtuple('Point', ['x', 'y'])
>>> p = Point(1, 2)
>>> p.x
1
>>> p.y
2
```

`namedtuple`是一个函数，它用来创建一个自定义的`tuple`对象，并且规定了`tuple`元素的个数，并可以用属性而不是索引来引用`tuple`的某个元素。

这样一来，我们用`namedtuple`可以很方便地定义一种数据类型，它具备tuple的不变性，又可以根据属性来引用，使用十分方便。

可以验证创建的`Point`对象是`tuple`的一种子类：

```plain
>>> isinstance(p, Point)
True
>>> isinstance(p, tuple)
True
```

类似的，如果要用坐标和半径表示一个圆，也可以用`namedtuple`定义：

```plain
# namedtuple('名称', [属性list]):
Circle = namedtuple('Circle', ['x', 'y', 'r'])
```

### deque

使用`list`存储数据时，按索引访问元素很快，但是插入和删除元素就很慢了，因为`list`是线性存储，数据量大的时候，插入和删除效率很低。

deque是为了高效实现插入和删除操作的双向列表，适合用于队列和栈：

```plain
>>> from collections import deque
>>> q = deque(['a', 'b', 'c'])
>>> q.append('x')
>>> q.appendleft('y')
>>> q
deque(['y', 'a', 'b', 'c', 'x'])
```

`deque`除了实现list的`append()`和`pop()`外，还支持`appendleft()`和`popleft()`，这样就可以非常高效地往头部添加或删除元素。

### defaultdict

使用`dict`时，如果引用的Key不存在，就会抛出`KeyError`。如果希望key不存在时，返回一个默认值，就可以用`defaultdict`：

```plain
>>> from collections import defaultdict
>>> dd = defaultdict(lambda: 'N/A')
>>> dd['key1'] = 'abc'
>>> dd['key1'] # key1存在
'abc'
>>> dd['key2'] # key2不存在，返回默认值
'N/A'
```

注意默认值是调用函数返回的，而函数在创建`defaultdict`对象时传入。

除了在Key不存在时返回默认值，`defaultdict`的其他行为跟`dict`是完全一样的。

### OrderedDict

使用`dict`时，Key是无序的。在对`dict`做迭代时，我们无法确定Key的顺序。

如果要保持Key的顺序，可以用`OrderedDict`：

```plain
>>> from collections import OrderedDict
>>> d = dict([('a', 1), ('b', 2), ('c', 3)])
>>> d # dict的Key是无序的
{'a': 1, 'c': 3, 'b': 2}
>>> od = OrderedDict([('a', 1), ('b', 2), ('c', 3)])
>>> od # OrderedDict的Key是有序的
OrderedDict([('a', 1), ('b', 2), ('c', 3)])
```

注意，`OrderedDict`的Key会按照插入的顺序排列，不是Key本身排序：

```plain
>>> od = OrderedDict()
>>> od['z'] = 1
>>> od['y'] = 2
>>> od['x'] = 3
>>> od.keys() # 按照插入的Key的顺序返回
['z', 'y', 'x']
```

`OrderedDict`可以实现一个FIFO（先进先出）的dict，当容量超出限制时，先删除最早添加的Key：

```plain
from collections import OrderedDict
class LastUpdatedOrderedDict(OrderedDict):
    def __init__(self, capacity):
        super(LastUpdatedOrderedDict, self).__init__()
        self._capacity = capacity
    def __setitem__(self, key, value):
        containsKey = 1 if key in self else 0
        if len(self) - containsKey >= self._capacity:
            last = self.popitem(last=False)
            print 'remove:', last
        if containsKey:
            del self[key]
            print 'set:', (key, value)
        else:
            print 'add:', (key, value)
        OrderedDict.__setitem__(self, key, value)
```

### Counter

`Counter`是一个简单的计数器，例如，统计字符出现的个数：

```plain
>>> from collections import Counter
>>> c = Counter()
>>> for ch in 'programming':
...     c[ch] = c[ch] + 1
...
>>> c
Counter({'g': 2, 'm': 2, 'r': 2, 'a': 1, 'i': 1, 'o': 1, 'n': 1, 'p': 1})
```

`Counter`实际上也是`dict`的一个子类，上面的结果可以看出，字符`'g'`、`'m'`、`'r'`各出现了两次，其他字符各出现了一次。

# 2.12 本章小结

## 知识点小结

### 基本数据类型

| 可变数据类型 | 不可变数据类型 |
| --- | --- |
| list | 数字类(bool,int,float,complex) |
| dict | str |
| set | tuple |
| | frozenset |

### 扩展数据类型collectins

1.namedtuple(): 生成可以使用名字来访问元素内容的tuple子类

2.deque: 双端队列，可以快速的从另外一侧追加和推出对象

3.Counter: 计数器，主要用来计数

4.OrderedDict: 有序字典

5.defaultdict: 带有默认值的字典

## 练习

1、请用代码实现：利用下划线将列表的每一个元素拼接成字符串，li＝\['alex', 'eric', 'rain']

2、查找列表中元素，移除每个元素的空格，并查找以a或A开头并且以c结尾的所有元素。

li = \["alec", " aric", "Alex", "Tony", "rain"]

tu = ("alec", " aric", "Alex", "Tony", "rain")

dic = {'k1': "alex", 'k2': ' aric', "k3": "Alex", "k4": "Tony"}

3、写代码，有如下列表，按照要求实现每一个功能

li＝\['alex', 'eric', 'rain']

* 计算列表长度并输出
* 列表中追加元素“seven”，并输出添加后的列表
* 请在列表的第1个位置插入元素“Tony”，并输出添加后的列表
* 请修改列表第2个位置的元素为“Kelly”，并输出修改后的列表
* 请删除列表中的元素“eric”，并输出修改后的列表
* 请删除列表中的第2个元素，并输出删除的元素的值和删除元素后的列表
* 请删除列表中的第3个元素，并输出删除元素后的列表
* 请删除列表中的第2至4个元素，并输出删除元素后的列表
* 请将列表所有的元素反转，并输出反转后的列表
* 请使用for、len、range输出列表的索引
* 请使用enumrate输出列表元素和序号（序号从100开始）
* 请使用for循环输出列表的所有元素

4、写代码，有如下列表，请按照功能要求实现每一个功能

li = \["hello", 'seven', \["mon", \["h", "kelly"], 'all'], 123, 446]

* 请根据索引输出“Kelly”
* 请使用索引找到'all'元素并将其修改为“ALL”，如：li\[0]\[1]\[9]...

5、写代码，有如下元组，请按照功能要求实现每一个功能

tu＝('alex', 'eric', 'rain')

* 计算元组长度并输出
* 获取元组的第2个元素，并输出
* 获取元组的第1-2个元素，并输出
* 请使用for输出元组的元素
* 请使用for、len、range输出元组的索引
* 请使用enumrate输出元祖元素和序号（序号从10开始）

6、有如下变量，请实现要求的功能

tu = ("alex", \[11, 22, {"k1": 'v1', "k2": \["age", "name"], "k3": (11,22,33)}, 44])

* 讲述元祖的特性
* 请问tu变量中的第一个元素“alex”是否可被修改？
* 请问tu变量中的"k2"对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven”
* 请问tu变量中的"k3"对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven”

7、字典

dic = {'k1': "v1", "k2": "v2", "k3": \[11,22,33]}

* 请循环输出所有的key
* 请循环输出所有的value
* 请循环输出所有的key和value
* 请在字典中添加一个键值对，"k4": "v4"，输出添加后的字典
* 请在修改字典中“k1”对应的值为“alex”，输出修改后的字典
* 请在k3对应的值中追加一个元素44，输出修改后的字典
* 请在k3对应的值的第1个位置插入个元素18，输出修改后的字典

8、转换

* 将字符串s = "alex"转换成列表
* 将字符串s = "alex"转换成元祖
* 将列表li = \["alex", "seven"]转换成元组
* 将元祖tu = ('Alex', "seven")转换成列表
* 将列表li = \["alex", "seven"]转换成字典且字典的key按照10开始向后递增

9、元素分类

有如下值集合\[11,22,33,44,55,66,77,88,99,90]，将所有大于66的值保存至字典的第一个key中，将小于66的值保存至第二个key的值中。

即：{'k1':大于66的所有值, 'k2':小于66的所有值}

10、输出商品列表，用户输入序号，显示用户选中的商品

商品li = \["手机", "电脑", '鼠标垫', '游艇']

* 允许用户添加商品
* 用户输入序号显示内容

11、用户交互显示类似省市县N级联动的选择

* 允许用户增加内容
* 允许用户选择查看某一个级别内容

12、列举布尔值是False的所有值

13、有两个列表

l1 = \[11,22,33]

l2 = \[22,33,44]

* 获取内容相同的元素列表
* 获取l1中有，l2中没有的元素列表
* 获取l2中有，l3中没有的元素列表
* 获取l1和l2中内容都不同的元素

14、利用For循环和range输出

* For循环从大到小输出1 - 100
* For循环从小到到输出100 - 1
* While循环从大到小输出1 - 100
* While循环从小到到输出100 - 1
* 在不改变列表数据结构的情况下找最大值li = \[1,3,2,7,6,23,41,243,33,85,56]
* 在不改变列表中数据排列结构的前提下，找出以下列表中最接近最大值和最小值的平均值 的数`li = [-100,1,3,2,7,6,120,121,140,23,411,99,243,33,85,56]`
* 利用for循环和range输出9 \* 9乘法表
* 求100以内的素数和。（编程题）

## 作业

#### 一、三级菜单：

**数据结构**：

```plain
menu = {
    '北京':{
        '海淀':{
            '五道口':{
                'soho':{},
                '网易':{},
                'google':{}
            },
            '中关村':{
                '爱奇艺':{},
                '汽车之家':{},
                'youku':{},
            },
            '上地':{
                '百度':{},
            },
        },
        '昌平':{
            '沙河':{
                '老男孩':{},
                '北航':{},
            },
            '天通苑':{},
            '回龙观':{},
        },
        '朝阳':{},
        '东城':{},
    },
    '上海':{
        '闵行':{
            "人民广场":{
                '炸鸡店':{}
            }
        },
        '闸北':{
            '火车站':{
                '携程':{}
            }
        },
        '浦东':{},
    },
    '山东':{},
}
```

**需求：**

* 可依次选择进入各子菜单
* 可从任意一层往回退到上一层
* 可从任意一层退出程序

> 所需新知识点：列表、字典

#### 二、购物车程序：

##### 数据结构：

```plain
goods = [
{"name": "电脑", "price": 1999},
{"name": "鼠标", "price": 10},
{"name": "游艇", "price": 20},
{"name": "美女", "price": 998},
......
]
```

##### 功能要求：

1、启动程序后，输入用户名密码后，让用户输入工资，然后打印商品列表

2、允许用户根据商品编号购买商品

3、用户选择商品后，检测余额是否够，够就直接扣款，不够就提醒

4、可随时退出，退出时，打印已购买商品和余额

5、在用户使用过程中， 关键输出，如余额，商品已加入购物车等消息，需高亮显示

##### 扩展需求：

1、用户下一次登录后，输入用户名密码，直接回到上次的状态，即上次消费的余额什么的还是那些，再次登录可继续购买

2、允许查询之前的消费记录

## 练习答案

1、请用代码实现：利用下划线将列表的每一个元素拼接成字符串，li＝\['alex', 'eric', 'rain']

```plain
该题目主要是考的字符串的拼接,join方法,
      s = ""
      li = ['alex', 'eric', 'rain']
      s = "_".join(li)
```

2、查找列表中元素，移除每个元素的空格，并查找以a或A开头并且以c结尾的所有元素。

li = \["alec", " aric", "Alex", "Tony", "rain"]

tu = ("alec", " aric", "Alex", "Tony", "rain")

dic = {'k1': "alex", 'k2': ' aric', "k3": "Alex", "k4": "Tony"}

```plain
li = ["alec", " aric", "Alex", "Tony", "rain"]
  for i in li:
      i = i.strip()
      if i.startswith("a") or i.startswith("A")  and i.endswith("c"):
          print(i)
```

3、写代码，有如下列表，按照要求实现每一个功能

li=\['alex', 'eric', 'rain']

* 计算列表长度并输出
* 列表中追加元素“seven”，并输出添加后的列表
* 请在列表的第1个位置插入元素“Tony”，并输出添加后的列表
* 请修改列表第2个位置的元素为“Kelly”，并输出修改后的列表
* 请删除列表中的元素“eric”，并输出修改后的列表
* 请删除列表中的第2个元素，并输出删除的元素的值和删除元素后的列表
* 请删除列表中的第3个元素，并输出删除元素后的列表
* 请删除列表中的第2至4个元素，并输出删除元素后的列表
* 请将列表所有的元素反转，并输出反转后的列表
* 请使用for、len、range输出列表的索引
* 请使用enumrate输出列表元素和序号（序号从100开始）
* 请使用for循环输出列表的所有元素

```plain
li=['alex', 'eric', 'rain']
# 计算列表长度并输出
print(len(li))
# 列表中追加元素“seven”，并输出添加后的列表
li.append("seven")
print(li)
# 请在列表的第1个位置插入元素“Tony”，并输出添加后的列表
li.insert(0, "Tony")
print(li)
# 请修改列表第2个位置的元素为“Kelly”，并输出修改后的列表
li[1] = "Kelly"
print(li)
# 请删除列表中的元素“eric”，并输出修改后的列表
li.remove("eric")  # 指定的是元素
print(li)
# 请删除列表中的第2个元素，并输出删除的元素的值和删除元素后的列表
li_pop = li.pop(1)  # 指定的是下标位置
print(li_pop, li)
# 请删除列表中的第3个元素，并输出删除元素后的列表
del li[2]  # 指定的是下标位置
print(li)
# 请删除列表中的第2至4个元素，并输出删除元素后的列表
# 请将列表所有的元素反转，并输出反转后的列表
# 请使用for、len、range输出列表的索引
for i in range(len(li)):
    print(i)
# 请使用enumrate输出列表元素和序号（序号从100开始）
for index, val in enumerate(li, 100):
    print(index)
# 请使用for循环输出列表的所有元素
for i in li:
    print(i)
```

4、写代码，有如下列表，请按照功能要求实现每一个功能

li = \["hello", 'seven', \["mon", \["h", "kelly"], 'all'], 123, 446]

* 请根据索引输出“Kelly”
* 请使用索引找到'all'元素并将其修改为“ALL”，如：li\[0]\[1]\[9]...

```plain
# 请根据索引输出“Kelly”
li[2][1][1]
# 请使用索引找到'all'元素并将其修改为“ALL”，如：li[0][1][9]...
li[2][2].upper()
li[2][2] = "ALL"
```

5、写代码，有如下元组，请按照功能要求实现每一个功能

tu＝('alex', 'eric', 'rain')

* 计算元组长度并输出
* 获取元组的第2个元素，并输出
* 获取元组的第1-2个元素，并输出
* 请使用for输出元组的元素
* 请使用for、len、range输出元组的索引
* 请使用enumrate输出元祖元素和序号（序号从10开始）

```plain
# 计算元组长度并输出
print(len(t))
# 获取元组的第2个元素，并输出
print(t[1])
# 获取元组的第1-2个元素，并输出
print(t[1:2])
# 请使用for输出元组的元素
for i in t:
    print(i)
# 请使用for、len、range输出元组的索引
for i in range(len(t)):
    print(i)
请使用enumrate输出元祖元素和序号（序号从10开始）
for index, val in enumerate(t, 10):
    print(index)
```

6、有如下变量，请实现要求的功能

tu = ("alex", \[11, 22, {"k1": 'v1', "k2": \["age", "name"], "k3": (11,22,33)}, 44])

* 讲述元祖的特性
* 请问tu变量中的第一个元素“alex”是否可被修改？
* 请问tu变量中的"k2"对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven”
* 请问tu变量中的"k3"对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven”

```plain
# 讲述元祖的特性
1、有序的集合
2、通过偏移来取数据
3、属于不可变的对象，不能在原地修改内容，没有排序，修改等操作。
# 请问tu变量中的第一个元素“alex”是否可被修改？
上题中的元组的第三个特点
# 请问tu变量中的"k2"对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven”
type(tu[1][2]["k2"])  -- list
可以
tu[1][2]["k2"].append("Seven")
# 请问tu变量中的"k3"对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven”
type(tu[1][2]["k3"])
tuple
不可以
```

7、字典

dic = {'k1': "v1", "k2": "v2", "k3": \[11,22,33]}

* 请循环输出所有的key
* 请循环输出所有的value
* 请循环输出所有的key和value
* 请在字典中添加一个键值对，"k4": "v4"，输出添加后的字典
* 请在修改字典中“k1”对应的值为“alex”，输出修改后的字典
* 请在k3对应的值中追加一个元素44，输出修改后的字典
* 请在k3对应的值的第1个位置插入个元素18，输出修改后的字典

```plain
# 请循环输出所有的key
dic.keys()
# 请循环输出所有的value
dic.values()
# 请循环输出所有的key和value
dic.items()
# 请在字典中添加一个键值对，"k4": "v4"，输出添加后的字典
dic["k4"] = "v4"
# 请在修改字典中“k1”对应的值为“alex”，输出修改后的字典
dic["k1"] = "alex"
{'k2': 'v2', 'k1': 'alex', 'k3': [11, 22, 33]}
# 请在k3对应的值中追加一个元素44，输出修改后的字典
dic["k3"].append(44)
{'k2': 'v2', 'k1': 'v1', 'k3': [11, 22, 33, 44]}
# 请在k3对应的值的第1个位置插入个元素18，输出修改后的字典
dic["k3"].insert(1, 18)
{'k2': 'v2', 'k1': 'v1', 'k3': [11, 18, 22, 33]}
```

8、转换

* 将字符串s = "alex"转换成列表
* 将字符串s = "alex"转换成元祖
* 将列表li = \["alex", "seven"]转换成元组
* 将元祖tu = ('Alex', "seven")转换成列表
* 将列表li = \["alex", "seven"]转换成字典且字典的key按照10开始向后递增

```plain
# 将字符串s = "alex"转换成列表
list(s)
# 将字符串s = "alex"转换成元祖
tuple(s)
# 将列表li = ["alex", "seven"]转换成元组
tuple(li)
# 将元祖tu = ('Alex', "seven")转换成列表
list(tu)
# 将列表li = ["alex", "seven"]转换成字典且字典的key按照10开始向后递增
dict(zip([i for i in range(10, len(li)+11)], li))
```

9、元素分类

有如下值集合\[11,22,33,44,55,66,77,88,99,90]，将所有大于66的值保存至字典的第一个key中，将小于66的值保存至第二个key的值中。

即：{'k1':大于66的所有值, 'k2':小于66的所有值}

```plain
li = [11, 22, 33, 44, 55, 66, 77, 88, 99]
dic = {
    "k1": [],
    "k2": [],
}
for i in li:
    if i >= 66:
        dic["k1"].append(i)
    else:
        dic["k2"].append(i)
print(dic)
```

10、输出商品列表，用户输入序号，显示用户选中的商品

商品li = \["手机", "电脑", '鼠标垫', '游艇']

* 允许用户添加商品
* 用户输入序号显示内容

```plain
goods = [
    {"name": "电脑", "price": 1999},
    {"name": "鼠标", "price": 10},
    {"name": "游艇", "price": 20},
    {"name": "美女", "price": 998}
]
wages = int(input('请输入工资：'))
shopping_car = []
exit_flag = False
while not exit_flag:
    print('--------商品列表--------')
    for index, i in enumerate(goods):
        print(index, i)
    choice = (input('请输入要购买的商品：'))
    if choice.isdigit():  
        if 0 <= int(choice) < len(goods):
            if wages >= goods[int(choice)].get('price'):  
                wages -= goods[int(choice)].get('price')
                print('\033[32;1m余额：\033[0m', wages)
                shopping_car.append(goods[int(choice)])
                print("\033[32;1m已将商品：%s 添加进购物车\033[0m" % (goods[int(choice)]))
            else:
                print('\033[31;1m余额不足\033[0m')
        else:
            print('\033[31;1m商品不存在！\033[0m')
    elif choice == "q":
        print('-----您已购买以下商品-----')
        for index, k in enumerate(shopping_car):
            print(index, k)
        print('\033[32;1m账户余额\033[0m', wages)
        exit_flag = True
    elif choice == "a":
        print("----您当前处于商品添加页面----")
        print("当前存在的商品：")
        for index, i in enumerate(goods):  
            print(index, i)
        name = input("商品名称：")
        price = input("商品价格：")
        dic = {"name": name, "price": int(price)}
        goods.append(dic)
        print("添加成功：")
        for index, i in enumerate(goods):  # enumerate（枚举）列表的索引值
            print(index, i)
```

11、用户交互显示类似省市县N级联动的选择

* 允许用户增加内容
* 允许用户选择查看某一个级别内容

12、列举布尔值是False的所有值

13、有两个列表

l1 = \[11,22,33]

l2 = \[22,33,44]

* 获取内容相同的元素列表
* 获取l1中有，l2中没有的元素列表
* 获取l2中有，l3中没有的元素列表
* 获取l1和l2中内容都不同的元素

14、利用For循环和range输出

* For循环从大到小输出1 - 100
* For循环从小到到输出100 - 1
* While循环从大到小输出1 - 100
* While循环从小到到输出100 - 1

```plain
```

15、利用for循环和range输出9 \* 9乘法表

```plain
print('\n'.join([ ' '.join([ "%d*%d=%2s" %(y,x,x*y) for y in range(1,x+1)]) for x in range(1,10)]))
```

```plain
for y in range(1,10):
    for x in range(1,10):
        if x <= y:
            print("%d*%d=%2s\t"%(y,x,x*y),end=" ")
    print("")

```

16、求100以内的素数和。（编程题）

\#求解思路，loop 100次，每次拿当前的值依次除以比它小的值，比如 当前值 是10， 那就拿10除以9，8，7，6，...2，如果其中任何一个可以被整除，就代表 10不是素数

```plain
#!/usr/bin/env python
# -*- coding:utf-8 -*-
# 素数又称为质数，它指的是只能被1和它本身整除的整数。其中，1不是素数，任何时候都不用考虑1。
L = [] # 定义一个初始的素数列表
for n in range(2,101): # 循环100以内的素数n,从2开始,0、1不是素数
    flag = True # 设置一个标志位,flag = True代表是素数，flag = Flase代表不是素数
    for i in range(2,n): # 除以比它小的所有数（不包括1和它本身）,看它是否还有其他因数
        if n % i == 0:
            flag = False # 出现一次余数为0就代表可以除尽，即代表这个数为素数，就可以设置flag = False
            break # 只要第一次出现flag = False，就不用继续往下循环，直接退出整个循环（第二层）
    if flag == True:
        L.append(n) # 当flag = True时代表n为素数,追加到素数列表中
print("100以内的所有素数:",L)
print(sum(L))
```

1. 在不改变列表中数据排列结构的前提下，找出以下列表中最接近最大值和最小值的平均值 的数

```plain
# 解题思路，找到最大值 ，找到最小值 ，求平均值 ，找到列表中离这个平均值 最近的值
li = [-100,1,3,2,7,6,120,121,140,23,411,99,243,33,85,56]
max_n = li[0]
min_n = li[0]
for i in li:
    if i > max_n:
        max_n = i
    if i < min_n:
        min_n = i
avg_n = (min_n+max_n)//2
print(min_n,max_n,avg_n)
avg_like = li[0]
for i in li:
    if abs(i - avg_n) < abs(avg_like - avg_n):
        avg_like = i
print('最接近平均值 的是',avg_like)
```

> 更新: 2021-04-30 16:42:53  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/spvur7>