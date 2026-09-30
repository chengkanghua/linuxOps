# 第二阶段-web基础之http

# <font style="color:black;"> 一、HTTP 核心基础  </font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. HTTP 本质与工作模式</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：</font><font style="color:#0070C0;">H</font><font style="color:black;">yper </font><font style="color:#0070C0;">T</font><font style="color:black;">ext   </font><font style="color:#0070C0;">T</font><font style="color:black;">ransfer  </font><font style="color:#0070C0;">P</font><font style="color:black;">rotocol </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">超文本传输协议</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，基于 TCP/IP 协议的应用层协议，「客户端 - 服务器」请求响应模式（运维抓包 / 排错的基础）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无状态：协议本身不记录请求上下文（运维需懂 Cookie/Session 作用 —— 排查登录态、会话保持问题）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">版本区别（运维重点关注）：</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">版本</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维核心关注点</font>** |
| :--- | :--- |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP/1.0</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">短连接（每次请求新建 TCP 连接，性能低）</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP/1.1</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">长连接（Keep-Alive 默认可用，减少 TCP 握手开销；支持管道化请求）</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP/2</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">多路复用（单 TCP 连接处理多请求，性能大幅提升；Nginx 可配置启用）</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP/3</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">基于 QUIC（UDP），解决 TCP 队头阻塞，运维接触少，了解即可</font> |

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. HTTP 请求 / 响应结构（运维排错的「语言」）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">必须能看懂请求 / 响应内容（用 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">curl -v</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 或抓包工具分析）：</font>

* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">请求结构</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>

```plain
1.概况
    Request URL: http://10.0.0.7/index.html         # 请求的URL地址
    Request Method: GET                             # 请求的方法（获取）
    Status Code: 304 Not Modified                   # 返回的状态
    Remote Address: 10.0.0.7:80                     # 请求的地址
    

2.客户端请求的头部信息
Accept: text/html,                                  # 请求的类型
Accept-Encoding: gzip, deflate                      # 是否进行压缩
Accept-Language: zh-CN,zh;q=0.9                     # 请求的语言
Cache-Control: max-age=0                            # 缓存
Connection: keep-alive                              # TCP长连接
Host: www.oldboyedu.com                             # 请求的域名
If-Modified-Since: Fri, 04 May 2018 08:13:44 GMT    # 修改的时间
If-None-Match: "a49-56b5ce607fe00"                  # 标记
Upgrade-Insecure-Requests:1                         # 在http和https之间起的一个过渡作用
User-Agent: Mozilla/5.0                             # 用户的浏览器
# 空行
（请求体：POST/PUT 才有，如表单数据）


 运维重点：Host（虚拟主机核心，Nginx 基于此匹配站点）、
     Connection: Keep-Alive（长连接）、
    Content-Length（请求体大小）。
```

* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">响应结构</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>

```plain
3.服务端响应的头部信息
HTTP/1.1 304 Not Modified                           # 返回服务器的http协议，状态码
Date: Fri, 14 Sep 2018 09:14:28 GMT                 # 返回服务器的时间
Server: Apache/2.4.6 (CentOS) PHP/5.4.16            # 返回服务器使用的软件（Apache php）
Connection: Keep-Alive                              # TCP长连接
Keep-Alive: timeout=5, max=100                      # 长连接的超时时间
ETag: "a49-56b5ce607fe00"                           # 验证客户端标记
===========返回一个空行=========================
===========返回内容页面=========================


运维重点：   Server（识别 Web 服务版本）、
            Cache-Control（缓存策略）、
            Content-Encoding: gzip（压缩状态）。

```

## HTTP 相关术语

<font style="color:#363636;">pv、ip、uv</font>

<font style="color:#363636;">PV：页面浏览量</font>

<font style="color:#363636;">uv：独立的客户</font>

<font style="color:#363636;">ip：独立IP</font>

<font style="color:#363636;">我们公司有一座大厦，大厦有100人，每个人有一台电脑一个手机，上网都是通过nat转换出口，每个人点击网站2次。</font>

<font style="color:#363636;">    PV：400</font>

<font style="color:#363636;">    UV：200</font>

<font style="color:#363636;">    IP：1个</font>

## <font style="color:#0070C0;">什么是URL？</font>

<font style="color:black;">URL即统一资源定位符</font><font style="color:black;">(Uniform Resource Locator)，</font><font style="color:black;">用来唯一地标识万维网中的某一个文档。URL由协议、主机和端口</font><font style="color:black;">(默认为80)</font><font style="color:black;">以及文件名三部分构成。如</font><font style="color:black;">：</font>

![1583822963141-9abacc41-d235-4fbe-b40b-16bbad70fc85.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-01.png)

