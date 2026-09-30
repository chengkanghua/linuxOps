# SSH基本概述
SSH<font style="color:#333333;">是</font>Secure Shell Protocol<font style="color:#333333;">的简写，在进行数据传输之前，SSH先对联机数据包通过加密技术进行加密处理，加密后在进行数据传输。确保了传递的数据安全。</font>

## 1.SSH远程服务主要功能
1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">安全远程登录</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">替代 Telnet 明文登录，全程加密，远程操控服务器终端。</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">安全文件传输</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">内置 </font>`<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">scp/sftp</font>`<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，加密上传、下载文件，防止窃听篡改。</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">端口转发 / 隧道穿透</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">支持 </font>`<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">-L</font>`<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 本地转发、</font>`<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">-R</font>`<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 远程转发、</font>`<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">-D</font>`<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 动态代理，实现</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">内网穿透、跳板机、隐藏真实 IP</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">。</font>
4. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">远程执行命令</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无需交互式登录，可直接远程单机 / 批量执行命令、脚本，方便运维自动化。</font>
5. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">图形界面转发 (X11)</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">可远程运行服务端图形化程序，画面渲染到本地。</font>
6. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">连接复用</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">支持长连接复用，一次认证后短时内秒连，不用重复输密码、验密钥。</font>

## 2.远程连接方式有哪些
### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令行终端远程（运维最常用）</font>
1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">SSH</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">主流标准，加密安全，跨平台，Linux/Windows11/Mac 都支持，远程登录、命令操作、跳板、隧道都靠它。</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Telnet</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">明文传输，不安全，老旧网络设备偶尔用，</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">生产环境基本禁用</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">。</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">IPMI/Console 串口</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">物理底层远程，系统崩了、SSH 连不上也能进，机房运维、服务器硬件管理用。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">图形桌面远程</font>
1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">RDP 远程桌面</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Windows 自带，Windows 连 Windows 图形桌面。</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">VNC / XRDP</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">跨平台，Linux 远程图形桌面，Windows/Mac 也能连。</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">第三方工具</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">向日葵、ToDesk、TeamViewer，自带内网穿透，不用公网 IP，普通人 / 运维都常用。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">文件类远程连接（远程传文件 / 共享）</font>
1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">SFTP/SCP</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">基于 SSH 加密，远程上传下载文件。</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">FTP/TFTP</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">FTP 明文不安全；TFTP 多用于网络设备系统部署。</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Samba/SMB</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">局域网 Windows 与 Linux 文件夹远程共享。</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Web 网页式远程</font>
1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">WebSSH</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">浏览器直接连服务器命令行，不用装客户端。</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">堡垒机 / 云厂商网页终端</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">企业运维统一入口，权限管控、操作审计。</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">面板管理</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">宝塔、云主机控制台，网页可视化管理服务器。</font>

## <font style="color:#333333;">3.</font>SSH<font style="color:#333333;">远程连接与</font>Telnet<font style="color:#333333;">远程连接区别</font>
ssh<font style="color:#6F6F6F;">服务是加密服务协议，</font>telnet<font style="color:#6F6F6F;">服务是非加密服务协议</font>

ssh服务默认支持root用户登录，Telnet默认不支持root用户登录

<font style="color:#6F6F6F;background-color:#ffff00;"></font>

_<font style="color:#FF0000;">案例: 使用</font>_wireshark_<font style="color:#FF0000;">验证</font>_telnet_<font style="color:#FF0000;">明文传输与</font>_ssh_<font style="color:#FF0000;">加密传输</font>_

## 1.安装telnet服务并运行
```bash
yum install telnet-server -y
systemctl start telnet.socket
```

## 2.使用wireshark检测vmnet8网卡上的telnet流量
![](img/SSH%20%E6%A0%B8%E5%BF%83%E7%9F%A5%E8%AF%86-01.png)



## 3.telnet是无法使用root用户登录Linux系统，需要创建普通用户
```bash
useradd od
echo "1"  | passwd --stdin od
```

## 4.使用普通用户进行telnet登录
```bash
[e:\~]$ telnet 10.0.0.7 22   #探测22 主机是不是开放了22端口
[e:\~]$ telnet 10.0.0.7   # 登入 按提示输入账号密码

```

## 5.搜索<font style="color:#333333;">wireshark</font>包含<font style="color:#333333;">telnet</font>相关的流量
![](img/SSH%20%E6%A0%B8%E5%BF%83%E7%9F%A5%E8%AF%86-02.png)

![](img/SSH%20%E6%A0%B8%E5%BF%83%E7%9F%A5%E8%AF%86-03.png)

![](img/SSH%20%E6%A0%B8%E5%BF%83%E7%9F%A5%E8%AF%86-04.png)



扩展：

```bash
$ echo "nneettssttaatt  --llnnttpp" |sed -r 's#(.)(.)#\2#g'
netstat -lntp

#测试服务端口有没有开启
telnet 10.0.0.41 22
ss -lntup|grep 22
netstat -lntup
nmap -p 22 10.0.0.41
nc 10.0.0.41 22

SSH远程连接不上，怎么办
   服务端
       22端口是否打开（telnet、nmap检测）
       防火墙是否允许能连接22端口
   客户端
       1.ping 127.0.0.1 检测TCP/IP协议栈（检查网卡是否故障）
       2.ping 172.16.1.31 排查是否是交换机故障
       3.ping 网关地址 数据包是否能抵达路由器
       4.ping 域名   检查DNS是否异常

        
```



# SSH 相关命令
```bash
SSH服务使一个C/S架构，有服务端，就有客户端
   Windows客户端（Xshell、CRT）
   Linux客户端（ssh命令）

# yum provides `which ssh`
# rpm -qf `which ssh`

# rpm -ql openssh-server
/etc/ssh/sshd_config    --- ssh服务配置文件
/usr/sbin/sshd          --- ssh服务进程启动命令

# rpm -ql openssh-clients
/usr/bin/scp            --- 远程拷贝命令
/usr/bin/sftp           --- 远程文件传输命令
/usr/bin/ssh            --- 远程连接登录命令
/usr/bin/ssh-copy-id    --- 远程分发公钥命令

```



## 1.ssh远程登录服务器命令
```bash
 ssh -p22 root@10.0.0.150 [命令]
   # SSH连接远程主机命令的基本语法;
   # ssh 命令
   # -p(小写), 用于指定远程主机端口，默认22端口可省略
   # root@remotehost
   # "@"前面为用户名，如果用当前用户连接，可以不指定用户
   # "@"后面为要连接的服务器的IP

$ telnet 172.16.1.7
Trying 172.16.1.7...
Connected to 172.16.1.7.

Kernel 3.10.0-862.el7.x86_64 on an x86_64
web01 login: od
Password:
Last login: Mon Sep 10 17:28:00 from ::ffff:10.0.0.1
[od@web01 ~]$
```



## 2.scp复制数据至远程主机命令(全量复制)
```bash
SSH连接远程主机命令的基本语法;
  scp 命令
    -P(大写) 指定端口，默认22端口可不写
    -r 表示递归拷贝目录
    -p 表示在拷贝文件前后保持文件或目录属性不变
    -l 限制传输使用带宽(默认kb)
   
 推：PUSH,上传
 scp -P22 -rp /tmp/oldboy oldboy@10.0.0.150:/tmp
   /tmp/oldboy为本地的目录。
   “@”前为用户名
   “@”后为要连接的服务器的IP。
   IP后的:/tmp目录，为远端的目标目录。
   说明: 以上命令作用是把本地/tmp/oldboy推送至远端服务器10.0.0.150的/tmp目录

拉：PULL,下载
scp -P22 -rp root@10.0.0.7:/tmp/oldboy /opt/
# 还可以将远端目录或文件拉取至本地

推
scp -rp nfs-file root@172.16.1.7:/tmp
拉
scp -rp  root@172.16.1.7:/tmp/yum.log  /tmp/

结论：
1.scp通过加密进行远程拷贝文件或目录的命令。
2.scp拷贝权限为连接的用户对应的权限。
3.scp支持数据的推送和拉取，但每次都是全量拷贝，效率低下。

扩展：
# -l 限速传输
scp -p22 -l 1024  -rp /火影4K官方宣传片.mp4 root@172.16.1.31:/tmp

```



