# 第4章  Python基础—常用模块（旧版）

# 4.1 模块、包介绍和相关语法

## 本节重点：

* 使学员掌握模块概念、分类、几种导入方法
* 使学生掌握包的概念、不同包之间模块的相互导入、模块的查找路径
* 使学员掌握第3方模块的安装方法

> **本节时长需控制在50分钟内**

## 什么是模块？

在计算机程序的开发过程中，随着程序代码越写越多，在一个文件里代码就会越来越长，越来越不容易维护。

为了编写可维护的代码，我们把很多函数分组，分别放到不同的文件里，这样，每个文件包含的代码就相对较少，很多编程语言都采用这种组织代码的方式。在Python中，一个.py文件就称之为一个模块（Module）。

## 使用模块有什么好处？

1. 最大的好处是大大提高了代码的可维护性。其次，编写代码不必从零开始。当一个模块编写完毕，就可以被其他地方引用。我们在编写程序的时候，也经常引用其他模块，包括Python内置的模块和来自第三方的模块。
2. 使用模块还可以避免函数名和变量名冲突。每个模块有独立的命名空间，因此相同名字的函数和变量完全可以分别存在不同的模块中，所以，我们自己在编写模块时，不必考虑名字会与其他模块冲突

## 模块分类

模块分为三种：

* 内置标准模块（又称标准库）执行help('modules')查看所有python自带模块列表
* 第三方开源模块，可通过pip install 模块名 联网安装
* 自定义模块

## 模块调用

```plain
import module
from module import xx
from module.xx.xx import xx as rename  
from module.xx.xx import *
```

> 注意：模块一旦被调用，即相当于执行了另外一个py文件里的代码

#### 自定义模块

这个最简单， 创建一个.py文件，就可以称之为模块，就可以在另外一个程序里导入

#### 模块查找路径

发现，自己写的模块只能在当前路径下的程序里才能导入，换一个目录再导入自己的模块就报错说找不到了， 这是为什么？

这与导入路径有关

```plain
import sys
print(sys.path)
```

输出

```plain
['', '/Library/Frameworks/Python.framework/Versions/3.6/lib/python36.zip', 
'/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6', 
'/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/lib-dynload', 
'/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages']
```

python解释器会按照列表顺序去依次到每个目录下去匹配你要导入的模块名，只要在一个目录下匹配到了该模块名，就立刻导入，不再继续往后找。

> 注意列表第一个元素为空，即代表当前目录，所以你自己定义的模块在当前目录会被优先导入。

## 开源模块安装、使用

<https://pypi.python.org/pypi> 是python的开源模块库，截止2017年9.30日 ，已经收录了**118170**个来自全世界python开发者贡献的模块,几乎涵盖了你想用python做的任何事情。 事实上每个python开发者，只要注册一个账号就可以往这个平台上传你自己的模块，这样全世界的开发者都可以容易的下载并使用你的模块。

<!-- OCR_START -->
- search
- 》 Package Index > alex_sayhi > 1.0.0
- PACKAGE INDEX
- alex_sayhi 1.0.0
- Not Logged In
- Browse packages
- Login
- List trove classifiers
- saywi-1.0.targ
- Reqister
- RSS (latest 40 updates)
- Lost Login?
- RSS (newest 40 packages)
- Terms of Service
- Login with OpenID Ip
- PyPI Tutorial
- Login with Google
- PyPI Security
- Google Login
- PyPI Support
- PyPI Bug Reports
- Status
- PyPI Discussion
- Nothing to report
- PyPI Developer Info
- ABOUT
- File
- Type
- Py Version
- Uploaded on
- Size
- NEWS
- alex_sayhi-1.0.0.tar.gz (md5)
- Source
- 2014-06-21
- 534B
- DOCUMENTATION
- Author: alex li
- DOWNLOAD
- 这就是我传的啊，哈哈哈
- Package Index Owner: lje3721
- COMMUNITY
- DOAP record: alex_sayhi-1.0.0.xml
- FOUNDATION
- CORE DEVELOPMENT >>
<!-- OCR_END -->

那如何从这个平台上下载代码呢？

1.直接在上面这个页面上点download,下载后，解压并进入目录，执行以下命令完成安装

```plain
编译源码    python setup.py build
安装源码    python setup.py install
```

1. 直接通过pip安装

```plain
pip3 install paramiko #paramiko 是模块名
```

pip命令会自动下载模块包并完成安装。

软件一般会被自动安装你python安装目录的这个子目录里

```plain
/your_python_install_path/3.6/lib/python3.6/site-packages
```

pip命令默认会连接在国外的python官方服务器下载，速度比较慢，你还可以使用国内的豆瓣源，数据会定期同步国外官网，速度快好多

```plain
sudo pip install -i http://pypi.douban.com/simple/ alex_sayhi --trusted-host pypi.douban.com   #alex_sayhi是模块名
```

#### 使用

下载后，直接导入使用就可以，跟自带的模块调用方法无差，演示一个连接linux执行命令的模块

```plain
#coding:utf-8
import paramiko
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('192.168.1.108', 22, 'alex', '123')
stdin, stdout, stderr = ssh.exec_command('df')
print(stdout.read())
ssh.close();
执行命令 - 通过用户名和密码连接服务器
```

## 包(Package)

当你的模块文件越来越多，就需要对模块文件进行划分，比如把负责跟数据库交互的都放一个文件夹，把与页面交互相关的放一个文件夹，

```plain
.
└── my_proj
    ├── crm #代码目录
    │   ├── admin.py
    │   ├── apps.py
    │   ├── models.py
    │   ├── tests.py
    │   └── views.py
    ├── manage.py
    └── my_proj #配置文件目录
        ├── settings.py
        ├── urls.py
        └── wsgi.py
```

像上面这样，**一个文件夹管理多个模块文件，这个文件夹就被称为包**

那不同包之间的模块互相导入呢？

**crm/views.py内容**

```plain
def sayhi():
    print('hello world!')
```

**通过manage.py调用**

```plain
from crm import views
views.sayhi()
```

**执行manage.py (注意这里用python2)**

```plain
Alexs-MacBook-Pro:my_proj alex$ ls
crm        manage.py    my_proj
Alexs-MacBook-Pro:my_proj alex$ python manage.py 
Traceback (most recent call last):
  File "manage.py", line 6, in <module>
    from crm import views
ImportError: No module named crm
```

竟然说找不到模块，为什么呢？

**包就是文件夹，但该文件夹下必须存在 **init**.py 文件, 该文件的内容可以为空。**int**.py用于标识当前文件夹是一个包。**

在crm目录下创建一个空文件\*\***int**.py ，再执行一次就可以了\*\*

```plain
Alexs-MacBook-Pro:my_proj alex$ touch crm/__init__.py #创建一个空文件
Alexs-MacBook-Pro:my_proj alex$ 
Alexs-MacBook-Pro:my_proj alex$ ls crm/
__init__.py    admin.py    models.py    views.py
__pycache__    apps.py        tests.py    views.pyc
Alexs-MacBook-Pro:my_proj alex$ python manage.py 
hello world!
```

> 注意，在python3里，即使目录下没__int\_\_.py文件也能创建成功，猜应该是解释器优化所致，但创建包还是要记得加上这个文件 吧。

## 跨模块导入

目录结构如下

```plain
.
├── __init__.py
├── crm
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   ├── views.py  
├── manage.py   
└── proj
    ├── __init__.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py
```

根据上面的结构，如何实现在`crm/views.py`里导入`proj/settings.py`模块？

直接导入的话，会报错，说找到不模块

```plain
$ python3 views.py
Traceback (most recent call last):
  File "views.py", line 2, in <module>
    from proj import settings
ModuleNotFoundError: No module named 'proj'
```

是因为路径找不到，proj/settings.py 相当于是crm/views.py的父亲(crm)的兄弟(proj)的儿子(settings.py)，settings.py算是views.py的表弟啦，在views.py里只能导入同级别兄弟模块代码，或者子级别包里的模块，根本不知道表弟表哥的存在。这可怎么办呢？

答案是**添加环境变量，把父亲级的路径添加到sys.path中，就可以了，这样导入 就相当于从父亲级开始找模块了。**

*crm/views.py中添加环境变量*

```plain
import sys ,os
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) #__file__的是打印当前被执行的模块.py文件相对路径，注意是相对路径
print(BASE_DIR)
sys.path.append(BASE_DIR)  
from proj import settings
def sayhi():
    print('hello world!')
print(settings.DATABASES)
```

输出

```plain
$ python3 views.py
/Users/alex/Documents/work/PyProjects/luffy_课件/21天入门/chapter4-常用模块/packages/my_proj
---my proj init---  #proj/__init__.py输出
in proj/settings.py #proj/settings.py输出
{'host': 'localhost'}
```

#### \*注意；此时在proj/settings.py写上import urls会有问题么？

```plain
DATABASES= {
    'host':'localhost'
}
import urls  #这行刚加的 
print('in proj/settings.py')
```

结果报错了

```plain
ModuleNotFoundError: No module named 'urls'
```

为什么呢？ 因为现在的程序入口是views.py , 你在settings.py导入import urls,其实相当于在crm目录找urls.py,而不是proj目录，若想正常导入，要改成如下

```plain
DATABASES= {
    'host':'localhost'
}
from proj import urls  #proj这一层目录已经添加到sys.path里，可以直接找到
print('in proj/settings.py')
```

## 绝对导入&相对导入

在linux里可以通过cd ..回到上一层目录 ，cd ../.. 往上回2层，这个..就是指相对路径，在python里，导入也可以通过`..`

例如：

```plain
.
├── __init__.py
├── crm
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   ├── views.py  #from ..proj import settings 
├── manage.py   
└── proj
    ├── __init__.py
    ├── settings.py #from .import urls  
    ├── urls.py
    └── wsgi.py
```

views.py里代码

```plain
from ..proj import settings
def sayhi():
    print('hello world!')
print(settings.DATABASES)
```

执行结果报错了

```plain
Traceback (most recent call last):
File "my_proj/crm/views.py", line 4, in <module>
 from ..proj import settings
SystemError: Parent module '' not loaded, cannot perform relative import
```

或者有人会看到这个错

```plain
ValueError: attempted relative import beyond top-level package
```

其实这两个错误的原因归根结底是一样的：在涉及到相对导入时，package所对应的文件夹必须正确的被python解释器视作package，而不是普通文件夹。否则由于不被视作package，无法利用package之间的嵌套关系实现python中包的相对导入。

文件夹被python解释器视作package需要满足两个条件：

1. **文件夹中必须有__init\_\_.py文件，该文件可以为空，但必须存在该文件。**
2. **不能作为顶层模块来执行该文件夹中的py文件（即不能作为主函数的入口）。**

所以这个问题的解决办法就是，既然你在views.py里执行了相对导入，那就不要把views.py当作入口程序，可以通过上一级的manage.py调用views.py

```plain
.
├── __init__.py
├── crm
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   ├── views.py  #from ..proj import settings 
├── manage.py  #from crm import views 
└── proj
    ├── __init__.py
    ├── settings.py #from .import urls  
    ├── urls.py
    └── wsgi.py
```

