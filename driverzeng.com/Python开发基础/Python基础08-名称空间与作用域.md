# Python基础08-名称空间与作用域

## Python基础08-名称空间与作用域
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

+ [函数对象](https://blog.driverzeng.com/zenglaoshi/5233.html#toc_0)
+ [函数嵌套](https://blog.driverzeng.com/zenglaoshi/5233.html#toc_1)
+ [名称空间与作用域](https://blog.driverzeng.com/zenglaoshi/5233.html#toc_2)
+ [闭包函数](https://blog.driverzeng.com/zenglaoshi/5233.html#toc_3)

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

## 函数对象
---

| 函数是第一类对象 |
| :--- |

指的是函数名指向的值（函数）可以被当做数据去使用

```plain
def func(): #func=函数的内存地址
    print('from func')
print(func)
```

**1、可以被引用**

```plain
def func(): #func=函数的内存地址
    print('from func')
print(func)
# 引用
f=func
print(f)
f()
```

**2、可以当作参数传递**

```plain
age=18
def func(): #func=函数的内存地址
    print('from func')
print(func)
def bar(x):
    print(x)
bar(age)  #既然我可以往里传递一个age，同样我也可以把函数传递进去
#传递func函数
bar(func)
```

**3、可以当做一个函数的返回值**

```plain
age=18
def func(): #func=函数的内存地址
    print('from func')
def bar(x):
    return x
res=bar(age)
print(res)
res=bar(func)
print(res)
```

**4、可以当作容器类型的元素**

```plain
age=18
l=[age]
print(l)
def func(): #func=函数的内存地址
    print('from func')
l=[age,func,func()]
print(l)
# 结果
[18, <function func at 0x101dd2ea0>, None]
```

**例子：**

```plain
def get():
    print('from get')
func_dic={
    'get':get
}
print(func_dic)
func_dic['get']()
```

**LowB 购物车**

```plain
def login():
    print('sigin')
def register():
    print('register')
def shopping():
    print('shopping')
def pay():
    print('pay')
msg="""
0 退出
1 登录
2 注册
3 购物
4 支付
"""
while True:
    print(msg)
    choice=input('请输入您的操作：').strip()
    if choice == '0':break
    if choice == '1':
        login()
    elif choice == '2':
        register()
    elif choice == '3':
        shopping()
    elif choice == '4':
        pay()
    else:
        print('输入错误指令，请重新输入')
        
## 这个代码，如果购物车功能有100个，要写100个判断？
```

---

| 使用函数对象，第4个特性 |
| :--- |

利用该特性 优雅的取代多分支的if

```plain
def login():
    print('sigin')
def register():
    print('register')
def shopping():
    print('shopping')
def pay():
    print('pay')
func_dic={
    '1':login,
    '2':register,
    '3':shopping,
    '4':pay
}
msg="""
0 退出
1 登录
2 注册
3 购物
4 支付
"""
while True:
    print(msg)
    choice=input('请输入您的操作：').strip()
    if choice == '0':break
    if choice in func_dic:
        func_dic[choice]()
    else:
        print('输入错误指令')
```

## 函数嵌套
函数的嵌套分为两大类：

**1.函数的嵌套调用**

在调用一个函数的过程中，函数内部代码有调用了其他函数

```plain
def max(x,y):
    return x if x > y else y
def max4(a,b,c,d):
    res1=max(a,b)
    res2=max(res1,c)
    res3=max(res2,d)
    return res3
print(max4(1,2,3,4))
```

**2.函数的嵌套定义**

在一个函数内部，又定义了另外一个函数或多个函数

```plain
def f1():
    def f2():
        def f3():
            print('from f3')
        f3()
    f2()
f1()
f3() #报错，为何？请看下一小节
```

函数在哪一级定义，就在哪一级调用

---

| 计算圆形 |
| :--- |

```plain
# 首先我们需要用到 π
from math import pi
print(pi)
def area(radius):
    return pi * (radius ** 2)
def perimeter(radius):
    return 2 * pi  * radius
```

如果这个写都和圆有关系，没必要定义两个函数

```plain
from math import pi
# print(pi)
def circle(radius,action=0):
    """
    圆形相关运算
    :param radius: 半径
    :param action: 0 代表求面积，1代表求周长
    :return: 面积或者周长
    """
    def area(radius):
        return pi * (radius ** 2)
    def perimeter(radius):
        return 2 * pi  * radius
    if action == 0:
        res=area(radius)
    elif action == 1:
        res=perimeter(radius)
    return res
print(circle(10,0))
print(circle(10,1))
```

<!-- OCR_START -->
- 圆形相关运算

```text
PYTHON
02函数嵌套.py
02函数嵌套
Project
01函数对象.py
02函数嵌套.py
PYTHON~/Desktop/PYTHON
from math import pi
01函数对象.py
#print(pi） 02函数嵌套.py lExternal Libraries Scratches and Consoles
def circle(radius,action=o):
param radius：半径
param action：代表求面积，1代表求周长
:return：面积或者周长
def area(radius):
return pi*（radius **2)
def perimeter(radius):
return2*pi*radius
if action==0:
2
elif action=11
res=perimeter（radius)
25
returnres
print(circle(10,0）) 28 print(circle（10.1）) Run:
02函数嵌套
314.1592653589793
62.83185307179586
Process finished with exit code 0
```
<!-- OCR_END -->

￼

## 名称空间与作用域
---

| 什么是名称空间 |
| :--- |

名称空间（namespace）：存放名字的地方，三种名称空间，（之前遗留的问题x=1，1存放于内存中，那名字x存放在哪里呢？名称空间正是存放名字x与1绑定关系的地方）

**名称空间分为三大类**

1.内置名称空间

2.全局名称空间

3.局部名称空间

---

| 名称空间的加载顺序 |
| :--- |

内置 -> 全局 -> 局部

python test.py

1、python解释器先启动，因而首先加载的是：内置名称空间

例：下面的几个功能，我们不需要定义就可以直接使用，因为python内置了

```plain
len
max
print
```

2、执行test.py文件，然后以文件为基础，加载全局名称空间

例：下面名字中 x、y、z、b、foo都存在 全局名称空间中

```plain
x=1
y=2
if x==1:
    z=3
while True:
    b=4
    break
    
def foo():
    m=3
```

3、在执行文件的过程中如果调用函数，则临时产生局部名称空间

例：foo内的m这个名字，一定是局部的。

```plain
x=1
y=2
if x==1:
    z=3
while True:
    b=4
    break
    
def foo():
    m=3
```

---

| 生命周期 |
| :--- |

内置名称空间：在解释器启动时则生效，解释器关闭则失效

全局名称空间：在解释器执行python文件时则生效，文件执行完毕后则失效

局部名称空间：只在调用函数时临时产生该函数的局部名称空间，该函数调用完成之后则失效（但是局部名称空间不一定都会生效，如果函数没有被调用，则不生效）

---

| 名字的查找顺序 |
| :--- |

```plain
局部名称空间--->全局名称空间--->内置名称空间
#需要注意的是：在全局无法查看局部的，在局部可以查看全局的，如下示例
# max=1
def f1():
    # max=2
    def f2():
        # max=3
        print(max)
    f2()
f1()
print(max)
# 例子1
x=111
def f1():
    x=222
    def f2():
        def f3():
            x=444
            print(x)
        x=333
        f3()
    f2()
f1()
结果 x=444
# 例子2
x=111
def f1():
    x=222
    def f2():
        def f3():
            #x=444
            print(x)
        x=333
        f3()
    f2()
f1()
结果 x=333
# 名字的查找顺序 ，在函数的定义阶段就已经固定死了，与函数的调用位置无关，也就是说，无论在任何地方调用函数，都必须回到当初定义函数的位置去确定名字的查找关系
## 例:下面代码，我们不能在outer函数外部直接调用inner，如何打破这个规则，直接在外部调用inner函数
x=111
def outer():
    def inner():
        print('from innser',x)
# 解决方案，我们把inner给return，返回inner函数的内存地址
x=111
def outer():
    def inner():
        print('from innser',x)
    return inner
f=outer()
f()
# 如此一来，我们就打破了函数的层级限制
# 那么问题来了，请问，下面代码，x是几？
x=111
def outer():
    def inner():
        print('from innser',x)
    return inner
f=outer()
x=222
f()
# 在一个函数内部，调用到另一个函数内部的函数
x=111
def outer():
    def inner():
        print('from innser',x)
    return inner
f=outer()
def func():
    f()
func()
# 问题又又来了，下面代码，x是几？
x=111
def outer():
    def inner():
        print('from innser',x)
    return inner
f=outer()
def func():
    x=333
    f()
func()
# 问题又又又来了，下面代码，x是几？
x=111
def outer():
    def inner():
        print('from innser',x)
    return inner
f=outer()
def func():
    x=333
    f()
func()
x=444
func()
```

---

| 作用域 |
| :--- |

**1.作用域即范围**

- 全局范围（内置名称空间与全局名称空间属于该范围）：全局存活，全局有效

- 局部范围（局部名称空间属于该范围）：临时存活，局部有效

**2.作用域关系是在函数定义阶段就已经固定的，与函数的调用位置无关，如下:**

```plain
x=1
def f1():
    def f2():
        print(x)
    return f2
x=100
def f3(func):
    x=2
    func()
x=10000
f3(f1())
```

**3.查看作用域：globals(),locals()**

```plain
LEGB 代表名字查找顺序: locals -> enclosing function -> globals -> __builtins__
locals 是函数内的名字空间，包括局部变量和形参
enclosing 外部嵌套函数的名字空间（闭包中常见）
globals 全局变量，函数定义所在模块的名字空间
builtins 内置模块的名字空间
# 下面代码x=1
x=1
def foo():
    x=2
foo()
print(x)
# 如果我使用global
x=1
def foo():
    global x
    x=2
foo()
print(x)
```

## 闭包函数
---

| 什么是闭包函数 |
| :--- |

闭：指的是闭包函数是一个定义在一个函数内部的函数

包：该内部去函数包含对外层函数作用域名字的引用

需要结合函数对象的概念，将闭包函数返回到全局作用域去使用，从而打破函数的层级限制

```plain
def outter():
    x=111
    def inner():
        print(x)
    return inner
f=outter()  #f=outer内部的inner函数
f()
```

---

| 模拟浏览器访问页面 |
| :--- |

```plain
# 安装requests模块
MacBook-pro:~ driverzeng$ pip3 install requests
```

```plain
# 爬百度
import requests
response=requests.get('https://www.baidu.com')
if response.status_code == 200:
    print(response.text.encode('utf-8'))
# 如果我现在还要爬京东呢？再复制一遍？
import requests
response=requests.get('https://www.baidu.com')
if response.status_code == 200:
    print(response.text.encode('utf-8'))
response=requests.get('https://www.jd.com')
if response.status_code == 200:
    print(response.text.encode('utf-8'))
    
# 太智障了吧，所以我们使用函数
import requests
def get(url):
    response=requests.get(url)
    if response.status_code == 200:
        print(response.text.encode('utf-8'))
get('http://www.baidu.com')
get('http://www.baidu.com')
get('http://www.jd.com')
# 高端解决方案，闭包
import requests
def outter(url):
    # url='https://www.baidu.com'
    def get():
        response = requests.get(url)
        if response.status_code == 200:
            print(response.text.encode('utf-8'))
    return get
baidu=outter('http://www.baidu.com')
baidu()
baidu()
baidu()
baidu()
jd=outter('http://www.jd.com')
jd()
jd()
jd()
jd()
```

<!-- OCR_START -->
PYTHON04闭包函数Py
04闭包函数
Project
01函数对象.py
02函数嵌套.py×
03名称空间与作用域.py
04闭包函数.py
PYTHON~/Desktop/PYTHON
101
import requests
113
def get（url):
14
response=requests.get（url)
15
IllExternal Libraries
200
Scratches and Consoles
17
18
19
get（'http://ww.baidu.com')
20
'http://
w.baidu.com')
21
et（'http://ww.jd.com)
23
def
outter(url):
.baidu.com'
25
def get():
26
27
.status
829
print（response.text.encode('utf-8')
return get
80
baidu=outter(*http://ww.baidu.com)
32
baidu(）
jd=outter（'https://ww.jd.com')
jdo
89
40
jd()
outter()
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/04闭包函数.py"
STATUSOK
<html>
d><meta
tf-8><meta http-equiv=X-UA-Compatible content=IE=Edge><meta content=always name=referrer><link rel=stylesheet type=te
b'<IDOCTYPE htm>\r\K！
→<html> <head><meta http-equiv=content-type content=text/html;charset=utf-8><meta http-equiv=X-UA-Compatible content=IE=Edge><meta content=always name=referrer><link rel=stylesheet type=te
b'<!DOCTYPE html>\r\n！
-STATUsOK-→<html><head><meta http-equiv=content-type
content=text/html;charset=utf-8><meta http-equiv=X-UA-Compatible content=IE=Edge><meta content=always name=referrer><linkrel=stylesheet
type=te
b'<!DOCTYPE
html>\r\ne!
content=text/html;charset=utf-8><meta http-equiv=x-UA-Compatiblec
content=IE=Edge><meta content=always name=referrer><link rel=stylesheet
<meta charset="utf8"
version=/\/>\n
<title>1xe4xba\xac\xe4xb8\x9c（JD.coM)-1xe6xadxa3\xe51x93\x81\xe41xbd\x8e\xe41xbb\xb7\xe3\x80\x81\xe51x93\x81\xe8xb4\xa8\xe41xbf\xd\xe9)
b'<!DOCTYPEhtml>\n<html>\n\n<head>\n
<meta charset="utf8”version=\’1\′/>\n
<title>1xe4\xba1xac\xe4\xb8\x9c(JD.c0M)-1xe6\xad\xa3\xe5\x93\x81\xe4\xbd\x8e\xe4\xbb\xb7\xe31x80\x81\xe51x93\x81\xe8\xb4\xa8\xe4\xbf\x9d\xe9)
Process finished with exit code0
<!-- OCR_END -->

