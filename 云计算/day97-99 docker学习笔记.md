# 1：什么是容器？
容器就是在隔离的环境运行的一个进程，如果进程停止，容器就会销毁。隔离的环境拥有自己的文件系统，ip地址，主机名等



什么是进程？

进程==正在运行的程序



# 2：容器和虚拟化的区别
linux容器技术，容器虚拟化和kvm虚拟化的区别

**kvm虚拟化**： 需要硬件的支持，需要模拟硬件，可以运行不同的操作系统，启动时间分钟级(开机启动流程)

linux开机启动流程

bios开机硬件自检

根据bios设置的优先启动项

读取mbr引导 (0磁道0扇区0柱面 前446字节)

加载内核

启动第一个进程 （centos6/sbin/init; centos7 /systemd）

。。。



**容器虚拟化**：不需要硬件的支持。不需要模拟硬件，共用宿主机的内核，启动时间秒级(没有开机启动流程)

总结：容器和虚拟化的优缺点：

容器：性能好，启动快，轻量， 只能运行在linux上

虚拟机： 性能损耗多，启动慢，重量，能够运行多个操作系统平台。



# 3:容器技术的发展过程：
### 1）chroot技术，新建一个子系统
参考资料：https://www.ibm.com/developerworks/cn/linux/l-cn-chroot/

chang root

```bash
chroot /opt/ubuntu
export PATH=$PATH:/bin:/sbin
apt-get install -y apache2

```



作业1：使用chroot监狱限制SSH用户访问指定目录和使用指定命令

https://linux.cn/article-8313-1.html



### 2）linux容器(lxc)  
linux container (namespaces 命名空间提供隔离环境 及 cgroups 限制一个进程能使用的的计算资源 )

lxc是最接近虚拟机的容器技术。

```bash
ifconfig
route -n
brctl show
brctl --help
brctl delif vibr0 eth0
brctl delbr vibr0
systemctl restart network
brctl show

```



```bash
#安装epel源
yum install epel-release -y

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

##安装lxc
yum install lxc-* -y
yum install libcgroup* -y
yum install bridge-utils -y

###桥接网卡
echo 'TYPE=Ethernet
BOOTPROTO=none
NAME=eth0
DEVICE=eth0
ONBOOT=yes
BRIDGE=virbr0' >/etc/sysconfig/network-scripts/ifcfg-eth0

echo 'TYPE=Bridge
BOOTPROTO=static
NAME=virbr0
DEVICE=virbr0
ONBOOT=yes
IPADDR=10.0.0.11
NETMASK=255.255.255.0
GATEWAY=10.0.0.254
DNS1=114.114.114.114' >/etc/sysconfig/network-scripts/ifcfg-virbr0

systemctl restart network

#lxc默认配置文件
cat /etc/lxc/default.conf  

##启动cgroup
systemctl start cgconfig.service
##启动lxc
systemctl start lxc.service

#创建lxc容器
方法1:
lxc-create -t download -n mycontainer -- --server mirrors.tuna.tsinghua.edu.cn/lxc-images 
lxc-create -t download -n centos7 -- --server mirrors.tuna.tsinghua.edu.cn/lxc-images -d centos -r 7 -a amd64
方法2：
lxc-create -t centos -n test

####为lxc容器设置root密码：
chroot /var/lib/lxc/centos7/rootfs  passwd

##为容器指定ip和网关
vi /var/lib/lxc/centos7/config
lxc.network.name = eth0
lxc.network.ipv4 = 10.0.0.111/24
lxc.network.ipv4.gateway = 10.0.0.254

##启动容器 加-d 放入后台
lxc-start -d -n centos7
键入<Ctrl+a q>组合键，退出控制台。

# 查看容器列表状态
lxc-ls --fancy

# 想停止和销毁容器
lxc-stop -n centos7
lxc-destroy -n centos7

# lxc自带模板
ls /usr/share/lxc/templates/
#使用模板创建容器
lxc-create -n mycentos7 -t centos

```



## 3:docker容器 ****	
Docker是通过内核虚拟化技术（namespaces及cgroups cpu、内存、磁盘io等）

namespaces来提供容器的资源隔离与cgroups做资源限制等。

由于Docker通过操作系统层的虚拟化实现隔离，所以Docker容器在运行时，不需要类似虚拟机（VM）额外的操作系统开销，提高资源利用率。



进程，占用资源过多，oom=out of memory

容器编排工具， k8s，保证容器高可用



docker的主要目标是"Build,Ship and Run any App,Anywhere",构建，运输，处处运行

docker是一种软件的打包技术



构建：做一个docker镜像

运输：docker pull

运行：启动一个容器

每一个容器，他都有自己的系统文件rootfs.



kvm解决了硬件和操作系统之间的依赖

kvm独立的虚拟磁盘，xml配置文件



## 4：docker的安装
```bash
# https://docs.docker.com/engine/install/centos/
sudo yum install -y yum-utils
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
#安装docker 社区版
yum install docker-ce docker-ce-cli containerd.io

-----------------------------------------------------------以上官方源下载非常慢--------推荐下面阿里源下载docker-ce
# https://developer.aliyun.com/mirror/docker-ce
# step 1: 安装必要的一些系统工具
yum install -y yum-utils device-mapper-persistent-data lvm2
# Step 2: 添加软件源信息
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3
sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
# Step 4: 更新并安装Docker-CE
yum makecache fast
yum -y install docker-ce
# Step 4: 开启Docker服务
service docker start

#启动并加入开机自启动
systemctl enable docker
systemctl start docker


--------------------扩展安装指定版本docker
#安装yum仓库管理工具
yum install -y yum-utils
#安装阿里云docker仓库
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#查看docker各个版本
yum list docker-ce --showduplicates |sort -r
#安装指定版本
yum install docker-ce-17.09.0.ce -y


```

## 5:docker的主要组成部分
docker是传统的CS架构分为docker client和docker server, 向mysql一样

```bash
# docker version  版本
[root@docker yum.repos.d]# docker version
Client: Docker Engine - Community
 Version:           26.1.4
 API version:       1.45
 Go version:        go1.21.11
 Git commit:        5650f9b
 Built:             Wed Jun  5 11:32:04 2024
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          26.1.4
  API version:      1.45 (minimum version 1.24)
  Go version:       go1.21.11
  Git commit:       de5c9cf
  Built:            Wed Jun  5 11:31:02 2024
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.33
  GitCommit:        d2d58213f83a351ca8f528a95fbd145f5654e957
 runc:
  Version:          1.1.12
  GitCommit:        v1.1.12-0-g51d5e94
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

```

docker主要组件有：镜像、容器、 仓库 存储卷、  网络

启动容器必须需要一个镜像，仓库中只存储镜像

容器---镜像---仓库



安装Nginx步骤：

官网下载Nginx源码包

wget  

tar

创建Nginx用户



编译安装

一 ./configure配置  

二 make 编译  

三 make install 安装

修改配置文件，

启动



