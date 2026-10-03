# 第七章· MySQL的存储引擎

## 一.存储引擎简介

<!-- OCR_START -->
| 排名 | Id |
| --- | --- |
| 1 | 小明 |
| 20 | select*from student; |
| storageengines | student.ibd |
<!-- OCR_END -->

+ 1、文件系统：
- 1.1 操作系统组织和存取数据的一种机制。
- 1.2 文件系统是一种软件。
+ 2、文件系统类型：ext2 3 4 ，xfs 数据
- 2.1 不管使用什么文件系统，数据内容不会变化
- 2.2 不同的是，存储空间、大小、速度。
+ 3、MySQL引擎：
- 3.1 可以理解为，MySQL的“文件系统”，只不过功能更加强大。
+ 4、MySQL引擎功能：
- 4.1 除了可以提供基本的存取功能，还有更多功能事务功能、锁定、备份和恢复、优化以及特殊功能

**总之，存储引擎的各项特性就是为了保障数据库的安全和性能设计结构。**

## 二.MySQL自带的存储引擎类型
> **MySQL 提供以下存储引擎:**
>
> **01）InnoDB  
****02）MyISAM**
>
> 03）MEMORY
>
> 04）ARCHIVE
>
> 05）FEDERATED
>
> 06）EXAMPLE
>
> 07）BLACKHOLE
>
> 08）MERGE
>
> 09）NDBCLUSTER
>
> 10）CSV
>

---

> **还可以使用第三方存储引擎:**
>
> 01）MySQL当中插件式的存储引擎类型
>
> 02）MySQL的两个分支
>
> 03）perconaDB
>
> 04）mariaDB
>

```sql
-- #查看当前MySQL支持的存储引擎类型
show engines;
-- #查看innodb的表有哪些
select table_schema,table_name,engine from information_schema.tables where engine='innodb';
-- #查看myisam的表有哪些
select table_schema,table_name,engine from information_schema.tables where engine='myisam';

```

+ **1、innodb和myisam的区别**

_物理上的区别：_

```sql
#进入mysql目录
[root@db01~l]# cd /application/mysql/data/mysql
#查看所有user的文件
[root@db01 mysql]# ll user.*
-rw-rw---- 1 mysql mysql 10684 Mar  6  2017 user.frm
-rw-rw---- 1 mysql mysql   960 Aug 14 01:15 user.MYD
-rw-rw---- 1 mysql mysql  2048 Aug 14 01:15 user.MYI

#进入word目录
[root@db01 world]# cd /application/mysql/data/world/
#查看所有city的文件
[root@db01 world]# ll city.*
-rw-rw---- 1 mysql mysql   8710 Aug 14 16:23 city.frm
-rw-rw---- 1 mysql mysql 688128 Aug 14 16:23 city.ibd

```

+ **2.innodb存储引擎的简介**

**在MySQL5.5版本之后，默认的存储引擎，提供高可靠性和高性能。**

> 优点:
>
> 01）事务安全（遵从 ACID）
>
> 02）MVCC（Multi-Versioning Concurrency Control，多版本并发控制）
>
> 03）InnoDB 行级别锁定
>
> 04）Oracle 样式一致非锁定读取
>
> 05）表数据进行整理来优化基于主键的查询
>
> 06）支持外键引用完整性约束
>
> 07）大型数据卷上的最大性能
>
> 08）将对表的查询与不同存储引擎混合
>
> 09）出现故障后快速自动恢复
>
> 10）用于在内存中缓存数据和索引的缓冲区池
>
> 
>

| 功能 | 支持 | 功能 | 支持 |
| --- | --- | --- | --- |
| 存储限制 | 64TB | 索引高速缓存 | 是 |
| MVCC | 是 | 数据高速缓存 | 是 |
| B 树索引 | 是 | 自适应散列索引 | 是 |
| 群集索引（聚簇索引） | 是 | 复制 | 是 |
| 压缩数据 | 是 | 更新数据字典 | 是 |
| 加密数据 | 是 | 地理空间数据类型 | 是 |
| 查询高速缓存 | 是 | 地理空间索引 | 否 |
| 事务 | 是 | 全文搜索索引 | 是 |
| 锁定粒度 | 行级 | 群集数据库 | 否 |
| 外键 | 是 | 备份和恢复 | 是 |
| 文件格式管理 | 是 | 快速索引创建 | 是 |
| 多个缓冲区池 | 是 | PERFORMANCE_SCHEMA | 是 |
| 更改缓冲 | 是 | 自动故障恢复 | 是 |

