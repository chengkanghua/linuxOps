# 第五章·SSH远程管理服务实战

## SSH基本概述

*SSH是一个安全协议，在进行数据传输时，会对数据包进行加密处理，加密后在进行数据传输。确保了数据传输安全。那*`_SSH_`*服务主要功能有哪些呢？*

\_1.提供远程连接服务器的服务\
\_*2.对传输的数据进行加密*

\_那么除了SSH协议能提供远程连接服务，Telnet也能提供远程连接服务, 那么分别的区别是什么呢?\
\_`_ssh_`*服务会对传输数据进行加密, 监听在本地*`_22/tcp_`\_端口, \_`_ssh_`*服务默认支持*`_root_`\_用户登录\
\_`_telnet_`*服务不对数据进行加密, 监听在本地*`_23/tcp_`\_端口, \_`_Telnet_`*默认不支持*`_root_`*用户登录*

| 服务连接方式 | 服务数据传输 | 服务监听端口 | 服务登陆用户 |
| :--- | :--- | :--- | :--- |
| ssh | 加密 | 22/tcp | 默认支持root用户登陆 |
| telnet | 明文 | 23/tcp | 不支持root用户登陆 |

企业面试题：

下列服务，分别使用的那个端口？

```bash
ftp
dns
ssh
telnet
mysql
http
https
```

*案例: 使用*`_wireshark_`*验证*`_telnet_`*明文传输与*`_ssh_`*加密传输*

*1.安装telnet服务并运行*

```bash
[root@m01 ~]# yum install telnet-server -y
[root@m01 ~]# systemctl start telnet.socket
```

*2.使用wireshark检测vmnet8网卡上telnet的流量*

<!-- OCR_START -->
- The WiresharkNetworkAnalyzer
- Applya displayfilter.
- <8/>
- Expression...
- WelcometoWireshark
- DevelopmentBuild
- Capture
- ...using this filter:
- Enter a capture filter.
- All interfacesshown
- Thunderbolt3:en3
- Thunderbolt4:en4
- vmnet4
- AX88772A:en7
- vmnet8
- Loopback: lo0
- gifo
- stfo
- XHCO
- XHC1
- Learn
- User's Guide · Wiki ·Questions and Answers ·Mailing Lists
- You arerunningWireshark3.1.0(v3.1.0-0-g414ca80b2168).
- Readytoloadorcapture
- https://www.driverzeng.comnackets
- Profile:Default
<!-- OCR_END -->

*3.telnet是无法使用root用户登录Linux系统，需要创建普通用户*

```bash
[root@m01 ~]# useradd zls
[root@m01 ~]# echo "1"| passwd --stdin zls
```

*4.使用普通用户进行telnet登录*

<!-- OCR_START -->
- 1.zls@zls:~（telnet)
- X..ntent/extra（bash)81
- zls@zls:~(telnet)
- 82
- root@zls:~(ssh)
- 83
- MacBook-Pro:~driverzeng$telnet10.0.0.101
- Trying10.0.0.101...
- Connected to 10.0.0.101.
- Escape characteris'<]'.
- Password:
- Login incorrect
- zls login:zls
- [zls@zls~]$netstat-lntup
- (No info could be read for "-p":geteuid)=1000 but you should be root.)
- ActiveInternetconnections(onlyservers)
- ProtoRecv-QSend-QLocalAddress
- Foreign Address
- State
- PID/Program name
- tcp
- 00.0.0.0:22
- 0.0.0.0:*
- LISTEN
- 0127.0.0.1:25
- tcp6
- 0:::22
- ::*
- 0:::23
- ::*
- 0::1:25
- ::*
- [zls@zls~]$
<!-- OCR_END -->

*5.搜索*`_wireshark_`*包含*`_telnet_`*相关的流量*

