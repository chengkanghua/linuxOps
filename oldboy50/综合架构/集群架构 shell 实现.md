# 集群架构 Shell 实现

完整综合架构（LNMP + NFS + Rsync/Sersync + MySQL MHA + Atlas + LB Keepalived + Zabbix）的逐台 Shell 实现手册。

**主机规划**

| 主机名 | eth0 | eth1 | 服务 |
| --- | --- | --- | --- |
| lb01 | 10.0.0.5 | 172.16.1.5 | 负载服务 |
| lb02 | 10.0.0.6 | 172.16.1.6 | 负载服务 |
| web01 | 10.0.0.7 | 172.16.1.7 | 动态 www |
| web02 | 10.0.0.8 | 172.16.1.8 | 动态 www |
| web03 | 10.0.0.9 | 172.16.1.9 | tomcat |
| db01 | 10.0.0.51 | 172.16.1.51 | 数据库主 |
| db02 | 10.0.0.52 | 172.16.1.52 | 数据库从 |
| db03 | 10.0.0.53 | 172.16.1.53 | 数据库从 |
| nfs01 | 10.0.0.31 | 172.16.1.31 | 存储 |
| backup | 10.0.0.41 | 172.16.1.41 | 备份 |
| m01 | 10.0.0.61 | 172.16.1.61 | 管理 |
| zabbix | 10.0.0.71 | 172.16.1.71 | 监控 |

---

## 一、系统基础优化（模板机）

```bash
hostnamectl set-hostname new_hostname

# 外网网卡
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=10.0.0.2
PREFIX=24
GATEWAY=10.0.0.254
DNS1=223.5.5.5
EOF

# 内网网卡
cat > /etc/sysconfig/network-scripts/ifcfg-eth1 <<EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=eth1
DEVICE=eth1
ONBOOT=yes
IPADDR=172.16.1.2
PREFIX=24
EOF

systemctl restart network

# 防火墙 / SELinux
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config

# SSH 优化
sed -i '93c GSSAPIAuthentication no' /etc/ssh/sshd_config
sed -i '129c UseDNS no' /etc/ssh/sshd_config
systemctl restart sshd

# YUM 源
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo

# 关闭 NetworkManager / 安装常用命令
systemctl stop NetworkManager
systemctl disable NetworkManager
yum install net-tools vim tree htop iotop iftop screen lsof \
  lrzsz wget unzip telnet nmap nc tcpdump psmisc \
  dos2unix bash-completion sysstat rsync nfs-utils -y

# 关闭邮件服务
systemctl stop postfix
systemctl disable postfix.service

# 优化 ulimit
echo '* - nofile 65535' >> /etc/security/limits.conf

# 关机导出 ova 模板
shutdown -h now
```

---

## 二、m01 搭建 YUM 仓库

```bash
# FTP 服务
yum -y install vsftpd
systemctl start vsftpd
systemctl enable vsftpd

# 开启 yum 缓存
sed -i '/^keepcache/c keepcache=1' /etc/yum.conf
yum clean all

# 基础 base 源
mkdir -p /var/ftp/centos7
mount /dev/cdrom /mnt
cp -rp /mnt/Packages/*.rpm /var/ftp/centos7

# 第三方 ops 源（仅下载不安装）
mkdir /var/ftp/ops
yum install --downloadonly net-tools vim tree htop iftop \
  iotop lrzsz sl wget unzip telnet nmap nc psmisc \
  dos2unix bash-completion sysstat screen -y
find /var/cache/yum/x86_64/7/ -iname "*.rpm" -exec mv -f {} /var/ftp/ops/ \;

# 生成 repo 元数据（新增软件需重新执行）
yum -y install createrepo
createrepo /var/ftp/ops
createrepo /var/ftp/centos7
```

**客户端（backup 上）使用**
```bash
gzip /etc/yum.repos.d/*
cat > /etc/yum.repos.d/centos7.repo <<EOF
[centos75]
name=centos74_base
baseurl=ftp://172.16.1.61/centos7
gpgcheck=0
EOF
cat > /etc/yum.repos.d/ops.repo <<EOF
[ops]
name=local ftpserver
baseurl=ftp://172.16.1.61/ops
gpgcheck=0
EOF
yum clean all && yum makecache

# 其他客户端同步推送
for i in 5 6 7 8 9 51 52 53 31 41 71; do
  rsync -avz /etc/yum.repos.d root@172.16.1.$i:/etc/ --delete
done
```

---

## 三、m01 时间同步服务器（NTP）

```bash
yum -y install ntp
systemctl start ntpd
systemctl enable ntpd
ntpstat
ntpq -p

# m01 每小时同步阿里云时间
echo '* */1 * * * /usr/sbin/ntpdate ntp1.aliyun.com' >> /var/spool/cron/root

# 其他客户端每分钟同步 m01
for i in 5 6 7 8 9 51 52 53 31 41 71; do
  ssh root@172.16.1.$i "echo '* */1 * * * /usr/sbin/ntpdate 172.16.1.61' >> /var/spool/cron/root"
done
```

