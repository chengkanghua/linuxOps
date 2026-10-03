# 第六章·Web基础之http协议

## Http协议介绍

<!-- OCR_START -->
| 排名 | 名称 |
| --- | --- |
| HTTP简介 | HTTP报文结构 |
| 2 | 1 |
| 3 | HTTP的工作原理 |
<!-- OCR_END -->

`HTTP` 全称：`Hyper Text Transfer Protocol` 中文名：超文本传输协议

***

| 什么是超文本 |
| :--- |

包含有超链接(Link)和各种多媒体元素标记(Markup)的文本。这些超文本文件彼此链接，形成网状(Web)，因此又被称为网页(Web Page)。这些链接使用URL表示。最常见的超文本格式是超文本标记语言HTML。

>  
>
> html文件->包含各种各样的元素（URL链接）->形成WebPage简称web页面

***

| 什么是URL |
| :--- |

`URL`即统一资源定位符(Uniform Resource Locator)，用来唯一地标识万维网中的某一个文档。

`URL`由协议、主机和端口(默认为80)以及文件名三部分构成:

<!-- OCR_START -->
- http://www.driverzeng.com:80/news/index.html
- 协议：//
- 主机：端口（80）/
- 文件名及其路径
<!-- OCR_END -->

***

| 什么是超文本传输协议 |
| :--- |

是一种按照URL指示，将超文本文档从一台主机(Web服务器)传输到另一台主机(浏览器)的应用层协议，以实现超链接的功能。

## Http工作原理

<!-- OCR_START -->
- 请求/响应交互模型
- 客户机(浏览器)
- Web服务器
- www.driverzeng.com
- 在用户点击URL为
- HTTP over TCP
- tml的链接后，浏览器和Web服务器执
- TCP连接
- 行以下动作：
- 浏览器分析超链接中的URL
- IP:222.246.129.8
- Index.html
- Internet
- 浏览器向DNS请求解析
- www.oldboy.com的IP地址
- DNS将解析出的IP地址
- 建立TCP连接
- 222.246.129.80返回浏览器
- 浏览器与服务器建立TCP连接（80端口）
- 请求文档
- 5
- HTTP请求报文
- 浏览器请求文档：GET/index.html
- 服务器给出响应，将文档
- 6
- 响应文档
- index.html发送给浏览器
- HTTP响应报文
- 释放TCP连接
- 浏览器显示index.html中的内容
- nttps://www.driverzeng.com
<!-- OCR_END -->

1.首先，当你在浏览器中输入一个网址的时候（https://www.baidu.com) 浏览器会帮你分析，你输入的这个URL

2.其次，浏览器会向DNS服务器请求解析，该URL中的域名www.baidu.com,解析出百度服务器所在的IP地址

3.DNS服务器，会将解析出来的IP地址`110.111.112.113`并返回给浏览器。

4.浏览器接收到DNS返回的IP地址，立即与该IP所在的服务器建立TCP连接（80端口）。

5.浏览器请求文档，也就是咱们常说的html页面，GET /index.html，并发出HTTP请求报文。

6.服务器给出响应，将请求的index.html文档返回给浏览器，也就是响应HTTP请求的报文。

7.TCP连接响应完之后，释放TCP连接。

8.最后就能显示出，你请求的这个页面了

《单身狗版HTTP工作原理》

单身狗刘大哥：浏览器饰

中介大哥：DNS饰

小姐姐照片：URL饰

小姐姐：服务器饰

1.首先作为单身狗的浏览器，在拿到一个`URL`（小姐姐照片）之后，先分析（意淫）...身材，脸蛋emmmmm...不可描述。

2.然后找到`DNS`（中介大哥），哥，你把这个小姐姐的,电话，微信，QQ...发给我呗

3.`DNS`（中介大哥），开始找，这个小姐姐的信息...找到手机号`110.111.112.113`返回给这个姓刘的单身狗（浏览器）

4.刘大哥拿到手机号之后，欣喜若狂，于是就开始打电话（建立TCP连接）给小姐姐。

5.刘大哥，打电话，给小姐姐，发出邀约请求（HTTP请求报文，GET /index.html）我们见一面吧，电影院，公园，酒店...都可以。

6.小姐姐，回应刘大哥的请求，（HTTP响应报文）现在是大夏天的公园热，电影院又黑，我怕黑...那就酒店见吧，你开好房间等我。

7.挂掉电话，（释放TCP连接）

8.刘大哥和小姐姐，在酒店见面，关好门，拉上窗帘，掀开被子，在床上，进入被窝，刘大哥掏出.........自己的手表，你看我的手表是夜光的（显示html页面）...活该单身

## 访问网站分析

| 1.浏览器分析超链接中的URL |
| :--- |

一个`URL`有可能会很长，以 `&` 为分隔符每一个`&`后面都是一个参数，如下所示：

<https://www.baidu.com/s?ie=utf-8>

\&f=8

\&rsv_bp=1

\&rsv_idx=1

\&tn=baidu

\&wd=%E6%9B%BE%E8%80%81%E6%B9%BF

\&rsv_pq=c177c4df0026ba3e

\&rsv_t=e001VxO8FQ8I6s1o1i0km8IYEX2%2F7PwwkwTB6FC%2FXU9Mmwz24Z4i%2BnYoP0I\&rqlang=cn\&rsv_enter=1

\&rsv_dl=tb

\&rsv_sug2=0

\&inputT=1729

\&rsv_sug4=1728

***

| 2.请求DNS |
| :--- |

PC（电脑）向DNS服务器`110.111.112.113`发出`DNS QUERY`请求，请`www.driverzeng.com`的`A`记录。

