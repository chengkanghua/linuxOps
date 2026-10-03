# 第十章· MySQL的主从复制

## 一.主从复制简介

<!-- OCR_START -->
- X☆
- http:/www:ctrip.com/sid= 1535078call
- 404
- PCtrip
- 携程
- 火年·汽车票·用车·门原·团购·攻路
- BOOM
- 酒店景点哈议国房·长佳
- 抱款！您所访问的页面不存在，请重新加载！
- 入日 mdd
- <返回首页
- 刷新网页
<!-- OCR_END -->

2015年5月28日11时，**12小时**后恢复，损失：平均**每小时106.48W$**

1）高可用

2）辅助备份

3）分担负载

复制是 MySQL 的一项功能，允许服务器将更改从一个实例复制到另一个实例。

1）主服务器将所有数据和结构更改记录到二进制日志中。

2）从属服务器从主服务器请求该二进制日志并在本地应用其内容。

3）IO：请求主库，获取上一次执行过的新的事件，并存放到relaylog

4）SQL：从relaylog中将sql语句翻译给从库执行

## 二.主从复制原理

**主从复制的前提**

1）两台或两台以上的数据库实例

2）主库要开启二进制日志

3）主库要有复制用户

4）主库的server_id和从库不同

5）从库需要在开启复制功能前，要获取到主库之前的数据（主库备份，并且记录binlog当时位置）

6）从库在第一次开启主从复制时，时必须获知主库：ip，port，user，password，logfile，pos

***

IP：10.0.0.51

Port：3306

User：rep

Password：oldboy123

logFile：mysql-bin.000002

Pos：120

***

7）从库要开启相关线程：IO、SQL

8）从库需要记录复制相关用户信息，还应该记录到上次已经从主库请求到哪个二进制日志

9）从库请求过来的binlog，首先要存下来，并且执行binlog，执行过的信息保存下来

**主从复制涉及到的文件和线程**

*主库：*

1）主库binlog：记录主库发生过的修改事件

2）dump thread：给从库传送（TP）二进制日志线程

*从库：*

1）relay-log（中继日志）：存储所有主库TP过来的binlog事件

2）master.info：存储复制用户信息，上次请求到的主库binlog位置点

3）IO thread：接收主库发来的binlog日志，也是从库请求主库的线程

4）SQL thread：执行主库TP过来的日志

*原理*

1）通过change master to语句告诉从库主库的ip，port，user，password，file，pos

2）从库通过start slave命令开启复制必要的IO线程和SQL线程

3）从库通过IO线程拿着change master to用户密码相关信息，连接主库，验证合法性

4）从库连接成功后，会根据binlog的pos问主库，有没有比这个更新的

5）主库接收到从库请求后，比较一下binlog信息，如果有就将最新数据通过dump线程给从库IO线程

6）从库通过IO线程接收到主库发来的binlog事件，存储到TCP/IP缓存中，并返回ACK更新master.info

7）将TCP/IP缓存中的内容存到relay-log中

8）SQL线程读取relay-log.info，读取到上次已经执行过的relay-log位置点，继续执行后续的relay-log日志，执行完成后，更新relay-log.info

***

<!-- OCR_START -->
- 主从复制原理
- 主从先决条件：1.主库开启binlog2.server-id主库和从库不同3.主库要有主从复制用户4.保证主从数据一致5.开启sql，IO线程
- 带着userhostbinlog pos去请求主库dump线程
- master（db02）主库
- slave（db03）从库
- 主库：show master status;
- TCPIP缓存
- 问：有没有比binlog1，pos：120更新的数据？
- 记录：binlog文件及位置点pos
- binglog2
- 120-520
- 创建主从用户：
- 10
- dump
- ACK
- grantreplication slave on**torep@'%'identifiedby'123';
- binlogposuser password
- port
- SQL
- 从库：
- master.info
- 主库binlogpos
- change masterto
- 主库连接信息
- master_host='10.0.0.52'
- relay-log.info
- master_user='rep'
- 上回读取的位置
- master_password=123'
- （中继日志）
- master_log_file='mysql-bin.000001'
- binlog
- relay-log中继日志
- master_log_pos=120
- mysql-bin.000002
- 520
- binlog2 120-520
- 开启IO线程和sQL线程：startslave；
<!-- OCR_END -->

