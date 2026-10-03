# 第十章· Logstash深入-Logstash与Redis那点事

## Logstash将日志写入Redis

### 为什么要使用Redis

在企业中，日志规模的量级远远超出我们的想象，这就是为什么会有一家公司`日志易`专门做日志收集，给大型金融公司收集日志，比如银行，因为你有可能看到，1秒钟好几千万的日志量，往服务器写入，那么企业中的集群，架构都不是单台的，而是多台的，一台如果是1千万，那么5台的量级，10台的量级，我们要对他们进行收集，进行分析，难免会在网络传输过程中，丢数据。

日志是什么？

日志对于企业来说，有什么作用？

用户使用我们的产品，体验如何？

用户的客诉，我们能拿出什么样的数据来说话？

...

一系列的问题，都和日志相关，如果至关重要的那个数据丢失了，那么公司的损失可不仅仅是一条日志那么简单。如果我们不知道，用户对我们产品最感兴趣的地方在哪，那么产品的寿命也就越来越短。如果被攻击了，恶意攻击的IP源我们都找不到，那么或许就不是产品的寿命越来越短，而是这个企业存在的寿命，越来越短。

好吧，一顿排比句，说的那么浮夸，说白了，我就是想要告诉你们，一个大规模日志量级的企业想要做到数据的安全性，数据的一致性，我们需要消息队列：`Redis` , `Kafka`，在ELK5版本中，建议使用`Redis`来做消息队列，`Kafka`能不能用？也能，只不过会有一些不必要的坑，需要我们去爬。在ELK6版本中，开始使用`Kafka`来做消息队列。

话不多说，我们接下来就开始将Logstash收集到的日志，输出到Redis中。

### Redis部署

```bash
yum install -y ncurses-devel libaio-devel cmake  gcc-c++ 
#下载
wget http://download.redis.io/releases/redis-3.2.12.tar.gz
#解压
tar xf redis-3.2.12.tar.gz
#移动到指定目录
mkdir -p /application/
mv redis-3.2.12 /application/
#做软链接
ln -s /application/redis-3.2.12 /application/redis
#进入redis目录
cd /application/redis
#编译
 make
 
#添加环境变量
echo 'export PATH="/application/redis/src:$PATH"' > /etc/profile.d/redis.sh
source /etc/profile
#创建配置文件存放目录
 mkdir -p /data/6379
#编辑redis配置文件
cat > /data/6379/redis.conf <<EOF
port 6379
daemonize yes
pidfile /data/6379/redis.pid
logfile /data/6379/redis.log
dbfilename dump.rdb
dir /data/6379
protected-mode no
requirepass  zls
EOF
#启动redis
[root@db04 ~]# redis-server -c /data/6379/redis.conf
```

***

### Logstash收集日志输出至Redis

```bash
#进入Logstash配置文件目录
[root@elkstack03 ~]# cd /etc/logstash/conf.d/
#编辑Logstash配置文件
[root@elkstack03 conf.d]# vim /etc/logstash/conf.d/log_to_redis.conf
input {
  file {
    path => "/usr/local/tomcat/logs/tomcat_access_log.*.log"
    start_position => "end"
    type => "tc"
  }
  file {
    path => "/usr/local/nginx/logs/access_json.log"
    start_position => "end"
    type => "ngx"
    codec => json
  }
}
output {
  if [type] == "tc" {
    redis {
      data_type => "list"
      key => "tomcat_log"
      host => "10.0.0.54"
      port => "6379"
      db => "0"
      password => "zls"
   }
}
  if [type] == "ngx" {
    redis {
      data_type => "list"
      key => "nginx_log"
      host => "10.0.0.54"
      port => "6379"
      db => "1"
      password => "zls"
    }
  }
}
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/log_to_redis.conf &
```

***

### 验证Redis数据

