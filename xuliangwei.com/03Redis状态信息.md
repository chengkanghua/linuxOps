# 03 Redis状态信息

# 03 Redis状态信息

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

`redis`提供一个`info`命令查看`redis`服务的运行状态信息。

1.使用`redis-cli`提供`info`命令查看

```plain
Server 表示redis服务器的信息，里面包含有启动时间等
Clients 表示redis的客户端连接信息。
Memory 表示redis的内存使用信息。
mem_fragmentation_ratio=used_memory_rss_human/used_memory_human #redis发生增加删除的动作，会引起内存碎片化
mem_allocator:jemalloc-4.0.3 #内存分配使用的库，越好的库内存碎片化率越低。低版本的建议升级
Persistence 表示redis的持久化信息，redis虽然主要用来做缓存用，但也提供数据持久化功能，也就是把数据存盘。
Stats 表示redis的一些状态信息，常用来监控
total_connections_received #一共接收了多少连接
total_commands_processed #一共运行了多个命令
total_net_input_bytes  #总流入流量
total_net_output_bytes  #总流出流量
Replication 表示redis主从状态信息
CPU  表示redis占用的cpu情况
Cluster  表示redis的集群信息
Keyspace 表示redis key的分配情况
```

2.单独查看某块信息

```plain
#只查看key
redis-cli info Keyspace
#只查看cpu信息
redis-cli info clients
```

> 更新: 2019-03-21 09:12:22  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/nqndqs>