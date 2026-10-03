# Python基础12-内置函数

## Python基础12-内置函数
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(3) 评论(0)

+ [内置函数介绍](https://blog.driverzeng.com/zenglaoshi/5299.html#toc_0)
+ [面向过程编程](https://blog.driverzeng.com/zenglaoshi/5299.html#toc_1)

>  
>
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

## 内置函数介绍
---

| 内置函数 |
| :--- |

```plain
#注意：内置函数id()可以返回一个对象的身份，返回值为整数。
这个整数通常对应与该对象在内存中的位置，但这与python的具体实现有关，不应该作为对身份的定义，即不够精准，最精准的还是以内存地址为准。
is运算符用于比较两个对象的身份，等号比较两个对象的值，内置函数type()则返回一个对象的类型
```

[更多内置函数](https://docs.python.org/3/library/functions.html)

<!-- OCR_START -->
- Built-inFunctions
- The Python interpreter has a number of functions and types built into it that are always available. They
- arelistedhereinalphabeticalorder.
- Built-in
- Functions
- abs()
- delattr()
- hash()
- memoryview()
- set()
- all()
- dict()
- help()
- min()
- setattr()
- any()
- dir()
- hex()
- next()
- slice()
- ascii()
- divmod()
- id()
- object()
- sorted()
- bin()
- enumerate()
- input()
- oct()
- staticmethod()
- bool()
- eval()
- int()
- open()
- str()
- breakpoint()
- exec()
- isinstance()
- ord()
- sum()
- bytearray()
- filter()
- issubclass()
- pow()
- super()
- bytes()
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
- import_()
- hasattr()
- max()
- round()
- comnlet
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

---

| abs |
| :--- |

取绝对值

```plain
print(abs(-1))
print(abs(0))
```

---

| all |
| :--- |

如果iterable中的所有值x的bool（x）为True，则返回True。

如果iterable为空，则返回True。

```plain
# 底层代码
def all(iterable):
    for element in iterable:
        if not element:
            return False
    return True
# 调用测试
print(all([1,'',None]))
print(all([1,2,'aaa']))
print(all([]))
print(all(''))
```

<!-- OCR_START -->
- 曾老湿

```text
PYTHON
01内置函数.py
01函数对象.pyX
02函数嵌套.py
03名称空间与作用域.py
04闭包函数.pyx
01装饰器.py
02函数的递归调用.py
03三元表达式
print(all([1,''None]))
print(all([1,2,'aaa']))
pnt(all([]))
print(all（"）) Run: 01内置函数× /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/01 内置函数.py"
False
True
'ue
Driver Zeng
```
<!-- OCR_END -->

￼

---

| any |
| :--- |

如果iterable中的任何x的bool（x）为True，则返回True。

如果iterable为空，则返回False。

```plain
# 底层代码
def any(iterable):
    for element in iterable:
        if element:
            return True
    return False
# 调用测试
print(any([0,'',None,False,1]))
print(any([0,'',None,False]))
print(any([]))
```

<!-- OCR_START -->
- 29
- orintCanyCLo"
- None,False,1]))
- 30
- print（any([0
- 31
- Run:
- 01内置函数×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python
- "/Users/driverzeng/Desktop/PYTHoN/o1内置函数.py
- True
- se
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

---

| bin |
| :--- |

二进制转换

---

| oct |
| :--- |

十进制转换

---

| hex |
| :--- |

十六进制转换

---

| bool |
| :--- |

查看布尔值

所有数据都有布尔值，只有几种的布尔值为假

```plain
print(bool(0))
print(bool(''))
print(bool([]))
print(bool(None))
```

---

| bytes |
| :--- |

字节类型

```plain
res='你'.encode('utf-8')
res='你'.encode('utf-8')
res=bytes('你',encoding='utf-8')
print(res,type(res))
```

---

| callable |
| :--- |

判断一个数据类型是不是可调用对象

```plain
print(callable(len))
print(callable(1))
```

---

| chr |
| :--- |

将字符编码表转换成ASCII码表的字符

```plain
print(chr(65))
print(chr(90))
print(chr(97))
print(chr(122))
```

---

| ord |
| :--- |

ord与chr相反，把ASCII码表的数字展示出来

```plain
print(ord('a'))
print(ord('z'))
print(ord('@'))
```

---

| dir |
| :--- |

查看某个函数下面所有的方法

```plain
import time
print(dir(time))
```

---

| divmod |
| :--- |

传递两个参数，最后得出结果，第一个参数除以第二个参数的结果放入元组中，前面是整数部分，后面是余数部分

```plain
print(divmod(3003,20))
```

<!-- OCR_START -->
26
print（divmod(3003,20))
Run:
01内置函数×
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/01 内置函数·py'
(150,3)
曾老湿
ocess finished with exit code o
Driver Zeng
<!-- OCR_END -->

￼

一般应用场景，就是一个网站分页的计算，如果我有3003个商品，一个页面摆20个商品，我需要多少页？

---

| enumerate |
| :--- |

循环一个列表，将该列表的值和索引存入元组中

```plain
for i in enumerate(['a','b','c']):
    print(i)
```

<!-- OCR_START -->
- 27
- for i in enumerate(['a','b',c']):
- 28
- print（i)
- Run:
- 01内置函数
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/01 内置函数.py"
- (0,'a')
- (1,
- 'b')
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| eval |
| :--- |

将字符串中的表达式拿出来运行

```plain
res=eval('[1,2,3]')
print(res,type(res))
```

<!-- OCR_START -->
26
res=eval('[1,2,3]')
27
print(res,type(res))
Run:
01内置函数×
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python
/Users/driverzeng/Desktop/PYTHoN/o1 内置函数.py
2,3】<class'list'>
曾老湿
Driver Zeng
<!-- OCR_END -->

￼

---

| pow |
| :--- |

传递三个参数，前两个参数的进行幂运算的结果对第三个参数取余

```plain
print(pow(2,3,5))
# 类似
print(2**3%5)
```

---

| reverse |
| :--- |

反转

```plain
l=[1,'a','3',3]
l1=reversed(l)
print(list(l1))
```

---

| round |
| :--- |

四舍五入

```plain
print(round(3.5))
print(round(3.3))
```

---

| slice |
| :--- |

切片

```plain
l=['a','b','c','d','e']
s='helloworld'
obj=slice(1,5,2)
print(l[1:5:2])
print(l[obj])
print(s[1:5:2])
print(s[obj])
```

<!-- OCR_START -->
- 30
- L=['a''b''c'd'
- 31
- s='helloworld'
- 32
- obj=slice(1,52)
- 33
- 34
- print([1:5:2])
- 35
- print(l[obj])
- 36
- 37
- print(s[1:5:2])
- 38
- Run:
- 01内置函数×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/PYTHoN/01 内置函数.py"
- ['b','d']
- el
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| zip |
| :--- |

拉链函数

```plain
l=[1,2,3,4,5,6,7]
s='hello'
res=zip(l,s)
print(list(res))
```

<!-- OCR_START -->
- 30
- L=[1.2345.67]
- 31
- s='hello
- 32
- 33
- res=zip(l,s)
- 34
- print(list(res))
- Run:
- 01内置函数×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/01 内置函数.py
- [（1,'h'）,（2,'e'),（3,'1'),(4,'1'),（5,'0')]
- Process finished with exit code O
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| import |
| :--- |

