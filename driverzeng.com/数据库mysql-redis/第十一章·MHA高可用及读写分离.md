# 第十一章· MHA高可用及读写分离

## 一.MHA简介

MHA（**Master High Availability**）是**开源 MySQL 高可用集群方案**，专门解决**一主多从架构下主库单点故障**问题。

* 底层依赖：MySQL 原生主从复制（传统位点 / GTID 均支持，生产推荐 GTID）
* 核心能力：**自动监控主库、主库宕机后自动选新主、自动修复从库复制关系**，最大程度保证数据不丢失。
* 主流版本：`MHA 0.58 / 0.59`，支持 MySQL 5.5 ~ 8.0。

### 1.2 MHA 两大角色（必记）

MHA 分为 **Manager（管理节点）** 和 **Node（数据节点）**，所有 MySQL 实例都必须安装 Node。

表格

| **角色** | **部署位置** | **核心作用** |
| :--- | :--- | :--- |
| **MHA Manager** | 独立服务器（建议不和 MySQL 混部） | 全局监控集群、检测主库宕机、发起故障切换、执行切换脚本 |
| **MHA Node** | 所有主库、从库节点（每台 MySQL 都装） | 解析 binlog/relay-log、比对日志位点、补全差异日志、协助切换 |

关键前置条件（部署必满足）：

1. 集群所有节点 **SSH 免密互通**（Manager ↔ Node、Node ↔ Node）；
2. 主从复制状态正常（`Slave_IO_Running=Yes`、`Slave_SQL_Running=Yes`）；
3. 集群内 `server_id` 全局唯一；
4. 建议开启 **GTID + 半同步复制**，降低切换后数据丢失风险。

##  二. MHA 架构拓扑（标准一主多从）

```plain
┌─────────────┐
                │ MHA Manager │  （独立监控节点）
                └──────┬──────┘
                       │ 监控所有节点状态
         ┌─────────────┼─────────────┐
         │             │             │
    ┌────▼────┐    ┌───▼───┐    ┌───▼───┐
    │ Master  │    │ Slave1 │    │ Slave2 │
    │(主库)   │    │(从库)  │    │(从库)  │
    │Node已装 │    │Node已装│    │Node已装│
    └────┬────┘    └───────┘    └───────┘
         │ 主从复制（binlog/GTID）
         └───────────┬───────────────┘

        c/s 结构     
mha manager 可以管理多套 mysql 集群
```

## 三. MHA 核心故障切换流程（面试高频，逐阶段拆解）

当**主库完全宕机、网络不通**时，MHA 自动执行 6 步切换（`auto_failover=1` 开启自动切换）：

### 阶段 1：故障检测

MHA Manager 定时 `ping` 主库，连续多次探测失败，判定**主库不可用**。

### 阶段 2：筛选候选新主

MHA 遍历所有从库，**优先选择「数据最新、延迟最小」的从库**（比对 `relay-log` 位点），避免选延迟过大的从库导致数据丢失。

### 阶段 3：日志补全（MHA 核心亮点）

1. 尝试连接宕机主库，拉取**未同步到从库的剩余 binlog**；
2. 将差异日志应用到候选新主，保证新主数据和原主尽可能一致。

### 阶段 4：提升新主

将选中的从库，**提升为新 Master**。

### 阶段 5：重构复制关系

所有剩余从库，自动修改 `CHANGE MASTER TO`，指向**新主库**（GTID 模式无需手动指定 binlog+pos，切换更稳）。

### 阶段 6：业务切换

搭配 `Keepalived VIP`（虚拟 IP），将 VIP 漂移到新主库；应用无需修改 IP，继续正常读写。

补充：如果只是主库 MySQL 进程挂了、服务器正常，MHA 会**尝试原地重启 MySQL**，而非直接切换。

<!-- OCR_START -->
| master上的数据量 | master上的数据量 | master上的数据量 | master上的数据量 | 排名 |
| --- | --- | --- | --- | --- |
| slave02上的数据量 | 从库 | 1.保存master上所有binlog事件 | relay | 2.对比所有从库上的relay-log，找到数据位置点最新的slave |
| 3.通过含有最新数据的slave上的relay-log将数据恢复到其他从库上 | 4.将含有最新数据的slave提升为新主。 | 5.将所有保存下来的binlog数据恢复到新主上 | 6.将所有从库指向新的主库开启主从复制 | 60 |
| 80 | 80 | 100 | 100 | 100 |
<!-- OCR_END -->

```bash

# 切换模式
自动故障切换：auto_failover=1（生产开启），主宕机自动切换；
手动切换：运维主动主从切换（版本升级、硬件维护），分「在线切换（不中断业务）」「离线切换」。

# 常用检查 / 运维命令
# 1. 检查集群所有节点SSH免密是否正常
masterha_check_ssh --conf=/etc/mha/app1.cnf

# 2. 检查主从复制状态是否正常
masterha_check_repl --conf=/etc/mha/app1.cnf

# 3. 启动MHA Manager监控（常驻后台）
nohup masterha_manager --conf=/etc/mha/app1.cnf &

# 4. 查看集群当前状态
masterha_status --conf=/etc/mha/app1.cnf

# 5. 手动在线主从切换（运维维护用）
masterha_master_switch --conf=/etc/mha/app1.cnf --master_state=alive --interactive=0

```

**MHA优点总结**

