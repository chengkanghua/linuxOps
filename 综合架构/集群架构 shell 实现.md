## 系统基础优化
```bash
hostnamectl set-hostname new_hostname

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


# 内网ip
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

# 防火墙 selinux关闭
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config


# ssh优化
vi /etc/ssh/sshd_config
93行 GSSAPIAuthentication no
129行 UseDNS no

#重启ssh
systemctl restart sshd

rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo


#关闭网卡图形化设置模式
systemctl stop NetworkManager
systemctl disable NetworkManager
#安装tab补全命令
#yum install -y bash-completion.noarch
#下载常用命令
yum install net-tools vim tree htop iotop iftop screen lsof \
iotop lrzsz wget unzip telnet nmap nc tcpdump psmisc \
dos2unix bash-completion sysstat rsync nfs-utils -y

#关闭邮件服务
systemctl stop postfix
systemctl disable postfix.service 

#优化ulimit
echo '* - nofile 65535' >> /etc/security/limits.conf

#至此，模板及优化完成，关机导出ova格式
shutdown -h now


服务器主机名和 IP 规划参考模板如下表：
主机名   eth0 网卡     eth1 网卡      服务简介
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



## m01  搭建yum仓库
```bash

# 安装ftp服务,启动并加入开机启动
yum -y install vsftpd 
systemctl start vsftpd 
systemctl enable vsftpd

# 开启yum缓存功能
sed -i '/^keepcache/c keepcache=1' /etc/yum.conf

yum clean all

# 2.提供基础base源
mkdir -p /var/ftp/centos7
mount /dev/cdrom /mnt
cp -rp  /mnt/Packages/*.rpm /var/ftp/centos7

# 3.提供第三方源
mkdir /var/ftp/ops

#  --downloadonly 仅下载不安装
yum install --downloadonly net-tools vim tree htop iftop \
iotop lrzsz sl wget unzip telnet nmap nc psmisc \
dos2unix bash-completion iotop iftop sysstat screen  -y


# 复制已缓存的 Nginx docker 及依赖包 到自定义 YUM 仓库目录中
find /var/cache/yum/x86_64/7/ -iname "*.rpm" -exec mv -f {} /var/ftp/ops/ \;


4.安装createrepo并创建 reopdata仓库
# 安装createrepo
yum -y install createrepo
# 生成仓库信息
createrepo /var/ftp/ops
createrepo /var/ftp/centos7
# 注意: 如果此仓库每次新增软件则需要重新生成一次


客户端(backup主机上)使用yum源
gzip /etc/yum.repos.d/*
# 1.配置并使用base基础源
cat > /etc/yum.repos.d/centos7.repo <<EOF 
[centos75]
name=centos74_base
baseurl=ftp://172.16.1.61/centos7
gpgcheck=0
EOF
# 2.客户端指向本地ops源
cat > /etc/yum.repos.d/ops.repo <<EOF
[ops]
name=local ftpserver
baseurl=ftp://172.16.1.61/ops
gpgcheck=0
EOF

yum clean all
yum makecache
#其他客户端同步推送过去
rsync -avz /etc/yum.repos.d root@172.16.1.5:/etc/ --delete
rsync -avz /etc/yum.repos.d root@172.16.1.6:/etc/ --delete
rsync -avz /etc/yum.repos.d root@172.16.1.7:/etc/ --delete
rsync -avz /etc/yum.repos.d root@172.16.1.8:/etc/ --delete
rsync -avz /etc/yum.repos.d root@172.16.1.9:/etc/ --delete
.....
```

##  m01主机  时间同步 服务器 
```bash

yum -y install ntp
systemctl start ntpd
systemctl enable ntpd

# netstat -nualp |grep ntp
#检查ntp时间服务器是否正常
ntpstat
ntpq -p

#定时任务每小时同步阿里云时间服务器
echo '* */1 * * * /usr/sbin/ntpdate ntp1.aliyun.com' >> /var/spool/cron/root
[root@m01 ~]# crontab -l
00 01 * * * /usr/bin/bash /server/scripts/clinet_rsync_backup.sh >/dev/null 2>&1
* */1 * * * /usr/sbin/ntpdate ntp1.aliyun.com


# 客户端写定时任务，每一分钟同步一次时间
# echo '* */1 * * * /usr/sbin/ntpdate 172.16.1.61' >> /var/spool/cron/root
for i in 5 6 7 8 9 51 52 53 31 41 71
do
  ssh root@172.16.1.$i "echo '* */1 * * * /usr/sbin/ntpdate 172.16.1.61' >> /var/spool/cron/root"
done

```



## backup 
```bash
hostnamectl set-hostname backup && bash
# yum install rsync -y   # 基础环境已经安装
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
# 创建rsync使用的虚拟连接用户
echo "rsync_backup:1" > /etc/rsync.password
chmod 600 /etc/rsync.password

systemctl enable rsyncd
systemctl start rsyncd
# netstat -lntp |grep 873



# 客户端只安装rsync不用启动服务,   定时执行脚本推送backup服务器
# 先在m01 操作
mkdir -p /server/scripts/
cat > /server/scripts/client_rsync_backup.sh <<-'EOF'
#!/usr/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
#1.定义变量
Host=$(hostname)
Addr=$(ifconfig eth1|awk 'NR==2{print $2}')
Date=$(date +%F)
Dest=${Host}_${Addr}_${Date}
Path=/backup

#2.创建备份目录
[ -d $Path/$Dest ] || mkdir -p $Path/$Dest