事实证明还是不行,报错

```plain
ValueError: attempted relative import beyond top-level package
```

但把`from ..proj import settings` 改成`from . import models` 后却执行成功了，为什么呢？

`from .. import models`会报错的原因是，这句代码会把manage.py所在的这一层视作package,但实际上它不是，因为package不能是顶层入口代码，若想不出错，只能把manage.py往上再移一层。

正确的代码目录结构如下

```plain
packages/
    ├── __init__.py
    ├── manage.py #from my_proj.crm  import views
    └── my_proj
        ├── crm
        │   ├── admin.py
        │   ├── apps.py
        │   ├── models.py
        │   ├── tests.py
        │   ├── views.py  #from . import models;  from ..proj import settings 
        └── proj
            ├── __init__.py
            ├── settings.py
            ├── urls.py
            └── wsgi.py
```

再执行manage.py就不会报错了。

> 注:虽然python支持相对导入，但对模块间的路径关系要求比较严格，处理不当就容易出错，so并不建议在项目里经常使用。

# 4.2 time & datetime 模块

## 本节重点：

* 使学员掌握time and datetime模块的使用

> **本节时长需控制在25分钟内**

## time & datetime 模块

在平常的代码中，我们常常需要与时间打交道。在Python中，与时间处理有关的模块就包括：time，datetime,calendar(很少用，不讲)，下面分别来介绍。

在开始之前，首先要说明几点：

**一、在Python中，通常有这几种方式来表示时间：**

1. 时间戳
2. 格式化的时间字符串
3. 元组（struct_time）共九个元素。由于Python的time模块实现主要调用C库，所以各个平台可能有所不同。

**二、几个定义**

UTC（Coordinated Universal Time，世界协调时）亦即格林威治天文时间，世界标准时间。在中国为UTC+8。DST（Daylight Saving Time）即夏令时。

时间戳（timestamp）的方式：通常来说，时间戳表示的是从1970年1月1日00:00:00开始按秒计算的偏移量。我们运行“type(time.time())”，返回的是float类型。

元组（struct_time）方式：struct_time元组共有9个元素，返回struct_time的函数主要有gmtime()，localtime()，strptime()。下面列出这种方式元组中的几个元素：

```plain
索引（Index）    属性（Attribute）    值（Values）
0     tm_year（年）                 比如2011 
1     tm_mon（月）             1 - 12
2     tm_mday（日）                 1 - 31
3     tm_hour（时）                 0 - 23
4     tm_min（分）             0 - 59
5     tm_sec（秒）             0 - 61
6     tm_wday（weekday）            0 - 6（0表示周日）
7     tm_yday（一年中的第几天）    1 - 366
8     tm_isdst（是否是夏令时）            默认为-1
```

#### time模块的方法

* time.localtime(\[secs])：将一个时间戳转换为当前时区的struct_time。secs参数未提供，则以当前时间为准。
* time.gmtime(\[secs])：和localtime()方法类似，gmtime()方法是将一个时间戳转换为UTC时区（0时区）的struct_time。
* time.time()：返回当前时间的时间戳。
* time.mktime(t)：将一个struct_time转化为时间戳。
* time.sleep(secs)：线程推迟指定的时间运行。单位为秒。
* time.asctime(\[t])：把一个表示时间的元组或者struct_time表示为这种形式：'Sun Oct 1 12:04:38 2017'。如果没有参数，将会将time.localtime()作为参数传入。
* time.ctime(\[secs])：把一个时间戳（按秒计算的浮点数）转化为time.asctime()的形式。如果参数未给或者为None的时候，将会默认time.time()为参数。它的作用相当于time.asctime(time.localtime(secs))。
* time.strftime(format\[, t])：把一个代表时间的元组或者struct_time（如由time.localtime()和time.gmtime()返回）转化为格式化的时间字符串。如果t未指定，将传入time.localtime()。
  * 举例：time.strftime("%Y-%m-%d %X", time.localtime()) #输出'2017-10-01 12:14:23'
* time.strptime(string\[, format])：把一个格式化时间字符串转化为struct_time。实际上它和strftime()是逆操作。
  * 举例：time.strptime('2017-10-3 17:54',"%Y-%m-%d %H:%M") #输出 time.struct_time(tm_year=2017, tm_mon=10, tm_mday=3, tm_hour=17, tm_min=54, tm_sec=0, tm_wday=1, tm_yday=276, tm_isdst=-1)

| 字符串转时间格式对应表 |
| :--- |
| |

| | Meaning | Notes |
| --- | :--- | :--- |
| `%a` | Locale’s abbreviated weekday name. | |
| `%A` | Locale’s full weekday name. | |
| `%b` | Locale’s abbreviated month name. | |
| `%B` | Locale’s full month name. | |
| `%c` | Locale’s appropriate date and time representation. | |
| `%d` | Day of the month as a decimal number \[01,31]. | |
| `%H` | Hour (24-hour clock) as a decimal number \[00,23]. | |
| `%I` | Hour (12-hour clock) as a decimal number \[01,12]. | |
| `%j` | Day of the year as a decimal number \[001,366]. | |
| `%m` | Month as a decimal number \[01,12]. | |
| `%M` | Minute as a decimal number \[00,59]. | |
| `%p` | Locale’s equivalent of either AM or PM. | (1) |
| `%S` | Second as a decimal number \[00,61]. | (2) |
| `%U` | Week number of the year (Sunday as the first day of the week) as a decimal number \[00,53]. All days in a new year preceding the first Sunday are considered to be in week 0. | (3) |
| `%w` | Weekday as a decimal number \[0(Sunday),6]. | |
| `%W` | Week number of the year (Monday as the first day of the week) as a decimal number \[00,53]. All days in a new year preceding the first Monday are considered to be in week 0. | (3) |
| `%x` | Locale’s appropriate date representation. | |
| `%X` | Locale’s appropriate time representation. | |
| `%y` | Year without century as a decimal number \[00,99]. | |
| `%Y` | Year with century as a decimal number. | |
| `%z` | Time zone offset indicating a positive or negative time difference from UTC/GMT of the form +HHMM or -HHMM, where H represents decimal hour digits and M represents decimal minute digits \[-23:59, +23:59]. | |
| `%Z` | Time zone name (no characters if no time zone exists). | |
| | `%%` | A literal `'%'`<br/> character. |

最后为了容易记住转换关系，看下图

<!-- OCR_START -->
1432224000.0
time.mktime(struct_time)
time.gmtime(1432224000.0)
time.struct_time(tm_year=2015,tm_mon=5,tm_mday=22,tm_hour=0,t
m_min=0,tm_sec=0,tm_wday=4,tm_yday=142,tm_isdst=-1)
time.strptime("2016/0522","%Y/%m/%d")
time.strftime("%Y-%m-%d %H:%M:%S",time.gmtime())
“2016/05/22
时间转换关系图，byALEX，OLDBOYPY
<!-- OCR_END -->

#### datetime模块

相比于time模块，datetime模块的接口则更直观、更容易调用

**datetime模块定义了下面这几个类：**

* datetime.date：表示日期的类。常用的属性有year, month, day；
* datetime.time：表示时间的类。常用的属性有hour, minute, second, microsecond；
* datetime.datetime：表示日期时间。
* datetime.timedelta：表示时间间隔，即两个时间点之间的长度。
* datetime.tzinfo：与时区有关的相关信息。（这里不详细充分讨论该类，感兴趣的童鞋可以参考python手册）

**我们需要记住的方法仅以下几个：**

1. d=datetime.datetime.now() 返回当前的datetime日期类型

```plain
d.timestamp(),d.today(), d.year,d.timetuple()等方法可以调用
```

2.datetime.date.fromtimestamp(322222) 把一个时间戳转为datetime日期类型

3.时间运算

```plain
>>> datetime.datetime.now()
datetime.datetime(2017, 10, 1, 12, 53, 11, 821218)
>>> datetime.datetime.now() + datetime.timedelta(4) #当前时间 +4天
datetime.datetime(2017, 10, 5, 12, 53, 35, 276589)
>>> datetime.datetime.now() + datetime.timedelta(hours=4) #当前时间+4小时
datetime.datetime(2017, 10, 1, 16, 53, 42, 876275)
```

4.时间替换

```plain
>>> d.replace(year=2999,month=11,day=30)
datetime.date(2999, 11, 30)
```

# 4.3 random模块

## 本节重点：

* 使学员掌握random模块的使用

> **本节时长需控制在5分钟内**

程序中有很多地方需要用到随机字符，比如登录网站的随机验证码，通过random模块可以很容易生成随机字符串

```plain
>>> random.randrange(1,10) #返回1-10之间的一个随机数，不包括10
>>> random.randint(1,10) #返回1-10之间的一个随机数，包括10
>>> random.randrange(0, 100, 2) #随机选取0到100间的偶数
>>> random.random()  #返回一个随机浮点数
>>> random.choice('abce3#$@1') #返回一个给定数据集合中的随机字符
'#'
>>> random.sample('abcdefghij',3)  #从多个字符中选取特定数量的字符
['a', 'd', 'b']
#生成随机字符串
>>> import string 
>>> ''.join(random.sample(string.ascii_lowercase + string.digits, 6)) 
'4fvda1'
#洗牌
>>> a
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> random.shuffle(a)
>>> a
[3, 0, 7, 2, 1, 6, 5, 8, 9, 4]
```

# 4.4 os模块

## 本节重点：

* 使学员掌握os模块的使用

> **本节时长需控制在15分钟内**

os 模块提供了很多允许你的程序与操作系统直接交互的功能

```plain
得到当前工作目录，即当前Python脚本工作的目录路径: os.getcwd()
返回指定目录下的所有文件和目录名:os.listdir()
函数用来删除一个文件:os.remove()
删除多个目录：os.removedirs（r“c：\python”）
检验给出的路径是否是一个文件：os.path.isfile()
检验给出的路径是否是一个目录：os.path.isdir()
判断是否是绝对路径：os.path.isabs()
检验给出的路径是否真地存:os.path.exists()
返回一个路径的目录名和文件名:os.path.split()     e.g os.path.split('/home/swaroop/byte/code/poem.txt') 结果：('/home/swaroop/byte/code', 'poem.txt') 
分离扩展名：os.path.splitext()       e.g  os.path.splitext('/usr/local/test.py')    结果：('/usr/local/test', '.py')
获取路径名：os.path.dirname()
获得绝对路径: os.path.abspath()  
获取文件名：os.path.basename()
运行shell命令: os.system()
读取操作系统环境变量HOME的值:os.getenv("HOME") 
返回操作系统所有的环境变量： os.environ 
设置系统环境变量，仅程序运行时有效：os.environ.setdefault('HOME','/home/alex')
给出当前平台使用的行终止符:os.linesep    Windows使用'\r\n'，Linux and MAC使用'\n'
指示你正在使用的平台：os.name       对于Windows，它是'nt'，而对于Linux/Unix用户，它是'posix'
重命名：os.rename（old， new）
创建多级目录：os.makedirs（r“c：\python\test”）
创建单个目录：os.mkdir（“test”）
获取文件属性：os.stat（file）
修改文件权限与时间戳：os.chmod（file）
获取文件大小：os.path.getsize（filename）
结合目录名与文件名：os.path.join(dir,filename)
改变工作目录到dirname: os.chdir(dirname)
获取当前终端的大小: os.get_terminal_size()
杀死进程: os.kill(10884,signal.SIGKILL)
```

