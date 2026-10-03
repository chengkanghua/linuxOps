# 第五章·监控系统-zabbix自动化监控

+ [Zabbix自动发现(被动)](https://www.driverzeng.com/#toc_0)
+ [Zabbix自动注册(主动)](https://www.driverzeng.com/#toc_1)
+ [Zabbix主被模式区别](https://www.driverzeng.com/#toc_2)
+ [Zabbix主被模式实践](https://www.driverzeng.com/#toc_3)

[](https://www.driverzeng.com/#toc_3)-曾老湿, 江湖人称曾老大。

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

## Zabbix自动发现(被动)
[网络发现官方手册](https://www.zabbix.com/documentation/3.4/zh/manual/discovery/network_discovery)

| 概述 |
| --- |

Zabbix提供了有效和非常灵活的网络自动发现功能。

> 当网络发现正确设置后你可以：
>
> 1.加快Zabbix部署
>
> 2.简化管理
>
> 3.无需过多管理就能在快速变化的环境中使用Zabbix
>

---

> Zabbix网络发现基于以下信息：
>
> 1.IP范围
>
> 2.可用的外部服务（FTP，SSH，WEB，POP3，IMAP，TCP等）
>
> 3.来自 zabbix agent 的信息（仅支持未加密模式）
>
> 4.来自 snmp agent 的信息
>

---

> 不支持：
>
> 1.发现网络拓扑
>

_**网络发现由两个阶段组成:发现（discovery）和动作（actions）。**_

_1.单击配置->自动发现->启动默认的Local network_

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
- 维护
- 动作
- 关联项事件
- 自动发现
- 服务
- 老男孩教育
- 发现规则已经启用
- 自动发现规则
- 创建发现规则
- 过滤器
- 名称
- IP范围
- 间隔
- 检查
- 状态
- Local network
- 192.168.0.1-254
- 1h
- Zabbix客户端
- 已启用
- 曾老湿
- 显示已自动发现的1中的1
- Dr
<!-- OCR_END -->

￼

_2.配置规则_

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
- 动作
- 关联项事件
- 自动发现
- 服务
- 老男孩教育
- 自动发现规则
- 名称
- Localnetwork
- 由agent代理程序自动发现
- 没有agent代理程序
- IP范围
- 10.0.0.1-100
- 更新间隔
- 10s
- 检查
- Zabbix客户端“system.uname”
- 编辑移除
- 新的
- 设备唯一性准则
- OIP地址
- OZabbix客户端"system.uname"
- 已启用
- 更新
- 克隆
- 删除
- 取消
- 曾老湿ng
- Or
<!-- OCR_END -->

￼

_3.单击配置->动作->事件源->自动发现->启用动作_

<!-- OCR_START -->
- ZABBIX
- 监测中
- 资产记录
- 报表
- 配置
- 管理
- Zshare
- 主机群组
- 模板
- 主机
- 维护
- 动作
- 关联项事件
- 自动发现
- 服务
- 老男孩教育
- 激活启用激活启用
- 事件源自动发现
- 创建动作
- 过滤器
- 名称
- 条件
- 操作
- 状态
- Auto discovery.Linuxservers.
- 接收到的值似Linux
- 添加到主机群组：Linuxservers
- 已启用
- 自动发现状态=上
- 链接到模板：TemplateOSLinux
- 服务类型=Zabbix客户端
- Dri曾老湿ng
- 显示已自动发现的1中的1
- Or
<!-- OCR_END -->

￼

_4.修改动作规则_

<!-- OCR_START -->
- ZABBIX
- 监测中
- 资产记录报表酉
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
- 操作
- 名称
- Autodiscovery.Linuxservers.
- 计算方式
- 与/或（默认）
- AandBandCandD
- 条件
- 标签
- 接收到的值似Linux
- 移除
- 自动发现状态=上
- 服务类型=Zabbix客户端
- 自动发现规则=Localnetwork
- 新的触发条件
- 自动发现规则
- 选择
- 添加
- 已启用
- 更新
- 克隆
- 删除
- 取消
- 曾老湿
- Or
<!-- OCR_END -->

￼

_5.修改操作细节_

> 默认标题
>
> 自动发现主机IP:{DISCOVERY.DEVICE.IPADDRESS}
>
> 消息内容
>
> 客户端名称: {DISCOVERY.SERVICE.NAME}
>
> 客户端端口: {DISCOVERY.SERVICE.PORT}
>
> 客户端状态: {DISCOVERY.SERVICE.STATUS}
>
> 操作动作
>
> 添加主机,添加主机组，链接模板，发送邮件，等等
>

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
- 操作
- 默认标题
- 自动发现主机IP：[DISCOVERY.DEVICE.IPADDRESS}
- 消息内容
- 客户端名称：{DISCOVERY.SERVICE.NAME}
- 客户端端口：{DISCOVERY.SERVICE.PORT}
- 客户端状态：{DISCOVERY.SERVICE.STATUS}
- 细节
- 发送消息给用户群组：Zabbixadministrators通过所有介质
- 编辑移除
- 添加主机
- 添加到主机群组：Linuxservers
- 链接到模板：TemplateOSLinux
- 新的
- 更新
- 克隆
- 删除
- 取消
- 曾老湿
<!-- OCR_END -->

￼

_6.主机已扫描加入节点 web03是/etc/hosts中定义的_

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
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称应用集
- 监控项
- 触发器
- 图形
- Web监测
- 接口
- 状态
- 可用性
- agent加密
- 信息
- web03
- 应用集10
- 监控项34
- 触发器15
- 图形6
- 自动发现2
- 10.0.0.30:10050
- Template OSLinux(TemplateAppZabbixAgent)
- 已启用
- ZBXSNMPJMXIPMI
- 曾老湿
- 显示已自动发现的1中的1
- Dr
<!-- OCR_END -->

￼

_7.新增一台全新的主机_

```plain
[root@web02 ~]# rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.12-1.el7.x86_64.rpm
[root@web02 ~]# grep "^Server" /etc/zabbix/zabbix_agentd.conf 
Server=10.0.0.61
[root@web02 ~]# systemctl restart zabbix-agent
```

_8.如果出现discover busy告警则需要优化_

```plain
[root@zabbix ~]# vim /etc/zabbix/zabbix_server.conf
StartDiscoverers=20
```

_9.zabbix网络发现总结_

```plain
1.网络发现速度太慢
2.轮询扫描网段
3.如果网段中存在不通的主机，会出现卡顿并且造成哦后续新增的服务器无法加入节点
4.会导致server性能变缓慢，影响server性能
```

## Zabbix自动注册(主动)
_Zabbix agent可以自动注册到服务器进行监控。这种方式无需在服务器上手动配置它们。自动注册官方手册_

_1.配置 Zabbix-Agent指定 Zabbix-Server_

```plain
[root@web03 ~]# vim /etc/zabbix/zabbix_agentd.conf
Server=172.16.1.71          #被动模式
ServerActive=172.16.1.71    #主动模式
Hostname=web03              #指定主机名
#重载服务
[root@web03 ~]# systemctl restart zabbix-agent
```

_注意： 如果不指定Hostname,则服务器将使用agent的系统主机名命名主机_

_2.单击配置->动作，选择自动注册为事件源，然后单击创建操作_

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
- 事件源自动注册
- 创建动作
- 曾老湿
- 过滤器
<!-- OCR_END -->

￼

_3.配置动作规则_

<!-- OCR_START -->
- ZABBIX
- 监测中
- 资产记录报表配置管理
- ZShare
- 主机群组
- 模板
- 主机维护
- 动作关联项事件
- 自动发现
- 服务
- 老男孩教育
- 动作
- 操作
- 名称
- 住动注册名web
- 条件
- 标签
- 主机名称似web
- 移除
- 新的触发条件
- 主机名称
- 添加
- 已启用
- 更新
- 克隆
- 删除
- 取消
- r曾老湿n
<!-- OCR_END -->

￼

_4.配置操作规则_

<!-- OCR_START -->
- ZABBIX
- 监测中
- 资产记录报表
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
- 操作
- 默认标题
- Autoregistration:{HOST.HOST}
- 消息内容
- Hostname:{HOST.HOST}
- HostIP:{HOST.IP}
- Agent port:{HOST.PORT}
- 细节
- 发送消息给用户：Admin（ZabbixAdministrator）通过Email
- 编辑移除
- 发送消息给用户群组：Zabbixadministrators通过Email
- 添加主机
- 添加到主机群组：Linuxservers
- 链接到模板：TemplateOSLinux
- 新的
- 添加
- 取消
- 曾老湿ng
<!-- OCR_END -->

￼

_5.等待自动注册_

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
- 群组所有
- 创建主机
- 导入
- 过滤器
- 名称
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
- wwweb03
- 应用集10
- 监控项32
- 触发器15
- 图形5
- 自动发现2
- 10.0.0.30:10050
- TemplateOSLinux(TemplateAppZabbixAgent)
- 已启用
- ZBXSNMPJMXIPMI
- 曾老湿
- 显示已自动发现的1中的1
- Dr
<!-- OCR_END -->

￼

_6.等待邮件通知_

<!-- OCR_START -->
- Autoregistration:wwweb03
- 发件人
- 时间：
- 收件人：
- Hostname:wwweb03
- HostIP:10.0.0.30
- Agentport:10050
<!-- OCR_END -->

￼

_7.可以通过主机名称来区分不同的主机，例如web，db，这样可以根据不同的主机配置不同的模板。_

_第一个动作如下_

> 名称：web服务主机自动注册
>
> 主机名称似 web
>
> 操作：链接到模板：Template Nginx Status
>

_第二个动作如下_

> 名称：db服务主机自动注册
>
> 主机名称似 db
>
> 操作：链接到模板：Template DB MySQL
>

_如无法通过主机名称进行区分各个主机，建议使用"主机元数据"进行区分各个主机，详情参考官方文档_

## Zabbix主被模式区别
**1.主动模式与被动模式区别**

_1) 被动模式 (Zabbix-server轮询检测zabbix-agent)2) 主动模式 (Zabbix-agent主动上报给Zabbix-server)_

**2.主动模式与被被动模式选择如何选择**

_1.当Queue里有大量延迟的监控项2.当监控主机超过300+, 建议使用主动模式。_

## Zabbix主被模式实践
_1.Zabbix被动模式演示取值: Zabbix默认是被动模式，被动模式如果需要获取100个监控项的值, 需要Server向Agent获取100次。（注意zabbix图中的时间)_

<!-- OCR_START -->
- zabbix被动模式
- tcp.estab状态数量
- 返回获取本地tcp.estab状态的值
- zabbix-server
- zabbix-agent
- tcp.listen状态数量
- 执行脚本，获取值
- 监控项是100个，需要请求100次
- 100个监控项
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 名称
- 最近检查记录
- 最新数据
- 更改
- CPU（13监控项）
- Context switches per second
- 2018-08-23
- 16:47:47
- 106 sps
- •1 $ps
- 图形
- CPU idle tme
- 16:47:48
- 99.77 %
- -0.01 %
- CPU interrupt tme
- 16:47:49
- 0%
- CPU iowait time
- 2018-08-23 16:47:50
- CPU nice tme
- 2018-08-23 16:47:51
- CPU stirq tme
- 2018-08-2316:47:52
- 0.03 %
- CPU steal tme
- 2018-08-23 16:47:53
- CPU system time
- 2018-08-23 16:47:54
- 0.17 %
- CPU user time
- 2018-08-23 16:47:55
- Interupts per second
- 2018-08-23 16:47:43
- 91i05
- +1ips
- Processor load (1 min average per core）
- 16:47:45
- Processor load (5 min average per core)
- 2018-08-2316:47:46
- Processor load (15 min average per core)
- 16:47:44
- 0.05
- General (3监控项）
- 2018-08-23 09:45:48
<!-- OCR_END -->

￼

_2.Zabbix主动模式演示取值: Zabbix主动模式如果需要获取100个监控项的值，Server会将要获取监控项的值生成一个清单发送给Agent，Agent采集完成后会一次将所有数据发送给Server。_

<!-- OCR_START -->
- zabbix主动模式
- zabbix-agent生成清单
- 主动一次性传递给zabbix-server
- zabbix-server
- zabbix-agent
- 执行脚本，获取监控项的值
- 100个监控项
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

<!-- OCR_START -->
- 名称
- 最近检查记录
- 最新数据
- 更改
- CPU（11监控项）
- CPUidle time
- 2018-08-23 16:55:02
- 99.85%
- 图形
- CPU interrupt tme
- 0%
- 西形
- CPU iowat time
- 0.02 %
- 四形
- CPU nice time
- CPU sofirq time
- CPU steal time
- CPU system time
- 0.12%
- CPU user time
- Processor load (1 min average per core)
- Processor load (5 min average per core)
- 0.01
- Processor load (15 min average per core)
- 0.05
- General(5监控项）
- Host boot tme
- 2018-08-23 09:45:48
- Host local tme
- Host name
- web02
- 历史记录
- Linux web02 3.10.0-862.el7.x.
- 历更记录
- 曾老湿
- 07:09:14
- DriverZeng
- 483.05 MB
<!-- OCR_END -->

￼

_3.如何将Zabbix调整为主动模式_

_1) 修改/etc/zabbix/zabbix_agent.conf配置文件_

```plain
[root@web03 ~]# vim /etc/zabbix/zabbix_agentd.conf
ServerActive=172.16.1.71
Hostname=   #填写主机名称
```

_2) Zabbix需要更新模板为 Active_

_1.克隆一份被动模式的模板  
__2.点击克隆后的模板->选中所有监控项->批量修改->修改为主动模式  
__3.主机取消链接并清理被动模板，重新关联新模板即可。_

**	**

 			

> 更新: 2019-11-23 09:17:07  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/wu1kmr>