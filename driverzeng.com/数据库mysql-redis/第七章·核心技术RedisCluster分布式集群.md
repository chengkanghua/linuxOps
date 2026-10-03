# 第七章·   核心技术 Redis Cluster 分布式集群

# Redis Cluster 分布式集群

## 什么是Redis Cluster

1）Redis集群是一个可以在多个Redis节点之间进行数据共享的设施（installation）。

2）Redis集群不支持那些需要同时处理多个键的Redis命令，因为执行这些命令需要在多个Redis节点之间移动数据，并且在高负载的情况下，这些命令将降低Redis集群的性能，并导致不可预测的行为。

3）Redis集群通过分区（partition）来提供一定程度的可用性（availability）：即使集群中有一部分节点失效或者无法进行通讯，集群也可以继续处理命令请求。

4）Redis集群有将数据自动切分（split）到多个节点的能力。

---

## Redis Cluster的特点

**高性能**

1.在多分片节点中，将16384个槽位，均匀分布到多个分片节点中

2.存数据时，将key做crc16（key），然后和16384进行取模，得出槽位值（0-16384之间）

3.根据计算得出的槽位值，找到相对应的分片节点的主节点，存储到相应槽位上

4.如果客户端当时连接的节点不是将来要存储的分片节点，分片集群会将客户端连接切换至真正存储节点进行数据存储

**高可用**

在搭建集群时，会为每一个分片的主节点，对应一个从节点，实现slaveof功能，同时当主节点down，实现类似于sentinel的自动failover的功能。

<!-- OCR_START -->
- slots
- 1
- SET
- ...
- CRC16（"date)&16383==2022
- 7000
- date
- 2022
- "2014-4-12"
- 5000
<!-- OCR_END -->

## Redis Cluster客户端连接任意节点

<!-- OCR_START -->
- Client3
- Client1
- Client2
<!-- OCR_END -->

如图所示，当我们用客户端连接A分片时，如果按照数据的取模，我们想要访问的数据，不在A分片中，那么集群会自动将请求进行转发。

## redis集群数据共享(设计理念)

Redis 集群使用数据分片（sharding）而非一致性哈希（consistency hashing）来实现： 一个 Redis  集群包含 16384 个哈希槽（hash slot）， 数据库中的每个键都属于这 16384 个哈希槽的其中一个， 集群使用公式  CRC16(key) % 16384 来计算键 key 属于哪个槽， 其中 CRC16(key) 语句用于计算键 key 的 CRC16 校验和  。

1.节点 A 负责处理 0 号至 5500 号哈希槽。

2.节点 B 负责处理 5501 号至 11000 号哈希槽。

3.节点 C 负责处理 11001 号至 16384 号哈希槽。

<!-- OCR_START -->
- A:Slot:0-5500
- B:Slot:5501-11000
- C:Slot:11001-16384
- Master
- 7000
- 7001
- 7002
- Slave
- 7003
- 7004
- 7005
<!-- OCR_END -->

Redis Cluster运行机制

所有的redis节点彼此互联(PING-PONG机制),内部使用二进制协议优化传输速度和带宽.

节点的fail是通过集群中超过半数的master节点检测失效时才生效.

客户端与redis节点直连,不需要中间proxy层.客户端不需要连接集群所有节点,连接集群中任何一个可用节点即可

把所有的物理节点映射到[0-16383]slot上,cluster 负责维护node<->slot<->key

Redis Cluster如何做集群复制

为了使得集群在一部分节点下线或者无法与集群的大多数（majority）节点进行通讯的情况下， 仍然可以正常运作， Redis  集群对节点使用了主从复制功能： 集群中的每个节点都有 1 个至 N 个复制品（replica）， 其中一个复制品为主节点（master），  而其余的 N-1 个复制品为从节点（slave）。

在之前列举的节点 A 、B 、C 的例子中， 如果节点 B 下线了， 那么集群将无法正常运行， 因为集群找不到节点来处理 5501 号至 11000 号的哈希槽。

