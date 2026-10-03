# 第七章·Logstash深入-收集NGINX日志

## NGINX安装配置

源码安装nginx

因为资源问题，我们先将nginx安装在Logstash所在机器

```bash
#安装nginx依赖包
 yum install -y gcc gcc-c++ automake pcre-devel zlib-devel openssl-devel
#下载nginx安装包
 wget http://nginx.org/download/nginx-1.10.3.tar.gz
#解压
tar xf nginx-1.10.3.tar.gz
#进入nginx安装目录
cd nginx-1.10.3/
#生成编译文件
  ./configure  --prefix=/usr/local/nginx-1.10.3
#编译
 make
#安装
 make install
#做软链接
 ln -s /usr/local/nginx-1.10.3 /usr/local/nginx
#检测nginx语法
 /usr/local/nginx/sbin/nginx -t

#启动nginx
 /usr/local/nginx/sbin/nginx
```

***

配置nginx

```bash
#简化nginx配置文件
[root@elkstack03 ~]# grep -Ev '#|^$' /usr/local/nginx/conf/nginx.conf.default  > /usr/local/nginx/conf/nginx.conf
#编辑nginx配置文件
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
    server {
        listen       80;
        server_name  localhost;
        location / {
            root   /code/html;
            index  index.html index.htm;
        }
    }
}
#创建nginx站点目录
 mkdir -p /code/html
#写测试页面
echo zls nginx test page > /code/html/index.html
#重新加载nginx
/usr/local/nginx/sbin/nginx -s reload
```

打开浏览器，访问：<http://10.0.0.53/>

<!-- OCR_START -->
- 不安全|10.0.0.53
- 应用T周报TTS系统
- zlsnginxtestpage
<!-- OCR_END -->

￼

***

## 修改nginx日志格式为Json

之前我们讲了tomcat日志，在企业中，修改格式需要与开发商量，但是nginx我们不需要，如果需要原来的格式日志，我们可以将日志输出两份，一份 `main`格式，一份`Json`格式

```bash
#编辑nginx日志，添加日志格式，源main格式和Json格式
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
#main格式日志
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  logs/access.log  main;
#Json格式日志
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
        listen       80;
        server_name  10.0.0.53;
        location / {
            root   /code/html;
            index  index.html index.htm;
        }
    }
}
#检测nginx配置文件语法
[root@elkstack03 ~]# /usr/local/nginx/sbin/nginx -t
nginx: the configuration file /usr/local/nginx-1.10.3/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.10.3/conf/nginx.conf test is successful
#重新加载nginx
[root@elkstack03 ~]# /usr/local/nginx/sbin/nginx -s reload
```

打开浏览器，访问：<http://10.0.0.53/> 查看日志

```bash
#进入nginx日志目录
[root@elkstack03 ~]# cd /usr/local/nginx/logs/
#查看目录中日志
[root@elkstack03 logs]# ll
总用量 24
#修改后的Json格式日志
-rw-r--r-- 1 root root 1280 4月   8 10:47 access_json.log
#源main格式日志
-rw-r--r-- 1 root root 5286 4月   8 10:47 access.log
-rw-r--r-- 1 root root 4218 4月   8 10:46 error.log
-rw-r--r-- 1 root root    5 4月   8 10:20 nginx.pid
#查看Json格式日志
[root@elkstack03 logs]# cat /usr/local/nginx/logs/access_json.log
{"@timestamp":"2019-04-08T10:47:41+08:00","host":"10.0.0.53","clientip":"10.0.0.1","size":0,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"10.0.0.53","url":"/index.html","domain":"10.0.0.53","xff":"-","referer":"-","status":"304"}
#查看main格式日志
[root@elkstack03 logs]# cat /usr/local/nginx/logs/access.log
10.0.0.1 - - [08/Apr/2019:10:29:11 +0800] "GET / HTTP/1.1" 404 571 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
```

结果如下：

