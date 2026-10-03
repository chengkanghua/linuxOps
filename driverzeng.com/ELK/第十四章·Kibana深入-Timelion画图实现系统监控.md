# 第十四章·Kibana深入-Timelion画图实现系统监控

## 什么是Timelion？

Timelion使你可以轻松获得以下问题的答案：

1）随着时间的推移，每个唯一的用户会查看多少个页面?

2）这个星期五和上周五之间的交通量有什么不同？

3）今天有多少日本人口来到我的网站？

4）标准普尔500指数的10日均线是多少？

5）过去两年收到的所有搜索请求的累计总和是多少？

　　`Timelion`是Kibana时间序列的可视化工具。时间序列可视化是可视化的，以时间顺序分析数据。`Timelion`可用于绘制二维图形，时间绘制在x轴上。

　　与使用简单的条形图或线条可视化相比有什么优势？`Timelion`采取不同的方法。使用`Timelion`特定语法，您通过将功能链接在一起来定义图形，而不是使用可视化编辑器创建图表。该语法启用了经典点系列图不提供的一些功能，如将不同索引或数据源的数据绘制到一个图形中。

但是在使用`Timelion`之前，我们需要下载并安装`Metricbeat`

## Metricbeat介绍及部署

| Metricbeat介绍 |
| :--- |

`Metricbeat`可以定期收集操作系统和服务器的运行指标（CPU，内存，硬盘，IO,读写速度，进程等等），`Metricbeat`可以将收集到的指标和数据发送到你指定的输出，比如：elasticsearch，logstash,redis等等，最终达成监视服务器的目标。

| Metricbeat部署及配置 |
| :--- |

因为我们使用的ES和Kibana是5版本的，所以我们需要下载5版本的`Metricbeat`

```bash
#RPM包下载
[root@elkstack04 ~]# wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.3.3-x86_64.rpm
#源码包下载
# wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.3.3-linux-x86_64.tar.gz
#安装Metricbeat
yum localinstall -y metricbeat-5.3.3-x86_64.rpm
#修改配置文件
[root@elkstack04 ~]# vim /etc/metricbeat/metricbeat.yml
#==========================  Modules configuration ============================
metricbeat.modules:
#------------------------------- System Module -------------------------------
- module: system
  metricsets:
    # CPU stats
    - cpu
    # System Load stats
    - load
    # Per CPU core stats
    #- core
    # IO stats
    #- diskio
    # Per filesystem stats
    - filesystem
    # File system summary stats
    - fsstat
    # Memory stats
    - memory
    # Network stats
    - network
    # Per process stats
    - process
    # Sockets (linux only)
    #- socket
  enabled: true
  period: 1m
  processes: ['.*']
#================================ Outputs =====================================
# Configure what outputs to use when sending the data collected by the beat.
# Multiple outputs may be used.
#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["10.0.0.51:9200"]
  # Optional protocol and basic auth credentials.
  #protocol: "https"
  #username: "elastic"
  #password: "changeme"
  #要加载仪表板，可以在metricbeat设置中启用仪表板加载。当仪表板加载被启用时，Metricbeat使用Kibana API来加载样本仪表板。只有当Metricbeat启动时，才会尝试仪表板加载。
  # 设置kibana服务地址
  setup.kibana.host: "10.0.0.54:5601"
  # 加载默认的仪表盘样式
  setup.dashboards.enabled: true
  # 设置如果存在模板，则不覆盖原有模板
  setup.template.overwrite: false
  
#启动Metricbeat(CentOS6)
# /etc/init.d/metricbeat start
#启动Metricbeat(CentOS7)
systemctl start metricbeat
#检查metricbeat是否正常运行（返回索引对应内容）
[root@elkstack04 ~]# curl -XGET 'http://10.0.0.51:9200/metricbeat-*/_search?pretty'
```

结果如下：