假如在创建集群的时候（或者至少在节点 B 下线之前）， 我们为主节点 B 添加了从节点 B1 ， 那么当主节点 B 下线的时候，  集群就会将 B1 设置为新的主节点， 并让它代替下线的主节点 B ， 继续处理 5501 号至 11000 号的哈希槽，  这样集群就不会因为主节点 B 的下线而无法正常运作了。

不过如果节点 B 和 B1 都下线的话， Redis 集群还是会停止运作。

**集群的复制特性重用了 SLAVEOF 命令的代码，所以集群节点的复制行为和 SLAVEOF 命令的复制行为完全相同。**

Redis Cluster故障转移

1）在集群里面，节点会对其他节点进行下线检测。

2）当一个主节点下线时，集群里面的其他主节点负责对下线主节点进行故障转移。

3）换句话说，集群的节点集成了下线检测和故障转移等类似 Sentinel 的功能。

4）因为 Sentinel 是一个独立运行的监控程序，而集群的下线检测和故障转移等功能是集成在节点里面的，它们的运行模式非常地不同，所以尽管这两者的功能很相似，但集群的实现没有重用 Sentinel 的代码。

Redis Cluster中执行命令的两种情况

1）命令发送到了正确的节点：命令要处理的键所在的槽正好是由接收命令的节点负责，那么该节点执行命令，就像单机 Redis 服务器一样。

<!-- OCR_START -->
- 集群
- 7001
- 7000：槽0~5000
- 7001:槽5001~10000
- SETdate"2014-4-12"
- 7000
- 7002:槽10001～16383
- OK
- 7002
<!-- OCR_END -->

2）命令发送到了错误的节点：接收到命令的节点并非处理键所在槽的节点，那么节点将向客户端返回一个转向（redirection）错误，告知客户端应该到哪个节点去执行这个命令，客户端会根据错误提示的信息，重新向正确的节点发送命令。

<!-- OCR_START -->
- 集群
- 键date所在的槽2022并
- 7000
- 7002
- 非由节点7001负责，7001
- 向客户端返回转向错误。
- 客户端
- SET date"2014-4-12"
- 7001
- MOVED2022<7000-ip>:<7000-port>
- 客户端根据转向错误的指
- 引1，转向至节点7000，并
- 重新发送命令。
- OK
<!-- OCR_END -->

# Redis Cluster 安装部署

部署Redis Cluster

6个redis实例，一般会放到3台硬件服务器

注：在企业规划中，一个分片的两个分到不同的物理机，防止硬件主机宕机造成的整个分片数据丢失。

## 环境规划
| 外网IP | 内网IP | 端口 | 安装包 |
| --- | --- | --- | --- |
| 10.0.0.51 | 172.16.1.51 | 7000，7001 | redis-3.2.12.tar.gz |
| 10.0.0.52 | 172.16.1.52 | 7002，7003 | redis-3.2.12.tar.gz |
| 10.0.0.53 | 172.16.1.53 | 7004，7005 | redis-3.2.12.tar.gz |

## 安装集群插件
```bash
#EPEL源安装ruby支持
yum install ruby rubygems -y
#查看gem源
[root@db01 ~]# gem sources -l
*** CURRENT SOURCES ***
http://rubygems.org/
#添加阿里云的gem源
gem sources -a http://mirrors.aliyun.com/rubygems/

#删除国外gem源
gem sources  --remove https://rubygems.org/

#再次查看gem源
[root@db01 ~]# gem sources -l
#使用gem安装redis的ruby插件
[root@db01 ~]# gem install redis -v 3.3.3
Successfully installed redis-3.3.3
1 gem installed
Installing ri documentation for redis-3.3.3...
Installing RDoc documentation for redis-3.3.3...
```

## 准备6个实例
```bash
# 安装依赖包
yum install -y ncurses-devel libaio-devel cmake  gcc-c++ 
#下载
wget http://download.redis.io/releases/redis-3.2.12.tar.gz
#解压
tar xf redis-3.2.12.tar.gz
#移动到指定目录
mkdir -p /application
mv redis-3.2.12 /application/
#做软链接
ln -s /application/redis-3.2.12 /application/redis
#进入redis目录
cd /application/redis
#编译
make -j2
#添加环境变量
echo 'export PATH="/application/redis/src:$PATH"' > /etc/profile.d/redis.sh
source /etc/profile
#启动redis
src/redis-server &

redis-cli
127.0.0.1:6379> shutdown
not connected> quit

```

