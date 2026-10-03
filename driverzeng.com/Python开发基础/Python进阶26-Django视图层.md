# Python进阶26-Django 视图层

## Python进阶26-Django 视图层

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

* [创建Django项目](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_0)
* [静态文件配置](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_1)
* [完整版登陆功能](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_2)
* [新手三件套](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_3)
* [HttpRequest对象](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_4)
* [HttpResponse对象](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_5)
* [JsonResponse](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_6)
* [CBV和FBV](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_7)
* [简单的文件上传](https://blog.driverzeng.com/zenglaoshi/5552.html#toc_8)

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

## 创建Django项目

***

| 图形创建项目 |
| :--- |

<!-- OCR_START -->
- New Project
- Pure Python
- Project Interpreter:Python 3.6
- dj Django
- New environment using
- Flask
- Virtualenv
- Google App Engine
- Location:
- /Users/driverzeng/PycharmProjects/login/venv
- Pyramid
- WWeb2Py
- Base interpreter:
- /usr/loca/bin/python3.6
- Scientific
- Inherit global site-packages
- Angular CLI
- Make available to all projects
- A AngularJS
- Existing interpreter
- B Bootstrap
- Interpreter
- EFoundation
- Python 3.6/Library/Frameworks/Python.framework/Versions/3.6/bin/pyt
- 5 HTML5 Boilerplate
- More Settings
- ReactApp
- React Native
- Template language:
- Django
- Templates folder:
- templates
- Application name:
- Enable Django admin
- 曾老湿
- Cancel
- Create
- Driver Zeng
<!-- OCR_END -->

￼

***

| 创建app |
| :--- |

```plain
MacBook-pro:login driverzeng$ python3 manage.py startapp app01
```

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 排名 | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| login[~/PycharmProjects/login]-../login/urls.py[login] | login | Project | settings.py | urls.py | login~/PycharmProjects/login |
| #login URL Configuration | app01 | 2 | 3 | The urlpatterns list routes URLs to views. For more information please see: | migrations |
| 4 | https://docs.djangoproject.com/en/1.11/topics/http/urls/ | _init_.py | 5 | Examples: | admin.py |
| Function views | apps.py | 7 | 1.Add an import: from my_app import views | models.py | 2.Add a URL to urlpatterns:url（r'^$',views.home, name='home') |
| tests.py | 9 | Class-based views | 10 | 1.Add an import: from other_app.views import Home | views.py |
| 11 | 2.Add a URL to urlpatterns: url（r'$',Home.as_view（), name=home') | login | 12 | Including another URLconf | init_.py |
| 13 | 1.Import the include() function: from django.conf.urls import url, include | settings.py | 14 | 2.Add a URL to urlpatterns:url（r'blog/',include('blog.urls'）) | urls.py |
| 15 | 16 | import ... | wsgi.py | 18 | templates |
| 19 | urlpatterns=[ | manage.py | 20 | url(radmin/',admin.site.urls), | 曾老湿 |
<!-- OCR_END -->

￼

***

| 在settings中配置app |
| :--- |

<!-- OCR_START -->
login [~/PycharmProjects/login]-./login/settings.py [login]
loginlogin
settings.py
Project
urls.pyx
login ~/PycharmProjects/login
For more information on this file, see
app01
migrations
8
_init_.py
9
For the full list of settings and their values, see
10
admin.py
11
apps.py
12
models.py
13
import os
14
tests.py
15
#Build paths inside the project like this:os.path.join(BASE_DIR,
views.py
16
BASE_DIR=os.path.dirname(os.path.dirname(os.path.abspath（_file)))
login
17
18
19
#Quick-start development settings -unsuitable for production
urls.py
20
#See https://docs.djangoproject.com/en/1.11/howto/deployment/checklist/
21
wsgi.py
22
#SECURITY WARNING:keep the secret key used in production secret!
templates
23
SECRET_KEY='5v4Lb1v（_rp8%r##)10!ea=y3sx12onkvy0mad1hp5=rl6y4u@'
manage.py
24
Illi External Libraries
25
#SECURITY WARNING: don't run with debug turned on in production！
Scratches and Consoles
26
DEBUG=True
27
28
ALLOWED_HOSTS=[]
29
30
31
#Application definition
32
33
INSTALLED_APPS=
34
django.contrib.admin',
35
'django.contrib.auth',
36
'django.contrib.contenttypes'
37
'django.contrib.sessions
38
'django.contrib.messages'
39
'django.contrib.staticfiles'
40
41
42
43
MIDDLEWARE=[
44
'django.middleware.security.SecurityMiddleware',
45
'django.contrib.sessions.middleware.SessionMiddleware'
46
django.middleware.common.CommonMiddleware',
47
django.middleware.csrf.CsrfViewMiddleware',
48
'django.contrib.auth.middleware.AuthenticationMiddleware'
49
django.contrib.messages.middleware.MessageMiddleware',
50
django.middleware.clickjacking.XFrameOptionsMiddleware',
51
52
53
ROOT_URLCONF='login.urls'
曾老湿
54
TEMDIATEC
Driver Zeng
<!-- OCR_END -->

￼

## 静态文件配置

***

| 基操 |
| :--- |

创建路由，写视图

**urls.py**

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url('login', views.login),
]
```

**views.py**

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def login(request):
    return HttpResponse('login')
```

<!-- OCR_START -->
- 127.0.0.1:8080/login
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- login
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 前端页面 |
| :--- |

创建一个static目录，将bootstrap环境copy进去

<!-- OCR_START -->
- 曾老湿

```text
login ~/PycharmProjects/login
app01
migrations
init_.py
admin.py
apps.py
models.py
tests.py
views.py
login
settings.py
urls.py
wsgi.py
static
bootstrap-3.3.7-dist
CSS
fonts
js
templates
db.sqlite3
manage.py
Libraries
DriverZeng
es and Consoles
```
<!-- OCR_END -->

￼

修改视图，返回一个页面

**views.py**

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def login(request):
    return render(request,'login.html')
```

**login.html**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- 引入bootstrap -->
    <link rel="stylesheet" href="../static/bootstrap-3.3.7-dist/css/bootstrap.css">
    <title>曾老湿登录页面</title>
</head>
<body>
</body>
</html>
```

<!-- OCR_START -->
- 曾老湿登录页面
- ←→C
- 127.0.0.1:8080/login
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 會志高翔（DriverZe
- Elements
- Console Sources
- Network
- Performance
- Memory
- Application
- Security
- 1
- QPreserve logDisable cacheOnline
- 全业
- 5ms
- 10ms
- 15ms
- 20ms
- 25ms
- 30ms
- 35ms
- 40ms
- 45ms
- 50ms
- 55ms
- 60ms
- 65ms
- 70ms
- 75ms
- 80ms
- 85ms
- 90ms
- 95ms
- 100ms
- 105ms
- 11
- Preview
- ResponseInitiator Timing
- logir
- General
- RequestURLhttp://127.0.0.1:8080/static/bootstrap-3.3.7-dist/css/bootstrap.css
- Request Method: GET
- StatusCode:404Not Found
- Remote Address:127.0.0.1:8080
- 曾老湿
- ReferrerPolicy
<!-- OCR_END -->

￼

会发现，卧槽，为啥找不到呢？我们需要在`settings`中做设置

**settings.py**

```plain
"""
Django settings for login project.
Generated by 'django-admin startproject' using Django 1.11.18.
For more information on this file, see
https://docs.djangoproject.com/en/1.11/topics/settings/
For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.11/ref/settings/
"""
import os
# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.11/howto/deployment/checklist/
# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '5v4lb1v(_rp&%r##)10!ea=y3sxl2onkvy0mad1hp5=rl6y4u@'
# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True
ALLOWED_HOSTS = []
# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'app01',
]
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
ROOT_URLCONF = 'login.urls'
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')]
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
WSGI_APPLICATION = 'login.wsgi.application'
# Database
# https://docs.djangoproject.com/en/1.11/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
# Password validation
# https://docs.djangoproject.com/en/1.11/ref/settings/#auth-password-validators
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]
# Internationalization
# https://docs.djangoproject.com/en/1.11/topics/i18n/
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_L10N = True
USE_TZ = True
# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.11/howto/static-files/
STATIC_URL = '/static/'
##  添加下面的内容，添加static的路径
STATICFILES_DIRS =  [
    os.path.join(BASE_DIR,'static'),
]
```

**修改login.html**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.css">
    <title>曾老湿登录页面</title>
</head>
<body>
</body>
</html>
```

<!-- OCR_START -->
- 曾老湿登录页面
- ←→C
- 127.0.0.1:8080/login
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element曾志高翔（DriverZe
- Elements
- QPreserve logDisablecache
- Online
- 5ms
- 10ms
- 15ms
- 20ms
- 25ms
- 30ms
- 35ms
- 40ms
- 45ms
- 50ms
- 55ms
- 60ms
- 65ms
- 70ms
- 75ms
- 80ms
- 85ms
- 90ms
- 95ms
- 100ms
- 105ms
- Name
- InitiatorTiming
- login
- RequestURL:http://127.0.0.1:8080/static/bootstrap-3.3.7-dist/css/bootstrap.css
- Request Method: GET
- Status Code:200 0K
- RemoteAddress:127.0.0.1:8080
- 曾老湿
- ReferrerPolicy:no-referrer-when-downgrade
<!-- OCR_END -->

￼

***

| 总结 |
| :--- |

```plain
模板文件配置:
    1 templates文件夹
    2 settings里注册一下
    
静态文件配置:
    1 STATIC_URL = '/static/'    一般不要改
    2 创建一个static文件夹       一般不要改
    3 STATICFILES_DIRS=[
        os.path.join(BASE_DIR, 'static'),  创建的文件夹路径(可以写多个)
        ]
```

## 完整版登陆功能

***

| 登录页面 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.css">
    <title>曾老湿登录页面</title>
</head>
<body>
<h1>登录</h1>
<div class="col-md-6 col-md-offset-3">
   <form action="http://127.0.0.1:8080/login" method="post">
       <p>
           用户:<input type="text" name="name" class="alert-success">
       </p>
       <p>
           密码:<input type="password" name="pwd" class="alert-info">
       </p>
       <input type="submit" value="提交" class="btn-info">
    </form>
</div>
</body>
</html>
```

***

| 后台提交数据 |
| :--- |

在浏览器访问页面：<http://127.0.0.1:8080/login>

会打印出提交两个字。

<!-- OCR_START -->
- 提交
- 曾老湿

```text
loginapp01views.py
Project
settings.pyx
urls.pyX
views.pyX
login.html x
login~/PycharmProjects/login
from django.shortcuts import render,HttpResponse,redirect
app01
migrations
_init_.py
def login(request):
print（提交）
admin.py
return render(request,'login.html')
apps.py
models.py
tests.py
views.py
login
_init_.py
settings.py
urls.py
wsgi.py
static
bootstrap-3.3.7-dist
CSS
fonts
js
templates
login.html
db.sqlite3
manage.py
lliExternal Libraries
Scratches and Consoles
Run:
dij loginx
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/login/manage.pyrunserver 8080
Performing system checks...
System check identified no issues (o silenced).
You have 13 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
June 12,2020-12:43:33
Django version 1.11.18,using settings'login.settings'
Startingdevelopmentserverathttp://127.0.0.1:8080/ Ouit the server with CoNTROL-C.
[12/Jun/202012:43:37]GET/loginHTTP/1.1200606
```
<!-- OCR_END -->

￼

但是，如果我输入东西，再提交，页面就会报错403

￼

目前解决方案，先在settings.py文件中，把csrf中间件注释掉。

<!-- OCR_START -->
settings.py
urls.pyx
views.py
login.html
32
33
INSTALLED APPS=
34
'django.contrib.admin'
35
django.contrib.auth'，
36
'django.contrib.contenttypes'
37
django.contrib.sessions'
38
'django.contrib.messages'
39
django.contrib.staticfiles'
40
'app01',
41
-1
42
43
MIDDLEWARE =[
44
django.middleware.security.SecurityMiddleware'
45
django.contrib.sessions.middleware.SessionMiddleware
46
diango.middleware.common.CommonMiddleware'
47
'django.middleware.csrf.CsrfViewMiddleware'
48
django.contrib.auth.middleware.AuthenticationMiddleware
49
django.contrib.messages.middleware.MessageMiddleware'
50
django.middleware.clickjacking.XFrameOptionsMiddleware
51
52
53
ROOT_URLCONF ='login.urls
54
55
TEMPLATES=[
56
57
BACKEND':'django.template.backends.django.DjangoTemplates'
58
DIRS':[os.path.join（BASE_DIR,'templates')]
59
60
'APP_DIRS':True，
61
OPTIONS':
'context_processors':[
曾老湿
django.template.context_processors.debug'
DriverZeng
<!-- OCR_END -->

￼

然后我们取出数据

**views.py**

```plain
from django.shortcuts import render, HttpResponse, redirect
import pymysql
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        ## 连接数据库
        conn = pymysql.connect(host='10.0.0.51', user='zls', password='123', port=3306, db='zls')
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.execute('select * from user where name=%s and password=%s', [name, pwd])
        user = cursor.fetchone()
        if user:
            return HttpResponse('登录成功')
        else:
            return HttpResponse('用户名密码错误')
```

<!-- OCR_START -->
- 曾老湿登录页面
- ←→C
- 127.0.0.1:8080/login
- 9
- 应用zabbix-api
- CanlUseiview
- 组件IElem
- 曾志高翔（DriverZe
- 登录
- 用户：zls
- 密码
- 提交
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
127.0.1:8080/login
C127.0.0.1:8080/login
应用zabbix-apiCanIUseiview组件IElement曾志高翔（DriverZe.
登录成功
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 127.0.0.1:8080/login
- ←→C
- 应用zabbix-api
- CanlUse
- iview
- 组件|Elem
- 曾志高翔（DriverZe
- 用户名密码错误
- 曾老湿
<!-- OCR_END -->

￼

**总结：**

一个视图函数，简称视图，是一个简单的Python 函数，它接受Web请求并且返回Web响应。响应可以是一张网页的HTML内容，一个重定向，一个404错误，一个XML文档，或者一张图片. . . 是任何东西都可以。无论视图本身包含什么逻辑，都要返回响应。代码写在哪里也无所谓，只要它在你的Python目录下面。除此之外没有更多的要求了——可以说“没有什么神奇的地方”。为了将代码放在某处，约定是将视图放置在项目或应用程序目录中的名为views.py的文件中。

```plain
## login.html  
        ***重点***
        一.action:提交到后台的地址三种写法:
          1.http://127.0.0.1:8080/login
          2./login/ 推荐使用
          3.空
        
        二.method POST方法
        三.<input type="submit" value="提交">或<button></button> ， type不可以是button
## 视图层:
        1 request.method  ----前台提交过来请求的方式
        2 request.POST(相当于字典)----post形式提交过来的数据,(http请求报文的请求体中)
        3 request.POST.get('name') ----推荐用get取值(取出列表最后一个值)
        4 request.POST.getlist('name')-----取出列表所有的值_
        5 前台get方式提交的数据,从request.GET字典里取
        
## 连接数据库(防止注入,推荐以下写法)
        cur.execute('select * from user where name=%s and password=%s ',[name,pwd])
## get请求和post请求:
    get:获取数据,页面,携带数据是不重要的数据(数据量有大小限制)
    post:往后台提交数据
```

## 新手三件套

```plain
from django.shortcuts import render, HttpResponse, redirect
## render 返回一个页面需要render
默认会去templates目录下找
## HttpResponse 返回一个信息
## redirect 页面跳转302
本质都是返回，HttpResponse的对象
```

**举例：登录成功跳转到其他页面**

```plain
from django.shortcuts import render, HttpResponse, redirect
import pymysql
from app01 import models
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        user = models.User.objects.filter(name=name, pwd=pwd).first()
        if user:
            return redirect('http://blog.driverzeng.com')
        else:
            return HttpResponse('用户名密码错误')
```

## HttpRequest对象

***

| 新建项目 |
| :--- |

<!-- OCR_START -->
- New Project
- Pure Python
- Location:
- /Users/driverzeng/PycharmProjects/shitu
- dj Django
- Flask
- Project Interpreter:Python 3.6
- Google App Engine
- Pyramid
- More Settings
- WWeb2Py
- Template language:
- Django
- i Scientific
- Angular CLI
- Templatesfolder:
- templates
- AngularJs
- B Bootstrap
- Application name:
- appo1
- Foundation
- EnableDjango admin
- 5
- HTML5 Boilerplate
- ReactApp
- React Native
- 曾老湿
- DriverZeng
- Cancel
- Create
<!-- OCR_END -->

￼

***

| 写视图函数 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def test(request):
    return HttpResponse('OK')
```

添加路由

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^test/', views.test),
]
```

<!-- OCR_START -->
- 127.0.0.1:8000/test/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe
- OK
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| request属性 |
| :--- |

django将请求报文中的请求行、首部信息、内容主体封装成 HttpRequest 类中的属性。 除了特殊说明的之外，其他均为只读的

```plain
'''
1.HttpRequest.GET
　　一个类似于字典的对象，包含 HTTP GET 的所有参数。详情请参考 QueryDict 对象。
2.HttpRequest.POST
　　一个类似于字典的对象，如果请求中包含表单数据，则将这些数据封装成 QueryDict 对象。
　　POST 请求可以带有空的 POST 字典 —— 如果通过 HTTP POST 方法发送一个表单，但是表单中没有任何的数据，QueryDict 对象依然会被创建。
   因此，不应该使用 if request.POST  来检查使用的是否是POST 方法；应该使用 if request.method == "POST"
　　另外：如果使用 POST 上传文件的话，文件信息将包含在 FILES 属性中。
   
   注意：键值对的值是多个的时候,比如checkbox类型的input标签，select标签，需要用：
        request.POST.getlist("hobby")
3.HttpRequest.body
　　一个字符串，代表请求报文的主体。在处理非 HTTP 形式的报文时非常有用，例如：二进制图片、XML,Json等。
　　但是，如果要处理表单数据的时候，推荐还是使用 HttpRequest.POST 。
4.HttpRequest.path
　　一个字符串，表示请求的路径组件（不含域名）。
　　例如："/music/bands/the_beatles/"
5.HttpRequest.method
　　一个字符串，表示请求使用的HTTP 方法。必须使用大写。
　　例如："GET"、"POST"
6.HttpRequest.encoding
　　一个字符串，表示提交的数据的编码方式（如果为 None 则表示使用 DEFAULT_CHARSET 的设置，默认为 'utf-8'）。
   这个属性是可写的，你可以修改它来修改访问表单数据使用的编码。
   接下来对属性的任何访问（例如从 GET 或 POST 中读取数据）将使用新的 encoding 值。
   如果你知道表单数据的编码不是 DEFAULT_CHARSET ，则使用它。
7.HttpRequest.META
 　　一个标准的Python 字典，包含所有的HTTP 首部。具体的头部信息取决于客户端和服务器，下面是一些示例：　　取值：
    CONTENT_LENGTH —— 请求的正文的长度（是一个字符串）。
    CONTENT_TYPE —— 请求的正文的MIME 类型。
    HTTP_ACCEPT —— 响应可接收的Content-Type。
    HTTP_ACCEPT_ENCODING —— 响应可接收的编码。
    HTTP_ACCEPT_LANGUAGE —— 响应可接收的语言。
    HTTP_HOST —— 客服端发送的HTTP Host 头部。
    HTTP_REFERER —— Referring 页面。
    HTTP_USER_AGENT —— 客户端的user-agent 字符串。
    QUERY_STRING —— 单个字符串形式的查询字符串（未解析过的形式）。
    REMOTE_ADDR —— 客户端的IP 地址。
    REMOTE_HOST —— 客户端的主机名。
    REMOTE_USER —— 服务器认证后的用户。
    REQUEST_METHOD —— 一个字符串，例如"GET" 或"POST"。
    SERVER_NAME —— 服务器的主机名。
    SERVER_PORT —— 服务器的端口（是一个字符串）。
 　　从上面可以看到，除 CONTENT_LENGTH 和 CONTENT_TYPE 之外，请求中的任何 HTTP 首部转换为 META 的键时，
    都会将所有字母大写并将连接符替换为下划线最后加上 HTTP_  前缀。
    所以，一个叫做 X-Bender 的头部将转换成 META 中的 HTTP_X_BENDER 键。
8.HttpRequest.FILES
　　一个类似于字典的对象，包含所有的上传文件信息。
   FILES 中的每个键为<input type="file" name="" /> 中的name，值则为对应的数据。
　　注意，FILES 只有在请求的方法为POST 且提交的<form> 带有enctype="multipart/form-data" 的情况下才会
   包含数据。否则，FILES 将为一个空的类似于字典的对象。
9.HttpRequest.COOKIES
　　一个标准的Python 字典，包含所有的cookie。键和值都为字符串。
10.HttpRequest.session
 　　一个既可读又可写的类似于字典的对象，表示当前的会话。只有当Django 启用会话的支持时才可用。
    完整的细节参见会话的文档。
11.HttpRequest.user(用户认证组件下使用)
　　一个 AUTH_USER_MODEL 类型的对象，表示当前登录的用户。
　　如果用户当前没有登录，user 将设置为 django.contrib.auth.models.AnonymousUser 的一个实例。你可以通过 is_authenticated() 区分它们。
    例如：
    if request.user.is_authenticated():
        # Do something for logged-in users.
    else:
        # Do something for anonymous users.
     　　user 只有当Django 启用 AuthenticationMiddleware 中间件时才可用。
     -------------------------------------------------------------------------------------
    匿名用户
    class models.AnonymousUser
django.contrib.auth.models.AnonymousUser 类实现了django.contrib.auth.models.User 接口，但具有下面几个不同点：
    id 永远为None。
    username 永远为空字符串。
    get_username() 永远返回空字符串。
    is_staff 和 is_superuser 永远为False。
    is_active 永远为 False。
    groups 和 user_permissions 永远为空。
    is_anonymous() 返回True 而不是False。
    is_authenticated() 返回False 而不是True。
    set_password()、check_password()、save() 和delete() 引发 NotImplementedError。
    New in Django 1.8:
    新增 AnonymousUser.get_username() 以更好地模拟 django.contrib.auth.models.User。
*/
```

## HttpResponse对象

***

| 响应对象主要有三种形式 |
| :--- |

1.HttpResponse()

2.render()

3.redirect()

HttpResponse()括号内直接跟一个具体的字符串作为响应体，比较直接很简单，所以这里主要介绍后面两种形式。

***

| render() |
| :--- |

```plain
render(request, template_name[, context]） 
## 结合一个给定的模板和一个给定的上下文字典，并返回一个渲染后的 HttpResponse 对象。
```

**参数：**

1.request： 用于生成响应的请求对象。

2.template_name：要使用的模板的完整名称，可选的参数

3.context：添加到模板上下文的一个字典。默认是一个空字典。如果字典中的某个值是可调用的，视图将在渲染模板之前调用它。

render方法就是将一个模板页面中的模板语法进行渲染，最终渲染成一个html页面作为响应体。

***

| redirect() |
| :--- |

传递要重定向的一个硬编码的URL

```plain
def my_view(request):
    ...
    return redirect('/some/url/')
```

也可以是一个完整的URL：

```plain
def my_view(request):
    ...
    return redirect('http://www.baidu.com/')
```

***

| 301和302的区别 |
| :--- |

```plain
1）301和302的区别。
　　301和302状态码都表示重定向，就是说浏览器在拿到服务器返回的这个状态码后会自动跳转到一个新的URL地址，这个地址可以从响应的Location首部中获取
  （用户看到的效果就是他输入的地址A瞬间变成了另一个地址B）——这是它们的共同点。
　　他们的不同在于。301表示旧地址A的资源已经被永久地移除了（这个资源不可访问了），搜索引擎在抓取新内容的同时也将旧的网址交换为重定向之后的网址；
　　302表示旧地址A的资源还在（仍然可以访问），这个重定向只是临时地从旧地址A跳转到地址B，搜索引擎会抓取新的内容而保存旧的网址。 SEO302好于301
 
2）重定向原因：
（1）网站调整（如改变网页目录结构）；
（2）网页被移到一个新地址；
（3）网页扩展名改变(如应用需要把.php改成.Html或.shtml)。
        这种情况下，如果不做重定向，则用户收藏夹或搜索引擎数据库中旧地址只能让访问客户得到一个404页面错误信息，访问流量白白丧失；再者某些注册了多个域名的
    网站，也需要通过重定向让访问这些域名的用户自动跳转到主站点等。
```

## JsonResponse

向前端返回一个json格式字符串的两种方式

```plain
# 第一种方式
import json
data={'name':'zls','age':18}
data1=['cls','zls']
return HttpResponse(json.dumps(data1))
    
# 第二种方式
from django.http import JsonResponse
data = {'name': 'zls', 'age': 18}
data1 = ['cls', 'zls']
# return JsonResponse(data)
return JsonResponse(data1,safe=False)
```

***

| 传中文 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
import json
# Create your views here.
def test(request):
    dic={'name':'曾老湿'}
    data=json.dumps(dic)
    print(data)
    return HttpResponse(data)
```

<!-- OCR_START -->
- 曾老湿

```text
shitu[~/PycharmProjects/shitu]
./app01/views.py[shitu]
shitu
app01
views.py
Project
settings.py
urls.py
views.py
sftp.htmlx
shitu ~/PycharmProjects/shitu
from django.shortcutsimportrender,HttpResponse,redirect
app01
2
import json
migrations
3
_init_.py
#Create your views here.
admin.py
5
apps.py
def test(request):
models.py
dic={’name:曾老湿’}
tests.py
data=json.dumps（dic)
10
print(data)
views.py
11
return HttpResponse(data)
shitu
_init_.py
settings.py
urlsnv
Run:
dishitu x
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/shitu/manage.py runserver 8000
Performing system checks...
System check identified no issues(o silenced).
You have 13 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s):admin, auth, contenttypes, sessions.
Run'python manage.py migrate'to apply them.
June14,2020-02:14:44
Django version 1.11.18,using settings'shitu.settings'
Startingdevelopmentserverathttp://127.0.0.1:8000/ Ouit the server with CONTROL-C.
"name":"\u66fe\u8001\u6e7f"}
DriverZeng
14/Jun/202002:14:50]
"GET/test/HTTP/1.1"20030
```
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 127.0.0.1:8000/test/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- ["name":"\u66fe\u8001\u6e7f"}
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
from django.shortcuts import render,HttpResponse,redirect
import json
# Create your views here.
def test(request):
    dic={'name':'曾老湿'}
    data=json.dumps(dic,ensure_ascii=False)
    print(data)
    return HttpResponse(data)
```