<!-- OCR_START -->
dns
Expressior
No.
Time0
Sourceu
[Destination.
122 24.793945
192.168.1.102
10.64.0.10
73Standard query 0xc26eAww.baidu.com
12324.800269
310Standard query_response 0xc26e A www.baidu.com
CNAMEwww.a.shifen.comA182.61.200.7A182.61.200.6NSns2.a.shifen.com NSns4.a.shif
22426.125456
78Standard query 0xdc75A www.driverzeng.com
225 26.131212
488Standardquery response 0xdc75Awww.driverzeng.comCNAMEwww.driverzeng.com.w.kunlungr.comA 45.253.17.211A 45.253.17.216A 45.253
277 26.633624
67 Standard query 0x979a A s.w.org
278 26.640813
349 Standard query
yresponse0x979a A s.w.orgA 192.0.77.48NSns2.wordpress.org NSns3.wordpress.org NS ns1.wordpress.org NS ns4.wordpres
419
45.029273
96 Standard query
y0xb6edPTRb._dns-sd._udp.0.0.0.10.in-addr.arpa
42045.029273
97 Standard query
0x9d61 PTR db._dns-sd._udp.0.0.0.10.in-addr.arpa
421
45.029300
97 Standard query0xf637PTRlb._dns-sd._udp.0.0.0.10.in-addr.arpa
422 45.035187
104 Standard query
response 0xb6ed No such name PTR b._dns-sd._udp.0.0.0.10.in-addr.arpa
423 45.036606
105 Standard query
response 0x9d61 No such name PTR db._dns-sd._udp.0.0.0.10.in-addr.arpa
424 45.036611
yresponse 0xf637 No such name PTR lb._dns-sd._udp.0.0.0.10.in-addr.arpa
433 47.637295
72 Standardquery0xe5b7A sqimg.qq.com
43847.649028
481 Standardqueryresponse0xe5b7A sqimg.qq.com CNAME sqimg.qq.com.cloud.tcdn.qq.com CNAME sqimg.qq.com.tc.qq.com CNAMEx2.tcdn.qq.com
514 71.138336
79 Standard query 0x238eA clients4.google.com
515 71.150232
375 Standard query responseOx238eAclients4.google.com CNAMEclients.l.google.comA 172.217.160.78NSns3.google.com NSns2.google.com
Source:Apple_2a:78:eb (f0:18:98:2a:78:eb)
Type:IPv4(0x0800)
Internet Protocol Version 4,Src: 192.168.1.102,Dst: 10.64.0.10
0100....=Version:4
....
0101= Header Length:20 bytes (5)
Differentiated Services Field:Oxoo (DSCP:CSO,ECN:Not-ECT)
Total Length:64
Identification:0x20d3（8403)
Flags:0x0000
..000000000 0000=Fragmentoffset:0
Time tolive:64
Protocol:UDP(17)
Header checksum:0x8d82[validation disabled]
[Header checksum status:Unverified]
Source:192.168.1.102
Destination: 10.64.0.10
User Datagram Protocol, Src Port:12803,Dst Port:53
Source Port: 12803
Destination Port:53
Length:44
Checksum:0xa60f[unverified]
[Checksum Status:Unverified]
[Stream index:8]
[Timestamps]
Domain Name System(query)
Transaction ID:Oxdc75
Questions:1
Authority RRs:0
Additional Rs:0
Queries
www.driverzeng.com:type A,class IN
[Response In:225]
bc4699b7f036f018982a78eb08004500
F...6..
*X...E
22(4.2%)
<!-- OCR_END -->

***

| 3.DNS回复 |
| :--- |

DNS服务器,回复 `DNS response`，解析出www.driverzeng.com域名对应的三条 `A` 记录

`45.253.17.216`

`45.253.17.213`

`45.253.17.211`

<!-- OCR_START -->
dns
→Expression
No.
Time
Source
Destination
Protocol|Lengtl|Info
205
3.818847
192.168.1.102
10.64.0.10
73Standardquery0xb367Aww.baidu.com
2063.824412
310 Standard query response 0xb367 A www.baidu.com CNAME www.a.shifen.com A 182.61.200.7A 182.61.200.6NS ns1.a.shifen.com NS ns4.a.shif.
3255.142852
95 Standard query 0x844fA content-signature-2.cdn.mozilla.net
3265.149108
492Standard query response 0x844f A content-signature-2.cdn.mozilla.net CNAME d2nxq2uap88usk.cloudfront.net A 13.225.103.116 A 13.225.10
4828.286673
78Standard query 0x2e4fAww.driverzenq.com
4838.292363
488Standard query response 0x2e4fA www.driverzeng.comCNAMEwww.driverzeng.com.w.kunlungr.comA 45.253.17.216A 45.253.17.213A 45.253.
5318.893650
79 Standard query 0xea79 A rf.revolvermaps.com
5358.898354
189 Standard query response 0xea79 A rf.revolvermaps.com A 185.44.104.99 NS ns1.hans.hosteurope.de NS ns2.hans.hosteurope.de A 217.115.14
29642.619910
79 Standard query 0x4645A clients4.google.com
296.
42.625655
375 Standard query response 0x4645 A clients4.google.com CNAME clients.l.google.com A 172.217.160.78 NS ns1.google.com NS ns2.google.com
Source: 10.64.0.10
Destination:192.168.1.102
User Datagram Protocol, Src Port:53,Dst Port:57400
Source Port:53
Destination Port:57400
Length:147
Checksum:0x6714[unverified]
[Checksum Status:Unverified]
[Stream index:3]
[Timestamps]
Domain Name System (response)
Transaction ID:0xea79
Flags:0x8180 Standard query response, No error
Questions:1
AnswerRRs:1
Authority RRs:2
Additional RRs:2
Queries
rf.revolvermaps.com:type A,class IN
Name:rf.revolvermaps.com
[Name Length:19]
[Label Count:3]
Type:A（Host Address）（1)
Class:IN(0x0001)
Answers
rf.revolvermaps.com: type A,class IN，addr 185.44.104.99
Authoritative nameservers
revolvermaps.com: type Ns, class IN,ns ns1.hans.hosteurope.de
Additionalrecords
ns1.hans.hosteurope.de: type A, class IN, addr 217.115.143.140
ns2.hans.hosteurope.de:type A, class IN, addr 80.237.128.10
[Request In:531]
[Time:0.004704000 seconds]
00906e7332c045c0 41 0001 00 010000 000b00ns2·E·A.........
Textitem（text）,16bytes
Packets:30159·Di
ayed:10(0.0%)
<!-- OCR_END -->

***

| 4.建立TCP连接 |
| :--- |

PC向解析出的www.driverzeng.com服务器地址发起tcp三次握手

<!-- OCR_START -->
- tcpl
- →Expresson.
- No
- |Time
- Source
- Destination
- IProtocolLengttIinfo
- 5416.904847
- 192.168.1.102
- 35.186.232.39
- TCP
- 7862794443 [SYN,ECN,CWR] Seq=0 Win=65535Len=0 MSS=1460 WS=64 TSval=862892622TSecr=0 SACK_PERM=1
- 5516.963860
- 82 443+62794 [SYN,ACK] Seq=0 Ack=1 Win=60192 Len=0 MSS=1380 SACK_PERM=1 TSval=577629172 TSecr=862892622 WS=256
- 56 16.963907
- 66 62794→443[ACK]Seq=1 Ack=1Win=131328 Len=0 TSval=862892680 TSecr=577629172
<!-- OCR_END -->

***

| 发起HTTP请求报文 |
| :--- |

PC向www.driverzeng.com服务器发出GET请求，请求主页面

