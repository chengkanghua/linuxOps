# LNMP 网站架构 · 单服务器架构

## 一、LNMP 架构概述

> **LNMP = Linux + Nginx + MySQL + PHP**
> - Linux：服务器操作系统
> - Nginx：Web 服务器（处理静态、反向代理）
> - PHP：动态脚本解析语言
> - MySQL：后端数据库

**关键点**：Nginx 本身不能处理 PHP 请求。当用户发起 PHP 动态请求时，流程是：

```
用户 → HTTP → Nginx → FastCGI 协议 → php-fpm → PHP 解析
```

> FastCGI 是 Nginx 与 php-fpm 之间的通信协议。

---

## 二、安装 LNMP（Nginx 1.14 / PHP 7.1~7.3 / MySQL 5.7）

### 1. 安装 Nginx
```bash
# 使用 Nginx 官方 rpm 源
cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF

yum install nginx -y
systemctl start nginx
systemctl enable nginx

# 修改 Nginx 运行身份为 www（与 PHP 保持一致，避免权限问题）
groupadd -g 666 www
useradd -u666 -g666 www -s /sbin/nologin
sed -i '/^user/c user www;' /etc/nginx/nginx.conf
systemctl restart nginx
ps aux | grep nginx
```

### 2. 安装 PHP（第三方源）
> 旧方式（epel + webtatic）已失效，下面给出可用的 **Remi 源 PHP 7.3** 安装方式。

```bash
# 方式 A（已失效，仅作记录）：epel + webtatic 装 php71w
# yum remove php-mysql-5.4 php php-fpm php-common
# rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
# yum -y install php71w php71w-cli php71w-common php71w-devel php71w-embedded \
#   php71w-gd php71w-mcrypt php71w-mbstring php71w-pdo php71w-xml php71w-fpm \
#   php71w-mysqlnd php71w-opcache php71w-pecl-memcached php71w-pecl-redis php71w-pecl-mongodb

# 方式 B（推荐，可用）：Remi 源装 php73
yum remove php-mysql-5.4 php php-fpm php-common -y
yum install -y epel-release
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils

yum install -y php73-php-fpm php73-php-cli php73-php-bcmath php73-php-gd \
  php73-php-json php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd \
  php73-php-opcache php73-php-pdo php73-php-pecl-crypto php73-php-pecl-mcrypt \
  php73-php-pecl-geoip php73-php-recode php73-php-snmp php73-php-soap php73-php-xml

# 创建 www 用户并修改 php-fpm 运行身份
groupadd -g 666 www
useradd -u666 -g666 www -s /sbin/nologin
sed -i '/^user/c user = www' /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i '/^group/c group = www' /etc/opt/remi/php73/php-fpm.d/www.conf

# 处理 CGI 路径解析问题
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/opt/remi/php73/php.ini

systemctl restart php73-php-fpm
systemctl enable php73-php-fpm
php73 -v
yum search php73   # 查看更多组件
```

**PHP 常用组件说明**
| 软件包 | 作用 |
| --- | --- |
| php73w（主程序） | PHP 解释器 |
| php73w-gd | 图形处理 |
| php73w-mcrypt | 数据加密传输 |
| php73w-pdo | PHP 连接数据库 |
| php73w-fpm | FastCGI 进程管理器 |

**重要目录**
| 路径 | 说明 |
| --- | --- |
| `/etc/php-fpm.conf` | php-fpm 主配置 |
| `/etc/php-fpm.d/www.conf` | 进程池配置 |
| `user/group = nginx` | 建议与 Nginx 运行用户一致 |
| `listen = 127.0.0.1:9000` | php-fpm 监听地址端口 |
| `listen.allowed_clients = 127.0.0.1` | 只允许本机访问 9000 |

### 3. 安装 MySQL 5.7
```bash
# 下载官方扩展源
rpm -ivh http://repo.mysql.com/mysql57-community-release-el7-11.noarch.rpm
# 其他地址：
# http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm
# http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
# https://repo.mysql.com//mysql84-community-release-el7-1.noarch.rpm

sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/mysql-community.repo
yum clean all && yum makecache
yum install mysql-community-server -y

systemctl start mysqld
systemctl enable mysqld

# 5.7 默认生成临时密码
grep 'temporary password' /var/log/mysqld.log
mysql -uroot -p$(awk '/temporary password/{print $NF}' /var/log/mysqld.log)

# 修改密码
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'Ckh123.com';
```

---

## 三、配置 PHP 站点并验证

> 下面的 Nginx + PHP 配置在「验证解析」「连接数据库」等环节会反复用到，统一给出一份标准配置。

```bash
cat > /etc/nginx/conf.d/oldboy_blog.conf <<EOF
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
cat > /oldboy_code4/index.php <<EOF
<?php
phpinfo();
?>
EOF

nginx -t
systemctl reload nginx
systemctl restart php73-php-fpm
systemctl enable php73-php-fpm

# Windows hosts：10.0.0.3 blog.oldboy.com  → 浏览器访问 blog.oldboy.com
```

