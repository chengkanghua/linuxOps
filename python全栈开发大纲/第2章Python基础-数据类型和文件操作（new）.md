# 第2章 Python基础-数据类型和文件操作(new)

# 2.1 上章补充-变量的创建过程

## 变量创建过程

首先，当我们定义了一个变量name = ‘oldboy’的时候，在内存中其实是做了这样一件事：

程序开辟了一块内存空间，将‘oldboy’存储进去，再让变量名name指向‘oldboy’所在的内存地址。如下图所示：

<!-- OCR_START -->
- 'oldboy
- name
<!-- OCR_END -->

我们可以通过id()方法查看这个变量在内存中的地址

```plain
>>> name = "oldboy"
>>> id(name)
4317182304
```

## 变量的修改

一般我们认为修改一个变量就是用新值把旧值覆盖掉， 可python是这样实现的么？

```plain
>>> name = "oldboy"
>>> id(name)
4317182304
>>> 
>>> name = "alex" 
>>> id(name)  # 如果只是在原有地址上修改，那么修改后内存地址不应该变化呀。
4317182360
```

实际的原理什么样的呢？ 程序先申请了一块内存空间来存储‘oldboy’，让name变量名指向这块内存空间

执行到name=‘alex’之后又申请了另一块内存空间来存储‘alex’，并让原本指向‘oldboy’内存的链接断开，让name再指向‘alex’。

<!-- OCR_START -->
- 'oldboy
- name
- 'alex'
<!-- OCR_END -->

**变量的指向关系**

提问：下面这段代码为何出现这样的现象？

```plain
>>> name1 = 'oldboy'
>>> name2 = name1   # 把name1赋值给name2,这样name2的值也是oldboy了
>>> print(name1,name2)
oldboy oldboy
>>> 
>>> name1 = 'alex'  
>>> print(name1,name2) #改了name1后，name2为何没跟着改？ 
alex oldboy
```

要想知道上面问题的结果是为什么，首先要了解在内存中两个变量的存储情况

<!-- OCR_START -->
- 'alex'
- name1
- "oldboy'
- name2
<!-- OCR_END -->

从上面的示意图中我们可以知道，当执行name2=name1这句话的时候，事实上是让name2指向了‘oldboy’所在的内存地址。

修改name1的值，相当于断开了name1到‘oldboy’的链接，重新建立name1和‘alex’之间的链接。在这个过程中，始终没有影响到name2和‘oldboy‘之间的关系，因此name2还是‘oldboy’，而name1变成了‘alex’。

