# Python进阶35-Django Auth组件

## Python进阶35-Django Auth组件

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(2) 评论(0)

* [什么是Auth模块](https://blog.driverzeng.com/zenglaoshi/5919.html#toc_0)
* [auth模块用法](https://blog.driverzeng.com/zenglaoshi/5919.html#toc_1)
* [Auth模块功能详解](https://blog.driverzeng.com/zenglaoshi/5919.html#toc_2)
* [扩展默认的auth_user表](https://blog.driverzeng.com/zenglaoshi/5919.html#toc_3)

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

## 什么是Auth模块

***

| 介绍 |
| :--- |

Auth模块是Django自带的用户认证模块：

我们在开发一个网站的时候，无可避免的需要设计实现网站的用户系统。此时我们需要实现包括用户注册、用户登录、用户认证、注销、修改密码等功能，这还真是个麻烦的事情呢。

Django作为一个完美主义者的终极框架，当然也会想到用户的这些痛点。它内置了强大的用户认证系统--auth，它默认使用 auth_user 表来存储用户数据。

## auth模块用法

***

| 创建项目 |
| :--- |

<!-- OCR_START -->
- New Project
- Pure Python
- Location:
- /Users/driverzeng/PycharmProjects/auth_module
- dj Django
- Flask
- Project Interpreter:Python 3.6
- Google App Engine
- Pyramid
- More Settings
- WWeb2Py
- Template language:
- Django
- Scientific
- Angular CLI
- Templates folder:
- templates
- A AngularJs
- B Bootstrap
- Application name:
- appo1
- EFoundation
- Enable Django admin
- 5HTML5 Boilerplate
- ReactApp
- React Native
- 曾老湿
- Cancel
- Create
- DriverZeng
<!-- OCR_END -->

￼

数据库迁移

```plain
MacBook-pro:auth_module driverzeng$ python3 manage.py makemigrations
MacBook-pro:auth_module driverzeng$ python3 manage.py migrate
```

<!-- OCR_START -->
- djauth_module
- #CCE
- settings.pyx
- urls.py
- login.html
- views.py
- main.auth_user[db]
- Database
- Orows
- Tx:Auto
- Tab-se...d(TSV)
- DDL
- ViewQuery
- <Filter criteria>
- db1
- dlastloginis_superuser
- firstnamelastnameemailis_staffis_activedatejoined
- username
- schemas1
- main
- auth_group
- auth_group_permiss
- auth_permission
- auth_user
- auth_user_groups
- auth_user_user_perr
- django_admin_log
- django_contenttypr
- django_migrations
- django_session
- sqlite_master
- sqlite_sequence
- collations 3
- 曾老湿
- DriverZenc
<!-- OCR_END -->

￼

这个表里的用户，不能直接往里面写，得使用命令，还是运行manage.py

```plain
# 创建超级用户
MacBook-pro:auth_module driverzeng$ python3 manage.py createsuperuser
```

<!-- OCR_START -->
MacBook-pro:auth_moduledriverzeng$python3manage.pymanage.pycreatesuperuser
Unknowncommand:'manage.py
Type'manage.pyhelp'forusage.
MacBook-pro:auth_moduledriverzeng$python3manage.pycreatesuperuser
Username(leaveblanktouse'driverzeng'):zls
Emailaddress:123@qq.com
Password:
Password(again)
Thepasswordistoosimilartotheemailaddress
Thispasswordistooshort.Itmustcontainatleast8characters.
Thispasswordisentirelynumeric
Error:Yourpasswordsdidn'tmatch.
Superusercreatedsuccessfully.
曾老湿
uth_moduledriverzeng$
DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- djauth_module
- #CCE
- settings.py
- urls.pyx
- login.htmlx
- views.py
- main.auth_user[db]>
- Database
- 1row
- Tx:Auto
- DE
- Tab-se...d(TsV)
- DDL
- ViewQuery
- Q<Filter criteria>
- 7
- db1
- idpassword
- lastlogin
- is_superuser
- firstnamelastname
- email
- schemas1
- 1pbkdf2_sha256$36000$s8mcxB9GAjgd$NgFY88rEUPIYROWjQNv.<nuLl>
- 123@qq.com
- main
- 1
- auth_group
- auth_group_permiss
- auth_permission
- 曾老湿
- auth_user
- DriverZeng
<!-- OCR_END -->

￼

***

| 模板层 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
</head>
<body>
<form action="" method="post">
    {% csrf_token %}
    <div>
        <lable>用户:<input type="text" name="name"></lable>
    </div>
    <div>
        <lable>密码:<input type="text" name="pwd"></lable>
    </div>
    <input type="submit" value="登录">
</form>
</body>
</html>
```

***

| 视图层 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
from django.contrib import auth
def login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    elif request.method == 'POST':
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        user = auth.authenticate(request,username=name,password=pwd)
        ## 相当于：user = models.User.objects.filter(name=name,pwd=pwd).first()
        if user:
            return HttpResponse('登录成功')
        else:
            return HttpResponse('用户名或密码错误')
```

***

| 路由层 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.login),
]
```

<!-- OCR_START -->
- 登录页面
- 招商
- →C
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanIUseiview
- 组件|Element
- 用户：zls
- 密码：zls12345
- 登录
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
127.0.0.1:8000/login/
招商
C127.0.0.1:8000/login/
应用zabbix-apiCanlUseiview组件|Element
登录成功
曾老湿
<!-- OCR_END -->

￼

## Auth模块功能详解

***

| 登录 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
from django.contrib import auth
def login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    elif request.method == 'POST':
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        user = auth.authenticate(request,username=name,password=pwd)
        ## 相当于：user = models.User.objects.filter(name=name,pwd=pwd).first()
        if user:
            # 登录，其实就是把用户的信息放到session中
            auth.login(request,user)
            ## 之前是这样 request.session['name'] = name
            return HttpResponse('登录成功')
        else:
            return HttpResponse('用户名或密码错误')
```

<!-- OCR_START -->
- 127.0.0.1:8000/login
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 登录成功
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- diauth_module
- G#COE
- settings.py
- urls.py x
- login.htmlx
- views.py
- main.django_session[db]
- auth_user[db]x
- Database
- 1row
- Tx:Auto
- Tab-se...d(TSV)
- DDL
- ViewQuery
- <Filter criteria>
- db1
- session_key
- session_data
- expire_date
- schemas1
- iqr5anh61r9o4yfshltb1k56fenuso10 NzNhYjQ1YTFhZjNLMjc4YTLmMjMzNWYwNDZlZDNjMTY5MGQwZDh..
- 2:33:53.532525
- main
- auth_group
- auth_group_permiss
- auth_permission
- auth_user
- auth_user_groups
- auth_user_user_perr
- django_admin_log
- django_content_typ
- django_migrations
- 曾老湿
- django_session
- Driver Zeng
<!-- OCR_END -->

￼

***

| 取出当前登陆用户 |
| :--- |

只要登录成功，之后在任意视图，都可以取出该用户，这个功能太强大了，省了我们很多事

```plain
def test(request):
    user=request.user
    print(user)
    return HttpResponse('当前登录的用户：%s' % user)
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.login),
    url(r'^test/', views.test),
]
```

<!-- OCR_START -->
127.0.0.1:8000/test/
→C127.0.0.1:8000/test/
应用zabbix-apiCanlUseiview组件IElement
当前登录的用户：zls
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
auth_moduleapp01
views.py
Project
settings.py
urls.pyx
login.htmlx
views.pyX
main.django_session[db]x
auth_user[db]x
auth_module ~/PycharmProjects/auth_module
from django.shortcuts import render HttpResponse,redirect
app01
#Create your views here.
migrations
from django.contrib import auth
_init_.py
def login(request）:
admin.py
ifrequest.method='GET':
apps.py
return render(request,login.html')
models.py
elif request.method='PoST':
name =request.PoST.get（'name')
tests.py
10
pwd= request.POST.get（'pwd')
11
user =auth.authenticate(request,username=name,password=pwd)
auth_module
12
#相当于：user=models.User.objects.filter（name=name.pwd=pwd）.first（)
13
ifuser:
14
#登录，其实就是把用户的信息放到session中
15
auth.login（requestuser)
urls.py
16
#之前是这样request.session[name]=name
wsgi.py
17
return HttpResponse（登录成功'）
templates
18
else:
db.sqlite3
19
returnHttpResponse（用户名或密码错误'）
manage.py
20
Ill External Libraries
21
def test(request):
22
user=request.user
Scratches and Consoles
23
print(user)
24
return HttpResponse（当前登录的用户：%s%user）
Run:
diauth_modulex
system cneck iaentitiea no issues (o sitencea).
June 21,2020-02:41:42
Django version 1.11.18,using settings 'auth_module.settings
Starting development server at http://127.0.0.1:8000/
Quit the server with coNTROL-C.
Performing system checks...
System check identified no issues (o silenced).
June21,2020-02:42:00
varwith CONTROL-C.
[21/3
[21/u
02:42.101
曾老湿
LS
Driver Zeng
<!-- OCR_END -->

￼

如果没有登录就会是一个匿名用户：`AnonymousUser`

<!-- OCR_START -->
- 127.0.0.1:8000/test/
- ←→C
- 8
- 应用zabbix-apiCanlUseiview
- 组件|Element
- 当前登录的用户：AnonymousUser
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Databasedbschemasmaindjango_session
- diauthmoduleG#C@E
- Project
- settings.py
- urls.pyx
- login.htmlx
- views.py
- main.django_session[db]x
- auth_user[db]x
- Database
- auth_module~/PycharmProjects/auth_module
- 0rows
- 1
- Tx:Auto
- Tab-se.d（TSVDDLViewQuery+G
- app01
- <Filter criteria>
- 8-db1
- migrations
- session_key
- session_data
- expire_date
- _init_.py
- schemas1
- admin.py
- main
- apps.py
- auth_group
- auth_group_permiss
- models.py
- auth_permission
- tests.py
- auth_user
- auth_module
- 田auth_user_groups
- auth_user_user_perr
- django_admin_log
- urls.py
- 田django_content_typ
- wsgi.py
- django_migrations
- templates
- django_session
- db.sqlite3
- sqlite_master
- sqlite_sequence
- manage.py
- lliExternal Libraries
- collations3
- Scratches and Consoles
- Run:
- diauth_module
- ：15]"GET/test/HTTP/1.1"20037
- 曾老湿
- honymousUser
<!-- OCR_END -->

￼

***

| 注销 |
| :--- |

```plain
def user_logout(request):
    auth.logout(request)
    user = request.user
    return HttpResponse('注销 [%s] 成功' %user)
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.login),
    url(r'^test/', views.test),
    url(r'^user_logout/', views.user_logout),
]
```

<!-- OCR_START -->
- settings.py
- urls.py
- login.html
- views.py
- main.django_session[db]
- auth_user[db]x
- 1row
- Tx:Auto
- Tab-se...d(TsV)
- DDL
- View Query
- <Filter criteria>
- session_key
- session_data
- expire_date
- 1
- t3r18ximft86an84eukwiqu6mt7ge768
- NzNhYjQ1YTFhZjNLMjc4YTLmMjMzNWYwNDZLZDNjMTY5MGQwZDh..2020-07-05 02:52:59.206789
<!-- OCR_END -->

￼

<!-- OCR_START -->
127.0.0.1:8000/user_logout/x
←→C
应用zabbix-apiCanlUseiview组件|Element
注销[zls]成功
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- diauth_moo
- settings.py
- urls.py
- login.html x
- views.py
- main.django_session[db]
- auth_user[db]x
- Orows
- Tx:Auto
- D6
- Tab-se...d(TsV)
- DDL
- ViewQuery
- <Filter criteria>
- session_key
- session_data
- expire_date
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 登录认证装饰器 |
| :--- |

目前 我有个test页面，不管用户有没有登录都可以访问，因为没有登录的时候，可以用匿名用户访问，Django内置了一个登录认证的装饰器，如果没有登录，或者是匿名用户，可以跳转到指定的页面

**模板层**

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>个人中心</title>
</head>
<body>
当前登录用户：{{ user }}
<div>
    <a href="/user_logout/">点我注销</a>
</div>
</body>
</html>
```

**视图层**

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.contrib.auth.decorators import login_required
# Create your views here.
from django.contrib import auth
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        user = auth.authenticate(request, username=name, password=pwd)
        ## 相当于：user = models.User.objects.filter(name=name,pwd=pwd).first()
        if user:
            # 登录，其实就是把用户的信息放到session中
            auth.login(request, user)
            ## 之前是这样 request.session['name'] = name
            return redirect('test')
        else:
            return HttpResponse('用户名或密码错误')
@login_required(redirect_field_name='zls', login_url='/login/')
def test(request):
    user = request.user
    print(user)
    return render(request,'test.html',locals())
def user_logout(request):
    user = request.user
    auth.logout(request)
    return redirect('/login/')
```

**路由层**

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.login),
    url(r'^test/', views.test),
    url(r'^user_logout/', views.user_logout),
]
```

<!-- OCR_START -->
- 登录页面
- →C
- 127.0.0.1:8000/login/zls=/test/
- 8
- 应用zabbix-api
- CanlUseiview
- 组件|Elemen
- 用户：
- 密码：
- 登录
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- ↑→C
- 127.0.0.1:8000/login/?zls=/test/
- 应用zabbix-api
- CanlUseiview组件|Element
- 用户：zls
- 密码：zls12345
- 登录
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 个人中心
- ←→C
- 127.0.0.1:8000/test/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 当前登录用户：zls
- 点我注销
- 曾老湿
<!-- OCR_END -->

￼

```plain
## 导入装饰器：from django.contrib.auth.decorators import login_required
## redirect_field_name 修改url的?后面传递的参数
## login_url 如果没有登录，跳转到页面
```

但是如果装饰器需要传递参数，如果有一万个视图函数，我就要传递一万次参数？很麻烦，所以Django帮我们做了一件事，settings文件中，修改即可。

```plain
LOGIN_URL = '/login/'
```

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.contrib.auth.decorators import login_required
# Create your views here.
from django.contrib import auth
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        user = auth.authenticate(request, username=name, password=pwd)
        ## 相当于：user = models.User.objects.filter(name=name,pwd=pwd).first()
        if user:
            # 登录，其实就是把用户的信息放到session中
            auth.login(request, user)
            ## 之前是这样 request.session['name'] = name
            return redirect('/test/')
        else:
            return HttpResponse('用户名或密码错误')
@login_required()
def test(request):
    user = request.user
    print(user)
    return render(request,'test.html',locals())
def user_logout(request):
    user = request.user
    auth.logout(request)
    return redirect('/login/')
```