<!-- OCR_START -->
- vmnet2
- telnet
- Expression..
- No.
- Time
- Source
- Destination
- Protocol
- [ Lengtr | Info
- 103 100.137925
- 10.0.0.1
- 10.0.0.101
- 93 Telnet Data
- 111 100.185006
- 78 TelnetData
- 113 100.185091
- 69 Telnet Data
- 115 100.185347
- 102 Telnet Data
- 117 100.185685
- 134 Telnet Data
- 118100.185986
- 120100.186044
- Frame 103: 93 bytes on wire (744 bits), 93 bytes captured (744 bits) on interface 0
- Ethernet II,Src: Vmware_c0:00:02 (00:50:56:c0:00:02),Dst: Vmware_91:25:0c (00:0c:29:91:25:
- Internet Protocol Version 4, Src: 10.0.0.1,Dst: 10.0.0.101
- Transmission Control Protocol,Src Port: 50605,Dst Port: 23, Seq: 1,Ack: 1,Len: 27
- 000c2991250c0050
- 56c0000208004512
- ).%.·P
- 0010
- 00 4f
- 40
- 06
- 26
- 32
- Oa
- 00 00 01 0a 00
- ·0..@·@.
- &2
- 0020
- 65
- c5
- ad
- 17
- c3
- 75
- 03
- d3
- ee928
- 8018
- 0030
- 08
- 66
- 2c
- 01
- 30
- b8
- 8c571
- 10e7
- 0040
- bf 7d
- ff
- fb
- 25
- ff fd03
- 18
- ff fb 1f ff fb
- 0050
- 20fffb21fffb22ff
- fb27fffd05
- wireshark_vmnet2_20190731183204https.plawng/W.driVerZengacketm210· Displayed:62(29.5%)·Profile: Default
<!-- OCR_END -->

<!-- OCR_START -->
- vmnet2
- telnet
- XI
- Expression...
- No.
- Time
- Source
- Destination
- Protocol | Lengtr | Info
- 103 100.137925
- 10.0.0.1
- 10.0.0.101
- 93 Telnet Data
- 111
- 100.185006
- Mark/Unmark Packet
- 78TelnetData
- 113
- 100.185091
- Ignore/Unignore Packet
- 69 Telnet Data
- 115
- 100.185347
- Set/UnsetTime Reference
- 102
- Telnet Data
- 117
- 100.185685
- Time Shift...
- 134
- 118
- 100.185986
- 69
- Packet Comment...
- 120
- 100.186044
- EditResolved Name
- Frame 103: 93 bytes on wire (744 b
- bits) on interface 0
- Ethernet II,Src: Vmware_c0:00:02
- Apply as Filter
- ware_91:25:0c(00:0c:29:91:25:0
- Internet Protocol Version 4, Src:
- Prepare a Filter
- Conversation Filter
- Seq: 1, Ack: 1,Len: 27
- Colorize Conversation
- SCTP
- Follow
- TCP Stream
- UDP Stream
- Copy
- TLS Stream
- 000c2991250c0050
- 56
- ce
- 0010
- 004f000040004006
- 26
- 32
- HTTP Stream
- Protocol Preferences
- 0020
- 0065c5ad@
- 0017c306
- 75
- Decode As...
- 0030
- 080a662c00000101
- 08
- Oa
- 0.-W.
- ShowPacket inNewWindow
- 0040
- bf 7dfffb25fffd
- 103
- ff
- ft
- 0050
- 20fffb21fffb22ff
- fb27fffd05
- Profile:Default
<!-- OCR_END -->

<!-- OCR_START -->
- 第五章
- Wireshark·FollowTCPStream(tcp.streameq2)·vmnet2
- LIBRAI
- .#..
- ..#..%..
- 38400,38400....
- ..USER.driverzeng......XTERM-256COLOR.......
- tcp.str
- ssion...
- ssword:1
- No.
- 140
- Login incorrect
- Data
- 141
- 23[AC
- 142
- zls login: zzllss
- 143
- Password:
- 144
- 1
- 145
- ]0;zls@zls:~..[?1034h[zls@zls~]$nneettsstt
- at --ll;;nn...[K
- 146
- [Knnttuupp
- Frame
- (Noinfocould beread for"-p":geteuid()=1000butyou should be
- Ether
- :56:c0:00:
- root.)
- Inter
- Active Internetconnections(only servers)
- Trans
- Foreign Address
- Len:2
- ProtoRecv-QSend-QLocalAddress
- Telne
- State
- PID/Program name
- tcp
- 00.0.0.0:22
- 0.0.0.0:*
- LISTEN
- 0127.0.0.1:25
- Packet132.30clientpkts,32serverpkts,55turns.Clicktoselect.
- 0010
- Entireconversation(1064by
- Showandsavedataas
- ASCII
- Stream
- 0020
- 0030
- 0040
- Find:
- Find Next
- Help
- Filter Out ThisStream
- Print
- Save as...
- Back
- Close
- wireshark_vmnet2_2019073118httpsy/wAwwgdriverZeng.Comts:210·Displayed:103(49.0%)
- Profile:Default
<!-- OCR_END -->

*6.使用wireshark分析ssh流量*

\_\_

<!-- OCR_START -->
1.root@zls:~（ssh)
X..ntent/extra（bash)81
root@zls:~(ssh)
82
83
[zls@zls~]$logout
Connectionclosedbyforeignhost.
MacBook-Pro:~driverzeng$sshroot@10.0.0.101
root@10.0.0.101's password:
Last failed login:Wed Jul 31 18:31:10CST 2019 from ::ffff:10.0.0.1 onpts/1
Therewas 1failed loginattemptsincethelast successfullogin.
Lastlogin:WedJul3118:27:002019from10.0.0.1
[root@zls~]#
<!-- OCR_END -->

<!-- OCR_START -->
- vmnet2
- ssh
- Expression...
- No.
- Time
- Source
- Destination
- Protocol
- | Lengtr | Info
- 268399.103982
- 10.0.0.1
- 10.0.0.101
- SSHv2
- 178 Client: Encryp
- 270 399.254619
- 566 Server: Encryp
- 272 399.255141
- 110 Server: Encryp
- 274 399.255276
- 518
- Client: Encryp
- 276 399.260831
- 174
- Server: Encryp
- 278
- 3399.267897
- 302
- 280 399.282566
- 142
- Server: Encrypte
- Frame 98: 190 bytes on wire (1520 bits), 190 bytes captured (1520 bits) on interface 0
- Ethernet 1I,Src: Vmware_91:25:0c（00:0c:29:91:25:0c),Dst:Vmware_c0:00:02(00:50:56:c0:00:(
- Internet Protocol Version 4, Src: 10.0.0.101, Dst: 10.0.0.1
- Transmission Control Protocol,Src Port: 22, Dst Port: 50068, Seq: 1269, Ack: 973,Len: 124
- SSH Protocol
- 005056c00002000c
- 2991250c08004512
- PV
- 0010
- 00 b0 1c 81
- 400040
- 06
- 09
- 50
- Oa
- 00650a00
- @@
- 0020
- 0001
- 16
- 94fc
- 58
- 4a
- 81
- f9
- d7
- 7e098018
- 0030
- 0125d8d0000001
- 01
- 08
- 10
- e7
- b5e030b8
- 0040
- 8473865888b11
- 17
- 36
- ee
- f3
- 7f27311e43
- S·X..
- 6
- 0050
- 9df98cd8b8cf29d4
- 31
- c8
- bb
- 284fb54141
- 1.·（0·AA
- 0060
- 4c557cbe57
- 74
- 4f
- 8b
- b1
- Of
- e6
- 67
- aa
- cf
- fc93
- LUI·WtO.
- 0070
- 3bd465
- 1c9b63
- 77
- 1f
- bc
- 8e
- 13
- 79
- 97
- e..c.w
- 0080
- a7cda40338e10623
- 18d72de3510f58b6
- 8··#..
- 0.X
- wireshark_vmnet2_20190731183204httpze.pcapng/W.driverZengacotm281·Displayed:81(28.8%)
- Profile: Default
<!-- OCR_END -->

<!-- OCR_START -->
- vmnet2
- ssh
- Expression...
- No.
- Time
- / Source
- Destination
- Protocol
- | Lengt | Info
- 268 399.103982
- 10.
- SSHv2
- 178 Client: Encryp
- Mark/Unmark Packet
- 270399.254619
- 566 Server: Encryp
- Ignore/UnignorePacket
- 272 399.255141
- 110 Server: Encryp
- 2743
- 399.255276
- Set/UnsetTimeReference
- 518 Client: Encryp
- 276
- 399.260831
- Time Shift...
- 174
- Server: Encryp
- 278
- 399.267897
- Packet Comment...
- 302
- 280 399.282566
- 142
- Server: Encrypte
- Edit Resolved Name
- Frame 268: 178 bytes on
- captured (1424 bits) on interface 0
- Ethernet II,Src: Vmwar
- Apply as Filter
- 2),Dst:Vmware_91:25:0c(00:0c:29:91:25:
- Internet Protocol Versi
- Prepare a Filter
- .0.0.101
- Transmission Control Pr
- Conversation Filter
- Port: 22,Seq: 2038,Ack: 1906,Len:112
- SSH Protocol
- Colorize Conversation
- SCTP
- Follow
- TCP Stream
- UDP Stream
- Copy
- TLS Stream
- 000c2991250c
- HTTP Stream
- 0010
- 00a400004000
- Protocol Preferences
- 0020
- 006
- 65c6f10016
- Decode As...
- 18
- e"
- 0030
- 08
- 00c863
- ec
- 0：
- ShowPacketinNewWindow
- 0040
- 4f5
- 543c
- 69a2
- 1e
- 51
- OT<i·
- @··S...Q
- 0050
- efb8fda3836
- 60
- e7
- 31
- 7760df5e90463d
- ac
- 1
- w..F=.
- 0060
- 688b6de9
- 5e24
- 01
- a8
- 4b
- 29
- ac47
- 2e
- 3b
- c1
- h·m·$..K)..G.·
- 0070
- 2ab
- b5fd
- 52
- 5873
- a3
- 3a
- c2
- 61
- b1
- 1a1cd65
- 5939
- *.·RXS.：
- a....Y9
- 0080
- ba
- b5da504ad387
- bb
- 987a67
- ea1f7e1bdd
- zg
- wireshark_vmnet2_20190731183204https.ncang/W.driverZengacketm281·Displayed:81(28.8%)
- Profile: Default
<!-- OCR_END -->

<!-- OCR_START -->
Wireshark·FollowTCPStream(tcp.stream eg3)·vmnet2
SSH-2.0-0penSSH_7.8
tcp.stre
SSH-2.0-0penSSH_7.4
ssion...
No.
...l..v...e.#z8.....)..
curve25519-sha256,curve25519-sha256@libssh.0rg,ecdh-sha2-
262
Encryp
nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-
263
exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-
264
22[AC
sha512,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1,ext-
265
info-c...fecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-
266
nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-
267
v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-
268
nistp521,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-
Encrypte
v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-
v01@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256,ssh-
Des
rsa...lchacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-
ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com...lchacha20-
ult)
poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-
gcm@openssh.com,aes256-gcm@openssh.com....umac-64-
So
etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-
etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-
etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-
sha2-256,hmac-sha2-512,hmac-sha1....umac-64-etm@openssh.com,umac-128-
etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-
0010
10clientpkts,12serverpkts,17turns.
0020
0030
Entireconversation(5470by
Showandsavedataas
ASCII
Stream
3
0040
0050
0060
6
Find:
Find Next
0070
2
0080
Help
Filter OutThis Stream
Print
Save as..
Back
Close
ofile:Default
<!-- OCR_END -->

<!-- OCR_START -->
Wireshark·FollowTCPStream(tcp.stream eq 3)·vmnet2
.tx.....AG..F.../...@curve25519-sha256,curve25519-
tcp.stre
sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-
ssion...
nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-
No.
sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-
262
Encryp
sha1,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1,diffie-
263
hellman-group1-sha1...Assh-rsa,rsa-sha2-512, rsa-sha2-256,ecdsa-sha2-
264
nistp256,ssh-ed25519....chacha20-poly1305@openssh.com,aes128-
22[AC
265
ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-
266
gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,blowfish-cbc,cast128-
267
cbc,3des-cbc....chacha20-poly1305@openssh.com,aes128-ctr,aes192-
ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-
268
Encrypte
cbc,aes192-cbc,aes256-cbc,blowfish-cbc,cast128-cbc,3des-
cbc....umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-
De
etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-
etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-
sha2-256,hmac-sha2-512,hmac-sha1....umac-64-etm@openssh.com,umac-128-
ult)
etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-
So
etm@openssh.com,hmac-sha1-
sha2-256,hmac-sha2-512,hmac-
sha1....none,zlib@openssh.com....none,zlib@openssh.com...
.x>e..9...%
XC
0010
Packet244.10clientpkts,12serverpkts,17turns.Clicktoselect.
0020
0030
Entireconversation(5470by
Showandsavedataas
ASCII
Stream
3
0040
4
0050
0060
6
Find:
Find Next
0070
0080
Help
FilterOut ThisStream
Print
Saveas...
Back
Close
ofile:Default
<!-- OCR_END -->

## SSH相关命令

\_SSH有客户端与服务端，我们将这种模式称为C/S架构，ssh客户端支持Windows、Linux、Mac等平台。\
\_*在ssh客户端中包含 ssh|slogin远程登陆、scp远程拷贝、sftp文件传输、ssh-copy-id秘钥分发等应用程序。*

***

| ssh远程登录服务器命令示例 |
| :--- |

```bash
ssh -p22 root@10.0.0.61
# -p指定连接远程主机端口，默认22端口可省略
# root@remotehost
# "@"前面为用户名，如果用当前用户连接，可以不指定用户
# "@"后面为要连接的服务器的IP
```

***

| scp复制数据至远程主机命令(全量复制) |
| :--- |

```bash
# -P 指定端口，默认22端口可不写
# -r 表示递归拷贝目录
# -p 表示在拷贝文件前后保持文件或目录属性不变
# -l 限制传输使用带宽(默认kb)
#推：将本地/tmp/oldboy推送至远端服务器10.0.0.61的/tmp目录，使用对端的root用户
[root@m01 ~]# scp -P22 -rp /tmp/oldboy oldboy@10.0.0.61:/tmp
#拉：将远程10.0.0.61服务器/tmp/oldboy文件拉取到本地/opt/目录下
[root@m01 ~]# scp -P22 -rp root@10.0.0.61:/tmp/oldboy /opt/
#限速
[root@m01 ~]# scp /opt/1.txt root@172.16.1.31:/tmp
root@172.16.1.31 password: 
test                        100%  656MB  '83.9MB/s'   00:07 
#限速为8096kb，换算为MB，要除以 8096/8=1024KB=1MB
[root@m01 ~]# scp -rp -l 8096  /opt/1.txt root@172.16.1.31:/tmp
root@172.16.1.31s password: 
test                        7%   48MB   '1.0MB/s'   09:45

```

>  
>
> 结论：
>
> 1.scp通过ssh协议加密方式进行文件或目录拷贝。
>
> 2.scp连接时的用户作为为拷贝文件或目录的权限。
>
> 3.scp支持数据推送和拉取，每次都是全量拷贝，效率较低。

***

| Sftp远程数据传输命令 |
| :--- |

```bash
#默认可以通过sftp命令连接sftp服务
sftp root@10.0.0.61
sftp -oPort=52113 root@10.0.0.61  #sftp的特殊端口连接
# sftp使用get下载文件至于本地服务器
sftp> get conf.txt /tmp/
# sftp使用put上传本地服务器文件至远程服务器
sftp> put /root/t1.txt /root/

```

## SSH验证方式

***1.基于账户密码远程登录***

*知道服务器的IP端口，账号密码，即可通过ssh客户端命令登陆远程主机。*

```bash
➜  ~ ssh -p22 root@10.0.0.61
root@10.0.0.61 password:
[root@m01 ~]#

```

***2.基于秘钥远程登录***

*默认情况下，通过ssh客户端命令登陆远程服务器，需要提供远程系统上的帐号与密码，但为了降低密码泄露的机率和提高登陆的方便性，建议使用密钥验证方式。*

<!-- OCR_START -->
- SSH秘钥认证过程
- 客户端
- 服务端
- ①客户端发送公钥至服务端（天王盖地虎）
- 客户端ssh-keygen生成密钥对
- 服务端会存放客户端的公钥至如下路径
- ~/.ssh/authorized_keys
- 公钥 id_rsa.pub (天王盖地虎)
- ②客户端通过SSH协议连接服务端
- 私钥id_rsa
- （宝塔镇河妖）
- ③服务端返回公钥询问（天王盖地虎）
- ④客户端使用私钥解密（宝塔镇河妖）
- 5密钥验证通过，二百五兄弟可连接
<!-- OCR_END -->

*1.在服务器上生成非对称密钥，使用-t指定密钥类型, 使用-C指定用户邮箱*

```bash
[root@m01 ~]# ssh-keygen -t rsa -C 133411023@qq.com
...
#默认一路回车即可
...
```

*2.将A服务器上的公钥推送至B服务器*

```bash
#命令示例: ssh-copy-id [-i [identity_file]] [user@]machine
ssh-copy-id #命令
-i          #指定下发公钥的路径
[user@]     #以什么用户身份进行公钥分发（root）,如果不输入，表示以当前系统用户身份分发公钥
machine     #下发公钥至那台服务器, 填写远程主机IP地址
#分发秘钥，[将A服务器的公钥写入B服务器~/.ssh/authorized_keys文件中]
[root@m01 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.41
```

*3.A服务器连接B服务器是无需密码的，如果能直接连接无需密码则表示秘钥已配置成功*

```bash
#远程登录对端主机方式
[root@m01 ~]# ssh root@172.16.1.41
[root@nfs ~]#
#不登陆远程主机bash，但可在对端主机执行命令
[root@m01 ~]# ssh root@172.16.1.41 "hostname -i"
172.16.1.41
```

## SSH场景实践

\_实践场景，用户通过Windows/MAC/Linux客户端连接跳板机免密码登录，跳板机连接后端无外网的Linux主机实现免密登录，架构图如下。\
\_\_实践多用户登陆一台服务器无密码\
\_*实践单用户登陆多台服务器免密码*

<!-- OCR_START -->
- Windows/Linux/Mac客户端
- Web服务1
- 172.16.1.7
- 运维
- 开发
- 客户端下发公钥
- 跳板机下发公钥
- Web服务2
- 跳板机
- 172.16.1.8
- 测试
- 公网
- 内网
- Web服务3
- 172.16.1.9
- 多用户连接单主机
- 单用户连接多主机
<!-- OCR_END -->

***1.windows客户端使用Xshell生成秘钥对，并下发公钥至跳板机***

*1) Xshell-->选择工具->新建密钥生成工具*

<!-- OCR_START -->
- Xshell5(Free forHome/School)
- 文件（日
- 编辑（E）查看（V)
- 工具（D
- 选项卡（B）窗口（W)
- 帮助（H）
- 发送键输入到所有会话（K)
- A?
- Sun(Solaris)快捷键
- 1本地Shell
- 主机密钥管理者（H.
- Xshell5（Builc
- 用户密钥管理者（U）
- Copyright （c)
- 新建用户密钥生成向导（W..
- Computer，Inc.All rights reserved.
- Typehelp
- Xagent开始（A)
- to
- shellprompt.
- [c:\~]$
- 配色方案（C)
- 快速命令集Q
- 脚本（R）
- 语言（N）.
- 选项（)
<!-- OCR_END -->

