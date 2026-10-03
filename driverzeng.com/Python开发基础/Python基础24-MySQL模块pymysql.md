# Python基础24-MySQL模块pymysql

## Python基础24-MySQL模块pymysql
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(3) 评论(0)

+ [pymysql介绍](https://blog.driverzeng.com/zenglaoshi/5506.html#toc_0)
+ [SQL注入问题](https://blog.driverzeng.com/zenglaoshi/5506.html#toc_1)
+ [ORM框架SQLAlchemy](https://blog.driverzeng.com/zenglaoshi/5506.html#toc_2)

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

## pymysql介绍
介绍个毛线啊，就是python可以操作数据库啊...

---

| 安装pymysql |
| :--- |

```plain
MacBook-pro:~ driverzeng$  pip3 install pymysql -i https://mirrors.aliyun.com/pypi/simple/
```

<!-- OCR_START -->
- File
- Edit
- View
- Navigate
- Code
- Refactor
- Tools
- VCS
- Window
- Help
- driverzeng
- About PyCharm
- Check for Updates...
- 01paramiko模块
- Preferences...
- 86，
- 莫块.py
- Project
- 井发编程
- Services
- 多线程套接字服务并发
- HidePyCharm
- 进程池
- Hide Others
- 01paramiko模块.py
- ShowAll
- 01开启进程的两种方式.py
- 02join方法.py
- Quit PyCharm
- 8Q
- Availabl
- Qpymysql
- Q-
- Project:PYTHON Project Interpreter
- For current project
- Flask-pymysql
- Description
- Project Interpreter:
- Python 3.6（untitled1）~/Py
- PyMySQL
- Editor
- Pure Python MySQL Driver
- PyMySQLPro
- General
- Version
- PyMysqIDB
- Package
- ersion
- atestversio
- PyMysqIPool
- 0.9.3
- Font
- anthill-PyMySQL
- Author
- Color Scheme
- PyNaCI
- 1.4.0
- Code Style
- bottle-pymysql
- yutaka.matsubara
- bcrypt
- 3.1.7
- django-mysql-pymysql
- Inspections
- certifi
- 2020.4.5.1
- File and Code Templates
- django-pymysql-backend
- cffi
- 1.14.0
- tps://github.com/PyMySQL/PyMySQL
- File Encodings
- easyPyMySQL
- chardet
- 3.0.4
- mypymysql
- Live Templates
- cryptography
- 2.9.2
- opencensus-ext-pymysql
- FileTypes
- idna
- 2.9
- opentelemetry-ext-pymysql
- Copyright
- amiko
- 2.7.1
- pymysql-kits
- Emmet
- pip
- 10.0.1
- 20.1.1
- pymysql-manager
- Images
- pycparser
- 2.20
- Intentions
- pygame
- 1.9.6
- pymysql-pooling
- Language Injections
- requests
- 2.23.0
- pymysql-split-tool
- Spelling
- setuptools
- 39.1.0
- 47.1.1
- pymysql-utils
- TextMateBundles
- pymysql2
- six
- 1.15.0
- pymysql_sa
- urllib3
- 1.25.9
- pymysqlbatchimport
- Plugins
- pymysqlblinker
- Version Control
- pymysqlpool-dd
- Project:PYTHON
- pymysqlrpc
- Specify version
- pymysqlslave
- Project Structure
- Options
- Build,Execution,Deployment
- PackagePyMySQL'installed successfully
- 曾老湿
- Package'PyMySQL'
- OK
<!-- OCR_END -->

￼

---

| 使用pymysql |
| :--- |

```plain
import pymysql
#1.连接到数据库
conn = pymysql.Connect(
    host="10.0.0.200",
    user="root",
    password="123",
    database="mysql",
    port=3306,
    charset="utf8"
)
# 2.获取游标对象,游标帮你封装了send和recv，读和写
cursor = conn.cursor()
# 3.查询数据
sql = "select * from user;"
# 4.游标执行sql语句
res=cursor.execute(sql)
print(res)
#  5.关闭连接
cursor.close()
conn.close()
```

<!-- OCR_START -->
- PYTHON[~/DeSktop/PYTHON
- PYTHON
- o7pymysql 模块.py
- 01paramiko模块×
- 01paramiko模块.pyx
- 1
- import pymysql
- 2
- 3
- #1.连接到数据库
- 4
- conn = pymysql.Connect（
- 5
- host="10.0.0.200"
- 6
- user="root",
- password="123"
- database="mysql"
- 9
- port=3306,
- 10
- charset="utf8"
- 11
- 12
- 13
- #2.获取游标对象，游标帮你封装了send和recv，读和写
- 14
- 15
- cursor = conn.cursor()
- 16
- 17
- #3.查询数据
- 18
- sql ="select*from user;
- 19
- 20
- #4.游标执行sql语句
- 21
- 22
- res=cursor.execute(sql)
- 23
- print(res)
- 24
- 25
- #5.关闭连接
- Run:
- 07 pymysql 模块
- ers/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/07 pymysql 模块.py"
- Process finished with exit code o
- 曾老湿
- Driver Zeng
<!-- OCR_END -->

￼

7代表的是，返回了7行数据，但是我们要查看内容呀。

```plain
import pymysql
#1.连接到数据库
conn = pymysql.Connect(
    host="10.0.0.200",
    user="root",
    password="123",
    database="mysql",
    port=3306,
    charset="utf8"
)
# 2.获取游标对象,游标帮你封装了send和recv，读和写
cursor = conn.cursor()
# 3.查询数据
sql = "select * from user;"
# 4.游标执行sql语句
res=cursor.execute(sql)
print(res)
#  获取查询结果
data=cursor.fetchall()
print(data)
#  5.关闭连接
cursor.close()
conn.close()
```

<!-- OCR_START -->
| 排名 | PYTHON | PYTHON | PYTHON | 排名(上年) | PYTHON |
| --- | --- | --- | --- | --- | --- |
| #1.连接到数据库 | conn=pymysql.Connect( | st="10.0.0.200" | ser="root" | database="mysql", | port=3306, |
| 10 | charset="utf8" | 11 | 12 | 13 | #2.获取游标对象，游标帮你封装了send和recv，读和写 |
| 14 | 15 | cursor=conn.cursor() | 16 | 1 | #3.查询数据 |
| 18 | sqt= | select*from user | 19 | 20 | #4.游标执行sql语句 |
| 21 | 223 | res=cursor.execute(sql) | print(res) | 24 | 25 |
| #获取查询结果 | Run: | 07pymysql模块 | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/pythor | （localhost'，'r00t'，*23AE809DDACAF96AF0FD78ED04B6A265E05AA257'，Y'， | 曾老湿 |
<!-- OCR_END -->

￼

结果是出来了，但是我们看不到字段名字，压根不知道这个数据是含义。

```plain
import pymysql
#1.连接到数据库
conn = pymysql.Connect(
    host="10.0.0.200",
    user="root",
    password="123",
    database="mysql",
    port=3306,
    charset="utf8"
)
# 2.获取游标对象,游标帮你封装了send和recv，读和写
cursor = conn.cursor(pymysql.cursors.DictCursor)
# 3.查询数据
sql = "select * from user;"
# 4.游标执行sql语句
res=cursor.execute(sql)
print(res)
#  获取查询结果
data=cursor.fetchall()
print(data)
#  5.关闭连接
cursor.close()
conn.close()
```

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 名称 | 名称 | 排名 |
| --- | --- | --- | --- | --- | --- |
| PYTHON07pymysql模块.py | 01paramiko模块× | 01paramiko模块.py | 07pyr | ysql模块.py | import pymysql |
| #1.连接到数据库 | host="10.0.0.200" | user="root", | database="mysql", | port=3306, | 10 |
| charset="utf8" | 11 | #2.获取游标对象，游标帮你封装了send和recv，读和写 | 1 | cursor=conn.cursor(pymysql.cursors.DictCursor) | 17 |
| 3.查询数据 | select * from user; | 20 | 4.游标执行sql语句 | 2 | 22 |
| r=cursor.execute(sql) | 23 | print(res) | 获取查询结果 | 07pymysql模块 | /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python |
<!-- OCR_END -->

￼

```plain
cursor.fetchmany(10)  查找指定个数
cursor.fetchall() 查找全部
cursir.fetchone() 查找一个
## scroll 方法,移动光标
cursor.scroll(1,"absolute")
```

## SQL注入问题
```plain
import  pymysql
conn = pymysql.Connect(
    user="root",
    password="123",
    host="10.0.0.200",
    database="mysql",
    charset="utf8"
)
cursor = conn.cursor(pymysql.cursors.DictCursor)
#sql = "select *from user where user = '%s' and pwd = '%s';" % (input("input userName"),input("input password"))
# 当用户输入的用户名为字符串 为 yy' --   时
# 最终产生的sql  select *from user where user = 'yy' -- ' and pwd = '987657890';
# -- 用于mysql注释  意思是 后面的内容忽略掉
# 从而导致 密码是否正确都能登录成功
# "select *from user where user = 'axxax' or 1=1;
#print(sql)
count = cursor.execute("select *from user where user = %s and pwd = %s;",args=(input("user"),input("pwd")))
print(count)
if count:
    print("login success")
else:
    print("login error")
cursor.close()
conn.close()
# sql注入攻击 是什么意思?
# 一些了解sql语法的 用户  可以输入一些关键字 或合法sql  来导致原始的sql逻辑发生变化  从而跳过登录验证 或者 删除数据库
# 如何避免 在接受用户输入的数据时  可以加上限制 比如 不能输    -- ' ; where 等等
# 上面这种方式 只能避免  黑客 从你的客户端软件注入 sql
# 但是无法避免  中间人攻击(在你的客户端和服务器中间加一个中转服务器)
# 这样就绕过了客户端的输入限制   此时 只能将 sql合法性验证放在服务器端
#
#  总结: python如何避免sql注入? 把你的slq(用户输入的)参数 放execute函数的arg参数中  让pymysql 自动帮你屏蔽注入攻击
```

## ORM框架SQLAlchemy
SQLAlchemy是Python编程语言下的一款ORM框架，该框架建立在数据库API之上，使用关系对象映射进行数据库操作，简言之便是：将对象转换成SQL，然后使用数据API执行SQL并获取执行结果。

---

| 安装 |
| :--- |

```plain
pip3 install sqlalchemy
```

---

| 架构与流程 |
| :--- |

<!-- OCR_START -->
- SQLAlchemyORM
- ObjectRelational Mapper(ORM)
- SQLAlchemyCore
- SQLExpression
- Schema/Types
- Engine
- Language
- Connection
- Dialect
- Pooling
- DBAPI
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

```plain
#1、使用者通过ORM对象提交命令
#2、将命令交给SQLAlchemy Core（Schema/Types  SQL Expression Language）转换成SQL
#3、使用 Engine/ConnectionPooling/Dialect 进行数据库操作
#3.1、匹配使用者事先配置好的egine
#3.2、egine从连接池中取出一个链接
#3.3、基于该链接通过Dialect调用DB API，将SQL转交给它去执行
```

！！！上述流程分析，可以大致分为两个阶段！！！：

```plain
#第一个阶段（流程1-2）：将SQLAlchemy的对象换成可执行的sql语句
#第二个阶段（流程3）：将sql语句交给数据库执行
```

如果我们不依赖于SQLAlchemy的转换而自己写好sql语句，那是不是意味着可以直接从第二个阶段开始执行了，事实上正是如此，我们完全可以只用SQLAlchemy执行纯sql语句，如下

```plain
from sqlalchemy import create_engine
#1 准备
# 需要事先安装好pymysql
# 需要事先创建好数据库:create database db1 charset utf8;
#2 创建引擎
egine=create_engine('mysql+pymysql://root@127.0.0.1/db1?charset=utf8')
#3 执行sql
# egine.execute('create table if not EXISTS t1(id int PRIMARY KEY auto_increment,name char(32));')
# cur=egine.execute('insert into t1 values(%s,%s);',[(1,"zls1"),(2,"zls2"),(3,"zls3")]) #按位置传值
# cur=egine.execute('insert into t1 values(%(id)s,%(name)s);',name='zls4',id=4) #按关键字传值
#4 新插入行的自增id
# print(cur.lastrowid)
#5 查询
cur=egine.execute('select * from t1')
cur.fetchone() #获取一行
cur.fetchmany(2) #获取多行
cur.fetchall() #获取所有行
```

---

| DB API |
| :--- |

SQLAlchemy本身无法操作数据库，其必须以来pymsql等第三方插件，Dialect用于和数据API进行交流，根据配置文件的不同调用不同的数据库API，从而实现对数据库的操作，如：

```plain
#1、MySQL-Python
    mysql+mysqldb://<user>:<password>@<host>[:<port>]/<dbname>
   
#2、pymysql
    mysql+pymysql://<username>:<password>@<host>/<dbname>[?<options>]
   
#3、MySQL-Connector
    mysql+mysqlconnector://<user>:<password>@<host>[:<port>]/<dbname>
   
#4、cx_Oracle
    oracle+cx_oracle://user:pass@host:port/dbname[?key=value&key=value...]
```

更多内容，请看官网：[TP](https://docs.sqlalchemy.org/en/13/dialects/index.html)

---

| ORM创建表 |
| :--- |

类=>表  
对象>表中的一行记录

四张表:业务线,服务,用户,角色，利用ORM创建出它们，并建立好它们直接的关系

```plain
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column,Integer,String,DateTime,Enum,ForeignKey,UniqueConstraint,ForeignKeyConstraint,Index
from sqlalchemy.orm import sessionmaker
egine=create_engine('mysql+pymysql://root@127.0.0.1:3306/db1?charset=utf8',max_overflow=5)
Base=declarative_base()
#创建单表:业务线
class Business(Base):
    __tablename__='business'
    id=Column(Integer,primary_key=True,autoincrement=True)
    bname=Column(String(32),nullable=False,index=True)
#多对一:多个服务可以属于一个业务线,多个业务线不能包含同一个服务
class Service(Base):
    __tablename__='service'
    id=Column(Integer,primary_key=True,autoincrement=True)
    sname=Column(String(32),nullable=False,index=True)
    ip=Column(String(15),nullable=False)
    port=Column(Integer,nullable=False)
    business_id=Column(Integer,ForeignKey('business.id'))
    __table_args__=(
        UniqueConstraint(ip,port,name='uix_ip_port'),
        Index('ix_id_sname',id,sname)
    )
#一对一:一种角色只能管理一条业务线,一条业务线只能被一种角色管理
class Role(Base):
    __tablename__='role'
    id=Column(Integer,primary_key=True,autoincrement=True)
    rname=Column(String(32),nullable=False,index=True)
    priv=Column(String(64),nullable=False)
    business_id=Column(Integer,ForeignKey('business.id'),unique=True)
#多对多:多个用户可以是同一个role,多个role可以包含同一个用户
class Users(Base):
    __tablename__='users'
    id=Column(Integer,primary_key=True,autoincrement=True)
    uname=Column(String(32),nullable=False,index=True)
class Users2Role(Base):
    __tablename__='users2role'
    id=Column(Integer,primary_key=True,autoincrement=True)
    uid=Column(Integer,ForeignKey('users.id'))
    rid=Column(Integer,ForeignKey('role.id'))
    __table_args__=(
        UniqueConstraint(uid,rid,name='uix_uid_rid'),
    )
def init_db():
    Base.metadata.create_all(egine)
def drop_db():
    Base.metadata.drop_all(egine)
if __name__ == '__main__':
    init_db()
```

注：设置外键的另一种方式 ForeignKeyConstraint(['other_id'], ['othertable.other_id'])

---

| 增删改查 |
| :--- |

**表结构**

```plain
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column,Integer,String,ForeignKey
from sqlalchemy.orm import sessionmaker
egine=create_engine('mysql+pymysql://root@127.0.0.1:3306/db1?charset=utf8',max_overflow=5)
Base=declarative_base()
#多对一:假设多个员工可以属于一个部门,而多个部门不能有同一个员工(只有创建公司才把员工当骆驼用,一个员工身兼数职)
class Dep(Base):
    __tablename__='dep'
    id=Column(Integer,primary_key=True,autoincrement=True)
    dname=Column(String(64),nullable=False,index=True)
class Emp(Base):
    __tablename__='emp'
    id=Column(Integer,primary_key=True,autoincrement=True)
    ename=Column(String(32),nullable=False,index=True)
    dep_id=Column(Integer,ForeignKey('dep.id'))
def init_db():
    Base.metadata.create_all(egine)
def drop_db():
    Base.metadata.drop_all(egine)
drop_db()
init_db()
Session=sessionmaker(bind=egine)
session=Session()
```

**增**

```plain
#增
row_obj=Dep(dname='销售') #按关键字传参,无需指定id,因其是自增长的
session.add(row_obj)
session.add_all([
    Dep(dname='技术'),
    Dep(dname='运营'),
    Dep(dname='人事'),
])
session.commit()
```

**删**

```plain
#删
session.query(Dep).filter(Dep.id > 3).delete()
session.commit()
```

**改**

```plain
#改
session.query(Dep).filter(Dep.id > 0).update({'dname':'哇哈哈'})
session.query(Dep).filter(Dep.id > 0).update({'dname':Dep.dname+'_SB'},synchronize_session=False)
session.query(Dep).filter(Dep.id > 0).update({'id':Dep.id*100},synchronize_session='evaluate')
session.commit()
```

**查**

```plain
#查所有,取所有字段
res=session.query(Dep).all() #for row in res:print(row.id,row.dname)
#查所有,取指定字段
res=session.query(Dep.dname).order_by(Dep.id).all() #for row in res:print(row.dname)
res=session.query(Dep.dname).first()
print(res) # ('哇哈哈_SB',)
#过滤查
res=session.query(Dep).filter(Dep.id > 1,Dep.id <1000) #逗号分隔,默认为and
print([(row.id,row.dname) for row in res])
```

---

| 其他查询相关 |
| :--- |

**准备表和数据**

```plain
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column,Integer,String,ForeignKey
from sqlalchemy.orm import sessionmaker
egine=create_engine('mysql+pymysql://root@127.0.0.1:3306/db1?charset=utf8',max_overflow=5)
Base=declarative_base()
#多对一:假设多个员工可以属于一个部门,而多个部门不能有同一个员工(只有创建公司才把员工当骆驼用,一个员工身兼数职)
class Dep(Base):
    __tablename__='dep'
    id=Column(Integer,primary_key=True,autoincrement=True)
    dname=Column(String(64),nullable=False,index=True)
class Emp(Base):
    __tablename__='emp'
    id=Column(Integer,primary_key=True,autoincrement=True)
    ename=Column(String(32),nullable=False,index=True)
    dep_id=Column(Integer,ForeignKey('dep.id'))
def init_db():
    Base.metadata.create_all(egine)
def drop_db():
    Base.metadata.drop_all(egine)
drop_db()
init_db()
Session=sessionmaker(bind=egine)
session=Session()
# 准备数据
session.add_all([
    Dep(dname='技术'),
    Dep(dname='销售'),
    Dep(dname='运营'),
    Dep(dname='人事'),
])
session.add_all([
    Emp(ename='曾老湿',dep_id=1),
    Emp(ename='李杰',dep_id=1),
    Emp(ename='武配齐',dep_id=1),
    Emp(ename='元昊',dep_id=2),
    Emp(ename='李钢弹',dep_id=3),
    Emp(ename='张二丫',dep_id=4),
    Emp(ename='李坦克',dep_id=2),
    Emp(ename='王大炮',dep_id=4),
    Emp(ename='牛榴弹',dep_id=3)
])
session.commit()
```

**条件、通配符、limit、排序、分组、连表、组合**

```plain
#一、条件
sql=session.query(Emp).filter_by(ename='曾老湿') #filter_by只能传参数:什么等于什么
res=sql.all() #sql语句的执行结果
res=session.query(Emp).filter(Emp.id>0,Emp.ename == '曾老湿').all() #filter内传的是表达式,逗号分隔,默认为and,
res=session.query(Emp).filter(Emp.id.between(1,3),Emp.ename == '曾老湿').all()
res=session.query(Emp).filter(Emp.id.in_([1,3,99,101]),Emp.ename == '曾老湿').all()
res=session.query(Emp).filter(~Emp.id.in_([1,3,99,101]),Emp.ename == '曾老湿') #~代表取反,转换成sql就是关键字not
from sqlalchemy import and_,or_
res=session.query(Emp).filter(and_(Emp.id > 0,Emp.ename=='曾老湿')).all()
res=session.query(Emp).filter(or_(Emp.id < 2,Emp.ename=='功夫熊猫')).all()
res=session.query(Emp).filter(
    or_(
        Emp.dep_id == 3,
        and_(Emp.id > 1,Emp.ename=='功夫熊猫'),
        Emp.ename != ''
    )
).all()
#二、通配符
res=session.query(Emp).filter(Emp.ename.like('%海_%')).all()
res=session.query(Emp).filter(~Emp.ename.like('%海_%')).all()
#三、limit
res=session.query(Emp)[0:5:2]
#四、排序
res=session.query(Emp).order_by(Emp.dep_id.desc()).all()
res=session.query(Emp).order_by(Emp.dep_id.desc(),Emp.id.asc()).all()
#五、分组
from sqlalchemy.sql import func
res=session.query(Emp.dep_id).group_by(Emp.dep_id).all()
res=session.query(
    func.max(Emp.dep_id),
    func.min(Emp.dep_id),
    func.sum(Emp.dep_id),
    func.avg(Emp.dep_id),
    func.count(Emp.dep_id),
).group_by(Emp.dep_id).all()
res=session.query(
    Emp.dep_id,
    func.count(1),
).group_by(Emp.dep_id).having(func.count(1) > 2).all()
#六、连表
#笛卡尔积
res=session.query(Emp,Dep).all() #select * from emp,dep;
#where条件
res=session.query(Emp,Dep).filter(Emp.dep_id==Dep.id).all()
# for row in res:
#     emp_tb=row[0]
#     dep_tb=row[1]
#     print(emp_tb.id,emp_tb.ename,dep_tb.id,dep_tb.dname)
#内连接
res=session.query(Emp).join(Dep)
#join默认为内连接,SQLAlchemy会自动帮我们通过foreign key字段去找关联关系
#但是上述查询的结果均为Emp表的字段,这样链表还有毛线意义,于是我们修改为
res=session.query(Emp.id,Emp.ename,Emp.dep_id,Dep.dname).join(Dep).all()
#左连接:isouter=True
res=session.query(Emp.id,Emp.ename,Emp.dep_id,Dep.dname).join(Dep,isouter=True).all()
#右连接:同左连接,只是把两个表的位置换一下
#七、组合
q1=session.query(Emp.id,Emp.ename).filter(Emp.id > 0,Emp.id < 5)
q2=session.query(Emp.id,Emp.ename).filter(
    or_(
        Emp.ename.like('%海%'),
        Emp.ename.like('%昊%'),
    )
)
res1=q1.union(q2) #组合+去重
res2=q1.union_all(q2) #组合,不去重
print([i.ename for i in q1.all()]) #['曾老湿', '李杰', '武配齐', '元昊']
print([i.ename for i in q2.all()]) #['曾老湿', '元昊']
print([i.ename for i in res1.all()]) #['曾老湿', '李杰', '武配齐', '元昊']
print([i.ename for i in res2.all()]) #['曾老湿', '李杰', '武配齐', '元昊', '元昊', '曾老湿']
```

**子查询**

```plain
##  有三种形式的子查询，注意：子查询的sql必须用括号包起来,尤其在形式三中需要注意这一点
## 形式一：
#示例:查出id大于2的员工,当做子查询的表使用
#原生SQL:
# select * from (select * from emp where id > 2);
#ORM:
res=session.query(
    session.query(Emp).filter(Emp.id > 8).subquery()
).all()
形式一:子查询当做一张表来用,调用subquery()
## 形式二：
#示例:#查出销售部门的员工姓名
#原生SQL:
# select ename from emp where dep_id in (select id from dep where dname='销售');
#ORM:
res=session.query(Emp.ename).filter(Emp.dep_id.in_(
    session.query(Dep.id).filter_by(dname='销售'), #传的是参数
    # session.query(Dep.id).filter(Dep.dname=='销售') #传的是表达式
)).all()
形式二:子查询当做in的范围用,调用in_
## 形式三：
#示例:查询所有的员工姓名与部门名
#原生SQL:
# select ename as 员工姓名,(select dname from dep where id = emp.dep_id) as 部门名 from emp;
#ORM:
sub_sql=session.query(Dep.dname).filter(Dep.id==Emp.dep_id) #SELECT dep.dname FROM dep, emp WHERE dep.id = emp.dep_id
sub_sql.as_scalar() #as_scalar的功能就是把上面的sub_sql加上了括号
res=session.query(Emp.ename,sub_sql.as_scalar()).all()
形式三:子查询当做select后的字段,调用as_scalar()
```

---

| 正查、反查 |
| :--- |

修改表

```plain
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column,Integer,String,ForeignKey
from sqlalchemy.orm import sessionmaker,relationship
egine=create_engine('mysql+pymysql://root@127.0.0.1:3306/db1?charset=utf8',max_overflow=5)
Base=declarative_base()
class Dep(Base):
    __tablename__='dep'
    id=Column(Integer,primary_key=True,autoincrement=True)
    dname=Column(String(64),nullable=False,index=True)
class Emp(Base):
    __tablename__='emp'
    id=Column(Integer,primary_key=True,autoincrement=True)
    ename=Column(String(32),nullable=False,index=True)
    dep_id=Column(Integer,ForeignKey('dep.id'))
    #在ForeignKey所在的类内添加relationship的字段,注意:
    #1:Dep是类名
    #2:depart字段不会再数据库表中生成字段
    #3:depart用于Emp表查询Dep表(正向查询),而xxoo用于Dep表查询Emp表(反向查询),
    depart=relationship('Dep',backref='xxoo') 
def init_db():
    Base.metadata.create_all(egine)
def drop_db():
    Base.metadata.drop_all(egine)
drop_db()
init_db()
Session=sessionmaker(bind=egine)
session=Session()
# 准备数据
session.add_all([
    Dep(dname='技术'),
    Dep(dname='销售'),
    Dep(dname='运营'),
    Dep(dname='人事'),
])
session.add_all([
    Emp(ename='曾老湿',dep_id=1),
    Emp(ename='李杰',dep_id=1),
    Emp(ename='武配齐',dep_id=1),
    Emp(ename='元昊',dep_id=2),
    Emp(ename='李钢弹',dep_id=3),
    Emp(ename='张二丫',dep_id=4),
    Emp(ename='李坦克',dep_id=2),
    Emp(ename='王大炮',dep_id=4),
    Emp(ename='牛榴弹',dep_id=3)
])
session.commit()
```

**标准连表查询**

```plain
# 示例:查询员工名与其部门名
res=session.query(Emp.ename,Dep.dname).join(Dep) #迭代器
for row in res:
    print(row[0],row[1]) #等同于print(row.ename,row.dname)
```

**基于relationship的正查、反查**

```plain
#SQLAlchemy的relationship在内部帮我们做好表的链接
#查询员工名与其部门名(正向查)
res=session.query(Emp)
for row in res:
    print(row.ename,row.id,row.depart.dname)
#查询部门名以及该部门下的员工(反向查)
res=session.query(Dep)
for row in res:
    # print(row.dname,row.xxoo)
    print(row.dname,[r.ename for r in row.xxoo])
```

关于 曾老湿

我只是一个躲在角落里瑟瑟发抖的小运维，随时准备给大佬端茶递水

> 更新: 2020-06-25 11:29:34  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/xcg5gv>