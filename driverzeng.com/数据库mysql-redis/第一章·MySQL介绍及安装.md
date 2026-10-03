# 第一章·MySQL介绍及安装

## 第一章·MySQL介绍及安装

## 一.DBA工作内容及课程体系
 
<!-- OCR_START -->
- 开发DBA
- 运维DBA
- MySQL和PHP客户端程序开发
- MySQL基础安装、搭建
- 初级
- 中级
- MySQL开发者基本SQL开发
- MySQL数据库管理员
- 高级
- MySQL高级存储过
- MySQL高级开发、
- 基于业务
- 程、正
- 函数等
- MySQL性能调节
- MySQL Cluster
- MySQL高可用性
- 的SQL改写、调优
<!-- OCR_END -->

## 二.MySQL课程体系介绍

<!-- OCR_START -->
- 什么是数据
- DBMS数据库管理系统介绍
- RDBMS与NoSQL
- 数据导入导出实现数据库迁移
- 数据库行业介绍
- 数据库产品行业排名
- 第三方工具实现异构数据库迁移
- 数据库导入导出工具
- 各公司产品介绍
- MySQL客户端工具
- MySQL数据库产品应用场景
- MySQL简介及部署
- 存储引擎的分类
- MyISAM与InnoDB引擎对比
- 安装方式介绍
- 存储引擎的介绍
- 存储引擎设置
- 软件获取方式
- 简介及产品线
- MySQL日志管理
- 编译安装详解
- 多实例简介及部署
- MySQL错误日志配置及查看
- MySQL体系结构
- MySQL二进制日志介绍及管理
- MySQL日志类型介绍
- MySQL慢日志设置及管理实践
- 实例简介
- MySQL备份恢复
- 服务器程序体系结构
- 数据库逻辑结构
- 客户端连接模型
- MySQL备份方式介绍
- 数据库存储结构
- MySQL备份工具介绍
- 存储底层结构
- mysqldump逻辑备份详解
- MySQL服务器配置管理
- mysqldump+binlog增量备份恢复详解
- 企业级备份策略及恢复案例
- MySQL用户及权限管理
- 企业不完全恢复案例实践
- MySQL的启动和关闭
- Xtrabackup物理备份工具详解
- MySQL的连接管理
- MySQL数据库配置文件详解
- 企业级物理备份恢复方案实战
- 数据库对象管理
- MySQL课程体系介绍
- MySQL复制技术
- MySQLSQL开发
- 主从复制简介
- MySQL获取帮助
- 主从复制原理
- DDL语句-管理数据库
- 基本主从复制搭建实践
- DDL语句-管理表对象
- 主从复制状态监控
- DCL语句-用户和权限管理
- 主从复制基本故障处理
- MySQL基本功能命令
- DML语句管理表记录数据
- 主从复制架构演变
- 传统备份方案缺陷
- SELECT检索数据库数据
- 一主多从及多主多从架构实现
- MySQL搜索引擎管理
- 主主复制架构实践
- EXPLAIN获取、执行计划及分析
- 主从复制高级功能介绍实践
- MySQL字符集
- 5.6新特性GTID复制介绍及实践
- MySQL高可用架构及读写分离
- 字符集管理
- 字符集介绍
- MySQL元数据获取
- MHA高可用架构详解及实战
- MySQL读写分离解决方案介绍
- SHOW命令详解
- MySQL高可用架构产品介绍
- INFORMATION_SCHEMA获取元数据
- Atlas实现MySQL数据库读写分离
- MySQLInnoDB存储引擎管理
- MySQL5.7新特性
- nnoDB存储引擎功能
- MySQL主从复制新特性
- 查看及设置存储引擎
- MySQL高可用方案MGR
- 安装部署的新特性
- InnoDB存储引擎物理存储结构
- MySQL优化
- InnoDB存储引擎介绍
- 事物简介
- 事物的处理过程
- InnoDB内存线程结构
- 数据导入导出及迁移
<!-- OCR_END -->

## 三.DBA的职业素养
 