## 3.Sftp远程数据传输命令
```bash
连接远程sftp
sftp root@192.168.56.12
# sftp -oPort=52113 root@10.0.0.41  <-sftp的特殊端口连接

# 下载文件, 至于本地服务器
sftp> get conf.txt /tmp/

# 上传本地服务器文件, 至远程服务器
sftp> put /root/t1.txt /root/

sftp  --->XFTP
	1 支持批量上传文件
	2 支持单个文件大于4G
	3 支持断点断续

扩展
克隆一台虚拟机操作
hostnamectl set-hostname m01
sed -i 's#222#61#g' /etc/sysconfig/network-scripts/ifcfg-eth[01]

重启生效

```

# 3.SSH连接方式*****
+ **<font style="color:rgb(51, 51, 51);">定义</font>**<font style="color:rgb(51, 51, 51);">：Secure Shell，加密的远程登录协议，替代明文的 Telnet/FTP，默认端口 22</font>
+ <font style="color:rgb(51, 51, 51);">核心原理：  非对称加密握手 + 对称加密传输</font>
    1. <font style="color:rgb(51, 51, 51);">客户端发起连接，服务端返回自己的公钥</font>
    2. <font style="color:rgb(51, 51, 51);">客户端生成随机会话密钥，用服务端公钥加密后发送</font>
    3. <font style="color:rgb(51, 51, 51);">服务端用私钥解密得到会话密钥</font>
    4. <font style="color:rgb(51, 51, 51);">后续所有数据都用这个</font>**<font style="color:rgb(51, 51, 51);">对称会话密钥</font>**<font style="color:rgb(51, 51, 51);">加密传输 ， 这个临时会话密码只存再内存里， 下次连接会重新算。</font>



```bash
#1.你需要登录哪台服务器，就将自己的公钥推送至对应的服务器即可
#1.创建密钥对
ssh-keygen -t rsa -C xuliangwei.com   #一路回车即可
[root@m01 ~]# ls ~/.ssh/
id_rsa(钥匙)  id_rsa.pub(锁头)

#2.发送密钥给需要登录的服务器即可
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.31
   
#Manager能通过密钥的方式连接  nfs和backup以及web
命令示例: ssh-copy-id [-i [identity_file]] [user@]machine
ssh-copy-id //命令
-i          //指定下发公钥的路径
[user@]     //以什么用户身份进行公钥分发（root）,如果不输入，表示以当前系统用户身份分发公钥
machine     //下发公钥至那台服务器, 填写远程主机IP地址  

# 远程登录对端主机方式
ssh root@172.16.1.41

# 不登陆远程主机执行命令
ssh root@172.16.1.41 "hostname -i"


# 可能遇到错误
1.no route to host   防火墙
2.Connection refused 防火墙或服务未启用

1.Linux实现秘钥管理
   ssh-keygen
2.Window实现秘钥登录服务器
   1.Xshell工具->新建密钥生成工具->猛击下一步
   2.连接服务器，在当前用户的家目录创建.ssh目录（权限700）
   3.在.ssh目录新建authorized_keys，权限是600
   4.找到xshell里面工具-》用户秘钥管理者-》选中对应的秘钥-》属性-》公钥-》复制
   5.将复制好的公钥粘贴至  ~/.ssh/authorized_keys中 ，保存，然后测试
   6.Xshell 登入时候 密码选择 Pubilc key  浏览用户密钥 登入
   
   
4.SSH访问控制  （还没讲）
   变更端口
   不使用公网IP
   禁止root登录
   禁止使用密码登录
```



# 5.SSH练习案例
```bash
#1.使用root用户完成一把钥匙开多把锁A钥匙，BC锁
#生成公钥和私钥
ssh-keygen -t rsa -C chengkanghua@foxmail.com
#分发A公钥至（BC）
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.31
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.41


# 2.在不破坏题1的前提下，完成多把钥匙开一把锁BC钥匙，A锁
# 生成公钥和私钥（b)
ssh-keygen -t rsa -C nfs@linux.com
# b 下发公钥给 A
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.61

# 生成公钥和私钥（C）
ssh-keygen -t rsa -C backup#linux.com
# c 下发公钥给 A
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.61

#3.如何实现从A指定目录或文件分发到BC服务器
scp -rp /tmp/yum.log root@172.16.1.31:/tmp
scp -rp /tmp/yum.log  root@172.16.1.41:/tmp

#4.如何快速查看所有机器的load，CPU，Memory等信息
#(思考:如果服务器数量多，如何并发查看和分发数据)
cat > test.sh<<EOF
#!/usr/bin/bash
[ $# -ne 1 ] && echo "输入执行的命令" && exit 1
for i in 31 41
do
	echo "#################172.16.1.$i######################"
	ssh root@172.16.1.$i "$1"
done
EOF

# 测试脚本
sh test.sh "free -h"

```



# 批量分发公钥 免去每次输入密码
```bash
# 1.创建密钥对
ssh-keygen -t rsa -C xuliangwei.com   #一路回车即可
[root@m01 ~]# ls ~/.ssh/
id_rsa(钥匙)  id_rsa.pub(锁头)

# 2#发送密钥给需要登录的用户
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.31

yum install sshpass -y
sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.5


for i in {7..255}; do sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" \
root@192.168.34.$i; done


```





## ssh远程连接不上，怎么办？
```plain
ssh -p22 root@192.168.1.31
服务端：
	22端口是否打开（telnet 、nmap检测）
  防火墙是否允许能连接22端口
客户端
	1. ping 127.0.0.1 检测TCP/IP 协议栈(检查网卡是否故障)
  2. ping 192.168.1.1 排查是否交换机故障
  3. ping 网关地址 数据库包是否能抵达路由器
  4. ping 域名  检查DNS是否异常
  
```



```plain
# echo "llnnttuupp --llnnttuupp"|sed -r 's#([a-Z-]{1}).#\1#g'
lntup -lntup

# echo "llnnttuupp --llnnttuupp"|sed -r 's#(.)(.)#\1#g'
lntup -lntup

```

# 面试题
## [企业面试题] 如果给你一个进程名 mongo，如何查看对应的端口是什么？
netstat/ss -lntup|grep mongo



## [企业面试题] 给你一个端口，如何命令行查出对应的服务是什么？
ss -lntup|grep 22

netstat -lntup|grep -w '22'

lsof -i:22



grep -w 22 /etc/services

grep  '\b22/' /etc/services   #\b  退格(BS) ，将当前位置移到前一列

grep '\b22/\b' /etc/services

nmap -p 22 172.16.1.41

nc 192.168.1.32 22

telnet 192.168.1.32 22



## 面试题： 用户访问网站的原理过程是什么样的？
  01. DNS域名解析，获悉域名对应的IP地址

  02. 根据IP地址访问网站服务器，TCP三次握手过程

  03. 用户想网站服务器请求信息，HTTP请求过程（http请求报文）

  3.5 把公司架构再介绍一下

  04. 网站服务对用户请求进行响应，HTTP响应过程（HTTP响应报文）

      说明03 04 步骤称为HTTP协议原理过程

  05. 断开网络连接，TCP四次挥手过程





