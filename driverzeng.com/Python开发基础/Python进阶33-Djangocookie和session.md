# Python进阶33-Django cookie和session

## Python进阶33-Django cookie和session
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(3) 评论(0)

+ [cookie和session的介绍](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_0)
+ [创建项目](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_1)
+ [Cookie测试](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_2)
+ [取Cookie的值记录登录状态](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_3)
+ [Cookie的其他参数](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_4)
+ [删除Cookie](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_5)
+ [Session的简单使用](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_6)
+ [Session的其他属性](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_7)
+ [Session的其他配置](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_8)
+ [CBV加装饰器](https://blog.driverzeng.com/zenglaoshi/5840.html#toc_9)

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

## cookie和session的介绍
---

| 介绍 |
| :--- |

介绍个锤子哦，我写过两个文章，自己去看

运维视野：[https://blog.driverzeng.com/zenglaoshi/2164.html](https://blog.driverzeng.com/zenglaoshi/2164.html)

前端视野：[https://blog.driverzeng.com/zenglaoshi/4655.html](https://blog.driverzeng.com/zenglaoshi/4655.html)

## 创建项目

<!-- OCR_START -->
- New Project
- Pure Python
- Location:
- /Users/driverzeng/PycharmProjects/cookie_session
- dj Django
- Flask
- Project Interpreter:Python 3.6
- Google App Engine
- Pyramid
- More Settings
- WWeb2Py
- Template language:
- Django
- I Scientific
- Angular CLI
- Templates folder:
- templates
- AngularJS
- B Bootstrap
- Application name:
- app01
- Foundation
- EnableDjango admin
- 5
- HTML5 Boilerplate
- ReactApp
- React Native
- 曾老湿
- Cancel
- Create
- DriverZeng
<!-- OCR_END -->

￼

注释csrf

---

| 路由层 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^test_cookie/', views.test_cookie),
]
```

---

| 视图层 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse
# Create your views here.
def test_cookie(request):
    return HttpResponse('OK')
```

下图可见，没有cookie

<!-- OCR_START -->
- 曾老湿

```http
别离开我啊，小老弟，点回来~
127.0.0.1:8000/test_cookie/ →C127.0.0.1:8000/test_cookie/ 应用zabbix-apiCanlIUseiview组件IElement曾志高翔（DriverZe
OK
Net
QPreserve logDisablecacheOnline
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
45ms
50ms
55ms
60ms
65ms
70ms
75ms
80ms
85ms
90ms
95ms
100ms
105ms
HeadersPreviewResponseInitiatorTiming
test_cookie/ Status Code:200 0K
Remote Address:127.0.0.1:8000
ReferrerPolicy:no-referrer-when-downgrade
Response Headers
viewsource
Content-Length:2
Content-Type:text/html;charset=utf-8
Date:Fri,19 Jun 2020 14:12:42 GMT
Server:WSGIServer/0.2CPython/3.6.4
X-Frame-Options:SAMEORIGIN
guest Headers
viewsource
cept:text/html,application/x
Accept-Encoding:gzip, deflate，br
Accept-Language:zh-CN,zh;q=0.9
Cache-Control:no-cache
Connection:keep-alive
Host:127.0.0.1:8000
Pragma:no-cache
Sec-Fetch-Dest:document
Sec-Fetch-Mode:navigate
Sec-Fetch-Site:none
Sec-Fetch-User:?1
Upgrade-Insecure-Reque
User-Agent:Mozilla/5.0 (Macintosh Intel Mac 0SX 10_14_1) AppleWebKit/537.36 （KHTML,like Gecko)Chrome/83.0.4103.97 Safari/537.3
4Btransferred2BresourcesFinish:2ms
```
<!-- OCR_END -->

￼

## Cookie测试
---

| 视图层 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse
# Create your views here.
def test_cookie(request):
    obj = HttpResponse('OK')
    obj.set_cookie('name','zls')
    return obj
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来～
- 曾老湿

```http
127.0.0.1:8000/test_cookie/x
×+ ←→C127.0.0.1:8000/test_cookie/ 应用zabbix-apiCanlUseiview组件|Element曾志高翔（DriverZe
OK
Elements
ConsoleSources
Network
Memory
Application
Security
QPreserve logDisable cacheOnline
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
45ms
50ms
55ms
60ms
65ms
70ms
75ms
80ms
85ms
90ms
95ms
100ms
105ms
1
Name
Headers
Initiator
Timing
Cookies
.121.0.0.1.000
test_cookie/ ReferrerPolicy:no-referrer-when-downgrade
Response Headers
view source
Content-Length:2
Content-Type:text/html;charset=utf-8
Date：Fri,19 Jun 2020 14:20:32 GMT
Server:WSGIServer/0.2 CPython/3.6.4
Set-Cookie:
me=zls;Path=/ 第一次请求：代码返回给浏览器
X-Frame-Optio
ons:SAMEORIGIN
Request Headers
viewsource
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.
9
Accept-Encoding:gzip, deflate,br
Accept-Language:zh-CN,zh;q=0.9
Cache-Control:no-cache
Connection:keep-alive
Cookie:name=zls
第二次请求：浏览器带着cookie去请求服务器
Host:127.0.0.1:8000
Pragma:no-cache
Sec-Fetch-Dest:document
Sec-Fetch-Mode:navigate
Sec-Fetch-Site:none
Sec-Fetch-User:?1
Upgrade-Insecure-Requests:1
User-Agent:Mozilla/5.0 (Macintosh;Intel Mac 0SX10_14_1)AppleWebKit/537.36（KHTML,like Gecko)Chrome/83.0.4103.97 Safari/537.3
Btransferred
2BresourcesFinish:3msDOMContentLoaded:16msLoad:16ms
What's Newx
Rendering
```
<!-- OCR_END -->

￼

---

| 设置Cookie |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^set_cookie/', views.set_cookie),
    url(r'^get_cookie/', views.get_cookie),
]
```

```plain
from django.shortcuts import render,HttpResponse
# Create your views here.
def set_cookie(request):
    obj = HttpResponse('set_cookie')
    obj.set_cookie('name','zls')
    return obj
```

<!-- OCR_START -->
```http
127.0.0.1:8000/set_cookie/ →C127.0.0.1:8000/set_cookie/ 应用zabbix-apiCanlIUseiview组件IElement曾志高翔（Drivere..
set_cookie
ElementsConsole
Sources
Network
Performance
Memory
Application
QPreserve logDisable cacheOnline
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
60ms
65ms
100ms
105ms
Response
Initiator Timing Cookies
setcookie/ General
RequestURL:http://127.0.0.1:8000/set_cookie/ RequestMethod:GET
Status Code:2000K
Remote Address:127.0.0.1:8000
ReferrerPolicy:no-referrer-when-downgrade
Response Headers
view source
Content-Length:10
Content-Type:text/html;charset=utf-8
Date:Fri,19 Jun 2020 14:27:01GMT
Server:WSGIServer/0.2 CPython/3.6.4
Set-Cookie:name=zls;Path=/ 曾老湿
X-Frame-Options:SAMEORIGIN
```
<!-- OCR_END -->

￼

---

| 获取Cookie |
| :--- |

```plain
from django.shortcuts import render,HttpResponse
# Create your views here.
def get_cookie(request):
    obj = HttpResponse('get_cookie')
    print(request.COOKIES)
    return obj
```

<!-- OCR_START -->
- 曾老湿

```http
127.0.0.1:8000/get_cookie/ →C127.0.0.1:8000/get_cookie/ 应用zabbix-apiCanlUseiview
组件|Element曾志高翔（DriverZe.
get_cookie
Network
QPreserve logDisable cacheOnline
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
45ms
50ms
55ms
60ms
65ms
70ms
75ms
80ms
85ms
90ms
95ms
100ms
105ms
Headers
Preview Response Initiator Timing Cookies
get_cookiel
General
Request URL:http://127.0.0.1:8000/get_c0okie/ Request Method: GET
Status Code:2000K
Remote Address:127.0.0.1:8000
ReferrerPolicy:no-referrer-when-downgrade
Resp
onse Headers
view source
Content-Length:10
Content-Type:text/html; charset=utf-8
Date:Fri,19 Jun2020 14:27:37 GMT
Server:WSGIServer/0.2 CPython/3.6.4
X-Frame-Options:SAMEORIGIN
Request Headers
view source
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0
9
Accept-Encoding:gzip,deflate, br
Accept-Language:zh-CN,zh;q=0.9
Cache-Control:no-cache
Connection:keep-alive
Cookie:name=zls
Host:127.0.0.1:8000
Pragma:no-cache
Sec-Fetch-Dest:document
Sec-Fetch-Mode:navigate
Sec-Fetch-Site:none
3Btransferred
10Bresoure
Finish:3ms
d:18ms
Load:17ms
```
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿

```text
cookie_sessionappo1views.py
Project
settings.py
urls.py
views.pyx
cookie_session
~/PycharmProjects/cookie_session
from django.shortcuts import render HttpResponse
app01
#Createyour views here
migrations
def set_cookie(request):
obj =HttpResponse(’set_cookie') admin.py obj.set_cookie('name''zls'） apps.py return obj
models.py
tests.py
def
get_cookie（request):
views.py
obj=HttpResponse('get_cookie')
print（request.cooKIES)
cookie_session
_init_.py
return obi
settinas.DV
Run:
dicookie_sessionx
[19/Jun/2020 14:27:37]GET/get_co0kie/ HTTP/1.1 20010
name':'zls'}
```
<!-- OCR_END -->

￼

## 取Cookie的值记录登录状态
---

| 登录页面 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
</head>
<body>
<form action="" method="post">
    <input type="text"  name="name">
    <input type="text"  name="pwd">
    <input type="submit"  name="登录">
</form>
</body>
</html>
```

