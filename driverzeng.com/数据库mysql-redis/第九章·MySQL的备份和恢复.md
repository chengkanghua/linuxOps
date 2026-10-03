# 第九章· MySQL的备份和恢复

# 一.备份的原因
> 运维工作的核心简单概括就两件事:
>
> 1）第一个是保护公司的数据.
>
> 2）第二个是让网站能7*24小时提供服务(用户体验)。
>

<!-- OCR_START -->
- 再见了，世界
- http:/wwv
- 实力章人头元说
- 考男孩教育
- 百西
- 特资介辑
- hi，真不巧，网页走丢了。
- 不如搜素一下你想要的，或有刷新网页试试吧
- 360所网救箱
- 用新试试
- 开班在即
- 名额疯
- 基础学
- Lir
- 轻轻松松月薪过
<!-- OCR_END -->

1）备份就是为了恢复。

2）尽量减少数据的丢失（公司的损失）

# 二.备份的类型
**冷备份:**

# 停业务备份

**温备份:**

# 用户可读取数据,但不能修改数据情况下备份

**热备份:**

 # 用户可读取和修改的操作下 备份

# 三.备份的方式
**逻辑备份:**

**基于SQL语句的备份**

1）binlog

2）into outfile

```bash
vim /etc/my.cnf
[mysqld]
secure_file_priv = /tmp/

# /etc/init.d/mysqld restart
# 纯数据  ,不是sql 没有表结构, --鸡肋
mysql> select * from world.city into outfile '/tmp/world_city.data'; 
```

3）mysqldump

4）replication

**物理备份:**

**基于数据文件的备份**

1）Xtrabackup（percona公司）

# 四.备份策略
1）全量备份 full

2）增量备份 increamental

# 五.备份工具
1）mysqldump（逻辑）

mysql原生自带很好用的逻辑备份工具

2）mysqlbinlog（逻辑）

实现binlog备份的原生态命令

3）xtrabackup（物理）

precona公司开发的性能很高的物理备份工具

# 备份工具使用
## mysqldump的备份
_mysqldump常用参数_

1）连接服务端参数(基本参数)：-u -p -h -P -S

2）-A, --all-databases：全库备份

```bash
mysqldump -uroot -p123 -A > /backup/full.sql

```

3）不加参数：单库、单表多表备份

```bash
mysqldump -uroot -p123 db1 > /backup/db1.sql   				#备份db1库的所有数据
mysqldump -uroot -p123 world city > /backup/city.sql  #备份world库里的city表数据

```

4）-B：指定库备份

```bash
mysqldump -uroot -p123 -B db1 > /backup/db1.sql
mysqldump -uroot -p123 -B db1 db2 > /backup/db1_db2.sql  #备份 db1 和db2 库的所有数据

```

5）-F：flush logs在备份时自动刷新binlog（不怎么常用）

```bash
mysqldump -uroot -p123 -A -R –-triggers -F > /backup/full_2.sql

```

6）--master-data=2：备份时加入change master语句 0没有 1不注释 2注释

```bash
# 显示 bin_log 文件 position  方便后面的操作使用binlog日志恢复做参考 
mysqldump -uroot -p123 --master-data=2 >/backup/full.sql

# 1不注释恢复就会执行 change master语句, 方便后面扩展从库
mysqldump -uroot -p123 --master-data=1 >/backup/full.sql

--------------------------------------------------说明
① --master-data=1（默认，省略数字等价于 =1）
导出 SQL 里会生成可直接执行的语句：
CHANGE MASTER TO 
MASTER_LOG_FILE='mysql-bin.000123', 
MASTER_LOG_POS=15620;

② --master-data=2
上面那行语句会被注释掉（-- 开头）：
-- CHANGE MASTER TO 
-- MASTER_LOG_FILE='mysql-bin.000123', 
-- MASTER_LOG_POS=15620;
```

7）-d：仅表结构   (不常用)

8）-t：仅数据   (不常用)

**备份额外扩展项**

1）-R, --routines：备份存储过程和函数数据

