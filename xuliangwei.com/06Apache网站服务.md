# 06 Apache网站服务

# 06 Apache网站服务

* [1.Apache基础概述](http://kt.xuliangwei.com/15212562802972.html#toc_0)
* [2.Apache安装配置](http://kt.xuliangwei.com/15212562802972.html#toc_1)
* [3.Apache基础配置](http://kt.xuliangwei.com/15212562802972.html#toc_2)
* [4.Apache虚拟主机](http://kt.xuliangwei.com/15212562802972.html#toc_3)
* [5.Apache动态网站](http://kt.xuliangwei.com/15212562802972.html#toc_4)
* [6.Apache访问控制](http://kt.xuliangwei.com/15212562802972.html#toc_5)
* [7.Apache安全服务](http://kt.xuliangwei.com/15212562802972.html#toc_6)
* [8.Apache反向代理](http://kt.xuliangwei.com/15212562802972.html#toc_7)
  * [8.1.Node节点部署](http://kt.xuliangwei.com/15212562802972.html#toc_8)
  * [8.2.反向代理部署](http://kt.xuliangwei.com/15212562802972.html#toc_9)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 1.Apache基础概述

**动态和静态资源**

> 静态元素： .html .img js css mp4
>
> 动态元素： .php .jsp .py

**常见Web Server服务**

Nginx、openresty、Tengine、Apache、IIS

**Web常见中间件**

> php: PHP-fpm、HHVM 
>
> py: wsgi
>
> jsp: Tomcat、JBOSS、Resin、Weblogic

**主流组合架构**

> LNMP (Linux + Nginx + MySQL + PHP) //php-fpm 进程 
>
> LAMP (Linux + Apache + MySQL + PHP) //php 作为 Apache 的模块 
>
> Nginx + Tomcat //取代 Apache 与 Tomcat 结合

[Apache官网](http://kt.xuliangwei.com/www.apache.org)

[Apache官方参考文档](http://httpd.apache.org/docs/2.4/)

```plain
软件包： 
    http  服务端口: 80/tcp(http) 
    https 服务端口: 443/tcp(https,http+ssl) 
配置文件:
/etc/httpd/conf/httpd.conf      //主配置文件
/etc/httpd/conf.d/*.conf        //包含配置文件
/etc/httpd/conf.d/welcome.conf  //默认测试页面
```

配置进程和线程

```plain
针对apache2.2仅针对面试
# prefork MPM //进程模式 
<IfModule prefork.c> StartServers 10 //初始建立的进程数 
MinSpareServers 10 //最小空闲的进程数
MaxSpareServers 15 //最大空闲的进程数
ServerLimit 2000 //最大启动的进程数 默认 256
MaxClients 2000 //最大并发连接数 默认 256
MaxRequestsPerChild 4000 //每个子进程在其生命周期内允许响应的最大请求数，0 不限制 
</IfModule>
# worker MPM //线程模式 
<IfModule worker.c> StartServers 2 //初始建立的进程数 
ThreadsPerChild 50 //每个进程建立的线程数
MinSpareThreads 100 //最小空闲的线程数
MaxSpareThreads 200 //最大空间的线程数
MaxClients 2000 //最大的并发访问量（线程）
MaxRequestsPerChild 0 //每个子进程在其生命周期内允许响应的最大请求数，0 不限制 
</IfModule>
```

## 2.Apache安装配置

1.环境准备

```plain
[root@xuliangwei ~]# yum update
[root@xuliangwei ~]# systemctl stop firewalld
[root@xuliangwei ~]# systemctl disable firewalld
[root@xuliangwei ~]# sed -ri '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config
[root@xuliangwei ~]# setenforce 0
```

2.安装`Apache`服务

```plain
[root@xuliangwei ~]# yum install -y httpd
[root@xuliangwei ~]# systemctl start httpd
[root@xuliangwei ~]# systemctl enable httpd
//如果必须启动防火墙的情况执行如下指令
[root@xuliangwei ~]# firewall-cmd --permanent --add-service=http
[root@xuliangwei ~]# firewall-cmd --reload
```

3.添加默认静态页面

```plain
//定义首页文件
[root@xuliangwei ~]# echo "Web is First" >> /var/www/html/index.html
//访问测试, 也可使用浏览器访问
[root@xuliangwei ~]# curl http://192.168.56.11
Web is First
```

## 3.Apache基础配置

查看Apache重要配置文件

```plain
IncludeOptional conf.d/*.conf
[root@xuliangwei ~]# grep '^[a-Z]' /etc/httpd/conf/httpd.conf
ServerRoot "/etc/httpd"         //安装目录
Listen 80                       //监听端口
Include conf.modules.d/*.conf   //包含模块目录配置文件
User apache                     //运行Apache进程的用户
Group apache                    //运行Apache进程的用户组
ServerAdmin root@localhost      //管理员邮箱
DocumentRoot "/var/www/html"    //站点目录
ErrorLog "logs/error_log"       //错误日志
LogLevel warn                   //日志级别
AddDefaultCharset UTF-8         //字符集
EnableSendfile on               //
IncludeOptional conf.d/*.conf   //包含conf.d目录下的所有conf结尾的文件
//类型模块
<IfModule mime_module>
    TypesConfig /etc/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>
//日志模块
ErrorLog "logs/error_log"
LogLevel warn
<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog "logs/access_log" combined
</IfModule>
//不允许用户直接访问/目录
<Directory />
    DirectoryIndex index.html
    AllowOverride none
    Require all denied
</Directory>
//允许所有用户访问/var/www
<Directory "/var/www">
    DirectoryIndex index.html
    AllowOverride None
    Require all granted
</Directory>
//拒绝任何人访问包含.ht文件
<Files ".ht*">
    Require all denied
</Files>
```

## 4.Apache虚拟主机

虚拟主机, 一个服务器上同时运行多个网站

```plain
//建立默认虚拟主机
# vim /etc/httpd/conf.d/00-default-vhost.conf
<VirtualHost _default_:80>
    DocumentRoot /srv/default/www/
    CustomLog "logs/default-vhost.log" combined
    <Directory /srv/default/www/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
//建立www0.example.com的虚拟主机
# vim /etc/httpd/conf.d/01-www0.example.com-vhost.conf
<VirtualHost *:80>
    Servername www0.example.com
        DocumentRoot /srv/www0.example.com/www/
        CustomLog "logs/www0.example.com-vhost.log" combined
        <Directory /srv/www0.example.com/www/>
                Options Indexes FollowSymLinks
                AllowOverride None
                Require all granted
        </Directory>
</VirtualHost>
```

## 5.Apache动态网站

1.如果需要解析动态`php`程序, 则需要安装`php`

```plain
//安装PHP
[root@xuliangwei ~]# yum install -y php
//php作为Apache的模块运行,并生成对应配置文件
[root@xuliangwei ~]# ll /etc/httpd/modules/libphp5.so
[root@xuliangwei ~]# ll /etc/httpd/conf.d/php.conf
//重启Apache加载php
[root@xuliangwei ~]# systemctl restart httpd
//编写php状态页面
[root@xuliangwei ~]# cat >> /var/www/html/info.php <<EOF
<?php
phpinfo();
?>
EOF
```

2.测试访问`php`状态页面

<!-- OCR_START -->
- phpinfo()
- 标杆徐
- 192.168.56.11/info.php
- 田☆
- 200
- phpbw
- 应用
- 运维
- 开发
- 学习
- 写作
- 阅读
- 教育
- 公有云
- 翻译
- Tmp
- 已导入
- PHPVersion5.4.16
- System
- Linux xuliangwei.com 3.10.0-693.el7.x86_64 #1 SMP Tue Aug 22 21:09:27 UTC
- 2017x86_64
- BuildDate
- Mar7201813:35:39
- Server API
- Apache 2.0 Handler
- Virtual Directory
- disabled
- Support
- Configuration File
- /etc
- (php.ini) Path
- Loaded Configuration
- /etc/php.ini
- File
- Scan this dir for
- /etc/php.d
- additional .ini fles
- Additional .ini files
- /etc/php.d/curl.ini, /etc/php.d/fileinfo.ini, /etc/php.d/json.ini
- parsed
- /etc/php.d/phar.ini, /etc/php.d/zip.ini
- PHP API
- 20100412
- PHP Extension
- 20100525
- Zend Extension
- 220100525
- Zend ExtensionBuild
- API220100525,NTS
- PHPExtensionBuild
- API20100525NTS
- Debug Build
- no
- Thread Safety
<!-- OCR_END -->

3.安装`MariaDB`数据库

```plain
//安装MariaDB数据库, 启动并加入开机自启动
[root@xuliangwei ~]# yum install mariadb mariadb-server -y
[root@xuliangwei ~]# systemctl enable mariadb
[root@xuliangwei ~]# systemctl start mariadb
//简单配置mariadb数据库
[root@xuliangwei ~]# mysql_secure_installation
//输入y, 然后设定root密码
Set root password? [Y/n]y
New password: 123 
Re-enter new password: 123
....后面暂时一路回车即可...
//登陆MariaDB验证密码 
[root@apache ~]# mysql -uroot -p123 
MariaDB [(none)]> exit
Bye
//编辑php连接数据库文件
[root@xuliangwei ~]# cat > /var/www/html/sql.php <<-EOF
<?php \$link=mysql_connect('localhost','root','123');
if(\$link)
    echo "Successfuly";
else
    echo "Faile";mysql_close();
?>
EOF
```

> 注意: 打开页面如果出现空白, 说明php无法连接MariaDB, 请按如下步骤操作:

```plain
//安装php连接mariadb数据库模块
[root@xuliangwei ~]# yum install php-mysql -y
//检查是否有对应数据库模块
[root@xuliangwei ~]# php -m |grep mysql
mysql
mysqli
pdo_mysql
//重启apache服务加载
[root@xuliangwei ~]# systemctl restart httpd
```

7.验证`php`与`mariaDB`连接

<!-- OCR_START -->
- 192.168.56.11/sql.php
- 标杆徐
- 田☆
- 200
- 应用
- 口运维
- 开发学习写作
- 阅读教育
- 公有云翻译Tmp已导入
- Successfuly
<!-- OCR_END -->

8.如果觉得PHP版本过低, 可进行升级`PHP`版本

```plain
//检查当前安装的PHP, 并移动旧版
[root@http-server ~]# rpm -e $(yum list installed | grep php)
//安装epel-扩展源, 安装php7
[root@http-server ~]# yum install epel-release
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
[root@http-server ~]# yum install -y php72-php php72-php-gd php72-php-mysqlnd \
php72-php-pecl-mysql php72-php-pecl-mysql-xdevapi php72-php-opcache \
php72-php-pecl-memcache php72-php-pecl-memcached php72-php-pecl-redis
```

<!-- OCR_START -->
phpinfo()
标杆徐
192.168.56.11/info.php
200phpbw
应用运维开发学习写作阅读教育口公有云翻译Tmp已导入
GGoogle
Ygoogle
PHP Version 7.2.4
ohp7
System
Linux http-server 3.10.0-693.el7.x86_64#1SMP Thu Jul 619:56:57 EDT 2017x86_64
Build Date
Mar27201816:17:18
ServerAPI
Apache 2.0 Handler
Virtual Directory Support
disabled
Configuration File(php.ini)Path
/etc/opt/remi/php72
LoadedConfigurationFile
/etc/opt/remi/php72/php.ini
Scan this dir for additional.ini files
/etc/opt/remi/php72/php.d
Additional.inifilesparsed
/etc/opt/remi/php72/php.d/10-opcache.ini,/etc/opt/remi/php72/php.d/20-bz2.ini,
/etc/opt/remi/php72/php.d/20-calendar.ini,/etc/opt/remi/php72/php.d/20-ctype.ini,
/etc/opt/remi/php72/php.d/20-curl.ini,/etc/opt/remi/php72/php.d/20-exif.ini,
/etc/opt/remi/php72/php.d/20-fileinfo.ini,/etc/opt/remi/php72/php.d/20-ftp.ini,
/etc/opt/remi/php72/php.d/20-gd.ini,/etc/opt/remi/php72/php.d/20-gettext.ini,
/etc/opt/remi/php72/php.d/20-iconv.ini,/etc/opt/remi/php72/php.d/20-json.ini,
/etc/opt/remi/php72/php.d/20-mysqlnd.ini,/etc/opt/remi/php72/php.d/20-pdo.ini,
/etc/opt/remi/php72/php.d/20-phar.ini,/etc/opt/remi/php72/php.d/20-sockets.ini,
/etc/opt/remi/php72/php.d/20-sqlite3.ini,/etc/opt/remi/php72/php.d/20-tokenizer.ini,
/etc/opt/remi/php72/php.d/30-mysqli.ini,/etc/opt/remi/php72/php.d/30-pdo_mysql.ini,
/etc/opt/remi/php72/php.d/30-pdo_sqlite.ini,/etc/opt/remi/php72/php.d/40-igbinary.ini,
/etc/opt/remi/php72/php.d/40-memcache.ini,/etc/opt/remi/php72/php.d/40-msgpack.ini,
/etc/opt/remi/php72/php.d/40-mysql_xdevapi.ini,/etc/opt/remi/php72/php.d/50-memcached.ini,
/etc/opt/remi/php72/php.d/50-mysql.ini,/etc/opt/remi/php72/php.d/50-redis.ini
PHPAPI
20170718
<!-- OCR_END -->

## 6.Apache访问控制

目录访问控制, 基于IP或者主机访问控制(仅限`httpd2.4`版本可用)

```plain
//匹配本机
Require local
//匹配所有的访问请求,并且授权访问
Require all granted
//匹配所有的访问请求,并且拒绝访问
Require all denied
//匹配指定IP的客户端访问
Require ip 192.168.56.11
//匹配某个IP网段
Require ip 192.168.56.0/255.255.0.0
Require ip 192.168.56.0/24
//不匹配该IP的请求
Require not ip 192.168.56.11
//匹配主机名的客户端访问
Require  host desktop0.example.com
//匹配某个域或主机名
Require  host example.com moreidiots.example
    example.com
    server0.example.com 
    node.example.com
    *.example.com
//不匹配所有以.gov结尾域
Require not host gov
//注意: not不能单独只用,必须使用在RequireAll, RequireAny,RequireNone容器标签里, 如下
<RequireAll>
    Require all granted
    Require not ip 192.168.56.11
</RequireAll>
```

> 1.实践环境准备

```plain
[root@http-server ~]# mkdir /var/www/html/download/
[root@http-server ~]# echo "web Server Apache" > /var/www/html/download/index.html
[root@http-server ~]# echo "htaccess" > /var/www/html/download/.htaccess
```

> 案例1: 允许所有主机访问

```plain
<VirtualHost *:80>
        ServerName test.bgx.com
        DocumentRoot "/var/www/html/download"
</VirtualHost>
<Directory "/var/www/html/download">
        AllowOverride None
        Require all granted
</Directory>
//AllowOverride All允许子目中的.htaccess 中的设置覆盖当前设置 
//AllowOverride None 不允许子目中的.htaccess 中的设置覆盖当前设置
```

> 案例2: 只允许网段`192.168.56|69.0/24`访问

```plain
<VirtualHost *:80>
        ServerName test.bgx.com
        DocumentRoot "/var/www/html/download"
</VirtualHost>
<Directory "/var/www/html/download">
        AllowOverride None
        Require ip 192.168.69.0/24
        Require ip 192.168.56.0/24
</Directory>
```

> 案例3: 所有请求都允许,只拒绝某些主机访问

```plain
<VirtualHost *:80>
        ServerName test.bgx.com
        DocumentRoot "/var/www/html/download"
</VirtualHost>
<Directory "/var/www/html/download">
        AllowOverride None
        //用于封装一组规则的授权，其中必须没有失败的授权
        //至少必须有一个规则成功才允许访问
        <RequireAll>
                Require all granted
                Require not host desktop0.example.com
                #Require not ip 192.168.56.0/24
        </RequireAll>
</Directory>
限制原理: 
1.要求<RequireAll>里的规则都完全匹配并且授权访问才能访问
2.desktop0.example.com满足第一条规则
3.desktop0.example.com不满足第二条规则随意不能访问
```

> 案例4: 拒绝所有人访问, 但允许个别主机可以访问

```plain
<VirtualHost *:80>
        ServerName test.bgx.com
        DocumentRoot "/var/www/html/download"
</VirtualHost>
<Directory "/var/www/html/download">
        AllowOverride None
                Require ip 192.168.160.161
                Require all denied
</Directory>
```

> 案例5: 特别的规则组合

```plain
//最终的结果居然是只能是本机访问
//<RequireAll> 要求所有规则都必须通过,不能有一个失败
<VirtualHost *:80>
        ServerName test.bgx.com
        DocumentRoot "/var/www/html/download"
</VirtualHost>
<Directory "/var/www/html/download">
        AllowOverride None
        //用于封装一组规则的授权，其中必须没有失败的授权
        //至少必须有一个规则成功才允许访问
        <RequireAll>
            Require all granted
            Require local
        </RequireAll>
</Directory>
//只有desktop0.example.com能访问. 
//其他机器都不能匹配到Require host desktop0.example.com
<VirtualHost *:80>
        ServerName test.bgx.com
        DocumentRoot "/var/www/html/download"
</VirtualHost>
<Directory "/var/www/html/download">
        AllowOverride None
        //用于封装一组规则的授权，其中必须没有失败的授权
        //至少必须有一个规则成功才允许访问
        <RequireAll>
                Require all granted
                Require host desktop0.example.com
        </RequireAll>
</Directory>
```

文件访问控制

```plain
//不允许在/var/www/edusoho/web/upload 目录中执行.php 文件 
<Directory /webroot/baidu/upload>
AllowOverride None 
Require all granted
<Files ~ " \.php$" > 
    Order allow,deny 
    Deny from all 
</Files> 
</Directory>
```

用户访问控制, 访问站点需要用户与密码[httpd官方参考文档](http://httpd.apache.org/docs/2.4/mod/mod_auth_basic.html)

```plain
//1.安装加密工具
[root@http-server ~]# yum install -y httpd-tools
//2.建立密码文件
[root@http-server ~]# htpasswd -c -b /etc/httpd/webpass bgx 123
//如果需要新增用户, 可使用如下方式
[root@http-server ~]# htpasswd -b /etc/httpd/webpass bgx1 123
//配置httpd支持认证
<VirtualHost *:80>
    ServerName test.bgx.com
    DocumentRoot "/var/www/html/download"
</VirtualHost>
<Directory "/var/www/html/download">
    AuthType "Basic"
    AuthName "Hai I's To Bgx"
    AuthBasicProvider file
    AuthUserFile "/etc/httpd/webpass"
    Require valid-user
</Directory>
```

## 7.Apache安全服务

使用虚拟主机技术部署两个网站, 按要求配置`HTTPS`网站

* 网站1：
  * 绑定域名 www0.example.com
  * 目录在 /srv/www0/www
  * 要求支持https加密访问
  * 所有通过http访问该网站都会自动调转到https
* 网站2：
  * 绑定域名 webapp0.example.com
    * 目录在 /srv/webapp0/www
    * 要求支持https加密访问
    * 所有通过http访问该网站都会自动调转到https

1.安装`httpd mod_ssl`实现 `http和https`服务

```plain
[root@http-server ~]# yum install httpd mod_ssl -y
[root@http-server ~]# systemctl enable httpd
[root@http-server ~]# systemctl start httpd
```

2.建立https网站需要的相关证书和密钥文件

```plain
http://classroom.example.com/pub/example-ca.crt     #根证书
http://classroom.example.com/pub/tls/certs/www0.crt # www0网站的证书
http://classroom.example.com/pub/tls/private/www0.key   # www0网站的私钥
        
http://classroom.example.com/pub/tls/certs/webapp0.crt      # webapp0网站的证书
http://classroom.example.com/pub/tls/private/webapp0.key    # webapp0网站的私钥
```

3.建立相关目录文件

```plain
[root@http-server ~]# mkdir  -p /srv/{www0,webapp0}/www
[root@http-server ~]# echo "www0"  > /srv/www0/www/index.html
[root@http-server ~]# echo "webapp0"  > /srv/webapp0/www/index.html
[root@http-server ~]# chown apache:apache -R /srv/*
```

4.建立对应两台虚拟主机

```plain
# vim /etc/httpd/conf.d/www0.conf
<VirtualHost *:443>
DocumentRoot "/srv/www0/www"
ServerName www0.example.com
SSLEngine on
SSLProtocol all -SSLv2
SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
SSLCertificateFile /etc/pki/tls/certs/www0.crt
SSLCertificateKeyFile /etc/pki/tls/private/www0.key
    <Directory /srv/www0/www>
        Require all granted
    </Directory>
</VirtualHost>                                  
<VirtualHost  *:80>
    Servername www0.example.com
    RewriteEngine  On
    RewriteRule ^(/.*)$  https://%{HTTP_HOST}$1 [redirect=301]
</VirtualHost>
//第二台虚拟主机
[root@http-server ~]# cp /etc/httpd/conf.d/{www0,webapp0}.conf
[root@http-server ~]# sed -i 's/www0/webapp0/g' /etc/httpd/conf.d/webapp0.conf
```

## 8.Apache反向代理

反向代理（Reverse Proxy）方式是指以代理服务器来接受internet上的连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给internet上请求连接的客户端，此时代理服务器对外就表现为一个反向代理服务器。

环境准备:

| 主机名 | IP地址 | 角色 | 系统 |
| :---: | :---: | :---: | :---: |
| web-node1.com | eth0:192.168.90.201 | web-node1节点 | CentOS7.2 |
| web-node2.com | eth0:192.168.90.202 | web-node2节点 | CentOS7.2 |
| lb-node1.com | eth0:192.168.90.203 | Apache反向代理 | CentOS7.2 |

### 8.1.Node节点部署

在两台web-node节点中均使用Yum安装一个Apache用于做真实机，监听8080端口

web-node1.com部署

```plain
[root@web-node1 ~]# rpm -ivh \
http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
[root@web-node1 ~]# yum install -y gcc glibc gcc-c++ make screen tree lrzsz
##部署web-node1 httpd服务
[root@web-node1 ~]# yum install -y httpd
[root@web-node1 ~]# sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
[root@web-node1 ~]# systemctl start httpd
[root@web-node1 ~]# echo "web-node1.com" > /var/www/html/index.html
[root@web-node1 ~]# curl  http://192.168.90.201:8080/
web-node1.com
```

web-node2.com部署

```plain
[root@web-node1 ~]# rpm -ivh \
http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
[root@web-node1 ~]# yum install -y gcc glibc gcc-c++ make screen tree lrzsz
##部署web-node2 httpd服务
[root@web-node2 ~]# yum install -y httpd
[root@web-node2 ~]# sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
[root@web-node2 ~]# systemctl start httpd
[root@web-node2 ~]# echo "web-node2.com" > /var/www/html/index.html
[root@web-node2 ~]# curl  http://192.168.90.202:8080/
web-node2.com
```

### 8.2.反向代理部署

1.`Apache`源码编译安装，并监听80端口

```plain
[root@lb-node1 ~]# yum install -y apr-devel apr-util-devel pcre-devel openssl-devel
[root@lb-node1 ~]# cd /usr/local/src
[root@lb-node1 src]# wget http://www-eu.apache.org/dist/httpd/httpd-2.4.23.tar.gz
[root@lb-node1 src]# tar xf httpd-2.4.23.tar.gz
[root@lb-node1 src]# cd httpd-2.4.23
[root@lb-node1 httpd-2.4.23]# ./configure --prefix=/usr/local/httpd-2.4.23 --enable-so --enable-modules="all"
[root@lb-node1 httpd-2.4.23]# make && make install
[root@lb-node1 httpd-2.4.23]# ln -s /usr/local/httpd-2.4.23/ /usr/local/httpd
## 测试配置并启动Apache
[root@lb-node1 ~]# sed -i 's@#ServerName www.example.com:80@ServerName 192.168.90.203:80@g' /usr/local/httpd/conf/httpd.conf
[root@lb-node1 ~]# /usr/local/httpd/bin/apachectl -t
Syntax OK
[root@lb-node1 ~]# /usr/local/httpd/bin/apachectl -k start
```

2.在`/usr/local/httpd/conf/httpd.conf`配置引用`proxy`配置文件

```plain
Include conf/extra/httpd-proxy.conf
```

3.配置`proxy`反向代理

```plain
[root@linux-node1 ~]# cat /usr/local/httpd/conf/extra/httpd-proxy.conf
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_connect_module modules/mod_proxy_connect.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so
LoadModule lbmethod_bytraffic_module modules/mod_lbmethod_bytraffic.so
LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so
LoadModule slotmem_shm_module modules/mod_slotmem_shm.so
ProxyRequests Off
<Proxy balancer://web-cluster>
BalancerMember http://192.168.90.201:8080 loadfactor=1
BalancerMember http://192.168.90.202:8080 loadfactor=2
</Proxy>
ProxyPass /biaoganxu balancer://web-cluster
ProxyPassReverse /biaoganxu balancer://web-cluster
<Location /manager>
    SetHandler balancer-manager
    Order Deny,Allow
    Allow from all
</Location>
```

4.重载`Apache`服务

```plain
[root@lb-node1 ~]# /usr/local/httpd/bin/apachectl -k graceful
```

5.测试反向代理

```plain
[root@lb-node1 ~]# curl http://192.168.90.203/biaogan/
web-node1.com
[root@lb-node1 ~]# curl http://192.168.90.203/biaogan/
web-node2.com
[root@lb-node1 ~]# curl http://192.168.90.203/biaogan/
web-node2.com
[root@lb-node1 ~]# curl http://192.168.90.203/biaogan/
web-node1.com
```

6.使用`HTTP`访问`Apache`管理页面

访问`http://192.168.90.203/manager`

<!-- OCR_START -->
| LoadBalancerManagerfor192.168.90.203 | LoadBalancerManagerfor192.168.90.203 | LoadBalancerManagerfor192.168.90.203 | LoadBalancerManagerfor192.168.90.203 | LoadBalancerManagerfor192.168.90.203 | 排名 |
| --- | --- | --- | --- | --- | --- |
| ServerBuilt:Oct19201610:51:50 | BalancerchangeswillNOTbepersistedonrestart. | Balancersareinheritedfrommainserver. | ProxyPasssettingsareinheritedfrommainserver. | LoadBalancerStatusforbalancer://web-cluster[pf4a1995f_web_cluster] | MaxMembersStickySessionDisableFailoverTimeoutFailoverAttemptsMethod |
| Path | Active | 2[2Used] | (None) | Off | 1 |
| byrequests/biaogan | Yes | WorkerURL | RouteRouteRedirFactorSetStatus ElectedBusy Load ToFrom | http://192.168.90.201:8080 | 1 |
<!-- OCR_END -->

Apache管理页面

7.`APache proxy`代理配置文件详解

```plain
#proxy模块
LoadModule proxy_module modules/mod_proxy.so
#链接模块
LoadModule proxy_connect_module modules/mod_proxy_connect.so  
#http代理模块
LoadModule proxy_http_module modules/mod_proxy_http.so 
#负载均衡模块
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so 
#算法默认是byrequest,可以是bytraffic或者bybusyness
#算法模块，根据server的请求量
LoadModule lbmethod_byrequests_module  modules/mod_lbmethod_byrequests.so 
#算法模块，根据server流量
LoadModule lbmethod_bytraffic_module modules/mod_lbmethod_bytraffic.so 
#算法模块，根据server繁忙
LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so  
LoadModule slotmem_shm_module modules/mod_slotmem_shm.so
ProxyRequests Off
#LB集群组名称
<Proxy balancer://web-cluster> 
#node节点并设置权重(可很多)
BalancerMember http://192.168.90.201:8080 loadfactor=1
BalancerMember http://192.168.90.202:8080 loadfactor=2
</Proxy>
#跳转至LB集群组名称,交由后端WEB节点处理
ProxyPass /biaogan balancer://web-cluster  
ProxyPassReverse /biaogan balancer://web-cluster  
# Apache管理页面
<Location /manager>
    SetHandler balancer-manager
    Order Deny,Allow
    Allow from all
</Location>
```

> 更新: 2019-03-20 20:01:08  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/gp0h8x>