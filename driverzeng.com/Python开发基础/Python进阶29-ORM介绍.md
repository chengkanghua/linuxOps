# Python进阶29-ORM介绍

## Python进阶29-ORM介绍

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(2) 评论(0)

* [pycharm连接数据库](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_0)
* [orm介绍](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_1)
* [使用orm](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_2)
* [orm操作增删改查](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_3)
* [小练习：图书管理系统表设计](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_4)
* [单表操作基本流程](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_5)
* [执行数据库操作](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_6)
* [基于双下划线的模糊查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_7)
* [多表模型](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_8)
* [添加表记录](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_9)
* [基于对象的连表查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_10)
  * [一对一查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_11)
  * [一对多查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_12)
* [多对多查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_13)
* [连续跨表](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_14)
* [打印Django查询数据的SQL语句](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_15)
* [基于双下划线查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_16)
* [聚合查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_17)
* [分组查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_18)
* [F查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_19)
* [Q查询](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_20)
* [ORM反向生成models](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_21)
* [ORM常用和非常用字段](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_22)
* [ORM字段参数](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_23)
* [ORM关系字段](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_24)
* [OneToOneField](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_25)
* [ManyToManyField](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_26)
* [多对多关联关系的三种方式](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_27)
* [元信息](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_28)
* [自定义字段（了解）](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_29)
* [defer和only](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_30)
* [事务操作](https://blog.driverzeng.com/zenglaoshi/5571.html#toc_31)

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

## pycharm连接数据库

***

| 连接MySQL |
| :--- |

<!-- OCR_START -->
- login[~/Pych
- loginapp01
- views.py
- djlogin
- #C
- Project
- setings.py x
- urls.pyx
- login.html
- Database
- rmProjects/login
- from django.shortcuts import render,
- HttpResponse,
- redirect
- import pymysql
- app01
- migrations
- Data Source
- Amazon Redshift
- DL
- DDLData Source
- Apache Cassandra
- admin.py
- #Create your views
- here.
- Data Source from URL
- Apache Derby
- def
- login(request):
- ifrequest.method='GET':
- Data Source from Path
- Azure SQL Database
- apps.py
- lClickHouse
- models.py
- Driver and Data Source
- tests.py
- Driver
- XExasol
- 1111213141516171819212
- name = request.POST.get（name')
- H2H2
- pwd=request.POST.get（‘pwd’)
- Import from Sources...
- HSQLDB
- 连接数据库
- IBMDb2LUW
- _init_py
- Cret
- settings.py
- MariaDB
- urls.py
- cursor
- =conn.cursor(pymysql.cursors.DictCursor)
- MicrosoftSQLServer
- cursor.execute('select * from user where name=%s and password%s'，[name，pwd])
- MySQL
- wsgi.py
- static
- Oracle
- ifuser:
- return HttpResponse（登录成功）
- PostgreSQL
- bootstrap-3.3.7-dist
- else:
- SQLite
- CSS
- fonts
- returnHttpResponse(用户名密码错误）
- Sybase ASE
- js
- 22
- templates
- db.sqlite3
- manage.py
- ll External Libraries
- Scratches and Consoles
- login()elfrequest.method ==POST'else
- 曾老湿
<!-- OCR_END -->

￼

下载驱动

<!-- OCR_START -->
- Data Sources and Drivers
- 十一区
- Name:
- @localhost
- Reset
- Project Data Sources
- Comment:
- General
- SSH/SSL
- Schemas
- Options
- Advanced
- Drivers
- Host:
- Port:
- 3306
- Amazon Redshift
- Database:
- Apache Derby (Embedded)
- Apache Derby (Remote)
- User:
- Azure SQL Database
- Password:
- <hidden>
- Remember password
- Cassandra
- ClickHouse
- URL:
- jdbc:mysql://localhost:3306
- default
- Exasol
- Overrides settings above
- H2H2
- Test Connection
- HSQLDB (Local)
- HSQLDB (Remote)
- Driver:
- MySQL
- IBMDb2
- IBM Db2(JTOpen)
- MariaDB
- Microsoft SQL Server
- Microsoft SQL Server (jTds)
- Oracle
- Tx: Auto
- Read-only  Auto sync
- PostgreSQL
- SQLite
- Download
- missing driver files
- 曾老湿
- Cancel
- Apply
- OK
- DriverZeng
<!-- OCR_END -->

￼

配置连接数据库

<!-- OCR_START -->
- Data Sources and Drivers
- 十一#区
- Name:
- zls@10.0.0.51
- Reset
- Project Data Sources
- Comment:
- General
- SSH/SSLSchemasOptionsAdvanced
- Drivers
- Host:
- 10.0.0.51
- Port
- 3306
- Amazon Redshift
- Database:
- zls
- Apache Derby （Embedded)
- Apache Derby （Remote)
- User:
- Azure SQL Database
- Passv
- ord:
- Remember password
- Cassandra
- ClickHouse
- URL:
- jdbc:mysql://10.0.0.51:3306/zls
- default
- Exasol
- Overrides settings above
- H2
- Test Connection
- Successful Details
- HSQLDB (Local)
- HSQLDB (Remote)
- Driver:
- MySQL
- IBMDb2
- IBM Db2(JTOpen)
- MariaDB
- Microsoft SQL Server
- Microsoft SQL Server (jTds)
- Oracle
- PostgreSQL
- SQLite
- Tx:Auto
- Read-only  Auto sync
- 曾老湿
- Cancel
- Apply
- OK
- DriverZeng
<!-- OCR_END -->

￼

查看数据

<!-- OCR_START -->
- Database
- 十面
- QL
- zls@10.0.0.511of19
- schemas 1
- zls
- user
- collations 219
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

添加数据

<!-- OCR_START -->
- settings.py
- urls.py
- views.py
- zls@10.0.0.51
- zls.user[zls@10.0.0.51]
- login.html
- Database
- 3rows
- Tx:Auto
- Tab-se...d(TSV)
- DDL
- ViewQuery
- GV
- <Filter criteria>
- zls@10.0.0.511of19
- idname
- password
- schemas1
- 1zls
- 123
- zis
- 2
- 2cls
- 111
- user
- 3
- 3wls
- 222
- id int(11)
- name varchar（10)
- passwordvarchar（10)
- collations219
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 连接sqllite |
| :--- |

<!-- OCR_START -->
- logindb.sqlite3
- djlogin
- Project
- settings.py
- urls.py×
- views.pyxzls@10.0.0.51x
- zls.user[zls@10.0.0.51x
- login.html
- Database
- login~/PycharmProjects/login
- 3rows
- 1
- G+-Tx:Auto
- Tab-se.d（TSV)DDL
- ViewQuery
- app01
- <Filter criteria>
- Column
- migrations
- idname
- password
- _init_.py
- Table
- 1zls
- 123
- iIndex
- admin.py
- 2cls
- 111
- ForeignKey
- apps.py
- 3wls
- 222
- Schema
- models.py
- tests.py
- 10)
- views.py
- nar(10)
- DataSource
- MySQL
- DDLData Source
- Amazon Redshift
- Data SourcefromURL
- Data Source from Path
- Apache Cassandra
- wsgi.py
- Apache Derby
- Driver and Data Source
- AzureSQL Database
- static
- Driver
- lClickHouse
- bootstrap-3.3.7-dist
- Import from Sources.
- Exasol
- CSS
- fonts
- H2H2
- HSQLDB
- Mjs
- IBMDb2LUW
- templates
- MariaDB
- loain.htm
- Microsoft SQL Server
- db.salite3
- Oracle
- manage.py
- PostareSQL
- llExternal Libraries
- SQLite
- Scratches and Consoles
- Sybase ASE
- 曾老湿
<!-- OCR_END -->

￼

复制路径

<!-- OCR_START -->
- static
- bootstrap-3.3.7-dist
- css
- New
- fonts
- Associate with File Type...
- Ijs
- Cut
- 8X
- templates
- Copy
- 8C
- loain.html
- Copy Path
- db.sqlite3
- Copy Relative Path
- manage.py
- Paste
- 8V
- External Libraries
- Open SQLite database
- F4
- Scratches and Consoles
- Find Usages
- LF7
- Inspect Code...
- Refactor
- Database Console:
- zls.user[zls@10.0.
- Clean Python Compiled Files
- [2020-06-12 21:37:58]Conne
- sql> use zls
- Add to Favorites
- [2020-06-12 21:37:58]c0mpl
- Sql> SELECT t.* FROM zls.US
- Delete...
- LIMIT 501
- [2020-06-12 21:37:58]2 roW
- Reveal in Finder
- s（execution:9 ms
- SgL> INSERT INTO
- zls.use
- （3，'wls','222'）
- Open in Terminal
- [2020-06-12 21:38:44] 1 roW
- Local History
- G Synchronize'db.sqlite3'
- [2020-06-12 21:38:44]3 roW
- （execution:7 ms,
- Edit Scopes...
- Compare With...
- 8D
- Compare File with Editor
- Database Change
- Diagrams
- nsole
- 三6:TODO
- 曾老湿
- minutes ago)
- Create Gist...
- Driver Zeng
<!-- OCR_END -->

￼

下载驱动，然后把路径填入

<!-- OCR_START -->
- Data Sources and Drivers
- 十一自区
- Name:
- db.sqlite3
- Reset
- Project Data Sources
- Comment:
- zls@10.0.0.51
- General
- SSH/SSL
- Schemas
- Options
- Advanced
- File:
- /Users/driverzeng/PycharmProjects/login/db.sqlite3
- Drivers
- Amazon Redshift
- URL:
- jdbc:sqlite:/Users/driverzeng/PycharmProjects/login/db.sq
- default
- Apache Derby (Embedded)
- Overrides settings above
- Apache Derby (Remote)
- Test Connection
- Azure SQL Database
- Driver:SQLite
- Cassandra
- ClickHouse
- Exasol
- H2
- HSQLDB (Local)
- HSQLDB （Remote)
- IBMDb2
- IBM Db2 (JTOpen)
- MariaDB
- Microsoft SQL Server
- Microsoft SQL Server (jTds)
- MySQL
- Tx:Auto
- Read-only  Auto sync
- Oracle
- PostgreSQL
- Download
- missing driver files
- OAI
- 曾老湿
- Cancel
- Apply
- OK
- DriverZeng
<!-- OCR_END -->

￼

测试连接

<!-- OCR_START -->
- Data Sources and Drivers
- 十一自区
- Name:
- db.sqlite3
- Reset
- Project Data Sources
- Comment:
- zls@10.0.0.51
- General
- SSH/sSL SchemasOptionsAdvanced
- File:
- /Users/driverzeng/PycharmProjects/login/db.sqlite3
- Drivers
- Amazon Redshift
- URL:
- jdbc:sqlite:/Users/driverzeng/PycharmProjects/login/db.sq
- default
- Apache Derby (Embedded)
- Overrides settings above
- Apache Derby (Remote）
- Test Connection
- Successful Details
- A Azure SQL Database
- Driver:SQLite
- Cassandra
- ll ClickHouse
- X Exasol
- H2H2
- HSQLDB (Local)
- HSQLDB (Remote)
- IBMDb2
- EBM
- IBM Db2(JTOpen）
- MariaDB
- Microsoft SQL Server
- MicrosoftSQL Server (jTds)
- MySQL
- Oracle
- PostgreSQL
- Tx:Auto
- Read-only  Auto sync
- CAI
- 曾老湿
- Cancel
- Apply
- OK
- Driver Zeng
<!-- OCR_END -->

￼

## orm介绍

***

| 简介 |
| :--- |

<!-- OCR_START -->
- ORM
- class Book(models.Model):
- name=models.CharField（max_length=32)
- price=models.IntegerField()
- pymsql探作mysql
- mysql
- 曾老湿
- DB
- DriverZeng
<!-- OCR_END -->

￼

ORM即Object Relational Mapping，全称对象关系映射。

当我们需要对数据库进行操作时，势必需要通过连接数据、调用sql语句、执行sql语句等操作，ORM将数据库中的表，字段，行与我们面向对象编程的类及其方法，属性等一一对应，即将该部分操作封装起来，程序猿不需懂得sql语句即可完成对数据库的操作。

**优点：**

1.不用写sql,不会sql的人也可以写程序

2.开发效率高

**缺点：**

可能sql的效率低

***

| Python中常用ORM框架 |
| :--- |

**1.Django's ORM**

```plain
## 优点：
1.易用，学习曲线短 
2.和Django紧密集合，用Django时使用约定俗成的方法去操作数据库 
##缺点：
1.不好处理复杂的查询，强制开发者回到原生SQL 
2.紧密和Django集成，使得在Django环境外很难使用
```

**2.peewee**

```plain
##优点：
1.Django式的API，使其易用 
2.轻量实现，很容易和任意web框架集成 
## 缺点：
1.多对多查询写起来不直观
```

**3.SQLAlchemy**

```plain
## 优点：
1.企业级 API，使得代码有健壮性和适应性 
2.灵活的设计，使得能轻松写复杂查询 
## 缺点：
1.重量级 API，导致长学习曲线
```

## 使用orm

***

| 修改配置 |
| :--- |

<!-- OCR_START -->
| 名称 | 排名 | 名称 | 名称 |
| --- | --- | --- | --- |
| settings.py | urls.pyx | views.py x | login.html x |
| 77 | 78 | DATABASES= | 79 |
| 一 | default': | 80 | ENGINE':'django.db.backends |
| sqlite3 | 81 | 'NAME':os.path.join(BASE_DIR, | 'db.sqlite3') |
| 82 | 83 | 曾老湿 | Driver Zeng |
<!-- OCR_END -->

￼

默认Django连接的是sqllite3

settings.py

```plain
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'HOST': '10.0.0.51',
        'PORT': 3306,
        'USER': 'zls',
        'PASSWORD': '123',
        'NAME': 'zls',
    }
}
```

<!-- OCR_START -->
- settings.py x
- urls.py x
- views.py x
- login.html x
- 75
- DATABASES=
- 76
- 'default':{
- 77
- 'ENGINE':'django.db.backends.mysql
- 78
- 'HOST':'10.0.0.51'
- 79
- 'PORT':3306,
- 'USER':'zls',
- 80
- 81
- PASSWORD':'123'
- 'NAME':'zls',
- 82
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

修改`app01`模块中的`__init__.py`

```plain
##  告诉Django，别用MySQLdb了，使用pymysql
import pymysql
pymysql.install_as_MySQLdb()
```

***

| 建立映射关系 |
| :--- |

**注意：**

1.orm不能创建数据库

2.可以创建数据表

3.可以创建字段

**models.py**

```plain
from django.db import models
# Create your models here.
class User(models.Model):
    # 自增int类型，主键
    id = models.AutoField(primary_key=True)
    # varchar类型长度32
    name = models.CharField(max_length=32)
    # varchar类型长度32
    pwd = models.CharField(max_length=32)
```

![]()￼

使用命令创建表

```plain
MacBook-pro:login driverzeng$ python3 manage.py makemigrations
```

<!-- OCR_START -->
[root@mysql-db01~]#pwd
/root
[root@mysql-db01~]#登出
Connectionto10.0.0.51closed.
MacBook-pro:logindriverzeng$python3manage.pymakemigrations
Migrationsfor'app01':
app01/migrations/0001_initial.py
CreatemodelUser
MacBook-pro:logindriverzeng$
曾老湿
DriverZeng
<!-- OCR_END -->

￼

表没有创建出来，但是创建了一个文件

<!-- OCR_START -->
- 曾老湿

```text
login[~/PycharmProjects/login]-./appo1/models.py [login]
loginapp01
models.py
Project
settings.py
_init_.py
models.py
urls.py X
views.py
login.html
login ~/PycharmProjects/login
from django.db import models
app01
2
miarations
3
# Create your models here.
0001_initial.py
class User(models.Model):
_init_.py
6
#自增int类型，主键
_init_.py
id = models.AutoField(primary_key=True)
admin.py
8
9
#varchar类型长度32
apps.py
10
name = models.CharField（max_Length=32)
models.py
11
tests.py
12
#varchar类型长度32
views.py
13
pwd = models.CharField(max_length=32)
login
14
_init_.py
settings.py
urls.py
wsgi.py
static
bootstrap-3.3.7-dist
cSS
fonts
js
templates
login.html
db.sqlite3
manage.py
Ili External Libraries
ches and Consoles
DriverZeng
```
<!-- OCR_END -->

￼

```plain
MacBook-pro:login driverzeng$ python3 manage.py migrate
```

<!-- OCR_START -->
root@mysql-db01:~
root
[root@mysql-db01~]#登出
Connection to 10.0.0.51closed.
MacBook-pro:login driverzengspython3manage.pymakemigrations
Migrations for'app01':
app01/mgrations/000_initial.py
-Create model User
MacBook-pro:login driverzengs python3manage.py migrate
System check identified some issues:
WARNINGS:
?:(mysql.woo2)MySQL StrictModeisnot setfor database connection'default
HINT:MSQLsStrictMdefixesmanydataintegrityproblemsnMySQL,suchasdatatruncationuponinsertion,by
1.11/ref/databases/#mysql-sql-mode
activateit.See:https://docs.djang
Operationstoperform:
Apply allmigrations:admin,app01,auth,contenttypes，sessions
Runningmigrations:
Applying contenttypes.0001_initial...OK
OK
Applying admin.0001_initial...oK
Applyingapp01.0001_initial...oK
Applyingauth.0002_alter_permission_name_max_length...
Applyingauth.0003_alter_user_email_max_length...oK
Applyingauth.0004_alter_user_username_opts...
Applying auth.0005_alter_user_last_login_null.
Applying auth.0006_require_contenttypes_0002...
Applyingauth.0008_alter_user_username_max_length...oK
Applying sessions.0001_initial...oK
acBook-pro:login driverzengs
曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- settings.py
- _init_py
- models.py
- urls.py
- views.py
- login.html
- Database
- from django.db import models
- GI
- db.sqlite31
- # Create your models here
- zls@10.0.0.51 1of19
- class User(models.Model):
- schemas 1
- #自增int类型，主键
- id= models.AutoField(primary_key=True)
- zls
- app01_user
- 9
- #varchar类型长度32
- id int（11) (auto increment)
- 10
- name = models.CharField（max_length=32)
- name varchar（32)
- 11
- pwd varchar(32)
- 12
- PRIMARY（id）
- 13
- pwd = models.CharField（max_Length=32)
- 14
- auth_group
- auth_group_permissions
- auth_permission
- auth_user
- auth_user_groups
- auth_user_user_permissions
- django_admin_log
- django_content_type
- django_migrations
- django_session
- user
- collations 219
- 曾老湿
<!-- OCR_END -->

