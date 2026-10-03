# 第三章·Nginx实现基础Web架构

## LNMP架构概述

| 什么是LNMP |
| :--- |

`LNMP`是一套技术的组合，L=Linux、N=Nginx、M~=MySQL、P~=PHP

***

| LNMP架构是如何工作的 |
| :--- |

*首先__Nginx__服务是不能处理动态请求，那么当用户发起动态请求时*\_, Nginx__又是如何进行处理的。\_

*当用户发起__http__请求，请求会被__Nginx__处理，如果是静态资源请求__Nginx__则直接返回，如果是动态请求__Nginx__则通过__fastcgi__协议转交给后端的__PHP__程序处理，具体如下图所示*

<!-- OCR_START -->
- http协议
- fastcgi协议
- 浏览器
- Nginx
- PHP
- 客户端
- 代理
- 服务端
<!-- OCR_END -->

***

| Nginx与Fast-CGO详细工作流程 |
| :--- |

<!-- OCR_START -->
- php
- Server
- Client
- fastcgi
- php-fpm
- wrapper
- MySQL
- ginx
- FastCG
- Access
- 解析器
- Database
- fastcgi_pass
- php-fpm.conf
- php.ini
<!-- OCR_END -->

1.用户通过`http`协议发起请求，请求会先抵达`LNMP`架构中的`Nginx`

2.`Nginx`会根据用户的请求进行判断，这个判断是有`Location`进行完成

3.判断用户请求的是静态页面，`Nginx`直接进行处理

4.判断用户请求的是动态页面，`Nginx`会将该请求交给`fastcgi`协议下发

5.`fastgi`会将请求交给`php-fpm`管理进程, `php-fpm`管理进程接收到后会调用具体的工作进程`warrap`

6.`warrap`进程会调用`php`程序进行解析,如果只是解析代码`php`直接返回

7.如果有查询数据库操作，则由`php`连接数据库(用户 密码 IP)发起查询的操作

8.最终数据由\*`mysql->php->php-fpm->fastcgi->nginx->http->user`

## LNMP架构环境部署

| 使用官方仓库安装Nginx |
| :--- |

```bash
[root@nginx ~]# cat /etc/yum.repos.d/nginx.repo 
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
 
#安装Nginx
[root@nginx ~]# yum install nginx -y
```

***

| 修改nginx用户 |
| :--- |

```bash
[root@nginx ~]# groupadd www -g 666
[root@nginx ~]# useradd www -u 666 -g 666 -s /sbin/nologin  -M
#修改nginx配置文件
[root@nginx ~]# sed -i '/^user/c user www;' /etc/nginx/nginx.conf
```

***

| 启动Nginx加入开机自启 |
| :--- |

```bash
[root@nginx ~]# systemctl start nginx
[root@nginx ~]# systemctl enable nginx
```

***

| 使用第三方扩展源安装php7.1 |
| :--- |

```bash
# rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
[root@nginx ~]# yum remove php-mysql-5.4 php php-fpm php-common
#配置第三方源
[root@nginx ~]# vim /etc/yum.repos.d/php.repo
[php-webtatic]
name = PHP Repository
baseurl = http://us-east.repo.webtatic.com/yum/el7/x86_64/
gpgcheck = 0
[root@nginx ~]# yum -y install php71w php71w-cli php71w-common php71w-devel php71w-embedded php71w-gd php71w-mcrypt php71w-mbstring php71w-pdo php71w-xml php71w-fpm php71w-mysqlnd php71w-opcache php71w-pecl-memcached php71w-pecl-redis php71w-pecl-mongodb
```

***

| 配置php-fpm用户与Nginx的运行用户保持一致 |
| :--- |

```bash
[root@nginx ~]# sed -i '/^user/c user = www' /etc/php-fpm.d/www.conf 
[root@nginx ~]# sed -i '/^group/c group = www' /etc/php-fpm.d/www.conf
```

***

| 启动php-fpm加入开机自启 |
| :--- |

```bash
[root@nginx ~]# systemctl start php-fpm
[root@nginx ~]# systemctl enable php-fpm
```

***

| 安装Mariadb数据库 |
| :--- |

```bash
[root@nginx ~]# yum install mariadb-server -y
```

***

| 启动Mariadb加入开机自动 |
| :--- |