***

| 用户注册 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.contrib.auth.decorators import login_required
# Create your views here.
from django.contrib import auth
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        user = auth.authenticate(request, username=name, password=pwd)
        ## 相当于：user = models.User.objects.filter(name=name,pwd=pwd).first()
        if user:
            # 登录，其实就是把用户的信息放到session中
            auth.login(request, user)
            ## 之前是这样 request.session['name'] = name
            return redirect('/test/')
        else:
            return HttpResponse('用户名或密码错误')
@login_required()
def test(request):
    user = request.user
    print(user)
    return render(request,'test.html',locals())
def user_logout(request):
    user = request.user
    auth.logout(request)
    return redirect('/login/')
from django.contrib.auth.models import User
def register(request):
    name='cls'
    pwd='123'
    ## 不能这么创建：密码不能是明文的
    ## user = User.objects.create(username=name,password=pwd)
    ## 创建超级用户
    #user = User.objects.create_superuser(username=name,password=pwd)
    ## 创建普通用户
    user = User.objects.create_user(username=name,password=pwd)
    return HttpResponse('用户：%s 注册成功' %user)
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.login),
    url(r'^test/', views.test),
    url(r'^user_logout/', views.user_logout),
    url(r'^register/', views.register),
]
```

<!-- OCR_START -->
127.0.0.1:8000/register/
←→C127.0.0.1:8000/register/
应用zabbix-apiCanlUseiview组件|Element
用户：cls注册成功
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- settings.py
- urls.py
- login.html x
- views.py
- test.html
- decorators.py
- main.django_session [db]
- main.auth_user[db]
- Database
- 2rows
- Tx:Auto
- Tab-se...d(TsV)
- DDL
- ViewQuery
- Q<Filter criteria>
- db1
- is_superuser
- first_name
- lastname
- email
- is_staff
- is_active
- date joined
- username
- schemas1
- 10642
- 123@qq.com
- 2020-06-20 14:10:47.634739
- zls
- main
- 2020-06-21 03:39:52.283207
- cls
- Da
- auth_group
- auth_group_permiss
- auth_permission
- 曾老湿
- auth_user
- DriverZeng
<!-- OCR_END -->

￼

***

| 校验密码 |
| :--- |

因为密码是加密的，所以我们不能直接拿出来，还得用Django给我们写的方法。

```plain
def check_pwd(request):
    pwd = '123'
    res = request.user.check_password(pwd)
    print(res)
    if res:
        return HttpResponse('密码校验成功')
    else:
        return HttpResponse('密码校验失败')
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.login),
    url(r'^test/', views.test),
    url(r'^user_logout/', views.user_logout),
    url(r'^register/', views.register),
    url(r'^check_pwd/', views.check_pwd),
]
```

<!-- OCR_START -->
- 127.0.0.1:8000/check_pwd/
- 别离开我啊，小老弟，点回来~
- ←→C
- 应用zabbix-apiCanlUseiview组件|Element
- 密码校验失败
- 曾老湿
<!-- OCR_END -->

￼

`zls`用户的密码是:`zls12345`

```plain
def check_pwd(request):
    pwd = 'zls12345'
    res = request.user.check_password(pwd)
    print(res)
    if res:
        return HttpResponse('密码校验成功')
    else:
        return HttpResponse('密码校验失败')
