# 第3章 Python基础-函数编程(new)

# 3.1 上章补充-Bytes类型

## 定义

bytes类型是指一堆字节的集合，在python中以b开头的字符串都是bytes类型

```plain
b'\xe5\xb0\x8f\xe7\x8c\xbf\xe5\x9c\x88' #b开头的都代表是bytes类型，是以16进制来显示的，2个16进制代表一个字节。 utf-8是3个字节代表一个中文，所以以上正好是9个字节
```

## Bytes类型的作用

计算机只能存储2进制， 我们的字符、图片、视频、音乐等想存到硬盘上，也必须以正确的方式编码成2进制后再存。

* 对于文字，我们可以以gbk编码，也可以以utf-8、ASCII编码。
* 对于图片，必须编码成PNG,JPEG等格式
* 对于音乐，必须编码成MP3,WAV等

在python中， 数据转成2进制后不是直接以0101010的形式表示的，而是用一种叫bytes(字节)的类型来表示，人类不可读。字符串转成bytes后长成这个样子

```plain
>>> s = "小猿圈"
>>> s.encode("utf-8")  # 以utf-8编码 
b'\xe5\xb0\x8f\xe7\x8c\xbf\xe5\x9c\x88' #b开头的都代表是bytes类型，是以16进制来显示的，2个16进制代表一个字节。 utf-8是3个字节代表一个中文，所以以上正好是9个字节
```

在python中，字符串必须编码成bytes后才能存到硬盘上。 唉，你说，我之前学的文件操作时也没有把字符串编码后再存呀， 哈，那是python默认帮你干了这个事，在python3中文件存储的默认编码是utf-8.

当然你可以自行改变文件的默认编码，但意味着你存的数据

```plain
f = open(file="encode_test",encoding="gbk",mode="w")
```

这样，你写入的数据就是按gbk编码的了。

## 以二进制模式操作文件

当然，在打开文件时如果你不想让open这个对象帮你自动编码，你也可以直接往文件里存入bytes数据。

```plain
f = open(file="encode_test",mode="wb") # wb以2进制模式打开文件
s = "自学编程，谁不上小猿圈".encode("utf-8")  # 自行编码
print(s )
f.write(s)
f.close()
```

```plain
#以下是print(s)的输出
b'\xe8\x87\xaa\xe5\xad\xa6\xe7\xbc\x96\xe7\xa8\x8b\xef\xbc\x8c\xe8\xb0\x81\xe4\xb8\x8d\xe4\xb8\x8a\xe5\xb0\x8f\xe7\x8c\xbf\xe5\x9c\x88'
```

2进制模式打开文件有

* wb 二进制创建
* rb 二进制读
* ab 二进制追加

# 3.2 上章补充-字符编码的转换

编码转换是指将一种编码转成另外一种编码，比如 utf-8 to gbk。

为何需要编码转换呢？ 因为不同操作系统编码不同， utf-8在win上没办法直接看，因为windows是GBK编码的，得转成gbk。 反过来如果你的GBK字符相在Linux\Mac上正常显示，就得转成utf-8编码。

## 编码&解码

<!-- OCR_START -->
- encode 编码
- string
- bytes
- decode 解码
<!-- OCR_END -->

```plain
>>> s.encode("utf-8")   # 编码
b'\xe5\xb0\x8f\xe7\x8c\xbf\xe5\x9c\x88'
>>> s_utf8=s.encode("utf-8")
>>> 
>>> s_utf8.decode("utf-8")  #解码
'小猿圈'
```

在py3里，内存里的字符串是以unicode编码的，unicode的其中一个特性就是跟

所有语言编码都有映射关系。所以你的utf-8格式的文件，在windows电脑上若是不能看，就可以把utf-8先解码成unicode,再由unicode编码成gbk就可以了。

<!-- OCR_START -->
- windows上乱码
- windows可读
- utf-8 bytes
- unicode str
- gbk bytes
<!-- OCR_END -->

注意，不管在Windows or Mac or Linux上，你的pycharm IDE都可以支持各种文件编码，所以即使是utf-8的文件，在windows下的pycharm里也可以正常显示

<!-- OCR_START -->
- apeland_py_learn [~/PycharmProjects/apeland_py_learn] - ./day3_函数编程/文件操作.py [apeland_py_learn]
- apeland_py_learn） day3_函数编程》文件操作.py
- 文件操作▼Q
- Project
- 文件操作.p义
- builtins.py X
- encode_test X
- apeland_py_learn~/Pychar
- 1
- day1
- 2
- day2
- 3
- open(file="encode_test",mode="wb")
- day3_函数编程
- 4
- 5
- #S="小猿圈""encode（"utf-8")
- 文件操作.py
- 6
- # f.write(s)
- venv
- 7
- lli External Libraries
- 8
- # f.write("中国".encode("GBK"))
- Z Scratches and Consoles
- 9
- 10
- S ="小猿圈".encode("shift_jis")
- 斤不
- 11
- print(s )
- 12
- fqwrite(s)
- 13
- f.close()小
- Run:
- 文件操作
- ①Big5
- /Users/alex/PycharmProjects/apeland_py_learn/venv/bin/python/Users/alex/PycharmProjects/apelard_py_learn/day3_函数编程/
- A Big5-HK
- b'\x8f\xac\x89\x8e\x9a\x9f'
- CESU-
- A EUC-JP
- Processfinishedwithexitcode0
- EUC-KR
- AGB18030
- AGB2312
- A GBK
- θ ISO-8859-1
- ① US-ASCII
- IBM-Tha
- IBM0785
- AUTF-16
- IBMO1140
- 三6:TODO
- 2 Python Console
- more
- ①IBM01141
- Change encoding to 'US-ASCIl'
- UTF-8  4 spaces
- IBM01142
<!-- OCR_END -->

# 3.3 上章补充-深浅copy

## 浅copy

现有数据

```plain
data = {
    "name":"alex",
    "age":18,
    "scores":{
        "语文":130,
        "数学":60,
        "英语":98,
    }
}
d2 = data
data["age"] = 20 
print(d2)
```

你说d2打印的值里，age是18，还是20？

```plain
{'name': 'alex', 'age': 20, 'scores': {'语文': 130, '数学': 60, '英语': 98}}
```

为何是20呢？ 因为d2=data相当于只是拿到了data的内存地址，但data里的每个k,v都是有单独的内存的地址的。d2,data会一直共享这个dict里的数据，不会出现像之前字符串a=1,b=a, a=2, b依然等于1的情况。

