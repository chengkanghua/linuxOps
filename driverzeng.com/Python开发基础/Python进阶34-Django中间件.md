# Python进阶34-Django 中间件

## Python进阶34-Django 中间件

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

* [什么是中间件？](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_0)
* [中间件的作用](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_1)
* [自定义中间件](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_2)
* [中间件的执行流程](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_3)
* [process_view](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_4)
* [process_exception](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_5)
* [process_template_response](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_6)
* [CSRF](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_7)
* [模拟CSRF攻击](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_8)
* [Django 防止 CSRF](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_9)
* [FBV 局部使用/禁用CSRF](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_10)
* [CBV 局部使用/禁用CSRF](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_11)
* [CSRF放在header中](https://blog.driverzeng.com/zenglaoshi/5894.html#toc_12)

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

## 什么是中间件？

***

| 介绍 |
| :--- |

中间件顾名思义，是介于request与response处理之间的一道处理过程，相对比较轻量级，并且在全局上改变django的输入与输出。因为改变的是全局，所以需要谨慎实用，用不好会影响到性能

就是请求和响应之间的一道屏障。

<!-- OCR_START -->
- Django请求的整个生命周期
- Web服务器
- Web应用程序
- 视图层（视图函数）
- wsgi协议
- 模版层
- 1视图函数从数据操作层（models）取数据
- template
- 2取到数据进行数据，逻辑处理
- 用户浏览器
- 各种实现了
- URL
- wsgi协议的服
- 路由层
- 3从模版层取出模版
- .用数据进行染
- 器：wsgiref
- uwsgi..
- 4将渲染好的html模版，返回给用户浏览器
- 数据操作
- models
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**Django中间件的定义：**

```plain
Middleware is a framework of hooks into Django’s request/response processing. 
It’s a light, low-level “plugin” system for globally altering Django’s input or output.
```

## 中间件的作用

如果你想修改请求，例如被传送到view中的HttpRequest对象。 或者你想修改view返回的HttpResponse对象，这些都可以通过中间件来实现。

可能你还想在view执行之前做一些操作，这种情况就可以用 middleware来实现。

***

| Django内置中间件 |
| :--- |

Django默认的中间件：（在django项目的settings模块中，有一个 MIDDLEWARE_CLASSES 变量，其中每一个元素就是一个中间件）

```plain
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```

每一个中间件都有具体的功能

导入中间件 ，查看方法：

```plain
from django.middleware.csrf import CsrfViewMiddleware
```

<!-- OCR_START -->
- 曾老湿

```text
class CsrfViewMiddleware(MiddlewareMixin):
Middleware that requires a present and correct csrfmiddlewaretoken
for PosT requests that have a CsRF cookie, and sets an outgoing
CSRF cookie.
This middleware should be used in conjunction with the csrf token template
tag.
# The accept and reject methods currently only exist for the sake of the
# requires_csrf_token decorator.
def _accept(self, request):...
def _reject(self, request, reason):...
def _get_token(self, request):...
def _set_token(self,request, response):...
def process_request(self, request):..
def process_view(self, request, callback, callback_args, callback_kwargs):..
ss_response(self, request, response):...
DriverZeng
```
<!-- OCR_END -->

￼

```plain
process_view
process_request
process_response
```

## 自定义中间件

***

| 写一个class继承 |
| :--- |

mymiddleware.py

```plain
from django.utils.deprecation import MiddlewareMixin
class MyMiddleware1(MiddlewareMixin):
    def process_request(self, request):
        print('MyMiddleware------> 1  ----> process_request')
        
class MyMiddleware2(MiddlewareMixin):
    def process_request(self, request):
        print('MyMiddleware------> 2  ----> process_request')
```

***

| 在settings中注册 |
| :--- |

```plain
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'app01.mymiddleware.MyMiddleware1',
    'app01.mymiddleware.MyMiddleware2',
]
```

***

| 添加路由 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01  import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^test_middle/', views.test_middle),
]
```

***

| 添加视图 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def test_middle(request):
    print('我是视图函数')
    return HttpResponse('I am View')
```

<!-- OCR_START -->
- 127.0.0.1:8000/testmiddle/
- →C127.0.0.1:8000/testmiddle/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- IamView
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿
- 我是视图函数

```text
cbv_session[~/Pyc cbv_sessionlapp01)views.py
djcbv_session
G#COEI
Project
settings.pyx
csrf.pyx
mymiddleware.py
models.pyx
main.app01_user[db]
login.html
urls.pyx
main.django
views.pyx
from django.shortcuts import render,HttpResponse,redirect
app01
migrations
#Create your views here.
_init_.py
admin.py
def test_middle(request):
apps.py
models.py
return HttpResponse('I am View')
tests.py
views.py
cbv_session
_init_.py
settings.py
urls.py
wsgi.py
templates
login.html
db.sqlite3
manage.py
Ill External Libraries
Scratches and Consoles
>2
process_request
```
<!-- OCR_END -->

