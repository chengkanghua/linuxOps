# 01 Saltstack快速入门

# 01 Saltstack快速入门

* [1.1Saltstack基本概述](http://class.xuliangwei.com/15128072287754.html#toc_0)
* [1.2Saltstack快速安装](http://class.xuliangwei.com/15128072287754.html#toc_1)
* [1.3Saltstack认证方式](http://class.xuliangwei.com/15128072287754.html#toc_2)
* [1.4Saltstack远程执行](http://class.xuliangwei.com/15128072287754.html#toc_3)
* [1.5Saltstack配置管理](http://class.xuliangwei.com/15128072287754.html#toc_4)
* [1.6SaltStack消息队列](http://class.xuliangwei.com/15128072287754.html#toc_5)
* [1.7SaltStack常用配置](http://class.xuliangwei.com/15128072287754.html#toc_6)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 1.1Saltstack基本概述

`SaltStack`是一个异构平台基础设施管理工具，具有远程执行、配置管理、云管理, 只需要花费数分钟即可运行起来，扩展性组以支撑管理上万台服务器，速度快，服务器之间秒级通讯数秒钟即可完成数据传递。

`**SaltStack**`**三大功能**

* 远程执行
* 配置管理（状态）
* 云管理

`**SaltStack**`**四种运行方式**

* `Local`本地运行
* `Minion/Master` 传统方式运行
* `Syndic`分布式
* `Salt SSH`

**SaltStack常用网址**

* [SaltStack官方网站](http://www.saltstack.com/)
* [SaltStack官方文档](http://docs.saltstack.cn/zh_CN/latest/)
* [SaltStack Github](http://class.xuliangwei.com/GitHub%EF%BC%9Ahttps://github.com/saltstack)

## 1.2Saltstack快速安装

`SaltStack`支持多种操作系统，如`CentOS、RedHat、Debian、Ubuntu、FreeBSD、Solaris、Fedora、SuSe、Gentoo、MAC OS X、Archlinux`等，以及`Windows`（仅支持`Minion`）

1.配置`salt`官方阿里云`yum`仓库

```plain
[root@salt0-master ~]# yum install -y  \
https://mirrors.aliyun.com/saltstack/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
[root@salt0-master ~]# sed -i \
"s/repo.saltstack.com/mirrors.aliyun.com\/saltstack/g" /etc/yum.repos.d/salt-latest.repo
[root@salt0-master ~]# yum makecache
```

2.安装`Master`,并启动服务

```plain
[root@salt0-master ~]# yum install salt-master -y
[root@salt0-master ~]# systemctl enable salt-master
[root@salt0-master ~]# systemctl start salt-master
```

3.安装`Salt-Minion`指向`Salt-Master`网络地址

```plain
[root@salt1-minion ~]# yum install salt-minion -y
#配置master地址或主机名, 建议使用主机名方式
[root@salt1-minion ~]# sed -i '/master: /c\master: salt-master' /etc/salt/minion
[root@salt1-minion ~]# systemctl enable salt-minion
[root@salt1-minion ~]# systemctl start salt-minion
```

4.如启动时发生异常可以查看`SaltStack`相关日志

```plain
#服务端日志
[root@salt0-master ~]# tail -f /var/log/salt/master
#客户端日志
[root@salt1-minion ~]# tail -f /var/log/salt/minion
```

## 1.3Saltstack认证方式

`Salt`的数据传输是通过`AES`加密，`Master`和`Minion`之间在通信之前，需要进行认证。

`Salt`通过认证的方式保证安全性，完成一次认证后，`Master`就可以控制`Minion`来完成各项工作了。

* 1.`minion`在第一次启动时, 会在`/etc/salt/pki/minion/`下自动生成`minion.pem(private key)`和`minion.pub(public key)`然后将`minion.pub`发送给`master`
* 2.`master`在第一次启动时, 会在`/etc/salt/pki/master`下自动生成`master.pem和master.pub`会接收到`minion`的`public key`通过`salt-key`命令接收`minion public key`, 则会在`master`的`/etc/salt/pki/master/minions`目录下存放以`minion id`命名的`public key`同时`minion`会保存一份`master public key`在`/etc/salt/pki/minion_master.pub`

**Salt认证原理小结**

> minion将自己的公钥发送给master
>
> mastr认证后会将自己的公钥也放置minion端

**Master端Key认证示例**

在上面一个小节已经提到了`Master`与`Minion`的认证方式，只有`Master`接受了`Minion Key`后，才能进行管理。具体的认证命令为`salt-key`常用的有如下命令。

```plain
[root@linux-node1 ~]# salt-key -L
Accepted Keys：  #已经接受的key
Denied Keys：    #拒绝的key
Unaccepted Keys：#未加入的key
Rejected Keys：#吊销的key
#常用参数
-L  #查看KEY状态
-A  #允许所有
-D  #删除所有
-a  #认证指定的key
-d  #删除指定的key
-r  #注销掉指定key（该状态为未被认证）
#在master端/etc/salt/master配置
auto_accept: True   #如果对Minion信任,可以配置master自动接受请求
```

`salt-key`使用

```plain
#列出当前所有的key
[root@salt0-master ~]# salt-key 
Accepted Keys:
salt1-minion.example.com
salt2-minion.example.com
salt3-minion.example.com
salt4-minion.example.com
Denied Keys:
Unaccepted Keys:
Rejected Keys:
#添加指定minion的key
[root@salt0-master ~]# salt-key  -a salt1-minion.example.com -y
#添加所有minion的key
[root@salt0-master ~]# salt-key  -A  -y
#删除指定的key
[root@salt0-master ~]# salt-key -d salt1-minion.example.com -y
#删除所有的key
[root@salt0-master ~]# salt-key -D -y
```

## 1.4Saltstack远程执行

远程执行是`SaltStack`的核心功能之一。主要使用`salt`模块可以批量给选定的`Minion`端执行相应的命令，并获得返回结果。

<!-- OCR_START -->
- Master
- salt
- disk.usage
- return
- command
- Minions
- Linux
- Solaris
- FreeBSD
- Windows
- OSX
<!-- OCR_END -->

1.判断`Salt`的`Minon`主机是否存活

```plain
[root@salt0-master ~]# salt '*' test.ping
salt3-minion.example.com:
    True
salt2-minion.example.com:
    True
salt1-minion.example.com:
    True
salt4-minion.example.com:
    True
# salt 是一个命令
# * 表示目标主机, 在这里代表所有目标主机
# test.ping是salt远程执行的一个模块下面的方法。
```

2.`SaltStack`可以使用`cmd.run`模块远程执行`shell`命令

```plain
//让指定目标Minion节点运行uptime命令
[root@salt0-master ~]# salt 'salt1-minion.example.com' cmd.run 'uptime'
salt1-minion.example.com:
     14:45:50 up 1 day,  1:25,  2 users,  load average: 0.00, 0.02, 0.05
# Salt提供了大量的模块执行不同的操作, 不建议生产频繁使用cmd.run
```

## 1.5Saltstack配置管理

`salt`通过状态模块来识别配置描述文件`State`状态文件,格式是`YAML`扩展名后缀是`.sls`

1.`YAML`基础语法

```plain
YAML:
    1.缩进(层级关系)  2个空格，不能试用Tab。
    2.冒号  key: value
    3.短横线 - list1
            - list2
```

* 1.缩进
  * YAML使用一个固定的缩进风格表示数据层级结构关系,每个缩进由两个空格组成, 不要使用tabs。
* 2.冒号
  * 以冒号结尾, 以冒号为路径的除外，其他所有冒号后面所有必须有空格。
* 3.短横线
  * 表示列表项，使用一个短横杠加一个空格。
  * 多个项使用同样的缩进级别作为同一列表。

2.`YAML`配置,设置`base`环境

```plain
#定义基础环境目录位置
[root@salt0-master ~]# vim /etc/salt/master
file_roots:
  base:
    - /srv/salt
#修改配置必须重启服务
[root@salt0-master ~]# systemctl restart salt-master
```

3.编写`yaml`语法文件

```plain
[root@salt0-master ~]# mkdir -p /srv/salt/app
[root@salt0-master ~]# cd /srv/salt/app
#编写sls文件, apache安装并启动
[root@salt0-master app]# cat apache.sls 
apache-install:
  pkg.installed:
    - name: httpd
apache-systemctl:
  service.running:
    - name: httpd
    - enable: True
#编写sls文件, vsftpd安装并启动
[root@salt0-master app]# cat vsftpd.sls 
vsftpd_install:
  pkg.installed:
    - names:
      - vsftpd
      - httpd-tools
vsftpd_systemctl:
  service.running:
    - name: vsftpd
    - enable: True
#编写sls文件, nginx安装并启动
[root@salt0-master app]# cat nginx.sls
nginx-install:
  pkg.installed:
    - name: nginx
nginx-systemctl:
  service.running:
    - name: nginx
```

4.使用`salt`命令的`state`状态模块让所有Minion都应用该配置

```plain
[root@linux-node1]# salt '*' state.sls app.vsftpd
[root@linux-node1]# salt '*' state.sls app.vsftpd
```

5.如果想不同的主机应用不同的配置, 则需要使用到`salt`高级状态模块

```plain
# topfile入口文件只能放置在base环境
[root@salt0-master ~]# cat /srv/salt/top.sls 
base:
  'salt1-minion.example.com':
    - app.nginx
  'salt2-minion.example.com':
    - app.nginx
  'salt3-minion.example.com':
    - app.apache
    - app.vsftpd
  'salt4-minion.example.com':
    - app.apache
    - app.vsftpd
```

6.当使用`salt`命令执行高级状态, 会将`topfile`当做入口文件,进行调用

<!-- OCR_START -->
- nginx-install:
- Top File
- pkg.installed:
- name: nginx
- base:
- nginx-system:
- 'salt1-minion':
- service.running:
- app.nginx
- 'salt2-minion':
- /srv/salt/app/nginx.sls
- 'salt3-minion':
- app.apache
- app.vsftpd
- apache-install:
- 'salt4-minion':
- name: httpd
- apache-system:
- /srv/salt/top.sls
- enable: True
- /srv/salt/app/apache.sls
<!-- OCR_END -->

```plain
# 将高级状态应用到所有主机
[root@linux-node1]# salt '*' state.highstate
```

## 1.6SaltStack消息队列

`SaltStack`可以支数以千计，甚至更多的服务器。这些性能的提供主要来自于`ZeroMQ`, 因为`SaltStack`底层是基于`ZeroMQ`进行高效的网络通信。`ZeroMQ`是一个简单好用的传输层，像框架一样的一个套接字库，他使得`Socket`编程更加简单、简洁和性能更高。

**发布与订阅**

`ZeroMQ`支持`Publish/Subscribe`即发布与订阅模式，我们经常简称`Pub/Sub`

<!-- OCR_START -->
- Publisher
- PUB
- bind
- updates
- connect
- SUB
- Subscriber
<!-- OCR_END -->

`Salt Master`运行两个网络服务

一个是`ZeroMQ PUB`消息发布与订阅系统，默认监听`4505`端口, 主要用于`Master`对`Minion`下发指令

```plain
#所有的Minion连接到Master的4505端口TCP状态持续保持为ESTABLISHED
[root@linux-node1]# yum install lsof -y
[root@linux-node1]# lsof -i :4505
```

> 注意: 可以修改`/etc/salt/master`配置文件的`publish_port`参数设置端口。

**请求与响应**

`ZeroMQ`支持`Request-Reply`请求与响应模式，简称`REQ/REP`

<!-- OCR_START -->
- Client
- REQ
- Hello
- World
- REP
- Server
<!-- OCR_END -->

`Salt Master`运行的第二个网络服务就是`ZeroMQ REP`系统，默认监听4506端口`salt`客户端与服务端通信的端口

同时也主要用于`Master`接收`Minion`执行某个命令后的返回值

> 注意: 可以修改`/etc/salt/master`配置文件的`ret_port`参数设置。

显示SaltStack进程名称方式

```plain
[root@linux-node1]# yum install -y python-setproctitle
[root@linux-node1]# ps aux | grep salt
/usr/bin/salt-master -d ProcessManager  #中心进程管理器
/usr/bin/salt-master -d _clear_old_jobs  #清除旧的Jobs文件及更新fileserver
/usr/bin/salt-master -d Publisher       #将任务PUB到Minion端
/usr/bin/salt-master -d EventPublisher  #Event Publisher进程
/usr/bin/salt-master -d ReqServer_ProcessManager #ReqServer进程管理器
/usr/bin/salt-master -d MWorker  #工作进程
/usr/bin/salt-master -d MWorker  #工作进程
/usr/bin/salt-master -d MWorker  #工作进程
/usr/bin/salt-master -d MWorker  #工作进程
/usr/bin/salt-master -d MWorker  #工作进程
/usr/bin/salt-master -d MWorkerQueue #将Ret接口(ROUTER)数据转发到Worker(DEALER)
```

## 1.7SaltStack常用配置

**1.Salt Master配置**

`Salt Master`端的配置是修改`/etc/salt下master`配置文件。以下是`Master`端常用的配置。

```plain
interface: //指定bind 的地址(默认为0.0.0.0)
publish_port: //指定发布端⼝(默认为4505)
ret_port: //指定结果返回端⼝,  与minion配置⽂件中的master_port对应(默认为4506)
user: //指定master进程的运⾏⽤户,如果调整, 则需要调整部分目录的权限(默认为root)
timeout: //指定timeout时间,  如果minion规模庞⼤或⺴络状况不好,建议增⼤该值(默认5s)
keep_jobs: //minion执⾏结果返回master, master会缓存到本地的cachedir目录,该参数指定缓存多⻓时间,可查看之间执行结果会占⽤磁盘空间(默认为24h)
job_cache: //master是否缓存执⾏结果,如果规模庞⼤(超过5000台),建议使⽤其他⽅式来存储jobs,关闭本选项(默认为True)
file_recv : //是否允许minion传送⽂件到master 上(默认是Flase)
file_roots: //指定file server目录,  默认为:
    file_roots:    
       base:    
        - /srv/salt     
pillar_roots : //指定pillar ⺫录,  默认为:
    pillar_roots:     
      base:     
        - /srv/pillar     
log_level: //⽇志级别
⽀持的⽇志级别有'garbage', 'trace', 'debug', info', 'warning', 'error', ‘critical ’ ( 默认为’warning’)
```

**2.Salt Minion配置**

`Minion`端配置非常简单，一般只需要修改两个配置即可。

```plain
[root@minion ~]# vim /etc/salt/minion
master: 192.168.56.11 //修改master为master的IP地址
id: //客户端的id,默认不设置会取客户端的完整主机名
```

`**Salt Minion**`**端常用配置**

```plain
master: //指定master 主机(默认为salt)
master_port: //指定认证和执⾏结果发送到master的哪个端⼝,  与master配置⽂件中的ret_port对应(默认为4506)
id: //指定本minion的标识, salt内部使⽤id作为标识(默认为主机名)
user: //指定运⾏minion的⽤户.由于安装包,启动服务等操作需要特权⽤户, 推荐使⽤root( 默认为root)
cache_jobs : //minion是否缓存执⾏结果(默认为False)
backup_mode: //在⽂件操作(file.managed 或file.recurse) 时,  如果⽂件发⽣变更,指定备份目录.当前有效
providers : //指定模块对应的providers, 如在RHEL系列中, pkg对应的providers 是yumpkg5
renderer: //指定配置管理系统中的渲染器(默认值为:yaml_jinja )
file_client : //指定file clinet 默认去哪⾥(remote 或local) 寻找⽂件(默认值为remote)
loglevel: //指定⽇志级别(默认为warning)
tcp_keepalive : //minion 是否与master 保持keepalive 检查, zeromq3(默认为True)
```

> 更新: 2019-03-21 09:15:40  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/nby2yg>