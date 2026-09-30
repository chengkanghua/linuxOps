



## [](#dhkqmh)功能需求完成表
![](img/%E7%BB%BC%E5%90%88%E6%9E%B6%E6%9E%84%20ansible-playbook-01.png)



## [](#gfhsdk)主机规划 ip


```plain
服务器主机名和 IP 规划参考模板如下表 4：
主机名  eth0 网卡     eth1 网卡      服务简介
lb01    10.0.0.5/24   172.16.1.5/24  负载服务
lb02    10.0.0.6/24   172.16.1.6/24  负载服务
web01   10.0.0.7/24   172.16.1.7/24  动态 www 服务
web02   10.0.0.8/24   172.16.1.8/24  动态 www 服务
web03   10.0.0.9/24   172.16.1.9/24  tomcat 服务
db01    10.0.0.51/24  172.16.1.51/24  数据库服务
db02    10.0.0.52/24  172.16.1.52/24  数据库从库
db03    10.0.0.53/24  172.16.1.53/24  数据库从库
nfs01   10.0.0.31/24  172.16.1.31/24  存储服务
backup  10.0.0.41/24  172.16.1.41/24  备份服务
m01     10.0.0.61/24  172.16.1.61/24  管理服务
zabbix  10.0.0.71/24  172.16.1.71/24  监控服务
```



## [](#o8nyei)统一操作  基础优化
---

```bash
#修改ip地址
sed -i 's#222#61#g' /etc/sysconfig/network-scripts/ifcfg-eth[01]

永久修改主机名
[root@oldboy-c7 ~]# hostnamectl set-hostname backup
[root@web01 data]# vim /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.16.1.5  lb01
172.16.1.6  lo02
172.16.1.7  web01
172.16.1.8  web02
172.16.1.9  web03
172.16.1.31  nfs
172.16.1.41  backup
172.16.1.51  db
172.16.1.52  db02
172.16.1.53  db03
172.16.1.71  zabbix
172.16.1.62  m02

#批量推送其他主机
[root@web01 data]# scp -rp /etc/hosts root@172.16.1.31:/etc/

调整yum源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

#1.安装基础软件包
yum install net-tools vim tree htop iftop iotop lrzsz sl wget unzip telnet nmap nc psmisc dos2unix bash-completion iotop iftop sysstat screen yum-plugin-priorities.noarch net-tools zip -y


1.自动补全
yum install bash-completion -y
退出一次，然后重新登录
安装net-tools工具，可使用ifconfig命令
yum install net-tools -y 

//2.关闭firewalld防火墙
systemctl disable firewalld
systemctl stop firewalld
systemctl status firewalld

//3.关闭selinux
# 方式一
sed -ri 's#(^SELINUX=).*#\1disabled#g' /etc/selinux/config
# 方式二
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config
# 方式三
vim /etc/selinux/config

# 临时生效
setenforce 0  

//4.优化ulimit
echo '* - nofile 65535' >> /etc/security/limits.conf

//5 重启快照
```





---

### [](#utkwlb)客户端指向本地yum源
```bash
[root@yum_client_69_113 ~]# vim /etc/yum.repos.d/centos7.repo 
[centos75]
name=centos74_base
baseurl=ftp://172.16.1.61/centos75
gpgcheck=0
enabled=1
priority=1

[root@yum_client_69_113 ~]# vim /etc/yum.repos.d/ops.repo 
[ops]
name=local ftpserver
baseurl=ftp://172.16.1.61/ops
gpgcheck=0
enabled=1
priority=2

#阿里的epel 源 三段加优先级3  priority=3
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
[root@backup yum.repos.d]# vim epel.repo
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
baseurl=http://mirrors.aliyun.com/epel/7/$basearch
failovermethod=priority
enabled=1
priority=3

yum clean all
yum makecache

#其他客户端同步推送过去
[root@backup yum.repos.d]# rsync -avz --delete /etc/yum.repos.d root@172.16.1.31:/etc/
```



