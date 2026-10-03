# 第三章·自动化运维工具-Ansible PlayBook

## Ansible PlayBook初识

| 什么是PlayBook |
| --- |

`PlayBook`即"剧本"，"兵书"之意，PlayBook是由以下部分组成的

`play`: 定义的是主机的角色。（主角还是配角）

`task`: 定义的是具体执行的任务。（角色的台词和动作）

`playbook`: 由一个或多个play（角色）组成，一个play（角色）可以包含多个task（台词，动作）。

*简单理解为: 使用不同的模块完成一件事情*

***

**在**`**Ansible**`\*\*中"剧本文件"是以yml结尾的文件。\
\*\***在**`**SaltStack**`\*\*中"剧本文件"是以sls结尾的文件。\
\*\***但是语法，使用的都是**`**yaml**`**语法**

***

<!-- OCR_START -->
- Playbook组成
- hosts:all
- playbook
- remote user:root
- vars:
- play
- file_name:zls
- tasks:
- task
- -name:touch new files
- shell:touch/tmp/{filename）
- 曾老湿
- DriverZeng
<!-- OCR_END -->

***

| PlayBook与ad-hoc |
| --- |

| 特点 | PlayBook | ad-hoc |
| --- | --- | --- |
| 完整性 | √ | ✘ |
| 持久性 | √ | ✘ |
| 执行效率 | 低 | 高 |
| 变量 | 支持 | 不支持 |
| 耦合度 | 低 | 高 |

1.`PlayBook`功能比`ad-hoc`更全，是对`ad-hoc`的一种编排.

2.`PlayBook`能很好的控制先后执行顺序, 以及依赖关系.

3.`PlayBook`语法展现更加的直观.

4.`playbook`可以持久使用,`ad-hoc`无法持久使用.

***

| YAML语法 |
| --- |

| 语法 | 描述 |
| --- | --- |
| 缩进 | YAML使用固定的缩进风格表示层级结构,每个缩进由两个空格组成, 不能使用TAB |
| 冒号 | 以冒号结尾的除外,其他所有冒号后面所有必须有空格 |
| 短横线 | 表示列表项,使用一个短横杠加一个空格,多个项使用同样的缩进级别作为同一列表 |

```yaml
yum:
  name: vsftpd
  state: present
  
yum:
  name:
    - httpd
    - nginx
    - php-fpm
  state: present
```

***

| PlayBook—《孙子兵法》编写 |
| --- |

host：对哪些主机进行操作（演员）

remote_user：使用什么用户执行（通行证）

tasks：具体执行任务（台词和动作）

示例：

```yaml
[root@m01 ~]# cat foo.yml
---
- hosts: all
  remote_user: root
  vars:
    file_name: zls.txt
  tasks:
    - name: Create New File
      file: name=/tmp/{{ file_name }} state=touch
```

## PlayBook部署httpd小练习

| 编写httpd剧本 |
| --- |

```yaml
#创建目录剧本存放目录
[root@m01 ~]# mkdir httpd
#编辑Inventory
[root@m01 ~]# vim /etc/ansible/hosts
[web_group]
web01 ansible_ssh_host=10.0.0.7
web02 ansible_ssh_host=10.0.0.8
```

**需求一：编写安装httpd剧本**

```yaml
[root@m01 ~]# vim /root/httpd/httpd.yml
---
- hosts: web_group
  tasks:
    - name: Install httpd Server
      yum:
        name: httpd
        state: present
#检查语法
[root@m01 ~]# ansible-playbook --syntax-check httpd/httpd.yml
playbook: httpd/httpd.yml
        
#测试安装
[root@m01 ~]# ansible-playbook -C httpd/httpd.yml
PLAY [web_group] ***************************************************************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] *********************************************************************************************************************************************************************************************************************************************************
ok: [web02]
ok: [web01]
TASK [Install httpd Server] ****************************************************************************************************************************************************************************************************************************************************
changed: [web02]
changed: [web01]
PLAY RECAP *********************************************************************************************************************************************************************************************************************************************************************
web01                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

**需求二：安装完httpd服务并启动加入开机自启**

```yaml
[root@m01 ~]# vim /root/httpd/httpd.yml
---
- hosts: web_group
#安装httpd
  tasks:
    - name: Install httpd Server
      yum:
        name: httpd
        state: present
#启动httpd
    - name: Start Httpd Server
      systemd:
        name: httpd
        state: started
        enabled: yes
#测试安装和启动
[root@m01 ~]# ansible-playbook -C httpd/httpd.yml
PLAY [web_group] ***************************************************************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] *********************************************************************************************************************************************************************************************************************************************************
ok: [web02]
ok: [web01]
TASK [Install httpd Server] ****************************************************************************************************************************************************************************************************************************************************
changed: [web02]
changed: [web01]
TASK [Start Httpd Server] ******************************************************************************************************************************************************************************************************************************************************
changed: [web02]
changed: [web01]
PLAY RECAP *********************************************************************************************************************************************************************************************************************************************************************
web01                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