## 配置多实例
```bash
#创建多实例目录
mkdir -p /data/700{0..5}

#编辑多实例配置文件
cat > /data/7000/redis.conf <<EOF
port 7000
daemonize yes
pidfile /data/7000/redis.pid
loglevel notice
logfile "/data/7000/redis.log"
dbfilename dump.rdb
dir /data/7000
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF
cat > /data/7001/redis.conf <<EOF
port 7001
daemonize yes
pidfile /data/7001/redis.pid
loglevel notice
logfile "/data/7001/redis.log"
dbfilename dump.rdb
dir /data/7001
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF
cat > /data/7002/redis.conf <<EOF
port 7002
daemonize yes
pidfile /data/7002/redis.pid
loglevel notice
logfile "/data/7002/redis.log"
dbfilename dump.rdb
dir /data/7002
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7003/redis.conf <<EOF
port 7003
daemonize yes
pidfile /data/7003/redis.pid
loglevel notice
logfile "/data/7003/redis.log"
dbfilename dump.rdb
dir /data/7003
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7004/redis.conf <<EOF
port 7004
daemonize yes
pidfile /data/7004/redis.pid
loglevel notice
logfile "/data/7004/redis.log"
dbfilename dump.rdb
dir /data/7004
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat > /data/7005/redis.conf <<EOF
port 7005
daemonize yes
pidfile /data/7005/redis.pid
loglevel notice
logfile "/data/7005/redis.log"
dbfilename dump.rdb
dir /data/7005
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

#启动节点
redis-server /data/7000/redis.conf 
redis-server /data/7001/redis.conf 
redis-server /data/7002/redis.conf 
redis-server /data/7003/redis.conf 
redis-server /data/7004/redis.conf 
redis-server /data/7005/redis.conf 

#检查端口
[root@db01 ~]# netstat -lntup|grep 700*
tcp        0      0 0.0.0.0:17003               0.0.0.0:*                   LISTEN      7433/redis-server *
tcp        0      0 0.0.0.0:17004               0.0.0.0:*                   LISTEN      7437/redis-server *
tcp        0      0 0.0.0.0:17005               0.0.0.0:*                   LISTEN      7443/redis-server *
tcp        0      0 0.0.0.0:7000                0.0.0.0:*                   LISTEN      7423/redis-server *
tcp        0      0 0.0.0.0:7001                0.0.0.0:*                   LISTEN      7425/redis-server *
tcp        0      0 0.0.0.0:7002                0.0.0.0:*                   LISTEN      7429/redis-server *
tcp        0      0 0.0.0.0:7003                0.0.0.0:*                   LISTEN      7433/redis-server *
tcp        0      0 0.0.0.0:7004                0.0.0.0:*                   LISTEN      7437/redis-server *
tcp        0      0 0.0.0.0:7005                0.0.0.0:*                   LISTEN      7443/redis-server *
tcp        0      0 0.0.0.0:17000               0.0.0.0:*                   LISTEN      7423/redis-server *
tcp        0      0 0.0.0.0:17001               0.0.0.0:*                   LISTEN      7425/redis-server *
tcp        0      0 0.0.0.0:17002               0.0.0.0:*                   LISTEN      7429/redis-server *
tcp        0      0 :::17003                    :::*                        LISTEN      7433/redis-server *
tcp        0      0 :::17004                    :::*                        LISTEN      7437/redis-server *
tcp        0      0 :::17005                    :::*                        LISTEN      7443/redis-server *
tcp        0      0 :::7000                     :::*                        LISTEN      7423/redis-server *
tcp        0      0 :::7001                     :::*                        LISTEN      7425/redis-server *
tcp        0      0 :::7002                     :::*                        LISTEN      7429/redis-server *
tcp        0      0 :::7003                     :::*                        LISTEN      7433/redis-server *
tcp        0      0 :::7004                     :::*                        LISTEN      7437/redis-server *
tcp        0      0 :::7005                     :::*                        LISTEN      7443/redis-server *
tcp        0      0 :::17000                    :::*                        LISTEN      7423/redis-server *
tcp        0      0 :::17001                    :::*                        LISTEN      7425/redis-server *
tcp        0      0 :::17002                    :::*                        LISTEN      7429/redis-server *
#检查进程
[root@db01 ~]# ps -ef|grep redis
root       7423      1  0 18:30 ?        00:00:00 redis-server *:7000 [cluster]
root       7425      1  0 18:30 ?        00:00:00 redis-server *:7001 [cluster]
root       7429      1  0 18:30 ?        00:00:00 redis-server *:7002 [cluster]
root       7433      1  0 18:30 ?        00:00:00 redis-server *:7003 [cluster]
root       7437      1  0 18:30 ?        00:00:00 redis-server *:7004 [cluster]
root       7443      1  0 18:30 ?        00:00:00 redis-server *:7005 [cluster]
```

