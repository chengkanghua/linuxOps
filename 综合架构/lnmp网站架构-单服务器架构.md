# lnmp网站架构-单服务器架构

# 1.LNMP架构概述

> LNMP就是Linux+Nginx+MySQL+PHP，Linux作为服务器的操作系统，Nginx作为Web服务器、PHP作为解析动态脚本语言、MySQL即为数据库。

Linux作为服务器的操作系统。 Nginx作为WebServer服务器。 PHP 作为动态解析服务(php)。 MySQL作为后端存储数据库服务。

> Nginx服务本身不能处理PHP的请求，那么当用户发起PHP动态请求, Nginx又是如何进行处理的。
>
> 用户-->http协议-->Nginx-->fastcgi协议-->php-fpm  注意: fatcgi是nginx连接php-fpm之间的协议。

1.安装LNMP架构

yum安装 nginx1.14  php7.1  mysql5.7

## 1.安装Nginx

```bash
#1.使用Nginx官方提供的rpm包   # $basearch获取不到值，改成arch命令的值x86_64
cat > /etc/yum.repos.d/nginx.repo<<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64/ 
gpgcheck=0
enabled=1
EOF

#2.执行yum安装 
yum install nginx -y
#3.启动并加入开机自启动
systemctl start nginx
systemctl enable nginx


#修改nginx运行身份
sed -i '/^user/c user www;' /etc/nginx/nginx.conf 
groupadd -g 666 www
useradd -u666 -g666 www -s /sbin/nologin
systemctl restart nginx
ps aux |grep nginx


```

## 2.使用第三方扩展epel源安装php7.1

```bash
#1.移除旧版php
yum remove php-mysql-5.4 php php-fpm php-common
#2.安装扩展源
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
#3.安装php7.1版本
yum -y install php71w php71w-cli php71w-common php71w-devel \ php71w-embedded php71w-gd php71w-mcrypt php71w-mbstring php71w-pdo php71w-xml php71w-fpm \ php71w-mysqlnd php71w-opcache php71w-pecl-memcached php71w-pecl-redis php71w-pecl-mongodb
自行解决依赖包安装
yum localinstall -y http://mirror.webtatic.com/yum/el7/webtatic-release.rpm 
yum localinstall -y http://mirror.webtatic.com/yum/el7/webtatic-release.rpm
#4.替换php-fpm运行的用户和组身份
sed -i '/^user/c user = www' /etc/php-fpm.d/www.conf
sed -i '/^group/c group = www' /etc/php-fpm.d/www.conf
#5.启动php-fpm管理进程, 并加入开机自启
systemctl start php-fpm
systemctl enable php-fpm

-------------------------------------------------------以上安装源失效了
# 移除旧版php
yum remove php-mysql-5.4 php php-fpm php-common

yum install -y epel-release
# CentOS 7
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
# CentOS 6
#yum install -y http://rpms.remirepo.net/enterprise/remi-release-6.rpm
yum -y install yum-utils


# 安装 PHP7.3：
yum install -y php73-php-fpm php73-php-cli php73-php-bcmath php73-php-gd php73-php-json php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pecl-crypto php73-php-pecl-mcrypt php73-php-pecl-geoip php73-php-recode php73-php-snmp php73-php-soap php73-php-xml



#替换php-fpm运行的用户和组身份
groupadd -g 666 www
useradd -u666 -g666 www -s /sbin/nologin
sed -i '/^user/c user = www' /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i '/^group/c group = www' /etc/opt/remi/php73/php-fpm.d/www.conf

rpm -qa | grep 'php'
rpm -ql php73-php-fpm

#查找php.ini位置
find /etc/opt/remi/php73 -name php.ini

#处理 CGI 模式下的路径解析问题
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/opt/remi/php73/php.ini

systemctl restart php73-php-fpm
systemctl enable php73-php-fpm
php73 -v

# 查看php73更多组件
yum search php73


php服务相关软件说明
php73w --> 主程序软件
php73w-gd --> 和显示图形相关的软件
php73w-mcrypt --> 和数据传输加密相关
php73w-pdo --> 让php和数据库建立联系
php73w-fpm --> fastcgi

重要的目录信息
/etc/php-fpm.conf        -->php-fpm进程的配置文件
/etc/php-fpm.d           -->php-fpm进程加载配置文件的目录
/etc/php-fpm.d/www.conf
user = nginx             -->利用指定用户管理php工作进程  建议配置和nginx服务相同的用户
group = nginx            -->利用指定用户组管理php工作进程
listen = 127.0.0.1:9000  -->指定php服务运行后，监听的地址和端口信息
listen.allowed_clients = 127.0.0.1  -->只允许本地访问php 9000端口服务
————————————————

# 配置一个php站点
#注意$ 改成 \$
cat > /etc/nginx/conf.d/oldboy_blog.conf<<EOF
server {
  listen 80;
  server_name blog.oldboy.com;
  location / {
    root /oldboy_code4;
    index index.php index.html;
    }
  location ~ \.php$ {
    root /oldboy_code4;
    fastcgi_index  index.php;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
    include        fastcgi_params;
    }
}
EOF

mkdir /oldboy_code4
cat > /oldboy_code4/index.php<<EOF
<?php
phpinfo();
?>
EOF

nginx -t
systemctl reload nginx
systemctl restart php73-php-fpm
systemctl enable php73-php-fpm



C:\Windows\System32\drivers\etc\hosts
10.0.0.3 blog.oldboy.com 
浏览器访问 blog.oldboy.com 
```

