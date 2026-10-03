# 第十五章·Kibana深入-Dev Tools及Lucene语法

## Dev Tools介绍

Dev Tools 页面包含开发工具，您可以使用这些Dev Tools与Kibana中的数据进行交互。

原先的交互式控制台Sense，使用户方便的通过浏览器直接与Elasticsearch进行交互。从Kibana 5开始改名并直接内建在Kibana，就是Dev Tools选项。

Kibana提供了Console UI来通过REST API与Elasticsearch交互，Console位于Kibana的Dev Tools栏下。Console有两个主要区域，左边是编辑区用来书写REST请求，右边用来显示请求返回结果。

***

自动提示

Console提供了自动提示功能，可以为你提供API、方法等提示。编写完请求后点击绿色执行按钮，会在右侧面板给出请求结果。执行按钮旁边的“小扳手”按钮，可以将请求copy转化为curl(copy)，还有一个功能就是自动缩紧格式(Auto  Indent)。如果对已经锁进好的代码进行Auto Indent，Console会将请求体(body)缩进在一行中。

<!-- OCR_START -->
- 1
- GET
- _search
- 2
- "blog":{
- 3-
- "query":{
- "aliases":{,
- 4
- "match"
- "mappings":
- ：，
- ×5
- API
- "settings":{
- 6~
- match_all
- "index":{
- 7
- match_phrase
- "creation_date":"1493710039826"
- match_phrase_prefix
- 8
- "number_of_shards":"3",
- multi_match
- 9
- "number_of_replicas":"2"
- 10
- "uuid":"fKmwONepSZafEnxI8NIxAQ"
- 11-
- "version":{
- 12
- "created":
- "5030099"
- 13
- 14
- "provided_name":"blog"
- 15-
- 16
- 17
- 18-
<!-- OCR_END -->

***

多请求查询

Console支持多请求查询，只需要你将左侧选中执行即可。Console会一次请求Elasticsearch返回结果，多个请求也允许一下复制curl，非常方便。

!

快捷键

Console提供了一些快捷键，来提高使用效率。

| 快捷键 | 说明 |
| --- | --- |
| ctrl/cmd + enter | 提交请求 |
| ctrl/cmd + alt/option + L | 叠起/打开当前代码 |
| ctrl/cmd + up/down | 跳到上一个或下一个执行块 |
| ctrl/cmd + I | 缩进格式 |
| esc | 关闭当前提示框 |

| 历史 |
| --- |

点击Console的顶部有History，会显示最近500条请求成功的历史纪录。左侧显示历史纪录，点击其中一条后会在右侧显示。

<!-- OCR_START -->
- 不安全|10.0.0.54601/app/kibana#/dev_tols/console_g=（fiters:0,refreshlnterval:(display:ff,pause:f,value:0)time:(from:now%2Fd,mode:quick,tonow%d）)
- 9
- 应用
- T周报TTS系统
- DevTools
- HistorySettings Help
- kibana
- History
- Discover
- 1PUT hello_world
- hello_world (12minutes ago)
- 2
- Visualize
- logs(13minutes ago)
- Dashboard
- _search(4 hours ago)
- Timelion
- _cat/indices(4 hours ago)
- Management
- Clear
- Apply
- 1
- GET
- _search
- "acknowledged":true,
- 3
- "query":{
- "shards_acknowledged":true
- "match_all":{}
- 4-
- 8
- 5
- 6-}
- GET_cat/indices
- 10
- PUThello_world
- Collapse
<!-- OCR_END -->

点击apply会自动copy到下面的Console编辑区，点击Clear会清空所有历史请求。

| 配置(Setting) |
| --- |

Console提供了一些基础配置，比如字体大小等。

<!-- OCR_START -->
- DevTools
- History
- Settings
- Help
- Font Size
- 14
- (>
- Wraplong lines
- Autocomplete
- Fields
- Indices&Aliases
- Cancel
- Save
<!-- OCR_END -->

***

| 关闭Console(Setting) |
| --- |

如果不想使用Console可以在$KIBANA/config/kibana.yml中设置：

console.enabled: false

这样就关闭了Console了，不过重启Kibana过程比较慢，需要几分钟。

## Dev Tools常用查询命令

| 上传日志 |
| --- |

不管在学任何开发语言，我们第一个学的都是"Hello World"

`仪式感`

```bash
PUT hello_world
```

<!-- OCR_START -->
- %2Fd,mode:quick,to:now%2Fd)）
- 应用
- T周报TTS系统
- DevTools
- History SettingsHelp
- kibana
- Discover
- 1PUT hello_world
- 1-{
- "acknowledged":true,
- Visualize
- "shards_acknowledged":true
- 4-
- Dashboard
- Timelion
- Management
<!-- OCR_END -->

| match_all查询所有索引包括内容 |
| --- |

```bash
GET _search
{
  "query": {
    "match_all": {}
  }
}
```

<!-- OCR_START -->
A不安全|10.0.0.54:5601/app/kibana#/dev_tools/console？_g=（filters:0),refreshlnterval:(display:Off,pause:f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd）)
应用
周报TTS系统
Dev Tools
History
Settings
kibana
Help
1
GET_search
2
"took":56,
Visualize
3
"query":{
"timed_out":false,
"match_all":}
4-
"_shards":{
Dashboard
5
"total":169,
6-}
"successful":169,
8
Timelion
7
"failed":0
9-
"hits":{
10
"total":21317,
Management
11
"max_score":1,
12-
13-
14
"_index":".kibana"，
15
"_type":"index-pattern",
16
"_id":"metricbeat-*",
17
"_score":1,
18-
"_source":{
19
"title":"metricbeat-*",
20
"timeFieldName":"@timestamp",
21
"fields":"""["name":"redis.info.cluster.enabled","type":"boolean","count":0,"scripted":false
,"indexed":true,"analyzed":false,"doc_values":true,"searchable":false,"aggregatable":false},{”name":”system
.process.cgroup.memory.mem.usage.max.bytes","type":"number","count":0,"scripted":false,"indexed":true,"analyze
d":false,"doc_values":true,”searchable":false,"aggregatable":false},{"name":"couchbase.node.get_hits","type"
:"number","count":0,"scripted":false,"indexed":true,"analyzed":false,"doc_values":true,"searchable":false
,"aggregatable":false}，"name":"haproxy.stat.queue.limit","type":"number","count":0,"scripted":false,"indexed"
：true,"analyzed":false,"doc_values":true,"searchable":false,"aggregatable":false},{"name":"system.socket.local
port","type":"number","count":0,"scripted":false,"indexed":true,"analyzed":false,"doc_values":true,”searchabl
e":false,"aggregatable":false},{"name":"redis.info.persistence.aof.rewrite.in_progress","type":"boolean"
,"count":0,"scripted":false,"indexed":true,”analyzed":false,"doc_values":true,"searchable":false,"aggregatable
":false},{"name":"mongodb.status.extra_info.heap_usage.bytes","type":"number","count":0,"scripted":false
.stat.check.health.last","type":"number","count":0,"scripted":false,"indexed":true,"analyzed":false,"doc_value
s":true,"searchable":false,"aggregatable":false},{"name":"system.socket.remote.port","type":"number","count":0
,"scripted":false,"indexed":true,"analyzed":false,"doc_values":true,"searchable":false,"aggregatable":false}
,"name":"haproxy.stat.client.aborted","type":”number","count":0,"scripted":false,"indexed":true,"analyzed"
:false,"doc_values":true,"searchable":false,"aggregatable":false},{"name":"system.filesystem.device_name"
,"type":"string","count":0,"scripted":false,"indexed":true,"analyzed":false,"doc_values":true,“searchable"
:true,"aggregatable":true},{"name":"zookeeper.mntr.open_file_descriptor_count","type":"number","count":0
,"name":"docker.container.size.rw","type":”number","count":0,"scripted":false,"indexed":true,"analyzed":false
,"doc_values":true,"searchable":false,"aggregatable":false},"name":“mongodb.status.wiredtiger.cache.pages
write","type":"number","count":0,"scripted":false,"indexed":true,"analyzed":false,"doc_values":true,“searchab
le":false,“aggregatable”:false}，{”name":"docker.info.id","type":"string","count":0,"scripted":false,"indexed"”
Collapse
<!-- OCR_END -->

***

| 查询所有索引名称 |
| --- |

也就是查看一下我们在ES中有多少个日志

```bash
GET _cat/indices
```

<!-- OCR_START -->
- A不安全|100.0.54:5601/app/ibana#/dev_tools/console_g=（filters:0),refreshlnterval:（display:Off,pause:fvalue:0)time:(from:now%2Fdmode:quick,tonow%）
- 应用
- 周报TTS系统
- DevTools
- History
- SettingsHelp
- kibana
- Discover
- 1GET_cat/indices
- 1
- green openlogstash-www.driverzeng.com-2019.04.11Tk1diVcmQrigCxYCMHC8UQ61
- 320699.8kb341.3kb
- greenopenww.driverzeng.com-2019.04.11
- mSdKKwfXQ6SpkIr32i6rDw61
- 310793.8kb 396.9kb
- Visualize
- green open zls_2019.03.30
- u0Ki8AMYQ6mf3Vv00941Aw61
- 190170.1kb
- 85kb
- greenopenlogstash-www.driverzeng.com-2019.04.12QsuJlsomSdyYae8DoxjurA61
- 420429.8kb214.9kb
- 5
- greenopenes_log_2019.04.01
- s784Ls-mSEqrK2zTfeHz7Q61
- 20
- 25.8kb
- 12.9kb
- 6
- green open nginx_access-2019.04.08
- _K39styERWCqt3Xrs-UNQw61
- 900524.2kb 262.1kb
- Timelion
- 7
- greenopen tc_log-2019.04.11
- 4vsaItuiT9-wASWI96Ho4g61
- 2070897.7kb 449.3kb
- 8
- greenopen ngx_log-2019.04.09
- JUmOom_RRqS3eEWiuMAeBw61
- 160229.6kb
- 121kb
- 9
- green openngx_log-2019.04.11
- RDCWZvHLQDaRBiPZoMKXow61
- 66 0 609.7kb 304.8kb
- 10
- green open message_log_2019.03.30
- PD6vz68JR02etRd2hPaGRw61
- 28kb
- 14kb
- Management
- 11
- green open m.driverzeng.com-2019.04.11
- 5Ei9b_9DQeKxpQz74rcr_A61
- 2920
- 1mb
- 546kb
- 12
- green openmessage_log_2019.03.31
- a_o0SVpZTQ-6S5f-0aMNYw61
- 40
- 55.3kb
- 27.6kb
- 13
- green open zls_2019.03.27
- Noc34f92ShKcbdvqERVMHQ61
- 50
- 30.2kb
- 15.1kb
- 14
- green open tomcat_access-2019.04.08
- 5HXDc0I5Q1ym9_JJxnITnA61
- 1050834.3kb
- 417.1kb
- 15
- green open ngx_zls-2019.04.08
- qjOROE_mQT-70EqoT0W9Sg61
- 218 0 606.7kb 270.9kb
- 16
- green openwww.elk.com-2019.04.08
- ULpYfERTTSqNf54wM35TLQ61
- 360
- 498kb
- 239kb
- 17
- greenopenzlsindex
- C807IxEVR2W7CpPFFCa4cA61
- 1010.1kb
- 5kb
- 18
- greenopentc_log-2019.04.08
- R3YBHWaOTq-pO1SXoKUKUg61
- 1610352.2kb 167.5kb
- 19
- greenopenhello_world
- f6B_oZLYRIeaM7dSXUtdoQ61
- 1.5kb
- 780b
- green open m.elk.com-2019.04.08
- rkEnd2PWRxCBZTcXkvGzhw61
- 240219.9kb109.9kb
- 21
- green open.kibana
- XzhNaytGR00ff9bI3B8CoA11
- 370
- 288kb151.2kb
- 22
- green open tcp_log-2019.04.08
- v5Dh9kwDQWKZ0BLf9Q-kvQ61
- 24.5kb
- 12.2kb
- 23
- green open ngx_log-2019.04.08
- eoSq4nVTT7ef08fQ0ZI29g61
- 2010507.1kb
- 231.6kb
- 24
- green open zls_2019.03.05
- R8IZGhT4Sw2XukCiG1002A 61
- 11.6kb
- 5.8kb
- 25
- green open metricbeat-2019.04.12
- f-QPN7AvRNi86fBaT6Gg0w61197880
- 11.1mb
- 5.5mb
- 26
- greenopenlogstash-m.driverzeng.com-2019.04.12
- iooSgrftTMmXPOYVkSRqgQ61
- 350396.3kb
- 198.1kb
- 27
- green openlogstash_rsyslog-2019.04.08
- bCy9ayDnTNGGaoCROTnqPQ61
- 820743.7kb
- 381.5kb
- 28
- green open secure_log_2019.03.30
- CU69-D01SQ2Ss30-Jf0jPg61
- 13.8kb
- 6.9kb
- 29
- green open tomcat_access-2019.03.31
- q6oVLxjCTrOTSmipZl-_sg61
- 110
- 80.4kb
- 40.2kb
- 30
- Collapse
<!-- OCR_END -->

| 查询集群节点是否禁用swap |
| --- |

```bash
GET _nodes?filter_path=**.mlockall
#结果
{
  "nodes": {
    "by_wSvKYQ5ycGlHxW0UWoQ": {
      "process": {
        "mlockall": false
      }
    },
    "iYV6jXoFQsaJJCTBXtaoWA": {
      "process": {
        "mlockall": false
      }
    }
  }
}
```

<!-- OCR_START -->
| C | C | C | 排名 | C | C |
| --- | --- | --- | --- | --- | --- |
| 9 | 应用 | TTTS | Dev Tools | History   Settings | Help |
| kibana | .mlockall | 1- | 23 | nodes":{ | 巨 |
| Visualize | "by_wSvKYQ5ycGLHxWOUWoQ": { | 4 | "process":{ | Dashboard | 5 |
| "mlockall":false | 6 | Timelion | 7 | 8- | "iYV6jXoFQsaJJCTBXtaoWA":{ |
| DevTools | 9- | "process":{ | 10 | "mlockall": false | Manageme |
<!-- OCR_END -->

| 查询集群节点最大文件描述符 |
| --- |

```bash
GET _nodes/stats/process?filter_path=**.max_file_descriptors
#结果
{
  "nodes": {
    "by_wSvKYQ5ycGlHxW0UWoQ": {
      "process": {
        "max_file_descriptors": 131072
      }
    },
    "iYV6jXoFQsaJJCTBXtaoWA": {
      "process": {
        "max_file_descriptors": 131072
      }
    }
  }
}
```

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/kib
- w%2Fd,r
- de:quick,to:now%2Fd))
- 应用
- TTTS
- DevTools
- History Settings
- Help
- kibana
- Discover
- 1GET _nodes/stats/process?filter_path=**.max_file_
- 1-
- descriptors
- 23
- nodes":{
- Visualize
- "by_wSvKYQ5ycGLHxWOUWoQ": {
- 4
- "process":{
- Dashboard
- 5
- "max_file_descriptors": 131072
- Timelion
- 8-
- "iYV6jXoFQsaJJCTBXtaoWA":{
- 9、
- 10
- Management
- 11~
- 12
- 13
- 14-
<!-- OCR_END -->

***

| 集群分片情况查询 |
| --- |

```bash
GET _cat/shards
```

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/ap
- #/dev_tools/co
- nsole?_g=（filters:!0),refreshlnterval:(display:Off,pause:!f,value:O),time:(fro
- uick,to:now%2Fd))
- 应用
- TTTS
- DevTools
- History  Settings  Help
- kibana
- 1GET_cat/shards
- 0pSTARTED
- 37
- 151.2kb10.0.0.51elk01
- 136.8kb 10.0.0.52 elk02
- Visualize
- ngx_zls-2019.04.08
- 5rSTARTED
- 35
- 42.9kb 10.0.0.51 elk01
- 4
- 42.9kb 10.0.0.52 elk02
- Dashboard
- 1r STARTED
- 28
- 42.5kb 10.0.0.51 elk01
- 42.5kb 10.0.0.52 elk02
- 6
- Timelion
- 7
- 4pSTARTED
- 46.6kb 10.0.0.51 elk01
- 8
- 73kb 10.0.0.52 elk02
- 9
- 3rSTARTED
- 42
- 51.1kb 10.0.0.51 elk01
- 10
- 51.1kb 10.0.0.52 elk02
- Management
- 11
- 2pSTARTED
- 36
- 44.1kb
- 10.0.0.51 elk01
- 12
- 70.5kb 10.0.0.52 elk02
- 13
- 43.5kb 10.0.0.51 elk01
- 14
- 55.6kb 10.0.0.52 elk02
- 15
- zls_2019.03.05
- 159b 10.0.0.51 elk01
- 16
- 159b 10.0.0.52 elk02
- 17
- 18
- 19
- 20
- 21
- 5kb 10.0.0.51 elk01
- 22
- 5kb 10.0.0.52 elk02
- 23
- 24
- 25
- 26
- 27
- www.elk.com-2019.04.08
- 41.2kb 10.0.0.51 elk01
- 41.2kb 10.0.0.52 elk02
- 5
- 41.7kb 10.0.0.51 elk01
- 29
- 30
- 41.7kb 10.0.0.52 elk02
- 31
- 3
- 20.8kb 10.0.0.51 elk01
- 32
- 20.8kb 10.0.0.52 elk02
- 33
- 31.2kb 10.0.0.51 elk01
- 34
- 31.2kb 10.0.0.52 elk02
- 72.6kb 10.0.0.51 elk01
- 62.5kb 10.0.0.52elk02
- 41.3kb 10.0.0.51 elk01
- 38
- 51.2kb 10.0.0.52 elk02
- 39
- message_log_2019.03.30
- 40
- 41
- 43
- 7.2kb 10.0.0.51 elk01
- 7.2kb 10.0.0.52 elk02
- Collapse
- 6.1kb 10.0.0.51 elk01
<!-- OCR_END -->

## Lucene 语法介绍

***

| 全文搜索 |
| --- |

在搜索栏输入404，会返回所有字段值中包含404的日志

使用双引号包起来作为一个短语搜索

`"like Gecko"`

| 字段搜索 |
| --- |

也可以按页面左侧显示的字段搜索

限定字段全文搜索：`field:value`

精确搜索：关键字加上双引号`filed:"value"`

`status:404` 搜索http状态码为404的日志

字段本身是否存在

`_exists_：http`：返回结果中需要有http字段

`_missing_：http`：不能含有http字段

| 通配符搜索 |
| --- |

`?` 匹配单个字符

`*` 匹配0到多个字符

可以看到两次搜索内容左上角，第一次是109 hits，第二次是182 hits

第一次匹配到的内容只有109条，第二次有182条。

`?` `*` 不能用作第一个字符，例如：`?status` `*status`

| 正则搜索 |
| --- |

es支持部分正则功能,性能较差

`domain:/adm?n.vantage(fx[prime]).com.cn/`

| 模糊搜索 |
| --- |

`quikc~` `brwn~` `foks~`

`~`:在一个单词后面加上~启用模糊搜索，可以搜到一些拼写错误的单词

`first~` 这种也能匹配到 frist

还可以设置编辑距离（整数），指定需要多少相似度

`cromm~1` 会匹配到 from 和 chrome

默认2，越大越接近搜索的原始值，设置为1基本能搜到80%拼写错误的单词

| 近似搜索 |
| --- |

在短语后面加上`~`，可以搜到被隔开或顺序不同的单词

`"where select"~5` 表示 select 和 where 中间可以隔着5个单词，可以搜到 select password from users where id=1

| 范围搜索 |
| --- |

数值/时间/IP/字符串

类型的字段可以对某一范围进行查询

`length:[100 TO 200]`

`sip:["172.24.20.110" TO "172.24.20.140"]`

`date:{"now-6h" TO "now"}`

`tag:{b TO e}` 搜索b到e中间的字符

`count:[10 TO *] *` 表示一端不限制范围

`count:[1 TO 5} [ ]` 表示端点数值包含在范围内，{ } 表示端点数值不包含在范围内，可以混合使用，此语句为1到5，包括1，不包括5

可以简化成以下写法：

`age:>10`

`age:<=10`

`age:(>=10 AND <20)`

| 优先级 |
| --- |

`quick^2 fox`

使用<sup>使一个词语比另一个搜索优先级更高，默认为1，可以为0~1之间的浮点数，来降低优先级</sup>

| 逻辑操作 |
| --- |

`AND`

`OR`

`+`：搜索结果中必须包含此项

`-`：不能含有此项

`+apache -jakarta test aaa bbb`：结果中必须存在apache，不能有jakarta，剩余部分尽量都匹配到

| 分组 |
| --- |

`(elasticsearch OR logstash) AND elasticsearch`

| 字段分组 |
| --- |

`title:(+return +"pink panther")`

`host:(baidu OR qq OR google) AND host:(com OR cn)`

| 转译特殊字符 |
| --- |

`+ - = && || > < ! ( ) { } [ ] ^ " ~ * ? : \ /`

以上字符当作值搜索的时候需要用\转义

`\(1\+1\)\=2`用来查询(1+1)=2

> 更新: 2024-09-20 21:40:07  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/pzh7vx>