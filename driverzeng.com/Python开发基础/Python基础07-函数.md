# Python基础07-函数

## Python基础07-函数

2019-04-29 分类：[Linux](https://www.driverzeng.com/zenglaoshi/category/linux), [Python](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80/python), [脚本语言](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80) 阅读(45) 评论(0)

* [函数知识体系](https://www.driverzeng.com/zenglaoshi/1351.html#toc_0)

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

# 函数知识体系

| 介绍 |
| :--- |

```plain
1.什么是函数？
2.为什么要用函数？
3.函数的分类：内置函数与自定义函数
4.如何自定义函数
  语法
  定义有参数函数，及有参函数的应用场景
  定义无参数函数，及无参函数的应用场景
  定义空函数，及空函数的应用场景
5.调用函数
    如何调用函数
    函数的返回值
    函数参数的应用：形参和实参，位置参数，关键字参数，默认参数，*args，**kwargs
6.高阶函数（函数对象）
7.函数嵌套
8.作用域与名称空间
9.装饰器
10.迭代器与生成器及协程函数
11.三元运算，列表解析、生成器表达式
12.函数的递归调用
13.内置函数
14.面向过程编程与函数式编程
```

***

| 什么是函数 |
| :--- |

**函数就是具备某一功能的工具**

***

| 为什么要用函数 |
| :--- |

**如果不使用函数，那么你的代码：\
****1.程序的组织结构不清晰，可读性差\
****2.代码冗余\
\*\*\*\*3.可扩展性（功能需要修改的时候...对不起GG）**

***

| 如何使用函数 |
| :--- |

**函数的使用必须遵循的原则：先定义，后调用\
****修理工事先准备好工具的过程，即，定义函数\
****修理工遇到应用场景哪来工具就用即函数的调用**

```plain
语法：
def 函数名(参数1，参数2，参数3...)
    “”“
    文档注释
    ”“”
    code1
    code2
    code3
    ...
    return 返回值
#def：定义函数的关键字
#函数名：就相当于一个变量名，指向函数的内存地址，
        #注意：加（）就可以触发函数体代码的执行
#参数：参数是函数的调用者函数体代码传值的媒介，在Python当中，函数的参数无需声明类型
        #定义时，无参，调用时也无参
#文档注释：推荐写上
#代码块：就是函数体功能的具体实现
#return返回值：函数体代码块运行的成果
```

```plain
#定义函数
def foo():
    pass
print(foo)
#触发函数体代码执行
def foo():
    print('from foo')
foo()
#定义无参函数：当函数体的代码逻辑不依赖任何传入的值就能执行，就不需要定义参数
def print_msg():
    print('='*50)
    print('welecome...'.center(50,' '))
    print('='*50)
print_msg()
print_msg()
#定义有参函数：当函数体的代码看逻辑依赖于外部调用者传入的值才能执行，必须定义参数用来接收外部传入的值
def max2(x,y):
    if x > y:
        print(x)
    else:
        print(y)
max2(10,2)
max2(1,2)
#返回结果
def max2(x,y):
    if x > y:
        return x
    else:
        return y
res=max(1,4)
print(res)
```

函数分为两个阶段：

1.调用阶段：运行函数体代码

2.定义阶段：只检测语法，不执行代码

```plain
def foo():
    aakjdakjsdasdasd
    print(
```

函数里调用函数

```plain
def foo():
    print('from foo')
def bar():
    print('from bar')
    foo()
bar()
def bar():
    print('from bar')
    foo()
def foo():
    print('from foo')
bar()
```

总结：

定义函数的三种形式

1.无参函数

2.有参函数

3.空函数

调用函数的三种形式

1.语句形式 foo()

2.表达式形式 res=foo(1,2)\*100

3.当做参数传给另外一个函数

```plain
def max2(x,y):
    if x > y:
        return x
    else:
        return y
#1 2 3比较大小
res=max2(max2(1,2),3)
print(res)
```

***

| 函数的返回值 |
| :--- |

一.函数的返回值，需要注意：

1.返回值没有类型限制

```plain
def foo():
    return [1,2]
res=foo()
print(res,type(res))
```

2.返回值没有个数限制

1）如果返回1个值：调用函拿到的结果就是一个值

2）如果返回多个值：调用函数拿到的结果就是一个元组

3）如果返回0个值：调用函数拿到的结果就是None

```plain
def bar():
    pass
def foo():
    return [1,2],1,1.3,{"name":"zls"},bar
res=foo()
print(res,type(res))
```

二.return关键字

```plain
def f1():
    print('first')
    return 1
    print('second')
    return 2
    print('third')
    return 3
res=f1()
print(res)
```

`return`是函数结束的标志，函数内可以有多个return，但只要执行一次，整个函数就结束

***

| 函数参数的使用 |
| :--- |

函数的参数分为两大类：

1.形参：

在定义阶段括号内指定的变量名，称之为形参，即形参本质就是`变量名`

2.实参：

指的是在调用函数阶段，括号内传入的值，即实参本质就是`值`

```plain
def foo(x,y):
    print(x,y)
foo(1,2)
#相当于：
def foo():
    x=1
    y=2
    print(x,y)
foo()
```

**形参与实参的具体分类**

**1.位置参数**

1）位置形参：在定义函数阶段按照从左到右的顺序依次定义的形参，称之为位置形参

注意：但凡按照位置定义的形参，必须被传值，多一个不行，少一个也不行

2）位置实参：在调用函数阶段按照从左到右的顺序依次传递的值，称之为位置实参

注意：但凡按照位置定义的实参，会按照形参一一对应

```plain
#位置形参
def foo(x,y):
    print(x,y)
#位置实参
foo(1,2)
```

```plain
#位置形参
def foo(x,y):
    print(x,y)
#位置实参
foo(1,2,3)
```

```plain
#位置形参
def foo(x,y):
    print(x,y)
#位置实参
foo(1)
```

```plain
#位置形参
def foo(x,y):
    print(x,y)
#位置实参
foo(2,1)
```

如果要按照位置的方式去传值，那么我们就要记住，每一个参数的位置。

**2.关键字参数（关键字实参）**

在调用函数阶段，按照`key=value`的形式，指名道姓的为形参传值。

注意1：可以完全打乱顺序，但仍然能指名道姓的形参传值

```plain
#按照位置传参
def foo(name,age):
    print(name,age)
foo('zls',18)
#如果换了位置
def foo(name,age):
    print(name,age)
foo(18,'zls')
#关键字实参
def foo(name,age):
    print(name,age)
foo(name='zls',age=18)
#打破位置
def foo(name,age):
    print(name,age)
foo(age=18,name='zls')
```

2：可以混合使用：\
但是必须注意\
1)位置实参必须放到关键字实参前面\
2)不能对同一个形参，重复赋值