## 将所有节点加入集群
```bash
#前三个为主节点，后三个为从节点
cd /application/redis/src
./redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005
#显示信息
>>> Creating cluster
>>> Performing hash slots allocation on 6 nodes...
#前三个为主节点
Using 3 masters:
127.0.0.1:7000
127.0.0.1:7001
127.0.0.1:7002
#主从关系
Adding replica 127.0.0.1:7003 to 127.0.0.1:7000
Adding replica 127.0.0.1:7004 to 127.0.0.1:7001
Adding replica 127.0.0.1:7005 to 127.0.0.1:7002
#槽位分配
M: c1838701432c77418850dcab8fbc6edd8c15c697 127.0.0.1:7000
   slots:0-5460 (5461 slots) master
M: 80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001
   slots:5461-10922 (5462 slots) master
M: c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002
   slots:10923-16383 (5461 slots) master
S: 15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003
   replicates c1838701432c77418850dcab8fbc6edd8c15c697
S: 797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004
   replicates 80d141fdf0af0a90c98ab911812e810ac073940f
S: 49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005
   replicates c74da3c4b8250425fa3626fd486364371188b1ee
Can I set the above configuration? (type 'yes' to accept):yes

```

## 查看集群状态
```bash
#查看集群主节点状态
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep master
c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002 master - 0 1554633602486 3 connected 10923-16383
80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001 master - 0 1554633602990 2 connected 5461-10922
c1838701432c77418850dcab8fbc6edd8c15c697 127.0.0.1:7000 master - 0 1554633603493 1 connected 0-5460
#查看集群从节点状态
[root@db01 ~]# redis-cli -p 7004 cluster nodes |grep slave
15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003 slave c1838701432c77418850dcab8fbc6edd8c15c697 0 1554633682768 4 connected
49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005 slave c74da3c4b8250425fa3626fd486364371188b1ee 0 1554633683273 6 connected
797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004 myself,slave 80d141fdf0af0a90c98ab911812e810ac073940f 0 0 5 connected

```

# Redis Cluster 集群管理操作（核心）
## 如何添加Redis Cluster节点

在另外一台机器上，准备两个实例，或者在本机也可以。