## [](#erudyt)m01  搭建yum仓库
```bash
1.基础环境准备
//安装ftp服务,启动并加入开机启动
 yum -y install vsftpd 
 systemctl start vsftpd 
 systemctl enable vsftpd

//开启yum缓存功能
 vim /etc/yum.conf
[main] cachedir=/var/cache/yum/$basearch/$releasever 
keepcache=1

 yum clean all

2.提供基础base源
 mkdir /var/ftp/centos75
 mount /dev/cdrom /mnt
 cp -rp  /mnt/Packages/*.rpm /var/ftp/centos75

3.提供第三方源
mkdir /var/ftp/ops

yum install net-tools vim tree htop iftop \
iotop lrzsz sl wget unzip telnet nmap nc psmisc \
dos2unix bash-completion iotop iftop sysstat screen  -y


//移动已缓存的 Nginx docker 及依赖包 到自定义 YUM 仓库目录中
[root@yum_server_69_112 ~]# find /var/cache/yum/x86_64/7/ \
-iname "*.rpm" -exec mv -rf {} /var/ftp/ops \;


4.安装createrepo并创建 reopdata仓库

//安装createrepo
[root@yum_server_69_112 ~]# yum -y install createrepo
//生成仓库信息
createrepo /var/ftp/ops
createrepo /var/ftp/centos75
//注意: 如果此仓库每次新增软件则需要重新生成一次


客户端使用yum源

1.配置并使用base基础源

[root@yum_client_69_113 ~]# gzip /etc/yum.repos.d/*
[root@yum_client_69_113 ~]# vim /etc/yum.repos.d/centos7.repo 
[centos75]
name=centos74_base
baseurl=ftp://172.16.1.61/centos75
gpgcheck=0
2.客户端指向本地ops源

[root@yum_client_69_113 ~]# vim /etc/yum.repos.d/ops.repo 
[ops]
name=local ftpserver
baseurl=ftp://172.16.1.61/ops
gpgcheck=0


yum clean all
yum makecache


#其他客户端同步推送过去
[root@backup ~]# rsync -avz /etc/yum.repos.d root@172.16.1.6:/etc/ --delete
```

## [](#og1gom)SSH、Ansible,批量管理服务项目  
```bash
[root@backup ~]# rpm -ql openssh-server
/etc/ssh/sshd_config    --- ssh服务配置文件
/usr/sbin/sshd          --- ssh服务进程启动命令

[root@backup ~]# rpm -ql openssh-clients
/usr/bin/scp            --- 远程拷贝命令
/usr/bin/sftp           --- 远程文件传输命令
/usr/bin/ssh            --- 远程连接登录命令
/usr/bin/ssh-copy-id    --- 远程分发公钥命令


1.创建密钥对
[root@m01 ~]# ssh-keygen -t rsa -C xuliangwei.com   #一路回车即可
[root@m01 ~]# ls ~/.ssh/
id_rsa(钥匙)  id_rsa.pub(锁头)

2#发送密钥给需要登录的用户
[root@m01 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.31
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.41
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.31
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.7
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.8
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.9
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.5
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.6
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.51
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.52
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.53
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.71



#远程登录对端主机方式
[root@m01 ~]# ssh root@172.16.1.41

# 不登陆主机执行命令
[root@m01 ~]# ssh root@172.16.1.41 "hostname -i"

#安装 ansible
[root@m01 ~]# yum install ansible -y

//检查ansible版本
[root@m01 ~]# ansible --version
ansible 2.6.1

配置ansible  主机清单
[root@m01 ~]# vim /etc/ansible/hosts
[root@m01 7]# cat /etc/ansible/hosts
[lb01]
172.16.1.5
[lb02]
172.16.1.6
[web]
172.16.1.7
172.16.1.8
[web03]
172.16.1.9
[nfs]
172.16.1.31
[backup]
172.16.1.41
[db]
172.16.1.51
[db02]
172.16.1.52
172.16.1.53
[db03]
172.16.1.53
[zabbix]
172.16.1.71

# ansible是通过ssh端口探测通信
[root@m01 ~]# ansible all -m ping

#批量执行命令
[root@m01 ~]# ansible all -m command -a "df -h"
[root@m01 ~]# ansible all -m command -a "hostname"
```



