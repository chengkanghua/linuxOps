# 第八章· MySQL日志管理

## 一.MySQL日志简介

| 日志类型 | 关键配置选项 | 文件名 / 表名称 | 常用工具 |
| --- | --- | --- | --- |
| **错误日志** | `--log-error` | `host_name.err` | N/A |
| **通用日志（常规日志）** | `--general_log` | `host_name.log` / `general_log`（表名） | N/A |
| **慢查询日志** | `--slow_query_log``--long_query_time` | `host_name-slow.log` / `slow_log`（表名） | `mysqldumpslow`、`pt-query-digest` |
| **二进制日志（Binlog）** | `--log-bin``--expire-logs-days` | `host_name-bin.000001`（循环生成） | `mysqlbinlog` |
| **审计日志** | `--audit_log``--audit_log_file` | `audit.log` | N/A |

```bash
# 错误日志：--log-error，记录错误/警告，生产必开，用于排错
# 通用日志：--general_log，记录所有SQL，性能开销大，默认关闭，临时排查用
# 慢查询日志：--slow_query_log --long_query_time，记录慢SQL，生产必开，优化性能用
# Binlog：--log-bin --expire-logs-days，记录所有变更，主从/恢复用，生产必须开
# 审计日志：--audit_log，合规审计用，按需开启

```

## 二.错误日志

*作用：*

记录mysql数据库的一般状态信息及报错信息，是我们对于数据库常规报错处理的常用日志。

*默认位置：*

$MYSQL_HOME/data/

*开启方式:*（MySQL安装完后默认开启)

```sql
#编辑配置文件
[root@db01 ~]# vim /etc/my.cnf
[mysqld]
# $hostname 改成主机名 这个配置默认就是这样的，也可以不用写
log_error=/application/mysql/data/$hostname.err  
#查看方式
mysql> show variables like 'log_error';

```

## 三.一般查询日志

*作用：*

记录mysql所有执行成功的SQL语句信息，可以做审计用，但是我们很少开启。

*默认位置：*

$MYSQL_HOME/data/

*开启方式:*（MySQL安装完之后默认不开启）

```sql
#编辑配置文件
[root@db01 ~]# vim /etc/my.cnf
[mysqld]
general_log=on
general_log_file=/application/mysql/data/$hostname.log # $hostanme 改成主机名
#查看方式
mysql> show variables like '%gen%';
```

## 四.二进制日志

<!-- OCR_START -->
- Binlog
- MySQL
- 数据
- cache?
- 内存
- Age=1
- Age=2
- Update t1setAge=20whereAge=19;
- 9
- MySQ
- bin.00000
- L数据
- 磁盘
- 1?
<!-- OCR_END -->

*作用：*

记录已提交的DML事务语句，并拆分为多个事件（event）来进行记录

记录所有DDL、DCL等语句

总之，二进制日志会记录所有对数据库发生修改的操作

*二进制日志模式:*

statement：语句模式，上图中将update语句进行记录（默认模式）。

row：行模式，即数据行的变化过程，上图中Age=19修改成Age=20的过程事件。

mixed：以上两者的混合模式。

企业推荐使用row模式

***优缺点:***

**statement模式：**

优点：简单明了，容易被看懂，就是sql语句，记录时不需要太多的磁盘空间。

缺点：记录不够严谨。

**row模式：**

优点：记录更加严谨。

缺点：有可能会需要更多的磁盘空间，不太容易被读懂。

> binlog的作用:
>
> 1）如果我拥有数据库搭建开始所有的二进制日志，那么我可以把数据恢复到任意时刻
>
> 2）数据的备份恢复
>
> 3）数据的复制

**二进制日志的管理操作实战**

**开启方式**

```sql
[root@db01 data]# vim /etc/my.cnf
[mysqld]
log-bin=mysql-bin
binlog_format=row
```

**注意:在mysql5.7中开启binlog必须要加上server-id。**

```sql
[root@db01 data]# vim /etc/my.cnf
[mysqld]
log-bin=mysql-bin
binlog_format=row
server_id=1
```