**innodb核心特性**

> 重点:
>
> MVCC
>
> 事务
>
> 行级锁
>
> 热备份
>
> Crash Safe Recovery（自动故障恢复）
>

+ **3.查看存储引擎**

```bash
1）使用 SELECT 确认会话存储引擎
#查询默认存储引擎
SELECT @@default_storage_engine;

2）使用 SHOW 确认每个表的存储引擎
#查看表的存储引擎
SHOW CREATE TABLE city\G
SHOW TABLE STATUS LIKE 'CountryLanguage'\G

3）使用 INFORMATION_SCHEMA 确认每个表的存储引擎
-- #查看表的存储引擎
SELECT TABLE_NAME, ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='city' AND TABLE_SCHEMA='world'\G

```

+ **4.存储引擎的设置**

```bash
1）在启动配置文件中设置服务器存储引擎
#在配置文件的[mysqld]标签下添加
[mysqld]
default-storage-engine=<Storage Engine>

2）使用 SET 命令为当前客户机会话设置
#在MySQL命令行中临时设置
SET @@storage_engine=<Storage Engine>

3）在 CREATE TABLE 语句指定
#建表的时候指定存储引擎
CREATE TABLE t (i INT) ENGINE = <Storage Engine>;

```

## 三.真实企业案例
**项目背景：**

公司原有的架构：一个展示型的网站，LAMT，MySQL5.1.77版本（MYISAM），50M数据量。

**小问题不断：**

+ 1、表级锁：对表中任意一行数据修改类操作时，整个表都会锁定，对其他行的操作都不能同时进行。
+ 2、不支持故障自动恢复（CSR）：当断电时有可能会出现数据损坏或丢失的问题。

**如何解决：**

+ 1、提建议将现有的MYISAM引擎替换为Innodb，将版本替换为5.6.38
- 1）如果使用MYISAM会产生”小问题”，性能安全不能得到保证，使用innodb可以解决这个问题。
- 2）5.1.77版本对于innodb引擎支持不够完善，5.6.38版本对innodb支持非常完善了。
+ 2、实施过程和注意要素

1）备份生产库数据（mysqldump）

```sql
mysqldump -uroot -p123 -A --triggers -R --master-data=2 >/tmp/full.sql

```

2）准备一个5.6.38版本的新数据库

3）对备份数据进行处理（将engine字段替换）

```sql
sed -i 's#ENGINE=MYISAM#ENGINE=INNODB#g' /tmp/full.sql
```

4）将修改后的备份恢复到新库

5）应用测试环境连接新库，测试所有功能

6）停应用，将备份之后的生产库发生的新变化，补偿到新库

7）应用割接到新数据库

**项目结果：**

*解决了”小问题” *

## 四.Innodb存储引擎——表空间介绍

<!-- OCR_START -->
- 独立表空间
- mysql
- data
- InnoDB多个表空间
- 共享表空间
- City.ibd
- test
- Country.ibd
- world
- City.frm
- CountryLanguage.ibd
- （元数据）
- Country.frm
- 内部数据字典：
- 事务记录
- 插入撤消日志
- 以及其他
- 王做目志
- 更新撒消日志
- CountryLanguage.frm
- ibdata文件
- ib_logfile文件
<!-- OCR_END -->

```bash
什么是表空间？
表空间概念是引入于oracle数据库。起初为了解决存储空间动态扩容的问题。mysql5.5版本引入了共享表空间模式

mysql表空间类型？
共享表空间：在5.5版本引入了共享表空间（ibdata1），作为默认存储方式
独立表空间：5.6版本默认独立表空间。单表空间，一个表一个ibd文件，好管理，解决io密集等问题
普通表空间：完全和oracle一致的表空间管理模式
undo表空间：存储undo logs（回滚日志）
临时表空间：存储临时表。5.7版本默认独立 

--查看默认表空间模式
mysql> select @@innodb_file_per_table;
1 代表独立表空间模式
0 代表共享表空间模式

--如何切换？
临时：mysql> set global innodb_file_per_table=1;
再重新登录会话
永久：vim /etc/my.cnf
      innodb_fiel_per_table=1
说明：修改完之后，只影响新创建的表。

5.5版本以后出现共享表空间概念
表空间的管理模式的出现是为了数据库的存储更容易扩展
5.6版本中默认的是独立表空间
```

