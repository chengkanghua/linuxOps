# 第五章· Redis主从复制介绍

# 一.Redis主从复制
## Redis复制功能简单介绍
1）使用异步复制。

2）一个主服务器可以有多个从服务器。

3）从服务器也可以有自己的从服务器。

4）复制功能不会阻塞主服务器。

5）可以通过复制功能来让主服务器免于执行持久化操作，由从服务器去执行持久化操作即可。

## Redis复制功能介绍（重点了解）
1）Redis 使用异步复制。从 Redis**2.8**开始，从服务器会以每秒一次的频率向主服务器报告复制流（replication stream）的处理进度。

2）一个主服务器可以有多个从服务器。

3）不仅主服务器可以有从服务器，从服务器也可以有自己的从服务器，多个从服务器之间可以构成一个图状结构。

4）复制功能不会阻塞主服务器：即使有一个或多个从服务器正在进行初次同步， 主服务器也可以继续处理命令请求。

5）复制功能也不会阻塞从服务器：只要在 redis.conf 文件中进行了相应的设置， 即使从服务器正在进行初次同步， 服务器也可以使用旧版本的数据集来处理命令查询。

6）在从服务器删除旧版本数据集并载入新版本数据集的那段时间内，连接请求会被阻塞。

7）还可以配置从服务器，让它在与主服务器之间的连接断开时，向客户端发送一个错误。

8）复制功能可以单纯地用于数据冗余（data redundancy），也可以通过让多个从服务器处理只读命令请求来提升扩展性（scalability）： 比如说，繁重的**SORT**命令可以交给附属节点去运行。

9）可以通过复制功能来让主服务器免于执行持久化操作：只要关闭主服务器的持久化功能，然后由从服务器去执行持久化操作即可。

## Redis架构图

<!-- OCR_START -->
- TheNiceBoyLikeMe.
- driverzeng
- Redis Master
- 10.0.0.51
- slaveof:10.0.0.51
- RedisSlave01
- RedisSlave02
- 10.0.0.53
- 10.0.0.52
- slaveof:10.0.0.53
- slaveof:10.0.0.52
- Redis Slave03
- Redis Slave04
- RedisSlave06
- 10:0:0.54
- 10.0.0.55
- RedisSlave05
- 10.0.0.57
- 10.0.0.56
<!-- OCR_END -->

关闭主服务器持久化时，复制功能的数据安全

1.当配置Redis复制功能时，强烈建议打开主服务器的持久化功能。 否则的话，由于延迟等问题，部署的服务应该要避免自动拉起。

2.为了帮助理解主服务器关闭持久化时自动拉起的危险性，参考一下以下会导致主从服务器数据全部丢失的例子：

1）假设节点A为主服务器，并且关闭了持久化。并且节点B和节点C从节点A复制数据

2）节点A崩溃，然后由自动拉起服务重启了节点A. 由于节点A的持久化被关闭了，所以重启之后没有任何数据

3）节点B和节点C将从节点A复制数据，但是A的数据是空的，于是就把自身保存的数据副本删除。

**结论：**

1）在关闭主服务器上的持久化，并同时开启自动拉起进程的情况下，即便使用Sentinel来实现Redis的高可用性，也是非常危险的。因为主服务器可能拉起得非常快，以至于Sentinel在配置的心跳时间间隔内没有检测到主服务器已被重启，然后还是会执行上面的数据丢失的流程。

2）无论何时，数据安全都是极其重要的，所以应该禁止主服务器关闭持久化的同时自动拉起。

## 主从复制的原理

<!-- OCR_START -->
- 开启主从发送sync命令
- TheNiceBoyLikeMe
- driverzeng
- RedisMaster
- RedisSlave01
- 发送RDB文件
- 10.0.0.51
- 10.0.0.52
- 发送缓冲区保存的所有命令
<!-- OCR_END -->

图1· 由一位灵魂画师画出的 Redis主从复制原理图

1）从服务器向主服务器发送 SYNC 命令。