***

***

### 主从复制搭建实战

*主库操作:*

1）修改配置文件

```bash
#编辑mysql配置文件
[root@db01 ~]# vim /etc/my.cnf
#在mysqld标签下配置
[mysqld]
#主库server-id为1，从库不等于1
server_id =1
#开启binlog日志
log_bin=mysql-bin

# /etc/init.d/mysqld restart
```

2）创建主从复制用户

```bash
#登录数据库
[root@db01 ~]# mysql -uroot -poldboy123
#创建rep用户
mysql> grant replication slave on *.* to rep@'10.0.0.%' identified by 'oldboy123';

# 查看bin_log position  #记录主库binlog及位置点
[(none)]>show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000001 |      324 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)

```

*从库操作:*

1）修改配置文件

```bash
#修改db02配置文件
[root@db02 ~]# vim /etc/my.cnf
#在mysqld标签下配置
[mysqld]
#主库server-id为1，从库不等于1
server_id =5
#重启mysql
[root@db02 ~]# /etc/init.d/mysqld restart
#记录主库binlog及位置点
mysql> show master status;

#登陆数据库
[root@db02 ~]# mysql -uroot -poldboy123
mysql> help change master to

#执行change master to 语句
mysql> change master to
-> master_host='10.0.0.51',
-> master_user='rep',
-> master_password='oldboy123',
-> MASTER_LOG_FILE='mysql-bin.000001',
-> master_log_pos=324,
-> MASTER_PORT=3306;

change master to 
master_host='10.0.0.10',
master_user='rep',
master_password='oldboy123',
master_log_file='mysql-bin.000001',
master_log_pos=324,
master_port=3306;

mysql> start slave;
mysql> show slave status\G

         Slave_IO_Running: Yes
        Slave_SQL_Running: Yes

-------------------------扩展
-- 取消从库
stop slave;  -- 关闭sql和io线程
reset slave all; 重置从库信息.

reset master; #会把binlog文件重置 mysql-bin.000001  120
```

## 四.主从复制基本故障处理

**IO线程**

*连接主库*

1）user password ip port

2）网络：不通，延时高，防火墙

*请求binlog*

1）binlog不存在或者损坏

*更新relay-log和master.info*

**

**SQL线程**

> 1）relay-log出现问题
>
> 2）从库做写入了

* 操作对象已存在（create）
* 操作对象不存在（insert update delete drop truncate alter）
* 约束问题、数据类型、列属性

**处理方法一：**

```bash
#临时停止同步
mysql> stop slave;
#将同步指针向下移动一个（可重复操作）
mysql> set global sql_slave_skip_counter=1;
#开启同步
mysql> start slave;
```

**处理方法二：**

```bash
#编辑配置文件
[root@db01 ~]# vim /etc/my.cnf
#在[mysqld]标签下添加以下参数  ,
# 数字是报错号, 在 show slave status\G 里Last_SQl_Errno: 1032
slave-skip-errors=1032,1062,1007

```

**但是以上操作都是有风险存在的**

****

**处理方法三：**

1）重新备份数据库，恢复到从库

2）给从库设置为只读  (读写分离)

```bash
#在命令行临时设置
set global read_only=1;
#在配置文件中永久生效
read_only=1

```

## 五.延时从库

**普通的主从复制可能存在不足**

1）逻辑损坏怎么办？

2）不能保证主库的操作，从库一定能做

3）高可用？自动failover？

4）过滤复制

**企业中一般会延时3-6小时**

**延时从库配置方法**

```bash
#停止主从
mysql>stop slave;
#设置延时为180秒
mysql>CHANGE MASTER TO MASTER_DELAY = 180;
#开启主从
mysql>start slave;
#查看状态
mysql> show slave status \G
SQL_Delay: 180
3.延时从库停止方法
#停止主从
mysql> stop slave;
#设置延时为0
mysql> CHANGE MASTER TO MASTER_DELAY = 0;
#开启主从
mysql> start slave;

原理: ----- 延时从库是在sql线程做了手脚 延长时间执行sql.
```

