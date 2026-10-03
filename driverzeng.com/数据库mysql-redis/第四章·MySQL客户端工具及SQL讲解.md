# 第四章· MySQL客户端工具及SQL讲解

## 一.客户端命令介绍

***mysql***

* 1、用于数据库的连接管理

> 1） 连接（略）
>
> 2） 管理：

```sql
#MySQL接口自带的命令
\h 或 help 或？      查看帮助
\G                  格式化查看数据（key：value）
\T 或 tee            记录日志
\c（5.7可以ctrl+c）   结束命令
\s 或 status         查看状态信息
\. 或 source         导入SQL数据
\u或 use             使用数据库
\q 或 exit 或 quit   退出
```

> 3）接收用户的SQL语句

* 2、将用户的SQL语句发送到服务器

***mysqladmin***

* 1、命令行管理工具

***mysqldump***

* 1、备份数据库和表的内容

***help命令的使用***

```sql
mysql> help
mysql> help contents
mysql> help select
mysql> help create
mysql> help create user
mysql> help status
mysql> help show
```

***source命令的使用***

```sql
#在MySQL中处理输入文件：
#如果这些文件包含SQL语句则称为：
#1.脚本文件
#2.批处理文件
mysql> SOURCE /data/mysql/world.sql
#或者使用非交互式
mysql</data/mysql/world.sql
```

***mysqladmin命令的使用***

> 01）“强制回应 (Ping)”服务器。
>
> 02）关闭服务器。
>
> 03）创建和删除数据库。
>
> 04）显示服务器和版本信息。
>
> 05）显示或重置服务器状态变量。
>
> 06）设置口令。
>
> 07）重新刷新授权表。
>
> 08）刷新日志文件和高速缓存。
>
> 09）启动和停止复制。
>
> 10）显示客户机信息。

```bash
#查看MySQL存活状态
mysqladmin -uroot -p123 ping
#查看MySQL状态信息
mysqladmin -uroot -p123 status
#关闭MySQL进程
mysqladmin -uroot -p123 shutdown
#查看MySQL参数
mysqladmin -uroot -p123 variables
#删除数据库
mysqladmin -uroot -p123 drop DATABASE
#创建数据库
mysqladmin -uroot -p123 create DATABASE
#重载授权表
mysqladmin -uroot -p123 reload
#刷新日志
mysqladmin -uroot -p123 flush-log
#刷新缓存主机
mysqladmin -uroot -p123 reload
#修改口令
mysqladmin -uroot -p123 password
```

## 二.接收用户的SQL语句

* 1.什么是SQL

结构化的查询语句

* 2.SQL的种类

### DDL：（Data Definition Language）数据定义语言

**库对象：库名字、库属性**

开发规范：库名小写

*创建库：create database|schema*

```sql
-- 创建oldboy数据库;
create database oldboy;
#创建OLDBOY数据库
create database OLDBOY;
#查看数据库
show databases;
#查看oldboy的创建语句（DQL）
show create database oldboy;
#查看创建数据库语句帮助
help create database
#创建oldboy数据库添加属性
create database testa charset utf8;
create database testa charset utf8mb4;

```

*删库：drop database*

```sql
-- #删除oldboy数据库;
drop database oldboy;
```

*修改定义库：alter database*

```sql
-- 修改oldboy数据库属性;
alter database oldboy charset gbk;

-- 查看oldboy的创建语句（DQL）;
show create database oldboy;

```

**表对象:列名、列属性、约束**

*创建表：create table （开发做）*

```sql
-- #查看创建表语句帮助;
help create table

-- #创建表;
mysql> create table student(
  sid INT,
  sname VARCHAR(20),
  sage TINYINT,
  sgender ENUM('m','f'),
  cometime DATETIME);

```

> 数据类型
>
> int： 整数 -2<sup>31</sup> ~ 2<sup>31</sup> -1
>
> varchar：字符类型 （变长）
>
> char： 字符类型 （定长）
>
> tinyint： 整数 -128 ~ 128
>
> enum： 枚举类型
>
> datetime： 时间类型 年月日时分秒