```bash
[root@nginx ~]# systemctl start mariadb
[root@nginx ~]# systemctl enable mariadb
```

***

| 给Mariadb配置登陆密码 |
| :--- |

```bash
[root@nginx ~]# mysqladmin password 'Zls123.com'
[root@nginx ~]# mysql -uroot -pZls123.com
```

## LNMP架构环境配置

在将Nginx与PHP集成过程中,需要先了解Fastcgi代理配置语法

1.设置`fastcgi`服务器的地址，该地址可以指定为域名或IP地址，以及端口

```bash
Syntax: fastcgi_pass address;
Default: —
Context: location, if in location
 
#语法示例
fastcgi_pass localhost:9000;
fastcgi_pass unix:/tmp/fastcgi.socket;
```

2.设置`fastcgi`默认的首页文件，需要结合`fastcgi_param`一起设置

```bash
Syntax: fastcgi_index name;
Default: —
Context: http, server, location
```

3.通过`fastcgi_param`设置变量，并将设置的变量传递到后端的`fastcgi`服务器

```bash
Syntax: fastcgi_param parameter value [if_not_empty];
Default: —
Context: http, server, location
 
#语法示例
fastcgi_index index.php;
fastcgi_param SCRIPT_FILENAME /code$fastcgi_script_name;
```

4.通过图形方式展示`fastcgi_index`与`fastcgi_param`作用

<!-- OCR_START -->
Fastcgi代理配置
root/code;
fastcgi_indexindex.php;
fastcgi_paramSCRIPT_FILENAME$document_root$fastcgi_script_name
php解析的真实路径
SCRIPT_FILENAME=/codelindex.php
浏览器
Nginx
FastCGI
客户端
https://www.driveizeng.com
服务端
<!-- OCR_END -->

<!-- OCR_START -->
root/code;
fastcgi_index index.php;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
php解析的真实路径
SCRIPT_FILENAME=/code/page.php
https://driverzeng.com/page.php
浏览器
Nginx
FastCGI
客户端
https://www.dti/erzeng.com
服务端
<!-- OCR_END -->

5.最终Nginx连接Fastcgi服务器配置如下

```bash
[root@nginx ~]# cat /etc/nginx/conf.d/php.conf 
server {
        listen 80;
        server_name php.driverzeng.com;
        location / {
                root /code;
                index index.php index.html;
        }
        location ~ \.php$ {
                root /code;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name
        }
}
```

6.在/code目录下创建info.php文件，测试能否通过浏览器访问，访问成功如下图

```bash
[root@nginx ~]# cat /code/info.php
<?php
        phpinfo();
?>
```

<!-- OCR_START -->
①不安全|php.driverzeng.com/index.php
C
<!-- OCR_END -->

按照刚才的配置，页面打开一片空白。

```bash
[root@nginx ~]# cat /etc/nginx/conf.d/php.conf 
server {
        listen 80;
        server_name php.driverzeng.com;
        location / {
                root /code;
                index index.php index.html;
        }
        location ~ \.php$ {
                root /code;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }
}
```