￼

当用户发起请求的时候会依次经过所有的的中间件，这个时候的请求时process_request,最后到达views的函数中，views函数处理后，在依次穿过中间件，这个时候是process_response,最后返回给请求者。

<!-- OCR_START -->
发起请求
MIDDLEWARE =
django.middleware.sequ
urity.SecMityMiddleware'
django.contrib.sessions.middlenare.SessionMiddleware'
'django.middleware.common.CommorMiddleware'
'django.contrib.auth.middleware.AuthenticationMiddleware'
'django.contrib.messages.miprocess-responseageMiddleware',
'django.middleware.clickjacking
XFrameOptionsMiddleware'
视图函数
曾老湿
DriverZeng
<!-- OCR_END -->

￼

上述截图中的中间件都是django中的，我们也可以自己定义一个中间件，我们可以自己写一个类，但是必须继承MiddlewareMixin

我们来添加一个请求

```plain
from django.utils.deprecation import MiddlewareMixin
class MyMiddleware1(MiddlewareMixin):
    def process_request(self, request):
        print('MyMiddleware------> 1  ----> process_request')
class MyMiddleware2(MiddlewareMixin):
    def process_request(self, request):
        print(request.GET.get('name'))
        print('MyMiddleware------> 2  ----> process_request')
```

<!-- OCR_START -->
127.0.0.1:8000/testmiddle/?nx
→C127.0.0.1:8000/test_middle/name=zls
应用zabbix-apiCanIUseiview组件IElement
IamView
1680px×434px
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿
- 是视图函数

```text
cbv_session[~/PycharmProjects/cbv_session]-
/app01/mymiddleware.py[cbv_session]
cbv_sessionapp01
niddleware.py
Project
csrf.pyx
mymideware.pyX
models.pyx
main.app01_user[db]
login.html
urls.py
cbv_session~/PycharmProjects/cbv_session
from django.utils.deprecation import MiddlewareMixin
app01
class MyMiddleware1（MiddlewareMixin）:
migrations
_init_.py
def process_request(self,request):
admin.py
print('MyMiddleware- apps.py Class MyMiddleware2（MiddlewareMixin）: models.py
mymiddleware.py
10
def process request(self,request):
tests.py
views.py
11
12
print('MyMiddleware- cbv_session _init_.py settings.py
urls.py
wsgi.py
templates
login.html
db.sqlite3
manage.py
lllExternal Libraries
Scratches and Consoles
MyMiddl
Run:
djcbv_sessionx
MvMiddleware-
[20/Jun/2020 09:47:51]"GET/test_middLe/?name=zls HTTP/1.1” 2009
zls
Middleware---
--->2
---->process_request
```
<!-- OCR_END -->

￼

加上process_response

```plain
from django.utils.deprecation import MiddlewareMixin
class MyMiddleware1(MiddlewareMixin):
    def process_request(self, request):
        print('MyMiddleware------> 1  ----> process_request')
        
    def process_response(self, request,response):
        print('MyMiddleware------> 1  ----> process_response')
        return response
class MyMiddleware2(MiddlewareMixin):
    def process_request(self, request):
        print('MyMiddleware------> 2  ----> process_request')
    def process_response(self, request,response):
        print('MyMiddleware------> 2  ----> process_response')
        return response
```

<!-- OCR_START -->
- 我是视图函数
- 曾老湿

```text
cbv_sessionapp01mymiddleware.py
djcbv_session
G#CE
Project
settings.pyx
csrf.pyx
mymiddleware.pyx
models.pyx
main.app01_user[db]×login.html
urls.py
main.django_session [db]
views.py
cbv_session ~/PycharmProjects/cbv_session
from django.utils.deprecation import MiddlewareMixin
app01
migrations
class MyMiddleware1（MiddlewareMixin）:
_init_.py
def process request(self,request）: admin.py 1 ->process_request')
apps.py
models.py
mymiddleware.py
print('MyMiddleware-- ->1 return response tests.py
11
views.py
class MyMiddLeware2（MiddLewareMixin）:
cbv_session
13
_init_.py
14
def process_request(self,request):
settings.py
15
print('MyMiddleware- ->2 ->process_reque urls.py
151
def process_response(self，request,response):
wsgi.py
18
print('MyMiddleware.-.. -->2 -->process_response')
templates
return response
login.html
db.sqlite3
Run:
djcbv_sessionx
Performing system checks...
System check identified no issues (o silenced）. June 20,2020-09:57:05 Django version 1.11.18, using settings ‘cbv_session.settings Quit the server with coNTROL-C.
MyMiddleware
>1
process_request
[20/Jun/2020 09:57:12]"GET /test_middle/?name=zls HTTP/1.1"2009
MyMiddleware
->2
---->process_request
MyMiddleware
>2
->process_response
yMiddleware
1
process_response
```
<!-- OCR_END -->