### 1、共享表空间

```sql
1）查看共享表空间
#物理查看
[root@db01 ~]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql 79691776 Aug 14 16:23 ibdata1
#命令行查看
mysql> show variables like '%path%';
innodb_data_file_path =bdata1:12M:autoextend

5.6版本中默认存储:
1.系统数据
2.undo
3.临时表
5.7版本中默认会将undo和临时表独立出来，5.6版本也可以独立，只不过需要在初始化的时候进行配置

2）设置方法
#编辑配置文件
[root@db01 ~]# vim /etc/my.cnf
[mysqld]
innodb_data_file_path=ibdata1:50M;ibdata2:50M:autoextend

# /etc/init.d/mysqld restart

# 报错
# grep ERROR /application/mysql/data/db02.err
2024-09-14 06:49:56 9166 [ERROR] InnoDB: Data file ./ibdata1 is of a different size 768 pages (rounded down to MB) than specified in the .cnf file 3200 pages!
2024-09-14 06:49:56 9166 [ERROR] InnoDB: Could not open or create the system tablespace. If you tried to add new data files to the system tablespace, and it failed here, you should now edit innodb_data_file_path in my.cnf back to what it was, and remove the new ibdata files InnoDB created in this failed attempt. InnoDB only wrote those files full of zeros, but did not yet use them in any way. But be careful: do not remove old data files which contain your precious data!

[root@db02 mysql]# ll -h /application/mysql/data/ib*
-rw-rw---- 1 mysql mysql 12M Sep 14 06:49 /application/mysql/data/ibdata1 #实际配置文件是12M
-rw-rw---- 1 mysql mysql 48M Sep 14 06:49 /application/mysql/data/ib_logfile0
-rw-rw---- 1 mysql mysql 48M Sep 14 03:41 /application/mysql/data/ib_logfile1

# 重新修改配置文件为 iddata1:12M
[root@db02 mysql]# vi /etc/my.cnf

[root@db02 mysql]# /etc/init.d/mysqld restart
 ERROR! MySQL server PID file could not be found!
Starting MySQL. SUCCESS!
[root@db02 mysql]# /etc/init.d/mysqld restart
Shutting down MySQL.. SUCCESS!
Starting MySQL. SUCCESS!
[root@db02 mysql]# ll -h /application/mysql/data/ib*
-rw-rw---- 1 mysql mysql 12M Sep 14 06:58 /application/mysql/data/ibdata1
-rw-rw---- 1 mysql mysql 50M Sep 14 06:58 /application/mysql/data/ibdata2 #*******
-rw-rw---- 1 mysql mysql 48M Sep 14 06:58 /application/mysql/data/ib_logfile0
-rw-rw---- 1 mysql mysql 48M Sep 14 03:41 /application/mysql/data/ib_logfile1

```

### 2、独立表空间
```sql
对于用户自主创建的表，会采用此种模式，每个表由一个独立的表空间进行管理
1）查看独立表空间

#物理查看
[root@db01 ~]# ll /application/mysql/data/world/
-rw-rw---- 1 mysql mysql 688128 Aug 14 16:23 city.ibd
#命令行查看
mysql> show variables like 'innodb_file_per_table'; 
innodb_file_per_table=ON
```

---

### 企业案例
在没有备份数据的情况下，突然断电导致表损坏，打不开数据库。