￼

**数据库迁移：**

```plain
## 记录数据库的变化
MacBook-pro:login driverzeng$ python3 manage.py makemigrations
## 将变化同步到数据库
MacBook-pro:login driverzeng$ python3 manage.py migrate
```

## orm操作增删改查

***

| 查数据 |
| :--- |

<!-- OCR_START -->
- settings.py
- _init_.py
- models.py
- zls.app01_user[zls@10.0.0.51]
- urls.py
- 三2
- Database
- 1row
- >1
- Tx:Auto
- √>Tab-se...d(TSV)
- DDL
- ViewQuery
- +、
- GV
- <Filter criteria>
- db.sqlite31
- idname
- pwd
- zls@10.0.0.51 1of19
- 1zls
- 123
- schemas1
- zls
- 曾老湿
- app01_user
- DriverZeng
<!-- OCR_END -->

￼

**views.py**

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
            return HttpResponse('登录成功')
        else:
            return HttpResponse('用户名密码错误')
```

<!-- OCR_START -->
- 127.0.0.1:8080/login
- 别离开我啊，小老弟，点回来~
- ×+
- ←→C
- 应用zabbix-apiCanlIUseiview组件|Element曾志高翔（DriverZe
- 登录成功
- 曾老湿
<!-- OCR_END -->

￼

***

| 添加字段 |
| :--- |

```plain
from django.db import models
# Create your models here.
class User(models.Model):
    # 自增int类型，主键
    id = models.AutoField(primary_key=True)
    # varchar类型长度32
    name = models.CharField(max_length=32)
    # varchar类型长度32
    pwd = models.CharField(max_length=32)
    # varchar类型长度64,默认值shanghai
    addr = models.CharField(max_length=64, default='shanghai')
```

```plain
MacBook-pro:login driverzeng$ python3 manage.py makemigrations
MacBook-pro:login driverzeng$ python3 manage.py migrate
```

<!-- OCR_START -->
- settings.py
- _init_.py
- models.py X
- zls.app01_user[zls@10.0.0.51]
- urls.py
- 三2
- Database
- 1row
- Tx:Auto
- Tab-se...d(TSV)
- DDL
- ViewQuery
- GV
- QL
- <Filter criteria>
- db.sqlite31
- idname
- pwd
- addr
- zls@10.0.0.511of19
- 1zls
- 123
- shanghai
- schemas1
- zls
- app01_user
- id int（11) (auto increment)
- name varchar（32)
- pwd varchar(32)
- addr varchar（64)
- PRIMARY(id)
- auth_group
- auth_group_permissions
- auth_permission
- auth_user
- auth_user_groups
- auth_user_user_permissions
- 用django_admin_log
- django_contenttype
- django_migrations
- django_session
- user
- collations 219
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

| 查询用户 |
| :--- |

urls.py

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url('login', views.login),
    url('userlist', views.userlist),
]
```

userlist.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>userlist</title>
</head>
<body>
    <table border="1">
        <thead>
        <tr>
            <th>id</th>
            <th>name</th>
            <th>password</th>
            <th>addr</th>
        </tr>
        </thead>
        <tbody>
        {% for user in user_list %}
            <tr>
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.pwd }}</td>
            <td>{{ user.addr }}</td>
            </tr>
        {% endfor %}
        </tbody>
    </table>
</body>
</html>
```

models.py

```plain
from django.db import models
# Create your models here.
class User(models.Model):
    # 自增int类型，主键
    id = models.AutoField(primary_key=True)
    # varchar类型长度32
    name = models.CharField(max_length=32)
    # varchar类型长度32
    pwd = models.CharField(max_length=32)
    # varchar类型长度64,默认值shanghai
    addr = models.CharField(max_length=64, default='shanghai')
```

views.py

```plain
from django.shortcuts import render, HttpResponse, redirect
from app01 import models
def userlist(request):
    if request.method == 'GET':
        ## 相当于 select * from app01_user ，查询user表中所有数据
        data = models.User.objects.all()  ## 返回结果QuerySet对象（先当成列表） [user1,user2]
        return render(request, 'userlist.html', {'user_list': data})
```

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 排名 | 名称 | 名称 |
| --- | --- | --- | --- | --- | --- |
| 别离开我啊，小老弟，点回来~ | userlist | →C127.0.0.1:8080/userlist | 8 | 应用zabbix-api | CanlUseiview |
| 组件\|Element曾志高翔（DriverZe | id | name | password | addr | 1z1s |
| 123 | shanghai | 2苍老师 | 111 | tokyo | 3波多野结衣222 |
<!-- OCR_END -->

￼

***

| 删除用户 |
| :--- |

userlist.html

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>userlist</title>
</head>
<body>
    <table border="1">
        <thead>
        <tr>
            <th>id</th>
            <th>name</th>
            <th>password</th>
            <th>addr</th>
            <th>删除</th>
        </tr>
        </thead>
        <tbody>
        {% for user in user_list %}
            <tr>
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.pwd }}</td>
            <td>{{ user.addr }}</td>
            <td><a href="/deluser?id={{ user.id }}">删除</a></td>
            </tr>
        {% endfor %}
        </tbody>
    </table>
</body>
</html>
```

添加路由`urls.py`

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url('login', views.login),
    url('userlist', views.userlist),
    url('deluser', views.deluser),
]
```

添加视图`views.py`

```plain
from django.shortcuts import render, HttpResponse, redirect
from app01 import models
def deluser(request):
    if request.method == 'GET':
        id = request.GET.get('id')
        data = models.User.objects.filter(id=id).delete()  ## 返回被修改的行数
        print(data)
        return redirect('/userlist/')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来~
- userlist
- ←→C
- 127.0.0.1:8080/userlist/
- 应用zabbix-api
- CanIUseiview组件IElement曾志高翔（Drivere.
- id
- name
- passwordaddr删除
- 2苍老师
- 111
- tokyo删除
- 3波多野结衣222
- 曾老湿
<!-- OCR_END -->

￼

***

| 增加用户 |
| :--- |

修改前端`userlist.html`

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>userlist</title>
</head>
<body>
    <table border="1">
        <thead>
        <tr>
            <th>id</th>
            <th>name</th>
            <th>password</th>
            <th>addr</th>
            <th>删除</th>
        </tr>
        </thead>
        <tbody>
        {% for user in user_list %}
            <tr>
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.pwd }}</td>
            <td>{{ user.addr }}</td>
            <td><a href="/deluser?id={{ user.id }}">删除</a></td>
            </tr>
        {% endfor %}
        </tbody>
    </table>
    <a href="/adduser/">新增用户</a>
</body>
</html>
```

添加路由`urls.py`

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url('login', views.login),
    url('userlist', views.userlist),
    url('deluser', views.deluser),
    url('adduser', views.adduser),
]
```

添加页面`adduser.html`

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>useradd</title>
</head>
<body>
<form action="" method="post">
    <p>用户:<input type="text" name="name"></p>
    <p>密码:<input type="password" name="password"></p>
    <p>地址:<input type="text" name="addr"></p>
    <input type="submit" value="提交">
</form>
</body>
</html>
```

添加视图`views.py`

```plain
from django.shortcuts import render, HttpResponse, redirect
from app01 import models
def adduser(request):
    if request.method == 'GET':
        return render(request, 'adduser.html')
    elif request.method == 'POST':
        name = request.POST.get('name')
        password = request.POST.get('password')
        addr = request.POST.get('addr')
        ## 方法一
        # data = models.User.objects.create(name=name, pwd=password, addr=addr)
        ## 方法二
        data = models.User(name=name, pwd=password, addr=addr)
        data.save()
        print(data.name)
        return redirect('/userlist/')
```

<!-- OCR_START -->
- 别离开我啊，小老弟，点回来～
- useradd
- →C
- 127.0.0.1:8080/adduser/
- 应用zabbix-apiCanlIUseiview组件|Element曾志高翔（DriverZe.
- 用户：zls111
- 密码：
- 地址：Peking
- 提交
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
| 别离开我啊，小老弟，点回来~ | 别离开我啊，小老弟，点回来~ | 别离开我啊，小老弟，点回来~ | 别离开我啊，小老弟，点回来~ | 排名 |
| --- | --- | --- | --- | --- |
| 9 | 应用zabbix-api | CanlUseiview组件IElement曾志高翔（DriverZe. | id | name |
| passwordaddr删除 | 2苍老师 | 11 | tokyo删除 | 3 |
| 波多野结衣222 | tokyo | 删除 | 5zls111 | 111 |
<!-- OCR_END -->

￼

***

| 修改用户 |
| :--- |

修改前端`userlist.html`

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>userlist</title>
</head>
<body>
    <table border="1">
        <thead>
        <tr>
            <th>id</th>
            <th>name</th>
            <th>password</th>
            <th>addr</th>
            <th>删除</th>
            <th>编辑</th>
        </tr>
        </thead>
        <tbody>
        {% for user in user_list %}
            <tr>
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.pwd }}</td>
            <td>{{ user.addr }}</td>
            <td><a href="/deluser?id={{ user.id }}">删除</a></td>
            <td><a href="/updateuser?id={{ user.id }}">编辑</a></td>
            </tr>
        {% endfor %}
        </tbody>
    </table>
    <a href="/adduser/">新增用户</a>
</body>
</html>
```

添加路由`urls.py`

```plain
from django.conf.urls import url
from django.contrib import admin
from app01 import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url('login', views.login),
    url('userlist', views.userlist),
    url('deluser', views.deluser),
    url('adduser', views.adduser),
    url('updateuser', views.updateuser),
]
```

添加页面`update.html`

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>updateuser</title>
</head>
<body>
<form action="" method="post">
    <p>用户:<input type="text" name="name" value="{{ data.name }}"></p>
    <p>密码:<input type="password" name="password" value="{{ data.pwd }}"></p>
    <p>地址:<input type="text" name="addr" value="{{ data.addr }}"></p>
    <input type="submit" value="提交">
</form>
</body>
</html>
```

添加视图`views.py`

```plain
from django.shortcuts import render, HttpResponse, redirect
from app01 import models
def updateuser(request):
    if request.method == 'GET':
        id = request.GET.get('id')
        data = models.User.objects.filter(id=id).first()
        return render(request, 'updateuser.html', {'data': data})
    if request.method == 'POST':
        ## 取出id两种方式
        # 方法一：
        ## 隐藏输入框：<p><input type="hidden" name="id" value="{{ data.id }}"></p>
        id = request.POST.get('id')
        # 方法二：
        ## form表单：<form action="/updateuser?id={{ data.id }}" method="post">
        # id2 = request.GET.get('id')
        # print(id,id2)
        name = request.POST.get('name')
        password = request.POST.get('password')
        addr = request.POST.get('addr')
        models.User.objects.filter(id=id).update(name=name, pwd=password, addr=addr)
        return redirect('/userlist/')
```

***

| 总结 |
| :--- |

```plain
## 数据的增删改查
        ****重点****:
        1 单表查询所有用户:models.User.objects.all()
            得到的是 queryset对象(当成列表),列表里面,一个一个的对象[user1,user2]
        2 render(request, 'userlist.html', {'user_list': ret})
        3 模板里:   {% for user in user_list %}
                        #要循环的内容 
                            {{user.name}}
                     {% endfor%}
        4 get请求携带参数:
            http://127.0.0.1:8080/deleteuser/?id=1
            后台取值:request.GET.get('id')
                    request.GET['id']
        5 orm删除记录 models.User.objects.filter(id=id).delete()
            返回值:影响的行数
        6 前台post提交的数据取值:name=request.POST.get('name')
        7 orm保存:
            两种方式:
            1 user=models.User.objects.create(name=name,password=pwd,address=addr)
            2 user=models.User(name=name,password=pwd,address=addr)
              user.save()
        8 orm查询单条数据:user=models.User.objects.filter(id=id).first()
        9 orm的修改 models.User.objects.filter(id=id).update(name=name,password=pwd,address=addr)
```

## 小练习：图书管理系统表设计

***

| 设计表 |
| :--- |

<!-- OCR_START -->
| 开始 | 开始 | 排名 | 开始 | 开始 |
| --- | --- | --- | --- | --- |
| 公式 | 数据 | 审阅 | 剪切 | 宋体 |
| 12 | A | A | L | 复制 |
| 粘贴 | B | I | U | abc |
| 格式 | U10 | fx | A | B |
| C | D | 1 | 出版社 | 2 |
| id | name | addr | email | 3 |
| 1北京出版上海市 | 22@qq.com | 4 | 5 | 6 |
| 7 | 作者 | 8 | 9 | id |
| name | addr | 10 | 1zls | 上海 |
| 11 | 2cls | 东京 | 12 | 13 |
| 14 | 书籍表 | 15 | id | name |
| price | publish_id | 16 | 1红楼梦 | 30 |
| 1 | 17 | 18 | 19 | 20 |
| 21 | booktoauthor（中间表） | 22 | id | book_id |
| authorid | 23 | 1 | 1 | 1 |
| 24 | 2 | 1 | 2 | 25 |
<!-- OCR_END -->

￼

```plain
图书管理系统多表设计:
        图书表--->出版社表---->一对多
            一对多的关系一旦确立,关联字段写在多的一方
        图书表--->作者表------>多对多
            多对多关系,需要创建第三张表