2）--triggers：备份触发器数据

```bash
mysqldump -uroot -p123 -A -R --triggers > /backup/full_2.sql

----------------------------------------------------------#温备份: 备份过程不可写数据进去,可读
mysqldump -uroot -p -A --master-data=2 -R --triggers > /backup/full.sql  #常用备份语句  
```

****

**mysqldump特殊参数**

1）-x：锁表备份（myisam温备份）

2）--single-transaction：快照备份

```bash
# 快照备份是 热备份  #备份过程不会锁表
# --single-transaction 要配合 --master-data=2 去使用才是热备份
mysqldump -uroot -p123 -A -R --triggers --master-data=2 --single-transaction>/backup/full.sql

```

3)gzip:压缩备份

```bash
mysqldump -uroot -p123 -A -R --triggers --master-data=2 --single-transaction|gzip>/backup/full.sql.gz

#生产中备份命令-
mysqldump -uroot -p -A -R --triggers --master-data=2 --single-transaction|gzip >/backup/full_$(date +%F).sql.gz
#恢复
zcat full_xxx.sql.gz > /tmp/full.sql
mysql -uroot -p123 < /tmp/full.sql
# 一条命令备份恢复
zcat full_xxx.sql.gz | mysql -uroot -p123
```

**mysqldump的恢复**

```bash
#先不记录二进制日志
mysql> set sql_log_bin=0;
#库内恢复操作
mysql> source /backup/full.sql

#库外恢复操作
[root@db01 ~]# mysql -uroot -p123 < /backup/full.sql

```

**注意：**

1）mysqldump在备份和恢复时都需要MySQL实例启动为前提

2）一般数据量级100G以内，大约15-30分钟可以恢复（PB、EB就需要考虑别的方式）

3）mysqldump是以覆盖的形式恢复数据的

## 企业故障恢复案例
_背景：_

正在运行的网站系统，MySQL数据库，数据量25G，日业务增量10-15M。

_备份策略：_

每天23：00，计划任务调用mysqldump执行全备脚本

_故障时间点：_

上午10点开发人员误删除一个核心业务表，如何恢复？

_思路：_

1）停业务避免数据的二次伤害

2）找一个临时的库，恢复前一天的全备

3）截取前一天23：00到第二天10点误删除之间的binlog，恢复到临时库

4）测试可用性和完整性

5）开启业务前的两种方式

> a.直接使用临时库顶替原生产库，前端应用割接到新库
>
> b.将误删除的表单独导出，然后导入到原生产环境
>

6）开启业务

**故障模拟演练：**

_准备数据：_

```sql
# mysql -uroot -p123
-- #刷新binlog使内容更清晰
flush logs;
-- #查看当前使用的binlog
show master status;
-- #创建backup库
create database backup;
-- #进入backup库
use backup
-- #创建full表
create table full select * from world.city;
-- #创建full_1表
create table full_1 select * from world.city;
-- #查看表
show tables;

quit
```

__

_全备：_

```bash
mysqldump -uroot -p123 -A -R --triggers --master-data=2 --single-transaction|gzip > /backup/full_$(date +%F).sql.gz

```

__

_模拟数据变化：_

```sql
# mysql -uroot -p123
#进入backup库
use backup
#创建new表
create table new select * from mysql.user;
#创建new_1表
create table new_1 select * from world.country;
#查看表
mysql> show tables;
#查看full表中所有数据
mysql> select * from full;
#把full表中所有的countrycode都改成CHN
mysql> update full set countrycode='CHN' where 1=1;
#提交
mysql> commit;
#删除id大于200的数据
mysql> delete from full where id>200;
#提交
mysql> commit;
```

__

_模拟故障：_

```bash
#删除new表
mysql> drop table new;
#查看表
mysql> show tables;
```

__

_恢复过程：_

1）准备临时数据库

```bash
[root@db02 ~]# mysqld_safe --defaults-file=/data/3307/my.cnf &

```

2）拷贝数据到新库上

