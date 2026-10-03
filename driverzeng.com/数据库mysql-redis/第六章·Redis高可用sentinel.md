# 第六章· Redis高可用sentinel

# sentinel介绍

## 什么是sentinel？

Redis-Sentinel是Redis官方推荐的高可用性(HA)解决方案，当用Redis做Master-slave的高可用方案时，假如master宕机了，Redis本身(包括它的很多客户端)都没有实现自动进行主备切换，而Redis-sentinel本身也是一个独立运行的进程，它能监控多个master-slave集群，发现master宕机后能进行自动切换。

## sentinel的构造
Sentinel 是一个监视器，它可以根据被监视实例的身份和状态来判断应该执行何种动作。

<!-- OCR_START -->
- 监视
- sentinel
- （哨兵）
- master
- TheNiceBoyLikeMe
- driverzeng
- 复制
- slave01
- slave03
- slave02
<!-- OCR_END -->

## sentinel的功能

1）监控（Monitoring）：

Sentinel会不断地检查你的主服务器和从服务器是否运作正常。

2）提醒（Notification）：

当被监控的某个Redis服务器出现问题时，Sentinel可以通过API向管理员或者其他应用程序发送通知。

3）自动故障迁移（Automatic failover）：

当一个主服务器不能正常工作时，Sentinel会开始一次自动故障迁移操作，它会将失效主服务器的其中一个从服务器升级为新的主服务器，并让失效主服务器的其他从服务器改为复制新的主服务器；当客户端试图连接失效的主服务器时，集群也会向客户端返回新主服务器的地址，使得集群可以使用新主服务器代替失效服务器。

### 发现并连接主服务器

Sentinel通过用户给定的配置文件来发现主服务器。

<!-- OCR_START -->
- TheNiceBoyLikeMe.
- driverzeng
- sentinel
- （哨兵）
- 创建命令连接
- 创建订阅连接
- master1
- master2
<!-- OCR_END -->

Sentinel会与被监视的主服务器创建两个网络连接：

**命令连接**用于向主服务器发送命令。

**订阅连接**用于订阅指定的频道，从而发现监视同一主服务器的其他Sentinel。

**配置文件示例**

```bash
redis-sentinel sentinel.conf
############ master1 configure ##############
sentinel monitor master1 127.0.0.1 6379 2
sentinel down-after-milliseconds master1 30000
sentinel parallel-syncs master1 1
sentinel failover-timeout master1 900000
############ master2 configure ##############
sentinel monitor master2 127.0.0.1 12345 5
sentinel down-after-milliseconds master2 50000
sentinel parallel-syncs master2 5
sentinel failover-timeout master2 450000
```

### 发现并连接从服务器

Sentinel通过向主服务器发送**INFO**命令来自动获得所有从服务器的地址。

<!-- OCR_START -->
- TheNiceBoyLikeMe
- driverzeng
- ntinel
- INFO
- master
- 命令连接
- 订阅连接
- 复制
- slave01
- slave02
- slave03
- slave04
<!-- OCR_END -->

跟主服务器一样，Sentinel 会与每个被发现的从服务器创建命令连接和订阅连接。

### 发现其他sentinel

Sentinel 会通过命令连接向被监视的主从服务器发送 “HELLO” 信息，该消息包含 Sentinel 的 IP、端口号、ID 等内容，以此来向其他 Sentinel 宣告自己的存在。与此同时Sentinel 会通过订阅连接接收其他 Sentinel 的“HELLO” 信息，以此来发现监视同一个主服务器的其他 Sentinel 。

<!-- OCR_START -->
- sentinel01通过发送HELLO信息让02、（
- 03、
- 04发现自己，
- 其他几个sentinel也会进行类似操作
- sentinelo
- （哨兵）
- 接收消息
- （订阅连接）
- 发送消息
- （命令连接）
- TheNiceBoyLikeMe
- master1
- driverzeng
<!-- OCR_END -->

1）一个Sentinel可以与其他多个Sentinel进行连接，各个Sentinel之间可以互相检查对方的可用性，并进行信息交换。你无须为运行的每个 Sentinel 分别设置其他 Sentinel 的地址，因为Sentinel可以通过发布与订阅功能来自动发现正在监视相同主服务器的其他 Sentinel ，这一功能是通过向频道__sentinel__:hello发送信息来实现的。

2）与此类似，你也不必手动列出主服务器属下的所有从服务器，因为 Sentinel 可以通过询问主服务器来获得所有从服务器的信息。每个Sentinel会以每两秒一次的频率，通过发布与订阅功能，向被它监视的所有主服务器和从服务器的__sentinel__:hello频道发送一条信息，信息中包含了Sentinel的IP地址、端口号和运行ID（runid）。

