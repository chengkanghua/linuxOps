## LVS-NAT 模式

#### 配置lvs-nat模式的负载集群(http)

###### <font style="color:black;">环境说明</font>
![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%EF%BC%88%E5%9B%9B%E7%A7%8D%E6%A8%A1%E5%BC%8F%EF%BC%89%E9%9B%86%E7%BE%A4%E9%85%8D%E7%BD%AE%E5%AE%9E%E8%B7%B5-01.webp)

###### <font style="color:black;">给DR主机添加一个仅主机的网卡</font>
```plain
[root@DR ~]# ifconfig     //查看到仅主机网卡的名字为 ens38
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.79.129  netmask 255.255.255.0  broadcast 192.168.79.255
        inet6 fe80::20c:29ff:feb8:3224  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:b8:32:24  txqueuelen 1000  (Ethernet)
        RX packets 299161  bytes 120054672 (114.4 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 382902  bytes 85603867 (81.6 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens38: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 00:0c:29:b8:32:2e  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        
//查看虚拟网络编辑器种仅主机的网段为192.168.23.0
[root@DR ~]# nmcli connection add con-name ens38 ifname ens38 type  ethernet 
Connection 'ens38' (9b003222-efb6-4d19-8043-a625b3a9c154) successfully added.
[root@DR ~]# nmcli connection 
NAME    UUID                                  TYPE      DEVICE 
ens33   af4d3903-2150-4bda-9723-f37666535088  ethernet  ens33  
ens38   9b003222-efb6-4d19-8043-a625b3a9c154  ethernet  ens38  
virbr0  95dd368f-e449-44b6-8fb2-cd0cbbb50c2f  bridge    virbr0 
[root@DR ~]# nmcli connection modify ens38 ipv4.addresses 192.168.23.10/24 ipv4.method manual autoconnect yes 
[root@DR ~]# systemctl restart NetworkManager
[root@DR ~]# nmcli connection up ens38 
Connection successfully activated (D-Bus active path:/org/freedesktop/NetworkManager/ActiveConnection/5)
```

```plain
#DR、RS1、RS2三台主机都关闭防火墙和selinux
[root@DR ~]# systemctl stop firewalld
[root@DR ~]# systemctl disable firewalld
[root@DR ~]# sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config 
[root@DR ~]# setenforce 0

[root@RS1 ~]# systemctl stop firewalld
[root@RS1 ~]# systemctl disable firewalld
[root@RS1 ~]# sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
[root@RS1 ~]# setenforce 0

[root@RS2 ~]# systemctl stop firewalld
[root@RS2 ~]# systemctl disable firewalld
[root@RS2 ~]# sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
[root@RS2 ~]# setenforce 0
```

###### <font style="color:black;">配置ip信息</font>
```plain
//DR:
[root@DR ~]# vim /etc/sysconfig/network-scripts/ifcfg-ens33
IPADDR=192.168.79.129
PREFIX=24
GATEWAY=192.168.79.2
DNS1=8.8.8.8

//RS1:
[root@RS1 ~]# vim /etc/sysconfig/network-scripts/ifcfg-ens33
.....
IPADDR=192.168.79.134
PREFIX=24
GATEWAY=192.168.79.129
DNS1=8.8.8.8

//RS2:
[root@RS2 ~]# vim /etc/sysconfig/network-scripts/ifcfg-ens33
IPADDR=192.168.91.139
PREFIX=24
GATEWAY=192.168.79.129
DNS1=8.8.8.8
```

###### <font style="color:black;">安装WEB服务</font>
```plain
//后端RS1和RS2部署WEB服务器
RS1:
[root@RS1 ~]# yum -y install httpd
[root@RS1 ~]# echo RS1 > /var/www/html/index.html
[root@RS1 ~]# systemctl restart httpd
[root@RS1 ~]# systemctl enable httpd

//RS2:
[root@RS2 ~]# yum -y install httpd
[root@RS2 ~]# echo RS2 > /var/www/html/index.html
[root@RS2 ~]# systemctl restart httpd
[root@RS2 ~]# systemctl enable httpd
```