```bash
[root@db02 ~]# scp /backup/full_2018-08-16.sql.gz root@10.0.0.52:/tmp

```

3）解压全备数据文件

```bash
#进入tmp目录
[root@db02 ~]# cd /tmp/
#解压全备数据文件
[root@db02 tmp]# gzip -d full_2018-08-16.sql.gz
截取二进制

#查看全备的位置点（起始位置点）
[root@db02 tmp]# head -50 full_2018-08-16.sql |grep -i 'change master to'
-- CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.0000004', MASTER_LOG_POS=269848;

#找到drop语句执行的位置点（结束位置点）675367
mysql> show binlog events in 'mysql-bin.000004';
#上面方式查看不清
mysqlbinlog --base64-output=decode-rows -vvv /application/mysql/data/mysql-bin.000004

#截取二进制
mysqlbinlog -uroot -p123 --start-position=269848 --stop-position=675367 /application/mysql/data/mysql-bin.000004 > /tmp/inc.sql

#发送增量数据到新库
[root@db01 tmp]# scp /tmp/inc.sql root@10.0.0.52:/tmp
在新库内恢复数据
#不记录二进制日志
mysql> set sql_log_bin=0;
#恢复全备数据
mysql> source /tmp/full_2018-08-16.sql
#进入backup库
mysql> use backup
# 查看表
mysql> show tables;
#恢复增量数据
mysql> source /tmp/inc.sql
#查看表
mysql> show tables;
```

4）将故障表导出并恢复到生产

```bash
#导出new表
[root@db02 ~]# mysqldump -uroot -p123 -S /data/3307/mysql.sock backup new > /tmp/new.sql
#发送到生产库
[root@db02 ~]# scp /tmp/new.sql root@10.0.0.51:/tmp/

#进入backup库
mysql -uroot -p123
mysql> use backup
#在生产库恢复数据
mysql> source /tmp/new.sql
#查看表
mysql> show tables;

```

****

## 物理备份（Xtrabackup）
_Xtrabackup安装_

```bash
#下载epel源
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
#安装依赖
yum -y install perl perl-devel libaio libaio-devel perl-Time-HiRes perl-DBD-MySQL

# https://www.percona.com/downloads
#下载Xtrabackup
wget https://downloads.percona.com/downloads/Percona-XtraBackup-2.4/Percona-XtraBackup-2.4.4/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm

# wget https://downloads.percona.com/downloads/Percona-XtraBackup-2.4/Percona-XtraBackup-2.4.29/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.29-1.el7.x86_64.rpm

yum localinstall percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm

```

**备份方式（物理备份）**

1）对于非innodb表（比如myisam）是直接锁表cp数据文件，属于一种温备。

2）对于innodb的表（支持事务），不锁表，cp数据页最终以数据文件方式保存下来，并且把redo和undo一并备走，属于热备方式。

3）备份时读取配置文件/etc/my.cnf ; 恢复的时候也读会取配置文件,

### 全量备份
```bash
#全备
[root@db01 data]# innobackupex --user=root --password=123 /backup

#避免时间戳，自定义路径名
[root@db01 ~]# innobackupex --user=root --password=123 --no-timestamp /backup/full

#查看备份路径中的内容
[root@db01 backup]# ll /backup/full
#记录binlog文件名和binlog的位置点
-rw-r-----  1 root root       21 Aug 16 06:23 xtrabackup_binlog_info 
#备份时刻，立即将已经commit过的内存中的数据页刷新到磁盘 
#备份时刻有可能会有其他数据写入，已备走的数据文件就不会再发生变化了
#在备份过程中，备份软件会一直监控着redo和undo，一旦有变化会将日志一并备走
-rw-r-----  1 root root      117 Aug 16 06:23 xtrabackup_checkpoints
#备份汇总信息
-rw-r-----  1 root root      485 Aug 16 06:23 xtrabackup_info
#备份的redo文件
-rw-r-----  1 root root     2560 Aug 16 06:23 xtrabackup_logfile
```

****

**全备的恢复**

_准备备份_