3）每个Sentinel都订阅了被它监视的所有主服务器和从服务器的__sentinel__:hello 频道，查找之前未出现过的sentinel（looking for unknown sentinels）。当一个Sentinel发现一个新的Sentinel时，它会将新的Sentinel添加到一个列表中，这个列表保存了Sentinel已知的，监视同一个主服务器的所有其他 Sentinel 。Sentinel发送的信息中还包括完整的主服务器当前配置（configuration）。如果一个 Sentinel 包含的主服务器配置比另一个Sentinel发送的配置要旧，那么这个 Sentinel 会立即升级到新配置上。

4）在将一个新 Sentinel 添加到监视主服务器的列表上面之前，Sentinel 会先检查列表中是否已经包含了和要添加的 Sentinel 拥有相同运行 ID 或者相同地址（包括 IP 地址和端口号）的 Sentinel ，如果是的话，Sentinel 会先移除列表中已有的那些拥有相同运行 ID或者相同地址的 Sentinel ，然后再添加新 Sentinel 。

### 多个sentinel之间连接
Sentinel之间只会互相创建命令连接，用于进行通信。因为已经有主从服务器作为发送和接收HELLO信息的中介，所以Sentinel之间不会创建订阅连接。

<!-- OCR_START -->
- 益视
- 命令连接
- sentine
- （哨兵）
- lentinel
- master1
- The Nice Boy Like Me.
- driverzeng
- 令连
<!-- OCR_END -->

### 检测实例的状态

Sentinel使用PING命令来检测实例的状态：如果实例在指定的时间内没有返回回复，或者返回错误的回复，那么该实例会被 Sentinel 判断为下线。

**Redis的Sentinel中关于下线（down）有两个不同的概念：**

1）主观下线（Subjectively Down， 简称 SDOWN）指的是单个 Sentinel 实例对服务器做出的下线判断。

2）客观下线（Objectively Down，简称 ODOWN）指的是多个Sentinel实例在对同一个服务器做出SDOWN判断，并且通过SENTINEL is-master-down-by-addr命令互相交流之后，得出的服务器下线判断。（一个 Sentinel可以通过向另一个Sentinel发送SENTINEL is-master-down-by-addr命令来询问对方是否认为给定的服务器已下线。）

<!-- OCR_START -->
- TheNiceBoyLikeMe
- driverzeng
- sentinelG
- (哨兵）
- master1
- slave02
- slave01
<!-- OCR_END -->

￼

如果一个服务器没有在 master-down-after-milliseconds 选项所指定的时间内，对向它送PING命令的Sentinel返回一个有效回复（valid reply），那么Sentinel就会将这个服务器标记为主观下线。

**服务器对PING命令的有效回复可以是以下三种回复的其中一种:**

1)返回 +PONG 。

2)返回 -LOADING 错误。

3)返回 -MASTERDOWN 错误。

如果服务器返回除以上三种回复之外的其他回复，又或者在指定时间内没有回复Ping命令，那么Sentinel认为服务器返回的回复无效（non-valid）。

**注意：**一个服务器必须在master-down-after-milliseconds毫秒内，一直返回无效回复才会被Sentinel标记为主观下线。

举个例子，如果master-down-after-milliseconds选项的值为30000毫秒（30秒），那么只要服务器能在每29秒之内返回至少一次有效回复，这个服务器就仍然会被认为是处于正常状态的。

从主观下线状态切换到客观下线状态并没有使用严格的法定人数算法（strong quorum algorithm），而是使用了流言协议：如果 Sentinel 在给定的时间范围内，从其他Sentinel那里接收到了足够数量的主服务器下线报告，那么Sentinel就会将主服务器的状态从主观下线改变为客观下线。如果之后其他Sentinel不再报告主服务器已下线，那么客观下线状态就会被移除。

客观下线条件只适用于主服务器：对于任何其他类型的Redis实例，Sentinel在将它们判断为下线前不需要进行协商，所以从服务器或者其他 Sentinel 永远不会达到客观下线条件。

只要一个Sentinel发现某个主服务器进入了客观下线状态，这个Sentinel就可能会被其他Sentinel推选出，并对失效的主服务器执行自动故障迁移操作。

### 故障转移FAILOVER

**一次故障转移操作由以下步骤组成：**

1）发现主服务器已经进入客观下线状态。

2）基于Raft leader election协议 ，进行投票选举

3）如果当选失败，那么在设定的故障迁移超时时间的两倍之后，重新尝试当选。如果当选成功，那么执行以下步骤。

4）选出一个从服务器，并将它升级为主服务器。

5）向被选中的从服务器发送 SLAVEOF NO ONE 命令，让它转变为主服务器。

6）通过发布与订阅功能，将更新后的配置传播给所有其他Sentinel，其他Sentinel对它们自己的配置进行更新。

7）向已下线主服务器的从服务器发送SLAVEOF命令，让它们去复制新的主服务器。