```sql
#准备数据
wget https://downloads.mysql.com/docs/world-db.tar.gz
tar xf world-db.tar.gz && cd world-db
mysql -uroot -p123 < world.sql
1）拷贝库目录到新库中
cp -r /application/mysql/data/world/ /data/3307/data/
chown -R mysql:mysql /data/3307/

2）启动新数据库
mysqld_safe --defaults-file=/data/3307/my.cnf &

3）登陆数据库查看
mysql -S /data/3307/mysql.sock
mysql> show databases; # 能看到city表

4）查询表中数据
mysql> select * from city;
报错-- ERROR 1146 (42S02): Table 'world.city' doesn't exist

5）找到以前的表结构在新库中创建表  (旧库里查看,找开发要.)
mysql> show create table world.city;
[(none)]>show create table world.city\G;
*************************** 1. row ***************************
       Table: city
Create Table: CREATE TABLE `city` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` char(35) NOT NULL DEFAULT '',
  `CountryCode` char(3) NOT NULL DEFAULT '',
  `District` char(20) NOT NULL DEFAULT '',
  `Population` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `CountryCode` (`CountryCode`),
  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)
) ENGINE=InnoDB AUTO_INCREMENT=4080 DEFAULT CHARSET=utf8mb4

# 新库3307操作
mysql -S /data/3307/mysql.sock
use world;
#删掉外键 表名改下 创建语句
CREATE TABLE `city_new` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` char(35) NOT NULL DEFAULT '',
  `CountryCode` char(3) NOT NULL DEFAULT '',
  `District` char(20) NOT NULL DEFAULT '',
  `Population` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `CountryCode` (`CountryCode`),
  KEY `idx_city` (`Population`,`CountryCode`)
) ENGINE=InnoDB AUTO_INCREMENT=4080 DEFAULT CHARSET=utf8mb4;

6）删除新表空间文件
mysql> alter table city_new discard tablespace;
mysql> quit

7）拷贝旧表空间文件
cp -a /data/3307/data/world/city.ibd /data/3307/data/world/city_new.ibd
# chown mysql:mysql /data/3307/data/world/city_new.ibd

8）授权
chown -R mysql.mysql /data/3307/data/world/

9）导入表空间
mysql -S /data/3307/mysql.sock
use world;
mysql>  alter table city_new import tablespace;
[world]> select * from world.city_new limit 2;  -- 再次查询就有数据了;
mysql > quit

# 删除物理文件city
rm /data/3307/data/world/city.ibd
rm /data/3307/data/world/city.frm

# 再次登录改表名
mysql -S /data/3307/mysql.sock
[(none)]>use world;
[world]>alter table city_new rename city;

```

## 五.Innodb核心特性——事务
### 1.什么是事务
_主要针对DML语句（update，delete，insert）_

> 一组数据操作执行步骤，这些步骤被视为一个工作单元:
>
> 1）用于对多个语句进行分组
>
> 2）可以在多个客户机并发访问同一个表中的数据时使用
>

---

> 所有步骤都成功或都失败
>
> 1）如果所有步骤正常，则执行
>
> 2）如果步骤出现错误或不完整，则取消
>

### 2.事务的通俗理解
_伴随着“交易”出现的数据库概念。_

> 我们理解的“交易”是什么？
>
> 1）物与物的交换（古代）
>
> 2）货币现金与实物的交换（现代1）
>
> 3）虚拟货币与实物的交换（现代2）
>
> 4）虚拟货币与虚拟实物交换（现代3）
>

---

> 数据库中的“交易”是什么？
>
> 1）事务又是如何保证“交易”的“和谐”？
>
> 2）ACID
>

### 3.事务ACID特性
---

Atomic   /əˈtɑːmɪk/（原子性）

所有语句作为一个单元全部成功执行或全部取消。

Consistent  /kənˈsɪstənt/（一致性）

如果数据库在事务开始时处于一致状态，则在执行该。 事务期间将保留一致状态。

Isolated  /'aɪsəletɪd/（隔离性）

事务之间不相互影响。

Durable  /ˈdʊrəbl/（持久性）

事务成功完成后，所做的所有更改都会准确地记录在 数据库中。所做的更改不会丢失。

---

### 4.事务流程举例

<!-- OCR_START -->
- 开始事务
- 从帐户1中
- 回滚
- 取款？
- （如果资金不足）
- 银行的交易流程
- 在帐户2
- 存款？
- （如果未完成）
- 提交
- （永久记录更改）
- 结束事务
<!-- OCR_END -->

