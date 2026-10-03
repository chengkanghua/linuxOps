# Python基础09-装饰器

## Python基础09-装饰器
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

+ [装饰器介绍](https://blog.driverzeng.com/zenglaoshi/5239.html#toc_0)
+ [小练习：认证功能的装饰器](https://blog.driverzeng.com/zenglaoshi/5239.html#toc_1)
+ [叠加多个装饰器](https://blog.driverzeng.com/zenglaoshi/5239.html#toc_2)
+ [有参装饰器](https://blog.driverzeng.com/zenglaoshi/5239.html#toc_3)
+ [装饰器伪装注释信息](https://blog.driverzeng.com/zenglaoshi/5239.html#toc_4)

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

## 装饰器介绍
---

| 什么是装饰器 |
| :--- |

装饰器，就是用来为被装饰器对象，添加新功能的工具

```plain
装饰器他人的器具，本身可以是任意可调用对象，被装饰者也可以是任意可调用对象。
强调装饰器的原则：1 不修改被装饰对象的源代码 2 不修改被装饰对象的调用方式
装饰器的目标：在遵循1和2的前提下，为被装饰对象添加上新功能
```

---

| 为什么要用装饰器 |
| :--- |

开放封闭原则：对修改封闭，对扩展开放

装饰器的实现，必须遵循两大原则。

1.不修改被装饰对象的源代码

2.不修改被装饰对象的调用方式

装饰器的目标，就是在遵循1和2原则的前提下为被装饰对象添加上新功能

---

| 装饰器简单版 |
| :--- |

```plain
# 模拟网站响应
import time
def index():
    print('welcome to index page')
    time.sleep(3)
# 需求，给上面的index函数，加一个新功能，统计他的执行时间
import time
def index():
    print('welcome to index page')
    time.sleep(3)
start=time.time()
index()
stop=time.time()
print('Run Time Is: %s' %(stop - start))
# 是不是满足了两大原则？
# 1.没有改变被装饰对象的源代码
# 2.没有改变被装饰对象的调用方式
# 哦~~~~这原来就是装饰器啊...
# 装饰你妹啊~
# 想一个问题，如果我们有login函数，register函数...等1万个函数，改怎么写？
start=time.time()
index()
stop=time.time()
print('Run Time Is: %s' %(stop - start))
start=time.time()
register()
stop=time.time()
print('Run Time Is: %s' %(stop - start))
start=time.time()
login()
stop=time.time()
print('Run Time Is: %s' %(stop - start))
# 智障...全都是重复代码，可以去屎了，那么我们来优化一下代码
import time
def index():
    print('welcome to index page')
    time.sleep(3)
def wrapper(func):
    start=time.time()
    func()
    stop=time.time()
    print('Run Time Is: %s' %(stop - start))
wrapper(index)
# 完美了吗？并没有，因为每次调用我们还需要传参...
import time
def index():
    print('welcome to index page')
    time.sleep(3)
def outter(func):
    def wrapper():
        start=time.time()
        func()
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
    return  wrapper
f=outter(index)
f()
# 变成"装饰器"写法，但是好像不满足两大原则，我们修改了函数的调用方式，下面的代码 ，搞定
import time
def index():
    print('welcome to index page')
    time.sleep(3)
def outter(func):
    def wrapper():
        start=time.time()
        func()
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
    return  wrapper
index=outter(index)
index()
```

---

| 装饰器升级版 |
| :--- |

```plain
import time
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
# 上面这个函数，是一个需要传参的函数，调用方法如下
home('zls')
# 需求，使用装饰器，调用
import time
def index():
    print('welcome to index page')
    time.sleep(3)
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
def outter(func):
    def wrapper(name):
        start=time.time()
        func(name)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
    return  wrapper
home=outter(home)
home('zls')
# 完美？那么我们把index在调用一下试试？
import time
def index():
    print('welcome to index page')
    time.sleep(3)
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
def outter(func):
    def wrapper(name):
        start=time.time()
        func(name)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
    return  wrapper
index=outter(index)
index()
# home=outter(home)
# # home('zls')
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-../01装饰器.py
- PYTHON
- 01装饰器.py
- 01函数对象.pyX
- 02函数嵌套.py
- 03名称空间与作用域.py
- 04闭包函数.py
- time.sleep(3)
- 5
- 6
- def home(name):
- 8
- print('welcome %s to home page' %name)
- 9
- time.sleep(2)
- 10
- 11
- def outter（func):
- 12
- def wrapper(name):
- 13
- start=time.time()
- 14
- func(name)
- 15
- stop=time.time()
- 16
- print('Run Time Is:%s'9
- %（stop -start))
- 17
- returnwrapper
- 18
- 19
- index=outter(index)
- 20
- index()
- 21
- 22
- 白#
- home=outter(home)
- 23
- ##home('zls')
- Run:
- 01装饰器X
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/01 装饰器.py
- Traceback(most recent call last):
- File"Users/driverzeng/Desktop/PYTHoN/01 装饰器.py"，line 20，in <module>
- TypeError:wrapper() missing 1 required positional argument:'name'
- Process finished with exit code 1
- https://blog.driverzeng.com
<!-- OCR_END -->

￼

emm... 报错了，为啥呢？因为把为了写home函数的装饰器，把wrapper改了啊，需要一个参数

```plain
import time
def index():
    print('welcome to index page')
    time.sleep(3)
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
def outter(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
    return  wrapper
index=outter(index)
index()
home=outter(home)
home('zls')
```

<!-- OCR_START -->
- THONI
- PYTHON01装饰器.Py
- 01函数对象.pyx
- 02函数嵌套.pyx
- 03名称空间与作用域.pyx
- 04闭包函数.py
- 01装饰器.py
- import time
- def index（）：
- print('welcome to index page')
- time.sleep(3)
- def home(name）:
- print('welcome %s tohome page'%name)
- time.sleep(2)
- 10
- 11
- def outter（func):
- 12
- def wrapper(*args**kwargs):
- 13
- start=time.time()
- 14
- func(*args,**kwargs)
- 15
- stop=time.time()
- 16
- print('Run Time Is:%s'%(stop-start))
- 17
- returnwrapper
- 18
- 19
- index=outter（index)
- 20
- index()
- 21
- 22
- home=outter(home)
- 23
- home('zls')
- Run:
- 01装饰器×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHON/01装饰器.py
- welcome to indexpage
- Run Time Is:3.002225875854492
- welcome zls to home page
- RunTimeIs:2.0022430419921875
- Processfinishedwith exitcodeO
<!-- OCR_END -->

￼

那么问题来了，如果函数有返回值怎么办？

```plain
import time
def index():
    print('welcome to index page')
    time.sleep(3)
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
    return 123
def outter(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
    return  wrapper
home=outter(home)
res=home('zls')
print(res)
```

<!-- OCR_START -->
- PYTHON01装饰器.py
- 01函数对象.py
- 02函数嵌套.pyx
- 03名称空间与作用域.pyx
- 04闭包函数.py
- 01装饰器.py
- def home(name):
- print(weLcome %s tohome page'%name)
- 9
- time.sleep(2)
- 10
- return 123
- 11
- 12
- def outter（func）:
- 13
- defwrapper(*args**kwargs):
- 14
- start=time.time()
- 15
- func(*args,**kwargs)
- 16
- stop=time.time()
- 17
- print('Run Time Is:%s'%（stop-start))
- 18
- returnwrapper
- 19
- 20
- index=outter(index)
- 21
- index()
- 22
- 23
- home=outter(home)
- 24
- 25
- res=home('zls')
- 26
- print(res)
- 27
- 28
- Run:
- 01装饰器×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/01装饰器.py
- welcome to index page
- Run Time Is:3.0042507648468018
- welcome zls to home page
- Run Time Is:2.0051019191741943
- None
- Process finished with exit code 0
<!-- OCR_END -->

￼

改进一下纸

```plain
import time
def index():
    print('welcome to index page')
    time.sleep(3)
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
    return 123
def timmer(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        res=func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
        return res
    return  wrapper
index=timmer(index)
index()
home=timmer(home)
res=home('zls')
print(res)
```

---

| 装饰器语法糖 |
| :--- |

```plain
import time
def timmer(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        res=func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
        return res
    return  wrapper
@timmer
def index():
    print('welcome to index page')
    time.sleep(3)
# 语法糖，把装饰器，放到被装饰对象上面加上@
@timmer
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
    return 123
index()
res=home('zls')
print(res)
```

---

| 装饰器模板 |
| :--- |

```plain
def outter(func):
    def wrapper(*args,**kwargs):
        res=func(*args,**kwargs)
        return res
    return wrapper
@outter
```

## 小练习：认证功能的装饰器
```plain
import time
def auth(func):
    def wrapper(*args,**kwargs):
        inp_user=input('please input your username: ').strip()
        inp_pwd=input('please input your password: ').strip()
        if inp_user == 'zls' and inp_pwd == '123':
            print('login successfull')
            res=func(*args,**kwargs)
        return res
    return wrapper
@auth
def index():
    print('welcome to index page')
    time.sleep(3)
index()
```

## 叠加多个装饰器
```plain
import time
def timmer(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        res=func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
        return res
    return  wrapper
def auth(func):
    def wrapper(*args,**kwargs):
        inp_user=input('please input your username: ').strip()
        inp_pwd=input('please input your password: ').strip()
        if inp_user == 'zls' and inp_pwd == '123':
            print('login successfull')
            res=func(*args,**kwargs)
        return res
    return wrapper
@auth
@timmer
def index():
    print('welcome to index page')
    time.sleep(3)
index()
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]
- ../01装饰器.py[PYTHON]
- PYTHON
- 01装饰器.py
- 01函数对象.py
- 02函数嵌套.py
- 03名称空间与作用域.py
- 04闭包函数.py
- 32
- start=time.time()
- 33
- res=func(*args,**kwargs)
- 34
- stop=time.time()
- 35
- print('Run TimeIs:%s'%（stop-start))
- 36
- return res
- 37
- returnwrapper
- 38
- 39
- defauth（func）:
- 40
- def wrapper(*args**kwargs):
- 41
- inp_user=input('please input your username:
- ').strip()
- 42
- inp_pwd=input('please input your password:
- 43
- 44
- ifinp_user='zls'and inp_pwd='123':
- 45
- print('login successfull')
- 46
- 50
- atimmer
- 51
- @auth
- 52
- def index）:
- 53
- print('welcome to index page')
- 54
- time.sleep(3)
- 55
- wrapper()
- Run:
- 01装饰器×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/PYTHoN/01 装饰器·py"
- please input your username:
- please input your password: 123
- login successfull
- welcome to index page
- Run Time Is
- 15.528491973876953
- ProcessfinishedwithexitcodeO
<!-- OCR_END -->

￼

**注意：**当我们有多个装饰器的时候，解释语法是自下而上运行，但是如果是装饰器的话，自上而下运行，如果我们把timmer装饰器放在auth上面，那么运算的时间，会把auth函数的时间加进去

<!-- OCR_START -->
- PYTHON
- 01装饰器.py
- 01函数对象.py
- 02函数嵌套.pyx
- 03名称空间与作用域.py
- 04闭包函数.py
- 34
- stop=time.time()
- 35
- print('Run TimeIs:%s'%（stop-start))
- 36
- return res
- 37
- returnwrapper
- 38
- 39
- def auth（func）:
- 40
- def wrapper(*args**kwargs):
- 41
- inp_user=input('please input your username:').strip()
- 42
- inp_pwd=input('please input your password:').strip()
- 43
- 44
- ifinp_user='zls'and inp_pwd='123':
- 45
- print('login successfull')
- 46
- res=func(*args,**kwargs)
- 47
- 48
- 49
- 50
- aauth
- 51
- @timmer
- 52
- def index（）:
- 53
- print('welcome to index page')
- 54
- time.sleep(3)
- 55
- 56
- index()
- auth()wrapper()
- Run:
- 01装饰器×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/01 装饰器.py
- please input your username:
- Zls
- please input your password: 123
- login successfull
- welcome to index nage
- Run Time Is:
- 3.0021278858184814
- Process finished with exitcode0
<!-- OCR_END -->

￼

## 有参装饰器
之前我们用的都是无参装饰器，现在我们要让装饰器可以传递参数

我们来修改一下认证的源，之前我们认证都是文件，企业中会把用户存储在MySQL中或者LDAP

```plain
import time
def timmer(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        res=func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
        return res
    return  wrapper
def auth(func):
    def wrapper(*args,**kwargs):
        if engine == 'file':
            inp_user=input('please input your username: ').strip()
            inp_pwd=input('please input your password: ').strip()
            if inp_user == 'zls' and inp_pwd == '123':
                print('login successfull')
                res=func(*args,**kwargs)
                return res
            else:
                print('username or password error')
        elif engine == 'mysql':
            print('基于MySQL的认证机制')
        elif engine == 'ldap':
            print('基于LDAP的认证机制')
        else:
            print('无法识别的认证源')
    return wrapper
@auth
@timmer
def index():
    print('welcome to index page')
    time.sleep(3)
index()
```

代码写完了，但是我需要知道engine是什么，然后找对应的认证方式，需要传参使用闭包

```plain
import time
def timmer(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        res=func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
        return res
    return  wrapper
def engine_auth(engine='file'):
    def auth(func):
        def wrapper(*args,**kwargs):
            if engine == 'file':
                inp_user=input('please input your username: ').strip()
                inp_pwd=input('please input your password: ').strip()
                if inp_user == 'zls' and inp_pwd == '123':
                    print('login successfull')
                    res=func(*args,**kwargs)
                    return res
                else:
                    print('username or password error')
            elif engine == 'mysql':
                print('基于MySQL的认证机制')
            elif engine == 'ldap':
                print('基于LDAP的认证机制')
            else:
                print('无法识别的认证源')
        return wrapper
    return auth
@engine_auth('mysql')
@timmer
def index():
    print('welcome to index page')
    time.sleep(3)
index()
```

装饰器，最多就三层，最外面层可以随便传递参数

---

| 无参装饰器模板 |
| :--- |

```plain
def outter(func):
    def wrapper(*args,**kwargs):
        res=func(*args,**kwargs)
        return res
    return wrapper
```

---

| 有参装饰器模板 |
| :--- |

```plain
def outter(x,y,z):
    def outter2(func):
        def wrapper(*args,**kwargs):
            res=func(*args,**kwargs)
            return res
        return wrapper
    return outter2
```

---

| 解决程序bug |
| :--- |

```plain
import time
def timmer(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        res=func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
        return res
    return  wrapper
def engine_auth(engine='file'):
    def auth(func):
        def wrapper(*args,**kwargs):
            if engine == 'file':
                inp_user=input('please input your username: ').strip()
                inp_pwd=input('please input your password: ').strip()
                if inp_user == 'zls' and inp_pwd == '123':
                    print('login successfull')
                    res=func(*args,**kwargs)
                    return res
                else:
                    print('username or password error')
            elif engine == 'mysql':
                print('基于MySQL的认证机制')
            elif engine == 'ldap':
                print('基于LDAP的认证机制')
            else:
                print('无法识别的认证源')
        return wrapper
    return auth
@engine_auth('file')
@timmer
def index():
    print('welcome to index page')
    time.sleep(3)
index()
@engine_auth('file')
@timmer
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
    return 123
res=home('zls')
print(res)
```

我们在两个函数前面都加上认证模块

<!-- OCR_START -->
PYTHON
THON
01装饰器.py
01函数对象.py
02函数嵌套.py
03名称空间与作用域.py
04闭包函数.py
32
start=time.time()
33
res=func(*args,**kwargs)
34
stop=time.time()
35
print('Run Time Is:%s' %(stop - start))
36
return res
37
return.wrapper
38
39
def engine_auth(engine='file'):
40
def auth(func）:
41
def wrapper(*args**kwargs):
42
if engine =
'file':
43
inp_user=input('please input your username:
）.strip(）
44
inp_pwd=input('please input your password:
45
if inp_user ='zls'and inp_pwd =
123：
46
print('login successfull')
47
48
lca
Run:
01装饰器×
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/PYTHoN/01 装饰器.py
please input your username: zls
please input your password: 123
login successfull
welcome to index page
Run Time Is:3.0019118785858154
welcome zls to home page
Run Time Is:2.004845142364502
Process finished with exit code 0
https://bloq.
<!-- OCR_END -->

￼

然后这个程序就智障了，mmp，让我登录两次？你们见过哪个网站登录过一次，还需要登录第二次？

比如你再京东买东西...一开始登录了，然后当你点购物车还要登录？点结算还要登录？疯了吧

所以我们需要记录一下用户的登录状态...

```plain
import time
current_user={'username':None}
def timmer(func):
    def wrapper(*args,**kwargs):
        start=time.time()
        res=func(*args,**kwargs)
        stop=time.time()
        print('Run Time Is: %s' %(stop - start))
        return res
    return  wrapper
def engine_auth(engine='file'):
    def auth(func):
        def wrapper(*args,**kwargs):
            if current_user['username']:
                print('已经登录过了，无需再次登录')
                res=func(*args,**kwargs)
                return res
            if engine == 'file':
                inp_user=input('please input your username: ').strip()
                inp_pwd=input('please input your password: ').strip()
                if inp_user == 'zls' and inp_pwd == '123':
                    print('login successfull')
                    current_user['username']=inp_user  #记录登录状态
                    res=func(*args,**kwargs)
                    return res
                else:
                    print('username or password error')
            elif engine == 'mysql':
                print('基于MySQL的认证机制')
            elif engine == 'ldap':
                print('基于LDAP的认证机制')
            else:
                print('无法识别的认证源')
        return wrapper
    return auth
@engine_auth('file')
@timmer
def index():
    print('welcome to index page')
    time.sleep(3)
index()
@engine_auth('file')
@timmer
def home(name):
    print('welcome %s to home page' %name)
    time.sleep(2)
    return 123
res=home('zls')
print(res)
```

<!-- OCR_START -->
- PYTHON
- 01装饰器.py
- 01函数对象.Py
- 02函数嵌套.py
- 03名称空间与作用域.py
- 04闭包函数.py
- 28
- import time
- 29
- 30
- current_user=f'username':None}
- 31
- 32
- def timmer（func):
- 33
- def wrapper(*args**kwargs):
- 34
- start=time.time()
- 35
- res=func(*args,**kwargs)
- 36
- stop=time.time()
- 37
- print('Run Time Is:%s' %(stop -start))
- 38
- return res
- 39
- returnwrapper
- 40
- 41
- def engine_auth(engine='file'):
- 42
- def auth(func):
- 43
- 44
- if current_user['username']:
- 45
- print（‘已经登录过了，无需再次登录）
- 46
- 47
- 48
- if engine=
- "file':
- 49
- inp_user=input('please input your username:
- ').strip()
- 50
- inp_pwd=input('please input your password:
- 51
- if inp_user =
- 'zls'and inp_pwd=
- '123':
- 52
- print('login successfull')
- 53
- current user['username']=inp user #记录登录状态
- engine_auth()
- Run:
- 01装饰器×
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/PYTHoN/01 装饰器.py
- please input your username:
- Z19
- nns:z
- please input your password:
- login successfull
- welcome to indexpage
- Run Time Ts
- 已经登录过了，无需再次登录
- welcomezls tohomepage
- Run Time Is:2.001326084136963
- Process finished with exit code 0
<!-- OCR_END -->

￼

## 装饰器伪装注释信息
---

| 了解函数注释的作用 |
| :--- |

```plain
import time
def demo(func):
    def wrapper(*args,**kwargs):
        res=func(*args,**kwargs)
        return res
    return  wrapper
def index():
    """
    index功能
    """
    print('进入index页面')
    time.sleep(3)
# 查看函数名
print(index.__name__)
# 查看函数注释信息
print(index.__doc__)
# 查看函数的注释信息
print(help(index))
```

<!-- OCR_START -->
| 排名 | PYTHON | PYTHON | PYTHON | PYTHON | PYTHON |
| --- | --- | --- | --- | --- | --- |
| 89 | res=func(*args,**kwargs) | 90 | return res | 91 | returnwrapper |
| 92 | 93 | def index(): | 94 | 95 | index功能 |
| 96 | 97 | print（进入index页面'） | 98 | time.sleep(3) | 99 |
| 100 | print（函数名 | 101 | print(index. | Lname | 102 |
| 103 | print（'- | 注释信息1 | 104 | print(index. | Ldoc |
| 105 | 106 | print(' | 注释信息2 | 107 | print(help(index)) |
| Run: | 01装饰器× | /ulsers/drivonz | 11/venv/bin/python/Users/driverzeng/Desktop/PYTHON/01装饰器·py | 函数名： | index |
| 注释信息1 | index功能 | 一 | 注释信息2- | Help on function index in module | main_ |
<!-- OCR_END -->

￼

现在我们把装饰器加上

```plain
import time
def demo(func):
    def wrapper(*args,**kwargs):
        res=func(*args,**kwargs)
        return res
    return  wrapper
@demo
def index():
    """
    index功能
    """
    print('进入index页面')
    time.sleep(3)
print('--- 函数名：---')
print(index.__name__)
print('--- 注释信息1 ---')
print(index.__doc__)
print('--- 注释信息2 ---')
print(help(index))
```

<!-- OCR_START -->
| PYTHON | PYTHON | PYTHON | PYTHON | PYTHON | 排名 |
| --- | --- | --- | --- | --- | --- |
| 03名称空间与作用域.py | 04闭包函数.py | 01装饰器.py | 89 | res=func(*args**kwargs) | 90 |
| return res | 91 | returnwrapper | 92 | 93 | ademo |
| 94 | def index（）： | 95 | 96 | index功能 | 97 |
| 98 | print（‘进入index页面'） | 99 | time.sleep(3) | 100 | 101 |
| print..函数名 | 102 | print(index. | name | 103 | 104 |
| print（'---注释信息1 | 105 | print(index. | doc | 106 | 107 |
| print（'---注释信息2 | 108 | print(help(index)) | index() | Run: | 01装饰器X |
| /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/01 装饰器.py | 函数名： | wrapper | 注释信息1 | 训 | None |
<!-- OCR_END -->

￼

当我们给一个函数加上装饰器后，会发现，函数名变了，注释信息没了，这样的话，别人无法查看你的这个功能，用不明白，那就是垃圾代码。

那肿么办？我们把注释信息加在wrapper里面？

```plain
import time
def demo(func):
    def wrapper(*args,**kwargs):
        """
        index功能
        """
        res=func(*args,**kwargs)
        return res
    return  wrapper
@demo
def index():
    """
    index功能
    """
    print('进入index页面')
    time.sleep(3)
print('--- 函数名：---')
print(index.__name__)
print('--- 注释信息1 ---')
print(index.__doc__)
print('--- 注释信息2 ---')
print(help(index))
```

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 排名 | 名称 |
| --- | --- | --- | --- | --- |
| PYTHON[~/Desktop/PYTHON] | PYTHON01装饰器.py | 01函数对象.py | 02函数嵌套.py | 03名称空间与作用域.py |
| 04闭包函数.py | 01装饰器.py | 84 | 85 | import time |
| 86 | 87 | def demo（func）: | 88 | defwrapper(*args**kwargs): |
| 89 | 90 | index功能 | 91 | 92 |
| res=func(*args,**kwargs) | 93 | return res | 94 | returnwrapper |
| 95 | 96 | ademo | 97 | def index（）: |
| 98 | 99 | index功能 | 100 | 101 |
| print（进入index页面'） | 102 | time.sleep(3) | 103 | 104 |
| Drint（---函数名： | Run: | 01装饰器X | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/01 装饰器.py | 函数名： |
| wrapper | 注释信息1 | 训 | index功能 | 注释信息2- |
| Help on function wrapper inmodule_main_: | wrapper(*args,**kwargs) | index功能 | None | Process finishedwithexitcodeo |
<!-- OCR_END -->

￼

这样写，那就是智障...写死了，如果我把装饰器加在别的函数上呢？还是index功能嘛？

```plain
import time
def demo(func):
    def wrapper(*args,**kwargs):
        res=func(*args,**kwargs)
        return res
    # 将wrapper函数的函数名赋值给func函数，也就是传递进来的函数（被装饰对象）
    wrapper.__name__ = func.__name__
    # 将wrapper函数的注释信息赋值给func函数，也就是传递进来的函数（被装饰对象）
    wrapper.__doc__ = func.__doc__
    return  wrapper
@demo
def index():
    """
    index功能
    """
    print('进入index页面')
    time.sleep(3)
print('--- 函数名：---')
print(index.__name__)
print('--- 注释信息1 ---')
print(index.__doc__)
print('--- 注释信息2 ---')
print(help(index))
```

<!-- OCR_START -->
| PYTHON | PYTHON | PYTHON | PYTHON | 排名 | PYTHON |
| --- | --- | --- | --- | --- | --- |
| 01函数对象.py | 02函数嵌套.py | 03名称空间与作用域.pyx | 04闭包函数.py | 01装饰器.py | 85 |
| import time | 86 | 87 | def demo(func): | 88 | defwrapper(*args**kwargs): |
| 89 | res=func(*args**kwargs) | 90 | return res | 91 | wrapper. |
| name | 二 | func. | name | 92 | wrapper. |
| doc | func. | doc | 93 | returnwrapper | 94 |
| 95 | ademo | 96 | def index（）： | 97 | 98 |
| index功能 | 99 | 100 | print（进入index页面 | 101 | time.sleep(3) |
| 102 | 103 | print('-- | 函数名 | 104 | print(index. |
| name | 105 | index() | Run: | 01装饰器× | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/PYTHON/01 装饰器·py |
| 函数名： | index | 注释信息1 | index功能 | 导 | 注释信息2- |
<!-- OCR_END -->

￼

但是...咱们可以看看一个函数下面有多少个__xxx__的方法，上面才有两个

<!-- OCR_START -->
- PYTHON
- YTHONI
- 01装饰器.py
- 01函数对象.py
- 02函数嵌套.py
- 03名称空间与作用域.py
- 04闭包函数.py
- 87
- detdemo(func):
- 88
- def
- wrapper(*args**kwargs):
- 89
- res=func(*args,**kwargs)
- 90
- return res
- 91
- wrapper.
- _name
- func.
- 92
- doc
- 93
- 94
- return
- objec
- 95
- FunctionTy
- 96
- ademo
- _annotations
- 97
- call
- （self,args,kwargs)
- 98
- class
- obje
- 99
- indexI
- closure_
- FunctionType
- 100
- code
- 101
- print(
- defaults
- 102
- time.s
- delattr
- （self,name)
- object
- 103
- 104
- dict
- printc:
- 105
- print（inde
- dir
- (self)
- 106
- pn
- nhier
- Press ^.to choose the selected (or first) suggestion and insert a dot afterwards ≥
- 107
- nnint(indov
- demo)
- Run:
- 01装饰器
<!-- OCR_END -->

￼

我们需要使用python内置的一个装饰器

```plain
from functools import wraps
import time
def demo(func):
    @wraps(func)
    def wrapper(*args,**kwargs):
        res=func(*args,**kwargs)
        return res
    return  wrapper
@demo
def index():
    """
    index功能
    """
    print('进入index页面')
    time.sleep(3)
print('--- 函数名：---')
print(index.__name__)
print('--- 注释信息1 ---')
print(index.__doc__)
print('--- 注释信息2 ---')
print(help(index))
```

<!-- OCR_START -->
- PYTHON
- 01装饰器.py
- 01函数对象.pyx
- 02函数嵌套.pyx
- 03名称空间与作用域.pyx
- 04闭包函数.py
- 82
- #print（res)
- 83
- 84
- from functools import wraps
- 85
- import time
- 86
- 87
- def demo(func）:
- 88
- awraps(func)
- 89
- def wrapper(*args**kwargs）:
- 90
- res=func(*args**kwargs)
- 91
- return res
- 92
- returnwwrapper
- 93
- 94
- ademo
- 95
- def index（）:
- 96
- 97
- index功能
- 98
- 99
- print（进入index页面）
- 100
- time.sleep(3)
- 101
- 102
- printC'-
- 函数名：
- nuin+/inday
- demo()wrapper()
- Run:
- 01装饰器X
- index
- 注释信息1
- 注释信息2-
- Help on function index in modulemain
- None
- Process finished with exit code 0
<!-- OCR_END -->

￼

> 更新: 2020-06-25 10:50:22  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/lcppir>