###### <font style="color:black;">配置LVS</font>
```plain
//配置DR
（1）开启IP转发功能
[root@DR ~]# vim /etc/sysctl.con
net.ipv4.ip_forward = 1
[root@DR ~]# sysctl -p
net.ipv4.ip_forward = 1

//安装ipvsadm并添加规则
[root@DR ~]# yum -y install ipvsadm
[root@DR ~]# ipvsadm -A -t 192.168.237.10:80 -s rr
[root@DR ~]# ipvsadm -a -t 192.168.23.10:80 -r 192.168.79.134:80 -m
[root@DR ~]# ipvsadm -a -t 192.168.23.10:80 -r 192.168.79.139:80 -m
[root@DR ~]# ipvsadm -Ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.23.10:80 rr
  -> 192.168.79.134:80            Masq    1      0          0         
  -> 192.168.79.139:80            Masq    1      0          0

[root@DR ~]# ipvsadm -Sn > /etc/sysconfig/ipvsadm
[root@DR ~]# systemctl restart ipvsadm.service 
[root@DR ~]# systemctl enable ipvsadm.service
```

###### <font style="color:black;">测试负载均衡效果</font>
```plain
//客户端测试
[root@Client ~]# curl http://192.168.23.10
RS2
[root@Client ~]# curl http://192.168.23.10
RS1
[root@Client ~]# curl http://192.168.23.10
RS2
[root@Client ~]# curl http://192.168.23.10
RS1
```

<font style="color:rgb(53, 53, 53);">更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

#### <font style="color:black;">配置lvs-nat模式负载均衡集群(https)</font>
###### <font style="color:black;">在DR中生成一对密钥</font>
```plain
[root@DR ~]# mkdir  -p  /etc/pki/CA/private
[root@DR ~]# cd /etc/pki/CA/
[root@DR CA]# (umask 077;openssl genrsa -out private/cakey.pem 2048)
Generating RSA private key, 2048 bit long modulus (2 primes)
........................................................................................+++++
..........+++++
e is 65537 (0x010001)

[root@DR CA]# openssl rsa -in private/cakey.pem -pubout
writing RSA key
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwzoaJdd6iyCTOe97L7jg
sd3I7TKZuADMwRWKYYwyt5x2QuBuI7FaJ0gtP6sSRn9UmOpxixXDKOX2wpv27Ld+
N0L45eX/cDcMNJtMLCm4eVxzFegJagiE60gt6paTn6JX70AK6RM8iIClAwQMPbc3
lUooeSDcRoWW7LU85+QU36p3RpNIKcNOow5GNvuHe/GQhqArA50gxXsKqkFDsZVm
7xLZVWyBJ5WImhHgjV9wEhjk+/fM+8i05KOS3+WPf01I58zmehh3REohMi1X4Knz
RAS25s4pU6Shs2XAj6nHRLrxPUslEE5ZS9Uc9hKLUizLUeWDTo37yv4CJkVi50XV
TwIDAQAB
-----END PUBLIC KEY-----

[root@DR CA]# openssl req -new -x509 -key private/cakey.pem -out cacert.pem -days 1024
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:hubei
Locality Name (eg, city) [Default City]:wuhan
Organization Name (eg, company) [Default Company Ltd]:runtime   
Organizational Unit Name (eg, section) []:linux
Common Name (eg, your name or your server's hostname) []:Gin
Email Address []:Gin@163.com

[root@DR CA]# touch index.txt && echo 01 > serial
```