```bash
#连接redis
[root@elkstack04 ~]# redis-cli -a zls
#在0库中查看所有key
127.0.0.1:6379> KEYS *
1) "tomcat_log"
#查看tomcat_log的长度（日志的条数）
127.0.0.1:6379> LLEN tomcat_log
(integer) 8
#切换1库
127.0.0.1:6379> SELECT 1
OK
#在1库中查看所有key
127.0.0.1:6379[1]> KEYS *
1) "nginx_log"
#查看nginx_log的长度（日志的条数）
127.0.0.1:6379[1]> LLEN nginx_log
(integer) 6
#演示Logstash如何取走一条tomcat日志
127.0.0.1:6379> LPOP tomcat_log
"{\"path\":\"/usr/local/tomcat/logs/tomcat_access_log.2019-04-08.log\",\"@timestamp\":\"2019-04-08T13:43:35.779Z\",\"@version\":\"1\",\"host\":\"0.0.0.0\",\"message\":\"{\\\"clientip\\\":\\\"10.0.0.53\\\",\\\"ClientUser\\\":\\\"-\\\",\\\"authenticated\\\":\\\"-\\\",\\\"AccessTime\\\":\\\"[08/Apr/2019:21:43:34 +0800]\\\",\\\"method\\\":\\\"GET / HTTP/1.1\\\",\\\"status\\\":\\\"304\\\",\\\"SendBytes\\\":\\\"-\\\",\\\"Query?string\\\":\\\"\\\",\\\"partner\\\":\\\"-\\\",\\\"AgentVersion\\\":\\\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36\\\"}\",\"type\":\"tc\"}"
#再次查看长度
127.0.0.1:6379> Llen tomcat_log
(integer) 7
#演示Logstash如何取走一条nginx日志
127.0.0.1:6379[1]> LPOP nginx_log
"{\"referer\":\"-\",\"type\":\"ngx\",\"http_host\":\"www.elk.com\",\"url\":\"/index.html\",\"path\":\"/usr/local/nginx/logs/access_json.log\",\"upstreamhost\":\"-\",\"@timestamp\":\"2019-04-08T13:43:19.000Z\",\"size\":0,\"clientip\":\"10.0.0.53\",\"domain\":\"www.elk.com\",\"host\":\"10.0.0.53\",\"@version\":\"1\",\"responsetime\":0.0,\"xff\":\"10.0.0.1\",\"upstreamtime\":\"-\",\"status\":\"304\"}"
#再次查看长度
127.0.0.1:6379[1]> LLEN nginx_log
(integer) 5
```