# <font style="color:rgb(51, 51, 51);">SSH 核心知识与面试高频考点（运维工程师版）</font>
<font style="color:rgb(51, 51, 51);">按</font>**<font style="color:rgb(51, 51, 51);">面试权重 + 工作重要性</font>**<font style="color:rgb(51, 51, 51);">排序，全部是实际会问到、会用到的内容</font>

---

## <font style="color:rgb(51, 51, 51);">一、基础核心（必问）</font>
### <font style="color:rgb(51, 51, 51);">1. SSH 本质与原理</font>
+ **<font style="color:rgb(51, 51, 51);">定义</font>**<font style="color:rgb(51, 51, 51);">：Secure Shell，加密的远程登录协议，替代明文的 Telnet/FTP，默认端口 22</font>
+ <font style="color:rgb(51, 51, 51);">核心原理：</font>

<font style="color:rgb(51, 51, 51);">非对称加密握手 + 对称加密传输</font>

    1. <font style="color:rgb(51, 51, 51);">客户端发起连接，服务端返回自己的公钥</font>
    2. <font style="color:rgb(51, 51, 51);">客户端生成随机会话密钥，用服务端公钥加密后发送</font>
    3. <font style="color:rgb(51, 51, 51);">服务端用私钥解密得到会话密钥</font>
    4. <font style="color:rgb(51, 51, 51);">后续所有数据都用这个</font>**<font style="color:rgb(51, 51, 51);">对称会话密钥</font>**<font style="color:rgb(51, 51, 51);">加密传输 ， 这个临时会话密码只存再内存里， 下次连接会重新算。</font>

<font style="color:rgb(51, 51, 51);"></font>

![](img/SSH%20%E6%A0%B8%E5%BF%83%E7%9F%A5%E8%AF%86-05.png)

**<font style="color:rgb(51, 51, 51);">为什么用两种加密？</font>**

<font style="color:rgb(51, 51, 51);">✅</font><font style="color:rgb(51, 51, 51);"> </font>**<font style="color:rgb(51, 51, 51);">非对称加密</font>**<font style="color:rgb(51, 51, 51);">（公钥 + 私钥）：安全但速度慢，只用来</font>**<font style="color:rgb(51, 51, 51);">安全传递会话密钥</font>**

<font style="color:rgb(51, 51, 51);">✅</font><font style="color:rgb(51, 51, 51);"> </font>**<font style="color:rgb(51, 51, 51);">对称加密</font>**<font style="color:rgb(51, 51, 51);">（同一个密钥）：速度快，用来</font>**<font style="color:rgb(51, 51, 51);">传输实际数据</font>**

<font style="color:rgb(51, 51, 51);">两者结合，既安全又高效。</font>

**<font style="color:rgb(51, 51, 51);">私钥绝对不能泄露</font>**

<font style="color:rgb(51, 51, 51);">私钥是你的身份凭证，就像你的银行卡密码。谁拿到你的私钥，谁就能登录你所有授权过的服务器。</font>

**<font style="color:rgb(51, 51, 51);">公钥可以随便分发</font>**

<font style="color:rgb(51, 51, 51);">公钥就像你的收款码，发给任何人都没关系，只能用来给你加密信息，不能解密。</font>

<font style="color:rgb(51, 51, 51);">扩展</font>

```plain
SSH 的「会话密钥」到底是什么？
就是 SSH 自动随机生成的一串 二进制乱码字符串
长度固定，常见： 128 位、192 位、256 位 二进制密钥
对应 对称AES加密算法： AES-128  AES-192  AES-256   
这个对称密钥不会在网络上明文传

SSH 的「会话密钥」的工作方式？
任一方： 发送的明文 + AES 算法 + 会话密钥 → 变成密文
对方：   接收的 密文 + AES 算法 + 同一个会话密钥 → 还原明文

AES算法原理：
AES 是对称分组加密算法，先把数据按 128 比特分组，通过字节替换、行移位、列混合、轮密钥加多轮循环打乱混淆，结合会话密钥生成密文；解密用同一密钥反向运算还原明文，只打乱加密、不压缩体积。
```

### <font style="color:rgb(51, 51, 51);">2. 两种认证方式（高频考点）</font>
| **<font style="color:rgb(51, 51, 51);">认证方式</font>** | **<font style="color:rgb(51, 51, 51);">原理</font>** | **<font style="color:rgb(51, 51, 51);">安全性</font>** | **<font style="color:rgb(51, 51, 51);">适用场景</font>** |
| :--- | :--- | :--- | :--- |
| <font style="color:rgb(51, 51, 51);">密码认证</font> | <font style="color:rgb(51, 51, 51);">客户端输入密码，服务端验证</font> | <font style="color:rgb(51, 51, 51);">低（易被暴力破解）</font> | <font style="color:rgb(51, 51, 51);">临时登录、个人测试</font> |
| <font style="color:rgb(51, 51, 51);">密钥认证</font> | <font style="color:rgb(51, 51, 51);">客户端持有私钥，服务端保存公钥，通过数学签名验证</font> | <font style="color:rgb(51, 51, 51);">高（无法暴力破解）</font> | <font style="color:rgb(51, 51, 51);">生产环境、自动化脚本、批量管理</font> |


### <font style="color:rgb(51, 51, 51);">密钥认证过程</font>
`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ssh-keygen</font>`<font style="color:rgb(51, 51, 51);"> 生成：</font>**<font style="color:rgb(51, 51, 51);">私钥 + 公钥</font>**<font style="color:rgb(51, 51, 51);"> 一对</font>

`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ssh-copy-id</font>`<font style="color:rgb(51, 51, 51);"> 推送公钥时，</font>**<font style="color:rgb(51, 51, 51);">第一次必须输服务器账号密码</font>**

<font style="color:rgb(51, 51, 51);">推送完以后，下次登录</font>**<font style="color:rgb(51, 51, 51);">不用输服务器密码</font>**<font style="color:rgb(51, 51, 51);">，直接免密进</font>

<font style="color:rgb(51, 51, 51);">客户端、服务器</font>**<font style="color:rgb(51, 51, 51);">各自存什么文件、存在哪</font>**<font style="color:rgb(51, 51, 51);">，我给你讲死</font>

<font style="color:rgb(51, 51, 51);">	</font><font style="color:rgb(51, 51, 51);">服务器 ~/.ssh/authorized_keys 存所有允许免密登录的客户端公钥</font>

<font style="color:rgb(51, 51, 51);">	</font><font style="color:rgb(51, 51, 51);">客户端 ~/.ssh/known_hosts 服务器的SSH公钥原文 /etc/ssh/ssh_host_ecdsa_key.pub</font>

<font style="color:rgb(51, 51, 51);">推送公钥的登录过程，</font>**<font style="color:rgb(51, 51, 51);">和普通 SSH 登录原理一模一样</font>**

