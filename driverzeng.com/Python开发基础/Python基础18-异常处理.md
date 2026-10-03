# Python基础18-异常处理

## Python基础18-异常处理
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(3) 评论(0)

+ [异常处理介绍](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_0)
+ [异常处理的单分支](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_1)
+ [异常处理的多分支](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_2)
+ [接收抛出异常的值](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_3)
+ [其他格式](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_4)
+ [万能异常类型Exception:可以匹配任意类型的异常](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_5)
+ [try... else...](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_6)
+ [主动触发异常](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_7)
+ [自定义异常](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_8)
+ [断言(了解)](https://blog.driverzeng.com/zenglaoshi/5367.html#toc_9)

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

## 异常处理介绍
---

| 什么是异常处理？ |
| :--- |

异常是错误发生的信号，一旦程序出错，就会产生一个异常，如果异常没有被应用程序处理，那么该异常就会抛出来，程序的执行也随之终止。

异常包含三个部分：

1.traceback异常信息追踪

2.异常类型

3.异常的信息

错误分为两大类：

1.语法上的错误

2.逻辑上的错误

---

| 为什么要异常处理？ |
| :--- |

避免程序因为异常而崩溃，所以在应用程序中应该对异常进行处理，从而增强程序的健壮性

**语法错误：**

语法错误（这种错误，根本过不了python解释器的语法检测，必须在程序执行前就改正）

```plain
#语法错误示范一
if
#语法错误示范二
def test:
    pass
#语法错误示范三
class Foo
    pass
#语法错误示范四
print(haha
```

**常见的逻辑错误导致的异常**

```plain
#TypeError:int类型不可迭代
for i in 3:
    pass
#ValueError
num=input(">>: ") #输入hello
int(num)
#NameError
aaa
#IndexError
l=['egon','aa']
l[3]
#KeyError
dic={'name':'egon'}
dic['age']
#AttributeError
class Foo:pass
Foo.x
#ZeroDivisionError:无法完成计算
res1=1/0
res2=1+'str'
```

在python中不同的异常可以用不同的类型（python中统一了类与类型，类型即类）去标识，一个异常标识一种错误

**常用异常**

```plain
AttributeError 试图访问一个对象没有的树形，比如foo.x，但是foo没有属性x
IOError 输入/输出异常；基本上是无法打开文件
ImportError 无法引入模块或包；基本上是路径问题或名称错误
IndentationError 语法错误（的子类） ；代码没有正确对齐
IndexError 下标索引超出序列边界，比如当x只有三个元素，却试图访问x[5]
KeyError 试图访问字典里不存在的键
KeyboardInterrupt Ctrl+C被按下
NameError 使用一个还未被赋予对象的变量
SyntaxError Python代码非法，代码不能编译(个人认为这是语法错误，写错了）
TypeError 传入对象类型与要求的不符合
UnboundLocalError 试图访问一个还未被设置的局部变量，基本上是由于另有一个同名的全局变量，
导致你以为正在访问它
ValueError 传入一个调用者不期望的值，即使值的类型是正确的
```

**更多异常**

```plain
ArithmeticError
AssertionError
AttributeError
BaseException
BufferError
BytesWarning
DeprecationWarning
EnvironmentError
EOFError
Exception
FloatingPointError
FutureWarning
GeneratorExit
ImportError
ImportWarning
IndentationError
IndexError
IOError
KeyboardInterrupt
KeyError
LookupError
MemoryError
NameError
NotImplementedError
OSError
OverflowError
PendingDeprecationWarning
ReferenceError
RuntimeError
RuntimeWarning
StandardError
StopIteration
SyntaxError
SyntaxWarning
SystemError
SystemExit
TabError
TypeError
UnboundLocalError
UnicodeDecodeError
UnicodeEncodeError
UnicodeError
UnicodeTranslateError
UnicodeWarning
UserWarning
ValueError
Warning
ZeroDivisionError
```

---

| 如何处理异常 |
| :--- |

```plain
# 语法：
try:
    代码1
    代码2
    代码3
    ......
except NameError:
    当抛出的异常是NameError时执行的子代码块
except ....:
    pass
except ...:
    pass
else:
    pass
finally:
    pass
```

## 异常处理的单分支
```plain
try:
    print('=====1')
    print('=====2')
    print('=====3')
    d = {'x': 1, 'y': 2}
    d['z']  # KeyError
    print('=====4')
    l = [1, 2, 3]
    l[1000]  # IndexError
    print('=====5')
except IndexError:
    print('IndexError')
print('other code')
```

## 异常处理的多分支
```plain
try:
    print('=====1')
    print('=====2')
    print('=====3')
    d = {'x': 1, 'y': 2}
    d['z']  # KeyError
    print('=====4')
    l = [1, 2, 3]
    l[1000]  # IndexError
    print('=====5')
except KeyError
    print('KeyError')
except IndexError
    print('IndexError')
print('other code')
```

## 接收抛出异常的值
```plain
try:
    print('=====1')
    print('=====2')
    print('=====3')
    d = {'x': 1, 'y': 2}
    d['z']  # KeyError
    print('=====4')
    l = [1, 2, 3]
    l[1000]  # IndexError
    print('=====5')
except KeyError as e:
    print('KeyError',e)
except IndexError as e:
    print('IndexError',e)
print('other code')
```

## 其他格式
```plain
try:
    print('=====1')
    print('=====2')
    print('=====3')
    d = {'x': 1, 'y': 2}
    # d['z']  # KeyError
    print('=====4')
    l = [1, 2, 3]
    l[1000]  # IndexError
    print('=====5')
except (KeyError,IndexError) as e:
    print(e)
print('other code')
```

## 万能异常类型Exception:可以匹配任意类型的异常
```plain
try:
    print('=====1')
    print('=====2')
    print('=====3')
    d = {'x': 1, 'y': 2}
    # d['z']  # KeyError
    # xxx
    print('=====4')
    l = [1, 2, 3]
    l[1000]  # IndexError
    print('=====5')
except IndexError as e:
    print('IndexError:', e)
except KeyError as e:
    print('KeyError:', e)
except Exception as e:
    print('Exception:',e)
print('other code')
```

## try... else...
```plain
try:
    print('=====1')
    print('=====2')
    print('=====3')
    d = {'x': 1, 'y': 2}
    # d['z']  # KeyError
    # xxx
    print('=====4')
    l = [1, 2, 3]
    # l[1000]  # IndexError
    print('=====5')
except IndexError as e:
    print('IndexError:', e)
except KeyError as e:
    print('KeyError:', e)
except Exception as e:
    print('Exception:',e)
else:
    print('else必须放到后面,else的子代码块会在被检测的代码没有异常的情况下执行')
print('other code')
```

**try... finally...**

```plain
try:
    f=open('a.txt','w')
    print('=====1')
    print('=====2')
    print('=====3')
    d = {'x': 1, 'y': 2}
    # d['z']  # KeyError
    # xxx
    'xx' > 10
    print('=====4')
    l = [1, 2, 3]
    # l[1000]  # IndexError
    print('=====5')
except IndexError as e:
    print('IndexError:', e)
except KeyError as e:
    print('KeyError:', e)
# except Exception as e:
#     print('Exception:',e)
else:
    print('else必须放到后面,else的子代码块会在被检测的代码没有异常的情况下执行')
finally:
    print('无论被检测的代码有没有异常都会执行')
    f.close()
```

## 主动触发异常
```plain
print('===>1')
print('===>2')
raise TypeError('类型错误')
print('===>3')
class People:
    def __init__(self,name,age):
        self.__name=name
        self.__age=age
    def tell_info(self):
        print(self.__name,self.__age)
    def set_info(self,name,age):
        if not isinstance(name,str):
            raise TypeError('名字必须是str类型')
        if not isinstance(age,int):
            raise TypeError('年龄必须是int类型')
        self.__name=name
        self.__age=age
obj=People('zls',18)
# print(obj.__dict__)
# obj.tell_info()
obj.set_info('zls',123)
obj.tell_info()
```

## 自定义异常
了解：

```plain
class MyException(BaseException):
    def __init__(self,msg):
        super().__init__()
        self.msg=msg
    def __str__(self):
        return '<%s>' %self.msg
raise MyException('我自定义的异常')
```

## 断言(了解)
```plain
print('上半部分,生产数据')
l=[1,2,3,4]
# if len(l) != 5:
#     raise TypeError('列表的长度必须为5')
assert len(l) == 5
print('下半部分,处理数据')
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

QQ：133411023

> 更新: 2020-06-25 11:20:05  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/xfbd7g>