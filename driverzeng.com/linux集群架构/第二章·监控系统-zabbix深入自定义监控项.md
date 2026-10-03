# 第二章·监控系统-zabbix深入自定义监控项

+ [自定义监控项-ssh端口](https://www.driverzeng.com/#toc_0)
+ [自定义监控项-TCP11种状态](https://www.driverzeng.com/#toc_1)
+ [zabbix多条件触发器](https://www.driverzeng.com/#toc_2)
+ [zabbix自定义告警方式](https://www.driverzeng.com/#toc_3)
+ [zabbix自愈模式配置](https://www.driverzeng.com/#toc_4)
+ [zabbix报警升级机制](https://www.driverzeng.com/#toc_5)
+ [zabbix自定义图形](https://www.driverzeng.com/#toc_6)
+ [自定义图形🌲[扩展]](https://www.driverzeng.com/#toc_7)
+ [Zabbix⾃定义监控模板](https://www.driverzeng.com/#toc_8)
+ [zabbix企业微信报警（扩展）](https://www.driverzeng.com/#toc_9)

> -曾老湿, 江湖人称曾老大。
>
> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023
>

---

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

## 自定义监控项-ssh端口
---

| 监控主机的22端口 |
| --- |

<!-- OCR_START -->
- 曾老湿：配置主机
- 不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 8
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表
- 配置
- 管理
- Share
- ？二心
- 主机群组模板
- 主机
- 维护动作关联项事件
- 自动发现服务
- 曾老湿
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent 加密
- 信息
- webo1
- 应用集11
- 监控项45
- 触发器20
- 图形9
- 自动发现2
- 10.0.0.7:10050
- Template OS Linux(Template AppZabbixAgent)
- 已启用
- ZBXSNMPJMXIPMI
- Zabbixserver
- 监控项68
- 触发器46
- 图形11
- 127.0.0.1:10050
- TemplateAppZabbixServerTemplateOSinuxTemplateAppZabbixAgent
- 停用的
- 显示已自动发现的2中的2
- 0选择
- 启用
- 禁用
- 导出
- 批量更新
- 曾老湿n
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置监控项
- →C不安全|10.0.0.8/zabbix/items.php?fiter_set=18hostid=10254
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 主机群组模板
- 主机维护动作关联项事件自动发现服务
- 曾老湿
- 监控项
- 创建监控项
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集11监控项45触发器20图形9自动发现规则2Web场景
- 过滤器
- 主机群组
- 在此输入搜索
- 选择
- 类型
- 所有
- 信息类型所有
- 状态所有
- 主机
- web01x
- 更新间隔
- 历史记录
- 应用集
- 趋势
- 触发器所有
- 名称
- 模板所有
- 键值
- 应用
- 重设
- 过滤器只影响过滤后的数据
- CPU13Filesystems10General5Memory5Networkinterfaces2OS8Performance13Processes2Security2SystemDIY1Zabbixagent3
- 信息类型
- 字符4数字（无正负）25浮点数16
- 模板
- 模板的监控项32非模板监控项13
- 有触发器
- 无触发器25有触发器20
- 7d443m1
- 间隔
- 3s11m3110m21h11
- Wizard
- 触发器
- 状态
- 信息
- TemplateAppZabbixAgent:Agentping
- 触发器1
- agent.ping
- 1m
- 1w
- 365d
- Zabbix客户端
- Zabbix agent
- 已启用
- TemplateOsLinux:Availablememory
- vm.memory.size[available]
- Memory
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置监控项
- A不安全|10.0.0.8/zabbix/items.php?hostid=10254&form=创建监控项
- 应用
- zabbix-api
- 监控项
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI
- 应用集11监控项45触发器20图形9自动发现规则2Web场景
- 监控项进程
- 名称
- ListenSSHPort
- 类型Zabbix客户端
- 键值
- net.tcp.listen[22]
- 选择
- 主机接口
- 10.0.0.7:10050
- 信息类型
- 数字（无正负）
- 单位
- 更新间隔
- 自定义时间间隔
- 类型
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长
- 趋势存储时间
- 查看值
- 不变
- 展示值映射
- 新的应用集
- 应用集
- Filesystems
- General
- Memory
- Performance
- Processes
- Securitv
- 填入主机资产纪录栏位无
- Dr曾e老湿ng
- 描述
<!-- OCR_END -->

￼

每个Zabbix事件需要大约170字节的磁盘空间。很难估计Zabbix每天生成的事件数量。最糟糕的情况下，我们可能需要假设Zabbix每秒会生成一个事件。

这意味着，如果我们需要保留3年的事件，需要**3**_365_24_3600_ **170** = **15GB**的磁盘空间。

下表列出了用于计算Zabbix系统所需磁盘空间的计算公式：

| zabbix公式计算范围 | 所需磁盘空间的计算公式 (单位：字节) |
| :--- | :--- |
| _Zabbix配置文件_ | 固定大小。一般10MB或更少。 |
| _历史（History）_ | days*(items/refresh rate)*24*3600*bytes  items : 监控项数量 days : 保留历史数据的天数 refresh rate : 监控项平均轮询时间 bytes :  保留单个值所需要占用的字节数，依赖于数据库引擎，一般大约90字节。 |
| _趋势（Trends）_ | days*(items/3600)*24*3600*bytes items : 监控项数量 days : 保留趋势数据的天数 bytes : 保留单个趋势数据所需要占用的字节数，依赖于数据库引擎，一般大约90字节。 |
| _事件（Events）_ | days*events*24*3600*bytes events : 每秒事件数。最糟糕的情况下，每秒一（1）个事件。 days : 保留事件数据的天数 bytes : 保留单个事件所需要占用的字节数，依赖于数据库引擎，一般大约90字节。 |

```plain
#历史数据保留90天
[root@web02 ~]# python
Python 2.7.5 (default, Apr 11 2018, 07:36:10)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-28)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
90天*(监控项的数量/取值时间)*24*3600*字节数/1024/1024（转换成MB）
>>> 90*(100/3)*24*3600*90/1024/1024
22024
#趋势365天
365*(100/3600)*24*3600*90/1024/1024
75.187683105469
#事件
>>> 365*1*24*3600*90/1024/1024
2706
```

<!-- OCR_START -->
- Z曾老湿：配置监控项
- →C不安全|10.0.0.8/zabbix/items.php？hostid=10254&form=创建监控项
- 应用zabbix-api
- 监控项
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI
- 应用集11监控项45触发器20图形9自动发现规则2Web场景
- 监控项进程
- 名称
- Listen SSH Port
- 类型
- Zabbix客户端
- 键值
- net.tcp.listen[22]
- 选择
- 主机接口10.0.0.7：10050
- 信息类型
- 数字（无正负）
- 单位
- 更新间隔
- 3s
- 自定义时间间隔
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长
- 90d
- 趋势存储时间
- 365d
- 查看值
- 不变
- 展示值映射
- 新的应用集
- 应用集
- Filesystems
- General
- Net
- interfaces
- OS
- Processes
- Security
- SystemDIY
- Zabbixagent
- 填入主机资产纪录栏位-无
- Dr增老湿ng
- 描述
- 监控ssh端口
<!-- OCR_END -->

￼

```plain
#获取值
[root@web02 ~]# zabbix_get -s 10.0.0.7 -k net.tcp.listen[22]
1
```

<!-- OCR_START -->
- Z曾老湿：最新数据[每30秒刷新
- 0不安全|10.0.0.8/zabbix/latest.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录
- 报表配置管理
- ZShar
- 仪表板问题概览Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 最新数据
- 过滤器
- 主机群组
- web_groupx
- 选择
- 名称
- 在此输入搜索
- 查看无资料项目
- 主机
- web01x
- 查看细节
- 应用集System DIY
- 应用
- 重设
- 最近检查记录
- 更改
- SystemDIY（2监控项）
- Listen SSH Port
- 2019-10-2411:13:08
- 1
- 图形
- Monitor Login User Count
- 2019-10-2411:13:10
- 2
- 0选择
- 显示堆叠数据图
- 显示数据图
- Dri曾老湿ng
<!-- OCR_END -->

￼

```plain
[root@web01 zabbix]# systemctl stop sshd
```

<!-- OCR_START -->
- Z曾老湿：最新数据[每30秒刷新—
- →C
- 不安全|10.0.0.8/zabbix/latest.php?ddreset=1
- 9
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 仪表板问题概览Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 最新数据
- 过滤器
- 主机群组
- web_groupx
- 选择
- 名称
- 在此输入搜索
- 查看无资料项目
- 主机
- web01x
- 查看细节
- 应用集
- SystemDIY
- 应用
- 重设
- 最近检查记录
- 更改
- SystemDIY（2监控项）
- Listen SSH Port
- 2019-10-2411:14:17
- 1
- 图形
- Monitor Login User Count
- 2019-10-2411:14:16
- 2
- 0选择
- 显示堆叠数据图
- 显示数据图
- Dri增e老湿ng
<!-- OCR_END -->

￼

---

| 添加值映射 |
| --- |

从上图可以看出，当端口存活的时候，数据是1，当端口不存在的时候，数据是0，看起来好low而且一般谁会去记1和0，所以此时我们可以给值添加一个映射关系，可以理解为创建一个别名。

<!-- OCR_START -->
- Z曾老湿：配置监控项
- →C不安全|10.0.0.8/zabbix/items.php?form=update&hostid=10254&itemid=28304
- 应用zabbix-api
- 监控项
- 所有主机/web01已启用ZBXSNMPJMXIPMIl应用集11监控项46触发器20图形9自动发现规则2Web场景
- 监控项进程
- 名称
- ListenSSHPort
- 类型
- Zabbix客户端
- 键值
- net.tcp.listen[22]
- 选择
- 主机接口
- 10.0.0.7:10050
- 信息类型
- 数字（无正负）
- 单位
- 更新间隔
- 3s
- 自定义时间间隔
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长
- 90d
- 趋势存储时间
- 365d
- 查看值不变
- 展示值映射
- 新的应用集
- 应用集
- CPU
- General
- Memory
- OS
- Performance
- Processes
- Securitv
- SystemDIY
- 填入主机资产纪录栏位
- Dri增老湿ng
- 描述
- 监控ssh端口
<!-- OCR_END -->

￼

此处可以选择系统自带的，也可以自己创建。

<!-- OCR_START -->
- Z曾老湿：配置监控项
- Z曾老湿：配置值映射
- →C不安全|10.0.0.8/zabbix/adm.valuemapping.php
- 应用zabbix-api
- 3=on-RedAlarm
- Maintenance status
- 0normal
- 1→inmaintenance
- 2=no data collection
- MY-SYSTEM-MIB:mySystemFanisNormal
- 1noexist
- 2=existnopower
- 3=existreadypower
- 4=normal
- 5powerbutabnormal
- 6= unknown
- QTECH-MIB:sysFanStatus
- 1=abnormal
- QTECH-MIB:sysPowerStatus
- 2=not available
- Service state
- 0→Down
- 1Up
- SNMPdevice status(hrDeviceStatus)
- 1=unknown
- 2=running
- 3→warning
- 4 =testing
- 5=→down
- SNMPinterface status(ifAdminStatus)
- 2down
- 3=testing
- SNMPinterface status(ifOperStatus)
- 4=unknown
- 5=dormant
- 6=notPresent
- 7 =lowerLayerDown
- SW-MIB:swOperStatus
- 1→online
- 2offline
- 4=faulty
- sW-MIB:swSensorStatus
- 2=faulty
- 3=below-min
- 4→nominal
- 5→above-
- Dri增e老湿ng
- 6→absent
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置监控项
- Z曾老湿：配置值映射
- →C不安全|10.0.0.8/zabbix/adm.valuemapping.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 一般
- agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 值映射
- 创建值映射
- 导入
- 名称
- 用于监控项
- APCBatteryReplacement Status
- 1=unknown
- 2=notlnstalled
- 3=ok
- 4=failed
- 5=highTemperature
- 6=replacelmmediately
- 7=lowCapacity
- APC Battery Status
- 2=batteryNormal
- 3=batteryLow
- CISCO-ENVMON-MIB::CiscoEnvMonState
- 1=normal
- 2=warming
- 3=critical
- 4=shutdown
- 5=notPresent
- 6=notFunctioning
- CPQHLTH-MIB:cpqHeTemperatureLocale
- 1=other
- 2=unknown
- 3=system
- 4→systemBoard
- 5=ioBoard
- 6=cpu
- 7=memory
- 8=storage
- 9=removableMedia
- 10=powerSupply
- 11=→ambient
- 12=chassis
- 13=bridgeCard
- CPQIDA-MIB::cpqDaCntlrModel
- 2=ida
- 3idaExpansion
- 4 =ida-2
- 5=smart
- 6=smart-2e
- 7=smart-2p
- Dri增e老湿ng
- 8=smart-2sl
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置监控项
- Z曾老湿：配置值映射
- C不安全|10.0.0.8/zabbix/adm.valuemapping.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 一般
- agent代理程序认证用户群组用户报警媒介类型
- 脚本队列
- 曾老湿
- 值映射
- ZLSjianListenPort
- 映射
- 映射到
- 动作
- 挂了
- 移除
- oibk
- 添加
- 取消
- Dri曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
CPQIDA-MIB:cpqDaPhyDrvStatus
Z曾老湿：配置监控项
CPQSINFO-MIB:Status
Dell Open Manage System Status
→Q
不安全|10.0.0.8/z
应用zabbix-api
ENTITY-STATE-MIB:EntityOperState
EQUIPMENT-MIB:sWFanStatus
EQUIPMENT-MIB::swPowerStatus
EtherLike-MIB:dot3StatsDuplexStatus
名称
EXTREME-SYSTEM-MIB:extremeFanOperational
类型
EXTREME-SYSTEM-MIB:extremeOverTemperatureAlarm
EXTREME-SYSTEM-MIB:extremePowerSupplyStatus
键值
F10-S-SERIES-CHASSIS-MIB:chSysFanTrayOperStatuS
F10-S-SERIES-CHASSIS-MIB:chSysPowerSupplyOperStatus
选择
主机接口
F10-S-SERIES-CHASSIS-MIB:extrer
FASTPATH-BOXSERVICES-PRIVATE-MIB:boXServicesFanltemState
信息类型
FASTPATH-BOXSERVICES-PRIVATE-MIB:boXServicesPowSupplyItemState
FASTPATH-BOXSERVICES-PRIVATE-MIB:boxServicesTempSensorState
单位
FOUNDRY-SN-AGENT-MIB:snChasPwrSupplyOperStats
更新间隔
HH3C-ENTITY-EXT-MIB:hh3cEntityExtErStatus
HP-ICF-CHASS:hpicfSensorstatus
自定义时间间隔
HPInsight SystemStatus
HUAWEI-ENTITY-EXTENT-MIB:hwEntityFanState
ICS-CHASSIS-MIB:icsChassisPowerSupplyOperStatus
ICS-CHASSIS-MIB:icsChassisSensorSlotOperStatus
历史数据保留时长
ICS-CHASiassratu
IF-MIB:ifOperStatus
趋势存储时间
IF-MIB:ifType
查看值
IMM-MIB:systemHealthStat
JUNIPER-ALARM-MIB:jnOperatingState
示值映射
新的应用集
JUNIPER-ALARM-MIB:jnxRedAlarmState
Maintenance status
应用集
MY-SYSTEM-MIB:my
hySystemFanlsNormal
QTECH-MIB:sysPowerStatus
Service state
SNMP device status(hrDeviceStatus)
SNMPinterface status(ifAdminStatus)
SNMPinterface status(ifOperStatus)
SW-MIB:swOperStatus
SW-MIB:swSensorStatus
TIMETRA-CHASS-MIB:TmnxDeviceState
填入主机资产纪录栏位
Value cacheoperatingmode
TruthValue
描述
VMware status
Windowsservicestartptye
Windows service state
Zabbix aqent pina status
Dr曾老湿ng
ZLS jianListenPort
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置监控项
- Z曾老湿：配置监控项
- →C不安全|10.0.0.8/zabbix/items.php?form=update&hostid=10254&itemid=28304
- 应用zabbix-api
- 监控项
- 所有主机/web01
- 已启用
- ZBX
- SNMPJMXIPMI
- 应用集11监控项46触发器20图形9自动发现规则2Web场景
- 监控项进程
- 名称
- Listen SSHPort
- 类型
- Zabbix客户端
- 键值
- net.tcp.listen[22]
- 选择
- 主机接口
- 10.0.0.7:10050
- 信息类型数字（无正负）
- 单位
- 更新间隔3s
- 自定义时间间隔
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长90d
- 趋势存储时间
- 365d
- 查看值
- ZLS jian Listen Port
- 展示值映射
- 新的应用集
- 应用集
- Filesystems
- General
- Memory
- Network interfaces
- OS
- Perform
- ance
- Processes
- Security
- SystemDIY
- Zabbixagent
- 填入主机资产纪录栏位-无-
- 曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- ee
- Z曾老湿：配置监控项
- Z曾老湿：最新数据[每30秒刷新
- →C不安全|10.0.0.8/zabbix/latest.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 仪表板
- 问题
- 概览Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 最新数据
- 过滤器
- 主机群组
- web_groupx
- 选择
- 名称
- 在此输入搜索
- 查看无资料项目
- 主机
- web01x
- 查看细节
- 应用集System DIY
- 应用
- 重设
- 最近检查记录
- 更改
- SystemDIY（2监控项）
- Listen SSH Port
- 2019-10-2411:22:50
- 挂了（0)
- 图形
- Monitor Login UserCount
- 2019-10-2411:22:49
- 2
- 0选择
- 显示堆叠数据图
- 显示数据图
- Dri增e老湿ng
<!-- OCR_END -->

￼

```plain
[root@web01 zabbix]# systemctl start sshd
```

<!-- OCR_START -->
- Z曾老湿：配置监控项
- 曾老湿：最新数据[每30秒刷新—
- 不安全|10.0.0.8/zabbix/latest.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 仪表板问题概览
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 最新数据
- 过滤器
- 主机群组
- web_groupx
- 选择
- 名称
- 在此输入搜索
- 查看无资料项目
- 主机
- web01x
- 查看细节
- 应用集SystemDIY
- 应用
- 重设
- 最近检查记录
- 更改
- SystemDIY（2监控项）
- Listen SSH Port
- 2019-10-24 11:23:20
- ojbk(1)
- 图形
- MonitorLoginUserCount
- 2019-10-2411:23:22
- 2
- 0选择
- 显示堆叠数据图
- 显示数据图
- Dri增e老湿ng
<!-- OCR_END -->

￼

## 自定义监控项-TCP11种状态
| 了解11种状态 |
| --- |

```plain
LISTEN - 侦听来自远方TCP端口的连接请求；
SYN-SENT -在发送连接请求后等待匹配的连接请求；
SYN-RECEIVED - 在收到和发送一个连接请求后等待对连接请求的确认；
ESTABLISHED- 代表一个打开的连接，数据可以传送给用户；
FIN-WAIT-1 - 等待远程TCP的连接中断请求，或先前的连接中断请求的确认；
FIN-WAIT-2 - 从远程TCP等待连接中断请求；
CLOSE-WAIT - 等待从本地用户发来的连接中断请求；
CLOSING -等待远程TCP对连接中断的确认；
LAST-ACK - 等待原来发向远程TCP的连接中断请求的确认；
TIME-WAIT -等待足够的时间以确保远程TCP接收到连接中断请求的确认；
CLOSED - 没有任何连接状态；
客户端独有的：（1）SYN_SENT （2）FIN_WAIT1 （3）FIN_WAIT2 （4）CLOSING （5）TIME_WAIT 。
服务端独有的：（1）LISTEN （2）SYN_RCVD （3）CLOSE_WAIT （4）LAST_ACK 。
共有的：（1）CLOSED （2）ESTABLISHED 。
```

---

| 配置监控 |
| --- |

```plain
#进入zabbix客户端子配置文件目录
[root@web01 ~]# cd /etc/zabbix/zabbix_agentd.d/
#编辑子配置文件
[root@web01 zabbix_agentd.d]# vim tcp_state.conf
UserParameter=tcp.state[*],netstat -ant|grep -c $1
#重启服务
[root@web01 zabbix_agentd.d]#  systemctl restart zabbix-agent
#zabbix-server测试
[root@web02 ~]# zabbix_get -s 10.0.0.7 -k tcp.state[LISTEN]
11
```

---

| 在web页面添加监控项 |
| --- |

因为TCP状态有11种，所以我们需要添加11个监控项，我们可以把所有监控项放入一个模板中，这样我们所有机器在模板中关联即可。

<!-- OCR_START -->
- 曾老湿：配置模板
- 曾老湿：最新数据[每30秒刷新
- A不安全|10.0.0.8/zabbix/templates.php
- 应用
- zabbix-api
- 模板
- 链接的模板
- 模版名称
- 可见的名称TCP状态监控模板
- 群组在..群组之中
- 其它群组
- Linuxservers
- Templates
- Templates/Applications
- Templates/NetworkDevices
- Templates/OperatingSystems
- Templates/ServersHardware
- Templates/Virtualization
- 新的群
- plate/Base
- 主机/模板在之中
- 其它|群组Discovered hosts
- TCP状态监控模板
- 添加
- 取消
- Zabbix3.4.15.@2001-2018,Zabbix SIA
- Dri曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置模板
- Z曾老湿：最新数据[每30秒刷新-×
- 0不安全|10.0.0.8/zabbix/templates.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表
- 配置
- 管理
- 主机群组
- 模板
- 主机
- 维护
- 动作
- 关联项事件
- 自动发现
- 服务
- 曾老湿
- 群组所有
- 创建模板
- 导入
- 过滤器
- 名称
- 应用
- 重设
- 应用集监控项触发器图形聚合图形自动发现Web监测链接的模板
- 已链接到
- TCP状态监控模板
- 应用集
- 监控项
- 触发器图形聚合图形自动发现Web监测
- TemplateAppApacheTomcat JMX
- 监控
- 触发
- 聚合图形自动发现Web监测
- 集5
- 项32
- 器5
- 形4
- TemplateAppFTPService
- 图形
- 集1
- 项1
- 器1
- TemplateAppGenericJavaJMX
- 集8
- 项55
- 器26
- 形11
- TemplateAppHTTPService
- 图形聚合图形自动发现Web监测
- Template App HTTPS Service
- TemplateAppIMAPService
<!-- OCR_END -->

￼

在模板中创建监控项

<!-- OCR_START -->
- Z曾老湿：配置监控项
- 曾老湿：最新数据[每30秒刷新—×|
- 不安全|10.0.0.8/zabbix/items.php?filter_set=1&hostid=10255&groupid=0
- 应用zabbix-api
- ZABBIX
- 监测中
- 资产记录报表配置管理
- ZSha
- 主机群组模板主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 监控项
- 创建监控项
- 所有模板/TCP状态监控模板应用集监控项触发器图形聚合图形
- 自动发现规则Web场景
- 过滤器
- 主机群组在此输入搜索
- 选择
- 类型所有
- 信息类型所有
- 状态所有
- 主机TCP状态监控模板×
- 更新间隔
- 历史记录
- 应用集
- 趋势
- 触发器所有
- 名称
- 模板所有
- 键值
- 应用
- 重设
- 过滤器只影响过滤后的数据
- Wizard
- 触发器
- 间隔
- 类型
- 状态
- 未发现数据
- 显示已自动发现的0中的0
- 清除历史
- 复制
- 批量更新
- 删除
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置监控项
- Z曾老湿：最新数据[每30秒刷新—×|+
- A不安全|10.0.0.8/zabbix/items.php?form=update&hostid=10255&itemid=28305
- 8
- 应用zabbix-api
- 监控项
- 所有模板/TCP状态监控模板应用集1监控项1触发器图形聚合图形自动发现规则Web场景
- 监控项进程
- 名称
- MonitorTCPStateForListen
- 类型
- Zabbix客户端
- 键值
- tp.state[LISTEN]
- 选择
- 信息类型
- 数字（无正负）
- 单位
- 更新间隔
- 3s
- 自定义时间间隔
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长
- 90d
- 趋势存储时间
- 365d
- 查看值不变
- 展示值映射
- 新的应用集
- 应用集
- SystemDIY
- 填入主机资产纪录栏位-无
- 描述
- 监控TCP状态中的Listen
- Dri增e老ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置监控项
- Z曾老湿：最新数据[每30秒刷新-×
- →C不安全|10.0.0.8/zabbix/items.php?form=update&hostid=10255&itemid=28305
- 应用zabbix-api
- 提值
- 信息类型数字（无正负）
- 单位
- 更新间隔3s
- 自定义时间间隔
- 类型
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长90d
- 趋势存储时间365d
- 查看值不变
- 展示值映射
- 新的应用集
- 应用集
- -无-
- System DIY
- 填入主机资产纪录栏位
- 描述
- 监控TCP状态中的Listen
- 已启用
- 更新
- 克隆
- 删除取消
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置监控项
- Z曾老湿：最新数据[每30秒刷新一
- C不安全|10.0.0.8/zabbixitems.php
- 应用zabbix-api
- 主机群组模板主机维护动作关联项事件自动发现服务
- 曾老湿
- 监控项
- 所有模板/TCP状态监控模板应用集1监控项1触发器图形聚合图形自动发现规则Web场景
- 监控项进程
- 名称MonitorTCPStateForESTABLISHED
- 类型Zabbix客户端
- 键值
- tcp.state[ESTABLISHED]
- 选择
- 信息类型数字（无正负）
- 单位
- 更新间隔
- 3s
- 自定义时间间隔
- 类型
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长90d
- 趋势存储时间365d
- 查看值不变
- 展示值映射
- 新的应用集
- 应用集
- SystemDIY
- 填入主机资产纪录栏位-无
- 描述
- 监控TCP状态中的ESTABLISHED
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置监控项
- Z曾老湿：最新数据[每30秒刷新-×
- →C不安全|10.0.0.8/zabbix/items.php
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置
- 管理
- ZShare
- 主机群组模板
- 主机维护动作
- 关联项事件
- 自动发现
- 服务
- 曾老湿
- 监控项已添加
- 监控项
- 创建监控项
- 所有模板/TCP状态监控模板
- 应用集1监控项2触发器图形聚合图形
- 自动发现规则
- Web场景
- 过滤器
- 主机群组
- 在此输入搜索
- 选择
- 类型所有
- 信息类型所有
- 状态所有
- 主机
- TCP状态监控模板×
- 更新间隔
- 历史记录
- 应用集
- 趋势
- 触发器所有
- 名称
- 模板所有
- 键值
- 重设
- 过滤器只影响过滤后的数据
- Wizard
- 触发器
- 间隔
- 类型
- 状态
- MonitorTCPStateForESTABLISHED
- tcp.state[ESTABLISHED]
- 3s
- 90d
- 365d
- Zabbix客户端
- SystemDIY
- 已启用
- MonitorTCPStateFor Listen
- tcp.state[LISTEN]
- 显示已自动发现的2中的2
- 0选择
- 启用
- 禁用
- 清除历史
- 复制
- 批量更新
- 删除
- Dri增e老湿ng
<!-- OCR_END -->

￼

以此类推，使用克隆的方式，创建出来所有模板。

---

| 给主机关联模板 |
| --- |

<!-- OCR_START -->
- Z曾老湿：配置主机
- Z曾老湿：最新数据[每30秒刷新—×
- →C不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表
- 配置
- 管理
- ZShare
- 主机群组模板主机维护动作关联项事件自动发现服务
- 曾老湿
- 主机
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 应用
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent 加密
- 信息
- webo1
- 应用集11
- 监控项46
- 触发器20
- 图形9
- 自动发现2
- 10.0.0.7:10050
- 已启用
- ZBXSNMPJMXIPMI
- Zabbixserver
- 监控项69
- 触发器46
- 图形11
- 127.0.0.1:10050
- TemplateAppZabbixServerTemplateOSLinuxTemplateAppZabbixAgent）
- 停用的
- 显示已自动发现的2中的2
- 0选择
- 启用
- 禁用导出
- 批量更新
- 副除
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置主机
- Z曾老湿：最新数据[每30秒刷新-×十
- →CA不安全|10.0.0.8/zabbix/hosts.php?form=update&hostid=10254&groupid=0
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表
- 配置
- 管理
- QZShare
- 主机群组模板
- 主机
- 维护动作关联项事件
- 自动发现服务
- 曾老湿
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI
- 应用集11监控项46触发器20图形9自动发现规则2Web场景
- 模板
- IPMI
- 主机资产记录
- 加密
- 链接的模板名称
- 动作
- TemplateOSLinux
- 取消链接取消链接并清理
- 链接指示器
- TCP
- 选择
- TCP状态监控模板
- 更新
- 克隆
- 全克隆
- 删除
- 取消
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置主机
- Z曾老湿：最新数据[每30秒刷新—×+
- 不安全|10.0.0.8/zabbix/hosts.php?form=update&hostid=10254&groupid=0
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 主机群组模板
- 主机维护动作关联项事件
- 自动发现
- 服务
- 曾老湿
- 主机
- 所有主机/web01已启用ZBXSNMPJMXIPMI应用集11监控项46触发器20图形9自动发现规则2Web场景
- 主机模板
- IPMI宏主机资产记录
- 加密
- 链接的模板名称
- 动作
- TemplateOSLinux
- 取消链接取消链接并清理
- 链接指示器
- TCP状态监控模板×
- 选择
- 添加
- 全克隆
- Dri曾e老湿ng
<!-- OCR_END -->

￼

```plain
[root@web02 ~]# zabbix_get -s 10.0.0.7 -k tcp.state[LISTEN]
11
[root@web02 ~]# zabbix_get -s 10.0.0.7 -k tcp.state[ESTABLISHED]
25
```

<!-- OCR_START -->
- Z曾老湿：最新数据[每30秒刷新-×
- ←→C不安全|10.0.0.8/zabbix/latest.php?ddreset=1
- 应用zabbix-api
- ZABBIX监测中
- 资产记录报表配置管理
- QZShare
- 仪表板问题概览Web监测
- 最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 最新数据
- 过滤器
- 主机群组
- web_groupx
- 选择
- 名称
- 在此输入搜索
- 查看无资料项目
- 主机
- web01x
- 查看细节
- 应用集
- SystemDIY
- 应用
- 重设
- 最近检查记录
- 更改
- SystemDIY（4监控项）
- Listen SSH Port
- 2019-10-2412:26:59
- ojbk(1)
- 图形
- Monitor Login User Count
- 2019-10-2412:26:58
- 2
- MonitorTCPStateForESTABLISHED
- 27
- MonitorTCPStateForLiSTEN
- 11
- 0选择
- 显示堆叠数据图
- 显示数据图
- Dr增e老湿ng
<!-- OCR_END -->

￼

## zabbix多条件触发器
**监控内存百分比（取出内存的可用大小 / 总内存大小 = 实际可用的百分比）**

---

| 自定义监控内存百分比 |
| --- |

```plain
#在agent端编辑配置
[root@web01 zabbix_agentd.d]# vim /etc/zabbix/zabbix_agentd.d/mem_state.conf
UserParameter=mem.state,free -m|awk '/^Mem/{print $NF*100/$2}'
#在server端获取数据
[root@web02 ~]# zabbix_get -s 10.0.0.7 -k mem.state
69.9294
```

_**web页面添加监控**_

<!-- OCR_START -->
- Z曾老湿：最新数据[每30秒刷新-×
- Z曾老湿：配置主机
- →C
- 不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置
- 管理
- ZShare
- 主机群组模板
- 主机
- 维护动作关联项事件自动发现服务
- 曾老湿
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 应用
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent 加密
- 信息
- web01
- 应用集11
- 监控项48
- 触发器20
- 图形9
- 自动发现2
- 10.0.0.7:10050
- TCP状态监控模板，TemplateOSLinux（TemplateAppZabbixAgent)
- 已启用
- ZBXSNMPJMXIPMI
- Zabbix server
- 监控项69
- 触发器46
- 图形11
- 127.0.0.1:10050
- TemplateAppZabbixServerTemplateOSLinuxTemplateAppZabbixAgent）
- 停用的
- 显示已自动发现的2中的2
- 0选择
- 启用
- 禁用导出
- 批量更新
- 测除
- r曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：最新数据[每30秒刷新-×
- Z曾老湿：配置监控项
- C不安全|10.0.0.8/zabbix/items.php？hostid=10254&form=创建监控项
- 应用zabbix-api
- 监控项
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集11监控项48触发器20图形9自动发现规则2Web场景
- 监控项进程
- 名称MonitorMemAvailable
- 类型Zabbix客户端
- 键值mem.state
- 选择
- 主机接口
- 10.0.0.7:10050
- 信息类型
- 浮点数
- 单位
- 更新间隔3s
- 自定义时间间隔
- 类型
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长
- 90d
- 趋势存储时间
- 365d
- 查看值不变
- 展示值映射
- 新的应用集
- 应用集
- Filesystems
- General
- Network interfaces
- Memory
- OS
- Performance
- Processes
- temDIY
- 填入主机资产纪录栏位-无
- Dr增老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：最新数据[每30秒刷新
- C不安全|10.0.0.8/zabbix/latest.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录
- 报表配置管理
- ZShare
- 仪表板问题
- 概览Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 最新数据
- 过滤器
- 主机群组
- web_groupx
- 选择
- 名称
- 在此输入搜索
- 查看无资料项目
- 主机
- web01x
- 查看细节
- 应用集
- SystemDIY
- 应用
- 重设
- 最近检查记录
- 更改
- SystemDIY（5监控项）
- Listen SSH Port
- 2019-10-2414:58:17
- ojbk(1)
- 图形
- Monitor Login User Count
- 2019-10-2414:58:19
- 2
- MonitorMemAvailable
- 69.93
- MonitorTCPStateForESTABLISHED
- 2019-10-24 14:58:18
- 25
- MonitorTCPStateFor LISTEN
- 11
- 0选择
- 显示堆叠数据图
- 显示数据图
- Dri曾e老湿ng
<!-- OCR_END -->

￼

没有单位看不出来69是什么。

<!-- OCR_START -->
- Z曾老湿：最新数据[每30秒刷新-×
- Z曾老湿：配置监控项
- CA不安全|10.0.0.8/zabbix/items.php?form=update&hostid=10254&itemid=28310
- 应用zabbix-api
- 监控项
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集11监控项49触发器20图形9自动发现规则2Web场景
- 监控项进程
- 名称MonitorMemAvailable
- 类型
- Zabbix客户端
- 键值
- mem.state
- 选择
- 主机接口
- 10.0.0.7:10050
- 信息类型
- 浮点数
- 单位
- 更新间隔
- 3s
- 自定义时间间隔
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长
- 90d
- 趋势存储时间
- 365d
- 查看值
- 不变
- 展示值映射
- 新的应用集
- 应用集
- CPU
- Filesystems
- General
- Memory
- Netwo
- interfaces
- OS
- Processes
- Security
- SystemDIY
- 填入主机资产纪录栏位
- Dr曾e老湿ng
- 描述
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：最新数据[每30秒刷新—
- →C不安全|10.0.0.8/zabbixlatest.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 仪表板问题概览
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 最新数据
- 过滤器
- 主机群组
- web_groupx
- 选择
- 名称
- 在此输入搜索
- 查看无资料项目
- 主机
- web01x
- 查看细节
- 应用集
- SystemDIY
- 应用
- 重设
- 最近检查记录
- 更改
- SystemDIY（5监控项）
- Listen SSH Port
- 2019-10-2415:00:14
- ojbk(1)
- 图形
- Monitor Login User Count
- 2019-10-2415:00:13
- 2
- Monitor MemAvailable
- 69.93%
- MonitorTCPStateForESTABLISHED
- 2019-10-2415:00:15
- 25
- MonitorTCPStateFor LISTEN
- 11
- Dr曾老湿ng
<!-- OCR_END -->

￼

_**添加触发器**_

<!-- OCR_START -->
- Z曾老湿：最新数据[每30秒刷新-×
- Z曾老湿：配置主机
- 不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表
- 配置
- 管理
- ZShare
- 主机群组模板主机维护动作关联项事件自动发现服务
- 曾老湿
- 主机
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 端口
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent加密
- 信息
- web01
- 应用集11
- 监控项49
- 触发器20
- 图形9
- 自动发现2
- 10.0.0.7:10050
- TCP状态监控模板，TemplateOSLinux（TemplateAppZabbixAgent)
- 已启用
- ZBXSNMPJMXIPMI
- Zabbix server
- 监控项69
- 触发器46
- 图形11
- 127.0.0.1:10050
- TemplateAppZabbixServerTemplateOSLinuxTemplateAppZabbixAgent)
- 停用的
- 显示已自动发现的2中的2
- 0选择
- 导出
- 批量更新
- 前除
- 曾老湿n
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：最新数据[每30秒刷新—
- 曾老湿：配置触发器
- CA不安全|10.0.0.8/zabbix/triggers.php?groupid=0&hostid=10254&form=创建触发器
- 应用zabbix-api
- 所有主机/web01已启用ZBXSNMPJMXIPMIl应用集11监控项49触发器20图形9自动发现规则2Web场景
- 触发器依赖关系
- 名尔MemAvLessThan{ITEM.VALUE)
- 严重性未分类信息警告
- 一般严重
- 严重
- 灾难
- 表达式
- (web01:mem.state.last()>20
- 添加
- 表达式构造器
- 事件成功选代
- 表达式恢复表达式无
- 问题事件生成模式
- 单个
- 多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 移除
- 允许手动关闭
- URL
- 描述
- 已启用
- 取消
- Dr增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
Z曾老湿：最新数据[每30秒刷新-×
Z曾老湿：配置触发器
不安全|10.0.0.8/zabbix/triggers.php
8
应用zabbix-api
应用
重设
严重性
名称
表达式
状态
信息
警告
TemplateOSLinux:/etc/passwd has beenchanged on{HOST.NAME)
{web01:vfs.fl.cksum[/etc/passwd.diff(o)}>0
已启用
TemplateOS Linux:Configuredmaxnumberof opened fles istoo low on(HOST.NAME)
{web01:kernel.maxfles.last(0)<1024
TemplateOS Linux:Configuredmaxnumberof processesistoolowon{HOST.NAME)
{web01:kenel.maxproc.last（0))256
Template OS Linux:Disk I/O is overloaded on{HOST.NAME}
{web01:system.cpu.utiliowait].avg(5m)>20
Mountedfilesystemdiscovery:Freediskspaceislessthan20%onvolume/
{web01:vfs.fs.size[/,pfree].last(0))<20
{web01:vfs.fs.size[/boot,pfree].last(0)}20
Mountedfilesystem discovery:Freeinodesisless than20%onvolume
{web01:vfs.fs.inode[/,pfree]last(0)}20
Mountedflesystemdiscovery:Freeinodesislessthan20%onvolume/boot
{web01:vfs.fs.inode[/boot,pfree.last（(0)}<20
TemplateOSLinux:HostinformationwaschangedonHOST.NAME)
{web01:system.uname.diff()}>0
Template App ZabbixAgent:Host name of zabbix_agentd was changed on {HOST.NAME}
{web01:agent.hostname.diff(0)>0
TemplateOS Linux:Hostname was changedon(HOST.NAME)
{web01:system.hostname.diff(0)}>0
一般严重
TemplateOsLinux:Lackof availableme
oryon server{HOST.NAME}
{web01:vm.memory.size[available].last(0))>20M
TemplateOSLinux:Lackof freeswap space on{HOST.NAME}
{web01:system.swap.size[.pfree].last(0))<50
MemAv LessThan (ITEM.VALUE)
{web01:mem.state.last()><20
Monitor LoginUserCountProblem主机名：(HOST.NAME}IP地址：(HOST.IP)
{web01:user.count.last()}>2
TemplateOSLinux:ProcessorloadistoohighonHOST.NAME)
{web01:system.cpu.load[percpu,avg1].avg（5m)>5
Template OS Linux:Too many processes on{HOST.NAME}
{web01:proc.num[.avg(5m)}>300
TemplateOSLinux:Toomany processesrunning onHOST.NAME)
{web01:proc.num[..run].avg(5m))>30
TemplateAppZabbixAgent:Version of zabbix_agent(d)was changed on{HOST.NAME)
{web01:agent.version.dif()}>0
TemplateAppZabbixAgent:Zabbixagent on{HOST.NAME}isunreachablefor5minutes
{web01:agent.ping.nodata(5m）)=1
TemplateOSLinux:{HOST.NAME}hasjustbeenrestarted
(web01:system.uptime.change(0))<0
显示已自动发现的21中的21
Dri曾e老湿ng
<!-- OCR_END -->

￼

```plain
#测试一波
[root@web01 zabbix_agentd.d]# dd < /dev/zero > /dev/null bs=1024M count=2048
```

<!-- OCR_START -->
- Z曾老湿：仪表板
- 曾老湿：配置触发器
- →C不安全|10.0.0.8/zabbixzabbix.php?action=dashboard.view&ddreset=1
- 8
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 仪表板问题
- 概览
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- Dashboard
- 编辑仪表盘
- 目日
- 添加仪表盘/Dashboard
- 清除
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 问题在web01
- MemAv LessThan18.26%
- 未添加数据图
- 未添加聚合图形
- 未添加拓扑图
- 主机群组
- 正常设备
- 异常设备
- 2019-10-2415:08:32
- web_group
- 1
- 已更新：15:08:46
- 问题
- 时间
- 恢复时间
- 状态
- 信息
- 主机
- 问题·严重性
- 持续时间
- 确认
- 动作
- 15:08:32
- web01
- 完成1
- 系统状态
- 灾难
- 严重
- 一般严重
- 警告
- 未分类
- 已更新：15:08:47
- Zabbix状态
- 1of1问题显示已更新：15:08:47
- 参数
- 细节
- Dri增e老湿ng
- 自动发现状态
- Zabbix服务器端运行中
- localhost:10051
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：仪表板
- 曾老湿：配置触发器
- 收件箱
- mail.qq.com/cgi-bin/frame_html?sid=IVos9kYlvU7-liV4&r=045c83ef24c4114b66d02d994189725a
- bix-api
- <133411023@qq.com>0
- |反馈建议|帮助中心|退出
- Moi
- QQ邮箱
- 邮箱首页|设置-换肤?
- Q邮件全文搜索
- 曾老写信
- 253097001
- 警地址：10.0.0.
- le告警信息：MemAvLessTh
- 2分钟前
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：仪表板
- 曾老湿：配置触发器
- 故障PROBLEM，服务器：web01发×
- →C
- mail.qq.com/cgi-bin/frame_html?sid=IVos9kYivU7-liv4&r=045c83ef24c4114b66d02d994189725a
- 9
- 应用
- <133411023@qq.com>@
- |反馈建议|帮助中心|退出
- Moi
- QQ邮箱
- 邮箱首页|设置-换肤?
- Q邮件全文搜索
- 写信
- 《返回
- 回复
- 回复全部
- 转发
- 删除
- 彻底删除
- 举报
- 拒收
- 标记为
- 移动到..
- 上一封下一封
- 收信
- 故障PROBLEM，服务器：web01发生：MemAvLessThan18.26%故障！
- 通讯录
- 发件人：253097001<253097001@qq.com>
- 时间：2019年10月24日（星期四）下午3:08
- 收件箱（60）
- 收件人：<133411023@qq.com>
- 星标邮件★
- 这不是腾讯公司的官方邮件？。请勿轻信密保、汇款、中奖信息，勿轻易拨打陌生电话。举报垃圾邮件
- 网站安全云检测
- 群邮件
- 草稿箱
- 告警地址：10.0.0.7
- 已发送
- 已删除
- 告警主机：web01
- 垃圾箱（3）
- [清空]
- QQ邮件订阅
- 告警时间：2019.10.2415：08:32
- 其他邮箱
- 告警等级：Average
- 日历|记事本
- 在线文档NEW
- 附件收藏
- 告警信息：MemAvLessThan18.26%
- 文件中转站
- 贺卡|明信片
- 告警项目：mem.state
- 阅读空间
- 问题详情：MonitorMemAvailable:18.26%
- 当前状态：PROBLEM:18.26%
- 事件ID:25
- 快捷回复给：253097001
- 曾老湿
<!-- OCR_END -->

￼

目前属于单条件触发器，因为内存低于20%就报警了，在生产中，我们应该是当内存低于20%并且占用了swap空间，然后再报警。

_**创建swap监控配置**_

```plain
[root@web01 zabbix_agentd.d]# vim mem_state.conf
UserParameter=swap.state,free -m|awk '/^Swap/{print $3*100/$2}'
[root@web01 zabbix_agentd.d]# systemctl restart zabbix-agent
```

_**web页面添加swap监控**_

<!-- OCR_START -->
- Z曾老湿：仪表板
- Z曾老湿：配置主机
- 故障PROBLEM，服务器：web01发X
- →C
- 不安全|10.0.0.8/zabbix/hosts.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表
- 配置
- 管理
- QShare
- 主机群组模板主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 主机
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
- DNS
- IP地址
- 应用
- 重设
- 应用集
- 监控项
- 触发器
- 图形
- 自动发现
- Web监测
- 接口
- 模板
- 状态
- 可用性
- agent加密
- 信息
- web01
- 应用集11
- 监控项49
- 触发器21
- 图形9
- 自动发现2
- 10.0.0.7:10050
- TCP状态监控模板，TemplateOSLinux（TemplateAppZabbixAgent)
- 已启用
- ZBXSNMPJMXIPMI
- Zabbix server
- 监控项69
- 触发器46
- 图形11
- 127.0.0.1:10050
- TemplateAppZabbixServerTemplateOSLinuxTemplateAppZabbixAgent)
- 停用的
- 显示已自动发现的2中的2
- 0选择
- 启用
- 批量更新
- 副除
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：仪表板
- Z曾老湿：配置监控项
- 故障PROBLEM,服务器：web01发X
- A不安全|10.0.0.8/zabbix/items.php？hostid=10254&form=创建监控项
- 应用
- zabbix-api
- 监控项
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集11监控项49触发器21图形9自动发现规则2Web场景
- 监控项进程
- 名称MonitorSwapUsed
- 类型Zabbix客户端
- 键值swap.state
- 选择
- 主机接口10.0.0.7：10050
- 信息类型
- 浮点数
- 单位%
- 更新间隔
- 3s
- 自定义时间间隔
- 类型
- 间隔
- 期间
- 动作
- 灵活
- 调度
- 50s
- 1-7,00:00-24:00
- 移除
- 添加
- 历史数据保留时长
- 90d
- 趋势存储时间365d
- 查看值不变
- 展示值映射
- 新的应用集
- 应用集
- Filesystems
- General
- Memory
- Network
- interfaces
- OS
- Security
- 填入主机资产纪录栏位-无
- Dr增e老湿ng
- 描述
- 已使用swap的百分比
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：仪表板
- 曾老湿：最新数据[每30秒刷新—
- 故障PROBLEM，服务器：web01发X
- 不安全|10.0.0.8/zabbix/latest.php?ddreset=1
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 仪表板问题
- 概览
- Web监测
- 最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 最新数据
- 过滤器
- 主机群组
- web_groupx
- 选择
- 名称
- 在此输入搜索
- 查看无资料项目
- 主机
- web01x
- 查看细节
- 应用集
- SystemDIY
- 重设
- 最近检查记录
- 更改
- SystemDIY（6监控项）
- ListenSSHPort
- 2019-10-24 15:22:11
- ojbk(1)
- 图形
- Monitor LoginUser Count
- 2019-10-2415:22:10
- 2
- Monitor MemAvailable
- 70.03%
- MonitorSwapUsed
- 2019-10-2415:22:12
- 0%
- Monitor TCP StateFor ESTABLISHED
- 25
- MonitorTCPStateForLISTEN
- 11
- 0选择
- 显示堆叠数据图
- 显示数据图
- Dr曾老湿ng
<!-- OCR_END -->

￼

_**添加多条件触发器**_

<!-- OCR_START -->
- Z曾老湿：仪表板
- Z曾老湿：配置触发器
- 故障PROBLEM，服务器：web01发X
- ←→
- 不安全|10.0.0.8/zabbix/triggers.php?groupid=0&hostid=10254&form=创建触发器
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 主机群组模板
- 主机维护动作关联项事件自动发现服务
- 曾老
- 触发器
- 所有主机/Web01已启用ZBXSNMPJMXIPMI
- 应用集11监控项50触发器21图形9自动发现规则2Web场景
- 触发器依赖关系
- 名尔MemAvLessThan{ITEM.VALUE}andSwapUsedMoreThan{ITEM.VALUE}
- 严重性
- 未分类信息警告
- 一般严重
- 严重
- 灾难
- 表达式
- (web01:mem.state.last()}<20
- 添加
- 表达式构造器
- 事件成功选代
- 恢复表达式无
- 问题事件生成模式
- 单个
- 多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 移除
- 允许手动关闭
- URL
- 描述
- 增老湿ng
- 已启用
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：仪表板
- Z曾老湿：配置触发器
- 故障PROBLEM，服务器：web01发X
- →C不安全|10.0.0.8/zabbix/triggers.php
- 应用zabbix-api
- 触发器
- 所有主机/WebO1已启用ZBXSNMPJMXIPMI
- 应用集11监控项50触发器21图形9自动发现规则2Web场景
- 触发器依赖关系
- 名和MemAvLessThan{ITEM.VALUE}andSwapUsedMoreThan{ITEM.VALUE)
- 严重性未分类信息警告一般严重
- 严重灾难
- 表达式
- 编辑
- 插入表达式
- 和（同时满足）
- 或替换
- AandB
- 动作
- 信息
- 移除
- FA{web01:mem.state.last()<20
- B{web01:swap.state.last()}>5
- 测试
- 关闭表达式构造器
- 事件成功选代
- 恢复表达式无
- 问题事件生成模式
- 多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 添加
- 允许手动关闭
- URL
- 曾老湿ng
- 描述
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置触发器
- Z曾老湿：最新数据[每30秒刷新-×
- 收到1封新邮件
- →C不安全|10.0.0.8/zabbix/triggers.php?form=update&hostid=10254&triggerid=15662
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 主机群组模板
- 主机维护动作关联项事件自动发现服务
- 曾老湿
- 触发器
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集11监控项50触发器21图形9自动发现规则2Web场景
- 触发器依赖关系
- 名称
- MemAv LessThan(ITEM.VALUE1}andSwapUsedMoreThan{ITEM.VALUE2)
- 严重性未分类信息警告一般严重
- 严重灾难
- 表达式
- {web01:mem.state.last()<20 and {web01:swap.state.last()>5
- 添加
- 表达式构造器
- 事件成功选代
- 恢复表达式无
- 问题事件生成模式
- 单个
- 多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 移除
- 允许手动关闭
- URL
- 描述
- 曾老湿ng
- 已启用
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置触发器
- 曾老湿：最新数据[每30秒刷新—
- 故障PROBLEM，服务器：web01发X
- mail.q.com/cgi-bin/frame_html?sid=IVos9kYivU7-liV4&r=045c83ef24c4114b66d02d994189725a
- 应用
- zabbix-api
- <133411023@qq.com>@
- 反馈建议|帮助中心|退出
- MoilQQ邮箱
- mail.qq.com
- 邮箱首页|设置-换肤?
- Q邮件全文搜索
- 写信
- 《返回回复回复全部转发删除彻底删除举报拒收标记为移动到
- 上一封下一封
- 收信
- 故障PROBLEM，服务器：web01发生：MemAvLessThan0.45%andSwapUsedMoreThan27.47%故障！
- 通讯录
- 1
- 收件箱（62）
- 星标邮件★
- 这不是腾讯公司的官方邮件。请勿轻信密保、汇款、中奖信息，勿轻易拨打陌生电话。举报垃圾邮件
- 网站安全云检测
- 群邮件
- 草稿箱
- 告警地址：10.0.0.7
- 已发送
- 已删除
- 告警主机：web01
- 垃圾箱（3)
- [清空]
- QQ邮件订阅
- 告警时间：2019.10.2415：39:59
- 其他邮箱
- 告警等级：High
- 日历|记事本
- 在线文档NEW
- 附件收藏
- 告警信息：MemAvLessThan0.45%andSwapUsedMoreThan27.47%
- 文件中转站
- 贺卡|明信片
- 告警项目：mem.state
- 阅读空间
- 问题详情：MonitorMemAvailable:0.45%
- 当前状态：PROBLEM:0.45%
- 事件ID:37
- Dri曾老湿ng
<!-- OCR_END -->

￼

_**常用触发器**_

```plain
and                 #并且
or              #或者
last()          #比对最新的值
avg()           #平均值
diff()          #比对上一次文件的内容
nodata()        #收不不到数据进行报警nodata(5m)
(5m)          #表示最近5分钟得到值
(#5)                #表示最近5次得到的值
```

## zabbix自定义告警方式
当监控项超过触发器设定的阈值->触发动作->（发消息|执行命令）

1.怎么报警->2.报警怎么发，发什么内容->3.报警发给谁

**注意：要使SMTP验证选项可用，zabbix服务器应使用cURL 7.20.0或更高版本**

---

| 配置动作 |
| --- |

<!-- OCR_START -->
- 曾老湿：动作的配置
- Z曾老湿：最新数据[每30秒刷新
- 收到3封新邮件
- 0不安全|10.0.0.8/zabbix/actionconf.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录
- 报表
- 配置
- 管理
- QZShare
- 主机群组
- 模板
- 主机维护
- 动作
- 关联项事件
- 自动发现
- 服务
- 曾老湿
- 事件源触发器
- 创建动作
- 过滤器
- 名称
- 状态
- 任何已启用停用的
- 应用
- 重设
- 条件
- 操作
- Report problems toZabbixadministrators
- 发送消息给用户群组：Zabbixadministrators通过所有介质
- 已启用
- 显示已自动发现的1中的1
- 0选择
- 制降
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：动作的配置
- 曾老湿：最新数据[每30秒刷新-×
- 收到3封新邮件
- ①不安全|10.0.0.8/zabbix/actionconf.php?form=update&actionid=3
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 主机群组模板主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 动作
- 动作操作
- 恢复操作确认操作
- 条件标签
- 名称
- 新的触发条件
- 触发器名称似
- 添加
- 已启用
- 更新
- 克隆
- Dr曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：动作的配置
- Z曾老湿：最新数据[每30秒刷新-×
- 收到3封新邮件
- →C不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- 默认操作步骤持续时间1h
- 默认标题故障（TRIGGER.STATUS），服务器：(HOSTNAME1)发生：{TRIGGER.NAME}故障！
- 消息内容告警地址：（(HOST.IP)
- 告警主机：(HOSTNAME1)
- 告警时间：(EVENT.DATE}（EVENT.TIME)
- 维护期间暂停操作
- 操作步骤细节
- 开始于持续时间动作
- 发送消息给用户群组：Zabbixadministrators通过所有介质
- 立即地默认
- 编辑移除
- 操作细节
- 步骤
- 1（0-无穷大）
- 步骤持续时间
- （0-使用默认）
- 操作类型发送消息
- 发送到用户群组
- 用户群组
- 动作
- Zabbix administrators
- 移除
- 添加
- 发送到用户
- 用户
- 仅送到QQ邮箱
- 消息内容
- 条件标签
- 名称
- 新的
- 添加取消
- 更新
- 克隆
- 删除
- 取消
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 老湿：动作的配置
- 收到3封新邮件
- ←→C
- 不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 主机群组模板主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 动作
- 操作恢复操作确认操作
- 默认标题恢复(TRIGGER.STATUS}，服务器：(HOSTNAME1：(TRIGGER.NAME}已恢复！
- 消息内容
- 告警地址：(HOST.IP)
- 告警主机：（HOSTNAME1）
- 告警时间：(EVENT.DATE)(EVENT.TIME)
- 操作细节
- 操作类型发送消息
- 发送到用户群组用户群组
- Zabbix administrators
- 移除
- 添加
- 发送到用户
- 用户
- Admin (Zabbix Administrator)
- 仅送到-所有-
- 添加取消
- 更新
- 克隆删除取消
- Dri曾老湿ng
- Zabbix3.4.15.2001-2018ZabbixSIA
<!-- OCR_END -->

￼

花式报警，花里胡哨，请见:[http://class.driverzeng.com，当然你登录不进去，所以此处只有内部学员](http://class.driverzeng.com%EF%BC%8C%E5%BD%93%E7%84%B6%E4%BD%A0%E7%99%BB%E5%BD%95%E4%B8%8D%E8%BF%9B%E5%8E%BB%EF%BC%8C%E6%89%80%E4%BB%A5%E6%AD%A4%E5%A4%84%E5%8F%AA%E6%9C%89%E5%86%85%E9%83%A8%E5%AD%A6%E5%91%98) 可以看见。

---

| 配置媒介 |
| --- |

<!-- OCR_START -->
- 曾老湿：配置媒体类型
- 曾老湿：最新数据[每30秒刷新—×
- 收到3封新邮件
- 不安全|10.0.0.8/zabbix/zabbix.php?action=mediatype.list&ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中
- 资产记录报表配置管理
- 一般
- agent代理程序
- 认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 报警媒介类型
- 创建媒体类型
- 过滤器
- 名称
- 状态
- 任何
- 已启用停用的
- 应用
- 重设
- 类型
- 用于动作中
- 细节
- Jabber
- 已启用
- QQ邮箱
- 电子邮件
- SMTP服务器："smtp.q.com"SMTPHELO:"q.com，SMTP电邮：“253097001@qq.com
- SMS
- 短信
- GSM调制解调器：“/dev/ttySo"
- 显示已自动发现的3中的3
- 0选择
- 启用
- 禁用删除
- Dri曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置媒体类型
- Z曾老湿：最新数据[每30秒刷新-×|
- 收到3封新邮件
- →C不安全|10.0.0.8/zabbix/zabbix.php?action=mediatype.edit&mediatypeid=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录
- 报表配置管理
- aZShare
- agent代理程序
- 认证用户群组
- 用户
- 报警媒介类型
- 脚本
- 队列
- 曾老湿
- 选项
- 名称QQ邮箱
- 类型
- 电子邮件
- SMTP服务器
- smtp.qq.com
- SMTP服务器端口
- 465
- SMTPHELO
- qq.com
- SMTP电邮
- 253097001@qq.com
- 安全链接
- 无STARTTLS（纯文本通信协议扩展）
- SSL/TLS
- SSL验证对端
- SSL验证主机
- 认证
- 用户名称
- 253097001@q.com
- 密码
- 修改密码
- 已启用
- 更新
- 克隆删除取消
- Dri增e老湿ng
<!-- OCR_END -->

￼

---

| 配置用户 |
| --- |

<!-- OCR_START -->
- 曾老湿：配置用户
- 曾老湿：最新数据[每30秒刷新—
- 收到3封新邮件
- A不安全|10.0.0.8/zabbix/users.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中
- 资产记录
- 报表配置
- 管理
- ZShare
- 一般
- agent代理程序认证用户群组
- 用户
- 报警媒介类型
- 脚本
- 队列
- 曾老湿
- 用户群组所有
- 创建用户
- 过滤器
- 别名
- 名称
- 姓氏
- 用户类型任何用户管理员超级管理员
- 应用
- 重设
- 用户名第一部分
- 用户类型
- 群组
- 是否在线？
- 登录
- 前端访问
- 调试模式
- 状态
- Admin
- Administrator
- 超级管理员
- Zabbix administrators
- 是（2019-10-2416:17:57)
- 正常
- 系统默认
- 停用的
- 已启用
- guest
- Guests
- 不（2019-10-2411:52:22)
- 显示已自动发现的2中的2
- 0选择
- 解锁
- Drive老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置用户
- Z曾老湿：最新数据[每30秒刷新—×
- 收到3封新邮件
- C不安全|10.0.0.8/zabbix/users.php?form=update&userid=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置
- 管理
- Share
- 一般
- agent代理程序认证用户群组用户报警媒介类型
- 脚本队列
- 曾老湿
- 用户
- 报警媒介权限
- 别名
- Admin
- 用户名第一部分
- 姓氏
- Administrator
- 群组
- Zabbixadministra
- 选择
- 在此输入搜索
- 密码
- 修改密码
- 语言中文（zh_CN)
- 主题系统默认
- 自动登录
- 自动注销
- 15m
- 刷新
- 30s
- 每页行数
- 50
- URL（登录后）
- 更新
- 取消
- Dri增e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置用户
- Z曾老湿：最新数据[每30秒刷新—×
- 收到3封新邮件
- C不安全|10.0.0.8/zabbix/users.php?form=update&userid=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 一般
- agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 用户
- 报警媒介
- 权限
- 报警媒介类型
- 收件人
- 当启用时
- 如果存在严重性则使用
- Status动作
- QQ邮箱133411023@qq.com
- 1-7,00:00-24:00
- 未信警一严灾
- 已启用编辑移除
- 添加
- 更新
- 删除
- 取消
- Dri增老湿ng
<!-- OCR_END -->

￼

## zabbix自愈模式配置
有些时候，我们的服务宕机了，或者有些服务停掉了，那么我们可以先尝试让他启动，看是否能起的来，为了不影响用户的体验，先把服务起起来，然后再去排查，是什么原因故障的。

那么此时我们就需要用到zabbix的自愈模式，这个...叫起来很好听，说白了，就是在让zabbix-server通过远程执行命令的方式，在agent上执行命令，启动服务。

---

| web页面配置 |
| --- |

首先添加一个ssh端口监控的触发器

<!-- OCR_START -->
- 曾老湿：动作的配置
- Z曾老湿：配置触发器
- 故障PROBLEM，服务器：web01发×
- 别离开我啊，小老弟，点回来～
- 不安全|10.0.0.8/zabbix/triggers.php?form=update&hostid=10254&triggerid=15663
- 8
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置
- 管理
- QZShare
- 主机群组模板
- 主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 触发器
- 所有主机/web01
- 已启用ZBXSNMPJMXIPMI应用集11监控项50触发器22图形9自动发现规则2Web场景
- 触发器依赖关系
- 名称
- ListenSSHPort Problem{ITEM.VALUE)
- 严重性
- 未分类信息警告一般严重
- 灾难
- 表达式
- {web01:net.tcp.listen[22]last()}=0
- 添加
- 表达式构造器
- 事件成功选代
- 恢复表达式无
- 问题事件生成模式
- 单个
- 多重
- 事件成功关闭
- 所有问题
- 所有问题如果标签值匹配
- 标记
- 移除
- 允许手动关闭
- URL
- 描述
- 曾老湿ng
- 已启用
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：动作的配置
- 曾老湿：最新数据[每30秒刷新—×
- 收到3封新邮件
- →C
- 不安全|10.0.0.8/zabbix/actionconf.php?ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置
- 管理
- Share
- 主机群组模板主机维护动作关联项事件自动发现服务
- 曾老湿
- 动作
- 事件源触发器
- 创建动作
- 过滤器
- 名称
- 状态
- 任何
- 已启用停用的
- 应用
- 重设
- 条件
- 操作
- Report problemstoZabbix administrators
- 发送消息给用户：Admin（ZabbixAdministrator）通过QQ邮箱
- 已启用
- 发送消息给用户群组：Zabbixadministrators通过QQ邮箱
- 显示已自动发现的1中的1
- 0选择启用
- 删除
- Dr曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置触发器
- 曾老湿：动作的配置
- 收到3封新邮件
- 别离开我啊，小老弟，点回来~
- 不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 主机群组模板主机维护动作关联项事件自动发现
- 服务
- 曾老湿
- 动作
- 动作操作
- 恢复操作确认操作
- 名称
- SSH自愈（你懂我意思吧）
- 条件标签
- 触发器=web01:ListenSSHPortProblem挂了（0)
- 移除
- 新的触发条件
- 触发器
- 在此输入搜索
- 选择
- 添加
- 已启用
- 更新
- 克隆删除取消
- Dri曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：仪表板
- Z曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- 不安全|10.0.0.8/zabbix/actionconf.php
- 应用
- zabbix-api
- 动作
- 动作操作
- 恢复操作确认操作
- 默认操作步骤持续时间1h
- 消息内容告警地址：(HOST.IP)
- 告警主机：（HOSTNAME1)
- 告警时间：(EVENT.DATE}{EVENT.TIME）
- 维护期间暂停操作
- 操作
- 步骤
- 细节
- 开始于
- 持续时间
- 操作细节
- 1
- 1（0-无穷大）
- 步骤持续时间
- 60
- （0-使用默认）
- 操作类型
- 远程命令
- 目标列表目标
- 当前主机
- 移除
- 新的
- 类型
- 自定义脚本
- 执行在
- Zabbix客户端
- Zabbix server（代理）zabbix服务器
- 命令
- sudosystemctl restartshd
- 条件标签
- 名称
- 曾老湿
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：仪表板
- Z曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来
- A不安全|10.0.0.8/zabbix/actionconf.php
- 应用
- zabbix-api
- 动作
- 动作操作恢复操作确认操作
- 默认操作步骤持续时间1h
- 默认标题故障（TRIGGER.STATUS)，服务器：(HOSTNAME1）发生：(TRIGGER.NAME）故障！
- 消息内容告警地址：(HOST.IP)
- 告警主机：(HOSTNAME1)
- 告警时间：(EVENT.DATE){EVENT.TIME)
- 维护期间暂停操作
- 操作
- 步骤
- 细节
- 开始于
- 持续时间
- 于当前主机上执行远程命令
- 立即地
- 60
- 编辑移除
- 操作细节
- 2-
- 2（0-无穷大）
- 步骤持续时间
- （0-使用默认）
- 操作类型
- 发送消息
- 发送到用户群组
- 用户群组
- Zabbix administrators
- 移除
- 添加
- 发送到用户
- 用户
- Admin (Zabbix Administrator)
- 仅送到
- QQ邮箱
- 消息内容
- 条件标签
- 名称
- 曾老湿
- 新的
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：仪表板
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来～
- 不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 主机群组模板
- 主机维护动作关联项事件
- 自动发现
- 服务
- 曾老湿
- 动作
- 动作操作恢复操作确认操作
- 默认操作步骤持续时间
- 1h
- 默认标题故障（TRIGGER.STATUS)，服务器：(HOSTNAME1)发生：{TRIGGER.NAME}故障！
- 消息内容
- 告警地址：(HOSTIP}
- 告警主机：(HOSTNAME1)
- 告警时间：(EVENT.DATE){EVENT.TIME)
- 维护期间暂停操作
- 操作步骤细节
- 开始于持续时间动作
- 于当前主机上执行远程命令
- 立即地60
- 编辑移除
- 2
- 发送消息给用户：Admin（ZabbixAdministrator）通过QQ邮箱00:01:0060
- 发送消息给用户群组：Zabbixadministrators通过QQ邮箱
- 新的
- 更新
- 克隆
- 删除
- 取消
- Dri曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：动作的配置
- Z曾老湿：配置触发器
- 故障PROBLEM，服务器：web01发×
- 别离开我啊，小老弟，点回来~
- 不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- 7
- 主机群组
- 模板
- 主机维护动作
- 关联项事件
- 自动发现
- 服务
- 曾老
- 动作
- 动作操作
- 恢复操作确认操作
- 消息内容告警地址：(HOST.IP}
- 告警主机：(HOSTNAME1)
- 告警时间：(EVENT.DATE){EVENT.TIME)
- 操作
- 细节
- 操作细节
- 操作类型
- 发送消息
- 发送到用户群组
- 用户群组
- Zabbix administrators
- 移除
- 添加
- 发送到用户
- 用户
- Admin (Zabbix Administrator)
- 仅送到
- QQ邮箱
- 消息内容
- 添加取消
- 取消
- Dri增e老湿ng
- Zabbix3.4.15.2001-2018,ZabbixSIA
<!-- OCR_END -->

￼

---

| 配置sudo |
| --- |

因为远程执行命令需要通过zabbix用户来执行，因为启动zabbix-server的用户是zabbix，所以我们必须给zabbix添加sudo权限，否则无法执行，并且要无密码。

```plain
#添加sudo权限
[root@web01 zabbix_agentd.d]# visudo
%zabbix ALL=(ALL)       NOPASSWD:ALL
#测试启动服务
[root@web01 zabbix_agentd.d]# usermod zabbix -s /bin/bash
[root@web01 zabbix_agentd.d]# su - zabbix
-bash-4.2$ sudo systemctl start sshd
```

---

| zabbix开启远程执行命令 |
| --- |

```plain
#修改配置文件
[root@web01 zabbix_agentd.d]# vim /etc/zabbix/zabbix_agentd.conf
EnableRemoteCommands=1
#重启zabbix
[root@web01 zabbix_agentd.d]# systemctl restart zabbix-agent
```

---

| 停止sshd服务测试 |
| --- |

```plain
[root@web01 zabbix_agentd.d]# systemctl stop sshd
```

<!-- OCR_START -->
- 曾老湿：仪表板
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- 不安全|10.0.0.8/zabbix/zabbix.php?action=dashboard.view&ddreset=1
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录
- 报表配置管理
- ZShare
- 7
- 仪表板
- 问题
- 概览
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- Dashboard
- 编辑仪表盘目
- 添加仪表盘/Dashboard
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 9 0 6
- 未添加数据图
- 未添加聚合图形
- 未添加拓扑图
- 主机群组
- 正常设备
- 异常设备
- 合计
- web_group
- 1
- 已更新：18:30:50
- 时间
- 恢复时间
- 状态
- 信息
- 主机
- 问题·严重性
- 持续时间
- 确认
- 动作
- 18:30:41
- 18:30:44
- 已解决
- webo1
- Listen SSHPort Problem挂了（0）
- 3s
- 完成4
- 系统状态
- 18:27:11
- 18:30:29
- 3m18s
- 步骤
- 用户
- 细节
- 警告
- 未分类
- 18:24:56
- 18:26:50
- web01
- 1m54s
- 恢复
- 18:19:05
- 18:24:02
- 4m57s
- 2019-10-2418:30:46
- QQ邮箱
- 已送达
- 18:16:08
- 18:18:56
- 2m48s
- Admin(ZabbixAdministrator)
- 18:09:35
- 18:15:53
- 6m18s
- 18:07:17
- 18:09:23
- 2m6s
- 2019-10-2418:30:43Admin（ZabixAdministrator)QQ邮箱
- 18:05:17
- 18:07:02
- 1m45s
- 2019-10-2418:30:43
- 远程命令已执行
- Listen SHPortProblem挂了（(）
- 16:44:23
- 18:04:23
- 1h20m
- 完成2
- Zabbix状态
- 9of9问题显示已更新：18:30:50
- 参数
- Zabbix服务器端运行中
- 自动发现状态
- localhost:10051
- Dri曾e老湿则
<!-- OCR_END -->

￼

## zabbix报警升级机制
场景一：在企业中，我们需要把报警设置为升级机制，当有些报警，运维人员没有及时处理的时候，或者没有时间，或者外出，或者陪产在医院，或者...总之身边没有电脑没有网络，在山沟子里的时候，必须有人站出来，解决这个问题。

场景二：当zabbix报警服务器出现问题的时候，例如MySQL挂了，运维人员在厕...没有及时处理，那一分钟后这个警告肯定要升级，从警告变成严重故障之类的。

所以不管在哪种场景下，我们要有不同的报警人员，比如，一级报警，交给运维，没有及时处理就二级报警，交给运维总监或者运维经理，如果此时报警还没有人处理，那么报警就会升级到CTO或者CEO那里，那么这个时候，也是灾难降临之时，这也是一个很好的对运维人员必须要及时处理告警的一个制约。

---

| 创建用户组 |
| --- |

<!-- OCR_START -->
- 曾老湿：配置用户组
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- 不安全| 10.0.0.8/zabbix/userg
- 应用 zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 一般agent代理程序认证
- 用户群组用户报警媒介类型
- 脚本队列
- 曾老湿
- 用户群组
- 创建用户群组
- 过滤器
- 名称
- 状态
- 任何
- 已启用停用的
- 应用
- 重设
- 成员
- 前端访问
- 调试模式
- Disabled
- 用户
- 系统默认
- 停用的
- Enabled debug mode
- 已启用
- Guests
- 用户1
- guest
- No access to thefi
- Zabbixadmi
- 显示已自动发现的5中的5
- 0选择
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户组
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- A不安全|10.0.0.8/zabbix/usergrps.php?form=创建用户群组
- I 应用 zabbix-api
- ZABBIX
- 监测中 资产记录 报表  配置  管理
- ZShare
- 一般agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 用户群组
- 权限
- 组名
- 运维组
- 用户在群组之中
- 其它群组所有
- 前端访问系统默认
- 已启用
- 调试模式
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置用户组
- Z曾老湿：动作的配置
- 收到1封新邮件
- 别离开我啊，小老弟，点回来~
- C不安全|10.0.0.8/zabbix/usergrps.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 一般
- agent代理程序认证用户群组用户报警媒介类型
- 脚本队列
- 曾老湿
- 用户群组
- 权限
- 权限主机群组
- 所有组
- 读写
- 在此输入搜索
- 选择
- 拒绝
- 包括子组
- 添加
- 更新
- 删除取消
- Dri曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户组
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- A不安全|10.0.0.8/zabbix/usergrps.php?form=创建用户群组
- l应用 zabbix-api
- ZABBIX
- 监测中资产记录报表配置
- 管理
- ZShare
- 一般
- agent代理程序
- 用户群组
- 用户
- 报警媒介类型
- 脚本
- 队列
- 曾老湿
- 权限
- 组名运维经理组
- 用户 在.群组之中
- 其它群组所有
- 前端访问系统默认
- 已启用
- 调试模式
- 取消
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户组
- 曾老湿：动作的配置
- 收到1封新邮件
- 别离开我啊，小老弟，点回来～
- C不安全|10.0.0.8/zabbix/usergrps.php
- 9
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 一般
- agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 用户群组
- 用户群组权限
- 权限
- 主机群组
- 所有组
- 读写
- 在此输入搜索
- 选择
- 拒绝
- 包括子组
- 添加
- Dr曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户组
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊,小老弟,点回来~
- A不安全|10.0.0.8/zabbix/user
- ergrps.php?form=创建用户群组
- I 应用 zabbix-api
- ZABBIX
- 监测中 资产记录 报表 配置 管理
- Share
- 一般agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 用户群组
- 权限
- 组名
- 运维总监组
- 用户在群组之中
- 其它群组所有
- dmin(ZabbixAdministrator)
- 前端访问系统默认
- 已启用
- 调试模式
- 添加
- 取消
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置用户组
- 曾老湿：动作的配置
- 收到1封新邮件
- 别离开我啊，小老弟，点回来~
- →C不安全|10.0.0.8/zabbix/usergrps.php
- 应用zabbi-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 一般
- agent代理程序
- 认证用户群组用户
- 报警媒介类型
- 脚本
- 队列
- 曾老湿
- 用户群组
- 用户群组权限
- 权限主机群组
- 权限
- 所有组
- 读写
- 在此输入搜索
- 选择
- 包括子组
- 添加
- 更新
- 删除
- r增e老湿ng
<!-- OCR_END -->

￼

---

| 创建用户 |
| --- |

<!-- OCR_START -->
- Z曾老湿：配置用户
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- ① 不安全| 10.0.0.8/zabbix/users.php?ddreset=1
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- αShare？
- 一般agent代理程序认证用户群组用户报警媒介类型
- 脚本队列
- 曾老湿
- 用户
- 用户群组所有
- 创建用户
- 过滤器
- 别名
- 名称
- 姓氏
- 用户类型任何用户管理员超级管理员
- 应用重设
- 用户名第一部分
- 用户类型
- 群组
- 是否在线？
- 登录
- 前端访问
- 调试模式
- 状态
- Admin
- Administrator
- 超级管理员
- Zabbix administrators运维组
- 是(2019-10-25 09:29:57)
- 正常
- 系统默认
- 停用的
- 已启用
- guest
- Guests
- 不(2019-10-24 11:52:22)
- 显示已自动发现的2中的2
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置用户
- Z曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- rgrpid=0&form=创建用户
- 应用 zabbix-api
- ZABBIX
- 监测中 资产记录报表 配置  管理
- 一般agent代理程序认证用户群组用户报警媒介类型
- 脚本队列
- 曾老湿
- 用户
- 别名邱老师
- 用户名第一部分qls
- 姓氏邱
- 群组
- 运维组×
- 在此输入搜索
- 密码
- ..
- 密码（再次确认）
- 语言英语(en_GB)
- 主题系统默认
- 自动登录
- 自动注销15m
- 刷新30s
- 每页行数
- 50
- URL(登录后)
- 取消
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置用户
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- ①不安全| 10.0.0.8/zabbix/users.php
- 8
- 应用
- zabbix-api
- ZABBIX
- 监测中 资产记录 报表  配置 管理
- Share
- 一般agent代理程序认证用户群组用户 报警媒介类型
- 脚本队列
- 曾老湿
- 用户
- 报警媒介
- 权限
- 类型
- 收件人
- 当启用时
- 如果存在严重性则使用
- Status动作
- Jabber
- 123@q.com
- 1-7,00:00-24:00
- 未信警一严灾
- 已启用编辑 移除
- 添加
- 添加取消
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- A不安全|10.0.0.8/zabbix/users.php?ilter_usrgrpid=0&form=创建用户
- 应用 zabbix-api
- ZABBIX
- 监测中
- 资产记录
- 报表配置
- 管理
- Share
- 一般agent代理程序认证 用户群组 用户 报警媒介类型
- 脚本队列
- 曾老湿
- 用户
- 报警媒介权限
- 别名曾老湿
- 用户名第一部分zls
- 姓氏曾
- 群组
- 运维总监组×
- 选择
- 在此输入搜索
- 密码
- 密码（再次确认）
- 语言英语（en_GB)
- 主题系统默认
- 自动登录
- 自动注销
- 15m
- 刷新30s
- 每页行数
- 50
- URL(登录后)
- 添加
- 取消
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- C① 不安全 | 10.0.0.8/zabbix/users.php
- 应用 zabbix-api
- ZABBIX
- 监测中 资产记录 报表配置管理
- ZShare
- 一般agent代理程序认证用户群组用户报警媒介类型
- 脚本队列
- 曾老湿
- 用户
- 报警媒介权限
- 报警媒介类型
- 收件人
- 当启用时
- 如果存在严重性则使用
- Status动作
- QQ邮箱13311023@q.com
- 1-7,00:00-24:00未信警一严灾
- 已启用编辑移除
- 添加
- 取消
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- A 不安全| 10.0.0.8/zabbix/users.php?filter_usrgrpid=0&form=创建用户
- 应用  zabbix-api
- ZABBIX
- 监测中
- 资产记录报表配置
- 管理
- 一般agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 用户
- 报警媒介权限
- 别名苍老师
- 用户名第一部分cls
- 姓氏苍
- 群组
- 运维经理组×
- 选择
- 在此输入搜索
- 密码
- ..
- 密码(再次确认)
- 语言英语（en_GB)
- 主题系统默认
- 自动登录
- 自动注销15m
- 刷新30s
- 每页行数
- 50
- URL(登录后）
- 添加
- 取消
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：配置用户
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- ①不安全| 10.0.0.8/zabbix/users.php
- 应用 zabbix-api
- ZABBIX
- 监测中 资产记录报表配置管理
- αShare？
- 一般
- agent代理程序认证用户群组用户
- 报警媒介类型
- 脚本队列
- 曾老湿
- 用户
- 报警媒介
- 权限
- 收件人
- 当启用时
- 如果存在严重性则使用
- Status动作
- QQ邮箱456@qq.com
- 1-7,00:00-24:00
- 未信警一严灾
- 已启用编辑移除
- 添加
- 取消
- DriverZeng
<!-- OCR_END -->

￼

---

| 设置报警升级动作 |
| --- |

<!-- OCR_START -->
- Z曾老湿：动作的配置
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 主机群组模板主机维护动作关联项事件自动发现服务
- 曾老湿
- 动作
- 事件源触发器创建动作
- 过滤器
- 名称
- 状态
- 任何
- 已启用停用的
- 应用
- 重设
- 条件
- 操作
- Report problems to Zabbix administrators
- 发送消息给用户：Admin（Zzabbix Administrator）通过QQ邮箱
- 已启用
- 发送消息给用户群组：Zabbixadministrators通过QQ邮箱
- SSH自愈（你懂我意思吧）
- 触发器= web01:Listen SSH Port Problem ojbk(1)
- 于当前主机上执行远程命令
- 发送消息给用户：Admin（ZabbixAdministrator）通过QQ邮箱
- 显示已自动发现的2中的2
- 0选择
- 启用
- 禁用
- 删除
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- →C不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- 动作
- 操作
- 恢复操作确认操作
- 默认操作步骤持续时间1h
- 默认标题
- 故障{TRIGGER.STATUS)，服务器：（(HOSTNAME1)发生：TRIGGER.NAME}故障！
- 消息内容
- 告警地址：（(HOSTIP)
- 告警主机：（HOSTNAME1)
- 告警时间：(EVENT.DATE)（EVENT.TIME}
- 维护期间暂停操作
- 步骤
- 细节
- 开始于
- 持续时间
- 操作细节
- 1
- 2（0-无穷大）
- 步骤持续时间
- 5m
- （0-使用默认）
- 操作类型发送消息
- 发送到用户群组
- 用户群组
- 运维组
- 移除
- 添加
- 发送到用户
- 用户
- 仅送到QQ邮箱
- 条件
- 标签
- 名称
- 新的
- 添加取消
- 曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- 不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- 动作操作恢复操作确认操作
- 默认操作步骤持续时间1h
- 默认标题故障（TRIGGER.STATUS)，服务器：（HOSTNAME1)发生：{TRIGGER.NAME}故障！
- 消息内容告警地址：（HOST.IP}
- 告警主机：（HOSTNAME1)
- 告警时间：(EVENT.DATE}（EVENT.TIME}
- 维护期间暂停操作
- 操作
- 步骤细节
- 开始于持续时间动作
- 1-2
- 发送消息给用户群组：运维组通过QQ邮箱
- 立即地5m
- 编辑移除
- 操作细节
- 步骤
- 3-
- 4（0-无穷大）
- 步骤持续时间
- 5m
- （0-使用默认）
- 操作类型
- 发送消息
- 发送到用户群组
- 用户群组
- 动作
- 运维经理组
- 移除
- 添加
- 发送到用户
- 用户
- 仅送到QQ邮箱
- 消息内容
- 条件标签
- 名称
- 新的
- 更新取消
- r曾老湿ng
- 更新
- 克隆
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来~
- →Q
- A不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- 默认操作步骤持续时间1h
- 默认标题故障（TRIGGER.STATUS)，服务器：[HOSTNAME1)发生：{TRIGGER.NAME}故障！
- 消息内容
- 告警地址：(HOSTIP)
- 告警主机：[HOSTNAME1}
- 告警时间：(EVENT.DATE){EVENT.TIME}
- 维护期间暂停操作
- 操作步骤细节
- 开始于
- 持续时间动作
- 1-2发送消息给用户群组：运维组通过QQ邮箱
- 立即地
- 5m
- 编辑移除
- 3-4发送消息给用户群组：运维经理组通过QQ邮箱
- 00:10:005m
- 操作细节
- 步骤
- 4-
- 5（0-无穷大）
- 步骤持续时间
- （0-使用默认）
- 操作类型
- 发送消息
- 发送到用户群组
- 用户群组
- 动作
- 运维总监组
- 移除
- 添加
- 发送到用户
- 用户
- 仅送到
- QQ邮箱
- 条件标签
- 名称
- 新的
- 添加取消
- 增老湿ng
- 更新
- 取消
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Z曾老湿：动作的配置
- 曾老湿：动作的配置
- 收到2封新邮件
- 别离开我啊，小老弟，点回来～
- 不安全|10.0.0.8/zabbix/actionconf.php
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 主机群组模板
- 自动发现
- 服务
- 曾老湿
- 动作
- 动作操作恢复操作确认操作
- 默认操作步骤持续时间
- 1h
- 默认标题
- 消息内容
- 告警地址：(HOST.IP}
- 告警主机：(HOSTNAME1)
- 告警时间：(EVENT.DATE){EVENT.TIME}
- 维护期间暂停操作
- 操作步骤细节
- 开始于
- 持续时间动作
- 1-2发送消息给用户群组：运维组通过QQ邮箱
- 立即地
- 5m
- 编辑移除
- 3-4发送消息给用户群组：运维经理组通过QQ邮箱
- 00:10:005m
- 4-5发送消息给用户群组：运维总监组通过QQ邮箱
- 00:15:005m
- 新的
- 更新
- 克隆删除取消
- Dri曾老湿ng
<!-- OCR_END -->

￼

---

> 计算方式：
>
> 1)开始于 ，这个是相对一但触发监控，则立即发送消息
>
> 2)1-2步骤是给运维组发送消息，每隔5分钟发送一次，总共2个步骤，所以发送2次
>
> 3)3-4步骤是给运维经理组发送消息，每隔5分钟发送一次，总共2个步骤，所以发送2次
>
> 4)4-5步骤是给运维总监组发送消息，每隔5分钟发送一次，总共2个步骤，所以发送2次
>
> 5)每次的开始时间是如何计算的呢，第一个立即开始：
>
> 1-2，3-4，4-5动作时间间隔是5分钟，所以在触发告警发送时间计算是5m+5m+5m=15m
>

<!-- OCR_START -->
- Z曾老湿：仪表板
- Z曾老湿：动作的配置
- 收到1封新邮件
- 别离开我啊，小老弟，点回来~
- ←→C
- 不安全|10.0.0.8/zabbix/zabbix.php?action=dashboard.view&ddreset=1
- 8
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QShare
- 仪表板问题
- 概览
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- Dashboard
- 编辑仪表盘
- 添加仪表盘/Dashboard
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 未添加数据图
- 未添加聚合图形
- 未添加拓扑图
- 主机群组
- 正常设备
- 异常设备
- 合计
- web_group
- 1
- 已更新：10:13:53
- 问题
- 时间
- 恢复时间状态
- 信息
- 主机
- 问题·严重性
- 持续时间
- 确认
- 动作
- 10:11:22
- web01
- Monitor LoginUserCountProblem主机名：web01IP地
- 2m31s
- 完成4
- 系统状态
- 址：10.0.0.7
- 10:05:13
- 10:11:10
- 5m57s
- 步骤
- 用户
- 细节
- 状态
- 警告
- 未分类
- Listen SSHPort Problem挂了（0）
- 10:03:44
- 10:03:47
- 2019-10-25 10:11:24
- 邱老师（qls邱）QQ邮箱
- 已送达
- 2019-10-2510:12:24
- 苍老师（cls苍）QQ邮箱已送达
- 2019-10-2510:13:24
- 曾老湿（zls曾）
- QQ邮箱
- 苍老师（cls苍）
- Zabbix状态
- 3of3问题显示已更新：10:13:53
- 参数
- 自动发现状态
- Zabbix服务器端运行中
- localhost:10051
<!-- OCR_END -->

￼

## zabbix自定义图形
---

| 创建图形 |
| --- |

介绍监控的顺序->应⽤级->监控项->基于监控项创建触发器->基于监控项创建图形

<!-- OCR_START -->
- ZABBIX
- 监测中
- 资产记录
- 报表
- 配置
- 管理
- Zshare
- 2
- 主机群组
- 模板
- 主机
- 维护
- 动作
- 关联项事件
- 自动发现
- 服务
- 老男孩教育
- 图形
- 群组所有
- 主机Web03-10.0.0.30
- 创建图形
- 所有主机/Web03-10.0.0.30
- 已启用
- ZBX SNMP JMX IPMI
- 应用集10
- 监控项46
- 触发器20
- 图形8
- 自动发现规则2
- Web场景
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| 基于监控项进行绘图 |
| --- |

<!-- OCR_START -->
- ZABBIX
- 监测中
- 资产记录
- 报表
- 配置
- 管理
- ZShare
- 主机群组
- 模板
- 主机
- 维护
- 动作
- 关联项事件
- 自动发现
- 服务
- 老男孩教育
- 图形
- 所有主机/Web03-10.0.0.30
- 已启用 ZBX SNMPJMX IPMI
- 应用集10监控项46
- 触发器20图形8
- 自动发现规则2Web场景
- 预览
- 名称
- CPU
- 900
- 200
- 图形类别
- 正常
- 监控项
- 功能
- 绘图风格
- 纵轴Y侧
- 颜色
- 1:Web03-10.0.0.30: CPU idle time
- 1A7C11
- 移除
- 左侧
- 2:Web03-10.0.0.30: CPU interrupt time
- F63100
- 3:Web03-10.0.0.30: CPU iowait time
- 2774A4
- 4:Web03-10.0.0.30: CPU nice time
- A54F10
- 5:Web03-10.0.0.30:CPU softirq time
- 平均
- FC6EA3
- 6:Web03-10.0.0.30:CPU steal time
- 6C59DC
- 7:Web03-10.0.0.30: CPU system time
- AC8C14
- 8:Web03-10.0.0.30:CPU user time
- 611F27
- 添加
- 取消
- 曾老湿
<!-- OCR_END -->

￼

---

| 聚合图形 |
| --- |

将多张图形整合为一张图形, 简称聚合图形

企业真实聚合图形，情况（昊达老师公司）



<!-- OCR_START -->
> 曾老湿
> DriverZeng
<!-- OCR_END -->

￼

注意，在这里，聚合图形，我们可以分为以下几类，主要还是看公司的需求

> 例如：
>
> 1.按项目聚合（王者荣耀，LOL，天涯明月刀...）
>
> 2.按主机聚合（每台主机的聚合...）
>
> 3.按应用聚合（所有nginx的监控，所有MySQL的监控...）
>

<!-- OCR_START -->
- 所有聚合图形/基础监控
- 过滤器
- Web03-10.0.0.30:CPU (1h)
- 100%
- Web03-10.0.0.30:Networktrafficonens33(1h)
- 150Kbps
- 50%
- 100Kbps
- 0%
- 50Kbps
- 5
- 4
- 3
- obps
- 2
- cPUidle time
- [00]
- 83.1 %
- 97.07%
- 98.44%
- CPUinterrupttime
- [0D]
- 8
- cPuiowaittime
- 0.05%
- 0.02 %
- CPUnicetime
- 【O0]
- Incomingnetworktrafficonens33
- 9.05Kbps
- 16bps
- 2.11Kbps
- 9.05Kbp
- CPUsoftirqtime
- 0.2 %
- 0.04 %
- outgoingnetwork trafficon ens33
- 118.81Kbps
- 24bps
- 12.44Kbps
- CPUstealtime
- CPUsystemtime
- 3.28%
- 0.65%
- 0.96 %
- cPUusertime
- [OD]
- 13.34%
- 0.84 %
- 1.85%
- Web03-10.0.0.30:Memory usage(1h)
- 974.6MB
- 512.0MB
- Web03-10.0.0.30:Diskspaceusage/(1h)
- OB
- 12
- Availablememory
- [口]
- 504.38MB499.05MB501.67MB
- 504.38MB
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| 幻灯片 |
| --- |

多张聚合图形可以整合为幻灯⽚

<!-- OCR_START -->
- ZABBIX
- 监测中
- 资产记录
- 报表
- 配置
- 管理
- ZShare
- 仪表板
- 问题
- 概览
- Web监测
- 最新数据
- 触发器
- 图形
- 聚合图形
- 拓扑图
- 自动发现
- 服务
- 老男孩教育
- 幻灯片演示
- 创建幻灯片播放
- 过滤器
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- ZABBIX
- 监测中
- 资产记录报表
- 配置
- 管理
- ZShare
- 仪表板
- 问题
- 概览
- Web监测
- 最新数据
- 触发器
- 图形
- 聚合图形
- 拓扑图
- 自动发现
- 服务
- 老男孩教育
- 幻灯片演示
- 幻灯片
- 分享
- 所有者
- Admin (Zabbix Administrator) x
- 选择
- 名称
- 默认延迟
- 10s
- 延迟
- 动作
- 1:Zabbix server
- 默认的
- 移除
- 2:基础监控
- 添加
- 更新
- 克隆
- 删除
- 取消
- 曾老湿
<!-- OCR_END -->

￼

## 自定义图形🌲[扩展]
---

| 安装和配置 |
| --- |

```plain
#1.安装graphtree
cd /usr/share/zabbix
wget https://raw.githubusercontent.com/OneOaaS/graphtrees/master/graphtree3.0.4.patch
#2.导⼊入补丁包
yum install -y patch
patch -Np0 <graphtree3.0.4.patch 
chown -R apache.apache oneoaas
#3.修改Apache配置⽂文件
vim /etc/httpd/conf.d/zabbix.conf 
Alias /oneoaas /usr/share/zabbix/oneoaas
#4.重启httpd服务 
systemctl restart httpd
单击->监测中->Graphtree
单击对应的主机->选择需要查看的图形->点击查询->效果展示
```

<!-- OCR_START -->
- 曾老湿：仪表板
- →C ① 不安全 | 10.0.0.8/zabbix/zabbix.php?action=dashboard.view
- 应用
- zabbix-api
- ZABBIX监测中资产记录报表配置管理
- ZShare
- 仪表板 问题概览
- Web监测最新数据触发器图形Graphtree聚合图形拓扑图 自动发现服务
- 曾老湿
- Dashboard
- 编辑仪表盘目
- 添加仪表盘/Dashboard
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 未添加数据图
- 未添加聚合图形.
- 未添加拓扑图.
- 主机群组
- 正常设备
- 异常设备
- 合计
- web_group
- 1
- 已更新：13:31:37
- 问题
- 时间
- 恢复时间
- 状态
- 信息主机
- 问题·严重性
- 持续时间
- 确认
- 动作
- 12:24:40
- web01
- m主机名：web01IP地址：10.0.0.7
- 1h6m57s
- 失败2
- 系统状态
- 灾难
- 严重
- 一般严重
- 警告
- 信息
- 未分类
- Zabbix状态
- 1of1间题显示已更新：13:31:37
- 参数
- 细节
- Zabbix服务器端运行中
- localhost:10051
- Web监测
- 自动发现状态
- 主机数量 (已启用/已禁用/模板)
- 78
- 1/1/76
- 正常
- 已失败
- 未知的
- 自动发现规则
- 监控项数量（已启用/已禁用/不支持）
- 119
- 50/69/0
- 未发现数据
- 触发器数量（已启用/已禁用[间题/正常]）
- 68
- 22/46[1 /21]
- 用户数（线上)
- 6
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 图形展示
- 别离开我啊，小老弟，点回来~
- ①不安全| 10.0.0.8/zabbix/one
- s/graphtree.php?ddreset=1
- 应用
- zabbix-api
- ONEOAAS
- Graphtree
- 返回Dashboard
- web_group(1)
- 开始时间
- 结束时间
- 2019-10-27 12:32
- 2019-10-27 13:32
- 请选择分组或输入查询条件
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 图形展示
- 别离开我啊，小老弟，点回来
- ①不安全| 10.0.0.8/zabbix/o
- 应用
- ONEOAAS
- Graphtree
- 返回Dashboard
- web_group(1)
- 开始时间
- 结束时间
- 白web01（11)
- 2019-10-27 12:32
- 2019-10-27 13:32
- DCPU
- Filesystems
- General
- Memory
- Networkinterfaces
- PrevNext共3项
- os
- Performance
- Processes
- Security
- 220
- SystemDIY
- Zabbix agent
- 210
- 200
- 190
- 180
- 6
- d g min average per cor8
- 0.01
- webol:CPU utilization (1h)
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

## Zabbix⾃定义监控模板
> 1.模板是⽀支持导⼊入与导出(模板⾥里里⾯面的监控项是有脚本⽀支撑，所以脚本需⼀一起打包)
>
> 2.conf⽂文件主要⽤用于定义监控项，监控项⽤用来调⽤用脚本或命令，获取监控值。
>
> 3.如果希望将之前定义的监控项做成模板，找到监控项->全选->复制
>
> 4.自定义使⽤用模板(让监控项可以重复使⽤用)
>
> 5.客户端agent必须要定义监控项，监控项取值需要使⽤用到脚本⽂文件或系统命令
>
> 6.服务端导⼊入模板
>
> 7.创建监控主机，链接新导⼊入模板，如果是已存在的监控主机，增加我们刚导⼊入的模板
>

## zabbix企业微信报警（扩展）
---

| 准备微信报警脚本, 脚本怎么写->脚本放在哪 |
| --- |

```plain
[root@ZabbixServer ~]# yum install python-pip -y
[root@ZabbixServer ~]# pip install requests
[root@ZabbixServer ~]# cd /usr/lib/zabbix/alertscripts
[root@ZabbixServer alertscripts]# rz weixin.py
[root@ZabbixServer alertscripts]# chmod +x weixin.py
[root@ZabbixServer alertscripts]# ./weixin.py test_zls_weixin
```

具体微信报警脚本内容，请见[http://class.driverzeng.com](http://class.driverzeng.com) 只针对内部学员。

---

| 单击管理理->报警媒介类型->创建媒介类型 |
| --- |

<!-- OCR_START -->
- Z曾老湿：配置媒体类型
- 曾老湿：仪表板
- 别离开我啊，小老弟，点回来～
- 故障PROBLEM，服务器：web01发X
- 不安全|10.0.0.8/zabbix/zabbix.php?action=mediatype.list&ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置
- 管理
- ZShare
- 一般
- agent代理程序
- 认证用户群组
- 用户
- 报警媒介类型
- 脚本
- 队列
- 曾老湿
- 创建媒体类型
- 过滤器
- 名称
- 状态
- 任何已启用停用的
- 重设
- 类型
- 用于动作中
- 细节
- Jabber
- 已启用
- Jabber标识符：jabber@company.com
- QQ邮箱
- 电子邮件
- SSH自愈（你懂我意思吧）
- SMTP服务器："smtp.qq.com"，SMTPHELO:“qq.com"SMTP电邮：“253097001@qq.c
- 曾老湿nS
- 短信
- GSM调制解调器："/dev/ttySO"
<!-- OCR_END -->

￼

---

| 填写微信报警名称，以及脚本需要传⼊入的参数，内容如下 |
| --- |

<!-- OCR_START -->
- Z曾老湿：配置媒体类型
- 曾老湿：仪表板
- 别离开我啊，小老弟，点回来~
- 故障PROBLEM，服务器：web01发X
- <→C不安全|10.0.0.8/zabbix/zabbix.php?action=mediatype.edit
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 一般
- agent代理程序认证用户群组用户报警媒介类型脚本队列
- 曾老湿
- 报警媒介类型
- 选项
- 名称企业微信报警
- 类型脚本
- 脚本名称weixin.py
- 脚本参数
- 参数
- 动作
- (ALERT.MESSAGE)
- 移除
- 添加
- 已启用
- 取消
- Dri增e老湿ng
<!-- OCR_END -->

￼

```plain
{ALERT.MESSAGE} #发送的内容
```

---

| 配置接收的企业微信号 |
| --- |

单击⽤用户->报警媒介->添加->按如下填写

<!-- OCR_START -->
- 曾老湿：配置用户
- 曾老湿：仪表板
- 别离开我啊，小老弟，点回来~
- 故障PROBLEM，服务器：WebO1发X
- 不安全|10.0.0.8/zabbix/users.php?form=update&userid=4
- 应用zabbix-api
- ZABBIX
- 监测中资产记录
- 报表
- 配置
- 管理
- Share
- agent代理程序
- 认证
- 用户群组
- 用户
- 报警媒介类型
- 脚本
- 队列
- 曾老湿
- 曾老湿：报警媒介
- 不安全|10.0.0.8/zabbix/popup_media.php?dstfrm=userForm&media=0&mediatypeid=4&sendto=%2A&period=1-7,00:00-24:00&severity=63&.
- 报警媒介
- 汉限
- 类型
- 企业微信报警
- 收件人
- 当启用时1-7.00:00-24:00
- 如果存在严重性则使用未分类
- 信息
- 警告
- 一般严重
- 严重
- 灾难
- 已启用
- 更新
- 取消
- Dri曾e老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：配置用户
- 曾老湿：仪表板
- 别离开我啊，小老弟，点回来~
- 故障PROBLEM，服务器：Web01发×
- →C不安全|10.0.0.8/zabbix/users.php
- 8
- 应用
- zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- ZShare
- 一般
- agent代理程序认证用户群组用户 报警媒介类型
- 脚本
- 队列
- 曾老湿
- 用户
- 报警媒介
- 权限
- 报警媒介类型
- 收件人当启用时
- 如果存在严重性则使用
- Status
- 动作
- 企业微信报警
- 1-7,00:00-24:00
- 未信警一严灾
- 已启用编辑移除
- 添加
- 更新
- 删除
- 取消
- 曾老湿D
<!-- OCR_END -->

￼

---

| 动作配置 |
| --- |

<!-- OCR_START -->
- 动作
- 动作操作恢复操作确认操作
- 默认操作步骤持续时间1h
- 默认标题
- 消息内容
- 告警地址：(HOST.IP)
- 告警主机：(HOSTNAME1)
- 告警时间：EVENT.DATE){EVENT.TIME）
- 维护期间暂停操作
- 操作步骤细节
- 开始于持续时间动作
- 1
- 发送消息给用户：曾老湿（zls曾）通过企业微信报警
- 立即地默认
- 编辑移除
- 发送消息给用户群组：运维总监组通过企业微信报警
- 操作细节
- 步骤
- 1（0-无穷大）
- 步骤持续时间
- （0-使用默认）
- 操作类型发送消息
- 发送到用户群组用户群组
- 运维总监组
- 移除
- 添加
- 发送到用户
- 用户
- 曾老湿（zls曾）
- 仅送到企业微信报警
- 条件标签
- 名称
- 曾老湿ng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 曾老湿：动作的配置
- 曾老湿：仪表板
- 别离开我啊，小老弟，点回来～
- 故障PROBLEM，服务器：web01发×
- 不安全|10.0.0.8/zabbix/actionconf.php
- 8
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- Share
- 主机群组模板主机维护动作关联项事件
- 自动发现服务
- 曾老湿
- 动作
- 动作操作
- 恢复操作确认操作
- 默认标题恢复{TRIGGER.STATUS），服务器：（HOSTNAME1)：{TRIGGER.NAME}已恢复！
- 消息内容
- 告警地址：(HOST.IP)
- 告警主机：（HOSTNAME1）
- 告警时间：(EVENT.DATE}(EVENT.TIME}
- 操作细节
- 操作类型发送消息
- 发送到用户群组
- 用户群组
- 运维总监组
- 移除
- 添加
- 发送到用户
- 用户
- 曾老湿（zls曾）
- 仅送到
- 企业微信报警
- 添加取消
- 更新
- 克隆
- 删除
- 取消
- r曾老湿ng
<!-- OCR_END -->

￼

---

| 测试企业微信报警 |
| --- |

<!-- OCR_START -->
- Z曾老湿：仪表板
- 曾老湿：仪表板
- 别离开我啊，小老弟，点回来～
- 故障PROBLEM，服务器：web01发X
- ←→C
- 不安全|10.0.0.8/zabbix/zabbix.php?action=dashboard.view&ddreset=1
- 应用zabbix-api
- ZABBIX
- 监测中资产记录报表配置管理
- QZShare
- 仪表板问题概览
- Web监测最新数据触发器图形聚合图形拓扑图自动发现服务
- 曾老湿
- 编辑仪表盘
- Dashboard
- 添加仪表盘/Dashboard
- 常用的图形
- 常用的聚合图形
- 常用的拓扑图
- 主机状态
- 问题在web01
- 未添加数据图
- 未添加聚合图形
- 未添加拓扑图
- 主机群组
- 正常设备
- 异常设备
- MonitorLoginUserCountProblem主机
- 名：web01IP地址：10.0.0.7
- web_group
- 2019-10-25-11.35.22
- 已更新：11:55:27
- 问题
- 时间
- 恢复时间
- 状态
- 信息
- 主机
- 问题·严重性
- 持续时间
- 确认
- 动作
- 11:55:22
- webo
- Monitor LoginUserCountProblem主机名：web01IP地
- 完成1
- 系统状态
- 址：10.0.0.7
- 11:42:49
- 11:55:07
- 已解
- web01
- 12m18s
- 完成
- 步骤
- 用户
- 细节
- 警告
- 未分类
- 11:42:37
- 11:40:46
- 1m51s
- 失见
- 2019-10-2511:55:25
- 曾老湿（zls曾）企业微信报警
- 已送达
- 11:37:49
- 11:40:25
- 2m36s
- 失败2
- 11:27:13
- 11:37:40
- 10m27s
- 完成2
- 11:25:43
- 11:27:04
- webo1
- 1m21s
- 11:24:25
- 11:25:28
- 1m3s
- Zabbix状态
- 7of7问题显示已更新：11:55:27
- 参数
- 自动发现状态
- Zabbix服务器端运行中
- localhost:10051
- W老测
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 三》
- 消息（1）
- Q搜索
- 微信报警接收全员
- 刚刚
- 曾老湿企业微信告警：告警地址：10.0.0.7告警主.
- 企业微信团队
- 51分钟前
- 邀请同事，领取红包
- 88
- 消息
- 通讯录
- 工作台
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- <消息
- 微信报警接收（1）
- 上午11:55
- 曾老湿企业微信告警BOT
- 告警地址：10.0.0.7
- 告警主机：web01
- 告警时间：2019.10.2511:55:22
- 告警等级：Average
- 告警信息：Monitor LoginUser
- CountProblem主机名:web01IP地
- 址：10.0.0.7
- 告警项目：user.count
- 问题详情：MonitorLoginUser
- Count:3
- 当前状态：PROBLEM:3
- 事件ID:87
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

> 更新: 2019-11-23 09:12:45  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/tv2d9a>