```

<!-- OCR_START -->
- 127.0.0.1:8000/check_pwd/
- 别离开我啊，小老弟，点回来～
- →C127.0.0.1:8000/check_pwd/
- 应用zabbix-api
- CanlUseiview
- 组件|Elemen
- 密码校验成功
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- auth_module
- app01views.py
- diauth_module
- G#CCE
- Project
- settings.py
- urls.pyx
- login.html
- views.pyx
- wsgi.pyx
- test.htmlxdecorators.pyxmain.django_sesson [db]x
- main.auth_user[db]x
- auth_module~/PycharmProjects/auth_module
- 27
- return render(request,'test.html'locals（）)
- app01
- migrations
- _init_.py
- 30
- def
- admin.py
- 31
- st.user
- 32
- auth.logo
- est)
- apps.py
- 33
- return redirect(/login/')
- models.py
- 34
- tests.py
- from django.contrib.auth.models import User
- views.py
- def register(request):
- 38
- name='cls
- 39
- 不能这么创建：蜜不能是明文的
- pwd='123
- 40
- urls.py
- 41
- #user=User.objects.create（username=namepassword=pwd)
- wsgi.py
- 42
- mplates
- 43
- 创建超级用户
- 创通用户
- word=pwd)
- test.html
- 45
- user =User.objects.create_user（usern
- ame=name,password=pwd)
- db.sqlite3
- 47
- return HttpResponse（‘用户：%s 注册成功%user）
- manage.py
- Il External Libraries
- 49
- def check_pwd（request):
- Scratches and Consoles
- 50
- res =request.user.check_password(pwd)
- print(res)
- 53
- ifres:
- return HttpResponse(密码校验成功'）
- 55
- else:
- 56
- checkpwd()ifres
- G→
- Starting development server at http://127.0.0.1:8000/
- Quit the server with coNTROL-C.
- [21/Jun/202003:47:43]GET/check_pwd/HTTP/1.120018
- False
- Performing system checks...
- System check identified no issues (0 silenced）.
- June21,2020-03:48:23
- Django version 1.11.18,using settingsauth_module.settings
- Ouit the s
- rver with CONTROL-C.
- 曾老湿
- 三6：TODODatabase Console
- Database Changes
- ②Event Log
<!-- OCR_END -->

￼

***

| 修改密码 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.login),
    url(r'^test/', views.test),
    url(r'^user_logout/', views.user_logout),
    url(r'^register/', views.register),
    url(r'^check_pwd/', views.check_pwd),
    url(r'^set_pwd/', views.set_pwd),
]
```

