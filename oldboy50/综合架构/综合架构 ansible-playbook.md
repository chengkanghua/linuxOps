# 综合架构 Ansible Playbook 实战

通过 Ansible Playbook 一键部署完整 LNMP 综合架构：负载均衡（Nginx+Keepalived）、Web（Nginx+PHP）、Tomcat、MySQL、NFS 共享存储、Rsync 备份、Sersync 实时同步。

## 一、功能需求完成表

![功能需求完成表](img/综合架构%20ansible-playbook-01.png)

## 二、主机规划 IP

| 主机名 | eth0 网卡 | eth1 网卡 | 服务简介 |
| --- | --- | --- | --- |
| lb01 | 10.0.0.5/24 | 172.16.1.5/24 | 负载服务 |
| lb02 | 10.0.0.6/24 | 172.16.1.6/24 | 负载服务 |
| web01 | 10.0.0.7/24 | 172.16.1.7/24 | 动态 www 服务 |
| web02 | 10.0.0.8/24 | 172.16.1.8/24 | 动态 www 服务 |
| web03 | 10.0.0.9/24 | 172.16.1.9/24 | tomcat 服务 |
| db01 | 10.0.0.51/24 | 172.16.1.51/24 | 数据库服务 |
| db02 | 10.0.0.52/24 | 172.16.1.52/24 | 数据库从库 |
| db03 | 10.0.0.53/24 | 172.16.1.53/24 | 数据库从库 |
| nfs01 | 10.0.0.31/24 | 172.16.1.31/24 | 存储服务 |
| backup | 10.0.0.41/24 | 172.16.1.41/24 | 备份服务 |
| m01 | 10.0.0.61/24 | 172.16.1.61/24 | 管理服务 |
| zabbix | 10.0.0.71/24 | 172.16.1.71/24 | 监控服务 |

## 三、统一操作：基础优化

```bash
# 修改 IP 地址
sed -i 's#222#61#g' /etc/sysconfig/network-scripts/ifcfg-eth[01]

# 永久修改主机名
hostnamectl set-hostname backup

# 配置 /etc/hosts 主机解析
cat > /etc/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.16.1.5  lb01
172.16.1.6  lb02
172.16.1.7  web01
172.16.1.8  web02
172.16.1.9  web03
172.16.1.31 nfs
172.16.1.41 backup
172.16.1.51 db
172.16.1.52 db02
172.16.1.53 db03
172.16.1.71 zabbix
172.16.1.61 m01
EOF

# 批量推送 hosts 到其他主机
scp -rp /etc/hosts root@172.16.1.31:/etc/

# 调整 YUM 源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

# 1. 安装基础软件包
yum install -y net-tools vim tree htop iftop iotop lrzsz sl wget unzip telnet \
  nmap nc psmisc dos2unix bash-completion sysstat screen yum-plugin-priorities zip

# 2. 关闭 firewalld 防火墙
systemctl disable firewalld
systemctl stop firewalld
systemctl status firewalld

# 3. 关闭 SELinux
sed -ri 's#(^SELINUX=).*#\1disabled#g' /etc/selinux/config
setenforce 0          # 临时生效

# 4. 优化 ulimit
echo '* - nofile 65535' >> /etc/security/limits.conf

# 5. 完成此轮优化后打快照
```

### 客户端指向本地 YUM 源（m01 为仓库）
```bash
# 基础源
cat > /etc/yum.repos.d/centos7.repo <<EOF
[centos75]
name=centos74_base
baseurl=ftp://172.16.1.61/centos75
gpgcheck=0
enabled=1
priority=1
EOF

# 自定义 ops 源
cat > /etc/yum.repos.d/ops.repo <<EOF
[ops]
name=local ftpserver
baseurl=ftp://172.16.1.61/ops
gpgcheck=0
enabled=1
priority=2
EOF

# 阿里 epel 源（优先级最低 = 3）
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
sed -i '/^enabled/a priority=3' /etc/yum.repos.d/epel.repo

yum clean all && yum makecache

# 其他客户端同步推送过去
rsync -avz --delete /etc/yum.repos.d root@172.16.1.31:/etc/
```

## 四、m01 搭建 YUM 仓库

