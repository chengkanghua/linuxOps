# Python进阶27-Django 路由层

## Python进阶27-Django 路由层

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

* [创建Django项目](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_0)
* [路由层介绍](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_1)
* [有名分组，无名分组](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_2)
* [反向解析](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_3)
* [路由分发](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_4)
* [名称空间](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_5)
* [Django配置/和404](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_6)
* [Django 路由不自动加/(几乎不用)](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_7)
* [Django2.0 和 Django 1.0路由层区别](https://blog.driverzeng.com/zenglaoshi/5616.html#toc_8)

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
- Location:
- /Users/driverzeng/PycharmProjects/route
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
- AngularJS
- B Bootstrap
- Application name:
- appo1l
- Foundation
- Enable Django admin
- 5
- HTML5 Boilerplate
- ReactApp
- React Native
- 曾老湿
- Cancel
- Create
- Driver Zeng
<!-- OCR_END -->

￼

注释`settings.py`的csrf中间件

```plain
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    # 'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```

设置静态资源路径`settings.py`

```plain
STATIC_URL = '/static/'
STATICFILES_DIRS = [
    os.path.join(BASE_DIR,'static')
]
```

创建static

<!-- OCR_START -->
- 曾老湿

```text
route~/PycharmProjects/route
app01
route
init_.py
settings.py
urls.py
wsgi.py
static
templates
manage.py
lliExternal Libraries
s and Consoles
DriverZeng
```
<!-- OCR_END -->

￼

## 路由层介绍

***

| 作用 |
| :--- |

URL配置(URLconf)就像Django 所支撑网站的目录。它的本质是URL与要为该URL调用的视图函数之间的映射表；你就是以这种方式告诉Django，对于客户端发来的某个URL调用哪一段逻辑代码对应执行

```plain
from django.conf.urls import url
from django.contrib import admin
urlpatterns = [
    url(r'^admin/', admin.site.urls),
]
```

url是一个函数，传递两个参数，我们从app01项目中，导入views，从而关联视图函数

```plain
"""
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'publish', views.publish),
    url(r'publishadd', views.publishadd),
]
```

views.py

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def publish(request):
    if request.method == 'GET':
        return HttpResponse('publish GET is ok')
    elif request.method == 'POST':
        return HttpResponse('publish POST is ok')
def publishadd(request):
    if request.method == 'GET':
        return HttpResponse('publishadd GET is ok')
    elif request.method == 'POST':
        return HttpResponse('publishadd POST is ok')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publishadd/
- 0127.0.0.1:8000/publishadd/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- publish
- GETisok
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

卧槽，我明明访问的是publishadd，为啥给我返回的是publish的页面？

因为url那里放的是正则表达式，在url中匹配了publish就匹配成功了，所以返回publish页面

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/$', views.publish),
    url(r'^publishadd/$', views.publishadd),
]
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publishadd/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- publishaddGETisok
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 匹配年 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/[0-9]{4}$', views.publish),
    url(r'^publishadd/$', views.publishadd),
]
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publish/2020
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- publish GET is ok
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 匹配任意长度数字 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/\d+$', views.publish),
    url(r'^publishadd/$', views.publishadd),
]
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publish/202012x
- 127.0.0.1:8000/publish/20201238123812312312312312312
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- publish GET is ok
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

## 有名分组，无名分组

***

| 正则例子 |
| :--- |

```plain
import re
ret=re.search('(?P<year>[0-9]{4})/([0-9]{2})','2012/12')
print(ret.group())
print(ret.group(1))
print(ret.group(2))
print(ret.group('year'))
```

上面的示例使用简单的、没有命名的正则表达式组（通过圆括号）来捕获URL 中的值并以位置 参数传递给视图。在更高级的用法中，可以使用命名的正则表达式组来捕获URL 中的值并以关键字 参数传递给视图。