```plain
from django.shortcuts import render,HttpResponse
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    else:
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        if name == 'zls' and pwd == '123':
            #登录 成功，写到客户端浏览器 cookie
            obj = HttpResponse('登录成功')
            obj.set_cookie('is_login',True)
        else:
            return HttpResponse('用户名或密码错误')
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^set_cookie/', views.set_cookie),
    url(r'^get_cookie/', views.get_cookie),
    url(r'^login/', views.login),
]
```

<!-- OCR_START -->
- 登录页面
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanIUseivew
- 组件|Element
- zls
- 123
- 提交
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录成功

```http
127.0.0.1:8000/login/ ←→C
127.0.0.1:8000/login/ 应用zabbix-api
CanlUseiview
组件|Element
ElementsConsole Sources
Network
Lign
QPreserve logDisable cacheOnline
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
60ms
85m
90ms
95m
100ms
105ms
Name
Initiator
Timing
Cookies
login/ Ger
RequestURL:http://127.0.0.1:8000/login/ Request Method: POST
Status Code:2000K
RemoteAddress:127.0.0.1:8000
RefererPolicy:no-referrer-when-downgrade
Response Headers
view source
Content-Length:12
Content-Type:text/html;charset=utf-8
Date:Sat,20 Jun2020 04:39:00 GMT
Server:WSGIServer/0.2CPython/3.6.4
Set-Cookie:is_login=True;Path=/ 曾老湿
X-Frame-Options:SAMEORIGIN
```
<!-- OCR_END -->