**二进制日志的操作**

```sql
#物理查看
[root@db01 data]# ll /application/mysql/data/
-rw-rw---- 1 mysql mysql      285 Mar  6  2017 mysql-bin.000001
#命令行查看
# mysql -uroot -p123
mysql> show binary logs;
mysql> show master status;
#查看binlog事件
mysql> show binlog events in 'mysql-bin.000007';
```

**事件介绍**

1）在binlog中最小的记录单元为event

2）一个事务会被拆分成多个事件（event）

**事件（event）特性**

1）每个event都有一个开始位置（start position）和结束位置（stop position）。

2）所谓的位置就是event对整个二进制的文件的相对位置。

3）对于一个二进制日志中，前120个position是文件格式信息预留空间。

4）MySQL第一个记录的事件，都是从120开始的。

**row模式下二进制日志分析及数据恢复**

```sql
#为了让大家更清晰看到新的操作
show master status;
#刷新一个新的binlog
flush logs;

-- #查看binlog信息;
show master status;
-- #创建一个binlog库;
create database binlog;
-- #使用binlog库;
use binlog
-- #创建binglog_table表;
create table binlog_table(id int);
-- #查看binlog信息;
show master status;
-- #插入数据1;
insert into binlog_table values(1);
-- #查看binlog信息;
show master status;
-- #提交
commit;
-- #查看binlog信息;
show master status;
-- #插入数据2;
insert into binlog_table values(2);
-- #插入数据3;
insert into binlog_table values(3);
-- #查看binlog信息;
show master status;
-- #提交;
commit;
-- #删除数据1;
delete from binlog_table where id=1;
-- #查看binlog信息;
show master status;
-- #提交;
commit;
-- #更改数据2为22;
update binlog_table set id=22 where id=2;
-- #查看binlog;
show master status;
-- #提交;
commit;
-- #查看binlog信息;
show master status;
-- #查看数据;
select * from binlog_table;
-- #删表;
drop table binlog_table;
-- #删库;
drop database binlog;
```

***

**恢复数据到delete之前**