```bash
#创建多实例目录
mkdir -p /data/700{6,7}
#添加多实例配置文件
cat > /data/7006/redis.conf <<EOF
port 7006
daemonize yes
pidfile /data/7006/redis.pid
loglevel notice
logfile "/data/7006/redis.log"
dbfilename dump.rdb
dir /data/7006
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF
cat > /data/7007/redis.conf <<EOF
port 7007
daemonize yes
pidfile /data/7007/redis.pid
loglevel notice
logfile "/data/7007/redis.log"
dbfilename dump.rdb
dir /data/7007
protected-mode no
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

#启动多实例
redis-server /data/7006/redis.conf
redis-server /data/7007/redis.conf

#检测端口
[root@db02 ~]# netstat -lntup|grep 700
tcp        0      0 0.0.0.0:17006               0.0.0.0:*                   LISTEN      4896/redis-server *
tcp        0      0 0.0.0.0:17007               0.0.0.0:*                   LISTEN      4900/redis-server *
tcp        0      0 0.0.0.0:7006                0.0.0.0:*                   LISTEN      4896/redis-server *
tcp        0      0 0.0.0.0:7007                0.0.0.0:*                   LISTEN      4900/redis-server *
tcp        0      0 :::17006                    :::*                        LISTEN      4896/redis-server *
tcp        0      0 :::17007                    :::*                        LISTEN      4900/redis-server *
tcp        0      0 :::7006                     :::*                        LISTEN      4896/redis-server *
tcp        0      0 :::7007                     :::*                        LISTEN      4900/redis-server *
#检测进程
[root@db02 ~]# ps -ef|grep redis
root       4896      1  0 19:35 ?        00:00:00 redis-server *:7006 [cluster]
root       4900      1  0 19:35 ?        00:00:00 redis-server *:7007 [cluster]
```

---

## 添加节点

```bash
#在主节点上执行，将db02上的redis添加到7000端口所在主节点
cd /application/redis/src
# 注意修改IP地址   ./redis-trib.rb add-node 127.0.0.1:7006 127.0.0.1:7000
[root@db01 ~]# ./redis-trib.rb add-node 172.16.1.52:7006 172.16.1.51:7000
>>> Adding node 172.16.1.52:7006 to cluster 172.16.1.51:7000
>>> Performing Cluster Check (using node 172.16.1.51:7000)
M: c1838701432c77418850dcab8fbc6edd8c15c697 172.16.1.51:7000
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
M: c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002
   slots:10923-16383 (5461 slots) master
   1 additional replica(s)
S: 15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003
   slots: (0 slots) slave
   replicates c1838701432c77418850dcab8fbc6edd8c15c697
M: 80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
S: 797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 80d141fdf0af0a90c98ab911812e810ac073940f
S: 49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005
   slots: (0 slots) slave
   replicates c74da3c4b8250425fa3626fd486364371188b1ee
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
>>> Send CLUSTER MEET to node 172.16.1.52:7006 to make it join the cluster.
[OK] New node added correctly.

#查看master状态
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep master
c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002 master - 0 1554637395372 3 connected 10923-16383
c1838701432c77418850dcab8fbc6edd8c15c697 172.16.1.51:7000 myself,master - 0 0 1 connected 0-5460
f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 172.16.1.52:7006 master - 0 1554637395476 0 connected #可以看到7006节点上并没有槽位
80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001 master - 0 1554637394866 2 connected 5461-1092

```

---

## 扩展槽位，添加主节点
```bash
#重新分片
cd /application/redis/src
[root@db01 ~]# ./redis-trib.rb reshard 127.0.0.1:7000
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: c1838701432c77418850dcab8fbc6edd8c15c697 127.0.0.1:7000
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
M: c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002
   slots:10923-16383 (5461 slots) master
   1 additional replica(s)
M: f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 172.16.1.52:7006
   slots: (0 slots) master
   0 additional replica(s)
S: 15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003
   slots: (0 slots) slave
   replicates c1838701432c77418850dcab8fbc6edd8c15c697
M: 80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
S: 797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 80d141fdf0af0a90c98ab911812e810ac073940f
S: 49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005
   slots: (0 slots) slave
   replicates c74da3c4b8250425fa3626fd486364371188b1ee
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
#你想要转移多少slot(槽位)到新节点  16384/4=4096 
How many slots do you want to move (from 1 to 16384)?4096
#哪个节点接收这些槽位？ID   新的7006节点的id
What is the receiving node ID? f4e3ce12a9aa1fe741634e74b88bb8b70b414f51
Please enter all the source node IDs.
  Type 'all' to use all the nodes as source nodes for the hash slots.
  Type 'done' once you entered all the source nodes IDs.
#源节点的ID  #all 表示从所有节点里平均分出这4096个槽位
Source node #1:all
#是否确认分片计划
Do you want to proceed with the proposed reshard plan (yes/no)? yes

# 重新查看7006节点就有槽位了
redis-cli -p 7000 cluster nodes |grep master
```