###### <font style="color:black;">在RS1中生成证书签署请求，并发送给CA</font>
```plain
[root@RS1 ~]# yum -y install mod_ssl
[root@RS1 ~]# mkdir /etc/httpd/ssl
[root@RS1 ~]# cd /etc/httpd/ssl/
[root@RS1 ssl]# (umask 077;openssl genrsa -out httpd.key 2048)
Generating RSA private key, 2048 bit long modulus (2 primes)
..................................+++++
............................................................................+++++
e is 65537 (0x010001)
[root@RS1 ssl]# openssl req -new -key httpd.key -days 1024 -out httpd.csr
Ignoring -days; not generating a certificate
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:hubei
Locality Name (eg, city) [Default City]:wuhan
Organization Name (eg, company) [Default Company Ltd]:runtime
Organizational Unit Name (eg, section) []:linux
Common Name (eg, your name or your server's hostname) []:Gin 
Email Address []:dr@1314.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

[root@RS1 ssl]# ls
httpd.csr  httpd.key
[root@RS1 ssl]# scp httpd.csr root@192.168.79.129:/root/
The authenticity of host '192.168.91.129 (192.168.79.129)' can't be established.
ECDSA key fingerprint is SHA256:Z3HMzqS6THCLCxpluX/FENh3Ag0hppqEQar7Klpf2LU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.91.129' (ECDSA) to the list of known hosts.
root@192.168.91.129's password: 
httpd.csr               100% 1025   280.9KB/s   00:00                              
//在DR中查看
[root@DR ~]# ls
anaconda-ks.cfg  cmake  Desktop  Documents  Downloads  httpd.csr  initial-setup-ks.cfg

//CA签署证书并发给RS1
[root@DR ~]# mkdir /etc/pki/CA/newcerts
[root@DR ~]# touch /etc/pki/CA/index.txt
[root@DR ~]# echo "01" > /etc/pki/CA/serial
[root@DR ~]# openssl ca -in httpd.csr -out httpd.crt -days 1024
Using configuration from /etc/pki/tls/openssl.cnf
Check that the request matches the signature
Signature ok
Certificate Details:
        Serial Number: 1 (0x1)
        Validity
            Not Before: Sep 27 06:57:45 2022 GMT
            Not After : Jul 17 06:57:45 2025 GMT
        Subject:
            countryName               = CN
            stateOrProvinceName       = hubei
            organizationName          = runtime
            organizationalUnitName    = linux
            commonName                = Gin
            emailAddress              = Gin@163.com
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            Netscape Comment: 
                OpenSSL Generated Certificate
            X509v3 Subject Key Identifier: 
                2F:0E:AD:05:5C:72:ED:18:44:EF:9B:CC:D4:8A:FA:98:E7:5E:9A:43
            X509v3 Authority Key Identifier: 
                keyid:BC:33:75:57:47:33:5A:3E:EB:17:8E:7B:37:E2:80:B1:BB:B2:4D:5E

Certificate is to be certified until Jul 17 06:57:45 2025 GMT (1024 days)
Sign the certificate? [y/n]:y

1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated

[root@DR ~]# ls
anaconda-ks.cfg  Desktop    Downloads  httpd.csr             Music     Public     Videos
cmake            Documents  httpd.crt  initial-setup-ks.cfg  Pictures  Templates

//将CA签署的证书httpd.crt和服务器的证书cacert.pem发送给RS1
[root@DR ~]# scp httpd.crt root@192.168.79.134:/etc/httpd/ssl   
[root@DR ~]# scp /etc/pki/CA/cacert.pem root@192.168.79.134:/etc/httpd/ssl
```

###### <font style="color:black;">RS2配置https</font>
```plain
[root@RS2 ~]# yum -y install mod_ssl
[root@RS2 ~]# mkdir /etc/httpd/ssl
//RS1中把RS1的证书和密钥发送给RS2
[root@RS1 ~]# cd /etc/httpd/ssl/
[root@RS1 ssl]# scp cacert.pem httpd.crt httpd.key root@192.168.79.139:/etc/httpd/ssl
```

###### <font style="color:black;">在RS1中修改https的配置文件</font>
```plain
[root@RS1 ssl]# vim /etc/httpd/conf.d/ssl.conf
SSLCertificateFile /etc/httpd/ssl/httpd.crt
SSLCertificateKeyFile /etc/httpd/ssl/httpd.key
SSLCACertificateFile /etc/httpd/ssl/cacert.pem
[root@RS1 ssl]# systemctl restart httpd.service 
[root@RS1 ssl]# ss -anlt |grep 443
LISTEN 0      128                *:443             *:*
```

###### <font style="color:black;">在RS2中修改https的配置文件</font>
```plain
[root@RS2 ~]# vim /etc/httpd/conf.d/ssl.conf
SSLCertificateFile /etc/httpd/ssl/httpd.crt
SSLCertificateKeyFile /etc/httpd/ssl/httpd.key
SSLCACertificateFile /etc/httpd/ssl/cacert.pem
[root@RS2 ~]# systemctl restart httpd.service 
[root@RS2 ~]# ss -anlt|grep 443
LISTEN 0      128                *:443             *:*
```

