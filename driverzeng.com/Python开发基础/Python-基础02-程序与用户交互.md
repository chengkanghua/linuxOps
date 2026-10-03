# Python-基础02-程序与用户交互

## Python-基础02-程序与用户交互

2019-04-22 分类：[Linux](https://www.driverzeng.com/zenglaoshi/category/linux), [Python](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80/python), [脚本语言](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80) 阅读(79) 评论(0)

* [用户与程序交互](https://www.driverzeng.com/zenglaoshi/1271.html#toc_0)
* [数据类型(简单介绍)](https://www.driverzeng.com/zenglaoshi/1271.html#toc_1)
* [基本运算符](https://www.driverzeng.com/zenglaoshi/1271.html#toc_2)

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

## 用户与程序交互

古时候，我们去银行取钱，需要有一个银行业务员等着我们把自己的账号密码输入给他，然后他去进行验证，成功后，我们再将取款金额输入/告诉他

骄傲的现代人，会为客户提供一台ATM机（就是一台计算机），让ATM机跟用户交互，从而取代人力。然而机器是死的，我们必须为其编写程序来运行，这就要求我们的编程语言中能够有一种能与用户交互，接收用户输入数据的机制

***

| 什么是与用户交互 |
| :--- |

程序等待用户输入一些数据，然后程序执行完毕后为用户反馈信息。

***

| 为什么要与用户交互 |
| :--- |

为了让计算机能够像人一样，可以和用户交流，识别用户提供的信息。

***

| input的区别 |
| :--- |

```plain
#在python3中
input：用户输入任何值，都存成字符串类型
#在python2中
input：用户输入什么类型，就存成什么类型
raw_input：等于python3的input
```

***

| 如何使用与用户交互 |
| :--- |

在`Python`中input和`SHELL`中的 read用法相同，只不过不需要写上很多选项。

```plain
#接收用户输入的用户名
username=input('please input your username:')
#接收用户输入的密码
pwd=input('please input your password:')
#打印出 用户名和密码
print(username,pwd)
```

<!-- OCR_START -->
- 基础.py
- Project
- 01与用户交互.py
- untitled1 ~/PycharmProjects/untitled1
- 73
- venv
- 74
- username=input(pleaseinputyourusername:
- bin
- 75
- pwd=input('pleaseinputyour password:')
- include
- lib
- 76
- 三pyvenv.cfg
- 77
- 78
- print(username,pwd)
- 79
- Ill External Libraries
- 80
- Scratches and Consoles
- 81
- 82
- 83
- 84
- 85
- 86
- 87
- 88
- 89
- Run:
- 变量X
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/venv/变量.py
- please input your username:zls
- please input your password:123
- zls 123
- Process finished with exit code0
<!-- OCR_END -->

￼

| 注释 |
| :--- |

随着学习的深入，用不了多久，你就可以写复杂的上千甚至上万行的代码啦，有些代码你花了很久写出来，过了些天再回去看，发现竟然看不懂了，这太正常了。 另外，你以后在工作中会发现，一个项目多是由几个甚至几十个开发人员一起做，你要调用别人写的代码，别人也要用你的，如果代码不加注释，你自己都看不懂，更别说别人了，这产会挨打的。所以为了避免这种尴尬的事情发生，一定要增加你代码的可读性。

代码注释分单行和多行注释， 单行注释用#，多行注释可以用三对双引号""" """

代码注释的原则：

```plain
#1. 不用全部加注释，只需要在自己觉得重要或不好理解的部分加注释即可
#2. 注释可以用中文或英文，但不要用拼音
```

文件头

```plain
#!/usr/bin/env python
# -*- coding: utf-8 -*-
```

***

| 格式化输出 |
| :--- |

程序中经常会有这样场景：要求用户输入信息，然后打印成固定的格式

比如要求用户输入用户名和年龄，然后打印如下格式：

My name is zls，I'm 18 years old.

很明显，用逗号进行字符串拼接，只能把用户输入的名字和年龄放到末尾，无法放到指定的xxx位置，而且数字也必须经过str(数字)的转换才能与字符串进行拼接。

这就用到了占位符，如：%s、%d

```plain
#%s字符串占位符：可以接收字符串，也可接收数字
print('My name is %s,my age is %s' %('zls',18))
#%d数字占位符：只能接收数字
print('My name is %s,my age is %d' %('zls',18))
print('My name is %s,my age is %d' %('zls','18')) #报错
#接收用户输入，打印成指定格式
name=input('your name: ')
age=input('your age: ') #用户输入18,会存成字符串18,无法传给%d
print('My name is %s,my age is %s' %(name,age))
#注意：
#print('My name is %s,my age is %d' %(name,age)) #age为字符串类型,无法传给%d,所以会报错
```

**练习：用户输入姓名、年龄、工作、爱好 ，然后打印成以下格式**

```plain
------------ info of zls -----------
Name  : zls
Age   : 18
Sex   : male
Job   : Teacher 
------------- end -----------------
```

## 数据类型(简单介绍)

什么是数据？为何要有多种类型的数据？

1.数据即变量的值，如age=18，18则是我们保存的数据。

2.变量的是用来反映/保持状态以及状态变化的，毫无疑问针对不同的状态就应该用不同类型的数据去标识

***

| 数字 |
| :--- |

1.int整型

作用：记录年龄，等级，QQ号，各种号码

定义：age=10 #age=int(10)

```plain
age=18
print(age,type(age))
#结果
18 <class 'int'>
```

<!-- OCR_START -->
| untitled1 | untitled1 | 排名 | untitled1 | untitled1 | 排名(上年) |
| --- | --- | --- | --- | --- | --- |
| Project | a | 基础.py | 01与用户交互.py | untitled1~/PycharmProjects/untitled1 | 80 |
| age=18 | venv | bin | 81 | print(age,type(age)) | 82 |
| include | Mlib | 83 | 三pyvenv.cfg | 84 | 01与用户交互.py |
| 85 | 基础.py | 86 | li External Libraries | Scratches and Consoles | 87 |
| 88 | 89 | 90 | Run: | 变量x | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/基础-py |
<!-- OCR_END -->

￼

2.float浮点型

作用：记录工资，身高，体重

定义：salary=3.1 #salary=float(3.1)

```plain
salary=3.1 #salary=float(3.1)
print(salary,type(salary))
#结果
3.1 <class 'float'>
```

<!-- OCR_START -->
| 名称 | 名称 | 排名 | 名称 | 名称 |
| --- | --- | --- | --- | --- |
| untitled1 | 基础.py | Project | 文 | 基础.pyx |
| 01与用户交互.pyX | untitled1~/PycharmProjects/untitled1 | 84 | salary=3.1w#salary=float(3.1) | venv |
| 85 | print(salary,type(salary)) | bin | 86 | include |
| 87 | lib | 88 | 三pyvenv.cfg | 01与用户交互.py |
| 89 | 基础.py | 90 | Illi External Libraries | 91 |
| Scratches and Consoles | 92 | 93 | 94 | 95 |
| 96 | 97 | 98 | Run: | 变量X |
<!-- OCR_END -->

￼

**其他数据类型了解**

```plain
#int（整型）
在32位机器上，整数的位数为32位，取值范围为-2**31～2**31-1，即-2147483648～2147483647
在64位系统上，整数的位数为64位，取值范围为-2**63～2**63-1，即-9223372036854775808～9223372036854775807
#long（长整型）
跟C语言不同，Python的长整数没有指定位宽，即：Python没有限制长整数数值的大小，但实际上由于机器内存有限，我们使用的长整数数值不可能无限大。
注意，自从Python2.2起，如果整数发生溢出，Python会自动将整数数据转换为长整数，所以如今在长整数数据后面不加字母L也不会导致严重后果了。
注意：在Python3里不再有long类型了，全都是int
>>> a= 2**64
>>> type(a)  #type()是查看数据类型的方法
<type 'long'>
>>> b = 2**60
>>> type(b)
<type 'int'>
#complex复数型
>>> x=1-2j
>>> x.imag
-2.0
>>> x.real
1.0
其他数据类型（了解部分）
```

***

| 字符串类型 |
| :--- |

字符类型：str

作用：描述性的内容，如姓名，性别，国籍，种族

定义：在引号内，包含一系列字符，`引号`可以是：单引号，双引号，三引号

在python中，加了引号的字符就是字符串类型，python并没有字符类型。

```plain
name='zls'
print(name,type(name))
name1="zls"
print(name1,type(name1))
name2='''zls'''
print(name2,type(name2))
name3="""zls"""
print(name3,type(name3))
#结果
zls <class 'str'>
zls <class 'str'>
zls <class 'str'>
zls <class 'str'>
```

<!-- OCR_START -->
- 基础.py
- untitled1
- Project
- 基础.pyX
- 01与用户交互.py
- untitled1 ~/PycharmProjects/untitled1
- 87
- name='zls'
- venv
- 88
- print(name,type(name))
- bin
- 89
- include
- lib
- 90
- 三pyvenv.cfg
- 91
- name1="zls"
- 92
- print(name1,type(name1))
- 93
- lli External Libraries
- 94
- Scratches and Consoles
- 95
- 96
- print(name2,type(name2))
- 97
- 98
- 99
- name3...z....
- 100
- print(name3,type(name3))
- 101
- Run:
- 变量
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/基础·py
- zls <class 'str'>
- Process finished with exit code 0
<!-- OCR_END -->

￼

三引号，一般在多行数据使用，例如：

```plain
info='''
name:zls
age:18
job:teacher
'''
print(info)
#结果
name:zls
age:18
job:teacher
```

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 名称 | 名称 | 排名 |
| --- | --- | --- | --- | --- | --- |
| untitled1 | 基础.py | Project | 基础.py | 01与用户交互.py | untitled1 ~/PycharmProjects/untitled1 |
| 104 | venv | 105 | info=!.! | bin | 106 |
| include | lib | 107 | name:zls | 三pyvenv.cfg | 108 |
| age:18 | 01与用户交互.py | 109 | ob:teacher | 基础.py | 110 |
| Illi External Libraries | 111 | Scratches and Consoles | 112 | 113 | 114 |
| print(info) | 115 | 116 | 117 | 118 | 110 |
| Run: | 变量× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/基础·py | 小 | name:zls | age:18 |
<!-- OCR_END -->

￼

引号的嵌套：

如果说，我有一个需求，我想要给人名加上引号打印出来

`My Name Is 'zls'.`

错误写法：

```plain
name='My Name Is 'zls'.'
print(name)
```

<!-- OCR_START -->
| 名称 | 名称 | 排名 | 名称 | 名称 |
| --- | --- | --- | --- | --- |
| untitled1 | 基础.py | 基础.py | 01与用户交互.py | Project |
| untitled1 ~/PycharmProjects/untitled1 | 104 | 1 | venv | 105 |
| name='My Name Is 'zls | bin | 106 | include | 107 |
| lib | 三pyvenv.cfg | 108 | print(name) | 01与用户交互.py |
| 109 | 基础·py | 110 | IlliExternal Libraries | 111 |
| Scratches and Consoles | 112 | 113 | 114 | 115 |
| 116 | 117 | 118 | Run: | 变量 |
| /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/基础·py | File"/Users/driverzeng/PycharmProjects/untitled1/基础.py",line 105 | name='My Name Is'zls'. | L | SyntaxError:invalidsyntax |
<!-- OCR_END -->

￼

正确写法：

```plain
name="My Name Is 'zls'."
print(name)
#结果
My Name Is 'zls'.
```

<!-- OCR_START -->
| untitled1 | 排名 | untitled1 | untitled1 | untitled1 |
| --- | --- | --- | --- | --- |
| 基础.py | Project | 女 | 基础.pyX | 01与用户交互.pyX |
| untitled1 ~/PycharmProjects/untitled1 | 105 | venv | 106 | print(name) |
| bin | 107 | include | 108 | lib |
| 三pyvenv.cfg | 109 | 01与用户交互.py | 110 | 基础.py |
| 111 | lliExternal Libraries | 112 | Scratches and Consoles | 113 |
| 114 | 115 | 116 | Run: | 变量X |
<!-- OCR_END -->

￼

一定要搞清楚，引号的配对。

Python中独特用法：字符串运算

1.字符串相加（字符串拼接）

字符串只能与字符串相加，但是效率不高

```plain
message1='hello'
message2='world'
print(message1+message2)
#结果
helloworld
```

<!-- OCR_START -->
| 名称 | 名称 | 排名 | 名称 | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| untitled1 | 基础.py | 基础.py | 01与用户交互.py | Project | untitled1 ~/PycharmProjects/untitled1 |
| 108 | venv | 109 | messagel='hello' | bin | 110 |
| message2='world' | include | lib | 111 | 三pyvenv.cfg | 112 |
| print(message1+message2） | 01与用户交互.py | 113 | 基础.py | 114 | IlliExternal Libraries |
| Scratches and Consoles | 115 | 116 | 117 | 118 | 119 |
| 120 | 121 | 122 | Run: | 变量× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/基础·py |
<!-- OCR_END -->

￼

**内存变化**

<!-- OCR_START -->
- #!/usr/bin/python
- The Nice Boy Like Me
- Driver_Zeng
- message1='hello'
- message2=world
- print(message1+message2)
- message1
- message2
- 新内存空间
- hello
- world
- helloworld
<!-- OCR_END -->

￼

2.字符串相乘

字符串之间可以相乘，做乘法运算，但是不是字符串与字符串相乘，是字符串与数字相乘。

```plain
print('hello'*10)
print('华丽的分割线'+'-'*100)
#结果
hellohellohellohellohellohellohellohellohellohello
华丽的分割线----------------------------------------------------------------------------------------------------
```

<!-- OCR_START -->
| untitled1 | 排名 | untitled1 | 排名(上年) | untitled1 | untitled1 |
| --- | --- | --- | --- | --- | --- |
| Project | 基础.pyX | 01与用户交互.pyX | untitled1 ~/PycharmProjects/untitled1 | 108 | venv |
| 109 | # messagel='hello' | bin | 110 | # message2='world' | Iinclude |
| lib | 111 | # | 三pyvenv.cfg | 112 | # print(message1+message2) |
| 01与用户交互.py | 113 | 基础.py | 114 | lli External Libraries | 115 |
| Scratches and Consoles | 116 | print('hella'*10) | 117 | 118 | print（华丽的分割线'+'-'*100） |
| 119 | 120 | 121 | 122 | Run: | 变量X |
<!-- OCR_END -->

￼

***

| 列表类型 |
| :--- |

如果定义一个人的爱好，使用字符串类型，爱好是多种多样的，例如：

```plain
hobbies='eat music sleep play'
```

如何取出第三个爱好？

列表类型：list

作用：记录/存放多个值，可以方便的出去来指定位置的值，比如，人的多个爱好，一堆学生的姓名。

定义：在`[]`内用逗号分隔开，多个任意类型的值。

例如：

list=\[1,3.1,'zls',\['a','b']]

列表类型如何取值？

```plain
list=[1,3.1,'zls',['a','b']]
print(list)
#结果
[1, 3.1, 'zls', ['a', 'b']]
```

<!-- OCR_START -->
| 排名 | 名称 | 名称 | 名称 | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| untitled1 | 基础.py | Project | 基础.pyx | 01与用户交互.py | untitled1 ~/PycharmProjects/untitled1 |
| 122 | venv | 123 | bin | include | 124 |
| print(list) | lib | 125 | 三pyvenv.cfg | 126 | 01与用户交互.py |
| 127 | 基础.py | li External Libraries | 128 | Scratchesand Consoles | 129 |
| 130 | 131 | 132 | 133 | 134 | 135 |
| 136 | Run: | 变量X | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/基础.py | [1,3.1,'zls',['a','b']] | Process finished with exit code 0 |
<!-- OCR_END -->

￼

```plain
list=[1,3.1,'zls',['a','b']]
print(list[0])
print(list[1])
print(list[2])
print(list[3])
print(list[3][0])
print(list[3][1])
#结果
1
3.1
zls
['a', 'b']
a
b
```

<!-- OCR_START -->
| 名称 | 排名 | 名称 | 名称 | 排名(上年) | 名称 |
| --- | --- | --- | --- | --- | --- |
| untitled1 | 基础.py | 1Project | 基础·py | 女 | 01与用户交互.py |
| untitled1 ~/PycharmProjects/untitled1 | 122 | list=[13.1zls',['a','b']] | venv | 123 | bin |
| 124 | include | print(list[o]) | lib | 125 | print(list[1]) |
| 三pyvenv.cfg | 126 | print(list[2]) | 01与用户交互.py | 127 | print(list[3]) |
| 基础·py | 128 | print(list[3][o]) | lli External Libraries | 129 | print(list[3][1]) |
| Scratches and Consoles | 130 | 131 | 132 | 133 | 134 |
| 135 | 136 | Run: | 变量 | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/基础·py | 1 |
| 3.1 | zls | ['a', | 'b'] | a | 工 |
<!-- OCR_END -->

￼

**小练习**

```plain
#请取在下面列表中，取出bgx的爱好？
student_info=[['zls',18,'play'],['egon',19,'beautiful girl'],['bgx',20,'play beautiful girl']]
#取出下面列表中的j
list=['a','b',['c','d',['e',['f',['g',['h','i','j']]]]]]
```

***

| 字典类型 |
| :--- |

为何还要用字典？

```plain
info=['zls',18,'male',['oldboy',200,'SH']]
如何取出，性别和所在公司名称？
info=['zls',18,'male',['oldboy',200,'SH']]
print(info[2])
print(info[3][0])
#存放一个人的信息：姓名，性别，年龄，很明显是多个值，既然是存多个值，我们完全可以基于刚刚学习的列表去存放，如下:
>>> info=['zls','male',18]
#定义列表的目的不单单是为了存，还要考虑取值，如果我想取出这个人的年龄，可以用
>>> info[2]
#但这是基于我们已经知道在第3个位置存放的是年龄的前提下，我们才知道索引2对应的是年龄
#即： name, sex, age
info=['zls','male',18]
#而这完全只是一种假设，并没有真正意义上规定第三个位置存放的是年龄，于是我们需要寻求一种，即可以存放多个任意类型的值，又可以硬性规定值的映射关系的类型，比如key=value，这就用到了字典
```

字典类型作用：

记录多个`key:value`值，优势是每一个值value都有其对应关系/映射关系key，而key对value有**描述性**的功能。可以更为方便高效地取值。

字典类型定义：

在{}内用逗号分隔开多个`key:value`元素，其中value可以死任意的数据类型，而key**通常**应该是字符串类型。

```plain
info={'name':'zls','sex':'male','age':18} #info=dict({'name':'zls','age':18,'sex':'male'})
print(type(info))
```

如何取值？

```plain
info={'name':'zls','sex':'male','age':18}
print(info['name'])
print(info['sex'])
print(info['age'])
#结果
zls
male
18
```

<!-- OCR_START -->
| untitled1 | untitled1 | untitled1 | untitled1 | 排名 |
| --- | --- | --- | --- | --- |
| 01与用户交互.py | untitled1 ~/PycharmProjects/untitled1 | 142 | venv | 143 |
| info={'name':'zls''sex':'male','age':18} | bin | 144 | include | 145 |
| print(info['name']) | lib | 146 | 三pyvenv.cfg | print(info['sex']) |
| 01与用户交互.py | 147 | print(info['age']) | 基础.py | 148 |
| Illi External Libraries | 149 | Scratches and Consoles | 150 | 151 |
| 152 | 153 | 154 | 155 | 156 |
| 157 | Run: | 变量 | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/基础·py | zls |
<!-- OCR_END -->

￼

字典嵌套取值：

```plain
#取出下列字典的公司名
info={
    'name':'zls',
    'hobbies':['play','eat'],
    'company_info':{
        'name':'Oldboy',
        'type':'education',
        'emp_num':40,
    }
}
print(info['company_info']['name'])
```

\*\*注意：\*\*在python中，字典是无序的，python2中可以明显看出，但是python3中有算法的优化，所以看起来像是有序的。

**小练习**

```plain
#取出oldboy的第二个爱好
students=[
    {'name':'zls','age':18,'hobbies':['play','sleep']},
    {'name':'oldboy','age':40,'hobbies':['read','sleep']},
    {'name':'bgx','age':58,'hobbies':['music','read','sleep']},
]
```

什么时候选择列表，什么时候选择字典？

列表：当你存的多个数据，是同一种类，或者同一种性质的，例如：所有人的名字。

字典：当你存的多个数据，非同一种类，或者非同种性质的，例如：多个人的信息，名字、年龄，身高。

***

| 布尔类型 |
| :--- |

布尔类型：bool

作用：用来作为判断条件去用

1.布尔值，一个True一个False

2.计算机俗称电脑，即我们编写程序让计算机运行时，应该是让计算机无限接近人脑，或者说人脑能干什么，计算机就应该能干什么，人脑的主要作用是数据运行与逻辑运算，此处的布尔类型就模拟人的逻辑运行，即判断一个条件成立时，用True标识，不成立则用False标识

定义：

```plain
tag=True # tag=bool(True)
tag1=False
print(type(tag))
print(type(tag1))
#结果
<class 'bool'>
<class 'bool'>
```

```plain
age=18
print(age>20)
print(age>=20)
print(age>=20)
print(age==20)
#结果
False
False
False
True
```

**is 和 == 的区别**

```plain
x=100
y=100
print(x==y)
print(x is y)
#结果
True
True
```

<!-- OCR_START -->
| 排名 | 名称 | 名称 | 名称 | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| untitled1 | 基础.py | Project | 基础.py | 01与用户交互.py | untitled1 ~/PycharmProjects/untitled1 |
| 167 | 1 | venv | 168 | X=100 | bin |
| 169 | y=100 | include | 170 | lib | 三pyvenv.cfg |
| 171 | print(x==y) | 01与用户交互.py | 172 | print(x is y) | 基础.py |
| 173 | lli External Libraries | 174 | Scratchesand Consoles | 175 | 176 |
| 177 | 178 | 179 | 180 | 181 | 102 |
| Run: | 变量 | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/基础.py | True | True | Process finished with exit code |
<!-- OCR_END -->

￼

但是，如果是在python解释器当中，那么结果如下

```plain
MacBook-Pro:~ driverzeng$ python3
Python 3.6.4 (v3.6.4:d48ecebad5, Dec 18 2017, 21:07:28)
[GCC 4.2.1 (Apple Inc. build 5666) (dot 3)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> x=257
>>> y=257
>>> x == y
True
>>> x is y
False
>>> n=256
>>> m=256
>>>
>>> x == y
True
>>> x is y
False
```

<!-- OCR_START -->
X..:~/Python-3.6.4（ssh)81
X..t@elkstack02:~（ssh)82
X.t@elkstack03:~（ssh)83
MacBook-Pro:~driverzeng$python3
Python 3.6.4 (v3.6.4:d48ecebad5，Dec 18 2017，21:07:28)
[GCC4.2.1（AppleInc.build5666)（dot3)]ondarwin
Type "help"，"copyright"，"credits" or "license" for more information.
x=257
y=257
x ==y
True
x is y
False
n=256
m=256
×==
<!-- OCR_END -->

￼

**结论:**

* 1.== 比较的是值是否相等
* 2.is 比较的是内存中的id是否相等
* 3.重点：只要id相等，那么值一定相等。id不相等，值仍然可以相等。

```plain
tag=True
print(id(tag))
res=3>1
print(id(res))
res1=1<10
print(id(res1))
#结果
4304560512
4304560512
4304560512
```

<!-- OCR_START -->
| untitled1 | untitled1 | 排名 | untitled1 | untitled1 | untitled1 |
| --- | --- | --- | --- | --- | --- |
| 基础.pyx | 01与用户交互.pyX | 女 | untitled1 ~/PycharmProjects/untitled1 | 175 | tag=True |
| 1 | venv | 176 | print(id(tag)) | bin | 177 |
| include | lib | 178 | res=3≥1 | 三pyvenv.cfg | 179 |
| print(id(res)) | 01与用户交互.py | 180 | 基础.py | 181 | res1=1<10 |
| lli External Libraries | 182 | print(id(res1)) | Scratchesand Consoles | 183 | 184 |
| 185 | 186 | 187 | 188 | Run: | 变量X |
<!-- OCR_END -->

￼

布尔值可以用来做判断。

## 基本运算符

| 算数运算符 |
| :--- |

计算机可以进行的运算有很多种，可不只加减乘除这么简单，运算按种类可分为算数运算、比较运算、逻辑运算、赋值运算、成员运算、身份运算、位运算，今天我们暂只学习算数运算、比较运算、逻辑运算、赋值运算。

以下假设变量：a=10，b=20

| 运算符 | 描述 | 实例 |
| :--- | :--- | :--- |
| + | 加 - 两个对象相加 | a + b 输出结果 30 |
| - | 减 - 得到负数或是一个数减去另一个数 | a - b 输出结果 -10 |
| \* | 乘 - 两个数相乘或是返回一个被重复若干次的字符串 | a \* b 输出结果 200 |
| / | 除 - 我还能说啥，就是一个数除以另外一个数 | b / a 输出结果 2 |
| % | 取模 - 返回除法的余数 | b % a 输出结果 0 |
| \*\* | 幂 - 这里指的不是杨幂，是几次方 | a \*\* b 输出结果 10000000000000000000000000000 |
| // | 取整除 - 返回商数的整数部分 | 9//2 输出结果 4 |

```plain
print(1+3)
4
print(3-2)
1
print(10 / 3)
3.3333333333333335
print(10 // 3)
3
print(10 % 3)
1
print(2 ** 3)
8
```

***

| 比较运算符 |
| :--- |

以下假设变量：a=10，b=20

| 运算符 | 描述 | 实例 |
| :--- | :--- | :--- |
| == | 等于 - 比较两个对象是否相等 | (a == b) 返回 False |
| != | 不等于 - 比较两个对象是否不相等 | (a != b) 返回 True |
| > | 大于 - 比较一个对象是否比另一个对象大 | (a > b) 返回 False |
| < | 小于 - 比较一个对象是否比另一个对象小 | (a < b) 返回 True |
| >= | 大于等于 - 比较一个对象是否比另一个对象大或者相等 | (a >= b) 返回 False |
| <= | 小于等于 - 比较一个对象是否比另一个对象小或者相等 | (a <= b) 返回 True |

```plain
a=10
b=20
print(a == b)
False
print(a != b)
True
print(a > b)
False
print(a < b)
True
print(a >= b)
False
print(a <= b)
True
```

**了解知识点**

```plain
#众所周知，整型之间是可以比大小的，整型和浮点型之间也是可以比大小的
print(10 > 3)
print(10 > 3.1)
#那么字符串之间可以比大小么？
msg1='hello'
msg2='z'
print(msg1 > msg2)
msg1='a'
msg2='Z'
print(msg1 > msg2)
#字符串只能与字符串比较大（安装对应位置的字符参考ASCII表去比较）
常用方式：
msg1='hello'
msg2='Z'
print(len(msg1)>3)
#列表之间可以比较大小么？
l1=[1,2,3]
l2=[10,1]
print(l1 > l2)
#列表只能与列表比较大小（按照对应位置的值依次比较，对应位置的值必须是相同的类型）
```

***

| 赋值运算符 |
| :--- |

以下假设变量：a=10，b=20

| 运算符 | 描述 | 实例 |
| :--- | :--- | :--- |
| = | 简单的赋值运算符 | c=a+b 将a+b的结果赋值给c |
| += | 加法赋值运算符 | c+=a 视为 c=c+a |
| -= | 减法赋值运算符 | c-=a 视为 c=c-a |
| \*= | 乘法赋值运算符 | c\_=a 视为 c=c_a |
| /= | 除法赋值运算符 | c/=a 视为 c=c/a |
| %= | 取模赋值运算符 | c%=a 视为 c=c%a |
| **= | 幂赋值运算符 | c**=a 视为 c=c\*\*a |
| //= | 取余赋值运算符 | c//=a 视为 c=c//a |

```plain
age=18
#增量赋值
age=age+1
print(age)
age+=1
print(age)
#链式赋值
x=100
y=x
z=y
print(id(x),id(y),id(z))
x=y=z=100
print(id(x),id(y),id(z))
#交叉赋值
m=1000
n=2000
m=n #????
#交叉赋值
m=1000
n=2000
temp=m
m=n
n=temp
print(m,n) #????
#交叉赋值
m=1000
n=2000
m,n=n,m
print(m,n)
#解压赋值
salaries=[11,22,33,44,55,66,77]
#需求，将列表中每一个值赋值给单独一个变量
mon1=salaries[0]
mon2=salaries[1]
mon3=salaries[2]
mon4=salaries[3]
mon5=salaries[4]
mon6=salaries[5]
mon7=salaries[6]
print(mon1,mon2,mon3,mon4,mon5,mon6,mon7)
mon1,mon2,mon3,mon4,mon5,mon6,mon7=salaries
print(mon1,mon2,mon3,mon4,mon5,mon6,mon7)
#需求，我只想要前两个月的工资
mon1,mon2,a,b,c,d,e=salaries
print(mon1,mon2)
mon1,mon2,a,a,a,a,a=salaries
print(mon1,mon2)
mon1,mon2,_,_,_,_,_=salaries
print(mon1,mon2)
#需求我只想要，第一个月和最后一个月的工资
first=salaries[0]
last=salaries[6]
print(first)
print(last)
#合并一行
first,_,_,_,_,_,last=salaries
print(first)
print(last)
#简写
first,*_,last=salaries
print(first)
print(last)
```

一个下划线的含义：一般来说，没有人会用下划线做变量名，所以我们可以让它来充当占位符。

***

| 逻辑运算符 |
| :--- |

| 运算符 | 描述 | 实例 |
| :--- | :--- | :--- |
| and | 布尔 "与" - 如果x为False，x and y返回False，否则它返回y计算值 | (a and b) 返回True |
| or | 布尔 "或" - 如果x是True，它返回True，否则他返回y的计算值 | (a or b) 返回 True |
| not | 布尔 "非" - 如果x为True，返回False，它返回True | not (a and b)返回False |

```plain
#三者的优先级从高到低分别是：not，or，and
>>> 3>4 and 4>3 or 1==3 and 'x' == 'x' or 3 >3
False
#最好使用括号来区别优先级，其实意义与上面的一样
>>> (3>4 and 4>3) or ((1==3 and 'x' == 'x') or 3 >3)
False
```

> 更新: 2019-05-27 17:23:07  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/xzxyhw>