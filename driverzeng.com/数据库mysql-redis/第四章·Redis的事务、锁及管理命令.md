# 第四章· Redis的事务、锁及管理命令

# 一.事务介绍
## Redis的事务与关系型数据库中的事务区别
1）在MySQL中讲过的事务，具有A、C、I、D四个特性

Atomic（原子性）

所有语句作为一个单元全部成功执行或全部取消。

Consistent（一致性）

如果数据库在事务开始时处于一致状态，则在执行该。 事务期间将保留一致状态。

Isolated（隔离性）

事务之间不相互影响。

Durable（持久性）

事务成功完成后，所做的所有更改都会准确地记录在 数据库中。所做的更改不会丢失。

2）MySQL具有MVCC（多版本并发控制）的功能，这些都是根据事务的特性来完成的。

3）redis中的事务跟关系型数据库中的事务是一个相似的概念，但是有不同之处。关系型数据库事务执行失败后面的sql语句不在执行前面的操作都会回滚，而在redis中开启一个事务时会把所有命令都放在一个队列中，这些命令并没有真正的执行，如果有一个命令报错，则取消这个队列，所有命令都不再执行。

4）redis中开启一个事务是使用multi，相当于begin\start transaction，exec提交事务，discard取消队列命令（非回滚操作）。

| | MySQL | Redis |
| --- | :--- | :--- |
| 开启 | start transaction begin | multi |
| 语句 | 普通SQL | 普通命令 |
| 失败 | rollback回滚 | discard取消（这里的取消不是回滚，是队列里的命令根本没有执行，并不是执行了之后，再撤回） |
| 成功 | commit | exec |

和事务相关的命令

```bash
1）取消事务，放弃执行事务块内的所有命令。
DISCARD 
2）执行所有事务块内的命令。
EXEC  
3）标记一个事务块的开始。
MULTI  
4）取消 WATCH 命令对所有 key 的监视。
UNWATCH  
5）监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。
WATCH key [key ...]  

```

## 事务测试
```bash
#登录redis
[root@db01 ~]# redis-cli
#验证密码
127.0.0.1:6379> auth 123
OK
#不开启事务直接设置key
127.0.0.1:6379> set zls "Nice"
OK
#查看结果
127.0.0.1:6379> get zls
"Nice"
#开启事务
127.0.0.1:6379> MULTI
OK
#设置一个key
127.0.0.1:6379> set bgx "low"
QUEUED
127.0.0.1:6379> set alex "Ugly"
QUEUED
#开启另一个窗口查看结果
127.0.0.1:6379> get bgx
(nil)
127.0.0.1:6379> get alex
(nil)
#执行exec完成事务
127.0.0.1:6379> EXEC
1) OK
2) OK
#再次查看结果
127.0.0.1:6379> get bgx
"low"
127.0.0.1:6379> get alex
"Ugly"
```

**实验结果如下:**

<!-- OCR_START -->
- root@db01:~（ssh)
- 127.0.0.1:6379> MULTI
- 127.0.0.1:6379>getbgx
- OK
- (nil)
- 127.0.0.1:6379> set bgx "low"
- 127.0.0.1:6379>get alex
- QUEUED
- 127.0.0.1:6379> set alex "Ugly"
- "low"
- 127.0.0.1:6379> EXEC
- 1) 0K
- "Ugly"
- 2)0K
- 127.0.0.1:6379>
<!-- OCR_END -->

￼

## 二.Redis乐观锁介绍

乐观锁举例

场景：我正在买票

Ticket -1 , money -100

而票只有1张, 如果在我multi之后,和exec之前, 票被别人买了---即ticket变成0了.

我该如何观察这种情景,并不再提交？

1）悲观的想法:

世界充满危险,肯定有人和我抢, 给 ticket上锁, 只有我能操作. [悲观锁]

2）乐观的想法:

没有那么人和我抢,因此,我只需要注意,

--有没有人更改ticket的值就可以了 [乐观锁]

3）Redis的事务中,启用的是乐观锁,只负责监测key没有被改动.

乐观锁实现

**模拟买票**

开启两个窗口实现（模拟买票）

```bash
#首先在第一个窗口设置一个key（ticket 1）
127.0.0.1:6379> set ticket 1
OK
#设置完票的数量之后观察这个票
127.0.0.1:6379> WATCH ticket
OK
#开启事务
127.0.0.1:6379> MULTI
OK
#买了票所以ticket设置为0
127.0.0.1:6379> set ticket 0
QUEUED

#然后在第二个窗口观察票
127.0.0.1:6379> WATCH ticket
OK
#开启事务
127.0.0.1:6379> MULTI
OK
#同样设置ticket为0
127.0.0.1:6379> set ticket 0
QUEUED

#此时如果谁先付款，也就是执行了exec另外一个窗口就操作不了这张票了
#在第二个窗口先付款（执行exec）
127.0.0.1:6379> exec
1) OK
#然后在第一个窗口再执行exec
127.0.0.1:6379> exec
(nil)       //无，也就是说我们无法对这张票进行操作
```