#3.备份对应的文件
cd / && \
[ -f $Path/$Dest/system.tar.gz ] || tar czf $Path/$Dest/system.tar.gz etc/fstab etc/rsyncd.conf && \
[ -f $Path/$Dest/log.tar.gz ] || tar czf $Path/$Dest/log.tar.gz  var/log/messages var/log/secure && \

#4.携带md5验证信息
[ -f $Path/$Dest/flag_$Date ] || md5sum $Path/$Dest/*.tar.gz >$Path/$Dest/flag_${Date}

#4.推送本地数据至备份服务器
export RSYNC_PASSWORD=1
rsync -avz $Path/ rsync_backup@172.16.1.41::backup

#5.本地保留最近7天的数据
find $Path/ -type d -mtime +7|xargs rm -rf
EOF

#---------------------------------------------
#-'EOF'   分割线
#-------------------------------


#多台客户端 定时任务 m01
echo '00 01 * * * /usr/bin/bash /server/scripts/client_rsync_backup.sh >/dev/null 2>&1' >> /var/spool/cron/root
# crontab -l

# 测试
sh /server/scripts/client_rsync_backup.sh

#m01 批量分发公钥免密登录
yum install sshpass -y
ssh-keygen -t rsa -C www.chengkanghua.top   #一路回车即可
for i in 5 6 7 8 9 51 52 53 31 41 71
do
  sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.$i
done

# 多台客户端快速增加 
for i in 5 6 7 8 9 51 52 53 31 71
do
  scp -rp /var/spool/cron/root root@172.16.1.$i:/var/spool/cron/  && \
  rsync -avz /server root@172.16.1.$i:/
done



#  服务端backup 校验压缩包 发送给管理员
# .配置邮箱（配发件服务器）
yum install mailx -y
cat > /etc/mail.rc <<EOF
set from=343264992@163.com
set smtp=smtp.163.com
set smtp-auth-user=343264992@163.com
set smtp-auth-password=MMaNQcY4HFTRJC2q
set smtp-auth=login
set ssl-verify=ignore
EOF

# 发邮件测试
# echo 'test' > test.log
# mail -s "Rsync Backup $Date" 343264992@163.com < test.log


mkdir /server/scripts -p
cat > /server/scripts/check_backup.sh <<\EOF
#!/usr/bin/bash

#1.定义全局的变量
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

#2.定义局部变量
Path=/backup
Date=$(date +%F)

#3.查看flag文件,并对该文件进行校验, 然后将校验的结果保存至result_时间
find $Path/*_${Date} -type f -name "flag_$Date"|xargs md5sum -c >$Path/result_${Date}

#4.将校验的结果发送邮件给管理员
mail -s "Rsync Backup $Date" 343264992@qq.com <$Path/result_${Date}

#5.删除超过7天的校验结果文件, 删除超过180天的备份数据文件
find $Path/ -type f -name "result*" -mtime +7|xargs rm -f
find $Path/ -type d -mtime +180|xargs rm -rf
EOF

#------------
#\EOF
#----------



#服务端
echo '00 05 * * * /usr/bin/bash /server/scripts/check_backup.sh >/dev/null 2>&1' > /var/spool/cron/root

[root@backup ~]# crontab -l
00 05 * * * /usr/bin/bash /server/scripts/check_backup.sh >/dev/null 2>&1
* */1 * * * /usr/sbin/ntpdate 172.16.1.61

```



## nfs共享存储
```bash
# ssh root@10.0.0.31
hostnamectl set-hostname nfs01 && bash

groupadd -g666 www
useradd -u666 -g666 -s /sbin/nologin -M www

#安装nfs-utils
yum install nfs-utils

#准备共享配置
cat > /etc/exports <<EOF
/data/blog 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
/data/zh   172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
/data/jpress 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
EOF

# 创建目录并授权
mkdir /data/{blog,zh,jpress} -p
chown -R www.www /data
systemctl enable nfs-server
systemctl start nfs-server


```



## NFS 共享存储数据实时复制到 backup
```bash
# 安装inotify-tools
yum install inotify-tools rsync -y
# 安装sersync   https://github.com/wsgzao/sersync
wget https://raw.githubusercontent.com/wsgzao/sersync/master/sersync2.5.4_64bit_binary_stable_final.tar.gz
# 解压重命名
tar xf sersync2.5.4_64bit_binary_stable_final.tar.gz -C /usr/local/
mv /usr/local/GNU-Linux-x86/ /usr/local/sersync

cp /usr/local/sersync/confxml.xml{,.bak}
[root@nfs01 ~]# cat /usr/local/sersync/confxml.xml
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
	    <userDefinedPort start="false" port="874"/><!-- port=874 -->
	    <timeout start="true" time="100"/><!-- timeout=100 -->
	    <ssh start="false"/>
	</rsync>
	<failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once-->
	<crontab start="false" schedule="600"><!--600mins-->
	    <crontabfilter start="false">
		<exclude expression="*.php"></exclude>
		<exclude expression="info/*"></exclude>
	    </crontabfilter>
	</crontab>
	<plugin start="false" name="command"/>
    </sersync>

</head>
EOF

#创建密码文件
echo "1" > /etc/rsync.pass
chmod 600 /etc/rsync.pass
#backup创建目录
# mkdir /data
# chown -R www.www /backup/ /data/
# 启动sersync
/usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml

---------------------------------------------------------------------------------