<!-- OCR_START -->
```http
Whttp
No
Time
Source
Destination
Protocol|Lengtt|Info
489-450.178311
192.168.1.102
45.253.17.214
HTTP
431GET/HTTP/1.1
492-450.035977
45.253.17.214
192.168.1.102
HTTP
725HTTP/1.1302MovedTemporarily
（text/html)
301
-394.184898
192.168.1.102
104.99.238.122
HTTP
413 GET/success.txt HTTP/1.1
301..
-393.915602
104.99.238.122
192.168.1.102
HTTP
458HTTP/1.12000K（text/plain）
307..
-344.455558
192.168.1.102
104.99.238.122
HTTP
413 GET/success.txt HTTP/1.1
308.
-344.187961
104.99.238.122
192.168.1.102
HTTP
458HTTP/1.12000K
(text/plain)
309..
-335.119102
192.168.1.102
36.110.170.58
HTTP
812POST/q HTTP/1.1
309
-335.074496
36.110.170.58
192.168.1.102
HTTP
320 HTTP/1.12000K
309..
-334.760120
192.168.1.102
36.110.170.58
HTTP
836POST/qHTTP/1.1
309..
-334.715282
36.110.170.58
192.168.1.102
HTTP
404HTTP/1.12000K
313..
-275.513594
192.168.1.102
182.254.21.82
HTTP
410 GET/cgi-bin/micromsg-bin/newgetdns?uin=2426324107&clientversion=302191122&scene=0&net=1&md5=db4a8b1a573f5a359f7abf9534ed0bc1&devicet..
313..
-275.506386
192.168.1.102
121.51.130.113
HTTP
754POST/mmtls/6640b90eHTTP/1.1
313.
-275.463089
182.254.21.82
192.168.1.102
HTTP/...
1412 HTTP/1.0 2000K
313
-275.395650
121.51.130.113
192.168.1.102
HTTP
1122 HTTP/1.1 200 0K
324-23.531971
192.168.1.102
211.159.235.178
HTTP
748POST/qHTTP/1.1
324..
-23.486561
211.159.235.178
192.168.1.102
HTTP
384HTTP/1.12000K
324-4.872129
121.51.90.164
192.168.1.102
TCP
1502 8080-52572[ACK] Seq=14105Ack=1480Win=63Len=1440
Type:IPv4(0x0800)
Internet Protocol Version 4,Src:192.168.1.102, Dst:45.253.17.214
0100....=Version:4
0101=Header Length:20 bytes （5)
Differentiated Services Field:Oxo0 (DSCP:CS0,ECN:Not-ECT)
TotalLength:417
Identification:0x0000（0)
Flags:0x4000,Don't fragment
..00000 00000000=Fragmentoffset:0
Time to live:64
Protocol:TCP（6)
Header checksum:0x3776[validation disabled]
[Header checksum status:Unverified]
Source: 192.168.1.102
Destination:45.253.17.214
Transmission Control Protocol,Src Port:63688,Dst Port:80,Seq:1,Ack:1,Len:377
Hypertext Transfer Protocol
GET/HTTP/1.1\r\n
[Expert Info（Chat/Sequence):GET/HTTP/1.1\r\n]
Request Method: GET
RequestURI:/ Request Version:HTTP/1.1
Host:ww.driverzeng.com\r\n
User-Agent: Mozilla/5.0 (Macintosh; IntelMac 0SX 10.14; V:68.0)Gecko/20100101
Firefox/68.0\r\n
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n
Accept-Language:zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2\r\n
Accept-Encoding:gzip, deflate\r\n
Connection:keep-alive\r\n
Upgrade-Insecure-Requests:1\r\n
Ar\n
[Full request URI:http://www.driverzeng.com/]
[HTTP request 1/1]
[Response in frame: 492]
0000bc4699b7f036f018982a78eb08004500
.F...6..·*X..·E·
viresharkWi-Fi20190803140152_ge
d:17(0.0%)
```
<!-- OCR_END -->

***

| 5.服务器回应 |
| :--- |