```

***

| 使用orm创建表 |
| :--- |

models.py

```plain
from django.db import models
class Publish(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    email = models.EmailField()
    address = models.CharField(max_length=64)
class Author(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    address = models.CharField(max_length=64)
class Book(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    ## 可以表示出 21.88 价格，也可以用varchar类型 max_digits:最大长度  decimal_places:小数点后面几位
    price = models.DecimalField(max_digits=5, decimal_places=2)
    ## 一对多的关系确立，关联字段写在多的一方，orm自动在publish后面加id  (publish_id)
    publish = models.ForeignKey(to='Publish', to_field='id')
    ##  对对多的关系，orm会自动创建第三张表
    authors = models.ManyToManyField(to='Author')
```

```plain
MacBook-pro:login driverzeng$ python3 manage.py makemigrations
MacBook-pro:login driverzeng$ python3 manage.py migrate
```

<!-- OCR_START -->
- 曾老湿

```text
app01
dels.py
djlogin
G#CCE
Project
gs.py
_init
armProjects/login
from django.db imp
lodels
app01
class Publish(models.Model):
hary_key=True)
0001_initial.py
zls@10.0.0.511of19
name
=models.CharField（max
0002_user_addr.py
email=models.EmailField(） 0003_auto_20200613_0347.py address =models.CharField（ init..py
dmin.py
```
<!-- OCR_END -->

￼

## 单表操作基本流程

***

| 基本配置 |
| :--- |

settings.py 修改连接数据库的信息

```plain
DATABASES = {
    # 'default': {
    #     'ENGINE': 'django.db.backends.sqlite3',
    #     'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    # }
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'zls_db',
        'HOST': '10.0.0.51',
        'PORT': 3306,
        'USER': 'zls',
        'PASSWORD': '123'
    }
}
```

创建数据库和用户

```plain
mysql> create database zls_db;
Query OK, 1 row affected (0.00 sec)
mysql> grant all on *.* to zls@'%' identified by '123';
Query OK, 0 rows affected (0.00 sec)
```

在__init\_\_.py中配置使用pymysql

```plain
## 因为Django默认连接mysql用的是MySQLdb模块，python3.0以后，不支持MySQLdb，需要用pymysql替换MySQLdb
import pymysql
pymysql.install_as_MySQLdb()
```

在models.py中建表

```plain
from django.db import models
# Create your models here.
class Book(models.Model):
    id=models.AutoField(primary_key=True)
    name=models.CharField(max_length=32)
    price=models.DecimalField(max_digits=5,decimal_places=2)
    publish=models.CharField(max_length=32)
    author=models.CharField(max_length=32)
    create_date=models.DateField(null=True)
```

开始创建数据

```plain
## 记录变化
MacBook-pro:orm driverzeng$ python3 manage.py makemigrations
## 写入数据库
MacBook-pro:orm driverzeng$ python3 manage.py migrate
## 查看未执行的记录文件
MacBook-pro:orm driverzeng$ python3 manage.py showmigrations
```

查看数据库

```plain
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
| zls_db             |
+--------------------+
mysql> use zls_db
mysql> show tables;
+----------------------------+
| Tables_in_zls_db           |
+----------------------------+
| app01_book                 |
| auth_group                 |
| auth_group_permissions     |
| auth_permission            |
| auth_user                  |
| auth_user_groups           |
| auth_user_user_permissions |
| django_admin_log           |
| django_content_type        |
| django_migrations          |
| django_session             |
+----------------------------+
11 rows in set (0.00 sec)
```

***

| 在python脚本中调用Django环境 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "untitled15.settings")
    import django
    django.setup()
    from app01 import models
    books = models.Book.objects.all()
    print(books)
```

## 执行数据库操作

***

| 增加数据 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    ## 插入数据的两种方式:
    # 方法一：返回结果是一个对象
    book_data=models.Book.objects.create(name='红楼梦',price=23.9,publish='人民出版社',author='曹雪芹',create_date='2018-09-17')
    print(book_data.name)
```

<!-- OCR_START -->
- 曾老湿
- 楼梦

```text
ormtest.py
test
#C三
Project
settings.py
models.py
test.py
urls.py
orm~/PycharmProjects/orm
import os
app01
name
os.enViron.setdefault("DJANGO_SETTINGS_MODULE"，“orm.settings"） migrations import django 0001_initial.py
django.setup()
0002_book_create_date.py
_init_.py
fromappo1 importmodels
admin.py
#插入数据的两种方式：
apps.py
=人民出版社
='2018-09-17')
12
print（book_data.name)
tests.py
views.py
orm
Library/Fran
```
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    ## 插入数据的两种方式:
    # 方法一：返回结果是一个对象
    # book_data=models.Book.objects.create(name='红楼梦',price=23.9,publish='人民出版社',author='曹雪芹',create_date='2018-09-17')
    # print(book_data.name)
    # 方法二：先实例化产生一个对象 ，然后调用save方法保存
    book_data=models.Book(name='金瓶没',price=99.9,publish='曾老湿出版社',author='曾老湿',create_date='2018-09-20')
    book_data.save()
    print(book_data.name)
```

<!-- OCR_START -->
- 插入数据的两种方式：
- 方法一：返回结果是一
- 个对象
- 方法二：先实例化产生
- 个对象，
- 金瓶没
- 曾老湿
- 瓶没

```text
orm[~/PycharmProjects/orm]
test.py[orm]
test.py
Project
ngs.py
manage.py
_init
test.p
orm~/PycharmProjects/orm
django.setup()
app01
migrations
fromappo1 import models
0001_initial.py
o002_book_create_date.py
10111213
_init_.py
#book_data=models.Book.objects.create（name=红楼梦’，price=23.9，publish=人民出版社’，author=曹雪芹，create_date=2018-09-17）
#print（book_data.name)
admin.py
然后调用save方法保存
14
book_data=models.Book（n
sh='曾老湿出版社
date='2018-09-20')
apps.py
models.py
16
print(book_data.name)
tests.py
views.py
test
```
<!-- OCR_END -->

￼

传日期格式

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    ## 插入数据的两种方式:
    # 方法一：返回结果是一个对象
    book_data=models.Book.objects.create(name='红楼梦',price=23.9,publish='人民出版社',author='曹雪芹',create_date='2018-09-17')
    # print(book_data.name)
    # 方法二：先实例化产生一个对象 ，然后调用save方法保存
    book_data=models.Book(name='金瓶没',price=99.9,publish='曾老湿出版社',author='曾老湿',create_date='2018-09-20')
    # book_data.save()
    # print(book_data.name)
    import datetime
    ctime=datetime.datetime.now()
    book_data = models.Book(name='水许传', price=19.9, publish='xx出版社', author='施奈淹', create_date=ctime)
    book_data.save()
    print(book_data.name)
```

查询数据

```plain
mysql> select * from app01_book;
+----+-----------+-------+--------------------+-----------+-------------+
| id | name      | price | publish            | author    | create_date |
+----+-----------+-------+--------------------+-----------+-------------+
|  1 | 红楼梦    | 23.90 | 人民出版社         | 曹雪芹    | 2018-09-17  |
|  2 | 红楼梦    | 23.90 | 人民出版社         | 曹雪芹    | 2018-09-17  |
|  3 | 金瓶没    | 99.90 | 曾老湿出版社       | 曾老湿    | 2018-09-20  |
|  4 | 水许传    | 19.90 | xx出版社           | 施奈淹    | 2020-06-14  |
+----+-----------+-------+--------------------+-----------+-------------+
4 rows in set (0.00 sec)
```

***

| 删除数据 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    ## 删除名字叫水许传的书
    ## 两种方式
    # 方式一：
    res = models.Book.objects.filter(name='水许传').delete()
    # print(res)
    # 方式二：
    res = models.Book.objects.filter(name='水许传').first()
    res.delete()
```

***

| 修改数据 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    ## 修改数据的两种方式
    # 方法一：
    res=models.Book.objects.filter(name='红楼梦').update(price=1.9)
    # 方法二：
    book=models.Book.objects.filter(name='红楼梦').first()
    book.price=99
    book.save()
```

***

| 查询数据(重点) |
| :--- |

查询API

```plain
<1> all():                  查询所有结果
  
<2> filter(**kwargs):       它包含了与所给筛选条件相匹配的对象
  
<3> get(**kwargs):          返回与所给筛选条件相匹配的对象，返回结果有且只有一个，如果符合筛选条件的对象超过一个或者没有都会抛出错误。
  
<4> exclude(**kwargs):      它包含了与所给筛选条件不匹配的对象
 
<5> order_by(*field):       对查询结果排序('-id')
  
<6> reverse():              对查询结果反向排序
  
<8> count():                返回数据库中匹配查询(QuerySet)的对象数量。
  
<9> first():                返回第一条记录
  
<10> last():                返回最后一条记录
  
<11> exists():              如果QuerySet包含数据，就返回True，否则返回False
 
<12> values(*field):        返回一个ValueQuerySet——一个特殊的QuerySet，运行后得到的并不是一系列
                            model的实例化对象，而是一个可迭代的字典序列
<13> values_list(*field):   它与values()非常相似，它返回的是一个元组序列，values返回的是一个字典序列
 
<14> distinct():            从返回结果中剔除重复纪录
```

**all**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.all()
    print(book_data)
```

<!-- OCR_START -->
```text
orm[~/PycharmProjects/orm]-./test.py[orm]
orm
test.py
Project
settings.py
manage.py
_init_.py
models.py
test.py
urls.py
orm ~/PycharmProjects/orm
Q-
Match Case
Words
Reg
app01
import os
migrations
if
name_
main
0001_initial.py
os.environ.setdefault("DJANGO_SETTINGS_MODULE","orm.settings")
0002_book_create_date.py
import django
_init_.py
django.setup()
_init_.py
from app01 import models
admin.py
book_data=models.Book.objects.all()
apps.py
print(book_data)
models.py
if_name_=='_main_'
Run:
testx
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm/test.py
<OuervSet[<Book:Bookobject>. <Book:Book object>. <Book:Book object>1> 曾老湿
rocessfinishedwithexitcodeo
DriverZeng
```
<!-- OCR_END -->

￼

如果想打印出来所有信息 ，就要去修改class

```plain
from django.db import models
# Create your models here.
class Book(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    price = models.DecimalField(max_digits=5, decimal_places=2)
    publish = models.CharField(max_length=32)
    author = models.CharField(max_length=32)
    create_date = models.DateField(null=True)
    def __str__(self):
        return '书名:%s,价格:%s' % (self.name, self.price)
```

<!-- OCR_START -->
- 曾老湿

```text
orm[~/PycharmProjects/orm]-../test.py[orm]
orm
test.py
Project
settings.py
manage.py
models.py
test.py
urls.py
orm~/PycharmProjects/orm
Q-
MatchCase
Words
Regex?
app01
import os
migrations
if
name_
main_':
0001_initial.py
os.environ.setdefauLt("DJANGO_SETTINGS_MODULE", "orm.settings")
0002_book_create_date.py
import django
_init_.py
django.setup()
init_.py
from
app01 import models
admin.py
book_data=models.Book.objects.all()
apps.py
print(book_data)
models.py
if_name_=='_main_
test>
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm/test.py
QuerySet[<Book：书名：红楼梦，价格：99.00>，<Book：书名：红楼梦，价格：1.90>，<Book：书名：金瓶没，价格：99.90>]>
DriverZeng
```
<!-- OCR_END -->

￼

**filter**

类似SQL语句中的where条件

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.filter(name='金瓶没').first()
    print(book_data)
```

**get**

get的使用比较少，有且只有一个结果的时候，才能使用，通常用id查询

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.get(name='金瓶没')
    print(book_data)
```

**exclude**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.exclude(name='金瓶没')
    print(book_data)
    
    
## 多条件查询
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.exclude(name='金瓶没',price=99.9)
    print(book_data)
    
    #  查看SQL语句
    print(book_data.query)
```

**order by**

```plain
##  按照价格排，升序
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    ## 升序
    book_data = models.Book.objects.all().order_by('price')
    print(book_data)
##  按照价格排，倒序   
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    #  倒序1
    book_data = models.Book.objects.all().order_by('price').reverse()
    print(book_data)
    #  倒序2
    book_data = models.Book.objects.all().order_by('-price')
    print(book_data)
    
##  只要是QuerySet对象 就可以一直'点'下去
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.all().order_by('-price').filter(name='红楼梦')
    print(book_data)
    
## 多条件排序，按照价格 和 时间排序
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.all().order_by('-price','create_date')
    print(book_data)
*********** 先修改model.py里面的内容，打印出时间 ***********
from django.db import models
# Create your models here.
class Book(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    price = models.DecimalField(max_digits=5, decimal_places=2)
    publish = models.CharField(max_length=32)
    author = models.CharField(max_length=32)
    create_date = models.DateField(null=True)
    def __str__(self):
        return '书名:%s,价格:%s,出版时间:%s' % (self.name, self.price,self.create_date)
```

**count**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.all().count()
    print(book_data)
```

**values**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.all().values('name','price')
    print(book_data)
    
## 相当于 select name,price from book;
```

**value_list**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.all().value_list('name','price')
    print(book_data)
    
## 返回元组
```

**distinct**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm.settings")
    import django
    django.setup()
    from app01 import models
    book_data = models.Book.objects.all().values('name').distinct()
    print(book_data)
```

## 基于双下划线的模糊查询

```plain
Book.objects.filter(price__in=[100,200,300])
Book.objects.filter(price__gt=100)
Book.objects.filter(price__lt=100)
Book.objects.filter(price__gte=100)
Book.objects.filter(price__lte=100)
Book.objects.filter(price__range=[100,200])
Book.objects.filter(title__contains="python")
Book.objects.filter(title__icontains="python")
Book.objects.filter(title__startswith="py")
Book.objects.filter(pub_date__year=2012)
```

```plain
#查询价格大于89 的书
ret=models.Book.objects.filter(price__gt='89')
print(ret)
#查询价格小于89 的书
ret=models.Book.objects.filter(price__lt='89')
print(ret)
#小于等于
ret=models.Book.objects.filter(price__lte='89')
#大于等于,
ret = models.Book.objects.filter(price__gte='89')
print(ret)
#in 在XX中
ret=models.Book.objects.filter(price__in=['23.8','89','100'])
print(ret)
print(ret.query)    
#range 在XX范围内 between and
ret=models.Book.objects.filter(price__range=[50,100])
print(ret.query)
#contains  查询名字有'%红%'的书
ret=models.Book.objects.filter(name__contains='红')
print(ret)
print(ret.query)
#icontains 查询名字带p的书,忽略大小写
ret=models.Book.objects.filter(name__icontains='P')
print(ret)
print(ret.query)
#startswith  以XX开头
ret=models.Book.objects.filter(name__startswith='红')
print(ret)
print(ret.query)
#endswith
ret=models.Book.objects.filter(name__endswith='梦')
print(ret)
#pub_date__year 按年查询
ret=models.Book.objects.filter(create_data__year='2017')
print(ret)
```

## 多表模型

***

| 建表 |
| :--- |

<!-- OCR_START -->
- 出版社表
- id
- name
- addr
- email
- 1北京出版上海市
- 123@qq.com
- 作者表
- authordetail_id
- 1zls
- 上海
- 21ls
- 北京
- 书籍表
- price
- publish_id
- 1红楼梦
- 30
- 作者详情
- phone
- sex
- booktoauthor(中间表)
- bookid
- author_id
- 1
- 2
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
from django.db import models
# Create your models here.
class Publish(models.Model):
    # id如果不写，会自动生成，名字叫nid并且自增
    id = models.AutoField(primary_key=True)
    name =  models.CharField(max_length=32)
    addr =  models.CharField(max_length=64)
    email =  models.EmailField()
class Author(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    addr = models.CharField(max_length=64)
    ## 数字类型
    sex = models.IntegerField()
    ## 一对一，外键 ，并且有唯一性约束
    # authordetail = models.ForeignKey(unique=True)
    ## Django内置了一对一的方法
    authordetail = models.OneToOneField(to='AuthorDetail',to_field='id')
class AuthorDetail(models.Model):
    id = models.AutoField(primary_key=True)
    phone = models.CharField(max_length=32)
    addr = models.CharField(max_length=64)
class Book(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    price = models.DecimalField(max_digits=5,decimal_places=2)
    ## 一对多的关系，关联字段创建在多的地方
    publish =  models.ForeignKey(to='Publish',to_field='id')
    ## 多对多的关系 ，创建在哪里 都可以
    authors = models.ManyToManyField(to='Author')
```

数据库迁移操作

```plain
MacBook-pro:orm2 driverzeng$ python3 manage.py makemigrations
MacBook-pro:orm2 driverzeng$ python3 manage.py migrate
```

使用脚本运行Django操作数据库

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
```

## 添加表记录

***

| 一对多新增数据 |
| :--- |

书跟出版社是一对多

先单表给出版社(publish)添加数据，这里我就直接用SQL语句添加了。

<!-- OCR_START -->
- .Py
- models.py
- test.py
- zls_orm@10.0.0.51
- zls_orm.app01_publish[zls_orm@10.0.0.51]
- 三5
- Database
- 3rows
- Tx:Auto
- Tab-se...d (TSV)
- DDL
- ViewQuery
- id
- name
- 闺addr
- email
- schemas1
- 1北京出版社
- 北京
- 123@qq.com
- zls_orm
- 2
- 南京出版社
- 南京
- 111@qq.com
- app01_author
- 3东京出版社
- 东京
- 222@qq.com
- app01_authordetail
- app01_book
- app01bookauthors
- 曾老湿
- app01publish
- DriverZeng
<!-- OCR_END -->

￼

```plain
## 添加一本北京出版社出版的书
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    # 第一种方式
    ret = Book.objects.create(name='红楼梦',price=34.5,publish_id=1)
    print(ret.name)
```

<!-- OCR_START -->
- .py
- models.py
- test.py
- zls_orm.app01_book[zls_orm@10.0.0.51]
- zls_orm@10.0.0.51
- 三6
- Database
- 1row
- Tx:Auto
- >Tab-se...d(TSV)
- DDL
- ViewQuery
- 十恒
- GVI
- <Filter criteria>
- idname
- price
- publish_id
- schemas1
- 1红楼梦
- 34.50
- zls_orm
- app01_author
- app01_authordetail
- 曾老湿
- DriverZeng
- app01_book
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 添加一本北京出版社出版的书
    # 第一种方式
    # ret = Book.objects.create(name='红楼梦',price=34.5,publish_id=1)
    # 第二种方式:存对象，publish=出版社对象,pk 是 primary key 主键
    publish = Publish.objects.get(pk=2)
    ret = Book.objects.create(name='西游记', price=34.5, publish=publish)
    print(ret.name)
```

<!-- OCR_START -->
- _-py
- models.py
- test.py
- zls_orm.app01_book[zls_orm@10.0.0.51]
- zls_orm@10.0.0.51
- 三6
- Database
- 2rows
- >1
- Tx:Auto
- Tab-se...d (TSV)
- DDL
- ViewQuery
- GVI
- Q<Filter criteria>
- zls_orm@10.0.0.511of6
- idname
- price
- publish_id
- schemas 1
- 1红楼梦
- 34.50
- zls_orm
- 2西游记
- 2
- app01_author
- app01_authordetail
- 曾老湿
- app01_book
- authors
<!-- OCR_END -->

￼

***

| 一对多修改数据 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 添加一本北京出版社出版的书
    # 第一种方式
    # ret = Book.objects.create(name='红楼梦',price=34.5,publish_id=1)
    # 第二种方式:存对象，publish=出版社对象,pk 是 primary key 主键
    # publish = Publish.objects.get(pk=2)
    # ret = Book.objects.create(name='西游记', price=34.5, publish=publish)
    ## 方法一：
    book = Book.objects.get(pk=1)
    # book.publish=对象
    book.publish_id=2
    book.save()
```

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 添加一本北京出版社出版的书
    # 第一种方式
    # ret = Book.objects.create(name='红楼梦',price=34.5,publish_id=1)
    # 第二种方式:存对象，publish=出版社对象,pk 是 primary key 主键
    # publish = Publish.objects.get(pk=2)
    # ret = Book.objects.create(name='西游记', price=34.5, publish=publish)
    ## 方法一：
    # book = Book.objects.get(pk=1)
    # book.publish=对象
    # book.publish_id=2
    # book.save()
    ## 方法二：
    # book = Book.objects.filter(pk=1).update(publish=出版社对象)
    book = Book.objects.filter(pk=1).update(publish_id=3)
```

***

| 多对多新增数据 |
| :--- |

**多对多新增的API**

```plain
book_obj.authors.add()         # 添加
book_obj.authors.remove()      # 将某个特定的对象从被关联对象集合中去除。    ======   book_obj.authors.remove(*[])
book_obj.authors.clear()       #清空被关联对象集合
book_obj.authors.set()         #先清空再设置
```

首先先给作者详情(authordetail)表和作者(author)表增加数据，单表添加就不演示了

<!-- OCR_START -->
- test.py
- zls_orm.app01_author[zls_orm@10.0.0.51]x
- zls_orm.app01_authordetail [zls_orm@10.0.0.51]
- 三7
- Database
- 2rows
- Tx:Auto
- >Tab-se...d(TSV)
- DDLViewQuery
- <Filter criteria>
- id
- phone
- addr
- schemas1
- 1
- 13056666666
- 上海
- zls_orm
- 213888888888
- 哈尔滨
- app01_author
- app01_authordetail
- 曾老湿
- app01_book
- rZeng
<!-- OCR_END -->

￼

![]()￼

**新增**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 给红楼梦的书添加一个作者
    zls = Author.objects.filter(name='zls').first()  ## 拿到zls对象
    lls = Author.objects.filter(name='lls').first()  ## 拿到lls对象
    book = Book.objects.filter(name='红楼梦').first()
    ## add添加多个对象，方法一：
    book.authors.add(zls, lls)
```

<!-- OCR_START -->
- p01_book_authors
- @10.0.0.51
- zls_orm.app01_book[zls_orm@10.0.0.51]
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- 三8Database
- 2rows
- >1
- Tx:Auto
- >Tab-se...d(TSV)
- DDL
- ViewQuery
- +自
- id
- bookid
- author_id
- schemas 1
- zls_orm
- 2
- app01_author
- app01_authordetail
- app01_book
- appo1_book_authors
- 曾老湿
- app01_publish
- DriverZeng
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 给红楼梦的书添加一个作者
    ## add添加作者id：方法二
    book = Book.objects.filter(name='红楼梦').first()
    book.authors.add(1,2)
```

<!-- OCR_START -->
- models.py
- test.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- tests.py
- 三1
- Database
- 2rows
- Tx:Auto
- >Tab-se...d(TSV)
- DDL
- ViewQuery
- GL
- <Filter criteria>
- zls_orm@10.0.0.51 1of6
- oid
- schemas1
- zls_orm
- 2
- app01_author
- app01_authordetail
- app01_book
- 曾老湿
- DriverZeng
- 田app01_book_authors
<!-- OCR_END -->

￼

***

| 多对多删除数据 |
| :--- |

remove

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 删除作者，使用对象方式
    book = Book.objects.filter(name='红楼梦').first()
    zls = Author.objects.filter(name='zls').first()  ## 拿到zls对象
    book.authors.remove(zls)
```

![]()￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 删除作者，使用id方式
    book = Book.objects.filter(name='红楼梦').first()
    book.authors.remove(2)
```

<!-- OCR_START -->
- models.py
- test.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- manage.py
- Database
- Orows
- Tx:Auto
- Tab-se...d(TSV)
- DDL
- ViewQuery
- Q<Filter criteria>
- id
- book_id
- authorid
- schemas1
- zls_orm
- app01_author
- app01_authordetail
- 用app01_book
- 曾老湿
- app01_book_authors
- DriverZeng
<!-- OCR_END -->

￼

**删除多个，先把数据添加回来**

<!-- OCR_START -->
- models.py
- test.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- manage.py
- Database
- 2rows
- Tx:Auto
- >Tab-se...d(TSV)
- DDL
- ViewQuery
- <Filter criteria>
- zls_orm@10.0.0.51 1of6
- id
- book_id
- author_id
- schemas1
- 1
- zls_orm
- 6
- app01_author
- 田app01_authordetail
- app01_book
- 曾老湿
- DriverZeng
- app01_book_authors
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 删除作者，使用id方式
    book = Book.objects.filter(name='红楼梦').first()
    book.authors.remove(1,2)
    ## 删除多个作者，使用对象方式
    book = Book.objects.filter(name='红楼梦').first()
    zls = Author.objects.filter(name='zls').first()  ## 拿到zls对象
    lls = Author.objects.filter(name='lls').first()  ## 拿到lls对象
    book.authors.remove(zls,lls)
```

**clear清空所有**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    # clear清空所有
    book = Book.objects.filter(name='红楼梦').first()
    book.authors.clear()
```

**set，先清空再添加**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    book = Book.objects.filter(name='红楼梦').first()
    ## 必须添加一个可迭代对象
    book.authors.set([2,])
    book.authors.set([zls,])
    
    ## 错误写法
    book.authors.set(*[zls,])
```

## 基于对象的连表查询

***

| 前戏知识点 |
| :--- |

**正向查询：**`author`表里面有跟`authordetail`表的关联字段，从`author`表查询到`authordetail`表就叫做正向查询

\*\*反向查询：\*\*反过来，从`authordetail`表查询到`author`表中，就是反向查询

### 一对一查询

正向查询按字段，反向查询按表名小写

***

| 需求：查询zls手机号 |
| :--- |

```plain
## 正向查询
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    author = Author.objects.filter(name='zls').first()
    ## author.authordetail是作者详情的对象
    authordetail = author.authordetail
    print(author.name,authordetail.phone)
```

<!-- OCR_START -->
- 曾老湿

```text
orm2[~/PycharmProjects/orm2]-..test.py[orm2]
Project
odels.py
test.py
n@10.0.0.51]
anage.py
Database
orm2~/Pych
Q-
Match Case
Words
Regex
app01
zls_orm@10.0.0.511of6
migrations
_init_.py
schemas1
admin.py
if
name
os.environ.setdefauLt（"DJANGO_SETTINGS_MODULE",“orm2.settings")
zls_orm
import django
apps.py
app01_author
models.py
app01_authordetail
django.setup()
tests.py
app01_book
views.py
app01bookauthors
from app01.modelsimport * app01_publish
orm2
auth_group
settings.py
authordetail=author.authordetail
auth_group_permissions
print(author.nameauthordetail.phone)
urls.py
auth_permission
auth_user
wsgi.py
if_name_=='_main_
authiicar
test
/Library/Frame
13056666666
```
<!-- OCR_END -->

￼

***

| 需求：查询地址是哈尔滨的作者名字 |
| :--- |

```plain
## 反向查询
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    authordetail = AuthorDetail.objects.filter(addr='哈尔滨').first()
    ## 作者对象authordetail.author
    author = authordetail.author
    print(authordetail.addr, author.name)
```

<!-- OCR_START -->
- /test.py[orm2]
- orm2test.py
- Project
- models.py
- test.py
- zls_orm.app01_authordetail[zls_orm@10.0.0.51]x
- 2Database
- orm2~/Pych
- Q-
- Match Case
- Words
- +、
- app01
- import os
- zls_orm@10.0.0.511of6
- migrations
- _init_.py
- schemas1
- if
- name
- admin.py
- os.enViron.setdefault（“DJANGO_SETTINGS_MODULE","orm2.settings")
- zls_orm
- import django
- app01_author
- apps.py
- app01_authordetail
- django.setup()
- tests.py
- app01_book
- app01_book_authors
- views.py
- fromappo1.modelsimport*
- 10
- app01_publish
- orm2
- 11
- authordetail=AuthorDetail.objects.filter（addr='哈尔滨'）.first（）
- auth_group
- settings.py
- 1213
- auth_group_permissions
- urls.py
- uthor
- auth_permission
- 14
- print(authordetail.addr,author.name)
- wsgi.py
- auth_user
- if_name_=-'_main_
- 田auth_user_groups
- temolates
- test
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- 尔滨Lls
- 曾老湿
- sfinishe
<!-- OCR_END -->

￼

### 一对多查询

**正向查询：**`boook`表里面有跟`publish`表的关联字段，从`book`表查询到`publish`表就叫做正向查询

\*\*反向查询：\*\*反过来，从`publish`表查询到`book`表中，就是反向查询

正向查询按字段，反向查询按表名小写_set.all()

***

| 需求：查询红楼梦这本书出版社邮箱 |
| :--- |

正向查询

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    book = Book.objects.filter(name='红楼梦').first()
    ## book.publish就是出版社对象
    publish = book.publish
    print(publish.email)
```

<!-- OCR_START -->
- 曾老湿

```text
orm2[~/PycharmProjects/orm2]-..test.py[orm2]
orm2test.py
Project
models.py
test.py
zls_.orm.app01_authordetail[zls_orm@10.0.0.51]
2Database
orm2~/Pych
Match Case Words Regex
app01
importos
zls_orm@10.0.0.511of6
migrations
schemas1
_init_.py
if
_name..
admin.py
main
os.environ.setdefault("DJANGO_SETTINGS_MODULE","orm2.settings")
zis_orm
import django
apps.py
app01_author
app01_authordetail
models.py
tests.py
django.setup()
app01_book
from appo1.models import * app01_book_authors
ame=红楼梦）.first（）
app01_publish
orm2
11
#bod
auth_group
init_.py
publish=book.publish
settings.py
auth_group_permissions
urls.py
13
print(publish.email)
auth_permission
1415
wsgi.py
#authordetail =AuthorDetail.objects.filter(addr=哈尔滨’）.first（） auth_user templates 16 17
##作者对象authordetail.author
auth_user_groups
#author = authordetail.author
auth_user_user_permissions
manage.py
#print(authordetail.addr,author.name)
18
django_admin_log
test.py
10
l External Libraries
django_content.type
if_name_=='_main_"
dianao miarations
testx
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
123@q.com
ocess finished with exit code0
```
<!-- OCR_END -->

￼

***

| 需求：查询地址是北京的出版社出版的图书 |
| :--- |

反向查询

<!-- OCR_START -->
- models.py
- test.pyx
- app01_book[zls_orm@10.0.0.51]
- 三3
- Database
- 3rows
- >1
- Tx:Auto
- Tab-se.d(TSV)
- DDL
- ViewQuery
- GVI
- <Filter criteria>
- zls_orm@10.0.0.511of6
- idname
- price
- publish_id
- schemas1
- 红楼梦
- 34.50
- zls_orm
- 2西游记
- 2
- app01_author
- 3
- 金瓶梅
- 66.90
- app01_authordetail
- 曾老湿
- app01_book
- rZeng
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    publish = Publish.objects.filter(addr='北京').first()
    ## 拿出所有的图书
    books = publish.book_set.all()
    print(books)
```

<!-- OCR_START -->
- orm2）test.py
- test
- #CE
- Project
- models.py
- test.py
- app01_authordetail[zls_orm@10.0.0.51]
- 2Database
- orm2~/PycharmProjects/orm2
- MatchCaseWordsRegex
- app01
- import os
- zls_orm@10.0.0.511of6
- migrations
- _init_.py
- schemas1
- os.environ.setdefault（"DJANGO_SETTINGS_MODULE","orm2.settings")
- zls_orm
- admin.py
- import django
- app01_author
- apps.py
- app01authordetail
- django.setup()
- tests.py
- app01_book
- views.py
- app01_book_authors
- from app01.models import *
- publish=Publish.objects.filter(addr=北京'）.first()
- app01_publish
- orm2
- 10
- 11
- 拿出所有的图书
- auth_group
- settings.py
- 12
- publish.book_set.all()
- auth_group_permissions
- 13
- urls.py
- auth_permission
- wsgi.py
- 14
- #book= Book.objects.filter（name=红楼梦），first()
- auth_user
- 15
- templates
- ##book.publish就是出版社对象
- auth_user_groups
- 17
- #publish=book.publish
- auth_user_user_permissions
- manage.py
- #print（publish.email)
- django_admin_log
- django_content_type
- ll External Libraries
- if_name_=='_main_
- 田dianaomiarations
- Run:
- testx
- 曾老湿
- erySet[<Book：红楼梦>，<Book：金瓶梅>]>
<!-- OCR_END -->

￼

## 多对多查询

**正向查询：**`boook`表里面有跟`author`表的关联字段，从`book`表查询到`author`表就叫做正向查询

\*\*反向查询：\*\*反过来，从`author`表查询到`book`表中，就是反向查询

正向查询按字段，反向查询按表名小写_set.all()

***

| 需求：查询红楼梦书所有的作者 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    book = Book.objects.filter(name='红楼梦').first()
    ## 是queryset对象，可以一直点 
    print(book.authors.all())
    ## 查看查询语句
    print(book.authors.all().query)
```

<!-- OCR_START -->
- 曾老湿

```text
/test.py[orm2]
orm2test.py
test
Project
models.py
test.py
manage.py
Database
orm2~/Pychar
import os
app01
if
main
zls_orm@10.0.0.511of6
migrations
_init_.py
os.environ.setdefault("DJANGO_SETTINGS_MODULE","orm2.settings")
import django
schemas1
admin.py
zls_orm
django.setup()
app01_author
apps.py
app01_authordetail
models.py
tests.py
from app01.models import * app01_book
views.py
k=Book.objects.filter
ame=红楼梦）.first（）
app01_book_authors
11
print(book.authors.all())
app01_publish
orm2
auth_group
_init_.py
publish=Publish.objects.filter（addr=北京').first()
settings.py
#拿出所有的图书
auth_group_permissions
urls.py
#books =publish.book_set.all()
auth_permission
#print(books） wsgi.py auth_user templates
auth_user_groups
18
#book=Book.objects.filter(name=红楼梦 ）.first(） manage.py ##book.publish就是出版社对象
auth_user_user_permissions
test.py
django_admin_log
External Libraries
django_content_type
if_name_--'_main_'
dianaomiarations
test
/Library/Fr
ons/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
QuerySet [<Author:zls>,<Author:lls>,<Author:cls>]>
```
<!-- OCR_END -->

￼

***

| 需求：查询zls写的所有书 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    zls = Author.objects.filter(name='zls').first()
    books =  zls.book_set.all()
    ## 查看所有数据
    print(books)
    ## 打印SQL语句
    print(books.query)
```

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-
- /test.py[orm2]
- orm2test.py
- test
- Project
- test.py
- zls_orm.
- app01_book_authors[zls_orm@10.0.0.51]
- Database
- orm2~/Pycha
- Projects/orm2
- importos
- app01
- migrations
- 3
- if
- _name.
- zls_orm@10.0.0.511of6
- _init_.py
- os.environ.setdefauLt("DJANGO_SETTINGS_MODULE",
- import django
- orm2.settings")
- schemas1
- admin.py
- django.setup()
- app01_author
- apps.py
- models.py
- app01_authordetail
- tests.py
- from appo1.models import *
- app01_book
- views.py
- ='zls'）.first（）
- app01_book_authors
- 11
- books=zls.book_set.all()
- app01_publish
- orm2
- print(books)
- print（books.query)
- auth_group
- 13
- ='红楼梦）.first（）
- auth_group_permissions
- settings.py
- urls.py
- 15
- auth_permission
- wsgi.py
- auth_user
- templates
- auth_user_groups
- 18
- publish=Publish.objects.filter(addr=北京).first()
- manage.py
- auth_user_user_permissions
- 19
- #books=publish.book_set.all()
- 田django_admin_log
- 20
- django_content type
- lExternal Libraries
- if_name_.
- =='_main_
- dianaomiarations
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- <QuerySet[<Book：红楼梦>，<Book：西游记>，<Book：金瓶梅>]>
- SELECTapp01_book.id，app01_book.name，app01_book.price，app01_book.publish_idFROMapp01_bookINNER JoINapp01_book_authorsON（app01_book.id=app01_book_authors.book_id） WHERE app01_book_autho
- 曾老湿
- cessfinished with exitcode0
<!-- OCR_END -->

￼

## 连续跨表

***

| 需求：查询红楼梦所有作者的手机号 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    book =  Book.objects.filter(name='红楼梦').first()
    authors = book.authors.all()
    for  author in authors:
        authordetail = author.authordetail
        print(authordetail.phone)
```

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-./test.py[orm2]
- test.py
- zls_o
- app01_book_authors[zls_orm@10.0.0.51]
- Database
- orm2~/Pycha
- import os
- app01
- if
- _name
- main_
- zls_orm@10.0.0.511of6
- migrations
- os.environ.setdefauLt("DJANGO_SETTINGS_MODULE",
- _init_.py
- "orm2.settings")
- schemas1
- import django
- admin.py
- zls_orm
- django.setup()
- app01_author
- apps.py
- models.py
- app01_authordetail
- tests.py
- from app01.models import*
- app01_book
- book=Book.objects,filter（
- me='红楼梦）.first（）
- views.py
- authors= book.authors.all()
- app01_book_authors
- app01_publish
- orm2
- 12
- forauthor in authors:
- auth_group
- authordetail=author.authordetail
- settings.py
- print(authordetail.phone)
- auth_group_permissions
- #zls =Author.objects.filter
- urls.py
- name='zls').first（)
- auth_permission
- 16
- #books=zls.book_set.all(）
- auth_user
- wsgi.py
- Book.objects.filter(name='红楼梦').first()
- templates
- auth_user_groups
- #print(books)
- auth_user_user_permissions
- manage.py
- django_admin_log
- 20
- l External Libraries
- django_content_type
- dianao miarations
- test
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- 13888888888
- 11111111
- 曾老湿
- cess finished
<!-- OCR_END -->

