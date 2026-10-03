# Python进阶30-Django AJAX

## Python进阶30-Django AJAX
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(2) 评论(0)

+ [什么是AJAX？](https://blog.driverzeng.com/zenglaoshi/5764.html#toc_0)
+ [创建项目](https://blog.driverzeng.com/zenglaoshi/5764.html#toc_1)
+ [AJAX上传文件](https://blog.driverzeng.com/zenglaoshi/5764.html#toc_2)
+ [AJAX 提交 Json数据](https://blog.driverzeng.com/zenglaoshi/5764.html#toc_3)
+ [serializers](https://blog.driverzeng.com/zenglaoshi/5764.html#toc_4)

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

## 什么是AJAX？
AJAX（Asynchronous Javascript And XML）翻译成中文就是“异步Javascript和XML”。即使用Javascript语言与服务器进行异步交互，传输的数据为XML（当然，传输的数据不只是XML,现在更多使用json数据）。

1、同步交互：客户端发出一个请求后，需要等待服务器响应结束后，才能发出第二个请求；

2、异步交互：客户端发出一个请求后，无需等待服务器响应结束，就可以发出第二个请求。

---

| 具体请看链接 |
| :--- |

[https://blog.driverzeng.com/zenglaoshi/4507.html](https://blog.driverzeng.com/zenglaoshi/4507.html)

## 创建项目
---

| 基本操作 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def index(request):
    if request.method == 'GET':
        print(request.body)
        print(request.GET)
        print(request.POST)
        return render(request,'index.html')
    else:
        print(request.body)
        print(request.GET)
        print(request.POST)
        return HttpResponse('ok')
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.index),
]
```

---

| 前端写测试页面 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AJAX</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<button class="btn">点我朝后台发数据</button>
<script>
    {# 取按钮 #}
    $('.btn').click(function () {
        alert('点我干啥？')
    })
</script>
</body>
</html>
```

<!-- OCR_START -->
- AJAX
- 127.0.0.1:8000
- 应用zabbix-api
- CanlUseiview组件IElement曾志高翔（DriverZe.
- 点我朝后台发数据
- Elements
- SourcesNetwork
- Performance
- Memory
- Application
- SecurityLighthouse
- 园to
- Fiter
- Default levels
- 1hiden
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- AJAX
- 127.0.0.1:8000
- 8
- 应用zabbix-apiCanlUseiview
- 组件|Element曾志高翔（DriverZe
- 127.0.0.1:8000显示
- 点我朝后台发数据
- 点我干啥？
- 确定
- top
- Filter
- Default levels
- 曾老湿
<!-- OCR_END -->

￼

---

| Jquery AJAX发送get请求 |
| :--- |

使用get发请求到后台

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AJAX</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<button class="btn">点我朝后台发数据</button>
<script>
    {# 取按钮 #}
    $('.btn').click(function () {
        {#alert('点我干啥？')#}
        $.ajax({
            {#向后台发送请求的地址#}
            url:'/?name=zls',
            {# 以什么方式发请求 #}
            type:'get'
        })
    })
</script>
</body>
</html>
```

<!-- OCR_START -->
- untitled2
- templatesindex.html
- Project
- settings.py
- urls.pyx
- views.py
- index.html
- ~/PycharmProjects/untitled2
- <!DOCTYPE html>
- app01
- <html lang="en">
- <head>
- migrations
- <title>AJAx</title>
- admin.py
- <script src=https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
- apps.py
- models.py
- <body>
- <buttonclass="btn">点我朝后台发数据</button>
- tests.py
- <script>
- [#取按钮#}
- static
- $（btn'）.click（function（）{
- templates
- [#alert（‘点我干啥？‘）#}
- 14
- $.ajax（f
- [#向后台发送请求的地址#}
- 161
- url:'
- 18 19
- type:'get
- urls.py
- wsgi.py
- db.sqlite3
- manage.py
- </html>
- l xternal Libraries
- Scratchesand Consoles
- Run:
- djuntitled2
- [16/Jun/2020 12:04:59]"GET/?name=zls HTTP/1.1"200 445
- QueryDict:{’name':['zls']>
- 曾老湿
- ueryDict:{}>
<!-- OCR_END -->

￼

---

| Jquery AJAX发送post请求 |
| :--- |

```plain
from django.shortcuts import render,HttpResponse,redirect
import time
# Create your views here.
def index(request):
    if request.method == 'GET':
        print(request.body)
        print(request.GET)
        print(request.POST)
        return render(request,'index.html')
    else:
        time.sleep(5)
        print(request.body)
        print(request.GET)
        print(request.POST)
        return HttpResponse('ok')
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AJAX</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<button class="btn">点我朝后台发数据</button>
<script>
    {# 取按钮 #}
    $('.btn').click(function () {
        $.ajax({
            url: '/',
            type: 'post',
            {#  data是网后台提交的数据  #}
            data:{'name':'zls','age':18},
            {# 成功的时候回调函数 #}
            success:function (data) {
                alert(data)
            }
        })
    })
</script>
</body>
</html>
```

<!-- OCR_START -->
- AJAX
- 别离开我啊，小老弟，点回来～
- ×+
- ↑→Q
- 127.0.0.1:8000
- 9
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe.
- 127.0.0.1:8000显示
- 点我朝后台发数据
- ok
- 确定
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- untitled2
- templates
- index.html
- #C
- Project
- settings.py
- urls.py
- views.py
- ~/PycharmProjects/untitled2
- <!DOCTYPE html>
- app01
- <html lang="en">
- migrations
- <meta charset="UTF-8">
- _init_.py
- <title>AJAX</title>
- admin.py
- <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
- apps.py
- <head>
- models.py
- <body>
- tests.py
- <buttonclass="btn">点我朝后台发数据</button>
- <script>
- 11
- [#取按钮#}
- static
- 12
- $（.btn'）.click（function（）{
- 3
- $.ajax（t
- url:/,
- 16
- success:function(data)
- wsgi.py
- alert(data)
- db.sqlite3
- manage.py
- External Libraries
- Scratches and Consoles
- html
- callback for click()
- Run:
- djuntitled2
- b'name=zls8age=18
- QueryDict:{>
- 曾老湿
- eryDict:{'name':['zls'],'age':['18']}>
- 16/Jun/202012:19:07]
- HTTP/1.1200
<!-- OCR_END -->

￼

---

| 写一个add功能 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
import time
# Create your views here.
def index(request):
    if request.method == 'GET':
        print(request.body)
        print(request.GET)
        print(request.POST)
        return render(request, 'index.html')
    else:
        time.sleep(5)
        print(request.body)
        print(request.GET)
        print(request.POST)
        return HttpResponse('ok')
def add(request):
    if request.method == 'GET':
        return render(request, 'add.html')
    else:
        add1 = request.POST.get('add1')
        add2 = request.POST.get('add2')
        sum = int(add1) + int(add2)
        return HttpResponse(str(sum))
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.index),
    url(r'^add/$', views.add),
]
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>求和</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
    <p>
        <input type="text" name="add1" id="add1"> + <input type="text" name="add2" id="add2"> = <input type="text" name="sum" id="sum">
    </p>
    <button class="btn">点我求和</button>
    <script>
        $('.btn').click(function () {
                $.ajax({
                url: '/add/',
                type: 'post',
                data: {'add1':$('#add1').val(),'add2':$('#add2').val()},
                success:function (data) {
                    $("#sum").val(data)
                }
            })
        })
    </script>
</body>
</html>
```

<!-- OCR_START -->
- AJAX
- 别离开我啊，小老弟，点回来~
- 求和
- ←→C
- 127.0.0.1:8000/add/
- 应用zabbix-apiCanlUseiview组件|Element曾志高翔（Driverze
- 9
- +7
- 16
- 点我求和
- 曾老湿
<!-- OCR_END -->

￼

## AJAX上传文件
```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>文件上传</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<form action="/sftp/" method="post" enctype="multipart/form-data">
    <p>用户名：<input type="text" name="name" id="name"></p>
    <p><input type="file" name="myfile" id="myfile"></p>
    <input type="submit" value="FORM表单提交">
</form>
<button id="btn">AJAX提交文件</button>
<script>
    $('#btn').click(function () {
        {# 上传文件 必须用formdata #}
        var formdata=new FormData()
        formdata.append('name',$('#name').val())
        {# 取出文件 #}
        formdata.append('myfile',$('#myfile')[0].files[0])
        $.ajax({
            url: '/sftp/',
            type: 'post',
            // 不预处理数据，如果不设置false，数据类似于(name=zls&age=18)
            processData:false,
            // contentType指定往后台传数据的编码格式 （urlencoded，formdata，json）
            // false：使用formdata对象处理了数据，就不需要指定编码了。
            contentType:false,
            data: formdata,
            success:function (data) {
                alert(data)
            }
        })
    })
</script>
</body>
</html>
```

```plain
from django.shortcuts import render, HttpResponse, redirect
import time
# Create your views here.
def sftp(request):
    if request.method == 'GET':
        return render(request,'sftp.html')
    name = request.POST.get('name')
    print(name)
    dic_files=request.FILES
    myfile = dic_files.get('myfile')
    with open(myfile.name,'wb') as f:
        #  循环上传过来的文件
        for line in myfile:
            # 往空文件中写
            f.write(line)
    return HttpResponse('OK')
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.index),
    url(r'^add/$', views.add),
    url(r'^sftp/$', views.sftp),
]
```

<!-- OCR_START -->
- AJAX
- 别离开我啊，小老弟，点回来～
- 求和
- 文件上传
- →C
- 127.0.0.1:8000/sftp/
- 应用zabbix-api
- CanlUseiview
- 组件|Element曾志高翔（DriverZe..
- 127.0.0.1:8000显示
- 用户名：zls
- 选择文件dibu.png
- 确定
- FORM表单提交
- AJAX提交文件
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿

```text
tled2~/Pycha
untitled2
djuntitled2
G#CCEI
Project
settings.py
urls.py
sftp.html
views.py
index.html
add.html
untitled2~/PycharmProjects/untitled2
print(request.GE1)
17
print(request.POST)
app01
18
return HttpResponse('ok')
admin.py
21
def
add(request):
apps.py
if request.method= 'GET':
models.py
return render(request,‘add.html') tests.py else: add1=request.POST.get('add1')
views.py
26
add2=request.POST.get（
static
27
sum =int（add1)+int（add2)
templates
return HttpResponse(str(sum))
add.html
29
def sftp（request）:
add_files.html
ifrequest.method='GET':
index.html
returnrender(request,'sftp.html')
sftp.html
name=request.POST.get（'name')
untitled2
print(name)
dic_files=request.FILES
_init_.py
36
myfile = dic_files.get（‘myfile'）
settings.py
with open（myfile.name, wb')asf:
urls.py
#循环上传过来的文件
wsgi.py
for line in myfile:
dh.salite3
#往空文件中写
dibu.png
f.write(line)
return HttpResponse('oK')
manage.py
l External Libraries
Run:
djuntitled2x
[16/Jun/2020 13:39:51]“P0ST/sftp/HTTP/1.12002
```
<!-- OCR_END -->

￼

## AJAX 提交 Json数据
---

| application/json |
| :--- |

application/json 这个 Content-Type 作为响应头大家肯定不陌生。实际上，现在越来越多的人把它作为请求头，用来告诉服务端消息主体是序列化后的 JSON 字符串。由于 JSON 规范的流行，除了低版本 IE 之外的各大浏览器都原生支持 JSON.stringify，服务端语言也都有处理 JSON 的函数，使用 JSON 不会遇上什么麻烦。

JSON 格式支持比键值对复杂得多的结构化数据，这一点也很有用。记得我几年前做一个项目时，需要提交的数据层次非常深，我就是把数据 JSON 序列化之后来提交的。不过当时我是把 JSON 字符串作为 val，仍然放在键值对里，以 x-www-form-urlencoded 方式提交。

---

| 写页面提交Json数据 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>提交JSON数据给后台</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<form enctype="multipart/form-data">
    <p>用户名：<input type="text" name="name" id="name"></p>
    <p>密码：<input type="password" name="pwd" id="pwd"></p>
</form>
<button id="btn">AJAX提交Json</button>
<script>
    $('#btn').click(function () {
        var post_data={'name':$('#name').val(),'pwd':$('#pwd').val()}
        // 字典转成Json字符串使用JSON.stringify 相当于 python中json.dumps
        var post_data = JSON.stringify(post_data)
        $.ajax({
            url: '/add_json/',
            type: 'post',
            contentType: 'application/json',
            data: post_data,
            success:function (data) {
                // 如果data是Json字符串，使用JSON.parse转成字典
                // console.log(typeof data)
                // var res = JSON.parse(data)
                alert(data)
            }
        })
    })
</script>
</body>
</html>
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.index),
    url(r'^add/$', views.add),
    url(r'^sftp/$', views.sftp),
    url(r'^add_json/$', views.add_json),
]
```

```plain
from django.shortcuts import render, HttpResponse, redirect
import time
from django.http import JsonResponse
# Create your views here.
def add_json(request):
    if request.method == 'GET':
        return render(request, 'json.html')
    else:
        import json
        res = json.loads(request.body.decode('utf-8'))
        name = res['name']
        pwd = res['pwd']
        ## 返回json格式给前端
        dic = {'user': name, 'password': pwd}
        print(dic)
        return HttpResponse(json.dumps(dic))
        # return JsonResponse(dic)
```

**注意，有两种方法，前端可以不用转格式**

1.使用JsonResponse，返回的直接是一个对象，前端不用再转类型了可以直接使用。

2.在前端加上dataType:'json'，返回的内容也是一个对象，前端也可以直接使用。

<!-- OCR_START -->
- AJAX
- ×别离开我啊，小老弟，点回来～
- 求和
- X|文件上传
- 提交JSON数据给后台
- 127.0.0.1:8000/add_json/
- 8
- 应用zabbix-api
- CanIUseiview组件|Element曾志高翔（Drivere.
- 127.0.0.1:8000显示
- 用户名：zls
- “"user":"zls","password":"111")
- 密码：
- 确定
- AJAX提交Json
- Elem
- Co
- Perf
- Appli
- Security
- top
- Filter
- Default levels
- 1hidden
- 曾老湿
<!-- OCR_END -->

￼

## serializers
Django内置的serializers（把对象序列化成json字符串）

```plain
from django.core import serializers
def test(request):
    book_list = Book.objects.all()    
    ret = serializers.serialize("json", book_list)
    return HttpResponse(ret)
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

QQ：133411023

> 更新: 2020-06-25 11:36:44  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/thl545>