```sql
#查看binlog事件
mysql> show binlog events in 'mysql-bin.000013';

#使用mysqlbinlog来查看
[root@db01 data]# mysqlbinlog /application/mysql/data/mysql-bin.000013
[root@db01 data]# mysqlbinlog /application/mysql/data/mysql-bin.000013|grep -v SET
[root@db01 data]# mysqlbinlog --base64-output=decode-rows -vvv /application/mysql/data/mysql-bin.000001
### UPDATE `binlog`.`binlog_table`
### WHERE
###   @1=2 /* INT meta=0 nullable=1 is_null=0 */
### SET
###   @1=22 /* INT meta=0 nullable=1 is_null=0 */
#分析
update binlog.binlog_table
set
@1=22 --------->@1表示binlog_table中的第一列,集合表结构就是id=22
where
@1=2  --------->@1表示binlog_table中的第一列,集合表结构就是id=2
#结果
update binlog.binlog_table set id=22 where id=2;
#截取二进制日志
查看二进制日志后，发现delete语句开始位置是858

[root@db01 data]# mysqlbinlog --start-position=120 --stop-position=858 /application/mysql/data/mysql-bin.000013 >/tmp/binlog.sql
#临时关闭binlog
mysql> set sql_log_bin=0;
#执行sql文件
mysql> source /tmp/binlog.sql
#查看删除的库
mysql> show databases;
#进binlog库
mysql> use binlog
#查看删除的表
mysql> show tables;
#查看表中内容
mysql> select * from binlog_table;

--------------------------------------------------------------------分析点位
[root@db02 ~]# mysqlbinlog --base64-output=decode-rows -vvv /application/mysql/data/mysql-bin.000001
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!40019 SET @@session.max_insert_delayed_threads=0*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#240914 22:48:19 server id 1  end_log_pos 120 CRC32 0x3f1c33ff 	Start: binlog v 4, server v 5.6.51-log created 240914 22:48:19 at startup
# Warning: this binlog is either in use or was not closed properly.
ROLLBACK/*!*/;
# at 120    *********创建库之前的 位置
#240915  4:03:06 server id 1  end_log_pos 220 CRC32 0x4ec1a813 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1726344186/*!*/;
SET @@session.pseudo_thread_id=1/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1075838976/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=33/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
create database binlog
/*!*/;
# at 220
#240915  4:05:28 server id 1  end_log_pos 331 CRC32 0xc9007366 	Query	thread_id=1	exec_time=0	error_code=0
use `binlog`/*!*/;
SET TIMESTAMP=1726344328/*!*/;
create table binlog_table(id int)
/*!*/;
# at 331
#240915  4:05:40 server id 1  end_log_pos 405 CRC32 0xdb7ee31d 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1726344340/*!*/;
BEGIN
/*!*/;
# at 405
#240915  4:05:40 server id 1  end_log_pos 462 CRC32 0xaf317d1a 	Table_map: `binlog`.`binlog_table` mapped to number 70
# at 462
#240915  4:05:40 server id 1  end_log_pos 502 CRC32 0x45c6b2d3 	Write_rows: table id 70 flags: STMT_END_F
### INSERT INTO `binlog`.`binlog_table`
### SET
###   @1=1 /* INT meta=0 nullable=1 is_null=0 */
# at 502
#240915  4:05:40 server id 1  end_log_pos 533 CRC32 0xd8cde1d9 	Xid = 15
COMMIT/*!*/;
# at 533
#240915  4:06:06 server id 1  end_log_pos 607 CRC32 0x03f36c97 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1726344366/*!*/;
BEGIN
/*!*/;
# at 607
#240915  4:06:06 server id 1  end_log_pos 664 CRC32 0x5e7ccf00 	Table_map: `binlog`.`binlog_table` mapped to number 70
# at 664
#240915  4:06:06 server id 1  end_log_pos 704 CRC32 0xf9d4f633 	Write_rows: table id 70 flags: STMT_END_F
### INSERT INTO `binlog`.`binlog_table`
### SET
###   @1=2 /* INT meta=0 nullable=1 is_null=0 */
# at 704
#240915  4:06:06 server id 1  end_log_pos 735 CRC32 0x1e231ac2 	Xid = 19
COMMIT/*!*/;
# at 735
#240915  4:06:06 server id 1  end_log_pos 809 CRC32 0x23fd745e 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1726344366/*!*/;
BEGIN
/*!*/;
# at 809
#240915  4:06:06 server id 1  end_log_pos 866 CRC32 0x86a46054 	Table_map: `binlog`.`binlog_table` mapped to number 70
# at 866
#240915  4:06:06 server id 1  end_log_pos 906 CRC32 0xbea57c69 	Write_rows: table id 70 flags: STMT_END_F
### INSERT INTO `binlog`.`binlog_table`
### SET
###   @1=3 /* INT meta=0 nullable=1 is_null=0 */
# at 906
#240915  4:06:06 server id 1  end_log_pos 937 CRC32 0xdbdd32ad 	Xid = 20
COMMIT/*!*/;
# at 937
#240915  4:06:16 server id 1  end_log_pos 1011 CRC32 0x6340ed75 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1726344376/*!*/;
BEGIN
/*!*/;
# at 1011
#240915  4:06:16 server id 1  end_log_pos 1068 CRC32 0xa3f30d0c 	Table_map: `binlog`.`binlog_table` mapped to number 70
# at 1068
#240915  4:06:16 server id 1  end_log_pos 1108 CRC32 0x361b1312 	Delete_rows: table id 70 flags: STMT_END_F
### DELETE FROM `binlog`.`binlog_table`
### WHERE
###   @1=1 /* INT meta=0 nullable=1 is_null=0 */
# at 1108
#240915  4:06:16 server id 1  end_log_pos 1139 CRC32 0xbc433b60 	Xid = 23
COMMIT/*!*/;
# at 1139
#240915  4:06:54 server id 1  end_log_pos 1213 CRC32 0xf77e8ae6 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1726344414/*!*/;
BEGIN
/*!*/;
# at 1213
#240915  4:06:54 server id 1  end_log_pos 1270 CRC32 0x6dff4d71 	Table_map: `binlog`.`binlog_table` mapped to number 70
# at 1270
#240915  4:06:54 server id 1  end_log_pos 1316 CRC32 0xdc752590 	Update_rows: table id 70 flags: STMT_END_F
### UPDATE `binlog`.`binlog_table`
### WHERE
###   @1=2 /* INT meta=0 nullable=1 is_null=0 */
### SET
###   @1=22 /* INT meta=0 nullable=1 is_null=0 */
# at 1316
#240915  4:06:54 server id 1  end_log_pos 1347 CRC32 0xf9d01ae1 	Xid = 29
COMMIT/*!*/;
# at 1347   **********删除表之前的位置.
#240915  4:07:06 server id 1  end_log_pos 1476 CRC32 0xd52f2731 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1726344426/*!*/;
DROP TABLE `binlog_table` /* generated by server */
/*!*/;
# at 1476
#240915  4:07:12 server id 1  end_log_pos 1565 CRC32 0xe76b8e67 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1726344432/*!*/;
drop database binlog
/*!*/;
DELIMITER ;
# End of log file
ROLLBACK /* added by mysqlbinlog */;
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
[root@db02 ~]# mysqlbinlog --start-position=120 --stop-position=1347 /application/mysql/data/mysql-bin.000001 >/tmp/binlog.sql

```