<!-- OCR_START -->
```http
1.root@elkstack03:/usr/local/nginx/logs(ssh)
.ticsearch-head（ssh）1×.kstack02:~（ssh）2X..ocl/nginxlogs（ssh）3×root@db04:~（ssh）4×..driver-zeng:~（bash）5
[root@elkstack03logs]#cataccess_json.logJson格式日志
["@timestamp":"2019-04-08T10:47:41+08:00","host":"10.0.0.53","clientip":"10.0.0.1","size":0,"responsetime":0.00,"upstreamtime":"-","upstreamhost":"-","http_host":"10.0.0.53","url":"/index.html","domain":"10.0.0.53","xff":"-","referer":" ',"status":"304"} {"@timestamp":"2019-04-08T10:47:42+08:00","host”:"10.0.0.53","clientip":"10.0.0.1","size":0,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"10.0.0.53","url":"/index.html","domain":"10.0.0.53","xff":"-","referer":"- ',"status":"304"} ["@timestamp":"2019-04-08T10:47:42+08:00","host”:"10.0.0.53","clientip":"10.0.0.1","size":0,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"10.0.0.53","url":"/index.html","domain":"10.0.0.53","xff":"-","referer":"- ,"status":"304"}
{"@timestamp":"2019-04-08T10:47:42+08:00","host":"10.0.0.53","clientip":"10.0.0.1","size":0,"responsetime”:0.00,"upstreamtime":"-","upstreamhost":"-","http_host":"10.0.0.53","url":"/index.html","domain":"10.0.0.53","xff":"-","referer":" ,"status":"304"}
{"@timestamp":"2019-04-08T10:47:42+08:00","host":"10.0.0.53","clientip":"10.0.0.1","size":0,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"10.0.0.53","url":"/index.html","domain":"10.0.0.53","xff":"-","referer":" ","status":"304"}
[root@elkstack03logs]#cataccess.logmain格式日志
10.0.0.1
[08/Apr/2019:10:29:11+0800]"GET/HTTP/1.1"404571"-"“Mozilla/5.0（Macintosh;Intel Mac0SX10_14_1)ApleWebKit/537.36(KHTML,like Gecko)Chrome/73.0.3683.86Safari/537.36"
10.0.0.1--
[08/Apr/2019:10:29:11+ +0800]
"GET/favicon.ico
HTTP/1.1"404571
tp://10.0.0.53
Mozilla
；IntelMac0SX10_14_1)Ap
it/537.36CKHTML
like Gecko)Chrome/73.0.3683.86Safari/537.36"
10.0.0.1--
[08/Apr/2019:10:29:17+0800]"GET/code HTTP/1.1"404571
"_”
“Mozilla/5.0（Macintosh;IntelMac0SX10_14_1）AppleWebKit/537.36（KHTML,like Gecko) Chrome/73.0.3683.86Safari/537.36"
10.0.0.1
[08/Apr/2019:10:29:47+0800]
"GET/code HTTP/1.1"
404571
"Mozilla/5.0(Macintosh;IntelMac0SX10_14_1)Appl
LeWebKit/537.36（KHTML，1ikeGecko)Chrome/73.0.3683.86Safari/537.36
10.0.0.1
[08/Apr/2019:10:29:51+ +0800 "GET / HTTP/1.1" "Mozi1la/5.0(Macintosh;IntelMac0SX10_14_1)AppleWebKit/537.36（KHTML，1ikeGecko)Chrome/73.0.3683.86Safari/537.36
10.0.0.1
[08/Apr/2019:10:29:53+ +0800 'GET HTTP/1.1"
/73.0.3683.865afari/537.36
10.0.0.1
08/Apr/2019:10:29:53
+0800]
"GET
/HTTP/1.1"
404
571
Mozilla/5.0 (Macintosh; Intel Mac 0SX10_14_1）
Kit/537.36
(KHTML like Gecko)
Chrome/73.0.3683.86Safari/537.36
10.0.0.1
[08/Apr/2019:10:29:53+0800]
"GET/HTTP/1.1"
404571“_
"Mozilla/5.0(Macintosh;Intel Mac0SX10_14_1)AppleWebKit/537.36(KHTML，
,like Gecko)Chrome/73.0.3683.86Safari/537.36"
10.0.0.1
08/Apr/ /2019:10:29:53
+08001
"GET
/HTTP/1.1"
404
571
Mozilla/5.0(Macintosh
10.0.0.1
[08/Apr/2019:10:31:20+ "GET/HTTP/1.1" 404571 IntelMac0SX10_14_1)AppleWebKit/537.36（KHTML,
0.0.0.1
08/Apr/ /2019:10:31:45
08001
"GET
/code HTTP/1.1"
404571
Mozilla/5.0(Macintosh; Kit/537.36(KHTML like Gecko)Chrome/73.0.3683.86Safari/537.36" Mozilla/5.0(Macintosh;Intel Mac0SX10_14_1) AppleWebKit/537.36(KHTML，like Gecko) Chrome/73.0.3683.86Safari/537.36"
10.0.0.1
08/Apr/2019:10:33:45
+0800
4000
10.0.0.1
08/Apr/2019:10:35:05+ +0800
"GET/code/index.htmLH11P/1.1"404S71"-"
"Mozilla/S.0(Macintosh;
IntelMac0SX10_14_1)AppleWebKit/537.36(KHTML，1ikeGecko)Chrome/73.0.3683.86Safari/537.36"
10.0.0.1
08/Apr
/2019:10:35:06
0800
'GET
/code/index.html
HTTP/1.1"
404571
loz1lla/S.0(Macintosh Intel "GET/code/index.html HTTP/1.1"404571" "Mozilla/5.0(Macintosh；Intel Mac0SX10_14_1）AppleWebKit/537.36(KHTML,1ike Gecko)Chrome/73.0.3683.86Safari/537.36"
it/537.36
(KHIML
10.0.0.1
08/Apr/2019:10:35:06+0800]
10.0.0.1
08/Apr/2019:10:35:06+ +0800
"GET/code/index.htmlHTTP/1.1"404571"-""Mozilla/5.0(Macintosh;
Intel Mac0SX 10_14_1)AppleWebKit/537.36（KHTML, ，1ikeGecko)Chrome/73.0.3683.86Safari/537.36
10.0.0.1
08/Apr/2019:10:35:06+ +0800
"GET
"Mozilla/5.0(Macintosh;
IntelMac0SX10_14_1)AppleWebKit/537.36(KHTML，1ikeGecko)Chrome/73.0.3683.86Safari/537.36
10.0.0.1
08/Apr/2019:10:35:06
+0800
"GET
/code/index.html
HTTP/1.1"
404571“-"
"Mozilla/5.0(Macintosh;
Intel
Mac0SX10_
AppleWebKit/537.36（KHTML，
likeGecko)Chrome/73.0.3683.86Safari/537.36
10.0.0.1
[08/Apr/2019:10:35:06+0800]
"GET/code/index.htmlHTTP/1.1404571"-*Mozilla/5.0(Macintosh；Intel Mac0SX10_14_1)AppleWebKit/537.36（KHTML，likeGecko)Chrome/73.0.3683.86Safari/537.36"
10.0.0.1
[08/Apr/2019:10:35:07+0800]
10.0.0.1
[08/Apr/2019:10:38:40+0800]
"GET/HTTP/1.1"
"Mozilla/5.0(Macintosh;IntelMac0Sx10_14_1)Appl
ebKit/537.36（KHTML，1ikeGecko) Chrome/73.0.3683.86Safari/537.36
10.0.0.1
[08/Apr/2019:10:47:41+ +0800 "GET/HTTP/1.1" Intel Mac0SX10_14_1)AppleWebKit/537.36(KHTML
like Gecko)Chrome/73.0.3683.86Safari/537.36"
10.0.0.1
[08/Apr/2019:10:47:42+0800]
"GET/HTTP/1.1"
3040"_"
"Mozilla/5.0(Macintosh;Intel Mac0SX10_14_1）AppleWebKit/537.36（KHTML, ,likeGecko)Chrome/73.0.3683.86Safari/537.36"
10.0.0.1--
[08/Apr/2019:10:47:42+0800]
"GET/HTTP/1.1"3040“-"
"Mozilla/5.0(Macintosh;IntelMac0SX10_14_1）AppleWebKit/537.36（KHTML，
like Gecko)Chrome/73.0.3683.86Safari/537.36"
“”
10.0.0.1
[08/Apr/2019:10:47:42+0800]
"GET /HTTP/1.1"
3040"-"
"Mozilla/5.0(Macintosh;Intel Mac0SX10_14_1)AppleWebKit/537.36（KHTML, likeGecko)Chrome/73.0.3683.86Safari/537.36"
10.0.0.1
[08/Apr/2019:10:47:42+0800]“GET/HTTP/1.1"3040"
"Mozilla/5.0（Macintosh;IntelMacOSX10_14_1)AppleWebkKit/537.36（KHML，likeGecko)Chrome/73.0.3683.86Safari/537.36
[root@elkstack03logs]#
```
<!-- OCR_END -->

