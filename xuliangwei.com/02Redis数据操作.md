# 02 Redis数据操作

# 02 Redis数据操作
+ [Redis连接方式](http://class.xuliangwei.com/15294872154995.html#toc_0)
+ [Redis字符串操作](http://class.xuliangwei.com/15294872154995.html#toc_1)
+ [Redis列表操作](http://class.xuliangwei.com/15294872154995.html#toc_2)
+ [RedisHash操作](http://class.xuliangwei.com/15294872154995.html#toc_3)
+ [Redis发布订阅操作](http://class.xuliangwei.com/15294872154995.html#toc_4)
+ [Redis批量添加数据](http://class.xuliangwei.com/15294872154995.html#toc_5)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208
>

## Redis连接方式
```plain
redis-cli客户端
1: mysql命令用来跟Mysql服务器进行交互
2: redis-cli命令用来跟redis服务器进行交互
1: 使用redis-cli客户端可以登录到redis服务器
redis-cli #可以使用-h来指定主机，-p来指定端口。默认登录127.0.0.1的6379端口。
redis-cli -h xxx.xxx.xxx.xxx -p 6379
exit  #退出当前会话(ctrl+d)
shutdown #关闭redis服务器，命令不区分大小写
```

## Redis字符串操作
```plain
2: redis字符串操作 (set key value)
set name bgx #增加
get name   #获取
set name bgx2 #修改
del name   #删除，返回1代表删除成功
set name bgx
GET name  #命令不区分大小写
set NAME bgx
get name
get NAME  #key区分大小写
3: 非交互式方式操作redis服务器，后续写一些批量脚本
redis-cli set name bgx
redis-cli get name
redis-cli del name
```

## Redis列表操作
```plain
redis的key都是string，value支持字符串、列表、集合等
1: redis列表的操作，有序的可重复的
lpush names bgx  #增加
lpush names bgx1  #增加
lpush names bgx2
lpush names bgx3
lpush names bgx4
lpush names bgx  #增加相同的值
lpush names 6666
lrange names 0 -1   #获取全部
lrange names 0 1   #获取第一个和第二个
LREM names 1 bgx#移除一个bgx元素
LREM names 0 bgx#移除所有bgx元素
LPOP names    #后进先出
RPOP names    #先进先出
LSET names 0 bgx5 #更改第1个元素
del names
2: redis集合的操作(无序、元素不重复)
sadd ages 25 #增加
sadd ages 30
sadd ages 35
sadd ages 40
sadd ages 45
sadd ages 50
sadd ages 25 #失败，唯一
SMEMBERS ages #获取集合的所有值
srem ages 25 #移除25的元素
spop ages #随机移除元素
SISMEMBER ages 35 #ages集合中是否有35的元素
```

## RedisHash操作
```plain
1: redis hash操作
hset info name 'bgx' #增加
hset info age 20
hset info location 'shanghai'
HGETALL info    #获取所有info信息
HGET info name   #获取name值
hdel info name age   #删除，可以指定多个
del info
hmset info name 'bgx' age 25 location 'hangzhou' #增加多个值
```

## Redis发布订阅操作
```plain
2: redis的发布订阅
subscribe bgx
publish bgx 'my name is bgx'
```

## Redis批量添加数据
```plain
1: 批量往redis server上插入数据
for line in `seq -w 50`;do 
  redis-cli  set name_${line} bgx_${line}
done
2: 查看key的情况
keys *   #查看所有key的命令，不建议使用，上千万的key会使redis服务器堵塞
RANDOMKEY #随意返回一个key
SCAN 0  #可利用scan的索引取所有的key，使用程序可以循环取出key
```

> 更新: 2019-03-21 09:12:04  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/gsad0a>