# Python-基础01-变量

## Python-基础01-变量

2019-04-21 分类：[Linux](https://www.driverzeng.com/zenglaoshi/category/linux), [Python](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80/python), [脚本语言](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80) 阅读(127) 评论(0)

* [变量](https://www.driverzeng.com/zenglaoshi/1251.html#toc_0)
* [常量](https://www.driverzeng.com/zenglaoshi/1251.html#toc_1)

>  
>
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

## 变量

| 变量介绍 |
| :--- |

1.什么是变量？

变量即变化的量，核心是“变”与“量”二字，变即变化，量即衡量状态。

量:是记录现实世界当中的某种状态

变:指的是记录的状态是可以发生变化的

2.为什么要用变量？

程序执行的本质就是一系列状态的变化，变是程序执行的直接体现，所以我们需要有一种机制能够反映或者说是保存下来程序执行时状态以及状态的变化。

是为了让计算机能够像人一样去将一个事物的状态记忆下来（存到计算机内）

`存`，永远不是目的，目的是为了，`取`,计算机以后在使用的时候，可以取出来。

例如：

在游戏中，英雄的等级为1，打怪升级（变）10级

游戏中人物名字：Driver_Zeng，使用了改名卡，变为：曾老湿

植物大战僵尸：僵尸的存活状态为True，被植物打死了，变为False

3.如何使用变量？

```plain
name=zls
age=18
print(age)
```

<!-- OCR_START -->
- untitled1
- venv
- lib
- python3.6
- Project
- 变量.pyX
- HIIHLCUI
- age=18
- print(age)
- bin
- include
- 三pyvenv.cfg
- 变量.py
- Run:
- 变量×
- /Users/driverzeng/PycharmProjects/untitled1/
- 18
- Process finished with exit code 0
<!-- OCR_END -->

￼

<!-- OCR_START -->
- #!/usr/bin/python
- TheNiceBoyLikeMe
- age=18
- Driver_Zeng
- print(age)
- 内存空间
- 18
<!-- OCR_END -->

￼

定义变量的语法（分三部分）：

1）变量名

相当于一个门牌号，便于取出变量值，是访问到值的唯一方式

2）赋值符号

将值的内存地址，绑定给变量名

3）变量值

用来表示状态

变量的使用规则：先定义，在通过变量名去引用。

***

| 变量名定义规范 |
| :--- |

变量名的命名规则：

1.大前提：变量名的命名应该能够反映出值记录的状态。

2.变量是用来访问变量值的，所以变量名应该遵循一定规范，来方便我们标识存到内存中值的功能。

```plain
1.变量名只能是 字母、数字或下划线的任意组合(区分大小写)
例如：
x=1
X=2
是两个变量
2.变量名的第一个字符不能是数字
例如：
1x=1
123_x=1
3.关键字不能声明为变量名
['and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'exec', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'not', 'or', 'pass', 'print', 'raise', 'return', 'try', 'while', 'with', 'yield']
例如：
print=123
这样python内置功能print就无法使用了
```

***

| 变量名定义方式 |
| :--- |

1.下划线（纯小写）

```plain
age_of_oldboy=73 #python推荐使用
```

2.驼峰体

```plain
AgeOfOldboy=73
```

3.不好的方式

1）变量名为中文、拼音

2）变量名过长

3）变量名词不达意

***

| 变量值特征 |
| :--- |

每定义一个变量，对于变量值，都具备3个特征。

1.id

反映在内存中的位置。

如果id相同，name这两个变量我们认为，是同一个变量。

类似于身份证号。

```plain
age=18
nam='zls'
print(id(name))
print(id(age))
```

<!-- OCR_START -->
- untitled1
- venv
- 变量.py
- Project
- 变量pyx
- untitled1~/PycharmProjects/untitled1
- name='zls
- 2
- age=18
- bin
- pnt(id(name))
- include
- 5
- print(id(age))
- lib
- python3.6
- 三pyvenv.cfg
- 变量nV
- Run:
- 变量
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/venv/变量.py
- 4327843072
- 4304952224
- Process finishedwith exitcodeO
<!-- OCR_END -->

￼

<!-- OCR_START -->
- #!/usr/bin/python
- TheNiceBoyLikeMe
- age=18
- Driver_Zeng
- name='zls'
- print(id(name))
- print(id(age)
- 内存空间id：
- 4304952224
- 4347766016
- 18
- zls
<!-- OCR_END -->

￼

2.type（类型）

不同类型的值，是用来表示、记录不同的状态

```plain
#整型
age=18
#字符串
nam='zls'
print(type(name))
print(type(age))
```

<!-- OCR_START -->
- untitled1
- venv
- 变量.py
- Project
- untitled1 ~/PycharmProjects/untitled1
- name=
- 'zls
- age=18
- bin
- print（type（name))
- include
- print(type(age))
- lib
- python3.6
- #print（id（name))
- 三pyvenv.cfg
- #print（id（age))
- 查量nv
- Run:
- 变量×
- /Users/driverzeng/P
- charmProiects/untitledl/venv/bin/python
- ycharmProjects/untitled1/venv/变量.py
- <class 'str'>
- 学符串
- <class 'int'>
- 整型
- Process finished with exit code 0
<!-- OCR_END -->

￼

<!-- OCR_START -->
- #1/usr/bin/python
- TheNiceBoyLike Me
- age=18
- Driver_Zeng
- name='zls'
- print(type(name))
- print(type(age))
- 内存空间
- <class'int'>
- <class'str'>
- 18
- zls
<!-- OCR_END -->

￼

3.value（值）

我们存放在内存中的数据，用来表示某种状态

```plain
name='zls'
age=18
print(name)
print(age)
```

<!-- OCR_START -->
| untitled1 | untitled1 | untitled1 | untitled1 | 排名 |
| --- | --- | --- | --- | --- |
| Project | 8 | 变量.pyx | untitled1~/PycharmProjects/untitled1 | 1 |
| name='zls | venv | 2 | age=18 | 3 |
| print(name) | include | 5 | print(age) | lib |
| python3.6 | #print（type（name)) | 三pyvenv.cfg | #print（type（age)) | 温查量nv |
| Run: | 变量× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/venv/变量.py | zls | 18 |
<!-- OCR_END -->

￼

<!-- OCR_START -->
- #!/usr/bin/python
- The Nice Boy Like Me
- age=18
- Driver_Zeng
- name='zls'
- print(name)
- print(age)
- 内存空间
- 18
- zls
<!-- OCR_END -->

￼

***

| 小整数池 |
| :--- |

```plain
#设置变量
x=100
y=20
#查看id
print(id(x))
print(id(y))
#当我们设置两个变量时，他们的内存地址是不一样的
4304954848
4304952288
```

<!-- OCR_START -->
- #!/usr/bin/python
- The NiceBoyLikeMe
- x=100
- Driver_Zeng
- y=20
- print(x)
- print(y)
- 内存空间id：
- 内存空间
- 4304952288
- 4304954848
- 20
- 100
<!-- OCR_END -->

￼

```plain
#设置变量
x=100
y=100
```

按照我们的理解，当设置这两个变量时，内存中发生了以下变化。

首先，开辟一块`x`的内存空间，`value`为100

其次，开辟一块`y`的内存空间，`value`为100

<!-- OCR_START -->
- 内存空间

```text
#!/usr/bin/python
TheNiceBoyLikeMe.
X=100
Driver_Zeng
y=100
print(x)
print(y)
100
```
<!-- OCR_END -->

￼

但是实际上:

```plain
#设置变量
x=100
y=100
#查看id
print(id(x))
print(id(y))
#他们的id是相同的
4304954848
4304954848
```

<!-- OCR_START -->
- #1/usr/bin/python
- The NiceBoy LikeMe.
- X=100
- -Driver_Zeng
- y=100
- print(x)
- print(y)
- 内存空间id：
- 4304954848
- 100
<!-- OCR_END -->

￼

Python实现int的时候有个小整数池。为了避免因创建相同的值而重复申请内存空间所带来的效率问题， Python解释器会在启动时创建出小整数池，范围是`[-5,256]`，该范围内的小整数对象是全局解释器范围内被重复使用，永远不会被GC回收。

每创建一个-5到256之间的整数，都是直接从这个池里直接拿走一个值，例如:

```plain
[root@elkstack01 ~]# python3
Python 3.6.4 (default, Apr  8 2019, 17:12:35)
[GCC 4.4.7 20120313 (Red Hat 4.4.7-4)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> a=257
>>> b=257
>>>
>>> print(id(a))
140410179172240
>>> print(id(b))
140410179172880
>>> m=256
>>> n=256
>>>
>>> id(m)
9096160
>>> id(n)
9096160
```

<!-- OCR_START -->
X..ython-3.6.4（ssh)O81X..kstack02:~（ssh)
。82
X.lkstack03:~（ssh)83
X..lkstack
[root@elkstack01~]#python3
Python 3.6.4(default，Apr8 2019，17:12:35)
[GCC4.4.720120313(RedHat4.4.7-4)]onlinux
Type "help"，"copyright"，"credits" or "license" for more information.
a=257
b=257
print(id(a))
140410179172240
print(id(b))
140410179172880
m=256
n=256
id(m)
9096160
id(n)
<!-- OCR_END -->