在Python 正则表达式中，命名正则表达式组的语法是(?Ppattern)，其中name 是组的名称，pattern 是要匹配的模式。

***

| 无名分组 |
| :--- |

下面是以上URLconf 使用命名组的重写：

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    # url(r'^publish/\d+$', views.publish),
    # url(r'^publishadd/$', views.publishadd),
    url(r'^publish/([0-9]{4})/$', views.publish),
]
```

<!-- OCR_START -->
别离开我啊，小老弟，点回来~
TypeErrorat/publish/2018/
←→C
127.0.0.1:8000/publish/2018/
G7
应用
zabbix-apiCanlUseiview组件|Element曾志高翔（Driverze
publishadd()takes1positionalargumentbut2weregiven
Request Method:GET
RequestURL:http://127.0.0.1:8000/publish/2018/
Django Version:1.11.18
ExceptionType:TypeError
Exception Value: publishadd(） takes 1 positional argument but 2 were given
ExceptionLocation:/ibrary/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/django/core/handlers/base.pyin_get_response,line185
PythonExecutable:/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6
Python Version:3.6.4
Python Path:['/Users/driverzeng/PycharmProjects/route',
/Users/driverzeng/PycharmProjects/route',
/Library/Frameworks/Python.framework/Versions/3.6/lib/python36.zip',
/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/1ib-dynload',
/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages',
/Applications/Pycharm.app/Contents/helpers/pycharm_matplotlib_backend')
Server time:Sat,13Jun202005:51:22+0000
曾老湿
<!-- OCR_END -->

￼

访问页面报错，因为在视图函数中，我们没有接收这个分组的参数

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    # url(r'^publish/\d+$', views.publish),
    # url(r'^publishadd/$', views.publishadd),
    url(r'^publish/([0-9]{4})/$', views.publish),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def publish(request,year):
    if request.method == 'GET':
        return HttpResponse('publish GET %s is ok' %year)
    elif request.method == 'POST':
        return HttpResponse('publish POST is ok')
def publishadd(request):
    if request.method == 'GET':
        return HttpResponse('publishadd GET is ok')
    elif request.method == 'POST':
        return HttpResponse('publishadd POST is ok')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publish/2018/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- publishGET 2018 is ok
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

但是如果我再加一个正则的分组，这样的话我们需要按照位置传参`*args`。

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def publish(request,*args):
    if request.method == 'GET':
        return HttpResponse('publish GET %s is ok' %args)
    elif request.method == 'POST':
        return HttpResponse('publish POST is ok')
def publishadd(request):
    if request.method == 'GET':
        return HttpResponse('publishadd GET is ok')
    elif request.method == 'POST':
        return HttpResponse('publishadd POST is ok')
```

但是一般不会这么传参，工作中一般也就一个两个。

***

| 有名分组 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    # url(r'^publish/\d+$', views.publish),
    # url(r'^publishadd/$', views.publishadd),
    # url(r'^publish/([0-9]{4})/$', views.publish),
    url(r'^publish/(?P<year>[0-9]{4})/$', views.publish),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def publish(request,year):
    if request.method == 'GET':
        return HttpResponse('publish GET %s is ok' %year)
    elif request.method == 'POST':
        return HttpResponse('publish POST is ok')
def publishadd(request):
    if request.method == 'GET':
        return HttpResponse('publishadd GET is ok')
    elif request.method == 'POST':
        return HttpResponse('publishadd POST is ok')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publish/2019/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- publish GET 2019 is ok
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**总结：**

```plain
## 无名分组
        -按位置传参
        -分组之后,会把分组出来的数据,当位置参数,传到视图函数,所以,视图函数需要定义形参
        -url(r'^publish/([0-9]{4})/([0-9]{2})$', views.publish),
        -def publish(request,*args):   视图函数可以这样接收
## 有名分组
        -按关键字传参
        -有名分组之后,会把分组出来的数据,当关键字参数,传到视图函数,所以,视图函数需要定义形参,形参名字要跟分组的名字对应,与无关
        -url(r'^publish/(?P<year>[0-9]{4})/(?P<mounth>[0-9]{2})/$', views.publish),
        -def publish(request, mounth,year):
        *****有名分组和无名分组,不要混用
```