￼

## 中间件的执行流程

<!-- OCR_START -->
- url请求
- 中间件1的
- process_request
- process_response
- 中间件2的
- 曾老湿
- 视图函数
- Driver Zeng
<!-- OCR_END -->

￼

```plain
## 由此总结一下：
1.中间件的process_request方法是在执行视图函数之前执行的。
2.当配置多个中间件时，会按照MIDDLEWARE中的注册顺序，也就是列表的索引值，从前到后依次执行的。
3.不同中间件之间传递的request都是同一个对象
多个中间件中的process_response方法是按照MIDDLEWARE中的注册顺序倒序执行的，也就是说第一个中间件的process_request方法首先执行，而它的process_response方法最后执行，最后一个中间件的process_request方法最后一个执行，它的process_response方法是最先执行。
```

## process_view

process_view(self, request, view_func, view_args, view_kwargs)

该方法有四个参数

request是HttpRequest对象。

view_func是Django即将使用的视图函数。 （它是实际的函数对象，而不是函数的名称作为字符串。）

view_args是将传递给视图的位置参数的列表.

view_kwargs是将传递给视图的关键字参数的字典。 view_args和view_kwargs都不包含第一个视图参数（request）。

Django会在调用视图函数之前调用process_view方法。

它应该返回None或一个HttpResponse对象。 如果返回None，Django将继续处理这个请求，执行任何其他中间件的process_view方法，然后在执行相应的视图。 如果它返回一个HttpResponse对象，Django不会调用适当的视图函数。 它将执行中间件的process_response方法并将应用到该HttpResponse并返回结果。

```plain
process_view(self, request, callback, callback_args, callback_kwargs)
from django.utils.deprecation import MiddlewareMixin
from django.shortcuts import HttpResponse
class Md1(MiddlewareMixin):
    def process_request(self,request):
        print("Md1请求")
        #return HttpResponse("Md1中断")
    def process_response(self,request,response):
        print("Md1返回")
        return response
    def process_view(self, request, callback, callback_args, callback_kwargs):
        print("Md1view")
class Md2(MiddlewareMixin):
    def process_request(self,request):
        print("Md2请求")
        return HttpResponse("Md2中断")
    def process_response(self,request,response):
        print("Md2返回")
        return response
    def process_view(self, request, callback, callback_args, callback_kwargs):
        print("Md2view")
```

**结果如下：**

```plain
Md1请求
Md2请求
Md1view
Md2view
view函数...
Md2返回
Md1返回
```

<!-- OCR_START -->
- url请求
- 中间件1的
- processrequest
- process_view
- process_response
- 中间件2的
- 路由控制
- 视图函数
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

当最后一个中间的process_request到达路由关系映射之后，返回到中间件1的process_view，然后依次往下，到达views函数，最后通过process_response依次返回到达用户。

process_view可以用来调用视图函数：

```plain
class Md1(MiddlewareMixin):
    def process_request(self,request):
        print("Md1请求")
        #return HttpResponse("Md1中断")
    def process_response(self,request,response):
        print("Md1返回")
        return response
    def process_view(self, request, callback, callback_args, callback_kwargs):
        # return HttpResponse("hello")
        response=callback(request,*callback_args,**callback_kwargs)
        return response
```

**结果如下：**

```plain
Md1请求
Md2请求
view函数...
Md2返回
Md1返回
```

**注意：**`process_view`如果有返回值，会越过其他的`process_view`以及视图函数，但是所有的`process_response`都还会执行。

## process_exception

process_exception(self, request, exception)

该方法两个参数:

一个HttpRequest对象

一个exception是视图函数异常产生的Exception对象。

这个方法只有在视图函数中出现异常了才执行，它返回的值可以是一个None也可以是一个HttpResponse对象。如果是HttpResponse对象，Django将调用模板和中间件中的process_response方法，并返回给浏览器，否则将默认处理异常。如果返回一个None，则交给下一个中间件的process_exception方法来处理异常。它的执行顺序也是按照中间件注册顺序的倒序执行。

```plain
process_exception(self, request, exception)
```

示例修改如下：

```plain
class Md1(MiddlewareMixin):
    def process_request(self,request):
        print("Md1请求")
        #return HttpResponse("Md1中断")
    def process_response(self,request,response):
        print("Md1返回")
        return response
    def process_view(self, request, callback, callback_args, callback_kwargs):
        # return HttpResponse("hello")
        # response=callback(request,*callback_args,**callback_kwargs)
        # return response
        print("md1 process_view...")
    def process_exception(self,request,exception):
        print("md1 process_exception...")
class Md2(MiddlewareMixin):
    def process_request(self,request):
        print("Md2请求")
        # return HttpResponse("Md2中断")
    def process_response(self,request,response):
        print("Md2返回")
        return response
    def process_view(self, request, callback, callback_args, callback_kwargs):
        print("md2 process_view...")
    def process_exception(self,request,exception):
        print("md1 process_exception...")
```