## 6：启动第一个容器
```bash
## https://cloud.tencent.com/developer/article/2434428
# https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors  #失效了 
#配置docker镜像加速  
# https://github.com/DaoCloud/public-image-mirror
# https://dockerpull.com/
# https://console.huaweicloud.com/swr    #容器镜像中心->镜像加速器
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://dockerproxy.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://docker.nju.edu.cn",
        "https://t5whu3di.mirror.aliyuncs.com"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

docker run -d -p 80:80 nginx
run（创建并运行一个容器）
-d 放在后台
-p 端口映射
nginx # docker镜像的名字

# 一个学习资料镜像仓库
docker run --name reference -d -p 9667:3000 wcjiang/reference:latest

```



## 7：docker的镜像管理
```bash
#搜索镜像
docker search 镜像名
选镜像的建议：
1，优先考虑官方
2，starts数量多
#获取镜像
docker pull（push）
	
镜像加速器：阿里云加速器，daocloud加速器，中科大加速器，
	Docker 中国官方镜像加速：https://registry.docker-cn.com
	daocloud 加速器  （这个是临时的，要登陆账号查看，每隔一段时间就会换地址）
{
 "registry-mirrors": ["http://f1361db2.m.daocloud.io"]
}

docker pull centos:6.8（没有指定版本，默认会下载最新版）
docker pull daocloud.io/huangzhichong/alpine-cn:latest   （私有镜像地址）
docker pull alpine

##配置docker镜像加速
vi /etc/docker/daemon.json
{
 "registry-mirrors": ["https://registry.docker-cn.com"]
}	

阿里云的镜像加速器
https://cr.console.aliyun.com/cn-qingdao/mirrors
登陆 选择镜像加速器
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://t5whu3di.mirror.aliyuncs.com"]
}
EOF

##第三方docker镜像仓库，使用方法：
docker pull index.tenxcloud.com/tenxcloud/httpd:latest
	
查看镜像
docker images ls
删除镜像
docker rmi   例子：docker image rmi centos:latest
导出镜像
docker save  例子：docker image save centos > docker-centos7.4.tar.gz
导入镜像
docker load  例子：docker image load -i docker-centos7.4.tar.gz

```

## 8：docker的容器管理
```bash
docker run -d -p 80:80 nginx:latest
run（创建并运行一个容器）
-d 放在后台
-p 端口映射
-v  源地址(宿主机):目标地址(容器)
nginx docker镜像的名字

#启动容器并且进入容器
docker run -it --name centos6 centos:6.9 /bin/bash
  -it   分配交互式的终端
  --name 指定容器的名字
  /bin/sh覆盖容器的初始命令
启动容器
docker run image_name
docker run -it image_name CMD
	
启动容器放入后台运行
docker run -it -d centos:6.9

停止容器
docker stop CONTAINER_ID
启动容器
docker start CONTAINER_ID 或者names
杀死容器
docker kill container_name
查看容器列表
  docker ps
	docker ps –a
	docker ps –-no-trunc ##查看完整id 命令
  
 进入容器(目的，调试，排错)
***	docker exec  （会分配一个新的终端tty）
		docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
    docker exec -it  容器id或容器名字 /bin/bash
    
docker attach（使用同一个终端）
		docker attach [OPTIONS] CONTAINER
	  nsenter (安装yum install -y util-linux  弃用)
    
[root@docker01 ~]# docker run -it centos:6.9  #启动并进入容器
[root@408f4ffe5916 /]# ps –ef                 # 这是容器里的操作
[root@408f4ffe5916 /]# [root@docker01 ~]#    ctrl+p，ctrl+q  临时退出容器x`
[root@docker01 ~]# docker attach 408f4ffe5916    # 再次进入容器（使用同一个终端）
[root@408f4ffe5916 /]# exit                   # 退出 但是容器已死

#（运行，新的终端）
docker run -it nginx:latest /bin/bash    
# 运行nginx容器 起个名字nginx  -d后台运行
docker run -it -d --name nginx nginx:latest

#进入nginx容器
docker exec -it nginx /bin/bash

root@53e0ff5e059f:/# hostname
53e0ff5e059f
root@53e0ff5e059f:/# exit   //退出


tail –F  大写F 会一直等待文件出现
docker run -d centos:6.9 tail -F /var/log/memages

删除容器
	docker rm
批量删除容器
  docker rm -f `docker ps -a -q`
	
总结：docker容器内的第一个进程必须一直处于前台运行的状态（必须夯住），否则这个容器，就会处于退出状态！
docker run –d centos:6.9 /bin/bash /init.sh
# cat /init.sh
/etc/init.d/sshd start
tail –F /var/log/sdsdsd.log
```



## 9：docker容器的网络访问
端口映射原理图

![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-01.png)

**BusyBox 是一个集成了一百多个最常用linux命令和工具的软件**

```bash
[root@docker01 ~]# docker run -it busybox
route -n
ip addr
ping 10.0.0.12

#12主机抓取ping的包 （这里ping的来源显示是10.0.0.11，容器和宿主机是做了一层nat地址转换）
tcpdump -i eth0 icmp -nn

#11主机过滤出内核转发参数
[root@docker01 ~]# sysctl -a|grep ipv4|grep forward
net.ipv4.ip_forward = 1
#临时将内核转发参数设置为0 ， 11将ping不同12主机
[root@docker01 ~]# sysctl net.ipv4.ip_forward=0
net.ipv4.ip_forward = 0


#查看iptable规则 nat转发规则
[root@docker01 ~]# iptables -t nat -L -n
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  0.0.0.0/0            0.0.0.0/0

指定映射(docker 会自动添加一条iptables规则来实现端口映射)
	-p hostPort:containerPort
	-p ip:hostPort:containerPort
	-p ip::containerPort(随机端口)
	-p hostPort:containerPort:udp
	-p 81:80 –p 443:443 可以指定多个-p
随机映射
	docker run -P （随机端口）
  
通过iptables来实现的端口映射
-p hostPort:containerPort
#容器做端口映射启动80:80  -d后台  （浏览器访问宿主机10.0.0.11:80端口就可以访问nginx）
docker run -d -p 80:80 nginx:latest

#再次启动nginx 使用宿主机81端口映射容器里80端口 （浏览器访问10.0.0.11:81端口）
docker run -d -p 81:80 nginx:latest
-p ip:hostPort:containerPort
#添加一个ip
[root@docker01 ~]# ifconfig eth0:1 10.0.0.100/24 up
[root@docker01 ~]# ifcibfig |grep -A 2 eth0
#不同的ip对应80端口
[root@docker01 ~]# docker run -d -p 10.0.0.100:80:80 nginx:latest
[root@docker01 ~]# docker run -d -p 10.0.0.11:80:80 nginx:latest

-p ip::containerPort(随机端口)
docker run -d -p 10.0.0.100::80 nginx:latest

域名解析使用的是udp协议
ping www.baidu.com
# 另一个窗口抓去upd数据
tcpdump -i eth0 upd -nn

