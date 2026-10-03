# Python基础10-函数的递归

## Python基础10-函数的递归
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

+ [函数递归介绍](https://blog.driverzeng.com/zenglaoshi/5260.html#toc_0)
+ [三元表达式](https://blog.driverzeng.com/zenglaoshi/5260.html#toc_1)
+ [列表生成式字典生成式集合生成式](https://blog.driverzeng.com/zenglaoshi/5260.html#toc_2)
+ [匿名函数](https://blog.driverzeng.com/zenglaoshi/5260.html#toc_3)

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

## 函数递归介绍
---

| 什么是函数递归 |
| :--- |

函数嵌套调用的一种特殊形式，在调用一个函数的过程中，又直接或间接的调用该函数本身，称之为函数的递归调用

例如：

```plain
def foo():
    print('from foo')
    foo()
foo()
```

<!-- OCR_START -->
- 曾老湿

```text
PYTHON[~/Desktop/PYTHON]-
./O2函数的递归调用.py[PYTHON]
PYTHON
02函数的递归调用.py
01函数对象.py
02函数嵌套.py
03名称空间与作用域.py
04闭包函数.py
01装饰器.py
02函数的递归调用.py
def foo（）:
print('from foo')
foo()
Run:
02函数的递归调用×
from foo
from foo
Traceback(most recent call last):
File"Users/driverzeng/Desktop/PYTHON/02 函数的递归调用.py"，line 5，in<module>
foo()
File“/Users/driverzeng/Desktop/PYTHON/02 函数的递归调用.py"，line 3，in foo
foo()
File/Users/driverzeng/Desktop/PYTHoN/02 函数的递归调用.py"，line 3，in foo
foo()
File“/Users/driverzeng/Desktop/PYTHON/02 函数的递归调用.py"，line3，infoo
foo（)
[Previous line repeated 993more times]
File“Users/driverzeng/Desktop/PYTHON/02 函数的递归调用.py"，line 2，in foo
print('from foo')
RecursionError:maximum recursion depth exceeded while calling a Python object
Process finished with exit code 1
DriverZeng
```
<!-- OCR_END -->

￼

函数调用深度

```plain
def foo(n):
    print('from foo',n)
    foo(n+1)
foo(0)
```

<!-- OCR_START -->
- 曾老湿

```text
PYTHON[~/Desktop/PYTHON]
../O2函数的递归调用.py[PYTHON]
PYTHON02函数的递归调用.py
01函数对象.py×
02函数嵌套.py
03名称空间与作用域.pyx
04闭包函数.pyx
01装饰器.pyx
02函数的递归调用.py
def foo（n):
print('from foo'n)
foo(n+1)
foo(o)
Run:
02函数的递归调用×
from foo 992
from foo 993
from foo994
foo
995
from foo 996
Traceback (mostrecent call last):
FileUsers/driverzeng/Desktop/PYTHON/02 函数的递归调用.py"，Line5，in<module>
foo(0)
File"/Users/driverzeng/Desktop/PYTHON/02 函数的递归调用.py"，line3，infoo
foo(n+1)
:7
File“/Users/driverzeng/Desktop/PYTHON/02 函数的递归调用.py"，Line3，in foo
foo（n+1)
FileUsers/driverzeng/Desktop/PYTHoN/02 函数的递归调用.py"，line3，in foo
foo(n+1)
[PreviousLine repeated993more times]
File/Users/driverzeng/Desktop/PYTHoN/02 函数的递归调用.py"，line2，in foo
print（'from foo',n)
RecursionError:maximum recursion depth exceeded while callinga Python object
5:Debug三6:TODO
Driver Zeng
```
<!-- OCR_END -->

￼

```plain
def bar():
    print('from bar')
    foo()
    
def foo():
    print('from foo')
    bar()
foo()
```

以上的这两种，都没有啥意义，调用完，报错...

```plain
递归调用必须有两个明确的阶段
1.回溯：一次次递归调用下去，但是需要注意的是，每一次重复，问题的规模都应该有所减少，直到最小值，即回溯阶段要有一个明确的结束条件.
2.递推：往回一层一层的推算出结果
def age(n):
    if n == 1:
        return 18
    return age(n-1) + 2
print(age(5))
```

---

| 为啥要用递归？ |
| :--- |

举个栗子：

有一个列表

l=[1,[2,[3,[4,[5,[6,[7,[8,[9,[10,[11,]]]]]]]]]]]

想取出里面的数据

```plain
l=[1,[2,[3,[4,[5,[6,[7,[8,[9,[10,[11,]]]]]]]]]]]
for item in l:
    if type(item) is not list:
        print(item)
    else:
        for i in item:
                if type(i) is not list:
                    print(i)
                else:
                    for n in i:
                        print(n)
```

代码还没写完，无限循环下去吧...

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-../O2函数的递！
- PYTHON
- 02函数的递归调用.py
- 01函数对象.pyx
- 02函数嵌套.pyx
- 03名称空间与作用域.pyx
- 04闭包函数.pyx
- 01装饰器.py
- 15
- bar()
- 16
- 17
- 18
- #foo()
- 19
- 20
- # def age（n):
- 21
- ifn=1:
- 22
- return 18
- 23
- return age（n-1)+2
- 24
- # print（age（5))
- 25
- 26
- =[1[2[3[4[5[6[7[8[9[10[11]]]]]]]]]]]
- 27
- 28
- for item in l:
- 29
- if type(item) is not list:
- 30
- print（item)
- 31
- else:
- 32
- for i in item:
- 33
- if type（i) is not list:
- 34
- print（i)
- 35
- 36
- for n in i:
- 37
- print(n)
- 38
- Run:
- 02函数的递归调用
- /lsers/
- /driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/02 函数的递归调用.py"
- [4, [5, [6, [7, [8, [9, [10, [11]]]]]]]]
- 曾老湿
- Process finished with exit code 0
- Driver Zeng
<!-- OCR_END -->

