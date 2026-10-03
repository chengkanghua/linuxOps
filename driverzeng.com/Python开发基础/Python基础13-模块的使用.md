# Python基础13-模块的使用

## Python基础13-模块的使用
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(3) 评论(0)

+ [模块介绍](https://blog.driverzeng.com/zenglaoshi/5314.html#toc_0)
+ [模块的循环导入](https://blog.driverzeng.com/zenglaoshi/5314.html#toc_1)
+ [区分python文件的两种用途](https://blog.driverzeng.com/zenglaoshi/5314.html#toc_2)
+ [模块的搜索路径](https://blog.driverzeng.com/zenglaoshi/5314.html#toc_3)
+ [软件开发的目录规范](https://blog.driverzeng.com/zenglaoshi/5314.html#toc_4)

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

## 模块介绍
---

| 什么是模块？ |
| :--- |

模块就是一系列功能的集合体

**例如：os模块**

```plain
import os
os.chmod()
os.chown()
```

**模块有三种来源：**

```plain
1.内置模块
2.第三方模块
3.自定义模块
```

**模块的格式**

```plain
# 常见的场景：一个模块就是一个包含了一组功能的python文件
# 比如spam.py，模块名为spam，可以通过import spam使用。
# 在python中，模块的使用方式都是一样的，但其实细说的话，模块可以分为四个通用类别：　
1.使用python编写的.py文件
2.已被编译为共享库或DLL的C或C++扩展
3.把一系列模块组织到一起的文件夹（注：文件夹下有一个__init__.py文件，该文件夹称之为包）
4.使用C编写并链接到python解释器的内置模块
```

---

| 为什么要使用模块？ |
| :--- |

1.使用内置的或者第三方模块的好处是: 拿来主义,可以极大提升开发效率

2.使用自定义模块的好处是: 可以减少代码冗余(抽取我们自己程序中要公用的一些功能定义成模块,然后程序的各部分组件都去模块中调用共享的功能)

```plain
#1、从文件级别组织程序，更方便管理
随着程序的发展，功能越来越多，为了方便管理，我们通常将程序分成一个个的文件，这样做程序的结构更清晰，方便管理。这时我们不仅仅可以把这些文件当做脚本去执行，还可以把他们当做模块来导入到其他的模块中，实现了功能的重复利用
#2、拿来主义，提升开发效率
同样的原理，我们也可以下载别人写好的模块然后导入到自己的项目中使用，这种拿来主义，可以极大地提升我们的开发效率
#ps：
如果你退出python解释器然后重新进入，那么你之前定义的函数或者变量都将丢失，因此我们通常将程序写到文件中以便永久保存下来，需要时就通过python test.py方式去执行，此时test.py被称为脚本script。
```

---

| 如何使用模块？ |
| :--- |

一定要区分开，谁是执行文件，谁是被导入文件

举个栗子：创建两个文件 run.py（执行的文件） 和 spam.py（要导入的文件）

```plain
# spam.py
print('from the spam.py')
money=1000
def read1():
    print('spam模块：',money)
def read2():
    print('spam模块')
    read1()
def change():
    global money
    money=0
```

```plain
# run.py
import spam
```

<!-- OCR_START -->
- 模块名是
- 曾老湿

```text
05模块的使用.py
01模块.py
run.py
spam.py
文件名是spam.py
spam
import spam
Run:
run x
from the spam.py
ocess finished with exit code 0
DriverZeng
```
<!-- OCR_END -->

￼

首次导入模块会发生哪些事？

1.会产生一个模块的名称空间

2.执行文件spam.py将执行过程中昌盛的名字都放到模块的名称空间中

3.在当前执行文件的名称空间中拿到一个模块名，该名字指向模块的名称空间

<!-- OCR_START -->
- spam.py的名称空间
- run.py的名称空间
- money”：1000的内存地址
- X：1的内存地址
- read1：readl函数的内存地址
- ’spam’:spam.py的名称空间地址
- change：change函数的内存也址
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿

```text
PYTHON[~/Desktop/P PYTHON run.py 05模块的使用.pyx
01模块.py
spam.py
#文件名是spam.py，模块名是spam
importspam
import spam
Run:
run x
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/run.py
from the spam.py
Process finished with exit code O
DriverZeng
```
<!-- OCR_END -->

￼

多次导入没有太大用处，因为之后导入都是直接引用第一次导入的结果（指向之前的内存地址）

在执行文件中，访问模块名称空间的语法：模块名.名字

<!-- OCR_START -->
- PYTHON
- run.py
- 05模块的使用.pyx
- 01模块.pyx
- spam.pyx
- #文件名是spam.py，模块名是spam
- 2
- import spam
- 3
- 4
- spam
- 5
- change()
- 6
- money
- read1()
- read2（）
- if
- if expr
- ifn
- if expr is None
- ifnn
- if expr is not None
- main
- name
- main_':expr
- not
- not expr
- par
- (expr)
- print
- print(expr)
- 曾老湿
- MA+IIMn
- Driver Zeng
- Press .to choose the selected (or first) suggestion and inserta dot afterwards ≥π
<!-- OCR_END -->

￼

```plain
# 文件名是spam.py ，模块名是 spam
import spam
print(spam.money)
print(spam.read1)
print(spam.read2)
print(spam.change)
```

**import导入模块总结：**

在使用时必须加上前缀：模块名

优点：指名道姓的向某一个名称空间要名字，肯定不会与当前名称空间名字冲突

缺点：但凡应用模块中的名字都要加前缀，不够简洁

---

| 导入多个模块 |
| :--- |

```plain
# 不推荐
import spam,os,time
# 推荐
import spam
import os
import time
## 可以给模块起别名
import spam as sm
print('sm.money')
print('sm.read1')
```

---

| 不加前缀使用模块 |
| :--- |

同样创建两个文件 run.py 和 spam.py

首次导入模块会发生哪些事？

1.会产生一个模块的名称空间

2.执行文件spam.py将执行过程中昌盛的名字都放到模块的名称空间中

3.在当前执行文件中直接拿到一个名字,该名字就是执行模块中相对应的名字的

<!-- OCR_START -->
- spam.py的名称空间
- run.py的名称空间
- money”：1000的内存地址
- read1”：readl函数的内存地士
- money’:spam.py中money
- money’：200的内存地址
- read2”：read2函数的内存地
- change：change函数的内存也址
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
# spam.py
print('from the spam.py')
money=1000
def read1():
    print('spam模块：',money)
def read2():
    print('spam模块')
    read1()
def change():
    global money
    money=0
```

```plain
# run.py
from spam import money
print(money)
```

<!-- OCR_START -->
- 曾老湿

```text
05模块的使用.pyx
01模块.py
run.py
spam.py
#文件名是spam.py，模块名是spam
fromspam importmoney
print(money)
Run:
run x
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/run.py
from the spam.py
1000
Process finished with exit code o
Driver Zeng
```
<!-- OCR_END -->

￼

**总结from...import...**

优点: 使用时,无需再加前缀,更简洁

缺点: 容易与当前名称空间中的名字冲突

**批量导入**

```plain
# 把所有名字写出来导入
from spam import money,read1,read2,change
print(money)
print(read1)
print(read2)
print(change)
# *代表从被导入模块中拿到所有名字（不推荐使用）
from spam import *
print(money)
print(read1)
print(read2)
print(change)
# 自己控制*都有哪些模块
__all__ = ['money','read1']
from spam import * # __all__ = ['money','read1']
print(money)
print(read1)
print(read2)
print(change)
# 起别名
from spam import read1 as r1
r1()
```

## 模块的循环导入
模块循环/嵌套导入抛出异常的根本原因是由于在python中模块被导入一次之后，就不会重新导入，只会在第一次导入时执行模块内代码

在我们的项目中应该尽量避免出现循环/嵌套导入，如果出现多个模块都需要共享的数据，可以将共享的数据集中存放到某一个地方

在程序出现了循环/嵌套导入后的异常分析、解决方法如下

```plain
#示范文件内容如下
#m1.py
print('正在导入m1')
from m2 import y
x='m1'
#m2.py
print('正在导入m2')
from m1 import x
y='m2'
#run.py
import m1
#测试一
执行run.py会抛出异常
正在导入m1
正在导入m2
Traceback (most recent call last):
  File "/Users/linhaifeng/PycharmProjects/pro01/1 aaaa练习目录/aa.py", line 1, in <module>
    import m1
  File "/Users/linhaifeng/PycharmProjects/pro01/1 aaaa练习目录/m1.py", line 2, in <module>
    from m2 import y
  File "/Users/linhaifeng/PycharmProjects/pro01/1 aaaa练习目录/m2.py", line 2, in <module>
    from m1 import x
ImportError: cannot import name 'x'
#测试一结果分析
先执行run.py--->执行import m1，开始导入m1并运行其内部代码--->打印内容"正在导入m1"
--->执行from m2 import y 开始导入m2并运行其内部代码--->打印内容“正在导入m2”--->执行from m1 import x,由于m1已经被导入过了，所以不会重新导入，所以直接去m1中拿x，然而x此时并没有存在于m1中，所以报错
#测试二:执行文件不等于导入文件，比如执行m1.py不等于导入了m1
直接执行m1.py抛出异常
正在导入m1
正在导入m2
正在导入m1
Traceback (most recent call last):
  File "/Users/Driverzeng/PycharmProjects/pro01/1 aaaa练习目录/m1.py", line 2, in <module>
    from m2 import y
  File "/Users/Driverzeng/PycharmProjects/pro01/1 aaaa练习目录/m2.py", line 2, in <module>
    from m1 import x
  File "/Users/Driverzeng/PycharmProjects/pro01/1 aaaa练习目录/m1.py", line 2, in <module>
    from m2 import y
ImportError: cannot import name 'y'
#测试二分析
执行m1.py，打印“正在导入m1”，执行from m2 import y ，导入m2进而执行m2.py内部代码--->打印"正在导入m2"，执行from m1 import x，此时m1是第一次被导入，执行m1.py并不等于导入了m1，于是开始导入m1并执行其内部代码--->打印"正在导入m1"，执行from m1 import y，由于m1已经被导入过了，所以无需继续导入而直接问m2要y，然而y此时并没有存在于m2中所以报错
# 解决方法:
## 方法一:导入语句放到最后
#m1.py
print('正在导入m1')
x='m1'
from m2 import y
#m2.py
print('正在导入m2')
y='m2'
from m1 import x
## 方法二:导入语句放到函数中
#m1.py
print('正在导入m1')
def f1():
    from m2 import y
    print(x,y)
x = 'm1'
# f1()
#m2.py
print('正在导入m2')
def f2():
    from m1 import x
    print(x,y)
y = 'm2'
#run.py
import m1
m1.f1()
```

## 区分python文件的两种用途
```plain
编写好的一个python文件可以有两种用途：
    一：脚本，一个文件就是整个程序，用来被执行
    二：模块，文件中存放着一堆功能，用来被导入使用
python为我们内置了全局变量__name__，
    当文件被当做脚本执行时：__name__ 等于'__main__'
    当文件被当做模块导入时：__name__等于模块名
作用：用来控制.py文件在不同的应用场景下执行不同的逻辑
    if __name__ == '__main__':
```

```plain
#fib.py
def fib(n):    # write Fibonacci series up to n
    a, b = 0, 1
    while b < n:
        print(b, end=' ')
        a, b = b, a+b
    print()
def fib2(n):   # return Fibonacci series up to n
    result = []
    a, b = 0, 1
    while b < n:
        result.append(b)
        a, b = b, a+b
    return result
if __name__ == "__main__":
    import sys
    fib(int(sys.argv[1]))
#执行：python fib.py <arguments>
python fib.py 50 #在命令行
```

## 模块的搜索路径
**模块搜索路径的优先级：**

1.内存中已经加载过的

2.内置模块

3.sys.path //第一个值是当前执行文件所在的文件夹

<!-- OCR_START -->
- 曾老湿

```text
05模块的使用.py
Users...run.py
run.py
Project
PYTHON~/Desktop/PYTHON
print(sys.path)
01内置函数.py
01函数对象.py
01装饰器.py
02函数嵌套.py
02函数的递归调用.py
orks/Python.framework/Versions/3.6/lib/python3.6','/Library/Frar
rocessfinished with exitcode0
```
<!-- OCR_END -->

￼

```plain
#模块的查找顺序
1、在第一次导入某个模块时（比如spam），会先检查该模块是否已经被加载到内存中（当前执行文件的名称空间对应的内存），如果有则直接引用
    ps：python解释器在启动时会自动加载一些模块到内存中，可以使用sys.modules查看
2、如果没有，解释器则会查找同名的内建模块
3、如果还没有找到就从sys.path给出的目录列表中依次寻找spam.py文件。
#sys.path的初始化的值来自于：
The directory containing the input script (or the current directory when no file is specified).
PYTHONPATH (a list of directory names, with the same syntax as the shell variable PATH).
The installation-dependent default.
#需要特别注意的是：我们自定义的模块名不应该与系统内置模块重名。虽然每次都说，但是仍然会有人不停的犯错。 
#在初始化后，python程序可以修改sys.path,路径放到前面的优先于标准库被加载。
1 >>> import sys
2 >>> sys.path.append('/a/b/c/d')
3 >>> sys.path.insert(0,'/x/y/z') #排在前的目录，优先被搜索
注意：搜索时按照sys.path中从左到右的顺序查找，位于前的优先被查找，sys.path中还可能包含.zip归档文件和.egg文件，python会把.zip归档文件当成一个目录去处理，
# 解决方法二
from dir1.dir2 import m1
#首先制作归档文件：zip module.zip foo.py bar.py 
import sys
sys.path.append('module.zip')
import foo,bar
#也可以使用zip中目录结构的具体位置
sys.path.append('module.zip/lib/python')
#windows下的路径不加r开头，会语法错误
sys.path.insert(0,r'C:\Users\Administrator\PycharmProjects\a')
 
#至于.egg文件是由setuptools创建的包，这是按照第三方python库和扩展时使用的一种常见格式，.egg文件实际上只是添加了额外元数据(如版本号，依赖项等)的.zip文件。
#需要强调的一点是：只能从.zip文件中导入.py，.pyc等文件。使用C编写的共享库和扩展块无法直接从.zip文件中加载（此时setuptools等打包系统有时能提供一种规避方法），且从.zip中加载文件不会创建.pyc或者.pyo文件，因此一定要事先创建他们，来避免加载模块是性能下降。
```

[官网解释](https://docs.python.org/3/tutorial/modules.html#the-module-search-path)

```plain
搜索路径：
当一个命名为spam的模块被导入时
    解释器首先会从内建模块中寻找该名字
    找不到，则去sys.path中找该名字
sys.path从以下位置初始化
    1 执行文件所在的当前目录
    2 PTYHONPATH（包含一系列目录名，与shell变量PATH语法一样）
    3 依赖安装时默认指定的
注意：在支持软连接的文件系统中，执行脚本所在的目录是在软连接之后被计算的，换句话说，包含软连接的目录不会被添加到模块的搜索路径中
在初始化后，我们也可以在python程序中修改sys.path,执行文件所在的路径默认是sys.path的第一个目录，在所有标准库路径的前面。这意味着，当前目录是优先于标准库目录的，需要强调的是：我们自定义的模块名不要跟python标准库的模块名重复，除非你是故意的，傻叉。
```

## 软件开发的目录规范

<!-- OCR_START -->
- 曾老湿

```text
·ATM
bin
start.py
conf
settings.py
core
src.py
db
common.py
1log
transaction.py
Driver Zeng
adme
```
<!-- OCR_END -->

￼

导入模块方法，不能把路径写死：

start.py

```plain
import sys
import os
BASE_DIR=os.path.dirname(os.path.dirname(__file__))
sys.path.append(BASE_DIR)
from core import src
if __name__ == '__main__':
    src.run()
```

settings.py

```plain
import os
BASE_DIR=os.path.dirname(os.path.dirname(__file__))
LOG_PATH=r'%s\log\transaction.log' %BASE_DIR
```

src.py

```plain
from lib import common
def register():
    print('\033[45m注册\033[0m')
def login():
    print('\033[44m登录\033[0m')
def shopping():
    print('\033[43m购物\033[0m')
def pay():
    print('\033[42m支付\033[0m')
def transfer():
    print('\033[41m转账\033[0m')
    common.logger('zls给qls转了1个亿')
func_dic={
    '1':register,
    '2':login,
    '3':shopping,
    '4':pay,
    '5':transfer
}
def run():
    while True:
        print("""
        0 退出
        1 注册
        2 登录
        3 购物
        4 支付
        5 转账
        """)
        choice=input('请输入您的操作: ').strip()
        if choice == '0':break
        if choice not in func_dic:
            print('输入错误指令')
            continue
        func_dic[choice]()
```

common.py

```plain
from conf import settings
import time
def logger(msg):
    with open(settings.LOG_PATH,'at',encoding='utf-8') as f:
        f.write('%s %s\n' %(time.strftime('%Y-%m-%d %H:%M:%S %p'),msg))
```

> 更新: 2020-06-25 10:55:25  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/tfnzzg>