# Python进阶32-Django forms组件

## Python进阶32-Django forms组件

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

* [forms组件功能介绍](https://blog.driverzeng.com/zenglaoshi/5805.html#toc_0)
* [项目案例](https://blog.driverzeng.com/zenglaoshi/5805.html#toc_1)
* [结合前端传递数据校验](https://blog.driverzeng.com/zenglaoshi/5805.html#toc_2)
* [渲染模板功能](https://blog.driverzeng.com/zenglaoshi/5805.html#toc_3)
* [渲染错误信息](https://blog.driverzeng.com/zenglaoshi/5805.html#toc_4)
* [局部钩子](https://blog.driverzeng.com/zenglaoshi/5805.html#toc_5)
* [全局钩子](https://blog.driverzeng.com/zenglaoshi/5805.html#toc_6)
* [实现注册功能](https://blog.driverzeng.com/zenglaoshi/5805.html#toc_7)

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

## forms组件功能介绍

***

| forms组件介绍 |
| :--- |

基本上就是一个类，可以校验前台传过来的字段

1.校验字段功能

2.渲染标签功能

3.渲染错误信息功能

例如写一个注册页面，如果页面中只需要输入用户名和密码，那就写一写if判断就好，但是如果有一堆注册信息要填写呢？

难道要写一万个判断嘛？会死人的，所以Django提供了forms组件，专门根据规则校验字段

## 项目案例

***

| 创建项目 |
| :--- |

```plain
### 路由 
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^index_form/', views.index_form),
]
```

```plain
### 失败的校验
from django.shortcuts import render,HttpResponse,redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
# 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name=forms.CharField(max_length=8,min_length=3)
    pwd=forms.CharField(max_length=8,min_length=3)
    # 校验邮箱格式
    email=forms.EmailField()
def index_form(request):
    # 生成对象，需要传入要校验的对象（数据是字典）
    dic = {'name':'zls','pwd':'123','email':'33'}
    myform = MyForm(dic)
    # is_vallid 方法 ，如果返回True则校验成功，反之则校验失败
    if myform.is_valid():
        return HttpResponse('校验成功')
    else:
        return HttpResponse('校验失败')
```

<!-- OCR_START -->
127.0.0.1:8000/index.form/
C127.0.0.1:8000/indexform/
9
应用zabbix-apiCanlUseiview组件|Element曾志高翔（DriverZe.
校验失败
曾老湿
<!-- OCR_END -->

￼

```plain
### 成功的校验
from django.shortcuts import render,HttpResponse,redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
# 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name=forms.CharField(max_length=8,min_length=3)
    pwd=forms.CharField(max_length=8,min_length=3)
    # 校验邮箱格式
    email=forms.EmailField()
def index_form(request):
    # 生成对象，需要传入要校验的对象（数据是字典）
    dic = {'name':'zls','pwd':'123','email':'33@qq.com'}
    myform = MyForm(dic)
    # is_vallid 方法 ，如果返回True则校验成功，反之则校验失败
    if myform.is_valid():
        return HttpResponse('校验成功')
    else:
        return HttpResponse('校验失败')
```

<!-- OCR_START -->
127.0.0.1:8000/index_form/
←→C127.0.0.1:8000/index_form/
应用zabbix-apiCanlUseiview组件|Element曾志高翔（DriverZe
校验成功
曾老湿
<!-- OCR_END -->

￼

```plain
### 打印校验通过的数据
from django.shortcuts import render,HttpResponse,redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
# 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name=forms.CharField(max_length=8,min_length=3)
    pwd=forms.CharField(max_length=8,min_length=3)
    # 校验邮箱格式
    email=forms.EmailField()
def index_form(request):
    # 生成对象，需要传入要校验的对象（数据是字典）
    dic = {'name':'zls','pwd':'123','email':'33@qq.com'}
    myform = MyForm(dic)
    # is_vallid 方法 ，如果返回True则校验成功，反之则校验失败
    if myform.is_valid():
        # 打印校验通过的数据
        print(myform.cleaned_data)
        return HttpResponse('校验成功')
    else:
        return HttpResponse('校验失败')
```

<!-- OCR_START -->
- formsssssapp01views.py
- Project
- settings.py
- urls.py
- indexform.html
- views.py
- formsssss ~/PycharmProjects/formsssss
- app01
- #Create your views here.
- migrations
- _init_py
- #forms组件数据校验功熊
- #0.导入模块
- admin.py
- from django import forms
- apps.py
- #1.是个类，先要继承Form
- models.py
- 10
- class MyForm(forms.Form):
- tests.py
- 11
- #2.定义一个属性可以校验字符串类型
- 12
- #限制字符串，最大长度是8最小长度是3
- 13
- name=forms.CharField(max_length=8,min_length=3)
- formsssss
- 14
- pwd=forms.CharField(max_Length=8,min_length=3)
- 15
- #校验邮箱格式
- 1617
- email=forms.EmailField(）
- wsgi.py
- 18
- 19
- def index_form(request):
- templates
- 20
- #生成对象，需要传入要校验的对象（数据是字典）
- 21
- dic={’name’zls′pwd’'123′email′:33aqq.com′}
- db.sqlite3
- 22
- myform = MyForm（dic)
- manage.py
- 23
- #is_vaLLid 方法，如果返回True则校验成功，反之则校验失败
- ll External Libraries
- 24
- ifmyform.is_valid(）:
- 25
- #打印校验通过的数据
- Scratches and Consoles
- 26
- print(myform.cleaned_data)
- 27
- return HttpResponse（校验成功）
- 28
- else:
- 29
- Run:
- dj formssss x
- Performing system checks...
- System check identified no issues (0 silenced).
- You have 13 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
- Run 'python manage.py migrate' to apply them.
- June 17,2020-14:50:34
- Django version 1.11.18, using settings 'formsssss.settings
- Starting development server at http://127.0.0.1:8000/
- Quit the server with CONTROL-C.
- {'name':'zls'，'pwd':'123′,
- 'email':'33@qq.com'}
- [17/Jun/202014:50:35]"GET/index_form/HTTP/1.1"20012
- 曾老湿
<!-- OCR_END -->

￼

```plain
### 打印错误信息
from django.shortcuts import render,HttpResponse,redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
# 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name=forms.CharField(max_length=8,min_length=3)
    pwd=forms.CharField(max_length=8,min_length=3)
    # 校验邮箱格式
    email=forms.EmailField()
def index_form(request):
    # 生成对象，需要传入要校验的对象（数据是字典）
    dic = {'name':'zls','pwd':'12','email':'33@qq.com'}
    myform = MyForm(dic)
    # is_vallid 方法 ，如果返回True则校验成功，反之则校验失败
    if myform.is_valid():
        # 打印校验通过的数据
        print(myform.cleaned_data)
        return HttpResponse('校验成功')
    else:
        print(myform.errors)
        return HttpResponse('校验失败')
```

<!-- OCR_START -->
- 曾老湿

```text
formsssss
app01views.py
dj
Project
settings.py
urls.py
index_form.html
views.py
formsssss
app01
# Create your views here.
migrations
init_.py
#forms组件数据狡验功能
admin.py
#0.导入模块
from django
apps.py
#1.是个类，先
models.py
10
class MyForm(forms.Form):
tests.py
2.定义一个属性可以校验字符患类型
views.py
#限制字符串，最大长度是8最小长度是3
13
name=forms.CharField(max_Lens formsssss 14 settings.py
15
16
email=forms.EmailField()
urls.py
wsgi.py
18
19
def index_form(request):
templates
#生成对象，需要传入要校验的对象（数据是字典）
index_form.html
21
dic=’name'gzlspwd:'12email'g33aqq.com}
db.sqlite3
22
myform =MyForm(dic)
manage.py
23
如果返回True则校验成功，反之则校验失败
lExternal Libraries
ifmyform.is_valid(）: Scratches and Consoles #打印校验通过的数据 print(myform.cleaned_data)
return HttpResponse（校验成功’）
else:
print(myform.errors)
return HttpResponse(‘校验失败'） if myform.is_valid() Run: [17/Jun/202014:54:21]GET/index_form/HTTP/1.1"20012
class="errorlist"><li>pwd<ul class=errorlist"><li>Ensure this value has at least 3 characters(it has 2).</li></ul>/li></ul>
```
<!-- OCR_END -->

￼

## 结合前端传递数据校验

***

| 后端代码 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
# 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name=forms.CharField(max_length=8,min_length=3)
    pwd=forms.CharField(max_length=8,min_length=3)
    # 校验邮箱格式
    email=forms.EmailField()
def index_form(request):
    if request.method == 'GET':
        return render(request,'index_form.html')
    elif request.method == 'POST':
        print(request.POST)
        # 生成对象，需要传入要校验的对象（数据是字典）
        myform = MyForm(request.POST)
        # is_vallid 方法 ，如果返回True则校验成功，反之则校验失败
        if myform.is_valid():
            # 打印校验通过的数据
            print(myform.cleaned_data)
            return HttpResponse('校验成功')
        else:
            print(myform.errors)
            return HttpResponse('校验失败')
```

***

| 前端代码 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>forms组件</title>
</head>
<body>
<form action="" method="post">
    <lable>用户:<input type="text" name="name"></lable>
    <lable>密码:<input type="text" name="pwd"></lable>
    <lable>邮箱:<input type="text" name="email"></lable>
    <input type="submit" value="提交">
</form>
</body>
</html>
```

<!-- OCR_START -->
- forms组件
- ←→C
- 127.0.0.1:8000/index_form/
- 应用
- zabbix-ap
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe
- 用户：zls
- 密码：123
- 邮箱：111
- 提交
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
127.0.0.1:8000/index_form/
→C127.0.0.1:8000/indexform/
应用zabbix-apiCanIUseiview组件IElement曾志高翔（DriverZe
校验失败
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿

```text
formssssappo01views.py
Project
settings.pyx
urls.pyx
indexform.html
views.py
formsssss~/PycharmProjects/formssss
8
from django import forms
app01
migrations
10
_init_.py
11
#1.是个类，先要继承Form
class MyForm(forms.Form):
admin.py
13
#2.定义一个属性可以校验字符串类型
apps.py
name =forms.CharField(max_Length=8,min_Length=3)
tests.py
16
pwd=forms.CharField(max_Length=8,min_Length=3)
17
#校验邮箱格式
views.py
18
email= forms.EmailField（)
formsssss
19
_init_.py
settings.py
20
urls.py
if request.method= 'GET':
23
return render（request,‘index_form.html')
wsgi.py
templates
25
print（request.POST)
index_form.html
26
#生成对象，需要传入要校验的对象（数据是字典）
db.sqlite3
22 28 2
manage.py
#is_vallid 方法，
如果返回True则校验成功，反之则校验失败
l External Libraries
ifmyform.is_valid(）: 30 Scratches and Consoles #打印校验通过的数据
31
print(myform.cleaned_data)
return HttpResponse（校验成功）
else:
3435
print(myform.errors） return HttpResponse（‘校验失败'） elif request.method ==POST' Run:
djformsssssX
Performing system checks...
System check identified no issues (0 silenced）. You have 13unapplied migration（s）.Your project may not work properly until you apply the migrations for app（s）:admin,auth,contenttypes, sessions. Run 'python manage.py migrate' to apply them. June 17,2020-15:42:24
Djangovrsion1using settingsformssetting
Starting development server at http://127.0.0.1:8000/ Quit the server with CONTROL-C.
Kul class="errorlist"><li>email<ul class="errorlist"><li>Enter avalid email address.</li></ul></li></ul>
```
<!-- OCR_END -->

￼

## 渲染模板功能

***

| 添加路由 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^index_form/', views.index_form),
    url(r'^index2/', views.index2),
]
```

***

| 添加视图 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3)
    pwd = forms.CharField(max_length=8, min_length=3)
    # 校验邮箱格式
    email = forms.EmailField()
def index2(request):
    myform = MyForm()
    if request.method == 'GET':
        return render(request,'index2.html',locals())
```

***

| 渲染模板：方法一 |
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
    <lable>用户:{{ myform.name }}</lable>
    <lable>密码:{{ myform.pwd }}</lable>
    <lable>邮箱:{{ myform.email }}</lable>
    <input type="submit" value="提交">
</form>
</body>
</html>
```

神奇的事情发生了，我们删除了input框，结果页面上还有，并且...还在input框里添加了字段的限制规则，并且直接点提交，还能提示我，我擦嘞~~~格式错了，还能报错 ，这就很舒服

<!-- OCR_START -->
- Title
- 127.0.0.1:8000/index2/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe
- 用户：
- 密码：
- 邮箱：
- 提交
- 请填写此字段。
- Elements
- Sources
- Network
- Performance
- Memory
- Application
- Security
- Lighthouse
- <!DOCTYPEhtml>
- Styles
- Computed
- EventListeners
- "<html lang="en">
- ==$0
- <head>_</head>
- Filter
- :hov.cls+
- <body>
- element.style
- <form action method="post">
- <lable>
- html[Attributes Style]{
- -webkit-locale:"en";
- <input type="text”name="name”maxlength="8"minlength="3”required id="id_name”>
- html{
- display:block;
- <input type="text"name=”pwd"maxlength="8"minlength="3"required id="id_pwd">
- <input type="email" name="email" required id="id_email">
- badding
- 1680×41
- <input type="submit"value="提交">
- </form>
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Title
- 127.0.0.1:8000/index2/
- 应用zabbix-api
- iview
- 组件|Element
- 曾志高翔（DriverZe
- 用户：zls
- 密码：123
- 邮箱：111
- 提交
- 请在电子邮件地址中包括”@”。“111"中缺少"@"
- Elements
- Sources
- Netw
- Perfor
- Applic
- Secu
- <!DOCTYPE html>
- Styles
- Computed
- Event Liste
- <html tang="en">
- =$0
- Filter
- :hov.cls
- <body>
- <form
- action method="post">
- html[AttributesStyle]
- vebkit-locale:"en";
- <input type="text"name="name” maxlength="8" minlength="3"required id="id_name>
- </lable>
- html{
- display:block;
- “密码：“
- <input type="text"name="pwd"maxlength="8"minlength="3"required id="id_pwd">
- “邮箱：
- <input type="emailname="email"required id="id_email>
- padding
- <input type="submit”value="提交”>
- 1680×41
- ..
- 曾老湿
<!-- OCR_END -->

￼

***

| 渲染模板：方法二 |
| :--- |

第二种方式特别牛逼，直接for循环 forms对象

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <h1>渲染模板方法一：</h1>
    <form action="" method="post">
    <lable>用户:{{ myform.name }}</lable>
    <lable>密码:{{ myform.pwd }}</lable>
    <lable>邮箱:{{ myform.email }}</lable>
    <input type="submit" value="提交">
</form>
<hr>
<h1>渲染模板方法二：</h1>
{% for foo in myform %}
    {{ foo }}
{% endfor %}
<input type="submit" value="提交">
</body>
</html>
```

<!-- OCR_START -->
- Title
- →C
- 127.0.0.1:8000/index2/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element曾志高翔（DriverZe.
- 渲染模板方法一：
- 用户：
- 密码：
- 邮箱：
- 提交
- 渲染模板方法二：
- 曾老湿
<!-- OCR_END -->

￼

好像没有字...

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>渲染模板方法二：</h1>
<form action="" method="post">
    {% for foo in myform %}
        {{ foo.label }}:{{ foo }}
    {% endfor %}
    <input type="submit" value="提交">
</form>
</body>
</html>
```

<!-- OCR_START -->
- Title
- →C
- 127.0.0.1:8000/index2/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element曾志高翔（DriverZe.
- 渲染模板方法一：
- 用户：
- 密码：
- 邮箱
- 提交
- 渲染模板方法二：
- Name:
- Pwd:
- Email:
- 曾老湿
<!-- OCR_END -->

￼

想显示中文？简单

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3,label='用户')
    pwd = forms.CharField(max_length=8, min_length=3,label='密码')
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱')
def index2(request):
    myform = MyForm()
    if request.method == 'GET':
        return render(request,'index2.html',locals())
```

<!-- OCR_START -->
- Title
- ←→C
- 127.0.0.1:8000/index2/
- 9
- 应用zabbix-apiCanlIUseiview组件IElement曾志高翔（DriverZe.
- 渲染模板方法一：
- 用户：
- 密码：
- 邮箱
- 提交
- 渲染模板方法二：
- 曾老湿
<!-- OCR_END -->

￼

***

| 渲染模板：方法三 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>渲染模板方法三：</h1>
<form action="" method="post">
    {{ myform.as_ul }}
    <input type="submit" value="提交">
</form>
</body>
</html>
```

<!-- OCR_START -->
- Title
- →C
- 127.0.0.1:8000/index2/
- 应用zabbix-api
- CanlIUseiview组件IElement曾志高翔（DriverZe
- 渲染模板方法一：
- 用户：
- 密码：
- 邮箱：
- 提交
- 渲染模板方法二：
- 渲染模板方法三：
- 曾老湿
<!-- OCR_END -->

￼

第三种方法，不建议使用，没有办法加样式。

## 渲染错误信息

***

| 创建路由 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^index_form/', views.index_form),
    url(r'^index2/', views.index2),
    url(r'^index3/', views.index3),
]
```

***

| 添加视图 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3,label='用户')
    pwd = forms.CharField(max_length=8, min_length=3,label='密码')
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱')
def index3(request):
    if request.method == 'GET':
        myform = MyForm()
    elif request.method == 'POST':
        myform = MyForm(request.POST)
    return render(request, 'index3.html', locals())
```

***

| 前端代码 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>渲染错误信息</title>
</head>
<body>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>使用渲染模板的第二种方式渲染错误信息：</h1>
<form action="" method="post" novalidate>
    {% for foo in myform %}
        <div>{{ foo.label }}:{{ foo }} <span>{{ foo.errors.0 }}</span></div>
    {% endfor %}
    <input type="submit" value="提交">
</form>
</body>
</html>
```

<!-- OCR_START -->
- 渲染错误信息
- →C127.0.0.1:8000/index3/
- 9
- 应用zabbix-apiCanIUseiview
- t曾志高翔（DriverZze.
- 使用渲染模板的第二种方式渲染错误信息：
- 用户：zls
- 密码：123
- 邮箱：1
- Enteravalidemail address.
- 提交
- 曾老湿
<!-- OCR_END -->

￼

***

| 换成中文 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3, label='用户',
                           error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'})
    pwd = forms.CharField(max_length=8, min_length=3, label='密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'})
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱', required=True, error_messages={'invalid':'必须是邮箱格式啊~我的哥'})
```

<!-- OCR_START -->
- 渲染错误信息
- →C127.0.0.1:8000/index3/
- 应用zabbix-apiCanIUseiview组件IElement曾志高翔（Driverze.
- 使用染模板的第二种方式染错误信息：
- 用户：aa
- 那啥最小是3位
- 密码：1
- 邮箱：33
- 必须是邮箱格式啊~我的哥
- 提交
- 曾老湿
<!-- OCR_END -->

￼

***

| 密码密文 |
| :--- |

密码是明文的，需要修改一下样式。

使用`widgets`，可以导入，也可以直接使用`from django.forms import widgets`

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3, label='用户',
                           error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                           widget=forms.widgets.TextInput())
    pwd = forms.CharField(max_length=8, min_length=3, label='密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                          widget=forms.widgets.PasswordInput())
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱', required=True, error_messages={'invalid': '必须是邮箱格式啊~我的哥'},
                             widget=forms.widgets.EmailInput())
def index3(request):
    if request.method == 'GET':
        myform = MyForm()
    elif request.method == 'POST':
        myform = MyForm(request.POST)
    return render(request, 'index3.html', locals())
```

<!-- OCR_START -->
- 渲染错误信息
- →C127.0.0.1:8000/index3/
- 应用zabbix-apiCanIUseiview组件|Element曾志高翔（Drivere.
- 使用渲染模板的第二种方式渲染错误信息：
- 用户：zls
- 密码：
- 邮箱：123@qq.com
- 提交
- 曾老湿
<!-- OCR_END -->

￼

***

| 指定input框的样式 |
| :--- |

首先引用`bootstrap`，或者自己写css

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>渲染错误信息</title>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>
<body>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>使用渲染模板的第二种方式渲染错误信息：</h1>
<form action="" method="post" novalidate>
    {% for foo in myform %}
        <div>{{ foo.label }}:{{ foo }} <span>{{ foo.errors.0 }}</span></div>
    {% endfor %}
    <input type="submit" value="提交">
</form>
</body>
</html>
```

修改forms类

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3, label='用户',
                           error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                           widget=forms.widgets.TextInput(attrs={'class':'form-control'}))
    pwd = forms.CharField(max_length=8, min_length=3, label='密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                          widget=forms.widgets.PasswordInput(attrs={'class':'form-control','id':'basic-addon2'}))
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱', required=True, error_messages={'invalid': '必须是邮箱格式啊~我的哥'},
                             widget=forms.widgets.EmailInput(attrs={'class':'form-control','id':'basic-addon3'}))
def index3(request):
    if request.method == 'GET':
        myform = MyForm()
    elif request.method == 'POST':
        myform = MyForm(request.POST)
    return render(request, 'index3.html', locals())
```

<!-- OCR_START -->
- 渲染错误信息
- →C
- 127.0.0.1:8000/index3/
- 应用zabbix-api
- CanlUse
- iview
- 组件IEler
- 曾志高翔（DriverZe
- 使用染模板的第二种方式渲染错误信息：
- 用户：
- 密码：
- 邮箱：
- 提交
- 曾老湿
<!-- OCR_END -->

￼

## 局部钩子

***

| 需求 |
| :--- |

如下图，在注册的时候，输入用户名，匹配数据库，如果存在则返回错误信息，登录用户名已被使用

<!-- OCR_START -->
- 注册新用户
- 需要通过邮件激活账户
- 手机号码
- +86
- 激活账户需要手机短信验证
- 登录用户名
- zeng
- 登录用户名已被使用
- 显示昵称
- 不少于2个字符
- 至少8位，并包含字母、数字和特殊字符中的两种
- 确认密码
- 请输入确认密码
- 注册
- 曾老湿
- *点击“注册”按钮，即表示您同意并愿意遵守用户协议。
- Driver Zeng
<!-- OCR_END -->

￼

***

| 添加新方法 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
from django.core.exceptions import ValidationError ## 导入异常
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3, label='用户',
                           error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                           widget=forms.widgets.TextInput(attrs={'class':'form-control'}))
    pwd = forms.CharField(max_length=8, min_length=3, label='密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                          widget=forms.widgets.PasswordInput(attrs={'class':'form-control','id':'basic-addon2'}))
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱', required=True, error_messages={'invalid': '必须是邮箱格式啊~我的哥'},
                             widget=forms.widgets.EmailInput(attrs={'class':'form-control','id':'basic-addon3'}))
    def clean_name(self):
        name = self.cleaned_data.get('name')
        if name.startswith('sb'):
            # 失败，抛异常
            raise ValidationError('不能以傻逼开头')
        #  成功就返回
        return name
def index3(request):
    if request.method == 'GET':
        myform = MyForm()
    elif request.method == 'POST':
        myform = MyForm(request.POST)
    return render(request, 'index3.html', locals())
```

<!-- OCR_START -->
- 渲染错误信息
- 别离开我啊，小老弟，点回来～
- 127.0.0.1:8000/index3/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件IEle
- 曾志高翔（DriverZe
- 使用染模板的第二种方式染错误信息：
- 用户：
- sb_egon
- 不能以傻逼开头
- 密码：
- 这个必须填
- 邮箱：
- 提交
- 曾老湿
<!-- OCR_END -->

￼

## 全局钩子

***

| 需求 |
| :--- |

注册页面再来一个确认密码，保证两次密码输入的一致。

重写clean方法

***

| 添加新方法 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
from django.core.exceptions import ValidationError ## 导入异常
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3, label='用户',
                           error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                           widget=forms.widgets.TextInput(attrs={'class':'form-control'}))
    pwd = forms.CharField(max_length=8, min_length=3, label='密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                          widget=forms.widgets.PasswordInput(attrs={'class':'form-control','id':'basic-addon2'}))
    re_pwd = forms.CharField(max_length=8, min_length=3, label='确认密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                          widget=forms.widgets.PasswordInput(attrs={'class': 'form-control', 'id': 'basic-addon2'}))
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱', required=True, error_messages={'invalid': '必须是邮箱格式啊~我的哥'},
                             widget=forms.widgets.EmailInput(attrs={'class':'form-control','id':'basic-addon3'}))
    def clean_name(self):
        name = self.cleaned_data.get('name')
        if name.startswith('sb'):
            # 失败，抛异常
            raise ValidationError('不能以傻逼开头')
        #  成功就返回
        return name
    def clean(self):
        pwd = self.cleaned_data.get('pwd')
        re_pwd = self.cleaned_data.get('re_pwd')
        if pwd != re_pwd:
            raise ValidationError('两次密码不一致')
def index3(request):
    if request.method == 'GET':
        myform = MyForm()
    elif request.method == 'POST':
        myform = MyForm(request.POST)
        if myform.is_valid():
            print(myform.cleaned_data)
        else:
            print(myform.errors.as_data)
    return render(request, 'index3.html', locals())
```

<!-- OCR_START -->
- 渲染错误信息
- 别离开我啊，小老弟，点回来～
- →C
- 127.0.0.1:8000/index3/
- 应用zabbix-apiCanlIUseiview组件|Element曾志高翔（DriverZe.
- 使用染模板的第二种方式染错误信息：
- 用户：
- zs
- 密码：
- ***
- 确认密码：
- 邮箱：
- 123@qq.com
- 提交
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
formsssss[~/PycharmProjects/forms
ews.pyLformsssss
formsssss
app01）views.py
djf
Project
settings.py
urls.pyx
index_form.html
views.py
index3.html
index2.html
formsssss ~/PycharmProjects/formsssss
from
django.shortcuts import render,
app01
migrations
django.core.exceptions import ValidationError#导入异赏
_init_.py
#Create your views here.
admin.py
apps.py
#forms组件数据校验功能
models.py
#0.导入模块
tests.py
django
import forms
1011121314
#1.是个类，先要继承Form
class MyForm(forms.Form):
#2.定义一个属性可以校验字符串类型
urls.py
1516 1718 19
#限制字符串，最大长度是8最小长度是3
name=forms.CharField（max_Length=8,min_Length=3,label='用户，
wsgi.py
那啥最小是3位’，‘required’：‘这个必须填'}，
templates
et=forms.widgets.TextInput(attrs=f'class':'form-control'}))
pwd=forms.CharField（max_Length=8,
2 2 2 23 24 15 16 27
abel=密码
error
老弟啊，最大是8位’，‘min_Length’：‘那啥最小是3位’，‘required’：‘这个必须填’}，
db.sqlite3
re_pwd=forms.CharField(max_Length=8,
min_length=3,
manage.py
老弟啊，最大是8位，
‘min_Length'：那啥最小是3位’，required’：这个必须填’}，
lllExternal Libraries
#校验邮箱格式
Scratches and Consoles
email=forms.EmailField（label='邮箱'，requ
error_messages={'invalid'：必须是邮箱格式网~我的哥'}，
widget=forms.widgets.EmailInput（attrs=f'class':'form-control','id':'basic-addon3'}))
28 2
def clean_name(self):
Run:
diformssss
Starting development server at http://127.0.0.1:8000
Quit the serv
verwith CONTROL-C
[19/Jun/202013:03:50]*GET/index3/HTTP/1.12001292
[19/Jun/202013:04:07]“POST/index3/HTTP/1.12001323
Performing system checks...
System check identified no issues (0 silenced).
You have 13 unapplied migration（s）.Your project may not work properly until you apply themigrations for app（s）:admin, auth, contenttypes, sessions.
Django version 1.11.18, using settings 'formssss.settings'
Quit the server with CONTROL-C.
<bound method ErrorDict.as_data of_al_：[两次密码不一致]}
9/5um/2020-19.06-181
曾老湿
<!-- OCR_END -->

￼

实现在页面显示

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>渲染错误信息</title>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>
<body>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>使用渲染模板的第二种方式渲染错误信息：</h1>
<form action="" method="post" novalidate>
    {% for foo in myform %}
        <div>{{ foo.label }}:{{ foo }} <span>{{ foo.errors.0 }}</span></div>
    {% endfor %}
    <input type="submit" value="提交"> <span>{{ all_error }}</span>
</form>
</body>
</html>
```

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
from django.core.exceptions import ValidationError ## 导入异常
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3, label='用户',
                           error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                           widget=forms.widgets.TextInput(attrs={'class':'form-control'}))
    pwd = forms.CharField(max_length=8, min_length=3, label='密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                          widget=forms.widgets.PasswordInput(attrs={'class':'form-control','id':'basic-addon2'}))
    re_pwd = forms.CharField(max_length=8, min_length=3, label='确认密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                          widget=forms.widgets.PasswordInput(attrs={'class': 'form-control', 'id': 'basic-addon2'}))
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱', required=True, error_messages={'invalid': '必须是邮箱格式啊~我的哥'},
                             widget=forms.widgets.EmailInput(attrs={'class':'form-control','id':'basic-addon3'}))
    def clean_name(self):
        name = self.cleaned_data.get('name')
        if name.startswith('sb'):
            # 失败，抛异常
            raise ValidationError('不能以傻逼开头')
        #  成功就返回
        return name
    def clean(self):
        pwd = self.cleaned_data.get('pwd')
        re_pwd = self.cleaned_data.get('re_pwd')
        if pwd != re_pwd:
            raise ValidationError('两次密码不一致')
def index3(request):
    if request.method == 'GET':
        myform = MyForm()
    elif request.method == 'POST':
        myform = MyForm(request.POST)
        if myform.is_valid():
            print(myform.cleaned_data)
        else:
            all_error = myform.errors.get('__all__')[0]
            print(myform.errors.as_data)
    return render(request, 'index3.html', locals())
```

<!-- OCR_START -->
- 渲染错误信息
- 别离开我啊，小老弟，点回来~
- →C
- 127.0.0.1:8000/index3/
- 应用zabbix-apiCanIUseiview组件|Element曾志高翔（DriverZe.
- 使用染模板的第二种方式染错误信息：
- 用户：
- zls
- 确认密码：
- ...
- 邮箱：
- 123@qq.com
- 提交两次密码不一致
- 曾老湿
<!-- OCR_END -->

￼

## 实现注册功能

***

| 模型层 |
| :--- |

**创建表**

models.py

```plain
from django.db import models
# Create your models here.
class User(models.Model):
    name = models.CharField(max_length=32)
    pwd = models.CharField(max_length=32)
    email = models.EmailField()
```

**数据库迁移**

```plain
MacBook-pro:formsssss driverzeng$ python3 manage.py makemigrations app01
MacBook-pro:formsssss driverzeng$ python3 manage.py migrate
```

<!-- OCR_START -->
- Database
- dbschemasmainapp01_user
- G#CCEI
- Project
- ttings.py
- urls.py
- index_form.html
- views.pyx
- models.py
- main.app01_user[db]x
- 3Database
- formsssss ~/PycharmProjects/formsssss
- Orows
- 5+
- Tx:Auto
- Tab-se.d（TSV)
- DDLViewQuery
- GI
- app01
- <Filter criteria>
- 8db1
- migrations
- _init_.py
- idname
- pwd
- email
- schemas1
- admin.py
- main
- app01_user
- apps.py
- auth_group
- auth_group_permissions
- tests.py
- views.py
- auth_permission
- auth_user
- auth_user_groups
- settings.py
- django_admin_log
- wsgi.py
- django_content_type
- templates
- django_migrations
- index2.html
- django_session
- index3.html
- sqlite_master
- sqlite_sequence
- 曾老湿
- ndex_form.html
- sqlite3
- collations3
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
    url(r'^index_form/', views.index_form),
    url(r'^index2/', views.index2),
    url(r'^index3/', views.index3),
]
```

***

| 视图层 |
| :--- |

注册成功就往数据库插入数据

views.py

```plain
from django.shortcuts import render, HttpResponse, redirect
from django.http import JsonResponse
from django.core.exceptions import ValidationError  ## 导入异常
from app01 import models
# Create your views here.
## forms组件数据校验功能
# 0.导入模块
from django import forms
# 1.是个类，先要继承Form
class MyForm(forms.Form):
    # 2.定义一个属性可以校验字符串类型
    # 限制字符串，最大长度是8最小长度是3
    name = forms.CharField(max_length=8, min_length=3, label='用户',
                           error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                           widget=forms.widgets.TextInput(attrs={'class': 'form-control'}))
    pwd = forms.CharField(max_length=8, min_length=3, label='密码',
                          error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                          widget=forms.widgets.PasswordInput(attrs={'class': 'form-control', 'id': 'basic-addon2'}))
    re_pwd = forms.CharField(max_length=8, min_length=3, label='确认密码',
                             error_messages={'max_length': '老弟啊，最大是8位', 'min_length': '那啥最小是3位', 'required': '这个必须填'},
                             widget=forms.widgets.PasswordInput(attrs={'class': 'form-control', 'id': 'basic-addon2'}))
    # 校验邮箱格式
    email = forms.EmailField(label='邮箱', required=True, error_messages={'invalid': '必须是邮箱格式啊~我的哥'},
                             widget=forms.widgets.EmailInput(attrs={'class': 'form-control', 'id': 'basic-addon3'}))
    def clean_name(self):
        name = self.cleaned_data.get('name')
        if name.startswith('sb'):
            # 失败，抛异常
            raise ValidationError('不能以傻逼开头')
        #  成功就返回
        return name
    def clean(self):
        pwd = self.cleaned_data.get('pwd')
        re_pwd = self.cleaned_data.get('re_pwd')
        if pwd != re_pwd:
            raise ValidationError('两次密码不一致')
