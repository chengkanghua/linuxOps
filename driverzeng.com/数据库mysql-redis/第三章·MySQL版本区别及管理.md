# 第三章·MySQL版本区别及管理

## 一.MySQL5.6与MySQL5.7安装的区别
+ 1、cmake的时候加入了boost
+ 2、初始化时 使用mysqld --initialize 替代mysql_install_db，其它参数没有变化：--user= --basedir= --datadir=
+ 3、--initialize会生成一个临时密码
+ 4、还可以用另外一个参数--initialize-insecure

### MySQL5.7编译安装
```bash
# 删除系统自带的mariadb
rpm -qa |grep mariadb
yum remove mariadb-libs -y

# https://www.boost.org/users/download/
# https://archives.boost.io/release/
# wget https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_59_0.tar.gz
# 上面地址已失效,官网没有了1.59版本的下载
# wget https://github.com/boostorg/boost/archive/refs/tags/boost-1.59.0.tar.gz
# tar xf boost_1_59_0.tar.gz -C /usr/local/

#安装编译依赖包
yum install -y gcc gcc-c++ automake autoconf
yum install make cmake bison-devel ncurses-devel libaio-devel

# 查看地址 https://downloads.mysql.com/archives/community/
# wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.20.tar.gz

# 直接下载带boost的版本
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-boost-5.7.20.tar.gz

tar xf mysql-5.7.20.tar.gz
cd mysql-5.7.20/
cp -a boost/boost_1_59_0 /usr/local/
[root@db02 mysql-5.7.20]#
cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.7.20 \
-DMYSQL_DATADIR=/application/mysql-5.7.20/data \
-DMYSQL_UNIX_ADDR=/application/mysql-5.7.20/tmp/mysql.sock \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=/usr/local/boost_1_59_0 \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
-DWITH_ZLIB=bundled \
-DWITH_SSL=bundled \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_EMBEDDED_SERVER=1 \
-DENABLE_DOWNLOADS=1 \
-DWITH_DEBUG=0

make -j2
make install 

# /application 目录会自动创建
#做软链接
ln -s /application/mysql-5.7.20/ /application/mysql
#拷贝配置文件  5.7版本没有这个文件
# cp /application/mysql-5.7.20/support-files/my*.cnf /etc/my.cnf
cat > /etc/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
[mysql]
socket=/tmp/mysql.sock
prompt=3306 [\d]>
EOF

#拷贝mysql启动脚本
cp /application/mysql-5.7.20/support-files/mysql.server /etc/init.d/mysqld
#进入MySQL初始化脚本目录
cd /application/mysql/bin/

# 创建mysql用户
groupadd mysql
useradd mysql -r -g mysql -s /sbin/nologin -M
#初始化MySQL
./mysqld --initialize --basedir=/application/mysql --datadir=/application/mysql/data --user=mysql
#最后一行生成临时密码
# 2024-09-12T03:45:21.008979Z 1 [Note] A temporary password is generated for root@localhost: s0-_>Mhboub9

#授权
chown -R mysql.mysql /application/mysql-5.7.20/
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
#创建tmp目录（mysql-5.7.20版本不会自动创建tmp目录）
mkdir /application/mysql-5.7.20/tmp
chown -R mysql.mysql /application/mysql-5.7.20/tmp
#启动MySQL C6
/etc/init.d/mysqld start
/etc/init.d/mysqld stop

#设置开机自启动 C7
systemctl daemon-reload
systemctl enable mysqld
#启动MySQL C7
systemctl start mysqld

#添加环境变量
# echo 'PATH=/application/mysql/bin/:$PATH' >>/etc/profile
#个人推荐
echo 'PATH=/application/mysql/bin/:$PATH' >/etc/profile.d/mysql.sh
source /etc/profile.d/mysql.sh

#登录 密码是上面初始化提示的密码
msyql -uroot -p's0-_>Mhboub9'

# 登录后修改密码  修改可远程登录
set password for root@localhost = password('root');
use mysql;
update user set user.Host='%' where user.User='root';
flush privileges;
quit

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
mysql> select user,host from user;
mysql> drop user ''@'db02';
mysql> drop user root@db02;
mysql> drop user root@'::1';
mysql> drop user root@'127.0.0.1';
```

