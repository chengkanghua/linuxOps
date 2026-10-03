# Python-基础03-流程控制

## Python-基础03-流程控制

2019-04-24 分类：[Linux](https://www.driverzeng.com/zenglaoshi/category/linux), [Python](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80/python), [脚本语言](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80) 阅读(47) 评论(0)

* [流程控制之if..else](https://www.driverzeng.com/zenglaoshi/1300.html#toc_0)
* [流程控制while循环](https://www.driverzeng.com/zenglaoshi/1300.html#toc_1)
* [流程控制for循环](https://www.driverzeng.com/zenglaoshi/1300.html#toc_2)

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

## 流程控制之if..else

既然我们编程的目的是为了控制计算机能够像人脑一样工作，那么人脑能做什么，就需要程序中有相应的机制去模拟。人脑无非是数学运算和逻辑运算，对于数学运算在上一节我们已经说过了。对于逻辑运算，即人根据外部条件的变化而做出不同的反映。

***

| if判断 |
| :--- |

1.语法

```plain
if 条件:
    代码1
    代码2
    代码3
    ...
```

如果面前飘过一个生物，是否要上去表白？

```plain
#语法1
cls='human'
sex='female'
age=18
if cls == 'human' and sex == 'female' and age > 16 and age < 22:
    print('开始表白')
print('end...')
```

<!-- OCR_START -->
| 排名 | untitled1 | untitled1 | untitled1 | untitled1 | untitled1 |
| --- | --- | --- | --- | --- | --- |
| 297 | cls='human' | venv | 298 | sex='fema le' | bin |
| 299 | include | age=18 | lib | 300 | 三pyvenv.cfg |
| 301 | if clshumanandsexfemaleandage16andage<22: | 01与用户交互.py | 302 | print（开始表白） | 基础.py |
| 303 | Illi External Libraries | 304 | print('end...) | Scratches and Consoles | 305 |
| 306 | 307 | 308 | 309 | 310 | 311 |
| Run: | 变量 | 个 | 开始表白 | end... | 训 |
<!-- OCR_END -->

￼

```plain
if 条件:
    代码1
    代码2
    代码3
    ...
else
    代码1
    代码2
    代码3
    ...
```

```plain
#语法2
cls='human'
sex='female'
age=38
if cls == 'human' and sex == 'female' and age > 16 and age < 22:
    print('开始表白')
else:
    print('阿姨好')
print('end...')
```

<!-- OCR_START -->
| 排名 | 名称 | 名称 | 名称 | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| untitled1 | 基础.py | Project | 基础.py | 01与用户交互.py | untitled1~/PycharmProjects/untitled1 |
| 297 | cls='human' | venv | 298 | sex='female' | bin |
| 299 | include | age=38 | Mlib | 300 | 三pyvenv.cfg |
| 301 | ifcls=humanandsex=femaleandage>16andage<22: | 01与用户交互.py | 302 | print（开始表白） | 基础.py |
| 303 | else: | I External Libraries | 304 | print（阿姨好'） | ScratchesandConsoles |
| 305 | 306 | print('end...') | 307 | 308 | 309 |
| 310 | 311 | Run: | 变量 | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/基础·py | 阿姨好 |
<!-- OCR_END -->

￼

```plain
if 条件1:
    代码1
    代码2
    代码3
    ...
elif 条件2:
    代码1
    代码2
    代码3
    ...
elif 条件3:
    代码1
    代码2
    代码3
    ...
else:
    代码1
    代码2
    代码3
    ...
```

```plain
#语法3
cls='human'
sex='female'
age=60
if cls == 'human' and sex == 'female' and age > 16 and age < 22:
    print('开始表白')
elif age > 22 and age < 38:
    print('阿姨好')
else:
    print('大妈好')
print('end...')
```

<!-- OCR_START -->
- untitled1
- 基础.py
- Project
- 01与用户交互.py
- untitled1 ~/PycharmProjects/untitled1
- 297
- cls='human'
- venv
- 298
- sex='fema le'
- bin
- include
- 299
- age=60
- lib
- 300
- 三pyvenv.cfg
- 301
- ifclshumanandsexfemaleandage16andage<22:
- 302
- print（开始表白）
- 303
- elif aae >22and age<38:
- lliExternal Libraries
- 304
- print（阿姨好'）
- Scratches and Consoles
- 305
- else:
- 306
- print（大妈好）
- 307
- 308
- print('end...')
- 309
- 310
- 311
- Run:
- 变量
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/基础.py
- 大妈好
- end...
- Process
- finished with exit code0
<!-- OCR_END -->

￼

**小练习**

> 接收用户输入的成绩,
>
> 如果：成绩>=90，那么：优秀
>
> 如果成绩>=80且<90,那么：良好
>
> 如果成绩>=70且<80,那么：普通
>
> 其他情况：很差

***

> 登录功能
>
> 接收用户的登录信息，判断用户是否可以登录

***

| if的嵌套 |
| :--- |

```plain
cls='human'
sex='female'
age=60
if cls == 'human' and sex == 'female' and age > 16 and age < 22:
    print('开始表白')
elif age > 22 and age < 38:
    print('阿姨好')
else:
    print('大妈好')
print('end...')
```

那如果表白成功了呢？表白不成功呢？

```plain
cls='human'
sex='female'
age=18
is_success=False
if cls == 'human' and sex == 'female' and age > 16 and age < 22:
    print('开始表白')
    if is_success:
        print('在一起')
    else:
        print('逗你玩...')
elif age > 22 and age < 38:
    print('阿姨好')
else:
    print('大妈好')
print('end...')
开始表白
逗你玩...
end...
```

<!-- OCR_START -->
| untitled1 | 排名 | untitled1 | untitled1 | untitled1 | untitled1 |
| --- | --- | --- | --- | --- | --- |
| 基础.py | Project | 基础.py | 01与用户交互.pyx | untitled1~/PycharmProjects/untitled1 | 295 |
| venv | 296 | bin | 297 | cls='human' | include |
| 298 | sex='female' | lib | 299 | age=18 | 三pyvenv.cfg |
| 01与用户交互.py | 300 | is_success=False | 基础.py | 301 | if |
| cls=humanandsex==femaleandage16andage<22: | llli External Libraries | 302 | print（开始表白） | Scratches and Consoles | 303 |
| if is_success: | 304 | print（在一起） | 305 | else: | 306 |
| print（逗你玩...） | 307 | elifage22andagew<38: | 308 | print（阿姨好） | 309 |
| else: | 310 | print（大妈好） | 311 | 312 | print('end...') |
| 313 | 314 | else | Run: | 变量X | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/基础.py |
<!-- OCR_END -->

￼

**小练习**

接收用户输入的信息：

如果:今天是Monday,那么:上班

如果:今天是Tuesday,那么:上班

如果:今天是Wednesday,那么:上班

如果:今天是Thursday,那么:上班

如果:今天是Friday,那么:上班

如果:今天是Saturday,那么:出去浪

如果:今天是Sunday,那么:出去浪

```plain
#方式一
today=input('>>: ')
if today == 'Monday':
    print('上班')
elif today == 'Tuesday':
    print('上班')
elif today == 'Wednesday':
    print('上班')
elif today == 'Thursday':
    print('上班')
elif today == 'Friday':
    print('上班')
elif today == 'Saturday':
    print('出去浪')
elif today == 'Sunday':
    print('出去浪')
else:
    print('''必须输入其中一种:
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
    Sunday
    ''')
#方式二：
today=input('>>: ')
if today == 'Monday' or today == 'Tuesday' or today == 'Wednesday' or today == 'Thursday' or today == 'Friday':
    print('上班')
elif today == 'Saturday' or today == 'Sunday':
    print('出去浪')
else:
    print('''必须输入其中一种:
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
    Sunday
    ''')
#方式三：
today=input('>>: ')
if today in ['Saturday','Sunday']:
    print('出去浪')
elif today in ['Monday','Tuesday','Wednesday','Thursday','Friday']:
    print('上班')
else:
    print('''必须输入其中一种:
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
    Sunday
    ''')
```

## 流程控制while循环

***

| if的嵌套 |
| :--- |

思考一个问题，如果我们根据之前学的if语句，写一个猜数字的游戏。

```plain
age_of_oldboy = 48
guess = int(input(">>:"))
if guess > age_of_oldboy :
    print("猜的太大了，往小里试试...")
elif guess < age_of_oldboy :
    print("猜的太小了，往大里试试...")
else:
    print("恭喜你，猜对了...")
```

这么写的话，我们每一次猜错了，都需要重新执行，否则很麻烦，或者，难道我们需要把代码复制很多次吗？

即使是小白的你，也觉得的太low了是不是，以后要修改功能还得修改3次，因此记住，写重复的代码是程序员最不耻的行为。

那么如何做到不用写重复代码又能让程序重复一段代码多次呢？ 循环语句就派上用场啦。

while语法，while循环又称为条件循环。

```plain
while 条件:    
    # 循环体
    # 如果条件为真，那么循环体则执行，执行完毕后再次循环，重新判断条件。。。
    # 如果条件为假，那么循环体不执行,循环终止
```

```plain
while True:
    1+1
while True:
    guess = int(input(">>:"))
    if guess > age_of_oldboy :
        print("猜的太大了，往小里试试...")
    elif guess < age_of_oldboy :
        print("猜的太小了，往大里试试...")
    else:
        print("恭喜你，猜对了...")
```

***

| while的break |
| :--- |

break的用法？？？

```plain
while True:
    print('1')
    print('2')
    break
    print('3')
```

登录程序：

```plain
user_db = 'zls'
pwd_db = '123'
while True:
    inp_user=input('username>>>:')
    inp_password=input('password>>:')
    if inp_user == user_db and inp_password == pwd_db:
        print('login successful')
    else:
        print('user or password error')
```

如果写出以上程序，那么即便是你输入了正确的用户名和密码，也不会退出循环，所以我们会使用break跳出本次循环。

```plain
user_db='zls'
pwd_db='123'
while True:
    inp_user=input('username>>>:')
    inp_password=input('password>>:')
    if inp_user == user_db and inp_password == pwd_db:
        print('login successful')
        break
    else:
        print('user or password error')
print('其他代码')
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- untitled1 ~/PycharmProjects/untitled1
- 7
- 8
- #n=1
- 1
- 9
- bin
- 10
- # while n<=10:
- include
- 11
- if n==8:
- 12
- lib
- 13
- 14
- print(n)
- 三pyvenv.cfg
- 15
- 16
- 17
- 18
- user_db='zls
- lliExternal Libraries
- 19
- pwd_db='123'
- Scratches and Consoles
- 20
- 21
- while True:
- 22
- inp_user=input('username>>>:')
- 23
- inp_password=input('password>>:')
- 24
- if inp_user ==user_db and inp_password ==pwd_db:
- 25
- print('login successful')
- 26
- break
- 27
- else:
- 28
- print('user or password error')
- 29
- print（其他代码'）
- 30
- 31
- 32
- 33
- 34
- 35
- 36
- Run:
- 变量X
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- username>>>:zls
- password>>:123
- login successful
- 其他代码
- Processfinishedwith exitcodeO
<!-- OCR_END -->

￼

break的意思：终止掉当前层的循环，执行其他代码。

***

| while的continue |
| :--- |

```plain
n=1
while n<4:
    print(n)
    
n=1
while n<4:
    print(n)
    n+=1
#打印1-10
n=1
while n<=10:
    print(n)
    n+=1
    
#8不打印，如何使用continue？
n=1
while n<=10:
    if n == 8:
        continue
    print(n)
    n+=1
```

如果按照上面那样写，程序会一直处于死循环的状态，咱们可以通过画图来理解。

```plain
n=1
while n<=10:
    if n == 8:
        n+=1
        continue
    print(n)
    n+=1
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- a.pyx
- untitled1~/PycharmProjects/untitled1
- 8
- n=1
- 9
- 10
- while n<=10:
- bin
- 11
- if n ==8:
- include
- 12
- 13
- lib
- 14
- print(n)
- 15
- 三pyvenv.cfg
- 16
- 17
- 18
- 19
- Illi External Libraries
- 20
- Scratches and Consoles
- 21
- 22
- 23
- 24
- 25
- 26
- 27
- 28
- 29
- 30
- 31
- 32
- 33
- 34
- 35
- 36
- 37
- Run:
- 2变量
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- 1
- 2
- 3
- 4
- 5
- 6
- Process finished with exit code o
<!-- OCR_END -->

￼

ps：continue一定不要加到循环体最后一步执行的代码

思考：下面这段代码的continue有没有意义？

```plain
while True:
    if 条件1:
        code1
        code2
        code3
        continue
    elif 条件2:
        code1
        code2
        code3
        continue
    elif 条件3:
        code1
        code2
        code3
        continue
    else:
        code1
        code2
        code3
        continue
```

***

| while的嵌套 |
| :--- |

语法：

```plain
tag=True 
while tag:
    ......
　　 while tag:
　　　　  ........
　　　　　while tag:
　　　　　    tag=False
```

应用场景：和ATM机交互，我只需要输入用户名和密码么？输入用户名密码错误，会循环重新输入，那么如果我输入正确了就会跳出循环，那用户去取钱，输入完用户名和密码就没有其他操作了么？我不还得取钱么？难道说，我只是为了去ATM玩一下？那么我就需要其他的交互，其他的操作，其他操作我也需要判断有循环。

```plain
user_db = 'zls'
pwd_db = '123'
while True:
    inp_user=input('username>>>:')
    inp_password=input('password>>:')
    if inp_user == user_db and inp_password == pwd_db:
        print('login successful')
        while True:
            cmd = input('>>>>:')
            print('%s run.....' %cmd)
    else:
        print('user or password error')
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- 基础.pyX
- 01与用户交互.py
- Project
- a.pyx
- 65
- untitled1 ~/PycharmProjects/untitled1
- 66
- user db='zls
- 67
- pwd_db=123
- bin
- 68
- 69
- while True:
- include
- 70
- inp_user=input('username>>>:
- lib
- 71
- inp_password=input('password>>
- 72
- if inp_user ==user_db and inp_password ==pwd_db:
- 三pyvenv.cfg
- 73
- print('login successful')
- 74
- 75
- cmd =input('>>>>:')
- 基础.py
- 76
- print('%s run...
- %cmd)
- liExternal Libraries
- 77
- else:
- Scratches and Consoles
- 78
- print('user or password error')
- 79
- 80
- 81
- 82
- 83
- 84
- 85
- 86
- 87
- 88
- 89
- 90
- 91
- 92
- 93
- 94
- Run:
- 2变量X
- 2.a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- username>>>:zls
- password>>:123
- login successful
- :L5
- ls run.....
- :pwd
- pwd run....:
- vvv:cd
- cd run....
- P>>>:
<!-- OCR_END -->

￼

如果用户想要退出

```plain
user_db = 'zls'
pwd_db = '123'
while True:
    inp_user=input('username>>>:')
    inp_password=input('password>>:')
    if inp_user == user_db and inp_password == pwd_db:
        print('login successful')
        while True:
            cmd = input('>>>>:')
            if cmd == 'quit':
                break
            print('%s run.....' %cmd)
    else:
        print('user or password error')
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- untitled1 ~/PycharmProjects/untitled1
- 65
- 66
- user_db=zls'
- 67
- pwd_db=123
- bin
- 68
- include
- 69
- while True:
- 70
- inp_user=input('username>>>:')
- Mlib
- 71
- inp_password=input('password>>:')
- 72
- if inp_user == user_db and inp_password == pwd_db:
- 三pyvenv.cfg
- 73
- print('login successful')
- 74
- 75
- cmd = input('>>>>:)
- 76
- if cmd ==quit':
- iExternal Libraries
- 77
- break
- Scratches and Consoles
- 78
- print('%s run.....
- %cmd）
- 79
- else:
- 80
- print('user or password error')
- 81
- 82
- 83
- 84
- 85
- 86
- 87
- 88
- 89
- 90
- 91
- 92
- 93
- 94
- Run:
- 变量×
- 2.a(1）x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- username>>>:zls
- password>>:123
- login successful
- >>:ls
- ls run.....
- >>:pwd
- pwd run...
- >>:cd
- cd run.....
- >>:quit
- username>>>:
<!-- OCR_END -->

￼

用户想要退出，那证明是取完钱了，按照上面的写法，为什么还需要让用户输入用户名和密码？退出所有程序，应该怎么写？

```plain
user_db = 'zls'
pwd_db = '123'
while True:
    inp_user=input('username>>>:')
    inp_password=input('password>>:')
    if inp_user == user_db and inp_password == pwd_db:
        print('login successful')
        while True:
            cmd = input('>>>>:')
            if cmd == 'quit':
                break
            print('%s run.....' %cmd)
        break
    else:
        print('user or password error')
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- a.py x
- untitled1 ~/PycharmProjects/untitled1
- 65
- 66
- user db='zls'
- 67
- pwd_db=123
- 68
- include
- 69
- while True:
- lib
- 70
- inp_user=input('username>>>:')
- 71
- inp_password=input('password>>:')
- 72
- if inp_user == user_db and inp_password == pwd_db:
- 三pyvenv.cfg
- 73
- print('login successful')
- 74
- 75
- cmd = input('>>>>:')
- 76
- if cmd == 'quit':
- lli External Libraries
- 77
- break
- Scratches and Consoles
- 78
- print('%s run...*
- %cmd)
- 79
- 80
- else:
- 81
- print('user or password error')
- 82
- 83
- 84
- 85
- 86
- 87
- 88
- 89
- 90
- 91
- 92
- 93
- Run:
- 变量X
- a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- username>>>:zls
- password>>:123
- login successful
- :ls
- ls run.....
- :aaa
- aaa run.....
- :quit
- Process finished with exit code 0
<!-- OCR_END -->

￼

以上写法，非常的low，有一个while就要写一个break，那我需要知道，我有几个while

```plain
user_db = 'zls'
pwd_db = '123'
tag = True
while tag:
    inp_user=input('username>>>:')
    inp_password=input('password>>:')
    if inp_user == user_db and inp_password == pwd_db:
        print('login successful')
        while tag:
            cmd = input('>>>>:')
            if cmd == 'quit':
                tag=False
                break
            print('%s run.....' %cmd)
    else:
        print('user or password error')
```

<!-- OCR_START -->
- untitled1
- venv
- 2a.py
- 1Project
- 基础.py
- 01与用户交互.py
- a.py
- untitled1 ~/PycharmProjects/untitled1
- 65
- 66
- user db=zls
- 1
- 67
- pwd_db='123
- bin
- 68
- tag = True
- include
- 69
- lib
- 70
- 71
- while tag:
- 72
- inp_user=input('username>>>:')
- 三pyvenv.cfg
- 73
- inp_password=input('password>>:')
- 74
- if inp_user == user_db and inp_password == pwd_db:
- 75
- print('login successful')
- 76
- lliExternal Libraries
- 77
- cmd =input('>>>>:')
- Scratches and Consoles
- 78
- if cmd == 'quit':
- 79
- tag=False
- 80
- break
- 81
- print('%s run.....' %cmd)
- 82
- else:
- 83
- print('user or password error')
- 84
- 85
- 86
- 87
- 88
- 89
- 90
- 91
- 92
- 93
- 94
- Run:
- 2变量×
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- username>>>:zls
- password>>:123
- login successful
- :ls
- ls run.....
- :pwd
- pwd run.....
- :quit
- Process finished with exit code 0
<!-- OCR_END -->

￼

***

| while循环其他知识点 |
| :--- |

```plain
while True:
    1+1
```

这种死循环，会导致CPU大量工作。

有没有这样对CPU工作量大的需求？区块链：GPU

**while使用else**

else的代码会在while循环没有被break打断的情况下运行。

```plain
n=1
while n<5:
    print(n)
    n+=1
else:
    print('else子代码')
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- a.py X
- untitled1~/PycharmProjects/untitled1
- 86
- 白#eLse的代码会在while循环没有被break打断的情况下运行
- 87
- 88
- bin
- n=1
- 89
- while n<5:
- include
- 90
- print(n)
- lib
- 91
- 92
- else:
- 三pyvenv.cfg
- 93
- print（'else子代码'）
- 94
- 95
- 96
- lli External Libraries
- 97
- 98
- Scratches and Consoles
- 99
- 100
- 101
- 102
- 103
- 104
- 105
- 106
- 107
- 108
- 109
- 110
- 111
- 112
- 113
- 114
- Run:
- 变量
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- 1
- 2
- 3
- 4
- else子代码
- Process finished with exit code O
<!-- OCR_END -->

￼

```plain
n=1
while n<5:
    if n == 4:
        break
    print(n)
    n+=1
else:
    print('else子代码')
```

<!-- OCR_START -->
- untitled1
- venv
- 2a.py
- Project
- 基础.py
- 01与用户交互.py
- a.py x
- untitled1 ~/PycharmProjects/untitled1
- 86
- #eLse的代码会在while循环没有被break打断的情况下运行
- 87
- 88
- bin
- n=1
- 89
- 白while n<5:
- include
- 90
- if n ==4:
- Mlib
- 91
- break
- a.py
- 92
- print(n)
- 三pyvenv.cfg
- 93
- 94
- else:
- 95
- print('else子代码'）
- 96
- lli External Libraries
- 97
- 98
- Scratches and Consoles
- 99
- 100
- 101
- 102
- 103
- 104
- 105
- 106
- 107
- 108
- 109
- 110
- 111
- 112
- 113
- 114
- Run:
- 2变量
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- 1
- 2
- 3
- Process finished with exit code 0
<!-- OCR_END -->

￼

将用户登录出错的次数限制为3次

```plain
user_db = 'zls'
pwd_db = '123'
count=0
tag = True
while tag:
    if count == 3:
        print('您已输错%s次，账户已被封' %count)
        break
    inp_user=input('username>>>:')
    inp_password=input('password>>:')
    if inp_user == user_db and inp_password == pwd_db:
        print('login successful')
        while tag:
            cmd = input('>>>>:')
            if cmd == 'quit':
                tag=False
                break
            print('%s run.....' %cmd)
    else:
        print('user or password error')
        count+=1
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- 基础.py
- 01与用户交互.py
- Project
- untitled1 ~/PycharmProjects/untitled1
- 65
- 66
- user_db ='zls
- 67
- pwd_db=123
- bin
- 68
- linclude
- 69
- count=0
- lib
- 70
- tag = True
- 71
- 72
- 三pyvenv.cfg
- 73
- while tag:
- 74
- if count ==3:
- 75
- print（您已输错%s次，账户已被封%count）
- 76
- break
- Illi External Libraries
- 77
- inp_user=input('username>>>:')
- Scratches and Consoles
- 78
- inp_password=input('password>>:')
- 79
- if inp_user == user_db and inp_password == pwd_db:
- 80
- print('login successful')
- 81
- 82
- cmd = input('>>>>:
- 83
- if cmd =='quit':
- 84
- tag=False
- 85
- 86
- print('%s run.....
- %cmd)
- 87
- else:
- 88
- print('user or password error')
- 89
- count+=1
- 90
- 91
- 92
- 93
- 94
- Run:
- 变量X
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- username>>>:zls
- password>>: 1
- user or password error
- password>>:2
- password>>:3
- 您已输错3次，账户已被封
- Process finished with exit code 0
<!-- OCR_END -->

￼

**练习题**

```plain
#练习，要求如下：
    1 循环验证用户输入的用户名与密码
    2 认证通过后，运行用户重复执行命令
    3 当用户输入命令为quit时，则退出整个程序
```

```plain
#1. 使用while循环输出1 2 3 4 5 6     8 9 10
#2. 求1-100的所有数的和
#3. 输出 1-100 内的所有奇数
#4. 输出 1-100 内的所有偶数
#5. 求1-2+3-4+5 ... 99的所有数的和
#6. 用户登陆（三次机会重试）
#7：猜年龄游戏
要求：
    允许用户最多尝试3次，3次都没猜对的话，就直接退出，如果猜对了，打印恭喜信息并退出
#8：猜年龄游戏升级版 
要求：
    允许用户最多尝试3次
    每尝试3次后，如果还没猜对，就问用户是否还想继续玩，如果回答Y或y, 就继续让其猜3次，以此往复，如果回答N或n，就退出程序
    如何猜对了，就直接退出
```

***

```plain
#题一
count=1
while count <= 10:
    if count == 7:
        count+=1
        continue
    print(count)
    count+=1
    
count=1
while count <= 10:
    if count != 7:
        print(count)
    count+=1
    
#题目二
res=0
count=1
while count <= 100:
    res+=count
    count+=1
print(res)
#题目三
count=1
while count <= 100:
    if count%2 != 0:
        print(count)
    count+=1
    
#题目四
count=1
while count <= 100:
    if count%2 == 0:
        print(count)
    count+=1
    
    
    
#题目五
res=0
count=1
while count <= 5:
    if count%2 == 0:
        res-=count
    else:
        res+=count
    count+=1
print(res)
    
#题目六
count=0
while count < 3:
    name=input('请输入用户名：')
    password=input('请输入密码：')
    if name == 'egon' and password == '123':
        print('login success')
        break
    else:
        print('用户名或者密码错误')
        count+=1
#题目七
age_of_oldboy=73
count=0
while count < 3:
    guess=int(input('>>: '))
    if guess == age_of_oldboy:
        print('you got it')
        break
    count+=1
#题目八
age_of_oldboy=73
count=0
while True:
    if count == 3:
        choice=input('继续(Y/N?)>>: ')
        if choice == 'Y' or choice == 'y':
            count=0
        else:
            break
    guess=int(input('>>: '))
    if guess == age_of_oldboy:
        print('you got it')
        break
    count+=1
```

## 流程控制for循环

for循环通常是用来做取值操作的，例如，列表取值。

```plain
#如果这么写，取值是一个重复的过程
names=['zls','bgx','oldboy','egon']
names[0]
names[1]
names[2]
names[3]
#使用while循环取值,i从何而来？
names=['zls','bgx','oldboy','egon']
i = 0
while i < 4:
    print(names[i])
    i+=1
#列表长度
names=['zls','bgx','oldboy','egon']
i = 0
while i < len(names):
    print(names[i])
    i+=1
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- a.pyx
- untitled1~/PycharmProjects/untitled1
- 90
- 91
- names=['zls'.'bgx','oldboy','egon']
- 1
- 92
- bin
- 93
- i=0
- 94
- while i<len(names):
- include
- 95
- print(names[i])
- lib
- 96
- i+=1
- 97
- 三pyvenv.cfg
- 98
- 99
- 100
- 101
- lli External Libraries
- 102
- oScratchesandConsoles
- 103
- 104
- 105
- 106
- 107
- 108
- 109
- 110
- 111
- 112
- 113
- 114
- 115
- 116
- 117
- 118
- 119
- Run:
- 2变量x
- a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- zls
- bgx
- oldboy
- egon
- Processfinishedwith exitcodeO
<!-- OCR_END -->

￼

这是在列表中，有索引的情况下，可以循环取值，但是如果是字典呢？如何用while取值？可以取，但是需要`迭代器`，非常的麻烦。

> for循环：不依赖索引而取值，是一种通用的取值方式

```plain
dic={'x':1,'y':2,'z':3}
for item in dic:
    print(item)
    
#结果
x
y
z
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.pyX
- 01与用户交互.py
- a.pyx
- untitled1 ~/PycharmProjects/untitled1
- 97
- 98
- dic={'x':1'y':2'z':3}
- 1
- 99
- bin
- 100
- for item in dic:
- include
- 101
- print(item)
- lib
- 102
- 103
- 104
- 三pyvenv.cfg
- 105
- 106
- 基础.py
- 107
- 108
- llliExternal Libraries
- 109
- Scratches and Consoles
- 110
- 111
- 112
- 113
- 114
- 115
- 116
- 117
- 118
- 119
- 120
- 121
- 122
- 123
- 124
- 125
- 126
- Run:
- 变量
- a(1)
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Pycha
- Process finished with exit code 0
<!-- OCR_END -->

￼

取出key了那么我们也就知道了value该如何去取

```plain
dic={'x':1,'y':2,'z':3}
for item in dic:
    print(item)
    print(dic[item])
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- a.pyx
- untitled1 /PycharmProjects/untitled1
- 97
- 98
- dic={'x':1'y':2'z':3}
- 99
- bin
- 100
- for item in dic：
- include
- 101
- print(item)
- lib
- 102
- print(dic[item])
- 103
- 104
- 三pyvenv.cfg
- 105
- 106
- 107
- 108
- lli External Libraries
- 109
- Scratches and Consoles
- 110
- 111
- 112
- 113
- 114
- 115
- 116
- 117
- 118
- 119
- 120
- 121
- 122
- 123
- 124
- 125
- 126
- Run:
- 变量
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- 2
- 3
- Process finished with exit code 0
<!-- OCR_END -->

￼

```plain
dic={'x':1,'y':2,'z':3}
for item in dic:
    print(item,dic[item])
```

<!-- OCR_START -->
| 排名 | 名称 | 名称 | 排名(上年) | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| untitled1 | venv | 2a.py | Project | 女 | 基础.pyx |
| 01与用户交互.py | a.pyx | untitled1~/PycharmProjects/untitled1 | 97 | 98 | dic={'x':1'y':2'z':3} |
| venv | 99 | bin | 100 | for item in dic: | include |
| 101 | print(item,dic[item]) | lib | 102 | 103 | a.py |
| 104 | 三pyvenv.cfg | 105 | 01与用户交互.py | 106 | 基础.py |
| 107 | 108 | lli External Libraries | 109 | oScratchesandConsoles | 110 |
| 111 | 112 | 113 | 114 | 115 | 116 |
| 117 | 118 | 119 | 120 | 121 | 122 |
| 123 | 124 | 125 | 126 | Run: | 2变量X |
| 2a(1)x | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py | x1 | y2 | Z3 | ProcessfinishedwithexitcodeO |
<!-- OCR_END -->

￼

如果使用同一种功能，反复使用，可以使用while循环，如果要做取值的事情，可以使用for循环。

for循环的次数，是由被循环对象包含值的个数决定的。

while循环的次数，是由条件决定的。

for循环按照索引取值 VS while循环按照索引取值

`range`

```plain
#在python2中
MacBook-Pro:~ driverzeng$ python
Python 2.7.10 (default, Aug 17 2018, 17:41:52)
[GCC 4.2.1 Compatible Apple LLVM 10.0.0 (clang-1000.0.42)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> range(0,5)
[0, 1, 2, 3, 4]
>>> range(0,5,2)
[0, 2, 4]
#在python3中
MacBook-Pro:~ driverzeng$ python3
Python 3.6.4 (v3.6.4:d48ecebad5, Dec 18 2017, 21:07:28)
[GCC 4.2.1 (Apple Inc. build 5666) (dot 3)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> range(0,5)
range(0, 5)
```

<!-- OCR_START -->
MacBook-Pro:~driverzeng$python
Python 2.7.10 (default，Aug 17 2018,17:41:52)
[GCC 4.2.1Compatible AppleLLVM10.0.0(clang-1000.0.42)]ondarwin
Type "help"，"copyright"，"credits" or "license" for more information.
range(0,5)
[0, 1, 2,3， 4]
range(0,5,2)
[0,2，4]
<!-- OCR_END -->

￼

<!-- OCR_START -->
X...ython-3.6.4(ssh)
81
X..lkstack02:~（ssh)
82
X..kstack03:~（ssh)
83
MacBook-Pro:~driverzeng$python3
bash:puthon3:commandnotfound
Python 3.6.4(v3.6.4:d48ecebad5，Dec182017，21:07:28)
[GCC4.2.1（AppleInc.build5666）（dot3)]ondarwin
Type "help"，"copyright"，"credits" or "license" for more information.
range(0,5)
<!-- OCR_END -->

￼

```plain
#while取值
names=['zls','bgx','oldboy','egon']
i = 0
while i < len(names):
    print(names[i])
    i+=1
dic={'x':1,'y':2,'z':3}
#for取值
for i in range(0,4):
    print(names[i])
#使用列表长度
for i in range(0,len(names)):
    print(names[i])
```

**for+break**

```plain
for i in range(10):
    if i == 4:
        break
    print(i)
```

**for+else**

```plain
for i in range(10):
    print(i)
else:
    print('====》')
```

打印99乘法表：

```plain
for i in range(1,10):
    for j in range(1,i+1):
        print('%s*%s=%s' %(i,j,i*j),end=' ')
    print()
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- 基础.py
- 01与用户交互.py
- Project
- 105
- untitled1 ~/PycharmProjects/untitled1
- 106
- for i in range（1,10):
- 1
- 107
- for j in range(l,i+1):
- bin
- 108
- print('%s*%s=%s'%（iji*j),end='
- include
- 109
- print()
- 110
- lib
- 111
- 112
- 三pyvenv.cfg
- 113
- 114
- 115
- 116
- lliExternal Libraries
- 117
- Scratches and Consoles
- 118
- 119
- 120
- 121
- 122
- 123
- 124
- 125
- 126
- 127
- 128
- 129
- 130
- 131
- 132
- 133
- 134
- Run:
- 2变量
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- 2*1=22*2=4
- 3*1=33*2=63*3=9
- 4*1=44*2=84*3=124*4=16
- 5*1=55*2=105*3=155*4=205*5=25
- 6*1=66*2=126*3=186*4=246*5=306*6=36
- 7*1=77*2=147*3=217*4=287*5=357*6=427*7=49
- 8*1=88*2=168*3=248*4=328*5=408*6=488*7=568*8=64
- 9*1=99*2=189*3=279*4=369*5=459*6=549*7=639*8=729*9=81
- Process finished with exit code 0
<!-- OCR_END -->

￼

打印金字塔：

```plain
#分析
'''
             #max_level=5
    *        #current_level=1，空格数=4，*号数=1
   ***       #current_level=2,空格数=3,*号数=3
  *****      #current_level=3,空格数=2,*号数=5
 *******     #current_level=4,空格数=1,*号数=7
*********    #current_level=5,空格数=0,*号数=9
#数学表达式
空格数=max_level-current_level
*号数=2*current_level-1
'''
#实现
max_level=5
for current_level in range(1,max_level+1):
    for i in range(max_level-current_level):
        print(' ',end='') #在一行中连续打印多个空格
    for j in range(2*current_level-1):
        print('*',end='') #在一行中连续打印多个空格
    print()
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- a.pyx
- untitled1 ~/PycharmProjects/untitled1
- 113
- 114
- max_level=5
- 115
- for current_level in range(1max_level+1):
- bin
- 116
- for i in range(max_level-current_level):
- include
- 117
- print（end=）#在一行中连续打印多个空格
- lib
- 118
- for j in range(2*current_level-1):
- 119
- 120
- print()
- 三pyvenv.cfg
- 121
- 122
- 123
- 124
- Illi External Libraries
- 125
- Scratches and Consoles
- 126
- 127
- 128
- 129
- 130
- 131
- 132
- 133
- 134
- 135
- 136
- 137
- 138
- 139
- 140
- Run:
- 2变量X
- a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- ***
- *****
- *******
- *********
- Process finished withexit code o
<!-- OCR_END -->

￼

未经允许不得转载，欢迎技术交流，QQ：133411023：[DBA老司机带你删库到跑路.](https://www.driverzeng.com/) » [Python-基础03-流程控制](https://www.driverzeng.com/zenglaoshi/1300.html)

> 更新: 2019-05-28 15:15:33  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/re9qlq>