[\
](http://book.luffycity.com/python-book/di-2-zhang-python-ji-7840-shu-ju-lei-xing-he-wen-jian-cao-zuo/22-shang-zhang-bu-5145-shen-fen-yun-suan-he-none.html)

# 2.2 上章补充-身份运算和None

## 身份运算

python 中有很多种数据类型， 查看一个数据的类型的方法是type().

```plain
>>> name="小猿圈"
>>> age = 1
>>> 
>>> name
'小猿圈'
>>> 
>>> type(name),type(age)
(, )
```

判断一个数据类型是不是str, or int等，可以用身份运算符is

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

```plain
>>> type(name) is str
True
>>> 
>>> type(name) is not int
True
```

## 空值None

代表什么都没有的意思，一般用在哪呢？ 比如玩游戏，你要初始化一个女朋友， 需要填上姓名、年龄、身高、体重等信息， 这些信息是让玩家填的，在填之前，你要先把变量定义好，那就得存个值 ，这个值用0,1来占位不合适 ，用True,False也不合适 ，用None最合适

```plain
>>> name=None
>>> age=None
>>> height=None
>>> weight=None
>>> 
>>> name,age,height,weight
(None, None, None, None)
>>>
```

此时可用is 运算符来判断变量是不是None

```plain
>>> if name is None:
...  print("你的女朋友还没起名字呢.")
... 
你的女朋友还没起名字呢.
```

其实用==判断也行，但是不符合开发规范

```plain
>>> name == None
True
```

## 三元运算

显的很NB的代码写法。

```plain
name = "Eva"
sex = None
# 普通写法
if name == "Eva":
    sex = "Female"
else:
    sex = "Male"
# 用三元运算来写
sex = "Female" if name == "Eva" else "Male"
```

# 2.3 细讲数据类型-列表

第一章我们大概介绍了列表的基本用法，本节我们学习下

**定义：**\[]内以逗号分隔，按照索引，存放各种数据类型，每个位置代表一个元素

**再回顾下列表的特点：**

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

## 列表的增加操作

**追加**，数据会追加到尾部

```plain
>>> names
['alex', 'jack']
>>> names.append("rain")
>>> names.append("eva")
>>> 
>>> names
['alex', 'jack', 'rain', 'eva']
```

**插入**，可插入任何位置

```plain
>>> names.insert(2,"黑姑娘")
>>> names
['alex', 'jack', '黑姑娘', 'rain', 'eva']
>>>
```

**合并**,可以把另一外列表的值合并进来

```plain
>>> n2 = ["狗蛋","绿毛","鸡头"]
>>> names
['alex', 'jack', '黑姑娘', 'rain', 'eva']
>>> names.extend(n2)
>>> names
['alex', 'jack', '黑姑娘', 'rain', 'eva', '狗蛋', '绿毛', '鸡头']
```

**列表嵌套**

```plain
>>> names.insert(2,[1,2,3])
>>> names 
['alex', 'jack', [1, 2, 3], '黑姑娘', 'rain', 'eva', '狗蛋', '绿毛', '鸡头']
>>> names[2][1]
2
```

## 删除操作

**del 直接删**

```plain
>>> names
['alex', 'jack', [1, 2, 3], '黑姑娘', 'rain', 'eva', '狗蛋', '绿毛', '鸡头']
>>> del names[2]
>>> names
['alex', 'jack', '黑姑娘', 'rain', 'eva', '狗蛋', '绿毛', '鸡头']
```

**pop 删**

```plain
>>> names
['alex', 'jack', '黑姑娘', 'rain', 'eva', '狗蛋', '绿毛', '鸡头']
>>> names.pop() #默认删除最后一个元素并返回被删除的值
'鸡头'
>>> names
['alex', 'jack', '黑姑娘', 'rain', 'eva', '狗蛋', '绿毛']
>>> help(names.pop)
>>> names.pop(1)  #删除指定元素
'jack'
```

**clear 清空**

```plain
>>> n2
['狗蛋', '绿毛', '鸡头']
>>> n2.clear()
>>> n2
[]
```

## 修改操作

```plain
>>> names
['alex', '黑姑娘', 'rain', 'eva', '狗蛋', '绿毛']
>>> names[0] = "金角大王"
>>> names[-1] = "银角大王"
>>> names
['金角大王', '黑姑娘', 'rain', 'eva', '狗蛋', '银角大王']
```

## 查操作

```plain
>>> names
['金角大王', '黑姑娘', 'rain', 'eva', '狗蛋', '银角大王', 'eva']
>>> 
>>> names.index("eva") #返回从左开始匹配到的第一个eva的索引
3
>>> names.count("eva") #返回eva的个数
2
```

## 切片

切片就像切面包，可以同时取出元素的多个值

```plain
names[start:end]
```

```plain
>>> names
['金角大王', '黑姑娘', 'rain', 'eva', '狗蛋', '银角大王', 'eva']
>>> names[1:4]  #不包含下标4的元素
['黑姑娘', 'rain', 'eva']
```

\*切片的特性是顾头不顾尾，即start的元素会被包含，end-1是实际取出来的值

**倒着切**

```plain
>>> names[-5:-1]
['rain', 'eva', '狗蛋', '银角大王']
```

但其实我想要的是后5个，只打印了4个，’eva’这个值没出来，为什么，因为上面提到的顾头不顾尾

可是想把后5个全取出来如何做呢？

```plain
>>> names[-5:]
['rain', 'eva', '狗蛋', '银角大王', 'eva']
```

如果取前几个值 ，一样可以把:号左边的省掉

```plain
>>> names
['金角大王', '黑姑娘', 'rain', 'eva', '狗蛋', '银角大王', 'eva']
>>> names[0:3]
['金角大王', '黑姑娘', 'rain']
>>> names[:3]  #跟上面一样的效果
['金角大王', '黑姑娘', 'rain']
```

\*\*步长，\*\*允许跳着取值

```plain
names[start:end:step] #step 默认是1
```

```plain
>>> a
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> a[0:7:2]  #设置步长为2
[0, 2, 4, 6]
```

```plain
>>> a
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> 
>>> a[::3] #按步长3打印列表，第1个:是省略掉的start:end
[0, 3, 6, 9]
```

**列表反转**

```plain
>>> a[::-1] #通过把步长设置成负值，可达到列表返转的效果
[9, 8, 7, 6, 5, 4, 3, 2, 1, 0] 
>>> a[::-2]
[9, 7, 5, 3, 1]
```

## 排序&反转

**排序**

```plain
>>> a = [83,4,2,4,6,19,33,21]
>>> a.sort()
>>> a
[2, 4, 4, 6, 19, 21, 33, 83]
```

下面的排序结果为何如何解释？

```plain
>>> names=['金角大王', 'rain', '@', '黑姑娘', '狗蛋', "4","#",'银角大王', 'eva']
>>> names.sort()
>>> names
['#', '4', '@', 'eva', 'rain', '狗蛋', '金角大王', '银角大王', '黑姑娘']
```

答案全在这张表上，虽然后面我们会讲，但现在先知道，排序的优化级规则是按这张表来的

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

**反转**

```plain
>>> names
['#', '4', '@', 'eva', 'rain', '狗蛋', '金角大王', '银角大王', '黑姑娘']
>>> names.reverse()
>>> names
['黑姑娘', '银角大王', '金角大王', '狗蛋', 'rain', 'eva', '@', '4', '#']
```

## 循环列表

```plain
>>> for i in names:  
...     print(i)
... 
黑姑娘
银角大王
金角大王
狗蛋
rain
eva
@
4
#
```

## 练习

针对列表names=\[‘金角大王’, ‘黑姑娘’, ‘rain’, ‘eva’, ‘狗蛋’, ‘银角大王’, ‘eva’,’鸡头’]进入以下操作

1. 通过names.index()的方法返回第2个eva的索引值
2. 把以上的列表通过切片的形式实现反转
3. 打印列表中所有下标为奇数的值
4. 通过names.index()方法找到第2个eva值 ，并将其改成EVA
5. 编程练习-购物车程序开发

##### 根据以下数据结构：

```plain
goods = [
{"name": "电脑", "price": 1999},
{"name": "鼠标", "price": 10},
{"name": "游艇", "price": 20},
{"name": "美女", "price": 998},
......
]
```

##### 实现功能要求：

1、启动程序后，让用户输入工资，然后进入循环，打印商品列表和编号

2、允许用户根据商品编号选择商品

3、用户选择商品后，检测余额是否够，够就直接扣款，并加入购物车， 不够就提醒余额不足

4、可随时退出，退出时，打印已购买商品和余额

# 2.4 细讲数据类型-元组

有些时候我们的列表数据不想被人修改时怎么办？ 就可以用元组存放，元组又被称为只读列表，不能修改。

*定义：与列表类似，只不过［］改成（）*

*特性：*

\_　　1.可存放多个值

　　2.不可变

　　3.\_按照从左到右的顺序定义元组元素，下标从0开始顺序访问，有序

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

注意：元组本身不可变，如果元组中还包含其他可变元素，这些可变元素可以改变

```plain
>>> data 
(99, 88, 77, ['Alex', 'Jack'], 33)
>>> data[3][0] = '金角大王'
>>> data
(99, 88, 77, ['金角大王', 'Jack'], 33)
```

为啥呢？ 因为元组只是存每个元素的内存地址，上面\[‘金角大王’, ‘Jack’]这个列表本身的内存地址存在元组里确实不可变，但是这个列表包含的元素的内存地址是存在另外一块空间里的，是可变的。

<!-- OCR_START -->
- 金角大王
- “Jack"
- 4357025384
- 4315464960
- (99，88，77,
- 4357373448
- ，33)
<!-- OCR_END -->

# 2.5 细讲数据类型-字符串

## 定义

字符串是一个有序的字符的集合，用于存储和表示基本的文本信息，’ ‘或’’ ‘’或’’’ ‘’’中间包含的内容称之为字符串

**创建：**

```plain
s = 'Hello,Eva！How are you?'
```

## 特性：

1. 按照从左到右的顺序定义字符集合，下标从0开始顺序访问，有序
2. 

<!-- OCR_START -->
| str | 排名 |
| --- | --- |
| h | e |
| 索引 | 1 |
| 2 | 3 |
<!-- OCR_END -->

3. 可以进行切片操作
4. 不可变，字符串是不可变的，不能像列表一样修改其中某个元素，所有对字符串的修改操作其实都是相当于生成了一份新数据。

补充：

1.字符串的单引号和双引号都无法取消特殊字符的含义，如果想让引号内所有字符均取消特殊意义，在引号前面加r，如name＝r’l\thf’

## 字符串的常用操作

字符串操作方法有非常多，但有些不常用 ，我们只讲重要的一些给大家，其它100年都用不上的有兴趣可以自己研究

<!-- OCR_START -->
```text
capitalize(self)
casefold(self)
center(self, width, fillchar=None)
count(self, sub, start=None, end=None)
endswith(self, suffix, start=None, end=None)
find(self, sub, start=None, end=None)
format(self, *args, **kwargs)
format_map(self, mapping)
index(self, sub, start=None, end=None)
f isdigit(self)
f islower(self)
isspace(self)
isupper(self)
f join(self, iterable)
ljust(self, width, fillchar=None)
lower(self)
Istrip(self, chars=None)
replace(self, old, new, count=None)
rjust(self, width, fillchar=None)
rsplit(self, sep=None, maxsplit=-1)
rstrip(self, chars=None)
split(self, sep=None, maxsplit=-1)
startswith(self, prefix, start=None, end=None)
strip(self, chars=None)
swapcase(self)
upper(self)
zfill(self, width)
```
<!-- OCR_END -->

```plain
def capitalize(self):  
    首字母大写
def casefold(self):  
    把字符串全变小写
    >> > c = 'Alex Li'
    >> > c.casefold()
    'alex li'
def center(self, width, fillchar=None):  
    >> > c.center(50, "-")
    '---------------------Alex Li----------------------'
def count(self, sub, start=None, end=None):  
    """
    S.count(sub[, start[, end]]) -> int
    >>> s = "welcome to apeland"
    >>> s.count('e')
    3
    >>> s.count('e',3)
    2
    >>> s.count('e',3,-1)
    2
def encode(self, encoding='utf-8', errors='strict'):  
    """
    编码，日后讲
def endswith(self, suffix, start=None, end=None):
    >> > s = "welcome to apeland"
    >> > s.endswith("land") 判断以什么结尾
    True
def find(self, sub, start=None, end=None):  
    """
    S.find(sub[, start[, end]]) -> int
    Return the lowest index in S where substring sub is found,
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.
    Return -1 on failure.
    """
    return 0
def format(self, *args, **kwargs):  # known special case of str.format
    >> > s = "Welcome {0} to Apeland,you are No.{1} user."
    >> > s.format("Eva", 9999)
    'Welcome Eva to Apeland,you are No.9999 user.'
    >> > s1 = "Welcome {name} to Apeland,you are No.{user_num} user."
    >> > s1.format(name="Alex", user_num=999)
    'Welcome Alex to Apeland,you are No.999 user.'
def format_map(self, mapping):  
    """
    S.format_map(mapping) -> str
    Return a formatted version of S, using substitutions from mapping.
    The substitutions are identified by braces ('{' and '}').
    """
    讲完dict再讲这个
def index(self, sub, start=None, end=None):  
    """
    S.index(sub[, start[, end]]) -> int
    Return the lowest index in S where substring sub is found, 
    such that sub is contained within S[start:end].  Optional
    arguments start and end are interpreted as in slice notation.
    Raises ValueError when the substring is not found.
    """
def isdigit(self):  
    """
    S.isdigit() -> bool
    Return True if all characters in S are digits
    and there is at least one character in S, False otherwise.
    """
    return False
def islower(self):  
    """
    S.islower() -> bool
    Return True if all cased characters in S are lowercase and there is
    at least one cased character in S, False otherwise.
    """
def isspace(self):  
    """
    S.isspace() -> bool
    Return True if all characters in S are whitespace
    and there is at least one character in S, False otherwise.
    """
def isupper(self):  
    """
    S.isupper() -> bool
    Return True if all cased characters in S are uppercase and there is
    at least one cased character in S, False otherwise.
    """
def join(self, iterable):  
    """
    S.join(iterable) -> str
    Return a string which is the concatenation of the strings in the
    iterable.  The separator between elements is S.
    """
    >>> n = ['alex','jack','rain']
    >>> '|'.join(n)
    'alex|jack|rain'
def ljust(self, width, fillchar=None):  
    """
    S.ljust(width[, fillchar]) -> str
    Return S left-justified in a Unicode string of length width. Padding is
    done using the specified fill character (default is a space).
    """
    return ""
def lower(self):  
    """
    S.lower() -> str
    Return a copy of the string S converted to lowercase.
    """
    return ""
def lstrip(self, chars=None):  
    """
    S.lstrip([chars]) -> str
    Return a copy of the string S with leading whitespace removed.
    If chars is given and not None, remove characters in chars instead.
    """
    return ""
def replace(self, old, new, count=None):  
    """
    S.replace(old, new[, count]) -> str
    Return a copy of S with all occurrences of substring
    old replaced by new.  If the optional argument count is
    given, only the first count occurrences are replaced.
    """
    return ""
def rjust(self, width, fillchar=None):  
    """
    S.rjust(width[, fillchar]) -> str
    Return S right-justified in a string of length width. Padding is
    done using the specified fill character (default is a space).
    """
    return ""
def rsplit(self, sep=None, maxsplit=-1):  
    """
    S.rsplit(sep=None, maxsplit=-1) -> list of strings
    Return a list of the words in S, using sep as the
    delimiter string, starting at the end of the string and
    working to the front.  If maxsplit is given, at most maxsplit
    splits are done. If sep is not specified, any whitespace string
    is a separator.
    """
    return []
def rstrip(self, chars=None):  
    """
    S.rstrip([chars]) -> str
    Return a copy of the string S with trailing whitespace removed.
    If chars is given and not None, remove characters in chars instead.
    """
    return ""
def split(self, sep=None, maxsplit=-1):  
    """
    S.split(sep=None, maxsplit=-1) -> list of strings
    Return a list of the words in S, using sep as the
    delimiter string.  If maxsplit is given, at most maxsplit
    splits are done. If sep is not specified or is None, any
    whitespace string is a separator and empty strings are
    removed from the result.
    """
    return []
def startswith(self, prefix, start=None, end=None):  
    """
    S.startswith(prefix[, start[, end]]) -> bool
    Return True if S starts with the specified prefix, False otherwise.
    With optional start, test S beginning at that position.
    With optional end, stop comparing S at that position.
    prefix can also be a tuple of strings to try.
    """
    return False
def strip(self, chars=None):  
    """
    S.strip([chars]) -> str
    Return a copy of the string S with leading and trailing
    whitespace removed.
    If chars is given and not None, remove characters in chars instead.
    """
    return ""
def swapcase(self):  
    """
    S.swapcase() -> str
    Return a copy of S with uppercase characters converted to lowercase
    and vice versa.
    """
    return ""
def upper(self):  
    """
    S.upper() -> str
    Return a copy of S converted to uppercase.
    """
    return ""
def zfill(self, width):  
    """
    S.zfill(width) -> str
    Pad a numeric string S with zeros on the left, to fill a field
    of the specified width. The string S is never truncated.
    """
    return ""
```

# 2.6 细讲数据类型-字典

## 引子

我们学了列表 ， 现在有个需求， 把你们公司每个员工的姓名、年龄、职务、工资存到列表里，你怎么存？

```plain
staff_list = [
    ["Alex",23,"CEO",66000],
    ["黑姑娘",24,"行政",4000],
    ["佩奇",26,"讲师",40000],
    # [xxx,xx,xx,xxx]
    # [xxx,xx,xx,xxx]
    # [xxx,xx,xx,xxx]  
]
```

这样存没问题，不过你要查一个人的工资的话， 是不是得把列表遍历一遍

```plain
for i in staff_list:
    if i[0] == '黑姑娘':
        print(i)
        break
```

但假如你公司有2万人，如果你要找的黑姑娘正好在列表末尾，那意味着你要遍历2万次，才能找到这个信息。列表越大，查找速度越慢。

好了，现在福音来了， 接下来学要的字典可以 查询数据又快、操作又方便，是日后开发中必备神器。

字典是Python语言中唯一的映射类型。

## 定义：

**｛key1:value1,key2:value2｝**

```plain
1、键与值用冒号“：”分开；
2、项与项用逗号“，”分开；
```

示例：

```plain
info = {
    "name":"小猿圈",
    "mission": "帮一千万极客高效学编程",
    "website": "http://apeland.com"
}
```

**特性：**

1. key-value结构
2. key必须为不可变数据类型、必须唯一
3. 可存放任意多个value、可修改、可以不唯一
4. 无序
5. 查询速度快，且不受dict的大小影响，至于为何快？我们学完hash再解释。

## 创建操作

```plain
>>>person = {"name": "alex", 'age': 20} 
#或
>>>person = dict(name='seven', age=20)
#或
>>>person = dict({"name": "egon", 'age': 20})
#或
>>> {}.fromkeys([1,2,3,4,5,6,7,8],100)
{1: 100, 2: 100, 3: 100, 4: 100, 5: 100, 6: 100, 7: 100, 8: 100}
```

## 增加操作

```plain
names = {
    "alex": [23, "CEO", 66000],
    "黑姑娘": [24, "行政", 4000],
}
# 新增k
names["佩奇"] = [26, "讲师", 40000]
names.setdefault("oldboy",[50,"boss",100000])  # D.setdefault(k[,d]) -> D.get(k,d), also set D[k]=d if k not in D
```

## 删除操作

```plain
names.pop("alex") # 删除指定key
names.popitem()   # 随便删除1个key
del names["oldboy"] # 删除指定key,同pop方法
names.clear()     # 清空dict
```

## 修改操作

```plain
dic['key'] = 'new_value',如果key在字典中存在，'new_value'将会替代原来的value值；
dic.update(dic2) 将字典dic2的键值对添加到字典dic中
```

## 查操作

```plain
dic['key'] #返回字典中key对应的值，若key不存在字典中，则报错；
dic.get(key, default = None)#返回字典中key对应的值，若key不存在字典中，则返回default的值（default默认为None）
'key' in dic #若存在则返回True，没有则返回False
dic.keys() 返回一个包含字典所有KEY的列表；
dic.values() 返回一个包含字典所有value的列表；
dic.items() 返回一个包含所有（键，值）元组的列表；
```

## 循环

```plain
1、for k in dic.keys()
2、for k,v in dic.items() 
3、for k in dic   # 推荐用这种，效率速度最快
info = {
    "name":"小猿圈",
    "mission": "帮一千万极客高效学编程",
    "website": "http://apeland.com"
}
for k in info:
    print(k,info[k])
输出
name 小猿圈
mission 帮一千万极客高效学编程
website http://apeland.com
```

## 求长度

```plain
len(dic)
```

## 练习题

1. 用你能想到的最少的代码生成一个包含100个key的字典，每个value的值不能一样
2. {‘k0’: 0, ‘k1’: 1, ‘k2’: 2, ‘k3’: 3, ‘k4’: 4, ‘k5’: 5, ‘k6’: 6, ‘k7’: 7, ‘k8’: 8, ‘k9’: 9} 请把这个dict中key大于5的值value打印出来。
3. 把题2中value是偶数的统一改成-1
4. 请设计一个dict, 存储你们公司每个人的信息， 信息包含至少姓名、年龄、电话、职位、工资，并提供一个简单的查找接口，用户按你的要求输入要查找的人，你的程序把查到的信息打印出来

# 2.7 细讲数据类型-集合

## 定义

集合跟我们学的列表有点像，也是可以存一堆数据，不过它有几个独特的特点，令其在整个Python语言中占有一席之地，

1. 里面的元素不可变，代表你不能存一个list、dict 在集合里，字符串、数字、元组等不可变类型可以存
2. 天生去重，在集合里没办法存重复的元素
3. 无序，不像列表一样通过索引来标记在列表中的位置 ，元素是无序的，集合中的元素没有先后之分，如集合{3,4,5}和{3,5,4}算作同一个集合

基于上面的特性，我们可以用集合来干2件事，**去重和关系运算**

## 语法

**创建集合**

```plain
>>> a = {1,2,3,4,2,'alex',3,'rain','alex'}
>>> a
{1, 2, 3, 4, 'alex', 'rain'}
```

由于它是天生去重的，重复的值你根本存不进去

**帮列表去重**

帮列表去重最快速的办法是什么？ 就是把它转成集合，去重完，再转回列表

```plain
>>> b
[1, 2, 3, 4, 2, 'alex', 3, 'rain', 'alex']
>>> set(b)
{1, 2, 3, 4, 'alex', 'rain'}
>>> 
>>> b = list(set(b)) #一句代码搞定
>>> b
[1, 2, 3, 4, 'alex', 'rain']
```

## 增删改查

```plain
>>> a
{1, 2, 3, 4, 'alex', 'rain'}
#新增
>>> a.add('黑姑娘')  
#删除discard
>>> a
{2, 3, '黑姑娘', 'alex', 'rain'}
>>> a.discard('rain')   #删除一个存在的值
>>> a.discard('rain2')   #如果这个值不存在，do nothing.
>>> a
{2, 3, '黑姑娘', 'alex'}
>>> 
#随机删除,少用，或特定场景用
>>> a.pop() #删除并返回
1
#删除remove
>>> a.remove(4)
#查
>>> a
{2, 3, '黑姑娘', 'alex', 'rain'}
>>> 'alex' in a
True
#改
呵呵，不能改。。。
```

## 关系运算

```plain
s_1024 = {"佩奇","老男孩","海峰","马JJ","老村长","黑姑娘","Alex"}
s_pornhub = {"Alex","Egon","Rain","马JJ","Nick","Jack"}
print(s_1024 & s_pornhub)  # 交集, elements in both set
print(s_1024 | s_pornhub)  # 并集 or 合集
print(s_1024 - s_pornhub)  # 差集 , only in 1024
print(s_pornhub - s_1024)  # 差集,  only in pornhub
print(s_1024 ^ s_pornhub)  # 对称差集, 把脚踩2只船的人T出去
```

两个集合之间一般有三种关系，相交、包含、不相交。在Python中分别用下面的方法判断：

```plain
print(s_1024.isdisjoint(s_pornhub))     # 判断2个集合是不是不相交，返回True or False
print(s_1024.issubset(s_pornhub))       # 判断s_1024是不是s_pornhub的子集，返回True or False
print(s_1024.issuperset(s_pornhub))     # 判断s_1024是不是s_pornhub的父集，返回True or False
```

# 2.8 秒懂二进制

## 引子

终于要讲2进制啦，讲之前，我们先讲个小故事，

大家知道古时候的中国是如何通信的么？

假如，战国时期两个国家要打仗了，我们垒了城墙，每隔一段就有兵镇守，现在有人来攻打我们了，然后我们是不是得通知其他人有人来打我们来了？怎么通知？

1. 派个人跑着去？等人回来，仗打完了
2. 飞鸽传书？不靠谱，鸽子会被敌人射下来做烧烤
3. 点狼烟信号，可行

好了，现在有5000精兵来打你了，你点了根狼烟搬救兵，从东边来了10个人，西边来了10个人，20个人来了，和你们一起战死了。

这怎么办？

我们不能这么保守了，只要我一点狼烟说有人来打我们了，先来他10000人，结果来了200个敌人，我们呼啦啦来一大堆人，是不是浪费资源啊？

我们是不是除了告诉人家要打仗了，还得告诉别人来了多少人啊？那我们怎么告诉？

来一个人点一根？来了5000人，点5000根，不用打了，自己给自己烧死了

那好我们就约定，来10个人点1根，来100个人点2根，来1000个人点3根，来5000个点4根，来10000个点5根。。。以此类推，恭喜你， 这样确实就能解决问题啦，粗略的能告诉友军来了多少敌人。

但现在友军将领提了一个变态的要求，你必须精确的告诉他一共来了多少敌人，他才安排来救援。 如何精确传送到底有多少个敌人？

各位同学可以自行思考研究5分钟，但我估计你想不出来哈哈。

**好了，现在来看看我的方法。。。**

假如我们有20个狼烟孔，狼烟孔点燃了代表有人，没点燃代表没人。

这时候，1个敌人来了，点1根狼烟



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



现在2个敌人来了，怎么办？再点一根狼烟，把20根狼烟都点上能表示20个人。。。这肯定不行。我们这样，把

第一个狼烟孔灭掉，点燃第二个，这样只点燃第二个孔就代表两个人



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



现在3个敌人来了，怎么办？把第一个狼烟孔点着了就表示3个人



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



那如果来了4个人敌人，现在有两根狼烟都点着了只能表示3个人，表示4个人，做得到么？臣妾做不到啊～～～

不过还记得么？之前使用2根狼烟只能表示2个人，现在我们通过一些奇淫巧技是不是表达了4种状态(0,1,2,3)啦。。。

看看眼下这4个可恶的敌人吧，咱们用这两根狼烟已经装不下他们了，所以我们只好再点一根，同时我们还要灭掉前面的两根，因为第三根这一根狼烟就可以表示4个敌人



<!-- OCR_START -->
> 狼烟孔
> 长城
<!-- OCR_END -->



接下来我们以此类推，烟不够了就往后多点一根，最终就出现这样的情况了，各位算算这是多少敌人？



<!-- OCR_START -->
> 1286432168421
<!-- OCR_END -->



很简单，把红色柱子代表的值加起来就行了对吧,一共247个敌人。

到此，友军将领的变态需求终于满足啦。。。

最后补充下，算敌人个数时，你要把每个红柱子加起来，柱子越多，算的越慢。 其实有快速算法，你发现没有，每根柱子所代表的值 就是此柱及其前面柱子的多少次方。

<!-- OCR_START -->
- 2**8=256
- 2**5=32
- 1286432168421
<!-- OCR_END -->

好，同学们，快帮我算出来，如果来61352个敌人的话，狼烟如何排列？

## 二进制定义

二进制是计算技术中广泛采用的一种[数制](http://baike.baidu.com/item/%E6%95%B0%E5%88%B6)。[二进制数](http://baike.baidu.com/item/%E4%BA%8C%E8%BF%9B%E5%88%B6%E6%95%B0)据是用0和1两个[数码](http://baike.baidu.com/item/%E6%95%B0%E7%A0%81)来表示的数。它的基数为2，进位规则是“逢二进一”，借位规则是“借一当二”，由18世纪德国数理哲学大师[莱布尼兹](http://baike.baidu.com/item/%E8%8E%B1%E5%B8%83%E5%B0%BC%E5%85%B9)发现。当前的[计算机系统](http://baike.baidu.com/item/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%B3%BB%E7%BB%9F)使用的都是[二进制系统](http://baike.baidu.com/item/%E4%BA%8C%E8%BF%9B%E5%88%B6%E7%B3%BB%E7%BB%9F)，数据在[计算机](http://baike.baidu.com/item/%E8%AE%A1%E7%AE%97%E6%9C%BA)中主要是以补码的形式存储的。计算机中的二进制则是一个非常微小的开关，用“开”来表示1，“关”来表示0。

我们发现刚刚我们讲述的狼烟的故事和现在这个新理论出奇相似。假设狼烟点燃用1表示，狼烟灭掉用0表示，那么刚刚我们用狼烟表示百万雄师的理论就可以用在计算机上，这种表示数字的方式就叫做二进制。

你可能会觉得发明计算机的人思路轻奇，为什么要多此一举的用这种方式来表达数字，但事实上计算机不像我们这样智能，CPU是一个包含上亿个精巧的[晶体管](https://www.baidu.com/s?wd=%E6%99%B6%E4%BD%93%E7%AE%A1\&tn=44039180_cpr\&fenlei=mv6quAkxTZn0IZRqIHckPjm4nH00T1YkrHfzmHbLuWf1nH9WrjIW0ZwV5Hcvrjm3rH6sPfKWUMw85HfYnjn4nH6sgvPsT6KdThsqpZwYTjCEQLGCpyw9Uz4Bmy-bIi4WUvYETgN-TLwGUv3EnWckPjmkrj03)的芯片集合，[晶体管](https://www.baidu.com/s?wd=%E6%99%B6%E4%BD%93%E7%AE%A1\&tn=44039180_cpr\&fenlei=mv6quAkxTZn0IZRqIHckPjm4nH00T1YzrHF9PjNBujwhmhN9mWDL0ZwV5Hcvrjm3rH6sPfKWUMw85HfYnjn4nH6sgvPsT6KdThsqpZwYTjCEQLGCpyw9Uz4Bmy-bIi4WUvYETgN-TLwGUv3EPjb3PHmvPH61Pjm3n1cdnW0Y)表达感情的方式很简单，就是通过高低电压(有电没电)，低电压的时候表示0，高电压的时候表示1，因此最终能让计算机理解的就只有0和1而已。

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

# 2.9 字符编码之文字是如何显示的

## 引子

通过上一节讲的二进制的知识，大家已经知道计算机只认识二进制，生活中的数字要想让计算机理解就必须转换成二进制。十进制到二进制的转换只能解决计算机理解数字的问题，那么文字要怎么让计算机理解呢？

于是我们就选择了一种曲线救国的方式，既然数字可以转换成十进制，我们只要想办法把文字转换成数字，这样文字不就可以表示成二进制了么？



<!-- OCR_START -->
> 文字
> 十进制
> 二进制
<!-- OCR_END -->



可是文字应该怎么转换成数字呢？就是强制转换啊，简单粗暴呀。 我们自己强行约定了一个表，把文字和数字对应上，这张表就相当于翻译，我们可以拿着一个数字来对比对应表找到相应的文字，反之亦然。

## ASCII码

这张表就是计算机显示各种文字、符号的基石呀

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

由于计算机是美国人发明的，因此，最早只有127个字母被编码到计算机里，也就是大小写英文字母、数字和一些符号，这个编码表被称为`ASCII`编码，比如大写字母`A`的编码是`65`，小写字母`z`的编码是`122`。后128个称为[扩展ASCII](http://baike.baidu.com/item/%E6%89%A9%E5%B1%95ASCII)码。

那现在我们就知道了上面的字母符号和数字对应的表是早就存在的。那么根据现在有的一些十进制，我们就可以转换成二进制的编码串。

比如

```plain
一个空格对应的数字是0          翻译成二进制就是0（注意字符'0'和整数0是不同的）
一个对勾√对应的数字是251       翻译成二进制就是11111011
```

**提问：假如我们要打印两个空格一个对勾 写作二进制就应该是 0011111011， 但是问题来了，我们怎么知道从哪儿到哪儿是一个字符呢？**

论断句的重要性与必要性：

上次在网上看到个新闻，讲是个小偷在上海被捕时高喊道：“我一定要当上海贼王！”

正是由于这些字符串长的长，短的短，写在一起让我们难以分清每一个字符的起止位置，所以聪明的人类就想出了一个解决办法，既然一共就这255个字符，那最长的也不过是11111111八位，不如我们就把所有的二进制都转换成8位的，不足的用0来替换。

这样一来，刚刚的两个空格一个对勾就写作000000000000000011111011，读取的时候只要每次读8个字符就能知道每个字符的二进制值啦。

在这里，每一位0或者1所占的空间单位为bit(比特)，这是计算机中最小的表示单位

**每8个bit组成一个字节，这是计算机中最小的存储单位(毕竟你是没有办法存储半个字符的)orz～**

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

## GB2312 & GBK

英文问题是解决了， 我们中文如何显示呢？ 美国佬设计ASSCII码的时候应该是没考虑中国人有一天也能用上电脑， 所以根本没考虑中文的问题，上世界80年代，电脑进入中国，把砖家们难倒了，妈的你个一ASSCII只能存256个字符，我常用汉字就几千个，怎么玩？？？勒紧裤腰带还苏联贷款的时候我们都挺过来啦，这点小事难不到我们， 既然美帝的ASCII不支持中文，那我们自己搞张编码表不就行了， 于是我们设计出了GB2312编码表，长成下面的样子。一共存了6763个汉字。

<!-- OCR_START -->
- code+0+1+2+3+4+5+6+7+8+9+A+B+C+D+E+F
- B4AO础储嘉搐触处揣川穿橡传船喘串疮
- B4B0窗幢床闯创吹炊捶锤垂春椿醇唇淳纯
- B4C0蠢戳绰疵茨磁雌辞慈瓷词此刺赐次聪
- B4D0葱卤匆从丛凑粗醋簇促蹄篡窜摧崔催
- B4E0脆粹淬翠村存寸磋攝搓措挫错搭达
- B4F0答瘩打大呆岁傣戴带殆代货袋待逮
- B5A0怠耽担丹单郸掸胆旦氮但惮淡诞弹
- B5B0蛋当挡党荡档力捣蹈倒岛祷导到稻悼
- B5C0道盗德得的蹬灯登等瞪凳邓堤低滴迪
- B5D0敌笛狄涤翟嫡抵底地蒂第帝弟递缔颠
- B5E0掂滇碘点典靛垫电佃甸店惦奠淀殿碱
- B5F0叼雕凋刁掉吊钓调跌爹碟蝶迭谍叠
- B6AO丁盯叮钉顶鼎锭定订丢东冬董懂动
- B6B0栋侗桐冻洞兜抖斗陡豆逗痘都督毒续
- B6C0独读堵睹赌杜镀肚度渡妒端短锻段断
- B6D0缎堆兑队对墩吨蹲敦顿囤钝盾遁哆
- B6E0多夺垛躲朵踩舱剁惰堕蛾峨鹅俄额讹
<!-- OCR_END -->

这个表格比较大，像上面的一块块的文字区域有72个，这导致通过一个字节是没办法表示一个汉字的(因为一个字节最多允许256个字符变种，你现在6千多个，只能2个字节啦，2\*\*16=65535个变种)。

有了gb2312，我们就能愉快的写中文啦。

但我们写字竟然会出现中英混杂的情况，比如“我是小猿圈，我的英文名叫Apeland.”， 这种你怎么办？这就要求你必须在gb2312里同时支持英文，但是还不能是2个字节表示一个英文字母。人家ASCII用一个字符，你用2个，那一个2mb大小的英文文档只要一改编码，就立刻变成4mb, 太坑爹，中国人你有钱也不能这么造呀。 所以中国砖家们又通过神奇手段兼容了ASSCII, 即遇到中文用2个字节，遇到英文直接用ASCII的编码。怎么做到的呢？

如何区别连在一起的2个字节是代表2个英文字母，还是一个中文汉字呢？ 中国人如此聪明，决定，\*\*如果2个字节连在一起，且每个字节的第1位(也就是相当于128的那个2进制位)如果是1，就代表这是个中文，这个首位是128的字节被称为高字节。 也就是2个高字节连在一起，必然就是一个中文。\*\*你怎么如此笃定？因为0-127已经表示了英文的绝大部分字符，128-255是ASCII的扩展表，表示的都是极特殊的字符，一般没什么用。所以中国人就直接拿来用了。

自1980年发布gb2312之后，中文一直用着没啥问题，随着个人电脑进入千家万户，有人发现，自己的名字竟然打印不出来，因为起的太生僻了。

于是1995年， 砖家们又升级了gb2312, 加入更多字符，连什么藏语、维吾尔语、日语、韩语、蒙古语什么的统统都包含进去了，国家统一亚洲的野心从这些基础工作中就可见一斑哈。 这个编码叫GBK，一直到现在，我们的windows电脑中文版本的编码就是GBK.

## 编码混战时代

中国人在搞自己编码的同时，世界上其它非英语国家也得用电脑呀，于是都搞出了自己的编码，你可以想得到的是，全世界有上百种语言，日本把日文编到**Shift_JIS**里，韩国把韩文编到**Euc-kr**里，

各国有各国的标准，就会不可避免地出现冲突，结果就是，在多语言混合的文本中，显示出来会有乱码。之前你从玩个日本游戏，往自己电脑上一装，就显示乱码了。

这么乱极大了阻碍了不同国家的信息传递，于是联合国出面，发誓要解决这个混乱局面。

因此，**Unicode**应运而生。**Unicode**把所有语言都统一到一套编码里，这样就不会再有乱码问题了。Unicode 2-4字节 已经收录136690个字符，并还在一直不断扩张中…

**Unicode**标准也在不断发展，但最常用的是用两个字节表示一个字符（如果要用到非常偏僻的字符，就需要**4**个字节）。现代[操作系统](http://lib.csdn.net/base/operatingsystem)和大多数编程语言都直接支持**Unicode**。

Unicode有2个特点：

1. 支持全球所有语言
2. 可以跟各种语言的编码自由转换，也就是说，即使你gbk编码的文字 ，想转成unicode很容易。

为何unicode可以跟其它语言互相转换呢？ 因为有跟所有语言都有对应关系哈，这样做的好处是可以让那些已经用gbk或其它编码写好的软件容易的转成unicode编码 ，利于unicode的推广。 下图就是unicode跟中文编码的对应关系

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

## UTF-8

新的问题又出现了：如果统一成**Unicode**编码，乱码问题从此消失了。但是，如果你写的文本基本上全部是英文的话，用**Unicode**编码比**ASCII**编码需要多一倍的存储空间，由于计算机的内存比较大，并且字符串在内容中表示时也不会特别大，所以内容可以使用unicode来处理，但是存储和网络传输时一般数据都会非常多，那么增加1倍将是无法容忍的！！！

为了解决存储和网络传输的问题，出现了Unicode Transformation Format，学术名UTF，即：对unicode字符进行转换，以便于在存储和网络传输时可以节省空间!

* UTF-8： 使用1、2、3、4个字节表示所有字符；优先使用1个字符、无法满足则使增加一个字节，最多4个字节。英文占1个字节、欧洲语系占2个、东亚占3个，其它及特殊字符占4个
* UTF-16： 使用2、4个字节表示所有字符；优先使用2个字节，否则使用4个字节表示。
* UTF-32： 使用4个字节表示所有字符；

总结：**UTF 是为unicode编码 设计 的一种 在存储 和传输时节省空间的编码方案。**

如果你要传输的文本包含大量英文字符，用**UTF-8**编码就能节省空间：

| 字符 | ASCII | Unicode | UTF-8 |
| :--- | :--- | :--- | :--- |
| A | 01000001 | 00000000 01000001 | 01000001 |
| 中 | x | 01001110 00101101 | 11100100 10111000 10101101 |

从上面的表格还可以发现，**UTF-8**编码有一个额外的好处，就是**ASCII**编码实际上可以被看成是**UTF-8**编码的一部分，所以，大量只支持**ASCII**编码的历史遗留软件可以在**UTF-8**编码下继续工作。

搞清楚了**ASCII**、**Unicode**和**UTF-8**的关系，我们就可以总结一下现在计算机系统通用的字符编码工作方式：

在计算机内存中，统一使用**Unicode**编码，当需要保存到硬盘或者需要传输的时候，就转换为**UTF-8**编码。

用记事本编辑的时候，从文件读取的**UTF-8**字符被转换为**Unicode**字符到内存里，编辑完成后，保存的时候再把**Unicode**转换为**UTF-8**保存到文件。

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
| :--- | :--- | :--- | :--- |
| ASCII | 1967年 | 表示英语及西欧语言 | 8bit/1bytes |
| GB2312 | 1980年 | 国家简体中文字符集，兼容ASCII | 2bytes |
| Unicode | 1991年 | 国际标准组织统一标准字符集 | 2bytes |
| GBK | 1995年 | GB2312的扩展字符集，支持繁体字，兼容GB2312 | 2bytes |
| UTF-8 | 1992年 | 不定长编码 | 1-3bytes |

## Py2 Vs Py3编码

python生下来的时候 还没有unicode\&utf-8, 所以龟叔选用的默认编码只能是ASCII, 一真到py2.7，用的还是ASCII, 导致Py默认只支持英文，想支持其它语言，必须单独配置。

```plain
```

直接写中文执行会报错的。

需在文件开头声明文件的编码才能写中文

```plain
```

再执行就不会有错了。

不过注意如果你的电脑 是windows系统 ， 你的系统默认编码是GBK ,你声明的时候要声明成GBK, 不能是utf-8, 否则依然是乱码，因为gbk自然不认识utf-8.

在Py2里编码问题非常头疼，若不是彻底理解编码之间的各种关系，会经常容易出现乱码而不知所措。

**到了Py3推出后,终于把默认编码改成了unicode, 同时文件存储编码变成了utf-8，意味着，不用任何声明，你就可以写各种语言文字在你的Python程序里。 从此，程序们手牵手过上了快乐的生活。**

***

# 2.10 秒懂十六进制

## 定义

16进制，英文名称Hexadecimal(简写Hex)， 在数学中是一种逢16进1的进位制。一般用数字0到9和字母A到F（或a~f）表示，其中:A~F表示10~15，这些称作十六进制数字，比如十进制13用16进制表示是D, 28用16进制是1C。

```plain
0 1 2 3 4 5 6 7 8 9  A  B  C  D  E  F 
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
```

16进制在计算机领域应用普遍，常见的有html\css的颜色表、mac地址、字符编码等都用16进制来表示。 这是因为将4个位元（Bit）化成单独的16进制数字不太困难。1字节可以表示成2个连续的16进制数字。可是，这种混合表示法容易令人混淆，因此需要一些字首、字尾或下标来显示,在C语言、C++、Shell、Python、Java语言及其他相近的语言使用字首“0x”来标示16进制，例如“0x5A3”代表1443。

<!-- OCR_START -->
```text
text-align: center;
padding-bottom:16px;
padding-left: 5px;
padding-right: 5px;
position:relative;
font-size: 16px;
color:
#5f1515；
font-family: PingFangSC-Regular;
```
<!-- OCR_END -->

<!-- OCR_START -->
en4: flagS=8863<UP,BR0ADCAST,SMART,RUNN]
options=3<RXCSUM,TXCSUM>
ether 00:0e:c6:cc:5b:46
inet 192.168.11.2 netmask 0xffff
media: autoselect (100baseTX <fu
status: active
Alexs-MacBook-Pro: alex$
<!-- OCR_END -->

## 1**6进制转换10进制**

**为何“0x5A3”代表1443呢？ 怎么算出来的？**

\*\*16进制数转10进制数的原理：\*\*1000=1X16^3（16的3次方）+0X16^2（16的2次方）+0X16（16的1次方）+0X1（16的0次方）=4096。

A = 10， B = 11,，C =12，D=13，E=14，F= 15。

FFF=15\_(16^2) + 15\_(16^1) + 15\*(16^0) = 4095。

## 10进制转16进制算法

**除16取余数得最低1位，然后把商继续除得第2位，直到商等于0**

举例：

```plain
65036 除 16，余数 12(C)，商4064
4064 除 16，余数 0(0)，商254
254 除 16，余数 14(E)，商15
15除16，余数 15(F)，商0，结束
得16进制为 FE0C
```

最后记住 ，16进制只是一种展示手法，相比2进制展示的更短更易换算，就像我们看10进制一样， 计算机底层运行的肯定还是二进制

# 2.11 hash是个什么东西

## 什么是哈希？

hash,一般翻译做散列、杂凑，或音译为哈希，是把任意长度的[输入](https://baike.baidu.com/item/%E8%BE%93%E5%85%A5/5481954)（又叫做预映射pre-image）通过散列算法变换成固定长度的[输出](https://baike.baidu.com/item/%E8%BE%93%E5%87%BA/11056752)，该输出就是散列值。这种转换是一种压缩映射，也就是，散列值的空间通常远小于输入的空间。

它其实就是一个算法，最简单的算法就是加减乘除，比方，我设计个数字算法，输入+7=输出，比如我输入1，输出为8；输入2，输出为9。

哈希算法不过是一个更为复杂的运算，它的输入可以是字符串，可以是数据，可以是任何文件，经过哈希运算后，变成一个固定长度的输出，该输出就是哈希值。**但是哈希算法有一个很大的特点，就是你不能从结果推算出输入,所以又称为不可逆的算法**

```plain
>>> hash('我爱你')
3471388576844338423
>>> hash('小猿圈')
5000768010434506639
```

如上所示，输入“我爱你”三个字，经过哈希运算后，会得到一个随机数列，而且不管你的输入文件多大，最后得到的结果都是这么一个固定长度的数列，即使你输入的是一部电影，输出也是这么大。而且通过数列不能推导出输入。

## 哈希特性

**不可逆**：在具备编码功能的同时，哈希算法也作为一种加密算法存在。即，你无法通过分析哈希值计算出源文件的样子，换句话说：你不可能通过观察香肠的纹理推测出猪原来的样子。

**计算极快**：20G高清电影和一个5K文本文件复杂度相同，计算量都极小，可以在0.1秒内得出结果。也就是说，不管猪有多肥，骨头多硬，做成香肠都只要眨眨眼的时间，

## 哈希的用途

哈希算法的不可逆特性使其在以下领域使用广泛

1. 密码，我们日常使用的各种电子密码本质上都是基于hash的，你不用担心支付宝的工作人员会把你的密码泄漏给第三方，因为你的登录密码是先经过 hash+各种复杂算法得出密文后 再存进支付宝的数据库里的
2. 文件完整性校验，通过对文件进行hash，得出一段hash值 ，这样文件内容以后被修改了，hash值就会变。 MD5 Hash算法的”数字指纹”特性，使它成为应用最广泛的一种文件完整性[校验和](https://baike.baidu.com/item/%E6%A0%A1%E9%AA%8C%E5%92%8C)(Checksum)算法，不少Unix系统有提供计算md5 checksum的命令。
3. 数字签名，[数字签名技术](https://baike.baidu.com/item/%E6%95%B0%E5%AD%97%E7%AD%BE%E5%90%8D%E6%8A%80%E6%9C%AF)是将摘要信息用发送者的私钥加密，与[原文](https://baike.baidu.com/item/%E5%8E%9F%E6%96%87)一起传送给接收者。接收者只有用发送者的公钥才能解密被加密的摘要信息，然后用[HASH函数](https://baike.baidu.com/item/HASH%E5%87%BD%E6%95%B0)对收到的[原文](https://baike.baidu.com/item/%E5%8E%9F%E6%96%87)产生一个摘要信息，与解密的摘要信息对比。如果相同，则说明收到的信息是完整的，在传输过程中没有被修改，否则说明信息被修改过，因此数字签名能够验证信息的完整性。

此外，hash算法在区块链领域也使用广泛。

## 基于hash的数据类型有哪些？

Python 中基于hash的2个数据类型是dict and set , 之前说dict查询速度快，为何快？ 说set天生去重，怎么做到的？其实都是利用了hash的特性，我们下面来剖析

### dict 为何查询速度超快，且不受dict大小影响 ？

解析：假设我要存14亿人的基本信息

```plain
data = {
    "张三":[23742364782642342323234,28,"山东济南"],
    "李四":[12124234232311214458271,25,"北京昌平"],
    "王五":[23030293483727384383929,33,"山东济南"],
    "赵六":[42302033030302482634674,28,"河北保定"],
    # "alex":["xxxx"],
    # "黑姑娘":["xxxx"]
    # ...
}
```

dict 的每个key 都要先经过hash生成一段固定长度的hash值，假设生成的hash值如下

<!-- OCR_START -->
| 名称 | 排名 |
| --- | --- |
| 张三 | 53 |
| 李四 | 67 |
| 王五 | 81 |
| 赵六 | 99 |
| alex | -10 |
| 黑姑娘 | 123 |
<!-- OCR_END -->

dict会把这些数字按大小排序好放在一个列表里kd = \[-10, 53, 67, 81, 99, 123]

当我们想查找”赵六”的信息时， 会把“赵六”先hash, 得到99这个值，然后拿这个值去到kd列表里找，想象这个列表有14亿个值 ，如何快速找到99？ 二分法就行，具体看剖析视频。

只要找到了99的位置，就可以定位到赵六对应的value的值了。 通过2分法查找，每次数据量都会少一半，这样查找最多31次(2\*\*31=2147483648)就能从20亿信息里找到这个人的信息。

当然 dict 真实的查找算法比这个还要复杂些， 我只是通过这个例子让大家理解下为何基于hash的数据类型查找速度会快很多。

### set为何是天生去重的？

因为每存一个值到set里时， 都要先经过hash，然后通过得出的这个hash值算出应该存在set里的哪个位置，存的时候会先检查那个位置上有没有值 ，有的话就对比是否相等，如果相等，则不再存储此值。 如果不相等(即为空)，则把新值 存在这。

# 2.12 用python操作文件

用word操作一个文件的流程如下：

1. 找到文件，双击打开
2. 读或修改
3. 保存&关闭

用python操作文件也差不多：

```plain
f=open(filename)  # 打开文件
f.write("我是野生程序员") # 写操作
f.read()  #读操作
f.close() #保存并关闭
```

不过有一点跟人肉操作word文档不同，就是word文档只要打开了，就即可以读、又可以修改。 但Python比较变态，只能以读、创建、追加 3种模式中的任意一种打开文件，不能即写又读。

## 操作模式

* r 只读模式
* w 创建模式，若文件已存在，则覆盖旧文件
* a 追加模式，新数据会写到文件末尾

## 创建文件

```plain
f = open(file='D:/工作日常/staff.txt',mode='w')
f.write("Alex  CEO  600\n")
f.write("黑姑娘  行政  5000\n")
f.close()
```

## 只读模式

```plain
f = open(file='兼职白领学生空姐模特护士联系方式.txt',mode='r')
print(f.readline())  # 读一行
print('------分隔符-------')
data = f.read()  # 读所有，剩下的所有
print(data)
f.close()
```

执行输出

```plain
马纤羽     深圳    173    50    13744234523
------分隔符-------
乔亦菲     广州    172    52    15823423525
罗梦竹     北京    175    49    18623423421
刘诺涵     北京    170    48    18623423765
岳妮妮     深圳    177    54    18835324553
贺婉萱     深圳    174    52    18933434452
叶梓萱     上海    171    49    18042432324
```

## 追加模式

```plain
f = open(file='兼职白领学生空姐模特护士联系方式.txt',mode='a')
f.write("黑姑娘 北京  168  48\n")  # 会追加到文件尾部
f.close()
```

## 循环文件

```plain
f = open(file='兼职白领学生空姐模特护士联系方式.txt',mode='a')
f.write("黑姑娘 北京  168  48\n")  # 会追加到文件尾部
f.close()
```

```plain
f = open(file='兼职白领学生空姐模特护士联系方式.txt',mode='r')
for line in f:
    line = line.split()
    name,addr,height,weight,phone = line
    height = int(height)
    weight = int(weight)
    if height > 170 and weight <= 50:
        print(line)
f.close()
```

输出

```plain
['马纤羽', '深圳', '173', '50', '13744234523']
['罗梦竹', '北京', '175', '49', '18623423421']
['叶梓萱', '上海', '171', '49', '18042432324']
```

## 其它功能

```plain
def mode(self) -> str:
        返回文件打开的模式
    def name(self) -> str:
        返回文件名
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

## 混合模式

其实我一直像你隐瞒，因为怕你觉得复杂。 打开文件其实还有3种混合模式

w+ 写读 , 这个功能基本没什么意义，它会创建一个新文件 ，写一段内容，可以再把写的内容读出来，没什么卵用。

r+ 读写，能读能写,但都是写在文件最后，跟追加一样

a+ 追加读,文件 一打开时光标会在文件尾部,写的数据全会是追加的形式

### **r+模式**

<!-- OCR_START -->
- apeland_py_learn[~/PycharmProjects/apeland_py_learn] -../day2/兼职白领学生空姐模特护士联系方式.txt[apeland_py_learn]
- apeland_py_learn〉 day2〉自 兼职白领学生空姐模特护士联系方式.txt
- 文件写▼
- 自兼职白领学生空姐模特护士联系方式.txt×
- 文件写.py x
- 1
- 马纤羽
- 深圳
- 173
- 50
- 13744234523
- 2
- 乔亦菲
- 广州
- 172
- 52
- 15823423525
- 3
- 罗梦竹
- 北京
- 175
- 49
- 18623423421
- 30
- 4
- 刘诺涵
- 170
- 48
- 18623423765
- 177
- 31
- 岳妮妮
- 54
- 18835324553
- 6
- 贺婉萱
- 174
- 18933434452
- 32
- f=open（file='兼职白领学生空姐模特护士联系方式.txt'，mode='r+'）
- 7
- 叶梓萱
- 上海
- 171
- 18042432324
- 33
- print(f.readline()）# 先打印一行
- 8
- hello...
- 34
- 35
- f.write（"hello..."）#在第2行写个hello
- 36
- 为何hello没有写在第2行,
- 37
- f.close()
- 而是到最后了?
- 既然文件已经写在最后一，再往下打印不应该是最后一行么?
- 为何打印的还是第2行
- Run:
- /Users/alex/PycharmProjects/apeland_py_learn
- -nv/bin/python/Users/alex/PycharmProjects/apeland_py_learn/day2/文件写.py
- Process finished withexitcode 0
- =6:TODO
- 2Python Console
- 8:1 LF  UTF-8 4spaces
<!-- OCR_END -->

因为默认就是往文件 尾部写

## 修改文件

尝试直接以r+模式打开文件，默认会把新增的内容追加到文件最后面。但我想要的是修改中间的内容 ，怎么办？ 为什么会把内容添加到尾部呢？(最新测试r+会从头覆盖，测试代码如下)

<!-- OCR_START -->
- 兼职白领学生空姐模特护士联系方式.txt×
- 文件写.py ×
- 20
- # 1or
- tine in r:
- ile was loaded in the wrong... Reload in another encoding
- 21
- line = line.split()
- {小猿圈}
- 22
- name,addr,height,weight,phone = line
- 北京
- 175
- 49
- 18623423421
- {黑姑娘}
- 170
- 48
- 23
- 18623423765
- height = int(height)
- 岳妮妮
- 深圳
- 177
- 54
- 24
- weight = int(weight)
- 18835324553
- 贺婉萱
- 174
- 25
- if height > 170 and weight <= 50:
- 52
- 18933434452
- 26
- print(line)
- 27
- 28
- # f.write()
- 29
- # f.close()
- 30
- 31
- 32
- f = open(file='兼职白领学生空姐模特护士联系方式.txt'，mode='r+'）
- 33
- 34
- f.write("{小猿圈}")
- #默认写在第一行，会覆盖原有数据
- 35
- f.seek(50)
- #想改中间的数据，就得seek到对应位置
- 36
- f.write("{黑姑娘}")
- 37
- 38
<!-- OCR_END -->

**问：为什么原有数据会被覆盖呢？**

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
f_name = "兼职白领学生空姐模特护士联系方式.txt"
f_new_name = "%s.new" % f_name
old_str = "刘诺涵"
new_str = "[黑姑娘]"
f = open(f_name,'r')
f_new = open(f_new_name,'w')
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
f_name = "兼职白领学生空姐模特护士联系方式.txt"
f_new_name = "%s.new" % f_name
old_str = "刘诺涵"
new_str = "[黑姑娘]"
f = open(f_name,'r')
f_new = open(f_new_name,'w')
for line in f:
    if old_str in line:
        new_line = line.replace(old_str,new_str)
    else:
        new_line = line
    f_new.write(new_line)
f.close()
f_new.close()
os.rename(f_new_name,f_name) #把新文件名字改成原文件 的名字，就把之前的覆盖掉了,windows使用os.replace # 帮助文档说明replace会覆盖原文件
```

## 练习题

**练习题1 —— 全局替换程序：**

* 写一个脚本，允许用户按以下方式执行时，即可以对指定文件内容进行全局替换

```plain
python your_script.py old_str new_str filename
```

* 替换完毕后打印替换了多少处内容

**练习题2 —— 模拟登陆：**

* 用户输入帐号密码进行登陆
* 用户信息保存在文件内
* 用户密码输入错误三次后锁定用户，下次再登录，检测到是这个用户也登录不了

# 2.13 本章联系题&作业

## 练习题【答案在页面的末尾(先自己做再看答案)】

1、请用代码实现：利用下划线将列表的每一个元素拼接成字符串，li＝\[‘alex’, ‘eric’, ‘rain’]

2、查找列表中元素，移除每个元素的空格，并查找以a或A开头并且以c结尾的所有元素。

```plain
li = ["alec", " aric", "Alex", "Tony", "rain"]
tu = ("alec", " aric", "Alex", "Tony", "rain")
dic = {'k1': "alex", 'k2': ' aric', "k3": "Alex", "k4": "Tony"}
```

3、写代码，有如下列表，按照要求实现每一个功能

li＝\[‘alex’, ‘eric’, ‘rain’]

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

```plain
li = ["hello", 'seven', ["mon", ["h", "kelly"], 'all'], 123, 446]
```

* 请根据索引输出“Kelly”
* 请使用索引找到’all’元素并将其修改为“ALL”，如：li\[0]\[1]\[9]…

5、有如下变量，请实现要求的功能

```plain
tu = ("alex", [11, 22, {"k1": 'v1', "k2": ["age", "name"], "k3": (11,22,33)}, 44])
```

* 讲述元组的特性
* 请问tu变量中的第一个元素“alex”是否可被修改？
* 请问tu变量中的”k2”对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven”
* 请问tu变量中的”k3”对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven“

6、转换

* 将字符串s = “alex”转换成列表
* 将字符串s = “alex”转换成元祖
* 将列表li = \[“alex”, “seven”]转换成元组
* 将元组tu = (‘Alex’, “seven”)转换成列表
* 将列表li = \[“alex”, “seven”]转换成字典且字典的key按照10开始向后递增

7、元素分类

有如下值集合\[11,22,33,44,55,66,77,88,99,90]，将所有大于66的值保存至字典的第一个key中，将小于66的值保存至第二个key的值中。

即：{‘k1’:大于66的所有值, ‘k2’:小于66的所有值}。（编程题）

8、在不改变列表数据结构的情况下找最大值li = \[1,3,2,7,6,23,41,243,33,85,56]。（编程题）

9、在不改变列表中数据排列结构的前提下，找出以下列表中最接近最大值和最小值的平均值 的数`li = [-100,1,3,2,7,6,120,121,140,23,411,99,243,33,85,56]。`（编程题）

`10、`利用for循环和range输出9 \* 9乘法表 。（编程题）

11、求100以内的素数和。（编程题）

12、请说明python2 与python3中的默认编码是什么？

13、为什么会出现中文乱码？你能列举出现乱码的情况有哪几种？

14、分别写出在windows和mac上用py2输出中文怎么做？

## 作业

**股票查询程序开发**

把以下股票数据存入stock_data.txt

<!-- OCR_START -->
- 序号
- 代码
- 名称
- 最新价
- 涨跌幅
- 涨跌额
- 成交量（手）成交额
- 振幅
- 最高
- 最低
- 今开
- 昨收
- 量比
- 换手率
- 市盈率（动态市净率
- 300780N德恩
- 16.68
- 44. 04%
- 5.1
- 40367.2万
- 24.01%
- 13.9
- 11.58
- 0.11%
- 46.73
- 2.62
- 2
- 2676顺威股份
- 3.69
- 10.15%
- 0.3415.23万
- 5516万
- 9.55%
- 3.37
- 3.35
- 1.16
- 2.11%
- 2.58
- 3
- 601619嘉泽新能
- 4.91
- 10. 09%
- 0.4516.55万
- 8006万
- 8.52%
- 4.53
- 4.54
- 4.46
- 1.82
- 3.28%
- 52.26
- 3.64
- 4
- 2310东方园林
- 5.57
- 10.08%
- 0.5152.66万
- 2.81亿
- 9.88%
- 5.07
- 5. 08
- 5.06
- 1.62
- 3.23%
- 1.2
- 2261拓维信息
- 6. 45
- 10. 07%
- 0.5982.2万
- 5.1亿
- 9.73%
- 5.88
- 5.93
- 5.86
- 1.53
- 9.28%
- 150.4
- 2.85
- 6
- 2696百洋股份
- 7.23
- 10.05%
- 0.6638.33万
- 2.7亿
- 6.54%
- 6.8
- 7
- 6.57
- 5.11
- 17.97%
- 97.39
- 1.31
- 300366创意信息
- 11. 06
- 1.0140.74万
- 4.39亿
- 11. 74%
- 9.93
- 0.7
- 13.22%
- 53.3
- 2.45
- 8
- 603266天龙股份
- 13.92
- 10.04%
- 1. 27
- 78661095万
- 0.00%
- 12.65
- 0.15
- 1.61%
- 60.63
- 3.26
- 9
- 2828贝肯能源
- 14.25
- 1.317.83万
- 2.52亿
- 4. 71%
- 13.64
- 13.8
- 12.95
- 3.45
- 18.03%
- 3.08
- 10
- 2725跃岭股份
- 12.6
- 1.1519.37万
- 2.39亿
- 6. 11%
- 11.9
- 11.45
- 0.88
- 10.97%
- 35.44
- 3.39
- 11
- 300262巴安水务
- 7.78
- 0.7116.43万
- 1.26亿
- 7.07
- 3.60%
- 48.95
- 2.24
- 2866传艺科技
- 13.81
- 1.2613.59万
- 1.83亿
- 9.72%
- 12.59
- 12.61
- 12.55
- 2.63
- 16.86%
- 33.37
- 3.43
- 13
- 300095华伍股份
- 7.02
- 10.03%
- 0.6445.69万
- 3.18亿
- 8.46%
- 6. 48
- 6.38
- 7. 4
- 16.59%
- 35.75
- 2.29
- 14
- 970中科三环
- 1.18139.1万
- 17.7亿
- 11. 47%
- 11.68
- 11. 77
- 2.04
- 13.06%
- 77.99
- 3.06
- 15
- 603693江苏新能
- 13.71
- 1.254.08万
- 5545万
- 4. 90%
- 12.46
- 0.92
- 3.46%
- 37.43
- 1.88
- 16
- 603727博迈科
- 18.65
- 1.75万
- 9315万
- 18.39
- 16.95
- 2.4
- 5. 27%
- 291.24
- 1. 84
- 17
- 586汇源通信
- 14.59
- 1.336.6万
- 9626万
- 13.26
- 0. 4
- 3. 41%
- 12. 1
- 18
- 603697有友食品
- 22.73
- 10. 02%
- 2.0734.93万
- 7.68亿
- 8.23%
- 21.03
- 21.17
- 20.66
- 43. 94%
- 38.1
- 4.66
- 19
- 300777中简科技
- 24.92
- 2.27
- 59521483万
- 22.65
- 1. 49%
- 102.24
- 11.49
- 20
- 300330 华虹计通
- 13.07
- 1.1921.23万
- 2.66亿
- 13.72%
- 11.44
- 11.88
- 12.66%
- 6810.83
- 5.96
- 21
- 300245天玑科技
- 11.53
- 1.0526.86万
- 3.05亿
- 9.64%
- 10.52
- 10.48
- 1.06
- 10.35%
- 127.47
- 2.57
- 22
- 603628清源股份
- 9.11
- 0.831.88万
- 1697万
- 8.70%
- 8.39
- 8.4
- 8.28
- 1.34
- 2. 12%
- 550.88
- 01%
- 52
- 35
- 47
- 43.02%
<!-- OCR_END -->

数据来源：

[东方财富网](http://http//quote.eastmoney.com/center/gridlist.html#hs_a_board)

开发程序对stock_data.txt进行以下操作：

1. 程序启动后，给用户提供查询接口，允许用户重复查股票行情信息(用到循环)
2. 允许用户通过模糊查询股票名，比如输入“啤酒”, 就把所有股票名称中包含“啤酒”的信息打印出来
3. 允许按股票价格、涨跌幅、换手率这几列来筛选信息，比如输入“价格>50”则把价格大于50的股票都打印，输入“市盈率<50“，则把市盈率小于50的股票都打印，不用判断等于。

思路提示：加载文件内容到内存，转成dict or list结构，然后对dict or list 进行查询等操作。 这样以后就不用每查一次就要打开一次文件了，效率会高。

程序启动后执行效果参考：

```plain
股票查询接口>>:换手率>25
['序号', '代码', '名称', '最新价', '涨跌幅', '涨跌额', '成交量(手)', '成交额', '振幅', '最高', '最低', '今开', '昨收', '量比', '换手率', '市盈率', '市净率']
['18', '603697', '有友食品', '22.73', '10.02%', '2.07', '34.93万', '7.68亿', '8.23%', '22.73', '21.03', '21.17', '20.66', '1.4', '43.94%', '38.1', '4.66']
['23', '603956', '威派格', '22.52', '10.01%', '2.05', '18.33万', '4.01亿', '10.60%', '22.52', '20.35', '20.35', '20.47', '2.16', '43.02%', '-', '9.82']
['36', '300748', '金力永磁', '59.7', '10.01%', '5.43', '11.02万', '6.38亿', '6.98%', '59.7', '55.91', '56.88', '54.27', '0.9', '26.49%', '234.09', '23.54']
['37', '300767', '震安科技', '41.13', '10.00%', '3.74', '6.22万', '2.49亿', '10.32%', '41.13', '37.27', '37.48', '37.39', '3.86', '31.11%', '43.32', '3.68']
['38', '603045', '福达合金', '32', '10.00%', '2.91', '17.06万', '5.31亿', '9.87%', '32', '29.13', '29.13', '29.09', '1.39', '25.17%', '52.74', '4.02']
['39', '2952', '亚世光电', '58.98', '10.00%', '5.36', '4.18万', '2.41亿', '7.42%', '58.98', '55', '55.91', '53.62', '3.04', '27.44%', '53.09', '5.51']
找到6条
股票查询接口>>:最新价<5
['序号', '代码', '名称', '最新价', '涨跌幅', '涨跌额', '成交量(手)', '成交额', '振幅', '最高', '最低', '今开', '昨收', '量比', '换手率', '市盈率', '市净率']
['2', '2676', '顺威股份', '3.69', '10.15%', '0.34', '15.23万', '5516万', '9.55%', '3.69', '3.37', '3.37', '3.35', '1.16', '2.11%', '-', '2.58']
['3', '601619', '嘉泽新能', '4.91', '10.09%', '0.45', '16.55万', '8006万', '8.52%', '4.91', '4.53', '4.54', '4.46', '1.82', '3.28%', '52.26', '3.64']
找到2条
股票查询接口>>:食品
['18', '603697', '有友食品', '22.73', '10.02%', '2.07', '34.93万', '7.68亿', '8.23%', '22.73', '21.03', '21.17', '20.66', '1.4', '43.94%', '38.1', '4.66']
找到1条
股票查询接口>>:能源
['9', '2828', '贝肯能源', '14.25', '10.04%', '1.3', '17.83万', '2.52亿', '4.71%', '14.25', '13.64', '13.8', '12.95', '3.45', '18.03%', '-', '3.08']
找到1条
股票查询接口>>:科技
['12', '2866', '传艺科技', '13.81', '10.04%', '1.26', '13.59万', '1.83亿', '9.72%', '13.81', '12.59', '12.61', '12.55', '2.63', '16.86%', '33.37', '3.43']
['19', '300777', '中简科技', '24.92', '10.02%', '2.27', '5952', '1483万', '0.00%', '24.92', '24.92', '24.92', '22.65', '3.45', '1.49%', '102.24', '11.49']
['21', '300245', '天玑科技', '11.53', '10.02%', '1.05', '26.86万', '3.05亿', '9.64%', '11.53', '10.52', '10.52', '10.48', '1.06', '10.35%', '127.47', '2.57']
['26', '300391', '康跃科技', '7.8', '10.01%', '0.71', '3.9万', '3027万', '10.01%', '7.8', '7.09', '7.09', '7.09', '0.75', '1.94%', '27.35', '1.89']
['37', '300767', '震安科技', '41.13', '10.00%', '3.74', '6.22万', '2.49亿', '10.32%', '41.13', '37.27', '37.48', '37.39', '3.86', '31.11%', '43.32', '3.68']
['40', '603327', '福蓉科技', '21.56', '10.00%', '1.96', '3586', '773.1万', '0.00%', '21.56', '21.56', '21.56', '19.6', '2.81', '0.70%', '31.97', '8.05']
找到6条
```

练习题答案如下：

1、请用代码实现：利用下划线将列表的每一个元素拼接成字符串，

```plain
li = ['alex', 'eric', 'rain']
print("_".join(li))
```

2 查找列表中元素，移除每个元素的空格，并查找以a或A开头并且以c结尾的所有元素。

> li = \["alec", " aric", "Alex", "Tony", "rain"]

```plain
for item in li:
    item = item.strip().replace(" ", "")
    if (item.startswith("A") or item.startswith("a")) and item.endswith("c"):
        print(item)
```

```plain
tu = ("alec", " aric", "Alex", "Tony", "rain")
```

```plain
for item in tu:
    item = item.strip().replace(" ", "")
    if (item.startswith("A") or item.startswith("a")) and item.endswith("c"):
        print(item)
```

```plain
dic = {'k1': "alex", 'k2': ' aric', "k3": "Alex", "k4": "Tony"}
```

```plain
for item in dic:
    value = dic[item].strip().replace(" ", "")
    if (value.startswith("A") or value.startswith("a")) and value.endswith("c"):
        print(value)
```

3 3、写代码，有如下列表，按照要求实现每一个功能 li＝\[‘alex’, ‘eric’, ‘rain’]

> * 计算列表长度并输出

```plain
print(len(li))
```

> * 列表中追加元素“seven”，并输出添加后的列表

```plain
li.append("seven")
print(li)
```

> * 请在列表的第1个位置插入元素“Tony”，并输出添加后的列表

```plain
li.insert(1, "Tony")
print(li)
```

> * 请修改列表第2个位置的元素为“Kelly”，并输出修改后的列表

```plain
li[1] = "Kelly"
print(li)
```

> * 请删除列表中的元素“eric”，并输出修改后的列表

```plain
li.remove("eric")
```

> * 请删除列表中的第2个元素，并输出删除的元素的值和删除元素后的列表

```plain
print(li.pop(1))
print(li)
```

> * 请删除列表中的第3个元素，并输出删除元素后的列表

```plain
print(li.pop(2))
```

> * 请删除列表中的第2至4个元素，并输出删除元素后的列表

```plain
li = ["ale", "eric", "rain", "alex", "luffy", "py"]
del li[2:5]
print(li)
```

> * 请将列表所有的元素反转，并输出反转后的列表

```plain
li.reverse()
print(li)
```

> * 请使用for、len、range输出列表的索引

```plain
for index in range(len(li)):
    print(index)
```

> * 请使用enumrate输出列表元素和序号（序号从100开始）

```plain
for index, ele in enumerate(li):
    print(index, ele)
```

> * 请使用for循环输出列表的所有元素

```plain
for i in li:
    print(i)
```

4 写代码，有如下列表，请按照功能要求实现每一个功能

```plain
li = ["hello", 'seven', ["mon", ["h", "kelly"], 'all'], 123, 446]
```

> 请根据索引输出“Kelly”

```plain
print(li[2][1][1])
```

> 请使用索引找到’all’元素并将其修改为“ALL”，如

```plain
li[2][2] = "ALL"
print(li)
```

5 有如下变量，请实现要求的功能

```plain
tu = ("alex", [11, 22, {"k1": 'v1', "k2": ["age", "name"], "k3": (11,22,33)}, 44])
```

> 讲述元组的特性

```plain
不可变，没有添加和删除的方法
```

> 请问tu变量中的第一个元素“alex”是否可被修改？

```plain
不能
```

> 请问tu变量中的”k2”对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven”

```plain
列表，可以被修改
tu[1][2]["k2"].append("seven")
print(tu)
```

> 请问tu变量中的”k3”对应的值是什么类型？是否可以被修改？如果可以，请在其中添加一个元素“Seven“

6、转换

> 将字符串s = “alex”转换成列表

```plain
print(list(s))
```

> 将字符串s = “alex”转换成元祖

```plain
print(tuple(s))
```

> 将列表li = \[“alex”, “seven”]转换成元组

```plain
print(tuple(li))
```

> 将元组tu = (‘Alex’, “seven”)转换成列表

```plain
print(list(tu))
```

> 将列表li = \[“alex”, “seven”]转换成字典且字典的key按照10开始向后递增

```plain
li = ["alex", "seven"]
num = 10
dic = {}
for i in range(len(li)):
    dic[num] = li[i]
    num += 1
print(dic)
```

7、元素分类

> 有如下值li = \[11,22,33,44,55,66,77,88,99,90]，将所有大于66的值保存至字典的第一个key中，将小于66的值保存至第二个key的值中。即：{‘k1’:大于66的所有值, ‘k2’:小于66的所有值}

```plain
dic = {"k1":[], "k2":[]}
for i in li:
    if i > 66:
        dic["k1"].append(i)
    elif i < 66:
        dic["k2"].append(i)
print(dic)
```

8、在不改变列表数据结构的情况下找最大值li = \[1,3,2,7,6,23,41,243,33,85,56]

```plain
max_value = li[0]
for i in li:
    if i > max_value:
        max_value = i
print(max_value)
```

9 在不改变列表中数据排列结构的前提下，找出以下列表中最接近最大值和最小值的平均值 的数`li = [-100,1,3,2,7,6,120,121,140,23,411,99,243,33,85,56]`

```plain
li = [-100,1,3,2,7,6,142, 120,121,140,23,411,99,243,33,85,56]
max_value = li[0]
min_value = li[0]
for i in li:
    if i > max_value:
        max_value = i
    if i < min_value:
        min_value = i
avg_value = (max_value+min_value)/2
close_n = li[0]
for i in li:
    if abs(i - avg_value) < abs(close_n - avg_value):
        close_n = i
print(close_n)
```

10 利用for循环和range输出9 \* 9乘法表

```plain
for i in range(1, 10):
    for j in range(1, i+1):
        print("%s*%s=%s" % (j,i,i*j), end=" ")
    print(end="\n")
```

11 求100以内的素数和

```plain
total = 0
for i in range(2, 101):
    for j in range(2, i):
        if i % j == 0:
            break
    else:
        total += i
print(total)
```

12 请说明python2 与python3中的默认编码是什么？

```plain
python2默认是ascii
python3默认是utf-8
```

13 为什么会出现中文乱码？你能列举出现乱码的情况有哪几种？

```plain
1 文件编码是utf-8，打开文件的时候却指定了gbk的编码
2 windows上的文件(windows上新建的文件默认都是gbk的编码)，传到mac电脑去打开(mac电脑默认的编码是utf-8)
```

> 更新: 2021-01-18 21:46:18  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/lb2gpp>