**结果如下：**

```plain
Md1请求
Md2请求
md1 process_view...
md2 process_view...
view函数...
Md2返回
Md1返回
```

流程图如下：

当views出现错误时：

<!-- OCR_START -->
- url请求
- 中间件1的
- process_request
- process_view
- process_exception
- process_response
- 中间件2的
- 路由控制
- 视图函数出错
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

\*\* 将md2的process_exception修改如下：\*\*

```plain
def process_exception(self,request,exception):
        print("md2 process_exception...")
        return HttpResponse("error")
```

**结果如下：**

```plain
Md1请求
Md2请求
md1 process_view...
md2 process_view...
view函数...
md2 process_exception...
Md2返回
Md1返回
```

## process_template_response

该方法对视图函数返回值有要求，必须是一个含有render方法类的对象，才会执行此方法

```plain
process_template_response(self,request,response)
```

压根用不到，规则比较局限性

```plain
class Test:
    def __init__(self,status,msg):
        self.status=status
        self.msg=msg
    def render(self):
        import json
        dic={'status':self.status,'msg':self.msg}
        return HttpResponse(json.dumps(dic))
def index(response):
    return Test(True,'测试')
```

## CSRF

***

| csrf |
| :--- |

CSRF（Cross-site request forgery）跨站请求伪造，也被称为“One Click Attack”或者Session Riding，通常缩写为CSRF或者XSRF，是一种对网站的恶意利用。尽管听起来像跨站脚本（XSS），但它与XSS非常不同，XSS利用站点内的信任用户，而CSRF则通过伪装来自受信任用户的请求来利用受信任的网站。与XSS攻击相比，CSRF攻击往往不大流行（因此对其进行防范的资源也相当稀少）和难以防范，所以被认为比XSS更具危险性

**可以这样来理解：**

攻击者盗用了你的身份，以你的名义发送恶意请求，对服务器来说这个请求是完全合法的，但是却完成了攻击者所期望的一个操作，比如以你的名义发送邮件、发消息，盗取你的账号，添加系统管理员，甚至于购买商品、虚拟货币转账等。 如下：其中Web A为存在CSRF漏洞的网站，Web B为攻击者构建的恶意网站，User C为Web A网站的合法用户

<!-- OCR_START -->
- 存在CSRF漏洞的网站：招商银行（A网站）
- 攻击者：网站B
- 受害者：用户
- 第一步：浏览并登录招商银行网站
- 招商银行网站A（信任的）
- 第二步：登录成功，返回cookies
- 第五步：用户携带cookies向A发送转账请求
- 浏览器
- 第三步：没有退出A网站的情况下，访问B网站
- 网站B（黑客网站）
- 第四步：B网站要求用户向A网站发送一个转账请求
- 曾老湿
- 第六步：网站A不知道第五步的请求是用户主动发起，还是黑客网站发起的，都
- 会带着用户cookies进行转账，这样就达到了转账的目的
- DriverZeng
<!-- OCR_END -->

￼

从上图可以看出，要完成一次CSRF攻击，受害者必须依次完成两个步骤：

1.登录受信任网站A，并在本地生成Cookie。

2.在不登出A的情况下，访问危险网站B。

看到这里，你也许会说：“如果我不满足以上两个条件中的一个，我就不会受到CSRF的攻击”。是的，确实如此，但你不能保证以下情况不会发生：

1.你不能保证你登录了一个网站后，不再打开一个tab页面并访问另外的网站。

2.你不能保证你关闭浏览器了后，你本地的Cookie立刻过期，你上次的会话已经结束。（事实上，关闭浏览器不能结束一个会话，但大多数人都会错误的认为关闭浏览器就等于退出登录/结束会话了......）

3.上图中所谓的攻击网站，可能是一个存在其他漏洞的可信任的经常被人访问的网站。

***

| CSRF攻击防范 |
| :--- |

