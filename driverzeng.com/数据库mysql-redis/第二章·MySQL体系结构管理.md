# 第二章· MySQL体系结构管理

# 一.客户端与服务器模型

<!-- OCR_START -->
- 数据库
- PHP
- mysqld
- TCP/IP
- MySQL服务器进程
- Linux
- TCPAP
- 套接字
- (Jocalhosn
- mysql
- 客户机
- 进程
<!-- OCR_END -->

+ _**1.mysql是一个典型的C/S服务结构**_
- _**  1.1 mysql自带的客户端程序（/application/mysql/bin）**_
        * _**    mysql**_
        * _**    mysqladmin**_
        * _**    mysqldump**_

 

+ _**1.2 mysqld一个二进制程序，后台的守护进程**_
- _**  单进程**_
- _**  多线程**_

 

+ _**2.应用程连接MySQL方式**_
- _**  TCP/IP的连接方式**_

<!-- OCR_START -->
- 数据库
- PHP
- mysqld
- TCP/IP
- MySQL服务器进程
- Linux
- 套接字
- (localhost)
- mysql
- 客户机
- 进程
- mysql-uroot-poldboy123-h10.0.0.52
- 客户端
- 服务端
<!-- OCR_END -->

- _**套接字连接方式**_

<!-- OCR_START -->
- 数据库
- PHP
- mysgld
- SOCKET
- MySOL服务器进程
- Linux
- (localhost)
- mysql
- 客户机
- 进程
- mysql-uroot-poldboy123-S/tmp/mysql.sock
- 客户端
- 服务端
<!-- OCR_END -->

 

_**思考：mysql -uroot -poldboy123是使用了哪个连接方式？？？**_

 配置文件如果没有指定网络连接参数, 默认是 socket 连接.

# 二.MySQL服务器构成
 

_**什么是实例**_

 

+ 1.MySQL的后台进程+线程+预分配的内存结构。
+ 2.MySQL在启动的过程中会启动后台守护进程，并生成工作线程，预分配内存结构供MySQL处理数据使用。

 

<!-- OCR_START -->
- Microsoft
- OfficeWord
- 2007
- oldboy.docx
<!-- OCR_END -->

图1.1-word的打开方式

<!-- OCR_START -->
- mysqld
- oldboy.ibd
- 96.0KB
- 10.4KB
<!-- OCR_END -->

图1.2-mysqld的打开方式

_****_

_****_

_**MySQLD服务器程序构成**_

 

<!-- OCR_START -->
- 应用程序
- 连接层
- pibsu
- SQL层
- 存储引擎层
- 磁盘
- 内存
- 网络
<!-- OCR_END -->

_**mysqld是一个守护进程但是本身不能自主启动：**_

```plain
mysql -uroot -poldboy123
select user,host,password from mysql.user;
```

 

_**连接层**_

+ 1、提供连接协议（socket、tcp/ip）
+ 2、验证用户的合法性（用户名、密码、白名单）
+ 3、提供一个专用连接线程（接收SQL、返回结果），将SQL语句交给SQL层继续处理

 

<!-- OCR_START -->
- SQL层
- 开始
- 检查高速缓存查询
- 选择？
- 解析查询
- 优化查询
- 找到？
- 执行查询
- 更新高速缓存查询
- 完成
<!-- OCR_END -->

_**SQL层**_

+ 1、接收到SQL语句，语法判断。
+ 2、判断语义（判断语句类型：DML、DDL、DCL、DQL）
+ 3、解析SQL语句，生成多种执行计划
+ 4、优化器，选择他认为成本最低的执行计划。
+ 5、执行器根据优化器的选择，按照优化器建议执行SQL语句，得到去哪儿找SQL语句需要访问的数据
- 5.1 具体：在哪个数据文件上的哪个数据页中？
- 5.2 将以上结果充送给下层继续处理
+ 6、接收存储引擎层的数据，结构化成表的形式，通过连接层提供的专用线程，将表数据返回给用户。
+ 7、提供查询缓存
- 7.1 query_cache, 使用memcache 或者redis 替代
+ 8、日志记录（binlog）

 

_**存储引擎层**_

+ 1、接收上层的执行结果
+ 2、取出磁盘文件和相应数据
+ 3、返回给SQL层，结构化之后生成表格，由专用线程返回给客户端

# 三.MySQL的结构

_**MySQL的逻辑结构（熟悉）**_

_MySQL的逻辑对象：做为管理人员或者开发人员操作的对象_

+ 1、库
+ 2、表：元数据+真实数据行
+ 3、元数据：列+其它属性（行数+占用空间大小+权限）
+ 4、列：列名字+数据类型+其他约束（非空、唯一、主键、非负数、自增长、默认值）

_最直观的数据：二维表，必须用库来存放_

<!-- OCR_START -->
- mysql> select user,password ,host from mysql.user;
- userpasswordhost
- root
- localhost|
- db01
- 127.0.0.11
- :: 1
- 6rows in set （0.o0 sec）
<!-- OCR_END -->

_MySQL逻辑结构与Linux系统对比_

| MySQL | Linux |
| :--- | :--- |
| 库 | 目录 |
| show databases; | ls-l / |
| use mysql | cd /mysql |
| 表 | 文件 |
| show tables; | ls |
| 二维表=元数据+真实数据行 | 文件=文件名+文件属性 |

 

_**MySQL的物理结构（了解）**_

1）MySQL的最底层的物理结构是数据文件，也就是说，存储引擎层，打交道的文件，是数据文件。

2）存储引擎分为很多种类（Linux中的FS）

3）不同存储引擎的区别：存储方式、安全性、性能

myisam：

![1553426698583-a1f60ba3-44bd-43fd-a840-96fe13f31d49.jpeg](img/第二章·MySQL体系结构管理/image9.jpeg)

 

innodb：



<!-- OCR_START -->
> 8556
> 98304
<!-- OCR_END -->



 

_**段、区、页（块）**_

+ 1、段：理论上一个表就是一个段，由多个区构成，（分区表是一个分区一个段）
+ 2、区：连续的多个页构成
+ 3、页：最小的数据存储单元，默认是16k

----------------------------------------------------------

# InnoDB引擎的逻辑存储结构 
，如下图所示：

<!-- OCR_START -->
- 表空间（Tablespace)
- lhhoDB逻辑存储结构
- Leafnodesegment
- None-Leafnode segment
- 1T码客出品：https://blog.csdn.net/u010647035
- Rollbacksegment
- 段（Segmenf)
- 区（Extent)
- Extent
- 行(Row)
- 页(Page)
- Trx id
- Row
- Roll Pointer
- Kow
- Col 1
- Col2
- Col 3
- Col4
- Col n
- nttps://blog.csdn.net/u010647035
<!-- OCR_END -->