[www.driverzeng.com服务器回应HTTP/1.1](http://www.driverzeng.xn--comhttp-2k1lx4zz7ao08cthx/1.1) 302 `这里302`是我做了跳转所以显示的是302，返回主页数据包，正常来说可以看到图中，下面的有些网站返回的是 HTTP/1.1 200 OK `200`是正确访问的状态码

<!-- OCR_START -->
```http
Whttp
X→Expressio
No.
Time
Source
Destination
Protocol|Lengt|Info
489-450.178311
192.168.1.102
45.253.17.214
HTTP
431GET/HTTP/1.1
492-450.035977
45.253.17.214
192.168.1.102
HTTP
725HTTP/1.1302Moved Temporarily(text/html)
301..
-394.184898
192.168.1.102
104.99.238.122
HTTP
413 GET/success.txt HTTP/1.1
301.
-393.915602
104.99.238.122
192.168.1.102
HTTP
458HTTP/1.12000K
(text/plain)
307.
-344.455558
192.168.1.102
104.99.238.122
HTTP
413 GET/success.txt HTTP/1.1
308..
-344.187961
104.99.238.122
192.168.1.102
HTTP
458
HTTP/1.12000K
(text/plain)
309.
-335.119102
192.168.1.102
36.110.170.58
HTTP
812
POST/qHTTP/1.1
309.
-335.074496
36.110.170.58
192.168.1.102
HTTP
320HTTP/1.12000K
309
-334.760120
192.168.1.102
36.110.170.58
HTTP
836POST/qHTTP/1.1
309.
-334.715282
36.110.170.58
192.168.1.102
HTTP
404HTTP/1.1200OK
313.
-275.513594
192.168.1.102
182.254.21.82
HTTP
410 GET/cgi-bin/micromsg-bin/newgetdns?uin=2426324107&clientversion=302191122&scene=0&net=1&md5=db4a8b1a573f5a359f7abf9534ed0bc1&devicet
313.
-275.506386
192.168.1.102
121.51.130.113
HTTP
754POST/mmtls/6640b90eHTTP/1.1
313.
-275.463089
182.254.21.82
192.168.1.102
HTTP/.
1412 HTTP/1.02000K
313..
-275.395650
121.51.130.113
192.168.1.102
HTTP
1122 HTTP/1.1 2000K
324
-23.531971
192.168.1.102
211.159.235.178
HTTP
748POST/qHTTP/1.1
324.-23.486561
211.159.235.178
192.168.1.102
HTTP
384 HTTP/1.12000K
324-4.872129
121.51.90.164
192.168.1.102
TCP
1502 8080→52572 [ACK] Seq=14105 Ack=1480Win=63 Len=1440
Destination:192.168.1.102
Transmission Control Protocol, Src Port:80,Dst Port:63688,Seq:1,Ack:378,Len:663
Hypertext Transfer Protocol
HTTP/1.1302MovedTemporarily\r\n
[ExpertInfo(Chat/Sequence):HTTP/1.1302Moved Temporarily\r\n]
[HTTP/1.1302Moved Temporarily\r\n]
[Severity level: Chat]
[Group:Sequence]
Response Version:HTTP/1.1
Status Code:302
[Status Code Description: Found]
Response Phrase:Moved Temporarily
Server:Tengine\r\n
Content-Type:text/html\r\n
Content-Length:154\r\n
[Content length:154]
Connection:keep-alive\r\n
Date:Sat,03Aug 201906:02:01 GMT\r\n
Location:https://www.driverzeng.com/r\n
Ali-Swift-Global-Savetime:1564812121\r\n
Via:cache14.12cm12[18,302-0,M],cache12.12cm12[19,0],cache13.cn1300[113,302-0,M],cache3.cn1300[115,0]\r\n
X-Cache:MISSTCP_MISS dirn:-2:-2\r\n
X-Swift-SaveTime:Sat,03Aug201906:02:01GMT\r\n
X-Swift-CacheTime:0\r\n
Timing-Allow-0rigin:*\r\n
EagleId:2dfd119715648121213585040e\r\n
Ir\n
[HTTP response 1/1]
[Time since request:0.142334000 seconds]
[Request in frame:489]
[Request URI:http://www.driverzeng.com/]
File Data:154bytes
Line-based text data:text/html(7lines)
0000f018982a78ebbc4699b7f03608004500
··*X··F...6.·E·
vireshark_Wi-Fi_20190803140152_qewGOR.pcapnc
Packets:37726-Displayed:19(0.1%)
```
<!-- OCR_END -->

下图中

`GET`那一部分内容被称为：请求头信息

`GET`和`HTTP`之间有一个空行被称为：请求空行

`HTTP`中的信息被称为：回应信息

`HTTP`与`faa`之间也有个空行被称为：响应空行

`faa`部分被称为：主体

<!-- OCR_START -->
```http
GET/HTTP/1.1
Accept:text/html,appl1catlon/xhtml+xml,*/* Accept-Language: zh-CN
User-Agent:Mozi1la/4. (compatible;MSIE 7.0;Windows NT 6.3;WOW64;Trident/7.0;.NET4.0E;.NET4.CC;.NET CLR
3.5.38729;.NET CLR2.0.50727;
.NET CLR 3.0.3e729;max-meeting-user)
Host：www.qq.com
Accept-Encoding:gzip,deflate
Connection:Keep-Alive
DNT:1
HTTP/1.12000K
Server: squid/3.5.20
Date:Fr1,11 Nov201607:36:06GMT
Transfer-Encoding:chunked
Content-Type:text/html;charset=GB2312
Connection:keep-alive
Vary: Accept-Encoding
Cache-Control:max-age=60
Expires: Fr1, 11 Nov 2016 e7:37:06 GMT
Vary:Accept-Encoding
Content-Encoding:gzip
X-Cache:MISS from shenzhen.qq.com
..-yW.G.(.7>..1.8..^..K.. t.2.T1JUE-BB ]2*..Un...
.l(v... ...）..T...M.7. -.]*6.K.
.R.b.
...2.P...(Y.o.uwb....M......F..
5...NOz]
hittps://www.driverzeng.com
R..}b
..XW..
f..cf.
+.cfvl.i.
```
<!-- OCR_END -->

***

| 6.完成响应 |
| :--- |

最后完成了数据的交互过程，TCP建立的连接经过三次握手之后，还要经过四次挥手，断开连接

下图所示：为什么有的时候状态码是200 有的时候是304？

<!-- OCR_START -->
| DBA老司机带你删库到跑路 | DBA老司机带你删库到跑路 | DBA老司机带你删库到跑路 | 排名 | DBA老司机带你删库到跑路 | DBA老司机带你删库到跑路 |
| --- | --- | --- | --- | --- | --- |
| zabbix-api | 文件存储 | 面试技巧 | 关于我 | Elements | SourcesNetworkPerformance |
| Memory | Application | Security | Audits | \| Q\| View: = =  Group by frame \|  Preserve log  Disable cache \|  offine No throtting | Fiter |
| Hide dataURLs A\| XHR JS CSS Img Media Font Doc WS Manifest Other | 200ms | 400ms | 600 ms | 800ms | 1000ms |
| 1200ms | 1400ms | 1600ms | 1800ms | 2000ms | 2200ms |
| 2400ms | 2600ms | 2800ms | 3000ms | 3200ms | 3400 ms |
| 3600ms | 3800ms | 4000ms | 4200ms | 4400 ms | 4600ms |
| 4800ms | Name | Status | Type | Initiator | Size |
| Time | fontawesome-webfont.wof2?v=4.7.0 | 200 | font | jguery.min.js?ver=2.0.0:6 | (memory cache) |
| 0 ms | 1 | back16.gif | 200 | gif | (memory cache) |
| 0ms | (index) | daohang6.gif | 304 | gif | (index) |
| 144 B | 24 ms | c.php?i=56tb40tpvmp | 200 | gif | 8.js?i=56tb40tpyp8m18=f08crfff8-arial8l |
| (memory cache) | 0ms | r.php?i=56tb40tpvmp&l=https%3A%2F%2Fwww.driverzeng.com%2F&r=1564813790523 | 200 | gif | 8.js?i56tb40tpvmp8m=18c=f08cer1=f=-arial8l |
| 216B | 919ms | h-code.js | 200 | script | index.js?ver=1.0.0:540 |
| (memory cache) | 0ms | thumbnail.png | 200 | png | jquery.min.js?ver=2.0.0:5 |
| (memorycache) | 0ms | %E5%BF%83%E7%81%B5%E9%B8%A1%E6%B1%A4.jpeg | 200 | jpeg | jquery.min.js?ver=2.0.0:5 |
| (memory cache) | 0 ms | devops.png | 200 | png | jquerymin.js?ver=2.0.0:5 |
| (memorycache) | 0ms | 15568609316561.jpg | 304 | jpeg | jgquery.min.js?ver=2.0.0:5 |
| 218B | 27ms | a2.ph?i=56b40tpvmp&m=1&c=f008cr=ff&f=arial83 | 200 | document | 8.js:1 |
| (disk cache) | 1ms | favicon.ico | 200 | x-icon | Other |
| 2.2KB | 26ms | cropped-2-32x32.png | 200 | png | Other |
| (diskcache) | 1ms | aphp?i=56tb40tpvmp&r=al3w | 200 | xhr | a2.php?i=56tb40tpyvmp&m=1&c=ff00008cr1=fff&f=ari.. |
| 238B | 1.95 s | 1024 | 200 | jpeg | a2.php?i=56tb40tpvmp&m=1&c=ff0000&cr1=fff8f=ari.. |
| 20.3KB | 1.18 s | cn.png | 200 | png | a2.php?56tb40tpyp8m18c=f008ocrff8-ar.. |
| (diskcache) | 1ms | b.php?i=56tb40tpvmp&t=0 | 200 | xhr | a2.php?i=56tb40tpymp8m=18c=f008ocr=f8f=-ar |
| (disk cache) | 1ms | b.php?i=56tb40tpvmp&t=pvne1n&r=jhcd | 200 | xhr | a2.php?i=56tb40tpvmp&m=1&c=ff0000&cr1=fff8f=ari.. |
| 206B | 310ms | 38requests\|33.4KB transferred | 24.8MBres | cesFinish:4.25 s\|DOMContentLoa | aded:329ms |
<!-- OCR_END -->

<!-- OCR_START -->
| 排名 | DBA老司机带你删库到跑路 - A × | DBA老司机带你删库到跑路 - A × | DBA老司机带你删库到跑路 - A × | DBA老司机带你删库到跑路 - A × | DBA老司机带你删库到跑路 - A × |
| --- | --- | --- | --- | --- | --- |
| 应用TTTSzabbix-api | 文件存储 | 面试技巧 | 关于我 | Elements | Sources |
| Network | Performance | Memory | Application | Security | Audits |
| \|Q\|View: Group byframe \| Preserve log  Disablecache \| Ofline No throting | Fitter | Hide data URLs AI XHR JS CSS Img Media Font Doc WS Manifet Other | 500ms | 1000ms | 1500ms |
| 2000ms | 2500 ms | 3000ms | 3500 ms | 4000 ms | 4500ms |
| 5000ms | 5500 ms | 6000ms | 6500ms | 7000ms | 7500 ms |
| 8000ms | 8500ms | 9000ms | 9500 | Name | Status |
| Type | Intator | Size | Time | Waterfll | wp-embed.min.js?ver=4.9.10 |
| 200 | script | (index) | 1.6 KB | 31ms | back16.gif |
| 200 | gif | (index) | 17.7 MB | 2.56 s | daohang6.gif |
| 200 | gif | (index) | 5.0MB | 1.18 s | fontawesome-webfont.woff2?v=4.7.0 |
| 200 | font | (index) | 75.7KB | 33ms | h-codejs |
| 200 | script | index.js?ver=1.0.0:540 | 42.8 KB | 131 ms | thumbnail.png |
| 200 | png | jgquery.min.js?ver=2.0.0:5 | 51.3KB | 124 ms | %E5%BF%83%E7%81%B5%E9%B8%A1%E6%B1%A4.jpeg |
| 200 | jpeg | jguery.min.js?ver=2.0.0:5 | 174KB | 142 ms | devops.png |
| 200 | png | jquery.min.js?ver=2.0.0:5 | 54.5 KB | 153ms | 15568609316561.jpg |
| 200 | jpeg | jquery.min.js?ver=2.0.0:5 | 637 KB | 328ms | c.php?i=56tb40tpvmp |
| 200 | gif | 8.js?i=56tb40tpvmp&m=18c=ff0008cr1=fff8f=aria. | 289B | 259ms | r.php?i=56tb40tpymp&l=https%3A%2F%2Fwww.drivereng.com%2F&r=1564813833628 |
| 200 | gif | 8.js?i=56tb40tpvmp&m=1&c=f0008cr1=ff8f=arial8l.. | 215B | 508ms | a2.p?-56tb40tpvmp8m18c=f8cr=ff=-arial833 |
| 200 | document | 8.js:1 | 9.7KB | 4.90 s | favicon.ico |
| 200 | x-icon | Other | 2.4 KB | 30 ms | cropped-2-32x32.png |
| 200 | png | Other | 2.6KB | 31ms | a.php?i=56tb40tpvmp&r=vg8l |
| 200 | xhr | a2.php?i-56tb40tpymp8m=18c=f008cr1=f8f-ari. | 238B | 1.05 s | 1024 |
| 200 | jpeg | a2.php?i-56tb40tpvmp8m=18c=f008cr=f8f-ar. | 32.3KB | 2.10 s | cn.png |
| 200 | png | a2.php?i=56tb40tpvmp&m=1&c=ff0008cr1=ff&f=-ari. | 639B | 267 ms | b.php?i=56tb40tpvmp&t=0 |
| 200 | xhr | a2.php?i=56tb40tpyvmp&m=18&c=ff00008cr1=ff8f=ari. | 395B | 267ms | 37 requests \| 24.5 MB transfered |
<!-- OCR_END -->

***

| 页面请求信息解析 |
| :--- |

<!-- OCR_START -->
- TS
- 步入社会的你要做到以下几点，句
- 句句入骨12
- 曰一
- Elements
- Sources
- Performance
- Memory Appliation Security Audits
- View：
- Group by frame | Preserve log  Disable cache |  Offline No throtting
- Hide data URLsAxHR JS CSs Img Media Font Doc WS Manifet Other
- Filter
- 2000ms
- 4000ms
- 6000ms
- 8000ms
- 10000ms
- 12000ms
- 14000ms
- 16000ms
- 18000ms
- 20000ms
- 22000ms
- 24000ms
- 26000ms
- 28000ms
- 30000ms
- 32000m
- 34000ms
- 36000ms
- 38000ms
- 40000ms
- 42000ms
- 44000ms
- HeadersPreview
- Response Cookies Timing
- lame
- www.driverzeng.com
- General
- jquery.min.js?ver=2.0.0
- Response Headers (19)
- bootstrap.min.js?ver=3.3.0
- Request Headers (11)
- logo.jpg
- lazyload.minjs?ver=1.9.0
- main.js?ver=1.0
- neel.jis?ver=1.0.0
- scrollbar.jis?ver=1.0.0
- 8.js?i=56tb40tpvmp&m=1&c=ff000cr1=fff&f=arial8l=33
- playerjs?ver=1.0.0
- index.js?ver=1.0.0
- ajax-comment.js?ver=1.0.0
- wp-embed.min.js?ver=4.9.10
- animate.css
- font-awesome.css
- player.css
- fontawesome-webfont.woff2?v=4.7.0
- back16.gif
- 27/36 requests | 9.9 KB/12.8KB transfered
- 1|25.8MB/25.9MB reso
- What'sNewx
- Higlightsfrom the Chrome 75 update
- Meaningful presetvalues when autocompleting CsSfunctions
- Clearsitedata fromtheCommandMenu
<!-- OCR_END -->

>  
>
> General:基本信息
>
> Response Headers:响应的头部信息
>
> Request Headers:请求的头部信息

***

| 基本信息 |
| :--- |

```bash
#请求的url
Request URL: https://www.driverzeng.com/
#请求方式
Request Method: GET
#状态码
Status Code: 200 
#远程主机IP
Remote Address: 45.253.17.213:443
#控制请求头内容
Referrer Policy: no-referrer-when-downgrade
```

***

| 请求头信息 |
| :--- |

<!-- OCR_START -->
- DBA老司机带你删库到跑路.
- 应用
- TTTS
- zabbix-api
- 文件存储
- 面试技巧
- 关于我
- Sources
- Network
- Performance
- Memory
- Application
- SecurityAudits
- 81
- Vew:Group byframe|Preserve log Disable cache|Offline No throtting
- Filter
- Hide dataURLs AI| XHR JS CSS Img Media Font Doc WS Manifest Other
- 20000ms
- 10000ms
- 30000ms
- 40000ms
- 50000ms
- 60000ms
- 70000ms
- 80000ms
- 90000ms
- 100000ms
- 110000ms
- 120000ms
- 130000ms
- 180000ms
- 190000ms
- 200000 ms
- 210000ms
- Name
- ×Headers
- Preview
- Response
- Cookies
- Timing
- www.driverzeng.com
- General
- b.css?ver=3.3.0
- Response Headers (19)
- style.css?ver=10.52
- highlight_ theme.css?ver=0.9.2
- Request Headers
- pure-highlight.css?ver=0.9.2
- :authority: www.driverzeng.com
- jquery.min.js?ver=2.0.0
- :method: GET
- bootstrap.minjs?ver=3.3.0
- :path:/
- logo.jpg
- :scheme: https
- accept: text/html, application/xhtml+xml, application/xml;g=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
- animate.css
- accept-encoding: gzip, deflate， br
- font-awesome.css
- accept-language:zh-CN,zh;q=0.9
- player.css
- cache-control:no-cache
- lazyload.min.js?ver=1.9.0
- cookie:PHPSESSID=afb7d767864ce6a652caa67dde33fcfc;wordpress_test_cookie=WP+Cookie+check;wordpress_logged_in_8cb66d45a3693d7c9673d2f1eaf63f66=admin%7C1565534946%7C0cvYan2unubeCmkeb4dHfIueS0DrnA4cl
- main.js?ver=1.0
- 8plJj9700T%7C37bb38d7b5c62837d6d82dd12eda70830752a1a37cf976d94d4ee560c75f766f;wp-settings-1=libraryContent%3Dbrowse%26editor%3Dtinymce%26hidetb%3D0%26post_dfwe3Doff%26align%3Dcenter%26imgsize%3D1
- mousewheel.js?ver=1.0.0
- rge%26mfold%3Do; wp-settings-time-1=1564325346; player_volume=0.0896551724137931; player=no; wp-postpass_8cb66d45a3693d7c9673d2f1eaf63f66=%24P%24Bpclv.Wj97LNy8oqHuxiMGDrNAjbwc1
- scrollbarjis?ver=1.0.0
- pragma: no-cache
- upgrade-insecure-requests: 1
- player.js?ver=1.0.0
- index.js?ver=1.0.0
- user-agent:Mozilla/5.0(Macintosh;Intel Mac 0SX10_14_1) AppleWebKit/537.36(KHTML，like Gecko)Chrome/75.0.3770.142Safari/537.36
- 43 requests | 24.5 MB transferred
- 24.8MBres
- |Finish:3.2min
- DOM
- What's Newx
- Highlightsfrom theChrome75update
<!-- OCR_END -->

```bash
#请求的域名
:authority: www.driverzeng.com
#请求的方式
:method: GET
#请求的路径
:path: /
#请求的协议：https
:scheme: https
#请求资源类型
accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
#压缩
accept-encoding: gzip, deflate, br
#语言
accept-language: zh-CN,zh;q=0.9
#缓存控制（没有做缓存）
cache-control: no-cache
#保持连接：长连接
Connetection:keep-alive
    HTTP/1.1版本 #长连接，一次TCP的连接可以发起多次http请求
    HTTP/1.0版本 #短连接，一次TCP的连接只能发起一次http请求
    
    还有HTTP/2.0和HTTP/3.0
#请求的域名
Host：www.driverzeng.com
#登录信息
cookie: PHPSESSID=afb7d767864ce6a652caa67dde33fcfc; wordpress_test_cookie=WP+Cookie+check; wordpress_logged_in_8cb66d45a3693d7c9673d2f1eaf63f66=admin%7C1565534946%7C0cvYan2unubeCmkeb4dHfIueS0DrnA4cW8plJj9700T%7C37bb38d7b5c62837d6d82dd12eda70830752a1a37cf976d94d4ee560c75f766f; wp-settings-1=libraryContent%3Dbrowse%26editor%3Dtinymce%26hidetb%3D0%26post_dfw%3Doff%26align%3Dcenter%26imgsize%3Dlarge%26mfold%3Do; wp-settings-time-1=1564325346; player_volume=0.0896551724137931; player=no; wp-postpass_8cb66d45a3693d7c9673d2f1eaf63f66=%24P%24Bpclv.Wj97LNy8oqHuxiMGDrNAjbwc1
#参数：没有缓存
pragma: no-cache
#谷歌自带的（不属于请求头的内容）
upgrade-insecure-requests: 1
#客户端（用户设备）
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36
```

***

| 响应头部信息 |
| :--- |

```bash
#大小
Accept-Range:bytes
#阿里云存储保存时间
ali-swift-global-savetime: 1564813833
#缓存控制
cache-control: no-cache, must-revalidate, max-age=0
#压缩
content-encoding: gzip
#内容长度
content-length: 9410
#返回内容类型及字符集
content-type: text/html; charset=UTF-8
#返回服务器时间
date: Sat, 03 Aug 2018 06:30:33 GMT
#加密id
eagleid: 2dfd119815648138332064260e
#失效时间
expires: Wed, 11 Jan 1984 05:00:00 GMT
#软链接
link: <https://www.driverzeng.com/wp-json/>; rel="https://api.w.org/"
#参数：没有缓存
pragma: no-cache
#使用的web软件
server: Tengine
#状态码
status: 200
#指定特定站点允许访问
timing-allow-origin: *
#渲染
vary: Accept-Encoding
#经过各级缓存
via: cache14.l2cm12[99,200-0,M], cache1.l2cm12[101,0], cache13.cn1300[122,200-0,M], cache4.cn1300[123,0]
------------- 以下都是CDN厂商带的 ----------------
#CDN缓存是否命中
x-cache: MISS TCP_MISS dirn:-2:-2
#缓存版本号
x-powered-by: PHP/7.1.21
#缓存时间
x-swift-cachetime: 0
#保存时间
x-swift-savetime: Sat, 03 Aug 2019 06:30:33 GMT
```

## Http请求方法

| 请求头信息 |
| :--- |

在`HTTP`请求报文中的方法(Method)，是对所请求对象所进行的操作，也就是一些命令。请求报文中的操作有：

| 方法(Method) | 含义 |
| :--- | :--- |
| GET | 请求读取一个Web页面 |
| POST | 附加一个命名资(如Web页面) |
| DELETE | 删除Web页面 |
| CONNECT | 用于代理服务器 |
| HEAD | 请求读取一个Web页面的头部 |
| PUT | 请求存储一个Web页面 |
| TRACE | 用于测试，要求服务器送回收到的请求 |
| OPTION | 查询特定选项 |

`POST`请求向指定的资源提交要被处理的数据

<!-- OCR_START -->
```http
enber.php?mod-logging&action=login&loginsubmit=yes&handlekey=post&loginhash=LlmjM&inajax=1HTTP/1.1
Host:bbs.sangfor.com.cn
Content-Length:159
Connection: keep-alive
Cache-Control:max-age=0
Origin:http:/bbs.sangfor.com.cn
Upgrade-Insecure-Requests:1
User-Agent:Mozi11a/5.0(Windows NT 6.3;wOW64） Aep1ewebKit/537.36（KHTML,，1ike Gecko)Chrome/58.0.3829.110 Safar1/537.36
Content-Type: appl1catlon/x-ww-form-urlencoded
Accept:text/htm1,application/xhtml+xml,app11cation/xm1;q=0.9,image/webp,*/*;q=0.8
Referer:http://bbs.sangfor.com.cn/plugin.php?id=info:index
Accept-Encoding:gzip,deflate
Accept-Language:zh-CN,zh;q=0.8
Cookle:gr_user_id=53345538-f248-4178-bceb-84de4f25f881;UP_distinctid-15be598ebc618f-09af4d91a3bb63-62181a75-144800-15be598ebc7436;
Hm_1vt_Be8161ac4f393ecc79c975079cc5fcc8=1494207748,1494209478,1494323977,1494385739; Udvb_2132_rid25065765422567599; Df1w_2132_saltkey=k828uV18;
Df1w_2132_1astvisit-1494911132;CNZZDATA1254845219=394365775-1494203502-s7C1494912229;Df1s_2132_1astact=1494914734%89meaber,phpx891ogging;
Df1w_2132_s1d=LZo1Id
formhash-1b5ee184&referer=httpx3Ax2Fx2Fbbs.sangfor.com.cn%2Fplugin.php%3F1dx3D1nfo
%3AIndex&username-179369652%40qq.com8password-
Date:Tue,16May 2017 06:05:46GMT
ookietime-2592000HTTP/1.120e 0K
Server:Apache
Cache-Control:no-store,private,post-check=0,pre-check=0,max-age=0
Expires:-1
Set-Cookie:Df1_2132_1astact-1494914746%e9menber,php%91ogging;expires=Wed,17-May-2017 06:05:46 GMT;path-/ Pragma:no-cache
Set-Cookie:Df1_2132_ulastactivity=a5f5nW2K18RISctfuMLr0%2Fa1GvCAZTk1rc90tAtIqLUfz6pg5Cx28;expiresWed，16-May-2818 06:05:46GMT;path/ Set-Cookie:Df1_2132_sid=LZo1Id;expires=Wed, 17-May-201706:05:46 GMT;path-/ Set-Cookie: Df1s_2132_auth=d6e8MuNBHtenHQeaFpkQb5H1kox1W45cY2fvHOWLMbARUtW5WC3ew3vyMRADaE4P1gVgL2Dy81HQ9UMP193NXk94;exp1res=Thu,15-Jun-2e17 06:05:46
GMIT;path-/;httponly
Set-Cookie: Df1_2132_1og1nuser=deleted;exp1res=Mon, 16-May-2816 06:05:46 GMT; path/ Set-Cookie:Df1_2132_activationauth=deleted;expires-Mon,16-May-201606:05:46GMT;path=/ Set-Cookie:
Df1w
132
www.drverzeng
16-May-2816 06:05:46 G
Set-Cookie:
Df1w
patn-
Set-Cookle:
Df1
g.com
Set-Cookle:Df1
vate,post-check=0,pre-check=,max-age=0
```
<!-- OCR_END -->

## Http响应方法

| 响应报文中的状态码 |
| :--- |

状态码（status-code）是响应报文状态行中包含的一个3位数字，指明特定的请求是否被满足，如果没有满足，原因是什么。状态码分为以下五类：

<!-- OCR_START -->
- 状态码
- 含义
- 例子
- 1xx
- 通知信息
- 100=服务器正在处理客户请求
- 2xx
- 成功
- 200=请求成功（OK)
- 3xx
- 重定向
- 301=页面改变了位置
- 4xx
- 客户错误
- 403=禁止的页面；404=页面未找到
- 5xx
- 服务器错误
- 500=服务器内部错误；503=以后再试
<!-- OCR_END -->

