# 第八章·Logstash深入-通过TCP/UDP收集日志

## 收集TCP/UDP日志

通过logstash的tcp/udp插件收集日志，通常用于在向elasticsearch日志补录丢失的部分日志，可以将丢失的日志通过一个TCP端口直接写入到elasticsearch服务器。

## 配置Logstash

```bash
#进入Logstash配置文件目录
[root@elkstack03 ~]# cd /etc/logstash/conf.d/
#编辑Logstash配置文件
[root@elkstack03 conf.d]# vim tcp.conf
input {
  tcp {
    port => 1234
    type => "tcplog"
    mode => "server"
  }
}
output {
  stdout {
    codec => rubydebug
  }
}
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f  /etc/logstash/conf.d/tcp.conf
#检测端口是否启动成功
[root@elkstack03 ~]# netstat -lntup
tcp        0      0 :::1234                     :::*                        LISTEN      8656/java

```

<!-- OCR_START -->
- [root@elkstack03 ~]# netstat -lntup
- Active Internet connections (only servers)
- Proto Recv-Q Send-Q Local Address
- Foreign Address
- State
- PID/Program name
- tcp
- 0 0.0.0.0:80
- 0.0.0.0:*
- LISTEN
- 8236/nginx
- 0 0.0.0.0:22
- 1272/sshd
- 0 127.0.0.1:25
- 1348/master
- :::8080
- 4974/iava
- 0 :::1234
- :::*
- 8656/java
- 0 :::22
- :::*
- 0 ::1:25
- :::*
- ::ffff:127.0.0.1:9600
- :::*
- 5683/java
- 0 ::ffff:127.0.0.1:9601
- 8572/java
- :::*
- 0 ::ffff:127.0.0.1:9602
- :::*
- 0 ::ffff:127.0.0.1:8005
- 4974/java
- :::*
- 0 :::8009
- :::*
- [root@elkstack03
- ~#
<!-- OCR_END -->

## 使用nc传输日志

NetCat简称nc，在网络工具中有`瑞士军刀`美誉，其功能实用，是一个简单、可靠的网络工具，可通过TCP或UDP协议传输读写数据，另外还具有很多其他功能。

在其它服务器安装nc命令

```bash
#使用yum安装nc
[root@db04 ~]# yum install -y nc
#使用nc传输数据
[root@elkstack04 ~]# echo "zls test nc" | nc 10.0.0.53 1234
```

<!-- OCR_START -->
```text
[root@elkstacko3conf.d]#/usr/share/logstash/bin/logstash-f/etc/logstash/conf.d/tcp.conf
WARNING:Could not find logstash.yml which is typically located in SLS_HOME/config or/etc/logstash.You can specify the path using --path.settings.Continuing using the defaults
Couldnotfindlog4j2configuration atpath/usr/share/logstash/config/log4j2.properties.Usingdefaultconfigwhichlogstoconsole
11:20:21.565[[main]-pipeline-manager]INF0
logstash.pipeline -Starting pipeline{"id"=>"main"，"pipeline.workers"=>1,"pipeline.batch.size"=>125,“pipeline.batch.delay”=>5,"pipeline.max_inflight"=>125}
11:20:21.631[[main]-pipeline-manager]INF0
logstash.inputs.tcp-Starting tcpinput listener{:address=>"0.0.0.0:1234"}
11:20:21.653[[main]-pipeline-manager]INF0logstash.pipeline-Pipelinemainstarted
11:20:21.789[Api Webserver]INF0logstash.agent-Successfully started Logstash APIendpoint{:port=>9602}
"@timestamp"=>2019-04-08T03:25:21.252Z, "port"=>40582, "@version”=>"1", "host"
=>"10.0.0.54"
“message"=>"zls test nc"，
type"=>"tcplog”
```
<!-- OCR_END -->

**通过nc发送一个文件**

```bash
#将/etc/passwd文件当成日志文件传送
[root@elkstack04 ~]# nc 10.0.0.53 1234 < /etc/passwd
```

结果如下，我们不难发现，Logstash会将传送来的日志文件 `一行一行` 读取，收集成日志

<!-- OCR_START -->
```text
1.root@elkstacko3:/etc/logstash/conf.d(ssh)
..icsearch-head（ssh）1×..lkstack02:（ssh）2×..logstash/conf.d（ssh）3
X.@elkstack04:~（ssh）4
×.lkstack03:~（ssh）5
[root@elkstack03conf.d]#/usr/share/logstash/bin/logstash-f/etc/Logstash/conf.d/tcp.conf
11:20:21.565[main]-pipeline-manager]
INFO
logstash.pipeline-Starting pipeline{"id”=>main"，“pipeline.workers"=>1,“pipeline.batch.size”=>125,“pipeline.batch.delay”=>5,“pipeline.max_inflight”=>125} 11:20:21.631[[main]-pipeline-manager] INFO logstash.inputs.tcp-Starting tcpinputlistener {:address=>"0.0.0.0:1234"}
11:20:21.653[main]-pipeline-manager]INFO1
logstash.pipeline-Pipelinemain started
11:20:21.789[Api Webserver]INF0 logstash.agent -Successfully started Logstash API endpoint {:port=>9602}
"@timestamp"=>2019-04-08T03:25:21.252Z, "port”=>40582, "@version"=>"1", "host"
"10.0.0.54", "message"
"type"=>"tcplog"
"timestamp"=>2019-04-08T03:27:08.155Z, "@version"
"message"=>"root:x:0:0:root:/root:/bin/bash", "type"=>"tcplog”
"@timestamp"=>2019-04-08T03:27:08.155Z, "port"= 40583, "host"
=>“10.0.0.54"，
"message"
"=>"bin:x:1:1:bin:/bin:/sbin/nologin", "type"=>"tcplog”
"@timestamp"=>2019-04-08T03:27:08.156Z, "port"=>40583，
"@version"=>"1", "host"
"daemon:x:2:2:daemon:/sbin:/sbin/nologin", "10.0.0.54", "message"
"type"=>"tcplog”
"@timestamp"=>2019-04-08T03:27:08.156Z, "port"
=>40583，
"message"=>“
"adm:x:3:4:adm:/var/adm:/sbin/nologin", "type"=>"tcplog"
"@timestamp"=>2019-04-08T03:27:08.157Z, “port"=>40583, 'host'
"10.0.0.54", https://www.driverzeng.com
```
<!-- OCR_END -->

￼

***

## 通过伪设备的方式发送日志

在类Unix操作系统中，设备节点并不一定要对应物理设备。没有这种对应关系的设备是伪设备。操作系统运用了它们提供的多种功能，tcp只是dev下面众多伪设备当中的一种设备。

```bash
#发送伪设备数据
[root@elkstack04 ~]# echo "曾老湿 伪设备 测试"  > /dev/tcp/10.0.0.53/1234
```

<!-- OCR_START -->
```text
"@timestamp" => 2019-04-08T03:32:27.249Z, "port"=> 40585, "@version"=>"1"
"host" => "10.0.0.54", "message"=>"曾老湿伪设备测试"，
"type"=> "tcplog"
```
<!-- OCR_END -->

## 将输出改成ES

```bash
#编辑logstash配置文件
[root@elkstack03 conf.d]# vim /etc/logstash/conf.d/tcp.conf
input {
  tcp {
    port => 1234
    type => "tcplog"
    mode => "server"
  }
}
output {
  elasticsearch {
    hosts => ["10.0.0.51:9200"]
    index =>  "tcp_log-%{+YYYY.MM.dd}"
  }
}
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f  /etc/logstash/conf.d/tcp.conf &
#测试数据
[root@elkstack04 ~]# echo "曾老湿 伪设备 测试1"  > /dev/tcp/10.0.0.53/1234
[root@elkstack04 ~]# echo "曾老湿 伪设备 测试2"  > /dev/tcp/10.0.0.53/1234
```

打开浏览器，访问：<http://10.0.0.51:9100/>

<!-- OCR_START -->
- 不安全|10.0.0.51:9100
- 应用T周报TTS系统
- Elasticsearch
- http://10.0.0.51:9200/
- 连接elk-cluster
- 集群健康值：green（146of146）
- 信息
- 概览索引数据浏览基本查询[+】复合查询[+]
- 集群概览
- 集群排序·
- SortIndices
- View Aliases
- ndexFilter
- 刷新
- tcp_log-
- zlsindex
- size:5.09ki
- zls_2019.03.30
- zls_2019.03.27
- zls_2019.03.05
- tomcat_access-
- 2019.04.08
- secure_log_2019.03.30
- nginx_
- （10.2ki)
- 2019.03.31
- size:12.1kr
- size:15.1ki (30.3ki)
- 2019.0
- docs:1(2)
- size:85.1ki(170ki)
- size:345ki(690ki)
- size:40.2ki(80.4ki)
- (24.2ki)
- size:6.94ki(13.9ki)
- docs:19(38)
- docs:5（10)
- size:31.5k
- 信息动作
- docs:71（142)
- docs:11（22)
- docs:2（4)
- docs:4(8)
- 动作
- elk01
- elk02
<!-- OCR_END -->

