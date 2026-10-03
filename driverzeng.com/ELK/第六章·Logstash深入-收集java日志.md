# 第六章·Logstash深入-收集java日志

## 通过Logstash收集java日志并输出到ES中

因为我们现在需要用Logstash收集tomcat日志，所以我们暂时将tomcat安装到Logstash所在机器，也就是db03：10.0.0.53这台机器，收集tomcat访问日志以及tomcat错误日志进行实时统计，在企业中，tomcat机器肯定不是单台，而是一个集群的形式，那么我们每台tomcat上都需要安装一个Logstash，然后将收集到的日志输出给Elasticsearch进行分析。

***

### 将tomcat日志改成json格式

在企业中，我们看到tomcat日志遇到异常(exception)一条日志可能是几行或者十几行甚至几十行，组成的，那么，我们需要将多行日志变成一行日志，来收集。

这里我们有几种方式可以实现：

1.将日志改成Json格式

在企业中，想要将java日志改成json格式，并没有那么容易。

格式不是你想改，想改就能改，让我挣开，让我明白，放手你的爱~~~~

因为将日志改成Json格式，查看起来会很难受，有些开发人员不希望将日志格式改成Json的，所以，在改日志格式之前需要跟开发人员进行沟通，那么将tomcat日志格式改成Json格式也有两种方式。

1）开发自己更改，通过程序代码，或者log4j

2）运维修改tomcat的server配置文件

```bash
#编辑tomcat配置文件
[root@elkstack03 ~]# vim conf/server.xml
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="tomcat_access_log" suffix=".log"
               pattern="{&quot;clientip&quot;:&quot;%h&quot;,&quot;ClientUser&quot;:&quot;%l&quot;,&quot;authenticated&quot;:&quot;%u&quot;,&quot;AccessTime&quot;:&quot;%t&quot;,&quot;method&quot;:&quot;%r&quot;,&quot;status&quot;:&quot;%s&quot;,&quot;SendBytes&quot;:&quot;%b&quot;,&quot;Query?string&quot;:&quot;%q&quot;,&quot;partner&quot;:&quot;%{Referer}i&quot;,&quot;AgentVersion&quot;:&quot;%{User-Agent}i&quot;}"/>
```

2.通过Logstash其他模块来收集例：multiline多行匹配

以下是tomcat日志文件中exception展示

<!-- OCR_START -->
```text
[root@elkstacko3~]#catcatlina.out
org.apache.coyote.http11.AbstractHttp11Processor.process Error parsing HTTP request header
Note: further occurrences of HTTP header parsing errors will be logged at DEBUG level.
java.lang.IllegalArgumentException:Invalid character found in method name.HTTP method names must be tokens
at org.apache.coyote.http11.AbstractNioInputBuffer.parseRequestLine(AbstractNioInputBuffer.java:233)
at org.apache.coyote.http11.AbstractHttp11Processor.process(AbstractHttp11Processor.java:1017)
atorg.apache.coyote.AbstractProtocol$AbstractConnectionHandler.process(AbstractProtocol.java:684)
at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1520)
at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.run(NioEndpoint.java:1476)
atjava.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
atorg.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
atjava.lang.Thread.run(Thread.jhttps5)/www.driverzeng.com
```
<!-- OCR_END -->

￼