### Mysql5.7 二进制安装
```bash
# 删除系统自带的mysql
rpm -qa|grep mysql
whereis mysql
find / -name mysql  #自带的目录全部删除掉
rpm -qa |grep mariadb
yum remove mariadb-libs -y

 # 安装所需要的依赖包
# yum -y install cmake bison-devel ncurses-devel libaio-devel gcc gcc-c++ automake autoconf

#1.创建安装目录：
mkdir /application

#2.下载二进制安装包：
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz

#3.解压二进制包：
tar zxvf mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz

#4.移动解压目录
mv mysql-5.7.20-linux-glibc2.12-x86_64 /application/mysql-5.7.20

#5.做MySQL软连接
ln -s /application/mysql-5.7.20/ /application/mysql

#6.创建MySQL用户
groupadd mysql
useradd mysql -r -g mysql -s /sbin/nologin -M
# -r 　建立系统帐号。
# -g<群组> 　指定用户所属的群组。
# -s<shell>　 　指定用户登入后所使用的shell。
# -M 　不要自动建立用户的登入目录。

#8.配置文件/etc/my.cnf
cat > /etc/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
[mysql]
socket=/tmp/mysql.sock
prompt=3306 [\d]>
EOF

#9.启动脚本软链接
ln -s /application/mysql-5.7.20/support-files/mysql.server /etc/init.d/mysqld
#11.修改MySQL启动脚本及启动程序
sed -i 's#/usr/local#/application#g' /application/mysql-5.7.20/support-files/mysql.server /application/mysql/bin/mysqld_safe 

# 10.初始化MySQL
cd /application/mysql-5.7.20/bin
./mysqld --initialize --user=mysql --basedir=/application/mysql --datadir=/application/mysql/data
#--user 		指定mysql用户
#--basedir 	指定mysql安装目录
#--datadir	 指定mysql数据目录

#2024-09-12T11:29:42.152626Z 1 [Note] A temporary password is generated for root@localhost: UMheu<jLM3jC
#记录临时登录密码

#授权 
chown -R mysql.mysql /application/mysql-5.7.20/

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

#加载配置
systemctl daemon-reload
systemctl start mysqld
systemctl stop mysqld

#MySQL查看报错：
#tail -100 /application/mysql/data/db01.err

#使用初始化的密码登录
mysql -u root -p'UMheu<jLM3jC'

# 登录后修改密码  修改可远程登录
set password for root@localhost = password('root');
use mysql;
update user set user.Host='%' where user.User='root';
flush privileges;
quit

```

### mysql5.7 官方 yum 源安装
```bash
wget https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
rpm -ivh mysql57-community-release-el7-8.noarch.rpm
rpm -qa |grep mariadb
yum remove mariadb-libs -y
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install mysql-server -y

systemctl start mysqld
systemctl status mysqld
systemctl enable mysqld
ps -ef | grep mysql
rpm -qa |grep -i mysql

#取出临时密码赋值给pass变量
pass=`grep 'A temporary password' /var/log/mysqld.log |awk '{print $NF}'`

mysql -uroot -p$pass
#下面是MySQL登录交互式操作
set global validate_password_policy=LOW;  -- 设置低密码策略;
set global validate_password_length=6;    -- 密码长度6位;
ALTER USER USER() IDENTIFIED BY '123456';
show variables like '%char%';
GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; -- 远程登录;
FLUSH PRIVILEGES;
quit

# 字符编码配置
tee -a /etc/my.cnf <<EOF
[client]
# 设置字符编码
default-character-set=utf8
[mysqld]
character-set-server=utf8
collation-server=utf8_general_ci
EOF

systemctl restart mysqld

```

## 二.MySQL用户权限管理
### 1.MySQL用户基础操作
_**Linux用户的作用:**_

+ 1）登陆系统
+ 2）管理系统文件

_**Linux用户管理：**_

+ 1）创建用户：useradd adduser
+ 2）删除用户：userdel
+ 3）修改用户：usermod

_**MySQL用户的作用:**_

+ 1）登陆MySQL数据库
+ 2）管理数据库对象

_**MySQL用户管理：**_

+ 1）创建用户：create user
+ 2）删除用户：delete user | drop user
+ 3）修改用户：update