```bash
为什么要有「www.」？
www. 本质是 qq.com 主域名下的子域名，加它的核心原因分 3 类（历史 + 技术 + 业务），尤其适配腾讯这类超大型网站的运维需求：
1. 历史由来：万维网的「约定俗成」
www 是 World Wide Web（万维网）的缩写，早期互联网的通用规范：
上世纪 90 年代互联网初期，一台服务器可能提供多种服务（Web、邮件、FTP、数据库），为了区分不同服务，约定用不同子域名标识：
www.域名 → 万维网服务（网页访问）；
mail.域名 → 邮件服务（如 mail.qq.com）；
ftp.域名 → 文件传输服务（如 ftp.qq.com）；
腾讯作为早期互联网企业，延续了这一规范，成为用户的「肌肉记忆」。


```

## CDN 核心解析

CDN（Content Delivery Network，内容分发网络）本质是\*\*<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">分布在全球 / 全国不同地域的「缓存服务器集群」</font>\*\*，核心目标是「让用户就近访问资源」—— 把源站的静态资源（图片、JS、CSS、视频、下载包等）缓存到离用户最近的 CDN 节点，用户访问时直接从节点取资源，而非远在千里的源站，解决「跨地域访问慢、源站压力大、带宽成本高」三大核心问题。

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">CDN 核心是「就近缓存」：把静态资源分发到各地节点，用户不用访问远的源站，速度快、源站压力小；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">工作流程：DNS 智能解析到就近节点 → 节点缓存命中直接返回，未命中回源缓存后返回；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维核心操作：配置缓存规则、刷新 / 预热缓存、排查节点解析 / 缓存故障。</font>

# <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">二、运维高频 HTTP 核心知识点（必背）</font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. HTTP 状态码（排查 Web 故障的「信号灯」）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">不用记全，但必须精准掌握以下高频状态码的</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">含义 + 运维排查方向</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">状态码分类</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心码</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">含义</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维排查方向</font>** |
| :--- | :--- | :--- | :--- |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2xx（成功）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">200</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">请求成功</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">正常状态，无需排查</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">206</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">部分请求（断点续传）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">下载 / 视频点播场景，检查 Nginx 配置是否支持 range</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3xx（重定向）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">301</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">永久重定向</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">检查 Nginx </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">rewrite</font></code><br/><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 规则，SEO 优化场景</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">302</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">临时重定向</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">临时跳转，排查业务跳转逻辑</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">304</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">未修改（缓存命中）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">检查静态资源缓存配置（Nginx </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">expires</font></code><br/><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Cache-Control</font></code><br/><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">4xx（客户端错误）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">400</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">请求参数错误</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">客户端请求格式问题，抓包看请求体 / 参数</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">403</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">禁止访问</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：文件权限 / SELinux/nginx </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">allow/deny</font></code><br/><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 规则 / 目录无索引页</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">404</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">资源不存在</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">检查 Nginx 根目录 / 路径配置、文件是否存在</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">408</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">请求超时</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">客户端请求发送慢，检查网络或客户端问题</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">499</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Nginx 特有：客户端主动断开</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">后端响应慢，客户端提前关闭连接，调大 Nginx </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">proxy_read_timeout</font></code> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">5xx（服务器错误）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">500</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">服务器内部错误</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">后端程序报错（PHP/Java）、Nginx 配置语法错</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">502</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">坏网关</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：后端服务挂了（Tomcat/PHP-FPM）、Nginx 反向代理地址错误</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">503</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">服务不可用</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">后端服务过载 / 维护中，检查服务进程 / 负载均衡配置</font> |
| | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">504</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">网关超时</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">后端响应超时，调大 Nginx </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">proxy_read_timeout</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">、排查后端慢请求</font> |

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>

<font style="color:black;"></font>

## <font style="color:black;">2.HTTP 请求方法</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">一、HTTP 1.1 核心请求方法（RFC 标准定义，最常用）</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">方法名</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心含义（大白话）</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">典型使用场景</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">幂等性（重点！）</font>** |
| :--- | :--- | :--- | :--- |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">GET</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">「查」：从服务器获取资源</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">访问网页、查询数据（如？id=1）、下载文件</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 幂等（多次请求结果一致）</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">POST</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">「增 / 提交」：向服务器提交数据，创建新资源</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">登录表单、提交订单、上传文件、新增数据</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">❌</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 非幂等（多次提交可能创建多条数据）</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">PUT</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">「改（全量）」：替换服务器上的资源（全量更新）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">更新用户信息（覆盖所有字段）、替换文件</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 幂等（多次替换结果一致）</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">DELETE</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">「删」：删除服务器上的指定资源</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">删除订单、删除用户、删除文件</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 幂等（多次删除结果一致）</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HEAD</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">只获取响应头，不获取响应体</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">检查文件是否存在、获取文件大小 / 修改时间</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 幂等</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">OPTIONS</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">「查权限」：询问服务器支持哪些请求方法</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">跨域请求（CORS）预检、接口兼容性检测</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 幂等</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">PATCH</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">「改（增量）」：部分更新资源（只改需要的字段）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">更新用户手机号（仅改 phone 字段）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">❌</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 非幂等（部分实现可能不保证）</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">TRACE</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">回显请求，用于调试 / 诊断</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">排查请求转发过程中的问题（极少用）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">✅</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 幂等</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">CONNECT</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">建立隧道连接（如 HTTPS 代理）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">代理服务器转发 HTTPS 请求</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">❌</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 非幂等</font> |

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">二、关键概念解释（新手必懂）</font>

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 幂等性（面试高频）</font>

* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">幂等</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：多次执行同一个请求，结果和执行一次完全一样（不会产生副作用）；</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">→ 比如 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">GET /user/1</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 查 1 次和查 100 次，返回的用户信息都一样；</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">DELETE /order/1</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 删 1 次和删 100 次，订单都是删除状态。</font>
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">非幂等</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：多次执行可能产生不同结果；</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">→ 比如 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">POST /order</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 提交订单，多次执行会创建多个订单；</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">PATCH /user/1</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 多次执行可能重复更新字段。</font>

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. GET vs POST 核心区别（最易混淆）</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">维度</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">GET</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">POST</font>** |
| :--- | :--- | :--- |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">数据位置</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">URL 拼接（如？name=test）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">请求体（Body）中</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">数据大小</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">受 URL 长度限制（一般 < 2KB）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无限制（可传大文件）</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">安全性</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">数据暴露在 URL，明文可见</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">数据在请求体，相对安全（仍需 HTTPS）</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">缓存</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">可被浏览器缓存</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">默认不缓存</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">用途</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">查数据</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">提交 / 创建数据</font> |

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">三、实际开发中的高频用法</font>

1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">GET</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：所有查询类操作（如列表查询、详情查询、下载）；</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">POST</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：所有提交 / 创建类操作（登录、注册、下单、上传）；</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">PUT</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：全量更新（如替换整个用户信息）；</font>
4. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">PATCH</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：增量更新（如只改用户昵称）；</font>
5. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">DELETE</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：删除操作（如删除评论、删除订单）；</font>
6. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">OPTIONS</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：前端跨域请求时，浏览器自动先发 OPTIONS 预检，确认服务器允许跨域后再发真实请求。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">四、总结（核心记忆点）</font>

1. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心方法：</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">GET（查）、POST（增）、PUT/PATCH（改）、DELETE（删）</font>**

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">     （对应 CRUD） CRUD = Create（增）、Read（查）、Update（改）、Delete（删）；</font>

2. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">幂等性：GET/PUT/DELETE/HEAD/OPTIONS 是幂等，POST/PATCH/CONNECT/TRACE 非幂等；</font>
3. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">实际开发：优先用 GET/POST 覆盖 80% 场景，PUT/PATCH/DELETE 用于 RESTful API 规范开发。</font>

#### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3. HTTP 核心特性（优化 Web 性能的关键）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维的核心工作之一是优化 Web 性能，必须懂这些特性的配置：</font>

* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">长连接（Keep-Alive）</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">作用：减少 TCP 三次握手 / 四次挥手开销，提升并发；</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维配置：Nginx 中 </font>
  * <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">keepalive_timeout 60;</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（长连接超时时间）、</font>
  * <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">keepalive_requests 10000;</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（单连接最大请求数）。</font>
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">缓存机制</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心响应头：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Cache-Control</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（如 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">max-age=86400</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）、</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Expires</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">、</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ETag</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">；</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维配置：Nginx 配置 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">expires 7d;</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（静态资源缓存 7 天），减少后端请求。</font>
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">压缩（gzip）</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">作用：压缩响应体（HTML/CSS/JS），减少传输量；</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维配置：Nginx 开启 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">gzip on;</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 配置 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">gzip_types text/html text/css application/json;</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（指定压缩类型）。</font>
* **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">跨域（CORS）</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维场景：前端调用后端接口报跨域错误，需在 Nginx 配置响应头</font>

```nginx
add_header Access-Control-Allow-Origin *;
add_header Access-Control-Allow-Methods GET,POST,OPTIONS;

```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">三、HTTPS 基础（运维必配，HTTP 的安全版）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维日常要部署 HTTPS 证书、排查证书问题，核心掌握：</font>

1. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTPS 本质：HTTP + SSL/TLS（加密传输，解决明文泄露、篡改、伪造问题）；</font>
2. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心配置：Nginx 配置 SSL 证书</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ssl_certificate</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ssl_certificate_key</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）、</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">   禁用低版本 TLS（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ssl_protocols TLSv1.2 TLSv1.3;</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）；</font>

3. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">常见问题：证书过期（监控告警）、HTTPS 访问慢（开启 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ssl_session_cache</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 缓存会话）、混合内容（页面同时加载 HTTP/HTTPS 资源）。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">四、运维必备的 HTTP 工具（实操核心）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">所有知识点最终要落地到工具使用，必须熟练：</font>