将redo进行重做，已提交的写到数据文件，未提交的使用undo回滚，模拟CSR的过程

```bash
innobackupex --user=root --password=123 --apply-log /backup/full  # --apply-log 准备工作redo进行重做

```

_恢复备份_

前提1：被恢复的目录是空的

前提2：被恢复的数据库的实例是关闭的

```bash
#停库
[root@db01 full]# /etc/init.d/mysqld stop
#进入mysql目录
[root@db01 full]# cd /application/mysql
#删除data目录（在生产中可以备份一下）
[root@db01 mysql]# rm -fr data/
#拷贝数据
[root@db01 mysql]# innobackupex --copy-back /backup/full
#授权
[root@db01 mysql]# chown -R mysql.mysql /application/mysql/data/
#启动MySQL
[root@db01 mysql]# /etc/init.d/mysqld start
```

### 增量备份及恢复
_备份方式_

1）基于上一次备份进行增量

2）增量备份无法单独恢复，必须基于全备进行恢复

3）所有增量必须要按顺序合并到全备当中

```bash
#不使用之前的全备，执行一次全备
innobackupex --user=root --password=123 --no-timestamp /backup/full

```

_模拟数据变化_

```bash
mysql -uroot -p123

mysql> create database inc1;
mysql> use inc1
mysql> create table inc1_tab(id int);
mysql> insert into inc1_tab values(1),(2),(3);
mysql> commit;
mysql> select * from inc1_tab;
mysql> quit;
```

**第一次增量备份**

```bash
innobackupex --user=root --password=123 --no-timestamp --incremental --incremental-basedir=/backup/full/ /backup/inc1
参数说明:
--incremental：开启增量备份功能
--incremental-basedir：上一次备份的路径
```

**再次模拟数据变化**

```sql
# mysql -uroot -p123
create database inc2;
use inc2
create table inc2_tab(id int);
insert into inc2_tab values(1),(2),(3);
commit;
quit
```

**第二次增量备份**

```bash
innobackupex --user=root --password=123 --no-timestamp --incremental --incremental-basedir=/backup/inc1/ /backup/inc2
```

**增量恢复**

```bash
#破坏数据
[root@db01 ~]# rm -fr /application/mysql/data/
/etc/init.d/mysqld stop

```

**准备备份**

1）full+inc1+inc2

2）需要将inc1和inc2按顺序合并到full中

3）分步骤进行--apply-log

_第一步：在全备中apply-log时，只应用redo，不应用undo_

```bash
innobackupex --apply-log --redo-only /backup/full/
```

_第二步：合并inc1合并到full中，并且apply-log，只应用redo，不应用undo_

```bash
innobackupex --apply-log --redo-only --incremental-dir=/backup/inc1/ /backup/full/
```

_第三步：合并inc2合并到full中，redo和undo都应用_

```bash
innobackupex --apply-log --incremental-dir=/backup/inc2/ /backup/full/
```

_第四步：整体full执行apply-log，redo和undo都应用_

```bash
# cd /application/mysql
[root@db01 mysql]# innobackupex --apply-log /backup/full/
[root@db01 ~]# innobackupex --copy-back /backup/full/
[root@db01 ~]# chown -R mysql.mysql /application/mysql/data/
[root@db01 ~]# /etc/init.d/mysqld start
```

****

金融公司: 每小时增备,每天全备

****

**思考:**

企业级增量恢复实战

**背景：**

某大型网站，mysql数据库，数据量500G，每日更新量100M-200M

**备份策略：**

xtrabackup，每周六0:00进行全备，周一到周五及周日00:00进行增量备份。

**故障场景：**

周三下午2点出现数据库意外删除表操作。

**如何恢复？？？**

```bash
先用全备加增备恢复到周二的时间, 周三0点到下午2点的数据通过binlog 恢复

binglog的位置起点   在最后一次增备份的  文件里查看
# cat xtrabackup_binlog_info  #这个文件里有 binlog文件位置信息

```

> 更新: 2026-06-08 00:45:36  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/adhgeb>