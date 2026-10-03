# nginx实现最简单的直播平台

## nginx实现最简单的直播平台
2019-05-03 分类：[Linux](https://www.driverzeng.com/zenglaoshi/category/linux), [Nginx](https://www.driverzeng.com/zenglaoshi/category/linux/web/nginx) 阅读(168) 评论(0)

+ [环境准备](https://www.driverzeng.com/zenglaoshi/1392.html#toc_0)
+ [nginx直播插件准备](https://www.driverzeng.com/zenglaoshi/1392.html#toc_1)
+ [源码安装nginx](https://www.driverzeng.com/zenglaoshi/1392.html#toc_2)
+ [启动并配置nginx](https://www.driverzeng.com/zenglaoshi/1392.html#toc_3)
+ [使用EV录屏实现推流](https://www.driverzeng.com/zenglaoshi/1392.html#toc_4)

> -曾老湿, 江湖人称曾老大。
>
> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023
>

---

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1)整合了各个公有云API，自主创建云主机。
>
> 2)ELK自动化收集日志功能。
>
> 3)Saltstack自动化运维统一配置管理工具。
>
> 4)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6)SQL执行及审批流程。
>
> 7)慢查询日志分析web界面。
>

---

## 环境准备
```plain
#系统版本
[root@centos7 ~]# cat /etc/redhat-release
CentOS Linux release 7.5.1804 (Core)
#selinux状态，如果开启，则关闭
[root@centos7 ~]# getenforce
Enforcing
#关闭selinux(临时关闭)
[root@centos7 ~]# setenforce 0
#永久关闭
[root@centos7 ~]# vim /etc/sysconfig/selinux
#将SELINUX=enforcing 替换为 SELINUX=disabled
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
#关闭防火墙
[root@centos7 ~]# systemctl stop firewalld
#IP地址
[root@centos7 ~]# hostname -I
10.0.0.100
```

## nginx直播插件准备
```plain
#安装git命令
[root@centos7 ~]# yum install -y git
#git拉取nginx-rtmp插件
[root@centos7 ~]# git clone https://github.com/arut/nginx-rtmp-module.git
正克隆到 'nginx-rtmp-module'...
remote: Enumerating objects: 4314, done.
remote: Total 4314 (delta 0), reused 0 (delta 0), pack-reused 4314
接收对象中: 100% (4314/4314), 3.10 MiB | 14.00 KiB/s, done.
处理 delta 中: 100% (2686/2686), done.
#查看克隆的插件
[root@centos7 ~]# ll
总用量 4
drwxr-xr-x. 7 root root 4096 5月   3 12:37 nginx-rtmp-module
```

## 源码安装nginx
```plain
#安装上传下载命令
[root@centos7 ~]# yum install -y lrzsz
#上传nginx的包，或者去官网下载
[root@centos7 ~]# rz
[root@centos7 ~]# wget http://nginx.org/download/nginx-1.10.0.tar.gz
#查看上传的包
[root@centos7 ~]# ll
总用量 896
-rwxr-xr-x. 1 root root 911509 6月   1 2017 nginx-1.10.3.tar.gz
drwxr-xr-x. 7 root root   4096 5月   3 12:37 nginx-rtmp-module
#解压nginx安装包
[root@centos7 ~]# tar xf nginx-1.10.3.tar.gz
#进入nginx目录
[root@centos7 ~]# cd nginx-1.10.3
#安装nginx依赖包
[root@centos7 nginx-1.10.3]# yum install pcre-devel openssl-devel gcc gcc-c++ -y
#创建nginx用户
[root@centos7 nginx-1.10.3]# useradd nginx -s /sbin/nologin -M
#生成nginx编译文件
[root@centos7 nginx-1.10.3]# ./configure --user=nginx --group=nginx --with-http_ssl_module --prefix=/usr/local/nginx --add-module=/root/nginx-rtmp-module
#编译
[root@centos7 nginx-1.10.3]# make
#安装
[root@centos7 nginx-1.10.3]# make instal
```