****

**延时从库恢复数据案例**

```plsql
思考问题：
总数据量级500G，正常备份去恢复需要1.5-2小时
1）配置延时3600秒
mysql>CHANGE MASTER TO MASTER_DELAY = 3600;
2）主库
drop database db;

3）怎么利用延时从库，恢复数据？
提示：
1、从库relaylog存放在datadir目录下
2、mysqlbinlog 可以截取relaylog内容
3、show relay log events in 'db01-relay-bin.000001';
处理的思路：
1）停止SQL线程
mysql> stop slave sql_thread;
2）截取relaylog到误删除之前点
● relay-log.info 获取到上次运行到的位置点，作为恢复起点
● 分析relay-log的文件内容，获取到误删除之前position

```

**模拟故障及恢复：**

```sql
1）关闭延时
mysql -S /data/3308/mysql.sock -p123
mysql> stop slave;
mysql> CHANGE MASTER TO MASTER_DELAY = 0;
mysql> start slave;

2）模拟数据
mysql -S /data/3307/mysql.sock -p123
source  /root/world.sql
use world;
create table c1 select * from city;
create table c2 select * from city;

3）开启从库延时5分钟
mysql -S /data/3308/mysql.sock
show slave status \G
mysql>stop slave;
mysql>CHANGE MASTER TO MASTER_DELAY = 300;
mysql>start slave;

mysql -S /data/3307/mysql.sock
use world;
create table c3 select * from city;
create table c4 select * from city;

4）破坏，模拟删库故障。(以下步骤在5分钟内操作完成。)
mysql -S /data/3307/mysql.sock
drop database world;

5）从库，关闭SQL线程
# drop database 已经在从库的 relay-log 里了
# 但 SQL 线程已停止，永远不会执行删除命令，数据保住了！
mysql -S /data/3308/mysql.sock
stop slave sql_thread;

6）截取relay-log
起点：
cd /data/3308/data/
cat relay-log.info
./db01-relay-bin.000002
283

终点：
mysql -S /data/3308/mysql.sock -p123
show relaylog events in 'db01-relay-bin.000002'
  db01-relay-bin.000002 | 268047 
#也可以在命令行查看 #查看drop database world;前一个pos点  393
mysqlbinlog db01-relay-bin.000002

mysqlbinlog --start-position=283  --stop-position=268047 /data/3308/data/db01-relay-bin.000002 >/tmp/relay.sql

在从库恢复relay.sql
1）取消从库身份
mysql -S /data/3308/mysql.sock -p123
mysql> stop slave;
mysql> reset slave all;
2）恢复数据
mysql> set sql_log_bin=0;  -- 当前会话关闭二进制日志记录
mysql> source /tmp/relay.sql
mysql> use world
mysql> show tables;

# 收尾（可选）
从库 3308 数据已完整恢复
可以将 3308 切换为新主库，对外提供服务
主库 3307 废弃或重新搭建从库

```

## 六.半同步复制

## 一、极简背诵版（10 秒简答，口头直接说）

半同步复制介于异步和全同步之间。主库提交事务后，**不会立刻返回客户端**，会等待**至少一个从库**把 binlog 拉取并写入本地中继日志（relay-log）、返回确认包后，再响应客户端；如果等待超时，会自动降级为普通异步复制。 作用：大幅降低异步模式的数据丢失风险，同时兼顾性能。

***

## 二、标准面试版（30~60 秒，主流回答，推荐）

### 1. 核心概念

MySQL 半同步复制是基于插件实现的增强复制模式，弥补**默认异步复制**的数据丢失隐患，又规避**全同步复制**性能过低的问题，MySQL 5.5 及以上版本原生支持。

### 2. 核心工作流程

1. 客户端在主库执行事务并提交，主库将变更写入 `binlog`；
2. 主库 Binlog Dump 线程推送日志给从库 IO 线程；
3. **从库 IO 线程接收 binlog 并落地到本地 relay-log 后，主动给主库发送 ACK 确认包**；
4. 主库收到**至少一台从库**的 ACK 应答，才告知客户端「事务提交成功」；
5. 从库后续由 SQL 线程**异步回放**中继日志，和普通主从逻辑一致。