* **兼容性好**：全系列 MySQL 版本都支持，传统位点、GTID 两种复制模式均可适配，老旧集群也能平滑接入；
* **数据安全性高**：主库宕机后会尝试拉取原主残留 binlog 补全差异，配合半同步复制，大幅降低数据丢失概率；
* **轻量化易运维**：架构简单，仅 Manager 和 Node 两个组件，资源占用低、配置简单，学习和排障门槛低；
* **灵活可控**：支持**自动故障切换**应对突发宕机，也支持**手动在线切换**用于版本升级、硬件维护等计划性操作；
* **无架构侵入**：基于原生主从复制实现，不用修改 MySQL 内核和业务代码，原有集群逻辑完全保留。 

## 四.MHA工具介绍

MHA软件由两部分组成，Manager工具包和Node工具包，具体的说明如下：

Manager工具包主要包括以下几个工具：

```bash
下载地址
https://github.com/yoshinorim/mha4mysql-manager/releases/tag/v0.58
https://github.com/yoshinorim/mha4mysql-node/releases

wget https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
wget https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node-0.58-0.el7.centos.noarch.rpm

masterha_check_ssh              #检查MHA的ssh-key
masterha_check_repl             #检查主从复制情况
masterha_manger                 #启动MHA
masterha_check_status           #检测MHA的运行状态
masterha_master_monitor         #检测master是否宕机
masterha_master_switch          #手动故障转移
masterha_conf_host              #手动添加server信息
masterha_secondary_check        #建立TCP连接从远程服务器
masterha_stop                   #停止MHA

```

Node工具包主要包括以下几个工具：

```bash
save_binary_logs                #保存宕机的master的binlog
apply_diff_relay_logs           #识别relay log的差异; 对比从库的relay-log
filter_mysqlbinlog              #防止回滚事件
purge_relay_logs                #清除中继日志relay-log

```

**MySQL环境准备**

1）环境检查

*mysql-db01*

```bash
#系统版本
[root@mysql-db01 ~]# cat /etc/redhat-release 
CentOS release 6.7 (Final)
#内核版本
[root@mysql-db01 ~]# uname -r
2.6.32-573.el6.x86_64
#IP地址
[root@mysql-db01 ~]# hostname -I
10.0.0.51
```

*mysql-db02*

```bash
#系统版本
[root@mysql-db02 ~]# cat /etc/redhat-release
CentOS release 6.7 (Final)
#内核版本
[root@mysql-db02 ~]# uname -r
2.6.32-573.el6.x86_64
#IP地址
[root@mysql-db02 ~]# hostname -I
10.0.0.52
```

*mysql-db03*

```bash
#系统版本
[root@mysql-db03 ~]# cat /etc/redhat-release 
CentOS release 6.7 (Final)
#内核版本
[root@mysql-db03 ~]# uname -r
2.6.32-573.el6.x86_64
#IP地址
[root@mysql-db03 ~]# hostname -I
10.0.0.53
```

**安装MySQL**

1）安装包准备

```bash
#创建安装包存放目录
[root@mysql-db01 ~]# mkdir /home/oldboy/tools -p
#进入目录
[root@mysql-db01 ~]# cd /home/oldboy/tools/
#上传mysql安装包（mysql-5.6.16-linux-glibc2.5-x86_64.tar.gz）
[root@mysql-db01 tools]# rz -be
```

2）安装

```bash
#创建安装目录
[root@mysql-db01 tools]# mkdir /application
#解压mysql二进制包
[root@mysql-db01 tools]# tar xf mysql-5.6.16-linux-glibc2.5-x86_64.tar.gz
#移动安装包
[root@mysql-db01 tools]# mv mysql-5.6.16-linux-glibc2.5-x86_64 /application/mysql-5.6.16
#做软链接
[root@mysql-db01 tools]# ln -s /application/mysql-5.6.16/ /application/mysql
#创建mysql用户
[root@mysql-db01 tools]# useradd mysql -s /sbin/nologin -M
#进入mysql初始化目录
[root@mysql-db01 tools]# cd /application/mysql/scripts/
#初始化mysql
[root@mysql-db01 scripts]# ./mysql_install_db \
--user=mysql \
--datadir=/application/mysql/data/ \
--basedir=/application/mysql/
#注解
--user：  指定mysql用户
--datadir：指定mysql数据存放目录
--basedir：指定mysql base目录
#拷贝mysql配置文件
[root@mysql-db01 ~]# \cp /application/mysql/support-files/my-default.cnf /etc/my.cnf
#拷贝mysql启动脚本
[root@mysql-db01 ~]# cp /application/mysql/support-files/mysql.server /etc/init.d/mysqld
#修改mysql默认安装目录（否则无法启动）
[root@mysql-db01 ~]# sed -i 's#/usr/local#/application#g' /etc/init.d/mysqld
[root@mysql-db01 ~]# sed -i 's#/usr/local#/application#g' /application/mysql/bin/mysqld_safe
#配置mysql环境变量
[root@mysql-db01 ~]# echo 'export PATH="/application/mysql/bin:$PATH"' >> /etc/profile.d/mysql.sh
#刷新环境变量
[root@mysql-db01 ~]# source /etc/profile
2.2.3启动
#加入开机自启
[root@mysql-db01 ~]# chkconfig mysqld on
#启动mysql
[root@mysql-db01 ~]# /etc/init.d/mysqld start
Starting MySQL........... SUCCESS! #启动成功
2.2.4配置密码
#配置mysql密码为oldboy123
[root@mysql-db01 ~]# mysqladmin -uroot password oldboy123

```

## 五.基于GTID的主从复制

### 一、基础概念 & 核心原理

### 1. GTID 格式

GTID 全局唯一，格式固定：UUID:Transaction_ID

示例：`3f4e2d10-8a7b-6c5d-4e3f-1234567890ab:1258`