### 5.事务的控制语句
> 如下:
>
> START TRANSACTION（或 BEGIN）：显式开始一个新事务
>
> SAVEPOINT：分配事务过程中的一个位置，以供将来引用
>
> COMMIT：永久记录当前事务所做的更改
>
> ROLLBACK：取消当前事务所做的更改
>
> ROLLBACK TO SAVEPOINT：取消在 savepoint 之后执行的更改
>
> RELEASE SAVEPOINT：删除 savepoint 标识符
>
> SET AUTOCOMMIT：为当前连接禁用或启用默认 autocommit 模式
>

**一个成功事务的生命周期**

begin;

sql1

sql2

sql3

...

commit;

**一个失败事务的生命周期**

begin;

sql1

sql2

sql3

...

rollback;

 自动提交

```sql
#查看自动提交
mysql> show variables like 'autocommit';
#临时关闭
mysql> set autocommit=0;
#永久关闭
[root@db01 world]# vim /etc/my.cnf
[mysqld]
autocommit=0
```

+ **事务演示**

1）成功事务

```sql
[(none)]>create database demo charset utf8mb4;
[(none)]>use demo

mysql> create table stu(id int,name varchar(10),sex enum('f','m'),money int);
mysql> begin;
mysql> insert into stu(id,name,sex,money) values(1,'zhang3','m',100), (2,'zhang4','m',110);
mysql> commit;
```

2）事务回滚

```sql
mysql> begin;
mysql> update stu set name='zhang3';
mysql> delete from stu;
mysql> rollback;
[demo]>select * from stu;

```

****

### 6.事务隐式提交情况
1）现在版本在开启事务时，不需要手工begin，只要你输入的是DML语句，就会自动开启事务。

2）有些情况下事务会被隐式提交

```bash
例如:
在事务运行期间，手工执行begin的时候会自动提交上个事务
在事务运行期间，加入DDL、DCL操作会自动提交上个事务
在事务运行期间，执行锁定语句（lock tables、unlock tables,LOAD DATA INFILE）

前提： autocommit=1（默认自动提交，单条 SQL 默认执行完立刻 commit）
3 类特殊 SQL：
LOCK TABLES / UNLOCK TABLES：隐式结束当前事务
LOAD DATA INFILE：DML 批量导入，受事务控制
SELECT ... FOR UPDATE：当前读、加行锁、开启隐式事务，不会自动提交

示例： 	
SET autocommit = 1;
CREATE TABLE t(id INT PRIMARY KEY,money INT);
INSERT INTO t VALUES(1,1000),(2,2000);

-- 1，SELECT ... FOR UPDATE
# 会话1
SET autocommit=1;
SELECT * FROM t WHERE id=1 FOR UPDATE; -- 锁住id=1，事务未提交
# 会话2
UPDATE t SET money=999 WHERE id=1; -- 阻塞等待
# 会话1执行提交，锁释放
COMMIT;

-- 2、LOCK TABLES 会强制提交正在运行的事务
SET autocommit=1;
START TRANSACTION;
UPDATE t SET money=111 WHERE id=1; -- 修改未提交

LOCK TABLES t WRITE; -- 触发隐式COMMIT，上面update直接落地，事务结束
# 现在t被加独占表锁，其他会话无法读写

UNLOCK TABLES; -- 释放表锁
规则：LOCK TABLES 是 DDL 类锁定语法，强制关闭现有事务

-- 3、LOAD DATA INFILE
-- 方式1：自动提交
SET autocommit=1;
LOAD DATA INFILE '/tmp/t.txt' INTO TABLE t; -- 导入完自动commit
-- 方式2：包裹事务可回滚
START TRANSACTION;
LOAD DATA INFILE '/tmp/t.txt' INTO TABLE t;
ROLLBACK; -- 导入数据全部撤销

```

### 7.事务日志redo基本功能
**1）Redo是什么？**

redo,顾名思义“重做日志”，是事务日志的一种。

**2）作用是什么？**

在事务ACID过程中，实现的是“D”持久化的作用。

<!-- OCR_START -->
- 修改
- MySQL
- Redo buffer
- 数据
- page?
- 内存
- 加载内存
- 落地磁盘
- MyS
- QL数
- Redo
- log?
- 磁盘
<!-- OCR_END -->