```plain
[root@ckh ~]# ssh-keygen #默认是rsa算法
[root@ckh ~]# ll ~/.ssh
total 8
-rw------- 1 root root 1679 May  1 04:34 id_rsa      #私钥
-rw-r--r-- 1 root root  390 May  1 04:34 id_rsa.pub  #公钥

[root@ckh ~]# ssh-copy-id root@10.0.0.4  # 把公钥拷贝到要免密登录的 服务器
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '10.0.0.4 (10.0.0.4)' can't be established.
ECDSA key fingerprint is SHA256:CTk4zIu2CMmmHXcx1Ii7RaEZ8Y1Ok0i3Pl8NuAYoEfc.
ECDSA key fingerprint is MD5:52:ad:6a:2e:e4:1b:25:88:51:6a:ba:e0:60:91:bc:ad.
Are you sure you want to continue connecting (yes/no)?

#这里的指纹验证  是到真实服务器上查看比对 ， 
# 1. 查看SHA256格式的指纹（和你本地第一行比对）
ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub
# 2. 查看MD5格式的指纹（和你本地第二行比对）
ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub -E md5

# yes 回车之后

# 把你本地 id_rsa.pub 里面一长串字符，追加写到服务器 authorized_keys 文件末尾
cat ~/.ssh/authorized_keys  

# 服务器的文件权限 700 600
[root@backup ~]# ll -d ~/.ssh
drwx------ 2 root root 29 May  1 19:12 /root/.ssh
[root@backup ~]# ll -d ~/.ssh/authorized_keys
-rw------- 1 root root 390 May  1 19:12 /root/.ssh/authorized_keys

# 客户端存服务器的公钥原文  
~/.ssh/known_hosts

# 服务器的公钥是哪里的？
# 服务器的 SSH 公私钥，是系统安装 OpenSSH 时，自动就帮你生成好了！
[root@backup ~]# ll /etc/ssh/ssh_host*
-rw-r-----. 1 root ssh_keys  227 Aug 28  2024 /etc/ssh/ssh_host_ecdsa_key
-rw-r--r--. 1 root root      162 Aug 28  2024 /etc/ssh/ssh_host_ecdsa_key.pub
-rw-r-----. 1 root ssh_keys  387 Aug 28  2024 /etc/ssh/ssh_host_ed25519_key
-rw-r--r--. 1 root root       82 Aug 28  2024 /etc/ssh/ssh_host_ed25519_key.pub
-rw-r-----. 1 root ssh_keys 1675 Aug 28  2024 /etc/ssh/ssh_host_rsa_key
-rw-r--r--. 1 root root      382 Aug 28  2024 /etc/ssh/ssh_host_rsa_key.pub
# cat /etc/ssh/ssh_host_ecdsa_key.pub  和这里的内容一样
```

---

## <font style="color:rgb(51, 51, 51);">免密登录完整流程（分发完免密公钥之后）</font>
#### <font style="color:rgb(51, 51, 51);">前置条件（不变）</font>
1. <font style="color:rgb(51, 51, 51);">客户端：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ssh-keygen -t ed25519</font>`<font style="color:rgb(51, 51, 51);"> 生成用户私钥</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh/id_ed25519</font>`<font style="color:rgb(51, 51, 51);">和公钥</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh/id_ed25519.pub</font>`
2. <font style="color:rgb(51, 51, 51);">服务器：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ssh-copy-id user@server</font>`<font style="color:rgb(51, 51, 51);"> 将客户端公钥追加到</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh/authorized_keys</font>`
3. <font style="color:rgb(51, 51, 51);">权限要求：客户端私钥</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">600</font>`<font style="color:rgb(51, 51, 51);">，服务器</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">.ssh</font>`<font style="color:rgb(51, 51, 51);">目录</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">700</font>`<font style="color:rgb(51, 51, 51);">，</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">authorized_keys</font>`<font style="color:rgb(51, 51, 51);">文件</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">600</font>`

### <font style="color:rgb(51, 51, 51);">第一阶段：【阶段1 纯明文通道 到加密通道】</font>
<font style="color:rgb(51, 51, 51);">客户端向服务器 22 端口发起 TCP 三次握手，建立纯明文的基础网络连接。</font>

**<font style="color:rgb(51, 51, 51);">此时所有数据都是明文传输</font>**<font style="color:rgb(51, 51, 51);">。</font>

<font style="color:rgb(51, 51, 51);">这一阶段全程</font>**<font style="color:rgb(51, 51, 51);">明文传输</font>**<font style="color:rgb(51, 51, 51);">，目标是协商出一个双方都认可的加密通道，之后所有数据都走加密通道。</font>

#### <font style="color:rgb(51, 51, 51);">步骤 1：版本号交换</font>
+ <font style="color:rgb(51, 51, 51);">客户端发送自己的 SSH 版本号：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">SSH-2.0-OpenSSH_8.0</font>`
+ <font style="color:rgb(51, 51, 51);">服务器返回自己的 SSH 版本号：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">SSH-2.0-OpenSSH_8.0</font>`
+ <font style="color:rgb(51, 51, 51);">客户端把自己的 </font>**<font style="color:rgb(51, 51, 51);">Client Random</font>**<font style="color:rgb(51, 51, 51);"> （随机数） 明文发给服务器</font>
+ <font style="color:rgb(51, 51, 51);">服务器把自己的 </font>**<font style="color:rgb(51, 51, 51);">Server Random</font>**<font style="color:rgb(51, 51, 51);"> （随机数） 明文发给客户端</font>
+ <font style="color:rgb(51, 51, 51);">双方确认都使用 SSH-2 协议（SSH-1 已废弃）</font>

#### <font style="color:rgb(51, 51, 51);">步骤 2：算法协商 + 服务器发送主机公钥</font>
+ <font style="color:rgb(51, 51, 51);">客户端发送自己支持的所有算法列表：加密算法、签名算法、密钥交换算法、哈希算法</font>
+ <font style="color:rgb(51, 51, 51);">服务器返回自己支持的所有算法列表</font>
+ <font style="color:rgb(51, 51, 51);">双方按优先级协商出本次连接使用的</font>**<font style="color:rgb(51, 51, 51);">算法组合</font>**
+ **<font style="color:rgb(51, 51, 51);">关键：服务器同时把自己的主机公钥（</font>**`**<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">/etc/ssh/ssh_host_\*.pub</font>**`**<font style="color:rgb(51, 51, 51);">）发给客户端</font>**

#### <font style="color:rgb(51, 51, 51);">步骤 3：客户端验证服务器身份（防中间人）</font>
<font style="color:rgb(51, 51, 51);">客户端收到服务器主机公钥后，和本地</font>

+ <font style="color:rgb(51, 51, 51);">~/.ssh/known_hosts</font>

<font style="color:rgb(51, 51, 51);">中对应 IP 的</font>

<font style="color:rgb(51, 51, 51);">完整公钥原文</font>

<font style="color:rgb(51, 51, 51);">做逐字节对比</font>

    - <font style="color:rgb(51, 51, 51);">✅</font><font style="color:rgb(51, 51, 51);"> 一致：继续下一步</font>
    - <font style="color:rgb(51, 51, 51);">❌</font><font style="color:rgb(51, 51, 51);"> 不一致：直接报错断开</font>
    - <font style="color:rgb(51, 51, 51);">第一次连接：显示公钥的 SHA256 指纹，手动确认后将完整公钥写入</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">known_hosts</font>`

#### <font style="color:rgb(51, 51, 51);">步骤 4：协商临时会话密钥（混合加密核心）</font>
+ <font style="color:rgb(51, 51, 51);">客户端生成一个</font>**<font style="color:rgb(51, 51, 51);">完全随机的预主密钥</font>**<font style="color:rgb(51, 51, 51);"> （随机 </font>**<font style="color:rgb(51, 51, 51);">32 字节 / 48 字节 串</font>**<font style="color:rgb(51, 51, 51);"> ）</font>
+ <font style="color:rgb(51, 51, 51);">客户端用</font>**<font style="color:rgb(51, 51, 51);">刚才收到的服务器主机公钥</font>**<font style="color:rgb(51, 51, 51);">加密这个预主密钥，发送给服务器</font>
+ <font style="color:rgb(51, 51, 51);">服务器用自己的</font>**<font style="color:rgb(51, 51, 51);">主机私钥</font>**<font style="color:rgb(51, 51, 51);">解密，得到相同的预主密钥</font>
+ <font style="color:rgb(51, 51, 51);">双方用预主密钥，通过相同的算法，各自独立计算出</font>**<font style="color:rgb(51, 51, 51);">同一个临时会话密钥</font>**
    - <font style="color:rgb(51, 51, 51);">什么算法？ 核心派生函数：KDF 密钥派生</font>

