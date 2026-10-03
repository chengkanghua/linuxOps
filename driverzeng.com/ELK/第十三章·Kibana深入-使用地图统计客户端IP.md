# 第十三章·Kibana深入-使用地图统计客户端IP

## 地址库

在ELK中，我们可以使用地址库，来对IP进行分析，对日志进行分析，在ELKstack中只有Logstash可以做到，但是出图，是Kibana来出的，所以我们首先需要下载地址库数据文件，然后对Logstash进行配置，使用`geoip`模块对日志访问IP进行分析后，再以`中国地图`或者是`世界地图`的形式，展现在Kibana中。

| 下载地址库 |
| :--- |

Logstash2版本下载地址：<http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz>

logstash5版本下载地址：<http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz>

上面地址失效了

<https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=O38GA2SviPLnqfF5&suffix=tar.gz>

<https://github.com/DocSpring/geolite2-city-mirror>

```bash
#进入Logstash目录
[root@elkstack03 ~]# cd /etc/logstash/
#下载地址库
[root@elkstack03 logstash]# wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
#解压地址库文件
[root@elkstack03 logstash]# tar xf GeoLite2-City.tar.gz
#查看地址库文件
[root@elkstack03 logstash]# ll
总用量 28784
drwxrwxr-x 2 root root     4096 4月  11 11:36 conf.d
drwxr-xr-x 2 2000 2000     4096 4月   8 20:07 GeoLite2-City_20190409
-rw-r--r-- 1 root root 29444833 4月   9 15:32 GeoLite2-City_20190409.tar.gz
-rw-rw-r-- 1 root root     1738 3月  23 2017 jvm.options
-rw-rw-r-- 1 root root     1334 3月  23 2017 log4j2.properties
-rw-rw-r-- 1 root root     4484 3月   5 17:35 logstash.yml
-rw-rw-r-- 1 root root     1659 3月  23 2017 startup.options
```

## 配置Logstash使用地址库

| 配置Logstash |
| :--- |

```bash
#进入Logstash配置文件目录
[root@elkstack03 logstash]# cd /etc/logstash/conf.d/
#编辑Logstash配置文件
[root@elkstack03 conf.d]# vim /etc/logstash/conf.d/redis_es_ip.conf
input {
  redis {
    host => "10.0.0.54"
    port => "6379"
    db => "1"
    key => "all"
    data_type => "list"
    password => "zls"
 }
}
filter {
        json {
            source => "message"
            remove_field => ["message"]
        }
        geoip {
                source => "clientip"
                target => "geoip"
                database => "/etc/logstash/GeoLite2-City_20240917/GeoLite2-City.mmdb"
                add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
                add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}"  ]
        }
    mutate {
      convert => [ "[geoip][coordinates]", "float"]
        }
}
output {
    elasticsearch {
      hosts => ["10.0.0.51:9200"]
      index => "www.xudao.com-%{+YYYY.MM.dd}"
    }
}
#启动Logstash
[root@elkstack03 ~]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/redis_es_ip.conf &

# 这里时间改成今年的
#因为是单机环境，日志里面没有公网IP，所以我们需要自己往里输入公网IP
#北京公网IP
echo '{"@timestamp":"2024-09-11T20:27:25+08:00","host":"222.28.0.112","clientip":"222.28.0.112","size":0,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"www.elk.com","url":"/index.html","domain":"www.elk.com","xff":"10.0.0.1","referer":"-","status":"304"}' >> /usr/local/nginx/logs/access_json.log
#海南公网IP
echo '{"@timestamp":"2024-09-11T20:40:24+08:00","host":" 124.225.0.13","clientip":"124.225.0.13","size":0,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"www.elk.com","url":"/index.html","domain":"www.elk.com","xff":"10.0.0.1","referer":"-","status":"304"}' >> /usr/local/nginx/logs/access_json.log
#吉林公网IP
echo '{"@timestamp":"2024-09-11T20:45:24+08:00","host":" 124.234.0.12","clientip":"124.234.0.12","size":0,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"www.elk.com","url":"/index.html","domain":"www.elk.com","xff":"10.0.0.1","referer":"-","status":"304"}' >> /usr/local/nginx/logs/access_json.log
#黑龙江公网IP
echo '{"@timestamp":"2024-09-11T20:46:24+08:00","host":" 123.164.0.18","clientip":"123.164.0.18","size":0,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"www.elk.com","url":"/index.html","domain":"www.elk.com","xff":"10.0.0.1","referer":"-","status":"304"}' >> /usr/local/nginx/logs/access_json.log

```