<!-- OCR_START -->
```text
shitu[~/PycharmProjects/shitu] -../app01/views.py[shitu]
shituapp01
views.py
Project
settings.py
urls.py
views.py
sftp.htmlx
shitu ~/PycharmProjects/shitu
fromdjango.shortcutsimportrenderHttpResponseredirect
import json
app01
migrations
# Create your views here.
_init_.py
admin.py
apps.py
def test(request):
models.py
dic={'name':曾老湿 data=json.dumps（dio tests.py ensure ascii=False)
10
print(data)
views.py
11
return HttpResponse(data)
shitu
_init_.py
settings.py
urlsnv
Run:
djshitux
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/shitu/manage.pyrunserver 8000
Performing system checks...
System check identified no issues (o silenced).
You have 13 unapplied migration（s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
June 14,2020-02:17:28
Django version 1.11.18,using settings'shitu.settings'
Starting developmentserver athttp://127.0.0.1:8000/ Quit the server with CONTROL-C.
["name”：“曾老湿”} 曾老湿 14/Jun/202002:17:30]"GET/test/HTTP/1.1"20021 DriverZeng
```
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 127.0.0.1:8000/test/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- {"name":"曾老湿"}
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
from django.shortcuts import render,HttpResponse,redirect
import json
from django.http import JsonResponse
# Create your views here.
def test(request):
    dic={'name':'曾老湿'}
    return JsonResponse(dic)