### 验证 Nginx 能解析 PHP
访问 `blog.oldboy.com`，能看到 `phpinfo()` 页面即成功。

### 验证 PHP 能连 MySQL
```bash
cat > /oldboy_code4/mysqli.php <<EOF
<?php
\$servername = "localhost";
\$username = "root";
\$password = "Ckh123.com";
\$conn = mysqli_connect(\$servername, \$username, \$password);
if (!\$conn) {
  die("Connection failed: " . mysqli_connect_error());
}
echo "连接成功";
?>
EOF

# curl 指定域名访问（本地测试）
curl -H "Host: blog.oldboy.com" http://localhost/mysqli.php
```
> 无论本地还是远程数据库，测试方式一致（把 `localhost` 换成数据库 IP 即可）。

---

## 四、LNMP 用户访问流程

1. 用户请求先抵达 **Nginx**。
2. 请求**静态内容** → Nginx 直接响应处理。
3. 请求**动态内容** → Nginx 通过 FastCGI 协议发给 **php-fpm**。
4. php-fpm 收到请求，派生 worker 线程解析动态内容。
5. 涉及查库时，PHP 先连接 MySQL 查询（php-mysql）。
6. 数据沿 `MySQL → php-fpm → FastCGI → Nginx → 用户` 返回。

---

## 五、部署博客系统 WordPress

```bash
# 1. Nginx 虚拟主机
cat > /etc/nginx/conf.d/oldboy_blog.conf <<EOF
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

# 2. 下载并部署代码
wget https://cn.wordpress.org/wordpress-4.9.4-zh_CN.tar.gz
tar zxvf wordpress-4.9.4-zh_CN.tar.gz -C /code/
chown -R www.www /code/wordpress/

# 3. 创建数据库
mysql -uroot -pCkh123.com -e "create database wordpress;"

# 4. 浏览器访问 http://blog.oldboy.com/wordpress 按向导安装
```

---

## 六、部署知乎系统 Wecenter

```bash
cat > /etc/nginx/conf.d/zh.conf <<EOF
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
systemctl restart nginx

mkdir -p /code/zh && cd /code
# 下载 Wecenter（链接以官方为准）：https://wecenter.isimpo.com/download/download.zip
wget https://wecenter.isimpo.com/download/download.zip
unzip download.zip -d /code/zh
chown -R www.www /code/zh/

# 创建数据库
mysql -uroot -pCkh123.com -e "create database wecenter;"

nginx -s reload
# Windows hosts：10.0.0.3 zh.oldboy.com/  浏览器访问 http://zh.oldboy.com/install/
```

---

## 七、MySQL 如何允许远程连接

**方法一：改表法**
```sql
use mysql;
select host, user from user;
update user set host = '%' where user = 'root';
flush privileges;
```

**方法二：授权法（推荐）**
```sql
-- 允许 myuser 从任意主机连接
GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'%' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;

-- 只允许 xiefei 从 172.22.254.1 连接
GRANT ALL PRIVILEGES ON *.* TO 'xiefei'@'172.22.254.1' IDENTIFIED BY '123456' WITH GRANT OPTION;
```

---

## 八、FAQ

- PHP 源码包下载：<https://mirrors.sohu.com/php/>

---

## 九、常见面试题

1. **LNMP 中 Nginx 怎么处理 PHP 请求？**
   Nginx 不解析 PHP，通过 FastCGI 协议把 `.php` 请求转发给 php-fpm，由 PHP 解析后返回。

2. **FastCGI 和 CGI 有什么区别？**
   CGI 每来一个请求就启一个进程，性能差；FastCGI 是常驻进程，预先启动 worker 复用，性能高。php-fpm 就是 FastCGI 进程管理器。

3. **php-fpm 的 `listen` 一般配成什么？为什么？**
   通常 `127.0.0.1:9000`（本机）或 unix socket。配 TCP 便于和 Nginx 分离部署；`listen.allowed_clients` 限制只允许 Nginx 访问，防止外部直连。

4. **为什么 Nginx 和 php-fpm 的运行用户要保持一致？**
   二者通过文件交互（站点目录、session 等），用户不一致会导致权限拒绝（403/无法写文件）。

5. **MySQL 5.7 装完首次登录密码在哪？**
   `/var/log/mysqld.log` 中 `temporary password` 关键字处。

6. **让 MySQL 支持远程连接有哪两种方式？**
   改表法（update user 表的 host）和授权法（GRANT ... TO 'user'@'%'）。生产推荐授权法，且限定来源 IP，不要用 root@'%'。

---

> 更新：2026-05-05 18:19:38
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/rl6z2z>