￼

此时此刻，用递归函数就会好很多，递归只需要把控好结束条件，代码如下，它不香嘛？

```plain
l=[1,[2,[3,[4,[5,[6,[7,[8,[9,[10,[11,]]]]]]]]]]]
def search(l):
    for item in l:
        if type(item) is not list:
            print(item)
        else:
            search(item)
search(l)
```

<!-- OCR_START -->
- 曾老湿

```text
PPYTHON
PYTHON
02函数的递归调用.py
01函数对象.pyx
02函数嵌套.py
03名称空间与作用域.py
04闭包函数.py
01装饰器.py
02函数的递归调用.py
21
ifn=1:
22
return 18
23
return age（n-1) +2
24
#print（age（5))
25
26
27
28
# for item in l:
29
if type（item) is not list:
30
print（item)
31
else:
32
for i in item:
33
if type(i) is not list:
34
print(i)
35
else:
36
for n in i：
37
日#
print(n)
38
39
1=[1,[2,[3[4,[5,[6[7[8,[9,[10[11,]]]]]]]]]]]
40
def search(l):
41
for item in l:
42
if type（item) is not list:
43
print（item)
44
else:
45
search(item)
46
47
search(l)
Run:
02函数的递归调用
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/02 函数的递归调用.py"
1
2
6
8
9
10
11
rocess finished with exit code o
DriverZeng
```
<!-- OCR_END -->

￼

---

| 函数递归调用应用于算法 |
| :--- |

现在有一个列表，里面有很多个数字，从小到排列，现有需求找到某一个数字

nums=[13,15,17,23,31,53,74,81,93,102,201,303,403,503,777]

```plain
# 需求一：找到15
nums=[13,15,17,23,31,53,74,81,93,102,201,303,403,503,777]
find_num=15
for num in nums:
    if num == find_num:
        print('find it:',num)
        break
## emm...运气好 ，15就在第二个，两次就找到了
## 如果找503呢？
## 如果这个数字列表有一万个字呢？
## 效率是不是很低？
# 需求二：提高效率（二分法）
def binary_search(nums,find_num):
    print(nums)
    mid_index=len(nums) // 2
    if find_num > nums[mid_index]:
        # in the right
        nums=nums[mid_index+1:]
        binary_search(nums,find_num)
    elif find_num < nums[mid_index]:
        # in the left
        nums=nums[0:mid_index]
        binary_search(nums, find_num)
    else:
        print('find it',nums[mid_index])
binary_search(nums,find_num)
```