## 反向解析

***

| 反向解析介绍 |
| :--- |

在使用Django 项目时，一个常见的需求是获得URL 的最终形式，以用于嵌入到生成的内容中（视图中和显示给用户的URL等）或者用于处理服务器端的导航（重定向等）。人们强烈希望不要硬编码这些URL（费力、不可扩展且容易产生错误）或者设计一种与URLconf 毫不相关的专门的URL 生成机制，因为这样容易导致一定程度上产生过期的URL。

在需要URL 的地方，对于不同层级，Django 提供不同的工具用于URL 反查：

在模板中：使用url 模板标签。

在Python 代码中：使用from django.urls import reverse()函数

***

| 举例 |
| :--- |

publish.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>publish</title>
</head>
<body>
<a href="/publishadd/">点我一下子</a>
</body>
</html>
```

urls.py

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/$', views.publish),
    url(r'^publishadd/$', views.publishadd),
    # url(r'^publish/([0-9]{4})/$', views.publish),
    # url(r'^publish/(?P<year>[0-9]{4})/$', views.publish),
]
```

views.py

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def publish(request):
    if request.method == 'GET':
        return render(request,'publish.html')
def publishadd(request):
    return HttpResponse('publishadd is ok')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- publish
- 127.0.0.1:8000/publish/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe..
- 点我一下子
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publishadd/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- publishadd is ok
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

