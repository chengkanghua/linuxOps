# Python基础14-内置模块

## Python基础14-内置模块
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(5) 评论(0)

+ [包介绍](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_0)
+ [包的使用](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_1)
+ [time模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_2)
+ [datetime模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_3)
+ [random模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_4)
+ [sys模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_5)
+ [shutil模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_6)
+ [os模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_7)
+ [Json模块&pickle模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_8)
+ [hashlib模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_9)
+ [xml模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_10)
+ [configparser模块](https://blog.driverzeng.com/zenglaoshi/5323.html#toc_11)

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

## 包介绍
---

| 什么是包 |
| :--- |

**官网解释**

Packages are a way of structuring Python’s module namespace by using “dotted module names”

包是一种通过使用‘.模块名’来组织python模块名称空间的方式。

**具体的：**包就是一个包含有__init__.py文件的文件夹，所以其实我们创建包的目的就是为了用文件夹将文件/模块组织起来

**需要强调的是：**

1.在python3中，即使包下没有__init__.py文件，import 包仍然不会报错，而在python2中，包下一定要有该文件，否则import 包报错

2.创建包的目的不是为了运行，而是被导入使用，记住，包只是模块的一种形式而已，包的本质就是一种模块

---

| 为什么要使用包 |
| :--- |

包的本质就是一个文件夹，那么文件夹唯一的功能就是将文件组织起来

随着功能越写越多，我们无法将所以功能都放到一个文件中，于是我们使用模块去组织功能，而随着模块越来越多，我们就需要用文件夹将模块文件组织起来，以此来提高程序的结构性和可维护性

>  
>
> 注意：
>
> 1.关于包相关的导入语句也分为import和from ... import ...两种，但是无论哪种，无论在什么位置，在导入时都必须遵循一个原则：凡是在导入时带点的，点的左边都必须是一个包，否则非法。可以带有一连串的点，如item.subitem.subsubitem,但都必须遵循这个原则。但对于导入后，在使用时就没有这种限制了，点的左边可以是包,模块，函数，类(它们都可以用点的方式调用自己的属性)。
>
> 2.import导入文件时，产生名称空间中的名字来源于文件，import 包，产生的名称空间的名字同样来源于文件，即包下的__init__.py，导入包本质就是在导入该文件
>
> 3.包A和包B下有同名模块也不会冲突，如A.a与B.a来自俩个命名空间
>

---

| 练习 |
| :--- |

```plain
1 实验一
    准备：
        执行文件为test.py，内容
        #test.py
        import aaa
        同级目录下创建目录aaa,然后自建空__init__.py(或者干脆建包)
    需求：验证导入包就是在导入包下的__init__.py
    解决：
        先执行看结果
        再在__init__.py添加打印信息后，重新执行
2、实验二
    准备：基于上面的结果
    需求：
        aaa.x
        aaa.y
    解决：在__init__.py中定义名字x和y
3、实验三
    准备：在aaa下建立m1.py和m2.py
        #m1.py
        def f1():
            print('from 1')
        #m2.py
        def f2():
            print('from 2')
    需求：
        aaa.m1 #进而aaa.m1.func1()
        aaa.m2 #进而aaa.m2.func2()
    解决：在__init__.py中定义名字m1和m2,先定义一个普通变量，再引出如何导入模块名，强调:环境变量是以执行文件为准
    
4、实验四
    准备：在aaa下新建包bbb
    需求：
        aaa.bbb
    解决：在aaa的__init__.py内导入名字bbb
5、实验五
    准备：
        在bbb下建立模块m3.py
        #m3.py
        def f3():
            print('from 3')
    需求：
        aaa.bbb.m3 #进而aaa.bbb.m3.f3()
    解决：是bbb下的名字m3，因而要在bbb的__init__.py文件中导入名字m3，from aaa.bbb import m3
6、实验六
    准备：基于上面的结果
    需求:
        aaa.m1()
        aaa.m2()
        aaa.m3()
        进而实现
        aaa.f1()
        aaa.f2()
        aaa.f3()
        先用绝对导入，再用相对导入
        
    解决：在aaa的__init__.py中拿到名字m1、m2、m3
    包内模块直接的相对导入，强调包的本质：包内的模块是用来被导入的，而不是被执行的
    用户无法区分模块是文件还是一个包，我们定义包是为了方便开发者维护
7、实验七
    将包整理当做一个模块，移动到别的目录下，操作sys.path
```

## 包的使用
---

| 示范文件 |
| :--- |

```plain
glance/                   #Top-level package
├── __init__.py      #Initialize the glance package
├── api                  #Subpackage for api
│   ├── __init__.py
│   ├── policy.py
│   └── versions.py
├── cmd                #Subpackage for cmd
│   ├── __init__.py
│   └── manage.py
└── db                  #Subpackage for db
    ├── __init__.py
    └── models.py
```

```plain
#文件内容
#policy.py
def get():
    print('from policy.py')
#versions.py
def create_resource(conf):
    print('from version.py: ',conf)
#manage.py
def main():
    print('from manage.py')
#models.py
def register_models(engine):
    print('from models.py: ',engine)
包所包含的文件内容
```

执行文件与示范文件在同级目录下

---

| import 包 |
| :--- |

```plain
import glance.db.models
glance.db.models.register_models('mysql')
```

单独导入包名称时不会导入包中所有包含的所有子模块，如

```plain
#在与glance同级的test.py中
import glance
glance.cmd.manage.main()
'''
执行结果：
AttributeError: module 'glance' has no attribute 'cmd'
'''
```

解决方法：

```plain
#glance/__init__.py
from . import cmd
#glance/cmd/__init__.py
from . import manage
```

执行：

```plain
#在于glance同级的test.py中
import glance
glance.cmd.manage.main()
```

---

| from ... import ... 包 |
| :--- |

需要注意的是from后import导入的模块，必须是明确的一个不能带点，否则会有语法错误，如：from a import b.c是错误语法

```plain
from glance.db import models
models.register_models('mysql')
from glance.db.models import register_models
register_models('mysql')
```

---

| from glance.api import |
| :--- |

```plain
在讲模块时，我们已经讨论过了从一个模块内导入所有*，此处我们研究从一个包导入所有*。
此处是想从包api中导入所有，实际上该语句只会导入包api下__init__.py文件中定义的名字，我们可以在这个文件中定义__all___:
```

```plain
#在__init__.py中定义
x=10
def func():
    print('from api.__init.py')
__all__=['x','func','policy']
```

此时我们在于glance同级的文件中执行from glance.api import *就导入__all__中的内容（versions仍然不能导入）。

**小练习：**

```plain
#执行文件中的使用效果如下，请处理好包的导入
from glance import *
get()
create_resource('a.conf')
main()
register_models('mysql')
```

```plain
#在glance.__init__.py中
from .api.policy import get
from .api.versions import create_resource
from .cmd.manage import main
from .db.models import  register_models
__all__=['get','create_resource','main','register_models']
```

---

| 绝对导入和相对导入 |
| :--- |

我们的最顶级包glance是写给别人用的，然后在glance包内部也会有彼此之间互相导入的需求，这时候就有绝对导入和相对导入两种方式：

绝对导入：以glance作为起始

相对导入：用.或者..的方式最为起始（只能在一个包中使用，不能用于不同目录内）

例如：我们在glance/api/version.py中想要导入glance/cmd/manage.py

```plain
在glance/api/version.py
#绝对导入
from glance.cmd import manage
manage.main()
#相对导入
from ..cmd import manage
manage.main()
```

测试结果：注意一定要在于glance同级的文件中测试

```plain
from glance.api import versions
```

**包以及包所包含的模块都是用来被导入的，而不是被直接执行的。而环境变量都是以执行文件为准的**

比如我们想在glance/api/versions.py中导入glance/api/policy.py，有的同学一抽这俩模块是在同一个目录下，十分开心的就去做了，它直接这么做

```plain
#在version.py中
import policy
policy.get()
```

没错，我们单独运行version.py是一点问题没有的，运行version.py的路径搜索就是从当前路径开始的，于是在导入policy时能在当前目录下找到

但是你想啊，你子包中的模块version.py极有可能是被一个glance包同一级别的其他文件导入，比如我们在于glance同级下的一个test.py文件中导入version.py，如下

```plain
from glance.api import versions
'''
执行结果:
ImportError: No module named 'policy'
'''
'''
分析:
此时我们导入versions在versions.py中执行
import policy需要找从sys.path也就是从当前目录找policy.py,
这必然是找不到的
'''
```

**绝对导入与相对导入总结**

```plain
绝对导入与相对导入
# 绝对导入: 以执行文件的sys.path为起始点开始导入,称之为绝对导入
#        优点: 执行文件与被导入的模块中都可以使用
#        缺点: 所有导入都是以sys.path为起始点,导入麻烦
# 相对导入: 参照当前所在文件的文件夹为起始开始查找,称之为相对导入
#        符号: .代表当前所在文件的文件加,..代表上一级文件夹,...代表上一级的上一级文件夹
#        优点: 导入更加简单
#        缺点: 只能在导入包中的模块时才能使用
　　　　  #注意:
　　　　　　　　1. 相对导入只能用于包内部模块之间的相互导入,导入者与被导入者都必须存在于一个包内
　　　　　　　　2. attempted relative import beyond top-level package # 试图在顶级包之外使用相对导入是错误的,言外之意,必须在顶级包内使用相对导入,每增加一个.代表跳到上一级文件夹,而上一级不应该超出顶级包
```

## time模块
---

| time模块介绍 |
| :--- |

与时间相关的功能模块

在Python中，时间分为3种：

1.时间戳 timestamp 从1970 1 月 1日 到先在的秒数 主要用于计算两个时间的差

2.localtime 本地时间 表示的是计算机当前系统时间

3.UTC 世界协调时间

时间戳 结构化 格式化字符

---

| time模块使用 |
| :--- |

```plain
import time
# 获取时间戳  返回浮点型
print(time.time())
# 获取当地时间   返回的是结构化时间
print(time.localtime())
#  获取UTC时间 返回的还是结构化时间  比中国时间少8小时
print(time.gmtime())
# 将获取的时间转成我们期望的格式 仅支持结构化时间
print(time.strftime("%Y-%m-%d %H:%M:%S",time.localtime()))
# 将格式化字符串的时间转为结构化时间  注意 格式必须匹配
print(time.strptime("2016-09-09 09:01:22","%Y-%m-%d %H:%M:%S"))
# 时间戳 转结构化
print(time.localtime(time.time()))
# 结构化转 时间戳
print(time.mktime(time.localtime()))
# sleep 让当前进程睡眠一段时间 单位是秒
time.sleep(2)
print("over")
# 不太常用的时间格式
print(time.asctime())
print(time.ctime())
```

## datetime模块
---

| datetime模块介绍 |
| :--- |

python实现的一个时间处理模块

time 用起来不太方便 所以就有了datetme

总结 datetime相比time 更灵活 更本土化

timedelta表示时间差

1.两个时间差可以 +-*/

2.时间差和datetime 可以+-

其中计算机认识的时间只能是'时间戳'格式，而程序员可处理的或者说人类能看懂的时间有: '格式化的时间字符串'，'结构化的时间' ，于是有了下图的转换关系

<!-- OCR_START -->
- 结构化的时间
- struct_time
- localtime
- strftime
- gmtime
- strptime
- mktime
- 格式化的字符串时间
- 时间戳
- ing
- 图1
- Timestamp
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

格式化时间格式

```plain
%a    Locale’s abbreviated weekday name.     
%A    Locale’s full weekday name.     
%b    Locale’s abbreviated month name.     
%B    Locale’s full month name.     
%c    Locale’s appropriate date and time representation.     
%d    Day of the month as a decimal number [01,31].     
%H    Hour (24-hour clock) as a decimal number [00,23].     
%I    Hour (12-hour clock) as a decimal number [01,12].     
%j    Day of the year as a decimal number [001,366].     
%m    Month as a decimal number [01,12].     
%M    Minute as a decimal number [00,59].     
%p    Locale’s equivalent of either AM or PM.    (1)
%S    Second as a decimal number [00,61].    (2)
%U    Week number of the year (Sunday as the first day of the week) as a decimal number [00,53]. All days in a new year preceding the first Sunday are considered to be in week 0.    (3)
%w    Weekday as a decimal number [0(Sunday),6].     
%W    Week number of the year (Monday as the first day of the week) as a decimal number [00,53]. All days in a new year preceding the first Monday are considered to be in week 0.    (3)
%x    Locale’s appropriate date representation.     
%X    Locale’s appropriate time representation.     
%y    Year without century as a decimal number [00,99].     
%Y    Year with century as a decimal number.     
%z    Time zone offset indicating a positive or negative time difference from UTC/GMT of the form +HHMM or -HHMM, where H represents decimal hour digits and M represents decimal minute digits [-23:59, +23:59].     
%Z    Time zone name (no characters if no time zone exists).     
%%    A literal '%' character.
```

<!-- OCR_START -->
- %a%b%d%H%M%S%Y串
- asctime
- ctime
- 结构化的时间
- 时间戳
- structtime
- 图2
- Timestamp
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| datetime模块使用 |
| :--- |

```plain
import datetime
# 获取时间 获取当前时间 并且返回的是格式化字符时间
print(datetime.datetime.now())
# 单独获取某个时间 年 月
d = datetime.datetime.now()
print(d.year)
print(d.day)
# 手动指定时间
d2 = datetime.datetime(2016,8,9,9,50,00)
print(d2)
# 计算两个时间的差  只能- 不能加+
print(d - d2)
# 替换某个时间
print(d.replace(year=2060))
# 表示时间差的模块 timedelta
print(datetime.timedelta(days=1))
t1 = datetime.timedelta(days=1)
t2 = datetime.timedelta(weeks=1)
print(t2 - t1)
# 时间差可以和一个datetime进行加减
print(d + t2)
#时间加减
import datetime
# print(datetime.datetime.now()) #返回 2016-08-19 12:47:03.941925
#print(datetime.date.fromtimestamp(time.time()) )  # 时间戳直接转成日期格式 2016-08-19
# print(datetime.datetime.now() )
# print(datetime.datetime.now() + datetime.timedelta(3)) #当前时间+3天
# print(datetime.datetime.now() + datetime.timedelta(-3)) #当前时间-3天
# print(datetime.datetime.now() + datetime.timedelta(hours=3)) #当前时间+3小时
# print(datetime.datetime.now() + datetime.timedelta(minutes=30)) #当前时间+30分
#
# c_time  = datetime.datetime.now()
# print(c_time.replace(minute=3,hour=2)) #时间替换
datetime模块
```

## random模块
---

| random模块介绍 |
| :--- |

**random 随机数相关模块**

1.random 0-1 开闭

2.randint 0 - 3 开开

3.randrange 0 - 3 开闭

4.choice [1,2,32,3,2,"哈哈"] 随机选⼀个

6.uniform(1,3) 闭闭 浮点

7.shuffle(列表) 打乱顺序

---

| random使用 |
| :--- |

```plain
import random
# 0 - 1 随机浮点 不包含1
print(random.random())
# 随机的整数，顾头也顾腚
print(random.randint(1,100))
# 随机的整数，顾头不顾腚
print(random.randrange(1,3))
# 随机从列表取数据，顾头也顾腚
print(random.choices((1,2,3)))
# 随机从列表中取数据，取两个
print(random.sample([1,2,3],2))
# 随机播放...打乱顺序
l = [1,2,3,4,5]
print(random.shuffle(l))
print(l)
# 随机介于1-2之间的小数，顾头不顾腚
print(random.uniform(1,2))
# 生成验证码 整形和字符(全大写)随机组成  可以指定长度
def make_code(i):
    res = ""
    for j in range(i):
#         随机0到9
        num = str(random.randint(0,9))
        c = chr(random.randint(65,90))
        s = random.choice([num,c])
        res += s
    return res
print(make_code(4))
```

## sys模块
---

| sys模块介绍 |
| :--- |

系统相关模块

一般用于设计脚本程序

常用方法

argv 获取cmd输入的参数

---

| sys模块使用 |
| :--- |

```plain
1 sys.argv           命令行参数List，第一个元素是程序本身路径
2 sys.exit(n)        退出程序，正常退出时exit(0)
3 sys.version        获取Python解释程序的版本信息
4 sys.maxint         最大的Int值
5 sys.path           返回模块的搜索路径，初始化时使用PYTHONPATH环境变量的值
6 sys.platform       返回操作系统平台名称
import sys
print(sys.argv)
print(sys.platform)
print(sys.exit(0))
```

---

| 实现进度条 |
| :--- |

```plain
#=========知识储备==========
#进度条的效果
[#             ]
[##            ]
[###           ]
[####          ]
#指定宽度
print('[%-15s]' %'#')
print('[%-15s]' %'##')
print('[%-15s]' %'###')
print('[%-15s]' %'####')
#打印%
print('%s%%' %(100)) #第二个%号代表取消第一个%的特殊意义
#可传参来控制宽度
print('[%%-%ds]' %50) #[%-50s]
print(('[%%-%ds]' %50) %'#')
print(('[%%-%ds]' %50) %'##')
print(('[%%-%ds]' %50) %'###')
#=========实现打印进度条函数==========
import sys
import time
def progress(percent,width=50):
    if percent >= 1:
        percent=1
    show_str=('[%%-%ds]' %width) %(int(width*percent)*'#')
    print('\r%s %d%%' %(show_str,int(100*percent)),file=sys.stdout,flush=True,end='')
#=========应用==========
data_size=1025
recv_size=0
while recv_size < data_size:
    time.sleep(0.1) #模拟数据的传输延迟
    recv_size+=1024 #每次收1024
    percent=recv_size/data_size #接收的比例
    progress(percent,width=70) #进度条的宽度70
```

实现过程

```plain
# 版本一
print("[*          ]")
print("[**         ]")
# 版本二
print("[%-10s]" % ("*" * 1))
print("[%-10s]" % ("*" * 2))
print("[%-10s]" % ("*" * 3))
print("[%-10s]" % ("*" * 4))
# 版本三
# 比例 0 - 1     0.5
def progress(percent,width=30):
    percent = percent if percent <= 1 else 1
    text = ("\r[%%-%ds]" % width) % ("*" * int((width * percent)))
    text = text + "%d%%"
    text = text % (percent * 100)
    print(  text  , end="")
# progress(0.5)
# 模拟下载
# 文件大小
import  time
file_size = 10240
# 已经下载大小
cur_size = 0
while True:
    time.sleep(0.5)
    cur_size += 1021
    progress(cur_size / file_size)
    if cur_size >= file_size:
        print("\nfinish")
        break
```

## shutil模块
---

| shutil模块作用 |
| :--- |

用于简化文件的高级操作

copy

move

remove

gzip

tar

...

---

| shutil模块使用 |
| :--- |

```plain
shutil.copyfileobj(fsrc, fdst[, length])
# 将文件内容拷贝到另一个文件中
import shutil
shutil.copyfileobj(open('old.xml','r'), open('new.xml', 'w'))
 
shutil.copyfile(src, dst)
# 拷贝文件
shutil.copyfile('f1.log', 'f2.log') #目标文件无需存在
 
shutil.copymode(src, dst)
# 仅拷贝权限。内容、组、用户均不变
shutil.copymode('f1.log', 'f2.log') #目标文件必须存在
 
shutil.copystat(src, dst)
# 仅拷贝状态的信息，包括：mode bits, atime, mtime, flags
shutil.copystat('f1.log', 'f2.log')#目标文件必须存在
 
shutil.copy(src, dst)
# 拷贝文件和权限
import shutil
shutil.copy('f1.log', 'f2.log')
 
shutil.copy2(src, dst)
# 拷贝文件和状态信息
import shutil 
shutil.copy2('f1.log', 'f2.log')
 
shutil.ignore_patterns(*patterns)
shutil.copytree(src, dst, symlinks=False, ignore=None)
# 递归的去拷贝文件夹
import shutil 
shutil.copytree('folder1', 'folder2', ignore=shutil.ignore_patterns('*.pyc', 'tmp*')) 
# 目标目录不能存在，注意对folder2目录父级目录要有可写权限，ignore的意思是排除拷贝软连接
 
shutil.rmtree(path[, ignore_errors[, onerror]])
# 递归的去删除文件
import shutil
shutil.rmtree('folder1')
 
shutil.move(src, dst)
# 递归的去移动文件，它类似mv命令，其实就是重命名。
import shutil
shutil.move('folder1', 'folder3')
 
shutil.make_archive(base_name, format,...)
# 创建压缩包并返回文件路径，例如：zip、tar
# 创建压缩包并返回文件路径，例如：zip、tar
# base_name： 压缩包的文件名，也可以是压缩包的路径。只是文件名时，则保存至当前目录，否则保存至指定路径，
# 如 data_bak                       =>保存至当前路径
# 如：/tmp/data_bak =>保存至/tmp/
# format： 压缩包种类，“zip”, “tar”, “bztar”，“gztar”
# root_dir： 要压缩的文件夹路径（默认当前目录）
# owner： 用户，默认当前用户
# group： 组，默认当前组
# logger： 用于记录日志，通常是logging.Logger对象
# 利用shutil来创建压缩文件  仅支持 tar 和zip格式 内部调用zipFIle tarFIle模块实现
# shutil 对压缩包的处理是调用 ZipFile 和 TarFile 两个模块来进行的，详细：
## 解压zip文件
import zipfile
# 压缩
z = zipfile.ZipFile('laxi.zip', 'w')
z.write('a.log')
z.write('data.data')
z.close()
# 解压
z = zipfile.ZipFile('laxi.zip', 'r')
z.extractall(path='.')
z.close()
## 解压tar文件
import tarfile
# 压缩
>>> t=tarfile.open('/tmp/zls.tar','w')
>>> t.add('/test1/a.py',arcname='a.bak')
>>> t.add('/test1/b.py',arcname='b.bak')
>>> t.close()
# 解压
>>> t=tarfile.open('/tmp/zls.tar','r')
>>> t.extractall('/zls')
>>> t.close()zls
```

---

| tar.gz包压缩和解压 |
| :--- |

额外扩展，为什么要有tar.gz这个包来操作呢？

因为运维人员一般都使用tar.gz来对文件进行压缩归档

```plain
# 压缩
import os, tarfile
def make_targz(output_filename, source_dir):
    """
    一次性打包目录为tar.gz
    :param output_filename: 压缩文件名
    :param source_dir: 需要打包的目录
    :return: bool
    """
    try:
        with tarfile.open(output_filename, "w:gz") as tar:
            tar.add(source_dir, arcname=os.path.basename(source_dir))
        return True
    except Exception as e:
        print(e)
        return False
make_targz('aa.tar.gz','folder')
# 解压
def untar(fname, dirs):
    """
    解压tar.gz文件
    :param fname: 压缩文件名
    :param dirs: 解压后的存放路径
    :return: bool
    """
    try:
        t = tarfile.open(fname)
        t.extractall(path = dirs)
        return True
    except Exception as e:
        print(e)
        return False
untar('aa.tar.gz','./')
# 完整代码
def make_targz(output_filename, source_dir):
    """
    一次性打包目录为tar.gz
    :param output_filename: 压缩文件名
    :param source_dir: 需要打包的目录
    :return: bool
    """
    try:
        with tarfile.open(output_filename, "w:gz") as tar:
            tar.add(source_dir, arcname=os.path.basename(source_dir))
        return True
    except Exception as e:
        print(e)
        return False
def untar(fname, dirs):
    """
    解压tar.gz文件
    :param fname: 压缩文件名
    :param dirs: 解压后的存放路径
    :return: bool
    """
    try:
        t = tarfile.open(fname)
        t.extractall(path = dirs)
        return True
    except Exception as e:
        print(e)
        return False
# make_targz('aa.tar.gz','folder')
untar('aa.tar.gz','./')
```

## os模块
---

| os模块作用 |
| :--- |

os模块是与操作系统交互的一个接口

使用os，就可以调用系统命令

---

| os模块使用 |
| :--- |

```plain
os.getcwd() 获取当前工作目录，即当前python脚本工作的目录路径
os.chdir("dirname")  改变当前脚本工作目录；相当于shell下cd
os.curdir  返回当前目录: ('.')
os.pardir  获取当前目录的父目录字符串名：('..')
os.makedirs('dirname1/dirname2')    可生成多层递归目录
os.removedirs('dirname1')    若目录为空，则删除，并递归到上一级目录，如若也为空，则删除，依此类推
os.mkdir('dirname')    生成单级目录；相当于shell中mkdir dirname
os.rmdir('dirname')    删除单级空目录，若目录不为空则无法删除，报错；相当于shell中rmdir dirname
os.listdir('dirname')    列出指定目录下的所有文件和子目录，包括隐藏文件，并以列表方式打印
os.remove()  删除一个文件
os.rename("oldname","newname")  重命名文件/目录
os.stat('path/filename')  获取文件/目录信息
os.sep    输出操作系统特定的路径分隔符，win下为"\\",Linux下为"/"
os.linesep    输出当前平台使用的行终止符，win下为"\t\n",Linux下为"\n"
os.pathsep    输出用于分割文件路径的字符串 win下为;,Linux下为:
os.name    输出字符串指示当前使用平台。win->'nt'; Linux->'posix'
os.system("bash command")  运行shell命令，直接显示
os.environ  获取系统环境变量
# path方法
os.path.abspath(path)  返回path规范化的绝对路径
os.path.split(path)  将path分割成目录和文件名二元组返回
os.path.dirname(path)  返回path的目录。其实就是os.path.split(path)的第一个元素
os.path.basename(path)  返回path最后的文件名。如何path以／或\结尾，那么就会返回空值。即os.path.split(path)的第二个元素
os.path.exists(path)  如果path存在，返回True；如果path不存在，返回False
os.path.isabs(path)  如果path是绝对路径，返回True
os.path.isfile(path)  如果path是一个存在的文件，返回True。否则返回False
os.path.isdir(path)  如果path是一个存在的目录，则返回True。否则返回False
os.path.join(path1[, path2[, ...]])  将多个路径组合后返回，第一个绝对路径之前的参数将被忽略
os.path.getatime(path)  返回path所指向的文件或者目录的最后存取时间
os.path.getmtime(path)  返回path所指向的文件或者目录的最后修改时间
os.path.getsize(path) 返回path的大小
```

```plain
在Linux和Mac平台上，该函数会原样返回path，在windows平台上会将路径中所有字符转换为小写，并将所有斜杠转换为饭斜杠。
>>> os.path.normcase('c:/windows\\system32\\')   
'c:\\windows\\system32\\'   
   
规范化路径，如..和/
>>> os.path.normpath('c://windows\\System32\\../Temp/')   
'c:\\windows\\Temp'   
>>> a='/Users/zls/test1/\\\a1/\\\\aa.py/../..'
>>> print(os.path.normpath(a))
/Users/zls/test1
```

```plain
os路径处理
#方式一：推荐使用
import os
#具体应用
import os,sys
possible_topdir = os.path.normpath(os.path.join(
    os.path.abspath(__file__),
    os.pardir, #上一级
    os.pardir,
    os.pardir
))
sys.path.insert(0,possible_topdir)
#方式二：不推荐使用
os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
```

## Json模块&pickle模块
---

| pickle模块作用 |
| :--- |

pickle模块用于序列化数据

**什么是序列化？**

我们把对象(变量)从内存中变成可存储或传输的过程称之为序列化，在Python中叫pickling，在其他语言中也被称之为serialization，marshalling，flattening等等，都是一个意思。

**为什么要序列化？**

1：持久保存状态

需知一个软件/程序的执行就在处理一系列状态的变化，在编程语言中，'状态'会以各种各样有结构的数据类型(也可简单的理解为变量)的形式被保存在内存中。

内存是无法永久保存数据的，当程序运行了一段时间，我们断电或者重启程序，内存中关于这个程序的之前一段时间的数据（有结构）都被清空了。

在断电或重启程序之前将程序当前内存中所有的数据都保存下来（保存到文件中），以便于下次程序执行能够从文件中载入之前的数据，然后继续执行，这就是序列化。

具体的来说，你玩使命召唤闯到了第13关，你保存游戏状态，关机走人，下次再玩，还能从上次的位置开始继续闯关。或如，虚拟机状态的挂起等。

2：跨平台数据交互

序列化之后，不仅可以把序列化后的内容写入磁盘，还可以通过网络传输到别的机器上，如果收发的双方约定好实用一种序列化的格式，那么便打破了平台/语言差异化带来的限制，实现了跨平台数据交互。

反过来，把变量内容从序列化的对象重新读到内存里称之为反序列化，即unpickling。

---

| 如何序列化之pickle |
| :--- |

<!-- OCR_START -->
- 保存到文件中或基于网
- 内存中结构化的数据
- 格式pickle
- bytes类型
- 络传输
<!-- OCR_END -->

￼

```plain
import pickle
dic={'name':'zls','age':18,'sex':'male'}
print(type(dic))#<class 'dict'>
j=pickle.dumps(dic)
print(type(j))#<class 'bytes'>
f=open('序列化对象_pickle','wb')#注意是w是写入str,wb是写入bytes,j是'bytes'
f.write(j)  #-------------------等价于pickle.dump(dic,f)
f.close()
#-------------------------反序列化
import pickle
f=open('序列化对象_pickle','rb')
data=pickle.loads(f.read())#  等价于data=pickle.load(f)
print(data['age'])
```

**python2与python3兼容问题**

```plain
# coding:utf-8
import pickle
with open('a.pkl',mode='wb') as f:
    # 一：在python3中执行的序列化操作如何兼容python2
    # python2不支持protocol>2，默认python3中protocol=4
    # 所以在python3中dump操作应该指定protocol=2
    pickle.dump('你好啊',f,protocol=2)
with open('a.pkl', mode='rb') as f:
    # 二：python2中反序列化才能正常使用
    res=pickle.load(f)
    print(res)
```

Pickle的问题和所有其他编程语言特有的序列化问题一样，就是它只能用于Python，并且可能不同版本的Python彼此都不兼容，因此，只能用Pickle保存那些不重要的数据，不能成功地反序列化也没关系。

**练习**

```plain
# 写法一：
## 序列化
import pickle
users={"name":"zls","age":18,"gender":"male"}
p=pickle.dumps(users)
f=open('zls.txt','wb')
f.write(p)
f.close()
## 反序列化
f=open("zls.txt","rb")
p=pickle.loads(f.read())
print(p)
f.close()
# 写法二：
## 序列化
pickle.dump(users,open("zls1.txt","wb"))
## 反序列化
print(pickle.load(open("zls1.txt","rb")))
```

**注意：**刚才我们介绍了跨平台性，所以我们不使用pickle,以后我们开发的东西，需要把数据传给前端，前端拿到序列化好的数据，做一个反序列化即可，所以我们推荐使用Json格式，使用Json做序列化。如果谁忘记这段话，以后开发使用pickle，那么帽子就这段话的颜色

---

| 如何序列化之json |
| :--- |

**JSON 语法**：请打开我的另一篇文章，让你5分钟学会一门语言。[TP](https://blog.driverzeng.com/zenglaoshi/4507.html)

如果我们要在不同的编程语言之间传递对象，就必须把对象序列化为标准格式，比如XML，但更好的方法是序列化为JSON，因为JSON表示出来就是一个字符串，可以被所有语言读取，也可以方便地存储到磁盘或者通过网络传输。JSON不仅是标准格式，并且比XML更快，而且可以直接在Web页面中读取，非常方便。

JSON表示的对象就是标准的JavaScript语言的对象，JSON和Python内置的数据类型对应如下：

<!-- OCR_START -->
- JSON类型
- Python类型
- dict
- list
- "string"
- str
- 1234.56
- int或float
- true/false
- 曾老湿
- None
- Driver Zeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 保存到文件中或基于网
- 内存中结构化的数据
- 格式json
- 字串
- 络传输
<!-- OCR_END -->

￼

```plain
import json
dic={'name':'zls','age':18,'sex':'male'}
print(type(dic))#<class 'dict'>
j=json.dumps(dic)
print(type(j))#<class 'str'>
f=open('序列化对象','w')
f.write(j)  #-------------------等价于json.dump(dic,f)
f.close()
#-----------------------------反序列化<br>
import json
f=open('序列化对象')
data=json.loads(f.read())#  等价于data=json.load(f)
```

**注意：**

```plain
import json
#dct="{'1':111}"#json 不认单引号
#dct=str({"1":111})#报错,因为生成的数据还是单引号:{'one': 1}
dct='{"1":"111"}'
print(json.loads(dct))
#conclusion:
#        无论数据是怎样创建的，只要满足json格式，就可以json.loads出来,不一定非要dumps的数据才能loads
```

**了解**

```plain
# 在python解释器2.7与3.6之后都可以json.loads(bytes类型)，但唯独3.5不可以
>>> import json
>>> json.loads(b'{"a":111}')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/Users/zls/anaconda3/lib/python3.5/json/__init__.py", line 312, in loads
    s.__class__.__name__))
TypeError: the JSON object must be str, not 'bytes'
```

**猴子补丁与ujson**

```plain
# 一.什么是猴子补丁?
      猴子补丁的核心就是用自己的代码替换所用模块的源代码，详细地如下
　　1，这个词原来为Guerrilla Patch，杂牌军、游击队，说明这部分不是原装的，在英文里guerilla发音和gorllia(猩猩)相似，再后来就写了monkey(猴子)。
　　2，还有一种解释是说由于这种方式将原来的代码弄乱了(messing with it)，在英文里叫monkeying about(顽皮的)，所以叫做Monkey Patch。
# 二. 猴子补丁的功能(一切皆对象)
　　1.拥有在模块运行时替换的功能, 例如: 一个函数对象赋值给另外一个函数对象(把函数原本的执行的功能给替换了)
class Monkey:
    def hello(self):
        print('hello')
    def world(self):
        print('world')
def other_func():
    print("from other_func")
monkey = Monkey()
monkey.hello = monkey.world
monkey.hello()
monkey.world = other_func
monkey.world()
# 三.monkey patch的应用场景
如果我们的程序中已经基于json模块编写了大量代码了，发现有一个模块ujson比它性能更高，
但用法一样，我们肯定不会想所有的代码都换成ujson.dumps或者ujson.loads,那我们可能
会想到这么做
import ujson as json，但是这么做的需要每个文件都重新导入一下，维护成本依然很高
此时我们就可以用到猴子补丁了
只需要在入口处加上
, 只需要在入口加上:
import json
import ujson
def monkey_patch_json():
    json.__name__ = 'ujson'
    json.dumps = ujson.dumps
    json.loads = ujson.loads
monkey_patch_json() # 之所以在入口处加，是因为模块在导入一次后，后续的导入便直接引用第一次的成果
#其实这种场景也比较多, 比如我们引用团队通用库里的一个模块, 又想丰富模块的功能, 除了继承之外也可以考虑用Monkey
Patch.采用猴子补丁之后，如果发现ujson不符合预期，那也可以快速撤掉补丁。个人感觉Monkey
Patch带了便利的同时也有搞乱源代码的风险!
```

**小练习**

```plain
## 序列化
import json
users={'name':'zls','age':18,'gender':'male'}
print(json.dumps(users))
## 序列化到文件
import json
users={'name':'zls','age':18,'gender':'male','hobbies':['野餐','外国妞','打篮球','跑步']}
json.dump(users,open("user.json","wt",encoding="utf-8"))
## 反序列化
print(json.load(open("user.json","rt",encoding="utf-8")))
```

## hashlib模块
---

| hashlib模块介绍 |
| :--- |

```plain
# 1、什么叫hash:hash是一种算法（3.x里代替了md5模块和sha模块，主要提供 SHA1, SHA224, SHA256, SHA384, SHA512 ，MD5 算法），该算法接受传入的内容，经过运算得到一串hash值
# 2、hash值的特点是：
#2.1 只要传入的内容一样，得到的hash值必然一样=====>要用明文传输密码文件完整性校验
#2.2 不能由hash值返解成内容=======》把密码做成hash值，不应该在网络传输明文密码
#2.3 只要使用的hash算法不变，无论校验的内容有多大，得到的hash值长度是固定的
```

hash算法就像一座工厂，工厂接收你送来的原材料（可以用m.update()为工厂运送原材料），经过加工返回的产品就是hash值

<!-- OCR_START -->
- 原材料
- hashI厂
- hash值
<!-- OCR_END -->

￼

```plain
import hashlib
m=hashlib.md5()# m=hashlib.sha256()
m.update('hello'.encode('utf8'))
print(m.hexdigest())  #5d41402abc4b2a76b9719d911017c592
m.update('alvin'.encode('utf8'))
print(m.hexdigest())  #92a7e713c30abbb0319fa07da2a5c4af
m2=hashlib.md5()
m2.update('helloalvin'.encode('utf8'))
print(m2.hexdigest()) #92a7e713c30abbb0319fa07da2a5c4af
'''
注意：把一段很长的数据update多次，与一次update这段长数据，得到的结果一样
但是update多次为校验大文件提供了可能。
'''
```

以上加密算法虽然依然非常厉害，但时候存在缺陷，即：通过撞库可以反解。所以，有必要对加密算法中添加自定义key再来做加密。

---

| 模拟撞库破解密码 |
| :--- |

```plain
import hashlib
# ######## 256 ########
hash = hashlib.sha256('898oaFs09f'.encode('utf8'))
hash.update('alvin'.encode('utf8'))
print (hash.hexdigest())#e79e68f070cdedcfe63eaf1a2e92c83b4cfb1b5c6bc452d214c1b7e77cdfd1c7
```

```plain
import hashlib
passwds=[
    'alex3714',
    'alex1313',
    'alex94139413',
    'alex123456',
    '123456alex',
    'a123lex',
    ]
def make_passwd_dic(passwds):
    dic={}
    for passwd in passwds:
        m=hashlib.md5()
        m.update(passwd.encode('utf-8'))
        dic[passwd]=m.hexdigest()
    return dic
def break_code(cryptograph,passwd_dic):
    for k,v in passwd_dic.items():
        if v == cryptograph:
            print('密码是===>\033[46m%s\033[0m' %k)
cryptograph='aee949757a2e698417463d47acac93df'
break_code(cryptograph,make_passwd_dic(passwds))
```

python 还有一个 hmac 模块，它内部对我们创建 key 和 内容 进行进一步的处理然后再加密:

```plain
import hmac
h1=hmac.new('hello'.encode('utf-8'),digestmod='md5')
h1.update('world'.encode('utf-8'))
print(h1.hexdigest())
```

**注意！注意！注意**

```plain
#要想保证hmac最终结果一致，必须保证：
#1:hmac.new括号内指定的初始key一样
#2:无论update多少次，校验的内容累加到一起是一样的内容
# 操作一
import hmac
h1=hmac.new('hello'.encode('utf-8'),digestmod='md5')
h1.update('world'.encode('utf-8'))
print(h1.hexdigest()) # 0e2564b7e100f034341ea477c23f283b
# 操作二
import hmac
h2=hmac.new('hello'.encode('utf-8'),digestmod='md5')
h2.update('w'.encode('utf-8'))
h2.update('orld'.encode('utf-8'))
print(h1.hexdigest()) # 0e2564b7e100f034341ea477c23f283b
```

## xml模块
---

| xml模块介绍 |
| :--- |

xml是实现不同语言或程序之间进行数据交换的协议，跟json差不多，但json使用起来更简单，不过，古时候，在json还没诞生的黑暗年代，大家只能选择用xml呀，至今很多传统公司如金融行业的很多系统的接口还主要是xml。

xml的格式如下，就是通过<>节点来区别数据结构的:

```plain
<!--xml数据-->
<?xml version="1.0"?>
<data>
    <country name="Liechtenstein">
        <rank updated="yes">2</rank>
        <year>2008</year>
        <gdppc>141100</gdppc>
        <neighbor name="Austria" direction="E"/>
        <neighbor name="Switzerland" direction="W"/>
    </country>
    <country name="Singapore">
        <rank updated="yes">5</rank>
        <year>2011</year>
        <gdppc>59900</gdppc>
        <neighbor name="Malaysia" direction="N"/>
    </country>
    <country name="Panama">
        <rank updated="yes">69</rank>
        <year>2011</year>
        <gdppc>13600</gdppc>
        <neighbor name="Costa Rica" direction="W"/>
        <neighbor name="Colombia" direction="E"/>
    </country>
</data>
```

xml协议在各个语言里的都 是支持的，在python中可以用以下模块操作xml：

```plain
# print(root.iter('year')) #全文搜索
# print(root.find('country')) #在root的子节点找，只找一个
# print(root.findall('country')) #在root的子节点找，找所有
```

---

| xml模块使用 |
| :--- |

```plain
import xml.etree.ElementTree as ET
 
tree = ET.parse("xmltest.xml")
root = tree.getroot()
print(root.tag)
 
#遍历xml文档
for child in root:
    print('========>',child.tag,child.attrib,child.attrib['name'])
    for i in child:
        print(i.tag,i.attrib,i.text)
 
#只遍历year 节点
for node in root.iter('year'):
    print(node.tag,node.text)
#---------------------------------------
import xml.etree.ElementTree as ET
 
tree = ET.parse("xmltest.xml")
root = tree.getroot()
 
#修改
for node in root.iter('year'):
    new_year=int(node.text)+1
    node.text=str(new_year)
    node.set('updated','yes')
    node.set('version','1.0')
tree.write('test.xml')
 
 
#删除node
for country in root.findall('country'):
   rank = int(country.find('rank').text)
   if rank > 50:
     root.remove(country)
 
tree.write('output.xml')
```

在country内添加（append）节点year2

```plain
import xml.etree.ElementTree as ET
tree = ET.parse("a.xml")
root=tree.getroot()
for country in root.findall('country'):
    for year in country.findall('year'):
        if int(year.text) > 2000:
            year2=ET.Element('year2')
            year2.text='新年'
            year2.attrib={'update':'yes'}
            country.append(year2) #往country节点下添加子节点
tree.write('a.xml.swap')
```

自己创建xml文档：

```plain
import xml.etree.ElementTree as ET
 
 
new_xml = ET.Element("namelist")
name = ET.SubElement(new_xml,"name",attrib={"enrolled":"yes"})
age = ET.SubElement(name,"age",attrib={"checked":"no"})
sex = ET.SubElement(name,"sex")
sex.text = '33'
name2 = ET.SubElement(new_xml,"name",attrib={"enrolled":"no"})
age = ET.SubElement(name2,"age")
age.text = '19'
 
et = ET.ElementTree(new_xml) #生成文档对象
et.write("test.xml", encoding="utf-8",xml_declaration=True)
 
ET.dump(new_xml) #打印生成的格式
```

## configparser模块
---

| configparser模块介绍 |
| :--- |

```plain
configparser 是什么? 配置文件解析模块
    什么是配置文件?
        用于提供程序运行所需要的一些信息的文件   后缀 ini cfg
    有什么用?
        方便用户修改   例如超时时间
配置文件内容格式
    只包括两种元素
    section  分区
    option   选项
    一个文件可以有多个section
    一个section可以有多个选项
核心功能
1.sections 获取所有分区
2.options  获取所有选项
3.get      获取一个值     传入 section  option
注意:大小写不敏感
```

---

| configparser模块使用 |
| :--- |

**配置文件**

```plain
# 注释1
; 注释2
[section1]
k1 = v1
k2:v2
user=zls
age=18
is_admin=true
salary=31
[section2]
k1 = v1
```

**读取操作**

```plain
import configparser
config=configparser.ConfigParser()
config.read('a.cfg')
#查看所有的标题
res=config.sections() #['section1', 'section2']
print(res)
#查看标题section1下所有key=value的key
options=config.options('section1')
print(options) #['k1', 'k2', 'user', 'age', 'is_admin', 'salary']
#查看标题section1下所有key=value的(key,value)格式
item_list=config.items('section1')
print(item_list) #[('k1', 'v1'), ('k2', 'v2'), ('user', 'zls'), ('age', '18'), ('is_admin', 'true'), ('salary', '31')]
#查看标题section1下user的值=>字符串格式
val=config.get('section1','user')
print(val) #zls
#查看标题section1下age的值=>整数格式
val1=config.getint('section1','age')
print(val1) #18
#查看标题section1下is_admin的值=>布尔值格式
val2=config.getboolean('section1','is_admin')
print(val2) #True
#查看标题section1下salary的值=>浮点型格式
val3=config.getfloat('section1','salary')
print(val3) #31.0
```

**改写操作**

```plain
import configparser
config=configparser.ConfigParser()
config.read('a.cfg',encoding='utf-8')
#删除整个标题section2
config.remove_section('section2')
#删除标题section1下的某个k1和k2
config.remove_option('section1','k1')
config.remove_option('section1','k2')
#判断是否存在某个标题
print(config.has_section('section1'))
#判断标题section1下是否有user
print(config.has_option('section1',''))
#添加一个标题
config.add_section('zls')
#在标题zls下添加name=zls,age=18的配置
config.set('zls','name','zls')
config.set('zls','age',18) #报错,必须是字符串
#最后将修改的内容写入文件,完成最终的修改
config.write(open('a.cfg','w'))
```

**基于上述方法添加一个ini文档**

```plain
import configparser
  
config = configparser.ConfigParser()
config["DEFAULT"] = {'ServerAliveInterval': '45',
                      'Compression': 'yes',
                     'CompressionLevel': '9'}
  
config['bitbucket.org'] = {}
config['bitbucket.org']['User'] = 'hg'
config['topsecret.server.com'] = {}
topsecret = config['topsecret.server.com']
topsecret['Host Port'] = '50022'     # mutates the parser
topsecret['ForwardX11'] = 'no'  # same here
config['DEFAULT']['ForwardX11'] = 'yes'
with open('example.ini', 'w') as configfile:
   config.write(configfile)
```

> 更新: 2020-06-25 11:15:12  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/rink6w>