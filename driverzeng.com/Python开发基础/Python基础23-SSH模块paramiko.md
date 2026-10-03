# Python基础23-SSH模块paramiko

## Python基础23-SSH模块paramiko
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(6) 评论(0)

+ [paramiko介绍](https://blog.driverzeng.com/zenglaoshi/5498.html#toc_0)

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

## paramiko介绍
---

| 什么是paramiko模块 |
| :--- |

paramiko是一个用于做远程控制的模块，使用该模块可以对远程服务器进行命令或文件操作，值得一说的是，fabric和ansible内部的远程管理就是使用的paramiko来现实。

---

| 安装paramiko模块 |
| :--- |

```plain
## 安装paramiko
MacBook-pro:~ driverzeng$ pip3 install paramiko
## 如果嫌慢可以用国内源
MacBook-pro:~ driverzeng$ pip3 install paramiko -i https://mirrors.aliyun.com/pypi/simple/
```

**在python2中**

```plain
pycrypto，由于 paramiko 模块内部依赖pycrypto，所以先下载安装pycrypto #在python2中
pip install pycrypto
pip install paramiko
注：如果在安装pycrypto2.0.1时发生如下错误
        command 'gcc' failed with exit status 1...
可能是缺少python-dev安装包导致
如果gcc没有安装，请事先安装gcc
```

---

| 使用paramiko模块 |
| :--- |

SSHClient

用于连接远程服务器并执行基本命令

**基于用户名密码连接：**

```plain
import paramiko
# 创建SSH对象
ssh = paramiko.SSHClient()
# 允许连接不在know_hosts文件中的主机
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
# 连接服务器
ssh.connect(hostname='10.0.0.200', port=22, username='root', password='1')
# 执行命令
stdin, stdout, stderr = ssh.exec_command('df')
# 获取命令结果
result = stdout.read()
print(result.decode('utf-8'))
# 关闭连接
ssh.close()
```

**SSHClient 封装 Transport**

```plain
import paramiko
transport = paramiko.Transport(('10.0.0.200', 22))
transport.connect(username='root', password='1')
ssh = paramiko.SSHClient()
ssh._transport = transport
stdin, stdout, stderr = ssh.exec_command('ifconfig')
res=stdout.read()
print(res.decode('utf-8'))
transport.close()
```

<!-- OCR_START -->
12
import paramiko
13
14
transport =paramiko.Transport（('10.0.0.200',22))
15
transport.connect（username='root',password='1')
16
17
ssh = paramiko.SSHClient()
18
ssh._transport = transport
19
20
stdin,stdout,stderr = ssh.exec_command('ifconfig')
21
res=stdout.read()
22
print(res.decode('utf-8'))
23
24
transport.close()
Run:
01paramiko模块
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python "/Users/driverzeng/Desktop/PYTHoN/并发编程/01 paramiko模块.py
eth0:fLagS=4163<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
inet 10.0.0.200 netmask 255.255.255.0 br0adcast 10.0.0.255
inet6 fe80:20c:29ff:fe4e:8444 prefixlen 64 scopeid 0x20<link>
ether 00:0c:29:4e:84:44 txqueuelen 1000 （Ethernet)
RX packets 168271 bytes 114147690 （108.8 MiB)
RX errors0dropped 0overruns 0 frame0
TX packets 80082 bytes 20624931 (19.6 MiB)
TX errors 0 dropped O overruns0carrier 0 collisions 0
lo:fLagS=73<UP,LOOPBACK,RUNNING> mtu 65536
inet 127.0.0.1 netmask 255.0.0.0
inet6 ::1 prefixlen 128 scopeid 0x10<host>
loop txqueuelen 1000 (Local Loopback)
RX packets 47 bytes 4060 (3.9 KiB)
TX errors 0dropped 0overruns0
frame 0
TX packets47
bytes 4060（3.9 KiB)
carrier 0
collisions 0
曾老湿
Driver Zeng
<!-- OCR_END -->

￼

**基于公钥密钥连接：**

客户端文件名：id_rsa

