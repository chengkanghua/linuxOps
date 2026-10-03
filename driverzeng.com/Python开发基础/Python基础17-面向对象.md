# Python基础17-面向对象

## Python基础17-面向对象
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(4) 评论(0)

+ [面向对象介绍](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_0)
+ [类与对象](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_1)
+ [对象的使用](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_2)
+ [属性查找的顺序](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_3)
+ [绑定方法](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_4)
+ [一切皆对象](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_5)
+ [对象之间的交互](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_6)
+ [继承](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_7)
+ [继承与抽象（先抽象再继承）](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_8)
+ [如何解决重用](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_9)
+ [组合](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_10)
+ [多态与多态性](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_11)
+ [封装](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_12)
+ [property装饰器](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_13)
+ [绑定方法与非绑定方法](https://blog.driverzeng.com/zenglaoshi/5354.html#toc_14)

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

## 面向对象介绍
---

| 回顾面向过程 |
| :--- |

```plain
# 面向过程的编程思想
面向过程的程序设计：核心是过程二字，过程指的是解决问题的步骤，即先干什么再干什么......面向过程的设计就好比精心设计好一条流水线，是一种机械式的思维方式。
优点是：复杂度的问题流程化，进而简单化（一个复杂的问题，分成一个个小的步骤去实现，实现小的步骤将会非常简单）
缺点是：一套流水线或者流程就是用来解决一个问题，生产汽水的流水线无法生产汽车，即便是能，也得是大改，改一个组件，牵一发而动全身。
应用场景：一旦完成基本很少改变的场景，著名的例子有Linux內核，git，以及Apache HTTP Server等。
```

---

| 面向对象介绍 |
| :--- |

```plain
# 面向对象的编程思想
面向对象的程序设计：核心是对象二字，（要理解对象为何物，必须把自己当成上帝，上帝眼里世间存在的万物皆为对象，不存在的也可以创造出来。面向对象的程序设计好比如来设计西游记，如来要解决的问题是把经书传给东土大唐，如来想了想解决这个问题需要四个人：唐僧，沙和尚，猪八戒，孙悟空，每个人都有各自的特征和技能（这就是对象的概念，特征和技能分别对应对象的数据属性和方法属性），然而这并不好玩，于是如来又安排了一群妖魔鬼怪，为了防止师徒四人在取经路上被搞死，又安排了一群神仙保驾护航，这些都是对象。然后取经开始，师徒四人与妖魔鬼怪神仙交互着直到最后取得真经。如来根本不会管师徒四人按照什么流程去取),对象是特征与技能的结合体，基于面向对象设计程序就好比在创造一个世界，你就是这个世界的上帝，存在的皆为对象，不存在的也可以创造出来，与面向过程机械式的思维方式形成鲜明对比，面向对象更加注重对现实世界的模拟，是一种“上帝式”的思维方式。
优点是：解决了程序的扩展性。对某一个对象单独修改，会立刻反映到整个体系中，如对游戏中一个人物参数的特征和技能修改都很容易。
缺点：
1. 编程的复杂度远高于面向过程，不了解面向对象而立即上手基于它设计程序，极容易出现过度设计的问题。一些扩展性要求低的场景使用面向对象会徒增编程难度，比如管理linux系统的shell脚本就不适合用面向对象去设计，面向过程反而更加适合。
2. 无法向面向过程的程序设计流水线式的可以很精准的预测问题的处理流程与结果，面向对象的程序一旦开始就由对象之间的交互解决问题，即便是上帝也无法准确地预测最终结果。于是我们经常看到对战类游戏，新增一个游戏人物，在对战的过程中极容易出现阴霸的技能，一刀砍死3个人，这种情况是无法准确预知的，只有对象之间交互才能准确地知道最终的结果。
应用场景：需求经常变化的软件，一般需求的变化都集中在用户层，互联网应用，企业内部软件，游戏等都是面向对象的程序设计大显身手的好地方
```

面向对象的程序设计并不是全部。对于一个软件质量来说，面向对象的程序设计只是用来解决扩展性。

<!-- OCR_START -->
- 性能
- 成本
- 可靠性
- 可扩展性
- 软件质量
- 安全性
- 属性
- 可伸缩性
- 可维护性
- 可移植性
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## 类与对象
---

| 类介绍 |
| :--- |

类即类别、种类，是面向对象设计最重要的概念，对象是特征与技能的结合体，而类则是一系列对象相似的特征与技能的结合体

那么问题来了，先有的一个个具体存在的对象（比如一个具体存在的人），还是先有的人类这个概念，这个问题需要分两种情况去看

在现实世界中：先有对象，再有类

世界上肯定是先出现各种各样的实际存在的物体，然后随着人类文明的发展，人类站在不同的角度总结出了不同的种类，如人类、动物类、植物类等概念

也就说，对象是具体的存在，而类仅仅只是一个概念，并不真实存在

在程序中：务必保证先定义类，后产生对象

这与函数的使用是类似的，先定义函数，后调用函数，类也是一样的，在程序中需要先定义类，后调用类

不一样的是，调用函数会执行函数体代码返回的是函数体执行的结果，而调用类会产生对象，返回的是对象

**按照上述步骤，我们来定义一个类（我们站在xx大学学校的角度去看，在座的各位都是学生）**

```plain
#在现实世界中，站在xx大学学校的角度：先有对象，再有类
对象1：李坦克
    特征:
        学校=xx大学
        姓名=李坦克
        性别=男
        年龄=18
    技能：
        学习
        吃饭
        睡觉
对象2：王大炮
    特征:
        学校=xx大学
        姓名=王大炮
        性别=女
        年龄=38
    技能：
        学习
        吃饭
        睡觉
对象3：牛榴弹
    特征:
        学校=xx大学
        姓名=牛榴弹
        性别=男
        年龄=78
    技能：
        学习
        吃饭
        睡觉
现实中的老男孩学生类
    相似的特征:
        学校=xx大学
    相似的技能：
        学习
        吃饭
        睡觉
```

**在程序中：先定义类，后产生对象**

```plain
#在程序中，务必保证：先定义（类），后使用（产生对象）
PS:
  1. 在程序中特征用变量标识，技能用函数标识
  2. 因而类中最常见的无非是：变量和函数的定义
#程序中的类
class xxSchoolStudent:
    school='xxSchool'
    def learn(self):
        print('is learning')
        
    def eat(self):
        print('is eating')
    
    def sleep(self):
        print('is sleeping')
  
#注意：
  1.类中可以有任意python代码，这些代码在类定义阶段便会执行
  2.因而会产生新的名称空间，用来存放类的变量名与函数名，可以通过xxSchoolStudent.__dict__查看
  3.对于经典类来说我们可以通过该字典操作类名称空间的名字（新式类有限制），但python为我们提供专门的.语法
  4.点是访问属性的语法，类中定义的名字，都是类的属性
#程序中类的用法
.:专门用来访问属性，本质操作的就是__dict__
xxSchoolStudent.school #等于经典类的操作xxSchoolStudent.__dict__['school']
xxSchoolStudent.school='xxSchool' #等于经典类的操作xxSchoolStudent.__dict__['school']='xxSchool'
xxSchoolStudent.x=1 #等于经典类的操作xxSchoolStudent.__dict__['x']=1
del xxSchoolStudent.x #等于经典类的操作xxSchoolStudent.__dict__.pop('x')
#程序中的对象
#调用类，或称为实例化，得到对象
s1=xxSchoolStudent()
s2=xxSchoolStudent()
s3=xxSchoolStudent()
#如此，s1、s2、s3都一样了，而这三者除了相似的属性之外还各种不同的属性，这就用到了__init__
#注意：该方法是在对象产生之后才会执行，只用来为对象进行初始化操作，可以有任意代码，但一定不能有返回值
class xxSchoolStudent:
    ......
    def __init__(self,name,age,sex):
        self.name=name
        self.age=age
        self.sex=sex
    ......
s1=xxSchoolStudent('李坦克','男',18) #先调用类产生空对象s1，然后调用xxSchoolStudent.__init__(s1,'李坦克','男',18)
s2=xxSchoolStudent('王大炮','女',38)
s3=xxSchoolStudent('牛榴弹','男',78)
#程序中对象的用法
#执行__init__,s1.name='牛榴弹'，很明显也会产生对象的名称空间
s2.__dict__
{'name': '王大炮', 'age': '女', 'sex': 38}
s2.name #s2.__dict__['name']
s2.name='王三炮' #s2.__dict__['name']='王三炮'
s2.course='python' #s2.__dict__['course']='python'
del s2.course #s2.__dict__.pop('course')
```

类是一系列对象相同的特征(变量)与技能(函数)的结合体,即类体中最常见的就是变量与函数的定义

但其实类体中是可以存在任意python代码的

类体代码会在类定义阶段立即执行,会产生一个类名称空间,用来将类体代码执行过程中产生的名字都丢进去,查看方式如下：

```plain
print(OldboyStudent.__dict__) # 查看类的名称空间
print(OldboyStudent.school) #print(OldboyStudent.__dict__['school'])
print(OldboyStudent.choose_course)
OldboyStudent.school='OLDBOY' #OldboyStudent.__dict__['school']='OLDBOY'
OldboyStudent.country='China' #OldboyStudent.__dict__['country']='China'
del OldboyStudent.country # del OldboyStudent.__dict__['country']
print(OldboyStudent.__dict__)
OldboyStudent.choose_course(123123)
# 总结:
#1. 类本质就是一个名称空间,或者说是一个用来存放变量与函数的容器
#2. 类的用途之一就是当做名称空间从其内部取出名字来使用
#3. 类的用途之二是调用类来产生对象
```

## 对象的使用
```plain
class OldboyStudent:
    #相同的特征
    school = 'oldboy'
    #相同的技能
    def choose_course(self):
        print('choosing course')
#2. 后调用类来产生对象:
# 调用类的过程称之为类的实例化,调用类的返回值称之为类的一个对象/实例
# 调用类发生了?
# 1. 会产生一个对象,然后返回
stu1=OldboyStudent()
stu2=OldboyStudent()
stu3=OldboyStudent()
print(stu1.__dict__)
print(stu2.__dict__)
print(stu3.__dict__)
# 为对象定制自己独有的特征
# name='李铁蛋'
# age=18
# sex='male'
stu1.name='李铁蛋'
stu1.age=18
stu1.sex='male'
print(stu1.__dict__)
# name='赵钢弹'
# age=38
# sex='female'
stu2.name='赵钢弹'
stu2.age=38
stu2.sex='female'
print(stu2.__dict__)
# name='刘银弹'
# age=28
# sex='male'
stu3.name='刘银弹'
stu3.age=28
stu3.sex='male'
print(stu3.__dict__)
## 上面全是重复代码啊...怎么办？定义函数解决
# 为对象定制自己独有的特征,简化方案一:
def init(obj,name,age,sex):
    obj.name = name
    obj.age = age
    obj.sex = sex
# stu1.name='李铁蛋'
# stu1.age=18
# stu1.sex='male'
init(stu1,'李铁蛋',18,'male')
# stu2.name='赵钢弹'
# stu2.age=38
# stu2.sex='female'
init(stu2,'赵钢弹',38,'female')
# stu3.name='刘银弹'
# stu3.age=28
# stu3.sex='male'
init(stu3,'刘银弹',28,'male')
print(stu1.__dict__)
print(stu2.__dict__)
print(stu3.__dict__)
# 为对象定制自己独有的特征,简化方案二:
class OldboyStudent:
    #相同的特征
    school = 'oldboy'
    #           stu1,'李铁蛋',18,'male'
    def __init__(obj, name, age, sex):
        obj.name = name #stu1.name='李铁蛋'
        obj.age = age   #stu1.age=18
        obj.sex = sex   #stu1.sex='male'
    #相同的技能
    def choose_course(self):
        print('choosing course')
        
# 调用类发生了
# 1. 先产生一个空对象stu1,然后返回
# 2. 触发类中函数__init__的执行,将对象连同调用类括号内指定的参数一同传入__init__(stu1,'李铁蛋',18,'male')
stu1=OldboyStudent('李铁蛋',18,'male') #__init__(stu1,'李铁蛋',18,'male')
stu2=OldboyStudent('赵钢弹',38,'female') #__init__(stu2,'赵钢弹',38,'female')
stu3=OldboyStudent('刘银弹',28,'male') #__init__(stu3,'刘银弹',28,'male')
print(stu1.__dict__)
print(stu2.__dict__)
print(stu3.__dict__)
# 总结__init__的功能: 是在实例化时就为对象初始自己独有的特征
# 注意:不能有返回值
```

---

| 细说__init__ |
| :--- |

```plain
#方式一、为对象初始化自己独有的特征
class People:
    country='China'
    x=1
    def run(self):
        print('----->', self)
# 实例化出三个空对象
obj1=People()
obj2=People()
obj3=People()
# 为对象定制自己独有的特征
obj1.name='zls'
obj1.age=18
obj1.sex='male'
obj2.name='lxx'
obj2.age=38
obj2.sex='female'
obj3.name='alex'
obj3.age=38
obj3.sex='female'
# print(obj1.__dict__)
# print(obj2.__dict__)
# print(obj3.__dict__)
# print(People.__dict__)
#方式二、为对象初始化自己独有的特征
class People:
    country='China'
    x=1
    def run(self):
        print('----->', self)
# 实例化出三个空对象
obj1=People()
obj2=People()
obj3=People()
# 为对象定制自己独有的特征
def chu_shi_hua(obj, x, y, z): #obj=obj1,x='zls',y=18,z='male'
    obj.name = x
    obj.age = y
    obj.sex = z
chu_shi_hua(obj1,'zls',18,'male')
chu_shi_hua(obj2,'lxx',38,'female')
chu_shi_hua(obj3,'alex',38,'female')
#方式三、为对象初始化自己独有的特征
class People:
    country='China'
    x=1
    def chu_shi_hua(obj, x, y, z): #obj=obj1,x='zls',y=18,z='male'
        obj.name = x
        obj.age = y
        obj.sex = z
    def run(self):
        print('----->', self)
obj1=People()
# print(People.chu_shi_hua)
People.chu_shi_hua(obj1,'zls',18,'male')
obj2=People()
People.chu_shi_hua(obj2,'lxx',38,'female')
obj3=People()
People.chu_shi_hua(obj3,'alex',38,'female')
# 方式四、为对象初始化自己独有的特征
class People:
    country='China'
    x=1
    def __init__(obj, x, y, z): #obj=obj1,x='zls',y=18,z='male'
        obj.name = x
        obj.age = y
        obj.sex = z
    def run(self):
        print('----->', self)
obj1=People('zls',18,'male') #People.__init__(obj1,'zls',18,'male')
obj2=People('lxx',38,'female') #People.__init__(obj2,'lxx',38,'female')
obj3=People('alex',38,'female') #People.__init__(obj3,'alex',38,'female')
# __init__方法
# 强调：
#   1、该方法内可以有任意的python代码
#   2、一定不能有返回值
class People:
    country='China'
    x=1
    def __init__(obj, name, age, sex): #obj=obj1,x='zls',y=18,z='male'
        # if type(name) is not str:
        #     raise TypeError('名字必须是字符串类型')
        obj.name = name
        obj.age = age
        obj.sex = sex
    def run(self):
        print('----->', self)
# obj1=People('zls',18,'male')
obj1=People(3537,18,'male')
# print(obj1.run)
# obj1.run() #People.run(obj1)
# print(People.run)
```

## 属性查找的顺序
类有两种属性：数据属性和函数属性

1.类的数据属性是所有对象共享的

2.类的函数属性是绑定给对象用的

```plain
#类的数据属性是所有对象共享的,id都一样
print(id(OldboyStudent.school))
print(id(s1.school))
print(id(s2.school))
print(id(s3.school))
'''
4377347328
4377347328
4377347328
4377347328
'''
#类的函数属性是绑定给对象使用的,obj.method称为绑定方法,内存地址都不一样
#ps:id是python的实现机制,并不能真实反映内存地址,如果有内存地址,还是以内存地址为准
print(OldboyStudent.learn)
print(s1.learn)
print(s2.learn)
print(s3.learn)
'''
<function OldboyStudent.learn at 0x1021329d8>
<bound method OldboyStudent.learn of <__main__.OldboyStudent object at 0x1021466d8>>
<bound method OldboyStudent.learn of <__main__.OldboyStudent object at 0x102146710>>
<bound method OldboyStudent.learn of <__main__.OldboyStudent object at 0x102146748>>
'''
```

<!-- OCR_START -->
- People模板、工厂
- objl
- name
- age
- 变量名country
- sex
- 函数名run
- obj2
- 名字x
- obj3
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| 访问顺序 |
| :--- |

```plain
xxx=33333
class OldboyStudent:
    school = 'oldboy'
    # xxx=2222
    yyy=333
    count=0
    def __init__(obj, name, age, sex):
        # print(OldboyStudent.yyy)
        # print(obj.yyy)
        OldboyStudent.count+=1
        obj.name = name #stu1.name='李铁蛋'
        obj.age = age   #stu1.age=18
        obj.sex = sex   #stu1.sex='male'
    def choose_course(self):
        print('choosing course')
# 1. 属性查找顺序
# stu1=OldboyStudent('李铁蛋',18,'male')
# print(stu1.__dict__)
# print(OldboyStudent.__dict__)
# stu1.xxx=111
# print(stu1.__dict__)
# 先从对象自己的名称空间找,没有则去所属的类中找
# print(stu1.xxx)
# 2.类中的变量共享
stu1=OldboyStudent('李铁蛋',18,'male')
stu2=OldboyStudent('赵钢弹',38,'female')
stu3=OldboyStudent('刘银弹',28,'male')
print(stu1.count)
print(stu2.count)
print(stu3.count)
print(OldboyStudent.count)
# 类中定义的变量是所有对象共享的,对象可以来用,类也可以来使用,类一旦改变自己的数据属性的值,所有的对象都能感知到
print(id(stu1.school))
print(id(stu2.school))
print(id(stu3.school))
print(id(OldboyStudent.school))
stu1.school=123
# OldboyStudent.school='OLDBOY'
print(stu1.__dict__)
print(stu2.__dict__)
print(stu3.__dict__)
print(OldboyStudent.__dict__)
print(OldboyStudent.school)
print(stu1.school)
print(stu2.school)
print(stu3.school)
print(id(stu1.choose_course))
print(id(stu2.choose_course))
print(id(stu3.choose_course))
```

## 绑定方法
```plain
#类中定义的变量是类的数据属性,类可以用,对象也可以用,大家都指向同一个内存地址,类变量值一旦改变所有对象都跟着变
#类中定义的函数是类的函数属性,类可以用,类来调用就是一个普通的函数,但其实类中定义的函数是给对象用的,而且是绑定给对象用的
# 绑定???
class OldboyStudent:
    school = 'oldboy'
    def __init__(self, name, age, sex):
        self.name = name #stu1.name='李铁蛋'
        self.age = age   #stu1.age=18
        self.sex = sex   #stu1.sex='male'
    def choose_course(self,x): #self=stu1
        print('%s choosing course' %self.name)
stu1=OldboyStudent('李铁蛋',18,'male')
stu2=OldboyStudent('赵钢弹',38,'female')
stu3=OldboyStudent('刘银弹',28,'male')
# 1. 类的函数: 该传几个参数就传几个
# print(OldboyStudent.__init__)
# print(OldboyStudent.choose_course)
# OldboyStudent.choose_course(stu1)
# 2. 绑定方法,指向类的函数: 特殊之处是绑定给谁就应该由谁来调用,谁来调用就会将谁当做第一个参数自动传入
# print(stu1.choose_course)
# print(stu2.choose_course)
# print(stu3.choose_course)
# stu1.choose_course(123) #OldboyStudent.choose_course(stu1,123)
# stu2.choose_course(123)
# stu3.choose_course(123)
stu1.choose_course()
```

类中定义的函数（没有被任何装饰器装饰的）是类的函数属性，类可以使用，但必须遵循函数的参数规则，有几个参数需要传几个参数

类中定义的函数（没有被任何装饰器装饰的）,其实主要是给对象使用的，而且是绑定到对象的，虽然所有对象指向的都是相同的功能，但是绑定到不同的对象就是不同的绑定方法

强调：绑定到对象的方法的特殊之处在于，绑定给谁就由谁来调用，谁来调用，就会将‘谁’本身当做第一个参数传给方法，即自动传值（方法__init__也是一样的道理）

注意：绑定到对象的方法的这种自动传值的特征，决定了在类中定义的函数都要默认写一个参数self，self可以是任意名字，但是约定俗成地写出self。

## 一切皆对象
类即类型

提示：python的class术语与c++有一定区别，与 Modula-3更像。

python中一切皆为对象，且python3中类与类型是一个概念，类型就是类

```plain
#类型dict就是类dict
>>> list
<class 'list'>
#实例化的到3个对象l1,l2,l3
>>> l1=list()
>>> l2=list()
>>> l3=list()
#三个对象都有绑定方法append,是相同的功能,但内存地址不同
>>> l1.append
<built-in method append of list object at 0x10b482b48>
>>> l2.append
<built-in method append of list object at 0x10b482b88>
>>> l3.append
<built-in method append of list object at 0x10b482bc8>
#操作绑定方法l1.append(3),就是在往l1添加3,绝对不会将3添加到l2或l3
>>> l1.append(3)
>>> l1
[3]
>>> l2
[]
>>> l3
[]
#调用类list.append(l3,111)等同于l3.append(111)
>>> list.append(l3,111) #l3.append(111)
>>> l3
[111]
----------------
class Foo:
    pass
# print(Foo)
# obj=Foo()
# print(type(obj))
# print(int)
# age=10 #age=int(10)
# print(type(age))
# print(dict)
l1=[1,2,3] #l1=list([1,2,3])
# print(type(l1))
# l1.append(4)
# print(l1)
l1.append(4) # list.append(l1,4)
print(l1)
l2=['a','b','c'] #l2=list(['a','b','c'])
l2.append('d')
```

## 对象之间的交互
```plain
class Garen:        #定义英雄盖伦的类，不同的玩家可以用它实例出自己英雄;
    camp='Demacia'  #所有玩家的英雄(盖伦)的阵营都是Demacia;
    def __init__(self,nickname,aggressivity=58,life_value=455): #英雄的初始攻击力58...;
        self.nickname=nickname  #为自己的盖伦起个别名;
        self.aggressivity=aggressivity #英雄都有自己的攻击力;
        self.life_value=life_value #英雄都有自己的生命值;
    def attack(self,enemy):   #普通攻击技能，enemy是敌人;
        enemy.life_value-=self.aggressivity #根据自己的攻击力，攻击敌人就减掉敌人的生命值。
```

**我们可以仿照garen类再创建一个Riven类**

```plain
class Riven:
    camp='Noxus'  #所有玩家的英雄(锐雯)的阵营都是Noxus;
    def __init__(self,nickname,aggressivity=54,life_value=414): #英雄的初始攻击力54;
        self.nickname=nickname  #为自己的锐雯起个别名;
        self.aggressivity=aggressivity #英雄都有自己的攻击力;
        self.life_value=life_value #英雄都有自己的生命值;
    def attack(self,enemy):   #普通攻击技能，enemy是敌人;
        enemy.life_value-=self.aggressivity #根据自己的攻击力，攻击敌人就减掉敌人的生命值。
```

**实例出俩英雄**

```plain
>>> g1=Garen('草丛伦')
>>> r1=Riven('锐雯雯')
```

**交互：锐雯雯攻击草丛伦，反之一样**

```plain
>>> g1.life_value
455
>>> r1.attack(g1)
>>> g1.life_value
401
```

**补充：**

garen_hero.Q()称为向garen_hero这个对象发送了一条消息，让他去执行Q这个功能，类似的有：

garen_hero.W()

garen_hero.E()

garen_hero.R()

## 继承
---

| 什么是继承？ |
| :--- |

继承一种新建类的方式,新建的类称之为子类/派生类,被继承的类称之为父类\基类\超类

因为啥要使用继承呢？就一句话：为了减少类与类之间代码冗余

**python中继承的特点:**

```plain
1.子类可以遗传/重用父类的属性
2.python中一个子类可以同时继承多个父类
3.在继承背景下去说,python中的类分为两种:新式类,经典类
    1)新式类: 但凡继承了object的类Foo,以及该类的子类...都是新式类
        在python3中一个类即便是没有显式地继承任何类,默认就会继承object
        即python3中所有的类都是新式类
    2)经典类:没有继承object的类,以及该类的子类...都是经典类
        在python2中才区分新式类与经典类,
        在python2中一个类如果没有显式地继承任何类,也不会继承object
```

---

| 如何继承？ |
| :--- |

**python中类的继承分为：单继承和多继承**

```plain
class ParentClass1: #定义父类
    pass
class ParentClass2: #定义父类
    pass
class SubClass1(ParentClass1): #单继承，基类是ParentClass1，派生类是SubClass
    pass
class SubClass2(ParentClass1,ParentClass2): #python支持多继承，用逗号分隔开多个继承的类
    pass
    
    
## 定义父类
class Parent1(object):
    pass
class Parent2(object):
    pass
#单继承
class Sub1(Parent1):
    pass
#多继承
class Sub2(Parent1,Parent2):
    pass
    
## 查看基类
print(Parent1.__bases__)
print(Parent2.__bases__)
print(Sub1.__bases__)
print(Sub2.__bases__)
# 问题:
# 1 子类如何重用父类的属性
# 2 在继承背景下,属性查找的优先级
# 3 新式类与经典类在属性查找上的区别
```

## 继承与抽象（先抽象再继承）
继承描述的是子类与父类之间的关系，是一种什么是什么的关系。要找出这种关系，必须先抽象再继承

抽象即抽取类似或者说比较像的部分。

抽象分成两个层次：

1.将奥巴马和梅西这俩对象比较像的部分抽取成类；

2.将人，猪，狗这三个类比较像的部分抽取成父类。

抽象最主要的作用是划分类别（可以隔离关注点，降低复杂度）

<!-- OCR_START -->
- 动物
- 抽象
- 曾老湿
- 麦兜
- 猪坚强
- 史努比
- 史派克
- DriverZeng
<!-- OCR_END -->

￼

**继承：是基于抽象的结果，通过编程语言去实现它，肯定是先经历抽象这个过程，才能通过继承的方式去表达出抽象的结构。**

抽象只是分析和设计的过程中，一个动作或者说一种技巧，通过抽象可以得到类

<!-- OCR_START -->
- 动物
- 继承
- 实例化
- 曾老湿
- 麦兜
- 猪坚强
- 史努比
- 史派克
- 每西
- DriverZeng
<!-- OCR_END -->

￼

## 如何解决重用
---

| 使用继承来重用代码比较好的例子 |
| :--- |

```plain
==========================第一部分
例如
　　猫可以：喵喵叫、吃、喝、拉、撒
　　狗可以：汪汪叫、吃、喝、拉、撒
如果我们要分别为猫和狗创建一个类，那么就需要为 猫 和 狗 实现他们所有的功能，伪代码如下：
 
#猫和狗有大量相同的内容
class 猫：
    def 喵喵叫(self):
        print '喵喵叫'
    def 吃(self):
        # do something
    def 喝(self):
        # do something
    def 拉(self):
        # do something
    def 撒(self):
        # do something
class 狗：
    def 汪汪叫(self):
        print '喵喵叫'
    def 吃(self):
        # do something
    def 喝(self):
        # do something
    def 拉(self):
        # do something
    def 撒(self):
        # do something
==========================第二部分
上述代码不难看出，吃、喝、拉、撒是猫和狗都具有的功能，而我们却分别的猫和狗的类中编写了两次。如果使用 继承 的思想，如下实现：
　　动物：吃、喝、拉、撒
　　   猫：喵喵叫（猫继承动物的功能）
　　   狗：汪汪叫（狗继承动物的功能）
伪代码如下：
class 动物:
    def 吃(self):
        # do something
    def 喝(self):
        # do something
    def 拉(self):
        # do something
    def 撒(self):
        # do something
# 在类后面括号中写入另外一个类名，表示当前类继承另外一个类
class 猫(动物)：
    def 喵喵叫(self):
        print '喵喵叫'
        
# 在类后面括号中写入另外一个类名，表示当前类继承另外一个类
class 狗(动物)：
    def 汪汪叫(self):
        print '喵喵叫'
==========================第三部分
#继承的代码实现
class Animal:
    def eat(self):
        print("%s 吃 " %self.name)
    def drink(self):
        print ("%s 喝 " %self.name)
    def shit(self):
        print ("%s 拉 " %self.name)
    def pee(self):
        print ("%s 撒 " %self.name)
class Cat(Animal):
    def __init__(self, name):
        self.name = name
        self.breed = '猫'
    def cry(self):
        print('喵喵叫')
class Dog(Animal):
    def __init__(self, name):
        self.name = name
        self.breed='狗'
    def cry(self):
        print('汪汪叫')
# ######### 执行 #########
c1 = Cat('小白家的小黑猫')
c1.eat()
c2 = Cat('小黑的小白猫')
c2.drink()
d1 = Dog('胖子家的小瘦狗')
d1.eat()
```

在开发程序的过程中，如果我们定义了一个类A，然后又想新建立另外一个类B，但是类B的大部分内容与类A的相同时

我们不可能从头开始写一个类B，这就用到了类的继承的概念。

通过继承的方式新建类B，让B继承A，B会‘遗传’A的所有属性(数据属性和函数属性)，实现代码重用

```plain
class Hero:
    def __init__(self,nickname,aggressivity,life_value):
        self.nickname=nickname
        self.aggressivity=aggressivity
        self.life_value=life_value
    def move_forward(self):
        print('%s move forward' %self.nickname)
    def move_backward(self):
        print('%s move backward' %self.nickname)
    def move_left(self):
        print('%s move forward' %self.nickname)
    def move_right(self):
        print('%s move forward' %self.nickname)
    def attack(self,enemy):
        enemy.life_value-=self.aggressivity
class Garen(Hero):
    pass
class Riven(Hero):
    pass
g1=Garen('草丛伦',100,300)
r1=Riven('锐雯雯',57,200)
print(g1.life_value)
r1.attack(g1)
print(g1.life_value)
'''
运行结果
243
'''
```

提示：用已经有的类建立一个新的类，这样就重用了已经有的软件中的一部分设置大部分，大大生了编程工作量，这就是常说的软件重用，不仅可以重用自己的类，也可以继承别人的，比如标准库，来定制新的数据类型，这样就是大大缩短了软件开发周期，对大型软件开发来说，意义重大.

注意：像g1.life_value之类的属性引用，会先从实例中找life_value然后去类中找，然后再去父类中找...直到最顶级的父类。

---

| 解决代码冗余实现 |
| :--- |

```plain
class OldboyPeople:
    school = 'Oldboy'
    def __init__(self,name,age,sex):
        self.name = name
        self.age = age
        self.sex = sex
class OldboyStudent(OldboyPeople):
    # def __init__(self, name, age, sex, score=0):
    #     self.name = name
    #     self.age = age
    #     self.sex = sex
    #     self.score = score
    def choose_course(self):
        print('%s choosing course' % self.name)
class OldboyTeacher(OldboyPeople):
    # def __init__(self,name,age,sex,level):
    #     self.name=name
    #     self.age=age
    #     self.sex=sex
    #     self.level=level
    def score(self,stu,num):
        stu.score=num
stu1=OldboyStudent('刘二蛋',38,'male')
print(stu1.__dict__)
tea1=OldboyTeacher('zls',18,'male')
print(tea1.__dict__)
## 上面虽然解决了代码冗余，但是学生类只有父类的特征，没有学生自己独有的特征，如何解决呢？
```

---

| 在子类派生出的新方法中重用父类功能一 |
| :--- |

```plain
# 方式一：
# 指名道姓地引用某一个类中的函数
# 总结:
# 1. 与继承无关
# 2. 访问是类的函数,没有自动传值的效果
class OldboyPeople:
    school = 'Oldboy'
    def __init__(self,name,age,sex):
        self.name = name
        self.age = age
        self.sex = sex
class OldboyStudent(OldboyPeople):
    def __init__(self, name, age, sex, score=0):
        OldboyPeople.__init__(self,name,age,sex)
        self.score = score
    def choose_course(self):
        print('%s choosing course' % self.name)
class OldboyTeacher(OldboyPeople):
    def __init__(self,name,age,sex,level):
        OldboyPeople.__init__(self,name,age,sex)
        self.level=level
    def score(self,stu,num):
        stu.score=num
stu1=OldboyStudent('刘二蛋',38,'male')
print(stu1.__dict__)
tea1=OldboyTeacher('egon',18,'male',10)
print(tea1.__dict__)
```

---

| 单继承背景下的属性查找 |
| :--- |

```plain
# 在单继承背景下属性的查找优先级:对象->对象的类->父类->父类.....
class Foo:
    # xxx=444
    pass
class Bar1(Foo):
    # xxx=333
    pass
class Bar2(Bar1):
    # xxx=222
    pass
obj=Bar2()
# obj.xxx=111
print(obj.xxx)
## 挖坑
class Foo:
    def f1(self):
        print('Foo.f1')
    def f2(self):
        print('Foo.f2')
        self.f1() #obj.f1()
class Bar(Foo):
    def f1(self):
        print('Bar.f1')
obj=Bar()
obj.f2()
## 结果是下面两个哪一个？
'''
Foo.f2
Foo.f1
'''
'''
Foo.f2
Bar.f1
'''
```

---

| 多继承背景下的属性查找 |
| :--- |

```plain
# 在多继承背景下属性的查找优先级:
# 如果一个子类继承多个分支(多个分支没有共同继承一个非object的类)
# 此时属性的查找优先级是:对象->对象的类->按照从左往右的顺序一个分支一个分支的找下去
# # 第四层:
class G:
    # x = 'G'
    pass
# 第三层
class E(G):
    # x = 'E'
    pass
class F:
    # x = 'F'
    pass
# 第二层
class B(E):
    # x = 'B'
    pass
class C(F):
    # x = 'C'
    pass
class D:
    # x = 'D'
    pass
# 第一层
class A(B, C, D):
    # x = 'A'
    pass
obj = A()
# obj.x = 111
print(obj.x)
#菱形继承问题:
# 新式类 : 广度优先查找,从左往右一个分支一个分支的查找,在最后一个分支才去查找顶级类
# 经典类 : 深度优先查找,从左往右一个分支一个分支的查找,在第一个分支就查找顶级类
# 第四层:
class G(object):
    # x = 'G'
    pass
# 第三层
class E(G):
    # x = 'E'
    pass
class F(G):
    # x = 'F'
    pass
# 第二层
class B(E):
    # x = 'B'
    pass
class C(F):
    # x = 'C'
    pass
class D(G):
    # x = 'D'
    pass
# 第一层
class A(B, C, D):
    # x = 'A'
    pass
obj=A()
# obj.x=111
print(obj.x)
#新式类(广度优先): obj->A->B->E->C-F->D->G->object
#经典类(深度优先): obj->A->B->E->G->C-F->D
# python专门为新式类内置了一个mro的方法,用来查看c3算法的计算结果,结果是??
print(A.mro())
```

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 排名 |
| --- | --- | --- | --- |
| G | E(G) | F(G) | 2 |
| B(E) | C(F) | D(G) | 4 |
| 曾老湿 | A(B,C,D) | DriverZeng | 下，在要查找属性不存在时、会按照深度优先的方式查找下去 |
<!-- OCR_END -->

￼

<!-- OCR_START -->
| 名称 | 名称 | 排名 | 名称 |
| --- | --- | --- | --- |
| F(G) | 2 | 4 | B(E) |
| C(F) | D(G) | 3 | 曾老湿 |
| A(B,C,D) | DriverZeng | 下， | 在要查找属性不存在时，会按照广度优先的方式查找下去 |
<!-- OCR_END -->

￼

了解知识点：

python到底是如何实现继承的，对于你定义的每一个类，python会计算出一个方法解析顺序(MRO)列表，这个MRO列表就是一个简单的所有基类的线性顺序列表，例如:

```plain
>>> F.mro() #等同于F.__mro__
[<class '__main__.F'>, <class '__main__.D'>, <class '__main__.B'>, <class '__main__.E'>, <class '__main__.C'>, <class '__main__.A'>, <class 'object'>]
```

为了实现继承,python会在MRO列表上从左到右开始查找基类,直到找到第一个匹配这个属性的类为止。

而这个MRO列表的构造是通过一个C3线性化算法来实现的。我们不去深究这个算法的数学原理,它实际上就是合并所有父类的MRO列表并遵循如下三条准则:

1.子类会先于父类被检查

2.多个父类会根据它们在列表中的顺序被检查

3.如果对下一个类存在两个合法的选择,选择第一个父类

---

| 在子类派生出的新方法中重用父类功能二 |
| :--- |

```plain
# 方式二:super()必须在类中用
# 在python2中:super(自己的类名,自己的对象)
# 在python3中:super()
# 调用该函数会得到一个特殊的对象,该对象专门用来访问父类中的属性,!!!完全参照mro列表!!!!
# 总结:
# 1. 严格依赖继承的mro列表
# 2. 访问是绑定方法,有自动传值的效果
class OldboyPeople:
    school = 'Oldboy'
    def __init__(self,name,age,sex):
        self.name = name
        self.age = age
        self.sex = sex
class OldboyStudent(OldboyPeople):
    def __init__(self, name, age, sex, score=0):
        super(OldboyStudent,self).__init__(name,age,sex)
        self.score = score
    def choose_course(self):
        print('%s choosing course' % self.name)
class OldboyTeacher(OldboyPeople):
    def __init__(self,name,age,sex,level):
        super().__init__(name,age,sex)
        self.level=level
    def score(self,stu,num):
        stu.score=num
stu1=OldboyStudent('刘二蛋',38,'male')
print(stu1.__dict__)
tea1=OldboyTeacher('zls',18,'male',10)
print(tea1.__dict__)
## 举例
class A:
    def f1(self):
        print('A.f1')
        super().f2()
class B:
    def f2(self):
        print('B.f2')
class C(A,B):
    def f2(self):
        print('C.f2')
obj=C()
print(C.mro())
obj.f1()
'''
A.f1
'''
```

**强调：二者使用哪一种都可以，但最好不要混合使用 **

## 组合
---

| 什么是组合？ |
| :--- |

软件重用的重要方式除了继承之外还有另外一种方式，即：组合

组合指的是，在一个类中以另外一个类的对象作为数据属性，称为类的组合

大白话：组合指的是某一个对象拥有一个属性,该属性的值是另外一个类的对象

例如：

```plain
class Foo:
    pass
class Bar:
    pass
obj=Foo()
obj.attr=Bar()
# 用Foo的属性
obj.xxx
# 用Bar的属性
obj.attr.yyy
```

---

| 为啥要用组合？ |
| :--- |

通过为某一个对象添加属性(属性的值是另外一个类的对象)的方式,可以间接地将两个类关联/整合/组合到一起,从而减少类与类之间代码冗余

```plain
class Foo1:
    pass
class Foo2:
    pass
class Foo3:
    pass
class Bar:
    pass
obj_from_bar=Bar()
obj1=Foo1()
obj2=Foo2()
obj3=Foo3()
obj1.attr1=obj_from_bar
obj2.attr2=obj_from_bar
obj3.attr3=obj_from_bar
```

---

| 如何使用组合 |
| :--- |

```plain
class OldboyPeople:
    school = 'Oldboy'
    def __init__(self,name,age,sex,):
        self.name = name
        self.age = age
        self.sex = sex
class OldboyStudent(OldboyPeople):
    def __init__(self, name, age, sex,score=0):
        OldboyPeople.__init__(self,name,age,sex)
        self.score = score
    def choose_course(self):
        print('%s choosing course' % self.name)
class OldboyTeacher(OldboyPeople):
    def __init__(self,name,age,sex,level):
        OldboyPeople.__init__(self,name,age,sex)
        self.level=level
    def score(self,stu,num):
        stu.score=num
class Course:
    def __init__(self,c_name,c_price,c_period):
        self.c_name = c_name
        self.c_price = c_price
        self.c_period = c_period
    def tell_info(self):
        print('<课程名:%s 价钱:%s 周期:%s>' %(self.c_name,self.c_price,self.c_period))
# 创建课程对象
python=Course('python全栈开发',100,'5mons')
linux=Course('linux架构师',20000,'3mons')
stu1=OldboyStudent('刘二蛋',38,'male')
stu1.course=python
# print(stu1.__dict__)
stu1.course.tell_info()
tea1=OldboyTeacher('zls',18,'male',10)
tea1.course=python
# print(tea1.__dict__)
tea1.course.tell_info()
```

---

| 练习：让学生有多门课程 |
| :--- |

```plain
class OldboyPeople:
    school = 'Oldboy'
    def __init__(self,name,age,sex,):
        self.name = name
        self.age = age
        self.sex = sex
class OldboyStudent(OldboyPeople):
    def __init__(self, name, age, sex,score=0):
        OldboyPeople.__init__(self,name,age,sex)
        self.score = score
        self.courses=[]
    def choose_course(self):
        print('%s choosing course' % self.name)
    def tell_all_course(self):
        print(('学生[%s]选修的课程如下' %self.name).center(50,'='))
        for obj in self.courses:
            obj.tell_info()
        print('='*60)
class OldboyTeacher(OldboyPeople):
    def __init__(self,name,age,sex,level):
        OldboyPeople.__init__(self,name,age,sex)
        self.level=level
        self.courses=[]
    def score(self,stu,num):
        stu.score=num
    def tell_all_course(self):
        print(('老师[%s]教授的课程如下' %self.name).center(50,'*'))
        for obj in self.courses:
            obj.tell_info()
        print('*'*70)
class Course:
    def __init__(self,c_name,c_price,c_period):
        self.c_name = c_name
        self.c_price = c_price
        self.c_period = c_period
    def tell_info(self):
        print('<课程名:%s 价钱:%s 周期:%s>' %(self.c_name,self.c_price,self.c_period))
# 创建课程对象
python=Course('python全栈开发',1900,'5mons')
linux=Course('linux架构师',900,'3mons')
stu1=OldboyStudent('刘二蛋',38,'male')
stu1.courses.append(python)
stu1.courses.append(linux)
# print(stu1.courses)
stu1.tell_all_course()
tea1=OldboyTeacher('zls',18,'male',10)
tea1.courses.append(zls)
# print(tea1.courses)
tea1.tell_all_course()
```

## 多态与多态性
---

| 什么是多态？ |
| :--- |

多态指的是一类事物有多种形态

动物有多种形态：人，狗，猪

水也有多种形态：冰，水蒸气，水

```plain
class Animal:
    def speak(self):
        pass
class People(Animal):
    def shuo(self):
        print('say hello')
class Dog(Animal):
    def jiao(self):
        print('汪汪汪')
class Pig(Animal):
    def chang(self):
        print('哼哼哼')
        
        
        
obj1=People()
obj2=Dog()
obj3=Pig()
# obj1.speak()
# obj2.speak()
# obj3.speak()
def speak(animal):
    animal.speak()
speak(obj1)
speak(obj2)
speak(obj3)
s1='hello'
l1=[1,2,3]
t1=(1,2)
# changdu(s1)
# size(l1)
# kuandu(t1)
print(len(s1)) #s1.__len__()
print(len(l1)) #l1.__len__()
print(len(t1)) #t1.__len__()
```

如何强制子类的规范？

```plain
import abc
class Animal(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def speak(self):
        pass
    @abc.abstractmethod
    def run(self):
        pass
# Animal() # 父类只是用来建立规范的,不能用来实例化的,更无需实现内部的方法
class People(Animal):
    def speak(self):
        print('say hello')
    def run(self):
        pass
class Dog(Animal):
    def speak(self):
        print('汪汪汪')
    def run(self):
        pass
class Pig(Animal):
    def speak(self):
        print('哼哼哼')
    def run(self):
        pass
obj1=People()
obj2=Dog()
obj3=Pig()
# python崇尚鸭子类型
class Disk:
    def read(self):
        print('Disk read')
    def write(self):
        print('Disk write')
class Memory:
    def read(self):
        print('Mem read')
    def write(self):
        print('Mem write')
class Cpu:
    def read(self):
        print('Cpu read')
    def write(self):
        print('Cpu write')
obj1=Disk()
obj2=Memory()
obj3=Cpu()
obj1.read()
obj2.read()
obj3.read()
```

---

| 为啥用多态？ |
| :--- |

多态性:在多态的背景下,可以在不用考虑对象具体类型的前提下而直接使用对象

多态性的精髓:统一

在面向对象方法中一般是这样表述多态性：向不同的对象发送同一条消息（！！！obj.func():是调用了obj的方法func，又称为向obj发送了一条消息func），不同的对象在接收时会产生不同的行为（即方法）。也就是说，每个对象可以用自己的方式去响应共同的消息。所谓消息，就是调用函数，不同的行为就是指不同的实现，即执行不同的函数。

比如：老师.下课铃响了（），学生.下课铃响了()，老师执行的是下班操作，学生执行的是放学操作，虽然二者消息一样，但是执行的效果不同

多态性分为静态多态性和动态多态性

静态多态性：如任何类型都可以用运算符+进行运算

动态多态性：如下

```plain
peo=People()
dog=Dog()
pig=Pig()
#peo、dog、pig都是动物,只要是动物肯定有talk方法
#于是我们可以不用考虑它们三者的具体是什么类型,而直接使用
peo.talk()
dog.talk()
pig.talk()
#更进一步,我们可以定义一个统一的接口来使用
def func(obj):
    obj.talk()
```

其实大家从上面多态性的例子可以看出，我们并没有增加什么新的知识，也就是说python本身就是支持多态性的，这么做的好处是什么呢？

1.增加了程序的灵活性

以不变应万变，不论对象千变万化，使用者都是同一种形式去调用，如func(animal)

2.增加了程序额可扩展性

通过继承animal类创建了一个新的类，使用者无需更改自己的代码，还是用func(animal)去调用 　　　　

```plain
>>> class Cat(Animal): #属于动物的另外一种形态：猫
...     def talk(self):
...         print('say miao')
... 
>>> def func(animal): #对于使用者来说，自己的代码根本无需改动
...     animal.talk()
... 
>>> cat1=Cat() #实例出一只猫
>>> func(cat1) #甚至连调用方式也无需改变，就能调用猫的talk功能
say miao
'''
这样我们新增了一个形态Cat，由Cat类产生的实例cat1，使用者可以在完全不需要修改自己代码的情况下。使用和人、狗、猪一样的方式调用cat1的talk方法，即func(cat1)
'''
```

---

| 鸭子类型 |
| :--- |

**逗比时刻：**

Python崇尚鸭子类型，即‘如果看起来像、叫声像而且走起路来像鸭子，那么它就是鸭子’

python程序员通常根据这种行为来编写程序。例如，如果想编写现有对象的自定义版本，可以继承该对象

也可以创建一个外观和行为像，但与它无任何关系的全新对象，后者通常用于保存程序组件的松耦合度。

例1：利用标准库中定义的各种‘与文件类似’的对象，尽管这些对象的工作方式像文件，但他们没有继承内置文件对象的方法

```plain
#二者都像鸭子,二者看起来都像文件,因而就可以当文件一样去用
class TxtFile:
    def read(self):
        pass
    def write(self):
        pass
class DiskFile:
    def read(self):
        pass
    def write(self):
        pass
```

例2：其实大家一直在享受着多态性带来的好处，比如Python的序列类型有多种形态：字符串，列表，元组，多态性体现如下

```plain
#str,list,tuple都是序列类型
s=str('hello')
l=list([1,2,3])
t=tuple((4,5,6))
#我们可以在不考虑三者类型的前提下使用s,l,t
s.__len__()
l.__len__()
t.__len__()
len(s)
len(l)
len(t)
```

## 封装
---

| 什么是封装 |
| :--- |

装:往容器/名称空间里存入名字

封:代表将存放于名称空间中的名字给藏起来,这种隐藏对外不对内

从封装本身的意思去理解，封装就好像是拿来一个麻袋，把小猫，小狗，小王八，还有alex一起装进麻袋，然后把麻袋封上口子。照这种逻辑看，封装='隐藏'，这种理解是相当片面的

---

| 如何封装 |
| :--- |

```plain
class Foo:
    __x=111 # _Foo__x
    __y=222 # _Foo__y
    def __init__(self,name,age):
        self.__name=name
        self.__age=age
    def __func(self): #_Foo__func
        print('func')
    def get_info(self):
        print(self.__name,self.__age,self.__x)#print(self._Foo__name,self._Foo__age,self._Foo__x)
----- 封装
print(Foo.__x)
print(Foo.__func)
print(Foo.__dict__)
print(Foo._Foo__x)
print(Foo._Foo__y)
Foo.__z=333
print(Foo.__dict__)
print(Foo.__z)
obj=Foo('zls',18)
print(obj.__dict__)
print(obj.__name)
print(obj.__age)
obj.get_info()
obj.__sex='male'
print(obj.__dict__)
print(obj.__sex)
obj.get_info()
# 1. __开头的属性到底如何实现的隐藏?
# 2. 如何实现的对外隐藏,对内不隐藏
在类内定义的属性前加__开头(没有__结尾)
总结:
1.__开头的属性实现的隐藏仅仅只是一种语法意义上的变形,并不会真的限制类外部的访问
2. 该变形操作只在类定义阶段检测语法时发生一次,类定义阶段之后新增的__开头的属性并不会变形
3. 如果父类不想让子类覆盖自己的属性,可以在属性前加__开头
class Foo:
    def __f1(self): #_Foo__f1
        print('Foo.f1')
    def f2(self):
        print('Foo.f2')
        self.__f1() #obj._Foo__f1()
class Bar(Foo):
    def __f1(self): # _Bar__f1
        print('Bar.f1')
obj=Bar()
# obj.f2()
'''
Foo.f2
Bar.f1
'''
```

---

| 为啥要封装 |
| :--- |

封装数据属性：将数据属性隐藏起来,类外就无法直接操作属性,需要类内开辟一个接口来外部的使用可以间接地操作属性,可以在接口内定义任意的控制逻辑,从而严格控制使用对属性的操作

```plain
class People:
    def __init__(self,name,age):
        self.__name=name
        self.__age=age
    def tell_info(self):
        print('<name:%s age:%s>'  %(self.__name,self.__age))
    def set_info(self,name,age):
        if type(name) is not str:
            print('名字必须是str类型傻叉')
            return
        if type(age) is not int:
            print('年龄必须是int类型傻叉')
            return
        self.__name=name
        self.__age=age
obj=People('zls',18)
# obj.tell_info()
# obj.set_info('zls',19)
# obj.set_info(123,19)
obj.set_info('zls','18')
obj.tell_info()
```

封装函数属性：

1.你的身体没有一处不体现着封装的概念：你的身体把膀胱尿道等等这些尿的功能隐藏了起来，然后为你提供一个尿的接口就可以了（接口就是你的。。。，），你总不能把膀胱挂在身体外面，上厕所的时候就跟别人炫耀：hi，man，你瞅我的膀胱，看看我是怎么尿的。

2.电视机本身是一个黑盒子，隐藏了所有细节，但是一定会对外提供了一堆按钮，这些按钮也正是接口的概念，所以说，封装并不是单纯意义的隐藏！！！

3.快门就是傻瓜相机为傻瓜们提供的方法，该方法将内部复杂的照相功能都隐藏起来了

提示：在编程语言里，对外提供的接口（接口可理解为了一个入口），可以是函数，称为接口函数，这与接口的概念还不一样，接口代表一组接口函数的集合体。

```plain
# 封装函数属性:隔离复杂度
class ATM:
    def __card(self):
        print('插卡')
    def __auth(self):
        print('用户认证')
    def __input(self):
        print('输入取款金额')
    def __print_bill(self):
        print('打印账单')
    def __take_money(self):
        print('取款')
    def withdraw(self):
        self.__card()
        self.__auth()
        self.__input()
        self.__print_bill()
        self.__take_money()
a=ATM()
a.withdraw()
```

## property装饰器
---

| 什么是property |
| :--- |

property是一种特殊的属性，访问它时会执行一段功能（函数）然后返回值（它就是一个装饰器）

例一：BMI指数（bmi是计算而来的，但很明显它听起来像是一个属性而非方法，如果我们将其做成一个属性，更便于理解）

成人的BMI数值：

过轻：低于18.5

正常：18.5-23.9

过重：24-27

肥胖：28-32

非常肥胖, 高于32

体质指数（BMI）=体重（kg）÷身高<sup>2（m）</sup>

EX：70kg÷（1.75×1.75）=22.86

```plain
class People:
    def __init__(self,name,weight,height):
        self.name=name
        self.weight=weight
        self.height=height
    def bmi(self):
        return self.weight / (self.height**2)
obj=People('zls',60,1.85)
obj.height=1.88
obj.weight=55
```

如何将类内的数据属性，伪装成数据属性？

**关键用法**

```plain
class People:
    def __init__(self,name,weight,height):
        self.name=name
        self.weight=weight
        self.height=height
    @property
    def bmi(self):
        return self.weight / (self.height**2)
obj=People('zls',60,1.85)
obj.height=1.88
obj.weight=55
```

**了解知识点**

```plain
class People:
    def __init__(self,name):
        self.__name=name
    @property
    def name(self):
        return '<名字:%s>' %self.__name
    @name.setter
    def name(self,obj):
        if type(obj) is not str:
            print('name必须为str类型')
            return
        self.__name=obj
    @name.deleter
    def name(self):
        # print('不让删')
        del self.__name
obj=People('zls')
print(obj.name)
obj.name='ZLS'
obj.name=123
print(obj.name)
del obj.name
print(obj.__dict__)
## 古老写法
class People:
    def __init__(self,name):
        self.__name=name
    def get_name(self):
        return '<名字:%s>' %self.__name
    def set_name(self,obj):
        if type(obj) is not str:
            print('name必须为str类型')
            return
        self.__name=obj
    def del_name(self):
        # print('不让删')
        del self.__name
    name=property(get_name,set_name,del_name)
obj=People('zls')
print(obj.name)
obj.name='ZLS'
obj.name=123
print(obj.name)
del obj.name
print(obj.__dict__)
```

## 绑定方法与非绑定方法
---

| 绑定方法 |
| :--- |

绑定方法（绑定给谁，谁来调用就自动将它本身当作第一个参数传入）：

1.绑定到类的方法：用classmethod装饰器装饰的方法。

为类量身定制

类.boud_method(),自动将类当作第一个参数传入（其实对象也可调用，但仍将类当作第一个参数传入）

```plain
class Foo:
    def f1(self):
        print(self)
    @classmethod
    def f2(cls):
        print(cls)
obj=Foo()
print(obj.f1)
obj.f1()
print(Foo.f2)
Foo.f2()
print(obj.f2)
obj.f2()
```

2.绑定到对象的方法：没有被任何装饰器装饰的方法。

为对象量身定制

对象.boud_method(),自动将对象当作第一个参数传入

属于类的函数，类可以调用，但是必须按照函数的规则来，没有自动传值那么一说）

---

| 非绑定方法 |
| :--- |

非绑定方法：用staticmethod装饰器装饰的方法

1.不与类或对象绑定，类和对象都可以调用，但是没有自动传值那么一说。就是一个普通工具而已

注意：与绑定到对象方法区分开，在类中直接定义的函数，没有被任何装饰器装饰的，都是绑定到对象的方法，可不是普通函数，对象调用该方法会自动传值，而staticmethod装饰的方法，不管谁来调用，都没有自动传值一说

```plain
class Foo:
    def f1(self):
        print(self)
    @classmethod
    def f2(cls):
        print(cls)
    @staticmethod
    def f3(x,y):
        print('f3',x+y)
obj=Foo()
print(Foo.f3)
print(obj.f3)
Foo.f3(1,2)
obj.f3(3,4)
```

---

| 绑定方法和非绑定方法的应用 |
| :--- |

```plain
class MySql:
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
    def tell_info(self):
        print('<id:%s ip:%s port:%s>' % (self.id, self.ip, self.port))
obj1=MySql('1.1.1.1',3306)
obj1.tell_info()
## 上面的方法做起来 很麻烦，我们还得往里面传递一个IP和端口
# 我们通过配置文件的方法，来设置MySQL的端口和IP
# settings.py 内容
IP='192.168.101.100'
PORT=3306
## 从settings中取出变量
import settings
class MySql:
    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
    def tell_info(self):
        print('<id:%s ip:%s port:%s>' % (self.id, self.ip, self.port))
    @classmethod
    def from_conf(cls):
        return cls(settings.IP, settings.PORT)
obj2=MySql(settings.IP,settings.PORT)
## 但是 这个方法还是不简单，我每次都要记住settings.IP,settings.PORT
# 更简单的方法
obj2 = MySql.from_conf()
obj2.tell_info()
## 现在给每一个对象加一个独一无二的id
import settings
class MySql:
    def __init__(self, ip, port):
        self.id = self.create_id()
        self.ip = ip
        self.port = port
    def tell_info(self):
        print('<id:%s ip:%s port:%s>' % (self.id, self.ip, self.port))
    @classmethod
    def from_conf(cls):
        return cls(settings.IP, settings.PORT)
    @staticmethod
    def create_id():
        import uuid
        return uuid.uuid4()
obj2 = MySql.from_conf()
obj2.tell_info()
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:19:21  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/dp4l73>