## [](#zgqffb)ansible-playbook 目录结构
```plain
[root@m01 playbook]# tree /root/playbook
/root/playbook
├── backup.yaml                     #备份服务器
├── base.yaml                       #基础剧本
├── conf                            #各种配置存放目录
│   ├── conf.tar.gz                 # nginx 的conf目录打包
│   ├── confxml.xml                 # sersync 配置文件
│   ├── exports                     # nfs共享配置文件
│   ├── jpress.conf                 # mailx 软件的配置文件
│   ├── mail.rc                     # 数据库
│   ├── my.cnf                      # mysql配置文件
│   ├── nginx.conf                  # nginx主配置文件
│   ├── php.ini                     # php 配置文件
│   ├── resolv.conf                 # dns 配置文件
│   ├── rsyncd.conf                 # rsyncd 配置 
│   ├── server.xml                  # tomcat server.xml 配置
│   └── www.conf                    # php配置文件
├── file
│   ├── 2018-10-2214-mysql-all.sql   # 数据全备份文件
│   ├── code.tar.gz                  # 源码包 
│   ├── contos75.repo
│   ├── kaoshi.zip
│   ├── ops.repo
│   ├── sersync2.5.4_64bit_binary_stable_final.tar.gz
│   ├── ssl_key.zip                 # ssl 加密证书文件
│   └── tomcat.tar.gz               # 配置好的tomcat程序
├── keepalived02.yaml               
├── keepalived.yaml
├── lb                              #nginx proxy 代理机器的配置文件
│   ├── blog_proxy.conf         
│   ├── ds.conf
│   ├── jpress_proxy.conf
│   ├── keepalived2.conf
│   ├── keepalived.conf
│   ├── nginx.conf
│   ├── proxy-https.conf
│   ├── proxy_params
│   └── zh_proxy.conf
├── lb.yaml
├── mail.yaml
├── mysql.yaml
├── nfs.yaml
├── scripts
│   ├── lb_check_web.sh
│   ├── mysql.sh
│   ├── rsync_backup_md5.sh
│   ├── rsync_check_backup.sh
│   └── tomcat_start.sh
├── sersync.yaml
├── web03.yaml
└── web.yaml
```

## [](#2vtqso)base.yaml
```yaml
- hosts: all
  tasks:
#    - name: Clear yum.repos.d
#      file: path=/etc/yum.repos.d/ state=absent
#
#    - name: Create yum.repos.d
#      file: path=/etc/yum.repos.d/ state=directory

#    - name: install aliyun base
#      get_url: url=http://mirrors.aliyun.com/repo/Centos-7.repo dest=/etc/yum.repos.d/CentOS-Base.repo
#
#    - name: install aliyun epel
#      get_url: url=http://mirrors.aliyun.com/repo/epel-7.repo dest=/etc/yum.repos.d/epel.repo
#
#    - name: Push centos75
#      copy: src=./file/contos75.repo  dest=/etc/yum.repos.d/
#
#    - name: Push ops
#      copy: src=./file/ops.repo  dest=/etc/yum.repos.d/
#
#    - name: Dns Client
#      copy: src=./conf/resolv.conf dest=/etc/resolv.conf

#    - name: Install base soft
#      yum: name=rsync,nfs-utils,net-tools,vim,tree,htop,iftop,iotop,lrzsz,sl,wget,unzip,telnet,nmap,nc,psmisc,dos2unix,bash-completion,iotop,iftop,sysstat,screen,zip state=installed

    - name: Create Group WWW
      group: name=www gid=666

    - name: Create User WWW
      user: name=www uid=666 group=666 create_home=no  shell=/sbin/nologin

    - name: Create Rsync_Client_Pass
      copy: content='1' dest=/etc/rsync.pass mode=600

    - name: Create Sripts Directory
      file: path=/server/scripts/ recurse=yes state=directory

    - name: Push Scripts
      copy: src=./scripts/rsync_backup_md5.sh  dest=/server/scripts/

    - name: Crontable Scripts
      cron: name="backup scripts" hour=01 minute=00 job="/usr/bin/bash /server/scripts/rsync_backup_md5.sh &>/dev/null"
```

