# 第三章·Logstash入门-部署与测试

## Logstash环境准备与安装
### Logstash环境准备
**关闭防火墙**

```bash
#CentOS6 关闭防火墙
[root@elkstack01 ~]# /etc/init.d/iptables stop
#CentOS7 关闭防火墙
[root@elkstack01 ~]# systemctl stop firewalld
```

**关闭SELINUX**

```bash
#临时关闭
[root@elkstack01 ~]# setenforce 0
setenforce: SELinux is disabled
#永久关闭
[root@elkstack01 ~]# vim /etc/sysconfig/selinux
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled    ==>      //原来是enforcing 改成disabled
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

**设置epel源**

```bash
#CentOS6 下载epel源
[root@elkstack01 ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
#CentOS7 下载epel源
[root@elkstack01 ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

**修改时区**

```bash
#将时区修改为上海时区
[root@elkstack01 ~]# cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
cp：是否覆盖"/etc/localtime"？ y
```

**设置时间同步**

```bash
#同步服务器时间（切记保证集群之间时间一致非常重要）
[root@elkstack01 ~]# ntpdate time1.aliyun.com
28 Feb 14:11:28 ntpdate[8904]: step time server 203.107.6.88 offset 3168820.831817 sec
```

---

### 部署Logstash
Logstash是一个开源的数据收集引擎，可以水平伸缩，而且logstash整个ELK当中拥有最多插件的一个组件，其可以接收来自不同来源的数据并统一输出到指定的且可以是多个不同目的地。

**安装JDK环境**

**<u>下载地址:</u>** [http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

```bash
#解压JDK安装包
[root@elkstack01 ~]# tar xf jdk-8u121-linux-x64.tar.gz
#将JDK安装包移动到安装目录下
[root@elkstack01 ~]# mv jdk1.8.0_121 /usr/local/
#做软链接(方便日后升级)
[root@elkstack01 ~]# ln -s /usr/local/jdk1.8.0_121 /usr/local/jdk1.8
#添加环境变量
[root@elkstack01 ~]# vim /etc/profile.d/jdk1.8.sh
export JAVA_HOME=/usr/local/jdk1.8
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
#加载环境变量
[root@elkstack01 ~]# source /etc/profile
#检查是否加载成功
[root@elkstack01 ~]# java -version
java version "1.8.0_121"
Java(TM) SE Runtime Environment (build 1.8.0_121-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode)

-----------------------------------------------------------------------
tar xf jdk-8u202-linux-x64.tar.gz
mv jdk1.8.0_202 /usr/local/
ln -s /usr/local/jdk1.8.0_202 /usr/local/jdk1.8
tee /etc/profile.d/jdk1.8.sh <<-'EOF'
export JAVA_HOME=/usr/local/jdk1.8
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
EOF
source /etc/profile
java -version
```

**安装Logstash**

**<u>下载地址:</u>** [https://www.elastic.co/downloads/past-releases/logstash-5-3-0](https://www.elastic.co/downloads/past-releases/logstash-5-3-0)

```bash
#安装Logstash使用yum localinstall 自动安装依赖包
[root@elkstack03 ~]# yum localinstall -y logstash-5.3.0.rpm
#给Logstash目录授权
[root@elkstack03 ~]# chown -R logstash.logstash /usr/share/logstash/
```

## Logstash输入输出插件介绍
| INPUT、OUTPUT插件 |
| --- |

**INPUT**：插件使Logstash能够读取特定的事件源。

**OUTPUT**：插件将事件数据发送到特定的目的地，OUTPUT是事件流水线中的最后阶段。

| INPUT支持事件源 | OUTPUT支持输出源 | CODEC编解码器支持编码 |
| --- | --- | --- |
| azure_event_hubs(微软云事件中心) | elasticsearch(搜索引擎数据库) | avro(数据序列化) |
| beats(filebeat日志收集工具) | email(邮件) | CEF(嵌入式框架) |
| elasticsearch(搜索引擎数据库) | file(文件) | es_bulk(ES中的bulk api) |
| file(文件) | http(超文本传输协议) | Json(数据序列化、格式化) |
| generator(生成器) | kafka(基于java的消息队列) | Json_lines(便于存储结构化) |
| heartbeat(高可用软件) | rabbitmq(消息队列 OpenStack) | line(行) |
| http_poller(http api) | redis(缓存、消息队列、NoSQL) | multiline(多行匹配) |
| jdbc(java连接数据库的驱动) | s3*(存储) | plain(纯文本，事件间无间隔) |
| kafka(基于java的消息队列) | stdout(标准输出) | rubydebug(ruby语法格式) |
| rabbitmq(消息队列 OpenStack) | tcp(传输控制协议) | |
| redis(缓存、消息队列、NoSQL) | udp(用户数据报协议) | |
| s3*(存储) | | |
| stdin(标准输入) | | |
| syslog(系统日志) | | |
| tcp(传输控制协议) | | |
| udp(用户数据报协议) | | |

## Logstash输入输出插件测试
| 测试logstash标准输入到标准输出 |
| --- |

```bash
#从标准输入到标准输出
[root@elkstack03 ~]# /usr/share/logstash/bin/logstash -e 'input { stdin{} } output { stdout{ codec => rubydebug }}'
#标准输入zls test及返回结果
zls test
{
#时间戳
    "@timestamp" => 2019-03-05T09:41:40.198Z,
#版本信息
      "@version" => "1",
#主机
          "host" => "0.0.0.0",
#接收信息
       "message" => "zls test"
}
```

结果展示如下图所示：

<!-- OCR_START -->
```text
WARNING:Couldnotfindlogstash.ymlwhichistypicallylocated in$LS_HOME/configor/etc/logstash.You can specify thepath using --path.settings.Continuingusing the defaults
Couldnotfindlog4j2configurationatpath/usr/share/logstash/config/log4j2.properties.Using default configwhichlogsto console
17:41:26.977[main]INF0logstash.setting.writabledirectory-Creating directory{:setting=>"path.queue"，:path=>"/usr/share/logstash/data/queue"}
17:41:27.005[LogStash::Runner]INF0 logstash.agent-Nopersistent UUID filefound.GeneratingnewUUID{:uuid=>ce76f0b4-e628-4974-8e44-1e84772c2d7c",:path=>"/usr/share/logstash/data/uuid}
17:41:27.291[main]-pipeline-manager] INF0 logstash.pipeline-Starting pipeline {"id"=>"main","pipeline.workers"=>1,"pipeline.batch.size"=>125,"pipeline.batch.delay"=>5,"pipeline.max_inflight"=>1
17:41:27.849[main]-pipeline-manager]INF01
logstash.pipeline-Pipelinemainstarted
Thestdinpluginisnowwaitingforinput:
17:41:27.923[ApiWebserver]INF0logstash.agent-Successfully started Logstash APIendpoint{:port=>9600}
zlstest命令行中标准输入内容
"@timestamp"=>2019-03-05T09:41:40.198Z, "@version”=>"1"，
"host"=>"0.0.0.0", 日志收集结果返回给命令行
"message"=>"zls test"
```
<!-- OCR_END -->

---

| 测试logstash标准输入到文件 |
| --- |

```bash
#从标准输入到文件中
[root@elkstack03 ~]# /usr/share/logstash/bin/logstash -e 'input { stdin{} } output { file { path => "/tmp/test_%{+YYYY.MM.dd}.log"}}'
#输入bgx ugly
bgx ugly
#返回结果
19:10:00.303 [[main]>worker0] INFO  logstash.outputs.file - Opening file {:path=>"/tmp/test_2019.03.05.log"}
#查看tmp目录下是否有日志文件存在
[root@elkstack03 ~]# ll /tmp/
总用量 4
-rw-r--r-- 1 root root   95 3月   5 19:10 test_2019.03.05.log
#查看日志内容
[root@elkstack03 ~]# cat /tmp/test_2019.03.05.log
{"@timestamp":"2019-03-05T11:10:00.235Z","@version":"1","host":"0.0.0.0","message":"bgx ugly"}
```

结果展示如下图所示：

<!-- OCR_START -->
typically
thepath using
--path.settings.Continuingusing the defaults
ould
logstash.pipeline
Startingpipeline{"id
"main"，“pipeline.w
s"=>1,“pipeline.batch.size”=>125,“pipeline.batch.delay”=>5，“pipeline.max_inflight”=>125}
[[main]-pipeline-manager]INFO
Thestdinpluginisnowwaitingforinput:
[ApiWebserver]INFO
logstash.agent
Successfully startedLogstash APIendpoint{:port=>9600}
ugly
zeng.com
<!-- OCR_END -->

<!-- OCR_START -->
[root@elkstack03~]#1l/tmp/
总用量4
-rw-r--r--1rootroot953月519:10test_2019.03.05.log
[root@elkstack03~]#cat/tmp/test_2019.03.05.log
{"@timestamp": "2019-03-05T11:10:00.235Z", "@version" :"1", "host":"0.0.0.0", "message": "bgx ugly"}
[root@elkstack03~]#
<!-- OCR_END -->

---

| 测试logstash标准输入到ES |
| --- |

```bash
#从标准输入到Elasticsearch
[root@elkstack03 ~]# /usr/share/logstash/bin/logstash -e 'input { stdin{} } output { elasticsearch {hosts => ["10.0.0.51:9200"] index => "blog.oldboy.com_%{+YYYY.MM.dd}" }}'
#输入内容
zls test stdin to ES
#在Elasticsearch中查看数据结果
[root@elkstack01 ~]# ll /data/elk/data/nodes/0/indices/
总用量 8
drwxr-xr-x 9 elasticsearch elasticsearch 4096 3月   5 17:19 C8o7IxEVR2W7CpPFFCa4cA
drwxr-xr-x 9 elasticsearch elasticsearch 4096 3月   5 19:35 R8IZGhT4Sw2XukCiG1O02A
```

结果展示如下图所示：

<!-- OCR_START -->
```text
["10.0.0.51:9200"]index
"zls_%{+YYYY.MM.dd}"3}”
--path.settings.Continuing using the defaults
Couldnotfindlog4j2configurationat
/config/log4j2.properties.Usingdefaultconfig whichlogs toconsole
INFO
ElasticsearchpoolURLsupdated{:changes=>{:removed=>,:added=>[http://10.0.0.51:9200/]}}
19:35:18.319[[main]-pipeline-manag Runninghealthcheckto seeifan Elasticsearch connectionisworking{:healthcheck_url=>http://10.0.0.51:9200/,:path=>"/} WARN Restored connectiontoESinstance{:url=>#<URI::HTTP:0x79997765URL:http://10.0.0.51:9200/>}
19:35:18.501
[[main]-pipeline-manag logstash.outputs.elasticsearch Usingmapping template from{:path=>nil} 19:35:18.812 [[main]-pipeline tash.outputs.elasticsear arch-Attempting to install template {:manage_template=>{"template”=>"logstash-*",“version”=>50001,“settings"=>{"index.refresh_interval"=>"5s"}，“mappings”=>{"- templates
"match_mapping_type"=>"string","mapping"=>{"type"=>"text", "norms"=>false}}}，{"string_fields"=>{"match"=>"* "match_m
pping_type"=>"string", alse}, "location"=>{"type"=>"geo_point"}，"latitude"=>{"type”=>"half_float"}，"longitude"=>{"type"=>"half_float"}}}}}} 19:35:18.826[[main]-pipeline-manager]
19:35:18.965[[main]-pipeline-manager]
logstash.outputs.elasticsearch-NewElasticsearchoutput {:class=>"LogStash::0utputs::ElasticSearch",:hosts=>[#<URI::Generic:0x6f04f27URL://10.0.0.51:9200>]}
19:35:18.968[[main]-pipeline-manager]
logstash.pipeline-
Starting pipeline {"id"=>"main","pipeline.workers”=>1,"pipeline.batch.size”=>125,“pipeline.batch.delay”=>5,"pipeline.max_inflight”=>125} Pipeline main started Thestdinpluginisnow waiting forinput: 19:35:29.099[Api Webserver]INF0 logstash.agent
Successfully started Logstash API endpoint{:port=>9600}
zls test stdin to ES
```
<!-- OCR_END -->

<!-- OCR_START -->
[root@elkstack01~]#[l/data/elk/data/nodes/0/indices/
总用量8
drwxr-xr-x9elasticsearchelasticsearch40963月
517:19C8o7IxEVR2W7CpPFFCa4cA
519:35R8IZGhT4Sw2XukCiG1002A
[root@elkstack01~]#
<!-- OCR_END -->

打开浏览器，访问：[http://10.0.0.51:9100](http://10.0.0.51:9100)

<!-- OCR_START -->
- →C
- 不安全|10.0.0.51:9100
- 应用
- Elasticsearch
- http://10.0.0.51:9200/
- 信息
- 概览索引数据浏览基本查询[+]复合查询[+]
- 集群概览
- 集群排序Sort IndicesView Aliases
- IndexFilter
- 刷新
- zlsindex
- zls_2019.03.05
- size:4.95ki (9.89ki)
- size:5.58ki(11.2ki)
- 如果没有新数据可以点击刷新
- docs:1(2)
- 信息动作
- elk01
- 动作
- elk02
<!-- OCR_END -->

	

> 更新: 2024-09-19 22:27:19  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/wxhw11>