***

## 验证Kibana中的数据

打开浏览器，访问：[http://10.0.0.54:5601](http://10.0.0.54:5601/)

**北京公网IP**

<!-- OCR_START -->
- 不安全|10.0.0.54
- 应用
- T周报TTS系统
- kibana
- April 11th 2019,20:27:24.000
- referer:-geoip.timezone:Asia/Shanghaigeoip.ip:222.28.0.111geoip.latitude:39.929
- geoip.coordinates:116.389,39.929 geoip.continent_code:AS
- geoip.city_name:Beijing geoip.country_code2:CN geoip.country_name:China
- geoip.cou
- ntry_code3:CN geoip.region_name:Beijing geoip.1ocation:116.389,39.
- 929geoip.longitude:116.389 geoip.region_code:BJ offset:1,648 input_type:log source:/usr/local/nginx/logs/access_json.log type:ww.driverzeng.com
- Discover
- http_host:ww.elk.com url:/index.html upstreamhost:-@timestamp: April 11th 2019,20:27:24.000 size:0clientip: 222.28.0.111 domain:www.elk.com
- Visualize
- beat.hostname:elkstack03 beat.name:elkstack03 beat.version:5.3.2 @version:1host:124.225.0.13responsetime:0xff:10.0.0.1upstreamtime:
- Link to/Www.driverzeng.com-2019.04.11/www. driverzeng.com/AWoMaooLxCtS9Tdyw_fD
- Dashboard
- Table
- JSON
- Timelion
- @timestamp
- Q*April11th2019,20:27:24.000
- Dev Tools
- t@version
- @Q四*1
- t_id
- @Q*AWoMaooLxCtS9Tdyw_fD
- Management
- t_index
- @Qm* www.driverzeng.com-2019.04.11
- #_score
- @Q*
- t_type
- www.driverzeng.com
- tbeat.hostname
- @Q四*elkstack03
- tbeat.name
- @Q* elkstack03
- tbeat.version
- Q*5.3.2
- tclientip
- @Q*222.28.0.111
- tdomain
- .elk.
- com
- tgeoip.city_name
- @Q*Beijing
- t geoip.continent_code @Q四* AS
- #geoip.coordinates
- @Q* 116.389, 39.929
- t geoip.country_code3
- @Q田*CN
- @Q*CN
- t geoip.country_name
- @Q*China
- tgeoip.ip
- #geoip.latitude
- Q*39.929
- #geoip.location
- geoip.longitude
- Q*116.389
- t geoip.region_code
- @Q*BJ
- tgeoip.region_name
- tgeoip.timezone
- Q*Asia/Shanghai
- thost
- thttp_host
<!-- OCR_END -->

**海南公网IP**

<!-- OCR_START -->
- 不安
- 10.0.0.54:5601/a
- e:0),t
- %5DYYYY.MM.DD,inter
- 应用
- T周报TTS系统
- kibana
- geoip.city_name: Qionghai geoip.co
- try_code3:CN
- geoip.region_
- lame:Hainangeoip.1ocation:110.577,19.
- 168geoip.longitude:110.577 geoip.region_code:HI offset:2,473 input_type:log
- source:/usr/local/nginx/logs/access_json.logtype:www.driverzeng.com
- Discover
- http_host:www.elk.comurl:/index.htmlupstreamhost:
- @timestamp:April11th2019,20:40:24.000size:0clientip:124.225.0.13domain:www.elk.com
- @version:1host:
- 124.225.0.13res
- sponsetime:0xff:10.0.0.1upstreamtime:
- Visualize
- Table
- Linkto/www.driverzeng.com-2019.04.11/www.driverzeng.com/AWoMbUYvxCtS9Tdyw_fH
- Dashboard
- JSON
- @timestamp
- Timelion
- @@  * April 11th 2019,20:40:24.000
- t@version
- @Q*1
- DevTools
- t_id
- ④Q*
- AWoMbUYvxCtS9Tdyw_fH
- Management
- t_index
- www.driverzeng.com-2019.04.11
- #_score
- t-type
- @@m*ww.driverzeng.com
- tbeat.hostname
- @Q*elkstack03
- tbeat.name
- tbeat.version
- @Q5.3.2
- tclientip
- @Q*124.225.0.13
- domain
- @Q四*
- elk.
- tgeoip.city_name
- @Q*Qionghai
- tgeoip.continent_code @Q四* AS
- #geoip.coordinates
- @Q* 110.577, 19.168
- t geoip.country_code3
- @Q*CN
- tgeoip.country_name
- @Q*China
- tgeoip.ip
- #geoip.latitude
- @Q*19.168
- #geoip.location
- #geoip.longitude
- ④Q*110.577
- tgeoip.region_code
- Q*HI
- t geoip.region_name
- @Q*Hainan
- tgeoip.timezone
- Qm*Asia/Shanghai
- thost
- thttp_host
<!-- OCR_END -->