* **UUID**：MySQL 实例唯一标识，保存在数据目录 `auto.cnf`，一台实例终身不变；
* **Transaction_ID**：事务序号，从 `1` 开始**连续递增**，实例每执行一个事务，序号 + 1。

核心特性：**一个事务对应唯一 GTID，一个 GTID 只对应一个事务，整个复制拓扑内全局唯一**。

### 2. GTID 复制三大核心规则（必背）

1. 事务在主库生成时，会**绑定 GTID 并写入 binlog**；
2. 从库拉取 binlog 后，先比对本地已执行的 GTID 集合： 
   * 本地**没有**该 GTID → 正常执行事务；
   * 本地**已有**该 GTID → **自动跳过**，杜绝重复执行；
3. GTID 模式下，搭建主从**无需手动指定 **`**MASTER_LOG_FILE**`** 和 **`**MASTER_LOG_POS**`，MySQL 自动比对 GTID 完成位点对齐。

### 3. 和传统位点复制的本质区别

* 传统：靠 `binlog文件 + 偏移量pos` 定位，人工找位点，主从切换、故障恢复极易出错；
* GTID：靠**全局事务 ID**自动定位，运维极简，适配故障转移、多从库、级联复制。

***

### 二、面试精简回答（分 3 档，直接背诵）

### 1. 极简版（10 秒简答）

GTID 即全局事务 ID，是 MySQL 新一代主从复制方案。它为每个事务分配全局唯一 ID，搭建主从无需手动指定 binlog 和位点，MySQL 自动比对 GTID 同步数据，还能自动跳过重复事务，降低运维难度。

### 2. 标准完整版（30~60 秒，首选）

GTID 全称全局事务 ID，MySQL 5.6 及以上支持，用来替代传统文件 + 位点复制。

1. 主库每个事务都会生成唯一 GTID 并写入 binlog；
2. 从库拉取日志时，通过比对本地已执行 GTID 集合，自动定位同步起点，**不用手动写 binlog 和 pos**；
3. 遇到已执行过的事务会自动跳过，避免数据重复；
4. 优势是运维简单、故障切换方便，是现在生产环境主流方案。 同时必须开启 `gtid_mode` 和 `enforce_gtid_consistency` 两个核心参数。

### 3. 深挖考点版（应对连环追问）

1. **GTID 组成**：由实例 `UUID` + 递增事务号组成，全局唯一；
2. **核心参数**： 
   * `gtid_mode=ON`：开启 GTID 模式；
   * `enforce_gtid_consistency=ON`：强制 GTID 一致性，禁止破坏 GTID 语义的 SQL；
3. **关键变量**： 
   * `gtid_executed`：实例已执行的所有 GTID 集合；
   * `gtid_purged`：已被清理（`purge`）的 binlog 对应的 GTID；
4. **限制**：开启一致性校验后，不支持 `CREATE TABLE ... SELECT`、临时表、事务混合非事务引擎等语句；
5. **适用场景**：一主多从、主从故障切换、MGR 组复制底层也依赖 GTID。

```bash
[root@db01 tools]# cat /application/mysql/data/auto.cnf  #mysql每个实例都有一个uuid
[auto]
server-uuid=11fe9dc0-7456-11ef-b976-000c29f43d84
TID: 事务提交编号

传统的主从复制：
  主库上：开启binlog
    server-id
    master_log_file: mysql-bin.000001
    master_log_pos:120
    创建一个主从复制用户
  从库上：server-id和主库不同
  
基于GTID的主从复制：
  UUID: dbbf22c5-f830-11e8-afef-000c293e6a42
  TID：事务提交编号

基于MHA的主从：
  主库：
    开启binlog
    server-id: 5
    创建一个主从复制用户
  
  从库：
    开启binlog
    server-id!=5建议大于5
    从库的server-id不能相同
    也要创建一个主从复制用户 
```

****

**双主模式**

<!-- OCR_START -->
- keepalived:vip
- master01和master02互为主从
- master01
- master02
- binlog
- slave01
- slave02
<!-- OCR_END -->

**级联复制**

<!-- OCR_START -->
- 级联复制
- 一主七从是可以的
- 中。
- master
- binlog
- save01
- slave02
- slave04
- slave05
- slav03
<!-- OCR_END -->