<!-- OCR_START -->
phpinfo()
应用TTTS
zabbix-api
PHP Version 7.1.30
php
System
Linux web01 3.10.0-862.el7.x86_64 #1 SMP Fri Apr 20 16:44:24 UTC 2018 x86_64
Build Date
Jun 2 2019 08:07:10
ServerAPI
FPM/FastCGI
Virtual Directory Support
disabled
Confguration File(php.ini) Path
/etc
Loaded Confguration File
/etc/php.ini
Scan this dir for additional ini fles
/etc/php.d
Additionaliniflesparsd
/et/ph.d/bz2i//ph/aledari//pd/tii/t/ppd/culi/t/.d/dm,
/et/ph/ifi//pd/loi///tii///gdi//ph/gexti,
/etc/php.d/gmp.ini,/etc/php.d/iconv.ini/etc/php.d/igbinary.ini,/etc/php.d/json.ini,
/etc/php.d/mbstring.ini,/etc/php.d/mcrypt.ini,/etc/php.d/mongodb.ini,/etc/php.d/mysqlnd.ini,
/etc/php.d/mysqlnd_mysqli.ini,/etc/php.d/opcache.ini,/etc/php.d/pdo.ini,/etc/php.d/pdo_mysqlnd.ini
/etc/php.d/shmop.ini,/etc/php.d/simplexml.ini,/etc/php.d/sockets.ini,/etc/php.d/sqlite3.ini,
/etc/php.d/xmli/t/ph.d/xm_wddxi/et/pp.d/xmlreader.i/t/php.d/xmlwriterini,
/etc/ph.d/xsi//hd/mmcachdi/t/ph.d/ipi
PHPAPI
20160303
PHP Extension
Zend Extension
320160303
Zend Extension Build
API320160303,NTS
PHP Extension Build
API20160303,NTS
Debug Build
no
Thread Safety
Zend Signal Handling
enabled
Zend Memory Manager
Zend Maultibyte Support
providedby mbstring
IPv6Support
DTrace Support
Registered PHP Streams
https,ftps,comp
Registered Stream Socket Transports
tp, udp, unix, udg, s, ss3,ts, tlsv., tls1.1, tlsv1.2
RegisteredStreamFilters
zlib.*,string.rot3,string.toupper, string.tol
convert.iconv.*,mcrypt.*,mdecrypt.*
Thisprogrammakes use of theZend Sd
https/swww.driverzeng.comendengine
Zend Enine3..0Copyright(c99
<!-- OCR_END -->

7.在`/code`目录下创建`mysqli.php`文件，填入对应的数据库**IP、用户名、密码**

```bash
[root@nginx ~]# cat /code/mysqli.php
<?php
    $servername = "localhost";
    $username = "root";
    $password = "Zls123.com";
    // 创建连接
    $conn = mysqli_connect($servername, $username, $password);
    // 检测连接
    if (!$conn) {
        die("Connection failed: " . mysqli_connect_error());
    }
    echo "小哥哥,php可以连接MySQL...";
?>
<img style='width:100%;height:100%;' src=https://www.driverzeng.com/zenglaoshi/php_mysql.png>
```

<!-- OCR_START -->
- phpinfo()
- php.driverzeng.com/mysqli.ph
- Statistic
- C①不安全| php.driverzeng.com/mysqli.php
- 应用TTSzabbix-api
- 小哥哥,php可以连接MySQL.
- 主要看上面的字
- 数据库连接成功了哟...
<!-- OCR_END -->

## 部署博客产WordPress

1\)配置`Nginx`虚拟主机站点，域名为`blog.driverzeng.com`