但是以后项目多了，我们有多个页面的时候，如下，我们该怎么办？

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/$', views.publish),
    url(r'^publishadd/$', views.publishadd),
    url(r'^publishadd1/$', views.publishadd),
    url(r'^publishadd2/$', views.publishadd),
    url(r'^publishadd3/$', views.publishadd),
    url(r'^publishadd4/$', views.publishadd),
    url(r'^publishadd5/$', views.publishadd),
    url(r'^publishadd6/$', views.publishadd),
    # url(r'^publish/([0-9]{4})/$', views.publish),
    # url(r'^publish/(?P<year>[0-9]{4})/$', views.publish),
]
```

我们要在前端添加一堆a标签嘛？当然不是，所以我们需要用到反向解析

```plain
"""
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/$', views.publish),
    url(r'^publishadd/$', views.publishadd,name='add'),
    # url(r'^publish/([0-9]{4})/$', views.publish),
    # url(r'^publish/(?P<year>[0-9]{4})/$', views.publish),
]
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>publish</title>
</head>
<body>
<a href="{% url 'add' %}">点我一下子</a>
</body>
</html>
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- publish
- 127.0.0.1:8000/publish/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- 点我一下子
- body
- 1664×22
- Elements
- Sources
- Network
- Performance
- Memory
- Application
- Security
- Lig
- <!DOCTYPEhtml>
- <html lang="en">
- <head>.</head>
- ·<body>==$0
- <a href="Lpublishadd/">点我-下子</a>
- /html>
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来～
- publish
- 127.0.0.1:8000/publish/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- 点我一下子
- Elements
- Sources
- Network
- Performance
- Memory
- Application
- Sec
- <!DOCTYPEhtml>
- <html lang="en">
- <head>.</head>
- <body>
- $0
- <a href=
- publishaddaaaaaaaaaa
- 点我一下子</a>
- </html>
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

后台随意修改。但是我们要在后台的视图层也要做一次反向解析，导入：`reverse`

```plain
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def publish(request):
    if request.method == 'GET':
        url=reverse('add')
        return redirect(url)
def publishadd(request):
    return HttpResponse('publishadd is ok')
```

***

| url使用无名参数如何传参 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/$', views.publish),
    url(r'^publishadd/([0-9]{4})$', views.publishadd,name='add'),
    # url(r'^publish/([0-9]{4})/$', views.publish),
    # url(r'^publish/(?P<year>[0-9]{4})/$', views.publish),
]
```

<!-- OCR_START -->
别离开我啊，小老弟，点回来~
NoReverseMatchat/publish/x
→C127.0.0.1:8000/publish/
应用zabbix-apiCanlUseiview组件IElement曾志高翔（DriverZe
Error during template rendering
In template/Users/driverzeng/PycharmProjects/route/templates/publish.html,error at line 8
Reversefor'add'with no argumentsnotfound.1pattern(s)tried:['publishadd/([o-9]4})$]
1<!DOCTYPE html>
2<html lang="en">
3<head>
<meta charset="uTF-8">
5
<title>publish</title>
6</head>
7<body>
8<ahref="(8url‘add’8)”>点我一下子</a>
9</body>
10</html>
TracebackSwitchtocopy-and-pasteview
曾老湿
<!-- OCR_END -->

￼

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>publish</title>
</head>
<body>
<a href="{% url 'add' 2018 %}">点我一下子</a>
</body>
</html>
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- publish
- ←→C
- 127.0.0.1:8000/publish/
- 应用zabbix-apiCanlUseiview组件|Element曾志高翔（DriverZe
- 点我一下子
- 曾老湿
<!-- OCR_END -->

￼

视图层传递参数

```plain
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def publish(request):
    if request.method == 'GET':
        url=reverse('add',args=(2018,))
        return redirect(url)
def publishadd(request,year):
    return HttpResponse('publishadd is ok')
```

<!-- OCR_START -->
别离开我啊，小老弟，点回来~
127.0.0.1:8000/publish
C127.0.0.1:8000/publishadd/2018
应用zabbix-apiCanlUseiview组件|Element曾志高翔（DriverZe.
publishadd isok
曾老湿
<!-- OCR_END -->

￼

***

| url使用有名参数如何传参 |
| :--- |

**模板层反向解析**

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/$', views.publish),
    url(r'^publishadd/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})$', views.publishadd,name='add'),
    # url(r'^publish/([0-9]{4})/$', views.publish),
    # url(r'^publish/(?P<year>[0-9]{4})/$', views.publish),
]
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>publish</title>
</head>
<body>
<a href="{% url 'add' year=2018 month=12 %}">点我一下子</a>
</body>
</html>
```

```plain
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def publish(request):
    if request.method == 'GET':
        # url=reverse('add',args=(2018,))
        # return redirect(url)
        return render(request,'publish.html')
def publishadd(request,year,month):
    return HttpResponse('publishadd is ok')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- publish
- 127.0.0.1:8000/publish/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（Drive
- 点我一下子
- Elements
- Sources
- Network
- Performance
- Memory
- Applica
- <!DOCTYPE html>
- <html lang="en">
- <head>.</head>
- <body>
- $0
- <a href
- Zpublishadd/2018/12"
- 点我一下子</a>
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**视图层反向解析**

```plain
## 方法一：
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def publish(request):
    if request.method == 'GET':
        url=reverse('add',args=(2018,12))
        return redirect(url)
        # return render(request,'publish.html')
def publishadd(request,year,month):
    return HttpResponse('publishadd is ok')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publishadd/201x
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe..
- publishadd is ok
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
## 方法二：
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def publish(request):
    if request.method == 'GET':
        url=reverse('add',kwargs={'year':2018,'month':11})
        return redirect(url)
        # return render(request,'publish.html')
def publishadd(request,year,month):
    return HttpResponse('publishadd is ok')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/publishadd/201>
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- publishadd is ok
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## 路由分发

当项目越来越大的时候，`urls.py`中的内容会越来越多，所以我们根据 app 来创建不同的路由

***

| 再创建一个APP |
| :--- |

```plain
## 创建一个名为blog的APP
MacBook-pro:route driverzeng$ python3 manage.py startapp blog
```

**注册APP**

```plain
### 方法一：（推荐方法）
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'app01.apps.App01Config',
    'blog.apps.BlogConfig',
]
### 方法二：
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'app01.apps.App01Config',
    'blog',
]
```

方法一的名字，怎么来的呢？

<!-- OCR_START -->
- 曾老湿

```text
route [~/PycharmProjects/route] - ../blog/apps
route
blog
apps.py
Project
2
settings.py
apps.py x
urls.py x
views.py x
publish.html X
from django.apps import AppConfig
route ~/PycharmProjects/route
1
appo1
2
3
migrations
class
BlogConfig
AppConfig):
_init_.py
5
name='blog
admin.py
6
apps.py
models.py
tests.py
views.py
ablog
migrations
_init_.py
admin.py
apps.py
models.py
tests.py
views.py
route
_init_.py
settings.py
urls.py
wsgi.py
static
templates
db.sqlite3
manage.py
l External Libraries
ches and Consoles
BlogConfig
Driver Zeng
```
<!-- OCR_END -->

￼

***

| 在各个项目中创建urls.py |
| :--- |

其实urls文件中已经告诉我们如何包含其他的URLconf

```plain
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
```

总路由`urls.py`文件中，导入include方法，然后添加`blog`和`app01`的路由。

```plain
from django.conf.urls import url,include
from django.contrib import admin
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^blog/', include('blog.urls')),
    url(r'^app01/', include('app01.urls')),
]
```

**app01路由文件urls.py**

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^publish/$',views.publish),
]
```

**app01视图文件views.py**

```plain
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def publish(request):
    if request.method == 'GET':
        return HttpResponse('app01 publish is OK')
```

**打开浏览器访问：**<http://127.0.0.1:8000/app01/publish/>

<!-- OCR_START -->
- 127.0.0.1:8000/app01/publish/ x
- 0127.0.0.1:8000/app01/publish/
- 应用
- zabbix-api
- CanlUse
- Viview
- 组件|Element
- 曾志高翔（DriverZe...
- app01 publish is OK
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**blog路由文件urls.py**

```plain
from django.conf.urls import url
from blog import views
urlpatterns = [
    url(r'^article/$',views.article),
]
```

**blog视图文件views.py**

```plain
from django.shortcuts import render,HttpResponse
# Create your views here.
def article(request):
    return HttpResponse('blog article OK')
```

**打开浏览器访问：**<http://127.0.0.1:8000/blog/article/>

<!-- OCR_START -->
- 127.0.0.1:8000/blog/article/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- blog article OK
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## 名称空间

命名空间（英语：Namespace）是表示标识符的可见范围。一个标识符可在多个命名空间中定义，它在不同命名空间中的含义是互不相干的。这样，在一个新的命名空间中可定义任何标识符，它们不会与任何已有的标识符发生冲突，因为已有的定义都处于其它命名空间中。

由于name没有作用域，Django在反解URL时，会在项目全局顺序搜索，当查找到第一个name指定URL时，立即返回

我们在开发项目时，会经常使用name属性反解出URL，当不小心在不同的app的urls中定义相同的name时，可能会导致URL反解错误，为了避免这种事情发生，引入了命名空间。

总而言之，就是，在不同app中，反向解析名字相同就会混乱。

解决方案，就是在总路由中设置名称空间

```plain
from django.conf.urls import url,include
from django.contrib import admin
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^blog/', include('blog.urls',namespace='blog')),
    url(r'^app01/', include('app01.urls',namespace='app01')),
]
```

**app01使用反向解析**

```plain
from django.conf.urls import url
from app01 import views
urlpatterns = [
    url(r'^publish/$',views.publish,name='zls'),
    url(r'^zls/$',views.zls),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def publish(request):
    if request.method == 'GET':
        return HttpResponse('app01 publish is OK')
def zls(request):
    url=reverse('app01:zls')  ## 输入zls的时候系统会自动提示app01:zls
    return redirect(url)
```

<!-- OCR_START -->
- 曾老湿

```text
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def publish(request):
if request.method = 'GET'：
return HttpResponse('appo1 publish is Ok')
def zls(reguest):
url=reverse
red
app01:zls
Driver Zeng
^√and↑willmovecaretdownandupintheeditor≥>
```
<!-- OCR_END -->

￼

**blog使用反向解析**

```plain
from django.conf.urls import url
from blog import views
urlpatterns = [
    url(r'^article/$',views.article,name='zls'),
    url(r'^zls/$',views.zls),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect,reverse
# Create your views here.
def article(request):
    return HttpResponse('blog article OK')
def zls(request):
    url=reverse('blog:zls')
    return redirect(url)
```

<!-- OCR_START -->
- 曾老湿

```text
from django.shortcuts
import
render,HttpResponse,reverse
# Create your views here.
def article(reguest):
return HttpResponse('blog article Ok')
def zls(reguest):
url=reverse('z' app01:zls blog:zls ^and↑will movecaretdown and up in theeditor≥>
DriverZeng
```
<!-- OCR_END -->

￼

但是我们尽量不要用名称空间，如果需要反向解析，尽量就使用项目前缀 `name='app01_zls'`和`name=blog_zls`

## Django配置/和404

***

| /路由 |
| :--- |

直接访问主页

```plain
from django.conf.urls import url,include
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^$',views.index),
    url(r'^admin/', admin.site.urls),
    url(r'^blog/', include('blog.urls',namespace='blog')),
    url(r'^app01/', include('app01.urls',namespace='app01')),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect,reverse,Http404
# Create your views here.
def publish(request):
    if request.method == 'GET':
        return HttpResponse('app01 publish is OK')
def zls(request):
    url=reverse('app01:zls')
    return redirect(url)
def index(request):
    return HttpResponse('主页')
```

<!-- OCR_START -->
- 127.0.0.1:8000
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- 主页
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

***

| 404页面 |
| :--- |

```plain
from django.conf.urls import url,include
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$',views.index),
    url(r'^blog/', include('blog.urls',namespace='blog')),
    url(r'^app01/', include('app01.urls',namespace='app01')),
    url(r'', views.page_not_fount),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect,reverse
from django.http import HttpResponseNotFound
# Create your views here.
def publish(request):
    if request.method == 'GET':
        return HttpResponse('app01 publish is OK')
def zls(request):
    url=reverse('app01:zls')
    return redirect(url)
def index(request):
    return HttpResponse('主页')
def page_not_fount(request):
    return HttpResponseNotFound('页面走丢啦')
```

<!-- OCR_START -->
- 127.0.0.1:8000/aasdq1
- ←→C
- 应用zabbix-api
- CanlUseiview
- 组件|Element曾志高翔（DriverZe
- 页面走丢啦
- Sources
- Net
- Prese
- Online
- 5ms
- 10ms
- 15ms
- 20ms
- 25m
- 30ms
- 95m
- 100ms
- 105ms
- nitiato
- Timing
- Request URL:http://127.0.0.1:8000/aasdq1
- RequestMethod:GET
- StatusCode:404Not Found
- Remote Address:127.0.0.1:8000
- 曾老湿
- grade
<!-- OCR_END -->

￼

## Django 路由不自动加/(几乎不用)

***

| APPEND_SLASH |
| :--- |

```plain
# 是否开启URL访问地址后面不为/跳转至带有/的路径的配置项
APPEND_SLASH=True
```

## Django2.0 和 Django 1.0路由层区别

***

| 思考问题 |
| :--- |

django2.0的re_path和1.0的url一样

思考情况如下：

```plain
urlpatterns = [  
    re_path('articles/(?P<year>[0-9]{4})/', year_archive),  
    re_path('article/(?P<article_id>[a-zA-Z0-9]+)/detail/', detail_view),  
    re_path('articles/(?P<article_id>[a-zA-Z0-9]+)/edit/', edit_view),  
    re_path('articles/(?P<article_id>[a-zA-Z0-9]+)/delete/', delete_view),  
]
```

考虑下这样的两个问题：

第一个问题，函数 year_archive 中year参数是字符串类型的，因此需要先转化为整数类型的变量值，当然year=int(year) 不会有诸如如TypeError或者ValueError的异常。那么有没有一种方法，在url中，使得这一转化步骤可以由Django自动完成？

第二个问题，三个路由中article_id都是同样的正则表达式，但是你需要写三遍，当之后article_id规则改变后，需要同时修改三处代码，那么有没有一种方法，只需修改一处即可？

在Django2.0中，可以使用 path 解决以上的两个问题。

```plain
from django.urls import path  
from . import views  
urlpatterns = [  
    path('articles/2003/', views.special_case_2003),  
    path('articles/<int:year>/', views.year_archive),  
    path('articles/<int:year>/<int:month>/', views.month_archive),  
    path('articles/<int:year>/<int:month>/<slug>/', views.article_detail),  
　　# path才支持，re_path不支持　　path('order/<int:year>',views.order),
]
```

***

| 基本规则 |
| :--- |

使用尖括号(<>)从url中捕获值。

捕获值中可以包含一个转化器类型（converter type），比如使用 int:name 捕获一个整数变量。若果没有转化器，将匹配任何字符串，当然也包括了 / 字符。

无需添加前导斜杠。

以下是根据 [2.0官方文档](https://docs.djangoproject.com/en/2.0/topics/http/urls/#example) 而整理的示例分析表：(跟上面url的匹配关系)

<!-- OCR_START -->
请求URL
匹配项
视图函数调用形式
views.month_archive(request,year=2
/articles/2005/03/
第3个
005,month=3)
/articles/2003/
第1个
views.special_case_2003(request)
views.article_detail(request,year=20
/articles/2003/03/building-a-djang
第4个
03,month=3,slug="building-a-djan
曾老湿
go-site")
Driver Zeng
<!-- OCR_END -->

￼

***

| path转化器 |
| :--- |

>  
>
> 文档原文是Path converters，暂且翻译为转化器。

```plain
Django默认支持以下5个转化器：
str,匹配除了路径分隔符（/）之外的非空字符串，这是默认的形式
int,匹配正整数，包含0。
slug,匹配字母、数字以及横杠、下划线组成的字符串。
uuid,匹配格式化的uuid，如 075194d3-6885-417e-a8a8-6c931e272f00。
path,匹配任何非空字符串，包含了路径分隔符（/）（不能用？）
```

***

| 自定义转化器 |
| :--- |

对于一些复杂或者复用的需要，可以定义自己的转化器。转化器是一个类或接口，它的要求有三点：

1.regex 类属性，字符串类型

2.to_python(self, value) 方法，value是由类属性 regex 所匹配到的字符串，返回具体的Python变量值，以供Django传递到对应的视图函数中。

3.to_url(self, value) 方法，和 to_python 相反，value是一个具体的Python变量值，返回其字符串，通常用于url反向引用。

**例子：**

```plain
class FourDigitYearConverter:  
    regex = '[0-9]{4}'  
    def to_python(self, value):  
        return int(value)  
    def to_url(self, value):  
        return '%04d' % value
```

**使用register_converter 将其注册到URL配置中：**

```plain
from django.urls import register_converter, path  
from . import converters, views  
register_converter(converters.FourDigitYearConverter, 'yyyy')  
urlpatterns = [  
    path('articles/2003/', views.special_case_2003),  
    path('articles/<yyyy:year>/', views.year_archive),  
    ...  
]
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:32:28  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/yxlw5m>