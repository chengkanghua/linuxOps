# 第九章·Logstash深入-Logstash配合rsyslog收集haproxy日志

# rsyslog介绍及安装配置

`rsyslog` 是 Linux 系统中用于日志管理的一个守护进程，它负责收集、处理和转发系统和应用程序生成的日志消息。

在centos 6及之前的版本叫做syslog，centos 7开始叫做rsyslog，根据官方的介绍，rsyslog(2013年版本)可以达到每秒转发百万条日志的级别，官方网址：<http://www.rsyslog.com/>

# 安装配置rsyslog

```bash
#安装rsyslog
[root@elkstack03 ~]# yum install -y rsyslog
#编辑rsyslog配置文件
[root@elkstack03 ~]# vim /etc/rsyslog.conf
$ModLoad imudp
$UDPServerRun 514
$ModLoad imtcp
$InputTCPServerRun 514
#最后面一行添加，local6对应haproxy配置文件定义的local级别,端口为Logstash的端口
local6.*     @@10.0.0.53:2222
```

# 安装配置haproxy

```bash
#安装haproxy
[root@elkstack03 ~]# yum install -y haproxy
#编辑haproxy配置文件
[root@elkstack03 ~]# vim /etc/haproxy/haproxy.cfg
global
    maxconn 100000
    chroot /var/lib/haproxy
    uid 99
    gid 99
    daemon
    nbproc 1
    pidfile /var/run/haproxy.pid
    log 127.0.0.1 local6 info
    defaults
    option http-keep-alive
    option  forwardfor
    maxconn 100000
    mode http
    timeout connect 300000ms
    timeout client  300000ms
    timeout server  300000ms
listen stats
    mode http
    bind 0.0.0.0:9999
    stats enable
    log global
    stats uri     /haproxy-status
    stats auth    haadmin:123456

#frontend web_port
frontend web_port
    bind 0.0.0.0:80
    mode http
    option httplog
    log global
    option  forwardfor
###################ACL Setting##########################
    acl pc          hdr_dom(host) -i www.elk.com
    acl mobile      hdr_dom(host) -i m.elk.com
###################USE ACL##############################
    use_backend     pc_host        if  pc
    use_backend     mobile_host    if  mobile
########################################################

backend pc_host
    mode    http
    option  httplog
    balance source
    server web1  10.0.0.53:8081 check inter 2000 rise 3 fall 2 weight 1

backend mobile_host
    mode    http
    option  httplog
    balance source
    server web1  10.0.0.53:8080 check inter 2000 rise 3 fall 2 weight 1

#启动haproxy
 # /etc/init.d/haproxy start
systemctl start haproxy  #先把nginx 停掉

#启动rsyslog
# /etc/init.d/rsyslog start
systemctl start rsyslog

启动系统日志记录器：
#验证端口
[root@elkstack03 ~]# netstat -lntup |grep haproxy
tcp        0      0 0.0.0.0:9999                0.0.0.0:*                   LISTEN      9082/haproxy
tcp        0      0 0.0.0.0:80                  0.0.0.0:*                   LISTEN      9631/haproxy
#验证进程
[root@elkstack03 ~]# ps -ef|grep haproxy
nobody     9082      1  0 14:04 ?        00:00:00 /usr/sbin/haproxy -D -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
#修改nginx配置文件，将端口改为8081
[root@elkstack03 ~]# vim /usr/local/nginx/conf/nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  logs/access.log  main;
    log_format access_json '{"@timestamp":"$time_iso8601",'
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
    access_log  logs/access_json.log  access_json;
    server {
        listen       8081;
        server_name  10.0.0.53;
        location / {
            root   /code/html;
            index  index.html index.htm;
        }
    }
}
#修改tomcat配置文件，将默认站点目录改成/webapps/webdir
[root@elkstack03 ~]# vim /usr/local/tomcat/conf/server.xml
      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
     <Context path="" docBase="/usr/local/tomcat/webapps/webdir" debug="0" reloadable="false"
              crossContext="true"/>
              
#重启nginx
[root@elkstack03 ~]# /usr/local/nginx/sbin/nginx -t
nginx: the configuration file /usr/local/nginx-1.10.3/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.10.3/conf/nginx.conf test is successful
[root@elkstack03 ~]# /usr/local/nginx/sbin/nginx -s reload
#启动nginx
 /usr/local/nginx/sbin/nginx
 
#重启tomcat
[root@elkstack03 ~]# cd /usr/local/tomcat/bin/
[root@elkstack03 bin]# ./catalina.sh stop
[root@elkstack03 bin]# ./catalina.sh start
#修改本地hosts文件
10.0.0.53 www.elk.com
10.0.0.53 m.elk.com
```