```bash
#1.nginx具体配置信息
[root@nginx ~]# cat /etc/nginx/conf.d/wordpress.conf
server {
    listen 80;
    server_name blog.driverzeng.com;
    root /code/wordpress;
    index index.php index.html;
 
    location ~ \.php$ {
        root /code/wordpress;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

2\)重启nginx服务

```bash
[root@nginx ~]# systemctl restart nginx
```

3\)获取`wordpress`产品，解压并部署`wordress`

```bash
[root@nginx ~]# mkdir /code
[root@nginx ~]# cd /code
[root@nginx code]# wget https://cn.wordpress.org/wordpress-5.0.3-zh_CN.tar.gz
#永远下载最新版
[root@nginx code]# wget https://cn.wordpress.org/latest-zh_CN.tar.gz
[root@nginx ~]# tar xf wordpress-5.0.3-zh_CN.tar.gz
[root@nginx ~]# chown -R www.www /code/wordpress/
```

4\)由于`wordpress`产品需要依赖数据库,所以需要手动建立数据库

```bash
[root@nginx ~]# mysql -uroot -pZls123.com
mysql> create database wordpress;
mysql> exit
```

5\)通过浏览器访问wordpress,并部署该产品

<!-- OCR_START -->
WordPress>调整配置文件
①不安全|php.driv
应用
zabbix-api
欢迎使用WordPress。在开始前，我们需要您数据库的一些信息。请准备好如下信息。
1.数据库名
2.数据库用户名
3.数据库密码
4.数据库主机
5.数据表前缀（table prefix，特别是当您要在一个数据库中安装多个WordPress时)
我们会使用这些信息来创建一个wp-config.php文件。如果自动创建未能成功，不用担心，您要做的只是将数
据库信息填入配置文件。您也可以在文本编辑器中打开wp-config-sample.php，填入您的信息，并将其另存
为wp-config.php。需要更多帮助？看这里。
绝大多数时候，您的网站服务提供商会给您这些信息。如果您没有这些信息，在继续之前您将需要联系他们。如果
您准备好了...
现在就开始！
<!-- OCR_END -->

<!-- OCR_START -->
- 调整配置文件
- A不安全
- php.drive
- 应用
- 请在下方填写您的数据库连接信息。如果您不确定，请联系您的服务提供商。
- 数据库名
- wordpress
- 希望将WordPress安装到的数据库名称。
- 用户名
- root
- 您的数据库用户名。
- 密码
- Zls123.com
- 您的数据库密码。
- 数据库主机
- 如果localhost不能用，您通常可以从网站
- localhost
- 服务提供商处得到正确的信息。
- 表前缀
- 如果您希望在同一个数据库安装多个
- wp_
- WordPress，请修改前缀。
- 提交
<!-- OCR_END -->

<!-- OCR_START -->
- php
- TTS
- 不错。您完成了安装过程中重要的一步，WordPress现在已经可以连接数据库了。如果您准备好了的话，现在就.
- 现在安装
<!-- OCR_END -->

<!-- OCR_START -->
- 应用
- T TTS zabbix-api
- 欢迎
- 欢迎使用著名的WordPress五分钟安装程序！请简单地填写下面的表格，来开始使用这个世界上最具扩展性、最
- 强大的个人信息发布平台。
- 需要信息
- 您需要填写一些基本信息。无需担心填错，这些信息以后可以再次修改。
- 站点标题
- 曾老湿博客
- 用户名
- admin
- 用户名只能含有字母、数字、空格、下划线、连字符、句号和"@"符号。
- 密码
- 123456
- 隐藏
- 非常弱
- 董要：
- 您将需要此密码来登录，请将其保存在安全的位置。
- 确认密码
- ?确认使用弱密码
- 您的电子邮件
- 123@qq.com
- 请仔细检查电子邮件地址后再继续。
- 对搜索引擎的可见性
- 建议搜索引擎不索引本站点
- 搜索引擎将本着自觉自愿的原则对待WordPress提出的请求。并不是所有搜索引擎都会遵守这类请
- 求。
- 安装WordPress
<!-- OCR_END -->

<!-- OCR_START -->
- WordPress
- 不安全
- 应用
- TTS
- 成功！
- WordPress安装完成。谢谢！
- 用户名
- admin
- 密码
- 您设定的密码。
- 登录
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全php.driverzeng.com
- 用户名或电子邮件地址
- admin
- 密码
- ······
- 记住我的登录信息
- 忘记密码？
- ←返回到曾老湿博客
<!-- OCR_END -->

<!-- OCR_START -->
- ①不安全| php.driverzeng.com/wp-
- 应用 T TTS zabbix-api
- 曾老湿博客70+新建
- 显示选项▼
- 帮助▼
- 仪表盘
- WordPress5.2.2现已可用！请现在更新。
- 首页
- 更新1
- 文章
- 欢迎使用WordPress！
- 不再显示
- 叮媒体
- 我们准备了几个链接供您开始：
- 页面
- 评论
- 开始使用
- 接下来
- 更多操作
- 撰写您的第一篇博文
- 管理边栏小工具和菜单
- 》外观
- 自定义您的站点
- 十添加"关于“页面
- 打开/关闭评论功能
- 插件
- 或更换主题
- 查看站点
- 了解更多新手上路知识
- 用户
- 工具
- 概览
- 快速草稿
- 设置
- 收起菜单
- 1篇文章
- 1个页面
- 标题
- 1条评论
- 在想些什么？
- WordPress5.0.3，使用二O一九主题。
- 更新到5.2.2
- 活动
- 保存草稿
- 最近发布
- 下午4:52今天
- 世界，您好！
- WordPress活动及新闻
- 近期评论
- 参加一场您附近的活动。
- 由一位WordPress评论者发表在《世界，您好！》
- 嗨，这是一条评论。要开始审核、编辑及删除评论，请
- 目前没有任何安排在您附近的活动。您想要组织一个吗？
- 访问仪表盘的“评论"页面。评论者头像来自Gravatar。
- 载入中..
- 全部（1）丨待审（0）丨已批准（1）垃圾（0）
- 回收站（0)
- 聚会Wor
- 新闻
<!-- OCR_END -->

<!-- OCR_START -->
- 不安全
- 应用
- 曾老湿博客
- 曾老湿博客一又一个WordPress站点
- 世界，您好！
- 欢迎使用WordPress。这是您的第一篇文章。编辑或删除它，然后开始写作吧！
- admin2019年8月11日未分类■有1条评论编辑
- 搜索..
- 近期文章
- 近期评论
- https://www.dn文e章归档om
<!-- OCR_END -->

***

**思考问题：上传文件报错413，如何解决？**

提示：nginx上传大小的限制

***

## 部署知乎产品Wecenter

1.配置`Nginx`虚拟主机站点，域名为`zh.driverzeng.com`

```bash
#1.nginx具体配置信息
[root@http-server ~]# cat /etc/nginx/conf.d/zh.conf
server {
    listen 80;
    server_name zh.driverzeng.com;
    root /code/zh;
    index index.php index.html;
 
        location ~ \.php$ {
        root /code/zh;
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_index  index.php;
                fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                include        fastcgi_params;
        }
}
 
 
#2.重启nginx服务
[root@http-server ~]# systemctl restart nginx
```

2.下载`Wecenter`产品，部署`Wecenter`并授权

官方下载地址：[TP](http://www.wecenter.com/downloads/)

```bash
[root@web02 ~]# wget http://ahdx.down.chinaz.com/201605/WeCenter_v3.2.1.zip
[root@web02 ~]# unzip WeCenter_3-2-1.zip
[root@web02 ~]# mv WeCenter_3-2-1/ /code/zh
[root@web02 ~]# chown -R www.www /code/zh/
```

3.由于`wecenter`产品需要依赖数据库, 所以需要手动建立数据库

```bash
#1.登陆数据库
[root@http-server ~]# mysql -uroot -pZls123.com
 