# 配置说明
[root@nfs01 sersync]# vim /usr/local/sersync/confxml.xml
     <fileSystem xfs="true"/>  <!-- 文件系统 -->
     <filter start="false">  <!-- 排除不想同步的文件-->
         <exclude expression="(.*)\.svn"></exclude>
         <exclude expression="(.*)\.gz"></exclude>
         <exclude expression="^info/*"></exclude>
         <exclude expression="^static/*"></exclude>
     </filter>
     <inotify> <!-- 监控的事件类型 -->
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
         <localpath watch="/data"> <!-- 监控的目录 -->
             <remote ip="172.16.1.41" name="data"/>  <!-- backup的IP以及模块 -->
         </localpath>
         <rsync> <!-- rsync的选项 -->
            <commonParams params="-az"/>
             <auth start="true" users="rsync_backup" passwordfile="/etc/rsync.pass"/>
             <userDefinedPort start="false" port="874"/><!-- port=874 -->
             <timeout start="true" time="100"/><!-- timeout=100 -->
             <ssh start="false"/>
         </rsync>
           <!-- 每60分钟执行一次同步-->
         <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--def
   ault every 60mins execute once-->
```



## web01web02 操作
```bash
# ssh root@10.0.0.7
hostnamectl set-hostname web01 && bash
# ssh root@10.0.0.8
hostnamectl set-hostname web02 && bash


# .创建www用户
groupadd -g 666 www
useradd -u666 -g666 -s /sbin/nologin -M www

#1.使用Nginx官方提供的rpm包   # $basearch获取不到值，改成arch命令的值x86_64
cat > /etc/yum.repos.d/nginx.repo<<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64/ 
gpgcheck=0
enabled=1
EOF

# 安装php 扩展源
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils nginx
# 安装 PHP7.3：
yum install -y php73-php-fpm php73-php-cli php73-php-bcmath php73-php-gd php73-php-json php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pecl-crypto php73-php-pecl-mcrypt php73-php-pecl-geoip php73-php-recode php73-php-snmp php73-php-soap php73-php-xml

# 配置web站点【wordpress|wecenter】
sed -i '/^user/c user www;' /etc/nginx/nginx.conf
sed -i '/^user/c user = www' /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i '/^group/c group = www' /etc/opt/remi/php73/php-fpm.d/www.conf

#查找php.ini位置
# find /etc/opt/remi/php73 -name php.ini

#处理 CGI 模式下的路径解析问题
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/opt/remi/php73/php.ini

systemctl restart php73-php-fpm  nginx
systemctl enable php73-php-fpm nginx
php73 -v
nginx -v


#调整网站上传文件大小
#vim /etc/php.ini
#memory_limit = 1024M
#post_max_size = 1024M
#upload_max_filesize = 1024M　　
#max_execution_time=60
#max_input_time=60

#sed -i '/^memory_limit/c memory_limit = 1024M' /etc/php.ini
#sed -i '/^post_max_size/c post_max_size = 1024M' /etc/php.ini
#sed -i '/^upload_max_filesize/c upload_max_filesize = 1024M' /etc/php.ini

#vim nginx配置文件 nginx.conf, 找到http{} 段 添加
#client_max_body_size 1024M; 

# sed -i '29aclient_max_body_size 1024M;' /etc/nginx/nginx.conf
# 重启服务生效配置
# systemctl restart nginx php-fpm




```



##  mysql-mha-atlas
```bash
ssh root@10.0.0.51
hostnamectl set-hostname db01 && bash
ssh root@10.0.0.52
hostnamectl set-hostname db02 && bash
ssh root@10.0.0.53
hostnamectl set-hostname db03 && bash


# 三台主机安装  mysql5.7官方yum 源安装
rpm -qa |grep mariadb
yum remove mariadb-libs -y
wget https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
rpm -ivh mysql57-community-release-el7-8.noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install mysql-server -y

systemctl start mysqld
systemctl status mysqld
systemctl enable mysqld
ps -ef | grep mysql
rpm -qa |grep -i mysql

#取出临时密码赋值给pass变量
pass=`grep 'A temporary password' /var/log/mysqld.log |awk '{print $NF}'`

mysql -uroot -p$pass
#下面是MySQL登录交互式操作
set global validate_password_policy=LOW;  -- 设置低密码策略;
set global validate_password_length=6;    -- 密码长度6位;
ALTER USER USER() IDENTIFIED BY '123456';
show variables like '%char%';
GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; -- 远程登录;
FLUSH PRIVILEGES;
quit


# 字符编码配置
tee -a /etc/my.cnf <<EOF
[client]
# 设置字符编码
default-character-set=utf8
[mysqld]
character-set-server=utf8
collation-server=utf8_general_ci
EOF

systemctl restart mysqld


#登录数据库
[root@mysql-db01 ~]# mysql -uroot -p123456
#创建rep用户
mysql> grant replication slave on *.* to rep@'172.16.1.%' identified by 'Oldboy@123.com';

# 主从开启gtid
gtid_mode=ON
enforce_gtid_consistency

[root@db01 ~]# cat /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
character-set-server=utf8
collation-server=utf8_general_ci
server_id=1
log_bin=mysql-bin
gtid_mode=ON
enforce_gtid_consistency
relay_log_purge = 0
skip_name_resolve
[client]
default-character-set=utf8

[root@db02 ~]# cat /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
character-set-server=utf8
collation-server=utf8_general_ci
server_id=5
log_bin=mysql-bin
gtid_mode=ON
enforce_gtid_consistency
#禁用自动删除relay log 永久生效 #这个参数主库也设置一下
relay_log_purge = 0
skip_name_resolve
[client]
default-character-set=utf8

[root@db03 ~]# cat /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
character-set-server=utf8
collation-server=utf8_general_ci
server_id=6
log_bin=mysql-bin
gtid_mode=ON
enforce_gtid_consistency
#禁用自动删除relay log 永久生效 #这个参数主库也设置一下
relay_log_purge = 0
skip_name_resolve
[client]
default-character-set=utf8

