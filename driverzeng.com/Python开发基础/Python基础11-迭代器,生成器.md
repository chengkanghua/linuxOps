# Python基础11-迭代器,生成器

## Python基础11-迭代器,生成器

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

* [迭代器介绍](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_0)
* [迭代器使用](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_1)
* [for循环底层原理分析](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_2)
* [迭代器总结](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_3)
* [自定义迭代器](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_4)
* [练习：实现range功能](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_5)
* [表达式yield应用（了解）](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_6)
* [yield关键字总结](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_7)
* [生成器表达式](https://blog.driverzeng.com/zenglaoshi/5275.html#toc_8)

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

## 迭代器介绍

***

| 什么是迭代器？ |
| :--- |

迭代器：指的是迭代取值的工具

迭代：迭代是一个重复过程，每一次重复都是基于上一次的结果而来

```plain
# 错误例子，单纯的重复不是迭代
i=0
while True:
    print(i)
# 迭代：重复+每次重复都是基于上一次的结果而进行
l=['a','b','c']
i=0
while i < len(l):
    print(l[i])
    i+=1
```

***

| 为何要使用迭代器？ |
| :--- |

刚才我们实现的迭代器，只能适用于，字符串，列表，元组等数据类型，但是字典，就不合适了

迭代器提供了一种通用的且不依赖于索引的迭代取值方式

***

| 如何使用迭代器？ |
| :--- |

首先了解一个概念，并不是所有数据都阔以使用迭代器，只有`可迭代对象`才可以使用迭代器。

那么什么是可迭代对象呢？

\*\*可迭代的对象iterable：\*\*但凡内置有__iter__方法的对象都称之为可迭代的对象。

```plain
# 以下数据类型包括文件，我们挨个测试一番
a=1
b=1.1
c='hello'
d=['a','b']
e=('a','b')
j={'x':1}
g={1,2,3}
f=open('a.txt','w')
## 结论：可迭代的对象：str，list，tuple，dict，set,文件对象
# 执行可迭代对象下的__iter__方法，返回的值就是一个迭代器对象iterator
dic={'x':1,'y':2,'z':3}
iter_dic=dic.__iter__()
print(iter_dic)
# 迭代取值
dic={'x':1,'y':2,'z':3}
iter_dic=dic.__iter__()
print(iter_dic.__next__())
print(iter_dic.__next__())
print(iter_dic.__next__())
// 我们只有三个key，如果取第四次，就会报错，但是这是好事，我们可以把它当成是一个结束信号
print(iter_dic.__next__())
# 文件同样可以迭代
f=open('a.txt','rt',encoding='utf-8')
iter_f=f.__iter__()
print(iter_f.__next__())
print(iter_f.__next__())
print(iter_f.__next__())
print(iter_f.__next__())
```

## 迭代器使用

***

| 迭代器对象 |
| :--- |

1. 既内置有__next__方法的对象，执行迭代器__next__方法可以不依赖索引取值
2. 又内置有__iter__方法的对象，执行迭代器__iter__方法得到的仍然是迭代器本身

**注意：**

1.迭代器对象一定是可迭代的对象，而可迭代的对象却不一定是迭代器对象

2.文件对象本身就是一个迭代器对象

```plain
l=['a','b','c']
iter_l=l.__iter__() # 调用可迭代的对象__iter__得到的是迭代对象，
print(iter_l is iter_l.__iter__().__iter__().__iter__().__iter__().__iter__().__iter__())
# 迭代器取值
dic={'x':1,'y':2,'z':3}
iter_dic=iter(dic) # dic.__iter__()
print(next(iter_dic)) # iter_dic.__next__()
print(next(iter_dic))
print(next(iter_dic))
print(next(iter_dic))
print(next(iter_dic))
## 这么取会发现，全都是重复代码
# 使用循环取值
dic={'x':1,'y':2,'z':3}
iter_dic=iter(dic) # dic.__iter__()
while True:
    print(next(iter_dic)) # iter_dic.__next__()
    
# 如果一直取就会报错异常
```

<!-- OCR_START -->
PYTHON[~/Desktop/PYTHON]-~/Desktop/py视频/python视频压缩包版/day13/代
/UsersdriverzengDesktoppy视频python视频压缩包版day13代码01迭代器.py
01函数对象.pyx
02函数嵌套.pyX
03名称空间与作用域.pyx
04闭包函数.pyx
01装饰器.pyX
02函数的递归调用.pyx
03三元表达式.pyX
04列表
85
#print(l._iter_().
_next_(））
86
#iter_l=l._iter_（)
87
#print（iter_l._next_())
88
89
90
91
92
#二：迭代器对象
93
#1.既内置有next方法的对象，热行送代器next方法可以不依赖索引取值
94
#2.又内置有iter方法的对象，执行选代器iter方法得到的仍然是选代器本身
95
#ps:
96
#1.送代器对象一定是可送代的对象，而可送代的对象却不一定是送代器对象
97
#2.文件对象本身就是一个送代器对象
98
#l=['a'，'b','c']
99
#iter_l=l._iter_（）#调用可迭代的对象_iter_得到的是迭代对象，
100
#print（iter_lisiter_l._iter_()._iter_()._iter_()._iter_()._iter_()._iter_())
101
102
##dic={1,2,3,4}
103
#dic={'x':1,'y':2,'z':3}
104
##print（len(dic)) #dic._len_()
105
# iter_dic=iter（dic） # dic.iter_（)
106
107
108
dic=f'x':1'y':2'z':3}
109
110
while True:
111
print(next（iter_dic))#iter_dic._next_()
112
113
Run:
01选代器
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/py视频/python视频压缩包版/day13/代码/01迭代器·py
Traceback (most recent call last):
File“ZUsers/driverzeng/Desktop/py视频/python视频压缩包版/day13/代码/01迭代器.py，Line111，in<module>
topIteration
Process finished with exit code 1
曾老湿
DriverZeng
<!-- OCR_END -->