***

**思考，存在问题：**

> 数据库或表被误删除的是很久之前创建的（一年前）
>
> **如果基于binlog全量恢复，成本很高**
>
> 1）可以用备份恢复+短时间内二进制日志，恢复到故障之前
>
> 2）非官方方法，binlog2sql，binlog取反，类似于Oracle的flushback
>
> 3）延时从库
>
> 如果同一时间内和故障库无关的数据库都有操作，在截取binlog时都会被截取到
>
> **想一个办法过滤出来？**
>
> 1）grep？
>
> **其他过滤方案？**
>
> 1）-d 参数接库名

**模拟数据**

```sql
#为了让大家更清晰看到新的操作
show master status;
#刷新一个新的binlog
flush logs;
show master status;

#创建db1、db2两个库
create database db1;
create database db2;
#库db1操作
mysql> use db1
#创建t1表
mysql> create table t1(id int);
#插入5条数据
mysql> insert into t1 values(1),(2),(3),(4),(5);
#提交
mysql> commit;
#库db2操作
mysql> use db2
#创建t2表
mysql> create table t2(id int);
#插入3条数据
mysql> insert into t2 values(1),(2),(3);
#提交
mysql> commit;
#查看binlog事件
mysql> show binlog events in 'mysql-bin.000014';

#只查看db1的binlog日志
[root@db01 data]# mysqlbinlog -d db1 --base64-output=decode-rows -vvv /application/mysql/data/mysql-bin.000014

# 模拟数据误删除
mysql -uroot -p123
delete from db1.t1 where id=3;
delete from db2.t2 where id=2;
commit;
quit

# 要求只恢复db1 删除前的数据;

# 过滤db1库数据 分析 起点 终点.
[root@db02 ~]# mysqlbinlog -d db1 --base64-output=decode-rows -vvv /application/mysql/data/mysql-bin.000002

# at 120  #****** 创建db1 点
#240915 17:51:41 server id 1  end_log_pos 211 CRC32 0x1489063d 	Query	thread_id=5	exec_time=0	error_code=0
SET TIMESTAMP=1726393901/*!*/;
SET @@session.pseudo_thread_id=5/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1075838976/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=33/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
create database db1
/*!*/;
# at 211
# at 302
#240915 17:52:03 server id 1  end_log_pos 397 CRC32 0xd7730e3f 	Query	thread_id=5	exec_time=0	error_code=0
use `db1`/*!*/;
SET TIMESTAMP=1726393923/*!*/;
create table t1(id int)
/*!*/;
# at 397
#240915 17:52:08 server id 1  end_log_pos 468 CRC32 0xd14afe34 	Query	thread_id=5	exec_time=0	error_code=0
SET TIMESTAMP=1726393928/*!*/;
BEGIN
/*!*/;
# at 468
#240915 17:52:08 server id 1  end_log_pos 512 CRC32 0x7509fa4c 	Table_map: `db1`.`t1` mapped to number 74
# at 512
#240915 17:52:08 server id 1  end_log_pos 572 CRC32 0x44fd3735 	Write_rows: table id 74 flags: STMT_END_F
### INSERT INTO `db1`.`t1`
### SET
###   @1=1 /* INT meta=0 nullable=1 is_null=0 */
### INSERT INTO `db1`.`t1`
### SET
###   @1=2 /* INT meta=0 nullable=1 is_null=0 */
### INSERT INTO `db1`.`t1`
### SET
###   @1=3 /* INT meta=0 nullable=1 is_null=0 */
### INSERT INTO `db1`.`t1`
### SET
###   @1=4 /* INT meta=0 nullable=1 is_null=0 */
### INSERT INTO `db1`.`t1`
### SET
###   @1=5 /* INT meta=0 nullable=1 is_null=0 */
# at 572
#240915 17:52:08 server id 1  end_log_pos 603 CRC32 0x65a00dfa 	Xid = 229
COMMIT/*!*/;
# at 603
# at 698
#240915 17:52:26 server id 1  end_log_pos 769 CRC32 0xc3150099 	Query	thread_id=5	exec_time=0	error_code=0
SET TIMESTAMP=1726393946/*!*/;
BEGIN
/*!*/;
# at 769
# at 813
# at 863
#240915 17:52:26 server id 1  end_log_pos 894 CRC32 0x6dd24436 	Xid = 236
COMMIT/*!*/;
# at 894  #******** 删除数据的前一个点.
#240915 18:03:09 server id 1  end_log_pos 962 CRC32 0xd9b91e34 	Query	thread_id=6	exec_time=0	error_code=0
SET TIMESTAMP=1726394589/*!*/;
BEGIN
/*!*/;
# at 962
#240915 18:03:09 server id 1  end_log_pos 1006 CRC32 0x7b4769fa 	Table_map: `db1`.`t1` mapped to number 74
# at 1006
#240915 18:03:09 server id 1  end_log_pos 1046 CRC32 0xe259e0c3 	Delete_rows: table id 74 flags: STMT_END_F
### DELETE FROM `db1`.`t1`
### WHERE
###   @1=3 /* INT meta=0 nullable=1 is_null=0 */
# at 1046
#240915 18:03:09 server id 1  end_log_pos 1077 CRC32 0xfb5710f3 	Xid = 242
COMMIT/*!*/;
# at 1077
#240915 18:04:54 server id 1  end_log_pos 1145 CRC32 0xadb2c9ae 	Query	thread_id=7	exec_time=0	error_code=0
SET TIMESTAMP=1726394694/*!*/;
BEGIN
/*!*/;
# at 1145
# at 1189
# at 1229
#240915 18:04:54 server id 1  end_log_pos 1260 CRC32 0x237a63d6 	Xid = 246
COMMIT/*!*/;
DELIMITER ;
# End of log file
ROLLBACK /* added by mysqlbinlog */;
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;

#按分析的点截取sql
# mysqlbinlog -d db1 --start-position=120 --stop-position=894 /application/mysql/data/mysql-bin.000002 >/tmp/db1.sql

# 临时把db1库备份一下; 后面恢复正常就可以删除了
# mysqldump -S /tmp/mysql.sock -uroot -p db1 > /tmp/db1.bak.sql

mysql -uroot -p123
[(none)]>set sql_log_bin=0;
[(none)]>drop database db1;
[(none)]>source /tmp/db1.sql
[db1]>select * from db1.t1;  -- 查看数据已经恢复了
[db1]>quit

# 实际生产中,各种库的操作可能是交叉操作的, 截取恢复点的时候需要截取多段sql,避开不需要恢复库的sql操作.
```