￼

但是我们每次都还要传递参数，有没有什么方法不用传参？默认参数，全局变量都麻烦

---

| 为何要用闭包函数 |
| :--- |

所以此时我们要用到 闭包函数，闭包函数提供了 一种为函数体传值的解决方案。

```plain
#内部函数包含对外部作用域而非全局作用域的引用
#提示：之前我们都是通过参数将外部的值传给函数，闭包提供了另外一种思路，包起来喽，包起呦，包起来哇
        def counter():
            n=0
            def incr():
                nonlocal n
                x=n
                n+=1
                return x
            return incr
        c=counter()
        print(c())
        print(c())
        print(c())
        print(c.__closure__[0].cell_contents) #查看闭包的元素
```

---

| 如何使用闭包函数 |
| :--- |

```plain
#闭包的意义：返回的函数对象，不仅仅是一个函数对象，在该函数外还包裹了一层作用域，这使得，该函数无论在何处调用，优先使用自己外层包裹的作用域
#应用领域：延迟计算（原来我们是传参，现在我们是包起来）
    from urllib.request import urlopen
    def index(url):
        def get():
            return urlopen(url).read()
        return get
    baidu=index('http://www.baidu.com')
    print(baidu().decode('utf-8'))
```

> 更新: 2020-06-25 10:48:39  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/susuuq>