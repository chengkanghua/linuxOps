# 第一章· Redis入门部署及持久化介绍

## Redis简介
| 软件说明 |
| :--- |

Redis是一款开源的，ANSI C语言编写的，高级键值(key-value)缓存和支持永久存储NoSQL数据库产品。

Redis采用内存(In-Memory)数据集(DataSet) 。

支持多种数据类型。

运行于大多数POSIX系统，如Linux、*BSD、OS X等。

作者： Salvatore Sanfilippo

---

| 软件特性 |
| :--- |

+ 1）透明性：分布式系统对用户来说是透明的，一个分布式系统在用户面前的表现就像一个传统的单处理机分时系统，可让用户不必了解内部结构就可以使用。
+ 2）扩展性：分布式系统的最大特点就是可扩展性，他可以根据需求的增加而扩展，可以通过横向扩展使集群的整体性能得到线性提升，也可以通过纵向扩展单台服务器的性能使服务器集群的性能得到提升。
+ 3）可靠性：分布式系统不允许单点失效的问题存在，它的基本思想是：如果一台服务器坏了，其他服务器接替它的工作，具有持续服务的特性。
+ 4）高性能：高性能是人们设计分布式系统的一个初衷，如果建立了一个透明，灵活，可靠的分布式系统，但他运行起来像蜗牛一样慢，那这个系统就是失败的。

---

| 软件获取和帮助 |
| :--- |

+ 官方网站：[https://redis.io/](https://redis.io/)
+ 下载网站：[http://download.redis.io/releases/](http://download.redis.io/releases/)
+ 帮助网站：[http://redisdoc.com/](http://redisdoc.com/)

---

| 软件功能 |
| :--- |

1）高速读写

2）数据类型丰富

3）支持持久化

4）多种内存分配及回收策略

5）支持事物

6）消息队列、消息订阅

7）支持高可用

8）支持分布式分片集群

---

| 企业缓存数据库解决方案对比 |
| :--- |

> Memcached:
>
> 1)优点：高性能读写、单一数据类型、支持客户端式分布式集群、一致性hash多核结构、多线程读写性能高。
>
> 2)缺点：无持久化、节点故障可能出现缓存穿透、分布式需要客户端实现、跨机房数据同步困难、架构扩容复杂度高
>

---

> Redis:
>
> 1)优点：高性能读写、多数据类型支持、数据持久化、高可用架构、支持自定义虚拟内存、支持分布式分片集群、单线程读写性能极高
>
> 2)缺点：多线程读写较Memcached慢
>

---

> Tair：
>
> 1)优点：高性能读写、支持三种存储引擎（ddb、rdb、ldb）、支持高可用、支持分布式分片集群、支撑了几乎所有淘宝业务的缓存。
>
> 2)缺点：单机情况下，读写性能较其他两种产品较慢
>

