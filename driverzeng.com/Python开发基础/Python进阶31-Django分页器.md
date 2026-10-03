# Python进阶31-Django 分页器

## Python进阶31-Django 分页器
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

+ [分页器](https://blog.driverzeng.com/zenglaoshi/5778.html#toc_0)
+ [话不多说...写他*的](https://blog.driverzeng.com/zenglaoshi/5778.html#toc_1)
+ [Django分页器使用](https://blog.driverzeng.com/zenglaoshi/5778.html#toc_2)
+ [终极分页器使用](https://blog.driverzeng.com/zenglaoshi/5778.html#toc_3)
+ [前端使用ajax后端写成装饰器](https://blog.driverzeng.com/zenglaoshi/5778.html#toc_4)

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

## 分页器
---

| 分页器介绍 |
| :--- |

介绍个p啊，不就是一堆数据不放在一页显示，放在好几页嘛...

具体长啥样？每个网站都不一样...

大概就是 ... 这样

￼

在页面显示分页数据，需要用到Django分页器组件

---

| 导入分页模块 |
| :--- |

```plain
from django.core.paginator import Paginator
Paginator对象：    paginator = Paginator(user_list, 10)
# per_page: 每页显示条目数量
# count:    数据总个数
# num_pages:总页数
# page_range:总页数的索引范围，如: (1,10),(1,200)
# page:     page对象    
page对象：page=paginator.page(1)
# has_next              是否有下一页
# next_page_number      下一页页码
# has_previous          是否有上一页
# previous_page_number  上一页页码
# object_list           分页之后的数据列表
# number                当前页
# paginator             paginator对象
```

## 话不多说...写他*的
---

| 创建项目 |
| :--- |

连接数据库创建表，直接使用sqllite数据库

```plain
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```

创建一张表，往里面多写点数据，然后我们才好分页

```plain
from django.db import models
# Create your models here.
class Book(models.Model):
    name  = models.CharField(max_length=32)
    price =  models.DecimalField(max_digits=5,decimal_places=2)
```

数据库迁移

```plain
MacBook-pro:fenye driverzeng$ python3 manage.py makemigrations app0
MacBook-pro:fenye driverzeng$ python3 manage.py migrate
```

<!-- OCR_START -->
- fenyeapp01models.py
- dj
- #CCE
- Project
- models.py
- urls.pyx
- Database
- mProjects/fenye
- from django.db import models
- app01
- #Create your models here.
- migrations
- _init_.py
- schemas
- admin.py
- models.CharField（m
- price=models.DecimalField（max digits=5,decimal _places=2）
- ngth=32)
- apps.py
- app01_book
- auth_group
- tests.py
- auth_group_permissions
- views.py
- auth_permission
- auth_user
- auth_user_groups
- settings.py
- auth_user_user_permissions
- urls.py
- django_admin_log
- django_content.type
- wsgi.py
- django_migrations
- templates
- db.sqlite3
- django_session
- sqlite_master
- manage.py
- IliExternal Libraries
- sqlite_sequence
- Scratches and Consoles
- collations3
- 曾老湿
<!-- OCR_END -->

￼

---

| 批量插入数据 |
| :--- |

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^index/', views.index),
]
```

```plain
from django.shortcuts import render, HttpResponse
# Create your views here.
from app01 import models
def index(request):
    ## 以前写法
    # for i in range(100):
    #     models.Book.objects.create(name='图书%s' % i, price=10 + i)
    ## 现在写法(批量插入)
    # 1.先造出100本书，放到列表中
    l = []
    for i in range(100):
        l.append(models.Book(name='图书%s' % i, price=10 + i))
    # 批量插入,第一个参数插入的对象，第二个参数，每一次插入多少条(不写则全插)
    models.Book.objects.bulk_create(l, 10)
    return HttpResponse('ok')
```

<!-- OCR_START -->
- 127.0.0.1:8000/index/
- ←→C
- 应用zabbix-api
- CanlUseiview组件|Element曾志高翔（Drivere..
- ok
- 曾老湿
<!-- OCR_END -->

￼

一访问页面，100条数据就进去了。

<!-- OCR_START -->
- Database
- dbschemasmainapp01_book
- difenye#@
- Project
- setings.pyx
- models.py
- urls.pyX
- views.pyx
- mainapp01book[db]x
- fenye~/PycharmProjects/fenye
- 100rows
- Tx:Auto
- Tab-sed（TSV)DDLViewQuery
- app01
- <Filter criteria>
- 8-/db1
- migrations
- idname
- init_.py
- price：
- schemas1
- 1图书0
- 10
- main
- admin.py
- 2
- 图书1
- 11
- 田app01_book
- apps.py
- 图书2
- 1213
- auth_group
- 图书3
- auth_group_permissions
- tests.py
- 图书4
- 1415
- 图书5
- auth_permission
- views.py
- fenye
- 图书6
- 16
- auth_user
- 8图书7
- 17
- auth_user_groups
- settings.py
- 图书8
- 18
- auth_user_user_permissions
- urls.py
- 图书9
- 19
- django_admin_log
- 图书10
- wsgi.py
- 20
- django_content_type
- 12
- 图书11
- 21
- templates
- 22
- django_migrations
- 13
- 图书12
- db.sqlite3
- django_session
- 14
- 图书13
- 23
- manage.py
- 15
- 图书14
- 2h
- sqlite_master
- 1617
- sqlite_sequence
- lliExternal Libraries
- 图书15
- Scratches and Consoles
- 图书16
- collations3
- 图书17
- 图书18
- 28
- 29
- 图书20
- 30
- 图书21
- 31
- 图书22
- 32
- 24
- 图书23
- 33
- 25
- 图书24
- 45
- 26
- 图书25
- 曾老湿
- 27
- 图书26
- 36
- 37
<!-- OCR_END -->

￼

现在写index页面，返回数据

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>图书 分页</title>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
      integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<body>
<div class="container-fluid">
    <nav class="navbar navbar-default navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">图书管理系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <form class="navbar-form navbar-left">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="你要找啥啊？">
                    </div>
                    <button type="submit" class="btn btn-default">搜索图书</button>
                </form>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>书名</th>
                    <th>价格</th>
                </tr>
                </thead>
                <tbody>
                {% for book in book_list %}
                    <tr>
                        <td>{{ book.name }}</td>
                        <td>{{ book.price }}</td>
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

<!-- OCR_START -->
- 图书分页
- ←→C
- 127.0.0.1:8000/index/
- 9
- 应用zabbix-api
- CanIUse
- iview
- 组件|Element
- 曾志高翔（DriverZe.
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书0
- 10.00
- 图书1
- 11.00
- 图书2
- 12.00
- 图书3
- 13.00
- 图书4
- 14.00
- 图书5
- 15.00
- 图书6
- 16.00
- 图书7
- 17.00
- 图书8
- 18.00
- 图书9
- 19.00
- 图书10
- 20.00
- 图书11
- 21.00
- 图书12
- 22.00
- 图书13
- 23.00
- 图书14
- 24.00
- 图书15
- 25.00
- 图书16
- 26.00
- 图书17
- 27.00
- 图书18
- 28.00
- 图书19
- 29.00
- 图书20
- 30.00
- 图书21
- 曾老湿
- 31.00
<!-- OCR_END -->

￼

---

| 添加前端分页 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>图书 分页</title>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
      integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<body>
<div class="container-fluid">
    <nav class="navbar navbar-default navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">图书管理系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <form class="navbar-form navbar-left">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="你要找啥啊？">
                    </div>
                    <button type="submit" class="btn btn-default">搜索图书</button>
                </form>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>书名</th>
                    <th>价格</th>
                </tr>
                </thead>
                <tbody>
                {% for book in book_list %}
                    <tr>
                        <td>{{ book.name }}</td>
                        <td>{{ book.price }}</td>
                    </tr>
                {% endfor %}
                </tbody>
            </table>
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li>
                        <a href="#" aria-label="Previous">
                            <span aria-hidden="true">上一页</span>
                        </a>
                    </li>
                    <li><a href="#">1</a></li>
                    <li><a href="#">2</a></li>
                    <li><a href="#">3</a></li>
                    <li><a href="#">4</a></li>
                    <li><a href="#">5</a></li>
                    <li>
                        <a href="#" aria-label="Next">
                            <span aria-hidden="true">下一页</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 图书分页
- →C127.0.0.1:8000/index/
- 应用zabbix-apiCanlUseiview组件|Element曾志高翔（Driverze.
- 图书77
- 87.00
- 图书78
- 88.00
- 图书79
- 89.00
- 图书80
- 90.00
- 图书81
- 91.00
- 图书82
- 92.00
- 图书83
- 93.00
- 图书84
- 94.00
- 图书85
- 95.00
- 图书86
- 96.00
- 图书87
- 97.00
- 图书88
- 98.00
- 图书89
- 99.00
- 图书90
- 100.00
- 图书91
- 101.00
- 图书92
- 102.00
- 图书93
- 103.00
- 图书94
- 104.00
- 图书95
- 105.00
- 图书96
- 106.00
- 图书97
- 107.00
- 图书98
- 108.00
- 图书99
- 109.00
- 上-页123
- 45下-页
- 曾老湿
<!-- OCR_END -->

￼

## Django分页器使用
```plain
from django.shortcuts import render, HttpResponse
# Create your views here.
from app01 import models
from django.core.paginator import Paginator   # 导入分页器的类
def index(request):
    book_list = models.Book.objects.all()
    # 实例化产生一个对象
    ## 两个参数
    # 1.第一个是对象列表
    # 2.第二个是每页的条数
    paginator=Paginator(book_list,10)
    ## 数据总条数
    print(paginator.count)
    ## 总页数 (10页)
    print(paginator.num_pages)
    ## 页码数列表
    print(paginator.page_range)
    ## 取到第x页,返回一个对象
    current_page = paginator.page(5)
    ## 当前页面的数据
    print(current_page.object_list)
    ## 是否有下一页
    print(current_page.has_next())
    ## 是否有上一页
    print(current_page.has_previous())
    ## 下一页页码数
    print(current_page.next_page_number())
    ## 上一页页码数
    print(current_page.previous_page_number())
    return render(request,'index.html',locals())
```

<!-- OCR_START -->
- 当前页面的数据
- 是否有下一页
- 是否有上一页
- 下一页页码数
- 上一页页码数
- 曾老湿

```text
fenye[~/PycharmProjects/fenye]-./app01/views.py[fenye]
fenyeapp01views.py
Project
④
models.pyx
urls.py
views.py
index.htmlx
main.app01_book[db]
fenye~/PycharmProjects/fenye
21324152627 28293
print(paginator.page_range)
app01
migrations
取到第×页，返回一个对象
_init_.py
current_page = paginator.page(5)
admin.py
apps.py
print(current_page.object_list)
models.py
tests.py
views.py
31
print(current_page.has_next())
fenye
33
_init_.py
print(current_page.has_previous（))
settings.py
urls.py
wsgi.py
print(current_page.next_page_number())
templates
db.sqlite3
print(current_page.previous_page_number(）) manage.py llExternalLibraries return render(request,'index.html'locals（）)
Scratches and Consoles
Run:
difenyex
Performing system checks...
System check identified no issues (0 silenced）. June 17,2020-09:47:33 Django version 1.11.18,using settings fenye.settings Startingdevelopmentserverathttp://127.0.0.1:800o/ Quit the server with CoNTROL-C.
Users/driverzeng/PycharmProiects/fenye/appo1/views.py:13:UnorderedobjectListWarning:Pagination may yield inconsistent results with an unordered object_list:<class'app01.models.Book'>QuerySet.
paginator=Paginator(book_list,10)
100
10
汽★
range(1,11)
<QuerySet[<Book:Book object>，<Book: Book object>，<Book:Book object>，<Book:Book object>，<Book:Book object>，<Book:Book object>，<Book:Book object>，<Book: Book object>，<Book:Book object>，<Book: Book object>]>
True
6
[17/Jun/202009:47:36]GET/index/HTTP/1.1200 17784
Database ChangesTerminal4:Run三6:TODO
ninutes ago)
43:1LFUTF-84spaces
```
<!-- OCR_END -->

￼

```plain
from django.shortcuts import render, HttpResponse
# Create your views here.
from app01 import models
from django.core.paginator import Paginator   # 导入分页器的类
def index(request):
    book_list = models.Book.objects.all()
    paginator = Paginator(book_list, 10)
    current_page_num = int(request.GET.get('page'))
    current_page = paginator.page(current_page_num)
    ## 当前页码所有数据
    print(current_page.object_list)
    # 既可以循环 current_page.pbject_list,又可以循环当前页的对象
    for item in current_page:
        print(item.name)
    return render(request, 'index.html', locals())
```

<!-- OCR_START -->
- 图书分页
- ←→C
- 127.0.0.1:8000/index/page=3
- 应用zabbix-api
- CanIUseiview
- 组件|Element
- 曾志高翔（DriverZe.
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书20
- 30.00
- 图书21
- 31.00
- 图书22
- 32.00
- 图书23
- 33.00
- 图书24
- 34.00
- 图书25
- 35.00
- 图书26
- 36.00
- 图书27
- 37.00
- 图书28
- 38.00
- 图书29
- 39.00
- 上一页
- 曾老湿
<!-- OCR_END -->

￼

目前只能通过浏览器传递数据，查看到后台内容，现在去修改前端。

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>图书 分页</title>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
      integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<body>
<div class="container-fluid">
    <nav class="navbar navbar-default navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">图书管理系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <form class="navbar-form navbar-left">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="你要找啥啊？">
                    </div>
                    <button type="submit" class="btn btn-default">搜索图书</button>
                </form>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>书名</th>
                    <th>价格</th>
                </tr>
                </thead>
                <tbody>
                {% for book in current_page %}
                    <tr>
                        <td>{{ book.name }}</td>
                        <td>{{ book.price }}</td>
                    </tr>
                {% endfor %}
                </tbody>
            </table>
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    {% if current_page.has_previous %}
                        <li>
                            {#<a href="/index/?page={{ current_page_num|add:-1 }}" aria-label="Previous">#}
                            <a href="/index/?page={{ current_page.previous_page_number }}" aria-label="Previous">
                                <span aria-hidden="true">上一页</span>
                            </a>
                        </li>
                    {% else %}
                        <li class="disable">
                            {#<a href="/index/?page={{ current_page_num|add:-1 }}" aria-label="Previous">#}
                            <a href="" aria-label="Previous">
                                <span aria-hidden="true">上一页</span>
                            </a>
                        </li>
                    {% endif %}
                    {% for total_page in paginator.page_range %}
                        {% if current_page_num == total_page %}
                            <li class="active"><a href="/index/?page={{ total_page }}">{{ total_page }}</a></li>
                        {% else %}
                            <li><a href="/index/?page={{ total_page }}">{{ total_page }}</a></li>
                        {% endif %}
                    {% endfor %}
                    {% if current_page.has_next %}
                        <li>
                            <a href="/index/?page={{ current_page.next_page_number }}" aria-label="Next">
                                <span aria-hidden="true">下一页</span>
                            </a>
                        </li>
                    {% else %}
                        <li class="disable">
                            <a href="" aria-label="Next">
                                <span aria-hidden="true">下一页</span>
                            </a>
                        </li>
                    {% endif %}
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 图书分页
- →C
- 127.0.0.1:8000/index/?page=1
- 应用zabbix-api
- CanIUseiview组件IElement曾志高翔（Driver.e..
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书0
- 10.00
- 图书1
- 11.00
- 图书2
- 12.00
- 图书3
- 13.00
- 图书4
- 14.00
- 图书5
- 15.00
- 图书6
- 16.00
- 图书7
- 17.00
- 图书8
- 18.00
- 图书9
- 19.00
- 上一
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 图书分页
- →C
- 127.0.0.1:8000/index/?page=5
- 9
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书40
- 50.00
- 图书41
- 51.00
- 图书42
- 52.00
- 图书43
- 53.00
- 图书44
- 54.00
- 图书45
- 55.00
- 图书46
- 56.00
- 图书47
- 57.00
- 图书48
- 58.00
- 图书49
- 59.00
- 上一页
- 10
- 下一页
- 曾老湿
<!-- OCR_END -->

￼

## 终极分页器使用
刚才的代码是有bug的，我们来解决一下bug，如果我们手动改浏览器中的?page=100000000，程序就炸了。Boom~~~~~~

<!-- OCR_START -->
EmptyPage at/index/
→C127.0.0.1:8000/index/?page=1000000000
8
应用zabbix-api
CanIUse
iview组件IElement曾志高翔（DriverZe
Thatpagecontainsnoresults
Request Method: GET
RequestURL:http://127.0.0.1:8000/index/?page=1000000000
Django Version:1.11.18
ExceptionType:EmptyPage
Exception Value:That page contains no results
ExceptionLocation:/ibrary/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/django/core/paginator.pyinvalidate_numberline50
PythonExecutable:/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6
Python Version:3.6.4
Python Path:[/Users/driverzeng/PycharmProjects/fenye',
'/Users/driverzeng/PycharmProjects/fenye'
/Library/Frameworks/Python.framework/versions/3.6/lib/python36.zip',
/Library/Frameworks/Python.framework/Versions/3.6/1ib/python3.6/1ib-dynload'，
/Applications/PyCharm.app/Contents/helpers/pycharmmatplotlib_backend')
ckages',
曾老湿
Server time:Wed,17Jun202012:59:29+0000
<!-- OCR_END -->

￼

不管输入多少，都跳转到最后一页

```plain
from django.shortcuts import render, HttpResponse
# Create your views here.
from app01 import models
from django.core.paginator import Paginator,EmptyPage   # 导入分页器的类
def index(request):
    book_list = models.Book.objects.all()
    paginator = Paginator(book_list, 10)
    try:
        current_page_num = int(request.GET.get('page'))
        current_page = paginator.page(current_page_num)
    ## 当前页码所有数据
    # print(current_page.object_list)
    # 既可以循环 current_page.pbject_list,又可以循环当前页的对象
    # for item in current_page:
    #     print(item.name)
    except EmptyPage as e:
        # 捕获异常后跳转到最后一页
        current_page_num = paginator.num_pages
        current_page = paginator.page(current_page_num)
    return render(request, 'index.html', locals())
```

<!-- OCR_START -->
- 图书分页
- →C
- 127.0.0.1:8000/index/?page=1000000000
- 应用zabbix-api
- CanlUseiview组件IElement
- 曾志高翔（DriverZe.
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书90
- 100.00
- 图书91
- 101.00
- 图书92
- 102.00
- 图书93
- 103.00
- 图书94
- 104.00
- 图书95
- 105.00
- 图书96
- 106.00
- 图书97
- 107.00
- 图书98
- 108.00
- 图书99
- 109.00
- 曾老湿
<!-- OCR_END -->

￼

但是还tmd有bug，我们在后端用int转了数据，但是如果调皮的用户们，输入的是字母或者特殊符号，int没有办法转...程序还是会炸。

<!-- OCR_START -->
ValueErrorat/index
←→C 127.0.0.1:8000/index/?page=asdsadas
8
应用zabbix-api
CanlUseiview组件|Element曾志高翔（Driverze
invalidliteralforint()withbase10:'asdsadas'
Request Method:GET
RequestURL:http://127.0.0.1:8000/index/?page=asdsadas
Django Version:1.11.18
ExceptionType:ValueError
Exception Value:invalid literal for int() with base 10:‘asdsadas'
ExceptionLocation:/Users/driverzeng/PycharmProjects/fenye/app01/views.pyinindex,line1
PythonExecutable:/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6
Python Version:3.6.4
Python Path:['/Users/driverzeng/PycharmProjects/fenye',
/Library/Frameworks/Python.framework/Versions/3.6/1ib/python36.zip',
/Users/driverze
g/PycharmProjects/feny
Server time:Wed,17Jun202013:14:32+0000
曾老湿
<!-- OCR_END -->

￼

继续捕获异常

```plain
from django.shortcuts import render, HttpResponse
# Create your views here.
from app01 import models
from django.core.paginator import Paginator,EmptyPage   # 导入分页器的类
def index(request):
    book_list = models.Book.objects.all()
    paginator = Paginator(book_list, 10)
    try:
        current_page_num = int(request.GET.get('page'))
        current_page = paginator.page(current_page_num)
    ## 当前页码所有数据
    # print(current_page.object_list)
    # 既可以循环 current_page.pbject_list,又可以循环当前页的对象
    # for item in current_page:
    #     print(item.name)
    except Exception as e:
        # 捕获异常后跳转到最后一页
        current_page_num = paginator.num_pages
        current_page = paginator.page(current_page_num)
    return render(request, 'index.html', locals())
```

<!-- OCR_START -->
- 图书分页
- →C
- 127.0.0.1:8000/index/?page=asdsadasasdsadqqqq
- 应用zabbix-api
- CanlUseiview组件IElement
- 曾志高翔（DriverZe.
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书90
- 100.00
- 图书91
- 101.00
- 图书92
- 102.00
- 图书93
- 103.00
- 图书94
- 104.00
- 图书95
- 105.00
- 图书96
- 106.00
- 图书97
- 107.00
- 图书98
- 108.00
- 图书99
- 109.00
- 曾老湿
<!-- OCR_END -->

￼

现在bug是没有了，但是还有一个问题 ... 我们现在网页显示的是10条，10条的话，看起来还阔以噻~

但是如果我们每页显示3条咋整？感受一下？

<!-- OCR_START -->
- 图书分页
- ←→C
- 127.0.0.1:8000/index/?page=6
- 9
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 曾志高翔（DriverZe.
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书15
- 25.00
- 图书16
- 26.00
- 图书17
- 27.00
- 曾老湿
<!-- OCR_END -->

￼

尼玛~ 丑的不要不要的啊。改tmd

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>图书 分页</title>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
      integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<body>
<div class="container-fluid">
    <nav class="navbar navbar-default navbar-inverse">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">图书管理系统</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <form class="navbar-form navbar-left">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="你要找啥啊？">
                    </div>
                    <button type="submit" class="btn btn-default">搜索图书</button>
                </form>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>书名</th>
                    <th>价格</th>
                </tr>
                </thead>
                <tbody>
                {% for book in current_page %}
                    <tr>
                        <td>{{ book.name }}</td>
                        <td>{{ book.price }}</td>
                    </tr>
                {% endfor %}
                </tbody>
            </table>
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    {% if current_page.has_previous %}
                        <li>
                            {#<a href="/index/?page={{ current_page_num|add:-1 }}" aria-label="Previous">#}
                            <a href="/index/?page={{ current_page.previous_page_number }}" aria-label="Previous">
                                <span aria-hidden="true">上一页</span>
                            </a>
                        </li>
                    {% else %}
                        <li class="disabled">
                            {#<a href="/index/?page={{ current_page_num|add:-1 }}" aria-label="Previous">#}
                            <a href="" aria-label="Previous">
                                <span aria-hidden="true">上一页</span>
                            </a>
                        </li>
                    {% endif %}
                    {% for total_page in page_range %}
                        {% if current_page_num == total_page %}
                            <li class="active"><a href="/index/?page={{ total_page }}">{{ total_page }}</a></li>
                        {% else %}
                            <li><a href="/index/?page={{ total_page }}">{{ total_page }}</a></li>
                        {% endif %}
                    {% endfor %}
                    {% if current_page.has_next %}
                        <li>
                            <a href="/index/?page={{ current_page.next_page_number }}" aria-label="Next">
                                <span aria-hidden="true">下一页</span>
                            </a>
                        </li>
                    {% else %}
                        <li class="disabled">
                            <a href="" aria-label="Next">
                                <span aria-hidden="true">下一页</span>
                            </a>
                        </li>
                    {% endif %}
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
```

```plain
from django.shortcuts import render, HttpResponse
# Create your views here.
from app01 import models
from django.core.paginator import Paginator,EmptyPage   # 导入分页器的类
def index(request):
    book_list = models.Book.objects.all()
    paginator = Paginator(book_list, 3)
    # 如果页码数多，让他显示前五，后五，中间是当前在的页码
    try:
        current_page_num = int(request.GET.get('page'))
        page_range = range(current_page_num - 5, current_page_num + 6)
        current_page = paginator.page(current_page_num)
    except Exception as e:
        current_page_num = paginator.num_pages
        current_page = paginator.page(current_page_num)
    return render(request, 'index.html', locals())
```

<!-- OCR_START -->
- 图书分页
- →C
- 127.0.0.1:8000/index/?page=31
- 9
- 应用zabbix-api
- CanlUseiview组件IElement曾志高翔（DriverZe.
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书90
- 100.00
- 图书91
- 101.00
- 图书92
- 102.00
- 曾老湿
<!-- OCR_END -->

￼

诶？看起来好像是可以了。。。。。可以个锤子哦。

请看下图...这特么的是啥？

<!-- OCR_START -->
- 图书分页
- ①127.0.0.1:8000/index/?page=1
- 8
- 应用zabbix-api
- CanIUse
- iview
- 组件|Element
- 曾志高翔（DriverZe.
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书0
- 10.00
- 图书1
- 11.00
- 图书2
- 12.00
- 上一页
- 曾老湿
<!-- OCR_END -->

￼

```plain
from django.shortcuts import render, HttpResponse
# Create your views here.
from app01 import models
from django.core.paginator import Paginator,EmptyPage   # 导入分页器的类
def index(request):
    book_list = models.Book.objects.all()
    paginator = Paginator(book_list, 3)
    # 如果页码数多，让他显示前五，后五，中间是当前在的页码
    try:
        current_page_num = int(request.GET.get('page'))
        current_page = paginator.page(current_page_num)
    except Exception as e:
        current_page_num = 1
        current_page = paginator.page(current_page_num)
    if paginator.num_pages > 11:
        if current_page_num - 5 < 1:
            page_range = range(1, 12)
        elif current_page_num + 5 > paginator.num_pages:
            page_range = range(paginator.num_pages - 11, paginator.num_pages + 1)
        else:
            page_range = range(current_page_num - 5, current_page_num + 6)
    else:
        page_range = paginator.page_range
    return render(request, 'index.html', locals())
```

<!-- OCR_START -->
- 图书分页
- →C
- 127.0.0.1:8000/index/?page=34
- 8
- 应用zabbix-api
- CanIUseiview组件IElement曾志高翔（DriverZe.
- 图书管理系统
- 你要找啥啊？
- 搜索图书
- 书名
- 价格
- 图书99
- 109.00
- 上一页
- 曾老湿
<!-- OCR_END -->

￼

## 前端使用ajax后端写成装饰器
```plain
from django.shortcuts import render, HttpResponse
# Create your views here.
from app01 import models
from django.core.paginator import Paginator,EmptyPage   # 导入分页器的类
import json
def auth_ajax(func):
    def inner(request,*args,**kwargs):
        request.data = request.POST
        try:
            request.data = json.loads(request.body.decode('utf-8'))
        except Exception as e:
            print(e)
        res = func(request,*args,**kwargs)
        return res
    return inner
@auth_ajax
def index(request):
    if request.method == 'GET':
        return render(request,'index.html')
    elif request.method == 'POST':
        print(request.data)
        return HttpResponse('OK')
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>图书分页AJAX</title>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css"
      integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<body>
    <button id="btn">点我</button>
    <script>
        $('#btn').click(function () {
            var dic = {'name':'zls'}
            var da = JSON.stringify(dic)
            $.ajax({
                url: '/index/',
                type: 'post',
                contentType: 'application/json',
                data:da,
                success:function (data) {
                    console.log(data)
                }
            })
        })
    </script>
</body>
</html>
```

<!-- OCR_START -->
- 曾老湿

```text
app01/views.py[tenye]
fenyeapp01views.py
djfenye
Project
settings.py
models.pyx
urls.pyx
views.py
index.htmlx
main.app01_book[db]
fenye ~/Pycha
from django.shortcuts import render,HttpResponse
app01
#Create your views here.
migrations
_init_.py
from appo1 import models
from django.core.paginatorimport Paginator，EmptyPage#导入分页器的类
admin.py
apps.py
import json
models.py
def authajax（func):
tests.py
def inner(request,*args**kwargs）: views.py request.data =request.POST Bfenye
1112
try:
request.data = json.loads（request.body.decode('utf-8'))
_init_.py
13
except Exception ase:
settings.py
print(e)
urls.py
14
15
res=func(request*args**kwargs)
wsgi.py
16
return res
return inner
static
18
templates
19
index.html
20
@auth_ajax
db.sqlite3
21
def index(request):
ifrequest.method='GET':
manage.py
23
return render(request,'index.html')
l External Libraries
Scratches and Consoles
25
print(request.data)
26
return HttpResponse(‘oK') 27 index() Run:
djfenyex
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/fenye/manage.pyrunserver 8000
Performing system checks...
System check identified no issues (o silenced）. June 17,2020-14:17:33 Django version 1.11.18, using settings fenye.settings Starting development server at http://127.0.0.1:8000/ Quit the server with CONTROL-C.
Expectingvalue:line1column 1（char 0）
[17/Jun/202014:17:37]GET/index/HTTP/1.1200 896
17/Jun/2020 14:17:38]"P0ST/index/HTTP/1.12002
```
<!-- OCR_END -->

￼

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:37:31  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/neiv20>