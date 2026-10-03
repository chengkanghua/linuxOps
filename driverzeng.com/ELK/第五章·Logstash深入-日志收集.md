# 第五章·Logstash深入-日志收集

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1)整合了各个公有云API，自主创建云主机。
>
> 2)ELK自动化收集日志功能。
>
> 3)Saltstack自动化运维统一配置管理工具。
>
> 4)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6)SQL执行及审批流程。
>
> 7)慢查询日志分析web界面。
>

---

## Logstash收集单个日志到文件中
| file模块收集日志 |
| --- |

不难理解，我们的日志通常都是在日志文件中存储的，所以，当我们在使用INPUT插件时，收集日志，需要使用file模块，从文件中读取日志的内容，那么接下来讲解的是，将日志内容输出到另一个文件中，如此一来，我们可以将日志文件统一目录，方便查找。

注意：Logstash与其他服务不同，收集日志的配置文件需要我们根据实际情况自己去写。

前提：需要Logstash对被收集的日志文件有读的，并且对要写入的文件，有写入的权限。

```bash
#进入Logstash配置文件目录下
[root@elkstack03 ~]# cd /etc/logstash/conf.d/
#编辑Logstash收集日志的配置文件
[root@elkstack03 conf.d]# vim message.conf
#输入插件
input {
#文件模块
  file {
#日志类型
    type => "message-log"
#日志路径
    path => "/var/log/messages"
#第一次收集日志从头开始
    start_position => "beginning"
  }
}
#输出插件
output {
#文件模块
  file {
#输出路径
    path => "/tmp/message_%{+yyyy.MM.dd}.log"
  }
}
#检测语法
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/message.conf -t
Configuration OK
```

结果如下图所示：

<!-- OCR_START -->
-path.settings. Continuing using the defaults
LonfigurationOk
<!-- OCR_END -->

```bash
#如果语法没有错，那就可以启动Logstash了，去掉-t，加上&即可
[root@elkstack03 ~]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/message.conf &
```

启动成功结果如下：