**实验结果如下**

<!-- OCR_START -->
- root@db01:~(ssh)
- 127.0.0.1:6379> set ticket 1
- 127.0.0.1:6379> WATCH ticket
- OK
- 127.0.0.1:6379> MULTI
- 127.0.0.1:6379> set ticket 0
- QUEUED
- 127.0.0.1:6379> exec
- 1）0K
- 127.0.0.1:6379>
- (nil)
<!-- OCR_END -->

## 三.Redis管理命令
## INFO
```bash
#查看redis相关信息
127.0.0.1:6379> info
#服务端信息
# Server
#版本号
redis_version:3.2.12
#redis版本控制安全hash算法
redis_git_sha1:00000000
#redis版本控制脏数据
redis_git_dirty:0
#redis建立id
redis_build_id:3b947b91b7c31389
#运行模式：单机（如果是集群：cluster）
redis_mode:standalone
#redis所在宿主机的操作系统
os:Linux 2.6.32-431.el6.x86_64 x86_64
#架构（64位）
arch_bits:64
#redis事件循环机制
multiplexing_api:epoll
#GCC的版本
gcc_version:4.4.7
#redis进程的pid
process_id:33007
#redis服务器的随机标识符(用于sentinel和集群)
run_id:46b07234cf763cab04d1b31433b94e31b68c6e26
#redis的端口
tcp_port:6379
#redis服务器的运行时间（单位秒）
uptime_in_seconds:318283
#redis服务器的运行时间（单位天）
uptime_in_days:3
#redis内部调度（进行关闭timeout的客户端，删除过期key等等）频率，程序规定serverCron每秒运行10次
hz:10
#自增的时钟，用于LRU管理,该时钟100ms(hz=10,因此每1000ms/10=100ms执行一次定时任务)更新一次
lru_clock:13601047
#服务端运行命令路径
executable:/application/redis-3.2.12/redis-server
#配置文件路径
config_file:/etc/redis/6379/redis.conf
#客户端信息
# Clients
#已连接客户端的数量(不包括通过slave的数量)
connected_clients:2
##当前连接的客户端当中，最长的输出列表，用client list命令观察omem字段最大值
client_longest_output_list:0
#当前连接的客户端当中，最大输入缓存，用client list命令观察qbuf和qbuf-free两个字段最大值
client_biggest_input_buf:0
#正在等待阻塞命令(BLPOP、BRPOP、BRPOPLPUSH)的客户端的数量
blocked_clients:0
#内存信息
# Memory
#由redis分配器分配的内存总量，以字节为单位
used_memory:845336
#以人类可读的格式返回redis分配的内存总量
used_memory_human:825.52K
#从操作系统的角度，返回redis已分配的内存总量(俗称常驻集大小)。这个值和top命令的输出一致
used_memory_rss:1654784
#以人类可读方式，返回redis已分配的内存总量
used_memory_rss_human:1.58M
#redis的内存消耗峰值(以字节为单位)
used_memory_peak:845336
#以人类可读的格式返回redis的内存消耗峰值
used_memory_peak_human:825.52K
#整个系统内存
total_system_memory:1028517888
#以人类可读的格式，显示整个系统内存
total_system_memory_human:980.87M
#Lua脚本存储占用的内存
used_memory_lua:37888
#以人类可读的格式，显示Lua脚本存储占用的内存
used_memory_lua_human:37.00K
#Redis实例的最大内存配置
maxmemory:0
#以人类可读的格式，显示Redis实例的最大内存配置
maxmemory_human:0B
#当达到maxmemory时的淘汰策略
maxmemory_policy:noeviction
#内存分裂比例（used_memory_rss/ used_memory）
mem_fragmentation_ratio:1.96
#内存分配器
mem_allocator:jemalloc-4.0.3
#持久化信息
# Persistence
#服务器是否正在载入持久化文件
loading:0
#离最近一次成功生成rdb文件，写入命令的个数，即有多少个写入命令没有持久化
rdb_changes_since_last_save:131
#服务器是否正在创建rdb文件
rdb_bgsave_in_progress:0
#最近一次rdb持久化保存时间
rdb_last_save_time:1540009420
#最近一次rdb持久化是否成功
rdb_last_bgsave_status:ok
#最近一次成功生成rdb文件耗时秒数
rdb_last_bgsave_time_sec:-1
#如果服务器正在创建rdb文件，那么这个域记录的就是当前的创建操作已经耗费的秒数
rdb_current_bgsave_time_sec:-1
#是否开启了aof
aof_enabled:0
#标识aof的rewrite操作是否在进行中
aof_rewrite_in_progress:0
#rewrite任务计划，当客户端发送bgrewriteaof指令，如果当前rewrite子进程正在执行，那么将客户端请求的bgrewriteaof变为计划任务，待aof子进程结束后执行rewrite
aof_rewrite_scheduled:0
#最近一次aof rewrite耗费的时长
aof_last_rewrite_time_sec:-1
#如果rewrite操作正在进行，则记录所使用的时间，单位秒
aof_current_rewrite_time_sec:-1
#上次bgrewriteaof操作的状态
aof_last_bgrewrite_status:ok
#上次aof写入状态
aof_last_write_status:ok
#统计信息
# Stats
#新创建连接个数,如果新创建连接过多，过度地创建和销毁连接对性能有影响，说明短连接严重或连接池使用有问题，需调研代码的连接设置
total_connections_received:19
#redis处理的命令数
total_commands_processed:299
#redis当前的qps，redis内部较实时的每秒执行的命令数
instantaneous_ops_per_sec:0
#redis网络入口流量字节数
total_net_input_bytes:10773
#redis网络出口流量字节数
total_net_output_bytes:97146
#redis网络入口kps
instantaneous_input_kbps:0.00
#redis网络出口kps
instantaneous_output_kbps:0.00
#拒绝的连接个数，redis连接个数达到maxclients限制，拒绝新连接的个数
rejected_connections:0
#主从完全同步次数
sync_full:0
#主从完全同步成功次数
sync_partial_ok:0
#主从完全同步失败次数
sync_partial_err:0
#运行以来过期的key的数量
expired_keys:5
#过期的比率
evicted_keys:0
#命中次数
keyspace_hits:85
#没命中次数
keyspace_misses:17
#当前使用中的频道数量
pubsub_channels:0
#当前使用的模式的数量
pubsub_patterns:0
#最近一次fork操作阻塞redis进程的耗时数，单位微秒
latest_fork_usec:0
#是否已经缓存了到该地址的连接
migrate_cached_sockets:0
#主从复制信息
# Replication
#角色主库
role:master
#连接slave的个数
connected_slaves:0
#主从同步偏移量,此值如果和上面的offset相同说明主从一致没延迟，与master_replid可被用来标识主实例复制流中的位置
master_repl_offset:0
#复制积压缓冲区是否开启
repl_backlog_active:0
#复制积压缓冲大小
repl_backlog_size:1048576
#复制缓冲区里偏移量的大小
repl_backlog_first_byte_offset:0
#此值等于 master_repl_offset - repl_backlog_first_byte_offset,该值不会超过repl_backlog_size的大小
repl_backlog_histlen:0
#CPU信息
# CPU
#将所有redis主进程在内核态所占用的CPU时求和累计起来
used_cpu_sys:203.44
#将所有redis主进程在用户态所占用的CPU时求和累计起来
used_cpu_user:114.57
#将后台进程在内核态所占用的CPU时求和累计起来
used_cpu_sys_children:0.00
#将后台进程在用户态所占用的CPU时求和累计起来
used_cpu_user_children:0.00
#集群信息
# Cluster
#实例是否启用集群模式
cluster_enabled:0
#库相关统计信息
# Keyspace
#db0的key的数量,以及带有生存期的key的数,平均存活时间
db0:keys=17,expires=0,avg_ttl=0
#单独查看某一个信息（例：查看CPU信息）
127.0.0.1:6379> info cpu
# CPU
used_cpu_sys:203.45
used_cpu_user:114.58
used_cpu_sys_children:0.00
used_cpu_user_children:0.00
```