-p 81:80 –p 443:443 可以指定多个-p
docker run --name jms_all -d -p 80:80 -p 2222:2222 jumpserver/jms_all:latest

扩展
docker network ls
docker network --help
```

## 10：docker的数据卷管理
```bash
docker volume create oldboy   #创建卷
docker volume ls              #查看卷列表
docker volume inspect oldboy   #查看卷属性  包含存储的位置

/usr/share/nginx/html
数据卷(文件或目录)
	-v oldboy:/data
	-v src（宿主机的目录）:dst（容器的目录）
# -v 把oldboy卷挂到 容器的/ usr/share/nginx/html
# docker run -d -p 80:80 -v oldboy:/usr/share/nginx/html nginx:latest
cd /var/lib/docker/volumes/oldboy/_data   # cd到容器的位置
ls   # 查看文件就是nginx的代码目录
echo 'oldboy' >index.html    # 替换内容浏览器访问测试

#将宿主机目录挂载到容器中
[root@docker01 opt]# ls /opt/xiaoniao/   //宿主机的xiaoniao代码
2000.png  21.js  icon.png  img  index.html  sound1.mp3  xiaoniaofeifei.zip
# 将宿主机/opt/xiaoniao 挂载到容器/usr/share/nginx/html
docker run -d -v /opt/xiaoniao:/usr/share/nginx/html -p 80:80 nginx:latest

```



第一种：把容器里面的文件，拷贝到卷中

第二种：把宿主机的目录挂载到容器的目录中





### 练习题：
基于nginx启动一个容器，监听80和81，访问80，出现nginx默认首页，访问81，出现小鸟。

```bash
-p 80:80 –p 81:81
-v nginx配置文件 –v xiaoniao:/容器
#进入到nginx容器 查看nginx配置文件
[root@docker01 opt]# docker ps    //查看正在运行的容器
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
ea201b85e7b2        nginx:latest        "nginx -g 'daemon of…"   6 minutes ago       Up 6 minutes        0.0.0.0:80->80/tcp   gracious_gates
[root@docker01 opt]# docker exec -it gracious_gates /bin/bash   //进入容器
root@ea201b85e7b2:/# nginx -v
nginx version: nginx/1.15.7
root@ea201b85e7b2:/# nginx –V  //查看环境变量
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log
root@ea201b85e7b2:/# cat /etc/nginx/nginx.conf

#拷贝容器的nginx配置文件到宿主机当前目录下 gracious_gates容器名字  .表示当前目录
[root@docker01 ~]# docker container cp  gracious_gates:/etc/nginx/conf.d/default.conf .
#过滤注释和空行查看nginx配置文件
egrep -v "$|#" default.conf

#定向向一个文件
egrep -v "^$|#" default.conf >xiaoniao.conf
[root@docker01 ~]# cat /opt/xiaoniao/xiaoniao.conf   //修改配置文件
server {
   listen       81;
   server_name  localhost;
   location / {
       root   /opt;
       index  index.html index.htm;
   }
   error_page   500 502 503 504  /50x.html;
   location = /50x.html {
       root   /usr/share/nginx/html;
   }
}
server {
   listen       80;
   server_name  localhost;
   location / {
       root   /usr/share/nginx/html;
       index  index.html index.htm;
   }
   error_page   500 502 503 504  /50x.html;
   location = /50x.html {
       root   /usr/share/nginx/html;
   }
}

docker run -d -p 80:80 -p 81:81 -v /opt/xiaoniao/xiaoniao.conf:/etc/nginx/conf.d/xiaoniao.conf -v /opt/xiaoniao:/opt nginx:latest

```



## 11：手动将容器保存为镜像
docker commit 容器id或者容器的名字   新的镜像名字[:版本号可选]



手工制作docker镜像



```bash
a: 手动启动一个容器，再容器中安装你的服务
docker run -it -p 2222:22 centos:6.9
#安装openssh-server
/etc/init.d/sshd start
echo '123456' |passwd --stdin root

b：docker commit 把容器提交为镜像
docker container commit 5ada2d44dd46 centos6.9_ssh:v1.1

c:  测试镜像的功能。
docker run -d -p 2223:22 centos6.9_ssh:v1.1 /usr/sbin/sshd -D

```





```bash
#启动centos6.9容器
docker run –it –p 2222:22 centos:6.9

#yum源安装
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo

#安装ssh服务
yum install openssh-server –y

#启动ssh服务
[root@645827e841d0 /]# /etc/init.d/sshd start

[root@645827e841d0 /]# echo 123456|passwd --stdin root  //设置root用户密码

#ssh 测试登陆  
#使用ctrp+p +ctrl +q 临时退出 ，将当前运行的容器提交成镜像
docker container commit 6c04f6467086 centos6.9_ssh:v1.1

docker images

#测试运行
# 这个启动测试 启动就停止了，没有夯住
docker run -it -p 222:22 centos6.9_ssh:v1.1 /etc/init.d/sshd start  
# 启动命令 –D 亢住
docker run -d -p 222:22 centos6.9_ssh:v1.1 /usr/sbin/sshd -D



1）：基于容器制作镜像
docker run -it centos:6.9
######
yum install httpd
yum install openssh-server
/etc/init.d/sshd start
vi /init.sh
#!/bin/bash
/etc/init.d/httpd start
/usr/sbin/sshd -D
chmod +x /init.sh
2）将容器提交为镜像
docker commit oldboy centos6-ssh-httpd:v1
3）测试镜像功能是否可用
```



晚上作业

kodexplorer  可道云的网盘

先在普通的主机上把它跑起来，然后再容器中跑起来。

php项目

nginx+php  fastcgi

httpd+php  php5.so



```bash
# https://kodcloud.com/download/
# echo '192.168.21.200 mirrors.aliyun.com' >>/etc/hosts
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum install php php-cli unzip php-gd php-mbstring -y
cd /var/www/html/
curl -o kodexplorer4.37.zip  http://192.168.21.200/kodexplorer4.37.zip
unzip kodexplorer4.37.zip
chmod -R 777 /var/www/html/
/etc/init.d/httpd restart
#启动脚本
[root@82a62ba90a1d /]# cat init.sh
#!/bin/bash
/etc/init.d/httpd start
tail -F /var/log/httpd/access_log

#提交成镜像
[root@docker01 ~]# docker commit 82a62ba90a1d kod:v1.1
#启动容器
[root@docker01 ~]# docker run -d -p 80:80 kod:v1.1 /bin/bash /init.sh

```



查看官方docker镜像的版本

https://hub.docker.com/r/library/



## 12：dockerfile自动构建docker镜像
```bash
dockerfile 更适合传输，实现更多的定制化
dockerfile主要组成部分：
	基础镜像信息       FROM centos:6.8
	制作镜像操作指令   RUN yum install openssh-server -y
	容器启动时执行指令 CMD ["/bin/bash"]