导入模块

```plain
m=__import__('time')
print(m.time())
```

---

| 面向对象重点知识 |
| :--- |

在面向对象文章中，重点介绍

```plain
object.__dict__
classmethod
staticmethod
property
delattr
hasattr
getattr
setattr
isinstance
issubclass
object
super
```

## 面向过程编程
可以理解为是一个编程思想或者是变成套路

核心是过程二字,过程指的就是解决问题的步骤,即先干什么再干什么后干什么...

基于该思想编写程序就好比在设计一条流水线,是一种机械式的思维方式

优点:复杂的问题流程化,进而简单化

缺点:可扩展性差

```plain
## 注册功能:
#阶段1: 接收用户输入账号与密码,完成合法性校验
def talk():
    while True:
        username=input('请输入你的用户名: ').strip()
        if username.isalpha():
            break
        else:
            print('用户必须为字母')
    while True:
        password1=input('请输入你的密码: ').strip()
        password2=input('请再次输入你的密码: ').strip()
        if password1 == password2:
            break
        else:
            print('两次输入的密码不一致')
    return username,password1
#阶段2: 将账号密码拼成固定的格式
def register_interface(username,password):
    format_str='%s:%s\n' %(username,password)
    return format_str
#阶段3: 将拼好的格式写入文件
def handle_file(format_str,filepath):
    with open(r'%s' %filepath,'at',encoding='utf-8') as f:
        f.write(format_str)
def register():
    user,pwd=talk()
    format_str=register_interface(user,pwd)
    handle_file(format_str,'user.txt')
register()
```

**如果要添加功能，那就很麻烦，牵一发而动全身**

```plain
#阶段1: 接收用户输入账号与密码,完成合法性校验
def talk():
    while True:
        username=input('请输入你的用户名: ').strip()
        if username.isalpha():
            break
        else:
            print('用户必须为字母')
    while True:
        password1=input('请输入你的密码: ').strip()
        password2=input('请再次输入你的密码: ').strip()
        if password1 == password2:
            break
        else:
            print('两次输入的密码不一致')
    role_dic={
        '1':'user',
        '2':'admin'
    }
    while True:
        for k in role_dic:
            print(k,role_dic[k])
        choice=input('请输入您的身份>>: ').strip()
        if choice not in role_dic:
            print('输入的身份不存在')
            continue
        role=role_dic[choice]
    return username,password1,role
#阶段2: 将账号密码拼成固定的格式
def register_interface(username,password,role):
    format_str='%s:%s:%s\n' %(username,password,role)
    return format_str
#阶段3: 将拼好的格式写入文件
def handle_file(format_str,filepath):
    with open(r'%s' %filepath,'at',encoding='utf-8') as f:
        f.write(format_str)
def register():
    user,pwd,role=talk()
    format_str=register_interface(user,pwd,role)
    handle_file(format_str,'user.txt')
register()
```

> 更新: 2020-06-25 10:53:56  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/kv6vq0>