￼

---

| 订单页面 |
| :--- |

只有登录后，才能看到订单页面，所以我们要取出Cookie

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    else:
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        if name == 'zls' and pwd == '123':
            #登录 成功，写到客户端浏览器 cookie
            obj = HttpResponse('登录成功')
            obj.set_cookie('is_login',True)
            return obj
        else:
            return HttpResponse('用户名或密码错误')
def order(request):
    is_login = request.COOKIES.get('is_login')
    if is_login:
        return HttpResponse('我是订单页面，登录后才能看到')
    else:
        return redirect('/login/')
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^set_cookie/', views.set_cookie),
    url(r'^get_cookie/', views.get_cookie),
    url(r'^login/', views.login),
    url(r'^order/', views.order),
]
```

<!-- OCR_START -->
- 我是订单页面，登录后才能看到
- 曾老湿

```http
127.0.0.1:8000/order/ →C127.0.0.1:8000/order/ 应用zabbix-api
CanIUse
Viview
组件|Element
ElementsConsole Sources
Network
PerformanceMemoryApplication
Security
Lighthouse
QPreservelogDisable cacheOnline
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
50ms
55ms
60ms
65ms
70ms
85m
90m
95m
100ms
105ms
Name
Response
InitiatorTimingCookies
General
RequestURL:http://127.0.0.1:8000/order/ Request Method: GET
Status Code:2000K
Remote Address:127.0.0.1:8000
Referrer Policy:no-referrer-when-downgrade
Response Headers
view source
Content-Length:42
Content-Type:text/html;charset=utf-8
Date:Sat,20 Jun 2020 06:07:52 GMT
Server:WSGIServer/0.2CPython/3.6.4
X-Frame-Options:SAMEORIGIN
Request Headers
viewsource
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.
9
Accept-Encoding:gzip, deflate,br
Accept-Language:zh-CN,zh;q=0.9
Cache-Control:no-cache
Connection:keep-alive
Cookie:is_login=True
Host:127.0.0.1:8000
Pragma:no-cache
Sec-Fetch-Dest:document
Sec-Fetch-Mode:navigate
Sec-Fetch-Site:none
Sec-Fetch-User:?1
requests
Btransferred
42Bresources
Finish:2msDOMContentLoaded:15msLoad:14ms
Upgrade-lnsecure-Requests:1
What'sNewx
Rendering
```
<!-- OCR_END -->

￼

---

| 购物页面 |
| :--- |

现在我们写一个购物页面，那这个购物页面是不是也要获取Cookie。如此一来，我们是不是可以把获取Cookie这波操作写成一个装饰器?

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
#  登录认证装饰器
def login_auth(func):
    def inner(request,*args,**kwargs):
        is_login = request.COOKIES.get('is_login')
        if is_login:
            res = func(request,*args,**kwargs)
            return res
        else:
            return redirect('/login/')
    return inner
```

使用装饰器，来装饰购物页面和订单页面

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
#  登录认证装饰器
def login_auth(func):
    def inner(request,*args,**kwargs):
        is_login = request.COOKIES.get('is_login')
        if is_login:
            res = func(request,*args,**kwargs)
            return res
        else:
            return redirect('/login/')
    return inner
def login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    else:
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        if name == 'zls' and pwd == '123':
            #登录 成功，写到客户端浏览器 cookie
            obj = HttpResponse('登录成功')
            obj.set_cookie('is_login',True)
            return obj
        else:
            return HttpResponse('用户名或密码错误')
@login_auth
def order(request):
    return HttpResponse('我是订单页面，登录后才能看到')
@login_auth
def shopping(request):
    return HttpResponse('我是购物页面，登录后才能看到')
```

<!-- OCR_START -->
- 我是购物页面，登录后才能看到
- 我是订单页面，登录后才能看到
- 曾老湿

```http
127.0.0.1:8000/shopping
127.0.0.1:8000/shopping/ 应用zabbix-api
CanlUseiview
组件|Element
127.0.0.1:8000/order/ C127.0.0.1:8000/order/ 应用zabbix-api
CanIUseiview组件IElement
Pres
10ms
15ms
20ms
25ms
30ms
40ms
45ms
50ms
55ms
60ms
65ms
70ms
75ms
80ms
85ms
90ms
95ms
100ms
105ms
11
Nam
Headers
Preview
Response
Initiator
Timing
Cookies
Content-Length:42
Content-Type:text/html;charset=utf-8
Date:Sat,20Jun202006:07:52 GMT
Server:wSGIServer/0.2CPython/3.6.4
X-Frame-Options:SAMEORIGIN
Request Headers
view source
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,1mage/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0
Accept-Encoding: gzip, deflate, br
Accept-Language:zh-CN,zh;q=0.9
Cache-Control:no-cache
Connection:keep-alive
Cookie:is_login=True
```
<!-- OCR_END -->

￼

## Cookie的其他参数
---

| 登录后重定向到之前访问的页面 |
| :--- |

举例，如果访问shopping页面，但是需要你登录，所以会自动跳转到登录页面，但是登录之后，我们需要再回到刚才的shopping页面

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
#  登录认证装饰器
def login_auth(func):
    def inner(request,*args,**kwargs):
        # 拿到之前的访问路径
        # url = request.path这个方式不行，因为取不到数据部分
        url = request.get_full_path()
        is_login = request.COOKIES.get('is_login')
        if is_login:
            res = func(request,*args,**kwargs)
            return res
        else:
            return redirect('/login/?next=%s'%url)
    return inner
def login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    else:
        next = request.GET.get('next')
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        if name == 'zls' and pwd == '123':
            if next:
                #登录 成功，写到客户端浏览器 cookie
                obj = redirect(next)
            else:
                obj = redirect('/shopping/')
            obj.set_cookie('is_login',True)
            return obj
        else:
            return HttpResponse('用户名或密码错误')
@login_auth
def order(request):
    return HttpResponse('我是订单页面，登录后才能看到')
@login_auth
def shopping(request):
    return HttpResponse('我是购物页面，登录后才能看到')
```

