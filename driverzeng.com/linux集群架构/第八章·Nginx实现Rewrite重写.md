# 第八章·Nginx实现Rewrite重写

# Rewrite基本概述

| 什么是rewrite |
| --- |

Rewrite主要实现url地址重写，以及重定向，就是把传入`web`的请求重定向到其他`url`的过程。

***

| Rewrite使用场景 |
| --- |

1、地址跳转，用户访问www.drz.com这个URL是，将其定向至一个新的域名mobile.drz.com

2、协议跳转，用户通过http协议请求网站时，将其重新跳转至https协议方式

3、伪静态，将动态页面显示为静态页面方式的一种技术，便于搜索引擎的录入，同时建上动态URL地址对外暴露过多的参数，提升更高的安全性。

4、搜索引擎，SEO优化依赖于url路径，好记的url便于智齿搜索引擎录入

***

| Rewrite配置示例 |
| --- |

```bash
句法：Syntax:  rewrite regex replacement [flag]
默认：Default: --
语境：Context: server,location,if
#用于切换维护页面场景
#rewrite ^(.*)$ /page/maintain.html break;
```

## Rewrite标记Flag

`rewrite`指令根据表达式来重定向`URL`，或者修改字符串，可以应用于`server，location，if`环境下，每行`rewrite`指令最后跟一个`flag`标记，支持的`flag`标记有如下表格所示：

| flag | 作用 |
| --- | --- |
| last | 本条规则匹配完成后，停止匹配，不再匹配后面的规则 |
| break | 本条规则匹配完成后，停止匹配，不再匹配后面的规则 |
| redirect | 返回302临时重定向，地址栏会显示跳转后的地址 |
| permanent | 返回301永久重定向，地址栏会显示跳转后的地址 |

***

| last与break区别对比示例 |
| --- |

```bash
[root@web01 conf.d]# cat rewrite.conf 
server {
        listen 80;
        server_name rewrite.drz.com;
        root /code;
        location ~ ^/break {
                rewrite ^/break /test/ break;
        }
        location ~ ^/last {
                rewrite ^/last /test/ last;
        }
        location /test/ {
                default_type application/json;
                return 200 "ok";
        }
}
#重启nginx服务
[root@web01 conf.d]# nginx -t 
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@web01 conf.d]# nginx -s reload

```

**如果懂**`**shell**`**脚本的，这两个就类似于脚本中的，**`**break**`**和**`**continue**`

| 浏览器访问break |
| --- |

<!-- OCR_START -->
- 404 Not Found
- I 应用 zabbix-api
- nginx/1.16.0
<!-- OCR_END -->

| 浏览器访问last |
| --- |

<!-- OCR_START -->
404NotFound
rewrite.drz.com/last
←→C①不安全| rewrite.drz.com/last
ll应用zabbix-api
<!-- OCR_END -->

| last与break区别 |
| --- |

break 只要匹配到规则，则会去本地配置路径的目录中寻找请求的文件；

而last只要匹配到规则，会对其所在的server(...)标签重新发起请求。

```bash
break请求：
1、请求rewrite.drz.com/break
2、首先：会去查找本地的/code/test/index.html;
3、如果找到了，则返回/code/test/index.html的内容；
4、如果没找到该目录则报错404，如果找到该目录没找到对应的文件则403
last请求:
1、请求rewrite.drz.com/last
2、首先：会去查找本地的/code/test/index.html;
3、如果找到了，则返回/code/test/index.html的内容；
4、如果没找到，会对当前server重新的发起一次请求，rewrite.drz.com/test/
5、如果有location匹配上，则直接返回该location的内容。
4、如果也没有location匹配，再返回404;
```

所以，在访问/break和/last请求时，虽然对应的请求目录/test都是不存在的，理论上都应该返回404，但是实际上请求/last的时候，是会有后面location所匹配到的结果返回的，原因在于此。

***

| redirect与permanent区别对比示例 |
| --- |