测试域名访问

<!-- OCR_START -->
MacBook-Pro:~driverzeng$
pingwww.elk.com
INGwwW.elk.com
(10.0.0.53)
56databytes
64 bytes from 10.0.0.53:icmp_seq=0 ttl=64 time=0.332 ms
64 bytes from 10.0.0.53:icmp_seq=1 ttl=64 time=0.369 ms
64bytesfrom10.0.0.53:icmp_seq=2ttl=64time=0.455ms
www.elk.compingstatistics
3packetstransmitted，3packetsreceived，0.0%packetloss
round-tripmin/avg/max/stddev=0.332/0.385/0.455/0.052ms
pingm.elk.com
64bytesfrom10.0.0.53:icmp_seq=0ttl=64 time=0.383ms
64bytes from 10.0.0.53:icmp_seq=1ttl=64 time=0.661ms
64bytesfrom10.0.0.53:icmp_seq=2ttl=64time=0.349ms
- m.elk.com ping statistics --
round-tripmin/avg/max/stddev=0.349/0.464/0.661/0.140ms
MacBook-Pro:~driventtps://www.driverzeng.com
<!-- OCR_END -->

测试haproxy，打开浏览器，访问：<http://www.elk.com/>

<!-- OCR_START -->
- 不安全|www.elk.com
- 应用T周报TTS系统
- zlsnginxtestpage
<!-- OCR_END -->

测试haproxy，打开浏览器，访问：<http://m.elk.com/>

<!-- OCR_START -->
- 不安全|m.elk.com
- 应用T周报TTS系统
- zlstomcatpage
<!-- OCR_END -->

***

# 配置Logstash

```bash
#编辑Logstash配置文件
[root@elkstack03 conf.d]# vim /etc/logstash/conf.d/haproxy.conf
input{
  syslog {
    type => "rsyslog_haproxy"
    port => "2222"
  }
}
output{
  stdout{
    codec => rubydebug
  }
}
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/haproxy.conf
#检查Logstash端口
[root@elkstack03 ~]# netstat -lntup|grep 2222
tcp        0      0 :::2222                     :::*                        LISTEN      9867/java
udp        0      0 :::2222                     :::*                                    9867/java
```

访问haproxy管理页面测试数据

打开浏览器，访问：<http://10.0.0.53:9999/haproxy-status>

输入haproxy配置文件中的用户名和密码

用户名：haadmin

密码：123456

<!-- OCR_START -->
- 10.0.0.53:9999/haproxy-status
- 无痕模式
- 周报TTS系统
- 登录
- http://10.0.0.53:9999
- 您与此网站的连接不是私密连接
- 用户名
- haadmin
- 123456
- 密码
<!-- OCR_END -->

<!-- OCR_START -->
- StatisticsReport forHAProxy
- 不安全|10.0.0.53:9999/haproxy-status
- 无痕模式
- T周报TTS系统
- HAProxyversion1.5.18,released2016/05/10
- Statistics Report for pid9631
- General process information
- activeUP
- backupUP
- Display option:
- Externalresources:
- ess#1,nbproc=1)
- .Scope:
- Primary site
- 310
- HideDOWNservers
- ·Updates (v1.5)
- notchecked
- Refresh now
- Online manual
- cuentcons=2cuentpips=cona1/sec
- itiveorbackupDowNformaintenance(MAINT)
- Runing tasks:1/9;idle=100%
- .CSVexport
- ctveorbackupSOFTSTOPPEDformaintenance
- ：NOLB/DRAIN”=UPwith load-balancing disabled.
- Session rate
- Bytes
- Denied
- Errors
- CurMaxLimit
- Cur
- Max
- Limit
- Total
- LbTot
- Last
- Out
- Req
- Resp
- Retr
- Status
- LastChk
- WghtActBckChkDwn
- Dwntme
- Thrtle
- Frontend
- 2
- 100000
- 2652
- 42408
- OPEN
- Backend
- 10000
- Os
- 53m4sUP
- web_port
- Server
- Conn
- Redis
- DwntmeThrtle
- 4
- 994
- 793
- pc_host
- ings
- Con
- Wght
- Act
- Bck
- Dwn
- web1
- 48m5s
- 498
- 179
- L4OKin0ms
- 0s
- 1
- moblle_host
- Reo
- BckChkDwn
- 47m59s
- 496
- 240
- 49m35sUP
- 6s
<!-- OCR_END -->