*2) 生成公钥对，选择下一步*

<!-- OCR_START -->
- 新建用户密钥生成向导
- 生成公钥对
- 生成公钥和私钥对。
- 2048位RSA用户
- 010101011011010
- 公钥对已成功生成。
- 请单击下一步输入用户密钥的名称和密码。
<!-- OCR_END -->

*3) 填写秘钥名称。秘钥增加密码则不建议配置*

<!-- OCR_START -->
- 新建用户密钥生成向导
- 用户密钥信息
- 请输入生成用户密钥的名称和密码。
- 请输入用户密钥的名称。
- 密钥名称：
- windows.
- 请输入给用户密钥加密的密码。
- 密码P：不建议使用
- 确认(C）：
- （重新键入密码）
- 请单击下一步在SSH服务器上注册公钥
- 取消
<!-- OCR_END -->

*4) Windows会提示密码，继续即可*

<!-- OCR_START -->
- 新建用户密钥生成向导
- 用户密钥信息
- 请输入生成用户密钥的名称和密码。
- Xshell
- 密码是空的。此用户密钥将保存未加密的私钥部分
- 是否仍要继续？
- 是(Y)
- 否（N)
<!-- OCR_END -->

*5) 生成秘钥后，点击Xshell->工具->用户秘钥管理者->选择对应秘钥的属性*