<!-- OCR_START -->
- os.path.isfile()
- 判断指定对象是否为文件。是返回True，否则False
- os.name()
- 判断现在正在实用的平台，Windows返回'nt;Linux返回posix
- os.path.is dir()—
- 一判断指定对象是否为目录。是True，否则False
- os.listdir()—
- 指定所有目录下所有的文件和目录名
- os.path.exists()
- 一检验指定的对象是否存在。是True，否则False.
- os.getcwd()
- 得到当前工作的目录
- os.path.getsize()——
- 一获得文件的大小，如果为目录，返回0
- os.mkdir()—
- -创建目录
- os.path.split()
- 一返回路径的目录和文件名
- path
- OS ( python)
- 不带path
- os.rmdir()
- 删除指定目录
- os.path.abspath()
- 获得绝对路径
- os.remove()-
- 删除指定文件
- os.path.basename(path)
- 返回文件名
- os.chdir()
- 改变目录到指定目录
- os.path.dirname(path)
- 返回文件路径
- os.system(
- -执行shell命令
- os.path.join(path, name)
- 一连接目录和文件名
<!-- OCR_END -->

# 4.5 sys模块

## 本节重点：

* 使学员掌握sys模块的使用

> **本节时长需控制在5分钟内**

```plain
sys.argv           命令行参数List，第一个元素是程序本身路径
sys.exit(n)        退出程序，正常退出时exit(0)
sys.version        获取Python解释程序的版本信息
sys.maxint         最大的Int值
sys.path           返回模块的搜索路径，初始化时使用PYTHONPATH环境变量的值
sys.platform       返回操作系统平台名称
sys.stdout.write('please:')  #标准输出 , 引出进度条的例子， 注，在py3上不行，可以用print代替
val = sys.stdin.readline()[:-1] #标准输入
sys.getrecursionlimit() #获取最大递归层数
sys.setrecursionlimit(1200) #设置最大递归层数
sys.getdefaultencoding()  #获取解释器默认编码
sys.getfilesystemencoding  #获取内存数据存到文件里的默认编码
```

# 4.6 shutil 模块

# 本节重点

* 使学员掌握shutil模块

### shutil 模块

高级的 文件、文件夹、压缩包 处理模块

**shutil.copyfileobj(fsrc, fdst\[, length])**

将文件内容拷贝到另一个文件中

```plain
import shutil
shutil.copyfileobj(open('old.xml','r'), open('new.xml', 'w'))
```

**shutil.copyfile(src, dst)**

拷贝文件

```plain
shutil.copyfile('f1.log', 'f2.log') #目标文件无需存在
```

**shutil.copymode(src, dst)**

仅拷贝权限。内容、组、用户均不变

```plain
shutil.copymode('f1.log', 'f2.log') #目标文件必须存在
```

**shutil.copystat(src, dst)**

仅拷贝状态的信息，包括：mode bits, atime, mtime, flags

```plain
shutil.copystat('f1.log', 'f2.log') #目标文件必须存在
```

shutil.copy(src, dst)

拷贝文件和权限

```plain
import shutil
shutil.copy('f1.log', 'f2.log')
```

**shutil.copy2(src, dst)**

拷贝文件和状态信息

```plain
import shutil
shutil.copy2('f1.log', 'f2.log')
```

\**shutil.ignore_patterns(*patterns)**

**shutil.copytree(src, dst, symlinks=False, ignore=None)**

递归的去拷贝文件夹

```plain
import shutil
shutil.copytree('folder1', 'folder2', ignore=shutil.ignore_patterns('*.pyc', 'tmp*')) #目标目录不能存在，注意对folder2目录父级目录要有可写权限，ignore的意思是排除
```

**shutil.rmtree(path\[, ignore_errors\[, onerror]])**

递归的去删除文件

```plain
import shutil
shutil.rmtree('folder1')
```

**shutil.move(src, dst)**

递归的去移动文件，它类似mv命令，其实就是重命名。

```plain
import shutil
shutil.move('folder1', 'folder3')
```

**shutil.make_archive(base_name, format,...)**

创建压缩包并返回文件路径，例如：zip、tar

创建压缩包并返回文件路径，例如：zip、tar

* base_name： 压缩包的文件名，也可以是压缩包的路径。只是文件名时，则保存至当前目录，否则保存至指定路径，

如 data_bak =>保存至当前路径

如：/tmp/data_bak =>保存至/tmp/

* format： 压缩包种类，“zip”, “tar”, “bztar”，“gztar”
* root_dir： 要压缩的文件夹路径（默认当前目录）
* owner： 用户，默认当前用户
* group： 组，默认当前组
* logger： 用于记录日志，通常是logging.Logger对象

```plain
#将 /data 下的文件打包放置当前程序目录
import shutil
ret = shutil.make_archive("data_bak", 'gztar', root_dir='/data')
#将 /data下的文件打包放置 /tmp/目录
import shutil
ret = shutil.make_archive("/tmp/data_bak", 'gztar', root_dir='/data')
```

shutil 对压缩包的处理是调用 ZipFile 和 TarFile 两个模块来进行的，详细：

zipfile压缩&解压缩

```plain
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
```

tarfile压缩&解压缩

```plain
import tarfile
# 压缩
>>> t=tarfile.open('/tmp/egon.tar','w')
>>> t.add('/test1/a.py',arcname='a.bak')
>>> t.add('/test1/b.py',arcname='b.bak')
>>> t.close()
# 解压
>>> t=tarfile.open('/tmp/egon.tar','r')
>>> t.extractall('/egon')
>>> t.close()
```

# 4.7 json & pickle 模块

## 本节重点：

* 使学员掌握json\&pickle模块的使用

> **本节时长需控制在20分钟内**

#### 什么叫序列化？

序列化是指把内存里的数据类型转变成字符串，以使其能存储到硬盘或通过网络传输到远程，因为硬盘或网络传输时只能接受bytes

#### 为什么要序列化？

你打游戏过程中，打累了，停下来，关掉游戏、想过2天再玩，2天之后，游戏又从你上次停止的地方继续运行，你上次游戏的进度肯定保存在硬盘上了，是以何种形式呢？游戏过程中产生的很多临时数据是不规律的，可能在你关掉游戏时正好有10个列表，3个嵌套字典的数据集合在内存里，需要存下来？你如何存？把列表变成文件里的多行多列形式？那嵌套字典呢？根本没法存。所以，若是有种办法可以直接把内存数据存到硬盘上，下次程序再启动，再从硬盘上读回来，还是原来的格式的话，那是极好的。

用于序列化的两个模块

* json，用于字符串 和 python数据类型间进行转换
* pickle，用于python特有的类型 和 python的数据类型间进行转换

Json模块提供了四个功能：dumps、dump、loads、load

pickle模块提供了四个功能：dumps、dump、loads、load

```plain
import pickle
data = {'k1':123,'k2':'Hello'}
# pickle.dumps 将数据通过特殊的形式转换位只有python语言认识的字符串
p_str = pickle.dumps(data)
print(p_str)
#pickle.dump 将数据通过特殊的形式转换位只有python语言认识的字符串，并写入文件
with open('D:/result.pk','wb',encoding='utf8') as fp:
    pickle.dump(data,fp)
import json
# json.dumps 将数据通过特殊的形式转换位所有程序语言都认识的字符串
j_str = json.dumps(data)
print(j_str)
#pickle.dump 将数据通过特殊的形式转换位只有python语言认识的字符串，并写入文件
with open('D:/result.json','wb',encoding='utf8') as fp:
    json.dump(data,fp)
```

#### json vs pickle:

**JSON:**

优点：跨语言、体积小

缺点：只能支持int\str\list\tuple\dict

**Pickle:**

优点：专为python设计，支持python所有的数据类型

缺点：只能在python中使用，存储数据占空间大

# 4.8 shelve 模块

## 本节重点：

* 使学员掌握shelve模块的使用

> **本节时长需控制在10分钟内**

shelve模块是一个简单的k,v将内存数据通过文件持久化的模块，可以持久化任何pickle可支持的python数据格式

**序列化：**

```plain
import shelve
f = shelve.open('shelve_test')  # 打开一个文件
names = ["alex", "rain", "test"]
info = {'name':'alex','age':22}
f["names"] = names  # 持久化列表
f['info_dic'] = info
f.close()
```

**反序列化：**

```plain
import shelve
d = shelve.open('shelve_test')  # 打开一个文件
print(d['names'])
print(d['info_dic'])
#del d['test'] #还可以删除
```

# 4.9 xml 模块

## 本节重点：

* 使学员掌握xml模块的使用

> **本节时长需控制在15分钟内**

xml是实现不同语言或程序之间进行数据交换的协议，跟json差不多，但json使用起来更简单，不过，古时候，在json还没诞生的黑暗年代，大家只能选择用xml呀，至今很多传统公司如金融行业的很多系统的接口还主要是xml。

xml的格式如下，就是通过<>节点来区别数据结构的:

```plain
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

xml协议在各个语言里的都 是支持的，在python中可以用以下模块操作xml 　　

```plain
import xml.etree.ElementTree as ET
tree = ET.parse("xmltest.xml")
root = tree.getroot()
print(root.tag)
#遍历xml文档
for child in root:
    print(child.tag, child.attrib)
    for i in child:
        print(i.tag,i.text)
#只遍历year 节点
for node in root.iter('year'):
    print(node.tag,node.text)
```

修改和删除xml文档内容

```plain
import xml.etree.ElementTree as ET
tree = ET.parse("xmltest.xml")
root = tree.getroot()
#修改
for node in root.iter('year'):
    new_year = int(node.text) + 1
    node.text = str(new_year)
    node.set("updated","yes")
tree.write("xmltest.xml")
#删除node
for country in root.findall('country'):
   rank = int(country.find('rank').text)
   if rank > 50:
     root.remove(country)
tree.write('output.xml')
```

自己创建xml文档

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

# 4.10 ConfigParser 模块

## 本节重点：

* 使学员掌握configparser模块的使用

> **本节时长需控制在15分钟内**

此模块用于生成和修改常见配置文档，当前模块的名称在 python 3.x 版本中变更为 configparser。

来看一个好多软件的常见配置文件格式如下

````plain
```cnf
[DEFAULT]
ServerAliveInterval = 45   
Compression = yes
CompressionLevel = 9
ForwardX11 = yes
[bitbucket.org]
User = hg
[topsecret.server.com]
Port = 50022
ForwardX11 = no
````

````

解析配置文件

```plain
```py
>>> import configparser # 导入模块
>>> config = configparser.ConfigParser()  #实例化(生成对象)
>>> config.sections()  #调用sections方法
[]
>>> config.read('example.ini')  # 读配置文件(注意文件路径)
['example.ini']
>>> config.sections() #调用sections方法(默认不会读取default)
['bitbucket.org', 'topsecret.server.com']
>>> 'bitbucket.org' in config #判断元素是否在sections列表内
True
>>> 'bytebong.com' in config
False
>>> config['bitbucket.org']['User'] # 通过字典的形式取值
'hg'
>>> config['DEFAULT']['Compression']
'yes'
>>> topsecret = config['topsecret.server.com']
>>> topsecret['ForwardX11']
'no'
>>> topsecret['Port']
'50022'
>>> for key in config['bitbucket.org']: print(key) # for循环 bitbucket.org 字典的key
...
user
compressionlevel
serveraliveinterval
compression
forwardx11
>>> config['bitbucket.org']['ForwardX11']
'yes'
````

````

其它增删改查语法

```plain
```python
[group1] # 支持的两种分隔符“=”, “:”
k1 = v1
k2:v2
[group2]
k1 = v1
import ConfigParser
config = ConfigParser.ConfigParser()
config.read('i.cfg')
# ########## 读 ##########
#secs = config.sections()
#print(secs)
#options = config.options('group2') # 获取指定section的keys
#print(options)
#item_list = config.items('group2') # 获取指定 section 的 keys & values ,key value 以元组的形式
#print(item_list)
#val = config.get('group1','key') # 获取指定的key 的value
#val = config.getint('group1','key')
# ########## 改写 ##########
#sec = config.remove_section('group1') # 删除section 并返回状态(true, false)
#config.write(open('i.cfg', "w")) # 对应的删除操作要写入文件才会生效
#sec = config.has_section('wupeiqi')
#sec = config.add_section('wupeiqi')
#config.write(open('i.cfg', "w")) # 
#config.set('group2','k1',11111)
#config.write(open('i.cfg', "w"))
#config.remove_option('group2','age')
#config.write(open('i.cfg', "w"))
````

````

# 4.11 hashlib 模块
## 本节重点：
+ 使学员掌握hashlib模块的使用

> **本节时长需控制在30分钟内**
>

## 加密算法介绍
### HASH
Hash，一般翻译做“散列”，也有直接音译为”哈希”的，就是把任意长度的输入（又叫做预映射，pre-image），通过散列算法，变换成固定长度的输出，该输出就是散列值。这种转换是一种压缩映射，也就是，散列值的空间通常远小于输入的空间，不同的输入可能会散列成相同的输出，而不可能从散列值来唯一的确定输入值。

简单的说就是一种将任意长度的消息压缩到某一固定长度的消息摘要的函数。

HASH主要用于信息安全领域中加密算法，他把一些不同长度的信息转化成杂乱的128位的编码里,叫做HASH值.也可以说，hash就是找到一种数据内容和数据存放地址之间的映射关系

### MD5
**什么是MD5算法**

MD5讯息摘要演算法（英语：MD5 Message-Digest Algorithm），一种被广泛使用的密码杂凑函数，可以产生出一个128位的散列值（hash value），用于确保信息传输完整一致。MD5的前身有MD2、MD3和MD4。

**MD5功能**

输入任意长度的信息，经过处理，输出为128位的信息（数字指纹）；

不同的输入得到的不同的结果（唯一性）；

**MD5算法的特点**

1. 压缩性：任意长度的数据，算出的MD5值的长度都是固定的
2. 容易计算：从原数据计算出MD5值很容易
3. 抗修改性：对原数据进行任何改动，修改一个字节生成的MD5值区别也会很大
4. 强抗碰撞：已知原数据和MD5，想找到一个具有相同MD5值的数据（即伪造数据）是非常困难的。

**MD5算法是否可逆？**

MD5不可逆的原因是其是一种散列函数，使用的是hash算法，在计算过程中原文的部分信息是丢失了的。

**MD5用途**

1. 防止被篡改：
- 比如发送一个电子文档，发送前，我先得到MD5的输出结果a。然后在对方收到电子文档后，对方也得到一个MD5的输出结果b。如果a与b一样就代表中途未被篡改。
- 比如我提供文件下载，为了防止不法分子在安装程序中添加木马，我可以在网站上公布由安装文件得到的MD5输出结果。
- SVN在检测文件是否在CheckOut后被修改过，也是用到了MD5.
2. 防止直接看到明文：
- 现在很多网站在数据库存储用户的密码的时候都是存储用户密码的MD5值。这样就算不法分子得到数据库的用户密码的MD5值，也无法知道用户的密码。（比如在UNIX系统中用户的密码就是以MD5（或其它类似的算法）经加密后存储在文件系统中。当用户登录的时候，系统把用户输入的密码计算成MD5值，然后再去和保存在文件系统中的MD5值进行比较，进而确定输入的密码是否正确。通过这样的步骤，系统在并不知道用户密码的明码的情况下就可以确定用户登录系统的合法性。这不但可以避免用户的密码被具有系统管理员权限的用户知道，而且还在一定程度上增加了密码被破解的难度。）
3. 防止抵赖（数字签名）：
- 这需要一个第三方认证机构。例如A写了一个文件，认证机构对此文件用MD5算法产生摘要信息并做好记录。若以后A说这文件不是他写的，权威机构只需对此文件重新产生摘要信息，然后跟记录在册的摘要信息进行比对，相同的话，就证明是A写的了。这就是所谓的“数字签名”。

### SHA-1
安全哈希算法（Secure Hash Algorithm）主要适用于数字签名标准（Digital Signature Standard DSS）里面定义的数字签名算法（Digital Signature Algorithm DSA）。对于长度小于2^64位的消息，SHA1会产生一个160位的消息摘要。当接收到消息的时候，这个消息摘要可以用来验证数据的完整性。

SHA是美国国家安全局设计的，由美国国家标准和技术研究院发布的一系列密码散列函数。

由于MD5和SHA-1于2005年被山东大学的教授王小云破解了，科学家们又推出了SHA224, SHA256, SHA384, SHA512，当然位数越长，破解难度越大，但同时生成加密的消息摘要所耗时间也更长。**目前最流行的是加密算法是SHA-256 .**

### MD5与SHA-1的比较
由于MD5与SHA-1均是从MD4发展而来，它们的结构和强度等特性有很多相似之处，SHA-1与MD5的最大区别在于其摘要比MD5摘要长32 比特。对于强行攻击，产生任何一个报文使之摘要等于给定报文摘要的难度：MD5是2128数量级的操作，SHA-1是2160数量级的操作。产生具有相同摘要的两个报文的难度：MD5是264是数量级的操作，SHA-1 是280数量级的操作。因而,SHA-1对强行攻击的强度更大。但由于SHA-1的循环步骤比MD5多80:64且要处理的缓存大160比特:128比特，SHA-1的运行速度比MD5慢。

## Python的 提供的相关模块
用于加密相关的操作，3.x里代替了md5模块和sha模块，主要提供 SHA1, SHA224, SHA256, SHA384, SHA512 ，MD5 算法

```plain
import hashlib
m = hashlib.md5()
m.update(b"Hello")
m.update(b"It's me")
print(m.digest())
m.update(b"It's been a long time since last time we ...")
print(m.digest()) #2进制格式hash
print(len(m.hexdigest())) #16进制格式hash
'''
def digest(self, *args, **kwargs): # real signature unknown
    """ Return the digest value as a string of binary data. """
    pass
def hexdigest(self, *args, **kwargs): # real signature unknown
    """ Return the digest value as a string of hexadecimal digits. """
    pass
'''
import hashlib
# ######## md5 ########
hash = hashlib.md5()
hash.update('admin')
print(hash.hexdigest())
# ######## sha1 ########
hash = hashlib.sha1()
hash.update('admin')
print(hash.hexdigest())
# ######## sha256 ########
hash = hashlib.sha256()
hash.update('admin')
print(hash.hexdigest())
# ######## sha384 ########
hash = hashlib.sha384()
hash.update('admin')
print(hash.hexdigest())
# ######## sha512 ########
hash = hashlib.sha512()
hash.update('admin')
print(hash.hexdigest())
````

# 4.12 subprocess 模块

## 本节重点：

* 使学员掌握subprocess模块的使用

> **本节时长需控制在20分钟内**

我们经常需要通过Python去执行一条系统命令或脚本，系统的shell命令是独立于你的python进程之外的，每执行一条命令，就是发起一个新进程，通过python调用系统命令或脚本的模块在python2有os.system，

```plain
>>> os.system('uname -a')
Darwin Alexs-MacBook-Pro.local 15.6.0 Darwin Kernel Version 15.6.0: Sun Jun  4 21:43:07 PDT 2017; root:xnu-3248.70.3~1/RELEASE_X86_64 x86_64
0
```

这条命令的实现原理是什么呢？(视频中讲，解释进程间通信的问题...)

除了os.system可以调用系统命令，,commands,popen2等也可以，比较乱，于是官方推出了subprocess,目地是提供统一的模块来实现对系统命令或脚本的调用

The subprocess module allows you to spawn new processes, connect to their input/output/error pipes, and obtain their return codes. This module intends to replace several older modules and functions:

* os.system
* os.spawn\*

The recommended approach to invoking subprocesses is to use the run() function for all use cases it can handle. For more advanced use cases, the underlying Popen interface can be used directly.

The run() function was added in Python 3.5; if you need to retain compatibility with older versions, see the Older high-level API section.

**三种执行命令的方法**

* subprocess.run(\*popenargs, input=None, timeout=None, check=False, \*\*kwargs) #官方推荐
* subprocess.call(\*popenargs, timeout=None, \*\*kwargs) #跟上面实现的内容差不多，另一种写法
* subprocess.Popen() #上面各种方法的底层封装

#### run()方法

Run command with arguments and return a CompletedProcess instance.The returned instance will have attributes args, returncode, stdout and stderr. By default, stdout and stderr are not captured, and those attributes will be None. Pass stdout=PIPE and/or stderr=PIPE in order to capture them.

If check is True and the exit code was non-zero, it raises a CalledProcessError. The CalledProcessError object will have the return code in the returncode attribute, and output & stderr attributes if those streams were captured.

If timeout is given, and the process takes too long, a TimeoutExpired exception will be raised.

The other arguments are the same as for the Popen constructor.

**标准写法**

```plain
subprocess.run(['df','-h'],stderr=subprocess.PIPE,stdout=subprocess.PIPE,check=True)
```

**涉及到管道|的命令需要这样写**

```plain
subprocess.run('df -h|grep disk1',shell=True) #shell=True的意思是这条命令直接交给系统去执行，不需要python负责解析
```

#### call()方法

```plain
#执行命令，返回命令执行状态 ， 0 or 非0
>>> retcode = subprocess.call(["ls", "-l"])
#执行命令，如果命令结果为0，就正常返回，否则抛异常
>>> subprocess.check_call(["ls", "-l"])
0
#接收字符串格式命令，返回元组形式，第1个元素是执行状态，第2个是命令结果 
>>> subprocess.getstatusoutput('ls /bin/ls')
(0, '/bin/ls')
#接收字符串格式命令，并返回结果
>>> subprocess.getoutput('ls /bin/ls')
'/bin/ls'
#执行命令，并返回结果，注意是返回结果，不是打印，下例结果返回给res
>>> res=subprocess.check_output(['ls','-l'])
>>> res
b'total 0\ndrwxr-xr-x 12 alex staff 408 Nov 2 11:05 OldBoyCRM\n'
```

#### Popen()方法

常用参数：

* args：shell命令，可以是字符串或者序列类型（如：list，元组）
* stdin, stdout, stderr：分别表示程序的标准输入、输出、错误句柄
* preexec_fn：只在Unix平台下有效，用于指定一个可执行对象（callable object），它将在子进程运行之前被调用
* shell：同上
* cwd：用于设置子进程的当前目录
* env：用于指定子进程的环境变量。如果env = None，子进程的环境变量将从父进程中继承。

下面这2条语句执行会有什么区别？

```plain
a=subprocess.run('sleep 10',shell=True,stdout=subprocess.PIPE)
a=subprocess.Popen('sleep 10',shell=True,stdout=subprocess.PIPE)
```

区别是Popen会在发起命令后立刻返回，而不等命令执行结果。这样的好处是什么呢？

如果你调用的命令或脚本 需要执行10分钟，你的主程序不需卡在这里等10分钟，可以继续往下走，干别的事情，每过一会，通过一个什么方法来检测一下命令是否执行完成就好了。

Popen调用后会返回一个对象，可以通过这个对象拿到命令执行结果或状态等，该对象有以下方法

`poll()`

Check if child process has terminated. Returns returncode

`wait()`

Wait for child process to terminate. Returns returncode attribute.

`terminate()`终止所启动的进程Terminate the process with SIGTERM

`kill()` 杀死所启动的进程 Kill the process with SIGKILL

`communicate()`与启动的进程交互，发送数据到stdin,并从stdout接收输出，然后等待任务结束

```plain
>>> a = subprocess.Popen('python3 guess_age.py',stdout=subprocess.PIPE,stderr=subprocess.PIPE,stdin=subprocess.PIPE,shell=True)
>>> a.communicate(b'22')
(b'your guess:try bigger\n', b'')
```

`send_signal(signal.xxx)`发送系统信号

`pid` 拿到所启动进程的进程号

# 4.13 logging 模块

## 本节重点：

* 使学员掌握logging模块的使用

> **本节时长需控制在35分钟内**

很多程序都有记录日志的需求，并且日志中包含的信息即有正常的程序访问日志，还可能有错误、警告等信息输出，python的logging模块提供了标准的日志接口，你可以通过它存储各种格式的日志，logging的日志可以分为 `debug(), info(), warning(), error() and critical()`5个级别，下面我们看一下怎么用。

### 最简单用法

```plain
import logging
logging.warning("user [alex] attempted wrong password more than 3 times")
logging.critical("server is down")
```

输出

```plain
WARNING:root:user [alex] attempted wrong password more than 3 times
CRITICAL:root:server is down
```

看一下这几个日志级别分别代表什么意思

| Level | When it’s used |
| :--- | :--- |
| `DEBUG` | Detailed information, typically of interest only when diagnosing problems. |
| `INFO` | Confirmation that things are working as expected. |
| `WARNING` | An indication that something unexpected happened, or indicative of some problem in the near future (e.g. ‘disk space low’). The software is still working as expected. |
| `ERROR` | Due to a more serious problem, the software has not been able to perform some function. |
| `CRITICAL` | A serious error, indicating that the program itself may be unable to continue running. |

### 如果想把日志写到文件里，也很简单

```plain
import logging
logging.basicConfig(filename='example.log',level=logging.INFO)
logging.debug('This message should go to the log file')
logging.info('So should this')
logging.warning('And this, too')
```

其中下面这句中的level=loggin.INFO意思是，把日志纪录级别设置为INFO，也就是说，只有比日志是INFO或比INFO级别更高的日志才会被纪录到文件里，在这个例子， 第一条日志是不会被纪录的，如果希望纪录debug的日志，那把日志级别改成DEBUG就行了。

```plain
logging.basicConfig(filename='example.log',level=logging.INFO)
```

### 自定义日志格式

感觉上面的日志格式忘记加上时间啦，日志不知道时间怎么行呢，下面就来加上!

```plain
import logging
logging.basicConfig(format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')
logging.warning('is when this event was logged.')
#输出
12/12/2010 11:46:36 AM is when this event was logged.
```

除了加时间，还可以自定义一大堆格式，下表就是所有支持的格式

| %(name)s | Logger的名字 |
| :--- | :--- |
| %(levelno)s | 数字形式的日志级别 |
| %(levelname)s | 文本形式的日志级别 |
| %(pathname)s | 调用日志输出函数的模块的完整路径名，可能没有 |
| %(filename)s | 调用日志输出函数的模块的文件名 |
| %(module)s | 调用日志输出函数的模块名 |
| %(funcName)s | 调用日志输出函数的函数名 |
| %(lineno)d | 调用日志输出函数的语句所在的代码行 |
| %(created)f | 当前时间，用UNIX标准的表示时间的浮 点数表示 |
| %(relativeCreated)d | 输出日志信息时的，自Logger创建以 来的毫秒数 |
| %(asctime)s | 字符串形式的当前时间。默认格式是 “2003-07-08 16:49:45,896”。逗号后面的是毫秒 |
| %(thread)d | 线程ID。可能没有 |
| %(threadName)s | 线程名。可能没有 |
| %(process)d | 进程ID。可能没有 |
| %(message)s | 用户输出的消息 |

### 日志同时输出到屏幕和文件

如果想同时把log打印在屏幕和文件日志里，就需要了解一点复杂的知识 了

Python 使用logging模块记录日志涉及四个主要类，使用官方文档中的概括最为合适：

* **logger提供了应用程序可以直接使用的接口；**
* **handler将(logger创建的)日志记录发送到合适的目的输出；**
* **filter提供了细度设备来决定输出哪条日志记录；**
* **formatter决定日志记录的最终输出格式。**

#### 他们之间的关系是这样的

<!-- OCR_START -->
Pythonlogging模块流程图
by路飞学城
Handler
Formatter对象1
logging.Formatter(%(asctime)s - %(name)s - %(levelname)s - %(message)s')
绑定到handler
StreamHandlerO输出至屏幕
Formatter对象2
logging.Formatter(%(asctime)s - %(name)s - %(lineno)d - %(message)s')
FileHandler(mysql.log输出至文件
logger.addHandlerO
Filters对象
日志内容中只要包含network attack字符的纪录
Logger对象
添加到logger
logger = logging.getLogger("Mysql")
logger.debug("test ....")
logger.info("test info ...")
logger.warning("network attack is coming..")
logger.error("test error....")
<!-- OCR_END -->

每个组件的主要功能

#### **logger**

每个程序在输出信息之前都要获得一个Logger。Logger通常对应了程序的模块名，比如聊天工具的图形界面模块可以这样获得它的Logger：

```plain
LOG=logging.getLogger(”chat.gui”)
```

而核心模块可以这样：

```plain
LOG=logging.getLogger(”chat.kernel”)
```

还可以绑定handler和filters

```plain
Logger.setLevel(lel):指定最低的日志级别，低于lel的级别将被忽略。debug是最低的内置级别，critical为最高
Logger.addFilter(filt)、Logger.removeFilter(filt):添加或删除指定的filter
Logger.addHandler(hdlr)、Logger.removeHandler(hdlr)：增加或删除指定的handler
```

Logger.debug()、Logger.info()、Logger.warning()、Logger.error()、Logger.critical()：可以设置的日志级别

#### **handler**

handler对象负责发送相关的信息到指定目的地。Python的日志系统有多种Handler可以使用。有些Handler可以把信息输出到控制台，有些Handler可以把信息输出到文件，还有些 Handler可以把信息发送到网络上。如果觉得不够用，还可以编写自己的Handler。可以通过addHandler()方法添加多个多handler

```plain
Handler.setLevel(lel):指定被处理的信息级别，低于lel级别的信息将被忽略
Handler.setFormatter()：给这个handler选择一个格式
Handler.addFilter(filt)、Handler.removeFilter(filt)：新增或删除一个filter对象
```

每个Logger可以附加多个Handler。接下来我们就来介绍一些常用的Handler：

1. **logging.StreamHandler** 使用这个Handler可以向类似与sys.stdout或者sys.stderr的任何文件对象(file object)输出信息。
2. \*\*logging.FileHandler \*\*和StreamHandler 类似，用于向一个文件输出日志信息。不过FileHandler会帮你打开这个文件
3. **logging.handlers.RotatingFileHandler**这个Handler类似于上面的FileHandler，但是它可以管理文件大小。当文件达到一定大小之后，它会自动将当前日志文件改名，然后创建 一个新的同名日志文件继续输出。比如日志文件是chat.log。当chat.log达到指定的大小之后，RotatingFileHandler自动把 文件改名为chat.log.1。不过，如果chat.log.1已经存在，会先把chat.log.1重命名为chat.log.2。。。最后重新创建 chat.log，继续输出日志信息。它的函数是：

```plain
RotatingFileHandler( filename[, mode[, maxBytes[, backupCount]]])
```

1. 其中filename和mode两个参数和FileHandler一样。
   * maxBytes用于指定日志文件的最大文件大小。如果maxBytes为0，意味着日志文件可以无限大，这时上面描述的重命名过程就不会发生。
   * backupCount用于指定保留的备份文件的个数。比如，如果指定为2，当上面描述的重命名过程发生时，原有的chat.log.2并不会被更名，而是被删除。
2. **logging.handlers.TimedRotatingFileHandler**这个Handler和RotatingFileHandler类似，不过，它没有通过判断文件大小来决定何时重新创建日志文件，而是间隔一定时间就 自动创建新的日志文件。重命名的过程与RotatingFileHandler类似，不过新的文件不是附加数字，而是当前时间。它的函数是：

```plain
TimedRotatingFileHandler( filename [,when [,interval [,backupCount]]])
```

1. 其中filename参数和backupCount参数和RotatingFileHandler具有相同的意义。`interval`是时间间隔。`when`参数是一个字符串。表示时间间隔的单位，不区分大小写。它有以下取值：
   * S 秒
   * M 分
   * H 小时
   * D 天
   * W 每星期（interval==0时代表星期一）
   * midnight 每天凌晨

#### **formatter 组件**

日志的formatter是个独立的组件，可以跟handler组合

```plain
fh = logging.FileHandler("access.log")
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter) #把formmater绑定到fh上
```

#### filter 组件

如果你想对日志内容进行过滤，就可自定义一个filter

```plain
class IgnoreBackupLogFilter(logging.Filter):
    """忽略带db backup 的日志"""
    def filter(self, record): #固定写法
        return   "db backup" not in record.getMessage()
```

> 注意filter函数会返加True or False，logger根据此值决定是否输出此日志

然后把这个filter添加到logger中

```plain
logger.addFilter(IgnoreBackupLogFilter())
```

下面的日志就会把符合filter条件的过滤掉

```plain
logger.debug("test ....")
logger.info("test info ....")
logger.warning("start to run db backup job ....")
logger.error("test error ....")
```

一个同时输出到屏幕、文件、带filter的完成例子

```plain
import logging
class IgnoreBackupLogFilter(logging.Filter):
    """忽略带db backup 的日志"""
    def filter(self, record): #固定写法
        return   "db backup" not in record.getMessage()
#console handler
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
#file handler
fh = logging.FileHandler('mysql.log')
#fh.setLevel(logging.WARNING)
#formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
#bind formatter to ch
ch.setFormatter(formatter)
fh.setFormatter(formatter)
logger = logging.getLogger("Mysql")
logger.setLevel(logging.DEBUG) #logger 优先级高于其它输出途径的
#add handler   to logger instance
logger.addHandler(ch)
logger.addHandler(fh)
#add filter
logger.addFilter(IgnoreBackupLogFilter())
logger.debug("test ....")
logger.info("test info ....")
logger.warning("start to run db backup job ....")
logger.error("test error ....")
```

文件自动截断例子

```plain
import logging
from logging import handlers
logger = logging.getLogger(__name__)
log_file = "timelog.log"
#fh = handlers.RotatingFileHandler(filename=log_file,maxBytes=10,backupCount=3)
fh = handlers.TimedRotatingFileHandler(filename=log_file,when="S",interval=5,backupCount=3)
formatter = logging.Formatter('%(asctime)s %(module)s:%(lineno)d %(message)s')
fh.setFormatter(formatter)
logger.addHandler(fh)
logger.warning("test1")
logger.warning("test12")
logger.warning("test13")
logger.warning("test14")
```

## python日志重复输出

### 问题起源：

在学习了python的函数式编程后，又接触到了logging这样一个强大的日志模块。为了减少重复代码，应该不少同学和我一样便迫不及待的写了一个自己的日志函数，比如下面这样：

```plain
# 这里为了便于理解，简单的展示了一个输出到屏幕的日志函数
def my_log():
    logger = logging.getLogger('mysql.log')
    ch = logging.StreamHandler()
    ch.setLevel(logging.ERROR)
    fmt = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(fmt)
    logger.addHandler(ch)
    return logger
my_log().error('run one')
my_log().error('run two')
my_log().error('run three')
```

函数写好了，看起来似乎也没有问题，我们来运行一下！

结果如下：

```plain
2018-06-21 13:06:37,569 - mysql.log - ERROR - run one
2018-06-21 13:06:37,569 - mysql.log - ERROR - run two
2018-06-21 13:06:37,569 - mysql.log - ERROR - run two
2018-06-21 13:06:37,569 - mysql.log - ERROR - run three
2018-06-21 13:06:37,569 - mysql.log - ERROR - run three
2018-06-21 13:06:37,569 - mysql.log - ERROR - run three
```

日志居然重复输出了，且数量递增。

### 问题解析

实际上`logger = logging.getLogger('mysql.log')`在执行时，没有每次生成一个新的logger，而是先检查内存中是否存在一个叫做‘mysql.log’的logger对象，存在则取出，不存在则新建。

实例化的logger对象具有‘handlers’这样一个属性来存储 Handler，代码演示如下：

```plain
def my_log():
    logger = logging.getLogger('mysql.log')
    # 每次被调用后打印出logger的handlers列表
    print(logger.handlers)
    ch = logging.StreamHandler()
    ch.setLevel(logging.ERROR)
    fmt = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(fmt)
    logger.addHandler(ch)
    return logger
my_log().error('run one')
my_log().error('run two')
my_log().error('run three')
```

运行结果：

```plain
[]
2018-06-21 13:26:14,059 - mysql.log - ERROR - run one
[<StreamHandler <stderr> (ERROR)>]
2018-06-21 13:26:14,060 - mysql.log - ERROR - run two
2018-06-21 13:26:14,060 - mysql.log - ERROR - run two
[<StreamHandler <stderr> (ERROR)>, <StreamHandler <stderr> (ERROR)>]
2018-06-21 13:26:14,060 - mysql.log - ERROR - run three
2018-06-21 13:26:14,060 - mysql.log - ERROR - run three
2018-06-21 13:26:14,060 - mysql.log - ERROR - run three
```

1. logger.handlers最初是一个空列表，执行‘logger.addHandler(ch)’添加个‘StreamHandler’，输出一条日志
2. 在第二次被调用时，logger.handlers已经存在一个‘StreamHandler’，再次执行‘logger.addHandler(ch)’就会再次添加一个‘StreamHandler’，此时的logger有两个个‘StreamHandler’，输出两条重复的日志
3. 在第三次被调用时，logger.handlers已经存在两个‘StreamHandler’，再次执行‘logger.addHandler(ch)’就会再次添加一个，此时的logger有三个‘StreamHandler’，输出三条重复的日志

### 解决办法

#### 1. 改名换姓

```plain
# 为日志函数添加一个name，每次调用时传入不同的日志名
def my_log(name):
    logger = logging.getLogger(name)
    ch = logging.StreamHandler()
    ch.setLevel(logging.ERROR)
    fmt = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(fmt)
    logger.addHandler(ch)
    return logger
my_log('log1').error('run one')
my_log('log2').error('run two')
my_log('log3').error('run three')
```

运行结果：

```plain
2018-06-21 13:40:51,685 - log1 - ERROR - run one
2018-06-21 13:40:51,685 - log2 - ERROR - run two
2018-06-21 13:40:51,685 - log3 - ERROR - run three
```

#### 2.及时清理（logger.handlers.clear）

```plain
def my_log():
    logger = logging.getLogger()
    # 每次被调用后，清空已经存在handler
    logger.handlers.clear()
    ch = logging.StreamHandler()
    ch.setLevel(logging.ERROR)
    fmt = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(fmt)
    logger.addHandler(ch)
    return logger
my_log().error('run one')
my_log().error('run two')
my_log().error('run three')
```

**ps：removeHandler方法（兼容性较差）**

```plain
# 这种写法下的可以使用removeHandler方法(logger.handlers.clear也可以使用在这种写法的函数内)
import logging
def my_log(msg):
    logger = logging.getLogger('mysql.log')
    ch = logging.StreamHandler()
    ch.setLevel(logging.ERROR)
    fmt = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(fmt)
    logger.addHandler(ch)
    logger.error(msg)
    # 在使用完ch后从移除
    logger.removeHandler(ch)
my_log('run one')
my_log('run two')
my_log('run three')
```

#### 3.用前判断

```plain
import logging
def my_log():
    logger = logging.getLogger('mysql.log')
    # 判断logger是否已经添加过handler，是则直接返回logger对象，否则执行handler设定以及addHandler(ch)
    if not logger.handlers:
        ch = logging.StreamHandler()
        ch.setLevel(logging.ERROR)
        fmt = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        ch.setFormatter(fmt)
        logger.addHandler(ch)
    return logger
my_log().error('run one')
my_log().error('run two')
my_log().error('run three')
```

### 总结

第一次遇到日志重复输出问题，那时还没有学习到面向对象编程的内容，当时并没有真正理解logging模块。学习完面向对象编程后，回过头来再思考这些问题有了豁然开朗的感觉。

比如起初对`logging.getLogger`的实际原理不是很理解，在学习了面向对象编程中的hasattr、getattr、setattr这样一些方法后就恍然大悟了。所以诸君如果现在还是对logging模块不太理解，不妨先不纠结于这些细节，继续学下去。

知识面扩充后，曾经的一些难题自然就会迎刃而解：）

***注：转载路飞学员***[***https://www.jianshu.com/p/92aa9b1ce9e7***](https://www.jianshu.com/p/92aa9b1ce9e7)

*\*\*\*\**

# 4.14 re模块

## 本节重点：

* 使学员掌握re模块的使用

> **本节时长需控制在50分钟内**

## 引子

请从以下文件里取出所有的手机号

```plain
姓名        地区    身高    体重    电话
况咏蜜     北京    171    48    13651054608
王心颜     上海    169    46    13813234424
马纤羽     深圳    173    50    13744234523
乔亦菲     广州    172    52    15823423525
罗梦竹     北京    175    49    18623423421
刘诺涵     北京    170    48    18623423765
岳妮妮     深圳    177    54    18835324553
贺婉萱     深圳    174    52    18933434452
叶梓萱    上海    171    49    18042432324
杜姗姗   北京    167    49       13324523342
```

你能想到的办法是什么？

必然是下面这种吧？

```plain
f = open("兼职白领学生空姐模特护士联系方式.txt",'r',encoding="gbk")
phones = []
for line in f:
    name,city,height,weight,phone = line.split()
    if phone.startswith('1') and len(phone) == 11:
        phones.append(phone)
print(phones)
```

有没有更简单的方式？

手机号是有规则的，都是数字且是11位，再严格点，就都是1开头，如果能把这样的规则写成代码，直接拿规则代码匹配文件内容不就行了？

<!-- OCR_START -->
importre
f=open（"兼职白领学生空姐模特护士联系方式.txt"，'r'，encoding="gbk"）
data = f.read()
phones = re.findall("[0-9]{11}", data)
print(phones)
re模块
/usr/local/bin/python3.5/Users/alex/Documents/work/PyProjects/luffy_课件/21天入门/chapter4-常用模块/re模块.py
['13651054608′，‘13813234424'，‘13744234523'，‘15823423525'，‘18623423421'，‘18623423765'，‘18835324553'，‘18933434452'，‘18042432324'，‘13324523342']
Process finished with exit code 0
<!-- OCR_END -->

这么nb的玩法是什么？它的名字叫正则表达式！

## re模块

正则表达式就是字符串的匹配规则，在多数编程语言里都有相应的支持，python里对应的模块是re

#### 常用的表达式规则

```plain
'.'     默认匹配除\n之外的任意一个字符，若指定flag DOTALL,则匹配任意字符，包括换行
'^'     匹配字符开头，若指定flags MULTILINE,这种也可以匹配上(r"^a","\nabc\neee",flags=re.MULTILINE)
'$'     匹配字符结尾， 若指定flags MULTILINE ,re.search('foo.$','foo1\nfoo2\n',re.MULTILINE).group() 会匹配到foo1
'*'     匹配*号前的字符0次或多次， re.search('a*','aaaabac')  结果'aaaa'
'+'     匹配前一个字符1次或多次，re.findall("ab+","ab+cd+abb+bba") 结果['ab', 'abb']
'?'     匹配前一个字符1次或0次 ,re.search('b?','alex').group() 匹配b 0次
'{m}'   匹配前一个字符m次 ,re.search('b{3}','alexbbbs').group()  匹配到'bbb'
'{n,m}' 匹配前一个字符n到m次，re.findall("ab{1,3}","abb abc abbcbbb") 结果'abb', 'ab', 'abb']
'|'     匹配|左或|右的字符，re.search("abc|ABC","ABCBabcCD").group() 结果'ABC'
'(...)' 分组匹配， re.search("(abc){2}a(123|45)", "abcabca456c").group() 结果为'abcabca45'
'\A'    只从字符开头匹配，re.search("\Aabc","alexabc") 是匹配不到的，相当于re.match('abc',"alexabc") 或^
'\Z'    匹配字符结尾，同$ 
'\d'    匹配数字0-9
'\D'    匹配非数字
'\w'    匹配[A-Za-z0-9]
'\W'    匹配非[A-Za-z0-9]
's'     匹配空白字符、\t、\n、\r , re.search("\s+","ab\tc1\n3").group() 结果 '\t'
'(?P<name>...)' 分组匹配 re.search("(?P<province>[0-9]{4})(?P<city>[0-9]{2})(?P<birthday>[0-9]{4})","371481199306143242").groupdict("city") 结果{'province': '3714', 'city': '81', 'birthday': '1993'}
```

#### re的匹配语法有以下几种

* re.match 从头开始匹配
* re.search 匹配包含
* re.findall 把所有匹配到的字符放到以列表中的元素返回
* re.split 以匹配到的字符当做列表分隔符
* re.sub 匹配字符并替换
* re.fullmatch 全部匹配

**re.compile(pattern, flags=0)**

Compile a regular expression pattern into a regular expression object, which can be used for matching using its match(), search() and other methods, described below.

The sequence

```plain
prog = re.compile(pattern)
result = prog.match(string)
```

is equivalent to

```plain
result = re.match(pattern, string)
```

but using re.compile() and saving the resulting regular expression object for reuse is more efficient when the expression will be used several times in a single program.

**re.match(pattern, string, flags=0)**

从起始位置开始根据模型去字符串中匹配指定内容，匹配单个

* pattern 正则表达式
* string 要匹配的字符串
* flags 标志位，用于控制正则表达式的匹配方式

```plain
import re
obj = re.match('\d+', '123uuasf')
if obj:
    print obj.group()