用了4次就可以找到

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-.
- ../O2函数的递归调用.py[PYTHON]
- PYTHON
- 02函数的递归调用.py
- 01函数对象.py
- 02函数嵌套.py
- 03名称空间与作用域.py
- 04闭包函数.py
- 01装饰器.py
- 40
- #det search(L):
- 41
- for item in l:
- 42
- if type(item) is not list:
- 43
- print（item)
- 44
- else:
- 45
- search(item)
- 46
- 47
- #search（）
- 48
- 49
- nums=[13.15,17:23,31,5374.81,93.102,201,303,403,503777]
- 50
- find_num=503
- 51
- 52
- def binary_search（nums,find num):
- 53
- print(nums)
- 54
- mid_index=len（nums)//2
- 55
- if find_num > nums[mid_index]:
- 56
- #in the right
- 57
- nums=nums[mid_index+1:]
- 58
- binary_search(nums,find_num)
- 59
- elif find_num < nums[mid_index]:
- 60
- #in the left
- 61
- nums=nums[o:mid_index]
- 62
- 63
- 64
- print（'find it'nums[mid_index])
- 65
- 66
- 67
- bary_search(numsfind_num)
- 68
- Run:
- 02函数的递归调用×
- /Users/driverzeng/PvcharmProiects/untitled1/venv/bin/pvthon/Users/driverzeng/Desktop/PYTHoN/02 函数的递归调用.py
- [13,15,17,23,31,53,74,81,93,102,201,303,403,503,777]
- [93,1
- 102,201,303，403,503,777]
- [403,503,777]
- find it 503
- 曾老湿
- rocess finished with exit code 0
- DriverZeng
<!-- OCR_END -->

￼

## 三元表达式
---

| 作用 |
| :--- |

会：可以让自己的代码变的更简洁

不会：也没有太大影响...

---

| 举例 |
| :--- |

```plain
# 以前我们写过一个函数，比较两个数的大小
def max2(x,y):
    if x > y:
        return x
    else:
        return y
print(max2(1,10))
# 三元表达式实现
def max2(x,y):
   return x if x > y else y
print(max2(1,10))
# 再举个例子
name=input('your name: ').strip()
res="SB" if name == "haifeng" else "NB"
print(res)
```

## 列表生成式\字典生成式\集合生成式
---

| 列表生成式 |
| :--- |

```plain
# 语法
[expression for item1 in iterable1 if condition1
for item2 in iterable2 if condition2
...
for itemN in iterableN if conditionN
]
类似于
res=[]
for item1 in iterable1:
    if condition1:
        for item2 in iterable2:
            if condition2
                ...
                for itemN in iterableN:
                    if conditionN:
                        res.append(expression)
# 优点：方便，改变了编程习惯，可称之为声明式编程
```

---

| 举例 |
| :--- |

现有一个名字的列表

names=['qls','lls','zhang3','li4','wang5']

```plain
# 需求一：将名字后面都加上一个"大帅比"的后缀
names=['qls','lls','zhang3','li4','wang5']
l=[]
for name in names:
    res=name + '_DSB'
    l.append(res)
print(l)
## 罗里吧嗦，很麻烦
# 使用列表生成式，一行代码搞定
names=['qls','lls','zhang3','li4','wang5']
l=[name + 'DSB' for name in names]
print(l)
# 需求二：将列表中，zls这个名字排除在外
names=['qls_sb','lls_sb','zhang3_sb','li4_sb','wang5_sb','zls']
l=[]
for name in names:
    if name.endswith('sb'):
        l.append(name)
print(l)
# 列表生成式，加判断
l=[name for name in names if name.endswith('sb')]
print(l)
```

---

| 字典生成式 |
| :--- |

现有两个列表

keys=['name','age','gender']

values=['zls',18,'male']