<!-- OCR_START -->
path.settings.Continuing using the defaults
nfig/log4jz
Usir
logs
to
22:05:26.948[[main]-pipeline
logstash.pipeline
"pipeline.workers"=>1,“pipeline.batch.size”=>125,“pipeline.batch.delay”=5,“pipeline.max_inflight"=>125}
INFO
Pipelin
Successfullystarted
<!-- OCR_END -->

---

| 验证收集数据 |
| --- |

```bash
#查看tmp目录下是否生成日志文件
[root@elkstack03 ~]# ll /tmp/
总用量 1
-rw-r--r-- 1 root  root   291 3月  30 22:05 message_2019.03.30.log
#查看日志内容（日志中就一条）
[root@elkstack03 ~]# cat /tmp/message_2019.03.30.log
{"path":"/var/log/messages","@timestamp":"2019-03-30T14:05:35.103Z","@version":"1","host":"0.0.0.0","message":"Mar 26 21:23:02 elkstack03 rsyslogd: [origin software=\"rsyslogd\" swVersion=\"5.8.10\" x-pid=\"1073\" x-info=\"http://www.rsyslog.com\"] rsyslogd was HUPed","type":"message-log"}
#往系统日志中写入数据
[root@elkstack03 ~]# echo zls_test_message >> /var/log/messages
#再次查看收集到的日志内容（变成了两条）
[root@elkstack03 ~]# cat /tmp/message_2019.03.30.log
{"path":"/var/log/messages","@timestamp":"2019-03-30T14:05:35.103Z","@version":"1","host":"0.0.0.0","message":"Mar 26 21:23:02 elkstack03 rsyslogd: [origin software=\"rsyslogd\" swVersion=\"5.8.10\" x-pid=\"1073\" x-info=\"http://www.rsyslog.com\"] rsyslogd was HUPed","type":"message-log"}
{"path":"/var/log/messages","@timestamp":"2019-03-30T14:07:37.071Z","@version":"1","host":"0.0.0.0","message":"zls_test_message","type":"message-log"}
```

开启两个窗口实时查看：

```bash
#右边窗口实时查看日志
[root@elkstack03 ~]# tail -f /tmp/message_2019.03.30.log
#左边窗口往系统日志中插入数据
echo 1 >> /var/log/messages
echo 2 >> /var/log/messages
echo 3 >> /var/log/messages
```

结果如下图所示：

<!-- OCR_START -->
1.root@elkstack03:~(ssh)
.elkstack01:~（ssh）1×t@elkstack02:~（ssh）2×..t@elkstack03:（ssh）3×..t@elkstack03:（ssh）4
root@elkstack03:
root@elkstack03:~（ssh）
Last login:Sat Mar 3022:12:25 on ttys004
Last login:Sat Mar 3022:13:08on ttys004
MacBook-Pro:~driverzengs db03
Last1ogin:SatMar3022:12:272019from10.0.0.1
[root@elkstack03~]#echo 1>>/var/Log/messages
[root@elkstack03~]#tail-f/tmp/message_2019.03.30.log
~]#echo2>>/var/Log/messages
/var/log/messages","@timestamp":"2019-03-30T14:05:35.103Z","@version":"1","host":"0.0.0.0","message":“Mar 26
~]#echo3>>/var/Log/messages
21:23:02elkstack03rsyslogd:[origin software=\"rsyslogd\"swVersion=\"5.8.10\"x-pid=\"1073\"x-info=\"http://www.rs
yslog.com\"]rsyslogd was HUPed","type":"message-Log"}
"path":"/var/Log/messages","@timestamp":"2019-03-30T14:07:37.071Z","@version":"1","host":"0.0.0.0","message":"zls_tes
t_message","type":"message-log"}
{"path":"/var/log/messages","@timestamp":"2019-03-30T14:13:55.380Z","@version":"1","host":"0.0.0.0","messag
":"message-log"}
{"path":"/var/Log/messages","@timestamp":"2019-03-30T14:14:04.390Z","@version":"1","host":"0.0.0.0","messag
e":"message-log"}
<!-- OCR_END -->

￼

## Logstash收集多个日志到文件中
```bash
#进入Logstash配置文件目录
[root@elkstack03 ~]# cd /etc/logstash/conf.d/
#编辑配置文件
[root@elkstack03 conf.d]# vim system_log.conf
#输入插件
input {
#文件模块
  file {
#日志路径
    path => "/var/log/messages"
#日志类型
    type => "system_log"
#第一次收集从头收集
    start_position => "beginning"
#收集日志间隔时间3秒
    stat_interval => "3"
  }
#文件模块
  file {
#日志路径
    path => "/var/log/secure"
#日志类型
    type => "secure_log"
#第一次收集从头收集
    start_position => "beginning"
#收集日志间隔时间3秒
    stat_interval => "3"
  }
}
#输出插件
output {
#判断如果类型是system_log则输出到指定路径
  if [type] == "system_log" {
#文件模块
    file {
#日志输出路径
      path => "/tmp/message2_%{+yyyy.MM.dd}.log"
    }}
#判断如果类型是secure_log则输出到指定路径
  if [type] == "secure_log" {
#文件模块
    file {
#日志输出路径
      path => "/tmp/secure_%{+yyyy.MM.dd}.log"
    }}
}
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/system_log.conf &
```

---

| 验证收集数据 |
| --- |

```bash
#查看tmp目录是否有新文件
[root@elkstack03 ~]# ll /tmp/
总用量 12
-rw-r--r-- 1 root  root   291 3月  30 22:05 message_2019.03.30.log
-rw-r--r-- 1 root  root   294 3月  30 23:00 message2_2019.03.30.log
-rw-r--r-- 1 root  root   286 3月  30 23:00 secure_2019.03.30.log
#查看新收集的message日志
[root@elkstack03 ~]# cat /tmp/message2_2019.03.30.log
{"path":"/var/log/messages","@timestamp":"2019-03-30T15:00:05.454Z","@version":"1","host":"0.0.0.0","message":"test_message","type":"message_log"}
#查看新收集的secure日志
[root@elkstack03 ~]# cat /tmp/secure_2019.03.30.log
{"path":"/var/log/secure","@timestamp":"2019-03-30T15:00:24.216Z","@version":"1","host":"0.0.0.0","message":"test_secure","type":"secure_log"}

```

开启多个窗口实时查看数据：

```bash
#中间窗口实时追踪message日志
[root@elkstack03 ~]# tail -f /tmp/message2_2019.03.30.log
#右边窗口实时追踪secure日志
[root@elkstack03 ~]# tail -f /tmp/secure_2019.03.30.log
#往message日志中插入数据
echo 1 >> /var/log/messages
echo 2 >> /var/log/messages
echo 3 >> /var/log/messages
#往secure日志中插入数据
echo 1 >> /var/log/secure
echo 2 >> /var/log/secure
echo 3 >> /var/log/secure
```

<!-- OCR_START -->
1.root@elkstack03:~（ssh）
.ekstack01:~（ssh）1×t@elkstack02:~（ssh）32×.t@elkstack03:~（ssh）3
..logstash/conf.d（ssh）34
oot@elkstack03:
（ssh)
[root@elkstack03~]#echo1>>/var/log/messages
[root@elkstack03
tail-f/tmp/message2_2019.03.30.log
tail-f/tmp/secure_2019.03.30.1og
"path":"/var/Log/
.454Z","@version"
30115:00:0
f"path":"
var/log/
","@timestamp":"2019-03-30T15:00:24
.216Z","@version":"
~]#echo3>>/var/log/messages
"1","host":"0.0.0.0","mess
e":"test_mess
sage”,"type”:"message
_log"}
1","host":"0.0.0.o","message":"test_secure","type":"secure_log"}
~了#
sages","@timestamp":"2019-03-30T15:00:07.359Z","
"@version"
[root@elkstack03~]#echo 1>>/var/Log/secure
[root@elkstack03~]#echo2>>/var/Log/secure
"@timestamp'
："2019-03-30T15:04:18.391Z"
~]#
echo3>>/var/log/secure
1","host":"0.0.0.0","message":"Mar
3023:04:17elkstack03 sshd[11538]:
Accepte
dpublickey for
root from 10.0.0.1 port 62504 ssh2","type":"secure_log”}
{"path":"/var/Log/messages","@t
p":"2019-03-30T15:04:57.687Z","@version"
"2019-03-30T15:05:03.695Z","@version”
"path"
var/Log/secure","@timestamp”
":"2019-03-30T15:04:20.395Z"
"message_log"}
1","host":"0.0.0.0”,"message":“Mar 30 23:04:20elkstack03 sshd[11565]:Accepte
":“2019-03-30T15:05:08.701Z",@version"
publickey
":"2019-03-30T15:04:20.395Z","@version":"
"host":"0.0.0.0","message":"Mar 3023:04:20 elkstack03 sshd[11565]:pam_uni
x(sshd:session):session opened for user root by (uid=O)","type":"secure_log"}
2019-03-30T15:05:17.445Z","@version":
"secure_log"
2019-03-30T15:05:22.453Z","@version":"
"0.0.0.0","mess
“2019-03-30T15:05:25.455Z","@version"
zeng.com
<!-- OCR_END -->