## 启动并配置nginx
```plain
#进入nginx安装目录
[root@centos7 nginx-1.10.3]# cd /usr/local/nginx/
#查看文件
[root@centos7 nginx]# ll
总用量 4
#配置文件目录
drwxr-xr-x. 2 root root 4096 5月   3 12:53 conf
#站点目录
drwxr-xr-x. 2 root root   40 5月   3 12:53 html
#日志目录
drwxr-xr-x. 2 root root    6 5月   3 12:53 logs
#程序目录
drwxr-xr-x. 2 root root   19 5月   3 12:53 sbin
#编辑nginx配置文件
[root@centos7 nginx]# vim conf/nginx.conf
worker_processes 1;
events {
worker_connections 1024;
}
rtmp {
    server {
        listen 1935;
        chunk_size 4096;
        application live {
            live on;
            hls on;
            hls_path /usr/local/nginx/html/live;
            hls_fragment 5s;
        }
    }
}
http {
    include mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;
    server {
        listen 80;
        server_name localhost;
        location /live {
            types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
            }
        alias /usr/local/nginx/html/live;
        expires -1;
        add_header Cache-Control no-cache;
        }
        location / {
        root html;
        index index.html index.htm;
        }
    }
}
#检查nginx语法
[root@centos7 nginx]# /usr/local/nginx/sbin/nginx -t
#启动nginx
[root@centos7 nginx]# /usr/local/nginx/sbin/nginx
#检测nginx端口
[root@centos7 nginx]# netstat -lntup|grep nginx
tcp        0      0 0.0.0.0:1935            0.0.0.0:*               LISTEN      4898/nginx: master
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      4898/nginx: master
#检测nginx进程
[root@centos7 nginx]# ps -ef|grep [n]ginx
root       4898      1  0 13:01 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
nginx      4899   4898  0 13:01 ?        00:00:00 nginx: worker process
nginx      4900   4898  0 13:01 ?        00:00:00 nginx: cache manager process
```

## 使用EV录屏实现推流

<!-- OCR_START -->
- 2
- G<
- Windows7x64
- 要释放鼠标，请按：Control-
- EV录屏
- 回收站
- 88常规
- 本地录制
- 在线直播
- ApkIDE最新
- 列表
- 选择录制区域
- 选择录制音频
- 3.3.3少月.
- 全屏录制
- 仅麦克风
- 会员
- lxeplayer
- 辅助工具
- 图片水印
- 文字水印
- 嵌入摄像头
- 定时录制
- 天龙八部架
- 场景编辑
- 分屏录制
- 按键显示
- 桌面画板
- 本地直播
- 00:00:00
- 时长：
- 声音：
- ApkIDE_1.
- V3.9.7
- GameDow....
- 2019/5/3
<!-- OCR_END -->

￼

<!-- OCR_START -->
- Windows7x64
- 要释放鼠标，请按：Control-
- EV录屏
- 回收站
- 88常规
- 本地录制
- 在线直播
- ApkIDE最新
- 列表
- 选择录制区域
- 3.3.3少月.
- 设置
- 全屏
- 会员
- 填写串流地址
- 录屏设置
- 串流地址：
- rtmp://10.0.0.100/live
- 如何使用在线直？
- lxeplayer
- 辅助工具
- 地址密钥：
- 秘钥随便填写，这里我填写的是：zls
- 用地址密码？
- 直播设置
- 图片水印
- 开启多路推流
- 如何使用多路推流？
- 鼠标设置
- 天龙八部架
- 视频帧率（fps）：10
- 关键帧间距：20
- 分屏录制
- 快捷键
- 音频码率：
- 128kbps
- 音频采样率：
- 8000Hz
- 其他
- 时长：
- 视频码率：800
- ApkIDE.1...
- 同时保存直播视频
- GameDow...
- 2019/5/3
<!-- OCR_END -->

￼

串流地址：rtmp://10.0.0.100/live

地址秘钥：zls

这里地址秘钥随便填写