```bash
#创建用户并设置密码
create user '[新用户名]'@'[作用域]' identified by '[密码]';
flush privileges;　　-- 创建完要记得刷新权限表;

# 授权加创建用户
grant [权限] on [数据库名].[表名] to '[用户名]'@'[作用域]' identified by '[密码]';
flush privileges;　　-- 记得刷新权限表;

# 删除用户 二选一
drop user '[用户名]'@'[作用域]';　　
delete from mysql.user where user='[用户名]' and host='[作用域];  
flush privileges;　　-- 刷新权限表;

# 修改用户密码
# mysql  # 配置文件添加 跳过授权表skip-grant-tables　　//添加 之后直接mysql无密码登录

mysql> update user set authentication_string=password('123') where user='root';
mysql> flush privileges;　　
```

_**用户的定义：**_

+ 1) username@’主机域’
+ 2）主机域：可以理解为是MySQL登陆的白名单
+ 3）主机域格式：
- ’10.0.0.51’
- ’10.0.0.5%’
- ’10.0.0.%’
- ’10.0.%.%’
- ’10.%.%.%’
- ‘%’
- ‘db01’
- ’10.0.0.51/255.255.255.0’

_**用户管理实战**_

_刚装完MySQL数据库该做的事情_

+ 1、设定初始密码（root@localhost）

```bash
[root@db02 mysql-5.7.20]# mysqladmin -uroot -p password ‘oldboy123’

```

+ 2、修改密码
+ 3、使用密码登陆

```bash
[root@db02 mysql-5.7.20]# mysql -uroot -p123
```

+ 4、清理无用的用户

_**误删除了所有用户**_

```bash
# -- 误删除实验
select user,host from mysql.user;
drop user root@"%";
drop user root@"localhost";
drop user root@'127.0.0.1';
quit

#关闭数据库
[root@db02 mysql-5.7.20]# /etc/init.d/mysqld stop
#或
systemctl stop mysqld
#启动数据库
[root@db02 mysql-5.7.20]# mysqld_safe --skip-grant-tables --skip-networking &  #如果没加&符号前台运行,ctrl+z;bg
#或
vi /etc/my.cnf
[mysqld] 后面添加
skip-grant-tables
skip-networking

mysql #直接登录
#使用mysql库
mysql> use mysql
#错误方法1、创建root用户
# create user root@’localhost’;
#错误方法2、创建root用户
#  insert into user(user,host,password) values('root','10.0.0.55',PASSWORD('123'));
#正确方法创建root用户- mysql-5.6
mysql> insert into mysql.user values ('localhost','root',PASSWORD('123'),
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'Y',
'',
'',
'',
'',0,0,0,0,'mysql_native_password','','N');

3306 [(none)]>quit
pkill mysql

systemctl start mysqld
[root@db03 ~]# mysql -uroot -p
3306 [(none)]>show grants for 'root'@'localhost';

--------------------------mysql-5.7 推荐下面方法 5.6使用也可以, 效果和上面insert语句一样.
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '123' WITH GRANT OPTION;
flush privileges;

select * from mysql.user where user='root'\G;

```

_**忘记root密码**_

```bash
#关闭数据库
[root@db02 mysql-5.7.20]# /etc/init.d/mysqld stop
#启动数据库
[root@db02 mysql-5.7.20]# mysqld_safe --skip-grant-tables --skip-networking
#修改root用户密码
mysql> update user set password=PASSWORD('oldboy123') where user='root' and host='localhost';

-------------------------- 跳过授权表 跳过网络的配置文件启动方式
[root@db03 bin]# cat /etc/my.cnf
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
skip-grant-tables
skip-networking
[mysql]
socket=/tmp/mysql.sock
prompt=3306 [\\d]>

# /application/mysql/bin/mysqld_safe --defaults-file=/etc/my.cnf

```

### 2.用户管理及权限管理_
1）创建用户

```bash
mysql> create user oldboy@'10.0.0.%' identified by '123';
```

2）查看用户

```bash
mysql>  select user,host from mysql.user;
```

3）删除用户

```bash
mysql>  drop user oldboy@‘10.0.0.%’；
```

4）修改密码

```bash
# set password 命令修改密码
SET PASSWORD FOR 'username'@'host' = PASSWORD('new_password');
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root123');

# 推荐alter命令修改用户密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123';
alter user 'root'@'%' identified by 'root123';

# mysql-5.6  
update mysql.user set password=PASSWORD('oldboy123') where user='root' and host='localhost';
# mysq-5.7 版本修改用户密码
update mysql.user set authentication_string=PASSWORD('oldboy123') where user='root' and host='localhost';

# 授权命令,用户不存在会创建
grant all privileges on *.* to oldboy@’10.0.0.%’ identified by ‘123’;

#最后都要刷新授权表
flush privileges;

```

