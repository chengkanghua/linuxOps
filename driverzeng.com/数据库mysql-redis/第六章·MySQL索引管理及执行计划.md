# 第六章· MySQL索引管理及执行计划

## 一.索引介绍
 

**1.什么是索引**

<!-- OCR_START -->
- 目录
- 第1章Linux系统介绍与环境搭建准备/1
- Linux
- 1.1Linux简介/1
- 1.1.1什么是操作系统/1
- 1.1.2什么是Linux/2
- 1.2Linux的起源/3
- Leatn Linux Operatio
- ithOid3o
- 跟老男孩
- 1.2.1UNIX的历史/3
- Web Cluser Practice
- uX运维
- 1.2.2UNIX的5大优秀特性/4
- 学Linux运维
- 1.2.3UNIX操作系统的革命/4
- 1.2.4Linux的诞生/5
- Web集群实战
- 1.2.5Linux的发展历程/5
- 老0蛋
- 1.3Linux核心概念知识/6
- 1.3.1自由软件与FSF/6
- 世家十多年的场单实店
- 1.3.2GNU知识/7
- 实润误，不级济解了W
- 1.3.3GPL知识/8
- 收点地出加决万，开导
- 1.3.4Linux系统组成/8
- 1.4Linux的特点/8
- 1.4.1Linux为什么受欢迎/8
- 试读
- 1.4.2Linux更多特点介绍/9
<!-- OCR_END -->

> 1）索引就好比一本书的目录，它能让你更快的找到自己想要的内容。
>
> 2）让获取的数据更有目的性，从而提高数据库检索数据的性能。
>

**2.索引类型介绍**

> 1)BTREE:B+树索引
>
> 2)HASH：HASH索引
>
> 3)FULLTEXT：全文索引
>
> 4)RTREE：R树索引
>

<!-- OCR_START -->
- 28
- 65
- DATA
- P1
- P2
- P3
- 10
- 20
- 35
- 56
- 80
- 90
- 15
- 26
- 30
- 38
- 60
- 73
- 85
- 96
- 18
- 27
- 33
- 50
- 63
- 79
- 88
- 99
<!-- OCR_END -->

图1·B+tree索引

<!-- OCR_START -->
- 5
- 28
- 65
- DATA
- P1
- P2
- P3
- 10
- 20
- 35
- 56
- 80
- 90
- 15
- 26
- 30
- 38
- 60
- 73
- 85
- 96
- 18
- 27
- 33
- 50
- 63
- 79
- 88
- 99
<!-- OCR_END -->

图2·B*tree索引

****

**3.索引管理**

> 索引建立在表的列上(字段)的。
>
> 在where后面的列建立索引才会加快查询速度。
>
> pages<---索引（属性）<----查数据。
>

+ 1、索引分类：

> 主键索引
>
> 普通索引*****
>
> 唯一索引
>
> 
>

+ 2、添加索引：

```sql
#创建索引
alter table test add index index_name(name);
#创建索引
create index index_name on test(name);
#查看索引
desc table;
#查看索引
show index from table;
#删除索引
alter table test drop key index_name;
#添加主键索引（略）
#添加唯一性索引
alter table student add unique key uni_xxx(xxx);

#查看表中数据行数
select count(*) from city;
#查看去重数据行数
select count(distinct name) from city;

```

+ 3、前缀索引和联合索引

**前缀索引**

_根据字段的前N个字符建立索引_

```sql
alter table test add index idx_name(name(10));

```

> 避免对大列建索引
>
> 如果有，就使用前缀索引
>

**联合索引**

_多个字段建立一个索引_

> 例：
>
> where a.女生 and b.身高 and c.体重 and d.身材好
>
> index(a,b,c)
>
> 特点：前缀生效特性
>
> a,ab,ac,abc,abcd 可以走索引或部分走索引
>
> b bc bcd cd c d ba ... 不走索引
>

**原则：把最常用来做为条件查询的列放在最前面**

```sql
#创建people表
create table people (id int,name varchar(20),age tinyint,money int ,gender enum('m','f'));
#创建联合索引
alter table people add index idx_gam(gender,age,money);

```

