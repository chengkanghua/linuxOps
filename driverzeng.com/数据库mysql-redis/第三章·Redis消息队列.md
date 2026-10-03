# 第三章· Redis消息队列

# 一.生产消费模型

<!-- OCR_START -->
- TheNiceBoyLikeMe
- driverzeng
- 生产者
- 消费者
- 消息队列
<!-- OCR_END -->

## 什么是消息队列？
在生活中，其实有很多的例子，都类似消息队列。

比如：工厂生产出来的面包，交给超市，商场来出售，客户通过超市，商场来买面包，客户不会针对某一个工厂去选择，只管从超市买出来，工厂也不会管是哪一个客户买了面包，只管生产出来之后，交给超市，商场来处理。

消息队列（Message Queue）是一种应用间的通信方式，消息发送后可以立即返回，有消息系统来确保信息的可靠专递，消息生产者只管把消息发布到MQ中而不管谁来取，消息消费者只管从MQ中取消息而不管谁发布的，这样发布者和使用者都不用知道对方的存在。

## 为什么要使用消息队列呢？
首先，我们可以知道，消息队列是一种异步的工作机制，比如说日志收集系统，为了避免数据在传输过程中丢失，还有订单系统，下单后，会生成对应的单据，库存的扣减，消费信息的发送，一个下单，产生这么多的消息，都是通过一个操作的触发，然后将其他的消息放入消息队列中，依次产生。再就是很多网站的，秒杀活动之类的，前多少名用户会便宜，都是通过消息队列来实现的。

这些例子，都是通过消息队列，来实现，业务的解耦，最终数据的一致性，广播，错峰流控等等，从而完成业务的逻辑。

## 消息队列产品
1）rabbit-MQ（最初起源于金融系统，用于分布式系统中存储转发消息。OpenStack）

2）Zero-MQ（SaltStack）

3）Kafka（JAVA）

4）redis（key:value数据库，缓存，消息队列）

# 二.Redis发布消息的两种模式
## 任务队列模式（queuing）
**任务队列：**顾名思义，就是“传递消息的队列”。与任务队列进行交互的实体有两类，一类是生产者（producer），另一类则是消费者（consumer）。生产者将需要处理的任务放入任务队列中，而消费者则不断地从任务独立中读入任务信息并执行。

> 任务队列的好处
>
> 1）松耦合。
>
> 生产者和消费者只需按照约定的任务描述格式，进行编写代码。
>
> 2）易于扩展。
>
> 多消费者模式下，消费者可以分布在多个不同的服务器中，由此降低单台服务器的负载。
>
> 
>

## 发布-订阅模式(publish-subscribe)
其实从Pub/Sub的机制来看，它更像是一个广播系统，多个订阅者（Subscriber）可以订阅多个频道（Channel），多个发布者（Publisher）可以往多个频道（Channel）中发布消息。

> 可以这么简单的理解：
>
> 1）Subscriber：收音机，可以收到多个频道，并以队列方式显示
>
> 2）Publisher：电台，可以往不同的FM频道中发消息
>
> 3）Channel：不同频率的FM频道
>

<!-- OCR_START -->
- TheNiceBoyLikeMe
- driverzeng
- FMIO3.9
- 北京交通广播
- FMI03.9
- BEIJINGCOMMUNICATIONRADIO
<!-- OCR_END -->

## 一个发布者多个订阅者模型
如下图所示，可以作为消息队列或者消息管道。

**主要应用：**通知、公告

<!-- OCR_START -->
- subscriber
- channel_1
- message
- TheNiceBoy LikeMe.
- -driverzeng
- publisher
- channel_2
<!-- OCR_END -->

## 多个发布者一个订阅者模型
可以将PubSub做成独立的HTTP接口，各应用程序作为Publisher向Channel中发送消息，Subscriber端收到消息后执行相应的业务逻辑，比如写数据库，显示等等。

**主要应用：**排行榜、投票、计数。

<!-- OCR_START -->
| publisher_1 | publisher_1 | publisher_1 | 排名 |
| --- | --- | --- | --- |
| 2 | publisher | subscriber | 1-message- |
| channel | 'message" | publisher | 4 |
| publisher_! | 5 | publisher | 6 |
<!-- OCR_END -->

## 多个发布者多个订阅者模型
故名思议，就是可以向不同的Channel中发送消息，由不同的Subscriber接收。

**主要应用：**群聊、聊天。

<!-- OCR_START -->
- publisher_1
- subscriber
- TheNiceBoyLikeMe.
- driverzeng
- publisher_2
- message
- publisher_3
- channel
- publisher_4
- publisher_5
- publisher_6
<!-- OCR_END -->