<!-- OCR_START -->
- 登录页面
- ←→C
- 127.0.0.1:8000/ogin/next=/shopping/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- zls
- 123
- 提交
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
127.0.0.1:8000/shopping/
←→C127.0.0.1:8000/shopping/
8
应用zabbix-apiCanlUseiview组件IElemen
我是购物页面，登录后才能看到
曾老湿
<!-- OCR_END -->

￼

---

| Cookie加盐 |
| :--- |

保证 数据安全。token

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^salt_cookie/', views.salt_cookie),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def salt_cookie(request):
    object = HttpResponse('OK')
    object.set_signed_cookie('name','zls',salt='123')
    return object
```

<!-- OCR_START -->
```http
127.0.0.1:8000/salt.cookie/ 别离开我啊，小老弟，点回来～
→C127.0.0.1:8000/salt_cookie/ 9
应用zabbix-apiCanlUseiview
组件|Element
OK
Elements Console Sources
Network
PerformanceMemory
Application
Security
Lighthouse
：X
QPreserve logDisable cacheOnline
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
45ms
50ms
55ms
60ms
65ms
70ms
80ms
85m
90ms
95ms
100ms
105ms
Name
Headers
Preview
ResponseInitiatorTimingCookies
salt_cookiel
General
RequestURL:http://127.0.0.1:8000/salt_c00kie/ Request Method: GET
Status Code:2000K
Remote Address:127.0.0.1:8000
ReferrerPolicy:no-referrer-when-downgrade
Response Headers
view source
Content-Length:2
Content-Type:text/html; charset=utf-8
Date:Sat,20 Jun 2020 06:41:09GMT
Server:WSGIServer/0.2CPython/3.6.4
Set-Cookie:name=zls:1jmXBd:rBAAiuccWBTZQr7EswLFax87Nbc;Path=/ 曾老湿
```
<!-- OCR_END -->

￼

---

| Cookie max_age |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def salt_cookie(request):
    object = HttpResponse('OK')
    object.set_cookie('name','zls',max_age=5) # 5秒后失效
    return object
def get_cookie(request):
    name = request.COOKIES.get('name')
    print(name)
    return HttpResponse('OK')
```

<!-- OCR_START -->
cookie_sessionapp01
views.py
Project
settings.py
urls.py
login.html x
cookie_session ~/PycharmProjects/cookie_session
1
from django.shortcuts import render,HttpResponse,redirect
app01
2
3
# Create your views here.
migrations
4
def salt_cookie(request):
_init_.py
object =HttpResponse（'OK')
admin.py
6
object.set_cookie(name''zlsmax_age=5）#5秒后失效
apps.py
7
return object
models.py
8
tests.py
9
def get_cookie(request):
10
name
=request.coOKIES.get('name')
11
print(name)
cookie_session
12
return HttpResponse('OK')
13
getcookie()
Run:
dicookie_sessionx
File"/Users/driverzeng/PycharmProjects/cookie_session/appo1/views.py"
line 10
SyntaxError: invalid syntax
Performing system checks...
System check identified no issues （0 silenced).
You have 13 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin,auth,contenttypes,sessions.
Run 'python manage.py migrate' to apply them.
June 20,2020-06:46:33
Djangoversion 1.11.18,using settings'cookie_session.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
[20/Jun/2020 06:46:41]"GET /salt_cookie/HTTP/1.1" 2002
June 20,2020-06:48:24
[20/Jun/2020 06:48:28]"GET/salt_c00kie/HTTP/1.1"2002
zls
[20/Jun/2020 06:48:29]
"GET/get_cookie/HTTP/1.1"2002
[20/Jun/2020 06:48:38]
"GET/salt_cookie/HTTP/1.1"2002
[20/Jun/2020 06:48:39]"GET/get_c0okie/HTTP/1.1"2002
None
20/Jun/2020 06:48:53]"GET/get_c0okie/HTTP/1.1"2002
曾老湿
DriverZeng
<!-- OCR_END -->

￼

---

| Cookie expires |
| :--- |

也是设置超时时间

传一个datetime对象

---

| Cookie path |
| :--- |

设置路径

path='/index/'只有访问index页面的时候，才会记录Cookie

---

| Cookie domain |
| :--- |

设置域名下生效

domain='blog.driverzeng.com'

---

| Cookie secure |
| :--- |

默认是False

浏览器通过HTTPS来回传Cookie

---

| Cookie httponly |
| :--- |

不允许前端JS操作Cookie，在前端内容部分有演示。

## 删除Cookie
```plain
def logout(request):
    rep = redirect("/login/")
    rep.delete_cookie("user")  # 删除用户浏览器上之前设置的usercookie值
    return rep
```

## Session的简单使用
啥是Session？看我另外一篇博客。Cookie保存在浏览器，Session存储在服务器