**表空间 **

InnoDB 表空间（Tablespace）可以看做一个逻辑概念，InnoDB 把数据保存在表空间，本质上是一个或多个磁盘文件组成的虚拟文件系统。InnoDB 表空间不仅仅存储了表和索引，它还保存了回滚日志（redo log）、插入缓冲（insert buffer）、双写缓冲（doublewrite buffer）以及其他内部数据结构。

默认情况下InnoDB存储引擎有一个共享表空间ibdata1，即所有数据都放在这个表空间内。如果我们配置了参数 innodb_file_per_table，则每张表内的数据可以单独放到一个表空间内。其对应的存储文件都放在 innodb_data_home_dir 指定的目录下。

当启用了 innodb_file_per_table 参数选项，需要注意的是，每张表的表空间内存放的只是数据、索引和插入缓冲，其它的数据，如撤销（Undo）信息、系统事务信息、二次写缓冲（double write buffer）等还是存放在原来的共享表空间内。这也就说明了另一个问题：即使在启用了参数 innodb_file_per_table ，共享表空间还是会不断地增加其大小。

从 InnoDB 逻辑存储结构来看，所有的数据都被逻辑的存放在一个空间中，这个空间就叫做表空间（tablespace）。表空间有 段（segment）、区（extent）、页（page）组成。

**段**

段， 分为数据段（Leaf node segment）、索引段（Non-leaf node segment）、回滚段

（Rollback segment），InnoDB是索引组织表，

数据段就是B+树的叶子节点， 

索引段即为B+树的非叶子节点。

回滚段用于数据的回滚和多版本控制,  

一个段包含256个区(256M大小)。

**区**

区是页的集合， 默认情况下， 

InnoDB存储引擎页大小为16K， 

一个区包含64个连续的页，

默认大小为 1MB (64*16K)。

**页**

页，是InnoDB 存储引擎磁盘管理的最小单元，每个页的大小默认为 16KB。为了保证页的连续性，InnoDB 存储引擎每次从磁盘申请 4-5 个区。

**行**

行，InnoDB 存储引擎数据是按行进行存放的。在行中，默认有两个隐藏字段：

Trx_id：每次对某条记录进行改动时，都会把对应的事务id赋值给trx_id隐藏列。

Roll_pointer：每次对某条引记录进行改动时，都会把旧的版本写入到undo日志中，然后这个隐藏列就相当于一个指针，可以通过它来找到该记录修改前的信息。

> 更新: 2024-09-13 12:23:36  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/nhske7>