```bash
[root@web01 conf.d]# cat rewrite.conf 
server {
        listen 80;
        server_name rewrite.drz.com;
        root /code;
        location /test {
                rewrite ^(.*)$  http://www.driverzeng.com redirect;
                #rewrite ^(.*)$  http://www.driverzeng.com permanent;
                #return 301 http://www.driverzeng.com;
                #return 302 http://www.driverzeng.com;
        }
}
```

***

| redirect与permanent区别（实现https） |
| --- |

<!-- OCR_START -->
- DBA老司机带你删库到跑路.
- C☆
- ☆302
- 入收藏。开始
- http://rewrite.drz.com/test
- 302:Temporaryredirect tohttps://www.drive
- ceng.com
- 首页
- 曾老湿撩妹宝典（PUA）
- Linux基础篇
- Linux架构篇
- DATABASE
- DevOps
- 监控系
- 200: HTTP/1.1 200
- 文件存储
- 下载工具地址
- 面试技巧
- 这周日你有空吗？
- 曾老湿
- DriverZeng
<!-- OCR_END -->

<!-- OCR_START -->
- DBA老司机带你删库到跑路.
- C☆https://www.driverzeng.com
- 301
- 入收藏。开始
- http://rewrite.drz.com/test
- 301Permanent redirect to https:/www.driverzeng.com/
- 曾老湿撩妹宝典(PUA)
- Linux基础篇
- Linux架构篇
- DATABASE
- DevOps
- 监控系
- 首页
- Web
- 200: HTTP/1.1 200
- 文件存储
- 下载工具地址
- 面试技巧
- 这周日你有空吗？
<!-- OCR_END -->

```bash
redirect: 每次请求都会询问服务器，如果当服务器不可用时，则会跳转失败。
permanent: 第一次请求会询问，浏览器会记录跳转的地址，第二次则不再询问服务器，直接通过浏览器缓存的地址跳转。
```

## Rewrite规则实践

在写rewrite规则之前，我们需要开启rewrite日志对规则的匹配进行调试。

```bash
[root@web01 code]# vim /etc/nginx/nginx.conf
/var/log/nginx/error.log notice;
http{
    rewrite_log on;
}
```

***

| 案例一 |
| --- |

用户访问`/abc/1.html`实际上真实访问的是`/ccc/bbb/2.html`

```bash
#http://www.drz.com/abc/1.html  ==>  http://www.drz.com/ccc/bbb/2.html
#1.准备真实访问路径
[root@web03 ~]# mkdir /code/ccc/bbb -p
[root@web03 ~]# echo "ccc_bbb_2" > /code/ccc/bbb/2.html
#2.Nginx跳转配置
[root@web03 ~]# cd /etc/nginx/conf.d/
[root@web03 conf.d]# cat ccbb.conf 
server {
        listen 80;
        location / {
                root /code;
                index index.html;
        }
        location /abc {
                rewrite (.*) /ccc/bbb/2.html redirect;
                #return 302 /ccc/bbb/2.html;
        }
}
#3.重启Nginx服务
[root@web03 conf.d]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@web03 conf.d]# nginx -s reload
```

***

| 案例二 |
| --- |

用户访问`/2018/ccc/2.html`实际上真实访问的是`/2014/ccc/bbb/2.html`

```bash
##http://www.drz.com/2018/ccc/2.html  ==>  http://www.drz.com/2014/ccc/bbb/2.html
#1.准备真是的访问路径
[root@web03 conf.c]# mkdir /code/2014/ccc/bbb -p 
[root@web03 conf.c]# echo "2014_ccc_bbb_2" > /code/2014/ccc/bbb/2.html
#2.Nginx跳转配置
[root@web03 conf.d]# cat ccbb.conf 
server {
        listen 80;
        location / {
                root /code;
                index index.html;
        }
        location /2018 {
                rewrite ^/2018/(.*)$ /2014/$1 redirect;
        }
}
#3.重启nginx服务
[root@web03 conf.d]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@web03 conf.d]# nginx -s reload
```