**吉林公网IP**

<!-- OCR_START -->
- 应用

```text
不安全|10.0.0.54
T周报TTS系统
kibana
April 11th 2019, 20:45:24.000
referer:-geoip.timezone:Asia/Shanghai geoip.ip:124.234.0.12 geoip.latitude:43.88 geoip.country_code2:CN geoip.country_name:China
geoip.coordinates:125.323, 43.88 geoip.continent_code: AS geoip.country_code3:CN geoip.region_name:Jilin geoip.location:125.323, 43.88
geoip.longitude:125.323 geoip.region_code: JL offset:4,948 input_type:log source:/usr/local/nginx/logs/access_json.log type: www.driverzeng.com
Discover
http_host: www.elk.com url: /index.html upstreamhost:-@timestamp: April 11th 2019, 20:45:24.000 size: 0 clientip: 124.234.0.12 domain: www.elk.com
Visualize
beat.hostname: elkstack03 beat.name: elkstack03 beat.version: 5.3.2 @version:1 host:124.234.0.12 responsetime: 0xff:10.0.0.1upstreamtime:
Dashboard
Link to/Www.driverzeng.com-2019.04.11/www. driverzeng.com/AWoMcAVaxCts9Tdyw_ fR
Table
JSON
Timelion
@timestamp
@Q * April 11th 2019, 20:45:24.000
DevTools
t@version
@Q*1
t-id
@Q*AWoMcAVaxCtS9Tdyw_fR
Management
t_index
@Qm * www.driverzeng.com-2019.04.11
#_score
t_type
www.driverzeng.com
tbeat.hostname
@Q* elkstack03
tbeat.name
@Q* elkstack03
tbeat.version
@Q*5.3.2
tclientip
@Q*124.234.0.12
tdomain
@Qm* www.elk.com
t geoip.continent_code @@四* AS
#geoip.coordinates
@Q*125.323, 43.88
t geoip.country_codez
@Q*CN
tgeoip.country_code3
@Q*CN
t geoip.country_name
@Q*China
t geoip.ip
@Q*124.234.0.12
#geoip.latitude
@Q*43.88
#geoip.location
@Q*125.323, 43.88
#geoip.longitude
Q*125.323
t geoip.region_code
@Q*JL
t geoip.region_name
@Q*Jilin
tgeoip.timezone
@Q四* Asia/Shanghai
thost
@Q*124.234.0.12
thttp_host
Collapse
input_type
```
<!-- OCR_END -->

**黑龙江公网IP**

