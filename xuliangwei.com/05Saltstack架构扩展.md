# 05 Saltstack架构扩展

# 05 Saltstack架构扩展

* [1.Salt多Master架构](http://class.xuliangwei.com/15128074896146.html#toc_0)
* [2.Salt Sydic模式架构](http://class.xuliangwei.com/15128074896146.html#toc_1)
* [3.salt无Master架构](http://class.xuliangwei.com/15128074896146.html#toc_2)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

前面所有章节均以单`Master`管理多`Minion`的方式展开讨论, 这一章我们将学习如何扩展`Salt`的架构，解决`Salt`在管理大量的`Minion`时的扩展问题以及`Salt Master`的高可用和高性能问题。

## 1.Salt多Master架构

`Salt`多`Master`架构可以看成`Master->Minion`模式的简单水平扩展,两台`Master`都可以对所有`Minion`进行管理，如下图:

<!-- OCR_START -->
- salt-master-one
- salt-master-two
- salt-minion
<!-- OCR_END -->

`Salt`多`Master`只需要在`minion`端配置多个`Master`地址即可实现

`Salt`支持多`Master`配置，`Salt`多`Master`方式是让一个`minion`可以同时接收两台或多台`master`的管理

因此多个`Master`之间不会有任何感知，也没有状态的同步，所有想做高可用多`Master`架构，需要自己来维护多个`Master`并且要让他们的配置文件、状态文件和密钥文件完全相同

否则仅在`minion`端配置多个`Master`地址是无法实现高可用架构的。

1.启动一台新服务器，安装`salt-master`

```plain
yum install salt-master -y
注意: 不要启动master
```

2.同步旧`Master`的配置文件、状态文件、密钥文件到新`Master`上面

```plain
//配置文件
rsync -avz /etc/salt/master server-two:/etc/salt/
//密钥文件
rsync -avz /etc/salt/pki/master/master.* server-two:/etc/salt/pki/master/
//状态文件
rsync -avz /srv server-two:/
```

3.修改`minion`的配置, 随后重启`minion`

```plain
# vim /etc/salt/minion
master:
  - server-one
  - server-two
# systemctl restart salt-minion
```

4.启动新的`master`服务, 在`server-two`上执行, 并执行命令测试

```plain
systemctl start salt-master
salt-key -A -y  
salt '*' test.ping
```

注意: 如果生产环境中配置多`master`需要注意多`master`之间的配置文件、状态文件和密钥文件的实时同步问题，可以使用`rsync+inotify`或`sersync`方式完成实时同步, 实现的脚本思路(low)

```plain
[root@salt0-master scripts]# cat rsync_salt.sh 
#!/usr/bin/bash
Srv_Config=/srv
Master_Config=/etc/salt/master
Master_New=192.168.70.151
Date=$(date +%F-%T)
rsync -avz --delete $Srv_Config  $Master_New:/ &>/dev/null && \
rsync -avz --delete $Master_Config $Master_New:$Master_Config &>/dev/null
        if [ $? -eq 0 ];then
                echo "$Date Rsync Salt Config Is Ok!"
        else
                echo "$Date Rsync Salt Config Is Err!"
        fi
```

## 2.Salt Sydic模式架构

前面我们了解了多Master的方式避免`salt-master`的单点故障，以解决Salt高可用问题。那如果我们管理主机的数量非常巨大，那一台`Master`性能就会出现问题，这个时候就需要对`Salt`进行扩展，用`Syndic`的方式可以完成多级扩展，`Syndic`的扩展架构如下图所示

<!-- OCR_START -->
- salt-master
- salt-master-two
- 蒋先生
- 小蒋
- salt-syndic
- 浩南
- 山鸡
- 大飞
- salt-minionsalt-minion
<!-- OCR_END -->

SaltStack-Syndic

> 1.Salt Syndic 必须运行在一个Master上
>
> 2.Syndic要连接上游的Master

1.配置顶级`Master`服务器`master-蒋先生`

```plain
yum install salt-master
vim /etc/salt/master
order_masters: True
systemctl restart salt-master
```

2.配置`syndic`服务器`syndic-陈浩南`

```plain
yum install salt-syndic
vim /etc/salt/master
syndic_master: 
  - 192.168.56.11
systemctl start salt-master
systemctl start salt-syndic
```

3.配置下级minion服务器

```plain
# yum install salt-minion
# vim /etc/salt/minion
master: syndic-one
# systemctl restart salt-minion
注意: 如果之前已经添加过受信任的Master需要删除对应的key
# rm -f /etc/salt/pki/minion/minion_master.pub
# systemctl restart salt-minion
```

4.测试`master`服务器通过`syndic`管理`minion`

```plain
在syndic服务器上接收所有minion的key
# salt-key -L
#在上级master上执行命令, 测试有syndic管理的minion是否可以正常管理
salt 'minion-syndic-one' test.ping
```

`syndic`本身还可以进行更多级的扩展, 通过`syndic`和多`master`的配合可以让Salt的架构变得更加灵活和可扩展性，可以应对更多的服务器管理

重点: `Syndic`的`file_roots、Pillar_roots`必须与高级`Master`一致

缺点: 高级的`Master`并不知道自己有多少`Minion`，仅知道有多少`syndic`

## 3.salt无Master架构

`Salt`脱离`Master`独立运行，这种状态可以称为无`master`的`salt`

这种模式可以用于登陆`minion`后的一些调试任务，可以将状态文件配置在本地进行执行

1.配置`salt minion`为本地执行方式

```plain
[root@salt1-minion ~]# vim /etc/salt/minion
file_client: local
file_roots:
  base:
    - /srv/salt/base
pillar_roots:
[root@salt1-minion ~]# systemctl restart salt-minion
```

2.编写`SLS`状态文件

```plain
[root@salt1-minion ~]# cat /srv/salt/base/init/dns.sls 
dns-config:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://init/files/resolv.conf.template
    - user: root
    - group: root
    - mode: 644
    - backup: minion
```

3.使用`salt-call`执行本地安装

```plain
salt-call --local state.sls init.dns
salt-call --local state.highstate  #必须有topfile
```

4.`Salt SSH`实现无`Master`管理`minion`

安装`salt-ssh`

```plain
[root@salt0-master ~]# yum install salt-ssh -y
[root@salt0-master ~]# salt-ssh --version
salt-ssh 2018.3.0 (Oxygen)
```

配置`/etc/salt/roster`文件

```plain
# Sample salt-ssh config file
#web1:
#  host: 192.168.42.1 # IP地址
#  user: fred         # 用户名
#  passwd: foobarbaz  # 密码
#  sudo: True         # 是否sudo到root
# priv: /etc/salt/pki/master/ssh/salt-ssh.rsa #私钥路径
# timeout:5  #超时时间
```

密码方式: 通过密码方式配置演示`salt-ssh`使用方式

```plain
[root@salt0-master ~]# vim /etc/salt/roster
test:
  host: 192.168.56.11
  user: root
  passwd: 123456
  port: 22
[root@salt0-master ~]# salt-ssh -H
/etc/salt/roster:
    ----------
    web-node1:
        192.168.70.171
        
[root@salt0-master ~]# salt-ssh '*' cmd.run 'df -h'
```

密钥方式: 通过密钥方式配置演示`salt-ssh`

```plain
[root@salt0-master ~]# vim /etc/salt/roster
test:
  host: 192.168.56.11
  user: root
  priv: /etc/salt/pki/master/ssh/salt-ssh.rsa
  port: 22
[root@salt0-master ~]# salt-ssh -H          
/etc/salt/roster:
    ----------
    web-node1:
        192.168.70.171
    web-node2:
        192.168.70.172
        
[root@salt0-master ~]# salt-ssh '*' cmd.run "df -h"
```

第一次运行需要输入密码复制公钥到目标服务器,后续在执行任何远程命令时都会使用密钥进行认证。

`Salt-ssh`的使用

> 1.salt-ssh可以进行目标匹配、远程执行模块使用、状态管理的使用、highstate高级状态应用
>
> 2.salt-ssh基本可以实现Salt大部分功能,在不方便部署Salt minion的特殊环境可以使用salt-ssh来实施配置管理

> 更新: 2019-03-21 09:17:44  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/mvikbe>