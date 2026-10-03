# 第四章·Kibana入门-安装,索引添加及界面功能

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

## Kibana简介及部署
| 什么是Kibana？ |
| --- |

Kibana是一个通过调用elasticsearch服务器进行图形化展示搜索结果的开源项目。

| Kibana安装及配置 |
| --- |

```bash
#将Kibana安装包上传至服务器，并安装
[root@elkstack04 ~]# yum localinstall -y kibana-5.3.0-x86_64.rpm
#配置Kibana
[root@elkstack04 ~]# grep -n "^[a-Z]" /etc/kibana/kibana.yml
2:server.port: 5601
7:server.host: "0.0.0.0"
21:elasticsearch.url: "http://10.0.0.51:9200"
#启动Kibana（CentOS6）
[root@elkstack04 ~]# /etc/init.d/kibana start
#启动Kibana（CentOS7）
[root@elkstack04 ~]# systemctl start kibana
#验证端口是否启动
[root@elkstack04 ~]# netstat -lntup|grep 5601
tcp        0      0 0.0.0.0:5601                0.0.0.0:*                   LISTEN      1573/node

--------------------------------------------------------------
yum localinstall -y kibana-5.3.0-x86_64.rpm
cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml.bak
cat > /etc/kibana/kibana.yml <<EOF
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.url: "http://10.0.0.51:9200"
EOF
systemctl start kibana
netstat -lntup|grep 5601
```