<!-- OCR_START -->
- (%2Fd))&_
- 应用
- T周报TTS系统
- tdomain
- April 11th 2019, 20:46:24.000
- referer:-geoip.timezone:Asia/Shanghai geoip.ip: 123.164.0.18 geoip.latitude: 45.75 geoip.country_code2:CN geoip.country_name: China
- kibana
- tgeoip.city_name
- geoip.coordinates: 126.65, 45.75 geoip.continent_code: AS geoip.country_code3: CN geoip.region_name: Heilongjiang geoip.location: 126.65, 45.75
- geoip.longitude: 126.65 geoip.region_code: HL offset: 8,523 input_type: log source: /usr/local/nginx/logs/access_json.log type: ww.driverzeng.com
- tgeoip.continent_code
- Discover
- http_host: www.elk.com url: /index.html upstreamhost:-@timestamp: April 11th 2019, 20:46:24.000 size:0 clientip: 123.164.0.18 domain: www.elk.com
- #geoip.coordinates
- beat.hostname:elkstack03 beat.name:elkstack03beat.version:5.3.2@version:1host:
- 123.164.0.18responsetime:0xff:10.0.0.1upstreamtime:
- Visualize
- t geoip.country_code3
- t geoip.country_code3
- Link to/www. driverzeng.com-2019.04.11/www.driverzeng.com/AWoMcQopxCts9Tdyw_fe
- Dashboard
- Table
- JSON
- tgeoip.country_name
- Timelion
- ① @timestamp
- t geoip.ip
- #geoip.latitude
- t@version
- @Q*1
- DevTools
- #geoip.location
- t_id
- @@ *AWoMcQOpxCtS9Tdyw_fe
- Management
- #geoip.longitude
- t_index
- @@*ww.driverzeng.com-2019.04.11
- t geoip.region_code
- #_score
- tgeoip.region_name
- t_type
- @Q*www.driverzeng.com
- tgeoip.timezone
- tbeat.hostname
- @Q四* elkstack03
- thost
- tbeat.name
- t http_host
- t beat.version
- ④Q*5.3.2
- tinput_type
- tclientip
- @Q*123.164.0.18
- #offset
- domain
- @Q*ww.elk.com
- treferer
- tgeoip.continent_code@Q四*AS
- #responsetime
- @Q* 126.65, 45.75
- #size
- tsource
- @Q*CN
- t status
- Q*China
- tupstreamhost
- tupstreamtime
- Q*45.75
- turl
- txff
- ④Q*126.65
- geoip.region_code
- @Q*HL
- geoip.region_name
- @Q四* Heilongjiang
- geoip.timezone
- @Q*Asia/Shanghai
- @Q*
- 123.164.0.18
- Collapse
- input_type
<!-- OCR_END -->

## 配置Kibana使用地图

| Kibana画中国地图 |
| :--- |

<!-- OCR_START -->
- w%2Fd))
- 应用T 周报TTS系统
- Visualize
- kibana
- Discover
- Q Search..
- 1-9of9<>
- Dashboard
- Name
- Type
- 用户IP访问前5-区域图
- Timelion
- Area chart
- DevTools
- 口用户IP访问前5-折线图
- Line chart
- Management
- 用户IP访问前5-数据表
- Datatable
- 用户IP访问前5-热图
- I Heatmapchart
- 用户访问URL前10-条形图
- LlVertical bar chart
- 用户访问前10URL-标签云
- Tag cloud
- 用户访问状态码前10-饼图
- Pie chart
- 网站访问次数及用户数量-度量图
- Metric
- 课程大纲-MarkDown
- </> Markdown widget
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全|10.0.0.54:5601/ap
- v%2Fd,
- 应用
- T周报TTS系统
- Heatmapchart
- kibana
- A heat map is a graphical representation of data where the individual values contained in a matrix are represented as colors.
- Discover
- Line chart
- Visualize
- nectionbetweenpointscan
- be misleading.
- Dashboard
- Timelion
- <>
- Markdownwidget
- DevTools
- Useful for displaying explanations or instructions for dashboards.
- Management
- Metric
- Piechart
- ment.ProTip:Piechartsarebestusedsparingly,andwith
- no more than 7 slices per pie.
- Tag cloud
- respondswithits
- importance.
- Tilemap
- Your source for geographic maps.
- longitude coordinates.
- Timeseries
- Createtimeserieschartsusingth
- moving averages
- Vertical bar chart
- you need,you could do wor
<!-- OCR_END -->