---

## 四、backup 备份服务器（Rsync + 邮件校验）

```bash
hostnamectl set-hostname backup && bash

# rsync 服务端配置
cat > /etc/rsyncd.conf <<EOF
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
secrets file = /etc/rsync.password
log file = /var/log/rsyncd.log
#####################################
[backup]
path = /backup
[data]
path = /data
EOF

groupadd -g666 www
useradd -u666 -g666 www
mkdir -p /backup /data
chown -R www.www /backup /data
chmod 755 /backup

# 虚拟用户密码
echo "rsync_backup:1" > /etc/rsync.password
chmod 600 /etc/rsync.password
systemctl enable rsyncd && systemctl start rsyncd
```

**客户端备份脚本（m01 编写，分发到各机）**
```bash
mkdir -p /server/scripts/
cat > /server/scripts/client_rsync_backup.sh <<-'EOF'
#!/usr/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
Host=$(hostname)
Addr=$(ifconfig eth1|awk 'NR==2{print $2}')
Date=$(date +%F)
Dest=${Host}_${Addr}_${Date}
Path=/backup

[ -d $Path/$Dest ] || mkdir -p $Path/$Dest
cd / && \
[ -f $Path/$Dest/system.tar.gz ] || tar czf $Path/$Dest/system.tar.gz etc/fstab etc/rsyncd.conf && \
[ -f $Path/$Dest/log.tar.gz ]    || tar czf $Path/$Dest/log.tar.gz  var/log/messages var/log/secure && \

[ -f $Path/$Dest/flag_$Date ] || md5sum $Path/$Dest/*.tar.gz >$Path/$Dest/flag_${Date}

export RSYNC_PASSWORD=1
rsync -avz $Path/ rsync_backup@172.16.1.41::backup

find $Path/ -type d -mtime +7|xargs rm -rf
EOF

# 定时任务 + 测试
echo '00 01 * * * /usr/bin/bash /server/scripts/client_rsync_backup.sh >/dev/null 2>&1' >> /var/spool/cron/root
sh /server/scripts/client_rsync_backup.sh
```

**m01 批量分发公钥与脚本**
```bash
yum install sshpass -y
ssh-keygen -t rsa -C www.chengkanghua.top
for i in 5 6 7 8 9 51 52 53 31 41 71; do
  sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.$i
done
for i in 5 6 7 8 9 51 52 53 31 71; do
  scp -rp /var/spool/cron/root root@172.16.1.$i:/var/spool/cron/ && \
  rsync -avz /server root@172.16.1.$i:/
done
```

**backup 服务端校验脚本（邮件通知）**
```bash
yum install mailx -y
cat > /etc/mail.rc <<EOF
set from=343264992@163.com
set smtp=smtp.163.com
set smtp-auth-user=343264992@163.com
set smtp-auth-password=MMaNQcY4HFTRJC2q
set smtp-auth=login
set ssl-verify=ignore
EOF

mkdir /server/scripts -p
cat > /server/scripts/check_backup.sh <<\EOF
#!/usr/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
Path=/backup
Date=$(date +%F)

find $Path/*_${Date} -type f -name "flag_$Date"|xargs md5sum -c >$Path/result_${Date}
mail -s "Rsync Backup $Date" 343264992@qq.com <$Path/result_${Date}

find $Path/ -type f -name "result*" -mtime +7|xargs rm -f
find $Path/ -type d -mtime +180|xargs rm -rf
EOF

echo '00 05 * * * /usr/bin/bash /server/scripts/check_backup.sh >/dev/null 2>&1' > /var/spool/cron/root
```

---

## 五、NFS 共享存储

```bash
hostnamectl set-hostname nfs01 && bash
groupadd -g666 www
useradd -u666 -g666 -s /sbin/nologin -M www
yum install nfs-utils -y

cat > /etc/exports <<EOF
/data/blog  172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
/data/zh    172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
/data/jpress 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
EOF

mkdir /data/{blog,zh,jpress} -p
chown -R www.www /data
systemctl enable nfs-server && systemctl start nfs-server
```

---

## 六、NFS 实时同步到 backup（Sersync）