<!-- OCR_START -->
- DBA的职业素养
- 人品
- 心态
- 熟悉操作系统
- 熟悉业务
- 熟悉行业
- 喜欢数据库
- 不要删库跑路
- delete
- 备份
- 处理故障要冷静
- 熟悉linux命令
- 开发需要熟悉业务
- 金融
- 一提到数据库就兴奋
- 不要随意甩锅
- drop
- 测试
- 出了事故别慌乱
- 熟悉常用服务
- 运维只需要熟悉流程
- 互联网
- 对公司数据感兴趣
- truncate
- 避免直接敲命令
- 电商
<!-- OCR_END -->

## 四.MySQL简介及安装
### 01 什么是数据?

数据(data)是事实或观察的结果，是对客观事物的逻辑归纳，是用于表示客观事物的未经加工的的原始素材。

数据可以是连续的值，比如声音、图像，称为模拟数据。也可以是离散的，如符号、文字，称为数字数据。

在计算机系统中，数据以二进制信息单元0,1的形式表示。

 

_**数据的定义:**_ 数据是指对客观事件进行记录并可以鉴别的符号，是对客观事物的性质、状态以及相互关系等进行记载的物理符号或这些物理符号的组合。它是可识别的、抽象的符号。*

 

### 02 什么是数据库管理系统
 

_**DBMS（database management system）**_



<!-- OCR_START -->
> 存储数据
> 管理数据
<!-- OCR_END -->



### 03 数据库管理系统种类
 

_**RDBMS**_

以多张二维表的方式来存储，又给多张表建立了一定的关系（关系型数据库）

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

 

_**NoSQL**_

左边rdbms右边nosql 很多以json格式进行存储数据的（mogodb）

<!-- OCR_START -->
- People:
- “姓名”：“M”
- 姓名
- 性别
- 年龄
- 住址
- “性别”：“男”，
- 25
- ID
- “年龄”：“25”，
- .....
- ...
- ..
- 1
- “国家”：“中国”，
- Address:
- “城市”：“北京”，
- 国家
- 城市
- 街道
- “街道”：“朝阳区北苑路108号
- 中国
- 北京
- 朝阳区北苑路108号
<!-- OCR_END -->

_**RDMS与NoSQL对比**_

 

---

+ _**功能性能对比:**_

 

<!-- OCR_START -->
- 关系型数据库
- 非关系型数据库
- 强大的查询功能
- 强一致性
- 二级索引
- 灵活模式
- 扩展性
- 性能
<!-- OCR_END -->

 

---

+ _**特点对比:**_

_关系型数据库（RDBMS）的特点：_

+ 1.二维表
+ 2.典型产品Oracle传统企业，MySQL互联网企业
+ 3.数据存取是通过SQL（Structured Query Language结构化查询语言）
+ 4.最大特点数据安全性方面强（ACID）

 

_非关系型数据库（NoSQL：Not only SQL）的特点：_

+ 1.不是否定关系型数据库，而是做关系型数据库的补充。
+ 2.想做老大，先学会做老二。

 

---

+ _**时代特点对比:**_

 

+ 1. web1.0时代
-   1.1 企业提供内容，用户浏览，所以关系型数据库够用，并发并不高，所以不需要nosql。

 

+ 2. web2.0时代
-   2.1 核心是企业提供平台，用户参与提供内容，这个时代关系型数据库无法满足需求了。

 

+ 3. 2003NoSQL出现
-   3.1 memcache的诞生，关注的点是性能，但是针对安全性能关注比较低，随着安全性能需求不断提升，所以有了redis。

 

+ 4. redis的特点
-   4.1 依然高性能高并发
-   4.2 数据持久化功能
-   4.3 支持多数据类型，主从复制和集群
-   4.4 管理不再使用SQL了

 

---

_**NoSQL特性总览**_

 

+ 1. 不是否定关系型数据库，而是做关系型数据库的补充，现在也有部分替代的趋势mongodb。
+ 2. 关注高性能，高并发，灵活性，忽略和上述无关的功能。
+ 3. 现在也在提升安全性和使用功能。
+ 4. 典型产品：redis（持久化缓存，）、MongoDB（最接近关系型数据库的NoSQL）、memcached。
+ 5. 管理不适用SQL管理，而是用一些特殊的API或数据接口。

 

_**NoSQL的分类、特点、典型产品**_