<!-- OCR_START -->
→C不安全|10.0.0.54:5601/app/kibana#/visualize/new
应用T周报TTS系统
Visualize / New / Choose search source
kibana
Discover
From a New Search, Select Index
Or, From a Saved Search
Visualize
Q Filter..
10of10
QSaved Searches Filter..
OofoManage Saved Searches
Dashboard
Timelion
Name
[logstash_rsyslog-JYYY.MM.DD
No matching saved searches found.
DevTools
[m.driverzeng.com-]YYYY.MM.DD
Management
[m.elk.com-JYYYY.MM.DD
[nginx_access-JYYY.MM.DD
[ngx_log-]JYYY.MM.DD
[tc_log-JYYYY.MM.DD
[tcp_log-JYYYY.MM.DD
[tomcat_access-]YYYY.MM.DD
[www.driverzeng.com-JYYYY.MM.DD
[www.elk.com-JYYY.MM.DD
1
Collapse
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T周报TTS系统
- Visualize/NewVisualization(unsaved)
- Save
- Share
- Refresh
- Today
- kibana
- Discover
- [www.driverzeng.com-JYYYY.MM.DD
- Visualize
- Data
- Options
- Dashboard
- metrics
- value
- Count
- Timelion
- buckets
- DevTools
- Aggregation
- Management
- Geohash
- CELAND
- Field
- ONo Compatible Fields:The"
- not containanyofthefollowingfield types:geo_point
- GERMANY
- FRANCE
- KAZAKHSTAN
- Change precision on map zoom
- PORTUGAL
- TAJIKISTAN
- AMERICA
- CustomLabel
- GUATEMALA
- Advanced
- PANAMA
- COLOMBIA
- PERU
- BOLIVIA
- SOUTH
- AUSTRALIA
<!-- OCR_END -->

如图：报错:"No Compatible Fields: The "\[[www.driverzeng.com](http://www.driverzeng.com/) -]YYYY.MM.DD" index pattern does not contain any of the following field types: geo_point"

原因：索引格式为\[[www.driverzeng.com](http://www.driverzeng.com/) -]YYYY-MM的日志文件由logstash输出到Elasticsearch；在elasticsearch中，所有的数据都有一个类型，什么样的类型，就可以在其上做一些对应类型的特殊操作。`geo`信息中的`location`字段是经纬度，我们需要使用经纬度来定位地理位置;在elasticsearch中，对于经纬度来说，要想使用elasticsearch提供的地理位置查询相关的功能，就需要构造一个结构，并且将其类型属性设置为`geo_point`，此错误明显是由于我们的`geo`的`location`字段类型不是`geo_point`。

我们可以通过以下方式验证一下:

```bash
[root@elkstack01 ~]# curl -XGET http://10.0.0.51:9200/www.driverzeng.com-2019.04.11/_mapping/
{"www.driverzeng.com-2019.04.11":{"mappings":{"www.driverzeng.com":{"properties":{"@timestamp":{"type":"date"},"@version":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"beat":{"properties":{"hostname":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"name":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"version":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}}}},"clientip":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"domain":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"geoip":{"properties":{"city_name":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"continent_code":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"coordinates":{"type":"float"},"country_code2":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"country_code3":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"country_name":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"ip":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"latitude":{"type":"float"},"location":{"type":"float"},"longitude":{"type":"float"},"region_code":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"region_name":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"timezone":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}}}},"host":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"http_host":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"input_type":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"offset":{"type":"long"},"referer":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"responsetime":{"type":"float"},"size":{"type":"long"},"source":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"status":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"type":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"upstreamhost":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"upstreamtime":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"url":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},"xff":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}}}}}}}
```

其中"location":{"type":"float"},"，字段类型是`float`，而不是`geo_point`，因此会报图中的错误。

\*\*解决方法：\**Elasticsearch支持给索引预定义设置和mapping(前提是你用的 elasticsearch 版本支持这个API，不过估计应该都支持)。其实ES中已经有一个默认预定义的模板，我们只要使用预定的模板即可，那为什么还会报错呢？因为默认预定义的模板必须只有匹配 logstash-* 的索引才会应用这个模板，由于我们在logstash中使用的是\[[www.driverzeng.com](http://www.driverzeng.com/) -]YYYY.MM.DD索引方式，因此不会匹配到默认模板，我们只需要改一下索引方式即可:

```bash
input {
  redis {
    host => "10.0.0.54"
    port => "6379"
    db => "3"
    key => "all"
    data_type => "list"
    password => "zls"
 }
}
filter {
        json {
            source => "message"
            remove_field => ["message"]
        }
        geoip {
                source => "clientip"
                target => "geoip"
                database => "/etc/logstash/GeoLite2-City_20240917/GeoLite2-City.mmdb"
                add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
                add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}"  ]
        }
    mutate {
      convert => [ "[geoip][coordinates]", "float"]
        }
}
output {
    elasticsearch {
      hosts => ["10.0.0.51:9200"]
      index => "logstash-%{type}-%{+YYYY.MM.dd}"
    }
}
```

将输出到ES的索引: `index => "%{type}-%{+YYYY.MM.dd}"` 

改为: `index => "logstash-%{type}-%{+YYYY.MM.dd}"`

重启Logstash，登录Kibana刷新即可。

```bash
[root@elkstack03 conf.d]# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/redis_es_ip.conf &

```

这里从新添加日志信息, 在 kibana 添加 \[logstash-nginx_access]YYYY.MM.DD 索引,  #和前面操作一样

再次查看Kibana

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app/k
- er?_g=（filte
- -%5DYYYY.MM.DD,inter
- 应用
- T周报TTS系统
- kibana
- tgeoip.country_code2
- t_id
- @Q*AWoMoyebxCtS9Tdyw_fl
- tgeoip.country_code3
- t_index
- @Q  * logstash-www.driverzeng.com-2019.04.11
- Discover
- t geoip.country.name
- #_score
- geoip.ip
- t_type
- Q*
- www.driverzeng.com
- Visualize
- #geoip.latitude
- tbeat.hostname
- @Q* elkstack03
- geoip.location
- tbeat.name
- #geoip.longitude
- Timelion
- beat.version
- Q*5.3.2
- tgeoip.region_code
- tclientip
- @Q*123.164.0.18
- DevTools
- tgeoip.region_name
- tdomain
- @Qm*www.elk.com
- t geoip.timezone
- Management
- @Q* AS
- thost
- geoip.coordinates
- @Q*126.65, 45.75
- thttp_host
- geoip.country_codez@Q四*CN
- t inputtype
- #offset
- geoip.country_code3
- @Q* CN
- treferer
- geoip.country_name
- @Q*China
- #responsetime
- #size
- Q*45.75
- t source
- tstatus
- @Q*126.65
- geoip.region_code
- @Q*HL
- tupstreamhost
- geoip.region_name
- @Q四* Heilongjiang
- tupstreamtime
- @Q四 * Asia/Shanghai
- turl
- host
- 123.164.0.18
- txff
- www.elk.com
- @Q*log
- ④*8,798
- @Q*/usr/Loca
- .log
- ④Q*304
- upstreamhost
<!-- OCR_END -->

继续画图

<!-- OCR_START -->
- 周报TTS系统
- Visualize / New Visualization (unsaved)
- Save  Share R
- Refresh
- Today
- kibana
- Discover
- ng.com-JYYYY.MM.DD
- Visualize
- Data
- Options
- Dashboard
- metrics
- value
- GREENLAND
- Timelion
- Aggregation
- DevTools
- Count
- Management
- CustomLabel
- 访问次数
- CELAND
- Advanced
- buckets
- GeoCoordinates
- PORTUGAL
- Geohash
- Field
- MEXICOCUBA
- OMAN
- GUATEMALA
- geoip.location
- Atlantic
- VIETNAM
- PANAMA
- Change precisiononmapzoom
- PAPUANEV
- 地区
- BOLIVIA
- AUSTRALIA
<!-- OCR_END -->

也可以根据自己喜好，画成热力图

<!-- OCR_START -->
- A不安全|10.0.0.54:5601/app
- T周报TTS系统
- Visualize/NewVisualization(unsaved)
- SaveShare
- Refresh
- <Today
- kibana
- Discover
- Visualize
- ap.typ
- Heatmap
- Timelion
- ius
- DevTools
- Management
- CELAND
- umzoom
- nopacity
- STATESOF
- Legend Position
- bottomleft
- ShowTooltip
- EXICOCUBA
- GUATEMALA
- PANAMA"
- WMS
- PAPUANEV
- APUANEV
- BOLIVIA
- USTRALIA
- Collapse
<!-- OCR_END -->

保存，可以放入`Dashboard`

<!-- OCR_START -->
- 不安全
- 应用
- 周报TTS系统
- Visualize / 用户IP所在地区-地图(unsaved)
- kibana
- Today
- Save Visualization
- Discover
- 用户IP所在地区-地图
- Visualize
- Dashboard
- DevTools
- Data   Options
- Management
- Maptype
- ScaledCircleMarkers
- egendPosition
- topright
- ShowTooltip
- Desaturatemaptiles
- WMScompliantmapserver
- TATESO
- MEXICOCUBA
- GUATEMALA
- PANAMA
- PAPUANEW
- TOKELAU
- BOLIVIA
- AUSTRALIA
- EW
<!-- OCR_END -->

> 更新: 2024-09-20 20:52:32  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/il3c3z>