#2.创建wordpress数据库
MariaDB [(none)]> create database zh;
MariaDB [(none)]> exit
```

3.通过浏览器访问网站

<http://zh.driverzeng.com/install/>

<!-- OCR_START -->
- 历史记录
- 书签
- 用户
- 窗口
- DBA老司机带你删库到跑路.-A×
- WeCenter-Install
- 不安全|zh.driverzeng.com/install/
- 应用T TTSzabbix-api
- ·欢迎使用
- 欢迎使用 WeCenter安装程序,WeCenter 是中国首个基于PHP+MYSQL开发的开源化社交问答社区
- ·服务器环境检查
- 为了确保程序安装顺利，您的服务器需要满足以下系统需求的运行环境
- PHP版本
- 7.1.30
- 数据库模块
- PDO_MYSQL
- Session支持
- Cookie支持
- CType支持
- CURL 支持
- 图象处理库
- GD  J(加装 ImageMagick 性能更佳)
- FreeType 支持
- Zlib支持
<!-- OCR_END -->

<!-- OCR_START -->
- A不安全| zh.driverzeng.com/install/
- 应用
- TTTS
- zabbix
- ·配置系统
- 需要您提供必要的系统配置信息
- 数据库主机
- localhost
- 通常为localhost
- 数据库账号
- root
- 数据库密码
- Zis123.com
- 数据库端口
- 3306
- 一般情况下不需要填写
- 数据库名称
- zh
- 数据表前缀
- zls_
- 同数据库安装多个本程序时需要更改
- 数据表类型
- InnoDB
- 请根据服务器状态选择数据表类型
- 开始安装
- 遇到问题？联系我们|Copyright -WeCenter3.2.1,AlRights Rese
<!-- OCR_END -->

<!-- OCR_START -->
- ·添加管理员
- 数据库导入成功，创建管理员账户
- 用户名
- admir
- 密码
- 123@qq.com
- 完成
- 遇到问题？联系我们|Copyright-WeCer
<!-- OCR_END -->

<!-- OCR_START -->
- ·安装成功
- 欢迎使用WeCen
- 问答交流平台，为了增强安全性，请将installindex.php文件删除
- 访问网站首页
- 遇到问题？联系我们|Cop
<!-- OCR_END -->

<!-- OCR_START -->
- 机带你删库到跑路.-A
- ①不安全| zh.driverzeng.com
- 应用TTTS
- zabbix-api
- 搜索问题、话题或人
- 三发现
- 话题
- 登录
- 注册
- 默认分类
- 默认分类描述
- 热门话题
- 更多>
- 最新
- 推荐
- 热门
- 等待回复
- 热门用户
- 8
- admin
- 0个问题，0次赞同
- Copyright2019,AllRightsReservedPoweredByWeCenter3.2.
<!-- OCR_END -->

<!-- OCR_START -->
- 制库到跑路.-
- 动态-WeCente
- 不安全
- TRUE#al
- 应用
- zabbix-api
- 搜索问题、话题或人
- 发起
- Hi , admin
- 最新动态
- 欢迎来到 WeCenter
- 我的草稿
- 1.完善基本资料
- 2.关注热门话题
- 3.关注热门用户
- 我的收藏
- 我关注的问题
- 性别：男○女○保密
- 我关注的话题
- 介绍：
- 如：80后IT男.
- 我关注的专栏
- 邀请我回复的问题
- 上传头像
- 所有话题
- 跳过资料填写
- 下一步
- 所有用户
- 邀请好友加入10
<!-- OCR_END -->

<!-- OCR_START -->
- W为什么曾老湿长的那么帅?
- ① 不安全| zh.driverzeng.com/?/question/1
- 应用TTTS
- zabbix-api
- 搜索问题、话题或人
- 话题
- 通知
- 发起
- 动态
- 专栏
- 三发现
- ··
- 没有归属话题，请帮问题添加话题，点此添加话题
- 发起人
- 8
- admin
- 为什么曾老湿长的那么帅？
- 取消关注
- 1秒前添加评论邀请编辑相关链接
- 分享举报
- 邮件邀请别人回复
- 邮件邀请回复.
- 0个回复
- 问题状态
- 匿名回复
- 最新活动：1秒前
- 浏览：0
- 关注：1人
- 上传附件
- 回复
- Copyright2019,AllRightsReservedPowered ByWeCenter3.2.1
<!-- OCR_END -->

>  
>
> 当然除了这些产品，还有很多我们可以尝试着搭建的：
>
> phpmyadmin
>
> zblog
>
> discuz
>
> edusoho

## 拆分数据库至独立服务器

| 为什么要进行数据库的拆分 |
| :--- |

由于单台服务器运行`LNMP`架构会导致网站访问缓慢，当内存被占满时，很容易导致系统出现`oom`从而kill屌MySQL数据库，所以要将web和数据库进行独立部署。

***

| 数据库拆分后解决了什么问题 |
| :--- |

1.缓解web网站的压力

2.增强数据库读写性能

3.提高用户访问速度

***

| 数据库拆分架构演变过程，如下图所示 |
| :--- |

<!-- OCR_START -->
- 单机时代
- LNMP架构
- 客户端
- www.linuxgc.com
- eth0:10.0.0.7
- eth1:172.16.1.7
- 拆分数据库
- Nginx+PHP
- tcp连接查询数据库
- MySQL
- eth1:172.16.1.51
- https.//www.driverzeng.com
<!-- OCR_END -->

***

| 数据库拆分 |
| :--- |

| **主机名称** | **应用环境** | **外网地址** | **内网地址** |
| :--- | :--- | :--- | :--- |
| web01 | nginx+php | 10.0.0.7 | 172.16.1.7 |
| db01 | mysql | 10.0.0.51 | 172.16.1.51 |

***

| 数据库拆分 |
| :--- |

**1.web01网站服务器操作如下**

1\)备份web01上的数据库，Zls123.com是数据库密码

```bash
[root@web01 ~]# mysqldump -uroot -p'Zls123.com' -A > mysql-all.sql
```

2\)将web01上备份的数据库拷贝至db01服务器上

```bash
[root@web01 ~]# scp mysql-all.sql  root@172.16.1.51:/tmp
```

**2.db01数据库服务器操作如下**

1\)将web01服务器上推送的数据库备份文件恢复至db01服务器新数据库中

```bash
[root@db01 ~]# yum install mariadb mariadb-server -y
[root@db01 ~]# systemctl start mariadb
[root@db01 ~]# systemctl enable mariadb
[root@db01 ~]# mysql -uroot -p'Zls123.com' < /tmp/mysql-all.sql
```

2\)数据库导入完成后，重启数据库，使用新密码进行登录，并检查数据库已被导入成功

```bash
[root@db01 ~]# systemctl restart mariadb
[root@db01 ~]# mysql -uroot -pZls123.com
mysql> show databases;
```

3\)在新数据库上授权,允许所有网段,通过all账户连接并操作该数据库

```bash
#授权所有权限   grant all privileges
#授权所有库所有表 *.* 
#将授权赋予给哪个用户，这个用户只能通过哪个网段过来(%所有) 'all'@'%'
#授权该用户登录的密码 identified by
 