```plain
# 补充技巧 ，python内置enumerate()方法
l=['a','b','c','d']
for item in enumerate(l):
    print(item)
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-../O4列表生成式.py[PYTHON]
- PYTHONO4列表生成式.py
- 01函数对象.py
- 02函数嵌套.pyx
- 03名称空间与作用域.pyx
- 04闭包函数.py
- 01装饰器.py
- 02函数的递归调用.pyx
- 03三元表达式.py
- 04列表生成式.py
- #names=['qls′,'lls′,'zhang3′,'li4',wang5']
- ##=[]
- ## for name in names:
- ##
- res=name +DSB'
- ##
- l.append(res)
- #l=[name +'DSB' for name in names]
- 9
- #print（l)
- 10
- 11
- #names=['qls_sb','lls_sb',zhang3_sb','li4_sb',wang5_sb','zls']
- 12
- #l=[name for name in names if name.endswith（'sb')]
- 13
- #=[]
- 15
- 16
- if name.endswith('sb'):
- 17
- L.append（name)
- 18
- 19
- 20
- keys=['name','age''gender']
- 21
- values=['zls′18,'male']
- 22
- 23
- #补充技巧，python内置enumerate（）方法
- 24
- l=['a'b''c'd']
- 25
- for item in enumerate(l):
- 26
- print(item)
- 27
- Run:
- 04列表生成式
- （0，
- 'a')
- (1,
- 'b')
- 2，
- 'c')
- 曾老湿
- 3，
- `d`)
- Dri
<!-- OCR_END -->

￼

```plain
# 那么我们变量解压
l=['a','b','c','d']
for i,v in enumerate(l):
    print(i,v)
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-
- ../04列表生成式.py[PYTHON]
- PYTHON04列表生成式.py
- 01函数对象.py
- 02函数嵌套.py
- 03名称空间与作用域.py
- 04闭包函数.py
- 01装饰器.py
- 02函数的递归调用.py
- 03三元表达式.py
- 04列表生成式.py
- #names=['qls′,'lls','zhang3','li4',
- wang5']
- ##=[]
- ## for name in names:
- ##
- res=name +'_DSB
- ##
- l.append(res)
- #l=[name+'DSB'forname in names]
- 9
- #print(l)
- 10
- 11
- #names=['qls_sb','lls_sb','zhang3_sb','li4_sb',wang5_sb','zls']
- 12
- #l=[name for name in names if name.endswith('sb')]
- 13
- 14
- #=[]
- 15
- 16
- if name.endswith('sb'）:
- 17
- l.append(name)
- 18
- 19
- 20
- keys=['name','age''gender']
- 21
- values=['zls'18male']
- 22
- 23
- #补充技巧，python内置enumerate（）方法
- 24
- l=['a''b'c''d']
- 25
- for iv in enumerate（l):
- 26
- print(iv)
- 27
- Run:
- 04列表生成式
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/04列表生成式.py
- ocess finishedwithexit codeO
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
# 需求一：把这两个列表，合并成一个字典
keys=['name','age','gender']
values=['zls',18,'male']
dic={}
for i,k in enumerate(keys):
    dic[k] = values[i]
print(dic)
# 需求二：字典生成式，一行代码搞定
keys=['name','age','gender']
values=['zls',18,'male']
dic={k:values[i] for i,k in enumerate(keys)}
print(dic)
# 需求三：字典生成式，加判断
keys=['name','age','gender']
values=['zls',18,'male']
dic={k:values[i] for i,k in enumerate(keys) if i > 0}
print(dic)
```

---

| 集合生成式 |
| :--- |

```plain
# 和字典生成式比较
## 字典
print({i:i for i in range(10)})
## 集合
print({i for i in range(10)})
```

<!-- OCR_START -->
- 曾老湿

```text
THONI
PYTHON04列表生成式.py
01函数对象.py
02函数嵌套.py
03名称空间与作用域.py
04闭包函数.py
01装饰器.py
02函数的递归调用.py
03三元表达式.py
04列表生成式.py
15
# for name in names:
16
if name.endswith('sb'):
17
1.append(name)
18
#print（l)
19
20
#keys=['name','age','gender']
21
#values=['zls',18,'male']
22
23
#dic={}
24
#for i,k in enumerate(keys):
25
dic[k]=values[i]
26
27
print(dic)
28
29
# dic={k:values[i] for i,k in enumerate(keys） if i > 0} 30 #print（dic)
31
32
#补充技巧，python内置enumerate（）方法
33
#l=['a','b','c'，'d']
34
#for i,v in enumerate(l）: 35 print（i,v)
36
37
print（{i:i fori in range(10)})
38
print({i for i in range（10)})
39
Run:
04列表生成式×
Users/driverzeng/Desktop/PYTHON/04列表生成式.py
[0,1,2,3,4,5,6,7,8,9}
DriverZeng
rocessfinishedwithexit code0
```
<!-- OCR_END -->

￼

但是，集合有两个特性：

1.去重

2.无序

```plain
# 例如
print({i for i in 'hello'})
# 结果
```

<!-- OCR_START -->
- 曾老湿

```text
print（{i for i in 'hello'})
04列表生成式
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python
/users/driverzeng/Desktop/PYTHoN/o4列表生成式.py
{'l','h','o'，'e'}
Process finished with exit code 0
DriverZeng
```
<!-- OCR_END -->

￼

## 匿名函数
---

| 什么是匿名函数？ |
| :--- |

匿名：就是没有名字

匿名函数：没有名字的函数

以前我们在定义函数的时候，为啥有名字呢？因为我们要保存下来，需要开辟一块内存空间，那么为什么要用匿名函数呢？作用就是，为了这个函数我们只使用一次的时候，不需要占用内存，没有重复使用的需求。

---

| 举例 |
| :--- |

```plain
# 写一个求和的函数
def sum2(x,y):
    return x+y