<!-- OCR_START -->
- 不讲看不懂的session解析图
- 服务器
- 第一次请求携带的cookie:{
- equest.session[username"]="yuan
- set_cookie:sessionid=123ghrjsdg
- 浏览器
- (2)
- (1)
- 第二次请求携带的cookie：{sessionid=123ghrjsdg}
- request.session["username"]
- django-session表
- session-key
- session-data
- 123ghrjsdg
- {"username":"yuan")
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| Session做的事情 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^set_session/', views.set_session),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def set_session(request):
    # 写session
    request.session['name'] = 'zls'
    '''
    这一句话相当于做了 三件事
    1.生成随机字符串 aabbccddeeff
    2.去数据库存储
        随机字符串       值(字典的形式)           超时时间
        aabbccddeeff    {'name':'zls'}         超时时间
    3.写入Cookie: set_cookie('sessionid','aabbccddeeff')
    '''
    return HttpResponse('ok')
```

<!-- OCR_START -->
127.0.0.1:8000/salt_.cookie/
OperationalErrorat /setsessid
←→
127.0.0.1:8000/set_session/
应用zabbix-api
CanlUse
iview
组件|Element
no such table:django_session
RequestMethod:GET
RequestURL:http://127.0.0.1:8000/set_session/
Django Version:1.11.18
ExceptionType:OperationalError
Exception Value:no such table: django_session
ExceptionLocation:/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/django/db/backends/sqlite3/base.pyinexecuteline328
PythonExecutable:/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6
Python Version:3.6.4
Python Path:('/Users/driverzeng/PycharmProjects/cookie_session',
/Library/Frameworks/Python.framework/Versions/3.6/1ib/python36.zip',
/Users/driverzeng/PycharmProjects/cookie_session',
Library/rameworks/Python.framework/Versions/3.6/1ib/python3.6/1
/Library/Frameworks/ython.framework/Versions/3.6/1ib/python3.6/site-packages，
/Applications/PyCharm.app/Contents/helpers/pycharmmatplotlib_backend)
Server time:Sat,20Jun202007:03:19+0000
Elements
Sources
Network
Perfomance
Memory
Application
Securty
Lighthouse
QPreserve logDisable cache
Online
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
45ms
50ms
55ms
60ms
65ms
70ms
75ms
80ms
85ms
90ms
95ms
100ms
105ms
11
Status
Type
Initiator
Size
Time
Wat
set_session
301
tex/html
Other
193B
500
document
128kB
87ms
曾老湿
<!-- OCR_END -->

￼

直接报错了，因为啥呢 ，因为刚才说了，做三件事，第二件事就是写入数据库，都没有 数据库也没有表，玩蛇~~~

迁移数据库，不需要咱们自己创建

```plain
MacBook-pro:cookie_session driverzeng$ python3 manage.py makemigrations
MacBook-pro:cookie_session driverzeng$ python3 manage.py migrate
```

<!-- OCR_START -->
- session[db]
- Databasedbschemasmaindjango_session
- dicookie_session
- Project
- settings.py
- urls.py
- main.django_session[db]x
- views.py
- login.html
- Database
- cookie_session/PycharmProjects/cookie_session
- Orows
- G+
- Tx:Auto
- Tab-se..dTSV)
- 下DDLViewQuery+G
- app01
- <Filter criteria>
- 8db1
- migrations
- session_key
- session_data
- expire_date
- _init_.py
- schemas1
- admin.py
- main
- auth_group
- apps.py
- models.py
- tests.py
- auth_permission
- auth_user
- auth_user_groups
- auth_user_user_permissions
- django_admin_log
- wsgi.py
- django_session
- templates
- db.sqlite3
- char(40)
- manage.py
- session_data text
- expire_datedatetime
- lli External Libraries
- Scratchesand Consoles
- i django_session_expire_date_a5c62663(expire_date)
- ju sqlite_autoindex_django_session_1(session_key)UNIQUE
- sqlite_master
- 曾老湿
- sqlite_sequence
<!-- OCR_END -->

￼

再次访问页面

<!-- OCR_START -->
- 曾老湿

```http
127.0.0.1:8000/salt_cookie/
127.0.0.1:8000/setsession/ ←→C
127.0.0.1:8000/set_session/ 应用zabbix-apiCanlUseiview
组件|Element
ok
ElementsConsole
SourcesNetwork
Performance
Memory
Application
Security
QPreserve logDisable cache
Online
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
45ms
50ms
55ms
60ms
65ms
70ms
75ms
80ms
35ms
90ms
95ms
100ms
105ms
Response
InitiatorTimingCookies
set_session/ General
Request URL:http://127.0.0.1:8000/set_session/ Request Method: GET
Status Code:200 0K
Remote Address:127.0.0.1:8000
ReferrerPolicy:no-referrer-when-downgrade
Response Headers
view source
Content-Length:2
Content-Type:text/html;charset=utf-8
Date:Sat,20Jun202007:31:02GMT
Server:WSGIServer/0.2CPvthon/3.6.4
Set-Cookie:sessionid=xbja15ruo0rcjb0bfrujwdtpbkg8wq7q;expires=Sat,04-Jul-2020 07:31:02 GMT;Http0nly;Max-Age=1209600;Path=/ Vary:Cookie
X-Frame-Options:SAMEORIGIN
```
<!-- OCR_END -->

￼

查看数据库

<!-- OCR_START -->
- cookie_session[~/PycharmProjects/cooki
- ssion]-main.django_session[db]
- Database
- as）maindjango_session
- di
- Project
- settings.py
- urls.py
- main.django_sesson [db]x
- views.py
- login.htmlx
- cookie_s
- ession ~/PycharmProjects/cookie_session
- 1row
- Tx:Auto
- 》Tab-se..d（TSVDDLViewQuery
- app01
- <Filter criteria>
- migrations
- session_key
- session_data
- schemas1
- xbja15ruo0rcjb0bfrujwdtpbkg8wq7q
- MjBkNzMxZTRiZWE5NTMwNjY2M2VjZjBiMj.
- 407:31:02.071
- main
- admin.py
- auth_group
- apps.py
- auth_group_permissions
- tests.py
- auth_permission
- auth_user
- auth_user_groups
- ssion
- auth_user_user_permissions
- django_admin_log
- _content_type
- 曾老湿
- wsgi.py
<!-- OCR_END -->

￼

---

| 获取session |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def set_session(request):
    # 写session
    request.session['name'] = 'zls'
    '''
    这一句话相当于做了 三件事
    1.生成随机字符串 aabbccddeeff
    2.去数据库存储
        随机字符串       值(字典的形式)           超时时间
        aabbccddeeff    {'name':'zls'}         超时时间
    3.写入Cookie: set_cookie('sessionid','aabbccddeeff')
    '''
    return HttpResponse('ok')
def get_session(request):
    return HttpResponse('get_session')
```

<!-- OCR_START -->
- 曾老湿

```http
127.0.0.1:8000/salt.cookie/x127.0.0.1:8000/get_session/ →C127.0.0.1:8000/get_session/ 应用zabbix-api
CanlUseiview组件IElement
get_session
Network
Preserve log Disable cacheOnline
5ms
10ms
15ms
20ms
25ms
30ms
35ms
40ms
45ms
50ms
55ms
60ms
65ms
70ms
75ms
80ms
85ms
90ms
95ms
100ms
105ms
11
Name
Headers
Preview
Response
Initiator Timing Cookies
get_session/ Request Method: GET
Status Code:2000K
RemoteAddress:127.0.0.1:8000
ReferrerPolicy:no-referrer-when-downgrade
Response Headers
view source
Content-Length:11
Content-Type:text/html; charset=utf-8
Date:Sat, 20 Jun 2020 07:34:31 GMT
Server:WSGIServer/0.2CPython/3.6.4
X-Frame-Options:SAMEORIGIN
Request Headers
viewsource
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0
9
Accept-Encoding:gzip, deflate，br
Accept-Language:zh-CN,zh;q=0.9
Cache-Control:no-cache
Connection:keep-alive
Cookie:is_login=True; sessionid=xbja15ruo0rcjbobfrujwdtpbkg8wq7q
Host:127.0.0.1:8000
Pragma:no-cache
Sec-Fetch-Dest: document
Sec-Fetch-Mode:navigate
Sec-Fetch-Site:none
Sec-Fetch-User:?1
Upgrade-lnsecure-Requests:1
User-Agent:Mozilla/5.0 (Macintosh;Intel Mac 0SX10_14_1) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/83.0.4103.106 Safari/537.3
```
<!-- OCR_END -->

￼

<!-- OCR_START -->
- settings.py
- urls.py
- main.django_session[db]
- views.py x
- login.html
- 1row
- Tx:Autov
- >Tab-se...d(TSV)
- DDL
- View Query
- Q <Filter criteria>
- session_data
- expire date
- xbja15ruo0rcjb0bfrujwdtpbkg8wq7q
- ljBkNzMxZTRiZWE5NTMwNjY2M2VjZjBiMjI
- 17:34:28.940
<!-- OCR_END -->

￼

随机字符串是跟浏览器相关的，数据是根据字符串相关的

---

| 取出随机字符串 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def set_session(request):
    # 写session
    request.session['name'] = 'zls'
    '''
    这一句话相当于做了 三件事
    1.生成随机字符串 aabbccddeeff
    2.去数据库存储
        随机字符串       值(字典的形式)           超时时间
        aabbccddeeff    {'name':'zls'}         超时时间
    3.写入Cookie: set_cookie('sessionid','aabbccddeeff')
    '''
    return HttpResponse('ok')
def get_session(request):
    # 取出name字段 对应的值
    # 1.去Cookie中取出随机字符串
    # 2.取Session那个表去查询，取出session_data的数据，解密成字典，然后取出name的值
    name = request.session['name']  # 一句话搞定
    print(name)
    return HttpResponse('get_session')
```

<!-- OCR_START -->
cookie_session[~/PycharmProjects/cookie_session]-
.../appo1/views.py[cookie_session]
okie session
app01views.py
Project
urls.pyX
main.django_session[db]
login.html
from django.shortcuts import render.HttpResponse,redirect
app01
# Create your views here.
migrations
def set _session（request）:
_init_.py
#写session
admin.py
request.session[name']='zs
apps.py
models.py
这一句话相当于做了三件事
生成随机字符串
tests.py
aabbccddeeff
10
2.去数据库存储
views.py
11
随机字符串
值（字典的形式）
超时时间
cookie_session
12
{'name':'zls'}
13
3.写入Cookie:set_cookie('sessionid’，aabbccddeeff'）
settings.py
14
urls.py
15
return HttpResponse('ok')
wsgi.py
17
st):
templates
18
字段对应的值
db.sqlite3
19
manage.py
20122
#2.取Session那个表去查询，
取出session_data的数据，解密成字典，然后取出name的值
l External Libraries
name=request.session['name’]#-句话搞定
Scratches and Consoles
print(name)
23
return HttpResponse('get_session')
setsession()
Run:
dicookie_sessionx
Quit the server with CONTROL-C.
Performing system checks...
June 20,2020-07:53:39
System check identified no issues (0 silenced）.
June 20,2020-07:53:56
Django version 1.11.18, using settings
ession.settings'
Starting development server at http://127.0
Django version 1.11.18, using settings'cookie_session.settings
Dune20,2020-07:54:40
Starting development server at http://127.0.0.1:8000/
rver with CONTROL-C.
曾老湿
<!-- OCR_END -->

￼

## Session的其他属性
```plain
# 获取、设置、删除Session中数据
request.session['k1']
request.session.get('k1',None)
request.session['k1'] = 123
request.session.setdefault('k1',123) # 存在则不设置
del request.session['k1']
# 所有 键、值、键值对
request.session.keys()
request.session.values()
request.session.items()
request.session.iterkeys()
request.session.itervalues()
request.session.iteritems()
# 会话session的key
request.session.session_key
# 将所有Session失效日期小于当前日期的数据删除
request.session.clear_expired()
# 检查会话session的key在数据库中是否存在
request.session.exists("session_key")
# 删除当前会话的所有Session数据(只删数据库)
request.session.delete()
　　
# 删除当前的会话数据并删除会话的Cookie（数据库和cookie都删）。
request.session.flush() 
    这用于确保前面的会话数据不可以再次被用户的浏览器访问
    例如，django.contrib.auth.logout() 函数中就会调用它。
# 设置会话Session和Cookie的超时时间
request.session.set_expiry(value)
    * 如果value是个整数，session会在些秒数后失效。
    * 如果value是个datatime或timedelta，session就会在这个时间后失效。
    * 如果value是0,用户关闭浏览器session就会失效。
    * 如果value是None,session会依赖全局session失效策略。
```

## Session的其他配置
```plain
1. 数据库Session
SESSION_ENGINE = 'django.contrib.sessions.backends.db'   # 引擎（默认）
2. 缓存Session
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'  # 引擎
SESSION_CACHE_ALIAS = 'default'                            # 使用的缓存别名（默认内存缓存，也可以是memcache,redis），此处别名依赖缓存的设置
3. 文件Session
SESSION_ENGINE = 'django.contrib.sessions.backends.file'    # 引擎
SESSION_FILE_PATH = None                                    # 缓存文件路径，如果为None，则使用tempfile模块获取一个临时地址tempfile.gettempdir() 
4. 缓存+数据库
SESSION_ENGINE = 'django.contrib.sessions.backends.cached_db'        # 引擎
5. 加密Cookie Session
SESSION_ENGINE = 'django.contrib.sessions.backends.signed_cookies'   # 引擎
##  其他公用设置项：在settings.py中设置
SESSION_COOKIE_NAME ＝ "sessionid"                       # Session的cookie保存在浏览器上时的key，即：sessionid＝随机字符串（默认）
SESSION_COOKIE_PATH ＝ "/"                               # Session的cookie保存的路径（默认）
SESSION_COOKIE_DOMAIN = None                             # Session的cookie保存的域名（默认）
SESSION_COOKIE_SECURE = False                            # 是否Https传输cookie（默认）
SESSION_COOKIE_HTTPONLY = True                           # 是否Session的cookie只支持http传输（默认）
SESSION_COOKIE_AGE = 1209600                             # Session的cookie失效日期（2周）（默认）
SESSION_EXPIRE_AT_BROWSER_CLOSE = False                  # 是否关闭浏览器使得Session过期（默认）
SESSION_SAVE_EVERY_REQUEST = False                       # 是否每次请求都保存Session，默认修改之后才保存（默认）
```

<!-- OCR_START -->
- settings.py
- urls.pyx
- main.django_session[db]
- views.pyx
- login.html x
- 110
- TIME_ZONE='UTC
- 111
- 112
- USE_I18N = True
- 113
- 114
- USE_L10N = True
- 115
- 116
- USE_TZ=True
- 117
- 118
- 119
- # Static files （css,JavaScript,Images)
- 120
- #https://docs.djangoproject.com/en/1.11/howto/static-files/
- 121
- 122
- STATIC_URL='/static/
- 123
- ##Session的配置添加到settings中
- 124
- SESSION_COOKIE_NAME ="sessionid"
- #Session的cookie保存在浏览器上时的key，即：sessionid=随机字符串（默认）
- 125
- SESSION_COOKIE_PATH=
- #Session的cookie保存的路径（默认）
- 126
- SESSION_COOKIE_DOMAIN = None
- 127
- SESSION_COOKIE_SECURE = FaLse
- #是否Https传输cookie（默认）
- 128
- SESSION_COOKIE_HTTPONLY=True
- #是否Session的cookie只支持http传输（默认）
- 129
- SESSI0N_C00KIE_AGE=1209600
- #Session的cookie失效日期（2周）（默认）
- 130
- SESSION_EXPIRE_AT_BROWSER_CLOSE = FaLse
- #是否关闭浏览器使得Session过期（默认）
- ION_SAVE_EVERY_REQUEST =False
- 曾老湿
- #是否每次请求都保存Session，默认修改之后才保存（默认）
- DriverZeng
<!-- OCR_END -->

￼

## CBV加装饰器

<!-- OCR_START -->
- New Project
- Pure Python
- Location:
- /Users/driverzeng/PycharmProjects/cbv_session
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
- Templates folder:
- templates
- AngularJs
- B Bootstrap
- Application name:
- appo1l
- Foundation
- Enable Django admin
- HTML5 Boilerplate
- ReactApp
- React Native
- 曾老湿
- Cancel
- Create
- DriverZeng
<!-- OCR_END -->

￼

---

| 创建项目 |
| :--- |

1.注释csrf

2.创建用户表

```plain
from django.db import models
# Create your models here.
class User(models.Model):
    name = models.CharField(max_length=32)
    pwd = models.CharField(max_length=32)
```

3.做数据库迁移，创建django_session表

```plain
MacBook-pro:cbv_session driverzeng$ python3 manage.py makemigrations
MacBook-pro:cbv_session driverzeng$ python3 manage.py migrate
```

4.手动添加一条数据

<!-- OCR_START -->
- settings.py
- models.py
- main.app01_user[db]
- urls.py
- Database
- 1row
- Tx:Auto
- BB
- Tab-se..d(TSV)
- DDLViewQuery
- <Filter criteria>
- 7db1
- idname
- pwd
- schemas1
- 1zls
- 123
- main
- app01_user
- 田auth_group
- auth_group_permissions
- auth_permission
- auth_user
- auth_user_groups
- auth_user_user_permissions
- django_admin_log
- django_contenttype
- django_migrations
- django_session
- sqlite_master
- sqlite_sequence
- 曾老湿
- collations 3
- Driv
- /erZeng
<!-- OCR_END -->

￼

---

| 登录页面 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
</head>
<body>
<form action="" method="post">
    <div>
        用户:<input type="text" name="name">
    </div>
    <div>
        密码:<input type="password" name="pwd">
    </div>
    <input type="submit" value="登录">
</form>
</body>
</html>
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01  import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', views.Login.as_view()),
    url(r'^order/', views.Order.as_view()),
]
```

```plain
from django.shortcuts import render,HttpResponse,redirect
from django.views import View
from app01 import models
# Create your views here.
class Login(View):
    def get(self,request,*args,**kwargs):
        return render(request,'login.html')
    def post(self,request,*args,**kwargs):
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        ret = models.User.objects.filter(name=name,pwd=pwd).first()
        if ret:
            request.session['id']=ret.pk
            request.session['name']=ret.name
            return HttpResponse('登录成功')
        else:
            return HttpResponse('用户名密码错误')
class  Order(View):
    def get(self,request):
        return HttpResponse('我是订单页面,我查出来好多')
```

<!-- OCR_START -->
- 127.0.0.1:8000/salt.cookie
- 登录页面
- ←→C
- 127.0.0.1:8000/login/
- 8
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 用户：zls
- 密码：
- 登录
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 127.0.0.1:8000/salt_cookie/
- 127.0.0.1:8000/login/
- ←→C
- 应用zabbix-api
- CanlUse
- iview
- 组件|Elem
- 登录成功
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- settings.pyX
- models.py
- main.app01_user[db]x
- login.html
- urls.py
- main.django_se要1
- Database
- 1row
- Tx:Auto
- Tab-se..d(TSV)
- DDL
- ViewQuery
- <Filter criteria>
- db1
- session_key
- session_data
- expire_date
- schemas1
- jvmu4f1gbe40pbt0hpwl23tihsvz6lg0ZjUwNTY3YTkwNzZlMzY5Nzg0MWZlZjE0ZD...
- 08:50:09.096
- main
- app01_user
- auth_group
- auth_group_permissions
- auth_permission
- auth_user
- auth_user_groups
- auth_user_user_permissions
- django_admin_log
- django_contenttype
- django_migrations
- django_session
- 曾老湿
- sqlite_master
- DriverZenc
<!-- OCR_END -->

￼

---

| 给cbv加装饰器 |
| :--- |

装饰器加在函数上

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.views import View
from app01 import models
# Create your views here.
def login_auth(func):
    def inner(request, *args, **kwargs):
        url = request.get_full_path()
        if request.session.get('id'):
            res = func(request, *args, **kwargs)
        else:
            return redirect('/login/?next=%s' % url)
        return res
    return inner
class Login(View):
    def get(self, request, *args, **kwargs):
        return render(request, 'login.html')
    def post(self, request, *args, **kwargs):
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        res = models.User.objects.filter(name=name, pwd=pwd).first()
        if res:
            url = request.GET.get('next')
            request.session['id'] = res.pk
            request.session['name'] = res.name
            return redirect(url)
        else:
            return HttpResponse('用户名密码错误')
from django.utils.decorators import method_decorator
class Order(View):
    @method_decorator(login_auth)
    def get(self, request):
        userid = request.session.get('id')
        ## 通过userid查订单表
        return HttpResponse('我是订单页面,我查出来好多')
    @method_decorator(login_auth)
    def post(self,request):
        return HttpResponse('post')
```

装饰器加在类上

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.views import View
from app01 import models
# Create your views here.
def login_auth(func):
    def inner(request, *args, **kwargs):
        url = request.get_full_path()
        if request.session.get('id'):
            res = func(request, *args, **kwargs)
        else:
            return redirect('/login/?next=%s' % url)
        return res
    return inner
class Login(View):
    def get(self, request, *args, **kwargs):
        return render(request, 'login.html')
    def post(self, request, *args, **kwargs):
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        res = models.User.objects.filter(name=name, pwd=pwd).first()
        if res:
            url = request.GET.get('next')
            request.session['id'] = res.pk
            request.session['name'] = res.name
            return redirect(url)
        else:
            return HttpResponse('用户名密码错误')
from django.utils.decorators import method_decorator
@method_decorator(login_auth,name='get')
@method_decorator(login_auth,name='post')
class Order(View):
    # @method_decorator(login_auth)
    def get(self, request):
        userid = request.session.get('id')
        ## 通过userid查订单表
        return HttpResponse('我是订单页面,我查出来好多')
    # @method_decorator(login_auth)
    def post(self,request):
        return HttpResponse('post')
```

**总结：**

```plain
## cbv加装饰器
    -先导入:from django.utils.decorators import method_decorator
    -1 可以在方法上加装饰器:
        @method_decorator(login_auth)
    -2 可以在类上加
        @method_decorator(login_auth,name='post')
        @method_decorator(login_auth,name='get')
    -3 可以加在dishpatch方法上
        @method_decorator(login_auth)
        一旦加在dishpatch,说明,所有方法都加了装饰器
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:39:20  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/vmewu2>