```bash
主库操作

[root@db ~]# vim /etc/my.cnf
[mysqld]
basedir=/application/mysql
datadir=/application/mysql/data
port=3306
socket=/tmp/mysql.sock
character-set-server=utf8mb4
skip-name-resolve
#主库server-id为1，从库不等于1
server-id=1
#开启binlog日志
log-bin=mysql-bin
binlog-format=row
# 开启gtid三个参数  主库从库都需要配置
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1  # mysql-5.7版本不用这个参数

创建主从复制用户
#登录数据库
[root@mysql-db01 ~]# mysql -uroot -p123
#创建rep用户
mysql> grant replication slave on *.* to rep@'10.0.0.%' identified by 'oldboy123';

从库操作

#修改mysql-db02配置文件  db03配置 server_id=10
[root@mysql-db02 ~]# vim /etc/my.cnf
#在mysqld标签下配置
[mysqld]
#主库server-id为1，从库必须大于1
server_id =5
log_bin=mysql-bin
binlog-format=row
gtid_mode=ON
enforce_gtid_consistency
log_slave_updates   

#重启数据库
[root@mysql-db01 ~]# /etc/init.d/mysqld restart
#检查GTID状态
mysql> show global variables like '%gtid%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| enforce_gtid_consistency | ON    | #执行GTID一致
| gtid_executed            |       |
| gtid_mode                | ON    | #开启GTID模块
| gtid_owned               |       |
| gtid_purged              |       |
+--------------------------+-------+

配置主从复制
#登录数据库
[root@mysql-db02 ~]# mysql -uroot -p123
#配置复制主机信息
mysql> change master to
#主库IP
-> master_host='10.0.0.51',
#主库复制用户
-> master_user='rep',
#主库复制用户的密码
-> master_password='123',
#GTID位置点
-> master_auto_position=1;

 change master to
master_host='10.0.0.10',
master_user='rep',
master_password='123',
master_auto_position=1;

#开启slave
mysql> start slave;
#查看slave状态
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.0.0.51
                  Master_User: rep
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000003
          Read_Master_Log_Pos: 403
               Relay_Log_File: mysql-db02-relay-bin.000002
                Relay_Log_Pos: 613
        Relay_Master_Log_File: mysql-bin.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 403
              Relay_Log_Space: 822
              Until_Condition: None

从库设置
#登录从库
[root@mysql-db02 ~]# mysql -uroot -p123
#禁用自动删除relay log 功能
mysql> set global relay_log_purge = 0;
#设置只读
mysql> set global read_only=1;
#编辑配置文件 ,
[root@mysql-db02 ~]# vim /etc/my.cnf
#在mysqld标签下添加
[mysqld]
#禁用自动删除relay log 永久生效 #这个参数主库也设置一下
relay_log_purge = 0
#设置只读 这个不要写配置里,当主从切换的时候可能出问题.
#read_only=1

```

****

小报错

```bash

mysql> show slave status \G
.....
lat_IO_Error: error connectiong to master 'slave@172.16.1.52:3306' - retry-time: 60 retries:1

排查过程
ping 172.16.1.52  #通的
telnet 172.16.1.52 3306 #通的
# mysql -uslave -p1 -h172.16.1.52
ERROR 1045 (28000): Access denied for user 'slave'@'mysql-01' (using password: YES)
# 这里报错提示的主机名mysql-01
解决: 
# vi /etc/my.cnf
skip-name-resolv   #mysql-5.6跳过反向解析
skip_name_resolve  #mysql-5.7的写法  #5.6这么写也可以
```

## 六.部署MHA

1）环境准备（所有节点）

下载地址

<https://github.com/yoshinorim/mha4mysql-manager/wiki/Downloads>

项目地址

<https://github.com/yoshinorim/mha4mysql-manager/releases>

<https://github.com/yoshinorim/mha4mysql-node/releases>

```bash
#安装依赖包
[root@mysql-db01 ~]# yum install perl-DBD-MySQL -y

wget https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
wget https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node-0.58-0.el7.centos.noarch.rpm

#安装node包 (所有mysql 主从节点)
[root@mysql-db01 tools]# rpm -ivh mha4mysql-node-0.56-0.el6.noarch.rpm
Preparing...                ########################################### [100%]
   1:mha4mysql-node         ########################################### [100%]
#登录数据库
[root@mysql-db01 tools]# mysql -uroot -p123
#添加mha管理账号
mysql> grant all privileges on *.* to mha@'10.0.0.%' identified by 'mha';

#查看是否添加成功
mysql> select user,host from mysql.user;
#主库上创建，从库会自动复制（在从库上查看）
mysql> select user,host from mysql.user;

命令软连接（所有节点）
#如果不创建命令软连接，检测mha复制情况的时候会报错
ln -s /application/mysql/bin/mysqlbinlog /usr/bin/mysqlbinlog
ln -s /application/mysql/bin/mysql /usr/bin/mysql

```

**

*部署管理节点（mha-manager:mysql-db03）*

```bash
#使用epel源
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo

#安装manager依赖包
yum install -y perl-Config-Tiny epel-release perl-Log-Dispatch perl-Parallel-ForkManager perl-Time-HiRes

#安装manager包 0.58版本需要把 mha4mysql-node-0.58-0.el7.noarch.rpm 安装下
rpm -ivh mha4mysql-manager-0.56-0.el6.noarch.rpm 

编辑配置文件
#创建配置文件目录
[root@mysql-db03 ~]# mkdir -p /etc/mha
#创建日志目录
[root@mysql-db03 ~]# mkdir -p /var/log/mha/app1
#编辑mha配置文件  如果有两套集群搞两个配置文件
[root@mysql-db03 ~]# vim /etc/mha/app1.cnf
[server default]
manager_log=/var/log/mha/app1/manager
manager_workdir=/var/log/mha/app1
master_binlog_dir=/application/mysql/data
user=mha
password=mha
ping_interval=2
repl_user=rep
repl_password=oldboy123
ssh_user=root
[server1]
hostname=10.0.0.10
port=3306
[server2]
candidate_master=1
check_repl_delay=0
hostname=10.0.0.11
port=3306
[server3]
hostname=10.0.0.15
port=3306

```

**配置文件详解**

