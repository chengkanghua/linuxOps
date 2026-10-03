# 第8章 MySQL数据库

# 8.1 初识数据库
## 8.1.1 数据库管理软件的由来
### 本节重点
+ 了解数据库的作用

> **本节时长需控制在5分钟内**
>

### 数据库管理软件的由来
基于我们之前所学，数据要想永久保存，都是保存于文件中，毫无疑问，一个文件仅仅只能存在于某一台机器上。

如果我们暂且忽略直接基于文件来存取数据的效率问题，并且假设程序所有的组件都运行在一台机器上，那么用文件存取数据，并没有问题。

很不幸，这些假设都是你自己意淫出来的，上述假设存在以下几个问题。。。。。。

**1、程序所有的组件就不可能运行在一台机器上**

```plain
因为这台机器一旦挂掉则意味着整个软件的崩溃，并且程序的执行效率依赖于承载它的硬件，而一台机器机器的性能总归是有限的，
受限于目前的硬件水平，就一台机器的性能垂直进行扩展是有极限的。
于是我们只能通过水平扩展来增强我们系统的整体性能，这就需要我们将程序的各个组件分布于多台机器去执行。
```

**2、数据安全问题**

```plain
根据1的描述，我们将程序的各个组件分布到各台机器，但需知各组件仍然是一个整体，言外之意，所有组件的数据还是要共享的。
但每台机器上的组件都只能操作本机的文件，这就导致了数据必然不一致。
于是我们想到了将数据与应用程序分离：把文件存放于一台机器，然后将多台机器通过网络去访问这台机器上的文件（用socket实现），
即共享这台机器上的文件,共享则意味着竞争，会发生数据不安全，需要加锁处理。。。。
```

**3、并发**

根据2的描述，我们必须写一个socket服务端来管理这台机器（数据库服务器）上的文件，然后写一个socket客户端，完成如下功能：

```plain
1.远程连接（支持并发）
2.打开文件
3.读写（加锁）
4.关闭文件
```

**总结：**

```plain
我们在编写任何程序之前，都需要事先写好基于网络操作一台主机上文件的程序（socket服务端与客户端程序），于是有人将此类程序写成一个
专门的处理软件，这就是mysql等数据库管理软件的由来，但mysql解决的不仅仅是数据共享的问题，还有查询效率，安全性等一系列问题，
总之，把程序员从数据管理中解脱出来，专注于自己的程序逻辑的编写。
```

## 8.1.2 数据库概述
### 本节重点
+ 掌握概念库、表、记录

> **本节时长需控制在5分钟内**
>

### 数据库概述
**1 什么是数据（Data）**

_描述事物的符号记录称为数据，描述事物的符号既可以是数字，也可以是文字、图片，图像、声音、语言等，数据由多种表现形式，它们都可以经过数字化后存入计算机_

_在计算机中描述一个事物，就需要抽取这一事物的典型特征，组成一条记录，就相当于文件里的一行内容，如：_

```plain
1 egon,male,18,1999,山东,计算机系,2017,oldboy
```

_单纯的一条记录并没有任何意义，如果我们按逗号作为分隔，依次定义各个字段的意思，相当于定义表的标题_

```plain
1 name,sex,age,birth,born_addr,major,entrance_time,school #字段
2 egon,male,18,1999,山东,计算机系,2017,oldboy #记录
```

_这样我们就可以了解egon，性别为男，年龄18岁，出生于1999年，出生地为山东，2017年考入老男孩计算机系_

**2 什么是数据库（DataBase，简称DB）**

_数据库即存放数据的仓库，只不过这个仓库是在计算机存储设备上，而且数据是按一定的格式存放的_

_过去人们将数据存放在文件柜里，现在数据量庞大，已经不再适用_

_数据库是长期存放在计算机内、有组织、可共享的数据即可。_

_数据库中的数据按一定的数据模型组织、描述和储存，具有较小的冗余度、较高的数据独立性和易扩展性，并可为各种 用户共享_

**3 什么是数据库管理系统（DataBase Management System 简称DBMS）**

_在了解了Data与DB的概念后，如何科学地组织和存储数据，如何高效获取和维护数据成了关键_

_这就用到了一个系统软件---数据库管理系统_

_如MySQL、Oracle、SQLite、Access、MS SQL Server_

_mysql主要用于大型门户，例如搜狗、新浪等，它主要的优势就是开放源代码，因为开放源代码这个数据库是免费的，他现在是甲骨文公司的产品。_

_oracle主要用于银行、铁路、飞机场等。该数据库功能强大，软件费用高。也是甲骨文公司的产品。_

_sql server是微软公司的产品，主要应用于大中型企业，如联想、方正等。_

**4 数据库服务器、数据管理系统、数据库、表与记录的关系（重点理解！！！）**

**记录：1 刘海龙 324245234 22（多个字段的信息组成一条记录，即文件中的一行内容）**

**表：student,scholl,class_list（即文件）**

**数据库：oldboy_stu（即文件夹）**

**数据库管理系统：如mysql（是一个软件）**

**数据库服务器：一台计算机（对内存要求比较高）**

**总结：**

**数据库服务器-：运行数据库管理软件**

**数据库管理软件：管理-数据库**

**数据库：即文件夹，用来组织文件/表**

**表：即文件，用来存放多行内容/多条记录**

<!-- OCR_START -->
| oldboy_stu | oldboy_stu | oldboy_stu | oldboy_stu | 排名 |
| --- | --- | --- | --- | --- |
| 324245234 | 22 | 李间 | 3532431 | 25 |
| name | addr | 孙海涛 | 224434232 | 50 |
| 北京总校 | 沙河昌平 | 上海分校 | 外滩 | class_list |
| id | course_name | semester | start_date | python自动化 |
| 16 | 2017-1-7 | 2 | python全栈开发 | 4 |
<!-- OCR_END -->

## 8.1.3 mysql安装与基本管理
### 本节重点
+ 掌握mysql的安装、启动、破解密码、统一字符编码

> **本节时长需控制在15分钟内**
>

### 一、MySQL介绍
MySQL是一个关系型数据库管理系统，由瑞典MySQL AB 公司开发，目前属于 Oracle 旗下公司。MySQL 最流行的关系型数据库管理系统，在 WEB 应用方面MySQL是最好的 RDBMS (Relational Database Management System，关系数据库管理系统) 应用软件之一。

**mysql是什么**

```plain
mysql就是一个基于socket编写的C/S架构的软件
客户端软件
　　mysql自带：如mysql命令，mysqldump命令等
　　python模块：如pymysql
```

**数据库管理软件分类**

```plain
分两大类：
　　关系型：如sqllite，db2，oracle，access，sql server，MySQL，注意：sql语句通用
　　非关系型：mongodb，redis，memcache
可以简单的理解为：
    关系型数据库需要有表结构
    非关系型数据库是key-value存储的，没有表结构
```

### 二、下载安装
**Linux版本**

```plain
#二进制rpm包安装
yum -y install mysql-server mysql
```