| 状态码 | 含义 |
| :--- | :--- |
| 200 | 成功 |
| 301 | 永久重定向（跳转） |
| 302 | 临时重定向（跳转） |
| 304 | 本地缓存 |
| 307 | 内部重定向（跳转） |
| 400 | 客户端错误 |
| 401 | 认证失败 |
| 403 | 找不到主页，权限不足 |
| 404 | 找不到页面 |
| 500 | 内部错误 |
| 502 | 找不到后端主机 |
| 503 | 服务器过载 |
| 504 | 后端主机超时 |

***

| 头部信息 |
| :--- |

<!-- OCR_START -->
- 头(header)
- 类型
- 说明
- User- Agent
- 请求
- 关于浏览器和它平台的信息，如Mozilla5.0
- Accept
- 客户能处理的页面的类型，如text/html
- Accept-Charset
- 客户可以接受的字符集，如Unicode-1-1
- Accept-Encoding
- 客户能处理的页面编码方法，如gzip
- Accept-Language
- 客户能处理的自然语言，如en（英语)，zh-cn（简体中文）
- Host
- 服务器的DNS名称。从URL中提取出来，必需。
- Referer
- 用户从该URL代表的页面出发访问当前请求的页面
- Cookie
- 将以前设置的Cookie送回服务器器，可用来作为会话信息
- Date
- 双向
- 消息被发送时的日期和时间
- Server
- 响应
- 关于服务器的信息，如Microsoft-lIS/6.0
- Content-Encoding
- 内容是如何被编码的（如gzip)
- Content-Language
- 页面所使用的自然语言
- Content-Length
- 以字节计算的页面长度
- Content-Type
- 页面的MIME类型
- Last-Modified
- 页面最后被修改的时间和日期，在页面缓存机制中意义重大
- Location
- 指示客户将请求发送给别处，即重定向到另一个URL
- Set-Cookie
- 服务器希望客户保存一个Cookie
<!-- OCR_END -->