2）接到 SYNC 命令的主服务器会调用BGSAVE 命令，创建一个 RDB 文件，并使用缓冲区记录接下来执行的所有写命令。

3）当主服务器执行完 BGSAVE 命令时，它会向从服务器发送 RDB 文件，而从服务器则会接收并载入这个文件。

4）主服务器将缓冲区储存的所有写命令发送给从服务器执行。

## 开启主从复制

```bash
#开启主从复制（在从库上执行）
127.0.0.1:6379> SLAVEOF 10.0.0.51 6379
OK
#查看主从信息
127.0.0.1:6379> INFO replication
# Replication
role:slave                      # 角色是从库
master_host:10.0.0.51           # 主库IP是10.0.0.51
master_port:6379
master_link_status:down
master_last_io_seconds_ago:-1
master_sync_in_progress:0
slave_repl_offset:1
master_link_down_since_seconds:1540419761
slave_priority:100
slave_read_only:1
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

```

# 二.Redis主从复制工作机制

## SYNC命令执行示例

<!-- OCR_START -->
- TheNiceBoyLikeMe.
- -driverzeng
- RedisMaster
- RedisSlave01
- 10.0.0.51
- 10.0.0.52
- TO
- TO时间启动服务
- 服务器启动
- TO时间执行
- T1
- T1时间设置key
- setk1v1
- T2
- T2时间设置key
- setk2v2
- T3
- T3时间设置key
- setk3v4
- 接收到client的
- T4
- T4时间开启主从复制
- slaveof命令
- 向主服务器发送SYNC命令
- slaveof:10.0.0.51
- 创建RDB，使用
- T5
- T5时间接收到slave的SYNC命令，执行BGSAVE
- 缓冲区记录接下
- 来的写命令
- setk4v4
- T6
- T6时间写入新数据
- 并将命令写入缓
- 冲区
- setk5、v5
- T7
- T7时间写入新数据
- T8
- T8时间执行完BGSAVE命令
- RDB文件创建完
- 接收并载入RDB文
- 向从服务器发送RDB文件
- 件，创建k1、k2、k3
- 向从服务器发送
- T9
- T9时间主库发送命令
- 接收命令并创建
- 缓冲区的命令
- 发送setk4、k5
- k4v4、k5v5
- 完成主从复制
- 主库上有：
- k1v1
- T10
- T10时间完成主从复制
- k2v2
- 数据一致
- k3v3
- k4v4
- k5v5
<!-- OCR_END -->

## 命令传播

在主从服务器完成同步之后，主服务器每执行一个写命令，它都会将被执行的写命令发送给从服务器执行，这个操作被称为“命令传播”（command propagate）。

<!-- OCR_START -->
- TheNiceBoyLikeMe.
- driverzeng
- 主服务器
- 客户
- 服务器
- 发送写命令W
<!-- OCR_END -->

命令传播是一个持续的过程：只要复制仍在继续，命令传播就会一直进行，使得主从服务器的状态可以一直保持一致。

## SYNC与PSYNC

1）在 Redis2.8版本之前，断线之后重连的从服务器总要执行一次完整重同步（fullresynchronization）操作。

2）从 Redis2.8开始，Redis使用PSYNC命令代替SYNC命令。

3）PSYNC比起SYNC的最大改进在于PSYNC实现了部分重同步（partial resync）特性：

在主从服务器断线并且重新连接的时候，只要条件允许，PSYNC可以让主服务器只向从服务器同步断线期间缺失的数据，而不用重新向从服务器同步整个数据库。

注：

PSYNC这个特性需要主服务器为被发送的复制流创建一个内存缓冲区（in-memory backlog）， 并且主服务器和所有从服务器之间都记录一个复制偏移量（replication offset）和一个主服务器 ID（master run id），当出现网络连接断开时，从服务器会重新连接，并且向主服务器请求继续执行原来的复制进程：

1）如果从服务器记录的主服务器ID和当前要连接的主服务器的ID相同，并且从服务器记录的偏移量所指定的数据仍然保存在主服务器的复制流缓冲区里面，那么主服务器会向从服务器发送断线时缺失的那部分数据，然后复制工作可以继续执行。