<font style="color:rgb(51, 51, 51);">会话密钥 = KDF(预主密钥 + 客户端随机数 + 服务端随机数 + SHA256哈希)</font>

+ <font style="color:rgb(51, 51, 51);">预主密钥立即销毁，会话密钥</font>**<font style="color:rgb(51, 51, 51);">只存在于双方内存中</font>**<font style="color:rgb(51, 51, 51);">，不写硬盘</font>

#### <font style="color:rgb(51, 51, 51);">步骤 5：加密通道正式建立</font>
+ <font style="color:rgb(51, 51, 51);">双方互相发送一个 "加密通道已建立" 的消息</font>
+ **<font style="color:rgb(51, 51, 51);">从这一刻起，后续所有数据（包括用户认证、命令、返回结果）全部用这个会话密钥做 AES 对称加密传输</font>**

---

### <font style="color:rgb(51, 51, 51);">第二阶段：用户身份认证（免密登录核心）</font>
**<font style="color:rgb(51, 51, 51);">此时所有数据已经是加密传输</font>**<font style="color:rgb(51, 51, 51);">，这一阶段才是免密登录的核心，使用</font>**<font style="color:rgb(51, 51, 51);">用户个人密钥对</font>**<font style="color:rgb(51, 51, 51);">。</font>

#### <font style="color:rgb(51, 51, 51);">步骤 1：客户端发起公钥认证请求 （默认的先公钥认证）</font>
<font style="color:rgb(51, 51, 51);">客户端向服务器发送：</font>

<font style="color:rgb(119, 119, 119);">我是用户 xxx，我想用公钥认证方式登录，我的公钥类型是 ed25519</font>

#### <font style="color:rgb(51, 51, 51);">步骤 2：服务器生成随机挑战串</font>
<font style="color:rgb(51, 51, 51);">服务器生成一个</font>**<font style="color:rgb(51, 51, 51);">完全随机的挑战字符串</font>**<font style="color:rgb(51, 51, 51);">，用</font>**<font style="color:rgb(51, 51, 51);">会话密钥加密</font>**<font style="color:rgb(51, 51, 51);">后发送给客户端。</font>

#### <font style="color:rgb(51, 51, 51);">步骤 3：客户端用私钥本地签名</font>
+ <font style="color:rgb(51, 51, 51);">客户端收到加密的挑战串，用</font>**<font style="color:rgb(51, 51, 51);">会话密钥解密</font>**<font style="color:rgb(51, 51, 51);">得到明文挑战串</font>
+ <font style="color:rgb(51, 51, 51);">客户端用</font>**<font style="color:rgb(51, 51, 51);">自己本地的私钥</font>**<font style="color:rgb(51, 51, 51);">对挑战串做</font>**<font style="color:rgb(51, 51, 51);">数字签名</font>**
+ **<font style="color:rgb(51, 51, 51);">私钥永远不离开客户端，只在本地做运算</font>**

#### <font style="color:rgb(51, 51, 51);">步骤 4：服务器用客户端公钥验签</font>
+ <font style="color:rgb(51, 51, 51);">客户端将</font>**<font style="color:rgb(51, 51, 51);">签名结果</font>**<font style="color:rgb(51, 51, 51);">用会话密钥加密后发送给服务器</font>
+ <font style="color:rgb(51, 51, 51);">服务器解密得到签名，从</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh/authorized_keys</font>`<font style="color:rgb(51, 51, 51);">中取出对应的客户端公钥</font>
+ <font style="color:rgb(51, 51, 51);">服务器用客户端公钥验证签名的合法性</font>
    - <font style="color:rgb(51, 51, 51);">✅</font><font style="color:rgb(51, 51, 51);"> 验签成功：证明客户端持有对应的私钥，身份合法，直接允许登录</font>
    - <font style="color:rgb(51, 51, 51);">❌</font><font style="color:rgb(51, 51, 51);"> 验签失败：拒绝登录，回退到密码认证方式</font>

### <font style="color:rgb(51, 51, 51);">最后：建立 SSH 会话</font>
1. <font style="color:rgb(51, 51, 51);">服务器分配伪终端，启动用户的默认 Shell</font>
2. <font style="color:rgb(51, 51, 51);">客户端发送终端类型、窗口大小等信息</font>
3. <font style="color:rgb(51, 51, 51);">双方进入交互模式：你输入的命令、服务器返回的结果，全部通过会话密钥 AES 加密传输</font>

---

## <font style="color:rgb(51, 51, 51);">极简时序图</font>


![](img/SSH%20%E6%A0%B8%E5%BF%83%E7%9F%A5%E8%AF%86-06.png)

```plain
【阶段1 纯明文通道 还没任何加密】
1. 客户端 ↔ 服务器 ：TCP 三次握手 建连

2. 客户端 → 服务器 ：明文发 SSH 版本号
   服务器 → 客户端 ：明文回 SSH 版本号

3. 算法协商 + 互发随机数（关键一步）
   客户端：本地生成 客户端随机数 Client-Rand
   服务器：本地生成 服务端随机数 Server-Rand
   客户端 ↔ 服务器 ：【明文互换】两个随机数
   同时双方明文交换：加密/签名/哈希算法列表，协商好统一算法

4. 服务器 → 客户端 ：**明文发送 服务器主机公钥**

5. 客户端本地校验
   比对 ~/.ssh/known_hosts 里的服务器公钥
   - 无记录：弹SHA256指纹 → yes 存入 known_hosts
   - 有记录且一致：放行继续
   - 有记录但不一致：直接报错断开

6. 客户端 本地生成 预主密钥（一大串随机串）
   客户端 → 服务器：用【服务器主机公钥】加密预主密钥 发送
   服务器 本地用【主机私钥】解密，拿到相同预主密钥

【阶段2 派生最终AES会话密钥】
7. 两端材料齐全，各自独立计算：
   材料 = 预主密钥 + Client-Rand + Server-Rand
   算法 = SHA256 密钥派生
   两边算出**同一套 AES 对称会话密钥**

8. 至此：**AES加密通道正式建立**
   后面所有传输 全部走 AES 加密，不再明文

【阶段3 加密通道内：免密登录认证】
9. 服务器 → 客户端：加密发 随机挑战串
10. 客户端：本地用**自己用户私钥** 对挑战串签名（私钥绝不外传）
11. 客户端 → 服务器：加密发送 签名结果
12. 服务器拿 authorized_keys 里的客户端公钥 验签
    验签通过 → 免密登录成功