```plain
目前防御 CSRF 攻击主要有三种策略：验证 HTTP Referer 字段；在请求地址中添加 token 并验证；在 HTTP 头中自定义属性并验证
      （1）验证 HTTP Referer 字段
        根据 HTTP 协议，在 HTTP 头中有一个字段叫 Referer，它记录了该 HTTP 请求的来源地址。在通常情况下，访问一个安全受限页面的请求来自于同一个网站，比如需要访问 http://bank.example/withdraw?account=bob&amount=1000000&for=Mallory，用户必须先登陆 bank.example，然后通过点击页面上的按钮来触发转账事件。这时，该转帐请求的 Referer 值就会是转账按钮所在的页面的 URL，通常是以 bank.example 域名开头的地址。而如果黑客要对银行网站实施 CSRF 攻击，他只能在他自己的网站构造请求，当用户通过黑客的网站发送请求到银行时，该请求的 Referer 是指向黑客自己的网站。因此，要防御 CSRF 攻击，银行网站只需要对于每一个转账请求验证其 Referer 值，如果是以 bank.example 开头的域名，则说明该请求是来自银行网站自己的请求，是合法的。如果 Referer 是其他网站的话，则有可能是黑客的 CSRF 攻击，拒绝该请求。
        这种方法的显而易见的好处就是简单易行，网站的普通开发人员不需要操心 CSRF 的漏洞，只需要在最后给所有安全敏感的请求统一增加一个拦截器来检查 Referer 的值就可以。特别是对于当前现有的系统，不需要改变当前系统的任何已有代码和逻辑，没有风险，非常便捷。
        然而，这种方法并非万无一失。Referer 的值是由浏览器提供的，虽然 HTTP 协议上有明确的要求，但是每个浏览器对于 Referer 的具体实现可能有差别，并不能保证浏览器自身没有安全漏洞。使用验证 Referer 值的方法，就是把安全性都依赖于第三方（即浏览器）来保障，从理论上来讲，这样并不安全。事实上，对于某些浏览器，比如 IE6 或 FF2，目前已经有一些方法可以篡改 Referer 值。如果 bank.example 网站支持 IE6 浏览器，黑客完全可以把用户浏览器的 Referer 值设为以 bank.example 域名开头的地址，这样就可以通过验证，从而进行 CSRF 攻击。
即便是使用最新的浏览器，黑客无法篡改 Referer 值，这种方法仍然有问题。因为 Referer 值会记录下用户的访问来源，有些用户认为这样会侵犯到他们自己的隐私权，特别是有些组织担心 Referer 值会把组织内网中的某些信息泄露到外网中。因此，用户自己可以设置浏览器使其在发送请求时不再提供 Referer。当他们正常访问银行网站时，网站会因为请求没有 Referer 值而认为是 CSRF 攻击，拒绝合法用户的访问。
       （2）在请求地址中添加 token 并验证
         CSRF 攻击之所以能够成功，是因为黑客可以完全伪造用户的请求，该请求中所有的用户验证信息都是存在于 cookie 中，因此黑客可以在不知道这些验证信息的情况下直接利用用户自己的 cookie 来通过安全验证。要抵御 CSRF，关键在于在请求中放入黑客所不能伪造的信息，并且该信息不存在于 cookie 之中。可以在 HTTP 请求中以参数的形式加入一个随机产生的 token，并在服务器端建立一个拦截器来验证这个 token，如果请求中没有 token 或者 token 内容不正确，则认为可能是 CSRF 攻击而拒绝该请求。
        这种方法要比检查 Referer 要安全一些，token 可以在用户登陆后产生并放于 session 之中，然后在每次请求时把 token 从 session 中拿出，与请求中的 token 进行比对，但这种方法的难点在于如何把 token 以参数的形式加入请求。对于 GET 请求，token 将附在请求地址之后，这样 URL 就变成 http://url?csrftoken=tokenvalue。 而对于 POST 请求来说，要在 form 的最后加上 <input type=”hidden” name=”csrftoken” value=”tokenvalue”/>，这样就把 token 以参数的形式加入请求了。但是，在一个网站中，可以接受请求的地方非常多，要对于每一个请求都加上 token 是很麻烦的，并且很容易漏掉，通常使用的方法就是在每次页面加载时，使用 javascript 遍历整个 dom 树，对于 dom 中所有的 a 和 form 标签后加入 token。这样可以解决大部分的请求，但是对于在页面加载之后动态生成的 html 代码，这种方法就没有作用，还需要程序员在编码时手动添加 token。
         该方法还有一个缺点是难以保证 token 本身的安全。特别是在一些论坛之类支持用户自己发表内容的网站，黑客可以在上面发布自己个人网站的地址。由于系统也会在这个地址后面加上 token，黑客可以在自己的网站上得到这个 token，并马上就可以发动 CSRF 攻击。为了避免这一点，系统可以在添加 token 的时候增加一个判断，如果这个链接是链到自己本站的，就在后面添加 token，如果是通向外网则不加。不过，即使这个 csrftoken 不以参数的形式附加在请求之中，黑客的网站也同样可以通过 Referer 来得到这个 token 值以发动 CSRF 攻击。这也是一些用户喜欢手动关闭浏览器 Referer 功能的原因。
      （3）在 HTTP 头中自定义属性并验证
        这种方法也是使用 token 并进行验证，和上一种方法不同的是，这里并不是把 token 以参数的形式置于 HTTP 请求之中，而是把它放到 HTTP 头中自定义的属性里。通过 XMLHttpRequest 这个类，可以一次性给所有该类请求加上 csrftoken 这个 HTTP 头属性，并把 token 值放入其中。这样解决了上种方法在请求中加入 token 的不便，同时，通过 XMLHttpRequest 请求的地址不会被记录到浏览器的地址栏，也不用担心 token 会透过 Referer 泄露到其他网站中去。
```

