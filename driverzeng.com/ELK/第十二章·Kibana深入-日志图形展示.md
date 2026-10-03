# 第十二章·Kibana深入-日志图形展示

## Kibana创建区域图

Kibana支持多重图从展示功能，需要日志是json格式的支持。

Kibana区域图

打开浏览器，访问：[http://10.0.0.54:5601](http://10.0.0.54:5601/)

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/
- ：now%2Fw))
- 应用
- T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch.
- O-Oofo<
- Dashboard
- Looks like you don't have any visu
- alization
- Let'screatesome!
- Timelion
- +Create a visualizati
- DevTools
- Management
- O-0ofo<
<!-- OCR_END -->

<!-- OCR_START -->
A不安全|10.0.0.54:5601/app
%2Fw
1ow%2Fw)
周报TTS系统
Visualize/New
kibana
Discover
Select visualization type
LlVisualize
Dashboard
Area chart
Greatforstacked timelinesinwhichthe total of all series ismore important than comparinganytwo ormore series.Less useful forassessingtherelative
Timelion
changeof unrelateddatapointsaschangesinaserieslowerdownthestackwill haveadifficulttogaugeeffectontheseriesaboveit
DevTools
Data table
Management
charts by clicking the grey bar at the bottom of the chart.
Heatmapchart
WLine chart
Often the best chart for high density time series. Great for comparing one seriesto another.Be careful with sparse sets as the connection between points can
be misleading.
</>Markdownwidget
Usefulfordisplayingexplanationsorinstru
Metric
One big number for all of your one big number needs. Perfect for showing a count of hits, or the exact average of a numeric field.
Pie chart
Pie charts are ideal for displaying the parts of some whole. For example, sales percentages by department.Pro Tip: Pie charts are best used sparingly, and with
nomore than7slicesperpie.
Tag cloud
A tag cloud visualization is a
tionof textdata,typicallyusedtovisualizeindividualwords.Thefontsizeof awordcorrespondswithits
importance.
<!-- OCR_END -->

选择一个日志