【阶段4 正常交互】
13. 进入Shell，所有命令、返回结果 全用AES会话密钥加密传输
14. 断开连接：内存清空会话密钥，下次重连全部重新随机来一遍
```

**<font style="color:rgb(51, 51, 51);">关键要点一眼记死</font>**

1. **<font style="color:rgb(51, 51, 51);">客户端 / 服务端随机数</font>**<font style="color:rgb(51, 51, 51);">：在</font>**<font style="color:rgb(51, 51, 51);">算法协商阶段就明文互换</font>**<font style="color:rgb(51, 51, 51);">，最早就发了</font>
2. <font style="color:rgb(51, 51, 51);">前 6 步全是</font>**<font style="color:rgb(51, 51, 51);">明文</font>**<font style="color:rgb(51, 51, 51);">，没任何加密通道</font>
3. <font style="color:rgb(51, 51, 51);">随机数、主机公钥、算法列表 全是明文随便看，不怕抓包</font>
4. <font style="color:rgb(51, 51, 51);">只把「预主密钥」用服务器公钥加密传，防中间人偷看</font>
5. <font style="color:rgb(51, 51, 51);">用 预主密钥 + 两个随机数 + SHA256 算出 AES 会话密钥</font>
6. <font style="color:rgb(51, 51, 51);">从第 8 步之后，</font>**<font style="color:rgb(51, 51, 51);">全程 AES 加密</font>**<font style="color:rgb(51, 51, 51);">，挑战串、签名、命令全在加密通道里跑</font>
7. <font style="color:rgb(51, 51, 51);">两套密钥互不干扰：</font>
    - <font style="color:rgb(51, 51, 51);">服务器主机密钥：做身份校验、协商密钥用</font>
    - <font style="color:rgb(51, 51, 51);">客户端用户密钥：做免密登录签名用</font>

<font style="color:rgb(51, 51, 51);"></font>

<font style="color:rgb(51, 51, 51);"></font>

<font style="color:rgb(51, 51, 51);"></font>

<font style="color:rgb(51, 51, 51);"></font>

<font style="color:rgb(51, 51, 51);">扩展</font>

```plain
签名 = 用本地私钥，对服务器随机串做专属数学运算，生成一段防伪码；
网络只传「随机串 + 防伪码」，不传私钥；
服务器用配对公钥做反向校验，对上就免密登录，
```

**<font style="color:rgb(51, 51, 51);">密钥认证配置步骤</font>**<font style="color:rgb(51, 51, 51);">（必须会写）：</font>

```plain
# 客户端生成密钥对（一路回车）
ssh-keygen -t ed25519  # 推荐，比rsa更安全更快
# 把公钥上传到服务端
ssh-copy-id user@remote-ip
# 测试免密登录
ssh user@remote-ip
```

---

## <font style="color:rgb(51, 51, 51);">二、常用操作与参数（工作必用，面试常考）</font>
### <font style="color:rgb(51, 51, 51);">1. 基础登录命令</font>
```plain
ssh user@remote-ip  # 默认22端口
ssh -p 2222 user@remote-ip  # 指定端口
ssh -i /path/to/private_key user@remote-ip  # 指定私钥文件
ssh -v user@remote-ip  # 调试模式，排查连接问题（非常重要）
```

### <font style="color:rgb(51, 51, 51);">2. 高频实用参数</font>
+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">-N</font>`<font style="color:rgb(51, 51, 51);">：不执行远程命令，只建立连接（专用于端口转发）</font>
+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">-f</font>`<font style="color:rgb(51, 51, 51);">：后台运行</font>
+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">-T</font>`<font style="color:rgb(51, 51, 51);">：不分配伪终端</font>
+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">-X</font>`<font style="color:rgb(51, 51, 51);">：启用 X11 转发（远程运行图形程序）</font>
+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">-o StrictHostKeyChecking=no</font>`<font style="color:rgb(51, 51, 51);">：自动接受主机公钥（脚本中常用）</font>

### <font style="color:rgb(51, 51, 51);">3. 衍生工具</font>
<font style="color:rgb(51, 51, 51);">scp</font>

<font style="color:rgb(51, 51, 51);">：基于 SSH 的文件传输</font>

```plain
scp local-file user@remote:/path/  # 本地上传到远程
scp user@remote:/path/file local-path/  # 远程下载到本地
```

+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">sftp</font>`<font style="color:rgb(51, 51, 51);">：交互式文件传输，比 scp 更安全，支持断点续传</font>

---

## <font style="color:rgb(51, 51, 51);">三、高级功能（区分初中级运维，面试重点）</font>
### <font style="color:rgb(51, 51, 51);">1. SSH 端口转发（隧道）（</font>**<font style="color:rgb(51, 51, 51);">超高频考点</font>**<font style="color:rgb(51, 51, 51);">）</font>
<font style="color:rgb(51, 51, 51);">核心作用：</font>**<font style="color:rgb(51, 51, 51);">加密不安全的流量、穿透内网、访问受限资源</font>**

#### <font style="color:rgb(51, 51, 51);">（1）本地转发（最常用）</font>
+ <font style="color:rgb(51, 51, 51);">作用：把本地端口的流量转发到远程服务器的指定端口</font>
+ <font style="color:rgb(51, 51, 51);">命令：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ssh -L 本地端口:目标地址:目标端口 user@跳板机</font>`
+ <font style="color:rgb(51, 51, 51);">场景：本地无法直接访问远程服务器的 3306 端口，通过跳板机访问</font>

```plain
ssh -L 3306:192.168.1.100:3306 user@jump-server-ip
# 本地访问127.0.0.1:3306 就等于访问192.168.1.100:3306

ssh -fN -L 3306:10.0.0.2:3306 root@10.0.0.4
```

#### <font style="color:rgb(51, 51, 51);">（2）远程转发</font>
+ <font style="color:rgb(51, 51, 51);">作用：把远程服务器的端口流量转发到本地的指定端口</font>
+ <font style="color:rgb(51, 51, 51);">命令：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ssh -R 远程端口:本地地址:本地端口 user@公网服务器</font>`
+ <font style="color:rgb(51, 51, 51);">场景：内网机器没有公网 IP，让公网用户访问内网的 Web 服务</font>

```plain
ssh -R 8080:127.0.0.1:80 user@public-server-ip
# 访问公网服务器的8080端口 就等于访问内网机器的80端口
```

#### <font style="color:rgb(51, 51, 51);">（3）动态转发（SOCKS 代理）</font>
+ <font style="color:rgb(51, 51, 51);">作用：把本地作为 SOCKS5 代理，所有流量通过 SSH 隧道转发</font>
+ <font style="color:rgb(51, 51, 51);">命令：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ssh -D 本地代理端口 user@远程服务器</font>`
+ <font style="color:rgb(51, 51, 51);">场景：科学上网、访问公司内网资源</font>

```plain
ssh -D 1080 user@remote-ip
# 浏览器设置SOCKS5代理为127.0.0.1:1080即可


# 后台运行 Socks5 代理  # 隧道后台运行，不占用终端、不登录 Shell
ssh -fNT -D 1080 user@跳板IP
```

### <font style="color:rgb(51, 51, 51);">2. 跳板机登录</font>
<font style="color:rgb(51, 51, 51);">旧方法（ProxyCommand）：</font>

+ <font style="color:rgb(51, 51, 51);">ssh -o ProxyCommand="ssh -W %h:%p user@jump-server" user@target-server</font>
+ <font style="color:rgb(51, 51, 51);">新方法（SSH 7.3+，推荐）：</font>

```plain
ssh -J user@jump-server user@target-server

#ssh -J 支持多节点链式跳板
ssh -J 跳板1,跳板2,跳板3 最终目标机器
# 黑客反追踪、躲溯源 主流操作方式（原理科普）
链路模板：
自己真实机子 → 国内跳板 → 海外跳板 1 → 海外跳板 2 → 攻击目标

方式 2：不登录 Shell，只用 Socks5 多层代理隧道
        # 格式：ssh -D 本地端口 跳板机用户@跳板机IP
                ssh -fN -D 127.0.0.1:1080 root@10.0.0.4
        -D 127.0.0.1:1080：在你本地电脑的 1080 端口，开一个 Socks5 代理服务
        这个代理的所有流量，都会通过 SSH 加密隧道，转发到 10.0.0.4 这台跳板机，再从跳板机的公网发出去
        执行完这条命令，你本地的 1080 端口就有了一个可用的 Socks5 代理
        全程你不会进入跳板机的 Shell，只是后台跑了个 SSH 隧道进程
        怎么使用这个代理？
        你本地的浏览器、curl、ssh 这些工具，都可以配置走这个代理：
        # 比如：用curl测试，看出口IP是不是跳板机的
        curl --socks5 127.0.0.1:1080 ip.gs
        
方式 3：大量抓「肉鸡集群」随机轮换跳板
方式 4：全程不用自己真实宽带 IP
        先用 海外匿名 VPS、动态拨号云、虚拟机、境外代理 做第一层出口