## 将ES索引添加到Kibana中

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/management_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd）)
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
- 8
- Timelion
- DevTools
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/management/kibana/indices/%5Btomcat_access-%5DYYYY.MM.DD?_g=（refreshlnterval:(display:Off,pause:If,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd）)_a=（t
- 应用
- T周报TTS系统
- Management/Kibana/Indices
- kibana
- Index Patterns Saved Objects Advanced Settings
- Discover
- +AddNew
- Visualize
- ★[tomcat_access-]YYY.MM.DD
- [tomcat_access-]YYYY.MM.DD
- Dashboard
- [nginx_access-JYYY.MM.DD
- 8
- Thispagelistseveryfieldinthe[tomcat_access-JYyYy.MM.DDindexandthefield'sassociatedcoretypeasrecordedbyElasticsearch.Whilethislistallowsyoutoviewthecoretypeof
- eachfield,changingfieldtypesmustbedoneusingElasticsearch'sMappingAPI
- DevTools
- Management
- ThisindexusesaTime-based indexpatternwhichrepeatsDaily
- Filter
- Fields(36)
- Scripted fields(0)
- Source filters(o)
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
- Collapse
- type.keyword
- https://www.driverzteing.com
<!-- OCR_END -->

<!-- OCR_START -->
A不安全|10.0.0.54:5601/app/kibana
应用
T周报TTS系统
kibana
[tomcat_access-]YY.MM.DD
[nginx_access-]YYY.MM.DD
Configure an indexpattern
Discover
InordertouseKibanayoumustconfigureatleastoneindexpattern.lndexpatternsareusedtoidentifytheElasticsearchindextorunsearchandanalyticsagainst.Theyarealsousedto
Visualize
configure fields.
Dashboard
Indexnameorpattern
Timelion
Dev Tools
ISOweekswhichstartonMonday.-DateFormatDocumentation
Management
[tcp_log-YYYY.MM.DD
Indexcontainstime-basedevents
Time-field namerefreshfields
@timestamp
Useevent timestocreateindexnames[DEPRECATED]
Time-intervalbased indexpatternsaredeprecated!
Westronglyrecommend usingwildcardpatternnamesinsteadof time-interval based indexpatterns.
Kibana isnowsmartenoughto automaticallydeterminewhichindicestosearchagainst within thecurrent timerangeforwildcard indexpatterns.Thismeansthatwildcard
indexpatternsnowgethesameperformanceoptimizationswhensearchingwithinatimerangeastime-intervalpatterns.
Indexpatterninterval
Daily
Patternmatches100%of existing indices and aliases
·tcp_log-2019.04.08
Create
Collapse
<!-- OCR_END -->

查看日志结果

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kiba
- na#/discover?_g=（refreshlnterval:(display:Off,pause:1f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））_a=（columns:1_source),index:%5Btcp_log-%5DYYYY.MM.DD,int
- 应用
- 周报TTS系统
- kibana
- [tcp_log-JYYYY.MM.DD
- April8th2019,00:00:00.000-April8th2019,23:59:59.999-by30minutes
- Selected Fields
- Visualize
- ?_source
- 1.5
- AvailableFields
- Dashboard
- @timestamp
- 0.5
- 8
- Timelion
- t@version
- DevTools
- tid
- @timestamp per30minutes
- Management
- t_index
- #_score
- Time
- ttype
- April 8th 2019,11:41:18.462
- etimestamp:April 8th 2019,11:41:18.462port:40,587@version:1host:10.0.0.54message:曾老湿伪设备测试2type:tcplog_id:
- thost
- AWn7CTUKxCtS9Tdyw_DF_type:tcplog_index:tcp_log-2019.04.08_score:
- tmessage
- Linkto/tcp_log-2019.04.08/tcplog/AWn7CTUKxCtS9Tdyw_DF
- #port
- Table
- JSON
- @Q*April8th2019,11:41:18.462
- @Q四*1
- @Q*AWn7CTUKxCtS9Tdyw_DF
- Qm*tcp_log-2019.04.08
- Q*
- @*tcplog
- Q①*10.0.0.54
- Q*曾老湿伪设备测试2
- Q*40,587
- @Q*tcplog
- April 8th 2019,11:41:13.465
- @timestamp:April8th 2019,11:41:13.465port:40,586@version:1host：10.0.0.54message:曾老湿伪设备测试1type:tcplog_id:
- Collapse
<!-- OCR_END -->

> 更新: 2024-09-20 15:10:31  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ycutgg>