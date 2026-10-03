# Python-基础04-数据类型

## Python-基础04-数据类型

2019-04-26 分类：[Linux](https://www.driverzeng.com/zenglaoshi/category/linux), [Python](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80/python), [脚本语言](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80) 阅读(41) 评论(0)

* [数据类型](https://www.driverzeng.com/zenglaoshi/1311.html#toc_0)
* [数据类型总结](https://www.driverzeng.com/zenglaoshi/1311.html#toc_1)

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

## 数据类型

1 什么是数据？

x=10，10是我们要存储的数据

2 为何数据要分不同的类型

数据是用来表示状态的，不同的状态就应该用不同的类型的数据去表示

3 数据类型

数字（整形，长整形，浮点型，复数）

字符串

字节串：在介绍字符编码时介绍字节bytes类型

列表

元组

字典

集合

4 按照以下几个点展开数据类型的学习

```plain
#======================================基本使用======================================
#1、用途
#2、定义方式
#3、常用操作+内置的方法
#======================================该类型总结====================================
#存一个值or存多个值
    
#有序or无序
有序：但凡有索引的数据都是有序的
#可变or不可变（1、可变：值变，id不变。可变==不可hash 2、不可变：值变，id就变。不可变==可hash）
可变类型：在值变了的情况下，id不变，证明在改原值
不可变类型：在值变了的情况下，id也跟着变了，证明不是在改变原值
```

***

| 数字类型 |
| :--- |

**整型：int**

1.用途

记录年龄、等级、号码。

2.定会方式

age=18 #age=int(18)

int除了造整型的功能，还可以转换。**只转换纯数字**

```plain
#报错
int('zls')
#报错
int('10.1')
#成功
int('10')
```

进制数

```plain
#二进制:0,1
10 #1*(2**1) + 0*(2**0)
#十进制:0-9
10 #1*(10**1)+0*(10**0)
#八进制:0-7
10 #1*(8**1)+0*(8**0)
#十六进制:0-9 A-F
10 #1*(16**1)+0*(16**0)
```

整数取余法，将十进制转成其他进制

python内置的方法

```plain
#转成二进制
print(bin(12))
#转成八进制
print(oct(12))
#转成十六进制
print(hex(12))
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- a.pyX
- 110
- untitled1 ~/PycharmProjects/untitled1
- 111
- 112
- bin
- 113
- print(bin（12))
- include
- 114
- 115
- print(oct(12))
- lib
- 116
- 117
- print(hex(12))
- 三pyvenv.cfg
- 118
- 119
- 120
- 121
- IliExternal Libraries
- 122
- ScratchesandConsoles
- 123
- 124
- 125
- 126
- 127
- 128
- 129
- 130
- 131
- 132
- 133
- 134
- 135
- Run:
- 2变量
- a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- 0b1100
- 0014
- 0xC
- ProcessfinishedwithexitcodeO
<!-- OCR_END -->

￼

3.常用操作+内置方法

4.存一个值or多个值

一个值

5.有序or无序

根本没有有序 无序，就是一个值

6.可变or不可变

```plain
x=10
print(id(x))
x=11
print(id(x))
#结果
4304951968
4304952000
```

值变了，id也变了，所以int类型是不可变类型

**浮点型：float**

1.用途

记录身高、体重、薪资

2.定义方式

salary=3.1 #salary=float(3.1)

3.常用操作+内置方法

4.存一个值or多个值

一个值

5.有序or无序

6.可变or不可变

```plain
x=1.1
print(id(x))
x+=1.2
print(id(x))
#结果
4325908888
4325908672
```

***

| 字符串类型 |
| :--- |

1.用途

记录描述性的状态，比如人的名字、地址、性别

2.定义方式

在'','''''',"",""""""内包含的一系列字符

msg='hello'

除了创造类型，还可以转换，**可以将所有类型都转成字符串**

```plain
res1=str(1)
res2=str([1,2,3])
print(type(res1),type(res2))
```

3.常用操作+内置方法

**优先掌握**

1）按索引取值(正向取+反向取) ：只能取

```plain
#正向取
msg='hello world'
print(msg[0])
print(msg[1])
print(msg[2])
print(msg[3])
print(msg[4])
print(msg[5])
#反向取
msg='hello world'
print(msg[-1])
print(msg[-2])
print(msg[-3])
print(msg[-4])
print(msg[-5])
```

2）切片(顾头不顾尾，步长)

```plain
#默认不步长
msg='hello world'
print(msg[0:5])
print(msg[6:-1])
msg='hello world'
print(msg[:5])
print(msg[6:])
#指定步长
msg='hello world'
print(msg[0:5:1])
print(msg[6:-1:2])
msg='hello world'
print(msg[0:5:-1])
print(msg[5:0-1])
print(msg[-1::-1])
print(msg[::-1])
```

3）长度len

```plain
msg='hello world'
print(len(msg))
```

4）成员运算in和not in

```plain
# in
msg='zls is a nice boy'
print('zls' in msg)
print('bgx' in msg)
# not in
msg='zls is a nice boy'
print('bgx' not in msg)
print(not 'bgx' in msg)
```

5）移除空白strip(去除字符串左右两边的字符)

```plain
user='         zls         '
print(user.strip(' '))
print(user.strip())
user='      x   zls         '
print(user.strip())
user='*********zls***********'
print(user.strip('*'))
user='****/* *+**zls***=** ******'
print(user.strip('/ *+='))
```

思考:

```plain
user=input('>>>:')
if user == 'zls':
    print('用户名正确')
```

6）切分split

```plain
#取出用户密码，用切片
msg='root:123:0:0::/root:/bin:/bash'
print(msg[5:8])
#使用切分取出用户密码
msg='root:123:0:0::/root:/bin:/bash'
res=msg.split(':')
print(res[1])
#取出文件名
dirct='/usr/local/src/a.txt
res=dirct.split('/')
print(res[4])
```

7）循环

```plain
msg='hello'
for item in msg:
    print(item)
```

**需要掌握**

1）strip,lstrip,rstrip

```plain
msg='*************zls**********'
print(msg.strip('*'))
print(msg.lstrip('*'))
print(msg.rstrip('*'))
```

2）lower,upper

```plain
#全变小写
msg='*************zLs ZHEN shuai**********'
print(msg.lower())
print(msg)
#全变大写
msg='*************zLs ZHEN shuai**********'
print(msg.upper())
print(msg)
```

3）startswith,endswith

```plain
msg='zls is a nice boy'
print(msg.startswith('zls'))
print(msg.endswith('zls'))
print(msg.endswith('boy'))
print(msg.endswith('oy'))
print(msg.endswith('y'))
```

4）format的三种玩法

```plain
1.玩法一
msg="my name is {name} ,I'm {age} years old"
print(msg.format(name='zls',age=18))
2.玩法二
msg="my name is {} ,I'm {} years old"
print(msg.format('zls',18))
3.玩法三
msg="my name is {0} ,I'm {1}{1} years old"
print(msg.format('zls',18))
```

5）split,rsplit

```plain
#指定切分个数
dirct='/usr/local/src/a.txt'
print(dirct.split('/',1))
#如果不指定个数，split和rsplit一样
dirct='/usr/local/src/a.txt'
print(dirct.split('/'))
print(dirct.rsplit('/'))
#指定个数就不一样了
dirct='/usr/local/src/a.txt'
print(dirct.split('/',1))
print(dirct.rsplit('/',1))
```

6）join

```plain
dirct='/usr/local/src/a.txt'
l=dirct.split('/')
msg='/'.join(l)
print(msg)
```

7）replace

```plain
msg='alex say i have one tesla,alex is hahaha'
print(msg.replace('alex','xxx'))
```

8）isdigit

```plain
print('10'.isdigit())
print('10.1'.isdigit())
#应用场景,判断是不是纯数字
age=input('>>>:')
if age > 30:
    print('too big')
elif age < 30:
    print('too small')
else:
    print('you got it')
#上面写法会报错，因为input的是字符串
age=int(input('>>>:'))
if age > 30:
    print('too big')
elif age < 30:
    print('too small')
else:
    print('you got it')
#如果按照上面的写，问题又来了，用户会老老实实写数字么？
age=input('>>>:')
if age.isdigit():
    age=int(age)
    if age > 30:
        print('too big')
    elif age < 30:
        print('too small')
    else:
        print('you got it')
else:
    print('必须输入数字')
```

**其他了解**

1）find,rfind,index,rindex,count

```plain
#find 从左边找
msg='zls is a nice boy'
print(msg.find('zls'))
print(msg.find('zls',5,7))
#index 查询索引
msg='zls is a nice boy'
print(msg.index('zls'))
print(msg.index('zls',7,8))
#rfind 从右边找
msg='hello zls is a nice boy'
print(msg.rfind('zls'))
#count 查询数量
msg='hello zls is a nice boy'
print(msg.count('zls'))
```

2）center,ljust,rjust,zfill

```plain
#center 居中
print('zls'.center(50,'*'))
#ljust 左对齐
print('zls'.ljust(50,'*'))
#rjust 右对齐
print('zls'.rjust(50,'*'))
#zfill 0填充
print('zls'.zfill(50))
```

3）expandtabs

```plain
print('zls\nshuai')
print('zls\tshuai')
print('zls\tshuai'.expandtabs(10))
```

4）captalize,swapcase,title

```plain
#captalize 首字母大写
print('hello'.capitalize())
#swapcase 大小写转换
print('Hello'.swapcase())
#title 首字母大写
print('heLLo'.title())
```

5）is数字系列

```plain
#在python3中
num1=b'4' #bytes
num2=u'4' #unicode,python3中无需加u就是unicode
num3='四' #中文数字
num4='Ⅳ' #罗马数字
#isnumeric
print(num1.ismueric())
print(num2.ismueric())
print(num3.ismueric())
print(num4.ismueric())
#总结：Unicode，中文数字，罗马数字
#isdecimal
print(num1.isdecimal())
print(num2.isdecimal())
print(num3.isdecimal())
print(num4.isdecimal())
#总结：只能识别Unicode
#isdigit
print(num1.isdigit())
print(num2.isdigit())
print(num3.isdigit())
print(num4.isdigit())
#总结：能识别bytes类型，Unicode
```

6）is其他

```plain
#isalnum 字母或数字，中文字符
print('abc'.isalnum())
print('123'.isalnum())
print('abc12'.isalnum())
#isalpha 字符串中包含的是纯字母、中文
print('abc'.isalpha())
```

4.存一个值or多个值

存一个值

5.有序or无序

有序

6.可变or不可变

不可变

```plain
x='zls'
print(id(x))
x='zls a'
print(id(x))
```

***

| 列表类型 |
| :--- |

1.用途

存放多个值，可以根据索引存取值。

2.定义方式

在`[]`内用逗号分隔开，多个任意类型的值。

除了创造值以外，还可以转换类型。类似于调用`for`循环

能被for循环的数据类型，一定可以被列表转换。

```plain
#转换字符串
l1=list('hello')
print(l1)
#转换字典
l2=list({'x':1,'y':2,'z':3})
print(l2)
```

3.常用操作+内置的方法

**优先掌握**

1）按索引存取值(正向存取+反向存取)：即可存也可以取

```plain
#列表可以改值，超过索引会报错，只能根据已经存在的索引去改值
l=['zls','bgx','oldboy']
print(l[0])
l[0]='ZLS'
print(l[0])
l=[1,2,3,4,5,6]
#正向步长
l[0:3:1] #[1, 2, 3]
#反向步长
l[2::-1] #[3, 2, 1]
#列表翻转
l[::-1] #[6, 5, 4, 3, 2, 1]
```

2）切片(顾头不顾尾，步长)

```plain
l=['zls','bgx','oldboy']
print(l[0:2])
print(l[0:2:2])
#翻转列表
l=['zls','bgx','oldboy']
print(l[::-1])
```

3）长度

```plain
l=['zls','bgx','oldboy']
print(len(l))
```

4）成员运算in和not in

```plain
l=['zls','bgx','oldboy']
print('zls' in l)
print('123' in l)
```

5）追加

```plain
#追加
l=['zls','bgx','oldboy']
l.append(123)
print(l)
#插入
l=['zls','bgx','oldboy']
l.insert(1,'alex')
print(l)
l.insert(0,'egon')
```

6）删除

```plain
#del
l=['zls','bgx','oldboy']
del l[1]
print(l)
#remove 指定要删除的值，返回None
l=['zls','bgx','oldboy']
res=l.remove('zls')
print(l,res)
#pop 指定索引删除，默认从末尾删，有返回值
l=['zls','bgx','oldboy']
res=l.pop(-1)
print(l,res)
```

7）循环

```plain
l=['zls','bgx','oldboy']
for item in l:
    print(item)
```

**需要掌握**

```plain
#count 判断重复元素个数
l=['zls','zls','bgx','oldboy']
print(l.count('zls'))
#index查找索引
l=['zls','zls','bgx','oldboy']
print(l.index('bgx'))
#extend 没有返回值
l=['zls','zls','bgx','oldboy']
l.extend(['a','b','c'])
print(l)
#reverse 翻转
l=['zls','zls','bgx','oldboy']
l.reverse()
print(l)
#sort 排序，但是不能夸类型排序
l=['1','-1','100','8']
l.sort()
print(l)
l=['1','-1','100','8']
l.sort(reverse=True)
print(l)
```

4.存一个值or存多个值

多个值

5.有序or无序

有序

6.可变or不可变

可变

```plain
l=['1','-1','100','8']
print(id(l))
l.append('10')
print(id(l))
```

**小练习**

队列：

先进，先出

入队

```plain
l=[]
l.append('first')
l.append('second')
l.append('third')
print(l)
```

出队

```plain
l.pop(0)
l.pop(0)
l.pop(0)
print(l)
```

堆栈：

先进，后出

后进，先出

入栈

```plain
l=[]
l.append('first')
l.append('second')
l.append('third')
```

出栈

```plain
l.pop()
l.pop()
l.pop()
```

***

| 元组类型 |
| :--- |

元组：tuple

1.用途

记录多个值，当多个值没有修改的需求，此时用元组更合适

2.定义方式

在`()`内，用逗号分隔开，多个任意类型的值

```plain
t=(1,1.3,('a','b'),[1,2],'zls')
print(t,type(t))
```

3.常用操作+内置的方法

**优先掌握**

1）按索引取值(正向取+反向取)：只能取

```plain
t=(1,1.3,('a','b'),[1,2],'zls')
print(t[0])
```

2）切片(顾头不顾尾，步长)

```plain
t=(1,1.3,('a','b'),[1,2],'zls')
print(t[0:3])
print(t[0:3:2])
```

3）长度

```plain
t=(1,1.3,('a','b'),[1,2],'zls')
print(len(t))
```

4）成员运算in和not in

```plain
t=(1,1.3,('a','b'),[1,2],'zls')
print('zls' in t)
print('zls' not in t)
print('123' not in t)
```

5）循环

```plain
t=(1,1.3,('a','b'),[1,2],'zls')
for item in t:
    print(item)
```

**需要掌握**

```plain
#count
t=(1,1.3,('a','b'),[1,2],'zls')
res=t.count('a')
print(res)
#index
t=(1,1.3,('a','b'),[1,2],'zls')
res=t.index(1.3)
print(res)
t=(1,1.3,('a','b'),[1,2],'zls')
res=t.index(1.3,2,5)
print(res)
```

4.存一个值or存多个值

多个值,在存放多个值的情况下 ，元组比列表更省空间

5.有序or无序

有序

6.可变or不可变

不可变,id不会变（图解）

***

| 字典类型 |
| :--- |

***可变类型：不可hash类型***

***不可变类型：可hash类型***

1.用途

用来记录多个值，每一个值都对应的key用来描述value的作用

2.定义方式

在`{}`内，用逗号分隔开，多个key:value，其中value可以是任意类型，但是key必须是不可变的类型

```plain
#这么去定义？？？？
dic={0:'aaa',1:'bbb',2:'ccc'}
print(dic,type(dic))
print(dic[0])
```

转换类型：

```plain
#字符串转换
dic=dict(x=1,y=2,z=3)
print(dic)
#列表转换
userinfo=[
    ['name','zls'],
    ['age',18],
    ['sex','male']
]
dic=dict(userinfo)
print(dic)
方法二：
userinfo=[
    ['name','zls'],
    ['age',18],
    ['sex','male']
]
dic={}
for item in userinfo:
    #print(key,value)
    dic[item[0]]=item[1]
print(dic)
   
方法三：
userinfo=[
    ['name','zls'],
    ['age',18],
    ['sex','male']
]
dic={}
for key,value in userinfo:
    #print(key,value)
    dic[key]=value
print(dic)
```

3.常用操作+内置的方法

**优先掌握**

1）按key存取值：可存可取

```plain
#取
dic={'name':'zls'}
print(dic['name'])
#修改
dic={'name':'zls'}
print(dic['name'])
dic['name']='ZLS'
print(dic)
#添加，列表做不到
dic={'name':'zls'}
dic['age']=18
print(dic)
```

2）长度len

```plain
#key:value的个数，也可以理解为key的个数，自动去重
dic={'name':'zls','age':18}
print(len(dic))
```

3）成员运算in和not in

```plain
#判断的是key
dic={'name':'zls','age':18}
print(18 in dic)
print('name' in dic)
```

4）删除

```plain
#del通用
dic={'name':'zls','age':18}
del dic['name']
print(dic)
#clear清空
dic={'name':'zls','age':18}
dic.clear()
print(dic)
#pop
dic={'name':'zls','age':18}
res=dic.pop('age')
print(dic,res)
#popitem随机删除，并且有返回值
dic={'name':'zls','age':18}
dic.popitem()
print(dic)
```

5）键keys()，值values()，键值对items()

```plain
#在python2中
MacBook-Pro:bin driverzeng$ python
Python 2.7.10 (default, Aug 17 2018, 17:41:52)
[GCC 4.2.1 Compatible Apple LLVM 10.0.0 (clang-1000.0.42)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> dic={'name':'zls','age':18}
>>> dic.keys()
['age', 'name']
>>> dic.values()
[18, 'zls']
>>> dic.items()
[('age', 18), ('name', 'zls')]
#python3中
dic={'name':'zls','age':18}
print(dic.keys())
print(dic.values())
print(dic.items())
#像python2中查看python3
l=[]
dic={'name':'zls','age':18}
for k in dic.keys():
    l.append(k)
print(l)
------------
dic={'name':'zls','age':18}
print(list(dic.keys()))
print(list(dic.values()))
print(list(dic.items()))
```

6）循环

```plain
dic={'name':'zls','age':18}
for k in dic.keys():
    print(k)
for v in dic.values():
    print(v)
for k,v in dic.items():
    print(k,v)
```

7.取值get

```plain
#key不存在不会报错
dic={'name':'zls','age':18}
print(dic.get('name'))
```

**需要掌握**

```plain
#fromkeys
dic={}
l=['name','age','sex']
dic=dic.fromkeys(l,None)
print(dic)
#setdefault有则不动（返回已经存在的key对应的value），无则添加（返回新value）
d={'name':'ZLS','x':1,'y':2}
d.setdefault('name','zls')
d.setdefault('sex','male')
print(d)
#update
od={'name':'zls','age':18}
d={'name':'ZLS','x':1,'y':2}
print(od)
od.update(d)
print(od)
```

4.存一个值or存多个值

存多个值

5.有序or无序

无序

6.可变or不可变

可变

***

**小练习**

```plain
1 有如下值集合 [11,22,33,44,55,66,77,88,99,90...]，将所有大于 66 的值保存至字典的第一个key中，将小于 66 的值保存至第二个key的值中
即： {'k1': 大于66的所有值, 'k2': 小于66的所有值}
```

```plain
2 统计s='hello alex alex say hello sb sb'中每个单词的个数
结果如：{'hello': 2, 'alex': 2, 'say': 1, 'sb': 2}
```

***

| 集合类型 |
| :--- |

引入场景：老男孩教育上海校区有两门课程，python和linux

```plain
#报名python和Linux的学生
pythons=['egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕']
linuxs=['oldboy','bgx','alex','陈独秀','赵铁柱','李二丫']
#如何判断哪个学生同时报了两门课程
pythons=['egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕']
linuxs=['oldboy','bgx','alex','陈独秀','赵铁柱','李二丫']
l=[]
for stu in pythons:
    if stu in linuxs:
        l.append(stu)
print(l)
```

1.用途

1）用来做关系运算

2）去重

2.定义方式

在`{}`内用逗号分隔开的多个值

1）每一个值都必须是不可变类型

2）元素不能重复

3）无序

```plain
s={'a','b''c','d'}
```

转换类型：

```plain
s='hello'
print(set(s))
```

3.常用操作+内置的方法

**优先掌握**

1）长度len

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(len(pythons),len(linuxs))
```

2）成员运算in和not in

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print('zls' in pythons)
print('zls' in linuxs)
print('oldboy' not in pythons)
```

3）|合集

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(pythons|linuxs)
```

4）&交集

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(pythons&linuxs)
```

5）-差集

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(linuxs-pythons)
print(pythons-linuxs)
```

6）<sup>对称差集</sup>

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(linuxs^pythons)
print(pythons^linuxs)
```

7）==

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(linuxs == pythons)
print(pythons == linuxs)
```

8）父集：>,>=

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(linuxs >= pythons)
print(pythons > linuxs)
```

9）子集：<,<=

```plain
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(linuxs <= pythons)
print(pythons < linuxs)
```

**需要掌握**

```plain
#交集
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(pythons.intersection(linuxs))
print(pythons&linuxs)
#并集
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(pythons.union(linuxs))
print(pythons|linuxs)
#差集
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(pythons.difference(linuxs))
print(pythons-linuxs)
#对称差集
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(pythons.symmetric_difference(linuxs))
print(pythons^linuxs)
#父集
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(pythons.issuperset(linuxs))
print(pythons>=linuxs)
#子集
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
print(pythons.issubset(linuxs))
print(pythons<=linuxs)
#update(一定要加大括号，否则...)
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
pythons.update('zls')
print(pythons)
pythons.update({'zls'})
print(pythons)
#pop随机删除，有返回值
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
res=pythons.pop()
print(pythons,res)
#remove指定元素删除，没有返回值
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
res=pythons.remove('alex')
print(pythons,res)
#add添加一个值，没有返回值
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
res=pythons.add('zls')
print(pythons,res)
#difference_update求出差集 并赋值给pythons集合
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
pythons=pythons.difference(linuxs)
print(pythons)
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
pythons.difference_update(linuxs)
print(pythons)
#discard ,同样是删除，并且没有返回值，但是相比remove 元素不存在，不报错
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
res=pythons.discard('alex')
print(pythons,res)
#isdisjoint如果两个集合没有交集则返回True
pythons={'egon','alex','张3','李4','王5','赵铁柱','李二丫','蔡徐坤','徐根硕'}
linuxs={'oldboy','bgx','alex','陈独秀','赵铁柱','李二丫'}
res=pythons.isdisjoint(linuxs)
print(res)
```

4.存一个值or存多个值

存多个值

5.有序or无序

无序

6.可变or不可变

可变

**去重用法**

```plain
names=['zls','oldboy','oldboy','zls','bgx','123']
print(set(names))
#存在问题
1.列表变成了集合
2.顺序乱了
#变回列表
names=['zls','oldboy','oldboy','zls','bgx','123']
s=set(names)
l=list(s)
print(l)
#但是顺序还是乱了
#如果数据是字典
stu_info=[
    {'name':'zls','age':18},
    {'name':'bgx','age':73},
    {'name':'bgx','age':73},
    {'name':'bgx','age':73},
    {'name':'zls','age':18},
    {'name':'oldboy','age':84},
    {'name':'oldboy','age':84}
]
set(stu_info)
#局限性：
1.无法保证元数据类型的顺序
2.当某一个数据类型中包含的多个值，全部为不可变类型时，才能用集合去重
#如何去重？
stu_info=[
    {'name':'zls','age':18},
    {'name':'bgx','age':73},
    {'name':'bgx','age':73},
    {'name':'bgx','age':73},
    {'name':'zls','age':18},
    {'name':'oldboy','age':84},
    {'name':'oldboy','age':84}
]
l=[]
for info in stu_info:
    if info not in l:
        l.append(info)
print(l)
stu_info=l
print(stu_info)
```

## 数据类型总结

| 按存储空间的占用分（从高到低） |
| :--- |

```plain
数字
字符串
集合：无序，即无序存索引相关信息
元组：有序，需要存索引相关信息，不可变
列表：有序，需要存索引相关信息，可变，需要处理数据的增删改
字典：无序，需要存key与value映射的相关信息，可变，需要处理数据的增删改
```

***

| 按存值个数区分 |
| :--- |

| 标量/原子类型 | 数字、字符串 |
| :--- | :--- |
| 容器类型 | 列表、原子、字典 |

***

| 按可变不可变区分 |
| :--- |

| 可变 | 列表、字典 |
| :--- | :--- |
| 不可变 | 数字、字符串、元组 |

***

| 按访问顺序区分 |
| :--- |

| 直接访问 | 数字 |
| :--- | :--- |
| 顺序访问(序列类型) | 字符串、列表、元组 |
| key值访问(映射类型) | 字典 |

未经允许不得转载，欢迎技术交流，QQ：133411023：[DBA老司机带你删库到跑路.](https://www.driverzeng.com/) » [Python-基础04-数据类型](https://www.driverzeng.com/zenglaoshi/1311.html)

> 更新: 2019-05-28 15:17:01  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/swkrcf>