```

<!-- OCR_START -->
- 127.0.0.1:8000/test/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe..
- {"name":"\u66fe\u8001\u6e7f"}
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
from django.shortcuts import render,HttpResponse,redirect
import json
from django.http import JsonResponse
# Create your views here.
def test(request):
    dic={'name':'曾老湿'}
    return JsonResponse(dic,json_dumps_params={'ensure_ascii':False})
```

<!-- OCR_START -->
- 127.0.0.1:8000/test/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- {"name"：“曾老湿"}
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## CBV和FBV

CBV基于类的视图(Class base view)和FBV基于函数的视图（Function base view）

```plain
from django.views import View
class AddPublish(View):
    def dispatch(self, request, *args, **kwargs):
        print(request)
        print(args)
        print(kwargs)
        # 可以写类似装饰器的东西，在前后加代码
        obj=super().dispatch(request, *args, **kwargs)
        return obj
    def get(self,request):
        return render(request,'index.html')
    def post(self,request):
        request
        return HttpResponse('post')
```

路由配置

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    ## 使用AddPublish继承的View的as_view方法
    url(r'^test/', views.AddPublish.as_view()),
]
```

## 简单的文件上传

urls.py

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^upload/', views.sftp),
]
```

views.py

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def sftp(request):
    if request.method == 'GET':
        return render(request,'sftp.html')
    if request.method == 'POST':
        return HttpResponse('OK')