￼

**总结：**

```plain
1 一对一
            正向:正向查询按字段
            反向:反向查询按表名小写
2 一对多
            正向:正向查询按字段
            反向:反向按表名小写_set.all()
3 多对多
            正向:正向查询按字段
            反向查询:反向按表名小写_set.all()
            
4******基于对象的查询,多次查询(子查询)
```

## 打印Django查询数据的SQL语句

将如下代码添加到settings.py文件中

```plain
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console':{
            'level':'DEBUG',
            'class':'logging.StreamHandler',
        },
    },
    'loggers': {
        'django.db.backends': {
            'handlers': ['console'],
            'propagate': True,
            'level':'DEBUG',
        },
    }
}
```

## 基于双下划线查询

双下划线查询就是连表查询。

***

| 一对一查询 |
| :--- |

**查询zls作者的手机号**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 方法一：以author作为基表
    ret = Author.objects.filter(name='zls').values('authordetail__phone')
    print(ret)
```

<!-- OCR_START -->
```text
orm2[~/PycharmProjects/orm2]-..test.py[orm2]
orm2test.py
Project
test.py
e.py
三2Database
orm2~/PycharmProjects/orm2
import os
app01
if_name
zls_orm@10.0.0.511of6
migrations
os.environ.setdefauLt("DJANGO_SETTINGS_MODULE","orm2.settings")
_init_.py
schemas1
admin.py
import django
zls_orm
django.setup()
app01_author
apps.py
app01_authordetail
models.py
tests.py
from
app01.models import * app01_book
ret
Author.objects.filter(name='zls').values('authordetail_phone')
app01_book_authors
views.py
print(ret)
Book.objects.filter（name=红楼梦）.first（）
app01_publish
orm2
3
auth_group
14
#for
author in
auth_group_permissions
settings.py
auth_permission
urls.py
117
print(authordetail.phone)
auth_user
wsgi.py
#zls=Author.objects.filter(name='zls'）.first（)
templates
auth_user_groups
18
#book=Book.objects.filter（name='红楼梦）.first（）
auth_user_user_permissions
manage.py
19
test.py
#print(books)
django_admin_log
django_content_type
llExternal Libraries
if_name_--'_main_
dianao miarations
test
/Library/Frame
orks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
rySet['authordetail_phone':1305666666'}]> （0.001）SELECTapp01_authordetail.phoneFROMapp01_authorINNER JOINapp01_authordetailON（app01_author.authordetailid=app01_authordetail.id）WHEREapp01_author.name=zls′LIMIT 21;args=('zls'，) 曾老湿 ocess finished with exit code0
```
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 方法二：以authordetail作为基表
    ret = AuthorDetail.objects.filter(author__name='zls').values('phone')
    print(ret)
```

<!-- OCR_START -->
- orm2test.py
- test
- Project
- models.py
- test.py
- rea
- settings.py
- 2
- Database
- orm2~/Pych
- cts/orm2
- import os
- app01
- if
- _name
- main
- zls_orm@10.0.0.511of6
- migrations
- os.environ.setdefauLt("DJANGO_SETTINGS_MODULE","orm2.settings")
- _init_py
- import django
- schemas1
- admin.py
- zls_orm
- apps.py
- django.setup()
- app01_author
- app01_authordetail
- from app01.models import *
- tests.py
- app01_book
- ret =AuthorDetail.objects.filter(auth
- views.py
- app01_book_authors
- 11
- print(ret)
- chor.objects.filter(name=zls').values('authordetail_phone')
- app01_publish
- orm2
- 72
- #ret
- auth_group
- #book=
- Book.objects.filter(name='红楼梦').first()
- auth_group_permissions
- urls.py
- =book.authors.all()
- auth_permission
- wsgi.py
- 16
- #for
- authordetail=author.authordetail
- auth_user
- templates
- print(authordetail.phone)
- auth_user_groups
- 18
- #zls=Author.objects.filter(name='zls').first()
- auth_user_user_permissions
- manage.py
- 20
- #books
- book_set.a
- django_admin_log
- l xternal Libraries
- django_content_type
- if__name_=='_main_
- dianaomiarations
- Run:
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- (0.ooe)SELECTaOSQL_AUTO_IS_NULL;args=None
- phone FROMapp01_authordetail:INNER JOINapp01_authorON（app01_authordetail.id=app01_author.authordetail id）WHEREapp01_author.name=‘zls′LIMIT 21;args=（'zls',)
- <QuerySet [f'phone':13056666666'}]
- 曾老湿
- rocess finished with exit code 0
<!-- OCR_END -->

￼

**查询zls作者的性别和手机号**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret = Author.objects.filter(name='zls').values('sex','authordetail__phone')
    print(ret)
```

<!-- OCR_START -->
- orm2test.py
- test
- #C=
- Project
- models.py
- test.pyx
- ireac
- settings.py
- 三2
- Database
- orm2
- mProjects/orm2
- import os
- app01
- 白if
- name
- zls_orm@10.0.0.511of.6
- migrations
- os.environ.setdefault（"DJANGO_SETTINGS_MODULE","orm2.settings")
- _init_.py
- schemas1
- import django
- zls_orm
- admin.py
- django.setup()
- app01_author
- apps.py
- app01_authordetail
- tests.py
- from
- app01.modelsimport*
- app01_book
- views.py
- 10
- Author.objects.filter(name=zls').values('sex''authordetail_phone')
- app01_book authors
- print(ret)
- app01_publish
- 12
- #ret=AuthorDetail.objects.filter(author_name='zls').values(phone')
- auth_group
- ret =Author.objects.filter(name=zls'）.values（‘authordetail_phone')
- auth_group_permissions
- urls.py
- auth_permission
- 16
- #book=
- wsgi.py
- auth_user
- 27
- templates
- 18
- #for
- author in authors:
- manage.py
- authordetail = author.authordetail
- print（authordetal.phone)
- test.py
- 20
- django_admin_log
- 1-3-1
- django_content.type
- External Libraries
- main_
- dianao miarations
- testx
- /Library/Fral
- works/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- detailphone':
- 13056666666>
- (0.O00)SELECT aaSQL_AUTO_IS_NULL;args=None
- (0.0O0) SELECT VERSION(）;args=None
- （0.000） SELECTappo1_authorsexapp01_authordetail.phoneFROMapp01authorINNER JOINapp01_authordetailON（app01authorauthordetailid=app01authordetail.id）WHERE appo1authorname=zls’LIMI
- ocessfinished with exitcode
- 曾老湿
<!-- OCR_END -->

￼

**总结：**

```plain
# 基于双下划线的跨表查询   
        - 连表查询
        - 一对一双下划线查询
            - 正向:按字段,跨表可以在filter,也可以在values中
            - 反向:按表名小写,跨表可以在filter,也可以在values中
```

***

| 一对多查询 |
| :--- |

**查看出版社为北京出版社的所有图书的名字和价格**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 方法一：左外连接查询
    ret = Publish.objects.filter(name='北京出版社').values('book__name','book__price')
    print(ret)
```

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-./test.py[orm2]
- Project
- odels.py
- test.py
- se
- @10.0.0.51]
- Database
- orm2~/Pychar
- ects/orm2
- import os
- app01
- if
- _name_=
- main
- zls_orm@10.0.0.511of6
- migrations
- _init_py
- os.enViron.setdefault("DJANGO_SETTINGS_MODULE","orm2.settings")
- import django
- schemas1
- zls_orm
- admin.py
- app01_author
- apps.py
- django.setup()
- models.py
- 田app01_authordetail
- tests.py
- from appo1.modelsimport*
- app01_book
- ret=Publish.objects.filter(na
- e='北京出版社'）.valu
- app01_book_authors
- views.py
- print(ret)
- orm2
- app01_publish
- 12
- auth_group
- settings.py
- auth_group_permissions
- urls.py
- auth_permission
- wsgi.py
- auth_user
- 17
- auth_user_groups
- templates
- 18
- auth_user_user_permissions
- manage.py
- 19
- django_admin_log
- 20
- llExternal Libraries
- django_content_type
- dianao miarations
- testx
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverz
- (0.000) SELECT aaSQL_AUTO_IS_NULL;args=None
- (0.000) SELECT VERSION();args=None
- .001)SELECTapp01_book.name，
- ppO1_book.priceFROMappO1_publishLEFTOUTERJOINa
- appo1_bookON（app01_publish.id=app01_book.publish_id）WHEREapp01_publish.name=‘北京出版社LIMIT 21；args=（‘北京
- 曾老湿
- uerySet ['book
- ：红楼梦
- price':Decimal（'34.50'）1,'book
- rice':Decimal('66.90'）)]>
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret = Book.objects.filter(publish__name='北京出版社').values('name','price')
    print(ret)
```

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-../test.py[orm2]
- orm2test.py
- test
- #C@E
- Project
- models.py
- testpyx
- settings.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- 三1
- Database
- orm2
- nProjects/orm2
- import os
- +G
- app01
- if
- _name_
- zls_orm@10.0.0.511of6
- migrations
- os.environ.setdefault(“DJANGO_SETTINGS_MODULE","orm.settings"）
- _init_.py
- schemas1
- import django
- admin.py
- zls_orm
- apps.py
- django.setup()
- app01_author
- app01_authordetail
- from appo1.models import *
- tests.py
- app01_book
- ret=Bok.objectsfilter(publish_name=北京出版社）.values（nameprice）
- app01_book_authors
- views.py
- print(ret)
- app01_publish
- #ret=Publish.objects.filter（name='北京出版社'）.values（‘book_name'，'book_price')
- 13
- auth_group
- auth_group_permissions
- urls.py
- auth_permission
- wsgi.py
- auth_user
- auth_user_groups
- templates
- 18
- manage.py
- 19
- auth_user_user_permissions
- django_admin_log
- test.py
- 20
- django_content_type
- llExternal Libraries
- dianao miarations
- Run:
- testx
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- (0.000) SELECT aaSQL_AUTO_IS_NULL;args=None
- （0.001) SELECTapp01_bo
- =‘北京出版社LIMIT21；args=（北京出版社
- 曾老湿
- ocess finished with exit code0
<!-- OCR_END -->

￼

**查询北京出版社出版并且价格大于30的书**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret = Publish.objects.filter(name='北京出版社',book__price__gt=30).values('book__name','book__price')
    print(ret)
```

<!-- OCR_START -->
- orm2test.py
- test
- #CE
- 12
- Project
- models.py
- test.py
- settings.py×
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- 1
- Database
- orm2~/PycharmProjects/orm2
- import os
- 十G
- app01
- 3
- if
- _name_=_main_
- migrations
- zls_orm@10.0.0.511of6
- os.environ.setdefault("DJANGO_SETTINGS_MODULE",“orm2.settings")
- init_.py
- schemas1
- import django
- admin.py
- zls_orm
- django.setup()
- app01_author
- apps.py
- app01_authordetail
- tests.py
- from appo1.models import *
- app01book
- views.py
- 10
- app01_bookauthors
- 11
- print(ret)
- app01_publish
- √口
- orm2
- #ret=Book.objects.filter（publish_name=北京出版社'）.values（）
- auth_group
- 14
- auth_group_permissions
- auth_permission
- urls.py
- wsgi.py
- #ret=Book.obiects.filter（publishname=北京出版社）.values（nameprice）
- auth_user
- templates
- auth_user_groups
- 18 19
- #ret=Publish.objects.filter（name='北京出版社）.values（book_name'，book_price）
- manage.py
- auth_user_user_permissions
- django_admin_log
- 20
- diango_content.type
- llExternal Libraries
- if__name_=='_main_
- dianao miarations
- Run:
- eworks/Python.frame
- tework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- <QuerySet[book_name'：红楼梦’，
- （0.000) SELECT VERSION(）; arg
- ocess finished with exit code 0
- 曾老湿
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret = Book.objects.filter(publish__name='北京出版社',publish__book__price__gt=19).values('name','price')
    print(ret)
```

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-../test.py[orm2]
- orm2test.py
- test
- Project
- mo
- odels.pyx
- test.pyx
- settings.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]x
- ge.py
- Database
- orm2
- mProjects/orm2
- import os
- app01
- if
- name_
- zls_orm@10.0.0.511of6
- migrations
- _init_.py
- schemas1
- import django
- zls_orm
- admin.py
- django.setup()
- app01_author
- apps.py
- models.py
- app01_authordetail
- tests.py
- from
- app01_book
- views.py
- 1011
- app01_bookauthors
- print(ret)
- app01_publish
- 1213
- #ret=Publish.objects.filter（name=北京出版社’，book_price_gt=30）.values（book_name'，book_price'）)
- auth_group
- 1415
- auth_group_permissions
- urls.py
- #ret=Book.obiects.filter（(publishname=北京出版社）.values（nameprice）)
- auth_permission
- wsgi.py
- 16171819 20
- auth_user
- #ret=Publish.objects.filter（name=北京出版社'）.values('book_name','book_price')
- templates
- auth_user_groups
- manage.py
- auth_user_user_permissions
- test.py
- django_admin_log
- django_content.type
- l External Libraries
- =='_main_
- dianao miarations
- Run:
- /Library/Frameworks/Python.fram
- work/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- <QuerySet [{'name’：红楼梦，'price”
- ：Decimal（'34.50'）}，{name'：‘红楼梦，
- 'price"
- 'price':Decimal（'66.90′）}]>
- 1
- (0.001) SELECTapp01_book.name
- T3ON（appo1_publish².id=T3.publish_id
- ocess finished with exit code 0
- 曾老湿
<!-- OCR_END -->

￼

***

| 多对多查询 |
| :--- |

**查询红楼梦所有作者的名字**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret = Book.objects.filter(name='红楼梦').values('authors__name')
    print(ret)
```

<!-- OCR_START -->
- 曾老湿

```text
orm2test.py
test
Project
test.py
settings.py
zls_orm.app01_book_authors[zls_orm@10.0.0.51]
Database
orm2~/Pycha
mProjects/orm2
import os
app01
if
name_
2
zls_orm@10.0.0.511of6
migrations
_init_.py
import django
schemas1
zls_orm
admin.py
app01_author
apps.py
django.setup()
models.py
app01_authordetail
from app01.models import * tests.py
app01_book
views.py
app01_book_authors
11
ret=Book.objects.filter（name=红楼梦'）.values（authors_n
app01_publish
12
print(ret)
_init_.py
auth_group
settings.py
auth_group_permissions
14
urls.py
15
auth_permission
1617 18 19
wsgi.py
auth_user
#ret=Book.obiects.filter（publishname=北京出版社publishbook_pricegt=19）.values（nameprice）
templates
auth_user_groups
manage.py
#print(ret)
#ret=Publish.objects.filter（name='北京出版社'，book_price_gt=30）.values（book
auth_user_user_permissions
test.py
20
django_admin_log
l External Libraries
django_content_type
main
田dianao miarations
Run:
test
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
（0.00O)SELECT aaSQL_AUTO_IS_NULL;args
(0.001) SELECT
FROMappo1_bookLEFT OUTER JOINapp01_book_authorsON（appo1_bookid=appo1_book_authors.book_id）LEFT OUTER JOINappo1_authorON（app01_book_authors.author_id=app01
cess finished with exit code0
```
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret = Author.objects.filter(book__name='红楼梦').values('name')
    print(ret)
```

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-./test.py[orm2]
- orm2test.py
- test
- Project
- test.py
- settings.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- Database
- orm2~/Pycha
- ojects/orm2
- import os
- GI
- app01
- if
- name_
- main
- zls_orm@10.0.0.511of6
- migrations
- os.environstefaut(JANGOETTINGOUE",rmettings）
- _init_.py
- import django
- schemas1
- admin.py
- zls_orm
- apps.py
- django.setup()
- app01_author
- models.py
- app01_authordetail
- tests.py
- from appo1.models impo
- app01_book
- 10
- ret=Author.objects.filter(book_name=红楼梦').values('name')
- app01_bookauthors
- views.py
- print(ret)
- app01_publish
- orm2
- 12
- #ret=Book.objects.filter(name='红楼梦').values('authors_name')
- auth_group
- 13
- 14
- auth_group_permissions
- auth_permission
- urls.py
- 16
- auth_user
- wsgi.py
- 17
- templates
- auth_user_groups
- 18
- manage.py
- #ret=Book.obiects.filter(publishname=北京出版社publishbookprice
- gt=19).values（nameprice'）
- auth_user_user_permissions
- 19
- django_admin_log
- lExternal Libraries
- django_content_type
- dianao miarations
- ework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- (0.000)SELECT a@SQL_AUTO_IS_NULL;args=Non
- <QuerySet [{'name':zls'},'name':
- ls'}，{name':cls′}]>
- （0.000)SELECTVERSION();args=N
- .001) SELECTapp01_authornameFROMapp01_authorINNER JOINapp01_bok_authorsON（app01_author.id=app01_book_authors.author_id）INNER JOINapp01_bookON(app01_book_authors.book_id=app01_book
- 曾老湿
<!-- OCR_END -->

￼

**查询图书价格大于30的所有作者名字**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret = Book.objects.filter(price__gt=30).values('authors__name')
    print(ret)
    ret2 = Author.objects.filter(book__price__gt=30).values('name')
    print(ret2)
```

<!-- OCR_START -->
orm2test.py
test
#CE
Project
models.py
test.py
settings.py
zls_orm.app01_bookauthors[zls_orm@10.0.0.51]
age.py
Database
orm2~/Pycha
armProjects/orm2
import os
app01
if
_name_
main':
zls_orm@10.0.0.511of6
migrations
os.environ.setdefault（DJANGO_SETTINGS_MODULE",“orm2.settings")
_init_.py
schemas1
import django
admin.py
zls_orm
django.setup()
app01_author
apps.py
app01_authordetail
tests.py
9
from app01.modelsimport *
app01_book
10
ret=Book.objects.filter(price_gt=30).values('authors_name')
app01_book_authors
views.py
11213
print(ret)
app01_publish
orm2
ret2=Author.objects.filter(book_price_gt=30).values('name')
auth_group
1415
auth_group_permissions
urls.py
auth_permission
16
#ret =Author.objects.filter（book_name=红楼梦'）.values（‘name')
wsgi.py
auth_user
1718
templates
auth_user_groups
19 20
#ret=Book.objects.filter（name='红楼梦).values(‘authors_name')
auth_user_user_permissions
manage.py
django_admin_log
django_content_type
IllExternal Libraries
if_name_=='_main
田dianao miarations
testx
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
(0.0oo)SELECT aaSQL_AUTO_IS_NULL;args=None
（0.000)SELECT VERSION）;args=None
(0.001)SELECT
FROMapp01_bookLEFT OUTER JOINapp01_book_authorsON（app01_book,id=app01_book_authors.book_id)LEFT OUTER JOINapp01_authorON（app01_book_authors.author_id=
author_id）INNER JOINapp01_bookON（app01_book_authors.book_id=app01_book
appo1
FROMapp01_author
<QuerySet ['authors__name':'zls'},
{'authors_name':zls'},{'authors_name':'zls'},f'authors_name':lls'},{'authors_name':'cls'}]>
QuerySet [’name′:zls'},{’name:zls'}，{name':‘zls}，’name′:ls'},{’name:cls'}]>
曾老湿
ocessfinishedwith exitcode0
<!-- OCR_END -->

￼

***

| 进阶练习：连续跨表 |
| :--- |

**查询北京出版社出版过的所有书籍以及作者的姓名**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret = Publish.objects.filter(name='北京出版社').values('book__name','book__authors__name')
    print(ret)
    ret2 = Book.objects.filter(publish__name='北京出版社').values('name','authors__name')
    print(ret2)
    
    ret3 = Author.objects.filter(book__publish__name='北京出版社').values('book__name','name')
    print(ret3)
```

**三种方法 ：**

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-./test.py[orm2]
- orm2test.py
- test
- Project
- odels.py
- test.py
- settings.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- Database
- orm2~/PycharmProjects/orm2
- importos
- +、
- app01
- if
- _name_
- main
- zls_orm@10.0.0.511of6
- migrations
- os.enViron.setdefauLt("DJANGO_SETTINGS_MODULE","orm2.settings")
- _init_.py
- import django
- schemas1
- admin.py
- zls_orm
- django.setup()
- app01_author
- apps.py
- models.py
- app01_authordetail
- tests.py
- fromappo1.models import *
- app01_book
- views.py
- app01_book_authors
- 11
- print(ret)
- app01_publish
- 12
- ret2= Book.objects.filter（publish_name=北京出版社'）.values（name’authors_name'）
- auth_group
- 14
- auth_group_permissions
- auth_permission
- urls.py
- 1617
- ret3=Author.objects.filter（book_publish_name=北京出版社'）.values（book_name’name′)
- wsgi.py
- auth_user
- auth_user_groups
- templates
- 1819
- #ret=Book
- .objects.filter(price_gt=30).values('authors_name')
- auth_user_user_permissions
- manage.py
- django_admin_log
- 20
- django_content.type
- IllExternal Libraries
- mdianao miarations
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- QuerySet
- name'：‘红楼梦'，
- name':'zls'}，{'book_name':
- ‘红楼梦
- 'zls'}，{’name'：‘红楼梦，authors_name'：
- ls'}，{’name'：
- 红楼梦’，‘authors_name'：'cls'}，{’name'：‘金瓶梅，‘authors_name'：zls'}]>
- (0.000)SELECT
- QL_AUTO_IS_NULL;args=None
- VERSION();args=No
- (0.001)
- SELECT
- app01_author.name
- FROMapp01_pubLishLEFTOUTER JOINapp01_bookON（app01_pubLish'.id=app01_book.pubLish_id）LEFT OUTER JOINapp01_book_authorsON（app01_book'.id
- name':zls'},
- INNER JOIN
- D01publish.id)LEFTOUTERJOIN
- app01_book_authorsON（app01_book.id
- et[f'b
- kname':
- {'book
- （0.001）SELECTapp01_book.name，
- app01_author.name FROMapp01_authorINNER JOINappo1_book_authorsON（app01_author.idappo1_book_authorsauthor_id）INNER JOINappo1_bookON(appo1_book_authors.book
- 曾老湿
- cess finished with exit code0
<!-- OCR_END -->

￼

**手机号以130开头的作者出版过的所有书籍以及出版社的名称**

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ret =  AuthorDetail.objects.filter(phone__startswith=130).values('author__name','author__book__name','author__book__publish__name')
    print(ret)
```

<!-- OCR_START -->
- orm2test.py
- CCE
- Project
- test.py
- zls_orm.app01_book[zls_orm@10.0.0.51]x
- settings.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]>
- 2Database
- orm2~/PycharmProjects/orm2
- import os
- app01
- if
- name
- zls_orm@10.0.0.511of6
- migrations
- os.enViron.setdefauLt（"DJANGO_SETTINGS_MODULE","orm2.settings")
- _init_.py
- schemas1
- Padmin.py
- import django
- zls_orm
- app01_author
- apps.py
- django.setup()
- models.py
- app01_authordetail
- 8
- tests.py
- from app01.models import*
- app01_book
- views.py
- 10
- ret=
- AuthorDetail.objects.filter(phpne_startswith=130).values（'author_name''author_book
- app01_book_authors
- 11
- print(ret)
- orm2
- 12
- #ret=Publish.objects.filter（name=北京出版社）.values（book_name'，book_authors_name）
- app01_publish
- 13141516171819 2
- auth_group
- auth_group_permissions
- urls.py
- #ret2=Book.objects.filter（publish_name='北京出版社'）.values（name'，'authors_name)
- auth_permission
- wsgi.py
- auth_user
- templates
- ret3=Author.objects.filter（book_publish_name=北京出版社'）.values('book_name'，,'name')
- auth_user_groups
- manage.py
- auth_user_user_permissions
- Book.objects.filter(price_gt=30).values('authors_name')
- django_admin_log
- django_contenttype
- IllExternal Libraries
- main`
- dianao miarations
- test
- ：西游记'，'author_book_publish_name'：‘南京出版社'}，{'author_name'：'zls'，‘author_book_name'：金瓶梅'，‘author_book_publish_name'：北京出版社'}]>
- 曾老湿
- etail
<!-- OCR_END -->

￼

## 聚合查询

***

| 导入聚合函数 |
| :--- |

aggregate()是QuerySet 的一个终止子句，意思是说，它返回一个包含一些键值对的字典。键的名称是聚合值的标识符，值是计算出来的聚合值。键的名称是按照字段和聚合函数的名称自动生成出来的。如果你想要为聚合值指定一个名称，可以向聚合子句提供它。

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
```