dockerfile常用指令：
	FROM 这个镜像的妈妈是谁？（指定基础镜像）
	MAINTAINER 告诉别人，谁负责养它？（指定维护者信息，可以没有）
	RUN 你想让它干啥（在命令前面加上RUN即可）
	ADD 给它点创业资金（COPY文件，会自动解压）
	WORKDIR 我是cd,今天刚化了妆（设置当前工作目录）
	VOLUME 给它一个存放行李的地方（设置卷，挂载主机目录）
	EXPOSE 它要打开的门是啥（指定对外的端口）(-P 随机端口)
	CMD 奔跑吧，兄弟！（指定容器启动后的要干的事情）（容易被替换）
	
dockerfile其他指令：	
	COPY 复制文件
	ENV  环境变量
	ENTRYPOINT  容器启动后执行的命令（无法被替换，启容器的时候指定的命令，会被当成参数）



面试题： cmd 和 entrypoint 什么区别
RUN、CMD 和 ENTRYPOINT 这三个 Dockerfile 指令看上去很类似，很容易混淆。本节将通过实践详细讨论它们的区别。
简单的说：
RUN 执行命令并创建新的镜像层，RUN 经常用于安装软件包。
CMD 设置容器启动后默认执行的命令及其参数，但 CMD 能够被 docker run 后面跟的命令行参数替换。
ENTRYPOINT 配置容器启动时运行的命令。(如果你希望你的docker镜像只执行一个具体程序, 不希望用户在执行docker run的时候随意覆盖默认程序. 建议用ENTRYPOINT.)

参考其他的dockerfile
https://docs.docker.com/samples/library/redis/
官方dockerfile或者时速云镜像广场
```



```bash
[root@docker01 centos_ssh]# pwd
/opt/dockerfile/centos_ssh
#dockerfile 开头字母大写或者小写都可以
[root@docker01 centos_ssh]# vim dockerfile
[root@docker01 centos_ssh]# mv dockerfile Dockerfile
#编写dockerfile 脚本
[root@docker01 centos_ssh]# vim Dockerfile
FROM centos:6.9
RUN yum install openssh-server -y
RUN /etc/init.d/sshd start
RUN echo '123456' |passwd --stdin root
CMD ["/usr/sbin/sshd","-D"]

#自动构建
[root@docker01 centos_ssh]# docker image build -t centos6.9_ssh:v2.1 /opt/dockerfile/centos_ssh
#启动测试
docker run -d -p 222:22 centos6.9_ssh:v2.1

```





如果有多个服务启动



```bash
[root@docker01 dockerfile]# cp -a centos_ssh centos_ssh_httpd
[root@docker01 dockerfile]# cd centos_ssh_httpd/
# vim Dockerfile

FROM centos:6.9
RUN yum install openssh-server httpd -y
RUN /etc/init.d/sshd start
RUN echo '123456' |passwd --stdin root
ADD init.sh /init.sh
CMD ["/bin/bash","/init.sh"]

[root@docker01 centos_ssh_httpd]# cat init.sh
#!/bin/bash
/etc/init.d/httpd start
/usr/sbin/sshd -D

# 构建
docker build -t centos6.9_ssh_http:v2.1 .

#启动测试
docker run -d -p 222:22 -p 88:80 centos6.9_ssh_http:v2.1
```



![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-02.png)







```bash
[root@docker01 kod]# pwd
/opt/dockerfile/kod
[root@docker01 kod]# ls
Dockerfile  init.sh  kodexplorer4.37.zip