```

sftp.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>文件上传下载</title>
</head>
<body>
<form action="" method="post" enctype="multipart/form-data">
    <input type="file" name="myfile">
    <input type="submit" value="提交">
</form>
</body>
</html>
```

<!-- OCR_START -->
- 文件上传下载
- 127.0.0.1:8000/upload/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe..
- 选择文件
- 未选择任何文件
- 提交
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

断点测试

<!-- OCR_START -->
shituapp01views.py
Project
settings.py
urls.py
views.py
sftp.html
shitu~/PycharmProjects/shitu
from django.shortcuts import renderHttpResponseredirect
app01
#Create your views here.
migrations
_init_.py
def sftp（request）:r
est:<WSGIRequest:POST/upload/'>
admin.py
if request.method=
'GET':
apps.py
return render(request,'sftp.html')
models.py
frequest.method=
tests.py
return HttpResponse(oK')
shitu
sftp()
Debug:
dishitu
Console→
←+▼
request={WSGIRe
est)<WSGIRe
FILES={MultiValueDict}<MultiValueDict:{myfile':[<InMemoryUploadedFile:dibu.png(image/png)>]}>
_ge
后inne
GET={QueryDict}<QueryDict:0>
eworks/Python.framework/Versions/3.6/bin:/usr/local/bin:/usr/bin:/bin:/
POST={QueryDict}<QueryDict:0>
inn
_encoding=
[NoneType} None
_messages ={FallbackStorage)<django.contrib.messages.storage.fllback.FallbackStorage object at Ox10fe625co>
inne
_post_parse_error =(bool) False
口_C
_read_started ={bool} True
石inne
_stream=（LimitedStream)<django.
.core.handlers.wsgi.LimitedStreamobjectatOx10fe621d0>
_upload_handlers=(ImmutableList)（<django.core.files.uploadhandler.MemoryFileUploadHandlerobject at Ox10ff5cac8>,<django.core.files.uploadhandler.TemporaryFileUploadHandler object at Ox10ff5cb00>)
body=str)Traceback（mostrecent calllast：:nFil/pplications/yCharm.app/Contents/helperspydev/pydevdbundle/ydevdresolver.pyline66,ingetPyDictionarynattr=getatr(var,n）nFile/ibrary/Frameworks/ythoVi
_ci
content_params={dict)<class'dict'>:{boundary:----WebKitFormBoundarylHEX9q9B49u1iAxB}
content_type=(str)'multipart/form-data'
encoding ={NoneType}None
environ=
{dict)<classdict>:(PATH:/Users/driverzeng/.yarn/bin:/Users/driverzeng/.config/yarn/global/node_modules/bin:/usr/local/opt/openssl/bin:/Library/Frameworks/Python.framework/Versions/3.6/bin:/usr/loca/bin:/usr/bin:/binV
method={str}POST
path={str}'upload/
_C
path_info={str)/upload/
resolver_match={ResolverMatch}ResolverMatch(func=app01.views.sftp,args=0),kwargs=0,url_name=None,app_names=,namespaces=)
后han
scheme={str)http
三session=
(SessionStore)<django.contrib.sessions.backends.db.SessionStore object at 0x10fe62518>
曾老湿
<!-- OCR_END -->

￼

**接收文件体**

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def sftp(request):
    if request.method == 'GET':
        return render(request,'sftp.html')
    if request.method == 'POST':
        myfile=request.FILES.get('myfile')
        with open(myfile.name,'wb') as f:
            for line in myfile.chunks():
                f.write(line)
        return HttpResponse('OK')
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:31:30  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/liywu2>