***

| 需求：计算所有图书的平均价格 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret = Book.objects.all().aggregate(Avg('price'))
    print(ret)
```

<!-- OCR_START -->
- 曾老湿

```text
orm2test.py
Project
test.py
zls_orm.app01_book[zls_orm@10.0.0.51]x
settings.py
nors[zls_orm@10.0.0.51]
Database
orm2~/PycharmProjects/orm2
import os
GI
app01
migrations
if
_name_
main
zls_orm@10.0.0.511of6
os.enViron.setdefault("DJANGO_SETTINGS_MODULE","orm2.settings")
import django
schemas1
admin.py
zls_orm
apps.py
django.setup()
app01_author
models.py
app01_authordetail
tests.py
from
app01.models import * app01_book
views.py
10
from
app01_book_authors
11
objects.all().aggregate(Avg('price'))
orm2
print(ret)
app01_publish
12
auth_group
_init_.py
13
settings.py
14
#.ret..
AuthorDetail.obiects.filter(phonestartswith=130).values（'authorname'authorbooknameauth
auth_group_permissions
urls.py
print(ret)
auth_permission
15
#ret=Publish.objects.filter（name=北京出版社‘）.values（‘book_name'，book_authors_name'）
wsgi.py
auth_user
17
#print（ret)
templates
auth_user_groups
18
auth_user_user_permissions
manage.py
19
20
#print（ret2)
django_admin_log
test.py
django_content_type
=='_main_
dianao miarations
test
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
（0.000)SELECT
'price_avg':45.3}
cessfinished withexit code0
```
<!-- OCR_END -->

￼

***

| 需求：计算所有图书的最高价格 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret = Book.objects.all().aggregate(Max('price'))
    print(ret)
```