<!-- OCR_START -->
- 1.root@elkstack04:~(ssh)
- t@elkstack01:~（ssh）1×..t@elkstack02:~（ssh）2×.logstash/conf.d（ssh）3×@elkstack04:~（ssh）34
- X..ver-zeng:~（bash)5
- [root@elkstack04~]#curl-xGET'http://10.0.0.51:9200/metricbeat-*/_search?pretty
- "took":3，
- "timed_out”:false,
- '_shards":{
- "total":6,
- "successful":6,
- "failed":0
- 了，
- 'hits":{
- "total":98,
- "max_score":1.0,
- "_index":"metricbeat-2019.04.12",
- "_type”:"metricsets",
- "_id":"AWoPMV4hxCtS9Tdyw_gq"，
- _score":1.0,
- "_source”:{
- "@timestamp'
- :"2019-04-12T01:37:34.285Z",
- "beat”：{
- "hostname":"elkstack04"，
- "name"”:"elkstack04"，
- "version":“5.3.3"
- "metricset":{
- “module":"system"，
- "name":“filesystem",
- "rtt":1142
- "system":{
- "filesystem”:{
- "available":15576846336,
- "device_name":"/dev/mapper/vg_db01-lv_root",
- "files":1152816,
- "free":16520142848,
- "free_files":1078169，
- "mount_point":"/"
- "total":18569568256,
- "used":{
- "bytes":2049425408,
- "pct":0.1104
<!-- OCR_END -->

打开浏览器，访问：<http://10.0.0.51:9100/>

查看Metricbeat索引

<!-- OCR_START -->
- 不安全|10.0.0.51:9100
- 应用T周报TTS系统
- Elasticsearch
- http:/10.0.0.51:9200/
- 连接elk-cluster
- en(326of326)
- 信息
- 概览索引数据浏览基本查询[+]复合查询[+]
- ngx_zls-
- ngx_log-
- metricbeat-
- 2019.04.08
- 2019.04.11
- 2019.04.09
- nginx_access-
- 2019.04.12
- secure_log_2019.03.30
- size:271ki
- size:305ki
- size:121ki
- size:232ki
- size:1.18Mi
- message_log_2019.03.31
- message_log_2019.03.30
- size:6.94ki(13.9ki)
- (607ki)
- (610ki)
- (230ki)
- (507ki)
- (2.39Mi)
- size:27.7ki(55.3ki)
- size:14.0ki(28.1ki)
- docs:1(2)
- docs:16(32)
- size:262ki(524ki)
- docs:218(436)
- docs:66(132)
- docs:201(415)
- docs:1,942
- docs:90(180)
- docs:4（8)
- docs:2（4)
- 信息动作
- 信惠
- (3,884)
- 动作
- 4
- 3
- 5
<!-- OCR_END -->

打开浏览器，访问：<http://10.0.0.54:5601/>

添加`metricbeat-*`索引

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kib
- nt?_g=（filter
- rs:!0,ref
- %2Fd,r
- ode:quick,to:now%2Fd))
- Gy
- 应用T周报TTS系统
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
- 应用
- T周报TTS系统
- Management/Kibana/Indices
- kibana
- IndexPatternsSavedObjectsAdvancedSettings
- Discover
- +AddNew
- Visualize
- ★[tomcat_access-])YY.MM.D
- [tomcat_access-JYYYY.MM.DD
- Dashboard
- [logstash-www.driverzeng.com-]jYY...
- [logstash_rsyslog-YYY.MM.DD
- 8
- Timelion
- [m.driverzeng.com-]YYY.MM.DD
- Thispagelistseveryfieldinthe[tomcat_access-JYYYY.MM.DDindexandthefield’sassociatedcoretypeasrecordedbyElasticsearch.Whilethislistallowsyoutoviewthecoretypeof
- [m.elk.com-JYY.MM.DD
- eachfield,changingfieldtypesmustbedoneusingElasticsearch'sMappingAPI
- DevTools
- [nginxaccess-JY.MM.DD
- Management
- ThisindexusesaTime-based indexpatternwhichrepeatsDaily
- [ngx.log-JYYY.M.DD
- [tc_log-]YYYY.MM.DD
- [tcp_log-]YYY.MM.D
- [www.driverzeng.com-]YYY.MM.DD
- Filter
- [www.elk.com-JYYY.MM.DD
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
- type.keyword
- clientip
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
不安全|10.0.0.54:5601/app/kibana#/management/kibana/index/?_g=（fiters:10,refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd）)
应用
T周报TTS系统
Management / Kibana
kibana
IndexPatternsSavedObjectsAdvancedSettings
Discover
★[tomcat_access-]YYY.MM.DD
Visualize
[logstash-www.driverzeng.com-jYY....
Configure an index pattern
logstash_rsyslog-YY.MM.D
Dashboard
[m.driverzeng.com-jYYY.MM.DD
InordertouseKibana youmustconfigureatleastoneindexpattern.lndexpatternsareusedtoidentifytheElasticsearchindextorunsearchandanalyticsagainst.Theyarealsousedto
Timelion
[m.elk.com-]YY.MM.DD
configure fields.
[nginx_access-]YY.MM.DD
DevTools
[ngxlog-]YYYY.MM.DD
Indexnameorpattern
Management
[t_log-YY.MM.D
Patterns allowyoutodefine dynamicindexnamesusing*as awildcard.Example:logstash-*
[tcp_log-JYYYY.MM.DD
[www.driverzeng.com-JYY.MM.DD
metricbeat-*
[www.elk.com-JYYY.MM.DD
Indexcontainstime-based events
Time-fieldnamerefreshfields
postgresql.bgwriter.stats_reset
docker.healthcheck.event.end_date
system.proce.cpu.sta
tawithinthecurrently
postgresql.activity.qurystart
@timestamp
ecurrenttimerange.
postgresql.activity.state_change
mongodb.status.local.time
mongodbstatusbackgroundfuhing.lastinished
postgresql.activity.transaction_sta
ceph.monitor_health.last_updated
postgresql.activity.backend_start
docker.image.created
docker.ealthcheckevnt.stad
postgresql.database.statsreset
Collapse
<!-- OCR_END -->

创建后，即可在`Discover`中看到`Metricbeat`信息

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/discover?_g=（filters:！),refreshlnterval:（display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd）&_a=（columns:(_source)index:metricbeat-*interval:au.
- 应用
- T周报TTS系统
- kibana
- metricbeat-*
- April12th20190:00:00.000April2h201923:59:59.99by30minut
- Selected Fields
- Discover
- 2,000
- ?_source
- 1,500
- Visualize
- AvailableFields
- 1,000
- Dashboard
- @timestamp
- 500
- 8
- Timelion
- tid
- t_index
- DevTools
- @timestamp per30minutes
- #_score
- Time
- Management
- t_type
- tbeat.hostname
- April 12th 2019,10:00:34.347
- @timestamp:April12th 2019,10:00:34.347beat.hostname:elkstack04 beat.name:elkstack04 beat.version:5.3.3
- tbeat.name
- metricset.module:System metricset.name:process metricset.rtt:22,246 system.process.cpu.start_time:April 11th 2019,01:32:47.
- tbeat.version
- 000system.process.cpu.total.pct:0system.process.fd.limit.hard:4,096system.process.fd.limit.soft:1,024
- tmetricset.module
- system.process.fd.open:O system.process.memory.rss.bytes:O system.process.memory.rss.pct:O system.process.memory.share:0
- metricset.name
- #metricset.rtt
- Linkto/metricbeat-2019.04.12/metricsets/AWoPRmtAxCtS9TdyxADx
- Table
- JSON
- #system.cpu.cores
- #system.cpu.idle.pct
- Q*April12th2019,10:00:34.347
- #system.cpu.iowait.pct
- @Q*AWoPRmtAxCtS9TdyxADx
- #system.cpu.irq.pct
- Q*metricbeat-2019.04.12
- #system.cpu.nice.pct
- @Q*
- #system.cpu.softirq.pct
- @*metricsets
- #system.cpu.steal.pct
- Q*elkstack04
- #system.cpu.system.pct
- #system.cpu.user.pct
- Q5.3.3
- #system.filesystem.available
- *system
- tsystem.filesystem.device_name
- tmetricset.name
- @Q*process
- #system.filesystem.files
- #system.filesystem.free
- Q*22,246
- system.process.cpu.start_time
- @Q*April11th2019,01:32:47.000
- #system.filesystem.free_files
- tsystem.flesystem.mount_point
- #system.process.cpu.total.pct
- Collapse
- #system.flesystem.total
- #system.process.fd.limit.hard
- httpw:/wwww.driverzeng.com
<!-- OCR_END -->

## Timelion使用Metricbeat

| 创建时间序列可视化 |
| :--- |

使用Metricbeat的时间序列数据带你浏览Timelion提供的一些函数。

创建第一个可视化将比较在用户空间中花费的CPU时间与一小时的结果偏移量的实时百分比，为了创建这个可视化，我们需要创建两个Timelion表达式，一个是system.cpu.user.pct的实时平均数，另一个是1小时的平均偏移量。

首先，需要在第一个表达式中定义`index`、`timefield`和`metric`，并在`Timelion`查询栏中输入以下表达式。

```bash
.es(index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct')
```

<!-- OCR_START -->
- 应用
- T周报TTS系统
- New
- Add
- Save
- Delete Open Options Docs
- Today
- kibana
- .es(*)
- auto
- Discover
- 500
- q：*>count
- Visualize
- Dashboard
- 400
- Timelion
- 300
- DevTools
- Management
- 18:0020:0022:00
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
| C | C | C | C | 排名 |
| --- | --- | --- | --- | --- |
| kibana | es(index=metricbeat-*,timefield=@timestamp',metric='avg:system.cpu.user.pct) | auto | Discover | 500 |
| 0.0045 | q:*>count | Visualize | 0.0040 | Dashboard |
| 400 | B | Timelion | 0.0035 | 300 |
| Dev Tools | 0.0030 | 中 | Management | 200 |
| 0.0025 | 100 | 0.0020 | 0.0015 | 14:0016:00 |
<!-- OCR_END -->

现在需要添加另一个具有前一小时数据的系列，以便进行比较，为此，你必须向.es()函数添加一个`offset`参数，`offset`将用日期表达式偏移序列检索。对于本例，你希望将数据偏移一小时，并使用日期表达式-1h，使用逗号分隔这两个系列，在Timelion查询栏中输入以下表达式：

```bash
.es(index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct'), .es(offset=-1h,index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct')
```

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#_g=（refreshlnterval:(display:Off,pause:1f,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd））_a=（colur
- mns:2,interval:auto,ro
- 应用T周报TTS系统
- New
- Add
- Save
- Delete
- Open
- Options
- Docs
- Today
- kibana
- .es(index=metricbeat-*,timefield=@timestamp'metric=avg:system.cpu.user.pct),.es（offset=-1h,index=metricbeat-*,timefield=@timestamp',metric=avg:system.cpu.user.pct）)
- uto
- Discover
- 500
- 0.0045
- q:*>count
- Visualize
- q:*>avg(system.cpu.user.pct)
- Dashboard
- 400
- 0.0040
- 8
- Timelion
- 0.0035
- 300
- DevTools
- 0.0030
- Management
- 200
- 0.0025
- 100
- 0.0020
- 0.0015
- 04:0006:00
- 18:0020:0022:00
- ②
- 14:0016:00
- 3
- Collapse
<!-- OCR_END -->

很难区分这两个系列，自定义标签以便于区分它们，你总是可以将.label()函数附加到任何表达式以添加自定义标签，在Timelion查询栏中输入以下表达式来定制标签：

```bash
.es(offset=-1h,index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('last hour'), .es(index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('current hour')
```

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd））_a=（columns:2,interval:auto,ro.
- 应用T周报TTS系统
- New
- Add
- SaveDeleteOpenOptionsDocs
- Today
- kibana
- es（offset=-1h,index=metricbeat-*,timefield=@timestampmetric=avg:system.cpu.user.pct）.label(lasthour),.es（index=metricbeat-*,timefield=@timestampmetric=avg:system.cpu.user.pct').label(curre
- auto
- Discover
- 600
- 0.0045
- q:*>count
- Visualize
- q:*>avg(system.cpu.user.pct)
- 500
- 0.0040
- Dashboard
- 8
- Timelion
- 400
- 0.0035
- DevTools
- 300
- 0.0030
- Management
- 200
- 0.0025
- 100
- 0.0020
- 0.0015
- 0.004
- lasthour
- currenthour
- ③00:00
- ④
- Collapse
<!-- OCR_END -->

保存完整的Timelion工作表作为Metricbeat示例，作为一种最佳实践，你应该在完成本教程的过程中保存对本工作表所做的任何重要更改。

<!-- OCR_START -->
- A不安全10.0.0.54:5601/app/timelion#?_a=（columns:2,interval:auto,rows:2,selected:3,sheet:!es(*),'es(index%3Dmetricbeat-*,%20timefield%3D!@timestamp!,%20metric%3D!'avg:syste
- 应用
- T周报TTS系统
- New
- Add
- DeleteOpenOptionsDocsToday
- kibana
- SaveentireTimelionsheet
- YouwanthisoptionifyoumostlyuseTimelionexpressi
- sionsfromwithintheTimelionappanddon'tneedtoaddTimelionchartstoKibanadashboards.Youmayalsowantthisifyoumakeuseofreferencestootherpanels.
- Visualize
- SavecurrentexpressionasKibanadashboardpanel
- Dashboard
- NeedtoaddacharttoaKibana dashboard?Wecandothat!Thisoptionwill saveyourcurrentlyselectedexpressionasapanelthatcanbeaddedtoKibanadashboardsasyouwouldaddanythingelse.Note,if youuse
- referencestootherpanelsyouwill needtoremovetherefencesbycopyingthereferencedexpressiondirectlyintotheexpressionyouaresaving.Clickacharttoselectadifferentexpressiontosave.
- 8
- Timelion
- DevTools
- .es（offset=-1h,index=metricbeat-*,timefield=@timestamp'metric=avg:system.cpu.user.pct）.label(lasthour),.es(index=metricbeat-*，timefield=@timestamp'metric=avg:system.cpu.user.pct）.labelcurre
- auto
- Manage
- 600
- 0.0060
- q:*>count
- q:*>avg(system.cpu.user.pct)
- 0.0055
- 500
- 0.0050
- 400
- 0.0045
- 0.0040
- 300
- 0.0035
- 200
- 0.0030
- 0.0025
- 100
- 0.0020
- 0.0015
- ②00:00
- lasthour
- currenthour
- 1
- Collapse
- https://www.driverzeng.coo30
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#？_a=（columns:2,interval:auto,rows:2,selected:3,sheet:(es(*).es(index%3Dmetricbeat-*%20timefield%3D!@timestamp!,%20metric%3D!avg:system.cpu.user.pct!),.e..
- 应用
- T周报TTS系统
- NewAdd
- Save
- kibana
- DeleteOpenOptionsDocs<OToday>
- SaveentireTimelionsheet
- Youwant thisoptionif youmostlyuseTimelionexpressionsfromwithintheTimelionappanddon'tneedtoaddTimelionchartstoKibanadashboards.Youmayalsowant thisif youmakeuseof referencestootherpanels.
- Visualize
- Savesheetas
- Dashboard
- 创建时间序列可视化
- Timelion
- DevTools
- SavecurrentexpressionasKibanadashboardpanel
- NeedtoaddacharttoaKibanadashboard?WecandothatThisoptionwillsaveyourcurrentlyselectedexpressionasapanelthatcanbeaddedtoKibanadashboardsasyouwouldaddanythingelse.Note,if youuse
- referencestootherpanelsyouwillneedtoremove therefencesbycopyingthereferencedexpressiondirectlyintotheexpressionyouaresaving.Clickacharttoselectadifferentexpressiontosave.
- es（offset=-1h,index=metricbeat-*，timefield=@timestamp'metric=avg:system.cpu.user.pct'）.label(lasthour),.es（index=metricbeat-*,timefield=@timestamp'metric=avg:system.cpu.user.pct).label(curre
- auto
- 600
- 0.0060
- q:*>count
- q:*>avg(system.cpu.user.pct)
- 0.0055
- 500
- 0.0050
- 400
- 0.0045
- 0.0040
- 300
- 0.0035
- 200
- 0.0030
- 0.0025
- 100
- 0.0020
- 0.0015
- ②00:0
- lasthour
- currenthour
- Collapse
- https://www.driverzeng.cofo50
<!-- OCR_END -->

***

| 定制和格式化可视化 |
| :--- |

Timelion有很多定制选项，你几乎可以使用可用的函数对图表的每个方面进行个性化设置，执行以下修改。

1\)添加一个标题

2\)更改系列类型

3\)改变一个系列的颜色和不透明度

4\)修改图例

之前用两个系列创建了一个时间轴图表，让我们继续定制这个可视化。

在进行任何其他修改之前，将`title()`函数附加到表达式的末尾，以添加具有有意义名称的标题，这将使不熟悉的用户更容易理解可视化目的。对于这个示例，将`title('CPU usage')`添加到原始系列中，在Timelion 查询栏中使用以下表达式：

```bash
.es(offset=-1h,index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('last hour'), .es(index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('current hour').title('CPU usage')
```

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#/？_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd）&_a=（columns:2,interval:auto,.
- 应用
- T周报TTS系统
- New
- AddSaveDelete
- OpenOptionsDocs
- Today
- kibana
- es（offset=-1h,index=metricbeat-*,timefield=@timestamp'metric=avg:system.cpu.user.pct).label(lasthour),.es（index=metricbeat-*,timefield=@timestamp'metric=avg:system.cpu.user.pct）.labelcurre
- auto
- Discover
- CPUusage
- Visualize
- 0.0070
- lasthour
- currenthour
- Dashboard
- 0.0060
- 8
- Timelion
- 0.0050
- DevTools
- 0.0040
- Management
- 0.0030
- 0.0020
- 0.0010
- ①00:00
- Collapse
<!-- OCR_END -->

为了进一步区分过去一小时系列，你将把图表类型更改为区域图表，为了做到这一点，你需要使用`.lines()`函数来定制折线图，你将设置fill和width参数，分别设置折线图的填充和折线宽度。在本例中，你将通过添加`.lines(fill=1,width=0.5)`将填充级别设置为1，边框宽度设置为0.5，在Timelion查询栏中使用以下表达式：

```bash
.es(offset=-1h,index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('last hour').lines(fill=1,width=0.5), .es(index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('current hour').title('CPU usage')
```

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#/?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd））&_a=（columns:2,interval:auto,r.
- 川I应用T周报TTS系统
- New
- Add
- SaveDelete
- OpenOptionsDocs
- <Today
- kibana
- es（offset=-1h,index=metricbeat-*,timefield=@timestampmetric=avg:system.cpu.user.pct）.label(lasthour).lines（fil=1,width=0.5),.es(index=metricbeat-*,timefield=@timestampmetric=avg:system.cpu.
- auto
- Discover
- CPUusage
- Visualize
- 0.0070
- 0.007
- lasthour
- currenthour
- Dashboard
- 0.0060
- 0.006
- Timelion
- 0.005
- 0.0050
- DevTools
- 0.004
- 0.0040
- Management
- 0.003
- 0.0030
- 0.002
- 0.0020
- 0.001
- 0.0010
- 0.000
- Collapse
<!-- OCR_END -->

让我们给这些系列涂上颜色，使当前的小时系列比过去一个小时系列流行一点，`color()`函数可用于更改任何系列的颜色，并接受标准颜色名称、十六进制值或分组系列的颜色模式。对于这个示例，你将在过去一个小时使用`.color(gray)`，而在当前小时使用`.color(#1E90FF)`，在Timelion查询栏中输入以下表达式进行调整：

```bash
.es(offset=-1h,index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('last hour').lines(fill=1,width=0.5).color(gray), .es(index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('current hour').title('CPU usage').color(#1E90FF)
```

<!-- OCR_START -->
- A不安全10.0.0.54:5601/app/timelion#/?_g=（refreshinterval:(display:Off,pause:lf,value:0),time:from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd））_a=（columns:2,interval:auto,r.
- 应用
- T周报TTS系统
- New
- Add
- SaveDeleteOpenOptionsDocs
- <OToday
- kibana
- es（offset=-1h,index=metricbeat-*timefield=@timestampmetric=avg：system.cpu.user.pct）.label(asthour）.ines（fil=1width=0.5)）.color(gray).es（index=metricbeat*,timefield=@timestampmetric=avg
- auto
- Discover
- CPUusage
- Visualize
- 0.0070
- 0.007
- lasthour
- currenthour
- Dashboard
- 0.006
- 0.0060
- 8
- Timelion
- 0.005
- 0.0050
- Dev Tools
- 0.004
- 0.0040
- 0.003
- 0.0030
- 0.002
- 0.0020
- 0.001
- 0.0010
- 0.000
- 20:0022:00
- 06:0008:0010:0012:0014:0016:0018:0020:0022:00
- Collapse
<!-- OCR_END -->

最后但并非最不重要，调整图例，使其占用尽可能小的空间，你可以使用`.legend()`函数来设置图例的位置和样式。在本例中，通过将`.legend(columns=2, position=nw)`两列追加到原始系列，将图例放置在可视化的西北位置，使用以下表达式进行调整：

```bash
.es(offset=-1h,index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('last hour').lines(fill=1,width=0.5).color(gray), .es(index=metricbeat-*, timefield='@timestamp', metric='avg:system.cpu.user.pct').label('current hour').title('CPU usage').color(#1E90FF).legend(columns=2, position=nw)
```

<!-- OCR_START -->
- 应用
- T周报TTS系统
- New
- Add
- SaveDelete
- Open Options Docs
- Today
- kibana
- es（offset=-1hindex=metricbeat-*,tmefield=@timestampmetric=avg:system.cpu.user.pct）.label（lasthour).lines（fil=1,width=0.5）.color(gray).es（index=metricbeat-*,timefield=@timestampmetric=av:
- auto
- Discover
- CPUusage
- Visualize
- 0.0070
- 0.007
- lasthour
- currenthour
- Dashboard
- 0.0060
- 0.006
- Timelion
- 0.005
- 0.0050
- DevTools
- 0.004
- Management
- 0.0040
- 0.003
- 0.0030
- 0.002
- 0.0020
- 0.001
- 0.0010
- 0.000
- 20:0022:00
- ②0：00
- 04:0006:0008:0010:0012:0014:0016:0018:0020:0022:00
- Collapse
<!-- OCR_END -->

保存下来，再创建一个新的。

<!-- OCR_START -->
- 2Fd))&
- 应用
- 周报TTS系统
- kibana
- New
- Add
- ete
- Open
- Options
- Docs
- <Today
- SaveentireTimelionsheet
- You wantthisoptionif youmostlyuseTimelionexpressions from within theTimelionappand don'tneed to addTimelionchartstoKibana dashboards.Youmayalsowant thisif youmake use of referencesto otherpanels.
- Visualize
- Savesheetas
- Dashboard
- 定制和格式化可视化
- Timelion
- DevTools
- Management
- SavecurrentexpressionasKibanadashboardpanel
- NeedtoaddacharttoaKibanadashboard?Wecandothat!ThisoptionwillsaveyourcurrentlyselectedexpressionasapanelthatcanbeaddedtoKibana dashboardsasyouwouldaddanythingelse.Note,if youuse
- referencestootherpanelsyou will need toremove therefencesbycopyingthereferenced expression directly into theexpressionyouaresaving.Clickachart toselecta differentexpressionto save.
- es（offset=-1h,index=metricbeat-*，timefield=@timestamp'metric=avg:system.cpu.user.pct).label(lasthour).lines（fil=1,width=0.5).color(gray),.es(index=metricbeat-*,timefield=@timestamp'metric=avg：
- auto
- CPUusage
- 0.0070
- 0.007
- last hour
- currenthour
- 0.0060
- 0.006
- 0.005
- 0.0050
- 0.004
- 0.0040
- 0.003
- 0.0030
- 0.002
- 0.0020
- 0.001
- 0.0010
- 0.000
- 20:0022:00
- Collapse
<!-- OCR_END -->

***

| 使用数学函数 |
| :--- |

在前两部分中，已经学习了如何创建和样式化Timelion可视化，本节将探索Timelion提供的数学函数。你将继续使用Metricbeat数据为入站和出站网络流量创建新的Timelion可视化，首先，需要在工作表中添加一个新的Timelion可视化。

在顶部菜单中，单击`Add`添加第二个可视化，当添加到工作表中时，你会注意到查询栏已经被替换为默认的`.es(*)`表达式，这是因为查询与你选择的Timelion工作表上的可视化相关联。

开始跟踪入站/出站网络流量，你的第一个表达式将计算`system.network.in.bytes`的最大值，将下面的表达式输入到你的Timelion查询栏：

```bash
.es(index=metricbeat*, timefield=@timestamp, metric=max:system.network.in.bytes)
```

<!-- OCR_START -->
- 应用
- T周报TTS系统
- kibana
- New
- Add
- Save
- Delete
- Open
- Options
- Docs
- Tod
- .es（index=metricbeat*,timefield=@timestamp,metric=max:system.network.in.bytes)
- auto
- Discover
- 225000000
- Visualize
- q:
- 222500000
- Dashboard
- 8
- Timelion
- 220000000
- DevTools
- 217500000
- Management
- 215000000
- 212500000
- 210000000
- 207500000
<!-- OCR_END -->

在绘制变化率时，监视网络流量更有价值，`derivative()`函数就是这样做的 - 绘制值随时间的变化，通过在表达式末尾添加`.derivative()`可以很容易地做到这一点，使用以下表达式来更新你的可视化：

```bash
```

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#？_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd）&_a=（colun
- mns:2,interval:auto,ro
- 应用
- T周报TTS系统
- New
- Add
- Save Delete Open Options Docs
- <Today
- kibana
- .es(index=metricbeat*,timefield=@timestamp,metric=max:system.network.in.bytes
- derivative0
- auto
- Discover
- 225000000
- 2500000
- Visualize
- q:*>max(system.network.in.bytes)
- 222500000
- Dashboard
- 2000000
- 8
- Timelion
- 220000000
- DevTools
- 1500000
- 217500000
- Management
- 215000000
- 1000000
- 212500000
- 500000
- 210000000
- 207500000
- 02:0004:0006:0008:00
- ②
- 02:0004:0006:0008:0010:0012:0014:0016:0018:0020:0022:00
<!-- OCR_END -->

现在是出站流量，你需要为`system.network.out.bytes`添加类似的计算，由于出站流量将离开你的机器，因此将此指标表示为负数是有意义的，`.multiply()`函数将系列乘以一个数字，这个数字是系列或系列列表的结果。对于本例，你将使用`.multiply(-1)`将出站网络流量转换为负值，使用以下表达式来更新你的可视化：

```bash
.es(index=metricbeat*, timefield=@timestamp, metric=max:system.network.in.bytes).derivative(), .es(index=metricbeat*, timefield=@timestamp, metric=max:system.network.out.bytes).derivative().multiply(-1)
```

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quid
- ns:2,interval:auto,ro...
- 应用
- T周报TTS系统
- NewAdd
- Save
- Delete
- Open
- Options Docs
- Today
- kibana
- .es（index=metricbeat*,timefield=@timestamp,metric=max:system.network.in.bytes）.derivative0,.es（index=metricbeat*,timefield=@timestamp,metric=max:system.network.out.bytes）.derivative0.multiply(
- auto
- Discover
- 225000000
- 2500000
- Visualize
- q:*>max(system.network.in.bytes)
- 222500000
- Dashboard
- 20000
- Timelion
- 220000000
- DevTools
- 1500000
- 217500000
- Management
- 215000000
- 1000000
- 212500000
- 500000
- 210000000
- 207500000
- 02:0004:00
- ②
- 16:0018:0020:0022:00
- 2000000
- q:*>max(system.network.out.bytes)
- ③
- Collapse
<!-- OCR_END -->

为了使这个可视化更容易使用，将这个系列从字节转换为兆字节，Timelion有一个`.divide()`函数可以使用，`.divide()`接受与`.multiply()`相同的输入，并将这个系列除以所定义的除数，使用以下表达式来更新你的可视化：

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/timelion#?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd）&_a=（columns:2,interval:auto,r.
- 应用
- T周报TTS系统
- New
- Add
- SaveDeleteOpenOptionsDocs
- Today
- kibana
- timestamp,metric=max:system.network.in.bytes).derivative.divide（1048576).es(index=metricbeat*,timefield=@timestamp,metric=max:system.network.out.bytes）.derivative(.multiply（-1).divide（1048576)
- auto
- Discover
- 225000000
- 2500000
- q:*>max(system.network.in.bytes)
- Visualize
- 222500000
- Dashboard
- 2000000
- 8
- Timelion
- 220000000
- DevTools
- 217500000
- 1500000
- Management
- 215000000
- 1000000
- 212500000
- 500000
- 210000000
- 207500000
- 02:0004:0006:00
- ①
- 12:0014:00
- 2
- 04:0006:0008:00
- network.in.bytes)
- q:*>max(system.network.out.bytes)
- 2.0
- 1.5
- 1.0
- 0.5
- 0.0
- 06:0008:0010:0012:0014:0016:0018:0020:0022:00
- 04:0006:0008:0010:0012:0014:0016:00
- 18:0020:0022:00
<!-- OCR_END -->

使用上一节中学习的格式化函数`.title()`、`.label()`、`.color()`、`.lines()`和`.legend()`，让我们稍微整理一下这个可视化，使用以下表达式来更新你的可视化：

```bash
.es(index=metricbeat*, timefield=@timestamp, metric=max:system.network.in.bytes).derivative().divide(1048576).lines(fill=2, width=1).color(green).label("Inbound traffic").title("Network traffic (MB/s)"), .es(index=metricbeat*, timefield=@timestamp, metric=max:system.network.out.bytes).derivative().multiply(-1).divide(1048576).lines(fill=2, width=1).color(blue).label("Outbound traffic").legend(columns=2, position=nw)
```

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd））&_a=（colu
- nns:2,interval:auto,ro..
- 应用T周报TTS系统
- 212500000
- kibana
- 500000
- 210000000
- Discover
- 207500000
- ①
- 02:0004:0006:00
- 18:0020:0022:00
- 04:0006:0008:00
- Visualize
- 12:0014:0016:0018:00
- 20:0022:00
- Dashboard
- 2500000
- q:*>max(system.network.in.bytes)
- 2.5
- 2000000
- q:*>max(system.network.out.bytes)
- 2.0
- Timelion
- 1500000
- DevTools
- Management
- 1000000
- 1.0
- 0.5
- 0.0
- -1.5
- Network traffic(MB/s)
- In
- und traffic
- Outbound traffic
- 04:0006:0008:0010:00
- Collapse
<!-- OCR_END -->

保存，开启新的，画图

<!-- OCR_START -->
不安全|10.0.0.54:5601/ap
应用
周报TTS系统
New
eleteOpenOptionsDocsoToday
kibana
SaveentireTimelionsheet
Discover
You want this optionif youmostly useTimelion expressionsfromwithintheTimelion app and don'tneed to addTimelionchartstoKibana dashboards.Youmay alsowant thisif youmake use of referencesto otherpanels.
Visualize
Savesheetas
Dashboard
数学函数绘制网络进出口流量
8
Timelion
Save
DevTools
Management
SavecurrentexpressionasKibanadashboardpanel
NeedtoaddacharttoaKibana dashboard?Wecandothat!Thisoptionwill saveyourcurrentlyselectedexpressionasapanel thatcanbeadded toKibana dashboardsasyouwouldaddanythingelse.Note,if youuse
referencestootherpanelsyouwill needtoremovetherefencesbycopyingthereferencedexpressiondirectlyintotheexpressionyouaresaving.Clickacharttoselectadifferentexpressiontosave.
es(index=metricbeat*,timefield=@timestamp,metric=max:system.network.in.bytes)）.derivative0.divide（1048576).lines（fill=2,width=1).color(green）.label("Inbound traffic").titleNetworktraffic(MB/s)"),.esin
auto
227500000
2500000
q:*>max(system.network.in.bytes)
225000000
2000000
222500000
220000000
1500000
217500000
215000000
1000000
212500000
500000
210000000
207500000
20:0022:00
2.5
q:*>max(system.network.out.bytes)
2.0
Collapse
1.5
<!-- OCR_END -->

***

| 使用条件逻辑和跟踪趋势 |
| :--- |

在本节中，你将学习如何使用条件逻辑修改时间序列数据，并使用移动平均值创建趋势，这有助于随着时间的推移很容易地发现异常值和模式。

对于本教程，你将继续使用Metricbeat数据添加另一个监控内存消耗的可视化，首先，使用以下表达式绘制`system.memory.actual.used.bytes`的最大值。

```bash
.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes')
```

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/timelion#/?_g=（refreshlnterval:(display:Off,pause:f,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd））_a=（columns:2,interval:auto,r.
- 应用T周报TTS系统
- New
- AddSaveDeleteOpenOptionsDocsOToday
- kibana
- es(index=metricbeat-*,timefield='@timestamp',metric=max:system.memory.actual.used.bytes)
- auto
- Discover
- 238000000
- Visualize
- q:*>max(system.memory.actual.used.byte
- 237000000
- Dashboard
- 236000000
- 8
- Timelion
- 235000000
- DevTools
- 234000000
- Management
- 233000000
- 232000000
- 231000000
- 230000000
- 229000000
- ①
- Collapse
<!-- OCR_END -->

让我们创建两个阈值来监视使用的内存数量，在本教程中，警告阈值为234MB，严重阈值为235MB，当使用内存的最大数量超过这些阈值中的任何一个时，将相应地对该系列进行着色。

>  
>
> 如果你的计算机的阈值过高或过低，请相应地进行调整。

要配置这两个阈值，可以使用Timelion的条件逻辑，在本教程中，你将使用`if()`将每个点与一个数字进行比较，如果条件的值为true，则调整样式，如果条件的值为false，则使用默认样式，Timelion提供了以下六个操作符值进行比较。

| 操作符 | 含义 |
| :--- | :--- |
| eq | 相等 |
| ne | 不相等 |
| lt | 小于 |
| gt | 大于 |
| lte | 小于等于 |
| gte | 大于等于 |

由于有两个阈值，因此对它们进行不同的样式是有意义的，使用gt操作符将警告阈值用`.color('#FFCC11')`涂成黄色，将严重阈值用`.color('red')`涂成红色，在Timelion查询栏中输入以下表达式，以应用条件逻辑和阈值样式：

```bash
.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes'), .es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').if(gt,234000000,.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes'),null).label('warning').color('#FFCC11'), .es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').if(gt,235000000,.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes'),null).label('serious').color('red')
```

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/timel
- y:off,p
- 2FSha
- 应用
- T周报TTS系统
- New
- Add
- Save
- Delete
- Open OptionsDocs
- <Today
- .es（index=metricbeat-*，timefield=@timestamp'metric=max:system.memory.actual.used.bytes),.es(index=metricbeat-*,timefield=@timestamp'metric=max:system.memory.actual.used.bytes).if(gt,234C
- auto
- 238000000
- q:*>max(system.memory.actual.used.bytes)
- 237000000
- warning
- serious
- 236000000
- 235000000
- 234000000
- 233000000
- 232000000
- 231000000
- 230000000
- 229000000
- 04:0006:00
- 16:0018:00
- ②
<!-- OCR_END -->

现在你已经定义了阈值来轻松地识别异常值，让我们创建一个新的系列来确定真正的趋势是什么，Timelion的`mvavg()`函数允许计算给定窗口上的移动平均值，这对嘈杂的时间序列特别有用，对于本教程，你将使用`.mvavg(10)`来创建具有10个数据点窗口的移动平均线，使用以下表达式创建最大内存使用量的移动平均值：

```bash
.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes'), .es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').if(gt,234000000,.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes'),null).label('warning').color('#FFCC11'), .es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').if(gt,235000000,.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes'),null).label('serious').color('red'), .es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').mvavg(10)
```

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/timelion#/_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd））_a=（columns:2,interval:auto,
- 应用T周报TTS系统
- New
- Add
- SaveDeleteOpenOptionsDocsToday
- kibana
- .es(index=metricbeat-*,timefield=@timestamp'metric=max:system.memory.actual.used.bytes),.es（index=metricbeat-*,timefield=@timestamp',metric=max:system.memory.actual.used.bytes).if(gt,234cauto
- Discover
- 238000000
- q：*>max(system.memory.actual.used.bytes
- Visualize
- 237000000
- warning
- serious
- Dashboard
- 236000000
- Timelion
- 235000000
- DevTools
- 234000000
- Management
- 233000000
- 232000000
- 231000000
- 230000000
- 229000000
- ②
- 04:0006:0008:0010:0012:0014:0016:0018:0020:0022:00
- 250000000
- q:*>max(system.mer
- severe
- 200000000
- q:
- max(sys
- 150000000
- 100000000
- 50000000
- 3
- 02:0004:0006:0008:00
- 12:0014:0016:0018:0020:0022:00
- Collapse
<!-- OCR_END -->

现在你已经有了阈值和移动平均值，让我们格式化可视化，以便更容易使用，和最后一部分一样，使用`.color()`、`.line()`、`.title()`和`.legend()`函数相应地更新可视化：

```bash
.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').label('max memory').title('Memory consumption over time'), .es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').if(gt,234000000,.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes'),null).label('warning').color('#FFCC11').lines(width=5), .es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').if(gt,235000000,.es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes'),null).label('serious').color('red').lines(width=5), .es(index=metricbeat-*, timefield='@timestamp', metric='max:system.memory.actual.used.bytes').mvavg(10).label('mvavg').lines(width=2).color(#5E5E5E).legend(columns=4, position=nw)
```

<!-- OCR_START -->
- 不安全10.0.0.54:5601/app/timelion#/?_g=（refreshlnterval:(display:Off,pause:1f,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd）&_a=（columns:2,interval:auto,
- 9
- 应用
- T周报TTS系统
- NewAddSaveDelete
- Open
- OptionsDocs
- Today
- kibana
- es（index=metricbeat-*，timefield=@timestamp'metric='max:system.memory.actual.used.bytes).label*maxmemory).title(Memory consumption overtime),.es(index=metricbeat-*,timefield=@timestamp
- auto
- Discover
- 240000000
- Visualize
- q:*>max(system.memory.actual.used.bytes)
- q:*>max(system.me
- nory.actual.used.bytes)
- warning
- 238000000
- serious
- Dashboard
- Timelion
- 236000000
- DevTools
- 234000000
- 232000000
- 230000000
- 228000000
- ②
- 250000000
- overtime
- maxmemorywarningseriousmv
- 200000000
- 150000000
- 100000000
- 50000000
- 3
- 02:0004:0006:0008:0010:0012:0014:0016:0018:0020:0022:00
- 02:0004:0006:00
- 12:0014:0016:0018:0020:0022:00
- Collapse
<!-- OCR_END -->

保存

<!-- OCR_START -->
不安全|10.0.0.54:5601/app/timelion#/?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd））_a=（columns:2,interval:auto,r
应用
T周报TTS系统
NewAddSaveDeleteOpenOptionsDocsOToday
kibana
SaveentireTimelionsheet
Discover
Youwant thisoptionif youmostlyuseTimelionexpressionsfromwithin theTimelionappanddontneedtoaddTimelionchartstoKibana dashboards.Youmayalsowant thisifyoumakeuseofreferencestootherpanels.
Visualize
Savesheetas
Dashboard
使用条件逻辑和跟踪趋势创建内存使用情况
8
Timelion
Save
DevTools
Management
SavecurrentexpressionasKibanadashboardpanel
NeedtoaddacharttoaKibanadashboard?Wecandothat!Thisoptionwillsaveyourcurrentlyselectedexpressionasapanelthatcanbeadded toKibana dashboardsasyouwouldaddanythingelse.Note,ifyouuse
referencestootherpanelsyouwillneedtoremovetherefencesbycopyingthereferencedexpressiondirectlyintotheexpressionyouaresaving.Clickacharttoselectadifferentexpressiontosave.
.es(index=metricbeat-*,timefield=@timestamp',metric='max:system.memory.actual.used.bytes).label(*maxmemory).title(Memoryconsumptionovertime),.es(index=metricbeat-*,timefield=@timestamp
auto
240000000
q:*>max(system.memory.actual.used.bytes)
warning
238000000
serious
236000000
234000000
232000000
230000000
228000000
2
250000000
Memorycons
maxmemory
200000000
=10
1
Collapse
https://www.driverzeng.copoooooo
<!-- OCR_END -->

***

| 展示至Dashboard |
| :--- |

整合，其实最终我们需要的是，网络，cpu，内存优化后的图

<!-- OCR_START -->
- 应用
- T周报TTS系统
- NewAddSave Delet
- Open
- Options
- Docs
- <Today
- kibana
- OpenSheet
- QSavedSheetsFilter...
- 4of4
- Visualize
- Name
- Dashboard
- 使用条件逻辑和跟踪趋势创建内存使用情况
- Timelion
- 创建时间序列可视化
- Dev Tools
- 定制和格式化可视化
- Management
- 数学函数绘制网络进出口流量
- .es(*)
- 600
- q:*>count
- 500
- 400
- 300
- 200
- 100
- 1
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- NewAddSaveDeleteOpenOptionsDocsToday
- kibana
- es(index=metricbeat-*，timefield=@timestamp'metric=max:system.memory.actual.used.bytes）.label(maxmemory）.titleMemoryconsumptionovertime).es(index=metricbeat-*，timefield=@timestamr
- auto
- Discover
- CPUusage
- Networktraffic(MB/s)
- Visualize
- 0.007
- 2.5
- lasthour
- currenthour
- Inbound traffic
- Dashboard
- 0.006
- 2.0
- 1.5
- Timelion
- 0.005
- 1.0
- DevTools
- 0.004
- 0.5
- Management
- 0.003
- 0.0
- 0.002
- 0.001
- 0.000
- ①00:0
- 20:0022:00
- 250000000
- maxmemory
- warning
- serious
- 200000000
- 150000000
- 100000000
- 50000000
- 3
- 02:0004:00
- Collapse
<!-- OCR_END -->

你已经正式利用了Timelion的功能来创建时间序列可视化，本教程的最后一步是向仪表盘添加你新的可视化，下面，本节将向你展示如何从Timelion工作表中保存可视化，并将其添加到现有的仪表盘中。

要将Timelion可视化保存为仪表盘面板，请执行以下步骤。

1）选择要添加到一个（或多个）仪表盘上的可视化视图。

2）点击顶部菜单中的`Save`选项。

3）选择`Save current expression as Kibana dashboard panel`。

4）命名你的面板并点击`Save`以作为仪表盘可视化。

<!-- OCR_START -->
- to:now%2Fd))&
- 应用
- T周报TTS系统
- kibana
- New
- Add
- Save
- DeleteOpenOptionsDocsToday>
- SaveentireTimelionsheet
- Discove
- You wantthis optionif youmostlyuseTimelionexpressionsfromwithin theTimelion appanddon't needto addTimelionchartstoKibana dashboards.Youmayalsowantthisifyoumakeuseofreferencesto otherpanels.
- Visualize
- SavecurrentexpressionasKibanadashboardpanel
- Dashboard
- NeedtoaddacharttoaKibanadashboard?Wecandothat!ThisoptionwillsaveyourcurrentlyselectedexpressionasapanelthatcanbeaddedtoKibanadashboardsasyouwouldaddanythingelse.Note,if youuse
- referencestootherpanelsyouwillneed toremovetherefencesbycopyingthereferencedexpressiondirectlyintotheexpressionyouaresaving.Clickacharttoselectadifferentexpressiontosave.
- Timelion
- DevTools
- es(index=metricbeat-*,timefield=@timestamp'metric=max:system.memory.actual.used.bytes）).label('maxmemory).title(Memoryconsumptionovertime'),.es（index=metricbeat-*，timefield=@timestamp
- auto
- Management
- CPUusage
- Networktraffic(MB/s)
- 0.007
- 2.5
- lasthour
- currenthour
- Inboundtraffic
- 2.0
- 0.006
- 1.5
- 0.005
- 1.0
- 0.004
- 0.5
- 0.003
- 0.0
- 0.002
- 0.001
- 0.000
- ①0:00
- 250000000
- maxmemory
- warning
- 200000000
- 150000000
- 100000000
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 9
- 应用
- T周报TTS系统
- NewAdd
- Save
- Delete
- Open
- OptionsDocs
- Today
- kibana
- SaveentireTimelionsheet
- Discover
- Visualize
- SavecurrentexpressionasKibanadashboardpanel
- Dashboard
- NeedtoaddacharttoaKibana dashboard?Wecandothat!Thisoptionwill saveyourcurrentlyselectedexpressionasapanelthatcanbeaddedtoKibana dashboardsasyouwouldaddanythingelse.Note,if youuse
- referencestootherpanelsyouwill need toremovetherefencesbycopyingthereferencedexpressiondirectlyintotheexpressionyouaresaving.Clickacharttoselectadifferentexpressiontosave.
- Timelion
- Currently selected expression.es（index=metricbeat-*, timefield='@timestamp',metric='max:system.memory.actual.used.bytes').label('maxmemory').title(Memory consumption over time'),.es(i
- DevTools
- ndex=metricbeat-*,timefield='@timestamp',metric='max:system.memory.actual.used.bytes').if(gt,2340ooooo,.es(index=metricbeat-*,timefield='@timestamp',metric='max:system.memory.actual.
- used.bytes'),null).label(*warning').color(*#FFcc11').lines(width=5),es（index=metricbeat-*,timefield='@timestamp',metric=max:system.memory.actual.used.bytes').if(gt,23500oo0,.es（ind
- Management
- ex=metricbeat-*,timefield='@timestamp',metric='max:system.memory.actual.used.bytes'),null).label('serious').color('red').lines（width=5),.es（index=metricbeat-*,timefield='@timestamp',
- metric=*max:system.memory.actual.used.bytes').mvavg(10).label('mvavg').lines(width=2).color(#5E5E5E).legend(columns=4,position=nw)
- Save expressionas
- 内存使用情况
- auto
- CPUusage
- Network traffic(MB/s)
- 0.007
- 2.5
- lasthour
- current hour
- Inbound traffic
- Outbound traffic
- 2.0
- 0.006
- 1.5
- 0.005
- 1.0
- 0.004
- 0.5
- 0.003
- 0.0
- 0.002
- 0.001
- 0.000
- Collapse
- 0：00
- httpg://w:o.dr?ierzeng.como:oo
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- NewAddSaveDelete
- Open
- OptionsDocs<
- Today
- kibana
- SaveentireTimelionsheet
- Discover
- Youwant thisoptionif youmostlyuseTimelionexpressionsfromwithintheTimelionappanddon'tneed toaddTimelionchartstoKibana dashboards.Youmayalsowant thisif youmakeuseof referencestootherpanels.
- Visualize
- SavecurrentexpressionasKibanadashboardpanel
- Dashboard
- Need toaddacharttoaKibanadashboard?Wecando that!ThisoptionwillsaveyourcurrentlyselectedexpressionasapanelthatcanbeaddedtoKibana dashboardsasyou would add anythingelse.Note,ifyou use
- referencestootherpanelsyouwillneed toremovetherefencesbycopyingthereferenced expression directlyintotheexpressionyouaresaving.Clicka charttoselecta differentexpressiontosave.
- Timelion
- Currently selected expression.es(offset=-1h,index=metricbeat-*,timefield='@timestamp',metric='avg:system.cpu.user.pct').label('last hour').lines(fill=1,width=0.5).color(gray),.es（index
- DevTools
- =metricbeat-*, timefield='@timestamp',metric='avg:system.cpu.user.pct').label('current hour').title('CPu usage').color(#1E9oFF).legend(columns=2,position=nw)
- Save expressionas
- CPU使用情况
- Save
- .es（offset=-1h,index=metricbeat-*,timefield=@timestamp'metric=avg:system.cpu.user.pct).label(lasthour).lines（fill=1,width=0.5).color(gray),.es(index=metricbeat-*,timefield=@timestampmetric=avg：
- auto
- CPUusage
- Networktraffic(MB/s)
- 0.007
- currenthour
- 2.5
- lasthour
- Inbound traffic
- Outbound traffic
- 0.006
- 2.0
- 1.5
- 0.005
- 1.0
- 0.004
- 0.5
- 0.003
- 0.0
- 0.002
- 0.001
- 0.000
- Memory consumptionovertime
- Collapse
- 250000000
<!-- OCR_END -->

<!-- OCR_START -->
不安全|10.0.0.54:5601/app/timelion#/?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,interval:auto,mode:quick,timezone:Asia%2FShanghai,to:now%2Fd）&_a=（columns:2,interval:auto,r
应用
周报TTS系统
NewAddSaveDeleteOpenOptionsDocsToday
kibana
SaveentireTimelionsheet
Discover
Youwantthisoptionif youmostlyuseTimelionexpressionsfromwithintheTimelionappanddon'tneedtoaddTimelionchartstoKibana dashboards.Youmayalsowantthisif youmakeuseofreferencestootherpanels.
Visualize
SavecurrentexpressionasKibanadashboardpanel
Dashboard
NeedtoaddacharttoaKibanadashboard?Wecandothat!ThisoptionwillsaveyourcurrentlyselectedexpressionasapanelthatcanbeaddedtoKibanadashboardsasyouwouldaddanythingelse.Note,ifyouuse
referencestootherpanelsyouwill needtoremovetherefencesbycopyingthereferencedexpressiondirectlyintotheexpressionyouaresaving.Clickacharttoselectadifferentexpressiontosave.
8
Timelion
Currently selected expression .es(index=metricbeat*,timefield=@timestamp,metric=max:system.network.in.bytes).derivative().divide(1048576).lines(fill=2,width=1).color(green).label("Inbou
DevTools
nd traffic").title("Network traffic（MB/s)"),.es(index=metricbeat*,timefield=@timestamp,metric=max:system.network.out.bytes).derivative().multiply(-1).divide(1048576).lines(fill=2,wi
dth=1).color(blue).label("Outbound traffic").legend(columns=2,position=nw)
Management
Saveexpressionas
网络进出口流量
Save
.es(index=metricbeat*,timefield=@timestamp,metric=max:system.network.in.bytes）.derivative0.divide(1048576).lines（fill=2,width=1).color(green）.label(lInbound traffic").title(Networktraffic(MB/s)).es(in
auto
CPUusage
Networktraffic(MB/s)
0.007
2.5
lasthour
currenthour
ndtraffic
0.006
2.0
1.5
0.005
1.0
0.004
0.5
0.003
0.0
0.002
0.001
0.000
Collapse
Memoryconsumptionovertime
<!-- OCR_END -->

现在你可以将这个仪表盘面板添加到任何你想要的仪表盘上，这个可视化现在将在可视化列表中列出，继续并按照你创建的其他可视化效果的相同过程进行操作。

创建一个新的仪表盘或打开一个现有的仪表盘，以添加Timelion可视化，就像其他任何可视化一样。

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/dashboard？_g=（filters:!0),refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd)
- 应用T周报TTS系统
- Dashboard
- kibana
- Discover
- QSearch...
- 1-2of2
- Visualize
- Name
- Timelion
- www.dirverzeng.com项目用户IP，URL..聚合图形展示
- DevTools
- 口用户访问www.driverzeng.com项目IP所在地区
- Management
<!-- OCR_END -->

<!-- OCR_START -->
①不安全|10.0.0.54:5601/app/kibana#/dashboard/cr
应用
T周报TTS系统
Dashboard /NewDashboard(unsaved)
Add
Save
ShareOptionsToday
kibana
Discover
Visualize
This dashboard is empty. Let's fill it up!
Dashboard
Click theAddbutton inthemenubar abovetoaddavisualization to thedashboard.
Timelion
If youhaven'tsetupavisualizationyetvisitVisualize”tocreateyourfirstvisualization.
DevTools
Management
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/dashboard/create？_g=（filters:!),refreshlnterval:(display:Off,pause:lf,value:0),time:from:now%2Fd,mode:quick,to:now%2Fd））&_a=（filters:),options:(darkTheme:!f),panels:!(
- 应用T周报TTS系统
- kibana
- Dashboard/NewDashboard(unsaved)
- AddSaveShareOptionsOToday
- AddPanels
- Discover
- Visualization
- SavedSearch
- Visualize
- Visualizations Filter..
- 17of17
- AddNewVisualization
- Dashboard
- 8
- Timelion
- Name
- </>课程大纲-MarkDown
- DevTools
- 网络进出口流量
- Management
- 网站访问次数及用户数量-度量图
- 用户访问状态码前10-饼图
- 用户访问前10URL-标签云
- Lll用户访问URL前10-条形图
- 用户IP访问前5-热图
- 曲用户IP访问前5-数据表
- 用户IP访问前5-折线图
- 用户IP访问前5-区域图
- 用户IP所在地区-地图
- 内存使用情况
- Osss
- CPU使用情况
- CPU、内存、网络监控
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全10.0.0.54:5601/app/kibana#/dashboard/create？_g=（filters:!(),refreshlnterval:(display:Off,pause:f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd))&_a=（filters:!(),options:(darkTheme:!f),panels:!(
- 应用
- T周报TTS系统
- Dashboard/系统监控（unsaved）
- Add
- Share
- Options
- <Today
- kibana
- Savedashboard
- Discover
- 系统监控
- Visualize
- OStoretimewithdashboardo
- Dashboard
- Timelion
- DevTools
- 网络进出口流量
- CPU使用情况
- Management
- Networktraffic(MB/s)
- CPU usage
- 3.0
- 0.007
- Inbound trafficOutbound traffic
- 0.006
- lasthourcurrenthour
- 2.0
- 0.005
- 1.0
- 0.004
- 0.0
- 0.003
- 0.002
- 0.001
- 0.000
- 内存使用情况
- 网站访问次数及用户数量-度量图
- Men
- 250000000
- 200000000
- 150000000
- 100000000
- 50000000
- 所有用户（将IP去重）
- 日志总条数
- 平均响应时间
- 04:0006:0008:00
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/dashboard?_g=（fiters:0),refreshlnterval:(display:Off,pause:1f,value:0),time:from:now%2Fd,mode:quick,to:now%2Fd）)
- 应用T周报TTS系统
- Dashboard
- kibana
- Discover
- QSearch...
- Visualize
- 1-3of3
- Name
- Timelion
- www.dirverzeng.com项目用户iP，URL..聚合图形展示
- DevTools
- 用户访问www.driverzeng.com项目iP所在地区
- Management
- 系统监控
- Collapse
<!-- OCR_END -->

最终展示

<!-- OCR_START -->
- 不安全
- 10.0.0.54:5601/app/
- 应用
- T周报TTS系统
- Dashboard/系统监控
- AddSaveShareOptionsToday
- kibana
- 网络进出口流量
- CPU使用情况
- Network traffic(MB/s)
- CPU usage
- Visualize
- 3.0
- 0.007
- Inbound trafficOutboundtraffic
- last
- Dashboard
- 0.006
- 2.0
- 0.005
- Timelion
- 1.0
- 0.004
- Dev Tools
- 0.003
- 0.0
- Management
- 0.002
- 0.001
- 0.000
- 内存使用情况
- 网站访问次数及用户数量-度量图
- Memoryconsumptionovertime
- 250000000
- max
- eriousmvavg
- 200000000
- 150000000
- 100000000
- 50000000
- 所有用户（将IP去重）
- 日志总条数
- 平均响应时间
- 00:0002:0004:0006:0008:0010:0012:0014:0016:0018:0020:0022:00
- Collapse
<!-- OCR_END -->

> 更新: 2024-09-20 21:25:32  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/vgxnqk>