## Logstash收集多个日志到Elasticsearch中
之前讲到Logstash收集多个日志到文件中，实际上，我们将输出源从文件改到Elasticsearch中即可。

```bash
#进入Logstash配置文件目录
[root@elkstack03 ~]# cd /etc/logstash/conf.d/
#编辑配置文件
[root@elkstack03 conf.d]# vim system_es.conf
#输入插件
input {
#文件模块
  file {
#日志路径
    path => "/var/log/messages"
#日志类型
    type => "message_log"
#第一次收集从头收集
    start_position => "beginning"
#收集日志间隔时间3秒
    stat_interval => "3"
  }
#文件模块
  file {
#日志路径
    path => "/var/log/secure"
#日志类型
    type => "secure_log"
#第一次收集从头收集
    start_position => "beginning"
#收集日志间隔时间3秒
    stat_interval => "3"
  }
}
#输出插件
output {
#判断如果类型是system_log则输出到指定路径
  if [type] == "message_log" {
#elasticsearch模块
    elasticsearch {
#es的ip及端口
      hosts => ["10.0.0.51:9200"]
#es的索引名称，也就是日志名称
      index => "message_log_%{+YYYY.MM.dd}"
    }}
#判断如果类型是secure_log则输出到指定路径
  if [type] == "secure_log" {
#es模块
    elasticsearch {
#es的ip及端口
      hosts => ["10.0.0.51:9200"]
#es的索引名称，也就是日志名称
      index => "secure_log_%{+YYYY.MM.dd}"
    }}
}
#启动Logstash
sed -i '/^#/d' system_es.conf
[root@elkstack03 ~]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/system_es.conf &
```