## 二.explain详解

**explain命令使用方法**

```sql
# https://dev.mysql.com/doc/index-other.html
# Example Databases 下载
# wget https://downloads.mysql.com/docs/world-db.tar.gz
# tar xf world-db.tar.gz && cd world-db
# mysql -uroot -proot123 < world.sql

use world;
explain select name,countrycode from city where id=1;

--------------------------------------------------------------------------------
3306 [world]>explain select name,countrycode from city where id=1 \G;
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: city
   partitions: NULL
         type: const
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 4
          ref: const
         rows: 1
     filtered: 100.00
        Extra: NULL
1 row in set, 1 warning (0.00 sec)

# 逐条解析 \G 结果
id:1                # 单表简单SQL，查询编号1
select_type:SIMPLE   # 无子查询、无union，普通简单查询
table:city           # 查询目标表city
type:const           # 主键精准等值，常量查询，最优级别，仅定位1行
possible_keys:PRIMARY# 优化器可选索引：主键索引
key:PRIMARY          # 实际执行使用主键索引
key_len:4            # id为int(4字节)，索引占用4字节
ref:const            # 索引匹配常量：where id=1
rows:1               # 预估扫描仅1行
Extra:NULL           # 无额外操作：无回表、无排序、无临时表

MYSQL 5.6.40 没有显示
partitions: 如果表使用了分区，这里会显示分区名。这里为 NULL，表示表没有分区。
filtered ： 查出数据符合条件的百分比

```

****

**explain命令应用**