<!-- OCR_START -->
```text
t@elkstack01:~（ssh)1
...t@elkstack02:~（ssh）2
...t@elkstack03:~（ssh)3
.@elkstack04:~（ssh）4×..logstash/conf.d（ssh）5
@driver-zeng:~（ssh）6
[root@elkstacko3conf.d]#/usr/share/logstash/bin/logstash
15:26:25.432[main]-pipeline-manger]
INFO
logstash.pipeline-Starting pipeline{"id"=>"main",“pipeline.workers"=>1,“pipeline.batch.size"=>125,“pipeline.batch.delay"=>5,“pipeline.max_inflight"=>125}
15:26:25.781[main]-pipeline-manager]INF0logstash.pipeline
-Pipeline mainstarted
15:26:25.885
[Ruby-0-Thread-9:/usr/share/logstash/ ndor/bundle/jruby/1.9/gems/logstash-input-syslog-3.2.0/Lib/logstash/inputs/syslog.rb:101]INF0logstash.inputs.syslog-Starting syslog udplistener {:address=>"0.0.0.0:2222"}
15:26:25.899
t-syslog-3.2.0/lib/logstash/inputs/syslog.rb:105]INF0logstash.inputs.syslog-Starting syslogtcplistener{:address=>"0.0.0.0:2222"}
15:26:25.957[ApiWebserver]INF0logstash.agent-
Successfully started Logstash APIendpoint {:port=> 15:33:20.998[Ruby-0-Thread-16:/usr/share/logstash/vendor/bundle/jruby/1.9/gems/Logstash-input-syslog-3.2.0/lib/logstash/inputs/syslog.rb:166]INF0logstash.inputs.syslog-newconnection{:client=>10.0.0.53:40339"} severity"=>6, "pid"=> "9631", "program"
"haproxy"
"message"
"Connect from 10.0.0.1:52998 to10.0.0.53:9999(stats/HTTP)\n", "type”=>
"rsyslog_haproxy", "priority"=>182, "logsource"
=>
"localhost", "@timestamp"=>2019-04-08T07:33:20.000Z, "@version”=>"1", "host"=>"10.0.0.53"，
"facility"=>22, "severity_label"=>
"Informational", "Apr815:33:20", "facility_label"=>"local6"
```
<!-- OCR_END -->

# 将输出改成ES

```bash
#进入Logstash配置文件目录
[root@elkstack03 ~]# cd /etc/logstash/conf.d
#编辑配置文件
[root@elkstack03 conf.d]# vim /etc/logstash/conf.d/haproxy.conf
input{
      syslog {
        type => "rsyslog_haproxy"
        port => "2222"
      }
}
output{
  elasticsearch {
    hosts => ["10.0.0.51:9200"]
    index =>  "logstash_rsyslog-%{+YYYY.MM.dd}"
  }
}
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/haproxy.conf &
```

打开浏览器，访问：<http://10.0.0.51:9100/>

<!-- OCR_START -->
- →C不安全|10.0.0.51:9100
- 应用T周报TTS系统
- Elasticsearch
- http://10.0.0.51:9200/
- 连接elk-cluster
- 集群健康值：gre
- 信息
- 概览索引]数据浏览 基本查询[+]  复合查询[+]
- tcp_log-
- 2019.04.08
- logstash_rsyslog-
- .kibana
- sS-
- tomcat_access-
- secure_log_2019.03.30
- nginx_access-
- message_log_2019.03.31
- message_log_2019.03.30
- es_log_2019.04.01
- 2019.03.31
- size:40.2ki(80.4ki)
- size: 284ki (579ki)
- ize:27.7ki（55.3ki)
- docs: 4(8)
- docs: 2 (4)
- size:80.7ki(161ki)
- docs:11 (22)
- docs:53(106)
- 信息动作
- docs:10（20)
- 1123
- 5
- 3
<!-- OCR_END -->