**特性:WAL(Write Ahead Log)日志优先写**

**REDO：记录的是，内存数据页的变化过程**

**3）REDO工作过程**

```sql
#执行步骤
update t1 set num=2 where num=1;
1）首先将t1表中num=1的行所在数据页加载到内存中 buffer page
2）MySQL实例在内存中将num=1的数据页改成num=2
3）num=1变成num=2的变化过程会记录到，redo内存区域，也就是redo buffer page中
#提交事务执行步骤
commit;
4）当敲下commit命令的瞬间，MySQL会将redo buffer page写入磁盘区域redo log
5）当写入成功之后，commit返回ok

如果此时服务器断电:
1)启动MySQL的过程中，读取redo log。(MySQL启动的很慢)
2)首先将数据页中的原数据1  加载到内存中。
3)将redolog中的修改过程，加载到内存中。
4)在内存中将数据修改(1改成2)。
5)写入磁盘。
```

### 8.redo数据实例恢复过程

<!-- OCR_START -->
- redo的情况
- 1.手动commit会写入redolog
- databufferpage
- redobufferpage
- 2.按一定的时间，定时写入
- 2
- 把1修改成2
- 内存
- LSN=100
- 101
- 对比LSN100
- LSN=101
- commit
- 检查commit标签
- update set num=2 where num=1
- redolog
- 磁盘
- 启动MySQL
<!-- OCR_END -->

```bash
LSN 代表日志序列号（Log Sequence Number）
1) 重新启动mysql 会将磁盘数据 relog 都加载到内存中
2) 对比 data 数据 对比 redo buffer page 中的 LSN 号
3) 去redolog中检查有没有 commit 标签 
  1) 有就将数据改过来 按LSN=101 的数据来
  2) 没有commit 就不算了,还是按LSN=100 的数据来

手动commit会写入redo log
mysql自己也会按一定时间,定时写入redo log中

[root@db02 ~]# ll /application/mysql/data
total 161852
-rw-rw---- 1 mysql mysql       56 Sep 14 03:42 auto.cnf
-rw-rw---- 1 mysql mysql    44368 Sep 14 06:58 db02.err
-rw-rw---- 1 mysql mysql        4 Sep 14 16:37 db02.pid
drwx------ 2 mysql mysql       50 Sep 14 08:38 demo
-rw-rw---- 1 mysql mysql 12582912 Sep 14 16:37 ibdata1  #共享表空间记录 系统数据,undo,临时表
-rw-rw---- 1 mysql mysql 52428800 Sep 14 06:58 ibdata2  
-rw-rw---- 1 mysql mysql 50331648 Sep 14 16:37 ib_logfile0  # redo.log 文件
-rw-rw---- 1 mysql mysql 50331648 Sep 14 03:41 ib_logfile1
drwx------ 2 mysql mysql     4096 Sep 14 03:41 mysql
drwx------ 2 mysql mysql     4096 Sep 14 03:41 performance_schema
drwx------ 2 mysql mysql        6 Sep 14 03:41 test
drwx------ 2 mysql mysql      144 Sep 14 07:41 world

# redo log 的几个参数
[(none)]>show variables like '%innodb_log%';  
+-----------------------------+----------+
| Variable_name               | Value    |
+-----------------------------+----------+
| innodb_log_buffer_size      | 8388608  |
| innodb_log_compressed_pages | ON       |
| innodb_log_file_size        | 50331648 |
| innodb_log_files_in_group   | 2        |
| innodb_log_group_home_dir   | ./       |
+-----------------------------+----------+

```

### 9.事务日志undo
**1）undo是什么？**

undo,顾名思义“回滚日志”，是事务日志的一种。

**2）作用是什么？**

在事务ACID过程中，实现的是“A”原子性的作用。当然CI的特性也和undo有关

<!-- OCR_START -->
- Undo
- 数据
- buffer
- 内存
- page?
- 加载到
- 落地到
- 磁盘
- log?
<!-- OCR_END -->

<!-- OCR_START -->
- data bufferpage
- rollback
- undobufferpage
- 内存
- =2
- 快照
- LSN=100
- =101
- txid=1
- update set num=2where num=1
- undo log
- 硬盘
<!-- OCR_END -->