```bash
# 1. 基础环境：安装并启动 vsftpd
yum -y install vsftpd
systemctl start vsftpd
systemctl enable vsftpd

# 开启 yum 缓存（保留下载的 rpm）
vim /etc/yum.conf
# [main]
# cachedir=/var/cache/yum/$basearch/$releasever
# keepcache=1
yum clean all

# 2. 提供基础 base 源
mkdir /var/ftp/centos75
mount /dev/cdrom /mnt
cp -rp /mnt/Packages/*.rpm /var/ftp/centos75

# 3. 提供第三方源 ops
mkdir /var/ftp/ops
yum install -y net-tools vim tree htop iftop iotop lrzsz sl wget unzip \
  telnet nmap nc psmisc dos2unix bash-completion sysstat screen
# 把缓存的 rpm（如 Nginx、docker 及其依赖）移动到 ops 仓库
find /var/cache/yum/x86_64/7/ -iname "*.rpm" -exec mv -f {} /var/ftp/ops \;

# 4. 安装 createrepo 生成仓库元数据
yum -y install createrepo
createrepo /var/ftp/ops
createrepo /var/ftp/centos75
# 注意：仓库每次新增软件都需重新 createrepo 一次

# 客户端使用
gzip /etc/yum.repos.d/*          # 先备份禁用默认源
# 然后配置 centos7.repo / ops.repo（见上节）
yum clean all && yum makecache
rsync -avz /etc/yum.repos.d root@172.16.1.6:/etc/ --delete
```

## 五、SSH、Ansible 与批量管理

```bash
# SSH 相关软件包文件
rpm -ql openssh-server     # /etc/ssh/sshd_config  /usr/sbin/sshd
rpm -ql openssh-clients    # /usr/bin/scp /sftp /ssh /ssh-copy-id

# 1. 在 m01 创建密钥对
ssh-keygen -t rsa -C xuliangwei.com   # 一路回车
ls ~/.ssh/                            # id_rsa(私钥)  id_rsa.pub(公钥)

# 2. 分发公钥到所有被管主机（首次用 sshpass 免交互）
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.31
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

# 远程执行命令
ssh root@172.16.1.41 "hostname -i"

# 3. 安装 ansible
yum install ansible -y
ansible --version      # ansible 2.6.1

# 4. 配置主机清单
cat > /etc/ansible/hosts <<EOF
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
[db03]
172.16.1.53
[zabbix]
172.16.1.71
EOF

# 5. 连通性测试 + 批量命令
ansible all -m ping
ansible all -m command -a "df -h"
ansible all -m command -a "hostname"
```

## 六、Playbook 目录结构

```
/root/playbook
├── backup.yaml                     # 备份服务器
├── base.yaml                       # 基础剧本（所有主机）
├── conf/                           # 各种配置存放目录
│   ├── conf.tar.gz                 # nginx conf 目录打包
│   ├── confxml.xml                 # sersync 配置
│   ├── exports                     # nfs 共享配置
│   ├── jpress.conf                 # 代理配置
│   ├── mail.rc                     # mailx 配置
│   ├── my.cnf                      # mysql 配置
│   ├── nginx.conf                  # nginx 主配置
│   ├── php.ini                     # php 配置
│   ├── resolv.conf                 # dns 配置
│   ├── rsyncd.conf                 # rsyncd 配置
│   ├── server.xml                  # tomcat server.xml
│   └── www.conf                    # php-fpm 配置
├── file/
│   ├── 2018-10-2214-mysql-all.sql  # 数据全备份
│   ├── code.tar.gz                 # 源码包
│   ├── contos75.repo
│   ├── kaoshi.zip
│   ├── ops.repo
│   ├── sersync2.5.4_64bit_binary_stable_final.tar.gz
│   ├── ssl_key.zip                 # ssl 证书
│   └── tomcat.tar.gz               # 配置好的 tomcat
├── keepalived02.yaml               # lb02 的 keepalived
├── keepalived.yaml                 # lb01 的 keepalived
├── lb/                             # nginx proxy 配置
│   ├── blog_proxy.conf
│   ├── ds.conf
│   ├── jpress_proxy.conf
│   ├── keepalived2.conf
│   ├── keepalived.conf
│   ├── nginx.conf
│   ├── proxy-https.conf
│   ├── proxy_params
│   └── zh_proxy.conf
├── lb.yaml
├── mail.yaml
├── mysql.yaml
├── nfs.yaml
├── scripts/
│   ├── lb_check_web.sh
│   ├── mysql.sh
│   ├── rsync_backup_md5.sh
│   ├── rsync_check_backup.sh
│   └── tomcat_start.sh
├── sersync.yaml
├── web03.yaml
└── web.yaml
```

