# 05 Redis主从实践

# 05 Redis主从实践

* [Redis主从复制概述](http://class.xuliangwei.com/15294874793985.html#toc_0)
* [Redis主从复制环境](http://class.xuliangwei.com/15294874793985.html#toc_1)
* [Redis主从复制实战](http://class.xuliangwei.com/15294874793985.html#toc_2)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## Redis主从复制概述

`redis`的主从就是多台`redis`的数据保持一致。

`redis`主服务器可写入和读取，从服务器只读。

`redis`第一次同步的时候，`redis`主服务器会生成一个`rdb`文件同步到`redis`从服务上， 从服务会加载到内存中。

## Redis主从复制环境

```plain
# 一台服务器启动两个redis实例
mkdir -pv /data/redis/6379 /data/redis/6380
cp /usr/local/redis/conf/redis.conf /data/redis/6379/
cp /usr/local/redis/conf/redis.conf /data/redis/6380/
更新配置
port 6379 
pidfile /data/redis/6379/redis.pid 
logfile "/data/redis/6379/redis.log"
dir /data/redis/6379/
/usr/local/redis/bin/redis-server /data/redis/6379/redis.conf #启动6379的redis
/usr/local/redis/bin/redis-server /data/redis/6380/redis.conf #启动6380的redis
```

## Redis主从复制实战

```plain
2: redis主从的配置，6379为主库，6380为从库
redis-cli -p 6380
SLAVEOF xxx.xxx.xxx.xxx 6379
config rewrite
3: 查看主从同步信息
info Replication
4: 设置主从后，从库只有读权限
redis-cli -p 6380
set name bgx
5: 往主写入数据，主从数据会保持同步
set name bgx
6: 主从同步的停止
SLAVEOF no one #在从库上运行
7: 观察第一次同步的情况，查看日志
SLAVEOF xxx.xxx.xxx.xxx 6379
8: 加密的主从同步
config set requirepass 'bgx' #主服务器设置密码，从服务器过段时间就显示为down的状态了
config set masterauth 'bgx' #从服务器需要设置主从同步的认证密码
#requirepass和masterauth主从的配置保持一致，预防主从切换后环境不一致。
9: redis一主多从的配置
     -> 从
主  -> 从
     -> 从
10: redis 主->从->从(去从库那同步数据)
```

> 更新: 2019-03-21 09:13:00  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/xr3t50>