5）用户权限介绍

MySQL的权限定义：

_**作用对象：库、表**_

_**权限**_

```bash
INSERT,SELECT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN,  PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE
#=============================================
#           MySQL 权限完整列表（必背）
#=============================================

#=========================
# 一、全局权限 ( *.* )
#=========================
ALL PRIVILEGES        # 所有权限（万能）
CREATE                # 创建库/表
DROP                  # 删除库/表
DELETE                # 删除数据
INSERT                # 插入数据
UPDATE                # 更新数据
SELECT                # 查询数据
ALTER                 # 修改表结构
INDEX                 # 创建/删除索引
RELOAD                # 刷新权限
SHUTDOWN              # 关闭MySQL
PROCESS               # 查看进程
FILE                  # 读写文件
GRANT OPTION          # 授权他人
SUPER                 # 超级权限（杀线程、改配置）
REPLICATION SLAVE     # 从库复制权限
REPLICATION CLIENT    # 查看主从状态
CREATE USER           # 创建用户
SHOW DATABASES        # 查看所有库

#=========================
# 二、数据库级别权限 ( db.* )
#=========================
CREATE                # 在该库下创建表
DROP                  # 删除该库/表
DELETE                # 库内删数据
INSERT                # 库内插数据
SELECT                # 库内查询
UPDATE                # 库内更新
ALTER                 # 库内改表
INDEX                 # 库内索引
CREATE ROUTINE        # 创建存储过程
ALTER ROUTINE         # 修改存储过程
EXECUTE               # 执行存储过程
LOCK TABLES           # 锁表

#=========================
# 三、表级别权限 ( db.tb )
#=========================
SELECT                # 查询表
INSERT                # 插入表
DELETE                # 删除表
UPDATE                # 更新表
ALTER                 # 修改表
INDEX                 # 索引
CREATE                # 创建表
DROP                  # 删除表
TRIGGER               # 触发器

#=========================
# 四、列级别权限（最细）
#=========================
SELECT (col1,col2)    # 只查某些列
INSERT (col1,col2)    # 只插某些列
UPDATE (col1,col2)    # 只改某些列

#=========================
# 五、管理类权限（DBA专用）
#=========================
CREATE USER           # 用户管理
SHOW DATABASES        # 查看所有库
SUPER                 # 核心管理
PROCESS               # 查看连接
RELOAD                # flush privileges
GRANT OPTION          # 可转授权限

#=========================
# 六、最常用 3 套权限（工作直接用）
#=========================

# 1. 只读账号（最常用）
GRANT SELECT ON *.* TO 'user'@'%';

# 2. 普通读写账号（开发）
GRANT SELECT,INSERT,UPDATE,DELETE ON db.* TO 'user'@'%';

# 3. DBA超级管理员
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
```

_**归属**_

每次设定只能有一个属主，没有属组或其他用户的概念

```bash
grant     all privileges    on     *.*    to   oldboy@’10.0.0.%’  identified by    ‘123’;
                权限               作用对象          归属               密码
                
```

_**作用对象分解**_

*.* [当前MySQL实例中所有库下的所有表]

wordpress.* [当前MySQL实例中wordpress库中所有表（单库级别）]

wordpress.user [当前MySQL实例中wordpress库中的user表（单表级别）]

### 3.企业中权限的设定
开发人员说：请给我开一个用户

沟通：

+ 1、你需要对哪些库、表进行操作
+ 2、你从哪里连接过来
+ 3、用户名有没有要求
+ 4、密码要求
+ 5、发邮件

```bash
#一般给开发创建用户权限
grant select,update,delete,insert on *.* to oldboy@’10.0.0.%’ identified by ‘123’;

```

---

思考下面场景：

开发：你把root用户给我呗？

你：emmmmm........ SO?

---

_**实验思考问题：**_

```bash
#创建wordpress数据库
create database wordpress;
#使用wordpress库
use wordpress;
#创建t1、t2表
create table t1 (id int);
create table t2 (id int);
#创建blog库
create database blog;
#使用blog库
use blog;
#创建t1表
create table tb1 (id int);
```

_授权：_