***

| User-Agent |
| :--- |

User-Agent：浏览器标识（操作系统标识；加密等级标识；浏览器语言）渲染引擎标识 版本信息

<!-- OCR_START -->
```http
GET/HTTP/1.1
Host:www.qq.com
Connection:keep-alive
Upgrade-Insecure-Reouests:1
User-Agent:Mozilla/5.0（Windows NT 6.3:WOW64)AppleWebKit/537.36（KHTML,1ike Gecko)Chrome)
58.0.3029.110 Safari/537.36
Accept:text/html,application/xhtml+xml,application/xml:q=0.9,image/webp,**;q=0.8
Accept-Encoding:gzip,deflate,sdch
Accept-Language:zh-CN,zh:q=0.8
Cookie:RK=SBGymg0uZp:pgv_pvi=2504480768:pac_uid=1_179369652;
rv2=80FFB6BC0109F0A27719A952C3227E1DFF4C09B4823C87F5FC;
property20=1306C920DFB75EC8636B8F6CF8B0FF8538092D9D29AD7D80E53606D9CA7DB866FB4802BDD0DB9C4E;
qz_gdt=zfpruwlhaaacur3rd5ma:ts_uid=5261623201:qv_als=GHau2mU1t77B0rSJA11494914934R020Pw==;
tvfe_boss_uuid=51702bfe7bd72710;o_cookie=179369652:pgv_info=ssid=s3581387376:pgv_pvid=8621361160:
pgv_si=s9327318016:_qpsvr_localtk=0.9080250126742624:ptisp=ctc;
```
<!-- OCR_END -->