```bash
yum install inotify-tools rsync -y
wget https://raw.githubusercontent.com/wsgzao/sersync/master/sersync2.5.4_64bit_binary_stable_final.tar.gz
tar xf sersync2.5.4_64bit_binary_stable_final.tar.gz -C /usr/local/
mv /usr/local/GNU-Linux-x86/ /usr/local/sersync
cp /usr/local/sersync/confxml.xml{,.bak}

cat > /usr/local/sersync/confxml.xml <<EOF
<?xml version="1.0" encoding="ISO-8859-1"?>
<head version="2.5">
    <host hostip="localhost" port="8008"></host>
    <debug start="false"/>
    <fileSystem xfs="true"/>
    <filter start="false">
        <exclude expression="(.*)\.svn"></exclude>
        <exclude expression="(.*)\.gz"></exclude>
        <exclude expression="^info/*"></exclude>
        <exclude expression="^static/*"></exclude>
    </filter>
    <inotify>
        <delete start="true"/>
        <createFolder start="true"/>
        <createFile start="true"/>
        <closeWrite start="true"/>
        <moveFrom start="true"/>
        <moveTo start="true"/>
        <attrib start="false"/>
        <modify start="false"/>
    </inotify>
    <sersync>
        <localpath watch="/data">
            <remote ip="172.16.1.41" name="data"/>
        </localpath>
        <rsync>
            <commonParams params="-az"/>
            <auth start="true" users="rsync_backup" passwordfile="/etc/rsync.pass"/>
            <userDefinedPort start="false" port="874"/>
            <timeout start="true" time="100"/>
            <ssh start="false"/>
        </rsync>
        <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/>
        <crontab start="false" schedule="600">
            <crontabfilter start="false">
                <exclude expression="*.php"></exclude>
                <exclude expression="info/*"></exclude>
            </crontabfilter>
        </crontab>
        <plugin start="false" name="command"/>
    </sersync>
</head>
EOF

echo "1" > /etc/rsync.pass
chmod 600 /etc/rsync.pass
# backup 端创建 /data 并授权 chown -R www.www /backup/ /data/
/usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
```

> 配置要点：`<fileSystem xfs="true"/>` 文件系统；`<inotify>` 监控事件；`<localpath watch>` 监控目录，`<remote ip>` backup 的 IP 与模块；`<rsync>` 同步选项及认证；每 60 分钟兜底同步一次。

---

## 七、web01/web02（Nginx + PHP）

```bash
hostnamectl set-hostname web01 && bash   # web02 同理
groupadd -g 666 www
useradd -u666 -g666 -s /sbin/nologin -M www

# Nginx 官方源
cat > /etc/yum.repos.d/nginx.repo<<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF

# PHP7.3
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils nginx
yum install -y php73-php-fpm php73-php-cli php73-php-bcmath php73-php-gd php73-php-json \
  php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo \
  php73-php-pecl-crypto php73-php-pecl-mcrypt php73-php-pecl-geoip php73-php-recode \
  php73-php-snmp php73-php-soap php73-php-xml

# 进程/属主改为 www
sed -i '/^user/c user www;' /etc/nginx/nginx.conf
sed -i '/^user/c user = www' /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i '/^group/c group = www' /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/opt/remi/php73/php.ini

systemctl restart php73-php-fpm nginx
systemctl enable php73-php-fpm nginx
```

---

## 八、MySQL MHA + Atlas（db01/02/03）

### 1. 安装 MySQL 5.7（三台）
```bash
rpm -qa |grep mariadb
yum remove mariadb-libs -y
wget https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
rpm -ivh mysql57-community-release-el7-8.noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install mysql-server -y
systemctl start mysqld && systemctl enable mysqld

# 修改初始密码
pass=`grep 'A temporary password' /var/log/mysqld.log |awk '{print $NF}'`
mysql -uroot -p$pass <<EOF
set global validate_password_policy=LOW;
set global validate_password_length=6;
ALTER USER USER() IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# 字符编码
tee -a /etc/my.cnf <<EOF
[client]
default-character-set=utf8
[mysqld]
character-set-server=utf8
collation-server=utf8_general_ci
EOF
systemctl restart mysqld
```

### 2. 主从配置（GTID）
```bash
# db01（主）
mysql -uroot -p123456 -e "grant replication slave on *.* to rep@'172.16.1.%' identified by 'Oldboy@123.com';"
```
```ini
# /etc/my.cnf（三台差异在 server_id）
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
character-set-server=utf8
collation-server=utf8_general_ci
server_id=1            # db02=5, db03=6
log_bin=mysql-bin
gtid_mode=ON
enforce_gtid_consistency
relay_log_purge = 0
skip_name_resolve
[client]
default-character-set=utf8
```
```bash
systemctl restart mysqld

# 两台从库
mysql -uroot -p123456 <<EOF
change master to
master_host='172.16.1.51',
master_user='rep',
master_password='Oldboy@123.com',
master_auto_position=1;
start slave;
EOF
# show slave status\G  确认双 Yes
```