***

| 案例三 |
| --- |

用户访问/test实际上真实访问的是<https://www.driverzeng.com>

```bash
#1.Nginx跳转配置
[root@web03 conf.d]# cat test.conf 
server {
        listen 80;
        location /test {
                rewrite (.*) https://www.driverzeng.com redirect;
        }
}
#2.重启nginx服务
[root@web03 conf.d]# nginx -s reload
```

***

| 案例四 |
| --- |

用户访问`couese-11-22-33.html`实际上真实访问的是`/course/11/22/33/course_33.html`

```bash
#http://www.drz.com/couese-11-22-33.html  ==>  http://www.drz.com/course/11/22/33/course_33.html
#1.准备真是的访问路径
[root@web03 ~]# mkdir /code/course/11/22/33 -p
[root@web03 ~]# echo "curl docs.etiantian.org" > /code/course/11/22/33/course_33.html
#2.Nginx跳转配置
[root@web03 conf.d]# cat test.conf 
server {
        listen 80;
        root /code;
        index index.html;
        location / {
                #灵活配法
                rewrite ^/course-(.*)-(.*)-(.*).html$ /course/$1/$2/$3/course_$3.html redirect;
                #固定配法
                #rewrite ^/course-(.*) /course/11/22/33/course_33.html redirect;
        }
}
#3.重启nginx服务
[root@web03 conf.d]# nginx -s reload
```

***

| 案例五 |
| --- |

将`http`请求跳转到`https`

```bash
#Nginx跳转配置
server {
        listen 80;
        server_name www.dirverzeng.com;
        rewrite ^(.*) https://$server_name$1 redirect;
        #return 302 https://$server_name$request_uri;
}       
server {
        listen 443;
        server_name www.driverzeng.com;
        ssl on;
}
```

## Rewrite场景示例

```bash
#部署discuz论坛
[root@web01 conf.d]# vim discuz.drz.com.conf
server {
        listen 80;
        server_name discuz.drz.com;
        location / {
                root /code/discuz;
                index index.php index.html;
        }
        location ~ \.php$ {
                root /code/discuz;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }
}
#创建站点目录部署代码
[root@web01 ~]# mkdir /code/discuz
[root@web01 ~]# rz Discuz_X3.3_SC_GBK.zip
[root@web01 ~]# unzip Discuz_X3.3_SC_GBK.zip -d /code/discuz/
#授权站点目录
[root@web01 discuz]# chown www.www -R /code/
#创建数据库
MariaDB [(none)]> create database discuz;
Query OK, 1 row affected (0.00 sec)
MariaDB [(none)]> grant all on discuz.* to discuz@'%' identified by '123';
Query OK, 0 rows affected (0.00 sec)
```

<!-- OCR_START -->
Discuz!安装向导
←→C① 不安全| discuz.drz.com/install/
9
应用 zabbix-api
Discuz!X3.3简体中文版20170701
中文版授权协议适用于中文用户
版权所有（c)2001-2017，北京康盛新创科技有限责任公司保留所有权利。
感谢您选择康盛产品。希望我们的努力能为您提供一个高效快速、强大的站点解决方案，和强大的社区论坛解决方
案。康盛公司网址为http://www.comsenz.com，产品官方讨论区网址为http://www.discuz.net。
用户须知：本协议是您与康盛公司之间关于您使用康盛公司提供的各种软件产品及服务的法律协议。无论您是个人或
组织、盈利与否、用途如何（包括以学习和研究为目的），均需仔细阅读本协议，包括免除或者限制康盛责任的免责条款
及对您的权利限制。请您审阅并接受或不接受本服务条款。如您不同意本服务条款及/或康盛随时对其的修改，您应不使用
或主动取消康盛公司提供的康盛产品。否则，您的任何对康盛产品中的相关服务的注册、登陆、下载、查看等使用行为将
被视为您对本服务条款全部的完全接受，包括接受康盛对服务条款随时所做的任何修改。
本服务条款一旦发生变更，康盛将在网页上公布修改内容。修改后的服务条款一旦在网站管理后台上公布即有效代替
原来的服务条款。您可随时登陆康盛官方论坛查阅最新版服务条款。如果您选择接受本条款，即表示您同意接受协议各项
条件的约束。如果您不同意本服务条款，则不能获得使用本服务的权利。您若有违反本条款规定，康盛公司有权随时中止
或终止您对康盛产品的使用资格并保留追究相关法律责任的权利。
我同意我不同意
曾老湿
2001 - 2017 Comsenz Inc.
DriverZeng
<!-- OCR_END -->