###### <font style="color:black;">配置LVS</font>
```plain
//在DR中添加规则
[root@DR ~]# ipvsadm -A -t 192.168.23.10:443 -s rr
[root@DR ~]# ipvsadm -a -t 192.168.23.10:443 -r 192.168.79.134 -m
[root@DR ~]# ipvsadm -a -t 192.168.23.10:443 -r 192.168.79.139 -m
[root@DR ~]# ipvsadm -Ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.23.10:80 rr
  -> 192.168.79.134:80            Masq    1      0          0         
  -> 192.168.79.139:80            Masq    1      0          0         
TCP  192.168.23.10:443 rr
  -> 192.168.79.134:443           Masq    1      0          0         
  -> 192.168.79.139:443           Masq    1      0          0
```

###### <font style="color:black;">客户端测试</font>
```plain
[root@Client ~]# curl -k https://192.168.23.10:443
RS1
[root@Client ~]# curl -k https://192.168.23.10:443
RS2
[root@Client ~]# curl -k https://192.168.23.10:443
RS1
[root@Client ~]# curl -k https://192.168.23.10:443
RS2
```

<font style="color:rgb(53, 53, 53);">更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

## <font style="color:rgb(34, 34, 34);">配置lvs-dr模式的负载集群</font>
![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%EF%BC%88%E5%9B%9B%E7%A7%8D%E6%A8%A1%E5%BC%8F%EF%BC%89%E9%9B%86%E7%BE%A4%E9%85%8D%E7%BD%AE%E5%AE%9E%E8%B7%B5-02.webp)

###### <font style="color:black;">配置httpd</font>
```plain
RS1：
#关闭防火墙和selinux
[root@rs1 ~]# systemctl stop firewalld
[root@rs1 ~]# systemctl disable firewalld
[root@rs1 ~]# sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
#安装httpd
[root@rs1 ~]# yum -y install httpd
[root@rs1 ~]# echo "RS1" > /var/www/html/index.html
[root@rs1 ~]# systemctl restart httpd
[root@rs1 ~]# systemctl enable httpd

RS2：
#关闭防火墙和selinux
[root@RS2 ~]# systemctl stop firewalld
[root@RS2 ~]# systemctl disable firewalld
[root@RS2 ~]# sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config 
#安装httpd
[root@RS2 ~]# yum -y install httpd
[root@RS2 ~]# echo "RS2" > /var/www/html/index.html
[root@RS2 ~]# systemctl restart httpd
[root@RS2 ~]# systemctl enable httpd
```

###### <font style="color:black;">LVS上配置ip</font>
```plain
DR：
//关闭防火墙和selinux
[root@DR ~]# systemctl stop firewalld
[root@DR ~]# systemctl disable firewalld
[root@DR ~]# sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config 

//临时生效
[root@DR ~]# ifconfig lo 192.168.79.100 broadcast 192.168.79.100 netmask 255.255.255.255 up
//永久生效
[root@DR ~]# vim /etc/rc.d/rc.local    
ifconfig lo 192.168.79.100 broadcast 192.168.79.100 netmask 255.255.255.255 up
[root@DR ~]# chmod +x /etc/rc.d/rc.local
[root@DR ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 192.168.79.100/32 brd 192.168.79.100 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:b8:32:24 brd ff:ff:ff:ff:ff:ff
    inet 192.168.79.129/24 brd 192.168.79.255 scope global noprefixroute ens33
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:feb8:3224/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

###### <font style="color:black;">RS上配置arp内核参数（RS1和RS2上都需要操作）</font>
```plain
vim /etc/sysctl.conf
#将对应网卡设置为只回应目标IP为自身接口地址的ARP请求
net.ipv4.conf.all.arp_ignore = 1
#将ARP请求的源IP设置为所有接口的IP，也就是RIP
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2

//RS1
[root@RS1 ~]# vim /etc/sysctl.conf
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
[root@RS1 ~]# sysctl -p
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2

