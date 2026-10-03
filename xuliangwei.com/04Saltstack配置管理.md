# 04 Saltstack配置管理

# 04 Saltstack配置管理

* [1.States状态模块](http://class.xuliangwei.com/15128074185699.html#toc_0)
  * [高级状态模块](http://class.xuliangwei.com/15128074185699.html#toc_1)
  * [LAMP架构案例](http://class.xuliangwei.com/15128074185699.html#toc_2)
* [2.States状态依赖](http://class.xuliangwei.com/15128074185699.html#toc_3)
* [3.Jinja模板使用](http://class.xuliangwei.com/15128074185699.html#toc_4)
* [4.Salt Job管理](http://class.xuliangwei.com/15128074185699.html#toc_5)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 1.States状态模块

`States`是`SaltStack`系统中的配置语言，在日常运维中需要编写大量的`States`文件，例如:创建用户、安装软件、配置软件、服务运行等。需要编写一些`States SLS`文件，即状态配置文件去描述和实现相应的功能。

`States SLS`主使用`YAML`语言，也可以支持使用`Python`语言编写。

```plain
apache-install: #ID申名,ID必须唯一
  pkg.installed: #State状态申名
    - names: #选项声明
      - httpd  #选项列表
      - httpd-devel
 
apache-service:
  service.running:  
    - name: httpd   
    - enable: True
//注意
//一个ID只能出现一次
//一个ID下相同模块只能使用一次
//一个ID下可以使用多个不同模块
```

常用的状态模块用法

```plain
//列出所有状态模块
[root@linux-node1 ~]# salt '*' sys.list_modules
//查看状态模块中的函数
[root@linux-node1 ~]# salt '*' sys.list_state_functions pkg
```

**1.pkg软件模块**

`pkg.installed`软件安装

```plain
mypkgs:
  pkg.installed:
    - pkgs:
      - httpd
      - httpd-tools: '>=2.4.6' #指定安装版本
```

指定安装的`rpm`来源

```plain
mypkgs:
  pkg.installed:
    - sources:
      - foo: salt://rpms/foo.rpm
      - bar: http://somesite.org/bar.rpm
      - qux: ftp://somesite.org/qux.rpm
```

指定安装最新版本的软件

```plain
mypkgs:
  pkg.latest:
    - pkgs:
      - httpd
      - httpd-tools
```

**2.file模块**

`file`模块包含许多函数, 比较常用的列举如下

`file.managed`下发文件, 确保文件存在

```plain
/etc/resolv.conf:
  file.managed:
    - source: salt://files/resolv.conf.defaults
    - user: root
    - group: root
    - mode: 644
    - backup: minion
```

`file.directory`建立目录

```plain
/tmp/dns:
  file.directory:
    - user: root
    - group: bgx
    - mode: 755
    - makedirs: True
```

`file.recurse`下发整个目录

```plain
nginx-vhost-config:
  file.recurse:
    - name: /etc/nginx/conf.d
    - source: salt://app/files/nginx_conf.d
    - file_mode: 600 #文件权限
    - dir_mode: 777 #目录权限
    - include_empty: True #同步空目录
    - clean: True #使用后minion与master强制一致
```

`file.symlink`建立软链接

```plain
/etc/target.conf:  #目标
  file.symlink:
    - target: /etc/grub2.cfg #源
```

**3.service模块**

```plain
redis-service:
  service.running:
    - enable: True #开机自启动
    - reload: True #允许重载,不写则是restart
    - watch: #我监控谁
      - pkg.redis-files
```

**4.cron模块**

每5分钟执行一次指定任务

```plain
crontab_scripts:
  cron.present:
    - name: bash /scripts/nginx.sh &>/dev/null
    - user: root
    - minute: '*/5'
```

### 高级状态模块

`top.sls`默认从`base`标签开始解析执行,下一级是操作的目标，可以通过正则，`grain`模块,或分组名,来进行匹配,再下一级是要执行的`state`文件

TopFile示例

```plain
base:
  '*': #通过正则去匹配所有minion
    - app.nginx
  webserver: #定义的分组名称
    - match: nodegroup
    - app.cron
  'os:centos':  #通过grains模块匹配
    - match: grains
    - nginx
```

高级状态执行方式

```plain
[root@salt0-master ~]# salt '*' state.highstate
```

### LAMP架构案例

此案例在`prod`环境配置

1.编写状态需要先定义`file_roots`环境

```plain
[root@linux-node1 ~]# vim /etc/salt/master
file_roots:
  base:
    - /srv/salt/base
  prod:
    - /srv/salt/prod
```

2.创建对应环境的目录

```plain
[root@salt0-master salt]# mkdir -p /srv/salt/{base,prod}
[root@salt0-master salt]# tree /srv/salt/
/srv/salt/
├── base
└── prod
```

3.先手动安装, 便于提取相应的配置文件

```plain
[root@linux-node1 ~]# yum -y install httpd mariadb-server php php-mysql php-gd gd
```

4.准备相应目录与对应配置文件

```plain
[root@salt0-master prod]# mkdir init/files -p
[root@salt0-master prod]# cd /srv/salt/prod/init
[root@salt0-master init]# cp /etc/httpd/conf/httpd.conf files/
[root@salt0-master init]# cp /etc/my.cnf files/
[root@salt0-master init]# cp /etc/php.ini files/
```

5.创建并编写`States`文件

```plain
[root@salt0-master init]# cat lamp.sls 
httpd-install:
  pkg.installed:
    - names:
      - httpd
      - httpd-tools
httpd-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://init/files/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
http-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
php-install:
  pkg.installed:
    - names:
      - php
      - php-mysql
      - php-gd
      - gd
php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://init/files/php.ini
    - user: root
    - group: root
    - mode: 644
    - backup: minion
mysql-install:
  pkg.installed:
    - names:
      - mariadb
      - mariadb-server
mysql-config:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://init/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
mysql-service:
  service.running:
    - name: mariadb
    - enable: True
```

6.编写`TopFile`文件

```plain
[root@salt0-master base]# cat /srv/salt/base/top.sls
prod:
  'salt1*':
    - init.lamp
```

7.部署LAMP整体`States`文件

```plain
[root@salt0-master base]# tree /srv/salt/
/srv/salt/
├── base
│   └── top.sls
└── prod
    └── init
        ├── files
        │   ├── httpd.conf
        │   ├── my.cnf
        │   └── php.ini
        └── lamp.sls
```

## 2.States状态依赖

现在外面已经可以用`State`模块来定义Minion的状态了, 但是如果一个主机涉及多个状态，并且状态之间有相互关联，需要在执行顺序上有先后之分，那么必须引入`requisites`来进行控制。

> 1.`require`我依赖某个状态, 我依赖谁 
>
> 2.`require_in`我被某个状态依赖, 谁依赖我
>
> 3.`watch`我关注某个状态, 当状态发生改变，进行restart或reload操作
>
> 4.`watch_in`我被某个状态关注
>
> 5.`include`我引用谁

1.修改状态间依赖关系后

```plain
[root@salt0-master init]# cat lamp.sls 
httpd-install:
  pkg.installed:
    - names:
      - httpd
      - httpd-tools
httpd-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://init/files/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - pkg: httpd-install
http-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:
      - file: httpd-config
    - watch:
      - file: httpd-config
php-install:
  pkg.installed:
    - names:
      - php
      - php-mysql
      - php-gd
      - gd
    - reqiure_in:
      - file: php-config
php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://init/files/php.ini
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - watch_in:
      - service: http-service
mysql-install:
  pkg.installed:
    - names:
      - mariadb
      - mariadb-server
mysql-config:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://init/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - pkg: mysql-install
mysql-service:
  service.running:
    - name: mariadb
    - enable: True
    - require:
      - file: mysql-config
    - watch:
      - file: mysql-config
```

2.修改引用关系后`include`

```plain
[root@salt0-master init]# tree /srv/salt/prod/
/srv/salt/prod/
├── init
│   ├── apache.sls
│   ├── files
│   │   ├── httpd.conf
│   │   ├── my.cnf
│   │   └── php.ini
│   └── mysql.sls
└── lamp.sls
[root@salt0-master init]# cat /srv/salt/prod/lamp.sls 
include:
  - init.apache
  - init.mysql
```

3.如何编写`SLS`技巧

> 1.按状态分类如果单独使用，很清晰
>
> 2.按服务分类,可以被其他`SLS`引用

## 3.Jinja模板使用

配置文件一般都是固定无法灵活多变

`Jinja2`模板包含变量和表达式, 变量用`{{...}}`包围, 表达式用`{%...%}`包围, 首先看如下简单的例子

```plain
# cat var.sls
{% set var= 'hello World!' %}
test_var:
  cmd.run:
    - name: echo "jinja is {{ var }}"
//变量的输出
salt '*' state.sls var saltenv=prod
linux-node1.com:
----------
          ID: test_var
    Function: cmd.run
        Name: echo "jinja is hello World!"
      Result: True
     Comment: Command "echo "jinja is hello World!"" run
     Started: 14:36:44.321252
    Duration: 10.811 ms
     Changes:
              ----------
              pid:
                  65813
              retcode:
                  0
              stderr:
              stdout:
                  jinja is hello World!
```

通过上面的例子,我们对`jinja2`有初步的认识, 下面介绍下`jinja2`的变量

字符串类型

```plain
{% set var = 'good' %}  #定义变量
{{ var }}  #调用变量
```

列表类型

```plain
{% set list = ['one', 'two', 'three'] %}
{{ list[1] }}  #最终显示one
```

字典类型

```plain
{% set dict = {'first': 'value1', 'second': 'value2'} %}
{{ dict['first'] }}
```

1.`SaltStack`使用`jinja2`模块需要三步

```plain
#1.告诉file状态模块, 需要使用jinja
  - template: jinja
#2.列出参数列表
  - defaults:
    PORT: 88
#3.配置文件引用jinja模板
{{ PORT }}
# 配置示例
httpd-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://init/files/httpd.conf
    - backup: minion
    - template: jinja
    - defaults:
      PORT: 9000
# 修改httpd.conf配置文件引用变量
Listen {{ PORT }}
```

2.模板支持`grinas pillar`进行赋值

```plain
//文件直接使用grins方式
listen {{ grains['fqdn_ip4'][0] }}:{{ PORT }}
//grains
{{ salt['netwrok.hw_addr']('eth0') }}
Pillar方式
apache:
  IP: {{ grains['fqdn_ip4'][0] }}
  PORT: 8008
#引用
{{ pillar['apache'][IP] }}
{{ pillar['apache'][PORT] }}
```

3.写在`SLS`里的`Defaults`变量列表中

```plain
- defaults:
    IPADDR: {{ grains['fqdn_ip4'][0] }}
    PORT: 88
配置文件引用方式
listen {{ IPADDR }}:{{ PORT }}
```

4.通过`jinja+grains`安装不同系统的`apache`

```plain
# Centos安装方式
httpd_install:
  pkg.installed:
    - name: httpd
#ubuntu安装方式
httpd_install:
  pkg.installed:
    - name: apache2
# 根据grains静态数据,使用jinja2流程控制
httpd_install:
  pkg.installed:
{% if grains['os_family'] == 'Debian' %}
    - name: apache2
{% elif grains['os_family'] == 'RedHat' %}
    - name: httpd
{% endif %}
```

## 4.Salt Job管理

**1.job概述**

`salt`每次运行任务都会将任务发布到`pub-sub`总线，`minion`会对任务作出响应，为区分不同的任务`SaltMaster`每次发布一个任务都会为该任务创建一个`jobid`。

`master`默认情况下会缓存24小时内的所有`job`的详细操作。

> 1.master缓存目录 /var/cache/salt/master/jobs
>
> 2.minion端每次执行任务都会缓存在 /var/cache/salt/minion/proc目录中创建jobid为名称的文件，任务执行完后文件会被删除

在`master`主机上执行一个长时间的任务

```plain
salt '*' cmd.run "sleep 100"
```

登陆`minion`执行

```plain
ls /var/cache/salt/minion/proc
#用strings查看文件的文本部分内容
[root@salt1-minion ~]# strings /var/cache/salt/minion/proc/20180603140922586080
```

`20180603140922586080`这串数字就是`jobid`一个以时间戳形式建立的唯一id。我们了解了jpbid的概念，下面来学习如果对job进行管理

**2.job管理**

通过`salt-run`命令来管理`job`也可以使用另一种管理`job`的方式`salt util`模块。

在`master`中执行一个长时间执行的命令

```plain
# salt '*' cmd.run "sleep 1000;echo hehe"
    //ctrl+c
```

获取`jobid`后登陆`minion`查看

```plain
ls /var/cache/salt/minion/proc
```

通过`saltutil.find_job`查看相关job信息

```plain
[root@salt0-master ~]# salt '*' saltutil.find_job 20180603141122461735
```

`Kill`指定的`job`

```plain
[root@salt0-master ~]# salt '*' saltutil.kill_job 20180603141122461735
```

查看`master`上`cache`的所有`job`

```plain
salt '*' saltutil.runner jobs.list_jobs|more
```

> 更新: 2019-03-21 09:17:20  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/hskldl>