<!-- OCR_START -->
127.0.0.1:6379>KEYS
1)"tomcat_log"
127.0.0.1:6379>SELECT1
OK
127.0.0.1:6379[1]>KEYS*
1)"nginx_log”
127.0.0.1:6379[1]>LLENnginx_log
(integer)6
127.0.0.1:6379[1]>select0
127.0.0.1:6379>LLENtomcat_log
(integer）8
127.0.0.1:6379>LPOPtomcat_log
‘\"path\":\"/usr/Local/tomcat/logs/tomcat_access_log.2019-04-08.log\",\"@timestamp\":\"2019-04-08T13:43:35.779z\",\"@version\":\"1\",\"host\":\"0.0.0.0\",\"message\":\"{\1\"clientip\\\":\\\"10.
authenticated\11":111"-111",111"AccessTime111":111"[08/Apr/2019:21:43:34+0800]\11",111"method\11":111"GET/HTTP/1.1111",111"status\11":111"304\11",\11"SendBytes\11":111"-111",111"Query?string\
gentVersion\\\":\\\"Mozilla/5.0(Macintosh;IntelMac0SX10_14_1)AppleWebKit/537.36（KHTML，likeGecko)Chrome/73.0.3683.86Safari/537.36\\\"3\",\"type\":\"tc\"}"
127.0.0.1:6379[1]>LPOP nginx_log
‘{\"referer\":\"-\",\"type\":\"ngx\",\"http_host\":\"www.elk.com\",\"url\":\"/index.html\",\"path\":\"/usr/local/nginx/logs/access_json.log\",\"upstreamhost\":\"-\",\"@timestamp\":\"2019-04-08T13
0.0.53\",\"domain\":\"www.elk.com\",\"host\":\"10.0.0.53\",\"@version\":\"1\",\"responsetime\":0.0,\"xff\":\"10.0.0.1\",\"upstreamtime\":\"-\",\"status\":\"304\")"
(integer)5
(integer)7
<!-- OCR_END -->

***

### Logstash从Redis中取出日志输出到ES

```bash
#进入Logstash配置文件目录
[root@elkstack03 ~]# cd /etc/logstash/conf.d/
#编辑Logstash配置文件
[root@elkstack03 conf.d]# vim /etc/logstash/conf.d/redis_to_es.conf
input {
  redis {
    data_type => "list"
    key => "tomcat_log"
    host => "10.0.0.54"
    port => "6379"
    db => "0"
    password => "zls"
    codec => "json"
  }
  redis {
    data_type => "list"
    key => "nginx_log"
    host => "10.0.0.54"
    port => "6379"
    db => "1"
    password => "zls"
    codec => "json"
  }
}
output {
  if [type] == "tc" {
    elasticsearch {
      hosts => ["10.0.0.51:9200"]
      index => "m.elk.com-%{+YYYY.MM.dd}"
  }
}
  if [type] == "ngx" {
    elasticsearch {
      hosts => ["10.0.0.51:9200"]
      index => "www.elk.com-%{+YYYY.MM.dd}"
    }
  }
}
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/redis_to_es.conf &
```

***

### 验证Logstash中的数据是否被取出

```bash
#连接Redis
[root@elkstack04 ~]# redis-cli -a zls
#查看所有key
127.0.0.1:6379> KEYS *
(empty list or set)
#切换1库
127.0.0.1:6379> SELECT 1
OK
#查看所有key
127.0.0.1:6379[1]> KEYS *
(empty list or set)
```

<!-- OCR_START -->
[root@elkstack04~]#redis-cli-azls
127.0.0.1:6379>KEYS*
（error）ERRunknown commandKEYS*
1)"tomcat_log"
127.0.0.1:6379>SELECT 1
OK
127.0.0.1:6379[1]>KEYS*
1)"nginx_log
127.0.0.1:6379[1]>LLENnginx_log
(integer)6
127.0.0.1:6379[1]>select0
127.0.0.1:6379>LLEN tomcat_log
(integer）8
127.0.0.1:6379>LPOPtomcat_log
'\"path\":\"/usr/local/tomcat/logs/tomcat_access_log.2019-04-08.log\",\"@timestamp\":\"2019-04-08T13:43:35.779z\",\"@version\":\"1\",\"host\":\"0.0.0.0\",\"message\":\"{\1\"clientip\1\":\1\"10
authenticated\1\":\11"-111",111"AccessTime111":11\"[08/Apr/2019:21:43:34+0800]\11",111"method\11":111"GET/HTTP/1.1\11",111"status\11":111"304\11",111"SendBytes\11":111"-111",111"Query?string
gentVersion\\\":\1\"Mozilla/5.0(Macintosh;IntelMac0SX10_14_1)AppleWebKit/537.36（KHTML，likeGecko)Chrome/73.0.3683.86Safari/537.36\1\"3\",\"type\":\"tc\"}“
127.0.0.1:6379[1]>LPOPnginx_log
"{\"referer\":\"-\",\"type\":\"ngx\",\"http_host\":\"www.elk.com\",\"url\":\"/index.html\",\"path\":\"/usr/local/nginx/Logs/access_json.log\",\"upstreamhost\":\"-\",\"@timestamp\":\"2019-04-08T
0.0.53\",\"domain\":\"www.elk.com\",\"host\":\"10.0.0.53\",\"@version\":\"1\",\"responsetime\":0.0,\"xff\":\"10.0.0.1\",\"upstreamtime\":\"-\",\"status\":\"304\"}”
(integer）5
(integer)7
emptylistorset)
127.0.0.1:6379[1]>
<!-- OCR_END -->

***

### 在ES中查看数据

打开浏览器，访问：<http://10.0.0.51:9100/>

<!-- OCR_START -->
- →Q
- 不安全|10.0.0.51:9100
- 应用T周报TTS系统
- Elasticsearch
- http://10.0.0.51:9200/
- 连接elk-cluster
- 概览索引  数据浏览基本查询[+]  复合查询[+]
- 集群概览
- 集群排序Sort IndicesView Aliases
- IndexFilter
- tcp_log-
- zlsindex
- www.elk.com-
- tomcat_access-
- 2019.04.08
- nginx_access-
- zls_2019.03.30
- zls_2019.03.27
- zls_2019.03.05
- secure_log_2019.03.30
- (120:2 5).0
- size:85.1ki(170ki)
- 2019.03.31
- size:15.1ki（30.3ki)
- size: 5.82ki (11.6ki)
- size:6.94ki(13.9ki)
- ：1（2）
- docs:19(38)
- docs:5(10)
- docs: 1 (2)
- size:497ki(994ki)
- size: 347ki (703ki)
- docs:2(4)
- docs:59(118)
- 信息动作
- elk01
- 信息
- 5
- 4
- elk02
- 动作
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.51:9100
- 应用
- T 周报TTS系统
- Elasticsearch
- http://10.0.0.51:9200/
- 连接
- elk-cluster
- 信息
- 概览  索引]  数据浏览  基本查询[+]  复合查询 [+]
- 刷新
- tcp_log-
- m.elk.com-
- access-
- 2019.04.08
- logstash_rsyslog-
- .kibana
- nginx_access-
- secure_log_2019.03.30
- .oki
- .31
- (57:23i0.
- (80.4ki)
- size:347ki (703ki)
- docs: 2 (4)
- size: 228ki(447ki)
- docs:5（10)
- docs:59(118)
- docs:26(52)
- 信息动作
- 动作
- 4
- 3
- 5
<!-- OCR_END -->