## [](#q9u1zz)backup.yaml
```yaml
- hosts: backup
  tasks:

#    - name: Install Rsync Server
#      yum: name=rsync,mailx state=installed

    - name: Configure Rsync Server
      copy: src=./conf/rsyncd.conf dest=/etc/rsyncd.conf
      notify: Restart Rsync Server

    - name: config mailx
      copy: src=./conf/rsyncd.conf dest=/etc/

    - name: Create Date
      file: path=/data state=directory  owner=www group=www mode=755

    - name: Create Backup
      file: path=/backup state=directory  owner=www group=www  mode=755

    - name: Create Virt User
      copy: content='rsync_backup:1' dest=/etc/rsync.password mode=600

    - name: Start RsyncServer
      service: name=rsyncd state=started enabled=yes

    - name: Push Check Scripts
      copy: src=./scripts/rsync_check_backup.sh dest=/server/scripts/

    - name: Crond Check Scripts
      cron: name="check scripts" hour=05 minute=00 job="/usr/bin/bash /server/scripts/rsync_check_backup.sh &>/dev/null"

  handlers:
    - name: Restart Rsync Server
      service: name=rsyncd state=restarted
```

## [](#ge6riw)nfs.yaml
```yaml
- hosts: nfs
  tasks:

#    - name: Installed Nfs Server
#      yum: name=nfs-utils state=installed

    - name: Configure Nfs Server
      copy: src=./conf/exports dest=/etc/exports
      notify: Restart Nfs Server

    - name: Create Share Data
      file: path=/data  state=directory owner=www group=www mode=755

    - name: create wordpress
      file: path=/data/wordpress state=directory owner=www group=www
    - name: create wecenter
      file: path=/data/wecenter state=directory owner=www group=www
    - name: create jpress
      file: path=/data/jpress state=directory owner=www group=www

#    - name: Create Share /data{}
#      shell: mkdir /data/{wordpress,wecenter,jpress} -p

    - name: Chown -R www.www /data
      file: path=/data recurse=yes owner=www group=www

    - name: Start Nfs Server
      service: name=nfs-server state=started enabled=yes

  handlers:
    - name: Restart Nfs Server
      service: name=nfs-server  state=restarted
```

## [](#8gm6dw)sersync.yaml
```yaml
- hosts: nfs
  tasks:

    - name: Scp Sersync
      copy: src=./file/sersync2.5.4_64bit_binary_stable_final.tar.gz dest=/usr/local/sersync.tar.gz

    - name: Zip
      shell: cd /usr/local && tar xf sersync.tar.gz && mv GNU-Linux-x86 sersync
      args:
        creates: /usr/local/sersync

    - name: configure Sersync
      copy: src=./conf/confxml.xml dest=/usr/local/sersync/confxml.xml
      notify: kill old sersync and restart new sersync

    - name: Start Sersync
      shell: pgrep sersync;
             [ $? -eq 0 ] || /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml

  handlers:
    - name:  kill old sersync and restart new sersync
      shell: pegrep sersync | xargs kill -9;
             /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
```

## [](#6kggvd)mysql.yaml
```yaml
- hosts: db
  tasks:

    - name: Install mysql-community
      yum: name=mysql-community-server state=installed

    - name: Start mysqld
      service: name=mysqld state=started enabled=yes

    - name: Copy backup.sql
      copy: src=./file/2018-10-2214-mysql-all.sql dest=/tmp/

    - name: scripts
      script: ./scripts/mysql.sh
```