<!-- OCR_START -->
- Discuz!安装向导
- 不安全|discuz.drz.com
- Vinstall/index.php?step=1&uchidden=&submit=%CE%D2%CD%AC%D2%E2
- 应用
- zabbix-api
- 目录、文件权限检查
- 目录文件
- 所需状态
- 当前状态
- 可写
- /config/config_global.php
- ./config/config_ucenter.php
- ./config
- /data
- /data/cache
- /data/avatar
- /data/plugindata
- /data/download
- /data/addonr
- /data/template
- /data/threadcache
- /data/attachment
- /data/attachment/album
- /data/attachment/forum
- ./data/attachment/group
- /data/log
- /uc_client/data/cache
- /uc_server/data/
- ./uc_server/data/cache
- ./uc_server/data/avatar
- /uc_server/data/backup
- ./uc_server/data/logs
- ./uc_server/data/tmp
- ./uc_server/data/view
- 函数依赖性检查
- 函数名称
- 检查结果
- 建议
- mysqli_connect()
- 支持
- gethostbyname()
- file_get_contents()
- xml_parser_create()
- fsockopen()
- 上一步下一步
- 曾老湿
- 2001-2017ComsenzInc.
- DriverZeng
<!-- OCR_END -->

<!-- OCR_START -->
- ！安装向导
- 应用
- zabbix-api
- Discuz！安装向导
- 设置运行环境
- 检测服务器环境以及设置UCenter
- 检查安装环境
- 创建数据库
- ○仅安装 Discuz!X（手工指定已经安装的 UCel
- 上一步下一步
- 曾老湿
- 2001-2017
<!-- OCR_END -->

<!-- OCR_START -->
- Discuz!安装向导
- Il 应用  zabbix-api
- Discuz!
- 安装向导
- 安装数据库
- 正在执行数据库安装
- 检查安装环境
- 设置运行环境
- 创建数据库
- 填写数据库信息
- 数据库服务器：
- 172.16.1.51
- 数据库服务器地址，一般为localhost
- 数据库名：
- 数据库用户名：
- 数据库密码：
- 123
- 数据表前缀：
- pre_
- 同一数据库运行多个论坛时，请修改前缀
- 系统信箱Email：
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
- 曾老湿
- 2001-2017Co
- DriverZeng
<!-- OCR_END -->

<!-- OCR_START -->
- ！安装向导
- 不安全|discuz.drz.co
- /install/index.php
- 应用
- Discuz！安装向导
- 安装数据库
- 正在执行数据库安装
- 检查安装环境
- 设置运行环境
- 建立数据表pre_portal_.topic_pic...成功
- 建立数据表pre_security_evilpost..成功
- 建立数据表pre_security_eviluser...
- 成功
- 建立数据表pre_security_.failedlog...成功
- 正在安装数据…..成功
- 正在安装附加数据.….．成功
- 初始化记录201908_ratelog
- 初始化记录201908_illegallog
- 初始化记录201908_modslog
- 初始化记录201908_cplog
- 初始化记录201908_errorlog
- 初始化记录201908_banlog
- 清空目录./data/template
- 清空目录./data/cache
- 清空目录./data/threadcache
- 清空目录./uc_client/data
- 清空目录./uc_client/data/cache
- 正在安装
- 2001- 2017 Comsenz Inc.
- 曾老湿
- DriverZeng
<!-- OCR_END -->

