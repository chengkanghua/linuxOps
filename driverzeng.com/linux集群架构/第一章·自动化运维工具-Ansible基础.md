# 第一章·自动化运维工具-Ansible基础

## Ansible基本概述

| 什么是Ansible？ |
| --- |

Ansible是一个自动化**统一配置管理工具**，自动化主要体现在Ansible集成了丰富模块以及功能组件，可以通过一个命令完成一系列的操作，进而能减少重复性的工作和维护成本，可以提高工作效率。

***

| 同类型软件对比 |
| --- |

> 1.puppet 学习难，安装ruby环境难，没有远程执行功能
>
> 2.ansible 轻量级，大规模环境下只通过ssh会很慢，串行的
>
> 3.saltstack 一般选择salt会使用`C/S`结构的模式，`salt-master`和`salt-minion`，并行的，大规模批量操作的情况下，会比Ansible速度快一些，底层使用的是`zero-MQ`消息队列

***

| 手动运维时代（原始社会） |
| --- |

在之前，我们学习了如何安装nginx。但是我们使用的是yum安装的方式，在以前，运维需要规范，需要统一配置管理，我们只能使用源码安装方式，便于我们去管理，源码安装，如果是单台还好，一会也就装完了，如果此时，生产环境压力骤增，需要扩展100台web节点（源码安装100台nginx）我们该如何操作？

**重复以下步骤100遍？？？**

```bash
#1.安装依赖
yum install pcre-devel openssl-devel -y
#2.进入安装目录
cd /usr/local/tools
#3.创建nginx用户
useradd nginx -M -s /sbin/nologin
#4.解压
tar xf nginx-1.6.3.tar.gz
#5.进入nginx程序目录
cd nginx-1.6.3
#6.生成
./configure --prefix=/usr/local/nginx-1.6.3 --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module
#7.编译
make
#8.安装
make install
#9.做软链接
ln -s /usr/local/nginx-1.6.3/ /usr/local/nginx
```

以上步骤还只是安装，那还要部署代码呢？修改配置文件？优化？启动？那还工作个毛线啊，一天啥也不用干了，就装`nginx`吧。

***

| 自动化运维时代 |
| --- |

<!-- OCR_START -->
- 程序
- 配置
- 安装
- 同步
- 应用一、批量命令执行
- 应用二、批量安装服务
- 命令
- 应用三、
- 批量配置同步
- 执行
- 应用四、
- 批量任务执行
- 应用五、
- 批量代码部署
- 任务
- 代码
- 部署
- 曾老湿
- DriverZeng
<!-- OCR_END -->

只需要一条命令，搞定100台集群

***

| 自动化运维工具的优势 |
| --- |

<!-- OCR_START -->
- 提高
- 提高效率
- 准确度
- 1.提高工作效率
- 2.提高工作准确度
- 运维
- 3.减少维护成本
- 4.减少重复性工作
- 减少
- 减少重复
- 维护成本
- 性工作
- 曾老湿
- DriverZeng
<!-- OCR_END -->

***

| Ansible的功能及优点 |
| --- |

1.远程执行

批量执行远程命令，可以对多台主机进行远程操作

2.配置管理

批量配置软件服务，可以进行自动化方式配置，服务的统一配置管理，和启停

3.事件驱动

通过Ansible的模块，对服务进行不同的事件驱动

比如：

1）修改配置后重启

2）只修改配置文件，不重启

3）修改配置文件后，重新加载

4）远程启停服务管理

4.管理公有云

通过API接口的方式管理公有云，不过这方面做的不如`saltstack`.

saltstack本身可以通过saltcloud管理各大云厂商的云平台。

5.二次开发

因为语法是Python，所以便于运维进行二次开发。

6.任务编排

可以通过playbook的方式来统一管理服务，并且可以使用一条命令，实现一套架构的部署

7.跨平台，跨系统

几乎不受到平台和系统的限制，比如安装`apache`和启动服务

在Ubuntu上安装apache服务名字叫apache2

在CentOS上安装apache服务名字叫httpd

在CentOS6上启动服务器使用命令：/etc/init.d/nginx start

在CentOS7上启动服务器使用命令：systemctl start nginx

***

| Ansible的架构 |
| --- |

1、连接插件`connection plugins`用于连接主机 用来连接被管理端

2、核心模块`core modules`连接主机实现操作， 它依赖于具体的模块来做具体的事情