2）否则的话，从服务器就要执行完整重同步操作。

SYNC处理断线重连示例

<!-- OCR_START -->
- TheNiceBoyLikeMe.
- driverzeng
- RedisMaster
- RedisSlave01
- 10.0.0.51
- 10.0.0.52
- 主从服务器完成
- 主从已经做好
- 主从服务器完成同
- TO
- TO时间已经做好了主从
- 同步
- T1
- T1时间执行并传播key
- setk1v1
- 传播key
- T2
- T2时间执行并传播key
- setk2v2
- ...
- T10086
- T10086时间执行并传播key
- setk10086
- v10086
- 断线中.尝试重新
- T10087
- T5时间主从服务器断开连接
- 失去从库连接
- 从库断开连接
- 连接服务器
- setk10087
- T10088
- T10088时间写入新数据
- v10087
- setk10089
- T10089
- T10089时间写入新数据
- v10089
- 主从重新建立连
- T10090
- T10090时间主从服务器重新连接
- 建立连接
- 主从重新建立连接
- 创建k1至k10089
- T10091
- T10091时间接收从服务器发来的SYNC命令，执行BGSAVE
- 的RDB文件，新
- 建立连接并向主库
- SYNC
- 命令写入缓存
- 发送SYNC命令
- T10092
- 向从服务器发送
- T10092执行完BGSAVE
- 接收主服务器发来的RDB文件
- 获得k1至k10089
- RDB文件
- 执行主服务器发来
- T10093
- T10093时时间发送缓存命令
- 发送缓存中的命令
- 缓存中的命令
- 的缓存中的命令
- T10094
- T10094时间完成同步
- 完成主从同步
- 同步结束
<!-- OCR_END -->

如果我们仔细地观察整个断线并重连的过程，就会发现：

从服务器在断线之前已经拥有主服务器的绝大部分数据，要让主从服务器重新回到一致状态，从服务器真正需要的是 k10087、k10088和k10089这三个键的数据，而不是主服务器整个数据库的数据。SYNC 命令在处理断线并重连时的做法——**将主服务器的整个数据库重新同步给从服务器，是极度浪费的！**

PSYNC处理断线重连示例

<!-- OCR_START -->
- TheNiceBoyLikeMe
- driverzeng
- RedisMaster
- RedisSlave01
- 10.0.0.51
- 10.0.0.52
- 主从服务器完成
- 主从服务器完成同
- TO
- TO时间已经做好了主从
- 同步
- 主从已经做好
- T1
- T1时间执行并传播key
- setk1v1
- 传播key
- T2
- T2时间执行并传播key
- setk2v2
- T10086
- T10086时间执行并传播key
- setk10086
- v10086
- T5时间主从服务器断开连接
- 断线中..尝试重新
- T10087
- 失去从库连接
- 从库断开连接
- 连接服务器
- setk10087
- T10088
- T10088时间写入新数据
- v10087
- setk10089
- 断线中..试重新
- T10089
- T10089时间写入新数据
- v10089
- 主从重新建立连
- T10090
- T10090时间主从服务器重新连接
- 建立连接
- 主从重新建立连接
- T10091
- T10091时间接收从服务器发来的PSYNC命令
- 接收到从服务器
- 建立连接并向主库
- 的PSYNC命令
- PSYNC
- 发送PSYNC命令
- 返回
- T10092
- 接收+CONTINUE
- T10092时间向从服务器返回+CONTINUE回复
- +CONTINUE
- 执行部分重同步
- 发送set
- T10093
- T10093发送缺失的命令令
- k10087-10089
- 接收缺失命令
- 执行缺失命令
- T10094
- T10094时间完成同步
- 完成主从同步
- 同步结束
<!-- OCR_END -->

1）PSYNC只会将从服务器断线期间缺失的数据发送给从服务器。两个例子的情况是相同的，但SYNC 需要发送包含整个数据库的 RDB 文件，而PSYNC 只需要发送三个命令。