<!-- OCR_START -->
- Discuz!安装向导
- →C不安全| discuz.drz.con
- /instal/index.php?method=ext_info
- 应用 餐 zabbix-api
- Discuz!
- 安装向导
- Discuz!X3.3简体中文版20170701
- 您的论坛已完成安装，点此访问
- 2001-2017ComsenzInc.
- 曾老湿
- DriverZeng
<!-- OCR_END -->

<!-- OCR_START -->
- 发表帖子-默认版块-Discuz!B×
- >C☆
- 域名重定向不安全|discuz.drz.com/forum.php?mod=post&action=newthread&fid=2
- 20
- 点击这里导入收藏。开始
- 设为首页收藏本站
- 社区动力
- admin在线我的|设置|消息|提醒模块管理管理中心|退出
- DISCUZ!
- 积分：21
- 用户组：管理员
- 论坛
- 快捷导航
- 请输入搜索内容
- 站子
- 热搜：活动交友discuz
- ）论坛）Discuz！）默认版块）发表帖子
- 发表帖子
- 发起投票
- 曾老湿discuz
- 还可输入68个字符
- Tahoma
- 2
- IUA
- 全屏高级
- 啊啊啊啊啊啊啊啊啊
- 20秒后保存保存数据|恢复数据字数检查|清除内容加大编辑框|缩小编辑框
- 附加选项
- 阅读权限
- 回帖奖励
- 抢楼主题
- 主题售价
- 主题标签
<!-- OCR_END -->

<!-- OCR_START -->
- 曾老湿discuz-默认版块-Disc
- 域名重定向
- 不安全
- discuz.drz.com/forum.php?mod=viewthread&tid=1&extra
- 301
- 点击这里导入收藏。开始
- 设为首页收藏本站
- XODIY
- 社区动力
- admin在线|我的|设置|消息|提醒|模块管理|管理中心|退出
- DISCUZ!
- 积分：2
- 用户组：管理员
- 论坛
- 快捷导航
- 请输入搜索内容
- 站子
- 热搜：活动交友discuz
- 》论坛》Discuz!）默认版块）曾老湿discuz
- 发帖
- 回复
- 《返回列表
- 删除主题|升降|置顶|直播|高亮|精华|图章|图标|关闭|移动|分类|复制|合并|分割|修复|警告|屏蔽|标签
- 查看：0回复：0
- 曾老湿discuz[复制链接]
- admin
- 发表于刚刚|只看该作者
- 楼主电梯直达
- 啊啊啊响啊啊啊啊啊
- 2
- 主题
- 帖子
- 积分
- 管理员
- 收藏
- IP编辑禁止帖子清理
- Dri曾e老湿ng
<!-- OCR_END -->