## 通过Logstash收集nginx日志输出到ES中

```bash
[root@elkstack03 ~]# cd /etc/logstash/conf.d/
[root@elkstack03 conf.d]# vim /etc/logstash/conf.d/nginx_es.conf
input {
  file {
    path => "/usr/local/nginx/logs/access_json.log"
    start_position => "end"
    type => "nginx_access"
    codec => json
  }
}
output {
    elasticsearch {
      hosts => ["10.0.0.51:9200"]
      index => "nginx_access-%{+YYYY.MM.dd}"
   }
}
#检测Logstash语法
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/nginx_es.conf -t
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/nginx_es.conf &
```

打开浏览器，访问：<http://10.0.0.51:9100/>

<!-- OCR_START -->
- →不安全|10.0.0.51:9100
- 应用T周报TTS系统
- Elasticsearch
- http://10.0.0.51:9200/
- 连接
- elk-cluster
- 集群健康值：green（134of134）
- 信息
- 概览索引|数据浏览基本查询[+]复合查询[+]
- tomcat_access-
- nginx_access-
- .kibana
- omcat_access-
- 2019.03.31
- secure_log_2019.03.30
- message_log_2019.03.31
- message_log_2019.03.30
- es_log_2019.04.01
- size:11.1ki
- 2019.04.08
- size:6.94ki(13.9ki)
- size:27.7ki(55.3ki)
- size:14.0ki(28.1ki)
- size:12.9ki (25.8ki)
- (19.5ki)
- ize:345ki（690ki)
- size:40.2ki(80.4ki)
- docs:1（2)
- size:260B（10.8ki)
- docs:4（8)
- docs:2（4)
- ocs:71(142)
- docs:11（22)
- 信息动作
- 动作
<!-- OCR_END -->