<!-- OCR_START -->
- 4321011536
- data = {
- "name": "alex"
- "age":18,
- "scores":{
- "语文"：130，
- "数学"：60，
- "英语"：98，
- d2 = data
- data["age"] = 20
<!-- OCR_END -->

如果我确实想复制一份完成的dict数据怎么办呢？

可以用浅copy语法

```plain
data = {
    "name":"alex",
    "age":18,
    "scores":{
        "语文":130,
        "数学":60,
        "英语":98,
    }
}
d2 = data.copy()
data["age"] = 20
print(d2)
print(data)
```

输出

```plain
{'name': 'alex', 'age': 18, 'scores': {'语文': 130, '数学': 60, '英语': 98}}
{'name': 'alex', 'age': 20, 'scores': {'语文': 130, '数学': 60, '英语': 98}}
```

这样就相当于是2份独立数据了， 但是为什么这个语法叫做浅copy呢？ 你改一下score里的值 就知道了。

```plain
data = {
    "name":"alex",
    "age":18,
    "scores":{
        "语文":130,
        "数学":60,
        "英语":98,
    }
}
d2 = data.copy()
data["age"] = 20
data["scores"]["数学"] = 77  
print(d2)
print(data)
```

看输出 ， 很神奇，两个Dict里age的值是独立的，但score字典里的分数值貌似是共享的

```plain
{'name': 'alex', 'age': 18, 'scores': {'语文': 130, '数学': 77, '英语': 98}}
{'name': 'alex', 'age': 20, 'scores': {'语文': 130, '数学': 77, '英语': 98}}
```

因为浅copy会仅复制dict的第一层数据，更深层的scores下面的值依然是共享一份。

<!-- OCR_START -->
- data = {
- d2={
- "name" : "alex"
- 4323124648
- "age":18,
- 4297636896
- "age":20,
- 4297636960
- "scores":{4303185672
- "语文"：130，
- "数学"：60，
- "英语"：98，
<!-- OCR_END -->

注意图中的2个dict中的name都是alex,内存地址也一样，在没改前，两个name都确实指向同一个内存地址，但只要改任何一个的值，内存地址都会变更， 如age这个key一样。

深copy

若你想彻底使上面的2个dict完全独立，无论有多少层数据。那就要用python工具包里的一个工具了，

<!-- OCR_START -->
- import copy
- data = {
- "name": "alex"
- "age":18,
- "scores":{
- "语文"：130，
- "数学"：60，
- "英语"：98，
- d2 = data.copy()
- d3 = copy.deepcopy(data)
- d3["scores"]["语文"]
- 149
- pμnt(d3)
- print(data)
- 完全独立了
- un:
- 深浅COPY
- /Users/alex/PycharmProjects/apeland_py_learn/venv/bir/python /Users/alex/PycharmProj
- {'name'：'alex'，'age'：20，'scores'：{'语文'：149，'数学'：60，'英语'：98}}
- {'name'：'alex'，'age'：20，'scores'：{'语文'：130，'数学'：60，'英语'：98}}
- Process finished with exit code 0
<!-- OCR_END -->

最后，这东西有什么用呢？ 坦白讲，以后开发中多数情况下你用不到，但是你有要知道有这个知识点，说不定哪天有个需求就要求你必须确保你的2个复制出来的dict,list必须是独立的了。

# 3.4 函数来了

## 引子

现在老板让你写一个监控程序，24小时全年无休的监控你们公司网站服务器的系统状况，当cpu＼memory＼disk等指标的使用量超过阀值时即发邮件报警，你掏空了所有的知识量，写出了以下代码

```plain
while True：
    if cpu利用率 > 90%:
        #发送邮件提醒
        连接邮箱服务器
        发送邮件
        关闭连接
    if 硬盘使用空间 > 90%:
        #发送邮件提醒
        连接邮箱服务器
        发送邮件
        关闭连接
    if 内存占用 > 80%:
        #发送邮件提醒
        连接邮箱服务器
        发送邮件
        关闭连接
```

上面的代码实现了功能，但即使是邻居老王也看出了端倪，老王亲切的摸了下你家儿子的脸蛋，说，你这个重复代码太多了，每次报警都要重写一段发邮件的代码，太low了，这样干存在2个问题：

1. 代码重复过多，一个劲的copy and paste不符合高端程序员的气质
2. 如果日后需要修改发邮件的这段代码，比如加入群发功能，那你就需要在所有用到这段代码的地方都修改一遍

你觉得老王说的对，你也不想写重复代码，但又不知道怎么搞，老王好像看出了你的心思，此时他抱起你儿子，笑着说，其实很简单，**只需要把重复的代码提取出来，放在一个公共的地方，起个名字，以后谁想用这段代码，就通过这个名字调用就行了**，如下

```plain
def 发送邮件(内容)
    #发送邮件提醒
    连接邮箱服务器
    发送邮件
    关闭连接
while True：
    if cpu利用率 > 90%:
        发送邮件('CPU报警')
    if 硬盘使用空间 > 90%:
        发送邮件('硬盘报警')
    if 内存占用 > 80%:
        发送邮件('内存报警')
```

你看着老王写的代码，气势恢宏、磅礴大气，代码里透露着一股内敛的傲气，心想，老王这个人真是不一般，突然对他的背景更感兴趣了，问老王，这些花式玩法你都是怎么知道的？ 老王亲了一口你儿子，捋了捋不存在的胡子，淡淡的讲，“老夫，年少时，师从京西沙河淫魔银角大王 ”， 你一听“银角大王”这几个字，不由的娇躯一震，心想，真nb,怪不得代码写的这么6, 这“银角大王”当年在江湖上可是数得着的响当当的名字，只可惜后期纵欲过度，卒于公元2019年， 真是可惜了，只留下其哥哥孤守当年兄弟俩一起打下来的江山。 此时你看着的老王离开的身影，感觉你儿子跟他越来越像了。。

## 基本定义

#### 函数是什么?

函数一词来源于数学，但编程中的「函数」概念，与数学中的函数是有很大不同的，具体区别，我们后面会讲，编程中的函数在英文中也有很多不同的叫法。在BASIC中叫做subroutine(子过程或子程序)，在Pascal中叫做procedure(过程)和function，在C中只有function，在Java里面叫做method。

**定义: 函数是指将一组语句的集合通过一个名字(函数名)封装起来，要想执行这个函数，只需调用其函数名即可**

**特性:**

1. 减少重复代码
2. 使程序变的可扩展
3. 使程序变得易维护

#### 语法定义

```plain
def sayhi():#函数名
    print("Hello, I'm nobody!")
sayhi() #调用函数
```

可以带参数

```plain
#下面这段代码
a,b = 5,8
c = a**b
print(c)
#改成用函数写
def calc(x,y):
    res = x**y
    return res #返回函数执行结果
c = calc(a,b) ＃结果赋值给c变量
print(c)
```

参数可以让你的函数更灵活，不只能做死的动作，还可以根据调用时传参的不同来决定函数内部的执行流程

## 函数参数

**形参变量**

只有在被调用时才分配内存单元，在调用结束时，即刻释放所分配的内存单元。因此，形参只在函数内部有效。函数调用结束返回主调用函数后则不能再使用该形参变量

**实参**

可以是常量、变量、表达式、函数等，无论实参是何种类型的量，在进行函数调用时，它们都必须有确定的值，以便把这些值传送给形参。因此应预先给实参赋值

<!-- OCR_START -->
- 形参
- 实参

```text
#改成用函数写
def calc(x,y)
res=x**y
return res
c = calc(a,b)
print(c)
```
<!-- OCR_END -->

#### **默认参数**

看如下代码

```plain
def stu_register(name,age,country,course):
    print("----注册学生信息------")
    print("姓名:",name)
    print("age:",age)
    print("国籍:",country)
    print("课程:",course)
stu_register("王山炮",22,"CN","python_devops")
stu_register("张叫春",21,"CN","linux")
stu_register("刘老根",25,"CN","linux")
```

发现 country 这个参数 基本都 是”CN”, 就像我们在网站上注册用户，像国籍这种信息，你不填写，默认就会是 中国， 这就是通过默认参数实现的，把country变成默认参数非常简单

```plain
def stu_register(name,age,course,country="CN"):
```

这样，这个参数在调用时不指定，那默认就是CN，指定了的话，就用你指定的值。

> \*\*另外，你可能注意到了，在把country变成默认参数后，我同时把它的位置移到了最后面，为什么呢？　　\*\*

#### 关键参数

正常情况下，给函数传参数要按顺序，不想按顺序就可以用关键参数，只需指定参数名即可(指定了参数名的参数就叫关键参数)，***但记住一个要求就是，关键参数必须放在位置参数(以位置顺序确定对应关系的参数)之后***

```plain
def stu_register(name, age, course='PY' ,country='CN'):
    print("----注册学生信息------")
    print("姓名:", name)
    print("age:", age)
    print("国籍:", country)
    print("课程:", course)
```

调用可以这样

```plain
stu_register("王山炮",course='PY', age=22,country='JP' )
```

但绝不可以这样

```plain
stu_register("王山炮",course='PY',22,country='JP' )
```

当然这样也不行

```plain
stu_register("王山炮",22,age=25,country='JP' )
```

这样相当于给age赋值2次，会报错！

注意，参数优先级顺序是 位置参数>关键参数

#### **非固定参数**

若你的函数在定义时不确定用户想传入多少个参数，就可以使用非固定参数

```plain
def stu_register(name,age,*args): # *args 会把多传入的参数变成一个元组形式
    print(name,age,args)
stu_register("Alex",22)
#输出
#Alex 22 () #后面这个()就是args,只是因为没传值,所以为空
stu_register("Jack",32,"CN","Python")
#输出
# Jack 32 ('CN', 'Python')
```

还可以有一个\*\*kwargs

```plain
def stu_register(name,age,*args,**kwargs): # *kwargs 会把多传入的参数变成一个dict形式
    print(name,age,args,kwargs)
stu_register("Alex",22)
#输出
#Alex 22 () {}#后面这个{}就是kwargs,只是因为没传值,所以为空
stu_register("Jack",32,"CN","Python",sex="Male",province="ShanDong")
#输出
# Jack 32 ('CN', 'Python') {'province': 'ShanDong', 'sex': 'Male'}
```

## 练习题

1.根据下图所示，对print_info里的代码进行实现

<!-- OCR_START -->
- 函数参数.pyX
- 1
- 2
- def print_info(*args,**kwargs):.. :
- 12
- 13
- 14
- print_info(name="Alex",age=22,sex="M")
- 15
- print_info(name="Jack",age=26,sex="M",hobbie="学习")
- 16
- 17
- Run:
- 函数参数
- /Users/alex/PycharmProjects/apeland_py_learn/venv/bin/python /Users/alex/P
- -info
- Name: Alex
- Age: 22
- Sex: M
- Hobbie：大保健
- Name: Jack
- Age: 26
- Hobbie：学习
<!-- OCR_END -->

# 3.5 函数返回值与作用域

函数外部的代码要想获取函数的执行结果，就可以在函数里用return语句把结果返回

```plain
def stu_register(name, age, course='PY' ,country='CN'):
    print("----注册学生信息------")
    print("姓名:", name)
    print("age:", age)
    print("国籍:", country)
    print("课程:", course)
    if age > 22:
        return False
    else:
        return True
registriation_status = stu_register("王山炮",22,course="PY全栈开发",country='JP')
if registriation_status:
    print("注册成功")
else:
    print("too old to be a student.")
```

**注意**

* 函数在执行过程中只要遇到return语句，就会停止执行并返回结果，so 也可以理解为 return 语句代表着函数的结束
* 如果未在函数中指定return,那这个函数的返回值为None

## 全局与局部变量

```plain
name = "Alex Li"
def change_name():
    name = "金角大王,一个有Tesla的高级屌丝"
    print("after change", name)
change_name()
print("在外面看看name改了么?",name)
```

输出

```plain
after change 金角大王,一个有Tesla的高级屌丝
在外面看看name改了么? Alex Li
```

为什么在函数内部改了name的值后， 在外面print的时候却没有改呢？ 因为这两个name根本不是一回事

* 在函数中定义的变量称为局部变量，在程序的一开始定义的变量称为全局变量。
* 全局变量作用域(即有效范围)是整个程序，局部变量作用域是定义该变量的函数。
* 变量的查找顺序是**局部变量>全局变量**
* 当全局变量与局部变量同名时，在定义局部变量的函数内，局部变量起作用；在其它地方全局变量起作用。
* 在函数里是不能直接修改全局变量的

#### 就是想在函数里修改全局变量怎么办？

```plain
name = "Alex Li"
def change_name():
    global name #声明一个全局变量
    name = "Alex 又名金角大王,爱生活、爱自由、爱姑娘"
    print("after change", name)
change_name()
print("在外面看看name改了么?", name)
```

`global name`**的作用就是要在函数里声明全局变量name ，意味着最上面的**`name = “Alex Li”`**即使不写，程序最后面的print也可以打印name**

## 传递列表、字典、集合产生的现象

```plain
d = {"name":"Alex","age":26,"hobbie":"大保健"}
l = ["Rebeeca","Katrina","Rachel"]
def change_data(info,girls):
    info["hobbie"] = "学习"
    girls.append("XiaoYun")
change_data(d,l)
print(d,l)
```

执行结果{‘name’: ‘Alex’, ‘age’: 26, ‘hobbie’: ‘学习’} \[‘Rebeeca’, ‘Katrina’, ‘Rachel’, ‘XiaoYun’]

不是说不能在函数里改全局变量么，怎么改了呀？

<!-- OCR_START -->
- 4312622856
- 4312638888
- 4297637152
- d=K"name":"Alex"，"age":26，"hobbie":"大保健"}
- def change_data(info,girls) :
- print(id(info))
- #输出4312622856
- info["hobbie"]="学习"
- girls.append("XiaoYun")
- change_data(d,)
<!-- OCR_END -->

根据上图我们能看出， 程序只是把d这个dict的内存地址传给了change_data函数，把dict比作鱼缸，里面的k,v比作缸里装的鱼。现在只是把鱼缸丢给了函数，这个鱼缸本身你不能改，但是里面的鱼可以。 相当于只是传了一个对这个d的引用关系给到函数的形参。这样是为了减少内存的浪费，因为如果这个dict比较大，传一次到函数里就要copy一份新的值的话，效率太低了。

# 3.6 嵌套&匿名&高阶函数

## 嵌套函数

函数里不仅可以写代码，还可以嵌套函数

```plain
name = "小猿圈"
def change():
    name = "小猿圈，自学编程"
    def change2():
        # global name  如果声明了这句，下面的name改的是最外层的全局变层
        name = "小猿圈，自学编程不要钱" #这句注释掉的话，下面name打印的是哪个值？
        print("第3层打印", name) 
    change2()  # 调用内层函数
    print("第2层打印", name)
change()
print("最外层打印", name)
```

输出

```plain
第3层打印 小猿圈，自学编程不要钱
第2层打印 小猿圈，自学编程
最外层打印 小猿圈
```

通过上面的例子，我们理解了，每个函数里的变量是互相独立的，变量的查找顺序也是从当前层依次往上层找。

问个哲学问题，这东西有什么用呢？哈，现在没用，不解释，长大后学了装饰器你就知道有啥用了。

## 匿名函数

匿名函数就是不需要显式的指定函数名

```plain
#这段代码
def calc(x,y):
    return x**y
print(calc(2,5))
#换成匿名函数
calc = lambda x,y:x**y
print(calc(2,5))
```

你也许会说，用上这个东西没感觉有毛方便呀， 。。。。呵呵，如果是这么用，确实没毛线改进，不过匿名函数主要是和其它函数搭配使用的呢，如下

```plain
res = map(lambda x:x**2,[1,5,7,4,8])
for i in res:
    print(i)
```

输出

```plain
1
25
49
16
64
```

## 高阶函数

变量可以指向函数，函数的参数能接收变量，那么一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数。

```plain
def get_abs(n):
    if n < 0 :
        n = int(str(n).strip("-"))
    return n
def add(x,y,f):
    return f(x) + f(y)
res = add(3,-6,get_abs)
print(res)
```

只需满足以下任意一个条件，即是高阶函数

* 接受一个或多个函数作为输入
* return 返回另外一个函数

# 3.7 函数的递归

求100不断除以2直到商为0为止，打印每次除的商

用循环实现

```plain
n = 100
while n > 0:
    n = int(n/2)
    print(n)
```

输出：

50

25

12

6

3

1

0

如果用函数，如何实现呢？

```plain
def calc(n):
    n = int(n/2)
    print(n)
    if n > 0:
        calc(n) #调用自己
calc(100)
```

在函数内部，可以调用其他函数。如果一个函数在内部调用自已本身，这个函数就叫做递归函数。上面我们写的这个代码就是递归

#### 递归的执行过程

```plain
def calc(n):
    n = int(n/2)
    print(n)
    if n > 0:
         calc(n)
    print(n) 
calc(10)
```

输出：

5

2

1

0

0

1

2

5

为什么输出是这样呢？

<!-- OCR_START -->
- 3
- =/o
- 2
- 7=l0
<!-- OCR_END -->

如上图所示，函数在每进入下一层的时候，当前层的函数并未结束，它必须等它调用的下一层函数执行结束返回后才能继续往下走。 所以最下面的那句print(n)会等最里层的函数执行时才会执行，然后不断往外退层，所以会出现0、1、2、5的效果

**递归特性:**

1. 必须有一个明确的结束条件
2. 每次进入更深一层递归时，问题规模相比上次递归都应有所减少
3. 递归效率不高，递归层次过多会导致栈溢出（在计算机中，函数调用是通过栈（stack）这种数据结构实现的，每当进入一个函数调用，栈就会加一层栈帧，每当函数返回，栈就会减一层栈帧。由于栈的大小不是无限的，所以，递归调用的次数过多，会导致栈溢出）

递归在特定场景下还是挺有用的，以后学的一些算法就得用到递归，比如堆排、快排等，现在看还是有些复杂的，以后再讲。

## 练习题

用递归实现2分查找的算法，以从列表 a = \[1,3,4,6,7,8,9,11,15,17,19,21,22,25,29,33,38,69,107] 查找指定的值。

注：参考答案在本章最后的练习题部分，但尽量先自己先。

# 3.8 内置函数

Python的len为什么你可以直接用？肯定是解释器启动时就定义好了

<!-- OCR_START -->
- Built-in Functions
- abs()
- dict()
- help()
- min()
- setattr()
- all()
- dir()
- hex()
- next()
- slice()
- any()
- divmod()
- id()
- object()
- sorted()
- ascii()
- enumerate()
- input()
- oct()
- staticmethod()
- bin()
- eval()
- int()
- open()
- str()
- bool()
- exec()
- isinstance()
- ord()
- sum()
- bytearray()
- filter()
- issubclass()
- pow()
- super()
- bytes ()
- float()
- iter()
- print()
- tuple()
- callable()
- format()
- len()
- property()
- type()
- chr()
- frozenset()
- list()
- range()
- vars()
- classmethod()
- getattr()
- locals()
- repr()
- zip()
- compile()
- globals()
- map()
- reversed()
- import
- _()
- complex()
- hasattr()
- max()
- round()
- delattr()
- hash()
- memoryview()
- set()
<!-- OCR_END -->

> 内置参数详解<https://docs.python.org/3/library/functions.html?highlight=built#ascii>

## 每个函数的作用我都帮你标好了

abs # 求绝对值

all #Return True if bool(x) is True for all values x in the iterable.If the iterable is empty, return True.

any #Return True if bool(x) is True for any x in the iterable.If the iterable is empty, return False.

ascii #Return an ASCII-only representation of an object,ascii(“中国”) 返回”‘\u4e2d\u56fd’”

bin #返回整数的2进制格式

bool # 判断一个数据结构是True or False, bool({}) 返回就是False, 因为是空dict

bytearray # 把byte变成 bytearray, 可修改的数组

bytes # bytes(“中国”,”gbk”)

callable # 判断一个对象是否可调用

chr # 返回一个数字对应的ascii字符 ， 比如chr(90)返回ascii里的’Z’

classmethod #面向对象时用，现在忽略

compile #py解释器自己用的东西，忽略

complex #求复数，一般人用不到

copyright #没用

credits #没用

delattr #面向对象时用，现在忽略

dict #生成一个空dict

dir #返回对象的可调用属性

divmod #返回除法的商和余数 ，比如divmod(4,2)，结果(2, 0)

enumerate #返回列表的索引和元素，比如 d = \[“alex”,”jack”]，enumerate(d)后，得到(0, ‘alex’) (1, ‘jack’)

eval #可以把字符串形式的list,dict,set,tuple,再转换成其原有的数据类型。

exec #把字符串格式的代码，进行解义并执行，比如exec(“print(‘hellworld’)”)，会解义里面的字符串并执行

exit #退出程序

filter #对list、dict、set、tuple等可迭代对象进行过滤， filter(lambda x:x>10,\[0,1,23,3,4,4,5,6,67,7])过滤出所有大于10的值

float #转成浮点

format #没用

frozenset #把一个集合变成不可修改的

getattr #面向对象时用，现在忽略

globals #打印全局作用域里的值

hasattr #面向对象时用，现在忽略

hash #hash函数

help

hex #返回一个10进制的16进制表示形式,hex(10) 返回’0xa’

id #查看对象内存地址

input

int

isinstance #判断一个数据结构的类型，比如判断a是不是fronzenset, isinstance(a,frozenset) 返回 True or False

issubclass #面向对象时用，现在忽略

iter #把一个数据结构变成迭代器，讲了迭代器就明白了

len

list

locals

map # map(lambda x:x\*\*2,\[1,2,3,43,45,5,6,]) 输出 \[1, 4, 9, 1849, 2025, 25, 36]

max # 求最大值

memoryview # 一般人不用，忽略

min # 求最小值

next # 生成器会用到，现在忽略

object #面向对象时用，现在忽略

oct # 返回10进制数的8进制表示

open

ord # 返回ascii的字符对应的10进制数 ord(‘a’) 返回97，

print

property #面向对象时用，现在忽略

quit

range

repr #没什么用

reversed # 可以把一个列表反转

round #可以把小数4舍5入成整数 ，round(10.15,1) 得10.2

set

setattr #面向对象时用，现在忽略

slice # 没用

sorted

staticmethod #面向对象时用，现在忽略

str

sum #求和,a=\[1, 4, 9, 1849, 2025, 25, 36],sum(a) 得3949

super #面向对象时用，现在忽略

tuple

type

vars #返回一个对象的属性，面向对象时就明白了

zip #可以把2个或多个列表拼成一个， a=\[1, 4, 9, 1849, 2025, 25, 36]，b = \[“a”,”b”,”c”,”d”]，

```plain
list(zip(a,b)) #得结果 
[(1, 'a'), (4, 'b'), (9, 'c'), (1849, 'd')]
```

#### 几个刁钻古怪的内置方法用法提醒

```plain
#compile
f = open("函数递归.py")
data =compile(f.read(),'','exec')
exec(data)
#print
msg = "又回到最初的起点"
f = open("tofile","w")
print(msg,"记忆中你青涩的脸",sep="|",end="",file=f)
# #slice
# a = range(20)
# pattern = slice(3,8,2)
# for i in a[pattern]: #等于a[3:8:2]
#     print(i)
#
#
#memoryview
#usage:
#>>> memoryview(b'abcd')
#
#在进行切片并赋值数据时，不需要重新copy原列表数据，可以直接映射原数据内存，
import time
for n in (100000, 200000, 300000, 400000):
    data = b'x'*n
    start = time.time()
    b = data
    while b:
        b = b[1:]
    print('bytes', n, time.time()-start)
for n in (100000, 200000, 300000, 400000):
    data = b'x'*n
    start = time.time()
    b = memoryview(data)
    while b:
        b = b[1:]
    print('memoryview', n, time.time()-start)
```

#### 练习题

#### 员工信息修改程序

#### 在一个文件里存多个人的个人信息，如以下

```plain
username,password,age,position,department,phone
alex,abc123,30,Engineer,IT,13651830433
rain,df2@432,25,Teacher,Teching,18912334223
黑姑娘,df2@432,26,行政,人事,13811177306
```

#### 需求：

#### 1.输入用户名密码，正确后登录系统 ，打印

```plain
1. 修改个人信息
2. 打印个人信息
3. 修改密码
```

#### 2.每个选项写一个方法

#### 3. 当用户选择1时，提示用户选择要修改的字段，根据用户输入对相应字段进行修改

#### 4.登录时输错3次退出程序

#### 执行时应该达到的效果参考：

#### python /Users/alex/PycharmProjects/apeland_py_learn/day3_函数编程/个人信息修改练习.py

```plain
Username:alex
Password:abc123
-------------------welcome alex --------------------
1. 打印个人信息
2. 修改个人信息
3. 修改密码
>>>1
    ------------------
    Name:   abc123
    Age :   30
    Job :   Engineer
    Dept:   Sales
    Phone:  13651830433
    ------------------
1. 打印个人信息
2. 修改个人信息
3. 修改密码
>>>2
person data: ['alex', 'abc123', '30', 'Engineer', 'Sales', '13651830433']
0.  Username: alex
1.  Password: abc123
2.  Age: 30
3.  Job: Engineer
4.  Dept: Sales
5.  Phone: 13651830433
[select column id to change]:4
current value>: Sales
new value>:Marketing
['alex', 'abc123', '30', 'Engineer', 'Marketing', '13651830433']
1. 打印个人信息
2. 修改个人信息
3. 修改密码
>>>q
bye.
```

#### 代码提示

#### 

<!-- OCR_START -->
- 打印个人信息
- 改了数据后要存回文件
- 改数据
- 启动程序后，先把文件内容加载到

```text
def print_personal_info(account_dic,username):..:
def save_back_to_file(account_dic): ..
def change_personal_info(account_dic,username) :..:
account_file = "staff_list"
f = open(account_file,"r+")
raw_data = f.readlines()
accounts = {}
#把账户数据从文件里读书来，变成dict，这样后面就好查询了
for line in raw_data:
line = line.strip()
ifnotline.startswith("#"）：内存后改成dict, ，username做key items = line.split(",") 后面查询时方便
accounts[items [o]] = items
# print(accounts)
白menu=
1.打印个人信息
2．修改个人信息
3．修改密码
count = 0
while count <3:..
else:
print("Too many attempts.")
```
<!-- OCR_END -->

# 3.9 名称空间

又名name space, 顾名思义就是存放名字的地方，存什么名字呢？举例说明，若变量x=1，1存放于内存中，那名字x存放在哪里呢？**名称空间正是存放名字x与1绑定关系的地方**

python里面有很多名字空间，每个地方都有自己的名字空间，互不干扰，不同空间中的两个相同名字的变量之间没有任何联系。

名称空间有4种:`LEGB`

* `locals`:函数内部的名字空间，一般包括函数的局部变量以及形式参数
* `enclosing function`:在嵌套函数中外部函数的名字空间, 若fun2嵌套在fun1里，对`fun2`来说，`fun1`的名字空间就enclosing.
* `globals`:当前的模块空间，模块就是一些`py`文件。也就是说，globals()类似全局变量。
* `**builtins**`: 内置模块空间，也就是内置变量或者内置函数的名字空间，print(dir(**builtins**))可查看包含的值。

**不同变量的作用域不同就是由这个变量所在的名称空间决定的。**

作用域即范围

* 全局范围：全局存活，全局有效
* 局部范围：临时存活，局部有效

查看作用域方法 globals(),locals()

## 作用域查找顺序

当程序引用某个变量的名字时，就会从当前名字空间开始搜索。搜索顺序规则便是:`LEGB`。**即locals -> enclosing function -> globals ->builtins**。一层一层的查找，找到了之后，便停止搜索，如果最后没有找到,则抛出在`NameError`的异常。

```plain
level = 'L0'
n = 22
def func():
    level = 'L1'
    n = 33
    print(locals())
    def outer():
        n = 44
        level = 'L2'
        print("outer:",locals(),n)
        def inner():
            level = 'L3'
            print("inner:",locals(),n) #此外打印的n是多少？
        inner()
    outer()
func()
```

输出

```plain
{'n': 33, 'level': 'L1'}
outer: {'level': 'L2', 'n': 44} 44
inner: {'level': 'L3', 'n': 44} 44
```

# 3.10 闭包是个什么东西？

关于闭包，即函数定义和函数表达式位于另一个函数的函数体内(嵌套函数)。而且，这些内部函数可以访问它们所在的外部函数中声明的所有局部变量、参数。当其中一个这样的内部函数在包含它们的外部函数之外被调用时，就会形成闭包。也就是说，内部函数会在外部函数返回后被执行。而当这个内部函数执行时，它仍然必需访问其外部函数的局部变量、参数以及其他内部函数。这些局部变量、参数和函数声明（最初时）的值是外部函数返回时的值，但也会受到内部函数的影响。

```plain
def outer():
    name = 'alex'
    def inner():
        print("在inner里打印外层函数的变量",name)
    return inner # 注意这里只是返回inner的内存地址，并未执行
f = outer() # .inner at 0x1027621e0> 
f()  # 相当于执行的是inner()
```

注意此时outer已经执行完毕，正常情况下outer里的内存都已经释放了，但此时由于闭包的存在，我们却还可以调用inner, 并且inner内部还调用了上一层outer里的name变量。这种粘粘糊糊的现象就是闭包。

闭包的意义：**返回的函数对象，不仅仅是一个函数对象，在该函数外还包裹了一层作用域，这使得，该函数无论在何处调用，优先使用自己外层包裹的作用域**

闭包在哪会用？ 下节就用。

# 3.11 函数进阶-装饰器

你是一家视频网站的后端开发工程师，你们网站有以下几个版块。

```plain
def home():
    print("---首页----")
def america():
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
def henan():
    print("----河南专区----")
```

视频刚上线初期，为了吸引用户，你们采取了免费政策，所有视频免费观看，迅速吸引了一大批用户，免费一段时间后，每天巨大的带宽费用公司承受不了了，所以准备对比较受欢迎的几个版块收费，其中包括“欧美” 和 “河南”专区，你拿到这个需求后，想了想，想收费得先让其进行用户认证，认证通过后，再判定这个用户是否是VIP付费会员就可以了，是VIP就让看，不是VIP就不让看就行了呗。 你觉得这个需求很是简单，因为要对多个版块进行认证，那应该把认证功能提取出来单独写个模块，然后每个版块里调用 就可以了，与是你轻轻的就实现了下面的功能 。

```plain
account = {
    "is_authenticated":False,# 用户登录了就把这个改成True
    "username":"alex", # 假装这是DB里存的用户信息
    "password":"abc123" # 假装这是DB里存的用户信息
}
def login():
    if account["is_authenticated"] is False:
        username = input("user:")
        password = input("pasword:")
        if username == account["username"] and password == account["password"]:
            print("welcome login....")
            account["is_authenticated"] = True
        else:
            print("wrong username or password!")
    else:
        print("用户已登录，验证通过...")
def home():
    print("---首页----")
def america():
    login()  # 执行前加上验证
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
def henan():
    login()  # 执行前加上验证
    print("----河南专区----")
home()
america()
henan()
```

此时你信心满满的把这个代码提交给你的TEAM LEADER审核，没成想，没过5分钟，代码就被打回来了， TEAM LEADER给你反馈是，我现在有很多模块需要加认证模块，你的代码虽然实现了功能，但是需要更改要加认证的各个模块的源代码，这直接违反了软件开发中的一个原则“开放-封闭”原则，简单来说，它规定已经实现的功能代码不应该被修改，但可以被扩展，即：

* 封闭：已实现的功能代码块不应该被修改
* 开放：对现有功能的扩展开放

这个原则你还是第一次听说，我擦，再次感受了自己这个野生程序员与正规军的差距，BUT ANYWAY,老大要求的这个怎么实现呢？如何在不改原有功能代码的情况下加上认证功能呢？你一时想不出思路，只好带着这个问题回家继续憋，媳妇不在家，去隔壁老王家串门了，你正好落的清静，一不小心就想到了解决方案，不改源代码可以呀。 你师从沙河金角大王时，记得他教过你，高阶函数，就是把一个函数当做一个参数传给另外一个函数，当时大王说，有一天，你会用到它的，没想到这时这个知识点突然从脑子 里蹦出来了，我只需要写个认证方法，每次调用 需要验证的功能 时，直接 把这个功能 的函数名当做一个参数 传给 我的验证模块不就行了么，哈哈，机智如我，如是你啪啪啪改写了之前的代码。

```plain
account = {
    "is_authenticated":False,# 用户登录了就把这个改成True
    "username":"alex", # 假装这是DB里存的用户信息
    "password":"abc123" # 假装这是DB里存的用户信息
}
def login(func):
    if account["is_authenticated"] is False:
        username = input("user:")
        password = input("pasword:")
        if username == account["username"] and password == account["password"]:
            print("welcome login....")
            account["is_authenticated"] = True
        else:
            print("wrong username or password!")
    if account["is_authenticated"] is True:  # 主要改了这
        func() # 认证成功了就执行传入进来的函数
def home():
    print("---首页----")
def america():
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
def henan():
    print("----河南专区----")
home()
login(america) # 需要验证就调用 login，把需要验证的功能 当做一个参数传给login
login(henan)
```

你很开心，终于实现了老板的要求，不改变原功能代码的前提下，给功能加上了验证，此时，媳妇回来了，后面还跟着老王，你两家关系 非常 好，老王经常来串门，老王也是码农，你跟他分享了你写的代码，兴奋的等他看完 夸奖你NB,没成想，老王看后，并没有夸你，抱起你的儿子，笑笑说，你这个代码还是改改吧， 要不然会被开除的，WHAT? 会开除，明明实现了功能 呀， 老王讲，没错，你功能 是实现了，但是你又犯了一个大忌，什么大忌？ 你改变了调用方式呀， 想一想，现在没每个需要认证的模块，都必须调用你的login()方法，并把自己的函数名传给你，人家之前可不是这么调用 的， 试想，如果 有100个模块需要认证，那这100个模块都得更改调用方式，这么多模块肯定不止是一个人写的，让每个人再去修改调用方式 才能加上认证，你会被骂死的。。。。 你觉得老王说的对，但问题是，如何即不改变原功能代码，又不改变原有调用方式，还能加上认证呢？ 你苦思了一会，还是想不出，老王在逗你的儿子玩，你说，老王呀，快给我点思路 ，实在想不出来，老王背对着你问，

老王：学过匿名函数没有？

你：学过学过，就是lambda嘛

老王：那lambda与正常函数的区别是什么？

你：最直接的区别是，正常函数定义时需要写名字，但lambda不需要

老王：没错，那lambda定好后，为了多次调用 ，可否也给它命个名？

你：可以呀，可以写成plus = lambda x:x+1类似这样，以后再调用plus就可以了，但这样不就失去了lambda的意义了，明明人家叫匿名函数呀，你起了名字有什么用呢？

老王：我不是要跟你讨论它的意义 ，我想通过这个让你明白一个事实

老王边说着，边拿起你儿子的画板，在上面写了以下代码：

```plain
def plus(n):
    return n+1
plus2 = lambda x:x+1
```

老王： 上面这两种写法是不是代表 同样的意思？

你：是的

老王：我给lambda x:x+1 起了个名字叫plus2，是不是相当于def plus2(x) ?

你：我擦，你别说，还真是，但老王呀，你想说明什么呢？

老王： 没啥，只想告诉你，给函数赋值变量名就像def func_name　是一样的效果，如下面的plus(n)函数，你调用时可以用plus名，还可以再起个其它名字，如

```plain
calc = plus
calc(n)
```

你明白我想传达什么意思了么？ 你：。。。。。。。。。。。这。。。。。。嗯 。。。。。不太。。。。明白 。。

老王：。。。。这。。。。。呵呵。。。。。。好吧。。。。，那我在给你点一下，你之前写的下面这段调用 认证的代码

```plain
home()
login(america) #需要验证就调用 login，把需要验证的功能 当做一个参数传给login
# home()
# america()
login(henan)
```

老王：你之所以改变了调用方式，是因为用户每次调用时需要执行login(henan)，类似的。其实稍一改就可以了呀

```plain
home()
america = login(america)
henan = login(henan)
```

老王：这样以后其它人调用henan时，其实相当于调用了login(henan), 通过login里的验证后，就会自动调用henan功能。

你：我擦，还真是唉。。。，老王，还是你nb。。。不过，等等， 我这样写了好，那用户调用时，应该是下面这个样子

```plain
home()
america = login(america) #你在这里相当于把america这个函数替换了
henan = login(henan)
#那用户调用时依然写
america()
```

但问题在于，还不等用户调用 ，你的america = login(america)就会先自己把america执行了呀。。。。，你应该等我用户调用 的时候 再执行才对呀，不信我试给你看。。。

老王：哈哈，你说的没错，这样搞会出现这个问题，但你想想有没有解决办法 呢？

你：我擦，你指的思路呀，大哥。。。我哪知道下一步怎么走。。。

老王：算了，估计你也想不出来。。。 学过嵌套函数没有？

你：yes,然后呢？

老王：想实现一开始你写的america = login(america)不触发你真正的america函数的执行，只需要在这个login里面再定义一层函数，第一次调用america = login(america)只调用到外层login，这个login虽然会执行，但不会触发认证了，因为认证的所有代码被封装在login里层的新定义 的函数里了，login只返回 里层函数的函数名，这样下次再执行america()时， 就会调用里层函数啦。。。

你：。。。。。。什么？ 什么个意思，我蒙逼了。。。

老王：还是给你看代码吧。。

```plain
account = {
    "is_authenticated":False,# 用户登录了就把这个改成True
    "username":"alex", # 假装这是DB里存的用户信息
    "password":"abc123" # 假装这是DB里存的用户信息
}
def login(func):
    def inner(): # 再定义一层函数
        if account["is_authenticated"] is False:
            username = input("user:")
            password = input("pasword:")
            if username == account["username"] and password == account["password"]:
                print("welcome login....")
                account["is_authenticated"] = True
            else:
                print("wrong username or password!")
        if account["is_authenticated"] is True:
            func()
    return inner  # 注意这里只返回inner的内存地址，不执行
def home():
    print("---首页----")
def america():
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
def henan():
    print("----河南专区----")
home()
america = login(america) # 这次执行login返回的是inner的内存地址 .inner at 0x101762840>
henan = login(henan)  # .inner at 0x102562840>
america()  # 相当于执行inner()
henan()
```

此时你仔细着了老王写的代码　，感觉老王真不是一般人呀，连这种奇淫巧技都能想出来。。。，心中默默感谢上天赐你一个大牛邻居。

你: 老王呀，你这个姿势很nb呀，你独创的？ 此时你媳妇噗嗤的笑出声来，你也不知道 她笑个球。。。

老王：呵呵， 这不是我独创的呀当然 ，这是开发中一个常用的玩法，叫语法糖，官方名称“装饰器”，其实上面的写法，还可以更简单 可以把下面代码去掉

```plain
america = login(america) # 这次执行login返回的是inner的内存地址
henan = login(henan)  # .inner at 0x102562840>
```

只在你要装饰的函数上面加上下面代码

```plain
@login
def america():
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
@login
def henan():
    print("----河南专区----")
```

效果是一样的。

你开心的玩着老王教你的新姿势 ，玩着玩着就手贱给你的“河南专区”版块 加了个参数，然后，结果 出错了。。

<!-- OCR_START -->
- 25
- 26
- def home():
- 27
- print("
- 28
- 29
- 30
- @login
- 31
- def america():
- 32
- -欧美专区---
- 33
- 34
- def japan():
- 35
- 一日韩专区----"）
- 36
- 37
- 38
- 39
- def henan(vip_level):
- 40
- if vip_level < 3:
- 41
- 河南专区普通会员--
- 42
- else:
- 43
- print（"欢迎来到尊贵河南口音RMB玩家私密社区".center(50,"-"））
- 44
- print（"再充值500就可以获取演员微信号，幸福大门即将开启".center(50,"")）
- 45
- 46
- 白#home()
- 47
- # america= login(america）# 这次执行login返回的是inner的内存地址 <function login.<locals>.inner at 0x101762840>
- 48
- # henan = login(henan)
- #<functionlogin.<locals>.inner at0x102562840>
- 49
- 50
- 51
- america()
- #相当于执行inner（）
- 52
- henan(5)
- 53
- Run:
- 装饰器3
- /Users/alex/PycharmProjects/apeland_py_learn/venv/bin/python /Users/alex/PycharmProjects/apeland_py_learn/day3_
- user:alex
- pasword:abc123
- Traceback(most recent call last):
- File "/Users/alex/PycharmProjects/apeland py learn/day3 函数编程/装饰器3.py"，line 50, in <module>
- TypeError:inner()_takes0positionalargumentsbut1wasgiven
- welcome login....
- Process finished with exit code 1
<!-- OCR_END -->

你：老王，老王，怎么传个参数就不行了呢？

老王：那必然呀，你调用henan时，其实是相当于调用的login，你的henan第一次调用时henan = login(henan)， login就返回了inner的内存地址，第2次用户自己调用henan(5),实际上相当于调用的是inner,但你的inner定义时并没有设置参数，但你给他传了个参数，所以自然就报错了呀

你：但是我的 版块需要传参数呀，你不让我传不行呀。。。

老王：没说不让你传，稍做改动便可。。

<!-- OCR_START -->
- 层函数
- 调用时传到对应的版块

```text
def login(func) :
加个arg1参数
def inner(argl):
if account ["is_authenticated"] is False:
username = input("user:")
password = input("pasword:")
if username == account["username"] and password == account["password"]:
print("welcome login....")
account["is_authenticated"] = True
else:
print("wrong username or password!")
if
It["is_authenticated"] is True:
func(arg1)
return inner
·#注意这里只返回inner的内存地址，不执行
def home():.. :
```
<!-- OCR_END -->

老王：你再试试就好了 。

你： 果然好使，大神就是大神呀。 。。 不过，如果有多个参数呢？

老王：。。。。老弟，你不要什么都让我教你吧，非固定参数你没学过么？\_args,\*\_kwargs…

你：噢 。。。还能这么搞?,nb,我再试试。 你身陷这种新玩法中无法自拔，竟没注意到老王已经离开，你媳妇告诉你说为了不打扰你加班，今晚带孩子去跟她姐妹住 ，你觉得媳妇真体贴，最终，你终于搞定了所有需求，完全遵循开放-封闭原则，最终代码如下。

```plain
account = {
    "is_authenticated":False,# 用户登录了就把这个改成True
    "username":"alex", # 假装这是DB里存的用户信息
    "password":"abc123" # 假装这是DB里存的用户信息
}
def login(func):
    def inner(*args,**kwargs): # 再定义一层函数
        if account["is_authenticated"] is False:
            username = input("user:")
            password = input("pasword:")
            if username == account["username"] and password == account["password"]:
                print("welcome login....")
                account["is_authenticated"] = True
            else:
                print("wrong username or password!")
        if account["is_authenticated"] is True:
            func(*args,**kwargs)
    return inner  # 注意这里只返回inner的内存地址，不执行
def home():
    print("---首页----")
@login
def america():
    print("----欧美专区----")
def japan():
    print("----日韩专区----")
@login
def henan(vip_level):
    if vip_level < 3:
        print("----河南专区普通会员----")
    else:
        print("欢迎来到尊贵河南口音RMB玩家私密社区".center(50,"-"))
        print("再充值500就可以获取演员微信号，幸福大门即将开启".center(50," "))
# home()
# america = login(america) # 这次执行login返回的是inner的内存地址 .inner at 0x101762840>
# henan = login(henan)  # .inner at 0x102562840>
america()  # 相当于执行inner()
henan(5)
```

此时，你已累的不行了，洗洗就抓紧睡了，半夜，上厕所，隐隐听到隔壁老王家有微弱的女人的声音传来，你会心一笑，老王这家伙，不声不响找了女朋友也不带给我看看，改天一定要见下真人。。。。。你本想着给媳妇打个电话问问她到了闺蜜家没有，想着想着竟然睡着了。。。

翌日，你精神抖擞到了公司，把代码扔给leader, leader看完后，会心一笑，小伙子不错，这才是专业的写法嘛。

# 3.12 列表生成式

现在有个需求，现有列表a=`[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]`,要求你把列表里的每个值加1，你怎么实现？你可能会想到2种方式

**二逼青年版**

生成一个新列表b，遍历列表a,把每个值加1后存在b里，最后再把a=b, 这样二逼的原因不言而喻，生成了新列表，浪费了内存空间。

```plain
>>> a
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> b = []
>>> for i in a:b.append(i+1)
... 
>>> b
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
>>> a = b
>>> a
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

**普通青年版**

毫无新意

```plain
a = [1,3,4,6,7,7,8,9,11]
for index,i in enumerate(a):
    a[index] +=1
print(a)
```

**略屌青年版**

```plain
>>> a
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
>>> a = map(lambda x:x+1, a)
>>> a
>>> for i in a:print(i)
... 
3
5
7
9
11
```

**装逼青年版**

```plain
>>> a = [i+1 for i in range(10)]
>>> a
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

这样的写法就叫做\*\*列表生成式，\*\*有什么用呢？装逼用，哈哈，写出来显的高级，效果跟上面的都一样哈。

# 3.13 生成器

## 生成器generator

通过列表生成式，我们可以直接创建一个列表。但是，受到内存限制，列表容量肯定是有限的。而且，创建一个包含100万个元素的列表，不仅占用很大的存储空间，如果我们仅仅需要访问前面几个元素，那后面绝大多数元素占用的空间都白白浪费了。比如我要循环100万次，按py的语法，for i in range(1000000)会先生成100万个值的列表。但是循环到第50次时，我就不想继续了，就退出了。但是90多万的列表元素就白为你提前生成了。

```plain
for i in range(1000000):
    if i == 50: 
        break
    print(i)
```

所以，如果列表元素可以按照某种算法推算出来，那我们是否可以在循环的过程中不断推算出后续的元素呢？

像上面这个循环，每次循环只是+1而已，我们完全可以写一个算法，让他执行一次就自动+1，这样就不必创建完整的list，从而节省大量的空间。**在Python中，这种一边循环一边计算后面元素的机制，称为生成器：generator。**

要创建一个generator，有很多种方法。第一种方法很简单，只要把一个列表生成式的`[]`改成`()，`就创建了一个generator：

```plain
>>> [x * x for x in range(10)]
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
>>> 
>>> (x * x for x in range(10))
 at 0x101ebc3b8>
```

(x\*x for x in range(10)）生成的就是一个生成器。

我们可以直接打印出list的每一个元素，但我们怎么打印出generator的每一个元素呢？

如果要一个一个打印出来，可以通过`next()`函数获得generator的下一个返回值：

```plain
>>> g = (x * x for x in range(10))
>>> next(g)
0
>>> next(g)
1
>>> next(g)
4
>>> next(g)
9
>>> next(g)
16
>>> next(g)
25
>>> next(g)
36
>>> next(g)
49
>>> next(g)
64
>>> next(g)
81
>>> next(g)
Traceback (most recent call last):
  File "", line 1, in 
StopIteration
```

我们讲过，generator保存的是算法，每次调用`next(g)`就计算出`g`的下一个元素的值，直到计算到最后一个元素，没有更多的元素时，抛出`StopIteration`的错误。

当然，上面这种不断调用`next(g)`实在是太变态了，正确的方法是使用`for`循环，因为generator也是可迭代(遍历)对象：

```plain
>>> g = (x * x for x in range(10))
>>> for n in g:
...     print(n)
...
0
1
4
9
16
25
36
49
64
81
```

通过for循环来迭代它，就不需要关心StopIteration的错误了。

### 函数生成器

generator非常强大。如果推算的算法比较复杂，用类似列表生成式的for循环无法实现的时候，还可以用函数来实现。

比如，著名的斐波拉契数列（Fibonacci），除第一个和第二个数外，任意一个数都可由前两个数相加得到：

1, 1, 2, 3, 5, 8, 13, 21, 34, …

实现100以内的斐波那契数代码：

```plain
a,b = 0,1
n = 0  # 斐波那契数
while n < 100:
    n = a + b
    a = b # 把b的旧值给到a
    b = n # 新的b = a + b(旧b的值)
    print(n)
```

改成函数也可以的

```plain
def fib(max):
    a,b = 0,1
    n = 0  # 斐波那契数
    while n < max:
        n = a + b
        a = b # 把b的旧值给到a
        b = n # 新的b = a + b(旧b的值)
        print(n)
fib(100)
```

输出 ：

1

2

3

5

8

13

21

34

55

89

144

仔细观察，可以看出，`fib`函数实际上是定义了斐波拉契数列的推算规则，可以从第一个元素开始，推算出后续任意的元素，这种逻辑其实非常类似generator。

**也就是说，上面的函数和generator仅一步之遥。要把**`**fib**`**函数变成generator，只需要把**`**print(b)**`**改为**`**yield b**`**就可以了：**

```plain
def fib(max):
    a,b = 0,1
    n = 0  # 斐波那契数
    while n < max:
        n = a + b
        a = b # 把b的旧值给到a
        b = n # 新的b = a + b(旧b的值)
        #print(n)
        yield n # 程序走到这，就会暂停下来，返回n到函数外面，直到被next方法调用时唤醒
f = fib(100) # 注意这句调用时，函数并不会执行，只有下一次调用next时，函数才会真正执行
print(f)
print(f.__next__())
print(f.__next__())
print(f.__next__())
print(f.__next__())
```

输出

```plain
1
2
3
5
```

这就是定义generator的另一种方法。如果一个函数定义中包含`yield`关键字，那么这个函数就不再是一个普通函数，而是一个generator：

这里，最难理解的就是generator和函数的执行流程不一样。函数是顺序执行，遇到return语句或者最后一行函数语句就返回。**而变成generator的函数，在每次调用next()的时候执行，遇到yield语句暂停并返回数据到函数外，再次被next()调用时从上次返回的yield语句处继续执行**。

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 排名 |
| --- | --- | --- | --- |
| () | print（"干点别的事"） | print(f.__next__()) | print(f.__next__()) |
| 斐波那契 | /Users/alex/PycharmProjects/apeland_py_learn | <generator object fibat 0x101f593b8> | 1 |
| 2 | 干点别的事 | 3 | 5 |
<!-- OCR_END -->

`在上面fib`的例子，我们在循环过程中不断调用`yield`，函数就会不断的中断(暂停)。当然要给循环设置一个条件来退出循环，不然就会产生一个无限数列出来。同样的，把函数改成generator后，我们基本上从来不会用`next()`来获取下一个返回值，而是直接使用`for`循环来迭代：

```plain
f = fib(100) # 注意这句调用时，函数并不会执行，只有下一次调用next时，函数才会真正执行
for i in f:
    print(i)
#输出：
1
2
3
...
...
55
89
144
```

### 并发编程

虽然我们还没学并发编程，但我们肯定听过cpu 多少核多少核之类的，cpu的多核就是为了可以实现并行运算，让你同时边听歌、边聊qq、边刷知乎。单核的cpu同一时间只能干一个事，所以你用单核电脑同时做好几件事的话，就会变的很慢，因为cpu要在不同程序任务间来回切换。

通过yield, 我们可以实现单核下并发做多件事的效果。

```plain
import time
def consumer(name):
    print("%s 准备吃包子啦!" %name)
    while True:
       baozi = yield  # yield可以接收到外部send传过来的数据并赋值给baozi
       print("包子[%s]来了,被[%s]吃了!" %(baozi,name))
c = consumer('A')
c2 = consumer('B')
c.__next__() # 执行一下next可以使上面的函数走到yield那句。 这样后面的send语法才能生效
c2.__next__()
print("----老子开始准备做包子啦!----")
for i in range(10):
    time.sleep(1)
    print("做了2个包子!")
    c.send(i)  # send的作用=next, 同时还把数据传给了上面函数里的yield
    c2.send(i)
```

**注意：调用send(x)给生成器传值时，必须确保生成器已经执行过一次next**()调用, 这样会让程序走到yield位置等待外部第2次调用。

# 3.14 迭代器

我们已经知道，可以直接作用于`for`循环的数据类型有以下几种：

1. 一类是集合数据类型，如`list`、`tuple`、`dict`、`set`、`str`等；
2. 一类是`generator`，包括生成器和带`yield`的generator function。

这些可以直接作用于`for`循环的对象统称为**可迭代对象：**`Iterable，可迭代的意思就是可遍历、可循环`**。**

可以使用`isinstance()`判断一个对象是否是`Iterable`对象：

```plain
>>> from collections import Iterable
>>> isinstance([], Iterable)
True
>>> isinstance({}, Iterable)
True
>>> isinstance('abc', Iterable)
True
>>> isinstance((x for x in range(10)), Iterable)
True
>>> isinstance(100, Iterable)
False
```

而生成器不但可以作用于for循环，还可以被next()函数不断调用并返回下一个值，直到最后抛出StopIteration错误表示无法继续返回下一个值了。

*\***可以被next()函数调用并不断返回下一个值的对象称为迭代器：Iterator。***

可以使用isinstance()判断一个对象是否是Iterator对象：

```plain
>>> from collections import Iterator
>>> isinstance([], Iterator)
True
>>> isinstance({}, Iterator)
True
>>> isinstance('abc', Iterator)
True
>>> isinstance((x for x in range(10)), Iterator)
True
>>> isinstance(100, Iterator)
False
```

生成器都是`Iterator`对象，但`list`、`dict`、`str`虽然是`Iterable`，却不是`Iterator`。

把`list`、`dict`、`str`等`Iterable`变成`Iterator`可以使用`iter()`函数：

```plain
>>> isinstance(iter([]), Iterator)
True
>>> isinstance(iter('abc'), Iterator)
True
```

你可能会问，为什么`list`、`dict`、`str`等数据类型不是`Iterator`？

这是因为Python的`Iterator`对象表示的是一个数据流，Iterator对象可以被`next()`函数调用并不断返回下一个数据，直到没有数据时抛出`StopIteration`错误。可以把这个数据流看做是一个有序序列，但我们却不能提前知道序列的长度，只能不断通过`next()`函数实现按需计算下一个数据，所以`Iterator`的计算是惰性的，只有在需要返回下一个数据时它才会计算。

`Iterator`甚至可以表示一个无限大的数据流，例如全体自然数。而使用list是永远不可能存储全体自然数的。

**小结**

凡是可作用于`for`循环的对象都是`Iterable`类型；

凡是可作用于`next()`函数的对象都是`Iterator`类型，它们表示一个惰性计算的序列；

集合数据类型如`list`、`dict`、`str`等是`Iterable`但不是`Iterator`，不过可以通过`iter()`函数获得一个`Iterator`对象。

# 3.15 练习题&作业

## 练习题

1. 写函数，计算传入数字参数的和。（动态传参）
2. 写函数，用户传入修改的文件名，与要修改的内容，执行函数，完成整个文件的批量修改操作
3. 写函数，检查用户传入的对象（字符串、列表、元组）的每一个元素是否含有空内容。
4. 写函数，检查传入字典的每一个value的长度,如果大于2，那么仅保留前两个长度的内容（对value的值进行截断），并将新内容返回给调用者，注意传入的数据可以是字符、list、dict
5. 解释闭包的概念
6. 写函数，返回一个扑克牌列表，里面有52项，每一项是一个元组

```plain
例如：\[\(‘红心’，2\),\(‘草花’，2\), …\(‘黑桃A’\)\]
```

1. 7.写函数，传入n个数，返回字典{‘max’:最大值,’min’:最小值}

```plain
例如:minmax(2,5,7,8,4)
返回:{‘max’:8,’min’:2}
```

```plain
8._写函数，专门计算图形的面积_
```

* *其中嵌套函数，计算圆的面积，正方形的面积和长方形的面积*
* *调用函数area(‘圆形’,圆半径) 返回圆的面积*
* *调用函数area(‘正方形’,边长) 返回正方形的面积*
* *调用函数area(‘长方形’,长，宽) 返回长方形的面积*

***

```plain
#代码模板
  def area():
      def 计算长方形面积():
          pass
      def 计算正方形面积():
          pass
      def 计算圆形面积():
          pass
```

```plain
9._写函数，传入一个参数n，返回n的阶乘_
```

```plain
例如:cal(7)
计算7654321
```

10.编写装饰器，为多个函数加上认证的功能（用户的账号密码来源于文件），要求登录成功一次，后续的函数都无需再输入用户名和密码

11.生成器和迭代器的区别？

12 生成器有几种方式获取value？

13.*通过生成器写一个日志调用方法， 支持以下功能*

* *根据指令向屏幕输出日志*
* *根据指令向文件输出日志*
* *根据指令同时向文件&屏幕输出日志*

*以上日志格式如下*

```plain
2017-10-19 22:07:38 [1] test log db backup 3
2017-10-19 22:07:40 [2]    user alex login success
#注意：其中[1],[2]是指自日志方法第几次调用，每调用一次输出一条日志
```

* *代码结构如下*

```plain
def logger(filename,channel=’file’):
    “””
    日志方法
    :param filename: log filename
    :param channel: 输出的目的地，屏幕(terminal)，文件(file)，屏幕+文件(both)
    :return:
    “””
    …your code…
 #调用
 logobj = logger(filename=”web.log”,channel=’both’)
 log_obj.__next()
 log_obj.send(‘user alex login success’)
```

14.用map来处理字符串列表,把列表中所有人都变成sb,比方alex_sb

```plain
name=[‘alex’,’wupeiqi’,’yuanhao’,’nezha’]
```

15.用filter函数处理数字列表，将列表中所有的偶数筛选出来

```plain
num = [1,3,5,6,7,8]
```

16.如下，每个小字典的name对应股票名字，shares对应多少股，price对应股票的价格

```plain
portfolio = [
    {‘name’: ‘IBM’, ‘shares’: 100, ‘price’: 91.1},
    {‘name’: ‘AAPL’, ‘shares’: 50, ‘price’: 543.22},
    {‘name’: ‘FB’, ‘shares’: 200, ‘price’: 21.09},
    {‘name’: ‘HPQ’, ‘shares’: 35, ‘price’: 31.75},
    {‘name’: ‘YHOO’, ‘shares’: 45, ‘price’: 16.35},
    {‘name’: ‘ACME’, ‘shares’: 75, ‘price’: 115.65}
]
```

* 通过哪个内置函数可以计算购买每支股票的总价
* 用filter过滤出，单价大于100的股票有哪些

17.有列表 li = \[‘alex’, ‘egon’, ‘smith’, ‘pizza’, ‘alen’], 请将以字母“a”开头的元素的首字母改为大写字母；

18.有列表 li = \[‘alex’, ‘egon’, ‘smith’, ‘pizza’, ‘alen’], 请以列表中每个元素的第二个字母倒序排序；

19.有名为`poetry.txt`的文件，其内容如下，请删除第三行；

```plain
昔人已乘黄鹤去，此地空余黄鹤楼。
   黄鹤一去不复返，白云千载空悠悠。
   晴川历历汉阳树，芳草萋萋鹦鹉洲。
   日暮乡关何处是？烟波江上使人愁。
```

20.有名为`username.txt`的文件，其内容格式如下，写一个程序，判断该文件中是否存在”alex”, 如果没有，则将字符串”alex”添加到该文件末尾，否则提示用户该用户已存在；

```plain
pizza
  alex
  egon
```

21.有名为user_info.txt的文件，其内容格式如下，写一个程序，删除id为100003的行；

```plain
pizza,100001
  alex, 100002
  egon, 100003
```

22.有名为user_info.txt的文件，其内容格式如下，写一个程序，将id为100002的用户名修改为`alex li`；

```plain
pizza,100001
 alex, 100002
 egon, 100003
```

23.写一个计算每个程序执行时间的装饰器；

24.lambda是什么？请说说你曾在什么场景下使用lambda？

25.题目：写一个摇骰子游戏，要求用户压大小，赔率一赔一。要求：三个骰子，每个骰子的值从1-6，摇大小，每次打印摇出来3个骰子的值。

## 作业

一些关键练习题的参考答案

#### 递归二分查找

```plain
a = [1,3,4,6,7,8,9,11,15,17,19,21,22,25,29,33,38,69,107]
def binary_search(start,end,n,d_list):
    """
    每次把列表规模折半，查找一个数据最多只需要2的n次方 < len(d_list),是2的多少次方，就是最多查多少次。
    假如列表长度为200，那最多只需查询8次(2**8次方）
    :param start: 查找的起始位置 
    :param end: 查找的结束位置 
    :param n: 要查找的值
    :param d_list: 要找的列表
    :return: 
    """
    if start < end: # 查找的范围[start:end]依然大于0个
        mid = (start + end)//2  # 找到中间位置
        if d_list[mid] > n:  # 如果中间的这个值比要找的n大，代表要往d_list[mid]左边找
            print("go left",start,mid,end,"--",d_list[start],d_list[mid],d_list[end-1])
            binary_search(start,mid,n,d_list)
        elif d_list[mid] < n :  # 要往右边找，继续折半
            print("go right..",start,mid,end,"--",d_list[start],d_list[mid],d_list[end-1])
            binary_search(mid+1,end,n,d_list)
        else:  # 找到了
            print("find:",d_list[mid],mid)
    else:  # 假设start=9,end=9, 那d_list[9:9]已经取不到值了，在这种情况下，只能说明，要找的这个值不在这个列表里
        print("cannot find %s in this data list" % n)
binary_search(0, len(a), 22, a)
```

> 更新: 2021-08-30 23:38:38  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/pkvnz7>