￼

```plain
# 捕捉异常方案
dic={'x':1,'y':2,'z':3}
iter_dic=iter(dic) # dic.__iter__()
while True:
    try:
        print(next(iter_dic)) #iter_dic.__next__()
    except StopIteration:
        break
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-~/Desktop/py视频/python视频压缩包版/day13/代码/01迭代器.py
- /UsersdriverzengDesktoppy视频python视频压缩包版day13代码01选代器py
- 01函数对象.py
- 02函数嵌套.py
- 03名称空间与作用域.py
- 04闭包函数.pyx
- 01装饰器.py
- 02函数的递归调用.pyx
- 03三元表达式.pyx
- 04列表生成式.py
- 01选代器.pyX
- 86
- #iter_l=l.
- _iter_()
- 87
- #print（iterl._next_())
- 88
- 89
- 90
- 91
- 92
- #二：送代器对象
- 93
- #1既内置有ext方法的对象热行选代next.方法可以不依赖索引取值
- 94
- #2.又内置有iter方法的对象，执行选代器iter方法得到的仍然是选代器本身
- 95
- #ps:
- 96
- #1.送代器对象一定是可送代的对象，而可迭代的对象却不一定是送代器对象
- 97
- #2.文件对象本身就是一个选代器对象
- 98
- #l=['a','b'，'c']
- 99
- #iter_L=l._iter_（）#调用可迭代的对象_iter_得到的是迭代对象，
- 100
- #print（iter_l is iter_l._iter_()._iter_()._iter_()._iter_()._iter_()._iter_())
- 101
- 102
- ##dic={1,2,3，4}
- 103
- #dic={'x':1,'y':2,'z':3}
- 104
- ##print（len（dic））#dic._len_（)
- 105
- #iter_dic=iter（dic)#dic._iter_()
- 106
- 107
- 108
- dic=f'x':1'y':2z':3}
- 109
- iter_dic=iter(dic)# dic.
- 110
- while True:
- 111
- try:
- 112
- print（next（iter_dic))#iter_dic
- next
- 113
- except StopIteration:
- 114
- break
- Run:
- 01选代器
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python
- Process finished with exit code0
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

注意：同一个迭代器只能完整地取完一次值

```plain
dic={'x':1,'y':2,'z':3}
iter_dic=iter(dic) # dic.__iter__()
while True:
    try:
        print(next(iter_dic)) #iter_dic.__next__()
    except StopIteration:
        break