￼

***

将ES中的索引添加到Kibana中

打开浏览器，访问：<http://10.0.0.54:5601/> Kibana页面

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/management?_g=（refreshlnterval:(display:Off,pause:!f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd）)
- 应用
- 周报TTS系统
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
- 不安全|10.0.0.54:5601/app/kibana#/man
- %5DYYYY.MM.DD?_g=（refr
- l:(display:Off,pa
- 应用
- T周报TTS系统
- Management/ Kibana/Indices
- kibana
- IndexPatterns
- Saved Objects Advanced Settings
- Discover
- +Add New
- Visualize
- [tomcat_access-]YYYY.MM.DD
- Dashboard
- Timelion
- Thispagelistseveryfield inthe[tomcat_access-]YYYY.MM.DDindexandthefield'sass
- coretypeasrecordedbyElasticsearch.whilethislistallowsyoutoviewthecoretypeof
- eachfield,changingfieldtypesmustbedoneusingElasticsearch'sMappingAPI
- DevTools
- Management
- Thisindex usesaTime-based indexpatternwhichrepeatsDaily
- Filter
- Fields(36)
- Scripted fields(0)
- Sourcefilters(o)
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
- https://www.driverzting.com
<!-- OCR_END -->

<!-- OCR_START -->
A不安全|10.0.0.54:5601/app/kibana#/management/kibana/index/?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode：quick,to:now%2Fd)
应用T周报TTS系统
★[tomcat_access-])YYY.MM.DD
kibana
Configure anindexpattern
Discover
InordertouseKibanayoumustconfigureatleastoneindexpattern.IndexpatternsareusedtoidentifytheElasticsearchindextorunsearchandanalyticsagainst.Theyarealsousedto
Visualize
configure fields.
Dashboard
Indexnameorpattern
Timelion
Patterns allowyouto define dynamicindexnames.Statictextinanindexname isdenoted usingbrackets.Example:[logstash-JYYYY.MM.DD.Pleasenote thatweeksaresetupto use
DevTools
ISOweekswhichstartonMonday.
Management
[nginx_access-]YYYY.MM.DD
Indexcontainstime-basedevents
refreshfields
@timestamp
Useeventtimestocreateindexnames[DEPRECATED]
Time-intervalbased indexpatternsaredeprecated!
We stronglyrecommend usingwildcardpatternnames insteadof time-interval based indexpatterns.
Kibana isnowsmartenoughtoautomaticallydeterminewhichindicestosearch againstwithinthecurrent timerangeforwildcard indexpatterns.Thismeansthatwildcard
indexpatternsnowget the sameperformance optimizations when searchingwithina timerangeastime-intervalpatterns.
Indexpatterninterval
Daily
Patternmatches100%ofexistingindices and aliases
·nginx_access-2019.04.08
Create
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/discover?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））_a=（columns:！_source),index:%5Bnginx_access-%5DYYYY.MM...
- 应用
- T周报TTS系统
- kibana
- t_index
- #_score
- Time
- _source
- t_type
- April 8th 2019,10:57:10.000
- referer:-type:nginx_accesshttp_host:10.0.0.53 ur1:/index.html path:/usr/local/nginx/logs/access_json.log upstreamhost:-
- Discover
- tclientip
- @timestamp:April 8th 2019,10:57:10.000size:0clientip:10.0.0.1 domain:10.0.0.53host:10.0.0.53@version:1
- Visualize
- tdomain
- responsetime:0xff:-upstreamtime:-status:304_id:AWn64NACxCtS9Tdyw_C7_type:nginx_access_index:nginx_access-2019.04.
- thost
- 08_score:
- Dashboard
- thttp_host
- Timelion
- Table
- JSON
- Linkto/nginx_access-2019.04.08/nginx_access/AWn64NACxCtS9Tdyw_C7
- tpath
- DevTools
- treferer
- @timestamp
- QApril8th2019，10:57:10.000
- #responsetime
- Management
- eversion
- Q*1
- #size
- _id
- Q*AWn64NACxCtS9Tdyw_C7
- tstatus
- m*nginx_access-2019.04.08
- Q*
- tupstreamhost
- Q*nginx_access
- tupstreamtime
- turl
- Q10.0.0.1
- txff
- ④Q*10.0.0.53
- @@*/usr/local/nginx/logs/access_json.log
- Q0
- Q*304
- upstreamtime
- Q*/index.html
- xff
- Collapse
<!-- OCR_END -->