<!-- OCR_START -->
- admin-Discuz!Board-Powered
- Discuz!Board管理中心-全局
- 域名重定向不安全|discuz.drz.com/adn
- 2
- 点击这里导入收藏。开始
- Discuz!
- 界面内容用户门户论坛群组防灌水运营应用工具站长UCenter
- 您好，admin[退出]
- 站点首页
- 首页
- Control Panel
- 全局》SEO设置[+]
- 搜索MAP+
- 站点信息
- SEO设置
- URL静态化
- 门户
- 论坛
- 家园群组其他
- 注册与访问控制
- 站点功能
- ·以红色虚线标示的选项，表示该选项和系统效率、负载能力与资源消耗有关（提高效率、或降低效率），建议依据自身服务器情况进行调整。
- 性能优化
- 查看当前的Rewrite规则
- 域名设置
- URL静态化可以提高搜索引擎抓取，开启本功能需要对Web服务器增加相应的Rewrite支持，且会轻微增加服务器负担。同时您还可以调整每个页面的静态格式，但不得删除其中的标记，重置静态格式请留空。注意，修改静态格式后您需要修改服务器的Re
- 广播设置
- write规则设置
- 空间设置
- 页面
- 标记
- 格式
- 可用
- 用户权限
- 门户专题页
- (name)
- topic-{name].html
- 积分设置
- 时间设置
- 门户文章页
- (id,(page)
- article-(id}-(page).html
- 上传设置
- 论坛主题列表页
- (fid), (page)
- forum-{fid}-{(page).html
- 水印设置
- 论坛主题内容页
- (tid,(page),(prevpage)
- thread-(tid)-(page}-{prevpage).html
- 附件类型尺寸
- 群组主题列表页
- 搜索设置
- [group-(fid}-(page).html
- 地区设置
- 用户个人主页
- {user},{value}
- space-{user}-{value].html
- 排行榜设置
- 用户日志内容页
- {uid),{blogid)
- blog-{uid})-(blogid}.html
- 手机版访问设置
- 论坛Archiver页
- {action},{value}
- [action}-{value}.html
- 防采集设置
- 插件
- {pluginid),{module)
- {pluginid}-{module].html
- Rewrite兼容性：
- ○是
- 如果您的服务器不支持Rewrite规则中的中文字符，请选择“是”。对于没有此问题的服务器，可以选择“否”
- 仅对游客有效：
- 是否
- 开启此项，则Rewrite功能只对游客和搜索引擎有效，可减轻服务器负担
- Powered byDiscuz!X3.3
- 提交
- 曾老湿o01-2017,ComsenzInc.
<!-- OCR_END -->

<!-- OCR_START -->
admin-Discuz!Board-Powered
Discuz！Board管理中心-全局-S
C☆
域名重定向
200
点击这里导入收藏。开始
</rule>
</rules>
</rewrite>
ZeusWebServer
match uRLintoSwith^（.*)/topic-（.+）\.html\?*（.*）s
if matched then
set URL=$1/portal.php?mod=topic&topic=S2&s3
endif
matchuRLinto swith^（.*)/article-（[0-9]+)-（[0-9]+）\.html\?*（.*)s
set URL=$1/portal.php?mod=view&aid=$2&page=$3&$4
match uRLinto $with^（.*)/forum-(\w+）-（[0-9]+）\.html\?*（.*）$
set URL= $1/forum.php?mod=forumdisplay&fid=$2&page=S3&$4
match URLinto$with^（.*)/thread-（[0-9]+）-([0-9]+)-（[0-9]+)\.htm1\?*（.*）)s
set URL=$1/forum.php?mod=viewthread&tid=$2&extra=page\83D$4&page=S3&$5
match URLinto$with^（.*)/group-（[0-9]+)-([0-9}+)\.htm1\?*（.*）$
set URL=S1/forum.php?mod=group&fid=s2&page=$3&$4
match URLinto$with^（.*)/space-（username|uid)-（.+)\.html\?*（.*）s
matchURLintoswith^（.*)/blog-（[0-9]+)-（[0-9）+)\.htm1\？*（.*）s
set URL= $1/home.php?mod=space&uid=$2&do=blogsid=s3&$4
match uRLinto$with^(.*)/（fid|tid）-（[0-9]+)\.htm1\?*（.*)s
set URL=$1/archiver/index.php?action=$26value=S3&$4
NginxWebServer
rewrite~（(^\.]*)/topic-（.+)\.htmls $1/portal.php?mod=topic&topic=s2 1ast;
ace-（username|uid)-().htmlsms1/home.me.?modmsdace
((*\.]*)/（fid|tid)-([0-9）+)\.htmls $1/archiver/index.php?action=$2&value=S3 1ast;
if（1-es
$request_filename）(
return 404;
曾老湿
<!-- OCR_END -->

```bash
server {
        listen 80;
        server_name discuz.drz.com;
        location / {
                root /code/discuz/upload;
                index index.php index.html;
                rewrite ^([^\.]*)/topic-(.+)\.html$ $1/portal.php?mod=topic&topic=$2 last;
                rewrite ^([^\.]*)/article-([0-9]+)-([0-9]+)\.html$ $1/portal.php?mod=view&aid=$2&page=$3 last;
                rewrite ^([^\.]*)/forum-(\w+)-([0-9]+)\.html$ $1/forum.php?mod=forumdisplay&fid=$2&page=$3 last;
                rewrite ^([^\.]*)/thread-([0-9]+)-([0-9]+)-([0-9]+)\.html$ $1/forum.php?mod=viewthread&tid=$2&extra=page%3D$4&page=$3 last;
                rewrite ^([^\.]*)/group-([0-9]+)-([0-9]+)\.html$ $1/forum.php?mod=group&fid=$2&page=$3 last;
                rewrite ^([^\.]*)/space-(username|uid)-(.+)\.html$ $1/home.php?mod=space&$2=$3 last;
                rewrite ^([^\.]*)/blog-([0-9]+)-([0-9]+)\.html$ $1/home.php?mod=space&uid=$2&do=blog&id=$3 last;
                rewrite ^([^\.]*)/(fid|tid)-([0-9]+)\.html$ $1/archiver/index.php?action=$2&value=$3 last;
                if (!-e $request_filename) {
                    return 404;
                }
        }
        location ~ \.php$ {
                root /code/discuz/upload;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }
}
```

<!-- OCR_START -->
- 曾老湿discuz-默认版块-Disc×
- Discuz!Board管理中心-全局-SE
- discuz.drz.com/admin.php?action
- C☆
- 域名重定向不安全
- discuz.drz.com/thread-1-1-1.html
- 200
- 点击这里导入收藏。开始
- 设为首页收藏本站
- XODY
- 社区动力
- admin在线我的|设置|消息|提醒|模块管理管理中心|退出
- DISCUZ!
- 积分：2
- 用户组：管理员
- 论坛
- 快捷导航
- 请输入搜索内容
- 帖子
- 热搜：活动交友discuz
- ）论坛》Discuz!》默认版块》曾老湿discuz
- 返回列表
- 删除主题|升降|置顶|直播|高亮|精华|图章|图标|关闭|移动|分类|复制|合并|分割|修复|警告|屏蔽|标签
- 查看：1回复：0
- 曾老湿discuz[复制链接]
- admin
- 发表于8分钟前只看该作者
- 楼主电梯直达
- 啊啊啊啊啊啊啊啊啊
- 1
- 2
- 管理员
- ee★
- 收藏
- 积分
- IP编辑禁止帖子清理
- 回复
- 编轴
- 发帖
- 曾老湿
<!-- OCR_END -->

## Rewrite规则补充

| Rewrite匹配优先级 |
| --- |

1.先执行server块的rewrite指令

2.其次执行location匹配规则

3.最后执行location中的rewrite

***

| Rewrite与Nginx全局变量 |
| --- |

Rewrite在匹配过程中，会用到一些Nginx全局变量

```bash
$server_name    #当前用户请求的域名
server {
        listen 80;
        server_name test.drz.com;
        rewrite ^(.*)$ https://$server_name$1;
}
```

```bash
$request_filename 请求的文件路径名（带网站的主目录/code/images/test.jpg）
$request_uri 当前请求的文件路径（不带网站的主目录/inages/test.jpg）
#大多数用于http协议转gttps协议
server {
        listen 80;
        server_name php.drz.com;
        return 302 https://$server_name$request_uri;
}
```

```bash
$scheme 用的协议，比如http或者https
```

***

| 如何更加规范的书写Rewrite规则 |
| --- |

```bash
server {
        listen 80;
        server_name www.drz.com drz.com;
        if ($http_host = drz.com){
            rewrite (.*) http://www.drz.com$1;
        }
}

#推荐书写格式
server {
        listen 80;
        server_name drz.com;
        rewrite ^ http://www.drz.com$request_uri;
}
server {
        listen 80;
        server_name www.drz.com;
}
```

> 更新: 2024-09-23 23:36:06  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/wyz2q4>