<!-- OCR_START -->
```text
[root@elkstack03~]#catcatlina.out
com.alibaba.druid.stat.DruidStatService]unregistermbeanerror
javax.management.InstanceNotFoundException:com.alibaba.druid:type=DruidStatService
atcom.sun.jmx.interceptor.DefaultMBeanServerInterceptor.getMBean(DefaultMBeanServerInterceptor.java:1095)
atcom.sun.jmx.interceptor.DefaultMBeanServerInterceptor.exclusiveUnregisterMBean(DefaultMBeanServerInterceptor.java:427)
atcom.sun.jmx.interceptor.DefaultMBeanServerInterceptor.unregisterMBean(DefaultMBeanServerInterceptor.java:415)
atcom.sun.jmx.mbeanserver.JmxMBeanServer.unregisterMBean(JmxMBeanServer.java:546)
at
com.alibaba.druid.stat.DruidStatService.unregisterMBean(DruidStatService.java:374)
atcom.alibaba.druid.stat.DruidDataSourceStatManager.removeDataSource(DruidDataSourceStatManager.java:202)
at
com.alibaba.druid.pool.DruidDataSource$2.run(DruidDataSource.java:1479)
at
java.security.AccessController.doPrivileged(NativeMethod)
atcom.alibaba.druid.pool.DruidDataSource.unregisterMbean(DruidDataSource.java:1475)
atcom.alibaba.druid.pool.DruidDataSource.close(DruidDataSource.java:1434)
atsun.reflect.NativeMethodAccessorImpl.invokeo(NativeMethod)
atsun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
atsun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
atjava.lang.reflect.Method.invoke(Method.java:606)
atorg.springframework.beans.factory.support.DisposableBeanAdapter.invokeCustomDestroyMethod(DisposableBeanAdapter.java:354)
atorg.springframework.beans.factory.support.DisposableBeanAdapter.destroy(DisposableBeanAdapter.java:277)
atorg.springframework.beans.factory.support.DefaultSingletonBeanRegistry.destroyBean(DefaultSingletonBeanRegistry.java:578)
atorg.springframework.beans.factory.support.DefaultSingletonBeanRegistry.destroySingleton(DefaultSingletonBeanRegistry.java:554)
atorg.springframework.beans.factory.support.DefaultListableBeanFactory.destroySingleton(DefaultListableBeanFactory.java:972)
at
org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.destroySingletons(DefaultSingletonBeanRegistry.java:523)
atorg.springframework.beans.factory.support.DefaultListableBeanFactory.destroySingletons(DefaultListableBeanFactory.java:979)
atorg.springframework.context.support.AbstractApplicationContext.destroyBeans(AbstractApplicationContext.java:1006)
atorg.springframework.context.support.AbstractApplicationContext.doClose(AbstractApplicationContext.java:982)
at
org.springframework.context.support.AbstractApplicationContext.close(AbstractApplicationContext.java:934)
atorg.springframework.web.context.ContextLoader.closeWebApplicationContext(ContextLoader.java:583)
atorg.springframework.web.context.ContextLoaderListener.contextDestroyed(ContextLoaderListener.java:116)
atorg.apache.catalina.core.StandardContext.listenerStop(StandardContext.java:4900)
atorg.apache.catalina.core.StandardContext.stopInternal(StandardContext.java:5537)
atorg.apache.catalina.util.LifecycleBase.stop(LifecycleBase.java:221)
atorg.apache.catalina.core.ContainerBase$StopChild.call(ContainerBase.java:1424)
atorg.apache.catalina.core.ContainerBase$StopChild.call(ContainerBase.java:1413)
at
java.util.concurrent.FutureTask.run(FutureTask.java:262)
java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
atjava.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
java.lang.Thread.run（Thread.java:745）
```
<!-- OCR_END -->

￼

***

### 安装tomcat

**安装JDK环境**

**<u>下载地址:</u>** <http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html>

```bash
#解压JDK安装包
[root@elkstack03 ~]# tar xf jdk-8u121-linux-x64.tar.gz
#将JDK安装包移动到安装目录下
[root@elkstack03 ~]# mv jdk1.8.0_121 /usr/local/
#做软链接(方便日后升级)
[root@elkstack03 ~]# ln -s /usr/local/jdk1.8.0_121 /usr/local/jdk1.8
#添加环境变量
[root@elkstack03 ~]# vim /etc/profile.d/jdk1.8.sh
export JAVA_HOME=/usr/local/jdk1.8
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
#加载环境变量
[root@elkstack03 ~]# source /etc/profile
#检查是否加载成功
[root@elkstack03 ~]# java -version
java version "1.8.0_121"
Java(TM) SE Runtime Environment (build 1.8.0_121-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode)

----------------------------------------------------------------
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

**安装tomcat**

```bash
#解压tomcat安装包
[root@elkstack03 ~]# tar xf apache-tomcat-8.0.38.tar.gz
#将安装包移动到安装路径并改名
[root@elkstack03 ~]# mv apache-tomcat-8.0.38 /usr/local/tomcat-8.0.38
#做软链接
[root@elkstack03 ~]# ln -s /usr/local/tomcat-8.0.38 /usr/local/tomcat
#进入tomcat站点目录
[root@elkstack03 ~]# cd /usr/local/tomcat/webapps/
#创建新项目目录
[root@elkstack03 webapps]# mkdir webdir
#写一个测试页面到站点目录下的index.html文件中
[root@elkstack03 webapps]# echo 'zls tomcat page' > webdir/index.html
#进入tomcat程序目录
[root@elkstack03 webapps]# cd /usr/local/tomcat/bin/
#启动tomcat
[root@elkstack03 bin]# ./catalina.sh start
#检测tomcat端口是否启动
[root@elkstack03 bin]# netstat -lntup|grep 8080
tcp        0      0 :::8080                     :::*                        LISTEN      12569/java
-------------------------------------------------------------------------------------
tar xf apache-tomcat-8.0.38.tar.gz
mv apache-tomcat-8.0.38 /usr/local/tomcat-8.0.38
ln -s /usr/local/tomcat-8.0.38 /usr/local/tomcat
cd /usr/local/tomcat/webapps/
 mkdir webdir
echo 'zls tomcat page' > webdir/index.html
cd /usr/local/tomcat/bin/
./catalina.sh start

 netstat -lntup|grep 8080