**需求三：编写网站页面并启动**

```yaml
---
- hosts: web_group
#安装httpd
  tasks:
    - name: Install httpd Server
      yum:
        name: httpd
        state: present
#配置网站
    - name: Config Httpd Server
      copy:
        content: zls_web_page
        dest: /var/www/html/index.html
#启动httpd
    - name: Start Httpd Server
      systemd:
        name: httpd
        state: started
        enabled: yes
#执行
[root@m01 httpd]# ansible-playbook /root/httpd/httpd.yml
```

**需求四：开启防火墙端口**

```yaml
---
- hosts: web_group
#安装httpd
  tasks:
    - name: Install httpd Server
      yum:
        name: httpd
        state: present
#配置网站
    - name: Config Httpd Server
      copy:
        content: zls_web_page
        dest: /var/www/html/index.html
#启动httpd
    - name: Start Httpd Server
      systemd:
        name: httpd
        state: started
        enabled: yes
#启动防火墙
    - name: Start Firewalld Server
      systemd:
        name: firewalld
        state: started
        enabled: yes
#开启防火墙的80端口
    - name: Config Firewalld Server
      firewalld:
        service: http
        immediate: yes
        permanent: yes
        state: enabled
```

打开浏览器访问网站：

<http://10.0.0.7>

<http://10.0.0.8>

<!-- OCR_START -->
- Chrome
- 文件
- 编辑
- 视图
- 历史记录
- 书签
- 用户
- 窗口
- 帮助
- 10.0.0.8
- ）不安全10.0.0.8
- 应用
- zabbix-api
- zls_web_page
- 10.0.0.7
- 不安全10.0.0.7
- 曾老湿
<!-- OCR_END -->

**需求五：不同的主机配置不同的网站**

目前来说，想要根据不同主机配置不同的网站，我们可以使用多个play的方式，但是在生产环境中，我们需要写循环，来满足我们的需求，多个play**了解即可**

```yaml
---
- hosts: web_group
#安装httpd
  tasks:
    - name: Install httpd Server
      yum:
        name: httpd
        state: present
#启动httpd
    - name: Start Httpd Server
      systemd:
        name: httpd
        state: started
        enabled: yes
#启动防火墙
    - name: Start Firewalld Server
      systemd:
        name: firewalld
        state: started
        enabled: yes
#开启防火墙的80端口
    - name: Config Firewalld Server
      firewalld:
        service: http
        immediate: yes
        permanent: yes
        state: enabled
#单独配置web01页面
- hosts: web01
  tasks:
    - name: Config Httpd Server
      copy:
        content: zls_web01_page
        dest: /var/www/html/index.html
#单独配置web02页面
- hosts: web02
  tasks:
    - name: Config Httpd Server
      copy:
        content: zls_web02_page
        dest: /var/www/html/index.html
[root@m01 httpd]# ansible-playbook  /root/httpd/httpd.yml
```

打开浏览器访问网站：

<http://10.0.0.7>

<http://10.0.0.8>

<!-- OCR_START -->
- Chrome
- 文件
- 编辑
- 视图
- 历史记录
- 书签
- 用户
- 窗口
- 帮助
- 10.0.0.7
- ①不安全10.0.0.7
- 应用
- zabbix-api
- zls_web01_page
- 10.0.0.8
- 不安全10.0.0.8
- zls_web02_page
- 曾老湿
- DriverZeng
<!-- OCR_END -->

## PlayBook实战

| 实战一：《孙子兵法-九变篇》之"未雨绸缪,严阵以待" |
| --- |