```plain
def set_pwd(request):
    pwd = 'zls111'
    user = request.user
    user.set_password(pwd)
    user.save()
    return HttpResponse('OK')
```

<!-- OCR_START -->
- 127.0.0.1:8000/set.pwd/
- →C127.0.0.1:8000/set.pwd/
- 应用zabbix-api
- CanlUseiview
- 组件|Elemen
- OK
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- ←→C
- 127.0.0.1:8000/login/
- 9
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 用户：zls
- 密码：zls12345
- 登录
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 127.0.0.1:8000/login/
- ←→C
- 8
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 用户名或密码错误
- 曾老湿
<!-- OCR_END -->

￼

注意：修改密码一定要 调用save方法，否则不保存。

***

| 是否认证通过 |
| :--- |

```plain
def auth_1(request):
    res = request.user.is_authenticated
    print(res)
    
    if res:
        return HttpResponse('认证成功')
    else:
        return HttpResponse('认证失败')
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.login),
    url(r'^test/', views.test),
    url(r'^user_logout/', views.user_logout),
    url(r'^register/', views.register),
    url(r'^check_pwd/', views.check_pwd),
    url(r'^set_pwd/', views.set_pwd),
    url(r'^auth_1/', views.auth_1),
]
```

<!-- OCR_START -->
127.0.0.1:8000/auth_1/
←→C
应用zabbix-apiCanlIUseiview组件|Element
认证成功
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- auth_module[~/PycharmProjects/auth_module]
- /app01/views.py[auth_module]
- auth_moduleapp01views.py
- Project
- setings.py
- urls.pyx
- login.html
- views.pyx
- wsgi.pyx
- test.html
- decorators.py
- main.django_session[db]x
- 42
- app01
- 43
- #创建超级用户
- migrations
- 44
- #user =User.objects.create superuser（username=name,password=pwd)
- _init_.py
- 45
- ##创建普通用户
- 46
- user =User.objects.create_user(username=name,password=pwd)
- admin.py
- return HttpResponse（用户：%s 注册成功%user）
- apps.py
- 48
- models.py
- 49
- def check_pwd(request):
- tests.py
- 50
- pwd=zls12345
- 51
- views.py
- res =request.user.check_password(pwd)
- 52
- print(res)
- auth_module
- 53
- if res:
- 54
- return HttpResponse（密码校验成功'）
- settings.py
- else:
- urls.py
- 55
- wsgi.py
- 58
- def set_pwd(request):
- templates
- 59
- pwd='zls111'
- 60
- user= request.user
- 61
- user.set_password(pwd)
- db.sqlite3
- 62
- user.save()
- manage.py
- 63
- return HttpResponse（'ok')
- ll External Libraries
- 64
- 65
- def auth 1(request):
- Scratches and Consoles
- 66
- res=request.user.is_authenticated
- 67
- 68
- 69
- 70
- return HttpResponse（'认证成功'）
- 71
- 72
- Run:
- diauth_module
- System check identified no issues (0 silenced).
- June 21,2020-04:07:18
- Django version 1.11.18, using settings 'auth_module.settings'
- Starting development server at http://127.0.0.1:8000/
- Quit the server with cONTROL-C.
- [21/Jun/202004:07:31]"GET/auth_1 HTTP/1.1"3010
- CallableBool(False)
- [21/Jun/202004:07:34]
- "GET/Login/HTTP/1.1" 200 507
- [21/Jun/2020 04:07:41]"POST/Login/HTTP/1.1"3020
- zls
- [21/Jun/202004:07:41]
- "GET/test/HTTP/1.1"200 217
- CallableBool(True)
- 曾老湿
- 21/Jun/202004:07:45]"GET/auth_1/HTTP/1.1"20012
- Driver Zeng
<!-- OCR_END -->