## [](#alf3nh)web.yaml
```yaml
- hosts: web
  tasks:
#    - name: Install nginx
#      yum: name=nginx state=installed

    - name:   nginx.conf copy
      copy: src=./conf/nginx.conf dest=/etc/nginx/nginx.conf
      notify: Restart nginx

#    - name: install php7.1
#      yum: name=php71w,php71w-cli,php71w-common,php71w-devel,php71w-embedded,php71w-gd,php71w-mcrypt,php71w-mbstring,php71w-pdo,php71w-xml,php71w-fpm,php71w-mysqlnd,php71w-opcache,php71w-pecl-memcached,php71w-pecl-redis,php71w-pecl-mongodb state=installed

    - name: Copy ./file/ssl_key.zip
      unarchive: src=./file/ssl_key.zip dest=/etc/nginx/ creates=/etc/nginx/ssl_key/server.crt

    - name: Copy  www.conf
      copy: src=./conf/www.conf dest=/etc/php-fpm.d/www.conf
      notify: Restart php-fpm

    - name: Copy  php.ini
      copy: src=./conf/php.ini dest=/etc/php.ini
      notify: Restart php-fpm


    - name: Del /etc/nginx/conf.d/default.conf
      file: path=/etc/nginx/conf.d/default.conf state=absent

    - name: Copy conf.d/*
      unarchive: src=./conf/conf.tar.gz dest=/etc/nginx/conf.d/ creates=/etc/nginx/conf.d/wecenter.conf

#    - name: Copy ./file/ssl_key.zip
#      unarchive: src=./file/ssl_key.zip dest=/etc/nginx/ creates=/etc/nginx/ssl_key/server.crt

    - name: Create /code
      file: path=/code/ recurse=yes state=directory mode=755 owner=www group=www

    - name: Copy /code.tar.gz
      unarchive: src=./file/code.tar.gz dest=/code/ creates=/code/wordpress/index.php

    - name: chown www.www /code
      file: path=/code owner=www group=www mode=0755

    - name: Mount wordpress
      mount: src=172.16.1.31:/data/wordpress path=/code/wordpress/wp-content/uploads fstype=nfs opts=defaults state=mounted

    - name: Mount wecenter
      mount: src=172.16.1.31:/data/wecenter path=/code/zh/uploads fstype=nfs opts=defaults state=mounted

    - name: Start nginx
      service: name=nginx state=started enabled=yes

    - name: Start php-fpm
      service: name=php-fpm state=started enabled=yes

#    - name: recovery data
#      shell: cp -rp /code/wecenter/uploads_bak/* /code/wecenter/uploads/ && cp -rp /code/wordpress/wp-content/uploads_bak/* /code/wordpress/wp-content/uploads/

  handlers:
    - name: Restart nginx
      service: name=nginx state=restarted enabled=yes

    - name: Restart php-fpm
      service: name=php-fpm state=restarted enabled=yes
```

## [](#2z1vys)web03.yaml
```yaml
- hosts: web03
  tasks:
#    - name: Install java jarjar
#      yum: name=java,jarjar-maven-plugin state=installed
#
#    - name: Install nginx
#      yum: name=nginx state=installed

    - name:   nginx.conf copy
      copy: src=./conf/nginx.conf dest=/etc/nginx/nginx.conf
      notify: Restart nginx

    - name: jpress.conf copy
      copy: src=./conf/jpress.conf dest=/etc/nginx/conf.d/

    - name: delete nginx default.conf
      file: path=/etc/nginx/conf.d/default.conf state=absent

    - name: start nginx
      service: name=nginx state=started enabled=yes

    - name: Create /code
      file: path=/code/ recurse=yes state=directory mode=755 owner=www group=www

    - name: 解压tomcat.tar.gz
      unarchive: src=./file/tomcat.tar.gz dest=/code/ creates=/code/tomcat/bin/startup.sh

#    - name: Configgurl copy
#      copy: src=./conf/server.xml dest=/server/tomcat8_1/conf/server.xml
#      notify: Restart tomcat

    - name: chown www
      file: path=/code/tomcat recurse=yes owner=www group=www

#    - name: 增加开机自tomcat
#      shell: "echo '/usr/bin/sh /code/tomcat/bin/startup.sh'>> /etc/rc.d/rc.local "

    - name: 增加开机自启动tomcat
      blockinfile: block='/usr/bin/sh /code/tomcat/bin/startup.sh' path='/etc/rc.d/rc.local'

    - name: chmod 755
      file: path=/etc/rc.d/rc.local mode=755

    - name: Start tomcat
#      script: ./scripts/tomcat_start.sh  用脚本启动不得
      shell: "nohup /code/tomcat/bin/startup.sh"

    - name: Mount NFS Server Share jpress
      mount: src=172.16.1.31:/data/jpress path=/code/tomcat/webapps/jpress-web-newest/attachment fstype=nfs opts=defaults state=mounted

#    - name: Recovery data
#      shell: cd /server/tomcat8_1/webapps/jpress && cp -rp attachment_bak/* attachment/

#    - name chown www
#      shell: chown -R www.www /server/tomcat8_1/webapps

#  handlers:
#    - name: Restart tomcat
#      shell: /server/tomcat8_1/bin/shutdown.sh &&  /server/tomcat8_1/bin/startup.sh

  handlers:
    - name: Restart nginx
      service: name=nginx state=restarted enabled=yes
```