2）如果主从服务器所处的网络环境并不那么好的话（经常断线），那么请尽量使用 Redis 2.8 或以上版本：通过使用 PSYNC 而不是 SYNC 来处理断线重连接，可以避免因为重复创建和传输 RDB文件而浪费大量的网络资源、计算资源和内存资源。

复制的一致性问题

<!-- OCR_START -->
- 发送getk10086
- redis-cli
- redis-server
- 客户端
- 主服务器
- 发送setk10086v10086
- 服务器
- 返回OK
- TheNiceBoyLikeMe.
- driverzeng
- 返回 (nli)
<!-- OCR_END -->

1）在读写分离环境下，客户端向主服务器发送写命令 SET k10086 v10086，主服务器在执行这个写命令之后，向客户端返回回复，并将这个写命令传播给从服务器。

2）接到回复的客户端继续向从服务器发送读命令 GET k10086 ，并且因为网络状态的原因，客户端的 GET命令比主服务器传播的 SET 命令更快到达了从服务器。

3）因为从服务器键k10086的值还未被更新，所以客户端在从服务器读取到的将是一个错误（过期）的k10086值。

**Redis是怎么保证数据安全的呢？**

1）主服务器只在有至少N个从服务器的情况下，才执行写操作

2）从Redis 2.8开始，为了保证数据的安全性，可以通过配置，让主服务器只在有至少N个当前已连接从服务器的情况下，才执行写命令。

3）不过，因为 Redis 使用异步复制，所以主服务器发送的写数据并不一定会被从服务器接收到，因此， 数据丢失的可能性仍然是存在的。

4）通过以下两个参数保证数据的安全：

```bash
#执行写操作所需的至少从服务器数量
min-slaves-to-write <number of slaves>
#指定网络延迟的最大值
min-slaves-max-lag <number of seconds>

```

**这个特性的运作原理：**

1）从服务器以每秒一次的频率 PING 主服务器一次， 并报告复制流的处理情况。主服务器会记录各个从服务器最后一次向它发送 PING 的时间。用户可以通过配置， 指定网络延迟的最大值 min-slaves-max-lag ， 以及执行写操作所需的至少从服务器数量 min-slaves-to-write 。

2）如果至少有 min-slaves-to-write 个从服务器， 并且这些服务器的延迟值都少于 min-slaves-max-lag 秒， 那么主服务器就会执行客户端请求的写操作。你可以将这个特性看作 CAP 理论中的 C 的条件放宽版本： 尽管不能保证写操作的持久性， 但起码丢失数据的窗口会被严格限制在指定的秒数中。

3）另一方面， 如果条件达不到 min-slaves-to-write 和 min-slaves-max-lag 所指定的条件， 那么写操作就不会被执行， 主服务器会向请求执行写操作的客户端返回一个错误。

## Redis主从实践

**环境**

| 角色 | 主机 | IP | 端口 |
| :--- | :--- | :--- | :--- |
| 主库（master） | db01 | 10.0.0.2 | 6379 |
| 从库（slave01） | db01 | 10.0.0.2 | 6380 |
| 主库（slave02） | db01 | 10.0.0.2 | 6381 |

**配置多实例**