<!-- OCR_START -->
- 曾老湿

```text
orm2test.py
#C@E
Project
test.py
zls_orm.app01_book[2zls_orm@10.0.0.51]x
settings.py
zls_orm.app01_boc
hors[zls_orm@10.0.0.51]
Database
orm2~/Pych
import os
app01
if
_name
_main_':
zls_orm@10.0.0.511of6
migrations
os.enViron.setdefauLt("DJANGO_SETTINGS_MODULE","orm2.settings")
_init_py
schemas1
import django
admin.py
zls_orm
田app01_author
apps.py
django.setup()
models.py
app01_authordetail
tests.py
from app01.models import * app01_book
10
views.py
rom
app01_book_authors
11213
ret=Book.objects.all().aggregate(Max('price') print(ret) app01_publish orm2
_init_.py
auth_group
settings.py
#ret= Book.objects.all().aggregate(Avg(‘price')) auth_group_permissions urls.py #print（ret)
auth_permission
auth_user
wsgi.py
templates
18 19
auth_user_groups
#retAuthorDetail.obiects.filter(phonestartswith=130).values(author auth_user_user_permissions manage.py test.py
20
#print（ret)
django_admin_log
django_content_type
田dianao miarations
test
/Library/Frameworks/Python.fram
work/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
（0.000) SELECT aaSQL_AUTO_IS_NULL;args=None
（0.000）SELECT
price`）AS
"price_max
FROM²app01_book;args=（)
'pricemax':Decimal（'66.90'）}
icessfinished with exit code0
```
<!-- OCR_END -->

￼

如果你希望生成不止一个聚合，你可以向aggregate()子句中添加另一个参数。所以，如果你也想知道所有图书价格的最大值和最小值，可以这样查询：

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret = Book.objects.all().aggregate(Max('price'),Min('price'),Avg('price'),Sum('price'))
    print(ret)
```

## 分组查询

在MySQL的SQL语句章节中，我吟过一个`group by`的诗。

annotate()为调用的QuerySet中每一个对象都生成一个独立的统计值（统计方法用聚合函数）。