---

## 扩展槽位，添加从节点

```bash
#查询主节点ID
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep master
c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002 master - 0 1554638379595 3 connected 12288-16383
c1838701432c77418850dcab8fbc6edd8c15c697 172.16.1.51:7000 myself,master - 0 0 1 connected 1365-5460
f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 172.16.1.52:7006 master - 0 1554638379089 7 connected 0-1364 5461-6826 10923-12287
80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001 master - 0 1554638378584 2 connected 6827-10922
#添加从节点
cd /application/redis/src
# 注意id 和ip都要修改 ./redis-trib.rb add-node --slave --master-id 0a9beb9aefc42ac6bf57194dbe96beff9a839383 127.0.0.1:7007 127.0.0.1:7000
[root@db01 ~]# ./redis-trib.rb add-node --slave --master-id f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 172.16.1.52:7007 172.16.1.51:7000
>>> Adding node 172.16.1.52:7007 to cluster 172.16.1.51:7000
>>> Performing Cluster Check (using node 172.16.1.51:7000)
M: c1838701432c77418850dcab8fbc6edd8c15c697 172.16.1.51:7000
   slots:1365-5460 (4096 slots) master
   1 additional replica(s)
M: c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002
   slots:12288-16383 (4096 slots) master
   1 additional replica(s)
M: f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 172.16.1.52:7006
   slots:0-1364,5461-6826,10923-12287 (4096 slots) master
   0 additional replica(s)
S: 15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003
   slots: (0 slots) slave
   replicates c1838701432c77418850dcab8fbc6edd8c15c697
M: 80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001
   slots:6827-10922 (4096 slots) master
   1 additional replica(s)
S: 797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 80d141fdf0af0a90c98ab911812e810ac073940f
S: 49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005
   slots: (0 slots) slave
   replicates c74da3c4b8250425fa3626fd486364371188b1ee
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
>>> Send CLUSTER MEET to node 172.16.1.52:7007 to make it join the cluster.
Waiting for the cluster to join....
>>> Configure node as replica of 172.16.1.52:7006.
[OK] New node added correctly.
#查看主节点状态
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep master
c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002 master - 0 1554638533957 3 connected 12288-16383
c1838701432c77418850dcab8fbc6edd8c15c697 172.16.1.51:7000 myself,master - 0 0 1 connected 1365-5460
f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 172.16.1.52:7006 master - 0 1554638535468 7 connected 0-1364 5461-6826 10923-12287
80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001 master - 0 1554638535971 2 connected 6827-10922
#查看从节点状态
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep slave
15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003 slave c1838701432c77418850dcab8fbc6edd8c15c697 0 1554638570751 4 connected
797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004 slave 80d141fdf0af0a90c98ab911812e810ac073940f 0 1554638571257 5 connected
62952416217385e535fdceb68a9a6825c752714c 172.16.1.52:7007 slave f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 0 1554638572266 7 connected
49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005 slave c74da3c4b8250425fa3626fd486364371188b1ee 0 1554638572266 6 connected

```

---

## 删除节点