### 3. MHA 部署
```bash
# 所有节点
yum install perl-DBD-MySQL -y
cd ~/tools
wget https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
wget https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node-0.58-0.el7.centos.noarch.rpm
rpm -ivh mha4mysql-node-0.58-0.el7.centos.noarch.rpm

mysql -uroot -p123456 -e "grant all privileges on *.* to mha@'172.16.1.%' identified by 'Mha@123.com';"

# 管理节点（db03）安装 manager
yum install -y perl-Config-Tiny epel-release perl-Log-Dispatch perl-Parallel-ForkManager perl-Time-HiRes
rpm -ivh mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
mkdir -p /etc/mha /var/log/mha/app1

cat > /etc/mha/app1.cnf <<EOF
[server default]
master_ip_failover_script=/usr/local/bin/master_ip_failover
manager_log=/var/log/mha/app1/manager.log
manager_workdir=/var/log/mha/app1
master_binlog_dir=/var/lib/mysql
user=mha
password=Mha@123.com
ping_interval=2
repl_user=rep
repl_password=Oldboy@123.com
ssh_user=root
[server1]
hostname=172.16.1.51
port=3306
[server2]
candidate_master=1
check_repl_delay=0
hostname=172.16.1.52
port=3306
[server3]
hostname=172.16.1.53
port=3306
EOF
```

**节点互信（每台都执行）**
```bash
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa >/dev/null 2>&1
ssh-copy-id -i /root/.ssh/id_dsa.pub root@172.16.1.51
ssh-copy-id -i /root/.ssh/id_dsa.pub root@172.16.1.52
ssh-copy-id -i /root/.ssh/id_dsa.pub root@172.16.1.53
```