方式 5：每台跳板必清理日志、抹痕迹
        清空 SSH 登录日志、系统安全日志
        删除 history 命令历史
        篡改登录时间、伪造异常用户
        让运维就算看服务器日志，也看不到真实登录记录。
 方式 6：用完即毁跳板节点
        临时租用 / 攻破的跳板，攻击完直接重装系统、关机、废弃
```

### <font style="color:rgb(51, 51, 51);">3. SSH 代理转发</font>
+ <font style="color:rgb(51, 51, 51);">作用：不用把私钥复制到跳板机，就能用本地私钥登录跳板机后面的服务器</font>
+ <font style="color:rgb(51, 51, 51);">用法：</font>

```plain
ssh-add  # 把私钥添加到本地ssh-agent
ssh -A user@jump-server  # 启用代理转发
# 在跳板机上直接登录目标服务器，无需输入密码
ssh user@target-server
```

### <font style="color:rgb(51, 51, 51);">2、会话管理（解决断连、重复输密码）</font>
#### <font style="color:rgb(51, 51, 51);">1. 连接复用（一次登录，永久复用）</font>
**<font style="color:rgb(51, 51, 51);">第一次输密码 / 验证密钥，后续连接秒连，不用重复验证</font>**

<font style="color:rgb(51, 51, 51);">在本地 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh/config</font>`<font style="color:rgb(51, 51, 51);"> 写入：</font>

```plain
Host *   #Host：指定对哪些服务器生效
  ControlMaster auto   #  连接复用总开关
  ControlPath ~/.ssh/%h_%p_%r.sock   #指定连接复用的通道文件（socket）
  ControlPersist 1h   # 退出了 SSH 终端，主连接也不会立刻关闭 会在后台保持 1 小时
  ControlPersist yes  #永久不超时  #两边电脑只要不重启，不停止sshd程序
```

<font style="color:rgb(51, 51, 51);">✅</font><font style="color:rgb(51, 51, 51);"> 用途：批量操作服务器，秒连无延迟</font>

#### <font style="color:rgb(51, 51, 51);">2. 强制伪终端（</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">-t</font>`<font style="color:rgb(51, 51, 51);">）</font>
**<font style="color:rgb(51, 51, 51);">远程执行交互式命令（top/vim/sudo）</font>**

```plain
ssh -t user@IP "top"

# 远程执行交互命令（top/vim/sudo） → 必须加 -t
```

<font style="color:rgb(51, 51, 51);">✅</font><font style="color:rgb(51, 51, 51);"> 用途：远程运行需要交互的程序</font>

---

## <font style="color:rgb(51, 51, 51);">三、远程批量执行（运维自动化）</font>
### <font style="color:rgb(51, 51, 51);">8. 远程直接执行命令 / 脚本</font>
**<font style="color:rgb(51, 51, 51);">不用登录，单命令远程干活</font>**

```plain
# 执行单命令
ssh user@IP "ls -l /root"
# 执行本地脚本
ssh user@IP < test.sh
# 批量执行（多台服务器）
for ip in 10.0.0.1 10.0.0.2; do ssh user@$ip "reboot"; done
```

<font style="color:rgb(51, 51, 51);">✅</font><font style="color:rgb(51, 51, 51);"> 用途：批量运维、自动化脚本</font>

---

## <font style="color:rgb(51, 51, 51);">四、配置文件与安全加固（</font>**<font style="color:rgb(51, 51, 51);">面试必问</font>**<font style="color:rgb(51, 51, 51);">）</font>
### <font style="color:rgb(51, 51, 51);">1. 核心配置文件</font>
+ <font style="color:rgb(51, 51, 51);">服务端配置：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">/etc/ssh/sshd_config</font>`<font style="color:rgb(51, 51, 51);">（修改后需重启 sshd 服务）</font>
+ <font style="color:rgb(51, 51, 51);">客户端配置：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">/etc/ssh/ssh_config</font>`<font style="color:rgb(51, 51, 51);">（全局）、</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh/config</font>`<font style="color:rgb(51, 51, 51);">（用户级）</font>

### <font style="color:rgb(51, 51, 51);">2. 服务端关键配置项（安全加固核心）</font>
```plain
Port 2222  # 1. 修改默认端口（减少暴力破解）
PermitRootLogin no  # 2. 禁止root直接登录（生产环境必须）
PasswordAuthentication no  # 3. 关闭密码认证，只允许密钥认证
PubkeyAuthentication yes  # 4. 启用密钥认证

AllowUsers alice bob  # 5. 只允许指定用户登录（白名单，最安全）
# DenyUsers eviluser  # 黑名单
ClientAliveInterval 300  # 6. 300秒无操作自动断开
ClientAliveCountMax 2
MaxAuthTries 3  # 7. 最多3次密码尝试
PermitEmptyPasswords no  # 8. 禁止空密码登录
UseDNS no  # 9. 关闭DNS解析，加快登录速度


ssh远程服务访问控制手段
	1. 更改ssh服务远程登陆端口（一般）
  2. 更改ssh服务监听本地内网ip（不重要）
  3. 更改ssh服务禁止root管理员登陆（重要）
  4. 更改ssh服务密码登陆认证为密钥登陆（重要）
  5. 重要服务器不使用公网ip地址（重要）
  6. 使用防火墙限制来源ip地址（一般）
```

### <font style="color:rgb(51, 51, 51);">3. 其他安全措施</font>
+ <font style="color:rgb(51, 51, 51);">使用</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">fail2ban</font>`<font style="color:rgb(51, 51, 51);">工具自动封禁暴力破解的 IP</font>
+ <font style="color:rgb(51, 51, 51);">定期检查</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">/var/log/secure</font>`<font style="color:rgb(51, 51, 51);">（CentOS）或</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">/var/log/auth.log</font>`<font style="color:rgb(51, 51, 51);">（Ubuntu）的登录日志</font>
+ <font style="color:rgb(51, 51, 51);">禁用 SSH1 协议，只使用 SSH2</font>
    - <font style="color:rgb(51, 51, 51);">定期轮换密钥，使用强密码保护私钥</font>

---

## <font style="color:rgb(51, 51, 51);">五、常见故障排查（面试常考实际问题）</font>
1. **<font style="color:rgb(51, 51, 51);">连接超时</font>**<font style="color:rgb(51, 51, 51);">：检查防火墙（iptables/firewalld/ufw）是否开放 22 端口、云服务器安全组、网络连通性</font>
2. **<font style="color:rgb(51, 51, 51);">连接被拒绝</font>**<font style="color:rgb(51, 51, 51);">：sshd 服务未启动、端口错误、SELinux 阻止</font>
3. <font style="color:rgb(51, 51, 51);">权限错误（最常见）：</font>
    - `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh</font>`<font style="color:rgb(51, 51, 51);">目录权限必须是</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">700</font>`
    - `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh/authorized_keys</font>`<font style="color:rgb(51, 51, 51);">文件权限必须是</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">600</font>`
    - <font style="color:rgb(51, 51, 51);">私钥文件权限必须是</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">600</font>`
4. **<font style="color:rgb(51, 51, 51);">Host key verification failed</font>**<font style="color:rgb(51, 51, 51);">：远程服务器公钥变更，删除本地</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">~/.ssh/known_hosts</font>`<font style="color:rgb(51, 51, 51);">中对应的条目</font>
5. **<font style="color:rgb(51, 51, 51);">免密登录不生效</font>**<font style="color:rgb(51, 51, 51);">：检查上述权限问题、公钥是否正确上传、sshd 配置是否允许密钥认证</font>

---

## <font style="color:rgb(51, 51, 51);">六、面试 TOP10 高频问题</font>
1. <font style="color:rgb(51, 51, 51);">SSH 的工作原理是什么？加密过程是怎样的？</font>