---

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 排名 |
| --- | --- | --- | --- |
| 单线程写入测试 | 125 | 1次写入 | 25 |
| 146 | 540 | 500次写入 | 178 |
| 432 | 1680 | 2000次写入 | 570 |
| 1186 | 250 | 500 | 750 |
| 1000 | 1250 | 1500 | 1750 |
| 200( | 消耗时间（毫秒） | Memcached | Redis |
<!-- OCR_END -->

 

图1·memcached、redis、tair单线程写入对比图

---

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 排名 |
| --- | --- | --- | --- |
| 单线程读取测试 | 175 | 1次读取 | 54 |
| 195 | 640 | 500次读取 | 208 |
| 468 | 1838 | 2000次读取 | 659 |
| 1242 | 250 | 500 | 750 |
| 1000 | 1250 | 1500 | 1750 |
| 200( | 消耗时间（毫秒） | Memcached | Redis |
<!-- OCR_END -->

图2·memcached、redis、tair单线程读取对比图

---

<!-- OCR_START -->
| 名称 | 排名 | 排名(上年) | 排名(上年) | 名称 |
| --- | --- | --- | --- | --- |
| 多线程写入测试 | 180 | 500个线程1次写入 | 189 | 456 |
| 500个线程5次写入 | 410 | 496 | 582 | 2000个线程1次写入 |
| 526 | 423 | 100 | 200 | 300 |
| 400 | 500 | 600 | 700 | 消耗时间（毫秒） |
| Memcached | Redis | Tair | https://www.driverzeng.com | Highcharts.com |
<!-- OCR_END -->

图3·memcached、redis、tair多线程写入对比图

---

<!-- OCR_START -->
| 排名 | 排名(上年) | 名称 | 排名(上年) |
| --- | --- | --- | --- |
| 多线程读取测试 | 240 | 500个线程1次读取 | 78 |
| 158 | 634 | 500个线程5次读取 | 412 |
| 551 | 617 | 2000个线程1次读取 | 537 |
| 477 | 100 | 200 | 300 |
| 400 | 500 | 600 | 700 |
| 消耗时间（毫秒） | Memcached | Redis | Tair |
<!-- OCR_END -->

图4·memcached、redis、tair多线程读取对比图

| 对比结论 |
| :--- |

+ 1.Memcached：多核的缓存服务，更加适合于多用户并发访问次数（访问次数较少的应用场景）。
+ 2.Redis：单核缓存服务，在单节点情况下，更加适合少量用户，多次访问的应用场景。

**redis一般在企业中，是单机多实例架构**

## Redis安装部署
```bash
 
# 安装依赖包
yum install -y ncurses-devel libaio-devel cmake  gcc-c++ 
#yum -y install gcc automake autoconf libtool make

#下载
wget http://download.redis.io/releases/redis-3.2.12.tar.gz
#解压
tar xf redis-3.2.12.tar.gz
#移动到指定目录
mkdir /application -p
mv redis-3.2.12 /application/
#做软链接
ln -s /application/redis-3.2.12 /application/redis
#进入redis目录
cd /application/redis
#编译
make
#解决“jemalloc/jemalloc.h：没有那个文件或目录“问题，在进行编译（因为上次编译失败，有残留的文件）
#[root@bogon redis-3.2.0]# make distclean
#[root@bogon redis-3.2.0]# make && make install

#添加环境变量
echo 'export PATH="/application/redis/src:$PATH"' > /etc/profile.d/redis.sh
source /etc/profile

#启动redis
src/redis-server &
#连接redis
#redis-cli
#退出redis
#127.0.0.1:6379> quit
#关闭redis服务
# redis-cli
127.0.0.1:6379> shutdown

# 基本配置
#创建redis工作目录
mkdir -p /etc/redis/6379
#创建redis配置文件
cat > /etc/redis/6379/redis.conf <<EOF
daemonize yes
port 6379
logfile /etc/redis/6379/redis.log
dir /etc/redis/6379
dbfilename dump.rdb
#指定ip地址监听 #修改为本地ip
bind 127.0.0.1 10.0.0.4
#认证密码
requirepass ckh
EOF

#指定配置文件启动redis
redis-server /etc/redis/6379/redis.conf

```

---

| redis基本配置说明 |
| :--- |

```bash
#创建redis工作目录
[root@db01 redis]# mkdir -p /etc/redis/6379
#创建redis配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
daemonize yes   //守护进程模式启动
port 6379       //端口
logfile /etc/redis/6379/redis.log   //日志文件位置
dir /etc/redis/6379      //持久化数据文件存储位置
dbfilename dump.rdb     //RDB持久化数据文件名称
#指定配置文件启动redis
[root@db01 redis]# redis-server /etc/redis/6379/redis.conf

```

| redis基本操作 |
| :--- |

```bash
#连接redis
[root@db01 redis]# redis-cli
127.0.0.1:6379> auth ckh

#设置键值对
127.0.0.1:6379> set foo bar
OK
#取出值
127.0.0.1:6379> get foo
"bar"
```

| redis安全配置 |
| :--- |

+ **protected-mode：** 禁止protected-mode yes/no （保护模式，是否只允许本地访问）
+ **bind：**指定IP进行监听

```bash
#添加到配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
bind 127.0.0.1 10.0.0.51

```

+ **requirepass：** 增加密码

```bash
#添加配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
requirepass  ckh

```

+ **auth {password}：** 在redis-cli中使用，进行认证

```bash
#不加认证，报错
[root@db01 redis]# redis-cli
127.0.0.1:6379> set name zhangsan
(error) NOAUTH Authentication required.
#连接方式1
[root@db01 redis]# redis-cli
127.0.0.1:6379> AUTH ckh
127.0.0.1:6379> set name zhangsan
OK
#连接方式2
[root@db01 redis]# redis-cli -a ckh
127.0.0.1:6379> set name lisi
OK

```

---

| redis在线查看和修改配置 |
| :--- |

```bash
#查看配置文件中的监听地址
127.0.0.1:6379> CONFIG GET bind
1) "bind"
2) "127.0.0.1 10.0.0.51"
#查看dir
127.0.0.1:6379> CONFIG GET dir
1) "dir"
2) "/etc/redis/6379"
#查看所有配置
127.0.0.1:6379> CONFIG GET *
#修改配置，即时生效
127.0.0.1:6379> CONFIG SET requirepass 123
OK
#测试修改后连接
[root@db01 redis]# redis-cli -a 123
127.0.0.1:6379> set age 18
OK
#查看配置文件
[root@db01 redis]# cat /etc/redis/6379/redis.conf
daemonize yes
port 6379
logfile /etc/redis/6379/redis.log
dir /etc/redis/6379
dbfilename dump.rdb
bind 127.0.0.1 10.0.0.51
requirepass  ckh        # 可以看出，配置文件中是没有改变的，只要redis不重启，密码就是新改的
```

## Redis持久化
**什么是持久化？**

**持久化：**就是将内存中的数据，写入到磁盘上，并且永久存在的。

| RDB 持久化介绍 |
| :--- |

可以在指定的时间间隔内生成数据集的时间点快照（point-in-time snapshot）。

**RDB持久化优点:**

+ 1）RDB是一种表示某个即时点的Redis数据的紧凑文件。RDB文件适合用于备份。例如，你可能想要每小时归档最近24小时的RDB文件，每天保存近30天的RDB快照。这允许你很容易的恢复不同版本的数据集以容灾。
+ 2）RDB非常适合于灾难恢复，作为一个紧凑的单一文件，可以被传输到远程的数据中心。
+ 3）RDB最大化了Redis的性能，因为Redis父进程持久化时唯一需要做的是启动(fork)一个子进程，由子进程完成所有剩余工作。父进程实例不需要执行像磁盘IO这样的操作。
+ 4）RDB在重启保存了大数据集的实例时比AOF要快。

**RDB持久化缺点**

+ 1）当你需要在Redis停止工作(例如停电)时最小化数据丢失，RDB可能不太好。你可以配置不同的保存点(save point)来保存RDB文件(例如，至少5分钟和对数据集100次写之后，但是你可以有多个保存点)。然而，你通常每隔5分钟或更久创建一个RDB快照，所以一旦Redis因为任何原因没有正确关闭而停止工作，你就得做好最近几分钟数据丢失的准备了。
+ 2）RDB需要经常调用fork()子进程来持久化到磁盘。如果数据集很大的话，fork()比较耗时，结果就是，当数据集非常大并且CPU性能不够强大的话，Redis会停止服务客户端几毫秒甚至一秒。AOF也需要fork()，但是你可以调整多久频率重写日志而不会有损(trade-off)持久性(durability)。

**RDB持久化优缺点总结**

+ 优点：速度快，适合于用作备份，主从复制也是基于RDB持久化功能实现的。
+ 缺点：会有数据丢失、导致服务停止几秒

**RDB持久化核心配置参数**

```bash
#编辑配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
#持久化数据文件存储位置
dir /etc/redis/6379
#rdb持久化数据文件名
dbfilename dump.rdb
#900秒（15分钟）内有1个更改
save 900 1
#300秒（5分钟）内有10个更改
save 300 10
#60秒（1分钟）内有10000个更改
save 60 10000
```

| AOF 持久化介绍 |
| :--- |

AOF（append only file）只追加文件，记录服务器执行的所有写操作命令，并在服务器启动时，通过重新执行这些命令来还原数据集。 AOF 文件中的命令全部以 Redis 协议的格式来保存，新命令会被追加到文件的末尾。

**AOF持久化优点:**

+ 1）使用AOF Redis会更具有可持久性(durable)：你可以有很多不同的fsync策略：没有fsync，每秒fsync，每次请求时fsync。使用默认的每秒fsync策略，写性能也仍然很不错(fsync是由后台线程完成的，主线程继续努力地执行写请求)，即便你也就仅仅只损失一秒钟的写数据。
+ 2）AOF日志是一个追加文件，所以不需要定位，在断电时也没有损坏问题。即使由于某种原因文件末尾是一个写到一半的命令(磁盘满或者其他原因),redis-check-aof工具也可以很轻易的修复。
+ 3）当AOF文件变得很大时，Redis会自动在后台进行重写。重写是绝对安全的，因为Redis继续往旧的文件中追加，使用创建当前数据集所需的最小操作集合来创建一个全新的文件，一旦第二个文件创建完毕，Redis就会切换这两个文件，并开始往新文件追加。
+ 4）AOF文件里面包含一个接一个的操作，以易于理解和解析的格式存储。你也可以轻易的导出一个AOF文件。例如，即使你不小心错误地使用FLUSHALL命令清空一切，如果此时并没有执行重写，你仍然可以保存你的数据集，你只要停止服务器，删除最后一条命令，然后重启Redis就可以。

**AOF持久化缺点:**

+ 1）对同样的数据集，AOF文件通常要大于等价的RDB文件。
+ 2）AOF可能比RDB慢，这取决于准确的fsync策略。通常fsync设置为每秒一次的话性能仍然很高，如果关闭fsync，即使在很高的负载下也和RDB一样的快。不过，即使在很大的写负载情况下，RDB还是能提供能好的最大延迟保证。
+ 3）在过去，我们经历了一些针对特殊命令(例如，像BRPOPLPUSH这样的阻塞命令)的罕见bug，导致在数据加载时无法恢复到保存时的样子。这些bug很罕见，我们也在测试套件中进行了测试，自动随机创造复杂的数据集，然后加载它们以检查一切是否正常，但是，这类bug几乎不可能出现在RDB持久化中。为了说得更清楚一点：Redis AOF是通过递增地更新一个已经存在的状态，像MySQL或者MongoDB一样，而RDB快照是一次又一次地从头开始创造一切，概念上更健壮。但是，

         1)要注意Redis每次重写AOF时都是以当前数据集中的真实数据从头开始，相对于一直追加的AOF文件(或者一次重写读取老的AOF文件而不是读内存中的数据)对bug的免疫力更强。

         2)我们还没有收到一份用户在真实世界中检测到崩溃的报告。