3、自定义模块`custom modules`根据自己的需求编写具体的模块

4、插件`plugins`完成模块功能的补充

5、剧本`playbook`ansible的配置文件,将多个任务定义在剧本中，由ansible自动执行

6、主机清单`inventor`定义ansible需要操作主机的范围

最重要的一点是 ansible是模块化的 它所有的操作都依赖于模块

<!-- OCR_START -->
- Ansible架构
- 受控端
- Hostl
- 连接插件，用
- Ansible
- 来连接受控端
- 主机清单
- Connection
- Host2
- Host Inventory
- Plugin
- 核心模块
- 自定义模块
- 插件Plugins
- 任务副本
- Core
- Custom
- Email
- PlayBooks
- Modules
- logging
- HostN
- 曾老湿
- DriverZeng
<!-- OCR_END -->

***

| Ansible的执行流程 |
| --- |

1.Ansible读取playbook剧本，剧本中会记录对哪些主机执行哪些任务。

2.首先Ansible通过主机清单找到要执行的主机，然后调用具体的模块。

3.其次Ansible会通过连接插件连接对应的主机并推送对应的任务列表。

4.最后被管理的主机会将Ansible发送过来的任务解析为本地Shell命令执行。

## 安装Ansible

| 环境准备 |
| --- |

| 主机名 | wanIP | lanIP | 角色 |
| --- | --- | --- | --- |
| m01 | 10.0.0.61 | 172.16.1.61 | Ansible控制端 |
| web01 | 10.0.0.7 | 172.16.1.7 | Ansible被控端 |
| web02 | 10.0.0.8 | 172.16.1.8 | Ansible被控端 |

***

| 安装Ansible |
| --- |

```bash
#1.安装epel源
[root@m01 ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
#2.安装Ansible
[root@m01 ~]# yum install -y ansible
# ansible <host-pattern> [options]
--version   #ansible版本信息
-v          #显示详细信息
-i          #主机清单文件路径，默认是在/etc/ansible/hosts
-m          #使用的模块名称，默认使用command模块
-a          #使用的模块参数，模块的具体动作
-k          #提示输入ssh密码，而不使用基于ssh的密钥认证
-C          #模拟执行测试，但不会真的执行
-T          #执行命令的超时
#3.查看Ansible版本及模块路径
[root@m01 ~]# ansible --version
ansible 2.7.1
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, Apr 11 2018, 07:36:10) [GCC 4.8.5 20150623 (Red Hat 4.8.5-28)]
```

***

| Ansible配置文件读取顺序 |
| --- |

```bash
[root@m01 ~]# vim /etc/ansible/ansible.cfg
# nearly all parameters can be overridden in ansible-playbook
# or with command line flags. ansible will read ANSIBLE_CONFIG,
# ansible.cfg in the current working directory, .ansible.cfg in
# the home directory or /etc/ansible/ansible.cfg, whichever it
# finds first
[root@m01 ~]# rpm -ql ansible
[root@m01 ~]# zcat /usr/share/man/man1/ansible-config.1.gz
#要查看完整列表，请访问https://docs.ansibe.com/或使用ansibe-config命令。
For a full list check \fI\%https://docs.ansible.com/\fP\&. or use the \fIansible\-config\fP command.
#/etc/ansible/ansible.cfg 配置文件，如果存在则使用
/etc/ansible/ansible.cfg \-\- Config file, used if present
#~/.ansible.cfg 用户配置文件，覆盖默认配置（如果存在）
~/.ansible.cfg \-\- User config file, overrides the default config if present
#\&/ansible.cfg 本地配置文件（在当前工作目录中）假定为（aqproject-specific）（aq，如果存在，则重写其余文件）。
\&./ansible.cfg \-\- Local config file (in current working directory) assumed to be \(aqproject specific\(aq and overrides the rest if present.
#如上所述，ANSIBLE_CONFIG环境变量将覆盖所有其他环境变量。
As mentioned above, the ANSIBLE_CONFIG environment variable will override all others.
```

> 1、$ANSIBLE_CONFIG
>
> 2、./ansible.cfg
>
> 3、~/.ansible.cfg
>
> 4、/etc/ansible/ansible.cfg

***

| Ansible配置文件详解 |
| --- |