**VIP 漂移脚本 `/usr/local/bin/master_ip_failover`**
```perl
#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';
use Getopt::Long;
my ($command,$ssh_user,$orig_master_host,$orig_master_ip,$orig_master_port,$new_master_host,$new_master_ip,$new_master_port);
my $vip = '172.16.1.55/24';
my $key = '1';
my $ssh_start_vip = "/sbin/ifconfig eth1:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig eth1:$key down";
GetOptions(
  'command=s'          => \$command,
  'ssh_user=s'         => \$ssh_user,
  'orig_master_host=s' => \$orig_master_host,
  'orig_master_ip=s'   => \$orig_master_ip,
  'orig_master_port=i' => \$orig_master_port,
  'new_master_host=s'  => \$new_master_host,
  'new_master_ip=s'    => \$new_master_ip,
  'new_master_port=i'  => \$new_master_port,
);
exit &main();
sub main {
  if ( $command eq "stop" || $command eq "stopssh" ) {
    my $exit_code = 1;
    eval { &stop_vip(); $exit_code = 0; };
    if ($@){ warn "Got Error: $@\n"; exit $exit_code; }
    exit $exit_code;
  }
  elsif ( $command eq "start" ) {
    my $exit_code = 10;
    eval { &start_vip(); $exit_code = 0; };
    if ($@){ warn $@; exit $exit_code; }
    exit $exit_code;
  }
  elsif ( $command eq "status" ) {
    print "Checking the Status of the script.. OK \n";
    exit 0;
  }
  else { &usage(); exit 1; }
}
sub start_vip() {
  `ssh $ssh_user\@$new_master_host \" $ssh_start_vip \"`;
}
sub stop_vip() {
  return 0 unless ($ssh_user);
  `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip;  \"`;
}
sub usage {
  print "Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}
EOF
chmod +x /usr/local/bin/master_ip_failover
```

**VIP 绑定与启动 MHA**
```bash
ifconfig eth1:1 172.16.1.55/24
masterha_check_ssh  --conf=/etc/mha/app1.cnf
masterha_check_repl --conf=/etc/mha/app1.cnf
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &
masterha_check_status --conf=/etc/mha/app1.cnf
```

### 4. Atlas 中间件
```bash
cd ~/tools/
wget https://github.com/Qihoo360/Atlas/releases/download/2.2.1/Atlas-2.2.1.el6.x86_64.rpm
rpm -ivh Atlas-2.2.1.el6.x86_64.rpm
cd /usr/local/mysql-proxy/bin/
# /usr/local/mysql-proxy/bin/encrypt 123456          -> /iZxz+0GRoA=
# /usr/local/mysql-proxy/bin/encrypt Oldboy@123.com  -> cr8+Kh8Hu2Z9yWwPW5JmmQ==
# /usr/local/mysql-proxy/bin/encrypt Mha@123.com     -> lWwLt+QjEMIjJfKhmDS20Q==

cat > /usr/local/mysql-proxy/conf/test.cnf <<\EOF
[mysql-proxy]
admin-username = user
admin-password = pwd
proxy-backend-addresses = 172.16.1.55:3306
proxy-read-only-backend-addresses = 172.16.1.52:3306,172.16.1.53:3306
pwds = mha:lWwLt+QjEMIjJfKhmDS20Q==,repl:cr8+Kh8Hu2Z9yWwPW5JmmQ==,root:/iZxz+0GRoA=
daemon = true
keepalive = true
event-threads = 8
log-level = message
log-path = /usr/local/mysql-proxy/log
sql-log=ON
sql-log-slow = 10
admin-address = 0.0.0.0:2345
proxy-address = 0.0.0.0:3307
charset=utf8
EOF
/usr/local/mysql-proxy/bin/mysql-proxyd test start
```
> 高可用：三台都装 Atlas，用 VIP 对外服务。主库故障切换后，更新 Atlas 移除旧主 IP 并重新加载配置。

### 5. MHA 切换后修复
```bash
# 1. 修复 down 的主库：/etc/init.d/mysqld start
# 2. 在 MHA 日志找 change master to：
grep -i 'change master to' /var/log/mha/app1/manager.log
# 3. 旧主库执行
change master to
  master_host='10.0.0.11',
  master_port=3306,
  master_auto_position=1,
  master_user='rep',
  master_password='oldboy123';
start slave;
# 4. 把旧主库 server 标签加回 /etc/mha/app1.cnf
# 5. 重启 MHA
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &
masterha_check_status --conf=/etc/mha/app1.cnf
```

---

## 九、部署 WordPress / Wecenter

```bash
# blog 站点
cat > /etc/nginx/conf.d/blog.conf<<EOF
server {
  listen 80;
  server_name blog.oldboy.com;
  location / {
    root /code/wordpress;
    index index.php index.html;
  }
  location ~ \.php$ {
    root /code/wordpress;
    fastcgi_index  index.php;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
    include        fastcgi_params;
  }
}
EOF
systemctl restart nginx

wget https://cn.wordpress.org/wordpress-4.9.4-zh_CN.tar.gz
mkdir -p /code
tar zxvf wordpress-4.9.4-zh_CN.tar.gz -C /code/
chown -R www.www /code/wordpress

mysql -uroot -p123456 -h172.16.1.55 -P3307 <<EOF
create database wordpress;
GRANT all privileges ON wordpress.* TO blog@'172.16.1.%' IDENTIFIED BY 'Blog@123.com';
FLUSH PRIVILEGES;
EOF
# 浏览器访问 http://blog.oldboy.com/wordpress

# zh 站点
cat > /etc/nginx/conf.d/zh.conf<<EOF
server {
  listen 80;
  server_name zh.oldboy.com;
  root /code/zh;
  index index.php index.html;
  location ~ \.php$ {
    root /code/zh;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
    include        fastcgi_params;
  }
}
EOF
systemctl reload nginx

mkdir -p /code/zh
wget https://github.com/wecenter/wecenter/archive/refs/tags/3.1.9.zip
unzip 3.1.9.zip -d /code/zh
mv /code/zh/wecenter-3.1.9/* /code/zh/
rm -rf /code/zh/wecenter-3.1.9
chown -R www.www /code/zh/

mysql -uroot -p123456 -h172.16.1.55 -P3307 <<EOF
create database wecenter;
GRANT all privileges ON wecenter.* TO zh@'172.16.1.%' IDENTIFIED BY 'Zh@123.com';
FLUSH PRIVILEGES;
EOF
```

**把业务账号加入 Atlas（三台都改 pwds 后重启）**
```bash
/usr/local/mysql-proxy/bin/encrypt Blog@123.com   # 9LC9u6ancfPJ50hl9Y7q9w==
/usr/local/mysql-proxy/bin/encrypt Zh@123.com     # tUU6igbdR2jgSv1GServJg==
# vi /usr/local/mysql-proxy/conf/test.cnf
# pwds = mha:...,repl:...,root:...,blog:9LC9u6ancfPJ50hl9Y7q9w==,zh:tUU6igbdR2jgSv1GServJg==
/usr/local/mysql-proxy/bin/mysql-proxyd test stop && /usr/local/mysql-proxy/bin/mysql-proxyd test start
```

**web02 同步配置与代码**
```bash
scp /etc/nginx/conf.d/* root@10.0.0.8:/etc/nginx/conf.d/
rsync -az /code root@10.0.0.8:/
ssh root@10.0.0.8 "systemctl restart nginx php73-php-fpm"
```

---

## 十、web03 Java 站点（Tomcat + JPress）

```bash
hostnamectl set-hostname web03 && bash
yum install java -y
mkdir /code && cd /code
wget https://mirror.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.95/bin/apache-tomcat-9.0.95.tar.gz
tar xf apache-tomcat-9.0.95.tar.gz
ln -s /code/apache-tomcat-9.0.95 /code/tomcat

# 上传 jpress 的 war 到 /code/tomcat/webapps，重启 tomcat 自动解压
#/code/tomcat/bin/shutdown.sh; /code/tomcat/bin/startup.sh
sed -i.ori '163a <Context path="" docBase="/code/tomcat/webapps/jpress-web-newest" debug="0" reloadable="false" crossContext="true"/>' /code/tomcat/conf/server.xml
/code/tomcat/bin/shutdown.sh; /code/tomcat/bin/startup.sh

# 创建 jpress 库
mysql -uroot -p123456 -h172.16.1.55 -P3307 <<EOF
create database jpress;
GRANT all privileges ON jpress.* TO press@'172.16.1.%' IDENTIFIED BY 'Press@123.com';
FLUSH PRIVILEGES;
EOF
# /usr/local/mysql-proxy/bin/encrypt Press@123.com  -> 485F3MpDTKRKR8K2xIyPJg==
# 三台 atlas 的 pwds 追加 press:485F3MpDTKRKR8K2xIyPJg== 后重启

# 本机 Nginx 反向代理
yum install nginx -y
cat > /etc/nginx/conf.d/jpress.conf <<EOF
server {
    listen 80;
    server_name jpress.oldboy.com;
    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_connect_timeout 30;
        proxy_send_timeout 60;
        proxy_read_timeout 60;
        proxy_buffering on;
        proxy_buffer_size 32k;
        proxy_buffers 4 128k;
    }
}
EOF
systemctl enable nginx && systemctl start nginx
```

---

## 十一、挂载 NFS 共享存储

```bash
# web01：wordpress / zh
cd /code/wordpress/wp-content/
mv uploads/ uploads_bak && mkdir uploads
mount -t nfs 172.16.1.31:/data/blog /code/wordpress/wp-content/uploads
cp -rp uploads_bak/* uploads/ && chown -R www.www uploads/

cd /code/zh/
mv uploads/ uploads_bak && mkdir uploads
mount -t nfs 172.16.1.31:/data/zh /code/zh/uploads
cp -rp uploads_bak/* uploads/ && chown www.www uploads

# web02：直接挂载
mkdir /code/wordpress/wp-content/uploads
mount -t nfs 172.16.1.31:/data/blog /code/wordpress/wp-content/uploads
mount -t nfs 172.16.1.31:/data/zh /code/zh/uploads

# web03：jpress
cd /code/tomcat/webapps/jpress-web-newest
mv attachment/ attachment_bak && mkdir attachment
mount -t nfs 172.16.1.31:/data/jpress /code/tomcat/webapps/jpress-web-newest/attachment
cp -rp attachment_bak/* attachment/

# 开机自动挂载
cat >> /etc/fstab <<EOF
172.16.1.31:/data/blog /code/wordpress/wp-content/uploads nfs defaults 0 0
172.16.1.31:/data/zh /code/zh/uploads nfs defaults 0 0
172.16.1.31:/data/jpress /code/tomcat/webapps/jpress-web-newest/attachment nfs defaults 0 0
EOF
mount -a && df -h | grep data
```

---

## 十二、LB01 负载均衡（Nginx）

```bash
hostnamectl set-hostname lb01 && bash
scp -rp root@172.16.1.7:/etc/yum.repos.d/nginx.repo /etc/yum.repos.d/
yum install nginx -y
rm -f /etc/nginx/conf.d/*

cat > /etc/nginx/conf.d/blog_proxy.conf <<EOF
upstream blog {
    server 172.16.1.7:80;
    server 172.16.1.8:80;
}
server {
    server_name blog.oldboy.com;
    listen 80;
    location / {
        proxy_pass http://blog;
        include proxy_params;
    }
}
EOF

cat > /etc/nginx/conf.d/zh_proxy.conf <<EOF
upstream zh {
    server 172.16.1.7:80;
    server 172.16.1.8:80;
}
server {
    server_name zh.oldboy.com;
    listen 80;
    location / {
        proxy_pass http://zh;
        include proxy_params;
    }
}
EOF

cat > /etc/nginx/conf.d/jpress_proxy.conf <<EOF
upstream java {
    server 172.16.1.9:8080;
}
server {
    listen 80;
    server_name jpress.oldboy.com;
    location / {
        proxy_pass http://java;
        include proxy_params;
    }
}
EOF

cat > /etc/nginx/proxy_params <<\EOF
proxy_set_header Host $http_host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_connect_timeout 30;
proxy_send_timeout 60;
proxy_read_timeout 60;
proxy_buffering on;
proxy_buffer_size 32k;
proxy_buffers 4 128k;
EOF

systemctl enable nginx && systemctl start nginx
```

---

## 十三、LB HTTPS 配置

```bash
# 生成证书（web01 上）
mkdir /etc/nginx/ssl_key && cd /etc/nginx/ssl_key/
openssl genrsa -idea -out server.key 2048   # 密码 1234
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt
# CN/WH/WH/edu/SA/bgx/bgx@foxmail.com

# blog_proxy.conf 支持 HTTPS（HTTP 跳转）
upstream blog {
    server 172.16.1.7:80;
    server 172.16.1.8:80;
}
server {
    server_name blog.oldboy.com;
    listen 80;
    return 302 https://$server_name$request_uri;
}
server {
    server_name blog.oldboy.com;
    listen 443;
    ssl on;
    ssl_certificate   ssl_key/server.crt;
    ssl_certificate_key  ssl_key/server.key;
    location / {
        proxy_pass http://blog;
        include proxy_params;
    }
}
```

---

## 十四、Keepalived 高可用

```bash
hostnamectl set-hostname lb02 && bash   # lb02
scp -rp root@172.16.1.5:/etc/yum.repos.d/nginx.repo /etc/yum.repos.d/
yum install nginx -y
rsync -avz root@172.16.1.5:/etc/nginx /etc/ --delete
systemctl start nginx && systemctl enable nginx

yum install keepalived -y   # 两台都装

# lb01
tee /etc/keepalived/keepalived.conf <<EOF
global_defs {
    router_id lb01
}
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 50
    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        10.0.0.3
    }
}
EOF
systemctl restart keepalived && systemctl enable keepalived

# lb02
tee /etc/keepalived/keepalived.conf <<EOF
global_defs {
    router_id lb02
}
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 50
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        10.0.0.3
    }
}
EOF
systemctl restart keepalived && systemctl enable keepalived
```

---

## 十五、Nginx Proxy Cache 负载均衡缓存

```bash
mkdir /soft/cache && chown -R www.www /soft/cache
# /etc/nginx/conf.d/zh_proxy.conf
upstream zh {
    server 172.16.1.7:80;
    server 172.16.1.8:80;
}
proxy_cache_path /soft/cache levels=1:2 keys_zone=code_cache:10m max_size=10g inactive=60m use_temp_path=off;
server {
    server_name zh.oldboy.com;
    listen 80;
    return 302 https://$server_name$request_uri;
}
server {
    server_name zh.oldboy.com;
    listen 443;
    ssl on;
    ssl_certificate ssl_key/server.crt;
    ssl_certificate_key ssl_key/server.key;
    location / {
        proxy_pass http://zh;
        proxy_cache code_cache;
        proxy_cache_valid 200 304 12h;
        proxy_cache_valid any 10m;
        add_header Nginx-Cache "$upstream_cache_status";
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        include proxy_params;
    }
}
```
> 说明：`proxy_cache_path` 存放缓存；`levels` 两级目录；`keys_zone` 空间名与大小；`max_size` 上限；`inactive` 60 分钟未访问清理；`use_temp_path off` 关临时文件提升性能；`proxy_cache_valid` 不同状态码过期时间；`add_header` 观察命中；`proxy_next_upstream` 异常跳过故障节点。

---

## 十六、firewalld 防火墙

```bash
# 管理机开启
systemctl start firewalld && systemctl enable firewalld

# 管理机仅允许 10.0.0.1 访问 ssh
firewall-cmd --remove-service=ssh --permanent
firewall-cmd --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 service name=ssh accept' --permanent

# LB / zabbix 仅允许 10.0.0.1 访问 http/https
firewall-cmd --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 service name=https accept' --permanent
firewall-cmd --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 service name=http accept' --permanent
firewall-cmd --reload

# 解决 LB 脑裂：放行 VRRP
firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --protocol vrrp -j ACCEPT
firewall-cmd --reload

# 管理机开启 IP 伪装，内网共享上网
firewall-cmd --add-masquerade --permanent
firewall-cmd --add-interface=eth1 --permanent --zone=trusted
firewall-cmd --reload

# 内网服务器指网关到管理机
# /etc/sysconfig/network-scripts/ifcfg-eth1 增加：
# GATEWAY=172.16.1.61
# DNS1=223.5.5.5
nmcli connection down eth1 && nmcli connection up eth1
systemctl restart NetworkManager
```

---

## 十七、SSH / Ansible 批量管理

```bash
rpm -ql openssh-server     # /etc/ssh/sshd_config  /usr/sbin/sshd
rpm -ql openssh-clients    # /usr/bin/{scp,sftp,ssh,ssh-copy-id}

ssh-keygen -t rsa -C www.chengkanghua.top
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.31
yum install sshpass -y
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.5
ssh root@172.16.1.41 "hostname -i"

yum install ansible -y
ansible --version    # 2.6.1

cat > /etc/ansible/hosts <<EOF
[lb]
172.16.1.5
172.16.1.6
[web]
172.16.1.7
172.16.1.8
[sweb]
172.16.1.9
[nfs]
172.16.1.31
[backup]
172.16.1.41
[db]
172.16.1.51
[zabbix]
172.16.1.71
EOF

ansible all -m ping
ansible all -m command -a "df -h"
ansible all -m command -a "hostname"
```

---

## 十八、Zabbix 监控（172.16.1.71）

```bash
# 服务端
rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
# 若 GPG 报错：sed -i 's/gpgcheck=1/gpgcheck=0/' /etc/yum.repos.d/epel.repo
yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server

systemctl start mariadb
mysql -uroot <<EOF
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
EOF

cd /usr/share/doc/zabbix-server-mysql-3.4.13/
zcat create.sql.gz |mysql -uzabbix -pzabbix zabbix

grep '^[a-Z]' /etc/zabbix/zabbix_server.conf
# DBHost=localhost  DBName=zabbix  DBUser=zabbix  DBPassword=zabbix
systemctl start zabbix-server && systemctl enable zabbix-server

vim /etc/httpd/conf.d/zabbix.conf   # 设 date.timezone Asia/Shanghai 等
systemctl start httpd && systemctl enable httpd
# 浏览器 http://IP/zabbix 安装，默认账号 Admin / zabbix

# 客户端 agent（所有主机安装并指向 server）
rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.12-1.el7.x86_64.rpm
sed -i '/^Server=/cServer=172.16.1.71' /etc/zabbix/zabbix_agentd.conf
sed -i '/^ServerActive=/cServerActive=172.16.1.71' /etc/zabbix/zabbix_agentd.conf
sed -i '/^Hostname/c #hostname=zabbix server' /etc/zabbix/zabbix_agentd.conf
# 导入监控项/脚本：for i in 5 7 8 9 31 41 51 52; do scp -rp scripts/ zabbix_agentd.d/ root@172.16.1.$i:/etc/zabbix/; done
```

**Zabbix API 批量创建主机**
```bash
echo 172.16.1.{41,31,7,8,9,61,5,6,51,52}|xargs -n1 > /tmp/ip.txt

cat > create_zabbix.sh <<'EOF'
GetToken=$(curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0","method": "user.login",
"params": {"user": "Admin","password": "zabbix"},"id": 1
}' http://10.0.0.71/zabbix/api_jsonrpc.php)
Token=$(echo $GetToken|awk -F ',' '{print $2}'|awk -F '"' '{print $4}')
while read line;do
curl -s -X POST -H 'Content-Type:application/json' -d "{
  \"jsonrpc\": \"2.0\",\"method\": \"host.create\",
  \"params\": {
    \"host\": \"$line\",
    \"interfaces\": [{\"type\": 1,\"main\": 1,\"useip\": 1,\"ip\": \"$line\",\"dns\": \"\",\"port\": \"10050\"}],
    \"groups\": [{\"groupid\": \"2\"}],
    \"templates\": [{\"templateid\": \"10001\"}]
  },
  \"auth\": \"$Token\",\"id\": 1
}" http://10.0.0.71/zabbix/api_jsonrpc.php|python -m json.tool
done < /tmp/ip.txt
EOF
# 关联模板、配置报警邮箱/微信，测试关闭服务能否报警
```

---

## 面试题

1. **这套架构包含哪些核心组件？**
   Nginx+PHP Web、Tomcat Java、MySQL 主从(GTID)+MHA+Atlas、NFS 共享存储、Rsync/Sersync 备份同步、Nginx LB+Keepalived 高可用、Zabbix 监控、m01 管理/时间/YUM。

2. **Rsync 服务端关键配置？**
   `uid/gid=www`、`auth users`、`secrets file`、`[模块]path`，`fake super=yes`（CentOS7 无 root 也能写属主）。

3. **Sersync 与 Rsync 关系？**
   Sersync 基于 inotify 监控 `/data` 变化，触发 rsync 实时增量同步到 backup；`confxml.xml` 配置监控事件与远端模块。

4. **MySQL 主从用 GTID 的好处？**
   自动定位复制位点，`change master to master_auto_position=1` 无需记 binlog 文件和位置，故障切换更简洁。

5. **MHA 故障转移流程？**
   检测主库故障→选最新从库→比对 relay log→提升为新主→VIP 漂移（`master_ip_failover`）→更新 Atlas 后端→其余从库指向新主。

6. **Atlas 的作用？**
   MySQL 中间件，实现读写分离（写走 VIP 主库、读走从库）与连接池、SQL 审计；通过 `proxy-backend-addresses` / `proxy-read-only-backend-addresses` 配置。

7. **Keepalived 脑裂如何避免？**
   防火墙放行 VRRP 协议（`--protocol vrrp -j ACCEPT`），并配置合理的 `priority` 与 `advert_int`。

8. **Nginx Proxy Cache 如何工作？**
   `proxy_cache_path` 定义缓存区，`proxy_cache` 开启，`proxy_cache_valid` 设各状态码过期时间，`add_header Nginx-Cache` 可观察命中状态（HIT/MISS）。

9. **Zabbix 批量纳管主机的做法？**
   所有节点装 agent 指向 server；通过 Zabbix API 脚本（`host.create`）批量创建主机并关联模板，再配置报警媒介。

---

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/ilfxqm>