+ 1.键值（KV）存储：memcached、redis
+ 2.列存储（column-oriented）：HBASE（新浪、360）Cassandra（200台服务器集群）
+ 3.文档数据库（document-oriented）：MongoDB（最接近关系型数据库的NoSQL）
+ 4.图形存储（Graph）：Neo4j

 

---

+ 数据库排行 【 [_**点击查看排行网站**_](https://db-engines.com/en/ranking) 】

---

 

_**数据库产品介绍**_

 

_Oracle公司产品介绍_

| 大版本 | 经典版本号 |
| :--- | :--- |
| 7 | 7.3.4 |
| 8i（internet） | 8.1.7 |
| 9i | 9.2.0.8 |
| 10g（grid） | 10.2.0.4 |
| 11g | 11.2.0.3、11.2.0.4 |
| 12c（cloud） | None |
| 18c | None |

 

_**Oracle的市场应用**_

+ 1.市场份额第一，趋势递减
+ 2.市场空间传统企业
+ 3.传统企业也在互联网化

 

_**MySQL数据库版本介绍**_

+ - 1.0
+ - 5.1
+ - 5.5
+ - 5.6
+ - 5.7
+ - 8.0

 

_**MySQL的市场应用**_

+ 1.中、大型互联网公司
+ 2.市场空间：互联网领域第一
+ 3.趋势明显
+ 4.同源产品：MariaDB、PerconaDB

 

_**其他公司产品介绍**_

+ 1. 微软：SQLserver
-   1.1 微软和sysbase合作开发的产品，后来自己开发，windows平台
-   1.2 三、四线小公司，传统行业在用
+ 2. IBM：DB2
-   2.1 市场占有量小
-   2.2 目前只有：国有银行（人行，中国银行，工商银行等）、中国移动应用
+ 3. PostgreSQL
+ 4. MongoDB
+ 5. Redis

 

_企业使用数据库情况_

+ 1. 中国银行
+ 2. 中国工商银行
+ 3. 江苏银行
+ 4. 浦发银行
+ 5. 中国光大银行

<!-- OCR_START -->
- TBM
- Microsoft"
- SQLServer
- ORACLE
- DB2
- MySQL
- mongoDB
- 浪潮K-DB
- APACHE
- HBASE
- Informix
- SYBASE
- TERADATA
- redis
- SOFTWARE
<!-- OCR_END -->

_**谁说金融公司不能用MySQL？？？？？？？**_

 

### 04 MySQL发展史
 

+ a. 1979年，报表工具Unireg出现。
+ b. 1985年，以瑞典David Axmark为首，成立了一家公司（AB前身），ISAM引擎出现。
+ c. 1990年，提供SQL支持。
+ d. 1999年-2000年，MySQL AB公司成立，并公布源码，开源化。
+ e. 2000年4月BDB引擎出现，支持事物。
+ f. 2008年1月16日 MySQL被Sun公司收购。
+ g. 2009年4月20日Oracle收购Sun公司，MySQL转入Oracle门下。

 

### 05 MySQL正在推动世界
 

<!-- OCR_START -->
- Google
- Autodesk
- sage
- facebook
- ebay
- SONICWALL
- CheckPoint
- flickr
- You
- SOFTWARETECHNOLOGIESLTD
- WIKIPEDIA
- Tube
- ticketmaster
- Symantec
- .....
- CISCO
- Adobe
- TECNOTREE
- YAHOO!
- BBC
- 格InfoVista
- MMcAfee
- Tennet
- EMC
- OfficeDEPOT
- Telefinica
- Alcatel-Lucent
- TakingCareefBuniners
- SHINSEI BANK
- AVAYA
- INTESA
- at&t
- eClinicalWorks
- technologies
- SANPAOLO
- Web和企业
- OEM和ISV
- TY
- Joyent
- Zimbra
- zendesk
- amazon
- webservices
- LOVEYOUR HELPDES
- Atos
- GoDaddys
- Worldline
<!-- OCR_END -->

### 06 MySQL简介及产品线
 

_**MySQL简介（特点）**_

+ 1. 开源
+ 2. 社区版免费
+ 3. 简单、使用方便、可靠
+ 4. 稳定、安全
+ 5. 社区活跃

 

_**MySQL产品线**_

+ _**产品线1:**_

 

+ 1) 3.26版本 --- 5.2版本
-   a. 正宗后代
-   b. CentOS5、6中默认都是5.1版本
-   c. CentOS7中默认是MariaDB

 