￼

因为超过了`[-5,256]`范围，所以需要重新开辟新的内存空间，因此，他们的id是不一样的。

<!-- OCR_START -->
- #1/usr/bin/python
- The NiceBoyLikeMe
- X=257
- Driver_Zeng
- y=257
- print（x)
- print(y)
- 内存空间id：
- 140410179172240
- 140410179172880
- 100
<!-- OCR_END -->

￼

但在pycharm中运行python程序，pycharm出于对性能的考虑，会扩大小整数池的范围，其他的字符串等不可变类型也都包含在内一便采用相同的方式处理了，我们只需要记住这是一种优化机制，至于范围到底多大，无需细究。

```plain
x=122222222222222111
y=122222222222222111
print(id(x))
print(id(y))
```

<!-- OCR_START -->
| untitled1 | untitled1 | untitled1 | untitled1 | 排名 |
| --- | --- | --- | --- | --- |
| 变量.py | Project | 变量py | untitled1~/PycharmProjects/untitled1 | 14 |
| 15 | X=122222222222222111 | 16 | bin | 17 |
| include | 18 | print(id（x)) | lib | 19 |
| print(id(y)) | python3.6 | 20 | 三pyvenv.cfg | 21 |
| 变量nv | Run: | 变量× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/venv/变量.py | 4341620432 |
<!-- OCR_END -->