```plsql
explain select name,countrycode from city where id=1;

3306 [world]>explain select name,countrycode from city where id=1 \G;
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: city
         type: const
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 4
          ref: const
         rows: 1
        Extra: NULL
1 row in set (0.00 sec)

# 逐条解析 \G 结果
id:1                 # 单表简单SQL，查询编号1
select_type:SIMPLE   # 无子查询、无union，普通简单查询
table:city           # 查询目标表city
type:const           # 主键精准等值，常量查询，最优级别，仅定位1行
possible_keys:PRIMARY# 优化器可选索引：主键索引
key:PRIMARY          # 实际执行使用主键索引；   实际使用索引名
key_len:4            # id为int(4字节)，索引占用4字节 → 判断联合索引用了几个字段  
ref:const            # 索引匹配常量：where id=1；索引匹配来源；三种取值：const、字段名、func
rows:1               # 预估扫描仅1行， 越少越好
Extra:NULL           # 无额外操作：无回表、无排序、无临时表

-- select_type 查询类型
类型	           说明                        示例 SQL
SIMPLE	        简单查询，无子查询、无 union   
-- EXPLAIN SELECT name FROM city WHERE id=1;
PRIMARY	        最外层主SQL       
-- EXPLAIN SELECT name FROM city WHERE id=(SELECT MAX(id) FROM city);
SUBQUERY	    WHERE里子查询    
-- EXPLAIN SELECT * FROM city WHERE countrycode=(SELECT code FROM country LIMIT 1);
DERIVED			FROM里派生临时表 (子查询生成临时表)  
-- EXPLAIN SELECT a.* FROM (SELECT * FROM city LIMIT 10) a;
UNION			union后面的 SQL    
-- EXPLAIN SELECT id FROM city WHERE id<10 UNION SELECT id FROM city WHERE id>100;
UNION RESULT	union合并结果集   
-- 同上 UNION 语句最后一行自动生成 UNION RESULT

-- type【重中之重：访问类型，性能优先级从优→劣】常见类型
system > const > eq_ref > ref > range > index > ALL
# system：系统表，仅1行数据，极罕见
# const：主键/唯一索引精准匹配，常量，仅匹配1行(=固定值)
# eq_ref：关联查询主键/唯一索引，关联每条只匹配1行（多表join最优）
# ref：普通索引等值匹配，命中多行（最常用）
# range：索引范围查询 > < between in like '前缀%'，用到索引范围段
# index：全索引树扫描（只扫索引不回表，优于全表）
# ALL：全表扫描【重点优化目标】
生产底线：至少 range/ref，杜绝 ALL

-- Extra 
# 1.Using index ✅ 覆盖索引，无回表，最优
# 2.Using filesort ❌ 文件排序：无法用索引排序，需要额外排序(ORDER BY没走索引)
# 3.Using temporary ❌ 临时表：GROUP BY/UNION创建临时内存/磁盘表
# 4.Using where：存储引擎取数后在server层过滤(正常现象)
# 5.Using join buffer：join没走索引，使用连接缓冲区
# 6.Impossible where：where条件永远不成立，无结果

如果出现Using filesort请检查order by ,group by ,distinct,join 条件列上没有索引
explain select * from city where countrycode='CHN' order by population;
当order by语句中出现Using filesort，那就尽量让排序值在where条件中出现	
explain select * from city where population>30000000 order by population;
		select * from city where population=2870300 order by population;

-- type详细介绍
## 1.system（最优，极少出现）
# 表只有1条数据、系统元数据表，MyISAM/Memory常见
# 场景：系统表、表数据总行数=1
## 2.const（主键/唯一索引精准等值 =常量，你刚才 id=1 就是）
# 条件：主键/UNIQUE索引 等值查询 where id=1
# 特征：优化器预转为常量，rows=1
## 3.eq_ref（多表JOIN顶级）
# JOIN时：被关联字段是主键/唯一索引，每条匹配唯一一行
# 示例：city JOIN country ON city.countrycode=country.code（code主键）
# 一一对应，每条只命中1行
## 4.ref（普通索引等值，开发最常用）
# 普通单列/联合索引等值匹配，可命中多行
# where username='test'  username建普通索引
-- ## 5.ref_or_null（ref变种）
# 索引字段等值+可查NULL：where phone='138' or phone is null
# 字段建有索引且允许NULL
-- ## 6.fulltext（全文索引专属）
# MATCH(col) AGAINST('关键词') 使用全文索引
## 7.range（索引范围查询）
# > < >= <= between in() like '前缀%'
# where id>100 and id<200
# 走索引区间扫描，优于全表
## 8.index（整棵索引树全扫，比ALL快）
# 只访问索引字段（覆盖索引但全索引遍历），不走聚簇数据
# select id from user; id是主键，遍历整棵主键索引
## 9.ALL（全表扫描，最差，优化重点）
# 没任何可用索引，从头到尾扫整表数据
# where status=1 status无索引 → type=ALL

# 了解
-- NULL：MySQL在优化过程中分解语句，执行时甚至不用访问表或索引，例如从一个索引列里选取最小值可以通过单独索引查找完成。
-- explain select * from city where id=1000000000000000000000000000;
-- explain select * from city where 1=2; # 同样Impossible WHERE，type全NULL

```

## 三.建立索引的原则（规范）
 