总结 ：跨表分组查询本质就是将关联表join成一张表，再按单表的思路进行分组查询。　

***

| 需求：统计每一本书作者个数 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret = Book.objects.all().annotate(c=Count('authors'))
    for r in ret:
        print(r.name,'====>',r.c)
```

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-
- .../test.py[orm2]
- orm2test.py
- test
- #C@E
- Project
- test.py
- zls_orm.app01_book[zls_orm@10.0.0.51]x
- settings.py
- zls_orm.app01_book_authors[zls_orm@10.0.0.51]
- 三2
- Database
- import os
- GVI
- app01
- 3→
- if
- _name
- zls_orm@10.0.0.511of6
- migrations
- os.environ.setdefault("DJANGO_SETTINGS_MODULE","orm2.settings")
- _init_.py
- import django
- schemas1
- admin.py
- zls_orm
- django.setup()
- app01_author
- apps.py
- 田app01_authordetail
- models.py
- tests.py
- from
- app01.models import *
- app01_book
- 10
- app01_book_authors
- views.py
- 11213
- app01_publish
- orm2
- print（r.namex===>xr.c)
- auth_group
- auth_group_permissions
- urls.py
- 1516
- auth_permission
- wsgi.py
- auth_user
- 17
- #ret=Book.obiects.all()agregate（Max(price）Min(price）Avg(price）Sum(price'))
- templates
- auth_user_groups
- 1819
- #print(ret)
- manage.py
- auth_user_user_permissions
- #ret= Book.objects.all().aggregate(Avg('price'))
- django_admin_log
- 20
- l External Libraries
- django_content_type
- if_name_-'_main_'
- dianao miarations
- /Library/Frameworks/Python.frame
- nework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- (0.001)SELECT
- app01_book.id，
- appbookname，appbookprice，apbookpublishid，cOUNT（appbookathorsauthorid）AScFROMappbookFoTEROIappbookauthorON（appook
- 红楼梦====>3
- 西游记
- 瓶梅
- ====>1
- 曾老湿
<!-- OCR_END -->

￼

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    
    ret =  Book.objects.all().annotate(c=Count('authors')).values('name','c')
    print(ret)
```

<!-- OCR_START -->
test.py[orm2]
orm2test.py
test
CCE
Project
test.py
zls_orm.app01_book[zls_orm@10.0.0.51]x
settings.py
zls_orm
app01_book_authors[zls_orm@10.0.0.51]
Database
orm2~/PycharmProjects/orm2
import os
#G
app01
if
zls_orm@10.0.0.511of6
migrations
os.environ.setdefault（"DJANGO_SETTINGS_MODULE","orm2.settings")
_init_.py
schemas1
admin.py
import django
django.setup()
app01_author
apps.py
models.py
app01_authordetail
tests.py
fromapp01.modelsimport*
app01_book
views.py
from django.db.modelsimport Avg.Count,Max.Min,Sum
app01_book_authors
app01_publish
orm2
1213
ret=Book.objects.all(）.annotate(c=Count（'authors')).values（‘name′c')
print(ret)
auth_group
14
#ret=Book.objects.all(）.annotate(c=Count('authors'))
auth_group_permissions
urls.py
1515
#for r in ret:
auth_permission
wsgi.py
print（r.name,'==>',r.c)
auth_user
17
templates
189
auth_user_groups
auth_user_user_permissions
manage.py
20
#ret=Book.obiects.all().aggregate（Max(price）,Min（price）Avg(price)Sum(price'))
django_admin_log
django_content.type
ll External Libraries
if_name_--'_main_
dianao miarations
Run:
testx
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
(0.00o)SELECTaaSQL_AUTO_IS_NULL;args=None
name
COUNT(appO1_book_authors.author_id)AScFROMapp01_bookLEFT OUTER JOINappO1_book_authors
ON（app01_bo
authors'.book_id)GROUP BYappo1_book.idORD
<QuerySet [{’name：红楼梦，'c'：3}，{’name：西游记，c'：1}，{name'：‘金瓶梅’，c'：1}]>
曾老湿
ocess finished with exit code0
<!-- OCR_END -->

￼

***

| 需求：统计每一个出版社最便宜的书 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret =  Publish.objects.all().annotate(n=Min('book__price')).values('name','n')
    print(ret)
```

<!-- OCR_START -->
- orm2[~/PycharmProjects/orm2]-./test.py[orm2]
- orm2test.py
- test
- Project
- test.py
- settings.py
- zls_or
- uthors[zls_orm@10.0.0.51]
- Database
- orm2~/PycharmProjects/orm2
- import os
- GI
- app01
- migrations
- if
- name
- main_':
- zls_orm@10.0.0.511of6
- _init_.py
- os.environ.setdefault（"DJANGO_SETTINGS_MODULE",“orm2.settings")
- schemas1
- import django
- admin.py
- zls_orm
- django.setup()
- app01_author
- models.py
- apps.py
- app01_authordetail
- from appo1.modelsimport *
- 田app01_book
- tests.py
- ort Avg,Count.MaxMin,Sum
- app01bookauthors
- views.py
- 11
- price')).values('name''n')
- print(ret)
- app01_publish
- orm2
- 12
- 13
- auth_group
- 14
- auth_group_permissions
- 15
- #ret=Book.objects.all（）.annotate(c=Count('authors)）.values（namec)
- auth_permission
- urls.py
- wsgi.py
- 16
- auth_user
- 17
- #ret= Book.objects.all().annotate(c=Count('authors'))
- templates
- auth_user_groups
- 18
- manage.py
- print（r.name,'.->',r.c)
- auth_user_user_permissions
- 19
- mdjango_admin_log
- ll External Libraries
- django_content_type
- if_name_=='_main_
- mdianao miarations
- Run:
- /Library/Fr
- lork/Versions/3.6/bin/python3.6/Users/drive
- n'：Decimal（'34.50'）}，{'name′:‘南京出版社'，'n:Decimal（'34.50'）}，{'name
- ‘东京出版社'，‘n'：None}]>
- （0.001） SELECT app01_publish.name，MIN（app1_book.price）ASnFROMapp01_publishLEFT OUTER JOINapp01_bookON（app01_publish.id
- app01_book.publish_id）GROUP BYappO1_publish.idORDER BY NULL LIMI
- 曾老湿
- ocess finished with exit code0
<!-- OCR_END -->

￼

***

| 需求：统计以红开头的书籍作者个数 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret = Book.objects.filter(name__startswith='红').annotate(c=Count('authors')).values('name','c')
    print(ret)
```

<!-- OCR_START -->
- orm2test.py
- test
- #CCE
- Project
- testpy
- zls_orm.app01_book[zls_orm@10.0.0.51]x
- settings.py
- zls_
- @10.0.0.51
- Database
- orm2~/Pycha
- import os
- app01
- if
- name
- main
- zls_orm@10.0.0.511of6
- migrations
- _init_.py
- os.environ.setdefault("DJANGO_SETTINGS_MODULE","orm2.settings")
- schemas1
- import django
- admin.py
- zls_orm
- django.setup()
- app01author
- apps.py
- app01_authordetail
- models.py
- 8
- tests.py
- from
- app01.models import *
- app01_book
- app01_book_authors
- views.py
- 11
- ret=
- startswith='红'）.annotate（c=Count（'authors'））.values('name′'c')
- app01_publish
- orm2
- 12
- print(ret)
- auth_group
- 13
- auth_group_permissions
- 14
- urls.py
- 15
- auth_permission
- 16
- #ret=Publish.obiects.all().annotate(n=Min（bookprice)）.values（namen)
- wsgi.py
- auth_user
- 17
- templates
- auth_user_groups
- 1819
- auth_user_user_permissions
- manage.py
- 20
- Book.obiects.all().annotate(c=Count（authors)).values（namec)
- django_admin_log
- llExternal Libraries
- django_contenttype
- dianao miarations
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- （0.000)SELECTVERSION);args=None
- (0.0oO)SELECTaaSQL_AUTO_IS_NULL;args=None
- (0.000)SELECT
- COUNT（app01_book_authors.author_id）AScFROMapp01_bookLEFT OUTER JOINapp01_book_authorsON(app01_book.id
- =app01_book_authors.book_id)WHEREapp01_book.nameLIKE
- uerySet [{name'：红楼梦’，c'：3}]>
- 曾老湿
<!-- OCR_END -->

￼

**总结：**

1.values在前，表示group by，在后表示取值

2.filter在前，表示where条件，在后表示having

***

| 需求：查询名字叫zls出书的总价 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret = Author.objects.all().values('pk').filter(name='zls').annotate(s=Sum('book__price')).values('name','s')
    print(ret)
```

***

| 需求：查询名所有作者出书的总价大于30 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret = Author.objects.all().values('pk').annotate(s=Sum('book__price')).filter(s__gt=30).values('name','s')
    print(ret)
```

