# Python基础19-面向对象(高级)

## Python基础19-面向对象(高级)
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(4) 评论(0)

+ [元类（猿类）](https://blog.driverzeng.com/zenglaoshi/5373.html#toc_0)
+ [自定义元类的类调用过程](https://blog.driverzeng.com/zenglaoshi/5373.html#toc_1)
+ [属性查找](https://blog.driverzeng.com/zenglaoshi/5373.html#toc_2)

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

## 元类（猿类）
---

| 什么是元类？ |
| :--- |

源自一句话：在python中，一切皆对象，而对象 都是由类实例化得到的。

```plain
class SchoolTeacher:
    def __init__(self,name,age,gender):
        self.name=name
        self.age=age
        self.gender=gender
    def score(self):
        print('%s is scoring' %self.name)
tea1=SchoolTeacher('zls',18,'male')
print(type(tea1))
print(type(SchoolTeacher))
# 对象tea1是调用SchoolTeacher类得到的,如果说一切皆对象,那么SchoolTeacher也是一个对象,只要是对象,都是调用一个类实例化得到的,即SchoolTeacher=元类(...),内置的元类是type
# 关系:
# 1. 调用元类---->自定义的类
# 2. 调用自定义的类---->自定义的对象
class SchoolTeacher:
    def __init__(self,name,age,gender):
        self.name=name
        self.age=age
        self.gender=gender
    def score(self):
        print('%s is scoring' %self.name)
# 自定义类的三个关键组成部分:
# 1. 类名
# 2. 类的基类们
# 3. 类的名称空间
```

---

| class底层原理 |
| :--- |

```plain
# class关键字创建自定义类的底层的工作原理,分为四步
# 1. 先拿到类名:'SchoolTeacher'
# 2. 再拿到类的基类们:(object,)
# 3. 然后拿到类的名称空间(执行类体代码,将产生的名字放到类的名称空间也就是一个字典里,补充exec)
# 4. 调用元类实例化得到自定义的类: SchoolTeacher=type('SchoolTeacher',(object,),{...})
# 不依赖class关键字创建一个自定义类
# 1. 拿到类名
class_name='SchoolTeacher'
#2. 拿到类的基类们:(object,)
class_bases=(object,)
#3. 拿到类的名称空间
class_dic={}
class_body="""
school = 'QingHua'
def __init__(self,name,age,sex):
    self.name=name
    self.age=age
    self.sex=sex
def score(self):
    print('%s is scoring' %self.name)
"""
exec(class_body,{},class_dic)
print(class_dic)
#4. 调用type得到自定义的类
SchoolTeacher=type(class_name,class_bases,class_dic)
print(SchoolTeacher)
# print(SchoolTeacher.school)
# print(SchoolTeacher.score)
tea1=SchoolTeacher('zls',18,'male')
print(tea1.__dict__)
```

---

| 自定义元类来控制类的产生 |
| :--- |

```plain
## 模板
class Mymeta(type):  #但凡继承了type的类，才能称之为自定义的元类，否则就是一个普通的类
    def __init__(self,class_name,class_bases,class_dic):
        print(self)
        print(class_name)
        print(class_bases)
        print(class_dic)
class SchoolTeacher(object,metaclass=Mymeta): #SchoolTeacher=Mymeta('SchoolTeacher',(object,){...})
    def __init__(self,name,age,gender):
        self.name=name
        self.age=age
        self.gender=gender
    def score(self):
        print('%s is scoring' %self.name)
## 控制类名必须是驼峰体
class Mymeta(type):
    def __init__(self,class_name,class_bases,class_dic):
        if class_name.islower():
            raise TypeError('名字必须是驼峰体')
class schoolteacher(object,metaclass=Mymeta): #SchoolTeacher=Mymeta('SchoolTeacher',(object,){...})
    def __init__(self,name,age,gender):
        self.name=name
        self.age=age
        self.gender=gender
    def score(self):
        pass
        print('%s is scoring' %self.name)
```

<!-- OCR_START -->
- 曾老湿

```text
81
#控制类名必须是驼峰体
82
class Mymeta(type):
83
def
(self,class_name,class_bases,class_dic):
84
if class_name.islower():
85
raiseTypeError（‘名字必须是驼峰体'）
86
87
class schoolteacher(object,metaclass=Mymeta):#SchoolTeacher=Mymeta('SchoolTeacher'(object,)f...J)
88
def
init_(selfnameagegender):
89
self.name=name
90
self.age=age
91
self.gender=gender
92
93
def score(self):
94
pass
95
print('%sisscoring'%self.name)
96
Run:
02元类介绍×
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6"/Users/driverzeng/Desktop/py视频/python视频压缩包版/day29/代码/02元类介绍.py
Traceback(most recent call last):
File"/Users/driverzeng/Desktop/py视频/python视频压缩包版/day29/代码/02元类介绍.py”，Line87，in<module>
class schoolteacher(object,metaclass=Mymeta): #SchoolTeacher=Mymeta('SchoolTeacher',(object,)...})
File"/Users/driverzeng/Desktop/py视频/python视频压缩包版/day29/代码/02元类介绍.py”，Line85，in_init
raiseTvpeError（'名字必须是驼峰体'）
TypeError：名字必须是驼峰体
ess finished with exit code 1
DriverZeng
```
<!-- OCR_END -->

￼

```plain
## 控制类必须写注释
class Mymeta(type):
    def __init__(self,class_name,class_bases,class_dic):
        if class_name.islower():
            raise TypeError('名字必须是驼峰体')
        doc=class_dic.get('__doc__')
        if doc is None or len(doc) == 0 or len(doc.strip('\n ')) == 0:
            raise TypeError('类体重必须有文档注释，且文档注释不能为空')
class SchoolTeacher(object,metaclass=Mymeta): #SchoolTeacher=Mymeta('SchoolTeacher',(object,){...})
    def __init__(self,name,age,gender):
        self.name=name
        self.age=age
        self.gender=gender
    def score(self):
        pass
        print('%s is scoring' %self.name)
```

<!-- OCR_START -->
- 曾老湿

```text
82
class
83
def
(self,class_name,class_bases,class_dic):
84
if class_name.islower(）: 85 raise TypeError（名字必须是驼峰体'） 86
87
doc=class_dic.get('_doc 88 ifdocisNone orlen（doc）=0or len（doc.strip（'\n'））=0： 89
raiseTypeError（类体重必须有文档注释，且文档注释不能为空）
90
91
class SchoolTeacher(object,metaclass=Mymeta): #SchoolTeacher=Mymeta('SchoolTeacher(object,）.) 92 def init（self,name,age,gender):
93
self.name=name
94
self.age=age
95
self.gender=gender
96
97
def score(self):
98
pass
99
print('%s is scoring' %self.name)
SchoolTeacher
score()
Run:
02元类介绍×
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/Desktop/py视频/python视频压缩包版/day29/代码/02元类介绍.py
Traceback(most recent calllast):
File“Users/driverzeng/Desktop/py视频/python视频压缩包版/day29/代码/02 元类介绍.py”，Line91，in<module>
class SchoolTeacher(object,metaclass=Mymeta):#SchoolTeacher=Mymeta('SchoolTeacher',(object,)...})
File“Users/driverzeng/Desktop/py视频/python视频压缩包版/day29/代码/02元类介绍.py”，line89，in_init_
raiseTypeError（类体重必须有文档注释，且文档注释不能为空'）
TypeError：类体重必须有文档注释，且文档注释不能为空
DriverZeng
ess finished with exit code 1
```
<!-- OCR_END -->

￼

## 自定义元类的类调用过程
```plain
class Mymeta(type): #但凡继承了type的类才能称之为自定义的元类,否则就是只是一个普通的类
    pass
class SchoolTeacher(object): #SchoolTeacher=Mymeta('SchoolTeacher',(object,),{...})
    school = 'QingHua'
    def __init__(self,name,age,sex):
        self.name=name
        self.age=age
        self.sex=sex
    def score(self):
        print('%s is scoring' %self.name)
tea1=SchoolTeacher('zls',18,'male')        
tea1()
# 直接调用会报错
## 使用__call__
class Mymeta(type): #但凡继承了type的类才能称之为自定义的元类,否则就是只是一个普通的类
    pass
class SchoolTeacher(object): #SchoolTeacher=Mymeta('SchoolTeacher',(object,),{...})
    school = 'QingHua'
    def __init__(self,name,age,sex):
        self.name=name
        self.age=age
        self.sex=sex
    def score(self):
        print('%s is scoring' %self.name)
    def __call__(self, *args, **kwargs):
        print(self)
        print(args)
        print(kwargs)
tea1=SchoolTeacher('zls',18,'male')
tea1(1,2,a=1,b=2) #__call__(tea1,(1,2).{'a':1,'b':2})
```

总结:对象之所以可以调用,是因为对象的类中有一个函数__call__

推导:如果一切皆对象,那么SchoolTeacher也是一个对象,该对象之所可以调用,肯定是这个对象的类中也定义了一个函数__call__

```plain
class Mymeta(type): #但凡继承了type的类才能称之为自定义的元类,否则就是只是一个普通的类
    def __call__(self, *args, **kwargs): #self=SchoolTeacher这个类,args=('zls',18,'male'),kwargs={}
        # 1. 先产生一个空对象
        tea_obj=self.__new__(self) #tea_obj是SchoolTeacher这个类的对象
        # 2. 执行__init__方法,完成对象的初始属性操作
        self.__init__(tea_obj,*args,**kwargs)
        # 3. 返回初始化好的那个对象
        return tea_obj
class SchoolTeacher(object,metaclass=Mymeta): #SchoolTeacher=Mymeta('SchoolTeacher',(object,),{...})
    school = 'QingHua'
    #            tea_obj,'zls',18,'male'
    def __init__(self,name,age,sex):
        self.name=name
        self.age=age
        self.sex=sex
    def score(self):
        print('%s is scoring' %self.name)
tea1=SchoolTeacher('zls',18,'male') # 会触发SchoolTeacher的类(即元类)中的__call__函数
print(tea1)
print(tea1.__dict__)
实例化SchoolTeacher,或者说调用SchoolTeacher会
1.先产生一个空对象
2.执行__init__方法,完成对象的初始属性操作
3.返回初始化好的那个对象
推导:调用SchoolTeacher(...)就是在调用SchoolTeacher的类中的__call__,那么在该__call__中就需要做上述三件事
```

**自定义元类来控制类的调用(即类的实例化过程)**

```plain
class Mymeta(type): #但凡继承了type的类才能称之为自定义的元类,否则就是只是一个普通的类
    def __call__(self, *args, **kwargs): #self=SchoolTeacher这个类,args=('zls',18,'male'),kwargs={}
        # 1. 先产生一个空对象
        tea_obj=self.__new__(self) #tea_obj是SchoolTeacher这个类的对象
        # 2. 执行__init__方法,完成对象的初始属性操作
        self.__init__(tea_obj,*args,**kwargs)
        # print(tea_obj.__dict__)
        tea_obj.__dict__={('_%s__%s' %(self.__name__,k)):v for k,v in tea_obj.__dict__.items()}
        # 3. 返回初始化好的那个对象
        return tea_obj
class SchoolTeacher(object,metaclass=Mymeta): #SchoolTeacher=Mymeta('SchoolTeacher',(object,),{...})
    school = 'QingHua'
    def __init__(self,name,age,sex):
        self.name=name
        self.age=age
        self.sex=sex
    def score(self):
        print('%s is scoring' %self.name)
tea1=SchoolTeacher('zls',18,'male') # 会触发SchoolTeacher的类(即元类)中的__call__函数
# print(tea1)
print(tea1.__dict__)
```

总结，Mymeta下的__call__里的self.__new__在SchoolTeacher、Foo、Bar里都没有找到__new__的情况下，会去找object里的__new__，而object下默认就有一个__new__，所以即便是之前的类均未实现__new__,也一定会在object中找到一个，根本不会、也根本没必要再去找元类Mymeta->type中查找__new__

## 属性查找
我们在元类的__call__中也可以用object.__new__(self)去造对象

<!-- OCR_START -->
- type
- Mymeta
- OldboyTeacher
- Foo
- Bar
- object
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

但我们还是推荐在__call__中使用self.__new__（self）去创造空对象，因为这种方式会检索三个类SchoolTeacher->Foo->Bar,而object.__new__则是直接跨过了他们三个

```plain
class Mymeta(type):  # 但凡继承了type的类才能称之为自定义的元类,否则就是只是一个普通的类
    # n=444
    def __call__(self, *args, **kwargs): #self=SchoolTeacher这个类
        # 1. 先产生一个空对象
        tea_obj = self.__new__(self)  # tea_obj是SchoolTeacher这个类的对象
        # print(self.__new__ is object.__new__)
        # tea_obj=object.__new__(self)
        # 2. 执行__init__方法,完成对象的初始属性操作
        self.__init__(tea_obj, *args, **kwargs)
        # 3. 返回初始化好的那个对象
        return tea_obj
class Bar:
    # n = 33
    pass
class Foo(Bar):
    # n = 222
    pass
class SchoolTeacher(Foo, metaclass=Mymeta):  # SchoolTeacher=Mymeta('SchoolTeacher',(object,),{...})
    # n = 111
    school = 'QingHua'
    def __init__(self, name, age, sex):
        self.name = name #None.name='zls'
        self.age = age
        self.sex = sex
    def score(self):
        print('%s is scoring' % self.name)
    def __new__(cls, *args, **kwargs):
        # print('=====>')
        return super().__new__(cls)
tea1 = SchoolTeacher('zls', 18, 'male')
print(tea1)
print(tea1.__dict__)
print(SchoolTeacher.n)
print(object.__new__)
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:21:46  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/gzxil5>