如果此时开启直播，那么访问[http://10.0.0.100/live/zls.m38u可以下载一个直播视频文件](http://10.0.0.100/live/zls.m38u%E5%8F%AF%E4%BB%A5%E4%B8%8B%E8%BD%BD%E4%B8%80%E4%B8%AA%E7%9B%B4%E6%92%AD%E8%A7%86%E9%A2%91%E6%96%87%E4%BB%B6)

<!-- OCR_START -->
- 2
- Windows7x64
- 要释放鼠标，请按：Control-
- 回收站
- lxeplayer....
- 404NotFound-WindowsInternetExplorer
- http:/10.0.0.100/live/k.m3u8
- Bing
- ★收藏夹
- 建议网站网页快讯库
- ApkIDE最新
- winrar-x6..
- 404NotFound
- 页面（P）→
- 安全（S）
- 工具（O）
- 3.3.3少月..
- 404Not
- Eouind
- 已完成0%-zls.m3u8（来自10.0.0.100）
- 一回X
- 文件下载
- 天龙八部架
- 设.zip
- 是要保存此文件，还是要联机查找程序来打开此文件？
- 名称：zls.m3u8
- 类型：未知文件类型，238字节
- 来源：10.0.0.100
- 天龙八部架腾讯手游助
- 查找（F）
- 保存（S)
- 取消
- 算机如果不信
- 不要查找可
- 并此文件的程序或保存此文件。有何风险？
- ApkIDE_1...
- EVCaptur....
- EV录屏
- 完成
- Internet|保护模式：启用
- 100%
- GameDow....
- 2019/5/3
<!-- OCR_END -->

￼

那么此时，你离成功又近了一步

```plain
#编辑直播前端页面
[root@centos7 ~]# vim /usr/local/nginx/html/index.html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>前端播放m3u8格式视频</title>
<link rel="stylesheet" href="http://vjs.zencdn.net/5.5.3/video-js.css">
<script src="http://vjs.zencdn.net/5.5.3/video.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/videojs-contrib-hls/5.12.2/videojs-contrib-hls.js"></script>
</head>
<body>
<video id="myVideo" class="video-js vjs-default-skin vjs-big-play-centered" controls preload="auto" width="1080" height="708" data-setup='{}'>
<source id="source" src="http://10.0.0.100/live/zls.m3u8" type="application/x-mpegURL">
</video>
</body>
<script>
// videojs 简单使用
var myVideo = videojs('myVideo',{
bigPlayButton : true,
textTrackDisplay : false,
posterImage: false,
errorDisplay : false,
})
myVideo.play() // 视频播放
myVideo.pause() // 视频暂停
</script>
</html>
```

打开浏览器，访问：[http://10.0.0.100](http://10.0.0.100/)

就可以看到直播的界面了

<!-- OCR_START -->
- 前端播放m3u8格式视频
- 不安全10.0.0.100
- 无痕模式
- TTS
- 回收站
- Ixeplayer.
- DBA老司机带你删库到跑路-ADriverForMysQL-Windows Internet Explorer
- ×PBing
- ★收藏夹会建议网站网页快讯库
- ApkIDE最新
- winrar-xo.
- DBA老司机带你删库到跑路-ADriverForMyS
- 页面（P）安全（S）工具（O）
- 3.3.3少月..
- DBA老司机带你删库到跑路
- xeplayer
- 天龙八部架
- 曾老湿撩妹宝典（PUA）
- Linux基础
- DATABASE
- DevOps
- Web
- 监控系统
- 云计算
- 设zip
- 这周日你有空吗？
- 腾讯手游助
- ApkIDE_1...
- Evcapt
- ApRIDE联新
- 33.3月
- com
<!-- OCR_END -->

￼

未经允许不得转载，欢迎技术交流，QQ：133411023：[DBA老司机带你删库到跑路.](https://www.driverzeng.com/) » [nginx实现最简单的直播平台](https://www.driverzeng.com/zenglaoshi/1392.html)

> 更新: 2019-05-28 15:22:47  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ut7en4>