8）当所有从服务器都已经开始复制新的主服务器时， leader Sentinel 终止这次故障迁移操作。

<!-- OCR_START -->
- TheNiceBoyLikeMe.
- -driverzeng
- sentinelol
- （哨兵）
- sentineld
- 人老珠黄？果断抛弃
- 监视
- master1
- 移情别
- 转正
- FAILOVER
- 复制
- 文本
- slave02
- 新主
- slave03
- slave01
- 曾老湿：没想到你是这样的sentinel！！！
<!-- OCR_END -->

每当一个Redis实例被重新配置（reconfigured）—— 无论是被设置成主服务器、从服务器、又或者被设置成其他主服务器的从服务器 —— Sentinel 都会向被重新配置的实例发送一个CONFIG REWRITE命令，从而确保这些配置会持久化在硬盘里。

> Sentinel使用以下规则来选择新的主服务器：
>
> 1）在失效主服务器属下的从服务器当中，那些被标记为主观下线、已断线、或者最后一次回复PING命令的时间大于五秒钟的从服务器都会被淘汰。
>
> 2）在失效主服务器属下的从服务器当中，那些与失效主服务器连接断开的时长超过down-after选项指定的时长十倍的从服务器都会被淘汰。
>
> 3）在经历了以上两轮淘汰之后剩下来的从服务器中，我们选出复制偏移量（replication offset）最大的那个从服务器作为新的主服务器；如果复制偏移量不可用，或者从服务器的复制偏移量相同，那么带有最小运行ID的那个从服务器成为新的主服务器。
>

---

> Sentinel自动故障迁移的一致性特质：
>
> 1）Sentinel自动故障迁移使用Raft算法来选举领头（leader）Sentinel ，从而确保在一个给定的周期（epoch）里，只有一个领头产生。
>
> 2）这表示在同一个周期中， 不会有两个 Sentinel 同时被选中为领头，并且各个 Sentinel 在同一个节点中只会对一个领头进行投票。
>
> 3）更高的配置节点总是优于较低的节点，因此每个 Sentinel 都会主动使用更新的节点来代替自己的配置。
>
> 简单来说，我们可以将Sentinel配置看作是一个带有版本号的状态。一个状态会以最后写入者胜出（last-write-wins）的方式（也即是，最新的配置总是胜出）传播至所有其他Sentinel。
>

**举个例子：**

1）当出现网络分割（network partitions）时，一个Sentinel可能会包含了较旧的配置，而当这个Sentinel接到其他Sentinel发来的版本更新的配置时，Sentinel就会对自己的配置进行更新。

2）如果要在网络分割出现的情况下仍然保持一致性， 那么应该使用 min-slaves-to-write 选项，让主服务器在连接的从实例少于给定数量时停止执行写操作，与此同时，应该在每个运行Redis主服务器或从服务器的机器上运行Redis Sentinel进程。

> Sentinel状态的持久化：
>
> 1）Sentinel 的状态会被持久化在 Sentinel 配置文件里面。
>
> 2）每当Sentinel接收到一个新的配置，或者当领头Sentinel为主服务器创建一个新的配置时，这个配置会与配置节点一起被保存到磁盘里面。
>
> 3）这意味着停止和重启Sentinel进程都是安全的。
>

---

> Sentinel在非故障迁移的情况下对实例进行重新配置：
>
> 1）即使没有自动故障迁移操作在进行，Sentinel总会尝试将当前的配置设置到被监视的实例上面。
>
> 特别是：
>
> 根据当前的配置，如果一个从服务器被宣告为主服务器，那么它会代替原有的主服务器，成为新的主服务器，并且成为原有主服务器的所有从服务器的复制对象。
>
> 2）那些连接了错误主服务器的从服务器会被重新配置， 使得这些从服务器会去复制正确的主服务器。
>
> 3）不过，在以上这些条件满足之后，Sentinel在对实例进行重新配置之前仍然会等待一段足够长的时间，确保可以接收到其他Sentinel发来的配置更新，从而避免自身因为保存了过期的配置而对实例进行了不必要的重新配置。
>

## sentinel实战及配置讲解

### 环境准备
| 角色 | 主机 | IP | 端口 |
| :--- | :--- | :--- | :--- |
| 主库（master） | db01 | 10.0.0.2 | 6379 |
| 从库（slave01） | db01 | 10.0.0.2 | 6380 |
| 从库（slave02） | db01 | 10.0.0.2 | 6381 |

### sentinel配置

```bash
#创建sentinel的配置文件目录
mkdir /etc/redis/26380
#编辑配置文件
tee /etc/redis/26380/sentinel.conf <<EOF
port 26380
dir "/etc/redis/26380"
sentinel monitor mymaster 127.0.0.1 6379 1
sentinel down-after-milliseconds mymaster 5000
EOF

#启动sentinel
redis-sentinel /etc/redis/26380/sentinel.conf &
```

