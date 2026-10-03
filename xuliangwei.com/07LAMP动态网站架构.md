# 07 LAMP动态网站架构

# 07 LAMP动态网站架构

* [LAMP架构-基础架构](http://kt.xuliangwei.com/15212562811804.html#toc_0)
* [LAMP架构-部署论坛系统Discuz](http://kt.xuliangwei.com/15212562811804.html#toc_1)
* [LAMP架构-部署博客系统Wordpress](http://kt.xuliangwei.com/15212562811804.html#toc_2)
* [LAMP架构-部署知乎系统Wecenter](http://kt.xuliangwei.com/15212562811804.html#toc_3)
* [LAMP架构-部署网校系统Edusohu](http://kt.xuliangwei.com/15212562811804.html#toc_4)
* [LAMP架构-迁移数据至独立服务器](http://kt.xuliangwei.com/15212562811804.html#toc_5)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## LAMP架构-基础架构

后续的所有开源系统部署, 都基于该环境之上完成

1.基础环境

```plain
[root@apache ~]# sed -ri '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config 
[root@apache ~]# setenforce 0 
[root@apache ~]# systemctl stop firewalld
[root@apache ~]# systemctl disable firewalld
```

2.安装`LAMP`架构

```plain
//检查当前安装的PHP版本, 如版本过低, 请先移除旧版
[root@http-server ~]# rpm -e $(yum list installed | grep php)
//安装epel-扩展源,和remi三方源
[root@http-server ~]# yum install epel-release
[root@http-server ~]# rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
//安装最新php72版本
[root@http-server ~]# yum install -y php72-php php72-php-gd php72-php-mysqlnd \
php72-php-pecl-mysql php72-php-pecl-mysql-xdevapi php72-php-opcache \
php72-php-pecl-memcache php72-php-pecl-memcached php72-php-pecl-redis php72-php-pecl-mcrypt
//安装完PHP72后, 对PHP进行基础优化
[root@http-server ~]# vim /etc/opt/remi/php72/php.ini
date.timezone = Asia/Shanghai
upload_max_filesize = 1024M
post_max_size ＝ 1024M
memory_limit ＝ 1024M
//基础优化后, 启动服务并加入开机自启动
[root@http-server ~]# systemctl start httpd
[root@http-server ~]# systemctl enable httpd
```

3.安装`mariadb`

```plain
//使用yum安装即可
[root@http-server ~]# yum install -y mariadb-server mariadb
//启动服务并加入开机自启动
[root@http-server ~]# systemctl start mariadb 
[root@http-server ~]# systemctl enable mariadb
//简单初始化, 配置root密码
[root@http-server ~]# mysql_secure_installation
Set root password? [Y/n] Y
New password: 输入密码123 
Re-enter new password: 确认密码123
...
//后面一路回车即可
...
//登录Mariadb测试
[root@http-server ~]# mysql -uroot -p123
MariaDB [(none)]> quit
```

## LAMP架构-部署论坛系统Discuz

1.配置`discuz`虚拟主机, 域名为`discuz.bgx.com`

```plain
[root@http-server ~]# vim /etc/httpd/conf.d/discuz.conf
<VirtualHost *:80>
    ServerName discuz.bgx.com
    DocumentRoot "/code/discuz"
    DirectoryIndex index.php index.html
    ErrorLog  logs/error_discuz_log
    CustomLog logs/access_discuz_log combined
</VirtualHost>
<Directory /code/discuz>
    AllowOverride All
    Require all granted
</Directory>
//重启httpd服务
[root@http-server ~]# systemctl restart httpd
```

2.部署`Discuz`源代码

```plain
//获取Discuz代码
[root@http-server ~]# yum install git -y
[root@http-server ~]# git clone https://gitee.com/ComsenzDiscuz/DiscuzX.git
//拷贝代码至站点目录
[root@http-server ~]# cp -r  DiscuzX/upload/ /code/discuz
//安装过程中会出现目录不可写，针对对应目录授权即可(可等安装报错在执行)
[root@http-server ~]# chmod 777 -R /code/discuz/{config,data,uc_client,uc_server}
//windows配置hosts解析, 以便通过域名访问站点
c:\Windows\system32\drivers\etc/hosts
192.168.69.112 discuz.bgx.com
```

3.通过浏览器访问网站

<!-- OCR_START -->
Discuz!安装向导
标杆徐
个→Q口
① discuz.bgx.com/install/
200phpbw%遠
应用运维开发学习写作阅读教育公有云翻译Tmp已导入
Discuz！X3.4简体中文UTF8版20180101
中文版授权协议适用于中文用户
版权所有（C）2001-2017，北京康盛新创科技有限责任公司保留所有权利。
感谢您选择康盛产品。希望我们的努力能为您提供一个高效快速、强大的站点解决方案，和强大的社区论坛解决方
案。康盛公司网址为http：//www.comsenz.com，产品官方讨论区网址为http://www.discuz.net。
用户须知：本协议是您与康盛公司之间关于您使用康盛公司提供的各种软件产品及服务的法律协议。无论您是个人
或组织、盈利与否、用途如何（包括以学习和研究为目的），均需仔细阅读本协议，包括免除或者限制康盛责任的免责
条款及对您的权利限制。请您审阅并接受或不接受本服务条款。如您不同意本服务条款及/或康盛随时对其的修改，您
应不使用或主动取消康盛公司提供的康盛产品。否则，您的任何对康盛产品中的相关服务的注册、登陆、下载、查看等
使用行为将被视为您对本服务条款全部的完全接受，包括接受康盛对服务条款随时所做的任何修改。
本服务条款一旦发生变更，康盛将在网页上公布修改内容。修改后的服务条款一旦在网站管理后台上公布即有效代
替原来的服务条款。您可随时登陆康盛官方论坛查阅最新版服务条款。如果您选择接受本条款，即表示您同意接受协议
各项条件的约束。如果您不同意本服务条款，则不能获得使用本服务的权利。您若有违反本条款规定，康盛公司有权随
时中止或终止您对康盛产品的使用资格并保留追究相关法律责任的权利。
我同意
我不同意
2001-2017ComsenzInc.
<!-- OCR_END -->

<!-- OCR_START -->
- Discuz!安装向导
- 标杆徐
- discuz.bgx.com/install/index.php?step=1&..☆
- 200
- php
- b%
- 应用
- 口运维开发学习口写作阅读教育口公有云
- 翻译Tmp
- ）口已导入
- du
- 开始安装
- 1
- 环境以及文件目录权限检查
- 检查安装环境
- 设置运行环境
- 创建数据库
- 安装
- 环境检查
- 项目
- Discuz!所需配置
- Discuz!最佳
- 当前服务器
- 操作系统
- 不限制
- 类Unix
- Linux
- PHP版本
- 5.2
- 7.0
- 7.2.4
- 附件上传
- 2M
- GD库
- 1.0
- 2.0
- 2.2.5
- CURL库
- 开启
- 开启7.29.0
- OPcache
- 磁盘空间
- 30MB
- 36GB
- 目录、文件权限检查
- 目录文件
- 所需状态
- 当前状态
- ./config/config_global.php
- 可写
- ./config/config_ucenter.php
- ./config
- ./data
- ./data/cache
- ./data/avatar
- ./data/plugindata
- Idata/download
<!-- OCR_END -->

<!-- OCR_START -->
- Discuz!安装向导
- 标杆徐
- ① discuz.bgx.com/install/index.php?step=1&...
- 200
- php
- 应用
- 口运维开发口学习口写作阅读
- 教育口公有云
- 翻译
- Tmp
- 已导入
- /uata/attacmmcmt
- 可与
- ./data/attachment/album
- 可写
- ./data/attachment/forum
- ./data/attachment/group
- ./data/log
- ./uc_client/data/cache
- ./uc_server/data/
- ./uc_server/data/cache
- ./uc_server/data/avatar
- ./uc_server/data/backup
- ./uc_server/data/logs
- ./uc_server/data/tmp
- ./uc_server/data/view
- 函数依赖性检查
- 函数名称
- 检查结果
- 建议
- mysql_connect()
- 支持
- gethostbyname()
- file_get_contents()
- xml_parser_create()
- fsockopen()
- 上一步
- 下一步
- @2001-2017ComsenzInc.
<!-- OCR_END -->

<!-- OCR_START -->
- Discuz!安装向导
- 标杆徐
- discuz.bgx.com/install/index.php
- 200
- php
- bw
- 应用
- 口运维开发口学习口写作阅读
- 教育
- 公有云
- 翻译
- 口Tmp
- 口已导入
- du
- Discuz!
- 安装向导
- Discuz!X3.4简体中文UTF8版20180101
- 2.
- 设置运行环境
- 检测服务器环境以及设置UCenter
- 检查安装环境
- 创建数据库
- 安装
- 全新安装Discuz！X（含UCenterServer）
- O仅安装Discuz！X（手工指定已经安装的UCenterServer）
- 上一步
- 下一步
- 2001-2017ComsenzInc.
<!-- OCR_END -->

# 07 LAMP动态网站架构

<!-- OCR_START -->
- Discuz!安装向导
- 标杆徐
- 不安全|discuz.bgx.com/install/index...
- 302
- php
- bw%
- 应用
- 口运维开发学习口写作阅读教育公有云
- 翻译
- Tmp
- ）口已导入
- du
- 3
- 安装数据库
- 正在执行数据库安装
- 检查安装环境
- 设置运行环境
- 创建数据库
- 安装
- 填写数据库信息
- 数据库服务器：
- localhost
- 数据库服务器地址，一般为localhost
- 数据库名：
- ultrax
- 数据库用户名：
- root
- 数据库密码：
- 123
- 数据表前缀：
- pre_
- 同一数据库运行多个论坛时，请修改前缀
- 系统信箱Email:
- admin@admin.com
- 用于发送程序错误报告
- 填写管理员信息
- 管理员账号：
- admin
- 管理员密码：
- 管理员密码不能为空
- 重复密码：
- 管理员Email：
- 下一步
<!-- OCR_END -->

<!-- OCR_START -->
Discuz!安装向导
标杆徐
×口
① discuz.bgx.com/install/index.php
o1
302
bw%
应用运维开发学习写作阅读
教育口公有云
翻译Tmp口已导入
du
Discuz!
「安装向导
Discuz!X3.4简体中文UTF8版20180101
安装数据库
正在执行数据库安装
检查安装环境
设置运行环境
创建数据库
安装
建立数据表pre_common_template_block...成功
建立数据表pre_common_template_permission...成功
建立数据表pre_common_uin_black...成功
建立数据表pre_common_usergroup...成功
建立数据表pre_common_usergroup_field...成功
建立数据表pre_common_visit...成功
建立数据表pre_common_word...成功
建立数据表pre_common_word_type...成功
建立数据表pre_connect_disktask...成功
建立数据表pre_connect_feedlog...成功
建立数据表pre_connect_memberbindlog...成功
建立数据表pre_connect_postfeedlog...成功
建立数据表pre_connect_tthreadlog...成功
建立数据表pre_forum_access...成功
建立数据表pre_forum_activity...成功
建立数据表pre_forum_activityapply...成功
建立数据表pre_forum_announcement..成功
正在安装...
<!-- OCR_END -->

<!-- OCR_START -->
- Discuz！安装向导
- 标杆徐
- ①discuz.bgx.com/install/index.php?method...
- 200
- php
- bw
- 8
- 应用
- 运维开发学习口写作口阅读教育公有云
- 翻译
- Tmp
- 口已导入
- du
- Discuz！应用中心
- 应用中心特意为您准备了一批优秀应用，插件、模板应有尽有，无限制扩充站点功能，建站必备。
- 快来应用中心装个应用吧！
- oM
- 专注微信应用
- MOCUZAPP·全国900+地方站长共同的选择
- 维清移动社区
- 全新升级
- 拼团
- 砍价
- 交友
- 站式解决方案
- 助力
- 抽奖
- 投票
- 文章
- 西瓜手机应用
- 免费使用
- 共同盈利
- 自动采集发布
- 50多任你挑
- 维清微信文章采集器
- 顶象无感验证码
- 【防灌水】智能验证码
- 安装：893★★★★☆
- 安装：2,808★★
- 安装：2,288★
- Discuz!短信通
- 【同盾】论坛防灌水
- 手机注册V手机登录
- 安装：2.2万★★★★★
- 安装：1.4万★★★★★
- Free
- 安装：873★★★★★
- 克米设计APP手机版
- 让您的手机版与众不同
- immwa
- 完美的体验
- 精雕细琢
- -APP3.0
- 城市生活|地方门户
- APP!手机模板
- 地方门户城市自适
- ★★★★★
- 您的论坛已完成安装，点此访问
- 2001-2017ComsenzInc.
<!-- OCR_END -->

<!-- OCR_START -->
- 欢迎安装discuz－默认版块－Di×
- 标杆徐
- discuz.bgx.com/forum.php?mod=viewthre...
- 200
- bw%
- 应用
- 运维口开发口学习口写作口阅读教育口公有云
- 翻译Tmp口已导入
- du
- 社区动力
- admin在线|我的|设置|消息|提醒
- DISCUZ!
- 积分
- 论坛
- 请输入搜索内容
- 帖子
- 热搜：活动交友discuz
- ）论坛）Discuz!）黑
- 默认版块）欢迎安装discuz
- 发帖
- 回复
- 删除主题丨升降丨置顶丨直播丨高亮丨精华丨图章丨图标丨关闭丨移动丨分类丨复制丨合并丨分割丨修复丨警告丨屏蔽丨标签
- 查看：1|回复：0
- 欢迎安装discuz[复制链接]
- admin
- 发表于 29秒前丨只看该作者
- 欢迎安装Discuz
- bydiscuz.bgx.com
- 1
- 5
- 主题
- 管理员
- 收藏
<!-- OCR_END -->

## LAMP架构-部署博客系统Wordpress

1.配置`wordpress`虚拟主机, 域名为`blog.bgx.com`

```plain
[root@http-server ~]# vim /etc/httpd/conf.d/wordpress.conf
<VirtualHost *:80>
    ServerName blog.bgx.com
    DocumentRoot "/code/wordpress"
    DirectoryIndex index.php index.html
    ErrorLog  logs/error_wordpress_log
    CustomLog logs/access_wordpress_log combined
</VirtualHost>
<Directory /code/wordpress>
    AllowOverride All
    Require all granted
</Directory>
//重启httpd服务
[root@http-server ~]# systemctl restart httpd
```

2.部署`wordpress`源代码

```plain
//获取wordpress代码
[root@http-server ~]# cd /soft/src
[root@http-server ~]# wget https://cn.wordpress.org/wordpress-4.9.4-zh_CN.tar.gz
//解压软件网站源码文件, 并授权站点目录,不然会导致无法安装
[root@http-server /soft/src]# tar xf wordpress-4.9.4-zh_CN.tar.gz
[root@http-server /soft/src]# cp -r wordpress /code/
[root@http-server ~]# chown -R apache.apache /code/wordpress/
//由于Wordpress无法自动创建数据库, 所以需要手动建立数据库
[root@http-server ~]# mysql -uroot -p123
MariaDB [(none)]> create database wordpress;
MariaDB [(none)]> exit
//windows配置hosts解析, 以便通过域名访问站点
c:\Windows\system32\drivers\etc\hosts
192.168.69.112 discuz.bgx.com blog.bgx.com
```

3.通过浏览器访问网站

<!-- OCR_START -->
WordPress>调整配置文件
标杆徐
个→Q口
blog.bgx.com/wp-admin/setup-config..Q☆
200Wbw%G这
应用运维开发学习写作阅读教育公有云翻译Tmp已导入
欢迎使用WordPresS。在开始前，我们需要您数据库的一些信息。请准备好如下信息。
1.数据库名
2.数据库用户名
3.数据库密码
4.数据库主机
5.数据表前缀（tableprefix，特别是当您要在一个数据库中安装多个WordPress时）
我们会使用这些信息来创建一个wp-config·php文件。如果自动创建未能成功，不用担心，您要做的只是将数据
库信息填入配置文件。您也可以在文本编辑器中打开wp-config-sample.php，填入您的信息，并将其另存为wp-
config·php。需要更多帮助？看这里。
绝大多数时候，您的网站服务提供商会给您这些信息。如果您没有这些信息，在继续之前您将需要联系他们。如果
您准备好了.…
现在就开始！
<!-- OCR_END -->

<!-- OCR_START -->
- WordPress>调整配置文件
- 标杆徐
- 不→
- ①不安全blog.bgx.com/wp-admin/setu..
- Q☆
- 200
- 应用运维开发学习写作阅读教育公有云
- 翻译口Tmp口已导入
- du
- 请在下方填写您的数据库连接信息。如果您不确定，请联系您的服务提供商。
- 数据库名
- wordpress
- 将WordPress安装到哪个数据库？
- 用户名
- 您的数据库用户名。
- root
- 密码
- 123
- 您的数据库密码。
- 数据库主机
- localhost
- 如果localhost不能用，您通常可以从网站服
- 务提供商处得到正确的信息。
- 表前缀
- 如果您希望在同一个数据库安装多个
- wp_
- WordPress，请修改前缀。
- 提交
<!-- OCR_END -->

<!-- OCR_START -->
WordPress>调整配置文件
标杆徐
←→C口
blog.bgx.com/wp-admin/setup-config...Q☆
200WbW%G德
应用运维开发学习写作阅读教育公有云翻译Tmp已导入
不错。您完成了安装过程中重要的一步，WordPress现在已经可以连接数据库了。如果您准备好了的话，现在就..
现在安装
<!-- OCR_END -->

<!-- OCR_START -->
- WordPress>安装
- 标杆徐
- ①不安全|blog.bgx.com/wp-admin/i...oQ☆
- 200
- Wbw%田
- 应用口运维
- 开发口学习口写作阅读
- 教育公有云
- 翻译口Tmp口已导入
- du
- 欢迎
- 欢迎使用著名的wordPress五分钟安装程序！请简单地填写下面的表格，来开始使用这个世界上最具扩展性、最
- 强大的个人信息发布平台。
- 需要信息
- 您需要填写一些基本信息。无需担心填错，这些信息以后可以再次修改。
- 站点标题
- wordpress-bgx
- 用户名
- bgx
- 用户名只能含有字母、数字、空格、下划线、连字符、句号和“@"符号。
- 密码
- 123
- 隐藏
- 非常弱
- 重要：您将需要此密码来登录，请将其保存在安全的位置。
- 确认密码
- 确认使用弱密码
- 您的电子邮件
- biaoganxu@foxmail.com
- 请仔细检查电子邮件地址后再继续。
- 对搜索引擎的可见性
- 口建议搜索引擎不索引本站点
- 搜索引l擎将本着自觉自愿的原则对待WordPress提出的请求。并不是所有搜索引l擎都会
- 遵守这类请求。
- 安装WordPress
<!-- OCR_END -->

<!-- OCR_START -->
- WordPress>安装
- 标杆徐
- blog.bgx.com/wp-admin/install.php?sto☆
- 200WbW%G
- 应用运维开发学习写作阅读教育公有云翻译Tmp已导入
- du
- 成功！
- WordPress安装完成。谢谢！
- 用户名
- bgx
- 密码
- 您设定的密码。
- 登录
<!-- OCR_END -->

<!-- OCR_START -->
- 登录<wordpress-bgx—WordIx
- 标杆徐
- ①不安全blog.bgx.com/wp-login.php
- 200
- phpbw%
- 应用运维开发学习写作阅读教育公有云
- 口翻译口Tmp口已导入
- du
- 用户名或电子邮件地址
- bgx
- 密码
- 记住我的登录信息
- 登录
- 忘记密码？
- ←返回到wordpress-bgx
<!-- OCR_END -->

<!-- OCR_START -->
- 标杆徐
- 我的个人网站-wordpress-bgxx
- ① blog.bgx.com/?p=4
- 200W%
- 应用
- 运维开发学习口写作阅读教育公有云
- 翻译白Tmp已导入
- du
- >>
- WORDPRESS-BGX
- 又一个WordPress站点
- 2018年4月1日由BGX
- 我的个人网站
- 编辑
<!-- OCR_END -->

## LAMP架构-部署知乎系统Wecenter

1.配置`wecenter`虚拟主机, 域名为`wecenter.bgx.com`

```plain
[root@http-server ~]# vim /etc/httpd/conf.d/wecenter.conf
<VirtualHost *:80>
    ServerName zh.bgx.com
    DocumentRoot "/code/wecenter"
    DirectoryIndex index.php index.html
    ErrorLog  logs/error_wecenter_log
    CustomLog logs/access_wecenter combined
</VirtualHost>
<Directory /code/wecenter>
    AllowOverride All
    Require all granted
</Directory>
//重启httpd服务
[root@http-server ~]# systemctl restart httpd
```

2.部署`wecenter`源代码

```plain
//获取wecenter代码
[root@http-server ~]# cd /soft/src
[root@http-server /soft/src]# wget http://ahdx.down.chinaz.com/201605/WeCenter_v3.1.9.zip
//解压软件网站源码文件, 并授权站点目录,不然会导致无法安装
[root@http-server /soft/src]# unzip WeCenter_v3.1.9.zip
[root@http-server /soft/src]# cp -rp UPLOAD/ /code/wecenter
//wecenter安装时需要授权的目录
[root@http-server ~]# chmod  -R 777 /code/wecenter/system
//创建数据库
[root@http-server ~]# mysql -uroot -p123
MariaDB [(none)]> create database wecenter;
Query OK, 1 row affected (0.00 sec)
MariaDB [(none)]> quit
Bye
//windows配置hosts解析, 以便通过域名访问站点
c:\Windows\system32\drivers\etc\hosts
192.168.69.112 discuz.bgx.com blog.bgx.com zh.bgx.com
```

3.通过浏览器访问网站

<!-- OCR_START -->
- WeCenter - Install
- 标杆徐
- zh.bgx.com/install/
- 200BW%T遠
- 应用运维开发学习写作阅读教育公有云翻译 Tmp已导入
- G Google
- :Ygoogle
- We
- Center
- ·欢迎使用
- 欢迎使用WeCenter安装程序，WeCenter是中国首个基于PHP+MYSQL开发的开源化社交问答社区
- ·服务器环境检查
- 为了确保程序安装顺利，您的服务器需要满足以下系统需求的运行环境
- PHP 版本
- 7.2.4
- 数据库模块
- PDO_MYSQL
- Session 支持
- Cookie支持
<!-- OCR_END -->

<!-- OCR_START -->
- WeCenter - Install
- 标杆徐
- ① zh.bgx.com/install/
- 200BW%德
- 应用运维开发学习写作阅读教育公有云翻译Tmp已导入
- G GoogleY google
- 图象处理库
- GD
- √ (加装 ImageMagick 性能更佳)
- FreeType 支持
- Zlib 支持
- Mcrypt 支持
- 编码转换
- 上传限制
- 500M（此处建议值>8M）
- 目录权限
- /code/wecenter/system/
- /code/wecenter/system/config/
- 下一步
<!-- OCR_END -->

# 07 LAMP动态网站架构

<!-- OCR_START -->
- WeCenter - Install
- 标杆徐
- ① 不安全|zh.bgx.com/install/
- ··
- 200Bbw%遠
- 应用运维开发学习写作阅读教育公有云翻译Tmp已导入
- G Google Y google
- ·配置系统
- 需要您提供必要的系统配置信息
- 数据库主机
- localhost
- 通常为 localhost
- 数据库帐号
- root
- 数据库密码
- 123
- 数据库端口
- 一般情况下不需要填写
- 数据库名称
- wecenter
- 数据表前缀
- aws_
- 同数据库安装多个本程序时需要更改
- 数据表类型
- InnoDB
- 请根据服务器状态选择数据表类型
- 开始安装
<!-- OCR_END -->

<!-- OCR_START -->
- WeCenter - Install
- 标杆徐
- ①不安全|zh.bgx.com/install/
- ··
- 200BW%G
- 应用运维开发学习写作阅读教育公有云翻译Tmp已导入G GoogleY google
- We
- Center
- ·添加管理员
- 数据库导入成功，创建管理员账户
- 用户名
- bgx
- ...
- 密码
- E-mail
- xuliangwei@foxmail.cor
- 完成
- 遇到问题？联系我们| Copyright @-WeCenter 3.1.9,All Rights Res(
<!-- OCR_END -->

<!-- OCR_START -->
- WeCenter - Install
- 标杆徐
- C口
- zh.bgx.com/install/
- 1☆
- ··
- 20BW%G
- 应用运维开发学习写作阅读教育公有云翻译Tmp已导入G Google
- eY google
- We
- Center
- ·安装成功
- 欢迎使用WeCenter问答交流平台，为了增强安全性
- 请将 instal/index.php文件删除
- 访问网站首页
- 遇到问题？联系我们|Copyright-WeCenter3.1.9，AllRightsReser
<!-- OCR_END -->

## LAMP架构-部署网校系统Edusohu

1.配置`edusohu`虚拟主机, 域名为`edu.bgx.com`

```plain
[root@http-server ~]# vim /etc/httpd/conf.d/edu.conf
<VirtualHost *:80>
    ServerName edu.bgx.com
    DocumentRoot "/code/edu/web"
    DirectoryIndex app.php index.php index.html
    ErrorLog  logs/error_edu_log
    CustomLog logs/access_edu_log combined
</VirtualHost>
<Directory /code/edu/web>
    AllowOverride All
    Require all granted
</Directory>
//重启httpd服务
[root@http-server ~]# systemctl restart httpd
```

2.部署`edusohu`源代码

```plain
//获取wordpress代码
[root@http-server ~]# cd /soft/src/
[root@http-server /soft/src]# wget http://download.edusoho.com/edusoho-8.2.17.tar.gz
//解压软件网站源码文件, 并授权站点目录,不然会导致无法安装
[root@http-server /soft/src]# tar xf edusoho-8.2.17.tar.gz
[root@http-server /soft/src]# cp -r edusoho /code/edu
[root@http-server ~]# chown -R apache.apache /code/edu/
[root@http-server ~]# chmod -R  777  /code/edu/{app,web}
//由于edusohu会自动创建数据库, 所以无需创建数据库
//windows配置hosts解析, 以便通过域名访问站点
c:\Windows\system32\drivers\etc\hosts
192.168.69.112 discuz.bgx.com blog.bgx.com edu.bgx.com
```

3.通过浏览器访问网站

<!-- OCR_START -->
EDUSOHO安装程序
标杆徐
C口
① edu.bgx.com/install/start-install.php
302BWG这
应用运维开发学习写作阅读教育公有云翻译Tmp已导入G GoogleY google
EduSoho网络课堂安装向导v8.2.17
版权所有02011-2018，杭州阔知网络科技有限公司
保留所有权利。
感谢您选择EduSoho网络课堂。希望我们的努力能为您提供一个高效快速和强大的在线教育解决方案。
EduSoho，中文全称为EduSoho网络课堂，以下简称EduSoho。
杭州阔知网络科技有限责任公司为EduSoho产品的开发商，依法独立拥有EduSoho产品著作权（软著登字第064
4777号）。EduSoho官方网站网址为http://www.edusoho.com。官方讨论区网址为http://www.howzhi.co
m/group/edusoho
使用者：无论个人或组织、盈利与否、用途如何（包括以学习和研究为目的），均需仔细阅读本协议，在理解、同
意、并遵守本协议的全部条款后，方可开始使用EduSoho软件。
本授权协议适用且仅适用于EduSoho版本，杭州阔知网络科技有限公司拥有对本授权协议的最终解释权。
I协议许可的权利
同意协议，并开始安装！
<!-- OCR_END -->

<!-- OCR_START -->
- EDUSOHO安装程序
- 标杆徐
- edu.bgx.com/install/start-install.php?step=1
- 200Bbw
- 应用
- 运维
- 开发学习写作阅读教育公有云翻译Tmp已导入GGoogleY google
- EduSoho网络课堂安装向导v8.2.17
- 1.环境检测
- 2.创建数据库
- 3.初始化系统
- 4.完成安装
- 环境检测
- 推荐配置
- 当前状态
- 最低要求
- 操作系统
- Linux
- PHP版本
- 5.6.x
- √7.2.4
- 5.5.0
- PDO_MySQL
- 必须
- √已安装
- 文件上传大小
- 大于200M
- √500M
- 2M
- 该值决定可以上传视频的最大大小
- 表单数据大小
- √ 8M
- 该值不能小于文件上传大小的值
- PHP脚本最大执行时间
- 大于300秒
- √30秒
- 该值决定上传视频时，最长可使用的时间
- PHP扩展：mbstring
- 该扩展用于处理中文字符
- PHP扩展：curl
- 该扩展用于远程读取文件
- PHP扩展：GD
<!-- OCR_END -->

<!-- OCR_START -->
- EDUSOHO安装程序
- 标杆徐
- ① edu.bgx.com/install/start-install.php?step=1
- 200BbW遠
- 用应用运维
- 开发学习写作阅读教育公有云翻译Tmp已导入GGoogle
- eYgoogle
- PHP扩展：curl
- 必须
- √已安装
- 该扩展用于远程读取文件
- PHP扩展：GD
- 该扩展用于处理图片
- 文件、目录权限检查
- 当前状态
- 所需状态
- 安全模式
- √关闭
- app/config/parameters.yml
- √可写
- app/data/udisk
- app/data/private_files
- web/files
- web/install
- app/cache
- app/data
- app/logs
- 下一步
<!-- OCR_END -->

# 07 LAMP动态网站架构

<!-- OCR_START -->
- EDUSOHO安装程序
- 标杆徐
- ① 不安全| edu.bgx.com/install/start-install.php?step=2
- 200
- Bbw
- 应用
- 运维
- 开发学习写作阅读教育公有云翻译Tmp已导入
- G Google Y google
- EduSoho网络课堂安装向导v8.2.17
- 1.环境检测
- 2.创建数据库
- 3.初始化系统
- 4.完成安装
- 数据库服务器
- 127.0.0.1
- 数据库服务器地址，一般为localhost或者127.0.0.1
- 数据库端口号
- 3306
- 数据库端口号，默认为3306
- 数据库用户名
- root
- 数据库密码
- 数据库名
- edusoho
- 覆盖现有数据库
- 创建数据库
<!-- OCR_END -->

<!-- OCR_START -->
- EDUSOHO安装程序
- 标杆徐
- ① 不安全| edu.bgx.com/install/start-install.php?step=3
- 1☆
- 200
- 应用
- 运维开发学习写作阅读教育公有云翻译Tmp已导入
- GGoogleYgoogle
- EduSoho网络课堂安装向导v8.2.17
- 1.环境检测
- 2.创建数据库
- 3.初始化系统
- 4.完成安装
- 网站名称
- 我的网络课堂
- 管理员Email地址
- xuliangwei@foxmail.com
- Email地址作为帐号，用于登录网站
- 管理员用户名
- xuliangwei
- 管理员密码
- 123.com
- 网站负责人姓名
- 徐亮伟
- 手机号码
- 15210540000
- QQ号码
- 572891887
- 初始化系统
<!-- OCR_END -->

<!-- OCR_START -->
- 任务学习－ EduSoho网络课堂 -
- 标杆徐
- C口
- ① edu.bgx.com/course/2/task/9/show#
- 200
- 应用运维开发学习写作阅读教育公有云翻译Tmp已导入
- G Google
- Y google
- <返回课程
- 任务1：企业培训-Linux运维知识体系-自动化运维
- 第1章:企业内训
- 6.数据库、MySQL
- 非关系型、
- Memcache、Redis、MangoDB
- 7.负载均衡
- Nginx4层7层
- Haproxy.
- 8.高可用
- Keepalived
- 9.Shell编程
- ->面向过程
- 面向对象
- 目录
- 高级：
- 自动化运维+企业私有云
- 1.自动化安装操作系统
- （Cobbler）定义标准化规范
- 2.自动化配置管理工具（Saltstack（c/s）、
- Ansible)
- 笔记
- 3.自动化部署业务（git分布式版本管理系统|
- 持续部署、持续集成、git+Jenkins+SheLL)
- 4.自动化监控工具（Zabbix/cs）
- 分布式proxy)
- 资产录入、资产管理CMDB
- 问答
- 10:54 / 11:36
- ?任务完成条件
- ○学过了
<!-- OCR_END -->

## LAMP架构-迁移数据至独立服务器

迁移LNMP的数据库到独立的数据库服务器步骤

（一）老服务器操作

```plain
//1.从老的数据库里导出数据
[root@Httpd ~]# mysqldump -uroot -p123 -A -B --events|gzip > /tmp/backup.sql.gz
[root@Httpd ~]# ls /tmp/backup.sql.gz 
/tmp/backup.sql.gz
//2.拷贝到独立的数据库服务器
[root@Httpd ~]# scp /tmp/backup.sql.gz root@192.168.69.113:/tmp
backup.sql.gz                                   100% 1347KB  21.9MB/s   00:00
```

（二）新服务器操作

```plain
//导入数据库
[root@MySQL ~]# gzip -d /tmp/backup.sql.gz 
[root@MySQL ~]# mysql -uroot -p123 </tmp/backup.sql
//重新授权
MariaDB [(none)]> grant all on  *.* to remote_user@'192.168.69.%' identified by '123456';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

（三）web服务器上修改程序连接文件

```plain
修改对应mysql连接
//wordpress
/code/wordpress/wp-config.php
//Discuz
/code/discuz/config/config_global.php
/code/discuz/config/config_ucenter.php
```

> 更新: 2019-03-20 20:01:54  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/clgieb>