```bash
[server default]
#设置manager的工作目录
manager_workdir=/var/log/masterha/app1
#设置manager的日志
manager_log=/var/log/masterha/app1/manager.log 
#设置master 保存binlog的位置，以便MHA可以找到master的日志，我这里的也就是mysql的数据目录
master_binlog_dir=/data/mysql
#设置自动failover时候的切换脚本
master_ip_failover_script= /usr/local/bin/master_ip_failover
#设置手动切换时候的切换脚本
master_ip_online_change_script= /usr/local/bin/master_ip_online_change
#设置mysql中root用户的密码，这个密码是前文中创建监控用户的那个密码
password=123456
#设置监控用户root
user=root
#设置监控主库，发送ping包的时间间隔，尝试三次没有回应的时候自动进行failover
ping_interval=1
#设置远端mysql在发生切换时binlog的保存位置
remote_workdir=/tmp
#设置复制用户的密码
repl_password=123456
#设置复制环境中的复制用户名 
repl_user=rep
#设置发生切换后发送的报警的脚本
report_script=/usr/local/send_report
#一旦MHA到server02的监控之间出现问题，MHA Manager将会尝试从server03登录到server02
secondary_check_script= /usr/local/bin/masterha_secondary_check -s server03 -s server02 --user=root --master_host=server02 --master_ip=192.168.0.50 --master_port=3306
#设置故障发生后关闭故障主机脚本（该脚本的主要作用是关闭主机放在发生脑裂,这里没有使用）
shutdown_script=""
#设置ssh的登录用户名
ssh_user=root 
[server1]
hostname=10.0.0.51
port=3306
[server2]
hostname=10.0.0.52
port=3306
# 标记当前从库为【候选主库】，主库宕机后优先选为新主
candidate_master=1
# 关闭MHA自动根据复制延迟过滤候选从库的逻辑
check_repl_delay=0

```

*配置ssh信任（所有节点）*

```bash
#所有节点做互信,都可以相互免密登录
#创建秘钥对
ssh-keygen -t ed25519 -P '' -f ~/.ssh/id_dsa >/dev/null 2>&1
#发送公钥，包括自己
ssh-copy-id -i /root/.ssh/id_dsa.pub root@10.0.0.51
ssh-copy-id -i /root/.ssh/id_dsa.pub root@10.0.0.52
ssh-copy-id -i /root/.ssh/id_dsa.pub root@10.0.0.53

```

*启动测试*

```bash
#测试ssh
[root@mysql-db03 ~]# masterha_check_ssh --conf=/etc/mha/app1.cnf
#看到如下字样，则测试成功
Tue Mar  7 01:03:33 2017 - [info] All SSH connection tests passed successfully.
#测试复制
[root@mysql-db03 ~]# masterha_check_repl --conf=/etc/mha/app1.cnf
#看到如下字样，则测试成功
MySQL Replication Health is OK.

```

*启动MHA*

```bash
#启动
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

#查看状态
masterha_check_status --conf=/etc/mha/app1.cnf

```

*切换master测试*

```bash
#登录数据库（db02）
[root@mysql-db02 ~]# mysql -uroot -p123
#检查复制情况
mysql> show slave status\G
            
#登录数据库（db03）
[root@mysql-db03 ~]# mysql -uroot -p123
#检查复制情况
mysql> show slave status\G

#停掉主库  # 在mha master上查看 tail -f /var/log/mha/app1/manager.log
[root@mysql-db01 ~]# /etc/init.d/mysqld stop
Shutting down MySQL..... SUCCESS!

#登录数据库（db02）
[root@mysql-db02 ~]# mysql -uroot -p123
#查看slave状态
mysql> show slave status\G
#db02的slave已经为空
Empty set (0.00 sec)

#登录数据库（db03）
[root@mysql-db03 ~]# mysql -uroot -p123
#查看slave状态
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.0.0.52
                  Master_User: rep
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000006
          Read_Master_Log_Pos: 191
               Relay_Log_File: mysql-db03-relay-bin.000002
                Relay_Log_Pos: 361
        Relay_Master_Log_File: mysql-bin.000006
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes

------------------------------------------------------
mha启动时读取配置文件: 
    从上到下,按行读取
    切换后,摘除down掉的主机
    重写配置文件
# master 主机上配置文件
[root@db01 tmp]# cat /etc/mha/app1.cnf

MHA修复步骤:
1.修复down的主库   
# /etc/init.d/mysqld start 
2.在mha日志中找到: change master to 语句 
# grep -i 'change master to' /var/log/mha/app1/manager.log
3.连接旧主库,执行change master to 语句
change master to 
master_host='10.0.0.11',
master_port=3306, 
master_auto_position=1, 
master_user='rep',
master_password='123';

4.打开IO,SQL线程(start slave;)
start slave 
5.把旧主库的server标签在MHA配置文件中添加回来  
# vi /etc/mha/app1.cnf

6.启动MHA
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

masterha_check_status --conf=/etc/mha/app1.cnf

----------------------------------------------------启动mha命令参数说明
nohup          						 命令放后台执行
 &
screen
masterha_manager           启动MHA的命令
--conf=/etc/mha/appl.cnf   指定配置文件
--remove_dead_master_conf  移除down机主库的配置
--ignore_last_failover     忽略最后一次故障转移
MHA的切换机制：
  1.切换后会生成一个临时文件，在MHA的工作目录下
  2.下一次切换之前，先检测是否存在这个临时文件T
  3.如果存在，则不做切换
  4.如果不存在，则做切换
  5.该文件，存在时间：8小时
  
</dev/null>/var/log/mha/appl/manager.log 2>&1&   打印日志

#基于传统的主从复制的日志
tail -f  /var/log/mha/appl/manager.log
vim /etc/my.cnf #下面参数注释掉
# gtid_mode=ON
# enforce_gtid_consistency
# log_slave_updates   # mysql-5.7版本不用这个参数

#mysql压测命令
mysqlslap --defaults-file=/etc/my.cnf \
--concurrency=100 --iterations=1 --create-schema='test' \
--query="select * from test.student where sname='zls801'" engine=innodb \
--number-of-queries=200000000 -verbose

```

## 七.配置VIP漂移

> VIP漂移的两种方式
>
> 1）通过keepalived的方式，管理虚拟IP的漂移
>
> 2）通过MHA自带脚本方式，管理虚拟IP的漂移

mha+keepalived 方式

