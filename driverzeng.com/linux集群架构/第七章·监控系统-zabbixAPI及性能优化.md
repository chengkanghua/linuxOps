# 第七章·监控系统-zabbix API及性能优化

* [](https://www.driverzeng.com/#toc_0)[zabbix API 概述](https://www.driverzeng.com/#toc_0)
* [zabbix性能调优](https://www.driverzeng.com/#toc_1)

> -曾老湿, 江湖人称曾老大。
>
> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023

***

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1\)整合了各个公有云API，自主创建云主机。
>
> 2\)ELK自动化收集日志功能。
>
> 3\)Saltstack自动化运维统一配置管理工具。
>
> 4\)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5\)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6\)SQL执行及审批流程。
>
> 7\)慢查询日志分析web界面。

***

## zabbix API 概述

Zabbix API允许你以编程方式检索和修改Zabbix的配置，并提供对历史数据的访问。

> **它广泛用于：**
>
> 1.创建新的应用程序以使用Zabbix；
>
> 2.将Zabbix与第三方软件集成；
>
> 3.自动执行常规任务。

Zabbix API是基于Web的API，作为Web前端的一部分提供。它使用JSON-RPC 2.0协议，这意味着两件事：

1.该API包含一组独立的方法；

2.客户端和API之间的请求和响应使用JSON格式进行编码。

***

| 结构 |
| --- |

Zabbix API包含许多方法，这些方法都名义上分组为单组的API。每个方法执行一个特定任务。例如，方法 host.create 隶属于 host 这个API ，用于创建新主机。历史上，API有时被称为“类”。

```plain
大多数API至少包含四种方法： get， create， update 和 delete ，分别是检索，创建，更新和删除数据，但是某些API提供一套完全不同的一组方法。
```

***

| 执行请求 |
| --- |

设置前端后，你就可以使用远程HTTP请求来调用API。为此，需要向 api_jsonrpc.php 位于前端目录中的文件发送HTTP POST请求。例如，如果你的Zabbix前端安装在 [http://company.com/zabbix，](http://company.com/zabbix%EF%BC%8C) 那么用HTTP请求来调用 apiinfo.version 方法就如下面这样：

```plain
POST http://company.com/zabbix/api_jsonrpc.php HTTP/1.1
Content-Type: application/json-rpc
 
{"jsonrpc":"2.0","method":"apiinfo.version","id":1,"auth":null,"params":{}}
```

请求的 `Content-Type` 头部必须设置为以下值之一： `application/json-rpc`, `application/json` 或 `application/jsonrequest`。

\*\*应用场景：\*\*二次开发`jumpserver`结合`zabbix`自动推送主机。[TP](https://www.cnblogs.com/goodcook/p/7390463.html)

***

| 调用API |
| --- |

在访问Zabbix中的任何数据之前，你需要登录并获取身份验证令牌。这可以使用该 user.login 方法完成。让我们假设你想要以标准Zabbix Admin用户身份登录。然后，你的JSON请求将如下所示：

```plain
[root@web02 ~]# curl -s -X POST -H 'Content-Type:application/json' -d '
{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "Admin",
        "password": "zabbix"
    },
    "id": 1,
    "auth": null
}' http://10.0.0.8/zabbix/api_jsonrpc.php
{"jsonrpc":"2.0","result":"4e8d7412babe19c856a2dfe57c6c64ab","id":1}
```

让我们仔细看看请求对象。它具有以下属性：

`jsonrpc` - API使用的JSON-RPC协议的版本; Zabbix API实现JSON-RPC版本2.0;

`method` - 调用的API方法;

`params` - 将被传递给API方法的参数;

`id` - 请求的任意标识符;

`auth` -用户认证令牌; 因为我们还没有一个，它的设置null。

***

| 添加主机 |
| --- |

```plain
[root@web02 ~]# curl -s -X POST -H 'Content-Type:application/json-rpc ' -d '
{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": "zls_web01",
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "192.168.3.1",
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "2"
            }
        ],
        "templates": [
            {
                "templateid": "10255"
            }
        ],
        "inventory_mode": 0,
        "inventory": {
            "macaddress_a": "01234",
            "macaddress_b": "56768"
        }
    },
    "auth": "4e8d7412babe19c856a2dfe57c6c64ab",
    "id": 1
}' http://10.0.0.8/zabbix/api_jsonrpc.php
```

<!-- OCR_START -->
- Z曾老湿：配置主机
- ①不安全| 10.0.0.8/zabbix/host
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share？
- 主机群组
- 模板
- 主机维护
- 动作关联项事件
- 自动发现
- 服务
- 曾老湿
- 主机
- 群组所有
- 创建主机导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 应用重设
- 应用集
- 监控项
- 触发器
- 图形
- Web监测
- 接口
- 状态
- 可用性
- agent加密
- 信息
- hl_proxy: pro_web01
- 172.16.1.7: 10050
- 已启用
- ZBXSNMP|JMXIPMI
- webo1
- 应用集11
- 监控项50
- 触发器22
- 图形9
- 自动发现2
- Web监测1
- 10.0.0.7:10050
- TCP状态监控模板，TemplateOS Linux（TemplateAppZabbixAgent)
- Zabbixserver
- 监控项69
- 触发器46
- 图形11
- 127.0.0.1: 10050
- TemplateAppabbixSeerlateSLinuxTemlateAppabbixAgent
- 停用的
- zls_webo1
- 应用集1
- 监控项2
- 192.168.3.1: 10050
- TCP状态监控模板
- 显示已自动发现的4中的4
- DriverZeng
<!-- OCR_END -->

￼

## zabbix性能调优

1. Zabbix属于写多读少的业务, 所以需要针对zabbix的MySQL进行拆分。MySQL一定要使用SSD固态盘

2. 将Zabbix-Agent被动监控模式, 调整为主动监控模式。

3. 使用zabbix-proxy分布式监控, 在大规模监控时用于缓解Zabbix-Server压力

4. 去掉无用监控项, 增加监控项的取值间隔, 减少历史数据保存周期(由housekeeper进程定时清理)

5\)针对于Zabbix-server进程调优, 谁忙就加大谁的进程数量, 具体取决实际情况, 不是越大越好