#修改配置后重启mysql
systemctl restart mysqld



# 两台从库开启主从复制
# mysql -uroot -p123456
 change master to
master_host='172.16.1.51',
master_user='rep',
master_password='Oldboy@123.com',
master_auto_position=1;

start slave;
show slave status \G




# mha
# 所有主机
yum install perl-DBD-MySQL -y
mkdir ~/tools -p && cd ~/tools
wget https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
wget https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node-0.58-0.el7.centos.noarch.rpm

rpm -ivh mha4mysql-node-0.58-0.el7.centos.noarch.rpm

# yum安装的mysql 已经有了 ,不用做软链接
# ln -s /application/mysql/bin/mysqlbinlog /usr/bin/mysqlbinlog
# ln -s /application/mysql/bin/mysql /usr/bin/mysql

#登录主库数据库
# mysql -uroot -p123456
grant all privileges on *.* to mha@'172.16.1.%' identified by 'Mha@123.com';
select user,host from mysql.user;
#从库会自动复制（在从库上查看）

# 部署管理节点（mha-manager:mysql-db03）随便找一台机器,或者在三台数据中一台都可以, 最好在从库,防止主库断电

#安装manager依赖包
yum install -y perl-Config-Tiny epel-release perl-Log-Dispatch perl-Parallel-ForkManager perl-Time-HiRes

#安装manager包
rpm -ivh mha4mysql-manager-0.58-0.el7.centos.noarch.rpm

#创建配置文件目录
mkdir -p /etc/mha
#创建日志目录
mkdir -p /var/log/mha/app1
#编辑mha配置文件  如果有两套集群搞两个配置文件
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

#所有节点做互信,都可以相互免密登录 #每个节点都执行下3条命令
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa >/dev/null 2>&1
#发送公钥，包括自己
ssh-copy-id -i /root/.ssh/id_dsa.pub root@172.16.1.51
ssh-copy-id -i /root/.ssh/id_dsa.pub root@172.16.1.52
ssh-copy-id -i /root/.ssh/id_dsa.pub root@172.16.1.53


# 配置vip漂移 # atlas高可用版本
cat > /usr/local/bin/master_ip_failover <<\EOF
#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Getopt::Long;

my (
    $command,          $ssh_user,        $orig_master_host, $orig_master_ip,
    $orig_master_port, $new_master_host, $new_master_ip,    $new_master_port
);

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

    print "\n\nIN SCRIPT TEST====$ssh_stop_vip==$ssh_start_vip===\n\n";

    if ( $command eq "stop" || $command eq "stopssh" ) {

        my $exit_code = 1;
        eval {
            print "Disabling the VIP on old master: $orig_master_host \n";
            &stop_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn "Got Error: $@\n";
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "start" ) {

        my $exit_code = 10;
        eval {
            print "Enabling the VIP - $vip on the new master - $new_master_host \n";
            &start_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn $@;
            exit $exit_code;
        }
        exit $exit_code;
    }
    elsif ( $command eq "status" ) {
        print "Checking the Status of the script.. OK \n";
        exit 0;
    }
    else {
        &usage();
        exit 1;
    }
}

sub start_vip() {
    `ssh $ssh_user\@$new_master_host \" $ssh_start_vip \"`;
    my $atlas_bad_id = `mysql -uuser -ppwd -h 127.0.0.1 -P2345 -e 'select * from backends' |awk /$new_master_host/'{print \$1}'`;
     system "ssh -t 172.16.1.\$(echo $orig_master_host | awk -F'.' '{print \$4}') '/usr/local/mysql-proxy/bin/mysql-proxyd test stop'";
    `ssh 172.16.1.51 \" mysql -uuser -ppwd -h 127.0.0.1 -P2345 -e 'remove backend $atlas_bad_id; SAVE CONFIG;' \"`;
    `ssh 172.16.1.52 \" mysql -uuser -ppwd -h 127.0.0.1 -P2345 -e 'remove backend $atlas_bad_id; SAVE CONFIG;' \"`;
    `ssh 172.16.1.53 \" mysql -uuser -ppwd -h 127.0.0.1 -P2345 -e 'remove backend $atlas_bad_id; SAVE CONFIG;' \"`;
 

}
sub stop_vip() {
     return 0  unless  ($ssh_user);
    `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip;  \"`;
}

