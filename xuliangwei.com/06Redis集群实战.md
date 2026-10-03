# 06 Redis集群实战

# 06 Redis集群实战
+ [twemproxy集群](http://class.xuliangwei.com/15294875113745.html#toc_0)
+ [Redis自带集群](http://class.xuliangwei.com/15294875113745.html#toc_1)
+ [Codis集群实战](http://class.xuliangwei.com/15294875113745.html#toc_2)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208
>

中间件

自带cluster

Codis

## twemproxy集群
```plain
集群介绍
redis集群的概念: 100个key，一部分放redis1，一部分放redis2，两部分的组合是100个key，才形成一个集群。
注意：主从跟集群的概念是不同的，主从是两个服务器都拥有全部的key。
1: twemproxy(nutcracker)介绍
twemproxy是twitter开源的一个redis和memcache集群工具
twemproxy不支持所有的redis命令，支持和不支持的命令列表见链接：https://github.com/twitter/twemproxy/blob/master/notes/redis.md
twemproxy后端的redis服务器不需要额外的配置，twemproxy会通过hash算法选择某个配置的后端redis服务器去分配key
2: twemproxy编译安装使用
yum install wget unzip libtool autoconf -y
wget 'https://codeload.github.com/twitter/twemproxy/zip/master'
unzip master
cd twemproxy-master
CFLAGS="-ggdb3 -O0" autoreconf -fvi
./configure --prefix=/usr/local/twemproxy  --enable-debug=log
make
make install
3: 安装验证
/usr/local/twemproxy/sbin/nutcracker -V
cd /usr/local/twemproxy/; mkdir -pv conf logs
4: twemproxy配置/usr/local/twemproxy/conf/nutcracker.yml
beta:
  listen: xxx.xxx.xxx.xxx:22122
  hash: fnv1a_64
  hash_tag: "{}"
  distribution: ketama
  auto_eject_hosts: false
  timeout: 400
  redis: true
  servers:
   - xxx.xxx.xxx.xxx:6379:1 master0
   - xxx.xxx.xxx.xxx:6380:1 master1
5: twemproxy的启动
/usr/local/redis/bin/redis-server /data/redis/6379/redis.conf
/usr/local/redis/bin/redis-server /data/redis/6380/redis.conf #先启动两个redis，同时做为主
/usr/local/twemproxy/sbin/nutcracker -t -c /usr/local/twemproxy/conf/nutcracker.yml  #测试配置语法
/usr/local/twemproxy/sbin/nutcracker -d -c /usr/local/twemproxy/conf/nutcracker.yml -p /usr/local/twemproxy/logs/redisproxy.pid -o /usr/local/twemproxy/logs/redisproxy.log -a 10.5.96.4 #启动(-a指定监控ip)
twemproxy启动的参数
  -h, --help             : this help   -V, --version          : show version and exit   -t, --test-conf        : test configuration for syntax errors and exit   -d, --daemonize        : run as a daemon   -D, --describe-stats   : print stats description and exit   -v, --verbose=N        : set logging level (default: 5, min: 0, max: 11)   -o, --output=S         : set logging file (default: stderr)   -c, --conf-file=S      : set configuration file (default: conf/nutcracker.yml)   -s, --stats-port=N     : set stats monitoring port (default: 22222)   -a, --stats-addr=S     : set stats monitoring ip (default: 0.0.0.0)   -i, --stats-interval=N : set stats aggregation interval in msec (default: 30000 msec)   -p, --pid-file=S       : set pid file (default: off)   -m, --mbuf-size=N      : set size of mbuf chunk in bytes (default: 16384 bytes)
6: 往redis集群写数据，查看500个key的分布情况
for line in `seq -w 500`;do
  redis-cli -h 10.5.96.4 -p 22122 set key3_${line} value_${line}
done
7: 后端redis加密的话，twemproxy的配置文件需要加入
redis_auth: bgx
8: twemproxy只有一个库，select不支持
9: twemproxy
假设有1000万，后端10个redis server。每个server只需要100万个key
10: 假设twemproxy挂掉后
后端的key分配会不会有变化
实验当twemproxy更换后，key的分配情况会不会改变
beta:
  listen: xxx.xxx.xxx.xxx:22122
  hash: fnv1a_64
  hash_tag: "{}"
  distribution: ketama
  auto_eject_hosts: false
  timeout: 400
  redis: true
  servers:
   - xxx.xxx.xxx.xxx:6379:1 master0
   - xxx.xxx.xxx.xxx:6380:1 master1
获取数据看一下key的分布是否变化
for line in `seq -w 500`;do
  redis-cli -h 10.5.96.3 -p 22122 get key3_${line}
done
优势
避免所有key分配在同一台服务器上（集群优点）
后端redis服务器不需要特殊配置
缺点
后端redis服务器如果需要增加的话，key得重新分配。
适用
缓存
永久存储(后端redis服务器都需要配置一个从服务器)
```

## Redis自带集群
```plain
redis从3.0从版本后本身支持集群，我们使用的是4.0.9，不依赖于第三方工具
1: redis集群特性
redis集群方式支持主从自动切换
redis集群只有一个库，单例或者主从的话有多个库
redis集群去中心化，只要通过其中一个入口连接即可
2: redis自带集群搭建，一般使用三主三从来构建，演示主使用7000 7001 7002，从使用8000 8001 8002
mkdir /data/redis-cluster
cd /data/redis-cluster
mkdir -pv 7000 7001 7002 8000 8001 8002
3: redis集群配置/data/redis-cluster/7000/redis.conf
cluster-enabled yes
port 7000
logfile "/data/redis-cluster/7000/redis.log"
pidfile "/data/redis-cluster/7000/redis.pid"
dir "/data/redis-cluster/7000"
daemonize yes
bind 127.0.0.1 xxx.xxx.xxx.xxx
tcp-backlog 1024
timeout 0
tcp-keepalive 0
loglevel notice
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename "dump.rdb"
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
appendonly no
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite yes
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-entries 512
list-max-ziplist-value 64
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
4: 启动redis服务器
/usr/local/redis/bin/redis-server /data/redis-cluster/7000/redis.conf
/usr/local/redis/bin/redis-server /data/redis-cluster/7001/redis.conf
/usr/local/redis/bin/redis-server /data/redis-cluster/7002/redis.conf
5: 编译安装高ruby版本，Ruby版本需要大于等于2.2.2，使用yum安装的不符合
wget --no-check-certificate 'https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.7.tar.gz'
tar -zxvf ruby-2.2.7.tar.gz
cd ruby-2.2.7
./configure #环境探测
make  #编译
make install #安装
ruby --version
ruby的redis扩展安装，如果有自带ruby的话，调用gem要用绝对路径
/usr/local/bin/gem install redis
6: 使用redis自带的工具集群
/usr/local/redis/bin/redis-trib.rb create xxx:7000 xxx:7001 xxx:7002 #三个主
7: 查看集群的信息
redis-cli -p 7000 cluster nodes
8: 使用redis-cli去操作集群，需要加入-c参数
redis-cli -c -h 10.5.96.3 -p 7000
set name1 bgx1
set name2 bgx2
9: 去中心化，随意一个入口
redis-cli -p 7000 -c get name1
redis-cli -p 7001 -c get name1
10: 批量导入数据观察
for line in `seq -w 5000`;do
  redis-cli -h 10.5.96.3 -p 7000 -c set key_${line} value_${line}
done
11.
启动从库
/usr/local/redis/bin/redis-server /data/redis-cluster/8000/redis.conf
/usr/local/redis/bin/redis-server /data/redis-cluster/8001/redis.conf
/usr/local/redis/bin/redis-server /data/redis-cluster/8002/redis.conf
1: redis自带集群的从库添加
/usr/local/redis/bin/redis-trib.rb add-node --slave 10.5.96.3:8001 10.5.96.3:7000  #添加从
/usr/local/redis/bin/redis-trib.rb add-node --slave 10.5.96.3:8002 10.5.96.3:7001
/usr/local/redis/bin/redis-trib.rb add-node --slave 10.5.96.3:8000 10.5.96.3:7002
2: 去中心化
从库的端口也能get或者set数据
3: redis集群的主从自动切换，主挂掉后，从自动变为主
redis-cli -p 7000
shutdown
如果主挂了，从会自动升为主。主再起来会变为从
4: 手动切换主从
CLUSTER FAILOVER
5: 研究方向
集群的扩展，假如集群扩到四台机器，key需要怎么分配？
```

## Codis集群实战
```plain
CentOS 7.2  两台均操作
=====================编译安装Redis
[root@test-node3 ~]# cd /usr/local/src
[root@test-node3 src]# wget http://download.redis.io/releases/redis-3.0.2.tar.gz
[root@linux-node1 src]# tar zxf redis-3.0.2.tar.gz 
[root@linux-node1 src]# cd redis-3.0.2
[root@test-node3 redis-3.0.2]# make PREFIX=/usr/local/redis install
[root@test-node3 redis-3.0.2]# cp utils/redis_init_script /etc/init.d/redis-server
[root@test-node3 redis-3.0.2]# chmod +x /etc/init.d/redis-server
[root@test-node3 redis-3.0.2]# mkdir /etc/redis
[root@test-node3 redis-3.0.2]# cp redis.conf /etc/redis/6379.conf
[root@test-node3 redis-3.0.2]# /etc/init.d/redis-server start
修改/etc/init.d/redis-server   /usr/local/redis/bin
/etc/profile
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
   echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
   echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
=====================编译安装codis
安装依赖包和go环境
[root@linux-node1 ~]# yum install -y gcc glibc gcc-c++ make git
[root@linux-node1 ~]# cd /usr/local/src
[root@linux-node1 ~]#wget https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz --no-check-certificate
[root@linux-node1 ~]# tar zxf go1.6.1.linux-amd64.tar.gz
[root@ linux-node1 src]# mv go /usr/local/
创建GOPATH
[root@ linux-node1 ~]# mkdir /usr/local/go/work/
[root@ linux-node1 ~]# vim .bash_profile
export GOROOT=/usr/local/go
export GOPATH=/usr/local/go/work
PATH=$PATH:$HOME/bin:$GOROOT/bin:$GOPATH/bin
[root@linux-node1 ~]# source .bash_profile
下载codis源码并编译
[root@linux-node1 ~]# go get -u -d github.com/CodisLabs/codis
[root@linux-node1 ~]# go get github.com/tools/godep
[root@linux-node1 ~]# cd $GOPATH/src/github.com/CodisLabs/codis
[root@linux-node1 codis ]# make && make gotest
```

> 更新: 2019-03-21 09:13:26  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/lir2d3>