```bash
-- redo和undo的存储位置
#redo位置
[root@db01 data]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql 50331648 Aug 15 06:34 ib_logfile0
-rw-rw---- 1 mysql mysql 50331648 Mar  6  2017 ib_logfile1

#undo位置
[root@db01 data]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql 79691776 Aug 15 06:34 ibdata1
-rw-rw---- 1 mysql mysql 79691776 Aug 15 06:34 ibdata2

在MySQL5.6版本中undo是在ibdata文件中，在MySQL5.7版本会独立出来。

txid : 事务id号
LSN : 日志序列号
1) 要修改数据时候, 实时的把修改的数据做一个快照并写入到磁盘undo log,(记录修改前的数据)
2) roolback的时候就从undo log(不是磁盘上的undo log就是内存中的undo buffer page)中拿出数据回复 

没有commit但是突然断电, 重启后也是会回滚数据

undo log 工作流程:
1)先将修改的数据行做一个快照。
2)实时写入到undo log中。如果断电了:
3)在MySQL启动时，检查commit标签。
4)如果有commit则数据不回滚。
5)如果没有commit则回滚数据。

#=====================
# 一、Undo 日常工作流程
#=====================
#1.DML更新数据前，记录修改前原始数据生成undo
#2.undo写入独立undo表空间文件
#3.事务未提交：rollback通过undo还原旧数据，实现原子回滚
#4.事务已提交：undo不立刻删除，供MVCC快照读；无事务引用后，Purge线程异步清理undo空间

#=====================
# 二、MySQL宕机重启：Redo+Undo协同故障恢复流程
#=====================
#步骤1：加载redo日志，重做【已提交但脏页没刷磁盘】的数据，把数据落盘(依靠redo持久性)
#步骤2：扫描undo日志，找出所有【未提交/异常中断事务】，利用undo回滚撤销脏修改
#步骤3：事务状态全部规整完毕，InnoDB引擎正常启动对外提供服务

```

****

****

### 10. 事务日志 redo 和 undo 结合修复数据

<!-- OCR_START -->
- 情况1：
- commit;
- 断电：
- 1.启动MySQL
- 3.数据加载到内存
- 2将redolog加载到内存
- undo bufferpage
- data bufferpage
- redobufferpage
- 内存
- =2
- 把1改成2的过程
- LSN=100
- =101
- LSN=101
- txid=1
- 1.手动commit的时候写入redolog
- 2.定时写入redolog
- 实时写入undolog
- update set num=2 where num=1
- 检查commit标签
- undo log
- data page
- redo log
- 硬盘
- 把1改成2
- ISN=101
<!-- OCR_END -->

****

```bash
情况1 commit; 然后断电了
1)启动mysql
2)将redolog加载到内存
3)数据加载到内存
4)检查commit 标签
    有的话就按commit标签的数据恢复
    没有commit 标签在回滚

先前滚 再回滚

```

****

****

### 11.事务中的锁
**1）什么是“锁”？**

“锁”顾名思义就是锁定的意思。

**2）“锁”的作用是什么？**

在事务ACID特性过程中，“锁”和“隔离级别”一起来实现“I”隔离性的作用。

<!-- OCR_START -->
- 事务1：setA=2
- 事务2：setA=3
- 数据A=1
<!-- OCR_END -->

排他锁：保证在多事务操作时，数据的一致性。

共享锁：保证在多事务工作期间，数据查询时不会被阻塞。

****

### 12.多版本并发控制（MVCC）
1）只阻塞修改类操作，不阻塞查询类操作

2）乐观锁的机制（谁先提交谁为准）

****

### 13.锁的粒度
+ MyIsam：低并发锁（表级锁）
+ Innodb：高并发锁（行级锁）

****

### 14.事务的隔离级别

```sql
四种隔离级别：
READ UNCOMMITTED（独立提交）  允许事务查看其他事务所进行的未提交更改
READ COMMITTED (读提交)      允许事务查看其他事务所进行的已提交更改
REPEATABLE READ(重复读)      确保每个事务的 SELECT 输出一致 # InnoDB 的默认级别
SERIALIZABLE   (串行)        将一个事务的结果与其他事务完全隔离

#查看隔离级别
mysql> show variables like '%iso%';
#修改隔离级别为RU
[mysqld]
transaction_isolation=read-uncommit
mysql> use oldboy
mysql> select * from stu;
mysql> insert into stu(id,name,sex,money) values(2,'li4','f',123);
#修改隔离级别为RC
[mysqld]
transaction_isolation=read-commit
```