<!-- OCR_START -->
- A 不安全| 10.0.0.54:5601/app/kiban
- na#/visuali
- 应用
- T周报TTS系统
- Visualize/New/Choose search source
- kibana
- From a New Search, Select Index
- Or, From a Saved Search
- Visualize
- Q Filter..
- 9of9
- Saved Searches Filter..
- Oofo
- ManageSavedSearches
- Dashboard
- Timelion
- Name
- [logstash_rsyslog-JYY.MM.DD
- No matching saved searches found.
- DevTools
- [m.elk.com-JYY.MM.DD
- Management
- [nginx_access-]YYYY.MM.DD
- [ngx_log-]JYYY.MM.DD
- [tc_log-]YYYY.MM.DD
- [tcp_log-JYYYY.MM.DD
- [tomcat_access-]YYY.MM.DD
- [www.driverzeng.com-JYY.MM.DD
- [www.elk.com-JYYY.MM.D
<!-- OCR_END -->

添加一个`X轴`

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize/cre
- 应用
- 周报TTS系统
- Visualize/NewVisualization(unsaved)
- SaveShareRefreshOToday
- kibana
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- 访问次数
- Visualize
- Data
- Options
- Dashboard
- metrics
- Y-AXxiS
- Timelion
- DevTools
- Count
- Management
- Custom Label
- Advanced
- Addmerics
- buckets
- X-Axis
- Aggregation
- Terms
- Field
- clientip.keyword
- OrderBy
- metric:访问次数
- Descending
- 用户ip
- Add sub-buckets
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- om-%5DYYYY.MM.DD8
- 应用
- T周报TTS系统
- Visualize/用户IP访问前5-区域图（unsaved）
- kibana
- re
- Refresh
- Today
- SaveVisualization
- Discover
- 用户IP访问前5-区域图
- Visualize
- Save
- Dashboard
- 8
- Timelion
- [www.driverzeng.com-]YYYY.MM.DD
- 访问次数
- DevTools
- Data Options
- Management
- metrics
- Y-Axis
- Aggregation
- Count
- Custom Label
- Advanced
- Addmetrics
- buckets
- X-Axis
- Terms
- Field
- clientip.keyword
- OrderBy
- metric:访问次数
- Order
- Size
- Descending
- 5
- 用户ip
- Collapse
<!-- OCR_END -->

再次点击`Vlsualize`即可看见刚才创建的图形

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize？_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））
- 应用
- T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch....
- 1-1of1
- Dashboard
- Name
- Type
- 用户IP访问前5-区域图
- Area chart
- Timelion
- DevTools
- Management
- Collapse
<!-- OCR_END -->

## Kibana创建数据表

Kibana数据表

点击图中 `+号` 即可再次画图。

<!-- OCR_START -->
- 应用T周报TTS系统
- Visualize
- kibana
- QSearch....
- 1-1of1
- Dashboard
- Name
- Type
- Timelion
- 用户IP访问前5-区域图
- Area chart
- DevTools
- Management
- Collapse
<!-- OCR_END -->

选择`Data table` 数据表

<!-- OCR_START -->
不安全|10.0.0.54：5601/a
应用
T周报TTS系统
kibana
Visualize/New
Selectvisualizationtype
Visualize
Dashboard
Areachart
Greatforstacked timelinesinwhichthetotalofallseriesismoreimportantthancomparinganytwoormoreseries.Lessuseful forassessingtherelative
Timelion
changeofunrelated datapoints aschangesina series lower downthestackwill havea difficult togaugeeffecton the seriesabove it.
DevTools
Management
Datatable
Thedatatableprovidesadetailedbreakdown,ntabularformatof theresultsofacomposedaggregation.Tip,adatatableisavailablefrommanyother
chartsbyclickingthegreybarat thebottom of thechart.
Heatmapchart
Linechart
Oftenthebestchartforhighdensitytimeseries.Greatforcomparingoneseriestoanother.Becarefulwithsparsesetsas theconnectionbetweenpointscan
be misleading.
</>Markdownwidget
Useful fordisplayingexplanationsorinstructionsfordashboards.
Metric
Onebignumberforall of youronebignumberneeds.Perfectforshowinga countof hits,ortheexactaverageofanumericfield.
Piechart
Piechartsareidealfordisplayingthepartsofsomewhole.Forexamplesalespercentagesbydepartment.ProTip:Piechartsarebestusedsparingly,andwith
nomore than7 slices per pie.
Tagcloud
Collapse
Atagcloudvisualizationisavisualrepre
esentatiotpstexwdatw.anivelzeng.eoiya
ofawordcorrespondswithits
<!-- OCR_END -->

选择日志

<!-- OCR_START -->
- 应用T周报TTS系统
- kibana
- Visualize/New/Choosesearchsource
- Discover
- Or,From a Saved Search
- Visualize
- QFilter....
- 9of9
- baved Searches Filter....
- Dashboard
- Oofo
- ManageSavedSearches
- Timelion
- Name
- DevTools
- [logstash_rsyslog-]YYYY.MM.DD
- Nomatchingsavedsearchesfound.
- [m.elk.com-]YYYY.MM.DD
- Management
- [nginx_aCccess-]YYYY.MM.DD
- [ngxlog-JY.MM.DD
- [tc_log-JYYYY.MM.DD
- [tcp_log-JYYYY.MM.DD
- [tomcat_access-]YYYY.MM.DD
- www.driverzeng.com-JYYYY.MM.DD
- [www.elk.com-JYYYY.MM.DD
- Collapse
<!-- OCR_END -->

添加行

<!-- OCR_START -->
- 应用
- T周报TTS系统
- Visualize/NewVisualization（unsaved)
- Save Share Refresh<Today
- kibana
- Discover
- [www.driverzeng.com-jYYYY.MM.DD
- Count
- Visualize
- Data
- Options
- 18
- Dashboard
- metrics
- Metric
- 8
- Timelion
- Add metrics
- Dev Tools
- buckets
- Managem
- Selectbucketstype
- Split Rows
- SplitTable
- Export:RawFormatted
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- Visualize/NewVisualization（unsaved)
- SaveShareRefreshOToday
- kibana
- Discover
- [www.driverzeng.com-jYYYY.MM.DD
- 用户IP
- Count
- Visualize
- DataOptions
- 10.0.0.53
- 16
- Dashboard
- metrics
- 10.0.0.54
- Metric
- 10.0.0.55
- 8
- Timelion
- Addmetrics
- DevTools
- buckets
- Split Rows
- Management
- Aggregation
- Terms
- Field
- clientip.keyword
- OrderBy
- metric:Count
- 此处可以将结果导出
- Export:Raw
- Formatted
- Order
- Descending
- CustomLabel
- Advanced
- Add sub-bucket
<!-- OCR_END -->

<!-- OCR_START -->
- LIBRARY
- 第八章·Logstash深入-.
- 第九章·Logstash深入-L..
- 使用Filebeat Modules..
- 使用Log
- QSearch
- 所有文档（71）
- New Visualization
- 最近使用（52）
- 第二章·Elastic
- 开始
- 插入
- 页面布局
- 公式
- 数据
- 审阅
- 视图
- X剪切
- 等线Regular（正文）
- 12
- 自动换行
- 常规
- 复制
- 文藏
- 名称
- 粘贴
- 合并后居中
- .00
- 条件格
- 格式
- 隔空投送
- A1
- fx
- 用户IP
- 最近使用
- glit
- vsql
- 应用程序
- ICount
- L.R.....
- 10.0.0.53
- 桌面
- 16
- 10.0.0.54
- 文稿
- 10.0.0.55
- 下载
- 软件
- 44H
- G盘
- 10
- iCloud云盘
- NewVisualization.csv
- 云例.txt
- 13
- 远程光盘
- 14
- 15
- 网络
- HRC?"
- 17
- "go.jpg
- 18
- 红色
- 19
<!-- OCR_END -->

保存

<!-- OCR_START -->
- 应用
- 周报TTS系统
- Visualize/用户IP访问前5-数据表
- are
- Refresh
- <Today
- kibana
- SaveVisualization
- 用户IP访问前5-数据表
- Visualize
- Saveasanewvisualization
- Dashboard
- Save
- Timelion
- DevTools
- [www.driverzeng.com-JYYYY.MM.DD
- 用户IP
- Count
- Management
- Data Options
- 10.0.0.53
- 16
- metrics
- 10.0.0.54
- Metric
- 10.0.0.55
- Addmetrics
- buckets
- SplitRows
- clientip.keyword:Descending
- Add sub-buckets
- Export:RawFormatted
<!-- OCR_END -->

## Kibana创建热图

热图举例

<!-- OCR_START -->
- Average temperatureby month
- MonthlyStockValue
- -125
- -52
- 31
- 10.1
- 5.5
- -5.6
- 255
- 248
- 242
- 235
- 50000
- 229
- https//www.driverzeng.com
- 222
- January
- February
- March
- April
- May
- June
- July
<!-- OCR_END -->

***

| Kibana热图 |
| :--- |

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/ki
- 应用
- T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch..
- 1-2of2
- Dashboard
- Name
- Type
- Timelion
- 用户IP访问前5-区域图
- Areachart
- DevTools
- 用户IP访问前5-数据表
- Datatable
- Management
<!-- OCR_END -->

<!-- OCR_START -->
A不安全|10.0.0.54:5601/app
应用
T周报TTS系统
Visualize/New
kibana
Selectvisualizationtype
Visualize
Areachart
Greatforstacked timelinesinwhichthetotal of allseriesismoreimportant thancomparing anytwo ormoreseries.Lessusefulforassessingtherelative
Timelion
changeof unrelateddatapointsaschangesinaserieslowerdown thestackwillhaveadifficult togaugeeffectontheseriesaboveit.
DevTools
Management
Datatable
Thedatatableprovidesadetailedbreakdownintabularformat,oftheresultsofacomposedaggregation.Tip,adatatableisavailablefrommanyother
chartsby clickingthegreybarat thebottomof thechart.
Heatmap chart
A heat map is a graphical representation of data where the individual values contained in amatrix arerepresented as colors.
Linechart
be misleading.
</>Markdown widget
Usefulfordisplayingexplanationsorinstructionsfordashboards.
Metric
Onebignumberforallof youronebignumberneeds.Perfect for showinga countof hits,ortheexact averageof anumericfield.
Piechart
Piechartsaredealfordisplayingthepartsof somewholeForexamplesalespercentagesbydeparment.ProTip:Piechartsarebestusedsparinglyandwith
nomorethan7slicesperpie.
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kib
- 应用
- T周报TTS系统
- Visualize/New/Choosesearchsource
- kibana
- Discover
- Visualize
- QFilter...
- 9of9
- Saved SearchesFilter..
- Oofo
- ManageSavedSearches
- Dashboard
- 8
- Timelion
- Name
- [logstash_rsyslog-]YYYY.MM.DD
- DevTools
- Nomatching saved searchesfound.
- Management
- [m.elk.com-]YYYY.MM.DD
- [nginx_access-]Y.MM.DD
- [ngx_log-]YYYY.MM.DD
- [tc_log-YYYY.MM.DD
- [tcp_log-]YYYY.MM.DD
- [tomcat_access-]YYY.MM.DD
- [www.driverzeng.com-]YYYY.MM.DD
- [www.elk.com-JYYYY.MM.DD
<!-- OCR_END -->

颜色随意选择

<!-- OCR_START -->
- 应用
- T周报TTS系统
- Visualize/NewVisualization(unsaved)
- SaveShareRefresh
- Today
- kibana
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- 0-4
- Visualize
- Data
- Options
- Dashboard
- metrics
- value
- Timelion
- Aggregation
- DevTools
- Count
- Management
- CustomLabel
- 访问次数
- Advanced
- buckets
- X-Axis
- 8-12
- 12-16
- Terms
- Field
- clientip.keyword
- OrderBy
- metric:访问次数
- Order
- Size
- Descending
- 5
- 用户IP
- Add sub-buckets
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- Visualize/用户IP访问前5-热图（unsaved）
- hare
- Refresh
- Today
- kibana
- SaveVisualization
- Discover
- 用户IP访问前5-热图
- Visualize
- Save
- Dashboard
- Timelion
- [www.driverzeng.com-jYYYY.MM.DD
- DevTools
- DataOptions
- Management
- metrics
- value
- Aggregation
- Count
- CustomLabel
- 访问次数
- Advanced
- buckets
- X-Axis
- 8-12
- 12-16
- Terms
- Field
- clientip.keyword
- OrderBy
- metric:访问次数
- Order
- Size
- Descending
- 用户IP
- Collapse
<!-- OCR_END -->

## Kibana创建折线图

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize？_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））
- 8
- I应用T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch...
- 1-3of3
- Dashboard
- Name
- Type
- Timelion
- 用户IP访问前5-区域图
- Areachart
- DevTools
- 用户IP访问前5-数据表
- Data table
- Management
- O用户IP访问前5-热图
- Heatmapchart
<!-- OCR_END -->

<!-- OCR_START -->
A不安全
10.0.0.54:5601/app/kiba
应用
T周报TTS系统
Visualize/New
kibana
Discover
Selectvisualizationtype
Visualize
Dashboard
Areachart
Greatforstackedtimelinesinwhichthetotalofallseriesismoreim
moreseries.Lessusefulforassessingtherelative
8
Timelion
changeof unrelated datapointsaschangesinaserieslower down thestackwillhaveadifficulttogaugeeffecton theseriesaboveit.
DevTools
Management
Datatable
Thedatatableprovidesadetailedbreakdown,intabularformat,oftheresultsofacomposedaggregation.Tip,adatatableisavailablefrommanyother
chartsbyclickingthegreybarat thebottomof thechart.
Heatmap chart
A heatmap isagraphicalrepresentation of data where the individual values contained inamatrix arerepresented ascolors.
Line chart
Oftenthebestchartforhighdensitytimeseries.Greatforcomparingoneseriestoanother.Becarefulwithsparsesetsastheconnectionbetweenpointscan
bemisleading.
<>
Markdownwidget
Useful fordisplayingexplanationsorinstructionsfordashboards.
Metric
Onebignumberforallof youronebignumberneeds.Perfectforshowingacountof hits,ortheexactaverageofanumericfield.
Piechart
Piechartsareidealfordiplayingthepartsofsomewhole.ForexamplesalespercentagesbydepartmentroTip:Piechartsarebestusedsparinglyandwith
nomore than7slicesperpie.
Collapse
Tagcloud
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kib
- 应用
- T周报TTS系统
- Visualize/New/Choosesearchsource
- kibana
- Discover
- Visualize
- QFilter..
- 9of9
- Qbaved Searches Filter..
- Oofo
- Manage Saved Searches
- Dashboard
- Timelion
- Name
- DevTools
- [logstash_rsyslog-JYYYY.MM.DD
- Nomatching saved searchesfound.
- [m.elk.com-]YYYY.MM.DD
- Management
- [nginx_access-]YYYY.MM.DD
- [ngxlog-YYY.MM.DD
- [tc_log-JYYYY.MM.DD
- [tcp_og-YYYY.MM.DD
- [tomcat_access-]YYYY.MM.DD
- [www.driverzeng.com-jYY.MM.DD
- [www.elk.com-]YYY.MM.DD
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize/create?type=line&indexPattern=%5Bwww.driverzeng.com-%5DYYYY.MM.DD&_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,..
- 应用T周报TTS系统
- Visualize /NewVisualization(unsaved)
- SaveShareRefreshToday
- kibana
- Discover
- [www.driverzeng.com-]YYYY.MM.DD
- 访问次数
- Visualize
- Data Options
- Dashboard
- metrics
- Y-Axis
- Timelion
- Aggregation
- DevTools
- Count
- Management
- CustomLabel
- Advanced
- Addmetrics
- buckets
- X-Axis
- Terms
- Field
- clientip.keyword
- OrderBy
- metric:访问次数
- Order
- Size
- Descending
- 用户IP
- ddsub-
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- Visualize/用户IP访问前5-折线图（unsaved）
- kibana
- Refresh
- Today
- SaveVisualization
- Discover
- 用户IP访问前5-折线图
- Visualize
- Save
- Dashboard
- Timelion
- [www.driverzeng.com-JYYY.MM.DD
- 访问次数
- DevTools
- Data Options
- Management
- metrics
- Y-Axis
- Aggregation
- Count
- Custom Label
- Adva
- Addmetrics
- buckets
- X-Axis
- Terms
- Field
- clientip.keyword
- OrderBy
- metric:访问次数
- Order
- Size
- Descending
- Collapse
- 用户IP
<!-- OCR_END -->

## Kibana创建MarkDown

Kibana Mark Down

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize？_g=（refreshlnterval:(display:Off,pause:f,value:0),time:from:now%2Fd,mode:quick,to:now%2Fd））
- 应用
- T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch...
- 1-4of4
- Dashboard
- Name
- Type
- 8
- Timelion
- 用户IP访问前5-区域图
- Areachart
- DevTools
- 用户IP访问前5-折线图
- Linechart
- Management
- 用户IP访问前5-数据表
- Data table
- 用户IP访问前5-热图
- Heatmap chart
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全
- 10.0.0.54:5601/app/kiba
- 应用
- T周报TTS系统
- Visualize/NewVisualization(unsaved)
- kibana
- Share
- Refresh
- <Today
- Discover
- Options
- Visualize
- Markdown
- Help%
- 老男孩教育
- Dashboard
- ##Linux云计算课程
- ###课程大纲
- Timelion
- ####ELK阶段
- DevTools
- -Elasticsearch安装
- -Logstash安装
- Management
- -Kibana安装
- -Filebeat安装
- yum localinstall-y elasticsearch
- yum localinstall-y logstash
- yum localinstall-ykibana
- yumlocalinstll-yfilebeat
- 重点：日志收集，日志画图
- yum localinstall-y filebeat
- 作者：曾老湿
- QQ:133411023
- 微信：z133411023
<!-- OCR_END -->

## Kibana创建饼图

Kibana饼图

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/visualize？_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd)
- 川应用T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch...
- 1-5of5
- Dashboard
- Name
- Type
- 用户IP访问前5-区域图
- Areachart
- 8
- Timelion
- DevTools
- 用户IP访问前5-折线图
- Linechart
- Management
- 用户IP访问前5-数据表
- Datatable
- 用户IP访问前5-热图
- IHeatmapchart
- 课程大纲-MarkDown
- <>Markdown widget
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 9
- 应用
- T周报TTS系统
- Visualize/New
- kibana
- Discover
- Selectvisualizationtype
- Visualize
- Dashboard
- Area chart
- Greatforstackedtimelinesinwhichthetotalofallseriesismoreimportantthancomparinganytwoormoreseries.Lessusefulforassessingtherelative
- 8
- Timelion
- changeof unrelateddatapointsaschangesinaserieslowerdownthestackwillhaveadifficultogaugeeffectontheseriesaboveit.
- DevTools
- Management
- Data table
- chartsbyclickingthegreybarathebottomof thechart.
- Heatmapchart
- Line chart
- bemisleading.
- <>
- Markdownwidget
- Useful fordisplayingexplanationsorinstructionsfordashboards.
- Metric
- Onebignumberforallof youronebignumberneeds.Perfectforshowingacountof hits,ortheexactaverageof anumericfield.
- Piechart
- nomorethan7slicesperpie.
- Tagcloud
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- Visualize/New/Choosesearchsource
- kibana
- Discover
- Visualize
- Dashboard
- QFilter...
- 9of9
- Saved Searches Filter....
- Oofo
- ManageSavedSearches
- Timelion
- Name
- DevTools
- [logstash_rsyslog-YYYY.MM.DD
- No matching saved searches found.
- [m.elk.com-]YYYY.MM.DD
- Management
- [nginx_access-]YY.MM.DD
- [ngx.og-JY.MM.DD
- [tc_log-JYYYY.MM.DD
- [tcp_log-JYYY.MM.DD
- [tomcat_access-]YYYY.MM.DD
- [www.driverzeng.com-]YYYY.MM.DD
- [www.elk.com-]YYYY.MM.DD
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize/create?type=pie&indexPattern=%5Bwww.driverzeng.com-%5DYYYY.MM.DD&_g=（refreshlnterval:(display:Off,pause:!f,value:0),time:(from:now%2Fd,mode:quick,t.
- 应用T周报TTS系统
- Visualize/NewVisualization(unsaved)
- Save ShareRefreshToday
- kibana
- Discover
- [www.driverzeng.com-jYYYY.MM.DD
- 304
- 302
- Visualize
- DataOptions
- ·200
- 404
- Dashboard
- metrics
- 403
- slice Size
- 500
- Timelion
- 400
- Aggregation
- 502
- DevTools
- Count
- 504
- Management
- stomLahel
- 出现次数
- Advanced
- buckets
- Split Slices
- Terms
- Field
- status.keyword
- OrderBy
- metric:出现次数
- Order
- Size
- Descending
- 10
- Custom Label
- 状态码
- Add sub-buckets
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/visualize/create?type=pie&indexPattern=%5Bwww.driverzeng.com-%5DYYYY.MM.DD&_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,t.
- 应用T周报TTS系统
- Visualize/用户访问状态码前10-饼图（unsaved）
- Share
- RefreshOToday
- kibana
- SaveVisualization
- Discover
- 用户访问状态码前10-饼图
- Visualize
- Save
- Dashboard
- 8
- Timelion
- [www.driverzeng.com-jyYYY.MM.DD
- 304
- DevTools
- 302
- Data
- Options
- 200
- Management
- 404
- metrics
- 403
- SliceSize
- 500
- 400
- Aggregation
- 502
- Count
- 504
- CustomLabel
- 出现次数
- Advanced
- buckets
- split Slices
- Terms
- Field
- status.keyword
- OrderBy
- metric:出现次数
- Order
- Size
- Descending
- 10
- 状态码
- Addsub-bucket:
- Collapse
- 1
<!-- OCR_END -->

## Kibana创建条形图

Kibana条形图

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize？_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））
- 应用T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch...
- 1-6of6
- Dashboard
- Name
- Type
- 8
- Timelion
- 用户IP访问前5-区域图
- Area chart
- DevTools
- 用户IP访问前5-折线图
- Line chart
- Management
- 用户IP访问前5-数据表
- Data table
- 用户IP访问前5-热图
- Heatmap chart
- 用户访问状态码前10-饼图
- Piechart
- 课程大纲-MarkDown
- <>Markdownwidget
<!-- OCR_END -->

<!-- OCR_START -->
不安全
10.0.0.54:5601/a
w%2Fd,mode:quick,to:now%2Fd))
应用
T周报TTS系统
kibana
Aheatmapisagraphicalrepresentationofdatawhere theindividual valuescontained inamatrixarerepresentedascolors.
Discover
Linechart
Visualize
Oftenthebestchartforhighdensity time series.Greatforcomparingoneseriestoanother.Becarefulwithsparsesetsastheconnection betweenpointscan
be misleading.
Dashboard
8
Timelion
<>
Markdownwidget
DevTools
Usefulfordisplayingexplanationsorinstructionsfordashboards.
Management
Metric
Onebignumberforall of youronebignumberneeds.Perfectfor showinga countof hits,ortheexactaverageof anumericfield.
Piechart
Piechartsareidealfordisplayingthepartsof somewhole.Forexample,salespercentagesbydepartment.ProTip:Piechartsarebestusedsparingly,andwith
no more than7 slicesperpie.
Tagcloud
Atagcloudvisualizationisavisualrepresentationof textdatatypicallyusedtovisualizeindividualwords.Thefontsizeofawordcorrespondswithits
importance.
Tilemap
longitude coordinates.
Timeseries
Createtimeseriescharts usingthetimelionexpressionlanguage.Perfectforcomputing and combiningtimeseriessetswithfunctionssuchasderivativesand
moving averages
Verticalbarchart
Thegotochartforo-so-manyneeds.Greatfortimeandnon-timedata.Stackedorgrouped,exactnumbersorpercentages.lf youarenotsurewhichchart
youneed,youcould doworse thanto start here.
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/vi
- 应用
- T周报TTS系统
- Visualize/New/Choosesearchsource
- kibana
- Discover
- Visualize
- QFilter...
- 9of9
- Saved Searches Filter....
- Oofo
- ManageSavedSearches
- Dashboard
- 8
- Timelion
- Name
- DevTools
- [logstash_rsyslog-]YYYY.MM.DD
- Nomatchingsavedsearchesfound.
- [m.elk.com-]YYYY.MM.DD
- Management
- [nginx_access-]YYYY.MM.DD
- [ngxlog-JYYYY.MM.DD
- [tc_log-]YYYY.MM.DD
- [tcp_log-JYYYY.MM.DD
- [tomcat_access-]YYYY.MM.DD
- [www.driverzeng.com-]YYYY.MM.DD
- [www.elk.com-]YYYY.MM.DD
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize/create?type=histogram&indexPattern=%5Bwww.driverzeng.com-%5DYYYY.MM.DD&_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:from:now%2Fd,mode:
- 应用T周报TTS系统
- Visualize/NewVisualization(unsaved)
- Save ShareRefresh Today
- kibana
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- 访问次数
- Visualize
- Data Options
- Dashboard
- metrics
- Y-Axis
- 8
- Timelion
- Aggregation
- DevTools
- Count
- Management
- Custom Label
- Advanced
- Addmetrics
- buckets
- X-Axis
- Terms
- Field
- url.keyword
- OrderBy
- metric:访问次数
- Order
- Size
- Descending
- 10
- 用户访问的URL
- Add sub-buckets
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize/create?type=histog
- 应用
- T周报TTS系统
- Visualize/用户访问URL前10-条形图（unsaved）
- kibana
- Refresh
- Today
- SaveVisualization
- Discover
- 用户访问URL前10-条形图
- Visualize
- Save
- Dashboard
- Timelion
- [www.driverzeng.com-jYYYY.MM.DD
- 访问次数
- DevTools
- DataOptions
- Management
- metrics
- Y-AxiS
- Aggregation
- Count
- CustomLabel
- Advanced
- ddmetr
- buckets
- X-Axis
- Terms
- Field
- url.keyword
- OrderBy
- metric:访问次数
- Order
- Size
- Descending
- 10
- 用户访问的URL
- Collapse
<!-- OCR_END -->

## Kibana创建度量图

Kibana度量图

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/visualize？_g=（refreshinterval:(display:Off,pause:f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））
- 应用
- T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch..
- 1-7of7
- Dashboard
- Name
- Type
- 8
- Timelion
- 用户IP访问前5-区域图
- Area chart
- DevTools
- 用户IP访问前5-折线图
- Linechart
- Management
- 用户IP访问前5-数据表
- Data table
- 用户IP访问前5-热图
- Heatmapchart
- 用户访问URL前10-条形图
- Verticalbar chart
- 用户访问状态码前10-饼图
- Pie chart
- 课程大纲-MarkDown
- </>Markdownwidget
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
不安全|10.0.0.54:5601/app/kibana#/visualize/new?_g=（refreshlnterval:(display:Off,pause:f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd)
应用
周报TTS系统
kibana
Datatable
Thedatatableprovidesadetailedbreakdown,intabularformatof theresultsofacomposedaggregation.Tip,adatatableisavailablefrommanyother
Discover
chartsbyclickingthegreybarat thebottomof thechart.
lVisualie
Heatmapchart
Dashboard
Aheatmap isagraphicalrepresentationof datawheretheindividual valuescontained inamatrixarerepresentedascolors.
8
Timelion
Dev Tools
Line chart
Oftenthebestchartforhighdensitytimeseries.Greatforcomparingoneseriestoanother.Becarefulwithsparsesetsastheconnectionbetweenpointscan
Management
bemisleading.
<>
Markdownwidget
Usefulfordisplayingexplanationsorinstructionsfordashboards.
Metric
Onebignumberforallofyouronebignumberneeds.Perfectfor showinga countof hits,ortheexactaverageofanumericfield.
Pie chart
Piecharts areideal fordisplayingthepartsof some
whole.Forexan
mple,salespercentagesbydepartment.ProTip:Piechartsarebestusedsparingly,andwith
nomorethan7slicesperpie.
Tagcloud
Atagcloudvisualizationisavisualrepresentationof textdata,typicallyusedtovisualizeindividualwords.Thefontsizeofawordcorrespondswithits
importance.
Tilemap
Yoursourceforgeographicmaps.Requiresanelasticsearchgeo_pointfieldMorespecificallyafieldthatismappedastpeeo_pointwithlatitudeand
longitude coordinates.
Timeseries
Createtimeserieschartsusingthetimelionexpressionlanguage.Perfectforcomputingand combiningtimeseriessetswithfunctionssuchasderivativesand
moving averages
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/visualize/new/configure?type=metric&_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd))
- 应用T周报TTS系统
- Visualize/New/Choosesearchsource
- kibana
- Discover
- Visualize
- QFilter...
- 9of9
- QbavedSearchesFilter...
- Oofo
- Manage Saved Searches
- Dashboard
- 8
- Timelion
- Name
- DevTools
- [logstash_rsyslog-]YYYY.MM.DD
- No matching saved searchesfound.
- [m.elk.com-]YYY.MM.DD
- Management
- [nginx_access-]YYYY.MM.DD
- [ngx_log-YYYY.MM.DD
- [tc_log-JYYYY.MM.DD
- [tcp_log-JYYYY.MM.DD
- [tomcat_access-]YYYY.MM.DD
- [www.driverzeng.com-]YYYY.MM.DD
- [www.elk.com-JYYYY.MM.DD
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- kibana
- Visualize/NewVisualization(unsaved)
- Save
- Share
- Refresh
- <Today
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- Visualize
- Data Options
- Dashboard
- metrics
- Metric
- Timelion
- Aggregation
- DevTools
- Count
- Management
- Custom Label
- 日志数量
- Advanced
- 144
- Collaps
<!-- OCR_END -->

<!-- OCR_START -->
- 8
- 应用T周报TTS系统
- Visualize/NewVisualization(unsaved)
- SaveShareRefreshToday
- kibana
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- Visualize
- DataOptions
- Dashboard
- metrics
- Metric
- 01x
- Timelion
- Aggregation
- DevTools
- Count
- Management
- CustomLabel
- 日志数量
- 4Advanced
- Average
- Field
- responsetime
- 平均响应时间
- Advanced
- Addmetrics
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/visualize/create?type=metric&indexPattern=%5Bwww.driverzeng.com-%5DYYYY.MM.DD&_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:qui.
- 应用
- T周报TTS系统
- Visualize/New Visualization（unsaved)
- kibana
- Save
- ShareRefreshOToday
- [www.driverzeng.com-jYYYY.MM.DD
- Visualize
- Data Options
- Dashboard
- metrics
- Metric
- 8
- Timelion
- Aggregation
- DevTools
- UniqueCount
- Management
- Field
- clientip.keyword
- CustomLabel
- 所有用户（将IP去重）
- Advanced
- 01x
- Count
- 日志总条数
- Addmetrics
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/visualize/create?type=metric&indexPattern=%5Bwww.driverzeng.com-%5DYYYY.MM.DD&_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:qui
- 应用T周报TTS系统
- Visualize/NewVisualization(unsaved)
- SaveShareRefreshToday
- kibana
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- Visualize
- DataOptions
- Dashboard
- metrics
- Metric
- 01×
- Timelion
- Aggregation
- DevTools
- UniqueCount
- Management
- Field
- clientip.keyword
- Custom Label
- 所有用户（将IP去重）
- Advanced
- Count
- 日志总条数
- 平均响应时间
- Average
- responsetime
- Addmetric
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/
- 应用
- 周报TTS系统
- Visualize/网站访问次数及用户数量-度量图（unsaved）
- ShareRefreshToday
- kibana
- SaveVisualization
- Discover
- 网站访问次数及用户数量度量图
- Visualize
- Save
- Dashboard
- Timelion
- DevTools
- Data Options
- Management
- metrics
- Metric
- 01x
- Aggregation
- Unique Count
- Field
- clientip.keyword
- Custom Label
- 所有用户（将IP去重）
- Advanced
- Count
- 日志总条数
- 平均响应时间
- Average
- responsetime
- Collapse
<!-- OCR_END -->

## Kibana创建标签云

标签云举例

<!-- OCR_START -->
- 数据挖掘
- 机器学习
- 数据库
- 2
- SAS
- 数据应用
- PYTHON
- 数据分
- 数据
- 分析工具
- EXCEL
- 大数据
- 分析报告
- ythah
- SP5S
- 析报告
- 5P55
<!-- OCR_END -->

<!-- OCR_START -->
- Wikis
- Aggregators
- Folksonomy
- User Centered Joy of Use
- Blogs
- Participation
- SixDegrees
- Usability
- Pagerank
- XFN
- Wdgets
- SocialSoftwareFOAF
- Recommendation
- Browser
- Simplicity
- Sharing
- Perpetual Beta
- Collaboration
- Videocasting Podcasting
- AJAX
- Audio Im
- esign
- Web
- 2.0
- Video
- Convergence
- CSS
- PayPer Click
- UMTS
- Mobility
- Affiliation
- Atom
- Ruby on Rails vC
- Trust
- XHTML
- SVG
- OpenAPls
- RSS
- Web StandardssEO
- Economy
- Semantic
- Remixability
- OpenID
- REST
- StandardizationThe Long Tail
- DataDriven Accessibility
- XML
- Microformats Syndication
- Modularity
- SOAP
<!-- OCR_END -->

Kibana标签云

<!-- OCR_START -->
- 9
- 应用
- T周报TTS系统
- Visualize
- kibana
- Discover
- QSearch...
- 1-8of8
- Name
- Type
- 8
- Timelion
- 用户IP访问前5-区域图
- Areachart
- DevTools
- 用户IP访问前5-折线图
- Line chart
- Management
- 用户IP访问前5-数据表
- Datatable
- 用户IP访问前5-热图
- Heatmap chart
- 用户访问URL前10-条形图
- lVertical bar chart
- 用户访问状态码前10-饼图
- Pie chart
- 网站访问次数及用户数量-度量图
- Metric
- 口课程大纲-MarkDown
- </>Markdownwidget
<!-- OCR_END -->

<!-- OCR_START -->
不安全|10.0.0.54:5601/app/kibana#/vi
应用T周报TTS系统
Visualize/New
kibana
Discover
Selectvisualizationtype
lVisualize
Dashboard
Area chart
Greatforstackedtimelinesinwhichthetotal ofall seriesismoreimportant thancomparinganytwo ormoreseries.Lessusefulforassessingtherelative
Timelion
changeofunrelated datapointsaschangesinaserieslowerdownthestackwillhaveadifficult togaugeeffectontheseriesaboveit.
DevTools
Management
Data table
chartsby clickingthegreybarat thebottom of thechart.
Heatmapchart
Aheatmapisagraphicalrepresentationof data wheretheindividual valuescontained inamatrix arerepresentedascolors.
Line chart
Oftenthebestchartforhighdensitytimeseries.Greatforcomparingon
eseriestoanother.Becarefulwithsparsesetsastheconnectionbetweenpointscan
bemisleading.
<>
Markdownwidget
Usefulfordisplayingexplanationsorinstructionsfordashboards.
Metric
Onebignumberforallofyouronebignumberneeds.Perfectforshowingacountofhits,ortheexactaverageofanumericfield.
Piechart
nomore than7slices per pie.
Tagcloud
Collapse
Atagcloudvisualization isavisualrepresenta
atinttpfsenwdatavanivalyzerngcosua
lizeindividualwords.Thefontsizeofawordcorrespondswithits
<!-- OCR_END -->

<!-- OCR_START -->
- %2Fd，m
- uick,to:now%2Fd))
- 应用
- T周报TTS系统
- Visualize/New/Choosesearchsource
- kibana
- Discover
- Visualize
- Q Filter..
- 9of9
- Saved Searches Filter..
- Dashboard
- Oofo
- ManageSavedSearches
- 8
- Timelion
- Name
- DevTools
- [logstash_rsyslog-]YYYY.MM.DD
- Nomatching saved searches found.
- [m.elk.com-]YY.MM.DD
- Management
- [nginx_access-]YYYY.MM.DD
- [ngxlog-]YYYY.MM.DD
- [tc_log-JYYY.MM.DD
- [tcp_log-YYY.MM.DD
- [tomcat_access-]YYYY.MM.DD
- [www.driverzeng.com-JYYY.MM.DD
- [www.elk.com-]YYY.MM.DD
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- me:(from:
- 应用
- T周报TTS系统
- Visualize/NewVisualization(unsaved)
- SaveShareRefreshOToday
- kibana
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- Visualize
- DataOptions
- Dashboard
- metrics
- Tag Size
- Count
- Timelion
- buckets
- Tags
- DevTools
- Aggregation
- Management
- Terms
- Field
- status.keyword
- OrderBy
- metric:Count
- 200
- Order
- Size
- Descending
- 500
- 20
- 403
- 404304302
- CustomLabel
- 504400502
- 前20状态码
- Advanced
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/
- %2Fd))&_a=（filters:!()，lin
- 应用
- T周报TTS系统
- Visualize/用户访问前20状态码-标签云
- SaveShareRefreshToday
- kibana
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- Visualize
- Data
- Options
- Dashboard
- metrics
- Tag Size
- Count
- Timelion
- buckets
- Tags
- DevTools
- Aggregation
- Management
- Terms
- Field
- url.keyword
- OrderBy
- /123.html /login /account
- metric:Count
- Vindex.html
- Order
- Size
- Descending
- 10
- CustomLabel
- /shopping
- /admin
- 前10URL
- /AppStore
- Advanced
<!-- OCR_END -->

## Kibana聚合图形

聚合图形

创建一个`Dashboard`

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/dashboard?_g=()
- 应用T周报TTS系统
- Dashboard
- kibana
- Discover
- QSearch....
- 0-0of0
- Visualize
- Looks likeyou don't have any dashboards.Let's createsome!
- 8
- Timelion
- +Create a dashboard
- DevTools
- Management
- O-0ofo
- Collapse
<!-- OCR_END -->

一开始什么都没有的时候，它会告诉你`Dashboard`是空的，点击`Add`添加。

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kib
- 应用
- T周报TTS系统
- Dashboard/NewDashboard(unsaved)
- Add
- Save
- Share
- Options
- Last15minutes
- kibana
- Discover
- Visualize
- This dashboard is empty. Let's fill it up!
- Dashboard
- Click theAdd
- outton in themenu bar aboveto add a visualization to thedashboard.
- 8
- Timelion
- f youhaven'tsetupavisualizationyetvisitVisualize”tocreateyourfirstvisualization.
- DevTools
- Management
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kibana#/dashboard/create？_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））&_a=（filters:!0,options:(darkTheme:!f),panels:!0,query:(
- 应用T周报TTS系统
- Dashboard/NewDashboard(unsaved)
- AddSaveShareOptions<Today>
- kibana
- Add Panels
- Discover
- Visualization
- SavedSearch
- Visualize
- VisualizationsFilter...
- 9of9
- AddNewVisualization
- Dashboard
- Timelion
- Name
- 用户IP访问前5-区域图
- DevTools
- 用户IP访问前5-折线图
- Management
- 曲用户IP访问前5-数据表
- 选择你选聚合的图，这里就全选了，在企业中一般会按照项目去选择
- 用户IP访问前5-热图
- 用户访问URL前10-条形图
- 用户访问前10URL-标签云
- 用户访问状态码前10-饼图
- 网站访问次数及用户数量-度量图
- </>课程大纲-MarkDown
- Thisdashboardisempty.Let'sfillitup!
- ClicktheAddbuttoninthemenubarabovetoaddavisualizationtothedashboard.
- Ifyouhaven'tsetupavisualizationyetvisit"Visualizetocreateyourfirstvisualization.
- Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kibana#/dashboard/create?_g=（refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））&_a=（filters:!0,options:(darkTheme:!f),panels:!（（col:1,id:.
- 应用T周报TTS系统
- Dashboard/www.dirverzeng.com项目用户ip，URL.聚合图形展示（unsaved)
- ShareOptionsToday
- kibana
- Save dashboard
- Discover
- www.dirverzeng.com项目用户ip，URL.聚合图形展示
- Visualize
- OStoretimewithdashboardo
- Dashboard
- Save
- Timelion
- DevTools
- 用户IP访问前5-区域图
- 用户IP访问前5-折线图
- Management
- 访问次数
- 120-
- 100
- 80
- 50
- 60
- 40
- 20
- 2C
- 用户ip
- 用户IP访问前5-数据表
- 用户IP访问前5-热图
- Count
- 0-33
- 33-65
- 10.0.0.54
- 127
- 65-98
- 98-130
- 10.0.0.53
- 16
- 10.0.0.55
- 用户访问URL前10-条形图
- 用户访问前10URL-标签云
- Collapse
- 123htm
- /AnnStoi
<!-- OCR_END -->

再次点击`Dashboard`就可以看见刚才创建的聚合图形了。

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/app/kib
- ue:0),time:(from:now%2Fd,mode:quick,to:now%2Fd））
- 应用
- T周报TTS系统
- Dashboard
- kibana
- Discover
- QSearch....
- 1-1of1
- Visualize
- Name
- Timelion
- www.dirverzeng.com项目用户IP，URL..聚合图形展示
- DevTools
- Management
<!-- OCR_END -->

<!-- OCR_START -->
- A 不安全|10.0.0.54:5601/app/kibana#/dashboard/fbe7be30-5c18-11e9-b24f-639986428cf9?_g=(refreshlnterval:(display:Off,pause:lf,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd)_a=(fiters:0,options:(darkThem
- e:!f),panels:!((col.
- 应用
- T周报TTS系统
- kiba
- Das
- 用户IP访问前5-区域图
- 用户IP访问前5-折线图
- 访问..
- iashli
- ManTg
- 用户IP访问前5-数据表
- 用户IP访问前5-热图
- 用户IP
- 10.0.0.54
- 127
- 10.0.0.53
- 16
- 10.0.0.55
- 用户访问URL前10-条形图
- 用户访问前10URL-标签云
- /index.html
- /shoppingog
- 用户访问状态码前10-饼图
- 3
- 144
- 所有用户 (将IP去重）
- 日志总条数
- 平均响应时间
- 课程大纲-MarkDown
- 老男孩教育
- Linux云计算课程
- 课程大纲
- ELK阶段
- Elasticsearch安装
- Logstash安装
- Kibana安装
- 。Filebeat安装
- yum Localinstall-y elasticsearch
- yum localinstalt-y Logstash
- yum localinstall -y kibana
- yum Localinstal-y filebeat
- 重点：日志收集，日志画图
- 作者：曾老湿
- QQ:133411023
- 微信：Z133411023
<!-- OCR_END -->

> 更新: 2024-09-20 17:40:57  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/nkofme>