1. <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">curl</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：测试 HTTP 请求（运维排错第一工具）：</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">bash</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运行</font>

```bash
 # 查看完整请求/响应
curl -v http://www.baidu.com 

 # 只看响应头
curl -I http://www.baidu.com 

# 测试POST请求
curl -X POST -d "name=test" http://www.baidu.com  

```

2. <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ab</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（Apache Bench）：HTTP 压力测试（验证服务并发能力）：</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">bash</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运行</font>

```bash
# 100并发，总共1000请求
ab -n 1000 -c 100 http://www.baidu.com/  

```

3. <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">tcpdump/wireshark</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：抓包分析 HTTP 流量（排查复杂网络 / 请求问题）：</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">bash</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运行</font>

```plain
 # 抓取80端口流量保存为文件
tcpdump -i eth0 port 80 -w http.pcap 

```

4. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Nginx/Apache 配置：把 HTTP 知识点落地到配置（反向代理、缓存、压缩、HTTPS）。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Nginx 核心配置（反向代理 + 缓存 + 压缩 + HTTPS）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">前提</font>

1. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">确保 Nginx 编译了核心模块：</font>
2. <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ngx_http_proxy_module</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（反向代理）、</font>
3. <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ngx_http_gzip_module</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（压缩）、</font>
4. <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ngx_http_ssl_module</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（HTTPS）；</font>
5. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">替换配置中的 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"><占位符></font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（如证书路径、后端地址）为实际值。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">完整配置示例（nginx.conf 或站点配置文件，如 /etc/nginx/conf.d/oldboy.conf）</font>

```nginx
# 全局/HTTP段基础配置
http {
  # ===== 1. HTTP压缩配置（对应HTTP gzip压缩特性）=====
  gzip on;                  # 开启gzip压缩（核心）
  gzip_vary on;             # 响应头添加Vary: Accept-Encoding，适配缓存服务器
  gzip_min_length 1k;       # 仅压缩大于1k的内容（小文件压缩无意义）
  gzip_comp_level 6;        # 压缩级别（1-9，6兼顾性能和压缩率）
  gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;  # 指定压缩的MIME类型（覆盖前端核心文件）
  gzip_proxied any;         # 对反向代理的请求也压缩

  # ===== 2. 反向代理缓存配置（可选，对应HTTP缓存特性）=====
  proxy_cache_path /var/nginx/cache levels=1:2 keys_zone=OLD_BOY_CACHE:10m max_size=10g inactive=60m use_temp_path=off;
  # 解释：
  # /var/nginx/cache：缓存文件存储路径（需提前创建并赋Nginx用户权限）
  # levels：缓存目录层级
  # keys_zone：缓存区名称+内存大小（10m足够）
  # max_size：缓存最大磁盘空间
  # inactive：60分钟未访问则清理缓存

  # ===== 3. 长连接配置（对应HTTP/1.1 Keep-Alive）=====
  keepalive_timeout 60s;    # HTTP长连接超时时间（客户端与Nginx）
  keepalive_requests 10000; # 单个长连接处理的最大请求数（高并发优化）
  proxy_http_version 1.1;   # 反向代理使用HTTP/1.1（支持长连接）
  proxy_set_header Connection "";  # 清空Connection头，保持后端长连接

  # 站点配置
  server {
    listen 80;
    server_name www.oldboy.com;
    # HTTP强制跳转HTTPS（对应HTTPS安全特性）
    rewrite ^(.*)$ https://$host$1 permanent;  # 301永久重定向
  }

  # HTTPS站点（对应HTTP安全层SSL/TLS）
  server {
    listen 443 ssl http2;  # 开启HTTPS+HTTP/2（HTTP/2提升并发）
    server_name www.oldboy.com;

    # ===== HTTPS核心配置 =====
    ssl_certificate /etc/nginx/ssl/oldboy.crt;        # 公钥证书路径
    ssl_certificate_key /etc/nginx/ssl/oldboy.key;    # 私钥路径
    ssl_session_cache shared:SSL:10m;                 # SSL会话缓存（提升HTTPS握手速度）
    ssl_session_timeout 10m;                          # SSL会话超时时间
    ssl_protocols TLSv1.2 TLSv1.3;                    # 禁用低版本TLS（TLSv1.0/1.1不安全）
    ssl_prefer_server_ciphers on;                     # 优先使用服务器端加密套件
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;  # 高安全加密套件

    # ===== 4. 反向代理配置（核心，对应HTTP请求转发）=====
    location / {
      proxy_pass http://192.168.1.100:8080;  # 后端服务地址（Tomcat/PHP-FPM等）
      # 传递核心请求头（解决后端获取真实IP/Host问题）
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;  # 告诉后端是HTTPS请求

      # 反向代理超时配置（解决504 Gateway Timeout）
      proxy_connect_timeout 30s;  # 连接后端超时时间
      proxy_read_timeout 60s;     # 等待后端响应超时时间
      proxy_send_timeout 60s;     # 发送请求到后端超时时间

      # 反向代理缓存（可选，针对GET请求缓存）
      proxy_cache OLD_BOY_CACHE;
      proxy_cache_valid 200 304 10m;  # 200/304响应缓存10分钟
      proxy_cache_valid any 1m;       # 其他状态码缓存1分钟
      proxy_cache_key $host$request_uri;  # 缓存key（按域名+请求路径）
      add_header X-Proxy-Cache $upstream_cache_status;  # 响应头显示缓存状态（HIT/MISS）
    }

        # ===== 静态资源缓存配置（对应HTTP Cache-Control/Expires）=====
        location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
            root /data/www;  # 静态资源根目录
            expires 7d;      # 响应头添加Expires: 7天后，Cache-Control: max-age=604800
            add_header Cache-Control "public, max-age=604800";  # 明确缓存策略
            access_log off;  # 关闭静态资源访问日志（减少IO）
        }
    }
}
```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Nginx 配置关键解释（对应 HTTP 知识点）</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">配置项</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">对应 HTTP 知识点</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维价值</font>** |
| :--- | :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">gzip on</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP 压缩特性</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">减少传输量，提升加载速度</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">expires 7d</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP 缓存（Cache-Control/Expires）</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">静态资源缓存，减少后端请求</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">proxy_pass</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP 反向代理</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">隔离后端服务，统一入口</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">proxy_read_timeout</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP 请求超时</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">解决 504 网关超时问题</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ssl_protocols TLSv1.2+</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTPS（SSL/TLS）安全层</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">避免低版本 TLS 被攻击</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">keepalive_timeout</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP/1.1 长连接</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">减少 TCP 握手开销，提升并发</font> |

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Nginx 验证</font>