+ 2) 5.5 --- 5.7 --- 8.0版本
-   a. 借鉴社区好的贡献，进一步开发的版本
-   b. 主流版本：5.5 5.6 5.7
-   c. 讲课版本：5.6

 

+ 3) MySQL Cluster 6.0版本 & 更高
-   a. 类似于Oracle RAC（双主），硬件要求高
-   b. 一般各大网站没有人用

 

+ _**产品线2:**_
+ 1) MariaDB
+ 2) PerconaDB 第三方 Xtrabackup PerconaDB

 

### 06 MySQL安装
 

_**MySQL安装方式**_

 

+ 1. rpm、yum安装
- 安装方便、安装速度快，无法定制

 

+ 2. 二进制
- 不需要安装，解压即可使用，不能定制功能

 

+ 3. 编译安装
-   3.1 可定制，安装慢
-   3.2 四个步骤：
        *     3.2.1 解压（tar）
        *     3.2.2 生成（./configure）cmake
        *     3.2.3 编译（make）
        *     3.2.4 安装（make install）
-   3.3  5.5版本之前：tar ./configure make make install
-   3.4  5.5版本之后：cmake gmake

 

+ 4. 先编译，然后定制rpm包，制作yum仓库，然后yum安装
-   4.1 简单，速度快，可定制，比较复杂，制作时间极长

 

+ 5. 企业中选择的安装方式
-   5.1 中小型企业：以上方式都可以，运维偏向编译，dba偏向二进制 运维也偏向二进制
-   5.2 大型企业：可以选择: _**先编译然后定制rpm包，制作yum仓库，然后yum安装**_

 

_**安装MySQL**_

```bash
#cmake
#定制功能：存储引擎、字符集、压缩
#定制安装位置、数据存放位置、文件位置（socket）
#克隆一个模板机（使用CentOS7），克隆完做快照
#IP 10.0.0.10 主机名db02
#下载5.6.36包
[root@db02 ~]# wget -q https://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.36.tar.gz
wget https://mirrors.huaweicloud.com/mysql/Downloads/MySQL-5.6/mysql-5.6.51.tar.gz
#安装epel源
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo

#安装依赖包
yum install -y ncurses-devel libaio-devel openssl openssl-devel perl-Data-Dumper
#安装cmake
yum install -y cmake
#创建用户
useradd mysql -s /sbin/nologin -M
#修改hosts
echo '10.0.0.10 db02' >> /etc/hosts
#解压MySQL源码包
tar zxvf mysql-5.6.51.tar.gz
#进入MySQL目录
cd mysql-5.6.51/
mkdir -p /application/
#生成
#程序存放位置
cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.6.51 \
#数据存放位置
-DMYSQL_DATADIR=/application/mysql-5.6.51/data \
#socket文件存放位置
-DMYSQL_UNIX_ADDR=/application/mysql-5.6.51/tmp/mysql.sock \
#使用utf8字符集
-DDEFAULT_CHARSET=utf8 \
#校验规则
-DDEFAULT_COLLATION=utf8_general_ci \
#使用其他额外的字符集
-DWITH_EXTRA_CHARSETS=all \
#支持的存储引擎
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
#禁用的存储引擎
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
#启用zlib库支持（zib、gzib相关）
-DWITH_ZLIB=bundled \
#启用SSL库支持（安全套接层）
-DWITH_SSL=bundled \
#启用本地数据导入支持
-DENABLED_LOCAL_INFILE=1 \
#编译嵌入式服务器支持
-DWITH_EMBEDDED_SERVER=1 \
# mysql5.6支持了google的c++mock框架了，允许下载，否则会安装报错。
-DENABLE_DOWNLOADS=1 \
#禁用debug（默认为禁用）
-DWITH_DEBUG=0

cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.6.51 -DMYSQL_DATADIR=/application/mysql-5.6.51/data -DMYSQL_UNIX_ADDR=/application/mysql-5.6.51/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=all -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 -DWITH_ZLIB=bundled -DWITH_SSL=bundled -DENABLED_LOCAL_INFILE=1 -DWITH_EMBEDDED_SERVER=1 -DENABLE_DOWNLOADS=1 -DWITH_DEBUG=0

#报错 Wrong option or path for WITH_SSL=bundled
-DWITH_SSL=bundled 改成  -DWITH_SSL=system
# -DSYSCONFDIR=/etc/my.cnf  # 添加这个配置文件目录,后面就不用拷贝配置文件了

#编译
make -j4
#安装
make install
#做软链接
ln -s /application/mysql-5.6.51/ /application/mysql
#拷贝配置文件
cp /application/mysql-5.6.51/support-files/my*.cnf /etc/my.cnf
#拷贝mysql启动脚本
cp /application/mysql-5.6.51/support-files/mysql.server /etc/init.d/mysqld
#进入MySQL初始化脚本目录
cd /application/mysql/scripts/

#初始化MySQL
./mysql_install_db --basedir=/application/mysql --datadir=/application/mysql/data --user=mysql
#报错 FATAL ERROR: please install the following Perl modules before executing ./mysql_install_db: Data::Dumper
# yum install perl-Data-Dumper

# 又报错
--------------------------------------------------------------------
Installing MySQL system tables.../application/mysql/bin/mysqld: /lib64/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /application/mysql/bin/mysqld)
/application/mysql/bin/mysqld: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by /application/mysql/bin/mysqld)
/application/mysql/bin/mysqld: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.20' not found (required by /application/mysql/bin/mysqld)
/application/mysql/bin/mysqld: /lib64/libstdc++.so.6: version `CXXABI_1.3.9' not found (required by /application/mysql/bin/mysqld)
---------------------------------------------------------------------
# 这是把redis6.0编译时候升级的gcc9.3的 libstdc++.so.6.0.28文件拷贝过来用.
mv /lib64/libstdc++.so.6 /tmp
cp /root/gcc-9.3.0/build/x86_64-pc-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6.0.28 /lib64/libstdc++.so.6