```

**Flags标志符**

* re.I(re.IGNORECASE): 忽略大小写（括号内是完整写法，下同）
* M(MULTILINE): 多行模式，改变'^'和'$'的行为
* S(DOTALL): 改变'.'的行为,make the '.' special character match any character at all, including a newline; without this flag, '.' will match anything except a newline.
* X(re.VERBOSE) 可以给你的表达式写注释，使其更可读，下面这2个意思一样

```plain
a = re.compile(r"""\d + # the integral part
                \. # the decimal point
                \d * # some fractional digits""", 
                re.X)
b = re.compile(r"\d+\.\d*")
```

**re.search(pattern, string, flags=0)**

根据模型去字符串中匹配指定内容，匹配单个

```plain
import re
obj = re.search('\d+', 'u123uu888asf')
if obj:
    print obj.group()
```

**re.findall(pattern, string, flags=0)**

match and search均用于匹配单值，即：只能匹配字符串中的一个，如果想要匹配到字符串中所有符合条件的元素，则需要使用 findall。

```plain
import re
obj = re.findall('\d+', 'fa123uu888asf')
print obj
```

**re.sub(pattern, repl, string, count=0, flags=0)**

用于替换匹配的字符串

```plain
>>>re.sub('[a-z]+','sb','武配齐是abc123',)
>>> re.sub('\d+','|', 'alex22wupeiqi33oldboy55',count=2)
'alex|wupeiqi|oldboy55'
```

相比于str.replace功能更加强大

**re.split(pattern, string, maxsplit=0, flags=0)**

```plain
>>>s='9-2*5/3+7/3*99/4*2998+10*568/14'
>>>re.split('[\*\-\/\+]',s)
['9', '2', '5', '3', '7', '3', '99', '4', '2998', '10', '568', '14']
>>> re.split('[\*\-\/\+]',s,3)
['9', '2', '5', '3+7/3*99/4*2998+10*568/14']
```

**re.fullmatch(pattern, string, flags=0)**

整个字符串匹配成功就返回re object, 否则返回None

```plain
re.fullmatch('\w+@\w+\.(com|cn|edu)',"alex@oldboyedu.cn")
```

#### 练习：

1.验证手机号是否合法

2.验证邮箱是否合法

3.开发一个简单的python计算器，实现加减乘除及拓号优先级解析

* 用户输入 1 - 2 \* ( (60-30 +(-40/5) \* (9-2*5/3 + 7 /3*99/4*2998 +10 \* 568/14 )) - (-4*3)/ (16-3*2) )等类似公式后，必须自己解析里面的(),+,-,*,/符号和公式(不能调用eval等类似功能偷懒实现)，运算后得出结果，结果必须与真实的计算器所得出的结果一致

> hint:

```plain
re.search(r'\([^()]+\)',s).group()#可拿到最里层的括号中的值 
'(-40/5)'
```

# 4.15 软件开发目录规范

## 本节重点：

* 使学员理解在开发标准软件时如何布局项目目录结构，以及注意开发规范的重要性

> **本节时长需控制在15分钟内**

#### 为什么要设计好目录结构?

"设计项目目录结构"，就和"代码编码风格"一样，属于个人风格问题。对于这种风格上的规范，一直都存在两种态度:

1. 一类同学认为，这种个人风格问题"无关紧要"。理由是能让程序work就好，风格问题根本不是问题。
2. 另一类同学认为，规范化能更好的控制程序结构，让程序具有更高的可读性。

我是比较偏向于后者的，因为我是前一类同学思想行为下的直接受害者。我曾经维护过一个非常不好读的项目，其实现的逻辑并不复杂，但是却耗费了我非常长的时间去理解它想表达的意思。从此我个人对于提高项目可读性、可维护性的要求就很高了。"项目目录结构"其实也是属于"可读性和可维护性"的范畴，我们设计一个层次清晰的目录结构，就是为了达到以下两点:

1. **可读性高**: 不熟悉这个项目的代码的人，一眼就能看懂目录结构，知道程序启动脚本是哪个，测试目录在哪儿，配置文件在哪儿等等。从而非常快速的了解这个项目。
2. **可维护性高**: 定义好组织规则后，维护者就能很明确地知道，新增的哪个文件和代码应该放在什么目录之下。这个好处是，随着时间的推移，代码/配置的规模增加，项目结构不会混乱，仍然能够组织良好。

所以，我认为，保持一个层次清晰的目录结构是有必要的。更何况组织一个良好的工程目录，其实是一件很简单的事儿。

#### 目录组织方式

关于如何组织一个较好的Python工程目录结构，已经有一些得到了共识的目录结构。在Stackoverflow的[这个问题](http://stackoverflow.com/questions/193161/what-is-the-best-project-structure-for-a-python-application)上，能看到大家对Python目录结构的讨论。

这里面说的已经很好了，我也不打算重新造轮子列举各种不同的方式，这里面我说一下我的理解和体会。

假设你的项目名为foo, 我比较建议的最方便快捷目录结构这样就足够了:

```plain
Foo/
|-- bin/
|   |-- foo
|
|-- foo/
|   |-- tests/
|   |   |-- __init__.py
|   |   |-- test_main.py
|   |
|   |-- __init__.py
|   |-- main.py
|
|-- docs/
|   |-- conf.py
|   |-- abc.rst
|
|-- setup.py
|-- requirements.txt
|-- README
```

简要解释一下:

* bin/: 存放项目的一些可执行文件，当然你可以起名script/之类的也行。
* foo/: 存放项目的所有源代码。(1) 源代码中的所有模块、包都应该放在此目录。不要置于顶层目录。(2) 其子目录tests/存放单元测试代码； (3) 程序的入口最好命名为main.py。
* docs/: 存放一些文档。
* setup.py: 安装、部署、打包的脚本。
* requirements.txt: 存放软件依赖的外部Python包列表。
* README: 项目说明文件。

除此之外，有一些方案给出了更加多的内容。比如`LICENSE.txt`,`ChangeLog.txt`文件等，我没有列在这里，因为这些东西主要是项目开源的时候需要用到。如果你想写一个开源软件，目录该如何组织，可以参考[这篇文章](http://www.jeffknupp.com/blog/2013/08/16/open-sourcing-a-python-project-the-right-way/)。

下面，再简单讲一下我对这些目录的理解和个人要求吧。

#### 关于README的内容

**这个我觉得是每个项目都应该有的一个文件**，目的是能简要描述该项目的信息，让读者快速了解这个项目。

它需要说明以下几个事项:

1. 软件定位，软件的基本功能。
2. 运行代码的方法: 安装环境、启动命令等。
3. 简要的使用说明。
4. 代码目录结构说明，更详细点可以说明软件的基本原理。
5. 常见问题说明。

#### 关于requirements.txt和setup.py

#### setup.py

一般来说，用`setup.py`来管理代码的打包、安装、部署问题。业界标准的写法是用Python流行的打包工具[setuptools](https://pythonhosted.org/setuptools/setuptools.html#developer-s-guide)来管理这些事情。这种方式普遍应用于开源项目中。不过这里的核心思想不是用标准化的工具来解决这些问题，而是说，**一个项目一定要有一个安装部署工具**，能快速便捷的在一台新机器上将环境装好、代码部署好和将程序运行起来。

这个我是踩过坑的。

我刚开始接触Python写项目的时候，安装环境、部署代码、运行程序这个过程全是手动完成，遇到过以下问题:

1. 安装环境时经常忘了最近又添加了一个新的Python包，结果一到线上运行，程序就出错了。
2. Python包的版本依赖问题，有时候我们程序中使用的是一个版本的Python包，但是官方的已经是最新的包了，通过手动安装就可能装错了。
3. 如果依赖的包很多的话，一个一个安装这些依赖是很费时的事情。
4. 新同学开始写项目的时候，将程序跑起来非常麻烦，因为可能经常忘了要怎么安装各种依赖。

`setup.py`可以将这些事情自动化起来，提高效率、减少出错的概率。"复杂的东西自动化，能自动化的东西一定要自动化。"是一个非常好的习惯。

setuptools的[文档](https://pythonhosted.org/setuptools/setuptools.html#developer-s-guide)比较庞大，刚接触的话，可能不太好找到切入点。学习技术的方式就是看他人是怎么用的，可以参考一下Python的一个Web框架，flask是如何写的: [setup.py](https://github.com/mitsuhiko/flask/blob/master/setup.py)

当然，简单点自己写个安装脚本（`deploy.sh`）替代`setup.py`也未尝不可。

#### requirements.txt

这个文件存在的目的是:

1. 方便开发者维护软件的包依赖。将开发过程中新增的包添加进这个列表中，避免在 `setup.py` 安装依赖时漏掉软件包。
2. 方便读者明确项目使用了哪些Python包。

这个文件的格式是每一行包含一个包依赖的说明，通常是`flask>=0.10`这种格式，要求是这个格式能被`pip`识别，这样就可以简单的通过 `pip install -r requirements.txt`来把所有Python包依赖都装好了。具体格式说明： [点这里](https://pip.readthedocs.org/en/1.1/requirements.html)。

#### 关于配置文件的使用方法

注意，在上面的目录结构中，没有将`conf.py`放在源码目录下，而是放在`docs/`目录下。

很多项目对配置文件的使用做法是:

1. 配置文件写在一个或多个python文件中，比如此处的conf.py。
2. 项目中哪个模块用到这个配置文件就直接通过`import conf`这种形式来在代码中使用配置。

这种做法我不太赞同:

1. 这让单元测试变得困难（因为模块内部依赖了外部配置）
2. 另一方面配置文件作为用户控制程序的接口，应当可以由用户自由指定该文件的路径。
3. 程序组件可复用性太差，因为这种贯穿所有模块的代码硬编码方式，使得大部分模块都依赖`conf.py`这个文件。

所以，我认为配置的使用，更好的方式是，

1. 模块的配置都是可以灵活配置的，不受外部配置文件的影响。
2. 程序的配置也是可以灵活控制的。

能够佐证这个思想的是，用过nginx和mysql的同学都知道，nginx、mysql这些程序都可以自由的指定用户配置。

所以，不应当在代码中直接`import conf`来使用配置文件。上面目录结构中的`conf.py`，是给出的一个配置样例，不是在写死在程序中直接引用的配置文件。可以通过给`main.py`启动参数指定配置路径的方式来让程序读取配置内容。当然，这里的`conf.py`你可以换个类似的名字，比如`settings.py`。或者你也可以使用其他格式的内容来编写配置文件，比如`settings.yaml`之类的。

# 4.16 本章小结

## **本章总结**

### 练习题

1. logging模块有几个日志级别？
2. 请配置logging模块，使其在屏幕和文件里同时打印以下格式的日志

```plain
2017-10-18 15:56:26,613 - access - ERROR - account [1234] too many login attempts
```

1. json、pickle、shelve三个区别是什么？
2. json的作用是什么？
3. subprocess执行命令方法有几种？
4. 为什么要设计好目录结构？
5. 打印出命令行的第一个参数。例如：

```plain
python argument.py luffy
打印出 luffy
```

1. 代码如下：

```plain
'''
Linux当前目录/usr/local/nginx/html/
文件名：index.html
'''
import os
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(index.html)))
print(BASE_DIR)
```

```
1. 打印的内容是什么？
2. os.path.dirname和os.path.abspath含义是什么？
```

1. 通过configparser模块完成以下功能文件名my.cnf

```plain
[DEFAULT]
[client]
port = 3306
socket = /data/mysql_3306/mysql.sock
[mysqld]
explicit_defaults_for_timestamp = true
port = 3306
socket = /data/mysql_3306/mysql.sock
back_log = 80
basedir = /usr/local/mysql
tmpdir = /tmp
datadir = /data/mysql_3306
default-time-zone = '+8:00'
```

```
1. 修改时区 default-time-zone = '+8:00' 为 校准的全球时间 +00:00
2. 删除 explicit_defaults_for_timestamp = true
3. 为DEFAULT增加一条 character-set-server = utf8
```

1. 写一个6位随机验证码程序（使用random模块),要求验证码中至少包含一个数字、一个小写字母、一个大写字母.
2. 利用正则表达式提取到 luffycity.com ，内容如下

```plain
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <title>luffycity.com</title>
</head>
<body>
</body>
</html>
```

1. 写一个用户登录验证程序，文件如下1234.json

```plain
{"expire_date": "2021-01-01", "id": 1234, "status": 0, "pay_day": 22, "password": "abc"}
```

```
1. 用户名为json文件名，密码为 password。
2. 判断是否过期，与expire_date进行对比。
3. 登陆成功后，打印“登陆成功”，三次登陆失败，status值改为1，并且锁定账号。
```

1. 把第12题三次验证的密码进行hashlib加密处理。即：json文件保存为md5的值，然后用md5的值进行验证。
2. 最近luffy买了个tesla，通过转账的形式，并且支付了5%的手续费，tesla价格为75万。文件为json，请用程序实现该转账行为。需求如下：
   1. 目录结构为

```plain
.
├── account
│   ├── luffy.json
│   └── tesla.json
└── bin
      └── start.py