**AOF持久化优缺点总结**

+ 优点：可以最大程度保证数据不丢失
+ 缺点：日志记录量级比较大

**AOF持久化核心配置参数**

```bash
#修改配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
#是否打开AOF日志功能
appendonly yes/no
#每一条命令都立即同步到AOF
appendfsync always
#每秒写一次
appendfsync everysec
#写入工作交给操作系统,由操作系统判断缓冲区大小,统一写入到AOF
appendfsync no
```

---

| RDB 和 AOF ,我应该用哪一个？ |
| :--- |

1）一般来说,如果想达到足以媲美 PostgreSQL 的数据安全性， 你应该同时使用两种持久化功能。

2）如果你非常关心你的数据,但仍然可以承受数分钟以内的数据丢失， 那么你可以只使用 RDB 持久化。

3）有很多用户单独使用AOF，但是我们并不鼓励这样，因为时常进行RDB快照非常方便于数据库备份，启动速度也较之快，还避免了AOF引擎的bug。

4）个人感触：在企业中，通常都使用RDB来做持久化，因为一般redis是在做MySQL的缓存，就算缓存数据丢失，真实的数据还是在MySQL中，之所以用缓存是为了速度，性能而考虑，所以还是建议使用RDB持久化，相对来说会好一些，除非专门用redis来做一个key：value的数据库，而且数据很重要，那么可以考虑使用AOF