### 3. 关键容错机制

主库有**超时阈值**，若指定时间内没收到从库 ACK，会**自动降级为异步复制**，避免主库长时间阻塞、业务不可用。

***

## 三、深度拆解（面试官追问细节，必背考点）

### 1. 三种复制模式横向对比

表格

| **复制模式** | **核心逻辑** | **数据安全性** | **性能** | **生产使用场景** |
| :--- | :--- | :--- | :--- | :--- |
| 异步（默认） | 主库写完 binlog 立即返回，不等从库 | 低（主库宕机可能丢未传输日志） | 最优 | 大部分读写分离、非核心业务 |
| 半同步 | 等至少 1 个从库落地 relay-log 再返回 | 高（主流防丢数据方案） | 轻微损耗 | 核心业务、要求数据尽量不丢失 |
| 全同步 | 等待**所有从库**执行完 SQL 再返回 | 最高 | 极差 | 几乎不用，仅极端强一致场景 |

### 2. 两大核心误区（面试高频坑）

❌ 误区 1：半同步需要等待从库 **SQL 线程执行完日志** ✅ 正解：**只等 IO 线程把 binlog 写入 relay-log**，不等 SQL 回放，这是性能损耗小的关键。

❌ 误区 2：半同步永远不会退化成异步 ✅ 正解：主库等待超时后，自动降级为异步；网络恢复后，**不会自动切回半同步**，需要手动重启复制或插件。

### 3. 依赖插件 & 核心参数（实操 + 面试考点）

半同步是**独立插件**，主、从库需要分别加载：

* 主库插件：`rpl_semi_sync_master`
* 从库插件：`rpl_semi_sync_slave`

常用系统变量（可动态修改）：

```sql
-- 主库：开启半同步
SET GLOBAL rpl_semi_sync_master_enabled = 1;
-- 从库：开启半同步
SET GLOBAL rpl_semi_sync_slave_enabled = 1;

-- 主库超时时间（单位：毫秒，默认 1000ms=1秒）
-- 超过这个时间没收到ACK，降级为异步
SET GLOBAL rpl_semi_sync_master_timeout = 1000;
```

### 4. 优缺点总结

#### 优点

1. 相比异步：数据落地到从库 relay-log，**极大降低主库宕机导致的数据丢失概率**；
2. 相比全同步：仅多一次网络 ACK 交互，性能损耗很小；
3. 自带超时降级机制，保证业务高可用。

#### 缺点

1. 相比纯异步，增加网络往返，**有轻微性能下降**；
2. 降级为异步后，就失去半同步的安全特性；
3. 无法做到 100% 绝对不丢数据（极端场景：从库写完 relay-log 未刷盘就宕机）。

### 5. 拓展：无损半同步（MySQL 5.7+ 新特性）

MySQL 5.7 推出 **Lossless Semi-Sync（无损半同步）**，进一步优化：

* 约束：主库必须确认 binlog 已经被从库接收，**才会清理本地 binlog**；
* 彻底解决旧版半同步「主库提前清理 binlog，从库又丢失日志」的极端问题；
* 现在生产环境基本都开启无损半同步。

***

## 四、完整工作时序图（串联之前学的主从线程）

```plain
客户端 → 主库(执行事务 → 写binlog)
                ↓
        Binlog Dump线程 → 推送binlog
                ↓
        从库IO线程 → 写入relay-log → 发送ACK确认
                ↓
        主库收到ACK → 返回「提交成功」给客户端
                ↓
        从库SQL线程（异步）→ 回放relay-log 完成数据同步
```

***

## 五、面试连环提问速答（直接背）

1. **问：半同步等待什么？** 答：等待从库 IO 线程将 binlog 写入中继日志后返回的 ACK，不等待 SQL 线程执行。
2. **问：需要几个从库确认？** 答：默认至少 **1 台** 从库返回 ACK 即可。
3. **问：超时后会怎样？** 答：自动降级为普通异步复制，保证业务不阻塞。
4. **问：半同步是内核功能吗？** 答：不是，是**插件形式**，主从库都需要手动加载并开启。
5. **问：和延时从库能一起用吗？** 答：可以，两者功能不冲突：半同步保障数据传输安全，延时从库用于防误删 / 误改。