<!-- OCR_START -->
- MHA +keepalived
- 半同步
- master
- keepal
- lived
- slave01
- 1.提升配置
- 2.不对外提供服务
- Slave02
- slave03
<!-- OCR_END -->

**MHA脚本方式**

*修改配置文件*

```bash
[root@db01 tools]# tar xf mha4mysql-manager-0.58.tar.gz
[root@db01 tools]# ll mha4mysql-manager-0.58/samples/scripts/  #master_ip_failover文件在这里

 #widows复制过来的文件需要转换一下
dos2unix /usr/local/bin/master_ip_failover 

配置步骤
vi /usr/local/bin/master_ip_failover  

#根据配置文件中脚本路径编辑
[root@mysql-db03 ~]# vim /usr/local/bin/master_ip_failover
#修改以下几行内容
my $vip = '10.0.0.55/24';   #这里修改成同网段空闲的地址
my $key = '0';              #key是网卡名称拼接:0 
my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";  #这里网卡名称eth0 是本地上的网络名称
my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down"; 
#添加执行权限，否则mha无法启动
chmod +x /usr/local/bin/master_ip_failover

#编辑配置文件
[root@mysql-db03 ~]# vim /etc/mha/app1.cnf
#在[server default]标签下添加
[server default]
#使用MHA自带脚本
master_ip_failover_script=/usr/local/bin/master_ip_failover

重启mha
masterha_stop --conf=/etc/mha/app1.cnf
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

# 手动绑定VIP 在主服务器上绑定 vip,可以提前绑定 
#绑定vip
ifconfig eth0:1 10.0.0.55/24
#查看vip
ip a |grep eth0

```

**

**

*测试ip漂移*

```bash
#登录db02
[root@mysql-db02 ~]# mysql -uroot -poldboy123
#查看slave信息
mysql> show slave status\G

#停掉主库
[root@mysql-db01 ~]# /etc/init.d/mysqld stop
Shutting down MySQL..... SUCCESS!

#在db03上查看从库slave信息
mysql> show slave status\G

#在db01上查看vip信息
ip a |grep eth0
#在db02上查看vip信息
ip a |grep eth0

```

#### 漂移脚本/usr/local/bin/master_ip_failover

```perl
#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Getopt::Long;

my (
    $command,          $ssh_user,        $orig_master_host, $orig_master_ip,
    $orig_master_port, $new_master_host, $new_master_ip,    $new_master_port
);

my $vip = '10.0.0.55/24';
my $key = '1';
my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down";

GetOptions(
    'command=s'          => \$command,
    'ssh_user=s'         => \$ssh_user,
    'orig_master_host=s' => \$orig_master_host,
    'orig_master_ip=s'   => \$orig_master_ip,
    'orig_master_port=i' => \$orig_master_port,
    'new_master_host=s'  => \$new_master_host,
    'new_master_ip=s'    => \$new_master_ip,
    'new_master_port=i'  => \$new_master_port,
);

exit &main();

sub main {

    print "\n\nIN SCRIPT TEST====$ssh_stop_vip==$ssh_start_vip===\n\n";

    if ( $command eq "stop" || $command eq "stopssh" ) {

        my $exit_code = 1;
        eval {
            print "Disabling the VIP on old master: $orig_master_host \n";
            &stop_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn "Got Error: $@\n";
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "start" ) {

        my $exit_code = 10;
        eval {
            print "Enabling the VIP - $vip on the new master - $new_master_host \n";
            &start_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn $@;
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "status" ) {
        print "Checking the Status of the script.. OK \n";
        exit 0;
    }
    else {
        &usage();
        exit 1;
    }
}

sub start_vip() {
    `ssh $ssh_user\@$new_master_host \" $ssh_start_vip \"`;
}
sub stop_vip() {
     return 0  unless  ($ssh_user);
    `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip \"`;
}