emmmm...说白了就是实现一个`backup`备份服务器的服务端和客户端的部署.

***1.演员表***

| 主机名 | wanIP | lanIP | 服务 | 角色 |
| --- | --- | --- | --- | --- |
| m01 | 10.0.0.61 | 172.16.1.61 | Ansible | 控制端（导演） |
| backup | 10.0.0.41 | 172.16.1.41 | rsync服务端 | 被控端（男一） |
| web01 | 10.0.0.7 | 172.16.1.7 | rsync客户端 | 被控端（女二） |
| web02 | 10.0.0.8 | 172.16.1.8 | rsync客户端 | 被控端（女二） |

***2.战前准备***

灯光，音响，摄像准备...

yum源，用户，配置文件...

```yaml
#创建rsync剧本存放目录
[root@m01 ~]# mkdir rsyncd
#编辑Inventory
[root@m01 ~]# vim /etc/ansible/hosts
[web_group]
web01 ansible_ssh_host=10.0.0.7
web02 ansible_ssh_host=10.0.0.8
[backup_group]
backup ansible_ssh_host=10.0.0.41
#准备rsync配置文件
[root@m01 rsyncd]# vim /root/rsyncd/rsyncd.j2
uid = www
gid = www
port = 873
fake super = yes
use chroot = no
max connections = 200
timeout = 600
ignore errors
read only = false
list = false
auth users = rsync_backup
secrets file = /etc/rsync.passwd
log file = /var/log/rsyncd.log
#####################################
[backup]
comment = welcome to oldboyedu backup!
path = /backup
```

***3.编写剧本***

```yaml
#编写剧本
[root@m01 ~]# vim /root/rsyncd/rsyncd.yml
- hosts: all
  tasks:
#安装rsync
    - name: Install Rsyncd Server
      yum:
        name: rsync
        state: present
#创建www组
    - name: Create www Group
      group:
        name: www
        gid: 666
#创建www用户
    - name: Create www User
      user:
        name: www
        group: www
        uid: 666
        create_home: false
        shell: /sbin/nologin
- hosts: backup_group
  tasks:
#推送rsync配置文件
    - name: Scp Rsync Config
      copy:
        src: ./rsyncd.j2
        dest: /etc/rsyncd.conf
        owner: root
        group: root
        mode: 0644
        
#创建密码文件并授权
    - name: Create Passwd File
      copy:
        content: 'rsync_backup:123'
        dest: /etc/rsync.passwd
        owner: root
        group: root
        mode: 0600
#创建/backup目录
    - name: Create backup Directory
      file:
        path: /backup
        state: directory
        mode: 0755
        owner: www
        group: www
        recurse: yes
#启动rsync服务
    - name: Start Rsyncd Server
      systemd:
        name: rsyncd
        state: started
#检测语法
[root@m01 ~]# ansible-playbook --syntax-check /root/rsyncd/rsyncd.yml
playbook: /root/rsyncd/rsyncd.yml
#测试
[root@m01 ~]# ansible-playbook -C /root/rsyncd/rsyncd.yml
PLAY [all] ***********************************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************
ok: [backup]
ok: [web02]
ok: [web01]
TASK [Install Rsyncd Server] *****************************************************************************************************************************************************************************************************************
changed: [backup]
changed: [web02]
changed: [web01]
TASK [Scp Rsync Config] **********************************************************************************************************************************************************************************************************************
changed: [web02]
changed: [web01]
changed: [backup]
TASK [Create www Group] **********************************************************************************************************************************************************************************************************************
changed: [backup]
changed: [web01]
changed: [web02]
TASK [Create www User] ***********************************************************************************************************************************************************************************************************************
changed: [web02]
changed: [web01]
changed: [backup]
TASK [Create backup Directory] ***************************************************************************************************************************************************************************************************************
changed: [web01]
changed: [backup]
changed: [web02]
TASK [Start Rsyncd Server] *******************************************************************************************************************************************************************************************************************
changed: [web01]
changed: [web02]
changed: [backup]
PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
backup                     : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

**扩展需求：**

1.给客户端推送脚本

2.加入crontab做备份

完成刚开始学架构阶段的rsync的实战案例

***

| 实战二：《孙子兵法-虚实篇》之"空城计" |
| --- |

好吧，说白了，就是部署`NFS`服务，`NFS`服务端，敞开大门提供挂载点给`web01`和`web02`

<!-- OCR_START -->
- 活该一辈子
- 有素质有文化
- 曾老湿
- DriverZeng
<!-- OCR_END -->

***1.演员表***

| 主机名 | wanIP | lanIP | 服务 | 角色 |
| --- | --- | --- | --- | --- |
| m01 | 10.0.0.61 | 172.16.1.61 | Ansible | 控制端（导演） |
| nfs | 10.0.0.31 | 172.16.1.31 | nfs服务端 | 被控端（男一） |
| web01 | 10.0.0.7 | 172.16.1.7 | nfs客户端 | 被控端（女二） |
| web02 | 10.0.0.8 | 172.16.1.8 | nfs客户端 | 被控端（女二） |

***2.战前准备***

```yaml
#编辑Ansible Inventory
[root@m01 ~]# vim /etc/ansible/hosts
[web_group]
web01 ansible_ssh_host=10.0.0.7
web02 ansible_ssh_host=10.0.0.8
[backup_group]
backup ansible_ssh_host=10.0.0.41
[nfs_group]
nfs ansible_ssh_host=10.0.0.31
[nfs_all:children]
web_group
nfs_group
#创建项目存放目录
[root@m01 ~]# mkdir nfs
#准备nfs配置文件
[root@m01 ~]# cat /root/nfs/nfs.j2
/data 10.0.0.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
```

***3.编写剧本***

```yaml
[root@m01 ~]# vim /root/nfs/nfs.yml
- hosts: nfs_all
  tasks:
#安装nfs
    - name: Install nfs-utils
      yum:
        name: nfs-utils
        state: present
#创建www组
    - name: Create www Group
      group:
        name: www
        gid: 666
#创建www用户
    - name: Create www User
      user:
        name: www
        group: www
        uid: 666
        create_home: false
        shell: /sbin/nologin
- hosts: nfs
  tasks:
#推送配置文件
    - name: Scp NFS Server
      copy:
        src: ./nfs.j2
        dest: /etc/exports
        owner: root
        group: root
        mode: 0644
#创建挂载目录并授权
    - name: Create data Directory
      file:
        path: /data
        state: directory
        owner: www
        group: www
        mode: 0755
        recurse: yes
#启动nfs-server
    - name: Start NFS Server
      systemd:
        name: nfs-server
        state: started
        enabled: yes
#web01和web02挂载目录
- hosts: web_group
  tasks:
    - name: Mount NFS Server
      mount:
        path: /opt
        src: 10.0.0.31:/data
        fstype: nfs
        opts: defaults
        state: mounted
#检查语法
[root@m01 ~]# ansible-playbook --syntax-check /root/nfs/nfs.yml
playbook: /root/nfs/nfs.yml
#执行
[root@m01 ~]# ansible-playbook /root/nfs/nfs.yml
```

**查看web01和web02的挂载情况**

***

<!-- OCR_START -->
- iTerm2
- Shell
- Edit
- View
- Session
- Scripts
- Profiles
- Toolbelt
- Window
- Help
- root@m01:~(ssh)
- 81
- root@web02:~(ssh)
- 82
- root@backup:~（ssh）83
- root@nfs:~(ss
- 文件系统
- 容量
- 已用
- 可用
- 已用%挂载点
- /dev/sda3
- 18G
- 1.2G
- 17G
- 7% /
- devtmpfs
- 981M
- 0% /dev
- tmpfs
- 992M
- 0%/dev/shm
- 9.5M
- 982M
- 1% /run
- 0% /sys/fs/cgroup
- /dev/sda1
- 1014M
- 124M
- 891M
- 13%/boot
- 199M
- 0%/run/user/0
- 10.0.0.31:/data
- 1.1G
- 6% /opt
- [root@web02~]#
- Xroot@web01:~（ssh)
- [root@web01~]#df-h
- tmnfs
- [root@web01~]#
- 曾老湿
- DriverZeng
<!-- OCR_END -->

**扩展需求：**

1.给web01和web02部署 提交作业代码

2.部署nfs，并挂载/var/www/html/upload目录

***

| 实战二：《孙子兵法-始计篇》之"兵者，诡道也" |
| --- |

使用`playbook`实现一套`LAMP`架构。

部署需求：

1.使用yum安装httpd、php、php-mysql、php-pdo、mariadb

2.启动httpd、mariadb服务

3.下载wordpress代码

4.部署到httpd站点目录

***1.演员表***

| 主机名 | wanIP | lanIP | 服务 | 角色 |
| --- | --- | --- | --- | --- |
| m01 | 10.0.0.61 | 172.16.1.61 | Ansible | 控制端（导演） |
| web01 | 10.0.0.7 | 172.16.1.7 | nfs客户端 | 被控端（男一） |
| web02 | 10.0.0.8 | 172.16.1.8 | nfs客户端 | 被控端（男一） |

**gay里gay气**

***2.战前准备***

因为这只是一个练习，所以我们将apache mariadb php全部都写在一个yml文件中，并且放在一个目录下，

注意：在生产中，我们是不会这么做的，我们需要每一个服务单独拎出来，解耦。

```yaml
#创建项目目录
[root@m01 ~]# cd lamp/
#编辑Inventory
[root@m01 lamp]# cat /etc/ansible/hosts
[web_group]
web01 ansible_ssh_host=10.0.0.7
web02 ansible_ssh_host=10.0.0.8
[backup_group]
backup ansible_ssh_host=10.0.0.41
[backup_all:children]
web_group
backup_group
[nfs_group]
nfs ansible_ssh_host=10.0.0.31
[nfs_all:children]
web_group
nfs_group
```

***3.编写剧本***

```yaml
[root@m01 ~]# vim /root/lamp/lamp.yml
- hosts: web_group
  tasks:
#安装指定服务
    - name: Install httpd  mariadb php Server
      yum:
        name: "{{ packages }}"
      vars:
        packages:
        - httpd
        - mariadb-server
        - php
        - php-mysql
        - php-pdo
#启动httpd服务
    - name: Start httpd Server
      systemd:
        name: httpd
        state: started
        enabled: yes
#启动mariadb服务
    - name: Start httpd Server
      systemd:
        name: mariadb
        state: started
        enabled: yes
#下载wordpress
    - name: Get Wordpress Package
      get_url:
        url: "http://test.driverzeng.com/Nginx_Code/wordpress-5.0.3-zh_CN.tar.gz"
        dest: /var/www/html
#解压wordpress
    - name: Unarchive Wordpress Package
      unarchive:
        src: /var/www/html/wordpress-5.0.3-zh_CN.tar.gz
        dest: /var/www/html
        copy: no
#检查语法
[root@m01 lamp]# ansible-playbook --syntax-check /root/lamp/lamp.yml
playbook: /root/lamp/lamp.yml
#执行
[root@m01 lamp]# ansible-playbook  /root/lamp/lamp.yml
```

打开浏览器访问：

<http://10.0.0.7/wordpress/wp-admin/setup-config.php>

<http://10.0.0.8/wordpress/wp-admin/setup-config.php>

<!-- OCR_START -->
WordPress）调整配置文件
→C不安全|10.0.0.7/wordpress/wp-admin/setup-config.php
应用zabbix-api
C不安全|10.0.0.8/wordpress/wp-admin/setup-config.php
欢迎使用WordPress。在开始前，我们需要您数据库的一些信息。请准备好如下信息。
1.数据库名
2.数据库用户名
3.数据库密码
4.数据库主机
5.数据表前缀（tableprefix，特别是当您要在一个数据库中安装多个WordPress时）
我们会使用这些信息来创建一个wp-config.php文件。如果自动创建未能成功，不用担心，您要做的只是将数
据库信息填入配置文件。您也可以在文本编辑器中打开wp-config-sample.php，填入您的信息，并将其另存
为wp-config.php。需要更多帮助？看这里。
绝大多数时候，您的网站服务提供商会给您这些信息。如果您没有这些信息，在继续之前您将需要联系他们。如果
您准备好了.…
现在就开始！
Dri增e老湿ng
<!-- OCR_END -->

**扩展需求：**

1.使用php连接数据库

2.使用Ansible创建数据库`wordpress`

```yaml
#类似于：
create database wordpress
```

3.使用Ansible创建数据库用户`wordpress`

```yaml
#类似于：
grant all on *.* to wordpress@'%' identified by 'zls';

```

> 更新: 2024-09-24 16:58:56  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/rmae72>