<!-- OCR_START -->
- 用户密钥
- 名称
- 类型
- 长度
- 生成（G)...
- RSA
- 2048 bits
- 属性(P）
- 删除(D）
- 导入(1)...
- 导出（E)...
- 关闭
<!-- OCR_END -->

*6) 选择对应秘钥的公钥，将其复制*

<!-- OCR_START -->
常规
公钥
公钥格式（P）：
SSH2-OpenSSH
ssh-rsa
AAAAB3NzaC1yc2EAAAABIwAAAQEAznZeu5hJYGm66m1UM4d2v2us6gv
msbZKnAWd/fckumW/IiyIPjq52ufSdFpRBaM41XqJRuOUOCoQLI9M3P
cKLahLShAGvI12c2Z2J1jaald12kjg33GfWJSnD0ctS1a45mYmqvCHh
QBIRLHLAGGJdRBW1B7ukvOhC9rfIAbIcMrOWfPDHfFcuwvs/chwrPQr
HpPvMsplEIs09Fm7DjU5uvfm1i8R5ChsUJc3Dvqt4VRH1LByGGzm
AXA7zbWXfhlowFjbnkG3lR5UiTA6WBbe7BSGsgPNJs
+JVAd4mX0W3s/SSgnkhS6At0bV3+Kg2w2q1umKbqs0Ud3c00lnbb6Q=
复制下来
或者保存为文件
保存为文件（S）.
https://www.driverzerig.com
确定
取消
<!-- OCR_END -->