```bash
[root@m01 ~]# cat /etc/ansible/ansible.cfg 
#inventory      = /etc/ansible/hosts      #主机列表配置文件
#library        = /usr/share/my_modules/  #库文件存放目录
#remote_tmp     = ~/.ansible/tmp          #临时py文件存放在远程主机目录
#local_tmp      = ~/.ansible/tmp          #本机的临时执行目录
#forks          = 5                       #默认并发数
#sudo_user      = root                    #默认sudo用户
#ask_sudo_pass = True                     #每次执行是否询问sudo的ssh密码
#ask_pass      = True                     #每次执行是否询问ssh密码
#remote_port    = 22                      #远程主机端口
host_key_checking = False                 #跳过检查主机指纹
log_path = /var/log/ansible.log           #ansible日志
#普通用户提权操作
[privilege_escalation]
#become=True
#become_method=sudo
#become_user=root
#become_ask_pass=False
```

## Ansible Inventory

`/etc/ansible/hosts`是ansible默认主机资产清单文件，用于定义被管理主机的认证信息， 例如ssh登录用户名、密码以及key相关信息。Inventory文件中填写需要被管理的主机与主机组信息。还可以自定义Inventory主机清单的位置，使用-i指定文件位置即可。

| 场景一：基于密码连接 |
| --- |

```bash
[root@m01 ~]# cat /etc/ansible/hosts
#方式一、IP+端口+用户+密码
[webs]
10.0.0.7 ansible_ssh_port=22 ansible_ssh_user=root ansible_ssh_pass='1'
10.0.0.8 ansible_ssh_port=22 ansible_ssh_user=root ansible_ssh_pass='1'
#方式二、主机名+密码
[webs]
web0[1:2] ansible_ssh_pass='123456'
#方式三、主机+端口+密码
[webs]
web0[1:2]
[webs:vars]
ansible_ssh_pass='123456'
[root@m01 ~]# ansible webs -m ping -i ./hosts
10.0.0.8 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
10.0.0.7 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

***

| 场景二：基于密钥连接，需要先创建公钥和私钥，并下发公钥至被控端 |
| --- |

```bash
#创建秘钥对
[root@m01 ~]# ssh-keygen
#推送公钥
[root@m01 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.7
[root@m01 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.8
```

```bash
#方式一、主机+端口+密钥
[webs]
10.0.0.7:22
10.0.0.8
[root@m01 ~]# ansible webs -m ping -i ./hosts
10.0.0.8 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
10.0.0.7 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
#方式二、别名+主机+端口+密钥
[webs]
web01 ansible_ssh_host=10.0.0.7 ansible_ssh_port=22
web02 ansible_ssh_host=10.0.0.8
[root@m01 ~]# ansible webs -m ping -i ./hosts
web02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

***

| 场景三：主机组使用方式 |
| --- |

```bash
[root@m01 ~]# vim hosts
[db_group]
db01 ansible_ssh_host=10.0.0.51
db02 ansible_ssh_host=10.0.0.52
[web_group]
web01 ansible_ssh_host=10.0.0.7
web02 ansible_ssh_host=10.0.0.8

#查看指定组内主机数量
[root@m01 ~]# ansible web_group -m ping -i ./hosts  --list-host
  hosts (2):
    web01
    web02
[root@m01 ~]# ansible db_group -m ping -i ./hosts  --list-host
  hosts (2):
    db01
    db02
#方式一、主机组变量+主机+密码
[db_group]
db01 ansible_ssh_host=10.0.0.51
db02 ansible_ssh_host=10.0.0.52
[db_group:vars]
ansible_ssh_pass='1'
#方式二、主机组变量+主机+密钥
[web_group]
web01 ansible_ssh_host=10.0.0.7
web02 ansible_ssh_host=10.0.0.8
#定义多组，多组汇总整合
# lnmp组包括两个子组[db,web]
[lnmp:children]
db_group
web_group
#最终配置文件
[root@m01 ~]# cat hosts
[db_group]
db01 ansible_ssh_host=10.0.0.51
db02 ansible_ssh_host=10.0.0.52
[web_group]
web01 ansible_ssh_host=10.0.0.7
web02 ansible_ssh_host=10.0.0.8
[lnmp:children]
db_group
web_group
#查看多组
[root@m01 ~]# ansible all -m ping -i ./hosts  --list-host
  hosts (4):
    db01
    db02
    web01
    web02
[root@m01 ~]# ansible lnmp -m ping -i ./hosts  --list-host
  hosts (4):
    db01
    db02
    web01
    web02
```

> 更新: 2024-09-24 11:14:09  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/xz0k2d>