sub usage {
    print
    "Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}

```

## 八.配置binlog-server

防止主库连接不上,用来存储binlog日志

```bash
# binlogserver配置：
# 找一台额外的机器，必须要有5.6以上的版本，支持gtid并开启，我们直接用的第二个slave（db03）
# 不是mysql的机器 yum install mysql-client ; 建议使用不是集群中的一台机器;

# 修改mha配置文件
[root@mysql-db03 ~]# vim /etc/mha/app1.cnf
[binlog1]
no_master=1   #永远不会当主库
hostname=10.0.0.15
master_binlog_dir=/data/mysql/binlog/

# 备份binlog
#创建备份binlog目录
mkdir -p /data/mysql/binlog/
#进入该目录
cd /data/mysql/binlog/
#备份binlog, ip是主库的; 生产中改成vip
mysqlbinlog  -R --host=10.0.0.55 --user=mha --password=mha --raw  --stop-never mysql-bin.000001 &
#启动mha 在mha-master主机上
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

```

**

*测试binlog备份*

```bash
#查看binlog sserver 目录中的binlog
[root@mysql-db03 binlog]# ll
total 44
-rw-r--r-- 1 root root 285 Mar  8 03:11 mysql-bin.000001
#登录主库
[root@mysql-db01 ~]# mysql -uroot -p123
#刷新binlog
mysql> flush logs;
#再次查看binlog目录
[root@mysql-db03 binlog]# ll
total 48
-rw-r--r-- 1 root root 285 Mar  8 03:11 mysql-bin.000001
-rw-r--r-- 1 root root 143 Mar  8 04:00 mysql-bin.000002

```

## 九.MySQL中间件Atlas

**Atlas简介**

Atlas是由 Qihoo 360公司Web平台部基础架构团队开发维护的一个基于MySQL协议的数据中间层项目。它在MySQL官方推出的MySQL-Proxy 0.8.2版本的基础上，修改了大量bug，添加了很多功能特性。它在MySQL官方推出的MySQL-Proxy 0.8.2版本的基础上，修改了大量bug，添加了很多功能特性。

**Atlas主要功能**

***

* 1.读写分离
* 2.从库负载均衡
* 3.IP过滤
* 4.自动分表
* 5.DBA可平滑上下线DB
* 6.自动摘除宕机的DB

***

**Atlas相对于官方MySQL-Proxy的优势**

***

* 1.将主流程中所有Lua代码用C重写，Lua仅用于管理接口
* 2.重写网络模型、线程模型
* 3.实现了真正意义上的连接池
* 4.优化了锁机制，性能提高数十倍

***

**安装Atlas**

安装Atlas真的是炒鸡简单，官方提供的Atlas有两种：

1）Atlas (普通) : Atlas-2.2.1.el6.x86_64.rpm

2）Atlas (分表) : Atlas-sharding_1.0.1-el6.x86_64.rpm

这里我们只需要下载普通的即可。

<https://github.com/Qihoo360/Atlas/releases>

```bash
#在主库安装，进入安装包目录
cd ~/tools/
#下载Atlas
wget https://github.com/Qihoo360/Atlas/releases/download/2.2.1/Atlas-2.2.1.el6.x86_64.rpm
#安装
rpm -ivh Atlas-2.2.1.el6.x86_64.rpm 

```

**编辑配置文件**

```bash
#进入Atlas工具目录
[root@mysql-db01 ~]# cd /usr/local/mysql-proxy/bin/
#生成密码
# /usr/local/mysql-proxy/bin/encrypt oldboy123
1N/CNLSgqXuTZ6zxvGQr9A==
# /usr/local/mysql-proxy/bin/encrypt mha
O2jBXONX098=

#修改Atlas配置文件
[root@mysql-db01 ~]# vim /usr/local/mysql-proxy/conf/test.cnf
[mysql-proxy]
#Atlas后端连接的MySQL主库的IP和端口，可设置多项，用逗号分隔, 写vip地址
proxy-backend-addresses = 10.0.0.55:3306
#Atlas后端连接的MySQL从库的IP和端口
proxy-read-only-backend-addresses = 10.0.0.11:3306,10.0.0.15:3306
#用户名与其对应的加密过的MySQL密码
pwds = root:1N/CNLSgqXuTZ6zxvGQr9A==
#SQL日志的开关
sql-log = ON
#Atlas监听的工作接口IP和端口
proxy-address = 0.0.0.0:3307
#默认字符集，设置该项后客户端不再需要执行SET NAMES语句
charset = utf8
---------------------------------------上面的配置当说明

[root@db03 bin]# cat /usr/local/mysql-proxy/conf/test.cnf
[mysql-proxy]
admin-username = user
admin-password = pwd
#Atlas后端连接的MySQL主库的IP和端口，可设置多项，用逗号分隔, # 写vip地址
proxy-backend-addresses = 10.0.0.55:3306
#Atlas后端连接的MySQL从库的IP和端口
proxy-read-only-backend-addresses = 10.0.0.11:3306,10.0.0.15:3306
#用户名与其对应的加密过的MySQL密码
pwds = mha:O2jBXONX098=,repl:1N/CNLSgqXuTZ6zxvGQr9A==
daemon = true
keepalive = true
event-threads = 8
log-level = message
log-path = /usr/local/mysql-proxy/log
#SQL日志的开关
sql-log=ON
sql-log-slow = 10
admin-address = 0.0.0.0:2345
#Atlas监听的工作接口IP和端口
proxy-address = 0.0.0.0:3307
#默认字符集，设置该项后客户端不再需要执行SET NAMES语句
charset=utf8

```

**启动Atlas**

```bash
[root@mysql-db01 ~]# /usr/local/mysql-proxy/bin/mysql-proxyd test start
OK: MySQL-Proxy of test is started
```

**Atlas管理操作**

```bash
#用atlas管理用户登录
[root@mysql-db01 ~]# mysql -uuser -ppwd -h127.0.0.1 -P2345
#查看可用命令帮助
mysql> select * from help;
#查看后端代理的库
mysql> SELECT * FROM backends;
+-------------+----------------+-------+------+
| backend_ndx | address        | state | type |
+-------------+----------------+-------+------+
|           1 | 10.0.0.51:3307 | up    | rw   |
|           2 | 10.0.0.53:3307 | up    | ro   |
|           3 | 10.0.0.52:3307 | up    | ro   |
+-------------+----------------+-------+------+
#平滑摘除mysql
mysql> REMOVE BACKEND 2;
Empty set (0.00 sec)
#检查是否摘除成功
mysql> SELECT * FROM backends;
+-------------+----------------+-------+------+
| backend_ndx | address        | state | type |
+-------------+----------------+-------+------+
|           1 | 10.0.0.51:3307 | up    | rw   |
|           2 | 10.0.0.52:3307 | up    | ro   |
+-------------+----------------+-------+------+
#保存到配置文件中
mysql> SAVE CONFIG;
Empty set (0.06 sec)

```

#### 漂移脚本/usr/local/bin/master_ip_failover,

基于[base_master_ip_failover.txt](https://www.yuque.com/preview/yuque/0/2024/txt/194754/1726652256877-a4cfead1-059f-4c34-afdf-e3810a6ea5b4.txt?from=https%3A%2F%2Fwww.yuque.com%2Fchengkanghua%2Fzg4iuy%2Fidpgcq%231127cea9) 做的调整.

Atlas 高可用方法,集群每台机器都装 Atlas, 使用 vip 作为对外提供服务

主库出故障停止服务, 提升一个最新的从库为主库,其他从库从新指向新主库, 同时 vip 漂移到新主库机器上,

同时更新 atlas 中的移除 新主库的 ip 地址(之前是从库),更新配置文件

```perl
#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Getopt::Long;

my (
    $command,          $ssh_user,        $orig_master_host, $orig_master_ip,
    $orig_master_port, $new_master_host, $new_master_ip,    $new_master_port
);

my $vip = '10.0.0.55/24';
my $key = '1';
my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down";

GetOptions(
    'command=s'          => \$command,
    'ssh_user=s'         => \$ssh_user,
    'orig_master_host=s' => \$orig_master_host,
    'orig_master_ip=s'   => \$orig_master_ip,
    'orig_master_port=i' => \$orig_master_port,
    'new_master_host=s'  => \$new_master_host,
    'new_master_ip=s'    => \$new_master_ip,
    'new_master_port=i'  => \$new_master_port,
);

exit &main();

sub main {

    print "\n\nIN SCRIPT TEST====$ssh_stop_vip==$ssh_start_vip===\n\n";

    if ( $command eq "stop" || $command eq "stopssh" ) {

        my $exit_code = 1;
        eval {
            print "Disabling the VIP on old master: $orig_master_host \n";
            &stop_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn "Got Error: $@\n";
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "start" ) {

        my $exit_code = 10;
        eval {
            print "Enabling the VIP - $vip on the new master - $new_master_host \n";
            &start_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn $@;
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "status" ) {
        print "Checking the Status of the script.. OK \n";
        exit 0;
    }
    else {
        &usage();
        exit 1;
    }
}

sub start_vip() {
    `ssh $ssh_user\@$new_master_host \" $ssh_start_vip \"`;
    my $atlas_bad_id = `mysql -uuser -ppwd -h 127.0.0.1 -P2345 -e 'select * from backends' |awk /$new_master_host/'{print \$1}'`;
     system "ssh -t 10.0.0.\$(echo $orig_master_host | awk -F'.' '{print \$4}') '/usr/local/mysql-proxy/bin/mysql-proxyd test stop'";
    `ssh 10.0.0.10 \" mysql -uuser -ppwd -h 127.0.0.1 -P2345 -e 'remove backend $atlas_bad_id; SAVE CONFIG;' \"`;
    `ssh 10.0.0.11 \" mysql -uuser -ppwd -h 127.0.0.1 -P2345 -e 'remove backend $atlas_bad_id; SAVE CONFIG;' \"`;
    `ssh 10.0.0.15 \" mysql -uuser -ppwd -h 127.0.0.1 -P2345 -e 'remove backend $atlas_bad_id; SAVE CONFIG;' \"`;
 

}
sub stop_vip() {
     return 0  unless  ($ssh_user);
    `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip;  \"`;
}

sub usage {
    print
    "Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}

```

```bash
# user@127.0.0.1> select * from help;
# +---------------------------+-----------------------------------------------------------+
# | command                    | description                                               |
# +---------------------------+-----------------------------------------------------------+
# | SELECT * FROM help        | 查看help帮助                                              |
# | SELECT * FROM backends    | 查看后端代理的数据库                                      |
# | SET OFFLINE $backend_id   | 平滑下线数据库，例：SET OFFLINE 1；加后端ID               |
# | SET ONLINE $backend_id    | 平滑上线数据库，例：SET ONLINE 1；加后端ID                |
# | ADD MASTER $backend       | 添加一个主库，例：ADD MASTER 172.16.1.56:3306;            |
# | ADD SLAVE $backend        | 添加一个从库，例：ADD SLAVE 172.168.1.57:3306;           |
# | REMOVE BACKEND $backend_id| 删除一个后端的库：例：REMOVE BACKEND 1；加后端ID          |
# | SELECT * FROM clients     | 查看可连接管理接口客户端                                  |
# | ADD CLIENT $client        | 添加一个客户端，例：ADD CLIENT 10.0.0.52;                 |
# | REMOVE CLIENT $client     | 删除一个客户端，例：REMOVE CLIENT 10.0.0.52;              |
# | SELECT * FROM pwds        | 查看Atlas可连接用户                                       |
# | ADD PWD $pwd              | 添加用户(密码会自动加密)例：ADD PWD mha:mha;              |
# | ADD ENPWD $pwd            | 添加用户(需要加密后的密码)例：ADD ENPWD mha:02jBXONX098=  |
# | REMOVE PWD $pwd           | 删除用户，例：REMOVE PWD mha;                             |
# | SAVE CONFIG               | 保存到配置文件                                            |
# | SELECT VERSION            | 查看版本信息                                              |
# +---------------------------+-----------------------------------------------------------+
```

作业:

Atlas 高可用省机器方法,集群每台机器都装 Atlas, 使用 vip 作为对外提供服务

第二种方法再加一台机器装 atlas 加上keepalive

<!-- OCR_START -->
- Atlas
- master
- slave1
- 40.0.0.55
- 10.0.0.55：
- 3307
- WWo
- slave3
- slave2
- /o. 4. D.
- MHA
- master_ip_failover
- 10.0.0.56
- At lo
<!-- OCR_END -->

## MHA 生产环境上线流程

[附件: MHA生产环境上线流程.docx](./attachments/附件-MHA生产环境上线流程/MHA生产环境上线流程.docx)

[附件: base_master_ip_failover.txt](./attachments/附件-MHA生产环境上线流程/base_master_ip_failover.txt)

> 更新: 2026-06-09 16:57:31  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/idpgcq>