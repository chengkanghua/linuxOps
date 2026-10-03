# DBA数据库管理员

<!-- OCR_START -->
- Mysal
- Python
- Redis
- Mongodb
<!-- OCR_END -->

毋庸置疑，所有互联网网站最大的瓶颈就是企业的后端数据库，而MySQL更是重中之重，谁掌握了数据库技术，谁就能轻松拿到高薪，并且数据库管理岗位比其他岗位更受企业重视，因为数据安全是企业最重要的生命线，没有之一。

并且数据库又分为很多种，包括关系型数据库，缓存数据库，我们重点学习的是企业里最常用的

+ mysql，mariadb
+ redis

于超老师会带着大家，从一个不会写SQL的小白，成为一名专业的数据库管理员，学习到如下知识

+ 数据库基础，mysql单、多实例安装实践
+ mysql重点SQL语句、数据库增删改查CURD
+ 数据库备份、恢复
+ 数据库日志、字符集、引擎原理
+ mysql数据复制、主从复制架构、GTID同步
+ mysql数据库集群高可用、MHA架构、读写分离、中间件
+ 阿里云RDS实战

# 数据库基础知识
## 什么是数据?
数据就是数值，也就是我们通过观察、实验或计算得出的结果。

数据有很多种，最简单的就是数字。

数据也可以是文字、图像、声音等。

我们打游戏最怕什么？最怕被盗号，怕自己的账号，密码丢失。

打游戏时候，腾讯为了保护大家的账号安全，提供了密保卡，进行坐标验证登录。

<!-- OCR_START -->
- DNF
- 网站
- 8手
- 杏城充值
- 游戏论坛
- bwakobdao.com
- 客服服务
- 重庆2区3月25日火热开启
- 密保卡输入
- @Q更码保护毛
- 行停公告
- 12345678
- 机维护公告
- 八BTOEEGH
- 你的账号己经#定了如码保
- 每好了吗？
- 火热报
- 扩卡必须入其相应顾色位置
- 标赛报名开始
- 的非定数字后才面登录游戏
- 停机公告
- 新手训练攀地
- 我要点亮图标
- DNFTBAIENGBASE
- 充值点券开通
- 动官方论坛
- 确认
- X取消
- QQ号码
- 26244
- 选择服务器
- QQ密码
- XXRAXAXAA
- 进入游戏
- 已类并同意《下城与再士》
- 游戏协识和玩家各例
- 抵制不良游装，拒绝坚单許戏，注套自我保护，谨防提骗上当
- 深州市医讯算机买统有限公司互动头系统
- SAMSING
<!-- OCR_END -->

于超老师曾经也是一个DNF玩家。。登录的账号，密码，即为数据，那么dnf这么大的游戏平台，N多的账号密码要进行存储，就定有数据库仓库，称为数据库。

## 数据存储
很早很早以前，古人是这么存数据的

<!-- OCR_START -->
- 结绳记事
- 契刻记事
- 契刻的
- 目的主要是
- 用来记录数
- 目。主要用
- 来作债务的
- 凭证。
<!-- OCR_END -->

结绳、契刻、结珠、石头替代法等等，如今纸张是人们广泛使用的信息载体。但是书籍不便于查询、共享、储藏等缺点。

随着计算机的发展，人们将信息转化为二进制数字，存储在磁性存储介质中，也就是磁盘进行数据记录。数据通过文件系统管理，以文件形式显示出来。

但是大量的文件数据，查询内容，还是很不方便。

在这个背景下，一个专门用于数据管理的工具诞生了，它能让我们更简单的管理数据。

<!-- OCR_START -->
- v2-0e3c8...8a2ea_r.jpg
- v2-1bad3...74d6_r.jpg
- v2-1c477...b405_r.jpg
- v2-1fadaa...ae91b_r.jpg
- v2-1fcee1..cef88_r.jpg
- v2-2a9f5a...50a4_r.jpg
- v2-2b3ab...7d81e_r.jpg
- v2-2b4d4...0dcb4_r.jpg
- v2-2b8f56...3dc5_r.jpg
- v2-2e6d8...e84db_r.jpg
- v2-2f25ac...93b7_r.jpg
- v2-2fc325...0110_r.jpg
- v2-4bae6c9e063d68d2f9d
- v2-2fd370...0e9e_r.jpg
- b18a992385294_r.jpg
- v2-4a63e...7850r.ina
<!-- OCR_END -->

## 什么是数据库
顾名思义，数据库(DB，database)按照数据结构来组织、存储和管理数据的“仓库”，是一个文件或者一组文件。

表是数据库中存储数据的基本单位，数据按照分类存储在不同的表中，便于查询。

数据库可以通过统一的一些指令对数据进行增、删、改、查（Create，Retrive，Updata，Delete）等操作。

例如财务人员使用Excel统计公司资产信息，进行管理，计算账户，Excel是微软推出的一款电子表格软件，提供计算和图标展示。

<!-- OCR_START -->
- AutoSave
- MonthlyBudget.xisx-LastSaved12/1/20182:30PM
- File
- Home
- Insert
- Draw
- Page Layout
- Formulas
- Data
- Review
- View
- Add-ins
- Help
- PowerPivot
- O Search
- Cut
- Calibri
- 11
- AA
- bwrapText
- General
- 自Copy
- Paste
- BIU
- 田·
- 回Merge&Center
- Conditional
- Formatas
- Cell
- InsertD
- FormatPainter
- Formatting
- Table
- Styles
- Clipboard
- Font
- Alignment
- Number
- fx
- psoExpenses
- Categories
- Other
- 7%
- $50.000
- 2:30PM
- 100%
- $45,000
- $40,000
- 5
- Rentand
- Utilities
- $35,000
- 37%
- $30,000
- Trave
- $25,000
- 3%
- $20.000
- $15,000
- lancer
- $10.000
- 14%
- S5,000
- Marketing
- Equipment
- S-
- 9%
- 2009
- 2010
- 2011
- 2012
- 2013
- 2014
- Total
- Trend
- Utilies
- 18,840
- 17,628S
- 16,368S
- 1,885
- 19,020$
- 17,760S
- 91,501
- 3,000S
- 3,9725
- 3,588
- 4,025
- 3,875$
- 3,7565
- 22,216
- 5,556
- 5,424
- 5,784s
- 5.883
- 5,892
- 5,304
- 33,843
- 5,604
- 5,700
- 5,438
- 5,844
- 6,324
- 34,466
- 1,476
- 1,104
- 696
- 1,595
- 492
- 1,260
- 6,623
- 1.10
- 6,168
- 6,672S
- 6,7325
- 7,032
- 6,504S
- 6,804
- 39,912
- 2724
- 2,460
- 3,720
- 2,847
- 2,556
- 2,568
- 16,875
- 43,104S
- 43,080S
- 42,588$
- 28,705
- 44,183$
- 43,776
- 245,436
<!-- OCR_END -->

例如工资计算

<!-- OCR_START -->
| A | A | A | A | A | 排名 |
| --- | --- | --- | --- | --- | --- |
| F | G | 其他 | 1 | 姓名 | 岗位 |
| 基本工资 | 合计 | 加班 | 出差补助 | 提成 | 2 |
| 3 | 张雨 | 财务经理 | 5,000 | 500 | 5,500 |
| 4 | 刘欣 | 会计 | 3,000 | 200 | 600 |
| 3,800 | 吴梦 | 5 | 会计 | 3,000 | 1,000 |
| 4,000 | 6 | 于心飞 | 销售经理 | 6,000 | 600 |
| 6,600 | 7 | 张玉蝶 | 销售总监 | 8,000 | 800 |
| 8,800 | 8 | 李宁 | 总经理 | 15,000 | 890 |
<!-- OCR_END -->

Excel很强大，但是对于企业来说，业务需求庞大，用Excel可能会有成千上万张，并且存储管理很麻烦，员工和客户想要实时知道企业数据，不可能把一个巨大无比的Excel发送给用户。

因此数据库软件应运而生。

## DBMS
Database Management System，数据库管理系统

数据库管理系统这一软件用于创建和操作数据库。

主流数据库软件，如Mysql(免费)，Oracle(收费，甲骨文公司)，Microsoft SQL Server、SQLite（轻型）等。

mysql主要用于大型门户，例如搜狗、新浪等，它主要的优势就是开放源代码，因为开放源代码这个数据库是免费的，他现在是甲骨文公司的产品。

oracle主要用于银行、铁路、飞机场等。该数据库功能强大，软件费用高。也是甲骨文公司的产品.

sql server是微软公司的产品，主要应用于大中型企业，如联想、方正等。

<!-- OCR_START -->
- ORACLE
- MySQL
- SQL
- ite
<!-- OCR_END -->

数据库，简而言之就是有组织的存储数据的一个仓库（本质就是文件信息管理）。

如同冰箱存储食物，衣柜存放衣物。超哥每天登陆QQ，微信，查询支付宝余额，银行卡余额，都是软件去读取查找数据库记录。

超哥日常生活，一直一直在使用数据库管理软件，譬如电话簿里找名字，百度搜索"如何变有钱"也是在用数据库。

## 数据库基础知识
首先mysql前面超哥已经多少带着大家接触过，安装过、使用过，大家心中有一个基础的认识

### 运维和数据库
说白了，数据库就是存数据的，是一款软件，用专门的数据库语言，增删改查数据。

这就好比超哥平时对电脑里的数据管理

+ 多个文件夹，分类管理
+ 文件夹里的文件，数据，照片，视频，游戏

超哥在公司里，和开发对接，对数据进行管理

数据库的形式

+ 自己再linux上，直接安装，例如上图，数据都在linux机器磁盘上，运维自己管理
+ 云服务器RDS产品(数据库安装在阿里巴巴的服务器上，我们通过账号密码，远程使用)

<!-- OCR_START -->
- Q口
- rdsnext.console.aliyun.com/rdsList/cn-beijing/basic
- 阿里云
- 账号全部资源华北2（北京）▼
- Q搜索文档、控制台、API、解决方案和资源
- 费用
- 工单
- 备案企业
- 支持
- App
- 简体
- 云数据库RDS
- 云数据库RDS/实例列表
- ?RDS简介
- 实例列表
- NEW
- 概览
- 登录数据库
- 数据导入
- 待处理事件
- 性能大盘
- 基本信息
- 标签信息
- 高性能版
- 自定义列表项
- 跨地域备份
- 创建实例
- 实例ID/名称
- 请输入内容
- 请选择标签
- 已删除实例备份
- 运行状态
- 创建时间
- 实例类型
- 数据库类型
- 付费类型
- 网络类型
- 可用区
- 标签
- 操作
- 回收站 (0)
- 包月224天后到期
- rm-2ze90
- 1
- √运行中
- 2017年9月22日
- 常规实例
- MySQL5.6
- +添加标
- 管理|性能
- 线上
- 11:29:04
- 续费
- 33v
- 更多▼
- 转按量付费
- 历史事件
- 共有余
- 参数模板
- 专属集群NEW
- 低成本历史库
- 一键构建数据仓库
- 数据库专家服务
<!-- OCR_END -->

开发、运维小于、数据库

<!-- OCR_START -->
- 开发DBA
- 运维DBA
- MySQL 和 PHP
- 初级
- MySQL 基础
- 客户端程序开发
- 安装、搭建
- 中级
- MySQL 开发者
- MySQL 数据库
- 基本SQL开发
- 管理员
- 高级
- MySQL
- 高级存储过程、
- 函数
- 高级开发、基于业务的
- 性能调节
- Cluster
- 高可用性
- SQL改写、调优
<!-- OCR_END -->

## 数据库在工作里怎么用
数据库和网站

<!-- OCR_START -->
- 路飞学城－帮助有志向的年轻人迮×
- luffycity.com/actual-course?category_id=1
- Pythonasyncio高性能异步编程
- 81343人已加入学习
- Python Asyncio
- 武Sir银角大王前汽车之家好大夫资深工程师
- 共18课时/更新完成
- 高性能异步编程
- 01|协程免费
- 02|课程介绍免费
- Wusir-银角大王
- o3|asyncio异步编程：concurren...
- 04|asyncio事件循环
- 前汽车之家架构师
- 限时折扣
- ￥39.00元
- 原价：70.90元
- 立即购买
- 基于Django开发轻量级Bug管理平台
- 82614人已加入学习
- 基于Django开发轻量级
- 共250课时/更新完成
- Bug管理平台
- 01|day01-sass项目演示
- 免费
- 02|day01-阶段项目涉及知识点免费
- 03|day01-项目讲解和学习提醒免费
- 04|day01-sass项目介绍免费
- 高级DevOps工程师
- ￥69.65元
- 原价：199.00元
- Python+微信小程序开发实战
- 81730人已加入学习
- Python+微信小程序开发
- 共201课时/更新完成
- 实战之《拍卖平台》
- 01|day1-全局配置
- 02|day1-小程序介绍免费
- 03|day1-flex布局
- 04|day1-小程序环境搭建
- ￥79.00元
- 原价：202.56元
<!-- OCR_END -->

例如这个网站里的数据，就是通过前端+后端的代码，然后从数据库中读取出来的，这就好比之前超哥讲的lnmp架构。

简单地说，数据库（Database）就是一个存放计算机数据的仓库，该仓库按照一定的数据结构（数据结构是指数据的组织形式或数据之间的联系）对数据进行组织和存储，我们可以通过数据库提供的多种方法来管理其中的数据。



<!-- OCR_START -->
> 存储数据
> 管理数据
<!-- OCR_END -->



若以生活中的案例来进行更形象的描述，那么计算机里的数据库就是类似于人们存放杂物的储物间和仓库，它们的区别只是存放的东西不同，杂物间存放的是实体物件，而数据库里存储的是计算机数据。

## 数据库类别
目前主流数据库软件，分为两种

+ 关系型数据库
+ 非关系型数据库

为何出现这2种类型数据库

+ web1.0时代，互联网发展慢，基本只是企业提供网站，用户浏览资料，上网的人还少，互联网还没那么多复杂的功能，网站压力很轻，因此mysql轻松干活
+ 随着互联网Web2.0、Web3.0网站的兴起，传统的关系型数据库在应付这些网站，特别是对于规模日益扩大的海量数据，超大规模和高并发的微博、微信等类型的动态网站时已经显得力不从心，暴露了很多难以克服的问题，例如，传统关系型数据库的I/O瓶颈、性能瓶颈等都难以有效突破。于是出现了大批针对特定场景，以高性能、高并发以及使用便利为目的的功能特异化的数据库产品
+ NoSQL出现，专注于解决高并发场景，大流量的场景，解决部分数据存读写的性能问题
+ 非关系型数据库就是在这样的情景中诞生并得到非常迅速发展的。在这些特定的场景下，NoSQL数据库可以发挥出难以想象的高效率和高性能。近年来，NoSQL这个术语得到了广泛认同。

<!-- OCR_START -->
- 概念理解：类似常见的表格，通过存储格式直观反映实体之间的联系
- 核心特点
- 事务的一致性（ACID）
- 相关产品
- MySQL、SQLServer、Sqlite、Oracle、DB2
- 容易理解一—二维层面的表结构
- 使用方便—一使用SQL语言操作
- 优点
- 关系型数据库
- 易于维护-
- 一完整性好，数据余和不一致概率低
- 支持SQL-—复杂查询
- 读写性能
- 表结构固定
- 缺点
- 高并发读写性能
- 海量数据无法高效读写
- 关系型数据库与非关系型数据库
- 概念
- Non-relational，不是关系型的数据库。
- 键值对存储（Key->Value）
- 列存储数据库
- 分类
- 文档性数据库
- 图形数据库
- 分布式
- 非关系型数据库
- 一般不支持ACID原则
- 产品
- Redis、MongDB、Hbase等
- 读写性能高、支持海量数据存储访问
- 数据没有耦合，易于扩展，可用性高
- 支持存储格式多样：图片、音视频等
- 不提供SQL支持
- 无事务处理
<!-- OCR_END -->

--

NoSQL是非关系型数据库的广义定义。它打破了长久以来关系型数据库与ACID理论大一统的局面。NoSQL数据库的数据存储不需要固定的表结构，通常也不存在连接操作。

其在大数据存取上具备关系型数据库无法比拟的性能优势，满足了企业应用需要将数据存储在横向且伸缩性上更强的功能需求。例如，Google的BigTable、Amazon的Dynamo都是非常成功的商业NoSQL实现。

在开源的NoSQL体系中，从早期的Memcached缓存软件到当今Facebook的Cassandra、Apache的HBase，都得到了广泛应用，redis、MongoDB等新兴的NoSQL数据库，也逐渐受到各类公司的欢迎和追捧。

NoSQL数据库没有标准的查询语言（SQL），因此进行数据库查询需要制定数据模型。许多NoSQL数据库都有REST式的数据接口或者查询API。

我们会先学习关系型数据库，mysql

之后再学习redis、非关系型数据库

## 关系型数据库
关系型数据库模型可将复杂的数据结构归结为简单的二元关系（即二维表格形式）

数据库的操作建立在一个、或者多个关系表格上，通过对这些表格进行分类、合并、连接等查询方式，来找到我们想要的数据。

最常见的数据库里是MySQL和Oracle。

来看一个生产环境下的数据库，以及数据表是什么样

<!-- OCR_START -->
NavicatPremium
fx)
Eoo
连接
新建查询
查看
函数
事件
用户
查询
备份
自动运行
模型
luffy_dev
对象
web_course@luffy_dev (.
田表
自、Y
auth_group_permissions
id
name
course_img
cbrief
auth_permission
1计算机原理与Linux基础入门
/media/frontend/public_class/Linux_1564729052.3445866.jpeg
0本课程将首先讲解计算件发展史、各硬件作用及实现原理、操作系统发展
田crm_couponapplicationr
2CRM客户关系管理系统实战开发
/media/frontend/public_class/CRM_1564729051.4933968.jpeg
0本项目将带你从0开始开发一个客户关系管理系统，又名CRM，支持多角色
crm_customerfllowupr.
3 Django入门与实践
/media/frontend/public_class/Django_1564729052.6937408.jpeg
0Django是Python语言中最流行、最强大的WEB框架，可快速构建稳定强
田 crm_pipeline
4 Mysql数据库从入门至进阶
/media/frontend/public_class/MySQL_1564729051.2508833.jpeg
0数据库是软件开发中极为重要的组件之一，软件中各种重要业务数据都会
5Python开发21天入门
/media/frontend/public_class/21_1564729054.7062445.jpeg
crm_pipelinechannel
0Python以其简洁、优雅、高效的特点，成为目前最流行的4大主流开发语
6BBS论坛&Web聊天室项目开发
/media/frontend/public_class/BBS_1564729051.6931577.jpeg
0随着网速的快速提高及H5的普及，越来越多的对延时要求比较苛刻的应用
django_admin_log
7金融量化分析入门
/media/frontend/public_class/金融_1564729054.4772513.jpeg
0量化投资是金融投资领域比较重要的投资手段，在海外的发展已有多年历
django_celery_beat_clo.
8Web开发入门
/media/frontend/course/8/Web开发入门_1528696693.7417865.jpeg
0HTML/CSS/JavaScript是WEB开发中必备的基础知识，假如把WEB开发
9爬虫从入门到进阶
/media/frontend/public_class/爬虫_1564729051.895241.jpeg
0信息时代，数据为王，互联网包含了迄今为止最有用的数据集，并且大部
django_celery_beat _inte.
10从零开始学算法&数据结构
/media/frontend/course/10/列表图@3x_1567150578.2325735.png
0算法是计算机的灵魂所在，是计算机学科的巅峰艺术，我们平日所聊的大
django_celery_beat_peri
11网络编程入门&FTP服务开发实战
/media/frontend/public_class/ftp_1564729052.543456.jpeg
0TCP/IP协议是目前互联网各种应用协议的基石，我们平日里用的微信、Q
12 Linux系统基础5周入门精讲
0Linux世界上使用最多的系统之一，这位幕后英雄支持着各大网站的运行。
django_celery_beat_sol..
13 第一模块：开发基础（I日)
/media/frontend/course/13/500114377_wx_1509540734.6380699.jpeg
2一、Python语言介绍、环境安装、基本语法、基本数据类型、二进制运算
djiango_content_type
14第二模块：函数编程（I旧）
/media/frontend/course/14/500113666_banner_1509541030.2613344.png
2一、函数、内置方法、递归、选代器、装饰器、内置方法、员工信息表开
15第三模块：面向对象&网络编程基础
/media/frontend/course/15/500002820_1509603846.6141765.jpeg
2一、面向对象介绍、特性、成员变量、方法、封装、继承、多态、类的生
djiango_kingadmin_log
16第四模块：网络编程进阶&数据库开发
/media/frontend/course/16/500114380_1509603890.423229.jpeg
2一、操作系统工作原理介绍、线程、进程演化史、特点、区别、互斥锁、
django_migrations
<!-- OCR_END -->

理解数据表的概念

<!-- OCR_START -->
| 学生表 | 学生表 | 排名 | 学生表 | 学生表 | 排名(上年) |
| --- | --- | --- | --- | --- | --- |
| 课程名 | 价格 | 学号 | 课程号 | 成绩 | 1 |
| 超哥 | 18 | 1 | linux云计算 | 9600 | 1 |
| 2 | 80 | 2 | 武沛奇 | 29 | 2 |
| python全栈开发 | 12800 | 2 | 96 | 3alex | 35 |
<!-- OCR_END -->

## 图解
大家可以这么去理解

+ 数据库-----文件夹----文件夹名字（luffy_dev）
+ 数据库里的数据表-----文件夹里的table数据表-----数据表的名字
+ 数据表里的数据------文件中的数据-----例如一个excel里的数据

那么大家应该理解，最核心的就是数据表的理解

数据库里的表格，是由多干个列组成，每一列存储不同的信息。

数据表概念

+ 列，是表中的字段，所有的表，都由一个、多个列组成
<!-- OCR_START -->
| 表名 | 排名 | 表名 | 表名 | 表名 | 表名 |
| --- | --- | --- | --- | --- | --- |
| 学生表 | 课程表 | 学生选课表 | 字段学号int(10) | 姓名varchar(20) | 年龄tinyint(12) |
| 课程号 | 课程名 | 价格 | 学号 | 课程号 | 成绩 |
| 1超哥 | 18 | 行记录 | 1 | linux云计算 | 9600 |
| 1 | 2 | 80 | 2武沛奇 | 29 | 2python全栈开发 |
| 12800 | 2 | 1 | 96 | 3alex | 35 |
<!-- OCR_END -->

- 每一列（字段）都有对应的数据类型，且只能写入对应数据类型的内容，例如数字、文本、日期等（后面介绍）
- 由此我们就可以理解数据类型的概念了，数据类型用于定义每个列需要存储什么样的数据，每个列都可以根据存储数据的实际需要来设置数据类型，在指定数据类型的同时还可以指定存储数据的长度。

## 表
我们存放一件衣服，不会直接塞进柜子，一般都是有条有理的放在某一个格子中。

存放文件也是放入文件柜中，整整齐齐便于管理。

那在数据库领域中，文件被称为是表。表是一种结构化的文件，用于特定类型的数据。表可以存人员信息，商品信息，或者其他等等资料。

![1671612511289-25e1e866-e62e-4225-8981-87128c9063a5.png](img/DBA数据库管理员/image17.png)

## 列
列存储表某一部分的信息。

列是表中的一个字段列。

所有表都是一个或多个列组成。

数据库中每个列都有对应的数据类型，如订单数是数值类型，日期、地址、介绍等英国是字符串类型。

数据类型帮助正确的排序数据。

## 行
表的数据按行存储，每条记录存储在自己的一行中。

也有人称作行(row)叫做数据库记录，最正确则是 行。

## 主键
这个键、在我们对数据表具体学习的时候，再去了解

每一行数据都应该有自己的一列唯一标识。

+ 如学生名单的编号排列。
+ 如订单表的订单ID号。

主键(primary key)一列(或一组列)，主键的值用于区分表中每一行。

表中的任意一列都可以作为主键，只需要保证：

+ 1.任意两行都不具有相同的主键值
+ 2.每个行都必须有一个主键值，不允许NULL值。

使用主键的技巧：

+ 不更新主键列的值
+ 不重用主键列的值
+ 不在主键中使用可能会修改的值

## 外键
外键是表中某一列，它的值是另一张表的主键值，定义两个表之间的关系。

比如我们有工资表、员工表，那这工资表中肯定是一行行记录，对应了超哥的工资条呗。

## SQL
SQL是结构化查询语言的缩写，读作S-Q-L或者sequel，全称是(Structured Query Language)，是一种专门用来与数据库交流的语言。

SQL语法主要是

+ 查询语言：select
+ 操作语言：insert、update、delete
+ 事务处理：begin transaction、commit、rollback
+ 权限控制：grant、revoke
+ 数据库管理：create、drop

以上语法不区分大小写

## MySQL/MariaDB
MySQL是一个开源的中小型关系型数据库管理系统，被应用于大、中、小型网站。由于其具有体积小、速度快、总体拥有成本低，且开放源码等特点，因此许多大中小型网站选择它作为网站数据库，从而降低网站总体拥有成本，甚至国内知名的淘宝网也选择弃用Oracle而更换成更为开放的MySQL。

MySQL数据库的应用范围主要包括互联网领域、大中小型网站、游戏公司、电商平台等，因用户广泛，其产生了很多高并发的成熟解决方案，因此传统企业的用户也在逐渐增多。

MariaDB

mariadb是mysql数据库的一个分支，主要由开源社区维护，采用GPL授权许可。

开发这个MariaDB数据库分支的可能原因之一是：Oracle公司收购了MySQL之后，有将MySQL闭源的潜在风险，因此MySQL开源社区采用分支的方式来避开这个风险。

开发 MariaDB 的目的是**完全兼容 MySQL**（包括 API 和命令行），从而轻松成为 MySQL 的替代品；存储引擎方面用 **XtraDB** 取代 MySQL 的 InnoDB。

背景：MariaDB 由 MySQL 创始人 Michael Widenius 主导开发。他此前以 10 亿美元将 MySQL AB 卖给 Sun；后来 Sun 被 Oracle 收购，MySQL 所有权也随之落入 Oracle 手中。为规避这一风险，他另起炉灶开发了 MariaDB——名称取自他女儿 Maria 的名字。

MariaDB基于事务的Maria存储引擎，替换了MySQL的MyISAM存储引擎，使用Percona的XtraDB替换了MySQL的InnoDB存储引擎。

MariaDB数据库的早期版本，均依照MySQL的版本发行。因此，使用MariaDB的人都会从MySQL中了解到MariaDB的相关功能，学习MySQL数据库的人，也可以轻松上手掌握MariaDB数据库。

### 其他关系型数据库
这里大家只需要了解有该数据库即可

+ Microsoft SQL Server
+ Microsoft Access
+ PostgreSQL
+ DB2
+ Sysbase
+ Informix

## 数据库具体应用场景
### 相亲网
譬如网站的注册登录功能，正确流程是，注册成功->可以登录。

工程师就要检测在注册成功后，检查数据库是否正确保留了信息。

如百合网的登录页面：

<!-- OCR_START -->
- 注册
- 登录
- 创建账号缘分速达
- 手机
- 密码
- 已经阅读并同意百合服务条款
- BERCRO
- 免费注册
<!-- OCR_END -->

比如超哥想找个女朋友，果断去注册一个账号。。

以上数据，如果用Excel管理，存储每一条记录如下：

<!-- OCR_START -->
- 姓名
- 年纪
- 身高
- 体重
- 归属地
- 联系电话
- 学历
- 月收入
- 个性签名
- 注册时间
- 五配齐
- 28 180cm
- 70kg
- 河北
- 16666666666本科
- 100000哥只是个传说，谁也别暗恋我
- 2018/5/28
- 鱼吵
- 18 188cm
- 90kg
- 江苏
- 18888888888博士
- 2800我是个好人
- 阿里克斯
- 38 150cm
- 100kg
- 山东
- 19999999999小学生
- 1000000我有钱
<!-- OCR_END -->

如用数据库管理软件(mysql)，如下:

<!-- OCR_START -->
- MariaDB [baihewang]> select * from vip_information;
- id
- 1年纪
- 丨身高
- |体重
- 1归属地
- 1联系电话
- 1学历
- 1月收入
- |个性签名
- 1注册时间
- 1128
- 1180
- 170
- 丨河北
- 14444444444
- 丨本科
- 1000000
- 哥只是个传说，谁也别暗恋我
- 2019/5/5
- 21
- 18
- |185
- 190
- 丨江苏
- 188888888
- |专科
- 2500
- 我是个好人
- 2019/9/5
- 31
- 1170
- 丨山东
- |1333
- |博士
- 1我有钱
- 12010/6/6
- rowsinset(0.o0sec)
- MariaDB [baihewang]>
<!-- OCR_END -->

## 游戏数据库
如下是英雄联盟所有的英雄数据库，列出了所有英雄数据

<!-- OCR_START -->
- 由Xnip截图
- 所有英雄
- 战士
- 法师刺客坦克射手
- 辅助
- 周免费
- 魔法猫咪
- 炼金术士
- 亡灵战神
- 德邦总管
- 众星之子
- 荆棘之兴
- 虚空之女
- 暗夜猎手
- 发条魔灵
- 复仇焰魂
- 虚空行者
- 影流之主
- 翠神
- 恶魔小丑
- 放逐之刃
- 复仇之矛
- 深渊巨口
- 万花通灵
- 生化魔人
- 瓦洛兰之盾
- 诡术妖姬
- 战争之影
- 青钢影
- 无双剑姬
- 刀锋意志
- 黑暗之女
- 冰晶凤凰
- 殇之木乃伊
- 牛头酋长
- 唤潮鲛姬
- 星界游神
- 狂野女猎手
- 法外狂徒
- 扭曲树精
- 圣锤之毅
- 皮城女警
- 赏金猎人
- 海兽祭司
- 暗裔剑魔
- 沙漠皇帝
- 诺克萨斯之手
- 解脱者
- 时间刺客
- 暮光星灵
- 河流之王
- 蛮族之王
- 暗黑元首
- 德玛西亚之翼
- 披甲龙龟
- 雪人骑士
- 永恒梦魔
- 堕落天使
- 圣枪游侠
- 齐天大圣
- 离群之刺
- 荣耀行刑官
- 蒸汽机器人
- 正义巨像
- 无极剑圣
- 虚空掠夺者
- 漂冬之怒
- 深海泰坦
- 惩戒之箭
- 戏命师
- 荒漠屠夫
- 巨魔之王
- 战争之王
- 审判天使
- 冰霜女巫
- 九尾妖狐
- 虚空之眼
- 爆破鬼才
- 祖安怒兽
- 血港鬼影
- 战争女神
- 麦林炮手
- 光辉女郎
- 不祥之刃
- 熔岩巨兽
- 机械公敌
- 魂锁典狱长
- 武器大师
- 虚空恐惧
- 弗雷尔卓德之心
- 琴瑟仙女
- 潮汐海灵
- 皎月女神
- 祖安狂人
- 英勇投弹手
- 探险家
- 龙血武姬
- 盲僧
- 兽灵行者
- 魔蛇之拥
- 死亡颂唱者
- 虚空先知
- 仙灵女巫
- 幻翎
- 寡妇制造者
- 暮光之眼
- 雷霆咆哮
- 逆羽
- 瘟疫之源
- 牧魂人
- 山隐之焰
- 迷失之牙
- 猩红收割者
- 狂暴之心
- 曙光女神
- 影流之镰
- 末日使者
- 沙漠死神
- 暴走萝莉
- 暴怒骑士
- 未来守护者
- 岩雀
- 海洋之灾
- 皮城执法官
- 时光守护者
- 策士统领
- 刀锋之影
- 酒桶
- 无畏战车
- 机械先驱
- 远古巫灵
- 傲之追猎者
- 虚空通地兽
- 风暴之怒
- 天启者
- 卡牌大师
- 蜘蛛女皇
- 邪恶小法师
- 铁铠冥魂
- 水晶先锋
- 德玛西亚皇子
- 铸星龙王
- 大发明家
- 永猎双子
- 狂战士
- 寒冰射手
- 疾风剑豪
- 德玛西亚之力
- 符文法师
- 迅捷斥候
<!-- OCR_END -->

游戏玩法中默认将英雄分为战士、法师、刺客、坦克、射手、辅助几类，对应数据库设计如下：

<!-- OCR_START -->
- MariaDB [baihewang]> show tables;
- Tables_in_baihewang
- 射手
- 战士
- vip_information
- 3 rows in set (0.00 sec)
- MariaDB [baihewang]> select * from 射手;
- id
- 丨名字
- |英雄特色
- 丨价格
- |暗夜猎手
- 1普攻第三下触发真实伤害
- 4800
- 1
- row in set (0.o0 sec)
- id丨名字
- 1|亚索
- 1快乐风男，在线送人头
- 6300
- 1 row in set (0.00 sec)
<!-- OCR_END -->

## 友情提醒
数据库方面知识，主要以运维、开发分为两个方向，不同的方向所重点学习的内容不一样

+ 运维人员，主要是对数据库架构、设计、维护
- 单实例、多实例
- SQL语句基础CURD学习、权限管理
- 字符集、数据库引擎
- 备份方案
- 复制方案
- 高可用方案
+ 开发人员，主要是对数据进行设计、开发
- 针对业务进行数据库设计、表结构设计
- 高性能索引
- 视图
- 存储过程
- 函数
- 等

# MySQL数据库基础实践
## 版本选择
## 企业版
**MySQL 企业版**由 MySQL AB 内部专人开发维护，同时吸纳社区的优秀代码与算法，并严格按测试流程验证后才发布。

简单说：企业版是 MySQL 公司的**盈利产品**，参考了社区版的先进功能与算法，**需付费**才能获得使用权和技术支持；稳定性和可靠性最好，但价格不菲——某知名分类门户网站 2008 年采购 MySQL 企业版花费达数十万元。

## 社区版
MySQL社区版则是由分散在世界各地的MySQL开发者、爱好者以及用户参与开发与测试的，包括软件代码的管理、测试工作，也是他们在负责。社区也会设立BUG汇报机制，收集用户在使用过程中遇到的BUG情况，相比于企业版，社区版的开发及测试环境没有那么严格。

## 选哪个
mysql是成熟产品，企业版和社区版在性能方面区别不大，对于我们学习而言，社区版即可。它们的区别可以如下了解

+ 企业版对代码的管理、测试更严格、稳定性更好
+ 企业版不遵循GPL开源协议，而社区版遵循，可以免费用
+ 企业版可以购买额外的收费服务，如7*24的技术支持，有钱任性。
+ 社区版的安全性，稳定性，无法像企业版有及时的维护、技术支持。

## MySQL特点
支持多种操作系统，Windows、MacOS、Linux等 支持多种语言API，如C、C++、Python、PHP、Java等 支持多线程、充分利用硬件资源 支持多种存储引擎

mysql就是一个基于socket编写的C/S架构的软件

客户端软件 mysql自带：如mysql命令，mysqldump命令等 python模块：如pymysql

## MySQL服务端-客户端
先看下什么是B/S和C/S架构。

B/S是**Browser/Server指浏览器和服务器端，**在客户机不需要装软件，只需要装一个浏览器。

C/S**是Client/Server指客户端和服务器，在客户机端必须装客户端软件及相应环境后，才能访问服务器**

MySQL是基于客户端-服务端的运行模式数据库，服务端负责数据处理，运行在数据库服务器上。

用户通过发送增删改查等请求，发送给客户端软件，然后通过网络提交请求给服务端，服务端接收到请求，再进行处理，然后返回。

服务端、客户端可以在不同的机器上，也可以在一台机器上。

这种服务端，客户端，就在生活里很常见，如打游戏时的登录，QQ、微信的登录，MySQL也是一个登录的过程。

### mysql下载选择
了解数据库后，我们可以下载mysql软件了

[http://mirrors.sohu.com/mysql/](http://mirrors.sohu.com/mysql/)

<!-- OCR_START -->
- Index of /mysql/MySQL-5.6/
- Q口
- A 不安全| mirrors.sohu.com/mysql/MySQL-5.6/
- mysql-5.6.45-solaris11-sparc-64bit.pkg.gz.asc
- 173 B
- 2019-Jun-12 12:03
- 76B
- 2019-Jun-1108:55
- mysql-5.6.45-solaris11-sparc-64bit.tar.gz
- 510.5 MiB
- 2019-Jun-10 08:45
- 2019-Jun-12 12:02
- mysql-5.6.45-solaris11-x86 _64.pkg.gz
- 459.9 MiB
- 2019-Jun-10 08:44
- 71B
- 515.5 MiB
- mysql-5.6.45-solaris11-x86 _64.tar.gz.asc
- mysql-5.6.45-win32.msi
- 32.2 MiB
- 2019-Jun-11 12:05
- mysql-5.6.45-win32.msi.asc
- 2019-Jun-12 12:04
- mysql-5.6.45-win32.msi.md5
- 57B
- 2019-Jun-12 12:01
- mysql-5.6.45-win32.zip
- 331.9 MiB
- 2019-Jun-10 09:08
- mysql-5.6.45-win32.zip.asc
- mysql-5.6.45-win32.zip.md5
- 2019-Jun-1108:58
- mysql-5.6.45-winx64.msi
- 34.0 MiB
- mysql-5.6.45-winx64.msi.asc
- mysql-5.6.45-winx64.msi.md5
- 58B
- mysql-5.6.45-winx64.zip
- 336.3 MiB
- 2019-Jun-10 09:05
- mysql-5.6.45-winx64.zip.asc
- mysql-5.6.45-winx64.zip.md5
- mysql-5.6.45.tar.gz
- 31.0 MiB
- 2019-Jun-10 08:31
- mysql-5.6.45.tar.gz.asc
- mysql-5.6.45.tar.gz.md5
- 54 B
- mysql-5.6.45.zip
- 40.0 MiB
- mysql-5.6.45.zip.asc
- mysql-5.6.45.zip.md5
- 51 B
- mysql-5.6.46-linux-glibc2.12-i686.tar.gz
- 368.2 MiB
- 2019-Sep-27 06:20
- 2019-Sep-29 15:04
- 75 B
- 2019-Sep-29 12:27
<!-- OCR_END -->

软件包解释

```plain
mysql-5.6.45.tar.gz

5 是主版本号
6 是发行级别，主版本号和发行级别组合，构成发行序列号
45 表示在此发行系列的一个版本，随着新版本发布，进行递增

例如
mysql-5.6.46.tar.gz
mysql-5.6.47.tar.gz
每次更新后，最后一个数字会递增
如果功能变化较大，字符串的第二个数字会递增，也就是如 5.7
如果软件格式大改动，第一个数字，主版本号会变化
```

## 生产环境用哪个版本
商业软件研发和发行公司，都会提供经过完整测试，甚至多种用户环境模拟测试及试用之后，才推出的稳定的生产环境版本，这也使得技术人员对于商业数据库软件的选择，一般不需要有太多的顾虑与考虑。

在大公司（像BAT等），对于数据库软件版本的选择，也会有相关人员详细阅读其新功能或改进点知识，并且会做很多相关的研究和测试工作，最后才逐步上线，而且是从边缘业务慢慢过渡到核心业务。

小公司该如何选

<!-- OCR_START -->
- 阿里云
- 账号全部资源→华北2(北京)
- Q搜索文档、控制台、
- 云数据库RDS
- 云数据库RDS／实例列表
- 实例列表
- 概览
- 基本信息
- 标签信息
- 高性能版
- 跨地域备份
- 创建实例
- 实例ID/名称
- 请输入内容
- 请选择标签
- 已删除实例备份
- 运行状态
- 创建时间
- 实例类型
- 数据库类型
- 回收站 (0)
- √运行中
- 2017年9月22日11:29:04
- 常规实例
- MySQL 5.6
- 待处理事件
- 编辑标签
<!-- OCR_END -->

在调研了快手、玩吧、百度、以及部分中小公司，从运维朋友那边得知也使用的是5.6 5.7

<!-- OCR_START -->
- MySQL-4.1/
- MySQL-5.0/
- MySQL-5.1/
- MySQL-5.2/
- MySQL-5.4/
- MySQL-5.5/
- MySQL-5.6/
- MvSQL-5.7/
- MySQL-6.0/
- MySQL-8.0/
<!-- OCR_END -->

## Centos7安装MySQL-5.6
安装方式超哥以前讲过

+ rpm
+ yum
+ 源码编译

## rpm方式
[http://mirrors.sohu.com/mysql/](http://mirrors.sohu.com/mysql/)

同学们可以下载好如下rpm包，谁还能有于超老师的笔记细心？还有谁？

```plain
http://mirrors.sohu.com/mysql/MySQL-5.6/MySQL-client-5.6.40-1.el7.x86_64.rpm
http://mirrors.sohu.com/mysql/MySQL-5.6/MySQL-devel-5.6.40-1.el7.x86_64.rpm
http://mirrors.sohu.com/mysql/MySQL-5.6/MySQL-server-5.6.40-1.el7.x86_64.rpm
http://mirrors.sohu.com/mysql/MySQL-5.6/MySQL-shared-5.6.40-1.el7.x86_64.rpm
```

rpm安装必须要提前准备好官网、第三方源提供好的rpm软件包，且无法满足定制化需求、编译参数、修改路径、依赖冲突问题，所以不建议使用。

## yum安装
这是最方便的，yum自动去源中下载相关rpm包

```plain
[root@mysql-server56 ~]# yum install mariadb-server mariadb

# 部分信息
Dependencies Resolved

=============================================================================================================================================
 Package                               Arch                          Version                               Repository                   Size
=============================================================================================================================================
Installing:
 mariadb                               x86_64                        1:5.5.68-1.el7                        base                        8.8 M
 mariadb-server                        x86_64                        1:5.5.68-1.el7                        base                         11 M
Installing for dependencies:
 mariadb-libs                          x86_64                        1:5.5.68-1.el7                        base                        760 k
 perl-DBD-MySQL                        x86_64                        4.023-6.el7                           base                        140 k
```

yum的有点是超级简单，缺点也是，也如法定制化安装rpm包，且yum源中的软件包版本可能较低，我们也可以修改源来解决。

## CMAKE编译安装
编译命令

+ make 读取makefile里面的指令，编译程序，makefile文件里调用gcc命令去编译源文件
+ cmake命令也是一个编译命令，用于一些跨平台的编译设置

### 编译步骤
编译安装需要下载源码包、可以定制化编译参数，路径等信息，缺点就是对新手不友好。

超哥给的链接版本如下，如果不合适，自行寻找其他版本，修改url即可

```plain
http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.40.tar.gz

# 编译参数如下
tar zxf mysql-5.6.40.tar.gz
cd mysql-5.6.40

cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.6.40 \
-DMYSQL_DATADIR=/application/mysql-5.6.40/data \
-DMYSQL_UNIX_ADDR=/application/mysql-5.6.40/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
-DWITH_ZLIB=bundled \
-DWITH_SSL=bundled \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_EMBEDDED_SERVER=1 \
-DENABLE_DOWNLOADS=1 \
-DWITH_DEBUG=0

#提示，编译时可配置的选项很多，具体可参考本章最后一部分的内容或官方文档。
make
make install
ln -s /application/mysql-5.6.40/   /application/mysql
```

## 开始安装且配置mysql5.6
### 环境准备
+ vmware虚拟机内存建议4G+
+ 安装过程中，注意看是否有error等信息
+ 需要安装好一些编译所需的基础环境
+ 超哥用centos7给大家讲课

```plain
[root@mysql-server56 ~]# cat /etc/redhat-release
CentOS Linux release 7.5.1804 (Core)
[root@mysql-server56 ~]#
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# uname -r
3.10.0-1160.11.1.el7.x86_64
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# uname -m
x86_64
```

### 基础依赖
```plain
# 请大家注意看系统的提示
[root@mysql-server56 ~]# yum install ncurses-devel libaio-devel 

# 检查
[root@mysql-server56 ~]# rpm -qa ncurses-devel libaio-devel
libaio-devel-0.3.109-13.el7.x86_64
ncurses-devel-5.9-14.20130511.el7_4.x86_64
[root@mysql-server56 ~]#
```

  
mysql5.5之后需要用cmake命令编译

```plain
[root@mysql-server56 ~]# yum install cmake -y

[root@mysql-server56 ~]# rpm -qa cmake
cmake-2.8.12.2-2.el7.x86_64
```

创建用户

```plain
[root@mysql-server56 ~]# useradd -s /sbin/nologin -M mysql
[root@mysql-server56 ~]# id mysql
uid=1001(mysql) gid=1001(mysql) groups=1001(mysql)
```

### 下载源码包
```plain
[root@mysql-server56 ~]# cd /home/chaoge/tools/

[root@mysql-server56 tools]# wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.40.tar.gz
```

### 解压-安装mysql
编译参数解释

[https://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html](https://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html)

<!-- OCR_START -->
编译参数
说明
-DCMAKE_INSTALL_PREFIX=/application/mysql-5.6.40
设定mysql安装目录
-DMYSQL_DATADIR=/application/mysql-5.6.40/data
设定mysql数据文件目录
-DMYSQL_UNIX_ADDR=/application/mysql-5.6.40/tmp/
设定mysql.sock路径
mysql.sock
-DDEFAULT_CHARSET=utf8
设定默认的字符集为utf8
-DDEFAULT_COLLATION=utf8_general_ci
设定默认排序规则
-DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii
启用额外的字符集类型
-DENABLED_LOCAL_INFILE=ON
启用本地数据导人支持
-DWITH_INNOBASE_STORAGE_ENGINE=1
若想启用某个引擎的支持：-DWITH
-DWITH_FEDERATED_STORAGE_ENGINE=1
<ENGINE>_STORAGE_ENGINE=1
-DWITH_BLACKHOLE_STORAGE_ENGINE=1
若想禁用某个引擎的支持：-DWITHOUT
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1
<ENGINE>_STORAGE_ENGINE=0
-DWITHOUT_PARTITION_STORAGE_ENGINE=1
<!-- OCR_END -->

---

<!-- OCR_START -->
- （续）
- 编译参数
- 说明
- -DWITH_FAST_MUTEXES=1
- -DWITH_ZLIB=bundled
- 启用libz库支持
- -DENABLED_LOCAL_INFILE=1
- 这个参数重复了，启用本地数据导人支持
- -DWITH_READLINE=1
- 启用readline库支持（提供可编辑的命令行）
- -DWITH_EMBEDDED_SERVER=1
- 编译嵌人式服务器支持
- -DWITH_DEBUG=0
- 禁用debug（默认为禁用）
<!-- OCR_END -->

编译代码  
  

```plain
[root@mysql-server56 tools]# ls
mysql-5.6.40.tar.gz
[root@mysql-server56 tools]# tar xf mysql-5.6.40.tar.gz
[root@mysql-server56 tools]# ls
mysql-5.6.40  mysql-5.6.40.tar.gz

# 执行如下的编译命令，设置mysql的编译参数

# 注意看下运行日志
[root@mysql-server56 tools]#  cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.6.40 \
-DMYSQL_DATADIR=/application/mysql-5.6.40/data \
-DMYSQL_UNIX_ADDR=/application/mysql-5.6.40/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
-DWITH_ZLIB=bundled \
-DWITH_SSL=bundled \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_EMBEDDED_SERVER=1 \
-DENABLE_DOWNLOADS=1 \
-DWITH_DEBUG=0

# 下一步，编译安装mysql 
# 这两步骤安装的过程较久，机器配置越高，速度会越快
make 
make install

# 最后几步的安装结果如下
-- Installing: /application/mysql-5.6.40/sql-bench/test-select
-- Installing: /application/mysql-5.6.40/sql-bench/test-transactions
-- Installing: /application/mysql-5.6.40/sql-bench/test-wisconsin
[root@mysql-server56 mysql-5.6.40]#
[root@mysql-server56 mysql-5.6.40]#

# mysql编译安装到了这里
[root@mysql-server56 mysql-5.6.40]# ls /application/mysql-5.6.40/
bin  COPYING  data  docs  include  lib  man  mysql-test  README  scripts  share  sql-bench  support-files

# 创建软连接，不带版本号，便于管理维护
[root@mysql-server56 mysql-5.6.40]# ln -s /application/mysql-5.6.40/ /application/mysql
```

建议命令执行完，都用echo $?检查结果

### 生成配置文件
```plain
[root@mysql-server56 mysql-5.6.40]# cp support-files/my-default.cnf /etc/my.cnf

```

### 初始化数据库
这一步得到数据库初始化的数据文件

这一步会出现两个OK选项，以及其他日志信息，不得出现error等信息，则表示初始化出问题  

```plain
[root@mysql-server56 mysql-5.6.40]# /application/mysql/scripts/mysql_install_db --basedir=/application/mysql/ --datadir=/application/mysql/data --user=mysql

# 检查数据文件夹
# 这是查看第一层目录
[root@mysql-server56 mysql-5.6.40]# tree -L 1 /application/mysql/data/
/application/mysql/data/
├── ibdata1
├── ib_logfile0
├── ib_logfile1
├── mysql        # 存放mysql核心数据
├── performance_schema    # 有关性能的库
└── test    # 测试数据库
```

### 配置数据库启动脚本
```plain
[root@mysql-server56 mysql-5.6.40]# cp support-files/mysql.server /etc/init.d/mysqld

# 授权
[root@mysql-server56 mysql-5.6.40]# chmod 700 /etc/init.d/mysqld
```

  
如上是系统自带的启停管理脚本，其实就是shell脚本了，大家shell学完，看懂是完全没问题

咱们自己开发的脚本，也提供给大家

```plain
[ -f /etc/init.d/functions ] && source /etc/init.d/functions
bindir="/application/mysql/bin"
datadir="/application/mysql/data"
mysqld_pid_file_path="/application/mysql/`hostname`.pid"
PATH="/sbin:/usr/sbin:/bin:/usr/bin:$basedir/bin" #此步对开机启动及定时启动及其关键。
export PATH
return_value=0

# Lock directory.
lockdir='/var/lock/subsys'
lock_file_path="$lockdir/mysql"

log_success_msg(){ 
    echo " SUCCESS! $@" # 注意函数的缩进，下同，也是专业的表现，可放到functions里。
}   
log_failure_msg(){     
    echo " ERROR! $@"
}  

# Start Func
start(){
    # Start daemon
    echo "Starting MySQL"
    if test -x $bindir/mysqld_safe  # 启动文件是否可执行。
    then
        $bindir/mysqld_safe --datadir="$datadir" --pid-file="$mysqld_pid_file_path"  >/dev/null &
        return_value=$? # 是否处理好返回值是区别脚本是否专业规范的关键。
        sleep 2

        # Make lock for CentOS
        if test -w "$lockdir"   # 锁目录是否可写。
        then
            touch "$lock_file_path"  # 创建锁文件。
        fi
        exit $return_value
    else
        log_failure_msg "Couldn't find MySQL server ($bindir/mysqld_safe)"
    fi
}
# Stop Func
stop(){
    if test -s "$mysqld_pid_file_path" # 是否PID文件存在并大小大于0。
    then
        mysqld_pid=`cat "$mysqld_pid_file_path"`

        if (kill -0 $mysqld_pid 2>/dev/null) # 检查PID对应的进程是否存在。
        then
            echo "Shutting down MySQL"
            kill $mysqld_pid  # 不能带-9，否则后果自负。
            return_value=$?
            sleep 2
        else
            log_failure_msg "MySQL server process #$mysqld_pid is not running!"
            rm -f "$mysqld_pid_file_path"
        fi
        # Delete lock for Oldboy's CentOS
        if test -f "$lock_file_path"
        then
            rm -f "$lock_file_path"
        fi
        exit $return_value
    else
        log_failure_msg "MySQL server PID file could not be found!"
    fi
}
case "$1" in
    start)            
        start
        ;;
    stop)
        stop
        ;;
    restart)
        if $0 stop; then
           $0 start
        else
           log_failure_msg "Failed to stop running server, so refusing to try to start."
           exit 1
        fi
        ;;

    *)
        echo "Usage: $0  {start|stop|restart}"
        exit 1
esac
exit $return_value #是否处理好返回值是区别脚本是否专业规范的关键。
```

### 启动mysql
执行脚本

```plain
[root@mysql-server56 mysql-5.6.40]# /etc/init.d/mysqld start
Starting MySQL.Logging to '/application/mysql-5.6.40/data/mysql-server56.err'.
210413 18:13:43 mysqld_safe Directory '/application/mysql-5.6.40/tmp' for UNIX socket file don't exists.
 ERROR! The server quit without updating PID file (/application/mysql-5.6.40/data/mysql-server56.pid).
```

  
兄弟们，看到超哥这里，是有报错的，千万别命令执行过后，啥系统给的提示也不看，这是非常危险的，且不对的想法。

大家一定得对自己执行的linux命令负责，否则在生产服务器上，你的操作，都得负责。

如何解决这个错误？

因为在我们编译安装mysql的时候，指定了一个配置，要求mysql的进程套接字文件，放在该tmp目录

如下

```plain
[root@mysql-server56 mysql-5.6.40]# mkdir -p /application/mysql/tmp
[root@mysql-server56 mysql-5.6.40]# chown -R mysql.mysql /application/mysql/

# 再次启动
[root@mysql-server56 mysql-5.6.40]# /etc/init.d/mysqld start
Starting MySQL.Logging to '/application/mysql-5.6.40/data/mysql-server56.err'.
 SUCCESS!
[root@mysql-server56 mysql-5.6.40]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      25459/mysqld
```

保持好习惯，检查日志文件

默认路径如下

该错误日志的文件名字，以当前主机名命名  
 

```plain
[root@mysql-server56 mysql-5.6.40]# tail -f /application/mysql/data/mysql-server56.err

```

### 设置开机启动
```plain
[root@mysql-server56 mysql-5.6.40]# systemctl enable mysqld
mysqld.service is not a native service, redirecting to /sbin/chkconfig.
Executing /sbin/chkconfig mysqld on

# 查看级别
[root@mysql-server56 mysql-5.6.40]# chkconfig --list mysqld

Note: This output shows SysV services only and does not include native
      systemd services. SysV configuration data might be overridden by native
      systemd configuration.

      If you want to list systemd services use 'systemctl list-unit-files'.
      To see services enabled on particular target use
      'systemctl list-dependencies [target]'.

mysqld             0:off    1:off    2:on    3:on    4:on    5:on    6:off
```

备注，在如下几个运行级别中，mysqld是自动启动的

```plain
等级代号列表：

等级0表示：表示关机
等级1表示：单用户模式
等级2表示：无网络连接的多用户命令行模式
等级3表示：有网络连接的多用户命令行模式
等级4表示：不可用
等级5表示：带图形界面的多用户模式
等级6表示：重新启动
```

### 设置PATH
此时超哥的服务器上，还无法直接使用mysql命令，为什么大家知道么？  

```plain
[root@mysql-server56 mysql-5.6.40]# echo 'export PATH=/application/mysql/bin:$PATH' >>/etc/profile
[root@mysql-server56 mysql-5.6.40]# source /etc/profile
[root@mysql-server56 mysql-5.6.40]# echo $PATH
/application/mysql/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

至此，mysql的安装就算是结束了，大家可以运行数据库使用了

### 登录mysql
登录命令，默认是空密码

```plain
[root@mysql-server56 mysql-5.6.40]# mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.40 Source distribution

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

如果有出现任何的问题，基本上是安装出错，跟着超哥上面的笔记， 再来一遍，检查下吧

话说这个笔记的细致程度，超哥认第二，谁敢认第一，哈哈哈  

```plain
mysql>
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+
4 rows in set (0.00 sec)

# 查看当前用户
mysql> select user();
+----------------+
| user()         |
+----------------+
| root@localhost |
+----------------+
1 row in set (0.00 sec)
```

  
 

## mysql安全配置
此时超哥的mysql是及其不安全的，密码为空，那就可以任意登录，以及通过mysqladmin等命令，篡改数据库密码。

修改mysql密码

### mysqladmin
设置密码为

root

yuchao668

```plain
# -u 用户名  -p 当前密码  password 设置新密码
[root@mysql-server56 mysql-5.6.40]# mysqladmin -uroot -p password
Enter password:
New password:
Confirm new password:
```

再次登录

```plain
[root@mysql-server56 mysql-5.6.40]# mysql
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)

# 看上面，不输入密码就拒绝了

[root@mysql-server56 mysql-5.6.40]# mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.6.40 Source distribution

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

  

### 清理无用信息
一些mysql无用的用户，会导致数据库不稳定性

```plain
mysql> select user,host from mysql.user;
+------+----------------+
| user | host           |
+------+----------------+
| root | 127.0.0.1      |
| root | ::1            |
|      | localhost      |
| root | localhost      |
|      | mysql-server56 |
| root | mysql-server56 |
+------+----------------+
6 rows in set (0.00 sec)

# 删除用户，也就是删除表记录
# 备注   ::1 是IPv6格式的 127.0.0.1 
mysql> drop user root@'::1';
Query OK, 0 rows affected (0.00 sec)

mysql> drop user root@'mysql-server56';
Query OK, 0 rows affected (0.00 sec)

mysql> drop user ''@'mysql-server56';
Query OK, 0 rows affected (0.00 sec)

mysql> drop user ''@'localhost';
Query OK, 0 rows affected (0.00 sec)

# 保留出如下2个用户即可
mysql> select user,host from mysql.user;
+------+-----------+
| user | host      |
+------+-----------+
| root | 127.0.0.1 |
| root | localhost |
+------+-----------+
2 rows in set (0.00 sec)
```

drop是mysql的内置语句，用于删除，请不要乱用，超哥讲过SQL之后，大家就明白了

删除语句还有delete，后面再说

```plain
# 刷新用户表权限
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

删除无用的数据库

上面是删除了table，表中的记录，一行行的信息

现在是删除整个数据库，无用的文件夹

```plain
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+
4 rows in set (0.00 sec)

# 干掉test数据库
mysql> drop database test;
Query OK, 0 rows affected (0.00 sec)
```

更多的mysql的安全知识，超哥会一步一步带着大家学习，奥力给！！

一些小问题

可能大家会出现如下问题

```plain
checking for tgetent in -ltinfo... no
checking for termcap functions library... configure: error: No curses/termcap library found
```

如何解决

```plain
yum install ncurses-devel -y

```

  

# MySQL多实例管理
  
 前面已经针对MySQL数据库进行了介绍，并说明了为什么选择MySQL数据库，以及MySQL数据库在Linux系统下的多种安装方式，同时以单实例讲解了如何以编译方式安装MySQL和基础安全优化等内容，本章将为大家讲解更为实用的MySQL多实例安装，百度、淘宝、阿里、新浪等大公司无一例外地都会使用多实例的方式部署数据库，那么是什么原因促使他们选择多实例数据库的部署方式呢？

单实例，也就是超哥前面是带着大家，在一台linux上，某个目录下，安装了一个mysql，且启动了这个mysql，这就表示，这个机器上，有单独的一个mysql个体，一个实例。

## 什么是多实例
一句话

多实例，就是一台linux上，同时运行多个mysql，当然是区别了不同的端口，例如3306、3307、3308。运行三个mysql数据库

这三个mysql，就相当于三个独立的卧室，互相没关系，在linux上的呈现区别就是

+ 不同的端口
+ 不同的数据目录，不同的配置文件
+ 不同的mysql进程，不同的pid

<!-- OCR_START -->
- 卧室1
- 卧室2
- 3306
- mysql
- 3307
- 实例1
- 为什么需要mysql
- 实例2
- 实例
- 多实例
- 3306实例的配置
- 3307实例的配置
- /data/3306/data
- 独立数据
- /data/3307/data
- 意义在哪?
- /data/3306/my.cnf
- 独立配置
- /data/3307/my.cnf
- 充分利用机器资源
- /data/3306/mysqld独立启动
- /data/3307/mysqld独立启动
- 厨房
- 客厅
- 公共资源
- 系统：Centoslinux
- 硬件：磁盘，内存，CPU
- OC
- CentOS
<!-- OCR_END -->

打个比方：MySQL 多实例就像**一套房子里的多个卧室**。

* 每个实例 = 一间卧室（各自独立）
* 整个服务器 = 一套房子
* 服务器的硬件资源（CPU、内存、磁盘）和软件资源（CentOS 操作系统）= 卫生间、厨房、客厅，属于**公共资源**

就像合租一样：大家各自在自己的卧室休息，但出来活动就要共用这些公共资源。下图是 MySQL 多实例的形象示意图。

因此，这个多实例的概念，也就是一个程序，被我们运行了多个单独的个体，这就不限于mysql了

nginx、apache、redis、memcached都可以多实例，只要他们的端口、数据文件、进程都是单独的就好。

## 多实例的好处
可有效利用服务器资源。当单个服务器资源有剩余时，可以充分利用剩余的资源提供更多的服务，且可以实现资源的逻辑隔离。

节约服务器资源。若公司资金紧张，但是数据库又需要各自尽量独立地提供服务，而且还需要用到主从复制等技术，那么选择多实例就再好不过了。

例如公司有多个业务，需要用到好几套mysql数据库，都得单独的部署，数据区分开

## 多实例的弊端
MySQL多实例有它的好处，也有其弊端，比如，会存在资源互相抢占的问题。当某个数据库实例并发很高或者有SQL慢查询时，整个实例会消耗大量的系统CPU、磁盘I/O等资源，导致服务器上的其他数据库实例提供服务的质量一起下降。

这就相当于大家住在一个房子的不同卧室中，早晨起来上班，都要刷牙、洗脸等，这样卫生间就会长期处于占用状态，其他人则必须要等待。

不同实例获取的资源是相对独立的，无法像虚拟化一样完全隔离。(毕竟大家都是在同一个文件系统下)

以后超哥教大家学习虚拟化后，就可以实现完全隔离。

## 学MySQL多实例用在哪些场景
### 资金紧张的公司
若公司资金紧张，公司业务访问量不太大，但又希望不同业务的数据库服务各自能够尽量独立地提供服务而互相不受影响，或者，还有需要主从复制等技术提供备份或读写分离服务的需求，那么，多实例就再好不过了。

比如：可以通过3台服务器部署9~15个实例，交叉做主从复制、数据备份及读写分离，这样就可以等同于9~15台服务器每个只装一个数据库才有的效果。（很省钱了）

这里需要强调的是，所谓的尽量独立是相对的。

### 用户并发访问量不大的业务
当公司业务访问量不太大的时候，服务器的资源基本上都是浪费的，这时就很适合多实例的应用，如果对SQL语句的优化做得比较好，MySQL多实例会是一个很值得使用的技术，即使并发很大，合理分配好系统资源以及搭配好服务，也不会有太大的问题。

例如某古董、古玩展示的网站，比起电商网站，并发量会小一些，更多追求稳定，而不是高性能、高并发。

### 大型网站也有用多实例
门户网站通常都会使用多实例，因为配置硬件好的服务器，可以节省IDC机柜空间，同时，运行多实例也会减少硬件资源占用率不满的浪费。

<!-- OCR_START -->
- 写操作
- Mysql-master
- 主从同步
- 读操作
- 客户端
- 应用程序服务器
- Mysql-slave
<!-- OCR_END -->

比如，百度公司的很多数据库都是多实例的，不过，一般是从库采用多实例，例如某部门中使用的IBM服务器为48核CPU，内存96GB，一台服务器运行3~4个实例；

此外，新浪网也有采用多实例的情况，内存48GB左右。

专门运行数据库的服务器，一般要求性能较高、因为数据库大多时候是网站性能的瓶颈。

要求CPU、内存、磁盘都得很强大。

## MySQL多实例部署
图解

<!-- OCR_START -->
- /data/3306/
- SQL
- 多实例
- 基于一套mysql应用
- 生成多个数据目录
- /data/3307/
- /data/3308/
- 一份mysql应用程序
- 目录：/application/mysql-5.6.40-linux-glibc2.12-
- x86_64/
<!-- OCR_END -->

我们采用的形式是：

+ 每个实例都有单独的
- 配置文件
- 启动脚本
- 数据目录

```plain
[root@mysql-server56 application]# tree /data/
/data/
├── 3306
│   ├── data
│   ├── my.cnf
│   └── mysql_3306
└── 3307
    ├── data
    ├── my.cnf
    └── mysql_3307
```

### 部署多实例
安装方式有如下几种

+ 二进制安装（软件包名字较长、带有版本号、平台信息、等）
- 源代码已经被编译过，下载、解压后，可以直接在对应的系统平台上运行，二进制包比较大，使用比较简单。
- 如mysql-5.0.45-linux-x86_64-glibc23.tar.gz
+ 源代码安装（软件包基本只是一个携带版本号的tar包）
- 需要在机器上重新编译安装，时间较久，对于系统环境依赖性比较重
- 如mysql-5.0.45.tar.gz
+ RPM包安装
- rpm是红包的一个软件包管理系统
- rpm包也是二进制包的一种，但是也分为两种
        * 源码rpm包，源代码被打包成了rpm格式（看不到源代码了，tar包可以看到源代码），还得重新编译rpmbuild --rebuild
            + 如name-version-release.arch.src.rpm
        * 二进制rpm包，可以直接安装rpm包使用
            + 如name-version-release.arch.rpm

### rpm和源码的优缺点
RPM包优点： 1）RPM包管理简单，只需要通过几个简单的命令就可以实现软件包的安装升级卸载和查询 2）安装速度比源码包形式快（源码包主要是make编译花费时间较长）

**RPM 包的缺点：**

1. 是事先编译好的二进制包，安装即用，因此**看不到源码**
2. 功能已固定，**无法灵活删除或新增功能**
3. **依赖性很强**，安装一个 RPM 包往往要先装很多依赖包
4. 卸载时不小心触及依赖关系，可能连带移除系统所需软件，**导致系统崩溃**

对于已经编译成二进制的rpm包，由于操作系统环境不同，一般不能混用。

### 二进制安装mysql
这里我们可以采用二进制方式，安装mysql，源码编译，前面已经讲过了

下载地址，依然是[http://mirrors.sohu.com/mysql/MySQL-5.6/](http://mirrors.sohu.com/mysql/MySQL-5.6/)

```plain
# 获取二进制代码包
wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz
```

<!-- OCR_START -->
mysql-5.6.40-freebsd11-x86_64.tar.gz.md5
71 B
2018-Feb-2708:00
mysql-5.6.40-linux-glibc2.12-i686.tar.gz
301.6 MiB
2018-Feb-26 12:02
173 B
2018-Feb-27 08:28
75 B
mysql-5.6.40-linux-glibc2.12-x86 64.tar.gz
313.3 MiB
2018-Feb-26 12:10
77 B
2018-Feb-2708:01
mysql-5.6.40-macos10.13-x86_64.dmg
167.3 MiB
2018-Feb-26 13:17
2018-Feb-2708:30
69B
2018-Feb-2708:05
mysql-5.6.40-macos10.13-x86_64.tar.gz
167.6 MiB
2018-Feb-26 13:13
72 B
<!-- OCR_END -->

## 安装流程
如果是centos，最小化安装系统，可以安装如下的基础环境依赖包，【可选】

```plain
yum  clean all
yum -y update
yum -y install gcc-c++ gd libxml2-devel libjpeg-devel libpng-devel net-snmp-devel wget telnet vim zip unzip
yum -y install curl-devel libxslt-devel pcre-devel libjpeg libpng libcurl4-openssl-dev
yum -y install libcurl-devel libcurl freetype-config freetype freetype-devel unixODBC libxslt
yum -y install gcc automake autoconf libtool openssl-devel
yum -y install perl-devel perl-ExtUtils-Embed  *libnuma* screen
yum -y install cmake ncurses-devel.x86_64  openldap-devel.x86_64 lrzsz  openssh-clients gcc-g77  bison
yum -y install libmcrypt libmcrypt-devel mhash mhash-devel bzip2 bzip2-devel
yum -y install ntpdate rsync svn  patch  iptables iptables-services
yum -y install libevent libevent-devel  cyrus-sasl cyrus-sasl-devel
yum -y install gd-devel libmemcached-devel memcached git libssl-devel libyaml-devel auto make
yum -y install gcc gcc-c++ make autoconf automake ncurses-devel bison ncurses  cmake libaio libaio-devel  boost
yum -y groupinstall "Server Platform Development" "Development tools"
yum -y groupinstall "Development tools"
```

### 二进制部署mysql多实例
理念就是，基于一套mysql程序，初始化多套数据，完成多实例

我们可以直接选用之前编译安装的mysql5.6

也可以用超哥这里新下载的二进制mysql5.6

目的在于教大家多会一种二进制的部署方式

```plain
# 1.下载代码，放入超哥的软件仓库
[root@mysql-server56 tools]# cd /home/chaoge/tools/ && wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz

# 2.系统基础环境依赖安装
yum install ncurses-devel libaio-devel gcc make cmake -y

# 3.创建系统用户，之前创建过了，就无须执行了
[root@mysql-server56 ~]# groupadd mysql
groupadd: group 'mysql' already exists
[root@mysql-server56 ~]# useradd -g mysql mysql
useradd: user 'mysql' already exists
[root@mysql-server56 ~]#

# 4.创建多实例的独立目录
[root@mysql-server56 ~]# mkdir -p /application/{3306,3307}

[root@mysql-server56 ~]# tree -L 1 /application/
/application/
├── 3306
├── 3307
├── mysql -> /application/mysql-5.6.40/
└── mysql-5.6.40

# 5.解压缩二进制mysql
# 注意如下的目录，是超哥之前讲课用到的数据，别搞混了
[root@mysql-server56 tools]# ls -lh
total 344M
drwxr-xr-x 35 7161 31415 4.0K Apr 13 17:10 mysql-5.6.40 # 解压出的源码
-rw-r--r--  1 root root  314M Apr 15 09:19 mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz # mysql二进制压缩包
-rw-r--r--  1 root root   31M Feb 26  2018 mysql-5.6.40.tar.gz # 源码压缩文件

# 6.解压缩mysql二进制压缩包
[root@mysql-server56 tools]# tar -xf mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz -C /application/

[root@mysql-server56 tools]# ls /application/ -l
total 0
lrwxrwxrwx  1 mysql mysql  26 Apr 13 17:17 mysql -> /application/mysql-5.6.40/
drwxr-xr-x 14 mysql mysql 216 Apr 13 18:15 mysql-5.6.40
drwxr-xr-x 13 root  root  191 Apr 15 10:04 mysql-5.6.40-linux-glibc2.12-x86_64
```

目前为止，咱们的mysql数据目录结构，长这样，大家别糊涂了

跟着超哥的脚步、一步一步来。。

<!-- OCR_START -->
[root@mysql-server56 tools]# tar -xf mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz -C /application/
[root@mysql-server56tools]#ls/application/
mysql mysql-5.6.40mysql-5.6.40-linux-glibc2.12-x86_64
totalo
lrwxrwxrwx 1 mysql mysql 26 Apr 13 17:17 mysql -> /application/mysql-5.6.40/
之前于超老师讲解的mysgl编译安装目录
drwxr-xr-x 14 mysql mysql 216 Apr 13 18:15 mysql-5.6.40
drwxr-xr-x 13 root root 191 Apr 15 10:04 mysql-5.6.40-linux-glibc2.12-x86_64
本节课mysql解压出的二进制目录
[root@mysql-server56tools]#
Froot@mysgl
server56toolsl#
<!-- OCR_END -->

### 停止编译的mysql
继续写步骤。。没毛病

此时可以停掉我们之前运行的，编译安装的mysql，让环境清晰些

```plain
# 检查、且停掉之前编译安装的mysql
[root@mysql-server56 /]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      1394/mysqld

[root@mysql-server56 /]# systemctl stop mysqld
[root@mysql-server56 /]# netstat -tunlp|grep mysql

# 禁止开机自启
[root@mysql-server56 /]# systemctl disable mysqld
mysqld.service is not a native service, redirecting to /sbin/chkconfig.
Executing /sbin/chkconfig mysqld off
[root@mysql-server56 /]# chkconfig --list mysqld
```

  

### 编写多实例配置文件
此时可以继续来安装我们的mysql多实例了

```plain
# 7.直接用二进制mysql，初始化多实例mysql

# 会看我们上面准备好的多实例目录
[root@mysql-server56 /]# tree /data
/data
├── 3306
│   ├── data
│   ├── my.cnf
│   └── mysql
└── 3307
    ├── data
    ├── my.cnf
    └── mysql

# 8.准备多实例的配置文件
[root@mysql-server56 application]# cat /data/3306/my.cnf
[client]
port=3306
socket=/data/3306/mysql.sock

[mysqld]
user=mysql
port=3306
socket=/data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3306/data
log-bin=/data/3306/mysql-bin
server-id=5

[mysqld_safe]
log-error=/data/3306/mysql_3306_error.log
pid-file=/data/3306/mysqld_3306.pid

# 以及3307配置文件
sed 's/3306/3307/g;s/server-id=5/server-id=6/g' /data/3306/my.cnf > /data/3307/my.cnf
```

<!-- OCR_START -->
[root@mysql-server56 application]#cat/data/3306/my.cnf
[root@mysql-server56~]#cat/data/3307/my.cnf
[client]
port=3306
port=3307
socket=/data/3307/mysql.sock
[mysqld]
user=mysql
socket=/data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3306/data
datadir=/data/3307/data
log-bin=/data/3306/mysql-bin
log-bin=/data/3307/mysql-bin
server-id=5
server-id=6
[mysqld_safe]
log-error=/data/3306/mysql_3306_error.log
log-error=/data/3307/mysql_3307_error.log
pid-file=/data/3306/mysqld_3306.pid
pid-file=/data/3307/mysqld_3307.pid
[root@mysql-server56application]#
[root@mysql-server56 ~]#
<!-- OCR_END -->

### 多实例启动脚本
```plain
# 目录文件
[root@mysql-server56 application]# tree /data/
/data/
├── 3306
│   ├── data
│   ├── my.cnf
│   └── mysql_3306
└── 3307
    ├── data
    ├── my.cnf
    └── mysql_3307
```

启停脚本代码，区别只有port

提示：

```plain
kill -0 pid 不发送任何信号，但是系统会进行错误检查。
所以经常用来检查一个进程是否存在，存在返回0；不存在返回1

man手册里：
The signals listed below may be available for use with kill. When known constant, numbers and default behavior are shown.
Name Num Action Description
0 0 n/a exit code indicates if a signal may be sent

kill不指定信号将发送SIGTERM（15）终止指定进程

kill -9 PID 是操作系统从内核级别强制杀死一个进程.

kill -15 PID 可以理解为操作系统发送一个通知告诉应用主动关闭.

SIGNTERM（15） 的效果是正常退出进程，退出前可以被阻塞或回调处理。并且它是Linux缺省的程序中断信号。
```

代码

```plain
port=3306
mysql_user="root"
Cmdpath="/application/mysql-5.6.40-linux-glibc2.12-x86_64/bin"
mysql_sock="/data/${port}/mysql.sock"
mysqld_pid_file_path=/data/${port}/mysqld_${port}.pid

start(){
if [ ! -e "$mysql_sock" ];then
    printf "Starting MySQL...\n"
    /bin/sh ${Cmdpath}/mysqld_safe --defaults-file=/data/${port}/my.cnf --pid-file=$mysqld_pid_file_path 2>&1 > /dev/null &
    sleep 3
else
    printf "MySQL is running...\n"
    exit 1
fi
}

stop(){
    if [ ! -e "$mysql_sock" ];then
        printf "MySQL is stopped...\n"
        exit 1
    else
        printf "Stoping MySQL...\n"
        mysqld_pid=`cat "$mysqld_pid_file_path"`
    if (kill -0 $mysqld_pid 2>/dev/null)
        then
        kill $mysqld_pid
        sleep 2
        fi
    fi
}

restart(){
    printf "Restarting MySQL...\n"
    stop
    sleep 2
    start
}

case "$1" in
start)
    start
;;
stop)
    stop
;;
restart)
    restart
;;
*)
    printf "Usage: /data/${port}/mysql{start|stop|restart}\n"
esac
```

### 授权mysql多实例
```plain
[root@mysql-server56 application]# chown -R mysql.mysql /data/

# 针对mysql启停脚本，单独设置权限
# mysql启动文件，权限给低一点，防止非root用户访问，加大权限
[root@mysql-server56 application]# find /data/ -name mysql_* |xargs chmod 700

# 命令检查权限
[root@mysql-server56 application]# find /data/ -name mysql_* -exec ls -l {} \;
-rwx------ 1 mysql mysql 998 Apr 15 11:17 /data/3306/mysql_3306
-rwx------ 1 mysql mysql 998 Apr 15 11:17 /data/3307/mysql_3307
```

### 命令添加入PATH
这里大家一定注意PATH，前面超哥讲解的编译安装mysql，已经配置过PATH了，可以选择PATH的读取顺序，也可以修改整个PATH。

此时超哥的linux目录如下  

```plain
[root@mysql-server56 application]# pwd
/application
[root@mysql-server56 application]# ls -l
total 0
drwxr-xr-x  2 root  root    6 Apr 15 10:06 3306
drwxr-xr-x  2 root  root    6 Apr 15 10:06 3307
lrwxrwxrwx  1 mysql mysql  26 Apr 13 17:17 mysql -> /application/mysql-5.6.40/
# 编译安装的
drwxr-xr-x 14 mysql mysql 216 Apr 13 18:15 mysql-5.6.40 
# 二进制mysql
drwxr-xr-x 13 root  root  191 Apr 15 10:04 mysql-5.6.40-linux-glibc2.12-x86_64
```

至于PATH的修改，希望大家一定搞清楚，因为我们机器上存在多个mysql，当我们执行mysql -uroot -p

这样的命令的时候，到底执行、读取的是哪一个mysql，这一点非常重要。

```plain
# 当前指向的是编译安装的mysql
[root@mysql-server56 application]# echo $PATH
/application/mysql/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

# 修改成指向二进制的mysql
[root@mysql-server56 application]# tail -2 /etc/profile
#export PATH=/application/mysql/bin:$PATH
export PATH=/application/mysql-5.6.40-linux-glibc2.12-x86_64/bin:$PATH

# 从新登陆会话，检查mysql的PATH

[root@mysql-server56 ~]# echo $PATH
/application/mysql-5.6.40-linux-glibc2.12-x86_64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
[root@mysql-server56 ~]# which mysql
/application/mysql-5.6.40-linux-glibc2.12-x86_64/bin/mysql
```

后面就可以根据不同的配置文件，初始化不同的mysql，进行使用了

### 初始化mysql多实例数据
初始化多实例3306

```plain
# 初始化命令
[root@mysql-server56 ~]#  /application/mysql-5.6.40-linux-glibc2.12-x86_64/scripts/mysql_install_db --defaults-file=/data/3306/my.cnf --basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/ --datadir=/data/3306/data/ --user=mysql

# 检查数据目录，这里就是mysql数据库存储的地方了
[root@mysql-server56 ~]# ls /data/3306/data/
ibdata1  ib_logfile0  ib_logfile1  mysql  performance_schema  test

# 此时3307是没数据的
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# ls /data/3307/data
```

初始化3307实例

```plain
[root@mysql-server56 ~]# /application/mysql-5.6.40-linux-glibc2.12-x86_64/scripts/mysql_install_db --defaults-file=/data/3307/my.cnf --basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/ --datadir=/data/3307/data/ --user=mysql

# 3307实例的数据出现了
[root@mysql-server56 ~]# ls /data/3307/data
ibdata1  ib_logfile0  ib_logfile1  mysql  performance_schema  test
```

### 最后的数据文件
这么多步骤下来了，不知道大家是否还能跟得上超哥的节奏。。总结如下

<!-- OCR_START -->
- [root@mysql-server56 ~]# tree /data -L 3
- /data
- 3306
- ibdata1
- ib_logfile0
- 实例1 mysql
- 的数据
- mysql
- performance_schema
- test
- my.cnf
- mysql_3306
- mysql-bin.000001
- mysql-bin.000002
- mvsal-bin.index
- 3307
- 实例 2 mysql
- mysql_3307
- mysql-bin.index
- 10 directories,
- 16 files
<!-- OCR_END -->

## 多实例mysql启动
根据脚本直接启动即可

3306

```plain
[root@mysql-server56 ~]# /data/3306/mysql_3306 start
Starting MySQL...
210415 14:57:43 mysqld_safe error: log-error set to '/data/3306/mysql_3306_error.log', however file don't exists. Create writable for user 'mysql'.

# 发现启动报错了，缺少日志文件
[root@mysql-server56 ~]# touch /data/3306/mysql_3306_error.log
[root@mysql-server56 ~]# touch /data/3307/mysql_3307_error.log

# 再次启动
[root@mysql-server56 ~]# /data/3306/mysql_3306 start
Starting MySQL...
[root@mysql-server56 ~]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      7412/mysqld
```

  
3307

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 start
Starting MySQL...
[root@mysql-server56 ~]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      7412/mysqld
tcp6       0      0 :::3307                 :::*                    LISTEN      7913/mysqld
```

只有看到这个结果，才表示多实例，正确启动了

## 设置开机自启
添加入rc.local  
   

```plain
[root@mysql-server56 ~]# echo "#mysql multi instances" >>/etc/rc.local
[root@mysql-server56 ~]# echo "/data/3306/mysql_3306 start" >>/etc/rc.local
[root@mysql-server56 ~]# echo "/data/3307/mysql_3307 start" >>/etc/rc.local
[root@mysql-server56 ~]# tail -3 /etc/rc.local
#mysql multi instances
/data/3306/mysql_3306 start
/data/3307/mysql_3307 start
```

## 如何登陆多实例
根据进程套接字文件连接

**mysql.sock是mysql的主机和客户机在同一host上的时候，使用unix domain socket做为通讯协议的载体，它比tcp快，在高并发场景下，效率更高。**

通过指定的不同sock文件，连接到不同的数据库，查看不同的信息

查看sock文件  

```plain
[root@mysql-server56 ~]# find /data -name *.sock
/data/3306/mysql.sock
/data/3307/mysql.sock
```

若是mysql实例关闭，sock文件被销毁

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 stop
Stoping MySQL...
[root@mysql-server56 ~]# /data/3306/mysql_3306 stop
Stoping MySQL...
[root@mysql-server56 ~]# find /data -name *.sock
```

## 连接命令
```plain
[root@mysql-server56 ~]# mysql -uroot -p  -S /data/3306/mysql.sock
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show variables like 'port';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| port          | 3306  |
+---------------+-------+
1 row in set (0.00 sec)

mysql>
```

登陆3307

```plain
[root@mysql-server56 ~]# mysql -uroot -p  -S /data/3307/mysql.sock
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show variables like 'port';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| port          | 3307  |
+---------------+-------+
1 row in set (0.00 sec)

mysql>
```

  

## mysql安全配置
mysql默认没有密码，大家可以通过mysqladmin命令修改密码

当然是修改不同的实例

连接命令可以设置别名，还有谁像超哥这样这么懒？  

```plain
[root@mysql-server56 ~]# alias "my3307=/data/3307/mysql_3307"
[root@mysql-server56 ~]# alias "my3306=/data/3306/mysql_3306"

[root@mysql-server56 ~]# my3307 start
Starting MySQL...
[root@mysql-server56 ~]# my3306 start
Starting MySQL...
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      12664/mysqld
tcp6       0      0 :::3307                 :::*                    LISTEN      12451/mysqld
[root@mysql-server56 ~]#
```

>   
修改密码
>
> 注意，密码不要写在命令行，不安全
>
> 为了让大家看的更明白，我们区别密码
>
> 3306如下
>
> root
>
> yuchao668
>
> 3307如下
>
> root
>
> yuchao778
>

```plain
[root@mysql-server56 ~]# mysqladmin -uroot -S /data/3306/mysql.sock password
New password:
Confirm new password:

[root@mysql-server56 ~]# mysqladmin -uroot -S /data/3307/mysql.sock password
New password:
Confirm new password:
```

### 新密码登录
```plain
# 3306  yuchao668
[root@mysql-server56 ~]# mysql -uroot -p -S /data/3306/mysql.sock
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

# 3307   yuchao778
[root@mysql-server56 ~]# mysql -uroot -p -S /data/3307/mysql.sock
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

## 如何远程登录多实例mysql
上面超哥的讲解，都是在linux本地，直接连接mysql，且是通过sock套接字进程文件连接。

那如果我们要通过客户端，远程连接linux的mysql，那就不是sock文件，而是：

+ ip
+ 端口

本地连接多实例，ip+端口

```plain
[root@mysql-server56 ~]# mysql -uroot -p  -h 127.0.0.1 -P 3307
[root@mysql-server56 ~]# mysql -uroot -p  -h 127.0.0.1 -P 3306
```

远程连接多实例，ip+port  

```plain
[yuchao@yumac ~]$mysql -uroot -p -h10.211.55.12 -P 3307
Enter password:
ERROR 1130 (HY000): Host '10.211.55.2' is not allowed to connect to this MySQL server

# 但是这里大家发现，被not allowed拒绝连接了，这是因为root权限的问题，后面我们学习SQL，就知道如何管理

# linux数据库给与root远程权限，+设置密码
mysql> grant all privileges on *.* to root@'%' identified by 'yuchao778';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

# 客户端可以正确连接了，注意密码，还是别写在命令行
[yuchao@yumac ~]$mysql -uroot -pyuchao778 -h10.211.55.12 -P 3307
```

## MySQL综合知识
### 查看帮助
```plain

mysql> help
mysql> help create
```

### 安全策略
初始化安装mysql后，我们要有如下安全意识

+ 数据库内网运行，127.0.0.1，禁止外网
+ root用户设置复杂密码

```plain
mysqladmin -uroot -p'yuchao888' password 'yuchao999' # 单实例
mysqladmin -uroot -p'yuchao888' password 'yuchao999'  -S /data/3307/mysql.sock

# SQL修改密码
update mysql.user set password=PASSWORD("yuchao888") WHERE user='root' and host='localhost';

flush privileges;
```

+ 删除无用账号，只保留所需的user
+ 删除test库
+ 用户创建时，权限尽可能小，授权的主机范围，尽肯能小
+ 数据库登录时，密码别遗漏在历史记录里

## 找回MySQL多实例密码
1.通过参数忽略授权登录验证

哪天超哥突然忘掉了mysql用户的密码，这咋办？

### 方法1，mysqld_safe命令
补充

```plain
直接运行mysqld程序来启动MySQL服务的方法很少见，mysqld_safe脚本会在启动MySQL服务器后继续监控其运行情况，并在其死机时重新启动它。用mysqld_safe脚本来启动MySQL服务器的做法在BSD风格的unix系统上很常见，非BSD风格的UNIX系统中的 mysql.server脚本其实也是调用mysqld_safe脚本去启动MySQL服务器的。它通常做如下事情：
1. 检查系统和选项。
2. 检查MyISAM表。
3. 保持MySQL服务器窗口。
4. 启动并监视mysqld，如果因错误终止则重启。
5. 将mysqld的错误消息发送到数据目录中的host_name.err 文件。
6. 将mysqld_safe的屏幕输出发送到数据目录中的host_name.safe文件。

使用mysqld_safe命令可以启动MySQL服务器。mysqld_safe增加了一些安全功能，比如发生错误时重新启动服务器，并记录运行信息到错误日志文件。

语法格式： mysqld_safe [参数]

常用参数：

--port    监听TCP/IP连接时，服务器应该使用的端口号。
--user    运行mysqld服务器的系统登录用户
--log-error    写入错误日志到指定文件
--pid-file    进程ID文件的路径名
```

启动时候，添加参数

比如3307实例的密码忘掉了，修改方式如下  
 

```plain
# 停止数据库
[root@mysql-server56 ~]# /data/3307/mysql_3307 stop
Stoping MySQL...

# 执行命令，跳过授权表启动
[root@mysql-server56 ~]# mysqld_safe --defaults-file=/data/3307/my.cnf --skip-grant-tables > /dev/null 2>&1 &
[1] 22060
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# netstat -tunlp|grep mysql
tcp6       0      0 :::3307                 :::*                    LISTEN      22247/mysqld

# 此时可以空密码直接登录
[root@mysql-server56 ~]# mysql -S /data/3307/mysql.sock

# 登录后，可以直接修改密码

mysql> update mysql.user set password=password("yuchao7777") where user='root' and host='localhost';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

密码修改之后，正常关闭该mysql-3307进程，重新正常启动，不要加额外参数了

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 stop
Stoping MySQL...
[1]+  Done                    mysqld_safe --defaults-file=/data/3307/my.cnf --skip-grant-tables > /dev/null 2>&1

# 再次启动
[root@mysql-server56 ~]# /data/3307/mysql_3307 start
Starting MySQL...

# 此时必须输入新密码
[root@mysql-server56 ~]# mysql -S /data/3307/mysql.sock
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# mysql -uroot -p -S /data/3307/mysql.sock
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

### 方法2，通过配置文件
该方式，相比方式1，稍有麻烦，需要来回修改配置文件  

```plain
# 修改配置文件，然后正常启动mysql即可
# 修改my.cnf
[mysqld]
user=mysql
port=3307
socket=/data/3307/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3307/data
log-bin=/data/3307/mysql-bin
server-id=6
skip-grant-tables

# 后续正常启动就行，操作是一样的
```

# MySQl核 心SQL语句
SQL，英文全称为Structured Query Language，中文意思是结构化查询语言，它是一种对关系型数据库中的数据进行定义和操作的语言，是大多数关系型数据库管理系统所支持的工业标准语言。

就像我们和bash打交道，要遵循bash的语法，然后可以对linux的数据，进行增删改查。

我们使用mysql这个工具，进行数据管理，就得遵循SQL专门的语法，进行存储、查询、更新、管理数据库内容。

SQL帮助我们不用关注数据到底是怎么在磁盘上存储的，通过高级SQL语言，能够非常简单的对数据管理，以及强大的灵活性，不同的数据库的SQL会有些差别。

## 有关SQL的分类
![1671616828395-9d43efc2-c264-47b6-9747-3473229741ef.png](img/DBA数据库管理员/image36.png)

### DQL数据查询语言
DQL，全称为Data Query Language，其语句也称为“数据检索语句”，作用是从表中获取数据，确定数据应怎样在应用程序中给出。

关键字SELECT是DQL（也是所有SQL）用得最多的，其他DQL常用的保留字有WHERE、ORDER BY、GROUP BY和HAVING。这些单词就是我们这一节要学习的SQL语句，进行查询。

这些DQL保留字常与其他类型的SQL语句一起使用。具体语句示例如下：

```plain
# 登录数据库
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# mysql -S /data/3307/mysql.sock
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
[root@mysql-server56 ~]# mysql -pyuchao7777 -S /data/3307/mysql.sock
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# 这句SQL翻译是从mysql库下的user表，查询user、host字段的数据、且对user排序
# 这就像我们用excel一样
mysql> select user,host from mysql.user order by user;
+------+----------------+
| user | host           |
+------+----------------+
|      | localhost      |
|      | mysql-server56 |
| root | localhost      |
| root | mysql-server56 |
| root | 127.0.0.1      |
| root | ::1            |
| root | %              |
+------+----------------+
7 rows in set (0.00 sec)
```

### DML数据操作语言
DML，全称为Data Manipulation Language，中文为数据操作语言。

其语句的关键字为INSERT、UPDATE和DELETE。它们分别用于添加、修改和删除表中的行（数据）。具体语句示例如下：

```plain
# 删除这些无用的用户
# 发现删除了2个空用户
mysql> delete from mysql.user where user=' ';
Query OK, 2 rows affected (0.00 sec)

mysql> delete from mysql.user where user='root' and host='mysql-server56';
Query OK, 1 row affected (0.00 sec)

mysql> delete from mysql.user where user='root' and host='::1';
Query OK, 1 row affected (0.00 sec)

# 剩下来的用户
mysql> select user,host from mysql.user order by user;
+------+-----------+
| user | host      |
+------+-----------+
| root | localhost |
| root | 127.0.0.1 |
| root | %         |
+------+-----------+
3 rows in set (0.00 sec)
```

有些我们后期再学习，前期对于运维而言，了解即可

### TPL事务
全称为Transaction Processing Language，TPL语句用于确保被DML语句影响的表的所有行能够及时得到更新。TPL语句包括BEGIN TRANSACTION、COMMIT和ROLLBACK。

---

### DCL授权控制
全称为Data Control Language，这类语句通过GRANT或REVOKE授权用户许可，确定单个用户和用户组对数据库对象的访问。

某些RDBMS可用GRANT或REVOKE控制对表中单个列的访问。

```plain
mysql> create user pyyu@'%' identified by 'pyyu668';
Query OK, 0 rows affected (0.01 sec)

# 普通用户被创建的时候，默认有USAGE权限，只能用于登录数据库，无其他权限
mysql> show grants for pyyu@'%';
+-----------------------------------------------------------------------------------------------------+
| Grants for pyyu@%                                                                                   |
+-----------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'pyyu'@'%' IDENTIFIED BY PASSWORD '*4896EFB7643861D41A6BF9CD6FF012B785508323' |
+-----------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

# 只给pyyu用户查看luffy数据库的查询权限
mysql> grant select on luffy.* to 'pyyu'@'%' with grant option;
Query OK, 0 rows affected (0.00 sec)

# 查询该用户的权限
mysql> show grants for pyyu@'%';
+-----------------------------------------------------------------------------------------------------+
| Grants for pyyu@%                                                                                   |
+-----------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'pyyu'@'%' IDENTIFIED BY PASSWORD '*4896EFB7643861D41A6BF9CD6FF012B785508323' |
| GRANT SELECT ON `luffy`.* TO 'pyyu'@'%' WITH GRANT OPTION                                           |
+-----------------------------------------------------------------------------------------------------+
2 rows in set (0.00 sec)
```

### DDL数据定义
全称为Data Definition Language，其语句包括动词CREATE、DROP和ALTER。可使用该语言在数据库中创建新库表或删除库表，或者为表添加字段、索引等。

```plain
# 这句SQL意为创建luffy数据库，且设置数据库编码为utf8，且大小写不敏感，a和A一样处理
mysql> create database  if not exists luffy default charset utf8 collate utf8_general_ci;
Query OK, 1 row affected (0.01 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| luffy              |
| mysql              |
| performance_schema |
| test               |
+--------------------+
5 rows in set (0.01 sec)
```

### CCL指针控制语言
CCL，全称为CURSOR Control Language，它的语句（像DECLARE CURSOR、FETCH INTO和UPDATE WHERE CURRENT）用于对一个或多个表的单独行进行操作。

### 运维和开发--SQL
运维主要关心数据库的架构维护、数据备份、基础数据的管理、但是一般不会修改数据表的结构

主要以DDL类别工作为主，也就是数据定义，运维和开发都得掌握

+ create
+ alter
+ drop

查看DDL语句具体信息

```plain

mysql> ? Data Definition
You asked for help about help category: "Data Definition"
For more information, type 'help <item>', where <item> is one of the following
topics:
   ALTER DATABASE
   ALTER EVENT
   ALTER FUNCTION
   ALTER LOGFILE GROUP
   ALTER PROCEDURE
   ALTER SERVER
   ALTER TABLE
   ALTER TABLESPACE
   ALTER VIEW
   CONSTRAINT
   CREATE DATABASE
   CREATE EVENT
   CREATE FUNCTION
   CREATE INDEX
   CREATE LOGFILE GROUP
   CREATE PROCEDURE
   CREATE SERVER
   CREATE TABLE
   CREATE TABLESPACE
   CREATE TRIGGER
   CREATE VIEW
   DROP DATABASE
   DROP EVENT
   DROP FUNCTION
   DROP INDEX
   DROP PROCEDURE
   DROP SERVER
   DROP TABLE
   DROP TABLESPACE
   DROP TRIGGER
   DROP VIEW
   RENAME TABLE
   TRUNCATE TABLE
```

DCL数据授权控制，一般是运维操作的多些

+ grant
+ revoke
+ commit
+ Rollback

```plain
mysql> ? Account Management
You asked for help about help category: "Account Management"
For more information, type 'help <item>', where <item> is one of the following
topics:
   ALTER USER
   CREATE USER
   DROP USER
   GRANT
   RENAME USER
   REVOKE
   SET PASSWORD
```

开发要重点掌握的SQL，运维熟悉就好，也就是DML数据操作语言，因为网站有各式各样的数据写入、数据读取操作，这是开发对于表的设计，是开发必须重点掌握的技能。

运维无须像开发一样，了解各种业务表的结构、设计，只需要熟悉查询数据操作。

也就是DML语句

+ select
+ insert
+ delete
+ update

```plain
mysql> ? Data Manipulation
You asked for help about help category: "Data Manipulation"
For more information, type 'help <item>', where <item> is one of the following
topics:
   CALL
   DELETE
   DO
   DUAL
   HANDLER
   INSERT
   INSERT DELAYED
   INSERT SELECT
   JOIN
   LOAD DATA
   LOAD XML
   REPLACE
   SELECT
   UNION
   UPDATE
```

### 查看帮助

```plain
mysql> ? CREATE DATABASE
Name: 'CREATE DATABASE'
Description:
Syntax:
CREATE {DATABASE | SCHEMA} [IF NOT EXISTS] db_name
    [create_specification] ...

create_specification:
    [DEFAULT] CHARACTER SET [=] charset_name
  | [DEFAULT] COLLATE [=] collation_name

CREATE DATABASE creates a database with the given name. To use this
statement, you need the CREATE privilege for the database. CREATE
SCHEMA is a synonym for CREATE DATABASE.

URL: http://dev.mysql.com/doc/refman/5.6/en/create-database.html
```

## SQL语法解析原理
目前大家都知道输入一段正确的SQL语句，mysql就可以执行，拿到结果，那么这个背后，发生了什么，听超哥给大家聊聊。

也就是你输入mysql的连接命令，连接成功后，输入SQL，这期间底层发生了什么。

大致顺序是

1.应用程序连接mysql，建立连接

2.SQL进行解析

3.进入存储引擎找数据，在磁盘、内存中读取数据，依次返回

4.数据返回给用户

### 图解

<!-- OCR_START -->
- aP
- SQL解析器原理流程
- Connection layer
- SQL layer
- Parser
- Qvery Execction
- Authorzaton
- Query Cache
- Mysald
- 4 Optimizer
- Query Logging
- Storage engine
- layer
- Disk
- Memory
- Wetwork
- 超哥带你学mysql
- SQL
- parsing begins
- yes
- select
- no
- Parsing qveries
- Check cache
- Optimizing Queries
- Findl
- Executing Qveries
- Update Cache
- Parsing Completed
<!-- OCR_END -->

### SQL解析流程
+ 连接层
- 应用程序（php，python，代码）连接mysql时，首先会进过连接池（创建数据库连接是很耗时且消耗资源的，数据库会提供连接池，保持连接，允许应用程序重复使用一个现有的连接，无须重复新建，省资源，减轻数据库压力），建立连接后，进入SQL解析层
+ SQL层
- 这一层是解析SQL语句，首先判断SQL正确性，是否符合DDL、DML、DCL语句规则
- 根据不同的类型，命令分发模块转发给对应的模块处理
        * 例如接收的是select语句，就是DML查询，既然查询，就会去查找是否有缓存
            + 有缓存则直接返回给应用程序
            + 如果没有缓存，就进入了SQL的解析流程(Parsing queries)
- 解析这件事由Parser解析器来对SQL进行词法分析（因为SQL可以是一个组合的，复杂、较长的语句），最终分析出一个或者多个SQL语句的执行计划
- 得到执行计划后，还不会立即执行，因为解析器可能给出了SQL的多种执行方式，还要再进一步的判断，怎么执行才是最高效的。
        * mysql内部有一个查询优化器（Optimizer）根据自身的算法，找到一个最高效的方式执行SQL（例如有合理索引的那一条SQL）
- 当优化器确定了执行计划，是不是就可以立即执行了?不是。。（大家可能回郁闷了，超哥你这么墨迹呢？）因为即使你确定了SQL可以执行了，但是你是不是有权限执行，对把。
- 在SQL层内部对权限也检查后，SQL语句终于执行了，最后把执行后的结果，交给最底层的存储引擎接口（发动机），存储引擎和操作系统交互，读取到磁盘上的数据（发动机喝油开始干活了）。
- 最终SQL执行完毕，本次获取的数据，常规下更新到缓存中，便于下次加速查询。

这个查询过程的原理，是希望大家心中有个概念，查询过程会发生什么事，具体落地到操作，mysql还提供了大量的SQL语句，提供我们对数据库进行性能分析。后面超哥会给大家讲！！

## 王者荣耀与SQL
确保mysql正确启动

## DDL管理数据库
DDL的特点是对数据库内部的对象进行创建、修改、删除等操作，不涉及对表中内容的操作和更改。这部分是运维人员或DBA需要熟练掌握的内容，开发人员了解即可。

创建数据库

不得已数字开头，大小写不敏感

```plain
mysql> create database  if not exists kings default charset utf8 collate utf8_general_ci;
Query OK, 1 row affected (0.00 sec)

# 表示影响了一行数据
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |    # 系统自带库，存储数据库内置信息
| kings                |
| luffy              |
| mysql              |    # 自带库，存储用户信息，授权等
| performance_schema |    # 存储和性能相关的数据
| test               | 
+--------------------+
6 rows in set (0.00 sec)

# 如何超哥刚才创建数据库信息
mysql> help show create database

# 查看lol数据库信息，\G是格式化结果
mysql> show create database kings\G
*************************** 1. row ***************************
       Database: kings
Create Database: CREATE DATABASE `kings` /*!40100 DEFAULT CHARACTER SET utf8 */
1 row in set (0.00 sec)
# 等于

mysql> show create database kings;
+----------+--------------------------------------------------------------+
| Database | Create Database                                              |
+----------+--------------------------------------------------------------+
| kings      | CREATE DATABASE `kings` /*!40100 DEFAULT CHARACTER SET utf8 */ |
+----------+--------------------------------------------------------------+
1 row in set (0.00 sec)
```

### 字符集问题
我们如果想正确的读写mysql的中文数据，需要保证服务端、客户端的字符集一致

服务端是我们的mysql，客户端的形式有很多了，可能是xshell，navicat，程序等等

服务端mysql的编码设置与查看

```plain
# 查看mysql支持哪些字符集
mysql> show character set;
```

在超哥开始带着大家编译安装mysql的时候，编译参数里，有指定编码

```plain
cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.6.40 \
-DMYSQL_DATADIR=/application/mysql-5.6.40/data \
-DMYSQL_UNIX_ADDR=/application/mysql-5.6.40/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \   # 告诉mysql创建数据库时默认的字符集
-DDEFAULT_COLLATION=utf8_general_ci \    # 创建数据库时默认的字符集校对规则，如大小写不敏感
```

查看当前mysql的默认字符集，由于超哥这里，用的是二进制安装包的mysql，默认字符集是latin1

  

```plain
# 查看当前的mysql编码
mysql> show variables like 'char%';
+--------------------------+------------------------------------------------------------------+
| Variable_name            | Value                                                            |
+--------------------------+------------------------------------------------------------------+
| character_set_client     | utf8                                                             |
| character_set_connection | utf8                                                             |
| character_set_database   | latin1                                                           |
| character_set_filesystem | binary                                                           |
| character_set_results    | utf8                                                             |
| character_set_server     | latin1                                                           |
| character_set_system     | utf8                                                             |
| character_sets_dir       | /application/mysql-5.6.40-linux-glibc2.12-x86_64/share/charsets/ |
+--------------------------+------------------------------------------------------------------+
8 rows in set (0.00 sec)
```

字符集的查看我们先说到这，后面会专门讲解字符集的统一设置，这里由于我们还没学习SQL语句，还无法操作。

### 查看王者荣耀数据库
show 语句

查看、展示某些内容

```plain
create database  if not exists K8S default charset utf8 collate utf8_general_ci;

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| kings              |
| k8s                |
| luffy              |
| mysql              |
| performance_schema |
| test               |
+--------------------+
6 rows in set (0.00 sec)

# 与show命令有关的帮助
mysql> help show

# % 是通配符，匹配以k开头，符合的数据库
mysql> show databases like 'k%';
+---------------+
| Database (k%) |
+---------------+
| k8s           |
| kings         |
+---------------+
2 rows in set (0.00 sec)
```

## 切换数据库
切换，就像cd命令一样，对目录、路径的切换，只不过在mysql里，不认识shell命令，只认识SQL语句；

```plain
# 查看当前在哪一层数据库，类似pwd命令概念
# 默认为NULL空
mysql> select database();
+------------+
| database() |
+------------+
| NULL       |
+------------+
1 row in set (0.00 sec)

mysql> use kings;
Database changed

# 这就是已经在库里了
mysql> select database();
+------------+
| database() |
+------------+
| kings      |
+------------+
1 row in set (0.00 sec)
```

## 查看库中信息
一、进入数据库查看库信息

```plain
mysql> use kings;
Database changed
# 目前这个文件夹kings，里面还没有table
mysql> show tables;
Empty set (0.00 sec)
```

二、在库外面直接查看库中信息

```plain
# 这里也是没有表
mysql> show tables from luffy;
Empty set (0.00 sec)
```

三、基于通配符的查看数据表

首先我们需要创建一些数据表，创建数据表有两个写法，一个简写，一个完整写法

超哥希望大家，尽量在创建数据表、库时，使用英文名，table中的数据可以用中文。

数据，翻译给大家了  

```plain
Tanks               坦克
Warrior             战士
Assassin       刺客
Mage           法师
Archer         射手
Assist         辅助
```

查询SQL

```plain
# 得先进入数据库，才能创建表
use kings;

# 缩写
create table table_name(column_name column_type);

# 完整
create table if not exists `Assist`(
    id int unsigned  auto_increment,
    name varchar(100) not null,
    skills varchar(255) not null,
    price int not null,
    PRIMARY KEY (id)
)engine=innodb default charset=utf8;

create table if not exists `Archer`(
    id int unsigned auto_increment,
    name varchar(100) not null,
    skills varchar(255) not null,
    price int not null,
    PRIMARY KEY (id)
)engine=innodb default charset=utf8;

# 查询table，以大写A开头的表
mysql> show tables from kings like 'A%';
+----------------------+
| Tables_in_kings (A%) |
+----------------------+
| Archer               |
| Assist               |
+----------------------+
2 rows in set (0.01 sec)
```

## Drop语句
```plain
# 删除数据库
mysql> drop database lol;
Query OK, 0 rows affected (0.00 sec)

# 如果不存在的话
mysql> drop database lol;
ERROR 1008 (HY000): Can't drop database 'lol'; database doesn't exist

mysql> drop database test;
Query OK, 0 rows affected (0.00 sec)

# 删除table
# 注意是区分大小写的

mysql> use kings;
Database changed
mysql> show tables;
+-----------------+
| Tables_in_kings |
+-----------------+
| Archer          |
| Assist          |
+-----------------+
2 rows in set (0.00 sec)

mysql> drop table Archer;
Query OK, 0 rows affected (0.00 sec)

mysql> drop table assist;
ERROR 1051 (42S02): Unknown table 'kings.assist'
mysql> drop table Assist;
Query OK, 0 rows affected (0.01 sec)
```

有关drop语句的帮助

```plain
mysql> help drop
Many help items for your request exist.
To make a more specific request, please type 'help <item>',
where <item> is one of the following
topics:
   ALTER TABLE
   ALTER TABLESPACE
   DEALLOCATE PREPARE
   DROP DATABASE
   DROP EVENT
   DROP FUNCTION
   DROP FUNCTION UDF
   DROP INDEX
   DROP PROCEDURE
   DROP SERVER
   DROP TABLE
   DROP TABLESPACE
   DROP TRIGGER
   DROP USER
   DROP VIEW
```

## DCL用户管理
对于数据库的维护，我们不能只用一个root用户去维护，必然应该用其他普通用户，且进行权限控制，加大数据库的安全性。

备注，超哥当前用的是root用户，权限最大

查看现有数据库用户  
 

```plain
# 查询mysql库中的user表，只看user，host两个信息
mysql> select user,host from mysql.user;
+------+-----------+
| user | host      |
+------+-----------+
| pyyu | %         |
| root | %         | # 这个用于远程登录
| root | 127.0.0.1 | # 别删
| root | localhost | # 别删
+------+-----------+
4 rows in set (0.00 sec)
```

### 创建mysql用户
语法

```plain
create user 'user'@'host' identified by '用户登录密码';
创建     用户   用户名@允许从哪登录     设定密码  "chaoge888";
```

创建用户

```plain
mysql> create user chaochao@'127.0.0.1' identified by 'chaochao888';

mysql> select user,host from mysql.user;
+----------+-----------+
| user     | host      |
+----------+-----------+
| pyyu     | %         |
| root     | %         |
| chaochao | 127.0.0.1 |
| root     | 127.0.0.1 |
| root     | localhost |
+----------+-----------+
5 rows in set (0.00 sec)
```

  
工作里创建用户，一般是只允许一个内网登录，可以设置不同的网段

如当前超哥讲课的linux局域网段

+ 10.211.55.% （SQL最常用的通配符就是%了，它表示任意字符的匹配，且不计字符的多少）

创建用户cc，只允许在10.211.55.0/24网段内访问机器  

```plain
mysql> create user cc@'10.211.55.%' identified by 'cc888';
Query OK, 0 rows affected (0.00 sec)
```

登录测试cc用户

```plain
# 上面限制了，只允许cc用户在该网段内登录mysql

# 错误的登录方式
# 这里超哥见到过N个同学，在这里出错，还不知道为什么
[root@mysql-server56 ~]# mysql -ucc -h127.0.0.1  -P3307 -pcc888
Warning: Using a password on the command line interface can be insecure.
ERROR 1045 (28000): Access denied for user 'cc'@'localhost' (using password: YES)

# 正确方式
# 得指定服务器地址
# 因为我们这是在linux本地登录，也就是局域网内了
[root@mysql-server56 ~]# mysql -ucc -h10.211.55.12  -P3307 -pcc888

# 如果不在这个网段内，就无法登录了
```

  

### grant语句
默认创建的用户是没有权限的，只有usage登录

grant也可以用于创建用户  

```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 24
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> grant usage on kings.* to 'yuyu'@'127.0.0.1' identified by 'yuyu888';
Query OK, 0 rows affected (0.01 sec)

# 查看该用户的权限信息
mysql> show grants for 'yuyu'@'127.0.0.1';
+-------------------------------------------------------------------------------------------------------------+
| Grants for yuyu@127.0.0.1                                                                                   |
+-------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'yuyu'@'127.0.0.1' IDENTIFIED BY PASSWORD '*A85393C05785337B86D834475B9D90C9CCED1DB9' |
+-------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

  

### 删除用户
语法

```plain
drop user 'user'@'主机域';  # 单引号

# 当前用户
mysql> select user,host from mysql.user;
+----------+-------------+
| user     | host        |
+----------+-------------+
| pyyu     | %           |
| root     | %           |
| cc       | 10.211.55.% |
| chaochao | 127.0.0.1   |
| root     | 127.0.0.1   |
| yuyu     | 127.0.0.1   |
| root     | localhost   |
+----------+-------------+
7 rows in set (0.01 sec)

# 删除这些无用的用户
mysql> drop user 'pyyu'@'%';
Query OK, 0 rows affected (0.00 sec)

mysql> drop user 'cc'@'10.211.55.%';
Query OK, 0 rows affected (0.00 sec)

mysql> drop user 'chaochao'@'127.0.0.1';
Query OK, 0 rows affected (0.00 sec)

mysql> drop user 'yuyu'@'127.0.0.1';
Query OK, 0 rows affected (0.00 sec)

mysql> select user,host from mysql.user;
+------+-----------+
| user | host      |
+------+-----------+
| root | %         |
| root | 127.0.0.1 |
| root | localhost |
+------+-----------+
3 rows in set (0.00 sec)

mysql 新设置用户或更改密码后需用flush privileges刷新MySQL的系统权限相关表

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

谨记：如果drop删除用户报错，那就是你的SQL语法不正确

也可以用如下SQL删除用户，delete语句

```plain
mysql> select user,host from mysql.user;
+------+-----------+
| user | host      |
+------+-----------+
| root | %         |
| root | 127.0.0.1 |
| root | localhost |
+------+-----------+
3 rows in set (0.00 sec)

mysql>
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> delete from mysql.user where user='root' and host='%';
Query OK, 1 row affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> select user,host from mysql.user;
+------+-----------+
| user | host      |
+------+-----------+
| root | 127.0.0.1 |
| root | localhost |
+------+-----------+
2 rows in set (0.00 sec)
```

## 授权用户
我们已知默认create创建的用户是没有权限的，因此得grant给它点权限。

```plain
语法

mysql> help grant
省略。。
部分
xample:

CREATE USER 'jeffrey'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON db1.* TO 'jeffrey'@'localhost';
GRANT SELECT ON db2.invoice TO 'jeffrey'@'localhost';
GRANT USAGE ON *.* TO 'jeffrey'@'localhost' WITH MAX_QUERIES_PER_HOUR 90;
```

### 实践grant
刚才讲过了，grant可以直接创建用户，且授权

只允许yuyu用户在kings库中，执行select命令

```plain
grant select on kings.* to 'yuyu'@'127.0.0.1' identified by 'yuyu888';

```

登录验证，看看yuyu用户有没有其他权限

```plain
[root@mysql-server56 ~]# mysql -h127.0.0.1 -P3307 -uyuyu -pyuyu888
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 34
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| kings              |
+--------------------+
2 rows in set (0.00 sec)

mysql> use kings;
Database changed
mysql> show tables;
Empty set (0.00 sec)

# 无法创建
mysql> create table t1(id int,name varchar(50));
ERROR 1142 (42000): CREATE command denied to user 'yuyu'@'localhost' for table 't1'
```

### 给与最大权限
创建pyyu1用户，可以对kings数据库有最大管理权限，只允许从localhost登录(无法远程登录了)

注意，只能用root用户有权限创建用户  

```plain
grant all privileges on kings.* to 'pyyu1'@'localhost' identified by 'pyyu1888';

```

测试登录pyyu1

```plain
# 授权的是localhost，其实就是127.0.0.1地址
[root@mysql-server56 ~]# mysql -upyyu1 -ppyyu1888 -P3307 -h127.0.0.1
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 38
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| kings              |
+--------------------+
2 rows in set (0.00 sec)

mysql> use kings;
Database changed
mysql> create table t1(id int,name varchar(50));
Query OK, 0 rows affected (0.02 sec)

mysql> show tables;
+-----------------+
| Tables_in_kings |
+-----------------+
| t1              |
+-----------------+
1 row in set (0.00 sec)
```

### 再造一个root出来
先查看当前的root权限  

```plain
mysql> select user,host from mysql.user;
+-------+-----------+
| user  | host      |
+-------+-----------+
| root  | 127.0.0.1 |
| yuyu  | 127.0.0.1 |
| pyyu1 | localhost |
| root  | localhost |
+-------+-----------+
4 rows in set (0.00 sec)

# 当前root用的权限
mysql> show grants for root@localhost;
+----------------------------------------------------------------------------------------------------------------------------------------+
| Grants for root@localhost                                                                                                              |
+----------------------------------------------------------------------------------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY PASSWORD '*A8A6AD538208D0FB857334608F3D0C567942BDD4' WITH GRANT OPTION |
| GRANT PROXY ON ''@'' TO 'root'@'localhost' WITH GRANT OPTION                                                                           |
+----------------------------------------------------------------------------------------------------------------------------------------+
2 rows in set (0.00 sec)
```

### with grant option
创建一个和root一样大权力的system用户

这个语句的作用是，可以将自己的权限，传递给其他用户

超哥给的system的权限是all privileges，表示所有权限，并且通过with grant option功能，表示system用户也可以给与其他用户最大权限，也就是root的作用。

```plain
mysql> grant all privileges on *.* to 'system'@'localhost' identified by 'system888' with grant option;
Query OK, 0 rows affected (0.00 sec)

mysql> show grants for system@localhost;
+------------------------------------------------------------------------------------------------------------------------------------------+
| Grants for system@localhost                                                                                                              |
+------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'system'@'localhost' IDENTIFIED BY PASSWORD '*C67D76406C2DD435C4092A5A42A5C86F943856B4' WITH GRANT OPTION |
+------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

### grant proxy
MySQL的用户权限管理一般都是通过User+Host的形式来区分不同的用户权限，当用户数一多，逐一去修改权限就变得较为繁琐。

有时很多用户需要的权限极为相似，此时，利用MySQL官方提供的Proxy User功能来实现“用户组权限”进行组内用户权限批量管理。

```plain
# 当前mysql版本
mysql> select version();
+------------+
| version()  |
+------------+
| 5.6.40-log |
+------------+
1 row in set (0.00 sec)

# 创建多个用户
# 且创建代理用户 group1
# 这样group1的权限，会映射给user1 user2 省的有大量用户的时候，权限难以管理
mysql>
mysql> create user 'group1';
Query OK, 0 rows affected (0.00 sec)

mysql> create user 'user1';
Query OK, 0 rows affected (0.00 sec)

mysql> create user 'user2';
Query OK, 0 rows affected (0.00 sec)

mysql> grant proxy on 'group1' to 'user1';
Query OK, 0 rows affected (0.00 sec)

mysql> grant proxy on 'group1' to 'user2';
Query OK, 0 rows affected (0.00 sec)
```

检查所建用户的权限

```plain
mysql> show grants for 'group1';
+------------------------------------+
| Grants for group1@%                |
+------------------------------------+
| GRANT USAGE ON *.* TO 'group1'@'%' |
+------------------------------------+
1 row in set (0.00 sec)

mysql>
mysql> show grants for 'user1';
+--------------------------------------------+
| Grants for user1@%                         |
+--------------------------------------------+
| GRANT USAGE ON *.* TO 'user1'@'%'          |
| GRANT PROXY ON 'group1'@'%' TO 'user1'@'%' |
+--------------------------------------------+
2 rows in set (0.00 sec)

mysql> show grants for 'user2';
+--------------------------------------------+
| Grants for user2@%                         |
+--------------------------------------------+
| GRANT USAGE ON *.* TO 'user2'@'%'          |
| GRANT PROXY ON 'group1'@'%' TO 'user2'@'%' |
+--------------------------------------------+
2 rows in set (0.00 sec)
```

使用新用户登录，但是没有赋予任何权限，看不到其他库，只有一个information_schema

```plain
[root@mysql-server56 ~]# mysql -uuser1 -h127.0.0.1 -P3307
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 40
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
+--------------------+
1 row in set (0.00 sec)
```

此时给我们的组用户group1授权，再看权限

```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 41
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> grant select on *.* to 'group1';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql> show grants for 'group1';
+-------------------------------------+
| Grants for group1@%                 |
+-------------------------------------+
| GRANT SELECT ON *.* TO 'group1'@'%' |
+-------------------------------------+
1 row in set (0.00 sec)
```

此时此刻，group1组用户多了select权限，user1、user2是看不出变化的。

再用user1、组内用户登录，看看权限  

```plain
[root@mysql-server56 ~]# mysql -uuser1 -h127.0.0.1 -P3307
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 42
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
+--------------------+
1 row in set (0.00 sec)
```

此时发现，并没有发生权限变化。

这是因为这个功能只在mysql5.7之后可用，我们这里的5.6无法使用，虽然说mysql有显示grant proxy

解释

基于mysql_native_password的认证插件自带了代理用户的功能。代理用户相当于“代理”其他用户的权限，这样很方便的把一个账号的权限授予其他账号，而不需要每个账号都需要执行授权操作。开启代理用户的功能需要开启参数：[check_proxy_users](https://dev.mysql.com/doc/refman/5.7/en/proxy-users.html) 和 mysql_native_password_proxy_users  
  

```plain
# mysql 5.7的显示
mysql> show variables like "%proxy%";
+-----------------------------------+-------+
| Variable_name                     | Value |
+-----------------------------------+-------+
| check_proxy_users                 | OFF   |
| mysql_native_password_proxy_users | OFF   |
| proxy_user                        |       |
| sha256_password_proxy_users       | OFF   |
+-----------------------------------+-------+
4 rows in set (0.00 sec)
```

### 创建用户且设置密码
注意localhost是被dns解析后出的127.0.0.1，也只能本地访问  
 

```plain
mysql> create user 'cc'@'localhost' identified by 'cc888';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

希望局域网内访问就是

```plain
mysql> create user 'cc1'@'10.211.55.%' identified by 'cc1888';
Query OK, 0 rows affected (0.00 sec)
```

若是希望外网用户也可以访问，例如服务器上的mysql

```plain
create user 'cc2'@'%' identified by 'cc1888';

```

此时检查用户

```plain
mysql> select user,host from mysql.user;
+--------+-------------+
| user   | host        |
+--------+-------------+
| cc2    | %           |
| group1 | %           |
| user1  | %           |
| user2  | %           |
| cc1    | 10.211.55.% |
| root   | 127.0.0.1   |
| yuyu   | 127.0.0.1   |
| cc     | localhost   |
| pyyu1  | localhost   |
| root   | localhost   |
| system | localhost   |
+--------+-------------+
11 rows in set (0.00 sec)
```

### 权限列表
```plain
mysql> show grants for 'cc2'@'%';
+----------------------------------------------------------------------------------------------------+
| Grants for cc2@%                                                                                   |
+----------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'cc2'@'%' IDENTIFIED BY PASSWORD '*16932EF14224F810F27C01DE21AB5522C07BD695' |
+----------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

# 授予最高权限
mysql> grant all privileges on *.* to 'cc2'@'%';
Query OK, 0 rows affected (0.00 sec)

mysql> show grants for 'cc2'@'%';
+-------------------------------------------------------------------------------------------------------------+
| Grants for cc2@%                                                                                            |
+-------------------------------------------------------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'cc2'@'%' IDENTIFIED BY PASSWORD '*16932EF14224F810F27C01DE21AB5522C07BD695' |
+-------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

看这里很有意思，cc2用户有所有的权限，我们单独去掉一个select权限，再来看

### 移除权限
revoke语句

```plain
# 语法revoke
mysql> revoke select on *.* from 'cc2'@'%';
Query OK, 0 rows affected (0.00 sec)

mysql> show grants for 'cc2'@'%';
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Grants for cc2@%                                                                                                                                                                                                                                                                                                                                                                                                 |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE ON *.* TO 'cc2'@'%' IDENTIFIED BY PASSWORD '*16932EF14224F810F27C01DE21AB5522C07BD695' |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql>
```

我们会发现all privileges被拆分为了如上的那么多权限，更细力度的。

<!-- OCR_START -->
- 权限
- 说明
- SELECT
- 查询 (数据)
- INSERT
- 插人 (数据)
- UPDATE
- 修改 (数据)
- DELETE
- 删除 (数据)
- CREATE
- 创建(数据库、表等对象)
- DROP
- 删除（数据库、表等对象)
- RELOAD
- 重载
- SHUTDOWN
- 关闭
- PROCESS
- 进程
- FILE
- 文件
- REFERENCES
- 参考资料
- INDEX
- 索引
- ALTER
- 修改(数据库、表等对象)
- SHOWDATABASES
- 查看数据库
- SUPER
- 超级权限
- CREATETEMPORARYTABLES
- 创建临时表
- LOCKTABLES
- 锁表
- EXECUTE
- 执行
- REPLICATIONSLAVE
- 从复制权限
- REPLICATIONCLIENT
- 从客户端复制
- CREATEVIEW
- 创建视图
- SHOWVIEW
- 查看视图
- CREATEROUTINE
- 创建存储过程
- ALTERROUTINE
- 修改存储过程
- CREATE USER
- 创建用户
- EVENT
- 事件
- TRIGGER
- 触发器
- CREATETABLESPACE
- 创建表空间
<!-- OCR_END -->

  
   

# MySQl核心SQL语句2
## grant授权实践
创建用于测试环境使用的账号，不能给与all privileges权限，只能给与单个，用于DML场景的语句，比如select,insert,update,delete适合web

因为一般开发工程师、测试工程师，会需要测试读写数据库，例如对网站登录功能，注册功能测试，那就得写入数据，读取数据。

我们可以通过各种各种语言，开发数据库数据读写操作。  

```plain
# 清空之前创建的测试用户
mysql> select user,host from mysql.user;
+------+-----------+
| user | host      |
+------+-----------+
| root | 127.0.0.1 |
| root | localhost |
+------+-----------+
2 rows in set (0.00 sec)

# 创建用户，授权
mysql> grant select,insert,update,delete on kings.* to pyyu@'10.211.55.%' identified by 'pyyu888';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

# 授权几大特性
```

授权几大特性

+ 权限不要轻易用all，安全性太低，应该使用select、insert、update、delete等具体权限
+ 主机范围尽量不用%，应该设置具体的网段
+ 库的选择也不用*，应该指定具体的库、表

python读取数据库，注意，只有查询、插入、更新、删除四个权限

准备好测试数据，创建数据表，用代码插入数据  

```plain
# 创建英雄表
mysql> create table heros(id int,name varchar(50));
Query OK, 0 rows affected (0.01 sec)

mysql> desc heros;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | YES  |     | NULL    |       |
| name  | varchar(50) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

# 默认是没数据的
mysql> select * from kings.heros;
Empty set (0.00 sec)
```

安装pymysql模块

```plain
[root@mysql-server56 ~]# pip3 install pymysql
WARNING: Running pip install with root privileges is generally not a good idea. Try `pip3 install --user` instead.
Collecting pymysql
  Downloading https://files.pythonhosted.org/packages/4f/52/a115fe175028b058df353c5a3d5290b71514a83f67078a6482cff24d6137/PyMySQL-1.0.2-py3-none-any.whl (43kB)
    100% |████████████████████████████████| 51kB 238kB/s
Installing collected packages: pymysql
Successfully installed pymysql-1.0.2
```

代码

```plain
import pymysql  
# 连接
# 使用该普通用户，连接数据库写入数据
conn = pymysql.Connect(host="10.211.55.12", port=3307, user="pyyu",
                       passwd="pyyu888",db="kings")
# 创建游标
cursor = conn.cursor()

# 插入数据
sql="insert into heros(id,name) values('1','孙悟空')"

#执行sql，并返回受影响行数
rows = cursor.execute(sql)
print(f"插入了{rows}行数据")

# 执行查询SQL
cursor.execute("select * from heros;")
print(f"查出的结果是：{cursor.fetchall()}")

# 提交事务
conn.commit()
# 关闭游标
cursor.close()
# 关闭连接
conn.close()
```

执行结果

```plain
[root@mysql-server56 ~]# python3 python_mysql.py
插入了1行数据
查出的结果是：((1, '孙悟空'),)
```

再来mysql中查询数据

```plain
mysql> select * from kings.heros;
+------+-----------+
| id   | name      |
+------+-----------+
|    1 | 孙悟空    |
+------+-----------+
1 row in set (0.01 sec)
```

数据已插入表中

## 博客产品
上一个实践，是针对如网站登录注册的场景，对数据库进行读写测试，账号权限给的较低。

又比如有很多开源软件的博客产品，在安装期间会需要初始化安装数据库，也可以有删除数据库。

因此需要增加create,drop权限，如

```plain
# 例如创建blog数据库，允许用户在库中建表

mysql> grant select,insert,update,delete,create,drop on blog.* to 'blog_user'@'10.211.55.%' identified by 'blog888';
Query OK, 0 rows affected (0.00 sec)
```

## 只读权限
在很多场景下，我们只会给一些账号，只读的权限，这很重要，例如后面的读写分离，例如给开发人员的测试账号，尽量不给select以外的权限，省的运维背黑锅！  

```plain
grant select on 'blog'.* to 'blog'@'10.211.55.%' identified by 'blog888';

```

## 创建数据表

<!-- OCR_START -->
- 英雄介绍
- 英雄
- 局内道具
- 召唤师技能
- 综合
- 本周免费
- 新手推荐
- 定位
- 全部
- 坦克
- 战士
- 刺客
- 法师
- 射手
- 辅助
- 请输入你想要搜索的英雄名
- 艾琳
- 司空震
- 夏洛特
- 阿古朵
- 蒙恬
- 鲁班大师
- 西施
- 马超
- 云中君
- 盘古
- 猪八戒
- 上官婉儿
- 李信
- 沈梦溪
- 伽罗
- 盾山
- 司马懿
- 孙策
- 元歌
- 米莱狄
- 狂铁
- 奔星
- 裴擒虎
- 杨玉环
- 公孙离
- 明世隐
- 百里守约
- 干将草邪
<!-- OCR_END -->

创建数据表，语法  

```plain
create table <表名> (
    字典名 类型,
    字段名2 类型,
)
```

### 创建英雄表
```plain
Tanks               坦克
Warrior             战士
Assassin       刺客
Mage           法师
Archer         射手
Assist         辅助
```

创建数据表，坦克表，  

```plain
use kings;

create table if not exists `Tanks`(
    id int unsigned  auto_increment,
    name varchar(100) not null,
    skills varchar(255) not null,
    price int not null,
    PRIMARY KEY (id)
)engine=innodb default charset=utf8;

# 解释
# 这里的`create table`是固定关键字，创建table，`Tanks`是表名，`if not exists`是更专业的写法，判断该table是否存在，不存在则创建。
create table if not exists `Tanks`(
  # 英雄序号，数字类型，无符号， 既为非负数，自动递增+1
    id int unsigned  auto_increment,
    # 英雄名字字段，100长度的变长字符类型varchar，还有一种char(定长)
    name varchar(100) not null,
    # 英雄介绍 ，不得为空
    introduction varchar(255) not null,
    # 价格 
    price int not null,
    # 这里是设置一个主键，后面再给大家介绍
    PRIMARY KEY (id)
    # 设置mysql数据库的引擎，默认字符集是utf8
)engine=innodb default charset=utf8;
```

### 查看table结构
```plain
mysql> desc Tanks;
+--------+------------------+------+-----+---------+----------------+
| Field  | Type             | Null | Key | Default | Extra          |
+--------+------------------+------+-----+---------+----------------+
| id     | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| name   | varchar(100)     | NO   |     | NULL    |                |
| skills | varchar(255)     | NO   |     | NULL    |                |
| price  | int(11)          | NO   |     | NULL    |                |
+--------+------------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)
```

无须切换数据库内的方法

```plain
mysql> show columns from kings.Tanks;
+--------+------------------+------+-----+---------+----------------+
| Field  | Type             | Null | Key | Default | Extra          |
+--------+------------------+------+-----+---------+----------------+
| id     | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| name   | varchar(100)     | NO   |     | NULL    |                |
| skills | varchar(255)     | NO   |     | NULL    |                |
| price  | int(11)          | NO   |     | NULL    |                |
+--------+------------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)
```

方法2

```plain
mysql> show full columns from Tanks from kings;
+--------+------------------+-----------------+------+-----+---------+----------------+---------------------------------+---------+
| Field  | Type             | Collation       | Null | Key | Default | Extra          | Privileges                      | Comment |
+--------+------------------+-----------------+------+-----+---------+----------------+---------------------------------+---------+
| id     | int(10) unsigned | NULL            | NO   | PRI | NULL    | auto_increment | select,insert,update,references |         |
| name   | varchar(100)     | utf8_general_ci | NO   |     | NULL    |                | select,insert,update,references |         |
| skills | varchar(255)     | utf8_general_ci | NO   |     | NULL    |                | select,insert,update,references |         |
| price  | int(11)          | NULL            | NO   |     | NULL    |                | select,insert,update,references |         |
+--------+------------------+-----------------+------+-----+---------+----------------+---------------------------------+---------+
4 rows in set (0.00 sec)
```

### 查看建表信息
可以在数据库创建后，通过命令检查建表的SQL，注意区分大小写  

```plain
mysql> show create table Tanks;
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                                                    |
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Tanks | CREATE TABLE `Tanks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `skills` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

### 看一个正式的table语句
```plain
use sns;
set names gbk;
CREATE TABLE `subject_comment_manager` (
  `subject_comment_manager_id` bigint(12) NOT NULL auto_increment COMMENT '主键',
  `subject_type` tinyint(2) NOT NULL COMMENT '素材类型',
  `subject_primary_key` varchar(255) NOT NULL COMMENT '素材的主键',
  `subject_title` varchar(255) NOT NULL COMMENT '素材的名称',
  `edit_user_nick` varchar(64) default NULL COMMENT '修改人',
  `edit_user_time` timestamp NULL default NULL COMMENT '修改时间',
  `edit_comment` varchar(255) default NULL COMMENT '修改的理由',
  `state` tinyint(1) NOT NULL default '1' COMMENT '0代表关闭，1代表正常',
  PRIMARY KEY  (`subject_comment_manager_id`),
  KEY `IDX_PRIMARYKEY` (`subject_primary_key`(32)), #<==括号内的32表示对前
                                                  32个字符做前缀索引。
  KEY `IDX_SUBJECT_TITLE` (`subject_title`(32))
  KEY `index_nick_type` (`edit_user_nick`(32),`subject_type`)
  #<==联合索引，此行为是新加的，用来为大家讲解。实际表语句内没有此行。
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

## 修改数据
rename table  

```plain
mysql> show tables;
+-----------------+
| Tables_in_kings |
+-----------------+
| Tanks           |
| heros           |
| t1              |
+-----------------+
3 rows in set (0.00 sec)

mysql> rename table Tanks to tanks;
Query OK, 0 rows affected (0.01 sec)

mysql> show tables;
+-----------------+
| Tables_in_kings |
+-----------------+
| heros           |
| t1              |
| tanks           |
+-----------------+
3 rows in set (0.00 sec)
```

Alter table

```plain
mysql> alter table heros rename to Heros;
Query OK, 0 rows affected (0.00 sec)

mysql> show tables;
+-----------------+
| Tables_in_kings |
+-----------------+
| Heros           |
| t1              |
| tanks           |
+-----------------+
3 rows in set (0.00 sec)
```

### 修改表字段记录
表中字段

id、名字、技能、价格  

```plain
mysql> desc tanks;
+--------+------------------+------+-----+---------+----------------+
| Field  | Type             | Null | Key | Default | Extra          |
+--------+------------------+------+-----+---------+----------------+
| id     | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| name   | varchar(100)     | NO   |     | NULL    |                |
| skills | varchar(255)     | NO   |     | NULL    |                |
| price  | int(11)          | NO   |     | NULL    |                |
+--------+------------------+------+-----+---------+----------------+
4 rows in set (0.01 sec)
```

### 添加字段
Alter table 表名 add 字段 类型 其他;

添加一个介绍字段introduction varchar(255) not null,

```plain
mysql> alter table tanks add introduction varchar(255) not null;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc tanks;
+--------------+------------------+------+-----+---------+----------------+
| Field        | Type             | Null | Key | Default | Extra          |
+--------------+------------------+------+-----+---------+----------------+
| id           | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| name         | varchar(100)     | NO   |     | NULL    |                |
| skills       | varchar(255)     | NO   |     | NULL    |                |
| price        | int(11)          | NO   |     | NULL    |                |
| introduction | varchar(255)     | NO   |     | NULL    |                |
+--------------+------------------+------+-----+---------+----------------+
5 rows in set (0.01 sec)
```

添加字段到指定位置，加到skills后面

再添加一个"召唤师技能"字段

ENUM字段类型

summoner_skills ENUM('flush','ghost') not null default 'flush' # flush 闪现 ghost 幽灵疾步

```plain
mysql>  alter table tanks add summoner_skills ENUM('flush','ghost') not null default 'flush' after skills;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc tanks;
+-----------------+-----------------------+------+-----+---------+----------------+
| Field           | Type                  | Null | Key | Default | Extra          |
+-----------------+-----------------------+------+-----+---------+----------------+
| id              | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(100)          | NO   |     | NULL    |                |
| skills          | varchar(255)          | NO   |     | NULL    |                |
| summoner_skills | enum('flush','ghost') | NO   |     | flush   |                |
| price           | int(11)               | NO   |     | NULL    |                |
| introduction    | varchar(255)          | NO   |     | NULL    |                |
+-----------------+-----------------------+------+-----+---------+----------------+
6 rows in set (0.00 sec)
```

再添加一个性别字段，在name后面

```plain
mysql> alter table tanks add gender ENUM('male','female') not null after name;
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc tanks;
+-----------------+-----------------------+------+-----+---------+----------------+
| Field           | Type                  | Null | Key | Default | Extra          |
+-----------------+-----------------------+------+-----+---------+----------------+
| id              | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(100)          | NO   |     | NULL    |                |
| gender          | enum('male','female') | NO   |     | NULL    |                |
| skills          | varchar(255)          | NO   |     | NULL    |                |
| summoner_skills | enum('flush','ghost') | NO   |     | flush   |                |
| price           | int(11)               | NO   |     | NULL    |                |
| introduction    | varchar(255)          | NO   |     | NULL    |                |
+-----------------+-----------------------+------+-----+---------+----------------+
7 rows in set (0.01 sec)
```

一次添加2个字段

camp varchar(50) 阵营

pic varchar(255) 头像，存储图片url  

```plain
mysql> alter table tanks add camp varchar(50),add pic varchar(255);
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc tanks;
+-----------------+-----------------------+------+-----+---------+----------------+
| Field           | Type                  | Null | Key | Default | Extra          |
+-----------------+-----------------------+------+-----+---------+----------------+
| id              | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(100)          | NO   |     | NULL    |                |
| skills          | varchar(255)          | NO   |     | NULL    |                |
| summoner_skills | enum('flush','ghost') | NO   |     | flush   |                |
| price           | int(11)               | NO   |     | NULL    |                |
| introduction    | varchar(255)          | NO   |     | NULL    |                |
| camp            | varchar(50)           | YES  |     | NULL    |                |
| pic             | varchar(255)          | YES  |     | NULL    |                |
+-----------------+-----------------------+------+-----+---------+----------------+
8 rows in set (0.00 sec)
```

### 删除字段
删除性别字段

```plain
mysql> alter table tanks drop gender;
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

### 修改字段
可以修改名字，以及数据类型

```plain
mysql> alter table tanks change pic pic_url char(255);
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc tanks;
+-----------------+-----------------------+------+-----+---------+----------------+
| Field           | Type                  | Null | Key | Default | Extra          |
+-----------------+-----------------------+------+-----+---------+----------------+
| id              | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(100)          | NO   |     | NULL    |                |
| skills          | varchar(255)          | NO   |     | NULL    |                |
| summoner_skills | enum('flush','ghost') | NO   |     | flush   |                |
| price           | int(11)               | NO   |     | NULL    |                |
| introduction    | varchar(255)          | NO   |     | NULL    |                |
| camp            | varchar(50)           | YES  |     | NULL    |                |
| pic_url         | char(255)             | YES  |     | NULL    |                |
+-----------------+-----------------------+------+-----+---------+----------------+
8 rows in set (0.00 sec)
```

## 索引
### 创建
mysql的索引功能，是提高mysql查询速度的一大重点，后面我们重点学习原理，这里先了解用法

索引功能，就像一本书的目录，知道目录，可以非常快速找到我们想要的内容在哪

通过给字段添加索引，能够加快该列字段的查询速度。

查看表默认索引

```plain
mysql> show index from tanks\G
*************************** 1. row ***************************
        Table: tanks
   Non_unique: 0
     Key_name: PRIMARY
 Seq_in_index: 1
  Column_name: id
    Collation: A
  Cardinality: 0
     Sub_part: NULL
       Packed: NULL
         Null:
   Index_type: BTREE
      Comment:
Index_comment:
1 row in set (0.00 sec)
```

alter创建索引

给当前的表字段，添加索引

```plain
mysql> alter table tanks add index index_name(name);
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

# 查看索引
mysql> show index from tanks\G
*************************** 1. row ***************************
        Table: tanks
   Non_unique: 0
     Key_name: PRIMARY
 Seq_in_index: 1
  Column_name: id
    Collation: A
  Cardinality: 0
     Sub_part: NULL
       Packed: NULL
         Null:
   Index_type: BTREE
      Comment:
Index_comment:
*************************** 2. row ***************************
        Table: tanks
   Non_unique: 1
     Key_name: index_name
 Seq_in_index: 1
  Column_name: name
    Collation: A
  Cardinality: 0
     Sub_part: NULL
       Packed: NULL
         Null:
   Index_type: BTREE
      Comment:
Index_comment:
2 rows in set (0.00 sec)
```

### 删除索引
```plain
mysql> alter table tanks drop index index_name;
Query OK, 0 rows affected (0.00 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> show index from tanks\G
*************************** 1. row ***************************
        Table: tanks
   Non_unique: 0
     Key_name: PRIMARY
 Seq_in_index: 1
  Column_name: id
    Collation: A
  Cardinality: 0
     Sub_part: NULL
       Packed: NULL
         Null:
   Index_type: BTREE
      Comment:
Index_comment:
1 row in set (0.00 sec)
```

  

## 删除数据
### 删除库、表
删除数据库

```plain
mysql> drop database k8s;
Query OK, 0 rows affected (0.00 sec)
```

删除数据表

```plain
# 查看当前在那个库
mysql> select database();
+------------+
| database() |
+------------+
| kings      |
+------------+
1 row in set (0.00 sec)

# 删除数据表
mysql> show tables;
+-----------------+
| Tables_in_kings |
+-----------------+
| Heros           |
| t1              |
| tanks           |
+-----------------+
3 rows in set (0.00 sec)

mysql> drop table t1;
Query OK, 0 rows affected (0.01 sec)
```

### 删除表数据delete
删除表数据

delete from语句

delete from语句可以使用where对要删除的记录进行选择，delete语句更灵活。

delete是一行一行的删除数据，对于大容量数据表，delete效率较低

delete语句对于带有自增id的列，数据删除后，会保留id的位置  

```plain
# 没有自增的id列
mysql> desc Heros;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | YES  |     | NULL    |       |
| name  | varchar(50) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

# 查看表数据
mysql> select * from Heros;
+------+-----------+
| id   | name      |
+------+-----------+
|    1 | 孙悟空    |
+------+-----------+
1 row in set (0.00 sec)

mysql> delete from Heros;
Query OK, 1 row affected (0.00 sec)

mysql> select * from Heros;
Empty set (0.00 sec)

# 对于有自增id的列
# 给Heros表添加自增id
#

mysql> alter table Heros modify  id int(11)  primary key auto_increment;
Query OK, 1 row affected (0.03 sec)
Records: 1  Duplicates: 0  Warnings: 0
```

### 修改表字段modify
这里学习，如何给一个字段，添加自增属性

```plain
# 给Heros表添加自增id

mysql> alter table Heros modify  id int(11)  primary key auto_increment;
Query OK, 1 row affected (0.03 sec)
Records: 1  Duplicates: 0  Warnings: 0

mysql> desc Heros;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| id    | int(11)     | NO   | PRI | NULL    | auto_increment |
| name  | varchar(50) | YES  |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)
```

### 自增id列保留数值
对于有自增的字段id，数据被delete后，依然会保留id的位置

```plain
mysql> select * from Heros;
+----+--------+
| id | name   |
+----+--------+
|  1 | 锐雯   |
+----+--------+
1 row in set (0.00 sec)

mysql> insert into Heros(name) values('石头人');
Query OK, 1 row affected (0.00 sec)

mysql> insert into Heros(name) values('盖伦');
Query OK, 1 row affected (0.01 sec)

mysql> insert into Heros(name) values('刀妹');
Query OK, 1 row affected (0.14 sec)

mysql> select * from Heros;
+----+-----------+
| id | name      |
+----+-----------+
|  1 | 锐雯      |
|  2 | 石头人    |
|  3 | 盖伦      |
|  4 | 刀妹      |
+----+-----------+
4 rows in set (0.00 sec)

# delete删除数据后，会保留自增id的数值
mysql>
mysql> delete from Heros;
Query OK, 4 rows affected (0.00 sec)

mysql> insert into Heros(name) values('提莫');
Query OK, 1 row affected (0.00 sec)

mysql> insert into Heros(name) values('酒桶');
Query OK, 1 row affected (0.00 sec)

mysql> select * from Heros;
+----+--------+
| id | name   |
+----+--------+
|  5 | 提莫   |
|  6 | 酒桶   |
+----+--------+
2 rows in set (0.00 sec)
```

### truncate删除表数据
truncate语句，清空表数据

truncate清空表数据，是重新建立一个新表，能够删除id自增列的数值，重0开始

```plain
#清空表数据
mysql> truncate table Heros;
Query OK, 0 rows affected (0.01 sec)

mysql> select * from Heros;
Empty set (0.00 sec)

mysql> insert into Heros(name) values('大虫子');
Query OK, 1 row affected (0.00 sec)

mysql> insert into Heros(name) values('巨魔');
Query OK, 1 row affected (0.00 sec)

mysql> select * from Heros;
+----+-----------+
| id | name      |
+----+-----------+
|  1 | 大虫子    |
|  2 | 巨魔      |
+----+-----------+
2 rows in set (0.00 sec)
```

## 插入数据
语法

```plain
insert into table_name  field1,field2,field3 values(值1,值2,值3);

```

### 插入英雄数据
方式一

根据指定的列名，每一列都插入值，插入完全的值，列和值要对应

```plain
# 我们现有的表，插入对应英雄
mysql> desc tanks;
+-----------------+-----------------------+------+-----+---------+----------------+
| Field           | Type                  | Null | Key | Default | Extra          |
+-----------------+-----------------------+------+-----+---------+----------------+
| id              | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(100)          | NO   |     | NULL    |                |
| skills          | varchar(255)          | NO   |     | NULL    |                |
| summoner_skills | enum('flush','ghost') | NO   |     | flush   |                |
| price           | int(11)               | NO   |     | NULL    |                |
| introduction    | varchar(255)          | NO   |     | NULL    |                |
| camp            | varchar(50)           | YES  |     | NULL    |                |
| pic             | char(255)             | YES  |     | NULL    |                |
+-----------------+-----------------------+------+-----+---------+----------------+
8 rows in set (0.00 sec)

# 表中无数据
mysql> select * from tanks;
Empty set (0.00 sec)

# 插入数据
# 字段和值要对应上
# 注意结尾的分号
mysql> insert into tanks(id,name,skills,summoner_skills,price,introduction,camp,pic) values(1,'亚瑟','圣剑裁决','flush','5888','能抗能打，技能沉默','近战','https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg');
Query OK, 1 row affected (0.00 sec)

mysql> select * from tanks;
+----+--------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name   | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟   | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
+----+--------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> select * from tanks\G
*************************** 1. row ***************************
             id: 1
           name: 亚瑟
         skills: 圣剑裁决
summoner_skills: flush
          price: 5888
   introduction: 能抗能打，技能沉默
           camp: 近战
            pic: https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg
1 row in set (0.01 sec)
```

方式2：只插入部分字段数据

并且id列，是自动递增，依次加一的，可以不填

这里的not null 属性，表示的是，不允许插入null值，可以插入空值，空值不表示任何数据类型

允许为null，默认就会插入null值

如果不指定列，会按照规则

```plain
# 注意哪些字段是not null的
mysql> desc tanks;
+-----------------+-----------------------+------+-----+---------+----------------+
| Field           | Type                  | Null | Key | Default | Extra          |
+-----------------+-----------------------+------+-----+---------+----------------+
| id              | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(100)          | NO   |     | NULL    |                |
| skills          | varchar(255)          | NO   |     | NULL    |                |
| summoner_skills | enum('flush','ghost') | NO   |     | flush   |                |
| price           | int(11)               | NO   |     | NULL    |                |
| introduction    | varchar(255)          | NO   |     | NULL    |                |
| camp            | varchar(50)           | YES  |     | NULL    |                |
| pic             | char(255)             | YES  |     | NULL    |                |
+-----------------+-----------------------+------+-----+---------+----------------+
8 rows in set (0.01 sec)

# 插入部分数据，可以只插入名字
insert into tanks(name) values("凯");

# 查看值
mysql> select * from tanks\G
*************************** 1. row ***************************
             id: 1
           name: 亚瑟
         skills: 圣剑裁决
summoner_skills: flush
          price: 5888
   introduction: 能抗能打，技能沉默
           camp: 近战
            pic: https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg
*************************** 2. row ***************************
             id: 2
           name: 凯
         skills:
summoner_skills: flush
          price: 0
   introduction:
           camp: NULL
            pic: NULL
2 rows in set (0.00 sec)
```

3.批量插入数据，提升效率

```plain
mysql> insert into tanks(name,skills) values('东皇太一','堕神契约'),('吕布','魔神降临');

mysql> mysql> select * from tanks\G
*************************** 1. row ***************************
             id: 1
           name: 亚瑟
         skills: 圣剑裁决
summoner_skills: flush
          price: 5888
   introduction: 能抗能打，技能沉默
           camp: 近战
            pic: https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg
*************************** 2. row ***************************
             id: 2
           name: 凯
         skills:
summoner_skills: flush
          price: 0
   introduction:
           camp: NULL
            pic: NULL
*************************** 3. row ***************************
             id: 3
           name: 东皇太一
         skills: 堕神契约
summoner_skills: flush
          price: 0
   introduction:
           camp: NULL
            pic: NULL
*************************** 4. row ***************************
             id: 4
           name: 吕布
         skills: 魔神降临
summoner_skills: flush
          price: 0
   introduction:
           camp: NULL
            pic: NULL
4 rows in set (0.00 sec)
```

这里所学的数据插入，比如超哥去访问一个博客，写了一遍文章，发布，这就是数据库的插入动作。

查看博客文章，就是查看数据select的操作。  

## 查询数据
语法

Select 字段1,字段2,字段3 from table_name where 表达式;

### 方法1
进入数据库，再查询数据表

通过 * 查询所有字段

```plain
mysql> use kings;
Database changed
mysql> select * from tanks;
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  2 | 凯           |              | flush           |     0 |                             | NULL   | NULL                                                           |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           |     0 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
4 rows in set (0.00 sec)
```

### 方法2
不用进入库，通过库.表的方式查询

通过指定字段查询

```plain
# 比如查看mysql的用户表信息
mysql> select user,host from mysql.user;
+-----------+-------------+
| user      | host        |
+-----------+-------------+
| blog_user | 10.211.55.% |
| pyyu      | 10.211.55.% |
| root      | 127.0.0.1   |
| root      | localhost   |
+-----------+-------------+
4 rows in set (0.00 sec)
```

## 条件表达式查询
### limit指定条数
查看2条数据

```plain
# 限定查看2条数据
mysql> select * from tanks limit 2;
+----+--------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name   | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟   | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  2 | 凯     |              | flush           |     0 |                             | NULL   | NULL                                                           |
+----+--------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
2 rows in set (0.00 sec)
```

指定开始位置，找出2条数据

Limit 起点,条数;

```plain
mysql> select * from tanks limit 2,2\G
*************************** 1. row ***************************
             id: 3
           name: 东皇太一
         skills: 堕神契约
summoner_skills: flush
          price: 0
   introduction:
           camp: NULL
            pic: NULL
*************************** 2. row ***************************
             id: 4
           name: 吕布
         skills: 魔神降临
summoner_skills: flush
          price: 0
   introduction:
           camp: NULL
            pic: NULL
2 rows in set (0.00 sec)
```

### where指定查询条件
where用于如网站的筛选功能

找出凯的信息

```plain
mysql> select * from tanks where name='凯';
+----+------+--------+-----------------+-------+--------------+------+------+
| id | name | skills | summoner_skills | price | introduction | camp | pic  |
+----+------+--------+-----------------+-------+--------------+------+------+
|  2 | 凯   |        | flush           |     0 |              | NULL | NULL |
+----+------+--------+-----------------+-------+--------------+------+------+
1 row in set (0.00 sec)
```

同时查询多个条件

```plain
# 测试数据准备
mysql> insert into tanks(name,price) value('庄周',7777);
Query OK, 1 row affected, 2 warnings (0.00 sec)

mysql> insert into tanks(name,price) value('关羽',8888);
Query OK, 1 row affected, 2 warnings (0.00 sec)

mysql> insert into tanks(name,price) value('钟馗',9888);
Query OK, 1 row affected, 2 warnings (0.00 sec)

mysql> select * from tanks;
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  2 | 凯           |              | flush           |     0 |                             | NULL   | NULL                                                           |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           |     0 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         |              | flush           |  9888 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
7 rows in set (0.01 sec)

# 找出id大于3，价格大于6000的英雄
mysql> select * from tanks where id>3 and price>6000;
+----+--------+--------+-----------------+-------+--------------+------+------+
| id | name   | skills | summoner_skills | price | introduction | camp | pic  |
+----+--------+--------+-----------------+-------+--------------+------+------+
|  9 | 庄周   |        | flush           |  7777 |              | NULL | NULL |
| 10 | 关羽   |        | flush           |  8888 |              | NULL | NULL |
| 11 | 钟馗   |        | flush           |  9888 |              | NULL | NULL |
+----+--------+--------+-----------------+-------+--------------+------+------+
3 rows in set (0.00 sec)

# 找出指定id的记录，指定记录的显示
mysql> select id,name,price from tanks where id=9 ;
+----+--------+-------+
| id | name   | price |
+----+--------+-------+
|  9 | 庄周   |  7777 |
+----+--------+-------+
1 row in set (0.00 sec)
```

### order排序功能
若是linux重启，数据库未启动

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 start
Starting MySQL...
[root@mysql-server56 ~]# netstat -tunlp|grep mysql
tcp6       0      0 :::3307                 :::*                    LISTEN      1967/mysqld
[root@mysql-server56 ~]#
```

找出id大于3，且价格大于5000的英雄，且降序排序，结果只输出id，name,price

```plain
# desc 降序
mysql> select id,name,price from kings.tanks where id>3 and price>5000 order by price desc;
+----+--------+-------+
| id | name   | price |
+----+--------+-------+
| 11 | 钟馗   |  9888 |
| 10 | 关羽   |  8888 |
|  9 | 庄周   |  7777 |
+----+--------+-------+
3 rows in set (0.00 sec)

# asc升序
```

  

## 修改表数据
### 修改吕布价格
修改英雄数据的价格，吕布价格该为18888  

```plain
mysql> select * from kings.tanks;
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  2 | 凯           |              | flush           |     0 |                             | NULL   | NULL                                                           |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           |     0 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         |              | flush           |  9888 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
7 rows in set (0.00 sec)

# 修改
mysql> update kings.tanks set price='18888' where name='吕布';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from kings.tanks;
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  2 | 凯           |              | flush           |     0 |                             | NULL   | NULL                                                           |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           | 18888 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         |              | flush           |  9888 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
7 rows in set (0.00 sec)
```

### 添加英雄技能
给钟馗添加大招  

```plain
mysql> update kings.tanks set skills='轮回吞噬' where name='钟馗';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from kings.tanks;
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  2 | 凯           |              | flush           |     0 |                             | NULL   | NULL                                                           |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           | 18888 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         | 轮回吞噬     | flush           |  9888 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
7 rows in set (0.00 sec)
```

### 更新数据的坑
备份数据

为什么？因为超哥要演示一个错误示范。。  

```plain
# 备份数据mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1
# -B  --database

[root@mysql-server56 ~]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B kings > /opt/kings.sql
Warning: Using a password on the command line interface can be insecure.
```

现在有数据备份了，演示一个错误操作

<!-- OCR_START -->
- mysql> select * from kings.tanks;
- |id丨 name
- |skills
- summoner_skills
- price
- introduction
- camp
- Ipic
- 1|亚瑟
- 丨圣剑裁决
- flush
- 5888
- 能抗能打，技能沉默
- |近战
- Ihttps://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg
- 21凯
- 01
- NULL
- I NULL
- 31东皇太-
- 丨堕神契约
- 41吕布
- |魔神降临
- 18888
- 91庄周
- 7777
- 101关羽
- 8888
- 11丨钟道
- 丨轮回吞噬
- 9888
- 7 rows in set (0.00 sec)
- mysql>
- mysql> update kings.tanks set price='2000';
- Query OK，7rows affected (0.00 sec)
- Rows matched:7
- Changed:7V
- Warnings:0
- Isummoner_skills
- |pic
- 1圣剑裁决
- 2000
- 丨近战
- 3丨东皇太-
- Iflush
- 7
- rowsinset(0.o0sec)
<!-- OCR_END -->

这里就是很严重的问题，错误的SQL，很有可能造成数据混乱，因此SQL一定要和开发人员对接，或者DBA对接，确认无误再执行

此时可以恢复数据

```plain
# 此时可以删除该旧表，kings.tanks
mysql> drop table kings.tanks;
Query OK, 0 rows affected (0.01 sec)

mysql> source /opt/kings.sql

# 数据以及被改回来了
mysql> select * from kings.tanks;
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  2 | 凯           |              | flush           |     0 |                             | NULL   | NULL                                                           |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           | 18888 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         | 轮回吞噬     | flush           |  9888 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
7 rows in set (0.00 sec)
```

可见备份数据库的重要性

并且，在修改数据的时候，一定确保是否需要where语句指定

### 删除数据的坑
同样的道理，delete删除和更新一样，应该指定where条件，指定删除某一个数据

删除凯英雄数据

```plain
# 影响到一行数据
mysql> delete from kings.tanks where name='凯';
Query OK, 1 row affected (0.00 sec)
```

如果不指定条件，就是删除所有数据了，这里于超老师就不演示了。。大家应该明白了

提示：

很多开发，都会使用update替代delete，来实现逻辑删除

## 练习
1）登录MySQL数据库。

2）查看当前登录的用户。

3）创建数据库chaoge_linux，并查看已建库完整语句。

4）创建用户chaoge，使之可以管理数据库chaoge_linux。

5）查看创建的用户chaoge拥有哪些权限。

6）查看当前数据库里有哪些用户。

7）进入chaoge_linux数据库。

8）查看当前所在的数据库。

9）创建一张表test，字段id和name varchar(16)。

10）查看建表结构及表结构的SQL语句。

11）插入一条数据“1，yuchao”。

12）再批量插入2行数据“2，pyyu” ，“3，yuchao_linux”。

13）查询名字包含为yu的记录。

14）把数据id等于1的名字yuchao更改为yuchao888。

15）在字段name前插入age字段，类型tinyint(2)。

16）备份chaoge_linux数据库。

17）删除test表中的所有数据，并查看。

18）删除表test和chaoge_linux数据库并查看。

19）不退出数据库恢复以上删除的数据。

20）将id列设置为主键，在Name字段上创建普通索引。

21）在字段name后插入手机号字段（phone），类型为char(11)。

22）所有字段上插入2条记录（自行设定数据）。

23）删除Name列的索引。

24）查询手机号以152开头的，名字为yuchao的记录（提前插入）。

26）删除chaoge用户。

27）删除chaoge_linux数据库。

28）停止数据库。

29）如何重置mysql密码

30）简述SQL执行原理流程

# MySQL备份方案

<!-- OCR_START -->
- MySQL
- 从时库到跑路盟色
- 数据库删了肯定要跑路啊
- 从删库到跑路
- 视频教学版
<!-- OCR_END -->

--

<!-- OCR_START -->
- MySOL
- 人时库到跑路魔必
- MySQL
- 从删库到跑路
- 视频教字版
<!-- OCR_END -->

为什么于超老师要给大家讲mysql备份？

先看上面两张图。。

## 为什么要备份
运维是干什么的？

+ 保护服务器数据安全
+ 维护公司运维资产7*24小时运转

企业真实案件：

[https://www.leiphone.com/category/sponsor/Isb7Smi17CHBTxVF.html](https://www.leiphone.com/category/sponsor/Isb7Smi17CHBTxVF.html)

企业丢了数据，就等于失去了商机、客户、产品、甚至倒闭。

在各式各样的数据中，数据库的数据更是核心之核心，当然其他各式各样的如静态文件数据，也很重要，也会通过其他的备份方式来保证安全。

## MySQL备份
mysqldump备份语法

Mysqldump -u用户名 -p密码 参数 数据库名 > 数据备份文件

备份kings数据库

```plain
mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B kings > /opt/kings.sql

```

### 查看备份文件信息
过滤无用信息

```plain
[root@mysql-server56 ~]# grep -Ev '#|\*|--|^$' /opt/kings.sql
USE `kings`;
DROP TABLE IF EXISTS `Heros`;
CREATE TABLE `Heros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
LOCK TABLES `Heros` WRITE;
INSERT INTO `Heros` VALUES (1,'大虫子'),(2,'巨魔');
UNLOCK TABLES;
DROP TABLE IF EXISTS `tanks`;
CREATE TABLE `tanks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `skills` varchar(255) NOT NULL,
  `summoner_skills` enum('flush','ghost') NOT NULL DEFAULT 'flush',
  `price` int(11) NOT NULL,
  `introduction` varchar(255) NOT NULL,
  `camp` varchar(50) DEFAULT NULL,
  `pic` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
LOCK TABLES `tanks` WRITE;
INSERT INTO `tanks` VALUES (1,'亚瑟','圣剑裁决','flush',5888,'能抗能打，技能沉默','近战','https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg'),(2,'凯','','flush',0,'',NULL,NULL),(3,'东皇太一','堕神契约','flush',0,'',NULL,NULL),(4,'吕布','魔神降临','flush',18888,'',NULL,NULL),(9,'庄周','','flush',7777,'',NULL,NULL),(10,'关羽','','flush',8888,'',NULL,NULL),(11,'钟馗','轮回吞噬','flush',9888,'',NULL,NULL);
UNLOCK TABLES;
```

看来备份的命令，导出的SQL语句，是相当于以后创建一个新的数据库，以及插入数据

为了恢复效率，mysqldump是把数据导出为数据插入语句

以及在插入数据的时候，lock tables锁表，数据插入结束后，解锁表

## 备份且压缩gzip
对于数据库有大量数据表，以及信息，导出的备份文件，最好是压缩后的，节省磁盘。

```plain
[root@mysql-server56 ~]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B kings|gzip  > /opt/kings.sql.gz
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 ~]# ls -lh /opt/kings*
-rw-r--r-- 1 root root 3.3K Apr 20 14:25 /opt/kings.sql
-rw-r--r-- 1 root root 1.2K Apr 20 16:30 /opt/kings.sql.gz
```

这里是一个没有多少数据的table，也被gzip压缩了很大空间。

  
 

## mysqldump备份原理
mysqldump命令备份过程，实际上是把数据库、表，以SQL语句的形式，输出为文件的备份过程，这种方式称之为逻辑备份。

但是这种方式效率并不高，以SQL导出，在海量数据下，例如几十G的场景，备份、恢复的时间都会过长。

因此还会有其他备份方案。

## 备份多个库
备份多个库，如下

```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| K8S                |
| blog               |
| kings              |
| luffy              |
| mysql              |
| performance_schema |
+--------------------+
7 rows in set (0.01 sec)

# 备份
[root@mysql-server56 ~]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B kings K8S luffy mysql|gzip  > /opt/more_db.sql.gz
Warning: Using a password on the command line interface can be insecure.
```

## 小结
+ 备份命令，尽量携带-B参数，会让sql更加完整
- -B可以跟上多个数据库名，同时备份多个库
+ 尽量结合gzip命令压缩

## 分库、分表备份
直接看于超老师之前的脚本开发，分库分表备份

直接看于超老师之前的脚本开发，分库分表备份

[http://book.luffycity.com/linux-book/%E8%B6%85%E5%93%A5%E5%B8%A6%E4%BD%A0%E5%AD%A6Shell/06_for%E5%BE%AA%E7%8E%AF%E5%BC%80%E5%8F%91.html#%E5%BC%80%E5%8F%91mysql%E5%88%86%E5%BA%93%E5%A4%87%E4%BB%BD%E8%84%9A%E6%9C%AC](http://book.luffycity.com/linux-book/%E8%B6%85%E5%93%A5%E5%B8%A6%E4%BD%A0%E5%AD%A6Shell/06_for%E5%BE%AA%E7%8E%AF%E5%BC%80%E5%8F%91.html#%E5%BC%80%E5%8F%91mysql%E5%88%86%E5%BA%93%E5%A4%87%E4%BB%BD%E8%84%9A%E6%9C%AC)

```plain
# 其实是等于执行多次mysqldump命令
mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B kings > /opt/kings.sql
mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B  K8S  > /opt/K8S.gz
```

## 备份单个table
这里不能加上-B参数了，这是指定数据库的作用

单独指定备份某个table

```plain
[root@mysql-server56 opt]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 kings tanks  > /opt/tanks.sql
Warning: Using a password on the command line interface can be insecure.
```

查看备份的sql文件

只有单独针对tanks表数据的备份

```plain
[root@mysql-server56 opt]# grep -Ev '#|\*|--|^$' /opt/tanks.sql
DROP TABLE IF EXISTS `tanks`;
CREATE TABLE `tanks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `skills` varchar(255) NOT NULL,
  `summoner_skills` enum('flush','ghost') NOT NULL DEFAULT 'flush',
  `price` int(11) NOT NULL,
  `introduction` varchar(255) NOT NULL,
  `camp` varchar(50) DEFAULT NULL,
  `pic` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
LOCK TABLES `tanks` WRITE;
INSERT INTO `tanks` VALUES (1,'亚瑟','圣剑裁决','flush',5888,'能抗能打，技能沉默','近战','https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg'),(3,'东皇太一','堕神契约','flush',0,'',NULL,NULL),(4,'吕布','魔神降临','flush',18888,'',NULL,NULL),(9,'庄周','','flush',7777,'',NULL,NULL),(10,'关羽','','flush',8888,'',NULL,NULL),(11,'钟馗','轮回吞噬','flush',9888,'',NULL,NULL);
UNLOCK TABLES;
```

## 备份库下多个表
```plain
# 备份库下，多个表
[root@mysql-server56 opt]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 kings tanks Heros > /opt/tanks_Heros.sql
Warning: Using a password on the command line interface can be insecure.

# 查看备份
```

查看备份sql

```plain
[root@mysql-server56 opt]# grep -Ev '#|\*|--|^$' /opt/tanks_Heros.sql
DROP TABLE IF EXISTS `tanks`;
CREATE TABLE `tanks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `skills` varchar(255) NOT NULL,
  `summoner_skills` enum('flush','ghost') NOT NULL DEFAULT 'flush',
  `price` int(11) NOT NULL,
  `introduction` varchar(255) NOT NULL,
  `camp` varchar(50) DEFAULT NULL,
  `pic` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
LOCK TABLES `tanks` WRITE;
INSERT INTO `tanks` VALUES (1,'亚瑟','圣剑裁决','flush',5888,'能抗能打，技能沉默','近战','https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg'),(3,'东皇太一','堕神契约','flush',0,'',NULL,NULL),(4,'吕布','魔神降临','flush',18888,'',NULL,NULL),(9,'庄周','','flush',7777,'',NULL,NULL),(10,'关羽','','flush',8888,'',NULL,NULL),(11,'钟馗','轮回吞噬','flush',9888,'',NULL,NULL);
UNLOCK TABLES;
DROP TABLE IF EXISTS `Heros`;
CREATE TABLE `Heros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
LOCK TABLES `Heros` WRITE;
INSERT INTO `Heros` VALUES (1,'大虫子'),(2,'巨魔');
UNLOCK TABLES;
```

通过sql可以看出，整个过程是

+ 如果该表存在，则删除
+ 创建table
+ 锁表，防止数据写入
+ 数据插入
+ 解锁表

## 只备份table结构，不要数据
有些情况下会只需要表结构，不要数据，命令如下  

```plain
--no-data，-d
不写表的任何行信息。如果你只想转储表的结构这很有用。
```

### 备份所有表结构
备份库下所有表结构

```plain
[root@mysql-server56 opt]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -d kings > /opt/kings_struct.sql
Warning: Using a password on the command line interface can be insecure.
```

查看只有表结构

```plain
[root@mysql-server56 opt]# grep -Ev '#|\*|--|^$' /opt/kings_struct.sql
DROP TABLE IF EXISTS `Heros`;
CREATE TABLE `Heros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `tanks`;
CREATE TABLE `tanks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `skills` varchar(255) NOT NULL,
  `summoner_skills` enum('flush','ghost') NOT NULL DEFAULT 'flush',
  `price` int(11) NOT NULL,
  `introduction` varchar(255) NOT NULL,
  `camp` varchar(50) DEFAULT NULL,
  `pic` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
```

## 单独备份表结构
```plain
[root@mysql-server56 opt]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -d kings tanks> /opt/tanks_struct.sql
Warning: Using a password on the command line interface can be insecure.

# 表结构
[root@mysql-server56 opt]# grep -Ev '#|\*|--|^$' /opt/tanks_struct.sql
DROP TABLE IF EXISTS `tanks`;
CREATE TABLE `tanks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `skills` varchar(255) NOT NULL,
  `summoner_skills` enum('flush','ghost') NOT NULL DEFAULT 'flush',
  `price` int(11) NOT NULL,
  `introduction` varchar(255) NOT NULL,
  `camp` varchar(50) DEFAULT NULL,
  `pic` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
```

### 只备份表数据，不要结构
语法

--no-create-info，-t

不写重新创建每个转储表的CREATE TABLE语句。  

```plain
# 查看数据sql
[root@mysql-server56 opt]# grep -Ev '#|\*|--|^$' /opt/kings_data.sql
LOCK TABLES `Heros` WRITE;
INSERT INTO `Heros` VALUES (1,'大虫子'),(2,'巨魔');
UNLOCK TABLES;
LOCK TABLES `tanks` WRITE;
INSERT INTO `tanks` VALUES (1,'亚瑟','圣剑裁决','flush',5888,'能抗能打，技能沉默','近战','https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg'),(3,'东皇太一','堕神契约','flush',0,'',NULL,NULL),(4,'吕布','魔神降临','flush',18888,'',NULL,NULL),(9,'庄周','','flush',7777,'',NULL,NULL),(10,'关羽','','flush',8888,'',NULL,NULL),(11,'钟馗','轮回吞噬','flush',9888,'',NULL,NULL);
UNLOCK TABLES;
```

  
单独备份某个表的数据

```plain
[root@mysql-server56 opt]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -t kings tanks> /opt/tanks_data.sql
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 opt]#
[root@mysql-server56 opt]# grep -Ev '#|\*|--|^$' /opt/tanks_data.sql
LOCK TABLES `tanks` WRITE;
INSERT INTO `tanks` VALUES (1,'亚瑟','圣剑裁决','flush',5888,'能抗能打，技能沉默','近战','https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg'),(3,'东皇太一','堕神契约','flush',0,'',NULL,NULL),(4,'吕布','魔神降临','flush',18888,'',NULL,NULL),(9,'庄周','','flush',7777,'',NULL,NULL),(10,'关羽','','flush',8888,'',NULL,NULL),(11,'钟馗','轮回吞噬','flush',9888,'',NULL,NULL);
UNLOCK TABLES;
```

### 分离结构、数据、备份
--compact 减少无用输出信息

-T 分离数据为纯文本、结构为SQL  

```plain
[root@mysql-server56 opt]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 kings  tanks --compact -T /tmp
Warning: Using a password on the command line interface can be insecure.
mysqldump: Got error: 1290: The MySQL server is running with the --secure-file-priv option so it cannot execute this statement when executing 'SELECT INTO OUTFILE'
[root@mysql-server56 opt]#
```

这里报错了，是因为--secure-file-priv option，因为安全机制，不允许执行，可以修改参数

查看参数

```plain
[root@mysql-server56 opt]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 16
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show global variables like '%secure_file_priv%';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| secure_file_priv | NULL  |
+------------------+-------+
1 row in set (0.00 sec)

mysql>

# 这里想用set命令，临时修改变量值
mysql> set global secure_file_priv='';
ERROR 1238 (HY000): Variable 'secure_file_priv' is a read only variable

# 但是因为是只读参数，禁止修改，只能修改配置文件，重启程序
```

但是因为是只读参数，禁止修改，只能修改配置文件，重启程序

```plain
[root@mysql-server56 opt]# cat /data/3307/my.cnf
[client]
port=3307
socket=/data/3307/mysql.sock

[mysqld]
user=mysql
port=3307
socket=/data/3307/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3307/data
log-bin=/data/3307/mysql-bin
server-id=6
secure_file_priv=''

[mysqld_safe]
log-error=/data/3307/mysql_3307_error.log
pid-file=/data/3307/mysqld_3307.pid
[root@mysql-server56 opt]#
```

重启，查看结果

```plain
[root@mysql-server56 opt]# /data/3307/mysql_3307 restart
Restarting MySQL...
Stoping MySQL...
Starting MySQL...
[root@mysql-server56 opt]#

[root@mysql-server56 opt]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 kings  tanks --compact -T /tmp
Warning: Using a password on the command line interface can be insecure.
```

查看结果

```plain
# 结构
[root@mysql-server56 opt]# cat /tmp/tanks.sql
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tanks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `skills` varchar(255) NOT NULL,
  `summoner_skills` enum('flush','ghost') NOT NULL DEFAULT 'flush',
  `price` int(11) NOT NULL,
  `introduction` varchar(255) NOT NULL,
  `camp` varchar(50) DEFAULT NULL,
  `pic` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

# 数据
[root@mysql-server56 opt]# cat /tmp/tanks.txt
1    亚瑟    圣剑裁决    flush    5888    能抗能打，技能沉默    近战    https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg
3    东皇太一    堕神契约    flush    0        \N    \N
4    吕布    魔神降临    flush    18888        \N    \N
9    庄周        flush    7777        \N    \N
10    关羽        flush    8888        \N    \N
11    钟馗    轮回吞噬    flush    9888        \N    \N
```

  

## 小节
-d 只备份库表结构，sql导出

-t 只备份表数据，sql导出

-T 分离数据、结构

## binlog
binlog是mysql一大重点，Binlog是一个二进制格式的文件，用于记录用户对数据库更新的SQL语句信息，例如更改数据库库表和更改表内容的SQL语句都会记录到binlog里，但是对库表等内容的查询则不会记录到日志中。

### binlog的作用
当有数据写入到数据库时，还会同时把更新的SQL语句写入到对应的binlog文件里，这个文件就是上文所说的binlog文件。

使用mysqldump备份时，例如我们一般会写crontab，例如夜里0点整，进行数据库备份。

### 使用binlog的背景
问题是，每天只有到0点整才进行备份，那未备份之前，也就是两次数据库备份的间隔是24小时。

一旦在这个期间发生故障，那么数据此时就是丢失的，即使使用mysqldump的备份，也只能找回当日0点的数据。

使用binlog功能，可以解决该问题

使用binlog文件，可以将两次完整备份间隔之间的数据还原

因为binlog文件的数据就是，写入数据库，的数据

因此可以使用binlog来恢复数据，这种方式称之为二进制增量数据恢复

图解

<!-- OCR_START -->
- 这24小时内，「
- 网站数据写入
- 4月20日24:00点执行备份
- 4月21日24:00点执行备份
- mysqldump
- ..
- binlog日志
<!-- OCR_END -->

### 切割binlog
切割binlog作用是很有必要的

因为要确定，全量备份mysqldump和增量备份binlog的一个临界点。

当全量备份完成之后，上一次的binlog文件就没有作用了（因为此时的mysqldump全量备份，导出的数据已经包含了上一次的binlog数据）

<!-- OCR_START -->
- 这24小时内，网站数据写入
- 4月20日24:00点执行备份
- 4月21日24:00点执行备份
- mysqldump
- 4月21~4月22
- 4月2224:00
- binlog日志
- binlog
- 全量备份
- 超哥带你学mysql bin-log
<!-- OCR_END -->

下一次的全量备份中间的数据依然很重要，就还得存储在binlog文件里

因此需要要求，mysqldump的全量备份数据，和binlog的数据确定临界点

+ binlog不能和mysqldump重复
+ binlog和mysqldump也不能丢失

## 如何开启binlog
开启binlog功能，只需要配置文件，添加参数log_bin  
  

```plain
# 配置文件如下
[root@mysql-server56 opt]#
[client]
port=3307
socket=/data/3307/mysql.sock

[mysqld]
user=mysql
port=3307
socket=/data/3307/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3307/data
log-bin=/data/3307/mysql-bin    # 这里开启binlog功能，以及binlog的文件名字
server-id=6
secure_file_priv=''

[mysqld_safe]
log-error=/data/3307/mysql_3307_error.log
pid-file=/data/3307/mysqld_3307.pid
~
```

### -F参数切割binlog日志
-F 参数用于mysqldump全量备份后立即对binlog日志文件切割，生成一个新日志文件，且重新记录binlog日志，用于将来增量恢复，从新的binlog日志文件开始

### binlog实践
例如早上10点时，数据表被误删，数据丢失，如何恢复？

思路

+ 目前现有的备份，还是4月20日24:00点的全量备份
+ 但是还好我们开启了binlog功能

解决办法

+ 先恢复4月20日24:00的全量数据
+ 再恢复4月20日24:00到4月21日10:00之间的binlog数据

使用-F参数

此时于超老师的3307实例下的数据文件

```plain
[root@mysql-server56 3307]# ls -l
total 24
drwxr-xr-x 8 mysql mysql  163 Apr 20 20:54 data
-rw-r--r-- 1 mysql mysql  346 Apr 20 20:34 my.cnf
-rwx------ 1 mysql mysql 1000 Apr 15 15:44 mysql_3307
-rw-r--r-- 1 mysql mysql 1607 Apr 20 20:54 mysql_3307_error.log
-rw-rw---- 1 mysql mysql  120 Apr 20 20:54 mysql-bin.000001
-rw-rw---- 1 mysql mysql   28 Apr 20 20:54 mysql-bin.index
-rw-rw---- 1 mysql mysql    6 Apr 20 20:54 mysqld_3307.pid
srwxrwxrwx 1 mysql mysql    0 Apr 20 20:54 mysql.sock
```

执行mysqldump -F参数

```plain
[root@mysql-server56 opt]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -F -B kings|gzip > /data/3307/$(date +%F).sql.gz

```

<!-- OCR_START -->
[root@mysql-server563307]#ls-l total24 drwxr-xr-x 8 mysql mysql 163 Apr 20 20:54 data

-rw-r--r-- 1 mysql mysql 346 Apr 20 20:34 my.cnf

rwx-- 1 mysql mysql 1000 Apr 15 15:44 mysql_3307

-rw-r--r--

1 mysql mysql 1607Apr 2020:54 mysql_3307_error.log

-rw-rw----

1 mysql mysql 120 Apr 20 20:54 mysql-bin.000001 28 Apr 20 20:54 mysql-bin.index 6 Apr 20 20:54 mysqld_3307.pid srwxrwxrwx 1 mysql mysql 0Apr2020:54 mysql.sock [root@mysql-server56 3307]# [root@mysql-server56 3307]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -F -B kingslgzip > /data/3307/$(date +%F).sql.gz Warning:Usingapasswordonthecommandlineinterfacecanbeinsecure. total32

-rw-r--r-- 1 root root 1222 Apr 20 20:55 2021-04-20.sql.gz

drwxr-xr-x 8 mysql mysql 163 Apr 20 20:54data 167 Apr 20 20:55 mysql-bin.000001 120 Apr 20 20:55 mysql-bin.000002 56 Apr 20 20:55 mysql-bin.index total36

-rw-r--r-- 1 root root

1223 Apr 20 20:55 2021-04-20.sql.gz

-rwx------ 1 mysql mysql 1000 Apr 15 15:44 mysql_3307

1167 Apr 20 20:55 mysql-bin.000001 167 Apr 20 20:55 mysql-bin.000002 120 Apr 20 20:55 mysql-bin.000003 84 Apr 20 20:55 mysql-bin.index Lroot@mysal

-server563307]#
<!-- OCR_END -->

  
可以看到，利用-F能够立即切割出新的binlog文件

后面超哥会带着大家实际进行数据故障恢复操作。

<!-- OCR_START -->
- mysallomp
- mysaloduomp
- 备份的全量数据
- yychao-bin.000003
- binlog增量数据备份
- 4月30日
- 4月3日
- binlog增量文件数据
- yvchao-bin.000004
- yuchao-bin.000005
- ychao-bin.0000on
<!-- OCR_END -->

## --master-data
刚才的-F参数，是给mysqldump提供的切割binlog，但是这也需要不断的执行，不断的切割

mysqldump也提供了--master-data参数，能够在备份的SQL文件中，添加CHANGE MASTER语句，以及binlog文件的pos位置，也就是记录数据的写入位置。

参数解释

```plain
--master-data[=value]
该选项将二进制日志的位置和文件名写入到输出中。该选项要求有RELOAD权限，并且必须启用二进制日志。
如果该选项值等于1，位置和文件名被写入CHANGE MASTER语句形式的转储输出，如果你使用该SQL转储主服务器以设置从服务器，从服务器从主服务器二进制日志的正确位置开始。
如果选项值等于2，CHANGE MASTER语句被写成SQL注释。
如果value被省略，这是默认动作。
```

实践

```plain
[root@mysql-server56 3307]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 --master-data=1  kings --compact  > /data/3307/master-data.sql
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 3307]#
[root@mysql-server56 3307]# mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 --master-data=2  kings --compact  > /data/3307/master-data.sql2
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 3307]#
[root@mysql-server56 3307]#
[root@mysql-server56 3307]#
[root@mysql-server56 3307]#
[root@mysql-server56 3307]# ls /data/3307/master-data.sql*
/data/3307/master-data.sql  /data/3307/master-data.sql2
```

  
最终结果，区别在下

```plain
[root@mysql-server56 3307]# head -1  /data/3307/master-data.sql
CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=120;

[root@mysql-server56 3307]# head -1  /data/3307/master-data.sql2
-- CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=120;
```

  

### 作用
该参数主要是用于在mysql基于binlog的数据主从复制，在后面的mysql架构学习讲解。

## -x参数
既然是数据备份，比如说淘宝网的数据库要进行全量备份，但是例如在24:00整点，还有人在写入数据，那就无法保证数据的一致性。

因此得在备份时，将表锁住，防止数据写入，得到一个完整的数据备份，也就是24:00停止所有写入操作。

<!-- OCR_START -->
- -x 参数锁表，数据停止写入
- 不锁表
- 得到完整all.sql.gz
- 备份适还有数据写入
- Kings
- yuchao_mysal
- y4:00
- 4:00零点
<!-- OCR_END -->

## mysqldump参数
[http://linux.51yip.com/search/mysqldump](http://linux.51yip.com/search/mysqldump)

## 恢复数据
### source
mysql利用srouce命令可以恢复数据库数据，就是在mysql中，重新执行SQL语句。

备份方式

```plain
mysql > use kings;

# 恢复数据
mysql > source /opt/kings.sql
```

### 重定向符号
mysql这个客户端命令，除了登录，也可以用于数据导入

```plain
[root@mysql-server56 3307]# mysql < /opt/yuchao_kings.sql

```

既然导入sql文件，是告诉mysql重新执行该SQL语句

如果sql中没有执行database，直接插入数据，那是会报错的

因此执行恢复的sql文件，得先看该SQL语句是什么作用

例如指定数据库，插入表、以及数据，那就得导入时，指定数据库名字

```plain
[root@mysql-server56 3307]# mysql  kings < /opt/yuchao_kings.sql

```

## 快捷执行SQL
可以不用登陆mysql，快捷执行SQL语句查看结果，-e参数

```plain
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e 'select database();'
Warning: Using a password on the command line interface can be insecure.
+------------+
| database() |
+------------+
| NULL       |
+------------+
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e 'select user();'
Warning: Using a password on the command line interface can be insecure.
+----------------+
| user()         |
+----------------+
| root@localhost |
+----------------+
```

查看mysql的SQL线程执行状态

该命令可以检查出mysql的慢查询问题，也就是哪些SQL执行的很耗时

```plain
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e 'show full processlist;'
Warning: Using a password on the command line interface can be insecure.
+----+------+-----------------+------+---------+------+-------+-----------------------+
| Id | User | Host            | db   | Command | Time | State | Info                  |
+----+------+-----------------+------+---------+------+-------+-----------------------+
|  8 | root | localhost:43368 | NULL | Query   |    0 | init  | show full processlist |
+----+------+-----------------+------+---------+------+-------+-----------------------+
```

有关mysql的性能调优，后期超哥再给大家讲解

## mysqlbinlog命令
[http://linux.51yip.com/search/mysqlbinlog](http://linux.51yip.com/search/mysqlbinlog)

该命令用于解析binlog日志文件的内容

```plain
参数
-d 指定数据库
-r 输出到文件

# 数据源
[root@mysql-server56 3307]# ls
2021-04-20.sql.gz  master-data.sql   my.cnf      mysql_3307_error.log  mysql-bin.000002  mysql-bin.index  mysql.sock
data               master-data.sql2  mysql_3307  mysql-bin.000001      mysql-bin.000003  mysqld_3307.pid

# 如果直接查看文件是二进制形式的，是无法查看的
[root@mysql-server56 3307]# tail -1 mysql-bin.000002

[root@mysql-server56 3307]# mysqlbinlog -d kings mysql-bin.000002 -r mysql-bin.000002.sql

[root@mysql-server56 3307]# cat mysql-bin.000002.sql
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!40019 SET @@session.max_insert_delayed_threads=0*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#210420 20:55:02 server id 6  end_log_pos 120 CRC32 0x158531c7     Start: binlog v 4, server v 5.6.40-log created 210420 20:55:02
BINLOG '
Js9+YA8GAAAAdAAAAHgAAAAAAAQANS42LjQwLWxvZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAEzgNAAgAEgAEBAQEEgAAXAAEGggAAAAICAgCAAAACgoKGRkAAccx
hRU=
'/*!*/;
# at 120
#210420 20:55:07 server id 6  end_log_pos 167 CRC32 0x5c6f5a8b     Rotate to mysql-bin.000003  pos: 4
DELIMITER ;
# End of log file
ROLLBACK /* added by mysqlbinlog */;
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
[root@mysql-server56 3307]#
```

# MySQL备份方案实践
数据备份，目的在于防患于未然

## 全量备份
全量数据，指的是某一整个数据库（如kings）中所有的表、以及表数据，进行备份。

例如备份所有数据库、以及所有数据

```plain
--all--database，-A

--compact 产生少量输出

mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 --master-data=2  -A |gzip  > /data/3307/all-data.sql.gz
```

备份其中一个db

```plain
mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 --master-data=2  kings|gzip > /data/3307/kings-data.sql.gz

```

## 增量备份
增量指的就是，在上一次全量备份数据之后，到下一次全量备份之间的新增数据。

增量数据，也就是以binlog形式进行记录数据，基于binlog日志的备份，也就是增量备份。

## 全量+增量

<!-- OCR_START -->
- mysqlclump
- mysqldump
- 备份的全量数据
- yuchao-bin.0oqbol
- yuchao-bin.00qbox
- yuchao-bin.009003
- yuchao-bin.0od
- binlog增量数据备份
- 4月30日
- 4月3日
- binlog 增量文件数据
- yuchao-bin.000004
- yuchao-bin.000005
- ychao-bin.00000n
- yvchao-bin.000006
- yuehao-bin.00000n
<!-- OCR_END -->

### 全量备份特点
优点

+ 恢复数据时需要的数据文件数量少，维护成本低

缺点

+ 每天一个全量备份，占用磁盘，且全量备份时，消耗计算机资源，造成极其压力上升。

中小公司最常用的就是全量备份，定制备份数据删除规则，例如仅保留7天内的数据，若是有特殊需求，可以长时间保留备份数据。

## 备份方案
### 逻辑备份
逻辑备份指的是用mysqldump命令或者其他工具，把mysql的数据以SQL的形式导出。

恢复的时候，导入该数据，source或者mysql命令，重新将SQL还原为数据。

### 特点
逻辑备份优点是简单、方便、可靠、备份后的数据可以跨平台、跨版本、跨操作系统恢复，因为都遵循SQL语句。

缺点：比起物理备份，效率较低，海量数据下，效率很低。

### 物理备份
物理备份是直接备份mysql的数据源，例如datadir=/data/3307/data

### 冷备
物理备份指的就是，利用cp,rsync,tar,scp等工具把mysql数据文件复制多份，但是在备份期间，仍可能有用户在写入数据，因此该方案，会导致数据丢失，数据复制不完整。

为了确保备份期间的数据一致性，可以人工的停止数据库，或者锁表，再进行复制数据，但是这种方案还是太粗暴。

因此是不推荐使用的，只是大家需要有这个概念，知道备份的方式。

冷备，指的是，停机情况下对数据备份

### 热备
热备，指的是，不停机，进行数据备份

结合Xtrabackup备份工具，可以实现物理全备+增量备份。

### 特点
和逻辑备份相反

优点：速度快，效率极高

缺点：不支持跨平台、版本、软件、操作系统，恢复麻烦些

<!-- OCR_START -->
- 逻辑备份
- 物理备份
- 直接复制磁盘物理文件或其他非SQL语句
- 备份原理
- 以SQL语句的形式存储
- 方式的备份
- 相关命令
- Mysqldump、mysql、mysqlbinlog
- cp、rsync、tar、scp、Xtrabackup（热备）
- 需要锁表但不需要停库。锁表会影响数
- 冷备需要锁表或停机，热备不需要锁表
- 备份要求
- 据库更新，InnoDB引擎可以不锁表，而
- （仅事务引擎，例如InnoDB）或停机
- 采用事务备份方案
- 恢复时与系统版本、库的配置甚至版本
- 物理复制需要系统、配置、版本尽可能的
- 配置特点
- 无关
- 一致
- 性能特点
- 速度慢
- 速度快
- 安全、易掌握、容易控制，一般不会丢
- 冷备简单，但应用场景少，热备工具操作
- 方便性考虑
- 失数据
- 复杂一些，较难掌握
<!-- OCR_END -->

## 中小公司全量备份实战
中小公司，一般是逻辑备份，mysqldump即可，设置每天进行全量备份，备份时间在业务流量最低谷时操作。jianli

### 备份脚本
如开发备份脚本

这里的mysql是超哥机器上的多实例环境，因此加上了些参数

```plain
#!/bin/bash

bak_path=/mysql_data/3307/
[ -d $bak_path ] && mkdir -p $bak_path
# 备份数据，逻辑备份
mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B -A --master-data=2|gzip >$bak_path/$(date +%F)_3307.sql.gz

# md5验证完整文件，用于未来检查传输结果
md5sum $bak_path/$(date +%F)_3307.sql.gz >$bak_path/$(date +%F)_3307.sql.gz.md5

# 复制、同步备份文件，物理备份
# 需要配置好rsync服务
rsync -az $bak_path/ rsync_backup@10.211.55.12::mysql/ --password-file=/etc/rsync.password

# 删除超过7天的备份
find $bak_path/ -type f -name "*.sql.gz" -mtime +7|xargs rm -f
```

### 定时任务
```plain
[root@mysql-server56 3307]# crontab -l
0 0 * * * /bin/bash /mysql_scripts/bak.sh &>/dev/null
```

## 中小公司增量备份实战
既然用增量备份

表示全量的数据文件，无法达到恢复的目的

例如

一位刚入职场的萌新开发，于超同学，一个不留神，删错了数据，凉凉

### 如何恢复
1.得有全量备份的数据

2.得有binlog增量日志

### 实战
### 实验环境准备
当前的kings库下，tanks表数据内容

```plain
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "select * from kings.tanks"
Warning: Using a password on the command line interface can be insecure.
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           | 18888 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         | 轮回吞噬     | flush           |  9888 |                             | NULL   | NULL                                                             |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
[root@mysql-server56 3307]#
```

  
模拟在0点整进行全量备份

## 这里非常重要！！！！
基于binlog的增量备份，核心就在于这里

我们在执行mysqldump备份时，添加的--master-data=2参数，能够立即计算出当前的数据在哪一个位置，表示，目前数据一直写到了这里。

<!-- OCR_START -->
- pos1895
- pos1346
- pos468
- pos200
- binlog
- 数据写入mysql，通过binlog日志，精确记录数据的变化，也就是events，通过pos定位数据到哪了
<!-- OCR_END -->

  

```plain
[root@mysql-server56 3307]# date -s "2021/04/21"
Wed Apr 21 00:00:00 CST 2021
[root@mysql-server56 3307]#
[root@mysql-server56 3307]# date
Wed Apr 21 00:00:03 CST 2021

# 备份脚本

# /bin/bash
[root@mysql-server56 mysql_script]# cat bak_db.sh
date -s "2021/04/21"
mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B --master-data=2 kings|gzip >/mysql_data/3307/$(date +%F)_3307.sql.gz
ls -l /mysql_data/3307/

# 执行脚本，查看备份文件
[root@mysql-server56 mysql_script]# bash bak_db.sh
[root@mysql-server56 mysql_script]# bash bak_db.sh
Wed Apr 21 00:00:00 CST 2021
Warning: Using a password on the command line interface can be insecure.
total 4
-rw-r--r-- 1 root root 1348 Apr 21 00:00 2021-04-21_3307.sql.gz
```

模拟0点全量备份后后，继续写入数据

<!-- OCR_START -->
[root@mysql-server56 mysql_script]#mysql-uroot-pyuchao7777-P3307-h127.0.0.1-e"select*
*from kings.tanks
Warning: Using a password on the command line interface can be insecure.
I id | name
Iskills
丨 summoner_skills 丨 price 丨 introduction
1camp
Ipic
1|亚瑟
|圣剑裁决
1flush
5888丨能抗能打，技能沉默
丨近战
Ihttps://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg
3丨东皇太-
丨堕神契约
|flush
I  NULL
1 NULL
41
吕布
|魔神降临
|18888|
91庄周
77771
101关羽
88881
11丨钟道
1轮回吞噬
I flush
98881
[root@mysql-server56 mysql_script]#
[root@mysql-server56 mysql_script]#mysql -uroot-pyuchao7777-P3307-h127.0.0.1-e"use kings;insert into tanks(id,name）values(12,'猪八戒');
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e"select * from kings.tanks"
Iid丨 name
1圣剑裁决
01
41吕布
1魔神降临
188881
NULL
12丨猪八戒
13丨孙悟空
<!-- OCR_END -->

模拟在上午11点，二货开发，于超同学，手残删掉了kings整个数据库

```plain
[root@mysql-server56 mysql_script]# cat drop_db.sh
date -s "2021/04/21 11:00"
mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "drop database kings;show databases;"
[root@mysql-server56 mysql_script]#

# 模拟修改时间
[root@mysql-server56 mysql_script]# bash drop_db.sh
Wed Apr 21 11:00:00 CST 2021
Warning: Using a password on the command line interface can be insecure.
+--------------------+
| Database           |
+--------------------+
| information_schema |
| K8S                |
| blog               |
| luffy              |
| mysql              |
| performance_schema |
+--------------------+
```

### 问题排查
此时在上午11点，kings数据库以及被删除了，后端代码，或者监控，一定会报错，使用到该kings数据库的人员，一定会投诉到DBA，运维部门。

此时dba超哥需要做如下事

+ 检查网站报错
+ 检查linux上后端代码日志，这里基本上就可以知道无法连接数据库
+ 登录数据库机器，发现数据库消失。。。

因此数据库的权限控制，尤其重要

### 开始恢复
找到原因，就需要开始恢复数据

+ 准备好全量备份数据，0点整的备份文件
+ 备份好所有的binlog增量日志文件，防止二次破坏

```plain
[root@mysql-server56 mysql_script]# cp -a /data/3307/mysql-bin.* /mysql_data/3307/
[root@mysql-server56 mysql_script]# ls /mysql_data/3307/
2021-04-21_3307.sql.gz  mysql-bin.000001  mysql-bin.000002  mysql-bin.000002.sql  mysql-bin.000003  mysql-bin.index
```

停止数据库访问，可以利用如iptables进行屏蔽请求

```plain
# 非127.0.0.1的请求，禁止访问3307端口，这样就禁止除了本地，其他人都无法连接

[root@mysql-server56 mysql_script]# iptables -I INPUT -p tcp --dport 3307 ! -s 127.0.0.1 -j DROP
```

解压缩全量备份的数据

**确保其中，并没有刚才超哥插入的2条数据，孙悟空，猪八戒**  

```plain
[root@mysql-server56 mysql_script]# cd /mysql_data/3307
[root@mysql-server56 3307]# gzip -cd 2021-04-21_3307.sql.gz > kings.sql
[root@mysql-server56 3307]# ls -lrt kings.sql
-rw-r--r-- 1 root root 3538 Apr 21 11:30 kings.sql
```

### 分析binlog日志
全量数据有了，我们就已经有了到4月21号0点整的数据

问题是应该从binlog什么位置开始恢复

答案是，基于binlog的位置，pos参数

因为我们全量备份时，添加了--master-data=2参数，当时记录了数据的一个切割点，也就是如下的mysql-bin.000003 ，数据位置是3704

```plain
[root@mysql-server56 3307]# ls
2021-04-21_3307.sql.gz  kings.sql  mysql-bin.000001  mysql-bin.000002  mysql-bin.000002.sql  mysql-bin.000003  mysql-bin.index
[root@mysql-server56 3307]#

# 开始复制或时间点恢复的位置为
[root@mysql-server56 3307]# sed -n '19,22p' kings.sql
-- Position to start replication or point-in-time recovery from
--

-- CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=3704;
[root@mysql-server56 3307]#
```

可以看到，用于主从数据复制，或者恢复的位置是

mysql-bin.000003，位置是3704

### 解析binlog
从binlog的位置，以及binlog文件，解析出我们能看得懂的SQL语句

**并且可以从基于binlog解析出的SQL文件中，找到我们增量写入的新数据，孙悟空，猪八戒**

```plain
[root@mysql-server56 3307]# mysqlbinlog -d kings mysql-bin.000003 --start-position=3704 -r kings_binlog.sql

```

并且

**找出有问题的sql语句，将其删除，因为我们要恢复数据**

```plain
[root@mysql-server56 3307]# grep -w drop kings_binlog.sql
drop database kings

# 删除该语句
[root@mysql-server56 3307]# sed -i '/drop database kings/d' kings_binlog.sql
[root@mysql-server56 3307]#
[root@mysql-server56 3307]# grep -w drop kings_binlog.sql
[root@mysql-server56 3307]#
```

### 执行恢复
此时此刻，数据库中，仍然是没有tanks数据表的

```plain
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e 'select * from kings.tanks;'
Warning: Using a password on the command line interface can be insecure.
ERROR 1146 (42S02) at line 1: Table 'kings.tanks' doesn't exist
```

先恢复全量备份，也就是0点前的内容

```plain
mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 < /mysql_data/3307/kings.sql

```

图解

<!-- OCR_START -->
- mysqldump -uroot -pyuchao7777 -P3307 -h127.0.0.1 -B --master-data=2 king slgzip >/mysql_data/3307/$(date +%F)_3307.sql.gz
- pos1895
- pos 1346
- pos 468
- 写入新的数据
- pos 200
- 记录新的binlog
- binlog
- 数据写入mysql，通过binlog日志，精确记录数据的变化，也就是events，通过pos定位数据到哪
- 但是增量备份的数据，还未导入
- 全量备份的数据
- 已恢复
<!-- OCR_END -->

#### 全量恢复结果
此时我们的tanks表数据就回来了，但是后续插入的新数据，孙悟空，猪八戒还没有，这是因为数据在增量备份的binlog里

```plain
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 < /mysql_data/3307/kings.sql
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 3307]#
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e 'select * from kings.tanks;'
Warning: Using a password on the command line interface can be insecure.
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           | 18888 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         | 轮回吞噬     | flush           |  9888 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
[root@mysql-server56 3307]#
```

### 恢复增量数据
再恢复binlog解析出的kings_binlog.sql

恢复增量的数据

```plain
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 < /mysql_data/3307/kings_binlog.sql
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e 'select * from kings.tanks;'
Warning: Using a password on the command line interface can be insecure.
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           | 18888 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         | 轮回吞噬     | flush           |  9888 |                             | NULL   | NULL                                                           |
| 12 | 孙悟空       |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 13 | 猪八戒         |              | flush           |     0 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
[root@mysql-server56 3307]#
```

此时mysql数据的全量备份＋binlog增量备份，恢复完毕

觉得超哥笔记写的好的，弹幕、评论，刷一波666~~~

最后注意把时间改回去

```plain
[root@mysql-server56 ~]# ntpdate -u ntp.aliyun.com
21 Apr 18:50:18 ntpdate[12116]: step time server 203.107.6.88 offset 11650.696802 sec
[root@mysql-server56 ~]#
```

## mysql备份架构总结
中小公司做法一般是，每天0点全量备份，数据按照日期备份到数据库本地，且进行定期如七天删除脚本。

主从复制架构，两台mysql服务器，机器A挂了，可以切换机器B，保证数据安全。

但是该方案，无法解决如drop、delete语句这样的删除问题（主从复制，是从库执行一遍主库的动作）

方案是可以通过从库的延迟复制解决。

## 练习
+ 总结
+ 数据库增量备份、全量备份
+ 逻辑备份、物理备份
+ mysql增量备份全流程
+ mysql分库分表备份脚本开发

# MySQL备份之xtrabackup
## 为什么要学这个工具
背景

一个合格的运维工程师或者dba工程师，如果有从事数据库方面的话，首先需要做的就是备份，如果没有备份，出现问题的话，你的业务就会出问题，你的工作甚至会。。。

所以备份是重要的，但光有备份还不行，备份后如果出现问题，你还得使用备份数据来恢复，但恢复数据的时间一般都是很长的，不符合业务需求，所以一个快速备份与恢复的软件就很有必要。

就像前文给大家看的微盟数据库被删。。最后是腾讯云的工程师协助进行数据恢复

## xtrabackup工具
Percona-xtrabackup是 Percona公司开发的一个用于MySQL数据库物理热备的备份工具，支持MySQL、Percona server和MariaDB，开源免费，是目前较为受欢迎的主流备份工具。xtrabackup只能备份innoDB和xtraDB两种数据引擎的表，而不能备份MyISAM数据表。

特点

+ 物理备份工具，拷贝数据文件
+ 备份和恢复数据的速度非常快，安全可靠
+ 在备份期间执行的事务不会间断，备份innodb数据不影响业务
+ 备份期间不增加太多数据库的性能压力
+ 支持对备份的数据自动校验
+ 运行全量，增量，压缩备份及流备份
+ 支持在线迁移表以及快速创建新的从库
+ 运行几乎所有版本的mysql和maridb

### 数据文件扩展名
| **.idb文件** | **以独立表空间存储的InnoDB引擎类型的数据文件扩展名** |
| --- | --- |
| .ibdata文件 | 以共享表空间存储的InnoDB引擎类型的数据文件扩展名 |
| .frm文件 | 存放于表相关的元数据(meta)信息及表结构的定义信息 |
| .MYD文件 | 存放MyISAM引擎表的数据文件扩展名 |
| .MYI文件 | 存放MyISAM引擎表的索引信息文件扩展名 |

### 事务型引擎的ACID特性
目前为止，我们还未学习mysql的引擎，会在后面讲解，大家先了解下对于mysql的引擎是InnoDB

数据库引擎，就像是摩托车的发动机，有各种品牌的发动机

有了发动机，我们可以将摩托车跑起来，且无序关心它是怎么制造动力的

对于数据库的引擎，就是开发人员写好的一种程序，能够让运维不用关心数据是如何增删改查到磁盘上的，通过SQL语句，就可以数据。

因此数据库引擎就是一个用于存储、处理、保护数据的程序。

mysql支持如下图中的几种引擎

<!-- OCR_START -->
- [root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e
- 'showengines;
- Warning: Using a password on the command line interface can be insecure.
- IEngine
- 1Support1Comment
- 1TransactionsIXA
- 1Savepoints1
- |InnoDB
- DEFAULT
- Supports transactions，row-level locking，and foreign keys
- IYES
- YES
- ICSV
- CSV storage engine
- 1NO
- NO
- INO
- IMRG_MYISAM
- CollectionofidenticalMyISAMtables
- BLACKHOLE
- 丨 /dev/null storage engine (anything you write to it disappears) l NO
- I1  MyISAM
- IMyISAM storage engine
- I MEMORY
- |Hash based，stored in memory，useful for temporary tables
- ARCHIVE
- IArchivestorageengine
- IFEDERATED
- IFederatedMysQLstorageengine
- INULL
- NULL
- IPERFORMANCE_SCHEMA
<!-- OCR_END -->

查看当前mysql用的哪一个引擎(哪一款发动机)

```plain
[root@mysql-server56 3307]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e 'show variables like "storage_engine%";'
Warning: Using a password on the command line interface can be insecure.
+----------------+--------+
| Variable_name  | Value  |
+----------------+--------+
| storage_engine | InnoDB |
+----------------+--------+
[root@mysql-server56 3307]#
```

## ACID
在MySQL中，InnoDB和MariaDB中的XtraDB都是事务型引擎，事务型引擎的共同特征是具备事务的4个特性，这4个特性分别是：

原子性（atomicity）

一致性（consistency）

隔离性（isolation）

持久性（durability）

又称为ACID特性。

<!-- OCR_START -->
ACID特性
说明
原子性
事务的所有SOL语句操作，要么全部成功，要么全部失败
一致性
事务开始之前和结束之后，数据库应保证数据的完整性不被破坏
当多个事务并发访问同一个数据源时，数据库能够保持每个访问的事务之间是隔
隔离性
离的，互不影响的
持久性
事务处理完成之后，事务所做的更改都会是持久化存储，不会丢失数据
<!-- OCR_END -->

## InnoDB日志名词
有关innodb引擎原理的知识，后面专门学习，这里不需要关心太多

需要了解下InnoDB日志的原理词汇

+ redo日志 redo日志，也称事务日志，是innodb引擎的重要组成部分，作用是记录innodb引擎中每一个数据发生的变化信息。主要用于保证innodb数据的完整性，以及丢数据后的恢复，同时可以有效提升数据库的io等性能。redo日志对应的配置参数为innodb_log_file_size和innodb_log_files_in_group
+ Undo日志 Undo是记录事务的逆向逻辑操作或者向物理操作对应的数据变化的内容，undo日志默认存放在共享表空间里面的ibdata*文件，和redo日志功能不同undo日志主要用于回滚数据库崩溃前未完整提交的事务数据,确保数据恢复前后一致。
+ LSN LSN，全拼log sequence number,中文是日志序列号，是一个64位的整型数字，LSN的作用是记录redo日志时，使用LSN唯一标识一条变化的数据。
+ checkpoint 用来标识数据库崩溃后,应恢复的redo log的起始点

## Xtrabackup备份原理
### 工作原理流程
xtrabackup软件基于innodb等事务引擎自带的redo日志和undo功能来保证备份、恢复的数据一致性，确保数据可靠

redo日志文件会存储每一个table中的数据修改记录

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 名称 | 排名 | 名称 |
| --- | --- | --- | --- | --- | --- |
| 记录LSN并监控redo日志的变化，且将 | 开始 | 变化实时记录到xtrabackuplogfile | Xtrabackup | 1 | 开始复制InnoDB对应的物理数据 |
| 文件（*ibd或*.ibdataN） | 2 | 执行“flush tableswith read lock”命令 | 时 | 3 | 间 |
| 轴 | 4 | 开始复制MyISAM对应的物理数据 | 文件（.FRM、.MYD及.MYI） | 5 | 获取二进制日志（binlog）位置信息 |
| 6 | 停止记录xtrabackup_logfile并执行 | 7 | unlocktables解锁 | 结束 | 备份完成 |
<!-- OCR_END -->

xtrabackup备份流程原理

+ xtrabackup程序开始备份时，该软件记录当前redo日志的位置（对应的LSN）号，且在后台启动一个进程持续监视redo日志文件变化，将变化的信息，写入到xtrabackup_logfile中
+ 针对所有的innodb数据文件进行复制，待inndob数据文件备份完成后
+ 执行命令flush tables with read lock，对整个数据库锁表
+ 然后再复制myisam非事务引擎的数据文件
+ 待所有的数据文件全都备份完毕后，获取binlog位置信息，也就是当前数据写到哪了
+ 解锁表unlock tables，恢复数据库的读写
+ 备份完成

图解

<!-- OCR_START -->
- Innobackupex
- xtrabackup备份流程图
- Xtrabackup
- （1）Fork一个进程启动-
- （2）启动redo拷贝线程，进行拷贝redo.log-
- redo拷贝线程
- innodebackupex
- 进程等待中
- （3）启动ibd拷贝线程
- ibd拷贝线程
- 进行拷贝ibd数据文件
- 从最新的
- （5）通知innobackupex
- （4）ibd数据考贝完成，线程退出
- -ibd数据考贝完成，xtrabackup
- checkpoint
- 进入等待状态
- 进行拷贝
- redo. log
- Xtrabackup进程
- （6）收到通知后，执行FTWRL，
- 等待redo.log烤
- 取得一致性位点，开始备份非
- 贝完成
- InnoDB文件
- （7）拷贝frm，MYD，MYI，etc
- 文件，此时数据库处于全局只读
- 状态
- （8）通知xtrabackup
- （9）收到通知后，停止redo拷贝线程
- 非innoDB文件拷贝完毕
- （11）通知innobackupex
- （10）redo.log拷贝完成，线程退出
- redo.log拷贝结束
- （12）收到redo备份完成的通知
- 后，开始解锁，执行UNLOCK
- TABLES
- （13）等待子进程xtrabackup结束
- (14）xtrabackup结束退出
- （15）备份结束
<!-- OCR_END -->

原理可能目前看的一头雾水，不慌，实际搭建完毕后，再回过头梳理下。

## 安装
超哥的环境

```plain
[root@mysql-server56 3307]# cat /etc/redhat-release
CentOS Linux release 7.5.1804 (Core)
[root@mysql-server56 3307]#
[root@mysql-server56 3307]# uname -r
3.10.0-1160.11.1.el7.x86_64
```

yum安装基础环境

```plain
[root@mysql-server56 3307]# yum install perl perl-devel libaio libaio-devel perl-Time-HiRes perl-DBD-MySQL -y

```

安装xtrabackup,centos7版本  

```plain
[root@mysql-server56 mysql_script]# wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.9/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.9-1.el7.x86_64.rpm

# yum本地安装
[root@mysql-server56 mysql_script]# yum localinstall percona-xtrabackup-24-2.4.9-1.el7.x86_64.rpm -y

# 查看
[root@mysql-server56 mysql_script]# ls -l `which xtrabackup innobackupex`
lrwxrwxrwx 1 root root       10 Apr 21 13:54 /usr/bin/innobackupex -> xtrabackup
-rwxr-xr-x 1 root root 21659096 Nov 23  2017 /usr/bin/xtrabackup
```

## 应用实践
### 命令介绍
```plain
Xtrabackup中主要包含两个工具：
xtrabackup：是用于热备innodb，xtradb表中数据的工具，不能备份其他类型的表，也不能备份数据表结构；
innobackupex：是将xtrabackup进行封装的perl脚本，提供了备份myisam表的能力。
常用选项:  
   --host     指定主机
   --user     指定用户名
   --password    指定密码
   --port     指定端口
   --databases     指定数据库
   --incremental    创建增量备份
   --incremental-basedir   指定包含完全备份的目录
   --incremental-dir      指定包含增量备份的目录   
   --apply-log        对备份进行预处理操作             

一般情况下，在备份完成后，数据尚且不能用于恢复操作，因为备份的数据中可能会包含尚未提交的事务或已经提交但尚未同步至数据文件中的事务。因此，此时数据文件仍处理不一致状态。“准备”的主要作用正是通过回滚未提交的事务及同步已经提交的事务至数据文件也使得数据文件处于一致性状态。
   --redo-only      不回滚未提交事务
   --copy-back     恢复备份目录
```

参数 
<!-- OCR_START -->
- （续）
- 参数
- 说明
- --defaults-file
- 指定MySQL的配置文件备份
- --defaults-group=GROUP-NAME
- 在多实例的时候使用
- --databases
- 指定需要备份的数据库，多个数据库之间以空格分开
- --incremental
- 增量备份，后面跟要增量备份的路径
- --incremental-basedir=DIRECTORY
- 增量备份使用，上一次（全备）增量备份所在的目录
- 增量备份还原的时候用来合并增量备份到全备份，指定增量备份
- --incremental-dir=DIRECTORY
- 的路径
- --no-timestamp
- 生成的备份文件不以时间戳为目录
- 会记录主库binlog的位置点，并保存到xtrabackup_slave_info文
- --slave-info
- 件里，用于主从复制
- 该参数的作用是暂停SLAVE库的SQL线程，待备份结束后又会
- --safe-slave-backup
- 启动SQL线程，目的是保证备份前后数据的一致性，类似锁表停
- 止写人数据到数据库
- --stream=tar
- 备份结果以tar的文件流方式输出
- --include=oldboy
- 备份包含的库表
- --throttle=500
- I/O较多的话，可以限定I/O操作
- --apply-log
- 回滚未提交的事务数据，应用redo日志数据
- --use-memory
- 恢复时使用内存大小选项（需要和--apply-log一起使用)
- --copy-back
- 将备份数据复制回原始位置（也可以用mv直接复制）
- 用于合并多份增量备份，只应用redo日志数据，而不应用undo
- --redo-only
- 日志回滚数据，执行最后一次增量合并应忽略该参数
- --rsync
- 加快本地文件传输，适用于non-InnoDB数据库引擎
- --parallel=N
- 当数据库比较大的时候，增加多线程备份，N为数字
<!-- OCR_END -->

Xtrabackup命令是专门用于对InnoDB和XtraDB等事务引擎的数据库热备份的工具，不能用于备份MyISAM等其他类型的引擎数据，其主要特点是备份数据时完全不用锁表。

Innobackupex命令是将上述Xtrabackup命令使用perl脚本进行二次封装的工具，除了可以用于InnoDB和XtraDB等引擎之外，还可以备份MyISAM及多种引擎混合使用的场景，该命令的主要特点是备份事务引擎数据而不用锁表，可以备份非事务引擎数据，但要锁表。

DBA用的最多的是Innobackupex命令备份恢复

## 创建数据备份用户
```plain

[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 44
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create user 'backup'@'localhost' identified by 'chaoge888';
Query OK, 0 rows affected (0.00 sec)

# 回收用户默认权限
mysql> REVOKE ALL PRIVILEGES ON *.* FROM 'backup'@'localhost';
Query OK, 0 rows affected (0.00 sec)

# 授权部分权限
mysql> grant reload,lock tables,process,replication client on *.* to 'backup'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

## （忽略此步骤）
创建mysql日志文件目录  

```plain
[root@mysql-server56 ~]# mkdir -p /xtrabackup/{log,cnf,data,mysql}
[root@mysql-server56 ~]# chown -R mysql.mysql /xtrabackup/
[root@mysql-server56 /]# ls -l /xtrabackup/
total 0
drwxr-xr-x 2 mysql mysql 6 Apr 21 14:56 cnf
drwxr-xr-x 2 mysql mysql 6 Apr 21 14:56 log
```

编写新配置文件

```plain
# egrep -v "#|^$" /xtrabackup/cnf/my.cnf
[client]
user=root
password=yuchao7777

[mysqld]
basedir = /xtrabackup/mysql                    #<==增加MySQL根目录。
datadir = /xtrabackup/data                     #<==MySQL数据目录，Xtrabackup
                                               恢复数据时需要这个目录。
###########binlog############
log_bin = /xtrabackup/logs/mysql-bin  #<==二进制日志路径调整，尽可能在装数据库前就调整好。

expire_logs_days = 7

###########slow log###########
slow-query-log = ON    # 慢查询日志
long_query_time = 2 # 查询阈值，超过了该阈值则记录到慢查询日志中
log_queries_not_using_indexes = ON # 记录所有未使用索引的SQL，无论是否超过long_query_time所设置的值。
slow-query-log-file = /xtrabackup/logs/slow.log  #<==慢查询日志路径调整。
min_examined_row_limit = 800 # 表示返回行数大于等于该值的sql，将会被记录到slow log中。

[mysqld_safe]
log-error = /xtrabackup/logs/mysql-error.log      
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
```

## 全量备份与恢复
备份王者荣耀数据库kings

```plain
# 这是现有数据
[root@mysql-server56 data]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "select * from kings.tanks;"
```

准备一个用于备份的文件夹

```plain
mkdir -p /xtrabackup/data/

```

执行备份命令

```plain
[root@mysql-server56 data]# innobackupex --defaults-file=/data/3307/my.cnf --user=root --password=yuchao7777 --socket=/data/3307/mysql.sock --no-timestamp /xtrabackup/data/all_db

```

### 执行命令结果
部分如下  

```plain
[root@mysql-server56 data]# innobackupex --defaults-file=/data/3307/my.cnf --user=root --password=yuchao7777 --socket=/data/3307/mysql.sock --no-timestamp /xtrabackup/data/all_db
210421 18:54:15 innobackupex: Starting the backup operation

IMPORTANT: Please check that the backup run completes successfully.
           At the end of a successful backup run innobackupex
           prints "completed OK!".

shell-init: error retrieving current directory: getcwd: cannot access parent directories: No such file or directory
/bin/pwd: couldn't find directory entry in ‘..’ with matching i-node
210421 18:54:15  version_check Connecting to MySQL server with DSN 'dbi:mysql:;mysql_read_default_group=xtrabackup;port=3307;mysql_socket=/data/3307/mysql.sock' as 'root'  (using password: YES).
210421 18:54:15  version_check Connected to MySQL server
210421 18:54:15  version_check Executing a version check against the server...
210421 18:54:15  version_check Done.
210421 18:54:15 Connecting to MySQL server host: localhost, user: root, password: set, port: 3307, socket: /data/3307/mysql.sock
Using server version 5.6.40-log
innobackupex version 2.4.9 based on MySQL server 5.7.13 Linux (x86_64) (revision 
210421 18:54:16 Finished backing up non-InnoDB tables and files
210421 18:54:16 [00] Writing /xtrabackup/data/all_db/xtrabackup_binlog_info
210421 18:54:16 [00]        ...done

....

# 停止日志监控

xtrabackup: Stopping log copying thread.
.210421 18:54:16 >> log scanned up to (1957778)

# 停止锁表

210421 18:54:17 Executing UNLOCK TABLES
210421 18:54:17 All tables unlocked
210421 18:54:17 Backup created in directory '/xtrabackup/data/all_db/'
MySQL 
binlog position: filename 'mysql-bin.000005', position '120'
210421 18:54:17 [00] Writing /xtrabackup/data/all_db/backup-my.cnf
210421 18:54:17 [00]        ...done
210421 18:54:17 [00] Writing /xtrabackup/data/all_db/xtrabackup_info
210421 18:54:17 [00]        ...done
xtrabackup: Transaction log of lsn (1957778) to (1957778) was copied.

# 备份成功

210421 18:54:17 completed OK!
[root@mysql-server56 data]#
```

  

## 检查备份的数据
我们mysql中的数据

```plain
[root@mysql-server56 data]#  mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e 'show databases;'
Warning: Using a password on the command line interface can be insecure.
+--------------------+
| Database           |
+--------------------+
| information_schema |
| K8S                |
| blog               |
| kings              |
| luffy              |
| mysql              |
| performance_schema |
+--------------------+
```

xtrabackup备份的数据目录

```plain
[root@mysql-server56 data]# ls /xtrabackup/data/all_db/ -l
total 77852
-rw-r----- 1 root root      418 Apr 21 18:54 backup-my.cnf    # 配置文件备份
drwxr-x--- 2 root root       20 Apr 21 18:54 blog    # 数据库备份
-rw-r----- 1 root root 79691776 Apr 21 18:54 ibdata1    # 共享表空间备份
drwxr-x--- 2 root root       20 Apr 21 18:54 K8S # 数据库备份
drwxr-x--- 2 root root       88 Apr 21 18:54 kings # 数据库备份
drwxr-x--- 2 root root       20 Apr 21 18:54 luffy # 数据库备份
drwxr-x--- 2 root root     4096 Apr 21 18:54 mysql # 数据库备份
drwxr-x--- 2 root root     4096 Apr 21 18:54 performance_schema # 数据库备份
# #mysql服务器当前正在使用的二进制日志文件和此时二进制日志时间的位置信息文件
-rw-r----- 1 root root       21 Apr 21 18:54 xtrabackup_binlog_info 
# 备份的类型、状态和LSN状态信息文件
-rw-r----- 1 root root      113 Apr 21 18:54 xtrabackup_checkpoints 
# 日志备份
-rw-r----- 1 root root      559 Apr 21 18:54 xtrabackup_info
-rw-r----- 1 root root     2560 Apr 21 18:54 xtrabackup_logfile
```

## 查看备份内容
binlog记录数据位置，以及日志文件  

```plain
[root@mysql-server56 data]# cat /xtrabackup/data/all_db/xtrabackup_binlog_info
mysql-bin.000005    120
```

备份的数据信息

```plain
[root@mysql-server56 data]# cat /xtrabackup/data/all_db/xtrabackup_checkpoints
backup_type = full-backuped    # 备份类型，全量备份
from_lsn = 0            # 起点
to_lsn = 1957778    # 结束点
last_lsn = 1957778 
compact = 0
recover_binlog_info = 0
```

## 全备恢复数据
模拟数据删除，直接操作mysql数据目录  

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 stop
MySQL is stopped...

[root@mysql-server56 data]# mv /data/3307/data/ /data/3307/data_ori

[root@mysql-server56 data]# mkdir -p /data/3307/data
[root@mysql-server56 ~]# ls /data/3307/data
```

在恢复数据之前，先执行如下命令，确保数据一致性，同时回滚未提交事务的日志数据

使用32M内存进行恢复，对内存限制，防止占用过多机器资源

--apply-log 读取redo日志

```plain
[root@mysql-server56 data]# innobackupex --apply-log --use-memory=32M /xtrabackup/data/all_db/

210421 19:24:05 completed OK!
```

### 恢复数据
可以直接用mv命令，恢复数据，和xtrabackup命令本质上一样的，都是直接复制物理文件

```plain
[root@mysql-server56 ~]# mv /xtrabackup/data/all_db/* /data/3307/data/

```

也可以用如下命令，作用一样，这2个方式，二选一即可

```plain
[root@mysql-server56 ~]# innobackupex --defaults-file=/data/3307/my.cnf --copy-back --rsync /xtrabackup/data/all_db/

# 检查数据文件
[root@mysql-server56 ~]# ls /xtrabackup/data/all_db
backup-my.cnf  ibdata1      ib_logfile1  K8S    luffy  performance_schema      xtrabackup_binlog_pos_innodb  xtrabackup_info
blog           ib_logfile0  ibtmp1       kings  mysql  xtrabackup_binlog_info  xtrabackup_checkpoints        xtrabackup_logfile
[root@mysql-server56 ~]#
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# ls /data/3307/data
blog     ib_logfile0  ibtmp1  kings  mysql               xtrabackup_binlog_pos_innodb
ibdata1  ib_logfile1  K8S     luffy  performance_schema  xtrabackup_info

[root@mysql-server56 ~]# chown -R mysql.mysql /data/3307/data/
```

重新启动

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 start
Starting MySQL...

# 数据库恢复正常
mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "select * from kings.tanks;"
```

## 增量备份与恢复
增量备份之前，仍然是要进行一次全量备份

后续的增量备份，就是依次增加增量的数据

### 一、先基础全备份
和前面的命令一样  

```plain
[root@mysql-server56 ~]# innobackupex --defaults-file=/data/3307/my.cnf --user=root --password=yuchao7777 --socket=/data/3307/mysql.sock --no-timestamp /xtrabackup/data/all_db2/

# 查看
[root@mysql-server56 ~]# ls /xtrabackup/data/
all_db  all_db2
```

  

### 二、增量数据写入
在全量备份之后，继续写入数据，模拟增量备份

```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "insert into kings.tanks(id,name) values(15,'夏侯惇');"

[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "insert into kings.tanks(id,name) values(16,'孙策');"
Warning: Using a password on the command line interface can be insecure.

# 结果
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "select * from kings.tanks;"
Warning: Using a password on the command line interface can be insecure.
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           | 18888 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         | 轮回吞噬     | flush           |  9888 |                             | NULL   | NULL                                                           |
| 12 | 雅典娜       |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 13 | 张飞         |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 15 | 夏侯惇       |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 16 | 孙策         |              | flush           |     0 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
[root@mysql-server56 ~]#
```

### 三、做一次增量备份
单词increment，增量的意思

第一次增量备份

--incremental-basedir=/xtrabackup/data/all_db2/ # 填入上一次全量备份的目录

--incremental /xtrabackup/data/all_db_increment # 填入增量备份的目录

```plain
[root@mysql-server56 ~]# innobackupex --defaults-file=/data/3307/my.cnf --user=root --password=yuchao7777 --socket=/data/3307/mysql.sock --no-timestamp --incremental-basedir=/xtrabackup/data/all_db2/ --incremental /xtrabackup/data/all_db_increment

```

正确备份后的结果

```plain
210421 21:32:59 Executing UNLOCK TABLES
210421 21:32:59 All tables unlocked
210421 21:32:59 Backup created in directory '/xtrabackup/data/all_db_increment/'
MySQL binlog position: filename 'mysql-bin.000006', position '583'
210421 21:32:59 [00] Writing /xtrabackup/data/all_db_increment/backup-my.cnf
210421 21:32:59 [00]        ...done
210421 21:32:59 [00] Writing /xtrabackup/data/all_db_increment/xtrabackup_info
210421 21:32:59 [00]        ...done
xtrabackup: Transaction log of lsn (1960586) to (1960586) was copied.
210421 21:32:59 completed OK!
```

检查增量备份的目录

```plain
[root@mysql-server56 ~]# ls /xtrabackup/data/all_db_increment/
backup-my.cnf  blog  ibdata1.delta  ibdata1.meta  K8S  kings  luffy  mysql  performance_schema  xtrabackup_binlog_info  xtrabackup_checkpoints  xtrabackup_info  xtrabackup_logfile
[root@mysql-server56 ~]#
```

  
对于增量备份的数据，是

+ 从全备信息的的LSN开始读取redo日志，对改变的数据进行增量备份

### 四、再次增量备份
再次插入数据，进行第二次增量备份  

```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "insert into kings.tanks(id,name) values(17,'牛魔');"
Warning: Using a password on the command line interface can be insecure.

[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "insert into kings.tanks(id,name) values(18,'钟无艳');"
Warning: Using a password on the command line interface can be insecure.
```

开始第二次增量备份

注意，这里使用上一次增量备份的目录，而不是全量备份了

--parallel=3 开启3个线程备份，当数据量较大时候

```plain
[root@mysql-server56 ~]# innobackupex --defaults-file=/data/3307/my.cnf --user=root --password=yuchao7777 --socket=/data/3307/mysql.sock --no-timestamp --parallel=3 --incremental-basedir=/xtrabackup/data/all_db_increment/ --incremental /xtrabackup/data/all_db_increment_2/

```

一定看清楚超哥的命令，以及对应的参数目录

至此，就完成了一次全量备份，以及后两次的增量备份。

### 五、增量数据恢复
步骤是

+ 先恢复全量备份数据，/xtrabackup/data/all_db2/
+ 再恢复第一次增量备份的数据，/xtrabackup/data/all_db_increment/
+ 再恢复第二次增量的数据，依次类推/xtrabackup/data/all_db_increment_2/

#### 合并多份增量备份日志
应用redo日志恢复全备数据

注意，只要不是最后一次合并增量数据，就要加--redo-only参数，作用是只应用redo日志恢复数据，不执行undo回滚未提交的数据。

等到最后一次增量日志合并，就要进行undo日志回滚，也就是不加该参数了。

图解

<!-- OCR_START -->
- 合并增量备份
- --apply-log
- 增量备份 2
- 增量备份 1
- 全量备份
<!-- OCR_END -->

第一步，应用redo日志恢复全备数据

```plain
[root@mysql-server56 ~]# innobackupex --apply-log --use-memory=32M --redo-only /xtrabackup/data/all_db2/

```

第二步，合并第一次的增量数据到全备数据目录

```plain
[root@mysql-server56 ~]# innobackupex --apply-log --use-memory=32M --redo-only --incremental-dir=/xtrabackup/data/all_db_increment/  /xtrabackup/data/all_db2/

```

第三步，合并第二次的增量数据，到全备目录，注意最后一次，没有 --redo-only参数

```plain
[root@mysql-server56 ~]# innobackupex --apply-log --use-memory=32M  --incremental-dir=/xtrabackup/data/all_db_increment_2/  /xtrabackup/data/all_db2/

```

第四步，对全量数据进行redo日志应用，执行undo回滚数据

```plain
[root@mysql-server56 ~]# innobackupex --apply-log --use-memory=32M /xtrabackup/data/all_db2/

```

  

### 正式恢复数据
模拟数据丢失，删除数据，用超哥这次定义的全备目录/xtrabackup/data/all_db2/

```plain
# 1.停止数据库
[root@mysql-server56 ~]# /data/3307/mysql_3307 stop
Stoping MySQL...

# 2.清空原有3307数据库的所有数据
[root@mysql-server56 ~]# mv  /data/3307/data /data/3307/data_ori_increment
[root@mysql-server56 ~]#
[root@mysql-server56 ~]# mkdir -p /data/3307/data

# 3.此时mysql的数据目录，是空的，也无法正常启动
[root@mysql-server56 ~]# ls /data/3307/data

# 4.恢复数据
[root@mysql-server56 ~]# innobackupex --defaults-file=/data/3307/my.cnf --copy-back --rsync /xtrabackup/data/all_db2/

# 5.授权用户
[root@mysql-server56 ~]# chown -R mysql.mysql /data/3307/data
[root@mysql-server56 ~]# ls /data/3307/data -l
total 188432
drwxr-x--- 2 mysql mysql       20 Apr 21 22:12 blog
-rw-r----- 1 mysql mysql 79691776 Apr 21 22:12 ibdata1
-rw-r----- 1 mysql mysql 50331648 Apr 21 22:12 ib_logfile0
-rw-r----- 1 mysql mysql 50331648 Apr 21 22:12 ib_logfile1
-rw-r----- 1 mysql mysql 12582912 Apr 21 22:12 ibtmp1
drwxr-x--- 2 mysql mysql       20 Apr 21 22:12 K8S
drwxr-x--- 2 mysql mysql       88 Apr 21 22:12 kings
drwxr-x--- 2 mysql mysql       20 Apr 21 22:12 luffy
drwxr-x--- 2 mysql mysql     4096 Apr 21 22:12 mysql
drwxr-x--- 2 mysql mysql     4096 Apr 21 22:12 performance_schema
-rw-r----- 1 mysql mysql       22 Apr 21 22:12 xtrabackup_binlog_pos_innodb
-rw-r----- 1 mysql mysql      663 Apr 21 22:12 xtrabackup_info
[root@mysql-server56 ~]#
```

收尾，启动mysql，查看数据是否回来

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 start
Starting MySQL...
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "select * from kings.tanks;"
Warning: Using a password on the command line interface can be insecure.
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
| id | name         | skills       | summoner_skills | price | introduction                | camp   | pic                                                            |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
|  1 | 亚瑟         | 圣剑裁决     | flush           |  5888 | 能抗能打，技能沉默          | 近战   | https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg |
|  3 | 东皇太一     | 堕神契约     | flush           |     0 |                             | NULL   | NULL                                                           |
|  4 | 吕布         | 魔神降临     | flush           | 18888 |                             | NULL   | NULL                                                           |
|  9 | 庄周         |              | flush           |  7777 |                             | NULL   | NULL                                                           |
| 10 | 关羽         |              | flush           |  8888 |                             | NULL   | NULL                                                           |
| 11 | 钟馗         | 轮回吞噬     | flush           |  9888 |                             | NULL   | NULL                                                           |
| 12 | 雅典娜       |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 13 | 张飞         |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 15 | 夏侯惇       |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 16 | 孙策         |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 17 | 牛魔         |              | flush           |     0 |                             | NULL   | NULL                                                           |
| 18 | 钟无艳       |              | flush           |     0 |                             | NULL   | NULL                                                           |
+----+--------------+--------------+-----------------+-------+-----------------------------+--------+----------------------------------------------------------------+
[root@mysql-server56 ~]#
```

## 总结
至此，我们全量备份，以及额外写入的数据，增量备份，全部都备份回来了。  

# MySQL日志


<!-- OCR_START -->
> MySQL.
<!-- OCR_END -->



<!-- OCR_START -->
- MySQL日志类型
- 解释说明
- 错误日志（errorlog）
- 当数据库启动、运行、停止时产生该日志
- 普通查询日志（generalquerylog）
- 客户端连接数据库执行语句时产生该日志
- 二进制日志（binarylog）
- 当数据库内容发生改变时产生该日志，也被用来实现主从复制功能
- 中继日志（relaylog）
- 从库上收到主库的数据更新时产生该日志
- 慢查询日志（slowquerylog）
- SQL语句在数据库查询超过指定时间时产生该日志
- DDL日志（metadatalog）
- 执行DDL语句操作元数据时产生该日志
<!-- OCR_END -->

日志的作用，不说大家应该都知道，可以收集、检测我们程序的健康状况

默认这些日志，大部分是未开启的，运维小于可以通过命令、配置文件，开启这些日志，以及定义存储路径。

mysql日志文件的作用：

1、能记录物理数据页面的修改的信息；

2、能将数据从逻辑上恢复至事务之前的状态；

3、能以二进制文件的形式记录了数据库中的操作；

4、能记录错误的相关信息；

5、能从主服务器中二进制文件取的事件等等。

## 普通日志
记录了服务器接收到的每一个查询或是命令，无论这些查询或是命令是否正确甚至是否包含语法错误，general log 都会将其记录下来 ，记录的格式为 {Time ，Id ，Command，Argument }。

也正因为mysql服务器需要不断地记录日志，开启General log会产生不小的系统开销。 因此，Mysql默认是把General log关闭的。

```plain
mysql> show variables like 'general_log%';
+------------------+------------------------------------+
| Variable_name    | Value                              |
+------------------+------------------------------------+
| general_log      | OFF                                |
| general_log_file | /data/3307/data/mysql-server56.log |
+------------------+------------------------------------+
2 rows in set (0.00 sec)
```

可以开启该功能，命令临时修改

```plain
mysql> set global general_log = on;
Query OK, 0 rows affected (0.00 sec)

mysql> set global general_log = on;
Query OK, 0 rows affected (0.00 sec)

mysql> show variables like 'general_log%';
+------------------+------------------------------------+
| Variable_name    | Value                              |
+------------------+------------------------------------+
| general_log      | ON                                 |
| general_log_file | /data/3307/data/mysql-server56.log |
+------------------+------------------------------------+
2 rows in set (0.00 sec)
```

可以永久开启生效

```plain
# 修改/data/3307/my.cnf

[mysqld]
user=mysql
port=3307
socket=/data/3307/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3307/data
log-bin=/data/3307/mysql-bin
server-id=6
secure_file_priv=''
general_log=on
general_log_file=/data/3307/data/mysql-server56.log
```

重启mysql查看

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 restart
Restarting MySQL...
Stoping MySQL...
Starting MySQL...
[root@mysql-server56 ~]#
```

## 查看日志内容
```plain
[root@mysql-server56 ~]# tail -f /data/3307/data/mysql-server56.log
/application/mysql-5.6.40-linux-glibc2.12-x86_64/bin/mysqld, Version: 5.6.40-log (MySQL Community Server (GPL)). started with:
Tcp port: 3307  Unix socket: /data/3307/mysql.sock
Time                 Id Command    Argument
210422  9:08:48        2 Query    show variables like 'general_log%'
210422  9:09:21        2 Quit
/application/mysql-5.6.40-linux-glibc2.12-x86_64/bin/mysqld, Version: 5.6.40-log (MySQL Community Server (GPL)). started with:
Tcp port: 3307  Unix socket: /data/3307/mysql.sock
Time                 Id Command    Argument
```

<!-- OCR_START -->
- root@mysql-server56:~
- 82
- 100%
- 8%
- 10GB
- 4/22,10:55
- 8yuchao
- □~
- root@mysql-server56:~ (ssh)
- /application/mysql-5.6.40-linux-glibc2.12-x86_64/bin/mysqld,Version:5.6.40-log (MySQL Community Server (GPL)).started with:
- Tcp port:3307
- Unix socket:/data/3307/mysql.sock
- Time
- Id Command
- Argument
- 210422
- 9:08:48
- 2 Query
- show variables like'general_log%'
- 210422 9:09:21
- 2 Quit
- 210422 10:36:30
- 1 Connect
- root@localhost on
- 1 Query
- select @@version_comment limit 1
- select * from kings.tanks
- 1 Quit
- 210422 10:37:03
- 2Connect
- delete from kings.tanks where id=4
- I id丨 name
- Iskills
- |summoner_skills|priceIintroduction
- camp
- I pic
- -+--
- 11
- 亚瑟
- 圣剑裁决
- |flush
- 5888丨能抗能打，技能沉默
- 近战
- 1https://img.18183.com/uploads/allimg/190924/266-1Z9241Q224.jpg
- 31东皇太一
- 堕神契约
- NULL
- 1  NULL
- 41
- 吕布
- 魔神降临
- |18888
- I1 NULL
- 91庄周
- 7777
- 101
- 关羽
- 88881
- 钟道
- 丨轮回吞噬
- 98881
- 12
- 雅典娜
- 01
- 13
- 张飞
- 15
- |夏侯
- 16
- 丨孙策
- 117
- 丨牛魔
- I NULL
- 118丨钟无艳
- mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e"delete from kings.tanks where id=4;"
- Warning:Usingapassword_onthecommandlineinterfacecan beinsecure.
<!-- OCR_END -->

  
对于普通日志的功能，一般都是关闭的，查询日志的信息量很大，网站用户的海量请求，日志频繁写入，对于磁盘的IO影响很大。

但是对于网访问量不大，并且企业对于SQL审计要求较高，可以开启该功能

## 二进制日志binlog
binlog是记录数据库被修改的SQL语句，对数据造成影响了。

一般是DDL和DML语句，包含

+ insert
+ update
+ delete
+ create
+ drop
+ alter
+ 等关键字

### 作用
记录mysql数据的增量数据，且用来做增量数据恢复，前面超哥已经完整的讲过、全量备份、增量备份的区别，如果不开启binlog，将无法恢复完整的数据。

以及用在主从数据复制

### 查看binlog
确保配置文件，开启该功能  
  

```plain

[mysqld]
user=mysql
port=3307
socket=/data/3307/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3307/data
log-bin=/data/3307/mysql-bin        # 二进制日志开启
server-id=6
secure_file_priv=''
# 关掉普通日志
#general_log=on
#general_log_file=/data/3307/data/mysql-server56.log
```

重启

```plain
[root@mysql-server56 ~]# /data/3307/mysql_3307 restart
Restarting MySQL...
Stoping MySQL...
Starting MySQL...
[root@mysql-server56 ~]#
```

查看日志

```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like 'log_bin';"
Warning: Using a password on the command line interface can be insecure.
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    | # 记录binlog开关
+---------------+-------+

[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like '%log_bin';"
Warning: Using a password on the command line interface can be insecure.
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    | # 记录binlog开关
| sql_log_bin   | ON    | # 临时关闭binlog开关
```

## 临时关闭binlog
作用在于用户进行数据恢复的时候，某些SQL（例如恢复的SQL语句）不希望被记录到binlog，可以临时关闭binlog的记录。  

```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> set session sql_log_bin = OFF;
Query OK, 0 rows affected (0.00 sec)

mysql> show variables like '%log_bin';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    |
| sql_log_bin   | OFF   |
+---------------+-------+
2 rows in set (0.00 sec)

# 查看当前的binlog记录状态
mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |       167 |
| mysql-bin.000002 |       167 |
| mysql-bin.000003 |      7818 |
| mysql-bin.000004 |       143 |
| mysql-bin.000005 |       143 |
| mysql-bin.000006 |      1069 |
| mysql-bin.000007 |       143 |
| mysql-bin.000008 |       355 |
| mysql-bin.000009 |       120 | # 最新的binlog文件，以及数据的位置在哪
+------------------+-----------+
9 rows in set (0.00 sec)

# 也可以直接看最新的binlog
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000009 |      120 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

测试写入数据，查看binlog是否变化

```plain
mysql> create database yuyu;
Query OK, 1 row affected (0.00 sec)

# 没有变化
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000009 |      120 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

再开启binlog，发现binlog已经有了变化，因为我们又写入了新的数据

```plain
mysql> set session sql_log_bin=on;
Query OK, 0 rows affected (0.00 sec)

mysql> create database yuyu2;
Query OK, 1 row affected (0.00 sec)

mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000009 |      217 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)

# 删除动作，也会被binlog记录
mysql> drop database yuyu;
Query OK, 0 rows affected (0.00 sec)

mysql> drop database yuyu2;
Query OK, 0 rows affected (0.01 sec)

mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000009 |      389 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

## 自动刷新binlog
binlog上面会发现有很多文件，这是因为

+ 数据库重启，会自动切割新的binlog
+ 执行mysqldump -F或者mysqladmin flush-logs都会刷新binlog
+ binlog达到1G时，自动刷新binlog

查看binlog最大值  

```plain
mysql> show variables like 'max_binlog_size';
+-----------------+------------+
| Variable_name   | Value      |
+-----------------+------------+
| max_binlog_size | 1073741824 |
+-----------------+------------+
1 row in set (0.00 sec)
```

## 二进制binlog索引文件
```plain
[root@mysql-server56 ~]# ls -l /data/3307/mysql-bin.*
-rw-rw---- 1 mysql mysql  167 Apr 20 20:55 /data/3307/mysql-bin.000001
-rw-rw---- 1 mysql mysql  167 Apr 20 20:55 /data/3307/mysql-bin.000002
-rw-rw---- 1 root  root   775 Apr 20 22:30 /data/3307/mysql-bin.000002.sql
-rw-rw---- 1 mysql mysql 7818 Apr 21 15:14 /data/3307/mysql-bin.000003
-rw-rw---- 1 mysql mysql  143 Apr 21 15:16 /data/3307/mysql-bin.000004
-rw-rw---- 1 mysql mysql  143 Apr 21 19:22 /data/3307/mysql-bin.000005
-rw-rw---- 1 mysql mysql 1069 Apr 21 22:08 /data/3307/mysql-bin.000006
-rw-rw---- 1 mysql mysql  143 Apr 22 10:31 /data/3307/mysql-bin.000007
-rw-rw---- 1 mysql mysql  355 Apr 22 11:03 /data/3307/mysql-bin.000008
-rw-rw---- 1 mysql mysql  389 Apr 22 11:26 /data/3307/mysql-bin.000009
-rw-rw---- 1 mysql mysql  252 Apr 22 11:03 /data/3307/mysql-bin.index
```

该文件用于记录binlog的索引号

```plain
[root@mysql-server56 ~]# cat /data/3307/mysql-bin.index
/data/3307/mysql-bin.000001
/data/3307/mysql-bin.000002
/data/3307/mysql-bin.000003
/data/3307/mysql-bin.000004
/data/3307/mysql-bin.000005
/data/3307/mysql-bin.000006
/data/3307/mysql-bin.000007
/data/3307/mysql-bin.000008
/data/3307/mysql-bin.000009
```

  

## 清除binlog
binlog日志也是需要删除的、如当全量备份后，之前的binlog也就无用了，一般我们会保留3~7天的binlog，通过mysql自带参数保留。  
  

```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show variables like 'expire_logs_days';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| expire_logs_days | 0     |
+------------------+-------+
1 row in set (0.00 sec)

mysql> set global expire_logs_days=7;
Query OK, 0 rows affected (0.00 sec)

# 或者写入配置文件也可以 my.cnf
```

### 删除binlog
超哥强烈不推荐直接删除binlog数据文件，而应该根据生产的需求，用命令删除binlog

删除binlog命令，删除到某一个文件停止  

```plain
mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |       167 |
| mysql-bin.000002 |       167 |
| mysql-bin.000003 |      7818 |
| mysql-bin.000004 |       143 |
| mysql-bin.000005 |       143 |
| mysql-bin.000006 |      1069 |
| mysql-bin.000007 |       143 |
| mysql-bin.000008 |       355 |
| mysql-bin.000009 |       389 |
+------------------+-----------+
9 rows in set (0.00 sec)

mysql>
mysql>
mysql> purge binary logs to 'mysql-bin.000003';
Query OK, 0 rows affected (0.01 sec)

mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000003 |      7818 |
| mysql-bin.000004 |       143 |
| mysql-bin.000005 |       143 |
| mysql-bin.000006 |      1069 |
| mysql-bin.000007 |       143 |
| mysql-bin.000008 |       355 |
| mysql-bin.000009 |       389 |
+------------------+-----------+
7 rows in set (0.00 sec)
```

根据时间戳删除binlog，例如删除某 年月日 时分秒的 binlog

```plain
# 当前的时间戳
[root@mysql-server56 ~]# ls -l --time-style=long-iso  /data/3307/mysql-bin.*
-rw-rw---- 1 root  root   775 2021-04-20 22:30 /data/3307/mysql-bin.000002.sql
-rw-rw---- 1 mysql mysql 7818 2021-04-21 15:14 /data/3307/mysql-bin.000003
-rw-rw---- 1 mysql mysql  143 2021-04-21 15:16 /data/3307/mysql-bin.000004
-rw-rw---- 1 mysql mysql  143 2021-04-21 19:22 /data/3307/mysql-bin.000005
-rw-rw---- 1 mysql mysql 1069 2021-04-21 22:08 /data/3307/mysql-bin.000006
-rw-rw---- 1 mysql mysql  143 2021-04-22 10:31 /data/3307/mysql-bin.000007
-rw-rw---- 1 mysql mysql  355 2021-04-22 11:03 /data/3307/mysql-bin.000008
-rw-rw---- 1 mysql mysql  389 2021-04-22 11:26 /data/3307/mysql-bin.000009
-rw-rw---- 1 mysql mysql  196 2021-04-22 11:41 /data/3307/mysql-bin.index
```

  
删除2021-04-21 23:00之前的binlog

```plain
mysql> purge master logs before '2021-04-21 23:00';
Query OK, 0 rows affected (0.01 sec)

[root@mysql-server56 ~]# ls -l --time-style=long-iso  /data/3307/mysql-bin.*
# 这个sql文件和binlog无关，是根据mysql-bin.index来查找的
-rw-rw---- 1 root  root  775 2021-04-20 22:30 /data/3307/mysql-bin.000002.sql
-rw-rw---- 1 mysql mysql 143 2021-04-22 10:31 /data/3307/mysql-bin.000007
-rw-rw---- 1 mysql mysql 355 2021-04-22 11:03 /data/3307/mysql-bin.000008
-rw-rw---- 1 mysql mysql 389 2021-04-22 11:26 /data/3307/mysql-bin.000009
-rw-rw---- 1 mysql mysql  84 2021-04-22 11:50 /data/3307/mysql-bin.index
```

清除所有的binlog，重新记录

```plain
mysql> reset master;
Query OK, 0 rows affected (0.02 sec)

# 重新从01记录
[root@mysql-server56 ~]# cat /data/3307/mysql-bin.index
/data/3307/mysql-bin.000001
```

## 慢查询日志
慢查询日志（slow query log）用于记录执行时间拆过指定值（long_query_time）或者没有使用索引、结果集大于1000行的SQL语句。

### 慢日志参数

<!-- OCR_START -->
慢查询的参数
解释说明
slow_query_log
慢查询开启开关，默认值是OFF*
slow-query-log-file
记录慢查询语句的文件，文件名形如“主机名-slow.log”*
记录大于指定N秒的SQL语句，默认是10秒，也可以使用
long_query_time
微秒单位*
log_queries_not_using_indexes
记录没有使用到索引的SQL语句，默认值是OFF*
min_examined_row_limit
记录结果集大于N行的SQL语句，默认是O行*
记录管理的慢SQL语句，例如ALTERTABLE、ANALYZE
log_slow_admin_statements
TABLE、CHECKTABLE、CREATEINDEX、DROPINDEX、
OPTIMIZETABLE、REPAIRTABLE
限制每分钟写人记录的慢SQL语句的数量，默认值为O，表
log_throttle_queries_not_using_indexes
示没限制
<!-- OCR_END -->

慢查询参数调整，是数据库SQL优化重要手段

修改my.cnf  

```plain
[mysqld]
user=mysql
port=3307
socket=/data/3307/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3307/data
log-bin=/data/3307/mysql-bin
server-id=6
secure_file_priv=''
#general_log=on
#general_log_file=/data/3307/data/mysql-server56.log
# slow-log
slow-query-log = ON                        #<==慢查询开启开关
long_query_time = 2                        #<==记录大于2秒的SQL语句。
log_queries_not_using_indexes = ON         #<==没有使用到索引的SQL语句。
slow-query-log-file = /data/3307/slow.log  #<==记录SQL语句的文件。
min_examined_row_limit = 800               #<==记录结果集大于800行的SQL语句。

# 重启
[root@mysql-server56 ~]# /data/3307/mysql_3307 restart
Restarting MySQL...
Stoping MySQL...
Starting MySQL...
```

### 检查参数
```plain
[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like '%slow_query%'"
Warning: Using a password on the command line interface can be insecure.
+---------------------+---------------------+
| Variable_name       | Value               |
+---------------------+---------------------+
| slow_query_log      | ON                  | # 开关
| slow_query_log_file | /data/3307/slow.log | # 慢日志位置
+---------------------+---------------------+

[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like '%long_query%'"
Warning: Using a password on the command line interface can be insecure.
+-----------------+----------+
| Variable_name   | Value    |
+-----------------+----------+
| long_query_time | 2.000000 |    # 超过2秒的查询
+-----------------+----------+

[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like '%log_queries_not%'"
Warning: Using a password on the command line interface can be insecure.
+-------------------------------+-------+
| Variable_name                 | Value |
+-------------------------------+-------+
| log_queries_not_using_indexes | ON    |    # 记录没有使用索引的查询
+-------------------------------+-------+

[root@mysql-server56 ~]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like '%min_examined_row_limit%'"
Warning: Using a password on the command line interface can be insecure.
+------------------------+-------+
| Variable_name          | Value |
+------------------------+-------+
| min_examined_row_limit | 800   |    # 查询结果集大于800行的SQL
+------------------------+-------+
```

  

### 慢日志切割脚本
慢日志此时已经能够被记录，且写入文件，问题是，如果该日志文件产生的信息过多，毕然要针对该日志文件，进行切割处理。

```plain
[root@mysql-server56 mysql_script]# cat cut_slow_log.sh
#!/bin/bash
cd /data/3307/ && mv slow.log slow.log.$(date +%F) && mysqladmin  -uroot -pyuchao7777 -P3307 -h127.0.0.1 flush-log
[root@mysql-server56 mysql_script]#
```

脚本执行结果

```plain
[root@mysql-server56 mysql_script]# bash cut_slow_log.sh
Warning: Using a password on the command line interface can be insecure.

[root@mysql-server56 mysql_script]# ls /data/3307/slow.log*
/data/3307/slow.log  /data/3307/slow.log.2021-04-22
```

  

# MySQL字符集设置
字符集的概念

首先计算机只能识别出0和1这样的二进制数字，计算机会将所有的数据最终转换为二进制的0和1数据进行处理。

例如我们输入的数字8，计算机只能将8转换为二进制数字 1000，才能处理。

<!-- OCR_START -->
- ASCII表
- ASCII码控制字符
- ASCII码打印字符
- 高四位
- 0001
- 0010
- 0011
- 01/0
- 0101
- 0110
- 0111
- 2
- 低四位
- 十进
- 转义
- 字符
- Ctrl
- 代码
- 字符解释
- ~@
- NUL
- 10
- 空字符
- 16
- ^P
- DLE
- 数据链路转义
- 32
- 48
- 64
- 80
- 96
- 112
- ~A
- SOH
- 标题开始
- 17
- DCI
- 设备控制1
- 1
- 33
- 49
- 65
- 81
- 97
- 113
- 9
- ^B
- STX
- 正文开始
- 18
- DC2
- 设备控制2
- 34
- 1D
- 50
- 66
- 82
- 98
- 114
- 001
- ^C
- ETX
- 正文结束
- 19
- !!
- ^S
- DC3
- 设备控制3
- 35
- 51
- 67
- 83
- 99
- 115
- 0100
- ^D
- EOT
- 传输结束
- 20
- ^T
- DC4
- 设备控制4
- 36
- 52
- 68
- 84
- 4
- 100
- 116
- ENQ
- 查询
- 21
- NAK
- 否定应答
- 37
- 53
- 69
- 85
- 101
- 117
- 110
- ACK
- 肯定应答
- 22
- AV
- SYN
- 同步空闲
- 38
- 54
- 70
- 86
- 102
- 118
- BEL
- 响铃
- 23
- AW
- ETB
- 传输块结束
- 39
- 55
- 71
- 87
- 103
- 119
- 1000
- ^H
- BS
- 退格
- 24
- AX
- CAN
- 取消
- 40
- 56
- 8
- 72
- 88
- 104
- 120
- 1001
- HT
- 横向指标
- 25
- AY
- EM
- 介质结束
- 41
- 57
- 73
- 89
- 105
- 121
- 1010
- AJ
- LF
- 换行
- 26
- AZ
- SUB
- 替代
- 42
- 58
- 74
- 90
- 106
- 122
- 11
- ^K
- VT
- 纵向制表
- 27
- ESC
- 溢出
- 43
- 59
- 75
- 91
- 107
- 123
- 1100
- 12
- FF
- 换页
- 28
- FS
- 文件分隔符
- 44
- 60
- 76
- 92
- 108
- 124
- 13
- ^M
- CR
- 回车
- 29
- GS
- 组分隔符
- 45
- 61
- 77
- 93
- 109
- 125
- AN
- 移出
- 30
- AA
- RS
- 记录分隔符
- 46
- 62
- 94
- 126
- SI
- 移入
- 31
- US
- 单元分隔符
- ^Backspac
- ^0
- 95
- 代码：DEL
- 表中的ASCII字符可以用AIt+小键盘上的数字键“方法输入
<!-- OCR_END -->

```plain
# 十进制转二进制
# obase进制;十进制值 

[root@mysql-server56 mysql_script]# echo "obase=2;255"|bc
11111111

[root@mysql-server56 mysql_script]# echo "obase=2;15"|bc
1111
```

但是计算机不但要处理数字、还有字母，字母有26个，算大小写52个，加上英文标点符号，特殊符号，也就是图片上面的显示，变化也不多。

如果我们用8位二进制数字11111111，就可以表示256种字符，也就是说8位二进制数字，可以胜任英文字符的工作。

问题是，每个国家，都有自己的文字、不仅有数字、字母、特殊字符

中国的汉字更是有上万个

因此上面超哥给出的ascii编码表就无法满足需求了

因此就出现了各种字符编码GBK、GB2312、UTF-8等等，采用16位二进制数字就可以表示65535个汉字，这就足够了。

```plain
[root@mysql-server56 mysql_script]# echo "obase=2;65535"|bc
1111111111111111
[root@mysql-server56 mysql_script]# expr  length `echo "obase=2;65535"|bc`
16
```

中文编码一般使用GBK

UTF-8编码 可以表达各种文字的编码，也是工作里用的最多的了

## 总结
字符编码就是将人类使用的汉字、以及其他语言、字母、特殊符号，通过预定的转换规则，且转换为计算机认识的二进制数字，这么一种编码表。

<!-- OCR_START -->
- 常用字符集
- 最大长度
- GB2312
- 2字节
- 早期制定的标准，不推荐使用
- GB18030
- 4字节
- 受一些系统支持，数据库支持的不多，不推荐使用
- GBK
- 不是国际标准，对中文环境支持的很好，不推荐使用
- 中英文混合的环境，建议使用此字符集，目前使用的比较多，互联网场景的
- UTF8
- 3字节
- Linux/UNIX及MySQL都支持UTF8，重点推荐。
- latinl
- 1字节
- MySQL系统的默认字符集，不推荐使用
- utf8mb4字符集主要从5.5开始被支持，兼容UTF8，且比UTF8能表示更多
- utf8mb4
- 的字符，正在成为未来趋势字符集，重点推荐
<!-- OCR_END -->

## 如何选择mysql的字符集
+ 存储的数据若是各式各样的语言，选择UTF8，是国内用的最广泛的字符集
+ 如果只支持中文，且数据很大，可以使用GBK，但是一般没必要选这个
+ 如今的互联网时代、网站、移动端，都推荐使用utf8mb4替代utf8

## 查看编码
查看mysql会吃的编码

```plain
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show character set;"

```

校对规则(collation)：

是在字符集内用于字符比较和排序的一套规则，比如有的规则区分大小写，有的则无视。

查看utf8的校对规则

```plain
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show collation like 'utf8%'"

```

## mysql配置字符集
数据库的读写，经常性会遇见问题，乱码，超哥就来带着大家解决

保证字符编码统一，或者说不出现乱码，需要考虑如下因素

+ 操作系统，centos本身字符集
+ 客户端，如ssh客户端字符集
+ mysql数据库实例编码
+ 具体某一个库字符集，如kings的字符集
+ 某一个table，数据表的字符集，如tanks
+ mysql客户端的字符集，如navicat等客户端工具
+ 代码级别，如php、python、golang

这几点确定没问题了，乱码就得以解决

### Linux系统字符集
i18n是internationalization的缩写，意思指i和n之间有18个字母。/etc/sysconfig/i18n里面存放着系统的区域语言设置，可以使linux系统支持国际化信息显示。就是支持多种字符集的转换，避免出现乱码。同一时间i18n只能是英文和一种选定的语言，例如英文+中文、英文+德文、英文+韩文等等。

使用locale查看系统当前locale环境变量

```plain
local          locale         localectl      localedef      local-getcert
[root@mysql-server56 mysql_script]# locale
LANG=en_US.UTF-8
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=
```

修改字符集

```plain
[root@mysql-server56 mysql_script]# cat /etc/sysconfig/i18n
LANG="zh_CN.UTF-8"
SYSFONT="latarcyrheb-sun16"

# 生效
[root@mysql-server56 mysql_script]# source /etc/sysconfig/i18n
[root@mysql-server56 mysql_script]#
[root@mysql-server56 mysql_script]#
[root@mysql-server56 mysql_script]# echo $LANG
zh_CN.UTF-8

[root@mysql-server56 mysql_script]# locale
LANG=zh_CN.UTF-8
LC_CTYPE="zh_CN.UTF-8"
LC_NUMERIC="zh_CN.UTF-8"
LC_TIME="zh_CN.UTF-8"
LC_COLLATE="zh_CN.UTF-8"
LC_MONETARY="zh_CN.UTF-8"
LC_MESSAGES="zh_CN.UTF-8"
LC_PAPER="zh_CN.UTF-8"
LC_NAME="zh_CN.UTF-8"
LC_ADDRESS="zh_CN.UTF-8"
LC_TELEPHONE="zh_CN.UTF-8"
LC_MEASUREMENT="zh_CN.UTF-8"
LC_IDENTIFICATION="zh_CN.UTF-8"
LC_ALL=
```

  

### Linux客户端字符集
例如大家用的如果是windows客户端xshell，就需要修改xhell的设置，字符编码使用utf-8

### mysql实例编码
可以通过修改my.cnf设置数据库实例编码，服务端

```plain
[mysqld]
user=mysql
port=3307
socket=/data/3307/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3307/data
log-bin=/data/3307/mysql-bin
server-id=6
secure_file_priv=''
#general_log=on
#general_log_file=/data/3307/data/mysql-server56.log
# slow-log
slow-query-log = ON                        #<==慢查询开启开关
long_query_time = 2                        #<==记录大于2秒的SQL语句。
log_queries_not_using_indexes = ON         #<==没有使用到索引的SQL语句。
slow-query-log-file = /data/3307/slow.log  #<==记录SQL语句的文件。
min_examined_row_limit = 800               #<==记录结果集大于800行的SQL语句。
# 编码
character-set-server=utf8
```

### 修改服务端字符集
```plain
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like 'character_set%'"
Warning: Using a password on the command line interface can be insecure.
+--------------------------+------------------------------------------------------------------+
| Variable_name            | Value                                                            |
+--------------------------+------------------------------------------------------------------+
| character_set_client     | utf8                                                             |
| character_set_connection | utf8                                                             |
| character_set_database   | latin1                                                           |
| character_set_filesystem | binary                                                           |
| character_set_results    | utf8                                                             |
| character_set_server     | latin1                                                           |
| character_set_system     | utf8                                                             |
| character_sets_dir       | /application/mysql-5.6.40-linux-glibc2.12-x86_64/share/charsets/ |
+--------------------------+------------------------------------------------------------------+
[root@mysql-server56 mysql_script]#
[root@mysql-server56 mysql_script]#
[root@mysql-server56 mysql_script]# /data/3307/mysql_3307 restart
Restarting MySQL...
Stoping MySQL...
Starting MySQL...
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like 'character_set%'"
Warning: Using a password on the command line interface can be insecure.
+--------------------------+------------------------------------------------------------------+
| Variable_name            | Value                                                            |
+--------------------------+------------------------------------------------------------------+
| character_set_client     | utf8                                                             |
| character_set_connection | utf8                                                             |
| character_set_database   | utf8                                                             |
| character_set_filesystem | binary                                                           |
| character_set_results    | utf8                                                             |
| character_set_server     | utf8                                                             |
| character_set_system     | utf8                                                             |
| character_sets_dir       | /application/mysql-5.6.40-linux-glibc2.12-x86_64/share/charsets/ |
+--------------------------+------------------------------------------------------------------+
[root@mysql-server56 mysql_script]#
```

## database的字符集设置
查看创建数据库的字符集

```plain
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like 'character_set_database%'"
Warning: Using a password on the command line interface can be insecure.
+------------------------+-------+
| Variable_name          | Value |
+------------------------+-------+
| character_set_database | utf8  |
+------------------------+-------+
```

后续创建数据库，字符集默认是utf8了

```plain
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "create database lol;"
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show create database lol"
Warning: Using a password on the command line interface can be insecure.
+----------+--------------------------------------------------------------+
| Database | Create Database                                              |
+----------+--------------------------------------------------------------+
| lol      | CREATE DATABASE `lol` /*!40100 DEFAULT CHARACTER SET utf8 */ |
+----------+--------------------------------------------------------------+
```

## 数据表table的字符集
```plain
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "use lol;create table heros(id int,name varchar(50))"
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 mysql_script]#
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show create table lol.heros"
Warning: Using a password on the command line interface can be insecure.
+-------+----------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                               |
+-------+----------------------------------------------------------------------------------------------------------------------------+
| heros | CREATE TABLE `heros` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+-------+----------------------------------------------------------------------------------------------------------------------------+
[root@mysql-server56 mysql_script]#
```

  

## mysql客户端编码
修改my.cnf  

```plain
[client]
default-character-set=utf8
```

## 检查mysql字符集
```plain
[root@mysql-server56 mysql_script]# mysql -uroot -pyuchao7777 -P3307 -h127.0.0.1 -e "show variables like 'character_set%'"
Warning: Using a password on the command line interface can be insecure.
+--------------------------+------------------------------------------------------------------+
| Variable_name            | Value                                                            |
+--------------------------+------------------------------------------------------------------+
| character_set_client     | utf8           # 客户端字符集                                                      |
| character_set_connection | utf8          # mysql连接的字符集                                                   |
| character_set_database   | utf8         #服务端字符集                                                    |
| character_set_filesystem | binary            # 文件系统字符集                                                |
| character_set_results    | utf8             # mysql返回数据字符集                                          |
| character_set_server     | utf8             # 服务器字符集                                                |
| character_set_system     | utf8              # 系统字符集                                              |
| character_sets_dir       | /application/mysql-5.6.40-linux-glibc2.12-x86_64/share/charsets/ |
+--------------------------+------------------------------------------------------------------+
[root@mysql-server56 mysql_script]#
```

  

### 更改现有数据库字符集
当我们已有的数据库，字符集不统一，导致的乱码，可以修改数据库字符集

```plain
# 创建一个非utf8字符集的数据库
mysql> create database lol_game default character set utf8;
Query OK, 1 row affected (0.00 sec)

# 查看
mysql> show create database lol_game;
+----------+-------------------------------------------------------------------+
| Database | Create Database                                                   |
+----------+-------------------------------------------------------------------+
| lol_game | CREATE DATABASE `lol_game` /*!40100 DEFAULT CHARACTER SET utf8 */ |
+----------+-------------------------------------------------------------------+
1 row in set (0.00 sec)

# 修改字符集
mysql> alter database lol_game character set latin1 collate=latin1_swedish_ci;
Query OK, 1 row affected (0.00 sec)

# 查看字符集
mysql> show create database lol_game;
+----------+---------------------------------------------------------------------+
| Database | Create Database                                                     |
+----------+---------------------------------------------------------------------+
| lol_game | CREATE DATABASE `lol_game` /*!40100 DEFAULT CHARACTER SET latin1 */ |
+----------+---------------------------------------------------------------------+
1 row in set (0.00 sec)
```

### 修改表字符集
注意上面lol_game数据库字符集被改为了latin1

```plain
mysql> use lol_game;
Database changed
mysql> create table heros(id int,name varchar(50));
Query OK, 0 rows affected (0.01 sec)

# 创建表
mysql> show create table heros;
+-------+------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                 |
+-------+------------------------------------------------------------------------------------------------------------------------------+
| heros | CREATE TABLE `heros` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 |
+-------+------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

# 插入数据，查看结果
mysql> insert into heros(id,name) values(1,'亚索'),(2,'寒冰射手');
Query OK, 2 rows affected, 2 warnings (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 2

mysql> select * from heros;
+------+------+
| id   | name |
+------+------+
|    1 | ??   |
|    2 | ???? |
+------+------+
2 rows in set (0.00 sec)
```

### 乱码解决
这里超哥写入的亚索，寒冰，是乱码，怎么办？统一字符集！

修改这个表为utf8

以及修改lol_game数据库的编码

```plain
mysql> alter table heros character set utf8;
Query OK, 0 rows affected (0.00 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> select * from heros;
+------+------+
| id   | name |
+------+------+
|    1 | ??   |
|    2 | ???? |
+------+------+
2 rows in set (0.00 sec)

mysql> alter database lol_game character set utf8;
Query OK, 1 row affected (0.00 sec)

mysql> select * from heros;
+------+------+
| id   | name |
+------+------+
|    1 | ??   |
|    2 | ???? |
+------+------+
2 rows in set (0.00 sec)
```

注意，这个表heros的创建信息如下

```plain
mysql> show create table lol_game.heros;
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                    |
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| heros | CREATE TABLE `heros` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(50) CHARACTER SET latin1 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

name这个字段默认字符集还是latin1，还得修改为utf8

```plain
mysql> alter table lol_game.heros change name name varchar(50) character set utf8;
Query OK, 4 rows affected (0.02 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> show create table lol_game.heros;
+-------+----------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                               |
+-------+----------------------------------------------------------------------------------------------------------------------------+
| heros | CREATE TABLE `heros` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+-------+----------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

此时再插入heros表，新的数据，就可以正常显示了。

  
 

## 生产环境改字符集
若是生产环境下已有了数据，需要对字符集调整，步骤

+ 先备份导出数据，导出所有SQL
+ 修改数据库字符集环境，如修改数据库、表，GBK改为UTF8
+ 可能需要修改my.cnf，重启数据库
+ 重新导入数据

  

# MySQL数据库引擎
什么是引擎，说过了，就好比是一个摩托车的发动机，发动机会有各种各样的品牌。

<!-- OCR_START -->
- jpg
- png
- bmp
<!-- OCR_END -->

电脑里的图片，会有各种形式，jpg,png,bmp,gif，但是都通过看图软件，打开，查看图片内容。

并且这些图片数据存储在磁盘上，也会存在于不同的文件系统中，例如ext3,ext4,xfs等

但是对于用来说，最后看到的图片内容，都是一样的，区别就是在于

+ 图片文件大小
+ 清晰程度不同

## mysql5.6引擎
数据库的数据，存储在mysql软件中，以及磁盘上，就和这个图片存储，理念是一样的

mysql数据存储也有多种格式

但是最终对于用户来说，看到都只是一个数据表，看到的数据都是一样的

对于不同的数据库引擎

+ 引擎特有的功能
+ 占用磁盘容量大小
+ 性能

这些有一定的区别

数据库引擎，作用是mysql数据库用来处理不同数据表的一个组件。

mysql5.6默认的引擎是InnoDB这一款。  

```plain
mysql> select version();
+------------+
| version()  |
+------------+
| 5.6.40-log |
+------------+
1 row in set (0.00 sec)

mysql> show variables like '%storage_engine%';
+----------------------------+--------+
| Variable_name              | Value  |
+----------------------------+--------+
| default_storage_engine     | InnoDB |
| default_tmp_storage_engine | InnoDB |
| storage_engine             | InnoDB |
+----------------------------+--------+
3 rows in set (0.00 sec)
```

## 存储引擎架构
### 存储引擎
mysql中建立的库===>文件夹

库中建立的表===>文件

现实生活中我们用来存储数据的文件有不同的类型，每种文件类型对应各自不同的处理机制。

比如处理文本用txt类型，处理表格用excel，处理图片用png等，看小电影用avi格式~~~

数据库中的表也应该有不同的类型，表的类型不同，会对应mysql不同的存取机制，表类型又称为存储引擎。

存储引擎说白了就是如何存储数据、如何为存储的数据建立索引和如何更新、查询数据等技术的实现方 法。【就好比一张图片可以存储png格式，jpeg格式，png图像比jpeg图片质量更高】

因为在关系数据库中数据的存储是以表的形式存储的，所以存储引擎也可以称为表类型（即存储和 操作此表的类型）

<!-- OCR_START -->
- 接口，我们直接使用select接口，然后提交查询
- 不同程序写的客户端
- 整个过程从上
- 命令给服务端，服务端收到这个指令，解析成
- 往下看
- 对应的底层操作，这种复杂的底层操作不需要
- 由于你做的操作是和磁盘打交道
- 的，从磁盘打开文件，读到内
- 你自己做
- 存，返回给你，这都是I0操作，
- 解析你的指令，进行操作
- 支持接口
- 提高效率就需要解决10问题
- 标准C的API,JD
- 0DBC, NET, PHP, Pyt
- MySQL就帮你做了，比如我们后面
- 会讲的索引机制，减少10操作，
- MySQLServer
- 10000行数据如何1次就能找到对
- 企业管理服务和工
- 连接池
- 备份与恢复
- 验证与授权一线程一连接限制一内存与圾存管理
- 应的数据，而不要遍历着10000条
- 安全
- 复制
- 数据。
- 群集
- SOL接口
- 解析器
- 优化
- 缓存和级件
- 分区管理
- 数据管理语言和数据
- 查询\事务
- 访问路径
- 全局和具体引攀的
- 事例管理
- 定义语言、存储过程、
- 对象优先级
- 统计
- 缓存和缓冲池
- 数据模板管理
- 视围、触发器、
- 等等
- 工作台
- 查询测览
- 支持并发
- 合并工具包
- 可插式存健引擎
- 内存\索引和存储管理
- 缓存机制，从内存中取比硬
- Cluster
- Falcon
- Archive
- Federated
- Merge
- Miemn
- 盘中取快多了，也属于优化
- 7件系统
- 文件和日志
- 机制
- 术文件系统：网络文件系统
- Redo,Undo,Deta,ndex,Binary
- 存储区
- 网络和网络附加存储
- Error,Query，andSlow
- 不同的存储引擎来存取数据，
- MySQL套接字服务端
- 最后就是我们的磁盘文件系统了
- 按照不同的方式，支持的引
- 如果你调用的是InnoDB引擎的话，那么每次存取数据都是使用的InnoDB的
- 擎很多，还可以自定义，也
- 处理机制来处理的
- 就是自己写一个
<!-- OCR_END -->

从图中可知

+ 连接池
+ 数据库管理部分
+ SQL接口，查询分析器、优化器、缓冲
+ 存储引擎
+ 数据库文件、日志、数据文件
+ 文件系统、磁盘

## mysql管理引擎
```plain
# 查看所有的引擎
mysql> show engines;
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
| FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
9 rows in set (0.00 sec)
```

<!-- OCR_START -->
- mysql> show engines;
- 是否支持
- 是否支持事务
- IEngine
- 引擎类型I
- Support
- Comment
- 引擎特点
- Transactions
- |XA
- Savepoints |
- InnoDB
- DEFAULT
- Supports transactions，row-level locking，and foreign keys
- YES
- CSV
- CSV storage engine
- I NO
- MRG_MYISAM
- Collectionof identical MyISAM tables
- NO
- BLACKHOLE
- /dev/null storage engine (anything you write to it disappears)
- 1MyISAM
- MyISAM storage engine
- MEMORY
- Hash based，stored in memory，useful for temporary tables
- ARCHIVE
- Archive storage engine
- FEDERATED
- 一NO
- |Federated MysQLstorageengine
- NULL
- 1NULL I NULL
- PERFORMANCE_SCHEMA|
- 9 rows in set (o.00 sec)
<!-- OCR_END -->

<!-- OCR_START -->
存储引擎
说明（带*的为重点）
InnoDB是MySQL5.6默认的存储引擎，InnoDB支持事务，具有提交、回滚的功能，
并且可以通过崩溃恢复能力来保护用户的数据，读写数据是行级锁定，可提升多用户
InnoDB
并发访问的能力，InnoDB以集群的索引方式存储用户数据，基于主键方式查询可提高
I/O性能，InnoDB也支持外键，使得数据更完整、更安全，更多的说明请参考InnoDB
引擎章节的说明*
MyISAM是MySQL5.5.5以前默认的存储引擎，曾经用的很多，现在用的少了，
MyISAM
MyISAM仅支持表级锁，读写性能都很有限。可用于只读或者绝大多数以读为主的业
务场景
Memory以内存的方式存储所有数据，访问速度很快，不过其使用场景也是越来越少
Memory
了。InnoDB的Bufferpool内存也可以缓存绝大多数的数据了
CSV这个引擎所对应的数据表格实际上是带有逗号分隔值的文本文件。CSV表格允
许您以CSV格式导入或者转储数据，以便于读取和写入相同格式的脚本，与应用程序
CSV
进行数据交换。由于CSV表是没有索引的，因此通常应在正常操作期间将数据保存在
InnoDB表中，并且只能在导入或导出阶段使用CSV表
Archive
这些紧凑、无索引的引擎表旨在存储和检索大量参考的历史、归档或安全审核信息
Blackhole存储引擎接受但不存储数据，类似于Unix／dev/null设备。查询总是会返
Blackhole
回一个空集。这些表可用于将DML语句发送到从属服务器的复制配置，但是主服务器
不保留其自己的数据副本
使MySQLDBA或开发人员能够对一系列相同的MyISAM表进行逻辑分组，并将其
Merge
作为一个对象引I用。Merge适用于数据仓库等VLDB环境
Federated可通过链接单独的MySQL服务器以从许多物理服务器创建一个逻辑数据
Federated
库。其非常适合于分布式或数据集环境。
该引擎作为MySQL源代码中的一个例子，说明了如何开始编写新的存储引擎。这主
Example
要是开发商感兴趣的。存储引擎是一个什么都不做的“stub”。您可以使用此引擎创建
表，但不能存储数据或从中检索数据。
<!-- OCR_END -->

我们只需要关注，InnoDB、MyISAM、Memory三个引擎即可

引擎之间的特性比较

<!-- OCR_START -->
- 特性
- MyISAM
- Memory
- InnoDB
- Archive
- NDB
- 存储限制
- 256TB
- RAM
- 64TB
- None
- 384EB
- 事务
- No
- Yes
- 锁粒度
- Table
- Row
- B-tree索引
- T-tree索引
- Hash索引
- Full-text search索引
- Clustered索引
- 数据缓存
- N/A
- 索引缓存
- 压缩数据
- 加密数据
- 集群数据库支持
- 主从复制支持
- 外键支持
<!-- OCR_END -->

## 设置与修改MySQL引擎
可以在创建表的时候，指定引擎

若是不指定引擎，默认表的引擎用数据库默认配置

```plain
use kings;

CREATE TABLE `student` (
  `Sno` int(10) NOT NULL COMMENT '学号',
  `Sname` varchar(16) NOT NULL COMMENT '姓名',
  `Ssex` char(2) NOT NULL COMMENT '性别',
  `Sage` varchar(16) default NULL,
  `Sdept` varchar(16) default NULL COMMENT '学生所在系别',
  KEY `ind_sage` (`Sage`),
  KEY `ind_sno` (`Sno`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 #<==最后一行括号外，指定引擎。
```

### 修改表的引擎
一般很少会修改引擎

```plain
mysql> alter table student engine=INNODB;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> show create table student\G
*************************** 1. row ***************************
       Table: student
Create Table: CREATE TABLE `student` (
  `Sno` int(10) NOT NULL COMMENT '学号',
  `Sname` varchar(16) NOT NULL COMMENT '姓名',
  `Ssex` char(2) NOT NULL COMMENT '性别',
  `Sage` varchar(16) DEFAULT NULL,
  `Sdept` varchar(16) DEFAULT NULL COMMENT '学生所在系别',
  KEY `ind_sage` (`Sage`),
  KEY `ind_sno` (`Sno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)
```

### 批量修改SQL引擎
若是对数据导出为SQL文件后，批量的数据库，表，创建语句，引擎都需要改的话，可以sed批量修改。

```plain
nohup sed -e 's/MyISAM/InnoDB/g' kings.sql > kings_InnoDB.sql &

```

## MyISAM引擎
MyISAM引擎是MySQL关系型数据库管理系统的默认存储引擎（MySQL 5.5.5以前）。这种MySQL表存储结构可从旧的ISAM代码中扩展出许多有用的功能。

在新版本的MySQL中，InnoDB引擎由于支持事务、外键等，有利于数据的一致性，以及其能支持更高的多用户并发性等优点，InnoDB已经取代了曾经常用的MyISAM引擎，不过由于数据库中的MySQL库的大部分表主要用于读取，因此，MyISAM引擎依然在使用。

每一个MyISAM引擎的表都对应于硬盘上的三个文件。这三个文件虽然具有一样的文件名，但是其不同的扩展名指示了其不同的类型用途：

“.frm”文件用于保存表的定义，该文件并不是MyISAM引擎的一部分，而是服务器的一部分；

“.MYD”用于保存表的数据；

“.MYI”则是表的索引文件。

“.MYD”和.MYI是MyISAM的关键点。

示例代码如下：

```plain
[root@mysql-server56 ~]# ls -l /data/3307/data/kings/
total 360
-rw-r----- 1 mysql mysql     61 Apr 21 22:12 db.opt
-rw-r----- 1 mysql mysql   8586 Apr 21 22:12 Heros.frm    # 独立表空间
-rw-r----- 1 mysql mysql  98304 Apr 21 22:12 Heros.ibd    # InnoDB
-rw-rw---- 1 mysql mysql   8718 Apr 22 18:25 student.frm
-rw-rw---- 1 mysql mysql 131072 Apr 22 18:25 student.ibd
-rw-r----- 1 mysql mysql   8822 Apr 21 22:12 tanks.frm
-rw-r----- 1 mysql mysql  98304 Apr 22 10:37 tanks.ibd
```

### MyISAM引擎特点

<!-- OCR_START -->
- 特性
- 支持情况
- 说明
- 存储限制
- 256TB
- 事务支持
- No
- 即数据更新时锁定整个表：其锁定机制是表级锁定，这虽然可以让锁定
- 锁表粒度
- Table
- 的实现成本很小，但是同时也大大降低了其并发性能
- 全文索引
- Yes
- 数据缓存
- 不会缓存数据
- MyISAM可以通过key_buffer_size缓存索引l，以大大提高访问性能，减
- 索引缓存
- 少磁盘IO，但是这个缓存区只会缓存索引，而不会缓存数据
- 外键支持
- 不支持外键
- 因为功能不多，且管理粒度较粗，因此，MyISAM消耗系统资源比
- 资源占用
- InnoDB少很多
- 不仅会在写人的时候阻塞读取，MyISAM还会在读取的时候阻塞写入，
- 读写是否阻塞
- 但读本身并不会阻塞另外的读
- MyISAM是MySQL5.5.5之前默认的存储引擎，因为性能问题，在
- 是否默认
- MySOL后期版本中被取代
<!-- OCR_END -->

这一块原理性的东西，只有数据库用的很高级，以及面试时候可能会问，了解即可。初学时不用太多关注

## MyISAM使用场景
+ 不需要事务、对数据一致性要求不高（只要和钱打交道，就没法用MyISAM）
+ 适合读的多、写的少的场景
+ 数据修改较少的场景，（也是写的少）
+ 服务器硬件性能较低的场景
+ 这样就适合，读写分离的mySQL，从库使用MyISAM引擎进行读取操作。

## InnoDB引擎
InnoDB引擎是当下MySQL数据库最重要的存储引擎，其正在成为目前MySQL AB所发行新版的标准，被包含在所有的安装包里。

与其他的存储引擎相比，InnoDB引擎的优点是更新数据行级锁定、支持ACID的事务、支持外键，它的设计目标是面向在线事务处理的应用，目前绝大多数互联网公司都在使用InnoDB引擎，该引擎替代了其他的引擎。

MySQL 5.6版本的默认引擎已变为InnoDB引擎。

### InnoDB特点
InnoDB存储引擎将数据存放在一个像黑盒一样的逻辑表空间中，这个表空间分为共享表空间和独立表空间，从MySQL 5.6开始，即默认支持将InnoDB引擎的表数据单独存放到各自独立的ibd文件中（独立表空间）。

创建innodb表，查看数据

```plain
mysql> use kings;

mysql> create table fuzhu(id int);
Query OK, 0 rows affected (0.01 sec)

mysql> show create table fuzhu;
+-------+-----------------------------------------------------------------------------------------+
| Table | Create Table                                                                            |
+-------+-----------------------------------------------------------------------------------------+
| fuzhu | CREATE TABLE `fuzhu` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+-------+-----------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

# 查看磁盘数据
-rw-r----- 1 mysql mysql  98304 Apr 22 10:37 tanks.ibd
[root@mysql-server56 ~]# ls -l /data/3307/data/kings/fuzhu*
-rw-rw---- 1 mysql mysql  8556 Apr 23 10:30 /data/3307/data/kings/fuzhu.frm
-rw-rw---- 1 mysql mysql 98304 Apr 23 10:30 /data/3307/data/kings/fuzhu.ibd

# 用于调节innodb引擎的参数
mysql> show variables like 'innodb%';
```

<!-- OCR_START -->
- 特性
- 支持情况
- 存储限制
- 64TB
- 存储限制有些小，但是也足够了
- 事务
- Yes
- 支持4个事务隔离级别，支持多版本读
- 锁粒度
- Row
- 更新数据仅锁定行
- B-tree索引
- T-tree 索引
- No
- Hash索引
- Full-text search 索引引
- 从5.5开始支持全文索引
- Clustered 索引
- 数据和主键以Cluster方式进行存储，组成一颗平衡树
- 数据缓存
- 高效缓存特性：能缓存索引，也能缓存数据
- 索引缓存
- 压缩数据
- 可以压缩数据
- 加密数据
- 可以加密数据
- 集群数据库支持
- 不支持MySQL集群，NDB是集群的引I擎
- 主从复制支持
- 支持主从复制集群
- 资源占用
- 由于其功能和粒度都更强，因此对硬件的要求很高
- 分区支持
- 支持分区，可以提升扩展性和性能
- 表空间支持
- 支持共享和独立表空间，有利于管理和提升性能
<!-- OCR_END -->

### innodb适合的场景
+ 需要事务支持的业务场景，保证数据完整、一致性，例如有关账户交易，转账，充值
+ 行级锁定对高并发，有很好的适应能力，但是得是基于索引完成
+ 数据读写、更新频繁的业务，例如微博，微信，用户频繁刷新朋友，写朋友圈
+ 硬件要求好一点，内存要求足够大，能够充分发挥innodb特性（缓存），以此尽量减少磁盘IO

<!-- OCR_START -->
InnoDB引I擎的重要参数
说明
InnoDB使用一个缓冲池来保存索引和原始数据，缓冲池设置的
越大，理论上在存取表里面的数据时所需要的磁盘I/O就越少。官
innodb_buffer_pool_size = 2048M
方建议将InnoDB的BufferPool值配置为物理内存的50%～80%，
实际配置大小应根据具体环境而定
innodb_data_file_path = ibdatal:12M:
InnoDB数据文件的路径，默认为12MB大小ibdata1的单独文
autoextend
件，默认以64MB为单位自增（autoextend）
该参数用来设置InnoDB存储的数据目录信息和其他内部数据结
构的内存池大小。应用程序里的表越多，就需要在其中分配越多
的内存。对于一个相对稳定的应用来说，这个参数的大小也是相
innodb_additional_mem_pool_size
对稳定的，没有必要预留非常大的值。如果InnoDB用光了这个
16M
池内的内存，那么InnoDB将开始从操作系统分配内存，并且向
MySQL错误日志中记录警告信息。默认为1MB，当发现错误日志
中已经有相关的警告信息时，就应该适当地增加该参数的大小
InnoDB中的文件I/O线程。通常设置为4，如果是Windows则
innodb_file_io_threads=4
可以设置更大的值以提高磁盘I/O
你的服务器中有几个CPU就设置为几，建议使用默认设置，一
innodb_thread_concurrency=8
般设置为8
若设置为O，就相当于innodb_log_buffer_size队列满后再统一
innodb_fush_log_at_trx_commit = 2
存储，默认值为1，该值也是最安全的设置
innodb_log_buffer_size = 16M
默认为1MB，通常设置为8～16MB就足够了
确定日志文件的大小，更大的设置可以提高性能，但也会增加数
innodb_log_file_size = 128M
据库恢复的时间
为提高性能，MySQL可以以循环的方式将日志文件写到多个文
innodb_log_files_in_group = 3
件。推荐设置为3
innodb_max_dirty_pages_pct = 90
InnoDB主线程刷新缓存池中的数据
InnoDB事务被回滚之前可以等待一个锁定的超时秒数。InnoDE
innodb_lock_wait_timeout=120
在它自己的锁定表中自动检测事务死锁并且回滚事务。默认值是
50秒
InnoDB为独立表空间模式，每个数据库的每个表都会生成一个
innodb_file_per_table = 1
数据空间。值为0表示关闭，值为1表示开启
innodb_data_home_dir=/data/xxx
InnoDB数据的存放路径
innodb_log_group_home_dir=/data/xxx
日志分组的目录路径
<!-- OCR_END -->

### InnoDB调优
+ 主键尽量小，避免secondary index带来过大空间负担
+ 建立有效索引，避免全表扫描
+ 尽量缓存所有的索引和数据，使用内存缓存，减少磁盘IO，提高响应速度。
+ 避免主键更新，这回带来大量的数据移动。

## Memory存储引擎
Memory就是内存的意思，因此Memory存储引擎（又称为heap引擎）的数据存储是放在内存（注意：由max_heap_table_size参数控制内存占用大小，默认为16MB。）中的，因此存取速度特别快，但是如果数据库宕机或重启，那么所有的数据就都会丢失，因此它比较适合用于存放临时表的数据

例如，discuz论坛数据库中的统计在线人数的session表采用的就是Memory引擎。

Memory存储引擎默认采用的是Hash索引，而不像其他引擎（MyISAM和InnoDB）默认的是B-tree索引。

Memory存储引擎在使用上也有一些限制，例如，仅支持表锁，不支持TEXT和BlOB数据类型，还有当存储变长字段（varchar）时是按照定长字段（char）来进行的，这也会浪费一些内存空间。Memory存储引擎在企业工作中应用的不是很多，读者作为知识点了解一下即可。

## 重点学习InnoDB
MySQL从5.5版本开始即将InnoDB作为默认存储引擎，该存储引擎是第一个完整支持事务ACID特性的存储引擎，且支持数据行锁、多版本并发控制（MVCC）、外键，以及一致性非锁定读。

InnoDB作为MySQL的默认存储引擎，这就意味着默认创建的表都会使用此存储引擎，除非使用“ENGINE=参数”指定创建其他存储引擎的表。

InnoDB关键属性

+ ACID事务特性、包括commit、rollback、crash恢复
+ 行级别锁，多版本并发控制
+ 利用主键的聚簇索引（clustered index）在底层存储数据，提升主键查询的IO能力。
+ 支持外键

## ACID介绍
事务（Transaction）是数据库区别于文件系统的重要特性之一，事务可由一条非常简单的SQL语句组成，也可以由一组复杂的SQL语句组成。

事务中的操作，要么都做修改，要么都不做，这就是事务的基本目的。

理论上说，事务有着极其严格的定义，它必须同时满足四个特性，即通常所说的事务的ACID特性。

ACID模型是关系型数据库普遍支持的事务模型，用于保证数据的一致性，其中的ACID所代表的具体含义分别如下。

1）A：atomicity原子性。事务是一个不可再分割的工作单位，事务中的操作要么都发生，要么都不发生。

2）C：consistency一致性。事务开始之前和事务结束以后，数据库的完整性约束没有被破坏。也就是说，数据库事务不能破坏关系数据的完整性以及业务逻辑上的一致性。

3）I：isolation独立性。多个事务并发访问时，事务之间是隔离的，一个事务不应该影响其他事务的运行效果。

4）D：durability持续性。在事务完成以后，该事务对数据库所做的更改便持久地保存在数据库之中，并不会被回滚。

举例来说，比如银行的汇款1000元的操作，简单来说，可以拆分成A账户的余额-1000，B账户的余额+1000，还要分别在A和B的账户流水上记录余额变更日志，这四个操作必须放在一个事务中完成，否则丢失其中的任何一条记录对整个系统来说都是不完整的。

对于上述例子来说，原子性体现在要么四条操作每条都成功，这就意味着汇款成功；要么其中某一个操作失败，则整个事务中的四条操作都回滚，即汇款失败。一致性表示当汇款结束时，A账户和B账户里的余额变化和操作日志记录是可以对应起来的。独立性表示在汇款操作过程中，如果有C账户也在往B账户里汇款的话，那么两个事务之间相互不会影响，即“A->B”有四个独立操作，“C->B”也有四个独立操作。持久性表示当汇款成功时，A和B的余额就变更了，不管是数据库重启还是别的什么原因，该数据已经写入到磁盘中作为永久存储，不会再发生变化，除非有新的事务发生。

事务的隔离性，是通过mysql锁机制实现，原子性、一致性、持久性通过mysql的redo和undo日志完成

### 显示事务开关
```plain
start transaction/begin 开始事务
commit/rollback transaction 结束事务
```

### 隐式事务提交
当create、alter、grant、revoke等语句，会隐式的提交事务

# MySQL主从复制架构
mysql的主从复制，是一个老牌技术了，发展了很多年，也运用了很多年

主从、也就是有一个master机器、以及一个、或者多个slave机器，用于数据的同步、备份。

MySQL数据库的主从复制技术与使用scp/rsync等命令进行的异机文件级别复制类似，都是数据的远程传输，只不过MySQL的主从复制技术是其软件自身携带的功能，无须借助第三方工具

并且，MySQL的主从复制并不是直接复制数据库磁盘上的文件，而是将逻辑的记录数据库更新的binlog日志发送到需要同步的数据库服务器本地，然后再由本地的数据库线程读取日志中的SQL语句并重新应用到MySQL数据库中，从而即可实现数据库的主从复制。

## MySQL主从复制介绍
MySQL数据库支持单向、双向、链式级联、环状等不同业务场景的主从复制。

在复制过程中，一台服务器（严格来讲是实例）作为主数据库（Master），接收来自用户的、对其内容的更新，而一个或多个其他的服务器则作为从服务器（Slave），接收来自主服务器binlog文件的日志内容，然后将该日志内容解析出的SQL语句重新应用到其他从服务器中，使得主从服务器数据达到一致。

<!-- OCR_START -->
- 超哥带你学
- 单向主从同步
- Replication
- master 1
- salve l
- salve 1
- 一主两从
- 一主多从的复制架构
- salve 小
<!-- OCR_END -->

如果设置了链式级联复制，那么，从服务器本身除了作为从服务器之外，也会同时作为其下面从服务器的主数据库服务器。链式级联复制形式类似于A==>B==>C。

## 双主、双向同步（互为主从）

<!-- OCR_START -->
- Replication
- 超哥带你学
- 双向主从
- master 1
- master
<!-- OCR_END -->

双向主、主的复制架构，可以在master1或者master2都可以写入数据，也可以同时写入数据（需要额外配置）

### 线性级联、单向双主复制

<!-- OCR_START -->
- 单向线性级联同步
- slave 1
- master l
- master 1
<!-- OCR_END -->

### 环状级联、单向多主复制

<!-- OCR_START -->
- master l
- master b
- 单向环状级联同步
- master 3
<!-- OCR_END -->

## 官网mysql复制架构图

<!-- OCR_START -->
Master>Slave
Master>Slave>Slave
Master>Slave(Multi-Source)
Ring(Multi-Master)
Master<Master(Multi-Master)
<!-- OCR_END -->

在当前的生产工作环境中，MySQL主从复制默认都是异步的复制方式，即不是严格实时的数据同步，但是在正常情况下带给用户的体验几乎都是实时的（延迟的情况见后文讲解）。

## 为什么用主从复制
MySQL主从复制集群技术使得MySQL数据库支持大规模高并发的读写操作成为可能，同时又能有效地解决物理服务器宕机场景的数据备份和进行快速业务切换的问题。

对于企业生产环境来说，MySQL主从复制主要有以下几个重要的应用场景。

### salve作为master实时数据备份
主从服务器架构的设计，可以大大加强MySQL数据库架构的健壮性。例如，当主服务器出现问题时，我们可以人工切换或设置成自动切换到从服务器继续提供服务，此时从服务器的数据和宕机时的主数据库几乎是一致的。

这有些类似于NFS存储数据通过inotify+rsync将数据同步到备份的NFS服务器，只不过MySQL的复制方案是其自带的工具，实现的方式是逻辑的复制，而非文件层级的复制。

缺点

利用MySQL的主从复制技术进行数据备份，在硬件故障、软件故障、人为在数据库外误操作的场景下，该数据备份是有效的；但对于人为地在数据库中执行drop、delete等语句删除数据的情况，从库的备份功能就没有用了，因为从服务器也会执行删除的语句。

### slave与master实现读写分离
MySQL主从服务器架构可通过程序（PHP、Java等）或代理软件（maxscale、atlas）实现对用户（客户端）的请求按读和写进行分离访问，

即让从服务器仅仅处理用户的select（查询）请求，以降低用户查询的响应时间及同时在主服务器上读写所带来的访问压力。

对于更新的数据（例如update、insert、delete语句）仍然会交给主服务器处理，以确保主服务器和从服务器保持实时同步。

百度、淘宝、新浪等绝大多数的网站都是用户浏览的页面多于用户发布内容的页面，因此通过在从服务器上接收只读请求，就可以很好地减轻主库的读压力

且从服务器可以很容易地扩展为多台，使用LVS进行负载均衡（读写分离软件自身大多也有负载均衡的功能），效果就非常棒了，这就是传说中的数据库读写分离架构。

## 读写分离架构
通过程序代码，可以通过设置多个连接文件，实现对数据库的读写分离

逻辑

+ 当关键字是select，读取slave从库
+ 当update、insert、delete，连接master库，写入

<!-- OCR_START -->
- slave
- 超哥带你学
- replication
- read
- Server Load Balancer
- lication
- write
- master 1
<!-- OCR_END -->

读写分离，是程序代码，对整体程序架构改造实现

mysql自身无法直接实现读写分离

能够实现读写分离的一些工具

有如下开源软件可以实现

+ Maxscale
+ Atlas
+ Mycat

可以实现mysql的读写分离，且支持负载均衡

读写分离原理图

<!-- OCR_START -->
- slave
- 超哥带你学，
- replication
- select
- 4
- Server Load Balancér
- HTTP Reaves+
- HTTP Reqvest
- 3
- DELETE`
- write
- UPDATE
- HWSERT
- masterl
<!-- OCR_END -->

## 主从复制原理
MySQL的主从复制是一个异步的复制过程（虽然一般情况下感觉是实时的），数据将从一个MySQL数据库（我们称之为Master）复制到另一个MySQL数据库（我们称之为Slave），在Master与Slave之间实现整个主从复制的过程是由三个线程参与完成的。

其中有两个线程（SQL线程和IO线程）在Slave端，另外一个线程（binlog dump线程）在Master端（MySQL 5及以前是3个线程完成复制，从MySQL 6起SQL线程可以是多个）。

要实现MySQL的主从复制功能，首先必须打开Master端的binlog日志功能。

因为整个复制过程实际上就是Slave从Master端获取binlog日志，然后再在Slave上以相同的顺序执行获取的binlog日志中所记录的各种SQL操作，从而实现主从数据一致的功能。

配置文件如下

```plain
[mysqld]
user=mysql
port=3307
socket=/data/3307/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3307/data
log-bin=/data/3307/mysql-bin        # 这里是定义二进制日志文件，用于复制
server-id=6
secure_file_priv= ''
#general_log=on
#general_log_file=/data/3307/data/mysql-server56.log
# slow-log
slow-query-log = ON                        #<==慢查询开启开关
long_query_time = 2                        #<==记录大于2秒的SQL语句。
log_queries_not_using_indexes = ON         #<==没有使用到索引的SQL语句。
slow-query-log-file = /data/3307/slow.log  #<==记录SQL语句的文件。
min_examined_row_limit = 800               #<==记录结果集大于800行的SQL语句。
# 编码
character-set-server=utf8
```

## 详细原理过程

<!-- OCR_START -->
- 1.全备还原到从库
- .指定master主库信息
- 3.开启slave
- 1.配置log-bin
- 4.查看slave状态
- 数据变动
- 3.用于复制的用户
- 线程
- insert、updlate、delete
- 4.锁表备份
- 账号验证通过
- 创建ro复制线程
- create.drop、ater
- binlog文件，以及Pos值
- 不包含select、shou
- 超哥保你
- binlog日志数据
- 执行SQL写入数据
- binlog日志数据写入最底端
- reay-binindex
- MYSaLdate
- lt.00000
- 连接master
- 配置连接信息
- relay-binoooool
- changemasterto
- relay-bin0000o3
<!-- OCR_END -->

+ slave机器start slave，开启主从复制
+ slave机器的I/O线程会通过在master上已授权的复制用户，连接master服务器
- 通过该用户再从指定的binlog日志文件的指定位置，发送binlog日志的内容
- （binglog文件名，pos值，都通过change master命令指定了）
+ Master服务器接收到slave的I/O线程请求之后，负责复制的binlog dump线程会根据slave服务器的I/O线程的请求信息，进行读取binlog，以及pos值之后的日志信息
- 然后返回给slave的I/O线程
- 返回的信息除了binlog日志内容以外，以及master服务端新的binlog文件，以及POS值
+ slave此时的I/O线程接收到master发来的日志信息后，将binlog日志内容，写入到slave本身的relay-log中继日志中，如mysql-relay-bin.xxxxxx的末端
- 并且记录新的binlog文件信息，名字、pos值，写入master-info文件中，用于下一次读取binlog数据时，可以明确知道数据读取的起点
+ slave服务器的SQL线程会实时监测本地的Relay Log新增的日志内容，然后将Reloy Log文件中的内容，解析为SQL语句，且在自身slave按顺序执行这些SQL。

经过这些，就可以确保，master和slave执行了同样的SQL。

在复制状态正常的情况下，master和slave的数据是完全一样的。

## 复制小结
+ 主从复制是异步的进行SQL语句的复制
+ 复制时，主库有一个binlog dump 线程，从库有2个线程I/O线程、SQL线程
+ 在MySQL5.6之后，slave的SQL线程有多个
+ 实现主从复制的必要条件、主库开启binlog，基于binlog复制
+ 用于复制的所有mysql节点，server-id不能相同
+ binlog文件只记录数据库有更改的SQL，（主数据库有变化），对select、show以及未修改数据库的语句不会记录

## 主从复制实践
mysql主从复制、机器数量可以是

+ 单机、单数据库多实例
+ 多台服务器、每个机器单独部署数据库

于超老师这里使用2台linux虚拟机

### 环境
master 10.211.55.12 3306

slave1 10.211.55.9 3306

分别安装启动好mysql，配置参考超哥前面的笔记

检查数据库状态

```plain
# 参考超哥安装笔记
http://127.0.0.1:4000/DBA/MySQL%E5%A4%9A%E5%AE%9E%E4%BE%8B%E7%AE%A1%E7%90%86.html#%E5%AE%89%E8%A3%85%E6%B5%81%E7%A8%8B
```

确认两个服务器，是否正确启动了mysql，

master

root

yuchao668

```plain
[root@mysql-server56 3306]# clear
[root@mysql-server56 3306]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      3015/mysqld
[root@mysql-server56 3306]#
```

slave

root 空密码

```plain
[root@chaoge_slave1 3306]#
[root@chaoge_slave1 3306]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      19802/mysqld
[root@chaoge_slave1 3306]#
```

### master主库操作
master复制操作，必须开启binlog

```plain
[root@mysql-server56 3306]# cat /data/3306/my.cnf
[client]
port=3306
socket=/data/3306/mysql.sock

[mysqld]
user=mysql
port=3306
socket=/data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3306/data
log-bin=/data/3306/mysql-bin    # 这里必须开启
server-id=5    # 这里必须不一样

[mysqld_safe]
log-error=/data/3306/mysql_3306_error.log
pid-file=/data/3306/mysqld_3306.pid
```

检查主库binlog状态

```plain
[root@mysql-server56 3306]# mysql -p -S /data/3306/mysql.sock -e "show variables like 'log_bin'"
Enter password:
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    |
+---------------+-------+

[root@mysql-server56 3306]# mysql -p -S /data/3306/mysql.sock -e "show variables like 'server_id'"
Enter password:
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| server_id     | 5     |
+---------------+-------+
```

### Master操作
前面原理说过，slave和master连接同步，得有一个账号进行连接master，允许同步数据  

```plain
mysql> grant replication slave on *.* to 'repl_chaoge'@'10.211.55.%' identified by 'chaoge668';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

# 检查
mysql> select user,host from mysql.user;
+-------------+-------------+
| user        | host        |
+-------------+-------------+
| repl_chaoge | 10.211.55.% |
| root        | 127.0.0.1   |
| root        | localhost   |
+-------------+-------------+
3 rows in set (0.00 sec)

# 检查授权信息
mysql> show grants for repl_chaoge@'10.211.55.%';
+----------------------------------------------------------------------------------------------------------------------------------+
| Grants for repl_chaoge@10.211.55.%                                                                                               |
+----------------------------------------------------------------------------------------------------------------------------------+
| GRANT REPLICATION SLAVE ON *.* TO 'repl_chaoge'@'10.211.55.%' IDENTIFIED BY PASSWORD '*B842582C3338645C950CE4FB530EDE23FC687264' |
+----------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

#### Master锁表
既然要开始数据同步，锁表，防止数据写入

```plain
mysql> flush table with read lock;
Query OK, 0 rows affected (0.00 sec)

# 锁表对于不同的引擎，有超时时间
mysql> show variables like '%timeout%';
+-----------------------------+----------+
| Variable_name               | Value    |
+-----------------------------+----------+
| connect_timeout             | 10       |
| delayed_insert_timeout      | 300      |
| innodb_flush_log_at_timeout | 1        |
| innodb_lock_wait_timeout    | 50       |
| innodb_rollback_on_timeout  | OFF      |
| interactive_timeout         | 28800    |    # mysql 连接超时
| lock_wait_timeout           | 31536000 |
| net_read_timeout            | 30       |
| net_write_timeout           | 60       |
| rpl_stop_slave_timeout      | 31536000 |
| slave_net_timeout           | 3600     |
| wait_timeout                | 28800    |    # mysql 连接超时
+-----------------------------+----------+
12 rows in set (0.00 sec)
```

查看锁库状态

```plain
# 无法写入数据
mysql> create database kings;
ERROR 1223 (HY000): Can't execute the query because you have a conflicting read lock

# 查看主库状态
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000010 |     1248 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

当前的binlog文件名mysql-bin.000010，日志偏移量的位置，POS值 1248

这里的信息需要记录下来，数据锁定在这里了

slave开始复制也就从这里开始

### 导出主库数据
锁表后，可以导出数据库中现有所有的数据

+ 如果数据库过大，超过30G以上，采用Xtrabackup备份

```plain

--all--database，-A
---database，-B

[root@mysql-server56 3306]# mysqldump -pyuchao668 -S /data/3306/mysql.sock -A -B|gzip > /data/3306/backup/alldb_$(date +%F).sql.gz
Warning: Using a password on the command line interface can be insecure.

# 数据导出之后，可以再次检查，binlog状态，应该没有变化
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000010 |     1248 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

导出数据完毕后，可以解锁主库、恢复可写

```plain
mysql> unlock tables;
Query OK, 0 rows affected (0.00 sec)
```

### master数据发给slave
Scp、rsync等命令都可以，将备份的数据发给slave机器

```plain
[root@mysql-server56 3306]# scp -rp /data/3306/backup/alldb_2021-04-25.sql.gz root@10.211.55.9:/opt/
root@10.211.55.9's password:
alldb_2021-04-25.sql.gz                                                                                        100%  177KB  16.6MB/s   00:00
[root@mysql-server56 3306]#
```

## slave机器
从库机器的server_id参数必须唯一，和master区别开

并且要关闭binlog参数配置，禁用二进制日志（如果该从库不需要级联复制的话）

如下情况，从库才会开启binlog，记录从库的数据更新。

+ 级联同步，A > B > C，那这里的B数据库，就需要开启binlog
+ 在从库下做数据备份，也需要开启binlog，数据库备份必须有全备、以及binlog备份，才是完整的

### slave配置文件
修改my.cnf

```plain
[root@chaoge_slave1 3306]# cat my.cnf
[client]
port=3306
socket=/data/3306/mysql.sock

[mysqld]
user=mysql
port=3306
socket=/data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/data/3306/data
server-id=9
# 开启只读模式
read-only

[mysqld_safe]
log-error=/data/3306/mysql_3306_error.log
pid-file=/data/3306/mysqld_3306.pid
```

检查slave数据库状态

限制只读 mysql> set global read_only=1;

```plain
[root@chaoge_slave1 3306]# mysql -S /data/3306/mysql.sock
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.6.40 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show variables like 'log_bin';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | OFF   |
+---------------+-------+
1 row in set (0.00 sec)

mysql> show variables like 'server_id';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| server_id     | 9     |
+---------------+-------+
1 row in set (0.00 sec)

# 限制只读
mysql> set global read_only=1;
```

### slave导入master数据

<!-- OCR_START -->
- 新增数据
- binlog记录
- 数据同步
- 复制
- 超哥带你学
- slave
- master
<!-- OCR_END -->

我们在复制之前，应该让master和slave的数据一致、然后再开始复制

```plain
# slave导入数据
[root@chaoge_slave1 3306]# zcat /opt/alldb_2021-04-25.sql.gz |mysql -S /data/3306/mysql.sock
```

### slave连接master-info
mysql从库连接配置

```plain
mysql> grant replication slave on *.* to 'repl_chaoge'@'10.211.55.%' identified by 'chaoge668';
| mysql-bin.000010 |     1248 | 

# 连接命令
change master to 
master_host='10.211.55.12',
master_port=3306,
master_user='repl_chaoge',
master_password='chaoge668',
master_log_file='mysql-bin.000010',
master_log_pos=1248;
```

具体命令

将master的数据信息，写入slave的master.info文件中记录

```plain
[root@chaoge_slave1 3306]# mysql -S /data/3306/mysql.sock
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.6.40 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> change master to
    -> master_host='10.211.55.12',
    -> master_port=3306,
    -> master_user='repl_chaoge',
    -> master_password='chaoge668',
    -> master_log_file='mysql-bin.000010',
    -> master_log_pos=1248;
Query OK, 0 rows affected, 2 warnings (0.02 sec)
```

查看master.info

```plain
[root@chaoge_slave1 3306]# cat /data/3306/data/master.info
23
mysql-bin.000010
1248
10.211.55.12
repl_chaoge
chaoge668
3306
60
0

0
1800.000

0

86400

0
```

### 启动主从同步
```plain
# 关注如下2参数，两个IO线程
# Slave_IO_Running: No
# Slave_SQL_Running: No
mysql> show slave status\G

# 开启复制
mysql> start slave;

# 检查线程状态
             Slave_IO_Running: Yes
             Slave_SQL_Running: Yes
             Seconds_Behind_Master: 0
```

解释

+ Slave_IO_Running：Yes，这个表示I/O的线程状态，I/O线程负责从主库中读取Binlog日志，并将Binlog日志写入从库的中继日志中，状态为Yes表示I/O线程工作正常，否则异常。
+ Slave_SQL_Running：Yes，这个表示SQL的线程状态，SQL线程负责读取中继日志（relay-log）中的数据并转换为SQL语句应用到从数据库中，状态为Yes表示I/O线程工作正常，否则异常。
+ Seconds_Behind_Master：0，这个表示在复制过程中，从库比主库延迟的秒数，这个参数很重要，但企业里有更准确地判断主从延迟的方法：在主库中写时间戳，然后通过从库读取时间戳，与当前数据库时间进行比较，从而认定是否真的延迟。

## master写入数据
写入master数据，看看slave从库变化

未写入时的master、slave  
  

```plain
[root@mysql-server56 3306]# mysql -pyuchao668 -S /data/3306/mysql.sock -e "show databases"
Warning: Using a password on the command line interface can be insecure.
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+

# slave
[root@chaoge_slave1 3306]# mysql -S /data/3306/mysql.sock -e "show databases"
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+
[root@chaoge_slave1 3306]#
```

master写入数据

```plain
[root@mysql-server56 3306]# mysql -pyuchao668 -S /data/3306/mysql.sock -e "create database kings;"
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 3306]#
```

slave检查数据  

```plain
[root@chaoge_slave1 3306]# mysql -S /data/3306/mysql.sock -e "show databases"
+--------------------+
| Database           |
+--------------------+
| information_schema |
| kings              |
| mysql              |
| performance_schema |
| test               |
+--------------------+
[root@chaoge_slave1 3306]#
```

## 小结
这里就验证了master 、slave两个数据库已经数据同步了，主从复制基本完成。

## Master复制线程
线程也就是操作系统，实际干活的一个资源单位，就好比是一个工人，在努力的搬运数据。

查看MySQL线程状态

Master

```plain
mysql> show processlist\G
# 线程1，用于复制binlog数据
*************************** 1. row ***************************
     Id: 5
   User: repl_chaoge
   Host: chaoge-slave1.shared:56564
     db: NULL
Command: Binlog Dump    # 用于复制的master线程
   Time: 608
   # state状态，该线程已正确把binlog数据发给了save，并且当前等待binlog日志更新
  State: Master has sent all binlog to slave; waiting for binlog to be updated
   Info: NULL

# 线程2，是我们当前这个查询进程的命令，query语句
*************************** 2. row ***************************
     Id: 11
   User: root
   Host: localhost
     db: NULL
Command: Query
   Time: 0
  State: init
   Info: show processlist
2 rows in set (0.00 sec)
```

state有如下常见状态

<!-- OCR_START -->
- 主库1/O线程工作状态
- 解释说明
- 线程已经从二进制binlog日志中读取了一个事件并且正将
- Sendingbinlogeventtoslave
- 它发送到从服务器
- Finished reading one binlog; switching to next
- 线程已经读完二进制binlog日志文件，并且正在打开下一
- binlog
- 个要发送到从服务器的binlog日志文件
- 线程已经从binlog日志中读取到所有更新并已经发送到了
- Has sent all binlog to slave; waiting for binlog
- 从数据库服务器。线程现在为空闲状态，等待由主服务器上
- tobeupdated
- 二进制binlog日志中的新事件更新
- Waitingtofinalizetermination
- 线程停止时发生的一个很简单的状态
<!-- OCR_END -->

## Slave复制线程
slave从库干活的工人(线程)

```plain
[root@chaoge_slave1 3306]# mysql -S /data/3306/mysql.sock -e "show processlist\G"
# slave进行 I/O的线程，从master接收数据
*************************** 1. row ***************************
     Id: 5
   User: system user
   Host:
     db: NULL
Command: Connect
   Time: 823
   # 等待master发来数据
  State: Waiting for master to send event
   Info: NULL

 # 执行SQL写入到slave数据库的线程

*************************** 2. row ***************************
     Id: 6
   User: system user
   Host:
     db: NULL
Command: Connect
   Time: 406
 # slave当前以读取所有中继日志，等待上面的I/O线程更新binlog
  State: Slave has read all relay log; waiting for the slave I/O thread to update it
   Info: NULL

# 这是当前命令的线程
*************************** 3. row ***************************
     Id: 9
   User: root
   Host: localhost
     db: NULL
Command: Query
   Time: 0
  State: init
   Info: show processlist
[root@chaoge_slave1 3306]#
```

# MySQL主主复制
超哥上一节是讲了MySQL的一主一从复制

尽量多的做虚拟机快照

一主多从也就是，多准备几个slave，同样操作即可

复制结构还有

+ 级联复制
+ 双向主从（主主）
+ 多主复制（环状）

## MySQL级联复制
也称之为MSS复制，master、slave1、slave2

**级联复制**（cascade）：是指从主场地复制过来的又从该场地再次复制到其他场地，即A场地把数据复制到B场地，B场地又把这些数据或其中部分数据再复制到其他场地。

级联复制可以平衡当前各种数据需求对网络通信的压力。

级联复制通常与**主/从复制**（master/slave）联合使用。

master、slave1 都需要开启binlog

Slave

<!-- OCR_START -->
- 复制
- 超部
- 4
- 单向线性级联同步
<!-- OCR_END -->

MySQL复制核心是通过传输binlog日志实现复制

级联复制是对主从复制的扩展

级联复制架构有一个中间从库B的角色

## 从库开启binlog场景
在做主从复制实验时候，超过说的是slave不开启binlog

这里slave开启binlog是应对如下场景

+ 当前slave还要作为其他slave的主库，例如
- 级联复制
- 双主、互为主从
+ 当slave也作为全备的服务器，也就需要binlog开启，进行增量数据恢复

## 如何配置
上一节超哥讲的主从复制，是如下形式

有三台机器

```plain
master1    10.211.55.12    A        主
slave1    10.211.55.9        B        从

slave2 10.211.55.8        C
```

如何实现级联？

只需要在机器B上，开启binlog，机器B，修改my.cnf

```plain
[mysqld]
log_bin = /data/3306/logs/mysql-bin
log_slave_updates    #<==必须要有这个参数，否则不会记录Binlog日志。
#<==相当于find /path -type f -name " mysql-bin.000*" -mtime +7 |xargs rm -f
expire_logs_days = 7
```

这里只需要在机器B上开启binlog日志，然后让机器C和B进行同步，就实现了级联复制，操作和前面一样，这里超哥就不说了，大家当做扩展练习

最终完成的效果应该是

数据写入A机器，mysql-master

立即同步到B、以及C两个从机器

## 级联复制效果
级联复制是主从复制的扩展，常用在下面的效果

+ 主从复制、A、B、C三个数据库
- B库作为级联中间库，减轻A库的压力
+ 级联复制、主从复制主要用于性能不高的业务场景
- 数据备份
- 企业内网数据

## MySQL主主复制
MySQL主主复制是级联复制的特殊形式，上一节是A > B > C 的单向复制

而主主复制是特殊架构，互为master，都可以写入数据。

<!-- OCR_START -->
- Master 1
- Master
- 双主、双向同步
- 互为主从
<!-- OCR_END -->

主主复制，也就是互相复制，其实就是配置参数，多了一些。

### 背景
既然是主主模式、也就是都可以写入数据，部分架构设计会考虑主主模式，提高并发写入能力，但是高并发场景下，master1、master2都要并发写入，压力并不会小，具体还需要实际场景验证。

如果要切实增加大并发写入数据，主主复制架构并不是好选择，有如下参考

+ 分库设计
- 例如有一个单实例数据库，运行多个库，如web业务库、博客业务库、CRM业务库
- 可以将每一个产品库都做成一套数据库集群，提高并发写入的压力
- 这样只需要运维同学调整运维架构，无须变动业务代码
+ 分表设计
- 这需要开发人员，针对业务进行对数据字段进行分表设计，运维人员配合处理
+ 数据库集群拆分
- 当单表数据写入达到指定行数后，自动化扩容、拆表数据。

## MySQL主主复制
该架构部署，有两种方案

### 方案：主键自增
例如这里是一张表，包含了自主键，自增

自增

```plain
CREATE TABLE `web_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_type` smallint(6) NOT NULL,
  `payment_number` varchar(128) DEFAULT NULL,
  `order_number` varchar(128) NOT NULL,
  `actual_amount` double NOT NULL,
  `status` smallint(6) NOT NULL,
  `date` datetime(6) NOT NULL,
  `pay_time` datetime(6) DEFAULT NULL,
  `cancel_time` datetime(6) DEFAULT NULL,
  `account_id` int(11) NOT NULL,
  `order_type` smallint(6) DEFAULT 0,
  `memo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `web_order_account_id_c8203036_fk_web_account_id` (`account_id`),
  CONSTRAINT `web_order_account_id_c8203036_fk_web_account_id` FOREIGN KEY (`account_id`) REFERENCES `web_account` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52127 DEFAULT CHARSET=utf8
```

<!-- OCR_START -->
- 对象
- web_order@luffy_dev (1...
- 品品
- 目、
- id
- payment_type
- payment_number
- order_number
- actual_amount
- status
- date
- 1
- 20171030224451743
- 2017-10-2022
- 2
- *20 22
- 3
- :H:101:
- 4
- 518
- 5
- ：610
- 6
- 2610
- 7
- .9
- 619
- 8
- 1：619
- ?...  T
- M. ...
- 10
- : H717:
- 11
- ...
- 717:
- 12
- 13
- ：F2717:
- 14
- .718:
- 15
- 1H:2718
- 16
- 719
- 17
- :H5:2720
- 18
- .720
- 19
- 010
<!-- OCR_END -->

我们能看出来，这里的主键ID是递增1的，每次加一

这是通过auto_increment参数，每次添加一条记录，id号就加一

有关主主复制，master1和master2都是可以写入数据的，并发写入

```plain
master1库，每张表的主键都为奇数、1、3、5、7。。
master2表，每张表的主键都为偶数，例如2、4、6、8。。。
```

知道怎么配置数据表，配置文件如下

my.cnf

m1的my.cnf

+ auto_increment_increment=2 # m1设置，间隔为2，奇数是1、3、5
+ auto_increment_offset=1 # id初始位置是1

m2的my.cnf

+ auto_increment_increment=1 # m2设置，间隔为1，id是2、4、6
+ auto_increment_offset=2 # m2的id初始位置是2

### 问题点
该方式

+ 优点：网站代码无须做更改，快速实现双主架构
+ 缺点：id号在表中不是连续的

### 自增ID-主主复制实践
### 环境准备
主主复制，准备好2台完全一样的mysql环境即可

```plain
m1 10.211.55.12   3306
m2 10.211.55.9        3306
```

### m1
```plain
# 环境准备
[root@mysql-server56 opt]# mkdir -p /mm_data/3306/
[root@mysql-server56 3306]# touch /mm_data/3306/my.cnf
```

my.cnf m2待会也用这个配置文件，m1和m2这里一定得不同！！

这是m2的配置

server_id = 2

auto_increment_increment = 2

auto_increment_offset = 2  

```plain
# 这是m1的配置
[root@mysql-server56 3306]# cat my.cnf
[client]
port=3306
socket=/mm_data/3306/mysql.sock
default-character-set=utf8

[mysqld]
user=mysql
port=3306
socket=/mm_data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/mm_data/3306/data
log-bin=/mm_data/3306/mysql-bin
server-id=1
expire_logs_days=7
auto_increment_increment=2 # 自增id的步长，为2，依次是1、3、5
auto_increment_offset=1    # 自增id起点
slave-skip-errors=1032,1062,1007,1008,1146,1049
log_slave_updates
character-set-server=utf8

[mysqld_safe]
log-error=/mm_data/3306/mysql_3306_error.log
pid-file=/mm_data/3306/mysqld_3306.pid

# 授权
[root@mysql-server56 3306]# chown -R mysql.mysql /mm_data/

# 初始化
/application/mysql-5.6.40-linux-glibc2.12-x86_64/scripts/mysql_install_db --defaults-file=/mm_data/3306/my.cnf --basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/ --datadir=/mm_data/3306/data/ --user=mysql

# 启动脚本
#!/bin/bash
port=3306
mysql_user="root"
Cmdpath="/application/mysql-5.6.40-linux-glibc2.12-x86_64/bin"
mysql_sock="/mm_data/${port}/mysql.sock"
mysqld_pid_file_path=/mm_data/${port}/mysqld_${port}.pid

start(){
if [ ! -e "$mysql_sock" ];then
    printf "Starting MySQL...\n"
    /bin/sh ${Cmdpath}/mysqld_safe --defaults-file=/mm_data/${port}/my.cnf --pid-file=$mysqld_pid_file_path 2>&1 > /dev/null &
    sleep 3
else
    printf "MySQL is running...\n"
    exit 1
fi
}

stop(){
    if [ ! -e "$mysql_sock" ];then
        printf "MySQL is stopped...\n"
        exit 1
    else
        printf "Stoping MySQL...\n"
        mysqld_pid=`cat "$mysqld_pid_file_path"`
    if (kill -0 $mysqld_pid 2>/dev/null)
        then
        kill $mysqld_pid
        sleep 2
        fi
    fi
}

restart(){
    printf "Restarting MySQL...\n"
    stop
    sleep 2
    start
}

case "$1" in
start)
    start
;;
stop)
    stop
;;
restart)
    restart
;;
*)
    printf "Usage: /data/${port}/mysql{start|stop|restart}\n"
esac

# 授权
[root@mysql-server56 3306]# chmod +x mysql_3306

# 创建文件
[root@mysql-server56 3306]# touch /mm_data/3306/mysql_3306_error.log

# 启动
[root@mysql-server56 3306]#  /mm_data/3306/mysql_3306 start
Starting MySQL...
[root@mysql-server56 3306]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      16162/mysqld
[root@mysql-server56 3306]#
```

至此，m1主库的binlog和表记录id的自增配置好了

也正确启动了

m2也遵循一样的操作

### 创建复制用户
```plain
mysql> grant replication slave on *.* to 'repl'@'10.211.55.%' identified by 'repl888';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql>
```

  

### 导出m1的数据
```plain
--lock-all-tables，-x
    所有数据库中的所有表加锁。在整体转储过程中通过全局读锁定来实现。该选项自动关闭--single-transaction和--lock-tables。

--master-data[=value]
    该选项将二进制日志的位置和文件名写入到输出中。该选项要求有RELOAD权限，并且必须启用二进制日志。
    如果该选项值等于1，位置和文件名被写入CHANGE MASTER语句形式的转储输出，如果你使用该SQL转储主服务器以设置从服务器，从服务器从主服务器二进制日志的正确位置开始。
    如果选项值等于2，CHANGE MASTER语句被写成SQL注释。如果value被省略，这是默认动作。
```

  
备份语句

```plain
[root@mysql-server56 3306]# mysqldump  -S /mm_data/3306/mysql.sock -A -B -x --master-data=1 |gzip > /mm_data/mm_all_db_$(date +%F).sql.gz
Warning: Using a password on the command line interface can be insecure.
[root@mysql-server56 3306]#

[root@mysql-server56 ~]# cd /mm_data/
[root@mysql-server56 mm_data]# ls
3306  mm_all_db_2021-04-26.sql.gz
[root@mysql-server56 mm_data]#

# 该数据文件，内容如下，做了一个change_master
[root@mysql-server56 mm_data]# zcat mm_all_db_2021-04-26.sql.gz |grep -i '^change'
CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=417;
```

发给m2机器

```plain
[root@mysql-server56 mm_data]# scp -rp /mm_data/mm_all_db_2021-04-26.sql.gz root@10.211.55.9:/mm_data/
root@10.211.55.9's password:
mm_all_db_2021-04-26.sql.gz                                                                                                                                                                100%  177KB  32.9MB/s   00:00

[root@mysql-server56 mm_data]#
```

### m2
修改m2配置文件  

```plain
[root@chaoge_slave1 mm_data]# cat 3306/my.cnf
[client]
port=3306
socket=/mm_data/3306/mysql.sock

[mysqld]
user=mysql
port=3306
socket=/mm_data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/mm_data/3306/data
log-bin=/mm_data/3306/mysql-bin
server-id=2
expire_logs_days=7
auto_increment_increment=2
auto_increment_offset
slave-skip-errors=1032,1062,1007,1008,1146,1049
log_slave_updates

[mysqld_safe]
log-error=/mm_data/3306/mysql_3306_error.log
pid-file=/mm_data/3306/mysqld_3306.pid
[root@chaoge_slave1 mm_data]#
```

重启

```plain
[root@chaoge_slave1 mm_data]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      27758/mysqld
[root@chaoge_slave1 mm_data]#
```

### m2导入数据
m1导出的数据是全库数据，也包含了mysql.user表中的数据，也包含了m1上创建的复制用户。

进行数据导入

```plain
[root@chaoge_slave1 mm_data]# zcat /mm_data/mm_all_db_2021-04-26.sql.gz |mysql -S /mm_data/3306/mysql.sock

```

在m2中写入m1的binlog信息

mysql> grant replication slave on _._ to 'repl'@'10.211.55.%' identified by 'repl888';

这里不需要指定binlog文件，以及POS值了

因为在m1数据备份里，已经包含了该信息，通过--master-data=1参数的作用  

```plain
mysql> change master to
    -> master_host='10.211.55.12',
    -> master_port=3306,
    -> master_user='repl',
    -> master_password='repl888';
Query OK, 0 rows affected, 2 warnings (0.00 sec)

mysql>
mysql> start slave;
mysql> show slave status\G
```

确认如下两行信息

```plain
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
```

### 小结
此时m1是master m2是slave，单向主从复制搭建好了

### 反过来m2>m1
此时需要配置m2是mater，m1是slave

记录m2的binlog信息  

```plain
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000003 |  2163445 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

#### m1操作
这里就是，反过来步骤，在搞一边

m1指定m2的复制信息  

```plain

mysql> change master to
    -> master_host='10.211.55.9',
    -> master_port=3306,
    -> master_user='repl',
    -> master_password='repl888',
    -> master_log_file='mysql-bin.000003',
    -> master_log_pos=2163445;
Query OK, 0 rows affected, 2 warnings (0.02 sec)

mysql> start slave;
Query OK, 0 rows affected (0.00 sec)

mysql> show slave status\G
```

确保如下

```plain
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
```

如果看不到2个yes，则一定会有报错日志提示

```plain
# 例如
  Last_IO_Errno: 2003
                Last_IO_Error: error connecting to master 'repl@10.211.55.9:3306' - retry-time: 60  retries: 2
```

#### 可能的问题
+ 注意iptables规则清空
+ selinux关闭
+ 配置步骤是否有误

### 测试主主模式
在m1上创建数据库、表、插入数据  

```plain
mysql> create database chaoge_kings;
Query OK, 1 row affected (0.00 sec)

mysql> show create database chaoge_kings;
+--------------+-----------------------------------------------------------------------+
| Database     | Create Database                                                       |
+--------------+-----------------------------------------------------------------------+
| chaoge_kings | CREATE DATABASE `chaoge_kings` /*!40100 DEFAULT CHARACTER SET utf8 */ |
+--------------+-----------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> use chaoge_kings;
Database changed

create table tanks(
id int not null auto_increment comment '主键id',
name varchar(20) not null comment '英雄姓名',
primary key (id));

mysql> insert into tanks(name) values('盾山'),('凯'),('猪八戒'),('东皇太一');
Query OK, 2 rows affected, 2 warnings (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 2

mysql> select * from tanks;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 盾山         |
|  3 | 凯           |
|  5 | 猪八戒       |
|  7 | 东皇太一     |
+----+--------------+
4 rows in set (0.00 sec)

# 每次自增，步长为2，下一次id就是9了
mysql> show create table tanks;
+-------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                                                                       |
+-------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tanks | CREATE TABLE `tanks` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(20) NOT NULL COMMENT '英雄姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8       |
+-------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

#### 登录m2查看数据
```plain
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| chaoge_kings       |
| mysql              |
| performance_schema |
| test               |
+--------------------+
5 rows in set (0.00 sec)

mysql> use chaoge_kings;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from tanks;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 盾山         |
|  3 | 凯           |
|  5 | 猪八戒       |
|  7 | 东皇太一     |
+----+--------------+
4 rows in set (0.00 sec)

# 插入数据
mysql>  insert into tanks(name) values('关羽'),('白起'),('钟无艳'),('刘备');
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

# 查看数据，m2数据库是从最大偶数6开始插入、每次递增2，因此插入的数据是，8、10、12、14
mysql> select * from tanks;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 盾山         |
|  3 | 凯           |
|  5 | 猪八戒       |
|  7 | 东皇太一     |
|  8 | 关羽         |
| 10 | 白起         |
| 12 | 钟无艳       |
| 14 | 刘备         |
+----+--------------+
8 rows in set (0.00 sec)
```

  
至此mysql主主复制、结果完成，

<!-- OCR_START -->
mysql> ^DBye
[root@chaoge_slave1 mm_data]# cat 3306/my.cnf
[root@mysql-server56mm_data]#cat 3306/my.cnf
[client]
port=3306
socket=/mm_data/3306/mysql.sock
default-character-set=utf8
[mysqld]
user=mysql
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/mm_data/3306/data
log-bin=/mm_data/3306/mysql-bin
server-id=1
server-id=2
expire_logs_days=7
注意区别
auto_increment_increment=2
auto_increment_offset=1
auto_increment_offset=2
m1和m2
slave-skip-errors=1032,1062,1007,1008,1146,1049
log_slave_updates
character-set-server=utf8
[mysqld_safe]
log-error=/mm_data/3306/mysql_3306_error.log
pid-file=/mm_data/3306/mysqld_3306.pid
[root@mysql-server56mm_data]#
[root@chaog
<!-- OCR_END -->

# MySQL之GTID复制
## mysql事务
为什么数据库需要事务？

+ 你表弟向你借500元，你打开APP、爽快的给他转账了，你的卡余额提示少了500
+ 你给表弟发了个微信，说，钱打过去了
+ 你表弟说：没收到啊哥，你别骗我行吗
+ 你钱扣少了，你表弟缺没收到钱，这事办的？咋整

讲道理应该是这样

1. 超哥发起转账，转给表弟
2. 超哥卡里少了500元
3. 表弟卡里多了500元

这三步骤、必然不得出问题，上面的案例，就是这三步发生了问题！

如果有事务、就不会发生这样的事

**事务就是**

这三件事、三个动作，是一根绳上的蚂蚱，要么都成功，要么都失败

转账要么到表弟账户、要么就转不出去、回到自己卡里

## 事务的ACID特性
```plain
TRANSACTION 事务 
```

### Atomicity原子性
原子性强调转账的三个步骤要么成功、要么失败

在一个事务中的所有SQL语句，要么全部执行成功，要么全部失败，即使成功的SQL语句也会被撤销，回到执行之前的状态。

### Consistency一致性
一致性是指数据库从一个状态、变为另一个状态

事务开始前、与结束后，数据库的完整性约束没有被破坏。

例如转账，无论成功、或者失败、这500不会多、也不会少

要么超哥卡里扣了500元、表弟多了500元

要么超哥转账失败500元未动、表弟一毛钱也没拿到

这个总和永远是500元，不多也不少

### Isolation隔离性
隔离性指的是每个读写事务对其他的事务操作，都是相互隔离不受影响的。

例如同是工商银行

+ 超哥转账操作不会影响到小猪佩奇的转账操作

### Durability持久性
事务一旦提交后，结果就是永久性生效。

超哥转账500给了表弟，表弟也收到钱了，这件事就结束了，真实生效了。

## 事务的实现

<!-- OCR_START -->
- 持久性
- redo_log
- 原子性
- 致性
- 事务的实现
- undo_log
- Multi-VersionConcurrencyControl，多版本并发控制
- 隔离性
<!-- OCR_END -->

更多高级mysql知识，超哥后期会再补充

### GTID是什么
从 MySQL 5.6.5 开始新增了一种基于 GTID 的复制方式。

通过 GTID 保证了每个在主库上提交的事务在集群中有一个唯一的ID。

这种方式强化了数据库的主备一致性，故障恢复以及容错能力。

在原来基于二进制日志的复制中，从库需要告知主库要从哪个偏移量进行增量同步，如果指定错误会造成数据的遗漏，从而造成数据的不一致。

借助GTID，在发生主备切换的情况下，MySQL的其它从库可以自动在新主库上找到正确的复制位置，这大大简化了复杂复制拓扑下集群的维护，也减少了人为设置复制位置发生误操作的风险。

另外，基于GTID的复制可以忽略已经执行过的事务，减少了数据发生不一致的风险。

### GTID长啥样
GTID (Global Transaction ID) 是对于一个已提交事务的编号，并且是一个全局唯一的编号。

GTID 实际上 是由 UUID+TID 组成的。

其中 UUID 是一个 MySQL 实例的唯一标识。

TID 代表了该实例上已经提交的事务数量，并且随着事务提交单调递增。下面是一个GTID的具体形式：

```plain
形式语法  
GTID = source_id ：transaction_id

具体结果
2E11FA47-61CA-11E1-9E33-C70AA9429562:28
```

在上面的定义中，每一个GTID均代表一个数据库的事务，等号右边的source_id表示执行事务的源服务器主库的uuid（也就是server_uuid）

而transaction_id是一个从1开始的自增的序列号，表示在这个主库上执行的第n个事务。

只要保证每台数据库的server_uuid全局唯一，以及每台数据库生成的transaction_id自身唯一，就能保证GTID的全局唯一性。

### server_uuid是什么
还记得以前我们在my.cnf中配置了一个参数

```plain
server_id=5

```

并且超哥要求master、slave的server_id必须唯一

为什么换成server_uuid

MySQL 5.6用128位的server_uuid代替了原本32位的server_id的大部分功能。

原因很简单，server_id依赖于my.cnf的手工配置，有可能会产生冲突，而自动产生128位uuid的算法可以保证所有的MySQL uuid都不会发生冲突。

在进行首次启动时，MySQL会自动生成一个server_uuid，并且保存到数据库目录下的auto.cnf文件里，这个文件目前存在的唯一目的就是保存server_uuid。

在MySQL再次启动时其会读取auto.cnf文件，继续使用上次生成的server_uuid。

## 使用GTID
GTID复制原理流程

+ master进行数据更新时、在事务前产生GTID号、一起记录到binlog日志。
+ slave的I/O线程将变更的binlog数据，写入到本地中继日志relay_log
+ slave的SQL线程从中继日志中获取GTID号，和本地的binlog对比查看是否有记录
- 有记录，说明该GTID事务已执行，slave数据库会忽略
+ 如果没有记录，slave数据库从relay_log中继日志中获取数据，且执行该GTID的事务，记录到binlog中

根据GTID号就可以知道事务最初是在哪个数据库上提交的

有了GTID号、可以方便主从复制的故障切换

### 主从故障切换
如图、在没有GTID以前，主从复制的故障切换

<!-- OCR_START -->
- new master
- crash
- old master.
- Slave
<!-- OCR_END -->

+ master-A宕机，需要将应用程序切换到master-B
+ slave-C得和master-B建立新的复制关系

只需要在slave-C上执行新的change master to xxx ，指定master-B即可

问题是，同一个事务、在每台服务器上的binlog名字和位置点、可能都是不一样的

比如执行一条SQL，创建了一个新数据库，执行了一个事务，在master-A机器的binlog中数据位置如下

```plain
mysql> show master status
    -> ;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000003 |     557 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

但是可能在机器master-B中的bin中，同一个SQL执行后，binlog数据位置可能是

```plain
mysql> show master status
    -> ;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000005 |     1251 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

  
那么这就是一个难题了，如果master-A宕机，需要切换到master-B

slave-C如何知道当前同步的起停数据位置点呢？master_log_file和master_log_pos填什么？

这就是为什么mysql官方开发了GTID复制方法。

往后，同一个事务的GTID在所有节点上都是一致的，slave-C机器根据GTID就可以知道数据的停止点在哪。

并且，mysql还提供了非常方便的参数master_auto_position，能够自动的获取GTID值，让运维更加省心了。

## GRID优缺点
优点

+ 根据GTID可以明确知道事务最开始是在哪个数据库提交的
+ GTID对于宕机切换，非常方便，明确数据起止点。

缺点

+ 开启了GTID的数据库，和未开启的数据库实例之间、是无法混用复制的

## GTID复制实践
### 环境准备
可以是单机多实例

也可以是多服务器

这里超哥用两台linux虚拟机服务器、初始化安装好mysql

<!-- OCR_START -->
- root@chaoge_slave1:~
- 1
- 92%
- 8%
- 显11GB
- 4/26, 11:56
- |8yuchao
- 口~
- Q初始化
- Xroot@mysql-server56:~(ssh)
- mysql>
- Ox
- mysql> show master status;
- |File
- I Position I Binlog_Do_DB I Binlog-Ignore_DB I Executed_Gtid_Set 1
- --+-
- ----+--
- -+---
- I mysql-bin.000003 1
- 4171
- 1 row in set (0.00 sec)
- mysql> show slave status;
- 机器A
- Empty set (0.00 sec)
- × root@chaoge_slave1:~ (ssh)
- 机器B
- I File
- +-
- 120 1
<!-- OCR_END -->

### 配置文件
```plain
m1 10.211.55.12 3306
m2 10.211.55.9  3306
```

m1 my.cnf

```plain
[root@mysql-server56 ~]# cat /mm_data/3306/my.cnf
[client]
default-character-set=utf8

[mysqld]
character-set-server=utf8
socket=/mm_data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/mm_data/3306/data
log-bin=/mm_data/3306/mysql-bin

server-id=1
expire_logs_days=7
log-slave-updates=1
binlog-format=ROW
gtid-mode=on
enforce-gtid-consistency=true

[mysqld_safe]
log-error=/mm_data/3306/mysql_3306_error.log
pid-file=/mm_data/3306/mysqld_3306.pid
sql_mode=NO_ENGINE_SUBSTITUTION,STRTICT_TRANS_TABLES
[root@mysql-server56 ~]#
```

slave my.cnf

```plain
[client]
default-character-set=utf8

[mysqld]
character-set-server=utf8
socket=/mm_data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/mm_data/3306/data
log-bin=/mm_data/3306/mysql-bin
server-id=2
expire_logs_days=7
log-slave-updates=1
binlog-format=ROW
gtid-mode=on
enforce-gtid-consistency=true

[mysqld_safe]
log-error=/mm_data/3306/mysql_3306_error.log
pid-file=/mm_data/3306/mysqld_3306.pid
sql_mode=NO_ENGINE_SUBSTITUTION,STRTICT_TRANS_TABLES
```

  
除了server-id完全一致，重启2个机器的mysql

参数解释

<!-- OCR_START -->
- my.cnf参数名称
- 说明
- server-id=x
- 同一个复制拓扑中的所有MySQL服务器的id号必须唯一
- binlog-format=ROW
- 设置二进制日志格式，这里设置为ROW格式
- log-slave-updates=1
- 开启开关让slave从库更新binlog日志
- gtid-mode = on
- 启用GTID复制模式，否则就是普通的复制模式
- enforce-gtid-consistency=true
- 强制确保GTID一致性
<!-- OCR_END -->

## Mater1--GTID主从复制
m1操作，创建用于slave复制的账号、权限

```plain
mysql> grant replication slave on *.* to 'repl'@'10.211.55.%' identified by 'repl888';
Query OK, 0 rows affected (0.01 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

导出主库数据

备注  

```plain
mysql提示: 当前数据库实例中开启了 GTID 功能, 在开启有 GTID 功能的数据库实例中, 导出其中任何一个库, 如果没有显示地指定--set-gtid-purged参数, 都会提示这一行信息. 意思是默认情况下, 导出的库中含有 GTID 信息, 如果不想导出包含有 GTID 信息的数据库, 需要显示地添加--set-gtid-purged=OFF参数. 于是乎, dump 变成了如下样子

➜ mysqldump -uroot -p --set-gtid-purged=OFF userdb > userdb.sql

使用以上这条命令 dump 出来的库是不包含 GTID 信息的
```

命令

```plain
[root@mysql-server56 ~]# mysqldump -S /mm_data/3306/mysql.sock  -A -B -x --set-gtid-purged=OFF|gzip > /mm_data/m1_alldb_$(date +%F).sql.gz
[root@mysql-server56 ~]#
```

## 查看GTID信息
```plain
mysql> show global variables like '%gtid%';
+---------------------------------+------------------------------------------+
| Variable_name                   | Value                                    |
+---------------------------------+------------------------------------------+
| binlog_gtid_simple_recovery     | OFF                                      |
| enforce_gtid_consistency        | ON     # 确保这里打开                      |
| gtid_executed                   | 20bdbbd9-a5cd-11eb-a6af-001c4279bcf3:1-4 |
| gtid_mode                       | ON     # 确保这里打开        
| gtid_owned                      |                                          |
| gtid_purged                     |                                          |
| simplified_binlog_gtid_recovery | OFF                                      |
+---------------------------------+------------------------------------------+
7 rows in set (0.00 sec)

# 查看uuid信息
mysql> show global variables like 'server%';
+----------------+--------------------------------------+
| Variable_name  | Value                                |
+----------------+--------------------------------------+
| server_id      | 1                                    |
| server_id_bits | 32                                   |
| server_uuid    | 20bdbbd9-a5cd-11eb-a6af-001c4279bcf3 |
+----------------+--------------------------------------+
3 rows in set (0.00 sec)

# 数据插入后，会生成新的GTID
mysql> show master status;
+------------------+----------+--------------+------------------+------------------------------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                        |
+------------------+----------+--------------+------------------+------------------------------------------+
| mysql-bin.000004 |      811 |              |                  | 20bdbbd9-a5cd-11eb-a6af-001c4279bcf3:1-4 |
+------------------+----------+--------------+------------------+------------------------------------------+
1 row in set (0.00 sec)

#
```

## 发送数据给slave
```plain
[root@mysql-server56 ~]# scp -rp /mm_data/m1_alldb_2021-04-26.sql.gz root@10.211.55.9:/mm_data/
root@10.211.55.9's password:
m1_alldb_2021-04-26.sql.gz             100%  177KB  21.2MB/s   00:00

[root@mysql-server56 ~]#
```

## slave操作
导入m1发来的数据  

```plain
[root@chaoge_slave1 mm_data]# zcat m1_alldb_2021-04-26.sql.gz |mysql -S /mm_data/3306/mysql.sock
[root@chaoge_slave1 mm_data]#
```

登录slave，配置m1的复制信息

```plain
[root@chaoge_slave1 mm_data]# mysql -S /mm_data/3306/mysql.sock
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> change master to
    -> master_host='10.211.55.12',
    -> master_port=3306,
    -> master_user='repl',
    -> master_password='repl888',
    -> master_auto_position=1;
Query OK, 0 rows affected, 2 warnings (0.02 sec)

mysql>
```

## 启动slave start
```plain
# 启动slave，测试主从复制
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.211.55.12
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000004
          Read_Master_Log_Pos: 657
               Relay_Log_File: mysqld_3306-relay-bin.000002
                Relay_Log_Pos: 867
        Relay_Master_Log_File: mysql-bin.000004
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
            ....
```

## 测试数据写入
```plain
# master上写入数据
mysql> create database kings_cc;
Query OK, 1 row affected (0.00 sec)

mysql>

# slave检查数据
mysql> show databases like '%kings%';
+--------------------+
| Database (%kings%) |
+--------------------+
| kings_cc           |
+--------------------+
1 row in set (0.00 sec)

# 查看slave的GTID信息
# 超哥这里的环境是双主
mysql> show master status;
+------------------+----------+--------------+------------------+--------------------------------------------------------------------------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                                                                    |
+------------------+----------+--------------+------------------+--------------------------------------------------------------------------------------+
| mysql-bin.000004 |   644131 |              |                  | 20bdbbd9-a5cd-11eb-a6af-001c4279bcf3:1-4,
7b2ec017-a62c-11eb-a91d-001c426c932a:1-115 |
+------------------+----------+--------------+------------------+--------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

  
至此基于GTID的主从复制也搭建好了。

数据写入后，GTID变化，事务更新  

```plain
# master数据更新

mysql> create table tanks_cc(id int,name varchar(50));
Query OK, 0 rows affected (0.02 sec)

mysql> show master status\G
*************************** 1. row ***************************
             File: mysql-bin.000004
         Position: 987
     Binlog_Do_DB:
 Binlog_Ignore_DB:
Executed_Gtid_Set: 20bdbbd9-a5cd-11eb-a6af-001c4279bcf3:1-5
1 row in set (0.00 sec)

# slave
mysql> show master status\G
*************************** 1. row ***************************
             File: mysql-bin.000004
         Position: 644307
     Binlog_Do_DB:
 Binlog_Ignore_DB:
Executed_Gtid_Set: 20bdbbd9-a5cd-11eb-a6af-001c4279bcf3:1-5,
7b2ec017-a62c-11eb-a91d-001c426c932a:1-115
1 row in set (0.00 sec)
```

  

# MySQL高可用集群MHA方案
爱奇艺在用的数据库高可用方案

<!-- OCR_START -->
- InfoQ
- HOT
- 首页
- 直播
- 专题
- 电子书
- 话题
- 免费视频
- 技术博客
- 新闻
- 架构
- 前端
- 编程语言
- 云计算
- AI
- 开源
- 技术管理
- 运维
- 区块链
- 新基建
- 云原生
- 产品
- 爱奇艺MySQL高可用方案概述
- 作者：爱奇艺技术产品..
- 202
- SQL
- 爱奇艺技术产品团队
- QIY
- 技术产品
- 科技赋能娱乐，“码"出快乐生活
- 爱奇艺技术产品团队秉持高效、开放、创新的
- 理念，分享前沿技术，传达爱奇艺生态理念及
- 技术进展。
- 137人关注
- 十关注
- MyS
- TM
<!-- OCR_END -->

MHA 是目前比较成熟及流行的 MySQL 高可用解决方案，很多互联网公司正是直接使用或者基于 MHA 的架构进行改造实现 MySQL 的高可用。

MHA 能在 30 秒内对故障进行转移，并最大程度的保障数据的一致性。MHA 由两个模块组成：Manager 和 Node。

## 什么是MHA
MHA（Master High Availability）目前在MySQL高可用方面是一个相对成熟的解决方案，是一套优秀的作为MySQL高可用性环境下故障切换和主从提升的高可用软件。

MHA作用是保证MySQL主从复制集群中的master高可用性，也就保证整个数据库集群业务不被故障影响。

+ master故障时，MHA会在30s内实现故障自动检测+故障转移
+ 选择一个最优的slave接替为新的master，并且保证new_master和其他slave继续保持数据一致性

高可用性HA、high availability

指的是一个经过设计的系统，能保证减少架构故障时的停工时间，保证业务程序的高度可用性

超哥也在各种运维业务场景下，接触过HA软件

无论是web、数据库、还是后端

## MHA架构
整个MHA软件由两部分角色组成，即MHA Manager（管理节点）和MHA Node（数据节点）。

MHA Manager服务可以独立部署在一台linux机器，也可以部署在某一台主从复制从节点或者其他应用服务器节点上。

而MHA Node服务需要运行在每一个MySQL服务器上。

MHA Manager会定时通过主库上的MHA Node服务监测主库，当master出现故障时，它可以自动将最优slave（可以提前指定或由MHA判定）提升为新的master，然后让所有其他的从库与新的主库重新保持正常的复制状态。

故障的整个切换和转移的过程对客户以及应用程序几乎是完全透明的（也就是用户不会感知到有故障发生）

<!-- OCR_START -->
- MHA
- Manaqes
- 超哥带你学MHA
- 超哥带你学MMA
- Mastes
- Master
- Slave
<!-- OCR_END -->

## MHA工作原理
MHA主要功能

+ master宕机、切换新的master，且保证其他slave和新的master保持一致复制
+ 故障切换过程中，集群数据丢失量最小

一、选择新master

old_master宕机，在集群中选择一个新的slave作为new_master，这要根据MHA的配置，如根据其他slave的binlog位置点，选择最新的slave作为new_master

二、数据补全

进行故障切换、转移之前，必须要进行数据补全，否则即使故障切换了，数据丢了那也是不允许的

**数据补全过程**

+ old_master数据库服务器还可以连接，MHA会SSH连接主库，保存主库所有的binlog
- 若ssh无法连接，放弃主库的binlog数据
+ 以切换好的new_master主库的binlog位置点位基准点，通过relay_log进行数据补全，使得其他所有slave和new_master数据一直
+ 将宕机时从old_master上保存下来的binlog日志（如果存在的话）恢复到所有的数据库节点.

三、角色切换

+ 已选择好的new_master正式提升为主库角色
+ 其他的slave和new_master保持主从复制关系

四、有关master主库IP切换的问题，可以结合keepalived的VIP漂移来实现

## MHA软件包介绍
MHA由2部分组成

Manager节点

Node节点

### Manager节点命令

<!-- OCR_START -->
- Manager节点命令工具
- 功能说明
- masterha_check_ssh
- 用于检查MHA的ssh-key设置是否符合要求
- masterha check repl
- 用于检查MySQL的主从复制情况
- masterha_check_status
- 检测MHA的运行状态
- masterha_manger
- 启动MHA
- masterha master_monitor
- 检测master是否岩机
- masterha_master_switch
- 手动故障转移
- masterha_conf_host
- 手动添加server信息
- masterha_secondary_check
- 从远程服务器建立TCP连接
- masterha_stop
- 停止MHA
<!-- OCR_END -->

### Node命令

<!-- OCR_START -->
- Node节点命令工具
- 功能说明
- save_binary_logs
- 保存并复制岩机的主库的binlog日志数据
- apply_diff_relay_logs
- 对比中继日志的差异，并补全到各个节点
- filter_MySQLbinlog
- 过滤掉无用的回滚事件
- purge_relay_logs
- 清除无用的中继日志
<!-- OCR_END -->

## MHA特点
+ old_master宕机，slave快速切换为new_master
+ 部署MHA与不会对现有的MySQL集群做大量改动
+ MHA——manager功能强大，可以管理上百个节点、多套mysql集群
+ 可以监控mysql状态，隔N秒向master发送ping包，性能不受影响
+ 只要mySQL主从复制支持的存储引擎，MHA也都支持，不限于InnoDB

## MHA部署
2台linux及以上

多个mysql实例之间实现复制

这里超哥准备四台linux机器

master1 10.211.55.12 MHA-node

Slave1 10.211.55.9 MHA-node

Slave2 10.211.55.11 MHA-node，MHA-Manager

Client 10.211.55.18 空

注意时间同步

```plain
ntpdate -u ntp.aliyun.com
```

 

### 准备好一主两从-GTID
MHA需要支持一主多从架构，至少三台数据库，三台机器，基于GTID的主从复制，三个配置文件，仅有server-id不同

一个master

一个备用master

一个slave

<!-- OCR_START -->
- 超哥带你学MHA
- Master
- 10.211.55.12
- Slave1
- Slave2
- 10.211.55.9
- 10.211.55.11
<!-- OCR_END -->

额外配置my.cnf

```plain
relay_log_purge = 0              #<==不自动删除relay log，以便于宕机后修复数据。
log-bin=/mm_data/3306/mysql-bin   #<==从库开启binlog，以便于宕机
                                            后修复数据。
expire_logs_days = 7             #<==自动删除7天前的binlog。
log-slave-updates = 1            #<==从库开启Binlog，以便于宕机后修复数据。
```

### master基础配置
My.cnf

```plain
[client]
socket=/mm_data/3306/mysql.sock

[mysqld]
socket=/mm_data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/mm_data/3306/data
log-bin=/mm_data/3306/mysql-bin
character-set-server=utf8

server-id=12
expire-logs-days=1
binlog_format=row
gtid_mode=on
enforce_gtid_consistency=1
log_slave_updates=1

[mysqld_safe]
log-error=/mm_data/3306/mysql_3306_error.log
pid-file=/mm_data/3306/mysqld_3306.pid
sql_mode=NO_ENGINE_SUBSTITUTION,STRTICT_TRANS_TABLES
```

数据目录

```plain
[root@mysql-server56 tools]# /mm_data/3306/mysql_3306 restart
Restarting MySQL...
Stoping MySQL...
Starting MySQL...
[root@mysql-server56 tools]# ls /mm_data/3306/
data  my.cnf  mysql_3306  mysql_3306_error.log  mysql-bin.000001  mysql-bin.000002  mysql-bin.index  mysqld_3306.pid  mysql.sock
[root@mysql-server56 tools]#
[root@mysql-server56 tools]# netstat -tunlp|grep mysql
tcp6       0      0 :::3306                 :::*                    LISTEN      11040/mysqld
[root@mysql-server56 tools]#
```

主库信息

```plain
mysql> show master status\G
*************************** 1. row ***************************
             File: mysql-bin.000002
         Position: 151
     Binlog_Do_DB:
 Binlog_Ignore_DB:
Executed_Gtid_Set:
1 row in set (0.00 sec)

mysql>

mysql> show slave status;
Empty set (0.00 sec)

mysql>
```

创建复制账号

```plain
mysql> grant replication slave on *.* to 'repl_chaoge'@'10.211.55.%' identified by 'chaoge668';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

mysql>
```

数据导出

```plain
[root@mysql-server56 3306]# mysqldump -S /mm_data/3306/mysql.sock  -A -B -x --set-gtid-purged=OFF|gzip > /mm_data/m1_alldb_$(date +%F).sql.gz

```

数据发给所有slave  

```plain
[root@mysql-server56 tools]# scp -rp /mm_data/m1_alldb_2021-04-27.sql.gz root@10.211.55.9:/mm_data/
m1_alldb_2021-04-27.sql.gz                                                                                                                     100%  177KB  28.6MB/s   00:00

[root@mysql-server56 tools]# scp -rp /mm_data/m1_alldb_2021-04-27.sql.gz root@10.211.55.11:/mm_data/
m1_alldb_2021-04-27.sql.gz                                                                                                                     100%  177KB  38.5MB/s   00:00
[root@mysql-server56 tools]#
```

查看GTID信息

```plain
mysql> show global variables like '%gtid%';
+---------------------------------+------------------------------------------+
| Variable_name                   | Value                                    |
+---------------------------------+------------------------------------------+
| binlog_gtid_simple_recovery     | OFF                                      |
| enforce_gtid_consistency        | ON                                       |
| gtid_executed                   | 20bdbbd9-a5cd-11eb-a6af-001c4279bcf3:1-5 |
| gtid_mode                       | ON                                       |
| gtid_owned                      |                                          |
| gtid_purged                     |                                          |
| simplified_binlog_gtid_recovery | OFF                                      |
+---------------------------------+------------------------------------------+
7 rows in set (0.00 sec)

mysql>

mysql> show global variables like 'server%';
+----------------+--------------------------------------+
| Variable_name  | Value                                |
+----------------+--------------------------------------+
| server_id      | 12                                   |
| server_id_bits | 32                                   |
| server_uuid    | 20bdbbd9-a5cd-11eb-a6af-001c4279bcf3 |
+----------------+--------------------------------------+
3 rows in set (0.00 sec)
```

### slave1~10.211.55.9~基础配置
my.cnf server-id=9  

```plain
[client]
socket=/mm_data/3306/mysql.sock

[mysqld]
socket=/mm_data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/mm_data/3306/data
log-bin=/mm_data/3306/mysql-bin
character-set-server=utf8

server-id=9
expire-logs-days=1
binlog_format=row
gtid_mode=on
enforce_gtid_consistency=1
log_slave_updates=1

[mysqld_safe]
log-error=/mm_data/3306/mysql_3306_error.log
pid-file=/mm_data/3306/mysqld_3306.pid
sql_mode=NO_ENGINE_SUBSTITUTION,STRTICT_TRANS_TABLES
```

导入master数据

```plain
[root@chaoge_slave1 3306]# zcat /mm_data/m1_alldb_2021-04-27.sql.gz |mysql -S /mm_data/3306/mysql.sock

[root@chaoge_slave1 3306]# ./mysql_3306 restart
Restarting MySQL...
Stoping MySQL...
Starting MySQL...
[root@chaoge_slave1 3306]# ls
data  my.cnf  mysql_3306  mysql_3306_error.log  mysql-bin.000001  mysql-bin.index  mysqld_3306.pid  mysql.sock
[root@chaoge_slave1 3306]#
```

授权master-info

```plain
mysql> change master to
    -> master_host='10.211.55.12',
    -> master_port=3306,
    -> master_user='repl_chaoge',
    -> master_password='chaoge668',
    -> master_auto_position=1;
Query OK, 0 rows affected, 2 warnings (0.00 sec)
```

启动slave

```plain
mysql> start slave;

mysql> show slave status\G

mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.211.55.12
                  Master_User: repl_chaoge
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 644733
               Relay_Log_File: mysqld_3306-relay-bin.000002
                Relay_Log_Pos: 408
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
```

### slave2~10.211.55.11~基础配置
my.cnf

server-id=11  

```plain
[client]
socket=/mm_data/3306/mysql.sock

[mysqld]
socket=/mm_data/3306/mysql.sock
basedir=/application/mysql-5.6.40-linux-glibc2.12-x86_64/
datadir=/mm_data/3306/data
log-bin=/mm_data/3306/mysql-bin
character-set-server=utf8

server-id=11
expire-logs-days=1
binlog_format=row
gtid_mode=on
enforce_gtid_consistency=1
log_slave_updates=1

[mysqld_safe]
log-error=/mm_data/3306/mysql_3306_error.log
pid-file=/mm_data/3306/mysqld_3306.pid
sql_mode=NO_ENGINE_SUBSTITUTION,STRTICT_TRANS_TABLES
```

导入master数据

```plain
[root@chaoge_slave2 3306]# zcat /mm_data/m1_alldb_2021-04-27.sql.gz |mysql -S /mm_data/3306/mysql.sock
[root@chaoge_slave2 3306]# ./mysql_3306 restart
Restarting MySQL...
Stoping MySQL...
Starting MySQL...
[root@chaoge_slave2 3306]# ls
data    mysql_3306            mysql-bin.000001  mysql-bin.000003  mysqld_3306.pid
my.cnf  mysql_3306_error.log  mysql-bin.000002  mysql-bin.index   mysql.sock
[root@chaoge_slave2 3306]#
```

授权master-info

```plain
change master to
master_host='10.211.55.12',
master_port=3306,
master_user='repl_chaoge',
master_password='chaoge668',
master_auto_position=1;
```

启动slave

```plain
mysql> start slave;

mysql> show slave status\G
```

  

## 主从结果

<!-- OCR_START -->
- root@mysql-server56:/mm_data/3306
- 81
- 91%
- 13%
- 显10GB
- 4/27, 16:45
- 8yuchao
- QERROR104
- root@chaoge_slave2:/mm_data/3306 (ssh)
- root@chaoge_slave1:/mm_data/3306 (ssh)
- mysql>
- performance_schema
- test
- 5 rows in set (0.o0 sec)
- mysql> show databases;
- Database
- information_schema |
- kings
- lol_chaoge
- 6 rows in set (0.00 sec)
- create database lol_chaoge;
- 6 rows in set (0.01 sec)
- Query OK， 1 row affected (0.00 sec)
<!-- OCR_END -->

主从结果是正常的

## SSH免密登录
MHA_Manager管理节点是通过ssh服务连接其他node节点进行探测、以及获取数据，必须提前做好ssh免密连接

最终结果就是，四台机器，可以任意ssh免密互相登录，包括机器本身  

```plain
# 生成公私钥
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa > /dev/null 2>&1

# 传输公钥
ssh-copy-id -i ~/.ssh/id_dsa.pub 10.211.55.9
ssh-copy-id -i ~/.ssh/id_dsa.pub 10.211.55.11
ssh-copy-id -i ~/.ssh/id_dsa.pub 10.211.55.12
ssh-copy-id -i ~/.ssh/id_dsa.pub 10.211.55.18
```

  

## 所有节点依赖安装
所有节点，安装MHA基础依赖

配置好yum源  

```plain
yum install -y perl-DBD-MySQL \
perl-Config-Tiny \
perl-Log-Dispatch \
perl-Parallel-ForkManager \
perl-ExtUtils-CBuilder \
perl-ExtUtils-MakeMaker \
perl-CPAN
```

## 所有mysql节点安装MHA-node
安装rpm包  

```plain
wget --no-check-certificate https://qiniu.wsfnk.com/mha4mysql-node-0.58-0.el7.centos.noarch.rpm

rpm -ivh mha4mysql-node-0.58-0.el7.centos.noarch.rpm
```

检查rpm安装出的命令

```plain
[root@chaoge_slave1 tools]# ls -l /usr/bin/*_*log*
-rwxr-xr-x  1 root root 17639 Mar 23  2018 /usr/bin/apply_diff_relay_logs
-rwxr-xr-x  1 root root 15704 Aug  9  2019 /usr/bin/db_log_verify
-rwxr-xr-x  1 root root 33032 Aug  9  2019 /usr/bin/db_printlog
-rwxr-xr-x  1 root root  4807 Mar 23  2018 /usr/bin/filter_mysqlbinlog
-rwxr-xr-x  1 root root  8337 Mar 23  2018 /usr/bin/purge_relay_logs
-rwxr-xr-x  1 root root  7525 Mar 23  2018 /usr/bin/save_binary_logs
-rwxr-xr-x. 1 root root  7910 Aug  4  2017 /usr/bin/scsi_logging_level
-rwxr-xr-x. 1 root root 94696 Aug  4  2017 /usr/bin/sg_logs
```

MHA工具会检测mysql命令，这里还需要加一个软连接

```plain
# 三台mysql节点，都执行该命令
ln -s /application/mysql-5.6.40-linux-glibc2.12-x86_64/bin/mysqlbinlog /usr/bin/mysqlbinlog
```

所有节点，创建MHA管理账号，三台机器都操作  

```plain
mysql> grant all privileges on *.* to mha@'10.211.55.%' identified by 'mha_chaoge';
Query OK, 0 rows affected (0.00 sec)

mysql>
```

## MHA-Manager管理节点
MHA管理节点可以装在任何节点，超哥这里就给安装到了slave02 节点

因为Manager管理节点，通过ssh检测mysql集群，如果master节点服务器宕机，或者网络故障，MHA也无法完成故障切换了。

因此mha-manager不能装在master节点  

```plain
wget --no-check-certificate https://qiniu.wsfnk.com/mha4mysql-manager-0.58-0.el7.centos.noarch.rpm

[root@chaoge_slave2 tools]# ls mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
[root@chaoge_slave2 tools]#
```

安装管理节点的依赖

```plain
yum install -y perl-Config-Tiny epel-release perl-Log-Dispatch perl-Parallel-ForkManager perl-Time-HiRes

```

安装MHA-Manager的包

```plain
[root@chaoge_slave2 tools]# rpm -ivh mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
Preparing...                          ################################# [100%]
Updating / installing...
   1:mha4mysql-manager-0.58-0.el7.cent################################# [100%]
[root@chaoge_slave2 tools]#
```

### 检查mha-manager的命令(slave2机器)
```plain
[root@chaoge_slave2 tools]# ls -l /usr/bin/masterha_*
-rwxr-xr-x 1 root root 1995 Mar 23  2018 /usr/bin/masterha_check_repl
-rwxr-xr-x 1 root root 1779 Mar 23  2018 /usr/bin/masterha_check_ssh
-rwxr-xr-x 1 root root 1865 Mar 23  2018 /usr/bin/masterha_check_status
-rwxr-xr-x 1 root root 3201 Mar 23  2018 /usr/bin/masterha_conf_host
-rwxr-xr-x 1 root root 2517 Mar 23  2018 /usr/bin/masterha_manager
-rwxr-xr-x 1 root root 2165 Mar 23  2018 /usr/bin/masterha_master_monitor
-rwxr-xr-x 1 root root 2373 Mar 23  2018 /usr/bin/masterha_master_switch
-rwxr-xr-x 1 root root 5172 Mar 23  2018 /usr/bin/masterha_secondary_check
-rwxr-xr-x 1 root root 1739 Mar 23  2018 /usr/bin/masterha_stop
[root@chaoge_slave2 tools]#
```

### 创建MHA配置文件
基础信息如下，这里不需要操作  
  

```plain
**主从账密**

mysql> grant replication slave on *.* to 'repl_chaoge'@'10.211.55.%' identified by 'chaoge668';

**MHA账密**

mysql> grant all privileges on *.* to mha@'10.211.55.%' identified by 'mha_chaoge';
Query OK, 0 rows affected (0.00 sec)

# 一定记住，刷新用户表
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

**主机host信息**，所有机器都做好/etc/hosts解析

10.211.55.11 chaoge_slave2   ,mha-manager安装在这里

10.211.55.9 chaoge_slave1 

10.211.55.12 mysql-server56  ，如果master挂了，需要其他slave去检测
```

注释版

```plain
[root@chaoge_slave2 tools]# mkdir -p /etc/mha           #<==在/etc下创建mha目录。
[root@chaoge_slave2 tools]# mkdir -p /var/log/mha/app1  #<==在/etc下创建mha目录。
[root@chaoge_slave2 tools]# vim /etc/mha/app1.cnf       #<==编辑mha配置文件，增加配置内容。

[server default]                           #<==默认模块标签。
manager_log=/var/log/mha/app1/manager.log  #<==配置日志路径。
manager_workdir=/var/log/mha/app1.log      #<==配置工作日志路径。
master_binlog_dir=/mm_data/3306/data/      #<==配置MHA保存主库binlog日志的路径。
user=mha                                   #<==MySQL数据中授权的用户。
password=mha_chaoge                               #<==MySQL数据中授权的用户。
ping_interval=2                       #<==设置监控主库发送ping数据包的时间间隔，
                                       若尝试三次没有回应则自动进行failover。
repl_user=repl_chaoge                              #<==主从复制对应的用户。
repl_password=chaoge668                    #<==主从复制用户对应的密码。
ssh_user=root                              #<==ssh远程连接服务器的用户。
report_script=/usr/local/send_report       #<==设置故障发生切换后触发执行的脚本。
secondary_check_script=/usr/local/bin/masterha_secondary_check -s 10.211.55.9  -s 10.211.55.11  --user=root --master_host=mysql-server56 --master_ip=10.211.55.12 --master_port=3306
#<==当MHA Manager节点到MASTER节点（mysql-server56）的监控之间出现问题时，MHA Manager将会尝试从其他路径登录到MASTER（mysql-server56）节点。
#<==注：此配置在MHA Manager节点只有单独一台机器时起作用。意思就是，在Manager节点联系不上Master时，通过两个从节点（chaoge_slave1 、chaoge_slave2）去探视Master（mysql-server56）节点的状态。

shutdown_script="" #<==设置故障发生后执行主机脚本关闭故障机（防止故障机活过来发生脑裂）
[server1]                                  #<==第一个mysql-master主机模块标签。
hostname=10.211.55.12                         #<==第一个mysql-master主机IP。
port=3306                                  #<==第一个mysql主机端口。

[server2]
hostname=10.211.55.11
port=3306
candidate_master=1           #<==设定此参数后，server2标签的主机，将优先作为主库，宕机的候选服务器（切换主库优先选择）。
check_repl_delay=0  #<==设定此参数后，MHA会忽略主从复制延迟，将此服务器作为后选主机。

[server3]
hostname=10.211.55.9
port=3306
```

最终版配置文件

```plain
[root@chaoge_slave2 tools]# mkdir -p /etc/mha
[root@chaoge_slave2 tools]# mkdir -p /var/log/mha/app1
[root@chaoge_slave2 tools]#

# 配置文件如下
[server default]
manager_log=/var/log/mha/app1/manager.log
manager_workdir=/var/log/mha/app1.log
master_binlog_dir=/mm_data/3306/data/
# 该脚本暂时先注释
#master_ip_failover_script=/usr/local/bin/master_ip_failover
user=mha
password=mha_chaoge
ping_interval=2
repl_user=repl_chaoge
repl_password=chaoge668
ssh_user=root
shutdown_script=""

[server1]
candidate_master=1
check_repl_delay=0
hostname=10.211.55.12
port=3306

[server2]
hostname=10.211.55.11
port=3306
candidate_master=1
check_repl_delay=0

[server3]
hostname=10.211.55.9
port=3306
```

自愈检测脚本

```plain
#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Getopt::Long;

my (
    $command,          $ssh_user,        $orig_master_host, $orig_master_ip,
    $orig_master_port, $new_master_host, $new_master_ip,    $new_master_port
);

my $vip = '';
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
}
sub stop_vip() {
     return 0  unless  ($ssh_user);
    `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip \"`;
}

sub usage {
    print
    "Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}
```

  

## 预备启动MHA
检测如下MHA运行条件

+ SSH免密登录
+ MySQL主从复制

### 检测SSH登录
如下结果表明服务器之间的SSH免密登录没有问题  
  

```plain
[root@chaoge_slave2 tools]# masterha_check_ssh --conf=/etc/mha/app1.conf
Tue Apr 27 15:06:51 2021 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Tue Apr 27 15:06:51 2021 - [info] Reading application default configuration from /etc/mha/app1.conf..
Tue Apr 27 15:06:51 2021 - [info] Reading server configuration from /etc/mha/app1.conf..
Tue Apr 27 15:06:51 2021 - [info] Starting SSH connection tests..
Tue Apr 27 15:06:52 2021 - [debug]
Tue Apr 27 15:06:51 2021 - [debug]  Connecting via SSH from root@10.211.55.12(10.211.55.12:22) to root@10.211.55.11(10.211.55.11:22)..
Tue Apr 27 15:06:51 2021 - [debug]   ok.
Tue Apr 27 15:06:51 2021 - [debug]  Connecting via SSH from root@10.211.55.12(10.211.55.12:22) to root@10.211.55.9(10.211.55.9:22)..
Tue Apr 27 15:06:51 2021 - [debug]   ok.
Tue Apr 27 15:06:52 2021 - [debug]
Tue Apr 27 15:06:51 2021 - [debug]  Connecting via SSH from root@10.211.55.11(10.211.55.11:22) to root@10.211.55.12(10.211.55.12:22)..
Tue Apr 27 15:06:51 2021 - [debug]   ok.
Tue Apr 27 15:06:51 2021 - [debug]  Connecting via SSH from root@10.211.55.11(10.211.55.11:22) to root@10.211.55.9(10.211.55.9:22)..
Tue Apr 27 15:06:52 2021 - [debug]   ok.
Tue Apr 27 15:06:53 2021 - [debug]
Tue Apr 27 15:06:52 2021 - [debug]  Connecting via SSH from root@10.211.55.9(10.211.55.9:22) to root@10.211.55.12(10.211.55.12:22)..
Tue Apr 27 15:06:52 2021 - [debug]   ok.
Tue Apr 27 15:06:52 2021 - [debug]  Connecting via SSH from root@10.211.55.9(10.211.55.9:22) to root@10.211.55.11(10.211.55.11:22)..
Tue Apr 27 15:06:52 2021 - [debug]   ok.
Tue Apr 27 15:06:53 2021 - [info] All SSH connection tests passed successfully.
[root@chaoge_slave2 tools]#
```

### 检测主从复制情况
MHA也提供了主从复制检测  

```plain
[root@chaoge_slave2 3306]# masterha_check_repl --conf=/etc/mha/app1.conf
Tue Apr 27 16:54:50 2021 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Tue Apr 27 16:54:50 2021 - [info] Reading application default configuration from /etc/mha/app1.conf..
Tue Apr 27 16:54:50 2021 - [info] Reading server configuration from /etc/mha/app1.conf..
Tue Apr 27 16:54:50 2021 - [info] MHA::MasterMonitor version 0.58.
Tue Apr 27 16:54:51 2021 - [info] GTID failover mode = 1
Tue Apr 27 16:54:51 2021 - [info] Dead Servers:
Tue Apr 27 16:54:51 2021 - [info] Alive Servers:
Tue Apr 27 16:54:51 2021 - [info]   10.211.55.12(10.211.55.12:3306)
Tue Apr 27 16:54:51 2021 - [info]   10.211.55.11(10.211.55.11:3306)
Tue Apr 27 16:54:51 2021 - [info]   10.211.55.9(10.211.55.9:3306)
Tue Apr 27 16:54:51 2021 - [info] Alive Slaves:
Tue Apr 27 16:54:51 2021 - [info]   10.211.55.11(10.211.55.11:3306)  Version=5.6.40-log (oldest major version between slaves) log-bin:enabled
Tue Apr 27 16:54:51 2021 - [info]     GTID ON
Tue Apr 27 16:54:51 2021 - [info]     Replicating from 10.211.55.12(10.211.55.12:3306)
Tue Apr 27 16:54:51 2021 - [info]     Primary candidate for the new Master (candidate_master is set)
Tue Apr 27 16:54:51 2021 - [info]   10.211.55.9(10.211.55.9:3306)  Version=5.6.40-log (oldest major version between slaves) log-bin:enabled
Tue Apr 27 16:54:51 2021 - [info]     GTID ON
Tue Apr 27 16:54:51 2021 - [info]     Replicating from 10.211.55.12(10.211.55.12:3306)
Tue Apr 27 16:54:51 2021 - [info] Current Alive Master: 10.211.55.12(10.211.55.12:3306)
Tue Apr 27 16:54:51 2021 - [info] Checking slave configurations..
Tue Apr 27 16:54:51 2021 - [info]  read_only=1 is not set on slave 10.211.55.11(10.211.55.11:3306).
Tue Apr 27 16:54:51 2021 - [info]  read_only=1 is not set on slave 10.211.55.9(10.211.55.9:3306).
Tue Apr 27 16:54:51 2021 - [info] Checking replication filtering settings..
Tue Apr 27 16:54:51 2021 - [info]  binlog_do_db= , binlog_ignore_db=
Tue Apr 27 16:54:51 2021 - [info]  Replication filtering check ok.
Tue Apr 27 16:54:51 2021 - [info] GTID (with auto-pos) is supported. Skipping all SSH and Node package checking.
Tue Apr 27 16:54:51 2021 - [info] Checking SSH publickey authentication settings on the current master..
Tue Apr 27 16:54:51 2021 - [info] HealthCheck: SSH to 10.211.55.12 is reachable.
Tue Apr 27 16:54:51 2021 - [info]
10.211.55.12(10.211.55.12:3306) (current master)
 +--10.211.55.11(10.211.55.11:3306)
 +--10.211.55.9(10.211.55.9:3306)

Tue Apr 27 16:54:51 2021 - [info] Checking replication health on 10.211.55.11..
Tue Apr 27 16:54:51 2021 - [info]  ok.
Tue Apr 27 16:54:51 2021 - [info] Checking replication health on 10.211.55.9..
Tue Apr 27 16:54:51 2021 - [info]  ok.
Tue Apr 27 16:54:51 2021 - [warning] master_ip_failover_script is not defined.
Tue Apr 27 16:54:51 2021 - [warning] shutdown_script is not defined.
Tue Apr 27 16:54:51 2021 - [info] Got exit code 0 (Not master dead).

MySQL Replication Health is OK.
[root@chaoge_slave2 3306]#
```

### 结果总结
结果必须和超哥一样，全都是info级别的日志信息，而不得有error日志

并且提示mysql replication health is OK，表示复制检查正常。  

## 配置VIP漂移
上面超哥是临时关闭了VIP的漂移脚本  

```plain
# 该脚本暂时先注释
#master_ip_failover_script=/usr/local/bin/master_ip_failover
```

这个作用是当master发生故障，迁移后数据库IP发生变化，解决这个问题，因此得使用VIP进行漂移

MHA已经提供好了perl脚本

我们只需要创建VIP即可，首先在master节点上创建

```plain
# 创建
[root@mysql-server56 3306]# ifconfig eth0:1 10.211.55.77/24

# 删除
[root@mysql-server56 3306]# ifconfig eth0:1 del 10.211.55.77/24

# 关闭
[root@mysql-server56 3306]# ifconfig eth0:1 down
```

### 使用vip脚本
脚本代码

master_ip_failover_script=/usr/local/bin/master_ip_failover

如下

vim /usr/local/bin/master_ip_failover

给与执行权限

chmod +x /usr/local/bin/master_ip_failover

```plain
#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Getopt::Long;

my (
    $command,          $ssh_user,        $orig_master_host, $orig_master_ip,
    $orig_master_port, $new_master_host, $new_master_ip,    $new_master_port
);

my $vip = '10.211.55.77/24';
my $key = '1';
my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down";

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
}
sub stop_vip() {
     return 0  unless  ($ssh_user);
    `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vip \"`;
}

sub usage {
    print
    "Usage: master_ip_failover --command=start|stop|stopssh|status --orig_master_host=host --orig_master_ip=ip --orig_master_port=port --new_master_host=host --new_master_ip=ip --new_master_port=port\n";
}
```

### 再次检测MHA程序
```plain
[root@chaoge_slave2 3306]# masterha_check_repl --conf=/etc/mha/app1.conf
Tue Apr 27 17:29:19 2021 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Tue Apr 27 17:29:19 2021 - [info] Reading application default configuration from /etc/mha/app1.conf..
Tue Apr 27 17:29:19 2021 - [info] Reading server configuration from /etc/mha/app1.conf..
Tue Apr 27 17:29:19 2021 - [info] MHA::MasterMonitor version 0.58.
Tue Apr 27 17:29:20 2021 - [info] GTID failover mode = 1
Tue Apr 27 17:29:20 2021 - [info] Dead Servers:
Tue Apr 27 17:29:20 2021 - [info] Alive Servers:
Tue Apr 27 17:29:20 2021 - [info]   10.211.55.12(10.211.55.12:3306)
Tue Apr 27 17:29:20 2021 - [info]   10.211.55.11(10.211.55.11:3306)
Tue Apr 27 17:29:20 2021 - [info]   10.211.55.9(10.211.55.9:3306)
Tue Apr 27 17:29:20 2021 - [info] Alive Slaves:
Tue Apr 27 17:29:20 2021 - [info]   10.211.55.11(10.211.55.11:3306)  Version=5.6.40-log (oldest major version between slaves) log-bin:enabled
Tue Apr 27 17:29:20 2021 - [info]     GTID ON
Tue Apr 27 17:29:20 2021 - [info]     Replicating from 10.211.55.12(10.211.55.12:3306)
Tue Apr 27 17:29:20 2021 - [info]     Primary candidate for the new Master (candidate_master is set)
Tue Apr 27 17:29:20 2021 - [info]   10.211.55.9(10.211.55.9:3306)  Version=5.6.40-log (oldest major version between slaves) log-bin:enabled
Tue Apr 27 17:29:20 2021 - [info]     GTID ON
Tue Apr 27 17:29:20 2021 - [info]     Replicating from 10.211.55.12(10.211.55.12:3306)
Tue Apr 27 17:29:20 2021 - [info] Current Alive Master: 10.211.55.12(10.211.55.12:3306)
Tue Apr 27 17:29:20 2021 - [info] Checking slave configurations..
Tue Apr 27 17:29:20 2021 - [info]  read_only=1 is not set on slave 10.211.55.11(10.211.55.11:3306).
Tue Apr 27 17:29:20 2021 - [info]  read_only=1 is not set on slave 10.211.55.9(10.211.55.9:3306).
Tue Apr 27 17:29:20 2021 - [info] Checking replication filtering settings..
Tue Apr 27 17:29:20 2021 - [info]  binlog_do_db= , binlog_ignore_db=
Tue Apr 27 17:29:20 2021 - [info]  Replication filtering check ok.
Tue Apr 27 17:29:20 2021 - [info] GTID (with auto-pos) is supported. Skipping all SSH and Node package checking.
Tue Apr 27 17:29:20 2021 - [info] Checking SSH publickey authentication settings on the current master..
Tue Apr 27 17:29:20 2021 - [info] HealthCheck: SSH to 10.211.55.12 is reachable.
Tue Apr 27 17:29:20 2021 - [info]
10.211.55.12(10.211.55.12:3306) (current master)
 +--10.211.55.11(10.211.55.11:3306)
 +--10.211.55.9(10.211.55.9:3306)

Tue Apr 27 17:29:20 2021 - [info] Checking replication health on 10.211.55.11..
Tue Apr 27 17:29:20 2021 - [info]  ok.
Tue Apr 27 17:29:20 2021 - [info] Checking replication health on 10.211.55.9..
Tue Apr 27 17:29:20 2021 - [info]  ok.
Tue Apr 27 17:29:20 2021 - [info] Checking master_ip_failover_script status:
Tue Apr 27 17:29:20 2021 - [info]   /usr/local/bin/master_ip_failover --command=status --ssh_user=root --orig_master_host=10.211.55.12 --orig_master_ip=10.211.55.12 --orig_master_port=3306

IN SCRIPT TEST====/sbin/ifconfig eth1:1 down==/sbin/ifconfig eth1:1 10.211.55.77/24===

Checking the Status of the script.. OK
Tue Apr 27 17:29:20 2021 - [info]  OK.
Tue Apr 27 17:29:20 2021 - [warning] shutdown_script is not defined.
Tue Apr 27 17:29:20 2021 - [info] Got exit code 0 (Not master dead).

MySQL Replication Health is OK.
```

一切OK，启动MHA

  
 

## 启动MHA
在MHA的manager节点，启动MHA进程  

```plain
nohup masterha_manager --conf=/etc/mha/app1.conf --ignore_last_failover /var/log/mha/app1/manager.log 2>&1 &

命令参数：
--remove_dead_master_conf       该参数代表当发生主从切换后，老的主库的ip将会从配置文件中移除。
--manger_log                    日志存放位置
--ignore_last_failover          在缺省情况下，如果MHA检测到连续发生宕机，且两次宕机间隔不足8小时的话，则不会进行Failover，之所以这样限制是为了避免ping-pong效应。该参数代表忽略上次MHA触发切换产生的文件，默认情况下，MHA发生切换后会在日志目录，也就是上面设置的manager_workdir目录中产生app1.failover.complete文件，下次再次切换的时候如果发现该目录下存在该文件将不允许触发切换，除非在第一次切换后收到删除该文件，为了方便，这里设置为--ignore_last_failover。

# 停止命令
masterha_stop --conf=/etc/mha/app1.conf
```

运行命令，检测日志

```plain
[root@chaoge_slave2 3306]# nohup masterha_manager --conf=/etc/mha/app1.conf --ignore_last_failover /var/log/mha/app1/manager.log 2>&1 &
[1] 31466
[root@chaoge_slave2 3306]# nohup: ignoring input and appending output to ‘nohup.out’

[root@chaoge_slave2 3306]# ps -ef|grep master
root     31466 25629  2 17:33 pts/0    00:00:00 perl /usr/bin/masterha_manager --conf=/etc/mha/app1.conf --ignore_last_failover /var/log/mha/app1/manager.log
root     31488 25629  0 17:33 pts/0    00:00:00 grep --color=auto master
[root@chaoge_slave2 3306]# tail -f /var/log/mha/app1/manager.log

IN SCRIPT TEST====/sbin/ifconfig eth1:1 down==/sbin/ifconfig eth1:1 10.211.55.77/24===

Checking the Status of the script.. OK
Tue Apr 27 17:33:36 2021 - [info]  OK.
Tue Apr 27 17:33:36 2021 - [warning] shutdown_script is not defined.
Tue Apr 27 17:33:36 2021 - [info] Set master ping interval 2 seconds.
Tue Apr 27 17:33:36 2021 - [warning] secondary_check_script is not defined. It is highly recommended setting it to check master reachability from two or more routes.
Tue Apr 27 17:33:36 2021 - [info] Starting ping health check on 10.211.55.12(10.211.55.12:3306)..
Tue Apr 27 17:33:36 2021 - [info] Ping(SELECT) succeeded, waiting until MySQL doesn't respond..
```

### 检测MHA状态
检测mysql主从集群的状态  

```plain
[root@chaoge_slave2 ~]# masterha_check_status --conf=/etc/mha/app1.conf
app1 (pid:31466) is running(0:PING_OK), master:10.211.55.12
```

检查VIP当前在哪，在当前的mysql-master机器

```plain
[root@mysql-server56 3306]# ifconfig  eth0:1
eth0:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.211.55.77  netmask 255.255.255.0  broadcast 10.211.55.255
        ether 00:1c:42:79:bc:f3  txqueuelen 1000  (Ethernet)

[root@mysql-server56 3306]#
```

第一次进行VIP脚本自动切换，VIP必须在master机器上

### 停止master主库
查看结果

+ master切换
+ VIP切换

```plain
[root@mysql-server56 3306]# /mm_data/3306/mysql_3306 stop
Stoping MySQL...
```

  

## 见证MHA漂移结果

<!-- OCR_START -->
11%
10G8
12 kB+△
0.0 kB 4/27,18:13
8yuchao
Ov vin
52021
Tue Apr 27 18:12:56
[info]
E 1 11
6 2021 -[info]
Resetting slave info on the new master.
hyte
m1
ue Apr 27 18:12:56
10.211.55.11:Resetting slave info
Master failover to 10.211.55.11(10.211.55.11:3306) completed successfully.
Tue Apr 27 18:12:56 2021 -[info]
rtt min/avg/
Failover Report
goge_slave1 3306]#
app1: MySQL Master failover 10.211.55.12(10.211.55.12:3306) to 10.211.55.11(10.211.55.11:3306) succeeded
enewmailin/var/spool/mail/root
33067#
Master 10.211.55.12(10.211.55.12:3306) is down!
_sl
3306]#
Check MHA Manager logs at chaoge_slave2:/var/log/mha/app1/manager.log for details.
306]
Started automgted(non-interactive)failover.
MHA脚本自动故障迁移
30
help"
mysth-is
63306]#
try "iphelp"
etho
inet6f
：0:3892:1b1e:mo
VIP也漂移到这台机器了
Xpacke
k255.255.25
10.211.55.255
aedrcoliss
inet10.211.55.77netmask 255.255.255.0
padcast 10.211.55.255
ether 00:1c:42:79:bc:f3txqueuelen 1000(Ethernet)
5633063
m_data/3306/mycql_3306
TX errors 0 dropped 0overruns @carrier 0collisions 0
e335#/mmdat/336/mysql_3306stop
Master主库挂掉
[rootechaoge_slave2 ~]#
Stoping MySQL
[rootemysql-server56 3306]#
<!-- OCR_END -->

最终发生了如下变化

+ MHA软件在切换后会自动停止进程
+ VIP发生漂移
+ 主从复制关系发生变化

slave01机器，主从角色发生变化

```plain
[root@chaoge_slave1 3306]# mysql -S /mm_data/3306/mysql.sock
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 28
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.211.55.11
                  Master_User: repl_chaoge
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000003
          Read_Master_Log_Pos: 1929
               Relay_Log_File: mysqld_3306-relay-bin.000003
                Relay_Log_Pos: 1405
        Relay_Master_Log_File: mysql-bin.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
```

slave01机器，已经没有slave的角色，成为了主库

```plain
[root@chaoge_slave2 ~]# mysql -S /mm_data/3306/mysql.sock
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 29
Server version: 5.6.40-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show slave status\G
Empty set (0.00 sec)

mysql>
```

完成MHA故障切换

# MySQL中间件
## 什么是中间件
中间件的定义：将具体业务和底层逻辑解耦的软件。

之前看过一个很生动的例子：我要开一家炸鸡店（业务端），需要鸡肉，有很多养鸡场（底层），我需要一个一个比较价钱，然后找一家性价比高的养鸡场合作（适配不同底层逻辑）。可能一段时间后，我需要重新选一家养鸡场合作，进货方式、交易方式等要重新制定（重新适配）。

这一套事情太复杂了，于是我找到了一个专门整合养鸡场的第三方代理（中间件），跟他谈好价格和质量后（统一接口），以后我就只需要给代理钱，然后拿肉就行。具体这个第三方代理怎么操作，我不用管。

数据库中间件

理解了什么是中间件，什么是数据库中间件就好理解了吧，

尝试着按照大白话描述：“数据库中间件是一个软件，他可以让上层的软件对数据库做一些操作，而不用去知道是怎么实现的”。

例如mycat这个数据库中间件工具，提供了很多方便，方便我们对mysql集群的管理

## 为什么用中间件
首先数据库技术发展的基础还是在业务推动的背景下，能够实现相关的技术保障。

业务需求的提升必然会在数据量，访问量等方面有更高的要求，而映射到数据库层面就不是简单的扩容和添加资源了，我们有时候更需要弹性，需要快速实现，需要更高的性能。

背景

早期的很多数据库，从一主一从，一主多从的架构，逐步演变到了读写分离，分库分表，然后就是分布式。

MySQL的中间件其实有很多，官方的、开源的。

MySQL中间件到底能干什么?

首先我们要明确数据库会出现的性能瓶颈问题

+ 单台服务器无法承载访问压力
+ 数据库单张表容量过大
+ 频繁、大量的读、写、需求无法平衡，数据库压力大
+ 服务器资源扩容，应用改变较大

<!-- OCR_START -->
- 超哥带你学MyCa+
- Cobar
- 阿里团队开发
- Mycat
- 基于阿里团队的coba-二次开发，由社区维护
- 中间件
- 4+las
- 360团队基于mysaleroxy开发
- MaxScale
- 超哥带你学My
- Marad开发的中间件，支持读写分离
- MySaL Route
- MySaL官方团队开发的中间件
<!-- OCR_END -->

cobar中间件已经通过阿里双11等业务，大规模的场景验证，性能强悍

## 中间件工具介绍
## Atlas
**360 Atlas**

这是国内360公司推出的一个中间件方案，github地址为：[https://github.com/Qihoo360/Atlas](https://github.com/Qihoo360/Atlas)

从github的情况来看，星级蛮高，最新的维护是在4天前。它的设计是在mysql-proxy 0.8.2版本的基础上，对其进行了优化，增加了一些新的功能特性。

但是已经停止更新很久了，停在了centos6时代

<!-- OCR_START -->
Search or jump to...
Pull requests Issues Marketplace
eExplore
Qiho0360/Atlas
545
☆Star
4.5k
Fork
<> Code
① Issues 173
” Pull requests  2
Actions
Projects
wiki
Security
Insights
Installing Atlas
Edit
NewP
TristanSu edited thispage on 22Oct 2015·6revisions
1. Install Atlas in Redhat/Centos (recommended)
Pages16
Find a Page...
Download the latestversionof theRPMpackagefromhttps://github.com/Qihoo360/Atlas/releases,and then run
Home
sudo rpm -i Atlas-XX.e16.x86_64.rpm
Atlas Sharding
Atlas功能特点FAQ
notes:
Atlas的分表功能简介
1. Atlas only run in 64-bit systems.
Atlas的安装
2. Mysql version should be greater than 5.1, it is recommended to useMysql 5.6.
3. When you install the rpm package, Atlas will be installed in the directory:/usr/local/mysql-proxy.
Atlas的开源历程（2013年）
Atlas的性能测试
2.InstallAtlasinDebian/Ubuntu
Atlas的架构
Atlas的运行及常见问题
dpkg -i Atlas-XX-debian6.0-x86_64.deb
Atlas部分配置参数及原理详解
3. Modify the configuration file
json配置部分参数说明
TheArchitectureOfAtlas
Atlasrunwithaconfigurationfile(test.cnf).BeforerunningAtlas,thefileneedstobeconfigured.Thedefault
installation directory of Atlas is /usr/local/mysql-proxy, enter /usr/local/mysql-proxy/conf, you can see that there
TheFAQsaboutthemain
featuresofAtlas
isa defaultconfigurationfilenamed test.cnf,weonlyneedtomodifysomeconfigurationoptionsinside,not
needtorewriteaconfigurationfilefromscratch.
The FAQs Of Running Atlas
<!-- OCR_END -->

## MyCat
国内非常热火的中间件，官网

[http://www.mycat.org.cn/](http://www.mycat.org.cn/)

还有一本Mycat相关的书《分布式数据库架构及企业实践——基于Mycat中间件》

mycat功能非常强大、需要学习的内容也很多，未来在工作场景下，可以针对性的深入学习

数据库中间件，mycat

+ 一个彻底开源的，面向企业应用开发的大数据库集
+ 支持事务、ACID、可以替代MySQL的加强版数据库
+ 一个可以视为MySQL集群的企业级数据库，用来替代昂贵的Oracle集群
+ 一个融合内存缓存技术、NoSQL技术、HDFS大数据的新型SQL Server
+ 结合传统数据库和新型分布式数据仓库的新一代企业级数据库产品
+ 一个新颖的数据库中间件产品

用来干什么

+ 用于支持海量数据存储，对海量数据进行分库分表
+ 支持分库分表场景下的分布式事务
+ 对多个数据源进行统一整合
+ 高并发应用场景下，降低请求对单个数据库节点带来的灾难性压力
+ 可以通过数据库中间间层面实现数据库读写分离，使其Java程序与数据库访问解耦

## MyCat介绍
MyCat是一个开源的分布式数据库系统，是一个实现了MySQL协议的服务器，前端用户可以把它看作是一个数据库代理**（类似于Mysql Proxy）**，用MySQL客户端工具和命令行访问，而其后端可以用MySQL原生协议与多个MySQL服务器通信，也可以用JDBC协议与大多数主流数据库服务器通信，其核心功能是分表分库，即将一个大表水平分割为N个小表，存储在后端MySQL服务器里或者其他数据库里。

MyCat发展到目前的版本，已经不是一个单纯的MySQL代理了，它的后端可以支持MySQL、SQL Server、Oracle、DB2、PostgreSQL等主流数据库，也支持MongoDB这种新型NoSQL方式的存储，未来还会支持更多类型的存储。

而在最终用户看来，无论是那种存储方式，在MyCat里，都是一个传统的数据库表，支持标准的SQL语句进行数据的操作，这样一来，对前端业务系统来说，可以大幅降低开发难度，提升开发速度。

**Mycat可以简单概括为** - 一个彻底开源的，面向企业应用开发的大数据库集群 - 支持事务、ACID、可以替代MySQL的加强版数据库 - 一个可以视为MySQL集群的企业级数据库，用来替代昂贵的Oracle集群 - 一个融合内存缓存技术、NoSQL技术、HDFS大数据的新型SQL Server - 结合传统数据库和新型分布式数据仓库的新一代企业级数据库产品 - 一个新颖的数据库中间件产品

**Mycat关键特性** - 支持SQL92标准 - 遵守Mysql原生协议，跨语言，跨平台，跨数据库的通用中间件代理 - 基于心跳的自动故障切换，支持读写分离，支持MySQL主从，以及galera cluster集群 - 支持Galera for MySQL集群，Percona Cluster或者MariaDB cluster - 基于Nio实现，有效管理线程，高并发问题 - 支持数据的多片自动路由与聚合，支持sum,count,max等常用的聚合函数,支持跨库分页 - 支持单库内部任意join，支持跨库2表join，甚至基于caltlet的多表join - 支持通过全局表，ER关系的分片策略，实现了高效的多表join查询 - 支持多租户方案 - 支持分布式事务（弱xa） - 支持全局序列号，解决分布式下的主键生成问题 - 分片规则丰富，插件化开发，易于扩展 - 强大的web，命令行监控 - 支持前端作为mysq通用代理，后端JDBC方式支持Oracle、DB2、SQL Server 、 mongodb 、巨杉 - 支持密码加密 - 支持服务降级 - 支持IP白名单 - 支持SQL黑名单、sql注入攻击拦截 - 支持分表（1.6） - 集群基于ZooKeeper管理，在线升级，扩容，智能优化，大数据处理（2.0开发版）

## mycat工作原理
Mycat的原理并不复杂，复杂的是代码。Mycat的原理中最重要的一个动词是“**拦截**”，它拦截了用户发送过来的SQL语句，首先对SQL语句做了一些特定的分析：

如分片分析、路由分析、读写分离分析、缓存分析等，然后将此SQL发往后端的真实数据库，并将返回的结果做适当的处理，最终再返回给用户。

使用mycat之前

<!-- OCR_START -->
- 应用程序、直接连接mysal
- 超哥带你学mysal
- 复制
- 后端应用
- 代码
<!-- OCR_END -->

使用mycat中间件之后

mycat可以实现主从复制的高可用

当某一个master挂掉之后，mycat能够迁移一个slave继续进行读写操作

<!-- OCR_START -->
- MycoA
- write
- read
- keepalived
- Mycat
- MysaL-slave
<!-- OCR_END -->

MyCat不存储数据，只是管理mysql数据库，数据存储在mysql里

## 部署Mycat
Mycat实现Mysql主从复制，其中写操作在master主节点上执行，包括insert，delete，update 语句操作；

读操作在slave节点上执行，只有select语句操作，其他操作均由主master的二进制文件决定；

MyCat支持双主多从，多主多从情况需要配置多个writeHost兄弟节点，多个readHost节点即可！

Mycat的架构其实很好理解，Mycat是数据库代理中间件，Mycat后面就是物理数据库。和Web服务器的Nginx类似。

对于使用者来说，访问的都是Mycat，不会接触到后端的数据库。

### 环境准备
三台服务器

| **ip** | **hostname** | **介绍** |
| --- | --- | --- |
| 10.211.55.9 | chaoge_slave1 | 从数据库，安装mysql-slave |
| 10.211.55.12 | chaoge_master1 | 主数据库，安装mysql-master |
| 10.211.55.11 | chaoge_mycat1 | 安装mycat |

### Mysql环境初始化
防火墙关闭，三台机器  
 

```plain
[root@chaoge_mycat1 ~]# iptables -F
[root@chaoge_mycat1 ~]# systemctl stop firewalld
[root@chaoge_mycat1 ~]# getenforce
Disabled
[root@chaoge_mycat1 ~]# systemctl disable firewalld
[root@chaoge_mycat1 ~]#
```

hosts解析

```plain
[root@chaoge_mycat1 ~]# tail -3 /etc/hosts
10.211.55.9 chaoge_slave1
10.211.55.12 chaoge_master1
10.211.55.11 chaoge_mycat1
```

时间同步

```plain
ntpdate -u ntp.aliyun.com

```

### 配置主从复制关系
chaoge_master1机器  

```plain
[root@chaoge_master1 ~]# mysql -S /mm_data/3306/mysql.sock -e 'show master status'
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000001 |      598 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
[root@chaoge_master1 ~]#
```

Chaoge_slave1机器

```plain
[root@chaoge_slave1 ~]# mysql -S /mm_data/3306/mysql.sock -e 'show slave status\G'
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.211.55.12
                  Master_User: repl_chaoge
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000001
          Read_Master_Log_Pos: 598
               Relay_Log_File: mysqld_3306-relay-bin.000002
                Relay_Log_Pos: 283
        Relay_Master_Log_File: mysql-bin.000001
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
```

测试数据同步正常与否

```plain
# master写入
[root@chaoge_master1 ~]# mysql -S /mm_data/3306/mysql.sock -e 'create database kings'
[root@chaoge_master1 ~]#

# slave检测
[root@chaoge_slave1 ~]# mysql -S /mm_data/3306/mysql.sock -e 'show databases' |grep kings
kings

# master创建数据库
mysql> CREATE  DATABASE chaoge_mycat CHARACTER SET utf8 COLLATE utf8_general_ci;   

# slave应该是有的
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| chaoge_mycat       |
| kings              |
| mysql              |
| performance_schema |
| test               |
+--------------------+
6 rows in set (0.00 sec)

mysql>

# 在master创建数据表
mysql> use chaoge_mycat;
Database changed
mysql> create table if not exists chaoge_tb(id int(10) primary key auto_increment, name varchar(50) not null);
Query OK, 0 rows affected (0.04 sec)

mysql>

# 在slave检查数据表
mysql> desc  chaoge_mycat.chaoge_tb;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| id    | int(10)     | NO   | PRI | NULL    | auto_increment |
| name  | varchar(50) | NO   |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)

mysql>

# 在master插入数据
insert into chaoge_mycat.chaoge_tb values(1,'pyyu'),(2,'cc');

# 在slave检查数据
mysql> select * from chaoge_mycat.chaoge_tb;
+----+------+
| id | name |
+----+------+
|  1 | pyyu |
|  2 | cc   |
+----+------+
2 rows in set (0.00 sec)

# 2台机器都创建登录用户
mysql> grant all privileges on *.* to 'root'@'10.211.55.%' identified by '123456';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

  
  
可以看到master，slave复制正常

## MyCat部署流程
部署的顺序是

+ 下载、解压mycat
+ 安装java环境jdk
+ 创建mycat运行账号
+ 配置PATH
+ 修改mycat配置文件

### 安装djk
环境安装，mycat是java开发的，安装java环境  

```plain
[root@chaoge_mycat1 conf]# yum install java -y

[root@chaoge_mycat1 bin]# java -version
openjdk version "1.8.0_292"
OpenJDK Runtime Environment (build 1.8.0_292-b10)
OpenJDK 64-Bit Server VM (build 25.292-b10, mixed mode)
```

### 下载mycat
官网可以找到github的下载地址

[http://dl.mycat.org.cn/1.6.7.4/Mycat-server-1.6.7.4-release/](http://dl.mycat.org.cn/1.6.7.4/Mycat-server-1.6.7.4-release/)

```plain
[root@chaoge_mycat1 tools]# wget http://dl.mycat.org.cn/1.6.7.4/Mycat-server-1.6.7.4-release/Mycat-server-1.6.7.4-release-20200105164103-linux.tar.gz

[root@chaoge_mycat1 mycat]# mkdir -p /mysql_data
[root@chaoge_mycat1 tools]# tar -zxf Mycat-server-1.6.7.4-release-20200105164103-linux.tar.gz -C /mysql_data/
[root@chaoge_mycat1 tools]#
[root@chaoge_mycat1 tools]# cd /mysql_data/
[root@chaoge_mycat1 mysql_data]# ls
[root@chaoge_mycat1 mysql_data]# ls
mycat

[root@chaoge_mycat1 mycat]# pwd
/mysql_data/mycat
[root@chaoge_mycat1 mycat]# tree -L 1
.
├── bin                # mycat命令行
├── catlet        # 一个扩展功能
├── conf          # 配置文件
├── lib                # mycat是java开发的，lib下是jar包
├── logs          # 日志文件
└── version.txt

5 directories, 1 file
```

### 添加PATH
```plain
[root@chaoge_mycat1 bin]# tail -1 /etc/profile
export PATH=/mysql_data/mycat/bin:/application/mysql-5.6.40-linux-glibc2.12-x86_64/bin:$PATH
[root@chaoge_mycat1 bin]#
```

### 测试启动mycat
```plain
[root@chaoge_mycat1 mycat]# mycat start
Starting Mycat-server...

# 进程、端口存在
[root@chaoge_mycat1 mycat]# ps -ef|grep mycat |grep -v grep|wc -l
2

# 查看日志
[root@chaoge_mycat1 mycat]# tail /mysql_data/mycat/logs/wrapper.log
STATUS | wrapper  | 2021/04/27 16:51:57 | --> Wrapper Started as Daemon
STATUS | wrapper  | 2021/04/27 16:51:58 | Launching a JVM...
INFO   | jvm 1    | 2021/04/27 16:51:58 | Wrapper (Version 3.2.3) http://wrapper.tanukisoftware.org
INFO   | jvm 1    | 2021/04/27 16:51:58 |   Copyright 1999-2006 Tanuki Software, Inc.  All Rights Reserved.
INFO   | jvm 1    | 2021/04/27 16:51:58 |
INFO   | jvm 1    | 2021/04/27 16:51:59 | MyCAT Server startup successfully. see logs in logs/mycat.log
[root@chaoge_mycat1 mycat]#
```

### 可以登录mycat
```plain
[root@chaoge_mycat1 mycat]# mysql -h10.211.55.11 -uroot -P8066 -p123456
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.29-mycat-1.6.7.4-release-20200105164103 MyCat Server (OpenCloudDB)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
# 默认存在一个TESTDB逻辑库
mysql> select user();
+-------------------+
| USER()            |
+-------------------+
| root@10.211.55.11 |
+-------------------+
1 row in set (0.00 sec)

mysql> select database();
+------------+
| DATABASE() |
+------------+
| NULL       |
+------------+
1 row in set (0.00 sec)

mysql> show databases;
+----------+
| DATABASE |
+----------+
| TESTDB   |
+----------+
1 row in set (0.00 sec)
```

### 学习MyCat基本元素
mycat使用起来，需要先知道，它的各种配置文件

以及各种配置文件的元素，否则会一头雾水

#### 逻辑库schema
+ 相当于mysql的数据库、但是只是一个虚拟的数据库，也叫做逻辑库
+ 一个逻辑库可以对应多个后端mysql的物理数据库
+ mycat的逻辑库，不保存数据，数据存在mysql
+ 应用程序可以访问逻辑库，然后访问到mysql的数据库（就是一个代理）

<!-- OCR_START -->
- 数据库
- mysal
- 千超老师
- mysal database
- 代码
- 应用程序
- myca+逻辑库
<!-- OCR_END -->

#### 逻辑表
+ 存储在逻辑库中的逻辑表
+ 可以理解为，mysql的database和table的关系
+ 逻辑表可以对应后端多个物理库中的表
+ 逻辑表也不存储数据

<!-- OCR_START -->
- mysal 数据库
- mysaltablei
- 代码
- 逻辑表
- mycat
- 应用程序
- table
- mysal
- 于超老师
- Ltable3
<!-- OCR_END -->

## 配置文件mycat
```plain
[root@chaoge_mycat1 mycat]# pwd
/mysql_data/mycat

[root@chaoge_mycat1 mycat]# ls -l  conf/*.xml
-rwxrwxrwx 1 root root  446 Oct 22  2019 conf/ehcache.xml
-rwxrwxrwx 1 root root 1285 Oct 22  2019 conf/log4j2.xml
-rwxrwxrwx 1 root root 5423 Oct 22  2019 conf/rule.xml        # mycat分库分表规则
-rwxrwxrwx 1 root root 3080 Dec 30  2019 conf/schema.xml  # mycat对应的数据库、表
-rwxrwxrwx 1 root root 6392 Dec 30  2019 conf/server.xml # mycat配置文件信息
[root@chaoge_mycat1 mycat]#
```

配置文件的关系

<!-- OCR_START -->
- Mycat
- servesxml
- Application
- log4jd.xml
- >logfile
- Schema.xml
- Mrule.xml
- 于超老师
- Database
<!-- OCR_END -->

### server.xml
**schema.xml是最主要的配置项，此文件关联mysql读写分离策略！读写分离、分库分表策略、分片节点都是在此文件中配置的！**

MyCat作为中间件，它只是一个代理，本身并不进行数据存储，需要连接后端的MySQL物理服务器

此文件就是用来连接MySQL服务器的！

这里解释下mycat主配置文件，主要作用是

+ 配置mycat系统相关参数
+ 配置用户访问权限
+ 配置SQL防火墙、SQL拦截功能等

```plain
[root@chaoge_mycat1 mycat]# cp conf/server.xml{,.bak}
[root@chaoge_mycat1 mycat]# ls -l conf/server.xml*
-rwxrwxrwx 1 root root 6392 Dec 30  2019 conf/server.xml
-rwxr-xr-x 1 root root 6392 Apr 27 14:31 conf/server.xml.bak
```

### xml语法
之前于超老师讲过tomcat的配置文件，大家是接触过xml数据文件的

```plain
<system>
  <property name="${key}"> ${value} </property>
</system>

<!-->例如端口定义 </--> 
<system>
  <property name="serverPort"> 3306 </property>
</system>
```

### mycat本身系统配置
比如有关mycat系统本身的配置，如修改mycat的运行端口，启动账号密码

```plain
11 <mycat:server xmlns:mycat="http://io.mycat/">
 12         <system>
 13         <property name="nonePasswordLogin">0</property> <!-- 0为需要密码登陆、1为不需要密码登陆 ,默认为0，设置为1则需要指定默认账户-->
 14         <property name="ignoreUnknownCommand">0</property><!-- 0遇上没有实现的报文(Unknown command:),就会报错、1为忽略该报文，返回ok报文。
 15         在某些mysql客户端存在客户端已经登录的时候还会继续发送登录报文,mycat会报错,该设置可以绕过这个错误-->
 16         <property name="useHandshakeV10">1</property>
 17     <property name="removeGraveAccent">1</property>
 18         <property name="useSqlStat">0</property>  <!-- 1为开启实时统计、0为关闭 -->
 19         <property name="useGlobleTableCheck">0</property>  <!-- 1为开启全加班一致性检测、0为关闭 -->
 20                 <property name="sqlExecuteTimeout">300</property>  <!-- SQL 执行超时 单位:秒-->
 21                 <property name="sequnceHandlerType">1</property>

--------
45                         <property name="serverPort">8066</property> <property name="managerPort">9066</property>
46                         <property name="idleTimeout">300000</property> <property name="bindIp">0.0.0.0</property>
47                         <property name="dataNodeIdleCheckPeriod">300000</property> 5 * 60 * 1000L; //连接空闲检查
48                         <property name="frontWriteQueueSize">4096</property> <property name="processors">32</property> -->
```

### mycat访问权限配置
user标签定义权限设置

/mysql_data/mycat/conf/server.xml 部分配置如下

```plain
# 可以理解，mycat就是一个数据库，是可以登录的
# mycat里面的一个虚拟数据库，名字是，TESTDB（逻辑库）
# user标签用于定义mycat的用户，能够访问哪些数据库
108         <user name="root" defaultAccount="true">
109                 <property name="password">123456</property>
                                        # 这个用户对多个数据库授权
110                 <property name="schemas">TESTDB,db1,db2,db3</property>
111                 <property name="defaultSchema">TESTDB</property>
112                 <!--No MyCAT Database selected 错误前会尝试使用该schema作为schema，不设置则为null,报错 -->
113
114                 <!-- 表级 DML 权限设置 -->
115                 # 这里是user的子标签
                                        # 控制mycat的用户，对数据库下的表，具体的访问权限
                                        # check属性表示，是否启用权限
116                 <privileges check="false">
                                                        # 上面对root用户设置了可以访问多个逻辑库
                                                        # 这里可以再细化权限
                                                        # 选择某一个逻辑库，再处理里面的逻辑表
                                                        # dml属性是定义权限，这里不定义会用schema默认权限
                                                        # 这个数字权限表示的是
                                                        # 依次是 insert,update,select,delete
                                                        # 如果都有权限，就是1111

117                         <schema name="TESTDB" dml="0110" >
118                                 <table name="tb01" dml="0000"></table>
119                                 <table name="tb02" dml="1111"></table>
120                         </schema>
121                 </privileges>
122                  -->
123         </user>
124                    
                        # 这里是第二个用户的配置
                       <!-- 配置用户信息，这个user表示和用户有关配置 --> 
125         <user name="yuchao">
126                 <property name="password">user</property>
127                 <property name="schemas">TESTDB</property>
                                        # 设置这个user用户是只读的权限，只能查询
128                 <property name="readOnly">true</property>
129                 <property name="defaultSchema">TESTDB</property>
130         </user>
131
132 </mycat:server>
```

对上述xml配置解释

```plain
重点关注上面这段配置，其他默认即可。

=======================================
参数           说明
user          用户配置节点
name          登录的用户名，也就是连接Mycat的用户名。
password      登录的密码，也就是连接Mycat的密码
schemas       数据库名，这里会和schema.xml中的配置关联，多个用逗号分开，例如需要这个用户需要管理两个数据库db1,db2，则配置db1,dbs
privileges    配置用户针对表的增删改查的权限
readOnly      mycat逻辑库所具有的权限。true为只读，false为读写都有，默认为false。

=======================================
上述的账号、密码自己创建、修改xml即可

我这里配置了一个账号root，密码为123456 ,逻辑数据库为TESTDB，这些信息都可以自己随意定义,读写权限都有，没有针对表做任何特殊的权限。

- server.xml文件里登录mycat的用户名和密码可以任意定义，这个账号和密码是为客户机登录mycat时使用的账号信息。

- 逻辑库名(如上面的TESTDB，也就是登录TESTDB后显示的库名，切换这个库之后，显示的就是代理的真实mysql数据库的表)要在schema.xml里面也定义，否则会导致mycat服务启动失败！

- 这里只定义了一个标签，所以把多余的都注释了。如果定义多个标签，即设置多个连接TESTDB的用户名和密码，那么就需要在schema.xml文件中定义多个对应的库！
```

## schema.xml
**schema.xml是最主要的配置项，此文件关联mysql读写分离策略！读写分离、分库分表策略、分片节点都是在此文件中配置的！**

schema.xml文件作用

+ 配置mycat的逻辑库、逻辑表
+ 配置逻辑表存储的数据节点
+ 配置数据节点对应的物理数据库服务器信息

### 语法
```plain
# name定义逻辑库的名字
# sqlMaxLimit限制每次sql执行结果，返回的行数

<schema name="yuchao_db" checkSQLschema="false" sqlMaxLimit="1000">

</schema>

# name定义逻辑表名字
# primarykey定义逻辑表主键
# dataNode 逻辑表数据，存储在那个物理节点，可以插入多个
<table name="chaoge_tb" primaryKey="id" dataNode="db01,db02"   />

# name定义数据节点的名称，必须唯一
# dataHost定义服务器地址
# database 定义物理数据库名字
<dataNode name="dn1" dataHost="localhost1" database="db1" />
<dataNode name="dn2" dataHost="localhost1" database="db2" />
<dataNode name="dn3" dataHost="localhost1" database="db3" />

# 定义后端数据库主机信息
# balance 负载均衡的方式，分别有0，1，2，3 不同的机制选择
# writeType 负载均衡类型，也有0，1，2选项
<dataHost name="localhost1" maxCon="1000" minCon="10" balance="0"
          writeType="0" dbType="mysql" dbDriver="native" switchType="1"  slaveThreshold="100">
  <heartbeat>select user()</heartbeat>
  <!-- can have multi write hosts -->
  <writeHost host="hostM1" url="localhost:3306" user="root"
             password="123456">
  </writeHost>
  <!-- <writeHost host="hostM2" url="localhost:3316" user="root" password="123456"/> -->
</dataHost>
```

有关的配置

<!-- OCR_START -->
- <dataHost>
- <writeHost/
- <readHost/>
- slave
- master
- 于超老师
<!-- OCR_END -->

### schema.xml参数详解
schemaxml文件中配置的参数解释  

```plain
schema     数据库设置，此数据库为逻辑数据库 name与server.xml中schema对应
dataNode    分片信息，也就是分库相关配置
dataHost    物理数据库，真正存储数据的数据库
```

配置说明

```plain
name属性唯一标识dataHost标签，供上层的标签使用。
maxCon属性指定每个读写实例连接池的最大连接。也就是说，标签内嵌套的
writeHost、readHost标签都会使用这个属性的值来实例化出连接池的最大连接数。
minCon属性指定每个读写实例连接池的最小连接，初始化连接池的大小。
```

每个节点的属性逐一说明

```plain
schema:
属性       说明
name        逻辑数据库名，与server.xml中的schema对应
checkSQLschema   数据库前缀相关设置，建议看文档，这里暂时设为folse
sqlMaxLimit  select时默认的limit，避免查询全表
```

table

```plain
属性       说明
name       表名，物理数据库中表名
dataNode    表存储到哪些节点，多个节点用逗号分隔。节点为下文dataNode设置name
primaryKey   主键字段名，自动生成主键时需要设置
autoIncrement   是否自增
rule        分片规则名，具体规则下文rule详细介绍
```

  
dataNode

```plain
属性       说明
name        节点名，与table中dataNode对应
datahost    物理数据库名，与datahost中name对应
database    物理数据库中数据库名
```

  
dataHost

```plain
属性       说明
name        物理数据库名，与dataNode中dataHost对应
balance      均衡负载的方式
writeType   写入方式
dbType       数据库类型
heartbeat   心跳检测语句，注意语句结尾的分号要加
```

### 负载均衡参数解释
schema.xml文件中有三点需要注意：balance="1"，writeType="0" ,switchType="1"

schema.xml中的balance的取值决定了负载均衡对非事务内的读操作的处理。balance 属性负载均衡类型，目前的取值有 4 种：  

```plain
balance="0"：     
不开启读写分离机制，所有读操作都发送到当前可用的writeHost 上,即读请求仅发送到writeHost上。

balance="1"：      
读请求随机分发到当前writeHost对应的readHost和standby的writeHost上。即全部的readHost与stand by writeHost 参与select 语句的负载均衡，简单的说，当双主双从模式(M1 ->S1 ， M2->S2，并且 M1 与 M2 互为主备)，正常情况下， M2,S1,S2 都参与 select 语句的负载均衡

balance="2"：      
读请求随机分发到当前dataHost内所有的writeHost和readHost上。即所有读操作都随机的在writeHost、 readhost 上分发。

balance="3"：      
读请求随机分发到当前writeHost对应的readHost上。即所有读请求随机的分发到 wiriterHost 对应的 readhost 执行,writerHost 不负担读压力，注意 balance=3 只在 1.4 及其以后版本有，1.3 没有。
```

writeType 属性，负载均衡类型，目前的取值有 3 种

```plain
writeType="0"   所有写操作发送到配置的第一个 writeHost，第一个挂了切到还生存的第二个writeHost，重新启动后已切换后的为准，切换记录在配置文件中:dnindex.properties .
writeType="1"   所有写操作都随机的发送到配置的 writeHost。
writeType="2"   没实现。
```

对于事务内的SQL默认走写节点

```plain
以 /*balance*/ 开头，可以指定SQL使用特定负载均衡方案。例如在大环境开启读写分离的情况下，特定强一致性的SQL查询需求；

slaveThreshold：近似的主从延迟时间（秒）Seconds_Behind_Master < slaveThreshold ，读请求才会分发到该Slave，确保读到的数据相对较新。

schema.xml中的writeType的取值决定了负载均衡对写操作的处理：
writeType="0"：所有的写操作都发送到配置文件中的第一个write host。（第一个write host故障切换到第二个后，即使之后修复了仍然维持第二个为写库）。推荐取0值，不建议修改.
```

主从切换（双主failover）：**switchType 属性**

```plain
如果细心观察schem.xml文件的话，会发现有一个参数：
switchType，如下配置：
 <dataHost name="237_15" maxCon="1000" minCon="10" balance="1" writeType="0" dbType="mysql" dbDriver="native"switchType="1"  slaveThreshold="100">

参数解读
switchType="-1"：  不自动切换
switchType="1"：   默认值，自动切换
switchType="2"：   基于MySQL主从同步的状态来决定是否切换。需修改heartbeat语句（即心跳语句）：show slave status
switchType="3"：   基于Mysql Galera Cluster（集群多节点复制）的切换机制。需修改heartbeat语句（即心跳语句）：show status like 'wsrep%'
```

dbType属性

```plain
指定后端连接的数据库类型，目前支持二进制的mysql协议，还有其他使用JDBC连接的数据库。例如：mongodb、oracle、spark等。

```

dbDriver属性指定连接后端数据库使用的

```plain
Driver，目前可选的值有native和JDBC。

使用native的话，因为这个值执行的是二进制的mysql协议，所以可以使用mysql和maridb。
其他类型的数据库则需要使用JDBC驱动来支持。从1.6版本开始支持postgresql的native原始协议。

如果使用JDBC的话需要将符合JDBC 4标准的驱动JAR包放到MYCAT\lib目录下，并检查驱动JAR包中包括如下目录结构的文件：
META-INF\services\java.sql.Driver。在这个文件内写上具体的Driver类名，例如：com.mysql.jdbc.Driver。
```

heartbeat标签

```plain
这个标签内指明用于和后端数据库进行心跳检查的语句。例如,MYSQL可以使用select user()，Oracle可以使用select 1 from dual等。
这个标签还有一个connectionInitSql属性，主要是当使用Oracla数据库时，需要执行的初始化SQL

语句就这个放到这里面来。例如：altersession set nls_date_format='yyyy-mm-dd hh24:mi:ss'

1.4主从切换的语句必须是：showslave status
```

writeHost标签、readHost标签

```plain
这两个标签都指定后端数据库的相关配置给mycat，用于实例化后端连接池。

唯一不同的是：writeHost指定写实例、readHost指定读实例，组着这些读写实例来满足系统的要求。

在一个dataHost内可以定义多个writeHost和readHost。但是，如果writeHost指定的后端数据库宕机，那么这个writeHost绑定的所有readHost都将不可用。

另一方面，由于这个writeHost宕机系统会自动的检测到，并切换到备用的writeHost上去。
```

## Mycat读写分离、主从自动切换
目前有大量Mycat的生产实践案例是属于简单的读写分离类型的，此案例主要用到Mycat的以下特性：

+ 读写分离支持
+ 高可用

大多数读写分离的案例是同时支持高可用性的，即Mycat+MySQL主从复制的集群，并开启Mycat的读写分离功能，这种场景需求下，Mycat是最为简单并且功能最为丰富的一类Proxy

正常情况下，配置文件也最为简单，不用每个表配置，只需要在schema.xml中的元素上增加dataNode=“defaultDN”属性，并配置此dataNode对应的真实物理数据库的database，然后dataHost开启读写分离功能即可。

修改配置文件的顺序

+ 逻辑库，schema
+ 数据节点，datanode
+ 数据主机，datahost，write，read

### 修改server.xml
和schema.xml对应  

```plain
        -->

        <user name="root" defaultAccount="true">
                <property name="password">123456</property>
                <property name="schemas">mycat</property>
                <property name="defaultSchema">mycat</property>
                <!--No MyCAT Database selected 错误前会尝试使用该schema作为schema，不设置则为null,>报错 -->

                <!-- 表级 DML 权限设置 -->
                <!--
                <privileges check="false">
                        <schema name="TESTDB" dml="0110" >
                                <table name="tb01" dml="0000"></table>
                                <table name="tb02" dml="1111"></table>
                        </schema>
                </privileges>
                 -->
        </user>
</mycat:server>
```

  

### 修改schema.xml
balance为1：让全部的readHost及备用的writeHost参与select的负载均衡。

switchType为2：基于MySQL主从同步的状态决定是否切换。

heartbeat：主从切换的心跳语句必须为show slave status。

**仅仅进行读写分离的schema.xml配置（备份原来的schema.xml文件，清空，直接复制下面内容）：**

**不想要自动切换功能，即MySQL写节点宕机后不自动切换到备用节点：**  

```plain
[root@chaoge_mycat1 conf]# cp schema.xml{,.bak}
[root@chaoge_mycat1 conf]# ls -l schema.xml*
-rwxrwxrwx 1 root root 3080 Dec 30  2019 schema.xml
-rwxr-xr-x 1 root root 3080 Apr 27 15:29 schema.xml.bak
```

填入如下配置

主机解析关系  

```plain
# 超哥的配置
[root@chaoge_mycat1 ~]# tail -3 /etc/hosts
10.211.55.9 chaoge_slave1
10.211.55.12 chaoge_master1
10.211.55.11 chaoge_mycat1
```

确保这里的配置，是你机器当前的环境

```plain
<?xml version="1.0"?>
<!DOCTYPE mycat:schema SYSTEM "schema.dtd">
<mycat:schema xmlns:mycat="http://io.mycat/">

        <schema name="mycat" checkSQLschema="false" sqlMaxLimit="100" dataNode="haha">
        </schema>

<dataNode name="haha" dataHost="chaoge_mycat1" database="chaoge_mycat" />

    <dataHost name="chaoge_mycat1" maxCon="1000" minCon="10" balance="1" writeType="0" dbType="mysql" dbDriver="native" switchType="1"  slaveThreshold="100">
        <heartbeat>show slave status</heartbeat>
        <writeHost host="chaoge_master1" url="10.211.55.12:3306" user="root" password="123456">
             <readHost host="chaoge_slave1" url="10.211.55.9:3306" user="root" password="123456">
             </readHost>
        </writeHost>
        <writeHost host="chaoge_slave1" url="10.211.55.9:3306" user="root" password="123456">
        </writeHost>
    </dataHost>

</mycat:schema>
```

### 重启mycat
```plain
[root@chaoge_mycat1 conf]# mycat restart
Stopping Mycat-server...
Mycat-server was not running.
Starting Mycat-server...

# 日志
[root@chaoge_mycat1 ~]# tail -f /mysql_data/mycat/logs/wrapper.log

STATUS | wrapper  | 2021/04/28 20:45:10 | --> Wrapper Started as Daemon
STATUS | wrapper  | 2021/04/28 20:45:10 | Launching a JVM...
INFO   | jvm 1    | 2021/04/28 20:45:11 | Wrapper (Version 3.2.3) http://wrapper.tanukisoftware.org
INFO   | jvm 1    | 2021/04/28 20:45:11 |   Copyright 1999-2006 Tanuki Software, Inc.  All Rights Reserved.
INFO   | jvm 1    | 2021/04/28 20:45:11 |
INFO   | jvm 1    | 2021/04/28 20:45:12 | MyCAT Server startup successfully. see logs in logs/mycat.log
```

### mycat管理命令
```plain
./mycat start      #开启
./mycat stop       #关闭
./mycat restart    #重启
./mycat status     #查看启动状态
./mycat console    #前台运行
./mycat pause      #暂停

[root@chaoge_mycat1 conf]# mycat status
Mycat-server is running (9574).
```

  
到这里mycat正确启动、配置好了

## 远程登录mycat中间件
可以准备一个client，登录mycat，登录mysql

mycat远程登录的配置，在server.xml

于超老师这里用 slave1这台机器登录  

```plain
[root@chaoge_slave1 ~]# mysql -h10.211.55.11 -P8066 -uroot -p123456
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.6.29-mycat-1.6.7.4-release-20200105164103 MyCat Server (OpenCloudDB)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# 看到一个mycat的逻辑库
mysql> show databases;
+----------+
| DATABASE |
+----------+
| mycat    |
+----------+
1 row in set (0.00 sec)

# 通过逻辑库mycat，看到了我们后端数据库的，数据表，chaoge_tb
mysql> show tables;
+------------------------+
| Tables_in_chaoge_mycat |
+------------------------+
| chaoge_tb              |
+------------------------+
1 row in set (0.00 sec)

# 查看mysql后端数据库，数据
mysql> select * from chaoge_tb;
+----+------+
| id | name |
+----+------+
|  1 | pyyu |
|  2 | cc   |
+----+------+
2 rows in set (0.01 sec)

# 查看当前数据库信息
mysql> select version();
+---------------------------------------------+
| VERSION()                                   |
+---------------------------------------------+
| 5.6.29-mycat-1.6.7.4-release-20200105164103 |
+---------------------------------------------+
1 row in set (0.00 sec)
```

### 读写分离测试
将mycat的日志输出级别改完debug（默认是info级别），在conf/log4j2.xml里配置，然后去查询去添加数据在/logs/mycat.log日志文件里查看sql被路由到了  

```plain
# vim log4j2.xml 修改
       <asyncRoot level="debug" includeLocation="true">

# 重启mycat
[root@chaoge_mycat1 conf]# mycat restart
Stopping Mycat-server...
Stopped Mycat-server.
Starting Mycat-server...
[root@chaoge_mycat1 conf]# mycat status
Mycat-server is running (10465).
[root@chaoge_mycat1 conf]#
```

用client登录mycat

执行SQL语句，查看日志，请求被发给了哪个mysql机器执行  

```plain
[root@chaoge_slave1 ~]# mysql -h10.211.55.11 -P8066 -uroot -p123456

mysql> use mycat;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from chaoge_tb;
+----+------+
| id | name |
+----+------+
|  1 | pyyu |
|  2 | cc   |
+----+------+
2 rows in set (0.00 sec)
```

### 插入数据，查看mycat代理的机器
```plain
mysql> use mycat;

insert into chaoge_tb values(3,"alex");
```

### 图解过程
数据写入，发给了master机器执行

<!-- OCR_START -->
root@chaoge_mycat1:/mysql_data/mycat/conf
100%
6%
12GB
2.1 kB↓ A~AL_ 1.0 kB↑ |  4/28, 21:07
8 yuchao
口~
|Q debug
× root@chaoge_mycat:/mysql_data/mycat/conf (ssh)
201-4-282135.33DEBUG$IOREACTOR-0-RWim
ackend.datc
nelMySQLCo
,schem
aoge_mycat, bo
连接的client信息
执行的SQL
ServerConnection [id=2，schema=mycat，host=10.211.55.9,user=root,txIsolation=3，autocommit=true，schema=mycat，
Lex"
2021-04-2821:07:40.542DEBUG[$_NIOREACTOR-0-RW](io.mycat.server.NonBlockingSess
ute(NonBlockingSession.jav
126))-ServerConnection [id=2， schema=mycat，host=10.211.55.9,user=root,txIsolation=3，autocommit=true， schema=myce
1 -> hahatinsert into chaoge-tb values(3,"alex")}
2021-04-28 21:07:40.542 DEBUG
[$_NIOREACTOR-O-RW]
(io.mycat.backend.mysql.nio.handler.SingleNodeHandler.execute(SingleNodeHandler.java:198)-node.getRunonSlavenul
(io.mycat.backend.mysql.nio.handler.SingleNodeHandler.execute(SingleNodeHandler.java:188))
node.getRunOnSlaveO)
default
G[$_NIOREACTOR-O-RW]
(io.mycat.backend.datasource.PhysicalDBNode.getConnection(PhysicalDBNode.java:102))
(io.mycat.backend.datas
e.PhysicalDBNode.getConnection(PhysicalDBNode.java:133))-
2021-04-2821:07:40.542DEBUG[$_NIOREACTOR-0-RW]
(io.mycat.backend.mysql.nio.MySQLCon
con needsyn，total syn cmd 1com
mands SETnames utf8;schema change:false con:MySQLConnection@45
055394[id=10,lastTime=1619615260542，u
root，schemc
aoge_mycat，olds
cat，borrow
fromSlaveDB=false，thread
=32,charset=utf8,txIsolation=3，auto
ent=haha{insert into chaoge_tb values（3
3，packetId=0],host=10.211.55.12, port=3306,
826,writeQueue=0,modifiedQ
2
ge_mycat，old sher
cat，bor
d=true,
mit=true，
ttachment=haha{insert into chaoge_tb values(3,"alex")}，respHandler=SingleNodeHandler [node=haha{insert int
chaoge_tb values(3,"alex)},packetId=1],host=10.211.55.12，port=3306，statusSync=null,writeQueue=0,modifiedSQLExecuted=true]
ource.java:633))-releasechannel MySQLCor
hema=chaoge_mycat，borro
st=10.211.55.12,
Xroot@chaoge_slave1:~(ssh)
mysql> select * from mycat.chaoge_tb;
ERROR 1146 (HY000): Table ‘mycat.chaoge_tb’ doesn't exist
mysql> use mycat;
You can turn off this feature to get a quicker startup with-A
Database changed
mysql> select * from chaoge_tb;
Iid | name |
1 i pyyu i
2|cc
2 rows in set (0.00 sec)
mysql>
mysql> insert into chaoge_tb values(3,"alex");
Query 0K， 1 row affected (0.01 sec)
sqL>
<!-- OCR_END -->

```plain
可以看到，insert插入语句，是发给了master机器执行
10.211.55.9 chaoge_slave1
10.211.55.12 chaoge_master1
10.211.55.11 chaoge_mycat1
```

### 查询语句
查询发给了slave机器执行  

<!-- OCR_START -->
root@chaoge_slave1:
100%
10%
11 GB
g 11kB↓
8.2kB↑|4/28,21:16
8yuchao
Q168.10.205
root@chaoge_mycat1:/mysql_data/mycat/conf (ssh)
edSQLExecuted=false]
2021-04-28 21:16:42.297 DEBUG [$_NIOREACTOR-0-RW]（io.mycat.net.FrontendConnection.query(FrontendConnection.java:337)）-ServerConnection [id=2，schema=mycat,host=10.211.55.9,user=root,txIsolation=3，autocommit=true，schema=mycat，ex
xecuteSql=select *
e_tb wh
e id=3]sel
(io.mycat.cache.impl.En
ere1d=
2021-04-2821:16:42.297 DEBUG[$_NIOREACTOR-0-RW]
2021-04-28 21:16:42.
.297 DEBUG
t，executeSql=select
from chao
id=3]select * from chaoge_tb where id=3，route={
2021-04-28 21:16:42.297D
[$_NIOREACTOR-O-RW]
.nio.handler.SingleNodeHandler.execute(SingleNodeHandLer.java:198))-node.getRunOnSlaveOnul1
node.getRun0nSlave()
(io.mycat.
.backend.mysql.
.297
.mycat.
d.mysql.nio.handler.SingleNodeHandler.
ecute(SingleNodeHandler
ava:200)-node.getRun0onSlave(）null
lode
getConnection(PhysicalDBNode.java:102))-
rrs.
default
a:133))
io.mycat.backend
oge_mycat,old shema
it=true,
attachment=ha
aselect *from chaoge_tb where id=33,
spHandler=SingleNodeHandler [node=haha{select * from
host=10.211.55.9,
2021-04-28 21:16:42.299 DEBUG [$_N
uted=false
sicalDat
a:633))
noge_mycat,
，old
dSQLExecuted=false]
Xroot@chaoge_slave1:~(ssh)
mysql> select * from chaoge_tb;
查询语句，被发给了mysql，slave机器执行
丨 id 丨 name |
1 I pyyu I
21cc
2 rows in set (0.00 sec)
mysql>
完成读写分离
mysql> insert into chaoge_tb values(3,"alex");
Query 0K，1 row affected (0.01 sec)
mysql> select * from chaoge_tb where id=3;
---+------+
I id丨 name |
|3|alex |
1 row in set (0.00 sec)
<!-- OCR_END -->

  

## mycat主从切换
流程

+ 关闭master
+ 查看slave状态
+ 登录mycat，进行数据读写

```plain

Mycat-node       192.168.10.210      mycat服务器，连接数据库时，连接此服务器
Mysql-node1      192.168.10.205      物理数据库1，真正存储数据的数据库,这里为Master主数据库
Mysql-node2      192.168.10.206      物理数据库2，真正存储数据的数据库,这里为Slave主数据库

# 超哥的配置
[root@chaoge_mycat1 ~]# tail -3 /etc/hosts
10.211.55.9 chaoge_slave1
10.211.55.12 chaoge_master1
10.211.55.11 chaoge_mycat1
```

### 关闭master
```plain
[root@chaoge_master1 ~]# /mm_data/3306/mysql_3306 stop
Stoping MySQL...
[root@chaoge_master1 ~]#
```

### 登录slave
检查slave状态  

```plain
[root@chaoge_slave1 ~]# mysql -S /mm_data/3306/mysql.sock -e "show slave status\G"
*************************** 1. row ***************************
               Slave_IO_State: Reconnecting after a failed master event read
                  Master_Host: 10.211.55.12
                  Master_User: repl_chaoge
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000001
          Read_Master_Log_Pos: 2170
               Relay_Log_File: mysqld_3306-relay-bin.000002
                Relay_Log_Pos: 1855
        Relay_Master_Log_File: mysql-bin.000001
             Slave_IO_Running: Connecting
            Slave_SQL_Running: Yes

                Last_IO_Error: error reconnecting to master 'repl_chaoge@10.211.55.12:3306' - retry-time: 60  retries: 1
```

### 登录mycat读写数据
找一个客户机，登录mycat

```plain
[root@chaoge_slave1 ~]# mysql -h10.211.55.11 -P8066 -uroot -p123456
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.6.29-mycat-1.6.7.4-release-20200105164103 MyCat Server (OpenCloudDB)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

# 执行查询语句，查看日志
```

查询语句被发给了slave机器

<!-- OCR_START -->
- root@chaoge_slave1:~
- 100%
- 5%
- 11 GB
- 1.0 kB↓AAAAAA 1.0kB↑| 4/28, 21:32
- |8 yuchao
- Q192.168.10.205
- ava:99)~[Mycat
- sh-m-2h21:32：35t3br
- cat.sgleng
- 2021-04-2821:32:334
- DENFO
- omchaoge_tb
- rom
- rm-chheseleutromchaogetb}
- 221-04-2821:3232EACTOR-
- 2021-04-28
- 21:32:43.200
- [S_NIOREACTOR-0-RW]
- defaut
- 查询SQL被发给了slave机器
- e.java:133))
- default
- catl
- ueue=0，modified
- QLExecuted-false]
- 21-S4-8133EUGNIOREACTOR--
- id=20,lastTime=1619616763190，user
- root@chaoge_n
- naster1:~（ssh）
- Oracle is a registered trademark of Oracle Corporation and/or its
- Last login: Mon Apr 26 10:11:44 2021 from 10.211.55.2
- affiliates. Other names may be trademarks of their respective
- [root@chaoge_master1 ~]#
- owners.
- Type‘help;′or ‘\h’ for help. Type '\c' to clear the current input statement.
- mysql主库，主动停止
- mysql>
- mysql> use mycat;
- media/
- mm_data/
- mnt/
- mysql_data/mysql_script/
- Reading table information for completion of table and column names
- [root@chaoge_master1~]#/mm_data/3306/mysql_3306 stop
- You can turn off this feature to get a quicker startup with -A
- Stoping MySQL...
- Database changed
- _slave1:~ (ssh)
- mysql> select * from chaoge_tb;
- Master_Retry_Count:86400
- ----+------+
- Master_Bind:
- I id | name |
- Last_I0_Error_Timestamp: 210428 21:24:11
- Last_SQL_Error_Timestamp:
- 1 1 pyu 1
- 登录mycat执行语句
- Master_SSL_Crl:
- Master_SSL_Crlpath:
- 21cc
- Retrieved_Gtid_Set:
- slave从库当前丢失了主库
- 3 1alex |
- ===+
- Executed_Gtid_Set:
- 3 rows in set (0.01 sec)
- Auto_Position:0
<!-- OCR_END -->

### 写入数据

<!-- OCR_START -->
root@chaoge_slave1:~
100%
12%
|11 GB
3.1 kB↓AAAAM_A 5.1 kB↑ O 4/28, 21:37
yuchao
Q192.168.10.205
er.NonBlockingSession.execute(NonBlockingSession.java:126)) - ServerConnection [id=3, schema=mycat,host=10.211.55.9,user=root,txIsolation=3，autocommit=true, schema=mycat, executeSql=insert into chaoge_tb values(4,
1->haha[insert into chaoge_tb values（4,yuchao66°）}
221--237189EUACT-
写入语句也发给了slave这台机器
因为master宕机了
ysicalDBNode.java:133
default
2021-04-2821:37:18597DEUG[SNOREACTR--R
tnto chaoge_toV
96173889，user=root，schema=chaoge_mycat，ld shem=chaoge_mycat，borro
root@chaoge_master1:~ (ssh)
Last login: Mon Apr 26 10:11:44 2021 from 10.211.55.2
Type'help;'or‘\h'forhelp.Type'\c'to clear the currentinput statement.
[rootechaoge_master1 ~]#
[root@chaoge_master1
mysql>
~]#
You can turn offthisfeature to geta quickerstartupwith-A
media/
mm_data/
mnt/
mysql_data/n
Database changed
mysql_script/
[root@chaoge_master1 ~]#/mm_data/3306/mysql_3306 stop
Stoping MySQL...
mysql> select * from chaoge_tb;
I id| name |
root@chaoge_slave1:~ (ssh)
Master_Retry_Count:86400
!1 I pyyu 1
Master_Bind:
21cc
Last_I0_Error_Timestamp: 210428 21:24:11
13丨alex |
Last_SQL_Error_Timestamp:
Master_SSL_Crl:
--+------+
Master_SSL_Crlpath:
3rows in set (0.01sec)
数据写入
Retrieved_Gtid_Set:
mysql>insert into chaoge_tb values(4,"yuchao666");
Executed_Gtid_Set:
Query 0K，1row affected (0.00 sec)
Auto_Position:0
<!-- OCR_END -->

## 总结
最终结果，发现insert和select语句都发给了slave机器

这里已经实现了mysql主从切换

查看数据，数据以及插入到数据库中

```plain
mysql> select * from chaoge_tb;
+----+-----------+
| id | name      |
+----+-----------+
|  1 | pyyu      |
|  2 | cc        |
|  3 | alex      |
|  4 | yuchao666 |
+----+-----------+
4 rows in set (0.01 sec)
```

到这里，我们已经使用mycat完成了mysql的读写分离、主从切换。

  
 

> 更新: 2022-12-22 01:17:17  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/eswim1o2242lwzo0>