***

### 将ES索引添加到Kibana中

打开浏览器，访问：[http://10.0.0.54:5601](http://10.0.0.54:5601/)

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app
- 应用
- T周报TTS系统
- kibana
- Management
- Discover
- Version:5.3.0
- Visualize
- Dashboard
- IndexPatterns
- Saved Objects
- AdvancedSettings
- Timelion
- DevTools
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/ap
- T周报TTS系统
- Management / Kibana / Indices
- kibana
- Index Patterns  Saved Objects  Advanced Settings
- +Add New
- Visualize
- ncat_access-JYYY.MM.DD
- ★[tomcat_access-]YYYY.MM.DD
- sh_rsyslog-JYYYY.MM.DD
- Dash
- nx_access-JYYY.MM.DD
- Timelion
- _log-JYYY.MM.DD
- This pagelists everyfield inthe [tomcat_accessJYYY.MM.DD indexand the field's associated
- must be done using Elasticsearch's Mapping API %
- DevTools
- Management
- This indexuses a Time-based index patten which repeats Daily
- Filter
- Fields (36)
- Scripted fields (0)
- Source filters (0)
- name
- type
- format
- searchable
- aggregatable
- analyzed
- excluded
- controls
- Query?string.keyword
- string
- partner.keyword
- authenticated
- AgentVersion
- status.keyword
- SendBytes
- path
- SendBytes.keyword
- AccessTime.keyword
- type.keyword
- clientip
- @version
- host
- method.keyword
<!-- OCR_END -->

<!-- OCR_START -->
不安全|10.0.0.54:5601/app/
dex/？_g=(refre
lick,to:now%2Fd)
应用
T周报TTS系统
Management/ Kibana
kibana
IndexPatternsSaved Objects AdvancedSettings
Discover
[tomcat_ccess]).MM.D
Visualize
[logstassysogY.MM.D
Configure an index pattern
[nginxaccess].M.D
Dashboard
tp.log-J.M.DD
nordertouseKibanayoumustconfigureatleastoneindexpa
8
Timelion
DevTools
Indexnameorpattern
Management
Patternsallowyoutodefinedynamic
otedusingbrackets.Example:[logstash-jYYYY.MM.DD.PleasenotethatweeksaresetuptouseISOweekswhichstarton
Monday.-Date Format Doc
[www.elk.com-JYYY.MM.D
Indexcontainstime-based events
Time-fieldname
refreshfields
@timestamp
Useeventtimestocreateindexnames[DEPRECATED)
Time-intervalbased indexpatternsaredeprecated!
Westronglyrecommend usingwlldcardpatternnamesinstead of time-intervalbasedIndexpatterns.
Kibanaisnowsmarte
ticallydete
berformance optimizationswhen searchingwithin a timerange as time-interval patterns.
Indexpatterninterval
Dal
Patternmatches100%ofexistingindicesandalases
www.elk.com-2019.04.08
Create
<!-- OCR_END -->

<!-- OCR_START -->
→C
A不安全|10.0.0.54:5601/app/kib
now%2Fd,mode:quick,to:now%2Fd)
应用T周报TTS系统
Management/Kibana
kibana
IndexPatternsSavedObjectsAdvancedSettings
[tomcat_ccess-JY.MM.D
Visualize
[logstash_syslog-JYY.MM.DD
Configure an index pattern
[nginxccess-]Y.M.DD
Dashboard
[tcp_log-Y.MM.DD
Timelion
[www.elk.com-JY.MM.D
DevTools
Indexname orpattern
Management
Patterns allowyoutodefinedynamicindexnames.Statictextin anindexnameisdenoted usingbrackets.Exal
ample:[logstash-JYYYY.MM.DD.PleasenotethatweeksaresetuptouseISOweekswhichstarton
Monday.-DateFormat Documenta
[m.elk.com-JYYY.MM.DD
Indexcontainstime-basedevents
Time-fieldnamerefreshfields
@timestamp
Use event timesto createindexnames[DEPRECATED]
Time-intervalbasedindexpatternsaredeprecated!
Westronglyrecommend usingwldcard patternnamesinstead of time-intervalbased indexpatterns.
performanceoptimizationswhensearchingwithinatimerange astime-intervalpatterns
Indexpatterninterval
Daily
Patternmatches100%ofexistingindicesand aliases
m.elk.com-2019.04.08
Create
<!-- OCR_END -->

**查看Kibana数据**

<!-- OCR_START -->
- A不安全|10.0.0.54：
- T周报TTS系统
- kibana
- [WWW.elk.com-JYYYY.MM.DD
- April 7th2019,00:00:00.000-April13th2019,23:59:59.999-by.3hours
- Discove
- Selected Fields
- Visualize
- ?_source
- Dashboard
- AvailableFields
- Timelion
- @timestamp
- t @version
- DevTools
- 2019-04-0708:002019-04-0720:002019-04-0808:002019-04-0820:002019-04-09 08:002019-04-0920:002019-04-1008:002019-04-1020:002019-04-1108:002019-04-1120:002019-04-1208:002019-04-1220:002019-04-1308:00
- t_id
- @timestamp per 3 hours
- Management
- tindex
- #_score
- t_type
- April 8th 2019, 21:43:20.@ Qreferer:-type: ngx http_host: www.elk.com url: /index.htmlpath: /usr/local/nginx/logs/access_json.log upstreamhost:-
- @timestamp: April 8th 2019, 21:4
- t clientip
- 3:20.000 size:0clientip:10.0.0.53 domain:www.elk.com host:10.0.0.53@version:1responsetime:0xff:10.0.0.1upstreamtime:-
- status:304id:AWn
- 9P171xCtS9Tdyw_FJ_type:ngx_index:www.elk.com-2019.04.08_score:
- tdomain
- thost
- Linkto/www.elk.com-2019.04.08/ngx/AWn9P171xCtS9Tdyw_FJ
- t http_.host
- Table
- JSON
- tpath
- @Q  * April 8th 2019, 21:43:20.000
- treferer
- @version
- @Q*1
- #responsetime
- @Q*AWn9P171xCtS9Tdyw_FJ
- #size
- @@m*ww.elk.com-2019.04.08
- tstatus
- @Q四*ngx
- tupstreamhost
- tupstreamtime
- Q*10.0.0.53
- turl
- domain
- @Qm*ww.elk.com
- xff
- @@m* /usr/local/nginx/logs/acce
- referer
- @Q*
- @α*θ
- status
- @Q*304
- @α* ngx
- upstreamhost
<!-- OCR_END -->

<!-- OCR_START -->
10.0.0.54:
rce),ind
x:%5Bm.elk.
T周报TTS系统
7hits
NewSaveOpen
ShareThisweek
kibana
April7th 2019,00:00:00.00-April 13th 2019,23:59:59.999-by.3 hours
m-JYYYY.MM.DD
Visualize
Selected Fields
Dashboard
?_source
Available Fields
Timelion
@timestamp
DevTools
t@version
Management
t_id
@tin
tampper3hours
t_index
#_score
t_type
thost
0.53","ClientUser":"-","authenticated""-","AccessTime":"[08/Apr/2019:21:43:39 +0800]","method":"GET / HTTP/1.1","status":"304","SendBytes":"-","Query?strin
g":"","partner":"-","AgentVersion":"Mozilla/5.0 (Macintosh; Intel Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"3
tmessage
type:tc_id:AWn9PmBzxCtS9Tdyw_FU_type:tc_index:m.elk.com-2019.04.08_score:
tpath
Linkto/m.elk.com-2019.04.08/tc/AWn9PmBzxCtS9Tdyw_FU
Table
JSON
①@timestamp @ Q  * April 8th 2019, 21:43:45.795
@Q四*1
@Qm*ANn9PmBzxCtS9Tdyw_FU
@*m.elk.com-2019.04.08
@Q田*
@Q四*tc
@α*0.0.0.0
@ Q *{"clientip":"10.0.0.53","ClientUser":"-","authenticated":"-","AccessTime":"[08/Apr/2019:21:43:39 +0800]","method":"GET/ HTTP/1.1","status":"304","SendBytes":"-","Quer
y?string":"","partner":"-","AgentVersion":"Mozilla/5.0 (Macintosh; Intel Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"}
@Q*
/usr/local/tomcat/logs/tomcc
ess_log.2019-04-08.log
@Q*tc
April 8th 2019, 21:43:45.792
https://www.driverzeng.com.
Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"3
m-2019.04.08_score:
<!-- OCR_END -->

### Redis key堆积监控

实际环境当中，可能会出现reids当中堆积了大量的数据而logstash由于种种原因未能及时提取日志，此时会导致redis服务器的内存被大量使用，甚至出现如下内存即将被使用完毕的情景.

<!-- OCR_START -->
- [root@elk-serverl tianqi]# free
- -m
- total
- used
- free
- shared
- buffers
- cached
- Mem:
- 13922
- 13220
- 701
- 9
- 5048
- -/+buffers/cache:
- 8162
- 5759
- Swap:
<!-- OCR_END -->

```bash
[root@elkstack01 ~]# vim redis_keylenth.py
#!/usr/bin/env python
#coding:utf-8
#Author Driver_Zeng
import redis
def redis_conn():
    pool=redis.ConnectionPool(host="10.0.0.54",port=6379,db=2,password='zls')
    conn = redis.Redis(connection_pool=pool)
    data = conn.llen('tn')
    print(data)
redis_conn()
[root@elkstack01 ~]# python3 redis_keylenth.py
259
```

<!-- OCR_START -->
1.root@elkstack01:~(ssh)
Xt@elkstack01:~（ssh）1
Xlkstack02:~（ssh）2
X.kstack03:/tmp（ssh）3×@elkstack04:~（ssh）4×.lkstack03:~（ssh）5×ver-zeng:~（bash）6
[root@elkstack01~]#python3redis_keylenth.py
59
[root@elkstack01~]#
<!-- OCR_END -->

***

elk 多种架构

<!-- OCR_START -->
- web01
- logstash
- filbeat
- redis
- 收集数据
- 消息队列
- logstash数据分析
- es
<!-- OCR_END -->

## 使用filebeat 收集web日志

```bash
#收集日志不做分析， 不需要jdk
yum localinstall -y filebeat-5.3.2-x86_64.rpm

```

nginx 配置json格式日志

```bash
/etc/nginx/nginx.conf #http层添加 

# vim /usr/local/nginx/conf/nginx.conf

log_format json '{"@timestamp":"$time_iso8601",'
            '"host":"$server_addr",'
            '"clientip":"$remote_addr",'
            '"size":$body_bytes_sent,'
            '"responsetime":$request_time,'
            '"upstreamtime":"$upstream_response_time",'
            '"upstreamhost":"$upstream_addr",'
            '"http_host":"$host",'
            '"url":"$uri",'
            '"domain":"$host",'
            '"xff":"$http_x_forwarded_for",'
            '"referer":"$http_referer",'
            '"status":"$status"}';

# access_log  /var/log/nginx/access.log  json;
access_log  logs/access_json.log  access_json; 
# /usr/local/nginx/
```

filebeat配置

```bash
[root@e3 ~]# cat /etc/filebeat/filebeat.yml
filebeat.prospectors:
- input_type: log
  paths:
    - /usr/local/nginx/logs/access_json.log 
  exclude_lines: ["^DBG","^$"]
  document_type: www.xudao.com

- input_type: log
  paths:
    - /usr/local/tomcat/logs/catalina.out
  exclude_lines: ["^DBG","^$"]
  document_type: tomcat-log

output.redis:
  hosts: ["10.0.0.54:6379"]
  key: "system-log-5612"  #为了后期日志处理，建议自定义key名称
  db: 1  #使用第几个库
  timeout: 5  #超时时间
  password: zls #redis密码

 # systemctl start filebeat

```

redis 查看数据

```bash
[root@e4 ~]# redis-cli -a zls
127.0.0.1:6379> keys *
(empty list or set)
127.0.0.1:6379> SELECT 1
OK
127.0.0.1:6379[1]> keys *
1) "system-log-5612"

```

架构图

<!-- OCR_START -->
- y-db03
- 4oldboy-web01
- 5oldboy-web01
- web01
- input:file
- filebeat
- elasticsearch
- output:redi
- 10.0.0.51:9100
- redis
- 展示
- kibana搜索
- 画图
- inputredis
- logstash
- output:elasticsearch
- grafana
- 出图
- 解折
<!-- OCR_END -->

配置logstash 抓取redis数据

```bash
[root@e3 ~]# vim /etc/logstash/conf.d/redis-systemlog-es.conf
input {
  redis {
    data_type => "list"
    host => "10.0.0.54"
    port => "6379"
    db => "1"
    key => "system-log-5612"
    password => "zls"
    codec => "json"
 }
}

output {
    elasticsearch {
      hosts => ["10.0.0.51:9200"]
      index => "tom-xudao-%{+YYYY.MM.dd}"}
}

# 这里index类型如果获取不到就自定义  index => "tom-xudao-%{+YYYY.MM.dd}"} # 已改原本是  index => "%{type}-%{+YYYY.MM.dd}"}
#启动logstash
[root@e3 ~]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/redis-systemlog-es.conf

```

刷新浏览器访问

<!-- OCR_START -->
A不安全
www.elk.com
zls nginx test page
<!-- OCR_END -->

查看es 是不是多了索引数据

<!-- OCR_START -->
- 10.0.0.20:9100
- 培训学校
- 邢帅淘宝课程
- 素材网
- 博客老男孩学习
- 收藏栏
- english
- Elasticsearch
- http://10.0.0.20:9200/
- 连接
- elk-cluster
- 概览
- 索引
- 数据浏览
- 基本查询 [+]
- 复合查询 [+]
- tom-
- xudao-
- 05.12
- 2019.05.12
- tctt-2019.05.12
- secure_log_2019.05.1
- 9ki)
- size:35.0KI
- size: 133ki (274ki)
- size: 195ki (398ki)
- (71.3ki)
- docs: 70 (142)
- docs: 107 (214)
- docs: 9 (18)
- 信息
- 动作▼
- 2
- 0123
- 5
- 3
- 01234
<!-- OCR_END -->

kibana 添加索引

<!-- OCR_START -->
- 10.0.0.23:5601/app/kibana#/management/kibana/indices/[tom-xuda
- 器目
- ·☆
- 培训学校
- 邢帅淘宝课程
- 素材网白博客口老男孩学习收藏栏english
- kibana
- Management / Kibana / Indices
- Index Patterns
- SSaved ObjectsAdvanced Settings
- Discover
- + Add New
- Visualize
- ★[tomcat_access-]YYYY.M..
- [tom-xudao-]YYYY.MM.DD
- [blog.oldboy.com_JYYYY.M..
- Dashboard
- [message_log_ ]YYYY.MM.DD
- Timelion
- [ngxtt-]YYYY.MM.DD
- This page lists every field in the [tom-xudao-JYYYY.MM.DD index and the field'
- [secure_log_]YYYY.MM.DD
- thislistallowsyou toview thecore type ofeach field,changingfieldtypesmust
- Dev Tools
- [tctt-]YYYY.MM.DD
- Management
- This index uses a Time-based index pattern which repeats Daily
- [www.chou.xudao.com-]YYY..
- [www.xudao.com-]YYYY.M...
- [zls_JYYYY.MM.DD
- Filter
- fields (23)
- scripted fields (0)
- source filters (0)
<!-- OCR_END -->

kibana查看

<!-- OCR_START -->
- kibana
- Discover
- [tom-xudao-JYYYY.MM.DD
- Visualize
- Selected Fields
- Dashboard
- ?_source
- Timelion
- Available Fields
- add
- Dev Tools
- t @version
- Management
- t id
- t jindex
- #_score
- t -type
- May 12th 2019,18:04:19.462
- @timestamp: May 12th 2019, 18:04:19.462 offset: 43,831 beat.hostname: e3 beat.name: e3 beat.version: 5.3.2 input_type: log @version: 1 source: /var/log/ng
- t beat.hostname
- inx/www.xudao. com_access.log message: {"@timestamp":"2019-05-12T18:04:16+08:00","host":"10.0.0.22","clientip":"10.0.0.1","size":0,"responsetime":0.000,"upstrea
- mtime":"-","upstreamhost":"-","http_host":"www.xudao.com","url":"/index.html","domain":"www.xudao.com","xff":"-","referer":"-","status":"304"} type: xudao.com
- t beat.name
- _id: AWqrgCVQDYvuJ3gCUU8a_type: xudao.com_index: tom-xudao-2019. 05.12_score:
- t beat.version
- t input_type
- Table
- Link
- t message
- JSON
- # offset
- ① @timestamp
- Q  * May 12th 2019, 18:04:19.462
- t source
- @@*1
- @@ * AWqrgCVQDYvuJ3gCUU8a
- t _index
- @ @  * tom-xudao-2019.05.12
- -type
- ④Q*
- e3
- @*5.3.2
- 需要在kibana配置里开启添加收集json格式目志
- message
- Q*"@timesta
- ',"clientip":"10.0.0.1","size":0,"responsetime":0.000,"upstre
- eamtime":"-","upstreamhost":"-","http_host":
<!-- OCR_END -->

> 更新: 2024-09-20 17:36:50  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/if7z3q>