```bash
#创建多实例目录
mkdir -p /etc/redis/{6379,6380,6381}
#编辑多实例配置文件

#redis 6379 配置文件
tee /etc/redis/6379/redis.conf <<-'EOF'
port 6379
daemonize yes
pidfile /etc/redis/6379/redis.pid
loglevel notice
logfile /etc/redis/6379/redis.log
dbfilename dump.rdb
dir /etc/redis/6379
bind 127.0.0.1 10.0.0.2
protected-mode no
EOF

#redis 6380 配置文件
tee /etc/redis/6380/redis.conf <<-'EOF'
port 6380
daemonize yes
pidfile /etc/redis/6380/redis.pid
loglevel notice
logfile /etc/redis/6380/redis.log
dbfilename dump.rdb
dir /etc/redis/6380
bind 127.0.0.1 10.0.0.2
protected-mode no
EOF

#redis 6381 配置文件
tee /etc/redis/6381/redis.conf <<EOF
port 6381
daemonize yes
pidfile /etc/redis/6381/redis.pid
loglevel notice
logfile /etc/redis/6381/redis.log
dbfilename dump.rdb
dir /etc/redis/6381
bind 127.0.0.1 10.0.0.2
protected-mode no
EOF

#启动redis多实例
redis-server /etc/redis/6379/redis.conf
redis-server /etc/redis/6380/redis.conf
redis-server /etc/redis/6381/redis.conf

#查看进程
[root@db01 ~]# ps -ef|grep redis
root       3570      1  0 22:44 ?        00:00:00 redis-server 127.0.0.1:6379
root       3574      1  0 22:44 ?        00:00:00 redis-server 127.0.0.1:6380
root       3578      1  0 22:44 ?        00:00:00 redis-server 127.0.0.1:6381

```

**开启主从**

```bash
#连接从库slave01（6380）
[root@db01 ~]# redis-cli -p 6380
#开启主从
127.0.0.1:6380> SLAVEOF 127.0.0.1 6379
OK
#查从信息
127.0.0.1:6380> INFO replication
# Replication
role:slave                  //角色变成了从库
master_host:127.0.0.1       //主库的ip
master_port:6379            //主库的端口
master_link_status:up
master_last_io_seconds_ago:7
master_sync_in_progress:0
slave_repl_offset:15
slave_priority:100
slave_read_only:1
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

#连接从库slave02（6381）
[root@db01 ~]# redis-cli -p 6381
#开启主从
127.0.0.1:6381> SLAVEOF 127.0.0.1 6379
OK
#查看主从信息
127.0.0.1:6381> INFO replication
# Replication
role:slave                  //角色变成了从库
master_host:127.0.0.1       //主库的ip
master_port:6379            //主库的端口
master_link_status:up
master_last_io_seconds_ago:9
master_sync_in_progress:0
slave_repl_offset:225
slave_priority:100
slave_read_only:1
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

#连接master（6379）
[root@db01 ~]# redis-cli -p 6379
#在主库上查看主从复制信息
127.0.0.1:6379> INFO replication
# Replication
role:master                                                     //角色master
connected_slaves:2                                              //两台slave
slave0:ip=127.0.0.1,port=6380,state=online,offset=337,lag=1
slave1:ip=127.0.0.1,port=6381,state=online,offset=337,lag=1
master_repl_offset:337
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:336
```

**主从切换**

```bash
#连接master（6379）
[root@db01 ~]# redis-cli -p 6379
#关闭主库
127.0.0.1:6379> shutdown

#连接从库slave01（6380）
[root@db01 ~]# redis-cli -p 6380
#查看主从信息
127.0.0.1:6380> INFO replication
# Replication
role:slave
master_host:127.0.0.1
master_port:6379
master_link_status:down                 //连接主库的状态是：down
master_last_io_seconds_ago:-1
master_sync_in_progress:0
slave_repl_offset:1877
master_link_down_since_seconds:58
slave_priority:100
slave_read_only:1
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

#取消6380的主从关系
127.0.0.1:6380> SLAVEOF no one
OK
127.0.0.1:6380> info replication
# Replication
role:master                 //此时6380的角色就变成了master
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

#将其他从库重新指向新主（6380）
#连接6381从库
[root@db01 ~]# redis-cli -p 6381
#将6381从库变成6380的从库
127.0.0.1:6381> SLAVEOF 127.0.0.1 6380
OK
#查看主从信息
127.0.0.1:6381> INFO replication
# Replication
role:slave                      //角色还是slave
master_host:127.0.0.1
master_port:6380                //主库的端口已经变成了6380
master_link_status:up
master_last_io_seconds_ago:4
master_sync_in_progress:0
slave_repl_offset:1
slave_priority:100
slave_read_only:1
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

```

> 更新: 2024-09-09 18:27:20  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/gqax7a>