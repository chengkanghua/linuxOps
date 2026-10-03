# 07 Redis API实战

# 07 Redis API实战
```plain
检查python的redis扩展
python
import redis
1: python安装操作redis扩展
yum install epel-release -y
yum install python2-pip -y
pip install redis
2: 使用python去操作redis单例
# -*- coding: utf-8 -*-
import redis
r = redis.Redis(host='10.5.96.3', port=6379, password='', db=0)
r.set('key_python','value_python')
value = r.get('key_python')
print(value)
3: 假如说php、java
4.python安装扩展用来操作redis集群
pip install redis-py-cluster
5.操作集群的代码
# -*- coding: utf-8 -*-
from rediscluster import StrictRedisCluster
redis_nodes =  [{'host':'10.5.96.3','port':7000},
                    {'host':'10.5.96.3','port':7001},
                    {'host':'10.5.96.3','port':7002},
                    {'host':'10.5.96.3','port':8000},
                    {'host':'10.5.96.3','port':8001},
                    {'host':'10.5.96.3','port':8002}
                   ]
redisconn = StrictRedisCluster(startup_nodes=redis_nodes)
redisconn.set('name100','bgx')
print(redisconn.get('name100'))
bgx
6.其中一个节点挂了，不影响功能的使用
```

需要：分析redis的key和每个key的大小

pip install rdbtools

rdb -c memory /data/redis-cluster/7000/dump.rdb >/tmp/bgx.csv

> 更新: 2019-03-21 09:13:48  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/pqpb04>