服务端必须有文件名：authorized_keys(在用ssh-keygen时，必须制作一个authorized_keys,可以用ssh-copy-id来制作)

```plain
import paramiko
private_key = paramiko.RSAKey.from_private_key_file('/tmp/id_rsa')
# 创建SSH对象
ssh = paramiko.SSHClient()
# 允许连接不在know_hosts文件中的主机
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
# 连接服务器
ssh.connect(hostname='10.0.0.200', port=22, username='root', pkey=private_key)
# 执行命令
stdin, stdout, stderr = ssh.exec_command('ifconfig')
# 获取命令结果
result = stdout.read()
print(result.decode('utf-8'))
# 关闭连接
ssh.close()
```

SSHClient 封装 Transport

```plain
import paramiko
private_key = paramiko.RSAKey.from_private_key_file('/tmp/id_rsa')
transport = paramiko.Transport(('10.0.0.200', 22))
transport.connect(username='root', pkey=private_key)
ssh = paramiko.SSHClient()
ssh._transport = transport
stdin, stdout, stderr = ssh.exec_command('df')
result=stdout.read()
print(result.decode('utf-8'))
transport.close()
```

基于私钥字符串进行连接:

```plain
import paramiko
from io import StringIO
key_str = """-----BEGIN RSA PRIVATE KEY-----
MIIEoQIBAAKCAQEAsJmFLrSeCumJvga0Gl5O5wVOVwMIy2MpqIyQPi5J87dg89a4
Da9fczJog7qoSbRwHFOQoCHNphSlp5KPhGsF6RJewkIw9H1UKV4dCOyl/4HOAkAD
rKrsEDmrJ9JlzF2GTTZSnTgVQWcvBS2RKB4eM2R9aJ11xV6X2Hk4YDLTExIWeabb
h2TUKw0iyjI8pRuYLKkF2X16u9TBwfOTroGYgiNFHQvhsQppbEbI49NF2XkCkFMi
8/7tLjf95InE/VUUq56JqfzyHwdpHou+waXbwtvGgXN3sz+KkuEv6R2qDz06upZV
FCZRRpDhzoR8Uh/UEzTGZb8z7FB6EJXUiXJikQIBIwKCAQBBmBuGYFf1bK+BGG7H
9ySe81ecqVsJtx4aCFLVRGScWg4RbQKIvXs5an6XU/VdNGQnx0RYvBkvDvuzRRC8
J8Bd4kB0CfTtGJuaVigKoQp02HEWx1HSa17+tlWD0c4KFBvwywi+DYQ83S64x8gz
eOalX9bPFenqORPUD8R7gJeKvPVc6ZTPeorpuH7u9xayP0Eop8qKxZza9Xh3foVj
Qo4IxoYnDN57CIRX5PFSlDDggpmr8FtRF4nAxmFq8LhSp05ivzX/Ku1SNHdaMWZO
7va8tISXdLI5m0EGzoVoBvohIbwlxI6kfmamrh6Eas2Jnsc4CLzMsR4jBWt0LHLv
/SLnAoGBANaEUf/Jptab9G/xD9W2tw/636i3gLpTPY9KPtCcAxqStNeT6RAWZ5HF
lKJg+NKpu3pI45ldAwvts0i+aCZk2xakEWIZWqCmXm31JSPDQTaMGe7H0vOmUaxx
ncdpBVdvhMbfFUgei15iKfuafgrKaS9oIkntXEgrC+3wBOI0Gbx3AoGBANLAGxAF
TK7ydr+Q1+6/ujs6e8WsXt8HZMa/1khCVSbrf1MgACvZPSSSrDpVwaDTSjlRI4AL
bb0l0RFU+/0caMiHilscuJdz9Fdd9Ux4pjROZa3TF5CFhvP7PsZAoxOo+yqJg4zr
996GG/aAv4M8lQJ2rDFk/Dgn5y/AaAun1oM3AoGAGIQmoOPYjY4qkHNSRE9lYOl4
pZFQilKn8x5tlC8WTC4GCgJGhX7nQ9wQ/J1eQ/YkDfmznH+ok6YjHkGlgLsRuXHW
GdcDCwuzBUCWh76LHC1EytUCKnloa3qy8jfjWnMlHgrd3FtDILrC+C7p1Vj2FAvm
qVz0moiTpioPL8twp9MCgYEAin49q3EyZFYwxwdpU7/SJuvq750oZq0WVriUINsi
A6IR14oOvbqkhb94fhsY12ZGt/N9uosq22H+anms6CicoQicv4fnBHDFI3hCHE9I
pgeh50GTJHUA6Xk34V2s/kp5KpThazv6qCw+QubkQExh660SEdSlvoCfPKMCi1EJ
TukCgYAZKY1NZ2bjJyyO/dfNvMQ+etUL/9esi+40GUGyJ7SZcazrN9z+DO0yL39g
7FT9NMIc2dsmNJQMaGBCDl0AjO1O3b/wqlrNvNBGkanxn2Htn5ajfo+LBU7yHAcV
7w4X5HLarXiE1mj0LXFKJhdvFqU53KUQJXBqR6lsMqzsdPwLMJg==
-----END RSA PRIVATE KEY-----"""
private_key = paramiko.RSAKey(file_obj=StringIO(key_str))
transport = paramiko.Transport(('10.0.0.200', 22))
transport.connect(username='root', pkey=private_key)
ssh = paramiko.SSHClient()
ssh._transport = transport
stdin, stdout, stderr = ssh.exec_command('ifconfig')
result = stdout.read()
print(result.decode('utf-8'))
transport.close()
print(result)
```