***

| Server |
| :--- |

Server：响应头包含处理请求的原始服务器的软件信息

<!-- OCR_START -->
```http
GET/c/guojixinwen.jsHTTP/1.1
Host:www.qq.com
Connection:keep-alive
User-Agent:Mozi11a/5.0 （Windows NT 6.3;WOW64)AppleWebKit/537.36 （KHTML,1ike
Accept:*/* Referer:http://www.qq.com/ Accept-Encoding:gzip, deflate, sdch
Accept-Language:zh-CN,zh:q=0.8
Cookie:RK=SBGymg0uZp:pgV_pvi=2504480768:pac_uid=1_179369652:rv2=80FFB6BC010
property20=1306C920DFB75EC8636B8F6CF8B0FF8538092D9D29AD7D80E53606D9CA7DB866FB48
qV_als=GHau2mU1t77B0rSJA11494914934R020Pw==:tvfe_boss_uuid=51702bfe7bd72710:
_qpsvr_1oca1tk=0.9080250126742624:ptisp=ctc:ptcz=fb14567159e1591c7a42bba81059
pt2gguin=o0179369652:uin=o0179369652:skey=@71x944TDP:pgv_info=ssid=s35813873
pgv_pvid=8621361160:o_cookie=179369652;ts_uid=5261623201:ad_play_index=18
HTTP/1.1200OK
Server:squid/3.5.20
Date:Thu, 18May201703:13:37GMT
Content-Type:application/javascript;charset=GB2312
Transfer-Encoding: chunked
Connection:keep-alive
Vary:Accept-Encoding
Expires:Thu,25May 2017 03:13:37 GMT
Cache-Control:max-age=604800
Vary:Accept-Encoding
Content-
Vary:
https.//www.driverzeng.com
Ac
X-Cache:
```
<!-- OCR_END -->

***

| Referer |
| :--- |

Referer：浏览器向 WEB 服务器表明自己是从哪个 网页/URL 获得/点击 当前请求中的网址/URL。

<!-- OCR_START -->
- www.qq.com
- 腾讯网
- QQ.com
- 新间图片军事
- 视频热剧综艺
- 娱乐明星电影
- 汽车车型购物
- 财经证券理财
- 体育NBA中超
- 时尚
- 健康
- 育儿
- 房产家居家电
<!-- OCR_END -->

