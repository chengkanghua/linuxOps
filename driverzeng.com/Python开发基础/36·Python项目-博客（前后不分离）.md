# 36·Python项目-博客(前后不分离)

## 36·Python项目-博客(前后不分离)

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(3) 评论(0)

* [需求分析](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_0)
* [数据库设计](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_1)
* [创建项目](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_2)
* [前端登录页面](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_3)
* [实现验证码功能](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_4)
* [登录功能](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_5)
* [注册功能](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_6)
* [提交注册信息](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_7)
* [渲染错误信息](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_8)
* [首页设计](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_9)
* [评论点赞处理](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_10)
* [显示头像](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_11)
* [个人站点](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_12)
* [随笔档案](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_13)
* [个人站点分类过滤文章](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_14)
* [个人站点标签过滤文章(三合一)](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_15)
* [修改点击跳转](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_16)
* [文章详情页](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_17)
* [文章点赞功能](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_18)
* [后台管理功能](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_19)
  * [查询所有文章](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_20)
  * [添加文章](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_21)
  * [富文本编辑器](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_22)
  * [文章描述截取文字](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_23)
  * [处理XSS攻击](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_24)
* [Django发送邮件](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_25)
  * [修改头像](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_26)
  * [文章编辑](https://blog.driverzeng.com/zenglaoshi/5959.html#toc_27)

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

## 需求分析

***

| 需求 |
| :--- |

```plain
-首页(显示文章)
-文章详情
-点赞,点踩
-文章评论
    -字评论
    -评论的展示
-登录功能(图片验证码)
-注册功能(基于form验证,ajax)
-个人站点(不同人不同样式,文章过滤)
-后台管理:
    -文章展示
-新增文章
    -富文本编辑器
```

## 数据库设计

```plain
User
            -nid
            -name
            -password
            -email
            -phone
            -avatar   用户头像
            -create_date    用户注册时间
            -blog
        Blog
            -nid
            -title
            -site_name
            -theme
        category:
            -nid
            -title
            -blog   跟blog一对多
            
        tag:(文章关键字)
            -nid
            -title
            -blog    跟blog一对多
            
        article
            -nid
            -title
            -desc    摘要
            -create_time    auto_add_now:当该条记录创建时,自动添加当前时间
            -content   文章内容
            
            -category    一对多
            -tag         多对多
            -blog        一对多
            
        commit
            -nid
            -user     哪个用户
            -article  对哪篇文章
            -content   评论了什么内容
            -commit_time  时间
            
            -parent_id
            如何实现根评论与子评论?
                -有同学分析,要再建一张表,跟commit是一对多的关系(不好)
                
                -如何用这一个表,表示出根评论和子评论?
                    -再加一个字段,标志,给那条评论,评论的
nid user    article   content    parent_id
        
    1    1        1         111         null
    2   2        1         222         null
    3   3          1         333          1
    4   4           1         444          3
    5   3        1         反弹          4
        UpandDown
            -nid
            -user     哪个用户
            -article  对哪篇文章
            -is_up   点赞还是点踩
```

## 创建项目

<!-- OCR_START -->
- New Project
- Pure Python
- Location:
- /Users/driverzeng/PycharmProjects/bbs
- dj Django
- Flask
- Project Interpreter:Python 3.6
- Google App Engine
- ：Pyramid
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
- blogl
- Foundation
- Enable Django admin
- 5
- HTML5 Boilerplate
- ReactApp
- React Native
- 曾老湿
- Driver Zeng
- Cancel
- Create
<!-- OCR_END -->

￼

1.数据库操作

```plain
# 创建数据库
mysql> create database bbs;
# 创建用户
mysql> grant all on *.* to root@'%' identified by '123';
```

2.Django配置使用MySQL

```plain
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'bbs',
        'HOST': '10.0.0.51',
        'PORT': 3306,
        'USER': 'root',
        'PASSWORD': '123',
    }
}
```

3.bbs的__init__中导入pymysql

```plain
import pymysql
pymysql.install_as_MySQLdb()
```

4.配置静态文件路径

```plain
STATIC_URL = '/static/'
STATICFILES_DIRS = [
    os.path.join(BASE_DIR,'static')
]
```

5.创建静态文件目录

6.创建表

```plain
from django.db import models
from django.contrib.auth.models import AbstractUser
# Create your models here.
## UserInfo这个表 要继承AbstractUser，因为要用auth组件
class UserInfo(AbstractUser):
    nid = models.AutoField(primary_key=True)
    phone = models.CharField(max_length=32, null=True)
    ## 这个需要传一个路径
    avatar = models.FileField(upload_to='avatar/', default='/static/img/default.png')
    blog = models.OneToOneField(to='Blog', to_field='nid',null=True)
class Blog(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    sit_name = models.CharField(max_length=32)
    theme = models.CharField(max_length=64)
class Category(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    blog = models.ForeignKey(to='Blog', to_field='nid', null=True)
class Tag(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    blog = models.ForeignKey(to='Blog', to_field='nid', null=True)
class Article(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    desc = models.CharField(max_length=255)
    content = models.TextField()
    create_time = models.DateTimeField(auto_now_add=True)
    blog = models.ForeignKey(to='Blog', to_field='nid', null=True)
    category = models.ForeignKey(to='Category', to_field='nid', null=True)
    tag = models.ManyToManyField(to='Tag', through='ArticleToTag', through_fields=('article', 'tag'))
## 手动创建第三张表
class ArticleToTag(models.Model):
    nid = models.AutoField(primary_key=True)
    article = models.ForeignKey(to='Article', to_field='nid')
    tag = models.ForeignKey(to='Tag', to_field='nid')
class Commit(models.Model):
    nid = models.AutoField(primary_key=True)
    user = models.ForeignKey(to='UserInfo', to_field='nid')
    article = models.ForeignKey(to='Article', to_field='nid')
    content = models.CharField(max_length=255)
    create_time = models.DateTimeField(auto_now_add=True)
    ## 自己关联自己：方法一
    parent_id = models.ForeignKey(to='self', to_field='nid')
    ## 自己关联自己：方法二
    # parent_id = models.ForeignKey(to='Commit',to_field='nid')
class UpAndDown(models.Model):
    nid = models.AutoField(primary_key=True)
    user = models.ForeignKey(to='UserInfo', to_field='nid')
    article = models.ForeignKey(to='Article', to_field='nid')
    is_up = models.BooleanField()
    ## user和 article不允许一个作者，给一个文章点多个赞,做联合唯一。
    class Meta:
        ## 做这个只是为了不写脏数据，但是效率低，工作中不写也OK
        unique_together = (('user', 'article'),)
```

7.修改配置setting.py

```plain
AUTH_USER_MODEL = 'blog.UserInfo'
```

8.数据库迁移

```plain
MacBook-pro:bbs driverzeng$ python3 manage.py makemigrations
MacBook-pro:bbs driverzeng$ python3 manage.py migrate
```

## 前端登录页面

***

| 引入bootstrap |
| :--- |

```plain
<!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
```

***

| 引入jquery |
| :--- |

```plain
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
```

***

| 登录页面 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <form>
                <div class="form-group">
                    <label for="">用户名</label>
                    <input type="text" id="name">
                </div>
                <div class="form-group">
                    <label for="">密码</label>
                    <input type="password" id="pwd">
                </div>
                <div class="form-group">
                    <label for="">验证码</label>
                    <input type="password" id="valid_code">
                </div>
                <input type="button" value="登录" class="btn btn-primary">
            </form>
        </div>
    </div>
</div>
</body>
</html>
```

**路由层**

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
]
```

**视图层**

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    else:
        return HttpResponse('OK')
```

<!-- OCR_START -->
- 登录页面
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanlUseiview组件IElement
- 用户名
- 密码
- 验证码
- 登录
- 曾老湿
<!-- OCR_END -->

￼

***

| 修改样式 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form>
                <div class="form-group">
                    <label for="name">用户名</label>
                    <input type="text" id="name" class="form-control">
                </div>
                <div class="form-group">
                    <label for="pwd">密码</label>
                    <input type="password" id="pwd" class="form-control">
                </div>
                <div class="form-group">
                    <label for="valid_code">验证码</label>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="text" id="valid_code" class="form-control">
                        </div>
                        <img width="350" height="45"
                             src="https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2142985517,724352710&fm=26&gp=0.jpg"
                             alt="">
                    </div>
                </div>
                <input type="button" value="登录" class="btn btn-primary pull-right">
            </form>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 登录页面
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanlUseiview
- 组件IEle
- 登录
- 用户名
- 密码
- 验证码
- 2
- 9
- 曾老湿
<!-- OCR_END -->

￼

## 实现验证码功能

***

| 添加验证码图片的方法 |
| :--- |

**方法一：**

1.添加验证码图片的路由

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
]
```

2.添加该路由的视图

```plain
def get_valid_code(request):
    with open('static/img/1.jpg','rb') as f:
        data = f.read()
    return HttpResponse(data)
```

<!-- OCR_START -->
- 登录页面
- 登录
- 用户名
- 密码
- 验证码
- 登录
- 全业
- 曾老湿

```http
→C
127.0.0.1:8000/login/ 应用zabbix-api
CanlUseiview
组件|Element
9
ElementsConsoleSources
Network
Performance
Memory
Application
Security
Lighthouse
QPreserve logDisable cacheOnline
10ms
20ms
30ms
40ms
50ms
60ms
70ms
80ms
90ms
100ms
110ms
120ms
130ms
140ms
150ms
160ms
170ms
180ms
190ms
200ms
210mg
Name
Preview
ResponseInitiatorTimingCookies
login/ General
RequestURL:http://127.0.0.1:8000/get_valid_code/ jquery.min.js
Request Method:GET
get_valid_code/ Status Code:200OK
Remote Address:127.0.0.1:8000
Referrer Policy:no-referrer-when-downgrade
Response Headers
viewsource
Content-Length:5852
Content-Type:text/html;charset=utf-8
Date:Sun,21Jun202008:38:05GMT
Server:WSGIServer/0.2CPython/3.6.4
X-Frame-Options:SAMEORIGIN
Request Headers
view source
Accept:image/webp,image/apng,image/*,*/*;q=0.8
Accept-Encoding:gzip, deflate, br
```
<!-- OCR_END -->

￼

**方法二：**

随机生成图片，需要使用pillow模块,是一个图像处理模块，功能很强大

```plain
MacBook-pro:bbs driverzeng$ pip3 install pillow -i https://mirrors.aliyun.com/pypi/simple/
```

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    else:
        return HttpResponse('OK')
def get_valid_code(request):
    # with open('static/img/1.jpg','rb') as f:
    #     data = f.read()
    # return HttpResponse(data)
    ## 生成一张图片,mode:'RGB'模式 (320,35)图片大小,color颜色
    img = Image.new('RGB', (320, 35), color='green')
    ## 保存到本地
    with open('valid_code.png', 'wb') as f:
        # 使用save方法，第一个参数是空文件，第二个参数是格式
        img.save(f, 'png')
    ## 打开文件，再返回
    with open('valid_code.png', 'rb') as f:
        data = f.read()
    return HttpResponse(data)
```

<!-- OCR_START -->
- 登录页面
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanIUse
- iview组件|Element
- 登录
- 用户名
- 密码
- 验证码
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿

```text
pngIbbs
bbsvalid_code.png
djbbs
G#CE
Project
settings.py×
views.py
valid_code.png
models.py
login.html
urls.py
wsgi.py
bbs~/PycharmProjects/bbs
320x35 PNG(24-bit color) 188 B
bbs
_init_.py
settings.py
blog
migrations
0001_initial.py
init_.py
admin.py
apps.py
tests.py
static
templates
manage.py
Ili xternal Libraries
Scratches and Consoles
```
<!-- OCR_END -->

￼

***

| 随机验证码的颜色 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image
import random
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    else:
        return HttpResponse('OK')
def get_random_color():
    return (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
def get_valid_code(request):
    # with open('static/img/1.jpg','rb') as f:
    #     data = f.read()
    # return HttpResponse(data)
    ## 生成一张图片,mode:'RGB'模式 (320,35)图片大小,color颜色
    img = Image.new('RGB', (320, 35), color=get_random_color())
    ## 保存到本地
    with open('valid_code.png', 'wb') as f:
        # 使用save方法，第一个参数是空文件，第二个参数是格式
        img.save(f, 'png')
    ## 打开文件，再返回
    with open('valid_code.png', 'rb') as f:
        data = f.read()
    return HttpResponse(data)
```

<!-- OCR_START -->
- 登录页面
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanIUse
- iview组件|Element
- 登录
- 用户名
- 密码
- 验证码
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanlUseiview
- 组件IEle
- 登录
- 用户名
- 密码
- 验证码
- 曾老湿
<!-- OCR_END -->

￼

每次刷新都在变。

***

| 解决资源问题 |
| :--- |

每次都要保存一张图片，只要一访问，或者刷新页面都会保存，很占资源啊。

使用内存管理的模块 `BytesIO`

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image
import random
from io import BytesIO
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    else:
        return HttpResponse('OK')
def get_random_color():
    return (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color())
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
```

***

| 验证码添加文字 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image,ImageDraw,ImageFont
import random
from io import BytesIO
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    else:
        return HttpResponse('OK')
def get_random_color():
    return (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color())
    # 拿到画笔，在图片上画画
    img_draw = ImageDraw.Draw(img)
    # 生成一个字体对象 ，第一个参数是字体文件路径，第二个参数，是字体大小
    font = ImageFont.truetype('static/font/ss.TTF',size=26)
    ## 第一个参数，xy的坐标，第二个参数，文字，第三个参数，颜色，第四个参数，字体。
    img_draw.text((120,0),'python',get_random_color(),font=font)
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
```

<!-- OCR_START -->
- 登录页面
- 127.0.0.1:8000/login/
- 应用
- zabbix
- iview
- 组件IEler
- 登录
- 用户名
- 密码
- 验证码
- python
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- →C
- 127.0.0.1:8000/login/
- 应用zabbix-apiCanIUseiview组件|Element
- 登录
- 用户名
- 密码
- 验证码
- python
- 曾老湿
<!-- OCR_END -->

￼

***

| 验证码随机 |
| :--- |

写一个循环，循环5次，每次随机写一个(数字，大写，小写字母)

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image,ImageDraw,ImageFont
import random
from io import BytesIO
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    else:
        return HttpResponse('OK')
def get_random_color():
    return (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color())
    # 拿到画笔，在图片上画画
    img_draw = ImageDraw.Draw(img)
    # 生成一个字体对象 ，第一个参数是字体文件路径，第二个参数，是字体大小
    font = ImageFont.truetype('static/font/ss.TTF',size=26)
    ## 写一个循环，循环5次，每次随机写一个(数字，大写，小写字母)
    for i in range(5):
        char_num = random.randint(0,9)
        # 生成97 ~ 122的数字,生成字母
        char_lower = chr(random.randint(97,122))
        char_upper = chr(random.randint(65,90))
        char_str = str(random.choice([char_num,char_lower,char_upper]))
        ## 第一个参数，xy的坐标，第二个参数，文字，第三个参数，颜色，第四个参数，字体。
        img_draw.text((i*60+20, 0), char_str, get_random_color(), font=font)
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
```

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来~
- →C
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 登录
- 用户名
- 密码
- 验证码
- 7
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来~
- →C
- 127.0.0.1:8000/login/
- 应用zabbix-apiCanlUseiview组件|Element
- 登录
- 用户名
- 密码
- 验证码
- 曾老湿
<!-- OCR_END -->

￼

***

| 画线画点 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image,ImageDraw,ImageFont
import random
from io import BytesIO
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    else:
        return HttpResponse('OK')
def get_random_color_light():
    return (random.randint(0, 100), random.randint(0, 100), random.randint(0, 100))
def get_random_color_dark():
    return (random.randint(150, 255), random.randint(150, 255), random.randint(150, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color_light())
    # 拿到画笔，在图片上画画
    img_draw = ImageDraw.Draw(img)
    # 生成一个字体对象 ，第一个参数是字体文件路径，第二个参数，是字体大小
    font = ImageFont.truetype('static/font/ss.TTF',size=26)
    ## 写一个循环，循环5次，每次随机写一个(数字，大写，小写字母)
    for i in range(5):
        char_num = random.randint(0,9)
        # 生成97 ~ 122的数字,生成字母
        char_lower = chr(random.randint(97,122))
        char_upper = chr(random.randint(65,90))
        char_str = str(random.choice([char_num,char_lower,char_upper]))
        ## 第一个参数，xy的坐标，第二个参数，文字，第三个参数，颜色，第四个参数，字体。
        img_draw.text((i*60+20, 0), char_str, get_random_color_dark(), font=font)
    width = 350
    height = 45
    for i in range(10):
        x1 = random.randint(0,width)
        x2 = random.randint(0,width)
        y1 = random.randint(0,height)
        y2 = random.randint(0,height)
        #在图片上画线
        img_draw.line((x1,y1,x2,y2),fill=get_random_color_light())
    for i in range(50):
        img_draw.point([random.randint(0,width),random.randint(0,height)],fill=get_random_color_light())
        x = random.randint(0,width)
        y = random.randint(0,height)
        img_draw.arc((x,y,x+4,y+4),0,90,fill=get_random_color_light())
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
```

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanlUseiview组件IElen
- 登录
- 用户名
- 密码
- 验证码
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来～
- →C
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanlUseiview组件IElement
- 登录
- 用户名
- 密码
- 验证码
- 曾老湿
<!-- OCR_END -->

￼

***

| 刷新验证码 |
| :--- |

让用户点击图片，可以刷新验证码，尽量每次刷新图片越来越清晰

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form>
                <div class="form-group">
                    <label for="name">用户名</label>
                    <input type="text" id="name" class="form-control">
                </div>
                <div class="form-group">
                    <label for="pwd">密码</label>
                    <input type="password" id="pwd" class="form-control">
                </div>
                <div class="form-group">
                    <label for="valid_code">验证码</label>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="text" id="valid_code" class="form-control">
                        </div>
                        
                    </div>
                </div>
                <input type="button" value="登录" class="btn btn-primary pull-right">
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $('#img_code').click(function () {
        // 每次点击图片都在图片路径后面加一个 问号.
        $('#img_code')[0].src+='?'
    })
</script>
</html>
```

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来～
- ←→C
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 登录
- 用户名
- 密码
- 验证码
- Elements
- Source
- 
- Styles
- Computed
- EventListeners
- ::before
- Filter
- :hov.cls+
- 
- element.style{
- <divclass="col-md-6col-md-offset-3">
- <h1>登录</h1>
- grid-framework.less:18
- <form>
- <divclass="form-group>_
- 
- *[
- bootstrap.css:1062
- <labelfor="valid_code">验证码</label>
- box-sizing:border-box;
- <divclass="col-md-6">_
- div
- user agent stylesheet
- <img width="350"height="45” src
- http://127.0.0.1:8000/get valid code/??7???????7???7??7?????7???????77??777??????????????77??7???" alt
- display:block;
- id="img_code">
- ::after
- Inherited from body
- body
- scaffolding.less:32
- <input type="button”value="登录class="btn btn-primary pull-right”>
- size:14px
- Inherited fromhtml
- v<script>
- html{
- scaffolding.less:27
- $('#img_code').click(function（）{
- size:10pxt
- fOn
- v.container-fluiddiv.rowdiv.col-md-6.col-md-offset-3formdiv.form-groupdiv.row
- ight-color:
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿

```http
bbstemplates
login.html
djbbs
Project
settings.py
views.py
models.py
login.html
bbs~/PycharmProjects/bbs
1712293012341537
<div class="col-md-6">
bbs
<input type="password"id="valid_code” class="form-control">
_init_.py
<div>
settings.py
<img width=”350”height="45”
urls.py
src="/get_valid_code/"
wsgi.py
<div>
blog
</div>
migrations
<input type="button”value="登录”class="btn btn-primary pull-right">
0001_initial.py
<form>
init_.py
<div>
_init_.py
</div>
<div>
admin.py
40
</body>
apps.py
41
models.py
23
$（‘#img_code'）.click（function（）{tests.py
views.py
$（#img_code')[o].src+='?
45
static
46
</script>
font
47
/html>
SS.TTF
ima
Run:
dibbs
[21/Jun/2020 09:57:13]
？??? HTTP/1.1"200 4435
？?HTTP/1.1"
2004770
"GET
[21/Jun/2020 09:57:14]
"GET
[21/Jun/2020 09:57:14]
"GET
HTTP/1.12004324
[21/Jun/2020 09:57:14]
GET
？??？HTTP/1.1” 200 4737
[21/Jun/202009:57:14]
'GET
[21/Jun/2020 09:57:14]
"GET
HTTP/1.12004415
[21/Jun/202009:57:14]
"GET
???7HTTP/1.1200 4187
[21/Jun/2020 09:57:151 "GET [21/Jun/2020 09:57:15]
"GET
??????? HTTP/1.12004474
[21/Jun/2020 09:57:15]
"GET
[21/Jun/2020 09:57:15]
"GET
[21/Jun/2020 09:57:15]
"GET
HTTP/1.12004885
[21/Jun/202009:57:15]
"GET
/get_valid_code/???????
[21/Jun/2020 09:57:161 "GET HTTP/1.1"2004309
[21/Jun/2020 09:57:16]
"GET
？????HTTP/1.1200 4310
[21/]un/2020 09:57:17]
"GET
[21/Jun/2020 09:57:17]
"GET
HTTP/1.12004821
[21/Jun/2020 09:57:17]
"GET
/get_valid_code/?????????
？？?？
HTTP/1.12004690
[21/Jun/202009:57:17]
"GET
[21/Jun/202009:57:17]
"GET
/get_valid_code/ ？??7 HTTP/1.1200 4440
？?？
[21/Jun/202009:57:18]
"GET/ [21/un/2020 09:57:18]
????????HTTP/1.1"2004198
??777??? HTTP/1.12004559
Q3:Find4:Run6:TODO
```
<!-- OCR_END -->

￼

## 登录功能

***

| 保存验证码 |
| :--- |

把验证码保存到session中

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    ## 判断前台发的请求是不是ajax的请求
    elif request.is_ajax():
        response = {'user': None, 'msg': None}
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        valid_code = request.POST.get('valid_code')
        if valid_code.upper() == request.session.get('valid_code').upper():
            user = auth.authenticate(request, username=name, password=pwd)
            if user:
                ## ajax请求，不能再返回render页面或者redirect页面，只能返回字符串或者json
                ## 校验通过，一定要登录
                auth.login(request, user)
                response['user'] = name
                response['msg'] = '登录成功'
            else:
                response['msg'] = '用户名密码错误'
        else:
            response['msg'] = '验证码错误'
    return JsonResponse(response)
def get_random_color_light():
    return (random.randint(0, 100), random.randint(0, 100), random.randint(0, 100))
def get_random_color_dark():
    return (random.randint(150, 255), random.randint(150, 255), random.randint(150, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color_light())
    # 拿到画笔，在图片上画画
    img_draw = ImageDraw.Draw(img)
    # 生成一个字体对象 ，第一个参数是字体文件路径，第二个参数，是字体大小
    font = ImageFont.truetype('static/font/ss.TTF', size=26)
    ## 保存验证码
    random_code = ''
    ## 写一个循环，循环5次，每次随机写一个(数字，大写，小写字母)
    for i in range(5):
        char_num = random.randint(0, 9)
        # 生成97 ~ 122的数字,生成字母
        char_lower = chr(random.randint(97, 122))
        char_upper = chr(random.randint(65, 90))
        char_str = str(random.choice([char_num, char_lower, char_upper]))
        ## 第一个参数，xy的坐标，第二个参数，文字，第三个参数，颜色，第四个参数，字体。
        img_draw.text((i * 60 + 20, 0), char_str, get_random_color_dark(), font=font)
        random_code += char_str
    ## 把验证码 保存到session中
    request.session['valid_code'] = random_code
    width = 350
    height = 45
    for i in range(10):
        x1 = random.randint(0, width)
        x2 = random.randint(0, width)
        y1 = random.randint(0, height)
        y2 = random.randint(0, height)
        # 在图片上画线
        img_draw.line((x1, y1, x2, y2), fill=get_random_color_light())
    for i in range(100):
        img_draw.point([random.randint(0, width), random.randint(0, height)], fill=get_random_color_light())
        x = random.randint(0, width)
        y = random.randint(0, height)
        img_draw.arc((x, y, x + 4, y + 4), 0, 90, fill=get_random_color_light())
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
```

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form>
                {% csrf_token %}
                <div class="form-group">
                    <label for="name">用户名</label>
                    <input type="text" id="name" class="form-control">
                </div>
                <div class="form-group">
                    <label for="pwd">密码</label>
                    <input type="password" id="pwd" class="form-control">
                </div>
                <div class="form-group">
                    <label for="valid_code">验证码</label>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="text" id="valid_code" class="form-control">
                        </div>
                        
                    </div>
                </div>
                <input type="button" value="登录" class="btn btn-primary pull-right" id="btn">
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $('#img_code').click(function () {
        // 每次点击图片都在图片路径后面加一个 问号.
        $('#img_code')[0].src += '?'
    })
    $('#btn').click(function () {
        $.ajax({
            url: '/login/',
            type: 'post',
            // 一定要 记住 传CSRF
            data: {
                'name': $('#name').val(),
                'pwd': $('#pwd').val(),
                'valid_code': $('#valid_code').val(),
                // 使用属性选择器，选择
                'csrfmiddlewaretoken': $('[name="csrfmiddlewaretoken"]').val()
                //使用变量
                //'csrfmiddlewaretoken': '{{ csrf_token }}'
            },
            success:function (data) {
                console.log(data)
            }
        })
    })
</script>
</html>
```

创建一个用户

```plain
MacBook-pro:bbs driverzeng$ python3 manage.py createsuperuser
Username: zls
Email address: 133@qq.com
Password: zls12345
Password (again): zls12345
Superuser created successfully.
```

<!-- OCR_START -->
- 登录页面
- →C
- 127.0.0.1:8000/login/
- 应用zabbix-apiCanlUseiview组件|Element
- 登录
- 用户名
- zls
- 密码
- 验证码
- tgkic
- Applica
- Security
- Default levels
- 1hidden
- {user:
- zLs"，msg:“登录成功”}
- (index):62
- 曾老湿
<!-- OCR_END -->

￼

***

| 登录功能完善 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        .error{
            color: red;
            margin-left: 20px;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form>
                {% csrf_token %}
                <div class="form-group">
                    <label for="name">用户名</label>
                    <input type="text" id="name" class="form-control">
                </div>
                <div class="form-group">
                    <label for="pwd">密码</label>
                    <input type="password" id="pwd" class="form-control">
                </div>
                <div class="form-group">
                    <label for="valid_code">验证码</label>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="text" id="valid_code" class="form-control">
                        </div>
                        
                    </div>
                </div>
                <input type="button" value="登录" class="btn btn-primary" id="btn"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $('#img_code').click(function () {
        // 每次点击图片都在图片路径后面加一个 问号.
        $('#img_code')[0].src += '?'
    })
    $('#btn').click(function () {
        $.ajax({
            url: '/login/',
            type: 'post',
            // 一定要 记住 传CSRF
            data: {
                'name': $('#name').val(),
                'pwd': $('#pwd').val(),
                'valid_code': $('#valid_code').val(),
                // 使用属性选择器，选择
                'csrfmiddlewaretoken': $('[name="csrfmiddlewaretoken"]').val()
                //使用变量
                //'csrfmiddlewaretoken': '{{ csrf_token }}'
            },
            success:function (data) {
                console.log(data)
                if(data.user){
                    // 登录成功跳转到index页面
                    location.href = '/index/'
                }else {
                    $('.error').html(data.msg)
                }
            }
        })
    })
</script>
</html>
```

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来~
- ←→C
- 127.0.0.1:8000/login/
- 应用zabbix-api
- CanlIUseiview组件|Element
- 登录
- 用户名
- zls
- 密码
- 验证码
- k36b7
- 用户名密码错误
- Elements
- Sources
- Network
- Performance
- Memory
- Application
- Security
- Lighthouse
- top
- Fiter
- Default levels
- 1hidden
- fuser
- ull，msg：“用户名密码错误}
- (index):68
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来~
- →C
- 127.0.0.1:8000/login/
- 应用zabbix-
- CanIUse
- 组件|Element
- 登录
- 用户名
- zls
- 密码
- 验证码
- k36b7asd
- 验证码错误
- 曾老湿
<!-- OCR_END -->

￼

## 注册功能

***

| myforms |
| :--- |

使用forms组件。

创建一个forms组件的文件。

```plain
from django import forms
class RegForm(forms.Form):
    name = forms.CharField(max_length=18,min_length=2)
    pwd = forms.CharField(max_length=18,min_length=2)
    re_pwd = forms.CharField(max_length=18,min_length=2)
    emai = forms.EmailField()
```

***

| 路由层 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
]
```

***

| 视图层 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    ## 判断前台发的请求是不是ajax的请求
    elif request.is_ajax():
        response = {'user': None, 'msg': None}
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        valid_code = request.POST.get('valid_code')
        if valid_code.upper() == request.session.get('valid_code').upper():
            user = auth.authenticate(request, username=name, password=pwd)
            if user:
                ## ajax请求，不能再返回render页面或者redirect页面，只能返回字符串或者json
                ## 校验通过，一定要登录
                auth.login(request, user)
                response['user'] = name
                response['msg'] = '登录成功'
            else:
                response['msg'] = '用户名密码错误'
        else:
            response['msg'] = '验证码错误'
    return JsonResponse(response)
def get_random_color_light():
    return (random.randint(0, 100), random.randint(0, 100), random.randint(0, 100))
def get_random_color_dark():
    return (random.randint(150, 255), random.randint(150, 255), random.randint(150, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color_light())
    # 拿到画笔，在图片上画画
    img_draw = ImageDraw.Draw(img)
    # 生成一个字体对象 ，第一个参数是字体文件路径，第二个参数，是字体大小
    font = ImageFont.truetype('static/font/ss.TTF', size=26)
    ## 保存验证码
    random_code = ''
    ## 写一个循环，循环5次，每次随机写一个(数字，大写，小写字母)
    for i in range(5):
        char_num = random.randint(0, 9)
        # 生成97 ~ 122的数字,生成字母
        char_lower = chr(random.randint(97, 122))
        char_upper = chr(random.randint(65, 90))
        char_str = str(random.choice([char_num, char_lower, char_upper]))
        ## 第一个参数，xy的坐标，第二个参数，文字，第三个参数，颜色，第四个参数，字体。
        img_draw.text((i * 60 + 20, 0), char_str, get_random_color_dark(), font=font)
        random_code += char_str
    ## 把验证码 保存到session中
    request.session['valid_code'] = random_code
    width = 350
    height = 45
    for i in range(10):
        x1 = random.randint(0, width)
        x2 = random.randint(0, width)
        y1 = random.randint(0, height)
        y2 = random.randint(0, height)
        # 在图片上画线
        img_draw.line((x1, y1, x2, y2), fill=get_random_color_light())
    for i in range(100):
        img_draw.point([random.randint(0, width), random.randint(0, height)], fill=get_random_color_light())
        x = random.randint(0, width)
        y = random.randint(0, height)
        img_draw.arc((x, y, x + 4, y + 4), 0, 90, fill=get_random_color_light())
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
def register(request):
    my_form = myforms.RegForm()
    return render(request, 'register.html', {'my_form': my_form})
```