## 3. 安装 MySQL5.7 版本数据库

```bash
# 1.下载MySQL官方扩展源
rpm -ivh http://repo.mysql.com/mysql57-community-release-el7-11.noarch.rpm
#其他地址 
# http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm
# http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
# https://repo.mysql.com//mysql84-community-release-el7-1.noarch.rpm

#关闭gpg检查
#sed -i 's/gpgcheck=1/gpgcheck=0/' /etc/yum.conf
sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/mysql-community.repo
yum clean all
yum makecache

#2.安装mysql5.7, 文件过大可能会导致下载缓慢
yum install mysql-community-server -y
#3.启动数据库, 并加入开机自启动
systemctl start mysqld
systemctl enable mysqld
#4.由于mysql5.7默认配置了默认密码, 需要过滤temporary password关键字查看对应登陆数据库密码
grep 'temporary password' /var/log/mysqld.log
#5.登陆mysql数据库[password中填写上一步过滤的密码]
mysql -uroot -p$(awk '/temporary password/{print $NF}' /var/log/mysqld.log)
#6.重新修改数据库密码
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'Ckh123.com';

# 测试php是否能连接mysql数据库服务[无论是本地数据库还是远程数据库，测试方式一致 ]
# vi  /oldboy_code4/mysqli.php
<?php
$servername = "localhost";
$username = "root";
$password = "Ckh123.com";
// 创建连接
$conn = mysqli_connect($servername, $username, $password);
// 检测连接
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}
echo "连接成功";
?>

# 测试访问  # curl访问 指定解析域名 
curl -H "Host: blog.oldboy.com" http://localhost/mysqli.php

```

## 4.验证Nginx是否能正常解析php动态请求

```bash
# 配置一个php站点
#注意$ 改成 \$
cat > /etc/nginx/conf.d/oldboy_blog.conf<<EOF
server {
  listen 80;
  server_name blog.oldboy.com;
  location / {
    root /oldboy_code4;
    index index.php index.html;
    }
  location ~ \.php$ {
    root /oldboy_code4;
    fastcgi_index  index.php;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
    include        fastcgi_params;
    }
}
EOF

mkdir /oldboy_code4
cat > /oldboy_code4/index.php<<EOF
<?php
phpinfo();
?>
EOF

nginx -t
systemctl reload nginx
systemctl restart php73-php-fpm
systemctl enable php73-php-fpm

C:\Windows\System32\drivers\etc\hosts
10.0.0.3 blog.oldboy.com 
浏览器访问 blog.oldboy.com 
```

## 5.测试php是否能连接mysql数据库服务\[无论是本地数据库还是远程数据库，测试方式一致]

```bash
# 测试php是否能连接mysql数据库服务[无论是本地数据库还是远程数据库，测试方式一致 ]
# vi  /oldboy_code4/mysqli.php
<?php
$servername = "localhost";
$username = "root";
$password = "Ckh123.com";
// 创建连接
$conn = mysqli_connect($servername, $username, $password);
// 检测连接
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}
echo "连接成功";
?>

# 测试访问  # curl访问 指定解析域名 
curl -H "Host: blog.oldboy.com" http://localhost/mysqli.php
```