### 索引创建6条规范
```bash
# 索引创建精简6条规范
## 1.优先唯一/主键索引
# 唯一值字段建唯一/主键，查询效率最优；重复多改用联合索引

## 2.排序分组字段建索引
# order by/group by/distinct字段建索引，规避文件排序Using filesort

## 3.高频查询字段建索引
# where常用字段，基数高(重复少)单列索引；重复量大改用联合索引

## 4.超长字符用前缀索引
# 长varchar，取前N字符建前缀索引，节省空间

## 5.严控索引总量
# 索引过多占用磁盘，增删改开销变大，单表索引不宜过多

## 6.定期清理无效索引
# 废弃、极少使用索引及时删除，降低DML维护成本

# 详细版 
为了使索引的使用效率更高，在创建索引时，必须考虑在哪些字段上创建索引和创建什么类型的索引。
那么索引设计原则又是怎样的?
● 1、选择唯一性索引
唯一性索引的值是唯一的，可以更快速的通过该索引来确定某条记录。
例如:
学生表中学号是具有唯一性的字段。为该字段建立唯一性索引可以很快的确定某个学生的信息。
如果使用姓名的话，可能存在同名现象，从而降低查询速度。
主键索引和唯一键索引，在查询中使用是效率最高的。
show index from world.city;
explain select count(*) from world.city;
explain select count(distinct countrycode) from world.city;
explain select count(distinct countrycode,population ) from world.city;

注意：如果重复值较多，可以考虑采用联合索引

● 2．为经常需要排序、分组和联合操作的字段建立索引
例如:
经常需要ORDER BY、GROUP BY、DISTINCT和UNION等操作的字段，排序操作会浪费很多时间。
如果为其建立索引，可以有效地避免排序操作
● 3．为常作为查询条件的字段建立索引
● 如果某个字段经常用来做查询条件，那么该字段的查询速度会影响整个表的查询速度。
● 因此，为这样的字段建立索引，可以提高整个表的查询速度。
  ○   3.1 经常查询
  ○   3.2 列值的重复值少
注：如果经常作为条件的列，重复值特别多，可以建立联合索引
● 4．尽量使用前缀来索引
如果索引字段的值很长，最好使用值的前缀来索引。例如，TEXT和BLOG类型的字段，进行全文检索
会很浪费时间。如果只检索字段的前面的若干个字符，这样可以提高检索速度。
● 5．限制索引的数目
● 索引的数目不是越多越好。每个索引都需要占用磁盘空间，索引越多，需要的磁盘空间就越大。
● 修改表时，对索引的重构和更新很麻烦。越多的索引，会使更新表变得很浪费时间。
● 6．删除不再使用或者很少使用的索引
● 表中的数据被大量更新，或者数据的使用方式被改变后，原有的一些索引可能不再需要。数据库管理
● 员应当定期找出这些索引，将它们删除，从而减少索引对更新操作的影响。为了使索引的使用效率更高，在创建索引时，必须考虑在哪些字段上创建索引和创建什么类型的索引。
那么索引设计原则又是怎样的?
● 1、选择唯一性索引
唯一性索引的值是唯一的，可以更快速的通过该索引来确定某条记录。
例如:
学生表中学号是具有唯一性的字段。为该字段建立唯一性索引可以很快的确定某个学生的信息。
如果使用姓名的话，可能存在同名现象，从而降低查询速度。
主键索引和唯一键索引，在查询中使用是效率最高的。
show index from world.city;
explain select count(*) from world.city;
explain select count(distinct countrycode) from world.city;
explain select count(distinct countrycode,population ) from world.city;

注意：如果重复值较多，可以考虑采用联合索引

● 2．为经常需要排序、分组和联合操作的字段建立索引
例如:
经常需要ORDER BY、GROUP BY、DISTINCT和UNION等操作的字段，排序操作会浪费很多时间。
如果为其建立索引，可以有效地避免排序操作
● 3．为常作为查询条件的字段建立索引
● 如果某个字段经常用来做查询条件，那么该字段的查询速度会影响整个表的查询速度。
● 因此，为这样的字段建立索引，可以提高整个表的查询速度。
  ○   3.1 经常查询
  ○   3.2 列值的重复值少
注：如果经常作为条件的列，重复值特别多，可以建立联合索引
● 4．尽量使用前缀来索引
如果索引字段的值很长，最好使用值的前缀来索引。例如，TEXT和BLOG类型的字段，进行全文检索
会很浪费时间。如果只检索字段的前面的若干个字符，这样可以提高检索速度。
● 5．限制索引的数目
● 索引的数目不是越多越好。每个索引都需要占用磁盘空间，索引越多，需要的磁盘空间就越大。
● 修改表时，对索引的重构和更新很麻烦。越多的索引，会使更新表变得很浪费时间。
● 6．删除不再使用或者很少使用的索引
● 表中的数据被大量更新，或者数据的使用方式被改变后，原有的一些索引可能不再需要。数据库管理
● 员应当定期找出这些索引，将它们删除，从而减少索引对更新操作的影响。

```

****

****

****