启动成功，结果如下：

<!-- OCR_START -->
```text
[1]1179
[root@elkstacko3~]#WARNING:Could not find logstash.yml whichis typically located inSLS_HOME/config or/etc/logstash.You can specify the path using--path.settings.Continuing using the defaults
Could notfindlog4j2configurationatpath/usr/share/Logstash/config/log4j2.properties.Using defaultconfig whichlogstoconsole
01:41:01.410[main]-pipeline-manager]INF0
logstash.outputs.elasticsearch-ElasticsearchpoolURLsupdated:changes=>{:removed=>,:added=>[http://10.0.0.51:9200/]}}
01:41:01.416[[main]-pipeline-manager]INFO
logstash.outputs.elasticsearch-Running health check to seeifanElasticsearch connectionis working{:healthcheck_url=>http://10.0.0.51:9200/,:path=>/"} 01:41:01.574[[main]-pipeline-manager]WARN logstash.outputs.elasticsearch-Restored connection toESinstance{:url=>#<URI::HTTP:0x5b2a4ea0 URL:http://10.0.0.51:9200/>} 01:41:01.575[[main]-pipeline-manager]INFO
logstash.outputs.elasticsearch-Usingmapping templatefrom:path=>nil}
01:41:01.836[[main]-pipeline-manager]INFO logstash.outputs.elasticsearch-Attempting to install template {:manage_template=>{"template"=>"logstash-*","version”=>50001,"settings">{"index.refresh_interval"=>"5s"},“mappings"=>{"_defa ult_"=>{"_all"=>{"enabled"=>true, "norms"=>false}, "dynamic_templates" ，"match_mapping_type"”=>"string",“mapping"=>{"type”=>"text","norms"=>false}}，{"string_fields"=>{"match”=>"
"match_m
"mapping”=>{"type”=>"text",，
01:41:01.845[[main]-pipeline-manager]INF0 logstash.outputs.elasticsearch-NewElasticsearch output{:class=>LogStash::Outputs:ElasticSearch",:hosts=>[#<URI::Generic:0x3ddf64cb URL://10.0.0.51:9200>]} 01:41:01.861 [[main]-pipeline-manager]INFO logstash.outputs.elasticsearch-Elasticsearch pool URLs updated{:chc es=>{:removed=>]，:added=>[http://10.0.0.51:9200/]}
01:41:01.861[main]-pipeline-manager]INFO
01:41:01.869[[main]-pipeline-manager]WARN
logstash.outputs.elasticsearch-Restored connection toESinstance {:url=>#<URI::HTTP:0x639b43edURL:http://10.0.0.51:9200/>}
01:41:01.873[[main]-pipeline-manager]INFO
logstash.outputs.elasticsearch-Usingmappingtemplatefrom{:path=>nil}
logstash.outputs.elasticsearch-Attempting to install template {:man e_template=>{"template"=>"logstash-*","version”=>5001,"setings"=>"index.refresh_interval">"ss"),"mappings"=>"-_defa ult_"=>{"_all"=>{"enabled"=>true, "norms"=>false}， pping_type"=>"string"，"
"mapping"”=>{"type”=>"text"， 01:41:01.883[main]-pipeline-manager]INFO logstash.outputs.elasticsearch-New Elasticsearch output{:class=>LogStash::Outputs::ElasticSearch",:hosts=>[#<URI::Generic:0x4228c089 URL://10.0.0.51:9200>]} 01:41:01.885[[main]-pipeline-manager]INFO
logstash.pipeline-Starting pipeline {"id"=>"main"，“pipeline.workers"=>1,“pipeline.batch.size”=>125,“pipeline.batch.delay"=>5,“pipeline.max_inflight"=>125} 1:41:17.140[[main]-pipeline ger]INFO logste
Pipelinemain started
Successfullys
ww.driverzeng.com
```
<!-- OCR_END -->