<!-- OCR_START -->
```http
GET/HTTP/1.1
Host:health.qq.com
Connection:keep-alive
Upgrade-Insecure-Requests:1
User-Agent:Mozi11a/5.0（Windows NT 6.3;WOw64)AppleWebKit/537.36 (KHTML，
Accept:text/html,application/xhtml+xml,app1ication/xml;q=0.9,image/webp,*/* Referer:http://www.qq.com/ Accept-Encoding:gzip,defiate,sdch
Accept-Language:zh-CN,zh;q=0.8
Cookie:RK=SBGymg0uZp:pgv_pvi=2504480768;pac_uid=1_179369652;pt2gguin=o01
ptisp=ctc;ptcz=fb14567159e1591c7a42bba8105964b9e998545c780ac2920eaeb6ceabb4
rv2=80FFB6BC0109F0A27719A952C3227E1DFF4C09B4823C87F5FC;
property20=1306C920DFB75EC8636B8F6CF8B0FF8538092D9D29AD7D80E53606D9CA7DB866F
pgv_info=ssid=s3581387376:pgv_pvid=8621361160:o_cookie=179369652
```
<!-- OCR_END -->

***

| HTTP重定向 |
| :--- |

Location：WEB 服务器告诉浏览器，试图访问的对象已经被移到别的位置了，到该头部指定的位置去取。

<!-- OCR_START -->
```http
GET/HTTP/1.1
Accept:text/html,application/xhtml+xml,*/* Accept-Language:zh-CN
User-Agent:Mozi1la/5.0（Windows NT 6.3:wow64;Trident/7.0:rv:11.0)1ike Gecko
Accent-Encoding:gzip,deflate
Host:www.baidu.com
DNT:1
Connection:Keep-Alive
Cookie:BD_UPN=1126314551:ispeed_1sm=6:BAIDUID=06DEF25F8520F5F32889DF58B1BA2E5C:FG=1;
BIDUPSID=06DEF25F8520F5F32889DF58B1BA2E5C:PSTM=1494141005:
cfduid=db940c72a3a66834ba1eae62432e14ea31494141011
HTTP/1.1302MovedTemporarily
Date:Tue,16May201706:12:34GMT
Content-Type:text/html
Content-Length:215
Connection:Keep-Alive
Location:https://www.baidu.com/ Server:BWS/1.1
X-UA-Comp
Set-Cookil:
```
<!-- OCR_END -->

***

| HTTP访问流程图 |
| :--- |

<!-- OCR_START -->
- startTime
- connectStart
- 开始时间
- 开始创建链接
- redirectStart
- fetchStart
- domainLookupStart
- (secureConnectStart)
- requestStart
- responseStart
- 开始跳转
- fetch开始
- 域名解析开始
- 开始创建安全链接
- 开始发送请求
- 开始接收返回
- Redirect
- App cache
- DNS
- TCP
- Request
- Response
- 跳转
- 应用缓存
- DNS查找
- 创建TCP链接
- 发送请求
- 接收响应
- redirectEnd
- domainLookupEnd
- connectEnd
- responseEnd
- 跳转结束
- 域名解析结束
- 创建链接结束
- 结束接收返回
- 浏览器输入URL后HTTP请求返回的完整过程
<!-- OCR_END -->

***

| HTTP协议原理总结 |
| :--- |

```bash
1.用输入域名 - > 浏览器跳转 - > 浏览器缓存 - > Hosts文件 - > DNS解析（递归查询|迭代查询）
    客户端向服务端发起查询 - > 递归查询
    服务端向服务端发起查询 - > 迭代查询
2.由浏览器向服务器发起TCP连接（三次握手）
    客户端     -->请求包连接 -syn=1 seq=x           服务端
    服务端     -->响应客户端syn=1 ack=x+1 seq=y     客户端
    客户端     -->建立连接 ack=y+1 seq=x+1          服务端
3.客户端发起http请求：
    1）请求的方法是什么:     GET获取
    2）请求的Host主机是:     www.driverzeng.com
    3）请求的资源是什么:     /index.html
    4）请求的端端口是什么:    默认http是80 https是443
    5）请求携带的参数是什么:   属性（请求类型、压缩、认证、浏览器信息、等等）
    6）请求最后的空行
4.服务端响应的内容是
    1）服务端响应使用WEB服务软件
    2）服务端响应请求文件类型
    3）服务端响应请求的文件是否进行压缩
    4）服务端响应请求的主机是否进行长连接
5.客户端向服务端发起TCP断开（四次挥手）
    客户端     --> 断开请求 fin=1 seq=x          -->    服务端
    服务端     --> 响应断开 fin=1 ack=x+1 seq=y  -->    客户端
    服务端     --> 断开连接 fin=1 ack=x+1 seq=z  -->    客户端
    客户端     --> 确认断开 fin=1 ack=x+1 seq=sj -->    服务端
```

***

| 用户访问网站集群架构流程 |
| :--- |

```bash
1.客户端发起http请求，请求会先抵达前端的防火墙
2.防火墙识别用户身份，正常的请求通过内部交换机通过tcp连接后端的负载均衡，传递用户的http请求
3.负载接收到请求，会根据请求的内容进行下发任务，通过tcp连接后端的web，转发发用户的http请求
4.web接收到用户的http请求后，会根据用户请求的内容进行解析，解析分为如下：
    静态请求:web直接返回给负载均衡->防火墙->用户
    动态请求:web向后端的动态程序建立TCP连接，将用户的动态http请求传递至动态程序->由动态程序进行解析
5.动态程序在解析的过程中，如果碰到查询数据库请求，则优先与缓存建立tcp连接，并发起数据查询操作。
6.如果缓存没有对应的数据，动态程序再次向数据库建立tcp连接，并发起查询操作。
7.最后数据由, 数据库->动态程序->缓存->web服务->负载均衡->防火墙->用户。

```

<!-- OCR_START -->
- CDN层
- 负载层
- web层
- 存储层
- 缓存层
- 数据层
- 浏览器请求
<!-- OCR_END -->

## http相关术语

***

| PV、UV、IP |
| :--- |

假设公司有一座大厦，大厦有100人，每个人有一台电脑和一部手机，上网都是通过nat转换出口，每个人点击网站2次, 请问对应的pv,uv,ip分别是多少？

*  PV : 页面独立浏览量
*  UV : 独立设备
*  IP : 独立IP

那么上面的题：

PV： 100*2*2 = 400

UV： 1002\*2 = 200

IP： 1

日PV千万量级并不大

***

| SOA松耦合架构 |
| :--- |

面向服务的架构（SOA）是一个组件模型，它将应用程序的不同功能单元（称为服务）进行拆分，并通过这些服务之间定义良好的接口和契约联系起来。接口是采用中立的方式进行定义的，它应该独立于实现服务的硬件平台、操作系统和编程语言。这使得构建在各种各样的系统中的服务可以以一种统一和通用的方式进行交互。

<!-- OCR_START -->
- Create
- Rich User Experience
- Distribute
- Services
- Bal百
<!-- OCR_END -->

```bash
#一个电商公司，他的网站页面功能会有很多
    注册
    登录
    首页
    详情页
    购物车
    价格标签
    留言
    客服
    支付中心
    物流
    仓储信息
    订单相信
    图片
    
```

> 更新: 2024-09-22 19:48:40  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/aun1d7>