## 模拟CSRF攻击

<!-- OCR_START -->
- New Project
- Pure Python
- Location:
- /Users/driverzeng/PycharmProjects/zhaoshang
- dj Django
- Flask
- Project Interpreter:Python3.6
- Google App Engine
- ?-
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
- appo1l
- Foundation
- Enable Django admin
- 5 HTML5 Boilerplate
- ReactApp
- React Native
- 曾老湿
- Cancel
- Create
- DriverZeng
<!-- OCR_END -->

￼

***

| 路由层 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^index/', views.index),
    url(r'^transfer/', views.transfer),
]
```

***

| 视图层 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse
# Create your views here.
def index(request):
    return render(request,'index.html')
def transfer(request):
    # 假装已经登录了
    # from_user = request.session.get('id')
    to = request.GET.get('to')
    # 转账的方法
    count = request.GET.get('count')
    # mytransfer(from_user,to,count)
    print('转账成功，转账：%s' %count)
    return HttpResponse('转账成功')
```

***

| 模板层 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>招商</title>
</head>
<body>
    我是招商银行
</body>
</html>
```

***

| 起两个服务 |
| :--- |

一个招商银行的：8001

一个黑客的： 8000

在黑客的页面上写一个按钮，实现攻击

hack.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>黑客</title>
</head>
<body>
<a href="http://127.0.0.1:8001/transfer/?to=zls&count=1000">点我看美女图片</a>
</body>
</html>
```

views.py

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def hack(request):
    return render(request,'hack.html')
```

urls.py

```plain
from django.conf.urls import url
from django.contrib import admin
from app01  import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^hack/', views.hack),
]
```

<!-- OCR_START -->
- 黑客
- 招商
- →C
- 127.0.0.1:8000/hack/
- 8
- 应用zabbix-api
- CanlUseiview
- 组件|Elemen
- 点我看美女图片
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 黑客
- 招商
- ←→Q
- 127.0.0.1:8001/index/
- 应用zabbix-apiCanlUseiview组件|Element
- 我是招商银行
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
127.0.0.1:8001/transfer/?to=zl:x
招商
→C127.0.0.1:8001/transfer/?to=zls&count=1000
8
应用zabbix-apiCanlIUseiview组件|Element
转账成功
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 假装已经登录了
- 曾老湿

```text
app01)views.py
Project
settings.py
urls.pyx
views.pyx
index.html
from django.shortcuts import render HttpResponse
app01
#Create your views here.
migrations
def index（request）:
_init_.py
return render(request,'index.html')
admin.py
apps.py
models.py
tests.py
#from_user
request.session.get('id')
views.py
to=request.GET.get('to')
templates
2
#转账的方法
zhaoshang
13
count =request.GET.get（'count')
_init_.py
#mytransfer（from_user,to,count)
settings.py
urls.py
return HttpResponse（‘转账成功）
wsgi.py
18
db.sqlite3
manage.py
ll External Libraries
Scratches and Consoles
djzhaoshang
G→
Youhave3unappliedmigrations）.Your projectmaynot work properlyuntilyou apply themigrationsforapps）:admin,auth,contenttypessessions.
pythonmanage.py migratetoapply them.
June 20,2020-11:04:48
Django version 1.11.18, using settingszhaoshang.settings
VTROL-C.
转账成功，转账：1000
[20/Jun/202011:05:12]
GET/transfer/?to=zls8count=1000 HTTP/1.1"200 12
onsoleTerminal4Run三6：TODO
```
<!-- OCR_END -->

￼

## Django 防止 CSRF

为了防止被工具，Django内置了方法，其实就是一个中间件，也是我们之前在学习过程中，每次都要注释掉的那个，也就是说，它每次都会拒绝我们的post请求，就是为了防止CSRF工具，从今以后我们不注释它，直接带着这个中间件的token去做post请求即可。

***

| 模板层 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<form action="" method="post">
    <input type="text" name="name">
    <input type="text" name="pwd">
    <input type="submit" value="提交">
</form>
</body>
</html>
```

***

| 路由层 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01  import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^hack/', views.hack),
    url(r'^test_csrf/', views.test_csrf),
]
```

***

| 视图层 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def test_csrf(request):
    return render(request,'test_csrf.html')
```