****

**删除、刷新binlog**

```bash
刷新binlog日志
1）flush logs;
2）重启数据库时会刷新
3）二进制日志上限（max_binlog_size）
[(none)]>show variables like 'max_binlog_size';
+-----------------+------------+
| Variable_name   | Value      |
+-----------------+------------+
| max_binlog_size | 1073741824 |
+-----------------+------------+
#计算  默认是 1G 就会刷新 binlog 日志
1073741824/1024/1024

删除二进制日志
1）原则
在存储能力范围内，能多保留则多保留
基于上一次全备前的可以选择删除

删除方式
● 1.根据存在时间删除日志
#临时生效   只保留7天内的
SET GLOBAL expire_logs_days = 7;
#永久生效
[root@db01 data]# vim /etc/my.cnf
[mysqld]
expire_logs_days = 7
● 2.使用purge命令删除  3 天之前的..
PURGE BINARY LOGS BEFORE now() - INTERVAL 3 day;
● 3.根据文件名删除  mysql-bin.000010 之前的都删除掉
PURGE BINARY LOGS TO 'mysql-bin.000010';
● 4.使用reset master    全删除
mysql> reset master;

```

## 五.慢查询日志

**作用：**

1）是将mysql服务器中影响数据库性能的相关SQL语句记录到日志文件