用于连接远程服务器并执行上传下载

基于用户名密码上传下载

```plain
import paramiko
 
transport = paramiko.Transport(('10.0.0.200',22))
transport.connect(username='root',password='1')
 
sftp = paramiko.SFTPClient.from_transport(transport)
# 将location.py 上传至服务器 /tmp/test.py
sftp.put('/tmp/id_rsa', '/etc/test.rsa')
# 将remove_path 下载到本地 local_path
sftp.get('remove_path', 'local_path')
 
transport.close()
```

基于公钥密钥上传下载

```plain
import paramiko
private_key = paramiko.RSAKey.from_private_key_file('/tmp/id_rsa')
transport = paramiko.Transport(('10.0.0.200', 22))
transport.connect(username='root', pkey=private_key )
sftp = paramiko.SFTPClient.from_transport(transport)
# 将location.py 上传至服务器 /tmp/test.py
sftp.put('/tmp/id_rsa', '/tmp/a.txt')
# 将remove_path 下载到本地 local_path
sftp.get('remove_path', 'local_path')
transport.close()
```

Demo

```plain
#!/usr/bin/env python
# -*- coding:utf-8 -*-
import paramiko
import uuid
class Haproxy(object):
    def __init__(self):
        self.host = '10.0.0.200'
        self.port = 22
        self.username = 'root'
        self.pwd = '1'
        self.__k = None
    def create_file(self):
        file_name = str(uuid.uuid4())
        with open(file_name,'w') as f:
            f.write('sb')
        return file_name
    def run(self):
        self.connect()
        self.upload()
        self.rename()
        self.close()
    def connect(self):
        transport = paramiko.Transport((self.host,self.port))
        transport.connect(username=self.username,password=self.pwd)
        self.__transport = transport
    def close(self):
        self.__transport.close()
    def upload(self):
        # 连接，上传
        file_name = self.create_file()
        sftp = paramiko.SFTPClient.from_transport(self.__transport)
        # 将location.py 上传至服务器 /tmp/test.py
        sftp.put(file_name, '/home/root/tttttttttttt.py')
    def rename(self):
        ssh = paramiko.SSHClient()
        ssh._transport = self.__transport
        # 执行命令
        stdin, stdout, stderr = ssh.exec_command('mv /home/root/tttttttttttt.py /home/root/ooooooooo.py')
        # 获取命令结果
        result = stdout.read()
ha = Haproxy()
ha.run()
Demo
```

关于 曾老湿

> 更新: 2020-06-25 11:28:45  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/owndsb>