## [](#vxh6mf)lb.yaml
```yaml
- hosts: lb01 lb02
  tasks:

#    - name: install nginx
#      yum: name=nginx state=installed

    - name: Del /etc/nginx/conf.d/default.conf
      file: path=/etc/nginx/conf.d/default.conf state=absent

    - name:   nginx.conf copy
      copy: src=./lb/nginx.conf dest=/etc/nginx/nginx.conf
      notify: Restart nginx

    - name: Creae /soft/cache
      file: path=/soft/cache state=directory recurse=yes owner=www group=www mode=755

#    - name: Copy  ds.conf
#      copy: src=./lb/ds.conf dest=/etc/nginx/conf.d/ds.conf
#      notify: Restart nginx

    - name: Copy ./file/ssl_key.zip
      unarchive: src=./file/ssl_key.zip dest=/etc/nginx/ creates=/etc/nginx/ssl_key/server.crt

    - name: Copy  proxy_params
      copy: src=./lb/proxy_params dest=/etc/nginx/proxy_params
      notify: Restart nginx

    - name: Copy  zh_proxy.conf
      copy: src=./lb/zh_proxy.conf dest=/etc/nginx/conf.d/

    - name: Copy  blog_proxy.conf
      copy: src=./lb/blog_proxy.conf dest=/etc/nginx/conf.d/

    - name: Copy  jpress_proxy.conf
      copy: src=./lb/jpress_proxy.conf dest=/etc/nginx/conf.d/

    - name: start nginx
      service: name=nginx state=started enabled=yes

  handlers:
    - name: Restart nginx
      service: name=nginx state=restarted enabled=yes
```

## [](#we75zx)keepalived.yaml
```yaml
- hosts: lb01
  tasks:

#    - name: install keepalived
#      yum: name=keepalived state=installed

    - name: Copy  keepalived.conf
      copy: src=./lb/keepalived.conf dest=/etc/keepalived/keepalived.conf
      notify: Restart keepalived

    - name: Copy scripts/lb_check_web.sh
      copy: src=./scripts/lb_check_web.sh dest=/server/scripts/lb_check_web.sh

    - name: start keepalived
      service: name=keepalived state=started enabled=yes

    - name: chmod 755 lb_check_web.sh
      file: path=/server/scripts/lb_check_web.sh mode=755

#    - name: start keepalived
#      shell: "screen /server/scripts/lb_check_web.sh"

  handlers:
    - name: Restart keepalived
      service: name=keepalived state=restarted enabled=yes
```

## [](#kpzknr)keepalived02.yaml
```plain
- hosts: lb02
  tasks:
#    - name: install keepalived
#      yum: name=keepalived state=installed

    - name: Copy  keepalived2.conf
      copy: src=./lb/keepalived2.conf dest=/etc/keepalived/keepalived.conf
      notify: Restart keepalived

    - name: Copy scripts/lb_check_web.sh
      copy: src=./scripts/lb_check_web.sh dest=/server/scripts/

    - name: start keepalived
      service: name=keepalived state=started enabled=yes

    - name: chmod 755 lb_check_web.sh
      file: path=/server/scripts/lb_check_web.sh mode=755

#    - name: start keepalived
#      shell: /bin/sh /server/scripts/lb_check_web.sh

  handlers:
    - name: Restart keepalived
      service: name=keepalived state=restarted enabled=yes
```