//RS2
[root@RS2 ~]# vim /etc/sysctl.conf
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
[root@RS2 ~]# sysctl -p
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
```

###### <font style="color:black;">RS上配置VIP</font>
<font style="color:rgb(53, 53, 53);">一定要先配置好内核参数，再配置VIP，如果先配置VIP，VIP配置好后会立即通告给所有人，而修改内核参数就是为了不通告。LVS服务器的ens33网卡的ip：192.168.79.100作为VIP，两台RS都要做。</font>

```plain
RS1:
[root@RS1 ~]# ifconfig lo 192.168.79.100 broadcast 192.168.79.100 netmask 255.255.255.255 up
[root@RS1 ~]# ip a
[root@RS1 ~]# ifconfig lo 192.168.79.100 broadcast 192.168.79.100 netmask 255.255.255.255 up
[root@RS1 ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 192.168.79.100/32 brd 192.168.79.100 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:70:9e:3b brd ff:ff:ff:ff:ff:ff
    inet 192.168.79.134/24 brd 192.168.79.255 scope global noprefixroute ens33
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe70:9e3b/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
       
[root@RS2 ~]# ifconfig lo 192.168.79.100 broadcast 192.168.79.100 netmask 255.255.255.255 up
[root@RS2 ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 192.168.79.100/32 brd 192.168.79.100 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:33:c1:e3 brd ff:ff:ff:ff:ff:ff
    inet 192.168.79.139/24 brd 192.168.79.255 scope global noprefixroute ens33
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe33:c1e3/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

//添加路由信息
RS1：
[root@RS1 ~]# route add -host 192.168.100.100/32 dev lo

RS2：
[root@RS2 ~]# route add -host 192.168.100.100/32 dev lo
```

<font style="color:rgb(53, 53, 53);">配置LVS</font>

```plain
//添加并保存规则
[root@DR ~]# ipvsadm -A -t 192.168.79.100:80 -s rr
[root@DR ~]# ipvsadm -a -t 192.168.79.100:80  -r  192.168.79.134:80 -g
[root@DR ~]# ipvsadm -a -t 192.168.79.100:80  -r  192.168.79.139:80 -g
[root@DR ~]# ipvsadm -Ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.79.100:80 rr
  -> 192.168.79.134:80            Route   1      0          0         
  -> 192.168.79.139:80            Route   1      0          0
[root@DR ~]# ipvsadm -Sn > /etc/sysconfig/ipvsadm
[root@DR ~]# cat /etc/sysconfig/ipvsadm
-A -t 192.168.79.100:80 -s rr
-a -t 192.168.79.100:80 -r 192.168.79.134:80 -g -w 1
-a -t 192.168.79.100:80 -r 192.168.79.139:80 -g -w 1
[root@DR ~]# systemctl restart ipvsadm.service 
[root@DR ~]# systemctl enable ipvsadm.service
```

<font style="color:rgb(53, 53, 53);">测试效果</font>

```plain
//客户端验证
[root@Client ~]# curl http://192.168.79.100
RS1
[root@Client ~]# curl http://192.168.79.100
RS2
[root@Client ~]# curl http://192.168.79.100
RS1
[root@Client ~]# curl http://192.168.79.100
RS2
```

<font style="color:rgb(53, 53, 53);">更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

## <font style="color:rgb(34, 34, 34);">LVS-TUN 模式</font>
###### <font style="color:black;">DR：关闭防火墙和selinux ，修改内核参数，开启IP转发</font>
```plain
[root@DR ~]# vim /etc/sysctl.conf 
net.ipv4.ip_forward = 1
[root@DR ~]# sysctl -p
net.ipv4.ip_forward = 1
[root@DR ~]# yum -y install ipvsadm
[root@DR ~]# ifconfig tunl0 192.168.79.55 broadcast 192.168.79.55 netmask 255.255.255.255 up
[root@DR ~]# ip a
.....
4: tunl0@NONE: <NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
  link/ipip 0.0.0.0 brd 0.0.0.0
  inet 192.168.79.55/32 brd 192.168.79.55 scope global tunl0
     valid_lft forever preferred_lft forever   
     
//RS1和RS2（两台主机操作一样）
关闭防火墙和selinux，部署httpd
```

###### <font style="color:black;">启用ipip模块</font>
```plain
RS1
[root@rs1 ~]# modprobe ipip
[root@rs1 ~]# ifconfig tunl0 192.168.79.55 broadcast 192.168.79.55 netmask 255.255.255.255 up

RS2
[root@rs2 ~]# modprobe ipip
[root@rs2 ~]# ifconfig tunl0 192.168.79.55 broadcast 192.168.79.55 netmask 255.255.255.255 up
```

###### <font style="color:black;">修改内核参数为</font>
```plain
RS1:
[root@RS1 ~]# vim /etc/sysctl.conf 
[root@RS1 ~]# sysctl -p
net.ipv4.conf.tunl0.arp_ignore = 1
net.ipv4.conf.tunl0.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.tunl0.rp_filter = 0
net.ipv4.conf.all.rp_filter = 0

RS2:
[root@RS2 ~]# vim /etc/sysctl.conf 
[root@RS2 ~]# sysctl -p
net.ipv4.conf.tunl0.arp_ignore = 1
net.ipv4.conf.tunl0.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.tunl0.rp_filter = 0
net.ipv4.conf.all.rp_filter = 0
```

<font style="color:rgb(53, 53, 53);">配置 LVS</font>

```plain
//DR上添加规则：
[root@DR ~]# ipvsadm -A -t 192.168.79.55:80 -s rr
[root@DR ~]# ipvsadm -a -t 192.168.79.55:80 -r 192.168.79.134 -i
[root@DR ~]# ipvsadm -a -t 192.168.79.55:80 -r 192.168.79.139 -i
[root@DR ~]# ipvsadm -Ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
-> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.79.55:80 rr
-> 192.168.79.134:80            Tunnel  1      0          0         
-> 192.168.79.139:80            Tunnel  1      0          0         
[root@DR ~]# ipvsadm -Sn > /etc/sysconfig/ipvsadm
[root@DR ~]# systemctl restart ipvsadm.service
```

<font style="color:rgb(53, 53, 53);">测试</font>

```plain
//客户端验证：
[root@Client ~]# curl http://192.168.79.55
RS1
[root@Client ~]# curl http://192.168.79.55
RS2
[root@Client ~]# curl http://192.168.79.55
RS1
[root@Client ~]# curl http://192.168.79.55
RS2
```

<font style="color:rgb(53, 53, 53);">前面提到了LVS的三种工作模式，其实，它还有另外一种工作模式 FULLNAT模式，所以，我们先来了解一下这种工作模式的具体原理。更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

## <font style="color:rgb(34, 34, 34);">LVS FULLNAT基本原理</font>
<font style="color:rgb(53, 53, 53);">NAT 模式中，负载均衡器和真实服务器必须在同一局域网内，但在实际的开发过程中，真实服务器可能分布在不同的网段，甚至不同的城市。如何能将 NAT 模式应用在真实服务器分布在不同网段的场景下？</font>

<font style="color:rgb(53, 53, 53);">LVS的NAT服务只提供了DNAT的功能。如果把经过了LVS服务的包在出LVS主机的时候，再做SNAT处理，就能够实现fullnat了。</font>![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%EF%BC%88%E5%9B%9B%E7%A7%8D%E6%A8%A1%E5%BC%8F%EF%BC%89%E9%9B%86%E7%BE%A4%E9%85%8D%E7%BD%AE%E5%AE%9E%E8%B7%B5-03.webp)

+ <font style="color:rgb(53, 53, 53);">（1）客户端将请求报文发送给VS；cip->vip</font>
+ <font style="color:rgb(53, 53, 53);">（2）VS将请求报文的目的地址修改为后端真实服务器(DNAT)，源地址改为自己的ip地址(SNAT)，发送给后端真实服务器；dip->rip</font>
+ <font style="color:rgb(53, 53, 53);">（3）后端服务器在处理完之后要将响应的报文返回给Lvs；rip->dip</font>
+ <font style="color:rgb(53, 53, 53);">（4）LVS将返回的数据包源地址改为自己(SNAT)，目的地址改为客户端(DNAT)，发送给客户端；vip->cip ，数据流走向：Client -> Vs -> Rs -> Vs -> client。</font>

<font style="color:rgb(53, 53, 53);">注：cip为客户端的地址，vip为虚拟地址，rip为真实的服务器，dip为本地地址，SNAT为来源地址转换，DNAT为目的地址转换</font>

**<font style="color:rgb(248, 57, 41);">架构特点：这是一种对nat模型的改进，是一个扩展，使得RS与Director可以处于不同网络,负载均衡器可以独立的和真实服务器进行数据包的传送。</font>**

+ <font style="color:rgb(53, 53, 53);">1.VIP是公网地址，RIP和DIP是私网地址，且通常不在同一IP网络，因此RIP的网关一般不会指向DIP。</font>
+ <font style="color:rgb(53, 53, 53);">2.RS收到的请求报文源地址是DIP，因此只需响应给DIP；但Director还要将其发往Client。</font>
+ <font style="color:rgb(53, 53, 53);">3.请求和响应报文都经由Director。</font>
+ <font style="color:rgb(53, 53, 53);">4.相对NAT模式，可以更好的实现LVS-RealServer间跨VLAN通讯。</font>
+ <font style="color:rgb(53, 53, 53);">5.支持端口映射。</font>

#### <font style="color:black;">IPVS FULLNAT实践</font>
<font style="color:rgb(53, 53, 53);">LVS的IP负载均衡技术是通过IPVS模块实现的。IPVS模块是LVS集群的核心软件模块，它安装在LVS集群作为负载均衡的主节点上，虚拟出一个IP地址和端口对外提供服务。用户通过访问这个虚拟服务（VS），然后访问请求由负载均衡器（LB）调度到后端真实服务器（RS）中，由RS实际处理用户的请求给返回响应。</font>![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%EF%BC%88%E5%9B%9B%E7%A7%8D%E6%A8%A1%E5%BC%8F%EF%BC%89%E9%9B%86%E7%BE%A4%E9%85%8D%E7%BD%AE%E5%AE%9E%E8%B7%B5-04.webp)

###### <font style="color:black;">配置IP</font>
```plain
VM1: eth0  10.1.1.10/24

VM2: eth0  10.1.1.1/24
     eth1  192.168.10.1/24

VM3: eth0  192.168.10.2/24
```

###### <font style="color:black;">lvs节点fullnat配置</font>
```plain
ipvsadm -A -t 10.1.1.1:80 -s rr
ipvsadm -a -t 10.1.1.1:80 -r 192.168.10.2:22 -q -w 1 //DNAT
ipvsadm -P -t 10.1.1.1:80 -z 192.168.10.1:90  //SNAT
```

###### <font style="color:black;">测试SSH</font>
```plain
ssh -p 80 root@10.1.1.1
```

<font style="color:rgb(53, 53, 53);">正常可以登录到VM3上。</font>

#### <font style="color:black;">ipvs主要参数</font>
```plain
添加虚拟服务器
    语法:ipvsadm -A [-t|u|f]  [vip_addr:port]  [-s:指定算法]
    -A:添加
    -t:TCP协议
    -u:UDP协议
    -f:防火墙标记
    -s:指定算法
    -D:删除虚拟服务器记录
    -E:修改虚拟服务器记录
    -C:清空所有记录
    -L:查看
添加后端RealServer
    语法:ipvsadm -a [-t|u|f] [vip_addr:port] [-r ip_addr] [-g|i|m] [-w 指定权重]
    -a:添加
    -t:TCP协议
    -u:UDP协议
    -f:防火墙标记
    -r:指定后端realserver的IP
    -g:DR模式
    -i:TUN模式
    -m:NAT模式
    -q:FULLNAT模式
    -w:指定权重
    -d:删除realserver记录
    -e:修改realserver记录
    -l:查看
通用:
    ipvsadm -ln:查看规则
```

<font style="color:rgb(53, 53, 53);">以上就是今天给大家分享的关于LVS的几种模式的配置。更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

_参考链接：https://blog.csdn.net/qq_15437629/_

_article/details/127343787 https://blog.csdn.net_

_/m0_72898391/article/details/127096428_