￼

***

```bash
yum install nginx

vim /etc/nginx/nginx.conf
# http段添加
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

[root@e3 yum.repos.d]# cat /etc/nginx/conf.d/chou.xudao.com.conf
server {
	server_name www.chou.xudao.com;
	listen 80;
	access_log /var/log/nginx/www.chou.xudao.com_access.log json;
	location / {
		root /code/chou;
		index index.html;
	}
}
[root@e3 yum.repos.d]# cat /etc/nginx/conf.d/www.xudao.conf
server {
	server_name www.xudao.com;
	listen 80;
	access_log /var/log/nginx/www.xudao.com_access.log json;
	location / {
		root /code/www;
		index index.html;
	}
}

[root@e3 yum.repos.d]# cat /code/chou/index.html
www.chou.xudao.com
[root@e3 yum.repos.d]# cat /code/www/index.html
www.xudao.com

#检查语法
nginx -t
#启动nginx
systemctl start nginx

#windows 浏览  添加hosts 解析 C:\Windows\System32\drivers\etc\hosts
10.0.0.22 www.chou.xudao.com
10.0.0.22 www.xudao.com

#logstash 实例配置
[root@e3 yum.repos.d]# cat /etc/logstash/conf.d/nginx_es.conf
input {
  file {
    path => "/var/log/nginx/www.chou.xudao.com_access.log"
    start_position => "end"
    type => "www.chou.xudao.com"
    codec => json
  }
  file {
    path => "/var/log/nginx/www.xudao.com_access.log"
    start_position => "end"
    type => "www.xudao.com"
    codec => json
  }
}
output {
    elasticsearch {
      hosts => ["10.0.0.20:9200"]
      index => "%{type}-%{+YYYY.MM.dd}"
   }
}

```

> 更新: 2024-09-20 15:01:38  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/un3rg7>