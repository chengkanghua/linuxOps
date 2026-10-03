# 20·Python基础-单例模式四种实现方式

## 20·Python基础-单例模式四种实现方式
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(2) 评论(0)

+ [单例模式介绍](https://blog.driverzeng.com/zenglaoshi/5380.html#toc_0)
+ [实现单例模式的第一种方式](https://blog.driverzeng.com/zenglaoshi/5380.html#toc_1)
+ [实现单例模式的第二种方式](https://blog.driverzeng.com/zenglaoshi/5380.html#toc_2)
+ [实现单例模式的第三种方式](https://blog.driverzeng.com/zenglaoshi/5380.html#toc_3)
+ [实现单例模式的第四种方式](https://blog.driverzeng.com/zenglaoshi/5380.html#toc_4)

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

## 单例模式介绍
---

| 什么是单例模式 |
| :--- |

单例模式:多次实例化的结果指向同一个实例

是面向对象的一种设计模式

---

| 举例 |
| :--- |

```plain
class MySQL:
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
# 第一次实例化
obj1=MySQL('1.1.1.1',3306)
# 再一次实例化，又得到一个容器
obj2=MySQL('1.1.1.1',3306)
# 第三次实例化
obj3=MySQL('1.1.1.1',3306)
## 我们经过三次实例化会发现，会产生3个内存地址，这三个内存地址存储的数据都是一样的，所以我们没有必要存储那么多次。
## 所以单例模式的作用，就是把结果指向一个实例，如此一来，我们就可以做到节省资源
## 例如我们之前实现 过的，使用settings.py文件来存储数据，然后导入 
### settings.py
IP='1.1.1.1'
PORT=3306
### 导入settings.py文件
import settings
class MySQL:
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
obj1=MySQL(settings.IP, settings.PORT)
obj2=MySQL(settings.IP, settings.PORT)
obj3=MySQL(settings.IP, settings.PORT)
```

## 实现单例模式的第一种方式
```plain
import settings
class MySQL:
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
    @classmethod
    def from_conf(cls):
        return cls(settings.IP,settings.PORT)
obj1=MySQL.from_conf()
obj2=MySQL.from_conf()
obj3=MySQL.from_conf()
print(obj1)
print(obj2)
print(obj3)
# 比原来精简了，但是没有实现单例
import settings
class MySQL:
    __instance=None
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
    @classmethod
    def from_conf(cls):
        if cls.__instance is None:
            cls.__instance=cls(settings.IP, settings.PORT)
        return cls.__instance
obj1=MySQL.from_conf()
obj2=MySQL.from_conf()
obj3=MySQL.from_conf()
obj4=MySQL('1.1.1.3',3302)
print(obj1)
print(obj2)
print(obj3)
print(obj4)
```

<!-- OCR_START -->
- import settings
- LO
- class MySQL:
- instance=None
- 8
- def
- init（self,ipport）:
- self.ip =ip
- 10
- self.port= port
- 11
- 12
- aclassmethod
- 13
- def from_conf（cls):
- 14
- if cls._instance is None:
- 15
- cls._instance=cls（settings.IP,settings.PORT)
- 16
- return cls.
- _instance
- 17
- obj1=MySQL.from_conf()
- 18
- obj2=MySQL.from_conf()
- 19
- obj3=MySQL.from_conf()
- 20
- #obj4=MySQL（'1.1.1.3',3302)
- 21
- print(obj1)
- 22
- print(obj2)
- 23
- print(obj3)
- 24
- #print（obj4）
- Run:
- 02单例模式×
- /Librarv/Frameworks/Pvthon.framework/Versions/3.6/bin/python3.6"/Users/driverzeng/Desktop/py视频/python视频压缩包版/day30/代码/02单例模式.py
- <_main_.MySQL object at 0x1034c47b8>
- 曾老湿
- ess finished with exit code 0
- DriverZeng
<!-- OCR_END -->

￼

## 实现单例模式的第二种方式
使用装饰器来实现

```plain
import settings
def singleton(cls):
    def wrapper(*args,**kwargs):
        instance=cls(*args,**kwargs)
        return instance
    return wrapper
@singleton #MySQL=singleton(MySQL) #MySQL=wrapper
class MySQL:
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
obj=MySQL('1.1.1.1',3306) #obj=wrapper('1.1.1.1',3306)
print(obj.__dict__)
## 目前装饰器 ，什么功能都没有实现，我们要定制，MySQL内不传递任何参数就返回已经定义好的对象
import settings
def singleton(cls):
    _instance=cls(settings.IP,settings.PORT)
    def wrapper(*args,**kwargs):
        if len(args) !=0 or len(kwargs) !=0:
            obj=cls(*args,**kwargs)
            return obj
        return _instance
    return wrapper
@singleton #MySQL=singleton(MySQL) #MySQL=wrapper
class MySQL:
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
obj1=MySQL() #wrapper()
obj2=MySQL() #wrapper()
obj3=MySQL() #wrapper()
obj4=MySQL('1.1.1.3',3302) #wrapper('1.1.1.3',3302)
print(obj1)
print(obj2)
print(obj3)
print(obj4)
```

<!-- OCR_START -->
- 29
- import settings
- 30
- 31
- def singleton（cls）:
- 32
- instance=cls(settings.IP,settings.PoRT)
- 33
- def wrapper(*args,**kwargs):
- 34
- HD
- if len（args)≠0 or len（kwargs) ≠0:
- 35
- obj=cls(*args,**kwargs)
- 36
- return obj
- 37
- return _instance
- 38
- return wrapper
- 39
- 40
- asingleton #MySQL=singleton(MySQL)#MySQL=wrapper
- 41
- class MySQL:
- 42
- def
- _init_（self,ip,port):
- 43
- self.ip = ip
- 44
- self.port = port
- 45
- 46
- #obj=MySQL('1.1.1.1',3306)#obj=wrapper('1.1.1.1',3306)
- 47
- # print（obj._dict）
- 48
- 49
- obj1=MySQL（）
- #wrapper()
- 50
- obj2=MySQL(）#wrapper（）
- 51
- obj3=MySQL()#wrapper（）
- 52
- obj4=MySQL('1.1.1.3',3302)#wrapper('1.1.1.3,3302)
- 53
- print(obj1)
- 54
- print(obj2)
- 55
- print(obj3)
- 56
- print（obj4)
- 57
- Run:
- 02单例模式×
- Lihrary/Frameworks/Python framework/Versions/3.6/hin/python3.6"/Users/driver
- main_.MySQL object at 0x1034c45f8>
- 曾老湿
- cess finished with exit code 0
- DriverZeng
<!-- OCR_END -->