#授权
chown -R mysql.mysql /application/mysql-5.6.51/
#给启动脚本授权700
chmod 700 /etc/init.d/mysqld
#systemd管理mysql启动
tee /usr/lib/systemd/system/mysqld.service <<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=https://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/application/mysql/bin/mysqld --defaults-file=/etc/my.cnf
LimitNOFILE = 5000
EOF

#设置开机自启动 C6
chkconfig mysqld on
#设置开机自启动 C7
systemctl daemon-reload
systemctl enable mysqld
#启动MySQL C6
/etc/init.d/mysqld start
#启动MySQL C7
systemctl start mysqld

#创建tmp目录（mysql-5.6.51版本不会自动创建tmp目录）
mkdir /application/mysql-5.6.51/tmp

#添加环境变量
# echo 'PATH=/application/mysql/bin/:$PATH' >>/etc/profile
#个人推荐
echo 'PATH=/application/mysql/bin/:$PATH' >/etc/profile.d/mysql.sh
source /etc/profile.d/mysql.sh

#设置MySQL密码
mysqladmin -uroot password 'root123'
#MySQL登陆
[root@db02 ~]# mysql -uuser -ppassword -Ssocket -hhost

#MySQL基本操作及基本优化
#查看库
mysql> show databases;
#删库
mysql> drop database test;
#使用库
mysql> use mysql
#查看表
mysql> show tables;
#查看当前所在库
mysql> select database();
#查看mysql用户
mysql> select user,host from mysql.user;
mysql> select user,host,password from mysql.user;
#删除用户
mysql> select user,host from mysql.user;
mysql> drop user ''@'db02';
mysql> drop user root@db02;
mysql> drop user root@'::1';
mysql> drop user root@'127.0.0.1';
```

### mysql 二进制安装

二进制版本选择下载截图

[https://downloads.mysql.com/archives/community/](https://downloads.mysql.com/archives/community/)

<!-- OCR_START -->
Please note that these are old versions. New releases will have recent bug fixes and features!
To download the latest release of MySQL Community Server, please visit MySQL Downloads.
Product Version:
5.6.40
Operating System:
Linux - Generic
OS Version:
AlI
Linux-Generic(glibc 2.12)(x86,32-bit), Compressed TAR
Feb 26, 2018
301.6M
Download
Archive
(mysql-5.6.40-linux-glibc2.12-i686.tar.gz)
MD5: 365f8562a47e9 f79e3b2a27cb450d4f5 |Signature
Linux - Generic (glibc 2.12) (x86, 64-bit), Compressed TAR
313.3M
(mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz)
MD5: 10f61 e60f8c42b6635e5c1 f423bce8be  Signature
We suggest that you use the MD5 checksums and GnuPG signatures to verify the integrity of the packages you download.
<!-- OCR_END -->

```bash
MySQL二进制安装：
 # 安装所需要的依赖包
