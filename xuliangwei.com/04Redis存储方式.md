# 04 Redis存储方式

# 04 Redis存储方式
+ [RDB存储方式](http://class.xuliangwei.com/15294874093464.html#toc_0)
+ [AOF存储方式](http://class.xuliangwei.com/15294874093464.html#toc_1)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208
>

## RDB存储方式
```plain
1: redis的运行方式说明
redis如果提供缓存的服务，可以关闭所有存储，这样子如果redis重启后所有数据会丢失。
开启rdb或者aof存储，能把redis中的数据持久化到磁盘中。
rdb和aof对性能都有影响，所以建议持久化的操作在从库上执行。
2: redis rdb存储方式，使用save配置开启rdb存储或者关闭rdb存储
dir /data/redis/    #dir为rdb存储的路径
dbfilename dump.rdb  #rdb存储文件的名字
save 60 10000   #60s更改10000个key，则触发rdb存储
save 300 10    #300s更改了10个key则触发存储
save 900 1    #900s更新了1个key则触发存储
rdbcompression no   #rdb压缩最好关闭，影响cpu
3: 设置开启或者关闭rdb
config set save '' #关闭rdb存储
config rewrite
config set save "180 1 120 10 60 10000" #开启rdb存储
config rewrite
4: 写入数据，观察rdb存储
for line in `seq -w 100`;do
  redis-cli set key_${line} value_${line}
done
5: redis提供的bgsave命令能够触发rdb存储，观察存储日志
bgsave #会启动一个新进程存储
save  #阻塞存储
```

## AOF存储方式
```plain
1: redis的appendonly存储配置
appendonly会把用户的每次写操作都记录到文件中
2: 动态开启或者关闭aof
config set appendonly yes #开启
config rewrite
config set appendonly no  #关闭
config rewrite
3: 写入数据，观察aof。多次运行，aof文件不断增大，rdb文件大小不变
for line in `seq -w 100`;do
  redis-cli set key_${line} value_${line}
done
4: 重写aof文件，整理相同的key，写入最后有效的值
BGREWRITEAOF
5: aof配置自动rewrite
auto-aof-rewrite-percentage #默认为100%，也就是增加一倍后考虑aof rewrite
auto-aof-rewrite-min-size  #默认为64mb，也就是达到64M后再rewrite。跟上一个条件要同时满足(config set auto-aof-rewrite-min-size 100000观察)
```

> 更新: 2019-03-21 09:12:42  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/av3is8>