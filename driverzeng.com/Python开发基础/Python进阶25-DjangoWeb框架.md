# Python进阶25-Django Web框架

## Python进阶25-Django Web框架
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(7) 评论(0)

+ [基于socket手撸web框架](https://blog.driverzeng.com/zenglaoshi/5516.html#toc_0)
+ [基于wsgiref自定义web框架](https://blog.driverzeng.com/zenglaoshi/5516.html#toc_1)
+ [从数据库中取出数据渲染页面](https://blog.driverzeng.com/zenglaoshi/5516.html#toc_2)
+ [Django安装](https://blog.driverzeng.com/zenglaoshi/5516.html#toc_3)
+ [创建Django项目](https://blog.driverzeng.com/zenglaoshi/5516.html#toc_4)
+ [写第一个页面](https://blog.driverzeng.com/zenglaoshi/5516.html#toc_5)
+ [Django请求的生命周期](https://blog.driverzeng.com/zenglaoshi/5516.html#toc_6)

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

## 基于socket手撸web框架
---

| 服务端 |
| :--- |

```plain
import socket
sc = socket.socket()
sc.bind(('127.0.0.1', 8001))
sc.listen(5)
while True:
    so, addr = sc.accept()
    data = so.recv(1024)
    print(data)
    so.send(b'hello zls web')
    so.close()
```

<!-- OCR_START -->
- 127.0.0.1
- →C
- 127.0.0.1:8001
- 应用zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe
- 该网页无法正常运作
- 127.0.0.1发送的响应无效。
- ERR_INVALID_HTTP_RESPONSE
- 重新加载
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-./Django/手撸web框架/myserver.py[PYTHON]
- PYTHONDjango手撸web框架myserver.py
- myserver
- G#CCEI
- myserver.py
- Project
- import socket
- PYTHON~/Desktop/PYTHON
- 2
- ATM
- sc= socket.socket（)
- Django
- sc.bind(('127.0.0.1',
- 8001))
- 手撸web框架
- sc.listen(5)
- socket
- while True:
- udp
- so,addr = sc.accept（)
- 基础
- data = so.recv(1024)
- 并发编程
- 10
- print(data)
- lliExternal Libraries
- 11
- so.send(b'hello web')
- Scratches and Consoles
- 12
- so.close()
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverz
- GET/HTTP/1.1\r\nHost:127.0.0.1:8001\r\nCo
- Mozilla/5.
- Kit/537.36（KHTML,LikeGecko)Chrome/83.0.4103.97Saf
- 曾老湿
- GET/HTTP/1.1\r\nHc
- X10141）AppleW
<!-- OCR_END -->

￼

显示不了，为啥呢？因为服务端给浏览器返回的内容，浏览器不认识。我们要给浏览器返回http协议的内容

---

| 返回HTTP协议 |
| :--- |

```plain
import socket
sc = socket.socket()
sc.bind(('127.0.0.1', 8001))
sc.listen(5)
while True:
    so, addr = sc.accept()
    data = so.recv(1024)
    print(data)
    so.send(b'HTTP/1.1 200 OK\r\n\r\nhello zls web')
    so.close()
```

<!-- OCR_START -->
- 127.0.0.1:8002
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔（DriverZe...
- hello zls web
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
| er.py | er.py | er.py | er.py | er.py | 排名(PYTHONDjango手撸web框架) |
| --- | --- | --- | --- | --- | --- |
| ATM | SO | =socket.socket() | Django | 4 | sc.bind((127.0.0.1',8002)) |
| 手撸web框架 | sc.listen(5) | cket | while True: | udp | 8 |
| so,addr =sc.accept（) | 基础 | 9 | data = so.recv（1024) | 并发编程 | 10 |
| print(data) | llExternal Libraries | 11 | so.send(b'HTTP/1.1200OK\r\n\r\nhellozlsweb') | Scratches and Consoles | 12 |
| so.close() | myserverx | /Users/driverze | ng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/Djang | /手措web框架/myserver.py | b'GET |
<!-- OCR_END -->

￼

---

| 添加响应体 |
| :--- |

```plain
import socket
sc = socket.socket()
sc.bind(('127.0.0.1', 8002))
sc.listen(5)
while True:
    so, addr = sc.accept()
    data = so.recv(1024)
    print(data)
    so.send(b'HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\nhello zls web')
    so.close()
```

<!-- OCR_START -->
- 127.0.0.1:8002
- →C
- 应用
- zabbix
- CanlUse
- Viview
- 组件|Eleme
- 曾志高翔（DriverZe
- hellozlsweb
- Sources
- Network
- Performa
- Mem
- Application
- Security
- Lighthouse
- Preserve logDisable cache
- Online
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
- Preview Response Initiator Timing
- 127.0.0.1
- General
- favicon.ico
- RequestURL:http://127.0.0.1:8002/
- Request Method:GET
- Status Code:2000K
- Remote Address:127.0.0.1:8002
- Referrer Policy:no-referrer-when-dow
- Response Headers
- 曾老湿
- Content-Type:text/html
<!-- OCR_END -->

￼

---

| 取出uri |
| :--- |

```plain
import socket
sc = socket.socket()
sc.bind(('127.0.0.1', 8001))
sc.listen(5)
while True:
    so, addr = sc.accept()
    data = so.recv(1024)
    print(data)
    data=str(data,encoding='utf-8')
    uri=data.split('\r\n')[0].split(' ')[1]
    print(uri)
    so.send(b'HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\nhello zls web')
    so.close()
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-../Django/手撸web框架/myserver.p
- PYTHoNDjango手撸web框架
- myserver.py
- import socket
- 2
- 3
- =socket.socket（)
- sc.bind(('127.0.0.1',8001))
- 5
- sc.listen(5)
- while True:
- 8
- so,addr = sc.accept()
- 9
- data = s0.recv（1024)
- 10
- print(data)
- 11
- data=str(data,encoding='utf-8')
- 12
- uri=data.split('\r\n')[o].split('')[1]
- 13
- print(uri)
- 14
- so.send(b'HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\nhello zls web')
- 15
- so.close()
- Run:
- myserver x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHoN/Django/手撸web框架/myserver.py
- b'GET
- HTTP/1.1\r\nHost:127.0.0.1:8001\r\nConnection:keep-alive\r\nPragma:no-cache\r\nCache-Control:no-cache\r\nUpgrade-Insecure
- UEI
- favicon.ico HTTP/1.1\r\nHost:127.0.0.1:8001\r\nConnection:keep-alive\r\nPragma:no-cache\r\nCache-Control:no-cache\r\nUser-
- /favicon.ico
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

---

| 获取用户访问路径 |
| :--- |

```plain
import socket
sc = socket.socket()
sc.bind(('127.0.0.1', 8001))
sc.listen(5)
while True:
    so, addr = sc.accept()
    data = so.recv(1024)
    so.send(b'HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n')
    data=str(data,encoding='utf-8')
    uri=data.split('\r\n')[0].split(' ')[1]
    if uri == '/':
        so.send(b'index.html')
    else:
        so.send(b'404')
    so.close()
```

<!-- OCR_START -->
- 127.0.0.1:8001
- →C127.0.0.1:8001
- 应用zabbix-apiCanlUseiview组件IElement曾志高翔（Drivere
- index.html
- Preserve logDisable cache
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
- Status
- Type
- Initiator
- Size
- Time
- 200
- document
- Other
- 53B
- 曾老湿
- text/html
- Othe
- 46B
- 1ms
<!-- OCR_END -->

￼

<!-- OCR_START -->
| 名称 | 排名 | 名称 |
| --- | --- | --- |
| + | ←→C | 0127.0.0.1:8001/askdjads |
| ★ | 9 | 应用zabbix-api |
| CanlIUseiview组件IElement曾志高翔（Drivere. | 404 | 曾老湿 |
<!-- OCR_END -->

￼

---

| 返回HTML |
| :--- |

我们来返回一个html代码

```plain
import socket
sc = socket.socket()
sc.bind(('127.0.0.1', 8002))
sc.listen(5)
while True:
    so, addr = sc.accept()
    data = so.recv(1024)
    so.send(b'HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n')
    data=str(data,encoding='utf-8')
    uri=data.split('\r\n')[0].split(' ')[1]
    if uri == '/':
        so.send(b'<h1>zls_web</h1><img src="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591892187097&di=acd00d338f39e4d31aae486db1b53ec7&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F279759ee3d6d55fb0b6e354e6b224f4a20a4dd2a.jpg">')
    else:
        so.send(b'404')
    so.close()
```

<!-- OCR_START -->
- 127.0.0.1:8002
- →C
- 应用zabbix-api
- CanlUseiview组件IElement曾志高翔（DriverZe.
- zls_web
- 曾老湿
<!-- OCR_END -->

￼

竟然这样可以返回一个html，那么我们是不是可以写到一个html文件中？

---

| HTML写入文件 |
| :--- |

```plain
import socket
sc = socket.socket()
sc.bind(('127.0.0.1', 8002))
sc.listen(5)
while True:
    so, addr = sc.accept()
    data = so.recv(1024)
    so.send(b'HTTP/1.1 200 OK\r\nContent-Type:text/html\r\n\r\n')
    data=str(data,encoding='utf-8')
    uri=data.split('\r\n')[0].split(' ')[1]
    if uri == '/':
        with open('index.html','rb') as f:
            page=f.read()
        so.send(page)
    else:
        so.send(b'404')
    so.close()
```

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>曾老湿web</title>
</head>
<body>
<h1>zls_web</h1>
<img src="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591892187097&di=acd00d338f39e4d31aae486db1b53ec7&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F279759ee3d6d55fb0b6e354e6b224f4a20a4dd2a.jpg">
</body>
</html>
```

## 基于wsgiref自定义web框架
---

| 服务端 |
| :--- |

```plain
from wsgiref.simple_server import make_server
def run(env, response):
    print(env)
    response('200 OK', [('Content-type', 'text/html')])
    return [b'hello zls web']
if __name__ == '__main__':
    ser = make_server('127.0.0.1', 8003, run)
    ser.serve_forever()
```

<!-- OCR_START -->
- 曾老湿web
- 127.0.0.1:8003
- 应用
- zabbix-api
- CanlUse
- iview
- 组件|Element
- 曾志高翔(DriverZe...
- hello zls web
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- PYTHONDI Djangoa手撸web框架
- wsgirefServer.py
- CE
- Project
- wsgiref.simple_server
- make_server
- PYTHON~/Desktop/PYTHON
- ATM
- def run（env,response):
- Django
- print(env
- 手撸web框架
- respon
- 2000K',[（'Con
- ntent-type'，‘text/html')])
- index.html
- return [b'hello zls web']
- myserver.py
- name_
- main
- socket
- 10
- if
- ser=make_server(127.0.0.1',8003,run)
- udp
- ser.serve_forever()
- 基础
- 并发编程
- Run:
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/Desktop/PYTHON/Django/手措web框架/wsgirefServer.py
- 'PATH':/Users/driverzeng/PycharmProjects/untitled1/venv/bin:/Users/driverzeng/.yarn/bin:/Users/driverzeng/.config/yarn/global/node_modules/.bin:/usr/local/opt/openssl/bin:/Library/Frameworks/Python.framework/Versions/3.6/
- 127.0.0.1
- -[11/Jun/202022:04:54]GET/fAaVicon.icoHTTP/1.120013
- 曾老湿
<!-- OCR_END -->

￼

---

| 取出uri |
| :--- |

<!-- OCR_START -->
- PYTHON Django
- 手撸web框架
- wsgirefServer.py
- G#CCE
- Project
- wsgiref.simple_server
- PYTHON~/Desktop/PYTHON
- ATM
- run(env
- Django
- print(env)
- （'200 ok'，[('Content-type’，
- 'text/html')]）
- index.html
- uri=env
- myserver.py
- return[b'hello zls web']
- 10
- cket
- 11
- if
- __name
- udp
- ser=make_server(127.0.0.1′，,8003，run）
- 基础
- 12
- 13
- ser.serve_forever()
- 并发编程
- 14
- lExternal Libraries
- run()
- Scratches and Consoles
- wsgirefServer
- WSGISerVer/0.2'，REQUEST_METHOD':'GET’
- 'PATH_INFO:/`,
- QUERY_STRING':'，‘REMOTE_ADDR':‘127.0.0.1'，'CONTENT_TYPE':‘teXt/pLain'，HTTP_HOST':'127.0.0.1:8003'，HTTP_CONNECTION':'Keep-aLive'，HTTP_UPGRADE_INSEC
- WSGISerVer/0.2'，'REQUEST_METHOD':'GET'，‘PATH_INFO':/faVicon.ico'，QUERY_STRING':，'REMOTE_ADDR':‘127.0.0.1'，'CONTENT_TYPE':‘text/plain'，HTTP_HOST':‘127.0.0.1:803'，‘HTTP_CONNECTION':‘keep-aLive'，‘HTTP_US
- 曾老湿
<!-- OCR_END -->

￼

```plain
from wsgiref.simple_server import make_server
def index(env):
    return 'index'
def zls_time(env):
    return 'zls_time'
def error(env):
    return '404'
urls = [
    ('/', index),
    ('/time', zls_time),
]
def run(env, response):
    response('200 OK', [('Content-type', 'text/html')])
    uri = env['PATH_INFO']
    func = None
    for url in urls:
        if uri == url[0]:
            func = url[1]
            break
    if func:
        response = func(env)
    else:
        response = error(env)
    return [response.encode('utf-8')]
if __name__ == '__main__':
    ser = make_server('127.0.0.1', 8003, run)
    ser.serve_forever()
```

<!-- OCR_START -->
- 曾老湿web
- 127.0.0.1:8003
- ←→C
- 8
- 应用zabbix-api
- CanlUseiview
- 组件|Element曾志高翔（DriverZe.
- index
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿web
- 127.0.0.1:8003/time
- ←→C
- 应用zabbix-api
- CanlUseiview
- 组件|Element曾志高翔（DriverZe.
- zls_time
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿web
- 127.0.0.1:8003/xxx
- ←→C
- 应用zabbix-apiCanlUseiview组件IElement曾志高翔（Drivere.
- 404
- 曾老湿
<!-- OCR_END -->

￼

---

| 分开路由 |
| :--- |

**wsgiServer.py**

```plain
from wsgiref.simple_server import make_server
from url import urls
from views import error
def run(env, response):
    response('200 OK', [('Content-type', 'text/html')])
    uri = env['PATH_INFO']
    func = None
    for url in urls:
        if uri == url[0]:
            func = url[1]
            break
    if func:
        response = func(env)
    else:
        response = error(env)
    return [response.encode('utf-8')]
if __name__ == '__main__':
    ser = make_server('127.0.0.1', 8003, run)
    ser.serve_forever()
```

**views.py**

```plain
def index(env):
    return 'index'
def zls_time(env):
    return 'zls_time'
def error(env):
    return '404'
```

**url.py**

```plain
from views import *
urls = [
    ('/', index),
    ('/time', zls_time),
]
```

---

| 创建一个存放HTML的目录 |
| :--- |

index.html

```plain
<!DOCTYPE html>
<html lang="zh-Hans">
<head>
    <meta charset="UTF-8">
    <title>曾老湿index</title>
</head>
<body>
<h1>曾老湿 index 页面</h1>
<img src="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591892187097&di=acd00d338f39e4d31aae486db1b53ec7&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F279759ee3d6d55fb0b6e354e6b224f4a20a4dd2a.jpg">
</body>
</html>
```

views.py

```plain
def index(env):
    with open('templates/index.html','r') as f:
        data=f.read()
    return data
def zls_time(env):
    return 'zls_time'
def error(env):
    return '404'
```

<!-- OCR_START -->
- 曾老湿index
- 127.0.0.1:8003
- 应用zabbix-api
- CanlUse
- iview组件|Element曾志高翔（DriverZe.
- 曾老湿index页面
- 曾老湿
<!-- OCR_END -->

￼

---

| 动态请求 |
| :--- |

time.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>曾老湿time</title>
</head>
<body>
    <div>
        {{ time }}
    </div>
</body>
</html>
```

views.py

```plain
import datetime
def index(env):
    with open('templates/index.html', 'r') as f:
        data = f.read()
    return data
def zls_time(env):
    ctime = datetime.datetime.now().strftime('%Y-%m-%d %X')
    with open('templates/time.html', 'r') as f:
        data = f.read()
        data = data.replace('{{ time }}', ctime)
    return data
def error(env):
    return '404'
```

上面代码我们手动替换的页面。

---

| 使用jinja2渲染页面 |
| :--- |

安装jinja2

<!-- OCR_START -->
- Available Packages
- Q-jinja2
- Jinja2
- Description
- Jinja2-Dev-Server
- A very fast and expressive template engine.
- Jinja2-Ext
- Version
- Jinja2-Minify
- 2.11.2
- Jinja2-Redis
- Author
- Jinja2-Typogrify
- Armin Ronacher
- Jinja2-template-info
- Jinja2Bear
- mailto:armin.ronacher@active-4.com
- Jinja2Loader
- https://palletsprojects.com/p/jinja/
- Jinja2Pipe
- Sanic-Jinja2-SPF
- TemplateAlchemy-Jinja2
- aiohttp-jinja2
- aiohttp-jinja2-haggle
- aspen-jinja2
- bareasgi-jinja2
- charms.templating.jinja2
- cherrypy-jinja2
- deform_jinja2
- django-jinja2
- django-jinja2loader
- djedi-cms-jinja2
- falcon-jinja2
- hypernova-jinja2-directive
- impaf-jinja2
- Specify version
- 3.0.0a1
- japronto-jinja2
- Options
- Package Jinja2' installed successfully
- 曾老湿
- age
- Manage Repositories
- Driver Zeng
<!-- OCR_END -->

￼

views.py

```plain
import datetime
from jinja2 import Template
def index(env):
    with open('templates/index.html', 'r') as f:
        data = f.read()
    return data
def zls_time(env):
    ctime = datetime.datetime.now().strftime('%Y-%m-%d %X')
    with open('templates/time.html', 'r') as f:
        data = f.read()
        data = data.replace('{{ time }}', ctime)
    return data
def test(env):
    with open('templates/test.html', 'r') as f:
        data = f.read()
    tem = Template(data)
    response = tem.render(user={'name': 'zls', 'age': 18})
    return response
def error(env):
    return '404'
```

url.py

```plain
from views import *
urls = [
    ('/', index),
    ('/time', zls_time),
    ('/test',test)
]
```

test.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>曾老湿 test web</title>
</head>
<body>
    {{user.name}}
    {{user.age}}
</body>
</html>
```

<!-- OCR_START -->
- 曾老湿testweb
- 127.0.0.1:8003/test
- 应用zabbix-api
- CanlUseiview
- 组件|Element曾志高翔（DriverZe.
- zls18
- 曾老湿
<!-- OCR_END -->

￼

## 从数据库中取出数据渲染页面
---

| url输入user拿出用户 |
| :--- |

**url.py**

```plain
from views import *
urls = [
    ('/', index),
    ('/time', zls_time),
    ('/test',test),
    ('/user',user),
]
```

**views.py**

```plain
import datetime
from jinja2 import Template
import pymysql
def index(env):
    with open('templates/index.html', 'r') as f:
        data = f.read()
    return data
def zls_time(env):
    ctime = datetime.datetime.now().strftime('%Y-%m-%d %X')
    with open('templates/time.html', 'r') as f:
        data = f.read()
        data = data.replace('{{ time }}', ctime)
    return data
def test(env):
    with open('templates/test.html', 'r') as f:
        data = f.read()
    tem = Template(data)
    response = tem.render(user={'name': 'zls', 'age': 18})
    return response
def user(env):
    conn = pymysql.connect(host='10.0.0.51', port=3306, user='zls', password='123', database='zls')
    cursor=conn.cursor(pymysql.cursors.DictCursor)
    cursor.execute('select *  from zls.user')
    dic=cursor.fetchall()
    print(dic)
    with open('templates/user.html', 'r') as f:
        data = f.read()
    tem = Template(data)
    response = tem.render(user_list=dic)
    return response
def error(env):
    return '404'
```

**user.html**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>曾老湿 MySQL User页面</title>
</head>
<body>
<table border="1">
    <thead>
    <tr>
        <th>id</th>
        <th>名字</th>
        <th>年龄</th>
    </tr>
    </thead>
    <tbody>
    {% for user in user_list %}
    <tr>
        <td>{{user.id}}</td>
        <td>{{user.name}}</td>
        <td>{{user.age}}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>
</body>
</html>
```

<!-- OCR_START -->
- 曾老湿MySQLUser页面
- 1
- C127.0.0.1:8003/user
- 国★
- 应用zabbix-apiCanlUse
- Viviev
- 组件IEle
- 曾志高翔（DriverZe
- id名字年龄
- 1zis18
- 2qls83
- 曾老湿
<!-- OCR_END -->

￼

修改数据库，在再查看页面

```plain
mysql> insert into zls.user values(3,'lxx',73);
```

<!-- OCR_START -->
- 曾老湿MySQLUser页面
- →C127.0.0.1:8003/user
- 应用zabbix-api
- CanlUseiview
- 组件|Element
- 曾志高翔（DriverZe
- id名字年龄
- 1zis18
- 2qls
- 83
- 曾老湿
<!-- OCR_END -->

￼

## Django安装
---

| 安装方式 |
| :--- |

**Django官方网站:**[TP](https://www.djangoproject.com/)

1.方法一

```plain
(venv) bash-3.2$ pip3 install Django==1.11.18
```

<!-- OCR_START -->
MacBook-pro:~driverzeng$pip3installDjango==1.11.18-ihttps://mirrors.aliyun.com/pypi/simple/
Collecting Django==1.11.18
Cache entry deserialization failed,entry ignored
Downloadinghttps://mirrors.aliyun.com/pypi/packages/e0/eb/6dc122c6d0a82263bd26bebae3cdbafeb99a7281aa1dae57ca1f645a9872/Django-1.11.18-py2.py3-none-any.whl (6.9MB)
100%
7.0MB257KB/s
Collectingpytz(from Django==1.11.18)
Downloadinghttps://mirrors.aliyun.com/pypi/packages/4f/a4/879454d49688e2fad93e59d7d4efda580b783c745fd2ec2a3adf87b0808d/pytz-2020.1-py2.py3-none-any.whl(510kB)
512kB572kB/s
Installing collected packages:pytz,Django
SuccessfullyinstalledDjango-1.11.18pytz-2020.1
曾老湿
pipversion9.0.1,howeverversion20.1.1isavailable.
<!-- OCR_END -->

￼

2.方法二

<!-- OCR_START -->
- File
- EditView
- Navigate
- Code
- Refactor
- Tools
- VCS
- Window
- Help
- 周五17:36
- driverzeng
- AboutPyCharm
- PYTHON[~/Desktop/PYTHON]
- PYTHONI
- PY
- Check for Updates...
- 框架
- i templates
- user.html
- Preferences..
- 8,
- index.html
- url.ov
- views.Dy
- user.ht
- Proiect
- Services
- Q-
- Project:PYTHON
- Project Interpreter
- Forcur
- Q-django
- Hide PyCharm
- AI
- Hide Others
- Python 3.6(untitled1)/PycharmP
- Django
- Description
- Ke
- ShowAll
- Django-504
- Package
- A high-level PythonWeb fram
- vork thatencouragesrapid development and clean
- Ec
- Quit PyCharm
- 8Q
- Django-Abstract-Relations
- Jinja2
- 2.11.2
- pragmaticdesign
- Plugins
- Django-Accounts
- Version
- MarkupSafe
- 1.1.1
- Version Control
- Django-Actuary
- 3.0.7
- PyMySQL
- 0.9.3
- Django-Admin-Object-Actions
- Author
- PyNaCI
- 1.4.0
- Django-ArrayAccum
- bcrypt
- Django Software Foundation
- 3.1.7
- Django-Avocado
- Project Structure
- certifi
- 2020.4.5.1
- Django-Bootstrap3-Validator
- Build,Execution,Deployment
- cffi
- 1.14.0
- Django-Chuck
- Languages&Frameworks
- chardet
- 3.0.4
- Django-ConfPages
- 2.9.2
- Django-Custom-User-Model
- cryptography
- 2.9
- idna
- Django-Data-lmport
- paramiko
- 2.7.1
- 10.0.1
- Django-Deployment-Tools
- pip
- Django-Drupal-Password-Hasher
- pycparser
- 2.20
- Django-EMS-R25
- pygame
- 1.9.6
- Django-EMS-WhenIWork
- requests
- 2.23.0
- Django-EditArea
- setuptools
- 39.1.0
- Django-EventAggregator
- six
- 1.15.0
- Django-FIDO-U2F
- urllib3
- 1.25.9
- Django-Forwarded
- Django-G11N
- Django-Gtranslate
- Django-Gtts
- Django-HTTPolice
- Specifyversion
- 3.1a1
- Django-HardWorker
- Options
- Install Package
- Manage Repositories
- 曾老湿
<!-- OCR_END -->

￼

## 创建Django项目
---

| 命令创建项目 |
| :--- |

```plain
# 进入目录
MacBook-pro:PYTHON driverzeng$ cd /Users/driverzeng/Desktop/PYTHON
#创建项目
MacBook-pro:PYTHON driverzeng$ django-admin startproject myfirstdjango
```

<!-- OCR_START -->
- PYTHON
- 88:
- Q搜索
- 名称
- 修改日期
- 大小
- 种类
- pycache_
- 文件夹
- 并发编程
- 基础
- ATM
- Django
- myfirstdjango
- socket
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- myfirstdjango
- 88:
- Q搜索
- 名称
- 修改日期
- 大小
- 种类
- PC
- manage.py
- 今天18:05
- 811字节
- Python 脚本
- 文件夹
- __init_.py
- 0字节
- settings.py
- 3KB
- urls.py
- 770字节
- wsgi.py
- 404字节
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

创建项目不够，还需要创建app，也就是不同的功能模块

```plain
# 进入到Django项目目录下
MacBook-pro:PYTHON driverzeng$ cd /Users/driverzeng/Desktop/PYTHON/myfirstdjango
# 创建app01
MacBook-pro:myfirstdjango driverzeng$ python3 manage.py startapp app01
```

<!-- OCR_START -->
- myfirstdjango
- 888
- Q搜索
- 名称
- 修改日期
- 大小
- 种类
- app01
- 今天18:11
- 文件夹
- PC
- manage.py
- 今天18:05
- 811字节
- Python脚本
- PG
- init_.py
- 0字节
- pycache_
- settings.py
- 3KB
- urls.py
- 770字节
- wsgi.py
- 404字节
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

使用pycharm打开项目

**注意：**

1.项目的路径不能有中文

2.计算机名字不能有中文

3.一个工程就是一个项目

<!-- OCR_START -->
- 曾老湿

```text
myfirstdjango
Project
~/Desktop/PYTHON/myfirstdjango
app01
migrations
_init_.py
admin.py
apps.py
tests.py
views.py
urls.py
settings.py
wsgi.py
manage.py
Search Everywhere Double
al Libraries
les andConsoles
GotoFileN
```
<!-- OCR_END -->

￼

```plain
# 项目入口，执行一些命令
manage.py
# myfirstdjango 项目
settings.py
urls：总路由，请求地址跟视图函数映射关系
# app01
migrations：数据库迁移的记录
models.py：数据库表模型
views.py：视图函数
```

---

| 图形化创建项目：推荐 |
| :--- |

<!-- OCR_START -->
- New Project
- Pure Python
- Locatiol
- /Users/driverzeng/PycharmProjects/zlsdjango
- dj Django
- Flask
- Project Interpreter:Python 3.6
- O-
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
- AngularJS
- BBootstrap
- Application name:
- app01
- Foundation
- Enable Django admin
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

---

| 启动项目 |
| :--- |

**方法一：**

```plain
MacBook-pro:myfirstdjango driverzeng$ python3 manage.py runserver 127.0.0.1:8001
```

<!-- OCR_START -->
- 曾老湿MySQLUser页面
- ×-]pypi镜像-pypi下载地址-pypi安×
- Welcome to Django
- ←→C
- 127.0.0.1:8001
- 应用zabbix-api
- CanlIUse
- iview组件IElement曾志高翔（DriverZe
- It worked!
- Congratulations on your first Django-powered page.
- Next,start your first app byrunning python manage.py startapp [app_label]
- You'resee
- eyouhaveDEBUG
- 曾老湿
<!-- OCR_END -->

￼

**方法二：**

<!-- OCR_START -->
- 曾老湿

```text
myfirstdjar
top/PYTHON/myfirstdjango]
myfirstdjangomanage.py
Project
myfirstdjango/Desktop/PYTHON/myfirstdjango
app01
migrations
init_.py
admin.py
apps.py
models.py
tests.py
views.py
myfirstdjango
_init_.py
settings.py
urls.py
wsgi.py
db.sqlite3
Search Everywhere Double
manage.py
llliExternalLibraries
GotoFileN
Scratches and Consoles
Recent Files E
Navigation Bar
Drop files here to open
```
<!-- OCR_END -->

￼

## 写第一个页面
**urls.py**

```plain
"""zlsdjango URL Configuration
The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.contrib import admin
from app01.views import *
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'index/', index),
]
```

**views.py**

```plain
from django.shortcuts import render,HttpResponse,redirect
# Create your views here.
def index(request):
    return render(request,'index.html',{'name':'zls'})
```

**index.html**

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>曾老湿第一个Django页面</title>
</head>
<body>
    {{ name }}
</body>
</html>
```

<!-- OCR_START -->
zlsdjangozisdjango
urls.py
djzlsdjango
Project
settings.py
urlspyx
views.pyx
index.html×
zlsdjango
~/Pycha
rmProjects/zlsdjango
zlsdjango URL Configuration
app01
Theurlpatterns'listroutes URLs toviews.Formore information please see:
migrations
_init_.py
Examples:
admin.py
Function views
apps.py
1.Add an import:from my_app import views
models.py
tests.py
Class-based views
10
1.Add an import:from other_app.views import Home
views.py
2.AddaURLtourlpatterns:url(r$，Homeasview），name=home)
11
templates
12
Including another URLconf
13
1.Import the include(）function:from django.conf.urls import url,include
2.Add a URL tourlpatterns:url(r'blog/'，include('blog.urls'))
from django.conf.urlsimporturl
from
django.contrib import admin
wsgi.py
1819
app01.views import *
db.sqlite3
manage.py
20
urlpatterns=[
IlExternal Libraries
22
url(r'
admin.site.urls),
url(r'index/
/,index),
Scratches and Consoles
23
24
Run:
/Library/Frameworks/Python.framer
ns/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/zlsdjango/manage.pyrunserver8001
Performing system checks...
System check identified no issues (0 silenced).
You have 13 unapplied migration（s）.Your project may not work properly until you apply the migrations for app(s）:admin, auth,contenttypes, sessions.
Django version 1.11.18,using settings zlsdiango.settings
Starting development server
http://127.0.0.1:8001/
曾老湿
uit the server with CONTROL-
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿MySQLUser页面
- pypi镜像-pypi下载地址-pypi安：×
- 曾老湿第一个Django页面
- C127.0.0.1:8001/index/
- 应用zabbix-api
- CanIUseiview组件lElement曾志高翔（DriverZe
- zls
- 曾老湿
<!-- OCR_END -->

￼

## Django请求的生命周期

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

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

> 更新: 2020-06-25 11:30:31  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/mg59wx>