￼

***

| Python的垃圾回收机制 |
| :--- |

Python解释器会定期回收，那些没有绑定变量名的值。

```plain
age=18
x=age
```

<!-- OCR_START -->
- #1/usr/bin/python
- TheNiceBoy LikeMe
- age=18
- Driver_Zeng
- x=age
- print(age)
- print（x)
- 内存空间
- 18
<!-- OCR_END -->

￼

此时不应被回收。

```plain
age=18
x=age
age=19
del x
```

<!-- OCR_START -->
- #!/usr/bin/python
- The NiceBoyLike Me.
- age=18
- Driver_Zeng
- x=age
- age=19
- delx
- print(age)
- print(x)
- 内存空间
- 18
- 19
<!-- OCR_END -->

￼

此时，18已经没有所谓的`门牌号`，那么Python解释器会自动将垃圾回收。

## 常量

`常量`就是不变的量.

***

| Python中的chang'l |
| :--- |

```plain
age_of_oldboy = 73
```

常量即指不变的量，如pai 3.141592653..., 或在程序运行过程中不会改变的量

举例，假如老男孩老师的年龄会变，那这就是个变量，但在一些情况下，他的年龄不会变了，那就是常量。在Python中没有一个专门的语法代表常量，程序员约定俗成用变量名全部大写代表常量

```plain
AGE_OF_OLDBOY = 73
```

ps:在c语言中有专门的常量定义语法，const int count = 60;一旦定义为常量，更改即会报错

> 更新: 2019-05-27 15:21:48  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/fiuigg>