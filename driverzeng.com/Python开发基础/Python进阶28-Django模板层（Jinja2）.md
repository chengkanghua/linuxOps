# Python进阶28-Django 模板层(Jinja2)

## Python进阶28-Django 模板层(Jinja2)

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(1) 评论(0)

* [模板层介绍](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_0)
* [模板语言变量](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_1)
* [模板语言过滤器](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_2)
* [模板语言标签](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_3)
* [自定义标签和过滤器](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_4)
* [模板导入](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_5)
* [模板继承](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_6)
* [静态文件配置](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_7)
  * [使用get_static_prefix](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_8)
  * [inclusion_tag](https://blog.driverzeng.com/zenglaoshi/5667.html#toc_9)

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

## 模板层介绍

***

| 模版简介 |
| :--- |

你可能已经注意到我们在例子视图中返回文本的方式有点特别。 也就是说，HTML被直接硬编码在 Python代码之中。

```plain
def current_datetime(request):
    now = datetime.datetime.now()
    html = "<html><body>It is now %s.</body></html>" % now
    return HttpResponse(html)
```

尽管这种技术便于解释视图是如何工作的，但直接将HTML硬编码到你的视图里却并不是一个好主意。 让我们来看一下为什么：

1.对页面设计进行的任何改变都必须对 Python 代码进行相应的修改。 站点设计的修改往往比底层 Python 代码的修改要频繁得多，因此如果可以在不进行 Python 代码修改的情况下变更设计，那将会方便得多。

2.Python 代码编写和 HTML 设计是两项不同的工作，大多数专业的网站开发环境都将他们分配给不同的人员（甚至不同部门）来完成。 设计者和HTML/CSS的编码人员不应该被要求去编辑Python的代码来完成他们的工作。

## 模板语言变量

***

| 视图设置变量，前端调用 |
| :--- |

```plain
## 路由
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^index/', views.index),
]
```

```plain
<!-- html --> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言-变量</h1>
<hr>
<!-- 调用变量 --> 
{{ name }}
</body>
</html>
```

```plain
## 视图
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def index(request):
    name='曾老湿'
    return render(request,'index.html',{'name':name})
```

<!-- OCR_START -->
- 主页
- 127.0.0.1:8000/index/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- 模板语言-变量
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def index(request):
    name='曾老湿'
    ## locals() 会把该视图函数内的所有变量，都传到模板
    return render(request,'index.html',locals())
```

<!-- OCR_START -->
- 主页
- 127.0.0.1:8000/index
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（Driv
- 模板语言-变量
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言-变量</h1>
<hr>
{{ name }}
<hr>
{{ age }}
</body>
</html>
```

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def index(request):
    name='曾老湿'
    age=18
    ## locals() 会把该视图函数内的所有变量，都传到模板
    return render(request,'index.html',locals())
```

<!-- OCR_START -->
- 主页
- 127.0.0.1:8000/index/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe..
- 模板语言-变量
- 曾老湿
- 18
- DriverZeng
<!-- OCR_END -->

￼

***

| 添加所有类型 |
| :--- |

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def index(request):
    name = '曾老湿'
    age = 18
    li = [1, 2, 3, 4, 'zls']
    dic = {'name': '苍井空', 'age': 18}
    tup = ('abc', 'def', 'ghi')
    def func():
        print('zls')
        return '波多野结衣'
    ## locals() 会把该视图函数内的所有变量，都传到模板
    return render(request, 'index.html', locals())
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言-变量</h1>
<hr>
字符串：{{ name }}
<hr>
整型：{{ age }}
<hr>
列表：{{ li }}
<hr>
字典：{{ dic }}
<hr>
元组：{{ tup }}
<hr>
函数：{{ func }}
<hr>
</body>
</html>
```

<!-- OCR_START -->
- 主页
- 127.0.0.1:8000/index
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe.
- 模板语言-变量
- 字符串：曾老湿
- 整型：18
- 列表：[1,2,3,4,'zls’]
- 字典：{'name'：‘苍井空'，'age':18}
- 元组：('abc','def'，'ghi)
- 函数：波多野结衣
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

***

| 深度查询 |
| :--- |

和ansible以及saltstack一样。如果数据是一个列表或者字典，我们想查询其中一个数据，那就使用句点符来获取数据。

例如：

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言-变量</h1>
<hr>
字符串：{{ name }}
<hr>
整型：{{ age }}
<hr>
列表：{{ li.0 }}
<hr>
字典：{{ dic.name }}
<hr>
元组：{{ tup.1 }}
<hr>
函数：{{ func }}
<hr>
</body>
</html>
```

<!-- OCR_START -->
- 主页
- 127.0.0.1:8000/index/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- 模板语言-变量
- 字符串：曾老湿
- 整型：18
- 列表
- 1
- 字典
- 苍井空
- 元组
- def
- 函数：波多野结衣
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**类和对象**

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def index(request):
    name = '曾老湿'
    age = 18
    li = [1, 2, 3, 4, 'zls']
    dic = {'name': '苍井空', 'age': 18}
    tup = ('abc', 'def', 'ghi')
    def func():
        print('zls')
        return '波多野结衣'
    class Person():
        def __init__(self, name, age):
            self.name = name
            self.age = age
        def get_name(self):
            return self.name
        @classmethod
        def cls_test(cls):
            return 'cls'
        @staticmethod
        def static_test():
            return 'static'
        # 模板里不支持带参数
        def get_name_cs(self, ttt):
            return self.name
    zls = Person('zls', 18)
    cls = Person('cls', 18)
    person_list = [zls, cls]
    person_dic = {'zls': zls}
    ## locals() 会把该视图函数内的所有变量，都传到模板
    return render(request, 'index.html', locals())
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言之变量</h1>
<p>字符串:{{ name }}</p>
<p>数字:{{ age }}</p>
<p>列表:{{ li }}</p>
<p>元祖:{{ tup }}</p>
<p>字典:{{ dic }}</p>
{#只写函数名:相当于函数名(),执行该函数#}
<p>函数:{{ test }}</p>
{#对象内存地址#}
<p>对象:{{ zls }}</p>
<p>列表套对象:{{ person_list }}</p>
<p>字典套对象:{{ person_dic }}</p>
<hr>
<h1>深度查询</h1>
<p>列表第0个值:{{ ll.0 }}</p>
<p>列表第3个值:{{ ll.3 }}</p>
<p>字典取值:{{ dic.name }}</p>
<p>字典取列表值:{{ dic.ll }}</p>
{#再继续取值,继续点#}
<p>对象取数据属性:{{ zls.name }}</p>
<p>对象取绑定给对象的函数属性:{{ zls.get_name }}</p>
<p>对象取绑定给类的函数属性:{{ zls.cls_test }}</p>
<p>对象取静态方法:{{ zls.static_test }}</p>
<p>把对象列表中cls年龄取出来:{{ person_list.1.age }}</p>
{#拓展:不能调有参数的方法#}
<p>字符串的方法:{{ name.upper }}</p>
</body>
</html>
```

<!-- OCR_START -->
- 主页
- ×编辑文章<曾志高翔（DriverZeng×+
- →C
- 127.0.0.1:8000/index/
- 应用zabbix-apiCanlUseiview组件|Element曾志高翔（DriverZe
- 模板语言之变量
- 字符串：曾老湿
- 数字：18
- 列表：[1,2,3,4,'zls’]
- 元祖：('abc'，'def，'ghi)
- 字典：name：苍井空’，age'：18}
- 函数：
- 对象：<app01.views.index.<locals>.Personobjectat0x111e8c358>
- 列表套对象:[<app01.views.index.<locals>.Person object at 0x111e8c358>, <app01.views.index.<locals>.Person object at 0x111e97470>]
- 字典套对象：[zls':<app01.views.index.<locals>.Personobjectat0x111e8c358>}
- 深度查询
- 列表第0个值：
- 列表第3个值：
- 字典取值：苍井空
- 字典取列表值：
- 对象取数据属性：zls
- 对象取绑定给对象的函数属性：zls
- 对象取绑定给类的函数属性：cls
- 对象取静态方法：static
- 把对象列表中cls年龄取出来：18
- 字符串的方法：曾老湿
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## 模板语言过滤器

***

| 语法 |
| :--- |

```plain
{{obj|filter__name:param}}  变量名字|过滤器名称：变量
```

***

| 过滤器使用 |
| :--- |

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言之过滤器</h1>
<p>统计字符串长度：{{ name|length }}</p>
<p>统计字列表长度：{{ li|length }}</p>
<p>过滤器默认值：{{ li|default:'没有值'}}</p>
<p>过滤器默认值：{{ li2|default:'没有值'}}</p>
<p>过滤器filesizeformat---1：{{ 1024|filesizeformat}}</p>
<p>过滤器filesizeformat---2：{{ file_size|filesizeformat}}</p>
<p>过滤器不用date：{{ ctim}}</p>
<p>过滤器使用date：{{ ctim|date:'Y-m-d'}}</p>
{#支持步长#}
<p>过滤器slice切列表：{{ li|slice:'2:-1'}}</p>
<p>过滤器slice切字符串：{{ name|slice:'0:-1'}}</p>
{#截断字符：使用场景，博客的内容摘要#}
<p>过滤器truncatechars：{{ 'ssssszzzzccccc'|truncatechars:5 }}</p>
{#截断单词：使用场景，博客的内容摘要#}
<p>过滤器truncat：{{ '你 hao hello 我 哎呀 fuck'|truncatewords:5 }}</p>
{#重中之重#}
<p>过滤器不用safe：{{ h1 }}</p>
<p>过滤器使用safe：{{ h1|safe }}</p>
</body>
</html>
```

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def index(request):
    name = '曾老湿'
    age = 18
    li = [1, 2, 3, 4, 'zls']
    dic = {'name': '苍井空', 'age': 18}
    tup = ('abc', 'def', 'ghi')
    def func():
        print('zls')
        return '波多野结衣'
    class Person():
        def __init__(self, name, age):
            self.name = name
            self.age = age
        def get_name(self):
            return self.name
        @classmethod
        def cls_test(cls):
            return 'cls'
        @staticmethod
        def static_test():
            return 'static'
        # 模板里不支持带参数
        def get_name_cs(self, ttt):
            return self.name
    zls = Person('zls', 18)
    cls = Person('cls', 18)
    person_list = [zls, cls]
    person_dic = {'zls': zls}
    file_size=1024
    import datetime
    ctim=datetime.datetime.now()
    h1='<h1>你好</h1>'
    ## locals() 会把该视图函数内的所有变量，都传到模板
    return render(request, 'index.html', locals())
```

<!-- OCR_START -->
- 5
- 主页
- 编辑文章<曾志高翔（DriverZeng×+
- 0127.0.0.1:8000/index/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe.
- 模板语言之过滤器
- 统计字符串长度：3
- 统计字列表长度：5
- 过滤器默认值：[1,2,3,4，'zls']
- 过滤器默认值：没有值
- 过滤器flesizeformat---1:1.0 KB
- 过滤器filesizeformat---2：1.0 KB
- 过滤器不用date：June14，2020,3:57a.m.
- 过滤器使用date：2020-06-14
- 过滤器slice切列表：[3,4]
- 过滤器slice切字符串：曾老
- 过滤器truncatechars：ss...
- 过滤器truncat：你haohello我哎呀..
- 过滤器不用safe：<h1>你好</h1>
- 过滤器使用safe：
- 你好
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 其它过滤器（了解） |
| :--- |

| 过滤器 | 描述 | 示例 |
| :--- | :--- | :--- |
| upper | 以大写方式输出 | {{ user.name | upper }} |
| add | 给value加上一个数值 | {{ user.age | add:”5” }} |
| addslashes | 单引号加上转义号 | |
| capfirst | 第一个字母大写 | {{ ‘good’| capfirst }} 返回”Good” |
| center | 输出指定长度的字符串，把变量居中 | {{ “abcd”| center:”50” }} |
| cut | 删除指定字符串 | {{ “You are not a Englishman” | cut:”not” }} |
| date | 格式化日期 | |
| default | 如果值不存在，则使用默认值代替 | {{ value | default:”(N/A)” }} |
| default_if_none | 如果值为None, 则使用默认值代替 | |
| dictsort | 按某字段排序，变量必须是一个dictionary | {% for moment in moments | dictsort:”id” %} |
| dictsortreversed | 按某字段倒序排序，变量必须是dictionary | |
| divisibleby | 判断是否可以被数字整除 | `{{ 224 | divisibleby:2 }} 返回 True` |
| escape | 按HTML转义，比如将”<”转换为”\&lt” | |
| filesizeformat | 增加数字的可读性，转换结果为13KB,89MB,3Bytes等 | `{{ 1024 | filesizeformat }} 返回 1.0KB` |
| first | 返回列表的第1个元素，变量必须是一个列表 | |
| floatformat | 转换为指定精度的小数，默认保留1位小数 | {{ 3.1415926 | floatformat:3 }} 返回 3.142 四舍五入 |
| get_digit | 从个位数开始截取指定位置的数字 | {{ 123456 | get_digit:’1’}} |
| join | 用指定分隔符连接列表 | {{ \[‘abc’,’45’] | join:’\_’ }} 返回 abc_45 |
| length | 返回列表中元素的个数或字符串长度 | |
| length_is | 检查列表，字符串长度是否符合指定的值 | {{ ‘hello’| length_is:’3’ }} |
| linebreaks | 用或标签包裹变量 | {{ “Hi\n\nDavid”|linebreaks }} 返回HiDavid |
| linebreaksbr | 用   标签代替换行符 | |
| linenumbers | 为变量中的每一行加上行号 | |
| ljust | 输出指定长度的字符串，变量左对齐 | {{‘ab’|ljust:5}}返回 ‘ab ’ |
| lower | 字符串变小写 | |
| make_list | 将字符串转换为列表 | |
| pluralize | 根据数字确定是否输出英文复数符号 | |
| random | 返回列表的随机一项 | |
| removetags | 删除字符串中指定的HTML标记 | {{value | removetags: “h1 h2”}} |
| rjust | 输出指定长度的字符串，变量右对齐 | |
| slice | 切片操作， 返回列表 | {{\[3,9,1] | slice:’:2’}} 返回 \[3,9] `{{ 'asdikfjhihgie' | slice:':5' }} 返回 ‘asdik’` |
| slugify | 在字符串中留下减号和下划线，其它符号删除，空格用减号替换 | `{{ '5-2=3and5 2=3' | slugify }} 返回 5-23and5-23` |
| stringformat | 字符串格式化，语法同python | |
| time | 返回日期的时间部分 | |
| timesince | 以“到现在为止过了多长时间”显示时间变量 | 结果可能为 45days, 3 hours |
| timeuntil | 以“从现在开始到时间变量”还有多长时间显示时间变量 | |
| title | 每个单词首字母大写 | |
| truncatewords | 将字符串转换为省略表达方式 | `{{ 'This is a pen' | truncatewords:2 }}返回``This is ...` |
| truncatewords_html | 同上，但保留其中的HTML标签 | `{{ 'This is a pen' | truncatewords:2 }}返回``This is ...` |
| urlencode | 将字符串中的特殊字符转换为url兼容表达方式 | {{ ‘[http://www.aaa.com/foo?a=b\&b=c’](http://www.aaa.com/foo?a=b\&b=c%E2%80%99) | urlencode}} |
| urlize | 将变量字符串中的url由纯文本变为链接 | |
| wordcount | 返回变量字符串中的单词数 | |
| yesno | 将布尔变量转换为字符串yes, no 或maybe | `{{ True | yesno }}{{ False | yesno }}{{ None | yesno }}``返回``yes``no``maybe` |

## 模板语言标签

***

| 标签介绍 |
| :--- |

标签看起来像是这样的： {% tag %}。标签比变量更加复杂：一些在输出中创建文本，一些通过循环或逻辑来控制流程，一些加载其后的变量将使用到的额外信息到模版中。一些标签需要开始和结束标签 （例如{% tag %} ...标签 内容 ... {% endtag %}）。

***

| 标签使用-循环 |
| :--- |

```plain
forloop.counter            The current iteration of the loop (1-indexed) 当前循环的索引值（从1开始）
forloop.counter0           The current iteration of the loop (0-indexed) 当前循环的索引值（从0开始）
forloop.revcounter         The number of iterations from the end of the loop (1-indexed) 当前循环的倒序索引值（从1开始）
forloop.revcounter0        The number of iterations from the end of the loop (0-indexed) 当前循环的倒序索引值（从0开始）
forloop.first              True if this is the first time through the loop 当前循环是不是第一次循环（布尔值）
forloop.last               True if this is the last time through the loop 当前循环是不是最后一次循环（布尔值）forloop.parentloop         本层循环的外层循环
```

**循环列表**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言之标签</h1>
{% for foo in li %}
    <p>{{ foo }}</p>
{% endfor %}
<hr>
{% for foo in li %}
    {{ forloop }}
    <p>{{ forloop.first }} === {{ forloop.revcounter }} === {{ foo }}</p>
{% endfor %}
<hr>
{% for foo in li %}
    {% for i in person_list %}
{#    取出外层是第几次循环    #}
        {{ forloop.parentloop.counter }}
        <p>{{ forloop.first }} === {{ forloop.revcounter }} === {{ foo }}</p>
    {% endfor %}
{% endfor %}
<hr>
{# 循环的对象如果是空，则返回empty的内容 #}
{% for foo in li1 %}
    <p>{{ foo }}</p>
{% empty %}
    傻逼了
{% endfor %}
</body>
</html>
```

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def index(request):
    name = '曾老湿'
    age = 18
    li = [1, 2, 3, 4, 'zls']
    dic = {'name': '苍井空', 'age': 18}
    tup = ('abc', 'def', 'ghi')
    def func():
        print('zls')
        return '波多野结衣'
    class Person():
        def __init__(self, name, age):
            self.name = name
            self.age = age
        def get_name(self):
            return self.name
        @classmethod
        def cls_test(cls):
            return 'cls'
        @staticmethod
        def static_test():
            return 'static'
        # 模板里不支持带参数
        def get_name_cs(self, ttt):
            return self.name
    zls = Person('zls', 18)
    cls = Person('cls', 18)
    person_list = [zls, cls]
    person_dic = {'zls': zls}
    file_size=1024
    import datetime
    ctim=datetime.datetime.now()
    h1='<h1>你好</h1>'
    ## locals() 会把该视图函数内的所有变量，都传到模板
    return render(request, 'index.html', locals())
```

<!-- OCR_START -->
- 主页
- 模板语言之标签

```text
编辑文章<曾志高翔（DriverZengX
127.0.0.1:8000/index/ 应用zabbix-api
CanlUse
Viview组件IElement
曾志高翔（DriverZe..
1
2
3
4
zls
I'parentloop': 0, 'counter0': 0, 'counter': 1, 'revcounter': 5, 'revcounter0': 4, 'first': True, 'last': False}
True=== 5 === 1
{'parentloop': , 'counter0': 1, 'counter': 2, 'revcounter': 4, 'revcounter0': 3, 'first': False, 'last': False}
False === 4 === 2
{'parentloop': , 'counter0': 2, 'counter': 3, 'revcounter': 3, 'revcounter0': 2, 'first': False, 'last': False}
False ===3 === 3
{'parentloop': 0, 'counter0': 3, 'counter': 4, 'revcounter': 2, 'revcounter0': 1, 'first': False, last': False} False === 2 === 4 I'parentloop': 0, 'counter0': 4, 'counter': 5, 'revcounter': 1, 'revcounter0': 0, 'first': False, 'last': True} 曾老湿
=== zls
DriverZeng
```
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 主页
- 傻曾老湿

```text
编辑文章<曾志高翔（DriverZeng
127.0.0.1:8000/index/ 应用
zabbix-apilCanlUse
iview
组件|Element
曾志高翔（DriverZe..
False===2===4
'parentloop':0,'counterO':4,'counter':5,'revcounter':1,'revcounter0':0,'first':False,last':True}
False===1===zls
1
True===2===1
False===1== 2
True ===2 === 2
False===1===2
3
True===2===3
4
True===2===4
5
True ===2===zls
Driver Zeng
```
<!-- OCR_END -->

￼

**循环字典**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言之标签</h1>
{#只循环字典，只能取到key#}
{% for k in dic %}
    <p>{{ k }}</p>
{% endfor %}
<hr>
{#循环value#}
{% for v in dic.values %}
    <p>{{ v }}</p>
{% endfor %}
<hr>
{#循环key和value#}
{% for k,v in dic.items %}
    <p>{{ k }}:{{ v }}</p>
{% endfor %}
</body>
</html>
```

```plain
from django.shortcuts import render, HttpResponse, redirect
# Create your views here.
def index(request):
    name = '曾老湿'
    age = 18
    li = [1, 2, 3, 4, 'zls']
    dic = {'name': '苍井空', 'age': 18}
    tup = ('abc', 'def', 'ghi')
    def func():
        print('zls')
        return '波多野结衣'
    class Person():
        def __init__(self, name, age):
            self.name = name
            self.age = age
        def get_name(self):
            return self.name
        @classmethod
        def cls_test(cls):
            return 'cls'
        @staticmethod
        def static_test():
            return 'static'
        # 模板里不支持带参数
        def get_name_cs(self, ttt):
            return self.name
    zls = Person('zls', 18)
    cls = Person('cls', 18)
    person_list = [zls, cls]
    person_dic = {'zls': zls}
    file_size=1024
    import datetime
    ctim=datetime.datetime.now()
    h1='<h1>你好</h1>'
    ## locals() 会把该视图函数内的所有变量，都传到模板
    return render(request, 'index.html', locals())
```

<!-- OCR_START -->
- 主页
- 编辑文章曾志高翔（DriverZeng×
- 127.0.0.1:8000/index/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- 模板语言之标签
- name
- age
- 苍井空
- 18
- name:苍井空
- age:18
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

***

| 标签使用-判断 |
| :--- |

{% if %}会对一个变量求值，如果它的值是“True”（存在、不为空、且不是boolean类型的false值），对应的内容块会输出。

if语句支持 and 、or、==、>、<、!=、<=、>=、in、not in、is、is not判断。

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言之标签</h1>
<hr>
{% if user %}
    <a href="">退出</a>
{% else %}
    <a href="">登录</a>
    <a href="">注册</a>
{% endif %}
<hr>
<h2>for循环套if</h2>
{% for foo in li %}
    {% if forloop.first %}
        <p>第一次</p>
    {% elif forloop.last %}
        <p>最后一次</p>
    {% else %}
        <p>{{ foo }}</p>
    {% endif %}
{% endfor %}
</body>
</html>
```

<!-- OCR_START -->
- 主页
- 别离开我啊，小老弟，点回来~
- 127.0.0.1:8000/index/
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe..
- 模板语言之标签
- 退出
- for循环套if
- 第一次
- 2
- 3
- 4
- 最后一次
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 标签使用-别名 |
| :--- |

使用一个简单地名字缓存一个复杂的变量，当你需要使用一个“昂贵的”方法（比如访问数据库）很多次的时候是非常有用的。或者字典和列表的深度比较深例如`li.lnmp.framework.web.package`我们可以简化as`packages`

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主页</title>
</head>
<body>
<h1>模板语言之标签</h1>
<hr>
{% with name as qqq %}
    <p>{{ qqq }}</p>
{% endwith %}
```

***

| 标签使用-csrf_token |
| :--- |

这个标签用于跨站请求伪造保护

```plain
{% csrf_token%}
```

## 自定义标签和过滤器

1.在settings中的INSTALLED_APPS配置当前app，不然django无法找到自定义的simple_tag.

2.在app中创建templatetags模块(模块名只能是templatetags)

3.创建任意 .py 文件，如：my_tags.py

```plain
from django import template
from django.utils.safestring import mark_safe
 
register = template.Library()   #register的名字是固定的,不可改变
 
 
@register.filter
def filter_multi(v1,v2):
    return  v1 * v2
<br>
@register.simple_tag
def simple_tag_multi(v1,v2):
    return  v1 * v2
<br>
@register.simple_tag
def my_input(id,arg):
    result = "<input type='text' id='%s' class='%s' />" %(id,arg,)
    return mark_safe(result)
```

4.在使用自定义simple_tag和filter的html文件中导入之前创建的 my_tags.py

```plain
{% load my_tags %}
```

5.使用simple_tag和filter（如何调用）

```plain
-------------------------------.html
{% load xxx %}     
# num=12
{{ num|filter_multi:2 }} #24
 
{{ num|filter_multi:"[22,333,4444]" }}
 
{% simple_tag_multi 2 5 %}  参数不限,但不能放在if for语句中
{% simple_tag_multi num 5 %}
```

\*\*注意：\*\*filter可以用在if等语句后，simple_tag不可以

```plain
{% if num|filter_multi:30 > 100 %}
    {{ num|filter_multi:30 }}
{% endif %}
```

## 模板导入

***

| 模板导入介绍 |
| :--- |

需求，之前写了一个组件，index.html中用，login.html页面也需要使用。所以我们需要写一个模板，然后导入。

***

| 创建项目 |
| :--- |

```plain
from django.shortcuts import render
# Create your views here.
def template_test(request):
    return render(request,'template_test.html')
```

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^template/', views.template_test),
]
```

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>模板导入</title>
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <style>
        .head {
            height: 60px;
            background: #1b6d85;
            margin-bottom: 10px;
        }
        body{
            background: #0f0f0f;
        }
    </style>
</head>
<body>
<div class="head"></div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-danger">
                <div class="panel-heading">
                    <h3 class="panel-title">欧美</h3>
                </div>
                <div class="panel-body">
                    金八天国
                </div>
                <div class="panel-footer">点击查看</div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">
                    <h3 class="panel-title">日韩</h3>
                </div>
                <div class="panel-body">
                    东京热
                </div>
                <div class="panel-footer">点击查看</div>
            </div>
            <div class="panel panel-success">
                <div class="panel-heading">
                    <h3 class="panel-title">大型**网站</h3>
                </div>
                <div class="panel-body">
                    草榴社区
                </div>
                <div class="panel-footer">点击付费</div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">
                    <h3 class="panel-title">egon</h3>
                </div>
                <div class="panel-body">
                    重金求子
                </div>
                <div class="panel-footer">点击查看详情</div>
            </div>
            <div class="panel panel-danger">
                <div class="panel-heading">
                    <h3 class="panel-title">图区</h3>
                </div>
                <div class="panel-body">
                    丝袜美腿
                </div>
                <div class="panel-footer">点击查看</div>
            </div>
        </div>
        <div class="col-md-9"></div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 模板导入
- 别离开我啊，小老弟，点回来～
- ←→C
- 127.0.0.1:8000/template/
- 应用zabbix-api
- CanlUseiview组件IElement曾志高翔（Drivere..
- 欧美
- 金八天国
- 点击查看
- 日韩
- 东京热
- 大型*网站
- 草榴社区
- 点击付费
- egon
- 重金求子
- 点击查看详情
- 图区
- 丝袜美腿
- 曾老湿
<!-- OCR_END -->

￼

左边的导航区域，我觉得很好看，其他页面也需要用到，我们就需要给它导入`{% include 'left.html' %}`。

**left.html**

```plain
<div class="panel panel-danger">
    <div class="panel-heading">
        <h3 class="panel-title">欧美</h3>
    </div>
    <div class="panel-body">
        金八天国
    </div>
    <div class="panel-footer">点击查看</div>
</div>
<div class="panel panel-warning">
    <div class="panel-heading">
        <h3 class="panel-title">日韩</h3>
    </div>
    <div class="panel-body">
        东京热
    </div>
    <div class="panel-footer">点击查看</div>
</div>
<div class="panel panel-success">
    <div class="panel-heading">
        <h3 class="panel-title">大型**网站</h3>
    </div>
    <div class="panel-body">
        草榴社区
    </div>
    <div class="panel-footer">点击付费</div>
</div>
<div class="panel panel-warning">
    <div class="panel-heading">
        <h3 class="panel-title">egon</h3>
    </div>
    <div class="panel-body">
        重金求子
    </div>
    <div class="panel-footer">点击查看详情</div>
</div>
<div class="panel panel-danger">
    <div class="panel-heading">
        <h3 class="panel-title">图区</h3>
    </div>
    <div class="panel-body">
        丝袜美腿
    </div>
    <div class="panel-footer">点击查看</div>
</div>
```

template_test.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>模板导入</title>
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <style>
        .head {
            height: 60px;
            background: #1b6d85;
            margin-bottom: 10px;
        }
        body{
            background: #0f0f0f;
        }
    </style>
</head>
<body>
<div class="head"></div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
        <!-- 导入模板 -->
            {% include 'left.html' %}
        </div>
        <div class="col-md-9"></div>
    </div>
</div>
</body>
</html>
```

## 模板继承

Django模版引擎中最强大也是最复杂的部分就是模版继承了。模版继承可以让您创建一个基本的“骨架”模版，它包含您站点中的全部元素，并且可以定义能够被子模版覆盖的 blocks 。

***

| 创建项目 |
| :--- |

views.py

```plain
from django.shortcuts import render
# Create your views here.
def template_test(request):
    return render(request,'template_test.html')
def template1(request):
    return render(request,'template1.html')
```

urls.py

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^template/', views.template_test),
    url(r'^template1/', views.template1),
]
```

template1.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>模板继承</title>
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <style>
        .head {
            height: 60px;
            background: #1b6d85;
            margin-bottom: 10px;
        }
        body{
            background: #0f0f0f;
        }
        p{
            color: white;
        }
    </style>
</head>
<body>
<div class="head"></div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            {% include 'left.html' %}
        </div>
        <div class="col-md-9">
            <p>这里是9的区域</p>
            <p>这里是9的区域</p>
            <p>这里是9的区域</p>
            <p>这里是9的区域</p>
            <p>这里是9的区域</p>
            <p>这里是9的区域</p>
            <p>这里是9的区域</p>
            <p>这里是9的区域</p>
            <p>这里是9的区域</p>
        </div>
    </div>
</div>
</body>
</html>
```

<!-- OCR_START -->
- 模板导入
- ×|Python进阶29-Django模板层（×
- 模板继承
- →C
- 127.0.0.1:8000/template1/
- 9
- 应用zabbix-api
- CanlUseiview组件IElement曾志高翔（DriverZe..
- 欧美
- 这里是9的区域
- 金八天国
- 点击查看
- 日韩
- 东京热
- 大型*网站
- 草榴社区
- 点击付费
- egon
- 重金求子
- 点击查看详情
- 图区
- 丝袜美腿
- 曾老湿
<!-- OCR_END -->

￼

我现在只想让9的区域变化，其他的地方都不变，这里就需要用到模板的继承了。

第一步，我们需要定义一个 `母版`，就是母体，其他网站都继承这个母体。

base.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>模板继承</title>
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <style>
        .head {
            height: 60px;
            background: #1b6d85;
            margin-bottom: 10px;
        }
        body{
            background: #0f0f0f;
        }
        p{
            color: white;
        }
    </style>
</head>
<body>
<div class="head"></div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            {% include 'left.html' %}
        </div>
        <div class="col-md-9">
            {% block content %}
            {% endblock %}
            
        </div>
    </div>
</div>
</body>
</html>
```

template1.html 继承母版

```plain
{% extends 'base.html' %}
```

<!-- OCR_START -->
- 模板导入
- ×Python进阶29-Django模板层（×
- 模板继承
- →C
- 127.0.0.1:8000/template1/
- 应用zabbix-api
- CanlUseiview组件IElement曾志高翔（Drivere..
- 欧美
- 金八天国
- 点击查看
- 日韩
- 东京热
- 大型*网站
- 草榴社区
- 点击付费
- egon
- 重金求子
- 点击查看详情
- 图区
- 丝袜美腿
- 曾老湿
<!-- OCR_END -->

￼

template1.html 添加内容

```plain
{% extends 'base.html' %}
{% block content %}
    <p>这是9的区域</p>
    <p>这是9的区域</p>
    <p>这是9的区域</p>
    <p>这是9的区域</p>
    <p>这是9的区域</p>
    <p>这是9的区域</p>
    <p>这是9的区域</p>
{% endblock %}
```

<!-- OCR_START -->
- 模板导入
- ×|Python进阶29-Django模板层（×
- 模板继承
- →C
- 127.0.0.1:8000/template1/
- 应用zabbix-api
- CanIUseiview组件|Element曾志高翔（Driverze.
- 欧美
- 这是9的区域
- 金八天国
- 点击查看
- 日韩
- 东京热
- 大型*网站
- 草榴社区
- 点击付费
- egon
- 重金求子
- 点击查看详情
- 图区
- 丝袜美腿
- 曾老湿
<!-- OCR_END -->

￼

测试再创建一个template2.html

```plain
{% extends 'base.html' %}
{% block content %}
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
{% endblock %}
```

添加路由

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^template/', views.template_test),
    url(r'^template1/', views.template1),
    url(r'^template2/', views.template2),
]
```

添加视图

```plain
from django.shortcuts import render
# Create your views here.
def template_test(request):
    return render(request,'template_test.html')
def template1(request):
    return render(request,'template1.html')
def template2(request):
    return render(request,'template2.html')
```

<!-- OCR_START -->
- 模板导入
- 模板继承
- 127.0.0.1:8000/template1/
- 127.0.0.1:8000/template2/
- 应用zabbix-apiCanlUseiview组件|Element
- 曾志高翔（DriverZe.
- 应用zabbix-apiCanlUseiview
- 组件|Element
- 欧美
- 这是9的区域
- 这里是template2的页面
- 金八天国
- 点击查看
- 日韩
- 东京热
- 大型*网站
- 草榴社区
- 点击付费
- egon
- 重金求子
- 点击查看详情
- 图区
- 丝袜美腿
- 曾老湿
<!-- OCR_END -->

￼

***

| 既显示母版内容又显示自己内容 |
| :--- |

请注意，子模版并没有定义 sidebar block，所以系统使用了父模版中的值。父模版的 {% block %} 标签中的内容总是被用作备选内容（fallback）。

这种方式使代码得到最大程度的复用，并且使得添加内容到共享的内容区域更加简单，例如，部分范围内的导航。

这里是使用继承的一些提示：

1.如果你在模版中使用 {% extends %} 标签，它必须是模版中的第一个标签。其他的任何情况下，模版继承都将无法工作。

2.在base模版中设置越多的 {% block %} 标签越好。请记住，子模版不必定义全部父模版中的blocks，所以，你可以在大多数blocks中填充合理的默认内容，然后，只定义你需要的那一个。多一点钩子总比少一点好。

3.如果你发现你自己在大量的模版中复制内容，那可能意味着你应该把内容移动到父模版中的一个 {% block %} 中。

If you need to get the content of the block from the parent template, the {{ block.super }} variable will do the trick. This is useful if you want to add to the contents of a parent block instead of completely overriding it. Data inserted using {{ block.super }} will not be automatically escaped (see the next section), since it was already escaped, if necessary, in the parent template.

**base.html**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>模板继承</title>
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <style>
        .head {
            height: 60px;
            background: #1b6d85;
            margin-bottom: 10px;
        }
        body{
            background: #0f0f0f;
        }
        p{
            color: white;
        }
    </style>
</head>
<body>
<div class="head"></div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            {% include 'left.html' %}
        </div>
        <div class="col-md-9">
            {% block content %}
                <p>这是母版的内容</p>
                <p>这是母版的内容</p>
                <p>这是母版的内容</p>
                <p>这是母版的内容</p>
                <p>这是母版的内容</p>
                <p>这是母版的内容</p>
            {% endblock %}
            
        </div>
    </div>
</div>
</body>
</html>
```

**template2.html**

```plain
{% extends 'base.html' %}
{% block content %}
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    {{ block.super }}
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
    <p>这里是template2的页面</p>
{% endblock %}
```

<!-- OCR_START -->
- 模板导入
- ×模板继承
- →C
- 127.0.0.1:8000/template2/
- 应用zabbix-api
- CanlUseiview组件IElement曾志高翔（DriverZe.
- 欧美
- 这里是template2的页面
- 金八天国
- 点击查看
- 这是母版的内容
- 日韩
- 东京热
- 大型*网站
- 草榴社区
- 点击付费
- egon
- 重金求子
- 点击查看详情
- 图区
- 丝袜美腿
- 曾老湿
<!-- OCR_END -->

￼

## 静态文件配置

```plain
{% load static %}

```

**引用JS文件时使用：**

```plain
{% load static %}
<script src="{% static "mytest.js" %}"></script>
```

某个文件多处被用到可以存为一个变量

```plain
{% load static %}
{% static "images/hi.jpg" as myphoto %}
</img>
```

### 使用get_static_prefix

```plain
{% load static %}

```

或者

```plain
{% load static %}
{% get_static_prefix as STATIC_PREFIX %}

```

### inclusion_tag

多用于返回html代码片段

示例：

templatetags/my_inclusion.py

```plain
from django import template
register = template.Library()
@register.inclusion_tag('result.html')
def show_results(n):
    n = 1 if n < 1 else int(n)
    data = ["第{}项".format(i) for i in range(1, n+1)]
    return {"data": data}
```

templates/snippets/result.html

```plain
<ul>
  {% for choice in data %}
    <li>{{ choice }}</li>
  {% endfor %}
</ul>
```

templates/index.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="x-ua-compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>inclusion_tag test</title>
</head>
<body>
{% load inclusion_tag_test %}
{% show_results 10 %}
</body>
</html>
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水

> 更新: 2020-06-25 11:33:42  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/zd56ev>