```

启动成功后，打开浏览器，访问：<http://10.0.0.53:8080/webdir/>

<!-- OCR_START -->
←→C不安全|10.0.0.53:8080/webdir/
应用
zls tomcat page
<!-- OCR_END -->

￼

***

### 修改tomcat日志格式

```bash
#进入tomcat配置文件目录
[root@elkstack03 ~]# cd /usr/local/tomcat/conf
#编辑server配置文件
[root@elkstack03 conf]# vim /usr/local/tomcat/conf/server.xml
#在138行 (在Host标签里的 替换掉<Valve 内容)，添加如下内容
<Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="tomcat_access_log" suffix=".log"
               pattern="{&quot;clientip&quot;:&quot;%h&quot;,&quot;ClientUser&quot;:&quot;%l&quot;,&quot;authenticated&quot;:&quot;%u&quot;,&quot;AccessTime&quot;:&quot;%t&quot;,&quot;method&quot;:&quot;%r&quot;,&quot;status&quot;:&quot;%s&quot;,&quot;SendBytes&quot;:&quot;%b&quot;,&quot;Query?string&quot;:&quot;%q&quot;,&quot;partner&quot;:&quot;%{Referer}i&quot;,&quot;AgentVersion&quot;:&quot;%{User-Agent}i&quot;}"/> 