**注意：基于这些原因，将来我们可能会统一AOF和RDB为一种单一的持久化模型(长远计划)。**

---

| RDB快照的工作方式 |
| :--- |

1）默认情况下，Redis保存数据集快照到磁盘，名为dump.rdb的二进制文件。你可以设置让Redis在N秒内至少有M次数据集改动时保存数据集，或者你也可以手动调用SAVE或者BGSAVE命令。

2）在上文中我们已经在配置文件中做过对应的配置：

例如，这个配置会让Redis在每个60秒内至少有1000次键改动时自动转储数据集到磁盘：

save 60 1000

3）当 Redis 需要保存 dump.rdb 文件时，服务器执行以下操作：

+ Redis 调用 fork() ，同时拥有父进程和子进程。
+ 子进程将数据集写入到一个临时的 RDB 文件中。当子进程完成对新 RDB 文件的写入时， Redis 用新RDB 文件替换原来的 RDB 文件，并删除旧的 RDB 文件。

4）这种方式使得 Redis 可以从写时复制机制中获益。

| AOF重写功能介绍 |
| :--- |

1）因为 AOF 的运作方式是不断地将命令追加到文件的末尾，所以随着写入命令的不断增加， AOF 文件的体积也变得越来越大。举个例子，如果你对一个计数器调用了 100 次 INCR ，那么仅仅是为了保存这个计数器的当前值， AOF 文件就需要使用 100 条记录。然而在实际上，只使用一条 SET 命令已经足以保存计数器的当前值了，其余 99 条记录实际上都是多余的。

2）为了处理这种情况， Redis 支持一种有趣的特性：可以在不断服务客户端的情况下，对 AOF 文件进行重建。执行 BGREWRITEAOF 命令， Redis 将生产一个新的 AOF 文件，这个文件包含重建当前数据集所需的最少命令。

| AOF有多持久？ |
| :--- |

你可以配置 Redis 多久才将数据 fsync 到磁盘一次。