<!-- OCR_START -->
| 名称 | 排名 | 名称 | 名称 |
| --- | --- | --- | --- |
| Title | 招商 | ←→C | 127.0.0.1:8000/test_csrf/ |
| ☆ | 8 | 应用zabbix-api | CanlIUseiview组件IElement |
| zls | 123 | 提交 | 曾老湿 |
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 403Forbidden
- 招商
- →C
- 127.0.0.1:8000/test_csrf/
- 9
- 应用zabbix-api
- 组件IEle
- Forbidden(403)
- CSRFverificationfailed.Requestaborted
- Ifyouhaveconfguredourwsertdisablecookieleasere-nablthmatlastfrthissiterforsam-originrequst.
- Help
- 曾老湿giv
- nforfailure:
<!-- OCR_END -->

￼

直接提交请求，就炸了，于是乎我们需要在模板层加一个东西。

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<form action="" method="post">
    {% csrf_token %}
    <input type="text" name="name">
    <input type="text" name="pwd">
    <input type="submit" value="提交">
</form>
</body>
</html>
```

<!-- OCR_START -->
- Title
- 招商
- 127.0.0.1:8000/test_csrf/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 提交
- 1680px×180px
- <!DOCTYPEhtml>
- Styles
- Computed
- <html lang="en">
- <head></head>
- Filter
- :hov.cls
- element.style{
- <form action method="post">
- body{
- user agent stylesheet
- <input type="text"name="name>
- display:block;
- <input type=”submit”value="提交">
- </form>
- </html>
- padding
- 曾老湿
- 1664×25
<!-- OCR_END -->

￼

## FBV 局部使用/禁用CSRF

***

| AJAX使用CSRF |
| :--- |

**引入JQuery**

```plain
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
```

**模板层**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AJAX使用CSRF</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<form action="" method="post">
    {% csrf_token %}
    <input type="text" name="name">
    <input type="text" name="pwd">
</form>
<button id="btn">点我</button>
</body>
<script>
    $('#btn').click(function () {
        $.ajax({
            url: '/test_csrf/',
            type: 'post',
            data:{'name':$('[name="name"]').val(),'pwd':$('[pwd="pwd"]').val()},
            success:function (data) {
                alert(data)
            }
        })
    })
</script>
</html>
```

<!-- OCR_START -->
- AJAX使用CSRF
- 招商
- 127.0.0.1:8000/test_csrf/
- 应用zabbix-api
- CanlIUseiview组件IElement
- Zls
- 123
- 点我
- LR
- top
- Filter
- Default levels
- P0ST http://127.0.0.1:8000/test csrf/ 403（Forbidden)
- jquery.min.js:2
- 曾老湿
<!-- OCR_END -->

￼

这样写不让提交。

**携带csrf_token**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AJAX使用CSRF</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<form action="" method="post">
    {% csrf_token %}
    <input type="text" name="name">
    <input type="text" name="pwd">
</form>
<button id="btn">点我</button>
</body>
<script>
    $('#btn').click(function () {
        $.ajax({
            url: '/test_csrf/',
            type: 'post',
            data:{'name':$('[name="name"]').val(),'pwd':$('[pwd="pwd"]').val(),'csrfmiddlewaretoken':$('[name="csrfmiddlewaretoken"]').val(),},
            success:function (data) {
                alert(data)
            }
        })
    })
</script>
</html>
```

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def test_csrf(request):
    if request.method == 'GET':
        return render(request,'test_csrf.html')
    else:
        return HttpResponse('CSRF_审核通过惹~')
```

<!-- OCR_START -->
| 排名 | AJAX使用CSRF | AJAX使用CSRF |
| --- | --- | --- |
| 8 | 应用zabbix-api | CanlUseiview |
| 组件\|Element | 127.0.0.1:8000显示 | zls |
| 123 | CSRF_审核通过惹~ | 点我 |
<!-- OCR_END -->

￼

方法二：

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AJAX使用CSRF</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<form action="" method="post">
    {% csrf_token %}
    <input type="text" name="name">
    <input type="text" name="pwd">
</form>
<button id="btn">点我</button>
</body>
<script>
    $('#btn').click(function () {
        $.ajax({
            url: '/test_csrf/',
            type: 'post',
            data: {
                'name': $('[name="name"]').val(),
                'pwd': $('[pwd="pwd"]').val(),
                //'csrfmiddlewaretoken': $('[name="csrfmiddlewaretoken"]').val(),
                'csrfmiddlewaretoken': '{{ csrf_token }}',
            },
            success: function (data) {
                alert(data)
            }
        })
    })
