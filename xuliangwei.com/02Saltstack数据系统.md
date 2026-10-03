# 02 Saltstack数据系统

# 02 Saltstack数据系统

* [1.数据系统Grains](http://class.xuliangwei.com/15128073294753.html#toc_0)
* [2.数据系统Pillar](http://class.xuliangwei.com/15128073294753.html#toc_1)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 1.数据系统Grains

`Grains`静态数据

> 1.Grains数据存储在minion端，minion端的数据信息
>
> 2.当minion启动时会收集Minion自身的状态信息后才加载grins信息，所以grains数据是静态的。比如: 操作系统版本，内核版本，CPU，内存，硬盘。设备型号。
>
> Minion收集的信息，可以作为Master端匹配目标
>
> Master端自定义grains设置, 需要执行命令推送给Minion端
>
> Master端推送的数据会存储在端的/var/cache/salt

1.资产管理, 信息查询

```plain
//列出所有可打印的状态模块
[root@salt0-master ~]# salt '*' grains.ls
//打印所有的状态信息
[root@salt0-master ~]# salt '*' grains.items
//列出每台minion的本地IP地址
[root@salt0-master ~]# salt '*' grains.item fqdn_ip4
```

2.`salt`远程执行的目标匹配

```plain
//修改minion配置文件，定义grains
[root@salt1-minion ~]# vim /etc/salt/minion 
grains:
  roles:
    - webserver
  os_version:
    - centos7u4
//重启minion
[root@salt1-minion ~]# systemctl restart salt-minion
//目标匹配方式
[root@salt1-minion ~]# salt -G 'os_version:centos7u4' test.ping
```

3.`Master`端编写一个`Grains`的`Python`脚本推送给`minion`配置管理案例

```plain
[root@salt0-master ~]# mkdir /srv/salt/_grains -p && cd /srv/salt/_grains
[root@salt0-master _grains]# cat /srv/salt/_grains/my_grains.py 
#!/usr/bin/env python
#-*- coding: utf-8 -*-
def mygrains():
    #设置一个字典
    grains = {}
    #设置字典的值
    grains['iaas'] = 'openstack'
    grains['pass'] = 'Docker'
    #返回这个字典
    return grains
    
# 刷新Grains,从Master推送给所有的Minion客户端
[root@salt0-master ~]# salt '*' saltutil.sync_grains
```

4.`Grians`优先级问题

> 1.Grains默认获取的状态信息
>
> 2.在minion配置文件进行自定义
>
> 3.在Master端定义grains推送Minion

## 2.数据系统Pillar

`Pillar`是动态的,`Pillar`存储在`master`端，提供给`minion`端。

`Pillar`主要记录一些加密信息, 可以确保这些敏感数据不被其他`minion`看到。

`Pillar`在`SaltStack`中主要作用是存储和定义配置管理中需要的一些数据，比如软件版本号、用户名密码等信息，它的存储格式跟`Grains`类似，都是`YAML`格式。

<!-- OCR_START -->
- Master
- Pillardata
- Minions
<!-- OCR_END -->

1.在`Master`端定义`Pillar`

```plain
[root@salt0-master ~]# vim /etc/salt/master
pillar_roots:
  base:
    - /srv/pillar
[root@salt0-master ~]# systemctl restart salt-master
[root@salt0-master ~]# mkdir /srv/pillar
[root@salt0-master ~]# cd /srv/pillar/
[root@salt0-master pillar]# cat zabbix.sls
Zabbix_Server: 192.168.70.170
Zabbix_Name: salt0-master.examp.com
```

2.编写`TopFile`指定`Minion`端可以使用

```plain
[root@salt0-master pillar]# cat top.sls 
base:
  'salt2-minion.example.com':
    - zabbix
```

3.刷新`Pillar`

```plain
[root@saltstack01 ~]# salt '*' saltutil.refresh_pillar
```

4.获取对应`pillar`值

```plain
[root@salt0-master ~]# salt '*' pillar.items
salt2-minion.example.com:
    ----------
    Zabbix_Name:
        salt0-master.examp.com
    Zabbix_Server:
        192.168.70.171
# 获取指定的key
[root@salt0-master ~]# salt 'salt2-minion.example.com' pillar.item Zabbix_Server
```

> 注意: 如果Master更新了新的数值, 需要刷新Pillar至Minion才可获取

5.`pillar`与`Grains`对比

```plain
类型     数据采集方式   应用场景                   定义位置
Grains   静态         minion启动时收集  数据查询  目标选择  配置管理   minion
Pillar   动态         master进行自定义  目标选择  配置管理  敏感数据   master
```

> 更新: 2019-03-21 09:16:05  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/le0g99>