```sql
-- #创建表加其他属性;
create table student(
sid INT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT ‘学号’,
sname VARCHAR(20) NOT NULL COMMENT ‘学生姓名’,
sage TINYINT UNSIGNED COMMENT ‘学生年龄’,
sgender ENUM('m','f')  NOT NULL DEFAULT ‘m’ COMMENT ‘学生性别’,
cometime DATETIME NOT NULL COMMENT ‘入学时间’)chatset utf8 engine innodb;

-- #查看建表语句;
show create table student;
-- #查看表;
show tables;
-- #查看表中列的定义信息;
desc student;

```

> 数据属性
>
> not null： 非空
>
> primary key： 主键（唯一且非空的）
>
> auto_increment： 自增（此列必须是：primary key或者unique key）
>
> unique key： 单独的唯一的
>
> default： 默认值
>
> unsigned： 非负数
>
> comment： 注释

*删除表*

```sql
-- #删除表;
drop table student;

```

*修改表定义：alter table （开发做）*

```sql
-- #修改表名;
alter table student rename stu;
-- #添加列和列定义;
alter table stu add age int;
--#添加多个列;
alter table stu add test varchar(20),add qq int;
-- #指定位置进行添加列（表首）;
alter table stu add classid varchar(20) first;
-- #指定位置进行添加列（指定列）;
alter table stu add phone int after age;
-- #删除指定的列及定义;
alter table stu drop qq;
-- #修改列及定义（列属性）;
alter table stu modify sid varchar(20);
-- #修改列及定义（列名及属性）;
alter table stu change phone telphone char(20);
```

### DCL：（Data Control Language）数据控制语言

**针对权限进行控制**

*grant*

```sql
-- #授权root@10.0.0.51用户所有权限（非炒鸡管理员）;
grant all on *.* to root@'10.0.0.51' identified by 'oldboy123';
-- #怎么去授权一个炒鸡管理员呢？;
grant all on *.* to root@'10.0.0.51' identified by 'oldboy123' with grant option;

-- #其他参数（扩展）;
max_queries_per_hour：一个用户每小时可发出的查询数量
max_updates_per_hour：一个用户每小时可发出的更新数量
max_connetions_per_hour：一个用户每小时可连接到服务器的次数
max_user_connetions： 允许同时连接数量
```

*revoke*

```sql
-- #收回select权限
revoke select on *.* from root@'10.0.0.51';

-- #查看权限
show grants for root@'10.0.0.51';

```

### DML：（Data Manipulation Language）数据操作语言

**操作表的数据行信息**

*insert*

```sql
-- #基础用法，插入数据
insert into stu values('linux01',1,NOW(),'zhangsan',20,'m',NOW(),110,123456);

-- #规范用法，插入数据
insert into stu(classid,birth.sname,sage,sgender,comtime,telnum,qq) values('linux01',1,NOW(),'zhangsan',20,'m',NOW(),110,123456);

-- #插入多条数据
insert into stu(classid,birth.sname,sage,sgender,comtime,telnum,qq) values('linux01',1,NOW(),'zhangsan',20,'m',NOW(),110,123456),
('linux02',2,NOW(),'zhangsi',21,'f',NOW(),111,1234567);

```

*update*

```sql
-- #不规范
update student set sgender='f';
-- #规范update修改
update student set sgender='f' where sid=1;
-- #如果非要全表修改
update student set sgender='f' where 1=1;

```

*delete*

```sql
-- #不规范
delete from student;

-- #规范删除（危险）
delete from student where sid=3;

-- #DDL删除表
-- 如果你需要删除表中的所有行，并且不需要回滚操作，TRUNCATE 是一个更快的选择;
truncate table student;

```

* 1、使用伪删除

**使用update代替delete**

1）额外添加一个状态列