### sentinel切换测试

```bash
#连接redis主库
[root@db01 26380]# redis-cli -p 6379
#关闭主库
127.0.0.1:6379> SHUTDOWN

#登录原从库6380
[root@db01 26380]# redis-cli -p 6380
#查看主从信息
127.0.0.1:6380> info replication
# Replication
role:master                 //由此可见，原从库6380已经被提升为主库
connected_slaves:1
slave0:ip=127.0.0.1,port=6381,state=online,offset=3552,lag=0  //从库变成了6381
master_repl_offset:3566
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:3565

#开启旧主库6379
[root@db01 26380]# redis-server /etc/redis/6379/redis.conf
#连接旧主库6379
[root@db01 26380]# redis-cli -p 6379
#查看主从信息
127.0.0.1:6379> info replication
# Replication
role:slave                      //角色变成了slave
master_host:127.0.0.1
master_port:6380                //主库的端口是6380
master_link_status:up
master_last_io_seconds_ago:2
master_sync_in_progress:0
slave_repl_offset:37819
slave_priority:100
slave_read_only:1
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

#在新主6380上查看主从信息
[root@db01 26380]# redis-cli -p 6380
127.0.0.1:6380> info replication
# Replication
role:master
connected_slaves:2
slave0:ip=127.0.0.1,port=6381,state=online,offset=45288,lag=1
slave1:ip=127.0.0.1,port=6379,state=online,offset=45421,lag=0  //6379自动加入了集群
master_repl_offset:45421
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:45420

```

**sentinel monitor mymaster 127.0.0.1 6379 2**

Sentinel 去监视一个名为mymaster的主服务器，这个主服务器的IP地址为127.0.0.1，端口号为6379，而将这个主服务器判断为失效至少需要2个Sentinel同意（只要同意Sentinel的数量不达标，自动故障迁移就不会执行，不过要注意，无论你设置要多少个Sentinel同意才能判断一个服务器失效，一个 Sentinel 都需要获得系统中多数（majority） Sentinel 的支持，才能发起一次自动故障迁移，并预留一个给定的配置节点（configuration Epoch，一个配置节点就是一个新主服务器配置的版本号）。换句话说，在只有少数（minority）Sentinel进程正常运作的情况下，Sentinel 是不能执行自动故障迁移的。

**sentinel down-after-milliseconds mymaster 5000**

指定了Sentinel认为服务器已经断线所需的毫秒数。如果服务器在给定的毫秒数之内，没有返回Sentinel发送的Ping命令的回复，或者返回一个错误，那么Sentinel将这个服务器标记为主观下线（subjectively down，简称SDOWN）。不过只有一个Sentinel将服务器标记为主观下线并不一定会引起服务器的自动故障迁移：只有在足够数量的Sentinel都将一个服务器标记为主观下线之后，服务器才会被标记为客观下线（objectively down， 简称 ODOWN ），这时自动故障迁移才会执行。

**sentinel failover-timeout mymaster 180000 **

自动故障切换的超时时间

**sentinel parallel-syncs mymaster 1 **

在执行故障转移时，最多可以有多少个从服务器同时对新的主服务器进行同步，这个数字越小，完成故障转移所需的时间就越长。如果从服务器被设置为允许使用过期数据集（参见对 redis.conf 文件中对 slave-serve-stale-data 选项的说明），那么你可能不希望所有从服务器都在同一时间向新的主服务器发送同步请求，因为尽管复制过程的绝大部分步骤都不会阻塞从服务器，但从服务器在载入主服务器发来的 RDB 文件时，仍然会造成从服务器在一段时间内不能处理命令请求：如果全部从服务器一起对新的主服务器进行同步，那么就可能会造成所有从服务器在短时间内全部不可用的情况出现。可以通过将这个值设为1来保证每次只有一个从服务器处于不能处理命令请求的状态。

### sentinel管理命令（不常用）

```bash
#连接sentinel管理端口
[root@db01 26380]# redis-cli -p 26380
#检测状态，返回PONG
127.0.0.1:26380> PING
PONG
#列出所有被监视的主服务器
127.0.0.1:26380> SENTINEL masters
#列出所有被监视的从服务器
127.0.0.1:26380> SENTINEL slaves mymaster
#返回给定名字的主服务器的IP地址和端口号
127.0.0.1:26380> SENTINEL get-master-addr-by-name mymaster
1) "127.0.0.1"
2) "6380"
#重置所有名字和给定模式
127.0.0.1:26380> SENTINEL reset mymaster
#当主服务器失效时，在不询问其他Sentinel意见的情况下，强制开始一次自动故障迁移。
127.0.0.1:26380> SENTINEL failover mymaster

```

> 更新: 2024-09-09 19:02:17  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/fpy8ff>