***

| 模板层 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>注册页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        #my_file {
            /* 把上传文件控件隐藏 */
            display: none;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form>
                {% csrf_token %}
                {% for foo in my_form %}
                    <div class="form-group">
                        <label for="{{ foo.auto_id }}">{{ foo.label }}</label>
                        {{ foo }}
                    </div>
                {% endfor %}
                {#                加一个上传文件的控件#}
                <div class="form-group">
                    <label for="my_file">
                        头像
                        
                    </label>
                    <input type="file" id="my_file">
                </div>
                <input type="button" value="注册" class="btn btn-primary" id="btn"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $("#my_file").change(function () {
        // 取出文件
        var file_obj = $("#my_file")[0].files[0]
        // 通过文件阅读器，把图片放到img标签上
        // 生成一个文件阅读器对象
        var filereader = new FileReader()
        // 把图片读到filereader对象中
        filereader.readAsDataURL(file_obj)
        // filereader.result是filereader对象的值
        filereader.onload = function () {
            $('#img_file').attr('src', filereader.result)
        }
    })
</script>
</html>
```

<!-- OCR_START -->
- 注册页面
- 127.0.0.1:8000/register/
- 应用
- iview
- 组件IEIe
- 登录
- 用户名
- 密码
- 确认密码
- 邮箱
- 头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 注册页面
- 127.0.0.1:8000/register/
- 应用
- zabbix-api
- CanlUse
- iview组件IEleme
- 登录
- 用户名
- 密码
- 确认密码
- 邮箱
- 头像
- 传头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 注册页面
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-apiCanlUseiview组件|Element
- 登录
- 用户名
- 密码
- 确认密码
- 邮箱
- 头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

## 提交注册信息

***

| 模板层 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>注册页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        #my_file {
            /* 把上传文件控件隐藏 */
            display: none;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form>
                {% csrf_token %}
                {% for foo in my_form %}
                    <div class="form-group">
                        <label for="{{ foo.auto_id }}">{{ foo.label }}</label>
                        {{ foo }}
                    </div>
                {% endfor %}
                {#                加一个上传文件的控件#}
                <div class="form-group">
                    <label for="my_file">
                        头像
                        
                    </label>
                    <input type="file" id="my_file">
                </div>
                <input type="button" value="注册" class="btn btn-primary" id="btn"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $("#my_file").change(function () {
        // 取出文件
        var file_obj = $("#my_file")[0].files[0]
        // 通过文件阅读器，把图片放到img标签上
        // 生成一个文件阅读器对象
        var filereader = new FileReader()
        // 把图片读到filereader对象中
        filereader.readAsDataURL(file_obj)
        // filereader.result是filereader对象的值
        filereader.onload = function () {
            $('#img_file').attr('src', filereader.result)
        }
    })
    $("#btn").click(function () {
        // 因为要上传文件，所以要生成一个formdata对象
        var formdata = new FormData()
        formdata.append('name',$('#id_name').val())
        formdata.append('pwd',$('#id_pwd').val())
        formdata.append('re_pwd',$('#id_re_pwd').val())
        formdata.append('email',$('#id_email').val())
        formdata.append('csrfmiddlewaretoken',$('[name="csrfmiddlewaretoken"]').val())
        // 把文件放到formdata中
        formdata.append('my_file',$('#my_file')[0].files[0])
        $.ajax({
            url: '/register/',
            type: 'post',
            processData:false,
            contentType:false,
            data: {},
            success: function (data) {
                console.log(data)
            }
        })
    })
</script>
</html>
```

***

| forms组件 |
| :--- |

```plain
from django import forms
from django.forms import widgets
class RegForm(forms.Form):
    name = forms.CharField(max_length=18, min_length=2, label='用户名',
                           widget=widgets.TextInput(attrs={'class': 'form-control'}))
    pwd = forms.CharField(max_length=18, min_length=2, label='密码',
                          widget=widgets.PasswordInput(attrs={'class': 'form-control'}))
    re_pwd = forms.CharField(max_length=18, min_length=2, label='确认密码',
                             widget=widgets.PasswordInput(attrs={'class': 'form-control'}))
    email = forms.EmailField(label='邮箱', widget=widgets.EmailInput(attrs={'class': 'form-control'}))
```

***

| 视图层 |
| :--- |

```plain
def register(request):
    if request.method == 'GET':
        my_form = myforms.RegForm()
        return render(request, 'register.html', {'my_form': my_form})
    elif request.is_ajax():
        response = {'status':100,'msg':None}
        my_form = myforms.RegForm(request.POST)
        if my_form.is_valid():
            pass
        else:
            response['status'] = 101
            response['msg'] = my_form.errors
        return JsonResponse(response)
```

<!-- OCR_START -->
- 注册页面
- 别离开我啊，小老弟，点回来~
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-apiCanlUseiview组件|Element
- 登录
- 用户名
- 1
- 密码
- 确认密码
- 邮箱
- 123@qq.com
- 头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 注册页面
- 别离开我啊，小老弟，点回来～
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 登录
- 用户名
- 1
- 密码
- 确认密码
- 邮箱
- 123@qq.com
- 头像
- 注册
- Elements
- Sources
- Network
- Performance
- nory
- Application
- Security
- Lighthouse
- 0top
- Filter
- Default levels
- 2hidden
- {status:101,msg:{}}
- (index):91
- name:["Ensure this value has at least 2 characters （it has 1)."]
- pwd:["Ensure this value has at least 2 characters (it has 1).]
- re_pwd:["Ensure this value has at least 2 characters (it has 1)."]
- proto_:object
- status:101
- 曾老湿
<!-- OCR_END -->

￼

现在我们提交的数据还不算多，但是如果数据多起来的话，模板层的代码，要命了。

<!-- OCR_START -->
$（"#my_file").change（function (){...}）
$（"#btn"）.click（function(){
因为要上传文件、所以要生成
个formdata对象
var formdata = new FormData()
formdata.append('name',$(#id_name').val())
formdata.append('pwd',$('#id_pwd').val())
formdata.append('re_pwd',$(#id_re_pwd').val(）)
formdata.append('email',$('#id_email').val())
formdata.append('csrfmiddlewaretoken',$('[name="csrfmiddlewaretoken"]').val())
//把文件放到formdata中
formdata.append('my_file',$('#my_file')[o].files[o])
$.ajax（
url:'/register/`
type:'post'
processData:false,
contentType:false,
data: formdata,
success: function （data）{
console.log(data)
曾老湿
Driver Zeng
<!-- OCR_END -->

￼

优化代码

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>注册页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        #my_file {
            /* 把上传文件控件隐藏 */
            display: none;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form id="form">
                {% csrf_token %}
                {% for foo in my_form %}
                    <div class="form-group">
                        <label for="{{ foo.auto_id }}">{{ foo.label }}</label>
                        {{ foo }}
                    </div>
                {% endfor %}
                {#                加一个上传文件的控件#}
                <div class="form-group">
                    <label for="my_file">
                        头像
                        
                    </label>
                    <input type="file" id="my_file">
                </div>
                <input type="button" value="注册" class="btn btn-primary" id="btn"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $("#my_file").change(function () {
        // 取出文件
        var file_obj = $("#my_file")[0].files[0]
        // 通过文件阅读器，把图片放到img标签上
        // 生成一个文件阅读器对象
        var filereader = new FileReader()
        // 把图片读到filereader对象中
        filereader.readAsDataURL(file_obj)
        // filereader.result是filereader对象的值
        filereader.onload = function () {
            $('#img_file').attr('src', filereader.result)
        }
    })
    $("#btn").click(function () {
        // 因为要上传文件，所以要生成一个formdata对象
        var formdata = new FormData()
        {#formdata.append('name',$('#id_name').val())#}
        {#formdata.append('pwd',$('#id_pwd').val())#}
        {#formdata.append('re_pwd',$('#id_re_pwd').val())#}
        {#formdata.append('email',$('#id_email').val())#}
        var arr = $('#form').serializeArray()
        // jquery的循环
        $.each(arr, function (key, value) {
            formdata.append(value.name, value.value)
        })
        formdata.append('csrfmiddlewaretoken', $('[name="csrfmiddlewaretoken"]').val())
        // 把文件放到formdata中
        formdata.append('my_file', $('#my_file')[0].files[0])
        $.ajax({
            url: '/register/',
            type: 'post',
            processData: false,
            contentType: false,
            data: formdata,
            success: function (data) {
                console.log(data)
            }
        })
    })
</script>
</html>
```

***

| 注册成功插入数据 |
| :--- |

myforms.py

```plain
from django import forms
from django.forms import widgets
from blog import models
from django.core.exceptions import ValidationError
class RegForm(forms.Form):
    username = forms.CharField(max_length=18, min_length=2, label='用户名',
                           widget=widgets.TextInput(attrs={'class': 'form-control'}))
    password = forms.CharField(max_length=18, min_length=2, label='密码',
                          widget=widgets.PasswordInput(attrs={'class': 'form-control'}))
    re_password = forms.CharField(max_length=18, min_length=2, label='确认密码',
                             widget=widgets.PasswordInput(attrs={'class': 'form-control'}))
    email = forms.EmailField(label='邮箱', widget=widgets.EmailInput(attrs={'class': 'form-control'}))
    # 局部校验钩子
    def clean_username(self):
        name = self.cleaned_data.get('username')
        # 去数据库校验
        ret = models.UserInfo.objects.filter(username=name).first()
        if ret:
            raise ValidationError('用户名已存在')
        return name
    # 全局校验钩子
    def clean(self):
        pwd = self.cleaned_data.get('password')
        re_pwd = self.cleaned_data.get('re_password')
        if pwd and re_pwd:
            if pwd == re_pwd:
                return self.cleaned_data
            else:
                raise ValidationError('两次密码不一致')
```

views.py

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    ## 判断前台发的请求是不是ajax的请求
    elif request.is_ajax():
        response = {'user': None, 'msg': None}
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        valid_code = request.POST.get('valid_code')
        if valid_code.upper() == request.session.get('valid_code').upper():
            user = auth.authenticate(request, username=name, password=pwd)
            if user:
                ## ajax请求，不能再返回render页面或者redirect页面，只能返回字符串或者json
                ## 校验通过，一定要登录
                auth.login(request, user)
                response['user'] = name
                response['msg'] = '登录成功'
            else:
                response['msg'] = '用户名密码错误'
        else:
            response['msg'] = '验证码错误'
    return JsonResponse(response)
def get_random_color_light():
    return (random.randint(0, 100), random.randint(0, 100), random.randint(0, 100))
def get_random_color_dark():
    return (random.randint(150, 255), random.randint(150, 255), random.randint(150, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color_light())
    # 拿到画笔，在图片上画画
    img_draw = ImageDraw.Draw(img)
    # 生成一个字体对象 ，第一个参数是字体文件路径，第二个参数，是字体大小
    font = ImageFont.truetype('static/font/ss.TTF', size=26)
    ## 保存验证码
    random_code = ''
    ## 写一个循环，循环5次，每次随机写一个(数字，大写，小写字母)
    for i in range(5):
        char_num = random.randint(0, 9)
        # 生成97 ~ 122的数字,生成字母
        char_lower = chr(random.randint(97, 122))
        char_upper = chr(random.randint(65, 90))
        char_str = str(random.choice([char_num, char_lower, char_upper]))
        ## 第一个参数，xy的坐标，第二个参数，文字，第三个参数，颜色，第四个参数，字体。
        img_draw.text((i * 60 + 20, 0), char_str, get_random_color_dark(), font=font)
        random_code += char_str
    ## 把验证码 保存到session中
    request.session['valid_code'] = random_code
    width = 350
    height = 45
    for i in range(10):
        x1 = random.randint(0, width)
        x2 = random.randint(0, width)
        y1 = random.randint(0, height)
        y2 = random.randint(0, height)
        # 在图片上画线
        img_draw.line((x1, y1, x2, y2), fill=get_random_color_light())
    for i in range(100):
        img_draw.point([random.randint(0, width), random.randint(0, height)], fill=get_random_color_light())
        x = random.randint(0, width)
        y = random.randint(0, height)
        img_draw.arc((x, y, x + 4, y + 4), 0, 90, fill=get_random_color_light())
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
def register(request):
    if request.method == 'GET':
        my_form = myforms.RegForm()
        return render(request, 'register.html', {'my_form': my_form})
    elif request.is_ajax():
        response = {'status': 100, 'msg': None}
        my_form = myforms.RegForm(request.POST)
        if my_form.is_valid():
            ## 定义一个字段，把通过的数据赋值给字典
            dic = my_form.cleaned_data
            ## 移除确认密码的字段
            dic.pop('re_password')
            ## 取出上传的文件对象
            my_file = request.FILES.get('my_file')
            ## 放到字典中
            ## 如果没有上传文件，数据库存默认值
            if my_file:
                dic['avatar'] = my_file
            user = models.UserInfo.objects.create_user(**dic)
            print(user.username)
        else:
            response['status'] = 101
            response['msg'] = my_form.errors
        return JsonResponse(response)
```

**用户已存在**

<!-- OCR_START -->
- 注册页面
- 别离开我啊，小老弟，点回来～
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-api
- 组件|Element
- 登录
- 用户名
- zls
- 密码
- 确认密码
- 邮箱
- 123@qq.com
- 头像
- 注册
- Elements
- Sources
- Network
- Memory
- Application
- Security
- Lighthouse
- ②o
- Filte
- Default levels
- 2hidden
- {status:101,msg:{)}
- (index):97
- msg:
- username：[“用户名已存在"]
- :Object
- status:101
- 曾老湿
<!-- OCR_END -->

￼

**密码不一致**

<!-- OCR_START -->
- 注册页面
- 别离开我啊，小老弟，点回来～
- 127.0.0.1:8000/register/
- 应用zabbix-api
- iview
- 组件|Elem
- 登录
- 用户名
- zls1
- 密码
- 确认密码
- 邮箱
- 123@qq.com
- 头值
- 注册
- top
- Defaultlevels
- {status:101,msg:{}}
- (index):97
- 一致]
- object
- 曾老湿
<!-- OCR_END -->

￼

**注册成功**

<!-- OCR_START -->
- 注册页面
- 别离开我啊，小老弟，点回来～
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-api
- CanIUseiview组件|Element
- 登录
- 用户名
- zls1
- 密码
- **
- 确认密码
- 邮箱
- 123@qq.com
- 头像
- 注册
- Elements
- Sources
- Network
- Performance
- Memory
- Application
- Security
- Lighthouse
- ①o
- Filter
- Default levels
- {status:100,msg:null}
- (index):97
- status:
- 100
- 曾老湿
- :Object
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Database
- bbs@10.0.0.51 schemas）bbsblog_userinfo
- djbbs
- G#CE
- Project
- models.py
- login.html×
- register.html
- bbs@10.0.0.51x
- 用bbs.blog_userinfo[bbs@10.0.0.51]=4
- 2rows
- 1
- Tx:Auto
- avatar
- <Fiter criteria>
- bbs@10.0.0.511of8
- Dbbs
- password
- last login
- issuperuserusername
- schemas1
- pbkdf2 sha256$36000$Mqys2Y6u8I1e$X_2020-06-21 11:22:56.070269
- settings.py
- 1zls
- ▼bbs
- 2pbkdf2_sha256$36000$wQ3DYs0bJW01$c.<null>
- 0zls1
- urls.py
- auth_group
- auth_group_permissions
- wsgi.py
- auth_permission
- blog
- blog_article
- 0001_initial.py
- blog_articletotag
- 0002_auto_20200621_1027.py
- blog_blog
- blog_category
- _init_.py
- blog_commit
- blog_tag
- admin.py
- apps.py
- blog_upan
- nddown
- blog_userinfo
- myforms.py
- blog_userinfo_groups
- blog_userinfo_user_permissions
- tests.py
- views.py
- django_admin_log
- 田django_content.type
- static
- django_migrations
- font
- Ss.TTF
- django_session
- collations 219
- img
- 1jpg
- default.png
- templates
- 曾老湿
- sole:
- nfo[bbs@10.0.0.51]
<!-- OCR_END -->

￼

最后说一个，在上传文件中，加一个image/\*可以控制图片的显示。

```plain
<input accept="image/*" type="file" id="my_file">
```

## 渲染错误信息

***

| 模板层 |
| :--- |

判断，数据的返回。

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>注册页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        #my_file {
            /* 把上传文件控件隐藏 */
            display: none;
        }
        .error{
            color: red;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form id="form">
                {% csrf_token %}
                {% for foo in my_form %}
                    <div class="form-group">
                        <label for="{{ foo.auto_id }}">{{ foo.label }}</label>
                        {{ foo }} <span class="error pull-right"></span>
                    </div>
                {% endfor %}
                {#                加一个上传文件的控件#}
                <div class="form-group">
                    <label for="my_file">
                        头像
                        
                    </label>
                    <input accept="image/*" type="file" id="my_file">
                </div>
                <input type="button" value="注册" class="btn btn-primary" id="btn"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $("#my_file").change(function () {
        // 取出文件
        var file_obj = $("#my_file")[0].files[0]
        // 通过文件阅读器，把图片放到img标签上
        // 生成一个文件阅读器对象
        var filereader = new FileReader()
        // 把图片读到filereader对象中
        filereader.readAsDataURL(file_obj)
        // filereader.result是filereader对象的值
        filereader.onload = function () {
            $('#img_file').attr('src', filereader.result)
        }
    })
    $("#btn").click(function () {
        // 因为要上传文件，所以要生成一个formdata对象
        var formdata = new FormData()
        {#formdata.append('name',$('#id_name').val())#}
        {#formdata.append('pwd',$('#id_pwd').val())#}
        {#formdata.append('re_pwd',$('#id_re_pwd').val())#}
        {#formdata.append('email',$('#id_email').val())#}
        var arr = $('#form').serializeArray()
        // jquery的循环
        $.each(arr, function (key, value) {
            formdata.append(value.name, value.value)
        })
        formdata.append('csrfmiddlewaretoken', $('[name="csrfmiddlewaretoken"]').val())
        // 把文件放到formdata中
        formdata.append('my_file', $('#my_file')[0].files[0])
        $.ajax({
            url: '/register/',
            type: 'post',
            processData: false,
            contentType: false,
            data: formdata,
            success: function (data) {
                console.log(data)
                if(data.status === 100){
                    location.href = data.url
                }else {
                    $.each(data.msg,function (key, value) {
                        console.log(key,value)
                        // 根据key 拼上id 通过id取出控件
                        //$('#id_username').next().html('sb')
                        //$('#id_'+key).next().html(value[0])
                        // 取出爸爸，然后加报错颜色
                        //$('#id_'+key).parent().addClass('has-error')
                        //  一行代码实现
                        $('#id_'+key).next().html(value[0]).parent().addClass('has-error')
                    })
                }
            }
        })
    })
</script>
</html>
```

***

| 视图层 |
| :--- |

```plain
def register(request):
    if request.method == 'GET':
        my_form = myforms.RegForm()
        return render(request, 'register.html', {'my_form': my_form})
    elif request.is_ajax():
        response = {'status': 100, 'msg': None}
        my_form = myforms.RegForm(request.POST)
        if my_form.is_valid():
            ## 定义一个字段，把通过的数据赋值给字典
            dic = my_form.cleaned_data
            ## 移除确认密码的字段
            dic.pop('re_password')
            ## 取出上传的文件对象
            my_file = request.FILES.get('my_file')
            ## 放到字典中
            ## 如果没有上传文件，数据库存默认值
            if my_file:
                dic['avatar'] = my_file
            user = models.UserInfo.objects.create_user(**dic)
            print(user.username)
            response['url'] = '/login/'
        else:
            response['status'] = 101
            response['msg'] = my_form.errors
        return JsonResponse(response)
```

***

| myforms组件 |
| :--- |

```plain
from django import forms
from django.forms import widgets
from blog import models
from django.core.exceptions import ValidationError
class RegForm(forms.Form):
    username = forms.CharField(max_length=18, min_length=2, label='用户名',
                           widget=widgets.TextInput(attrs={'class': 'form-control'}))
    password = forms.CharField(max_length=18, min_length=2, label='密码',
                          widget=widgets.PasswordInput(attrs={'class': 'form-control'}))
    re_password = forms.CharField(max_length=18, min_length=2, label='确认密码',
                             widget=widgets.PasswordInput(attrs={'class': 'form-control'}))
    email = forms.EmailField(label='邮箱', widget=widgets.EmailInput(attrs={'class': 'form-control'}))
    # 局部校验钩子
    def clean_username(self):
        name = self.cleaned_data.get('username')
        # 去数据库校验
        ret = models.UserInfo.objects.filter(username=name).first()
        if ret:
            raise ValidationError('用户名已存在')
        return name
    # 全局校验钩子
    def clean(self):
        pwd = self.cleaned_data.get('password')
        re_pwd = self.cleaned_data.get('re_password')
        if pwd and re_pwd:
            if pwd == re_pwd:
                return self.cleaned_data
            else:
                raise ValidationError('两次密码不一致')
```

<!-- OCR_START -->
- 注册页面
- 别离开我啊，小老弟，点回来～
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Eleme
- 登录
- 用户名
- Ensure thisvaluehasatleast2characters（ithas1）
- 密码
- 确认密码
- 邮箱
- 4
- Enteravalidemailaddress.
- 头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

但是这么写有个bug，如果把对应字段改成正确的之后，点击注册，还是这些错误

<!-- OCR_START -->
- 注册页面
- 别离开我啊，小老弟，点回来~
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 登录
- 用户名
- aaaaaa
- Ensure thisvaluehasatleast2characters(ithas1)
- 密码
- 确认密码
- 邮箱
- 4
- Enteravalidemailaddress
- 头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>注册页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        #my_file {
            /* 把上传文件控件隐藏 */
            display: none;
        }
        .error{
            color: red;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form id="form">
                {% csrf_token %}
                {% for foo in my_form %}
                    <div class="form-group">
                        <label for="{{ foo.auto_id }}">{{ foo.label }}</label>
                        {{ foo }} <span class="error pull-right"></span>
                    </div>
                {% endfor %}
                {#                加一个上传文件的控件#}
                <div class="form-group">
                    <label for="my_file">
                        头像
                        
                    </label>
                    <input accept="image/*" type="file" id="my_file">
                </div>
                <input type="button" value="注册" class="btn btn-primary" id="btn"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $("#my_file").change(function () {
        // 取出文件
        var file_obj = $("#my_file")[0].files[0]
        // 通过文件阅读器，把图片放到img标签上
        // 生成一个文件阅读器对象
        var filereader = new FileReader()
        // 把图片读到filereader对象中
        filereader.readAsDataURL(file_obj)
        // filereader.result是filereader对象的值
        filereader.onload = function () {
            $('#img_file').attr('src', filereader.result)
        }
    })
    $("#btn").click(function () {
        // 因为要上传文件，所以要生成一个formdata对象
        var formdata = new FormData()
        {#formdata.append('name',$('#id_name').val())#}
        {#formdata.append('pwd',$('#id_pwd').val())#}
        {#formdata.append('re_pwd',$('#id_re_pwd').val())#}
        {#formdata.append('email',$('#id_email').val())#}
        var arr = $('#form').serializeArray()
        // jquery的循环
        $.each(arr, function (key, value) {
            formdata.append(value.name, value.value)
        })
        formdata.append('csrfmiddlewaretoken', $('[name="csrfmiddlewaretoken"]').val())
        // 把文件放到formdata中
        formdata.append('my_file', $('#my_file')[0].files[0])
        $.ajax({
            url: '/register/',
            type: 'post',
            processData: false,
            contentType: false,
            data: formdata,
            success: function (data) {
                console.log(data)
                if(data.status === 100){
                    location.href = data.url
                }else {
                    $('.form-group').removeClass('has-error')
                        $('.error').html('')
                    $.each(data.msg,function (key, value) {
                        console.log(key,value)
                        // 根据key 拼上id 通过id取出控件
                        //$('#id_username').next().html('sb')
                        //$('#id_'+key).next().html(value[0])
                        // 取出爸爸，然后加报错颜色
                        //$('#id_'+key).parent().addClass('has-error')
                        //  一行代码实现
                        $('#id_'+key).next().html(value[0]).parent().addClass('has-error')
                    })
                    /*setTimeout(function () {
                        // 清除父级的has-error
                        // 清除错误信息
                        $('.form-group').removeClass('has-error')
                        $('.error').html('')
                    },3000)*/
                }
            }
        })
    })
</script>
</html>
```

***

| 处理form组件钩子报错显示 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>注册页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        #my_file {
            /* 把上传文件控件隐藏 */
            display: none;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form id="form">
                {% csrf_token %}
                {% for foo in my_form %}
                    <div class="form-group">
                        <label for="{{ foo.auto_id }}">{{ foo.label }}</label>
                        {{ foo }} <span class="error pull-right"></span>
                    </div>
                {% endfor %}
                {#                加一个上传文件的控件#}
                <div class="form-group">
                    <label for="my_file">
                        头像
                        
                    </label>
                    <input accept="image/*" type="file" id="my_file">
                </div>
                <input type="button" value="注册" class="btn btn-primary" id="btn"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $("#my_file").change(function () {
        // 取出文件
        var file_obj = $("#my_file")[0].files[0]
        // 通过文件阅读器，把图片放到img标签上
        // 生成一个文件阅读器对象
        var filereader = new FileReader()
        // 把图片读到filereader对象中
        filereader.readAsDataURL(file_obj)
        // filereader.result是filereader对象的值
        filereader.onload = function () {
            $('#img_file').attr('src', filereader.result)
        }
    })
    $("#btn").click(function () {
        // 因为要上传文件，所以要生成一个formdata对象
        var formdata = new FormData()
        {#formdata.append('name',$('#id_name').val())#}
        {#formdata.append('pwd',$('#id_pwd').val())#}
        {#formdata.append('re_pwd',$('#id_re_pwd').val())#}
        {#formdata.append('email',$('#id_email').val())#}
        var arr = $('#form').serializeArray()
        // jquery的循环
        $.each(arr, function (key, value) {
            formdata.append(value.name, value.value)
        })
        formdata.append('csrfmiddlewaretoken', $('[name="csrfmiddlewaretoken"]').val())
        // 把文件放到formdata中
        formdata.append('my_file', $('#my_file')[0].files[0])
        $.ajax({
            url: '/register/',
            type: 'post',
            processData: false,
            contentType: false,
            data: formdata,
            success: function (data) {
                console.log(data)
                if (data.status === 100) {
                    location.href = data.url
                } else {
                    $('.form-group').removeClass('has-error')
                    $('.error').html('')
                    $.each(data.msg, function (key, value) {
                        console.log(key, value)
                        // 根据key 拼上id 通过id取出控件
                        //$('#id_username').next().html('sb')
                        //$('#id_'+key).next().html(value[0])
                        // 取出爸爸，然后加报错颜色
                        //$('#id_'+key).parent().addClass('has-error')
                        // 处理两次密码 不一致
                        if(key === '__all__'){
                            $('#id_re_password').next().html(value[0])
                        }
                        //  一行代码实现
                        $('#id_' + key).next().html(value[0]).parent().addClass('has-error')
                    })
                    /*setTimeout(function () {
                        // 清除父级的has-error
                        // 清除错误信息
                        $('.form-group').removeClass('has-error')
                        $('.error').html('')
                    },3000)*/
                }
            }
        })
    })
</script>
</html>
```

<!-- OCR_START -->
- 注册页面
- 127.0.0.1:8000/register/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件IElem
- 登录
- 用户名
- zls
- 用户名已存在
- 密码
- **.
- 确认密码
- 两次密码不一致
- 邮箱
- 123@qq.com
- 头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

***

| 错误信息显示中文 |
| :--- |

myforms.py

```plain
from django import forms
from django.forms import widgets
from blog import models
from django.core.exceptions import ValidationError
class RegForm(forms.Form):
    username = forms.CharField(max_length=18, min_length=2, label='用户名',
                               widget=widgets.TextInput(attrs={'class': 'form-control'}),
                               error_messages={'max_length': '最长18位哦~', 'min_length': '最少2位哦~', 'required': '必须填写哦~'})
    password = forms.CharField(max_length=18, min_length=2, label='密码',
                               widget=widgets.PasswordInput(attrs={'class': 'form-control'}),
                               error_messages={'max_length': '最长18位哦~', 'min_length': '最少2位哦~', 'required': '必须填写哦~'})
    re_password = forms.CharField(max_length=18, min_length=2, label='确认密码',
                                  widget=widgets.PasswordInput(attrs={'class': 'form-control'}),
                                  error_messages={'max_length': '最长18位哦~', 'min_length': '最少2位哦~',
                                                  'required': '必须填写哦~'})
    email = forms.EmailField(label='邮箱', widget=widgets.EmailInput(attrs={'class': 'form-control'}),
                             error_messages={'invalid': '请填写邮件格式，傻x', 'required': '必须填写哦~'})
    # 局部校验钩子
    def clean_username(self):
        name = self.cleaned_data.get('username')
        # 去数据库校验
        ret = models.UserInfo.objects.filter(username=name).first()
        if ret:
            raise ValidationError('用户名已存在')
        return name
    # 全局校验钩子
    def clean(self):
        pwd = self.cleaned_data.get('password')
        re_pwd = self.cleaned_data.get('re_password')
        if pwd and re_pwd:
            if pwd == re_pwd:
                return self.cleaned_data
            else:
                raise ValidationError('两次密码不一致')
```

<!-- OCR_START -->
- 注册页面
- 127.0.0.1:8000/register/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Elemen
- 登录
- 用户名
- 最少2位哦～
- 密码
- 确认密码
- 邮箱
- 请填写邮件格式，傻x
- 头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

***

| 失去焦点 |
| :--- |

啥意思呢？当填写完用户名的时候，鼠标移动到下一个框的时候，用户名的框就失去焦点了，那么在失去焦点的时候，瞬间显示出，这个字段的校验错误信息。

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>注册页面</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        #my_file {
            /* 把上传文件控件隐藏 */
            display: none;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <h1>登录</h1>
            <form id="form">
                {% csrf_token %}
                {% for foo in my_form %}
                    <div class="form-group">
                        <label for="{{ foo.auto_id }}">{{ foo.label }}</label>
                        {{ foo }} <span class="error pull-right"></span>
                    </div>
                {% endfor %}
                {#                加一个上传文件的控件#}
                <div class="form-group">
                    <label for="my_file">
                        头像
                        
                    </label>
                    <input accept="image/*" type="file" id="my_file">
                </div>
                <input type="button" value="注册" class="btn btn-primary" id="btn"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $("#my_file").change(function () {
        // 取出文件
        var file_obj = $("#my_file")[0].files[0]
        // 通过文件阅读器，把图片放到img标签上
        // 生成一个文件阅读器对象
        var filereader = new FileReader()
        // 把图片读到filereader对象中
        filereader.readAsDataURL(file_obj)
        // filereader.result是filereader对象的值
        filereader.onload = function () {
            $('#img_file').attr('src', filereader.result)
        }
    })
    $("#btn").click(function () {
        // 因为要上传文件，所以要生成一个formdata对象
        var formdata = new FormData()
        {#formdata.append('name',$('#id_name').val())#}
        {#formdata.append('pwd',$('#id_pwd').val())#}
        {#formdata.append('re_pwd',$('#id_re_pwd').val())#}
        {#formdata.append('email',$('#id_email').val())#}
        var arr = $('#form').serializeArray()
        // jquery的循环
        $.each(arr, function (key, value) {
            formdata.append(value.name, value.value)
        })
        formdata.append('csrfmiddlewaretoken', $('[name="csrfmiddlewaretoken"]').val())
        // 把文件放到formdata中
        formdata.append('my_file', $('#my_file')[0].files[0])
        $.ajax({
            url: '/register/',
            type: 'post',
            processData: false,
            contentType: false,
            data: formdata,
            success: function (data) {
                console.log(data)
                if (data.status === 100) {
                    location.href = data.url
                } else {
                    $('.form-group').removeClass('has-error')
                    $('.error').html('')
                    $.each(data.msg, function (key, value) {
                        console.log(key, value)
                        // 根据key 拼上id 通过id取出控件
                        //$('#id_username').next().html('sb')
                        //$('#id_'+key).next().html(value[0])
                        // 取出爸爸，然后加报错颜色
                        //$('#id_'+key).parent().addClass('has-error')
                        // 处理两次密码 不一致
                        if(key === '__all__'){
                            $('#id_re_password').next().html(value[0])
                        }
                        //  一行代码实现
                        $('#id_' + key).next().html(value[0]).parent().addClass('has-error')
                    })
                    /*setTimeout(function () {
                        // 清除父级的has-error
                        // 清除错误信息
                        $('.form-group').removeClass('has-error')
                        $('.error').html('')
                    },3000)*/
                }
            }
        })
    })
    // name失去焦点，发ajax请求校验用户是否存在
    /*$('#id_username').change(function () {
        alert('change')
    })*/
    //只要发生变化就去校验
    $('#id_username').blur(function () {
        $.ajax({
            url: '/check_username/',
            type: 'post',
            data:{name:$('#id_username').val(),'csrfmiddlewaretoken':'{{ csrf_token }}'},
            success:function (data) {
                if(data.status === 101){
                    $('#id_username').next().html(data.msg).parent().addClass('has-error')
                }
            }
        })
    })
</script>
</html>
```

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
]
```

```plain
def check_username(request):
    response = {'status':100,'msg':None}
    name = request.POST.get('name')
    user = models.UserInfo.objects.filter(username=name).first()
    if user:
        response['status'] = 101
        response['msg'] = '用户名已存在'
    return JsonResponse(response)
```

<!-- OCR_START -->
- 注册页面
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-api
- CanlUseiview组件IElement
- 登录
- 用户名
- zls
- 用户名已存在
- 密码
- 确认密码
- 邮箱
- 注册
- 曾老湿
<!-- OCR_END -->

￼

## 首页设计

***

| 创建index页面 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-default">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">Brand</a>
    </div>
    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li class="active"><a href="#">Link <span class="sr-only">(current)</span></a></li>
        <li><a href="#">Link</a></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">Separated link</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">One more separated link</a></li>
          </ul>
        </li>
      </ul>
      <form class="navbar-form navbar-left">
        <div class="form-group">
          <input type="text" class="form-control" placeholder="Search">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#">Link</a></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">Separated link</a></li>
          </ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2"></div>
        <div class="col-md-7"></div>
        <div class="col-md-3"></div>
    </div>
</div>
</body>
</html>
```

***

| 配置路由 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
]
```

***

| 配置视图 |
| :--- |

```plain
def index(request):
    return render(request,'index.html')
```

<!-- OCR_START -->
- 博客
- 127.0.0.1:8000/index/
- 8
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- Brand
- Link
- Dropdown
- Search
- Submit
- 曾老湿
<!-- OCR_END -->

￼

***

| 修改导航 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">曾老湿博客系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">文章 <span class="sr-only">(current)</span></a></li>
                    <li><a href="#">随笔</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#">Link</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                           aria-expanded="false">个人中心 <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">修改密码</a></li>
                            <li><a href="#">修改头像</a></li>
                            <li><a href="#">修改主题</a></li>
                            <li role="separator" class="divider"></li>
                            <li><a href="/logout/">注销</a></li>
                        </ul>
                    </li>
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2"></div>
        <div class="col-md-7"></div>
        <div class="col-md-3"></div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 博客
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/index#
- 9
- 应用
- zabbix
- iview
- 组件|Element
- 曾老湿博客系统
- 文章
- 随笔
- Link
- 个人中心
- 修改密码
- 修改头像
- 修改主题
- 注销
- 曾老湿
<!-- OCR_END -->

￼

***

| 实现注销 |
| :--- |

**添加路由**

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
]
```

**编辑视图**

```plain
def logout(request):
    auth.logout(request)
    return redirect('/index/')
```

***

| 显示登录用户名 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">曾老湿博客系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">文章<span class="sr-only">(current)</span></a></li>
                    <li><a href="#">随笔</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    {% if request.user.is_authenticated %}
                        <li><a href="#">{{ request.user.username }}</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                               aria-haspopup="true"
                               aria-expanded="false">个人中心<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="#">修改密码</a></li>
                                <li><a href="#">修改头像</a></li>
                                <li><a href="#">修改主题</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="/logout/">注销</a></li>
                            </ul>
                        </li>
                    {% else %}
                        <li><a href="/login/">登录</a></li>
                        <li><a href="/register/">注册</a></li>
                    {% endif %}
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2"></div>
        <div class="col-md-7"></div>
        <div class="col-md-3"></div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 博客
- 别离开我啊，小老弟，点回来～
- ←→C
- 127.0.0.1:8000/index/
- 8
- 应用zabbix-api
- CanIUseiview组件|Element
- 曾老湿博客系统
- 文章
- 随笔
- 登录
- 注册
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来~
- ←→C
- 127.0.0.1:8000/login/
- 应用zabbix-apiCanlUseiview组件|Element
- 登录
- 用户名
- zls
- 密码
- 验证码
- 12y5a
- 验证码错误
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 博客
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/index/
- 应用zabbix-
- CanIUse
- iview
- 组件|Element
- 曾老湿博客系统
- 文章
- 随笔
- zls
- 个人中心
- 修改密码
- 修改头像
- 修改主题
- 注销
- 曾老湿
<!-- OCR_END -->

￼

***

| 添加侧边栏 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <style>
        body{
            background-image: url("/static/img/bg.jpg");
        }
    </style>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">曾老湿博客系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">文章<span class="sr-only">(current)</span></a></li>
                    <li><a href="#">随笔</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    {% if request.user.is_authenticated %}
                        <li><a href="#">{{ request.user.username }}</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                               aria-haspopup="true"
                               aria-expanded="false">个人中心<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="#">修改密码</a></li>
                                <li><a href="#">修改头像</a></li>
                                <li><a href="#">修改主题</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="/logout/">注销</a></li>
                            </ul>
                        </li>
                    {% else %}
                        <li><a href="/login/">登录</a></li>
                        <li><a href="/register/">注册</a></li>
                    {% endif %}
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2">
            <div class="panel panel-danger">
                <div class="panel-heading">重金求子</div>
                <div class="panel-body">
                    <p>请联系：13800000000</p>
                    <p>年入60w</p>
                </div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">草榴社区</div>
                <div class="panel-body">
                    <a href="http://www.driverzeng.com">请点击跳转</a>
                </div>
            </div>
        </div>
        <div class="col-md-7"></div>
        <div class="col-md-3">
            <div class="panel panel-success">
                <div class="panel-heading">日韩系列</div>
                <div class="panel-body">
                    <a href="http://download.driverzeng.com">Tokyo Hot</a>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">欧美系列</div>
                <div class="panel-body">
                    <a href="http://blog.driverzeng.com">金八天国</a>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">动漫卡通</div>
                <div class="panel-body">
                    <a href="http://pikachu.driverzeng.com">女仆</a>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">精品图区</div>
                <div class="panel-body">
                    <a href="http://taiji.driverzeng.com">美腿丝袜</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 博客
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/index/
- 应用zabbix-apiCanlUseiview
- 组件|Element
- 曾老湿博客系统
- 文章
- 随笔
- 登录
- 注册
- 重金求子
- 日韩系列
- 请联系：13800000000
- TokyoHot
- 年入60w
- 欧美系列
- 草榴社区
- 金八天国
- 请点击跳转
- 动漫卡通
- 女仆
- 精品图区
- 美腿丝袜
- 曾老湿
<!-- OCR_END -->

￼

***

| 主页面 |
| :--- |

```plain
def index(request):
    article_list =  models.Article.objects.all()
    return render(request,'index.html',{'article_list':article_list})
```

**使用admin组件添加数据**

<http://127.0.0.1:8000/admin>

<!-- OCR_START -->
博客
别离开我啊，小老弟，点回来~
Log inIDjango site admin
→C
0127.0.0.1:8000/admin/login/?next=/admin/
明☆
应用zabbix-apiCanlIUseiview组件IElement
Django administration
Username:
Password:
Login
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
博客
×|别离开我啊，小老弟，点回来～
Site administration|Django sitX
↑→C
127.0.0.1:8000/admin/
应用zabbix-apiCanlIUseiview组件|Element
Djangoadministration
WELCOMEZLS.VIEWSITE/CHANGEPASSWORD/LOGOUT
Siteadministration
AUTHENTICATIONANDAUTHORIZATION
Recent actions
Groups
+Add
Change
Myactions
None available
曾老湿
<!-- OCR_END -->

￼

将页面设置为中文`settings.py`

```plain
LANGUAGE_CODE = 'zh-hans'
```

<!-- OCR_START -->
- 博客
- ×别离开我啊，小老弟，点回来～
- 站点管理IDjango站点管理员x
- →C
- 127.0.0.1:8000/admin/
- 应用zabbix-api
- CanlUseiview组件IElement
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 站点管理
- 认证和授权
- 最近动作
- +增加
- 修改
- 我的动作
- 无可用的
- 曾老湿
<!-- OCR_END -->

￼

把数据库的表模型，注册到admin页面上`admin.py`

```plain
from django.contrib import admin
from blog import models
# Register your models here.
admin.site.register(models.UserInfo)
admin.site.register(models.Blog)
admin.site.register(models.Article)
admin.site.register(models.Tag)
admin.site.register(models.Category)
admin.site.register(models.Commit)
admin.site.register(models.UpAndDown)
```

<!-- OCR_START -->
- 登录页面
- ×别离开我啊，小老弟，点回来~
- 站点管理IDjango站点管理员x
- →C
- 127.0.0.1:8000/admin/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 站点管理
- BLOG
- 最近动作
- Articles
- +增加
- 修改
- Blogs
- 我的动作
- Categorys
- 无可用的
- Commits
- Tags
- Upanddowns
- 用户
- 认证和授权
- 曾老湿
<!-- OCR_END -->

￼

把表名变成中文

```plain
from django.db import models
from django.contrib.auth.models import AbstractUser
# Create your models here.
## UserInfo这个表 要继承AbstractUser，因为要用auth组件
class UserInfo(AbstractUser):
    nid = models.AutoField(primary_key=True)
    phone = models.CharField(max_length=32, null=True)
    ## 这个需要传一个路径
    avatar = models.FileField(upload_to='avatar/', default='/static/img/default.png')
    blog = models.OneToOneField(to='Blog', to_field='nid',null=True)
    class Meta:
        verbose_name = '用户表'
        verbose_name_plural = verbose_name
class Blog(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    sit_name = models.CharField(max_length=32)
    theme = models.CharField(max_length=64)
    class Meta:
        verbose_name = '博客表'
        verbose_name_plural = verbose_name
class Category(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    blog = models.ForeignKey(to='Blog', to_field='nid', null=True)
    class Meta:
        verbose_name = '分类表'
        verbose_name_plural = verbose_name
class Tag(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    blog = models.ForeignKey(to='Blog', to_field='nid', null=True)
    class Meta:
        verbose_name = '标签表'
        verbose_name_plural = verbose_name
class Article(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    desc = models.CharField(max_length=255)
    content = models.TextField()
    create_time = models.DateTimeField(auto_now_add=True)
    blog = models.ForeignKey(to='Blog', to_field='nid', null=True)
    category = models.ForeignKey(to='Category', to_field='nid', null=True)
    tag = models.ManyToManyField(to='Tag', through='ArticleToTag', through_fields=('article', 'tag'))
    class Meta:
        verbose_name = '文章表'
        verbose_name_plural = verbose_name
## 手动创建第三张表
class ArticleToTag(models.Model):
    nid = models.AutoField(primary_key=True)
    article = models.ForeignKey(to='Article', to_field='nid')
    tag = models.ForeignKey(to='Tag', to_field='nid')
class Commit(models.Model):
    nid = models.AutoField(primary_key=True)
    user = models.ForeignKey(to='UserInfo', to_field='nid')
    article = models.ForeignKey(to='Article', to_field='nid')
    content = models.CharField(max_length=255)
    create_time = models.DateTimeField(auto_now_add=True)
    ## 自己关联自己：方法一
    parent_id = models.ForeignKey(to='self', to_field='nid')
    ## 自己关联自己：方法二
    # parent_id = models.ForeignKey(to='Commit',to_field='nid')
    class Meta:
        verbose_name = '评论表'
        verbose_name_plural = verbose_name
class UpAndDown(models.Model):
    nid = models.AutoField(primary_key=True)
    user = models.ForeignKey(to='UserInfo', to_field='nid')
    article = models.ForeignKey(to='Article', to_field='nid')
    is_up = models.BooleanField()
    ## user和 article不允许一个作者，给一个文章点多个赞,做联合唯一。
    class Meta:
        ## 做这个只是为了不写脏数据，但是效率低，工作中不写也OK
        unique_together = (('user', 'article'),)
        verbose_name = '点赞表'
        verbose_name_plural = verbose_name
```

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来～
- 站点管理IDjango站点管理员x
- ←→C
- 127.0.0.1:8000/admin/
- 9
- 应用zabbix-api
- CanIUseiview组件|Element
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 站点管理
- BLOG
- 最近动作
- 分类表
- +增加
- 修改
- 博客表
- 我的动作
- 文章表
- 无可用的
- 标签表
- 点赞表
- 用户表
- 评论表
- 认证和授权
- +增加修改
- 曾老湿
<!-- OCR_END -->

￼

添加数据

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来～
- 增加文章表|Django站点管理X
- 增加博客表|Django站点管理×
- →C
- 127.0.0.1:8000/admin/blog/article/add/
- 应用zabbix-api
- CanIUseiview组件|Element
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 首页Blog，文章表，增加文章表
- 增加文章表
- Title:
- 深入浅出~
- Desc:
- 这里是文章描述15字，15字，15字，15字，1
- Content:
- Blog:
- Category.
- 保存并增加另一
- 保存并继续编辑
- 保存
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来～
- 增加文章表|Django站点管理x
- 增加博客表|Django站点管理×
- 127.0.0.1:8000/admin/blog/blog/add/?_to_field=nid&_popup=1
- 应用zabbix-api
- CanIUseiview组件|Element
- 增加博客表
- Title:
- 这里是博客站点的标题
- Sit name:
- 老司机带你删库跑路
- Theme:
- zls.css
- 保存
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来～
- 增加文章表|Django站点管理x
- ←→C
- 127.0.0.1:8000/admin/blog/article/add/
- 应用zabbix-apiCanlUseiview组件|Element
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 首页Blog，文章表增加文章表
- 增加文章表
- Title:
- 深入浅出~
- Desc:
- 这里是文章描述15字，15字，15字，15字，1
- Content:
- Blog:
- 老司机带你删库跑路
- Category.
- 保存并增加另一个
- 保存并继续编辑
- 保存
- 曾老湿
<!-- OCR_END -->

￼

作者表需要跟blog进行关联

<!-- OCR_START -->
- 登录页面
- ×别离开我啊，小老弟，点回来~
- 增加文章表|Django站点管理×
- 修改用户表|Django站点管理×
- 0127.0.0.1:8000/admin/blog/userinfo/1/change/
- 应用
- CanIUseiview组件|Element
- a口芯比求TCauereteogemuy
- auth|组|Can add group
- auth|组|Canchangegroup
- auth|组|Candeletegroup
- auth|权限|Canaddpermission
- uthI权胞ICan
- 为该用户声明权限。按住“Control，或者Mac上的“Command"，可以选择多个。
- 用户名：
- zls
- 必填。150个字符或者更少。包含字母，数字和仅有的@//+/-/_符号。
- 名字：
- 姓氏：
- 电子邮件地址：
- 133@qq.com
- 职员状态
- 指明用户是否可以登录到这个管理站点。
- 有效
- 指明用户是否被认为活跃的。以反选代替删除账号。
- 加入日期：
- 日期：
- 2020/06/21
- 今天曲
- 时间：
- 现在|
- 注意：
- 超前8个小时。
- Phone:
- 13300000000
- Avatar.
- 目前：/static/img/default.png
- 修改：选择文件未选择任何文件
- Blog:
- 老司机带你删库跑路
- 删除
- 保存并增加另一个
- 保存并继续编辑
- 保存
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- ×别离开我啊，小老弟，点回来～
- 增加文章表|Django站点管理x
- 增加分类表|Django站点管理
- 127.0.0.1:8000/admin/blog/category/add/?_to_field=nid&_popup=1
- 应用zabbix-api
- CanIUseiview组件IElement
- 增加分类表
- Title:
- zls的分类1
- Blog:
- 老司机带你删库跑路
- 保存
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- ×别离开我啊，小老弟，点回来～
- 增加文章表|Django站点管理x
- →C
- 127.0.0.1:8000/admin/blog/article/add/
- 应用zabbix-apiCanlUseiview组件IElement
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 首页Blog文章表增加文章表
- 增加文章表
- Title:
- 深入浅出~
- Desc:
- 这里是文章描述15字，15字，15字，15字，1
- Content:
- Blog:
- 老司机带你删库跑路
- Category.
- zls的分类1
- 保存并增加另一
- 保存并继续编辑
- 保存
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 登录页面
- 别离开我啊，小老弟，点回来～
- 选择文章表来修改|Django站
- →C
- 127.0.0.1:8000/admin/blog/article/
- 9
- 应用zabbix-api
- CanIUseiview组件|Element
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 首页，Blog文章表
- 选择文章表来修改
- 增加文章表
- 动作
- 执行
- 1个中0个被选
- 文章表
- 深入浅出~
- 1文章表
- 曾老湿
<!-- OCR_END -->

￼

多添加几篇文章

<!-- OCR_START -->
- 博客
- ×别离开我啊，小老弟，点回来～
- 增加文章表|Django站点管理x
- 127.0.0.1:8000/admin/blog/article/add/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 首页Blog，文章表，增加文章表
- 增加文章表
- Title:
- Golang简易入门教程--面向对象篇
- Desc:
- 本文始发于个人公众号：TechFlow，原创不易
- Content:
- Blog:
- 老司机带你删库跑路
- Category.
- zls的分类1
- 保存并增加另一
- 保存并继续编辑
- 保存
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 博客
- ×别离开我啊，小老弟，点回来～
- 增加文章表|Django站点管理x
- 127.0.0.1:8000/admin/blog/article/add/
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 首页Blog文章表增加文章表
- 增加文章表
- Title:
- 手摸手带你理解Vue响应式原理
- Desc:
- 前言响应式原理作为Vue的核心，使用数据去
- Content:
- Blog:
- 老司机带你删库跑路
- Category.
- zls的分类2
- 保存并增加另一个
- 保存并继续编辑
- 保存
- 曾老湿
<!-- OCR_END -->

￼

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">曾老湿博客系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">文章<span class="sr-only">(current)</span></a></li>
                    <li><a href="#">随笔</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    {% if request.user.is_authenticated %}
                        <li><a href="#">{{ request.user.username }}</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                               aria-haspopup="true"
                               aria-expanded="false">个人中心<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="#">修改密码</a></li>
                                <li><a href="#">修改头像</a></li>
                                <li><a href="#">修改主题</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="/logout/">注销</a></li>
                            </ul>
                        </li>
                    {% else %}
                        <li><a href="/login/">登录</a></li>
                        <li><a href="/register/">注册</a></li>
                    {% endif %}
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2">
            <div class="panel panel-danger">
                <div class="panel-heading">重金求子</div>
                <div class="panel-body">
                    <p>请联系：13800000000</p>
                    <p>年入60w</p>
                </div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">草榴社区</div>
                <div class="panel-body">
                    <a href="http://www.driverzeng.com">请点击跳转</a>
                </div>
            </div>
        </div>
        <div class="col-md-7">
            {% for article in article_list %}
                <div>
                    <h3><a href="">{{ article.title }}</a></h3>
                    <div class="media">
                        <div class="media-left">
                            <a href="#">
                                
                            </a>
                        </div>
                        <div class="media-body">
                            {{ article.desc }}
                        </div>
                    </div>
                </div>
            {% endfor %}
        </div>
        <div class="col-md-3">
            <div class="panel panel-success">
                <div class="panel-heading">日韩系列</div>
                <div class="panel-body">
                    <a href="http://download.driverzeng.com">Tokyo Hot</a>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">欧美系列</div>
                <div class="panel-body">
                    <a href="http://blog.driverzeng.com">金八天国</a>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">动漫卡通</div>
                <div class="panel-body">
                    <a href="http://pikachu.driverzeng.com">女仆</a>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">精品图区</div>
                <div class="panel-body">
                    <a href="http://taiji.driverzeng.com">美腿丝袜</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 博客
- 别离开我啊，小老弟，点回来~
- ×选择文章表来修改|Django站×
- 127.0.0.1:8000/index/
- 应用zabbix-api
- CanlIUse
- iview
- 组件|Element
- 曾老湿博客系统
- 文章
- 随笔
- zls
- 个人中心
- 重金求子
- 深入浅出～
- 日韩系列
- 请联系：13800000000
- 这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
- TokyoHot
- 年入60w
- Golang简易入门教程一一面向对象篇
- 欧美系列
- 草榴社区
- 本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现
- 金八天国
- 在高级语言当中，面向对象几乎是不可或缺也是一门语言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但
- 请点击跳转
- 是golang当...
- 手摸手带你理解Vue响应式原理
- 动漫卡通
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析
- 女仆
- 响应式原理的工作流程，主要以下面结构进行：分析主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体
- 流程文章稍长，但大部分是代码实
- 精品图区
- 美腿丝袜
- 曾老湿
<!-- OCR_END -->

￼

## 评论点赞处理

***

| 添底部作者信息及发布时间 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">曾老湿博客系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">文章<span class="sr-only">(current)</span></a></li>
                    <li><a href="#">随笔</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    {% if request.user.is_authenticated %}
                        <li><a href="#">{{ request.user.username }}</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                               aria-haspopup="true"
                               aria-expanded="false">个人中心<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="#">修改密码</a></li>
                                <li><a href="#">修改头像</a></li>
                                <li><a href="#">修改主题</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="/logout/">注销</a></li>
                            </ul>
                        </li>
                    {% else %}
                        <li><a href="/login/">登录</a></li>
                        <li><a href="/register/">注册</a></li>
                    {% endif %}
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2">
            <div class="panel panel-danger">
                <div class="panel-heading">重金求子</div>
                <div class="panel-body">
                    <p>请联系：13800000000</p>
                    <p>年入60w</p>
                </div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">草榴社区</div>
                <div class="panel-body">
                    <a href="http://www.driverzeng.com">请点击跳转</a>
                </div>
            </div>
        </div>
        <div class="col-md-7">
            {% for article in article_list %}
                <div>
                    <h4><a href="">{{ article.title }}</a></h4>
                    <div class="media">
                        <div class="media-left">
                            <a href="#">
                                
                            </a>
                        </div>
                        <div class="media-body">
                            {{ article.desc }}
                        </div>
                    </div>
                    <div>
                        <span><a href="">{{ article.blog.userinfo.username }}</a></span>
                        <span>发布于{{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                    </div>
                </div>
            {% endfor %}
        </div>
        <div class="col-md-3">
            <div class="panel panel-success">
                <div class="panel-heading">日韩系列</div>
                <div class="panel-body">
                    <a href="http://download.driverzeng.com">Tokyo Hot</a>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">欧美系列</div>
                <div class="panel-body">
                    <a href="http://blog.driverzeng.com">金八天国</a>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">动漫卡通</div>
                <div class="panel-body">
                    <a href="http://pikachu.driverzeng.com">女仆</a>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">精品图区</div>
                <div class="panel-body">
                    <a href="http://taiji.driverzeng.com">美腿丝袜</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 博客
- 选择文章表来修改|Django站×
- 127.0.0.1:8000/index/
- 应用zabbix-api
- CanIUse
- iview
- 组件|Element
- 曾老湿博客系统
- 文章
- 随笔
- zls
- 个人中心
- 重金求子
- 深入浅出~
- 日韩系列
- 这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
- 请联系：13800000000
- Tokyo Hot
- 年入60w
- zls发布于2020-06-2202:55:42
- Golang简易入门教程一一面向对象篇
- 欧美系列
- 本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现
- 草榴社区
- 在高级语言当中，面向对象几乎是不可或缺也是一门语言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但
- 金八天国
- 是golang当...
- 请点击跳转
- zls发布于2020-06-2203:08:19
- 手摸手带你理解Vue响应式原理
- 动漫卡通
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析
- 响应式原理的工作流程，主要以下面结构进行：分析主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体
- 女仆
- 流程文章稍长，但大部分是代码实
- zls发布于2020-06-2203:09:09
- 精品图区
- 美腿丝袜
- 曾老湿
<!-- OCR_END -->

￼

***

| 修改时区问题 |
| :--- |

```plain
TIME_ZONE = 'Asia/Shanghai'
```

<!-- OCR_START -->
- 博客
- 选择文章表来修改|Django站×
- 127.0.0.1:8000/index/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾老湿博客系统
- 文章
- 随笔
- zls
- 个人中心
- 重金求子
- 深入浅出~
- 日韩系列
- 这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
- 请联系：13800000000
- TokyoHot
- 年入60w
- zls发布于2020-06-2210:55:42
- Golang简易入门教程一一面向对象篇
- 欧美系列
- 本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现
- 草榴社区
- 在高级语言当中，面向对象几乎是不可或缺也是一门语言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但
- 金八天国
- 是golang当...
- 请点击跳转
- zls发布于2020-06-2211:08:19
- 手摸手带你理解Vue响应式原理
- 动漫卡通
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析
- 响应式原理的工作流程，主要以下面结构进行：分析主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体
- 女仆
- 流程文章稍长，但大部分是代码实
- zls发布于2020-06-2211:09:09
- 精品图区
- 美腿丝袜
- 曾老湿
<!-- OCR_END -->

￼

***

| 添加评论和点赞 |
| :--- |

字段修改

```plain
class Article(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=64)
    desc = models.CharField(max_length=255)
    content = models.TextField()
    create_time = models.DateTimeField(auto_now_add=True)
    ## 评论数
    commit_num = models.IntegerField(default=0)
    ## 点赞数
    up_num = models.IntegerField(default=0)
    ## 点踩数
    down_num = models.IntegerField(default=0)
    blog = models.ForeignKey(to='Blog', to_field='nid', null=True)
    category = models.ForeignKey(to='Category', to_field='nid', null=True)
    tag = models.ManyToManyField(to='Tag', through='ArticleToTag', through_fields=('article', 'tag'))
    class Meta:
        verbose_name = '文章表'
        verbose_name_plural = verbose_name
    def __str__(self):
        return self.title
```

数据迁移

```plain
MacBook-pro:bbs driverzeng$ python3 manage.py makemigrations
MacBook-pro:bbs driverzeng$ python3 manage.py migrate
```

添加几条评论

<!-- OCR_START -->
- 博客
- 增加评论表|Django站点管理×
- ←→C
- 127.0.0.1:8000/admin/blog/commit/add/
- 应用zabbix-api
- CanlUseiview组件|Element
- Django管理
- 欢迎，ZLS.查看站点/修改密码/注销
- 首页，Blog，评论表，增加评论表
- 增加评论表
- User.
- zls1
- Article:
- 深入浅出~
- Content:
- 写的秒啊~~
- Parent id:
- 保存并增加另一个
- 保存并继续编辑
- 保存
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 博客
- 增加评论表|Django站点管理×
- ←→C
- 127.0.0.1:8000/admin/blog/commit/add/
- 应用zabbix-apiCanlUseiview组件|Element
- Django管理
- 欢迎.ZLS.查看站点/修改密码/注销
- 首页，Blog评论表，增加评论表
- 增加评论表
- User.
- alin
- Article:
- 深入浅出~
- Content:
- 牛逼牛逼，大佬大佬。
- Parentid:
- 保存并增加另一个
- 保存并继续编辑
- 保存
- 曾老湿
<!-- OCR_END -->

￼

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <style>
        .bottom span{
            margin-right: 16px;
        }
    </style>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">曾老湿博客系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">文章<span class="sr-only">(current)</span></a></li>
                    <li><a href="#">随笔</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    {% if request.user.is_authenticated %}
                        <li><a href="#">{{ request.user.username }}</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                               aria-haspopup="true"
                               aria-expanded="false">个人中心<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="#">修改密码</a></li>
                                <li><a href="#">修改头像</a></li>
                                <li><a href="#">修改主题</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="/logout/">注销</a></li>
                            </ul>
                        </li>
                    {% else %}
                        <li><a href="/login/">登录</a></li>
                        <li><a href="/register/">注册</a></li>
                    {% endif %}
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2">
            <div class="panel panel-danger">
                <div class="panel-heading">重金求子</div>
                <div class="panel-body">
                    <p>请联系：13800000000</p>
                    <p>年入60w</p>
                </div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">草榴社区</div>
                <div class="panel-body">
                    <a href="http://www.driverzeng.com">请点击跳转</a>
                </div>
            </div>
        </div>
        <div class="col-md-7">
            {% for article in article_list %}
                <div>
                    <h4><a href="">{{ article.title }}</a></h4>
                    <div class="media">
                        <div class="media-left">
                            <a href="#">
                                
                            </a>
                        </div>
                        <div class="media-body">
                            {{ article.desc }}
                        </div>
                    </div>
                    <div style="margin-top: 20px;margin-bottom: 30px" class="bottom">
                        <span><a href="">{{ article.blog.userinfo.username }}</a></span>
                        <span>发布于{{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        <span class="glyphicon glyphicon-comment"><a href="" style="margin-left: 2px">评论({{ article.commit_num }})</a></span>
                        <span class="glyphicon glyphicon-thumbs-up"><a href="" style="margin-left: 2px">点赞({{ article.up_num}})</a></span>
                    </div>
                </div>
            {% endfor %}
        </div>
        <div class="col-md-3">
            <div class="panel panel-success">
                <div class="panel-heading">日韩系列</div>
                <div class="panel-body">
                    <a href="http://download.driverzeng.com">Tokyo Hot</a>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">欧美系列</div>
                <div class="panel-body">
                    <a href="http://blog.driverzeng.com">金八天国</a>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">动漫卡通</div>
                <div class="panel-body">
                    <a href="http://pikachu.driverzeng.com">女仆</a>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">精品图区</div>
                <div class="panel-body">
                    <a href="http://taiji.driverzeng.com">美腿丝袜</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
博客
Blog管理|Django站点管理员×
127.0.0.1:8000/index/
应用zabbix-api
CanlUseiview组件IElement
曾老湿博客系统
文章
随笔
zls
个人中心
重金求子
深入浅出～
日韩系列
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
请联系：13800000000
TokyoHot
年入60w
发布于2020-06-2210:55:42
评论（2）
点赞（0）
欧美系列
Golang简易入门教程一一面向对象篇
草榴社区
金八天国
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现
请点击跳转
在高级语言当中，面向对象几乎是不可或缺也是一门语言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但
是golang当...
动漫卡通
发布于2020-06-2211:08:19评论（0）点赞（0）
女仆
手摸手带你理解Vue响应式原理
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析
精品图区
响应式原理的工作流程，主要以下面结构进行：分析主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体
流程文章稍长，但大部分是代码实…
美腿丝袜
Zls发布于2020-06-2211:09:09评论（0）点赞（0）
曾老湿
<!-- OCR_END -->

￼

## 显示头像

***

| 配置头像上传路径 |
| :--- |

settings.py

```plain
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR,'media')
```

测试注册用户上传图片

<!-- OCR_START -->
- 注册页面
- Blog管理|Django站点管理员×
- →C
- 127.0.0.1:8000/register/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 登录
- 用户名
- zls666
- 密码
- ***
- 确认密码
- 邮箱
- 123@qq.com
- 头像
- 注册
- 曾老湿
<!-- OCR_END -->

￼

因为数据库创建字段的时候，写的`upload_to='avatar/'`，所以会在media目录下创建一个avatar目录，然后把图像上传进去，并且，media目录也不需要咱们手动创建，会自动创建。

<!-- OCR_START -->
- bbsbbs
- settings.py
- djbbs
- Project
- views.py
- admin.py
- index.html
- login.html
- models.py
- register.html
- urls.py
- myforms.py
- 118
- apps.py
- 119
- #TIME_ZONE=‘UTC
- 120
- TIME_ZONE='Asia/Shanghai'
- 121
- 122
- USE_I18N=True
- tests.py
- 123
- 124
- USE_L10N=True
- media
- 125
- avatar
- 126
- USE_TZ=True
- 127
- touxiang.jpeg
- 128
- static
- 129
- #Staticfiles（css,JavaScript，Images）
- font
- 130
- #https://docs.djangoproject.com/en/1.11/howto/static-files/
- img
- 131
- 1.jpg
- 132
- STATIC_URL=/static/
- bgjpg
- 133
- 134
- STATICFILES_DIRS=[
- bg1.jpg
- 135
- os.path.join（BASE_DIR'static')
- default.png
- 136
- templates
- 137
- 138
- AUTH_USER_MODEL='bLog.UserInfo
- 139
- 140
- MEDIA_URL=/media/
- 141
- MEDIA_ROOT=os.path.join（BASE_DIR,‘media')
- manage.py
- Ill External Libraries
- Scratches and Consoles
- 曾老湿
<!-- OCR_END -->

￼

***

| 在页面显示图片 |
| :--- |

首先配置路由：

创建有名分组

1.url第一个参数，正则表达式

2.第二个参数，函数的内存地址

3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)

4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对

**settings.py**

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
]
```

**models.py**

```plain
class UserInfo(AbstractUser):
    nid = models.AutoField(primary_key=True)
    phone = models.CharField(max_length=32, null=True)
    ## 这个需要传一个路径
    avatar = models.FileField(upload_to='avatar/', default='avatar/default.png')
    blog = models.OneToOneField(to='Blog', to_field='nid',null=True)
    class Meta:
        verbose_name = '用户表'
        verbose_name_plural = verbose_name
```

**数据库迁移**

```plain
MacBook-pro:bbs driverzeng$ python3 manage.py makemigrations
MacBook-pro:bbs driverzeng$ python3 manage.py migrate
```

**模板层页面**

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <style>
        .bottom span {
            margin-right: 16px;
        }
    </style>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">曾老湿博客系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">文章<span class="sr-only">(current)</span></a></li>
                    <li><a href="#">随笔</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    {% if request.user.is_authenticated %}
                        <li><a href="#">{{ request.user.username }}</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                               aria-haspopup="true"
                               aria-expanded="false">个人中心<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="#">修改密码</a></li>
                                <li><a href="#">修改头像</a></li>
                                <li><a href="#">修改主题</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="/logout/">注销</a></li>
                            </ul>
                        </li>
                    {% else %}
                        <li><a href="/login/">登录</a></li>
                        <li><a href="/register/">注册</a></li>
                    {% endif %}
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2">
            <div class="panel panel-danger">
                <div class="panel-heading">重金求子</div>
                <div class="panel-body">
                    <p>请联系：13800000000</p>
                    <p>年入60w</p>
                </div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">草榴社区</div>
                <div class="panel-body">
                    <a href="http://www.driverzeng.com">请点击跳转</a>
                </div>
            </div>
        </div>
        <div class="col-md-7">
            {% for article in article_list %}
                <div>
                    <h4><a href="">{{ article.title }}</a></h4>
                    <div class="media">
                        <div class="media-left">
                            <a href="#">
                                
                            </a>
                        </div>
                        <div class="media-body">
                            {{ article.desc }}
                        </div>
                    </div>
                    <div style="margin-top: 20px;margin-bottom: 30px" class="bottom">
                        <span><a href="">{{ article.blog.userinfo.username }}</a></span>
                        <span>发布于{{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        <span class="glyphicon glyphicon-comment"><a href=""
                                                                     style="margin-left: 2px">评论({{ article.commit_num }})</a></span>
                        <span class="glyphicon glyphicon-thumbs-up"><a href=""
                                                                       style="margin-left: 2px">点赞({{ article.up_num }})</a></span>
                    </div>
                </div>
            {% endfor %}
        </div>
        <div class="col-md-3">
            <div class="panel panel-success">
                <div class="panel-heading">日韩系列</div>
                <div class="panel-body">
                    <a href="http://download.driverzeng.com">Tokyo Hot</a>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">欧美系列</div>
                <div class="panel-body">
                    <a href="http://blog.driverzeng.com">金八天国</a>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">动漫卡通</div>
                <div class="panel-body">
                    <a href="http://pikachu.driverzeng.com">女仆</a>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">精品图区</div>
                <div class="panel-body">
                    <a href="http://taiji.driverzeng.com">美腿丝袜</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 博客
- Blog管理|Django站点管理员×
- 127.0.0.1:8000/index/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾老湿博客系统
- 文章
- 随笔
- 登录
- 注册
- 重金求子
- 深入浅出～
- 日韩系列
- 这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
- 请联系：13800000000
- TokyoHot
- 年入60w
- zls
- 发布于2020-06-2210:55:42
- 评论（2）点赞（0）
- 欧美系列
- 草榴社区
- Golang简易入门教程一一面向对象篇
- 金八天国
- 请点击跳转
- 本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在
- 现在高级语言当中，面向对象几乎是不可或缺也是一门语言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象
- 的，但是golang当.….
- 动漫卡通
- zls发布于2020-06-2211:08:19
- 评论（0）点赞（0）
- 女仆
- 手摸手带你理解Vue响应式原理
- 精品图区
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解
- 析响应式原理的工作流程，主要以下面结构进行：分析主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解
- 美腿丝袜
- 整体流程文章稍长，但大部分是代码实
- 发布于2020-06-2211:09:09评论（0）点赞（0）
- 曾老湿
<!-- OCR_END -->

￼

## 个人站点

***

| 路由设计 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)', views.user_blog),
]
```

***

| 视图设计 |
| :--- |

```plain
def user_blog(request, username):
    print(username)
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    return render(request, 'user_blog.html', locals())
```

***

| 模板层 |
| :--- |

error.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>404错误</title>
</head>
<body>
<a href="http://www.cnblogs.com/"><img src="//static.cnblogs.com/images/logo_small.gif" alt="cnblogs"></a>
<p class="d">请确认您输入的网址是否正确，如果问题持续存在，请发邮件至contact@cnblogs.com与我们联系。</p>
<p><b>404.</b> 抱歉! 您访问的资源不存在!</p><p><a href="http://www.cnblogs.com/">返回网站首页</a></p>
</body>
</html>
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-primary">
                <div class="panel-heading">我的标签</div>
                <div class="panel-body">
                   {% for foo in tag_num %}
                   <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                   {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">我的分类</div>
                <div class="panel-body">
                    {% for foo in category_num %}
                        <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">随笔档案</div>
                <div class="panel-body">
                    {% for foo in y_m_num %}
                    <p><a href="">{{ foo.0|date:"Y-m" }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
        </div>
        <div class="col-md-9">
            {#通过站点查询所有文章,反向查询,按表名小写_set.all#}
            {% for article in blog.article_set.all %}
                <div>
                <h4><a href="">{{ article.title }}</a></h4>
                <div class="media">
                    <div>
                        {{ article.desc }}
                    </div>
                    <div style="margin-top: 10px " class="article_bottom small">
                        <span>posted @ {{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        {#反向查询,一对多,按表名小写_set#}
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span>{{ article.blog.userinfo.username }}</span>
                        <span><i class="fa fa-comment" aria-hidden="true"><a
                                href="">评论({{ article.commit_num }})</a></i></span>
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span class="glyphicon glyphicon-thumbs-up"><a href="">点赞({{ article.up_num }})</a></span>
                        <span><a href="">编辑</a></span>
                    </div>
                    <hr>
                </div>
            {% endfor %}
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
zls-的个人博客
xBlog管理|Django站点管理员×+
→C127.0.0.1:8000/zls
应用zabbix-apiCanlUseiview组件|Element
这里是博客站点的标题
我的标签
深入浅出~
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
posted@2020-06-2210:55:42zls评论(2)点赞（0）编辑
我的分类
Golang简易入门教程一一面向对象篇
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现在高级语言当中，面向对象几乎是不可或缺也是一门语
随笔档案
言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但是golang当..
posted@2020-06-2211:08:19zls评论(0)点赞（0）编辑
手摸手带你理解Vue响应式原理
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
posted@2020-06-2211:09:09zls评论(0)点赞（0）编辑
曾老湿
<!-- OCR_END -->

￼

***

| 添加分类 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-primary">
                <div class="panel-heading">我的标签</div>
                <div class="panel-body">
                   {% for foo in tag_num %}
                   <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                   {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">我的分类</div>
                <div class="panel-body">
                    {% for foo in category_num %}
                        <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">随笔档案</div>
                <div class="panel-body">
                    {% for foo in y_m_num %}
                    <p><a href="">{{ foo.0|date:"Y-m" }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
        </div>
        <div class="col-md-9">
            {#通过站点查询所有文章,反向查询,按表名小写_set.all#}
            {% for article in blog.article_set.all %}
                <div>
                <h4><a href="">{{ article.title }}</a></h4>
                <div class="media">
                    <div>
                        {{ article.desc }}
                    </div>
                    <div style="margin-top: 10px " class="article_bottom small">
                        <span>posted @ {{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        {#反向查询,一对多,按表名小写_set#}
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span>{{ article.blog.userinfo.username }}</span>
                        <span><i class="fa fa-comment" aria-hidden="true"><a
                                href="">评论({{ article.commit_num }})</a></i></span>
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span class="glyphicon glyphicon-thumbs-up"><a href="">点赞({{ article.up_num }})</a></span>
                        <span><a href="">编辑</a></span>
                    </div>
                    <hr>
                </div>
            {% endfor %}
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

```plain
def user_blog(request, username):
    print(username)
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    # 查询当前站点下所有的分类,对应的文章数
    # 每个的分类,对应的文章数
    #group by谁,就以谁做基表
    #ret=models.Category.objects.all().annotate(coun=Count('article__title')).values('title','coun')
    #filter在前表示where value在前表group by
    #value在后表示取值,fileter在后,表示having
    #先过滤出当前站点下所有的分类
    #ret=models.Category.objects.all().filter(blog=blog)
    #ret=models.Category.objects.all().filter(blog=blog).values('pk').annotate(coun=Count('article__title')).values('title','coun')
    #结果跟上面一样
    #ret=models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values('title','coun')
    category_num = models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title', 'coun')
    print(category_num)
    return render(request, 'user_blog.html', locals())
```

<!-- OCR_START -->
zls-的个人博客
Blog管理|Django站点管理员×博客园-开发者的网上家园
→C127.0.0.1:8000/zls
应用zabbix-api
CanIUseiview组件|Element
这里是博客站点的标题
我的标签
深入浅出～
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
posted@2020-06-2210:55:42zls评论(2)点赞（0）编辑
我的分类
zls的分类1(2)
Golang简易入门教程一一面向对象篇
zls的分类2（1)
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现在高级语言当中，面向对象几乎是不可或缺也是一门语
言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但是golang当…
posted@2020-06-2211:08:19zls评论(0)点赞（0）编辑
随笔档案
手摸手带你理解Vue响应式原理
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实..
posted@2020-06-2211:09:09 zls评论(0)点赞（0）编辑
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
alin1-的个人博客
Blog管理|Django站点管理员×丨博客园-开发者的网上家园
×+
→C127.0.0.1:8000/alin1
应用zabbix-apiCanIUseiview组件|Element
alin1
我的标签
C#数据结构与算法系列（十）：中缀表达式转后缀表达式
1.具体步骤1）初始化两个栈：运算符栈s1和储存中间结果的栈s2；2）从左至右扫描中缀表达式；3）遇到操作数时，将其压s2；4）遇到运算符时，比较其与s1栈顶运算符的优先级：（1）如果s1为
空，或栈顶运算符为左括号""，则直接将此运算符入栈；（2）否则，若优先级比栈顶运算符的高，也将运算符压
我的分类
posted@2020-06-2214:27:06alin1评论（0）点赞（0）编辑
alin(2)
说说TCP的三次握手和四次挥手
一、传输控制协议TCP简介1.1简介TCP（TransmissionControl Protocol）传输控制协议，是一种面向连接的、可靠的、基于字节流的传输层通信协议。TCP是一种面向连接（连接导向）的、可靠的
随笔档案
基于字节流的传输层通信协议。TCP将用户数据打包成报文段，它发送后启动一…
posted@2020-06-2214:27:27alin1评论(0）点赞（0）编辑
曾老湿
<!-- OCR_END -->

￼

***

| 添加标签 |
| :--- |

导入标签的第三张表

```plain
from django.contrib import admin
from blog import models
# Register your models here.
admin.site.register(models.UserInfo)
admin.site.register(models.Blog)
admin.site.register(models.Article)
admin.site.register(models.Tag)
admin.site.register(models.Category)
admin.site.register(models.Commit)
admin.site.register(models.UpAndDown)
admin.site.register(models.ArticleToTag)
```

**视图**

```plain
def user_blog(request, username):
    print(username)
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    # 查询当前站点下所有的分类,对应的文章数
    # 每个的分类,对应的文章数
    #group by谁,就以谁做基表
    #ret=models.Category.objects.all().annotate(coun=Count('article__title')).values('title','coun')
    #filter在前表示where value在前表group by
    #value在后表示取值,fileter在后,表示having
    #先过滤出当前站点下所有的分类
    #ret=models.Category.objects.all().filter(blog=blog)
    #ret=models.Category.objects.all().filter(blog=blog).values('pk').annotate(coun=Count('article__title')).values('title','coun')
    #结果跟上面一样
    #ret=models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values('title','coun')
    category_num = models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title', 'coun')
    print(category_num)
    # 查询当前站点下每个标签对应的文章数
    tag_num = models.Tag.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title','coun')
    print(tag_num)
    return render(request, 'user_blog.html', locals())
```

**模板**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-primary">
                <div class="panel-heading">我的标签</div>
                <div class="panel-body">
                   {% for foo in tag_num %}
                   <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                   {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">我的分类</div>
                <div class="panel-body">
                    {% for foo in category_num %}
                        <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">随笔档案</div>
                <div class="panel-body">
                    {% for foo in y_m_num %}
                    <p><a href="">{{ foo.0|date:"Y-m" }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
        </div>
        <div class="col-md-9">
            {#通过站点查询所有文章,反向查询,按表名小写_set.all#}
            {% for article in blog.article_set.all %}
                <div>
                <h4><a href="">{{ article.title }}</a></h4>
                <div class="media">
                    <div>
                        {{ article.desc }}
                    </div>
                    <div style="margin-top: 10px " class="article_bottom small">
                        <span>posted @ {{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        {#反向查询,一对多,按表名小写_set#}
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span>{{ article.blog.userinfo.username }}</span>
                        <span><i class="fa fa-comment" aria-hidden="true"><a
                                href="">评论({{ article.commit_num }})</a></i></span>
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span class="glyphicon glyphicon-thumbs-up"><a href="">点赞({{ article.up_num }})</a></span>
                        <span><a href="">编辑</a></span>
                    </div>
                    <hr>
                </div>
            {% endfor %}
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
alin1-的个人博客
Blog管理|Django站点管理员×|
→C127.0.0.1:8000/alin1
应用zabbix-api
CanlUseiview组件IElement
alin1
我的标签
C#数据结构与算法系列（十）：中缀表达式转后缀表达式
1.具体步骤1）初始化两个栈：运算符栈s1和储存中间结果的栈s2；2）从左至右扫描中缀表达式；3）遇到操作数时，将其压s2；4）遇到运算符时，比较其与s1栈顶运算符的优先级：（1）如果s1为
alin1的标签1(1)
空，或栈顶运算符为左括号""，则直接将此运算符入栈；（2）否则，若优先级比栈顶运算符的高，也将运算符压
alin1的标签2(1)
posted@2020-06-2214:27:06alin1评论(0)点赞（0)编辑
我的分类
说说TCP的三次握手和四次挥手
一、传输控制协议TCP简介1.1简介TCP（TransmissionControlProtocol）传输控制协议，是一种面向连接的、可靠的、基于字节流的传输层通信协议。TCP是一种面向连接（连接导向）的、可靠的
alin1(2)
基于字节流的传输层通信协议。TCP将用户数据打包成报文段，它发送后启动一…
posted@2020-06-2214:27:27alin1评论(0）点赞（0）编辑
随笔档案
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
zls-的个人博客
Blog管理|Django站点管理员×
←→C
127.0.0.1:8000/zls
9
应用zabbix-api
CanIUseiview
组件|Element
这里是博客站点的标题
我的标签
深入浅出～
zls的标签1(2)
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
zls的标签2(1)
posted@2020-06-2210:55:42zls评论(2)点赞（0）编辑
Golang简易入门教程一一面向对象篇
我的分类
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现在高级语言当中，面向对象几乎是不可或缺也是一门语
言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但是golang当
zls的分类1(2)
posted@2020-06-2211:08:19zls评论(0)点赞（0）编辑
zls的分类2（1)
手摸手带你理解Vue响应式原理
随笔档案
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
posted@2020-06-2211:09:09zls评论(0)点赞（0）编辑
曾老湿
<!-- OCR_END -->

￼

## 随笔档案

我们要来按日期归档。

<!-- OCR_START -->
- 随笔档案(276)
- 2020年6月（2）
- 2020年5月（1）
- 2020年4月（1）
- 2020年1月（1）
- 2019年10月（4）
- 2019年9月（1)
- 2019年4月（1）
- 2019年3月（1）
- 2019年2月（1）
- 2019年1月（2）
- 2018年5月（1）
- 2018年4月（1）
- 2017年11月（1）
- 2017年9月（1)
- 2017年6月（1）
- 2017年4月（1）
- 2017年2月（2）
- 2016年12月（1)
- 2016年11月（2）
- 2016年4月（3）
- 2016年3月（4)
- 2016年2月（2）
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

修改一下数据库的时间

<!-- OCR_START -->
- settings.py
- admin.py
- index.html
- models.py
- urls.py
- views.pyx
- user_blog.html
- bbs.blog_article[bbs@10
- Database
- 5rows
- Tx:Auto
- DB
- Tab-se...d(TSV)
- DDL
- ViewQuery
- GI
- Q<Filter criteria>
- 8-7
- bbs@10.0.0.511of8
- SC
- content
- blogid
- category_id
- commit
- schemas1
- 1文章描述15字，15字，15字，15字，15字，15字，155
- 2018-07-0302:55:42.391000
- 1
- bbs
- 2发于个人公众号：TechFLow，原创不易，求个关注
- 2018-07-2403:08:19.705000
- auth_group
- 3向应式原理作为Vue的核心，使用数据劫持实现数据.
- 2019-08-23 03:09:09.747000
- 2
- auth_group_permissions
- 步骤1）初始化两个栈：运算符栈s1和储存中间结果
- 2018-11-2406:27:06.447000
- 3
- 5
- auth_permission
- 曾老湿
- CP简介1.1简介TCP（Transmission
- 2019-08-2306:27:27.844000
- DriverZeng
- blog_article
<!-- OCR_END -->

￼

***

| 使用截断 |
| :--- |

```plain
'''
from django.db.models.functions import TruncMonth
Sales.objects
.annotate(month=TruncMonth('timestamp'))  # Truncate to month and add to select list
.values('month')  # Group By month
.annotate(c=Count('id'))  # Select the count of the grouping
.values('month', 'c')  # (might be redundant, haven't tested) select month and count
'''
## 截断函数
文章标题                时间            blog_id      month
文章1     2018-07-03 02:55:42.391000      1       2018-07
文章2     2018-07-24 03:08:19.705000      1       2018-07
文章3     2019-08-23 03:09:09.747000      1       2019-08
group by month
from django.db.models.functions import TruncMonth
y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values('y_m').annotate(coun=Count('y_m')).values('y_m', 'coun')
```

**修改时区 settings.py**

```plain
## 不用UTC时间
USE_TZ = False
```

**视图层**

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
def user_blog(request, username):
    print(username)
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    # 查询当前站点下所有的分类,对应的文章数
    # 每个的分类,对应的文章数
    #group by谁,就以谁做基表
    #ret=models.Category.objects.all().annotate(coun=Count('article__title')).values('title','coun')
    #filter在前表示where value在前表group by
    #value在后表示取值,fileter在后,表示having
    #先过滤出当前站点下所有的分类
    #ret=models.Category.objects.all().filter(blog=blog)
    #ret=models.Category.objects.all().filter(blog=blog).values('pk').annotate(coun=Count('article__title')).values('title','coun')
    #结果跟上面一样
    #ret=models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values('title','coun')
    category_num = models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title', 'coun')
    print(category_num)
    # 查询当前站点下每个标签对应的文章数
    tag_num = models.Tag.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title','coun')
    print(tag_num)
    '''
        from django.db.models.functions import TruncMonth
        Sales.objects
        .annotate(month=TruncMonth('timestamp'))  # Truncate to month and add to select list
        .values('month')  # Group By month
        .annotate(c=Count('id'))  # Select the count of the grouping
        .values('month', 'c')  # (might be redundant, haven't tested) select month and count
    '''
    # 查询当前站点下按年月分类的文章数
    from django.db.models.functions import TruncMonth
    # y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values('y_m').annotate(coun=Count('y_m')).values('y_m', 'coun')
    y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values('y_m').annotate(coun=Count('y_m')).values_list('y_m', 'coun')
    print(y_m_num)
    return render(request, 'user_blog.html', locals())
```

**模板层**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-primary">
                <div class="panel-heading">我的标签</div>
                <div class="panel-body">
                   {% for foo in tag_num %}
                   <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                   {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">我的分类</div>
                <div class="panel-body">
                    {% for foo in category_num %}
                        <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">随笔档案</div>
                <div class="panel-body">
                    {% for foo in y_m_num %}
                    <p><a href="">{{ foo.0|date:"Y-m" }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
        </div>
        <div class="col-md-9">
            {#通过站点查询所有文章,反向查询,按表名小写_set.all#}
            {% for article in blog.article_set.all %}
                <div>
                <h4><a href="">{{ article.title }}</a></h4>
                <div class="media">
                    <div>
                        {{ article.desc }}
                    </div>
                    <div style="margin-top: 10px " class="article_bottom small">
                        <span>posted @ {{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        {#反向查询,一对多,按表名小写_set#}
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span>{{ article.blog.userinfo.username }}</span>
                        <span><i class="fa fa-comment" aria-hidden="true"><a
                                href="">评论({{ article.commit_num }})</a></i></span>
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span class="glyphicon glyphicon-thumbs-up"><a href="">点赞({{ article.up_num }})</a></span>
                        <span><a href="">编辑</a></span>
                    </div>
                    <hr>
                </div>
            {% endfor %}
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
zls-的个人博客
Blog管理|Django站点管理员×|
博客园_百度搜索
博客园-开发者的网上家园
基于领域驱动设计（DDD）超轻量×|+
→C
127.0.0.1:8000/zls
9
应用zabbix-api
CanlUseiview
组件|Element
这里是博客站点的标题
我的标签
深入浅出～
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
zls的标签1（2）
posted@2018-07-0302:55:42zls评论（2）点赞（0）编辑
zls的标签2(1)
Golang简易入门教程一一面向对象篇
我的分类
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现在高级语言当中，面向对象几乎是不可或缺也是一门语
zls的分类1(2)
言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但是golang当.
posted@2018-07-2403:08:19zls评论(0)点赞（0）编辑
zls的分类2（1)
手摸手带你理解Vue响应式原理
随笔档案
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
2018-07(2)
posted@2019-08-2303:09:09zls评论(0)点赞（0）编辑
2019-08(1)
曾老湿
<!-- OCR_END -->

￼

改成中文的年月

```plain
<p><a href="">{{ foo.0|date:"Y年m月" }}({{ foo.1 }})</a></p>
```

<!-- OCR_START -->
zls-的个人博客
Blog管理|Django站点管理员×
→C127.0.0.1:8000/zls
应用zabbix-api
CanlUseiview
组件|Element
这里是博客站点的标题
我的标签
深入浅出～
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
zls的标签1(2)
posted@2018-07-0302:55:42zls评论(2)点赞（0）编辑
zls的标签2（1)
Golang简易入门教程一一面向对象篇
我的分类
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现在高级语言当中，面向对象几乎是不可或缺也是一门语
言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但是golang当…
zls的分类1(2)
posted@2018-07-2403:08:19zls评论(0)点赞（0）编辑
zls的分类2（1)
手摸手带你理解Vue响应式原理
随笔档案
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实.
2018年07月（2）
posted@2019-08-2303:09:09zls评论(0)点赞（0）编辑
2019年08月（1）
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
alin1-的个人博客
Blog管理|Django站点管理员×
→C127.0.0.1:8000/alin1
应用zabbix-api
CanIUse
iview组件|Element
alin1
我的标签
C#数据结构与算法系列（十）：中缀表达式转后缀表达式
1.具体步骤1）初始化两个栈：运算符栈s1和储存中间结果的栈s2；2）从左至右扫描中缀表达式；3）遇到操作数时，将其压s2；4）遇到运算符时，比较其与s1栈顶运算符的优先级：（1）如果s1为
alin1的标签1（1)
空，或栈顶运算符为左括号""，则直接将此运算符入栈：（2）否则，若优先级比栈顶运算符的高，也将运算符压
alin1的标签2（1)
posted@2018-11-2406:27:06alin1评论(0）点赞（0）编辑
我的分类
说说TCP的三次握手和四次挥手
一、传输控制协议TCP简介1.1简介TCP（TransmissionControlProtocol）传输控制协议，是一种面向连接的、可靠的、基于字节流的传输层通信协议。TCP是一种面向连接（连接导向）的、可靠的
alin1(2)
基于字节流的传输层通信协议。TCP将用户数据打包成报文段，它发送后启动一.
posted@2019-08-2306:27:27alin1评论(0）点赞（0）编辑
随笔档案
2018年11月（1）
2019年08月（1）
曾老湿
<!-- OCR_END -->

￼

底部放右侧

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-primary">
                <div class="panel-heading">我的标签</div>
                <div class="panel-body">
                    {% for foo in tag_num %}
                        <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">我的分类</div>
                <div class="panel-body">
                    {% for foo in category_num %}
                        <p><a href="">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">随笔档案</div>
                <div class="panel-body">
                    {% for foo in y_m_num %}
                        <p><a href="">{{ foo.0|date:"Y年m月" }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
        </div>
        <div class="col-md-9">
            {#通过站点查询所有文章,反向查询,按表名小写_set.all#}
            {% for article in blog.article_set.all %}
                <div>
                <h4><a href="">{{ article.title }}</a></h4>
                <div class="media">
                    <div>
                        {{ article.desc }}
                    </div>
                    <div class="clearfix">
                        <div style="margin-top: 10px " class="article_bottom small pull-right">
                            <span>posted @ {{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                            {#反向查询,一对多,按表名小写_set#}
                            {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                            <span>{{ article.blog.userinfo.username }}</span>
                            <span><i class="fa fa-comment" aria-hidden="true"><a
                                    href="">评论({{ article.commit_num }})</a></i></span>
                            {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                            <span class="glyphicon glyphicon-thumbs-up"><a href="">点赞({{ article.up_num }})</a></span>
                            <span><a href="">编辑</a></span>
                        </div>
                    </div>
                    <hr>
                </div>
            {% endfor %}
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
zls-的个人博客
Blog管理|Django站点管理员×|
别离开我啊，小老弟，点回来~
→C
127.0.0.1:8000/zls
应用zabbix-api
CanIUseiview组件|Element
这里是博客站点的标题
我的标签
深入浅出～
zls的标签1(2)
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
posted@2018-07-0302:55:42zls评论（2)点赞（0）编辑
zls的标签2（1)
Golang简易入门教程一一面向对象篇
我的分类
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现在高级语言当中，面向对象几乎是不可或缺也是一门语
言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但是golang当..
zls的分类1（2）
posted@2018-07-2403:08:19zls评论(0)点赞（0）编辑
zls的分类2（1)
手摸手带你理解Vue响应式原理
随笔档案
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
2018年07月（2）
posted@2019-08-2303:09:09 zls评论(0）点赞（0）编辑
2019年08月（1）
曾老湿
<!-- OCR_END -->

￼

## 个人站点分类过滤文章

***

| 路由设计 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点过滤
    url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)', views.user_blog),
]
```

***

| 视图函数 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
def user_blog(request, username,*args,**kwargs):
    print(username)
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    # 先取出category_id
    category_id =  kwargs.get('category_id',None)
    blog = user.blog
    ## 过滤这个人所有的文章
    article_list = blog.article_set.all()
    # 判断category_id，如果有值直接过滤
    if category_id:
        article_list = article_list.filter(category__pk=category_id)
    # 查询当前站点下所有的分类,对应的文章数
    # 每个的分类,对应的文章数
    #group by谁,就以谁做基表
    #ret=models.Category.objects.all().annotate(coun=Count('article__title')).values('title','coun')
    #filter在前表示where value在前表group by
    #value在后表示取值,fileter在后,表示having
    #先过滤出当前站点下所有的分类
    #ret=models.Category.objects.all().filter(blog=blog)
    #ret=models.Category.objects.all().filter(blog=blog).values('pk').annotate(coun=Count('article__title')).values('title','coun')
    #结果跟上面一样
    #ret=models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values('title','coun')
    category_num = models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title', 'coun')
    print(category_num)
    # 查询当前站点下每个标签对应的文章数
    tag_num = models.Tag.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title','coun')
    print(tag_num)
    '''
        from django.db.models.functions import TruncMonth
        Sales.objects
        .annotate(month=TruncMonth('timestamp'))  # Truncate to month and add to select list
        .values('month')  # Group By month
        .annotate(c=Count('id'))  # Select the count of the grouping
        .values('month', 'c')  # (might be redundant, haven't tested) select month and count
    '''
    # 查询当前站点下按年月分类的文章数
    from django.db.models.functions import TruncMonth
    # y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values('y_m').annotate(coun=Count('y_m')).values('y_m', 'coun')
    y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values('y_m').annotate(coun=Count('y_m')).values_list('y_m', 'coun')
    print(y_m_num)
    return render(request, 'user_blog.html', locals())
```

<!-- OCR_START -->
- zls-的个人博客
- Blog管理|Django站点管理员×
- ←→C
- 127.0.0.1:8000/zls/category/2
- 应用zabbix-api
- CanlUseiview组件|Element
- 这里是博客站点的标题
- 我的标签
- 手摸手带你理解Vue响应式原理
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
- zls的标签1(2)
- 主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
- zls的标签2（1)
- posted@2019-08-2303:09:09zls评论(o)点赞（0）编辑
- 我的分类
- zls的分类1(2)
- zls的分类2（1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

## 个人站点标签过滤文章(三合一)

***

| 路由设计 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)', views.user_blog),
]
```

***

| 视图设计 |
| :--- |

```plain
def user_blog(request, username,*args,**kwargs):
    print(username)
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    
    '''
    过滤分类
    '''
    # 先取出category_id
    category_id =  kwargs.get('category_id',None)
    blog = user.blog
    ## 过滤这个人所有的文章
    article_list = blog.article_set.all()
    # 判断category_id，如果有值直接过滤
    if category_id:
        article_list = article_list.filter(category__pk=category_id)
    '''
    过滤标签
    '''
    tag_id = kwargs.get('tag_id', None)
    blog = user.blog
    ## 过滤这个人所有的文章
    article_list = blog.article_set.all()
    # 判断category_id，如果有值直接过滤
    if tag_id:
        article_list = article_list.filter(category__pk=tag_id)
    # 查询当前站点下所有的分类,对应的文章数
    # 每个的分类,对应的文章数
    #group by谁,就以谁做基表
    #ret=models.Category.objects.all().annotate(coun=Count('article__title')).values('title','coun')
    #filter在前表示where value在前表group by
    #value在后表示取值,fileter在后,表示having
    #先过滤出当前站点下所有的分类
    #ret=models.Category.objects.all().filter(blog=blog)
    #ret=models.Category.objects.all().filter(blog=blog).values('pk').annotate(coun=Count('article__title')).values('title','coun')
    #结果跟上面一样
    #ret=models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values('title','coun')
    category_num = models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title', 'coun')
    print(category_num)
    # 查询当前站点下每个标签对应的文章数
    tag_num = models.Tag.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title','coun')
    print(tag_num)
    '''
        from django.db.models.functions import TruncMonth
        Sales.objects
        .annotate(month=TruncMonth('timestamp'))  # Truncate to month and add to select list
        .values('month')  # Group By month
        .annotate(c=Count('id'))  # Select the count of the grouping
        .values('month', 'c')  # (might be redundant, haven't tested) select month and count
    '''
    # 查询当前站点下按年月分类的文章数
    from django.db.models.functions import TruncMonth
    # y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values('y_m').annotate(coun=Count('y_m')).values('y_m', 'coun')
    y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values('y_m').annotate(coun=Count('y_m')).values_list('y_m', 'coun')
    print(y_m_num)
    return render(request, 'user_blog.html', locals())
```

会发现，路由和视图，代码基本差不多，就中间的字段不一样，所以我们来节省代码。包括随笔的过滤也是一样的，我们三合一

***

| 路由合并 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)$', views.user_blog),
]
```

***

| 视图合并 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
from django.db.models.functions import TruncMonth
def user_blog(request, username, *args, **kwargs):
    print(username)
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    article_list = blog.article_set.all()
    condition = kwargs.get('condition')
    param = kwargs.get('param')
    if condition == 'tag':
        article_list = article_list.filter(tag__pk=param)
    elif condition == 'category':
        article_list = article_list.filter(category__pk=param)
    elif condition == 'archive':
        archive_list = param.split('-')
        article_list = article_list.filter(create_time__year=archive_list[0], create_time__month=archive_list[1])
    category_num = models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list(
        'title', 'coun', 'pk')
    print(category_num)
    tag_num = models.Tag.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title',
                                                                                                            'coun',
                                                                                                            'pk')
    print(tag_num)
    y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values(
        'y_m').annotate(coun=Count('y_m')).values_list('y_m', 'coun')
    print(y_m_num)
    return render(request, 'user_blog.html', locals())
```

<!-- OCR_START -->
zls-的个人博客
Blog管理|Django站点管理员×|
别离开我啊，小老弟，点回来~
127.0.0.1:8000/zls/archive/2018-07
应用zabbix-api
CanIUseiview组件|Element
这里是博客站点的标题
我的标签
深入浅出～
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
zls的标签1(2)
zls的标签2(1)
posted@2018-07-0302:55:42zls评论（2）点赞（0）编辑
Golang简易入门教程一一面向对象篇
我的分类
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在现在高级语言当中，面向对象几乎是不可或缺也是一门语
言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象的，但是golang当…
zls的分类1(2)
posted@2018-07-2403:08:19zls评论(0)点赞（0）编辑
zls的分类2（1)
随笔档案
2018年07月（2）
2019年08月（1）
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- zls-的个人博客
- Blog管理|Django站点管理员×|
- 别离开我啊，小老弟，点回来
- 127.0.0.1:8000/zls/tag/1
- 应用zabbix-api
- CanlIUse
- iview组件IElement
- 这里是博客站点的标题
- 我的标签
- 深入浅出~
- 这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
- zls的标签1(2)
- posted@2018-07-0302:5542zls评论(2）点赞（0）编辑
- zls的标签2(1)
- 手摸手带你理解Vue响应式原理
- 我的分类
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
- 主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
- zls的分类1（2)
- posted@2019-08-2303:09:09zls评论(0）点赞（0）编辑
- zls的分类2（1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- zls-的个人博客
- Blog管理|Django站点管理员×|
- 别离开我啊，小老弟，点回来～
- →C127.0.0.1:8000/zls/category/2
- 应用zabbix-api
- CanIUse
- iview组件IElement
- 这里是博客站点的标题
- 我的标签
- 手摸手带你理解Vue响应式原理
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
- zls的标签1(2)
- 主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
- zls的标签2(1)
- posted@2019-08-2303:09:09zls评论(0)点赞（0）编辑
- 我的分类
- zls的分类1(2)
- zls的分类2(1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

## 修改点击跳转

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-primary">
                <div class="panel-heading">我的标签</div>
                <div class="panel-body">
                    {% for foo in tag_num %}
                        <p><a href="/{{ username }}/tag/{{ foo.2 }}">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">我的分类</div>
                <div class="panel-body">
                    {% for foo in category_num %}
                        <p><a href="/{{ username }}/category/{{ foo.2 }}">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">随笔档案</div>
                <div class="panel-body">
                    {% for foo in y_m_num %}
                        <p><a href="/{{ username }}/archive/{{ foo.0|date:"Y-m" }}">{{ foo.0|date:"Y年m月" }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
        </div>
        <div class="col-md-9">
            {#通过站点查询所有文章,反向查询,按表名小写_set.all#}
            {% for article in article_list %}
                <div>
                <h4><a href="">{{ article.title }}</a></h4>
                <div class="media">
                    <div>
                        {{ article.desc }}
                    </div>
                    <div class="clearfix">
                        <div style="margin-top: 10px " class="article_bottom small pull-right">
                            <span>posted @ {{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                            {#反向查询,一对多,按表名小写_set#}
                            {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                            <span>{{ article.blog.userinfo.username }}</span>
                            <span><i class="fa fa-comment" aria-hidden="true"><a
                                    href="">评论({{ article.commit_num }})</a></i></span>
                            {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                            <span class="glyphicon glyphicon-thumbs-up"><a href="">点赞({{ article.up_num }})</a></span>
                            <span><a href="">编辑</a></span>
                        </div>
                    </div>
                    <hr>
                </div>
            {% endfor %}
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

```plain
def user_blog(request, username, *args, **kwargs):
    print(username)
    username = username
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    article_list = blog.article_set.all()
    condition = kwargs.get('condition')
    param = kwargs.get('param')
    if condition == 'tag':
        article_list = article_list.filter(tag__pk=param)
    elif condition == 'category':
        article_list = article_list.filter(category__pk=param)
    elif condition == 'archive':
        archive_list = param.split('-')
        article_list = article_list.filter(create_time__year=archive_list[0], create_time__month=archive_list[1])
    category_num = models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list(
        'title', 'coun', 'pk')
    print(category_num)
    tag_num = models.Tag.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title',
                                                                                                            'coun',
                                                                                                            'pk')
    print(tag_num)
    from django.db.models.functions import TruncMonth
    y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values(
        'y_m').annotate(coun=Count('y_m')).values_list('y_m', 'coun')
    print(y_m_num)
    return render(request, 'user_blog.html', locals())
```

<!-- OCR_START -->
zls-的个人博客
Blog管理|Django站点管理员×|
别离开我啊，小老弟，点回来～
→C127.0.0.1:8000/zls/tag/1
应用zabbix-api
CanIUseiview组件IElement
这里是博客站点的标题
我的标签
深入浅出~
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
zls的标签1(2)
posted@2018-07-0302:55:42zls评论(2）点赞（0）编辑
zls的标签2(1)
手摸手带你理解Vue响应式原理
我的分类
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
zls的分类1(2)
主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
posted@2019-08-2303:09:09zls评论(0)点赞（0）编辑
zls的分类2（1)
随笔档案
2018年07月（2）
2019年08月（1）
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- zls-的个人博客
- Blog管理|Django站点管理员×|
- 别离开我啊，小老弟，点回来～
- →C
- 127.0.0.1:8000/zls/category/2
- 应用zabbix-api
- CanIUse
- iview
- 组件|Element
- 这里是博客站点的标题
- 我的标签
- 手摸手带你理解Vue响应式原理
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
- zls的标签1(2)
- 主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实
- zls的标签2（1)
- posted@2019-08-2303:09:09zls评论(0)点赞（0）编辑
- 我的分类
- zls的分类1(2)
- zls的分类2（1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- zls-的个人博客
- Blog管理|Django站点管理员×
- 别离开我啊，小老弟，点回来～
- ←→C
- 127.0.0.1:8000/zls/archive/2019-08
- 9
- 应用zabbix-api
- CanIUseiview组件IElement
- 这里是博客站点的标题
- 我的标签
- 手摸手带你理解Vue响应式原理
- 前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解析响应式原理的工作流程，主要以下面结构进行：分析
- zls的标签1（2）
- 主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解整体流程文章稍长，但大部分是代码实.
- zls的标签2(1)
- posted@2019-08-2303:09:09zls评论（0)点赞（0）编辑
- 我的分类
- zls的分类1(2)
- zls的分类2（1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

## 文章详情页

***

| 路由设计 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

***

| 视图设计 |
| :--- |

```plain
def article_detail(request,username,id):
    article = models.Article.objects.filter(pk=id)
    
    return render(request,'article_detail.html',locals())
```

***

| 模板继承 |
| :--- |

base.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-primary">
                <div class="panel-heading">我的标签</div>
                <div class="panel-body">
                    {% for foo in tag_num %}
                        <p><a href="/{{ username }}/tag/{{ foo.2 }}">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">我的分类</div>
                <div class="panel-body">
                    {% for foo in category_num %}
                        <p><a href="/{{ username }}/category/{{ foo.2 }}">{{ foo.0 }}({{ foo.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">随笔档案</div>
                <div class="panel-body">
                    {% for foo in y_m_num %}
                        <p>
                            <a href="/{{ username }}/archive/{{ foo.0|date:"Y-m" }}">{{ foo.0|date:"Y年m月" }}({{ foo.1 }})</a>
                        </p>
                    {% endfor %}
                </div>
            </div>
        </div>
        <div class="col-md-9">
            {% block content %}
            {% endblock %}
        </div>
    </div>
</div>
</div>
</body>
</html>
```

user_blog.html

```plain
{% extends 'base.html' %}
{% block content %}
    {#通过站点查询所有文章,反向查询,按表名小写_set.all#}
    {% for article in article_list %}
        <div>
            <h4><a href="">{{ article.title }}</a></h4>
            <div class="media">
                <div>
                    {{ article.desc }}
                </div>
                <div class="clearfix">
                    <div style="margin-top: 10px " class="article_bottom small pull-right">
                        <span>posted @ {{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        {#反向查询,一对多,按表名小写_set#}
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span>{{ article.blog.userinfo.username }}</span>
                        <span><i class="fa fa-comment" aria-hidden="true"><a
                                href="">评论({{ article.commit_num }})</a></i></span>
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span class="glyphicon glyphicon-thumbs-up"><a href="">点赞({{ article.up_num }})</a></span>
                        <span><a href="">编辑</a></span>
                    </div>
                </div>
                <hr>
            </div>
        </div>
    {% endfor %}
{% endblock %}
```

***

| inclution_tag |
| :--- |

**blog/templatetags/my_tag.py**

```plain
from django.template import Library
from blog import models
from django.db.models import Count
from django.db.models.functions import TruncMonth
register = Library()
@register.inclusion_tag('classify.html')
def classify(username):
    user = models.UserInfo.objects.filter(username=username).first()
    blog = user.blog
    category_num = models.Category.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list(
        'title', 'coun', 'pk')
    tag_num = models.Tag.objects.all().filter(blog=blog).annotate(coun=Count('article__title')).values_list('title',
                                                                                                            'coun',
                                                                                                            'pk')
    y_m_num = models.Article.objects.all().filter(blog=blog).annotate(y_m=TruncMonth('create_time')).values(
        'y_m').annotate(coun=Count('y_m')).values_list('y_m', 'coun')
    return {'category_num': category_num, 'tag_num': tag_num, 'y_m_num': y_m_num, 'username': username}
```

**classify.html**

```plain
<div>
    <div class="panel panel-primary">
        <div class="panel-heading">我的标签</div>
        <div class="panel-body">
            {% for foo in tag_num %}
                <p><a href="/{{ username }}/tag/{{ foo.2 }}">{{ foo.0 }}({{ foo.1 }})</a></p>
            {% endfor %}
        </div>
    </div>
    <div class="panel panel-primary">
        <div class="panel-heading">我的分类</div>
        <div class="panel-body">
            {% for foo in category_num %}
                <p><a href="/{{ username }}/category/{{ foo.2 }}">{{ foo.0 }}({{ foo.1 }})</a></p>
            {% endfor %}
        </div>
    </div>
    <div class="panel panel-primary">
        <div class="panel-heading">随笔档案</div>
        <div class="panel-body">
            {% for foo in y_m_num %}
                <p>
                    <a href="/{{ username }}/archive/{{ foo.0|date:"Y-m" }}">{{ foo.0|date:"Y年m月" }}({{ foo.1 }})</a>
                </p>
            {% endfor %}
        </div>
    </div>
</div>
```

**base.html**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            {% load my_tag %}
            {% classify username %}
        </div>
        <div class="col-md-9">
            {% block content %}
            {% endblock %}
        </div>
    </div>
</div>
</div>
</body>
</html>
```

**views.py**

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
from django.db.models.functions import TruncMonth
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    ## 判断前台发的请求是不是ajax的请求
    elif request.is_ajax():
        response = {'user': None, 'msg': None}
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        valid_code = request.POST.get('valid_code')
        if valid_code.upper() == request.session.get('valid_code').upper():
            user = auth.authenticate(request, username=name, password=pwd)
            if user:
                ## ajax请求，不能再返回render页面或者redirect页面，只能返回字符串或者json
                ## 校验通过，一定要登录
                auth.login(request, user)
                response['user'] = name
                response['msg'] = '登录成功'
            else:
                response['msg'] = '用户名密码错误'
        else:
            response['msg'] = '验证码错误'
    return JsonResponse(response)
def get_random_color_light():
    return (random.randint(0, 100), random.randint(0, 100), random.randint(0, 100))
def get_random_color_dark():
    return (random.randint(150, 255), random.randint(150, 255), random.randint(150, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color_light())
    # 拿到画笔，在图片上画画
    img_draw = ImageDraw.Draw(img)
    # 生成一个字体对象 ，第一个参数是字体文件路径，第二个参数，是字体大小
    font = ImageFont.truetype('static/font/ss.TTF', size=26)
    ## 保存验证码
    random_code = ''
    ## 写一个循环，循环5次，每次随机写一个(数字，大写，小写字母)
    for i in range(5):
        char_num = random.randint(0, 9)
        # 生成97 ~ 122的数字,生成字母
        char_lower = chr(random.randint(97, 122))
        char_upper = chr(random.randint(65, 90))
        char_str = str(random.choice([char_num, char_lower, char_upper]))
        ## 第一个参数，xy的坐标，第二个参数，文字，第三个参数，颜色，第四个参数，字体。
        img_draw.text((i * 60 + 20, 0), char_str, get_random_color_dark(), font=font)
        random_code += char_str
    ## 把验证码 保存到session中
    request.session['valid_code'] = random_code
    width = 350
    height = 45
    for i in range(10):
        x1 = random.randint(0, width)
        x2 = random.randint(0, width)
        y1 = random.randint(0, height)
        y2 = random.randint(0, height)
        # 在图片上画线
        img_draw.line((x1, y1, x2, y2), fill=get_random_color_light())
    for i in range(100):
        img_draw.point([random.randint(0, width), random.randint(0, height)], fill=get_random_color_light())
        x = random.randint(0, width)
        y = random.randint(0, height)
        img_draw.arc((x, y, x + 4, y + 4), 0, 90, fill=get_random_color_light())
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
def register(request):
    if request.method == 'GET':
        my_form = myforms.RegForm()
        return render(request, 'register.html', {'my_form': my_form})
    elif request.is_ajax():
        response = {'status': 100, 'msg': None}
        my_form = myforms.RegForm(request.POST)
        if my_form.is_valid():
            ## 定义一个字段，把通过的数据赋值给字典
            dic = my_form.cleaned_data
            ## 移除确认密码的字段
            dic.pop('re_password')
            ## 取出上传的文件对象
            my_file = request.FILES.get('my_file')
            ## 放到字典中
            ## 如果没有上传文件，数据库存默认值
            if my_file:
                dic['avatar'] = my_file
            user = models.UserInfo.objects.create_user(**dic)
            print(user.username)
            response['url'] = '/login/'
        else:
            response['status'] = 101
            response['msg'] = my_form.errors
        return JsonResponse(response)
def check_username(request):
    response = {'status': 100, 'msg': None}
    name = request.POST.get('name')
    user = models.UserInfo.objects.filter(username=name).first()
    if user:
        response['status'] = 101
        response['msg'] = '用户名已存在'
    return JsonResponse(response)
def index(request):
    article_list = models.Article.objects.all()
    return render(request, 'index.html', {'article_list': article_list})
def logout(request):
    auth.logout(request)
    return redirect('/index/')
def user_blog(request, username, *args, **kwargs):
    username = username
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    article_list = blog.article_set.all()
    condition = kwargs.get('condition')
    param = kwargs.get('param')
    if condition == 'tag':
        article_list = article_list.filter(tag__pk=param)
    elif condition == 'category':
        article_list = article_list.filter(category__pk=param)
    elif condition == 'archive':
        archive_list = param.split('-')
        article_list = article_list.filter(create_time__year=archive_list[0], create_time__month=archive_list[1])
    return render(request, 'user_blog.html', locals())
def article_detail(request,username,id):
    username = username
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    article = models.Article.objects.filter(pk=id)
    return render(request,'article_detail.html',locals())
```

<!-- OCR_START -->
- zls-的个人博客
- Blog管理|Django站点管理员×
- →C
- 127.0.0.1:8000/zls/article/1
- 应用zabbix-api
- CanIUse
- iview
- 组件|Element
- 这里是博客站点的标题
- 文章详情
- 我的标签
- zls的标签1(2)
- zls的标签2（1)
- 我的分类
- zls的分类1(2)
- zls的分类2（1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

***

| 详情页跳转 |
| :--- |

```plain
{% extends 'base.html' %}
{% block content %}
    {#通过站点查询所有文章,反向查询,按表名小写_set.all#}
    {% for article in article_list %}
        <div>
            <h4><a href="/{{ username }}/article/{{ article.pk }}">{{ article.title }}</a></h4>
            <div class="media">
                <div>
                    {{ article.desc }}
                </div>
                <div class="clearfix">
                    <div style="margin-top: 10px " class="article_bottom small pull-right">
                        <span>posted @ {{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        {#反向查询,一对多,按表名小写_set#}
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span>{{ article.blog.userinfo.username }}</span>
                        <span><i class="fa fa-comment" aria-hidden="true"><a
                                href="">评论({{ article.commit_num }})</a></i></span>
                        {#                        <span class="glyphicon glyphicon-comment"><a href="">评论({{ article.commit_num }})</a></span>#}
                        <span class="glyphicon glyphicon-thumbs-up"><a href="">点赞({{ article.up_num }})</a></span>
                        <span><a href="">编辑</a></span>
                    </div>
                </div>
                <hr>
            </div>
        </div>
    {% endfor %}
{% endblock %}
```

***

| 主页跳转文章详情和个人中心 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <style>
        .bottom span {
            margin-right: 16px;
        }
    </style>
    <title>博客</title>
</head>
<body>
<div class="head">
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <a class="navbar-brand" href="#">曾老湿博客系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">文章<span class="sr-only">(current)</span></a></li>
                    <li><a href="#">随笔</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    {% if request.user.is_authenticated %}
                        <li><a href="#">{{ request.user.username }}</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                               aria-haspopup="true"
                               aria-expanded="false">个人中心<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="#">修改密码</a></li>
                                <li><a href="#">修改头像</a></li>
                                <li><a href="#">修改主题</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="/logout/">注销</a></li>
                            </ul>
                        </li>
                    {% else %}
                        <li><a href="/login/">登录</a></li>
                        <li><a href="/register/">注册</a></li>
                    {% endif %}
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2">
            <div class="panel panel-danger">
                <div class="panel-heading">重金求子</div>
                <div class="panel-body">
                    <p>请联系：13800000000</p>
                    <p>年入60w</p>
                </div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">草榴社区</div>
                <div class="panel-body">
                    <a href="http://www.driverzeng.com">请点击跳转</a>
                </div>
            </div>
        </div>
        <div class="col-md-7">
            {% for article in article_list %}
                <div>
                    <h4><a href="/{{ article.blog.userinfo.username }}/article/{{ article.pk }}">{{ article.title }}</a></h4>
                    <div class="media">
                        <div class="media-left">
                            <a href="#">
                                
                            </a>
                        </div>
                        <div class="media-body">
                            {{ article.desc }}
                        </div>
                    </div>
                    <div style="margin-top: 20px;margin-bottom: 30px" class="bottom">
                        <span><a href="/{{ article.blog.userinfo.username }}/">{{ article.blog.userinfo.username }}</a></span>
                        <span>发布于{{ article.create_time|date:'Y-m-d H:i:s' }}</span>
                        <span class="glyphicon glyphicon-comment"><a href=""
                                                                     style="margin-left: 2px">评论({{ article.commit_num }})</a></span>
                        <span class="glyphicon glyphicon-thumbs-up"><a href=""
                                                                       style="margin-left: 2px">点赞({{ article.up_num }})</a></span>
                    </div>
                </div>
            {% endfor %}
        </div>
        <div class="col-md-3">
            <div class="panel panel-success">
                <div class="panel-heading">日韩系列</div>
                <div class="panel-body">
                    <a href="http://download.driverzeng.com">Tokyo Hot</a>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">欧美系列</div>
                <div class="panel-body">
                    <a href="http://blog.driverzeng.com">金八天国</a>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">动漫卡通</div>
                <div class="panel-body">
                    <a href="http://pikachu.driverzeng.com">女仆</a>
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">精品图区</div>
                <div class="panel-body">
                    <a href="http://taiji.driverzeng.com">美腿丝袜</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

***

| 构造文章详情页 |
| :--- |

views.py

```plain
def article_detail(request,username,id):
    username = username
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    article = models.Article.objects.filter(pk=id).first()
    return render(request,'article_detail.html',locals())
```

```plain
{% extends 'base.html' %}
{% block content %}
<div>
<h4 class="text-center">{{ article.title }}</h4>
<div>
    {{ article.content }}
</div>
</div>
{% endblock %}
```

<!-- OCR_START -->
zls-的个人博客
X修改文章表|Django站点管理×+
←→C127.0.0.1:8000/zls/article/1
l应用zabbix-apiCanIUseiview组件|Element
这里是博客站点的标题
我的标签
深入浅出～
Java中的实参与形参之间的传递到底是值传递还是引用传递呢？其实之前我和大多数人一样认为：传递的参数如果是“基本数据类型”，那就是“值传递”，如果是“引用类型”（即对象），那就是“引用
zls的标签1(2)
传递”。但是昨天我突然觉得：好像。。。不一定！矣，别急着我说：Nemo！你传递过对象没啊，把对象传过去，修改对象的属性值，属性值就是的的确确的修改了啊！谈，你说的没错，确实是修
zls的标签2（1)
改了，但是你也说了是修改对象的属性值，传过去的是对象地址，而你的实际操作并没有对你传入的地址进行修改，只是修改了对象地址下面的属性值。如果只是修改对象地址下面的属性值的话，那
么值传递和引用传递有差吗？值传递：复制对象地址给函数，函数修改对象地址下面的属性值。引用传递：引用对象地址给函数，函数修改对象地址下面的属性值。这两者有差吗，无论是复制还是引
用，传入的对象地址都没有改变，改变的只是对象地址下面的属性值。类比：我们可以类比一下，你家的地址是“北京市海淀区清华园1号”。引用传递：你给我引用你的地址，我过去你的地址那，打
开你家的门，偷你家电动车的电瓶。值传递：你不给我你的地址，我从网上找到你的地址，复制一份，过去你的地址那，打开你家的门，偷你家电动车的电瓶。你瞧瞧，这两者有差吗？无论是怎样拿
我的分类
到你家的地址，你家的电瓶我要定了啊，你家的电瓶都会被修改啊。举例代码：↓CloseCodelpackagetemp;/**@authorNemo*@date2020/6/22*/publicclassValueTransfer{public staticvoid
main(Stringargs){Home yourHome=newHome(你的家");Nemo nemo=newNemoO;nemo.steal(yourHome);yourHome.show0:}}class Home{public String name;public boolean battery=
zls的分类1(2)
true;publicboolean isBattery0{returnbattery;}publicvoidsetBattery(booleanbattery){this.battery=battery;}publicString getName0return name;}publicvoid setName(String name){
this.name=name;}public Home(String name){this.name=name;}publicvoid show0{if（this.isBatteryO)(System.out.println(name+“的电瓶还在哟~);}else{System.out.println(name+“的电瓶
zls的分类2（1)
被偷了！);)）}classNemo{publicvoidsteal（(Homehome)[/如果是引用传递的话，那么我把你的家整个都变为了别人的家，那么你的家对象上现在应该存放的是别人的家//如果是值传递的话，那
么我只是把你的家对象复制了一个新的，这个新的家是别人的家，我偷一个跟你家一模一样的别人家的电瓶，你家的电瓶应该不会变home=newHome(“别人的家");；home.battery=false；
home.showo：））在Nemo类的steal方法中，我们可以看到注释：如果是引用传递，那么我把你的家整个都变为了别人的家，那么你的家对象上现在应该存放的是别人的家，并且你家（即别人家）
的电瓶也应该被我偷了。如果是值传递，那么我只是把你的家对象参数复制了一个新的，这个新的家我设为了别人的家，我偷一个跟你家一模一样的别人家的电瓶，你家的电瓶应该不会变。运行结
随笔档案
果：ICloseCodeL别人的家的电瓶被偷了！你的家的电瓶还在哟～根据运行结果来看，很显然，是第二种情况，也就是值传递，我偷的是一个跟你家一模一样的别人家的电瓶，而你家的电瓶还在
2018年07月（2）
2019年08月（1）
曾老湿
<!-- OCR_END -->

￼

文章内容，好....

好踏马的丑。

文章里面存的都是html的标签。我们来修改一下。

<!-- OCR_START -->
- zls-的个人博客
- Blog 管理|Django站点管理员×
- 127.0.0.1:8000/zls/article/1
- 应用zabbix-api
- CanIUseiview组件IElement
- 这里是博客站点的标题
- 我的标签
- 深入浅出～
- <h1>你好，哈拉哨~</h1>
- zls的标签1(2)
- zls的标签2(1)
- 我的分类
- zls的分类1(2)
- zls的分类2（1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

卧槽，妖兽啦~为啥没好使？

因为需要使用模板语言的safe

```plain
{% extends 'base.html' %}
{% block content %}
<div>
<h4 class="text-center">{{ article.title }}</h4>
<div>
    {{ article.content|safe }}
</div>
</div>
{% endblock %}
```

<!-- OCR_START -->
- zls-的个人博客
- Blog管理|Django站点管理员×
- ←→C
- 127.0.0.1:8000/zls/article/1
- 应用zabbix-api
- CanIUseiview组件IElement
- 这里是博客站点的标题
- 我的标签
- 深入浅出～
- zls的标签1（2）
- 你好，哈拉哨~
- zls的标签2(1)
- 我的分类
- zls的分类1(2)
- zls的分类2（1）
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

## 文章点赞功能

***

| 模板层 |
| :--- |

base.html 引入一个css文件

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ blog.userinfo.username }}-的个人博客</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="/static/css/mycss.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="/static/css/{{ blog.theme }}">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<div class="head">
    <p>{{ blog.title }}</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            {% load my_tag %}
            {% classify username %}
        </div>
        <div class="col-md-9">
            {% block content %}
            {% endblock %}
        </div>
    </div>
</div>
</div>
</body>
</html>
```

mycss.css

```plain
#div_digg {
    float: right;
    margin-bottom: 10px;
    margin-right: 30px;
    font-size: 12px;
    width: 125px;
    text-align: center;
    margin-top: 10px;
}
.diggit {
    float: left;
    width: 46px;
    height: 52px;
    background: url(/static/img/upup.gif) no-repeat;
    text-align: center;
    cursor: pointer;
    margin-top: 2px;
    padding-top: 5px;
}
.buryit {
    float: right;
    margin-left: 20px;
    width: 46px;
    height: 52px;
    background: url(/static/img/downdown.gif) no-repeat;
    text-align: center;
    cursor: pointer;
    margin-top: 2px;
    padding-top: 5px;
}
.clear {
    clear: both;
}
.diggword {
    margin-top: 5px;
    margin-left: 0;
    font-size: 12px;
    color: gray;
}
```

article_detail.html

```plain
{% extends 'base.html' %}
{% block content %}
    <div>
        <h4 class="text-center">{{ article.title }}</h4>
        <div>
            {{ article.content|safe }}
        </div>
        <div id="div_digg">
            <div class="diggit">
                <span class="diggnum" id="digg_count">{{ article.up_num }}</span>
            </div>
            <div class="buryit">
                <span class="burynum" id="bury_count">{{ article.down_num }}</span>
            </div>
            <div class="clear"></div>
            <div class="diggword" id="digg_tips" style="color: red;">您已经反对过</div>
        </div>
    </div>
    </div>
{% endblock %}
```

<!-- OCR_START -->
- zls-的个人博客
- Blog管理|Django站点管理员x丨+
- ←→Q
- 127.0.0.1:8000/zls/article/1
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 这里是博客站点的标题
- 我的标签
- 深入浅出～
- zls的标签1(2)
- 你好，哈拉哨~
- zls的标签2（1)
- 推荐
- 反对
- 我的分类
- 您已经反对过
- zls的分类1(2)
- zls的分类2（1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 曾老湿
<!-- OCR_END -->

￼

点赞，向后台发起ajax请求。

```plain
{% extends 'base.html' %}
{% block content %}
    <div>
        <h4 class="text-center">{{ article.title }}</h4>
        <div>
            {{ article.content|safe }}
        </div>
        <div id="div_digg">
            <div class="diggit">
                <span class="diggnum" id="digg_count">{{ article.up_num }}</span>
            </div>
            <div class="buryit">
                <span class="burynum" id="bury_count">{{ article.down_num }}</span>
            </div>
            <div class="clear"></div>
            <div class="diggword" id="digg_tips" style="color: red;">您已经反对过</div>
        </div>
    </div>
    </div>
    <script>
        $(".diggit").click(function () {
            $.ajax({
                url: '/diggit/',
                type: 'post',
                //谁对哪篇文章,点赞
                //谁,可以不传吗?从后台取
                data: {
                    article_id: '{{ article.pk }}',
                    is_up: true,
                    'csrfmiddlewaretoken': '{{ csrf_token }}'
                },
                success: function (data) {
                    console.log(data)
                }
            })
        })
    </script>
{% endblock %}
```

```plain
def diggit(request):
    response={'status':100,'msg':None}
    if request.user.is_authenticated():
        # 从前端传过来的数据,都转成str类型
        article_id=request.POST.get('article_id')
        is_up=request.POST.get('is_up')
        print(is_up)
        print(type(is_up))
        # 用json转
        # # python中的
        # {'is_up':True}
        # # 转成json
        # {"is_up": "true"}
        is_up=json.loads(is_up)
        print(is_up)
        print(type(is_up))
        # 原子性操作.用事务
        with transaction.atomic():
            models.UpAndDown.objects.create(user=request.user,article_id=article_id,is_up=is_up)
            models.Article.objects.filter(pk=article_id).update(up_num=F('up_num')+1)
            response['msg']='点赞成功'
    else:
        response['msg'] = '请先登录'
        response['status'] = 101
    return JsonResponse(response)
```

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    
    
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

<!-- OCR_START -->
zls-的个人博客
Blog管理|Django站点管理员×+
→C127.0.0.1:8000/zls/article/2
9
应用zabbix-api
CanIUseiview组件IElement
这里是博客站点的标题
我的标签
Golang简易入门教程一一面向对象篇
..Kubernetes学习笔记（九）：StatefulSet--部署有状态的多副本应用StatefulSet如何提供稳定的网络标识和状态#ReplicaSet中的Pod都是无状态，可随意替代的。又因为ReplicaSet中的Pod是根据
zls的标签1(2)
模板生成的多副本，无法对每个副本都指定单独的PVC。来看一下StatefulSet如何解决的。提供稳定的网络标识#StatefulSet创建Pod都有一个从零开始的顺序索引l，这会体现在Pod的名称和主机名
zls的标签2(1)
上，同样也会体现在Pod对应的固定存储上。所以这些名字是可预先知道的，不同于ReplicaSet的随机生成名字。因为他们的名字都是固定的，而且彼此状态都不同，通常会操作他们其中的一个。如
此情况，一般都会创建一个与之对应的headlessService，通过这个Service，每个Pod将拥有独立的DNS记录。扩容一个StatefulSet会使用下一个顺序索引创建一个新的Pod，缩容会删除索引值最高
的。并且缩容任何时候只会操作一个Pod。如何提供稳定的存储#StatefulSet可以拥有一个或多个PVC模板，这些PVC会在创建Pod前创建出来，绑定到一个Pod实例上。扩容的时候会创建一个Pod以
及若干个PVC，删除的时候只会删除Pod。StatefulSet缩容时不会删除PVC，扩容时会重新挂上。使用StatefulSet#定义三个PV#定义pv-(alblc)Copy#stateful-pv-list.yamlapiVersion:v1kind：
我的分类
PersistentVolumemetadata:name:pv-aspec:capacity:storage:1MiaccessModes:-ReadWriteOnce persistentVolumeReclaimPolicy:Recycle hostPath:path:/tmp/pva--apiVersion:v1kind:
PersistentVolume#以下忽略headless的Service#Copy #stateful-service-headless.yamlapiVersion:v1kind:Servicemetadata:name:rwfile spec:clusterlP:None selector:app:rwflports:-port:
zls的分类1(2)
80定义StatefulSet#先创建两个Pod副本。使用volumeClaimTemplates定义了PVC模板。Copy#stateful.yamlapiVersion:apps/v1kind:StatefulSetmetadata:name:rwfil spec:replicas:2
serviceName:rwfileselector:matchLabels:app:rwfiletemplate:metadata:labels:app:rwfilespec:containers:-image:registry.cn-hangzhou.aliyuncs.com/orzi/rwfilename:rwfileports:-
zls的分类2（1)
containerPort:80o0volumeMounts:-name:datamountPath:/tmp/datavolumeClaimTemplates:-metadata:name:data spec:resources:requests:storage:1MiaccessModes:-ReadWriteOnce创
建三个PV,—个headless的Service,—个StatefulSetCopy->[root@kube0.vm][] kcreate-f stateful-pv-list.yaml persistentvolume/pv-a createdpersistentvolume/pv-bcreated
persistentvolume/pv-ccreated->[root@kube0.vm] [-]kcreate-f stateful-service-headless.yaml service/rwfilecreated->[root@kube0.vm][-]kcreate-f stateful.yaml statefulset.apps/rwfilecreated
查看Copy->[root@kube0.vm][]kgetall-owideNAMEREADYSTATUSRESTARTSAGEIPNODENOMINATEDNODEREADINESSGATESpod/rwfile-01/1Running012s10.244.1.52kube1.vm
随笔档案
pod/rwfil-11/1Running08s10.244.2.56kube2.vmNAMETYPECLUSTER-IPEXTERNAL-IPPORT(S)AGESELECTORservice/kubernetesClusterIP10.96.0.1443/TCP81sservice/rwfile
ClusterlPNone80/TCP23sapp=rwfileNAMEREADYAGECONTAINERSIMAGESstatefulset.apps/rwfile2/212srwfileregistry.cn-hangzhou.aliyuncs.com/orzi/rwfile查看PV和PVC，可以看到已经
2018年07月（2）
有两个PVC绑定了PVCopy->[root@kubeO.vm][]kgetpv,pvc-owideNAMECAPACITYACCESSMODESRECLAIMPOLICYSTATUSCLAIMSTORAGECLASSREASONAGEVOLUMEMODE
2019年08月（1）
persistentvolume/pv-a1MiRWORecycleBounddefault/data-rwil-07m20sFilesystempersistentvolume/pv-b1MiRWORecycleBounddefault/data-rwfile-17m20sFilesystem
persistentvolume/pv-c1MiRWORecycleAvailable7m20sFilesystemNAMESTATUSVOLUMECAPACITYACCESSMODESSTORAGECLASSAGEVOLUMEMODEpersistentvolumeclaim/data-
rwfile-0Boundpv-a1MiRWO6m55sFilesystempersistentvolumeclaim/data-rwfil-1Boundpv-b1MiRWO6m51sFilesystem请求Pod#启动代理Copy->[root@kube0.vm][-]kproxyStartingto
serveon127.0.0.1:8001发送请求Copy->[root@kube0.vm][-]curlhttp://localhost:8001/api/v1/namespaces/default/pods/rwfile-0/proxy/-da=123"datastored in:rwfile-0->[root@kube0.vm][-]
curl http://localhost:8001/api/v1/namespaces/default/pods/wfile-0/proxy/a=123删除测试#删除rwfil-0，然后查看，从时间上看确实是被删除重建的。Copy->[root@kube0.vm][-]kdeletepo
rwfile-0pod“rwfile-0°deleted->[root@kube0.vm][-]kgetpoNAMEREADYSTATUSRESTARTSAGErwile-01/1Running07srwfile-11/1Running019m看一下之前存储的数据还在不在Copy-
[root@kube0.vm][-]curlhttp://localhost:8001/api/v1/namespaces/default/pods/rwil-0/proxy/a=123还是在的，此次测试实际上也证明了StatefulSet提供了稳定的网络标识和存储。发现
StatefuISet的伙伴节点#使用DNS解析headless的Service的FQDN。例子以后再写吧。。如何处理节点失效#除非确定节点无法运行或者不会在访问，否则不要强制删除有状态的PodCopykdelete
podrwile-0--force--grace-periodO小结#StatefulSet创建Pod都有一个从零开始的顺序索引通常会创建一个与StatefulSet对应的headlessService。扩容一个StatefulSet会使用下一个顺序索引l创建
一个新的Pod，缩容会删除索引l值最高的。新建StatefulSet需要指定headlessServiceName和volumeClaimTemplates。使用DNS发现StatefulSet的伙伴节点强制删除：kdeletepodrwfile-0--force--
grace-period0
推荐
反对
Elements
ConsoleSourcesNetworkPerfomanceMemoryApplicationSecurityLighthouse
：X
top
Fiter
Default levels
_proto_:Object
曾老湿
Rendering
<!-- OCR_END -->

￼

***

| 合并点赞点踩以及评论功能 |
| :--- |

article_detail.html

```plain
{% extends 'base.html' %}
{% block content %}
    {#{% csrf_token %}#}
    <div>
        <p><h4 class="text-center">{{ article.title }}</h4></p>
        <div>
            {{ article.content|safe }}
        </div>
        {#点赞#}
        <div class="clearfix">
            <div id="div_digg">
                <div class="diggit action">
                    <span class="diggnum" id="digg_count">{{ article.up_num }}</span>
                </div>
                <div class="buryit action">
                    <span class="burynum" id="bury_count">{{ article.down_num }}</span>
                </div>
                <div class="clear"></div>
                <div class="diggword" id="digg_tips" style="color: red;"></div>
            </div>
        </div>
        {#评论#}
        <div>
            <ul class="list-group cotent_ul">
                {% for content in content_list %}
                    <li class="list-group-item">
                        <p><span>#{{ forloop.counter }}楼</span>
                            <span>{{ content.create_time|date:'Y-m-d H:i:s' }}</span>
                            <span><a href="/{{ content.user.username }}">{{ content.user.username }}</a></span>
                            <span class="pull-right replay" username="{{ content.user.username }}" content_id="{{ content.pk }}">回复</span>
                        </p>
                        {% if content.parent %}
                            {#content.parent 拿到的是什么? 拿到父评论的对象#}
                            <p class="well">@{{ content.parent.user.username }}</p>
                        {% endif %}
                        {{ content.content }}
                    </li>
                {% endfor %}
            </ul>
        </div>
        <div>
            <p>发表评论</p>
            <p>
                昵称：<input type="text" id="tbCommentAuthor" class="author" disabled="disabled" size="50" value="曾老湿">
            </p>
            <p>评论内容：</p>
            <p>
                <textarea name="" id="content" cols="60" rows="10">
            </textarea>
            </p>
            <button class="btn btn-primary submit">提交</button>
        </div>
    </div>
    <script>
        //全局变量
        var pid = ''
        //评论相关(跟评论的方法)
        /*
        $('.submit').click(function () {
            //评论要提交什么内容
            //谁?又不需要传对哪篇文章评论了什么内容
            var content = $("#content").val()
            $("#content").val("")
            $.ajax({
                url: '/commit_content/',
                type: 'post',
                data: {
                    'article_id': '{{ article.pk }}',
                    'content': content,
                    'pid': '',
                    'csrfmiddlewaretoken': '{{ csrf_token }}'
                },
                success: function (data) {
                    console.log(data)
                    //拼  用户名:时间
                    //    评论内容    这些数据都应该从后台返回
                    var time=data.time
                    var content=data.content
                    var user_name=data.user_name
                    var ss=`
                      <li class="list-group-item">
                        <p>
                            <span>${ user_name }</span>:
                            <span>${ time }</span>
                        </p>
                         ${content}
                    </li>
                    `
                    $(".cotent_ul").append(ss)
                }
            })
        })
        */
        //字评论和根评论
        $('.submit').click(function () {
            var content = $("#content").val()
            $("#content").val("")
            if (pid) {
                //pid有值,才切掉头部
                //拿到content要切的起始位置indexOf(),取到指定值的索引值
                //取到 \n 索引位置的后一位
                var index = content.indexOf('\n') + 1
                alert('评论成功')
                //slice传一个起始位置,一个结束位置,就可以切出来
                content = content.slice(index)
            }
            $.ajax({
                url: '/commit_content/',
                type: 'post',
                data: {
                    'article_id': '{{ article.pk }}',
                    'content': content,
                    'pid': pid,
                    'csrfmiddlewaretoken': '{{ csrf_token }}'
                },
                success: function (data) {
                    console.log(data)
                    //拼  用户名:时间
                    //    评论内容    这些数据都应该从后台返回
                    var time = data.time
                    var content = data.content
                    var user_name = data.user_name
                    var ss =''
                    if (pid){
                        //需要清空一下父评论的id
                        {#pid=''#}
                        var parent_name=data.parent_name
                        ss=`
                         <li class="list-group-item">
                         <p>
                         <span>${ user_name }</span>
                            <span>${ time }</span>
                        </p>
                            <p class="well">@${parent_name }</p>
                        ${content}
                    </li>
                        `
                    }else {
                         ss= `
                      <li class="list-group-item">
                        <p>
                            <span>${ user_name }</span>:
                            <span>${ time }</span>
                        </p>
                         ${content}
                    </li>
                    `
                    }
                    $(".cotent_ul").append(ss)
                }
            })
        })
        $(".replay").click(function () {
            //拿到span标签中username属性对应的值
            var username = $(this).attr('username')
            //alert(username)
            //把拼接的字符串放到content内,并且换行
            $('#content').val('@' + username + '\n')
            //让光标聚焦到这个控件
            $('#content').focus()
            //给pid赋值(pid是父评论的id)
            pid = $(this).attr('content_id')
        })
        //点赞相关
        $(".action").click(function () {
            //判断当前点击的div控件,有没有diggit类
            var is_up = $(this).hasClass('diggit')
            var obj = $(this).children('span')
            //alert(is_up)
            $.ajax({
                url: '/diggit/',
                type: 'post',
                //谁对哪篇文章,点赞
                //谁,可以不传吗?从后台取
                data: {article_id: '{{ article.pk }}', is_up: is_up, 'csrfmiddlewaretoken': '{{ csrf_token }}'},
                success: function (data) {
                    console.log(data)
                    //在点赞下方显示信息提示
                    $("#digg_tips").html(data.msg)
                    if (data.status == 100) {
                        //如果返回成功,点赞数或点踩数加1(第一种方案)
                        /*
                        if(is_up){
                            //这个值是字符串
                           var count= $("#digg_count").text()
                            //把count转成int类型
                            //这两种方式都可以
                            //$("#digg_count").text(parseInt(count)+1)
                            $("#digg_count").text(Number(count)+1)
                        }else{
                            var count= $("#bury_count").text()
                            $("#bury_count").text(Number(count)+1)
                        }
                        */
                        //第二种方案
                        //ojb是当前点击div中的span标签,先取出span中的数字,+1,然后放到span中
                        obj.text(Number(obj.text()) + 1)
                    }
                    //过三秒清除提示
                    setTimeout(function () {
                        $("#digg_tips").html("")
                    }, 3000)
                }
            })
        })
        /*
            $(".diggit").click(function () {
            })
            function test() {
                $.ajax({
                    url: '/diggit/',
                    type: 'post',
                    //谁对哪篇文章,点赞
                    //谁,可以不传吗?从后台取
                    data: {article_id: '{{ article.pk }}', is_up: true, 'csrfmiddlewaretoken': '{{ csrf_token }}'},
                success: function (data) {
                    console.log(data)
                }
            })
        }
        */
    </script>
{% endblock %}
```

views.py

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
from django.db.models.functions import TruncMonth
from django.contrib.auth.decorators import login_required
import json
from django.db import transaction
from django.db.models import F
# Create your views here.
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    ## 判断前台发的请求是不是ajax的请求
    elif request.is_ajax():
        response = {'user': None, 'msg': None}
        name = request.POST.get('name')
        pwd = request.POST.get('pwd')
        valid_code = request.POST.get('valid_code')
        if valid_code.upper() == request.session.get('valid_code').upper():
            user = auth.authenticate(request, username=name, password=pwd)
            if user:
                ## ajax请求，不能再返回render页面或者redirect页面，只能返回字符串或者json
                ## 校验通过，一定要登录
                auth.login(request, user)
                response['user'] = name
                response['msg'] = '登录成功'
            else:
                response['msg'] = '用户名密码错误'
        else:
            response['msg'] = '验证码错误'
    return JsonResponse(response)
def get_random_color_light():
    return (random.randint(0, 100), random.randint(0, 100), random.randint(0, 100))
def get_random_color_dark():
    return (random.randint(150, 255), random.randint(150, 255), random.randint(150, 255))
def get_valid_code(request):
    img = Image.new('RGB', (320, 35), color=get_random_color_light())
    # 拿到画笔，在图片上画画
    img_draw = ImageDraw.Draw(img)
    # 生成一个字体对象 ，第一个参数是字体文件路径，第二个参数，是字体大小
    font = ImageFont.truetype('static/font/ss.TTF', size=26)
    ## 保存验证码
    random_code = ''
    ## 写一个循环，循环5次，每次随机写一个(数字，大写，小写字母)
    for i in range(5):
        char_num = random.randint(0, 9)
        # 生成97 ~ 122的数字,生成字母
        char_lower = chr(random.randint(97, 122))
        char_upper = chr(random.randint(65, 90))
        char_str = str(random.choice([char_num, char_lower, char_upper]))
        ## 第一个参数，xy的坐标，第二个参数，文字，第三个参数，颜色，第四个参数，字体。
        img_draw.text((i * 60 + 20, 0), char_str, get_random_color_dark(), font=font)
        random_code += char_str
    ## 把验证码 保存到session中
    request.session['valid_code'] = random_code
    width = 350
    height = 45
    for i in range(10):
        x1 = random.randint(0, width)
        x2 = random.randint(0, width)
        y1 = random.randint(0, height)
        y2 = random.randint(0, height)
        # 在图片上画线
        img_draw.line((x1, y1, x2, y2), fill=get_random_color_light())
    for i in range(100):
        img_draw.point([random.randint(0, width), random.randint(0, height)], fill=get_random_color_light())
        x = random.randint(0, width)
        y = random.randint(0, height)
        img_draw.arc((x, y, x + 4, y + 4), 0, 90, fill=get_random_color_light())
    ## 在内存中生成一个空文件
    f = BytesIO()
    ## 把图片保存到f中
    img.save(f, 'png')
    ## 取出图片
    data = f.getvalue()
    return HttpResponse(data)
def register(request):
    if request.method == 'GET':
        my_form = myforms.RegForm()
        return render(request, 'register.html', {'my_form': my_form})
    elif request.is_ajax():
        response = {'status': 100, 'msg': None}
        my_form = myforms.RegForm(request.POST)
        if my_form.is_valid():
            ## 定义一个字段，把通过的数据赋值给字典
            dic = my_form.cleaned_data
            ## 移除确认密码的字段
            dic.pop('re_password')
            ## 取出上传的文件对象
            my_file = request.FILES.get('my_file')
            ## 放到字典中
            ## 如果没有上传文件，数据库存默认值
            if my_file:
                dic['avatar'] = my_file
            user = models.UserInfo.objects.create_user(**dic)
            print(user.username)
            response['url'] = '/login/'
        else:
            response['status'] = 101
            response['msg'] = my_form.errors
        return JsonResponse(response)
def check_username(request):
    response = {'status': 100, 'msg': None}
    name = request.POST.get('name')
    user = models.UserInfo.objects.filter(username=name).first()
    if user:
        response['status'] = 101
        response['msg'] = '用户名已存在'
    return JsonResponse(response)
def index(request):
    article_list = models.Article.objects.all()
    return render(request, 'index.html', {'article_list': article_list})
def logout(request):
    auth.logout(request)
    return redirect('/index/')
def user_blog(request, username, *args, **kwargs):
    username = username
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    article_list = blog.article_set.all()
    condition = kwargs.get('condition')
    param = kwargs.get('param')
    if condition == 'tag':
        article_list = article_list.filter(tag__pk=param)
    elif condition == 'category':
        article_list = article_list.filter(category__pk=param)
    elif condition == 'archive':
        archive_list = param.split('-')
        article_list = article_list.filter(create_time__year=archive_list[0], create_time__month=archive_list[1])
    return render(request, 'user_blog.html', locals())
def article_detail(request, username, id):
    username = username
    user = models.UserInfo.objects.filter(username=username).first()
    if not user:
        return render(request, 'error.html')
    blog = user.blog
    article = models.Article.objects.filter(pk=id).first()
    content_list = article.commit_set.all().order_by('pk')
    return render(request, 'article_detail.html', locals())
def diggit(request):
    response = {'status': 100, 'msg': None}
    if request.user.is_authenticated():
        # 从前端传过来的数据,都转成str类型
        article_id = request.POST.get('article_id')
        is_up = request.POST.get('is_up')
        is_up = json.loads(is_up)
        user = request.user
        # 存之前先查询,当前用户对该篇文章是否点过
        ret = models.UpAndDown.objects.filter(user_id=user.pk, article_id=article_id).exists()
        if ret:
            # 当有数据,说明,已经点过赞或者踩了
            response['msg'] = '您已经点过了'
            response['status'] = 101
        else:
            # 原子性操作.用事务
            with transaction.atomic():
                models.UpAndDown.objects.create(user=user, article_id=article_id, is_up=is_up)
                # 先取出文章的queryset对象
                article = models.Article.objects.filter(pk=article_id)
                if is_up:
                    article.update(up_num=F('up_num') + 1)
                    response['msg'] = '点赞成功'
                else:
                    article.update(down_num=F('down_num') + 1)
                    response['msg'] = '反对成功'
    else:
        response['msg'] = '请先登录'
        response['status'] = 101
    return JsonResponse(response)
def commit_content(request):
    response = {'status': 100, 'msg': None}
    if request.is_ajax():
        if request.user.is_authenticated():
            # 核心逻辑
            user = request.user
            article_id = request.POST.get('article_id')
            content = request.POST.get('content')
            pid = request.POST.get('pid')
            print(pid)
            with transaction.atomic():
                ret = models.Commit.objects.create(user=user, article_id=article_id, content=content, parent_id_id=pid)
                models.Article.objects.filter(pk=article_id).update(commit_num=F('commit_num') + 1)
            response['msg'] = '评论成功'
            response['content'] = ret.content
            # 把datetime类型转成字符串,因为json是无法序列化datetime
            response['time'] = ret.create_time.strftime('%Y-%m-%d %X')
            response['user_name'] = ret.user.username
            if pid:
                # 如果是字评论,返回父评论的名字
                response['parent_name'] = ret.parent.user.username
        else:
            response['status'] = 101
            response['msg'] = '您没有登录'
    else:
        response['status'] = 101
        response['msg'] = '您请求非法'
    print(response)
    return JsonResponse(response)
```

urls.py

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    # p评论的路由
    url(r'^commit_content/$', views.commit_content),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

<!-- OCR_START -->
- zls-的个人博客
- 选择评论表来修改|Django站×|
- →C
- 127.0.0.1:8000/zls/article/1
- 8
- 应用zabbix-api
- CanlUse
- iview组件|Element
- 1
- 推荐
- 反对
- 我的分类
- #1楼2020-06-2204:11:07zls1
- 回复
- zls的分类1(2)
- 写的秒啊~~
- zls的分类2（1)
- #2楼2020-06-2204:11:35alin
- 牛逼牛逼，大佬大佬。
- 随笔档案
- #3楼2020-06-2315:46:17 zls
- 2018年07月（2）
- 2019年08月（1）
- #4楼2020-06-2315:47:28zls
- 安安
- #5楼2020-06-2315:55:13zls
- aaaa
- #6楼2020-06-2315:59:22zs
- hello
- #7楼2020-06-2316:00:12zls
- test
- 发表评论
- 昵称：曾老湿
- 评论内容：
- 曾老湿
- 提交
<!-- OCR_END -->

￼

## 后台管理功能

***

| 路由 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    # p评论的路由
    url(r'^commit_content/$', views.commit_content),
    url(r'^backend/', views.backend),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

***

| 视图 |
| :--- |

```plain
@login_required(login_url='/login/')
def backend(request):
    if request.method == 'GET':
        return render(request,'back/backend.html')
    return HttpResponse('OK')
```

***

| 模板 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>后台管理</title>
</head>
<body>
这里是后台管理页面
</body>
</html>
```

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- →C127.0.0.1:8000/backend/
- 9
- 应用zabbix-api
- CanIUseiview组件IElement
- 这里是后台管理页面
- 曾老湿
<!-- OCR_END -->

￼

### 查询所有文章

***

| 视图 |
| :--- |

```plain
@login_required(login_url='/login/')
def backend(request):
    if request.method == 'GET':
        blog = request.user.blog
        article_list = models.Article.objects.filter(blog=blog)
        return render(request,'back/backend.html',{'article_list':article_list})
    return HttpResponse('OK')
```

***

| 模板 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="/static/css/mycss.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <title>后台管理</title>
    <style>
        .head {
            height: 60px;
            background: aquamarine;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="head">
    <p>后台管理</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne"
                               aria-expanded="true" aria-controls="collapseOne">
                                操作
                            </a>
                        </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">添加文章</a>
                        </div>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">添加随笔</a>
                        </div>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">其他操作</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-9">
            <table class="table table-hover table-striped">
                <thead>
                <tr>
                    <th>文章标题</th>
                    <th>发布时间</th>
                    <th>评论数</th>
                    <th>点赞数</th>
                    <th>修改</th>
                    <th>删除</th>
                </tr>
                </thead>
                <tbody>
                {% for article in article_list %}
                <tr>
                <td><a href="/{{ article.blog.userinfo.username }}/article/{{ article.pk }}">{{ article.title }}</a></td>
                <td>{{ article.create_time|date:'Y-m-d H:i:s' }}</td>
                <td>{{ article.commit_num }}</td>
                <td>{{ article.up_num }}</td>
                <td><a href="">修改</a></td>
                <td><a href="">删除</a></td>
                </tr>
                {% endfor %}
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
```

***

| 路由 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    # p评论的路由
    url(r'^commit_content/$', views.commit_content),
    url(r'^backend/', views.backend),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- ←→C
- 127.0.0.1:8000/backend/
- 应用zabbix-api
- CanIUseiview组件IElement
- 操作
- 文章标题
- 发布时间
- 评论数
- 点赞数
- 修改
- 删除
- 添加文章
- 深入浅出～
- 2018-07-0302:55:42
- 7
- 1
- Golang简易入门教程一-面向对象篇
- 2018-07-2403:08:19
- 添加随笔
- 手摸手带你理解Vue响应式原理
- 2019-08-2303:09:09
- 其他操作
- 曾老湿
<!-- OCR_END -->

￼

***

| 添加标签和样式 |
| :--- |

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- 127.0.0.1:8000/backend/
- 应用zabbix-api
- CanIUseiview组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 文章标题
- 发布时间
- 评论数
- 点赞数
- 修改
- 删除
- 深入浅出～
- 2018-07-03 02:55:42
- 7
- 1
- 添加随笔
- Golang简易入门教程--面向对象篇
- 2018-07-2403:08:19
- 其他操作
- 手摸手带你理解Vue响应式原理
- 2019-08-2303:09:09
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- →C
- 127.0.0.1:8000/backend/
- 应用zabbix-api
- CanIUse
- iview
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 随笔页面
- 添加文章
- 添加随笔
- 其他操作
- 曾老湿
<!-- OCR_END -->

￼

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="/static/css/mycss.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <title>后台管理</title>
    <style>
        .head {
            height: 60px;
            background: aquamarine;
            margin-bottom: 20px;
        }
        .a1 {
            background: red;
            color: black;
        }
        .a2 {
            background: orange;
            color: black;
        }
        .a3 {
            background: yellow;
            color: black;
        }
        .a4 {
            background: lawngreen;
            color: black;
        }
        .a5 {
            background: #2aabd2;
            color: black;
        }
        .a6 {
            background: pink;
            color: black;
        }
        .a7 {
            background: lightcoral;
            color: black;
        }
        .a8 {
            background: gray;
            color: black;
        }
        .a9 {
            background: beige;
            color: black;
        }
    </style>
</head>
<body>
<div class="head">
    <p>后台管理</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne"
                               aria-expanded="true" aria-controls="collapseOne">
                                操作
                            </a>
                        </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">添加文章</a>
                        </div>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">添加随笔</a>
                        </div>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">其他操作</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-9">
            <div>
                <!-- Nav tabs -->
                <ul class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a class="a1" href="#article" aria-controls="home" role="tab"
                                                              data-toggle="tab">文章</a></li>
                    <li role="presentation" class="nav2"><a class="a2" href="#note" aria-controls="profile"
                                                            role="tab" data-toggle="tab">随笔</a>
                    </li>
                    <li role="presentation" class="nav3"><a class="a3" href="#log" aria-controls="messages"
                                                            role="tab" data-toggle="tab">日志</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a4" href="#comment" aria-controls="settings"
                                                            role="tab" data-toggle="tab">评论</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a5" href="#linked" aria-controls="settings"
                                                            role="tab" data-toggle="tab">链接</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a6" href="#photo" aria-controls="settings"
                                                            role="tab" data-toggle="tab">相册</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a7" href="#file" aria-controls="settings"
                                                            role="tab" data-toggle="tab">文件</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a8" href="#settings" aria-controls="settings"
                                                            role="tab" data-toggle="tab">设置</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a9" href="#options" aria-controls="settings"
                                                            role="tab" data-toggle="tab">选项</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane active" id="article">
                        <table class="table table-hover table-striped">
                            <thead>
                            <tr>
                                <th>文章标题</th>
                                <th>发布时间</th>
                                <th>评论数</th>
                                <th>点赞数</th>
                                <th>修改</th>
                                <th>删除</th>
                            </tr>
                            </thead>
                            <tbody>
                            {% for article in article_list %}
                                <tr>
                                    <td>
                                        <a href="/{{ article.blog.userinfo.username }}/article/{{ article.pk }}">{{ article.title }}</a>
                                    </td>
                                    <td>{{ article.create_time|date:'Y-m-d H:i:s' }}</td>
                                    <td>{{ article.commit_num }}</td>
                                    <td>{{ article.up_num }}</td>
                                    <td><a href="">修改</a></td>
                                    <td><a href="">删除</a></td>
                                </tr>
                            {% endfor %}
                            </tbody>
                        </table>
                    </div>
                    <div role="tabpanel" class="tab-pane" id="note">随笔页面</div>
                    <div role="tabpanel" class="tab-pane" id="log">日志页面</div>
                    <div role="tabpanel" class="tab-pane" id="comment">评论页面</div>
                    <div role="tabpanel" class="tab-pane" id="linked">链接页面</div>
                    <div role="tabpanel" class="tab-pane" id="photo">相册页面</div>
                    <div role="tabpanel" class="tab-pane" id="file">文件页面</div>
                    <div role="tabpanel" class="tab-pane" id="settings">设置页面</div>
                    <div role="tabpanel" class="tab-pane" id="options">选项页面</div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

***

| 写成模板 |
| :--- |

back/backbase.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="/static/css/mycss.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <title>后台管理</title>
    <style>
        .head {
            height: 60px;
            background: aquamarine;
            margin-bottom: 20px;
        }
        .a1 {
            background: red;
            color: black;
        }
        .a2 {
            background: orange;
            color: black;
        }
        .a3 {
            background: yellow;
            color: black;
        }
        .a4 {
            background: lawngreen;
            color: black;
        }
        .a5 {
            background: #2aabd2;
            color: black;
        }
        .a6 {
            background: pink;
            color: black;
        }
        .a7 {
            background: lightcoral;
            color: black;
        }
        .a8 {
            background: gray;
            color: black;
        }
        .a9 {
            background: beige;
            color: black;
        }
    </style>
</head>
<body>
<div class="head">
    <p>后台管理</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne"
                               aria-expanded="true" aria-controls="collapseOne">
                                操作
                            </a>
                        </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">添加文章</a>
                        </div>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">添加随笔</a>
                        </div>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">其他操作</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-9">
            <div>
                <!-- Nav tabs -->
                <ul class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a class="a1" href="#article" aria-controls="home" role="tab"
                                                              data-toggle="tab">文章</a></li>
                    <li role="presentation" class="nav2"><a class="a2" href="#note" aria-controls="profile"
                                                            role="tab" data-toggle="tab">随笔</a>
                    </li>
                    <li role="presentation" class="nav3"><a class="a3" href="#log" aria-controls="messages"
                                                            role="tab" data-toggle="tab">日志</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a4" href="#comment" aria-controls="settings"
                                                            role="tab" data-toggle="tab">评论</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a5" href="#linked" aria-controls="settings"
                                                            role="tab" data-toggle="tab">链接</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a6" href="#photo" aria-controls="settings"
                                                            role="tab" data-toggle="tab">相册</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a7" href="#file" aria-controls="settings"
                                                            role="tab" data-toggle="tab">文件</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a8" href="#settings" aria-controls="settings"
                                                            role="tab" data-toggle="tab">设置</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a9" href="#options" aria-controls="settings"
                                                            role="tab" data-toggle="tab">选项</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane active" id="article">
                        {% block home %}
                        {% endblock %}
                    </div>
                    <div role="tabpanel" class="tab-pane" id="note">随笔页面</div>
                    <div role="tabpanel" class="tab-pane" id="log">日志页面</div>
                    <div role="tabpanel" class="tab-pane" id="comment">评论页面</div>
                    <div role="tabpanel" class="tab-pane" id="linked">链接页面</div>
                    <div role="tabpanel" class="tab-pane" id="photo">相册页面</div>
                    <div role="tabpanel" class="tab-pane" id="file">文件页面</div>
                    <div role="tabpanel" class="tab-pane" id="settings">设置页面</div>
                    <div role="tabpanel" class="tab-pane" id="options">选项页面</div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

back/backend.html

```plain
{% extends 'back/backbase.html' %}
{% block home %}
              <table class="table table-hover table-striped">
                            <thead>
                            <tr>
                                <th>文章标题</th>
                                <th>发布时间</th>
                                <th>评论数</th>
                                <th>点赞数</th>
                                <th>修改</th>
                                <th>删除</th>
                            </tr>
                            </thead>
                            <tbody>
                            {% for article in article_list %}
                                <tr>
                                    <td>
                                        <a href="/{{ article.blog.userinfo.username }}/article/{{ article.pk }}">{{ article.title }}</a>
                                    </td>
                                    <td>{{ article.create_time|date:'Y-m-d H:i:s' }}</td>
                                    <td>{{ article.commit_num }}</td>
                                    <td>{{ article.up_num }}</td>
                                    <td><a href="">修改</a></td>
                                    <td><a href="">删除</a></td>
                                </tr>
                            {% endfor %}
                            </tbody>
                        </table>
{% endblock %}
```

### 添加文章

***

| 视图 |
| :--- |

```plain
@login_required(login_url='/login/')
def add_article(request):
    if request.method == 'GET':
        return render(request,'back/add_article.html')
```

***

| 模板 |
| :--- |

back/backbase.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="/static/css/mycss.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
    <title>后台管理</title>
    <style>
        .head {
            height: 60px;
            background: aquamarine;
            margin-bottom: 20px;
        }
        .a1 {
            background: red;
            color: black;
        }
        .a2 {
            background: orange;
            color: black;
        }
        .a3 {
            background: yellow;
            color: black;
        }
        .a4 {
            background: lawngreen;
            color: black;
        }
        .a5 {
            background: #2aabd2;
            color: black;
        }
        .a6 {
            background: pink;
            color: black;
        }
        .a7 {
            background: lightcoral;
            color: black;
        }
        .a8 {
            background: gray;
            color: black;
        }
        .a9 {
            background: beige;
            color: black;
        }
    </style>
</head>
<body>
<div class="head">
    <p>后台管理</p>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne"
                               aria-expanded="true" aria-controls="collapseOne">
                                操作
                            </a>
                        </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="/add_article/">添加文章</a>
                        </div>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">添加随笔</a>
                        </div>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel"
                         aria-labelledby="headingOne">
                        <div class="panel-body">
                            <a href="">其他操作</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-9">
            <div>
                <!-- Nav tabs -->
                <ul class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a class="a1" href="#article" aria-controls="home" role="tab"
                                                              data-toggle="tab">文章</a></li>
                    <li role="presentation" class="nav2"><a class="a2" href="#note" aria-controls="profile"
                                                            role="tab" data-toggle="tab">随笔</a>
                    </li>
                    <li role="presentation" class="nav3"><a class="a3" href="#log" aria-controls="messages"
                                                            role="tab" data-toggle="tab">日志</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a4" href="#comment" aria-controls="settings"
                                                            role="tab" data-toggle="tab">评论</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a5" href="#linked" aria-controls="settings"
                                                            role="tab" data-toggle="tab">链接</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a6" href="#photo" aria-controls="settings"
                                                            role="tab" data-toggle="tab">相册</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a7" href="#file" aria-controls="settings"
                                                            role="tab" data-toggle="tab">文件</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a8" href="#settings" aria-controls="settings"
                                                            role="tab" data-toggle="tab">设置</a>
                    </li>
                    <li role="presentation" class="nav4"><a class="a9" href="#options" aria-controls="settings"
                                                            role="tab" data-toggle="tab">选项</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane active" id="article">
                        {% block home %}
                        {% endblock %}
                    </div>
                    <div role="tabpanel" class="tab-pane" id="note">随笔页面</div>
                    <div role="tabpanel" class="tab-pane" id="log">日志页面</div>
                    <div role="tabpanel" class="tab-pane" id="comment">评论页面</div>
                    <div role="tabpanel" class="tab-pane" id="linked">链接页面</div>
                    <div role="tabpanel" class="tab-pane" id="photo">相册页面</div>
                    <div role="tabpanel" class="tab-pane" id="file">文件页面</div>
                    <div role="tabpanel" class="tab-pane" id="settings">设置页面</div>
                    <div role="tabpanel" class="tab-pane" id="options">选项页面</div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

```plain
{% extends 'back/backbase.html' %}
{% block home %}
<div>
<p>添加文章</p>
    <form action="/add_article/" method="post">
        <div>
            <p>标题</p>
            <p><input type="text" name="title" class="form-control"></p>
            <p>内容(KindEditor编辑器，不支持拖放/粘贴上传图片)</p>
            <p>
                <textarea name="" id="" cols="30" rows="10"></textarea>
            </p>
            <input type="submit" class="btn btn-danger" value="发表">
        </div>
    </form>
</div>
{% endblock %}
```

***

| 路由 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    # p评论的路由
    url(r'^commit_content/$', views.commit_content),
    url(r'^backend/', views.backend),
    url(r'^add_article/', views.add_article),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- 127.0.0.1:8000/add_article/
- 应用
- zabbix-api
- CanlUse
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 标题
- 添加随笔
- 其他操作
- 内容（KindEditor编辑器，不支持拖放/粘贴上传图片）
- 发表
- 曾老湿
<!-- OCR_END -->

￼

### 富文本编辑器

***

| 介绍 |
| :--- |

KindEditor官网：[TP](http://kindeditor.net/demo.php)

KindEditor下载：[TP](http://kindeditor.net/down.php)

KindEditor使用：[TP](http://kindeditor.net/doc.php)

下载下来是一个zip包，解压开是一个目录，直接放在static目录下

<!-- OCR_START -->
- static
- csS
- font
- img
- kindeditor
<!-- OCR_END -->

￼

***

| 使用 |
| :--- |

```plain
{% extends 'back/backbase.html' %}
{% block home %}
    <div>
        <p>添加文章</p>
        <form action="/add_article/" method="post">
            <div>
                <p>标题</p>
                <p><input type="text" name="title" class="form-control"></p>
                <p>内容(KindEditor编辑器，不支持拖放/粘贴上传图片)</p>
                <p>
                    <textarea id="editor_id" name="content" style="width:700px;height:300px;"></textarea>
                </p>
                <input type="submit" class="btn btn-danger" value="发表">
            </div>
        </form>
    </div>
    <script charset="utf-8" src="/static/kindeditor/kindeditor-all-min.js"></script>
    <script charset="utf-8" src="/static/kindeditor/lang/zh-CN.js"></script>
    <script>
        KindEditor.ready(function (K) {
            window.editor = K.create('#editor_id', {
                width: '100%',
                height: '600px',
                resizeType: 0
            });
        });
    </script>
{% endblock %}
```

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- 127.0.0.1:8000/add_article/
- 应用
- zabbix-api
- CanIUse
- iview
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 标题
- 添加随笔
- 其他操作
- 内容（KindEditor编辑器，不支持拖放/粘贴上传图片）
- H1-F-T-A
- AB
- 曾老湿
- 发表
<!-- OCR_END -->

￼

***

| 提交数据 |
| :--- |

```plain
{% extends 'back/backbase.html' %}
{% block home %}
    <div>
        <p>添加文章</p>
        <form action="/add_article/" method="post">
            {% csrf_token %}
            <div>
                <p>标题</p>
                <p><input type="text" name="title" class="form-control"></p>
                <p>内容(KindEditor编辑器，不支持拖放/粘贴上传图片)</p>
                <p>
                    <textarea id="editor_id" name="content" style="width:700px;height:300px;"></textarea>
                </p>
                <input type="submit" class="btn btn-danger" value="发表">
            </div>
        </form>
    </div>
    <script charset="utf-8" src="/static/kindeditor/kindeditor-all-min.js"></script>
    <script charset="utf-8" src="/static/kindeditor/lang/zh-CN.js"></script>
    <script>
        KindEditor.ready(function (K) {
            window.editor = K.create('#editor_id', {
                width: '100%',
                height: '600px',
                resizeType: 0
            });
        });
    </script>
{% endblock %}
```

```plain
@login_required(login_url='/login/')
def add_article(request):
    if request.method == 'GET':
        return render(request, 'back/add_article.html')
    elif request.method == 'POST':
        title = request.POST.get('title')
        content = request.POST.get('content')
        desc = content[0:150]
        blog =  request.user.blog
        models.Article.objects.create(title=title, desc=desc, content=content,blog=blog)
        return redirect('/backend/')
```

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- 127.0.0.1:8000/add_article/
- 应用
- zabbix
- CanlUse
- iview
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 标题
- 添加随笔
- 曾老湿第一次发布博客
- 其他操作
- 内容（KindEditor编辑器，不支持拖放/粘贴上传图片）
- H1FAAB
- 好特么的紧张啊~~
- 哎哎哎
- 啦啦啦
- 发表
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- →C
- 127.0.0.1:8000/backend/
- 9
- 应用
- zabbix-api
- CanlUseiview
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 文章标题
- 发布时间
- 评论数
- 点赞数
- 修改
- 删除
- 深入浅出～
- 2018-07-0302:55:42
- 7
- 1
- 添加随笔
- Golang简易入门教程--面向对象篇
- 2018-07-2403:08:19
- 其他操作
- 手摸手带你理解Vue响应式原理
- 2019-08-2303:09:09
- 曾老湿第一次发布博客
- 2020-06-2323:47:59
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- zls-的个人博客
- 选择评论表来修改|Django站：×
- ←→C
- 127.0.0.1:8000/zls/article/6
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 这里是博客站点的标题
- 我的标签
- 曾老湿第一次发布博客
- 好特么的紧张啊~
- zls的标签1（2）
- zls的标签2(1)
- 哎哎哎
- 我的分类
- zls的分类1(2)
- 啦啦啦
- zls的分类2(1)
- 推荐
- 反对
- 随笔档案
- 发表评论
- 2018年07月（2）
- 2019年08月（1)
- 昵称：曾老湿
- 评论内容：
- 2020年06月（1）
- 提交
- 曾老湿
<!-- OCR_END -->

￼

***

| 上传图片 |
| :--- |

上传文件教程：[TP](http://kindeditor.net/docs/upload.html)

```plain
{% extends 'back/backbase.html' %}
{% block home %}
    <div>
        <p>添加文章</p>
        <form action="/add_article/" method="post">
            {% csrf_token %}
            <div>
                <p>标题</p>
                <p><input type="text" name="title" class="form-control"></p>
                <p>内容(KindEditor编辑器，不支持拖放/粘贴上传图片)</p>
                <p>
                    <textarea id="editor_id" name="content" style="width:700px;height:300px;"></textarea>
                </p>
                <input type="submit" class="btn btn-danger" value="发表">
            </div>
        </form>
    </div>
    <script charset="utf-8" src="/static/kindeditor/kindeditor-all-min.js"></script>
    <script charset="utf-8" src="/static/kindeditor/lang/zh-CN.js"></script>
    <script>
        KindEditor.ready(function (K) {
            window.editor = K.create('#editor_id', {
                width: '100%',
                height: '600px',
                resizeType: 0,
                uploadJson: '/upload_img/', // 需要添加一个路由
                extraFileUploadParams:{
                    'csrfmiddlewaretoken':'{{ csrf_token }}'
                },
                filePostName:'myfile',
            });
        });
    </script>
{% endblock %}
```

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
from django.db.models.functions import TruncMonth
from django.contrib.auth.decorators import login_required
import json
from django.db import transaction
from django.db.models import F
import os
from bbs import settings
def upload_img(request):
    myfile = request.FILES.get('myfile')
    path = os.path.join(settings.BASE_DIR, 'media', 'img')
    if not os.path.isdir(path):
        os.mkdir(path)
    file_path = os.path.join(path, myfile.name)
    with open(file_path, 'wb', ) as f:
        for line in myfile:
            f.write(line)
    dic = {'error': 0, 'url': '/media/img/%s' % myfile.name}
    return JsonResponse(dic)
```

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    # p评论的路由
    url(r'^commit_content/$', views.commit_content),
    url(r'^backend/', views.backend),
    url(r'^add_article/', views.add_article),
    # 富文本编辑器上床图片
    url(r'^upload_img/', views.upload_img),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

<!-- OCR_START -->
- 127.0.0.1:8000/add_article/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Elem
- 台管理
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 标题
- 添加随笔
- 其他操作
- 内容（KindEditor编辑器，不支持拖放/粘贴上传图片）
- B口
- H1-F
- A-
- 图片
- 网络图片
- 本地上传
- 上传文件
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/add_article/
- 应用
- zabbix-api
- CanIUse
- iview
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 标题
- 添加随笔
- 上传图片试一下子
- 其他操作
- 内容（KindEditor编辑器，不支持拖放/粘贴上传图片）
- H1-F-T-
- 阿拉雷雷~N
- 上传图片
- 曾老湿
- 发表
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×|
- 别离开我啊，小老弟，点回来~
- →C
- 127.0.0.1:8000/backend/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 文章标题
- 发布时间
- 评论数
- 点赞数
- 修改
- 删除
- 深入浅出~
- 2018-07-0302:55:42
- 7
- 1
- 添加随笔
- Golang简易入门教程一-面向对象篇
- 2018-07-2403:08:19
- 其他操作
- 手摸手带你理解Vue响应式原理
- 2019-08-2303:09:09
- 曾老湿第一次发布博客
- 2020-06-2323:47:59
- 上传图片试一下子
- 2020-06-2400:11:12
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- zls-的个人博客
- 选择评论表来修改|Django站×|
- 别离开我啊，小老弟，点回来～
- →C
- 127.0.0.1:8000/zls/article/7
- 应用zabbix-api
- CanIUse
- iview组件|Element
- 这里是博客站点的标题
- 我的标签
- 上传图片试一下子
- zls的标签1(2)
- zls的标签2(1)
- 我的分类
- zls的分类1(2)
- zls的分类2（1)
- 随笔档案
- 2018年07月（2）
- 2019年08月（1）
- 阿拉雷雷~~~~上传图片
- 2020年06月（2）
- 心推荐
- 反对
- 发表评论
- 昵称：曾老湿
- 评论内容：
- 曾老湿
- 提交
<!-- OCR_END -->

￼

### 文章描述截取文字

<!-- OCR_START -->
- zls-的个人博客
- 选择评论表来修改|Django站×
- 127.0.0.1:8000/zls/archive/2020-06
- 9
- 应用zabbix-api
- CanIUseiview组件IElement
- 这里是博客站点的标题
- 我的标签
- 曾老湿第一次发布博客
- 好特么的紧张啊~
- zls的标签1(2)
- posted @ 2020-0
- 23:47:59zls评论（0）点赞（0）编辑
- zls的标签2（1)
- 上传图片试一下子
- 我的分类
- <img src="/media/img/touxiang.ipegalt=/>阿拉雷雷~~~~上传图片
- zls的分类1(2)
- posted@2020-06-2400:11:12zls评论（0）点赞（0）编辑
- 曾老湿
- 2(1)
<!-- OCR_END -->

￼

***

| 使用BeautifulSoup4 |
| :--- |

简称BS4，专门解析html网页的，爬虫会用到

```plain
MacBook-pro:auth_module driverzeng$ pip3 install BeautifulSoup4  -i https://mirrors.aliyun.com/pypi/simple/
```

```plain
## 导入模块
from bs4 import BeautifulSoup
```

***

| 视图层 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
from django.db.models.functions import TruncMonth
from django.contrib.auth.decorators import login_required
import json
from django.db import transaction
from django.db.models import F
import os
from bbs import settings
from bs4 import BeautifulSoup
@login_required(login_url='/login/')
def add_article(request):
    if request.method == 'GET':
        return render(request, 'back/add_article.html')
    elif request.method == 'POST':
        title = request.POST.get('title')
        content = request.POST.get('content')
        ## 第一个参数，被解析对象，第二个参数，选择解析器
        soup = BeautifulSoup(content,'html.parser')
        ## 取出html标签中的文本内容
        ## soup.text
        desc = soup.text[0:150]
        blog = request.user.blog
        models.Article.objects.create(title=title, desc=desc, content=content, blog=blog)
        return redirect('/backend/')
```

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×|
- 别离开我啊，小老弟，点回来～
- →C
- 0127.0.0.1:8000/add_article/
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 标题
- 添加随笔
- 测试
- 其他操作
- 内容（KindEditor编辑器，不支持拖放/粘贴上传图片）
- 三三
- H1-
- FTAABIU
- 这篇文章还会被XSS攻击
- 这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击
- 这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击
- 这篇文章还会被XSS攻击这篇文章还会被XSS攻击这篇文章还会被XSS攻击
- 曾老湿
- 发表
<!-- OCR_END -->

￼

我们点击文章的源码，然后在文章源码中，写js代码`alert(xxx)`，因为html的页面会被soup解析。所以这个语法也会被解析。那网站....

<!-- OCR_START -->
- 后台管理
- 选择评论表来修改|Django站×|
- 别离开我啊，小老弟，点回来～
- C127.0.0.1:8000/add_article/
- 应用zabbix-api
- CanlUse
- 7iview
- 组件|Elen
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 标题
- 添加随笔
- 测试
- 其他操作
- 内容（KindEditor编辑器，不支持拖放/粘贴上传图片）
- H1FT|AABII
- 
- 这篇文章还会被xSS攻击
- 这篇文章还会被xSS攻击这篇文章还会被xSS攻击这篇文章还会被xSS攻击这篇文章还会被xSS攻击这篇文章还会被xSS攻击
- 这篇文章还会被XSS攻击这篇文章还会被XSS攻击
- 这篇文章还会被xSS攻击这篇文章还会被xSS攻击这篇文章还会被xSS攻击
- 这篇文章还会被XSS攻击</span
- 这篇文章还会被xSS攻击<spo
- 这篇文章还会被XSS攻击这篇文章还会被xSS攻击这篇文章还会被xSS攻击
- 
- 
- <script>alter('曾老湿xsS攻击）</script>
- 曾老湿
- 发表
<!-- OCR_END -->

￼

点开文章，先解析了js语法，弹窗，然后再出来文章页面

<!-- OCR_START -->
- zls-的个人博客
- 选择评论表来修改|Django站×
- 别离开我啊，小老弟，点回来~
- →X127.0.0.1:8000/zls/article/9
- 9
- 应用zabbix-api
- CanlUseiview组件IElement
- 127.0.0.1:8000显示
- 曾老湿XSS攻击
- 确定
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- zls-的个人博客
- 选择评论表来修改|Django站×|
- 别离开我啊，小老弟，点回来～
- ←→C
- 127.0.0.1:8000/zls/article/9
- 9
- 应用zabbix-api
- CanIUseiview组件IElement
- 这里是博客站点的标题
- 我的标签
- 测试
- 这篇文章会被XSS攻击这篇文章会被XSS攻击这篇文章会被XSS攻击这篇文章会被XSS攻击这篇文章会被XSS攻击
- zls的标签1(2)
- 这篇文章会被XSS攻击这篇文章会被XSS攻击这篇文章会被XSS攻击
- zls的标签2(1)
- 我的分类
- 这篇文章会被XSS攻击这篇文章会被XSS攻击
- zls的分类1(2)
- 这篇文章会被XSS攻击
- zls的分类2（1)
- 推荐
- 反对
- 随笔档案
- 发表评论
- 2018年07月（2）
- 昵称：曾老湿
- 2019年08月（1）
- 评论内容：
- 2020年06月（4）
- 提交
- 曾老湿
<!-- OCR_END -->

￼

### 处理XSS攻击

***

| 使用bs4处理 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
from django.db.models.functions import TruncMonth
from django.contrib.auth.decorators import login_required
import json
from django.db import transaction
from django.db.models import F
import os
from bbs import settings
from bs4 import BeautifulSoup
@login_required(login_url='/login/')
def add_article(request):
    if request.method == 'GET':
        return render(request, 'back/add_article.html')
    elif request.method == 'POST':
        title = request.POST.get('title')
        content = request.POST.get('content')
        ## 第一个参数，被解析对象，第二个参数，选择解析器
        soup = BeautifulSoup(content,'html.parser')
        ## 查询出所有的标签
        tags = soup.find_all()
        ## 循环标签，找到script就删除
        for tag in tags:
            if tag.name == 'script':
                ## 删除标签
                tag.decompose()
        ## 取出html标签中的文本内容
        ## soup.text
        desc = soup.text[0:150]
        blog = request.user.blog
        models.Article.objects.create(title=title, desc=desc, content=content, blog=blog)
        return redirect('/backend/')
```

## Django发送邮件

***

| 导入模块 |
| :--- |

```plain
from django.core.mail import send_mail
```

***

| Django 发邮件 |
| :--- |

需要在settings中设置一下内容

```plain
# EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.qq.com'
EMAIL_PORT = 465
EMAIL_HOST_USER = '253097001@qq.com'  # 帐号
EMAIL_HOST_PASSWORD = '***'  # 密码
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
#这样收到的邮件，收件人处就会这样显示
#DEFAULT_FROM_EMAIL = 'zls<'253097001@qq.com>'
EMAIL_USE_SSL = True   #使用ssl
#EMAIL_USE_TLS = False # 使用tls
#EMAIL_USE_SSL 和 EMAIL_USE_TLS 是互斥的，即只能有一个为 True
```

<!-- OCR_START -->
邮箱首页
设置
换肤
POP3/IMAP/SMTP/Exchange/CardDAV/CaIDAV服务
开启服务：
POP3/SMTP服务（如何使用Foxmail等软件收发邮件？）
已开启|关闭
IMAP/SMTP服务（什么是IMAP，它又是如何设置？）
Exchange服务（什么是Exchange，它又是如何设置？）
已关闭|开启
CardDAV/CaIDAV服务（什么是CardDAV/CaIDAV，它又是如何设置？）
（POP3/IMAP/SMTP/CardDAV/CaIDAV服务均支持SSL连接。如何设置？）
温馨提示：在第三方登录QQ邮箱，可能存在邮件泄露风险，甚至危害AppleID安全，建议使用QQ邮箱手机版登录。
继续获取授权码登录第三方客户端邮箱?。
生成授权码
收取选项：
最近30天
的邮件
收取“我的文件夹”
收取“QQ邮件订阅”
SMTP发信后保存到服务器
（以上收取选项对POP3/IMAP/SMTP/Exchange均生效。了解更多）
收取垃圾邮件隔离提醒
曾老湿
（该收取选项只对POP3生效。我使用了IMAP/Exchange协议，怎么办？）
DriverZeng
<!-- OCR_END -->

￼

***

| 评论发邮件 |
| :--- |

```plain
def commit_content(request):
    response = {'status': 100, 'msg': None}
    if request.is_ajax():
        if request.user.is_authenticated():
            # 核心逻辑
            user = request.user
            article_id = request.POST.get('article_id')
            content = request.POST.get('content')
            pid = request.POST.get('pid')
            print(pid)
            with transaction.atomic():
                ret = models.Commit.objects.create(user=user, article_id=article_id, content=content, parent_id_id=pid)
                models.Article.objects.filter(pk=article_id).update(commit_num=F('commit_num') + 1)
            response['msg'] = '评论成功'
            response['content'] = ret.content
            # 把datetime类型转成字符串,因为json是无法序列化datetime
            response['time'] = ret.create_time.strftime('%Y-%m-%d %X')
            response['user_name'] = ret.user.username
            if pid:
                # 如果是字评论,返回父评论的名字
                response['parent_name'] = ret.parent.user.username
                ## 评论成功，发送邮件
                '''
                subject:邮件标题
                message:邮件内容
                from_email:邮件发送者
                recipient_list:接收者列表
                '''
            from bbs import settings
            ## 拿到文章标题
            article_name = ret.article.title
            ## 被当前登录人评论
            user_name = request.user.username
            ## 有返回值，邮件发送成功是true
            res = send_mail('您的《%s》文章被[%s]评论了' % (article_name, user_name), '这个人评论内容：%s' % content,
                            settings.EMAIL_HOST_USER, ['133411023@qq.com'])
            print(res)
        else:
            response['status'] = 101
            response['msg'] = '您没有登录'
    else:
        response['status'] = 101
        response['msg'] = '您请求非法'
    return JsonResponse(response)
```

<!-- OCR_START -->
- zls-的个人博客
- QQ邮箱
- →C
- 127.0.0.1:8000/zls/article/1
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 2019年08月（1）
- #4楼2020-06-2315:47:28zls
- 回复
- 2020年06月（5）
- 安安
- #5楼2020-06-2315:55:13zls
- aaaa
- #6楼2020-06-2315:59:22zls
- hello
- #7楼2020-06-2316:00:12zls
- test
- #8楼2020-06-2412:14:59 zls
- 你好帅～大佬
- #9楼2020-06-2412:20:02zls
- 来啊造作呀
- #10楼2020-06-2412:24:14zls
- 哎哎哎
- zls:2020-06-2412:28:49
- 哎哎哎哎哎哎啊啊啊啊
- 发表评论
- 昵称：曾老湿
- 评论内容：
- 曾老湿～你好帅啊啊啊啊啊啊啊啊啊啊啊啊。迷妹爱爱爱
- 曾老湿
- 提交
<!-- OCR_END -->

￼

<!-- OCR_START -->
- zls-的个人博客
- 您的《深入浅出~》文章被[zls]×
- mail.q.com/cgi-bin/frame_html?sid=Bco4W_s92SrYaG8x&r=0623fff8c37afce5865e2b8f6c2cc010
- 应用
- zabbix-api
- CanlUseiview组件IElement
- <1>
- 丨反馈建议|帮助中心|退出
- MOilQQ邮箱
- 邮箱首页|设置-换肤
- Q邮件全文搜索
- 写信
- 《返回回复回复全部转发删除彻底删除举报拒收标记为移动到
- 上一封下一封
- 收信
- 您的《深入浅出~》文章被[zls]评论了☆
- 通讯录
- 发件人：>
- 时间：2020年6月24日（星期三）下午12：31
- 收件箱（214）
- 收件人：<133411023@qq.com>
- 纯文本|
- 星标邮件★
- 群邮件（3）
- 这个人评论内容：曾老湿～你好帅啊啊啊啊啊啊啊啊啊啊啊啊。迷妹爱爱爱
- 草稿箱
- 已发送
- 已删除
- [清空]
- 曾老湿
<!-- OCR_END -->

￼

***

| 多线程 |
| :--- |

发邮件是一个同步的操作 ，所以... 我们要开启多线程操作

```plain
from django.shortcuts import render, HttpResponse, redirect
from PIL import Image, ImageDraw, ImageFont
import random
from io import BytesIO
from django.contrib import auth
from django.http import JsonResponse
from blog import myforms
from blog import models
from django.db.models import Count
from django.db.models.functions import TruncMonth
from django.contrib.auth.decorators import login_required
import json
from django.db import transaction
from django.db.models import F
import os
from bbs import settings
from bs4 import BeautifulSoup
from django.core.mail import send_mail
def commit_content(request):
    response = {'status': 100, 'msg': None}
    if request.is_ajax():
        if request.user.is_authenticated():
            # 核心逻辑
            user = request.user
            article_id = request.POST.get('article_id')
            content = request.POST.get('content')
            pid = request.POST.get('pid')
            print(pid)
            with transaction.atomic():
                ret = models.Commit.objects.create(user=user, article_id=article_id, content=content, parent_id_id=pid)
                models.Article.objects.filter(pk=article_id).update(commit_num=F('commit_num') + 1)
            response['msg'] = '评论成功'
            response['content'] = ret.content
            # 把datetime类型转成字符串,因为json是无法序列化datetime
            response['time'] = ret.create_time.strftime('%Y-%m-%d %X')
            response['user_name'] = ret.user.username
            if pid:
                # 如果是字评论,返回父评论的名字
                response['parent_name'] = ret.parent.user.username
                ## 评论成功，发送邮件
                '''
                subject:邮件标题
                message:邮件内容
                from_email:邮件发送者
                recipient_list:接收者列表
                '''
            from bbs import settings
            ## 拿到文章标题
            # article_name = ret.article.title
            #
            # ## 被当前登录人评论
            # user_name = request.user.username
            #
            # ## 有返回值，邮件发送成功是true
            # res = send_mail('您的《%s》文章被[%s]评论了' % (article_name, user_name), '这个人评论内容：%s' % content,
            #                 settings.EMAIL_HOST_USER, ['133411023@qq.com'])
            # print(res)
            from threading import Thread
            article_name = ret.article.title
            user_name = request.user.username
            ## 实例化
            t1 = Thread(target=send_mail, args=('您的《%s》文章被[%s]评论了' % (article_name, user_name), '这个人评论内容：%s' % content,
                                           settings.EMAIL_HOST_USER, ['133411023@qq.com']))
            t1.start()
        else:
            response['status'] = 101
            response['msg'] = '您没有登录'
    else:
        response['status'] = 101
        response['msg'] = '您请求非法'
    return JsonResponse(response)
```

### 修改头像

***

| 模板层 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>修改头像</title>
</head>
<body>
<form action="" method="post" enctype="multipart/form-data">
    {% csrf_token %}
    <input type="file" name="head">
    <input type="submit" value="提交">
</form>
</body>
</html>
```

***

| 路由 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    # p评论的路由
    url(r'^commit_content/$', views.commit_content),
    url(r'^backend/', views.backend),
    url(r'^add_article/', views.add_article),
    # 富文本编辑器上床图片
    url(r'^upload_img/', views.upload_img),
    ## 修改头像
    url(r'^update_head/', views.update_head),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

***

| 视图 |
| :--- |

```plain
@login_required
def update_head(request):
    if request.method == 'GET':
        return render(request,'update_head.html')
    else:
        myfile = request.FILES.get('head')
        ## 可以只删除数据库的地址，不删实际文件
        user = request.user
        user.avatar=myfile
        user.save()
        ret = #models.UserInfo.objects.filter(pk=request.user.pk).update(avatar=myfile)
        return redirect('/index/')
```

<!-- OCR_START -->
- 修改头像
- 您的《深入浅出~》文章被[zls]词×
- →C
- 127.0.0.1:8000/update_head/
- 9
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 选择文件51devops.png
- 提交
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
博客
您的《深入浅出~》文章被[zls]×
127.0.0.1:8000/index/
应用
zabbix-api
CanIUse
iview
组件|Element
曾老湿博客系统
文章
随笔
zls
个人中心
重金求子
深入浅出~
日韩系列
这里是文章描述15字，15字，15字，15字，15字，15字，15字，15字
请联系：13800000000
TokyoHot
年入60w
zls发布于2018-07-0302:55:42
评论（14）点赞（1）
欧美系列
草榴社区
Golang简易入门教程一一面向对象篇
金八天国
请点击跳转
本文始发于个人公众号：TechFlow，原创不易，求个关注今天是golang专题的第9篇文章，我们一起来看看golang当中的面向对象的部分。在
现在高级语言当中，面向对象几乎是不可或缺也是一门语言最重要的部分之一。golang作为一门刚刚诞生十年的新兴语言自然是支持面向对象
动漫卡通
的，但是golang当...
zls发布于2018-07-2403:08:19评论（0）点赞（1)）
女仆
手摸手带你理解Vue响应式原理
精品图区
前言响应式原理作为Vue的核心，使用数据劫持实现数据驱动视图。在面试中是经常考查的知识点，也是面试加分项。本文将会循序渐进的解
析响应式原理的工作流程，主要以下面结构进行：分析主要成员，了解它们有助于理解流程将流程拆分，理解其中的作用结合以上的点，理解
美腿丝袜
整体流程文章稍长，但大部分是代码实
曾老湿
发布于2019-08-2303:09:09评论（0）点赞（1）
<!-- OCR_END -->

￼

### 文章编辑

***

| 路由层 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    # p评论的路由
    url(r'^commit_content/$', views.commit_content),
    url(r'^backend/', views.backend),
    url(r'^add_article/', views.add_article),
    # 富文本编辑器上床图片
    url(r'^upload_img/', views.upload_img),
    ## 修改头像
    url(r'^update_head/', views.update_head),
    ##修改文章
    url(r'^update_article/(?P<pk>\d+)', views.update_article),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

***

| 视图层 |
| :--- |

```plain
def update_article(request,pk):
    if request.method == 'GET':
        article = models.Article.objects.get(pk=pk)
        return render(request,'back/update_article.html',{'article':article})
```

***

| 模板层 |
| :--- |

backend.html

```plain
{% extends 'back/backbase.html' %}
{% block home %}
              <table class="table table-hover table-striped">
                            <thead>
                            <tr>
                                <th>文章标题</th>
                                <th>发布时间</th>
                                <th>评论数</th>
                                <th>点赞数</th>
                                <th>修改</th>
                                <th>删除</th>
                            </tr>
                            </thead>
                            <tbody>
                            {% for article in article_list %}
                                <tr>
                                    <td>
                                        <a href="/{{ article.blog.userinfo.username }}/article/{{ article.pk }}">{{ article.title }}</a>
                                    </td>
                                    <td>{{ article.create_time|date:'Y-m-d H:i:s' }}</td>
                                    <td>{{ article.commit_num }}</td>
                                    <td>{{ article.up_num }}</td>
                                    <td><a href="/update_article/{{ article.pk }}">修改</a></td>
                                    <td><a href="">删除</a></td>
                                </tr>
                            {% endfor %}
                            </tbody>
                        </table>
{% endblock %}
```

back/update_article.html

```plain
{% extends 'back/backbase.html' %}
{% block home %}
    <div>
        <p>修改文章</p>
        <form action="/add_article/" method="post">
            {% csrf_token %}
            <div>
                <p>标题</p>
                <p><input type="text" name="title" class="form-control" value="{{ article.title }}"></p>
                <p>内容(KindEditor编辑器，不支持拖放/粘贴上传图片)</p>
                <p>
                    <textarea id="editor_id" name="content" rows="10" value="{{ article.content|safe }}"></textarea>
                </p>
                <input type="submit" class="btn btn-danger" value="发表">
            </div>
        </form>
    </div>
    <script charset="utf-8" src="/static/kindeditor/kindeditor-all-min.js"></script>
    <script charset="utf-8" src="/static/kindeditor/lang/zh-CN.js"></script>
    <script>
        KindEditor.ready(function (K) {
            window.editor = K.create('#editor_id', {
                width: '100%',
                height: '600px',
                resizeType: 0,
                uploadJson: '/upload_img/', // 需要添加一个路由
                extraFileUploadParams:{
                    'csrfmiddlewaretoken':'{{ csrf_token }}'
                },
                filePostName:'myfile',
            });
        });
    </script>
{% endblock %}
```

<!-- OCR_START -->
- 后台管理
- 您的《深入浅出~》文章被[zls]×
- ←→C
- 127.0.0.1:8000/backend/
- 应用zabbix-apiCanlUseiview
- 组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 添加文章
- 文章标题
- 发布时间
- 评论数
- 点赞数
- 修改
- 删除
- 深入浅出～
- 2018-07-0302:55:42
- 14
- 1
- 添加随笔
- Golang简易入门教程一-面向对象篇
- 2018-07-2403:08:19
- 其他操作
- 手摸手带你理解Vue响应式原理
- 2019-08-2303:09:09
- 曾老湿第一次发布博客
- 2020-06-23 23:47:59
- 上传图片试一下子
- 2020-06-2400:11:12
- 测试
- 2020-06-2400:27:04
- 2020-06-2400:28:32
- 查查次次错错错错错错错
- 2020-06-2400:40:09
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 后台管理
- 您的《深入浅出~》文章被[zls]×
- →C
- 127.0.0.1:8000/update_article/7
- 应用zabbix-api
- CanlUse
- iview组件|Element
- 操作
- 文章
- 随笔
- 日志
- 评论
- 链接
- 相册
- 文件
- 设置
- 选项
- 修改文章
- 添加文章
- 标题
- 添加随笔
- 上传图片试一下子
- 其他操作
- 内容（KindEditor编辑器，不支持拖放/粘贴上传图片）
- H1-F-T-A
- 阿拉雷雷~
- ~上传图片
- 发表
- 曾老湿
<!-- OCR_END -->

￼

***

| AJAX方法渲染页面 |
| :--- |

back/update_article.html

```plain
{% extends 'back/back_base.html' %}
{% block home %}
    <div>
        <p>修改文章</p>
        <form action="/add_article/" method="post">
            {% csrf_token %}
            <p>标题</p>
            <p><input type="text" name="title" class="form-control" id="title" article_id="{{ article_id }}"></p>
            <p>内容(KindEdit编辑器，不支持拖放/粘贴上传图片)</p>
            <p>
             <textarea name="content" id="editor_id" cols="30" rows="10">
                </textarea>
            </p>
            <input type="submit" class="btn btn-danger" value="提交">
        </form>
    </div>
    <script charset="utf-8" src="/static/kindeditor/kindeditor-all.js"></script>
    <script>
        KindEditor.ready(function (K) {
            window.editor = K.create('#editor_id', {
                width: '100%',
                height: '500px',
                //item 控制要显示的控件
                //控制控件不能拖动
                resizeType: 0,
                //上传图片,uploadJson 指的是上传的路径,也就是咱们的路由
                uploadJson: '/upload_img/',
                //添加一些额外的参数
                extraFileUploadParams: {
                    'csrfmiddlewaretoken': '{{ csrf_token }}',
                    'article_id': '1'
                },
                //修改默认上传文件的名字
                filePostName: 'myfile'
            })
        });
        //当页面加载完成以后,发ajax请求,拿回文章数据
        //jquery 的页面加载完成
        $(function () {
            var id = $("#title").attr('article_id')
            $.ajax({
                url: '/get_article/' + '{{ article_id }}',
                type: 'get',
                success: function (data) {
                    console.log(data)
                    $("#title").val(data.title)
                    // 设置HTML内容
                    window.editor.html(data.content);
                }
            })
        })
        /*
        window.onload = function () {
            //拿到我隐藏的id
            var id = $("#title").attr('article_id')
            $.ajax({
                url: '/get_article/' + '{{ article_id }}',
                type: 'get',
                success: function (data) {
                    console.log(data)
                    $("#title").val(data.title)
                    // 设置HTML内容
                    window.editor.html(data.content);
                }
            })
        }
        */
    </script>
{% endblock %}
```

views.py

```plain
def update_article(request,pk):
    if request.method=='GET':
        return render(request,'back/update_article.html',{'article_id':pk})
def get_article(request,pk):
    article=models.Article.objects.get(pk=pk)
    return JsonResponse({'title':article.title,'content':article.content})
```

urls.py

```plain
from django.conf.urls import url
from django.contrib import admin
from blog import views
from django.views.static import serve
from bbs import settings
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/$', views.login),
    url(r'^get_valid_code/$', views.get_valid_code),
    url(r'^register/$', views.register),
    url(r'^check_username/$', views.check_username),
    url(r'^index/$', views.index),
    url(r'^logout/$', views.logout),
    ##  有名分组
    # 1.url第一个参数，正则表达式
    # 2.第二个参数，函数的内存地址
    # 3.第三个参数，字典，它会以关键字参数的形式传到(第二个参数)
    # 4.当从浏览器输入media/后面的路径会去settings.MEDIA_ROOT这个变量对应的文件夹下面去找对应的图片
    url(r'^media/(?P<path>.*)', serve,{'document_root':settings.MEDIA_ROOT}),
    ## 个人站点分类过路由
    # url(r'^(?P<username>[\w]+)/category/(?P<category_id>\d+)', views.user_blog),
    ## 个人站点标签过滤路由
    # url(r'^(?P<username>[\w]+)/tag/(?P<tag>\d+)', views.user_blog),
    # 点赞的路由
    url(r'^diggit/$', views.diggit),
    # p评论的路由
    url(r'^commit_content/$', views.commit_content),
    url(r'^backend/', views.backend),
    url(r'^add_article/', views.add_article),
    # 富文本编辑器上床图片
    url(r'^upload_img/', views.upload_img),
    ## 修改头像
    url(r'^update_head/', views.update_head),
    # 修改文章
    url(r'^update_article/(?P<pk>\d+)', views.update_article),
    # ajax获取文件的口
    url(r'^get_article/(?P<pk>\d+)', views.get_article),
    ## 路由三合一（分类，标签，随笔）
    # 分组分出三个，（用户名，category|tag|archive中的一个，可能是分类id  tagid或者时间）
    url(r'^(?P<username>[\w]+)/(?P<condition>category|tag|archive)/(?P<param>.*)', views.user_blog),
    url(r'^(?P<username>[\w]+)/article/(?P<id>\d+)', views.article_detail),
    # 放到最后,都匹配完成,没有匹配到,再匹配它
    url(r'^(?P<username>[\w]+)/$', views.user_blog),
]
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

QQ：133411023

> 更新: 2020-06-25 12:04:24  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/fmp7is>