源码安装见：[http://www.cnblogs.com/linhaifeng/articles/7126847.html](http://www.cnblogs.com/linhaifeng/articles/7126847.html)

**Window版本**

```plain
#1、下载：MySQL Community Server 5.7.16
http://dev.mysql.com/downloads/mysql/
#2、解压
如果想要让MySQL安装在指定目录，那么就将解压后的文件夹移动到指定目录，如：C:\mysql-5.7.16-winx64
#3、添加环境变量
【右键计算机】--》【属性】--》【高级系统设置】--》【高级】--》【环境变量】--》【在第二个内容框中找到 变量名为Path 的一行，双击】 --> 【将MySQL的bin目录路径追加到变值值中，用 ； 分割】
#4、初始化
mysqld --initialize-insecure
#5、启动MySQL服务
mysqld # 启动MySQL服务
#6、启动MySQL客户端并连接MySQL服务
mysql -u root -p # 连接MySQL服务器
```

上一步解决了一些问题，但不够彻底，因为在执行【mysqd】启动MySQL服务器时，当前终端会被hang住，那么做一下设置即可解决此问题,即将MySQL服务制作成windows服务

```plain
注意：--install前，必须用mysql启动命令的绝对路径
# 制作MySQL的Windows服务，在终端执行此命令：
"c:\mysql-5.7.16-winx64\bin\mysqld" --install
# 移除MySQL的Windows服务，在终端执行此命令：
"c:\mysql-5.7.16-winx64\bin\mysqld" --remove
注册成服务之后，以后再启动和关闭MySQL服务时，仅需执行如下命令：
# 启动MySQL服务
net start mysql
# 关闭MySQL服务
net stop mysql
```

### 三、MySQL启动与查看
linux平台下查看

```plain
[root@egon ~]# systemctl start mariadb #启动
[root@egon ~]# systemctl enable mariadb #设置开机自启动
Created symlink from /etc/systemd/system/multi-user.target.wants/mariadb.service to /usr/lib/systemd/system/mariadb.service.
[root@egon ~]# ps aux |grep mysqld |grep -v grep #查看进程，mysqld_safe为启动mysql的脚本文件，内部调用mysqld命令
mysql     3329  0.0  0.0 113252  1592 ?        Ss   16:19   0:00 /bin/sh /usr/bin/mysqld_safe --basedir=/usr
mysql     3488  0.0  2.3 839276 90380 ?        Sl   16:19   0:00 /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --log-error=/var/log/mariadb/mariadb.log --pid-file=/var/run/mariadb/mariadb.pid --socket=/var/lib/mysql/mysql.sock
[root@egon ~]# netstat -an |grep 3306 #查看端口
tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN  
[root@egon ~]# ll -d /var/lib/mysql #权限不对，启动不成功，注意user和group
drwxr-xr-x 5 mysql mysql 4096 Jul 20 16:28 /var/lib/mysql
```

You must reset your password using ALTER USER statement before executing this statement.

```plain
安装完mysql 之后，登陆以后，不管运行任何命令，总是提示这个
mac mysql error You must reset your password using ALTER USER statement before executing this statement.
解决方法：
step 1: SET PASSWORD = PASSWORD('your new password');
step 2: ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;
step 3: flush privileges;
```

windows平台到服务中查看即可

### 三、登录设置密码
```plain
初始状态下，管理员root，密码为空，默认只允许从本机登录localhost
设置密码
[root@egon ~]# mysqladmin -uroot password "123"        设置初始密码 由于原密码为空，因此-p可以不用
[root@egon ~]# mysqladmin -uroot -p"123" password "456"        修改mysql密码,因为已经有密码了，所以必须输入原密码才能设置新密码
命令格式:
[root@egon ~]# mysql -h172.31.0.2 -uroot -p456
[root@egon ~]# mysql -uroot -p
[root@egon ~]# mysql                    以root用户登录本机，密码为空
```

### 三、破解密码
**linux平台下，破解密码的两种方式**

方法一：删除授权库mysql，重新初始化

```plain
[root@egon ~]# rm -rf /var/lib/mysql/mysql #所有授权信息全部丢失！！！
[root@egon ~]# systemctl restart mariadb
[root@egon ~]# mysql
```

方法二：启动时，跳过授权库

```plain
[root@egon ~]# vim /etc/my.cnf    #mysql主配置文件
[mysqld]
skip-grant-table
[root@egon ~]# systemctl restart mariadb
[root@egon ~]# mysql
MariaDB [(none)]> update mysql.user set password=password("123") where user="root" and host="localhost";
MariaDB [(none)]> flush privileges;
MariaDB [(none)]> \q
[root@egon ~]# #打开/etc/my.cnf去掉skip-grant-table,然后重启
[root@egon ~]# systemctl restart mariadb
[root@egon ~]# mysql -u root -p123 #以新密码登录
```

**windows平台下，5.7版本mysql，破解密码的两种方式：**

方式一

```plain
#1 关闭mysql
#2 在cmd中执行：mysqld --skip-grant-tables
#3 在cmd中执行：mysql
#4 执行如下sql：
update mysql.user set authentication_string=password('') where user = 'root';
flush privileges;
#5 tskill mysqld #或taskkill -f /PID 7832
#6 重新启动mysql
```

方式二

```plain
#1. 关闭mysql，可以用tskill mysqld将其杀死
#2. 在解压目录下，新建mysql配置文件my.ini
#3. my.ini内容,指定
[mysqld]
skip-grant-tables
#4.启动mysqld
#5.在cmd里直接输入mysql登录，然后操作
update mysql.user set authentication_string=password('') where user='root and host='localhost';
flush privileges;
#6.注释my.ini中的skip-grant-tables，然后启动myqsld，然后就可以以新密码登录了
```

### 四、统一字符编码
**强调：配置文件中的注释可以有中文，但是配置项中不能出现中文**

```plain
#在mysql的解压目录下，新建my.ini,然后配置
#1. 在执行mysqld命令时，下列配置会生效，即mysql服务启动时生效
[mysqld]
;skip-grant-tables
port=3306
character_set_server=utf8
default-storage-engine=innodb
innodb_file_per_table=1
#解压的目录
basedir=E:\mysql-5.7.19-winx64
#data目录
datadir=E:\my_data #在mysqld --initialize时，就会将初始数据存入此处指定的目录，在初始化之后，启动mysql时，就会去这个目录里找数据
#2. 针对客户端命令的全局配置，当mysql客户端命令执行时，下列配置生效
[client]
port=3306
default-character-set=utf8
user=root
password=123
#3. 只针对mysql这个客户端的配置，2中的是全局配置，而此处的则是只针对mysql这个命令的局部配置
[mysql]
;port=3306
;default-character-set=utf8
user=egon
password=4573
#！！！如果没有[mysql],则用户在执行mysql命令时的配置以[client]为准
```

**统一字符编码**

```plain
#1. 修改配置文件
[mysqld]
default-character-set=utf8 
[client]
default-character-set=utf8 
[mysql]
default-character-set=utf8
#mysql5.5以上：修改方式有所改动
[mysqld]
character-set-server=utf8
collation-server=utf8_general_ci
[client]
default-character-set=utf8
[mysql]
default-character-set=utf8
#2. 重启服务
#3. 查看修改结果：
\s
show variables like '%char%'
```

## 8.1.4 初识sql语句
### 本节重点
+ 了解数据库的作用
+ 掌握概念库、表、记录

> **本节时长需控制在15分钟内**
>

### 初识sql语句
有了mysql这个数据库软件，就可以将程序员从对数据的管理中解脱出来，专注于对程序逻辑的编写

mysql服务端软件即mysqld帮我们管理好文件夹以及文件，前提是作为使用者的我们，需要下载mysql的客户端，或者其他模块来连接到mysqld，然后使用mysql软件规定的语法格式去提交自己命令，实现对文件夹或文件的管理。该语法即sql（Structured Query Language 即结构化查询语言）

```plain
SQL语言主要用于存取数据、查询数据、更新数据和管理关系数据库系统,SQL语言由IBM开发。SQL语言分为3种类型：
```

```plain
1、DDL语句    数据库定义语言： 数据库、表、视图、索引、存储过程，例如CREATE DROP ALTER
2、DML语句    数据库操纵语言： 插入数据INSERT、删除数据DELETE、更新数据UPDATE、查询数据SELECT
3、DCL语句    数据库控制语言： 例如控制用户的访问权限GRANT、REVOKE
```

```plain
#1. 操作文件夹
        增：create database db1 charset utf8;
        查：show databases;
        改：alter database db1 charset latin1;
        删除: drop database db1;
#2. 操作文件
    先切换到文件夹下：use db1
        增：create table t1(id int,name char);
        查：show tables
        改：alter table t1 modify name char(3);
              alter table t1 change name name1 char(2);
        删：drop table t1;
#3. 操作文件中的内容/记录
        增：insert into t1 values(1,'egon1'),(2,'egon2'),(3,'egon3');
        查：select * from t1;
        改：update t1 set name='sb' where id=2;
        删：delete from t1 where id=1;
```

## 8.2 库操作
## 8.2.1 库的增删改查
### 本节重点
+ 掌握概念库的增删改查

> **本节时长需控制在10分钟内**
>

### 一 系统数据库
information_schema： 虚拟库，不占用磁盘空间，存储的是数据库启动后的一些参数，如用户表信息、列信息、权限信息、字符信息等

performance_schema： MySQL 5.5开始新增一个数据库：主要用于收集数据库服务器性能参数，记录处理查询请求时发生的各种事件、锁等现象

mysql： 授权库，主要存储系统用户的权限信息

test： MySQL数据库系统自动创建的测试数据库

### 二 创建数据库
1 语法(help create database)

```plain
CREATE DATABASE 数据库名 charset utf8;
```

2 数据库命名规则：

```plain
可以由字母、数字、下划线、＠、＃、＄
区分大小写
唯一性
不能使用关键字如 create select
不能单独使用数字
最长128位
```

### 三 数据库相关操作
```plain
查看数据库
show databases;
show create database db1;
select database();
选择数据库
USE 数据库名
删除数据库
DROP DATABASE 数据库名;
修改数据库
alter database db1 charset utf8;
```

# 8.3 表操作
## 8.3.1 存储引擎介绍
### 本节重点
+ 了解存储引擎

> **本节时长需控制在10分钟内**
>

### 一 什么是存储引擎
mysql中建立的库===>文件夹

库中建立的表===>文件

现实生活中我们用来存储数据的文件有不同的类型，每种文件类型对应各自不同的处理机制：比如处理文本用txt类型，处理表格用excel，处理图片用png等

数据库中的表也应该有不同的类型，表的类型不同，会对应mysql不同的存取机制，表类型又称为存储引擎。

存储引擎说白了就是如何存储数据、如何为存储的数据建立索引和如何更新、查询数据等技术的实现方

法。因为在关系数据库中数据的存储是以表的形式存储的，所以存储引擎也可以称为表类型（即存储和

操作此表的类型）

在Oracle 和SQL Server等数据库中只有一种存储引擎，所有数据存储管理机制都是一样的。而MySql

数据库提供了多种存储引擎。用户可以根据不同的需求为数据表选择不同的存储引擎，用户也可以根据

自己的需要编写自己的存储引擎

<!-- OCR_START -->
- 支持接口
- 标准 C 的 API, JDBC, ODBC, NET PHP, Pyth
- Per1,B
- by.YB
- MySQL Server
- 企业管理服务和工具
- 备份与恢复
- 验证与授权一线程一连楼限制一内存与缓存管理
- 连接池
- 安全
- 复制
- 群集
- 分区管理
- SQL接口
- 数据管理语言和数据
- 解析器
- 优化
- 访问路径
- 全局和具体引擎的
- 缓存和缓冲池
- 事例管理
- 定文语言、存储过程、
- 查询\事务
- 数据模板管理
- 视围、触发器、等等
- 对象优先级
- 统计
- 工作台
- 查询浏览
- 3
- 合并工具包
- 内存\索引和存储管理
- 可插式存储引擎
- MyISAM InnoDB Cluster Falcon Archive Federated Merge
- Memory
- Partner Community Custom
- 文件系统
- 新技术文件系统：网络文件系统
- Redo,Udo,DataIndex,Binary
- 文件和日志
- 存储区城网络和网络附加存储
- Error,Qury,andSlw
<!-- OCR_END -->

SQL 解析器、SQL 优化器、缓冲池、存储引擎等组件在每个数据库中都存在,但不是每 个数据库都有这么多存储引擎。MySQL 的插件式存储引擎可以让存储引擎层的开发人员设 计他们希望的存储层,例如,有的应用需要满足事务的要求,有的应用则不需要对事务有这 么强的要求 ;有的希望数据能持久存储,有的只希望放在内存中,临时并快速地提供对数据 的查询。

### 二 mysql支持的存储引擎
```plain
MariaDB [(none)]> show engines\G  #查看所有支持的存储引擎
MariaDB [(none)]> show variables like 'storage_engine%'; #查看正在使用的存储引擎
```

**1、InnoDB 存储引擎**

支持事务,其设计目标主要面向联机事务处理(OLTP)的应用。其

特点是行锁设计、支持外键,并支持类似 Oracle 的非锁定读,即默认读取操作不会产生锁。 从 MySQL 5.5.8 版本开始是默认的存储引擎。

InnoDB 存储引擎将数据放在一个逻辑的表空间中,这个表空间就像黑盒一样由 InnoDB 存储引擎自身来管理。从 MySQL 4.1(包括 4.1)版本开始,可以将每个 InnoDB 存储引擎的 表单独存放到一个独立的 ibd 文件中。此外,InnoDB 存储引擎支持将裸设备(row disk)用 于建立其表空间。

InnoDB 通过使用多版本并发控制(MVCC)来获得高并发性,并且实现了 SQL 标准 的 4 种隔离级别,默认为 REPEATABLE 级别,同时使用一种称为 netx-key locking 的策略来 避免幻读(phantom)现象的产生。除此之外,InnoDB 存储引擎还提供了插入缓冲(insert buffer)、二次写(double write)、自适应哈希索引(adaptive hash index)、预读(read ahead) 等高性能和高可用的功能。

对于表中数据的存储,InnoDB 存储引擎采用了聚集(clustered)的方式,每张表都是按 主键的顺序进行存储的,如果没有显式地在表定义时指定主键,InnoDB 存储引擎会为每一 行生成一个 6 字节的 ROWID,并以此作为主键。

InnoDB 存储引擎是 MySQL 数据库最为常用的一种引擎,Facebook、Google、Yahoo 等 公司的成功应用已经证明了 InnoDB 存储引擎具备高可用性、高性能以及高可扩展性。对其 底层实现的掌握和理解也需要时间和技术的积累。如果想深入了解 InnoDB 存储引擎的工作 原理、实现和应用,可以参考《MySQL 技术内幕:InnoDB 存储引擎》一书。

**2、MyISAM 存储引擎**

不支持事务、表锁设计、支持全文索引,主要面向一些 OLAP 数 据库应用,在 MySQL 5.5.8 版本之前是默认的存储引擎(除 Windows 版本外)。数据库系统 与文件系统一个很大的不同在于对事务的支持,MyISAM 存储引擎是不支持事务的。究其根 本,这也并不难理解。用户在所有的应用中是否都需要事务呢?在数据仓库中,如果没有 ETL 这些操作,只是简单地通过报表查询还需要事务的支持吗?此外,MyISAM 存储引擎的 另一个与众不同的地方是,它的缓冲池只缓存(cache)索引文件,而不缓存数据文件,这与 大多数的数据库都不相同。

**3、NDB 存储引擎**

年,MySQL AB 公司从 Sony Ericsson 公司收购了 NDB 存储引擎。 NDB 存储引擎是一个集群存储引擎,类似于 Oracle 的 RAC 集群,不过与 Oracle RAC 的 share everything 结构不同的是,其结构是 share nothing 的集群架构,因此能提供更高级别的 高可用性。NDB 存储引擎的特点是数据全部放在内存中(从 5.1 版本开始,可以将非索引数 据放在磁盘上),因此主键查找(primary key lookups)的速度极快,并且能够在线添加 NDB 数据存储节点(data node)以便线性地提高数据库性能。由此可见,NDB 存储引擎是高可用、 高性能、高可扩展性的数据库集群系统,其面向的也是 OLTP 的数据库应用类型。

**4、Memory 存储引擎**

正如其名,Memory 存储引擎中的数据都存放在内存中,数据库重 启或发生崩溃,表中的数据都将消失。它非常适合于存储 OLTP 数据库应用中临时数据的临时表,也可以作为 OLAP 数据库应用中数据仓库的维度表。Memory 存储引擎默认使用哈希 索引,而不是通常熟悉的 B+ 树索引。

**5、Infobright 存储引擎**

第三方的存储引擎。其特点是存储是按照列而非行的,因此非常 适合 OLAP 的数据库应用。其官方网站是 [http://www.infobright.org/,上面有不少成功的数据](http://www.infobright.org/,%E4%B8%8A%E9%9D%A2%E6%9C%89%E4%B8%8D%E5%B0%91%E6%88%90%E5%8A%9F%E7%9A%84%E6%95%B0%E6%8D%AE) 仓库案例可供分析。

**6、NTSE 存储引擎**

网易公司开发的面向其内部使用的存储引擎。目前的版本不支持事务, 但提供压缩、行级缓存等特性,不久的将来会实现面向内存的事务支持。

**7、BLACKHOLE**

黑洞存储引擎，可以应用于主备复制中的分发主库。

MySQL 数据库还有很多其他存储引擎,上述只是列举了最为常用的一些引擎。如果 你喜欢,完全可以编写专属于自己的引擎,这就是开源赋予我们的能力,也是开源的魅 力所在。

### 三 使用存储引擎
方法1：建表时指定

```plain
MariaDB [db1]> create table innodb_t1(id int,name char)engine=innodb;
MariaDB [db1]> create table innodb_t2(id int)engine=innodb;
MariaDB [db1]> show create table innodb_t1;
MariaDB [db1]> show create table innodb_t2;
```

方法2：在配置文件中指定默认的存储引擎

```plain
/etc/my.cnf
[mysqld]
default-storage-engine=INNODB
innodb_file_per_table=1
```

查看

```plain
[root@egon db1]# cd /var/lib/mysql/db1/
[root@egon db1]# ls
db.opt  innodb_t1.frm  innodb_t1.ibd  innodb_t2.frm  innodb_t2.ibd
```

练习

创建四个表，分别使用innodb，myisam，memory，blackhole存储引擎，进行插入数据测试

```plain
MariaDB [db1]> create table t1(id int)engine=innodb;
MariaDB [db1]> create table t2(id int)engine=myisam;
MariaDB [db1]> create table t3(id int)engine=memory;
MariaDB [db1]> create table t4(id int)engine=blackhole;
MariaDB [db1]> quit
[root@egon db1]# ls /var/lib/mysql/db1/ #发现后两种存储引擎只有表结构，无数据
db.opt  t1.frm  t1.ibd  t2.MYD  t2.MYI  t2.frm  t3.frm  t4.frm
#memory，在重启mysql或者重启机器后，表内数据清空
#blackhole，往表内插入任何数据，都相当于丢入黑洞，表内永远不存记录
```

## 8.3.2 表的增删改查
### 本节重点
+ 掌握表的增删改查

> **本节时长需控制在15分钟内**
>

### 一、表介绍
表相当于文件，表中的一条记录就相当于文件的一行内容，不同的是，表中的一条记录有对应的标题，称为表的字段

<!-- OCR_START -->
| id | 排名 |
| --- | --- |
| sex | 1 |
| egon | 18 |
| male | 2 |
| alex | 73 |
| female | 3 |
| wu | 84 |
| male | 4 |
| yh | 63 |
<!-- OCR_END -->

id，name，qq，age称为字段，其余的，一行内容称为一条记录

### 二、创建表
语法

```plain
create table 表名(
字段名1 类型[(宽度) 约束条件],
字段名2 类型[(宽度) 约束条件],
字段名3 类型[(宽度) 约束条件]
);
#注意：
1. 在同一张表中，字段名是不能相同
2. 宽度和约束条件可选
3. 字段名和类型是必须的
```

示范

```plain
MariaDB [(none)]> create database db1 charset utf8;
MariaDB [(none)]> use db1;
MariaDB [db1]> create table t1(  
    -> id int, 
    -> name varchar(50),
    -> sex enum('male','female'),
    -> age int(3)
    -> );
MariaDB [db1]> show tables; #查看db1库下所有表名
MariaDB [db1]> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
MariaDB [db1]> select id,name,sex,age from t1;
Empty set (0.00 sec)
MariaDB [db1]> select * from t1;
Empty set (0.00 sec)
MariaDB [db1]> select id,name from t1;
Empty set (0.00 sec)
```

往表中插入数据

```plain
MariaDB [db1]> insert into t1 values
    -> (1,'egon',18,'male'),
    -> (2,'alex',81,'female')
    -> ;
MariaDB [db1]> select * from t1;
+------+------+------+--------+
| id   | name | age  | sex    |
+------+------+------+--------+
|    1 | egon |   18 | male   |
|    2 | alex |   81 | female |
+------+------+------+--------+
MariaDB [db1]> insert into t1(id) values 
    -> (3),
    -> (4);
MariaDB [db1]> select * from t1;
+------+------+------+--------+
| id   | name | age  | sex    |
+------+------+------+--------+
|    1 | egon |   18 | male   |
|    2 | alex |   81 | female |
|    3 | NULL | NULL | NULL   |
|    4 | NULL | NULL | NULL   |
+------+------+------+--------+
```

**注意注意注意：表中的最后一个字段不要加逗号**

### 三、查看表结构
```plain
MariaDB [db1]> describe t1; #查看表结构，可简写为desc 表名
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
MariaDB [db1]> show create table t1\G; #查看表详细结构，可加\G
```

### 四、修改表结构
```plain
语法：
1. 修改表名
      ALTER TABLE 表名 
                          RENAME 新表名;
2. 增加字段
      ALTER TABLE 表名
                          ADD 字段名  数据类型 [完整性约束条件…],
                          ADD 字段名  数据类型 [完整性约束条件…];
      ALTER TABLE 表名
                          ADD 字段名  数据类型 [完整性约束条件…]  FIRST;
      ALTER TABLE 表名
                          ADD 字段名  数据类型 [完整性约束条件…]  AFTER 字段名;
3. 删除字段
      ALTER TABLE 表名 
                          DROP 字段名;
4. 修改字段
      ALTER TABLE 表名 
                          MODIFY  字段名 数据类型 [完整性约束条件…];
      ALTER TABLE 表名 
                          CHANGE 旧字段名 新字段名 旧数据类型 [完整性约束条件…];
      ALTER TABLE 表名 
                          CHANGE 旧字段名 新字段名 新数据类型 [完整性约束条件…];
```

示范

```plain
示例：
1. 修改存储引擎
mysql> alter table service 
    -> engine=innodb;
2. 添加字段
mysql> alter table student10
    -> add name varchar(20) not null,
    -> add age int(3) not null default 22;
mysql> alter table student10
    -> add stu_num varchar(10) not null after name;                //添加name字段之后
mysql> alter table student10                        
    -> add sex enum('male','female') default 'male' first;          //添加到最前面
3. 删除字段
mysql> alter table student10
    -> drop sex;
mysql> alter table service
    -> drop mac;
4. 修改字段类型modify
mysql> alter table student10
    -> modify age int(3);
mysql> alter table student10
    -> modify id int(11) not null primary key auto_increment;    //修改为主键
5. 增加约束（针对已有的主键增加auto_increment）
mysql> alter table student10 modify id int(11) not null primary key auto_increment;
ERROR 1068 (42000): Multiple primary key defined
mysql> alter table student10 modify id int(11) not null auto_increment;
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0
6. 对已经存在的表增加复合主键
mysql> alter table service2
    -> add primary key(host_ip,port);        
7. 增加主键
mysql> alter table student1
    -> modify name varchar(10) not null primary key;
8. 增加主键和自动增长
mysql> alter table student1
    -> modify id int not null primary key auto_increment;
9. 删除主键
a. 删除自增约束
mysql> alter table student10 modify id int(11) not null; 
b. 删除主键
mysql> alter table student10                                 
    -> drop primary key;
```

### 五、复制表
```plain
复制表结构＋记录 （key不会复制: 主键、外键和索引）
mysql> create table new_service select * from service;
只复制表结构
mysql> select * from service where 1=2;        //条件为假，查不到任何记录
Empty set (0.00 sec)
mysql> create table new1_service select * from service where 1=2;  
Query OK, 0 rows affected (0.00 sec)
Records: 0  Duplicates: 0  Warnings: 0
mysql> create table t4 like employees;
```

### 六、删除表
```plain
DROP TABLE 表名;
```

## 8.3.3 数据类型
### 本节重点
+ 掌握数据类型

> **本节时长需控制在5分钟内**
>

### 介绍
存储引擎决定了表的类型，而表内存放的数据也要有不同的类型，每种数据类型都有自己的宽度，但宽度是可选的

详细参考：

+ [http://www.runoob.com/mysql/mysql-data-types.html](http://www.runoob.com/mysql/mysql-data-types.html)
+ [http://dev.mysql.com/doc/refman/5.7/en/data-type-overview.html](http://dev.mysql.com/doc/refman/5.7/en/data-type-overview.html)

mysql常用数据类型概览

```plain
#1. 数字：
    整型：tinyinit  int  bigint
    小数：
        float ：在位数比较短的情况下不精准
        double ：在位数比较长的情况下不精准
            0.000001230123123123
            存成：0.000001230000
        decimal：（如果用小数，则用推荐使用decimal）
            精准
            内部原理是以字符串形式去存
#2. 字符串：
    char（10）：简单粗暴，浪费空间，存取速度快
        root存成root000000
    varchar：精准，节省空间，存取速度慢
    sql优化：创建表时，定长的类型往前放，变长的往后放
                    比如性别           比如地址或描述信息
    >255个字符，超了就把文件路径存放到数据库中。
            比如图片，视频等找一个文件服务器，数据库中只存路径或url。
#3. 时间类型：
    最常用：datetime
#4. 枚举类型与集合类型
```

### 1 数值类型
+ 掌握整型
+ 掌握浮点型

> **本节时长需控制在15分钟内**
>

**1、整数类型**

整数类型：TINYINT SMALLINT MEDIUMINT INT BIGINT

作用：存储年龄，等级，id，各种号码等

```plain
========================================
        tinyint[(m)] [unsigned] [zerofill]

            小整数，数据类型用于保存一些范围的整数数值范围：
            有符号：
                -128 ～ 127
            无符号：
                0 ～ 255

            PS： MySQL中无布尔值，使用tinyint(1)构造。

========================================
        int[(m)][unsigned][zerofill]

            整数，数据类型用于保存一些范围的整数数值范围：
            有符号：
                    -2147483648 ～ 2147483647
            无符号：
                    0 ～ 4294967295

========================================
        bigint[(m)][unsigned][zerofill]
            大整数，数据类型用于保存一些范围的整数数值范围：
            有符号：
                    -9223372036854775808 ～ 9223372036854775807
            无符号：
                    0  ～  18446744073709551615
```

验证

```plain
=========有符号和无符号tinyint==========
#tinyint默认为有符号
MariaDB [db1]> create table t1(x tinyint); #默认为有符号，即数字前有正负号
MariaDB [db1]> desc t1;
MariaDB [db1]> insert into t1 values
    -> (-129),
    -> (-128),
    -> (127),
    -> (128);
MariaDB [db1]> select * from t1;
+------+
| x    |
+------+
| -128 | #-129存成了-128
| -128 | #有符号，最小值为-128
|  127 | #有符号，最大值127
|  127 | #128存成了127
+------+

#设置无符号tinyint
MariaDB [db1]> create table t2(x tinyint unsigned);
MariaDB [db1]> insert into t2 values
    -> (-1),
    -> (0),
    -> (255),
    -> (256);
MariaDB [db1]> select * from t2;
+------+
| x    |
+------+
|    0 | -1存成了0
|    0 | #无符号，最小值为0
|  255 | #无符号，最大值为255
|  255 | #256存成了255
+------+

============有符号和无符号int=============
#int默认为有符号
MariaDB [db1]> create table t3(x int); #默认为有符号整数
MariaDB [db1]> insert into t3 values
    -> (-2147483649),
    -> (-2147483648),
    -> (2147483647),
    -> (2147483648);
MariaDB [db1]> select * from t3;
+-------------+
| x           |
+-------------+
| -2147483648 | #-2147483649存成了-2147483648
| -2147483648 | #有符号，最小值为-2147483648
|  2147483647 | #有符号，最大值为2147483647
|  2147483647 | #2147483648存成了2147483647
+-------------+

#设置无符号int
MariaDB [db1]> create table t4(x int unsigned);
MariaDB [db1]> insert into t4 values
    -> (-1),
    -> (0),
    -> (4294967295),
    -> (4294967296);
MariaDB [db1]> select * from t4;
+------------+
| x          |
+------------+
|          0 | #-1存成了0
|          0 | #无符号，最小值为0
| 4294967295 | #无符号，最大值为4294967295
| 4294967295 | #4294967296存成了4294967295
+------------+

==============有符号和无符号bigint=============
MariaDB [db1]> create table t6(x bigint);
MariaDB [db1]> insert into t5 values  
    -> (-9223372036854775809),
    -> (-9223372036854775808),
    -> (9223372036854775807),
    -> (9223372036854775808);

MariaDB [db1]> select * from t5;
+----------------------+
| x                    |
+----------------------+
| -9223372036854775808 |
| -9223372036854775808 |
|  9223372036854775807 |
|  9223372036854775807 |
+----------------------+

MariaDB [db1]> create table t6(x bigint unsigned);
MariaDB [db1]> insert into t6 values  
    -> (-1),
    -> (0),
    -> (18446744073709551615),
    -> (18446744073709551616);

MariaDB [db1]> select * from t6;
+----------------------+
| x                    |
+----------------------+
|                    0 |
|                    0 |
| 18446744073709551615 |
| 18446744073709551615 |
+----------------------+

======用zerofill测试整数类型的显示宽度=============
MariaDB [db1]> create table t7(x int(3) zerofill);
MariaDB [db1]> insert into t7 values
    -> (1),
    -> (11),
    -> (111),
    -> (1111);
MariaDB [db1]> select * from t7;
+------+
| x    |
+------+
|  001 |
|  011 |
|  111 |
| 1111 | #超过宽度限制仍然可以存
+------+
```

注意：为该类型指定宽度时，仅仅只是指定查询结果的显示宽度，与存储范围无关，存储范围如下

其实我们完全没必要为整数类型指定显示宽度，使用默认的就可以了

默认的显示宽度，都是在最大值的基础上加1

<!-- OCR_START -->
- 类型
- 大小
- 范围（有符号）
- 范围（无符号）
- 用途
- TINYINT
- 1字节
- (-128, 127)
- (0，255)
- 小整数值
- SMALLINT
- 2字节
- (-32768,32 767)
- (0， 65 535)
- 大整数值
- MEDIUMINT
- 3字节
- (-8 388 608, 8 388 607)
- (0， 16 777 215)
- INT或
- 4字节
- (-2 147 483 648, 2 147 483 647)
- (0,4294 967 295)
- INTEGER
- BIGINT
- 8字节
- (-9 233372036854 775808,9
- (0, 18 446 744 073 709 551 615)
- 极大整数值
- 223 372 036 854 775 807)
- FLOAT
- (-3.402 823 466 E+38,-1.175 494
- 0,(1.175 494 351 E-38,3.402
- 单精度
- 351E-38), 0,(1.175 494 351E-
- 823 466 E+38)
- 浮点数值
- 38,3.402 823 466 351E+38)
- DOUBLE
- (-1.797 693 134 862 315 7
- 0, (2.225 073 858 507 201 4 E-
- 双精度
- E+308, -2.225 073 858 507 201 4
- 308, 1.797 693 134 862 315 7
- E-308),0,(2.225 073 858 507
- E+308)
- 201 4E-308, 1.797 693 134 862
- 315 7 E+308)
- DECIMAL
- 依赖于M和D的值
- 小数值
- DECIMAL(M,D)
- ，如果M>D，为
- M+2否则为D+2
<!-- OCR_END -->

int的存储宽度是4个Bytes，即32个bit，即2**32

无符号最大值为：4294967296-1

有符号最大值：2147483648-1

有符号和无符号的最大数字需要的显示宽度均为10，而针对有符号的最小值则需要11位才能显示完全，所以int类型默认的显示宽度为11是非常合理的

最后：整形类型，其实没有必要指定显示宽度，使用默认的就ok

**2、浮点型**

定点数类型 DEC等同于DECIMAL

浮点类型：FLOAT DOUBLE

作用：存储薪资、身高、体重、体质参数等

```plain
======================================
#FLOAT[(M,D)] [UNSIGNED] [ZEROFILL]

定义：
        单精度浮点数（非准确小数值），m是数字总个数，d是小数点后个数。m最大值为255，d最大值为30

有符号：
           -3.402823466E+38 to -1.175494351E-38,
           1.175494351E-38 to 3.402823466E+38
无符号：
           1.175494351E-38 to 3.402823466E+38

精确度： 
           **** 随着小数的增多，精度变得不准确 ****

======================================
#DOUBLE[(M,D)] [UNSIGNED] [ZEROFILL]

定义：
           双精度浮点数（非准确小数值），m是数字总个数，d是小数点后个数。m最大值为255，d最大值为30

有符号：
           -1.7976931348623157E+308 to -2.2250738585072014E-308
           2.2250738585072014E-308 to 1.7976931348623157E+308

无符号：
           2.2250738585072014E-308 to 1.7976931348623157E+308

精确度：
           ****随着小数的增多，精度比float要高，但也会变得不准确 ****

======================================
decimal[(m[,d])] [unsigned] [zerofill]

定义：
          准确的小数值，m是数字总个数（负号不算），d是小数点后个数。 m最大值为65，d最大值为30。

精确度：
           **** 随着小数的增多，精度始终准确 ****
           对于精确数值计算时需要用此类型
           decaimal能够存储精确值的原因在于其内部按照字符串存储。
```

验证

```plain
mysql> create table t1(x float(256,31));
ERROR 1425 (42000): Too big scale 31 specified for column 'x'. Maximum is 30.
mysql> create table t1(x float(256,30));
ERROR 1439 (42000): Display width out of range for column 'x' (max = 255)
mysql> create table t1(x float(255,30)); #建表成功
Query OK, 0 rows affected (0.02 sec)

mysql> create table t2(x double(255,30)); #建表成功
Query OK, 0 rows affected (0.02 sec)

mysql> create table t3(x decimal(66,31));
ERROR 1425 (42000): Too big scale 31 specified for column 'x'. Maximum is 30.
mysql> create table t3(x decimal(66,30));
ERROR 1426 (42000): Too-big precision 66 specified for 'x'. Maximum is 65.
mysql> create table t3(x decimal(65,30)); #建表成功
Query OK, 0 rows affected (0.02 sec)

mysql> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| t1            |
| t2            |
| t3            |
+---------------+
rows in set (0.00 sec)

mysql> insert into t1 values(1.1111111111111111111111111111111); #小数点后31个1
Query OK, 1 row affected (0.01 sec)

mysql> insert into t2 values(1.1111111111111111111111111111111);
Query OK, 1 row affected (0.00 sec)

mysql> insert into t3 values(1.1111111111111111111111111111111);
Query OK, 1 row affected, 1 warning (0.01 sec)

mysql> select * from t1; #随着小数的增多，精度开始不准确
+----------------------------------+
| x                                |
+----------------------------------+
| 1.111111164093017600000000000000 |
+----------------------------------+
row in set (0.00 sec)

mysql> select * from t2; #精度比float要准确点，但随着小数的增多，同样变得不准确
+----------------------------------+
| x                                |
+----------------------------------+
| 1.111111111111111200000000000000 |
+----------------------------------+
row in set (0.00 sec)

mysql> select * from t3; #精度始终准确,d为30，于是只留了30位小数
+----------------------------------+
| x                                |
+----------------------------------+
| 1.111111111111111111111111111111 |
+----------------------------------+
row in set (0.00 sec)
```

### 2 日期类型

**DATE TIME DATETIME TIMESTAMP YEAR**

**作用：存储用户注册时间，文章发布时间，员工入职时间，出生时间，过期时间等**

```plain
        YEAR
            YYYY（1901/2155）

        DATE
            YYYY-MM-DD（1000-01-01/9999-12-31）

        TIME
            HH:MM:SS（'-838:59:59'/'838:59:59'）

        DATETIME

            YYYY-MM-DD HH:MM:SS（1000-01-01 00:00:00/9999-12-31 23:59:59    Y）

        TIMESTAMP

            YYYYMMDD HHMMSS（1970-01-01 00:00:00/2037 年某时）
```

**验证**

```plain
============year===========
MariaDB [db1]> create table t10(born_year year); #无论year指定何种宽度，最后都默认是year(4)
MariaDB [db1]> insert into t10 values  
    -> (1900),
    -> (1901),
    -> (2155),
    -> (2156);
MariaDB [db1]> select * from t10;
+-----------+
| born_year |
+-----------+
|      0000 |
|      1901 |
|      2155 |
|      0000 |
+-----------+

============date,time,datetime===========
MariaDB [db1]> create table t11(d date,t time,dt datetime);
MariaDB [db1]> desc t11;
+-------+----------+------+-----+---------+-------+
| Field | Type     | Null | Key | Default | Extra |
+-------+----------+------+-----+---------+-------+
| d     | date     | YES  |     | NULL    |       |
| t     | time     | YES  |     | NULL    |       |
| dt    | datetime | YES  |     | NULL    |       |
+-------+----------+------+-----+---------+-------+

MariaDB [db1]> insert into t11 values(now(),now(),now());
MariaDB [db1]> select * from t11;
+------------+----------+---------------------+
| d          | t        | dt                  |
+------------+----------+---------------------+
| 2017-07-25 | 16:26:54 | 2017-07-25 16:26:54 |
+------------+----------+---------------------+

============timestamp===========
MariaDB [db1]> create table t12(time timestamp);
MariaDB [db1]> insert into t12 values();
MariaDB [db1]> insert into t12 values(null);
MariaDB [db1]> select * from t12;
+---------------------+
| time                |
+---------------------+
| 2017-07-25 16:29:17 |
| 2017-07-25 16:30:01 |
+---------------------+

============注意啦，注意啦，注意啦===========
1. 单独插入时间时，需要以字符串的形式，按照对应的格式插入
2. 插入年份时，尽量使用4位值
3. 插入两位年份时，<=69，以20开头，比如50,  结果2050      
                >=70，以19开头，比如71，结果1971
MariaDB [db1]> create table t12(y year);
MariaDB [db1]> insert into t12 values  
    -> (50),
    -> (71);
MariaDB [db1]> select * from t12;
+------+
| y    |
+------+
| 2050 |
| 1971 |
+------+

============综合练习===========
MariaDB [db1]> create table student(
    -> id int,
    -> name varchar(20),
    -> born_year year,
    -> birth date,
    -> class_time time,
    -> reg_time datetime);

MariaDB [db1]> insert into student values
    -> (1,'alex',"1995","1995-11-11","11:11:11","2017-11-11 11:11:11"),
    -> (2,'egon',"1997","1997-12-12","12:12:12","2017-12-12 12:12:12"),
    -> (3,'wsb',"1998","1998-01-01","13:13:13","2017-01-01 13:13:13");

MariaDB [db1]> select * from student;
+------+------+-----------+------------+------------+---------------------+
| id   | name | born_year | birth      | class_time | reg_time            |
+------+------+-----------+------------+------------+---------------------+
|    1 | alex |      1995 | 1995-11-11 | 11:11:11   | 2017-11-11 11:11:11 |
|    2 | egon |      1997 | 1997-12-12 | 12:12:12   | 2017-12-12 12:12:12 |
|    3 | wsb  |      1998 | 1998-01-01 | 13:13:13   | 2017-01-01 13:13:13 |
+------+------+-----------+------------+------------+---------------------+
```

**datetime与timestamp的区别**

```plain
在实际应用的很多场景中，MySQL的这两种日期类型都能够满足我们的需要，存储精度都为秒，但在某些情况下，会展现出他们各自的优劣。
下面就来总结一下两种日期类型的区别。

1.DATETIME的日期范围是1001——9999年，TIMESTAMP的时间范围是1970——2038年。

2.DATETIME存储时间与时区无关，TIMESTAMP存储时间与时区有关，显示的值也依赖于时区。在mysql服务器，
操作系统以及客户端连接都有时区的设置。

3.DATETIME使用8字节的存储空间，TIMESTAMP的存储空间为4字节。因此，TIMESTAMP比DATETIME的空间利用率更高。

4.DATETIME的默认值为null；TIMESTAMP的字段默认不为空（not null）,默认值为当前时间（CURRENT_TIMESTAMP），
如果不做特殊处理，并且update语句中没有指定该列的更新值，则默认更新为当前时间。
```

+ 掌握char类型与varchar类型

> **本节时长需控制在15分钟内**
>

### 3 字符类型

```plain
#官网：https://dev.mysql.com/doc/refman/5.7/en/char.html
#注意：char和varchar括号内的参数指的都是字符的长度

#char类型：定长，简单粗暴，浪费空间，存取速度快
    字符长度范围：0-255（一个中文是一个字符，是utf8编码的3个字节）
    存储：
        存储char类型的值时，会往右填充空格来满足长度
        例如：指定长度为10，存>10个字符则报错，存<10个字符则用空格填充直到凑够10个字符存储

    检索：
        在检索或者说查询时，查出的结果会自动删除尾部的空格，除非我们打开pad_char_to_full_length SQL模式（SET sql_mode = 'PAD_CHAR_TO_FULL_LENGTH';）

#varchar类型：变长，精准，节省空间，存取速度慢
    字符长度范围：0-65535（如果大于21845会提示用其他类型 。mysql行最大限制为65535字节，字符编码为utf-8：https://dev.mysql.com/doc/refman/5.7/en/column-count-limit.html）
    存储：
        varchar类型存储数据的真实内容，不会用空格填充，如果'ab  ',尾部的空格也会被存起来
        强调：varchar类型会在真实数据前加1-2Bytes的前缀，该前缀用来表示真实数据的bytes字节数（1-2Bytes最大表示65535个数字，正好符合mysql对row的最大字节限制，即已经足够使用）
        如果真实的数据<255bytes则需要1Bytes的前缀（1Bytes=8bit 2**8最大表示的数字为255）
        如果真实的数据>255bytes则需要2Bytes的前缀（2Bytes=16bit 2**16最大表示的数字为65535）

    检索：
        尾部有空格会保存下来，在检索或者说查询时，也会正常显示包含空格在内的内容
```

官网解释如下

<!-- OCR_START -->
- Value
- CHAR(4)
- StorageRequired
- VARCHAR(4)
- 4 bytes
- 1 byte
- 'ab'
- 3bytes
- 'abcd'
- 5bytes
- abcdefgh
<!-- OCR_END -->

测试前了解两个函数

```plain
length：查看字节数
char_length:查看字符数
```

**1. char填充空格来满足固定长度，但是在查询时却会很不要脸地删除尾部的空格（装作自己好像没有浪费过空间一样），然后修改sql_mode让其现出原形**

```plain
mysql> create table t1(x char(5),y varchar(5));
Query OK, 0 rows affected (0.26 sec)

#char存5个字符，而varchar存4个字符
mysql> insert into t1 values('你瞅啥 ','你瞅啥 ');
Query OK, 1 row affected (0.05 sec)

mysql> SET sql_mode='';
Query OK, 0 rows affected, 1 warning (0.00 sec)

#在检索时char很不要脸地将自己浪费的2个字符给删掉了，装的好像自己没浪费过空间一样，而varchar很老实，存了多少，就显示多少
mysql> select x,char_length(x),y,char_length(y) from t1; 
+-----------+----------------+------------+----------------+
| x         | char_length(x) | y          | char_length(y) |
+-----------+----------------+------------+----------------+
| 你瞅啥    |              3 | 你瞅啥     |              4 |
+-----------+----------------+------------+----------------+
row in set (0.00 sec)

#略施小计，让char现出原形
mysql> SET sql_mode = 'PAD_CHAR_TO_FULL_LENGTH';
Query OK, 0 rows affected (0.00 sec)

#这下子char原形毕露了......
mysql> select x,char_length(x),y,char_length(y) from t1;
+-------------+----------------+------------+----------------+
| x           | char_length(x) | y          | char_length(y) |
+-------------+----------------+------------+----------------+
| 你瞅啥      |              5 | 你瞅啥     |              4 |
+-------------+----------------+------------+----------------+
row in set (0.00 sec)

#char类型：3个中文字符+2个空格=11Bytes
#varchar类型:3个中文字符+1个空格=10Bytes
mysql> select x,length(x),y,length(y) from t1;
+-------------+-----------+------------+-----------+
| x           | length(x) | y          | length(y) |
+-------------+-----------+------------+-----------+
| 你瞅啥      |        11 | 你瞅啥     |        10 |
+-------------+-----------+------------+-----------+
row in set (0.00 sec)
```

**2. 虽然 CHAR 和 VARCHAR 的存储方式不太相同,但是对于两个字符串的比较,都只比 较其值,忽略 CHAR 值存在的右填充,即使将 SQL **_**MODE 设置为 PAD_CHAR_TO_FULL**_** LENGTH 也一样,,但这不适用于like**

```plain
Values in CHAR and VARCHAR columns are sorted and compared according to the character set collation assigned to the column.

All MySQL collations are of type PAD SPACE. This means that all CHAR, VARCHAR, and TEXT values are compared without regard to any trailing spaces. “Comparison” in this context does not include the LIKE pattern-matching operator, for which trailing spaces are significant. For example:

mysql> CREATE TABLE names (myname CHAR(10));
Query OK, 0 rows affected (0.03 sec)

mysql> INSERT INTO names VALUES ('Monty');
Query OK, 1 row affected (0.00 sec)

mysql> SELECT myname = 'Monty', myname = 'Monty  ' FROM names;
+------------------+--------------------+
| myname = 'Monty' | myname = 'Monty  ' |
+------------------+--------------------+
|                1 |                  1 |
+------------------+--------------------+
row in set (0.00 sec)

mysql> SELECT myname LIKE 'Monty', myname LIKE 'Monty  ' FROM names;
+---------------------+-----------------------+
| myname LIKE 'Monty' | myname LIKE 'Monty  ' |
+---------------------+-----------------------+
|                   1 |                     0 |
+---------------------+-----------------------+
row in set (0.00 sec)
```

**3. 总结**

```plain
#常用字符串系列：char与varchar
注：虽然varchar使用起来较为灵活，但是从整个系统的性能角度来说，char数据类型的处理速度更快，有时甚至可以超出varchar处理速度的50%。因此，用户在设计数据库时应当综合考虑各方面的因素，以求达到最佳的平衡

#其他字符串系列（效率：char>varchar>text）
TEXT系列 TINYTEXT TEXT MEDIUMTEXT LONGTEXT
BLOB 系列    TINYBLOB BLOB MEDIUMBLOB LONGBLOB 
BINARY系列 BINARY VARBINARY

text：text数据类型用于保存变长的大字符串，可以组多到65535 (2**16 − 1)个字符。
mediumtext：A TEXT column with a maximum length of 16,777,215 (2**24 − 1) characters.
longtext：A TEXT column with a maximum length of 4,294,967,295 or 4GB (2**32 − 1) characters.
```

### 4 枚举类型与集合类型

字段的值只能在给定范围中选择，如单选框，多选框

enum 单选 只能在给定的范围内选一个值，如性别 sex 男male/女female

set 多选 在给定的范围内可以选择一个或一个以上的值（爱好1,爱好2,爱好3...）

```plain
MariaDB [db1]> create table consumer( 
    -> name varchar(50),
    -> sex enum('male','female'),
    -> level enum('vip1','vip2','vip3','vip4','vip5'), #在指定范围内，多选一
    -> hobby set('play','music','read','study') #在指定范围内，多选多
    -> );

MariaDB [db1]> insert into consumer values  
    -> ('egon','male','vip5','read,study'),
    -> ('alex','female','vip1','girl');

MariaDB [db1]> select * from consumer;
+------+--------+-------+------------+
| name | sex    | level | hobby      |
+------+--------+-------+------------+
| egon | male   | vip5  | read,study |
| alex | female | vip1  |            |
+------+--------+-------+------------+
```

## 8.3.4 完整性约束
### 本节重点
+ [not null与default](http://www.cnblogs.com/linhaifeng/articles/7238814.html#_label2)
+ [unique](http://www.cnblogs.com/linhaifeng/articles/7238814.html#_label3)
+ [primary key](http://www.cnblogs.com/linhaifeng/articles/7238814.html#_label4)
+ [auto_increment](http://www.cnblogs.com/linhaifeng/articles/7238814.html#_label5)
+ [foreign key](http://www.cnblogs.com/linhaifeng/articles/7238814.html#_label6)

> **本节时长需控制在15分钟内**
>

### 一、介绍
约束条件与数据类型的宽度一样，都是可选参数

作用：用于保证数据的完整性和一致性

主要分为：

```plain
PRIMARY KEY (PK)    标识该字段为该表的主键，可以唯一的标识记录
FOREIGN KEY (FK)    标识该字段为该表的外键
NOT NULL    标识该字段不能为空
UNIQUE KEY (UK)    标识该字段的值是唯一的
AUTO_INCREMENT    标识该字段的值自动增长（整数类型，而且为主键）
DEFAULT    为该字段设置默认值
UNSIGNED 无符号
ZEROFILL 使用0填充
```

说明：

```plain
1. 是否允许为空，默认NULL，可设置NOT NULL，字段不允许为空，必须赋值
2. 字段是否有默认值，缺省的默认值是NULL，如果插入记录时不给字段赋值，此字段使用默认值
sex enum('male','female') not null default 'male'
age int unsigned NOT NULL default 20 必须为正值（无符号） 不允许为空 默认是20
3. 是否是key
主键 primary key
外键 foreign key
索引 (index,unique...)
```

### 二、not null与default
是否可空，null表示空，非字符串

not null - 不可空

null - 可空

默认值，创建列时可以指定默认值，当插入数据时如果未主动设置，则自动添加默认值

create table tb1(

nid int not null defalut 2,

num int not null

)

```plain
==================not null====================
mysql> create table t1(id int); #id字段默认可以插入空
mysql> desc t1;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | YES  |     | NULL    |       |
+-------+---------+------+-----+---------+-------+
mysql> insert into t1 values(); #可以插入空
mysql> create table t2(id int not null); #设置字段id不为空
mysql> desc t2;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | NO   |     | NULL    |       |
+-------+---------+------+-----+---------+-------+
mysql> insert into t2 values(); #不能插入空
ERROR 1364 (HY000): Field 'id' doesn't have a default value
==================default====================
#设置id字段有默认值后，则无论id字段是null还是not null，都可以插入空，插入空默认填入default指定的默认值
mysql> create table t3(id int default 1);
mysql> alter table t3 modify id int not null default 1;
==================综合练习====================
mysql> create table student(
    -> name varchar(20) not null,
    -> age int(3) unsigned not null default 18,
    -> sex enum('male','female') default 'male',
    -> hobby set('play','study','read','music') default 'play,music'
    -> );
mysql> desc student;
+-------+------------------------------------+------+-----+------------+-------+
| Field | Type                               | Null | Key | Default    | Extra |
+-------+------------------------------------+------+-----+------------+-------+
| name  | varchar(20)                        | NO   |     | NULL       |       |
| age   | int(3) unsigned                    | NO   |     | 18         |       |
| sex   | enum('male','female')              | YES  |     | male       |       |
| hobby | set('play','study','read','music') | YES  |     | play,music |       |
+-------+------------------------------------+------+-----+------------+-------+
mysql> insert into student(name) values('egon');
mysql> select * from student;
+------+-----+------+------------+
| name | age | sex  | hobby      |
+------+-----+------+------------+
| egon |  18 | male | play,music |
+------+-----+------+------------+
验证
```

### 三、 unique
```plain
============设置唯一约束 UNIQUE===============
方法一：
create table department1(
id int,
name varchar(20) unique,
comment varchar(100)
);
方法二：
create table department2(
id int,
name varchar(20),
comment varchar(100),
constraint uk_name unique(name)
);
mysql> insert into department1 values(1,'IT','技术');
Query OK, 1 row affected (0.00 sec)
mysql> insert into department1 values(1,'IT','技术');
ERROR 1062 (23000): Duplicate entry 'IT' for key 'name'
```

```plain
mysql> create table t1(id int not null unique);
Query OK, 0 rows affected (0.02 sec)
mysql> desc t1;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | NO   | PRI | NULL    |       |
+-------+---------+------+-----+---------+-------+
row in set (0.00 sec)
not null+unique的化学反应
```

```plain
create table service(
id int primary key auto_increment,
name varchar(20),
host varchar(15) not null,
port int not null,
unique(host,port) #联合唯一
);
mysql> insert into service values
    -> (1,'nginx','192.168.0.10',80),
    -> (2,'haproxy','192.168.0.20',80),
    -> (3,'mysql','192.168.0.30',3306)
    -> ;
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0
mysql> insert into service(name,host,port) values('nginx','192.168.0.10',80);
ERROR 1062 (23000): Duplicate entry '192.168.0.10-80' for key 'host'
联合唯一
```

### 四、 primary key
primary key字段的值不为空且唯一

一个表中可以：

单列做主键

多列做主键（复合主键）

但一个表内只能有一个主键primary key

```plain
============单列做主键===============
#方法一：not null+unique
create table department1(
id int not null unique, #主键
name varchar(20) not null unique,
comment varchar(100)
);
mysql> desc department1;
+---------+--------------+------+-----+---------+-------+
| Field   | Type         | Null | Key | Default | Extra |
+---------+--------------+------+-----+---------+-------+
| id      | int(11)      | NO   | PRI | NULL    |       |
| name    | varchar(20)  | NO   | UNI | NULL    |       |
| comment | varchar(100) | YES  |     | NULL    |       |
+---------+--------------+------+-----+---------+-------+
rows in set (0.01 sec)
#方法二：在某一个字段后用primary key
create table department2(
id int primary key, #主键
name varchar(20),
comment varchar(100)
);
mysql> desc department2;
+---------+--------------+------+-----+---------+-------+
| Field   | Type         | Null | Key | Default | Extra |
+---------+--------------+------+-----+---------+-------+
| id      | int(11)      | NO   | PRI | NULL    |       |
| name    | varchar(20)  | YES  |     | NULL    |       |
| comment | varchar(100) | YES  |     | NULL    |       |
+---------+--------------+------+-----+---------+-------+
rows in set (0.00 sec)
#方法三：在所有字段后单独定义primary key
create table department3(
id int,
name varchar(20),
comment varchar(100),
constraint pk_name primary key(id); #创建主键并为其命名pk_name
mysql> desc department3;
+---------+--------------+------+-----+---------+-------+
| Field   | Type         | Null | Key | Default | Extra |
+---------+--------------+------+-----+---------+-------+
| id      | int(11)      | NO   | PRI | NULL    |       |
| name    | varchar(20)  | YES  |     | NULL    |       |
| comment | varchar(100) | YES  |     | NULL    |       |
+---------+--------------+------+-----+---------+-------+
rows in set (0.01 sec)
单列主键
```

```plain
==================多列做主键================
create table service(
ip varchar(15),
port char(5),
service_name varchar(10) not null,
primary key(ip,port)
);
mysql> desc service;
+--------------+-------------+------+-----+---------+-------+
| Field        | Type        | Null | Key | Default | Extra |
+--------------+-------------+------+-----+---------+-------+
| ip           | varchar(15) | NO   | PRI | NULL    |       |
| port         | char(5)     | NO   | PRI | NULL    |       |
| service_name | varchar(10) | NO   |     | NULL    |       |
+--------------+-------------+------+-----+---------+-------+
rows in set (0.00 sec)
mysql> insert into service values
    -> ('172.16.45.10','3306','mysqld'),
    -> ('172.16.45.11','3306','mariadb')
    -> ;
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0
mysql> insert into service values ('172.16.45.10','3306','nginx');
ERROR 1062 (23000): Duplicate entry '172.16.45.10-3306' for key 'PRIMARY'
多列主键
```

### 五、 auto_increment
约束字段为自动增长，被约束的字段必须同时被key约束

```plain
#不指定id，则自动增长
create table student(
id int primary key auto_increment,
name varchar(20),
sex enum('male','female') default 'male'
);
mysql> desc student;
+-------+-----------------------+------+-----+---------+----------------+
| Field | Type                  | Null | Key | Default | Extra          |
+-------+-----------------------+------+-----+---------+----------------+
| id    | int(11)               | NO   | PRI | NULL    | auto_increment |
| name  | varchar(20)           | YES  |     | NULL    |                |
| sex   | enum('male','female') | YES  |     | male    |                |
+-------+-----------------------+------+-----+---------+----------------+
mysql> insert into student(name) values
    -> ('egon'),
    -> ('alex')
    -> ;
mysql> select * from student;
+----+------+------+
| id | name | sex  |
+----+------+------+
|  1 | egon | male |
|  2 | alex | male |
+----+------+------+
#也可以指定id
mysql> insert into student values(4,'asb','female');
Query OK, 1 row affected (0.00 sec)
mysql> insert into student values(7,'wsb','female');
Query OK, 1 row affected (0.00 sec)
mysql> select * from student;
+----+------+--------+
| id | name | sex    |
+----+------+--------+
|  1 | egon | male   |
|  2 | alex | male   |
|  4 | asb  | female |
|  7 | wsb  | female |
+----+------+--------+
#对于自增的字段，在用delete删除后，再插入值，该字段仍按照删除前的位置继续增长
mysql> delete from student;
Query OK, 4 rows affected (0.00 sec)
mysql> select * from student;
Empty set (0.00 sec)
mysql> insert into student(name) values('ysb');
mysql> select * from student;
+----+------+------+
| id | name | sex  |
+----+------+------+
|  8 | ysb  | male |
+----+------+------+
#应该用truncate清空表，比起delete一条一条地删除记录，truncate是直接清空表，在删除大表时用它
mysql> truncate student;
Query OK, 0 rows affected (0.01 sec)
mysql> insert into student(name) values('egon');
Query OK, 1 row affected (0.01 sec)
mysql> select * from student;
+----+------+------+
| id | name | sex  |
+----+------+------+
|  1 | egon | male |
+----+------+------+
row in set (0.00 sec)
```

```plain
#在创建完表后，修改自增字段的起始值
mysql> create table student(
    -> id int primary key auto_increment,
    -> name varchar(20),
    -> sex enum('male','female') default 'male'
    -> );
mysql> alter table student auto_increment=3;
mysql> show create table student;
.......
ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8
mysql> insert into student(name) values('egon');
Query OK, 1 row affected (0.01 sec)
mysql> select * from student;
+----+------+------+
| id | name | sex  |
+----+------+------+
|  3 | egon | male |
+----+------+------+
row in set (0.00 sec)
mysql> show create table student;
.......
ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8
#也可以创建表时指定auto_increment的初始值，注意初始值的设置为表选项，应该放到括号外
create table student(
id int primary key auto_increment,
name varchar(20),
sex enum('male','female') default 'male'
)auto_increment=3;
#设置步长
sqlserver：自增步长
    基于表级别
    create table t1（
        id int。。。
    ）engine=innodb,auto_increment=2 步长=2 default charset=utf8
mysql自增的步长：
    show session variables like 'auto_inc%';
    #基于会话级别
    set session auth_increment_increment=2 #修改会话级别的步长
    #基于全局级别的
    set global auth_increment_increment=2 #修改全局级别的步长（所有会话都生效）
#！！！注意了注意了注意了！！！
If the value of auto_increment_offset is greater than that of auto_increment_increment, the value of auto_increment_offset is ignored. 
翻译：如果auto_increment_offset的值大于auto_increment_increment的值，则auto_increment_offset的值会被忽略 
比如：设置auto_increment_offset=3，auto_increment_increment=2
mysql> set global auto_increment_increment=5;
Query OK, 0 rows affected (0.00 sec)
mysql> set global auto_increment_offset=3;
Query OK, 0 rows affected (0.00 sec)
mysql> show variables like 'auto_incre%'; #需要退出重新登录
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 1     |
| auto_increment_offset    | 1     |
+--------------------------+-------+
create table student(
id int primary key auto_increment,
name varchar(20),
sex enum('male','female') default 'male'
);
mysql> insert into student(name) values('egon1'),('egon2'),('egon3');
mysql> select * from student;
+----+-------+------+
| id | name  | sex  |
+----+-------+------+
|  3 | egon1 | male |
|  8 | egon2 | male |
| 13 | egon3 | male |
+----+-------+------+
步长increment与起始偏移量offset:auto_increment_increment,auto_increment_offset
```

auto_increment时增加新内容

清空表：

delete from t1; #如果有自增id，新增的数据，仍然是以删除前的最后一样作为起始。

truncate table t1;数据量大，删除速度比上一条快，且直接从零开始，

### 六、 foreign key
**一 快速理解foreign key**

员工信息表有三个字段：工号 姓名 部门

公司有3个部门，但是有1个亿的员工，那意味着部门这个字段需要重复存储，部门名字越长，越浪费

解决方法：

我们完全可以定义一个部门表

然后让员工信息表关联该表，如何关联，即foreign key

```plain
#表类型必须是innodb存储引擎，且被关联的字段，即references指定的另外一个表的字段，必须保证唯一
create table department(
id int primary key,
name varchar(20) not null
)engine=innodb;
#dpt_id外键，关联父表（department主键id），同步更新，同步删除
create table employee(
id int primary key,
name varchar(20) not null,
dpt_id int,
constraint fk_name foreign key(dpt_id)
references department(id)
on delete cascade
on update cascade 
)engine=innodb;
#先往父表department中插入记录
insert into department values
(1,'欧德博爱技术有限事业部'),
(2,'艾利克斯人力资源部'),
(3,'销售部');
#再往子表employee中插入记录
insert into employee values
(1,'egon',1),
(2,'alex1',2),
(3,'alex2',2),
(4,'alex3',2),
(5,'李坦克',3),
(6,'刘飞机',3),
(7,'张火箭',3),
(8,'林子弹',3),
(9,'加特林',3)
;
#删父表department，子表employee中对应的记录跟着删
mysql> delete from department where id=3;
mysql> select * from employee;
+----+-------+--------+
| id | name  | dpt_id |
+----+-------+--------+
|  1 | egon  |      1 |
|  2 | alex1 |      2 |
|  3 | alex2 |      2 |
|  4 | alex3 |      2 |
+----+-------+--------+
#更新父表department，子表employee中对应的记录跟着改
mysql> update department set id=22222 where id=2;
mysql> select * from employee;
+----+-------+--------+
| id | name  | dpt_id |
+----+-------+--------+
|  1 | egon  |      1 |
|  3 | alex2 |  22222 |
|  4 | alex3 |  22222 |
|  5 | alex1 |  22222 |
+----+-------+--------+
 示范
```

**二 如何找出两张表之间的关系**

```plain
分析步骤：
#1、先站在左表的角度去找
是否左表的多条记录可以对应右表的一条记录，如果是，则证明左表的一个字段foreign key 右表一个字段（通常是id）
#2、再站在右表的角度去找
是否右表的多条记录可以对应左表的一条记录，如果是，则证明右表的一个字段foreign key 左表一个字段（通常是id）
#3、总结：
#多对一：
如果只有步骤1成立，则是左表多对一右表
如果只有步骤2成立，则是右表多对一左表
#多对多
如果步骤1和2同时成立，则证明这两张表时一个双向的多对一，即多对多,需要定义一个这两张表的关系表来专门存放二者的关系
#一对一:
如果1和2都不成立，而是左表的一条记录唯一对应右表的一条记录，反之亦然。这种情况很简单，就是在左表foreign key右表的基础上，将左表的外键字段设置成unique即可
```

**三 建立表之间的关系**

```plain
#一对多或称为多对一
三张表：出版社，作者信息，书
一对多（或多对一）：一个出版社可以出版多本书
关联方式：foreign key
```

```plain
=====================多对一=====================
create table press(
id int primary key auto_increment,
name varchar(20)
);
create table book(
id int primary key auto_increment,
name varchar(20),
press_id int not null,
foreign key(press_id) references press(id)
on delete cascade
on update cascade
);
insert into press(name) values
('北京工业地雷出版社'),
('人民音乐不好听出版社'),
('知识产权没有用出版社')
;
insert into book(name,press_id) values
('九阳神功',1),
('九阴真经',2),
('九阴白骨爪',2),
('独孤九剑',3),
('降龙十巴掌',2),
('葵花宝典',3)
;
```

```plain
一夫多妻制
#妻子表的丈夫id外键到丈夫表的id
```

```plain
#多对多
三张表：出版社，作者信息，书
多对多：一个作者可以写多本书，一本书也可以有多个作者，双向的一对多，即多对多
　　
关联方式：foreign key+一张新的表
```

```plain
=====================多对多=====================
create table author(
id int primary key auto_increment,
name varchar(20)
);
#这张表就存放作者表与书表的关系，即查询二者的关系查这表就可以了
create table author2book(
id int not null unique auto_increment,
author_id int not null,
book_id int not null,
constraint fk_author foreign key(author_id) references author(id)
on delete cascade
on update cascade,
constraint fk_book foreign key(book_id) references book(id)
on delete cascade
on update cascade,
primary key(author_id,book_id)
);
#插入四个作者，id依次排开
insert into author(name) values('egon'),('alex'),('yuanhao'),('wpq');
#每个作者与自己的代表作如下
egon: 
九阳神功
九阴真经
九阴白骨爪
独孤九剑
降龙十巴掌
葵花宝典
alex: 
九阳神功
葵花宝典
yuanhao:
独孤九剑
降龙十巴掌
葵花宝典
wpq:
九阳神功
insert into author2book(author_id,book_id) values
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),
(2,1),
(2,6),
(3,4),
(3,5),
(3,6),
(4,1)
;
```

```plain
单张表：用户表+相亲关系表，相当于：用户表+相亲关系表+用户表
多张表：用户表+用户与主机关系表+主机表
中间那一张存放关系的表，对外关联的字段可以联合唯一
```

```plain
#一对一
两张表：学生表和客户表
一对一：一个学生是一个客户，一个客户有可能变成一个学校，即一对一的关系
关联方式：foreign key+unique
```

```plain
#一定是student来foreign key表customer，这样就保证了：
#1 学生一定是一个客户，
#2 客户不一定是学生，但有可能成为一个学生
create table customer(
id int primary key auto_increment,
name varchar(20) not null,
qq varchar(10) not null,
phone char(16) not null
);
create table student(
id int primary key auto_increment,
class_name varchar(20) not null,
customer_id int unique, #该字段一定要是唯一的
foreign key(customer_id) references customer(id) #外键的字段一定要保证unique
on delete cascade
on update cascade
);
#增加客户
insert into customer(name,qq,phone) values
('李飞机','31811231',13811341220),
('王大炮','123123123',15213146809),
('守榴弹','283818181',1867141331),
('吴坦克','283818181',1851143312),
('赢火箭','888818181',1861243314),
('战地雷','112312312',18811431230)
;
#增加学生
insert into student(class_name,customer_id) values
('脱产3班',3),
('周末19期',4),
('周末19期',5)
;
```

```plain
例一：一个用户只有一个博客
    用户表：
    id  name
   egon
   alex
   wupeiqi
    博客表   
           fk+unique
    id url name_id
 xxxx   1
 yyyy   3
 zzz    2
例二：一个管理员唯一对应一个用户
    用户表：
    id user  password
 egon    xxxx
 alex    yyyy
    管理员表：
       fk+unique
    id user_id password
  1      xxxxx
  2      yyyyy
其他例子
```

### 七、 作业
练习：账号信息表，用户组，主机表，主机组

```plain
#用户表
create table user(
id int not null unique auto_increment,
username varchar(20) not null,
password varchar(50) not null,
primary key(username,password)
);
insert into user(username,password) values
('root','123'),
('egon','456'),
('alex','alex3714')
;
#用户组表
create table usergroup(
id int primary key auto_increment,
groupname varchar(20) not null unique
);
insert into usergroup(groupname) values
('IT'),
('Sale'),
('Finance'),
('boss')
;
#主机表
create table host(
id int primary key auto_increment,
ip char(15) not null unique default '127.0.0.1'
);
insert into host(ip) values
('172.16.45.2'),
('172.16.31.10'),
('172.16.45.3'),
('172.16.31.11'),
('172.10.45.3'),
('172.10.45.4'),
('172.10.45.5'),
('192.168.1.20'),
('192.168.1.21'),
('192.168.1.22'),
('192.168.2.23'),
('192.168.2.223'),
('192.168.2.24'),
('192.168.3.22'),
('192.168.3.23'),
('192.168.3.24')
;
#业务线表
create table business(
id int primary key auto_increment,
business varchar(20) not null unique
);
insert into business(business) values
('轻松贷'),
('随便花'),
('大富翁'),
('穷一生')
;
#建关系：user与usergroup
create table user2usergroup(
id int not null unique auto_increment,
user_id int not null,
group_id int not null,
primary key(user_id,group_id),
foreign key(user_id) references user(id),
foreign key(group_id) references usergroup(id)
);
insert into user2usergroup(user_id,group_id) values
(1,1),
(1,2),
(1,3),
(1,4),
(2,3),
(2,4),
(3,4)
;
#建关系：host与business
create table host2business(
id int not null unique auto_increment,
host_id int not null,
business_id int not null,
primary key(host_id,business_id),
foreign key(host_id) references host(id),
foreign key(business_id) references business(id)
);
insert into host2business(host_id,business_id) values
(1,1),
(1,2),
(1,3),
(2,2),
(2,3),
(3,4)
;
#建关系：user与host
create table user2host(
id int not null unique auto_increment,
user_id int not null,
host_id int not null,
primary key(user_id,host_id),
foreign key(user_id) references user(id),
foreign key(host_id) references host(id)
);
insert into user2host(user_id,host_id) values
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),
(1,7),
(1,8),
(1,9),
(1,10),
(1,11),
(1,12),
(1,13),
(1,14),
(1,15),
(1,16),
(2,2),
(2,3),
(2,4),
(2,5),
(3,10),
(3,11),
(3,12)
;
```

作业：

<!-- OCR_START -->
| 班级表：class | 班级表：class | 班级表：class | 班级表：class | 排名 |
| --- | --- | --- | --- | --- |
| sname | gender | class_id | 1 | 三年二班 |
| 1 | 钢蛋 | 女 | 1 | 2 |
| 一年三班 | 2 | 铁锤 | 女 | 1 |
| 3 | 三年一班 | 3 | 山炮 | 男 |
| 2 | 老师表： | teacher | 课程表：course | tid |
| tname | cid | cname | tearch_id | 1 |
| 波多 | 1 | 生物 | 1 | 2 |
| 苍空 | 2 | 体育 | 1 | 3 |
| 饭岛 | 3 | 物理 | 2 | 成绩表：score |
| sid | student_id | corse_id | number | 1 |
| 1 | 1 | 60 | 2 | 1 |
| 2 | 59 | 3 | 2 | 2 |
<!-- OCR_END -->

# 8.4 数据操作
## 8.4.1 数据的增删改查
### 本节重点
+ [插入数据INSERT](http://www.cnblogs.com/linhaifeng/articles/7267587.html#_label2)
+ [更新数据UPDATE](http://www.cnblogs.com/linhaifeng/articles/7267587.html#_label3)
+ [删除数据DELETE](http://www.cnblogs.com/linhaifeng/articles/7267587.html#_label4)
+ [权限管理](http://www.cnblogs.com/linhaifeng/articles/7267587.html#_label6)

> **本节时长需控制在15分钟内**
>

### 一 介绍
MySQL数据操作： DML

========================================================

在MySQL管理软件中，可以通过SQL语句中的DML语言来实现数据的操作，包括

1. _使用INSERT实现数据的插入_
2. _UPDATE实现数据的更新_
3. _使用DELETE实现数据的删除_
4. _使用SELECT查询数据以及。_

_========================================================_

本节内容包括：

插入数据

更新数据

删除数据

查询数据

### 二 插入数据INSERT
```plain
1. 插入完整数据（顺序插入）
    语法一：
    INSERT INTO 表名(字段1,字段2,字段3…字段n) VALUES(值1,值2,值3…值n);
    语法二：
    INSERT INTO 表名 VALUES (值1,值2,值3…值n);
2. 指定字段插入数据
    语法：
    INSERT INTO 表名(字段1,字段2,字段3…) VALUES (值1,值2,值3…);
3. 插入多条记录
    语法：
    INSERT INTO 表名 VALUES
        (值1,值2,值3…值n),
        (值1,值2,值3…值n),
        (值1,值2,值3…值n);
4. 插入查询结果
    语法：
    INSERT INTO 表名(字段1,字段2,字段3…字段n) 
                    SELECT (字段1,字段2,字段3…字段n) FROM 表2
                    WHERE …;
```

### 三 更新数据UPDATE
```plain
语法：
    UPDATE 表名 SET
        字段1=值1,
        字段2=值2,
        WHERE CONDITION;
示例：
    UPDATE mysql.user SET password=password(‘123’) 
        where user=’root’ and host=’localhost’;
```

### 四 删除数据DELETE
```plain
语法：
    DELETE FROM 表名 
        WHERE CONITION;
示例：
    DELETE FROM mysql.user 
        WHERE password=’’;
练习：
    更新MySQL root用户密码为mysql123
    删除除从本地登录的root用户以外的所有用户
```

### 五 权限管理

<!-- OCR_START -->
- column1
- table1
- column2
- column3
- table2
- db1
- table3
- db2
<!-- OCR_END -->

```plain
#授权表
user #该表放行的权限，针对：所有数据，所有库下所有表，以及表下的所有字段
db #该表放行的权限，针对：某一数据库，该数据库下的所有表，以及表下的所有字段
tables_priv #该表放行的权限。针对：某一张表，以及该表下的所有字段
columns_priv #该表放行的权限，针对：某一个字段
#按图解释：
user：放行db1，db2及其包含的所有
db：放行db1，及其db1包含的所有
tables_priv:放行db1.table1，及其该表包含的所有
columns_prive:放行db1.table1.column1，只放行该字段
```

```plain
#创建用户
create user 'egon'@'1.1.1.1' identified by '123';
create user 'egon'@'192.168.1.%' identified by '123';
create user 'egon'@'%' identified by '123';
#授权：对文件夹，对文件，对文件某一字段的权限
查看帮助：help grant
常用权限有：select,update,alter,delete
all可以代表除了grant之外的所有权限
#针对所有库的授权:*.*
grant select on *.* to 'egon1'@'localhost' identified by '123'; #只在user表中可以查到egon1用户的select权限被设置为Y
#针对某一数据库：db1.*
grant select on db1.* to 'egon2'@'%' identified by '123'; #只在db表中可以查到egon2用户的select权限被设置为Y
#针对某一个表：db1.t1
grant select on db1.t1 to 'egon3'@'%' identified by '123';  #只在tables_priv表中可以查到egon3用户的select权限
#针对某一个字段：
mysql> select * from t3;
+------+-------+------+
| id   | name  | age  |
+------+-------+------+
|    1 | egon1 |   18 |
|    2 | egon2 |   19 |
|    3 | egon3 |   29 |
+------+-------+------+
grant select (id,name),update (age) on db1.t3 to 'egon4'@'localhost' identified by '123'; 
#可以在tables_priv和columns_priv中看到相应的权限
mysql> select * from tables_priv where user='egon4'\G
*************************** 1. row ***************************
       Host: localhost
         Db: db1
       User: egon4
 Table_name: t3
    Grantor: root@localhost
  Timestamp: 0000-00-00 00:00:00
 Table_priv:
Column_priv: Select,Update
row in set (0.00 sec)
mysql> select * from columns_priv where user='egon4'\G
*************************** 1. row ***************************
       Host: localhost
         Db: db1
       User: egon4
 Table_name: t3
Column_name: id
  Timestamp: 0000-00-00 00:00:00
Column_priv: Select
*************************** 2. row ***************************
       Host: localhost
         Db: db1
       User: egon4
 Table_name: t3
Column_name: name
  Timestamp: 0000-00-00 00:00:00
Column_priv: Select
*************************** 3. row ***************************
       Host: localhost
         Db: db1
       User: egon4
 Table_name: t3
Column_name: age
  Timestamp: 0000-00-00 00:00:00
Column_priv: Update
rows in set (0.00 sec)
#删除权限
revoke select on db1.* to 'alex'@'%';
权限相关操作
```

## 8.4.2 单表查询
### 本节重点
+ [单表查询的语法](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label1)
+ [关键字的执行优先级(重点)](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label2)
+ [简单查询](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label3)
+ [WHERE约束](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label4)
+ [分组查询:GROUP BY](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label5)
+ [HAVING过滤](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label6)
+ [查询排序:ORDER BY](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label7)
+ [限制查询的记录数:LIMIT](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label8)
+ [使用正则表达式查询](http://www.cnblogs.com/linhaifeng/articles/7267592.html#_label9)

> **本节时长需控制在15分钟内**
>

### 一 单表查询的语法
```plain
SELECT 字段1,字段2... FROM 表名
                  WHERE 条件
                  GROUP BY field
                  HAVING 筛选
                  ORDER BY field
                  LIMIT 限制条数
```

### 二 关键字的执行优先级(重点)
```plain
重点中的重点：关键字的执行优先级
from
where
group by
having
select
distinct
order by
limit
```

**1.找到表:from**

**2.拿着where指定的约束条件，去文件/表中取出一条条记录**

**3.将取出的一条条记录进行分组group by，如果没有group by，则整体作为一组**

**4.将分组的结果进行having过滤**

**5.执行select**

**6.去重**

**7.将结果按条件排序：order by**

**8.限制结果的显示条数**

[**详细见：http://www.cnblogs.com/linhaifeng/articles/7372774.html**](http://www.cnblogs.com/linhaifeng/articles/7372774.html)

### 三 简单查询
```plain
company.employee
    员工id      id                  int             
    姓名        emp_name            varchar
    性别        sex                 enum
    年龄        age                 int
    入职日期     hire_date           date
    岗位        post                varchar
    职位描述     post_comment        varchar
    薪水        salary              double
    办公室       office              int
    部门编号     depart_id           int
#创建表
create table employee(
id int not null unique auto_increment,
name varchar(20) not null,
sex enum('male','female') not null default 'male', #大部分是男的
age int(3) unsigned not null default 28,
hire_date date not null,
post varchar(50),
post_comment varchar(100),
salary double(15,2),
office int, #一个部门一个屋子
depart_id int
);
#查看表结构
mysql> desc employee;
+--------------+-----------------------+------+-----+---------+----------------+
| Field        | Type                  | Null | Key | Default | Extra          |
+--------------+-----------------------+------+-----+---------+----------------+
| id           | int(11)               | NO   | PRI | NULL    | auto_increment |
| name         | varchar(20)           | NO   |     | NULL    |                |
| sex          | enum('male','female') | NO   |     | male    |                |
| age          | int(3) unsigned       | NO   |     | 28      |                |
| hire_date    | date                  | NO   |     | NULL    |                |
| post         | varchar(50)           | YES  |     | NULL    |                |
| post_comment | varchar(100)          | YES  |     | NULL    |                |
| salary       | double(15,2)          | YES  |     | NULL    |                |
| office       | int(11)               | YES  |     | NULL    |                |
| depart_id    | int(11)               | YES  |     | NULL    |                |
+--------------+-----------------------+------+-----+---------+----------------+
#插入记录
#三个部门：教学，销售，运营
insert into employee(name,sex,age,hire_date,post,salary,office,depart_id) values
('egon','male',18,'20170301','老男孩驻沙河办事处外交大使',7300.33,401,1), #以下是教学部
('alex','male',78,'20150302','teacher',1000000.31,401,1),
('wupeiqi','male',81,'20130305','teacher',8300,401,1),
('yuanhao','male',73,'20140701','teacher',3500,401,1),
('liwenzhou','male',28,'20121101','teacher',2100,401,1),
('jingliyang','female',18,'20110211','teacher',9000,401,1),
('jinxin','male',18,'19000301','teacher',30000,401,1),
('成龙','male',48,'20101111','teacher',10000,401,1),
('歪歪','female',48,'20150311','sale',3000.13,402,2),#以下是销售部门
('丫丫','female',38,'20101101','sale',2000.35,402,2),
('丁丁','female',18,'20110312','sale',1000.37,402,2),
('星星','female',18,'20160513','sale',3000.29,402,2),
('格格','female',28,'20170127','sale',4000.33,402,2),
('张野','male',28,'20160311','operation',10000.13,403,3), #以下是运营部门
('程咬金','male',18,'19970312','operation',20000,403,3),
('程咬银','female',18,'20130311','operation',19000,403,3),
('程咬铜','male',18,'20150411','operation',18000,403,3),
('程咬铁','female',18,'20140512','operation',17000,403,3)
;
#ps：如果在windows系统中，插入中文字符，select的结果为空白，可以将所有字符编码统一设置成gbk
准备表和记录
```

```plain
#简单查询
    SELECT id,name,sex,age,hire_date,post,post_comment,salary,office,depart_id 
    FROM employee;
    SELECT * FROM employee;
    SELECT name,salary FROM employee;
#避免重复DISTINCT
    SELECT DISTINCT post FROM employee;    
#通过四则运算查询
    SELECT name, salary*12 FROM employee;
    SELECT name, salary*12 AS Annual_salary FROM employee;
    SELECT name, salary*12 Annual_salary FROM employee;
#定义显示格式
   CONCAT() 函数用于连接字符串
   SELECT CONCAT('姓名: ',name,'  年薪: ', salary*12)  AS Annual_salary 
   FROM employee;
   CONCAT_WS() 第一个参数为分隔符
   SELECT CONCAT_WS(':',name,salary*12)  AS Annual_salary 
   FROM employee;
```

```plain
1
```

```plain
查出所有员工的名字，薪资,格式为
<
名字:egon
>
<
薪资:3000
>
2
 查出所有的岗位（去掉重复）
3 查出所有员工名字，以及他们的年薪,年薪的字段名为annual_year
```

```plain
select concat('<名字:',name,'>    ','<薪资:',salary,'>') from employee;
select distinct depart_id from employee;
select name,salary*12 annual_salary from employee;
```

### 四 WHERE约束
where字句中可以使用：

1. 比较运算符：><>= <= <> !=
2. between 80 and 100 值在80到100之间
3. in(80,90,100) 值是80或90或100
4. like 'egon%'  
pattern可以是%或_，  
%表示任意多字符  
_表示一个字符
5. 逻辑运算符：在多个条件直接可以使用逻辑运算符 and or not

```plain
#1:单条件查询
    SELECT name FROM employee
        WHERE post='sale';
#2:多条件查询
    SELECT name,salary FROM employee
        WHERE post='teacher' AND salary>10000;
#3:关键字BETWEEN AND
    SELECT name,salary FROM employee 
        WHERE salary BETWEEN 10000 AND 20000;
    SELECT name,salary FROM employee 
        WHERE salary NOT BETWEEN 10000 AND 20000;
#4:关键字IS NULL(判断某个字段是否为NULL不能用等号，需要用IS)
    SELECT name,post_comment FROM employee 
        WHERE post_comment IS NULL;
    SELECT name,post_comment FROM employee 
        WHERE post_comment IS NOT NULL;
    SELECT name,post_comment FROM employee 
        WHERE post_comment=''; 注意''是空字符串，不是null
    ps：
        执行
        update employee set post_comment='' where id=2;
        再用上条查看，就会有结果了
#5:关键字IN集合查询
    SELECT name,salary FROM employee 
        WHERE salary=3000 OR salary=3500 OR salary=4000 OR salary=9000 ;
    SELECT name,salary FROM employee 
        WHERE salary IN (3000,3500,4000,9000) ;
    SELECT name,salary FROM employee 
        WHERE salary NOT IN (3000,3500,4000,9000) ;
#6:关键字LIKE模糊查询
    通配符’%’
    SELECT * FROM employee 
            WHERE name LIKE 'eg%';
    通配符’_’
    SELECT * FROM employee 
            WHERE name LIKE 'al__';
```

```plain
1. 查看岗位是teacher的员工姓名、年龄
2. 查看岗位是teacher且年龄大于30岁的员工姓名、年龄
3. 查看岗位是teacher且薪资在9000-1000范围内的员工姓名、年龄、薪资
4. 查看岗位描述不为NULL的员工信息
5. 查看岗位是teacher且薪资是10000或9000或30000的员工姓名、年龄、薪资
6. 查看岗位是teacher且薪资不是10000或9000或30000的员工姓名、年龄、薪资
7. 查看岗位是teacher且名字是jin开头的员工姓名、年薪
```

```plain
select name,age from employee where post = 'teacher';
select name,age from employee where post='teacher' and age > 30; 
select name,age,salary from employee where post='teacher' and salary between 9000 and 10000;
select * from employee where post_comment is not null;
select name,age,salary from employee where post='teacher' and salary in (10000,9000,30000);
select name,age,salary from employee where post='teacher' and salary not in (10000,9000,30000);
select name,salary*12 from employee where post='teacher' and name like 'jin%';
```

### 五 分组查询:GROUP BY
**一 什么是分组？为什么要分组？**

```plain
#1、首先明确一点：分组发生在where之后，即分组是基于where之后得到的记录而进行的
#2、分组指的是：将所有记录按照某个相同字段进行归类，比如针对员工信息表的职位分组，或者按照性别进行分组等
#3、为何要分组呢？
    取每个部门的最高工资
    取每个部门的员工数
    取男人数和女人数
小窍门：‘每’这个字后面的字段，就是我们分组的依据
#4、大前提：
    可以按照任意字段分组，但是分组完毕后，比如group by post，只能查看post字段，如果想查看组内信息，需要借助于聚合函数
```

**二 ONLY_FULL_GROUP_BY**

```plain
#查看MySQL 5.7默认的sql_mode如下：
mysql> select @@global.sql_mode;
ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
#！！！注意
ONLY_FULL_GROUP_BY的语义就是确定select target list中的所有列的值都是明确语义，简单的说来，在ONLY_FULL_GROUP_BY模式下，target list中的值要么是来自于聚集函数的结果，要么是来自于group by list中的表达式的值。
#设置sql_mole如下操作(我们可以去掉ONLY_FULL_GROUP_BY模式)：
mysql> set global sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
！！！SQL_MODE设置！！！
```

```plain
mysql> select @@global.sql_mode;
+-------------------+
| @@global.sql_mode |
+-------------------+
|                   |
+-------------------+
row in set (0.00 sec)
mysql> select * from emp group by post; 
+----+------+--------+-----+------------+----------------------------+--------------+------------+--------+-----------+
| id | name | sex    | age | hire_date  | post                       | post_comment | salary     | office | depart_id |
+----+------+--------+-----+------------+----------------------------+--------------+------------+--------+-----------+
| 14 | 张野 | male   |  28 | 2016-03-11 | operation                  | NULL         |   10000.13 |    403 |         3 |
|  9 | 歪歪 | female |  48 | 2015-03-11 | sale                       | NULL         |    3000.13 |    402 |         2 |
|  2 | alex | male   |  78 | 2015-03-02 | teacher                    | NULL         | 1000000.31 |    401 |         1 |
|  1 | egon | male   |  18 | 2017-03-01 | 老男孩驻沙河办事处外交大使 | NULL         |    7300.33 |    401 |         1 |
+----+------+--------+-----+------------+----------------------------+--------------+------------+--------+-----------+
rows in set (0.00 sec)
#由于没有设置ONLY_FULL_GROUP_BY,于是也可以有结果，默认都是组内的第一条记录，但其实这是没有意义的
mysql> set global sql_mode='ONLY_FULL_GROUP_BY';
Query OK, 0 rows affected (0.00 sec)
mysql> quit #设置成功后，一定要退出，然后重新登录方可生效
Bye
mysql> use db1;
Database changed
mysql> select * from emp group by post; #报错
ERROR 1055 (42000): 'db1.emp.id' isn't in GROUP BY
mysql> select post,count(id) from emp group by post; #只能查看分组依据和使用聚合函数
+----------------------------+-----------+
| post                       | count(id) |
+----------------------------+-----------+
| operation                  |         5 |
| sale                       |         5 |
| teacher                    |         7 |
| 老男孩驻沙河办事处外交大使 |         1 |
+----------------------------+-----------+
rows in set (0.00 sec)
```

**三 GROUP BY**

```plain
单独使用GROUP BY关键字分组
    SELECT post FROM employee GROUP BY post;
    注意：我们按照post字段分组，那么select查询的字段只能是post，想要获取组内的其他相关信息，需要借助函数
GROUP BY关键字和GROUP_CONCAT()函数一起使用
    SELECT post,GROUP_CONCAT(name) FROM employee GROUP BY post;#按照岗位分组，并查看组内成员名
    SELECT post,GROUP_CONCAT(name) as emp_members FROM employee GROUP BY post;
GROUP BY与聚合函数一起使用
    select post,count(id) as count from employee group by post;#按照岗位分组，并查看每个组有多少人
```

**强调：**

```plain
如果我们用unique的字段作为分组的依据，则每一条记录自成一组，这种分组没有意义
多条记录之间的某个字段值相同，该字段通常用来作为分组的依据
```

**四 聚合函数**

```plain
#强调：聚合函数聚合的是组的内容，若是没有分组，则默认一组
示例：
    SELECT COUNT(*) FROM employee;
    SELECT COUNT(*) FROM employee WHERE depart_id=1;
    SELECT MAX(salary) FROM employee;
    SELECT MIN(salary) FROM employee;
    SELECT AVG(salary) FROM employee;
    SELECT SUM(salary) FROM employee;
    SELECT SUM(salary) FROM employee WHERE depart_id=3;
```

**五 小练习：**

```plain
1. 查询岗位名以及岗位包含的所有员工名字
2. 查询岗位名以及各岗位内包含的员工个数
3. 查询公司内男员工和女员工的个数
4. 查询岗位名以及各岗位的平均薪资
5. 查询岗位名以及各岗位的最高薪资
6. 查询岗位名以及各岗位的最低薪资
7. 查询男员工与男员工的平均薪资，女员工与女员工的平均薪资
```

```plain
#题1：分组
mysql> select post,group_concat(name) from employee group by post;
+-----------------------------------------+---------------------------------------------------------+
| post                                    | group_concat(name)                                      |
+-----------------------------------------+---------------------------------------------------------+
| operation                               | 张野,程咬金,程咬银,程咬铜,程咬铁                        |
| sale                                    | 歪歪,丫丫,丁丁,星星,格格                                |
| teacher                                 | alex,wupeiqi,yuanhao,liwenzhou,jingliyang,jinxin,成龙   |
| 老男孩驻沙河办事处外交大使              | egon                                                    |
+-----------------------------------------+---------------------------------------------------------+
#题目2：
mysql> select post,count(id) from employee group by post;
+-----------------------------------------+-----------+
| post                                    | count(id) |
+-----------------------------------------+-----------+
| operation                               |         5 |
| sale                                    |         5 |
| teacher                                 |         7 |
| 老男孩驻沙河办事处外交大使              |         1 |
+-----------------------------------------+-----------+
#题目3：
mysql> select sex,count(id) from employee group by sex;
+--------+-----------+
| sex    | count(id) |
+--------+-----------+
| male   |        10 |
| female |         8 |
+--------+-----------+
#题目4：
mysql> select post,avg(salary) from employee group by post;
+-----------------------------------------+---------------+
| post                                    | avg(salary)   |
+-----------------------------------------+---------------+
| operation                               |  16800.026000 |
| sale                                    |   2600.294000 |
| teacher                                 | 151842.901429 |
| 老男孩驻沙河办事处外交大使              |   7300.330000 |
+-----------------------------------------+---------------+
#题目5
mysql> select post,max(salary) from employee group by post;
+-----------------------------------------+-------------+
| post                                    | max(salary) |
+-----------------------------------------+-------------+
| operation                               |    20000.00 |
| sale                                    |     4000.33 |
| teacher                                 |  1000000.31 |
| 老男孩驻沙河办事处外交大使              |     7300.33 |
+-----------------------------------------+-------------+
#题目6
mysql> select post,min(salary) from employee group by post;
+-----------------------------------------+-------------+
| post                                    | min(salary) |
+-----------------------------------------+-------------+
| operation                               |    10000.13 |
| sale                                    |     1000.37 |
| teacher                                 |     2100.00 |
| 老男孩驻沙河办事处外交大使              |     7300.33 |
+-----------------------------------------+-------------+
#题目七
mysql> select sex,avg(salary) from employee group by sex;
+--------+---------------+
| sex    | avg(salary)   |
+--------+---------------+
| male   | 110920.077000 |
| female |   7250.183750 |
+--------+---------------+
```

### 六 HAVING过滤
HAVING与WHERE不一样的地方在于!!!!!!

```plain
#！！！执行优先级从高到低：where > group by > having 
#1. Where 发生在分组group by之前，因而Where中可以有任意字段，但是绝对不能使用聚合函数。
#2. Having发生在分组group by之后，因而Having中可以使用分组的字段，无法直接取到其他字段,可以使用聚合函数
```

```plain
mysql> select @@sql_mode;
+--------------------+
| @@sql_mode         |
+--------------------+
| ONLY_FULL_GROUP_BY |
+--------------------+
row in set (0.00 sec)
mysql> select * from emp where salary > 100000;
+----+------+------+-----+------------+---------+--------------+------------+--------+-----------+
| id | name | sex  | age | hire_date  | post    | post_comment | salary     | office | depart_id |
+----+------+------+-----+------------+---------+--------------+------------+--------+-----------+
|  2 | alex | male |  78 | 2015-03-02 | teacher | NULL         | 1000000.31 |    401 |         1 |
+----+------+------+-----+------------+---------+--------------+------------+--------+-----------+
row in set (0.00 sec)
mysql> select * from emp having salary > 100000;
ERROR 1463 (42000): Non-grouping field 'salary' is used in HAVING clause
mysql> select post,group_concat(name) from emp group by post having salary > 10000;#错误，分组后无法直接取到salary字段
ERROR 1054 (42S22): Unknown column 'salary' in 'having clause'
mysql> select post,group_concat(name) from emp group by post having avg(salary) > 10000;
+-----------+-------------------------------------------------------+
| post | group_concat(name) |
+-----------+-------------------------------------------------------+
| operation | 程咬铁,程咬铜,程咬银,程咬金,张野 |
| teacher | 成龙,jinxin,jingliyang,liwenzhou,yuanhao,wupeiqi,alex |
+-----------+-------------------------------------------------------+
rows in set (0.00 sec)
验证
```

小练习：

```plain
1. 查询各岗位内包含的员工个数小于2的岗位名、岗位内包含员工名字、个数
3. 查询各岗位平均薪资大于10000的岗位名、平均工资
4. 查询各岗位平均薪资大于10000且小于20000的岗位名、平均工资
```

```plain
#题1：
mysql> select post,group_concat(name),count(id) from employee group by post having count(id) < 2;
+-----------------------------------------+--------------------+-----------+
| post                                    | group_concat(name) | count(id) |
+-----------------------------------------+--------------------+-----------+
| 老男孩驻沙河办事处外交大使              | egon               |         1 |
+-----------------------------------------+--------------------+-----------+
#题目2：
mysql> select post,avg(salary) from employee group by post having avg(salary) > 10000;
+-----------+---------------+
| post      | avg(salary)   |
+-----------+---------------+
| operation |  16800.026000 |
| teacher   | 151842.901429 |
+-----------+---------------+
#题目3：
mysql> select post,avg(salary) from employee group by post having avg(salary) > 10000 and avg(salary) <20000;
+-----------+--------------+
| post      | avg(salary)  |
+-----------+--------------+
| operation | 16800.026000 |
+-----------+--------------+
```

### 七 查询排序:ORDER BY
```plain
按单列排序
    SELECT * FROM employee ORDER BY salary;
    SELECT * FROM employee ORDER BY salary ASC;
    SELECT * FROM employee ORDER BY salary DESC;
按多列排序:先按照age排序，如果年纪相同，则按照薪资排序
    SELECT * from employee
        ORDER BY age,
        salary DESC;
```

小练习：

```plain
1. 查询所有员工信息，先按照age升序排序，如果age相同则按照hire_date降序排序
2. 查询各岗位平均薪资大于10000的岗位名、平均工资,结果按平均薪资升序排列
3. 查询各岗位平均薪资大于10000的岗位名、平均工资,结果按平均薪资降序排列
```

```plain
#题目1
mysql> select * from employee ORDER BY age asc,hire_date desc;
#题目2
mysql> select post,avg(salary) from employee group by post having avg(salary) > 10000 order by avg(salary) asc;
+-----------+---------------+
| post      | avg(salary)   |
+-----------+---------------+
| operation |  16800.026000 |
| teacher   | 151842.901429 |
+-----------+---------------+
#题目3
mysql> select post,avg(salary) from employee group by post having avg(salary) > 10000 order by avg(salary) desc;
+-----------+---------------+
| post      | avg(salary)   |
+-----------+---------------+
| teacher   | 151842.901429 |
| operation |  16800.026000 |
+-----------+---------------+
```

### 八 限制查询的记录数:LIMIT
```plain
示例：
    SELECT * FROM employee ORDER BY salary DESC 
        LIMIT 3;                    #默认初始位置为0 
    SELECT * FROM employee ORDER BY salary DESC
        LIMIT 0,5; #从第0开始，即先查询出第一条，然后包含这一条在内往后查5条
    SELECT * FROM employee ORDER BY salary DESC
        LIMIT 5,5; #从第5开始，即先查询出第6条，然后包含这一条在内往后查5条
```

小练习：

```plain
1. 分页显示，每页5条
```

```plain
mysql> select * from  employee limit 0,5;
+----+-----------+------+-----+------------+-----------------------------------------+--------------+------------+--------+-----------+
| id | name      | sex  | age | hire_date  | post                                    | post_comment | salary     | office | depart_id |
+----+-----------+------+-----+------------+-----------------------------------------+--------------+------------+--------+-----------+
|  1 | egon      | male |  18 | 2017-03-01 | 老男孩驻沙河办事处外交大使              | NULL         |    7300.33 |    401 |         1 |
|  2 | alex      | male |  78 | 2015-03-02 | teacher                                 |              | 1000000.31 |    401 |         1 |
|  3 | wupeiqi   | male |  81 | 2013-03-05 | teacher                                 | NULL         |    8300.00 |    401 |         1 |
|  4 | yuanhao   | male |  73 | 2014-07-01 | teacher                                 | NULL         |    3500.00 |    401 |         1 |
|  5 | liwenzhou | male |  28 | 2012-11-01 | teacher                                 | NULL         |    2100.00 |    401 |         1 |
+----+-----------+------+-----+------------+-----------------------------------------+--------------+------------+--------+-----------+
rows in set (0.00 sec)
mysql> select * from  employee limit 5,5;
+----+------------+--------+-----+------------+---------+--------------+----------+--------+-----------+
| id | name       | sex    | age | hire_date  | post    | post_comment | salary   | office | depart_id |
+----+------------+--------+-----+------------+---------+--------------+----------+--------+-----------+
|  6 | jingliyang | female |  18 | 2011-02-11 | teacher | NULL         |  9000.00 |    401 |         1 |
|  7 | jinxin     | male   |  18 | 1900-03-01 | teacher | NULL         | 30000.00 |    401 |         1 |
|  8 | 成龙       | male   |  48 | 2010-11-11 | teacher | NULL         | 10000.00 |    401 |         1 |
|  9 | 歪歪       | female |  48 | 2015-03-11 | sale    | NULL         |  3000.13 |    402 |         2 |
| 10 | 丫丫       | female |  38 | 2010-11-01 | sale    | NULL         |  2000.35 |    402 |         2 |
+----+------------+--------+-----+------------+---------+--------------+----------+--------+-----------+
rows in set (0.00 sec)
mysql> select * from  employee limit 10,5;
+----+-----------+--------+-----+------------+-----------+--------------+----------+--------+-----------+
| id | name      | sex    | age | hire_date  | post      | post_comment | salary   | office | depart_id |
+----+-----------+--------+-----+------------+-----------+--------------+----------+--------+-----------+
| 11 | 丁丁      | female |  18 | 2011-03-12 | sale      | NULL         |  1000.37 |    402 |         2 |
| 12 | 星星      | female |  18 | 2016-05-13 | sale      | NULL         |  3000.29 |    402 |         2 |
| 13 | 格格      | female |  28 | 2017-01-27 | sale      | NULL         |  4000.33 |    402 |         2 |
| 14 | 张野      | male   |  28 | 2016-03-11 | operation | NULL         | 10000.13 |    403 |         3 |
| 15 | 程咬金    | male   |  18 | 1997-03-12 | operation | NULL         | 20000.00 |    403 |         3 |
+----+-----------+--------+-----+------------+-----------+--------------+----------+--------+-----------+
rows in set (0.00 sec)
```

### 九 使用正则表达式查询
```plain
SELECT * FROM employee WHERE name REGEXP '^ale';
SELECT * FROM employee WHERE name REGEXP 'on$';
SELECT * FROM employee WHERE name REGEXP 'm{2}';
小结：对字符串匹配的方式
WHERE name = 'egon';
WHERE name LIKE 'yua%';
WHERE name REGEXP 'on$';
```

小练习：

```plain
查看所有员工中名字是jin开头，n或者g结果的员工信息
```

```plain
select * from employee where name regexp '^jin.*[gn]$';
```

## 8.4.3 多表查询
### 本节重点
+ [多表连接查询](http://www.cnblogs.com/linhaifeng/articles/7267596.html#_label2)
+ [符合条件连接查询](http://www.cnblogs.com/linhaifeng/articles/7267596.html#_label3)
+ [子查询](http://www.cnblogs.com/linhaifeng/articles/7267596.html#_label4)

> **本节时长需控制在15分钟内**
>

### 一 介绍
本节主题

+ 多表连接查询
+ 复合条件连接查询
+ 子查询

准备表

```plain
#建表
create table department(
id int,
name varchar(20) 
);
create table employee(
id int primary key auto_increment,
name varchar(20),
sex enum('male','female') not null default 'male',
age int,
dep_id int
);
#插入数据
insert into department values
(200,'技术'),
(201,'人力资源'),
(202,'销售'),
(203,'运营');
insert into employee(name,sex,age,dep_id) values
('egon','male',18,200),
('alex','female',48,201),
('wupeiqi','male',38,201),
('yuanhao','female',28,202),
('liwenzhou','male',18,200),
('jingliyang','female',18,204)
;
#查看表结构和数据
mysql> desc department;
+-------+-------------+------+-----+---------+-------+
| Field | Type | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id | int(11) | YES | | NULL | |
| name | varchar(20) | YES | | NULL | |
+-------+-------------+------+-----+---------+-------+
mysql> desc employee;
+--------+-----------------------+------+-----+---------+----------------+
| Field | Type | Null | Key | Default | Extra |
+--------+-----------------------+------+-----+---------+----------------+
| id | int(11) | NO | PRI | NULL | auto_increment |
| name | varchar(20) | YES | | NULL | |
| sex | enum('male','female') | NO | | male | |
| age | int(11) | YES | | NULL | |
| dep_id | int(11) | YES | | NULL | |
+--------+-----------------------+------+-----+---------+----------------+
mysql> select * from department;
+------+--------------+
| id | name |
+------+--------------+
| 200 | 技术 |
| 201 | 人力资源 |
| 202 | 销售 |
| 203 | 运营 |
+------+--------------+
mysql> select * from employee;
+----+------------+--------+------+--------+
| id | name | sex | age | dep_id |
+----+------------+--------+------+--------+
| 1 | egon | male | 18 | 200 |
| 2 | alex | female | 48 | 201 |
| 3 | wupeiqi | male | 38 | 201 |
| 4 | yuanhao | female | 28 | 202 |
| 5 | liwenzhou | male | 18 | 200 |
| 6 | jingliyang | female | 18 | 204 |
+----+------------+--------+------+--------+
表department与employee
```

### 二 多表连接查询
```plain
#重点：外链接语法
SELECT 字段列表
    FROM 表1 INNER|LEFT|RIGHT JOIN 表2
    ON 表1.字段 = 表2.字段;
```

**1 交叉连接：不适用任何匹配条件。生成笛卡尔积**

```plain
mysql> select * from employee,department;
+----+------------+--------+------+--------+------+--------------+
| id | name       | sex    | age  | dep_id | id   | name         |
+----+------------+--------+------+--------+------+--------------+
|  1 | egon       | male   |   18 |    200 |  200 | 技术         |
|  1 | egon       | male   |   18 |    200 |  201 | 人力资源     |
|  1 | egon       | male   |   18 |    200 |  202 | 销售         |
|  1 | egon       | male   |   18 |    200 |  203 | 运营         |
|  2 | alex       | female |   48 |    201 |  200 | 技术         |
|  2 | alex       | female |   48 |    201 |  201 | 人力资源     |
|  2 | alex       | female |   48 |    201 |  202 | 销售         |
|  2 | alex       | female |   48 |    201 |  203 | 运营         |
|  3 | wupeiqi    | male   |   38 |    201 |  200 | 技术         |
|  3 | wupeiqi    | male   |   38 |    201 |  201 | 人力资源     |
|  3 | wupeiqi    | male   |   38 |    201 |  202 | 销售         |
|  3 | wupeiqi    | male   |   38 |    201 |  203 | 运营         |
|  4 | yuanhao    | female |   28 |    202 |  200 | 技术         |
|  4 | yuanhao    | female |   28 |    202 |  201 | 人力资源     |
|  4 | yuanhao    | female |   28 |    202 |  202 | 销售         |
|  4 | yuanhao    | female |   28 |    202 |  203 | 运营         |
|  5 | liwenzhou  | male   |   18 |    200 |  200 | 技术         |
|  5 | liwenzhou  | male   |   18 |    200 |  201 | 人力资源     |
|  5 | liwenzhou  | male   |   18 |    200 |  202 | 销售         |
|  5 | liwenzhou  | male   |   18 |    200 |  203 | 运营         |
|  6 | jingliyang | female |   18 |    204 |  200 | 技术         |
|  6 | jingliyang | female |   18 |    204 |  201 | 人力资源     |
|  6 | jingliyang | female |   18 |    204 |  202 | 销售         |
|  6 | jingliyang | female |   18 |    204 |  203 | 运营         |
+----+------------+--------+------+--------+------+--------------+
```

**2 内连接：只连接匹配的行**

```plain
#找两张表共有的部分，相当于利用条件从笛卡尔积结果中筛选出了正确的结果
#department没有204这个部门，因而employee表中关于204这条员工信息没有匹配出来
mysql> select employee.id,employee.name,employee.age,employee.sex,department.name from employee inner join department on employee.dep_id=department.id; 
+----+-----------+------+--------+--------------+
| id | name      | age  | sex    | name         |
+----+-----------+------+--------+--------------+
|  1 | egon      |   18 | male   | 技术         |
|  2 | alex      |   48 | female | 人力资源     |
|  3 | wupeiqi   |   38 | male   | 人力资源     |
|  4 | yuanhao   |   28 | female | 销售         |
|  5 | liwenzhou |   18 | male   | 技术         |
+----+-----------+------+--------+--------------+
#上述sql等同于
mysql> select employee.id,employee.name,employee.age,employee.sex,department.name from employee,department where employee.dep_id=department.id;
```

**3 外链接之左连接：优先显示左表全部记录**

```plain
#以左表为准，即找出所有员工信息，当然包括没有部门的员工
#本质就是：在内连接的基础上增加左边有右边没有的结果
mysql> select employee.id,employee.name,department.name as depart_name from employee left join department on employee.dep_id=department.id;
+----+------------+--------------+
| id | name       | depart_name  |
+----+------------+--------------+
|  1 | egon       | 技术         |
|  5 | liwenzhou  | 技术         |
|  2 | alex       | 人力资源     |
|  3 | wupeiqi    | 人力资源     |
|  4 | yuanhao    | 销售         |
|  6 | jingliyang | NULL         |
+----+------------+--------------+
```

**4 外链接之右连接：优先显示右表全部记录**

```plain
#以右表为准，即找出所有部门信息，包括没有员工的部门
#本质就是：在内连接的基础上增加右边有左边没有的结果
mysql> select employee.id,employee.name,department.name as depart_name from employee right join department on employee.dep_id=department.id;
+------+-----------+--------------+
| id   | name      | depart_name  |
+------+-----------+--------------+
|    1 | egon      | 技术         |
|    2 | alex      | 人力资源     |
|    3 | wupeiqi   | 人力资源     |
|    4 | yuanhao   | 销售         |
|    5 | liwenzhou | 技术         |
| NULL | NULL      | 运营         |
+------+-----------+--------------+
```

**5 全外连接：显示左右两个表全部记录**

```plain
全外连接：在内连接的基础上增加左边有右边没有的和右边有左边没有的结果
#注意：mysql不支持全外连接 full JOIN
#强调：mysql可以使用此种方式间接实现全外连接
select * from employee left join department on employee.dep_id = department.id
union
select * from employee right join department on employee.dep_id = department.id
;
#查看结果
+------+------------+--------+------+--------+------+--------------+
| id   | name       | sex    | age  | dep_id | id   | name         |
+------+------------+--------+------+--------+------+--------------+
|    1 | egon       | male   |   18 |    200 |  200 | 技术         |
|    5 | liwenzhou  | male   |   18 |    200 |  200 | 技术         |
|    2 | alex       | female |   48 |    201 |  201 | 人力资源     |
|    3 | wupeiqi    | male   |   38 |    201 |  201 | 人力资源     |
|    4 | yuanhao    | female |   28 |    202 |  202 | 销售         |
|    6 | jingliyang | female |   18 |    204 | NULL | NULL         |
| NULL | NULL       | NULL   | NULL |   NULL |  203 | 运营         |
+------+------------+--------+------+--------+------+--------------+
#注意 union与union all的区别：union会去掉相同的纪录
```

### 三 符合条件连接查询
```plain
#示例1：以内连接的方式查询employee和department表，并且employee表中的age字段值必须大于25,即找出年龄大于25岁的员工以及员工所在的部门
select employee.name,department.name from employee inner join department
    on employee.dep_id = department.id
    where age > 25;
#示例2：以内连接的方式查询employee和department表，并且以age字段的升序方式显示
select employee.id,employee.name,employee.age,department.name from employee,department
    where employee.dep_id = department.id
    and age > 25
    order by age asc;
```

### 四 子查询
```plain
#1：子查询是将一个查询语句嵌套在另一个查询语句中。
#2：内层查询语句的查询结果，可以为外层查询语句提供查询条件。
#3：子查询中可以包含：IN、NOT IN、ANY、ALL、EXISTS 和 NOT EXISTS等关键字
#4：还可以包含比较运算符：= 、 !=、> 、<等
```

**1 带IN关键字的子查询**

```plain
#查询平均年龄在25岁以上的部门名
select id,name from department
    where id in 
        (select dep_id from employee group by dep_id having avg(age) > 25);
#查看技术部员工姓名
select name from employee
    where dep_id in 
        (select id from department where name='技术');
#查看不足1人的部门名
select name from department
    where id in 
        (select dep_id from employee group by dep_id having count(id) <=1);
```

**2 带比较运算符的子查询**

```plain
#比较运算符：=、!=、>、>=、<、<=、<>
#查询大于所有人平均年龄的员工名与年龄
mysql> select name,age from emp where age > (select avg(age) from emp);
+---------+------+
| name | age |
+---------+------+
| alex | 48 |
| wupeiqi | 38 |
+---------+------+
rows in set (0.00 sec)
#查询大于部门内平均年龄的员工名、年龄
select t1.name,t1.age from emp t1
inner join 
(select dep_id,avg(age) avg_age from emp group by dep_id) t2
on t1.dep_id = t2.dep_id
where t1.age > t2.avg_age;
```

**3 带EXISTS关键字的子查询**

EXISTS关字键字表示存在。在使用EXISTS关键字时，内层查询语句不返回查询的记录。

而是返回一个真假值。True或False

当返回True时，外层查询语句将进行查询；当返回值为False时，外层查询语句不进行查询

```plain
#department表中存在dept_id=203，Ture
mysql> select * from employee
    ->     where exists
    ->         (select id from department where id=200);
+----+------------+--------+------+--------+
| id | name       | sex    | age  | dep_id |
+----+------------+--------+------+--------+
|  1 | egon       | male   |   18 |    200 |
|  2 | alex       | female |   48 |    201 |
|  3 | wupeiqi    | male   |   38 |    201 |
|  4 | yuanhao    | female |   28 |    202 |
|  5 | liwenzhou  | male   |   18 |    200 |
|  6 | jingliyang | female |   18 |    204 |
+----+------------+--------+------+--------+
#department表中存在dept_id=205，False
mysql> select * from employee
    ->     where exists
    ->         (select id from department where id=204);
Empty set (0.00 sec)
```

**练习：查询每个部门最新入职的那位员工**

```plain
company.employee
    员工id      id                  int             
    姓名        emp_name            varchar
    性别        sex                 enum
    年龄        age                 int
    入职日期     hire_date           date
    岗位        post                varchar
    职位描述     post_comment        varchar
    薪水        salary              double
    办公室       office              int
    部门编号     depart_id           int
#创建表
create table employee(
id int not null unique auto_increment,
name varchar(20) not null,
sex enum('male','female') not null default 'male', #大部分是男的
age int(3) unsigned not null default 28,
hire_date date not null,
post varchar(50),
post_comment varchar(100),
salary double(15,2),
office int, #一个部门一个屋子
depart_id int
);
#查看表结构
mysql> desc employee;
+--------------+-----------------------+------+-----+---------+----------------+
| Field        | Type                  | Null | Key | Default | Extra          |
+--------------+-----------------------+------+-----+---------+----------------+
| id           | int(11)               | NO   | PRI | NULL    | auto_increment |
| name         | varchar(20)           | NO   |     | NULL    |                |
| sex          | enum('male','female') | NO   |     | male    |                |
| age          | int(3) unsigned       | NO   |     | 28      |                |
| hire_date    | date                  | NO   |     | NULL    |                |
| post         | varchar(50)           | YES  |     | NULL    |                |
| post_comment | varchar(100)          | YES  |     | NULL    |                |
| salary       | double(15,2)          | YES  |     | NULL    |                |
| office       | int(11)               | YES  |     | NULL    |                |
| depart_id    | int(11)               | YES  |     | NULL    |                |
+--------------+-----------------------+------+-----+---------+----------------+
#插入记录
#三个部门：教学，销售，运营
insert into employee(name,sex,age,hire_date,post,salary,office,depart_id) values
('egon','male',18,'20170301','老男孩驻沙河办事处外交大使',7300.33,401,1), #以下是教学部
('alex','male',78,'20150302','teacher',1000000.31,401,1),
('wupeiqi','male',81,'20130305','teacher',8300,401,1),
('yuanhao','male',73,'20140701','teacher',3500,401,1),
('liwenzhou','male',28,'20121101','teacher',2100,401,1),
('jingliyang','female',18,'20110211','teacher',9000,401,1),
('jinxin','male',18,'19000301','teacher',30000,401,1),
('成龙','male',48,'20101111','teacher',10000,401,1),
('歪歪','female',48,'20150311','sale',3000.13,402,2),#以下是销售部门
('丫丫','female',38,'20101101','sale',2000.35,402,2),
('丁丁','female',18,'20110312','sale',1000.37,402,2),
('星星','female',18,'20160513','sale',3000.29,402,2),
('格格','female',28,'20170127','sale',4000.33,402,2),
('张野','male',28,'20160311','operation',10000.13,403,3), #以下是运营部门
('程咬金','male',18,'19970312','operation',20000,403,3),
('程咬银','female',18,'20130311','operation',19000,403,3),
('程咬铜','male',18,'20150411','operation',18000,403,3),
('程咬铁','female',18,'20140512','operation',17000,403,3)
;
#ps：如果在windows系统中，插入中文字符，select的结果为空白，可以将所有字符编码统一设置成gbk
准备表和记录
```

```plain
SELECT
    *
FROM
    emp AS t1
INNER JOIN (
    SELECT
        post,
        max(hire_date) max_date
    FROM
        emp
    GROUP BY
        post
) AS t2 ON t1.post = t2.post
WHERE
    t1.hire_date = t2.max_date;
答案一（链表）
```

```plain
mysql> select (select t2.name from emp as t2 where t2.post=t1.post order by hire_date desc limit 1) from emp as t1 group by post;
+---------------------------------------------------------------------------------------+
| (select t2.name from emp as t2 where t2.post=t1.post order by hire_date desc limit 1) |
+---------------------------------------------------------------------------------------+
| 张野                                                                                  |
| 格格                                                                                  |
| alex                                                                                  |
| egon                                                                                  |
+---------------------------------------------------------------------------------------+
rows in set (0.00 sec)
mysql> select (select t2.id from emp as t2 where t2.post=t1.post order by hire_date desc limit 1) from emp as t1 group by post;
+-------------------------------------------------------------------------------------+
| (select t2.id from emp as t2 where t2.post=t1.post order by hire_date desc limit 1) |
+-------------------------------------------------------------------------------------+
|                                                                                  14 |
|                                                                                  13 |
|                                                                                   2 |
|                                                                                   1 |
+-------------------------------------------------------------------------------------+
rows in set (0.00 sec)
#正确答案
mysql> select t3.name,t3.post,t3.hire_date from emp as t3 where id in (select (select id from emp as t2 where t2.post=t1.post order by hire_date desc limit 1) from emp as t1 group by post);
+--------+-----------------------------------------+------------+
| name   | post                                    | hire_date  |
+--------+-----------------------------------------+------------+
| egon   | 老男孩驻沙河办事处外交大使              | 2017-03-01 |
| alex   | teacher                                 | 2015-03-02 |
| 格格   | sale                                    | 2017-01-27 |
| 张野   | operation                               | 2016-03-11 |
+--------+-----------------------------------------+------------+
rows in set (0.00 sec)
答案二（子查询）
```

答案一为正确答案，答案二中的limit 1有问题（每个部门可能有>1个为同一时间入职的新员工），我只是想用该例子来说明可以在select后使用子查询

可以基于上述方法解决：比如某网站在全国各个市都有站点，每个站点一条数据，想取每个省下最新的那一条市的网站质量信息

### 五 综合练习
init.sql文件内容

```plain
/*
 数据导入：
 Navicat Premium Data Transfer
 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50624
 Source Host           : localhost
 Source Database       : sqlexam
 Target Server Type    : MySQL
 Target Server Version : 50624
 File Encoding         : utf-8
 Date: 10/21/2016 06:46:46 AM
*/
SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;
-- ----------------------------
--  Table structure for `class`
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `caption` varchar(32) NOT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `class`
-- ----------------------------
BEGIN;
INSERT INTO `class` VALUES ('1', '三年二班'), ('2', '三年三班'), ('3', '一年二班'), ('4', '二年九班');
COMMIT;
-- ----------------------------
--  Table structure for `course`
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `cname` varchar(32) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  PRIMARY KEY (`cid`),
  KEY `fk_course_teacher` (`teacher_id`),
  CONSTRAINT `fk_course_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `course`
-- ----------------------------
BEGIN;
INSERT INTO `course` VALUES ('1', '生物', '1'), ('2', '物理', '2'), ('3', '体育', '3'), ('4', '美术', '2');
COMMIT;
-- ----------------------------
--  Table structure for `score`
-- ----------------------------
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `sid` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `num` int(11) NOT NULL,
  PRIMARY KEY (`sid`),
  KEY `fk_score_student` (`student_id`),
  KEY `fk_score_course` (`course_id`),
  CONSTRAINT `fk_score_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`cid`),
  CONSTRAINT `fk_score_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`sid`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `score`
-- ----------------------------
BEGIN;
INSERT INTO `score` VALUES ('1', '1', '1', '10'), ('2', '1', '2', '9'), ('5', '1', '4', '66'), ('6', '2', '1', '8'), ('8', '2', '3', '68'), ('9', '2', '4', '99'), ('10', '3', '1', '77'), ('11', '3', '2', '66'), ('12', '3', '3', '87'), ('13', '3', '4', '99'), ('14', '4', '1', '79'), ('15', '4', '2', '11'), ('16', '4', '3', '67'), ('17', '4', '4', '100'), ('18', '5', '1', '79'), ('19', '5', '2', '11'), ('20', '5', '3', '67'), ('21', '5', '4', '100'), ('22', '6', '1', '9'), ('23', '6', '2', '100'), ('24', '6', '3', '67'), ('25', '6', '4', '100'), ('26', '7', '1', '9'), ('27', '7', '2', '100'), ('28', '7', '3', '67'), ('29', '7', '4', '88'), ('30', '8', '1', '9'), ('31', '8', '2', '100'), ('32', '8', '3', '67'), ('33', '8', '4', '88'), ('34', '9', '1', '91'), ('35', '9', '2', '88'), ('36', '9', '3', '67'), ('37', '9', '4', '22'), ('38', '10', '1', '90'), ('39', '10', '2', '77'), ('40', '10', '3', '43'), ('41', '10', '4', '87'), ('42', '11', '1', '90'), ('43', '11', '2', '77'), ('44', '11', '3', '43'), ('45', '11', '4', '87'), ('46', '12', '1', '90'), ('47', '12', '2', '77'), ('48', '12', '3', '43'), ('49', '12', '4', '87'), ('52', '13', '3', '87');
COMMIT;
-- ----------------------------
--  Table structure for `student`
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `sid` int(11) NOT NULL AUTO_INCREMENT,
  `gender` char(1) NOT NULL,
  `class_id` int(11) NOT NULL,
  `sname` varchar(32) NOT NULL,
  PRIMARY KEY (`sid`),
  KEY `fk_class` (`class_id`),
  CONSTRAINT `fk_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `student`
-- ----------------------------
BEGIN;
INSERT INTO `student` VALUES ('1', '男', '1', '理解'), ('2', '女', '1', '钢蛋'), ('3', '男', '1', '张三'), ('4', '男', '1', '张一'), ('5', '女', '1', '张二'), ('6', '男', '1', '张四'), ('7', '女', '2', '铁锤'), ('8', '男', '2', '李三'), ('9', '男', '2', '李一'), ('10', '女', '2', '李二'), ('11', '男', '2', '李四'), ('12', '女', '3', '如花'), ('13', '男', '3', '刘三'), ('14', '男', '3', '刘一'), ('15', '女', '3', '刘二'), ('16', '男', '3', '刘四');
COMMIT;
-- ----------------------------
--  Table structure for `teacher`
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `tname` varchar(32) NOT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
-- ----------------------------
--  Records of `teacher`
-- ----------------------------
BEGIN;
INSERT INTO `teacher` VALUES ('1', '张磊老师'), ('2', '李平老师'), ('3', '刘海燕老师'), ('4', '朱云海老师'), ('5', '李杰老师');
COMMIT;
SET FOREIGN_KEY_CHECKS = 1;
```

从init.sql文件中导入数据

```plain
#准备表、记录
mysql> create database db1;
mysql> use db1;
mysql> source /root/init.sql
```

```plain
1、查询所有的课程的名称以及对应的任课老师姓名
2、查询学生表中男女生各有多少人
3、查询物理成绩等于100的学生的姓名
4、查询平均成绩大于八十分的同学的姓名和平均成绩
5、查询所有学生的学号，姓名，选课数，总成绩
6、 查询姓李老师的个数
7、 查询没有报李平老师课的学生姓名
8、 查询物理课程比生物课程高的学生的学号
9、 查询没有同时选修物理课程和体育课程的学生姓名
10、查询挂科超过两门(包括两门)的学生姓名和班级
、查询选修了所有课程的学生姓名
12、查询李平老师教的课程的所有成绩记录
13、查询全部学生都选修了的课程号和课程名
14、查询每门课程被选修的次数
15、查询之选修了一门课程的学生姓名和学号
16、查询所有学生考出的成绩并按从高到低排序（成绩去重）
17、查询平均成绩大于85的学生姓名和平均成绩
18、查询生物成绩不及格的学生姓名和对应生物分数
19、查询在所有选修了李平老师课程的学生中，这些课程(李平老师的课程，不是所有课程)平均成绩最高的学生姓名
20、查询每门课程成绩最好的前两名学生姓名
21、查询不同课程但成绩相同的学号，课程号，成绩
22、查询没学过“叶平”老师课程的学生姓名以及选修的课程名称；
23、查询所有选修了学号为1的同学选修过的一门或者多门课程的同学学号和姓名；
24、任课最多的老师中学生单科成绩最高的学生姓名
题目
```

# 8.5 Navicat 工具 pymysql模块
## 8.5.1 图形工具Navicat
### 本节重点
+ 掌握Navicat的基本使用

> **本节时长需控制在5分钟内**
>

## 一 Navicat
```plain
在生产环境中操作MySQL数据库还是推荐使用命令行工具mysql，但在我们自己开发测试时，可以使用可视化工具Navicat，以图形界面的形式操作MySQL数据库
```

官网下载：[https://www.navicat.com/en/products/navicat-for-mysql](https://www.navicat.com/en/products/navicat-for-mysql)

网盘下载：[https://pan.baidu.com/s/1bpo5mqj](https://pan.baidu.com/s/1bpo5mqj)

需要掌握的基本操作

```plain
掌握：
#1. 测试+链接数据库
#2. 新建库
#3. 新建表，新增字段+类型+约束
#4. 设计表：外键
#5. 新建查询
#6. 备份库/表
#注意：
批量加注释：ctrl+？键
批量去注释：ctrl+shift+？键
```

## 8.5.2 pymysql模块
### 本节重点
+ 掌握pymysql模块对数据的增删改查

> **本节时长需控制在20分钟内**
>

### 一 介绍
之前我们都是通过MySQL自带的命令行客户端工具mysql来操作数据库，那如何在python程序中操作数据库呢？这就用到了pymysql模块，该模块本质就是一个套接字客户端软件，使用前需要事先安装

```plain
pip3 install pymysql
```

### 二 **链接、执行sql、关闭（游标）**

<!-- OCR_START -->
| userinfo@egon（本地数据库）-表 | userinfo@egon（本地数据库）-表 | userinfo@egon（本地数据库）-表 | 排名 |
| --- | --- | --- | --- |
| 导入向导导出向导 | 筛选向导 | 田网格查看表单查看 | id |
| name | password | egonl | 123 |
| 2 egon2 | 456 | 3 egon3 | 789 |
<!-- OCR_END -->

```plain
import pymysql
user=input('用户名: ').strip()
pwd=input('密码: ').strip()
#链接
conn=pymysql.connect(host='localhost',user='root',password='123',database='egon',charset='utf8')
#游标
cursor=conn.cursor() #执行完毕返回的结果集默认以元组显示
#cursor=conn.cursor(cursor=pymysql.cursors.DictCursor)
#执行sql语句
sql='select * from userinfo where name="%s" and password="%s"' %(user,pwd) #注意%s需要加引号
print(sql)
res=cursor.execute(sql) #执行sql语句，返回sql查询成功的记录数目
print(res)
cursor.close()
conn.close()
if res:
    print('登录成功')
else:
    print('登录失败')
```

### 三 **execute()之sql注入**
注意：符号--会注释掉它之后的sql，正确的语法：--后至少有一个任意字符

根本原理：就根据程序的字符串拼接name='%s'，我们输入一个_**xxx' -- haha**_,用我们输入的xxx加'在程序中拼接成一个判断条件name='_**xxx' -- haha**_'

```plain
最后那一个空格，在一条sql语句中如果遇到select * from t1 where id > 3 -- and name='egon';则--之后的条件被注释掉了
#1、sql注入之：用户存在，绕过密码
egon' -- 任意字符
#2、sql注入之：用户不存在，绕过用户与密码
xxx' or 1=1 -- 任意字符
```

<!-- OCR_START -->
- 用户名：egonl"--hahahahahaha
- 密码：
- select
- from userinfo where name=
- egonl
- and
- 1password=
- -之后的sql均被注释掉
- 登录成功
- 绕过密码，直接登录成功
<!-- OCR_END -->

<!-- OCR_START -->
- 用户名：
- egon
- asdf
- 密码：
- select * from userinfo where name-
- and password=
- 在用户名不存在的情况下还是会登录失败，有没有绕过用户名+
- 登录失败
- 密码的方法？？？有
<!-- OCR_END -->

<!-- OCR_START -->
- 用户名：
- XXX
- or 1=1
- hahahahah
- 密码：
- select * from userinfo where name
- or
- 1=1
- and password=
- 3
- 登录成功
- or后的条件1=1永远成立，直接连用户名都可以是假的了
<!-- OCR_END -->

解决方法：

```plain
# 原来是我们对sql进行字符串拼接
# sql="select * from userinfo where name='%s' and password='%s'" %(user,pwd)
# print(sql)
# res=cursor.execute(sql)
#改写为（execute帮我们做字符串拼接，我们无需且一定不能再为%s加引号了）
sql="select * from userinfo where name=%s and password=%s" #！！！注意%s需要去掉引号，因为pymysql会自动为我们加上
res=cursor.execute(sql,[user,pwd]) #pymysql模块自动帮我们解决sql注入的问题，只要我们按照pymysql的规矩来。
```

### 四 **增、删、改：conn.commit()**
```plain
import pymysql
#链接
conn=pymysql.connect(host='localhost',user='root',password='123',database='egon')
#游标
cursor=conn.cursor()
#执行sql语句
#part1
# sql='insert into userinfo(name,password) values("root","123456");'
# res=cursor.execute(sql) #执行sql语句，返回sql影响成功的行数
# print(res)
#part2
# sql='insert into userinfo(name,password) values(%s,%s);'
# res=cursor.execute(sql,("root","123456")) #执行sql语句，返回sql影响成功的行数
# print(res)
#part3
sql='insert into userinfo(name,password) values(%s,%s);'
res=cursor.executemany(sql,[("root","123456"),("lhf","12356"),("eee","156")]) #执行sql语句，返回sql影响成功的行数
print(res)
conn.commit() #提交后才发现表中插入记录成功
cursor.close()
conn.close()
```

### 五 **查：fetchone，fetchmany，fetchall**

<!-- OCR_START -->
- mysql> select #from
- userinfo;
- id1nane
- password
- |root
- 1
- 123456
- 2
- 31root
- 41root
- 1123456
- 5
- 1root
- 6
- 7
- 1hf
- 12356
- 8
- eee
- 1156
- rows in set (0.00 sec)
<!-- OCR_END -->

```plain
import pymysql
#链接
conn=pymysql.connect(host='localhost',user='root',password='123',database='egon')
#游标
cursor=conn.cursor()
#执行sql语句
sql='select * from userinfo;'
rows=cursor.execute(sql) #执行sql语句，返回sql影响成功的行数rows,将结果放入一个集合，等待被查询
# cursor.scroll(3,mode='absolute') # 相对绝对位置移动
# cursor.scroll(3,mode='relative') # 相对当前位置移动
res1=cursor.fetchone()
res2=cursor.fetchone()
res3=cursor.fetchone()
res4=cursor.fetchmany(2)
res5=cursor.fetchall()
print(res1)
print(res2)
print(res3)
print(res4)
print(res5)
print('%s rows in set (0.00 sec)' %rows)
conn.commit() #提交后才发现表中插入记录成功
cursor.close()
conn.close()
'''
(1, 'root', '123456')
(2, 'root', '123456')
(3, 'root', '123456')
((4, 'root', '123456'), (5, 'root', '123456'))
((6, 'root', '123456'), (7, 'lhf', '12356'), (8, 'eee', '156'))
rows in set (0.00 sec)
'''
```

### 五 **获取插入的最后一条数据的自增ID**
```plain
import pymysql
conn=pymysql.connect(host='localhost',user='root',password='123',database='egon')
cursor=conn.cursor()
sql='insert into userinfo(name,password) values("xxx","123");'
rows=cursor.execute(sql)
print(cursor.lastrowid) #在插入语句后查看
conn.commit()
cursor.close()
conn.close()
```

# 8.6 mysql内置功能
## 8.6.1 视图
### 本节重点
+ 掌握视图的基本使用

> **本节时长需控制在5分钟内**
>

### 一 视图
视图是一个虚拟表（非真实存在），其本质是【根据SQL语句获取动态的数据集，并为其命名】，用户使用时只需使用【名称】即可获取结果集，可以将该结果集当做表来使用。

使用视图我们可以把查询过程中的临时表摘出来，用视图去实现，这样以后再想操作该临时表的数据时就无需重写复杂的sql了，直接去视图中查找即可，但视图有明显地效率问题，并且视图是存放在数据库中的，如果我们程序中使用的sql过分依赖数据库中的视图，即强耦合，那就意味着扩展sql极为不便，因此并不推荐使用

```plain
#两张有关系的表
mysql> select * from course;
+-----+--------+------------+
| cid | cname  | teacher_id |
+-----+--------+------------+
|   1 | 生物   |          1 |
|   2 | 物理   |          2 |
|   3 | 体育   |          3 |
|   4 | 美术   |          2 |
+-----+--------+------------+
rows in set (0.00 sec)
mysql> select * from teacher;
+-----+-----------------+
| tid | tname           |
+-----+-----------------+
|   1 | 张磊老师        |
|   2 | 李平老师        |
|   3 | 刘海燕老师      |
|   4 | 朱云海老师      |
|   5 | 李杰老师        |
+-----+-----------------+
rows in set (0.00 sec)
#查询李平老师教授的课程名
mysql> select cname from course where teacher_id = (select tid from teacher where tname='李平老师');
+--------+
| cname  |
+--------+
| 物理   |
| 美术   |
+--------+
rows in set (0.00 sec)
#子查询出临时表，作为teacher_id等判断依据
select tid from teacher where tname='李平老师'
临时表应用举例
```

#### **一 创建视图**
```plain
#语法：CREATE VIEW 视图名称 AS  SQL语句
create view teacher_view as select tid from teacher where tname='李平老师';
#于是查询李平老师教授的课程名的sql可以改写为
mysql> select cname from course where teacher_id = (select tid from teacher_view);
+--------+
| cname  |
+--------+
| 物理   |
| 美术   |
+--------+
rows in set (0.00 sec)
#！！！注意注意注意：
#1. 使用视图以后就无需每次都重写子查询的sql，但是这么效率并不高，还不如我们写子查询的效率高
#2. 而且有一个致命的问题：视图是存放到数据库里的，如果我们程序中的sql过分依赖于数据库中存放的视图，
那么意味着，一旦sql需要修改且涉及到视图的部分，则必须去数据库中进行修改，而通常在公司中数据库有专门的DBA负责，
你要想完成修改，必须付出大量的沟通成本DBA可能才会帮你完成修改，极其地不方便
```

#### **二 使用视图**
```plain
#修改视图，原始表也跟着改
mysql> select * from course;
+-----+--------+------------+
| cid | cname  | teacher_id |
+-----+--------+------------+
|   1 | 生物   |          1 |
|   2 | 物理   |          2 |
|   3 | 体育   |          3 |
|   4 | 美术   |          2 |
+-----+--------+------------+
rows in set (0.00 sec)
mysql> create view course_view as select * from course; #创建表course的视图
Query OK, 0 rows affected (0.52 sec)
mysql> select * from course_view;
+-----+--------+------------+
| cid | cname  | teacher_id |
+-----+--------+------------+
|   1 | 生物   |          1 |
|   2 | 物理   |          2 |
|   3 | 体育   |          3 |
|   4 | 美术   |          2 |
+-----+--------+------------+
rows in set (0.00 sec)
mysql> update course_view set cname='xxx'; #更新视图中的数据
Query OK, 4 rows affected (0.04 sec)
Rows matched: 4  Changed: 4  Warnings: 0
mysql> insert into course_view values(5,'yyy',2); #往视图中插入数据
Query OK, 1 row affected (0.03 sec)
mysql> select * from course; #发现原始表的记录也跟着修改了
+-----+-------+------------+
| cid | cname | teacher_id |
+-----+-------+------------+
|   1 | xxx   |          1 |
|   2 | xxx   |          2 |
|   3 | xxx   |          3 |
|   4 | xxx   |          2 |
|   5 | yyy   |          2 |
+-----+-------+------------+
rows in set (0.00 sec)
```

我们不应该修改视图中的记录，而且在涉及多个表的情况下是根本无法修改视图中的记录的，如下图

#### 

<!-- OCR_START -->
- mysql> select # from user;
- id ↓name 1dep_id 1
- 11egon
- 1
- 11
- 21alex
- 31wsh
- 31
- -+
- rows in set (0.00 sec)
- mysql> select * from dep;
- id1nane
- 21
- 技术
- 卖淫
- mysql> create view user_dep as select user.id,user.name,user.dep_id,dep.name dep_name from user left join dep on user.dep_id=dep.id;
- Query Ok,0rowsaffected(0.03sec)
- mysql> show tables;
- Tables_in_test1
- dep
- user
- user_dep
- mysql> select # from user_dep;
- Iid1name1dep_id1dep_name
- 1egon
- 财务
- 31wsb
- 3
- ysql>insertintouser_depvalues(4,'yuanhao'.3,'技术'>；
- ERROR 1471（HY00O):The target table user_dep of theINSERT is not insertable-into
<!-- OCR_END -->

**三 修改视图**
```plain
语法：ALTER VIEW 视图名称 AS SQL语句
mysql> alter view teacher_view as select * from course where cid>3;
Query OK, 0 rows affected (0.04 sec)
mysql> select * from teacher_view;
+-----+-------+------------+
| cid | cname | teacher_id |
+-----+-------+------------+
|   4 | xxx   |          2 |
|   5 | yyy   |          2 |
+-----+-------+------------+
rows in set (0.00 sec)
```

#### **四 删除视图**
```plain
语法：DROP VIEW 视图名称
DROP VIEW teacher_view
```

## 8.6.2 触发器
### 本节重点
+ 掌握触发器的基本使用

> **本节时长需控制在5分钟内**
>

### 一 触发器
使用触发器可以定制用户对表进行【增、删、改】操作时前后的行为，注意：没有查询

#### **一 创建触发器**
```plain
# 插入前
CREATE TRIGGER tri_before_insert_tb1 BEFORE INSERT ON tb1 FOR EACH ROW
BEGIN
    ...
END
# 插入后
CREATE TRIGGER tri_after_insert_tb1 AFTER INSERT ON tb1 FOR EACH ROW
BEGIN
    ...
END
# 删除前
CREATE TRIGGER tri_before_delete_tb1 BEFORE DELETE ON tb1 FOR EACH ROW
BEGIN
    ...
END
# 删除后
CREATE TRIGGER tri_after_delete_tb1 AFTER DELETE ON tb1 FOR EACH ROW
BEGIN
    ...
END
# 更新前
CREATE TRIGGER tri_before_update_tb1 BEFORE UPDATE ON tb1 FOR EACH ROW
BEGIN
    ...
END
# 更新后
CREATE TRIGGER tri_after_update_tb1 AFTER UPDATE ON tb1 FOR EACH ROW
BEGIN
    ...
END
```

```plain
#准备表
CREATE TABLE cmd (
    id INT PRIMARY KEY auto_increment,
    USER CHAR (32),
    priv CHAR (10),
    cmd CHAR (64),
    sub_time datetime, #提交时间
    success enum ('yes', 'no') #0代表执行失败
);
CREATE TABLE errlog (
    id INT PRIMARY KEY auto_increment,
    err_cmd CHAR (64),
    err_time datetime
);
#创建触发器
delimiter //
CREATE TRIGGER tri_after_insert_cmd AFTER INSERT ON cmd FOR EACH ROW
BEGIN
    IF NEW.success = 'no' THEN #等值判断只有一个等号
            INSERT INTO errlog(err_cmd, err_time) VALUES(NEW.cmd, NEW.sub_time) ; #必须加分号
      END IF ; #必须加分号
END//
delimiter ;
#往表cmd中插入记录，触发触发器，根据IF的条件决定是否插入错误日志
INSERT INTO cmd (
    USER,
    priv,
    cmd,
    sub_time,
    success
)
VALUES
    ('egon','0755','ls -l /etc',NOW(),'yes'),
    ('egon','0755','cat /etc/passwd',NOW(),'no'),
    ('egon','0755','useradd xxx',NOW(),'no'),
    ('egon','0755','ps aux',NOW(),'yes');
#查询错误日志，发现有两条
mysql> select * from errlog;
+----+-----------------+---------------------+
| id | err_cmd         | err_time            |
+----+-----------------+---------------------+
|  1 | cat /etc/passwd | 2017-09-14 22:18:48 |
|  2 | useradd xxx     | 2017-09-14 22:18:48 |
+----+-----------------+---------------------+
rows in set (0.00 sec)
插入后触发触发器
```

**特别的：NEW表示即将插入的数据行，OLD表示即将删除的数据行。**

#### **二 使用触发器**
触发器无法由用户直接调用，而知由于对表的【增/删/改】操作被动引发的。

#### **三 删除触发器**
```plain
drop trigger tri_after_insert_cmd;
```

## 8.6.2 事务
### 本节重点
+ 掌握事物的基本使用

> **本节时长需控制在5分钟内**
>

### 一 事物
事务用于将某些操作的多个SQL作为原子性操作，一旦有某一个出现错误，即可回滚到原来的状态，从而保证数据库数据完整性。

```plain
create table user(
id int primary key auto_increment,
name char(32),
balance int
);
insert into user(name,balance)
values
('wsb',1000),
('egon',1000),
('ysb',1000);
#原子操作
start transaction;
update user set balance=900 where name='wsb'; #买支付100元
update user set balance=1010 where name='egon'; #中介拿走10元
update user set balance=1090 where name='ysb'; #卖家拿到90元
commit;
#出现异常，回滚到初始状态
start transaction;
update user set balance=900 where name='wsb'; #买支付100元
update user set balance=1010 where name='egon'; #中介拿走10元
uppdate user set balance=1090 where name='ysb'; #卖家拿到90元,出现异常没有拿到
rollback;
commit;
mysql> select * from user;
+----+------+---------+
| id | name | balance |
+----+------+---------+
|  1 | wsb  |    1000 |
|  2 | egon |    1000 |
|  3 | ysb  |    1000 |
+----+------+---------+
rows in set (0.00 sec)
```

```plain
#介绍
delimiter //
            create procedure p4(
                out status int
            )
            BEGIN
                1. 声明如果出现异常则执行{
                    set status = 1;
                    rollback;
                }
                开始事务
                    -- 由秦兵账户减去100
                    -- 方少伟账户加90
                    -- 张根账户加10
                    commit;
                结束
                set status = 2;
            END //
            delimiter ;
#实现
delimiter //
create PROCEDURE p5(
    OUT p_return_code tinyint
)
BEGIN 
    DECLARE exit handler for sqlexception 
    BEGIN 
        -- ERROR 
        set p_return_code = 1; 
        rollback; 
    END; 
    DECLARE exit handler for sqlwarning 
    BEGIN 
        -- WARNING 
        set p_return_code = 2; 
        rollback; 
    END; 
    START TRANSACTION; 
        DELETE from tb1; #执行失败
        insert into blog(name,sub_time) values('yyy',now());
    COMMIT; 
    -- SUCCESS 
    set p_return_code = 0; #0代表执行成功
END //
delimiter ;
#在mysql中调用存储过程
set @res=123;
call p5(@res);
select @res;
#在python中基于pymysql调用存储过程
cursor.callproc('p5',(123,))
print(cursor.fetchall()) #查询select的查询结果
cursor.execute('select @_p5_0;')
print(cursor.fetchall())
事务
```

## 8.6.4 存储过程
### 本节重点
+ 掌握存储过程的基本使用

> **本节时长需控制在5分钟内**
>

### 一 存储过程
#### **一 存储过程介绍**
存储过程包含了一系列可执行的sql语句，存储过程存放于MySQL中，通过调用它的名字可以执行其内部的一堆sql

使用存储过程的优点：

```plain
#1. 用于替代程序写的SQL语句，实现程序与sql解耦
#2. 基于网络传输，传别名的数据量小，而直接传sql数据量大
```

使用存储过程的缺点：

```plain
#1. 程序员扩展功能不方便
```

**补充：程序与数据库结合使用的三种方式**

```plain
#方式一：
    MySQL：存储过程
    程序：调用存储过程
#方式二：
    MySQL：
    程序：纯SQL语句
#方式三：
    MySQL:
    程序：类和对象，即ORM（本质还是纯SQL语句）
```

#### **二 创建简单存储过程（无参）**
```plain
delimiter //
create procedure p1()
BEGIN
    select * from blog;
    INSERT into blog(name,sub_time) values("xxx",now());
END //
delimiter ;
#在mysql中调用
call p1() 
#在python中基于pymysql调用
cursor.callproc('p1') 
print(cursor.fetchall())
```

#### **三 创建存储过程（有参）**
```plain
对于存储过程，可以接收参数，其参数有三类：
#in          仅用于传入参数用
#out        仅用于返回值用
#inout     既可以传入又可以当作返回值
```

```plain
delimiter //
create procedure p2(
    in n1 int,
    in n2 int
)
BEGIN
    select * from blog where id > n1;
END //
delimiter ;
#在mysql中调用
call p2(3,2)
#在python中基于pymysql调用
cursor.callproc('p2',(3,2))
print(cursor.fetchall())
in:传入参数
```

```plain
delimiter //
create procedure p3(
    in n1 int,
    out res int
)
BEGIN
    select * from blog where id > n1;
    set res = 1;
END //
delimiter ;
#在mysql中调用
set @res=0; #0代表假（执行失败），1代表真（执行成功）
call p3(3,@res);
select @res;
#在python中基于pymysql调用
cursor.callproc('p3',(3,0)) #0相当于set @res=0
print(cursor.fetchall()) #查询select的查询结果
cursor.execute('select @_p3_0,@_p3_1;') #@p3_0代表第一个参数，@p3_1代表第二个参数，即返回值
print(cursor.fetchall())
out：返回值
```

```plain
delimiter //
create procedure p4(
    inout n1 int
)
BEGIN
    select * from blog where id > n1;
    set n1 = 1;
END //
delimiter ;
#在mysql中调用
set @x=3;
call p4(@x);
select @x;
#在python中基于pymysql调用
cursor.callproc('p4',(3,))
print(cursor.fetchall()) #查询select的查询结果
cursor.execute('select @_p4_0;') 
print(cursor.fetchall())
inout:既可以传入又可以返回
```

#### **四 执行存储过程**
```plain
-- 无参数
call proc_name()
-- 有参数，全in
call proc_name(1,2)
-- 有参数，有in，out，inout
set @t1=0;
set @t2=3;
call proc_name(1,2,@t1,@t2)
执行存储过程
在MySQL中执行存储过程-- 无参数
call proc_name()
-- 有参数，全in
call proc_name(1,2)
-- 有参数，有in，out，inout
set @t1=0;
set @t2=3;
call proc_name(1,2,@t1,@t2)
执行存储过程
在MySQL中执行存储过程
```

```plain
#!/usr/bin/env python
# -*- coding:utf-8 -*-
import pymysql
conn = pymysql.connect(host='127.0.0.1', port=3306, user='root', passwd='123', db='t1')
cursor = conn.cursor(cursor=pymysql.cursors.DictCursor)
# 执行存储过程
cursor.callproc('p1', args=(1, 22, 3, 4))
# 获取执行完存储的参数
cursor.execute("select @_p1_0,@_p1_1,@_p1_2,@_p1_3")
result = cursor.fetchall()
conn.commit()
cursor.close()
conn.close()
print(result)
在python中基于pymysql执行存储过程
```

#### **五 删除存储过程**
```plain
drop procedure proc_name;
```

## 8.6.5 函数
### 本节重点
+ 掌握函数的基本使用

> **本节时长需控制在5分钟内**
>

### 一 函数
MySQL中提供了许多内置函数，例如：

```plain
一、数学函数
    ROUND(x,y)
        返回参数x的四舍五入的有y位小数的值
    RAND()
        返回０到１内的随机值,可以通过提供一个参数(种子)使RAND()随机数生成器生成一个指定的值。
二、聚合函数(常用于GROUP BY从句的SELECT查询中)
    AVG(col)返回指定列的平均值
    COUNT(col)返回指定列中非NULL值的个数
    MIN(col)返回指定列的最小值
    MAX(col)返回指定列的最大值
    SUM(col)返回指定列的所有值之和
    GROUP_CONCAT(col) 返回由属于一组的列值连接组合而成的结果    
三、字符串函数
    CHAR_LENGTH(str)
        返回值为字符串str 的长度，长度的单位为字符。一个多字节字符算作一个单字符。
    CONCAT(str1,str2,...)
        字符串拼接
        如有任何一个参数为NULL ，则返回值为 NULL。
    CONCAT_WS(separator,str1,str2,...)
        字符串拼接（自定义连接符）
        CONCAT_WS()不会忽略任何空字符串。 (然而会忽略所有的 NULL）。
    CONV(N,from_base,to_base)
        进制转换
        例如：
            SELECT CONV('a',16,2); 表示将 a 由16进制转换为2进制字符串表示
    FORMAT(X,D)
        将数字X 的格式写为'#,###,###.##',以四舍五入的方式保留小数点后 D 位， 并将结果以字符串的形式返回。若  D 为 0, 则返回结果不带有小数点，或不含小数部分。
        例如：
            SELECT FORMAT(12332.1,4); 结果为： '12,332.1000'
    INSERT(str,pos,len,newstr)
        在str的指定位置插入字符串
            pos：要替换位置其实位置
            len：替换的长度
            newstr：新字符串
        特别的：
            如果pos超过原字符串长度，则返回原字符串
            如果len超过原字符串长度，则由新字符串完全替换
    INSTR(str,substr)
        返回字符串 str 中子字符串的第一个出现位置。
    LEFT(str,len)
        返回字符串str 从开始的len位置的子序列字符。
    LOWER(str)
        变小写
    UPPER(str)
        变大写
    REVERSE(str)
        返回字符串 str ，顺序和字符顺序相反。
    SUBSTRING(str,pos) , SUBSTRING(str FROM pos) SUBSTRING(str,pos,len) , SUBSTRING(str FROM pos FOR len)
        不带有len 参数的格式从字符串str返回一个子字符串，起始于位置 pos。带有len参数的格式从字符串str返回一个长度同len字符相同的子字符串，起始于位置 pos。 使用 FROM的格式为标准 SQL 语法。也可能对pos使用一个负值。假若这样，则子字符串的位置起始于字符串结尾的pos 字符，而不是字符串的开头位置。在以下格式的函数中可以对pos 使用一个负值。
        mysql> SELECT SUBSTRING('Quadratically',5);
            -> 'ratically'
        mysql> SELECT SUBSTRING('foobarbar' FROM 4);
            -> 'barbar'
        mysql> SELECT SUBSTRING('Quadratically',5,6);
            -> 'ratica'
        mysql> SELECT SUBSTRING('Sakila', -3);
            -> 'ila'
        mysql> SELECT SUBSTRING('Sakila', -5, 3);
            -> 'aki'
        mysql> SELECT SUBSTRING('Sakila' FROM -4 FOR 2);
            -> 'ki'
四、日期和时间函数
    CURDATE()或CURRENT_DATE() 返回当前的日期
    CURTIME()或CURRENT_TIME() 返回当前的时间
    DAYOFWEEK(date)   返回date所代表的一星期中的第几天(1~7)
    DAYOFMONTH(date)  返回date是一个月的第几天(1~31)
    DAYOFYEAR(date)   返回date是一年的第几天(1~366)
    DAYNAME(date)   返回date的星期名，如：SELECT DAYNAME(CURRENT_DATE);
    FROM_UNIXTIME(ts,fmt)  根据指定的fmt格式，格式化UNIX时间戳ts
    HOUR(time)   返回time的小时值(0~23)
    MINUTE(time)   返回time的分钟值(0~59)
    MONTH(date)   返回date的月份值(1~12)
    MONTHNAME(date)   返回date的月份名，如：SELECT MONTHNAME(CURRENT_DATE);
    NOW()    返回当前的日期和时间
    QUARTER(date)   返回date在一年中的季度(1~4)，如SELECT QUARTER(CURRENT_DATE);
    WEEK(date)   返回日期date为一年中第几周(0~53)
    YEAR(date)   返回日期date的年份(1000~9999)
    重点:
    DATE_FORMAT(date,format) 根据format字符串格式化date值
       mysql> SELECT DATE_FORMAT('2009-10-04 22:23:00', '%W %M %Y');
        -> 'Sunday October 2009'
       mysql> SELECT DATE_FORMAT('2007-10-04 22:23:00', '%H:%i:%s');
        -> '22:23:00'
       mysql> SELECT DATE_FORMAT('1900-10-04 22:23:00',
        ->                 '%D %y %a %d %m %b %j');
        -> '4th 00 Thu 04 10 Oct 277'
       mysql> SELECT DATE_FORMAT('1997-10-04 22:23:00',
        ->                 '%H %k %I %r %T %S %w');
        -> '22 22 10 10:23:00 PM 22:23:00 00 6'
       mysql> SELECT DATE_FORMAT('1999-01-01', '%X %V');
        -> '1998 52'
       mysql> SELECT DATE_FORMAT('2006-06-00', '%d');
        -> '00'
五、加密函数
    MD5()    
        计算字符串str的MD5校验和
    PASSWORD(str)   
        返回字符串str的加密版本，这个加密过程是不可逆转的，和UNIX密码加密过程使用不同的算法。
六、控制流函数            
    CASE WHEN[test1] THEN [result1]...ELSE [default] END
        如果testN是真，则返回resultN，否则返回default
    CASE [test] WHEN[val1] THEN [result]...ELSE [default]END  
        如果test和valN相等，则返回resultN，否则返回default
    IF(test,t,f)   
        如果test是真，返回t；否则返回f
    IFNULL(arg1,arg2) 
        如果arg1不是空，返回arg1，否则返回arg2
    NULLIF(arg1,arg2) 
        如果arg1=arg2返回NULL；否则返回arg1        
七、控制流函数小练习
#7.1、准备表
/*
Navicat MySQL Data Transfer
Source Server         : localhost_3306
Source Server Version : 50720
Source Host           : localhost:3306
Source Database       : student
Target Server Type    : MYSQL
Target Server Version : 50720
File Encoding         : 65001
Date: 2018-01-02 12:05:30
*/
SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `c_id` int(11) NOT NULL,
  `c_name` varchar(255) DEFAULT NULL,
  `t_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`c_id`),
  KEY `t_id` (`t_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES ('1', 'python', '1');
INSERT INTO `course` VALUES ('2', 'java', '2');
INSERT INTO `course` VALUES ('3', 'linux', '3');
INSERT INTO `course` VALUES ('4', 'web', '2');
-- ----------------------------
-- Table structure for score
-- ----------------------------
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `s_id` int(10) DEFAULT NULL,
  `c_id` int(11) DEFAULT NULL,
  `num` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of score
-- ----------------------------
INSERT INTO `score` VALUES ('1', '1', '1', '79');
INSERT INTO `score` VALUES ('2', '1', '2', '78');
INSERT INTO `score` VALUES ('3', '1', '3', '35');
INSERT INTO `score` VALUES ('4', '2', '2', '32');
INSERT INTO `score` VALUES ('5', '3', '1', '66');
INSERT INTO `score` VALUES ('6', '4', '2', '77');
INSERT INTO `score` VALUES ('7', '4', '1', '68');
INSERT INTO `score` VALUES ('8', '5', '1', '66');
INSERT INTO `score` VALUES ('9', '2', '1', '69');
INSERT INTO `score` VALUES ('10', '4', '4', '75');
INSERT INTO `score` VALUES ('11', '5', '4', '66.7');
-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `s_id` varchar(20) NOT NULL,
  `s_name` varchar(255) DEFAULT NULL,
  `s_age` int(10) DEFAULT NULL,
  `s_sex` char(1) DEFAULT NULL,
  PRIMARY KEY (`s_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES ('1', '鲁班', '12', '男');
INSERT INTO `student` VALUES ('2', '貂蝉', '20', '女');
INSERT INTO `student` VALUES ('3', '刘备', '35', '男');
INSERT INTO `student` VALUES ('4', '关羽', '34', '男');
INSERT INTO `student` VALUES ('5', '张飞', '33', '女');
-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher` (
  `t_id` int(10) NOT NULL,
  `t_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`t_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES ('1', '大王');
INSERT INTO `teacher` VALUES ('2', 'alex');
INSERT INTO `teacher` VALUES ('3', 'egon');
INSERT INTO `teacher` VALUES ('4', 'peiqi');
#7.2、统计各科各分数段人数.显示格式:课程ID,课程名称,[100-85],[85-70],[70-60],[ <60]
select  score.c_id,
          course.c_name, 
      sum(CASE WHEN num BETWEEN 85 and 100 THEN 1 ELSE 0 END) as '[100-85]',
      sum(CASE WHEN num BETWEEN 70 and 85 THEN 1 ELSE 0 END) as '[85-70]',
      sum(CASE WHEN num BETWEEN 60 and 70 THEN 1 ELSE 0 END) as '[70-60]',
      sum(CASE WHEN num < 60 THEN 1 ELSE 0 END) as '[ <60]'
from score,course where score.c_id=course.c_id GROUP BY score.c_id;
```

```plain
#1 基本使用
mysql> SELECT DATE_FORMAT('2009-10-04 22:23:00', '%W %M %Y');
        -> 'Sunday October 2009'
mysql> SELECT DATE_FORMAT('2007-10-04 22:23:00', '%H:%i:%s');
        -> '22:23:00'
mysql> SELECT DATE_FORMAT('1900-10-04 22:23:00',
    ->                 '%D %y %a %d %m %b %j');
        -> '4th 00 Thu 04 10 Oct 277'
mysql> SELECT DATE_FORMAT('1997-10-04 22:23:00',
    ->                 '%H %k %I %r %T %S %w');
        -> '22 22 10 10:23:00 PM 22:23:00 00 6'
mysql> SELECT DATE_FORMAT('1999-01-01', '%X %V');
        -> '1998 52'
mysql> SELECT DATE_FORMAT('2006-06-00', '%d');
        -> '00'
#2 准备表和记录
CREATE TABLE blog (
    id INT PRIMARY KEY auto_increment,
    NAME CHAR (32),
    sub_time datetime
);
INSERT INTO blog (NAME, sub_time)
VALUES
    ('第1篇','2015-03-01 11:31:21'),
    ('第2篇','2015-03-11 16:31:21'),
    ('第3篇','2016-07-01 10:21:31'),
    ('第4篇','2016-07-22 09:23:21'),
    ('第5篇','2016-07-23 10:11:11'),
    ('第6篇','2016-07-25 11:21:31'),
    ('第7篇','2017-03-01 15:33:21'),
    ('第8篇','2017-03-01 17:32:21'),
    ('第9篇','2017-03-01 18:31:21');
#3. 提取sub_time字段的值，按照格式后的结果即"年月"来分组
SELECT DATE_FORMAT(sub_time,'%Y-%m'),COUNT(1) FROM blog GROUP BY DATE_FORMAT(sub_time,'%Y-%m');
#结果
+-------------------------------+----------+
| DATE_FORMAT(sub_time,'%Y-%m') | COUNT(1) |
+-------------------------------+----------+
| 2015-03                       |        2 |
| 2016-07                       |        4 |
| 2017-03                       |        3 |
+-------------------------------+----------+
rows in set (0.00 sec)
需要掌握函数：date_format
```

更多函数：[中文猛击这里](http://doc.mysql.cn/mysql5/refman-5.1-zh.html-chapter/functions.html#encryption-functions) OR [官方猛击这里](https://dev.mysql.com/doc/refman/5.7/en/functions.html)

#### **一 自定义函数**
```plain
#！！！注意！！！
#函数中不要写sql语句（否则会报错），函数仅仅只是一个功能，是一个在sql中被应用的功能
#若要想在begin...end...中写sql，请用存储过程
```

```plain
delimiter //
create function f1(
    i1 int,
    i2 int)
returns int
BEGIN
    declare num int;
    set num = i1 + i2;
    return(num);
END //
delimiter ;
```

```plain
delimiter //
create function f5(
    i int
)
returns int
begin
    declare res int default 0;
    if i = 10 then
        set res=100;
    elseif i = 20 then
        set res=200;
    elseif i = 30 then
        set res=300;
    else
        set res=400;
    end if;
    return res;
end //
delimiter ;
```

#### **二 删除函数**
```plain
drop function func_name;
```

#### **三 执行函数**
```plain
# 获取返回值
select UPPER('egon') into @res;
SELECT @res;
# 在查询中使用
select f1(11,nid) ,name from tb2;
```

## 8.6.6 流程控制
### 本节重点
+ 掌握流程控制的基本使用

> **本节时长需控制在5分钟内**
>

### 一 流程控制
```plain
delimiter //
CREATE PROCEDURE proc_if ()
BEGIN
    declare i int default 0;
    if i = 1 THEN
        SELECT 1;
    ELSEIF i = 2 THEN
        SELECT 2;
    ELSE
        SELECT 7;
    END IF;
END //
delimiter ;
if条件语句
```

#### **二 循环语句**
```plain
delimiter //
CREATE PROCEDURE proc_while ()
BEGIN
    DECLARE num INT ;
    SET num = 0 ;
    WHILE num < 10 DO
        SELECT
            num ;
        SET num = num + 1 ;
    END WHILE ;
END //
delimiter ;
while循环
```

```plain
delimiter //
CREATE PROCEDURE proc_repeat ()
BEGIN
    DECLARE i INT ;
    SET i = 0 ;
    repeat
        select i;
        set i = i + 1;
        until i >= 5
    end repeat;
END //
delimiter ;
 repeat循环
```

```plain
BEGIN
    declare i int default 0;
    loop_label: loop
        set i=i+1;
        if i<8 then
            iterate loop_label;
        end if;
        if i>=10 then
            leave loop_label;
        end if;
        select i;
    end loop loop_label;
END
loop
```

# 8.7 索引原理与慢查询优化
## 8.7.1 索引原理与慢查询优化(1)
### 一 介绍
#### 为何要有索引?
一般的应用系统，读写比例在10:1左右，而且插入操作和一般的更新操作很少出现性能问题，在生产环境中，我们遇到最多的，也是最容易出问题的，还是一些复杂的查询操作，因此对查询语句的优化显然是重中之重。说起加速查询，就不得不提到索引了。

#### 什么是索引？
索引在MySQL中也叫做“键”，是存储引擎用于快速找到记录的一种数据结构。索引对于良好的性能

非常关键，尤其是当表中的数据量越来越大时，索引对于性能的影响愈发重要。

索引优化应该是对查询性能优化最有效的手段了。索引能够轻易将查询性能提高好几个数量级。

索引相当于字典的音序表，如果要查某个字，如果不使用音序表，则需要从几百页中逐页去查。

```plain
30
        10                          40
   5         15               35          66
1    6    11   19          21   39     55    100
```

#### 你是否对索引存在误解？
索引是应用程序设计和开发的一个重要方面。若索引太多，应用程序的性能可能会受到影响。而索引太少，对查询性能又会产生影响，要找到一个平衡点，这对应用程序的性能至关重要。一些开发人员总是在事后才想起添加索引----我一直认为，这源于一种错误的开发模式。如果知道数据的使用，从一开始就应该在需要处添加索引。开发人员往往对数据库的使用停留在应用的层面，比如编写SQL语句、存储过程之类，他们甚至可能不知道索引的存在，或认为事后让相关DBA加上即可。DBA往往不够了解业务的数据流，而添加索引需要通过监控大量的SQL语句进而从中找到问题，这个步骤所需的时间肯定是远大于初始添加索引所需的时间，并且可能会遗漏一部分的索引。当然索引也并不是越多越好，我曾经遇到过这样一个问题：某台MySQL服务器iostat显示磁盘使用率一直处于100%，经过分析后发现是由于开发人员添加了太多的索引，在删除一些不必要的索引之后，磁盘使用率马上下降为20%。可见索引的添加也是非常有技术含量的。

### 二 索引的原理
#### 一 索引原理
索引的目的在于提高查询效率，与我们查阅图书所用的目录是一个道理：先定位到章，然后定位到该章下的一个小节，然后找到页数。相似的例子还有：查字典，查火车车次，飞机航班等

**本质都是：通过不断地缩小想要获取数据的范围来筛选出最终想要的结果，同时把随机的事件变成顺序的事件，也就是说，有了这种索引机制，我们可以总是用同一种查找方式来锁定数据。**

数据库也是一样，但显然要复杂的多，因为不仅面临着等值查询，还有范围查询(>、<、between、in)、模糊查询(like)、并集查询(or)等等。数据库应该选择怎么样的方式来应对所有的问题呢？我们回想字典的例子，能不能把数据分成段，然后分段查询呢？最简单的如果1000条数据，1到100分成第一段，101到200分成第二段，201到300分成第三段......这样查第250条数据，只要找第三段就可以了，一下子去除了90%的无效数据。但如果是1千万的记录呢，分成几段比较好？稍有算法基础的同学会想到搜索树，其平均复杂度是lgN，具有不错的查询性能。但这里我们忽略了一个关键的问题，复杂度模型是基于每次相同的操作成本来考虑的。而数据库实现比较复杂，一方面数据是保存在磁盘上的，另外一方面为了提高性能，每次又可以把部分数据读入内存来计算，因为我们知道访问磁盘的成本大概是访问内存的十万倍左右，所以简单的搜索树难以满足复杂的应用场景。

#### 二 磁盘IO与预读
前面提到了访问磁盘，那么这里先简单介绍一下磁盘IO和预读，磁盘读取数据靠的是机械运动，每次读取数据花费的时间可以分为寻道时间、旋转延迟、传输时间三个部分，寻道时间指的是磁臂移动到指定磁道所需要的时间，主流磁盘一般在5ms以下；旋转延迟就是我们经常听说的磁盘转速，比如一个磁盘7200转，表示每分钟能转7200次，也就是说1秒钟能转120次，旋转延迟就是1/120/2 = 4.17ms；传输时间指的是从磁盘读出或将数据写入磁盘的时间，一般在零点几毫秒，相对于前两个时间可以忽略不计。那么访问一次磁盘的时间，即一次磁盘IO的时间约等于5+4.17 = 9ms左右，听起来还挺不错的，但要知道一台500 -MIPS（Million Instructions Per Second）的机器每秒可以执行5亿条指令，因为指令依靠的是电的性质，换句话说执行一次IO的时间可以执行约450万条指令，数据库动辄十万百万乃至千万级数据，每次9毫秒的时间，显然是个灾难。下图是计算机硬件延迟的对比图，供大家参考：

<!-- OCR_START -->
- L1 cache reference
- 0.5ns
- Branch mispredict
- 5ns
- L2 cache reference
- 7ns
- Mutex lock/unlock
- 25ns
- Main memoryreference
- 100ns
- Compress 1K byteswithZippy
- 3,000ns
- Send2K bytes over1Gbpsnetwork
- 20,000 ns
- Read 1MB sequentially from memory
- 250,000 ns
- Round trip within same datacenter
- 500,000 ns
- Disk seek
- 10,000,000
- ns
- Read 1MBsequentially from disk
- 20,000,000ns
- Send packet CA->Netherlands->CA
- 150,000,000ns
<!-- OCR_END -->

考虑到磁盘IO是非常高昂的操作，计算机操作系统做了一些优化，**当一次IO时，不光把当前磁盘地址的数据，而是把相邻的数据也都读取到内存缓冲区内**，因为局部预读性原理告诉我们，当计算机访问一个地址的数据的时候，与其相邻的数据也会很快被访问到。每一次IO读取的数据我们称之为一页(page)。具体一页有多大数据跟操作系统有关，一般为4k或8k，也就是我们读取一页内的数据时候，实际上才发生了一次IO，这个理论对于索引的数据结构设计非常有帮助。

### 三 索引的数据结构
前面讲了索引的基本原理，数据库的复杂性，又讲了操作系统的相关知识，目的就是让大家了解，任何一种数据结构都不是凭空产生的，一定会有它的背景和使用场景，我们现在总结一下，我们需要这种数据结构能够做些什么，其实很简单，那就是：每次查找数据时把磁盘IO次数控制在一个很小的数量级，最好是常数数量级。那么我们就想到如果一个高度可控的多路搜索树是否能满足需求呢？就这样，b+树应运而生（B+树是通过二叉查找树，再由平衡二叉树，B树演化而来）。

<!-- OCR_START -->
- 盘块
- P1
- P2
- P3
- 05
- 50
- 90
- 盘块5
- 磁盘块6
- 磁盘块7
- 磁盘块8
- 盘块9
- 磁盘块10
- 磁盘块11
<!-- OCR_END -->

如上图，是一颗b+树，关于b+树的定义可以参见B+树，这里只说一些重点，浅蓝色的块我们称之为一个磁盘块，可以看到每个磁盘块包含几个数据项（深蓝色所示）和指针（黄色所示），如磁盘块1包含数据项17和35，包含指针P1、P2、P3，P1表示小于17的磁盘块，P2表示在17和35之间的磁盘块，P3表示大于35的磁盘块。真实的数据存在于叶子节点即3、5、9、10、13、15、28、29、36、60、75、79、90、99。非叶子节点只不存储真实的数据，只存储指引搜索方向的数据项，如17、35并不真实存在于数据表中。

###b+树的查找过程 如图所示，如果要查找数据项29，那么首先会把磁盘块1由磁盘加载到内存，此时发生一次IO，在内存中用二分查找确定29在17和35之间，锁定磁盘块1的P2指针，内存时间因为非常短（相比磁盘的IO）可以忽略不计，通过磁盘块1的P2指针的磁盘地址把磁盘块3由磁盘加载到内存，发生第二次IO，29在26和30之间，锁定磁盘块3的P2指针，通过指针加载磁盘块8到内存，发生第三次IO，同时内存中做二分查找找到29，结束查询，总计三次IO。真实的情况是，3层的b+树可以表示上百万的数据，如果上百万的数据查找只需要三次IO，性能提高将是巨大的，如果没有索引，每个数据项都要发生一次IO，那么总共需要百万次的IO，显然成本非常非常高。

###b+树性质 1.**索引字段要尽量的小**：通过上面的分析，我们知道IO次数取决于b+数的高度h，假设当前数据表的数据为N，每个磁盘块的数据项的数量是m，则有h=㏒(m+1)N，当数据量N一定的情况下，m越大，h越小；而m = 磁盘块的大小 / 数据项的大小，磁盘块的大小也就是一个数据页的大小，是固定的，如果数据项占的空间越小，数据项的数量越多，树的高度越低。这就是为什么每个数据项，即索引字段要尽量的小，比如int占4字节，要比bigint8字节少一半。这也是为什么b+树要求把真实的数据放到叶子节点而不是内层节点，一旦放到内层节点，磁盘块的数据项会大幅度下降，导致树增高。当数据项等于1时将会退化成线性表。 2.**索引的最左匹配特性**：当b+树的数据项是复合的数据结构，比如(name,age,sex)的时候，b+数是按照从左到右的顺序来建立搜索树的，比如当(张三,20,F)这样的数据来检索的时候，b+树会优先比较name来确定下一步的所搜方向，如果name相同再依次比较age和sex，最后得到检索的数据；但当(20,F)这样的没有name的数据来的时候，b+树就不知道下一步该查哪个节点，因为建立搜索树的时候name就是第一个比较因子，必须要先根据name来搜索才能知道下一步去哪里查询。比如当(张三,F)这样的数据来检索时，b+树可以用name来指定搜索方向，但下一个字段age的缺失，所以只能把名字等于张三的数据都找到，然后再匹配性别是F的数据了， 这个是非常重要的性质，即索引的最左匹配特性。

### 四 聚集索引与辅助索引
在数据库中，B+树的高度一般都在2~4层，这也就是说查找某一个键值的行记录时最多只需要2到4次IO，这倒不错。因为当前一般的机械硬盘每秒至少可以做100次IO，2~4次的IO意味着查询时间只需要0.02~0.04秒。

数据库中的B+树索引可以分为聚集索引（clustered index）和辅助索引（secondary index），

聚集索引与辅助索引相同的是：不管是聚集索引还是辅助索引，其内部都是B+树的形式，即高度是平衡的，叶子结点存放着所有的数据。

聚集索引与辅助索引不同的是：叶子结点存放的是否是一整行的信息

#### 1、聚集索引
```plain
#InnoDB存储引擎表示索引组织表，即表中数据按照主键顺序存放。而聚集索引（clustered index）就是按照每张表的主键构造一棵B+树，同时叶子结点存放的即为整张表的行记录数据，也将聚集索引的叶子结点称为数据页。聚集索引的这个特性决定了索引组织表中数据也是索引的一部分。同B+树数据结构一样，每个数据页都通过一个双向链表来进行链接。
#如果未定义主键，MySQL取第一个唯一索引（unique）而且只含非空列（NOT NULL）作为主键，InnoDB使用它作为聚簇索引。
#如果没有这样的列，InnoDB就自己产生一个这样的ID值，它有六个字节，而且是隐藏的，使其作为聚簇索引。
#由于实际的数据页只能按照一棵B+树进行排序，因此每张表只能拥有一个聚集索引。在多少情况下，查询优化器倾向于采用聚集索引。因为聚集索引能够在B+树索引的叶子节点上直接找到数据。此外由于定义了数据的逻辑顺序，聚集索引能够特别快地访问针对范围值得查询。
```

<!-- OCR_START -->
- Page Offset:
- 0003（根节点）
- Key:8
- 80000001
- Key:8000 0002
- Key:80000004
- Pointer:
- 0004
- Pointer:00 05
- Pointer:00 06
- 0005
- 0006
- 1,repeat('a',7000)
- 2,repeat ('a',7000)
- 4,repeat ('a',7000)
- 3,repeat (`a',7000)
<!-- OCR_END -->

**聚集索引的好处之一：它对主键的排序查找和范围查找速度非常快，叶子节点的数据就是用户所要查询的数据。如用户需要查找一张表，查询最后的10位用户信息，由于B+树索引是双向链表，所以用户可以快速找到最后一个数据页，并取出10条记录**

```plain
#参照第六小结测试索引的准备阶段来创建出表s1
mysql> desc s1; #最开始没有主键
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| id     | int(11)     | NO   |     | NULL    |       |
| name   | varchar(20) | YES  |     | NULL    |       |
| gender | char(6)     | YES  |     | NULL    |       |
| email  | varchar(50) | YES  |     | NULL    |       |
+--------+-------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
mysql> explain select * from s1 order by id desc limit 10; #Using filesort，需要二次排序
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+----------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows    | filtered | Extra          |
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+----------------+
|  1 | SIMPLE      | s1    | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 2633472 |   100.00 | Using filesort |
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+----------------+
1 row in set, 1 warning (0.11 sec)
mysql> alter table s1 add primary key(id); #添加主键
Query OK, 0 rows affected (13.37 sec)
Records: 0  Duplicates: 0  Warnings: 0
mysql> explain select * from s1 order by id desc limit 10; #基于主键的聚集索引在创建完毕后就已经完成了排序，无需二次排序
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref  | rows | filtered | Extra |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------+
|  1 | SIMPLE      | s1    | NULL       | index | NULL          | PRIMARY | 4       | NULL |   10 |   100.00 | NULL  |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------+
1 row in set, 1 warning (0.04 sec)
```

**聚集索引的好处之二：范围查询（range query），即如果要查找主键某一范围内的数据，通过叶子节点的上层中间节点就可以得到页的范围，之后直接读取数据页即可**

```plain
mysql> alter table s1 drop primary key;
Query OK, 2699998 rows affected (24.23 sec)
Records: 2699998  Duplicates: 0  Warnings: 0
mysql> desc s1;
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| id     | int(11)     | NO   |     | NULL    |       |
| name   | varchar(20) | YES  |     | NULL    |       |
| gender | char(6)     | YES  |     | NULL    |       |
| email  | varchar(50) | YES  |     | NULL    |       |
+--------+-------------+------+-----+---------+-------+
4 rows in set (0.12 sec)
mysql> explain select * from s1 where id > 1 and id < 1000000; #没有聚集索引，预估需要检索的rows数如下
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows    | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+-------------+
|  1 | SIMPLE      | s1    | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 2690100 |    11.11 | Using where |
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+-------------+
1 row in set, 1 warning (0.00 sec)
mysql> alter table s1 add primary key(id);
Query OK, 0 rows affected (16.25 sec)
Records: 0  Duplicates: 0  Warnings: 0
mysql> explain select * from s1 where id > 1 and id < 1000000; #有聚集索引，预估需要检索的rows数如下
+----+-------------+-------+------------+-------+---------------+---------+---------+------+---------+----------+-------------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref  | rows    | filtered | Extra       |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+---------+----------+-------------+
|  1 | SIMPLE      | s1    | NULL       | range | PRIMARY       | PRIMARY | 4       | NULL | 1343355 |   100.00 | Using where |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+---------+----------+-------------+
1 row in set, 1 warning (0.09 sec)
```

#### 2、辅助索引
表中除了聚集索引外其他索引都是辅助索引（Secondary Index，也称为非聚集索引），与聚集索引的区别是：辅助索引的叶子节点不包含行记录的全部数据。

叶子节点除了包含键值以外，每个叶子节点中的索引行中还包含一个书签（bookmark）。该书签用来告诉InnoDB存储引擎去哪里可以找到与索引相对应的行数据。

由于InnoDB存储引擎是索引组织表，因此InnoDB存储引擎的辅助索引的书签就是相应行数据的聚集索引键。如下图

<!-- OCR_START -->
- SecondaryIndex
- ClusteredIndex
<!-- OCR_END -->

辅助索引的存在并不影响数据在聚集索引中的组织，因此每张表上可以有多个辅助索引，但只能有一个聚集索引。当通过辅助索引来寻找数据时，InnoDB存储引擎会遍历辅助索引并通过叶子级别的指针获得只想主键索引的主键，然后再通过主键索引来找到一个完整的行记录。

举例来说，如果在一棵高度为3的辅助索引树种查找数据，那需要对这个辅助索引树遍历3次找到指定主键，如果聚集索引树的高度同样为3，那么还需要对聚集索引树进行3次查找，最终找到一个完整的行数据所在的页，因此一共需要6次逻辑IO访问才能得到最终的一个数据页。

<!-- OCR_START -->
- 辅助索引idx_c
- Page Offset:00 04
- Key：7ffffff
- Pointer:80 0000 01
- Pointer:80 00 0002
- Pointer:80000003
- 聚集索引IPageOffset:0003
- Key:80 00 0001
- Key:80 00 00 02
- Key:80 00 00 04
- Pointer:0005
- Pointer:0006
- Pointer:0007
- Page Offset:00 05
- Page Offset:00 06
- Page Offset:00 07
- 1,repeat ('a',7000)
- 2,repeat(a²,7000）,-2
- 4,repeat（‘a',7000)，-
- -1
- 3,repeat(a',7000),-3
<!-- OCR_END -->

### 五 MySQL索引管理
#### 一 功能
```plain
#1. 索引的功能就是加速查找
#2. mysql中的primary key，unique，联合唯一也都是索引，这些索引除了加速查找以外，还有约束的功能
```

#### 二 MySQL常用的索引
```plain
普通索引INDEX：加速查找
唯一索引：
    -主键索引PRIMARY KEY：加速查找+约束（不为空、不能重复）
    -唯一索引UNIQUE:加速查找+约束（不能重复）
联合索引：
    -PRIMARY KEY(id,name):联合主键索引
    -UNIQUE(id,name):联合唯一索引
    -INDEX(id,name):联合普通索引
```

各个索引的应用场景

```plain
举个例子来说，比如你在为某商场做一个会员卡的系统。
这个系统有一个会员表
有下列字段：
会员编号 INT
会员姓名 VARCHAR(10)
会员身份证号码 VARCHAR(18)
会员电话 VARCHAR(10)
会员住址 VARCHAR(50)
会员备注信息 TEXT
那么这个 会员编号，作为主键，使用 PRIMARY
会员姓名 如果要建索引的话，那么就是普通的 INDEX
会员身份证号码 如果要建索引的话，那么可以选择 UNIQUE （唯一的，不允许重复）
#除此之外还有全文索引，即FULLTEXT
会员备注信息 ， 如果需要建索引的话，可以选择全文搜索。
用于搜索很长一篇文章的时候，效果最好。
用在比较短的文本，如果就一两行字的，普通的 INDEX 也可以。
但其实对于全文搜索，我们并不会使用MySQL自带的该索引，而是会选择第三方软件如Sphinx，专门来做全文搜索。
#其他的如空间索引SPATIAL，了解即可，几乎不用
```

#### 三 索引的两大类型hash与btree
```plain
#我们可以在创建上述索引的时候，为其指定索引类型，分两类
hash类型的索引：查询单条快，范围查询慢
btree类型的索引：b+树，层数越多，数据量指数级增长（我们就用它，因为innodb默认支持它）
#不同的存储引擎支持的索引类型也不一样
InnoDB 支持事务，支持行级别锁定，支持 B-tree、Full-text 等索引，不支持 Hash 索引；
MyISAM 不支持事务，支持表级别锁定，支持 B-tree、Full-text 等索引，不支持 Hash 索引；
Memory 不支持事务，支持表级别锁定，支持 B-tree、Hash 等索引，不支持 Full-text 索引；
NDB 支持事务，支持行级别锁定，支持 Hash 索引，不支持 B-tree、Full-text 等索引；
Archive 不支持事务，支持表级别锁定，不支持 B-tree、Hash、Full-text 等索引；
```

#### 四 创建/删除索引的语法
```plain
#方法一：创建表时
    　　CREATE TABLE 表名 (
                字段名1  数据类型 [完整性约束条件…],
                字段名2  数据类型 [完整性约束条件…],
                [UNIQUE | FULLTEXT | SPATIAL ]   INDEX | KEY
                [索引名]  (字段名[(长度)]  [ASC |DESC]) 
                );
#方法二：CREATE在已存在的表上创建索引
        CREATE  [UNIQUE | FULLTEXT | SPATIAL ]  INDEX  索引名 
                     ON 表名 (字段名[(长度)]  [ASC |DESC]) ;
#方法三：ALTER TABLE在已存在的表上创建索引
        ALTER TABLE 表名 ADD  [UNIQUE | FULLTEXT | SPATIAL ] INDEX
                             索引名 (字段名[(长度)]  [ASC |DESC]) ;
#删除索引：DROP INDEX 索引名 ON 表名字;
```

示范

```plain
#方式一
create table t1(
    id int,
    name char,
    age int,
    sex enum('male','female'),
    unique key uni_id(id),
    index ix_name(name) #index没有key
);
#方式二
create index ix_age on t1(age);
#方式三
alter table t1 add index ix_sex(sex);
#查看
mysql> show create table t1;
| t1    | CREATE TABLE `t1` (
  `id` int(11) DEFAULT NULL,
  `name` char(1) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` enum('male','female') DEFAULT NULL,
  UNIQUE KEY `uni_id` (`id`),
  KEY `ix_name` (`name`),
  KEY `ix_age` (`age`),
  KEY `ix_sex` (`sex`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
```

### 六 测试索引
#### 一 准备
```plain
#1. 准备表
create table s1(
id int,
name varchar(20),
gender char(6),
email varchar(50)
);
#2. 创建存储过程，实现批量插入记录
delimiter $$ #声明存储过程的结束符号为$$
create procedure auto_insert1()
BEGIN
    declare i int default 1;
    while(i<3000000)do
        insert into s1 values(i,'egon','male',concat('egon',i,'@oldboy'));
        set i=i+1;
    end while;
END$$ #$$结束
delimiter ; #重新声明分号为结束符号
#3. 查看存储过程
show create procedure auto_insert1\G 
#4. 调用存储过程
call auto_insert1();
```

#### 二 在没有索引的前提下测试查询速度
```plain
#无索引：mysql根本就不知道到底是否存在id等于333333333的记录，只能把数据表从头到尾扫描一遍，此时有多少个磁盘块就需要进行多少IO操作，所以查询速度很慢
mysql> select * from s1 where id=333333333;
Empty set (0.33 sec)
```

#### 三 在表中已经存在大量数据的前提下，为某个字段段建立索引，建立速度会很慢

<!-- OCR_START -->
- mysql>
- create
- index a on
- s1<id>；
- Query OK,
- 0rows affected
- <5.30sec)
- Records:0
- Duplicates: 0
- Warnings: 0
<!-- OCR_END -->

#### 四 在索引建立完毕后，以该字段为查询条件时，查询速度提升明显

<!-- OCR_START -->
- mysql> select  from s1where id=333333333;
- Emptyset
- 0.00sec
- 提速效果明显
<!-- OCR_END -->

PS：

1. mysql先去索引表里根据b+树的搜索原理很快搜索到id等于333333333的记录不存在，IO大大降低，因而速度明显提升
2. 我们可以去mysql的data目录下找到该表，可以看到占用的硬盘空间多了
3. 需要注意，如下图

<!-- OCR_START -->
mysql> select # from s1 where
Emptyset
(0.34sec)
设有为email加索引l，
因而以该字段为查询条件，速度依然很慢
<!-- OCR_END -->

#### 五 总结
```plain
#1. 一定是为搜索条件的字段创建索引，比如select * from s1 where id = 333;就需要为id加上索引
#2. 在表中已经有大量数据的情况下，建索引会很慢，且占用硬盘空间，建完后查询速度加快
比如create index idx on s1(id);会扫描表中所有的数据，然后以id为数据项，创建索引结构，存放于硬盘的表中。
建完以后，再查询就会很快了。
#3. 需要注意的是：innodb表的索引会存放于s1.ibd文件中，而myisam表的索引则会有单独的索引文件table1.MYI
MySAM索引文件和数据文件是分离的，索引文件仅保存数据记录的地址。而在innodb中，表数据文件本身就是按照B+Tree（BTree即Balance True）组织的一个索引结构，这棵树的叶节点data域保存了完整的数据记录。这个索引的key是数据表的主键，因此innodb表数据文件本身就是主索引。
因为inndob的数据文件要按照主键聚集，所以innodb要求表必须要有主键（Myisam可以没有），如果没有显式定义，则mysql系统会自动选择一个可以唯一标识数据记录的列作为主键，如果不存在这种列，则mysql会自动为innodb表生成一个隐含字段作为主键，这字段的长度为6个字节，类型为长整型.
```

## 8.7.2 索引原理与慢查询优化(2)
### 七 正确使用索引
一 索引未命中

并不是说我们创建了索引就一定会加快查询速度，若想利用索引达到预想的提高查询速度的效果，我们在添加索引时，必须遵循以下问题

**1 范围问题，或者说条件不明确，条件中出现这些符号或关键字：>、>=、<、<=、!= 、between...and...、like、**

_大于号、小于号_

<!-- OCR_START -->
mysql> select count(#) from s1 where
id=1000；
count(）1
明确指定要找1000这个id，在索引树中可以快速找到
31
row in set
(0.00 sec)
同上，也会利用索引树，但是没有明确指定到底找哪个id，而是指定了
8781261
一个范围，这个范围包含所有大于1000的id，即mysql会掌着1001去搜
索树中找一次，然后拿着1003...再拿着1003....整体下来，如果范围很
(0.28 sec)
大，则跟全表扫描没多大区别
mysql> select count(*) from s1
whereid>1000and id< 2000;
如果范围很小，查询速度仍然很快
一+
29971
<!-- OCR_END -->

_不等于！=_

<!-- OCR_START -->
- mysql> select count(*) from s1 where id=1000;
- count（*）1
- 31
- row in set (0.00 sec)
- mysql> select count(*) from s1 where
- id!=1000;
- ：count(#)！
- 不等于1000的id，
- ，是一个很大的范围
- 8811231
- row in set
- (0.28 sec)
<!-- OCR_END -->

_between ...and..._

<!-- OCR_START -->
- mysql> select count(#) from s1 where
- id between 1 and 300000;
- count(#)1
- 范围大，查询速度很慢
- 6029991
- row
- in set
- (0.20 sec)
- mysql>
- select count(*) from s1 wher
- id between 1 and 3;
- count(#)
- 1
- -+
- 9
- 范围小，查询速度很快
- (0.00 sec)
<!-- OCR_END -->

like

<!-- OCR_START -->
- mysql> select count(#) from s1 where
- email="
- "xXXX"
- count(*)1
- 01
- 没有给emai字段加索引，查询速度慢
- row in set
- (0.30 sec)
- mysql> create index d on s1<email>;
- Query 0K, 0 rows affected (9.78 sec)
- Records:01
- Duplicates: 0 Warnings:0
- email='xxxx';
- ：count(#)
- 给email字段加索引后，查询速度加快
- 1
- (0.00 sec)
- nysql>
- select count() from s1 where
- email like'xxxx'
- like指定的是一个明确的值，速度依然很快
- mysql> select count(#) from s1 where email like
- like匹配的字符中有%，但是处于末尾，速度依然很快
- like匹配的字符中有%，但是处于开头，速度慢
- (0.39 sec)
<!-- OCR_END -->

 

<!-- OCR_START -->
- mysql> select count(#) from s1 where
- email="
- "xXXX"
- count(*)1
- 01
- 没有给emai字段加索引，查询速度慢
- row in set
- (0.30 sec)
- mysql> create index d on s1<email>;
- Query 0K, 0 rows affected (9.78 sec)
- Records:01
- Duplicates: 0 Warnings:0
- email='xxxx';
- ：count(#)
- 给email字段加索引后，查询速度加快
- 1
- (0.00 sec)
- nysql>
- select count() from s1 where
- email like'xxxx'
- like指定的是一个明确的值，速度依然很快
- mysql> select count(#) from s1 where email like
- like匹配的字符中有%，但是处于末尾，速度依然很快
- like匹配的字符中有%，但是处于开头，速度慢
- (0.39 sec)
<!-- OCR_END -->

**2 尽量选择区分度高的列作为索引,区分度的公式是count(distinct col)/count(*)，表示字段不重复的比例，比例越大我们扫描的记录数越少，唯一键的区分度是1，而一些状态、性别字段可能在大数据面前区分度就是0，那可能有人会问，这个比例有什么经验值吗？使用场景不同，这个值也很难确定，一般需要join的字段我们都要求是0.1以上，即平均1条扫描10条记录**

#先把表中的索引都删除，让我们专心研究区分度的问题

```plain
#先把表中的索引都删除，让我们专心研究区分度的问题
mysql> desc s1;
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| id     | int(11)     | YES  | MUL | NULL    |       |
| name   | varchar(20) | YES  |     | NULL    |       |
| gender | char(5)     | YES  |     | NULL    |       |
| email  | varchar(50) | YES  | MUL | NULL    |       |
+--------+-------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
mysql> drop index a on s1;
Query OK, 0 rows affected (0.20 sec)
Records: 0  Duplicates: 0  Warnings: 0
mysql> drop index d on s1;
Query OK, 0 rows affected (0.18 sec)
Records: 0  Duplicates: 0  Warnings: 0
mysql> desc s1;
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| id     | int(11)     | YES  |     | NULL    |       |
| name   | varchar(20) | YES  |     | NULL    |       |
| gender | char(5)     | YES  |     | NULL    |       |
| email  | varchar(50) | YES  |     | NULL    |       |
+--------+-------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
```

<!-- OCR_START -->
mysql>
select count(*) from s1 where name='xxx'
count()
1
没有为name加索引前查询速度很慢
01
row in set
(0.29 sec)
create
index b on s1（name）;
Query 0K,V rows affected (7.1y sec）
Records:0
Duplicates: 0Warnings: 0
为name字段加索引后，插叙速度貌似加快了
(0.00 sec)
select count(*)from s1 where nane=’egon′;
881126 1
如果查询条件为name='egon',查询速度又变慢了，这是为什么？？？
row
in set
(0.33 sec)
<!-- OCR_END -->

分析原因

```plain
我们编写存储过程为表s1批量添加记录，name字段的值均为egon，也就是说name这个字段的区分度很低（gender字段也是一样的，我们稍后再搭理它）
回忆b+树的结构，查询的速度与树的高度成反比，要想将树的高低控制的很低，需要保证：在某一层内数据项均是按照从左到右，从小到大的顺序依次排开，即左1<左2<左3<...
而对于区分度低的字段，无法找到大小关系，因为值都是相等的，毫无疑问，还想要用b+树存放这些等值的数据，只能增加树的高度，字段的区分度越低，则树的高度越高。极端的情况，索引字段的值都一样，那么b+树几乎成了一根棍。本例中就是这种极端的情况，name字段所有的值均为'egon'
#现在我们得出一个结论：为区分度低的字段建立索引，索引树的高度会很高，然而这具体会带来什么影响呢？？？
#1：如果条件是name='xxxx',那么肯定是可以第一时间判断出'xxxx'是不在索引树中的（因为树中所有的值均为'egon’），所以查询速度很快
#2：如果条件正好是name='egon',查询时，我们永远无法从树的某个位置得到一个明确的范围，只能往下找，往下找，往下找。。。这与全表扫描的IO次数没有多大区别，所以速度很慢
```

**3 =和in可以乱序，比如a = 1 and b = 2 and c = 3 建立(a,b,c)索引可以任意顺序，mysql的查询优化器会帮你优化成索引可以识别的形式**

**4 索引列不能参与计算，保持列“干净”，比如from_unixtime(create_time) = ’2014-05-29’就不能使用到索引，原因很简单，b+树中存的都是数据表中的字段值，但进行检索时，需要把所有元素都应用函数才能比较，显然成本太大。所以语句应该写成create_time = unix_timestamp(’2014-05-29’)**

<!-- OCR_START -->
- desc
- sl;
- Field
- ：Type
- 1 Nu1l
- 1Key
- 1Default
- 1Extra
- id
- 1
- int(11)
- YES
- NULL
- name
- varchar(20)
- MUL
- gender
- char(5)
- email
- varchar(50>
- rows in
- set (0.00 sec)
- ysql>drop
- index b on s1;
- query OK,
- ① rows affected(
- (0.18 sec)
- Records:0
- Duplicates: 0
- Warnings:0
- ysql> create index a on s1(id>;
- query 0k,0 rows affected (5.43 sec)
- ysql> desc s1;
- 1Type
- 1KeylDefault1Extra
- 1int<11>
- 1MUL
- 1NULL
- INULL
- rows in set (0.00 sec)
- mysql> select count(#)from s1
- s1
- where id=3000;
- count(#)！
- 21
- id字段有索引，于是查询速度很快
- row in set
- (0.00 sec)
- vhere id×3=3000;
- 索引字段id，参与了计算，无法拿到一个明确的值去索引树中查找，每次都得
- 临时计算一下
- 31
- (0.27 sec)
<!-- OCR_END -->

**5 and/or**

```plain
#1、and与or的逻辑
    条件1 and 条件2:所有条件都成立才算成立，但凡要有一个条件不成立则最终结果不成立
    条件1 or 条件2:只要有一个条件成立则最终结果就成立
#2、and的工作原理
    条件：
        a = 10 and b = 'xxx' and c > 3 and d =4
    索引：
        制作联合索引(d,a,b,c)
    工作原理:
        对于连续多个and：mysql会按照联合索引，从左到右的顺序找一个区分度高的索引字段(这样便可以快速锁定很小的范围)，加速查询，即按照d—>a->b->c的顺序
#3、or的工作原理
    条件：
        a = 10 or b = 'xxx' or c > 3 or d =4
    索引：
        制作联合索引(d,a,b,c)
    工作原理:
        对于连续多个or：mysql会按照条件的顺序，从左到右依次判断，即a->b->c->d
```

<!-- OCR_START -->
- mysql> desc s1;
- 1Field
- 1Type
- 1Null1Key1Default1Extra1
- id
- 1
- int(11)
- IYES
- ！MUL！
- NULL
- name
- 1varchar(20)
- gender
- |char(5)
- enail
- 1varchar(50)
- 1YES
- 1NULL
- 4 rows in set (0.00 sec)
- mysql>
- create index b on s1(name);
- 为name字段添加索引l，但是该字段的区分度低
- Query 0k,0 rows affected (6.76 sec)
- Records:0
- Duplicates: 0Warnings:0
- mysql> select count(#) from s1 where
- name='xxx
- count(×)
- name='xxx'可以很快低从索引树中区分出该字段不存在，因而
- 速度很快
- row
- in set
- (0.00 sec)
- mysql> select
- from
- s1
- where
- name='xxx'and gender=’male
- gender是非索引字段，但是name='xxx不成立，因而根本不
- 01
- 会管gender的条件，且name='xxxx'的速度很快
- row in set
<!-- OCR_END -->

在左边条件成立但是索引字段的区分度低的情况下（name与gender均属于这种情况），会依次往右找到一个区分度高的索引字段，加速查询

<!-- OCR_START -->
- mysql> select count(#) from s1 where
- name=’xxx'and gender='male′;
- count(#)1
- 01
- row
- in
- set
- (0.00 sec)
- name=′egon′ and gender=’male′
- -+
- 4033851
- in set
- (2.02 sec)
- mysql> create index c on s1<gender);
- Query OK.
- 0 rows affected (7.24 sec)
- Records:0
- Duplicates:0
- Warnings:0
- 1count(#)
- 1
- row in set
- (0.40 sec)
- name='egon’and gender=’xxx
- count(#)
- nysql>
- select
- count() from s1 where
- name='egon’and gender='male’and id =333
- 一+
- 11
- mysql>
- select count() from s1 where
- 403052
- (1.61 sec)
- name=’egon’andgender=’xxx’andid>333
<!-- OCR_END -->

<!-- OCR_START -->
- mysql> desc s1;
- Field
- ：Type
- |Null：KeylDefault：Extra1
- id
- int(11)
- YES
- 1MUL
- 1
- NULL
- name
- varchar(20)
- MUL
- 1NULL
- gender
- char(5)
- 1MUL1NULL
- email
- varchar(50)
- 1YES
- 4
- rows in set (0.D0 sec)
- mysql> select count() from s1where name=’egon’and gender='xxx'and id > 333;
- count()
- row in set (0.00 sec)
- mysql> select count() from s1where name=’egon’and gender=’male’and id >333;
- 403052
- rowin
- set (1.58 sec)
- mysql>
- select count(#) from s1where
- name=′egon′and gender=’male′and id > 333 and email=’xxx’
- 前三个条件都成立，但都无法利用索引达到加速的目的：第一个和第二个都是因为区分度低
- 而第三个是因为使用了一个很大的范围，而第四个字段emai的区分度高，但是未加索引l，所
- 01
- 以插叙速度很慢
- row:
- in set
- (1.61 sec)
- create
- index
- d on s1<email>;
- 为email字段创建索引，该字段的区分度很高
- Query
- ffected (11.03 sec)
- Records: 0
- Duplicates: 0
- Warnings: 0
- mysql> select count(*) from s1 where name='egon′ and gender='male′ and id > 333 and email='xxx';
- 速度提升明显
- (0.20 sec)
<!-- OCR_END -->

经过分析，在条件为name='egon' and gender='male' and id>333 and email='xxx'的情况下，我们完全没必要为前三个条件的字段加索引，因为只能用上email字段的索引，前三个字段的索引反而会降低我们的查询效率

<!-- OCR_START -->
- mysql> select count(*) from s1 where name='egon′ and gender='male′ and id > 333 and email=′xxx';
- count(×)1
- 01
- row in set
- (0.20 sec)
- mysql> desc s1;
- Field
- 1Type
- INull1Key1Default
- 1Extra1
- id
- 1int(11)
- IYES
- MUL
- 1
- NULL
- 1YES
- name
- 1varchar(20)
- gender
- 1char(5)
- YES
- email
- 1varchar(50>
- rows in set （0.01
- sec)
- mysql>
- drop
- index a
- on s1;
- QueryOK,
- rows aff
- ected (0.16 sec)
- Records:0
- Duplicat
- es:0
- Warnings: 0
- mysql> drop
- index b
- 0rows
- 无用索引反而会降低查询速度，让我们删掉他们
- aff
- ected
- (0.16 sec)
- s:0
- index
- s1；
- cted
- (0.23 sec)
- nysql>
- desc s1;
- |Null：Key：Default
- Extra
- varchar(2
- ！MUL !NULL
- rows
- in
- set
- (0.00
- ec）
- select count(
- from s1where name=′egon’and gender=’male’and id > 333 and email='xxx';
- count(*)
- 插叙速度很快
- r0w
- (0.00 sec)
<!-- OCR_END -->

**6 最左前缀匹配原则（详见第八小节），非常重要的原则，对于组合索引mysql会一直向右匹配直到遇到范围查询(>、<、between、like)就停止匹配(指的是范围大了，有索引速度也慢)，比如a = 1 and b = 2 and c > 3 and d = 4 如果建立(a,b,c,d)顺序的索引，d是用不到索引的，如果建立(a,b,d,c)的索引则都可以用到，a,b,d的顺序可以任意调整。**

<!-- OCR_START -->
mysql> drop index d on s1;
Query 0K,0 rows affected (0.20 sec)
Records:0
Duplicates:0
Warnings:0
mysql>
create index xxx on s1<id,name,gender,email>;
QuerybK, 0 rows affected (i3.03 sec)
mysql> select count(#) from s1 where
Rlatm
and gender=’male’and id > 333 and email='xxx';
count(#)！
01
建立索引时未将条件中关于范围比较的字段放到后面，查询速度很慢
row in set
(0.47 sec)
mysql> drop
index xxx on s1;
Query OK，
0 rows affected (0.18 sec)
create index xxx on s1<name,gender,email,id>;
Query 0K,0rows affected （1509 sec)
name=′egon′and gender=’male’and id > 333 and email=’xxx’；
建立索引时将关于范围比较的字段放到了后面，查询速度很快
row in
set
(0.00 sec)
<!-- OCR_END -->

**7 其他情况**

```plain
- 使用函数
    select * from tb1 where reverse(email) = 'egon';
- 类型不一致
    如果列是字符串类型，传入条件是必须用引号引起来，不然...
    select * from tb1 where email = 999;
#排序条件为索引，则select字段必须也是索引字段，否则无法命中
- order by
    select name from s1 order by email desc;
    当根据索引排序时候，select查询的字段如果不是索引，则速度仍然很慢
    select email from s1 order by email desc;
    特别的：如果对主键排序，则还是速度很快：
        select * from tb1 order by nid desc;
- 组合索引最左前缀
    如果组合索引为：(name,email)
    name and email       -- 命中索引
    name                 -- 命中索引
    email                -- 未命中索引
- count(1)或count(列)代替count(*)在mysql中没有差别了
- create index xxxx  on tb(title(19)) #text类型，必须制定长度
```

#### 二 其他注意事项
```plain
- 避免使用select *
- count(1)或count(列) 代替 count(*)
- 创建表时尽量时 char 代替 varchar
- 表的字段顺序固定长度的字段优先
- 组合索引代替多个单列索引（经常使用多个条件查询时）
- 尽量使用短索引
- 使用连接（JOIN）来代替子查询(Sub-Queries)
- 连表时注意条件类型需一致
- 索引散列值（重复少）不适合建索引，例：性别不适合
```

### 八 联合索引与覆盖索引
#### 一 联合索引
联合索引时指对表上的多个列合起来做一个索引。联合索引的创建方法与单个索引的创建方法一样，不同之处在仅在于有多个索引列，如下

```plain
mysql> create table t(
    -> a int,
    -> b int,
    -> primary key(a),
    -> key idx_a_b(a,b)
    -> );
Query OK, 0 rows affected (0.11 sec)
```

<!-- OCR_START -->
- (2,4)
- (1,1)(1,2)
- (2,1)
- (2,4)(3,1)
- (3,2)
<!-- OCR_END -->

那么何时需要使用联合索引呢？在讨论这个问题之前，先来看一下联合索引内部的结果。从本质上来说，联合索引就是一棵B+树，不同的是联合索引的键值得数量不是1，而是>=2。接着来讨论两个整型列组成的联合索引，假定两个键值得名称分别为a、b如图

可以看到这与我们之前看到的单个键的B+树并没有什么不同，键值都是排序的，通过叶子结点可以逻辑上顺序地读出所有数据，就上面的例子来说，即（1,1），（1,2），（2,1），（2,4），（3,1），（3,2），数据按（a,b）的顺序进行了存放。

因此，对于查询select * from table where a=xxx and b=xxx, 显然是可以使用(a,b) 这个联合索引的，对于单个列a的查询select * from table where a=xxx,也是可以使用（a,b）这个索引的。

但对于b列的查询select * from table where b=xxx,则不可以使用（a,b） 索引，其实你不难发现原因，叶子节点上b的值为1、2、1、4、1、2显然不是排序的，因此对于b列的查询使用不到(a,b) 索引

联合索引的第二个好处是在第一个键相同的情况下，已经对第二个键进行了排序处理，例如在很多情况下应用程序都需要查询某个用户的购物情况，并按照时间进行排序，最后取出最近三次的购买记录，这时使用联合索引可以帮我们避免多一次的排序操作，因为索引本身在叶子节点已经排序了，如下

```plain
#===========准备表==============
create table buy_log(
    userid int unsigned not null,
    buy_date date
);
insert into buy_log values
(1,'2009-01-01'),
(2,'2009-01-01'),
(3,'2009-01-01'),
(1,'2009-02-01'),
(3,'2009-02-01'),
(1,'2009-03-01'),
(1,'2009-04-01');
alter table buy_log add key(userid);
alter table buy_log add key(userid,buy_date);
#===========验证==============
mysql> show create table buy_log;
| buy_log | CREATE TABLE `buy_log` (
  `userid` int(10) unsigned NOT NULL,
  `buy_date` date DEFAULT NULL,
  KEY `userid` (`userid`),
  KEY `userid_2` (`userid`,`buy_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
#可以看到possible_keys在这里有两个索引可以用，分别是单个索引userid与联合索引userid_2,但是优化器最终选择了使用的key是userid因为该索引的叶子节点包含单个键值，所以理论上一个页能存放的记录应该更多
mysql> explain select * from buy_log where userid=2;
+----+-------------+---------+------+-----------------+--------+---------+-------+------+-------+
| id | select_type | table   | type | possible_keys   | key    | key_len | ref   | rows | Extra |
+----+-------------+---------+------+-----------------+--------+---------+-------+------+-------+
|  1 | SIMPLE      | buy_log | ref  | userid,userid_2 | userid | 4       | const |    1 |       |
+----+-------------+---------+------+-----------------+--------+---------+-------+------+-------+
1 row in set (0.00 sec)
#接着假定要取出userid为1的最近3次的购买记录，用的就是联合索引userid_2了，因为在这个索引中，在userid=1的情况下，buy_date都已经排序好了
mysql> explain select * from buy_log where userid=1 order by buy_date desc limit 3;
+----+-------------+---------+------+-----------------+----------+---------+-------+------+--------------------------+
| id | select_type | table   | type | possible_keys   | key      | key_len | ref   | rows | Extra                    |
+----+-------------+---------+------+-----------------+----------+---------+-------+------+--------------------------+
|  1 | SIMPLE      | buy_log | ref  | userid,userid_2 | userid_2 | 4       | const |    4 | Using where; Using index |
+----+-------------+---------+------+-----------------+----------+---------+-------+------+--------------------------+
1 row in set (0.00 sec)
#ps：如果extra的排序显示是Using filesort，则意味着在查出数据后需要二次排序
#对于联合索引（a,b）,下述语句可以直接使用该索引，无需二次排序
select ... from table where a=xxx order by b;
#然后对于联合索引(a,b,c)来首，下列语句同样可以直接通过索引得到结果
select ... from table where a=xxx order by b;
select ... from table where a=xxx and b=xxx order by c;
#但是对于联合索引(a,b,c)，下列语句不能通过索引直接得到结果，还需要自己执行一次filesort操作，因为索引（a，c)并未排序
select ... from table where a=xxx order by c;
```

#### 二 覆盖索引
**InnoDB存储引擎支持覆盖索引（covering index，或称索引覆盖），即从辅助索引中就可以得到查询记录，而不需要查询聚集索引中的记录。**

使用覆盖索引的一个好处是：辅助索引不包含整行记录的所有信息，故其大小要远小于聚集索引，因此可以减少大量的IO操作

注意：覆盖索引技术最早是在InnoDB Plugin中完成并实现，这意味着对于InnoDB版本小于1.0的，或者MySQL数据库版本为5.0以下的，InnoDB存储引擎不支持覆盖索引特性

对于InnoDB存储引擎的辅助索引而言，由于其包含了主键信息，因此其叶子节点存放的数据为（primary key1，priamey key2，...,key1，key2，...）。例如

```plain
select age from s1 where id=123 and name = 'egon'; #id字段有索引，但是name字段没有索引,该sql命中了索引，但未覆盖，需要去聚集索引中再查找详细信息。
最牛逼的情况是，索引字段覆盖了所有，那全程通过索引来加速查询以及获取结果就ok了
mysql> desc s1;
+--------+-------------+------+-----+---------+-------+
| Field | Type | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| id | int(11) | NO | | NULL | |
| name | varchar(20) | YES | | NULL | |
| gender | char(6) | YES | | NULL | |
| email | varchar(50) | YES | | NULL | |
+--------+-------------+------+-----+---------+-------+
4 rows in set (0.21 sec)
mysql> explain select name from s1 where id=1000; #没有任何索引
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+-------------+
| 1 | SIMPLE | s1 | NULL | ALL | NULL | NULL | NULL | NULL | 2688336 | 10.00 | Using where |
+----+-------------+-------+------------+------+---------------+------+---------+------+---------+----------+-------------+
1 row in set, 1 warning (0.00 sec)
mysql> create index idx_id on s1(id); #创建索引
Query OK, 0 rows affected (4.16 sec)
Records: 0 Duplicates: 0 Warnings: 0
mysql> explain select name from s1 where id=1000; #命中辅助索引，但是未覆盖索引，还需要从聚集索引中查找name
+----+-------------+-------+------------+------+---------------+--------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+--------+---------+-------+------+----------+-------+
| 1 | SIMPLE | s1 | NULL | ref | idx_id | idx_id | 4 | const | 1 | 100.00 | NULL |
+----+-------------+-------+------------+------+---------------+--------+---------+-------+------+----------+-------+
1 row in set, 1 warning (0.08 sec)
mysql> explain select id from s1 where id=1000; #在辅助索引中就找到了全部信息，Using index代表覆盖索引
+----+-------------+-------+------------+------+---------------+--------+---------+-------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key | key_len | ref | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+--------+---------+-------+------+----------+-------------+
| 1 | SIMPLE | s1 | NULL | ref | idx_id | idx_id | 4 | const | 1 | 100.00 | Using index |
+----+-------------+-------+------------+------+---------------+--------+---------+-------+------+----------+-------------+
1 row in set, 1 warning (0.03 sec)
```

**覆盖索引的另外一个好处是对某些统计问题而言的。基于上一小结创建的表buy_log,查询计划如下**

```plain
mysql> explain select count(*) from buy_log;
+----+-------------+---------+-------+---------------+--------+---------+------+------+-------------+
| id | select_type | table   | type  | possible_keys | key    | key_len | ref  | rows | Extra       |
+----+-------------+---------+-------+---------------+--------+---------+------+------+-------------+
|  1 | SIMPLE      | buy_log | index | NULL          | userid | 4       | NULL |    7 | Using index |
+----+-------------+---------+-------+---------------+--------+---------+------+------+-------------+
1 row in set (0.00 sec)
```

innodb存储引擎并不会选择通过查询聚集索引来进行统计。由于buy_log表有辅助索引，而辅助索引远小于聚集索引，选择辅助索引可以减少IO操作，故优化器的选择如上key为userid辅助索引

**对于（a,b）形式的联合索引，一般是不可以选择b中所谓的查询条件。但如果是统计操作，并且是覆盖索引，则优化器还是会选择使用该索引，如下**

```plain
#联合索引userid_2（userid,buy_date）,一般情况，我们按照buy_date是无法使用该索引的，但特殊情况下：查询语句是统计操作，且是覆盖索引，则按照buy_date当做查询条件时，也可以使用该联合索引
mysql> explain select count(*) from buy_log where buy_date >= '2011-01-01' and buy_date < '2011-02-01';
+----+-------------+---------+-------+---------------+----------+---------+------+------+--------------------------+
| id | select_type | table   | type  | possible_keys | key      | key_len | ref  | rows | Extra                    |
+----+-------------+---------+-------+---------------+----------+---------+------+------+--------------------------+
|  1 | SIMPLE      | buy_log | index | NULL          | userid_2 | 8       | NULL |    7 | Using where; Using index |
+----+-------------+---------+-------+---------------+----------+---------+------+------+--------------------------+
1 row in set (0.00 sec)
```

### 九 查询优化神器-explain
**关于explain命令相信大家并不陌生，具体用法和字段含义可以参考官网explain-output，这里需要强调rows是核心指标，绝大部分rows小的语句执行一定很快（有例外，下面会讲到）。所以优化语句基本上都是在优化rows。**

```plain
执行计划：让mysql预估执行操作(一般正确)
    all < index < range < index_merge < ref_or_null < ref < eq_ref < system/const
    id,email
    慢：
        select * from userinfo3 where name='alex'
        explain select * from userinfo3 where name='alex'
        type: ALL(全表扫描)
            select * from userinfo3 limit 1;
    快：
        select * from userinfo3 where email='alex'
        type: const(走索引)
```

[http://blog.itpub.net/29773961/viewspace-1767044/](http://blog.itpub.net/29773961/viewspace-1767044/)

### 十 慢查询优化的基本步骤
```plain
0.先运行看看是否真的很慢，注意设置SQL_NO_CACHE
1.where条件单表查，锁定最小返回记录表。这句话的意思是把查询语句的where都应用到表中返回的记录数最小的表开始查起，单表每个字段分别查询，看哪个字段的区分度最高
2.explain查看执行计划，是否与1预期一致（从锁定记录较少的表开始查询）
3.order by limit 形式的sql语句让排序的表优先查
4.了解业务方使用场景
5.加索引时参照建索引的几大原则
6.观察结果，不符合预期继续从0分析
```

### 十一 慢日志管理
```plain
慢日志
            - 执行时间 > 10
            - 未命中索引
            - 日志文件路径
        配置：
            - 内存
                show variables like '%query%';
                show variables like '%queries%';
                set global 变量名 = 值
            - 配置文件
                mysqld --defaults-file='E:\wupeiqi\mysql-5.7.16-winx64\mysql-5.7.16-winx64\my-default.ini'
                my.conf内容：
                    slow_query_log = ON
                    slow_query_log_file = D:/....
                注意：修改配置文件之后，需要重启服务
```

日志管理

```plain
MySQL日志管理
========================================================
错误日志: 记录 MySQL 服务器启动、关闭及运行错误等信息
二进制日志: 又称binlog日志，以二进制文件的方式记录数据库中除 SELECT 以外的操作
查询日志: 记录查询的信息
慢查询日志: 记录执行时间超过指定时间的操作
中继日志： 备库将主库的二进制日志复制到自己的中继日志中，从而在本地进行重放
通用日志： 审计哪个账号、在哪个时段、做了哪些事件
事务日志或称redo日志： 记录Innodb事务相关的如事务执行时间、检查点等
========================================================
一、bin-log
1. 启用
# vim /etc/my.cnf
[mysqld]
log-bin[=dir\[filename]]
# service mysqld restart
2. 暂停
//仅当前会话
SET SQL_LOG_BIN=0;
SET SQL_LOG_BIN=1;
3. 查看
查看全部：
# mysqlbinlog mysql.000002
按时间：
# mysqlbinlog mysql.000002 --start-datetime="2012-12-05 10:02:56"
# mysqlbinlog mysql.000002 --stop-datetime="2012-12-05 11:02:54"
# mysqlbinlog mysql.000002 --start-datetime="2012-12-05 10:02:56" --stop-datetime="2012-12-05 11:02:54" 
按字节数：
# mysqlbinlog mysql.000002 --start-position=260
# mysqlbinlog mysql.000002 --stop-position=260
# mysqlbinlog mysql.000002 --start-position=260 --stop-position=930
4. 截断bin-log（产生新的bin-log文件）
a. 重启mysql服务器
b. # mysql -uroot -p123 -e 'flush logs'
5. 删除bin-log文件
# mysql -uroot -p123 -e 'reset master' 
二、查询日志
启用通用查询日志
# vim /etc/my.cnf
[mysqld]
log[=dir\[filename]]
# service mysqld restart
三、慢查询日志
启用慢查询日志
# vim /etc/my.cnf
[mysqld]
log-slow-queries[=dir\[filename]]
long_query_time=n
# service mysqld restart
MySQL 5.6:
slow-query-log=1
slow-query-log-file=slow.log
long_query_time=3
查看慢查询日志
测试:BENCHMARK(count,expr)
SELECT BENCHMARK(50000000,2*3);
```

# 8.8 本章小结
## 8.8.1 章节作业
### 一、表关系
请创建如下表，并创建相关约束

| | | | | | | | |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 班级表：class | | | | 学生表：student | | | |
| cid | caption | grade_id | | sid | sname | gender | class_id |
| 1 | 一年一班 | 1 | | 1 | 乔丹 | 女 | 1 |
| 2 | 二年一班 | 2 | | 2 | 艾弗森 | 女 | 1 |
| 3 | 三年二班 | 3 | | 3 | 科比 | 男 | 2 |
| | | | | | | | |
| 老师表：teacher | | | | 课程表：course | | | |
| tid | tname | | | cid | cname | teacher_id | |
| 1 | 张三 | | | 1 | 生物 | 1 | |
| 2 | 李四 | | | 2 | 体育 | 1 | |
| 3 | 王五 | | | 3 | 物理 | 2 | |
| | | | | | | | |
| 成绩表：score | | | | | 年级表：class_grade | | |
| sid | student_id | course_id | score | | gid | gname | |
| 1 | 1 | 1 | 60 | | 1 | 一年级 | |
| 2 | 1 | 2 | 59 | | 2 | 二年级 | |
| 3 | 2 | 2 | 99 | | 3 | 三年级 | |
| | | | | | | | |
| 班级任职表：teach2cls | | | | | | | |
| tcid | tid | cid | | | | | |
| 1 | 1 | 1 | | | | | |
| 2 | 1 | 2 | | | | | |
| 3 | 2 | 1 | | | | | |
| 4 | 3 | 2 | | | | | |

### 二、操作表
1、自行创建测试数据；

2、查询学生总人数；

3、查询“生物”课程和“物理”课程成绩都及格的学生id和姓名；

4、查询每个年级的班级数，取出班级数最多的前三个年级；

5、查询平均成绩最高和最低的学生的id和姓名以及平均成绩；

6、查询每个年级的学生人数；

7、查询每位学生的学号，姓名，选课数，平均成绩；

8、查询学生编号为“2”的学生的姓名、该学生成绩最高的课程名、成绩最低的课程名及分数；

9、查询姓“李”的老师的个数和所带班级数；

10、查询班级数小于5的年级id和年级名；

11、查询班级信息，包括班级id、班级名称、年级、年级级别(12为低年级，34为中年级，56为高年级)，示例结果如下；

| 班级id | 班级名称 | 年级 | 年级级别 |
| --- | --- | --- | --- |
| 1 | 一年一班 | 一年级 | 低 |

12、查询学过“张三”老师2门课以上的同学的学号、姓名；

13、查询教授课程超过2门的老师的id和姓名；

14、查询学过编号“1”课程和编号“2”课程的同学的学号、姓名；

15、查询没有带过高年级的老师id和姓名；

16、查询学过“张三”老师所教的所有课的同学的学号、姓名；

17、查询带过超过2个班级的老师的id和姓名；

18、查询课程编号“2”的成绩比课程编号“1”课程低的所有同学的学号、姓名；

19、查询所带班级数最多的老师id和姓名；

20、查询有课程成绩小于60分的同学的学号、姓名；

21、查询没有学全所有课的同学的学号、姓名；

22、查询至少有一门课与学号为“1”的同学所学相同的同学的学号和姓名；

23、查询至少学过学号为“1”同学所选课程中任意一门课的**其他同学**学号和姓名；

24、查询和“2”号同学学习的课程完全相同的其他同学的学号和姓名；

25、删除学习“张三”老师课的score表记录；

26、向score表中插入一些记录，这些记录要求符合以下条件：①没有上过编号“2”课程的同学学号；②插入“2”号课程的平均成绩；

27、按平均成绩从低到高显示所有学生的“语文”、“数学”、“英语”三门的课程成绩，按如下形式显示： 学生ID,语文,数学,英语,有效课程数,有效平均分；

28、查询各科成绩最高和最低的分：以如下形式显示：课程ID，最高分，最低分；

29、按各科平均成绩从低到高和及格率的百分数从高到低顺序；

30、课程平均分从高到低显示（现实任课老师）；

31、查询各科成绩前三名的记录(不考虑成绩并列情况)

32、查询每门课程被选修的学生数；

33、查询选修了2门以上课程的全部学生的学号和姓名；

34、查询男生、女生的人数，按倒序排列；

35、查询姓“张”的学生名单；

36、查询同名同姓学生名单，并统计同名人数；

37、查询每门课程的平均成绩，结果按平均成绩升序排列，平均成绩相同时，按课程号降序排列；

38、查询课程名称为“数学”，且分数低于60的学生姓名和分数；

39、查询课程编号为“3”且课程成绩在80分以上的学生的学号和姓名；

40、求选修了课程的学生人数

41、查询选修“王五”老师所授课程的学生中，成绩最高和最低的学生姓名及其成绩；

42、查询各个课程及相应的选修人数；

43、查询不同课程但成绩相同的学生的学号、课程号、学生成绩；

44、查询每门课程成绩最好的前两名学生id和姓名；

45、检索至少选修两门课程的学生学号；

46、查询没有学生选修的课程的课程号和课程名；

47、查询没带过任何班级的老师id和姓名；

48、查询有两门以上课程超过80分的学生id及其平均成绩；

49、检索“3”课程分数小于60，按分数降序排列的同学学号；

50、删除编号为“2”的同学的“1”课程的成绩；

51、查询同时选修了物理课和生物课的学生id和姓名；

> 更新: 2022-08-01 18:24:54  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/agxeb4>