有三个选项：

+ 每次有新命令追加到 AOF 文件时就执行一次 fsync ：非常慢，也非常安全。
+ 每秒 fsync 一次：足够快（和使用 RDB 持久化差不多，）并且在故障时只会丢失1秒钟的数据。
+ 从不 fsync ：将数据交给操作系统来处理。更快，也更不安全的选择。

推荐（并且也是默认）的措施为每秒 fsync 一次，这种 fsync 策略可以兼顾速度和安全性。

总是 fsync 的策略在实际使用中非常慢，即使在 Redis2.0 对相关的程序进行了改进之后仍是如此。频繁调用 fsync 注定了这种策略不可能快得起来。

---

| 如果 AOF 文件出错了，怎么办？ |
| :--- |

服务器可能在程序正在对AOF文件进行写入时停机，如果停机造成了AOF文件出错，那么 Redis 在重启时会拒绝载入这个 AOF 文件，从而确保数据的一致性不会被破坏。

当发生 AOF 文件出错时，可以用以下方法来修复出错的 AOF 文件：

+ 1、为现有的 AOF 文件创建一个备份。
+ 2、使用 Redis 附带的 redis-check-aof 程序，对原来的AOF 文件进行修复。redis-check-aof --fix
+ 3、使用 diff -u 对比修复后的 AOF 文件和原始 AOF 文件的备份，查看两个文件之间的不同之处。
+ 4、重启 Redis 服务器，等待服务器载入修复后的 AOF 文件，并进行数据恢复。

| RDB 和 AOF 之间的相互作用 |
| :--- |

+ 1）在版本号大于等于 2.4 的 Redis 中， BGSAVE 执行的过程中，不可以执行 BGRWRITEAOF 。 反过来说，在 BGRWRITEAOF 执行的过程中，也不可以执行 BGSAVE 。
+ 2）这可以防止两个 Redis 后台进程同时对磁盘进行大量的 I/O 操作。如果 BGSAVE 正在执行，并且用户显示地调用 BGRWRITEAOF 命令，那么服务器将向用户回复一个 OK 状态，并告知用户， BGRWRITEAOF 已经被预定执行； 一旦 BGSAVE 执行完毕， BGRWRITEAOF 就会正式开始。
+ 3）当 Redis 启动时，如果 RDB 持久化和 AOF 持久化都被打开了，那么程序会优先使用 AOF 文件来恢复数据集，因为 AOF 文件所保存的数据通常是最完整的。

| 备份 Redis 数据 |
| :--- |

1）Redis 对于数据备份是非常友好的，因为你可以在服务器运行的时候对 RDB 文件进行复制： RDB 文件一旦被创建，就不会进行任何修改。

2）当服务器要创建一个新的 RDB 文件时，它先将文件的内容保存在一个临时文件里面，当临时文件写入完毕时，程序才使用临时文件替换原来的 RDB 文件。

3）这也就是说，无论何时， 复制 RDB 文件都是绝对安全的。

以下是我们的建议：

1）创建一个定期任务（cron job）， 每小时将一个 RDB 文件备份到一个文件夹， 并且每天将一个 RDB 文件备份到另一个文件夹。

2）确保快照的备份都带有相应的日期和时间信息， 每次执行定期任务脚本时， 使用 find 命令来删除过期的快照： 比如说， 你可以保留最近 48 小时内的每小时快照， 还可以保留最近一两个月的每日快照。

3）至少每天一次， 将 RDB 备份到你的数据中心之外， 或者至少是备份到你运行 Redis 服务器的物理机器之外。

| RDB持久化高级配置 |
| :--- |

```bash
#编辑配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
#后台备份进程出错时,主进程停不停止写入? 主进程不停止容易造成数据不一致
stop-writes-on-bgsave-error yes
#导出的rdb文件是否压缩 如果rdb的大小很大的话建议这么做
rdbcompression yes 
#导入rbd恢复时数据时,要不要检验rdb的完整性 验证版本是不是一致
rdbchecksum yes
```

| AOF持久化高级配置 |
| :--- |

```bash
#编辑配置文件
[root@db01 redis]# vim /etc/redis/6379/redis.conf
#正在导出rdb快照的过程中,要不要停止同步aof
no-appendfsync-on-rewrite yes/no
#aof文件大小比起上次重写时的大小,增长率100%时重写,缺点:业务开始的时候，会重复重写多次
auto-aof-rewrite-percentage 100
#aof文件,至少超过64M时,重写
auto-aof-rewrite-min-size 64mb
```

> 更新: 2024-09-09 15:35:51  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/vzzhcg>