## Redis发布订阅实践
```bash
1）PUBLISH channel msg
将信息 message 发送到指定的频道 channel

2）SUBSCRIBE channel [channel ...]
订阅频道，可以同时订阅多个频道

3）UNSUBSCRIBE [channel ...]
取消订阅指定的频道, 如果不指定频道，则会取消订阅所有频道

4）PSUBSCRIBE pattern [pattern ...]
订阅一个或多个符合给定模式的频道，每个模式以 * 作为匹配符，比如 it* 匹配所  有以 it 开头的频道( it.news 、 it.blog 、 it.tweets 等等)， news.* 匹配所有  以 news. 开头的频道( news.it 、 news.global.today 等等)，诸如此类

5）PUNSUBSCRIBE [pattern [pattern ...]]
退订指定的规则, 如果没有参数则会退订所有规则

6）PUBSUB subcommand [argument [argument ...]]
查看订阅与发布系统状态

```

_**注意：**_使用发布订阅模式实现的消息队列，当有客户端订阅channel后只能收到后续发布到该频道的消息，之前发送的不会缓存，必须Provider和Consumer同时在线。

****

**订阅单个频道**

```bash
#第一个窗口
#登录Redis
[root@db01 ~]# redis-cli -a 123

#在订阅者的服务器上输入订阅zls
127.0.0.1:6379> SUBSCRIBE zls
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "zls"
3) (integer) 1

#第二个窗口
#登录Redis
[root@db01 ~]# redis-cli -a 123
#在发布者的服务器上输入信息
127.0.0.1:6379> PUBLISH zls "The Nice Boy Like Me."
(integer) 1

#第一个窗口
#在订阅者的服务器上会看到如下信息
1) "message"
2) "zls"
3) "The Nice Boy Like Me."

```

**结果如下:**

<!-- OCR_START -->
- 1. root@db01:~ (ssh)
- 127.0.0.1:6379> PUBLISH zls "The Nice Boy Like Me."
- 127.0.0.1:6379> SUBSCRIBE zls
- (integer)1
- Reading messages... (press Ctrl-C to quit)
- 127.0.0.1:6379>
- 1) "subscribe"
- 2)
- "zls"
- 3) (integer) 1
- 1)
- "message"
- "The Nice Boy Like Me."
- 3
<!-- OCR_END -->

**订阅多个频道**

```bash
#第一个窗口
#登录Redis
[root@db01 ~]# redis-cli -a 123
#在订阅者服务器上输入订阅所有频道
127.0.0.1:6379> PSUBSCRIBE *
Reading messages... (press Ctrl-C to quit)
1) "psubscribe"
2) "*"
3) (integer) 1
#第二个窗口
#在发布者服务器上输入多频道信息
127.0.0.1:6379> PUBLISH zls "The Nice Boy Like Me."
(integer) 1
127.0.0.1:6379> PUBLISH bgx "The Ugly Old Man Like Me."
(integer) 1
#第一个窗口
#在订阅者的服务器上会看到如下信息
1) "pmessage"
2) "*"
3) "zls"
4) "The Nice Boy Like Me."
1) "pmessage"
2) "*"
3) "bgx"
4) "The Ugly Old Man Like Me."
```

**结果如下:**

<!-- OCR_START -->
- 1. root@db01:~(ssh)
- root@db01:~(ssh)
- [root@db01~]#redis-cli-a 123
- 127.0.0.1:6379> PUBLISH zls "The Nice Boy Like Me."
- 127.0.0.1:6379> PSUBSCRIBE *
- (integer)1
- 127.0.0.1:6379> PUBLISH bgx "The Ugly Old Man Like Me."
- 127.0.0.1:6379>
- 3) (integer) 1
- 1) "pmessage"
- "*
- 4)
- "The Nice Boy Like Me."
- 2
- 3
- "bgx"
- "The Ugly Old Man Like Me."
<!-- OCR_END -->

## 消息队列系统对比
客户端在执行订阅命令之后进入了订阅状态，只能接收 SUBSCRIBE 、PSUBSCRIBE、 UNSUBSCRIBE 、PUNSUBSCRIBE 四个命令。 开启的订阅客户端，无法收到该频道之前的消息，因为 Redis 不会对发布的消息进行持久化。 和很多专业的消息队列系统（例如Kafka、RocketMQ、RabbitMQ）相比，Redis的发布订阅略显粗糙。

**例如:**无法实现消息堆积和回溯。但胜在足够简单，如果当前场景可以容忍的这些缺点，也不失为一个不错的选择。

> 更新: 2024-09-09 15:48:41  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/zsokhu>