# 将ES索引添加到Kibana中

打开浏览器，访问：<http://10.0.0.54:5601/>

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/ap
- (now%2Fd)
- 应用
- T周报TTS系统
- kibana
- Management
- Discover
- Version:5.3.0
- Visualize
- Dashboard
- IndexPatterns
- SavedObjects
- AdvancedSettings
- Timelion
- DevTools
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- Management / Kibana / Indices
- kibana
- Index Patterns  Saved Objects  Advanced Settings
- Discover
- +AddNew
- Visualize
- cat_access-JYYYY.MM.DD
- ★ [tomcat_access-]YYYY.MM.DD
- Dashboard
- acces-YY.M.D
- g-JYYYY.MM.DD
- Timelion
- This page lists every field in the [tomcat_access-JYYYY.MM.DD index
- must be done using Elasticsearch's Mapping API
- DevTools
- This index uses a Time-based index pattern which repeats Daily
- Management
- Filter
- Fields (36)
- Scripted fields (0)
- Source filters (0)
- name
- type
- format
- searchable
- aggregatable 0
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
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
不安全|10.0.0.54:5601/app/ki
应用
T周报TTS系统
Management/Kibana
kibana
IndexPatterns SavedObjects AdvancedSettings
Discover
★[tomcat_access-]YYYY.MM.DD
Visualize
[nginx_ccess-).MM.D
Configure an index pattern
[tcp_log-.MM.DD
Dashboard
In ordertouseKibanayou mustconfigure at least one indexpattern.Indexpatterns areused toidentify theElasticsearch indextorunsearch and analyticsagainst.They arealsoused to configurefields.
Timelion
DevTools
Indexnameorpattern
Management
Patterns allowyou to define dynamic
ample:[logstash-JYYYY.MM.DD.PleasenotethatweeksaresetuptouseISOweekswhichstarton
Monday.-DateFormatDocur
[logstash_rsyslog-JYYY.MM.DD
Indexcontainstime-based events
Time-fieldname
refreshfields
@timestamp
Useeventtimestocreateindexnames[DEPRECATED]
Time-interval based indexpatternsaredeprecated!
Westronglyrecommendusingwildcardpatternnamesinsteadoftime-
expatterns
Kibanaisnowsmartenoughtoautoma
aticallydeter
cardindexpa
Indexpatterninterval
Daily
Patternmatches100% of existingindices and aliases
·logstash_rsyslog-2019.04.08
Create
Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- [logstash_rsyslog-JYYYY.MM.DD
- kibana
- Selected Fields
- Disco
- _source
- Visualize
- AvailableFields
- @timestamp
- Dashboard
- t@version
- Timelion
- tid
- @timestamp per 30 minutes
- t_index
- DevTools
- Time
- #_score
- Management
- ttype
- # facility
- localhost @timestamp:April 8th 2019,15:43:11.000 @version:1host:10.0.0.53 facility:22 severity_label:Informational timestamp:Apr 815:43:11
- t facility.label
- facility_1label:local6_id:AWn75qjpxCts9Tdyw_EW_type:rsyslog_haproxy _index: logstash_rsyslog-2019.04.08_score:
- thost
- tlogsource
- Table
- JSON
- tmessage
- @Q*April8th2019，15:43:11.000
- tpid
- Q*1
- #priority
- @Qm* AWn75qjpxCtS9Tdyw_EW
- tprogram
- _index
- @Q*logstash_rsyslog-2019.04.08
- #severity
- Q*
- tseverity_label
- @@四*rsyslog_haproxy
- ttimestamp
- @Q*22
- tfacility_label@@*local6
- @Q* 10.0.0.53
- Q*localhost
- @ Q m * Connect from 10.0.0.1:53733 to 10.0.0.53:999 (stats/HTTP)
- Q*9631
- ④Q*182
- program
- Q*haproxy
- @Q*6
- tseverity_label @Q*Informational
- Collapse
- type
<!-- OCR_END -->

> 更新: 2024-09-20 16:22:22  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/rl0eah>