<!-- OCR_START -->
曾老湿：自定义图表[每30秒刷新
→C①不安全|10.0.0.8/zabbix/charts.php?fullscreen=0&groupid=4&hostid=0&graphid=518
应用  zabbix-api
ZABBIX
监测中  资产记录  报表  配置  管理
仪表板 问题 概览
Web监测最新数据触发器图形 Graphtree 聚合图形拓扑图 自动发现 服务
曾老湿
图形
群组Zabbixservers主机所有
Zabbix data gathering process busy%
过滤器
缩放:5m 15m 30m 1h 2h 3h 6h 12h 1d 3d 7d 14d 1m 3m 6m 1y 所有.
2019-11-11 13:00:13-2019-11-114:00:13现在）
《 1y 6m 1m 7d 1d 12h 1h 5m 1 5m 1h 12h 1d 7d 1m 6m 1y >》
1h固定的
Zabbix server: Zabbix data gathering process busy % (1h)
100 %
80 %
60 s
40%
20%
最新
最小
平均最大
Zabbix busy trapper processes，in%
没有数据
xbusy
Zabix
x busy pnreachable pollerprocesses,
[ 7引]
mi pollerprocessesmore than75%busy
[> 75]
DriverZeng
<!-- OCR_END -->

￼

```plain
[root@web02 ~]# vim /etc/zabbix/zabbix_server.conf
StartPollers=20
StartPollersUnreachable=20
...
```

6\)针对于Zabbix-server缓存调优, 谁的剩余内存少, 就加大它的缓存值(zabbix cache usage图表)

<!-- OCR_START -->
- 应用 zabbix-api
- ZABBIX
- 监测中
- 资产记录报表配置管理
- ZShare
- 仪表板问题概览
- Web监测 最新数据 触发器图形 Graphtree 聚合图形 拓扑图 自动发现 服务
- 曾老湿
- 图形
- 群组Zabbix servers主机所有
- Zabbix cache usage, % free
- 图开
- 过滤器
- 缩放：5m 15m30m 1h 2h 3h6h12h 1d 3d 7d 14d 1m3m6m1y.所有
- 2019-11-1113:06:01- 2019-11-11 14:06:01(现在)
- 《《1y6m1m7d1d12h1h5m15m1h12h1d7d1m6m1y>》
- 1h 固定的
- Zabbix server: Zabbix cache usage, % free (1h)
- 100 %
- 80 %
- 60 %
- 40%
- 20
- 09
- 11-11
- 最新
- Zabbix trend write cache, % free
- 没有数据
- oryindexca
- %free
- Zabbix value cache,% free
- trends cache
- K 2引]
- in the
- configuration
- cache
- DriverZeng
- 25%free in thehistory index cache
- [<25]
<!-- OCR_END -->

￼

```plain
[root@web02 ~]# vim /etc/zabbix/zabbix_server.conf
CacheSize=8M
HistoryCacheSize=16M
HistoryIndexCacheSize=4M
```

7. 关注管理->队列, 是否有被延迟执行的监控项

<!-- OCR_START -->
- C不安全|10.0.0.8/zabbix/queue.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 一般agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 项目队列已被更新
- 概览
- 监控项
- 10秒
- 305
- 1分
- 5分
- 10分钟以上
- Zabbix客户端
- Zabbix客户（主动式）
- 简单检查
- SNMPV1客户端
- SNMPV2客户端
- SNMPV3客户端
- Zabbix内部
- Zabbix整合
- 外部检查
- 数据库监控
- IPMI客户端
- SSH客户端
- TELNET客户端
- JMXagent代理程序
- 回曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 5秒
- 10秒
- 30秒
- 1分
- 5分
- 10分钟以上
- 3
- 18
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

***

> 更新: 2019-11-23 09:18:43  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/yiehei>