*7) 将从WIndows下复制好的公钥粘贴至跳板机~/.ssh/authorized_keys中，然后测试*

```bash
[root@m01 ~]# cd ; umask 077; mkdir -p .ssh ;cd .ssh
[root@m01 .ssh]# vim authorized_keys  #添加windows公钥
```

***2.跳板机下发公钥至后端主机***

*1) 在跳板机上生成秘钥对*

```bash
[root@m01 ~]# ssh-keygen -t rsa -C manager@qq.com
```

*2) 拷贝跳板机上的密钥至后端主机，如果SSH不是使用默认22端口, 使用-p指定对应端口*

```bash
[root@m01 ~]# ssh-copy-id  -i /root/.ssh/id_rsa.pub "-p22 root@172.16.1.31"
[root@m01 ~]# ssh-copy-id  -i /root/.ssh/id_rsa.pub "-p22 root@172.16.1.41"
```

*3) 在m01管理机上测试是否成功登陆两台服务器*

```bash
[root@m01 ~]# ssh root@172.16.1.41
[root@nfs01 ~]# exit
[root@m01 ~]# ssh root@1172.16.1.31
[root@backup ~]# exit
```

***3.通过跳板机能实现scp拷贝文件免密码***

```bash
[root@m01 ~]# scp zls.txt root@172.16.1.31:/tmp
zls.txt                 100%    0     0.0KB/s   00:00    
[root@m01 ~]# scp zls.txt root@172.16.1.41:/tmp
zls.txt                 100%    0     0.0KB/s   00:00
```