￼

该方法，主要不是在视图使用，是在模板中使用。

***

| 封号和后台管理 |
| :--- |

is_staff ： 用户是否拥有网站的管理权限.

is_active ： 是否允许用户登录, 设置为 False，可以在不删除用户的前提下禁止用户登录。

## 扩展默认的auth_user表

这内置的认证系统这么好用，但是auth_user表字段都是固定的那几个，我在项目中没法拿来直接使用啊！

比如，我想要加一个存储用户手机号的字段，怎么办？

聪明的你可能会想到新建另外一张表然后通过一对一和内置的auth_user表关联，这样虽然能满足要求但是有没有更好的实现方式呢？

答案是当然有了。

我们可以通过继承内置的 AbstractUser 类，来定义一个自己的Model类。

这样既能根据项目需求灵活的设计用户表，又能使用Django强大的认证系统了。

**两种方式，复用User表**

***

| 一对一关联auth_user表 |
| :--- |

```plain
from django.db import models
# Create your models here.
from django.contrib.auth.models import User
class UserDetail(models.Model):
    phone = models.CharField(max_length=32)
    # 如果是从外部引入的表模型是不能加 引号的
    #user = models.OneToOneField(to='User')
    user = models.OneToOneField(to=User)
```

数据库迁移

```plain
MacBook-pro:~ driverzeng$ cd /Users/driverzeng/PycharmProjects/auth_module
MacBook-pro:auth_module driverzeng$ python3 manage.py makemigrations
MacBook-pro:auth_module driverzeng$ python3 manage.py migrate
```