## client
```bash
#查看客户端连接信息（有几个会话就会看到几条信息）
127.0.0.1:6379> CLIENT LIST
id=19 addr=127.0.0.1:35687 fd=6 name= age=30474 idle=8962 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 obl=0 oll=0 omem=0 events=r cmd=info
id=21 addr=127.0.0.1:35689 fd=7 name= age=3 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=32768 obl=0 oll=0 omem=0 events=r cmd=client
#杀掉某一个会话
127.0.0.1:6379> CLIENT KILL 127.0.0.1:35687

```

## config
```bash
#重置统计状态信息
127.0.0.1:6379> CONFIG RESETSTAT
#查看所有配置信息
127.0.0.1:6379> CONFIG GET *
#查看某个配置信息
127.0.0.1:6379> CONFIG GET maxmemory
1) "maxmemory"
2) "0"
#动态修改配置信息
127.0.0.1:6379> CONFIG SET maxmemory 60G
OK
#再次查看修改后的配置信息
127.0.0.1:6379> CONFIG GET maxmemory
1) "maxmemory"
2) "60000000000"
```

## dbsize
```bash
#查看当前库内有多少个 key
127.0.0.1:6379> DBSIZE
(integer) 17
#验证key的数量
127.0.0.1:6379> KEYS *
 1) "lidao_fans"
 2) "ticket"
 3) "myhash"
 4) "teacher1"
 5) "name"
 6) "zls_fans"
 7) "bgx_fans"
 8) "mykey"
 9) "bgx"
10) "diffkey"
11) "alex"
12) "KEY"
13) "teacher"
14) "key3"
15) "unionkey"
16) "zls"
17) "wechat"
```