打开浏览器，访问：[http://10.0.0.54:5601/status](http://10.0.0.54:5601/status) 查看Kibana及集群状态。

<!-- OCR_START -->
- →Q
- ①不安全|10.0.0.54:5601/status#？_g=()
- 应用
- kibana
- Status: Green
- elkstack04
- Discover
- Visualize
- Heap Total (MB)70.29
- Heap Used (MB)55.86
- Load
- 0.00, 0.02,
- 0.00
- Timelion
- DevTools
- Response Time AvgO.00
- Response Time MaxO.00
- Requests Per SecondO.00
- Management
- (ms)
- Status Breakdown
- 1D
- Status
- ui settings
- Ready
- plugin:kibana@5.3.0
- plugin:elasticsearch@5.3.0
- Kibana index ready
- plugin:console@5.3.0
- plugin:timelion@5.3.0
<!-- OCR_END -->

## Kibana中添加ES索引
打开浏览器，访问：[http://10.0.0.54:5601](http://10.0.0.54:5601)

<!-- OCR_START -->
→C①不安全|10.0.0.54:5601/app/kibana#/management/kibana/index/?_g=()
应用
Management / Kibana
kibana
Index Patterns  Saved Objects  Advanced Settings
No defaultindexpattern.Youmust
Visualize
selectorcre
Configure an index pattern
InordertouseKibana youmustconfigure atleast
Timelion
DevTools
Indexnameorpattern
Management
Patterns allowyou to define
logstash-*
Indexcontainstime-based events
Time-fieldnamerefreshfields
Searchingagainsttheindexpatternlogs
stash-2015.12.21) that fall within the current time range
Use event times tocreateindexnames[DEPRECATED]
<!-- OCR_END -->

在上图右边红框出写入ES索引名，下图中红框部分，就是ES中的索引，也是日志名称。

<!-- OCR_START -->
- ←→C①不安全|10.0.0.51:9100
- 应用
- Elasticsearch
- http://10.0.0.51:9200/
- 连接elk-cluster
- 信息一
- 概览 索引  数据浏览  基本查询 [+]  复合查询[+]
- 集群概览
- IndexFilter
- zlsindex
- zls_2019.03.05
- size:5.68ki(11.4ki)
- docs:1(2)
- 信息
- elk01
- 信息动作
- elk02
<!-- OCR_END -->

<!-- OCR_START -->
→Q
A不安全|10.0.0.54:5601/app/kibana#/management/kibana/index/?_g=()
应用
Management / Kibana
kibana
Index Patterns  Saved Objects  Advanced Settings
Discover
No default indexpattern.Youmust
Visualize
Configure an index pattern
Dashboard
InordertouseKibana you must configure atleast oneindexpattern.Inde
patternsare
used toidentifytheElasticsearchindextorunsearch and analyticsagainst.Theyarealsousedtoconfigurefields
Timelion
DevTools
Index name or pattern
Manag
pent
YYYY:年 (year)
[zls_JYYYY.MM.DD
MM:月（month）
DD:日(day)
Index contains time-based events
Time-field name refreshfields
Useeventtimestocreateindexnames[DEPRECATED]
Unable to fetch mapping. Do you have indices matching the pat
<!-- OCR_END -->

<!-- OCR_START -->
不安全|10.0.0.54:5601/app/kibana#/management/kibana/index/?_g=()
应用
Management/Kibana
kibana
Index Patterns Saved Objects Advanced Settings
Discover
Warning
Nodefault indexpattern.Youmust
Visualize
selectorcreateonetocontinue
Configure an index pattern
Dashboard
Timelion
DevTools
Indexname orpattern
Management
Patterns allow youto definedyna
nicindexnamestatictextinanindexameidenotedusingbracketsExample:logstash-Y.M.DD.PleasenotethatweksaresetuptoueISOweekswhichstartn
Monday.-DateFormat Documentation
[zls_JYYYY.MM.DD
Indexcontainstime-based events
Time-fieldname
单击此处空白框，下拉菜单中，选中timestamp时间戳
Useeventtimestocreateindexnames[DEPRECATED]
Time-interval based indexpatternsaredeprecated!
We stronglyrecommend usingwlldcard pattern names instead of time-interval based indexpatterns.
Kibanaisnowsmartenoughtoautomaticallydeterminewhichndicestosearchagainstwithinthecurrenttimerangeforwildcardindexpatte
berformanceoptimizationswhensearchingwithinatimerangeastime-intervalpatterns
Indexpatterninterval
Daily
Patternmatches100%ofexistingindicesand aliases
·zls_2019.03.05
·zls_2019.03.27
Create
选择完毕后，单击Create创建
Collap
<!-- OCR_END -->

<!-- OCR_START -->
→C
A不安全|10.0.0.54:5601/app/kibana#/management/kibana/index/?_g=()
应用
Management /Kibana
kibana
IndexPatternsSavedObjectsAdvancedSettings
Discover
WarningNodefaultindexpattern.Youmust
Visualize
selectorcreateone tocontinue
Configure anindexpattern
Dashboard
Timelion
DevTools
Indexnameorpattern
Management
Patternsallowyoutodefinedynamicindexna
Monday.-DateFormat Documentation
[zls_JYYY.MM.DD
Indexcontainstime-based events
Time-field namerefreshfieds
@timestamp
Useeventtimestocreateindexnames[DEPRECATED]
Time-intervalbased indexpatterns aredeprecated!
Westronglyrecommend usingwlldcardpatternnamesinstead of time-interval
Kibanaisnowsmartenoughtoautomaticalydeterminewhichindicestosearchagainstwithinthecurenttmerangeforwildcardindexpatter
rns.Thismeansthatwildcard Indexpatternsnowgetthe sam
erformanceoptimizationswhensearchingwithinatimerangeastime-intervalpattern
Indexpatterninterval
Daily
Patternmatches100%6of existingindicesand allases
·zls_2019.03.05
·zls_2019.03.27
Create
<!-- OCR_END -->

<!-- OCR_START -->
- →C①不安全|10.0.0.54:5601/app/kibana#/management/kibana/indices/%5Bzls_%5DYYYY.MM.DD?_g=()&_a=(tab:indexedFields)
- 应用
- Management / Kibana / Indices
- kibana
- Index Patterns Saved Objects Advanced Settings
- 单击此处，查看日志
- Visualize
- ★[z/sY.M.D
- ★[ZIS_]YYYY.MM.DD
- Dashboard
- Timelion
- usingElasticsearch'sMappingAPI%
- DevTools
- Management
- Filter
- Fields (12)
- Scripted fields(0)
- Source filters (o)
- name
- type
- format
- searchable
- analyzed
- excluded
- controls
- @version.keyword
- string
- message
- @timestamp
- date
- message.keyword
- @version
- host
- _source
- host.keyword
- id
- _index
- _score
- number
- Scroll to top
- Page Size 25
<!-- OCR_END -->

## Kibana查看日志

<!-- OCR_START -->
ohits
New
Save
Open
Share
Last 15minutes
kibana
选择今天的
Disco
[zls_JYYYY.MM.DD
没有结果，是因为时间需要选择
No results found
Visualize
SelectedFields
and frankly, I just couldn't find anything good. Help me, help you.
Dashboard
?_source
Here are some ideas:
Timelion
AvailableFields
Expand your time range
DevTools
seeyouarelookingatanindexwithadatefiel.t isossibleyourquerydoesnotmatchanything inthecurrent timerangeorthat thereisnodataat allinthecurrenty
selected time range. Click the button below to open the time picker.Forfuture reference you can open the time pickerby clicking on the Otime picker button in the top right
corner of your screen.
Refine your query
Examples:
Find requests that contain the number 200, in any field:
200
Or we cansearch in a specificfield.Find 200 in the status field:
status:200
Find allstatuscodesbetween400-499:
status:[400 T0 499]
Find status codes 400-499 with the extension php:
status:[400 T0 499] AND extension:PHP
Or HTML
n:html
Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- auto,query:(query_string:(analyze_wildcard:!t,query:*)),sort:!(@timestamp',desc))
- 应用
- ohits
- New   Save  Open  Share  CAuto-refresh
- Last15minutes
- kibana
- Time Range
- Today
- Dise
- Yesterday
- Last30days
- Quick
- Thisweek
- Daybeforeyesterday
- Last30minutes
- Last60days
- Visualize
- Thismonth
- Thisdaylastweek
- Last1hour
- Last90 days
- Relative
- This year
- Previousweek
- Last4hours
- Last6months
- Dashboard
- The day so far
- Previousmonth
- Last12hours
- Last1year
- Absolute
- Week to date
- Last 24 hours
- Previousyear
- Last 2years
- 1
- Timelion
- Monthtodate
- Last 7days
- Last5years
- Yeartodate
- DevTools
- Manager
- [zls_JYYYY.MM.DD
- No results found @
- Selected Fields
- ?_source
- Here are some ideas:
- AvailableFields
- Expand your time range
- I see you are looking at an index with a date field It is possible your query does not match anything in the current time range, or that there is no data at all in the currently
- selected timerange.Clickthebuttonbelowtoopenthetimepicker.Forfuturereferenceyoucanopenthetimepickerby clickingontheOtimepickerbutton inthetopright
- corner of your screen.
- Refine your query
- The search bar at the top uses Elasticsearch's support for Lucene Query String syntax. Let's say we're searching web server logs that have been parsed into a few fields.
- Examples:
- Find requests thatcontain thenumber200,inanyfie:
- 200
- Orwe can searchin a specificfield.Find 200inthestatusfield:
- status:200
- Find all status codes between 400-499:
- status:[400 T0 499]
- Find status codes 400-499 with the extension php:
- status:[400 T0 499] AND ext
- Or HTML
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全10.0.0.54:5601/app/kik
- 应用
- 7hits
- Share
- Today
- kibana
- March 30th 2019,00:00:00.000- March 30th 2019, 23:59:59.999 - by.30 minutes
- [zIs_JYYYY.MM.DD
- Visualize
- Selected Fields
- Dashboard
- ?_source
- AvailableFields
- Timelion
- ① @timestamp
- DevTools
- t@version
- t_id
- @tin
- t_index
- #_score
- Time
- t_type
- March 30th 2019,20:56:44.047
- @timestamp:March 30th 2019,20:56
- HshQ0uyrLS7nT4f_type:logs_index:zls_2019.03.30_score
- thost
- tmessage
- March 30th 2019,20:56:36.140
- 2019,
- 20:56:35.977
- _type:logs
- March 30th 2019,20:56:35.817
- @times
- id:
- 2019,20:56:35.659
- AWn0rFpdQ0uyrLS7nT4b_type:logs
- March 30th 2019，20:56:35.455
- @ti
- March30th2019，20:56:34.002
- @timestamp:March 30th 2019,20:56:34.002@
- _index:zls_2019.03.30_score:
<!-- OCR_END -->

## Kibana区域定义及说明

<!-- OCR_START -->
- nns:!(_source),index:%5Bzls_%5DYYYY.MM.DD,interval:auto,query:(query_string:(analyze
- 应用
- 7hits
- kibana
- NewSaveOpenShare
- CAuto-refresh
- <Today
- TimeRange
- Yesterday
- Last15minutes
- Last30days
- Quick
- Thisweek
- Daybeforeyesterday
- Last30minutes
- Last60days
- Thismonth
- Thisdaylast week
- Last1hour
- Last90days
- 1.时间区域
- Visualize
- Relative
- Thisyear
- Previousweek
- Last4hours
- Last6months
- Dashboard
- Thedaysofar
- Previousmonth
- Last12hours
- Last1year
- Absolute
- Weektodate
- Previousyear
- Last24hours
- Last2years
- Monthtodate
- Last7 days
- Last5years
- Yeartodate
- DevTools
- 4.搜索区域
- March30th201900:00:0000Marc30th2019,23:5959.999-by30minutes
- [zls_JYYYY.MM.DD
- 2.功能区域
- SelectedFields
- 7_source
- AvailableFields
- @timestamp
- @version
- t_id
- tindex
- 5.展示区域
- _score
- Time
- _source
- ttype
- thost
- tmessage
- 3.日志列表区域
- March 30th 2019,20:56:36.140
- etimestamp:March30th 2019,20:56:36.140@version:1
- _id:AWnOrFw-QOuyrLS7nT4e_type:logs_index:zls_2019.03.30_score:
- March 30th 2019,20:56:35.977
- etimestamp:March 30th 2019,20:56:35.977
- _id:AWn0rFugQ0uyrLS7nT4d_type:logs_index:zls_2019.03.30_score:
- March 30th2019,20:56:35.817
- etimestamp:March 30th 2019,20:56:35.817
- _id:AWn0rFr9QOuyrLS7nT4c_type:logs_index:zls_2019.03.30
- March 30th 2019,20:56:35.659
- March 30th 2019,20:56:35.455
- March 30th 2019,20:56:34.002
- March 30th 2019,20:56:34.002 eversion:1host:0.0.0.0
- ssage:balabalaxiaomo\xE5\x85xian_id:AWn0rFS1QouyrLS7nT4Y_type:logs
- https://www:driverzeng.com
<!-- OCR_END -->

| 绿色区域 |
| --- |

> 时间区域，选择想要查看日志的时间段：
>
> 第一个是快速查询，可以查看今天，这周，这个月，这一年，昨天…… 等时段的日志
>
> 第二个是查看具体那个时间段之前，到现在为止的一段时间的日志
>
> 第三个是精确查找，可以根据日志，具体到某个时间点，可精确到秒
>

---

| 黄色区域 |
| --- |

> 功能区域，查看日志，画图工具，图形展示，时间轴，开发工具，管理工具
>

---

| 黑色区域 |
| --- |

> 日志列表区，选择自己想看的日志，日志名以项目名开头，后面是对应的域名。
>
> 例：[zls_]YYYY.MM.DD 标红的为日期格式。
>

---

| 红色区域 |
| --- |

> 搜索区，使用Lucene语法搜索想要内容。
>

---

| 白色区域 |
| --- |

> 展示区 ，日志的详细信息，及过滤日志后会高亮显示。
>

	

> 更新: 2024-09-19 22:36:02  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/sku7cs>