```plain
#如果这么写 ，会报语法错误
def foo(name,age):
    print(name,age)
foo(name='zls',18)
#正确写法
def foo(name,age):
    print(name,age)
foo('zls',age=18)
```

```plain
#对一个形参，重复赋值
def foo(name,age):
    print(name,age)
foo('zls',age=18,name='oldboy')
#我们之前学的对文件操作，open就是一个函数
# open(file, mode='r', buffering=None, encoding=None, errors=None, newline=None, closefd=True)
#如果这么写，会报错
open('a.txt','r','utf-8')
#如下写法，就没问题，是因为我们将位置实参，和关键字实参混合使用
open('a.txt','r',encoding='utf-8')
```

**3.默认参数（形参）**

指的是在定义函数阶段，就已经为某个形参复制了，改形参称之为有默认值的形参，简称：默认形参

注意：\
1.在定义阶段就已经被赋值，意味着，在调用阶段，可以不用为其赋值\
2.位置形参应该放到默认形参的前面\
3.默认参数的值，在函数定义阶段就固定死了\
4.默认参数通常应该是不可变类型

```plain
def foo(x,y=2):
    print(x,y)
foo(1)
```

```plain
def foo(x,y=2):
    print(x,y)
foo(1)
foo(1,3)
foo(y=3,x=1)
```

应用场景:

```plain
#比如我写一个注册功能
def register(name,age,sex):
    print(name,age,sex)
register('zls',18,'male')
register('bgx',73,'male')
register('oldboy',84,'male')
#如果注册大多都是男生那么可以给一个默认值
def register(name,age,sex='male'):
    print(name,age,sex)
register('zls',18)
register('bgx',73)
register('oldboy',84)
register('oldgirl','female')
#错误写法
def register(sex='male',name,age):
    print(name,age,sex)
register('zls',18)
```

```plain
m=10
def foo(x,y=m):
    print(x,y)
foo(1)
m=10
def foo(x,y=m):
    print(x,y)
m=20
foo(1)
```

```plain
def register(name,hobby,l=[]):
    l.append(hobby)
    print('%s的爱好为 %s' %(name,l))
register('alex','piao')
register('bgx','KTV')
register('zls','read')
def register(name,hobby,l=None):
    if l is None:
        l=[]
    l.append(hobby)
    print('%s的爱好为 %s' %(name,l))
register('alex','piao')
register('bgx','KTV')
register('zls','read')
def register(name,hobby,l=[]):
    l.append(hobby)
    print('%s的爱好为 %s' %(name,l))
register('alex','piao',[])
register('bgx','KTV',[])
register('zls','read',[])
```

4.可变长参数

站在实参的角度，参数长度可变指的是在调用函数时，传入的实参值的个数不固定

实参的定义方式无非两种：位置实参，关键字实参，对应着形参也必须有两种解决方案，来分别应对溢出的位置实参与关键字实参。`*`与 `**`

1.在形参中带`*`：会将调用函数时溢出位置实参保存成元组的形式，然后赋值`*`后的变量名

```plain
def foo(x,y,*z):
    print(x,y)
    print(z)
    
foo(1,2,3,4,5)
```

2.在形参中带`**`：会将调用函数时溢出的关键字实参保存成字典的形式，然后赋值给`**`后的变量名

```plain
def foo(x,y,**z):
    print(x,y)
    print(z)
foo(1,y=2,z=3,a=4,b=5)
```

3.在实参中带`*`：在传值前，都先将其打散成位置实参，再进行赋值

```plain
def foo(x,y,*z):
    print(x,y,z)
foo(1,*[2,3,4,5])
def foo(x,y,z):
    print(x,y,z)
foo(1,*(2,3,4,5))
def foo(x,y,z):
    print(x,y,z)
foo(*(1,2,3))
def foo(x,y,z):
    print(x,y,z)
foo(*'hello')
def foo(x,y,z):
    print(x,y,z)
foo(*'abc')
```

4.在实参中带`**`：

```plain
def foo(x,y,**z):
    print(x,y,z)
foo(1,{'a':100,'b':2})
def foo(x,y,**z):
    print(x,y,z)
foo(1,**{'a':100,'b':2,'y':10})
```

***

当我们想要将一个函数的参数格式原封不动的转嫁给其内部的一个函数，应该使用下面的形式

```plain
#下面这种写法，结果会如何？
def bar(x,y,z):
    print(x,y,z)
def wrapper(*args,**kwargs):#args=(1,2,3,4,5)  kwargs={'a':1,'b':2,'c':3}
    bar(*args,**kwargs)
    #bar(*(1,2,3,4,5)),**{'a':1,'b':2,'c':3} #bar(1,2,3,4,5,a=1,b=2,c=3)
#虽然调用的是wrapper，但是要遵循的，确实bar的参数标准
wrapper(1,2,3,4,5,a=1,b=2,c=3)
```

5.命名关键字参数（了解）

只要放到`*` 与 `**` 之间的参数，称之为，命名关键字参数

注意：命名关键字参数，必须按照`key=value`的形式传值

```plain
def foo(x,y,*args,n,m,**kwargs):
    print(x,y)
    print(n,m)
    print(kwargs)
foo(1,2,3,4,5,m=10,n=11,a=1,b=2)
```

函数定义时，参数位置总结：

```plain
def foo(x,y=1,*args,m,**kwargs):
```

位置参数，默认参数，可变长参数`*`，命名关键字参数，可变长参数`**`

未经允许不得转载，欢迎技术交流，QQ：133411023：[DBA老司机带你删库到跑路.](https://www.driverzeng.com/) » [Python基础07-函数](https://www.driverzeng.com/zenglaoshi/1351.html)

> 更新: 2019-05-28 15:20:27  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/pq1zfh>