> 执行顺序建议：`base.yaml` → `rsync/backup` → `nfs` → `sersync` → `mysql` → `web/web03` → `lb` → `keepalived/keepalived02`。

## 七、各角色 Playbook

### base.yaml（所有主机初始化）
```yaml
- hosts: all
  tasks:
    - name: Create Group WWW
      group: name=www gid=666

    - name: Create User WWW
      user: name=www uid=666 group=666 create_home=no shell=/sbin/nologin

    - name: Create Rsync_Client_Pass
      copy: content='1' dest=/etc/rsync.pass mode=600

    - name: Create Sripts Directory
      file: path=/server/scripts/ recurse=yes state=directory

    - name: Push Scripts
      copy: src=./scripts/rsync_backup_md5.sh dest=/server/scripts/

    - name: Crontable Scripts
      cron: name="backup scripts" hour=01 minute=00 job="/usr/bin/bash /server/scripts/rsync_backup_md5.sh &>/dev/null"
```
> 注释掉的 yum 源/软件安装任务可按需启用（已拆分为第四节手动或统一角色）。

### backup.yaml（备份服务器）
```yaml
- hosts: backup
  tasks:
    - name: Configure Rsync Server
      copy: src=./conf/rsyncd.conf dest=/etc/rsyncd.conf
      notify: Restart Rsync Server

    - name: config mailx
      copy: src=./conf/rsyncd.conf dest=/etc/

    - name: Create Date
      file: path=/data state=directory owner=www group=www mode=755

    - name: Create Backup
      file: path=/backup state=directory owner=www group=www mode=755

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

### nfs.yaml（存储服务器）
```yaml
- hosts: nfs
  tasks:
    - name: Configure Nfs Server
      copy: src=./conf/exports dest=/etc/exports
      notify: Restart Nfs Server

    - name: Create Share Data
      file: path=/data state=directory owner=www group=www mode=755

    - name: create wordpress
      file: path=/data/wordpress state=directory owner=www group=www
    - name: create wecenter
      file: path=/data/wecenter state=directory owner=www group=www
    - name: create jpress
      file: path=/data/jpress state=directory owner=www group=www

    - name: Chown -R www.www /data
      file: path=/data recurse=yes owner=www group=www

    - name: Start Nfs Server
      service: name=nfs-server state=started enabled=yes

  handlers:
    - name: Restart Nfs Server
      service: name=nfs-server state=restarted
```

### sersync.yaml（NFS 实时同步到 Backup）
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
      shell: pgrep sersync; [ $? -eq 0 ] || /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml

  handlers:
    - name: kill old sersync and restart new sersync
      shell: pgrep sersync | xargs kill -9; /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
```

### mysql.yaml（数据库）
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

### web.yaml（Nginx + PHP Web 节点）
```yaml
- hosts: web
  tasks:
    - name: nginx.conf copy
      copy: src=./conf/nginx.conf dest=/etc/nginx/nginx.conf
      notify: Restart nginx

    - name: Copy ./file/ssl_key.zip
      unarchive: src=./file/ssl_key.zip dest=/etc/nginx/ creates=/etc/nginx/ssl_key/server.crt

    - name: Copy www.conf
      copy: src=./conf/www.conf dest=/etc/php-fpm.d/www.conf
      notify: Restart php-fpm

    - name: Copy php.ini
      copy: src=./conf/php.ini dest=/etc/php.ini
      notify: Restart php-fpm

    - name: Del /etc/nginx/conf.d/default.conf
      file: path=/etc/nginx/conf.d/default.conf state=absent

    - name: Copy conf.d/*
      unarchive: src=./conf/conf.tar.gz dest=/etc/nginx/conf.d/ creates=/etc/nginx/conf.d/wecenter.conf

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

  handlers:
    - name: Restart nginx
      service: name=nginx state=restarted enabled=yes
    - name: Restart php-fpm
      service: name=php-fpm state=restarted enabled=yes
```

### web03.yaml（Tomcat 节点）
```yaml
- hosts: web03
  tasks:
    - name: nginx.conf copy
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

    - name: 解压 tomcat.tar.gz
      unarchive: src=./file/tomcat.tar.gz dest=/code/ creates=/code/tomcat/bin/startup.sh

    - name: chown www
      file: path=/code/tomcat recurse=yes owner=www group=www

    - name: 增加开机自启动 tomcat
      blockinfile: block='/usr/bin/sh /code/tomcat/bin/startup.sh' path='/etc/rc.d/rc.local'

    - name: chmod 755
      file: path=/etc/rc.d/rc.local mode=755

    - name: Start tomcat
      shell: "nohup /code/tomcat/bin/startup.sh"

    - name: Mount NFS Server Share jpress
      mount: src=172.16.1.31:/data/jpress path=/code/tomcat/webapps/jpress-web-newest/attachment fstype=nfs opts=defaults state=mounted

  handlers:
    - name: Restart nginx
      service: name=nginx state=restarted enabled=yes
```

