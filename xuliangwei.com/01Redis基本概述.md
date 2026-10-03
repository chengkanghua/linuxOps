# 01 Redis基本概述

# 01 Redis基本概述

* [Redis安装配置](http://class.xuliangwei.com/15294795975185.html#toc_0)
* [Redis日志处理](http://class.xuliangwei.com/15294795975185.html#toc_1)
* [Redis加密方式](http://class.xuliangwei.com/15294795975185.html#toc_2)
* [Redis禁止危险命令](http://class.xuliangwei.com/15294795975185.html#toc_3)
* [Redis最大内存设置](http://class.xuliangwei.com/15294795975185.html#toc_4)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

`redis`是一种内存型的`nosql`数据库，优点是快，通常用来做数据的缓存

`redis`存储数据的方法是以`key-value`的形式

`redis`的`key`通常都是字符串

`redis`的`value`类型支持字符串、列表、哈希等多种类型

redis下载地址 <https://redis.io/download>

## Redis安装配置

1.关闭防火墙

```plain
systemctl stop firewalld; systemctl disable firewalld
```

2.安装基础依赖包

```plain
yum install -y wget gcc gcc-c++ make tar openssl openssl-devel cmake
```

3.源码编译redis

```plain
cd /usr/local/src
wget 'http://download.redis.io/releases/redis-4.0.9.tar.gz'
tar -zxf redis-4.0.9.tar.gz
cd redis-4.0.9
make #make完后会生成可运行的二进制包，这些包直接拷贝就能够使用
```

4.安装后基础优化

```plain
# redis安装在/usr/local/redis里面
mkdir -pv /usr/local/redis/conf /usr/local/redis/bin
cp src/redis-* /usr/local/redis/bin/  #拷贝常用的二进制文件
\rm /usr/local/redis/bin/*.c  /usr/local/redis/bin/*.o
cp redis.conf /usr/local/redis/conf/  #拷贝配置文件
# 验证和软链接的建立
/usr/local/redis/bin/redis-server --version
/usr/local/redis/bin/redis-cli --version
ln -s /usr/local/redis/bin/redis-cli /usr/local/bin/  #由于redis客户端经常使用，做个软链接
redis-cli --version
```

5.调整`redis`相关配置信息

```plain
vim /usr/local/redis/conf/redis.conf
bind 127.0.0.1 192.168.56.11  #监听地址更改，0.0.0.0代表监控所有网卡
port 6379       #监听端口，默认6379
daemonize yes   #后台启用
pidfile /data/redis/redis.pid   #pid存放目录
logfile "/data/redis/redis.log" #日志存放目录
dir /data/redis/    #数据目录
```

6.`redis`服务器启动和关闭

```plain
/usr/local/redis/bin/redis-server /usr/local/redis/conf/redis.conf #启动redis服务器
redis-cli
SHUTDOWN  #关闭redis服务器
```

## Redis日志处理

由于系统没有进行初始化和优化，在安装并启动redis后，日志中会提示相应的警告信息，建议按如下方式进行调整，并后续出现类似的问题。

```plain
vim /etc/security/limits.conf
* soft nofile 65535
* hard nofile 65535
3.允许内核分配所有的物理内存，而不管当前的内存状态如何
sysctl vm.overcommit_memory=1
4.每个tcp端口最大的监听队列的长度
sysctl net.core.somaxconn=10240
# vi /etc/rc.local  
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then  
   echo never > /sys/kernel/mm/transparent_hugepage/enabled  
fi  
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then  
   echo never > /sys/kernel/mm/transparent_hugepage/defrag  
fi
5: 删除日志再启动一下redis，然后再观察redis服务器
\rm /data/redis/redis.log
/usr/local/redis/bin/redis-server /usr/local/redis/conf/redis.conf
```

## Redis加密方式

1.修改`Redis`配置文件

```plain
vim /usr/local/redis/conf/redis.conf
requirepass 'bgx'
systemctl restart redis-server
加密redis的操作方法
redis-cli 登录进去以后auth 'bgx'
redis-cli -a 'bgx' info 非交互式的操作
```

2.无需重启redis加密方式

```plain
auth 'bgx' #加完密码后，需要使用auth去认证才能操作redis服务器
config get requirepass #获取指定配置
config set requirepass '' #无需重启redis服务器将密码置为空，平滑更新配置(临时)
config rewrite   #平常更新配置完后需要写入到配置文件，预防重启后配置失效(临时配置刷新)
config set requirepass 'bgx' #重新设置密码
```

## Redis禁止危险命令

```plain
1: redis禁用命令
FLUSHALL和FLUSHDB会清除redis的数据，比较危险
KEYS在键过多的时候使用会阻塞业务请求
config会引起攻击
2: redis禁用危险命令的配置如下，粘贴到配置文件里面，重启redis服务器。此配置无法平滑的更新
rename-command FLUSHALL ""
rename-command FLUSHDB ""
rename-command KEYS ""
3: 登录redis，运行禁止的命令，会提示失败
127.0.0.1:6379> FLUSHALL
(error) ERR unknown command 'FLUSHALL'
4.建议Redis监听在本地内网地址，同时增加密码，可大大的减少被攻击
```

## Redis最大内存设置

```plain
redis可以设置最大内存和达到最大内存的删除算法。
清空redis的所有内容
FLUSHALL
1: redis的键设置有效期，过期自动删除
set name bgx
ttl name    #默认不超期，值为-1
expire name 10  #10s后会被删除
ttl name
2: 查看设置最大内存
config get maxmemory #默认无限制，值为0
config set maxmemory 1m #设置最大使用1m内存
config get maxmemory-policy #默认使用noeviction
3: 可选择的删除算法
volatile-lru   使用LRU算法删除键（key需要设置过期时间）
volatile-random 随机删除键（key需要设置过期时间）
volatile-ttl   删除ttl最小的键（key需要设置过期时间）
allkeys-lru  使用LRU算法删除键(所有key)
allkeys-random 随机删除键(所有key)
noeviction  不进行任何的操作，只返回错误，默认
4: 模拟超过内存
for line in `seq -w 1000`;do
  redis-cli set key_${line} value__${line}
done
5: 设置删除算法
config set maxmemory-policy volatile-random   #超过最大内存，设置了ttl的使用lru算法删除
redis-cli expire key_${line} 3600    #尝试一下设置key的过期时间
config set maxmemory-policy allkeys-random    #随机删除，set不会出错，但会随机删除
```

> 更新: 2019-03-21 09:11:40  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/giclcy>