def index3(request):
    if request.method == 'GET':
        myform = MyForm()
    elif request.method == 'POST':
        myform = MyForm(request.POST)
        if myform.is_valid():
            # myform.cleaned_data是一个字典，但是会传过来re_pwd的字段，我们来把它删掉然后再传入
            myform.cleaned_data.pop('re_pwd')
            # models.User.objects.create(name='zls',pwd='123') 正常需要这么传入，我们可以直接传入字典
            models.User.objects.create(**myform.cleaned_data)
            ## 创建成功之后，跳转到登录页面，就不能return index3.html了,因为没有写登录页面，所以临时注册成功就跳转我博客http://blog.driverzeng.com
            return redirect('http://blog.driverzeng.com')
        else:
            ## 如果注册成功，all_error没有值，网页就会报错，所以我们给 all_error添加一个判断
            all_error = myform.errors.get('__all__')
            if all_error:
                all_error = all_error[0]
    return render(request, 'index3.html', locals())
```

***

| 前端 |
| :--- |

index3.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>渲染错误信息</title>
    <!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>
<body>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>使用渲染模板的第二种方式渲染错误信息：</h1>
<form action="" method="post" novalidate>
    {% for foo in myform %}
        <div>{{ foo.label }}:{{ foo }} <span>{{ foo.errors.0 }}</span></div>
    {% endfor %}
    <input type="submit" value="提交"> <span>{{ all_error }}</span>
</form>
</body>
</html>
```