***4.通过跳板机获取所有机器的***`_**load，CPU，Memory**_`***等信息(思考:如果服务器数量多，如何并发查看和分发数据)***

```bash
[root@m01 ~]# cat all.sh 
#!/usr/bin/bash
[ $# -ne 1 ] && echo "请输入执行的命令" && exit 1
for i in 31 41
do
    echo "#########172.16.1.$i#####"
    ssh root@172.16.1.$i "$1"
done
```

***5.脚本实现（跳板机）***

```bash
#！/bin/bash
#jumpserver
lb01=10.0.0.5
lb02=10.0.0.6
web01=10.0.0.7
web02=10.0.0.8
web03=10.0.0.9
nfs=10.0.0.31
backup=10.0.0.41
db01=10.0.0.51
m01=10.0.0.61
zabbix=10.0.0.71
menu(){
        cat <<-EOF
        +-------------------------+
        |     1) lb01             |
        |     2) lb02             |
        |     3) web01            |
        |     4) web02            |
        |     5) web03            |
        |     6) nfs              |
        |     7) backup           |
        |     8) db01             |
        |     9) m01              |
        |     10) zabbix          |
        |     h) help             |
        +-------------------------+
EOF
}
#菜单函数
menu
#连接函数
connect(){
  ping -c 1 -w 1 $1 &>/dev/null
  if [ $? -eq 0 ];then
    ssh root@$1
  else
    echo -e "\033[5;4;40;31m 别连了,我的哥,$2:$1机器都没开!!!\033[0m"
  fi
}
#控制不让输入ctrl+c,z
trap "" HUP INT TSTP
while true
do
    read -p "请输入要连接的主机编号：" num
    case $num in
            1|lb01)
              connect $lb01 lb01
                    ;;
            2|lb02)
              connect $lb02 lb02
                    ;;
            3|web01)
              connect $web01 web01
                    ;;
            4|web02)
              connect $web02 web02
                    ;;
            5|web03)
                  connect $web03 web03
                    ;;
            6|nfs)
              connect $nfs nfs
                    ;;
            7|backup)
                  connect $backup backup
                    ;;
            8|db01)
                   connect $db01 db01
                    ;;
            9|m01)
                    connect $m01 m01
                    ;;
            10|zabbix)
                    connect $zabbix zabbix
                    ;;
            h|help)
                    clear
                    menu
                    ;;
            close)
                    break
                    ;;
    esac
done
```