```nginx
nginx -t  # 检查配置语法
systemctl restart nginx  # 重启生效
# 验证压缩/缓存：
curl -I -H "Accept-Encoding: gzip" https://www. xxx.com/css/index.css
# 响应头包含 Content-Encoding: gzip、Cache-Control: max-age=604800 则生效


```

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">五、HTTP 常见运维问题排查思路（核心能力）</font>

1. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Web 服务访问慢：</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">用 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">curl -w %{time_total}\\n -o /dev/null http://xxx</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 测响应时间；</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">抓包看是 TCP 握手慢 / 请求处理慢 / 传输慢；</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">检查长连接、gzip、缓存配置是否生效。</font>
2. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">502/504 错误：</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">502：先查后端服务（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ps -ef | grep php-fpm</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）、Nginx 反向代理地址是否正确；</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">504：调大 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">proxy_read_timeout</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，排查后端慢查询 / 程序卡死。</font>
3. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">403 错误：</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">先看 Nginx 日志（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/var/log/nginx/error.log</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）；</font>
   * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">检查文件权限（Nginx 进程用户是否有权限）、SELinux 状态（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">getenforce</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）。</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"></font>

# <font style="color:black;">HTTP工作原理</font>

<font style="color:black;"> HTTP（超文本传输协议）的核心工作逻辑是「</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">客户端 - 服务器</font>**<font style="color:black;"> 基于 TCP/IP 的请求 - 响应模型」  </font>

<font style="color:black;"></font>