print(sum2(1,5))
# 匿名函数
lambda x,y:x+y
# 打印出来，会发现是一个内存地址，如此一来，我们加上括号就可以调用
print(lambda x,y:x+y)
# 错误写法
print(lambda x,y:x+y(1,2))
## 打印出来，还是内存地址，为啥呢... 因为是y(1,2)，所以我们需要，把整个函数括起来
# 正确写法
print((lambda x,y:x+y)(1,2))
```

<!-- OCR_START -->
- 48
- print（（lambda xy:x+y)(12))
- Run:
- 04列表生成式
- /thon
- Process finished with exit code 0
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

---

| 匿名函数配合其他函数使用 |
| :--- |

>  
>
> 内置函数：max,min,sorted,map,filter,reduce
>
> 自定义函数：xxx
>

```plain
# 现有一薪资列表
salaries={
    'zls':10000000,
    'qls':10000,
    'lls':11111,
    'zhang3':100,
    'li4':1
}
# 需求一：max 求出薪资最高的人名：即比较的是字典的value，但是取的结果是key
salaries={
    'zls':10000000,
    'qls':10000,
    'lls':11111,
    'zhang3':100,
    'li4':1
}
def func(name):
    return salaries[name]
res=max(salaries,key=func)
print(res)
# 使用匿名函数
salaries={
    'zls':10000000,
    'qls':10000,
    'lls':11111,
    'zhang3':100,
    'li4':1
}
res=max(salaries,key=lambda name:salaries[name])
print(res)
## 需求二：min 求最小薪资
salaries={
    'zls':10000000,
    'qls':10000,
    'lls':11111,
    'zhang3':100,
    'li4':1
}
res=min(salaries,key=lambda name:salaries[name])
print(res)
# 需求三：使用 sorted 排序，按照薪资从小到大排序（从大到小 reverse=True 即可）
salaries={
    'zls':10000000,
    'qls':10000,
    'lls':11111,
    'zhang3':100,
    'li4':1
}
res=sorted(salaries,key=lambda name:salaries[name])
print(res)
res=sorted(salaries,key=lambda name:salaries[name],reverse=True)
print(res)
# 需求四：使用 map 映射，把每一个人名加上DSB
names=['lxx','qxx','zhang3','li4']
res=map(lambda name:name + 'DSB',names)
print(list(res))
# 需求五：filter 把所有以sb结尾的换成DSB
names=['lxx_sb','qxx_sb','zhang3_sb','zls','li4_sb']
res=filter(lambda name:name.endswith('sb'),names)
print(list(res))
# 需求六：reduce，把多个值合并成一个结果
from functools import reduce
l=['a','b','c','d']
res=reduce(lambda x,y:x+y,l,'A')
print(res)
# 需求七：reduce，1-100相加
from functools import reduce
res=reduce(lambda x,y:x+y,range(1,101))
print(res)
```

> 更新: 2020-06-25 10:51:33  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/cqgxh5>