</script>
</html>
```

<!-- OCR_START -->
- AJAX使用CSRF
- 招商
- →C
- 127.0.0.1:8000/test_csrf/
- 应用zabbix-apiCanIUseiview组件|Element
- 127.0.0.1:8000显示
- ZZZ
- 111
- CSRF_审核通过惹~
- 点我
- 确定
- 曾老湿
<!-- OCR_END -->

￼

***

| 局部禁用 |
| :--- |

**使用内置装饰器:**

1.csrf_exempt 局部禁用

2.csrf_protect 局部使用，必须在settings.py里面把全站的注释掉

**视图层**

```plain
from django.shortcuts import render, HttpResponse, redirect
## 导入装饰器
## csrf_exempt  局部禁用
## csrf_protect 局部使用
from django.views.decorators.csrf import csrf_exempt,csrf_protect
# Create your views here.
## 局部禁用
@csrf_exempt
def csrf_disable(request):
        return HttpResponse('CSRF_审核通过惹~')
```

**路由层**

```plain
from django.conf.urls import url
from django.contrib import admin
from app01  import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^hack/', views.hack),
    url(r'^test_csrf/', views.test_csrf),
    url(r'^csrf_disable/', views.csrf_disable),
]
```

**模板层**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AJAX使用CSRF</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<form action="" method="post">
    {% csrf_token %}
    <input type="text" name="name">
    <input type="text" name="pwd">
</form>
<button id="btn">点我</button>
</body>
<script>
    $('#btn').click(function () {
        $.ajax({
            url: '/csrf_disable/',
            type: 'post',
            data: {
                'name': $('[name="name"]').val(),
                'pwd': $('[pwd="pwd"]').val(),
            },
            success: function (data) {
                alert(data)
            }
        })
    })
</script>
</html>
```

<!-- OCR_START -->
| AJAX使用CSRF | AJAX使用CSRF | 排名 | AJAX使用CSRF |
| --- | --- | --- | --- |
| 127.0.0.1:8000/test_csrf/ | ☆ | 8 | 应用 |
| zabbix-api | CanIUse | iview | 组件\|Element |
| 127.0.0.1:8000显示 | zls111 | 222 | CSRF_审核通过惹~ |
<!-- OCR_END -->

￼

## CBV 局部使用/禁用CSRF

CBV的局部使用和局部禁用是有bug的。

***

| 路由层 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01  import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^hack/', views.hack),
    url(r'^test_csrf/', views.test_csrf),
    # url(r'^csrf_disable/', views.csrf_disable),
    url(r'^csrf_disable/', views.Csrf_disable.as_view()),
]
```

***

| 视图层 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.views.decorators.csrf import csrf_exempt,csrf_protect
# Create your views here.
from django.views import View
from django.utils.decorators import method_decorator
class Csrf_disable(View):
    def get(self,request):
        return HttpResponse('GET OK')
    @method_decorator(csrf_protect)
    def post(self,request):
        return HttpResponse('POST OK')
```

如果这么写，把装饰器加在内部的方法上，还会报错403。

所以我们会把装饰器写在类上,或者单独加在dispatch的方法上。

```plain
#方法一：
from django.shortcuts import render, HttpResponse, redirect
from django.views.decorators.csrf import csrf_exempt,csrf_protect
# Create your views here.
from django.views import View
from django.utils.decorators import method_decorator
@method_decorator(csrf_protect,name='dispatch')
class Csrf_disable(View):
    def dispatch(self, request, *args, **kwargs):
        res =  super().dispatch(request, *args, **kwargs)
        return res
    def get(self,request):
        return HttpResponse('GET OK')
    def post(self,request):
        return HttpResponse('POST OK')
#方法二：
from django.shortcuts import render, HttpResponse, redirect
from django.views.decorators.csrf import csrf_exempt,csrf_protect
# Create your views here.
from django.views import View
from django.utils.decorators import method_decorator
class Csrf_disable(View):
    @method_decorator(csrf_protect)
    def dispatch(self, request, *args, **kwargs):
        res =  super().dispatch(request, *args, **kwargs)
        return res
    def get(self,request):
        return HttpResponse('GET OK')
    def post(self,request):
        return HttpResponse('POST OK')
```

## CSRF放在header中

获取cookie：document.cookie

是一个字符串，可以自己用js切割，也可以用jquery的插件

获取cookie：$.cookie('csrftoken')

设置cookie：$.cookie('key','value')

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 引入JQuery操作cookie -->
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
    <title>Title</title>
</head>
<body>
<form action="" method="post">
    {% csrf_token %}
    <p>用户名：<input type="text" name="name"></p>
    <p>密码：<input type="text" name="password" id="pwd"></p>
    <p><input type="submit"></p>
</form>
<button class="btn">点我</button>
</body>
<script>
    $(".btn").click(function () {
        var token=$.cookie('csrftoken')
        //var token='{{ csrf_token }}'
        $.ajax({
            url: '',
            headers:{'X-CSRFToken':token},
            type: 'post',
            data: {
                'name': $('[name="name"]').val(),
                'password': $("#pwd").val(),
            },
            success: function (data) {
                console.log(data)
            }
        })
    })
</script>
</html>
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准

> 更新: 2020-06-25 11:40:07  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/wzzbax>