打开浏览器，访问：[http://10.0.0.51:9100](http://10.0.0.51:9100) 查看是否有新索引添加

如果没有查看到新数据，那么可以往日志文件中插入几条测试数据，再刷新页面即可。

```bash
echo test_message_to_es >> /var/log/messages
echo test_secure_to_es >> /var/log/secure
```

<!-- OCR_START -->
- ←→C不安全|10.0.0.51:9100
- 90
- 应用
- Elasticsearch
- http://10.0.0.51:9200/
- 连接elk-cluster
- 信息
- 概览  索引  数据浏览  基本查询 [+  复合查询 [+]
- 集群概览
- 集群排序Sort IndicesView Aliases
- IndexFilter
- 刷新
- skibana
- zlsindex
- zls_2019.03.30
- zls_2019.03.27
- zls_2019.03.05
- secure_log_2019.03.30
- message_log_2019.03.30
- size: 5.09ki (10.2ki)
- size:85.0ki(170ki)
- size:15.0ki(30.0ki)
- size:5.82ki (11.6ki)
- size:6.71ki (13.4ki)
- (12.6ki)
- docs:1(2)
- docs:19(38)
- docs:5(10)
- docs: 2 (4)
- 信息动作
- 动作
- elk01
- 5
- elk02
- 1
- 2
- 3
- 4
<!-- OCR_END -->

在数据浏览中，我们可以查看到message_log_2019.03.30日志的内容，在message中显示刚才插入的数据：test_message_to_es

<!-- OCR_START -->
- →C不安全|10.0.0.51:9100
- 应用
- Elasticsearch
- http://10.0.0.51:9200/
- 连接elk-cluster
- 信息
- 概览索引
- 数据浏览
- 基本查询[+]  复合查询[+]
- 刷新
- 所有索引
- 查询6个分片中用的6个.1命中.耗时0.005秒
- index
- _id
- _score path
- @timestamp
- @version
- host
- message
- 索引
- type
- message_log_2019.03.30
- message_log AWnPuNEFQOuyrLS7nT431
- /var/log/messages 2019-03-30T17:49:49.435Z 1
- 0.0.0.0
- test_message_to_es
- message_log
- .kibana
- secure_log_2019.03.30
- zls_2019.03.05
- zls_2019.03.27
- zls_2019.03.30
- zlsindex
- 类型
- config
- index-pattern
- logs
- search
- secure_log
- server
- timelion-sheet
- zls
- 字段
- age
- buildNum
- columns
- defaultIndex
- description
- fieldFormatMap
- fields
- hits
- intervalName
- kibanaSavedObjectMeta.searchSourceJSON
- name
- notExpandable
- path
- salary
- sort
- sourceFilters
<!-- OCR_END -->

在数据浏览中，我们可以查看到secure_log_2019.03.30日志的内容，在message中显示刚才插入的数据：test_secure_to_es

<!-- OCR_START -->
- →Q
- 不安全|10.0.0.51:9100
- 应用
- Elasticsearch
- http://10.0.0.51:9200/
- 连接elk-cluster
- 集群健康值：
- 信息
- 概览索引数据浏览
- 基本查询[+] 复合查询 [+]
- 数据浏览
- 刷新
- 所有索引
- 查询6个分片中用的6个.1命中.耗时0.003秒
- id
- _score path
- @timestamp
- @version
- host
- 索引
- _index
- _type
- message
- secure_log_2019.03.30 secure_log AWnPuQu5QOuyrLS7nT47 1
- /var/log/secure 2019-03-30T17:50:04.410Z 1
- 0.0.0.0
- test_secure_to_essecure_log
- .kibana
- ssage_log_2019.03.30
- zls_2019.03.05
- zls_2019.03.27
- zls_2019.03.30
- zlsindex
- 类型
- config
- index-pattern
- logs
- message_log
- search
- secure_log
- server
- timelion-sheet
- zls
- 字段
- age
- buildNum
- columns
- defaultIndex
- description
- fieldFormatMap
- fields
- hits
- intervalName
- kibanaSavedObjectMeta.searchSourceJSON
- name
- notExpandable
- path
- salary
- sort
- sourceFilters
<!-- OCR_END -->

	

> 更新: 2024-09-20 11:25:13  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/vupria>