### 8类索引失效 重点关注
```bash
# 8类索引失效精简总结 
## 1.无查询条件/条件无索引 → 全表扫描
# select * from tbl; 大数据严禁全表，加where/limit+索引

## 2.筛选数据超25% → 优化：limit分页，海量数据迁移Redis

## 3.频繁DML导致索引统计失真
# 解决：重建索引/analyze table更新统计信息

## 4.索引字段做运算、套函数(+-*/、函数)
# 错：where id-1=9  对：where id=10

## 5.隐式字段类型转换(字符串字段查数字)
# telnum varchar查数字120失效，加引号'120'生效

## 6.<>、not in通常失效；in/or建议拆分union all
# >/</in返回大量数据也会放弃索引，建议搭配limit

## 7.like通配符%前置失效(%abc)；后缀%(abc%)可走range
# 全文模糊检索改用ES

## 8.联合索引违背最左前缀
# idx(money,age,sex)，跳过首列money直接查age/sex → 索引失效

#详细版 

● 1.没有查询条件，或者查询条件没有建立索引
#全表扫描
select * from table;
select  * from tab where 1=1;

在业务数据库中，特别是数据量比较大的表,是没有全表扫描这种需求。
1）对用户查看是非常痛苦的。
2）对服务器来讲毁灭性的。
3）SQL改写成以下语句：
#情况1
#全表扫描
select * from table;
#需要在price列上建立索引
selec * from tab order by price limit 10;
#情况2
#name列没有索引
select * from table where name='zhangsan'; 
1、换成有索引的列作为查询条件
2、将name列建立索引

● 2.查询结果集是原表中的大部分数据，应该是25％以上
explain select * from city where population>3000 order by population;

1）如果业务允许，可以使用limit控制。
2）结合业务判断，有没有更好的方式。如果没有更好的改写方案就尽量不要在mysql存放这个数据了，放到redis里面。
● 3.索引本身失效，统计数据不真实
索引有自我维护的能力。
对于表内容变化比较频繁的情况下，有可能会出现索引失效。
重建索引就可以解决
● 4.查询条件使用函数在索引列上或者对索引列进行运算，运算包括(+，-，*等)
#例子
错误的例子：select * from test where id-1=9; 
正确的例子：select * from test where id=10;

● 5.隐式转换导致索引失效.这一点应当引起重视.也是开发中经常会犯的错误
create table test (id int ,name varchar(20),telnum varchar(10));
insert into test values(1,'zs','110'),(2,'l4',120),(3,'w5',119),(4,'z4',112);

explain select * from test where telnum=120;

alter table test add index idx_tel(telnum);
explain select * from test where telnum=120;
explain select * from test where telnum='120';

● 6． <> ，not in 不走索引
select * from tab where telnum <> '1555555';
explain select * from tab where telnum <> '1555555';

单独的>,<,in 有可能走，也有可能不走，和结果集有关，尽量结合业务添加limit
or或in尽量改成union
EXPLAIN  SELECT * FROM teltab WHERE telnum IN ('110','119');
#改写成
EXPLAIN SELECT * FROM teltab WHERE telnum='110'
UNION ALL
SELECT * FROM teltab WHERE telnum='119'
● 7．like "%_" 百分号在最前面不走
#走range索引扫描
EXPLAIN SELECT * FROM teltab WHERE telnum LIKE '31%';
#不走索引
EXPLAIN SELECT * FROM teltab WHERE telnum LIKE '%110';

%linux%类的搜索需求，可以使用Elasticsearch -------> ELK
● 8.单独引用联合索引里非第一位置的索引列
CREATE TABLE t1 (id INT,NAME VARCHAR(20),age INT ,sex ENUM('m','f'),money INT);
ALTER TABLE t1 ADD INDEX t1_idx(money,age,sex);
DESC t1;
SHOW INDEX FROM t1;

#走索引的情况测试
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE money=30 AND age=30  AND sex='m';

#部分走索引
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE money=30 AND age=30;
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE money=30  AND sex='m'; 
#不走索引
EXPLAIN SELECT  NAME,age,sex,money FROM t1 WHERE age=20;
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE age=30 AND sex='m';
EXPLAIN SELECT NAME,age,sex,money FROM t1 WHERE sex='m';

```

> 更新: 2026-06-06 12:09:32  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/no52on>