## select
**在Redis中也是有库这个概念的，不过不同于MySQL，Redis的库是默认的，并不是我们手动去创建的，在Redis中一共有16（0-15）个库。在MySQL中进入某一个库，我们需要使用use dbname，在Redis中，只需要select即可。默认情况下，我们是在0库中进行操作，每个库之间都是隔离的。**

```bash
#在0库中创建一个key
127.0.0.1:6379> set name zls
OK
#查看0库中的所有key
127.0.0.1:6379> KEYS *
1) "name"

#进1库中
127.0.0.1:6379> SELECT 1
OK
#查看所有key
127.0.0.1:6379[1]> KEYS *
(empty list or set)         //由此可见，每个库之间都是隔离的
```

## flushdb、flushall
```bash
#删库跑路专用命令（删除所有库）
127.0.0.1:6379> FLUSHALL
OK
#验证一下是否真的删库了
127.0.0.1:6379> DBSIZE
(integer) 0
127.0.0.1:6379> KEYS *
(empty list or set)

#删除单个库中数据
127.0.0.1:6379> FLUSHDB
OK
```

## monitor
**开启两个窗口进行命令实时监控**

```bash
#在第一个窗口开启监控
127.0.0.1:6379> MONITOR
OK

#在第二个窗口输入命令
127.0.0.1:6379> SELECT 2
OK
127.0.0.1:6379[2]> set name bgx
OK
127.0.0.1:6379[2]> info

#在第一个窗口会实时显示执行的命令
127.0.0.1:6379> MONITOR
OK
1540392396.690268 [0 127.0.0.1:35689] "SELECT" "2"
1540392409.883011 [2 127.0.0.1:35689] "set" "name" "bgx"
1540392543.892889 [2 127.0.0.1:35689] "info"

```

**实验结果如下**

<!-- OCR_START -->
×root@db01:~ (ssh)
127.0.0.1:6379> MONITOR
127.0.0.1:6379>SELECT2
OK
1540392685.379978 [0 127.0.0.1:35689] "SELECT" "2"
127.0.0.1:6379[2]> set name bgx
1540392696.475088
[2 127.0.0.1:35689]
"set""name""bgx
1540392700.130948 [2 127.0.0.1:35689] “info"
127.0.0.1:6379[2]> info
#Server
redis_version:3.2.12
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:3b947b91b7c31389
redis_mode:standalone
0s:Linux 2.6.32-431.e16.x86_64 x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:4.4.7
process_id:33007
run_id:46b07234cf763cab04d1b31433b94e31b68c6e26
tcp_port:6379
uptime_in_seconds:383123
uptime_in_days:4
hz:10
lru_clock:13665887
executable:/application/redis-3.2.12/redis-server
config_file:/etc/redis/6379/redis.conf
#Clients
connected_clients:2
client_longest_output_list:0
client_biggest_input_buf:0
blocked_clients:0
#Memory
used_memory:842920
used_memory_human:823.16K
used_memory_rss:1761280
used_memory_rss_human:1.68M
used_memory_peak:865240
used_memory_peak_human:844.96K
total_system_memory:1028517888
total_system_memory_human:980.87M
used_memory_lua:37888
used_memory_lua_human:37.00K
ixmemory:6000000000
maxmemory_human:55.88G
emory_policy:noeviction
mem_fragmentation_ratio:2.09
mem_allocator:jemalloc-4.0.3
#Persistence
loading:0
rdb_changes_since_last_save:151
rdb_bgsave_in_progress:0
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_curr
<!-- OCR_END -->

## shutdown
```bash
#关闭Redis服务
127.0.0.1:6379> SHUTDOWN
not connected>

```

> 更新: 2024-09-09 16:15:58  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/browcb>