```plain
工作原理
先版本协商 → 协商加密算法 → 密钥交换生成临时会话密钥 → 身份认证 → 加密传输数据。
加密流程
先用非对称加密协商出统一的随机会话密钥；再用对称加密传输业务数据；最后用哈希算法校验数据完整性，防篡改。
```

2. <font style="color:rgb(51, 51, 51);">密码认证和密钥认证的区别？为什么密钥认证更安全？</font>

```plain
区别
密码认证：输账号密码登录
密钥认证：本地公私钥配对校验，不用输密码
密钥更安全原因
密码容易被暴力破解、中间人劫持窃听；密钥私钥只在本地不传输，无法爆破，中间人也破解不了。
```

3. <font style="color:rgb(51, 51, 51);">如何配置 SSH 免密登录？详细步骤</font>

```plain
本地 ssh-keygen 生成公私钥
把本地公钥传到目标机 ~/.ssh/authorized_keys
目标机权限设：.ssh目录700，authorized_keys文件600
客户端直接 ssh 登录，免密
```

4. <font style="color:rgb(51, 51, 51);">什么是 SSH 端口转发？本地转发、远程转发、动态转发的区别和应用场景？</font>

```plain
本地转发 -L：在本机监听端口，把请求转发到跳板机后方的内网服务，用于本机访问远端内网资源。 →场景：本地无法直接访问远程服务器的 3306 端口，通过跳板机访问
ssh -L 3306:192.168.1.100:3306 user@jump-server-ip
# 本地访问127.0.0.1:3306 就等于访问192.168.1.100:3306

ssh -fN -L 3306:10.0.0.2:3306 root@10.0.0.4
远程转发 -R：在远程服务器监听端口，把外网请求反向转发到本地内网 →  场景：内网穿透，外网访问家里 / 
        ssh -R 8080:127.0.0.1:80 user@public-server-ip
        # 访问公网服务器的8080端口 就等于访问内网机器的80端口

动态转发 -D：本地生成 Socks5 全局代理 → 场景：走跳板上网、隐藏真实 IP
```

5. <font style="color:rgb(51, 51, 51);">生产环境如何加固 SSH 服务？至少说出 5 点</font>

```plain
修改默认 22 端口
禁止 root 直接登录
关闭密码登录，只允许密钥登录
限制指定用户才能登录
配置空闲会话自动断开
防火墙只放行固定 IP 连接 SSH
```

6. <font style="color:rgb(51, 51, 51);">SSH 连接失败的常见原因有哪些？如何排查？</font>

```plain
常见原因
网络不通、端口不通、防火墙拦截、密钥 / 密码错误、.ssh权限过大、known_hosts指纹冲突、sshd 服务异常、账号锁定。

排查
ping 测网络 → telnet 测端口 → ssh -v 调试 → 检查文件权限 → 清理冲突的 known_hosts → 查看 sshd 日志。
```

7. <font style="color:rgb(51, 51, 51);">为什么.ssh 目录和 authorized_keys 的权限必须是 700 和 600？</font>

```plain
SSH 安全机制不允许权限过宽；
防止服务器上其他普通用户读取、篡改你的密钥和授权文件，避免被盗用免密、恶意登录、提权。权限不对直接免密失效。
```

8. <font style="color:rgb(51, 51, 51);">known_hosts 文件的作用是什么？</font>

```plain
首次连接自动保存服务器公钥指纹；
下次登录自动比对指纹，防止中间人伪装服务器劫持、骗密码。
```

9. <font style="color:rgb(51, 51, 51);">如何通过跳板机登录内网服务器？有几种方法？</font>

```plain
普通登录：先 ssh 进跳板机，再从跳板机 ssh 内网机器
命令跳板：ssh -J 跳板机 内网目标机
配置 ~/.ssh/config 写好跳板，直接别名一键登录
```

10. <font style="color:rgb(51, 51, 51);">scp 和 rsync 的区别？什么时候用哪个？</font>

```plain
区别
scp：全量覆盖拷贝，简单粗暴，不支持增量
rsync：增量同步、只传变化部分，支持断点续传、压缩、保留文件权限属性
使用场景
临时少量小文件拷贝用 scp；
大文件、定时备份、增量同步、服务器间同步数据用 rsync。
```

# <font style="color:rgb(51, 51, 51);">（了解即可）进阶：多层 Socks5 代理隧道（串多台跳板）</font>
<font style="color:rgb(51, 51, 51);">本机→跳板 1→跳板 2→跳板 3→目标，全程不登录任何一台的 Shell。</font>

## <font style="color:rgb(51, 51, 51);">核心工具：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">proxychains4</font>`
<font style="color:rgb(51, 51, 51);">这是一个专门用来把多个代理串起来的工具，它可以让你的命令，按顺序走你配置的多层代理，不用你手动搭一堆端口转发。</font>

---

## <font style="color:rgb(51, 51, 51);">详细步骤（可直接操作，合法用途）</font>
### <font style="color:rgb(51, 51, 51);">1. 先安装依赖（环境重置后，重新装）</font>
```plain
# 安装proxychains4，用来串多层代理
sudo apt update && sudo apt install -y proxychains4
```

### <font style="color:rgb(51, 51, 51);">2. 配置多层代理</font>
<font style="color:rgb(51, 51, 51);">编辑配置文件：</font>

sudo vim /etc/proxychains4.conf

<font style="color:rgb(51, 51, 51);">找到 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">[ProxyList]</font>`<font style="color:rgb(51, 51, 51);"> 这一段，把你的跳板按</font>**<font style="color:rgb(51, 51, 51);">从近到远</font>**<font style="color:rgb(51, 51, 51);">的顺序写进去：</font>

```plain
[ProxyList]
# 格式：代理类型  代理IP  代理端口
# 顺序：你本机 → 第一个代理 → 第二个代理 → 第三个代理...
socks5  127.0.0.1  1080  # 第一层：你本地搭的到跳板1的Socks5
socks5  127.0.0.1  1081  # 第二层：跳板1上搭的到跳板2的Socks5
socks5  127.0.0.1  1082  # 第三层：跳板2上搭的到跳板3的Socks5
```

<font style="color:rgb(119, 119, 119);">简单说：每一层的代理，都是上一层机器上开的本地端口，流量就这么一层一层串过去。</font>

---

### <font style="color:rgb(51, 51, 51);">3. 逐层搭 SSH 动态代理</font>
#### <font style="color:rgb(51, 51, 51);">第一步：在你本机，搭到跳板 1 的代理</font>
```plain
# 本机执行：开1080端口，连跳板1
ssh -D 127.0.0.1:1080 root@跳板1的IP
```

#### <font style="color:rgb(51, 51, 51);">第二步：通过跳板 1 的代理，在跳板 1 上搭到跳板 2 的代理</font>
```plain
# 本机执行，用proxychains走第一层代理，去连跳板2
proxychains4 ssh -D 127.0.0.1:1081 root@跳板2的IP
```

<font style="color:rgb(51, 51, 51);">这一步，相当于在跳板 1 的本地，开了个 1081 端口，连到跳板 2。</font>

#### <font style="color:rgb(51, 51, 51);">第三步：同理，搭到跳板 3 的代理</font>
```plain
# 本机执行，走前两层代理，去连跳板3
proxychains4 ssh -D 127.0.0.1:1082 root@跳板3的IP
```

---

### <font style="color:rgb(51, 51, 51);">4. 用多层代理访问目标</font>
<font style="color:rgb(51, 51, 51);">现在所有代理都搭好了，你直接用 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">proxychains4</font>`<font style="color:rgb(51, 51, 51);"> 跑任何命令，流量都会自动走三层跳板：</font>

```plain
# 测试：看最终出口IP，是不是最后一台跳板3的IP
proxychains4 curl ip.gs

# 直接用这个代理，SSH连最终目标机器
proxychains4 ssh root@最终目标的IP
```