```

1. 当执行start.py时，出现交互窗口

```plain
------- Luffy Bank ---------
  1.  账户信息
  2.  转账
```

```
- 选择1 账户信息 显示luffy的当前账户余额。
- 选择2 转账 直接扣掉75万和利息费用并且tesla账户增加75万
```

1. 对上题增加一个需求：提现。目录结构如下

```plain
.
├── account
│   └── luffy.json
├── bin
│   └── start.py
└── core
   └── withdraw.py
```

1. 当执行start.py时，出现交互窗口

```plain
------- Luffy Bank ---------
1.  账户信息
2.  提现
```

```
- 选择1 账户信息 显示luffy的当前账户余额和信用额度。
- 选择2 提现 提现金额应小于等于信用额度，利息为5%，提现金额为用户自定义。
```

1. 尝试把上一章的验证用户登陆的装饰器添加到提现和转账的功能上。
2. 对第15题的用户转账、登录、提现操作均通过logging模块记录日志,日志文件位置如下

```plain
.
 ├── account
 │   └── luffy.json
 ├── bin
 │   └── start.py
 └── core
 |   └── withdraw.py
 └── logs
     └── bank.log
```

### 本章作业：

**模拟实现一个ATM + 购物商城程序**

1. 额度 15000或自定义
2. 实现购物商城，买东西加入 购物车，调用信用卡接口结账
3. 可以提现，手续费5%
4. 支持多账户登录
5. 支持账户间转账
6. 记录每月日常消费流水
7. 提供还款接口
8. ATM记录操作日志
9. 提供管理接口，包括添加账户、用户额度，冻结账户等。。。
10. 用户认证用装饰器

示例代码 <https://github.com/triaquae/py3_training/tree/master/atm>

简易流程图：<https://www.processon.com/view/link/589eb841e4b0999184934329>

## 练习题答案

1. logging模块有几个日志级别？

```plain
答案
 logging模块共5个级别，它们分别是：
 DEBUG INFO WARNING ERROR CRITICAL