print('==='*100)
while True:
    try:
        print(next(iter_dic)) #iter_dic.__next__()
    except StopIteration:
        break
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]
- ~/Desktop/py视
- 贝/pvthon
- /UsersdriverzengDesktoppy视频python视频压缩包版day13代码01迭代器.py
- 01函数对象.pyx
- 02函数嵌套.pyx
- 03名称空间与作用域.pyx
- 04闭包函数.pyX
- 01装饰器.pyx
- 02函数的递归调用.pyx
- 03三元表达式.pyx
- 04列表生成式.py
- 01选代器.py
- 95
- #ps:
- 96
- 1.迭代器对象一定是可迭代的对象，而可迭代的对象却不一定是迭代器对象
- 97
- 2.文件对象本身就是
- 一个送代器对象
- 98
- l=['a,'b','c']
- 99
- #iter_l=l._iter_（）#调用可迭代的对象_iter_得到的是迭代对象，
- 100
- #print（iter_lisiter_l._iter_()._iter_()._iter_()._iter_()._iter_()._iter_())
- 101
- 102
- ##dic={1,2,3,4}
- 103
- #dic={'x':1,'y'：2,'z'：3}
- 104
- ##print（len（dic））#dic.len_（)
- 105
- #iter_dic=iter（dic）#dic.iter_（)
- 106
- 107
- 108
- 109
- 110
- while True:
- 111
- try:
- 112
- print（next（iter_dic))#iter dicnext（）
- 113
- except StopIteration:
- 114
- break
- 115
- 116
- print（*100）
- 117
- 118
- 119
- 120
- 121
- 122
- 123
- Run:
- 01迭代器×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/py视频/python视频压缩包版/day13/代码/01选代器·py
- 曾老湿
- rocess finished with exit code
- DriverZeng
<!-- OCR_END -->

￼

如果想再次取值，那就重新赋值

```plain
dic={'x':1,'y':2,'z':3}
iter_dic=iter(dic) # dic.__iter__()
while True:
    try:
        print(next(iter_dic)) #iter_dic.__next__()
    except StopIteration:
        break
print('==='*100)
iter_dic=iter(dic) #dic.__iter__()
while True:
    try:
        print(next(iter_dic)) #iter_dic.__next__()
    except StopIteration:
        break
```