```bash
#=====================
# InnoDB 事务锁：共享锁(S)、排他锁(X)
#=====================
# 1. 共享锁 S (Shared Lock)
#  作用：多事务可同时加S锁读取数据，读操作互不阻塞
#  限制：持有S锁期间，其他事务无法加排他锁修改数据
#  手动加锁：SELECT ... LOCK IN SHARE MODE

# 2. 排他锁 X (Exclusive Lock)
#  作用：独占数据，防止并发篡改，保障修改后数据一致
#  限制：持有X锁时，其他事务既不能读、也不能改，全部阻塞
#  触发场景：UPDATE/DELETE、SELECT ... FOR UPDATE（自动/手动加X锁）

#=====================
# 锁兼容规则（核心）
#=====================
# S + S：兼容，可共存
# S + X：互斥，阻塞
# X + 任意锁：互斥，阻塞

#=====================
# 补充要点
#=====================
# 1. 普通SELECT 是MVCC快照读，**不加锁**，读写互不影响
# 2. 锁生命周期：事务内加锁，commit/rollback 才释放
# 3. 有索引走行锁；无索引，行锁降级为全表锁

# ======================
# 二、锁粒度（从细到粗）
# ======================
# 1. 行锁(默认)：只锁定命中数据行，并发最高，InnoDB主力锁
#    触发：DML、for update 走有效索引时生效
# 2. 表锁：锁定整张表，并发极低
#    触发：LOCK TABLES、索引失效/无索引(行锁降级)
# 3. 意向锁(IS/IX)：表级辅助锁，标记表内存在行锁，避免全表扫描判断锁

# ======================
# 三、MVCC 多版本并发控制    Multi-Version Concurrency Control
# ======================
# 1. 适用：RC、RR隔离级别，**快照读(普通SELECT)不加锁**
# 2. 依赖：undo日志 + 行隐藏事务字段，生成数据历史快照
# 3. 作用：读写不阻塞，大幅提升并发；配合隔离级别解决读异常
# 4. 区分：
#    快照读：普通SELECT，走MVCC无锁
#    当前读：UPDATE/DELETE/FOR UPDATE，走行锁

# ======================
# 二、悲观锁 & 乐观锁（两种并发控制思想）
# ======================
# 悲观锁
# 含义：默认并发一定会产生数据冲突，**提前加锁**阻止别人操作
# 实现：依赖上面的共享锁、排他锁、行锁、表锁
# 场景：写操作频繁、并发冲突高的业务
# 排他锁、共享锁 = 悲观锁的具体实现

# 乐观锁 
# 含义：默认冲突概率很低，**全程不加锁**，更新时再校验数据是否被改动
# 实现：依赖版本号/时间戳字段做校验
# 场景：读多写少、冲突少，追求高并发性能 谁先提交谁为准

# ======================
# 三、三大并发读异常（隔离级别要解决的问题）
# ======================
# 1. 脏读
# 含义：一个事务读到了**其他事务未提交**的修改数据
# 问题：对方事务回滚后，读到的数据就变成无效脏数据
# 出现场景：读未提交 隔离级别

# 2. 不可重复读
# 含义：**同一个事务内**，两次查询同一条数据，结果不一致  #同一行数据不一样
# 原因：间隔期间其他事务执行UPDATE并提交
# 侧重点：单条数据内容被修改
# 出现场景：读已提交(RC) 隔离级别

# 3. 幻读
# 含义：**同一个事务内**，按条件多次查询，数据行数忽多/忽少 #数据行不一样
# 原因：间隔期间其他事务执行INSERT/DELETE并提交
# 侧重点：数据条数发生变化（新增/消失行）
# 出现场景：可重复读(RR)仍会存在，InnoDB靠间隙锁缓解，串行化彻底解决
```

> 更新: 2026-06-07 13:13:32  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/crwqlb>