```

1. 请配置logging模块，使其在屏幕和文件里同时打印以下格式的日志

```plain
2017-10-18 15:56:26,613 - access - ERROR - account [1234] too many login attempts
```

```plain
```

1. json、pickle、shelve三个区别是什么？

```plain
答案
 首先，这三个模块都是序列化工具。
 1. json是所有语言的序列化工具,优点跨语言、体积小.只能序列化一些基本的数据类型。int\str\list\tuple\dict
 pickle是python语言特有序列化工具，所有数据都能序列化。只能在python中使用，存储数据占空间大.
 shelve模块是一个简单的k,v将内存数据通过文件持久化的模块，可以持久化任何pickle可支持的python数据格式。
 2. 使用方式，json和pickle用法一样，shelve是f = shelve.open('shelve_test')
```

1. json的作用是什么？

```plain
答案：
 序列化是指把内存里的数据类型转变成字符串，以使其能存储到硬盘或通过网络传输到远程，因为硬盘或网络传输时只能接受bytes
```

1. subprocess执行命令方法有几种？

```plain
答案吧：有三种方法，他们分别是
 run()方法
 call()方法
 Popen()方法
```

1. 为什么要设计好目录结构？

```plain
答案：
1.可读性高: 不熟悉这个项目的代码的人，一眼就能看懂目录结构，知道程序启动脚本是哪个，测试目录在哪儿，配置文件在哪儿等等。从而非常快速的了解这个项目。
2.可维护性高: 定义好组织规则后，维护者就能很明确地知道，新增的哪个文件和代码应该放在什么目录之下。这个好处是，随着时间的推移，代码/配置的规模增加，项目结构不会混乱，仍然能够组织良好。
```

1. 打印出命令行的第一个参数。例如：

```plain
python argument.py luffy
打印出 luffy
```

```plain
答案：
import sys
print(sys.argv[1])
```

1. 代码如下：

```plain
'''
Linux当前目录/usr/local/nginx/html/
文件名：index.html
'''
import os
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath('index.html')))
print(BASE_DIR)
```

1. 打印的内容是什么？

```plain
答案
/usr/local/nginx
```

1. os.path.dirname和os.path.abspath含义是什么？

```plain
答案
os.path.dirname：指定文件的目录
os.path.abspath：指定文件的绝对路径
```

1. 通过configparser模块完成以下功能\
   文件名my.cnf

```plain
[DEFAULT]
 [client]
 port = 3306
 socket = /data/mysql_3306/mysql.sock
 [mysqld]
 explicit_defaults_for_timestamp = true
 port = 3306
 socket = /data/mysql_3306/mysql.sock
 back_log = 80
 basedir = /usr/local/mysql
 tmpdir = /tmp
 datadir = /data/mysql_3306
 default-time-zone = '+8:00'