```bash
#重新分片
[root@db01 ~]# ./redis-trib.rb reshard 127.0.0.1:7000
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: c1838701432c77418850dcab8fbc6edd8c15c697 127.0.0.1:7000
   slots:1365-5460 (4096 slots) master
   1 additional replica(s)
M: c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002
   slots:12288-16383 (4096 slots) master
   1 additional replica(s)
M: f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 172.16.1.52:7006
   slots:0-1364,5461-6826,10923-12287 (4096 slots) master
   1 additional replica(s)
S: 15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003
   slots: (0 slots) slave
   replicates c1838701432c77418850dcab8fbc6edd8c15c697
M: 80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001
   slots:6827-10922 (4096 slots) master
   1 additional replica(s)
S: 797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 80d141fdf0af0a90c98ab911812e810ac073940f
S: 62952416217385e535fdceb68a9a6825c752714c 172.16.1.52:7007
   slots: (0 slots) slave
   replicates f4e3ce12a9aa1fe741634e74b88bb8b70b414f51
S: 49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005
   slots: (0 slots) slave
   replicates c74da3c4b8250425fa3626fd486364371188b1ee
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
#移动多少槽位
How many slots do you want to move (from 1 to 16384)?4096
#接收槽位的节点ID
What is the receiving node ID? c1838701432c77418850dcab8fbc6edd8c15c697
#源节点的ID
Source node #1:f4e3ce12a9aa1fe741634e74b88bb8b70b414f51
#结束
Source node #2:done
#是否确认分片计划
Do you want to proceed with the proposed reshard plan (yes/no)? yes

#查看主节点状态获取ID
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep master
c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002 master - 0 1554638856125 3 connected 12288-16383
c1838701432c77418850dcab8fbc6edd8c15c697 172.16.1.51:7000 myself,master - 0 0 8 connected 0-6826 10923-12287
f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 172.16.1.52:7006 master - 0 1554638856632 7 connected #7006没了槽位
80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001 master - 0 1554638856632 2 connected 6827-10922
#查看从节点状态获取ID
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep slave
15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003 slave c1838701432c77418850dcab8fbc6edd8c15c697 0 1554638997865 8 connected
797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004 slave 80d141fdf0af0a90c98ab911812e810ac073940f 0 1554638998876 5 connected
62952416217385e535fdceb68a9a6825c752714c 172.16.1.52:7007 slave c1838701432c77418850dcab8fbc6edd8c15c697 0 1554638998371 8 connected
49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005 slave c74da3c4b8250425fa3626fd486364371188b1ee 0 1554638997865 6 connected
                                                                #7005的从库主节点变成了7002的id
#删除节点   redis-trib.rb del-node 127.0.0.1:7006 0a9beb9aefc42ac6bf57194dbe96beff9a839383
[root@db01 ~]# redis-trib.rb del-node 172.16.1.52:7006 f4e3ce12a9aa1fe741634e74b88bb8b70b414f51
>>> Removing node f4e3ce12a9aa1fe741634e74b88bb8b70b414f51 from cluster 172.16.1.52:7006
>>> Sending CLUSTER FORGET messages to the cluster...
>>> SHUTDOWN the node.
#7007从节点删除   redis-trib.rb del-node 127.0.0.1:7007 7ccc67950d66525b841e1b125dd5873e4c5a57fb
[root@db01 ~]# redis-trib.rb del-node 172.16.1.52:7007 62952416217385e535fdceb68a9a6825c752714c
>>> Removing node 62952416217385e535fdceb68a9a6825c752714c from cluster 172.16.1.52:7007
>>> Sending CLUSTER FORGET messages to the cluster...
>>> SHUTDOWN the node.
#查看主节点状态，检查节点是否删除
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep master
c74da3c4b8250425fa3626fd486364371188b1ee 127.0.0.1:7002 master - 0 1554639086209 3 connected 12288-16383
c1838701432c77418850dcab8fbc6edd8c15c697 172.16.1.51:7000 myself,master - 0 0 8 connected 0-6826 10923-12287
80d141fdf0af0a90c98ab911812e810ac073940f 127.0.0.1:7001 master - 0 1554639085704 2 connected 6827-10922
#查看从节点状态，检查节点是否删除
[root@db01 ~]# redis-cli -p 7000 cluster nodes |grep slave
15bb1efcbddf404ed079651b34cc4d8a56e769e8 127.0.0.1:7003 slave c1838701432c77418850dcab8fbc6edd8c15c697 0 1554639091757 8 connected
797516c376ab94eb8211414efd5cf5e4074945d7 127.0.0.1:7004 slave 80d141fdf0af0a90c98ab911812e810ac073940f 0 1554639092261 5 connected
49de58635d02ee66ce950e44bf06d055faf44131 127.0.0.1:7005 slave c74da3c4b8250425fa3626fd486364371188b1ee 0 1554639091256 6 connected

```

	

> 更新: 2024-09-10 10:47:07  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ne6vdm>