<!-- OCR_START -->
- PYTHON [~/Desktop/PYTHON]-~/Desktop/py视频/python视频压缩
- driverzeng Desktoppy视频python视频压缩包版 day13代码01迭代器·py
- 01函数对象.pyx
- 02函数嵌套.pyx
- 03名称空间与作用域.pyx
- 04闭包函数.pyx
- 01装饰器.pyx
- 02函数的递归调用.pyx
- 03三元表达式.py
- 96
- #1·送代器对家一定定可达代的对家，而可达代的对家却不一
- 一正定达代器对家
- 97
- #2.文件对象本身就是一个送代器对象
- 98
- #l=['a','b','c']
- 99
- #iter_l=l。_iter_（）#调用可迭代的对象_iter_得到的是迭代对象，
- 100
- #print(iter_l is iter_l._iter_()._iter_().
- _iter_()._iter_()._iter_().iter_())
- 101
- 102
- ##dic={1,2,3,4}
- 103
- #dic={'x':1,'y':2,'z':3}
- 104
- ## print(len(dic)) #dic.len_（)
- 105
- # iter_dic=iter（dic) # dic.iter_（)
- 106
- 107
- 108
- dic=f'x':1'y':2'z':3}
- 109
- iter_dic=iter(dic) # dic.
- iter_()
- 110
- while True：
- 111
- try:
- 112
- print（next(iter_dic)) #iter dic.next()
- 113
- except StopIteration:
- 114
- break
- 115
- 116
- print('
- 117
- 118
- 119
- 120
- 121
- 122
- 123
- 124
- 125
- Run:
- 01迭代器
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/py视频/python视频压缩包版/day13/代码/01
- rocess finished with exit code 0
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

## for循环底层原理分析

***

| for本质应该称之为迭代器循环 |
| :--- |

**工作原理：**

1. 先调用in后面那个对象的__iter__方法，将其变成一个迭代器对象

2. 调用next(迭代器)，将得到的返回值赋值给变量名k

3. 循环往复直到next(迭代器)抛出异常，for会自动捕捉异常然后结束循环

**注意：**

从for角度，可以分辨出但凡可以被for循，环循环取值的对象都是可迭代的对象

```plain
dic={'x':1,'y':2,'z':3}
for k in dic:
    print(k)
for k in dic:
    print(k)
```

## 迭代器总结

**优点：**

1.提供一种通用的且不依赖于索引的迭代取值方式

2.同一时刻在内存中只存在一个值，更节省内存

```plain
## 在python3中，直接做成迭代器对象，返回的是内存地址
l=[1,2,2,3,3,3,3,3,3,3,3,3,3,3]
iter_l=iter(l)
print(iter_l)
names = ['qls', 'lls', 'cls']
res=map(lambda x:x+"_SB",names)
print(res)
## 对于内存保护
obj=range(1,1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)
print(obj)
```

**缺点：**

1.取值不如按照索引的方式灵活，（不能取指定的某一个值，而且只能往后取）

2.无法预测迭代器的长度

## 自定义迭代器

***

| 生成器介绍 |
| :--- |

emm...看到标题，我们要讲一个自定义的迭代器，结果mmp，为啥就变成了生成器的介绍呢？

Because，生成器就是一种自定义的迭代器，本质就是迭代器

新概念：`yield`

```plain
def func():
    print('first')
    yield 
    
func()
```

但凡函数内包含yield关键字，调用函数不会执行函数体代码

<!-- OCR_START -->
- 83
- deffunc(）:
- 84
- print(
- 'first
- 85
- yield
- 86
- 87
- 88
- func()
- Run:
- 04列表生成式
- /Users/driverzeng/Desktop/PYTHoN/04列表生成式.py
- Process finished with exit code O
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
def func():
    print('first')
    # yield
func()
```

<!-- OCR_START -->
- 83
- deffunc():
- 84
- print('first'
- 85
- #yield
- 86
- 87
- 88
- func()
- Run:
- 04列表生成式×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/04 列表生成式.py
- first
- 曾老湿
- DriverZeng
- ocess finished with exit code o
<!-- OCR_END -->

￼

但是，它会得到一个返回值，该返回值就是生成器对象

```plain
def func():
    print('first')
    yield
g=func()
print(g)
```

<!-- OCR_START -->
- 83
- def func():
- 84
- print('first'
- 85
- yield
- 86
- 87
- gunc(）
- 88
- print(g)
- Run:
- 04列表生成式×
- /users/driverzeng/PvcharmProiects/untit
- Led1/venv/bin/python"/Users/driverzeng/Desktop/PYTHoN/o4列表生成式.py
- <generator object func at 0x1035da468>
- 曾老湿
- cess finished with exit code 0
- Driver Zeng
<!-- OCR_END -->

￼

所以，现在我们就会自己自定义迭代器了，只要在函数里面来一个yield，然后调用该函数得到这个函数的返回值即可。

yield后面可以跟返回值，类似于return

**区别：**

如果用return返回，一个函数只能返回一次，但是如果要用yield，只要next一次就能返回一个值

```plain
def func():
    print('first')
    yield 1
    print('second')
    yield 2
    print('third')
    yield 3
    print('fourth')
g=func()
print(g)
print(g.__iter__().__iter__() is g)
```

<!-- OCR_START -->
- 曾老湿

```text
driverzengDesktoppy视频python视频压缩包版day14代码01生成器py
01函数对象.py
02函数嵌套.py
03名称空间与作用域.py
04闭包函数.py
01装饰器.py
02函数的递归调用.py
03三元表达式.py
04列表
def func（）:
print('first')
yield1
print('second')
yield2
print('third')
10
yield3
11
print('fourth')
12
13
g=func()
14
print(g)
15
print(g. iter_(). iter_()is g)
Run:
01生成器
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/py视频/python视频压缩包版/day14/代码/01生成器·py
it
<generator object func at 0x103d93e60>
True
Process finished with exit code O
DriverZeng
```
<!-- OCR_END -->

￼

调用迭代器

```plain
def func():
    print('first')
    yield 1
    print('second')
    yield 2
    print('third')
    yield 3
    print('fourth')
g=func()
# print(g)
# print(g.__iter__().__iter__() is g)
res1=next(g) #会触发函数的执行，直到碰到一个yield停下来，并且将yield后的值当作本次next的结果返回
print(res1)
```

<!-- OCR_START -->
| 排名 | 名称 | 排名(上年) | 排名(上年) | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| def func（）: | 5 | print('first') | 6 | yield 1 | print('second') |
| 8 | yield 2 | 9 | print('third') | 10 | yield3 |
| 11 | print('fourth') | 12 | 13 | g=func() | 14 |
| #print(g) | 15 | #print(g._iter_()._iter_()isg) | 16 | 17 | res1=next（g）#会触发函数的执行，直到碰到一个yield停下来，并且将yield后的值当作本次next的结果返回 |
| 18 | print(res1) | 19 | Run: | 01生成器× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/py视频/python视频压缩包版/day14/代码/01生成器·py |
<!-- OCR_END -->

￼

一直调用，一直爽

```plain
def func():
    print('first')
    yield 1
    print('second')
    yield 2
    print('third')
    yield 3
    print('fourth')
g=func()
# print(g)
# print(g.__iter__().__iter__() is g)
res1=next(g) #会触发函数的执行，直到碰到一个yield停下来，并且将yield后的值当作本次next的结果返回
print(res1)
res2=next(g)
# print(res2)
res3=next(g)
# print(res3)
res4=next(g)
```

<!-- OCR_START -->
- 曾老湿

```text
PYTHON[~/Desktop/PYTHON]-~/Desktop/py视频/python视频压缩包版/day14/代码/01生成器.py
/UsersdriverzengDesktoppy视频python视频压缩包版day14代码01生成器py
01函数对象.py×
02函数嵌套.py
03名称空间与作用域.pyx
04闭包函数.py×
01装饰器.pyX
02函数的递归调用.pyX
03三元表达式.py×
04列表生成式.py
01生成器.py
百#但凡函数内包含y1eLd天键子，调用函数不会执行函数体代码，会得到一个返回值，该返回值就是生成器对家
def func（）：
print('first')
yield1
print('second')
yield2
print('third')
10
yield3
11
print('fourth')
12
13
g=func()
14
#print(g)
15
#print(g._iter_()._iter_() is g)
16
17
res1=next（g）#会触发函数的执行、真到碰到一个yield停下来，并具将yieLd后的值当作本次next的结果返回
18
print(res1)
19
res2=next(g)
20
#print（res2）
21
res3=next(g)
22
#print（res3)
23
res4=next(g)
Run:
01生成器×
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/py视频/python视频压缩包版/day14/代码/01生成器·py
first
1
second
third
fourth
Traceback(most recent call last):
File“/Users/driverzeng/Desktop/py视频/python视频压缩包版/day14/代码/01生成器.py"，line23，in<module>
res4=next(g)
StopIteration
Process finished with exit code1
DriverZeng
```
<!-- OCR_END -->

￼

## 练习：实现range功能

```plain
def my_range(start,stop,step=1):
    while start < stop: # 3 < 3
        yield start
        start+=step #start=3
obj=my_range(1,5,2) # 1 3
print(next(obj))
print(next(obj))
# 取干净了就报错
print(next(obj))
```

## 表达式yield应用（了解）

yield的表达式形式的应用: x=yield

**喂狗：**

```plain
def dog(name):
    print('狗哥 %s 准备开吃' %name)
    food_list=[]
    while True:
        food=yield food_list #  food=yield='肉包子'
        print('%s 吃了 %s' %(name,food))
        food_list.append(food)
g=dog('qls')
# 强调：针对表达式形式的yield的使用，第一步必须让函数先暂停到一个yield的位置，才能进行传值操作
next(g) # 张开狗嘴，让生成器先暂停到yield的位置，准备接收外部传进来的值
res1=next(g) #g.send(None)
print(res1)
res2=g.send('屎包子') # 1. 先为当前暂停位置的yield赋值 2. next(生成器)直到再次碰到一个yield停下来，然后其的值当做本次next的结果
# print(res2)
res3=g.send('肉包子')
# print(res3)
res4=g.send('泔水')
print(res4)
```

## yield关键字总结

**总结yield:**

* 0.只能在函数中使用。
* 1.yield提供了一种自定义迭代器的解决方案。
* 2.yield可以保存函数的暂停的状态。
* 3.yield对比return。
  * 3.1相同点：都可以返回值，值的类型与个数都没有限制。
  * 3.2不同点：yield可以返回多次值，而return只能返回一次值函数就结束了。

## 生成器表达式

回顾列表表达式

```plain
l=[i**2 for i in range(1,6) if i > 3]
print(l)
```

***

| 生成器表达式 |
| :--- |

```plain
# 生成器表达式
g=(i**2 for i in range(1,6) if i > 3)
# print(g)
print(next(g))
print(next(g))
print(next(g))
```

<!-- OCR_START -->
| 名称 | 排名 | 名称 | 名称 | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| g=(i**2foriinrange(1.6)if i>3) | 8 | #print(g) | 9 | print(next(g)) | 10 |
| print(next(g)) | 11 | print(next(g)) | Run: | 02生成器表达式× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/py视频/python视频压缩包版/day14/代码/02生成器表达式.py |
| Traceback(most recentcalllast): | File”/Users/driverzeng/Desktop/py视频/python视频压缩包版/day14/代码/02 生成器表达式.py”，line11，in<module> | print(next(g)) | 曾老湿 | pIteration | DriverZeng |
<!-- OCR_END -->

￼

```plain
# 统计文件中的字符数量
with open(r'/Users/driverzeng/Desktop/PYTHON/01 装饰器.py','rt',encoding='utf-8') as f:
    data=f.read()
    print(len(data))
## 但是这样会出问题，如果文件过大，可能会导致内存溢出
# 使用for循环一行一行的读
with open(r'/Users/driverzeng/Desktop/PYTHON/01 装饰器.py','rt',encoding='utf-8') as f:
    res=0
    for line in f:
        res+=len(line)
    print(res)
## 但是麻烦
# 使用生成器表达式
with open(r'/Users/driverzeng/Desktop/PYTHON/01 装饰器.py','rt',encoding='utf-8') as f:
    g=(len(line) for line in f)
    print(sum(g))
```

<!-- OCR_START -->
- 14
- 装饰器·py
- ,encoding='utf-8')asf:
- 15
- data=f.read()
- 16
- print(len(data))
- 17
- 18
- with open（r'/Users/driverzeng/Desktop/PYTHoN/o1 装饰器.py','rt'encoding='utf-8'）as f:
- 19
- g=(len(line)forline inf)
- 20
- print(sum(g))
- 21
- Run:
- 02生成器表达式
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python
- 2496
- Process finishedwithexit codeo
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

> 更新: 2020-06-25 10:52:55  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/agcax3>