# lnmp架构用户访问流程

1.用户发起的所有请求会先抵达LNMP架构中的Nginx\
2.如果用户请求的是静态内容，则Nginx直接响应并处理。\
3.如果用户请求的是动态内容，则通过fastcgi协议发送至php-fpm管理进程\
4.php-fpm接收到请求后，会派生对应的warrap线程，来解析用户请求的动态内容。\
5.如果涉及到查询数据库操作，则需要php先连接数据库，然后进行查询操作。(php- mysql)\
6.最终由mysql-->php-fpm->fastcgi->nginx->user

# 部署博客系统Wordpress

```bash
#1.配置Nginx虚拟主机站点
cat > oldboy_blog.conf<<EOF
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
#1.获取wordpress代码
wget https://cn.wordpress.org/wordpress-4.9.4-zh_CN.tar.gz
#2.解压网站源码文件,拷贝至对应站点目录,并授权站点目录
tar zxvf wordpress-4.9.4-zh_CN.tar.gz -C /code/
chown -R www.www /code/wordpress/

#4.由于wordpress产品需要依赖数据库, 所以需要手动建立数据库
#1.登陆数据库
# mysql -uroot -pCkh123.com
#2.创建wordpress数据库
#MariaDB [(none)]> create database wordpress;
#MariaDB [(none)]> exit

# 一条命令创建数据库
# mysql -u [username] -p[password] -D [database_name] -e "SELECT * FROM [table_name];"
mysql -uroot -pCkh123.com -e "create database wordpress;"


5.通过浏览器访问wordpress, 并部署该产品  
http://blog.oldboy.com/wordpress

```

\_\_

\_\_

\_\_

\_\_

# 部署知乎系统Wecenter

1.配置`Nginx`虚拟主机站点，域名为`zh.bgx.com`

```bash
#1.nginx具体配置信息
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
#2.重启nginx服务
systemctl restart nginx

mkdir -p /code/zh ;cd /code

# 2.下载Wecenter产品，部署Wecenter并授权
# wget http://ahdx.down.chinaz.com/201605/WeCenter_v3.2.1.zip #链接地址失效了
# https://wecenter.isimpo.com/buy/index.htm
wget https://wecenter.isimpo.com/download/download.zip
unzip download.zip -d /code/zh
chown -R www.www /code/zh/

# 3.由于wecenter产品需要依赖数据库, 所以需要手动建立数据库
#1.登陆数据库
[root@http-server ~]# mysql -uroot -pCkh123.com
#2.创建wecenter数据库
MariaDB [(none)]> create database wecenter;
MariaDB [(none)]> exit

mysql -uroot -pCkh123.com -e "create database wecenter;"

nginx -s reload
3.通过浏览器访问网站
windows : C:\Windows\System32\drivers\etc\hosts
10.0.0.3 zh.oldboy.com/
浏览器访问 zh.oldboy.com/install/
```

\=

\#################################################################

```bash
1.用户通过http协议发起请求，请求会先抵达LNMP架构中的Nginx。
2.Nginx会根据用户的请求进行判断，这个判断是有Location进行完成(静态走本地 动态交给后端）。
3.判断用户请求的是静态页面，Nginx直接进行处理。
4.判断用户请求的是动态页面，Nginx会将该请求交给fastcgi协议下发
5.fastgi将请求交给php-fpm管理进程，php-fpm管理进程接收到后会生成具体的工作线程warrap
6.由warrap线程操作php进行解析。
7.如果有查询数据库操作，则由php连接数据库（用户密码 IP），然后发起查询的操作。

```

# 服务器mysql怎么配置才能远程连接

```bash
一、改表法。
a. bin/mysql -uroot -p密码
b. use mysql-----> show tables; ------> select host, user from user;
c. update user set host = '%' where user = 'root';
d. flush privileges;

二、授权法。
例如，你想myuser使用mypassword从任何主机连接到mysql服务器的话。
GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'%' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;

如果你想允许用户xiefei从ip为172.22.254.1的主机连接到mysql服务器，并使用123456作为密码 .
GRANT ALL PRIVILEGES ON *.* TO 'xiefei'@'172.22.254.1' IDENTIFIED BY '123456' WITH GRANT OPTION;

```

# FAQ

php源代码包下载地址

<https://mirrors.sohu.com/php/>


> 更新: 2026-05-05 18:19:38  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/rl6z2z>