**半同步复制开启方法**

1）安装（主库）

```bash
#登录数据库
[root@db01 ~]# mysql -uroot -poldboy123
#查看是否有动态支持
mysql> show global variables like 'have_dynamic_loading';
#安装自带插件 # ll /application/mysql/lib/plugin/
mysql> INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';
#启动插件
mysql> SET GLOBAL rpl_semi_sync_master_enabled = 1;
#设置超时 1000秒
mysql> SET GLOBAL rpl_semi_sync_master_timeout = 1000;
#修改配置文件
[root@db01 ~]# vim /etc/my.cnf
#在[mysqld]标签下添加如下内容（不用重启库）
[mysqld]
rpl_semi_sync_master_enabled=1
rpl_semi_sync_master_timeout=1000
检查安装：
mysql> show variables like'rpl%';
mysql> show global status like 'rpl_semi%';
```

2）安装（从库）

```bash
#登录数据库
[root@mysql-db02 ~]# mysql -uroot -poldboy123
#安装slave半同步插件
mysql>  INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';
#启动插件
mysql> SET GLOBAL rpl_semi_sync_slave_enabled = 1;
#重启io线程使其生效
mysql> stop slave io_thread;
mysql> start slave io_thread;
#编辑配置文件（不需要重启数据库）
[root@mysql-db02 ~]# vim /etc/my.cnf
#在[mysqld]标签下添加如下内容
[mysqld]
rpl_semi_sync_slave_enabled =1

相关参数说明:
参数											作用							默认值
rpl_semi_sync_master_wait_for_slave_count	主库需等待 ACK的从库最小数量	    1
rpl_semi_sync_master_timeout				等待 ACK 的超时时间（毫秒）	    10000（10 秒）
rpl_semi_sync_master_wait_no_slave			从库不足时是否继续等待				ON

官方行为描述（Oracle MySQL 5.7 文档）
当 rpl_semi_sync_master_wait_no_slave=ON 时，允许在超时期间内从库数量降至小于 rpl_semi_sync_master_wait_for_slave_count。只要在超时前有足够从库确认事务，主库就保持半同步；否则降级为异步。
当 rpl_semi_sync_master_wait_no_slave=OFF 时，若从库数量在任何时候降至小于等待阈值，主库立即恢复为异步复制。
```

***

**测试半同步**