# cat Dockerfile
FROM centos:6.9
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo && \
    yum install php php-cli unzip php-gd php-mbstring wget httpd -y && \
    wget -O /kod.zip http://static.kodcloud.com/update/download/kodexplorer4.37.zip  && \
	unzip *.zip -d /var/www/html && \
	chmod -R 777 /var/www/html && \
	rm -rf /*.zip
COPY init.sh /
CMD ["/bin/bash","/init.sh"]


# cat init.sh
#!/bin/bash
/etc/init.d/httpd start
tail -F /var/log/httpd/access_log
#/usr/sbin/sshd -D

# docker build -t kod:v2.1 .
```



## 13：docker镜像的分层（kvm 链接克隆，写时复制的特性）
+ **<font style="color:rgb(20, 21, 26);">分层</font>**<font style="color:rgb(20, 21, 26);">：Docker 镜像由多个只读层组成，每一层对应 Dockerfile 中的一个指令。</font>
+ **<font style="color:rgb(20, 21, 26);">写时复制</font>**<font style="color:rgb(20, 21, 26);">：容器运行时，对镜像层的修改会应用到一个可写的容器层上，而不会影响原始的镜像层。</font>
+ <font style="color:rgb(20, 21, 26);">分层的好处：重复利用，节约资源。</font>

## ![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-03.jpeg)![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-04.png)






小结：

![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-05.jpeg)

## 14:.容器间的互联（--link 是单方向的！！！）
如果不暴露端口能不能访问 （外界访问不了，宿主机可以访问）

```bash
docker run -d -it centos
docker ps -a
# -l 是显示最新的创建的容器  --no-trunc 完整显示全部id
docker ps -a -l

#查看容器的属性过滤出ip地址
docker inspect container-id |grep -i "ip"

#测试ping 容器ip
 ping 172.17.0.3

----------------------------------------------------------
# link 链接启动容器
docker run -d kod:v2.1
docker run -d --name kod kod:v2.1
docker ps -a -l

# --link 容器id或者容器名:alias
docker run -it --link kod:kod busybox:latest
ping kod
---------------------------------------------------------------
#容器里的hosts是自动加上去的。
cat /etc/hosts
....
172.17.0.6 kod container-id
172.17.0.7 container-id

docker run -d -p --name nginx 80:80 nginx
docker run -it --link nginx:web01 busybox:latest
ping web01

# cat /etc/hosts
172.17.0.2 web01 container-id nginx
```



**使用docker运行zabbix-server**

```bash
docker run --name mysql-server -t \
     -e MYSQL_DATABASE="zabbix" \
     -e MYSQL_USER="zabbix" \
     -e MYSQL_PASSWORD="zabbix_pwd" \
     -e MYSQL_ROOT_PASSWORD="root_pwd" \
     -d mysql:5.7 \
     --character-set-server=utf8 --collation-server=utf8_bin
参数说明  --name 容器名字
		     -t 终端的意思（分配一个终端）
         -e 指定环境变量
		     -d   后台启动
		     mysql:5.7 指的是镜像名字
         --character-set-server=utf8 --collation-server=utf8_bin  这个是指容器的初始命令
docker run --name zabbix-java-gateway -t \
       -d zabbix/zabbix-java-gateway:latest
docker run --name zabbix-server-mysql -t \
     -e DB_SERVER_HOST="mysql-server" \       指定数据的地址
     -e MYSQL_DATABASE="zabbix" \
     -e MYSQL_USER="zabbix" \
     -e MYSQL_PASSWORD="zabbix_pwd" \
     -e MYSQL_ROOT_PASSWORD="root_pwd" \
     -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
     --link mysql-server:mysql \                    链接mysql-server主机： 别名
     --link zabbix-java-gateway:zabbix-java-gateway \
     -p 10051:10051 \
     -d zabbix/zabbix-server-mysql:latest
docker run --name zabbix-web-nginx-mysql -t \
     -e DB_SERVER_HOST="mysql-server" \
     -e MYSQL_DATABASE="zabbix" \
     -e MYSQL_USER="zabbix" \
     -e MYSQL_PASSWORD="zabbix_pwd" \
     -e MYSQL_ROOT_PASSWORD="root_pwd" \
     --link mysql-server:mysql \                    链接数据库主机：别名
     --link zabbix-server-mysql:zabbix-server \      
     -p 80:80 \                                  开放宿主机80：映射容器80端口
     -d zabbix/zabbix-web-nginx-mysql:latest        -d后台启动 容器名称
#在线pull 网速慢（提前下载好的上传主机）
[root@docker01 ~]# ll
total 2528904
-rw-r--r--  1 root root  392823296 Sep 23  2016 docker-mysql-5.7.tar.gz
-rw-r--r--  1 root root  153172992 Sep 23  2016 zabbix-java-gateway.tar.gz
-rw-r--r--  1 root root  110936576 Sep 23  2016 zabbix-server-mysql.tar.gz
-rw-r--r--  1 root root  179232768 Sep 23  2016 zabbix-web-nginx-mysql.tar.gz
#导入镜像   然后运行上面的命令
 495  docker load -i zabbix-server-mysql.tar.gz
 496  docker load -i zabbix-web-nginx-mysql.tar.gz
 497  docker load -i zabbix-java-gateway.tar.gz
 498  docker load -i docker-mysql-5.7.tar.gz
 
 #浏览器访问  登陆Admin zabbix
 
 #在客户机装客户端
rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.2/rhel/7/x86_64/zabbix-agent-3.2.11-1.el7.x86_64.rpm
#配置
# vim /etc/zabbix/zabbix_agentd.conf  #配置server服务器
Server=10.0.0.11

# systemctl restart zabbix-agent.service


```



#浏览器配置

![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-06.png)



![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-07.png)





#重启zabbix-server 加快发现客户端速度

docker restart zabbix-server-mysql



#重启完，刷新网页查看



![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-08.png)



docker-zabbix生产中一般不用docker版， 因为功能被精简，不支持微信报警了



## 16：docker registry
```bash
##普通的registry  （安装私有镜像仓库）
docker run -d -p 5000:5000 --restart=always --name registry -v /opt/myregistry:/var/lib/registry  registry
参数说明
  --restart=always  docker重启docker服务同时也启动这个私有仓库容器
  --name 容器的名字
  -v      把宿主机的目录挂载容器里面
    
#上传私有镜像仓库  默认是官方
docker push index.tenxcloud.com/google_containers/busybox

上传到docker镜像到私有仓库
1：10.0.0.11:5000/centos6-sshd:v3(手动给它打tag)
# docker tag alpine 10.0.0.11:5000/alpin
#这两个镜像类似硬链接一样
docker images  查看 IMAGE ID 一样

2：vi /etc/docker/daemon.json  （第一次上传镜像报错：修改配置文件添加安全：私有仓库 ，重启服务）

tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://t5whu3di.mirror.aliyuncs.com"]
   "insecure-registries": ["10.0.0.11:5000"]
}
EOF

-'EOF'-----------分割线


#	或者启动命令后面加上
echo "--insecure-registry 192.168.14.156:5000" >> /etc/sysconfig/docker-network
ps aux |grep dockerd #查看启动命令后面的参数

systemctl restart docker

3.docker push 10.0.0.11:5000/centos6-sshd:v3   推送上传
[root@docker02 ~]# docker push 10.0.0.11:5000/alpin

#上传nginx镜像 导入
docker load -i nginx.tar
# tag
docker tag nginx:latest 10.0.0.11:5000/nginx:latest   
# push
docker push 10.0.0.11:5000/nginx:latest

# 推送的镜像到哪里去了，（查看启动命令 挂载卷的地址 /opt/myregistry:/var/lib/registry  ）

#查看版本
[root@con ~]# ls /opt/myregistry/docker/registry/v2/repositories/alpine/_manifests/tags/
latest

#另一台机器下载镜像 提示报错
[root@docker01 myregistry]# docker pull 10.0.0.11:5000/nginx:latest
Error response from daemon: Get https://10.0.0.11:5000/v2/: http: server gave HTTP response to HTTPS client
#解决报错
#	或者启动命令后面加上
echo "--insecure-registry 192.168.14.156:5000" >> /etc/sysconfig/docker-network
ps aux |grep dockerd #查看启动命令后面的参数
#重启docker服务
systemctl restart docker

#通过浏览器访问仓库镜像列表
http://192.168.14.156:5000/v2/_catalog  
{"repositories":["alepine","alpine","busybox","csphere/busybox"]}


```



## 带basic认证的registry
```bash
yum install httpd-tools -y
mkdir /opt/registry-var/auth/ -p
htpasswd  -Bbn testuser 123456  >> /opt/registry-var/auth/htpasswd

#先停掉registry 运行的容器 再运行上面的命名启动registry
docker rm -f `docker ps -a -q`

#启动 带认证镜像仓库
docker run -d -p 5000:5000 -v /opt/registry-var/auth/:/auth/ -v /opt/myregistry:/var/lib/registry \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd registry

# docker push会报错 http: server gave HTTP response to HTTPS client
# 解决
sed -i '2s/$/,/' /etc/docker/daemon.json
sed -i '2a"insecure-registries": ["10.0.0.2:5000"]' /etc/docker/daemon.json
service docker restart

docker pull nginx
docker tag nginx:latest 10.0.0.2:5000/nginx:latest
[root@docker ~]# docker login 10.0.0.2:5000
Username: testuser
Password:
docker push 10.0.0.2:5000/nginx:latest

# 另一台docker客户端下载镜像
sed -i '2s/$/,/' /etc/docker/daemon.json
sed -i '2a"insecure-registries": ["10.0.0.2:5000"]' /etc/docker/daemon.json
service docker restart
docker login 10.0.0.2:5000  #登陆再下载
docker pull 10.0.0.2:5000/nginx


删除镜像
1）进入docker registry的容器中
docker exec -it registry /bin/sh
2) 删除repo
rm -fr /var/lib/registry/docker/registry/v2/repositories/nginx


/var/lib/registry/docker/registry/v2 # du -smh /var/lib/registry/docker/registry/v2/blobs/sha256
3.4M	/var/lib/registry/docker/registry/v2/blobs/sha256
/var/lib/registry/docker/registry/v2 # du -smh /var/lib/registry/docker/registry/v2/repositories
40.0K	/var/lib/registry/docker/registry/v2/repositories

3) 清楚掉blob  执行垃圾回收命令
/var/lib/registry/docker/registry/v2 # registry garbage-collect /etc/docker/registry/config.yml

# 查看文件变小了
/var/lib/registry/docker/registry/v2 # du -smh /var/lib/registry/docker/registry/v2/blobs/sha256
2.7M	/var/lib/registry/docker/registry/v2/blobs/sha256


```





小结回顾：

容器有关的操作

创建并启动一个容器 docker run =docker create + docker start

进入容器docker exec

查看容器的列表 docker ps –a

停止一个容器  docker stop

强制停止容器  docker kill

重启容器 docker restart

删除一个容器  docker rm

把容器提交为镜像 docker commit

在容器和宿主机直接拷贝文件 docker cp

查看容器终端的输出

docker ps –a –l  显示最近的一条容器

docker inspect |grep –i “ip”  查看容器信息 过滤ip信息

docker logs –f     实时查看容器终端输出信息



仓库：



volume:

network:



制作docker镜像

脚本制作docker



通过变量生成dockerfile文件

dockerfile指令

FORM

RUN

ADD

COPY  把宿主机的文件拷贝到容器中， 带解压功能

CMD  指定容器运行时的初始命令

EXPOSE  暴露端口，运行容器使用随机端口映射

WORKDIR  指定容器的工作目录

VOLUME /data

ENV   环境变量，灵活定制容器

ENTRYPOINT   容器启动后执行的命令（无法被替换，启容器的时候指定的命令，会被当成参数）



## 17:docker-compose(单机版的容器编排工具)




```bash
# yum install epel-release 
yum install -y python2-pip（需要epel源）
pip install docker-compose
##pip 加速
##详细指令
http://www.jianshu.com/p/2217cfed29d7

# 安装好检查
[root@docker01 ~]# docker-compose -v
docker-compose version 1.23.2, build 1110ad0
# 1.从github上下载docker-compose二进制文件安装
# 下载最新版的docker-compose文件 
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

# 若是github访问太慢，可以用daocloud下载
sudo curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

# 添加可执行权限 
sudo chmod +x /usr/local/bin/docker-compose
 
————————————————
版权声明：本文为CSDN博主「pushiqiang」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/pushiqiang/article/details/78682323
```







```bash
mkdir /opt/my_wordpress ;cd /opt/my_wordpress
# vi docker-compose.yaml
version: '3'
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    volumes:
      - web_data:/var/www/html
    ports:
      - "80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
volumes:
   db_data:
   web_data:
   
   
#启动
docker-compose up
#后台启动
docker-compose up -d
```





#测试负载均衡

```bash
yum install nginx -y

# cat /etc/nginx/nginx.conf
worker_processes  1;
events {
   worker_connections  1024;
}
http {
   include       mime.types;
   default_type  application/octet-stream;
   sendfile        on;
   keepalive_timeout  65;
   upstream wordpress {
       server 10.0.0.11:32769;
       server 10.0.0.11:32768;
       server 10.0.0.11:32770;
   }
   server {
       listen       80;
       server_name  localhost;
       location / {
       proxy_pass http://wordpress;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       #proxy_set_header X-Forwarded-For $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       }
   }
}

systemctl restart nginx

[root@docker01 _data]# pwd
/var/lib/docker/volumes/opt_web_data/_data
[root@docker01 _data]# echo '<?php phpinfo();'>phpinfo.php
```



刷新访问 phpinfo页面查看ip地址变化

![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-09.png)







### 调试方法
```bash
# 二进制直接使用  应对很多容器内置的命令太少问题
wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
chmod +x busybox-x86_64
./busybox-x86_64 netstat -lntup

---------------------------------------------------------- 以下常用 推荐
docker run -d -p80:80 --name nginx  nginx
docker inspect nginx|grep Pid |awk  'NR==1{print $2}' #拿到Pid
[root@m01 ~]# nsenter -t 88444 -n ifconfig    #进入Pid的网络命名空间查看 ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.2  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:ac:11:00:02  txqueuelen 0  (Ethernet)
        RX packets 8  bytes 656 (656.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)

[root@m01 ~]# docker exec -it nginx /bin/bash   
root@224d1953a44e:/# ifconfig   #容器内部没有这个命令
bash: ifconfig: command not found



```





## 18：重启docker服务，容器全部退出的解决办法
```bash
方法一：docker run  --restart=always

方法二："live-restore": true
docker server配置文件/etc/docker/daemon.json参考
{
"registry-mirrors": ["http://b7a9017d.m.daocloud.io"],
"graph": "/opt/mydocker",  #存储镜像、容器数据的位置。
"insecure-registries":["10.0.0.11:5000"],
"live-restore":true     #****
}
```

## 20：Docker网络类型
None：不为容器配置任何网络功能，--net=none

Container：与另一个运行中的容器共享Network Namespace，--net=container:containerID

Host：与主机共享Network Namespace，--net=host

Bridge：Docker设计的NAT网络模型

```bash
[root@con ~]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
33050c85fa1f        bridge              bridge              local
dd15cea9228b        host                host                local
ca69393334bf        none                null                local

[root@con ~]# docker run -it -d --name bus  --network none busybox:latest
[root@con ~]# docker exec bus ifconfig
[root@con ~]# docker exec bus hostname
[root@con ~]# docker inspect bus |grep IP

# 默认启动时桥接网络类型
docker run -d busybox
docker ps -a -l    #查看容器id 23d2
# 两个容器共用一个网络ip地址一样  不能使用共同端口
docker run -it --network container:23d2 busybox
# host网络类型  与宿主机共用网络
[root@con ~]# docker run -it --network host busybox /bin/sh
```



## 21：Docker跨主机通信之macvlan
虚拟多个max地址， 虚拟多个网卡



优点： 性能好，与局域网的其他服务器处于同一个网段

缺点： 每次都需要手动指定ip地址  与自己宿主机ping不通

```bash
##再两台机器都创建macvlan网络
docker network create --driver macvlan --subnet 10.0.0.0/24 --gateway 10.0.0.254 -o parent=eth0 macvlan_1
##设置eth0的网卡为混杂模式
ip link set eth0 promisc on

## 第一台机器创建使用macvlan网络的容器
docker run --name busybox1 -dit --network macvlan_1 --ip=10.0.0.200 busybox:latest /bin/sh

## 第二台机器创建使用macvlan网络的容器
docker run --name busybox2 -dit --network macvlan_1 --ip=10.0.0.201 busybox:latest /bin/sh

## 容器1 ping 容器2 ip
[root@con ~]# docker exec busybox1 ping 10.0.0.201


```



作业2：用PIPEWORK为docker容器配置独立IP

```bash
# 安装pipework
wget https://github.com/jpetazzo/pipework/archive/master.zip
unzip master.zip 
cp pipework-master/pipework  /usr/local/bin/
chmod +x /usr/local/bin/pipework 

#网卡配置
[root@con network-scripts]# cat ifcfg-eth0
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
NAME=eth0
DEVICE=eth0
ONBOOT=yes
BRIDGE="br0"
[root@con network-scripts]# cat ifcfg-br0
TYPE=Bridge
BOOTPROTO=static
IPADDR=192.168.14.156
NETMASK=255.255.252.0
GATEWAY=192.168.12.1
PREFIX=22
DNS1=114.114.114.114
NAME=br0
ONBOOT=yes
DEVICE=br0

#运行容器
docker run -d -it --name busybox1 busybox /bin/sh
#为容器指定ip   重启容器后需要重新指定ipb
pipework br0 busybox1 192.168.14.30/22@192.168.12.1

```



## 22：Dcoker跨主机通信之overlay
![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-10.png)

http://www.cnblogs.com/CloudMan6/p/7270551.html

1）准备工作

```bash

# docker01上启动consul服务，实现网路统一配置管理
docker run -d -p 8500:8500 -h consul --name consul --restart=always progrium/consul -server -bootstrap
参数说明  
 -h 指定容器的主机名
 -name  容器名字
 -restart=always   # docker重启容器也启动
  progrium/consul  # 这个是镜像
 -server -bootstrap  #传递给容器内的 Consul 服务的参数，指示它以服务器模式运行并进行引导（bootstrap）操作，通常用于初始化一个新的 Consul 集群。

# 配置文件 docker02、03上：
vim  /etc/docker/daemon.json

{
  "registry-mirrors": ["https://registry.docker-cn.com"],
  "insecure-registries": ["10.0.0.11:5000"],
  "live-restore": true,
  "hosts":["tcp://0.0.0.0:2376","unix:///var/run/docker.sock"],
  "cluster-store": "consul://192.168.14.156:8500",
  "cluster-advertise": "192.168.14.156:2376"
}

------------------------------这是在原有内容上追加的
"hosts":["tcp://0.0.0.0:2376","unix:///var/run/docker.sock"],  #最新的19.03加到service 配置文件 -H tcp://0.0.0.0:2376
"live-restore": true,
"cluster-store": "consul://192.168.14.156:8500",        #consul服务的IP地址
"cluster-advertise": "192.168.14.156:2376"              #这里的ip地址修改成本机器IP地址
-----------------------------------------------

#配置或者是修改启动配置文件
[root@client1 ~]# cat /lib/systemd/system/docker.service | grep "ExecStart=/usr/bin/dockerd"
ExecStart=/usr/bin/dockerd  -H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --cluster-store=consul://192.168.6.134:8500 --cluster-advertise=ens33:2376 --insecure-registry=0.0.0.0/0

[root@client2~]# cat /lib/systemd/system/docker.service | grep "ExecStart=/usr/bin/dockerd"
ExecStart=/usr/bin/dockerd  -H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --cluster-store=consul://192.168.6.135:8500 --cluster-advertise=ens33:2376 --insecure-registry=0.0.0.0/0



# 启动progrium/consul 镜像
docker run -d -p 8500:8500 -h consul --name consul --restart=always progrium/consul -server –bootstrap
参数 –h 指定容器的主机名
    -name  容器名字      
     consul |key values 数据类型
     
2）创建overlay网络
docker network create -d overlay --subnet 172.16.1.0/24 --gateway 172.16.1.254 ol1

两台机器上 docker network ls 都能看到name ol1的overlay网络类型

3）启动容器测试
docker run -it --network ol1 --name oldboy01  busybox:latest /bin/sh

docker run -it --network ol1 --name oldboy02  busybox:latest /bin/sh

overlay网络，需要2块网卡，一块网卡上外网，一块网卡实现容器间的通信


```





浏览器访问 查看所有节点

![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-11.png)





## 




## 23：docker企业级镜像仓库harbor
```bash
https://github.com/goharbor/harbor/blob/master/docs/installation_guide.md
第一步：安装docker和docker-compose

第二步：下载harbor-offline-installer-v1.3.0.tgz

第三步：上传到/opt,并解压
[root@docker01 opt]# tar xf harbor-offline-installer-v1.5.1.tgz
[root@docker01 opt]# cd harbor
第四步：修改harbor.cfg配置文件
hostname = 10.0.0.11
harbor_admin_password = 123456

第五步：执行./install.sh
```



浏览器登陆查看



![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-12.png)





docker02主机推送镜像

![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-13.png)



#修改配置文件

```bash
vim /etc/docker/daemon.json
[root@docker02 ~]# cat /etc/docker/daemon.json
{
 "registry-mirrors": ["https://registry.docker-cn.com"],
 "insecure-registries": ["10.0.0.11"]
}


systemctl restart docker
docker images
#打标签
docker tag nginx:latest 10.0.0.11/library/nginx:latest
docker images
#登陆
[root@docker02 ~]# docker login 10.0.0.11
Username: admin
Password:
#推送镜像
docker push 10.0.0.11/library/nginx:latest
```



#网页刷新查看

![](img/day97-99%20docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0-14.png)







#有问题启动不了的

 158  cd /opt/harbor/

 164  docker-compose restart



harbor作业： 配置harbor的https



容器集群软件

docker swarm

mesos docker

kubernetes





### ###k8s的安装方法
kubernetes 二进制安装

kubeadm 安装

minikube 安装

yum 安装

go编译安装



### k8s 安装
```bash
1：修改主机和host解析
10.0.0.11  k8s-master  
10.0.0.12  k8s-node-1
10.0.0.13  k8s-node-2
[root@k8s-master ~]# vim /etc/hosts
...
10.0.0.11 k8s-master
10.0.0.12 k8s-node-1
10.0.0.13 k8s-node-2
[root@k8s-master ~]# scp /etc/hosts root@10.0.0.12:/etc/hosts
[root@k8s-master ~]# scp /etc/hosts root@10.0.0.13:/etc/hosts

老版本安装包下载地址
http://vault.centos.org/7.0.1406/extras/x86_64/Packages/
https://vault.centos.org/7.4.1708/extras/x86_64/Packages/

2：所有节点安装docker-1.12.6-68
wget https://vault.centos.org/7.4.1708/extras/x86_64/Packages/docker-common-1.12.6-68.gitec8512b.el7.centos.x86_64.rpm
wget https://vault.centos.org/7.4.1708/extras/x86_64/Packages/docker-client-1.12.6-68.gitec8512b.el7.centos.x86_64.rpm
wget https://vault.centos.org/7.4.1708/extras/x86_64/Packages/docker-1.12.6-68.gitec8512b.el7.centos.x86_64.rpm

yum localinstall docker-common-1.12.6-68.gitec8512b.el7.centos.x86_64.rpm -y
yum localinstall docker-client-1.12.6-68.gitec8512b.el7.centos.x86_64.rpm -y
yum localinstall docker-1.12.6-68.gitec8512b.el7.centos.x86_64.rpm -y



3：master节点安装etcd(k8s数据库kv类型存储) 原生支持做集群
yum install etcd.x86_64 -y
vim /etc/etcd/etcd.conf
第6行：ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
第21行：ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.11:2379"
sed -i '6s#localhost#0.0.0.0#g' /etc/etcd/etcd.conf
sed -i '21s#localhost#0.0.0.0#g' /etc/etcd/etcd.conf
systemctl start etcd.service
systemctl enable etcd.service
#测试
etcdctl set testdir/testkey0 0
etcdctl get testdir/testkey0
#检查etcd健康状态
etcdctl -C http://10.0.0.4:2379 cluster-health

4：master节点安装kubernetes
yum install kubernetes-master.x86_64 -y

vim /etc/kubernetes/apiserver
8行  KUBE_API_ADDRESS="--insecure-bind-address=0.0.0.0"
11行 KUBE_API_PORT="--port=8080"
14行 KUBELET_PORT="--kubelet-port=10250"
17行 KUBE_ETCD_SERVERS="--etcd-servers=http://10.0.0.4:2379"
23行 KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,Resource Quota"


vim /etc/kubernetes/config
22行 KUBE_MASTER="--master=http://10.0.0.4:8080"

systemctl enable kube-apiserver.service
systemctl start kube-apiserver.service
systemctl enable kube-controller-manager.service
systemctl start kube-controller-manager.service
systemctl enable kube-scheduler.service
systemctl start kube-scheduler.service

api-server：接受并响应用户的请求
controller：控制管理器的概念，保证容器存活
schedule：  调度器，选择启动容器的node节点

5：node节点安装kubernetes
yum install kubernetes-node.x86_64 -y
vim /etc/kubernetes/config
22行 KUBE_MASTER="--master=http://10.0.0.4:8080"

vim /etc/kubernetes/kubelet
 5行 KUBELET_ADDRESS="--address=0.0.0.0"
 8行 KUBELET_PORT="--port=10250"
11行 KUBELET_HOSTNAME="--hostname-override=k8s-node-1"    //主机名写本机的
14行 KUBELET_API_SERVER="--api-servers=http://10.0.0.11:8080"

systemctl enable kubelet.service
systemctl start kubelet.service
systemctl enable kube-proxy.service
systemctl start kube-proxy.service


kubelet     调用docker管理容器的生命周期
kube-proxy  提供容器网络访问


#检测 所有节点数
[root@k8s-master ~]# kubectl get nodes
NAME        STATUS    AGE
k8s-node1   Ready     30s
k8s-node2   Ready     23s


6：所有节点配置flannel网络
# 其他网络 https://blog.csdn.net/ganpuzhong42/article/details/77853131?tdsourcetag=s_pctim_aiomsg

yum install flannel -y
sed -i 's#http://127.0.0.1:2379#http://10.0.0.4:2379#g' /etc/sysconfig/flanneld

# master节点
etcdctl mk /atomic.io/network/config '{ "Network": "172.16.0.0/16" }'


#master节点：
systemctl enable flanneld.service
systemctl start flanneld.service
service docker restart
systemctl restart kube-apiserver.service
systemctl restart kube-controller-manager.service
systemctl restart kube-scheduler.service

node节点：
systemctl enable flanneld.service
systemctl start flanneld.service
service docker restart
systemctl restart kubelet.service
systemctl restart kube-proxy.service

```





```bash
# 另一台主机单独装的docker
docker pull busybox
docker images save busybox > busybox.tar.gz
sz busybox.tar.gz

[root@k8s-master ~]# rz -E
rz waiting to receive.

rsync -avz docker_busybox.tar.gz 10.0.0.5:/root
rsync -avz docker_busybox.tar.gz 10.0.0.6:/root

#所有节点都导入 docker_busybox 镜像
docker load -i docker_busybox.tar.gz

docker run -it busybox:latest


# 检测
[root@k8s-node2 ~]# docker run -it busybox:latest
/ # hostname -i
172.16.30.2
[root@k8s-node1 ~]# docker run -it busybox:latest
/ # hostname -i
172.16.47.2

[root@k8s-master ~]# docker run -it busybox:latest
/ # hostname -i
172.16.89.2
/ # ping -c4 172.16.30.2
PING 172.16.30.2 (172.16.30.2): 56 data bytes
64 bytes from 172.16.30.2: seq=0 ttl=60 time=1.248 ms
64 bytes from 172.16.30.2: seq=1 ttl=60 time=0.619 ms
64 bytes from 172.16.30.2: seq=2 ttl=60 time=0.548 ms
64 bytes from 172.16.30.2: seq=3 ttl=60 time=0.543 ms

--- 172.16.30.2 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.543/0.739/1.248 ms
/ # ping -c4 172.16.47.2
PING 172.16.47.2 (172.16.47.2): 56 data bytes
64 bytes from 172.16.47.2: seq=0 ttl=60 time=8.504 ms
64 bytes from 172.16.47.2: seq=1 ttl=60 time=0.675 ms
64 bytes from 172.16.47.2: seq=2 ttl=60 time=0.599 ms
64 bytes from 172.16.47.2: seq=3 ttl=60 time=0.575 ms

--- 172.16.47.2 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.575/2.588/8.504 ms

```







#### 制作一个只支持sshd服务的镜像
```bash
1):启动一个容器，并修改
docker run -it -p 1022:22 centos:7 /bin/bash
# 容器内操作
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
yum install openssh-server -y
echo 'root:123456'|chpasswd
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
chmod 600 /etc/ssh/ssh_host_*_key
/usr/sbin/sshd -D
# /etc/init.d/sshd start  #这是centos6的命令
测试：ssh远程登录

2）：将修改后的容器，保存为镜像
# docker commit friendly_swartz centos6-ssh
docker commit goofy_blackwell centos7-ssh

3）测试新镜像，sshd是否可用
# docker run -d -p 1122:22 centos6-ssh:latest /usr/sbin/sshd -D
# ssh root@10.0.0.11 -p 1122

docker run -d -p 1122:22 centos7-ssh:latest /usr/sbin/sshd -D
docker exec -it 33db0385ee66 /bin/bash  #进入容器查看ip地址
  yum install net-tools -y
  [root@33db0385ee66 /]# hostname -i
  172.16.89.3


# 两种方式都可以连接
[root@k8s-node2 ~]# ssh root@172.16.89.3
[root@k8s-node2 ~]# ssh root@10.0.0.4 -p1122


```





#### 制作了一个支持sshd和httpd双服务的镜像
```bash
1）：启动一个容器，并修改
docker run -d -p 1122:22 centos6-ssh:latest /usr/sbin/sshd -D
yum install httpd -y
/etc/init.d/httpd start

vi /init.sh
#!/bin/bash
/etc/init.d/httpd start
/usr/sbin/sshd -D

chmod +x /init.sh
2）：将修改后的容器，保存为镜像
docker commit 11bf5984784a centos6-httpd

3）测试新镜像，检测sshd和httpd是否可用
docker run -d -p 1222:22 -p 80:80 centos6-httpd:latest /init.sh
```