<!-- OCR_START -->
- settings.py
- urls.py
- login.html
- views.py
- models.py
- main.app01_userdetail[db]
- wsgi.py
- test.html
- 三2
- Database
- Orows
- Tx:Auto
- Tab-se...d(TSV)
- DDL
- ViewQuery
- 交+
- GV
- Q<Filter criteria>
- 8db1
- idphone
- user_id
- schemas1
- main
- app01_userdetail
- auth_group
- 曾老湿
- auth_group_permissions
- auth pe
- mission
<!-- OCR_END -->

￼

***

| 定义表模型继承 |
| :--- |

```plain
from django.contrib.auth.models import AbstractUser
class UserInfo(AbstractUser):
    """
    用户信息表
    """
    nid = models.AutoField(primary_key=True)
    phone = models.CharField(max_length=11, null=True, unique=True)
    
    def __str__(self):
        return self.username
```

**注意：**

按上面的方式扩展了内置的auth_user表之后，一定要在settings.py中告诉Django，我现在使用我新定义的UserInfo表来做用户认证。写法如下：

```plain
# 引用Django自带的User表，继承使用时需要设置
AUTH_USER_MODEL = "app01.UserInfo"
```

**再次注意：**

一旦我们指定了新的认证系统所使用的表，我们就需要重新在数据库中创建该表，而不能继续使用原来默认的auth_user表了。

> 更新: 2020-06-25 11:40:54  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/soz5ho>