```

1. 修改时区 default-time-zone = '+8:00' 为 校准的全球时间 +00:00

```plain
答案
import configparser
config = configparser.ConfigParser()
config.read('my.cnf')
config.set('mysqld','default-time-zone','+00:00')
config.write(open('my.cnf', "w"))
print(config['mysqld']['default-time-zone'] )
```

1. 删除 explicit_defaults_for_timestamp = true

```plain
import configparser
config = configparser.ConfigParser()
config.read('my.cnf')
config.remove_option('mysqld','explicit_defaults_for_timestamp')
config.write(open('my.cnf', "w"))
```

1. 为DEFAULT增加一条 character-set-server = utf8

```plain
答案：
import configparser
config = configparser.ConfigParser()
config.read('my.cnf')
config.set('DEFAULT','character-set-server','utf8')
config.write(open('my.cnf', "w"))
```

1. 写一个6位随机验证码程序（使用random模块),要求验证码中至少包含一个数字、一个小写字母、一个大写字母.
2. 利用正则表达式提取到 luffycity.com ，内容如下

```plain
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>luffycity.com</title>
</head>
<body>
</body>
</html>
```

```plain
import re
f = open('index.html','r',encoding='utf-8')
data = f.read()
print(re.findall('luffycity.com',data))
```

1. 写一个用户登录验证程序，文件如下 1234.json

```plain
{"expire_date": "2021-01-01", "id": 1234, "status": 0, "pay_day": 22, "password": "abc"}
```

1. 用户名为json文件名，密码为 password。
2. 判断是否过期，与expire_date进行对比。
3. 登陆成功后，打印“登陆成功”，三次登陆失败，status值改为1，并且锁定账号。
4. 把第12题三次验证的密码进行hashlib加密处理。即：json文件保存为md5的值，然后用md5的值进行验证。
5. 最近luffy买了个tesla，通过转账的形式，并且支付了5%的手续费，tesla价格为75万。文件为json，请用程序实现该转账行为。 需求如下：
6. 目录结构为

```plain
.
├── account
│ ├── luffy.json
│ └── tesla.json
└── bin
└── start.py
```

当执行start.py时，出现交互窗口

```plain
------- Luffy Bank ---------
  1. 账户信息
  2. 转账
```

* 选择1 账户信息 显示luffy的当前账户余额。
* 选择2 转账 直接扣掉75万和利息费用并且tesla账户增加75万
* 对上题增加一个需求：提现。 目录结构如下

```plain
.
├── account
│ └── luffy.json
├── bin
│ └── start.py
└── core
└── withdraw.py
```

当执行start.py时，出现交互窗口

```plain
------- Luffy Bank ---------
  1. 账户信息
  2. 提现
```

* 选择1 账户信息 显示luffy的当前账户余额和信用额度。
* 选择2 提现 提现金额应小于等于信用额度，利息为5%，提现金额为用户自定义。
* 尝试把上一章的验证用户登陆的装饰器添加到提现和转账的功能上。
* 对第15题的用户转账、登录、提现操作均通过logging模块记录日志,日志文件位置如下

```plain
.
├── account
│ └── luffy.json
├── bin
│ └── start.py
└── core
| └── withdraw.py
└── logs
└── bank.log
```

> 更新: 2021-01-15 08:42:28  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/bbsn8u>