<!-- OCR_START -->
- orm2test.py
- test
- Project
- models.py
- test.py
- settings.py
- manage.py
- Datal
- orm2~/Pycha
- mProjects/orm2
- import os
- app01
- migrations
- if
- _name
- os.environ.setdefault("DJANGO_SETTINGS_MODULE","orm2.settings")
- zs_orm@10.0.0.5
- _init_.py
- schemas1
- import django
- admin.py
- zls_orm
- django.setup()
- app01_a
- apps.py
- app01_au
- tests.py
- from
- app01.models import *
- app01_b
- 10
- views.py
- 11
- app01_pl
- 12
- print(ret)
- auth_grc
- 13
- 14
- auth_gro
- urls.py
- 15
- 1617
- #ret=Book.obiects.filter（namestartswith=红）.annotate(c=Count（'authors））.values（namec)
- wsgi.py
- auth_use
- 111111
- templates
- 18
- 19
- django_a
- l External Libraries
- 13/1
- django_c
- if_name
- diar
- Run:
- SELECT
- (0.001) SELECTapp01_author
- app01_book_authors.author_id)LEFT OUTERJOINapp01_bookON（ap
- <QuerySet [’name':'zls'，
- s：Decimal（'135.90′）}，{name′:1ls'，s':Decimal（34.50′）},{name′:cls',s:Decimal（'34.50′）}]>
- ocess finished with exit code 0
- 曾老湿
<!-- OCR_END -->

￼

***

| 需求：统计不止一个作者的书名 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    from django.db.models import Avg,Count,Max,Min,Sum
    ret = Book.objects.all().values('pk').annotate(c=Count('authors')).filter(c__gt=1).values('name','c')
    print(ret)
```

![]()￼

## F查询

在上面所有的例子中，我们构造的过滤器都只是将字段值与某个常量做比较。如果我们要对两个字段的值做比较，那该怎么做呢？

Django 提供 F() 来做这样的比较。F() 的实例可以在查询中引用字段，来比较同一个 model 实例中两个不同字段的值。

***

| 首先添加两个字段 |
| :--- |

将下面两个字段，添加到书的表中

```plain
# 阅读数
reat_num=models.IntegerField(default=0)
# 评论数
commit_num=models.IntegerField(default=0)
```

models.py

```plain
from django.db import models
# Create your models here.
class Publish(models.Model):
    # id如果不写，会自动生成，名字叫nid并且自增
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    addr = models.CharField(max_length=64)
    email = models.EmailField()
class Author(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    addr = models.CharField(max_length=64)
    ## 数字类型
    sex = models.IntegerField()
    ## 一对一，外键 ，并且有唯一性约束
    # authordetail = models.ForeignKey(unique=True)
    ## Django内置了一对一的方法
    authordetail = models.OneToOneField(to='AuthorDetail', to_field='id')
    def __str__(self):
        return self.name
class AuthorDetail(models.Model):
    id = models.AutoField(primary_key=True)
    phone = models.CharField(max_length=32)
    addr = models.CharField(max_length=64)
class Book(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    price = models.DecimalField(max_digits=5, decimal_places=2)
    ## 一对多的关系，关联字段创建在多的地方
    publish = models.ForeignKey(to='Publish', to_field='id')
    ## 多对多的关系 ，创建在哪里 都可以
    authors = models.ManyToManyField(to='Author')
    # 阅读数
    reat_num = models.IntegerField(default=0)
    # 评论数
    commit_num = models.IntegerField(default=0)
    def __str__(self):
        return self.name
```

数据库迁移

```plain
MacBook-pro:orm2 driverzeng$ python3 manage.py makemigrations app01
MacBook-pro:orm2 driverzeng$ python3 manage.py migrate
```

自己随便添加点数据

<!-- OCR_START -->
- zls_orm.app01_authordetail[zls_orm@10.0.0.51]x
- zls_orm.app01_author[zls_orm@10.0.0.51]
- zls_orm.app01_book[zls_orm@10.0.0.51]
- 4
- Database
- 3rows
- Tx:Auto
- Tab-se...d(TSV)
- DDL
- ViewQuery
- GVI
- <Filter criteria>
- zls_orm@10.0.0.511of6
- idname
- price
- publish_id
- commitnum
- reatnum
- schemas1
- 1红楼梦
- 34.50
- 1
- 111111
- 22
- zls_orm
- 2
- 西游记
- 333332
- 1112
- app01_author
- 3
- 金瓶梅
- 66.90
- 553
- 11122
- app01_authordetail
- 曾老湿
- app01_book
<!-- OCR_END -->

￼

***

| 需求：查询评论数大于阅读数的书 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 导入F函数
    from django.db.models import F
    #ret =  Book.objects.filter(commit_num__gt=reat_num)  ## 这是错误写法
    ## 使用F函数包裹一下
    ret1 = Book.objects.filter(commit_num__gt=F('reat_num'))
    print(ret1)
```

<!-- OCR_START -->
- orm2test.py
- test
- Project
- models.py
- test.py
- set
- .p
- manage.py
- Database
- orm2/PycharmProjects/orm2
- importos
- app01
- if
- _name
- zls_orm@10.0.0.511of6
- migrations
- os.enViron.setdefauLt("DJANGO_SETTINGS_MODULE","orm2.settings")
- _init_.py
- schemas1
- import django
- admin.py
- zls_orm
- apps.py
- django.setup()
- app01_author
- app01_authordetail
- tests.py
- from
- 01.models import *
- app01_book
- views.py
- 10
- #导
- 入F函数
- app01_book_authors
- from django.db.models import F
- orm2
- 12
- app01_publish
- ok.objects.filter（commitnumgt=reatnum）#这是错误写法
- auth_group
- settings.py
- 14
- ret1=Book.objects.filter（commitnumgt=F（'reatnum））
- auth_group_permissions
- urls.py
- print(ret1)
- auth_permission
- 16
- wsgi.py
- auth_user
- 17
- auth_user_groups
- templates
- auth_user_user_permissions
- 19
- django_admin_log
- 26
- #ret=Book.objects.all().values(pk').ar
- django_contenttype
- llli External Libraries
- if__name_=='_main_
- dianao miarations
- /Library/Framev
- eworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- erySet[<Book：红楼梦>，<Book：西游记>]>
- （0.000）SELECT anSQL_AUTO_IS_NULL;args=None
- (0.000) SELECT VERSION(); args=None
- (0.001)SELECT
- appo1_bookid，app01_book.name，app01_book.price，app01_bookpublish_id，app01_book.reat_num，
- 曾老湿
- ocess finishedwith exit code 0
<!-- OCR_END -->

￼

***

| 需求：把所有书的评论数加1 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 导入F函数
    from django.db.models import F
    ## 把所有书的评论数加1
    # ret = Book.objects.all().update(commit_num+=1) ## 错误写法
    ret =  Book.objects.all().update(commit_num=F('commit_num')+1)
```

<!-- OCR_START -->
- models.py
- test.py
- zls_orm.app01_authordetail[zls_orm@10.0.0.51]
- zls_orm.app01_book[zls_orm@10.0.0.51]
- 三2
- Database
- 3rows
- 1
- Tx:Auto
- Tab-se...(TSV)
- DDL
- ViewQuery
- <Filter criteria>
- ido
- name
- price
- publishid
- commit.num
- reatnum
- schemas1
- 1红楼梦
- 34.50
- 111112
- 22
- zls_orm
- 2
- 2西游记
- 333333
- 1112
- appo1_author
- 金瓶梅
- 66.90
- 554
- 11122
- 田app01_authordetail
- 曾老湿
- DriverZeng
- app01_book
<!-- OCR_END -->

￼

***

| 需求：把红楼梦书的阅读数减5 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 导入F函数
    from django.db.models import F
    ret = Book.objects.all().update(reat_num=F('reat_num')-5)
```

<!-- OCR_START -->
- models.py
- test.py
- zls_orm.app01_book[zls_orm@10.0.0.51]
- settings.py
- manage.py
- Database
- 3rows
- 1
- Tx:Auto
- 5
- Tab-se...d(TSV)
- DDL
- ViewQuery
- <Filter criteria>
- zls_orm@10.0.0.511of6
- id！
- name
- price
- publish_id
- commit.num
- reatnum
- schemas1
- 1红楼梦
- 34.50
- 111112
- 17
- zls_orm
- 2
- 西游记
- 333333
- 1107
- app01_author
- 金瓶梅
- 66.90
- 554
- 11117
- 田app01_authordetail
- 曾老湿
- app01_book
<!-- OCR_END -->

￼

## Q查询

filter() 等方法中的关键字参数查询都是一起进行“AND” 的。 如果你需要执行更复杂的查询（例如OR 语句），你可以使用Q 对象。

***

| 导入Q函数 |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 导入Q函数
    from django.db.models import Q
```

***

| 需求：查询作者名字是zls或者名字是cls的书/font> |
| :--- |

```plain
import os
if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "orm2.settings")
    import django
    django.setup()
    from app01.models import *
    ## 导入Q函数
    from django.db.models import Q
    # 方法一：
    ret = Author.objects.filter(Q(name='zls')|Q(name='cls')).values('book__name')
    print(ret)
    # 方法二：
    ret2 = Book.objects.filter(Q(authors__name='zls')|Q(authors__name='cls')).values('name')
    print(ret2)
```

<!-- OCR_START -->
- orm2test.py
- test
- #CCE
- Project
- test.py
- zls_orm.app01_book[zls_orm@10.0.0.51]x
- settings.py
- Database
- orm2~/Pyo
- import os
- app01
- if
- zls_orm@10.0.0.511of6
- migrations
- os.environ.setdefault("DJANGO_SETTINGS_MODULE","orm2.settings")
- _init_.py
- schemas1
- import django
- admin.py
- zls_orm
- django.setup()
- app01_author
- apps.py
- models.py
- app01_authordetail
- tests.py
- from
- app01.models import *
- app01_book
- views.py
- 10
- 导入Q函数
- app01_book_authors
- 11
- from django.db.models import Q
- app01_publish
- orm2
- 12
- #方法
- auth_group
- 1314
- ret=Author.objects.filter（Q(nam
- ='zls'）↓Q(na
- ='cls')).values('book
- print(ret)
- auth_group_permissions
- urls.py
- 15
- #方法二
- auth_permission
- 16
- ret2=B
- k.objects.filter(Q(authors_name='zls')IQ(authors_name='cls')).values（'name
- wsgi.py
- auth_user
- auth_user_groups
- templates
- auth_user_user_permissions
- manage.py
- 19
- mdjango_admin_log
- django_content_type
- llExternal Libraries
- 田dianaomiarations
- testx
- /Library/Frameworks/Python.framework/Versions/3.6/bin/python3.6/Users/driverzeng/PycharmProjects/orm2/test.py
- (0.000)
- SELECT
- _AUTO_IS_NULL;args=None
- （0.000） SELECT VERSION();args=No
- （0.001) SELECT app01_book
- nameFROMapp01_authorLEFTOUTERJOINappo1_book
- p01_author.id=app01_book_authors.author_id) LEFT OUTER JOINapp01_bookON（app01_book_authors².book_id=app01
- <QuerySet [{'book
- ame'：‘红楼梦'}，{'b
- ‘红楼梦'}，{'b
- ：‘金瓶梅'}]>
- [{'name'：红楼梦'}，{'name
- 金瓶梅'}，{'name'：‘红楼梦'}]>
- INNER JOINappO1_b
- k_authorsON（app01_book.id=app01_book_authors.book_id）INNER JOINapp01_authorON（`app01_book_authors.author_id=appo1_author.id
- 曾老湿
<!-- OCR_END -->

￼

```plain
## 支持下面三种写法
与：&
filter(Q(authors__name='zls')&Q(authors__name='cls'))
或：|
filter(Q(authors__name='zls')|Q(authors__name='cls'))
非：~
filter(Q(authors__name='zls')~Q(authors__name='cls'))
```

## ORM反向生成models

在企业中，我们的表基本上一句存在了，那么我们需要反向把他们从数据库中，导成orm的对象

**settings.py配置**

```plain
DATABASES = {
    'zls_orm': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'zls_orm',
        'USER': 'zls',
        'PASSWORD': '123',
        'HOST': '10.0.0.51',
        'PORT': '3306',
    },
}
```

**执行反向导出命令**

```plain
## 执行manage.py文件
MacBook-pro:orm2 driverzeng$ python3 manage.py inspectdb --database zls_orm > app01/models.py
inspectdb：反向导出
--datatabase：指定数据库（库名一定是在settings.py文件中配置的）
app01：项目名
```

## ORM常用和非常用字段

***

| 字段介绍 |
| :--- |

**AutoField**

int自增列，必须填入参数 primary_key=True。当model中如果没有自增列，则自动会创建一个列名为id的列。

**IntegerField**

一个整数类型,范围在 -2147483648 to 2147483647。

**CharField**

字符类型，必须提供max_length参数， max_length表示字符长度。

**DateField**

日期字段，日期格式 YYYY-MM-DD，相当于Python中的datetime.date()实例。

**DateTimeField**

日期时间字段，格式 YYYY-MM-DD HH:MM\[:ss\[.uuuuuu]]\[TZ]，相当于Python中的datetime.datetime()实例

```plain
AutoField
int自增列，必须填入参数 primary_key=True。当model中如果没有自增列，则自动会创建一个列名为id的列。
IntegerField
一个整数类型,范围在 -2147483648 to 2147483647。
CharField
字符类型，必须提供max_length参数， max_length表示字符长度。
DateField
日期字段，日期格式  YYYY-MM-DD，相当于Python中的datetime.date()实例。
DateTimeField
日期时间字段，格式 YYYY-MM-DD HH:MM[:ss[.uuuuuu]][TZ]，相当于Python中的datetime.datetime()实例
```

## ORM字段参数

```plain
null
用于表示某个字段可以为空。
unique
如果设置为unique=True 则该字段在此表中必须是唯一的 。
db_index
如果db_index=True 则代表着为此字段设置索引。
default
为该字段设置默认值。
# DateField和DateTimeField
auto_now_add
配置auto_now_add=True，创建数据记录的时候会把当前时间添加到数据库。
auto_now
配置上auto_now=True，每次更新数据记录的时候会更新该字段。
```

```plain
null                数据库中字段是否可以为空
    db_column           数据库中字段的列名
    db_tablespace
    default             数据库中字段的默认值
    primary_key         数据库中字段是否为主键
    db_index            数据库中字段是否可以建立索引
    unique              数据库中字段是否可以建立唯一索引
    unique_for_date     数据库中字段【日期】部分是否可以建立唯一索引
    unique_for_month    数据库中字段【月】部分是否可以建立唯一索引
    unique_for_year     数据库中字段【年】部分是否可以建立唯一索引
    verbose_name        Admin中显示的字段名称
    blank               Admin中是否允许用户输入为空
    editable            Admin中是否可以编辑
    help_text           Admin中该字段的提示信息
    choices             Admin中显示选择框的内容，用不变动的数据放在内存中从而避免跨表操作
                        如：gf = models.IntegerField(choices=[(0, '何穗'),(1, '大表姐'),],default=1)
    error_messages      自定义错误信息（字典类型），从而定制想要显示的错误信息；
                        字典健：null, blank, invalid, invalid_choice, unique, and unique_for_date
                        如：{'null': "不能为空.", 'invalid': '格式错误'}
    validators          自定义错误验证（列表类型），从而定制想要的验证规则
                        from django.core.validators import RegexValidator
                        from django.core.validators import EmailValidator,URLValidator,DecimalValidator,\
                        MaxLengthValidator,MinLengthValidator,MaxValueValidator,MinValueValidator
                        如：
                            test = models.CharField(
                                max_length=32,
                                error_messages={
                                    'c1': '优先错信息1',
                                    'c2': '优先错信息2',
                                    'c3': '优先错信息3',
                                },
                                validators=[
                                    RegexValidator(regex='root_\d+', message='错误了', code='c1'),
                                    RegexValidator(regex='root_112233\d+', message='又错误了', code='c2'),
                                    EmailValidator(message='又错误了', code='c3'), ]
                            )
```

## ORM关系字段

```plain
**ForeignKey**
外键类型在ORM中用来表示外键关联关系，一般把ForeignKey字段设置在 '一对多'中'多'的一方。
ForeignKey可以和其他表做关联关系同时也可以和自身做关联关系。
to
设置要关联的表
to_field
设置要关联的表的字段
related_name
反向操作时，使用的字段名，用于代替原反向查询时的'表名_set'。
```

```plain
class Classes(models.Model):
    name = models.CharField(max_length=32)
class Student(models.Model):
    name = models.CharField(max_length=32)
    theclass = models.ForeignKey(to="Classes")
```

当我们要查询某个班级关联的所有学生（反向查询）时，我们会这么写：

```plain
models.Classes.objects.first().student_set.all()
```

当我们在ForeignKey字段中添加了参数 related_name 后，

```plain
class Student(models.Model):
    name = models.CharField(max_length=32)
    theclass = models.ForeignKey(to="Classes", related_name="students")
```

当我们要查询某个班级关联的所有学生（反向查询）时，我们会这么写：

```plain
models.Classes.objects.first().students.all()
```

```plain
related_query_name
反向查询操作时，使用的连接前缀，用于替换表名。
on_delete
　　当删除关联表中的数据时，当前表与其关联的行的行为。
　　models.CASCADE
　　删除关联数据，与之关联也删除
　　models.DO_NOTHING
　　删除关联数据，引发错误IntegrityError
　　models.PROTECT
　　删除关联数据，引发错误ProtectedError
　　models.SET_NULL
　　删除关联数据，与之关联的值设置为null（前提FK字段需要设置为可空）
　　models.SET_DEFAULT
　　删除关联数据，与之关联的值设置为默认值（前提FK字段需要设置默认值）
　　models.SET
　　删除关联数据，
　　a. 与之关联的值设置为指定值，设置：models.SET(值)
　　b. 与之关联的值设置为可执行对象的返回值，设置：models.SET(可执行对象)
def func():
    return 10
class MyModel(models.Model):
    user = models.ForeignKey(
        to="User",
        to_field="id"，
        on_delete=models.SET(func)
    )
# db_constraint
是否在数据库中创建外键约束，默认为True。
```

## OneToOneField

一对一字段。

通常一对一字段用来扩展已有字段。

一对一的关联关系多用在当一张表的不同字段查询频次差距过大的情况下，将本可以存储在一张表的字段拆开放置在两张表中，然后将两张表建立一对一的关联关系。

```plain
class Author(models.Model):
    name = models.CharField(max_length=32)
    info = models.OneToOneField(to='AuthorInfo')
    
class AuthorInfo(models.Model):
    phone = models.CharField(max_length=11)
    email = models.EmailField()
```

```plain
to
设置要关联的表。
to_field
设置要关联的字段。
on_delete
同ForeignKey字段。
```

## ManyToManyField

```plain
用于表示多对多的关联关系。在数据库中通过第三张表来建立关联关系
to
设置要关联的表
related_name
同ForeignKey字段。
related_query_name
同ForeignKey字段。
symmetrical
仅用于多对多自关联时，指定内部是否创建反向操作的字段。默认为True。
```

**举个例子：**

```plain
class Person(models.Model):
    name = models.CharField(max_length=16)
    friends = models.ManyToManyField("self")
```

**此时，person对象就没有person_set属性。**

```plain
class Person(models.Model):
    name = models.CharField(max_length=16)
    friends = models.ManyToManyField("self", symmetrical=False)
```

此时，person对象现在就可以使用person_set属性进行反向查询。

```plain
through
在使用ManyToManyField字段时，Django将自动生成一张表来管理多对多的关联关系。
但我们也可以手动创建第三张表来管理多对多关系，此时就需要通过through来指定第三张表的表名。
through_fields
设置关联的字段。
db_table
默认创建第三张表时，数据库中表的名称。
```

## 多对多关联关系的三种方式

***

| 自己创建第三张表 |
| :--- |

```plain
class Book(models.Model):
    title = models.CharField(max_length=32, verbose_name="书名")
class Author(models.Model):
    name = models.CharField(max_length=32, verbose_name="作者姓名")
# 自己创建第三张表，分别通过外键关联书和作者
class Author2Book(models.Model):
    author = models.ForeignKey(to="Author")
    book = models.ForeignKey(to="Book")
    class Meta:
        unique_together = ("author", "book")
```

***

| 通过ManyToManyField自动创建第三张表 |
| :--- |

```plain
class Book(models.Model):
    title = models.CharField(max_length=32, verbose_name="书名")
# 通过ORM自带的ManyToManyField自动创建第三张表
class Author(models.Model):
    name = models.CharField(max_length=32, verbose_name="作者姓名")
    books = models.ManyToManyField(to="Book", related_name="authors")
```

设置ManyTomanyField并指定自行创建的第三张表

```plain
class Book(models.Model):
    title = models.CharField(max_length=32, verbose_name="书名")
# 自己创建第三张表，并通过ManyToManyField指定关联
class Author(models.Model):
    name = models.CharField(max_length=32, verbose_name="作者姓名")
    books = models.ManyToManyField(to="Book", through="Author2Book", through_fields=("author", "book"))
    # through_fields接受一个2元组（'field1'，'field2'）：
    # 其中field1是定义ManyToManyField的模型外键的名（author），field2是关联目标模型（book）的外键名。
class Author2Book(models.Model):
    author = models.ForeignKey(to="Author")
    book = models.ForeignKey(to="Book")
    class Meta:
        unique_together = ("author", "book")
```

**注意：**

当我们需要在第三张关系表中存储额外的字段时，就要使用第三种方式。

但是当我们使用第三种方式创建多对多关联关系时，就无法使用set、add、remove、clear方法来管理多对多的关系了，需要通过第三张表的model来管理多对多关系。

## 元信息

```plain
ORM对应的类里面包含另一个Meta类，而Meta类封装了一些数据库的信息。主要字段如下:
db_table
ORM在数据库中的表名默认是 app_类名，可以通过db_table可以重写表名。
index_together
联合索引。
unique_together
联合唯一索引。
ordering
指定默认按什么字段排序。
只有设置了该属性，我们查询到的结果才可以被reverse()。
```

```plain
class UserInfo(models.Model):
        nid = models.AutoField(primary_key=True)
        username = models.CharField(max_length=32)
        class Meta:
            # 数据库中生成的表名称 默认 app名称 + 下划线 + 类名
            db_table = "table_name"
            # 联合索引
            index_together = [
                ("pub_date", "deadline"),
            ]
            # 联合唯一索引
            unique_together = (("driver", "restaurant"),)
            
            ordering = ('name',)
            
            # admin中显示的表名称
            verbose_name='哈哈'
            # verbose_name加s
            verbose_name_plural=verbose_name
```

## 自定义字段（了解）

自定义char类型字段：

```plain
class FixedCharField(models.Field):
    """
    自定义的char类型的字段类
    """
    def __init__(self, max_length, *args, **kwargs):
        self.max_length = max_length
        super(FixedCharField, self).__init__(max_length=max_length, *args, **kwargs)
    def db_type(self, connection):
        """
        限定生成数据库表的字段类型为char，长度为max_length指定的值
        """
        return 'char(%s)' % self.max_length
class Class(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=25)
    # 使用自定义的char类型的字段
    cname = FixedCharField(max_length=25)
```

## defer和only

defer('id','name'):取出对象，字段除了id和name都有

only('id','name'):取的对象，只有id和name

如果点，依然能点出其它列，但是不要点了，因为取没有的列，会再次查询数据库

```plain
ret=models.Author.objects.only('nid')
    for i in ret:
        # 查询不在的字段，会再次查询数据库，造成数据库压力大
        print(i.name)
```

## 事务操作

```plain
# 事务操作
    from django.db import transaction
    with transaction.atomic():
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水。

WeChat：z133411023

QQ：133411023

> 更新: 2020-06-25 11:35:27  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/woey4i>