```sql
alter table student add status enum(1,0) default 1;

```

2）使用update

```sql
update student set status='0' where sid=1;

```

3）应用查询存在的数据

```sql
select * from student where status=1;

```

* 2、使用触发器（了解）

> trigger

### DQL：（Data Query Language）数据查询语言

[附件: world.sql](./attachments/附件-Navicat for MySQL王满源提供的不用安装/world.sql)

*select：基础用法*

```sql
# https://dev.mysql.com/doc/index-other.html
# Example Databases 下载
# wget https://downloads.mysql.com/docs/world-db.tar.gz
# tar xf world-db.tar.gz && cd world-db
# mysql -uroot -proot123 < world.sql

-- 先认识 world 库的 3 张表（关联字段）
-- 1. city  城市表    关键字段：ID(主键)、Name(城市名)、CountryCode(国家编码)
-- 2. country 国家表  关键字段：Code(国家编码,主键)、Name(国家名)、Continent(洲)
-- 3. countrylanguage 语言表 关键字段：CountryCode(国家编码)、Language(语言)
-- 关联关系：city.CountryCode = country.Code
--          countrylanguage.CountryCode = country.Code

use world;
-- #基础查询

-- 1. 查询所有数据 *代表所有列
SELECT * FROM city;
-- 2. 查询指定列
SELECT Name, Population FROM city;
-- 3. 去重查询 DISTINCT
SELECT DISTINCT Continent FROM country;

-- 条件查询
-- 1. 查询中国(CN)的所有城市
SELECT * FROM city WHERE CountryCode='CHN';
-- 2. 查询人口大于100万的城市
SELECT * FROM city WHERE Population > 1000000;
-- 3. 多条件 and/or
SELECT * FROM city WHERE CountryCode='CHN' AND Population>50000;

-- 排序 ORDER BY / 分页 LIMIT
-- 1. 按人口降序排序（大→小）
SELECT * FROM city ORDER BY Population DESC;
-- 2. 查询前10条数据
SELECT * FROM city LIMIT 10;
SELECT * FROM city LIMIT 2,2;

-- #排序查询（顺序）
select id,name,population,countrycode from city order by countrycode limit 10;
-- #排序查询（倒叙）
select id,name,population,countrycode from city order by countrycode desc limit 10;

-- #模糊查询
select name,population,countrycode from city where countrycode like '%H%' limit 10;

-- #范围查询(>,<,>=,<=,<>)
select * from city where population>=1410000;
-- #范围查询OR语句
select * from city where countrycode='CHN' or countrycode='USA';
-- #范围查询IN语句
select * from city where countrycode in ('CHN','USA');

-- 分组统计 GROUP BY + 聚合函数
-- 统计每个国家的城市数量
SELECT CountryCode, COUNT(*) AS city_count FROM city GROUP BY CountryCode;

-- 1. 内连接 INNER JOIN（取交集，两张表都匹配的数据）
-- 作用：只查询相互匹配的数据

-- 查询：城市名 + 对应的国家名
SELECT 
	c.Name AS 城市名, 
	cou.Name AS 国家名 
FROM city c 
INNER JOIN country cou 
ON c.CountryCode = cou.Code; -- 关联条件：国家编码相等

-- 2. 左连接 LEFT JOIN（左表全显示，右表匹配，不匹配为 NULL）
-- 作用：左表数据全部保留，右表有就显示，没有显示 NULL
-- 左表：country 国家表
-- 右表：countrylanguage 语言表
-- 查询：所有国家 + 对应的官方语言（没有语言也显示国家）
SELECT 
  cou.Name AS 国家名,
  cl.Language AS 语言
FROM country cou
LEFT JOIN countrylanguage cl 
ON cou.Code = cl.CountryCode;

-- 3. 右连接 RIGHT JOIN（右表全显示，左表匹配）
-- 作用：右表数据全部保留，左表匹配
-- 右表：city 城市表 全显示
-- 左表：country 匹配显示
SELECT 
  cou.Name AS 国家名,
  c.Name AS 城市名
FROM country cou
RIGHT JOIN city c 
ON cou.Code = c.CountryCode;

-- 子查询(查询嵌套)
-- 查询人口最多的城市
SELECT * FROM city 
WHERE Population = (SELECT MAX(Population) FROM city);
```