mysql> grant all on  *.* to zls@'%' identified by 'Zls123.com';
Query OK, 0 rows affected (0.00 sec)
 
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

**3.web01修改代码连接新数据库环境**

1\)修改`Wordpress`产品代码连接数据库的配置文件

```bash
[root@web01 ~]# vim /code/wordpress/wp-config.php
# 数据库名称
define('DB_NAME', 'wordpress');
# 数据库用户
define('DB_USER', 'zls');
# 数据库密码
define('DB_PASSWORD', 'Zls123.com');
# 数据库地址
define('DB_HOST', '172.16.1.51');
```

2\)修改`wecenter`产品代码连接数据库的配置文件

```bash
[root@web01 zh]#  grep -iR "Zls123.com"|grep -v cache
system/config/database.php:  'password' => 'Zls123.com',
[root@web01 zh]# vim /code/zh/system/config/database.php
'host' => '172.16.1.51',
'username' => 'zls',
'password' => 'Zls123.com',
'dbname' => 'zh',
```

3\)最后访问网站，成功打开，至此拆分数据库完成

## 扩展多台相同的Web服务器

| 为什么要扩展多台web节点 |
| :--- |

单台web服务器能抗住的访问量是有限的，配置多台web服务器能提升更高的访问速度。

***

| 扩展多台web解决了什么问题 |
| :--- |