#进入tomcat程序目录
[root@elkstack03 conf]# cd /usr/local/tomcat/bin/
#停止tomcat
[root@elkstack03 bin]# ./catalina.sh stop
#启动tomcat
[root@elkstack03 bin]# ./catalina.sh start
#进入tomcat日志目录
[root@elkstack03 bin]# cd /usr/local/tomcat/logs/
#查看新生成的tomcat日志
[root@elkstack03 logs]# ll
总用量 40
-rw-r--r-- 1 root root 14601 3月  31 10:10 tomcat_access_log.2019-03-31.log
#实时跟进日志
[root@elkstack03 logs]# tail -f tomcat_access_log.2019-03-31.log
```

打开浏览器，访问：<http://10.0.0.53:8080/webdir/>

<!-- OCR_START -->
←→C①不安全|10.0.0.53:8080/webdir/
用应用
zls tomcat page
<!-- OCR_END -->

￼

<!-- OCR_START -->
1.root@elkstacko3:/usr/local/tomcat/logs(ssh)
ck01:~（ssh）91
...t@elkstack02:~（ssh）32
X.cal/tomcat/logs(ssh）3
..logstash/conf.d(ssh）34
[root@elkstack03logs]#tail-ftomcat_access_log.2019-03-31.log
","AgentVersion":"Mozilla/5.0(Macintosh
entVersion":"Mozilla/5.0(Macintosh;Intel Mac OSX10_14_1) AppleWebKit/537.36(KHTML,like Gecko)Chrom
Ome/72.0.3626.119Safari/537.36"}
ww.driverzeng.com
<!-- OCR_END -->

￼

***

### 验证Json格式

复制一条日志，打开浏览器，访问：<http://www.kjson.com/>

<!-- OCR_START -->
- ←→Q
- A不安全|www.kjson.com
- 应用
- Helloworld，今天是03月31日（星期日）。
- kjson
- JSON
- Google
- 格式化工具
- 转换工具
- 加密/解密
- 常用对照表
- 常用工具
- 理财
- 电台
- 博客
- 合作
- 关于
- json格式化校验工具省钱达人：淘宝购物优惠券领取
- {"clientip":"10.0.0.1","clientUser":"-","authenticated":"-","AccessTime":"[31/Mar/2019:10:15:37 +0800]","method":"GET
- /favicon.ico HTTP/1.1","status":"200","SendBytes":"21630","Query?
- string":"*,"partner":"http://10.0.0.53:8080/webdir/","AgentVersion":"Mozi1la/5.0(Macintosh;Intel Mac 0S X10_14_1)
- AppleWebKit/537.36(KHTML,1ike Gecko) Chrome/72.0.3626.119 Safari/537.36")
- 10
- 11
- 13
- 14
- https//www.driverzeng.com
- 校验
- 清空
- 微信交流群
<!-- OCR_END -->

￼

<!-- OCR_START -->
| 个 | 个 | 个 | 个 | 个 | 排名 |
| --- | --- | --- | --- | --- | --- |
| Helloworld，今天是03月31日（星期日）。 | kison | JSON- | Google | 格式化工具 | 转换工具 |
| 加密/解密 | 常用对照表 | 常用工具 | 理财 | 电台 | 博客 |
| 合作 | 关于 | json格式化校验工具省钱达人：淘宝购物优惠券领取 | "clientip": "10.0.0.1", | 10 | 11 |
| 10_14_1)Apple | ebKit/537.36（KHTML，1ike | ecko)Chrome/72.0.3626.119 | 12 | Safari/537.36" | 13 |
| 14 | 15 | 16 | 17 | 18 | 19 |
<!-- OCR_END -->

### 配置Logstash收集tomcat日志输出到ES中

```bash
#进入Logstash配置文件目录
[root@elkstack03 logs]# cd /etc/logstash/conf.d/
#编辑Logstash配置文件
[root@elkstack03 conf.d]# vim /etc/logstash/conf.d/tomcat_es.conf
#输入插件
input {
#文件模块
  file {
#文件路径
    path => "/usr/local/tomcat/logs/tomcat_access_log.2024-09-20.log"
#从结束位置点开始收集
    start_position => "end"
#日志类型
    type => "tomct_access_log"
  }
}
#输出插件
output {
#ES模块
    elasticsearch {
#主机信息
      hosts => ["10.0.0.51:9200"]
#索引名称，也就是日志名称
      index => "tomcat_access-%{+YYYY.MM.dd}"
#输出成json格式
      codec => "json"
  }
}
#启动Logstash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/tomcat_es.conf &
```

启动成功，如下图所示：

<!-- OCR_START -->
```text
Could notfindlog4j2
Elastics
S=>{:removed=>], :added=>[http://10.0.0.51:9200/]}}
10:43:05.824[[main]-pipeline-man INFO logstash.outputs.elasticsearch Running health check to see if an Elasticsearch connection is working {:healthcheckurl=>http://10.0.0.51:9200/, :path="/"3 10:43:05.973[[main]-pipeline-mar ager]
WARN
logstash.outputs.elasticsearch
Restored connection to ES instance {:url=>#<URI: :HTTP:0x3a69fae8 URL:http://10.0.0.51:9200/>}
0:43:05.978
[[main]-pipeline-ma ager]
INFO
logstash.outputs.
elasti
from {:path=>nil}
ger]
INFO
logstash.outputs.elastics
oinstalltemplate{:man nage_template=>{"template"=>"logstash-*", "version"=>50001, "settings"=>{"index.refresh_interval"=>"5s"}, " "match_mapping_type"=>"string", "fields"=>{"keyword"=>{"type"=>"keyword"}}}?}], "include_in-all"=>false?, norms"=>false
"@version"=>{"type"=>"keyword", "include_in_all"= lse}, jeoip"=>{"d
erties"=>{"ip"=>{"type"=>"ip"}, "location"
,"latitude"=>"type"=>"half_ float"y,"longitude">"type">"half-float"}}}3"
"pr
logstash.outputs.elasticsearch - New Elasticsearch output {:class=>"LogStash::Outputs:ElasticSearch", :hosts=>[#<URI::Generic:0x9d2923f URL:/10.0.0.51:9200>]}
logstash.pipeline
0:43:14.177
r]INFO
hpinelin
ipeline
main started
10:43:14.288 [Api Webserver] INF0 logstash.agent
Successfully
started Logstash API endpoint {:port=>9601}
```
<!-- OCR_END -->

打开浏览器，访问：<http://10.0.0.51:9100/> 查看是否生成日志，如果没有，则访问tomcat页面。

<!-- OCR_START -->
- →Q
- ①不安全|10.0.0.51:9100
- 应用
- Elasticsearch
- http://10.0.0.51:9200/
- 连接elk-cluster
- 信息
- 概览 索引 数据浏览 基本查询 [+]  复合查询[+]
- 集群概览
- ViewAlias
- IndexFilter
- 刷新
- tomcat_access
- zls_2019.03.30
- zls_2019.03.27
- zls_2019.03.05
- secure_l1og_2019.03.30
- message_log_2019.03.31
- message_log_2019.03.30
- 2019.03.31
- 170ki)
- (30.0ki)
- 2ki (11.6ki)
- ize:21.0ki(42.1ki)
- ize:13.9ki(27.8ki)
- docs:19(38)
- docs:5(10)
- docs:1(2)
- docs:3(6)
- docs:2(4)
- 信息动作
- 动作
- 01234
- 4
- elk01
- 5
- 2
- 3
- 1234
- elk02
<!-- OCR_END -->

### 将tomcat日志索引添加到Kibana中

<!-- OCR_START -->
A不安全|10.0.0.54:5601/app/kibana#/mar
应用T周报TTS系统
Warning
No default indexpattern.
kibana
Youmust select or create oneto
continue.
Configure an index pattern
Discover
In orderto use Kibana you must configure at least one index pattern.Index patterns are used to identify the Elasticsearchindextorun search and analytics against.Theyare also used to
Visualize
configure fields.
Dashboard
Index name or pattern
Timelion
Patterns allow you to define dynamic index names. Static text in an index name is denoted using brackets. Example: [logstash-JYYYY.MM.DD. Please note that weeks are setup to use
DevTools
ISO weeks which start on Monday.— Date Format Documentation
Management
[tomcat_access-]YYYY.MM.DD
Indexcontainstime-basedevents
Time-field name
refreshfields
@timestamp
Use event times to create index names [DEPRECATED]
Time-intervalbasedindexpatternsaredeprecated!
We stronglyrecommend using wildcard patternnames instead of time-interval based index patterns.
Kibana is now smart enough to automatically determine which indices to search against within the current time range for wildcard index patterns. This mea
ansthatwildcard
index patterns now get the same performance optimizations when searching within a time range as time-interval patterns.
Indexpatterninterval
Daily
Patternmatches100% of existing indices and aliases
·tomcat_access-2019.03.31
·tomcat_access-2019.04.08
Create
Collapse
<!-- OCR_END -->

查看日志内容，不难发现，即便是用了Json格式的，所有日志在message中还是 `一坨` 看起来很麻烦，并不是以`KEY：VALUE`的形式展示出来的。

<!-- OCR_START -->
A不安全|10.0.0.54:5601/app/kibana#/discover?_g=(refreshlnterval:(display:Off,pause:!f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd))&_a=(columns:(_source),index:%5Btomcat_access-%5DYYYY.M...
应用
T周报TTS系统
kibana
[tomcat_access-JYYYY.MM.DD
April8th 2019, 00:00:00.000 - April 8th 2019, 23:59:59.999 — by.30 minutes
Selected Fields
?_source
Visualize
Available Fields
Dashboard
@timestamp
8
Timelion
t@version
tAccessTime
DevTools
@timestamp per 30 minutes
tAgentVersion
Time
Management
tClientUser
tQuery?string
April 8th 2019, 09:34:28.607
path:/usr/local/tomcat/logs/tomcat_access_log.2019-04-08.log @timestamp: April 8th 2019,09:34:28.607 @version:1 host:0.0.0.0
tSendBytes
message:{"clientip":"10.0.0.1","ClientUser":"-","authenticated":"-","AccessTime":"[08/Apr/2019:09:34:27 +0800]","method":"GET /favic
t_id
on.ico HTTP/1.1","status":"200","SendBytes":"21630","Query?string":"","partner":"http://10.0.0.53:8080/webdir/","AgentVersion":"Mozill
t _index
a/5.0 (Macintosh; Intel Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/73.0.3683.86 Safari/537.36"} type: tomct_acce
#_score
ss_log_id:AWn6lRc-xCtS9Tdyw_CE_type:tomct_access_log_index:tomcat_access-2019.04.08_score:
t_type
Table
JSON
Link to/tomcat_access-2019.04.08/tomct_access_log/AWn6lRc-xCtS9Tdyw_CE
tauthenticated
t clientip
@Qm*April8th2019，09:34:28.607
thost
@Q*1
tmessage
Q*AWn61Rc-xCtS9Tdyw_CE
tmethod
Qm*tomcat_access-2019.04.08
tpartner
@Q*
t path
Qm*tomct_access_log
tstatus
Q*0.0.0.0
message
@Q*{"clientip":"10.0.0.1","ClientUser":"-","authenticated":"-","AccessTime":"[08/Apr/2019:09:34:27+0800]","method":"GET /favicon.ico HTTP/1.
1","status":"200","SendBytes":"21630","Query?string":"","partner":"http:/10.0.0.53:8080/webdir/","AgentVersion":"Mozilla/5.0 (Macintosh;In
tel Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML，like Gecko) Chrome/73.0.3683.86 Safari/537.36"}
@Qm*/usr/local/tomcat/logs/tomcat_access_log.2019-04-08.log
<!-- OCR_END -->

所以，我们需要获取到message中的`KEY：VALUE`将他解析成键值对的形式，展现出来

```bash
vim /etc/logstash/conf.d/tomcat_es.conf
#在Logstash的配置文件中，添加filter过滤规则
filter {
        json {
            source => "message"
        }
}
#重新启动Logstash
[root@elkstack03 ~]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/tomcat_es.conf &
```

再次查看日志内容

<!-- OCR_START -->
er?_g=(refreshlnte
al:(display:Off,p
ue:0),tir
S-%5DYYY
应用
T周报TTS系统
April 8th 2019, 09:43:28.744 authenticated:- method:GET /webdir/ HTTP/1.1 AgentVersion:Mozilla/5.0 (Macintosh; Intel Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73
Ren
Table JSON
Linkto/tomcat_access-2019.04.08/tomct_access_log/AWn6nVVPxCtS9Tdyw_CI
o@timestamp
Q *April 8th 2019,09:43:28.744
t@version
Q*1
tAccessTime
@Q *[08/Apr/2019:09:43:21 +0800]
tAgentVersio
@ Q  *Mozilla/5.0 (Macintosh;Intel Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML，like Gecko) Chrome/73.0.3683.86 Safari/537.36
tClientUser
Q四*-
tQuery?strin
@Q*
tSendBytes
t_id
@Q*AWn6nVVPxCtS9Tdyw_CI
t_index
@Q*tomcat_access-2019.04.08
#_score
t_type
@Q*tomct_access_log
tauthenticat
d@Q*
tclientip
@Q*10.0.0.1
thost
@Q*0.0.0.0
tmessage
Q*{"clientip":"10.0.0.1","ClientUser":"-","authenticated":"-","AccessTime":"[08/Apr/2019:09:43:21 +0800]","method":"GET/webdir/ HTTP/1.1","status":"304","SendByte
s":"-","Query?string":"","partner":"-","AgentVersion":"Mozilla/5.0 (Macintosh; Intel Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86
Safari/537.36"}
tmethod
Q*GET/webdir/HTTP/1.1
tpartner
tpath
@Q*/usr/local/tomcat/logs/tomcat_access_log.2019-04-08.log
tstatus
Q*304
ttvpe
@Qm*tomct_access_log
April 8th 2019, 09:34:28.607 path:/usr/local/tomcat/logs/tomcat_access_log.2019-04-08.log @timestamp:April 8th 2019, 09:34:28.607 @version:1 host:0.0.0.0 message:"clientip":"10.0.0.
Link to /tomcat_access-2019.04.08/tomct_access_log/AWn61Rc-xCtS9Tdyw_CE
@timestamp
Q*April 8th 2019,09:34:28.607
Q*AWn6LRc-xCtS9Tdyw_CE
QM*{"clientip":"10.0.0.1","ClientUser":"-","authenticated":"-","AccessTime":"[08/Apr/2019:09:34:27 +0800]","method":"GET /favicon.ico HTTP/1.1","status":"200","SendByte
s":"21630","Query?string":"","partner":"http://10.0.0.53:8080/webdir/","AgentVersion":"Mozilla/5.0 (Macintosh; Intel Mac 0S × 10_14_1) AppleWebKit/537.36 (KHTML，1ik
eGecko)Chrome/73.0.3683.86Safari/537.36"3
<!-- OCR_END -->

两条日志对比，可以看出修改后的Logstash日志，前面多出很多KEY，虽然还message里还是有`一坨`，但是message中的所有Json已经被解析出来变成了`KEY：VALUE`的形式，当然我们也可以取消message的显示，操作如下：

```bash
vim /etc/logstash/conf.d/tomcat_es.conf
#讲Logstash中的filter规则添加一行，remove_field，删除列 message
filter {
        json {
            source => "message"
            remove_field => ["message"]
        }
}
#重新启动Logstash  #之前启动的停止了

[root@elkstack03 ~]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/tomcat_es.conf &
```

再次查看日志，可以看到message已经没有了，但是所有的`KEY：VALUE`都还在。

为什么要这么做呢，一定要展示成Json格式呢？

因为，如果我们想要Kibana画图，那么必须用`KEY：VALUE`的形式，获取值，来画图。

<!-- OCR_START -->
- 应用
- T周报TTS系统
- kibana
- tAgentVersion
- t ClientUser
- Time
- _source
- tQuery?string
- April 8th 2019, 09:54:48.683
- authenticated:- method: GET /favicon.ico HTTP/1.1 Agentversion: Mozilla/5.0 (Macintosh; Intel Mac 0S X 10_14_1) AppleWebKit/537.3
- Discover
- tSendBytes
- 6 (KHTML，like Gecko) Chrome/73.0.3683.86 Safari/537.36 type: tomct_access_log sendBytes: 21630 path:/usr/local/tomcat/logs/tomca
- Visualize
- t _id
- t_access_log.2019-04-08.log AccessTime: [08/Apr/2019:09:54:39 +0800] Query?string:@timestamp: April 8th 2019, 09:54:48.683
- t _jindex
- partner:http://10.0.0.53:8080/webdir/ clientip:10.0.0.1@version:1host:0.0.0.0 clientUser:-status:200_id:AWn6p7U9xCt
- Dashboard
- index:tomcat_access-2019.04.08
- #_score
- 8
- Timelion
- t_type
- Table
- JSON
- Linkto/tomcat_access-2019.04.08/tomct_access_log/AWn6p7U9xCtS9Tdyw_c0
- DevTools
- tauthenticated
- t clientip
- @timestamp
- @Q* April 8th 2019,09:54:48.683
- Management
- thost
- t@version
- @Q*1
- tmessage
- tAccessTime
- @Q*[08/Apr/2019:09:54:39 +0800]
- tmethod
- @ Q m * Mozilla/5.0 (Macintosh;Intel Mac 0S X 10_14_1) AppleWebKit/537.36 (KHTML，like Gecko） Chrome/73.0.3683.86 Safari/537.36
- tpartner
- @Q*
- tpath
- t status
- Q*21630
- @Q四*AWn6p7U9xCtS9Tdyw_Co
- t_index
- Q*tomcat_access-2019.04.08
- tomct_access_log
- tauthenticated@Q四*
- @Q*10.0.0.1
- @Q*0.0.0.0
- @Q  * GET /favicon.ico HTTP/1.1
- @Q*http://10.0.0.53:8080/webdir/
- @@m*/usr/local/tomcat/logs/tomcat_access_log.2019-04-08.log
- @Q*200
- @Qm* tomct_access_log
<!-- OCR_END -->

***

```bash
#生产环境一般直接收集 这个日志文件（这个文件会每天自动切割，但是最新的文件还是这个） /usr/local/tomcat/logs/catalina.out
[root@e3 tomcat]# cat /etc/logstash/conf.d/tomcat_es.conf
input {
  file {
    path => "/usr/local/tomcat/logs/tomcat_access_log.*"
    start_position => "beginning"
    type => "tomct_access_log"
  }
}
output {
    elasticsearch {
      hosts => ["10.0.0.20:9200"]
      index => "tomcat_access-%{+YYYY.MM.dd}"
      codec => "json"
  }
}

```

***

## 使用multiline插件收集java日志

使用codec的multiline插件实现多行匹配，这是一个可以将多行进行合并的插件，而且可以使用what指定将匹配到的行与前面的行合并还是和后面的行合并，<https://www.elastic.co/guide/en/logstash/current/plugins-codecs-multiline.html>

因为目前tomcat日志中没有exception，所以，我们把Logstash部署在ES上，收集一下ES的java日志。

**安装JDK环境**

**<u>下载地址:</u>** <http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html>

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
```

**安装Logstash**

**<u>下载地址:</u>** <https://www.elastic.co/downloads/past-releases/logstash-5-3-0>

```bash
#安装Logstash使用yum localinstall 自动安装依赖包
[root@elkstack03 ~]# yum localinstall -y logstash-5.3.0.rpm
#给Logstash目录授权
[root@elkstack03 ~]# chown -R logstash.logstash /usr/share/logstash/
```

***

| 测试标准输入标准输出多行匹配 |
| --- |

```bash
#编辑Logstash配置文件
[root@elkstack03 ~]# vim /etc/logstash/conf.d/java.conf
input {
        stdin {
        codec => multiline {
#当遇到[开头的行时候将多行进行合并
        pattern => "^\["
#true为匹配成功进行操作，false为不成功进行操作
        negate => true
#与上面的行合并，如果是下面的行合并就是next
        what => "previous"
        }}
}
output {
        stdout {
        codec => rubydebug
        }
}
#测试多行匹配数据
[root@elkstack01 ~]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/java.conf
```

<!-- OCR_START -->
[root@elkstack01~]#/usr/share/logstash/bin/logstash-f/etc/logstash/conf.d/java.conf
WARNING: Could not find logstash.yml which is typically located in $LS_HOME/config or /etc/logstash. You can specify the path using --path.settings. Continuing using the defaults
Could not find log4j2 configuration at path /usr/share/logstash/config/log4j2.properties. Using default config which logs to console
14:53:37.275[main]-pipeline-manager] INF0
logstash.pipeline - Starting pipeline {"id"=>"main", "pipeline.workers"=>1, "pipeline.batch.size"=>125, "pipeline.batch.delay"=>5, "pipeline.max_inflight"=>125}
14:53:44.844 [[main]-pipeline-manager] INF0 logstash.pipeline - Pipeline main started
The stdin plugin is now waiting for input:
14:53:44.896 [Api Webserver] INF0 logstash.agent - Successfully started Logstash API endpoint {:port=>9600}
zls
nice
ooy
[bg
"@timestamp" => 2019-03-31T06:54:13.728Z,
"@version"
=>
"1",
"host"
"0.0.0.0".
"message"
="zls\nis\nnice\nboy",
"tags" => [
[0]"multiline"
very
ugly[yes]
[oldboy
"@timestamp"
=> 2019-03-31T06:54:42.738Z,
=>
"[bgx\nvery\nugly[yes]",
<!-- OCR_END -->

￼

***

| 测试将日志写入到文件中 |
| --- |

```bash
[root@elkstack01 ~]# vim /etc/logstash/conf.d/eslog_file.conf
input {
  file {
    path => "/data/elk/logs/elk-cluster.log"
    type => "es-log"
    start_position => "beginning"
    codec => multiline {
    pattern => "^\["
    negate => true
    what => "previous"
  }}
}
output {
   file {
    path =>  "/tmp/es_log.txt"
   }
}
#启动Logstash
[root@elkstack01 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/eslog_file.conf &
```

<!-- OCR_START -->
"path":"/data/elk/logs/elk-cluster.log",
:"2019-04-01T15:48:23.182Z","@version": "1","host":"0.0.0.0","message":"[2019-04-01T23:47:12,935][INF0 J[o.e.n.Node
][elk01] initializing ...","type":"es-log"}
sage":"[2019-04-01T23:47:13,068][INF0 ][o.e.e.NodeEnvironment
] [elk01] using [1] data paths, mounts [[/ (/dev/mapper/
e [17.2gb], spins? [possibly],
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.187Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:13,069][INF0 J[o.e.e.NodeEnvironment
］ [elk01] heap size [1015.6mb], compressed ordinary obje
tpointers[true]",
"type":"es-log"}
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.187z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:13,150][INF0 J[o.e.n.Node
][elk01] node name [elk01]，node ID [by_wSvkYQ5ycGlHxWC
WoQ]",
pe":"es-log'
sage":"[2019-04-01T23:47:13,150][INF0 J[o.e.n.Node
][elk01] version[5.3.0]，pid[7207],build[3adb13b/2017
03-23T03:31:50.652Z], 0S[Linux/2.6.32-431.el6.x86_64/amd64], JVM[Oracle Corporation/Java HotSpot(TM) 64-Bit Server VM/1.8.0_121/25.121-b13]","type":"es-log"3
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.191z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:14,518][INF0 J[o.e.p.PluginsService
] [elk01] loaded module [aggs-matrix-stats]","type":"es-
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.192Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:14,518][INF0 J[o.e.p.PluginsService
] [elko1] loaded module [ingest-common]","type":"es-log"
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.193Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:14,518][INF0 J[o.e.p.PluginsService
] [elko1] loaded module [lang-expression]","type":"es-lo
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.195Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:14,518][INF0 J[o.e.p.PluginsService
] [elko1] loaded module [lang-mustache]","type":"es-log"
] [elko1] loaded module [lang-painless]","type":"es-log"
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.197Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:14,518][INF0 ][o.e.p.PluginsService
] [elk01] loaded module [percolator]","type":"es-log"}
":"2019-04-01T15:48:23.437Z"
e":"[2019-04-01T23:47:14,518][INF0
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.440Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:14,518][INF0 J[o.e.p.PluginsService
] [elk01] loaded module [transport-netty3]","type":"es-l
g"了
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.441z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:14,518][INF0 J[o.e.p.PluginsService
] [elk01] loaded module [transport-netty4]","type":"es-l
g"}
"path" :"/data/elk/logs/elk-cluster.log","@timestamp" :"2019-04-01T15:48:23.442Z","@version":"1","host":"0.0.0.0","message": "[2019-04-01T23:47:14,522][INF0 J[o.e.p. PluginsService
] [elk01] no plugins loaded","type":"es-log"?
e": "[2019-04-01T23:47:18,454][INFO ]o.e.n.Node
][elk01] starting
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.447Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:18,732][INF0 J[o.e.t.TransportService
] [elk01] publish_address {10.0.0.51:9300}, bound_addres
ses {[::]:93003","type":"es-log"}
":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.450Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:18,740][INF0 J[o.e.b.BootstrapChecks  ] [elk01] bound or publishing to a non-loopback or non-l
"path":"/data/elk/logs
ssage":"[2019-04-01T23:47:22,119][INF0 J[o.e.c.s.ClusterService ］ [elk01] detected_master {elk023{iYV6jXoFQsaJJCTBXtaoWA
3YIBPqUMgRQORdq7B8WJEMO310.0.0.52}10.0.0.52:9300}, added felk02}{iYV6jXoFQsaJJCTBXtaoWA3-{YIBPqUMgRQORdq7B8WJEMO3[10.0.0.52}[10.0.0.52:9300},3,reason:zen-disco-receivefrom master [master elk02}iY6jXoFQsaJJCTBXtaoWAH-YIBPqUMgRQORd
a7B8wJEMQ3{10.0.0.523{10.0.0.52:9300} committed version [155]])","type":"es-log"3
"path":"/data/elk/logs/elk-cluster.log","@timestamp":"2019-04-01T15:48:23.457Z","@version":"1","host":"0.0.0.0","message":"[2019-04-01T23:47:22,238][INF0 J[o.e.h.n.Netty4HttpServerTransport] [elk01] publish_address {10.0.0.51:9200}, boun
root@elkstac
<!-- OCR_END -->

***

| 将结果输出到ES中 |
| --- |

```bash
#编写Logstash配置文件
[root@elkstack01 ~]# vim /etc/logstash/conf.d/eslog_es.conf
input {
  file {
    path => "/data/elk/logs/elk-cluster.log"
    type => "es-log"
    start_position => "beginning"
    codec => multiline {
    pattern => "^\["
    negate => true
    what => "previous"
  }}
}
output {
  elasticsearch {
    hosts =>  ["10.0.0.51:9200"]
    index => "es_log_%{+YYYY.MM.dd}"
  }
}
#启动Logstash
[root@elkstack01 ~]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/eslog_es.conf &
```

打开浏览器，访问：<http://10.0.0.51:9100/>

<!-- OCR_START -->
- C不要全10:0.0.519100
- 90
- Elasticsearch
- Mtp:/1000.519200/
- ek-cluster
- 概宽素数浏览基本童询[+]复合查[+】
- YA
- zls_2019.03.30
- zls_2019.03.05
- (11.68)
- secure_log_2019.03.30
- 80.3/
- 1
- DM
- 012
- 01234
- 0123
- 345
- 5
- 23④
- 0234
- 023
<!-- OCR_END -->

> 更新: 2024-09-20 12:24:26  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ifvvu5>