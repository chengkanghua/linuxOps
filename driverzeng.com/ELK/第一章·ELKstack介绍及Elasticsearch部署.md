# 第一章·ELKstack介绍及Elasticsearch部署

## ELKstack课程大纲

<!-- OCR_START -->
- 试用模式
- 老男孩教育ELK课程大纲
- 曾老师
- ELK企业案例讲解
- ELK架构讲解
- ELK多种类型架构设计
- 什么是ELK
- 为什么要学ELK
- filebeat安装部署
- filebeat配置文件讲解
- elasticsearch介绍
- ELK介绍
- Filebeat部署及讲解
- Logstash介绍
- filebeat收集日志输出到Logstash中
- ELK各个组件介绍
- Kibana介绍
- filebeat收集日志输出到ES中
- filebeat收集日志输出到Redis中
- filebeat介绍
- redis、kafka在ELK中充当的角色
- 关闭防火墙
- Kibana展示java日志
- 关闭selinux
- Kibana展示nginx日志
- 基础环境准备
- 配置本地hosts
- Kibana日志搜索Lucene语法讲解
- Kibana深入讲解
- 设置源
- Kibana分析日志生成图形
- 安装JDK
- dashboard展示图形
- 在Kibana中会用devtools查询ES索引
- elasticsearch配置讲解
- Elasticsearch部署及讲解
- elasticsearch内存设置讲解
- 部署elasticsearch
- ELK课程大纲
- elasticsearch-head插件安装
- elasticsearch插件KOPF介绍
- Redis部署及讲解
- 通过shell脚本监控
- 监控elasticsearch集群状态
- 给Redis配置密码并启动
- 通过python脚本监控
- Logstash结合Redis使用
- 通过Logstash收集日志输出到Redis中
- 验证Redis中的日志数据(对Redis消息队列的基本操作）
- 通过Logstash读取Redis中的日志并输出到ES
- 部署Logstash
- Logstash部署及讲解
- Logstash常用模块讲解
- Logstash配置文件讲解及启动语法检测
- 日志标准输入、标准输出
- 通过Logstash收集单个日志并输出到文件
- 测试Logstash
- 日志输出到文件
- 日志输出到elasticsearch
- 通过Logstash收集日志文件并输出到elasticsearch
- 通过Logstash收集nginx日志并修改为json格式
- Logstash深入讲解
- 通过Logstash收集java日志并修改为json格式
- 安装并配置Kibana
- 企业中tomcat日志不让修改为json格式的解决方案
- Kibana部署及日志展示
- 通过Kibana查看elasticsearch集群状态
- 使用Logstash的grok模块格式化日志
- 添加elasticsearch索引
- 通过TCP/UDP的方式收集日志
- Kibana功能区域讲解
- 使用nc命令发送日志到Logstash
<!-- OCR_END -->

## ELKstack简介
### 什么是ELK？
通俗来讲，ELK是由Elasticsearch、Logstash、Kibana  三个开源软件的组成的一个组合体，这三个软件当中，每个软件用于完成不同的功能，ELK 又称为ELK  stack，官方域名为 [https://www.elastic.co/cn](https://www.elastic.co/cn)，ELK stack的主要优点有如下几个：

+ 1.处理方式灵活：elasticsearch是实时全文索引，具有强大的搜索功能
+ 2.配置相对简单：elasticsearch全部使用JSON 接口，logstash使用模块配置，kibana的配置文件部分更简单。
+ 3.检索性能高效：基于优秀的设计，虽然每次查询都是实时，但是也可以达到百亿级数据的查询秒级响应。
+ 4.集群线性扩展：elasticsearch和logstash都可以灵活线性扩展
+ 5.前端操作绚丽：kibana的前端设计比较绚丽，而且操作简单

---

### 什么是Elasticsearch？
是一个高度可扩展的开源全文搜索和分析引擎，它可实现数据的实时全文搜索搜索、支持分布式可实现高可用、提供API接口，可以处理大规模日志数据，比如Nginx、Tomcat、系统日志等功能。

<!-- OCR_START -->
- Elasticsearch
- curl-XPUThttp://localhost:9200/twitter/tweet/1-d'{
- -XPUThttp:/
- "user":"kimchy"
- post_date":"2009-11-15T13:12:00"，
- ser"r.
- "kimchy"
- essage":“Trying out elasticsearch,so far so good?
- ostdate"
- 2.00
<!-- OCR_END -->

---

### 什么是Logstash？
可以通过插件实现日志收集和转发，支持日志过滤，支持普通log、自定义json格式的日志解析。

<!-- OCR_START -->
- INPUTS
- FILTERS
- Grok
- →ElasticSearch
- GeoIP
- Graphite
- ApacheTogs
- Date
- →PagerDuty
- Anonymize
- Mail logs
<!-- OCR_END -->

### 什么是Kibana？
主要是通过接口调用elasticsearch的数据，并进行前端数据可视化的展现。

<!-- OCR_START -->
kibana
2.316hits
New Save Open Share CAuto-refresh
TimeRange
Today
Yesterday
Last15minutes
Last30days
Disc
Quick
Thisweek
Daybefore yesterday
Last30minutes
Last60days
Visualize
Relative
Thismonth
Thisdaylastweek
Last1hour
Last90days
1.时间区
Thisyear
Previousweek
Last4hours
Last6months
Dashboard
Thedaysofar
Previousmonth
Last12hours
Last1year
Absolute
Weektodate
Previousyear
Last24hours
Last2years
Timelion
Monthto date
Last7days
Last5years
Yeartodate
DevTools
nent
4.搜索区
[au-admin.vantagefx.com-jYYYY.M..
2.功能区
m.au-YYYY.MM.DD
agefx.co
.cn-JYYYY.MM.DD
u-openapi.vantagefx.com-JYY.MM.DD
re.vantagef.cm-.MM.DD
vantagefx.com.au-Yr.MM.DD
mg.infinox.cn-JTYYY.MM.DD
nt.infinox.bs.access-YYY.MM....
5.展示区
@timestamp per30 minutes
[bhm-sttic.infinox.bs-Y.MM.D
Time
cn-JYYY.MM.DD
January 5th 2018,19:52:25.000
referer:https://admin.vantagefx.com/admin/mainoffset:1,222,248input_type:1ogsessiem_id:session_id-somrce：/au_project/logs/nginx_1og/admin.vantagefx.
[icn-betaopenapi.infinox.cn-JYr.MM.DD
com.access-s1_json.log tye:au-admin.vantagefx.comhttphost:admin.vantagefx.comwrl:/account/query_accountListhtp_user_agent:Mozilla/5.0（windows NT
国恋列表区.MM.D
10.0:win64;x64）App7ewebKit/537.36（KHTML,1ike Gecko)Chrome/51.0.2704.79 Safari/537.36Edge/14.14393pstremhost:10.0.6.115:8032timestamp:January 5th
2018,19:52:25.000size:1,080elientip:198.143.53.20doain:admin.vantagefx.combeat.hestae:AU_release_nginx01beat.nme:AU_release_nginx01
beat.versim:5.3.2rerion:1host:10.0.6.6resensetine:2.201xff:210.10.193.166stremtine:2.200staus:200ia:AWDGKjk67YLYNhKXD7Cvtype:au-ad
K.cn-JYY.MM.DD
y5th2018,19:52:25.000
referer:https://admin.vantagefx.com/admin/mainoffet:1,222,794input_type:1ogsessinid:session_id-sorce:/au_project/logs/nginx_log/admin.vantagefx.
com.access-ss1_json.logtype:au-admin.vantagefx.comhttp_host:admin.vantagefx.comml:/tree/query_user_1evel_tree http_mser_agent:Mozila/5.0(windows NT
napiinfino
.cn-YY.MM.DD
10.0;win64；x64）ApplewebKit/37.36（KHML,1ike Gecko)Chrome/51.0.2704.79 Safari/537.36Edge/14.14393pstrehost:10.0.6.163:8032etimestmp:January 5th
.cn-JY.MM.DD
2018,19:52:25.000size:124,531clientip:198.143.53.20 dmain:admin.vantagefx.com beat.hostnme:AU_relea5e_nginx01beat.nme:AU_release_nginx01
enapi.infinox.
[icn-payvicorfinec.cm-.MMDD
https://www.driverzehg.com
6.076ff:210.10.193.166
mstremtine:
5.462
status
200
ia:AWDGKik67YLYNhKXD7Cw
type:
<!-- OCR_END -->

## ELKstack部署及配置
### 环境准备
| 公网IP | 内网IP | 主机名 | 部署服务 | 用途 |
| --- | --- | --- | --- | --- |
| 10.0.0.51 | 172.16.1.51 | elkstack01 | elasticsearch、JDK | 存储日志的数据库 |
| 10.0.0.52 | 172.16.1.52 | elkstack02 | elasticsearch、JDK | 存储日志的数据库 |
| 10.0.0.53 | 172.16.1.53 | elkstack03 | Logstash、JDK | 收集日志、过滤日志 |
| 10.0.0.54 | 172.16.1.54 | elkstack04 | Redis、Kibana | 消息队列、日志展示 |
| 10.0.0.55 | 172.16.1.55 | nginx01 | nginx、filebeat | 修改nginx日志格式为json收集 |
| 10.0.0.56 | 172.16.1.56 | tomcat01 | tomcat、JDK、filebeat | 修改tomcat日志格式为json收集 |

```bash
[root@m01 ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet
BOOTPROTO=none
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=10.0.0.51
PREFIX=24
GATEWAY=10.0.0.254
DNS1=223.5.5.5
[root@m01 ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth1
TYPE=Ethernet
BOOTPROTO=none
NAME=eth1
DEVICE=eth1
ONBOOT=yes
IPADDR=172.16.1.51
PREFIX=24

# hostnamectl set-hostname elkstack01 && bash

```

---

### 安装包准备
| 安装包名 | 用途 |
| --- | --- |
| elasticsearch-5.3.0.rpm | 存储日志的数据库 |
| elasticsearch-head.tar.gz | elasticsearch的web界面插件 |
| logstash-5.3.0.rpm | 日志收集、日志分析工具 |
| kibana-5.3.0-x86_64.rpm | 日志展示、日志查询工具 |
| filebeat-5.3.2-x86_64.rpm | 日志收集工具（比Logstash轻量） |
| jdk-8u121-linux-x64.tar.gz | JAVA容器（es、Logstash、tomcat需要） |
| nginx-1.10.3.tar.gz | 测试收集nginx日志 |
| apache-tomcat-8.0.38.tar.gz | 测试收集tomcat日志 |
| redis-3.2.8.tar.gz | 消息队列工具 |

```bash
# https://www.elastic.co/guide/en/elasticsearch/reference/5.3/rpm.html#install-rpm
# https://www.elastic.co/cn/downloads/past-releases#elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.0.rpm

wget https://artifacts.elastic.co/downloads/logstash/logstash-5.3.0.rpm
wget https://artifacts.elastic.co/downloads/kibana/kibana-5.3.0-x86_64.rpm
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.3.2-x86_64.rpm

#https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html
#https://repo.huaweicloud.com/java/jdk/8u202-b08/
#https://mirrors.huaweicloud.com/java/jdk/
wget https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz

# https://nginx.org/en/download.html
wget https://nginx.org/download/nginx-1.10.3.tar.gz

# https://archive.apache.org/dist/tomcat/tomcat-8/
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.38/bin/apache-tomcat-8.0.38.tar.gz

#http://download.redis.io/releases/
wget http://download.redis.io/releases/redis-3.2.8.tar.gz

# https://github.com/mobz/elasticsearch-head
https://github.com/mobz/elasticsearch-head/archive/refs/tags/v5.0.0.tar.gz
https://github.com/mobz/elasticsearch-head/archive/refs/tags/v5.0.0.tar.gz

```

### Elasticsearch环境准备
**关闭防火墙**

```bash
#CentOS6 关闭防火墙
[root@elkstack01 ~]# /etc/init.d/iptables stop
#CentOS7 关闭防火墙
[root@elkstack01 ~]# systemctl stop firewalld
```

**关闭SELINUX**

```bash
#临时关闭
[root@elkstack01 ~]# setenforce 0
setenforce: SELinux is disabled
#永久关闭
[root@elkstack01 ~]# vim /etc/sysconfig/selinux
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled    ==>      //原来是enforcing 改成disabled
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

**设置epel源**

```bash
#CentOS6 下载epel源
[root@elkstack01 ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
#CentOS7 下载epel源
[root@elkstack01 ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

**修改时区**

```bash
#将时区修改为上海时区
[root@elkstack01 ~]# cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
cp：是否覆盖"/etc/localtime"？ y
```

**设置时间同步**

```bash
#同步服务器时间（切记保证集群之间时间一致非常重要）
yum install -y ntpdate
[root@elkstack01 ~]# ntpdate time1.aliyun.com
28 Feb 14:11:28 ntpdate[8904]: step time server 203.107.6.88 offset 3168820.831817 sec

# echo '*/1 * * * * /usr/sbin/ntpdate time1.aliyun.com > /dev/null 2>&1' > /var/spool/cron/root
```

---

### 部署Elasticsearch

在elkstack01 和 elkstack02两台机器分别安装elasticsearch，因为elasticsearch服务运行需要JAVA环境，所以两台服务器都需要安装JAVA环境。

**安装JDK环境**

**<u>下载地址:</u>** [http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

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

--------------------------------------------------------------------------
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

**安装elasticsearch**

**<u>下载地址:</u>** [https://www.elastic.co/downloads/elasticsearch](https://www.elastic.co/downloads/elasticsearch)

```bash
#安装elasticsearch使用yum localinstall 自动安装依赖包
yum localinstall -y elasticsearch-5.3.0.rpm

```

**修改配置文件**

_<u>如果系统是CentOS6则做以下修改</u>_

```bash
#查看配置文件修改部分内容
[root@elkstack01 ~]# grep "^[a-Z]" /etc/elasticsearch/elasticsearch.yml
#设置集群名称（想要其他节点加入同一个集群必须集群名称相同）
cluster.name: elk-cluster
#节点名称（通过此配置项来区分集群中的所有节点）
node.name: elk01
#elasticsearch数据存放目录
path.data: /data/elk/data
#elasticsearch日志存放目录
path.logs: /data/elk/logs
#CentOS6不支持内存锁功能，所以要关闭内存锁
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
#elasticsearch监听地址
network.host: 0.0.0.0
#elasticsearch服务端口
http.port: 9200
#配置所有集群节点IP
discovery.zen.ping.unicast.hosts: ["10.0.0.51", "10.0.0.52"]
```

_<u>如果系统是CentOS7则做以下修改</u>_

```bash
#查看配置文件修改部分内容(CentOS7中配置)
[root@elkstack01 ~]# grep "^[a-Z]" /etc/elasticsearch/elasticsearch.yml
#设置集群名称（想要其他节点加入同一个集群必须集群名称相同）
cluster.name: elk-cluster
#节点名称（通过此配置项来区分集群中的所有节点）
node.name: elk01
#elasticsearch数据存放目录
path.data: /data/elk/data
#elasticsearch日志存放目录
path.logs: /data/elk/logs
#内存锁设置（在CentOS7中支持内存锁并且要修改启动脚本）
bootstrap.memory_lock: true
#elasticsearch监听地址
network.host: 0.0.0.0
#elasticsearch服务端口
http.port: 9200
#配置所有集群节点IP
discovery.zen.ping.unicast.hosts: ["10.0.0.51", "10.0.0.52"]
#修改启动脚本
[root@elkstack01 ~]# vim /usr/lib/systemd/system/elasticsearch.service
#修改内存限制（去掉此行注释）
LimitMEMLOCK=infinity
#重新加载启动脚本
[root@elkstack01 ~]# systemctl daemon-reload

-----------------------------------------------------------------
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.bak

#第二节节点注意修改名称为elk02
cat > /etc/elasticsearch/elasticsearch.yml <<EOF
cluster.name: elk-cluster
node.name: elk01
path.data: /data/elk/data
path.logs: /data/elk/logs
bootstrap.memory_lock: true
network.host: 0.0.0.0
http.port: 9200
discovery.zen.ping.unicast.hosts: ["10.0.0.51", "10.0.0.52"]
EOF

sed -i 's/^#LimitMEMLOCK/LimitMEMLOCK/g' /usr/lib/systemd/system/elasticsearch.service
systemctl daemon-reload

```

**创建目录并授权**

```bash
#创建数据目录
mkdir -p /data/elk/data
#创建日志目录
mkdir -p /data/elk/logs
#授权
chown -R elasticsearch.elasticsearch /data/elk/

```

**优化文件描述符**

```bash
#编辑limit文件
[root@elkstack01 ~]# vim /etc/security/limits.conf
* soft memlock unlimited
* hard memlock unlimited
* soft nofile 131072
* hard nofile 131072
#编辑子配置文件（CentOS6）
[root@elkstack01 ~]# vim /etc/security/limits.d/90-nproc.conf
*          soft    nproc     2048
root       soft    nproc     unlimited

------------------------------------------------

cat >> /etc/security/limits.conf <<EOF
* soft memlock unlimited
* hard memlock unlimited
* soft nofile 131072
* hard nofile 131072
EOF

cat > /etc/security/limits.d/90-nproc.conf <<EOF
*          soft    nproc     2048
root       soft    nproc     unlimited
EOF
```

**设置JVM最大最小内存限制**

```bash
#编辑配置文件
[root@elkstack01 ~]# vim /etc/elasticsearch/jvm.options
-Xms1g
-Xmx1g

------------------------------------------------------
sed -i 's/-Xms2g/-Xms512M/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx2g/-Xmx512M/g' /etc/elasticsearch/jvm.options

```

**启停elasticsearch**

```bash
#CentOS6 启动、停止elasticsearch
[root@elkstack01 ~]# /etc/init.d/elasticsearch start
[root@elkstack01 ~]# /etc/init.d/elasticsearch stop
#CentOS7 启动、停止elasticsearch
[root@elkstack01 ~]# systemctl start elasticsearch
[root@elkstack01 ~]# systemctl stop elasticsearch
#查看启动进程
[root@elkstack01 ~]# ps -ef|grep java
#查看端口
[root@elkstack01 ~]# netstat -lntup
tcp        0      0 :::9200                     :::*                        LISTEN      10872/java
tcp        0      0 :::9300                     :::*                        LISTEN      10872/java
```

es启动不了，报错

```bash
[root@e1 ~]# journalctl -u elasticsearch
May 11 11:38:31 e1 elasticsearch[1200]: which: no java in (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin)

原因找不到 java
ln -s /usr/local/jdk1.8/bin/* /usr/local/bin/

```

**验证启动elasticsearch后的页面**

打开浏览器访问地址：[http://10.0.0.51:9200/](http://10.0.0.51:9200/)

<!-- OCR_START -->
不安全10.0.0.51:9200
应用
点击这里导入书签。开始
"name":"elk01"
"cluster_name":"elk-cluster
"cluster_uuid":"xFsbUh_AT2y5jyZLGOAz3w",
"version"
'number"
"5.3.0"
"build_hash":"3adb13b"，
"bui1ddate":"2017-03-23T03:31:50.652z"
"build_snapshot":false,
"lucene_version":"6.4.1"
），
"tagline":"You Know，for Search"
ps://www.driverzeng.c
<!-- OCR_END -->

```bash
{
  #此节点名称
  "name" : "elk01", 
  #此集群名称
  "cluster_name" : "elk-cluster",
  #集群的uuid
  "cluster_uuid" : "XFsbUh_AT2y5jyZLGOAZ3w",
  "version" : {
  #elasticsearch版本
    "number" : "5.3.0", 
    "build_hash" : "3adb13b",
    "build_date" : "2017-03-23T03:31:50.652Z",
  #创建快照
    "build_snapshot" : false,
  #Lucene语法版本（基于Lucene做日志搜索）
    "lucene_version" : "6.4.1"
  },
  #口号
  "tagline" : "You Know, for Search"
}
```

**其他节点安装并加入集群**

安装其他节点，步骤和上面一样，修改配置文件时，直接将elk01节点的配置文件scp（拷贝）过去，然后在配置文件中 将 节点名称修改后启动即可。

```bash
#发送配置文件到其他节点
[root@elkstack01 ~]# scp /etc/elasticsearch/elasticsearch.yml  172.16.1.52:/etc/elasticsearch/
#修改其他节点配置文件
[root@elkstack02 ~]# vim /etc/elasticsearch/elasticsearch.yml
#此行节点名称唯一即可
node.name: elk02
```

操作完成后，同样启动elasticsearch并且访问9200端口，检查是否安装成功。

访问地址：[http://10.0.0.52:9200/](http://10.0.0.52:9200/)

<!-- OCR_START -->
- 不安全10.0.0.52:9200
- 用应用
- 点击这里导入书签。开始
- "name":"elk02"
- "cluster_name"
- "elk-cluster"
- "cluster_uuid":"xFsbUh_AT2y5jyZLGOAz3w",
- "version"
- ：{
- "number"
- "5.3.0"
- "build_hash":"3adb13b",
- "bui1d_date":"2017-03-23T03:31:50.652z",
- "build_snapshot":false,
- "lucene_version":"6.4.1"
- 'tagline":"You Know，for Search
- ttps://www.driverzeng.co
<!-- OCR_END -->

如上图所示：可以看到节点名称是不一样的。

---

### 安装elasticsearch插件
插件是为了完成不同的功能，官方提供了一些插件但大部分是收费的，另外也有一些开发爱好者提供的插件，可以实现对elasticsearch集群的状态监控与管理配置等功能，我们现在要安装的是Elasticsearch的head插件，此插件提供elasticsearch的web界面功能。

安装Elasticsearch的head插件时，要安装npm，npm的全称是Node Package Manager，是随同NodeJS一起安装的包管理和分发工具，它很方便让JavaScript开发者下载、安装、上传以及管理已经安装的包。

在Elasticsearch 5.x版本以后不再支持直接安装head插件，而是需要通过启动一个服务方式。

Github地址：[https://github.com/mobz/elasticsearch-head](https://github.com/mobz/elasticsearch-head)

```bash
注意： 每个节点都需要安装
#安装npm（只需要在一个节点安装即可，如果前端还有nginx做反向代理可以每个节点都装）
yum install -y nodejs npm git bzip2
#更新npm到最新版本
# npm install -g npm 
npm config set registry https://registry.npmmirror.com

#进入下载head插件代码目录
cd /usr/local/
#从GitHub上克隆代码到本地
git clone https://github.com/mobz/elasticsearch-head.git
#克隆完成后，进入elasticsearch插件目录
cd elasticsearch-head/
#清除缓存
npm cache clean -f
#使用npm安装n模块（不同的项目js脚本所需的node版本可能不同，所以就需要node版本管理工具）
npm install -g n
#安装最新版本n模块
n stable
#生成grunt
npm install grunt -save
#确认生成grunt文件
ll node_modules/grunt
#执行安装grunt
 npm install
#后台启动head插件（切记，必须在插件目录下执行启动命令）
npm run start &
#验证端口是否启动成功
# netstat -lntup
tcp        0      0 0.0.0.0:9100                0.0.0.0:*                   LISTEN      11293/grunt
#启动成功后，修改elasticsearch配置文件
[root@elkstack01 elasticsearch-head]# vim /etc/elasticsearch/elasticsearch.yml
#添加如下两行，开启跨域访问支持（添加在配置文件最后即可）
http.cors.enabled: true
http.cors.allow-origin: "*"
-----------------------------------------
echo 'http.cors.enabled: true' >>/etc/elasticsearch/elasticsearch.yml
echo 'http.cors.allow-origin: "*"' >>/etc/elasticsearch/elasticsearch.yml
#重启elasticsearch
systemctl restart elasticsearch

```

如果启动成功了，则打开浏览器，访问：[http://10.0.0.51:9100/](http://10.0.0.51:9100/)

<!-- OCR_START -->
- ←→
- A不安全10.0.0.51:9100
- 应用点击这里导入书签。开始将原来的http://localhost:9200修改为es所在地址即可
- Elasticsearch
- http://10.0.0.51:9200/
- 连接
- elk-cluster
- 集群健康值：green（Oofo）
- 概览索引
- 数据浏览
- 基本查询[+]
- 复合查询[+]
- 集群概览
- 集群排序
- SortIndices
- ViewAliases
- Index Filter
- elk01
- 信息
- 动作
- elk02
<!-- OCR_END -->

安装成功界面如下：

<!-- OCR_START -->
[root@elkstack01elasticsearch-head]#npminstall-gn
npm http GET https://registry.npmjs.org/n
npm http GET https://registry.npmjs.org/n/-/n-2.1.12.tgz
/usr/bin/n->/usr/lib/node_modules/n/bin/n
WARN
npm
unmet dependency/usr/lib/node_modules/block-stream requiresinherits@'~2.0.0'but willloa
WARNunmetdependencyundefined,
unmetdependencywhichisversionundefined
unmet dependency/usr/lib/node_modules/fstream requires inherits@'~2.0.0'butwill load
unmetdependencyundefined,
unmetdependency/usr/lib/node_modules/fstream-ignorerequiresinherits@'2'butwillload
unmetdependency/usr/lib/node_modules/fstream-npmrequiresinherits@'2'butwillload
unmetdependency/usr/lib/node_modules/globrequiresinherits@'2'butwillload
WARNunmet dependencywhichisversionundefined
unmetdependency/usr/lib/node_modules/tarrequiresinherits@'2'butwillload
n@2.1.12/usr/lib/node_modules/nhttps://www.driverzeng.com
<!-- OCR_END -->

安装n模块遇到报错SSL认证问题，解决方案如下。

<!-- OCR_START -->
```text
root@elkstackolelasticsearch-head#npm
install-gn
npmhttpGEThttps://registry.npmjs.org/n
npm
n httpGEThttps://registry.npmjs.org/n
ERR
Error:CERT_UNTRUSTED
atSecurePair.<anonymous>(tls.js:1430:32)
atSecurePair.emit(events.js:92:17)
atSecurePair.maybeInitFinished(tls.js:1029:10)
atCleartextStream.read[as_read](tls.js:521:13)
atCleartextStream.Readable.read(_stream_readable.js:341:10） atEncryptedStream.write[as_write](tls.js:418:25) atdoWrite(_stream_writable.js:226:10) at write0rBuffer(_stream_writable.js:216:5)
atEncryptedStream.Writable.write(_stream_writable.js:183:11)
atwrite（_stream_readable.js:602:24)
If
youneedhelp，youmayreportthislogat:
<http://github.com/isaacs/npm/issues>
ore
emailitto:
<npm-@googlegroups.com>
ERR!SystemLinux 2.6.32-431.el6.x86_64
ERR!command
"node""/usr/bin/npm""install""
"n'
!cwd/usr/local/elasticsearch-head
node-vv0.10.48
npm-v1.3.6
Additionalloggingdetailscanbefoundin:
/usr/local/elasticsearch-head/npm-debug.log
```
<!-- OCR_END -->

```bash
#取消npm的ssl验证
npm config set strict-ssl false
```

> 更新: 2024-09-19 01:04:14  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/vhpvxg>