### lb.yaml（负载均衡 Nginx 代理）
```yaml
- hosts: lb01 lb02
  tasks:
    - name: Del /etc/nginx/conf.d/default.conf
      file: path=/etc/nginx/conf.d/default.conf state=absent

    - name: nginx.conf copy
      copy: src=./lb/nginx.conf dest=/etc/nginx/nginx.conf
      notify: Restart nginx

    - name: Creae /soft/cache
      file: path=/soft/cache state=directory recurse=yes owner=www group=www mode=755

    - name: Copy ./file/ssl_key.zip
      unarchive: src=./file/ssl_key.zip dest=/etc/nginx/ creates=/etc/nginx/ssl_key/server.crt

    - name: Copy proxy_params
      copy: src=./lb/proxy_params dest=/etc/nginx/proxy_params
      notify: Restart nginx

    - name: Copy zh_proxy.conf
      copy: src=./lb/zh_proxy.conf dest=/etc/nginx/conf.d/

    - name: Copy blog_proxy.conf
      copy: src=./lb/blog_proxy.conf dest=/etc/nginx/conf.d/

    - name: Copy jpress_proxy.conf
      copy: src=./lb/jpress_proxy.conf dest=/etc/nginx/conf.d/

    - name: start nginx
      service: name=nginx state=started enabled=yes

  handlers:
    - name: Restart nginx
      service: name=nginx state=restarted enabled=yes
```

### keepalived.yaml（lb01 高可用）
```yaml
- hosts: lb01
  tasks:
    - name: Copy keepalived.conf
      copy: src=./lb/keepalived.conf dest=/etc/keepalived/keepalived.conf
      notify: Restart keepalived

    - name: Copy scripts/lb_check_web.sh
      copy: src=./scripts/lb_check_web.sh dest=/server/scripts/lb_check_web.sh

    - name: start keepalived
      service: name=keepalived state=started enabled=yes

    - name: chmod 755 lb_check_web.sh
      file: path=/server/scripts/lb_check_web.sh mode=755

  handlers:
    - name: Restart keepalived
      service: name=keepalived state=restarted enabled=yes
```

### keepalived02.yaml（lb02 高可用）
```yaml
- hosts: lb02
  tasks:
    - name: Copy keepalived2.conf
      copy: src=./lb/keepalived2.conf dest=/etc/keepalived/keepalived.conf
      notify: Restart keepalived

    - name: Copy scripts/lb_check_web.sh
      copy: src=./scripts/lb_check_web.sh dest=/server/scripts/

    - name: start keepalived
      service: name=keepalived state=started enabled=yes

    - name: chmod 755 lb_check_web.sh
      file: path=/server/scripts/lb_check_web.sh mode=755

  handlers:
    - name: Restart keepalived
      service: name=keepalived state=restarted enabled=yes
```

## 八、面试题

1. **这套综合架构用 Ansible 部署了哪些角色？**
   base 基础初始化、backup 备份、nfs 存储、sersync 实时同步、mysql 数据库、web（Nginx+PHP）、web03（Tomcat）、lb 负载均衡、keepalived 高可用。

2. **为什么用 `unarchive` 而不是 `copy` 推送代码包？**
   `unarchive` 可在推送同时解压，并配合 `creates` 实现幂等（已解压则跳过）。

3. **`mount` 模块 `state=mounted` 与 `state=present` 区别？**
   `present` 仅写入 `/etc/fstab` 不挂载；`mounted` 写入并立即挂载。

4. **handlers 的作用？本架构哪里用到？**
   仅当被 notify 的任务发生变更才触发，用于重启服务（nginx、php-fpm、rsync、nfs、keepalived），避免无谓重启。

5. **`blockinfile` 在此项目的用途？**
   向 `/etc/rc.d/rc.local` 追加 Tomcat 开机自启命令，幂等且不重复追加。

6. **如何保证 Playbook 幂等性？**
   优先用原生模块（copy/yum/service/mount）；用 `creates` 判断文件已存在则跳过；用 handlers 仅在变更时重启。

---

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/lbzfgi>