￼

## 实现单例模式的第三种方式
使用元类来实现单例模式

```plain
import settings
class Mymeta(type):
    def __init__(self,class_name,class_bases,class_dic):
        #self=MySQL这个类
        self.__instance=self(settings.IP,settings.PORT)
    def __call__(self, *args, **kwargs):
        # self=MySQL这个类
        if len(args) != 0 or len(kwargs) != 0:
            obj=self.__new__(self)
            self.__init__(obj,*args, **kwargs)
            return obj
        else:
            return self.__instance
class MySQL(metaclass=Mymeta): #MySQL=Mymeta(...)
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
obj1=MySQL()
obj2=MySQL()
obj3=MySQL()
obj4=MySQL('1.1.1.3',3302)
print(obj1)
print(obj2)
print(obj3)
print(obj4)
```

<!-- OCR_START -->
- 61
- import settings
- 62
- 63
- class Mymeta(type):
- 64
- def
- init
- (self,class_name,class bases,class_dic):
- 65
- #seLf=MySQL这个类
- 66
- self._instance=self(settings.IP,settings.PoRT)
- 67
- 68
- of
- call_(self, *args,**kwargs):
- 69
- 70
- iflen（args）≠0 or len（kwargs）≠0:
- 71
- obj=self.new_(self)
- 72
- self._init_（obj,*args,**kwargs)
- 73
- return obj
- 74
- else:
- 75
- return self._instance
- 76
- 77
- class MySQL(metaclass=Mymeta): #MySQL=Mymeta(
- 78
- definit_（self,ip,port):
- 79
- self.ip = ip
- 80
- self.port = port
- 81
- 82
- 83
- obj1=MySQL（）
- 84
- obj2=MySQL（）
- 85
- obj3=MySQL（）
- 86
- obj4=MySQL('1.1.1.33302)
- 87
- print(obj1)
- 88
- print（obj2)
- 89
- print(obj3)
- 90
- print(obj4)
- Run:
- 02单例模式
- /Librarv/Frameworks/Pvthon.framework/Versions/3.6/bin/python3.6"/Users/driverzeng/Desktop/py视
- main_.MySQL object at 0x1036a49b0>
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

## 实现单例模式的第四种方式
使用导入模块的方式

settings.py

```plain
IP='1.1.1.1'
PORT=3306
```

singleton.py

```plain
import settings
class MySQL:
    print('run....')
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
instance=MySQL(settings.IP,settings.PORT)
```

**导入singleton模块并调用**

```plain
def f1():
    from singleton import instance
    print(instance)
def f2():
    from singleton import instance,MySQL
    print(instance)
    obj=MySQL('1.1.1.3',3302)
    print(obj)
f1()
f2()
```

<!-- OCR_START -->
- 94
- def f1（）:
- 95
- from singleton import instance
- 96
- print(instance)
- 97
- 98
- def f2（）:
- 99
- from singleton import instance MysQL
- 100
- 101
- obj=MySQL('1.1.1.3'3302)
- 102
- print(obj)
- 103
- 104
- 105
- 106
- Run:
- 02单例模式
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6"/Users/driverzeng/Desktop.
- <singleton.MySQL object at 0x103ba49e8>
- ocess finished with exit code 0
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

QQ：133411023

> 更新: 2020-06-25 11:22:21  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/rs0543>