sub usage {
    print
    "Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}

EOF
#-----------------------
#\EOF   分隔符
#-----------------

chmod +x /usr/local/bin/master_ip_failover


# 手动绑定VIP 在主服务器上绑定 vip,可以提前绑定 
#绑定vip
ifconfig eth1:1 172.16.1.55/24
#查看vip
ip a |grep eth1

#启动测试
masterha_check_ssh --conf=/etc/mha/app1.cnf
masterha_check_repl --conf=/etc/mha/app1.cnf

#启动mha
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

#查看状态
masterha_check_status --conf=/etc/mha/app1.cnf

# 重启mha
# masterha_stop --conf=/etc/mha/app1.cnf
# nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &



# MySQL中间件Atlas

cd ~/tools/
wget https://github.com/Qihoo360/Atlas/releases/download/2.2.1/Atlas-2.2.1.el6.x86_64.rpm
rpm -ivh Atlas-2.2.1.el6.x86_64.rpm 

#进入Atlas工具目录
cd /usr/local/mysql-proxy/bin/
# root用户的密码加密 ,后续给开发的账号也要添加到atlas配置里,
# /usr/local/mysql-proxy/bin/encrypt 123456
/iZxz+0GRoA=

#rep的密码加密
# /usr/local/mysql-proxy/bin/encrypt Oldboy@123.com
cr8+Kh8Hu2Z9yWwPW5JmmQ==
# mha的密码加密
# /usr/local/mysql-proxy/bin/encrypt Mha@123.com
lWwLt+QjEMIjJfKhmDS20Q==

cat > /usr/local/mysql-proxy/conf/test.cnf <<\EOF
[mysql-proxy]
admin-username = user
admin-password = pwd
#Atlas后端连接的MySQL主库的IP和端口，可设置多项，用逗号分隔, # 写vip地址
proxy-backend-addresses = 172.16.1.55:3306
#Atlas后端连接的MySQL从库的IP和端口
proxy-read-only-backend-addresses = 172.16.1.52:3306,172.16.1.53:3306
#用户名与其对应的加密过的MySQL密码
pwds = mha:lWwLt+QjEMIjJfKhmDS20Q==,repl:cr8+Kh8Hu2Z9yWwPW5JmmQ==,root:/iZxz+0GRoA=
daemon = true
keepalive = true
event-threads = 8
log-level = message
log-path = /usr/local/mysql-proxy/log
#SQL日志的开关
sql-log=ON
sql-log-slow = 10
admin-address = 0.0.0.0:2345
#Atlas监听的工作接口IP和端口
proxy-address = 0.0.0.0:3307
#默认字符集，设置该项后客户端不再需要执行SET NAMES语句
charset=utf8
EOF

#\EOF --------------分隔符

# 启动Atlas
/usr/local/mysql-proxy/bin/mysql-proxyd test start


# Atlas 高可用方法,集群每台机器都装 Atlas, 使用 vip 作为对外提供服务
# 主库出故障停止服务, 提升一个最新的从库为主库,其他从库从新指向新主库, 同时 vip 漂移到新主库机器上,
# 同时更新 atlas 中的移除 新主库的 ip 地址(之前是从库),更新配置文件
# 三台机器都按这个配置安装启动即可

--------------------------------------------------------------mha 切换后修复
mha启动时读取配置文件: 
    从上到下,按行读取
    切换后,摘除down掉的主机
    重写配置文件
# master 主机上配置文件
[root@db01 tmp]# cat /etc/mha/app1.cnf

MHA修复步骤:
1.修复down的主库   
# /etc/init.d/mysqld start 
2.在mha日志中找到: change master to 语句 
# grep -i 'change master to' /var/log/mha/app1/manager.log
3.连接旧主库,执行change master to 语句
change master to 
master_host='10.0.0.11',
master_port=3306, 
master_auto_position=1, 
master_user='rep',
master_password='oldboy123';


4.打开IO,SQL线程(start slave;)
start slave 
5.把旧主库的server标签在MHA配置文件中添加回来  
# vi /etc/mha/app1.cnf
6.启动MHA
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover < /dev/null > /var/log/mha/app1/manager.log 2>&1 &

masterha_check_status --conf=/etc/mha/app1.cnf


```



## 部署 wordpress  Wecenter
```bash
#部署wordpress

#1.配置Nginx虚拟主机站点
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

#2.重启nginx服务
systemctl restart nginx

#3.下载wordpress产品，部署wordress并授权
wget https://cn.wordpress.org/wordpress-4.9.4-zh_CN.tar.gz
mkdir -p /code
#2.解压网站源码文件,拷贝至对应站点目录,并授权站点目录
tar zxvf wordpress-4.9.4-zh_CN.tar.gz -C /code/
chown -R www.www /code/wordpress

# 创建数据库和开发用的账号
mysql -uroot -p123456 -h172.16.1.55 -P3307  

create database wordpress;
GRANT all privileges ON wordpress.* TO blog@'172.16.1.%' IDENTIFIED BY 'Blog@123.com';
FLUSH PRIVILEGES;

#5.通过浏览器访问wordpress, 并部署该产品  
# windows修改hosts
# 10.0.0.7 blog.oldboy.com
# http://blog.oldboy.com/wordpress  


#部署Wecenter
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

mkdir -p /code/zh ;cd /code

# 2.下载Wecenter产品，部署Wecenter并授权
wget https://github.com/wecenter/wecenter/archive/refs/tags/3.1.9.zip
unzip download.zip -d /code/zh
mv /code/zh/wecenter-3.1.9/* /code/zh/
rm -rf /code/zh/wecenter-3.1.9
chown -R www.www /code/zh/

# 3.由于wecenter产品需要依赖数据库, 所以需要手动建立数据库
#1.登陆数据库
mysql -uroot -p123456 -h172.16.1.55 -P3307  
#2.创建wecenter数据库
create database wecenter;
GRANT all privileges ON wecenter.* TO zh@'172.16.1.%' IDENTIFIED BY 'Zh@123.com';
FLUSH PRIVILEGES;

#更新atlas配置文件 
[root@db01 tools]# /usr/local/mysql-proxy/bin/encrypt Blog@123.com
9LC9u6ancfPJ50hl9Y7q9w==
[root@db01 tools]# /usr/local/mysql-proxy/bin/encrypt Zh@123.com
tUU6igbdR2jgSv1GServJg==

# 三台atlas都操作
# vi /usr/local/mysql-proxy/conf/test.cnf
pwds = mha:lWwLt+QjEMIjJfKhmDS20Q==,repl:cr8+Kh8Hu2Z9yWwPW5JmmQ==,root:/iZxz+0GRoA=,blog:9LC9u6ancfPJ50hl9Y7q9w==,zh:tUU6igbdR2jgSv1GServJg==
# 重启atlas
/usr/local/mysql-proxy/bin/mysql-proxyd test stop && /usr/local/mysql-proxy/bin/mysql-proxyd test start

#验证可以登录
# mysql -uzh -pZh@123.com -h172.16.1.55 -P3307


3.通过浏览器访问网站
windows : C:\Windows\System32\drivers\etc\hosts
10.0.0.7 zh.oldboy.com/
浏览器访问 zh.oldboy.com/install/



# web02 复制nginx配置文件过去,和 源码
scp /etc/nginx/conf.d/* root@10.0.0.8:/etc/nginx/conf.d/
rsync -az /code root@10.0.0.8:/
#切换到web02操作
systemctl restart nginx php73-php-fpm
#修改hosts 访问测试
```



## [](#1a3bdw)web03 JAVA站点
```bash
ssh root@10.0.0.9
hostnamectl set-hostname web03 && bash

yum install java -y
mkdir /code ; cd /code
wget https://mirror.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.95/bin/apache-tomcat-9.0.95.tar.gz
tar xf apache-tomcat-9.0.95.tar.gz
ln -s /code/apache-tomcat-9.0.95 /code/tomcat


# 下载jpress
cd /code/tomcat/webapps
# https://gitee.com/chengkanghua/jpress/tree/master/wars
# rz 上传jpress的war
#重启tomcat  会自动解压 war包
#/code/tomcat/bin/shutdown.sh
# /code/tomcat/bin/startup.sh

# 修改tomcat配置  不用接路径访问, 在配置文件的 <Host> 标签内部添加
sed -i.ori '163a <Context path="" docBase="/code/tomcat/webapps/jpress-web-newest" debug="0" reloadable="false" crossContext="true"/>' /code/tomcat/conf/server.xml
#重启tomcat
/code/tomcat/bin/shutdown.sh
/code/tomcat/bin/startup.sh

#浏览器访问 http://10.0.0.9:8080/jpress-web-newest/install 改成http://10.0.0.9:8080/install



#1.登陆数据库
mysql -uroot -p123456 -h172.16.1.55 -P3307  
#2.创建wecenter数据库
create database jpress;
GRANT all privileges ON jpress.* TO press@'172.16.1.%' IDENTIFIED BY 'Press@123.com';
FLUSH PRIVILEGES;

#更新atlas配置文件 
[root@db01 tools]# /usr/local/mysql-proxy/bin/encrypt Press@123.com
485F3MpDTKRKR8K2xIyPJg==


# 三台atlas都操作
# vi /usr/local/mysql-proxy/conf/test.cnf
pwds = mha:lWwLt+QjEMIjJfKhmDS20Q==,repl:cr8+Kh8Hu2Z9yWwPW5JmmQ==,root:/iZxz+0GRoA=,blog:9LC9u6ancfPJ50hl9Y7q9w==,zh:tUU6igbdR2jgSv1GServJg==,press:485F3MpDTKRKR8K2xIyPJg==
# 重启atlas
/usr/local/mysql-proxy/bin/mysql-proxyd test stop && /usr/local/mysql-proxy/bin/mysql-proxyd test start

#验证可以登录
# mysql -upress -pPress@123.com -h172.16.1.55 -P3307


-------------------------------------------------------------------------------
# 默认安装的是openjdk, 可以换成官方的java
wget https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.rpm
rpm -ivh jdk-8u202-linux-x64.rpm
echo 'JAVA_HOME=/usr/java/jdk1.8.0_202-amd64/' >>/etc/profile
echo 'PATH=$JAVA_HOME:$PATH' >> /etc/profile
source /etc/profile


-------------------------------------------------------------------------------
#本机安装一个nginx 作反向代理
[root@web03 webapps]# yum install nginx -y
#拷贝nginx配置文件
[root@web02 code]# sed -i '29aclient_max_body_size 1024M;' /etc/nginx/nginx.conf
[root@web03 conf.d]# vim jpress.conf
server {
        listen 80;
        server_name jpress.oldboy.com;

        location / {
                proxy_pass http://127.0.0.1:8080;
proxy_set_header Host $http_host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_connect_timeout 30;
proxy_send_timeout 60;
proxy_read_timeout 60;
proxy_buffering on;
proxy_buffer_size 32k;
proxy_buffers 4 128k;
        }
}


[root@web03 conf.d]# systemctl enable nginx
[root@web03 conf.d]# systemctl start nginx


```

## 挂载 nfs 共享存储
```bash
#####################################################################################
# web01 执行挂载wordpress  # zh 挂载
cd /code/wordpress/wp-content/
mv uploads/ uploads_bak
mkdir uploads
mount -t nfs 172.16.1.31:/data/blog /code/wordpress/wp-content/uploads
cp -rp uploads_bak/* uploads/
chown -R www.www uploads/

cd /code/zh/
mv uploads/ uploads_bak
mkdir uploads
mount -t nfs 172.16.1.31:/data/zh /code/zh/uploads
cp -rp uploads_bak/* uploads/
chown www.www uploads

#web02上面直接挂载即可
mkdir /code/wordpress/wp-content/uploads
mount -t nfs 172.16.1.31:/data/blog /code/wordpress/wp-content/uploads
mount -t nfs 172.16.1.31:/data/zh /code/zh/uploads


# web03 java
cd /code/tomcat/webapps/jpress-web-newest
mv attachment/ attachment_bak
mkdir attachment
mount -t nfs 172.16.1.31:/data/jpress /code/tomcat/webapps/jpress-web-newest/attachment
cp -rp attachment_bak/* attachment/



# 记得加入开机自动挂载
vim /etc/fstab
172.16.1.31:/data/blog /code/wordpress/wp-content/uploads nfs defaults 0 0
172.16.1.31:/data/zh /code/zh/uploads nfs defaults 0 0
172.16.1.31:/data/jpress /code/tomcat/webapps/jpress-web-newest/attachment nfs defaults 0 0
df -h | grep data
mount -a
```

[  
](#tsgiop)







## [](#7ys0gr)lb01操作
```bash
ssh root@10.0.0.5
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


##共有优化配置文件
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

systemctl enable nginx 
systemctl start nginx
```

## [](#d91ics)lb01操作HTTPS
```bash
1.生成ssl
[root@web01 code]# mkdir /etc/nginx/ssl_key 
[root@web01 code]# cd /etc/nginx/ssl_key/
[root@web01 ~]# openssl genrsa -idea -out server.key 2048
这里密码设置1234
[root@web01 ~]# openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:WH
Locality Name (eg, city) [Default City]:WH
Organization Name (eg, company) [Default Company Ltd]:edu    
Organizational Unit Name (eg, section) []:SA
Common Name (eg, your name or your servers hostname) []:bgx
Email Address []:bgx@foxmail.com


2.配置nginx的负载均衡支持https【代码实例-其他自行修改】
[root@lb01 conf.d]# cat blog_proxy.conf 
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

## [](#hrqgwx)+keepalived
```bash
ssh root@10.0.0.6
hostnamectl set-hostname lb02 && bash
#两台lb 一模一样配置 , 快速配置一台lb02-6
scp -rp root@172.16.1.5:/etc/yum.repos.d/nginx.repo /etc/yum.repos.d/
yum install nginx -y
rsync -avz root@172.16.1.5:/etc/nginx /etc/ --delete
systemctl start nginx
systemctl enable nginx


# 两台lb 都安装 keepalived
yum install keepalived -y


# lb01 配置 keepalived
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
systemctl restart keepalived
systemctl enable keepalived

# lb02 配置
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

systemctl restart keepalived
systemctl enable keepalived


```

## [](#pz4rgc)NginxProxyCache 实现负载均衡缓存
```bash
mkdir /soft/cache
chown -R www.www /soft/cache

# lb01 配置
[root@lb01 conf.d]# cat /etc/nginx/conf.d/zh_proxy.conf
upstream zh {
	server 172.16.1.7:80;
	server 172.16.1.8:80;
}
proxy_cache_path /soft/cache levels=1:2 keys_zone=code_cache:10m max_size=10g inactive=60m use_temp_path=off;
server {
	server_name zh.oldboy.com
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
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503  http_504;
		include proxy_params;
	}
}

配置说明
#proxy_cache存放缓存临时文件
#levels     按照两层目录分级
#keys_zone  开辟空间名, 10m:开辟空间大小, 1m可存放8000key
#max_size   控制最大大小, 超过后Nginx会启用淘汰规则
#inactive   60分钟没有被访问缓存会被清理
#use_temp_path  临时文件, 会影响性能, 建议关闭

#proxy_cache        开启缓存
#proxy_cache_valid  状态码200|304的过期为12h, 其余状态码10分钟过期
#proxy_cache_key    缓存key
#add_header         增加头信息, 观察客户端respoce是否命中
#proxy_next_upstream 出现502-504或错误, 会跳过此台服务器访问下台


```

## 
## [  
](#t68wgw)
## [](#p4s6rm)防火墙 firewalld
```bash
1. 管理机操作如下【管理机|负载均衡|zabbix】firewall

[root@m01 ~]# systemctl start firewalld
[root@m01 ~]# systemctl enable firewalld

#移除默认所有人能访问ssh的规则
[root@m01 ~]# firewall-cmd --remove-service=ssh --permanent

#添加只允许10.0.0.1这台主机访问
[root@m01 ~]# firewall-cmd --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 service name=ssh accept' --permanent

#lb02 和 lb02设置  允许10.0.0.1访问http https服务   zabbix 也需要开启
[root@lb01 ~]# firewall-cmd --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 service name=https accept' --permanent
[root@lb01 ~]# firewall-cmd --add-rich-rule='rule family=ipv4 source address=10.0.0.1/32 service name=http accept' --permanent

# 重载配置
[root@lb01 services]# firewall-cmd --reload
# 检查结果
[root@lb01 services]# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0
  sources:
  services: dhcpv6-client
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
	rule family="ipv4" source address="10.0.0.1/32" service name="ssh" accept
	rule family="ipv4" source address="10.0.0.1/32" service name="http" accept
	rule family="ipv4" source address="10.0.0.1/32" service name="https" accept

# lb01 和lb02 会出现列脑问题 解决  两台lb执行下面三条命令
firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0  --protocol vrrp -j ACCEPT
firewall-cmd --direct --get-all-rules
#重载配置
firewall-cmd --reload

		
# 开启ip伪装，为后续主机提供共享上网【管理机开就可以】
[root@m01 ~]# firewall-cmd --add-masquerade  --permanent
# 重启firewalld生效
[root@m01 ~]# firewall-cmd --reload
#将内网网卡加入到trusted区域
[root@m01 ~]# firewall-cmd --add-interface=eth1 --permanent --zone=trusted

#########没有公网地址的内部服务器配置指向管理机的网关
[root@backup ~]# /etc/sysconfig/network-scripts/ifcfg-eth1  # 配置新增如下2条规则
GATEWAY=172.16.1.61
DNS1=223.5.5.5
[root@backup ~]# nmcli connection down eth1 && nmcli connection up eth1
# 重启networkmanager 就可以访问公网了
[root@backup ~]# systemctl restart NetworkManager

```

## [  
](#g4dqql)
## [](#gmasbl)SSH、Ansible,批量管理服务项目
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
[root@m01 ~]# ssh-keygen -t rsa -C www.chengkanghua.top   #一路回车即可
[root@m01 ~]# ls ~/.ssh/
id_rsa(钥匙)  id_rsa.pub(锁头)

2#发送密钥给需要登录的用户
[root@m01 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.31

[root@m01 ~]# yum install sshpass -y
[root@m01 ~]# sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.5
#远程登录对端主机方式
[root@m01 ~]# ssh root@172.16.1.41

# 不登陆主机执行命令
[root@m01 ~]# ssh root@172.16.1.41 "hostname -i"

# ansible借助公钥批量管理
#利用非交换式工具实现批量分发公钥与批量管理服务器
[root@m01 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.41

[root@m01 ~]# yum install ansible -y

//检查ansible版本
[root@m01 ~]# ansible --version
ansible 2.6.1

配置ansible  主机清单
[root@m01 ~]# vim /etc/ansible/hosts
[root@m01 7]# cat /etc/ansible/hosts
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

# ansible是通过ssh端口探测通信
[root@m01 ~]# ansible all -m ping

#批量执行命令
[root@m01 ~]# ansible all -m command -a "df -h"
[root@m01 ~]# ansible all -m command -a "hostname"
```

## [](#3r72pg)172.16.1.71 zabbix 监控
```bash
1.配置Zabbix仓库
[root@zabbix-server ~]# rpm -ivh
https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
2.安装Zabbix程序包，以及MySQL、Zabbix-agent
[root@zabbix-server ~]# yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server

安装警告提示
从 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 检索密钥
获取 GPG 密钥失败：[Errno 14] curl#37 - "Couldn't open file /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7"
[root@m01 yum.repos.d]# vim /etc/yum.repos.d/epel.repo
gpgcheck=0      #改成0#  3处

3.创建Zabbix数据库以及用户
[root@zabbix-server ~]# systemctl start mariadb
[root@zabbix-server ~]# mysql -uroot
MariaDB [(none)]> create database zabbix character set utf8 collate utf8_bin;
MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';

2.倒入数据库
[root@zabbix ~]# cd /usr/share/doc/zabbix-server-mysql-3.4.13/
[root@zabbix ~]# zcat create.sql.gz |mysql -uzabbix -pzabbix zabbix

3.配置zabbix-server
[root@zabbix ~]#grep '^[a-Z]' /etc/zabbix/zabbix_server.conf 
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
4.启动zabbix-server
[root@zabbix ~]# systemctl start zabbix-server
[root@zabbix ~]# systemctl enable zabbix-server

5.调整时区
[root@zabbix ~]# vim /etc/httpd/conf.d/zabbix.conf
php_value max_execution_time 300
php_value memory_limit 128M
php_value post_max_size 16M
php_value upload_max_filesize 2M
php_value max_input_time 300
php_value always_populate_raw_post_data -1
#取消注释，设置正确的时区
php_value date.timezone Asia/Shanghai

6.重启Apache Web服务器
[root@zabbix ~]# systemctl start httpd
[root@zabbix ~]# systemctl enable httpd

# mariadb也要加入开机自启
[root@zabbix ~]# systemctl start mariadb.service

9.通过浏览器访问http://IP/zabbix 进入向导页面，进行zabbix安装。
10.完成zabbix安装后，默认的账户和密码是  Admin  zabbix


zabbix监控-agent-----
1.所有主机都需要安装agent，并且需要指定zabbix-server
[root@web01 ~]# rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.12-1.el7.x86_64.rpm

2.修改所有的agent配置指向Server
[root@web01 ~]# sed -i '/^Server=/cServer=172.16.1.71' /etc/zabbix/zabbix_agentd.conf
[root@web01 ~]# sed -i '/^ServerActive=/cServerActive=172.16.1.71' /etc/zabbix/zabbix_agentd.conf 

[root@web01 ~]# sed -i '/^Hostname/c #hostname=zabbix server' /etc/zabbix/zabbix_agentd.conf

3.倒入所有的监控项和脚本
[root@zabbix ~]# cd /etc/zabbix
[root@zabbix ~]# rz  #上传zabbix_key.tar.gz
[root@zabbix ~]# for i in 5 7 8 9 31 41 51 52;do scp -rp scripts/ zabbix_agentd.d/ root@172.16.1.$i:/etc/zabbix/;done

4.登录zabbix-server倒入对应的模板
	
		配置->模板->倒入

5.使用api批量创建主机，添加模板（注意开启对应服务器的状态模块  nginx  php  ）


1.创建IP文件
[root@lb01 ~]# echo 172.16.1.{41,31,7,8,9,61,5,6,61,51,52}|xargs -n1 > /tmp/ip.txt

2.通过api批量创建
[root@zabbix ~]# cat create_zabbix.sh
#login
GetToken=$(curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0",
"method": "user.login",
"params": {
"user": "Admin",
"password": "zabbix"
},
"id": 1
}' http://10.0.0.71/zabbix/api_jsonrpc.php)

# result token
Token=$(echo $GetToken|awk -F ',' '{print $2}'|awk -F '"' '{print $4}')

while read line;do
curl -s -X POST -H 'Content-Type:application/json' -d '{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": '\"$line\"',
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": '\"$line\"',
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "2"
            }
        ],
        "templates": [
            {
                "templateid": "10001"
            }
        ]
    },
    "auth": '\"$Token\"',
    "id": 1
}' http://10.0.0.71/zabbix/api_jsonrpc.php|python -m json.tool
done < /tmp/ip.txt


3.关联对应的模板
4.配置对应的报警邮箱或微信
5.需要测试关闭服务是否能正常报警
```

## [  
](#p894bg)