```bash
1、grant select on *.* to wordpress@’10.0.0.5%’ identified by ‘123’;
2、grant insert,delete,update on wordpress.* to wordpress@’10.0.0.5%’ identified by ‘123’;
3、grant all on wordpress.t1 to wordpress@’10.0.0.5%’ identified by ‘123’;

# 限定mysql数据库表user, host字段可以查,其他不可查
# grant select(host) on mysql.user to xudao_5@'localhost' identified by '123';
# grant select(user,host) on mysql.user to xudao_5@'localhost' identified by '123';
```

_问：_

一个客户端程序使用wordpress用户登陆到10.0.0.51的MySQL后，

+ 1、对t1表的管理能力？
+ 2、对t2表的管理能力？
+ 3、对tb1表的管理能力？

_解：_

+ 1、同时满足1，2，3，最终权限是1+2+3
+ 2、同时满足了1和2两个授权，最终权限是1+2
+ 3、只满足1授权，所以只能select

_结论：_

+ 1、如果在不同级别都包含某个表的管理能力时，权限是相加关系。
+ 2、但是我们不推荐在多级别定义重复权限。
+ 3、最常用的权限设定方式是单库级别授权，即：wordpress.*

## 三.MySQL连接管理
### 1.连接工具
+ 1)MySQL自带的连接工具

mysql

常见的特定于客户机的连接选项：

-u：指定用户

-p：指定密码

-h：指定主机

-P：指定端口

-S：指定sock

-e：指定SQL

--protocol=name：指定连接方式

+ 2)第三方的连接工具

sqlyog、navicat

应用程序连接MySQL

注意：需要加载对应语言程序的API

### 2.连接方式
+ 1) socket连接

```bash
mysql -uroot -poldboy123 -S/application/mysql/tmp/mysql.sock
mysql -uroot -poldboy123
```

+ 2) TCP/IP

```bash
mysql -uroot -poldboy123 -h10.0.0.51 -P3306
```

+ _**问题：你怎么判断你的MySQL数据库可以对外提供服务？**_

## 四.MySQL启动关闭流程

<!-- OCR_START -->
- nysql.server
- mysqld safe
- mysqld
- 启动
- service mysqld start
- /bin/mysqld_safe
<!-- OCR_END -->

_**启动**_

```bash
/etc/init.d/mysqld start ------> mysqld_safe ------> mysqld
```

_**关闭**_

```bash
/etc/init.d/mysqld stop 
mysqladmin -uroot -poldboy123 shutdown
kill -9 pid ?
killall mysqld ?
pkill mysqld ?
```

_**出现问题：**_

- 1、如果在业务繁忙的情况下，数据库不会释放pid和sock文件

- 2、号称可以达到和Oracle一样的安全性，但是并不能100%达到

- 3、在业务繁忙的情况下，丢数据（补救措施，高可用）

可通过如下地址查看，生产高并发环境野蛮粗鲁杀死数据库进程导致故障企业案例：