<font style="color:black;">在用户点击URL为</font>[<u><font style="color:#009999;">http</font></u>](http://www.sxtyu.com/index.html)[<u><font style="color:#009999;">://www.qq.com/</font></u>](http://www.sxtyu.com/index.html)[<u><font style="color:#009999;">index.html</font></u>](http://www.sxtyu.com/index.html)<font style="color:black;">的链接后，浏览器和Web服务器执行以下动作</font><font style="color:black;">：</font>

![1583823128135-0b40108d-97a5-4245-aee4-04abdd82115b.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-02.png)

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">一、HTTP 完整工作流程（7 步核心）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">以「浏览器访问 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">http://www.baidu.com/index.html</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">」为例，一步一步讲清底层逻辑：</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">步骤 1：客户端解析域名（DNS 解析）</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：浏览器先查「域名→IP」（运维场景：可通过 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">nslookup/www.oldboy.com</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 验证解析是否正确）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">过程：本地 DNS 缓存 → 本地 DNS 服务器 → 根服务器 → 顶级域服务器 → 目标域名服务器，最终拿到服务器 IP（如 192.168.1.100）。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">步骤 2：建立 TCP 连接（三次握手）</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：HTTP 基于 TCP 协议（可靠传输），客户端和服务器的 80 端口（HTTP）/443 端口（HTTPS）建立连接；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维关注点：</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">三次握手失败 → 服务端 80/443 端口未监听（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ss -lntup | grep 80</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）、防火墙拦截；</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP/1.1 默认为</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">长连接（Keep-Alive）</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，一次 TCP 连接可处理多次 HTTP 请求（对比 HTTP/1.0 短连接，性能更高）。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">步骤 3：客户端发送 HTTP 请求</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：客户端（浏览器 /curl）向服务器发送「请求报文」，包含「要什么资源、用什么方式要、附带什么信息」；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">请求报文结构（运维抓包 / 用 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">curl -v</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 能直接看到）：</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">plaintext</font>

```plain
GET /index.html HTTP/1.1  # 请求行：方法（GET）+ 路径 + 协议版本
Host: www.oldboy.com      # 请求头：核心字段（Host指定虚拟主机，Nginx靠它匹配站点）
User-Agent: Chrome/120.0.0.0
Connection: Keep-Alive    # 要求长连接
# 空行（分隔请求头和请求体）
（请求体：GET无，POST/PUT才有，如表单数据）

```

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维关注点：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Host</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 字段错误 → 404/400 错误；请求方法被禁用（如 DELETE）→ 405 错误。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">步骤 4：服务器接收并处理请求</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：Web 服务器（Nginx/Apache）监听 80/443 端口，接收请求后做 3 件事：</font>
  1. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">解析请求头（如 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Host</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 匹配对应站点配置）；</font>
  2. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">处理请求（静态资源直接读取文件，动态资源转发给 PHP-FPM/Tomcat）；</font>
  3. <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">生成响应内容（HTML/JSON/ 图片）。</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维关注点：</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">静态资源找不到 → 404 错误（检查 Nginx </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">root</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 路径 / 文件权限）；</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">动态资源处理失败 → 500 错误（查后端程序日志）。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">步骤 5：服务器返回 HTTP 响应</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：服务器向客户端发送「响应报文」，包含「请求是否成功、返回什么内容、附带什么信息」；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">响应报文结构（运维排错核心）：</font><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">plaintext</font>

```plain
HTTP/1.1 200 OK           # 响应行：协议版本 + 状态码 + 描述（200=成功）
Server: nginx/1.20.1      # 响应头：服务器信息、缓存/压缩配置
Content-Type: text/html   # 返回内容类型（运维：类型错误→浏览器解析异常）
Content-Length: 1024      # 响应体大小
Cache-Control: max-age=86400  # 缓存策略
# 空行
<html>...</html>          # 响应体：实际返回的内容（页面/数据）
```

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维关注点：状态码是排错关键（如 502 = 后端服务挂了、304 = 缓存命中、403 = 权限不足）。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">步骤 6：关闭 / 复用 TCP 连接</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">短连接（HTTP/1.0 默认）：响应完成后，TCP 四次挥手关闭连接；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">长连接（HTTP/1.1 默认）：连接保持打开，客户端可继续发送新请求（运维配置：Nginx </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">keepalive_timeout 60s</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 控制超时时间）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维关注点：长连接配置过小 → TCP 握手频繁，性能下降；过大 → 连接堆积，占用端口。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">步骤 7：客户端渲染响应内容</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心：浏览器接收响应体后，解析 HTML/CSS/JS，加载图片等静态资源（静态资源会触发新的 HTTP 请求）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维关注点：静态资源加载慢 → 检查缓存 / 压缩配置、CDN 是否生效。</font>

<font style="color:black;"></font>

```bash
1.客户端输入域名以及请求的页面
2.本地会进行一次redirect跳转
3.解析域名对应的dns
4.最终客户端浏览器获取到dns的IP地址
5.客户端会与服务端发起TCP的三次握手（长连接）
6.客户端发起http请求，请求会先抵达前端的防火墙
7.防火墙识别用户身份，正常的请求通过内部交换机通过tcp连接后端的负载均衡，然后传递用户的http请求
8.负载接收到请求，会根据请求的内容进行下发任务，通过tcp连接后端的web，然后下发用户的http请求
9.web接收到用户的http请求后，会根据用户请求的内容进行解析，解析分为如下两步：
静态请求:由web服务器向nfs建立tcp连接，获取对应的图片，最后返回给负载均衡（负载均衡->防火墙->用户）
动态请求:有web向后端的动态程序建立TCP连接，将用户的动态http请求传递给动态程序->由动态程序进行解析 

10.动态程序在解析的过程中，如果碰到查询数据库的请求，则优先和缓存建立tcp的连接，然后缓存服务发起http的查询
11.如果缓存没有对应的数据，动态程序再次向数据库建立tcp的连接，然后发起查询操作。
12.由数据库返回->动态程序->缓存->web服务->负载均衡->防火墙->用户。

```

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">二、HTTP 核心特性（运维必懂）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">这些特性直接影响运维配置和故障排查，是理解「为什么这么配」的关键：</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 无状态（Stateless）</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">含义：HTTP 协议不记录前后请求的关联（比如第一次登录后，第二次请求服务器不知道你已登录）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维场景：</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">解决无状态：靠 Cookie/Session 维持登录态（排查登录失效 → 查 Cookie 是否携带、Session 配置）；</font>
  * <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">负载均衡场景：需配置「会话保持」（ip_hash），避免同一用户请求分发到不同后端服务器导致登录失效。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. 无连接（HTTP/1.0）→ 长连接（HTTP/1.1）</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无连接：每次请求都新建 TCP 连接，性能低（三次握手 / 四次挥手开销大）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">长连接：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Connection: Keep-Alive</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 让 TCP 连接复用，运维通过 Nginx </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">keepalive_requests 10000</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 配置单连接最大请求数，提升并发。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3. 明文传输（HTTP）→ 加密传输（HTTPS）</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTP：所有报文明文传输，容易被窃听 / 篡改（运维：生产环境必须禁用 HTTP，强制跳转 HTTPS）；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">HTTPS：HTTP + SSL/TLS 加密，运维需配置证书、禁用低版本 TLS（</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ssl_protocols TLSv1.2 TLSv1.3</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">4. 媒体无关性</font>

* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">含义：HTTP 可传输任意类型数据（HTML / 图片 / 视频 / JSON），靠 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Content-Type</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 标识；</font>
* <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">运维场景：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Content-Type</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 配置错误 → 浏览器下载图片（本该显示）、页面乱码（如 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">text/html</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 写成 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">application/json</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）。</font>

<font style="color:black;"></font>

<font style="color:black;"></font>

<font style="color:black;"></font>

# <font style="color:black;">访问网站分析 抓包分析</font>

<font style="color:black;">第一步：浏览器分析超链接中的URL</font>

<font style="color:black;">第二步：DNS请求               </font>

<font style="color:black;">PC向DNS服务器222.246.129.80发出DNS </font><font style="color:black;">QUERY请求，请求www.qq.com的A记录</font>

![1583823177003-f555d2f8-a5de-4f0b-b067-6a2268ff0ed0.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-03.png)

<font style="color:#0070C0;"></font>

<font style="color:black;">第三步：DNS回复</font>

<font style="color:black;">DNS服务器222.246.129.80回复DNS response,解析出www.qq.com域名对应的三条A记录59.37.96.63、14.17.42.40/14.17.32.211</font>

![1583823203216-bee3f6e0-f0b1-493e-a91d-98f796db4ac6.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-04.png)

<font style="color:black;">DNS的A记录：将主机名解析成对应的IP</font>

<font style="color:black;">第四步：PC向解析出的www.qq.com服务器地址发起tcp三次握手</font>

![1583823225582-47214f14-d826-421e-a21b-0edeb20dbeac.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-05.png)

<font style="color:black;">第五步：PC向</font>[<u><font style="color:#009999;">www.qq.com</font></u>](http://www.qq.com/)<font style="color:black;"> </font><font style="color:black;">服务器发出GET请求，请求主页</font>

![1583823245266-2aaa6495-7481-4acb-8d16-99595d1693a5.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-06.png)

<font style="color:black;">第六步：</font>[<u><font style="color:#009999;">www.qq.com</font></u>](http://www.qq.com/)<font style="color:black;"> </font><font style="color:black;">服务器回应HTTP</font><font style="color:black;">/1.1 200 </font><font style="color:black;">OK，返回主页数据包</font>

![1583823264628-8d28e3ed-0101-48e9-af9e-6c5e201bc5f2.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-07.png)

<font style="color:black;">第七步：完成数据交互过程，四次挥手断开连接</font>

#

## <font style="color:black;">POST请求方法 </font>

<font style="color:black;">POST - </font><font style="color:black;">向指定的资源提交要被处理的数据</font>

![1583823397939-73e2d331-2082-4a7b-9729-2df9f27fd1ea.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-08.png)

#

## <font style="color:#0070C0;"> </font><font style="color:black;">HTTP头部</font>

<font style="color:black;">首部字段或消息头</font>

| <font style="color:#262626;">头(header)</font> | <font style="color:#262626;">类型</font> | <font style="color:#262626;">说明</font> |
| :--- | :--- | :--- |
| <font style="color:red;">User-   Agent</font> | <font style="color:black;">请求</font> | <font style="color:black;">关于浏览器和它平台的信息，如Mozilla5.0</font> |
| <font style="color:#7F7F7F;">Accept</font> | <font style="color:black;">请求</font> | <font style="color:black;">客户能处理的页面的类型，如text/html</font> |
| <font style="color:#7F7F7F;">Accept-Charset</font> | <font style="color:black;">请求</font> | <font style="color:black;">客户可以接受的字符集，如Unicode-1-1</font> |
| <font style="color:#7F7F7F;">Accept-Encoding</font> | <font style="color:black;">请求</font> | <font style="color:black;">客户能处理的页面编码方法，如gzip</font> |
| <font style="color:#7F7F7F;">Accept-Language</font> | <font style="color:black;">请求</font> | <font style="color:black;">客户能处理的自然语言，如en(英语)，zh-cn(简体中文）</font> |
| <font style="color:#7F7F7F;">Host</font> | <font style="color:black;">请求</font> | <font style="color:black;">服务器的DNS名称。从URL中提取出来，必需。</font> |
| <font style="color:red;">Referer</font> | <font style="color:black;">请求</font> | <font style="color:black;">用户从该URL代表的页面出发访问当前请求的页面</font> |
| <font style="color:#7F7F7F;">Cookie</font> | <font style="color:black;">请求</font> | <font style="color:black;">将以前设置的Cookie送回服务器器，可用来作为会话信息</font> |
| <font style="color:#19194D;">Date</font> | <font style="color:black;">双向</font> | <font style="color:black;">消息被发送时的日期和时间</font> |
| <font style="color:red;">Server</font> | <font style="color:black;">响应</font> | <font style="color:black;">关于服务器的信息，如Microsoft-IIS</font><font style="color:black;">/6.0</font> |
| <font style="color:#4597A0;">Content-Encoding</font> | <font style="color:black;">响应</font> | <font style="color:black;">内容是如何被编码的（如gzip</font><font style="color:black;">)</font> |
| <font style="color:#4597A0;">Content-Language</font> | <font style="color:black;">响应</font> | <font style="color:black;">页面所使用的自然语言</font> |
| <font style="color:#4597A0;">Content-Length</font> | <font style="color:black;">响应</font> | <font style="color:black;">以字节计算的页面长度</font> |
| <font style="color:#4597A0;">Content-Type</font> | <font style="color:black;">响应</font> | <font style="color:black;">页面的MIME类型</font> |
| <font style="color:#4597A0;">Last-Modified</font> | <font style="color:black;">响应</font> | <font style="color:black;">页面最后被修改的时间和日期，在页面缓存机制中意义重大</font> |
| <font style="color:red;">Location</font> | <font style="color:black;">响应</font> | <font style="color:black;">指示客户将请求发送给别处，即重定向到另一个URL</font> |
| <font style="color:red;">Set-Cookie</font> | <font style="color:black;">响应</font> | <font style="color:black;">服务器希望客户保存一个Cookie</font> |

## <font style="color:black;">UA字段</font>

<font style="color:black;">User-Agent: </font>[<u><font style="color:#009999;">浏览器</font></u>](http://baike.baidu.com/item/%E6%B5%8F%E8%A7%88%E5%99%A8)<font style="color:black;">标识</font><font style="color:black;"> (</font>[<u><font style="color:#009999;">操作系统</font></u>](http://baike.baidu.com/item/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F)<font style="color:black;">标识</font><font style="color:black;">; </font><font style="color:black;">加密等级标识</font><font style="color:black;">; </font>[<u><font style="color:#009999;">浏览器</font></u>](http://baike.baidu.com/item/%E6%B5%8F%E8%A7%88%E5%99%A8)<font style="color:black;">语言</font><font style="color:black;">) </font><font style="color:black;">渲染引擎标识</font><font style="color:black;"> </font><font style="color:black;">版本信息</font>

![1583823567959-7344a2fa-9037-4549-ac00-3b2c63d97b71.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-09.png)

## <font style="color:black;">SERVER字段</font>

<font style="color:black;">Server：响应头包含处理请求的原始服务器的软件信息</font>

![1583823610415-d7e42d11-facf-488c-b802-3caf2568edca.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-10.png)

<font style="color:#0070C0;"></font>

## <font style="color:black;">Referer字段</font>

<font style="color:black;">Referer：浏览器向</font><font style="color:black;"> WEB </font><font style="color:black;">服务器表明自己是从哪个</font><font style="color:black;"> </font><font style="color:black;">网页</font><font style="color:black;">/URL </font><font style="color:black;">获得</font><font style="color:black;">/</font><font style="color:black;">点击</font><font style="color:black;"> </font><font style="color:black;">当前请求中的网址</font><font style="color:black;">/URL。</font>

![1583823645002-f0440dc5-51bb-43f3-b130-b4c04435164e.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-11.png)

<font style="color:#0070C0;"></font>

![1583823651593-dd01314e-9217-45e7-9a6b-6da61b9df89b.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-12.png)<font style="color:#0070C0;"></font>

## <font style="color:black;">HTTP重定向</font>

<font style="color:black;">Location：WEB</font><font style="color:black;"> </font><font style="color:black;">服务器告诉浏览器，试图访问的对象已经被移到别的位置了，到该头部指定的位置去取</font><font style="color:black;">。</font>

![1583823684324-0547e0fe-ea6f-44b5-a1d0-7586e3004633.png](img/%E7%AC%AC%E4%BA%8C%E9%98%B6%E6%AE%B5-web%E5%9F%BA%E7%A1%80%E4%B9%8Bhttp-13.png)

<font style="color:#0070C0;"></font>

<font style="color:#0070C0;"></font>

<font style="color:#0070C0;"></font>


> 更新: 2026-05-04 17:10:01  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/gpo7u6>