2）通过对这些特殊的SQL语句分析，改进以达到提高数据库性能的目的

**默认位置：**

$MYSQL_HOME/data/$hostname-slow.log

**开启方式（默认没有开启）：**

```sql
[root@db01 ~]# vim /etc/my.cnf
[mysqld]
#开关
slow_query_log = 1
#指定慢日志文件存放位置（默认在data）
slow_query_log_file=/application/mysql/data/slow.log
#设定慢查询的阀值(默认10s)
long_query_time=0.05
#没走索引的语句也记录
log_queries_not_using_indexes

#查询语句的执行结果的行数少于该参数指定行的SQL 不被记录到慢查询日志 
min_examined_row_limit=100（鸡肋）

```

**模拟慢查询语句**

```sql
# https://dev.mysql.com/doc/index-other.html
# Example Databases 下载
# wget https://downloads.mysql.com/docs/world-db.tar.gz
# tar xf world-db.tar.gz && cd world-db
# mysql -uroot -proot123 < world.sql

mysql -uroot -p123
#进入world库
mysql> use world
#查看表
mysql> show tables
#将city表中所有内容加到t1表中
mysql> create table t1 select * from city;
#查看t1的表结构
mysql> desc t1;
#将t1表所有内容插入到t1表中（多插入几次）
mysql> insert into t1 select * from t1;
mysql> insert into t1 select * from t1;
mysql> insert into t1 select * from t1;
mysql> insert into t1 select * from t1;
#提交
mysql> commit;
#删除t1表中id>2000的数据
mysql> delete from t1 where id>2000;
#查看慢日志
[root@db01 ~]# cat /application/mysql/data/slow.log
```

**使用mysqldumpslow命令来分析慢查询日志**

```sql
#输出记录次数最多的10条SQL语句
mysqldumpslow -s c -t 10 /application/mysql/data/slow.log

参数说明:
-s:是表示按照何种方式排序，c、t、l、r分别是按照记录次数、时间、查询时间、返回的记录数来排序，
        ac、at、al、ar，表示相应的倒叙；
-t:是top n的意思，即为返回前面多少条的数据；
-g:后边可以写一个正则匹配模式，大小写不敏感的；

#得到返回记录集最多的10个查询
mysqldumpslow -s r -t 10 /application/mysql/data/slow.log
#得到按照时间排序的前10条里面含有左连接的查询语句
mysqldumpslow -s t -t 10 -g "left join" /application/mysql/data/slow.log

mysqldumpslow -s c -t 10 /application/mysql/data/slow.log

```

**第三方推荐（扩展）：**

****

****

****