*1.单台web节点如果故障，会导致业务down机*

*2.多台web节点能保证业务的持续稳定，扩展性高*

*3.多台web节点能有效的提升用户访问网站的速度*

*3.多台web节点技术架构组成，如下图所示*

<!-- OCR_START -->
- 单台web
- Nginx+PHP
- www.linuxgc.com
- tcp连接查询数据库
- MySQL
- 客户端
- eth0:10.0.0.7
- eth1:172.16.1.51
- eth1:172.16.1.7
- 扩展多台web
- eth0:10.0.0.8
- eth1:172.16.1.8
<!-- OCR_END -->

***

| 扩展web环境 |
| :--- |

| **主机名称** | **应用环境** | **外网地址** | **内网地址** |
| :--- | :--- | :--- | :--- |
| web01 | nginx+php | 10.0.0.7 | 172.16.1.7 |
| web02 | nginx+php | 10.0.0.8 | 172.16.1.8 |
| db01 | mysql | 10.0.0.51 | 172.16.1.51 |

***

| 快速扩展一台web节点详细步骤 |
| :--- |

通过web01现有环境快速的扩展一台web02的服务器，数据库统一使用db01

1\)创建www用户

```bash
[root@web02 ~]# groupadd -g666 www
[root@web02 ~]# useradd -u666 -g666 www
```

2\)安装LNP

```bash
[root@web02 ~]# scp -rp root@172.16.1.7:/etc/yum.repos.d/* /etc/yum.repos.d/
[root@web02 ~]# scp -rp root@172.16.1.7:/etc/pki/rpm-gpg/* /etc/pki/rpm-gpg/
 
[root@web02 ~]# yum install nginx -y
[root@web02 ~]# yum -y install php71w php71w-cli php71w-common php71w-devel php71w-embedded php71w-gd php71w-mcrypt php71w-mbstring php71w-pdo php71w-xml php71w-fpm php71w-mysqlnd php71w-opcache php71w-pecl-memcached php71w-pecl-redis php71w-pecl-mongodb
```

3\)将web01的nginx配置文件导入到web02

```bash
[root@web02 ~]# scp -rp root@172.16.1.7:/etc/nginx /etc/
```

4\)将web01的php配置文件导入到web02

```bash
[root@web02 ~]# scp -rp root@172.16.1.7:/etc/php-fpm.d /etc/
```

5\)将web01的产品代码打包传输到web02服务器上,在web01上线进行打包操作

```bash
[root@web01 ~]# tar czf code.tar.gz /code
[root@web01 ~]# scp code.tar.gz root@172.16.1.8:/tmp
 
#在web02服务器上进行解压
[root@web02 ~]# tar xf /tmp/code.tar.gz -C /
```

6\)最后启动nginx与php-fpm，并加入开机自启