[625某电商网站数据库宕机故障解决实录（上）](https://blog.51cto.com/oldboy/1431161)

[625某电商网站数据库宕机故障解决实录（下）](https://blog.51cto.com/oldboy/1431172)

```bash
---------------------------------------------------------------------
#==================================================
#              MySQL 启动 → 运行 → 关闭 全流程
#==================================================

#=========================
# 一、MySQL 启动流程（重点）
#=========================
1. 读取配置文件
   - my.cnf / my.ini
   - 加载端口、数据目录、内存、字符集等

2. 初始化核心内存结构
   - 缓冲池 (Buffer Pool)
   - 日志缓冲、表缓存等

3. 启动后台线程
   - 主线程、IO线程、Purge清理线程、锁线程

4. 打开物理文件
   - ibdata1、ib_logfile、redo log、binlog
   - 加载表空间文件 .ibd

5. 恢复阶段（崩溃恢复）
   - 应用 redo log 前滚
   - 回滚未提交事务 undo log

6. 启动监听
   - 打开 3306 端口
   - 生成 /tmp/mysql.sock
   - 开始接收客户端连接

7. 启动完成
   - 可以登录 mysql
   - 提供读写服务

#=========================
# 二、MySQL 关闭流程（重点）
#=========================
1. 停止接收新连接
   - 关闭 3306 端口
   - 关闭 socket 文件

2. 等待活跃事务执行完毕
   - 不允许新事务
   - 等待运行中 SQL 结束

3. 刷新脏页到磁盘
   - 将 Buffer Pool 里的修改数据写入 .ibd

4. 关闭所有存储引擎
   - InnoDB 做 checkpoint
   - 确保数据完全落盘

5. 关闭线程、释放内存
   - 退出所有后台线程
   - 释放缓冲池

6. 退出进程 mysqld
   - 删除 pid 文件
   - 完全关闭

#=========================
# 三、常用启动/关闭命令
#=========================

# 1. 启动
systemctl start mysqld
service mysqld start
/etc/init.d/mysqld start

# 2. 关闭（推荐安全关闭）
systemctl stop mysqld
service mysqld stop
/etc/init.d/mysqld stop

# 3. 重启
systemctl restart mysqld

# 4. 强制关闭（不推荐，可能丢数据）
pkill mysqld
kill -9 进程号

#=========================
# 四、启动关闭 3 个关键点（面试必考）
#=========================
1. 启动必须做：崩溃恢复（redo + undo）
2. 关闭必须做：刷脏页、做 checkpoint
3. kill -9 会丢数据，绝对不能乱用！

#=========================
# 五、一句话总结流程
#=========================
启动：读配置 → 开内存 → 启线程 → 开文件 → 崩溃恢复 → 监听端口
关闭：停连接 → 等事务 → 刷数据 → 关引擎 → 退进程
```

## 五.MySQL实例初始化配置
_**1.初始化配置文件的作用**_

场景：我要启动实例

问题：

1）我不知道我的程序在哪？

2）我也不知道我将来启动后去哪找数据库？

3）将来我启动的时候启动信息和错误信息放在哪？

4）我启动的时候sock文件pid文件放在哪？

5）我启动，你们给了我多少内存？

...

N）我还有很多问题需要在我启动之前告诉我，emmmmm....

<!-- OCR_START -->
- 预编译的选项
- 启动配置
- 命令行选项
- 初始化配置文件
<!-- OCR_END -->

+ 1）预编译：cmake去指定，硬编码到程序当中去
+ 2）在命令行设定启动初始化配置

```bash
--skip-grant-tables 
--skip-networking
--datadir=/application/mysql/data
--basedir=/application/mysql
--defaults-file=/etc/my,cnf
--pid-file=/application/mysql/data/db01.pid
--socket=/application/mysql/data/mysql.sock
--user=mysql
--port=3306
--log-error=/application/mysql/data/db01.err

```

+ 3）初始化配置文件（/etc/my.cnf）

配置文件读取顺序：

/etc/my.cnf

/etc/mysql/my.cnf

$MYSQL_HOME/my.cnf（前提是在环境变量中定义了MYSQL_HOME变量）

defaults-extra-file （类似include）

~/my.cnf

<!-- OCR_START -->
/etc/my.cnf
/etc/mysql/my.cnf
$MYSQLHOME/my.cnf
defaults-extra-file
/.my.cnf
<!-- OCR_END -->

---

--defaults-file：默认配置文件

_**如果使用./bin/mysqld_safe 守护进程启动mysql数据库时，使用了 --defaults-file=<配置文件的绝对路径>参数，这时只会使用这个参数指定的配置文件。**_

---

_**思考：**_

```bash
#cmake：
socket=/application/mysql/tmp/mysql.sock
#命令行：
--socket=/tmp/mysql.sock
#配置文件：
/etc/my.cnf中 [mysqld]标签下：socket=/opt/mysql.sock
#default参数：
--defaults-file=/tmp/a.txt   配置文件中 [mysqld]标签下：socket=/tmp/test.sock
```

_**socket文件会生成在哪？？？文件名叫什么？？？**_

<!-- OCR_START -->
- 老子早料到
- 你会这么说
<!-- OCR_END -->

_**优先级结论：**_

+ 1、命令行
+ 2、defaults-file
+ 3、配置文件
+ 4、预编译

_**2.初始化配置文件的使用**_

_初始化配置文件功能_

1）影响实例的启动（mysqld）

2）影响到客户端

+ mysql
+ mysqldump
+ mysqladmin

_如何配置初始化配置文件_

1）配置标签分类

[client]所有客户端程序

mysql

mysqldump

...

[server]所有服务器程序

mysqld

mysqld_safe

...

## 六.MySQL多实例配置
+ 1.什么是多实例

1）多套后台进程+线程+内存结构

2）多个配置文件

a.多个端口

b.多个socket文件

c.多个日志文件

d.多个server_id

3）多套数据

+ 2.多实例实战

```bash
# 多实例

#创建数据目录
mkdir -p /data/330{7..9}
#创建配置文件
touch /data/330{7..9}/my.cnf
#编辑3307配置文件
cat > /data/3307/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/data/3307/data
socket=/data/3307/mysql.sock
log_error=/data/3307/mysql.log
log-bin=/data/3307/mysql-bin
server_id=7
port=3307
[client]
socket=/data/3307/mysql.sock
EOF
#编辑3308配置文件
cat > /data/3308/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/data/3308/data
socket=/data/3308/mysql.sock
log_error=/data/3308/mysql.log
log-bin=/data/3308/mysql-bin
server_id=8
port=3308
[client]
socket=/data/3308/mysql.sock
EOF
#编辑3309配置文件
cat > /data/3309/my.cnf <<EOF
[mysqld]
basedir=/application/mysql
datadir=/data/3309/data
socket=/data/3309/mysql.sock
log_error=/data/3309/mysql.log
log-bin=/data/3309/mysql-bin
server_id=9
port=3309
[client]
socket=/data/3309/mysql.sock
EOF

mkdir -p /data/330{7..9}/data
chown -R mysql:mysql /data
---------------------------------------------msyql 5.6版本初始化
#初始化3307数据
/application/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/data/3307/my.cnf --basedir=/application/mysql --datadir=/data/3307/data
#初始化3308数据
/application/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/data/3308/my.cnf --basedir=/application/mysql --datadir=/data/3308/data
#初始化3309数据
/application/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/data/3309/my.cnf --basedir=/application/mysql --datadir=/data/3309/data

------------------------------------------------msyql 5.7 版本初始化
/application/mysql/bin/mysqld --initialize --user=mysql --basedir=/application/mysql --datadir=/data/3307/data
# root@localhost: tovM4anvvj!%

/application/mysql/bin/mysqld --initialize --user=mysql --basedir=/application/mysql --datadir=/data/3308/data
# root@localhost: daFi.BVrm06!

/application/mysql/bin/mysqld --initialize --user=mysql --basedir=/application/mysql --datadir=/data/3309/data
# root@localhost: LuU1;Pu,-1id

-----------------------------------------------------------------------------------------
#修改目录权限
chown -R mysql.mysql /data/330*

# systemd 管理多套实例
cp /etc/systemd/system/mysqld.service /etc/systemd/system/mysqld3307.service
cp /etc/systemd/system/mysqld.service /etc/systemd/system/mysqld3308.service
cp /etc/systemd/system/mysqld.service /etc/systemd/system/mysqld3309.service

sed -i s#--defaults-file=/etc/my.cnf#--defaults-file=/data/3307/my.cnf#g /etc/systemd/system/mysqld3307.service
sed -i s#--defaults-file=/etc/my.cnf#--defaults-file=/data/3308/my.cnf#g /etc/systemd/system/mysqld3308.service
sed -i s#--defaults-file=/etc/my.cnf#--defaults-file=/data/3309/my.cnf#g /etc/systemd/system/mysqld3309.service

systemctl daemon-reload
systemctl start mysqld3307.service
systemctl start mysqld3308.service
systemctl start mysqld3309.service

#验证多实例
netstat -lnp|grep 330
# mysql-5.6版本默认没密码可以着看操作
mysql -S /data/3307/mysql.sock -e "select @@server_id"
mysql -S /data/3308/mysql.sock -e "select @@server_id"
mysql -S /data/3309/mysql.sock -e "select @@server_id"

-------------------------------------------
# mysql-5.7使用初始化的密码登录 再修改密码
mysql -S /data/3307/mysql.sock -uroot -p'tovM4anvvj!%'
alter user 'root'@'localhost' identified by 'root123'; -- 修改密码sql语句 ;

mysql -S /data/3308/mysql.sock -uroot -p'daFi.BVrm06!'

mysql -S /data/3309/mysql.sock -uroot -p'LuU1;Pu,-1id'

# 最后查看  server_id
mysql -uroot -proot123 -S /data/3307/mysql.sock -e "select @@server_id"
mysql -uroot -proot123 -S /data/3308/mysql.sock -e "select @@server_id"
mysql -uroot -proot123 -S /data/3309/mysql.sock -e "select @@server_id"
```

> 更新: 2026-08-26 13:57:54  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/mrgwbp>