yum -y install cmake bison-devel ncurses-devel libaio-devel gcc gcc-c++ automake autoconf
# 卸载冲突 的mariadb
rpm -qa |grep mariadb  
yum remove mariadb-libs

#1.创建安装目录：
mkdir /application

#2.下载二进制安装包：
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz

#3.解压二进制包：
tar zxvf mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz

#4.移动解压目录
mv mysql-5.6.40-linux-glibc2.12-x86_64 /application/mysql-5.6.40

#5.做MySQL软连接
ln -s /application/mysql-5.6.40/ /application/mysql

#6.创建MySQL用户
useradd mysql -s /sbin/nologin -M
# useradd mysql -r -g mysql -s /sbin/nologin -M
# -r 　建立系统帐号。
# -g<群组> 　指定用户所属的群组。
# -s<shell>　 　指定用户登入后所使用的shell。
# -M 　不要自动建立用户的登入目录。

#7.进入配置文件及启动脚本目录
cd /application/mysql-5.6.40/support-files

#8.拷贝配置文件到/etc/my.cnf
cp my-default.cnf /etc/my.cnf

#9.拷贝启动脚本
cp mysql.server /etc/init.d/mysqld

# 10.初始化MySQL
cd /application/mysql-5.6.40/scripts
./mysql_install_db --user=mysql --basedir=/application/mysql --datadir=/application/mysql/data
#--user 		指定mysql用户
#--basedir 	指定mysql安装目录
#--datadir	 指定mysql数据目录
#授权 
chown -R mysql.mysql /application/mysql-5.6.40

#11.修改MySQL启动脚本及启动程序
sed -i 's#/usr/local#/application#g' /etc/init.d/mysqld /application/mysql/bin/mysqld_safe 

#12.启动MySQL
/etc/init.d/mysqld start
/etc/init.d/mysqld stop
#13.添加环境变量
echo 'export PATH="/application/mysql/bin:$PATH"' > /etc/profile.d/mysql.sh

#14.加载环境变量
source /etc/profile

#15.添加systemd启动
cat > /etc/systemd/system/mysqld.service <<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=https://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/application/mysql/bin/mysqld --defaults-file=/etc/my.cnf
LimitNOFILE = 5000
EOF

cat > /etc/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
[mysql]
socket=/tmp/mysql.sock
prompt=3306 [\\d]>
EOF
#加载配置
systemctl daemon-reload
systemctl start mysqld

#MySQL查看报错：
#tail -100 /application/mysql/data/db01.err

#连接MySQL：
# mysql
#查看库：
#mysql> show databases;

#修改密码
mysqladmin -u root password 'root123'
mysql -u root -proot123

#创建jira数据库并授权相关账号
CREATE DATABASE jiradb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX on jiradb.* TO 'jira'@'localhost' IDENTIFIED BY 'ckh123.com';

GRANT all privileges on  jiradb.* TO 'jira'@'localhost' IDENTIFIED BY 'ckh123.com';
GRANT all privileges on  jiradb.* TO 'jira'@'10.0.0.11' IDENTIFIED BY 'ckh123.com';
GRANT all privileges on  jiradb.* TO 'jira'@'%' IDENTIFIED BY 'ckh123.com';

flush privileges;

```

## 官方文档
mysql 官方英文版本文档

[附件: mysql-refman-5.7-en.a4.pdf](./attachments/附件-mysql-refman-5.7-en.a4/mysql-refman-5.7-en.a4.pdf)

[附件: refman-5.6-en.a4.pdf](./attachments/附件-mysql-refman-5.7-en.a4/refman-5.6-en.a4.pdf)

### 

> 更新: 2024-09-12 12:23:21  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/mf6w50>