```bash
[root@web02 ~]# systemctl start nginx php-fpm 
[root@web02 ~]# systemctl enable nginx php-fpm
```

## 拆分静态资源至独立服务器

| 为什么拆分静态资源至独立存储服务器 |
| :--- |

*当后端的*`_web_`*节点出现多台时，会导致用户上传的图片、视频附件等内容仅上传至一台*`_web_`*服务器，那么其他的web服务器则无法访问到该图片。*

***

| 新增一台nfs存储解决了什么问题 |
| :--- |

*1.保证了多台web节点静态资源一致。*

*2.有效节省多台web节点的存储空间。*

*3.统一管理静态资源，便于后期推送至CDN进行静态资源加速*

***

| 多台web节点技术架构组成，如下图所示 |
| :--- |

<!-- OCR_START -->
- 多台web共享数据库
- Nginx+PHP
- tcp连接查询数据库
- MySQL
- 客户端
- eth0:10.0.0.7
- eth1:172.16.1.51
- eth1:172.16.1.7
- eth0:10.0.0.8
- eth1:172.16.1.8
- 新增多台web共享存储
- 共享静态资派
- NFS
- 共享静态资源
- eth1:172.16.1.31
- ng.com
<!-- OCR_END -->

***

| 环境准备 |
| :--- |

| **主机名称** | **应用环境** | **外网地址** | **内网地址** |
| :--- | :--- | :--- | :--- |
| web01 | nginx+php | 10.0.0.7 | 172.16.1.7 |
| web02 | nginx+php | 10.0.0.8 | 172.16.1.8 |
| nfs | nfs | 10.0.0.31 | 172.16.1.31 |
| db01 | mysql | 10.0.0.51 | 172.16.1.51 |

***

| nfs服务端，操作步骤如下 |
| :--- |

*1) 安装并配置nfs*

```bash
[root@nfs ~]# yum install nfs-utils -y
[root@nfs ~]# cat /etc/exports
/data/blog 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
/data/zh 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
```

*2)* *创建共享目录，并进行授权*

```bash
[root@nfs01 ~]# mkdir /data/{blog,zh} -p
[root@nfs01 ~]# chown -R www.www /data/
```

*3) 启动nfs服务，并加入开机自启*

```bash
[root@nfs01 ~]# systemctl restart nfs-server
```

***

| web01端操作步骤如下 |
| :--- |

*1) web01节点安装nfs，然后使用showmount查看服务端共享的资源*

```bash
[root@web01 ~]# yum install nfs-utils -y
[root@web01 ~]# showmount -e 172.16.1.31
Export list for 172.16.1.31:
/data/zh   172.16.1.0/24
/data/blog 172.16.1.0/24
```

*2) 如何查找Wordpress静态资源存放的位置*

```bash
浏览器->右键->检查->Network->选择左上角的Select按钮->点击对应的图片，然后能获取到对应的url地址，如下
# http://blog.oldboy.com/wp-content/uploads/2018/11/timg.gif
```

*3) 备份web01服务器上Wordpress的静态资源，因为该服务器上的资源资源最全*

```bash
[root@web01 ~]# cd /code/wordpress/wp-content
[root@web01 wp-content]# cp uploads/ uploads_bak/
```

*4) web01客户端执行挂载操作*

```bash
[root@web01 wp-content]# mount -t nfs 172.16.1.31:/data/blog /code/wordpress/wp-content/uploads/
 
#恢复对应的数据
[root@web01 wp-content]# cp -rp uploads_bak/* uploads/
```

*5) 将挂载信息加入开机自启*

```bash
[root@web01 wp-content]# tail -1 /etc/fstab 
172.16.1.31:/data/blog  /code/wordpress/wp-content/uploads nfs defaults 0 0
[root@web01 wp-content]# mount -a
```

***

| web02端操作步骤如下 |
| :--- |

*1) web02客户端直接挂载nfs即可*

```bash
[root@web02 ~]# mount -t nfs 172.16.1.31:/data/blog /code/wordpress/wp-content/uploads/
```

*2) 将挂载信息加入开机自启*

```bash
[root@web02 ~]# tail -1 /etc/fstab 
172.16.1.31:/data/blog  /code/wordpress/wp-content/uploads nfs defaults 0 0
[root@web02 ~]# mount –a
```

> 更新: 2024-09-22 20:19:20  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/stpdie>