## 三.字符集定义

* 1.什么是字符集（Charset）

字符集：是一个系统支持的所有抽象字符的集合。字符是各种文字和符号的总称，包括各国家文字、标点符号、图形符号、数字等。

<!-- OCR_START -->
- GB2312简体中文编码表
- 准电码本
<!-- OCR_END -->

* 2.MySQL数据库的字符集

> 1）字符集（CHARACTER）
>
> 2）排序规则（COLLATION）

* 3.MySQL中常见的字符集

> 1）UTF8
>
> 2）LATIN1
>
> 3）GBK

* 4.常见排序规则

> 1）ci：大小写不敏感
>
> 2）cs或bin：大小写敏感

* 5.我们可以使用以下命令查看

```sql
mysql> show charset;
mysql> show collation;

```

## 四.字符集设置

* 1.操作系统级别

```sql
[root@db01 ~]# source /etc/sysconfig/i18n
[root@db01 ~]# echo $LANG
zh_CN.UTF-8
```

* 2.操作系统客户端级别（SSH）
* 3.MySQL实例级别

*方法1：在编译安装时候就指定如下服务器端字符集。*

```sql
cmake . 
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \

```

*方法2：在配置文件中设置字符集*

```sql
[mysqld]
character-set-server=utf8

```

* 4.建库级别

```sql
create database oldboy charset utf8 default collate = utf8_general_ci;
create database oldboy charset utf8mb4 default collate = utf8mb4_unicode_ci;

```

* 5.建表级别

```sql
CREATE TABLE `test` (
`id` int(4) NOT NULL AUTO_INCREMENT,
`name` char(20) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

```

***

***思考问题：如果在生产环境中，字符集不够用或者字符集不合适该怎么处理？***

***

**生产环境更改数据库（含数据）字符集的方法**

```sql
alter database oldboy CHARACTER SET utf8 collate utf8_general_ci;
alter table t1 CHARACTER SET utf8;

```

## 五.select的高级用法（扩展）

* 1.多表连接查询（连表查询）

<!-- OCR_START -->
- Stuno
- 老男孩教育
- Stuname
- 05001
- Stubirth
- oldboyedu.com
- 张三
- 05002
- Stusex
- 1988-12-12
- 李四
- StuAddr
- 05003
- StuTel
- 1987-06-05
- 王五
- 江苏南京
- 05004
- 1
- 12345
- 1987-12-01
- 赵六
- 上海
- 05005
- 1986-02-23
- 12346
- 学生表
- 北京
- 05006
- 12347
- 孙七
- 1988-04-01
- 广东深圳
- 12348
- 1988-07-031
- 重庆
- 12349
- 湖北武汉
- score
- Classno
- (Null)
- 95
- 001
- 90
- 002
- 88
- 003
- 91
- Classname
- 2成绩表
- 93
- 计算机
- 日语
- 英语
- 课程表
- 73
- 58
- 47
- 61
- 59
<!-- OCR_END -->

集合：

\[zhang3,li4,wang5]

\[50,70,80]

t1:

sid 1 2 3

sname zhang3 li4 wang5

t2:

sid 1 2 3

mark 50 70 80

*范式：* 减少数据冗余，防止产生一致性问题，把一个表作为一个原子，把一张表拆到不能再拆为止。（开发阶段设计规范）

**例：根据两张表的内容查出张三的成绩**

```sql
select t1.sname,t2.mark from t1,t2 where t1.sid=t2.sid and t1.sname=’zhang3’;

```

**1.1传统连接（只能内连接，只能取交集）**