```sql
yum install -y percona-toolkit-3.0.11-1.el6.x86_64.rpm
-------------------------------------------------------------------------------------------

# 安装官方 percona-release
yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm
# 2. 启用 tools 源（生成 repo 文件）
percona-release enable-only tools release
#官方源太慢
#把官方地址替换成腾讯云（关键）
sed -i 's#repo.percona.com#mirrors.cloud.tencent.com/percona#g' /etc/yum.repos.d/percona-*.repo
yum clean all && yum makecache
------------------------------或者
# 1. 创建 percona.repo
cat > /etc/yum.repos.d/percona.repo <<'EOF'
[percona-tools]
name=Percona Tools (Tencent Cloud Mirror)
baseurl=https://mirrors.cloud.tencent.com/percona/yum/
enabled=1
gpgcheck=0
EOF
# 2. 清缓存、建缓存
yum clean all
yum makecache
# 3. 安装工具（pt-toolkit、xtrabackup）
yum install -y percona-toolkit percona-xtrabackup
---------------------------------

yum install percona-toolkit

# xtrabackup对应mysql版本
percona-xtrabackup-24       # for 5.6/5.7
percona-xtrabackup-80       # for 8.0

使用percona公司提供的pt-query-digest工具分析慢查询日志
[root@mysql-db01 ~]# pt-query-digest /application/mysql/data/slow.log
```

有能力的可以做成可视化界面：

Anemometer基于pt-query-digest将MySQL慢查询可视化

<https://www.percona.com/downloads>  慢日志分析工具下载

打开网页  下拉找到 Percona Toolkit , 版本选择 3.0.12 , 系统 redhat 7

https://github.com/box/Anemometer 可视化代码下载

```bash
# 上面yum安装成功的话就不用手动下载安装了
wget https://downloads.percona.com/downloads/percona-toolkit/3.0.12/binary/redhat/7/x86_64/percona-toolkit-3.0.12-1.el7.x86_64.rpm
yum localinstall percona-toolkit-3.0.12-1.el7.x86_64.rpm

```

<!-- OCR_START -->
- BoxAnemometer
- QFind Query
- From
- To
- 数据源，暂时只有localhost
- Query frst seen since
- 查询方式，默认为tablesearch
- 2014-04-21 13:33:00
- 2014-04-22 13:33:00
- 2014-04-21 00:00:00
- 开始时间
- 结束时间
- Table Fields
- Filter By Host
- Where
- Custom Fields
- 按host过滤
- checksum
- 自定义查询条件
- date
- hour
- 通用字段
- Group By
- hour_ts
- 大多为函数返回值
- minute_ts
- 分组字段
- minute
- snippet
- OrderBy
- index_ratio
- Query_time_sum DESC
- 排序子句
- Query Sample Contains
- query_time_avg
- rows_sent_avg
- 示例sql中所包含的字符串
- global_quen
- review
- Having
- having过滤结果集
- Reviewed Status
- fingerprint
- global_query_review表字段
- sample
- first_seen
- last_seen
- Limit
- reviewed_by
- 往下拉会看到
- 20
- 符合条件的前20条记录
- reviewed_on
- global_query_review_history表字段
- comments
- Search
- 一点击查询
- 点击会显示按上面条件组织的sq语句
- +Show Raw SQL
- U Permalink
- JSON
- 显示的结果
- 点击会进入该查询的分析页面
- rows_sent_avgts_cntQuery_time_sum
- Lock_time_sum
- Rows_sent_sumRows_examined_sumTmp_ti
- 84EDDFF11FD0A5
- select this_.id as 1
- 406704.17
- 3.431244273245366
- 7676
- 26338.2310414314271.1659360002158792
- 13819
- 5620244858
- 3392EE69D5CC3BB8
- select id, 'dealid
- 176211.96
- 31.784756796154564 70
- 499
- 15860.5936412811280.01669800004310673
- 34781
- 6128828180
- 42822711
- EOA7
- 0507
- 113896147
<!-- OCR_END -->

> 更新: 2026-06-07 16:53:49  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/gh1y07>