<!-- OCR_START -->
- 渲染错误信息
- 别离开我啊，小老弟，点回来~
- 1
- →C
- 127.0.0.1:8000/index3/
- 应用zabbix-api
- CanlUse
- iview
- 组件IElement曾志高翔（DriverZe
- 使用渲染模板的第二种方式渲染错误信息：
- 用户：
- zls
- 密码：
- 确认密码：
- 邮箱：
- 123@qq.com
- 提交
- 曾老湿
<!-- OCR_END -->

￼

注册成功

<!-- OCR_START -->
- 曾志高翔（DriverZeng)的博客-×
- 别离开我啊，小老弟，点回来～
- →Cblog.driverzeng.com
- 应用zabbix-apiCanlUseiview
- 组件|Element
- 曾志高翔（DriverZe
- 个人中心后台退出
- 首页
- 曾老湿撩妹宝典（PUA）
- Linux基础篇
- Linux架构篇
- DATABASE
- DevOps
- Web
- 监控系统
- 云计算
- 前端开发
- 后端开发
- 文件存储
- 下载工具地址
- 面试技巧
- 这周日你有空吗？
- 友链
- 曾老湿带你了解运维需求-实现自动化运维平台57
- 24
- 自动化运维平台功能大纲核心功能1-Dashboard及展示核心功能2-资产管理及展示
- 曾老湿
- 核心功能3-SQL...
- 曾老湿2019/12/0420900
- 曾老湿教你如何架设游戏服务器（天龙八部手游）
- 30
- 8.11kvisi
- 环境准备服务部署-曾老湿，江湖人称曾老大。-笔者QQ：133411023、
- REVOLVERMAPS
- 253097001-笔.
- 曾老湿2019/12/011628Q1
<!-- OCR_END -->

￼

跳转页面

<!-- OCR_START -->
- Databasedb schemasmain田appo1_user
- G#C@
- Project
- settings.py
- urls.pyx
- index_form.html
- views.pyx
- models.py
- main.app01_user[db]三2
- Database
- formsssss ~/PycharmProjects/formsssss
- 1row
- 5+
- Tx:Auto
- Tab-se...d(TSV)
- app01
- 8-db1
- migrations
- idname
- pwd
- email
- _init_.py
- schemas1
- 1zls
- 666666
- 123@qq.com
- admin.py
- main
- app01_user
- apps.py
- tests.py
- name varchar（32)
- pwdvarchar(32)
- views.py
- email varchar（254）
- <unnamed>(id)
- auth_group
- auth_group_permissions
- urls.py
- wsgi.py
- auth_permission
- auth_user
- olates
- ndex2.html
- auth_user_groups
- 曾老湿
- auth_user_user_permissions
<!-- OCR_END -->

￼

数据库中有数据

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:38:25  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/deku9r>