```plsql
#创建两个数据库，test1和test2  主库操作
create database test1;
create database test2;

#查看复制状态
mysql> show global status like 'rpl_semi%';
+--------------------------------------------+-------+
| Variable_name                              | Value |
+--------------------------------------------+-------+
| Rpl_semi_sync_master_clients               | 1     |
| Rpl_semi_sync_master_net_avg_wait_time     | 768   |
| Rpl_semi_sync_master_net_wait_time         | 1497  |
| Rpl_semi_sync_master_net_waits             | 2     |
| Rpl_semi_sync_master_no_times              | 0     |
| Rpl_semi_sync_master_no_tx                 | 0     |
| Rpl_semi_sync_master_status                | ON    |
| Rpl_semi_sync_master_timefunc_failures     | 0     |
| Rpl_semi_sync_master_tx_avg_wait_time      | 884   |
| Rpl_semi_sync_master_tx_wait_time          | 1769  |
| Rpl_semi_sync_master_tx_waits              | 2     |
| Rpl_semi_sync_master_wait_pos_backtraverse | 0     |
| Rpl_semi_sync_master_wait_sessions         | 0     |
#此行显示2，表示刚才创建的两个库执行了半同步
| Rpl_semi_sync_master_yes_tx                | 2     | 
+--------------------------------------------+-------+
14 rows in set (0.06 sec)
#从库查看
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
| test1              |
| test2              |
+--------------------+

#关闭半同步（1:开启 0:关闭） 主库上执行
mysql> SET GLOBAL rpl_semi_sync_master_enabled = 0;
#查看半同步状态
mysql> show global status like 'rpl_semi%';
+--------------------------------------------+-------+
| Variable_name                              | Value |
+--------------------------------------------+-------+
| Rpl_semi_sync_master_clients               | 1     |
| Rpl_semi_sync_master_net_avg_wait_time     | 768   |
| Rpl_semi_sync_master_net_wait_time         | 1497  |
| Rpl_semi_sync_master_net_waits             | 2     |
| Rpl_semi_sync_master_no_times              | 0     |
| Rpl_semi_sync_master_no_tx                 | 0     |
| Rpl_semi_sync_master_status                | OFF   | #状态为关闭
| Rpl_semi_sync_master_timefunc_failures     | 0     |
| Rpl_semi_sync_master_tx_avg_wait_time      | 884   |
| Rpl_semi_sync_master_tx_wait_time          | 1769  |
| Rpl_semi_sync_master_tx_waits              | 2     |
| Rpl_semi_sync_master_wait_pos_backtraverse | 0     |
| Rpl_semi_sync_master_wait_sessions         | 0     |
| Rpl_semi_sync_master_yes_tx                | 2     | 
+--------------------------------------------+-------+
14 rows in set (0.00 sec)
#再一次创建两个库
create database test3;
create database test4;

#再一次查看半同步状态
mysql> show global status like 'rpl_semi%';
+--------------------------------------------+-------+
| Variable_name                              | Value |
+--------------------------------------------+-------+
| Rpl_semi_sync_master_clients               | 1     |
| Rpl_semi_sync_master_net_avg_wait_time     | 768   |
| Rpl_semi_sync_master_net_wait_time         | 1497  |
| Rpl_semi_sync_master_net_waits             | 2     |
| Rpl_semi_sync_master_no_times              | 0     |
| Rpl_semi_sync_master_no_tx                 | 0     |
| Rpl_semi_sync_master_status                | OFF   |
| Rpl_semi_sync_master_timefunc_failures     | 0     |
| Rpl_semi_sync_master_tx_avg_wait_time      | 884   |
| Rpl_semi_sync_master_tx_wait_time          | 1769  |
| Rpl_semi_sync_master_tx_waits              | 2     |
| Rpl_semi_sync_master_wait_pos_backtraverse | 0     |
| Rpl_semi_sync_master_wait_sessions         | 0     |
#此行还是显示2，则证明，刚才的那两条并没有执行半同步否则应该是4
| Rpl_semi_sync_master_yes_tx                | 2     | 
+--------------------------------------------+-------+
14 rows in set (0.00 sec)
注:不难发现，在查询半同步状态是，开启半同步，查询会有延迟时间，关闭之后则没有

```

## 七.过滤复制

```bash
主库：
白名单:只记录白名单中列出的库的二进制日志
● binlog-do-db
黑名单：不记录黑名单列出的库的二进制日志
● binlog-ignore-db

从库：
白名单：只执行白名单中列出的库或者表的中继日志
● --replicate-do-db=test
● --replicate-do-table=test.t1
● --replicate-wild-do-table=test.t2
黑名单：不执行黑名单中列出的库或者表的中继日志
● --replicate-ignore-db
● --replicate-ignore-table
● --replicate-wild-ignore-table
```

**复制过滤 test**

```bash
# 从库配置
# vim /data/3308/my.cnf 
#在[mysqld]标签下添加
replicate-do-db=world
#关闭MySQL
mysqladmin -S /data/3308/mysql.sock  shutdown
#启动MySQL
mysqld_safe --defaults-file=/data/3308/my.cnf &

测试复制过滤：
第一次测试：
1）主库：
# mysql -uroot -p123 -S /data/3307/mysql.sock 
mysql> use world
mysql> create table t1(id int);
2）从库查看结果：
# mysql -uroot -p123 -S /data/3308/mysql.sock 
mysql> use world
mysql> show tables;

第二次测试：
1）主库：
# mysql -uroot -p123 -S /data/3307/mysql.sock 
mysql> use test
mysql> create table tb1(id int);
2）从库查看结果：
# mysql -uroot -p123 -S /data/3308/mysql.sock 
mysql> use test
mysql> show tables;

```

> 更新: 2026-06-08 20:28:56  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ig3inh>