```sql
#世界上小于100人的人口城市是哪个国家的？
select city.name,city.countrycode,country.name 
from city,country 
where city.countrycode=country.code 
and city.population<100;

```

**1.2 NATURAL　JOIN（自连接的表要有共同的列名字）**

```sql
SELECT city.name,city.countrycode ,countrylanguage.language ,city.population
FROM  city NATURAL  JOIN  countrylanguage 
WHERE population > 1000000
ORDER BY population;

```

**1.3企业中多表连接查询（内连接）**

```sql
select city.name,city.countrycode,country.name 
from city join country on city.countrycode=country.code 
where city.population<100;

```

**建议：使用join语句时，小表在前，大表在后。**

****

**1.4外连接**

```sql
select city.name,city.countrycode,country.name 
from city left join country 
on city.countrycode=country.code 
and city.population<100;

```

**1.5 UNION（合并查询）**

```sql
用途：把多个「完全不同的查询」结果，拼到一张表里展示
UNION：合并 + 自动去重（速度慢）
UNION ALL：合并 + 不去重（速度快，生产首选）
MySQL 5.6 版本有硬性规定：UNION 里的每个 SELECT 带 LIMIT，必须加括号 () 包裹！

#范围查询OR语句
mysql> select * from city where countrycode='CHN' or countrycode='USA';
#范围查询IN语句
mysql> select * from city where countrycode in ('CHN','USA');
替换为：
mysql> (select * from city where countrycode='CHN' limit 2) 
union  all
(select * from city where countrycode='USA' limit 2);

```

> union：去重复合并
>
> union all ：不去重复
>
> 使用情况：union\<union all

## mysql 字符集

MySQL 支持多种字符集（character sets）和排序规则（collations），允许用户根据需要存储和处理不同语言和字符的数据。字符集定义了字符的编码方式，而排序规则定义了字符集内字符的排序和比较规则。

### 常见的字符集

1.**latin1**：也称为 ISO-8859-1，支持西欧语言字符，包括英语、德语、法语等。

2.**utf8**：支持 Unicode 字符集的子集，可以表示大部分语言的字符。在 MySQL 5.5.3 之前，`utf8` 字符集仅支持最多三个字节的 Unicode 字符。

3.**utf8mb4**：是 `utf8` 的超集，支持最多四个字节的 Unicode 字符，包括表情符号（emojis）和其他一些特殊字符。

4.**gbk**：支持简体中文字符。

5.**gb2312**：支持简体中文字符，但支持的字符范围比 `gbk` 小。

6.**big5**：支持繁体中文字符。

### 常见的排序规则

1.**latin1_swedish_ci**：`latin1` 字符集的默认排序规则，不区分大小写。

2.**utf8_general_ci**：`utf8` 字符集的默认排序规则，不区分大小写。

3.**utf8mb4_unicode_ci**：`utf8mb4` 字符集的排序规则之一，不区分大小写。

4.**utf8mb4_bin**：`utf8mb4` 字符集的二进制排序规则，区分大小写。

5.**gbk_chinese_ci**：`gbk` 字符集的默认排序规则，不区分大小写。

6.**gb2312_chinese_ci**：`gb2312` 字符集的默认排序规则，不区分大小写。

### 如何设置字符集和排序规则

```sql
-- 创建数据库时指定字符集和排序规则;
CREATE DATABASE mydb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建表时指定字符集和排序规则;
CREATE TABLE mytable (
    id INT PRIMARY KEY,
    name VARCHAR(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 为列指定字符集和排序规则;
CREATE TABLE mytable (
    id INT PRIMARY KEY,
    name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
);

```

  

## navicat 绿色版

\[附件: Navicat for MySQL王满源提供的不用安装.zip]\(./attachments/附件-Navicat for MySQL王满源提供的不用安装/Navicat for MySQL王满源提供的不用安装.zip)

> 更新: 2026-06-05 16:26:46  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/nlcmqv>