## SSH安全优化

\_SSH作为远程连接服务，通常我们需要考虑到该服务的安全，所以需要对该服务进行安全方面的配置。\
\_\_1.更改远程连接登陆的端口\
\_\_2.禁止ROOT管理员直接登录\
\_\_3.密码认证方式改为密钥认证\
\_\_4.重要服务不使用公网IP地址\
\_*5.使用防火墙限制来源IP地址*

*SSH服务登录防护需进行如下配置调整，先对如下参数进行了解*

```bash
Port 6666                       # 变更SSH服务远程连接端口
PermitRootLogin         no      # 禁止root用户直接远程登录
PasswordAuthentication  no      # 禁止使用密码直接远程登录
UseDNS                  no      # 禁止ssh进行dns反向解析，影响ssh连接效率参数
GSSAPIAuthentication    no      # 禁止GSS认证，减少连接时产生的延迟

```

*将如下具体配置添加至/etc/ssh/sshd_config文件中，参数需根据实际情况进行调整*

```bash
###SSH###
#Port 6666
#PasswordAuthentication no
#PermitRootLogin no
GSSAPIAuthentication no
UseDNS no
###END###

```

## 免交互expect\[扩展]

1.安装expect

```bash
[root@m01 ~]# yum install -y expect
```

2.编写expect脚本

```bash
#!/usr/bin/expect
set ip 10.0.0.51
set pass 123456
set timeout 30
spawn ssh root@$ip
expect {
        "(yes/no)" {send "yes\r"; exp_continue}
        "password:" {send "$pass\r"}
}
expect "root@*"  {send "df -h\r"}
expect "root@*"  {send "exit\r"}
expect eof
```

## 免交互sshpass\[扩展]

1.安装sshpass

```bash
[root@m01 ~]# yum install -y sshpass
```

2.使用sshpass命令

```bash
[root@m01 ~]# sshpass -p 123456 ssh root@10.0.0.51
[option]
-p：指定密码
-f：从文件中取密码
-e：从环境变量中取密码
-P：设置密码提示
```

> 更新: 2024-09-22 18:19:59  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/spg9a5>